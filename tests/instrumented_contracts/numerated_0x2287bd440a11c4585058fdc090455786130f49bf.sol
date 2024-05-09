1 /*
2 
3 The U.S. dollar was the only currency strong enough to meet the rising demands for international currency transactions, and so the United States agreed both to link the dollar to gold at the rate of $35 per ounce of gold and to convert dollars into gold at that price.
4 
5 */
6 
7 pragma solidity ^0.5.16;
8 
9 interface IERC165 {
10     function supportsInterface(bytes4 interfaceId) external view returns (bool);
11 }
12 
13 pragma solidity ^0.5.16;
14 
15 contract IERC721 is IERC165 {
16     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
17     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
18     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
19 
20     function balanceOf(address owner) public view returns (uint256 balance);
21     function ownerOf(uint256 tokenId) public view returns (address owner);
22     function approve(address to, uint256 tokenId) public;
23     function getApproved(uint256 tokenId) public view returns (address operator);
24     function setApprovalForAll(address operator, bool _approved) public;
25     function isApprovedForAll(address owner, address operator) public view returns (bool);
26     function transferFrom(address from, address to, uint256 tokenId) public;
27     function safeTransferFrom(address from, address to, uint256 tokenId) public;
28     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
29 }
30 
31 pragma solidity ^0.5.16;
32 
33 contract IERC721Receiver {
34     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
35     public returns (bytes4);
36 }
37 
38 pragma solidity ^0.5.16;
39 
40 library SafeMath {
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b);
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b > 0);
52         uint256 c = a / b;
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b <= a);
58         uint256 c = a - b;
59         return c;
60     }
61 
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a);
65         return c;
66     }
67 
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b != 0);
70         return a % b;
71     }
72 }
73 
74 pragma solidity ^0.5.16;
75 
76 library Address {
77     function isContract(address account) internal view returns (bool) {
78         uint256 size;
79         assembly { size := extcodesize(account) }
80         return size > 0;
81     }
82 }
83 
84 pragma solidity ^0.5.16;
85 
86 contract ERC165 is IERC165 {
87     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
88     mapping(bytes4 => bool) private _supportedInterfaces;
89 
90     constructor () internal {
91         _registerInterface(_INTERFACE_ID_ERC165);
92     }
93 
94     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
95         return _supportedInterfaces[interfaceId];
96     }
97 
98     function _registerInterface(bytes4 interfaceId) internal {
99         require(interfaceId != 0xffffffff);
100         _supportedInterfaces[interfaceId] = true;
101     }
102 }
103 
104 pragma solidity ^0.5.16;
105 
106 contract ERC721 is ERC165, IERC721 {
107     using SafeMath for uint256;
108     using Address for address;
109 
110     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
111     mapping (uint256 => address) private _tokenOwner;
112     mapping (uint256 => address) private _tokenApprovals;
113     mapping (address => uint256) private _ownedTokensCount;
114     mapping (address => mapping (address => bool)) private _operatorApprovals;
115     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
116 
117     constructor () public {
118         _registerInterface(_INTERFACE_ID_ERC721);
119     }
120 
121     function balanceOf(address owner) public view returns (uint256) {
122         require(owner != address(0));
123         return _ownedTokensCount[owner];
124     }
125 
126     function ownerOf(uint256 tokenId) public view returns (address) {
127         address owner = _tokenOwner[tokenId];
128         require(owner != address(0));
129         return owner;
130     }
131 
132     function approve(address to, uint256 tokenId) public {
133         address owner = ownerOf(tokenId);
134         require(to != owner);
135         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
136 
137         _tokenApprovals[tokenId] = to;
138         emit Approval(owner, to, tokenId);
139     }
140 
141     function getApproved(uint256 tokenId) public view returns (address) {
142         require(_exists(tokenId));
143         return _tokenApprovals[tokenId];
144     }
145 
146     function setApprovalForAll(address to, bool approved) public {
147         require(to != msg.sender);
148         _operatorApprovals[msg.sender][to] = approved;
149         emit ApprovalForAll(msg.sender, to, approved);
150     }
151 
152     function isApprovedForAll(address owner, address operator) public view returns (bool) {
153         return _operatorApprovals[owner][operator];
154     }
155 
156     function transferFrom(address from, address to, uint256 tokenId) public {
157         require(_isApprovedOrOwner(msg.sender, tokenId));
158         _transferFrom(from, to, tokenId);
159     }
160 
161     function safeTransferFrom(address from, address to, uint256 tokenId) public {
162         safeTransferFrom(from, to, tokenId, "");
163     }
164 
165     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
166         transferFrom(from, to, tokenId);
167         require(_checkOnERC721Received(from, to, tokenId, _data));
168     }
169 
170     function _exists(uint256 tokenId) internal view returns (bool) {
171         address owner = _tokenOwner[tokenId];
172         return owner != address(0);
173     }
174 
175     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
176         address owner = ownerOf(tokenId);
177         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
178     }
179 
180     function _mint(address to, uint256 tokenId) internal {
181         require(to != address(0));
182         require(!_exists(tokenId));
183 
184         _tokenOwner[tokenId] = to;
185         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
186 
187         emit Transfer(address(0), to, tokenId);
188     }
189 
190     function _transferFrom(address from, address to, uint256 tokenId) internal {
191         require(ownerOf(tokenId) == from);
192         require(to != address(0));
193 
194         _clearApproval(tokenId);
195 
196         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
197         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
198         _tokenOwner[tokenId] = to;
199 
200         emit Transfer(from, to, tokenId);
201     }
202 
203     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
204         internal returns (bool)
205     {
206         if (!to.isContract()) {
207             return true;
208         }
209 
210         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
211         return (retval == _ERC721_RECEIVED);
212     }
213 
214     function _clearApproval(uint256 tokenId) private {
215         if (_tokenApprovals[tokenId] != address(0)) {
216             _tokenApprovals[tokenId] = address(0);
217         }
218     }
219 
220     function uint2str(uint i) internal pure returns (string memory){
221         if (i == 0) return "0";
222         uint j = i;
223         uint length;
224         while (j != 0){
225             length++;
226             j /= 10;
227         }
228         bytes memory bstr = new bytes(length);
229         uint k = length - 1;
230         while (i != 0){
231             bstr[k--] = byte(uint8(48 + i % 10));
232             i /= 10;
233         }
234         return string(bstr);
235     }
236 
237     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
238         bytes memory _ba = bytes(_a);
239         bytes memory _bb = bytes(_b);
240         string memory ab = new string(_ba.length + _bb.length);
241         bytes memory bab = bytes(ab);
242         uint k = 0;
243         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
244         for (uint j = 0; j < _bb.length; j++) bab[k++] = _bb[j];
245         return string(bab);
246     }
247 
248 }
249 
250 pragma solidity ^0.5.16;
251 
252 contract IERC721Enumerable is IERC721 {
253     function totalSupply() public view returns (uint256);
254     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
255     function tokenByIndex(uint256 index) public view returns (uint256);
256 }
257 
258 pragma solidity ^0.5.16;
259 
260 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
261 
262     mapping(address => uint256[]) private _ownedTokens;
263     mapping(uint256 => uint256) private _ownedTokensIndex;
264     uint256[] private _allTokens;
265     mapping(uint256 => uint256) private _allTokensIndex;
266     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
267 
268     constructor () public {
269         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
270     }
271 
272     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
273         require(index < balanceOf(owner));
274         return _ownedTokens[owner][index];
275     }
276 
277     function totalSupply() public view returns (uint256) {
278         return _allTokens.length;
279     }
280 
281     function tokenByIndex(uint256 index) public view returns (uint256) {
282         require(index < totalSupply());
283         return _allTokens[index];
284     }
285 
286     function _transferFrom(address from, address to, uint256 tokenId) internal {
287         super._transferFrom(from, to, tokenId);
288         _removeTokenFromOwnerEnumeration(from, tokenId);
289         _addTokenToOwnerEnumeration(to, tokenId);
290     }
291 
292     function _mint(address to, uint256 tokenId) internal {
293         super._mint(to, tokenId);
294         _addTokenToOwnerEnumeration(to, tokenId);
295         _addTokenToAllTokensEnumeration(tokenId);
296     }
297 
298     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
299         return _ownedTokens[owner];
300     }
301 
302     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
303         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
304         _ownedTokens[to].push(tokenId);
305     }
306 
307     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
308         _allTokensIndex[tokenId] = _allTokens.length;
309         _allTokens.push(tokenId);
310     }
311 
312     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
313         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
314         uint256 tokenIndex = _ownedTokensIndex[tokenId];
315 
316         if (tokenIndex != lastTokenIndex) {
317             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
318             _ownedTokens[from][tokenIndex] = lastTokenId;
319             _ownedTokensIndex[lastTokenId] = tokenIndex;
320         }
321 
322         _ownedTokens[from].length--;
323     }
324 
325     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
326 
327         uint256 lastTokenIndex = _allTokens.length.sub(1);
328         uint256 tokenIndex = _allTokensIndex[tokenId];
329         uint256 lastTokenId = _allTokens[lastTokenIndex];
330 
331         _allTokens[tokenIndex] = lastTokenId;
332         _allTokensIndex[lastTokenId] = tokenIndex;
333 
334         _allTokens.length--;
335         _allTokensIndex[tokenId] = 0;
336     }
337 }
338 
339 pragma solidity ^0.5.16;
340 
341 contract IERC721Metadata is IERC721 {
342     function name() external view returns (string memory);
343     function symbol() external view returns (string memory);
344     function tokenURI(uint256 tokenId) external view returns (string memory);
345 }
346 
347 
348 pragma solidity ^0.5.16;
349 
350 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
351 
352     string private _name;
353     string private _symbol;
354 
355     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
356 
357     constructor (string memory name, string memory symbol) public {
358         _name = name;
359         _symbol = symbol;
360         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
361     }
362 
363     function name() external view returns (string memory) {
364         return _name;
365     }
366 
367     function symbol() external view returns (string memory) {
368         return _symbol;
369     }
370 
371     function tokenURI(uint256 tokenId) external view returns (string memory) {
372         require(_exists(tokenId));
373         string memory infoUrl;
374         infoUrl = strConcat('https://soundm0ney.com/v1/', uint2str(tokenId));
375         return infoUrl;
376     }
377 }
378 
379 pragma solidity ^0.5.16;
380 
381 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
382     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
383     }
384 }
385 
386 pragma solidity ^0.5.16;
387 
388 library Roles {
389     struct Role {
390         mapping (address => bool) bearer;
391     }
392 
393     function add(Role storage role, address account) internal {
394         require(account != address(0));
395         require(!has(role, account));
396 
397         role.bearer[account] = true;
398     }
399 
400     function remove(Role storage role, address account) internal {
401         require(account != address(0));
402         require(has(role, account));
403 
404         role.bearer[account] = false;
405     }
406 
407     function has(Role storage role, address account) internal view returns (bool) {
408         require(account != address(0));
409         return role.bearer[account];
410     }
411 }
412 
413 pragma solidity ^0.5.16;
414 
415 
416 contract MinterRole {
417     using Roles for Roles.Role;
418     event MinterAdded(address indexed account);
419     event MinterRemoved(address indexed account);
420 
421     Roles.Role private _minters;
422 
423     constructor () internal {
424         _addMinter(msg.sender);
425     }
426 
427     modifier onlyMinter() {
428         require(isMinter(msg.sender));
429         _;
430     }
431 
432     function isMinter(address account) public view returns (bool) {
433         return _minters.has(account);
434     }
435 
436     function addMinter(address account) public onlyMinter {
437         _addMinter(account);
438     }
439 
440     function renounceMinter() public {
441         _removeMinter(msg.sender);
442     }
443 
444     function _addMinter(address account) internal {
445         _minters.add(account);
446         emit MinterAdded(account);
447     }
448 
449     function _removeMinter(address account) internal {
450         _minters.remove(account);
451         emit MinterRemoved(account);
452     }
453 }
454 
455 pragma solidity ^0.5.16;
456 
457 contract ERC721Mintable is ERC721, MinterRole {
458 
459     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
460         _mint(to, tokenId);
461         return true;
462     }
463 }
464 
465 
466 pragma solidity ^0.5.16;
467 
468 contract Ownable {
469     address private _owner;
470     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472     constructor () internal {
473         _owner = msg.sender;
474         emit OwnershipTransferred(address(0), _owner);
475     }
476 
477     function owner() public view returns (address) {
478         return _owner;
479     }
480 
481     modifier onlyOwner() {
482         require(isOwner());
483         _;
484     }
485 
486     function isOwner() public view returns (bool) {
487         return msg.sender == _owner;
488     }
489 
490     function renounceOwnership() public onlyOwner {
491         emit OwnershipTransferred(_owner, address(0));
492         _owner = address(0);
493     }
494 
495     function transferOwnership(address newOwner) public onlyOwner {
496         _transferOwnership(newOwner);
497     }
498 
499     function _transferOwnership(address newOwner) internal {
500         require(newOwner != address(0));
501         emit OwnershipTransferred(_owner, newOwner);
502         _owner = newOwner;
503     }
504 }
505 
506 
507 pragma solidity ^0.5.16;
508 
509 contract soundmoney is ERC721Full, ERC721Mintable, Ownable {
510     using SafeMath for uint256;
511 
512     constructor (string memory _name, string memory _symbol) public
513         ERC721Mintable()
514         ERC721Full(_name, _symbol){
515     }
516 
517     function transfer(address _to, uint256 _tokenId) public {
518         safeTransferFrom(msg.sender, _to, _tokenId);
519     }
520 
521     function transferAll(address _to, uint256[] memory _tokenId) public {
522         for (uint i = 0; i < _tokenId.length; i++) {
523             safeTransferFrom(msg.sender, _to, _tokenId[i]);
524         }
525     }
526 
527     function batchMint(address _to, uint256[] memory _tokenId) public onlyMinter{
528         for (uint i = 0; i < _tokenId.length; i++) {
529             _mint(_to, _tokenId[i]);
530         }
531     }
532 }