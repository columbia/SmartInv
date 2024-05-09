1 // SPDX-License-Identifier: MIT
2 
3 //GolblinTownTowns/\GolblinTownTowns\GolblinTownTowns\GolblinTownTowns/\GolblinTownTowns
4 //GolblinTownTowns\/GolblinTownTowns\GolblinTownTowns\GolblinTownTowns\/GolblinTownTowns
5 //GolblinTownTowns/\GolblinTownTowns\GolblinTownTowns\GolblinTownTowns/\GolblinTownTowns
6 //GolblinTownTowns\/GolblinTownTowns\GolblinTownTowns\GolblinTownTowns\/GolblinTownTowns
7 //GolblinTownTowns/\GolblinTownTowns\GolblinTownTowns\GolblinTownTowns/\GolblinTownTowns
8 //GolblinTownTowns\/GolblinTownTowns\GolblinTownTowns\GolblinTownTowns\/GolblinTownTowns
9 
10 //  https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
11 pragma solidity ^0.8.0;
12 
13 interface IERC165 {
14    
15     function supportsInterface(bytes4 interfaceId) external view returns (bool);
16 }
17 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
18 pragma solidity ^0.8.0;
19 
20 interface IERC721 is IERC165 {
21   
22     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
23     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
24     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);    
25     function balanceOf(address owner) external view returns (uint256 balance);
26     function ownerOf(uint256 tokenId) external view returns (address owner);
27 
28     function safeTransferFrom(
29         address from,
30         address to,
31         uint256 tokenId
32     ) external;
33 
34     function transferFrom(
35         address from,
36         address to,
37         uint256 tokenId
38     ) external;
39 
40     function approve(address to, uint256 tokenId) external;
41     function getApproved(uint256 tokenId) external view returns (address operator);
42     function setApprovalForAll(address operator, bool _approved) external;
43     function isApprovedForAll(address owner, address operator) external view returns (bool);
44 
45     function safeTransferFrom(
46         address from,
47         address to,
48         uint256 tokenId,
49         bytes calldata data
50     ) external;
51 }
52 
53 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
54 pragma solidity ^0.8.0;
55 
56 abstract contract ERC165 is IERC165 {
57  
58     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
59         return interfaceId == type(IERC165).interfaceId;
60     }
61 }
62 
63 pragma solidity ^0.8.0;
64 // conerts to ASCII
65 library Strings {
66     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
67 
68 function toString(uint256 value) internal pure returns (string memory) {
69         // Inspired by OraclizeAPI's implementation - MIT licence
70         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
71 
72         if (value == 0) {
73             return "0";
74         }
75         uint256 temp = value;
76         uint256 digits;
77         while (temp != 0) {
78             digits++;
79             temp /= 10;
80         }
81         bytes memory buffer = new bytes(digits);
82         while (value != 0) {
83             digits -= 1;
84             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
85             value /= 10;
86         }
87         return string(buffer);
88     }
89 function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     } 
101 function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
102         bytes memory buffer = new bytes(2 * length + 2);
103         buffer[0] = "0";
104         buffer[1] = "x";
105         for (uint256 i = 2 * length + 1; i > 1; --i) {
106             buffer[i] = _HEX_SYMBOLS[value & 0xf];
107             value >>= 4;
108         }
109         require(value == 0, "Strings: hex length insufficient");
110         return string(buffer);
111     }
112 }
113 
114 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
115 
116 pragma solidity ^0.8.0;
117 //address functions
118 library Address {
119   
120     function isContract(address account) internal view returns (bool) {
121 
122         uint256 size;
123         assembly {
124             size := extcodesize(account)
125         }
126         return size > 0;
127     }
128  function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130 
131         (bool success, ) = recipient.call{value: amount}("");
132         require(success, "Address: unable to send value, recipient may have reverted");
133     }
134 function functionCall(address target, bytes memory data) internal returns (bytes memory) {
135         return functionCall(target, data, "Address: low-level call failed");
136     }
137 function functionCall(
138         address target,
139         bytes memory data,
140         string memory errorMessage
141     ) internal returns (bytes memory) {
142         return functionCallWithValue(target, data, 0, errorMessage);
143     }
144 
145 function functionCallWithValue(
146         address target,
147         bytes memory data,
148         uint256 value
149     ) internal returns (bytes memory) {
150         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
151     }
152 
153 function functionCallWithValue(
154         address target,
155         bytes memory data,
156         uint256 value,
157         string memory errorMessage
158     ) internal returns (bytes memory) {
159         require(address(this).balance >= value, "Address: insufficient balance for call");
160         require(isContract(target), "Address: call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.call{value: value}(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165  
166 function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
167         return functionStaticCall(target, data, "Address: low-level static call failed");
168     } 
169  function functionStaticCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal view returns (bytes memory) {
174         require(isContract(target), "Address: static call to non-contract");
175 
176         (bool success, bytes memory returndata) = target.staticcall(data);
177         return verifyCallResult(success, returndata, errorMessage);
178     }
179  function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182  function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 function verifyCallResult(
193         bool success,
194         bytes memory returndata,
195         string memory errorMessage
196     ) internal pure returns (bytes memory) {
197         if (success) {
198             return returndata;
199         } else {
200             
201             if (returndata.length > 0) {
202                 
203 
204                 assembly {
205                     let returndata_size := mload(returndata)
206                     revert(add(32, returndata), returndata_size)
207                 }
208             } else {
209                 revert(errorMessage);
210             }
211         }
212     }
213 }
214 
215 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
216 
217 pragma solidity ^0.8.0;
218 //ERC-721 Token Standard
219 interface IERC721Metadata is IERC721 {
220    
221     function name() external view returns (string memory);  
222     function symbol() external view returns (string memory);
223     function tokenURI(uint256 tokenId) external view returns (string memory);
224 }
225 
226 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
227 
228 pragma solidity ^0.8.0;
229 interface IERC721Receiver {
230 
231     function onERC721Received(
232         address operator,
233         address from,
234         uint256 tokenId,
235         bytes calldata data
236     ) external returns (bytes4);
237 }
238 
239 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
240 pragma solidity ^0.8.0;
241 
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes calldata) {
248         return msg.data;
249     }
250 }
251 
252 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
253 pragma solidity ^0.8.0;
254 
255 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
256     using Address for address;
257     using Strings for uint256;
258 
259     string private _name;
260 
261     string private _symbol;
262 
263     mapping(uint256 => address) private _owners;
264 
265     mapping(address => uint256) private _balances;
266 
267     mapping(uint256 => address) private _tokenApprovals;
268 
269     mapping(address => mapping(address => bool)) private _operatorApprovals;
270 //coolection constructor
271     constructor(string memory name_, string memory symbol_) {
272         _name = name_;
273         _symbol = symbol_;
274     } 
275 function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
276         return
277             interfaceId == type(IERC721).interfaceId ||
278             interfaceId == type(IERC721Metadata).interfaceId ||
279             super.supportsInterface(interfaceId);
280     }
281 function balanceOf(address owner) public view virtual override returns (uint256) {
282         require(owner != address(0), "ERC721: balance query for the zero address");
283         return _balances[owner];
284     }
285 function ownerOf(uint256 tokenId) public view virtual override returns (address) {
286         address owner = _owners[tokenId];
287         require(owner != address(0), "ERC721: owner query for nonexistent token");
288         return owner;
289     } 
290 function name() public view virtual override returns (string memory) {
291         return _name;
292     }
293 function symbol() public view virtual override returns (string memory) {
294         return _symbol;
295     }
296 function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
297         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
298 
299         string memory baseURI = _baseURI();
300         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
301     }
302 
303 function _baseURI() internal view virtual returns (string memory) {
304         return "";
305     }
306  function approve(address to, uint256 tokenId) public virtual override {
307         address owner = ERC721.ownerOf(tokenId);
308         require(to != owner, "ERC721: approval to current owner");
309         require(
310             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
311             "ERC721: approve caller is not owner nor approved for all"
312         );
313         _approve(to, tokenId);
314     }
315 function getApproved(uint256 tokenId) public view virtual override returns (address) {
316         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
317         return _tokenApprovals[tokenId];
318     } 
319 function setApprovalForAll(address operator, bool approved) public virtual override {
320         require(operator != _msgSender(), "ERC721: approve to caller");
321 
322         _operatorApprovals[_msgSender()][operator] = approved;
323         emit ApprovalForAll(_msgSender(), operator, approved);
324     }
325 function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
326         return _operatorApprovals[owner][operator];
327     }
328 function transferFrom(
329         address from,
330         address to,
331         uint256 tokenId
332     ) public virtual override {
333      
334         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
335         _transfer(from, to, tokenId);
336     }
337 
338 function safeTransferFrom(
339         address from,
340         address to,
341         uint256 tokenId
342     ) public virtual override {
343         safeTransferFrom(from, to, tokenId, "");
344     }
345 function safeTransferFrom(
346         address from,
347         address to,
348         uint256 tokenId,
349         bytes memory _data
350     ) public virtual override {
351         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
352         _safeTransfer(from, to, tokenId, _data);
353     } 
354 function _safeTransfer(
355         address from,
356         address to,
357         uint256 tokenId,
358         bytes memory _data
359     ) internal virtual {
360         _transfer(from, to, tokenId);
361         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
362     }
363 function _exists(uint256 tokenId) internal view virtual returns (bool) {
364         return _owners[tokenId] != address(0);
365     }  
366 function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
367         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
368         address owner = ERC721.ownerOf(tokenId);
369         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
370     } 
371 function _safeMint(address to, uint256 tokenId) internal virtual {
372         _safeMint(to, tokenId, "");
373     }
374 function _safeMint(
375         address to,
376         uint256 tokenId,
377         bytes memory _data
378     ) internal virtual {
379         _mint(to, tokenId);
380         require(
381             _checkOnERC721Received(address(0), to, tokenId, _data),
382             "ERC721: transfer to non ERC721Receiver implementer"
383         );
384     }
385 function _mint(address to, uint256 tokenId) internal virtual {
386         require(to != address(0), "ERC721: mint to the zero address");
387         require(!_exists(tokenId), "ERC721: token already minted");
388 
389         _beforeTokenTransfer(address(0), to, tokenId);
390 
391         _balances[to] += 1;
392         _owners[tokenId] = to;
393 
394         emit Transfer(address(0), to, tokenId);
395     }
396 function _burn(uint256 tokenId) internal virtual {
397         address owner = ERC721.ownerOf(tokenId);
398 
399         _beforeTokenTransfer(owner, address(0), tokenId);
400         _approve(address(0), tokenId);
401         _balances[owner] -= 1;
402         delete _owners[tokenId];
403         emit Transfer(owner, address(0), tokenId);
404     }
405 function _transfer(
406         address from,
407         address to,
408         uint256 tokenId
409     ) internal virtual {
410         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
411         require(to != address(0), "ERC721: transfer to the zero address");
412 
413         _beforeTokenTransfer(from, to, tokenId);
414         _approve(address(0), tokenId);
415         _balances[from] -= 1;
416         _balances[to] += 1;
417         _owners[tokenId] = to;
418 
419         emit Transfer(from, to, tokenId);
420     }
421  function _approve(address to, uint256 tokenId) internal virtual {
422         _tokenApprovals[tokenId] = to;
423         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
424     }
425 function _checkOnERC721Received(
426         address from,
427         address to,
428         uint256 tokenId,
429         bytes memory _data
430     ) private returns (bool) {
431         if (to.isContract()) {
432             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
433                 return retval == IERC721Receiver.onERC721Received.selector;
434             } catch (bytes memory reason) {
435                 if (reason.length == 0) {
436                     revert("ERC721: transfer to non ERC721Receiver implementer");
437                 } else {
438                     assembly {
439                         revert(add(32, reason), mload(reason))
440                     }
441                 }
442             }
443         } else {
444             return true;
445         }
446     }
447 function _beforeTokenTransfer(
448         address from,
449         address to,
450         uint256 tokenId
451     ) internal virtual {}
452 }
453 
454 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
455 
456 pragma solidity ^0.8.0;
457 // owner only commands
458 abstract contract Ownable is Context {
459     address private _owner;
460     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
461 
462     constructor() {
463         _setOwner(_msgSender());
464     }
465     function owner() public view virtual returns (address) {
466         return _owner;
467     } 
468     modifier onlyOwner() {
469         require(owner() == _msgSender(), "Ownable: caller is not the owner");
470         _;
471     }
472     function renounceOwnership() public virtual onlyOwner {
473         _setOwner(address(0));
474     }
475     function transferOwnership(address newOwner) public virtual onlyOwner {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         _setOwner(newOwner);
478     }
479     function _setOwner(address newOwner) private {
480         address oldOwner = _owner;
481         _owner = newOwner;
482         emit OwnershipTransferred(oldOwner, newOwner);
483     }
484 }
485 
486 pragma solidity ^0.8.0;
487 
488 
489 
490 /**
491  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
492  * @dev See https://eips.ethereum.org/EIPS/eip-721
493  */
494 interface IERC721Enumerable is IERC721 {
495     /**
496      * @dev Returns the total amount of tokens stored by the contract.
497      */
498     function totalSupply() external view returns (uint256);
499 
500     /**
501      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
502      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
503      */
504     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
505 
506     /**
507      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
508      * Use along with {totalSupply} to enumerate all tokens.
509      */
510     function tokenByIndex(uint256 index) external view returns (uint256);
511 }
512 
513 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
514     using Address for address;
515     using Strings for uint256;
516 
517     struct TokenOwnership {
518         address addr;
519         uint64 startTimestamp;
520     }
521 
522     struct AddressData {
523         uint128 balance;
524         uint128 numberMinted;
525     }
526 
527     uint256 internal currentIndex;
528 
529     // Token name
530     string private _name;
531 
532     // Token symbol
533     string private _symbol;
534 
535     // Mapping from token ID to ownership details
536     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
537     mapping(uint256 => TokenOwnership) internal _ownerships;
538 
539     // Mapping owner address to address data
540     mapping(address => AddressData) private _addressData;
541 
542     // Mapping from token ID to approved address
543     mapping(uint256 => address) private _tokenApprovals;
544 
545     // Mapping from owner to operator approvals
546     mapping(address => mapping(address => bool)) private _operatorApprovals;
547 
548     constructor(string memory name_, string memory symbol_) {
549         _name = name_;
550         _symbol = symbol_;
551     }
552 
553     /**
554      * @dev See {IERC721Enumerable-totalSupply}.
555      */
556     function totalSupply() public view override returns (uint256) {
557         return currentIndex;
558     }
559 
560     /**
561      * @dev See {IERC721Enumerable-tokenByIndex}.
562      */
563     function tokenByIndex(uint256 index) public view override returns (uint256) {
564         require(index < totalSupply(), 'ERC721A: global index out of bounds');
565         return index;
566     }
567 
568     /**
569      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
570      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
571      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
572      */
573     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
574         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
575         uint256 numMintedSoFar = totalSupply();
576         uint256 tokenIdsIdx;
577         address currOwnershipAddr;
578 
579         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
580         unchecked {
581             for (uint256 i; i < numMintedSoFar; i++) {
582                 TokenOwnership memory ownership = _ownerships[i];
583                 if (ownership.addr != address(0)) {
584                     currOwnershipAddr = ownership.addr;
585                 }
586                 if (currOwnershipAddr == owner) {
587                     if (tokenIdsIdx == index) {
588                         return i;
589                     }
590                     tokenIdsIdx++;
591                 }
592             }
593         }
594 
595         revert('ERC721A: unable to get token of owner by index');
596     }
597 
598     /**
599      * @dev See {IERC165-supportsInterface}.
600      */
601     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
602         return
603             interfaceId == type(IERC721).interfaceId ||
604             interfaceId == type(IERC721Metadata).interfaceId ||
605             interfaceId == type(IERC721Enumerable).interfaceId ||
606             super.supportsInterface(interfaceId);
607     }
608 
609     /**
610      * @dev See {IERC721-balanceOf}.
611      */
612     function balanceOf(address owner) public view override returns (uint256) {
613         require(owner != address(0), 'ERC721A: balance query for the zero address');
614         return uint256(_addressData[owner].balance);
615     }
616 
617     function _numberMinted(address owner) internal view returns (uint256) {
618         require(owner != address(0), 'ERC721A: number minted query for the zero address');
619         return uint256(_addressData[owner].numberMinted);
620     }
621 
622     /**
623      * Gas spent here starts off proportional to the maximum mint batch size.
624      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
625      */
626     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
627         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
628 
629         unchecked {
630             for (uint256 curr = tokenId; curr >= 0; curr--) {
631                 TokenOwnership memory ownership = _ownerships[curr];
632                 if (ownership.addr != address(0)) {
633                     return ownership;
634                 }
635             }
636         }
637 
638         revert('ERC721A: unable to determine the owner of token');
639     }
640 
641     /**
642      * @dev See {IERC721-ownerOf}.
643      */
644     function ownerOf(uint256 tokenId) public view override returns (address) {
645         return ownershipOf(tokenId).addr;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, can be overriden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return '';
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public override {
685         address owner = ERC721A.ownerOf(tokenId);
686         require(to != owner, 'ERC721A: approval to current owner');
687 
688         require(
689             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
690             'ERC721A: approve caller is not owner nor approved for all'
691         );
692 
693         _approve(to, tokenId, owner);
694     }
695 
696     /**
697      * @dev See {IERC721-getApproved}.
698      */
699     function getApproved(uint256 tokenId) public view override returns (address) {
700         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     /**
706      * @dev See {IERC721-setApprovalForAll}.
707      */
708     function setApprovalForAll(address operator, bool approved) public override {
709         require(operator != _msgSender(), 'ERC721A: approve to caller');
710 
711         _operatorApprovals[_msgSender()][operator] = approved;
712         emit ApprovalForAll(_msgSender(), operator, approved);
713     }
714 
715     /**
716      * @dev See {IERC721-isApprovedForAll}.
717      */
718     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[owner][operator];
720     }
721 
722     /**
723      * @dev See {IERC721-transferFrom}.
724      */
725     function transferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public override {
730         _transfer(from, to, tokenId);
731     }
732 
733     /**
734      * @dev See {IERC721-safeTransferFrom}.
735      */
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) public override {
741         safeTransferFrom(from, to, tokenId, '');
742     }
743 
744     /**
745      * @dev See {IERC721-safeTransferFrom}.
746      */
747     function safeTransferFrom(
748         address from,
749         address to,
750         uint256 tokenId,
751         bytes memory _data
752     ) public override {
753         _transfer(from, to, tokenId);
754         require(
755             _checkOnERC721Received(from, to, tokenId, _data),
756             'ERC721A: transfer to non ERC721Receiver implementer'
757         );
758     }
759 
760     /**
761      * @dev Returns whether `tokenId` exists.
762      *
763      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
764      *
765      * Tokens start existing when they are minted (`_mint`),
766      */
767     function _exists(uint256 tokenId) internal view returns (bool) {
768         return tokenId < currentIndex;
769     }
770 
771     function _safeMint(address to, uint256 quantity) internal {
772         _safeMint(to, quantity, '');
773     }
774 
775     /**
776      * @dev Safely mints `quantity` tokens and transfers them to `to`.
777      *
778      * Requirements:
779      *
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
781      * - `quantity` must be greater than 0.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _safeMint(
786         address to,
787         uint256 quantity,
788         bytes memory _data
789     ) internal {
790         _mint(to, quantity, _data, true);
791     }
792 
793     /**
794      * @dev Mints `quantity` tokens and transfers them to `to`.
795      *
796      * Requirements:
797      *
798      * - `to` cannot be the zero address.
799      * - `quantity` must be greater than 0.
800      *
801      * Emits a {Transfer} event.
802      */
803     function _mint(
804         address to,
805         uint256 quantity,
806         bytes memory _data,
807         bool safe
808     ) internal {
809         uint256 startTokenId = currentIndex;
810         require(to != address(0), 'ERC721A: mint to the zero address');
811         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
812 
813         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
814 
815         // Overflows are incredibly unrealistic.
816         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
817         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
818         unchecked {
819             _addressData[to].balance += uint128(quantity);
820             _addressData[to].numberMinted += uint128(quantity);
821 
822             _ownerships[startTokenId].addr = to;
823             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
824 
825             uint256 updatedIndex = startTokenId;
826 
827             for (uint256 i; i < quantity; i++) {
828                 emit Transfer(address(0), to, updatedIndex);
829                 if (safe) {
830                     require(
831                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
832                         'ERC721A: transfer to non ERC721Receiver implementer'
833                     );
834                 }
835 
836                 updatedIndex++;
837             }
838 
839             currentIndex = updatedIndex;
840         }
841 
842         _afterTokenTransfers(address(0), to, startTokenId, quantity);
843     }
844 
845     /**
846      * @dev Transfers `tokenId` from `from` to `to`.
847      *
848      * Requirements:
849      *
850      * - `to` cannot be the zero address.
851      * - `tokenId` token must be owned by `from`.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _transfer(
856         address from,
857         address to,
858         uint256 tokenId
859     ) private {
860         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
861 
862         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
863             getApproved(tokenId) == _msgSender() ||
864             isApprovedForAll(prevOwnership.addr, _msgSender()));
865 
866         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
867 
868         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
869         require(to != address(0), 'ERC721A: transfer to the zero address');
870 
871         _beforeTokenTransfers(from, to, tokenId, 1);
872 
873         // Clear approvals from the previous owner
874         _approve(address(0), tokenId, prevOwnership.addr);
875 
876         // Underflow of the sender's balance is impossible because we check for
877         // ownership above and the recipient's balance can't realistically overflow.
878         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
879         unchecked {
880             _addressData[from].balance -= 1;
881             _addressData[to].balance += 1;
882 
883             _ownerships[tokenId].addr = to;
884             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
885 
886             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
887             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
888             uint256 nextTokenId = tokenId + 1;
889             if (_ownerships[nextTokenId].addr == address(0)) {
890                 if (_exists(nextTokenId)) {
891                     _ownerships[nextTokenId].addr = prevOwnership.addr;
892                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
893                 }
894             }
895         }
896 
897         emit Transfer(from, to, tokenId);
898         _afterTokenTransfers(from, to, tokenId, 1);
899     }
900 
901     /**
902      * @dev Approve `to` to operate on `tokenId`
903      *
904      * Emits a {Approval} event.
905      */
906     function _approve(
907         address to,
908         uint256 tokenId,
909         address owner
910     ) private {
911         _tokenApprovals[tokenId] = to;
912         emit Approval(owner, to, tokenId);
913     }
914 
915     /**
916      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
917      * The call is not executed if the target address is not a contract.
918      *
919      * @param from address representing the previous owner of the given token ID
920      * @param to target address that will receive the tokens
921      * @param tokenId uint256 ID of the token to be transferred
922      * @param _data bytes optional data to send along with the call
923      * @return bool whether the call correctly returned the expected magic value
924      */
925     function _checkOnERC721Received(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory _data
930     ) private returns (bool) {
931         if (to.isContract()) {
932             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
933                 return retval == IERC721Receiver(to).onERC721Received.selector;
934             } catch (bytes memory reason) {
935                 if (reason.length == 0) {
936                     revert('ERC721A: transfer to non ERC721Receiver implementer');
937                 } else {
938                     assembly {
939                         revert(add(32, reason), mload(reason))
940                     }
941                 }
942             }
943         } else {
944             return true;
945         }
946     }
947 
948     /**
949      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
950      *
951      * startTokenId - the first token id to be transferred
952      * quantity - the amount to be transferred
953      *
954      * Calling conditions:
955      *
956      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
957      * transferred to `to`.
958      * - When `from` is zero, `tokenId` will be minted for `to`.
959      */
960     function _beforeTokenTransfers(
961         address from,
962         address to,
963         uint256 startTokenId,
964         uint256 quantity
965     ) internal virtual {}
966 
967     /**
968      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
969      * minting.
970      *
971      * startTokenId - the first token id to be transferred
972      * quantity - the amount to be transferred
973      *
974      * Calling conditions:
975      *
976      * - when `from` and `to` are both non-zero.
977      * - `from` and `to` are never both zero.
978      */
979     function _afterTokenTransfers(
980         address from,
981         address to,
982         uint256 startTokenId,
983         uint256 quantity
984     ) internal virtual {}
985 }
986 
987 pragma solidity >=0.7.0 <0.9.0;
988 
989 contract GoblinTownTownsNFT is ERC721A, Ownable {
990 
991   using Strings for uint256;
992   string baseURI="ipfs://addCID/";
993   string public baseExtension = ".json";
994   string public notRevealedUri;
995   uint256 public cost = 0.00 ether;
996   uint256 public maxTowns = 9999;
997   uint256 public dontBGreedy = 1;
998   uint256 public townsClaimed;
999   bool public claimStopped = true;
1000   bool public showTowns = false;
1001   mapping(address => uint256) private _townOwner;
1002   constructor() ERC721A("Goblin Town Towns", "GBLNTWN") {
1003     setSecretLink("ipfs://QmS9wfN25kWgvryHUC3Wt6Kynq3HLNt23cbVBbEHCqtyFe/hidden.json");
1004   }
1005 function _baseURI() internal view virtual override returns (string memory) {
1006     return baseURI;
1007   }
1008 function ClaimGoblinTownTowns(uint256 _mintAmount) public payable {
1009     uint256 mintSupply = totalSupply();
1010     uint256 oneAtATime =1;
1011     mintSupply=totalSupply();
1012     require(_townOwner[msg.sender]< dontBGreedy,"already got a town");
1013     require(!claimStopped, "Contract is not active");
1014     require(_mintAmount > 0, "Cannot mint 0");
1015     require(_mintAmount <= oneAtATime, "Dont be Greedy");
1016     require(mintSupply + _mintAmount <= maxTowns, "Exceeds Max Supply");
1017     require(msg.value >= cost * _mintAmount);
1018 
1019       _safeMint(msg.sender, oneAtATime);
1020    
1021     townsClaimed+= oneAtATime;
1022     _townOwner[msg.sender] +=1;
1023   
1024   }
1025 function makeTownFly(address recieving , uint256 numberOfTokens) public onlyOwner {
1026     uint256 currentSupply = totalSupply();
1027     require(currentSupply + numberOfTokens <= maxTowns, "Exceeds max availbe to buy");
1028  
1029         _safeMint(recieving, numberOfTokens);
1030 
1031   
1032     townsClaimed+=numberOfTokens;
1033  }
1034 
1035 function walletOfOwner(address _owner)
1036     public
1037     view
1038     returns (uint256[] memory)
1039   {
1040     uint256 ownerTokenCount = balanceOf(_owner);
1041     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1042     uint256 currentTokenId = 1;
1043     uint256 ownedTokenIndex = 0;
1044 
1045     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxTowns) {
1046       address currentTokenOwner = ownerOf(currentTokenId);
1047       if (currentTokenOwner == _owner) {
1048         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1049         ownedTokenIndex++;
1050       }
1051       currentTokenId++;
1052     }
1053     return ownedTokenIds;
1054   }
1055 function tokenURI(uint256 tokenId)
1056     public
1057     view
1058     virtual
1059     override
1060     returns (string memory)
1061   {
1062     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1063     if(showTowns == false) {
1064         return notRevealedUri;
1065     }
1066     if(tokenId>townsClaimed) {
1067         return notRevealedUri;
1068     }
1069     string memory currentBaseURI = _baseURI();
1070     return bytes(currentBaseURI).length > 0
1071         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1072         : "";
1073   }
1074 function seeTowns(bool _newBool) public onlyOwner() {
1075       showTowns = _newBool;
1076   }
1077 function setSecretLink(string memory _notRevealedURI) public onlyOwner {
1078     notRevealedUri = _notRevealedURI;
1079   }
1080 function setNotSecretLink(string memory _newBaseURI) public onlyOwner {
1081     baseURI = _newBaseURI;
1082   }
1083 function addPieces(string memory _newBaseExtension) public onlyOwner {
1084     baseExtension = _newBaseExtension;
1085   }
1086 function GoblinTownTownsGo(bool _state) public onlyOwner {
1087     claimStopped = _state;
1088   }
1089 function onlyDown(uint256 _newDigits) public onlyOwner{
1090     if(_newDigits<maxTowns){
1091     maxTowns=_newDigits;
1092     }
1093 }
1094 function townChanges(uint256 _changes) public onlyOwner{
1095     dontBGreedy=_changes;
1096     }
1097 function whatMoneyItsFree() public payable onlyOwner {
1098     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1099     require(success);
1100   }
1101 }