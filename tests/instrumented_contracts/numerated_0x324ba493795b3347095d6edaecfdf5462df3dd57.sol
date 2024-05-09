1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.13;
3 
4 library Counters {
5   struct Counter {
6     uint256 _value;
7   }
8   function current(Counter storage counter) internal view returns (uint256) {
9     return counter._value;
10   }
11   function increment(Counter storage counter) internal {
12     unchecked {
13       counter._value += 1;
14     }
15   }
16   function decrement(Counter storage counter) internal {
17     uint256 value = counter._value;
18     require(value > 0, "Counter: decrement overflow");
19     unchecked {
20       counter._value = value - 1;
21     }
22   }
23   function reset(Counter storage counter) internal {
24     counter._value = 0;
25   }
26 }
27 
28 library Strings {
29   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
30   function toString(uint256 value) internal pure returns (string memory) {
31     if (value == 0) {
32       return "0";
33     }
34     uint256 temp = value;
35     uint256 digits;
36     while (temp != 0) {
37       digits++;
38       temp /= 10;
39     }
40     bytes memory buffer = new bytes(digits);
41     while (value != 0) {
42       digits -= 1;
43       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44       value /= 10;
45     }
46     return string(buffer);
47   }
48 }
49 
50 library SafeMath {
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     return a + b;
53   }
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     return a - b;
56   }
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     return a * b;
59   }
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     return a / b;
62   }
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     return a % b;
65   }
66   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67     unchecked {
68       require(b <= a, errorMessage);
69       return a - b;
70     }
71   }
72   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73     unchecked {
74       require(b > 0, errorMessage);
75       return a / b;
76     }
77   }
78   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79     unchecked {
80       require(b > 0, errorMessage);
81       return a % b;
82     }
83   }
84 }
85 
86 abstract contract Context {
87   function _msgSender() internal view virtual returns (address) {
88     return msg.sender;
89   }
90 }
91 
92 abstract contract Ownable is Context {
93   address private _owner;
94   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95   constructor() {
96     _transferOwnership(_msgSender());
97   }
98   function owner() public view virtual returns (address) {
99     return _owner;
100   }
101   modifier onlyOwner() {
102     require(owner() == _msgSender(), "Ownable: caller is not the owner");
103     _;
104   }
105   function renounceOwnership() public virtual onlyOwner {
106     _transferOwnership(address(0));
107   }
108   function transferOwnership(address newOwner) public virtual onlyOwner {
109     require(newOwner != address(0), "Ownable: new owner is the zero address");
110     _transferOwnership(newOwner);
111   }
112   function _transferOwnership(address newOwner) internal virtual {
113     address oldOwner = _owner;
114     _owner = newOwner;
115     emit OwnershipTransferred(oldOwner, newOwner);
116   }
117 }
118 
119 abstract contract ContextMixin {
120   function msgSender() internal view returns (address payable sender) {
121     if (msg.sender == address(this)) {
122       bytes memory array = msg.data;
123       uint256 index = msg.data.length;
124       assembly {
125         sender := and(
126           mload(add(array, index)),
127           0xffffffffffffffffffffffffffffffffffffffff
128         )
129       }
130     } else {
131       sender = payable(msg.sender);
132     }
133     return sender;
134   }
135 }
136 
137 contract Initializable {
138   bool inited = false;
139   modifier initializer() {
140     require(!inited, "already inited");
141     _;
142     inited = true;
143   }
144 }
145 
146 contract EIP712Base is Initializable {
147   struct EIP712Domain {
148     string name;
149     string version;
150     address verifyingContract;
151     bytes32 salt;
152   }
153   string constant public ERC712_VERSION = "1";
154   bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
155     bytes(
156       "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
157     )
158   );
159   bytes32 internal domainSeperator;
160 
161   function _initializeEIP712(string memory name) internal initializer {
162     _setDomainSeperator(name);
163   }
164   function _setDomainSeperator(string memory name) internal {
165     domainSeperator = keccak256(
166       abi.encode(
167         EIP712_DOMAIN_TYPEHASH,
168         keccak256(bytes(name)),
169         keccak256(bytes(ERC712_VERSION)),
170         address(this),
171         bytes32(getChainId())
172       )
173     );
174   }
175   function getDomainSeperator() public view returns (bytes32) {
176     return domainSeperator;
177   }
178   function getChainId() public view returns (uint256) {
179     uint256 id;
180     assembly {
181       id := chainid()
182     }
183     return id;
184   }
185   function toTypedMessageHash(bytes32 messageHash) internal view returns (bytes32) {
186     return
187       keccak256(
188         abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
189       );
190   }
191 }
192 
193 contract NativeMetaTransaction is EIP712Base {
194   using SafeMath for uint256;
195   bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
196     bytes(
197       "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
198     )
199   );
200   event MetaTransactionExecuted(address userAddress, address payable relayerAddress, bytes functionSignature);
201   mapping(address => uint256) nonces;
202   struct MetaTransaction {
203     uint256 nonce;
204     address from;
205     bytes functionSignature;
206   }
207 
208   function executeMetaTransaction(address userAddress, bytes memory functionSignature, bytes32 sigR, bytes32 sigS, uint8 sigV) public payable returns (bytes memory) {
209     MetaTransaction memory metaTx = MetaTransaction({
210       nonce: nonces[userAddress],
211       from: userAddress,
212       functionSignature: functionSignature
213     });
214     require(
215       verify(userAddress, metaTx, sigR, sigS, sigV),
216       "Signer and signature do not match"
217     );
218     nonces[userAddress] = nonces[userAddress].add(1);
219     emit MetaTransactionExecuted(userAddress, payable(msg.sender), functionSignature);
220     (bool success, bytes memory returnData) = address(this).call(
221       abi.encodePacked(functionSignature, userAddress)
222     );
223     require(success, "Function call not successful");
224     return returnData;
225   }
226   function hashMetaTransaction(MetaTransaction memory metaTx) internal pure returns (bytes32) {
227     return
228       keccak256(
229         abi.encode(
230           META_TRANSACTION_TYPEHASH,
231           metaTx.nonce,
232           metaTx.from,
233           keccak256(metaTx.functionSignature)
234         )
235       );
236   }
237   function getNonce(address user) public view returns (uint256 nonce) {
238     nonce = nonces[user];
239   }
240   function verify(address signer, MetaTransaction memory metaTx, bytes32 sigR, bytes32 sigS, uint8 sigV) internal view returns (bool) {
241     require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
242     return
243       signer ==
244       ecrecover(
245         toTypedMessageHash(hashMetaTransaction(metaTx)),
246         sigV,
247         sigR,
248         sigS
249       );
250   }
251 }
252 
253 interface IERC165 {
254   function supportsInterface(bytes4 interfaceId) external view returns (bool);
255 }
256 
257 abstract contract ERC165 is IERC165 {
258   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
259     return interfaceId == type(IERC165).interfaceId;
260   }
261 }
262 
263 interface IERC721 is IERC165 {
264   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
265   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
266   event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
267   function balanceOf(address owner) external view returns (uint256 balance);
268   function ownerOf(uint256 tokenId) external view returns (address owner);
269   function safeTransferFrom(address from, address to, uint256 tokenId) external;
270   function transferFrom(address from, address to, uint256 tokenId) external;
271   function approve(address to, uint256 tokenId) external;
272   function getApproved(uint256 tokenId) external view returns (address operator);
273   function setApprovalForAll(address operator, bool _approved) external;
274   function isApprovedForAll(address owner, address operator) external view returns (bool);
275   function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
276 }
277 
278 interface IERC721Metadata is IERC721 {
279   function name() external view returns (string memory);
280   function symbol() external view returns (string memory);
281 }
282 
283 library Address {
284   function isContract(address account) internal view returns (bool) {
285     uint256 size;
286     assembly {
287       size := extcodesize(account)
288     }
289     return size > 0;
290   }
291   function sendValue(address payable recipient, uint256 amount) internal {
292     require(address(this).balance >= amount, "Address: insufficient balance");
293     (bool success, ) = recipient.call{value: amount}("");
294     require(success, "Address: unable to send value, recipient may have reverted");
295   }
296   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
297     return functionCall(target, data, "Address: low-level call failed");
298   }
299   function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
300     return functionCallWithValue(target, data, 0, errorMessage);
301   }
302   function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
303     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
304   }
305   function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
306     require(address(this).balance >= value, "Address: insufficient balance for call");
307     require(isContract(target), "Address: call to non-contract");
308     (bool success, bytes memory returndata) = target.call{value: value}(data);
309     return verifyCallResult(success, returndata, errorMessage);
310   }
311   function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
312     return functionStaticCall(target, data, "Address: low-level static call failed");
313   }
314   function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
315     require(isContract(target), "Address: static call to non-contract");
316     (bool success, bytes memory returndata) = target.staticcall(data);
317     return verifyCallResult(success, returndata, errorMessage);
318   }
319   function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
320     return functionDelegateCall(target, data, "Address: low-level delegate call failed");
321   }
322   function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
323     require(isContract(target), "Address: delegate call to non-contract");
324     (bool success, bytes memory returndata) = target.delegatecall(data);
325     return verifyCallResult(success, returndata, errorMessage);
326   }
327   function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
328     if (success) {
329       return returndata;
330     } else {
331       if (returndata.length > 0) {
332         assembly {
333           let returndata_size := mload(returndata)
334           revert(add(32, returndata), returndata_size)
335         }
336       } else {
337         revert(errorMessage);
338       }
339     }
340   }
341 }
342 
343 interface IERC721Receiver {
344   function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
345 }
346 
347 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
348   using Address for address;
349   using Strings for uint256;
350   string private _name;
351   string private _symbol;
352   mapping(uint256 => address) private _owners;
353   mapping(address => uint256) private _balances;
354   mapping(uint256 => address) private _tokenApprovals;
355   mapping(address => mapping(address => bool)) private _operatorApprovals;
356 
357   constructor(string memory name_, string memory symbol_) {
358     _name = name_;
359     _symbol = symbol_;
360   }
361   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
362     return
363       interfaceId == type(IERC721).interfaceId ||
364       interfaceId == type(IERC721Metadata).interfaceId ||
365       super.supportsInterface(interfaceId);
366   }
367   function balanceOf(address owner) public view virtual override returns (uint256) {
368     require(owner != address(0), "ERC721: balance query for the zero address");
369     return _balances[owner];
370   }
371   function ownerOf(uint256 tokenId) public view virtual override returns (address) {
372     address owner = _owners[tokenId];
373     require(owner != address(0), "ERC721: owner query for nonexistent token");
374     return owner;
375   }
376   function name() public view virtual override returns (string memory) {
377     return _name;
378   }
379   function symbol() public view virtual override returns (string memory) {
380     return _symbol;
381   }
382   function approve(address to, uint256 tokenId) public virtual override {
383     address owner = ERC721.ownerOf(tokenId);
384     require(to != owner, "ERC721: approval to current owner");
385     require(
386       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
387       "ERC721: approve caller is not owner nor approved for all"
388     );
389     _approve(to, tokenId);
390   }
391   function getApproved(uint256 tokenId) public view virtual override returns (address) {
392     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
393     return _tokenApprovals[tokenId];
394   }
395   function setApprovalForAll(address operator, bool approved) public virtual override {
396     _setApprovalForAll(_msgSender(), operator, approved);
397   }
398   function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
399     return _operatorApprovals[owner][operator];
400   }
401   function transferFrom(address from, address to, uint256 tokenId) public virtual override {
402     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
403     _transfer(from, to, tokenId);
404   }
405   function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
406     safeTransferFrom(from, to, tokenId, "");
407   }
408   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
409     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
410     _safeTransfer(from, to, tokenId, _data);
411   }
412   function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
413     _transfer(from, to, tokenId);
414     require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
415   }
416   function _exists(uint256 tokenId) internal view virtual returns (bool) {
417     return _owners[tokenId] != address(0);
418   }
419   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
420     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
421     address owner = ERC721.ownerOf(tokenId);
422     return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
423   }
424   function _safeMint(address to, uint256 tokenId) internal virtual {
425     _safeMint(to, tokenId, "");
426   }
427   function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
428     _mint(to, tokenId);
429     require(
430       _checkOnERC721Received(address(0), to, tokenId, _data),
431       "ERC721: transfer to non ERC721Receiver implementer"
432     );
433   }
434   function _mint(address to, uint256 tokenId) internal virtual {
435     require(to != address(0), "ERC721: mint to the zero address");
436     require(!_exists(tokenId), "ERC721: token already minted");
437     _beforeTokenTransfer(address(0), to, tokenId);
438     _balances[to] += 1;
439     _owners[tokenId] = to;
440     emit Transfer(address(0), to, tokenId);
441   }
442   function _burn(uint256 tokenId) internal virtual {
443     address owner = ERC721.ownerOf(tokenId);
444     _beforeTokenTransfer(owner, address(0), tokenId);
445     _approve(address(0), tokenId);
446     _balances[owner] -= 1;
447     delete _owners[tokenId];
448     emit Transfer(owner, address(0), tokenId);
449   }
450   function _transfer(address from, address to, uint256 tokenId) internal virtual {
451     require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
452     require(to != address(0), "ERC721: transfer to the zero address");
453     _beforeTokenTransfer(from, to, tokenId);
454     _approve(address(0), tokenId);
455     _balances[from] -= 1;
456     _balances[to] += 1;
457     _owners[tokenId] = to;
458     emit Transfer(from, to, tokenId);
459   }
460   function _approve(address to, uint256 tokenId) internal virtual {
461     _tokenApprovals[tokenId] = to;
462     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
463   }
464   function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
465     require(owner != operator, "ERC721: approve to caller");
466     _operatorApprovals[owner][operator] = approved;
467     emit ApprovalForAll(owner, operator, approved);
468   }
469   function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
470     if (to.isContract()) {
471       try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
472         return retval == IERC721Receiver.onERC721Received.selector;
473       } catch (bytes memory reason) {
474         if (reason.length == 0) {
475           revert("ERC721: transfer to non ERC721Receiver implementer");
476         } else {
477           assembly {
478             revert(add(32, reason), mload(reason))
479           }
480         }
481       }
482     } else {
483       return true;
484     }
485   }
486   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
487 }
488 
489 contract Escrow is Ownable {
490   using Address for address payable;
491   event Deposited(address indexed payee, uint256 weiAmount);
492   event Withdrawn(address indexed payee, uint256 weiAmount);
493   mapping(address => uint256) private _deposits;
494 
495   function depositsOf(address payee) public view returns (uint256) {
496     return _deposits[payee];
497   }
498   function deposit(address payee) public payable virtual onlyOwner {
499     uint256 amount = msg.value;
500     _deposits[payee] += amount;
501     emit Deposited(payee, amount);
502   }
503   function withdraw(address payable payee) public virtual onlyOwner {
504     uint256 payment = _deposits[payee];
505     _deposits[payee] = 0;
506     payee.sendValue(payment);
507     emit Withdrawn(payee, payment);
508   }
509 }
510 
511 abstract contract PullPayment {
512   Escrow private immutable _escrow;
513   constructor() {
514     _escrow = new Escrow();
515   }
516   function withdrawPayments(address payable payee) public virtual {
517     _escrow.withdraw(payee);
518   }
519   function payments(address dest) public view returns (uint256) {
520     return _escrow.depositsOf(dest);
521   }
522   function _asyncTransfer(address dest, uint256 amount) internal virtual {
523     _escrow.deposit{value: amount}(dest);
524   }
525 }
526 
527 contract OwnableDelegateProxy {}
528 contract ProxyRegistry {
529   mapping(address => OwnableDelegateProxy) public proxies;
530 }
531 
532 contract LastDragonsGen1 is ERC721, PullPayment, ContextMixin, NativeMetaTransaction, Ownable {
533   using SafeMath for uint256;
534   using Counters for Counters.Counter;
535 
536   uint256 public constant TOTAL_SUPPLY = 2222;
537   uint256 public constant MINT_PRICE = 0.08 ether;
538 
539   Counters.Counter private _nextTokenId;
540   address proxyRegistryAddress;
541   string public baseTokenURI;
542   
543   constructor() ERC721("LastDragons Gen1", "LDG1") {
544     baseTokenURI = "";
545     _initializeEIP712("LastDragons Gen1");
546   }
547   function mintToAdmin(address recipient) public onlyOwner returns (uint256) {
548     uint256 tokenId = _nextTokenId.current();
549     require(tokenId < TOTAL_SUPPLY, "Max supply reached");
550     _nextTokenId.increment();
551     uint256 newItemId = _nextTokenId.current();
552     _safeMint(recipient, newItemId);
553     return newItemId;
554   }
555   function mintTo(address recipient) public payable returns (uint256) {
556     uint256 tokenId = _nextTokenId.current();
557     require(tokenId < TOTAL_SUPPLY, "Max supply reached");
558     require(msg.value == MINT_PRICE, "Transaction value did not equal the mint price");
559     _nextTokenId.increment();
560     uint256 newItemId = _nextTokenId.current();
561     _safeMint(recipient, newItemId);
562     return newItemId;
563   }
564   function totalSupply() public view returns (uint256) {
565     return _nextTokenId.current();
566   }
567   function tokenURI(uint256 _tokenId) public view returns (string memory) {
568     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
569     string memory baseURI = baseTokenURI;
570     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(_tokenId))) : "";
571   }
572   function setProxyRegistryAddress(address _proxyRegistryAddress) public onlyOwner() {
573     proxyRegistryAddress = _proxyRegistryAddress;
574   }
575   function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
576     baseTokenURI = _baseTokenURI;
577   }
578   function isApprovedForAll(address owner, address operator) override public view returns (bool) {
579     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
580     if (address(proxyRegistry.proxies(owner)) == operator) {
581       return true;
582     }
583     return super.isApprovedForAll(owner, operator);
584   }
585   function _msgSender() internal override view returns (address sender) {
586     return ContextMixin.msgSender();
587   }
588   function withdrawPayments(address payable payee) public override onlyOwner virtual {
589     super.withdrawPayments(payee);
590   }
591 }