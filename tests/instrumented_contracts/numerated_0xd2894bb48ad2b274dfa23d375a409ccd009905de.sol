1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 library Address {
6   
7     function isContract(address account) internal view returns (bool) {
8        
9         uint256 size;
10         assembly { size := extcodesize(account) }
11         return size > 0;
12     }
13 
14 }
15 library SafeMath {
16 
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         if (a == 0) {
22             return 0;
23         }
24         c = a * b;
25         require(c / a == b);
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers, truncating the quotient.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         // uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return a / b;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         return a - b;
45     }
46 
47     /**
48     * @dev Adds two numbers, throws on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51         c = a + b;
52         require(c >= a);
53         return c;
54     }
55 }
56 
57 
58 interface IAccessControl {
59     function hasRole(bytes32 role, address account) external view returns (bool);
60     function getRoleAdmin(bytes32 role) external view returns (bytes32);
61     function grantRole(bytes32 role, address account) external;
62     function revokeRole(bytes32 role, address account) external;
63     function renounceRole(bytes32 role, address account) external;
64 }
65 
66 interface IERC165 {
67     function supportsInterface(bytes4 interfaceId) external view returns (bool);
68 }
69 
70 interface IERC721Receiver {
71     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
72 }
73 
74 interface IERC721 is IERC165 {
75     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
76     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
77     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
78     event Mint(uint indexed index, address indexed minter);
79     event Withdraw(address indexed account, uint indexed amount);
80     event SaleIsStarted();
81 
82     function balanceOf(address owner) external view returns (uint256 balance);
83     function ownerOf(uint256 tokenId) external view returns (address owner);
84     function safeTransferFrom(address from, address to, uint256 tokenId) external;
85     function transferFrom(address from, address to, uint256 tokenId) external;
86     function approve(address to, uint256 tokenId) external;
87     function getApproved(uint256 tokenId) external view returns (address operator);
88     function setApprovalForAll(address operator, bool _approved) external;
89     function isApprovedForAll(address owner, address operator) external view returns (bool);
90     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
91 }
92 
93 interface IERC721Metadata is IERC721 {
94     function name() external view returns (string memory);
95     function symbol() external view returns (string memory);
96     function tokenURI(uint256 tokenId) external view returns (string memory);
97 }
98 
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104 }
105 
106 abstract contract ERC165 is IERC165 {
107        function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
108         return interfaceId == type(IERC165).interfaceId;
109     }
110 }
111 
112 abstract contract Ownable is Context {
113     address private _owner;
114 
115     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
116 
117     /**
118      * @dev Initializes the contract setting the deployer as the initial owner.
119      */
120     constructor() {
121         _setOwner(_msgSender());
122     }
123 
124     /**
125      * @dev Returns the address of the current owner.
126      */
127     function owner() public view virtual returns (address) {
128         return _owner;
129     }
130 
131     /**
132      * @dev Throws if called by any account other than the owner.
133      */
134     modifier onlyOwner() {
135         require(owner() == _msgSender(), "Ownable: caller is not the owner");
136         _;
137     }
138 
139     /**
140      * @dev Leaves the contract without owner. It will not be possible to call
141      * `onlyOwner` functions anymore. Can only be called by the current owner.
142      *
143      * NOTE: Renouncing ownership will leave the contract without an owner,
144      * thereby removing any functionality that is only available to the owner.
145      */
146     function renounceOwnership() public virtual onlyOwner {
147         _setOwner(address(0));
148     }
149 
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      * Can only be called by the current owner.
153      */
154     function transferOwnership(address newOwner) public virtual onlyOwner {
155         require(newOwner != address(0), "Ownable: new owner is the zero address");
156         _setOwner(newOwner);
157     }
158 
159     function _setOwner(address newOwner) private {
160         address oldOwner = _owner;
161         _owner = newOwner;
162         emit OwnershipTransferred(oldOwner, newOwner);
163     }
164 }
165 
166 abstract contract AccessControl is Context, IAccessControl, ERC165 {
167     struct RoleData {
168         mapping (address => bool) members;
169         bytes32 adminRole;
170     }
171 
172     mapping (bytes32 => RoleData) private _roles;
173     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
174 
175     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
176     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
177     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
178 
179     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
180         return interfaceId == type(IAccessControl).interfaceId
181             || super.supportsInterface(interfaceId);
182     }
183 
184     function hasRole(bytes32 role, address account) public view override returns (bool) {
185         return _roles[role].members[account];
186     }
187 
188     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
189         return _roles[role].adminRole;
190     }
191 
192     function grantRole(bytes32 role, address account) public virtual override {
193         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
194 
195         _grantRole(role, account);
196     }
197 
198     function revokeRole(bytes32 role, address account) public virtual override {
199         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
200 
201         _revokeRole(role, account);
202     }
203 
204     function renounceRole(bytes32 role, address account) public virtual override {
205         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
206 
207         _revokeRole(role, account);
208     }
209 
210     function _setupRole(bytes32 role, address account) internal virtual {
211         _grantRole(role, account);
212     }
213 
214     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
215         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
216         _roles[role].adminRole = adminRole;
217     }
218 
219     function _grantRole(bytes32 role, address account) private {
220         if (!hasRole(role, account)) {
221             _roles[role].members[account] = true;
222             emit RoleGranted(role, account, _msgSender());
223         }
224     }
225 
226     function _revokeRole(bytes32 role, address account) private {
227         if (hasRole(role, account)) {
228             _roles[role].members[account] = false;
229             emit RoleRevoked(role, account, _msgSender());
230         }
231     }
232 }
233 
234 contract ERC721 is  Context, ERC165,Ownable, AccessControl, IERC721, IERC721Metadata {
235     using Address for address;
236     using SafeMath for uint256;
237 
238     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
239     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
240 
241     string private _name;
242     string private _symbol;
243     string internal baseURI;
244     uint256 internal tokensSold = 0;
245     bool public _startSale = false;
246 
247     uint256 constant MAX_SUPPLY = 10000;
248 
249 
250     mapping (uint256 => address) private _owners;
251     mapping (address => uint256) private _balances;
252     mapping (uint256 => address) private _tokenApprovals;
253     mapping (address => mapping (address => bool)) private _operatorApprovals;
254     mapping (uint256 => string) private _tokenURIs;
255     mapping (address => uint256[]) public tokensPerOwner;
256     mapping(address => uint256[]) internal ownerToIds;
257     mapping(uint256 => uint256) internal idToOwnerIndex;
258    
259 
260    
261     constructor (string memory name_, string memory symbol_,string memory baseURI_) {
262         _name = name_;
263         _symbol = symbol_;
264         baseURI = baseURI_;
265     }
266     
267 
268     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165, AccessControl) returns (bool) {
269         return interfaceId == type(IERC721).interfaceId
270             || interfaceId == type(IERC721Metadata).interfaceId
271             || super.supportsInterface(interfaceId);
272     }
273 
274     function balanceOf(address owner) public view virtual override returns (uint256) {
275         require(owner != address(0), "ERC721: balance query for the zero address");
276         return _balances[owner];
277     }
278 
279     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
280         address owner = _owners[tokenId];
281         require(owner != address(0), "ERC721: owner query for nonexistent token");
282         return owner;
283     }
284 
285     function name() public view virtual override returns (string memory) {
286         return _name;
287     }
288 
289     function symbol() public view virtual override returns (string memory) {
290         return _symbol;
291     }
292 
293 
294     function totalSupply() public view returns (uint256) {
295         return tokensSold;
296     }
297 
298     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
299         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
300         return string(abi.encodePacked(_baseURI(), toString(tokenId)));
301     }
302 
303     function _baseURI() internal view virtual returns (string memory) {
304         return baseURI;
305     }
306 
307 
308     function approve(address to, uint256 tokenId) public virtual override {
309         address owner = ERC721.ownerOf(tokenId);
310         require(to != owner, "ERC721: approval to current owner");
311 
312         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
313             "ERC721: approve caller is not owner nor approved for all"
314         );
315 
316         _approve(to, tokenId);
317     }
318 
319     function getApproved(uint256 tokenId) public view virtual override returns (address) {
320         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
321 
322         return _tokenApprovals[tokenId];
323     }
324 
325     function setApprovalForAll(address operator, bool approved) public virtual override {
326         require(operator != _msgSender(), "ERC721: approve to caller");
327 
328         _operatorApprovals[_msgSender()][operator] = approved;
329         emit ApprovalForAll(_msgSender(), operator, approved);
330     }
331 
332     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
333         return _operatorApprovals[owner][operator];
334     }
335 
336     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
337         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
338 
339         _transfer(from, to, tokenId);
340     }
341 
342     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
343         safeTransferFrom(from, to, tokenId, "");
344     }
345 
346     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
347         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
348         _safeTransfer(from, to, tokenId, _data);
349     }
350 
351     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
352         _transfer(from, to, tokenId);
353         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
354     }
355 
356     function _exists(uint256 tokenId) internal view virtual returns (bool) {
357         return _owners[tokenId] != address(0);
358     }
359 
360     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
361         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
362         address owner = ERC721.ownerOf(tokenId);
363         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
364     }
365 
366     function _safeMint(address to, uint256 tokenId) internal virtual {
367         _safeMint(to, tokenId, "");
368     }
369 
370     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
371         _mint(to, tokenId);
372         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
373     }
374 
375     function toString(uint256 value) internal pure returns (string memory) {
376            
377         if (value == 0) {
378             return "0";
379         }
380         uint256 temp = value;
381         uint256 digits;
382         while (temp != 0) {
383             digits++;
384             temp /= 10;
385         }
386         bytes memory buffer = new bytes(digits);
387         while (value != 0) {
388             digits -= 1;
389             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
390             value /= 10;
391         }
392         return string(buffer);
393     }
394 
395 
396     function _addNFToken(address _to, uint256 _tokenId) internal {
397         require(_owners[_tokenId] == address(0), "Cannot add, already owned.");
398         _owners[_tokenId] = _to;
399 
400         ownerToIds[_to].push(_tokenId);
401         idToOwnerIndex[_tokenId] = ownerToIds[_to].length.sub(1);
402     }
403 
404     function _removeNFToken(address _from, uint256 _tokenId) internal {
405         require(_owners[_tokenId] == _from, "Incorrect owner.");
406         delete _owners[_tokenId];
407         uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
408         uint256 lastTokenIndex = ownerToIds[_from].length.sub(1);
409 
410         if (lastTokenIndex != tokenToRemoveIndex) {
411             uint256 lastToken = ownerToIds[_from][lastTokenIndex];
412             ownerToIds[_from][tokenToRemoveIndex] = lastToken;
413             idToOwnerIndex[lastToken] = tokenToRemoveIndex;
414         }
415 
416         ownerToIds[_from].pop();
417     }
418 
419     function _mint(address to, uint256 tokenId) internal virtual {
420         require(to != address(0), "ERC721: mint to the zero address");
421         require(!_exists(tokenId), "ERC721: token already minted");
422 
423         _beforeTokenTransfer(address(0), to, tokenId);
424 
425         _balances[to] += 1;
426         tokensSold += 1;
427         tokensPerOwner[to].push(tokenId);
428         _addNFToken(to, tokenId);
429         emit Mint(tokenId, to);
430         emit Transfer(address(0), to, tokenId);
431     }
432 
433     function devMint(uint count, address recipient) external {
434         require(hasRole(MINTER_ROLE, _msgSender()), "You must have minter role to change baseURI");
435         require(tokensSold+count <=10000, "The tokens limit has reached.");
436         for (uint i = 0; i < count; i++) {
437             uint256 _tokenId = tokensSold + 1;
438             _mint(recipient, _tokenId);
439         }
440     }
441 
442 
443     
444     function _burn(uint256 tokenId) internal virtual {
445         address owner = ERC721.ownerOf(tokenId);
446 
447         _beforeTokenTransfer(owner, address(0), tokenId);
448 
449         _approve(address(0), tokenId);
450 
451         _balances[owner] -= 1;
452         delete _owners[tokenId];
453         tokensPerOwner[owner].push(tokenId);
454         emit Transfer(owner, address(0), tokenId);
455     }
456 
457     function _transfer(address from, address to, uint256 tokenId) internal virtual {
458         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
459         require(to != address(0), "ERC721: transfer to the zero address");
460 
461         _beforeTokenTransfer(from, to, tokenId);
462 
463         _approve(address(0), tokenId);
464         
465         _removeNFToken(from, tokenId);
466         _addNFToken(to, tokenId);
467 
468         _balances[from] -= 1;
469         _balances[to] += 1;
470         
471         emit Transfer(from, to, tokenId);
472     }
473 
474     function _approve(address to, uint256 tokenId) internal virtual {
475         _tokenApprovals[tokenId] = to;
476         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
477     }
478 
479     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
480         private returns (bool)
481     {
482         if (to.isContract()) {
483             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
484                 return retval == IERC721Receiver(to).onERC721Received.selector;
485             } catch (bytes memory reason) {
486                 if (reason.length == 0) {
487                     revert("ERC721: transfer to non ERC721Receiver implementer");
488                 } else {
489                     // solhint-disable-next-line no-inline-assembly
490                     assembly {
491                         revert(add(32, reason), mload(reason))
492                     }
493                 }
494             }
495         } else {
496             return true;
497         }
498     }
499 
500     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
501 }
502 
503 contract Characters is ERC721  {
504     using SafeMath for uint256;
505 
506     bool private lock = false;
507     bool public contractPaused;
508    
509     constructor() ERC721("Characters", "CHFTG", " https://character-generator.xyz/json/") {
510 
511         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
512         _setupRole(ADMIN_ROLE, _msgSender());
513         _setupRole(MINTER_ROLE, _msgSender());
514     }
515     modifier nonReentrant {
516         require(!lock, "ReentrancyGuard: reentrant call");
517         lock = true;
518         _;
519         lock = false;
520     }
521     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
522         return super.supportsInterface(interfaceId);
523     }
524 
525     function pauseContract(bool _paused) external  {
526         require(hasRole(MINTER_ROLE, _msgSender()), "You must have minter role to pause the contract");
527         contractPaused = _paused;
528     }
529 
530     function setBaseURI(string memory newURI) public returns (bool) {
531         require(hasRole(MINTER_ROLE, _msgSender()), "You must have minter role to change baseURI");
532         baseURI = newURI;
533         return true;
534 
535     }
536 
537     function getTokensByOwner(address _owner) public view returns (uint256[] memory){
538         return ownerToIds[_owner];
539     }
540 
541    
542     function startSale() external {
543         require(hasRole(MINTER_ROLE, _msgSender()), "You must have minter role to change baseURI");
544         require(!_startSale);
545         _startSale = true;
546         emit SaleIsStarted();
547     }
548 
549     function birth()external nonReentrant returns(bool, uint){
550         require(!contractPaused);
551         require(_startSale, "The sale hasn't started.");
552         require(tokensSold+1 <=10000, "The tokens limit has reached.");
553         uint _tokenId = tokensSold + 1;
554         _mint(_msgSender(), _tokenId);        
555         return (true,_tokenId);
556     }
557 
558 }