1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-14
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-13
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-04-17
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-03-24
15 */
16 
17 // SPDX-License-Identifier: MIT
18 
19 
20 pragma solidity ^0.8.0;
21 
22 interface IERC165 {
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 pragma solidity ^0.8.0;
27 interface IERC721 is IERC165 {
28     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
29 
30     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
31 
32     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
33 
34     function balanceOf(address owner) external view returns (uint256 balance);
35 
36     function ownerOf(uint256 tokenId) external view returns (address owner);
37 
38     function safeTransferFrom(
39         address from,
40         address to,
41         uint256 tokenId
42     ) external;
43 
44     function transferFrom(
45         address from,
46         address to,
47         uint256 tokenId
48     ) external;
49 
50     function approve(address to, uint256 tokenId) external;
51 
52     function getApproved(uint256 tokenId) external view returns (address operator);
53 
54     function setApprovalForAll(address operator, bool _approved) external;
55 
56     function isApprovedForAll(address owner, address operator) external view returns (bool);
57 
58     function safeTransferFrom(
59         address from,
60         address to,
61         uint256 tokenId,
62         bytes calldata data
63     ) external;
64 }
65 
66 
67 pragma solidity ^0.8.0;
68 interface IERC721Enumerable is IERC721 {
69     function totalSupply() external view returns (uint256);
70 
71     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
72 
73     function tokenByIndex(uint256 index) external view returns (uint256);
74 }
75 
76 
77 pragma solidity ^0.8.0;
78 abstract contract ERC165 is IERC165 {
79     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
80         return interfaceId == type(IERC165).interfaceId;
81     }
82 }
83 
84 
85 pragma solidity ^0.8.0;
86 
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89 
90     function toString(uint256 value) internal pure returns (string memory) {
91         
92         if (value == 0) {
93             return "0";
94         }
95         uint256 temp = value;
96         uint256 digits;
97         while (temp != 0) {
98             digits++;
99             temp /= 10;
100         }
101         bytes memory buffer = new bytes(digits);
102         while (value != 0) {
103             digits -= 1;
104             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
105             value /= 10;
106         }
107         return string(buffer);
108     }
109 
110     
111     function toHexString(uint256 value) internal pure returns (string memory) {
112         if (value == 0) {
113             return "0x00";
114         }
115         uint256 temp = value;
116         uint256 length = 0;
117         while (temp != 0) {
118             length++;
119             temp >>= 8;
120         }
121         return toHexString(value, length);
122     }
123 
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 
138 
139 
140 pragma solidity ^0.8.0;
141 
142 library Address {
143     function isContract(address account) internal view returns (bool) {
144         
145         uint256 size;
146         assembly {
147             size := extcodesize(account)
148         }
149         return size > 0;
150     }
151 
152     function sendValue(address payable recipient, uint256 amount) internal {
153         require(address(this).balance >= amount, "Address: insufficient balance");
154 
155         (bool success, ) = recipient.call{value: amount}("");
156         require(success, "Address: unable to send value, recipient may have reverted");
157     }
158 
159     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionCall(target, data, "Address: low-level call failed");
161     }
162 
163     function functionCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     function functionCallWithValue(
172         address target,
173         bytes memory data,
174         uint256 value
175     ) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
177     }
178 
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         require(address(this).balance >= value, "Address: insufficient balance for call");
186         require(isContract(target), "Address: call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.call{value: value}(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     
193     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
194         return functionStaticCall(target, data, "Address: low-level static call failed");
195     }
196 
197     function functionStaticCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal view returns (bytes memory) {
202         require(isContract(target), "Address: static call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.staticcall(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
209         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
210     }
211 
212     function functionDelegateCall(
213         address target,
214         bytes memory data,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(isContract(target), "Address: delegate call to non-contract");
218 
219         (bool success, bytes memory returndata) = target.delegatecall(data);
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     function verifyCallResult(
224         bool success,
225         bytes memory returndata,
226         string memory errorMessage
227     ) internal pure returns (bytes memory) {
228         if (success) {
229             return returndata;
230         } else {
231             // Look for revert reason and bubble it up if present
232             if (returndata.length > 0) {
233                 // The easiest way to bubble the revert reason is using memory via assembly
234 
235                 assembly {
236                     let returndata_size := mload(returndata)
237                     revert(add(32, returndata), returndata_size)
238                 }
239             } else {
240                 revert(errorMessage);
241             }
242         }
243     }
244 }
245 
246 pragma solidity ^0.8.0;
247 
248 interface IERC721Metadata is IERC721 {
249     function name() external view returns (string memory);
250 
251     function symbol() external view returns (string memory);
252 
253     function tokenURI(uint256 tokenId) external view returns (string memory);
254 }
255 
256 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
257 
258 pragma solidity ^0.8.0;
259 
260 interface IERC721Receiver {
261     function onERC721Received(
262         address operator,
263         address from,
264         uint256 tokenId,
265         bytes calldata data
266     ) external returns (bytes4);
267 }
268 
269 pragma solidity ^0.8.0;
270 abstract contract Context {
271     function _msgSender() internal view virtual returns (address) {
272         return msg.sender;
273     }
274 
275     function _msgData() internal view virtual returns (bytes calldata) {
276         return msg.data;
277     }
278 }
279 
280 
281 pragma solidity ^0.8.0;
282 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
283     using Address for address;
284     using Strings for uint256;
285 
286     // Token name
287     string private _name;
288 
289     // Token symbol
290     string private _symbol;
291 
292     // Mapping from token ID to owner address
293     mapping(uint256 => address) private _owners;
294 
295     // Mapping owner address to token count
296     mapping(address => uint256) private _balances;
297 
298     // Mapping from token ID to approved address
299     mapping(uint256 => address) private _tokenApprovals;
300 
301     // Mapping from owner to operator approvals
302     mapping(address => mapping(address => bool)) private _operatorApprovals;
303 
304     constructor(string memory name_, string memory symbol_) {
305         _name = name_;
306         _symbol = symbol_;
307     }
308 
309     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
310         return
311             interfaceId == type(IERC721).interfaceId ||
312             interfaceId == type(IERC721Metadata).interfaceId ||
313             super.supportsInterface(interfaceId);
314     }
315 
316     /**
317      * @dev See {IERC721-balanceOf}.
318      */
319     function balanceOf(address owner) public view virtual override returns (uint256) {
320         require(owner != address(0), "ERC721: balance query for the zero address");
321         return _balances[owner];
322     }
323 
324     /**
325      * @dev See {IERC721-ownerOf}.
326      */
327     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
328         address owner = _owners[tokenId];
329         require(owner != address(0), "ERC721: owner query for nonexistent token");
330         return owner;
331     }
332 
333     /**
334      * @dev See {IERC721Metadata-name}.
335      */
336     function name() public view virtual override returns (string memory) {
337         return _name;
338     }
339 
340     /**
341      * @dev See {IERC721Metadata-symbol}.
342      */
343     function symbol() public view virtual override returns (string memory) {
344         return _symbol;
345     }
346 
347     /**
348      * @dev See {IERC721Metadata-tokenURI}.
349      */
350     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
351         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
352 
353         string memory baseURI = _baseURI();
354         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
355     }
356 
357     function _baseURI() internal view virtual returns (string memory) {
358         return "";
359     }
360 
361     function approve(address to, uint256 tokenId) public virtual override {
362         address owner = ERC721.ownerOf(tokenId);
363         require(to != owner, "ERC721: approval to current owner");
364 
365         require(
366             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
367             "ERC721: approve caller is not owner nor approved for all"
368         );
369 
370         _approve(to, tokenId);
371     }
372 
373     /**
374      * @dev See {IERC721-getApproved}.
375      */
376     function getApproved(uint256 tokenId) public view virtual override returns (address) {
377         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
378 
379         return _tokenApprovals[tokenId];
380     }
381 
382     /**
383      * @dev See {IERC721-setApprovalForAll}.
384      */
385     function setApprovalForAll(address operator, bool approved) public virtual override {
386         require(operator != _msgSender(), "ERC721: approve to caller");
387 
388         _operatorApprovals[_msgSender()][operator] = approved;
389         emit ApprovalForAll(_msgSender(), operator, approved);
390     }
391 
392     /**
393      * @dev See {IERC721-isApprovedForAll}.
394      */
395     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
396         return _operatorApprovals[owner][operator];
397     }
398 
399     /**
400      * @dev See {IERC721-transferFrom}.
401      */
402     function transferFrom(
403         address from,
404         address to,
405         uint256 tokenId
406     ) public virtual override {
407         //solhint-disable-next-line max-line-length
408         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
409 
410         _transfer(from, to, tokenId);
411     }
412 
413     /**
414      * @dev See {IERC721-safeTransferFrom}.
415      */
416     function safeTransferFrom(
417         address from,
418         address to,
419         uint256 tokenId
420     ) public virtual override {
421         safeTransferFrom(from, to, tokenId, "");
422     }
423 
424     /**
425      * @dev See {IERC721-safeTransferFrom}.
426      */
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 tokenId,
431         bytes memory _data
432     ) public virtual override {
433         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
434         _safeTransfer(from, to, tokenId, _data);
435     }
436 
437     
438     function _safeTransfer(
439         address from,
440         address to,
441         uint256 tokenId,
442         bytes memory _data
443     ) internal virtual {
444         _transfer(from, to, tokenId);
445         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
446     }
447 
448     
449     function _exists(uint256 tokenId) internal view virtual returns (bool) {
450         return _owners[tokenId] != address(0);
451     }
452 
453     
454     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
455         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
456         address owner = ERC721.ownerOf(tokenId);
457         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
458     }
459 
460     
461     function _safeMint(address to, uint256 tokenId) internal virtual {
462         _safeMint(to, tokenId, "");
463     }
464 
465     
466     function _safeMint(
467         address to,
468         uint256 tokenId,
469         bytes memory _data
470     ) internal virtual {
471         _mint(to, tokenId);
472         require(
473             _checkOnERC721Received(address(0), to, tokenId, _data),
474             "ERC721: transfer to non ERC721Receiver implementer"
475         );
476     }
477 
478     
479     function _mint(address to, uint256 tokenId) internal virtual {
480         require(to != address(0), "ERC721: mint to the zero address");
481         require(!_exists(tokenId), "ERC721: token already minted");
482 
483         _beforeTokenTransfer(address(0), to, tokenId);
484 
485         _balances[to] += 1;
486         _owners[tokenId] = to;
487 
488         emit Transfer(address(0), to, tokenId);
489     }
490 
491     
492     function _burn(uint256 tokenId) internal virtual {
493         address owner = ERC721.ownerOf(tokenId);
494 
495         _beforeTokenTransfer(owner, address(0), tokenId);
496 
497         // Clear approvals
498         _approve(address(0), tokenId);
499 
500         _balances[owner] -= 1;
501         delete _owners[tokenId];
502 
503         emit Transfer(owner, address(0), tokenId);
504     }
505 
506     
507     function _transfer(
508         address from,
509         address to,
510         uint256 tokenId
511     ) internal virtual {
512         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
513         require(to != address(0), "ERC721: transfer to the zero address");
514 
515         _beforeTokenTransfer(from, to, tokenId);
516 
517         // Clear approvals from the previous owner
518         _approve(address(0), tokenId);
519 
520         _balances[from] -= 1;
521         _balances[to] += 1;
522         _owners[tokenId] = to;
523 
524         emit Transfer(from, to, tokenId);
525     }
526 
527     
528     function _approve(address to, uint256 tokenId) internal virtual {
529         _tokenApprovals[tokenId] = to;
530         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
531     }
532 
533     
534     function _checkOnERC721Received(
535         address from,
536         address to,
537         uint256 tokenId,
538         bytes memory _data
539     ) private returns (bool) {
540         if (to.isContract()) {
541             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
542                 return retval == IERC721Receiver.onERC721Received.selector;
543             } catch (bytes memory reason) {
544                 if (reason.length == 0) {
545                     revert("ERC721: transfer to non ERC721Receiver implementer");
546                 } else {
547                     assembly {
548                         revert(add(32, reason), mload(reason))
549                     }
550                 }
551             }
552         } else {
553             return true;
554         }
555     }
556 
557     
558     function _beforeTokenTransfer(
559         address from,
560         address to,
561         uint256 tokenId
562     ) internal virtual {}
563 }
564 
565 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
566 
567 
568 
569 pragma solidity ^0.8.0;
570 
571 
572 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
573     // Mapping from owner to list of owned token IDs
574     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
575 
576     // Mapping from token ID to index of the owner tokens list
577     mapping(uint256 => uint256) private _ownedTokensIndex;
578 
579     // Array with all token ids, used for enumeration
580     uint256[] private _allTokens;
581 
582     // Mapping from token id to position in the allTokens array
583     mapping(uint256 => uint256) private _allTokensIndex;
584 
585     /**
586      * @dev See {IERC165-supportsInterface}.
587      */
588     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
589         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
590     }
591 
592     /**
593      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
594      */
595     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
596         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
597         return _ownedTokens[owner][index];
598     }
599 
600     /**
601      * @dev See {IERC721Enumerable-totalSupply}.
602      */
603     function totalSupply() public view virtual override returns (uint256) {
604         return _allTokens.length;
605     }
606 
607     /**
608      * @dev See {IERC721Enumerable-tokenByIndex}.
609      */
610     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
611         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
612         return _allTokens[index];
613     }
614 
615     
616     function _beforeTokenTransfer(
617         address from,
618         address to,
619         uint256 tokenId
620     ) internal virtual override {
621         super._beforeTokenTransfer(from, to, tokenId);
622 
623         if (from == address(0)) {
624             _addTokenToAllTokensEnumeration(tokenId);
625         } else if (from != to) {
626             _removeTokenFromOwnerEnumeration(from, tokenId);
627         }
628         if (to == address(0)) {
629             _removeTokenFromAllTokensEnumeration(tokenId);
630         } else if (to != from) {
631             _addTokenToOwnerEnumeration(to, tokenId);
632         }
633     }
634 
635    
636     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
637         uint256 length = ERC721.balanceOf(to);
638         _ownedTokens[to][length] = tokenId;
639         _ownedTokensIndex[tokenId] = length;
640     }
641 
642     
643     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
644         _allTokensIndex[tokenId] = _allTokens.length;
645         _allTokens.push(tokenId);
646     }
647 
648     
649     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
650         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
651         // then delete the last slot (swap and pop).
652 
653         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
654         uint256 tokenIndex = _ownedTokensIndex[tokenId];
655 
656         // When the token to delete is the last token, the swap operation is unnecessary
657         if (tokenIndex != lastTokenIndex) {
658             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
659 
660             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
661             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
662         }
663 
664         // This also deletes the contents at the last position of the array
665         delete _ownedTokensIndex[tokenId];
666         delete _ownedTokens[from][lastTokenIndex];
667     }
668 
669     
670     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
671         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
672         // then delete the last slot (swap and pop).
673 
674         uint256 lastTokenIndex = _allTokens.length - 1;
675         uint256 tokenIndex = _allTokensIndex[tokenId];
676 
677         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
678         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
679         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
680         uint256 lastTokenId = _allTokens[lastTokenIndex];
681 
682         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
683         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
684 
685         // This also deletes the contents at the last position of the array
686         delete _allTokensIndex[tokenId];
687         _allTokens.pop();
688     }
689 }
690 
691 
692 // File: @openzeppelin/contracts/access/Ownable.sol
693 pragma solidity ^0.8.0;
694 
695 abstract contract Ownable is Context {
696     address private _owner;
697 
698     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
699 
700     /**
701      * @dev Initializes the contract setting the deployer as the initial owner.
702      */
703     constructor() {
704         _setOwner(_msgSender());
705     }
706 
707     /**
708      * @dev Returns the address of the current owner.
709      */
710     function owner() public view virtual returns (address) {
711         return _owner;
712     }
713 
714     /**
715      * @dev Throws if called by any account other than the owner.
716      */
717     modifier onlyOwner() {
718         require(owner() == _msgSender(), "Ownable: caller is not the owner");
719         _;
720     }
721 
722     
723     function renounceOwnership() public virtual onlyOwner {
724         _setOwner(address(0));
725     }
726 
727     
728     function transferOwnership(address newOwner) public virtual onlyOwner {
729         require(newOwner != address(0), "Ownable: new owner is the zero address");
730         _setOwner(newOwner);
731     }
732 
733     function _setOwner(address newOwner) private {
734         address oldOwner = _owner;
735         _owner = newOwner;
736         emit OwnershipTransferred(oldOwner, newOwner);
737     }
738 }
739 // @Author Syed MUhammad Ali (Qubitars)
740 pragma solidity >=0.7.0 <0.9.0;
741 
742 contract YesBear is ERC721Enumerable, Ownable {
743   using Strings for uint256;
744 
745   string public baseURI;
746   string public baseExtension = ".json";
747   string public notRevealedUri;
748   uint256 public cost = 0.039 ether;
749   uint256 public maxSupply = 6666;
750   uint256 public maxMintAmount = 50;
751   uint256 public nftPerAddressLimit = 3;
752   bool public paused = false;
753   bool public revealed = false;
754   bool public onlyWhitelisted = true;
755   address[] public whitelistedAddresses;
756   mapping(address => uint256) public addressMintedBalance;
757 
758   constructor(
759     string memory _name,
760     string memory _symbol,
761     string memory _initBaseURI,
762     string memory _initNotRevealedUri
763   ) ERC721(_name, _symbol) {
764     setBaseURI(_initBaseURI);
765     setNotRevealedURI(_initNotRevealedUri);
766   }
767 
768   // internal
769   function _baseURI() internal view virtual override returns (string memory) {
770     return baseURI;
771   }
772 
773   // public
774   function mint(uint256 _mintAmount) public payable {
775     require(!paused, "the contract is paused");
776     uint256 supply = totalSupply();
777     require(_mintAmount > 0, "need to mint at least 1 NFT");
778     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
779     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
780 
781     if (msg.sender != owner()) {
782         if(onlyWhitelisted == true) {
783             require(isWhitelisted(msg.sender), "user is not whitelisted");
784             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
785             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
786         }
787         require(msg.value >= cost * _mintAmount, "insufficient funds");
788     }
789 
790     for (uint256 i = 1; i <= _mintAmount; i++) {
791       addressMintedBalance[msg.sender]++;
792       _safeMint(msg.sender, supply + i);
793     }
794   }
795   
796   function isWhitelisted(address _user) public view returns (bool) {
797     for (uint i = 0; i < whitelistedAddresses.length; i++) {
798       if (whitelistedAddresses[i] == _user) {
799           return true;
800       }
801     }
802     return false;
803   }
804 
805   function walletOfOwner(address _owner)
806     public
807     view
808     returns (uint256[] memory)
809   {
810     uint256 ownerTokenCount = balanceOf(_owner);
811     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
812     for (uint256 i; i < ownerTokenCount; i++) {
813       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
814     }
815     return tokenIds;
816   }
817 
818   function tokenURI(uint256 tokenId)
819     public
820     view
821     virtual
822     override
823     returns (string memory)
824   {
825     require(
826       _exists(tokenId),
827       "ERC721Metadata: URI query for nonexistent token"
828     );
829     
830     if(revealed == false) {
831         return notRevealedUri;
832     }
833 
834     string memory currentBaseURI = _baseURI();
835     return bytes(currentBaseURI).length > 0
836         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
837         : "";
838   }
839 
840   //only owner
841   function reveal() public onlyOwner {
842       revealed = true;
843   }
844   
845   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
846     nftPerAddressLimit = _limit;
847   }
848   
849   function setCost(uint256 _newCost) public onlyOwner {
850     cost = _newCost;
851   }
852 
853   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
854     maxMintAmount = _newmaxMintAmount;
855   }
856 
857   function setBaseURI(string memory _newBaseURI) public onlyOwner {
858     baseURI = _newBaseURI;
859   }
860 
861   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
862     baseExtension = _newBaseExtension;
863   }
864   
865   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
866     notRevealedUri = _notRevealedURI;
867   }
868 
869   function pause(bool _state) public onlyOwner {
870     paused = _state;
871   }
872   
873   function setOnlyWhitelisted(bool _state) public onlyOwner {
874     onlyWhitelisted = _state;
875   }
876   
877   function whitelistUsers(address[] calldata _users) public onlyOwner {
878     delete whitelistedAddresses;
879     whitelistedAddresses = _users;
880   }
881 
882   function withdraw() public onlyOwner {
883     (bool success, ) = msg.sender.call{value: address(this).balance}("");
884     require(success, "Transaction failed.");
885   }
886 }