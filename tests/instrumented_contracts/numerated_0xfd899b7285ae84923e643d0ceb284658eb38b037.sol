1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0; 
4 
5 library Address {
6     function isContract(address account) internal view returns (bool) {
7         uint256 size;
8         assembly { size := extcodesize(account) }
9         return size > 0;
10     }
11     function sendValue(address payable recipient, uint256 amount) internal {
12         require(address(this).balance >= amount, "Address: insufficient balance");
13 
14         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
15         (bool success, ) = recipient.call{ value: amount }("");
16         require(success, "Address: unable to send value, recipient may have reverted");
17     }
18     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
19       return functionCall(target, data, "Address: low-level call failed");
20     }
21     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
22         return functionCallWithValue(target, data, 0, errorMessage);
23     }
24     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
25         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
26     }
27     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
28         require(address(this).balance >= value, "Address: insufficient balance for call");
29         require(isContract(target), "Address: call to non-contract");
30 
31         // solhint-disable-next-line avoid-low-level-calls
32         (bool success, bytes memory returndata) = target.call{ value: value }(data);
33         return _verifyCallResult(success, returndata, errorMessage);
34     }
35     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
36         return functionStaticCall(target, data, "Address: low-level static call failed");
37     }
38     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
39         require(isContract(target), "Address: static call to non-contract");
40 
41         // solhint-disable-next-line avoid-low-level-calls
42         (bool success, bytes memory returndata) = target.staticcall(data);
43         return _verifyCallResult(success, returndata, errorMessage);
44     }
45     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
46         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
47     }
48     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
49         require(isContract(target), "Address: delegate call to non-contract");
50         // solhint-disable-next-line avoid-low-level-calls
51         (bool success, bytes memory returndata) = target.delegatecall(data);
52         return _verifyCallResult(success, returndata, errorMessage);
53     }
54     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
55         if (success) {
56             return returndata;
57         } else {
58             if (returndata.length > 0) {
59                 // solhint-disable-next-line no-inline-assembly
60                 assembly {
61                     let returndata_size := mload(returndata)
62                     revert(add(32, returndata), returndata_size)
63                 }
64             } else {
65                 revert(errorMessage);
66             }
67         }
68     }
69 }
70 
71 library Strings {
72     bytes16 private constant alphabet = "0123456789abcdef";
73 
74     function toString(uint256 value) internal pure returns (string memory) {
75         // Inspired by OraclizeAPI's implementation - MIT licence
76         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
77 
78         if (value == 0) {
79             return "0";
80         }
81         uint256 temp = value;
82         uint256 digits;
83         while (temp != 0) {
84             digits++;
85             temp /= 10;
86         }
87         bytes memory buffer = new bytes(digits);
88         while (value != 0) {
89             digits -= 1;
90             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
91             value /= 10;
92         }
93         return string(buffer);
94     }
95     function toHexString(uint256 value) internal pure returns (string memory) {
96         if (value == 0) {
97             return "0x00";
98         }
99         uint256 temp = value;
100         uint256 length = 0;
101         while (temp != 0) {
102             length++;
103             temp >>= 8;
104         }
105         return toHexString(value, length);
106     }
107     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
108         bytes memory buffer = new bytes(2 * length + 2);
109         buffer[0] = "0";
110         buffer[1] = "x";
111         for (uint256 i = 2 * length + 1; i > 1; --i) {
112             buffer[i] = alphabet[value & 0xf];
113             value >>= 4;
114         }
115         require(value == 0, "Strings: hex length insufficient");
116         return string(buffer);
117     }
118 
119 }
120 
121 library SafeMath {
122     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             uint256 c = a + b;
125             if (c < a) return (false, 0);
126             return (true, c);
127         }
128     }
129     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         unchecked {
131             if (b > a) return (false, 0);
132             return (true, a - b);
133         }
134     }
135     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
136         unchecked {
137             if (a == 0) return (true, 0);
138             uint256 c = a * b;
139             if (c / a != b) return (false, 0);
140             return (true, c);
141         }
142     }
143     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         unchecked {
145             if (b == 0) return (false, 0);
146             return (true, a / b);
147         }
148     }
149     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
150         unchecked {
151             if (b == 0) return (false, 0);
152             return (true, a % b);
153         }
154     }
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a + b;
157     }
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a - b;
160     }
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a * b;
163     }
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         return a / b;
166     }
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a % b;
169     }
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         unchecked {
172             require(b <= a, errorMessage);
173             return a - b;
174         }
175     }
176     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         unchecked {
178             require(b > 0, errorMessage);
179             return a / b;
180         }
181     }
182     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         unchecked {
184             require(b > 0, errorMessage);
185             return a % b;
186         }
187     }
188 }
189 
190 interface IERC165 {
191     function supportsInterface(bytes4 interfaceId) external view returns (bool);
192 }
193 
194 interface IERC721 is IERC165 {
195     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
196 
197     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
198 
199     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
200 
201     function balanceOf(address owner) external view returns (uint256 balance);
202 
203     function ownerOf(uint256 tokenId) external view returns (address owner);
204 
205     function safeTransferFrom(address from, address to, uint256 tokenId) external;
206 
207     function transferFrom(address from, address to, uint256 tokenId) external;
208 
209     function approve(address to, uint256 tokenId) external;
210 
211     function getApproved(uint256 tokenId) external view returns (address operator);
212 
213     function setApprovalForAll(address operator, bool _approved) external;
214 
215     function isApprovedForAll(address owner, address operator) external view returns (bool);
216 
217     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
218 }
219 
220 interface IERC721Enumerable is IERC721 {
221 
222     function totalSupply() external view returns (uint256);
223 
224     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
225 
226     function tokenByIndex(uint256 index) external view returns (uint256);
227 }
228 
229 interface IERC721Metadata is IERC721 {
230 
231     function name() external view returns (string memory);
232 
233     function symbol() external view returns (string memory);
234 
235     function tokenURI(uint256 tokenId) external view returns (string memory);
236 }
237 
238 interface IERC721Receiver {
239     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
240 }
241 
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes calldata) {
248         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
249         return msg.data;
250     }
251 }
252 
253 abstract contract Ownable is Context {
254     address private _owner;
255 
256     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258     constructor () {
259         address msgSender = _msgSender();
260         _owner = msgSender;
261         emit OwnershipTransferred(address(0), msgSender);
262     }
263 
264     function owner() public view virtual returns (address) {
265         return _owner;
266     }
267 
268     modifier onlyOwner() {
269         require(owner() == _msgSender(), "Ownable: caller is not the owner");
270         _;
271     }
272 
273     function renounceOwnership() public virtual onlyOwner {
274         emit OwnershipTransferred(_owner, address(0));
275         _owner = address(0);
276     }
277 
278     function transferOwnership(address newOwner) public virtual onlyOwner {
279         require(newOwner != address(0), "Ownable: new owner is the zero address");
280         emit OwnershipTransferred(_owner, newOwner);
281         _owner = newOwner;
282     }
283 }
284 
285 abstract contract ERC165 is IERC165 {
286     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
287         return interfaceId == type(IERC165).interfaceId;
288     }
289 }
290 
291 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
292     using Address for address;
293     using Strings for uint256;
294     string private _name;
295     string private _symbol;
296     mapping (uint256 => address) private _owners;
297     mapping (address => uint256) private _balances;
298     mapping (uint256 => address) private _tokenApprovals;
299     mapping (address => mapping (address => bool)) private _operatorApprovals;
300     constructor (string memory name_, string memory symbol_) {
301         _name = name_;
302         _symbol = symbol_;
303     }
304     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
305         return interfaceId == type(IERC721).interfaceId
306             || interfaceId == type(IERC721Metadata).interfaceId
307             || super.supportsInterface(interfaceId);
308     }
309     function balanceOf(address owner) public view virtual override returns (uint256) {
310         require(owner != address(0), "ERC721: balance query for the zero address");
311         return _balances[owner];
312     }
313     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
314         address owner = _owners[tokenId];
315         require(owner != address(0), "ERC721: owner query for nonexistent token");
316         return owner;
317     }
318     function name() public view virtual override returns (string memory) {
319         return _name;
320     }
321     function symbol() public view virtual override returns (string memory) {
322         return _symbol;
323     }
324     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
325         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
326 
327         string memory baseURI = _baseURI();
328         return bytes(baseURI).length > 0
329             ? string(abi.encodePacked(baseURI, tokenId.toString()))
330             : '';
331     }
332     function _baseURI() internal view virtual returns (string memory) {
333         return "";
334     }
335     function approve(address to, uint256 tokenId) public virtual override {
336         address owner = ERC721.ownerOf(tokenId);
337         require(to != owner, "ERC721: approval to current owner");
338 
339         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
340             "ERC721: approve caller is not owner nor approved for all"
341         );
342 
343         _approve(to, tokenId);
344     }
345     function getApproved(uint256 tokenId) public view virtual override returns (address) {
346         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
347 
348         return _tokenApprovals[tokenId];
349     }
350     function setApprovalForAll(address operator, bool approved) public virtual override {
351         require(operator != _msgSender(), "ERC721: approve to caller");
352 
353         _operatorApprovals[_msgSender()][operator] = approved;
354         emit ApprovalForAll(_msgSender(), operator, approved);
355     }
356     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
357         return _operatorApprovals[owner][operator];
358     }
359     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
360         //solhint-disable-next-line max-line-length
361         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
362 
363         _transfer(from, to, tokenId);
364     }
365     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
366         safeTransferFrom(from, to, tokenId, "");
367     }
368     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
369         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
370         _safeTransfer(from, to, tokenId, _data);
371     }
372     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
373         _transfer(from, to, tokenId);
374         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
375     }
376     function _exists(uint256 tokenId) internal view virtual returns (bool) {
377         return _owners[tokenId] != address(0);
378     }
379     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
380         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
381         address owner = ERC721.ownerOf(tokenId);
382         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
383     }
384     function _safeMint(address to, uint256 tokenId) internal virtual {
385         _safeMint(to, tokenId, "");
386     }
387     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
388         _mint(to, tokenId);
389         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
390     }
391     function _mint(address to, uint256 tokenId) internal virtual {
392         require(to != address(0), "ERC721: mint to the zero address");
393         require(!_exists(tokenId), "ERC721: token already minted");
394 
395         _beforeTokenTransfer(address(0), to, tokenId);
396 
397         _balances[to] += 1;
398         _owners[tokenId] = to;
399 
400         emit Transfer(address(0), to, tokenId);
401     }
402     function _burn(uint256 tokenId) internal virtual {
403         address owner = ERC721.ownerOf(tokenId);
404 
405         _beforeTokenTransfer(owner, address(0), tokenId);
406         _approve(address(0), tokenId);
407 
408         _balances[owner] -= 1;
409         delete _owners[tokenId];
410 
411         emit Transfer(owner, address(0), tokenId);
412     }
413     function _transfer(address from, address to, uint256 tokenId) internal virtual {
414         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
415         require(to != address(0), "ERC721: transfer to the zero address");
416 
417         _beforeTokenTransfer(from, to, tokenId);
418         _approve(address(0), tokenId);
419 
420         _balances[from] -= 1;
421         _balances[to] += 1;
422         _owners[tokenId] = to;
423 
424         emit Transfer(from, to, tokenId);
425     }
426     function _approve(address to, uint256 tokenId) internal virtual {
427         _tokenApprovals[tokenId] = to;
428         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
429     }
430     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
431         private returns (bool)
432     {
433         if (to.isContract()) {
434             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
435                 return retval == IERC721Receiver(to).onERC721Received.selector;
436             } catch (bytes memory reason) {
437                 if (reason.length == 0) {
438                     revert("ERC721: transfer to non ERC721Receiver implementer");
439                 } else {
440                     // solhint-disable-next-line no-inline-assembly
441                     assembly {
442                         revert(add(32, reason), mload(reason))
443                     }
444                 }
445             }
446         } else {
447             return true;
448         }
449     }
450     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
451 }
452 
453 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
454     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
455     mapping(uint256 => uint256) private _ownedTokensIndex;
456     uint256[] private _allTokens;
457     mapping(uint256 => uint256) private _allTokensIndex;
458 
459     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
460         return interfaceId == type(IERC721Enumerable).interfaceId
461             || super.supportsInterface(interfaceId);
462     }
463     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
464         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
465         return _ownedTokens[owner][index];
466     }
467     function totalSupply() public view virtual override returns (uint256) {
468         return _allTokens.length;
469     }
470     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
471         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
472         return _allTokens[index];
473     }
474     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
475         super._beforeTokenTransfer(from, to, tokenId);
476 
477         if (from == address(0)) {
478             _addTokenToAllTokensEnumeration(tokenId);
479         } else if (from != to) {
480             _removeTokenFromOwnerEnumeration(from, tokenId);
481         }
482         if (to == address(0)) {
483             _removeTokenFromAllTokensEnumeration(tokenId);
484         } else if (to != from) {
485             _addTokenToOwnerEnumeration(to, tokenId);
486         }
487     }
488 
489     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
490         uint256 length = ERC721.balanceOf(to);
491         _ownedTokens[to][length] = tokenId;
492         _ownedTokensIndex[tokenId] = length;
493     }
494     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
495         _allTokensIndex[tokenId] = _allTokens.length;
496         _allTokens.push(tokenId);
497     }
498     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
499 
500         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
501         uint256 tokenIndex = _ownedTokensIndex[tokenId];
502         if (tokenIndex != lastTokenIndex) {
503             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
504 
505             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
506             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
507         }
508 
509         delete _ownedTokensIndex[tokenId];
510         delete _ownedTokens[from][lastTokenIndex];
511     }
512     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
513       
514         uint256 lastTokenIndex = _allTokens.length - 1;
515         uint256 tokenIndex = _allTokensIndex[tokenId];
516         uint256 lastTokenId = _allTokens[lastTokenIndex];
517 
518         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
519         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
520 
521         delete _allTokensIndex[tokenId];
522         _allTokens.pop();
523     }
524 }
525 
526 contract OwnableDelegateProxy {}
527 
528 contract ProxyRegistry {
529     mapping(address => OwnableDelegateProxy) public proxies;
530 }
531 
532 contract LaCosaOstra is ERC721Enumerable, Ownable {
533     using SafeMath for uint256;
534     using Strings for uint256;
535 
536     address proxyRegistryAddress;
537     address oTownWallet = 0x11905F966D22c6715cfC4BD75c12961035E269B5;
538     mapping (uint256 => string) private _tokenURIs;
539     string private BASE_URI = "https://www.lacosaostra.com/api/?token_id=";
540     uint256 public MAX_TOKENS = 5555;
541     uint256 public TOKEN_PRICE = 50000000000000000;
542     uint public MAX_TOKENS_PER_ORDER = 20;
543     bool public ON_SALE = false;                 
544 
545     constructor(address _proxyRegistryAddress) ERC721("LaCosaOstra", "OTOWN") {
546         proxyRegistryAddress = _proxyRegistryAddress;
547     }
548 
549     function mintToken(uint numberOfTokens) external payable  {
550         require(totalSupply().add(numberOfTokens) <= MAX_TOKENS, "Not enough tokens left to process order.");
551         require(ON_SALE || msg.sender == owner(), "These tokens are not on sale yet, nice try.");
552         require(numberOfTokens <= MAX_TOKENS_PER_ORDER, "Tried to buy too many in one go.");
553         require(numberOfTokens > 0, "You cannot mint 0 items.");
554         require(TOKEN_PRICE.mul(numberOfTokens) <= msg.value, 'Not enough Ethereum sent to buy that many');
555         for(uint i = 0; i < numberOfTokens; i++) {
556             uint mintIndex = totalSupply();
557             if (totalSupply() < MAX_TOKENS) {
558                 _safeMint(msg.sender, mintIndex);
559             }
560         }
561     }
562 
563     function airdropTokens(uint256 quantity, address userAddress) external onlyOwner {
564         for(uint i = 0; i < quantity; i++) {
565             uint mintIndex = totalSupply();
566             if (mintIndex < MAX_TOKENS) {
567                 _safeMint(userAddress, mintIndex);
568             }
569         }
570     }
571     
572     function changeTokenURI(uint256 tokenId, string memory _tokenURI) external onlyOwner {
573         _setTokenURI(tokenId, _tokenURI);
574     }
575 
576     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
577             require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
578             _tokenURIs[tokenId] = _tokenURI;
579     }
580 
581     function withdrawBalance() external onlyOwner {
582         uint256 balance = address(this).balance;
583         payable(oTownWallet).transfer(balance);
584     }
585 
586     function startSale() external onlyOwner {
587         ON_SALE = true;
588     }
589 
590     function stopSale() external onlyOwner {
591         ON_SALE = false;
592     }
593 
594     function setWithdrawalWallet(address _wallet) external onlyOwner {
595         oTownWallet = _wallet;
596     }
597 
598     function setMaxTokensPerOrder(uint256 quantity) external onlyOwner {
599         MAX_TOKENS_PER_ORDER = quantity;
600     }
601 
602     function setTokenPrice(uint256 price) external onlyOwner {
603         TOKEN_PRICE = price;
604     }
605 
606     function setMaxTokens(uint256 quantity) external onlyOwner {
607         MAX_TOKENS = quantity;
608     }
609 
610     function setBaseURI(string memory baseURI) external onlyOwner() {
611         BASE_URI = baseURI;
612     }
613     
614     function _baseURI() internal view override returns (string memory) {
615         return BASE_URI;
616     }
617 
618     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
619         uint256 tokenCount = balanceOf(_owner);
620         if (tokenCount == 0) {
621             // Return an empty array
622             return new uint256[](0);
623         } else {
624             uint256[] memory result = new uint256[](tokenCount);
625             uint256 index;
626             for (index = 0; index < tokenCount; index++) {
627                 result[index] = tokenOfOwnerByIndex(_owner, index);
628             }
629             return result;
630         }
631     }
632 
633     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
634             require(_exists(tokenId), "Token does not exist");
635 
636             string memory _tokenURI = _tokenURIs[tokenId];
637             string memory base = _baseURI();
638             
639             if (bytes(base).length == 0) {
640                 return _tokenURI;
641             }
642             if (bytes(_tokenURI).length > 0) {
643                 return string(abi.encodePacked(base, _tokenURI));
644             }
645             return string(abi.encodePacked(base, tokenId.toString()));
646     }
647     
648     function isApprovedForAll(address owner, address operator)
649         override
650         public
651         view
652         returns (bool)
653     {
654         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
655         if (address(proxyRegistry.proxies(owner)) == operator) {
656             return true;
657         }
658 
659         return super.isApprovedForAll(owner, operator);
660     }
661 }