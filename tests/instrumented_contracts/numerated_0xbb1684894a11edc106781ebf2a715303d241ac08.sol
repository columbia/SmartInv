1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3 pragma solidity ^0.8.0;
4 interface IERC165 {
5     function supportsInterface(bytes4 interfaceId) external view returns (bool);
6 }
7 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
8 pragma solidity ^0.8.0;
9 interface IERC721 is IERC165 {
10     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
11     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
12     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
13     function balanceOf(address owner) external view returns (uint256 balance);
14     function ownerOf(uint256 tokenId) external view returns (address owner);
15     function safeTransferFrom(
16         address from,
17         address to,
18         uint256 tokenId
19     ) external;
20     function transferFrom(
21         address from,
22         address to,
23         uint256 tokenId
24     ) external;
25     function approve(address to, uint256 tokenId) external;
26     function getApproved(uint256 tokenId) external view returns (address operator);
27     function setApprovalForAll(address operator, bool _approved) external;
28     function isApprovedForAll(address owner, address operator) external view returns (bool);
29     function safeTransferFrom(
30         address from,
31         address to,
32         uint256 tokenId,
33         bytes calldata data
34     ) external;
35 }
36 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
37 pragma solidity ^0.8.0;
38 interface IERC721Metadata is IERC721 {
39     function name() external view returns (string memory);
40 
41     function symbol() external view returns (string memory);
42 
43     function tokenURI(uint256 tokenId) external view returns (string memory);
44 }
45 
46 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
47 
48 pragma solidity ^0.8.0;
49 
50 abstract contract ERC165 is IERC165 {
51     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
52         return interfaceId == type(IERC165).interfaceId;
53     }
54 }
55 // File: @openzeppelin/contracts/utils/Context.sol
56 pragma solidity ^0.8.0;
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 
62     function _msgData() internal view virtual returns (bytes calldata) {
63         return msg.data;
64     }
65 }
66 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
67 pragma solidity ^0.8.0;
68 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
69     using Address for address;
70     using Strings for uint256;
71     string private _name;
72     string private _symbol;
73     mapping(uint256 => address) private _owners;
74     mapping(address => uint256) private _balances;
75     mapping(uint256 => address) private _tokenApprovals;
76     mapping(address => mapping(address => bool)) private _operatorApprovals;
77     constructor(string memory name_, string memory symbol_) {
78         _name = name_;
79         _symbol = symbol_;
80     }
81     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
82         return
83             interfaceId == type(IERC721).interfaceId ||
84             interfaceId == type(IERC721Metadata).interfaceId ||
85             super.supportsInterface(interfaceId);
86     }
87     function balanceOf(address owner) public view virtual override returns (uint256) {
88         require(owner != address(0), "ERC721: balance query for the zero address");
89         return _balances[owner];
90     }
91     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
92         address owner = _owners[tokenId];
93         require(owner != address(0), "ERC721: owner query for nonexistent token");
94         return owner;
95     }
96     function name() public view virtual override returns (string memory) {
97         return _name;
98     }
99     function symbol() public view virtual override returns (string memory) {
100         return _symbol;
101     }
102     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
103         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
104 
105         string memory baseURI = _baseURI();
106         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
107     }
108     function _baseURI() internal view virtual returns (string memory) {
109         return "";
110     }
111     function approve(address to, uint256 tokenId) public virtual override {
112         address owner = ERC721.ownerOf(tokenId);
113         require(to != owner, "ERC721: approval to current owner");
114 
115         require(
116             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
117             "ERC721: approve caller is not owner nor approved for all"
118         );
119 
120         _approve(to, tokenId);
121     }
122     function getApproved(uint256 tokenId) public view virtual override returns (address) {
123         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
124 
125         return _tokenApprovals[tokenId];
126     }
127 
128     function setApprovalForAll(address operator, bool approved) public virtual override {
129         require(operator != _msgSender(), "ERC721: approve to caller");
130 
131         _operatorApprovals[_msgSender()][operator] = approved;
132         emit ApprovalForAll(_msgSender(), operator, approved);
133     }
134 
135     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
136         return _operatorApprovals[owner][operator];
137     }
138 
139     function transferFrom(
140         address from,
141         address to,
142         uint256 tokenId
143     ) public virtual override {
144         //solhint-disable-next-line max-line-length
145         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
146 
147         _transfer(from, to, tokenId);
148     }
149 
150     function safeTransferFrom(
151         address from,
152         address to,
153         uint256 tokenId
154     ) public virtual override {
155         safeTransferFrom(from, to, tokenId, "");
156     }
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId,
161         bytes memory _data
162     ) public virtual override {
163         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
164         _safeTransfer(from, to, tokenId, _data);
165     }
166     function _safeTransfer(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes memory _data
171     ) internal virtual {
172         _transfer(from, to, tokenId);
173         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
174     }
175     function _exists(uint256 tokenId) internal view virtual returns (bool) {
176         return _owners[tokenId] != address(0);
177     }
178     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
179         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
180         address owner = ERC721.ownerOf(tokenId);
181         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
182     }
183     function _safeMint(address to, uint256 tokenId) internal virtual {
184         _safeMint(to, tokenId, "");
185     }
186     function _safeMint(
187         address to,
188         uint256 tokenId,
189         bytes memory _data
190     ) internal virtual {
191         _mint(to, tokenId);
192         require(
193             _checkOnERC721Received(address(0), to, tokenId, _data),
194             "ERC721: transfer to non ERC721Receiver implementer"
195         );
196     }
197     function _mint(address to, uint256 tokenId) internal virtual {
198         require(to != address(0), "ERC721: mint to the zero address");
199         require(!_exists(tokenId), "ERC721: token already minted");
200 
201         _beforeTokenTransfer(address(0), to, tokenId);
202 
203         _balances[to] += 1;
204         _owners[tokenId] = to;
205 
206         emit Transfer(address(0), to, tokenId);
207     }
208     function _burn(uint256 tokenId) internal virtual {
209         address owner = ERC721.ownerOf(tokenId);
210 
211         _beforeTokenTransfer(owner, address(0), tokenId);
212 
213         _approve(address(0), tokenId);
214 
215         _balances[owner] -= 1;
216         delete _owners[tokenId];
217 
218         emit Transfer(owner, address(0), tokenId);
219     }
220     function _transfer(
221         address from,
222         address to,
223         uint256 tokenId
224     ) internal virtual {
225         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
226         require(to != address(0), "ERC721: transfer to the zero address");
227         _beforeTokenTransfer(from, to, tokenId);
228         _approve(address(0), tokenId);
229         _balances[from] -= 1;
230         _balances[to] += 1;
231         _owners[tokenId] = to;
232         emit Transfer(from, to, tokenId);
233     }
234     function _approve(address to, uint256 tokenId) internal virtual {
235         _tokenApprovals[tokenId] = to;
236         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
237     }
238     function _checkOnERC721Received(
239         address from,
240         address to,
241         uint256 tokenId,
242         bytes memory _data
243     ) private returns (bool) {
244         if (to.isContract()) {
245             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
246                 return retval == IERC721Receiver.onERC721Received.selector;
247             } catch (bytes memory reason) {
248                 if (reason.length == 0) {
249                     revert("ERC721: transfer to non ERC721Receiver implementer");
250                 } else {
251                     assembly {
252                         revert(add(32, reason), mload(reason))
253                     }
254                 }
255             }
256         } else {
257             return true;
258         }
259     }
260     function _beforeTokenTransfer(
261         address from,
262         address to,
263         uint256 tokenId
264     ) internal virtual {}
265 }
266 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
267 pragma solidity ^0.8.0;
268 library ECDSA {
269     enum RecoverError {
270         NoError,
271         InvalidSignature,
272         InvalidSignatureLength,
273         InvalidSignatureS,
274         InvalidSignatureV
275     }
276     function _throwError(RecoverError error) private pure {
277         if (error == RecoverError.NoError) {
278             return; // no error: do nothing
279         } else if (error == RecoverError.InvalidSignature) {
280             revert("ECDSA: invalid signature");
281         } else if (error == RecoverError.InvalidSignatureLength) {
282             revert("ECDSA: invalid signature length");
283         } else if (error == RecoverError.InvalidSignatureS) {
284             revert("ECDSA: invalid signature 's' value");
285         } else if (error == RecoverError.InvalidSignatureV) {
286             revert("ECDSA: invalid signature 'v' value");
287         }
288     }
289     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
290         if (signature.length == 65) {
291             bytes32 r;
292             bytes32 s;
293             uint8 v;
294             assembly {
295                 r := mload(add(signature, 0x20))
296                 s := mload(add(signature, 0x40))
297                 v := byte(0, mload(add(signature, 0x60)))
298             }
299             return tryRecover(hash, v, r, s);
300         } else if (signature.length == 64) {
301             bytes32 r;
302             bytes32 vs;
303             assembly {
304                 r := mload(add(signature, 0x20))
305                 vs := mload(add(signature, 0x40))
306             }
307             return tryRecover(hash, r, vs);
308         } else {
309             return (address(0), RecoverError.InvalidSignatureLength);
310         }
311     }
312     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
313         (address recovered, RecoverError error) = tryRecover(hash, signature);
314         _throwError(error);
315         return recovered;
316     }
317     function tryRecover(
318         bytes32 hash,
319         bytes32 r,
320         bytes32 vs
321     ) internal pure returns (address, RecoverError) {
322         bytes32 s;
323         uint8 v;
324         assembly {
325             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
326             v := add(shr(255, vs), 27)
327         }
328         return tryRecover(hash, v, r, s);
329     }
330     function recover(
331         bytes32 hash,
332         bytes32 r,
333         bytes32 vs
334     ) internal pure returns (address) {
335         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
336         _throwError(error);
337         return recovered;
338     }
339     function tryRecover(
340         bytes32 hash,
341         uint8 v,
342         bytes32 r,
343         bytes32 s
344     ) internal pure returns (address, RecoverError) {
345         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
346             return (address(0), RecoverError.InvalidSignatureS);
347         }
348         if (v != 27 && v != 28) {
349             return (address(0), RecoverError.InvalidSignatureV);
350         }
351         address signer = ecrecover(hash, v, r, s);
352         if (signer == address(0)) {
353             return (address(0), RecoverError.InvalidSignature);
354         }
355 
356         return (signer, RecoverError.NoError);
357     }
358     function recover(
359         bytes32 hash,
360         uint8 v,
361         bytes32 r,
362         bytes32 s
363     ) internal pure returns (address) {
364         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
365         _throwError(error);
366         return recovered;
367     }
368     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
369         // 32 is the length in bytes of hash,
370         // enforced by the type signature above
371         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
372     }
373     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
374         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
375     }
376 }
377 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
378 pragma solidity ^0.8.0;
379 interface IERC721Enumerable is IERC721 {
380     function totalSupply() external view returns (uint256);
381     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
382     function tokenByIndex(uint256 index) external view returns (uint256);
383 }
384 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
385 pragma solidity ^0.8.0;
386 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
387     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
388     mapping(uint256 => uint256) private _ownedTokensIndex;
389     uint256[] private _allTokens;
390     mapping(uint256 => uint256) private _allTokensIndex;
391     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
392         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
393     }
394     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
395         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
396         return _ownedTokens[owner][index];
397     }
398     function totalSupply() public view virtual override returns (uint256) {
399         return _allTokens.length;
400     }
401     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
402         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
403         return _allTokens[index];
404     }
405     function _beforeTokenTransfer(
406         address from,
407         address to,
408         uint256 tokenId
409     ) internal virtual override {
410         super._beforeTokenTransfer(from, to, tokenId);
411 
412         if (from == address(0)) {
413             _addTokenToAllTokensEnumeration(tokenId);
414         } else if (from != to) {
415             _removeTokenFromOwnerEnumeration(from, tokenId);
416         }
417         if (to == address(0)) {
418             _removeTokenFromAllTokensEnumeration(tokenId);
419         } else if (to != from) {
420             _addTokenToOwnerEnumeration(to, tokenId);
421         }
422     }
423     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
424         uint256 length = ERC721.balanceOf(to);
425         _ownedTokens[to][length] = tokenId;
426         _ownedTokensIndex[tokenId] = length;
427     }
428     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
429         _allTokensIndex[tokenId] = _allTokens.length;
430         _allTokens.push(tokenId);
431     }
432     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
433         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
434         uint256 tokenIndex = _ownedTokensIndex[tokenId];
435 
436         if (tokenIndex != lastTokenIndex) {
437             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
438 
439             _ownedTokens[from][tokenIndex] = lastTokenId;
440             _ownedTokensIndex[lastTokenId] = tokenIndex;
441         }
442 
443         delete _ownedTokensIndex[tokenId];
444         delete _ownedTokens[from][lastTokenIndex];
445     }
446     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
447         uint256 lastTokenIndex = _allTokens.length - 1;
448         uint256 tokenIndex = _allTokensIndex[tokenId];
449         uint256 lastTokenId = _allTokens[lastTokenIndex];
450 
451         _allTokens[tokenIndex] = lastTokenId;
452         _allTokensIndex[lastTokenId] = tokenIndex;
453 
454         delete _allTokensIndex[tokenId];
455         _allTokens.pop();
456     }
457 }
458 // File: @openzeppelin/contracts/utils/Strings.sol
459 pragma solidity ^0.8.0;
460 library Strings {
461     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
462     function toString(uint256 value) internal pure returns (string memory) {
463         if (value == 0) {
464             return "0";
465         }
466         uint256 temp = value;
467         uint256 digits;
468         while (temp != 0) {
469             digits++;
470             temp /= 10;
471         }
472         bytes memory buffer = new bytes(digits);
473         while (value != 0) {
474             digits -= 1;
475             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
476             value /= 10;
477         }
478         return string(buffer);
479     }
480     function toHexString(uint256 value) internal pure returns (string memory) {
481         if (value == 0) {
482             return "0x00";
483         }
484         uint256 temp = value;
485         uint256 length = 0;
486         while (temp != 0) {
487             length++;
488             temp >>= 8;
489         }
490         return toHexString(value, length);
491     }
492     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
493         bytes memory buffer = new bytes(2 * length + 2);
494         buffer[0] = "0";
495         buffer[1] = "x";
496         for (uint256 i = 2 * length + 1; i > 1; --i) {
497             buffer[i] = _HEX_SYMBOLS[value & 0xf];
498             value >>= 4;
499         }
500         require(value == 0, "Strings: hex length insufficient");
501         return string(buffer);
502     }
503 }
504 // File: @openzeppelin/contracts/utils/Address.sol
505 pragma solidity ^0.8.0;
506 library Address {
507     function isContract(address account) internal view returns (bool) {
508         uint256 size;
509         assembly {
510             size := extcodesize(account)
511         }
512         return size > 0;
513     }
514     function sendValue(address payable recipient, uint256 amount) internal {
515         require(address(this).balance >= amount, "Address: insufficient balance");
516 
517         (bool success, ) = recipient.call{value: amount}("");
518         require(success, "Address: unable to send value, recipient may have reverted");
519     }
520     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
521         return functionCall(target, data, "Address: low-level call failed");
522     }
523     function functionCall(
524         address target,
525         bytes memory data,
526         string memory errorMessage
527     ) internal returns (bytes memory) {
528         return functionCallWithValue(target, data, 0, errorMessage);
529     }
530     function functionCallWithValue(
531         address target,
532         bytes memory data,
533         uint256 value
534     ) internal returns (bytes memory) {
535         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
536     }
537     function functionCallWithValue(
538         address target,
539         bytes memory data,
540         uint256 value,
541         string memory errorMessage
542     ) internal returns (bytes memory) {
543         require(address(this).balance >= value, "Address: insufficient balance for call");
544         require(isContract(target), "Address: call to non-contract");
545 
546         (bool success, bytes memory returndata) = target.call{value: value}(data);
547         return verifyCallResult(success, returndata, errorMessage);
548     }
549     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
550         return functionStaticCall(target, data, "Address: low-level static call failed");
551     }
552     function functionStaticCall(
553         address target,
554         bytes memory data,
555         string memory errorMessage
556     ) internal view returns (bytes memory) {
557         require(isContract(target), "Address: static call to non-contract");
558 
559         (bool success, bytes memory returndata) = target.staticcall(data);
560         return verifyCallResult(success, returndata, errorMessage);
561     }
562     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
563         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
564     }
565     function functionDelegateCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal returns (bytes memory) {
570         require(isContract(target), "Address: delegate call to non-contract");
571 
572         (bool success, bytes memory returndata) = target.delegatecall(data);
573         return verifyCallResult(success, returndata, errorMessage);
574     }
575     function verifyCallResult(
576         bool success,
577         bytes memory returndata,
578         string memory errorMessage
579     ) internal pure returns (bytes memory) {
580         if (success) {
581             return returndata;
582         } else {
583             if (returndata.length > 0) {
584                 assembly {
585                     let returndata_size := mload(returndata)
586                     revert(add(32, returndata), returndata_size)
587                 }
588             } else {
589                 revert(errorMessage);
590             }
591         }
592     }
593 }
594 
595 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
596 pragma solidity ^0.8.0;
597 interface IERC721Receiver {
598     function onERC721Received(
599         address operator,
600         address from,
601         uint256 tokenId,
602         bytes calldata data
603     ) external returns (bytes4);
604 }
605 
606 // File: @openzeppelin/contracts/access/Ownable.sol
607 pragma solidity ^0.8.0;
608 abstract contract Ownable is Context {
609     address private _owner;
610     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
611     constructor() {
612         _setOwner(_msgSender());
613     }
614     function owner() public view virtual returns (address) {
615         return _owner;
616     }
617     modifier onlyOwner() {
618         require(owner() == _msgSender(), "Ownable: caller is not the owner");
619         _;
620     }
621     function renounceOwnership() public virtual onlyOwner {
622         _setOwner(address(0));
623     }
624     function transferOwnership(address newOwner) public virtual onlyOwner {
625         require(newOwner != address(0), "Ownable: new owner is the zero address");
626         _setOwner(newOwner);
627     }
628 
629     function _setOwner(address newOwner) private {
630         address oldOwner = _owner;
631         _owner = newOwner;
632         emit OwnershipTransferred(oldOwner, newOwner);
633     }
634 }
635 
636 // File: contracts/Femverse.sol
637 // Written by: @zestrells
638 pragma solidity ^0.8.4;
639 
640 contract Femverse is ERC721Enumerable, Ownable {
641     using Strings for uint256;
642     using ECDSA for bytes32;
643     uint256 public FEMVERSE_GIFT = 555; // first 555 NFTs free
644     // uint256 public FEMVERSE_PRESALE = 0;
645     uint256 public FEMVERSE_PUBLIC = 5000;
646     // uint256 public FEMVERSE_MAX = FEMVERSE_GIFT + FEMVERSE_PRESALE + FEMVERSE_PUBLIC;
647     uint256 public FEMVERSE_MAX = FEMVERSE_GIFT + FEMVERSE_PUBLIC;
648     uint256 public FEMVERSE_PRICE = .0555 ether;
649     uint256 public FEMVERSE_FREE_PRICE = 0 ether;
650     // uint256 public FEMVERSE_PRESALE_PRICE = .03 ether;
651     uint256 public FEMVERSE_PER_MINT = 5;
652     uint256 public constant FEMVERSE_PER_FREE_MINT = 1;
653     // mapping(address => bool) public presalerList;
654     // mapping(address => uint256) public presalerListPurchases;
655     string private _tokenBaseURI = "https://mint.femverse.org/api/";
656     uint256 public giftedAmount;
657     uint256 public publicAmountMinted;
658     // uint256 public privateAmountMinted;
659     // uint256 public presalePurchaseLimit = 13;
660     // bool public presaleLive;
661     bool public saleLive;
662     constructor() ERC721("FemVerse", "Fem") payable { }
663     // function addToPresaleList(address[] calldata entries) external onlyOwner {
664     //     for(uint256 i = 0; i < entries.length; i++) {
665     //         address entry = entries[i];
666     //         require(entry != address(0), "NULL_ADDRESS");
667     //         require(!presalerList[entry], "DUPLICATE_ENTRY");
668     //         presalerList[entry] = true;
669     //     }
670     // }
671     // function removeFromPresaleList(address[] calldata entries) external onlyOwner {
672     //     for(uint256 i = 0; i < entries.length; i++) {
673     //         address entry = entries[i];
674     //         require(entry != address(0), "NULL_ADDRESS");
675     //         presalerList[entry] = false;
676     //     }
677     // }
678     // function togglePresaleStatus() external onlyOwner {
679     //     presaleLive = !presaleLive;
680     // }
681     function toggleSaleStatus() external onlyOwner {
682         saleLive = !saleLive;
683     }
684     function buy(uint256 tokenQuantity) external payable {
685         require(saleLive, "SALE_CLOSED");
686         // require(!presaleLive, "ONLY_PRESALE");
687         require((totalSupply() + 1) < FEMVERSE_MAX, "Out of stock.");
688         require(publicAmountMinted + tokenQuantity <= FEMVERSE_PUBLIC, "EXCEED_PUBLIC");
689         require(tokenQuantity <= FEMVERSE_PER_MINT, "EXCEED_FEMVERSE_PER_MINT");
690         for(uint i = 0; i < tokenQuantity; i++) {
691             uint _mintId = totalSupply() + 1; // iterate from 1
692             // if (_mintId > 100 && _mintId < 301) {
693             if (_mintId < 555) {
694                 require(tokenQuantity <= FEMVERSE_PER_FREE_MINT, "EXCEED_FEMVERSE_PER_FREE_MINT");
695                 _safeMint(msg.sender, _mintId);
696                 publicAmountMinted++;
697             } else {
698                 require(FEMVERSE_PRICE * tokenQuantity <= msg.value, "Insufficient ETH.");
699                 _safeMint(msg.sender, _mintId);
700                 publicAmountMinted++;
701             }
702         }
703     }
704     // function presaleBuy(uint256 tokenQuantity) external payable {
705     //     // require(!saleLive && presaleLive, "The presale has finished.");
706     //     require(presalerList[msg.sender], "You are not qualified for the presale.");
707     //     require((totalSupply() + 1) < FEMVERSE_MAX, "Out of stock.");
708     //     require(privateAmountMinted + tokenQuantity <= FEMVERSE_PRESALE, "EXCEED_PRIVATE");
709     //     require(presalerListPurchases[msg.sender] + tokenQuantity <= presalePurchaseLimit, "You have reached your maximum purchase amount.");
710     //     require(FEMVERSE_PRESALE_PRICE * tokenQuantity <= msg.value, "Insufficient ETH.");
711     //     for (uint256 i = 0; i < tokenQuantity; i++) {
712     //         uint _mintId = totalSupply() + 1; // iterate from 1
713     //         presalerListPurchases[msg.sender]++;
714     //         _safeMint(msg.sender, _mintId);
715     //         privateAmountMinted++;
716     //     }
717     // }
718     function gift(address[] calldata receivers) external onlyOwner {
719         require((totalSupply() + 1) + receivers.length <= FEMVERSE_MAX, "MAX_MINT");
720         require(giftedAmount + receivers.length <= FEMVERSE_GIFT, "GIFTS_EMPTY");
721         for (uint256 i = 0; i < receivers.length; i++) {
722             uint _mintId = totalSupply() + 1; // iterate from 1
723             _safeMint(receivers[i], _mintId);
724             giftedAmount++;
725         }
726     }
727     function withdrawTeam() external onlyOwner {
728         uint balance = address(this).balance;
729         payable(msg.sender).transfer(balance);
730     }
731     // function isPresaler(address addr) external view returns (bool) {
732     //     return presalerList[addr];
733     // }
734     // function presalePurchasedCount(address addr) external view returns (uint256) {
735     //     return presalerListPurchases[addr];
736     // }
737     function setBaseURI(string calldata URI) external onlyOwner {
738         _tokenBaseURI = URI;
739     }
740     // function setPresaleAmount(uint256 number) external onlyOwner {
741     //     FEMVERSE_PRESALE = number;
742     //     FEMVERSE_MAX = FEMVERSE_GIFT + FEMVERSE_PRESALE + FEMVERSE_PUBLIC;
743     // }
744     function setPublicAmount(uint256 number) external onlyOwner {
745         FEMVERSE_PUBLIC = number;
746         // FEMVERSE_MAX = FEMVERSE_GIFT + FEMVERSE_PRESALE + FEMVERSE_PUBLIC;
747         FEMVERSE_MAX = FEMVERSE_GIFT + FEMVERSE_PUBLIC;
748     }
749     function setGiftAmount(uint256 number) external onlyOwner {
750         FEMVERSE_GIFT = number;
751         // FEMVERSE_MAX = FEMVERSE_GIFT + FEMVERSE_PRESALE + FEMVERSE_PUBLIC;
752         FEMVERSE_MAX = FEMVERSE_GIFT + FEMVERSE_PUBLIC;
753     }
754     function setFemVersePerMint(uint256 number) external onlyOwner {
755         FEMVERSE_PER_MINT = number;
756     }
757     function setPrice(uint256 number) external onlyOwner {
758         FEMVERSE_PRICE = number;
759     }
760     // function setPresalePrice(uint256 number) external onlyOwner {
761     //     FEMVERSE_PRESALE_PRICE = number;
762     // }
763     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
764         require(_exists(tokenId), "Cannot query non-existent token");
765         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
766     }
767 }