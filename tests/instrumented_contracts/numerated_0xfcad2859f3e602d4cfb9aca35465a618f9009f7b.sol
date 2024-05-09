1 pragma solidity 0.4.25;
2 
3 library SafeMath256 {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint256 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     function _validateAddress(address _addr) internal pure {
45         require(_addr != address(0), "invalid address");
46     }
47 
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner, "not a contract owner");
54         _;
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58         _validateAddress(newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 
63 }
64 
65 contract Controllable is Ownable {
66     mapping(address => bool) controllers;
67 
68     modifier onlyController {
69         require(_isController(msg.sender), "no controller rights");
70         _;
71     }
72 
73     function _isController(address _controller) internal view returns (bool) {
74         return controllers[_controller];
75     }
76 
77     function _setControllers(address[] _controllers) internal {
78         for (uint256 i = 0; i < _controllers.length; i++) {
79             _validateAddress(_controllers[i]);
80             controllers[_controllers[i]] = true;
81         }
82     }
83 }
84 
85 contract Upgradable is Controllable {
86     address[] internalDependencies;
87     address[] externalDependencies;
88 
89     function getInternalDependencies() public view returns(address[]) {
90         return internalDependencies;
91     }
92 
93     function getExternalDependencies() public view returns(address[]) {
94         return externalDependencies;
95     }
96 
97     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
98         for (uint256 i = 0; i < _newDependencies.length; i++) {
99             _validateAddress(_newDependencies[i]);
100         }
101         internalDependencies = _newDependencies;
102     }
103 
104     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
105         externalDependencies = _newDependencies;
106         _setControllers(_newDependencies);
107     }
108 }
109 
110 contract ERC721Basic {
111     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
112     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
113     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
114 
115     function balanceOf(address _owner) public view returns (uint256 _balance);
116     function ownerOf(uint256 _tokenId) public view returns (address _owner);
117     function exists(uint256 _tokenId) public view returns (bool _exists);
118 
119     function approve(address _to, uint256 _tokenId) public;
120     function getApproved(uint256 _tokenId) public view returns (address _operator);
121 
122     function setApprovalForAll(address _operator, bool _approved) public;
123     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
124 
125     function transferFrom(address _from, address _to, uint256 _tokenId) public;
126     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
127     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
128 
129     function supportsInterface(bytes4 _interfaceID) external pure returns (bool);
130 }
131 
132 contract ERC721Enumerable is ERC721Basic {
133     function totalSupply() public view returns (uint256);
134     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
135     function tokenByIndex(uint256 _index) public view returns (uint256);
136 }
137 
138 contract ERC721Metadata is ERC721Basic {
139     function name() public view returns (string _name);
140     function symbol() public view returns (string _symbol);
141     function tokenURI(uint256 _tokenId) public view returns (string);
142 }
143 
144 
145 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {}
146 
147 contract ERC721Receiver {
148     function onERC721Received(
149         address _operator,
150         address _from,
151         uint256 _tokenId,
152         bytes _data
153     )
154         public
155         returns(bytes4);
156 }
157 
158 contract ERC721BasicToken is ERC721Basic, Upgradable {
159 
160     using SafeMath256 for uint256;
161 
162     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
163     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
164     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
165 
166     // Mapping from token ID to owner
167     mapping (uint256 => address) internal tokenOwner;
168 
169     // Mapping from token ID to approved address
170     mapping (uint256 => address) internal tokenApprovals;
171 
172     // Mapping from owner to number of owned token
173     mapping (address => uint256) internal ownedTokensCount;
174 
175     // Mapping from owner to operator approvals
176     mapping (address => mapping (address => bool)) internal operatorApprovals;
177 
178     function _checkRights(bool _has) internal pure {
179         require(_has, "no rights to manage");
180     }
181 
182     function _validateAddress(address _addr) internal pure {
183         require(_addr != address(0), "invalid address");
184     }
185 
186     function _checkOwner(uint256 _tokenId, address _owner) internal view {
187         require(ownerOf(_tokenId) == _owner, "not an owner");
188     }
189 
190     function _checkThatUserHasTokens(bool _has) internal pure {
191         require(_has, "user has no tokens");
192     }
193 
194     function balanceOf(address _owner) public view returns (uint256) {
195         _validateAddress(_owner);
196         return ownedTokensCount[_owner];
197     }
198 
199     function ownerOf(uint256 _tokenId) public view returns (address) {
200         address owner = tokenOwner[_tokenId];
201         _validateAddress(owner);
202         return owner;
203     }
204 
205     function exists(uint256 _tokenId) public view returns (bool) {
206         address owner = tokenOwner[_tokenId];
207         return owner != address(0);
208     }
209 
210     function _approve(address _from, address _to, uint256 _tokenId) internal {
211         address owner = ownerOf(_tokenId);
212         require(_to != owner, "can't be approved to owner");
213         _checkRights(_from == owner || isApprovedForAll(owner, _from));
214 
215         if (getApproved(_tokenId) != address(0) || _to != address(0)) {
216             tokenApprovals[_tokenId] = _to;
217             emit Approval(owner, _to, _tokenId);
218         }
219     }
220 
221     function approve(address _to, uint256 _tokenId) public {
222         _approve(msg.sender, _to, _tokenId);
223     }
224 
225     function remoteApprove(address _to, uint256 _tokenId) external onlyController {
226         _approve(tx.origin, _to, _tokenId);
227     }
228 
229     function getApproved(uint256 _tokenId) public view returns (address) {
230         require(exists(_tokenId), "token doesn't exist");
231         return tokenApprovals[_tokenId];
232     }
233 
234     function setApprovalForAll(address _to, bool _approved) public {
235         require(_to != msg.sender, "wrong sender");
236         operatorApprovals[msg.sender][_to] = _approved;
237         emit ApprovalForAll(msg.sender, _to, _approved);
238     }
239 
240     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
241         return operatorApprovals[_owner][_operator];
242     }
243 
244     function transferFrom(address _from, address _to, uint256 _tokenId) public {
245         _checkRights(isApprovedOrOwner(msg.sender, _tokenId));
246         _validateAddress(_from);
247         _validateAddress(_to);
248 
249         clearApproval(_from, _tokenId);
250         removeTokenFrom(_from, _tokenId);
251         addTokenTo(_to, _tokenId);
252 
253         emit Transfer(_from, _to, _tokenId);
254     }
255 
256     function safeTransferFrom(
257         address _from,
258         address _to,
259         uint256 _tokenId
260     ) public {
261         safeTransferFrom(_from, _to, _tokenId, "");
262     }
263 
264     function safeTransferFrom(
265         address _from,
266         address _to,
267         uint256 _tokenId,
268         bytes _data
269     ) public {
270         transferFrom(_from, _to, _tokenId);
271         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data), "can't make safe transfer");
272     }
273 
274     function isApprovedOrOwner(address _spender, uint256 _tokenId) public view returns (bool) {
275         address owner = ownerOf(_tokenId);
276         return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
277     }
278 
279     function _mint(address _to, uint256 _tokenId) internal {
280         _validateAddress(_to);
281         addTokenTo(_to, _tokenId);
282         emit Transfer(address(0), _to, _tokenId);
283     }
284 
285     function _burn(address _owner, uint256 _tokenId) internal {
286         clearApproval(_owner, _tokenId);
287         removeTokenFrom(_owner, _tokenId);
288         emit Transfer(_owner, address(0), _tokenId);
289     }
290 
291     function clearApproval(address _owner, uint256 _tokenId) internal {
292         _checkOwner(_tokenId, _owner);
293         if (tokenApprovals[_tokenId] != address(0)) {
294             tokenApprovals[_tokenId] = address(0);
295             emit Approval(_owner, address(0), _tokenId);
296         }
297     }
298 
299     function addTokenTo(address _to, uint256 _tokenId) internal {
300         require(tokenOwner[_tokenId] == address(0), "token already has an owner");
301         tokenOwner[_tokenId] = _to;
302         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
303     }
304 
305     function removeTokenFrom(address _from, uint256 _tokenId) internal {
306         _checkOwner(_tokenId, _from);
307         _checkThatUserHasTokens(ownedTokensCount[_from] > 0);
308         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
309         tokenOwner[_tokenId] = address(0);
310     }
311 
312     function _isContract(address addr) internal view returns (bool) {
313         uint256 size;
314         assembly { size := extcodesize(addr) }
315         return size > 0;
316     }
317 
318     function checkAndCallSafeTransfer(
319         address _from,
320         address _to,
321         uint256 _tokenId,
322         bytes _data
323     ) internal returns (bool) {
324         if (!_isContract(_to)) {
325             return true;
326         }
327         bytes4 retval = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
328         return (retval == _ERC721_RECEIVED);
329     }
330 }
331 
332 contract ERC721Token is ERC721, ERC721BasicToken {
333 
334     bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
335     bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = 0x80ac58cd;
336     bytes4 internal constant INTERFACE_SIGNATURE_ERC721TokenReceiver = 0xf0b9e5ba;
337     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Metadata = 0x5b5e139f;
338     bytes4 internal constant INTERFACE_SIGNATURE_ERC721Enumerable = 0x780e9d63;
339 
340     string internal name_;
341     string internal symbol_;
342 
343     // Mapping from owner to list of owned token IDs
344     mapping (address => uint256[]) internal ownedTokens;
345 
346     // Mapping from token ID to index of the owner tokens list
347     mapping(uint256 => uint256) internal ownedTokensIndex;
348 
349     // Array with all token ids, used for enumeration
350     uint256[] internal allTokens;
351 
352     // Mapping from token id to position in the allTokens array
353     mapping(uint256 => uint256) internal allTokensIndex;
354 
355     // Optional mapping for token URIs
356     mapping(uint256 => string) internal tokenURIs;
357 
358     // The contract owner can change the base URL, in case it becomes necessary. It is needed for Metadata.
359     string public url;
360 
361 
362     constructor(string _name, string _symbol) public {
363         name_ = _name;
364         symbol_ = _symbol;
365     }
366 
367     function name() public view returns (string) {
368         return name_;
369     }
370 
371     function symbol() public view returns (string) {
372         return symbol_;
373     }
374 
375     function _validateIndex(bool _isValid) internal pure {
376         require(_isValid, "wrong index");
377     }
378 
379     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
380         _validateIndex(_index < balanceOf(_owner));
381         return ownedTokens[_owner][_index];
382     }
383 
384     function tokensOfOwner(address _owner) external view returns (uint256[]) {
385         return ownedTokens[_owner];
386     }
387 
388     function getAllTokens() external view returns (uint256[]) {
389         return allTokens;
390     }
391 
392     function totalSupply() public view returns (uint256) {
393         return allTokens.length;
394     }
395 
396     function tokenByIndex(uint256 _index) public view returns (uint256) {
397         _validateIndex(_index < totalSupply());
398         return allTokens[_index];
399     }
400 
401     function addTokenTo(address _to, uint256 _tokenId) internal {
402         super.addTokenTo(_to, _tokenId);
403         uint256 length = ownedTokens[_to].length;
404         ownedTokens[_to].push(_tokenId);
405         ownedTokensIndex[_tokenId] = length;
406     }
407 
408     function removeTokenFrom(address _from, uint256 _tokenId) internal {
409         _checkThatUserHasTokens(ownedTokens[_from].length > 0);
410 
411         super.removeTokenFrom(_from, _tokenId);
412 
413         uint256 tokenIndex = ownedTokensIndex[_tokenId];
414         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
415         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
416 
417         ownedTokens[_from][tokenIndex] = lastToken;
418         ownedTokens[_from][lastTokenIndex] = 0;
419 
420         ownedTokens[_from].length--;
421         ownedTokensIndex[_tokenId] = 0;
422         ownedTokensIndex[lastToken] = tokenIndex;
423     }
424 
425     function _mint(address _to, uint256 _tokenId) internal {
426         super._mint(_to, _tokenId);
427 
428         allTokensIndex[_tokenId] = allTokens.length;
429         allTokens.push(_tokenId);
430     }
431 
432     function _burn(address _owner, uint256 _tokenId) internal {
433         require(allTokens.length > 0, "no tokens");
434 
435         super._burn(_owner, _tokenId);
436 
437         uint256 tokenIndex = allTokensIndex[_tokenId];
438         uint256 lastTokenIndex = allTokens.length.sub(1);
439         uint256 lastToken = allTokens[lastTokenIndex];
440 
441         allTokens[tokenIndex] = lastToken;
442         allTokens[lastTokenIndex] = 0;
443 
444         allTokens.length--;
445         allTokensIndex[_tokenId] = 0;
446         allTokensIndex[lastToken] = tokenIndex;
447     }
448 
449     function supportsInterface(bytes4 _interfaceID) external pure returns (bool) {
450         return (
451             _interfaceID == INTERFACE_SIGNATURE_ERC165 ||
452             _interfaceID == INTERFACE_SIGNATURE_ERC721 ||
453             _interfaceID == INTERFACE_SIGNATURE_ERC721TokenReceiver ||
454             _interfaceID == INTERFACE_SIGNATURE_ERC721Metadata ||
455             _interfaceID == INTERFACE_SIGNATURE_ERC721Enumerable
456         );
457     }
458 
459     function tokenURI(uint256 _tokenId) public view returns (string) {
460         require(exists(_tokenId), "token doesn't exist");
461         return string(abi.encodePacked(url, _uint2str(_tokenId)));
462     }
463 
464     function setUrl(string _url) external onlyOwner {
465         url = _url;
466     }
467 
468     function _uint2str(uint _i) internal pure returns (string){
469         if (i == 0) return "0";
470         uint i = _i;
471         uint j = _i;
472         uint length;
473         while (j != 0){
474             length++;
475             j /= 10;
476         }
477         bytes memory bstr = new bytes(length);
478         uint k = length - 1;
479         while (i != 0){
480             bstr[k--] = byte(48 + i % 10);
481             i /= 10;
482         }
483         return string(bstr);
484     }
485 }
486 
487 
488 contract EggStorage is ERC721Token {
489     struct Egg {
490         uint256[2] parents;
491         uint8 dragonType; // used for genesis only
492     }
493 
494     Egg[] eggs;
495 
496     constructor(string _name, string _symbol) public ERC721Token(_name, _symbol) {
497         eggs.length = 1; // to avoid some issues with 0
498     }
499 
500     function push(address _sender, uint256[2] _parents, uint8 _dragonType) public onlyController returns (uint256 id) {
501         Egg memory _egg = Egg(_parents, _dragonType);
502         id = eggs.push(_egg).sub(1);
503         _mint(_sender, id);
504     }
505 
506     function get(uint256 _id) external view returns (uint256[2], uint8) {
507         return (eggs[_id].parents, eggs[_id].dragonType);
508     }
509 
510     function remove(address _owner, uint256 _id) external onlyController {
511         delete eggs[_id];
512         _burn(_owner, _id);
513     }
514 }