1 pragma solidity ^0.5.2;
2 
3 
4 interface ERC165Interface {
5     
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 contract ERC721Interface is ERC165Interface {
10     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
11     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
12     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
13 
14     function balanceOf(address owner) public view returns (uint256 balance);
15     function ownerOf(uint256 tokenId) public view returns (address owner);
16     function approve(address to, uint256 tokenId) public;
17     function getApproved(uint256 tokenId) public view returns (address operator);
18     function setApprovalForAll(address operator, bool _approved) public;
19     function isApprovedForAll(address owner, address operator) public view returns (bool);
20     function transferFrom(address from, address to, uint256 tokenId) public;
21     function safeTransferFrom(address from, address to, uint256 tokenId) public;
22     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
23 }
24 
25 contract ERC721MetadataInterface is ERC721Interface {
26     function name() external view returns (string memory);
27     function symbol() external view returns (string memory);
28     function tokenURI(uint256 tokenId) external view returns (string memory);
29 }
30 
31 contract ERC721EnumerableInterface is ERC721Interface {
32     function totalSupply() public view returns (uint256);
33     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
34     function tokenByIndex(uint256 index) public view returns (uint256);
35 }
36 
37 contract ERC165 is ERC165Interface {
38     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
39     
40 
41     
42     mapping(bytes4 => bool) private _supportedInterfaces;
43 
44     
45     constructor () internal {
46         _registerInterface(_INTERFACE_ID_ERC165);
47     }
48 
49     
50     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
51         return _supportedInterfaces[interfaceId];
52     }
53 
54     
55     function _registerInterface(bytes4 interfaceId) internal {
56         require(interfaceId != 0xffffffff);
57         _supportedInterfaces[interfaceId] = true;
58     }
59 }
60 
61 contract Ownable {
62     address private _owner;
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     
67     constructor () internal {
68         _owner = msg.sender;
69         emit OwnershipTransferred(address(0), _owner);
70     }
71 
72     
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     
78     modifier onlyOwner() {
79         require(isOwner());
80         _;
81     }
82 
83     
84     function isOwner() public view returns (bool) {
85         return msg.sender == _owner;
86     }
87 
88     
89     function renounceOwnership() public onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94     
95     function transferOwnership(address newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     
100     function _transferOwnership(address newOwner) internal {
101         require(newOwner != address(0));
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105 }
106 
107 contract ERC721ReceiverInterface {
108     
109     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
110     public returns (bytes4);
111 }
112 
113 library SafeMath {
114     
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         
117         
118         
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b);
125 
126         return c;
127     }
128 
129     
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         
132         require(b > 0);
133         uint256 c = a / b;
134         
135 
136         return c;
137     }
138 
139     
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b <= a);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         uint256 c = a + b;
150         require(c >= a);
151 
152         return c;
153     }
154 
155     
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b != 0);
158         return a % b;
159     }
160 }
161 
162 contract ERC721Extended is ERC721Interface, ERC721MetadataInterface, ERC721EnumerableInterface, ERC165, Ownable {
163     using SafeMath for uint256;
164 
165     
166     mapping(uint256 => address) private _tokenOwner;
167 
168     
169     mapping(uint256 => address) private _tokenApprovals;
170 
171     
172     mapping(address => uint256) private _ownedTokensCount;
173 
174     
175     mapping(address => mapping (address => bool)) private _operatorApprovals;
176 
177     
178     string private _name;
179 
180     
181     string private _symbol;
182 
183     
184     mapping(uint256 => string) private _tokenURIs;
185 
186     
187     mapping(address => uint256[]) private _ownedTokens;
188 
189     
190     mapping(uint256 => uint256) private _ownedTokensIndex;
191 
192     
193     uint256[] private _allTokens;
194 
195     
196     mapping(uint256 => uint256) private _allTokensIndex;
197 
198     
199     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
200 
201     
202     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
203 
204     
205     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
206 
207     
208     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
209 
210     
211     constructor(string memory name, string memory symbol) public {
212         _name = name;
213         _symbol = symbol;
214         _registerInterface(_INTERFACE_ID_ERC721);
215         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
216         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
217     }
218 
219     
220     function balanceOf(address owner) public view returns (uint256) {
221         require(owner != address(0));
222         return _current(owner);
223     }
224 
225     
226     function ownerOf(uint256 tokenId) public view returns (address) {
227         address owner = _tokenOwner[tokenId];
228         require(owner != address(0));
229         return owner;
230     }
231 
232     
233     function approve(address to, uint256 tokenId) public {
234         address owner = ownerOf(tokenId);
235         require(to != owner);
236         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
237 
238         _tokenApprovals[tokenId] = to;
239         emit Approval(owner, to, tokenId);
240     }
241 
242     
243     function getApproved(uint256 tokenId) public view returns (address) {
244         require(_exists(tokenId));
245         return _tokenApprovals[tokenId];
246     }
247 
248     
249     function setApprovalForAll(address to, bool approved) public {
250         require(to != msg.sender);
251         _operatorApprovals[msg.sender][to] = approved;
252         emit ApprovalForAll(msg.sender, to, approved);
253     }
254 
255     
256     function isApprovedForAll(address owner, address operator) public view returns (bool) {
257         return _operatorApprovals[owner][operator];
258     }
259 
260     
261     function transferFrom(address from, address to, uint256 tokenId) public {
262         require(_isApprovedOrOwner(msg.sender, tokenId));
263 
264         _transferFrom(from, to, tokenId);
265     }
266 
267     
268     function safeTransferFrom(address from, address to, uint256 tokenId) public {
269         safeTransferFrom(from, to, tokenId, "");
270     }
271 
272     
273     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
274         transferFrom(from, to, tokenId);
275         require(_checkOnERC721Received(from, to, tokenId, _data));
276     }
277 
278     
279     function _exists(uint256 tokenId) internal view returns (bool) {
280         address owner = _tokenOwner[tokenId];
281         return owner != address(0);
282     }
283 
284     
285     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
286         require(_exists(tokenId));
287         address owner = ownerOf(tokenId);
288         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
289     }
290 
291     
292     function _mint(address to, uint256 tokenId) internal {
293         require(to != address(0));
294         require(!_exists(tokenId));
295 
296         _tokenOwner[tokenId] = to;
297         _increment(to);
298 
299         _addTokenToOwnerEnumeration(to, tokenId);
300         _addTokenToAllTokensEnumeration(tokenId);
301 
302         emit Transfer(address(0), to, tokenId);
303     }
304 
305     
306     function _burn(address owner, uint256 tokenId) internal {
307         require(ownerOf(tokenId) == owner);
308 
309         _clearApproval(tokenId);
310 
311         _decrement(owner);
312         _tokenOwner[tokenId] = address(0);
313 
314         
315         if (bytes(_tokenURIs[tokenId]).length != 0) {
316             delete _tokenURIs[tokenId];
317         }
318 
319         _removeTokenFromOwnerEnumeration(owner, tokenId);
320         
321         _ownedTokensIndex[tokenId] = 0;
322         _removeTokenFromAllTokensEnumeration(tokenId);
323 
324         emit Transfer(owner, address(0), tokenId);
325     }
326 
327     
328     function _burn(uint256 tokenId) internal {
329         _burn(ownerOf(tokenId), tokenId);
330     }
331 
332     
333     function _transferFrom(address from, address to, uint256 tokenId) internal {
334         require(ownerOf(tokenId) == from);
335         require(to != address(0));
336 
337         _clearApproval(tokenId);
338 
339         _decrement(from);
340         _increment(to);
341 
342         _tokenOwner[tokenId] = to;
343 
344         _removeTokenFromOwnerEnumeration(from, tokenId);
345         _addTokenToOwnerEnumeration(to, tokenId);
346 
347         emit Transfer(from, to, tokenId);
348     }
349 
350     
351     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
352         internal returns (bool)
353     {
354         if (!_isContract(to)) {
355             return true;
356         }
357 
358         bytes4 retval = ERC721ReceiverInterface(to).onERC721Received(msg.sender, from, tokenId, _data);
359         return (retval == _ERC721_RECEIVED);
360     }
361 
362     
363     function name() external view returns (string memory) {
364         return _name;
365     }
366 
367     
368     function symbol() external view returns (string memory) {
369         return _symbol;
370     }
371 
372     
373     function tokenURI(uint256 tokenId) external view returns (string memory) {
374         require(_exists(tokenId));
375         return _tokenURIs[tokenId];
376     }
377 
378     
379     function setTokenURI(uint256 tokenId, string calldata uri) external onlyOwner {
380         _setTokenURI(tokenId, uri);
381     }
382 
383     
384     function _setTokenURI(uint256 tokenId, string memory uri) internal {
385         require(_exists(tokenId));
386         _tokenURIs[tokenId] = uri;
387     }
388 
389     
390     function totalSupply() public view returns (uint256) {
391         return _allTokens.length;
392     }
393 
394     
395     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
396         require(index < balanceOf(owner));
397         return _ownedTokens[owner][index];
398     }
399 
400     
401     function tokenByIndex(uint256 index) public view returns (uint256) {
402         require(index < totalSupply());
403         return _allTokens[index];
404     }
405 
406     
407     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
408         return _ownedTokens[owner];
409     }
410 
411     
412     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
413         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
414         _ownedTokens[to].push(tokenId);
415     }
416 
417     
418     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
419         _allTokensIndex[tokenId] = _allTokens.length;
420         _allTokens.push(tokenId);
421     }
422 
423     
424     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
425         
426         
427 
428         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
429         uint256 tokenIndex = _ownedTokensIndex[tokenId];
430 
431         
432         if (tokenIndex != lastTokenIndex) {
433             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
434 
435             _ownedTokens[from][tokenIndex] = lastTokenId; 
436             _ownedTokensIndex[lastTokenId] = tokenIndex; 
437         }
438 
439         
440         _ownedTokens[from].length--;
441 
442         
443         
444     }
445 
446     
447     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
448         
449         
450 
451         uint256 lastTokenIndex = _allTokens.length.sub(1);
452         uint256 tokenIndex = _allTokensIndex[tokenId];
453 
454         
455         
456         
457         uint256 lastTokenId = _allTokens[lastTokenIndex];
458 
459         _allTokens[tokenIndex] = lastTokenId; 
460         _allTokensIndex[lastTokenId] = tokenIndex; 
461 
462         
463         _allTokens.length--;
464         _allTokensIndex[tokenId] = 0;
465     }
466 
467     
468     function _isContract(address account) private view returns (bool) {
469         uint256 size;
470         assembly { size := extcodesize(account) }
471         return size > 0;
472     }
473 
474     
475     function _current(address tokenAddress) private view returns (uint256) {
476         return _ownedTokensCount[tokenAddress];
477     }
478 
479     
480     function _increment(address tokenAddress) private {
481         _ownedTokensCount[tokenAddress] = _ownedTokensCount[tokenAddress].add(1);
482     }
483 
484     
485     function _decrement(address tokenAddress) private {
486         _ownedTokensCount[tokenAddress] = _ownedTokensCount[tokenAddress].sub(1);
487     }
488 
489     
490     function _clearApproval(uint256 tokenId) private {
491         if (_tokenApprovals[tokenId] != address(0)) {
492             _tokenApprovals[tokenId] = address(0);
493         }
494     }
495   }
496 
497 contract RoleManager {
498 
499     mapping(address => bool) private admins;
500     mapping(address => bool) private controllers;
501 
502     modifier onlyAdmins {
503         require(admins[msg.sender], 'only admins');
504         _;
505     }
506 
507     modifier onlyControllers {
508         require(controllers[msg.sender], 'only controllers');
509         _;
510     } 
511 
512     constructor() public {
513         admins[msg.sender] = true;
514         controllers[msg.sender] = true;
515     }
516 
517     function addController(address _newController) external onlyAdmins{
518         controllers[_newController] = true;
519     } 
520 
521     function addAdmin(address _newAdmin) external onlyAdmins{
522         admins[_newAdmin] = true;
523     } 
524 
525     function removeController(address _controller) external onlyAdmins{
526         controllers[_controller] = false;
527     } 
528     
529     function removeAdmin(address _admin) external onlyAdmins{
530         require(_admin != msg.sender, 'unexecutable operation'); 
531         admins[_admin] = false;
532     } 
533 
534     function isAdmin(address addr) external view returns (bool) {
535         return (admins[addr]);
536     }
537 
538     function isController(address addr) external view returns (bool) {
539         return (controllers[addr]);
540     }
541 
542 }
543 
544 contract AccessController {
545 
546     address roleManagerAddr;
547 
548     modifier onlyAdmins {
549         require(RoleManager(roleManagerAddr).isAdmin(msg.sender), 'only admins');
550         _;
551     }
552 
553     modifier onlyControllers {
554         require(RoleManager(roleManagerAddr).isController(msg.sender), 'only controllers');
555         _;
556     }
557 
558     constructor (address _roleManagerAddr) public {
559         require(_roleManagerAddr != address(0), '_roleManagerAddr: Invalid address (zero address)');
560         roleManagerAddr = _roleManagerAddr;
561     }
562 
563 }
564 
565 contract GeneAidolsToken is ERC721Extended, AccessController {
566     constructor(address _roleManagerAddr)
567         public
568         ERC721Extended("GeneA.I.dols", "GAI")
569         AccessController(_roleManagerAddr)
570     {
571     }
572 
573     function generateToken(uint256 tokenId, address to) external onlyControllers {
574         _mint(to, tokenId);
575     }
576 
577     function setTokenURI(uint256 tokenId, string calldata uri) external onlyAdmins {
578         _setTokenURI(tokenId, uri);
579     }
580 
581     function tokenExists(uint256 tokenId) external view returns (bool exists) {
582         return _exists(tokenId);
583     }
584 }