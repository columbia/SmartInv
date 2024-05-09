1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 
4 interface IERC165 {
5 
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 interface IERC721 is IERC165 {
10     
11     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
12 
13     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
14 
15     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
16 
17     function balanceOf(address _owner) external view returns (uint256);
18 
19     function ownerOf(uint256 _tokenId) external view returns (address);
20     
21     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external;
22 
23     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
24 
25     function transferFrom(address _from, address _to, uint256 _tokenId) external;
26 
27     function approve(address _approved, uint256 _tokenId) external;
28 
29     function setApprovalForAll(address _operator, bool _approved) external;
30 
31     function getApproved(uint256 _tokenId) external view returns (address);
32 
33     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
34     
35 }
36 
37 interface IERC721Metadata is IERC721 {
38 
39     /**
40      * @dev Returns the token collection name.
41      */
42     function name() external view returns (string memory);
43 
44     /**
45      * @dev Returns the token collection symbol.
46      */
47     function symbol() external view returns (string memory);
48     
49     function totalSupply() external view returns(uint256);
50     
51     /**
52      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
53      */
54     function tokenURI(uint256 tokenId) external view returns (string memory);
55 }
56 
57 abstract contract ERC165 is IERC165 {
58 
59     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
60         return interfaceId == type(IERC165).interfaceId;
61     }
62 }
63 
64 library Strings {
65 
66     function toString(uint256 value) internal pure returns (string memory) {
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85 }
86 
87 abstract contract OMS { //Orcania Management Standard
88 
89     address private _owner;
90     mapping(address => bool) private _manager;
91 
92     event OwnershipTransfer(address indexed newOwner);
93     event SetManager(address indexed manager, bool state);
94 
95     receive() external payable {}
96     
97     constructor() {
98         _owner = msg.sender;
99         _manager[msg.sender] = true;
100 
101         emit SetManager(msg.sender, true);
102     }
103 
104     //Modifiers ==========================================================================================================================================
105     modifier Owner() {
106         require(msg.sender == _owner, "OMS: NOT_OWNER");
107         _;  
108     }
109 
110     modifier Manager() {
111       require(_manager[msg.sender], "OMS: MOT_MANAGER");
112       _;  
113     }
114 
115     //Read functions =====================================================================================================================================
116     function owner() public view returns (address) {
117         return _owner;
118     }
119 
120     function manager(address user) external view returns(bool) {
121         return _manager[user];
122     }
123 
124     
125     //Write functions ====================================================================================================================================
126     function setNewOwner(address user) external Owner {
127         _owner = user;
128         emit OwnershipTransfer(user);
129     }
130 
131     function setManager(address user, bool state) external Owner {
132         _manager[user] = state;
133         emit SetManager(user, state);
134     }
135 
136     //===============
137 
138     function withdraw(address payable to, uint256 value) external Manager {
139         require(to.send(value), "OMS: ISSUE_SENDING_FUNDS");
140     }
141 
142 }
143 
144 abstract contract O_ERC721 is OMS, ERC165, IERC721, IERC721Metadata{ //OrcaniaERC721 Standard
145     using Strings for uint256;
146 
147     string internal uriLink;
148     
149     uint256 internal _totalSupply;
150 
151     string internal _name;
152     string internal _symbol;
153 
154     mapping(uint256 => address) internal _owners;
155     mapping(address => uint256) internal _balances;
156     mapping(uint256 => address) public _tokenApprovals;
157     mapping(address => mapping(address => bool)) public _operatorApprovals;
158 
159     //Read Functions======================================================================================================================================================
160     
161     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
162         return interfaceId == type(IERC721).interfaceId
163             || interfaceId == type(IERC721Metadata).interfaceId
164             || super.supportsInterface(interfaceId);
165     }
166 
167     function balanceOf(address owner) external view override returns (uint256) {
168         require(owner != address(0), "ERC721: balance query for the zero address");
169         return _balances[owner];
170     }
171 
172     function ownerOf(uint256 tokenId) external view override returns (address) {
173         address owner = _owners[tokenId];
174         require(owner != address(0), "ERC721: owner query for nonexistent token");
175         return owner;
176     }
177 
178     function name() public view override returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public view override returns (string memory) {
183         return _symbol;
184     }
185     
186     function totalSupply() public view override returns(uint256){return _totalSupply;}
187 
188     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
189         return string(abi.encodePacked(uriLink, tokenId.toString(), ".json"));
190 
191     }
192 
193     function getApproved(uint256 tokenId) external view override returns (address) {
194         require(_owners[tokenId] != address(0), "ERC721: approved query for nonexistent token");
195 
196         return _tokenApprovals[tokenId];
197     }
198 
199     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
200         return _operatorApprovals[owner][operator];
201     }
202 
203     function tokensOf(address user, uint256 limit) external view returns(uint256[] memory nfts) {
204         nfts = new uint256[](limit);
205         uint256 index;
206 
207         for(uint256 t=1; t <= _totalSupply && index < limit; ++t) {
208             if(_owners[t] == user) {nfts[index++] = t;}
209         }
210     }
211     
212     //Moderator Functions======================================================================================================================================================
213 
214     function changeURIlink(string calldata newUri) external Manager {
215         uriLink = newUri;
216     }
217 
218     function changeData(string calldata name, string calldata symbol) external Manager {
219         _name = name;
220         _symbol = symbol;
221     }
222 
223     function adminMint(address to, uint256 amount) external Manager {
224         _mint(to, amount);
225     }
226 
227     function adminMint(address to) external payable Manager {
228         _mint(to, msg.value);
229     }
230 
231     function adminMint(address[] calldata to, uint256[] calldata amount) external Manager {
232         uint256 size = to.length;
233 
234         for(uint256 t; t < size; ++t) {
235             _mint(to[t], amount[t]);
236         }
237     }
238 
239     //User Functions======================================================================================================================================================
240     function approve(address to, uint256 tokenId) external override {
241         address owner = _owners[tokenId];
242 
243         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
244             "ERC721: approve caller is not owner nor approved for all"
245         );
246 
247         _approve(to, tokenId);
248     }
249 
250     function setApprovalForAll(address operator, bool approved) public override {
251         require(operator != msg.sender, "ERC721: approve to caller");
252 
253         _operatorApprovals[msg.sender][operator] = approved;
254         emit ApprovalForAll(msg.sender, operator, approved);
255     }
256 
257     function transferFrom(address from, address to, uint256 tokenId) external override {
258         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
259 
260         _transfer(from, to, tokenId);
261     }
262 
263     function safeTransferFrom(address from, address to, uint256 tokenId) external override {
264         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
265         _transfer(from, to, tokenId);
266     }
267 
268     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external override {
269         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
270         _safeTransfer(from, to, tokenId, _data);
271     }
272 
273     //Internal Functions======================================================================================================================================================
274     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal {
275         _transfer(from, to, tokenId);
276     }
277 
278     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
279         require(_owners[tokenId] != address(0), "ERC721: operator query for nonexistent token");
280         address owner = _owners[tokenId];
281         require(spender == owner || _tokenApprovals[tokenId] == spender || isApprovedForAll(owner, spender), "ERC721: Not approved or owner");
282         return true;
283     }
284     
285     function _transfer(address from, address to, uint256 tokenId) internal {
286         require(_owners[tokenId] == from, "ERC721: transfer of token that is not own");
287         require(to != address(0), "ERC721: transfer to the zero address");
288 
289         // Clear approvals from the previous owner
290         _approve(address(0), tokenId);
291 
292         _balances[from] -= 1;
293         _balances[to] += 1;
294         _owners[tokenId] = to;
295 
296         emit Transfer(from, to, tokenId);
297     }
298 
299     function _approve(address to, uint256 tokenId) internal {
300         _tokenApprovals[tokenId] = to;
301         emit Approval(_owners[tokenId], to, tokenId);
302     }
303 
304     function _mint(address user, uint256 amount) internal {
305         uint256 tokenID = _totalSupply;
306 
307         _balances[user] += amount;
308         _totalSupply += amount;
309         
310         for(uint256 t; t < amount; ++t) {
311             
312             _owners[++tokenID] = user;
313                 
314             emit Transfer(address(0), user, tokenID);
315         }
316         
317     }
318 
319 }
320 
321 contract TRAF is O_ERC721 {
322 
323     constructor() {
324         _name = "The Red Ape Family";
325         _symbol = "TRAF";
326         uriLink = "https://ipfs.io/ipfs/QmNLozPFC34fZuzKWDb35hbmpUUZg9MBBVjBg8c6aUHc2A/EpisodeData";
327     }
328 
329     mapping(address => uint256) private _holdersMint_Mints;
330     bool private _holdersMint_Active;
331     function holdersMint() external payable{
332         require(_holdersMint_Active, "MINT_OFF");
333         require(_balances[msg.sender] > 0, "NOT_HOLDER");
334         require(msg.value % 250000000000000000 == 0, "WRONG_VALUE");
335 
336         uint256 amount = msg.value / 250000000000000000;
337         require((_holdersMint_Mints[msg.sender] += amount) < 11, "USER_MINT_LIMIT_REACHED"); //Total mints of 10 per wallet
338 
339         _mint(msg.sender, amount);
340 
341         require(_totalSupply < 1778, "MINT_LIMIT_REACHED"); //Max of 1111 NFTs for ep3
342     }
343 
344     mapping(address => uint256) private _wlPartnersMint_Mints;
345     uint256 private _wlPartnersMint_TotalMinted;
346     bool private _wlPartnersMint_Active;
347     function wlPartnersMint() external payable{
348         require(_wlPartnersMint_Active, "MINT_OFF");
349         require(
350             IERC721(0x219B8aB790dECC32444a6600971c7C3718252539).balanceOf(msg.sender) > 0 ||
351             IERC721(0xF1268733C6FB05EF6bE9cF23d24436Dcd6E0B35E).balanceOf(msg.sender) > 0 ||
352             IERC721(0x5DF340b5D1618c543aC81837dA1C2d2B17b3B5d8).balanceOf(msg.sender) > 0 ||
353             IERC721(0x9ee36cD3E78bAdcAF0cBED71c824bD8C5Cb65a8C).balanceOf(msg.sender) > 0 ||
354             IERC721(0x3a4cA1c1bB243D299032753fdd75e8FEc1F0d585).balanceOf(msg.sender) > 0 ||
355             IERC721(0xF3114DD5c5b50a573E66596563D15A630ED359b4).balanceOf(msg.sender) > 0
356         , "NOT_PARTNER_HOLDER");
357 
358         require(msg.value % 350000000000000000 == 0, "WRONG_VALUE");
359 
360         uint256 amount = msg.value / 350000000000000000;
361         require((_wlPartnersMint_Mints[msg.sender] += amount) < 2, "USER_MINT_LIMIT_REACHED"); //Total mints of 1 per wallet
362         require((_wlPartnersMint_TotalMinted += amount) < 889, "MINT_LIMIT_REACHED"); //Total mints of 888 for this mint
363 
364         _mint(msg.sender, amount);
365 
366         require(_totalSupply < 1778, "MINT_LIMIT_REACHED"); //Max of 1111 NFTs for ep3
367     }
368 
369     mapping(address => uint256) private _nonWlPartnersMint_Mints;
370     bool private _nonWlPartnersMint_Active;
371     function nonWlPartnersMint() external payable{
372         require(_nonWlPartnersMint_Active, "MINT_OFF");
373         require(
374             IERC721(0x369156da04B6F313b532F7aE08E661e402B1C2F2).balanceOf(msg.sender) > 0 ||
375             IERC721(0x91cc3844B8271337679F8C00cB2d238886917d40).balanceOf(msg.sender) > 0 ||
376             IERC721(0x21AE791a447c7EeC28c40Bba0B297b00D7D0e8F4).balanceOf(msg.sender) > 0 
377         , "NOT_PARTNER_HOLDER");
378         
379         require(msg.value % 400000000000000000 == 0, "WRONG_VALUE");
380 
381         uint256 amount = msg.value / 400000000000000000;
382         require((_nonWlPartnersMint_Mints[msg.sender] += amount) < 11, "USER_MINT_LIMIT_REACHED"); //Total mints of 10 per wallet
383 
384         _mint(msg.sender, amount);
385 
386         require(_totalSupply < 1778, "MINT_LIMIT_REACHED"); //Max of 1111 NFTs for ep3
387     }
388 
389     function setMints(bool holdersMint_Active, bool wlPartnersMint_Active, bool nonWlPartnersMint_Active) external Manager {
390         _holdersMint_Active = holdersMint_Active;
391         _wlPartnersMint_Active = wlPartnersMint_Active;
392         _nonWlPartnersMint_Active = nonWlPartnersMint_Active;
393     }
394  
395 
396 }