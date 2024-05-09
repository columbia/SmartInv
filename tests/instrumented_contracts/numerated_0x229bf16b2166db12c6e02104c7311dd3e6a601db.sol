1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  * World War Goo - Competitive Idle Game
6  * 
7  * https://ethergoo.io
8  * 
9  */
10 
11 interface ERC721 {
12     function totalSupply() external view returns (uint256 tokens);
13     function balanceOf(address owner) external view returns (uint256 balance);
14     function ownerOf(uint256 tokenId) external view returns (address owner);
15     function exists(uint256 tokenId) external view returns (bool tokenExists);
16     function approve(address to, uint256 tokenId) external;
17     function getApproved(uint256 tokenId) external view returns (address approvee);
18 
19     function transferFrom(address from, address to, uint256 tokenId) external;
20     function tokensOf(address owner) external view returns (uint256[] tokens);
21     //function tokenByIndex(uint256 index) external view returns (uint256 token);
22 
23     // Events
24     event Transfer(address from, address to, uint256 tokenId);
25     event Approval(address owner, address approved, uint256 tokenId);
26 }
27 
28 interface ERC20 {
29     function totalSupply() external constant returns (uint);
30     function balanceOf(address tokenOwner) external constant returns (uint balance);
31     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
32     function transfer(address to, uint tokens) external returns (bool success);
33     function approve(address spender, uint tokens) external returns (bool success);
34     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
35     function transferFrom(address from, address to, uint tokens) external returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 interface ERC721TokenReceiver {
42     function onERC721Received(address operator, address from, uint256 tokenId, bytes data) external returns(bytes4);
43 }
44 
45 interface ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
47 }
48 
49 contract Bankroll {
50      function depositEth(uint256 gooAllocation, uint256 tokenAllocation) payable external;
51 }
52 
53 contract Inventory {
54     mapping(uint256 => uint256) public tokenItems; // tokenId -> itemId
55 }
56 
57 contract Marketplace is ERC721TokenReceiver, ApproveAndCallFallBack {
58     
59     mapping(address => bool) whitelistedMaterials; // ERC20 addresses allowed to list
60     mapping(address => bool) whitelistedItems; // ERC721 addresses allowed to list
61     mapping(address => uint256) listingFees; // Just incase want different fee per type
62     Bankroll constant bankroll = Bankroll(0x66a9f1e53173de33bec727ef76afa84956ae1b25);
63  
64     uint256 private constant removalDuration = 14 days; // Listings can be pruned from market after 14 days
65     
66     bool public paused = false;
67     address owner;
68 
69     mapping(uint256 => Listing) public listings;
70     uint256[] public listingsIds;
71     
72     uint256 listingId = 1; // Start at one
73     
74     constructor() public {
75         owner = msg.sender;
76     }
77 
78     struct Listing {
79         address tokenAddress; // Listing type (either item, premium unit, materials)
80         address player;
81         
82         uint128 listingPointer; // Index in the market's listings
83         uint128 tokenId; // Or amount listed (if it's erc20)
84         uint128 listTime;
85         uint128 price;
86     }
87     
88     function getMarketSize() external constant returns(uint) {
89         return listingsIds.length;
90     }
91     
92     function onERC721Received(address operator, address from, uint256 tokenId, bytes data) external returns(bytes4) {
93         require(whitelistedItems[msg.sender]); // Can only list items + premium units
94         require(canListItems(from)); // Token owner cannot be a contract (to prevent reverting payments)
95         require(!paused);
96         
97         uint256 price = extractUInt256(data);
98         require(price > 99 szabo && price <= 100 ether);
99         
100         listings[listingId] = Listing(msg.sender, from, uint128(listingsIds.push(listingId) - 1), uint128(tokenId), uint128(now), uint128(price));
101         listingId++;
102         
103         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
104     }
105     
106     function receiveApproval(address from, uint256 amount, address token, bytes data) external {
107         require(whitelistedMaterials[msg.sender]);
108         require(canListItems(from)); // Token owner cannot be a contract (to prevent reverting payments)
109         require(amount > 0);
110         require(!paused);
111         
112         uint256 price = extractUInt256(data);
113         require(price > 9 szabo && price <= 100 ether);
114         
115         listings[listingId] = Listing(msg.sender, from, uint128(listingsIds.push(listingId) - 1), uint128(amount), uint128(now), uint128(price));
116         listingId++;
117         
118         ERC20(token).transferFrom(from, this, amount);
119     }
120     
121     function purchaseListing(uint256 auctionId) payable external {
122         Listing memory listing = listings[auctionId];
123         require(listing.tokenId > 0);
124         require(listing.player != msg.sender);
125         require(!paused);
126         
127         uint128 price = listing.price;
128         require(msg.value >= price);
129         
130         if (whitelistedMaterials[listing.tokenAddress]) {
131             uint128 matsBought = uint128(msg.value) / price;
132             if (matsBought >= listing.tokenId) {
133                 matsBought = listing.tokenId; // Max mats for sale
134                 removeListingInternal(auctionId); // Listing sold out so remove
135             } else {
136                 listings[auctionId].tokenId = listings[auctionId].tokenId - matsBought;
137             }
138             price *= matsBought;
139             ERC20(listing.tokenAddress).transfer(msg.sender, matsBought);
140         } else if (whitelistedItems[listing.tokenAddress]) {
141             removeListingInternal(auctionId);
142             ERC721(listing.tokenAddress).transferFrom(this, msg.sender, listing.tokenId);
143         }
144         
145         uint256 saleFee = (price * listingFees[listing.tokenAddress]) / 100;
146         listing.player.transfer(price - saleFee); // Pay seller
147         bankroll.depositEth.value(saleFee)(50, 50);
148         
149         uint256 bidExcess = msg.value - price;
150         if (bidExcess > 0) {
151             msg.sender.transfer(bidExcess);
152         }
153     }
154     
155     function removeListing(uint256 auctionId) external {
156         Listing memory listing = listings[auctionId];
157         require(listing.tokenId > 0);
158         require(listing.player == msg.sender || (now - listing.listTime) > removalDuration);
159         
160         // Transfer back
161         if (whitelistedMaterials[listing.tokenAddress]) {
162             ERC20(listing.tokenAddress).transfer(listing.player, listing.tokenId);
163         } else if (whitelistedItems[listing.tokenAddress]) {
164             ERC721(listing.tokenAddress).transferFrom(this, listing.player, listing.tokenId);
165         }
166         
167         removeListingInternal(auctionId);
168     }
169     
170     function removeListingInternal(uint256 auctionId) internal {
171         if (listingsIds.length > 1) {
172             uint128 rowToDelete = listings[auctionId].listingPointer;
173             uint256 keyToMove = listingsIds[listingsIds.length - 1];
174             
175             listingsIds[rowToDelete] = keyToMove;
176             listings[keyToMove].listingPointer = rowToDelete;
177         }
178         
179         listingsIds.length--;
180         delete listings[auctionId];
181     }
182     
183     
184     function getListings(uint256 startIndex, uint256 endIndex) external constant returns (uint256[], address[], uint256[], uint256[], uint256[], address[]) {
185         uint256 numListings = (endIndex - startIndex) + 1;
186         if (startIndex == 0 && endIndex == 0) {
187             numListings = listingsIds.length;
188         }
189         uint256[] memory itemIds = new uint256[](numListings);
190         address[] memory listingOwners = new address[](numListings);
191         uint256[] memory listTimes = new uint256[](numListings);
192         uint256[] memory prices = new uint256[](numListings);
193         address[] memory listingType = new address[](numListings);
194         
195         for (uint256 i = startIndex; i < numListings; i++) {
196             Listing memory listing = listings[listingsIds[i]];
197             listingOwners[i] = listing.player;
198             
199             if (whitelistedItems[listing.tokenAddress]) {
200                 itemIds[i] = Inventory(listing.tokenAddress).tokenItems(listing.tokenId); // tokenId -> itemId
201             } else {
202                 itemIds[i] = listing.tokenId; // Amount of tokens listed
203             }
204             
205             listTimes[i] = listing.listTime;
206             prices[i] = listing.price;
207             listingType[i] = listing.tokenAddress;
208         }
209         return (listingsIds, listingOwners, itemIds, listTimes, prices, listingType);
210     }
211     
212     function getListingAtPosition(uint256 i) external constant returns (address, uint256, uint256, uint256) {
213         Listing memory listing = listings[listingsIds[i]];
214         return (listing.player, listing.tokenId, listing.listTime, listing.price);
215     }
216     
217     function getListing(uint64 tokenId) external constant returns (address, uint256, uint256, uint256) {
218         Listing memory listing = listings[tokenId];
219         return (listing.player, listing.tokenId, listing.listTime, listing.price);
220     }
221     
222     // Contracts can't list items (avoids unbuyable listings)
223     function canListItems(address seller) internal constant returns (bool) {
224         uint size;
225         assembly { size := extcodesize(seller) }
226         return size == 0 && tx.origin == seller;
227     }
228     
229     function extractUInt256(bytes bs) internal pure returns (uint256 payload) {
230         uint256 payloadSize;
231         assembly {
232             payloadSize := mload(bs)
233             payload := mload(add(bs, 0x20))
234         }
235         payload = payload >> 8*(32 - payloadSize);
236         
237     }
238 
239     function setPaused(bool shouldPause) external {
240         require(msg.sender == owner);
241         paused = shouldPause;
242     }
243     
244     function updateERC20Settings(address token, bool allowed, uint256 newFee) external {
245         require(msg.sender == owner);
246         require(newFee <= 10); // Let's not get crazy
247         whitelistedMaterials[token] = allowed;
248         listingFees[token] = newFee;
249     }
250     
251     function updateERC721Settings(address token, bool allowed, uint256 newFee) external {
252         require(msg.sender == owner);
253         require(newFee <= 10); // Let's not get crazy
254         whitelistedItems[token] = allowed;
255         listingFees[token] = newFee;
256     }
257 
258 }