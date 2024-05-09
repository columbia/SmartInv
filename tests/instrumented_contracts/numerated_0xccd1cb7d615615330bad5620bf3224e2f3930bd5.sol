1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /* ERC721I - ERC721I (ERC721 0xInuarashi Edition) - Gas Optimized
5     Open Source: with the efforts of the [0x Collective] <3 */
6 
7 contract ERC721I {
8 
9     string public name; string public symbol;
10     string internal baseTokenURI; string internal baseTokenURI_EXT;
11     constructor(string memory name_, string memory symbol_) {
12         name = name_; symbol = symbol_; 
13     }
14 
15     uint256 public totalSupply; 
16     mapping(uint256 => address) public ownerOf; 
17     mapping(address => uint256) public balanceOf; 
18 
19     mapping(uint256 => address) public getApproved; 
20     mapping(address => mapping(address => bool)) public isApprovedForAll; 
21 
22     // Events
23     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
24     event Mint(address indexed to, uint256 tokenId);
25     event Approval(address indexed owner, address indexed approved, 
26     uint256 indexed tokenId);
27     event ApprovalForAll(address indexed owner, address indexed operator, 
28     bool approved);
29 
30     // // internal write functions
31     // mint
32     function _mint(address to_, uint256 tokenId_) internal virtual {
33         require(to_ != address(0x0), 
34             "ERC721I: _mint() Mint to Zero Address");
35         require(ownerOf[tokenId_] == address(0x0), 
36             "ERC721I: _mint() Token to Mint Already Exists!");
37 
38         balanceOf[to_]++;
39         ownerOf[tokenId_] = to_;
40 
41         emit Transfer(address(0x0), to_, tokenId_);
42     }
43 
44     // transfer
45     function _transfer(address from_, address to_, uint256 tokenId_) internal virtual {
46         require(from_ == ownerOf[tokenId_], 
47             "ERC721I: _transfer() Transfer Not Owner of Token!");
48         require(to_ != address(0x0), 
49             "ERC721I: _transfer() Transfer to Zero Address!");
50 
51         // checks if there is an approved address clears it if there is
52         if (getApproved[tokenId_] != address(0x0)) { 
53             _approve(address(0x0), tokenId_); 
54         } 
55 
56         ownerOf[tokenId_] = to_; 
57         balanceOf[from_]--;
58         balanceOf[to_]++;
59 
60         emit Transfer(from_, to_, tokenId_);
61     }
62 
63     // approve
64     function _approve(address to_, uint256 tokenId_) internal virtual {
65         if (getApproved[tokenId_] != to_) {
66             getApproved[tokenId_] = to_;
67             emit Approval(ownerOf[tokenId_], to_, tokenId_);
68         }
69     }
70     function _setApprovalForAll(address owner_, address operator_, bool approved_)
71     internal virtual {
72         require(owner_ != operator_, 
73             "ERC721I: _setApprovalForAll() Owner must not be the Operator!");
74         isApprovedForAll[owner_][operator_] = approved_;
75         emit ApprovalForAll(owner_, operator_, approved_);
76     }
77 
78     // token uri
79     function _setBaseTokenURI(string memory uri_) internal virtual {
80         baseTokenURI = uri_;
81     }
82     function _setBaseTokenURI_EXT(string memory ext_) internal virtual {
83         baseTokenURI_EXT = ext_;
84     }
85 
86     // // Internal View Functions
87     // Embedded Libraries
88     function _toString(uint256 value_) internal pure returns (string memory) {
89         if (value_ == 0) { return "0"; }
90         uint256 _iterate = value_; uint256 _digits;
91         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
92         bytes memory _buffer = new bytes(_digits);
93         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(
94             48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
95         return string(_buffer); // return string converted bytes of value_
96     }
97 
98     // Functional Views
99     function _isApprovedOrOwner(address spender_, uint256 tokenId_) internal 
100     view virtual returns (bool) {
101         require(ownerOf[tokenId_] != address(0x0), 
102             "ERC721I: _isApprovedOrOwner() Owner is Zero Address!");
103         address _owner = ownerOf[tokenId_];
104         return (spender_ == _owner 
105             || spender_ == getApproved[tokenId_] 
106             || isApprovedForAll[_owner][spender_]);
107     }
108     function _exists(uint256 tokenId_) internal view virtual returns (bool) {
109         return ownerOf[tokenId_] != address(0x0);
110     }
111 
112     // // public write functions
113     function approve(address to_, uint256 tokenId_) public virtual {
114         address _owner = ownerOf[tokenId_];
115         require(to_ != _owner, 
116             "ERC721I: approve() Cannot approve yourself!");
117         require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender],
118             "ERC721I: Caller not owner or Approved!");
119         _approve(to_, tokenId_);
120     }
121     function setApprovalForAll(address operator_, bool approved_) public virtual {
122         _setApprovalForAll(msg.sender, operator_, approved_);
123     }
124     function transferFrom(address from_, address to_, uint256 tokenId_) 
125     public virtual {
126         require(_isApprovedOrOwner(msg.sender, tokenId_), 
127             "ERC721I: transferFrom() _isApprovedOrOwner = false!");
128         _transfer(from_, to_, tokenId_);
129     }
130     function safeTransferFrom(address from_, address to_, uint256 tokenId_, 
131     bytes memory data_) public virtual {
132         transferFrom(from_, to_, tokenId_);
133         if (to_.code.length != 0) {
134             (, bytes memory _returned) = to_.staticcall(abi.encodeWithSelector(
135                 0x150b7a02, msg.sender, from_, tokenId_, data_));
136             bytes4 _selector = abi.decode(_returned, (bytes4));
137             require(_selector == 0x150b7a02, 
138                 "ERC721I: safeTransferFrom() to_ not ERC721Receivable!");
139         }
140     }
141     function safeTransferFrom(address from_, address to_, uint256 tokenId_) 
142     public virtual {
143         safeTransferFrom(from_, to_, tokenId_, "");
144     }
145 
146     // 0xInuarashi Custom Functions
147     function multiTransferFrom(address from_, address to_, uint256[] memory tokenIds_)
148     public virtual {
149         for (uint256 i = 0; i < tokenIds_.length; i++) {
150             transferFrom(from_, to_, tokenIds_[i]);
151         }
152     }
153     function multiSafeTransferFrom(address from_, address to_, 
154     uint256[] memory tokenIds_, bytes memory data_) public virtual {
155         for (uint256 i = 0; i < tokenIds_.length; i++) {
156             safeTransferFrom(from_, to_, tokenIds_[i], data_);
157         }
158     }
159 
160     // OZ Standard Stuff
161     function supportsInterface(bytes4 interfaceId_) public pure returns (bool) {
162         return (interfaceId_ == 0x80ac58cd || interfaceId_ == 0x5b5e139f);
163     }
164 
165     function tokenURI(uint256 tokenId_) public view virtual returns (string memory) {
166         require(ownerOf[tokenId_] != address(0x0), 
167             "ERC721I: tokenURI() Token does not exist!");
168         return string(abi.encodePacked(
169             baseTokenURI, _toString(tokenId_), baseTokenURI_EXT));
170     }
171     // // public view functions
172     // never use these for functions ever, they are expensive af and for view only 
173     function walletOfOwner(address address_) public virtual view 
174     returns (uint256[] memory) {
175         uint256 _balance = balanceOf[address_];
176         uint256[] memory _tokens = new uint256[] (_balance);
177         uint256 _index;
178         uint256 _loopThrough = totalSupply;
179         for (uint256 i = 0; i < _loopThrough; i++) {
180             if (ownerOf[i] == address(0x0) && _tokens[_balance - 1] == 0) {
181                 _loopThrough++; 
182             }
183             if (ownerOf[i] == address_) { 
184                 _tokens[_index] = i; _index++; 
185             }
186         }
187         return _tokens;
188     }
189 
190     // not sure when this will ever be needed but it conforms to erc721 enumerable
191     function tokenOfOwnerByIndex(address address_, uint256 index_) public 
192     virtual view returns (uint256) {
193         uint256[] memory _wallet = walletOfOwner(address_);
194         return _wallet[index_];
195     }
196 }
197 
198 abstract contract Ownable {
199     address public owner;
200     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
201     constructor() { owner = msg.sender; }
202     modifier onlyOwner {
203         require(owner == msg.sender, "Ownable: caller is not the owner");
204         _;
205     }
206     function _transferOwnership(address newOwner_) internal virtual {
207         address _oldOwner = owner;
208         owner = newOwner_;
209         emit OwnershipTransferred(_oldOwner, newOwner_);    
210     }
211     function transferOwnership(address newOwner_) public virtual onlyOwner {
212         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
213         _transferOwnership(newOwner_);
214     }
215     function renounceOwnership() public virtual onlyOwner {
216         _transferOwnership(address(0x0));
217     }
218 }
219 
220 interface IERC721 {
221     function ownerOf(uint256 tokenId_) external view returns (address);
222     function transferfrom(address from_, address to_, uint256 tokenId_) external;
223 }
224 
225 interface iPlasma {
226     function balanceOf(address address_) external view returns (uint256);
227     // function transferFrom(address from_, address to_, uint256 amount_) external;
228     function burnByController(address from_, uint256 amount_) external;
229 }
230 
231 abstract contract PublicMint {
232     // Public Minting
233     bool public _publicMintEnabled; uint256 public _publicMintTime;
234     function _setPublicMint(bool bool_, uint256 time_) internal {
235         _publicMintEnabled = bool_; _publicMintTime = time_; }
236     modifier publicMintEnabled { 
237         require(_publicMintEnabled && _publicMintTime <= block.timestamp, 
238             "Public Mint is not enabled yet!"); _; }
239     function publicMintStatus() external view returns (bool) {
240         return _publicMintEnabled && _publicMintTime <= block.timestamp; }
241 }
242 
243 contract CyborgYetis is ERC721I, Ownable, PublicMint {
244     constructor() ERC721I("Cyborg Yetis", "CYETI") {}
245 
246     // Constraints
247     uint256 public maxTokens = 5555;
248     uint256 public fusionCost = 650 ether;
249     function setMaxTokens(uint256 maxTokens_) external onlyOwner {
250         maxTokens = maxTokens_;
251     }
252     function setFusionCost(uint256 fusionCost_) external onlyOwner {
253         fusionCost = fusionCost_;
254     }
255 
256     // Interfaces
257     IERC721 public SpaceYetis = IERC721(0x33a39af0F83E9D46a055e6eEbde3296D26d916F4);
258     iPlasma public Plasma = iPlasma(0xC3aF7Bb38999e8A1db7849e30706Efbf8FFd57Fa);
259     function setSpaceYetis(address address_) external onlyOwner {
260         SpaceYetis = IERC721(address_);
261     }
262     function setPlasma(address address_) external onlyOwner {
263         Plasma = iPlasma(address_);
264     }
265 
266     // Administration
267     function setBaseTokenURI(string calldata uri_) external onlyOwner { 
268         _setBaseTokenURI(uri_);
269     }
270     function setBaseTokenURI_EXT(string calldata ext_) external onlyOwner {
271         _setBaseTokenURI_EXT(ext_);
272     }
273     function setPublicMint(bool bool_, uint256 time_) external onlyOwner {
274         _setPublicMint(bool_, time_);
275     }
276 
277     // Internal Mint
278     function _mintMany(address to_, uint256 amount_) internal {
279         require(maxTokens >= totalSupply + amount_,
280             "Not enough remaining Cyborg Yetis!");
281 
282         // TokenId Starts at 1
283         uint256 _startId = totalSupply + 1;
284         
285         for (uint256 i = 0; i < amount_; i++) {
286             _mint(to_, _startId + i);
287         }
288         totalSupply += amount_;
289     }
290 
291     // Fusion Mechanism
292     function fusion(uint256 parent1_, uint256 parent2_, uint256 amount_) external publicMintEnabled {
293         require(parent1_ != parent2_,
294             "Parents can't be the same!");
295         require(msg.sender == SpaceYetis.ownerOf(parent1_) 
296             && msg.sender == SpaceYetis.ownerOf(parent2_),
297             "You do not own these Yetis!");
298         
299         uint256 _totalFusionCost = fusionCost * amount_;
300 
301         require(Plasma.balanceOf(msg.sender) >= _totalFusionCost,
302             "You don't have enough $PLASMA!");
303         
304         // Now, msg.sender is owner of both yetis. It is not the same yeti, and they
305         // have enough $PLASMA for the fusion.
306         Plasma.burnByController(msg.sender, _totalFusionCost); // Burn
307         _mintMany(msg.sender, amount_); // Breed
308     }
309 }