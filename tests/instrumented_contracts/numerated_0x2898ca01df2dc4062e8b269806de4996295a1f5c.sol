1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC721 {
5     
6     function totalSupply() public constant returns (uint256 total);
7     function balanceOf(address _owner) public constant returns (uint256 balance);
8     function ownerOf(uint256 _tokenId) external constant returns (address owner);
9     function approve(address _to, uint256 _tokenId) external;
10     function transfer(address _to, uint256 _tokenId) external;
11     function transferFrom(address _from, address _to, uint256 _tokenId) external;
12 
13     // Events
14     event Transfer(address from, address to, uint256 tokenId);
15     event Approval(address owner, address approved, uint256 tokenId);
16 
17     // Optional
18     // function name() public view returns (string name);
19     // function symbol() public view returns (string symbol);
20     function tokensOfOwner(address _owner) external constant returns (uint256[] tokenIds);
21     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
22 
23     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
24     // function supportsInterface(bytes4 _interfaceID) external constant returns (bool);
25 }
26 
27 
28 contract BlockBase{
29     event Transfer(address from, address to, uint256 tokenId);
30     event Birth(address owner, uint256 blockId, uint256 width,  uint256 height, string position, uint16 genes);
31 
32     struct Block { 
33         uint256 width;
34         uint256 heigth;
35         string position;
36         uint16 generation;
37     }
38     
39     Block[] blocks;
40     mapping (uint256 => address) public blockIndexToOwner;
41     mapping (address => uint256) public ownershipTokenCount;
42     mapping (uint256 => address) public blockIndexToApproved;
43     SaleAuction public saleAuction;
44     function _transfer(address _from, address _to, uint256 _tokenId) internal {
45         ownershipTokenCount[_to]++;
46         blockIndexToOwner[_tokenId] = _to;
47         if (_from != address(0)) {
48             ownershipTokenCount[_from]--;
49         }
50         Transfer(_from, _to, _tokenId);
51     }
52     
53     function transferBlock(address oldAdd, address newAdd, uint256 newBlockId) internal {
54         _transfer(oldAdd, newAdd, newBlockId);
55     }
56 
57 
58     function _createBlock(uint256 _width, uint256 _heigth, uint256 _generation, string _position, address _owner) internal returns (uint)
59     {
60         require(_generation == uint256(uint16(_generation)));
61         Block memory _block = Block({
62             width: _width,
63             heigth: _heigth,
64             position: _position,
65             generation: uint16(_generation)
66         });
67         uint256 newBlockId = blocks.push(_block) - 1;
68         Birth(
69             _owner,
70             newBlockId,
71             _width,
72             _heigth,
73             _block.position,
74             uint16(_generation)
75         );
76         _transfer(0, _owner, newBlockId);
77         return newBlockId;
78     }
79 
80 }
81 
82 contract AuctionBase {
83 
84     struct Auction {
85         address seller;
86         uint256 sellPrice;
87     }
88 
89     
90     ERC721 public nonFungibleContract;
91 
92     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
93     // Values 0-10,000 map to 0%-100%
94     uint256 public ownerCut;
95 
96     // Map from token ID to their corresponding auction.
97     mapping (uint256 => Auction) tokenIdToAuction;
98 
99     event AuctionCreated(uint256 tokenId, uint256 startingPrice);
100     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
101     event AuctionCancelled(uint256 tokenId);
102 
103     function _owns(address _claimant, uint256 _tokenId) internal constant returns (bool) {
104         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
105     }
106 
107     function _escrow(address _owner, uint256 _tokenId) internal {
108         // it will throw if transfer fails
109         nonFungibleContract.transferFrom(_owner, this, _tokenId);
110     }
111 
112     /// @dev Transfers an NFT owned by this contract to another address.
113     /// Returns true if the transfer succeeds.
114     /// @param _receiver - Address to transfer NFT to.
115     /// @param _tokenId - ID of token to transfer.
116     function _transfer(address _receiver, uint256 _tokenId) internal {
117         // it will throw if transfer fails
118         nonFungibleContract.transfer(_receiver, _tokenId);
119     }
120 
121     function _addAuction(uint256 _tokenId, Auction _auction) internal {
122         tokenIdToAuction[_tokenId] = _auction;
123         AuctionCreated(
124             uint256(_tokenId),
125             uint256(_auction.sellPrice)
126         );
127     }
128 
129     /// @dev Cancels an auction unconditionally.
130     function _cancelAuction(uint256 _tokenId, address _seller) internal {
131         _removeAuction(_tokenId);
132         //_transfer(_seller, _tokenId);
133         AuctionCancelled(_tokenId);
134     }
135 
136     /// @dev Computes the price and transfers winnings.
137     /// Does NOT transfer ownership of token.
138     function _bid(uint256 _tokenId, uint256 _bidAmount)
139         internal
140         returns (uint256)
141     {
142         // Get a reference to the auction struct
143         Auction storage auction = tokenIdToAuction[_tokenId];
144 
145        
146         // Check that the bid is greater than or equal to the current price
147         uint256 price = auction.sellPrice;
148         require(_bidAmount >= price);
149 
150         // Grab a reference to the seller before the auction struct
151         // gets deleted.
152         address seller = auction.seller;
153 
154         // The bid is good! Remove the auction before sending the fees
155         // to the sender so we can't have a reentrancy attack.
156         _removeAuction(_tokenId);
157         
158         // Tell the world!
159         AuctionSuccessful(_tokenId, price, msg.sender);
160         return price;
161     }
162 
163     /// @dev Removes an auction from the list of open auctions.
164     /// @param _tokenId - ID of NFT on auction.
165     function _removeAuction(uint256 _tokenId) internal {
166         delete tokenIdToAuction[_tokenId];
167     }
168 
169 }
170 
171 contract SaleAuction is AuctionBase {
172     address public beneficiary = msg.sender;
173     function SaleAuction(address _nftAddress) public {
174         ERC721 candidateContract = ERC721(_nftAddress);
175         nonFungibleContract = candidateContract;
176     }
177 
178     function getAuction(uint256 _tokenId)
179         external
180         constant
181         returns
182     (
183         address seller,
184         uint256 sellPrice
185     ) {
186         Auction storage auction = tokenIdToAuction[_tokenId];
187         
188         return (
189             auction.seller,
190             auction.sellPrice
191         );
192     }
193     
194     modifier onlyOwner() {
195         require(msg.sender == beneficiary);
196         _;
197     }
198 
199     function withdrawBalance() external {
200         address nftAddress = address(nonFungibleContract);
201         require(msg.sender == nftAddress);
202         bool res = nftAddress.send(this.balance);
203     }
204     
205    function bid(uint256 _tokenId)
206         external
207         payable
208     {
209         Auction memory auction = tokenIdToAuction[_tokenId];
210         address seller = auction.seller;
211         _bid(_tokenId, msg.value);
212         _transfer(msg.sender, _tokenId);
213         seller.transfer(msg.value);
214     }
215 
216     function bidCustomAuction(uint256 _tokenId, uint256 _price, address _buyer)
217         external
218         payable
219     {
220         
221         _bid(_tokenId, _price);
222         _transfer(_buyer, _tokenId);
223     }
224 
225 
226     function createAuction(
227         uint256 _tokenId,
228         uint256 _sellPrice,
229         address _seller
230     )
231         external
232     {       
233         // require(msg.sender == address(nonFungibleContract));
234         _escrow(_seller, _tokenId);
235         Auction memory auction = Auction(_seller, _sellPrice);
236         _addAuction(_tokenId, auction);
237     }
238 }
239 
240 contract BlockOwnership is BlockBase, ERC721 {
241   string public constant name = "CryptoBlocks";
242   string public constant symbol = "CB";
243 
244   bytes4 constant InterfaceSignature_ERC721 =
245       bytes4(keccak256('name()')) ^
246       bytes4(keccak256('symbol()')) ^
247       bytes4(keccak256('totalSupply()')) ^
248       bytes4(keccak256('balanceOf(address)')) ^
249       bytes4(keccak256('ownerOf(uint256)')) ^
250       bytes4(keccak256('approve(address,uint256)')) ^
251       bytes4(keccak256('transfer(address,uint256)')) ^
252       bytes4(keccak256('transferFrom(address,address,uint256)')) ^
253       bytes4(keccak256('tokensOfOwner(address)')) ^
254       bytes4(keccak256('tokenMetadata(uint256,string)'));
255       
256       function _owns(address _claimant, uint256 _tokenId) internal constant returns (bool) {
257           return blockIndexToOwner[_tokenId] == _claimant;
258       }
259 
260       function _approve(uint256 _tokenId, address _approved) internal {
261           blockIndexToApproved[_tokenId] = _approved;
262       }
263 
264       function _approvedFor(address _claimant, uint256 _tokenId) internal constant returns (bool) {
265           return blockIndexToApproved[_tokenId] == _claimant;
266       }
267 
268       function ownerOf(uint256 _tokenId) external constant returns (address owner)
269       {
270           owner = blockIndexToOwner[_tokenId];
271   
272           require(owner != address(0));
273           return owner;
274       }
275 
276 
277       function balanceOf(address _owner) public constant returns (uint256 count) {
278           return ownershipTokenCount[_owner];
279       }
280     
281       function totalSupply() public constant returns (uint) {
282           return blocks.length - 1;
283       }
284 
285       function approve(address _to, uint256 _tokenId) external {
286           require(_owns(msg.sender, _tokenId));
287           _approve(_tokenId, _to);
288           Approval(msg.sender, _to, _tokenId);
289       }
290 
291       function transfer(address _to, uint256 _tokenId) external {
292           //require(_to != address(0));
293           //require(_to != address(this));
294           _transfer(msg.sender, _to, _tokenId);
295       }
296       
297 
298       function tokensOfOwner(address _owner) external constant returns(uint256[] ownerTokens) {
299           uint256 tokenCount = balanceOf(_owner);
300           if (tokenCount == 0) {
301               return new uint256[](0);
302           } else {
303               uint256[] memory result = new uint256[](tokenCount);
304               uint256 totalBlocks = totalSupply();
305               uint256 resultIndex = 0;
306               uint256 blockId;
307   
308               for (blockId = 1; blockId <= totalBlocks; blockId++) {
309                   if (blockIndexToOwner[blockId] == _owner) {
310                       result[resultIndex] = blockId;
311                       resultIndex++;
312                   }
313               }
314               return result;
315           }
316       }
317       
318 
319       function transferFrom(address _from, address _to, uint256 _tokenId) external {
320           require(_to != address(0));
321           require(_to != address(this));
322           require(_approvedFor(msg.sender, _tokenId));
323           require(_owns(_from, _tokenId));
324           _transfer(_from, _to, _tokenId);
325       }
326 }
327 
328 
329 
330 contract BlockCoreOne is BlockOwnership {
331 
332     uint256[5] public lastGen0SalePrices;
333     address[16] public owners;
334     address public beneficiary = msg.sender;
335 
336     mapping (uint256 => address) public blockIndexToOwner;
337     uint256 public gen0CreatedCount;
338 
339     uint256 public constant BLOCK_BASIC_PRICE = 10 finney;
340     uint256 public constant BLOCK_DURATION = 1 days;
341 
342 
343 
344     function buyBlock(string _position, uint256 _w, uint256 _h, uint256 _generation, uint256 _unitPrice) public payable returns(uint256 blockID) {
345         uint256 price = computeBlockPrice(_w, _h, _unitPrice);
346         uint256 _bidAmount = msg.value;
347         require(_bidAmount >= price);
348         uint256 blockId = _createBlock(_w, _h, _generation, _position, address(this));
349         
350         _approve(blockId, saleAuction);
351         saleAuction.createAuction(blockId, price, address(this));  
352         address buyer = msg.sender;  
353         saleAuction.bidCustomAuction(blockId, _bidAmount, buyer);    
354 
355         return blockId;
356     }
357 
358     function migrateBlock (string _position, uint256 _width, uint256 _heigth, uint256 _generation, address _buyer) external returns(uint256){
359         uint newBlockId = _createBlock(_width, _heigth, _generation, _position, address(this));
360         address owner = _buyer;
361         _approve(newBlockId, owner);
362         return newBlockId;
363     }   
364 
365     function create(string _position, uint256 _width, uint256 _heigth, uint256 _generation) external returns(uint256){
366         uint newBlockId = _createBlock(_width, _heigth, _generation, _position, address(this));
367 
368         return newBlockId;
369     }   
370 
371     function computeBlockPrice(uint256 _w, uint256 _h, uint256 unitPrice) public constant returns (uint256 blockPrice) {
372         uint256 price = _w * _h * unitPrice;
373         return price;
374     }
375     
376     modifier onlyOwner() {
377         require(msg.sender == beneficiary);
378         _;
379     }
380 
381 
382     function withdrawBalance() external onlyOwner {
383         uint256 balance = this.balance;
384         beneficiary.transfer(balance);
385     }
386 
387     function checkBalance() external constant onlyOwner returns (uint balance) {
388         return this.balance;
389     }
390 
391     function createSaleAuction(uint256 _tokenId, uint256 _sellPrice) external{
392         address seller = msg.sender;
393         _approve(_tokenId, saleAuction);
394         saleAuction.createAuction(_tokenId, _sellPrice, seller);    
395     }
396     
397     function setSaleAuctionAddress(address _address) external onlyOwner {
398         SaleAuction candidateContract = SaleAuction(_address);
399         saleAuction = candidateContract;
400     }
401    
402 }