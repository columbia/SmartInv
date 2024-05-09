1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5 1. Cost 50 $AURA per mint
6 2. Dont need to hold ascended
7 3. Yes is random
8 4. No yield from VX
9 */
10 
11 /* ERC721I - ERC721I (ERC721 0xInuarashi Edition) - Gas Optimized
12     Open Source: with the efforts of the [0x Collective] <3 */
13 
14 contract ERC721I {
15 
16     string public name; string public symbol;
17     string internal baseTokenURI; string internal baseTokenURI_EXT;
18     constructor(string memory name_, string memory symbol_) {
19         name = name_; symbol = symbol_; 
20     }
21 
22     uint256 public totalSupply; 
23     mapping(uint256 => address) public ownerOf; 
24     mapping(address => uint256) public balanceOf; 
25 
26     mapping(uint256 => address) public getApproved; 
27     mapping(address => mapping(address => bool)) public isApprovedForAll; 
28 
29     // Events
30     event Transfer(address indexed from, address indexed to, 
31     uint256 indexed tokenId);
32     event Approval(address indexed owner, address indexed approved, 
33     uint256 indexed tokenId);
34     event ApprovalForAll(address indexed owner, address indexed operator, 
35     bool approved);
36 
37     // // internal write functions
38     // mint
39     function _mint(address to_, uint256 tokenId_) internal virtual {
40         require(to_ != address(0x0), 
41             "ERC721I: _mint() Mint to Zero Address");
42         require(ownerOf[tokenId_] == address(0x0), 
43             "ERC721I: _mint() Token to Mint Already Exists!");
44 
45         balanceOf[to_]++;
46         ownerOf[tokenId_] = to_;
47 
48         emit Transfer(address(0x0), to_, tokenId_);
49     }
50 
51     // transfer
52     function _transfer(address from_, address to_, uint256 tokenId_) internal virtual {
53         require(from_ == ownerOf[tokenId_], 
54             "ERC721I: _transfer() Transfer Not Owner of Token!");
55         require(to_ != address(0x0), 
56             "ERC721I: _transfer() Transfer to Zero Address!");
57 
58         // checks if there is an approved address clears it if there is
59         if (getApproved[tokenId_] != address(0x0)) { 
60             _approve(address(0x0), tokenId_); 
61         } 
62 
63         ownerOf[tokenId_] = to_; 
64         balanceOf[from_]--;
65         balanceOf[to_]++;
66 
67         emit Transfer(from_, to_, tokenId_);
68     }
69 
70     // approve
71     function _approve(address to_, uint256 tokenId_) internal virtual {
72         if (getApproved[tokenId_] != to_) {
73             getApproved[tokenId_] = to_;
74             emit Approval(ownerOf[tokenId_], to_, tokenId_);
75         }
76     }
77     function _setApprovalForAll(address owner_, address operator_, bool approved_)
78     internal virtual {
79         require(owner_ != operator_, 
80             "ERC721I: _setApprovalForAll() Owner must not be the Operator!");
81         isApprovedForAll[owner_][operator_] = approved_;
82         emit ApprovalForAll(owner_, operator_, approved_);
83     }
84 
85     // token uri
86     function _setBaseTokenURI(string memory uri_) internal virtual {
87         baseTokenURI = uri_;
88     }
89     function _setBaseTokenURI_EXT(string memory ext_) internal virtual {
90         baseTokenURI_EXT = ext_;
91     }
92 
93     // // Internal View Functions
94     // Embedded Libraries
95     function _toString(uint256 value_) internal pure returns (string memory) {
96         if (value_ == 0) { return "0"; }
97         uint256 _iterate = value_; uint256 _digits;
98         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
99         bytes memory _buffer = new bytes(_digits);
100         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(
101             48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
102         return string(_buffer); // return string converted bytes of value_
103     }
104 
105     // Functional Views
106     function _isApprovedOrOwner(address spender_, uint256 tokenId_) internal 
107     view virtual returns (bool) {
108         require(ownerOf[tokenId_] != address(0x0), 
109             "ERC721I: _isApprovedOrOwner() Owner is Zero Address!");
110         address _owner = ownerOf[tokenId_];
111         return (spender_ == _owner 
112             || spender_ == getApproved[tokenId_] 
113             || isApprovedForAll[_owner][spender_]);
114     }
115     function _exists(uint256 tokenId_) internal view virtual returns (bool) {
116         return ownerOf[tokenId_] != address(0x0);
117     }
118 
119     // // public write functions
120     function approve(address to_, uint256 tokenId_) public virtual {
121         address _owner = ownerOf[tokenId_];
122         require(to_ != _owner, 
123             "ERC721I: approve() Cannot approve yourself!");
124         require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender],
125             "ERC721I: Caller not owner or Approved!");
126         _approve(to_, tokenId_);
127     }
128     function setApprovalForAll(address operator_, bool approved_) public virtual {
129         _setApprovalForAll(msg.sender, operator_, approved_);
130     }
131 
132     function transferFrom(address from_, address to_, uint256 tokenId_) 
133     public virtual {
134         require(_isApprovedOrOwner(msg.sender, tokenId_), 
135             "ERC721I: transferFrom() _isApprovedOrOwner = false!");
136         _transfer(from_, to_, tokenId_);
137     }
138     function safeTransferFrom(address from_, address to_, uint256 tokenId_, 
139     bytes memory data_) public virtual {
140         transferFrom(from_, to_, tokenId_);
141         if (to_.code.length != 0) {
142             (, bytes memory _returned) = to_.staticcall(abi.encodeWithSelector(
143                 0x150b7a02, msg.sender, from_, tokenId_, data_));
144             bytes4 _selector = abi.decode(_returned, (bytes4));
145             require(_selector == 0x150b7a02, 
146                 "ERC721I: safeTransferFrom() to_ not ERC721Receivable!");
147         }
148     }
149     function safeTransferFrom(address from_, address to_, uint256 tokenId_) 
150     public virtual {
151         safeTransferFrom(from_, to_, tokenId_, "");
152     }
153 
154     // 0xInuarashi Custom Functions
155     function multiTransferFrom(address from_, address to_, 
156     uint256[] memory tokenIds_) public virtual {
157         for (uint256 i = 0; i < tokenIds_.length; i++) {
158             transferFrom(from_, to_, tokenIds_[i]);
159         }
160     }
161     function multiSafeTransferFrom(address from_, address to_, 
162     uint256[] memory tokenIds_, bytes memory data_) public virtual {
163         for (uint256 i = 0; i < tokenIds_.length; i++) {
164             safeTransferFrom(from_, to_, tokenIds_[i], data_);
165         }
166     }
167 
168     // OZ Standard Stuff
169     function supportsInterface(bytes4 interfaceId_) public pure returns (bool) {
170         return (interfaceId_ == 0x80ac58cd || interfaceId_ == 0x5b5e139f);
171     }
172 
173     function tokenURI(uint256 tokenId_) public view virtual returns (string memory) {
174         require(ownerOf[tokenId_] != address(0x0), 
175             "ERC721I: tokenURI() Token does not exist!");
176         return string(abi.encodePacked(
177             baseTokenURI, _toString(tokenId_), baseTokenURI_EXT));
178     }
179     // // public view functions
180     // never use these for functions ever, they are expensive af and for view only 
181     function walletOfOwner(address address_) public virtual view 
182     returns (uint256[] memory) {
183         uint256 _balance = balanceOf[address_];
184         uint256[] memory _tokens = new uint256[] (_balance);
185         uint256 _index;
186         uint256 _loopThrough = totalSupply;
187         for (uint256 i = 0; i < _loopThrough; i++) {
188             if (ownerOf[i] == address(0x0) && _tokens[_balance - 1] == 0) {
189                 _loopThrough++; 
190             }
191             if (ownerOf[i] == address_) { 
192                 _tokens[_index] = i; _index++; 
193             }
194         }
195         return _tokens;
196     }
197 
198     // not sure when this will ever be needed but it conforms to erc721 enumerable
199     function tokenOfOwnerByIndex(address address_, uint256 index_) public 
200     virtual view returns (uint256) {
201         uint256[] memory _wallet = walletOfOwner(address_);
202         return _wallet[index_];
203     }
204 }
205 
206 abstract contract Ownable {
207     address public owner; 
208     constructor() { owner = msg.sender; }
209     modifier onlyOwner { require(owner == msg.sender, "Not Owner!"); _; }
210     function transferOwnership(address new_) external onlyOwner { owner = new_; }
211 }
212 
213 interface iERC20 {
214     function balanceOf(address wallet_) external view returns (uint256);
215     function transferFrom(address from_, address to_, uint256 amount_) external;
216 }
217 
218 contract AscendedVX is ERC721I, Ownable {
219     constructor() ERC721I("Ascended VX","AscendedVX") {}
220 
221     ///// Interfaces /////
222     iERC20 public AURA = iERC20(0xBE6a20DAd94b377Af1EfaA229ed0E0B91eb54ac5);
223     function setAURA(address aura_) external onlyOwner { AURA = iERC20(aura_); }
224 
225     ///// Project Constraints /////
226     uint256 public maxTokens = 8888; 
227 
228     ///// Costs /////
229     uint256 public auraToMint = 50 ether;
230     function setAuraToMint(uint256 cost_) external onlyOwner { auraToMint = cost_; }
231     address public auraReceiver = 0x000000000000000000000000000000000000dEaD;
232     function setAuraReceiver(address receiver_) external onlyOwner { 
233         auraReceiver = receiver_; }
234 
235     ///// Ownable Administration //////
236     function setBaseTokenURI(string calldata uri_) external onlyOwner { 
237         _setBaseTokenURI(uri_);
238     }
239     function setBaseTokenURI_EXT(string calldata ext_) external onlyOwner {
240         _setBaseTokenURI_EXT(ext_);
241     }
242 
243     ///// Pausable Administration (Ownable) /////
244     bool public vxMintingPaused; 
245     modifier onlyMinting { require(!vxMintingPaused, "VX Minting is Paused!"); _; }
246     function setMintingPaused(bool bool_) external onlyOwner {
247         vxMintingPaused = bool_; 
248     }
249 
250     ///// Internal Functions /////
251     function _mintMany(address to_, uint256 amount_) internal {
252         require(maxTokens >= totalSupply + amount_,
253             "Not enough supply remaining!");
254 
255         // TokenId starts at 1
256         uint256 _startId = totalSupply + 1;
257 
258         for (uint256 i = 0; i < amount_; i++) {
259             _mint(to_, _startId + i);
260         }
261         totalSupply += amount_;
262     }
263 
264     ///// Owner Mint Functions /////
265     function ownerMint(address[] calldata tos_, uint256[] calldata amounts_) 
266     external onlyOwner {
267         require(tos_.length == amounts_.length,
268             "Array Length Mismatch!");
269         
270         for (uint256 i = 0; i < tos_.length; i++) {
271             _mintMany(tos_[i], amounts_[i]);
272         }
273     }
274 
275     ///// Aura Mint Functions /////
276     function mint(uint256 amount_) external onlyMinting {
277         // Maximum amount_ per mint is 20. Hardcode to save 2100 SLOAD gas
278         require(amount_ <= 20,
279             "You can only mint 20 per tx!");
280 
281         // calculate the total AURA cost
282         uint256 _totalAuraCost = auraToMint * amount_;
283 
284         // msg.sender requires to have >= AURA than cost
285         require(AURA.balanceOf(msg.sender) >= _totalAuraCost,
286             "You don't have enough $AURA!");
287 
288         // transfer it to receiver address
289         AURA.transferFrom(msg.sender, auraReceiver, _totalAuraCost);
290 
291         // after that, mint the amount to the msg.sender
292         _mintMany(msg.sender, amount_);
293     }
294 }