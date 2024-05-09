1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.7;
4 
5 interface IERC165 {
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 interface IERC721 is IERC165 {
10     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
11     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
12     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
13 
14     function balanceOf(address owner) external view returns (uint256 balance);
15     function ownerOf(uint256 tokenId) external view returns (address owner);
16     function safeTransferFrom( address from, address to, uint256 tokenId, bytes calldata data) external;
17     function safeTransferFrom( address from, address to, uint256 tokenId) external;
18     function transferFrom(address from, address to, uint256 tokenId) external;
19     function approve(address to, uint256 tokenId) external;
20     function setApprovalForAll(address operator, bool _approved) external;
21     function getApproved(uint256 tokenId) external view returns (address operator);
22     function isApprovedForAll(address owner, address operator) external view returns (bool);
23 }
24 
25 interface IERC721Metadata is IERC721 {
26     function name() external view returns (string memory);
27     function symbol() external view returns (string memory);
28     function tokenURI(uint256 tokenId) external view returns (string memory);
29 }
30 
31 interface IERC721Receiver {
32     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
33 }
34 
35 interface IERC20 {
36     function totalSupply() external view returns (uint256);
37     function balanceOf(address who) external view returns (uint256);
38     function allowance(address _owner, address spender) external view returns (uint256);
39     function transfer(address to, uint256 value) external returns (bool);
40     function approve(address spender, uint256 value) external returns (bool);
41     function transferFrom(address from, address to, uint256 value) external returns (bool);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 library Address {
48     function isContract(address account) internal view returns (bool) {
49         return account.code.length > 0;
50     }
51 }
52 
53 abstract contract ERC721 is IERC721, IERC721Metadata {
54     using Address for address;
55 
56     string private _name;
57     string private _symbol;
58 
59     mapping(uint256 => address) private _owners;
60     mapping(address => uint256) private _balances;
61     mapping(uint256 => address) private _tokenApprovals;
62     mapping(address => mapping(address => bool)) private _operatorApprovals;
63 
64     constructor(string memory name_, string memory symbol_) {
65         _name = name_;
66         _symbol = symbol_;
67     }
68 
69     function supportsInterface(bytes4 interfaceId) external view virtual override returns (bool) {
70         return
71             interfaceId == type(IERC721).interfaceId ||
72             interfaceId == type(IERC721Metadata).interfaceId ||
73             interfaceId == type(IERC165).interfaceId;
74     }
75 
76     function balanceOf(address owner) external view virtual override returns (uint256) {
77         require(owner != address(0), "address zero is not a valid owner");
78         return _balances[owner];
79     }
80 
81     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
82         address owner = _ownerOf(tokenId);
83         require(owner != address(0), "invalid token ID");
84         return owner;
85     }
86 
87     function name() external view virtual override returns (string memory) {
88         return _name;
89     }
90 
91     function symbol() external view virtual override returns (string memory) {
92         return _symbol;
93     }
94 
95     function approve(address to, uint256 tokenId) external virtual override {
96         address owner = ERC721.ownerOf(tokenId);
97         require(to != owner, "approval to current owner");
98 
99         require(
100             msg.sender == owner || isApprovedForAll(owner, msg.sender),
101             "approve caller is not token owner or approved for all"
102         );
103 
104         _approve(to, tokenId);
105     }
106 
107     function getApproved(uint256 tokenId) public view virtual override returns (address) {
108         _requireMinted(tokenId);
109 
110         return _tokenApprovals[tokenId];
111     }
112 
113     function setApprovalForAll(address operator, bool approved) external virtual override {
114         _setApprovalForAll(msg.sender, operator, approved);
115     }
116 
117     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
118         return _operatorApprovals[owner][operator];
119     }
120 
121     function transferFrom(
122         address from,
123         address to,
124         uint256 tokenId
125     ) external virtual override {
126         //solhint-disable-next-line max-line-length
127         require(_isApprovedOrOwner(msg.sender, tokenId), "caller is not token owner or approved");
128 
129         _transfer(from, to, tokenId);
130     }
131 
132     function safeTransferFrom(
133         address from,
134         address to,
135         uint256 tokenId
136     ) external virtual override {
137         safeTransferFrom(from, to, tokenId, "");
138     }
139 
140     function safeTransferFrom(
141         address from,
142         address to,
143         uint256 tokenId,
144         bytes memory data
145     ) public virtual override {
146         require(_isApprovedOrOwner(msg.sender, tokenId), "caller is not token owner or approved");
147         _safeTransfer(from, to, tokenId, data);
148     }
149 
150     function _safeTransfer(
151         address from,
152         address to,
153         uint256 tokenId,
154         bytes memory data
155     ) internal virtual {
156         _transfer(from, to, tokenId);
157         require(_checkOnERC721Received(from, to, tokenId, data), "transfer to non ERC721Receiver implementer");
158     }
159 
160     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
161         return _owners[tokenId];
162     }
163 
164     function _exists(uint256 tokenId) internal view virtual returns (bool) {
165         return _ownerOf(tokenId) != address(0);
166     }
167 
168     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
169         address owner = ERC721.ownerOf(tokenId);
170         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
171     }
172 
173     function _mint(address to, uint256 tokenId) internal virtual {
174         require(to != address(0), "mint to the zero address");
175         require(!_exists(tokenId), "token already minted");
176         require(!_exists(tokenId), "token already minted");
177 
178         unchecked {
179             _balances[to] += 1;
180         }
181 
182         _owners[tokenId] = to;
183 
184         emit Transfer(address(0), to, tokenId);
185     }
186 
187     function _transfer(
188         address from,
189         address to,
190         uint256 tokenId
191     ) internal virtual {
192         require(ERC721.ownerOf(tokenId) == from, "transfer from incorrect owner");
193         require(to != address(0), "transfer to the zero address");
194         require(ERC721.ownerOf(tokenId) == from, "transfer from incorrect owner");
195         delete _tokenApprovals[tokenId];
196 
197         unchecked {
198             _balances[from] -= 1;
199             _balances[to] += 1;
200         }
201         _owners[tokenId] = to;
202 
203         emit Transfer(from, to, tokenId);
204     }
205 
206     function _approve(address to, uint256 tokenId) internal virtual {
207         _tokenApprovals[tokenId] = to;
208         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
209     }
210 
211     function _setApprovalForAll(
212         address owner,
213         address operator,
214         bool approved
215     ) internal virtual {
216         require(owner != operator, "approve to caller");
217         _operatorApprovals[owner][operator] = approved;
218         emit ApprovalForAll(owner, operator, approved);
219     }
220 
221     function _requireMinted(uint256 tokenId) internal view virtual {
222         require(_exists(tokenId), "invalid token ID");
223     }
224 
225     function _checkOnERC721Received(
226         address from,
227         address to,
228         uint256 tokenId,
229         bytes memory data
230     ) private returns (bool) {
231         if (to.isContract()) {
232             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
233                 return retval == IERC721Receiver.onERC721Received.selector;
234             } catch (bytes memory reason) {
235                 if (reason.length == 0) {
236                     revert("ERC721: transfer to non ERC721Receiver implementer");
237                 } else {
238                     /// @solidity memory-safe-assembly
239                     assembly {
240                         revert(add(32, reason), mload(reason))
241                     }
242                 }
243             }
244         } else {
245             return true;
246         }
247     }
248 }
249 
250 contract BananaTaskForceApeGenesis is ERC721 {
251 
252     address public owner;
253     bool public enabled;
254     address payable public wallet;
255     uint256 public total;
256     uint256 public remaining;
257     bool public opened;
258 
259     string private _baseTokenURI;
260     uint256 private nonce = 0;
261     uint256 private blockSize;
262     uint256[] private blockLog;
263 
264     SaleMode public saleMode;
265 
266     uint256 public reserved;
267     uint256 public reserveLimit;
268 
269     enum SaleMode { FREELIST, WHITELIST, PUBLIC1, PUBLIC2 }
270     struct Mode {
271         uint256 price;
272         uint256 limit;
273         bool useWhitelist;
274         mapping(address => uint256) purchases;
275         mapping(address => bool) whitelist;
276     }
277     mapping(SaleMode => Mode) private modes;
278 
279     modifier onlyOwner() {
280         require(msg.sender == owner, "can only be called by the contract owner");
281         _;
282     }
283 
284     modifier isEnabled() {
285         require(enabled, "sale is currently disabled");
286         _;
287     }
288 
289     constructor() ERC721("Banana Task Force Ape Genesis Collection", "BTFA") {
290         owner = msg.sender;
291         _baseTokenURI = "https://bafybeicxrpwqlno3hrtli7qtjp6sh35arge4why5t73c75uib73tk2mnsi.ipfs.nftstorage.link/";
292 
293         wallet = payable(0x2411eD788bACdB0394570c8B3A393Af0AB9Cfb4F);
294         saleMode = SaleMode.FREELIST;
295         reserveLimit = 500;
296 
297         modes[SaleMode.FREELIST].price = 0;
298         modes[SaleMode.FREELIST].limit = 2;
299         modes[SaleMode.FREELIST].useWhitelist = true;
300 
301         modes[SaleMode.WHITELIST].price = 100000000000000000;
302         modes[SaleMode.WHITELIST].limit = 10;
303         modes[SaleMode.WHITELIST].useWhitelist = true;
304 
305         modes[SaleMode.PUBLIC1].price = 125000000000000000;
306         modes[SaleMode.PUBLIC1].limit = 8;
307         modes[SaleMode.PUBLIC1].useWhitelist = false;
308 
309         modes[SaleMode.PUBLIC2].price = 150000000000000000;
310         modes[SaleMode.PUBLIC2].limit = 5;
311         modes[SaleMode.PUBLIC2].useWhitelist = false;
312 
313         total = 8000;
314         blockSize = 100;
315         remaining = total;
316         for (uint256 i = 0; i < total / blockSize; i++) {
317             blockLog.push(blockSize);
318         }
319     }
320 
321     function tokenURI(uint256 tokenId) external override view returns (string memory) {
322         require(_exists(tokenId));
323 
324         if (opened) {
325             return string(abi.encodePacked(_baseTokenURI, uint2str(tokenId), ".json"));
326         } else {
327             return "https://bafybeidjtckjrh3yygyk5qcwx7t43uan7vibhgubg56wsgxenykfj5whwa.ipfs.nftstorage.link/closed.json";
328         }
329     }
330 
331     function status() public view returns (bool canBuy, uint256 boxCost, uint256 boxRemaining, uint256 hasPurchased, uint256 purchaseLimit) { 
332         canBuy = enabled && canPurchase(msg.sender, 1);
333         boxCost = modes[saleMode].price;
334         boxRemaining = remaining;
335         hasPurchased =  modes[saleMode].purchases[msg.sender];
336         purchaseLimit =  modes[saleMode].limit;
337     }
338 
339     function purchaseBlindbox(uint256 amount) public payable isEnabled {
340         require (remaining >= amount, "Not enough blindboxes available");
341         require(canPurchase(msg.sender, amount), "You cannot purchase at this time.");
342         require (msg.value == modes[saleMode].price * amount, "Incorrect Eth value.");
343 
344         if (modes[saleMode].price > 0) {
345             wallet.transfer(modes[saleMode].price * amount);
346         }
347 
348         for (uint256 i = 0; i < amount; i++) {
349             mint(msg.sender);
350         }
351         modes[saleMode].purchases[msg.sender] += amount;
352     }
353 
354     function mint(address who) private {
355         uint256 nftBlock = requestRandomWords();
356         uint256 blockRoll = nftBlock % blockLog.length;
357         while (blockLog[blockRoll] == 0) {
358             blockRoll++;
359 
360             if (blockRoll >= blockLog.length) {
361                 blockRoll = 0;
362             }
363         }
364 
365         uint256 nftRoll = requestRandomWords();
366         uint256 roll = nftRoll % blockSize + 1;
367         while (_exists(blockRoll * blockSize + roll)) {
368             roll++;
369 
370             if (roll > blockSize) {
371                 roll = 1;
372             }
373         }
374 
375         _mint(who, blockRoll * blockSize + roll);
376         blockLog[blockRoll]--;
377         remaining--;
378     }
379 
380     // Admin
381 
382     function setOwner(address who) external onlyOwner {
383         owner = who;
384     } 
385 
386     function openBoxes() external onlyOwner {
387         opened = true;
388     } 
389 
390     function setPrice(SaleMode mode, uint256 price) external onlyOwner {
391         modes[mode].price = price;
392     }
393 
394     function setEnabled(bool on) external onlyOwner {
395         enabled = on;
396     }
397 
398     function setMode(SaleMode mode) external onlyOwner {
399         saleMode = mode;
400     }
401 
402     function setUseWhitelist(SaleMode mode, bool on) external onlyOwner {
403         modes[mode].useWhitelist = on;
404     }
405 
406     function setWhitelist(SaleMode mode, address who, bool whitelisted) external onlyOwner {
407         modes[mode].whitelist[who] = whitelisted;
408     }
409 
410     function setWhitelisted(SaleMode mode, address[] calldata who, bool whitelisted) external onlyOwner {
411         for (uint256 i = 0; i < who.length; i++) {
412             modes[mode].whitelist[who[i]] = whitelisted;
413         }
414     }
415 
416     function setBuyLimits(SaleMode mode, uint256 limit) external onlyOwner {
417         modes[mode].limit = limit;
418     }
419 
420     function reserveNfts(address who, uint256 amount) external onlyOwner {
421         require(reserved + amount <= reserveLimit, "NFTS have already been reserved");
422 
423         for (uint256 i = 0; i < amount; i++) {
424             mint(who);
425         }
426 
427         reserved += amount;
428     }
429 
430     // Private
431 
432     function canPurchase(address who, uint256 amount) private view returns (bool) {
433         return modes[saleMode].purchases[who] + amount <= modes[saleMode].limit && 
434             (modes[saleMode].useWhitelist == false || modes[saleMode].whitelist[who]);
435     }
436 
437     function uint2str(uint _i) private pure returns (string memory _uintAsString) {
438         if (_i == 0) {
439             return "0";
440         }
441         uint j = _i;
442         uint len;
443         while (j != 0) {
444             len++;
445             j /= 10;
446         }
447         bytes memory bstr = new bytes(len);
448         uint k = len;
449         while (_i != 0) {
450             k = k-1;
451             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
452             bytes1 b1 = bytes1(temp);
453             bstr[k] = b1;
454             _i /= 10;
455         }
456         return string(bstr);
457     }
458 
459     function requestRandomWords() private returns (uint256) {
460         nonce += 1;
461         return uint(keccak256(abi.encodePacked(nonce, msg.sender, blockhash(block.number - 1))));
462     }
463 
464 }