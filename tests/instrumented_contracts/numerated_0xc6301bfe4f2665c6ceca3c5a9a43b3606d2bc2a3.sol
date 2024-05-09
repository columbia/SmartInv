1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-11
3 */
4 
5 // SPDX-License-Identifier: UNLICENSED;
6 
7 pragma solidity ^0.8.0;
8 
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     function toString(uint256 value) internal pure returns (string memory) {
13 
14         if (value == 0) {
15             return "0";
16         }
17         uint256 temp = value;
18         uint256 digits;
19         while (temp != 0) {
20             digits++;
21             temp /= 10;
22         }
23         bytes memory buffer = new bytes(digits);
24         while (value != 0) {
25             digits -= 1;
26             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
27             value /= 10;
28         }
29         return string(buffer);
30     }
31 
32     function toHexString(uint256 value) internal pure returns (string memory) {
33         if (value == 0) {
34             return "0x00";
35         }
36         uint256 temp = value;
37         uint256 length = 0;
38         while (temp != 0) {
39             length++;
40             temp >>= 8;
41         }
42         return toHexString(value, length);
43     }
44 
45     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
46         bytes memory buffer = new bytes(2 * length + 2);
47         buffer[0] = "0";
48         buffer[1] = "x";
49         for (uint256 i = 2 * length + 1; i > 1; --i) {
50             buffer[i] = _HEX_SYMBOLS[value & 0xf];
51             value >>= 4;
52         }
53         require(value == 0, "Strings: hex length insufficient");
54         return string(buffer);
55     }
56 }
57 
58 
59 
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view virtual returns (bytes calldata) {
66         return msg.data;
67     }
68 }
69 
70 
71 
72 abstract contract Ownable is Context {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     constructor() {
78         _setOwner(_msgSender());
79     }
80 
81     function owner() public view virtual returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         _setOwner(address(0));
92     }
93 
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _setOwner(newOwner);
97     }
98 
99     function _setOwner(address newOwner) private {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 
108 library Address {
109     function isContract(address account) internal view returns (bool) {
110         uint256 size;
111         assembly {
112             size := extcodesize(account)
113         }
114         return size > 0;
115     }
116 
117     function sendValue(address payable recipient, uint256 amount) internal {
118         require(address(this).balance >= amount, "Address: insufficient balance");
119 
120         (bool success, ) = recipient.call{value: amount}("");
121         require(success, "Address: unable to send value, recipient may have reverted");
122     }
123 
124     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
125         return functionCall(target, data, "Address: low-level call failed");
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
130      * `errorMessage` as a fallback revert reason when `target` reverts.
131      *
132      * _Available since v3.1._
133      */
134     function functionCall(
135         address target,
136         bytes memory data,
137         string memory errorMessage
138     ) internal returns (bytes memory) {
139         return functionCallWithValue(target, data, 0, errorMessage);
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
144      * but also transferring `value` wei to `target`.
145      *
146      * Requirements:
147      *
148      * - the calling contract must have an ETH balance of at least `value`.
149      * - the called Solidity function must be `payable`.
150      *
151      * _Available since v3.1._
152      */
153     function functionCallWithValue(
154         address target,
155         bytes memory data,
156         uint256 value
157     ) internal returns (bytes memory) {
158         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
163      * with `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCallWithValue(
168         address target,
169         bytes memory data,
170         uint256 value,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         require(address(this).balance >= value, "Address: insufficient balance for call");
174         require(isContract(target), "Address: call to non-contract");
175 
176         (bool success, bytes memory returndata) = target.call{value: value}(data);
177         return verifyCallResult(success, returndata, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but performing a static call.
183      *
184      * _Available since v3.3._
185      */
186     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
187         return functionStaticCall(target, data, "Address: low-level static call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
192      * but performing a static call.
193      *
194      * _Available since v3.3._
195      */
196     function functionStaticCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal view returns (bytes memory) {
201         require(isContract(target), "Address: static call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.staticcall(data);
204         return verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but performing a delegate call.
210      *
211      * _Available since v3.4._
212      */
213     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
214         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a delegate call.
220      *
221      * _Available since v3.4._
222      */
223     function functionDelegateCall(
224         address target,
225         bytes memory data,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(isContract(target), "Address: delegate call to non-contract");
229 
230         (bool success, bytes memory returndata) = target.delegatecall(data);
231         return verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     /**
235      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
236      * revert reason using the provided one.
237      *
238      * _Available since v4.3._
239      */
240     function verifyCallResult(
241         bool success,
242         bytes memory returndata,
243         string memory errorMessage
244     ) internal pure returns (bytes memory) {
245         if (success) {
246             return returndata;
247         } else {
248             // Look for revert reason and bubble it up if present
249             if (returndata.length > 0) {
250                 // The easiest way to bubble the revert reason is using memory via assembly
251 
252                 assembly {
253                     let returndata_size := mload(returndata)
254                     revert(add(32, returndata), returndata_size)
255                 }
256             } else {
257                 revert(errorMessage);
258             }
259         }
260     }
261 }
262 
263 
264 
265 interface IERC721Receiver {
266     function onERC721Received(
267         address operator,
268         address from,
269         uint256 tokenId,
270         bytes calldata data
271     ) external returns (bytes4);
272 }
273 
274 
275 
276 interface IERC165 {
277     function supportsInterface(bytes4 interfaceId) external view returns (bool);
278 }
279 
280 
281 
282 abstract contract ERC165 is IERC165 {
283     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
284         return interfaceId == type(IERC165).interfaceId;
285     }
286 }
287 
288 
289 
290 interface IERC721 is IERC165 {
291     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
292     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
293     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
294 
295     function balanceOf(address owner) external view returns (uint256 balance);
296 
297     function ownerOf(uint256 tokenId) external view returns (address owner);
298 
299     function safeTransferFrom(
300         address from,
301         address to,
302         uint256 tokenId
303     ) external;
304 
305     function transferFrom(
306         address from,
307         address to,
308         uint256 tokenId
309     ) external;
310 
311     function approve(address to, uint256 tokenId) external;
312 
313     function getApproved(uint256 tokenId) external view returns (address operator);
314 
315     function setApprovalForAll(address operator, bool _approved) external;
316 
317     function isApprovedForAll(address owner, address operator) external view returns (bool);
318 
319     function safeTransferFrom(
320         address from,
321         address to,
322         uint256 tokenId,
323         bytes calldata data
324     ) external;
325 }
326 
327 
328 
329 interface IERC721Enumerable is IERC721 {
330     function totalSupply() external view returns (uint256);
331 
332     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
333 
334     function tokenByIndex(uint256 index) external view returns (uint256);
335 }
336 
337 
338 
339 interface IERC721Metadata is IERC721 {
340     function name() external view returns (string memory);
341 
342     function symbol() external view returns (string memory);
343 
344     function tokenURI(uint256 tokenId) external view returns (string memory);
345 }
346 
347 
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
406         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
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
432         require(operator != _msgSender(), "ERC721: approve to caller");
433 
434         _operatorApprovals[_msgSender()][operator] = approved;
435         emit ApprovalForAll(_msgSender(), operator, approved);
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
500         _mint(to, tokenId + 1);
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
517     }
518 
519     function _burn(uint256 tokenId) internal virtual {
520         address owner = ERC721.ownerOf(tokenId);
521 
522         _beforeTokenTransfer(owner, address(0), tokenId);
523 
524         // Clear approvals
525         _approve(address(0), tokenId);
526 
527         _balances[owner] -= 1;
528         delete _owners[tokenId];
529 
530         emit Transfer(owner, address(0), tokenId);
531     }
532 
533     function _transfer(
534         address from,
535         address to,
536         uint256 tokenId
537     ) internal virtual {
538         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
539         require(to != address(0), "ERC721: transfer to the zero address");
540 
541         _beforeTokenTransfer(from, to, tokenId);
542 
543         // Clear approvals from the previous owner
544         _approve(address(0), tokenId);
545 
546         _balances[from] -= 1;
547         _balances[to] += 1;
548         _owners[tokenId] = to;
549 
550         emit Transfer(from, to, tokenId);
551     }
552 
553     function _approve(address to, uint256 tokenId) internal virtual {
554         _tokenApprovals[tokenId] = to;
555         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
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
586 }
587 
588 
589 
590 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
591     // Mapping from owner to list of owned token IDs
592     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
593 
594     // Mapping from token ID to index of the owner tokens list
595     mapping(uint256 => uint256) private _ownedTokensIndex;
596 
597     // Array with all token ids, used for enumeration
598     uint256[] private _allTokens;
599 
600     // Mapping from token id to position in the allTokens array
601     mapping(uint256 => uint256) private _allTokensIndex;
602 
603     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
604         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
605     }
606 
607     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
608         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
609         return _ownedTokens[owner][index];
610     }
611 
612     function totalSupply() public view virtual override returns (uint256) {
613         return _allTokens.length;
614     }
615 
616 
617     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
618         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
619         return _allTokens[index];
620     }
621 
622     function _beforeTokenTransfer(
623         address from,
624         address to,
625         uint256 tokenId
626     ) internal virtual override {
627         super._beforeTokenTransfer(from, to, tokenId);
628 
629         if (from == address(0)) {
630             _addTokenToAllTokensEnumeration(tokenId);
631         } else if (from != to) {
632             _removeTokenFromOwnerEnumeration(from, tokenId);
633         }
634         if (to == address(0)) {
635             _removeTokenFromAllTokensEnumeration(tokenId);
636         } else if (to != from) {
637             _addTokenToOwnerEnumeration(to, tokenId);
638         }
639     }
640 
641     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
642         uint256 length = ERC721.balanceOf(to);
643         _ownedTokens[to][length] = tokenId;
644         _ownedTokensIndex[tokenId] = length;
645     }
646 
647     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
648         _allTokensIndex[tokenId] = _allTokens.length;
649         _allTokens.push(tokenId);
650     }
651 
652     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
653         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
654         // then delete the last slot (swap and pop).
655 
656         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
657         uint256 tokenIndex = _ownedTokensIndex[tokenId];
658 
659         // When the token to delete is the last token, the swap operation is unnecessary
660         if (tokenIndex != lastTokenIndex) {
661             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
662 
663             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
664             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
665         }
666 
667         // This also deletes the contents at the last position of the array
668         delete _ownedTokensIndex[tokenId];
669         delete _ownedTokens[from][lastTokenIndex];
670     }
671 
672     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
673         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
674         // then delete the last slot (swap and pop).
675 
676         uint256 lastTokenIndex = _allTokens.length - 1;
677         uint256 tokenIndex = _allTokensIndex[tokenId];
678 
679         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
680         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
681         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
682         uint256 lastTokenId = _allTokens[lastTokenIndex];
683 
684         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
685         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
686 
687         // This also deletes the contents at the last position of the array
688         delete _allTokensIndex[tokenId];
689         _allTokens.pop();
690     }
691 }
692 
693 
694 
695 // a special whitelist that allows you to mint a certain ammount for no cost (just gas)  =>  DONE;
696 //  a "normal" whitelist
697 // presale (for whitelisted) 
698 // Also we want to have a reveal
699 
700 contract MarsPunks is ERC721Enumerable, Ownable {
701 
702     using Strings for uint256;
703 
704     string _baseTokenURI;
705     uint256 public _reserved = 50;
706     uint256 private _price = 0.04 ether;
707     bool public _paused = true;
708     bool public _WLpaused = true;
709     uint256 public limit = 10000;
710     uint256 public maxPerTx = 5;
711     
712     uint256  public WL_limit = 3;
713     mapping(address => bool) public WL; 
714     mapping(address => uint) public WL_Mint;
715     
716     uint256  public SWL_limit = 1;
717     mapping(address => bool) public SWL; 
718     mapping(address => uint) public SWL_Mint; 
719         
720     constructor(string memory baseURI) ERC721("Mars Punks", "MP") {
721         setBaseURI(baseURI);
722         // fundWallet = _fundWallet;
723     }
724 
725     function Mint(uint256 num) public payable {
726         uint256 supply = totalSupply();
727         require( !_paused,                              "Sale paused" );
728         require( num <= maxPerTx,                       "You exceeds mint limit per transaction." );
729         require( supply + num <= limit - _reserved,     "Exceeds maximum punks supply" );
730         require( msg.value >= _price * num,             "Ether sent is not correct" );
731 
732         for(uint256 i; i < num; i++){
733             _safeMint( msg.sender, supply + i );
734         }
735     }
736 
737     function giveAway(address[] memory _to, uint256[] memory _amount) external onlyOwner() {
738         require( _to.length == _amount.length, "Entered data is invalid");
739         for(uint i;  i<_amount.length; i++){
740             minto(_to[i], _amount[i]);
741         }
742     }
743     
744     function minto (address _to, uint256 _amount) private {
745         uint256 supply = totalSupply();
746         require( _to != address(0),    "Invalid address found");
747         require( _amount <= _reserved, "Exceeds reserved punk supply" );
748 
749         for(uint i; i<_amount; i++){
750             _safeMint( _to, supply + i );
751         }
752         _reserved -= _amount;
753     }
754     
755     function WHITELIST_MINT(uint256 num) public payable {
756         uint256 supply = totalSupply();
757         require( !_WLpaused,                                       "Sale paused" );
758         require( WL[msg.sender] == true,                         "Only WHITELIST can mint" );
759         require( supply + num <= limit - _reserved,              "Exceeds maximum PUNK supply" );
760         require( msg.value >= _price * num,                      "Ether sent is not correct" );
761         require( WL_Mint[msg.sender]  +  num <= WL_limit,        "Exceeds minting limit per tx");
762         
763         for(uint256 i; i < num; i++){
764             _safeMint( msg.sender, supply + i );
765         }
766         WL_Mint[msg.sender] += num;
767     }
768     
769     function SWL_mint(uint qwt) public payable {
770         uint256 supply = totalSupply();
771         require( !_WLpaused,                                      "Sale paused" );
772         require( SWL[msg.sender] == true,                       "You are not allowed to mint from here");
773         require( SWL_Mint[msg.sender]  +  qwt <=  SWL_limit ,   "You are exceeding SWL mint allowance");
774         require( qwt  <=  SWL_limit,                            "Exceeds minting limit per tx");
775         require( supply + qwt <= limit - _reserved,             "Exceeds maximum punks supply" );
776         
777         for(uint256 i; i < qwt; i++){
778             _safeMint( msg.sender, supply + i );
779         }
780         
781         SWL_Mint[msg.sender] += qwt;
782     }
783     
784     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
785         uint256 tokenCount = balanceOf(_owner);
786 
787         uint256[] memory tokensId = new uint256[](tokenCount);
788         for(uint256 i; i < tokenCount; i++){
789             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
790         }
791         return tokensId;
792     }
793     
794     // Just in case Eth does some crazy stuff
795     function setPrice(uint256 _newPrice) public onlyOwner() {
796         _price = _newPrice;
797     }
798  
799     function setWL(address[] memory _address) public onlyOwner() {
800         for(uint256 i; i<_address.length; i++){
801             require(_address[i] != address(0), "Invalid address found");
802             address tempAdd = _address[i];
803             WL[tempAdd] = true;
804         }
805     }
806  
807     function setSWL(address[] memory _address) public onlyOwner() {
808         for(uint256 i; i<_address.length; i++){
809             require(_address[i] != address(0), "Invalid address found");
810             address tempAdd = _address[i];
811             SWL[tempAdd] = true;
812         }
813     }
814 
815     function setSWL_limit(uint256 _limit) public onlyOwner() {
816         SWL_limit = _limit;
817     }
818 
819     function setLimit(uint256 __limit) public onlyOwner() {
820         limit = __limit;
821     }
822 
823     function setMaxPerTx(uint256 __maxPerTx) public onlyOwner() {
824         maxPerTx = __maxPerTx;
825     }
826 
827     function _baseURI() internal view virtual override returns (string memory) {
828         return _baseTokenURI;
829     }
830 
831     function setBaseURI(string memory baseURI) public onlyOwner {
832         _baseTokenURI = baseURI;
833     }
834 
835     function getPrice() public view returns (uint256){
836         return _price;
837     }
838 
839     function pause() public onlyOwner {
840         _paused = !_paused;
841     }
842 
843     function WLpaused() public onlyOwner {
844         _WLpaused = !_WLpaused;
845     }
846 
847 
848 
849     address public wallet1 = 0x592A830d4883bBEF0fB5eF78eC2a8455F1EbAC4D;
850     address public wallet2 = 0x24d38AF5790189902037d4b81242C3EC2739Ab71;
851  
852     function withdraw() public payable onlyOwner {
853         uint256 _mars1 = (address(this).balance * 500) / 1000;  // 50%  
854         uint256 _mars2 = (address(this).balance * 500) / 1000;  // 50%
855  
856         payable(wallet1).transfer(_mars1);
857         payable(wallet2).transfer(_mars2);
858     }
859 }