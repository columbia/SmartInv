1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10     address public owner;
11 
12     /**
13     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14     * account.
15     */
16     function Ownable() public {
17         owner = msg.sender;
18     }
19 
20 
21     /**
22     * @dev Throws if called by any account other than the owner.
23     */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30     * @dev Allows the current owner to transfer control of the contract to a newOwner.
31     * @param newOwner The address to transfer ownership to.
32     */
33     function transferOwnership(address newOwner) public onlyOwner {
34         require(newOwner != address(0));
35         owner = newOwner;
36   }
37 }
38 
39 contract Pausable is Ownable {
40     event Pause();
41     event Unpause();
42 
43     bool public paused = false;
44 
45     /**
46     * @dev modifier to allow actions only when the contract IS paused
47     */
48     modifier whenNotPaused() {
49         require(!paused);
50         _;
51     }
52 
53     /**
54     * @dev modifier to allow actions only when the contract IS NOT paused
55     */
56     modifier whenPaused {
57         require(paused);
58         _;
59     }
60 
61     /**
62     * @dev called by the owner to pause, triggers stopped state
63     */
64     function pause() onlyOwner whenNotPaused public returns (bool) {
65         paused = true;
66         Pause();
67         return true;
68     }
69 
70     /**
71     * @dev called by the owner to unpause, returns to normal state
72     */
73     function unpause() onlyOwner whenPaused public returns (bool) {
74         paused = false;
75         Unpause();
76         return true;
77     }
78 }
79 
80 contract ERC721 {
81 
82     // Events
83     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
84     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
85 
86     // Required
87     function totalSupply() public view returns (uint256 total);
88     function balanceOf(address _owner) public view returns (uint256 balance);
89     function ownerOf(uint256 _tokenId) public view returns (address owner);
90     function approve(address _to, uint256 _tokenId) public;
91     function getApproved(uint _tokenId) public view returns (address approved);
92     function transferFrom(address _from, address _to, uint256 _tokenId) public;
93     function transfer(address _to, uint256 _tokenId) public;
94     function implementsERC721() public pure returns (bool);
95 
96     // Optional
97     // function name() public view returns (string name);
98     // function symbol() public view returns (string symbol);
99     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
100     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
101 }
102 
103 contract BCFAuction is Pausable {
104 
105     struct CardAuction {
106         address seller;
107         uint128 startPrice; // in wei
108         uint128 endPrice;
109         uint64 duration;
110         uint64 startedAt;
111     }
112 
113     // To lookup owners 
114     ERC721 public dataStore;
115     uint256 public auctioneerCut;
116 
117     mapping (uint256 => CardAuction) playerCardIdToAuction;
118 
119     event AuctionCreated(uint256 cardId, uint256 startPrice, uint256 endPrice, uint256 duration);
120     event AuctionSuccessful(uint256 cardId, uint256 finalPrice, address winner);
121     event AuctionCancelled(uint256 cardId);
122 
123     function BCFAuction(address dataStoreAddress, uint cutValue) public {
124         require(cutValue <= 10000); // 100% == 10,000
125         auctioneerCut = cutValue;
126 
127         ERC721 candidateDataStoreContract = ERC721(dataStoreAddress);
128         require(candidateDataStoreContract.implementsERC721());
129         dataStore = candidateDataStoreContract;
130     }
131 
132     function withdrawBalance() external {
133         address storageAddress = address(dataStore);
134         require(msg.sender == owner || msg.sender == storageAddress);
135         storageAddress.transfer(this.balance);
136     }
137 
138     function createAuction(
139         uint256 cardId, 
140         uint256 startPrice, 
141         uint256 endPrice, 
142         uint256 duration, 
143         address seller
144     )
145         external
146         whenNotPaused
147     {
148         require(startPrice == uint256(uint128(startPrice)));
149         require(endPrice == uint256(uint128(endPrice)));
150         require(duration == uint256(uint64(duration)));
151         require(seller != address(0));
152         require(address(dataStore) != address(0));
153         require(msg.sender == address(dataStore));
154 
155         _escrow(seller, cardId);
156         CardAuction memory auction = CardAuction(
157             seller,
158             uint128(startPrice),
159             uint128(endPrice),
160             uint64(duration),
161             uint64(now)
162         );
163         _addAuction(cardId, auction);
164     }
165 
166     function bid(uint256 cardId) external payable whenNotPaused {
167         _bid(cardId, msg.value); // This function handles validation and throws
168         _transfer(msg.sender, cardId);
169     }
170 
171     function cancelAuction(uint256 cardId) external {
172         CardAuction storage auction = playerCardIdToAuction[cardId];
173         require(isOnAuction(auction));
174         address seller = auction.seller;
175         require(msg.sender == seller);
176         _cancelAuction(cardId, seller);
177     }
178 
179     function getAuction(uint256 cardId) external view returns
180     (
181         address seller,
182         uint256 startingPrice,
183         uint256 endingPrice,
184         uint256 duration,
185         uint256 startedAt
186     ) {
187         CardAuction storage auction = playerCardIdToAuction[cardId];
188         require(isOnAuction(auction));
189         return (auction.seller, auction.startPrice, auction.endPrice, auction.duration, auction.startedAt);
190     }
191 
192     function getCurrentPrice(uint256 cardId) external view returns (uint256) {
193         CardAuction storage auction = playerCardIdToAuction[cardId];
194         require(isOnAuction(auction));
195         return currentPrice(auction);
196     }
197 
198     // Internal utility functions
199     function ownsPlayerCard(address cardOwner, uint256 cardId) internal view returns (bool) {
200         return (dataStore.ownerOf(cardId) == cardOwner);
201     }
202 
203     function _escrow(address owner, uint256 cardId) internal {
204         dataStore.transferFrom(owner, this, cardId);
205     }
206 
207     function _transfer(address receiver, uint256 cardId) internal {
208         dataStore.transfer(receiver, cardId);
209     }
210 
211     function _addAuction(uint256 cardId, CardAuction auction) internal {
212         require(auction.duration >= 1 minutes && auction.duration <= 14 days);
213         playerCardIdToAuction[cardId] = auction;
214         AuctionCreated(cardId, auction.startPrice, auction.endPrice, auction.duration);
215     }
216 
217     function _removeAuction(uint256 cardId) internal {
218         delete playerCardIdToAuction[cardId];
219     }
220 
221     function _cancelAuction(uint256 cardId, address seller) internal {
222         _removeAuction(cardId);
223         _transfer(seller, cardId);
224         AuctionCancelled(cardId);
225     }
226 
227     function isOnAuction(CardAuction storage auction) internal view returns (bool) {
228         return (auction.startedAt > 0);
229     }
230 
231     function _bid(uint256 cardId, uint256 bidAmount) internal returns (uint256) {
232         CardAuction storage auction = playerCardIdToAuction[cardId];
233         require(isOnAuction(auction));
234 
235         uint256 price = currentPrice(auction);
236         require(bidAmount >= price);
237 
238         address seller = auction.seller;
239         _removeAuction(cardId);
240 
241         if (price > 0) {
242             uint256 handlerCut = calculateAuctioneerCut(price);
243             uint256 sellerProceeds = price - handlerCut;
244             seller.transfer(sellerProceeds);
245         } 
246 
247         uint256 bidExcess = bidAmount - price;
248         msg.sender.transfer(bidExcess);
249 
250         AuctionSuccessful(cardId, price, msg.sender); // Emit event/log
251 
252         return price;
253     }
254 
255     function currentPrice(CardAuction storage auction) internal view returns (uint256) {
256         uint256 secondsPassed = 0;
257         if (now > auction.startedAt) {
258             secondsPassed = now - auction.startedAt;
259         }
260 
261         return calculateCurrentPrice(auction.startPrice, auction.endPrice, auction.duration, secondsPassed);
262     }
263 
264     function calculateCurrentPrice(uint256 startPrice, uint256 endPrice, uint256 duration, uint256 secondsElapsed)
265         internal
266         pure
267         returns (uint256)
268     {
269         if (secondsElapsed >= duration) {
270             return endPrice;
271         } 
272 
273         int256 totalPriceChange = int256(endPrice) - int256(startPrice);
274         int256 currentPriceChange = totalPriceChange * int256(secondsElapsed) / int256(duration);
275         int256 _currentPrice = int256(startPrice) + currentPriceChange;
276 
277         return uint256(_currentPrice);
278     }
279 
280     function calculateAuctioneerCut(uint256 sellPrice) internal view returns (uint256) {
281         // 10,000 = 100%, ownerCut required'd <= 10,000 in the constructor so no requirement to validate here
282         uint finalCut = sellPrice * auctioneerCut / 10000;
283         return finalCut;
284     }    
285 }