1 // SPDX-License-Identifier: MIT
2 // File: contracts/OmniPill.sol
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 pragma solidity ^0.8.0;
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
15 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
16 abstract contract Ownable is Context {
17     address private _owner;
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19     constructor() {
20         _transferOwnership(_msgSender());
21     }
22     function owner() public view virtual returns (address) {
23         return _owner;
24     }
25     modifier onlyOwner() {
26         require(owner() == _msgSender(), "Ownable: caller is not the owner");
27         _;
28     }
29     function renounceOwnership() public virtual onlyOwner {
30         _transferOwnership(address(0));
31     }
32     function transferOwnership(address newOwner) public virtual onlyOwner {
33         require(newOwner != address(0), "Ownable: new owner is the zero address");
34         _transferOwnership(newOwner);
35     }
36     function _transferOwnership(address newOwner) internal virtual {
37         address oldOwner = _owner;
38         _owner = newOwner;
39         emit OwnershipTransferred(oldOwner, newOwner);
40     }
41 }
42 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
43 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
44 library Strings {
45     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
48      */
49     function toString(uint256 value) internal pure returns (string memory) {
50         // Inspired by OraclizeAPI's implementation - MIT licence
51         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
52 
53         if (value == 0) {
54             return "0";
55         }
56         uint256 temp = value;
57         uint256 digits;
58         while (temp != 0) {
59             digits++;
60             temp /= 10;
61         }
62         bytes memory buffer = new bytes(digits);
63         while (value != 0) {
64             digits -= 1;
65             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
66             value /= 10;
67         }
68         return string(buffer);
69     }
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
72      */
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
85     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
86         bytes memory buffer = new bytes(2 * length + 2);
87         buffer[0] = "0";
88         buffer[1] = "x";
89         for (uint256 i = 2 * length + 1; i > 1; --i) {
90             buffer[i] = _HEX_SYMBOLS[value & 0xf];
91             value >>= 4;
92         }
93         require(value == 0, "Strings: hex length insufficient");
94         return string(buffer);
95     }
96 }
97 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
98 interface IERC165 {
99     function supportsInterface(bytes4 interfaceId) external view returns (bool);
100 }
101 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
102 interface IERC721 is IERC165 {
103     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
104     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
105     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
106     function balanceOf(address owner) external view returns (uint256 balance);
107     function ownerOf(uint256 tokenId) external view returns (address owner);
108     function safeTransferFrom(
109         address from,
110         address to,
111         uint256 tokenId
112     ) external;
113     function transferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118     function approve(address to, uint256 tokenId) external;
119     function getApproved(uint256 tokenId) external view returns (address operator);
120     function setApprovalForAll(address operator, bool _approved) external;
121     function isApprovedForAll(address owner, address operator) external view returns (bool);
122     function safeTransferFrom(
123         address from,
124         address to,
125         uint256 tokenId,
126         bytes calldata data
127     ) external;
128 }
129 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
130 interface IERC721Receiver {
131     function onERC721Received(
132         address operator,
133         address from,
134         uint256 tokenId,
135         bytes calldata data
136     ) external returns (bytes4);
137 }
138 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
139 interface IERC721Metadata is IERC721 {
140     function name() external view returns (string memory);
141     function symbol() external view returns (string memory);
142     function tokenURI(uint256 tokenId) external view returns (string memory);
143 }
144 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
145 interface IERC721Enumerable is IERC721 {
146     function totalSupply() external view returns (uint256);
147     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
148     function tokenByIndex(uint256 index) external view returns (uint256);
149 }
150 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
151 library Address {
152     function isContract(address account) internal view returns (bool) {
153         uint256 size;
154         assembly {
155             size := extcodesize(account)
156         }
157         return size > 0;
158     }
159     function sendValue(address payable recipient, uint256 amount) internal {
160         require(address(this).balance >= amount, "Address: insufficient balance");
161         (bool success, ) = recipient.call{value: amount}("");
162         require(success, "Address: unable to send value, recipient may have reverted");
163     }
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
180     }
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(address(this).balance >= value, "Address: insufficient balance for call");
188         require(isContract(target), "Address: call to non-contract");
189         (bool success, bytes memory returndata) = target.call{value: value}(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
193         return functionStaticCall(target, data, "Address: low-level static call failed");
194     }
195     function functionStaticCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal view returns (bytes memory) {
200         require(isContract(target), "Address: static call to non-contract");
201         (bool success, bytes memory returndata) = target.staticcall(data);
202         return verifyCallResult(success, returndata, errorMessage);
203     }
204     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
206     }
207     function functionDelegateCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         require(isContract(target), "Address: delegate call to non-contract");
213         (bool success, bytes memory returndata) = target.delegatecall(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216     function verifyCallResult(
217         bool success,
218         bytes memory returndata,
219         string memory errorMessage
220     ) internal pure returns (bytes memory) {
221         if (success) {
222             return returndata;
223         } else {
224             // Look for revert reason and bubble it up if present
225             if (returndata.length > 0) {
226                 // The easiest way to bubble the revert reason is using memory via assembly
227 
228                 assembly {
229                     let returndata_size := mload(returndata)
230                     revert(add(32, returndata), returndata_size)
231                 }
232             } else {
233                 revert(errorMessage);
234             }
235         }
236     }
237 }
238 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
239 abstract contract ERC165 is IERC165 {
240     /**
241      * @dev See {IERC165-supportsInterface}.
242      */
243     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
244         return interfaceId == type(IERC165).interfaceId;
245     }
246 }
247 // File contracts/ERC721A.sol
248 // Creator: Chiru Labs
249 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
250     using Address for address;
251     using Strings for uint256;
252     struct TokenOwnership {
253         address addr;
254         uint64 startTimestamp;
255     }
256     struct AddressData {
257         uint128 balance;
258         uint128 numberMinted;
259     }
260     uint256 internal currentIndex = 0;
261     // Token name
262     string private _name;
263     // Token symbol
264     string private _symbol;
265     // Mapping from token ID to ownership details
266     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
267     mapping(uint256 => TokenOwnership) internal _ownerships;
268     // Mapping owner address to address data
269     mapping(address => AddressData) private _addressData;
270     // Mapping from token ID to approved address
271     mapping(uint256 => address) private _tokenApprovals;
272     // Mapping from owner to operator approvals
273     mapping(address => mapping(address => bool)) private _operatorApprovals;
274     constructor(string memory name_, string memory symbol_) {
275         _name = name_;
276         _symbol = symbol_;
277     }
278     function totalSupply() public view override returns (uint256) {
279         return currentIndex;
280     }
281     function tokenByIndex(uint256 index) public view override returns (uint256) {
282         require(index < totalSupply(), 'ERC721A: global index out of bounds');
283         return index;
284     }
285     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
286         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
287         uint256 numMintedSoFar = totalSupply();
288         uint256 tokenIdsIdx = 0;
289         address currOwnershipAddr = address(0);
290         for (uint256 i = 0; i < numMintedSoFar; i++) {
291             TokenOwnership memory ownership = _ownerships[i];
292             if (ownership.addr != address(0)) {
293                 currOwnershipAddr = ownership.addr;
294             }
295             if (currOwnershipAddr == owner) {
296                 if (tokenIdsIdx == index) {
297                     return i;
298                 }
299                 tokenIdsIdx++;
300             }
301         }
302         revert('ERC721A: unable to get token of owner by index');
303     }
304     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
305         return
306             interfaceId == type(IERC721).interfaceId ||
307             interfaceId == type(IERC721Metadata).interfaceId ||
308             interfaceId == type(IERC721Enumerable).interfaceId ||
309             super.supportsInterface(interfaceId);
310     }
311     function balanceOf(address owner) public view override returns (uint256) {
312         require(owner != address(0), 'ERC721A: balance query for the zero address');
313         return uint256(_addressData[owner].balance);
314     }
315     function _numberMinted(address owner) internal view returns (uint256) {
316         require(owner != address(0), 'ERC721A: number minted query for the zero address');
317         return uint256(_addressData[owner].numberMinted);
318     }
319     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
320         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
321         for (uint256 curr = tokenId; ; curr--) {
322             TokenOwnership memory ownership = _ownerships[curr];
323             if (ownership.addr != address(0)) {
324                 return ownership;
325             }
326         }
327 
328         revert('ERC721A: unable to determine the owner of token');
329     }
330     function ownerOf(uint256 tokenId) public view override returns (address) {
331         return ownershipOf(tokenId).addr;
332     }
333     function name() public view virtual override returns (string memory) {
334         return _name;
335     }
336     function symbol() public view virtual override returns (string memory) {
337         return _symbol;
338     }
339     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
340         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
341         string memory baseURI = _baseURI();
342         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
343     }
344     function _baseURI() internal view virtual returns (string memory) {
345         return '';
346     }
347     function approve(address to, uint256 tokenId) public override {
348         address owner = ERC721A.ownerOf(tokenId);
349         require(to != owner, 'ERC721A: approval to current owner');
350         require(
351             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
352             'ERC721A: approve caller is not owner nor approved for all'
353         );
354         _approve(to, tokenId, owner);
355     }
356     function getApproved(uint256 tokenId) public view override returns (address) {
357         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
358         return _tokenApprovals[tokenId];
359     }
360     function setApprovalForAll(address operator, bool approved) public override {
361         require(operator != _msgSender(), 'ERC721A: approve to caller');
362         _operatorApprovals[_msgSender()][operator] = approved;
363         emit ApprovalForAll(_msgSender(), operator, approved);
364     }
365     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
366         return _operatorApprovals[owner][operator];
367     }
368     function transferFrom(
369         address from,
370         address to,
371         uint256 tokenId
372     ) public override {
373         _transfer(from, to, tokenId);
374     }
375     function safeTransferFrom(
376         address from,
377         address to,
378         uint256 tokenId
379     ) public override {
380         safeTransferFrom(from, to, tokenId, '');
381     }
382     function safeTransferFrom(
383         address from,
384         address to,
385         uint256 tokenId,
386         bytes memory _data
387     ) public override {
388         _transfer(from, to, tokenId);
389         require(
390             _checkOnERC721Received(from, to, tokenId, _data),
391             'ERC721A: transfer to non ERC721Receiver implementer'
392         );
393     }
394     function _exists(uint256 tokenId) internal view returns (bool) {
395         return tokenId < currentIndex;
396     }
397     function _safeMint(address to, uint256 quantity) internal {
398         _safeMint(to, quantity, '');
399     }
400     function _safeMint(
401         address to,
402         uint256 quantity,
403         bytes memory _data
404     ) internal {
405         uint256 startTokenId = currentIndex;
406         require(to != address(0), 'ERC721A: mint to the zero address');
407         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
408         require(!_exists(startTokenId), 'ERC721A: token already minted');
409         require(quantity > 0, 'ERC721A: quantity must be greater 0');
410         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
411         AddressData memory addressData = _addressData[to];
412         _addressData[to] = AddressData(
413             addressData.balance + uint128(quantity),
414             addressData.numberMinted + uint128(quantity)
415         );
416         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
417         uint256 updatedIndex = startTokenId;
418         for (uint256 i = 0; i < quantity; i++) {
419             emit Transfer(address(0), to, updatedIndex);
420             require(
421                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
422                 'ERC721A: transfer to non ERC721Receiver implementer'
423             );
424             updatedIndex++;
425         }
426         currentIndex = updatedIndex;
427         _afterTokenTransfers(address(0), to, startTokenId, quantity);
428     }
429     function _transfer(
430         address from,
431         address to,
432         uint256 tokenId
433     ) private {
434         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
435         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
436             getApproved(tokenId) == _msgSender() ||
437             isApprovedForAll(prevOwnership.addr, _msgSender()));
438         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
439         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
440         require(to != address(0), 'ERC721A: transfer to the zero address');
441         _beforeTokenTransfers(from, to, tokenId, 1);
442         // Clear approvals from the previous owner
443         _approve(address(0), tokenId, prevOwnership.addr);
444         // Underflow of the sender's balance is impossible because we check for
445         // ownership above and the recipient's balance can't realistically overflow.
446         unchecked {
447             _addressData[from].balance -= 1;
448             _addressData[to].balance += 1;
449         }
450         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
451         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
452         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
453         uint256 nextTokenId = tokenId + 1;
454         if (_ownerships[nextTokenId].addr == address(0)) {
455             if (_exists(nextTokenId)) {
456                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
457             }
458         }
459         emit Transfer(from, to, tokenId);
460         _afterTokenTransfers(from, to, tokenId, 1);
461     }
462     function _approve(
463         address to,
464         uint256 tokenId,
465         address owner
466     ) private {
467         _tokenApprovals[tokenId] = to;
468         emit Approval(owner, to, tokenId);
469     }
470     function _checkOnERC721Received(
471         address from,
472         address to,
473         uint256 tokenId,
474         bytes memory _data
475     ) private returns (bool) {
476         if (to.isContract()) {
477             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
478                 return retval == IERC721Receiver(to).onERC721Received.selector;
479             } catch (bytes memory reason) {
480                 if (reason.length == 0) {
481                     revert('ERC721A: transfer to non ERC721Receiver implementer');
482                 } else {
483                     assembly {
484                         revert(add(32, reason), mload(reason))
485                     }
486                 }
487             }
488         } else {
489             return true;
490         }
491     }
492     function _beforeTokenTransfers(
493         address from,
494         address to,
495         uint256 startTokenId,
496         uint256 quantity
497     ) internal virtual {}
498     function _afterTokenTransfers(
499         address from,
500         address to,
501         uint256 startTokenId,
502         uint256 quantity
503     ) internal virtual {}
504 }
505 contract OmniPills is ERC721A, Ownable {
506     string public baseURI = "ipfs://QmYNSzG4hWdeHFWsF2PRVg54KM5XNPw12nfFQ9KCzzY2ko/";
507     string public constant baseExtension = ".json";
508     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
509     uint256 public constant MAX_PER_TX_FREE = 5;
510     uint256 public constant MAX_PER_WALLET = 20;
511     uint256 public constant MAX_PER_TX = 5;
512     uint256 public constant FREE_MAX_SUPPLY = 770;
513     uint256 public constant MAX_SUPPLY = 3333;
514     uint256 public constant price = 0.005 ether;
515     bool public paused = false;
516  mapping(address => uint256) public addressMinted;
517     constructor() ERC721A("OmniPills", "OP") {}
518     function mint(uint256 _amount) external payable {
519         address _caller = _msgSender();
520         require(!paused, "Paused");
521         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
522         require(_amount > 0, "No 0 mints");
523         require(tx.origin == _caller, "No contracts");
524          require(addressMinted[msg.sender] + _amount <= MAX_PER_WALLET, "Exceeds max per wallet");
525         if(FREE_MAX_SUPPLY >= totalSupply()){
526             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
527         }else{
528             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
529             require(_amount * price == msg.value, "Invalid funds provided");
530         }
531        addressMinted[msg.sender] += _amount;
532         _safeMint(_caller, _amount);
533     }
534     function isApprovedForAll(address owner, address operator)
535         override
536         public
537         view
538         returns (bool)
539     {
540         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
541         if (address(proxyRegistry.proxies(owner)) == operator) {
542             return true;
543     }
544         return super.isApprovedForAll(owner, operator);
545     }
546     function withdraw() external onlyOwner {
547         uint256 balance = address(this).balance;
548         (bool success, ) = _msgSender().call{value: balance}("");
549         require(success, "Failed to send");
550     }
551     function pause(bool _state) external onlyOwner {
552         paused = _state;
553     }
554     function setBaseURI(string memory baseURI_) external onlyOwner {
555         baseURI = baseURI_;
556     }
557     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
558         require(_exists(_tokenId), "Token does not exist.");
559         return bytes(baseURI).length > 0 ? string(
560             abi.encodePacked(
561               baseURI,
562               Strings.toString(_tokenId),
563               baseExtension
564             )
565         ) : "";
566     }
567 }
568 contract OwnableDelegateProxy { }
569 contract ProxyRegistry {
570     mapping(address => OwnableDelegateProxy) public proxies;
571 }