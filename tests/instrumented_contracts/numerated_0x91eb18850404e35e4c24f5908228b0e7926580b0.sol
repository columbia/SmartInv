1 pragma solidity ^0.5.0;
2 
3 interface IERC165 {
4 
5     function supportsInterface(bytes4 interfaceId) external view returns (bool);
6 }
7 
8 pragma solidity ^0.5.0;
9 
10 contract IERC721 is IERC165 {
11     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
12     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
13     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
14 
15     function balanceOf(address owner) public view returns (uint256 balance);
16     function ownerOf(uint256 tokenId) public view returns (address owner);
17 
18     function approve(address to, uint256 tokenId) public;
19     function getApproved(uint256 tokenId) public view returns (address operator);
20 
21     function setApprovalForAll(address operator, bool _approved) public;
22     function isApprovedForAll(address owner, address operator) public view returns (bool);
23 
24     function transferFrom(address from, address to, uint256 tokenId) public;
25     function safeTransferFrom(address from, address to, uint256 tokenId) public;
26 
27     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
28 }
29 
30 pragma solidity ^0.5.0;
31 
32 contract IERC721Receiver {
33 
34     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
35     public returns (bytes4);
36 }
37 
38 pragma solidity ^0.5.0;
39 
40 library SafeMath {
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43 
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b);
50 
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b > 0);
56         uint256 c = a / b;
57 
58         return c;
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71 
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79 }
80 
81 pragma solidity ^0.5.0;
82 
83 library Address {
84 
85     function isContract(address account) internal view returns (bool) {
86         uint256 size;
87 
88         assembly { size := extcodesize(account) }
89         return size > 0;
90     }
91 }
92 
93 pragma solidity ^0.5.0;
94 
95 contract ERC165 is IERC165 {
96     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
97 
98     mapping(bytes4 => bool) private _supportedInterfaces;
99 
100     constructor () internal {
101         _registerInterface(_INTERFACE_ID_ERC165);
102     }
103 
104     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
105         return _supportedInterfaces[interfaceId];
106     }
107 
108     function _registerInterface(bytes4 interfaceId) internal {
109         require(interfaceId != 0xffffffff);
110         _supportedInterfaces[interfaceId] = true;
111     }
112 }
113 
114 pragma solidity ^0.5.0;
115 
116 contract ERC721 is ERC165, IERC721 {
117     using SafeMath for uint256;
118     using Address for address;
119 
120     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
121 
122     mapping (uint256 => address) private _tokenOwner;
123 
124     mapping (uint256 => address) private _tokenApprovals;
125 
126     mapping (address => uint256) private _ownedTokensCount;
127 
128     mapping (address => mapping (address => bool)) private _operatorApprovals;
129 
130     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
131 
132     constructor () public {
133         _registerInterface(_INTERFACE_ID_ERC721);
134     }
135 
136     function balanceOf(address owner) public view returns (uint256) {
137         require(owner != address(0));
138         return _ownedTokensCount[owner];
139     }
140 
141     function ownerOf(uint256 tokenId) public view returns (address) {
142         address owner = _tokenOwner[tokenId];
143         require(owner != address(0));
144         return owner;
145     }
146 
147     function approve(address to, uint256 tokenId) public {
148         address owner = ownerOf(tokenId);
149         require(to != owner);
150         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
151 
152         _tokenApprovals[tokenId] = to;
153         emit Approval(owner, to, tokenId);
154     }
155 
156     function getApproved(uint256 tokenId) public view returns (address) {
157         require(_exists(tokenId));
158         return _tokenApprovals[tokenId];
159     }
160 
161     function setApprovalForAll(address to, bool approved) public {
162         require(to != msg.sender);
163         _operatorApprovals[msg.sender][to] = approved;
164         emit ApprovalForAll(msg.sender, to, approved);
165     }
166 
167     function isApprovedForAll(address owner, address operator) public view returns (bool) {
168         return _operatorApprovals[owner][operator];
169     }
170 
171     function transferFrom(address from, address to, uint256 tokenId) public {
172         require(_isApprovedOrOwner(msg.sender, tokenId));
173 
174         _transferFrom(from, to, tokenId);
175     }
176 
177     function safeTransferFrom(address from, address to, uint256 tokenId) public {
178         safeTransferFrom(from, to, tokenId, "");
179     }
180 
181     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
182         transferFrom(from, to, tokenId);
183         require(_checkOnERC721Received(from, to, tokenId, _data));
184     }
185 
186     function _exists(uint256 tokenId) internal view returns (bool) {
187         address owner = _tokenOwner[tokenId];
188         return owner != address(0);
189     }
190 
191     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
192         address owner = ownerOf(tokenId);
193         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
194     }
195 
196     function _mint(address to, uint256 tokenId) internal {
197         require(to != address(0));
198         require(!_exists(tokenId));
199 
200         _tokenOwner[tokenId] = to;
201         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
202 
203         emit Transfer(address(0), to, tokenId);
204     }
205 
206     function _burn(address owner, uint256 tokenId) internal {
207         require(ownerOf(tokenId) == owner);
208 
209         _clearApproval(tokenId);
210 
211         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
212         _tokenOwner[tokenId] = address(0);
213 
214         emit Transfer(owner, address(0), tokenId);
215     }
216 
217     function _burn(uint256 tokenId) internal {
218         _burn(ownerOf(tokenId), tokenId);
219     }
220 
221     function _transferFrom(address from, address to, uint256 tokenId) internal {
222         require(ownerOf(tokenId) == from);
223         require(to != address(0));
224 
225         _clearApproval(tokenId);
226 
227         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
228         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
229 
230         _tokenOwner[tokenId] = to;
231 
232         emit Transfer(from, to, tokenId);
233     }
234 
235     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
236         internal returns (bool)
237     {
238         if (!to.isContract()) {
239             return true;
240         }
241 
242         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
243         return (retval == _ERC721_RECEIVED);
244     }
245 
246     function _clearApproval(uint256 tokenId) private {
247         if (_tokenApprovals[tokenId] != address(0)) {
248             _tokenApprovals[tokenId] = address(0);
249         }
250     }
251 }
252 
253 pragma solidity ^0.5.0;
254 
255 contract IERC721Enumerable is IERC721 {
256     function totalSupply() public view returns (uint256);
257     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
258 
259     function tokenByIndex(uint256 index) public view returns (uint256);
260 }
261 
262 pragma solidity ^0.5.0;
263 
264 contract ERC721EnumerableSimple is ERC165, ERC721, IERC721Enumerable {
265     mapping(address => uint256[]) private _ownedTokens;
266 
267     mapping(uint256 => uint256) private _ownedTokensIndex;
268 
269     uint256 internal totalSupply_;
270 
271     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
272 
273     constructor () public {
274         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
275     }
276 
277     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
278         require(index < balanceOf(owner), "Index is higher than number of tokens owned.");
279         return _ownedTokens[owner][index];
280     }
281 
282     function totalSupply() public view returns (uint256) {
283         return totalSupply_;
284     }
285 
286     function tokenByIndex(uint256 index) public view returns (uint256) {
287         require(index < totalSupply(), "Index is out of bounds.");
288         return index;
289     }
290 
291     function _transferFrom(address from, address to, uint256 tokenId) internal {
292         super._transferFrom(from, to, tokenId);
293 
294         _removeTokenFromOwnerEnumeration(from, tokenId);
295 
296         _addTokenToOwnerEnumeration(to, tokenId);
297     }
298 
299     function _mint(address to, uint256 tokenId) internal {
300         super._mint(to, tokenId);
301 
302         _addTokenToOwnerEnumeration(to, tokenId);
303 
304         totalSupply_ = totalSupply_.add(1);
305     }
306 
307     function _burn(address /*owner*/, uint256 /*tokenId*/) internal {
308         revert("This token cannot be burned.");
309     }
310 
311     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
312         return _ownedTokens[owner];
313     }
314 
315     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
316         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
317         _ownedTokens[to].push(tokenId);
318     }
319 
320     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
321 
322         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
323         uint256 tokenIndex = _ownedTokensIndex[tokenId];
324 
325         if (tokenIndex != lastTokenIndex) {
326             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
327 
328             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
329             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
330         }
331 
332         _ownedTokens[from].length--;
333 
334     }
335 }
336 
337 pragma solidity ^0.5.0;
338 
339 contract IERC721Metadata is IERC721 {
340     function name() external view returns (string memory);
341     function symbol() external view returns (string memory);
342     function tokenURI(uint256 tokenId) external view returns (string memory);
343 }
344 
345 pragma solidity ^0.5.0;
346 
347 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
348     // Token name
349     string private _name;
350 
351     // Token symbol
352     string private _symbol;
353 
354     // Optional mapping for token URIs
355     mapping(uint256 => string) private _tokenURIs;
356 
357     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
358 
359     constructor (string memory name, string memory symbol) public {
360         _name = name;
361         _symbol = symbol;
362 
363         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
364     }
365 
366     /**
367      * @dev Gets the token name
368      * @return string representing the token name
369      */
370     function name() external view returns (string memory) {
371         return _name;
372     }
373 
374     function symbol() external view returns (string memory) {
375         return _symbol;
376     }
377 
378     function tokenURI(uint256 tokenId) external view returns (string memory) {
379         require(_exists(tokenId));
380         return _tokenURIs[tokenId];
381     }
382 
383     function _setTokenURI(uint256 tokenId, string memory uri) internal {
384         require(_exists(tokenId));
385         _tokenURIs[tokenId] = uri;
386     }
387 
388     function _burn(address owner, uint256 tokenId) internal {
389         super._burn(owner, tokenId);
390 
391         // Clear metadata (if any)
392         if (bytes(_tokenURIs[tokenId]).length != 0) {
393             delete _tokenURIs[tokenId];
394         }
395     }
396 }
397 
398 pragma solidity ^0.5.0;
399 
400 interface IERC20 {
401     function transfer(address to, uint256 value) external returns (bool);
402 
403     function approve(address spender, uint256 value) external returns (bool);
404 
405     function transferFrom(address from, address to, uint256 value) external returns (bool);
406 
407     function totalSupply() external view returns (uint256);
408 
409     function balanceOf(address who) external view returns (uint256);
410 
411     function allowance(address owner, address spender) external view returns (uint256);
412 
413     event Transfer(address indexed from, address indexed to, uint256 value);
414 
415     event Approval(address indexed owner, address indexed spender, uint256 value);
416     
417 }
418     
419 pragma solidity ^0.5.0;
420 
421 contract Chaingrapher is ERC721, ERC721EnumerableSimple, ERC721Metadata("Smart Contract analytics: Chaingraph.io", "Chaingraph.io - Smart contract analytics") {
422 
423     address public createControl;
424 
425     constructor(address _createControl)
426     public
427     {
428         createControl = _createControl;
429     }
430 
431     modifier onlyCreateControl()
432     {
433         require(msg.sender == createControl, "createControl key required for this function.");
434         _;
435     }
436 
437     function create(uint256 _tokenId, address _owner)
438     public
439     onlyCreateControl
440     {
441         require(_tokenId == 0 || _exists(_tokenId.sub(1)), "Previous token ID has to exist.");
442         _mint(_owner, _tokenId);
443     }
444     
445     function createMulti(uint256 _tokenIdStart, address[] memory _owners)
446     public
447     onlyCreateControl
448     {
449         // Make sure we do not get any holes in Ids so we can do more optimizations.
450         require(_tokenIdStart == 0 || _exists(_tokenIdStart.sub(1)), "Previous token ID has to exist.");
451         uint256 addrcount = _owners.length;
452         for (uint256 i = 0; i < addrcount; i++) {
453             // Make sure this is in sync with what create() does.
454             _mint(_owners[i], _tokenIdStart + i);
455         }
456     }
457 
458     function destroy(uint256 _tokenId)
459     public
460     onlyCreateControl
461     {
462         _transferFrom(ownerOf(_tokenId), address(this), _tokenId);
463     }
464 
465     function rescueToken(IERC20 _foreignToken, address _to)
466     external
467     onlyCreateControl
468     {
469         _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
470     }
471 
472     function()
473     external payable
474     {
475         revert("The contract cannot receive ETH payments.");
476     }
477 }