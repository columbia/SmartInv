1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 
4 
5 interface IERC165 {
6 
7     function supportsInterface(bytes4 interfaceId) external view returns (bool);
8 }
9 
10 interface IERC721 is IERC165 {
11     
12     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
13 
14     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
15 
16     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
17 
18     function balanceOf(address _owner) external view returns (uint256);
19 
20     function ownerOf(uint256 _tokenId) external view returns (address);
21     
22     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external;
23 
24     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
25 
26     function transferFrom(address _from, address _to, uint256 _tokenId) external;
27 
28     function approve(address _approved, uint256 _tokenId) external;
29 
30     function setApprovalForAll(address _operator, bool _approved) external;
31 
32     function getApproved(uint256 _tokenId) external view returns (address);
33 
34     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
35     
36 }
37 
38 interface IERC721Metadata is IERC721 {
39 
40     /**
41      * @dev Returns the token collection name.
42      */
43     function name() external view returns (string memory);
44 
45     /**
46      * @dev Returns the token collection symbol.
47      */
48     function symbol() external view returns (string memory);
49     
50     function totalSupply() external view returns(uint256);
51     
52     /**
53      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
54      */
55     function tokenURI(uint256 tokenId) external view returns (string memory);
56 }
57 
58 abstract contract ERC165 is IERC165 {
59 
60     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
61         return interfaceId == type(IERC165).interfaceId;
62     }
63 }
64 
65 library Strings {
66 
67     function toString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86 }
87 
88 abstract contract CFMS { //Crypto Family Management Standard
89 
90     address private _owner;
91     mapping(address => bool) private _manager;
92 
93     event OwnershipTransfer(address indexed newOwner);
94     event SetManager(address indexed manager, bool state);
95 
96     constructor() {
97         _owner = msg.sender;
98         _manager[msg.sender] = true;
99 
100         emit SetManager(msg.sender, true);
101     }
102 
103     //Modifiers ==========================================================================================================================================
104     modifier Owner() {
105         require(msg.sender == _owner, "CFMS: NOT_OWNER");
106         _;  
107     }
108 
109     modifier Manager() {
110       require(_manager[msg.sender], "CFMS: MOT_MANAGER");
111       _;  
112     }
113 
114     //Read functions =====================================================================================================================================
115     function owner() public view returns (address) {
116         return _owner;
117     }
118 
119     function manager(address user) external view returns(bool) {
120         return _manager[user];
121     }
122 
123     
124     //Write functions ====================================================================================================================================
125     function setNewOwner(address user) external Owner {
126         _owner = user;
127         emit OwnershipTransfer(user);
128     }
129 
130     function setManager(address user, bool state) external Owner {
131         _manager[user] = state;
132         emit SetManager(user, state);
133     }
134 
135 
136 }
137 
138 abstract contract CF_ERC721 is CFMS, ERC165, IERC721, IERC721Metadata{ //Crypto Family ERC721 Standard
139     using Strings for uint256;
140 
141     string internal uriLink = "";
142     
143     uint256 internal _totalSupply;
144 
145     string private _name = "Surreal Society";
146     string private _symbol = "SURREAL";
147 
148     mapping(uint256 => address) internal _owners;
149     mapping(address => uint256) private _balances;
150     mapping(uint256 => address) private _tokenApprovals;
151     mapping(address => mapping(address => bool)) private _operatorApprovals;
152 
153     //Read Functions======================================================================================================================================================
154     
155     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
156         return interfaceId == type(IERC721).interfaceId
157             || interfaceId == type(IERC721Metadata).interfaceId
158             || super.supportsInterface(interfaceId);
159     }
160 
161     function balanceOf(address owner) external view override returns (uint256) {
162         require(owner != address(0), "ERC721: balance query for the zero address");
163         return _balances[owner];
164     }
165 
166     function ownerOf(uint256 tokenId) external view override returns (address) {
167         address owner = _owners[tokenId];
168         require(owner != address(0), "ERC721: owner query for nonexistent token");
169         return owner;
170     }
171 
172     function name() public view override returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public view override returns (string memory) {
177         return _symbol;
178     }
179     
180     function totalSupply() public view override returns(uint256){return _totalSupply;}
181 
182     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
183         return string(abi.encodePacked(uriLink, "secret.json"));
184 
185     }
186 
187     function getApproved(uint256 tokenId) external view override returns (address) {
188         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
189 
190         return _tokenApprovals[tokenId];
191     }
192 
193     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
194         return _operatorApprovals[owner][operator];
195     }
196     
197     //Moderator Functions======================================================================================================================================================
198 
199     function changeURIlink(string calldata newUri) external Manager {
200         uriLink = newUri;
201     }
202 
203     function changeData(string calldata name, string calldata symbol) external Manager {
204         _name = name;
205         _symbol = symbol;
206     }
207 
208     //User Functions======================================================================================================================================================
209     function approve(address to, uint256 tokenId) external override {
210         address owner = _owners[tokenId];
211 
212         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
213             "ERC721: approve caller is not owner nor approved for all"
214         );
215 
216         _approve(to, tokenId);
217     }
218 
219     function setApprovalForAll(address operator, bool approved) public override {
220         require(operator != msg.sender, "ERC721: approve to caller");
221 
222         _operatorApprovals[msg.sender][operator] = approved;
223         emit ApprovalForAll(msg.sender, operator, approved);
224     }
225 
226     function transferFrom(address from, address to, uint256 tokenId) external override {
227         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
228 
229         _transfer(from, to, tokenId);
230     }
231 
232     function safeTransferFrom(address from, address to, uint256 tokenId) external override {
233         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
234         _transfer(from, to, tokenId);
235     }
236 
237     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external override {
238         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
239         _safeTransfer(from, to, tokenId, _data);
240     }
241 
242     //Internal Functions======================================================================================================================================================
243     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal {
244         _transfer(from, to, tokenId);
245     }
246 
247     function _exists(uint256 tokenId) internal view returns (bool) {
248         return _owners[tokenId] != address(0);
249     }
250 
251     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
252         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
253         address owner = _owners[tokenId];
254         require(spender == owner || _tokenApprovals[tokenId] == spender || isApprovedForAll(owner, spender), "ERC721: Not approved or owner");
255         return true;
256     }
257     
258     function _transfer(address from, address to, uint256 tokenId) internal {
259         require(_owners[tokenId] == from, "ERC721: transfer of token that is not own");
260         require(to != address(0), "ERC721: transfer to the zero address");
261 
262         // Clear approvals from the previous owner
263         _approve(address(0), tokenId);
264 
265         _balances[from] -= 1;
266         _balances[to] += 1;
267         _owners[tokenId] = to;
268 
269         emit Transfer(from, to, tokenId);
270     }
271 
272     function _approve(address to, uint256 tokenId) internal {
273         _tokenApprovals[tokenId] = to;
274         emit Approval(_owners[tokenId], to, tokenId);
275     }
276 
277     function _mint(address user, uint256 amount) internal {
278         _balances[user] += amount;
279         
280         uint256 tokenId;
281         for(uint256 t; t < amount; ++t) {
282             tokenId = _totalSupply++;
283             
284             _owners[tokenId] = user;
285                 
286             emit Transfer(address(0), user, tokenId);
287         }
288         
289     }
290 }
291 
292 contract SURREAL is CF_ERC721 {
293     
294     using Strings for uint256;
295 
296     bool private _reveal = false;
297 
298     uint256 private _whitePrice = 100000000000000000;
299     uint256 private _publicPrice = 150000000000000000;
300 
301     mapping(address => uint256) private _userWhiteMints; //How many times did the user mint in white lsit minting
302 
303     uint256 private _whiteMinted;
304 
305     mapping(address => bool) private _whiteAccess;
306     
307     constructor() {
308         _mint(0x81cc8A4bb62fF93f62EC94e3AA40A3A862c54368, 10);
309     }
310 
311     //Read Functions======================================================================================================================================================
312 
313     function tokenURI(uint256 tokenId) external view override returns (string memory) {
314         if(!_reveal) {return string(abi.encodePacked(uriLink, "secret.json"));}
315         
316         ++tokenId;
317         return string(abi.encodePacked(uriLink, tokenId.toString(), ".json"));
318 
319     }
320 
321     function prices() public view returns(uint256 whitePrice, uint256 publicPrice) {
322         whitePrice = _whitePrice;
323         publicPrice = _publicPrice;
324     }
325 
326     function whiteListed(address user) external view returns(bool listed) {
327         return _whiteAccess[user];
328     } 
329 
330     function userWhiteMints(address user) external view returns(uint256 mints) {
331         return _userWhiteMints[user];
332     }
333     
334     //Moderator Functions======================================================================================================================================================
335 
336     function setWhiteList(address[] calldata whiteUsers) external Owner {
337         uint256 size = whiteUsers.length;
338             
339             for(uint256 t; t < size; ++t) {
340                 _whiteAccess[whiteUsers[t]] = true;
341             }
342     }
343 
344     function adminMint(address to, uint256 amount) external Manager {
345         _mint(to, amount);
346     }
347 
348     function adminMint(address[] calldata to, uint256[] calldata amount) external Manager {
349         uint256 size = to.length;
350 
351         for(uint256 t; t < size; ++t) {
352             _mint(to[t], amount[t]);
353         }
354     }
355 
356     function changePrices(uint256 whitePrice, uint256 publicPrice) external Manager {
357         _whitePrice = whitePrice;
358         _publicPrice = publicPrice;
359     }
360 
361     function toggleReveal() external Manager {
362         _reveal = !_reveal;
363     }
364 
365     function withdraw(address payable to, uint256 value) external Manager {
366         to.transfer(value);
367     }
368 
369     function distribute() public Manager {
370         
371         uint256 balance = address(this).balance / 10000; // This is 0.01% of the total balance -> Needed to do presition calculations without floating point.
372         
373         require(payable(0x81cc8A4bb62fF93f62EC94e3AA40A3A862c54368).send(balance * 5000));
374         require(payable(0x10f3667970FAd7dA441261c80727caCd8B164806).send(balance * 900));
375         require(payable(0x7A6c41c001d6Fbf4AE6022E936B24d0d39AE3a25).send(balance * 325));
376         require(payable(0x6Ec4EAA315aba37B7558A66c51D0dd4986128bCb).send(balance * 325));
377         require(payable(0xcc2ba3C4E74A531635b928D2aC5B3f176C8B6ec3).send(balance * 216));
378         require(payable(0x37B8C37EB031312c5DaaA02fD5baD9Dc380a8cc4).send(balance * 125));
379         require(payable(0xC970bd4E2dF5F33ea62c72b9c3d808b8a609e5e1).send(balance * 550));
380         require(payable(0xED7AdfDBbcB1b5C93fa8B6b28B0Fc833Fa68BCA0).send(balance * 580));
381         require(payable(0x50a583Ab2432BF3bC5E7458C8ed10BC5Ec3AB23E).send(balance * 580));
382         require(payable(0x3b0f95D44f629e8E24a294799c4A1D21f06B6969).send(balance * 225));
383         require(payable(0x02916D0f68a02c502476DC630628B01Ee36A7826).send(balance * 50));
384         require(payable(0x41b6cb632F5707bF80a1c904316b19fcBee2a4cF).send(balance * 50));
385         require(payable(0x2C1Ba2909A0dC98A6219079FBe9A4ab23517D47E).send(balance * 50));
386         require(payable(0x58EE6F81AE4Ed77E8Dc50344Ab7571EA7A75a9b7).send(balance * 24));
387 
388         require(payable(0x3AA599FB8003B94666c9D66Db43D859ef5EEa29f).send(address(this).balance));
389     }
390     
391     //User Functions======================================================================================================================================================
392 
393     function whiteMint() external payable {
394         require(_whiteAccess[msg.sender], "SURREAL: Invalid Access"); 
395 
396         uint256 amount = msg.value / _whitePrice;
397 
398         _userWhiteMints[msg.sender] += amount;
399         require(_userWhiteMints[msg.sender] < 11, "SURREAL: Minting Limit Reached");
400 
401         _whiteMinted += amount;
402         require(_whiteMinted < 1500,"SURREAL: Insufficient White Mint Tokens");
403 
404         _mint(msg.sender, amount);
405     }
406 
407     function mint() external payable {
408         uint256 amount = msg.value / _publicPrice;
409 
410         require(_totalSupply + amount < 5000, "SURREAL: Insufficient Tokens");
411 
412         _mint(msg.sender, amount);
413     }
414 
415 }