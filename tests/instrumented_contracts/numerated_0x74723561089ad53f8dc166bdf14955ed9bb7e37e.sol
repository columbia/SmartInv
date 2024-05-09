1 pragma solidity ^0.4.21;
2 
3 library AddressUtils {
4 
5     function isContract(address addr) internal view returns (bool) {
6         uint256 size;
7         // solium-disable-line security/no-inline-assembly
8         assembly { size := extcodesize(addr) }
9         return size > 0;
10     }
11 
12 }
13 
14 library SafeMath {
15 
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         return a / b;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 contract ERC721Receiver {
42     function onERC721Received(address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
43 }
44 
45 contract ERC721BasicToken {
46 
47     event Transfer(address indexed from, address indexed to, uint256 tokenId);
48     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     using SafeMath for uint256;
52     using AddressUtils for address;
53 
54     // Mapping from token ID to owner
55     mapping (uint256 => address) internal tokenOwner;
56 
57     // Mapping from owner to number of owned token
58     mapping (address => uint256) internal ownedTokensCount;
59 
60     // Mapping from token ID to approved address
61     mapping (uint256 => address) internal tokenApprovals;
62 
63     // Mapping from owner to operator approvals
64     mapping (address => mapping (address => bool)) internal operatorApprovals;
65 
66     bytes4 constant InterfaceSignature_ERC165 =
67         bytes4(keccak256('supportsInterface(bytes4)'));
68 
69     bytes4 constant InterfaceSignature_ERC721TokenReceiver =
70         bytes4(keccak256('onERC721Received(address,uint256,bytes)'));
71 
72     bytes4 constant InterfaceSignature_ERC721 =
73         bytes4(keccak256('balanceOf(address)')) ^
74         bytes4(keccak256('ownerOf(uint256)')) ^
75         bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) ^
76         bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
77         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
78         bytes4(keccak256('approve(address,uint256)')) ^
79         bytes4(keccak256('setApprovalForAll(address,bool)')) ^
80         bytes4(keccak256('getApproved(uint256)')) ^
81         bytes4(keccak256('isApprovedForAll(address,address)'));
82 
83     modifier onlyOwnerOf(uint256 _tokenId) {
84         require(tokenOwner[_tokenId] == msg.sender);
85         _;
86     }
87 
88     modifier canTransfer(uint256 _tokenId) {
89         require(
90             tokenOwner[_tokenId] == msg.sender
91             || tokenApprovals[_tokenId] == msg.sender
92             || operatorApprovals[tokenOwner[_tokenId]][msg.sender]
93         );
94         _;
95     }
96 
97     //  We implement ERC721 here
98     function supportsInterface(bytes4 _interfaceID) public pure returns (bool)
99     {
100         return (
101           (_interfaceID == InterfaceSignature_ERC165)
102           || (_interfaceID == InterfaceSignature_ERC721)
103         );
104     }
105 
106     function balanceOf(address _owner) public view returns (uint256) {
107         //require(_owner != address(0));
108         return ownedTokensCount[_owner];
109     }
110 
111     function ownerOf(uint256 _tokenId) public view returns (address) {
112         address owner = tokenOwner[_tokenId];
113         //require(owner != address(0));
114         return owner;
115     }
116 
117     function transferFrom(
118         address _from,
119         address _to,
120         uint256 _tokenId
121     )
122         public
123         canTransfer(_tokenId)
124     {
125         require(_from != address(0));
126         require(_to != address(0));
127 
128         clearApproval(_from, _tokenId);
129         removeTokenFrom(_from, _tokenId);
130         addTokenTo(_to, _tokenId);
131 
132         emit Transfer(_from, _to, _tokenId);
133     }
134 
135     function safeTransferFrom(
136         address _from,
137         address _to,
138         uint256 _tokenId,
139         bytes _data
140     )
141         public
142         canTransfer(_tokenId)
143     {
144         transferFrom(_from, _to, _tokenId);
145         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
146     }
147 
148     function safeTransferFrom(
149         address _from,
150         address _to,
151         uint256 _tokenId
152     )
153         external
154         canTransfer(_tokenId)
155     {
156         safeTransferFrom(_from, _to, _tokenId, "");
157     }
158 
159     function approve(address _approved, uint256 _tokenId) external {
160         address owner = ownerOf(_tokenId);
161         require(_approved != owner);
162         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
163 
164         if (getApproved(_tokenId) != address(0) || _approved != address(0)) {
165             tokenApprovals[_tokenId] = _approved;
166             emit Approval(owner, _approved, _tokenId);
167         }
168     }
169 
170     function setApprovalForAll(address _to, bool _approved) external {
171         require(_to != msg.sender);
172         operatorApprovals[msg.sender][_to] = _approved;
173         emit ApprovalForAll(msg.sender, _to, _approved);
174     }
175 
176     function getApproved(uint256 _tokenId) public view returns (address) {
177         return tokenApprovals[_tokenId];
178     }
179 
180     function isApprovedForAll
181     (
182         address _owner,
183         address _operator
184     )
185         public view returns (bool)
186     {
187         return operatorApprovals[_owner][_operator];
188     }
189 
190     function clearApproval(address _owner, uint256 _tokenId) internal {
191         require(ownerOf(_tokenId) == _owner);
192         if (tokenApprovals[_tokenId] != address(0)) {
193             tokenApprovals[_tokenId] = address(0);
194             emit Approval(_owner, address(0), _tokenId);
195         }
196     }
197 
198     function addTokenTo(address _to, uint256 _tokenId) internal {
199         require(tokenOwner[_tokenId] == address(0));
200         tokenOwner[_tokenId] = _to;
201         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
202     }
203 
204     function removeTokenFrom(address _from, uint256 _tokenId) internal {
205         require(ownerOf(_tokenId) == _from);
206         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
207         tokenOwner[_tokenId] = address(0);
208     }
209 
210     function checkAndCallSafeTransfer(
211         address _from,
212         address _to,
213         uint256 _tokenId,
214         bytes _data
215     )
216         internal
217         returns (bool)
218     {
219         if (!_to.isContract()) {
220             return true;
221         }
222         bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
223         return (retval == InterfaceSignature_ERC721TokenReceiver);
224     }
225 
226     function _mint(address _to, uint256 _tokenId) internal {
227         require(_to != address(0));
228         addTokenTo(_to, _tokenId);
229         emit Transfer(address(0), _to, _tokenId);
230     }
231 
232     function _burn(address _owner, uint256 _tokenId) internal {
233         clearApproval(_owner, _tokenId);
234         removeTokenFrom(_owner, _tokenId);
235         emit Transfer(_owner, address(0), _tokenId);
236     }
237 }
238 
239 contract ERC721Token is ERC721BasicToken{
240 
241     string internal name_;
242     string internal symbol_;
243 
244     // Array with all token ids, used for enumeration
245     uint256[] internal allTokens;
246 
247     // Optional mapping for token URIs
248     mapping(uint256 => string) internal tokenURIs;
249 
250     // Mapping from token id to position in the allTokens array
251     mapping(uint256 => uint256) internal allTokensIndex;
252 
253     // Mapping from owner to list of owned token IDs
254     mapping (address => uint256[]) internal ownedTokens;
255 
256     // Mapping from token ID to index of the owner tokens list
257     mapping(uint256 => uint256) internal ownedTokensIndex;
258 
259     bytes4 constant InterfaceSignature_ERC721Metadata =
260         bytes4(keccak256('name()')) ^
261         bytes4(keccak256('symbol()')) ^
262         bytes4(keccak256('tokenURI(uint256)'));
263 
264     bytes4 constant InterfaceSignature_ERC721Enumerable =
265         bytes4(keccak256('totalSupply()')) ^
266         bytes4(keccak256('tokenByIndex(uint256)')) ^
267         bytes4(keccak256('tokenOfOwnerByIndex(address, uint256)'));
268 
269     function ERC721Token(string _name, string _symbol) public {
270         name_ = _name;
271         symbol_ = _symbol;
272     }
273 
274     //  We implement ERC721Metadata(optional) and ERC721Enumerable(optional).
275     function supportsInterface(bytes4 _interfaceID) public pure returns (bool)
276     {
277         return (
278             super.supportsInterface(_interfaceID)
279             || (_interfaceID == InterfaceSignature_ERC721Metadata)
280             || (_interfaceID == InterfaceSignature_ERC721Enumerable)
281         );
282     }
283 
284     function name() external view returns (string) {
285         return name_;
286     }
287 
288     function symbol() external view returns (string) {
289         return symbol_;
290     }
291 
292     function tokenURI(uint256 _tokenId) external view returns (string) {
293         return tokenURIs[_tokenId];
294     }
295 
296     function totalSupply() external view returns (uint256) {
297         return allTokens.length;
298     }
299 
300     function tokenByIndex(uint256 _index) external view returns (uint256) {
301         require(_index < allTokens.length);
302         return allTokens[_index];
303     }
304 
305     function tokenOfOwnerByIndex(
306         address _owner,
307         uint256 _index
308     )
309         external view returns (uint256)
310     {
311         require(_index < balanceOf(_owner));
312         return ownedTokens[_owner][_index];
313     }
314 
315     function addTokenTo(address _to, uint256 _tokenId) internal {
316         super.addTokenTo(_to, _tokenId);
317 
318         uint256 length = ownedTokens[_to].length;
319         ownedTokens[_to].push(_tokenId);
320         ownedTokensIndex[_tokenId] = length;
321     }
322 
323     function removeTokenFrom(address _from, uint256 _tokenId) internal {
324         super.removeTokenFrom(_from, _tokenId);
325 
326         uint256 tokenIndex = ownedTokensIndex[_tokenId];
327         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
328         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
329 
330         ownedTokens[_from][tokenIndex] = lastToken;
331         ownedTokens[_from][lastTokenIndex] = 0;
332 
333         ownedTokens[_from].length = ownedTokens[_from].length.sub(1);
334         ownedTokensIndex[_tokenId] = 0;
335         ownedTokensIndex[lastToken] = tokenIndex;
336     }
337 
338     function _setTokenURI(uint256 _tokenId, string _uri) internal {
339         require(ownerOf(_tokenId) != address(0));
340         tokenURIs[_tokenId] = _uri;
341     }
342 
343     function _mint(address _to, uint256 _tokenId) internal {
344         super._mint(_to, _tokenId);
345 
346         allTokensIndex[_tokenId] = allTokens.length;
347         allTokens.push(_tokenId);
348     }
349 
350     function _burn(address _owner, uint256 _tokenId) internal {
351         super._burn(_owner, _tokenId);
352 
353         // Clear metadata (if any)
354         if (bytes(tokenURIs[_tokenId]).length != 0) {
355             delete tokenURIs[_tokenId];
356         }
357 
358         uint256 tokenIndex = allTokensIndex[_tokenId];
359         uint256 lastTokenIndex = allTokens.length.sub(1);
360         uint256 lastToken = allTokens[lastTokenIndex];
361 
362         allTokens[tokenIndex] = lastToken;
363         allTokens[lastTokenIndex] = 0;
364 
365         allTokens.length = allTokens.length.sub(1);
366         allTokensIndex[_tokenId] = 0;
367         allTokensIndex[lastToken] = tokenIndex;
368     }
369 }
370 
371 contract owned {
372     address public owner;
373 
374     function owned() public {
375         owner = msg.sender;
376     }
377 
378     modifier onlyOwner {
379         require(msg.sender == owner);
380         _;
381     }
382 
383     function transferOwnership(address newOwner) onlyOwner public {
384         owner = newOwner;
385     }
386 }
387 
388 contract HashLand is ERC721Token, owned{
389 
390     function HashLand() ERC721Token("HashLand", "HSL") public {}
391 
392     struct LandInfo {
393         // Unique key for a land, derived from longitude and latitude
394         bytes8 landKey;
395         string landName;
396 
397         string ownerNick;
398         string landSlogan;
399 
400         bool forSale;
401         uint256 sellPrice;
402     }
403 
404     mapping(uint256 => bytes8) landKeyOfId;
405     mapping(bytes8 => uint256) landIdOfKey;
406     mapping(uint256 => LandInfo) landInfoOfId;
407 
408     mapping (address => uint256) pendingWithdrawals;
409 
410     function mintLand(
411         address _to,
412         bytes8 _landKey,
413         string _landName,
414         string _ownerNick,
415         string _landSlogan,
416         string _landURI     // keccak256(landKey)
417     )
418         public onlyOwner
419     {
420         require(landIdOfKey[_landKey] == 0);
421         uint256 _landId = allTokens.length.add(1);
422 
423         landKeyOfId[_landId] = _landKey;
424         landIdOfKey[_landKey] = _landId;
425         landInfoOfId[_landId] = LandInfo(
426             _landKey, _landName,
427             _ownerNick, _landSlogan,
428             false, 0
429         );
430 
431         _mint(_to, _landId);
432         _setTokenURI(_landId, _landURI);
433     }
434 
435     function officialTransfer(
436         address _to,
437         bytes8 _landKey,
438         string _landName,
439         string _ownerNick,
440         string _landSlogan,
441         string _landURI     // keccak256(landKey)
442     )
443         public
444     {
445         uint256 _landId = landIdOfKey[_landKey];
446         if (_landId == 0) {
447             require(msg.sender == owner);
448             _landId = allTokens.length.add(1);
449 
450             landKeyOfId[_landId] = _landKey;
451             landIdOfKey[_landKey] = _landId;
452             landInfoOfId[_landId] = LandInfo(
453                 _landKey, _landName,
454                 _ownerNick, _landSlogan,
455                 false, 0
456             );
457 
458             _mint(_to, _landId);
459             _setTokenURI(_landId, _landURI);
460         }
461         else {
462             require(tokenOwner[_landId] == msg.sender);
463             require(_to != address(0));
464 
465             landInfoOfId[_landId].forSale = false;
466             landInfoOfId[_landId].sellPrice = 0;
467             landInfoOfId[_landId].ownerNick = _ownerNick;
468             landInfoOfId[_landId].landSlogan = _landSlogan;
469 
470             clearApproval(msg.sender, _landId);
471             removeTokenFrom(msg.sender, _landId);
472             addTokenTo(_to, _landId);
473 
474             emit Transfer(msg.sender, _to, _landId);
475         }
476     }
477 
478 
479     function burnLand(uint256 _landId) public onlyOwnerOf(_landId){
480         bytes8 _landKey = landKeyOfId[_landId];
481         require(_landKey != 0);
482         landKeyOfId[_landId] = 0x0;
483         landIdOfKey[_landKey] = 0;
484         delete landInfoOfId[_landId];
485 
486         _burn(msg.sender, _landId);
487     }
488 
489     function getLandIdByKey(bytes8 _landKey)
490         external view
491         returns (uint256)
492     {
493         return landIdOfKey[_landKey];
494     }
495 
496     function getLandInfo(uint256 _landId)
497         external view
498         returns (bytes8, bool, uint256, string, string, string)
499     {
500         bytes8 _landKey = landKeyOfId[_landId];
501         require(_landKey != 0);
502         return (
503             _landKey,
504             landInfoOfId[_landId].forSale, landInfoOfId[_landId].sellPrice,
505             landInfoOfId[_landId].landName,
506             landInfoOfId[_landId].ownerNick, landInfoOfId[_landId].landSlogan
507         );
508     }
509 
510     function setOwnerNick(
511         uint256 _landId,
512         string _ownerNick
513     )
514         public
515         onlyOwnerOf(_landId)
516     {
517         landInfoOfId[_landId].ownerNick = _ownerNick;
518     }
519 
520     function setLandSlogan(
521         uint256 _landId,
522         string _landSlogan
523     )
524         public
525         onlyOwnerOf(_landId)
526     {
527         landInfoOfId[_landId].landSlogan = _landSlogan;
528     }
529 
530     function setForSale(
531         uint256 _landId,
532         bool _forSale,
533         uint256 _sellPrice
534     )
535         public
536         onlyOwnerOf(_landId)
537     {
538         landInfoOfId[_landId].forSale = _forSale;
539         landInfoOfId[_landId].sellPrice = _sellPrice;
540     }
541 
542     function buyLand(uint256 _landId) payable public {
543         bytes8 _landKey = landKeyOfId[_landId];
544         require(_landKey != 0);
545 
546         require(landInfoOfId[_landId].forSale == true);
547         require(msg.value >= landInfoOfId[_landId].sellPrice);
548 
549         address origin_owner = tokenOwner[_landId];
550 
551         clearApproval(origin_owner, _landId);
552         removeTokenFrom(origin_owner, _landId);
553         addTokenTo(msg.sender, _landId);
554 
555         landInfoOfId[_landId].forSale = false;
556         emit Transfer(origin_owner, msg.sender, _landId);
557 
558         uint256 price = landInfoOfId[_landId].sellPrice;
559         uint256 priviousBalance = pendingWithdrawals[origin_owner];
560         pendingWithdrawals[origin_owner] = priviousBalance.add(price);
561     }
562 
563     function withdraw() public {
564         uint256 amount = pendingWithdrawals[msg.sender];
565         // Remember to zero the pending refund before
566         // sending to prevent re-entrancy attacks
567         pendingWithdrawals[msg.sender] = 0;
568         msg.sender.transfer(amount);
569     }
570 }