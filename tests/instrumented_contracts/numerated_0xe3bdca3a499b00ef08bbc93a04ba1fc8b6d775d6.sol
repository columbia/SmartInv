1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 contract ERC721I {
5 
6     string public name; string public symbol;
7     string internal baseTokenURI; string internal baseTokenURI_EXT;
8     constructor(string memory name_, string memory symbol_) { name = name_; symbol = symbol_; }
9 
10     uint256 public totalSupply; 
11     mapping(uint256 => address) public ownerOf; 
12     mapping(address => uint256) public balanceOf; 
13 
14     mapping(uint256 => address) public getApproved; 
15     mapping(address => mapping(address => bool)) public isApprovedForAll; 
16 
17     // Events
18     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
19     event Mint(address indexed to, uint256 tokenId);
20     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
21     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
22 
23     // // internal write functions
24     // mint
25     function _mint(address to_, uint256 tokenId_) internal virtual {
26         require(to_ != address(0x0), "ERC721I: _mint() Mint to Zero Address");
27         require(ownerOf[tokenId_] == address(0x0), "ERC721I: _mint() Token to Mint Already Exists!");
28 
29         // ERC721I Starts Here
30         ownerOf[tokenId_] = to_;
31         balanceOf[to_]++;
32         totalSupply++; 
33         // ERC721I Ends Here
34 
35         emit Transfer(address(0x0), to_, tokenId_);
36         emit Mint(to_, tokenId_);
37     }
38 
39     // transfer
40     function _transfer(address from_, address to_, uint256 tokenId_) internal virtual {
41         require(from_ == ownerOf[tokenId_], "ERC721I: _transfer() Transfer Not Owner of Token!");
42         require(to_ != address(0x0), "ERC721I: _transfer() Transfer to Zero Address!");
43 
44         // ERC721I Starts Here
45         // checks if there is an approved address clears it if there is
46         if (getApproved[tokenId_] != address(0x0)) { 
47             _approve(address(0x0), tokenId_); 
48         } 
49 
50         ownerOf[tokenId_] = to_; 
51         balanceOf[from_]--;
52         balanceOf[to_]++;
53         // ERC721I Ends Here
54 
55         emit Transfer(from_, to_, tokenId_);
56     }
57 
58     // approve
59     function _approve(address to_, uint256 tokenId_) internal virtual {
60         if (getApproved[tokenId_] != to_) {
61             getApproved[tokenId_] = to_;
62             emit Approval(ownerOf[tokenId_], to_, tokenId_);
63         }
64     }
65     function _setApprovalForAll(address owner_, address operator_, bool approved_) internal virtual {
66         require(owner_ != operator_, "ERC721I: _setApprovalForAll() Owner must not be the Operator!");
67         isApprovedForAll[owner_][operator_] = approved_;
68         emit ApprovalForAll(owner_, operator_, approved_);
69     }
70 
71     // token uri
72     function _setBaseTokenURI(string memory uri_) internal virtual {
73         baseTokenURI = uri_;
74     }
75     function _setBaseTokenURI_EXT(string memory ext_) internal virtual {
76         baseTokenURI_EXT = ext_;
77     }
78 
79     // // Internal View Functions
80     // Embedded Libraries
81     function _toString(uint256 value_) internal pure returns (string memory) {
82         if (value_ == 0) { return "0"; }
83         uint256 _iterate = value_; uint256 _digits;
84         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
85         bytes memory _buffer = new bytes(_digits);
86         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
87         return string(_buffer); // return string converted bytes of value_
88     }
89 
90     // Functional Views
91     function _isApprovedOrOwner(address spender_, uint256 tokenId_) internal view virtual returns (bool) {
92         require(ownerOf[tokenId_] != address(0x0), "ERC721I: _isApprovedOrOwner() Owner is Zero Address!");
93         address _owner = ownerOf[tokenId_];
94         return (spender_ == _owner || spender_ == getApproved[tokenId_] || isApprovedForAll[_owner][spender_]);
95     }
96     function _exists(uint256 tokenId_) internal view virtual returns (bool) {
97         return ownerOf[tokenId_] != address(0x0);
98     }
99 
100     // // public write functions
101     function approve(address to_, uint256 tokenId_) public virtual {
102         address _owner = ownerOf[tokenId_];
103         require(to_ != _owner, "ERC721I: approve() Cannot approve yourself!");
104         require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender], "ERC721I: Caller not owner or Approved!");
105         _approve(to_, tokenId_);
106     }
107     function setApprovalForAll(address operator_, bool approved_) public virtual {
108         _setApprovalForAll(msg.sender, operator_, approved_);
109     }
110     function transferFrom(address from_, address to_, uint256 tokenId_) public virtual {
111         require(_isApprovedOrOwner(msg.sender, tokenId_), "ERC721I: transferFrom() _isApprovedOrOwner = false!");
112         _transfer(from_, to_, tokenId_);
113     }
114     function safeTransferFrom(address from_, address to_, uint256 tokenId_, bytes memory data_) public virtual {
115         transferFrom(from_, to_, tokenId_);
116         if (to_.code.length != 0) {
117             (, bytes memory _returned) = to_.staticcall(abi.encodeWithSelector(0x150b7a02, msg.sender, from_, tokenId_, data_));
118             bytes4 _selector = abi.decode(_returned, (bytes4));
119             require(_selector == 0x150b7a02, "ERC721I: safeTransferFrom() to_ not ERC721Receivable!");
120         }
121     }
122     function safeTransferFrom(address from_, address to_, uint256 tokenId_) public virtual {
123         safeTransferFrom(from_, to_, tokenId_, "");
124     }
125 
126     // 0xInuarashi Custom Functions
127     function multiTransferFrom(address from_, address to_, uint256[] memory tokenIds_) public virtual {
128         for (uint256 i = 0; i < tokenIds_.length; i++) {
129             transferFrom(from_, to_, tokenIds_[i]);
130         }
131     }
132     function multiSafeTransferFrom(address from_, address to_, uint256[] memory tokenIds_, bytes memory data_) public virtual {
133         for (uint256 i = 0; i < tokenIds_.length; i++) {
134             safeTransferFrom(from_, to_, tokenIds_[i], data_);
135         }
136     }
137 
138     // OZ Standard Stuff
139     function supportsInterface(bytes4 interfaceId_) public pure returns (bool) {
140         return (interfaceId_ == 0x80ac58cd || interfaceId_ == 0x5b5e139f);
141     }
142 
143     function tokenURI(uint256 tokenId_) public view virtual returns (string memory) {
144         require(ownerOf[tokenId_] != address(0x0), "ERC721I: tokenURI() Token does not exist!");
145         return string(abi.encodePacked(baseTokenURI, _toString(tokenId_), baseTokenURI_EXT));
146     }
147     // // public view functions
148     // never use these for functions ever, they are expensive af and for view only (this will be an issue in the future for interfaces)
149     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
150         uint256 _balance = balanceOf[address_];
151         uint256[] memory _tokens = new uint256[] (_balance);
152         uint256 _index;
153         uint256 _loopThrough = totalSupply;
154         for (uint256 i = 0; i < _loopThrough; i++) {
155             if (ownerOf[i] == address(0x0) && _tokens[_balance - 1] == 0) { _loopThrough++; }
156             if (ownerOf[i] == address_) { _tokens[_index] = i; _index++; }
157         }
158         return _tokens;
159     }
160 }
161 
162 abstract contract Ownable {
163     address public owner;
164     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
165     constructor() { owner = msg.sender; }
166     modifier onlyOwner {
167         require(owner == msg.sender, "Ownable: caller is not the owner");
168         _;
169     }
170     function _transferOwnership(address newOwner_) internal virtual {
171         address _oldOwner = owner;
172         owner = newOwner_;
173         emit OwnershipTransferred(_oldOwner, newOwner_);    
174     }
175     function transferOwnership(address newOwner_) public virtual onlyOwner {
176         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
177         _transferOwnership(newOwner_);
178     }
179     function renounceOwnership() public virtual onlyOwner {
180         _transferOwnership(address(0x0));
181     }
182 }
183 
184 contract VoxxtPrimal is ERC721I, Ownable {
185     constructor() payable ERC721I("Voxxt Primal","VP") {}
186     
187     // Project Settings
188     uint256 public mintPrice = 0.08 ether;
189     uint256 public maxTokens = 10000;
190     
191     // Whitelist Stuff
192     uint256 public whitelistAmount = 1200; // 1200 (1000 + 200) >> (1200 - 276) = 924
193     uint256 public mintsPerWhitelist = 4; // 4 mints per whitelist
194     mapping(address => uint256) public addressToWhitelistMinted;
195     mapping(address => bool) public isWhitelisted;
196 
197     bool public whitelistMintEnabled = false; // default false
198     uint256 public whitelistMintStartTime = 1641726000; // Sun Jan 09 2022 11:00:00 GMT+0000
199 
200     // Public Mint Stuff
201     uint256 public maxMintsPerTx = 10; // 10 mints per tx
202 
203     bool public publicMintEnabled = false; // default false
204     uint256 public publicMintStartTime; // default unset
205 
206     // Modifiers
207     modifier onlySender {
208         require(msg.sender == tx.origin, 
209             "No smart contracts!");
210         _;
211     }
212     modifier whitelistMinting {
213         require(whitelistMintEnabled && block.timestamp >= whitelistMintStartTime,
214             "Whitelist Mints are not enabled yet!");
215         _;
216     }
217     modifier publicMinting {
218         require(publicMintEnabled && block.timestamp >= publicMintStartTime,
219             "Public Mints are not enabled yet!");
220         _;
221     }
222 
223     // Owner Administration
224     function setMintPrice(uint256 mintPrice_) external onlyOwner {
225         mintPrice = mintPrice_;
226     }
227     function setMaxTokens(uint256 maxTokens_) external onlyOwner {
228         require(maxTokens_ >= totalSupply, 
229             "maxTokens cannot be set lower than totalSupply!");
230 
231         maxTokens = maxTokens_;
232     }
233     function setWhitelistAmount(uint256 whitelistAmount_) external onlyOwner {
234         whitelistAmount = whitelistAmount_;
235     }
236     function setMintsPerWhitelist(uint256 mintsPerWhitelist_) external onlyOwner {
237         mintsPerWhitelist = mintsPerWhitelist_;
238     }
239     function setMaxMintsPerTx(uint256 maxMintsPerTx_) external onlyOwner {
240         maxMintsPerTx = maxMintsPerTx_;
241     }
242     function setWhitelists(address[] calldata addresses_, bool bool_) external onlyOwner {
243         for (uint256 i = 0; i < addresses_.length; i++) {
244             isWhitelisted[addresses_[i]] = bool_;
245         }
246     }
247     function setWhitelistParams(bool whitelistMintEnabled_, uint256 whitelistMintStartTime_) external onlyOwner {
248         whitelistMintEnabled = whitelistMintEnabled_;
249         whitelistMintStartTime = whitelistMintStartTime_;
250     }
251     function setPublicMintParams(bool publicMintEnabled_, uint256 publicMintStartTime_) external onlyOwner {
252         publicMintEnabled = publicMintEnabled_;
253         publicMintStartTime = publicMintStartTime_;
254     }
255     function setBaseTokenURI(string memory uri_) external onlyOwner {
256         _setBaseTokenURI(uri_);
257     }
258     function setBaseTokenURI_EXT(string memory ext_) external onlyOwner {
259         _setBaseTokenURI_EXT(ext_);
260     }
261 
262     // Internal Mint 
263     function _mintMany(address to_, uint256 amount_) internal {
264         require(maxTokens >= totalSupply + amount_,
265             "Not enough tokens remaining!");
266 
267         uint256 _startId = totalSupply + 1; // iterate from 1
268         
269         for (uint256 i = 0; i < amount_; i++) {
270             _mint(to_, _startId + i);
271         }
272     }
273 
274     // Owner Mint Functions
275     function ownerMint(address to_, uint256 amount_) external onlyOwner {
276         _mintMany(to_, amount_);
277     }
278     function ownerMintToMany(address[] calldata tos_, uint256[] calldata amounts_) external onlyOwner {
279         require(tos_.length == amounts_.length, 
280             "Array lengths mismatch!");
281             
282         for (uint256 i = 0; i < tos_.length; i++) {
283             _mintMany(tos_[i], amounts_[i]);
284         }
285     }
286 
287     // Whitelist Mint Functions
288     function whitelistMint(uint256 amount_) external payable onlySender whitelistMinting {
289         require(isWhitelisted[msg.sender], 
290             "You are not whitelisted!");
291         require(mintsPerWhitelist >= amount_,
292             "Amount exceeds max mints per whitelist!");
293         require(mintsPerWhitelist >= addressToWhitelistMinted[msg.sender] + amount_,
294             "You don't have enough whitelist mints remaining!");
295         require(msg.value == amount_ * mintPrice, 
296             "Invalid amount sent!");
297         require(whitelistAmount >= totalSupply + amount_,
298             "Not enough whitelist mints remaining!");
299         
300         addressToWhitelistMinted[msg.sender] += amount_;
301 
302         _mintMany(msg.sender, amount_);
303     }
304 
305     // Public Mint Functions
306     function publicMint(uint256 amount_) external payable onlySender publicMinting {
307         require(maxMintsPerTx >= amount_, 
308             "Amount exceeds max mints per tx!");
309         require(msg.value == amount_ * mintPrice, 
310             "Invalid amount sent!");
311         require(maxTokens >= totalSupply + amount_,
312             "Not enough tokens remaining!");
313         
314         _mintMany(msg.sender, amount_);
315     }
316 
317     // Withdraw Funds
318     function _sendETH(address payable address_, uint256 amount_) internal {
319         (bool success, ) = payable(address_).call{value: amount_}("");
320         require(success, "Transfer failed");
321     }
322     function withdraw() external onlyOwner {
323         uint256 _balance = address(this).balance;
324         uint256 _toShare1 = (_balance * 5) / 100;
325         uint256 _toShare2 = _balance - _toShare1;
326 
327         _sendETH( payable(0x2D3C70A7b4d9C8Cba7D6f78F8B707256eE40A3c0), _toShare1);
328         _sendETH( payable(msg.sender), _toShare2);
329     }
330 
331     // Emergency Withdraw (if all fails!)
332     mapping(address => bool) public shareSigned;
333     function signShare() external {
334         require(msg.sender == owner 
335             || msg.sender == 0x2D3C70A7b4d9C8Cba7D6f78F8B707256eE40A3c0,
336             "You cannot sign!");
337         
338         shareSigned[msg.sender] = true;
339     }
340     function emergencyWithdraw() external onlyOwner {
341         require(shareSigned[msg.sender] 
342             && shareSigned[0x2D3C70A7b4d9C8Cba7D6f78F8B707256eE40A3c0],
343             "Both parties have not agreed to unlock this function!"); // both parties must sign
344 
345         _sendETH( payable(msg.sender), address(this).balance); // send contract eth to msg.sender
346     }
347 }