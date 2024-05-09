1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 pragma solidity ^0.8.0;
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
13 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
14 abstract contract Ownable is Context {
15     address private _owner;
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17     constructor() {
18         _transferOwnership(_msgSender());
19     }
20     function owner() public view virtual returns (address) {
21         return _owner;
22     }
23     modifier onlyOwner() {
24         require(owner() == _msgSender(), "Ownable: caller is not the owner");
25         _;
26     }
27     function renounceOwnership() public virtual onlyOwner {
28         _transferOwnership(address(0));
29     }
30     function transferOwnership(address newOwner) public virtual onlyOwner {
31         require(newOwner != address(0), "Ownable: new owner is the zero address");
32         _transferOwnership(newOwner);
33     }
34     function _transferOwnership(address newOwner) internal virtual {
35         address oldOwner = _owner;
36         _owner = newOwner;
37         emit OwnershipTransferred(oldOwner, newOwner);
38     }
39 }
40 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
41 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
42 library Strings {
43     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
46      */
47     function toString(uint256 value) internal pure returns (string memory) {
48         // Inspired by OraclizeAPI's implementation - MIT licence
49         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
50 
51         if (value == 0) {
52             return "0";
53         }
54         uint256 temp = value;
55         uint256 digits;
56         while (temp != 0) {
57             digits++;
58             temp /= 10;
59         }
60         bytes memory buffer = new bytes(digits);
61         while (value != 0) {
62             digits -= 1;
63             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
64             value /= 10;
65         }
66         return string(buffer);
67     }
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
70      */
71     function toHexString(uint256 value) internal pure returns (string memory) {
72         if (value == 0) {
73             return "0x00";
74         }
75         uint256 temp = value;
76         uint256 length = 0;
77         while (temp != 0) {
78             length++;
79             temp >>= 8;
80         }
81         return toHexString(value, length);
82     }
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = _HEX_SYMBOLS[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 }
95 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
96 interface IERC165 {
97     function supportsInterface(bytes4 interfaceId) external view returns (bool);
98 }
99 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
100 interface IERC721 is IERC165 {
101     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
102     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
103     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
104     function balanceOf(address owner) external view returns (uint256 balance);
105     function ownerOf(uint256 tokenId) external view returns (address owner);
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111     function transferFrom(
112         address from,
113         address to,
114         uint256 tokenId
115     ) external;
116     function approve(address to, uint256 tokenId) external;
117     function getApproved(uint256 tokenId) external view returns (address operator);
118     function setApprovalForAll(address operator, bool _approved) external;
119     function isApprovedForAll(address owner, address operator) external view returns (bool);
120     function safeTransferFrom(
121         address from,
122         address to,
123         uint256 tokenId,
124         bytes calldata data
125     ) external;
126 }
127 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
128 interface IERC721Receiver {
129     function onERC721Received(
130         address operator,
131         address from,
132         uint256 tokenId,
133         bytes calldata data
134     ) external returns (bytes4);
135 }
136 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
137 interface IERC721Metadata is IERC721 {
138     function name() external view returns (string memory);
139     function symbol() external view returns (string memory);
140     function tokenURI(uint256 tokenId) external view returns (string memory);
141 }
142 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
143 interface IERC721Enumerable is IERC721 {
144     function totalSupply() external view returns (uint256);
145     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
146     function tokenByIndex(uint256 index) external view returns (uint256);
147 }
148 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
149 library Address {
150     function isContract(address account) internal view returns (bool) {
151         uint256 size;
152         assembly {
153             size := extcodesize(account)
154         }
155         return size > 0;
156     }
157     function sendValue(address payable recipient, uint256 amount) internal {
158         require(address(this).balance >= amount, "Address: insufficient balance");
159         (bool success, ) = recipient.call{value: amount}("");
160         require(success, "Address: unable to send value, recipient may have reverted");
161     }
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163         return functionCall(target, data, "Address: low-level call failed");
164     }
165     function functionCall(
166         address target,
167         bytes memory data,
168         string memory errorMessage
169     ) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, 0, errorMessage);
171     }
172     function functionCallWithValue(
173         address target,
174         bytes memory data,
175         uint256 value
176     ) internal returns (bytes memory) {
177         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
178     }
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         require(address(this).balance >= value, "Address: insufficient balance for call");
186         require(isContract(target), "Address: call to non-contract");
187         (bool success, bytes memory returndata) = target.call{value: value}(data);
188         return verifyCallResult(success, returndata, errorMessage);
189     }
190     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
191         return functionStaticCall(target, data, "Address: low-level static call failed");
192     }
193     function functionStaticCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal view returns (bytes memory) {
198         require(isContract(target), "Address: static call to non-contract");
199         (bool success, bytes memory returndata) = target.staticcall(data);
200         return verifyCallResult(success, returndata, errorMessage);
201     }
202     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
203         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
204     }
205     function functionDelegateCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(isContract(target), "Address: delegate call to non-contract");
211         (bool success, bytes memory returndata) = target.delegatecall(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214     function verifyCallResult(
215         bool success,
216         bytes memory returndata,
217         string memory errorMessage
218     ) internal pure returns (bytes memory) {
219         if (success) {
220             return returndata;
221         } else {
222             // Look for revert reason and bubble it up if present
223             if (returndata.length > 0) {
224                 // The easiest way to bubble the revert reason is using memory via assembly
225 
226                 assembly {
227                     let returndata_size := mload(returndata)
228                     revert(add(32, returndata), returndata_size)
229                 }
230             } else {
231                 revert(errorMessage);
232             }
233         }
234     }
235 }
236 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
237 abstract contract ERC165 is IERC165 {
238     /**
239      * @dev See {IERC165-supportsInterface}.
240      */
241     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
242         return interfaceId == type(IERC165).interfaceId;
243     }
244 }
245 // File contracts/ERC721A.sol
246 // Creator: Chiru Labs
247 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
248     using Address for address;
249     using Strings for uint256;
250     struct TokenOwnership {
251         address addr;
252         uint64 startTimestamp;
253     }
254     struct AddressData {
255         uint128 balance;
256         uint128 numberMinted;
257     }
258     uint256 internal currentIndex = 0;
259     // Token name
260     string private _name;
261     // Token symbol
262     string private _symbol;
263     // Mapping from token ID to ownership details
264     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
265     mapping(uint256 => TokenOwnership) internal _ownerships;
266     // Mapping owner address to address data
267     mapping(address => AddressData) private _addressData;
268     // Mapping from token ID to approved address
269     mapping(uint256 => address) private _tokenApprovals;
270     // Mapping from owner to operator approvals
271     mapping(address => mapping(address => bool)) private _operatorApprovals;
272     constructor(string memory name_, string memory symbol_) {
273         _name = name_;
274         _symbol = symbol_;
275     }
276     function totalSupply() public view override returns (uint256) {
277         return currentIndex;
278     }
279     function tokenByIndex(uint256 index) public view override returns (uint256) {
280         require(index < totalSupply(), 'ERC721A: global index out of bounds');
281         return index;
282     }
283     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
284         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
285         uint256 numMintedSoFar = totalSupply();
286         uint256 tokenIdsIdx = 0;
287         address currOwnershipAddr = address(0);
288         for (uint256 i = 0; i < numMintedSoFar; i++) {
289             TokenOwnership memory ownership = _ownerships[i];
290             if (ownership.addr != address(0)) {
291                 currOwnershipAddr = ownership.addr;
292             }
293             if (currOwnershipAddr == owner) {
294                 if (tokenIdsIdx == index) {
295                     return i;
296                 }
297                 tokenIdsIdx++;
298             }
299         }
300         revert('ERC721A: unable to get token of owner by index');
301     }
302     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
303         return
304             interfaceId == type(IERC721).interfaceId ||
305             interfaceId == type(IERC721Metadata).interfaceId ||
306             interfaceId == type(IERC721Enumerable).interfaceId ||
307             super.supportsInterface(interfaceId);
308     }
309     function balanceOf(address owner) public view override returns (uint256) {
310         require(owner != address(0), 'ERC721A: balance query for the zero address');
311         return uint256(_addressData[owner].balance);
312     }
313     function _numberMinted(address owner) internal view returns (uint256) {
314         require(owner != address(0), 'ERC721A: number minted query for the zero address');
315         return uint256(_addressData[owner].numberMinted);
316     }
317     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
318         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
319         for (uint256 curr = tokenId; ; curr--) {
320             TokenOwnership memory ownership = _ownerships[curr];
321             if (ownership.addr != address(0)) {
322                 return ownership;
323             }
324         }
325 
326         revert('ERC721A: unable to determine the owner of token');
327     }
328     function ownerOf(uint256 tokenId) public view override returns (address) {
329         return ownershipOf(tokenId).addr;
330     }
331     function name() public view virtual override returns (string memory) {
332         return _name;
333     }
334     function symbol() public view virtual override returns (string memory) {
335         return _symbol;
336     }
337     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
338         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
339         string memory baseURI = _baseURI();
340         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
341     }
342     function _baseURI() internal view virtual returns (string memory) {
343         return '';
344     }
345     function approve(address to, uint256 tokenId) public override {
346         address owner = ERC721A.ownerOf(tokenId);
347         require(to != owner, 'ERC721A: approval to current owner');
348         require(
349             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
350             'ERC721A: approve caller is not owner nor approved for all'
351         );
352         _approve(to, tokenId, owner);
353     }
354     function getApproved(uint256 tokenId) public view override returns (address) {
355         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
356         return _tokenApprovals[tokenId];
357     }
358     function setApprovalForAll(address operator, bool approved) public override {
359         require(operator != _msgSender(), 'ERC721A: approve to caller');
360         _operatorApprovals[_msgSender()][operator] = approved;
361         emit ApprovalForAll(_msgSender(), operator, approved);
362     }
363     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
364         return _operatorApprovals[owner][operator];
365     }
366     function transferFrom(
367         address from,
368         address to,
369         uint256 tokenId
370     ) public override {
371         _transfer(from, to, tokenId);
372     }
373     function safeTransferFrom(
374         address from,
375         address to,
376         uint256 tokenId
377     ) public override {
378         safeTransferFrom(from, to, tokenId, '');
379     }
380     function safeTransferFrom(
381         address from,
382         address to,
383         uint256 tokenId,
384         bytes memory _data
385     ) public override {
386         _transfer(from, to, tokenId);
387         require(
388             _checkOnERC721Received(from, to, tokenId, _data),
389             'ERC721A: transfer to non ERC721Receiver implementer'
390         );
391     }
392     function _exists(uint256 tokenId) internal view returns (bool) {
393         return tokenId < currentIndex;
394     }
395     function _safeMint(address to, uint256 quantity) internal {
396         _safeMint(to, quantity, '');
397     }
398     function _safeMint(
399         address to,
400         uint256 quantity,
401         bytes memory _data
402     ) internal {
403         uint256 startTokenId = currentIndex;
404         require(to != address(0), 'ERC721A: mint to the zero address');
405         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
406         require(!_exists(startTokenId), 'ERC721A: token already minted');
407         require(quantity > 0, 'ERC721A: quantity must be greater 0');
408         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
409         AddressData memory addressData = _addressData[to];
410         _addressData[to] = AddressData(
411             addressData.balance + uint128(quantity),
412             addressData.numberMinted + uint128(quantity)
413         );
414         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
415         uint256 updatedIndex = startTokenId;
416         for (uint256 i = 0; i < quantity; i++) {
417             emit Transfer(address(0), to, updatedIndex);
418             require(
419                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
420                 'ERC721A: transfer to non ERC721Receiver implementer'
421             );
422             updatedIndex++;
423         }
424         currentIndex = updatedIndex;
425         _afterTokenTransfers(address(0), to, startTokenId, quantity);
426     }
427     function _transfer(
428         address from,
429         address to,
430         uint256 tokenId
431     ) private {
432         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
433         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
434             getApproved(tokenId) == _msgSender() ||
435             isApprovedForAll(prevOwnership.addr, _msgSender()));
436         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
437         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
438         require(to != address(0), 'ERC721A: transfer to the zero address');
439         _beforeTokenTransfers(from, to, tokenId, 1);
440         // Clear approvals from the previous owner
441         _approve(address(0), tokenId, prevOwnership.addr);
442         // Underflow of the sender's balance is impossible because we check for
443         // ownership above and the recipient's balance can't realistically overflow.
444         unchecked {
445             _addressData[from].balance -= 1;
446             _addressData[to].balance += 1;
447         }
448         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
449         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
450         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
451         uint256 nextTokenId = tokenId + 1;
452         if (_ownerships[nextTokenId].addr == address(0)) {
453             if (_exists(nextTokenId)) {
454                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
455             }
456         }
457         emit Transfer(from, to, tokenId);
458         _afterTokenTransfers(from, to, tokenId, 1);
459     }
460     function _approve(
461         address to,
462         uint256 tokenId,
463         address owner
464     ) private {
465         _tokenApprovals[tokenId] = to;
466         emit Approval(owner, to, tokenId);
467     }
468     function _checkOnERC721Received(
469         address from,
470         address to,
471         uint256 tokenId,
472         bytes memory _data
473     ) private returns (bool) {
474         if (to.isContract()) {
475             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
476                 return retval == IERC721Receiver(to).onERC721Received.selector;
477             } catch (bytes memory reason) {
478                 if (reason.length == 0) {
479                     revert('ERC721A: transfer to non ERC721Receiver implementer');
480                 } else {
481                     assembly {
482                         revert(add(32, reason), mload(reason))
483                     }
484                 }
485             }
486         } else {
487             return true;
488         }
489     }
490     function _beforeTokenTransfers(
491         address from,
492         address to,
493         uint256 startTokenId,
494         uint256 quantity
495     ) internal virtual {}
496     function _afterTokenTransfers(
497         address from,
498         address to,
499         uint256 startTokenId,
500         uint256 quantity
501     ) internal virtual {}
502 }
503 contract Katakana is ERC721A, Ownable {
504     string public baseURI = "ipfs://QmW9wU1GL1Czuv2uS6LyK6oEyvGYwATTnABzjsXB3reRvC/";
505     string public constant baseExtension = ".json";
506     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
507     uint256 public constant MAX_PER_TX_FREE = 2;
508     uint256 public constant MAX_PER_WALLET = 6;
509     uint256 public constant MAX_PER_TX = 2;
510     uint256 public constant FREE_MAX_SUPPLY = 500;
511     uint256 public constant MAX_SUPPLY = 650;
512     uint256 public constant price = 0.005 ether;
513     bool public paused = false;
514  mapping(address => uint256) public addressMinted;
515     constructor() ERC721A("Katakana", "KTK") {}
516     function mint(uint256 _amount) external payable {
517         address _caller = _msgSender();
518         require(!paused, "Paused");
519         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
520         require(_amount > 0, "No 0 mints");
521         require(tx.origin == _caller, "No contracts");
522          require(addressMinted[msg.sender] + _amount <= MAX_PER_WALLET, "Exceeds max per wallet");
523         if(FREE_MAX_SUPPLY >= totalSupply()){
524             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
525         }else{
526             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
527             require(_amount * price == msg.value, "Invalid funds provided");
528         }
529        addressMinted[msg.sender] += _amount;
530         _safeMint(_caller, _amount);
531     }
532     function isApprovedForAll(address owner, address operator)
533         override
534         public
535         view
536         returns (bool)
537     {
538        //  Whitelist OpenSea proxy contract for easy trading.
539         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
540         if (address(proxyRegistry.proxies(owner)) == operator) {
541             return true;
542     }
543         return super.isApprovedForAll(owner, operator);
544     }
545     function withdraw() external onlyOwner {
546         uint256 balance = address(this).balance;
547         (bool success, ) = _msgSender().call{value: balance}("");
548         require(success, "Failed to send");
549     }
550     function pause(bool _state) external onlyOwner {
551         paused = _state;
552     }
553     function setBaseURI(string memory baseURI_) external onlyOwner {
554         baseURI = baseURI_;
555     }
556     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
557         require(_exists(_tokenId), "Token does not exist.");
558         return bytes(baseURI).length > 0 ? string(
559             abi.encodePacked(
560               baseURI,
561               Strings.toString(_tokenId),
562               baseExtension
563             )
564         ) : "";
565     }
566 }
567 contract OwnableDelegateProxy { }
568 contract ProxyRegistry {
569     mapping(address => OwnableDelegateProxy) public proxies;
570 }