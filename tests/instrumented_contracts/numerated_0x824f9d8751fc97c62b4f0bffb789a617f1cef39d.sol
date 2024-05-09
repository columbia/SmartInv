1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9 <0.9.0;
3 
4 library Address {
5     function isContract(address account) internal view returns (bool) {
6         return account.code.length > 0;
7     }
8 	
9     function sendValue(address payable recipient, uint256 amount) internal {
10         require(address(this).balance >= amount, "Address: insufficient balance");
11 
12         (bool success, ) = recipient.call{value: amount}("");
13         require(success, "Address: unable to send value, recipient may have reverted");
14     }
15 
16     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
17         return functionCall(target, data, "Address: low-level call failed");
18     }
19 
20     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
21         return functionCallWithValue(target, data, 0, errorMessage);
22     }
23 
24     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
25         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
26     }
27 
28     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
29         require(address(this).balance >= value, "Address: insufficient balance for call");
30         require(isContract(target), "Address: call to non-contract");
31 
32         (bool success, bytes memory returndata) = target.call{value: value}(data);
33         return verifyCallResult(success, returndata, errorMessage);
34     }
35 
36     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
37         return functionStaticCall(target, data, "Address: low-level static call failed");
38     }
39 
40     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
41         require(isContract(target), "Address: static call to non-contract");
42 
43         (bool success, bytes memory returndata) = target.staticcall(data);
44         return verifyCallResult(success, returndata, errorMessage);
45     }
46 
47     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
48         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
49     }
50 
51     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
52         require(isContract(target), "Address: delegate call to non-contract");
53 
54         (bool success, bytes memory returndata) = target.delegatecall(data);
55         return verifyCallResult(success, returndata, errorMessage);
56     }
57 
58     function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
59         if (success) {
60             return returndata;
61         } else {
62             if (returndata.length > 0) {
63                 assembly {
64                     let returndata_size := mload(returndata)
65                     revert(add(32, returndata), returndata_size)
66                 }
67             } else {
68                 revert(errorMessage);
69             }
70         }
71     }
72 }
73 
74 library Counters {
75     struct Counter {
76         uint256 _value;
77     }
78 
79     function current(Counter storage counter) internal view returns (uint256) {
80         return counter._value;
81     }
82 
83     function increment(Counter storage counter) internal {
84         unchecked {
85             counter._value += 1;
86         }
87     }
88 
89     function decrement(Counter storage counter) internal {
90         uint256 value = counter._value;
91         require(value > 0, "Counter: decrement overflow");
92         unchecked {
93             counter._value = value - 1;
94         }
95     }
96 
97     function reset(Counter storage counter) internal {
98         counter._value = 0;
99     }
100 }
101 
102 library Strings {
103     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
104     uint8 private constant _ADDRESS_LENGTH = 20;
105 
106     function toString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0";
109         }
110         uint256 temp = value;
111         uint256 digits;
112         while (temp != 0) {
113             digits++;
114             temp /= 10;
115         }
116         bytes memory buffer = new bytes(digits);
117         while (value != 0) {
118             digits -= 1;
119             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
120             value /= 10;
121         }
122         return string(buffer);
123     }
124 
125     function toHexString(uint256 value) internal pure returns (string memory) {
126         if (value == 0) {
127             return "0x00";
128         }
129         uint256 temp = value;
130         uint256 length = 0;
131         while (temp != 0) {
132             length++;
133             temp >>= 8;
134         }
135         return toHexString(value, length);
136     }
137 
138     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
139         bytes memory buffer = new bytes(2 * length + 2);
140         buffer[0] = "0";
141         buffer[1] = "x";
142         for (uint256 i = 2 * length + 1; i > 1; --i) {
143             buffer[i] = _HEX_SYMBOLS[value & 0xf];
144             value >>= 4;
145         }
146         require(value == 0, "Strings: hex length insufficient");
147         return string(buffer);
148     }
149 
150     function toHexString(address addr) internal pure returns (string memory) {
151         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
152     }
153 }
154 
155 library MerkleProof {
156     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
157         return processProof(proof, leaf) == root;
158     }
159 
160     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
161         return processProofCalldata(proof, leaf) == root;
162     }
163 
164     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
165         bytes32 computedHash = leaf;
166         for (uint256 i = 0; i < proof.length; i++) {
167             computedHash = _hashPair(computedHash, proof[i]);
168         }
169         return computedHash;
170     }
171 
172     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
173         bytes32 computedHash = leaf;
174         for (uint256 i = 0; i < proof.length; i++) {
175             computedHash = _hashPair(computedHash, proof[i]);
176         }
177         return computedHash;
178     }
179 
180     function multiProofVerify(bytes32[] memory proof, bool[] memory proofFlags, bytes32 root, bytes32[] memory leaves) internal pure returns (bool) {
181         return processMultiProof(proof, proofFlags, leaves) == root;
182     }
183 
184     function multiProofVerifyCalldata(bytes32[] calldata proof, bool[] calldata proofFlags, bytes32 root, bytes32[] memory leaves) internal pure returns (bool) {
185         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
186     }
187 
188     function processMultiProof(bytes32[] memory proof, bool[] memory proofFlags, bytes32[] memory leaves) internal pure returns (bytes32 merkleRoot) {
189         uint256 leavesLen = leaves.length;
190         uint256 totalHashes = proofFlags.length;
191         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
192 
193         bytes32[] memory hashes = new bytes32[](totalHashes);
194         uint256 leafPos = 0;
195         uint256 hashPos = 0;
196         uint256 proofPos = 0;
197 
198         for (uint256 i = 0; i < totalHashes; i++) {
199             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
200             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
201             hashes[i] = _hashPair(a, b);
202         }
203 
204         if (totalHashes > 0) {
205             return hashes[totalHashes - 1];
206         } else if (leavesLen > 0) {
207             return leaves[0];
208         } else {
209             return proof[0];
210         }
211     }
212 
213     function processMultiProofCalldata(bytes32[] calldata proof, bool[] calldata proofFlags, bytes32[] memory leaves) internal pure returns (bytes32 merkleRoot) {
214         uint256 leavesLen = leaves.length;
215         uint256 totalHashes = proofFlags.length;
216         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
217 
218         bytes32[] memory hashes = new bytes32[](totalHashes);
219         uint256 leafPos = 0;
220         uint256 hashPos = 0;
221         uint256 proofPos = 0;
222         for (uint256 i = 0; i < totalHashes; i++) {
223             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
224             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
225             hashes[i] = _hashPair(a, b);
226         }
227 
228         if (totalHashes > 0) {
229             return hashes[totalHashes - 1];
230         } else if (leavesLen > 0) {
231             return leaves[0];
232         } else {
233             return proof[0];
234         }
235     }
236 
237     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
238         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
239     }
240 
241     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
242         assembly {
243             mstore(0x00, a)
244             mstore(0x20, b)
245             value := keccak256(0x00, 0x40)
246         }
247     }
248 }
249 
250 interface IERC165 {
251     function supportsInterface(bytes4 interfaceId) external view returns (bool);
252 }
253 
254 interface IERC721 is IERC165 {
255     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
256     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
257     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
258     function balanceOf(address owner) external view returns (uint256 balance);
259     function ownerOf(uint256 tokenId) external view returns (address owner);
260     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
261     function safeTransferFrom(address from, address to, uint256 tokenId) external;
262     function transferFrom(address from, address to, uint256 tokenId) external;
263     function approve(address to, uint256 tokenId) external;
264     function setApprovalForAll(address operator, bool _approved) external;
265     function getApproved(uint256 tokenId) external view returns (address operator);
266     function isApprovedForAll(address owner, address operator) external view returns (bool);
267 }
268 
269 interface IOperatorFilterRegistry {
270     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
271     function register(address registrant) external;
272     function registerAndSubscribe(address registrant, address subscription) external;
273     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
274     function unregister(address addr) external;
275     function updateOperator(address registrant, address operator, bool filtered) external;
276     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
277     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
278     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
279     function subscribe(address registrant, address registrantToSubscribe) external;
280     function unsubscribe(address registrant, bool copyExistingEntries) external;
281     function subscriptionOf(address addr) external returns (address registrant);
282     function subscribers(address registrant) external returns (address[] memory);
283     function subscriberAt(address registrant, uint256 index) external returns (address);
284     function copyEntriesOf(address registrant, address registrantToCopy) external;
285     function isOperatorFiltered(address registrant, address operator) external returns (bool);
286     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
287     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
288     function filteredOperators(address addr) external returns (address[] memory);
289     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
290     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
291     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
292     function isRegistered(address addr) external returns (bool);
293     function codeHashOf(address addr) external returns (bytes32);
294 }
295 
296 interface IERC721Metadata is IERC721 {
297     function name() external view returns (string memory);
298     function symbol() external view returns (string memory);
299     function tokenURI(uint256 tokenId) external view returns (string memory);
300 }
301 
302 interface IERC721Receiver {
303     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
304 }
305 
306 abstract contract Context {
307     function _msgSender() internal view virtual returns (address) {
308         return msg.sender;
309     }
310 
311     function _msgData() internal view virtual returns (bytes calldata) {
312         return msg.data;
313     }
314 }
315 
316 abstract contract Ownable is Context {
317     address private _owner;
318 
319     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
320 
321     constructor() {
322         _transferOwnership(_msgSender());
323     }
324 
325     modifier onlyOwner() {
326         _checkOwner();
327         _;
328     }
329 
330     function owner() public view virtual returns (address) {
331         return _owner;
332     }
333 
334     function _checkOwner() internal view virtual {
335         require(owner() == _msgSender(), "Ownable: caller is not the owner");
336     }
337 
338     function renounceOwnership() public virtual onlyOwner {
339         _transferOwnership(address(0));
340     }
341 
342     function transferOwnership(address newOwner) public virtual onlyOwner {
343         require(newOwner != address(0), "Ownable: new owner is the zero address");
344         _transferOwnership(newOwner);
345     }
346 
347     function _transferOwnership(address newOwner) internal virtual {
348         address oldOwner = _owner;
349         _owner = newOwner;
350         emit OwnershipTransferred(oldOwner, newOwner);
351     }
352 }
353 
354 abstract contract OperatorFilterer {
355     error OperatorNotAllowed(address operator);
356     IOperatorFilterRegistry constant operatorFilterRegistry = IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
357     
358 	constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
359         if (address(operatorFilterRegistry).code.length > 0) {
360             if (subscribe) {
361                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
362             } else {
363                 if (subscriptionOrRegistrantToCopy != address(0)) {
364                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
365                 } else {
366                     operatorFilterRegistry.register(address(this));
367                 }
368             }
369         }
370     }
371 
372     modifier onlyAllowedOperator(address from) virtual {
373         if (address(operatorFilterRegistry).code.length > 0) {
374             if (from == msg.sender) {
375                 _;
376                 return;
377             }
378             if (
379                 !(
380                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
381                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
382                 )
383             ) {
384                 revert OperatorNotAllowed(msg.sender);
385             }
386         }
387         _;
388     }
389 }
390 
391 abstract contract ERC165 is IERC165 {
392     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
393         return interfaceId == type(IERC165).interfaceId;
394     }
395 }
396 
397 abstract contract DefaultOperatorFilterer is OperatorFilterer {
398     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
399     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
400 }
401 
402 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
403     using Address for address;
404     using Strings for uint256;
405 
406     string private _name;
407     string private _symbol;
408     mapping(uint256 => address) private _owners;
409     mapping(address => uint256) private _balances;
410     mapping(uint256 => address) private _tokenApprovals;
411     mapping(address => mapping(address => bool)) private _operatorApprovals;
412 
413     constructor(string memory name_, string memory symbol_) {
414         _name = name_;
415         _symbol = symbol_;
416     }
417 
418     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
419         return
420             interfaceId == type(IERC721).interfaceId ||
421             interfaceId == type(IERC721Metadata).interfaceId ||
422             super.supportsInterface(interfaceId);
423     }
424 
425     function balanceOf(address owner) public view virtual override returns (uint256) {
426         require(owner != address(0), "ERC721: address zero is not a valid owner");
427         return _balances[owner];
428     }
429 
430     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
431         address owner = _owners[tokenId];
432         require(owner != address(0), "ERC721: invalid token ID");
433         return owner;
434     }
435 
436     function name() public view virtual override returns (string memory) {
437         return _name;
438     }
439 
440     function symbol() public view virtual override returns (string memory) {
441         return _symbol;
442     }
443 
444     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
445         _requireMinted(tokenId);
446         string memory baseURI = _baseURI();
447         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
448     }
449 
450     function _baseURI() internal view virtual returns (string memory) {
451         return "";
452     }
453 
454     function approve(address to, uint256 tokenId) public virtual override {
455         address owner = ERC721.ownerOf(tokenId);
456         require(to != owner, "ERC721: approval to current owner");
457         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not token owner nor approved for all");
458         _approve(to, tokenId);
459     }
460 
461     function getApproved(uint256 tokenId) public view virtual override returns (address) {
462         _requireMinted(tokenId);
463         return _tokenApprovals[tokenId];
464     }
465 
466     function setApprovalForAll(address operator, bool approved) public virtual override {
467         _setApprovalForAll(_msgSender(), operator, approved);
468     }
469 
470 	function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
471 		return _operatorApprovals[owner][operator];
472 	}
473 
474     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
475         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
476         _transfer(from, to, tokenId);
477     }
478 
479     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
480         safeTransferFrom(from, to, tokenId, "");
481     }
482 
483     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
484         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
485         _safeTransfer(from, to, tokenId, data);
486     }
487 
488     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
489         _transfer(from, to, tokenId);
490         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
491     }
492 
493     function _exists(uint256 tokenId) internal view virtual returns (bool) {
494         return _owners[tokenId] != address(0);
495     }
496 
497     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
498         address owner = ERC721.ownerOf(tokenId);
499         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
500     }
501 
502     function _safeMint(address to, uint256 tokenId) internal virtual {
503         _safeMint(to, tokenId, "");
504     }
505 
506     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
507         _mint(to, tokenId);
508         require(_checkOnERC721Received(address(0), to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
509     }
510 
511     function _mint(address to, uint256 tokenId) internal virtual {
512         require(to != address(0), "ERC721: mint to the zero address");
513         require(!_exists(tokenId), "ERC721: token already minted");
514         _beforeTokenTransfer(address(0), to, tokenId);
515         _balances[to] += 1;
516         _owners[tokenId] = to;
517         emit Transfer(address(0), to, tokenId);
518         _afterTokenTransfer(address(0), to, tokenId);
519     }
520 
521     function _burn(uint256 tokenId) internal virtual {
522         address owner = ERC721.ownerOf(tokenId);
523         _beforeTokenTransfer(owner, address(0), tokenId);
524         _approve(address(0), tokenId);
525         _balances[owner] -= 1;
526         delete _owners[tokenId];
527         emit Transfer(owner, address(0), tokenId);
528         _afterTokenTransfer(owner, address(0), tokenId);
529     }
530 
531     function _transfer(address from, address to, uint256 tokenId) internal virtual {
532         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
533         require(to != address(0), "ERC721: transfer to the zero address");
534         _beforeTokenTransfer(from, to, tokenId);
535         _approve(address(0), tokenId);
536         _balances[from] -= 1;
537         _balances[to] += 1;
538         _owners[tokenId] = to;
539         emit Transfer(from, to, tokenId);
540         _afterTokenTransfer(from, to, tokenId);
541     }
542 
543     function _approve(address to, uint256 tokenId) internal virtual {
544         _tokenApprovals[tokenId] = to;
545         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
546     }
547 
548     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
549         require(owner != operator, "ERC721: approve to caller");
550         _operatorApprovals[owner][operator] = approved;
551         emit ApprovalForAll(owner, operator, approved);
552     }
553 
554     function _requireMinted(uint256 tokenId) internal view virtual {
555         require(_exists(tokenId), "ERC721: invalid token ID");
556     }
557 
558     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private returns (bool) {
559         if (to.isContract()) {
560             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
561                 return retval == IERC721Receiver.onERC721Received.selector;
562             } catch (bytes memory reason) {
563                 if (reason.length == 0) {
564                     revert("ERC721: transfer to non ERC721Receiver implementer");
565                 } else {
566                     assembly {
567                         revert(add(32, reason), mload(reason))
568                     }
569                 }
570             }
571         } else {
572             return true;
573         }
574     }
575     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
576     function _afterTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
577 }
578 
579 contract ERC721F is Ownable, ERC721, DefaultOperatorFilterer {
580     using Counters for Counters.Counter;
581 
582     Counters.Counter private _tokenSupply;
583 
584     string private _baseTokenURI;
585 
586     constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
587     }
588 
589     function walletOfOwner(address _owner) external view returns (uint256[] memory){
590         uint256 ownerTokenCount = balanceOf(_owner);
591         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
592         uint256 currentTokenId = _startTokenId();
593         uint256 ownedTokenIndex = 0;
594 
595         while (ownedTokenIndex < ownerTokenCount && currentTokenId < _tokenSupply.current()) {
596             if (ownerOf(currentTokenId) == _owner) {
597                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
598                 unchecked{ ownedTokenIndex++;}
599             }
600             unchecked{ currentTokenId++;}
601         }
602         return ownedTokenIds;
603     }
604     
605     function _startTokenId() internal view virtual returns (uint256) {
606         return 0;
607     }
608 
609     function _baseURI() internal view virtual override returns (string memory) {
610         return _baseTokenURI;
611     }
612 
613     function setBaseTokenURI(string memory baseURI) public onlyOwner {
614         _baseTokenURI = baseURI;
615     }
616 
617     function _mint(address to, uint256 tokenId) internal virtual override {
618         super._mint(to, tokenId);
619         _tokenSupply.increment();
620     }
621 	
622     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
623         super.transferFrom(from, to, tokenId);
624     }
625 
626     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
627         super.safeTransferFrom(from, to, tokenId);
628     }
629 
630     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
631         super.safeTransferFrom(from, to, tokenId, data);
632     }
633 	
634     function totalSupply() public view returns (uint256) {
635         return _tokenSupply.current();
636     }
637 }
638 
639 abstract contract ERC721Payable {
640     function _withdraw(address _address, uint256 _amount) internal {
641         (bool success, ) = _address.call{ value: _amount }("");
642         require(success, "Failed to withdraw Ether");
643     }
644     receive() external payable { }
645 }
646 
647 contract ERC721FCOMMON is ERC721F, ERC721Payable {
648     constructor(string memory name_, string memory symbol_) ERC721F(name_, symbol_) {
649     }
650 }
651 
652 contract SatoshiAvas is ERC721FCOMMON {
653     uint256 public tokenPrice = 0.006 ether; 
654     uint256 public constant MAX_TOKENS = 1000;
655 	uint public constant MAX_RESERVE = 10;
656     uint public saleState;
657     bytes32 public claimlistMerkleRoot;
658 	mapping(address => uint256) private userBalanceSaleMint;
659     mapping(address => uint256) private userBalanceClaim;
660     
661     constructor() ERC721FCOMMON("SatoshiMysteryAvatars", "SMA") {
662         setBaseTokenURI("https://mint.ordersatoshi.com/avatars/meta/");
663         _mint(msg.sender, 0);
664     }
665 
666     function airdrop(address to, uint256 numberOfTokens) public onlyOwner {    
667         uint supply = totalSupply();
668 		require(numberOfTokens != 0, "numberOfNfts cannot be 0");
669         require(supply + numberOfTokens <= MAX_RESERVE, "Airdrop would exceed max reserve value");
670         for (uint i = 0; i < numberOfTokens;) {
671             _safeMint(to, supply + i);
672             unchecked{ i++;}
673         }
674     }
675 
676     function setMintPrice(uint256 price) external onlyOwner {
677         tokenPrice = price;
678     }
679 		
680     function setMerkleRoot(bytes32 _newRoot) external onlyOwner {
681         claimlistMerkleRoot = _newRoot;
682     }
683 
684     function setSaleState(uint256 _id) external onlyOwner {
685         require(_id < 4, "!id");
686         saleState=_id;
687     }
688 
689     function mint() external payable {
690         require(saleState==2, "$_sat_$Sale is not active$$_sat_$$");
691         require(userBalanceSaleMint[msg.sender]<2,"$_sat_$Max mint amount is 2 tokens for 1 address$$_sat_$$");
692         require(msg.sender == tx.origin, "$_sat_$No Contracts allowed$$_sat_$$");
693         require(tokenPrice <= msg.value, "$_sat_$ETH value sent is not correct$$_sat_$$");
694         uint256 supply = totalSupply();
695         require(supply < MAX_TOKENS, "$_sat_$All collection tokens have been already minted$$_sat_$$");
696         userBalanceSaleMint[msg.sender] += 1;
697         _mint(msg.sender, supply);
698     }
699 
700     function claim(bytes32[] calldata merkleProof) external {
701         require(saleState==1, "$_sat_$Claim is not active$$_sat_$$");
702         require(userBalanceClaim[msg.sender] < 1,"$_sat_$Max claim amount is 1 token for 1 address$$_sat_$$");
703         require(msg.sender == tx.origin, "$_sat_$No Contracts allowed$$_sat_$$");
704         uint256 supply = totalSupply();
705         require(supply < MAX_TOKENS, "$_sat_$All collection tokens have been already minted$$_sat_$$");
706         require(checkValidity(merkleProof), "$_sat_$Invalid Merkle Proof$$_sat_$$");
707         userBalanceClaim[msg.sender] = 1;
708         _mint(msg.sender, supply);
709     }
710 
711     function checkValidity(bytes32[] calldata merkleProof) internal view returns (bool) {
712         bytes32 leafToCheck = keccak256(abi.encodePacked(msg.sender));
713         return MerkleProof.verify(merkleProof, claimlistMerkleRoot, leafToCheck);
714     }
715 
716     function withdraw() external onlyOwner {
717         uint256 balance = address(this).balance;
718         require(balance > 0, "Insufficient balance");
719         _withdraw(owner(), address(this).balance);
720     }
721 }