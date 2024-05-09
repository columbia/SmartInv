1 // File: TamagoNeko.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /* ERC721I - ERC721I (ERC721 0xInuarashi Edition) - Gas Optimized
7     Open Source: with the efforts of the [0x Collective] <3 */
8 
9 contract ERC721I {
10     string public name; string public symbol;
11     string internal baseTokenURI; string internal baseTokenURI_EXT;
12     constructor(string memory name_, string memory symbol_) {
13         name = name_; symbol = symbol_; 
14     }
15 
16     uint256 public totalSupply; 
17     mapping(uint256 => address) public ownerOf; 
18     mapping(address => uint256) public balanceOf; 
19 
20     mapping(uint256 => address) public getApproved; 
21     mapping(address => mapping(address => bool)) public isApprovedForAll; 
22 
23     // Events
24     event Transfer(address indexed from, address indexed to, 
25     uint256 indexed tokenId);
26     event Approval(address indexed owner, address indexed approved, 
27     uint256 indexed tokenId);
28     event ApprovalForAll(address indexed owner, address indexed operator, 
29     bool approved);
30 
31     // // internal write functions
32     // mint
33     function _mint(address to_, uint256 tokenId_) internal virtual {
34         require(to_ != address(0x0), 
35             "ERC721I: _mint() Mint to Zero Address");
36         require(ownerOf[tokenId_] == address(0x0), 
37             "ERC721I: _mint() Token to Mint Already Exists!");
38 
39         balanceOf[to_]++;
40         ownerOf[tokenId_] = to_;
41 
42         emit Transfer(address(0x0), to_, tokenId_);
43     }
44 
45     // transfer
46     function _transfer(address from_, address to_, uint256 tokenId_) internal virtual {
47         require(from_ == ownerOf[tokenId_], 
48             "ERC721I: _transfer() Transfer Not Owner of Token!");
49         require(to_ != address(0x0), 
50             "ERC721I: _transfer() Transfer to Zero Address!");
51 
52         // checks if there is an approved address clears it if there is
53         if (getApproved[tokenId_] != address(0x0)) { 
54             _approve(address(0x0), tokenId_); 
55         } 
56 
57         ownerOf[tokenId_] = to_; 
58         balanceOf[from_]--;
59         balanceOf[to_]++;
60 
61         emit Transfer(from_, to_, tokenId_);
62     }
63 
64     // approve
65     function _approve(address to_, uint256 tokenId_) internal virtual {
66         if (getApproved[tokenId_] != to_) {
67             getApproved[tokenId_] = to_;
68             emit Approval(ownerOf[tokenId_], to_, tokenId_);
69         }
70     }
71     function _setApprovalForAll(address owner_, address operator_, bool approved_)
72     internal virtual {
73         require(owner_ != operator_, 
74             "ERC721I: _setApprovalForAll() Owner must not be the Operator!");
75         isApprovedForAll[owner_][operator_] = approved_;
76         emit ApprovalForAll(owner_, operator_, approved_);
77     }
78 
79     // token uri
80     function _setBaseTokenURI(string memory uri_) internal virtual {
81         baseTokenURI = uri_;
82     }
83     function _setBaseTokenURI_EXT(string memory ext_) internal virtual {
84         baseTokenURI_EXT = ext_;
85     }
86 
87     // // Internal View Functions
88     // Embedded Libraries
89     function _toString(uint256 value_) internal pure returns (string memory) {
90         if (value_ == 0) { return "0"; }
91         uint256 _iterate = value_; uint256 _digits;
92         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
93         bytes memory _buffer = new bytes(_digits);
94         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(
95             48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
96         return string(_buffer); // return string converted bytes of value_
97     }
98 
99     // Functional Views
100     function _isApprovedOrOwner(address spender_, uint256 tokenId_) internal 
101     view virtual returns (bool) {
102         require(ownerOf[tokenId_] != address(0x0), 
103             "ERC721I: _isApprovedOrOwner() Owner is Zero Address!");
104         address _owner = ownerOf[tokenId_];
105         return (spender_ == _owner 
106             || spender_ == getApproved[tokenId_] 
107             || isApprovedForAll[_owner][spender_]);
108     }
109     function _exists(uint256 tokenId_) internal view virtual returns (bool) {
110         return ownerOf[tokenId_] != address(0x0);
111     }
112 
113     // // public write functions
114     function approve(address to_, uint256 tokenId_) public virtual {
115         address _owner = ownerOf[tokenId_];
116         require(to_ != _owner, 
117             "ERC721I: approve() Cannot approve yourself!");
118         require(msg.sender == _owner || isApprovedForAll[_owner][msg.sender],
119             "ERC721I: Caller not owner or Approved!");
120         _approve(to_, tokenId_);
121     }
122     function setApprovalForAll(address operator_, bool approved_) public virtual {
123         _setApprovalForAll(msg.sender, operator_, approved_);
124     }
125 
126     function transferFrom(address from_, address to_, uint256 tokenId_) 
127     public virtual {
128         require(_isApprovedOrOwner(msg.sender, tokenId_), 
129             "ERC721I: transferFrom() _isApprovedOrOwner = false!");
130         _transfer(from_, to_, tokenId_);
131     }
132     function safeTransferFrom(address from_, address to_, uint256 tokenId_, 
133     bytes memory data_) public virtual {
134         transferFrom(from_, to_, tokenId_);
135         if (to_.code.length != 0) {
136             (, bytes memory _returned) = to_.staticcall(abi.encodeWithSelector(
137                 0x150b7a02, msg.sender, from_, tokenId_, data_));
138             bytes4 _selector = abi.decode(_returned, (bytes4));
139             require(_selector == 0x150b7a02, 
140                 "ERC721I: safeTransferFrom() to_ not ERC721Receivable!");
141         }
142     }
143     function safeTransferFrom(address from_, address to_, uint256 tokenId_) 
144     public virtual {
145         safeTransferFrom(from_, to_, tokenId_, "");
146     }
147 
148     // 0xInuarashi Custom Functions
149     function multiTransferFrom(address from_, address to_, 
150     uint256[] memory tokenIds_) public virtual {
151         for (uint256 i = 0; i < tokenIds_.length; i++) {
152             transferFrom(from_, to_, tokenIds_[i]);
153         }
154     }
155     function multiSafeTransferFrom(address from_, address to_, 
156     uint256[] memory tokenIds_, bytes memory data_) public virtual {
157         for (uint256 i = 0; i < tokenIds_.length; i++) {
158             safeTransferFrom(from_, to_, tokenIds_[i], data_);
159         }
160     }
161 
162     // OZ Standard Stuff
163     function supportsInterface(bytes4 interfaceId_) public pure returns (bool) {
164         return (interfaceId_ == 0x80ac58cd || interfaceId_ == 0x5b5e139f);
165     }
166 
167     function tokenURI(uint256 tokenId_) public view virtual returns (string memory) {
168         require(ownerOf[tokenId_] != address(0x0), 
169             "ERC721I: tokenURI() Token does not exist!");
170         return string(abi.encodePacked(
171             baseTokenURI, _toString(tokenId_), baseTokenURI_EXT));
172     }
173     // // public view functions
174     // never use these for functions ever, they are expensive af and for view only 
175     function walletOfOwner(address address_) public virtual view 
176     returns (uint256[] memory) {
177         uint256 _balance = balanceOf[address_];
178         uint256[] memory _tokens = new uint256[] (_balance);
179         uint256 _index;
180         uint256 _loopThrough = totalSupply;
181         for (uint256 i = 0; i < _loopThrough; i++) {
182             if (ownerOf[i] == address(0x0) && _tokens[_balance - 1] == 0) {
183                 _loopThrough++; 
184             }
185             if (ownerOf[i] == address_) { 
186                 _tokens[_index] = i; _index++; 
187             }
188         }
189         return _tokens;
190     }
191 
192     // not sure when this will ever be needed but it conforms to erc721 enumerable
193     function tokenOfOwnerByIndex(address address_, uint256 index_) public 
194     virtual view returns (uint256) {
195         uint256[] memory _wallet = walletOfOwner(address_);
196         return _wallet[index_];
197     }
198 }
199 
200 // Open0x Ownable (by 0xInuarashi)
201 abstract contract Ownable {
202     address public owner;
203     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
204     constructor() { owner = msg.sender; }
205     modifier onlyOwner {
206         require(owner == msg.sender, "Ownable: caller is not the owner");
207         _;
208     }
209     function _transferOwnership(address newOwner_) internal virtual {
210         address _oldOwner = owner;
211         owner = newOwner_;
212         emit OwnershipTransferred(_oldOwner, newOwner_);    
213     }
214     function transferOwnership(address newOwner_) public virtual onlyOwner {
215         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
216         _transferOwnership(newOwner_);
217     }
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0x0));
220     }
221 }
222 
223 abstract contract PublicMint {
224     // Public Minting
225     bool public _publicMintEnabled;
226     function _setPublicMint(bool bool_) internal {
227         _publicMintEnabled = bool_; 
228     }
229     modifier publicMintEnabled { 
230         require(_publicMintEnabled, "Public Mint is not enabled yet!"); 
231         _; 
232     }
233     function publicMintStatus() external view returns (bool) {
234         return _publicMintEnabled; 
235     }
236 }
237 
238 abstract contract Security {
239     // Prevent Smart Contracts
240     modifier onlySender {
241         require(msg.sender == tx.origin, "No Smart Contracts!"); _; }
242 }
243 
244 contract TamagoNeko is ERC721I, Ownable, PublicMint, Security {
245     // Constructor
246     constructor(string memory baseTokenURI) payable ERC721I("Tamago Neko", "NEKO") {
247         _setBaseTokenURI(baseTokenURI);
248         _setBaseTokenURI_EXT(".json");
249         _mintMany(msg.sender, 1);
250     }
251 
252     // Project Constraints
253     uint256 public mintPrice = 0.004 ether;
254     uint256 public freeSupply = 300;
255     uint256 public maxSupply = 748;
256 
257     // Public Limits
258     // maxMintsPerPublic also serves as max NFTs per wallet
259     uint256 public maxFreeMintPerWallet = 2;
260     uint256 public maxMintsPerPublic = 15;
261     mapping(address => uint256) public addressToPublicMints;
262     mapping(address => uint256) private mintedFreeAmount;
263 
264     // Public Mint
265     function publicMint(uint256 amount_) external payable
266     onlySender publicMintEnabled {
267         uint256 cost = mintPrice;
268         
269         bool isFree = ((totalSupply + amount_ < freeSupply + 1) &&
270             (mintedFreeAmount[msg.sender] + amount_ <= maxFreeMintPerWallet));
271 
272         if (isFree) {
273             cost = 0;
274         }
275 
276         require(maxMintsPerPublic >= addressToPublicMints[msg.sender] + amount_,
277             "Exceeds the max amount per TX!");
278         require(msg.value == cost * amount_, 
279             "Invalid value sent!");
280 
281         if (isFree) {
282             mintedFreeAmount[msg.sender] += amount_;
283         }
284 
285         // Add address to Public Mints
286         addressToPublicMints[msg.sender] += amount_;
287         
288         // Now, mint to msg.sender
289         _mintMany(msg.sender, amount_);
290     }
291 
292     // Administrative Functions
293     function setMintPrice(uint256 mintPrice_) external onlyOwner {
294         mintPrice = mintPrice_;
295     }
296     function setMaxSupply(uint256 maxSupply_) external onlyOwner {
297         maxSupply = maxSupply_;
298     }
299     
300     // Public Mint Limits
301     function setMaxMintsPerPublic(uint256 maxMintsPerPublic_) external onlyOwner {
302         maxMintsPerPublic = maxMintsPerPublic_;
303     }
304 
305     function setfreeSupply(uint256 freeSupply_) external onlyOwner {
306         freeSupply = freeSupply_;
307     }
308 
309     // Token URI
310     function setBaseTokenURI(string calldata uri_) external onlyOwner {
311         _setBaseTokenURI(uri_);
312     }
313     function setBaseTokenURI_EXT(string calldata ext_) external onlyOwner {
314         _setBaseTokenURI_EXT(ext_);
315     }
316 
317     // Public Mint
318     function setPublicMint(bool bool_) external onlyOwner {
319         _setPublicMint(bool_);
320     }
321 
322     // Internal Functions
323     function _mintMany(address to_, uint256 amount_) internal {
324         require(maxSupply >= totalSupply + amount_,
325             "Not enough NFTs remaining!");
326         
327         uint256 _startId = totalSupply + 1; // iterate from 1
328 
329         for (uint256 i = 0; i < amount_; i++) {
330             _mint(to_, _startId + i);
331         }
332 
333         totalSupply += amount_;
334     }
335 
336     function withdraw() external onlyOwner {
337         (bool success, ) = payable(msg.sender).call{
338             value: address(this).balance
339         }("");
340         require(success, "Transfer failed.");
341     }
342 }