1 pragma solidity ^0.5.16;
2 
3 interface IERC165 {
4     function supportsInterface(bytes4 interfaceId) external view returns (bool);
5 }
6 
7 pragma solidity ^0.5.16;
8 
9 contract IERC721 is IERC165 {
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
25 pragma solidity ^0.5.16;
26 
27 contract IERC721Receiver {
28     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
29     public returns (bytes4);
30 }
31 
32 pragma solidity ^0.5.16;
33 
34 library SafeMath {
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39         uint256 c = a * b;
40         require(c / a == b);
41         return c;
42     }
43 
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b > 0);
46         uint256 c = a / b;
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b <= a);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a);
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 pragma solidity ^0.5.16;
69 
70 library Address {
71     function isContract(address account) internal view returns (bool) {
72         uint256 size;
73         assembly { size := extcodesize(account) }
74         return size > 0;
75     }
76 }
77 
78 pragma solidity ^0.5.16;
79 
80 contract ERC165 is IERC165 {
81     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
82     mapping(bytes4 => bool) private _supportedInterfaces;
83 
84     constructor () internal {
85         _registerInterface(_INTERFACE_ID_ERC165);
86     }
87 
88     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
89         return _supportedInterfaces[interfaceId];
90     }
91 
92     function _registerInterface(bytes4 interfaceId) internal {
93         require(interfaceId != 0xffffffff);
94         _supportedInterfaces[interfaceId] = true;
95     }
96 }
97 
98 pragma solidity ^0.5.16;
99 
100 contract ERC721 is ERC165, IERC721 {
101     using SafeMath for uint256;
102     using Address for address;
103 
104     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
105     mapping (uint256 => address) private _tokenOwner;
106     mapping (uint256 => address) private _tokenApprovals;
107     mapping (address => uint256) private _ownedTokensCount;
108     mapping (address => mapping (address => bool)) private _operatorApprovals;
109     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
110 
111     constructor () public {
112         _registerInterface(_INTERFACE_ID_ERC721);
113     }
114 
115     function balanceOf(address owner) public view returns (uint256) {
116         require(owner != address(0));
117         return _ownedTokensCount[owner];
118     }
119 
120     function ownerOf(uint256 tokenId) public view returns (address) {
121         address owner = _tokenOwner[tokenId];
122         require(owner != address(0));
123         return owner;
124     }
125 
126     function approve(address to, uint256 tokenId) public {
127         address owner = ownerOf(tokenId);
128         require(to != owner);
129         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
130 
131         _tokenApprovals[tokenId] = to;
132         emit Approval(owner, to, tokenId);
133     }
134 
135     function getApproved(uint256 tokenId) public view returns (address) {
136         require(_exists(tokenId));
137         return _tokenApprovals[tokenId];
138     }
139 
140     function setApprovalForAll(address to, bool approved) public {
141         require(to != msg.sender);
142         _operatorApprovals[msg.sender][to] = approved;
143         emit ApprovalForAll(msg.sender, to, approved);
144     }
145 
146     function isApprovedForAll(address owner, address operator) public view returns (bool) {
147         return _operatorApprovals[owner][operator];
148     }
149 
150     function transferFrom(address from, address to, uint256 tokenId) public {
151         require(_isApprovedOrOwner(msg.sender, tokenId));
152         _transferFrom(from, to, tokenId);
153     }
154 
155     function safeTransferFrom(address from, address to, uint256 tokenId) public {
156         safeTransferFrom(from, to, tokenId, "");
157     }
158 
159     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
160         transferFrom(from, to, tokenId);
161         require(_checkOnERC721Received(from, to, tokenId, _data));
162     }
163 
164     function _exists(uint256 tokenId) internal view returns (bool) {
165         address owner = _tokenOwner[tokenId];
166         return owner != address(0);
167     }
168 
169     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
170         address owner = ownerOf(tokenId);
171         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
172     }
173 
174     function _mint(address to, uint256 tokenId) internal {
175         require(to != address(0));
176         require(!_exists(tokenId));
177 
178         _tokenOwner[tokenId] = to;
179         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
180 
181         emit Transfer(address(0), to, tokenId);
182     }
183 
184     function _transferFrom(address from, address to, uint256 tokenId) internal {
185         require(ownerOf(tokenId) == from);
186         require(to != address(0));
187 
188         _clearApproval(tokenId);
189 
190         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
191         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
192         _tokenOwner[tokenId] = to;
193 
194         emit Transfer(from, to, tokenId);
195     }
196 
197     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
198         internal returns (bool)
199     {
200         if (!to.isContract()) {
201             return true;
202         }
203 
204         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
205         return (retval == _ERC721_RECEIVED);
206     }
207 
208     function _clearApproval(uint256 tokenId) private {
209         if (_tokenApprovals[tokenId] != address(0)) {
210             _tokenApprovals[tokenId] = address(0);
211         }
212     }
213 
214     function uint2str(uint i) internal pure returns (string memory){
215         if (i == 0) return "0";
216         uint j = i;
217         uint length;
218         while (j != 0){
219             length++;
220             j /= 10;
221         }
222         bytes memory bstr = new bytes(length);
223         uint k = length - 1;
224         while (i != 0){
225             bstr[k--] = byte(uint8(48 + i % 10));
226             i /= 10;
227         }
228         return string(bstr);
229     }
230 
231     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
232         bytes memory _ba = bytes(_a);
233         bytes memory _bb = bytes(_b);
234         string memory ab = new string(_ba.length + _bb.length);
235         bytes memory bab = bytes(ab);
236         uint k = 0;
237         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
238         for (uint j = 0; j < _bb.length; j++) bab[k++] = _bb[j];
239         return string(bab);
240     }
241 
242 }
243 
244 pragma solidity ^0.5.16;
245 
246 contract IERC721Enumerable is IERC721 {
247     function totalSupply() public view returns (uint256);
248     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
249     function tokenByIndex(uint256 index) public view returns (uint256);
250 }
251 
252 pragma solidity ^0.5.16;
253 
254 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
255 
256     mapping(address => uint256[]) private _ownedTokens;
257     mapping(uint256 => uint256) private _ownedTokensIndex;
258     uint256[] private _allTokens;
259     mapping(uint256 => uint256) private _allTokensIndex;
260     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
261 
262     constructor () public {
263         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
264     }
265 
266     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
267         require(index < balanceOf(owner));
268         return _ownedTokens[owner][index];
269     }
270 
271     function totalSupply() public view returns (uint256) {
272         return _allTokens.length;
273     }
274 
275     function tokenByIndex(uint256 index) public view returns (uint256) {
276         require(index < totalSupply());
277         return _allTokens[index];
278     }
279 
280     function _transferFrom(address from, address to, uint256 tokenId) internal {
281         super._transferFrom(from, to, tokenId);
282         _removeTokenFromOwnerEnumeration(from, tokenId);
283         _addTokenToOwnerEnumeration(to, tokenId);
284     }
285 
286     function _mint(address to, uint256 tokenId) internal {
287         super._mint(to, tokenId);
288         _addTokenToOwnerEnumeration(to, tokenId);
289         _addTokenToAllTokensEnumeration(tokenId);
290     }
291 
292     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
293         return _ownedTokens[owner];
294     }
295 
296     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
297         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
298         _ownedTokens[to].push(tokenId);
299     }
300 
301     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
302         _allTokensIndex[tokenId] = _allTokens.length;
303         _allTokens.push(tokenId);
304     }
305 
306     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
307         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
308         uint256 tokenIndex = _ownedTokensIndex[tokenId];
309 
310         if (tokenIndex != lastTokenIndex) {
311             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
312             _ownedTokens[from][tokenIndex] = lastTokenId;
313             _ownedTokensIndex[lastTokenId] = tokenIndex;
314         }
315 
316         _ownedTokens[from].length--;
317     }
318 
319     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
320 
321         uint256 lastTokenIndex = _allTokens.length.sub(1);
322         uint256 tokenIndex = _allTokensIndex[tokenId];
323         uint256 lastTokenId = _allTokens[lastTokenIndex];
324 
325         _allTokens[tokenIndex] = lastTokenId;
326         _allTokensIndex[lastTokenId] = tokenIndex;
327 
328         _allTokens.length--;
329         _allTokensIndex[tokenId] = 0;
330     }
331 }
332 
333 pragma solidity ^0.5.16;
334 
335 contract IERC721Metadata is IERC721 {
336     function name() external view returns (string memory);
337     function symbol() external view returns (string memory);
338     function tokenURI(uint256 tokenId) external view returns (string memory);
339 }
340 
341 
342 pragma solidity ^0.5.16;
343 
344 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
345 
346     string private _name;
347     string private _symbol;
348 
349     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
350 
351     constructor (string memory name, string memory symbol) public {
352         _name = name;
353         _symbol = symbol;
354         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
355     }
356 
357     function name() external view returns (string memory) {
358         return _name;
359     }
360 
361     function symbol() external view returns (string memory) {
362         return _symbol;
363     }
364 
365     function tokenURI(uint256 tokenId) external view returns (string memory) {
366         require(_exists(tokenId));
367         string memory infoUrl;
368         infoUrl = strConcat('https://dfimoney.net/v1/', uint2str(tokenId));
369         return infoUrl;
370     }
371 }
372 
373 pragma solidity ^0.5.16;
374 
375 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
376     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
377     }
378 }
379 
380 pragma solidity ^0.5.16;
381 
382 library Roles {
383     struct Role {
384         mapping (address => bool) bearer;
385     }
386 
387     function add(Role storage role, address account) internal {
388         require(account != address(0));
389         require(!has(role, account));
390 
391         role.bearer[account] = true;
392     }
393 
394     function remove(Role storage role, address account) internal {
395         require(account != address(0));
396         require(has(role, account));
397 
398         role.bearer[account] = false;
399     }
400 
401     function has(Role storage role, address account) internal view returns (bool) {
402         require(account != address(0));
403         return role.bearer[account];
404     }
405 }
406 
407 pragma solidity ^0.5.16;
408 
409 
410 contract MinterRole {
411     using Roles for Roles.Role;
412     event MinterAdded(address indexed account);
413     event MinterRemoved(address indexed account);
414 
415     Roles.Role private _minters;
416 
417     constructor () internal {
418         _addMinter(msg.sender);
419     }
420 
421     modifier onlyMinter() {
422         require(isMinter(msg.sender));
423         _;
424     }
425 
426     function isMinter(address account) public view returns (bool) {
427         return _minters.has(account);
428     }
429 
430     function addMinter(address account) public onlyMinter {
431         _addMinter(account);
432     }
433 
434     function renounceMinter() public {
435         _removeMinter(msg.sender);
436     }
437 
438     function _addMinter(address account) internal {
439         _minters.add(account);
440         emit MinterAdded(account);
441     }
442 
443     function _removeMinter(address account) internal {
444         _minters.remove(account);
445         emit MinterRemoved(account);
446     }
447 }
448 
449 pragma solidity ^0.5.16;
450 
451 contract ERC721Mintable is ERC721, MinterRole {
452 
453     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
454         _mint(to, tokenId);
455         return true;
456     }
457 }
458 
459 
460 pragma solidity ^0.5.16;
461 
462 contract Ownable {
463     address private _owner;
464     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
465 
466     constructor () internal {
467         _owner = msg.sender;
468         emit OwnershipTransferred(address(0), _owner);
469     }
470 
471     function owner() public view returns (address) {
472         return _owner;
473     }
474 
475     modifier onlyOwner() {
476         require(isOwner());
477         _;
478     }
479 
480     function isOwner() public view returns (bool) {
481         return msg.sender == _owner;
482     }
483 
484     function renounceOwnership() public onlyOwner {
485         emit OwnershipTransferred(_owner, address(0));
486         _owner = address(0);
487     }
488 
489     function transferOwnership(address newOwner) public onlyOwner {
490         _transferOwnership(newOwner);
491     }
492 
493     function _transferOwnership(address newOwner) internal {
494         require(newOwner != address(0));
495         emit OwnershipTransferred(_owner, newOwner);
496         _owner = newOwner;
497     }
498 }
499 
500 
501 pragma solidity ^0.5.16;
502 
503 contract dfimoney is ERC721Full, ERC721Mintable, Ownable {
504     using SafeMath for uint256;
505     uint256 private tid = 10001;
506 
507     constructor (string memory _name, string memory _symbol) public
508         ERC721Mintable()
509         ERC721Full(_name, _symbol){
510     }
511 
512     function transfer(address _to, uint256 _tokenId) public {
513         safeTransferFrom(msg.sender, _to, _tokenId);
514     }
515 
516     function transferAll(address _to, uint256[] memory _tokenId) public {
517         for (uint i = 0; i < _tokenId.length; i++) {
518             safeTransferFrom(msg.sender, _to, _tokenId[i]);
519         }
520     }
521 
522     function batchMint(address _to, uint256[] memory _tokenId) public onlyMinter{
523         for (uint i = 0; i < _tokenId.length; i++) {
524             _mint(_to, _tokenId[i]);
525         }
526     }
527 
528     function batchAddrMint(address[] memory _to, uint256 _tokenId) public onlyMinter{
529         for (uint i = 0; i < _to.length; i++) {
530             _mint(_to[i], _tokenId.add(i));
531         }
532     }
533 
534     function claim() public {
535         _mint(msg.sender,tid);
536         tid = tid.add(1);
537     }
538 
539     function reset(uint256 _newtid) public onlyMinter{
540         tid = _newtid;
541     }
542 
543     function gettid() external view returns (uint256) {
544         return tid;
545     }
546 
547     function draw() public onlyOwner{
548         msg.sender.transfer(address(this).balance);
549     }
550 
551     function () external{
552         claim();
553     }
554 
555 }