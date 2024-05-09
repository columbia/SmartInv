1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 abstract contract ReentrancyGuard {
5     uint256 private constant _NOT_ENTERED = 1;
6     uint256 private constant _ENTERED = 2;
7     uint256 private _status;
8 
9     constructor() {
10         _status = _NOT_ENTERED;
11     }
12 
13     modifier nonReentrant() {
14         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
15         _status = _ENTERED;
16         _;
17         _status = _NOT_ENTERED;
18     }
19 }
20 
21 interface IERC721Receiver {
22     function onERC721Received(
23         address operator,
24         address from,
25         uint256 tokenId,
26         bytes calldata data
27     ) external returns (bytes4);
28 }
29 
30 
31 library Address {
32 
33     function isContract(address account) internal view returns (bool) {
34         uint256 size;
35         assembly {
36             size := extcodesize(account)
37         }
38         return size > 0;
39     }
40 
41     function sendValue(address payable recipient, uint256 amount) internal {
42         require(address(this).balance >= amount, "Address: insufficient balance");
43         (bool success, ) = recipient.call{value: amount}("");
44         require(success, "Address: unable to send value, recipient may have reverted");
45     }
46 
47     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
48         return functionCall(target, data, "Address: low-level call failed");
49     }
50 
51     function functionCall(
52         address target,
53         bytes memory data,
54         string memory errorMessage
55     ) internal returns (bytes memory) {
56         return functionCallWithValue(target, data, 0, errorMessage);
57     }
58 
59     function functionCallWithValue(
60         address target,
61         bytes memory data,
62         uint256 value
63     ) internal returns (bytes memory) {
64         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
65     }
66 
67     function functionCallWithValue(
68         address target,
69         bytes memory data,
70         uint256 value,
71         string memory errorMessage
72     ) internal returns (bytes memory) {
73         require(address(this).balance >= value, "Address: insufficient balance for call");
74         require(isContract(target), "Address: call to non-contract");
75         (bool success, bytes memory returndata) = target.call{value: value}(data);
76         return verifyCallResult(success, returndata, errorMessage);
77     }
78 
79     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
80         return functionStaticCall(target, data, "Address: low-level static call failed");
81     }
82 
83     function functionStaticCall(
84         address target,
85         bytes memory data,
86         string memory errorMessage
87     ) internal view returns (bytes memory) {
88         require(isContract(target), "Address: static call to non-contract");
89         (bool success, bytes memory returndata) = target.staticcall(data);
90         return verifyCallResult(success, returndata, errorMessage);
91     }
92 
93     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
94         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
95     }
96 
97     function functionDelegateCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         require(isContract(target), "Address: delegate call to non-contract");
103         (bool success, bytes memory returndata) = target.delegatecall(data);
104         return verifyCallResult(success, returndata, errorMessage);
105     }
106 
107     function verifyCallResult(
108         bool success,
109         bytes memory returndata,
110         string memory errorMessage
111     ) internal pure returns (bytes memory) {
112         if (success) {
113             return returndata;
114         } else {
115             if (returndata.length > 0) {
116                 assembly {
117                     let returndata_size := mload(returndata)
118                     revert(add(32, returndata), returndata_size)
119                 }
120             } else {
121                 revert(errorMessage);
122             }
123         }
124     }
125 }
126 
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         return msg.data;
134     }
135 }
136 
137 library Strings {
138     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
139     function toString(uint256 value) internal pure returns (string memory) {
140         if (value == 0) {
141             return "0";
142         }
143         uint256 temp = value;
144         uint256 digits;
145         while (temp != 0) {
146             digits++;
147             temp /= 10;
148         }
149         bytes memory buffer = new bytes(digits);
150         while (value != 0) {
151             digits -= 1;
152             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
153             value /= 10;
154         }
155         return string(buffer);
156     }
157 
158     function toHexString(uint256 value) internal pure returns (string memory) {
159         if (value == 0) {
160             return "0x00";
161         }
162         uint256 temp = value;
163         uint256 length = 0;
164         while (temp != 0) {
165             length++;
166             temp >>= 8;
167         }
168         return toHexString(value, length);
169     }
170 
171     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
172         bytes memory buffer = new bytes(2 * length + 2);
173         buffer[0] = "0";
174         buffer[1] = "x";
175         for (uint256 i = 2 * length + 1; i > 1; --i) {
176             buffer[i] = _HEX_SYMBOLS[value & 0xf];
177             value >>= 4;
178         }
179         require(value == 0, "Strings: hex length insufficient");
180         return string(buffer);
181     }
182 }
183 
184 interface IERC165 {
185     function supportsInterface(bytes4 interfaceId) external view returns (bool);
186 }
187 
188 abstract contract ERC165 is IERC165 {
189     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
190         return interfaceId == type(IERC165).interfaceId;
191     }
192 }
193 
194 interface IERC721 is IERC165 {
195     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
196     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
197     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
198     function balanceOf(address owner) external view returns (uint256 balance);
199     function ownerOf(uint256 tokenId) external view returns (address owner);
200     function safeTransferFrom(
201         address from,
202         address to,
203         uint256 tokenId
204     ) external;
205 
206     function transferFrom(
207         address from,
208         address to,
209         uint256 tokenId
210     ) external;
211 
212     function approve(address to, uint256 tokenId) external;
213     function getApproved(uint256 tokenId) external view returns (address operator);
214     function setApprovalForAll(address operator, bool _approved) external;
215     function isApprovedForAll(address owner, address operator) external view returns (bool);
216     function safeTransferFrom(
217         address from,
218         address to,
219         uint256 tokenId,
220         bytes calldata data
221     ) external;
222 }
223 
224 interface IERC721Metadata is IERC721 {
225     function name() external view returns (string memory);
226     function symbol() external view returns (string memory);
227     function tokenURI(uint256 tokenId) external view returns (string memory);
228 }
229 
230 interface IERC721Enumerable is IERC721 {
231     function totalSupply() external view returns (uint256);
232     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
233     function tokenByIndex(uint256 index) external view returns (uint256);
234 }
235 
236 library MerkleProof {
237     
238     function verify(
239         bytes32[] memory proof,
240         bytes32 root,
241         bytes32 leaf
242     ) internal pure returns (bool) {
243         return processProof(proof, leaf) == root;
244     }
245 
246     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
247         bytes32 computedHash = leaf;
248         for (uint256 i = 0; i < proof.length; i++) {
249             bytes32 proofElement = proof[i];
250             if (computedHash <= proofElement) {
251                 // Hash(current computed hash + current element of the proof)
252                 computedHash = _efficientHash(computedHash, proofElement);
253             } else {
254                 // Hash(current element of the proof + current computed hash)
255                 computedHash = _efficientHash(proofElement, computedHash);
256             }
257         }
258         return computedHash;
259     }
260 
261     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
262         assembly {
263             mstore(0x00, a)
264             mstore(0x20, b)
265             value := keccak256(0x00, 0x40)
266         }
267     }
268 }
269 
270 abstract contract Ownable is Context {
271     address private _owner;
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273 
274     constructor() {
275         _setOwner(_msgSender());
276     }
277 
278     function owner() public view virtual returns (address) {
279         return _owner;
280     }
281 
282     modifier onlyOwner() {
283         require(owner() == _msgSender(), "Ownable: caller is not the owner");
284         _;
285     }
286 
287     function renounceOwnership() public virtual onlyOwner {
288         _setOwner(address(0));
289     }
290 
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         _setOwner(newOwner);
294     }
295 
296     function _setOwner(address newOwner) private {
297         address oldOwner = _owner;
298         _owner = newOwner;
299         emit OwnershipTransferred(oldOwner, newOwner);
300     }
301 }
302 
303 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
304     using Address for address;
305     string private _name;
306     string private _symbol;
307     address[] internal _owners;
308     mapping(uint256 => address) private _tokenApprovals;
309     mapping(address => mapping(address => bool)) private _operatorApprovals;     
310     constructor(string memory name_, string memory symbol_) {
311         _name = name_;
312         _symbol = symbol_;
313     }     
314     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
315         return
316             interfaceId == type(IERC721).interfaceId ||
317             interfaceId == type(IERC721Metadata).interfaceId ||
318             super.supportsInterface(interfaceId);
319     }
320     function balanceOf(address owner) public view virtual override returns (uint256) {
321         require(owner != address(0), "ERC721: balance query for the zero address");
322         uint count = 0;
323         uint length = _owners.length;
324         for( uint i = 0; i < length; ++i ){
325           if( owner == _owners[i] ){
326             ++count;
327           }
328         }
329         delete length;
330         return count;
331     }
332     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
333         address owner = _owners[tokenId];
334         require(owner != address(0), "ERC721: owner query for nonexistent token");
335         return owner;
336     }
337     function name() public view virtual override returns (string memory) {
338         return _name;
339     }
340     function symbol() public view virtual override returns (string memory) {
341         return _symbol;
342     }
343     function approve(address to, uint256 tokenId) public virtual override {
344         address owner = ERC721.ownerOf(tokenId);
345         require(to != owner, "ERC721: approval to current owner");
346         require(
347             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
348             "ERC721: approve caller is not owner nor approved for all"
349         );
350         _approve(to, tokenId);
351     }
352     function getApproved(uint256 tokenId) public view virtual override returns (address) {
353         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
354         return _tokenApprovals[tokenId];
355     }
356     function setApprovalForAll(address operator, bool approved) public virtual override {
357         require(operator != _msgSender(), "ERC721: approve to caller");
358         _operatorApprovals[_msgSender()][operator] = approved;
359         emit ApprovalForAll(_msgSender(), operator, approved);
360     }
361     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
362         return _operatorApprovals[owner][operator];
363     }
364     function transferFrom(
365         address from,
366         address to,
367         uint256 tokenId
368     ) public virtual override {
369         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
370         _transfer(from, to, tokenId);
371     }
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId
376     ) public virtual override {
377         safeTransferFrom(from, to, tokenId, "");
378     }
379     function safeTransferFrom(
380         address from,
381         address to,
382         uint256 tokenId,
383         bytes memory _data
384     ) public virtual override {
385         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
386         _safeTransfer(from, to, tokenId, _data);
387     }     
388     function _safeTransfer(
389         address from,
390         address to,
391         uint256 tokenId,
392         bytes memory _data
393     ) internal virtual {
394         _transfer(from, to, tokenId);
395         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
396     }
397 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
398         return tokenId < _owners.length && _owners[tokenId] != address(0);
399     }
400 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
401         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
402         address owner = ERC721.ownerOf(tokenId);
403         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
404     }
405 	function _safeMint(address to, uint256 tokenId) internal virtual {
406         _safeMint(to, tokenId, "");
407     }
408 	function _safeMint(
409         address to,
410         uint256 tokenId,
411         bytes memory _data
412     ) internal virtual {
413         _mint(to, tokenId);
414         require(
415             _checkOnERC721Received(address(0), to, tokenId, _data),
416             "ERC721: transfer to non ERC721Receiver implementer"
417         );
418     }
419 	function _mint(address to, uint256 tokenId) internal virtual {
420         require(to != address(0), "ERC721: mint to the zero address");
421         require(!_exists(tokenId), "ERC721: token already minted");
422         _beforeTokenTransfer(address(0), to, tokenId);
423         _owners.push(to);
424         emit Transfer(address(0), to, tokenId);
425     }
426 	function _burn(uint256 tokenId) internal virtual {
427         address owner = ERC721.ownerOf(tokenId);
428         _beforeTokenTransfer(owner, address(0), tokenId);
429         _approve(address(0), tokenId);
430         _owners[tokenId] = address(0);
431         emit Transfer(owner, address(0), tokenId);
432     }
433 	function _transfer(
434         address from,
435         address to,
436         uint256 tokenId
437     ) internal virtual {
438         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
439         require(to != address(0), "ERC721: transfer to the zero address");
440         _beforeTokenTransfer(from, to, tokenId);
441         _approve(address(0), tokenId);
442         _owners[tokenId] = to;
443         emit Transfer(from, to, tokenId);
444     }
445 	function _approve(address to, uint256 tokenId) internal virtual {
446         _tokenApprovals[tokenId] = to;
447         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
448     }
449 	function _checkOnERC721Received(
450         address from,
451         address to,
452         uint256 tokenId,
453         bytes memory _data
454     ) private returns (bool) {
455         if (to.isContract()) {
456             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
457                 return retval == IERC721Receiver.onERC721Received.selector;
458             } catch (bytes memory reason) {
459                 if (reason.length == 0) {
460                     revert("ERC721: transfer to non ERC721Receiver implementer");
461                 } else {
462                     assembly {
463                         revert(add(32, reason), mload(reason))
464                     }
465                 }
466             }
467         } else {
468             return true;
469         }
470     }
471 	function _beforeTokenTransfer(
472         address from,
473         address to,
474         uint256 tokenId
475     ) internal virtual {}
476 }
477 
478 abstract contract ERC721Enum is ERC721, IERC721Enumerable {
479     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
480         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
481     }
482     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
483         require(index < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
484         uint count;
485         for( uint i; i < _owners.length; ++i ){
486             if( owner == _owners[i] ){
487                 if( count == index )
488                     return i;
489                 else
490                     ++count;
491             }
492         }
493         require(false, "ERC721Enum: owner ioob");
494     }
495     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
496         require(0 < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
497         uint256 tokenCount = balanceOf(owner);
498         uint256[] memory tokenIds = new uint256[](tokenCount);
499         for (uint256 i = 0; i < tokenCount; i++) {
500             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
501         }
502         return tokenIds;
503     }
504     function totalSupply() public view virtual override returns (uint256) {
505         return _owners.length;
506     }
507     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
508         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
509         return index;
510     }
511 }
512 
513 contract DOADS is ERC721Enum, Ownable, ReentrancyGuard {
514 
515 	using Strings for uint256;
516 
517 	//sale settings
518     uint256 public maxWL;
519 	uint256 public maxMint;
520     bytes32 public whitelistRoot;
521 	uint256 public maxSupply = 6969;
522 	string public baseURI = "https://api.doads.io/doads/content/metadata/";
523 
524 	constructor() ERC721("DoadNFT", "DOAD"){
525 	setBaseURI(baseURI);
526 	}
527 
528 	function _baseURI() internal view virtual returns (string memory) {
529 	    return baseURI;
530 	}
531     function mint(uint256 _mintAmount) public nonReentrant{
532         require(balanceOf(msg.sender) + _mintAmount <= maxMint, "Limit");
533         require(_mintAmount > 0,"0" );
534         uint256 s = totalSupply();
535         require(s + _mintAmount <= maxSupply ,"Max" );
536         for (uint256 i = 0; i < _mintAmount; ++i) {
537         _safeMint(msg.sender, s + i, "");
538         }
539         delete s;
540 	}
541     function mintWL(uint256 _mintAmount,bytes32[] calldata proof) public nonReentrant{
542         require(isWhitelisted(msg.sender, proof), "Invalid");
543         require(balanceOf(msg.sender) + _mintAmount <= maxWL, "Limit");
544         require(_mintAmount > 0,"0" );
545         uint256 s = totalSupply();
546         require(s + _mintAmount <= maxSupply ,"Max" );
547         for (uint256 i = 0; i < _mintAmount; ++i) {
548         _safeMint(msg.sender, s + i, "");
549         }
550         delete s;
551 	}
552     function gift(address[] calldata recipient) external onlyOwner{
553 	    uint256 s = totalSupply();
554 	    require(s + recipient.length <= maxSupply, "Too many" );
555 	    for(uint i = 0; i < recipient.length; ++i){
556 	    _safeMint(recipient[i], s++, "" );
557 	    }
558 	    delete s;
559 	}
560 	function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
561 	    require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
562 	    string memory currentBaseURI = _baseURI();
563 	    return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
564 	}
565 	function isWhitelisted(address account, bytes32[] calldata proof) public view returns (bool) {
566         return _verify(_leaf(account), proof, whitelistRoot);
567     }
568     function setWhitelistRoot(bytes32 _root) external onlyOwner {
569         whitelistRoot = _root;
570     }
571     function _leaf(address account) internal pure returns (bytes32) {
572         return keccak256(abi.encodePacked(account));
573     }
574     function _verify(bytes32 leaf,bytes32[] calldata proof,bytes32 root) internal pure returns (bool) {
575         return MerkleProof.verify(proof, root, leaf);
576     }
577 	function setMaxWL(uint256 _amount) external onlyOwner {
578 	    maxWL = _amount;
579 	}
580     function setMaxMint(uint256 _amount) external onlyOwner {
581 	    maxMint = _amount;
582 	}
583 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
584 	    baseURI = _newBaseURI;
585 	}
586 }