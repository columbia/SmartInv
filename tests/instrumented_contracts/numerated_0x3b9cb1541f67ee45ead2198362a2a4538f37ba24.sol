1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 interface IERC721Receiver {
33   function onERC721Received(
34     address _operator,
35     address _from,
36     uint256 _tokenId,
37     bytes   _userData
38   ) external returns (bytes4);
39 }
40 
41 contract IERC721Metadata {
42     function name() external view returns (string);
43     function symbol() external view returns (string);
44     function description() external view returns (string);
45     function tokenMetadata(uint256 assetId) external view returns (string);
46 }
47 
48 contract IERC721Enumerable {
49     function tokensOf(address owner) external view returns (uint256[]);
50     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
51 }
52 
53 interface IERC721Base {
54     function totalSupply() external view returns (uint256);
55     // function exists(uint256 assetId) external view returns (bool);
56     function ownerOf(uint256 assetId) external view returns (address);
57     function balanceOf(address holder) external view returns (uint256);
58     function safeTransferFrom(address from, address to, uint256 assetId) external;
59     function safeTransferFrom(address from, address to, uint256 assetId, bytes userData) external;
60     function transferFrom(address from, address to, uint256 assetId) external;
61     function approve(address operator, uint256 assetId) external;
62     function setApprovalForAll(address operator, bool authorized) external;
63     function getApprovedAddress(uint256 assetId) external view returns (address);
64     function isApprovedForAll(address assetHolder, address operator) external view returns (bool);
65     function isAuthorized(address operator, uint256 assetId) external view returns (bool);
66 
67     event Transfer(address indexed from, address indexed to, uint256 indexed assetId, address operator, bytes userData);
68     event Transfer(address indexed from, address indexed to, uint256 indexed assetId);
69     event ApprovalForAll(address indexed operator, address indexed holder, bool authorized);
70     event Approval(address indexed owner, address indexed operator, uint256 indexed assetId);
71 }
72 
73 interface ERC165 {
74   function supportsInterface(bytes4 interfaceID) external view returns (bool);
75 }
76 
77 contract AssetRegistryStorage {
78     string internal _name;
79     string internal _symbol;
80     string internal _description;
81 
82     uint256 internal _count;
83     mapping(address => uint256[]) internal _assetsOf;
84     mapping(uint256 => address) internal _holderOf;
85     mapping(uint256 => uint256) internal _indexOfAsset;
86     mapping(uint256 => string) internal _assetData;
87     mapping(address => mapping(address => bool)) internal _operators;
88     mapping(uint256 => address) internal _approval;
89 }
90 
91 contract ERC721Enumerable is AssetRegistryStorage, IERC721Enumerable {
92     function tokensOf(address owner) external view returns (uint256[]) {
93         return _assetsOf[owner];
94     }
95 
96     function tokenOfOwnerByIndex(address owner, uint256 index)external view returns (uint256 assetId) {
97         require(index < _assetsOf[owner].length);
98         require(index < (1<<127));
99         return _assetsOf[owner][index];
100     }
101 }
102 
103 contract ERC721Holder is IERC721Receiver {
104     bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
105 
106     function onERC721Received(address /* _operator */, address /* _from */, uint256 /* _tokenId */, bytes /* _data */) external returns (bytes4) {
107         return ERC721_RECEIVED;
108     }
109 }
110 
111 contract ERC721Metadata is AssetRegistryStorage, IERC721Metadata {
112     function name() external view returns (string) {
113         return _name;
114     }
115 
116     function symbol() external view returns (string) {
117         return _symbol;
118     }
119 
120     function description() external view returns (string) {
121         return _description;
122     }
123 
124     function tokenMetadata(uint256 assetId) external view returns (string) {
125         return _assetData[assetId];
126     }
127 
128     function _update(uint256 assetId, string data) internal {
129         _assetData[assetId] = data;
130     }
131 }
132 
133 contract ERC721Base is AssetRegistryStorage, IERC721Base, ERC165 {
134     using SafeMath for uint256;
135 
136     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
137     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
138 
139     bytes4 private constant InterfaceId_ERC165 = 0x01ffc9a7;
140     /*
141     * 0x01ffc9a7 ===
142     *   bytes4(keccak256('supportsInterface(bytes4)'))
143     */
144 
145     bytes4 private constant Old_InterfaceId_ERC721 = 0x7c0633c6;
146     bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
147     /*
148     * 0x80ac58cd ===
149     *   bytes4(keccak256('balanceOf(address)')) ^
150     *   bytes4(keccak256('ownerOf(uint256)')) ^
151     *   bytes4(keccak256('approve(address,uint256)')) ^
152     *   bytes4(keccak256('getApproved(uint256)')) ^
153     *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
154     *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
155     *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
156     *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
157     *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
158     */
159 
160     //
161     // Global Getters
162     //
163 
164     /**
165     * @dev Gets the total amount of assets stored by the contract
166     * @return uint256 representing the total amount of assets
167     */
168     function totalSupply() external view returns (uint256) {
169         return _totalSupply();
170     }
171 
172     function _totalSupply() internal view returns (uint256) {
173         return _count;
174     }
175 
176     function ownerOf(uint256 assetId) external view returns (address) {
177         return _ownerOf(assetId);
178     }
179 
180     function _ownerOf(uint256 assetId) internal view returns (address) {
181         return _holderOf[assetId];
182     }
183 
184     function balanceOf(address owner) external view returns (uint256) {
185         return _balanceOf(owner);
186     }
187 
188     function _balanceOf(address owner) internal view returns (uint256) {
189         return _assetsOf[owner].length;
190     }
191 
192     function isApprovedForAll(address assetHolder, address operator) external view returns (bool) {
193         return _isApprovedForAll(assetHolder, operator);
194     }
195     
196     function _isApprovedForAll(address assetHolder, address operator) internal view returns (bool) {
197         return _operators[assetHolder][operator];
198     }
199 
200     function getApproved(uint256 assetId) external view returns (address) {
201         return _getApprovedAddress(assetId);
202     }
203 
204     function getApprovedAddress(uint256 assetId) external view returns (address) {
205         return _getApprovedAddress(assetId);
206     }
207 
208     function _getApprovedAddress(uint256 assetId) internal view returns (address) {
209         return _approval[assetId];
210     }
211 
212     function isAuthorized(address operator, uint256 assetId) external view returns (bool) {
213         return _isAuthorized(operator, assetId);
214     }
215 
216     function _isAuthorized(address operator, uint256 assetId) internal view returns (bool) {
217         require(operator != 0);
218         address owner = _ownerOf(assetId);
219         if (operator == owner) {
220             return true;
221         }
222         return _isApprovedForAll(owner, operator) || _getApprovedAddress(assetId) == operator;
223     }
224 
225     function setApprovalForAll(address operator, bool authorized) external {
226         return _setApprovalForAll(operator, authorized);
227     }
228 
229     function _setApprovalForAll(address operator, bool authorized) internal {
230         if (authorized) {
231             require(!_isApprovedForAll(msg.sender, operator));
232             _addAuthorization(operator, msg.sender);
233         } else {
234             require(_isApprovedForAll(msg.sender, operator));
235             _clearAuthorization(operator, msg.sender);
236         }
237         emit ApprovalForAll(msg.sender, operator, authorized);
238     }
239 
240     function approve(address operator, uint256 assetId) external {
241         address holder = _ownerOf(assetId);
242         require(msg.sender == holder || _isApprovedForAll(msg.sender, holder));
243         require(operator != holder);
244 
245         if (_getApprovedAddress(assetId) != operator) {
246             _approval[assetId] = operator;
247             emit Approval(holder, operator, assetId);
248         }
249     }
250 
251     function _addAuthorization(address operator, address holder) private {
252         _operators[holder][operator] = true;
253     }
254 
255     function _clearAuthorization(address operator, address holder) private {
256         _operators[holder][operator] = false;
257     }
258 
259     function _addAssetTo(address to, uint256 assetId) internal {
260         _holderOf[assetId] = to;
261 
262         uint256 length = _balanceOf(to);
263 
264         _assetsOf[to].push(assetId);
265 
266         _indexOfAsset[assetId] = length;
267 
268         _count = _count.add(1);
269     }
270 
271     function _removeAssetFrom(address from, uint256 assetId) internal {
272         uint256 assetIndex = _indexOfAsset[assetId];
273         uint256 lastAssetIndex = _balanceOf(from).sub(1);
274         uint256 lastAssetId = _assetsOf[from][lastAssetIndex];
275 
276         _holderOf[assetId] = 0;
277 
278         // Insert the last asset into the position previously occupied by the asset to be removed
279         _assetsOf[from][assetIndex] = lastAssetId;
280 
281         // Resize the array
282         _assetsOf[from][lastAssetIndex] = 0;
283         _assetsOf[from].length--;
284 
285         // Remove the array if no more assets are owned to prevent pollution
286         if (_assetsOf[from].length == 0) {
287             delete _assetsOf[from];
288         }
289 
290         // Update the index of positions for the asset
291         _indexOfAsset[assetId] = 0;
292         _indexOfAsset[lastAssetId] = assetIndex;
293 
294         _count = _count.sub(1);
295     }
296 
297     function _clearApproval(address holder, uint256 assetId) internal {
298         if (_ownerOf(assetId) == holder && _approval[assetId] != 0) {
299             _approval[assetId] = 0;
300             emit Approval(holder, 0, assetId);
301         }
302     }
303 
304     function _generate(uint256 assetId, address beneficiary) internal {
305         require(_holderOf[assetId] == 0);
306 
307         _addAssetTo(beneficiary, assetId);
308 
309         emit Transfer(0, beneficiary, assetId);
310     }
311 
312     function _destroy(uint256 assetId) internal {
313         address holder = _holderOf[assetId];
314         require(holder != 0);
315 
316         _removeAssetFrom(holder, assetId);
317 
318         emit Transfer(holder, 0, assetId);
319     }
320 
321     modifier onlyHolder(uint256 assetId) {
322         require(_ownerOf(assetId) == msg.sender);
323         _;
324     }
325 
326     modifier onlyAuthorized(uint256 assetId) {
327         require(_isAuthorized(msg.sender, assetId));
328         _;
329     }
330 
331     modifier isCurrentOwner(address from, uint256 assetId) {
332         require(_ownerOf(assetId) == from);
333         _;
334     }
335 
336     modifier isDestinataryDefined(address destinatary) {
337         require(destinatary != 0);
338         _;
339     }
340 
341     modifier destinataryIsNotHolder(uint256 assetId, address to) {
342         require(_ownerOf(assetId) != to);
343         _;
344     }
345 
346     function safeTransferFrom(address from, address to, uint256 assetId) external {
347         return _doTransferFrom(from, to, assetId, '', true);
348     }
349 
350     function safeTransferFrom(address from, address to, uint256 assetId, bytes userData) external {
351         return _doTransferFrom(from, to, assetId, userData, true);
352     }
353 
354     function transferFrom(address from, address to, uint256 assetId) external {
355         return _doTransferFrom(from, to, assetId, '', false);
356     }
357 
358     function _doTransferFrom(address from, address to, uint256 assetId, bytes userData, bool doCheck) onlyAuthorized(assetId) internal {
359         _moveToken(from, to, assetId, userData, doCheck);
360     }
361 
362     function _moveToken(address from, address to, uint256 assetId, bytes userData, bool doCheck) isDestinataryDefined(to) destinataryIsNotHolder(assetId, to) isCurrentOwner(from, assetId) internal{
363         address holder = _holderOf[assetId];
364         _removeAssetFrom(holder, assetId);
365         _clearApproval(holder, assetId);
366         _addAssetTo(to, assetId);
367 
368         if (doCheck && _isContract(to)) {
369             // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
370             require(IERC721Receiver(to).onERC721Received(msg.sender, holder, assetId, userData) == ERC721_RECEIVED);
371         }
372 
373         emit Transfer(holder, to, assetId);
374     }
375 
376     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
377         if (_interfaceID == 0xffffffff) {
378             return false;
379         }
380         
381         return _interfaceID == InterfaceId_ERC165 || _interfaceID == Old_InterfaceId_ERC721 || _interfaceID == InterfaceId_ERC721;
382     }
383 
384     function _isContract(address addr) internal view returns (bool) {
385         uint size;
386         assembly { size := extcodesize(addr) }
387 
388         return size > 0;
389     }
390 }
391 
392 contract FullAssetRegistry is ERC721Base, ERC721Enumerable, ERC721Metadata {
393     constructor() public {
394     }
395 
396     function exists(uint256 assetId) external view returns (bool) {
397         return _exists(assetId);
398     }
399 
400     function _exists(uint256 assetId) internal view returns (bool) {
401         return _holderOf[assetId] != 0;
402     }
403 
404     function decimals() external pure returns (uint256) {
405         return 0;
406     }
407 }
408 
409 contract JZToken is FullAssetRegistry {
410     constructor() public {
411         _name = "JZToken";
412         _symbol = "JZ";
413         _description = "JZ NFT Token";
414     }
415 
416     function isContractProxy(address addr) public view returns (bool) {
417         return _isContract(addr);
418     }
419 
420     function generate(uint256 assetId, address beneficiary) public {
421         _generate(assetId, beneficiary);
422     }
423 
424     function destroy(uint256 assetId) public {
425         _destroy(assetId);
426     }
427 
428     // Problematic override on truffle
429     function safeTransfer(address from, address to, uint256 assetId, bytes data) public {
430         return _doTransferFrom(from, to, assetId, data, true);
431     }
432 }