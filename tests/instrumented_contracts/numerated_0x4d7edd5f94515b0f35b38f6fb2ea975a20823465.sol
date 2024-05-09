1 pragma solidity ^0.4.2;
2 
3 // The below two interfaces (KittyCore and SaleClockAuction) are from Crypto Kitties. This contract will have to call the Crypto Kitties contracts to find the owner of a Kitty, the properties of a Kitty and a Kitties price.
4 interface KittyCore {
5 
6     function ownerOf (uint256 _tokenId) external view returns (address owner);
7     
8     function getKitty (uint256 _id) external view returns (bool isGestating, bool isReady, uint256 cooldownIndex, uint256 nextActionAt, uint256 siringWithId, uint256 birthTime, uint256 matronId, uint256 sireId, uint256 generation, uint256 genes);
9     
10 }
11 
12 interface SaleClockAuction {
13     
14     function getCurrentPrice (uint256 _tokenId) external view returns (uint256);
15     
16     function getAuction(uint256 _tokenId) external view returns (address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt);
17     
18 }
19 
20 // ERC721 token standard is used for non-fungible assets, like Sprites (non-fungible because they can't be split into pieces and don't have equal value). Technically this contract will also be ERC20 compliant.
21 contract ERC721 {
22     // Required methods
23     function totalSupply() public view returns (uint256 total);
24     function balanceOf(address _owner) public view returns (uint256 balance);
25     function ownerOf(uint256 _tokenId) external view returns (address owner);
26     function approve(address _to, uint256 _tokenId) external;
27     function transfer(address _to, uint256 _tokenId) external;
28     function transferFrom(address _from, address _to, uint256 _tokenId) external;
29     
30     function allowance(address _owner, address _spender) view returns (uint remaining);
31 
32     // Events
33     event Transfer(address indexed from, address indexed to, uint256 tokenId);
34     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
35 
36     function name() public view returns (string);
37     function symbol() public view returns (string);
38     
39     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
40     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
41 
42     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
43     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
44 }
45 
46 contract CryptoSprites is ERC721 {
47     
48     address public owner;
49     
50     address KittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
51 
52     address SaleClockAuctionAddress = 0xb1690C08E213a35Ed9bAb7B318DE14420FB57d8C;
53 
54     // 1.5% of Sprite sales to go to Heifer International: https://www.heifer.org/what-you-can-do/give/digital-currency.html (not affiliated with this game)
55     address charityAddress = 0xb30cb3b3E03A508Db2A0a3e07BA1297b47bb0fb1;
56     
57     uint public etherForOwner;
58     uint public etherForCharity;
59     
60     uint public ownerCut = 15; // 1.5% (15/1000 - see the buySprite() function) of Sprite sales go to owner of this contract
61     uint public charityCut = 15; // 1.5% of Sprite sales also go to an established charity (Heifer International)
62     
63     uint public featurePrice = 10**16; // 0.01 Ether to feature a sprite
64     
65     // With the below the default price of a Sprite of a kitty would be only 10% of the kitties price. If for example priceMultiplier = 15 and priceDivider = 10, then the default price of a sprite would be 1.5 times the price of its kitty. Since Solidity doesn't allow decimals, two numbers are needed for  flexibility in setting the default price a sprite would be in relation to the price of its kitten, in case that's needed later (owner of this contract can change the default price of Sprites anytime). 
66     // The default price of a Sprite may easily increase later to be more than 10%
67     uint public priceMultiplier = 1;
68     uint public priceDivider = 10;
69     
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74     
75     function CryptoSprites() {
76         owner = msg.sender;
77     }
78     
79     uint[] public featuredSprites;
80     
81     uint[] public allPurchasedSprites;
82     
83     uint public totalFeatures;
84     uint public totalBuys;
85     
86     struct BroughtSprites {
87         address owner;
88         uint spriteImageID;
89         bool forSale;
90         uint price;
91         uint timesTraded;
92         bool featured;
93     }
94     
95     mapping (uint => BroughtSprites) public broughtSprites;
96     
97     // This may include Sprites the user previously owned but doesn't anymore
98     mapping (address => uint[]) public spriteOwningHistory;
99     
100     mapping (address => uint) public numberOfSpritesOwnedByUser;
101     
102     // First address is the address of a Sprite owner, second address is an address having approval to move a token belonging to the first address, uint[] is the array of Sprites belonging to the first address that the second address has approval to transfer
103     mapping (address => mapping (address => uint[])) public allowed;
104     
105     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
106     
107     bytes4 constant InterfaceSignature_ERC721 =
108         bytes4(keccak256('totalSupply()')) ^
109         bytes4(keccak256('balanceOf(address)')) ^
110         bytes4(keccak256('ownerOf(uint256)')) ^
111         bytes4(keccak256('approve(address,uint256)')) ^
112         bytes4(keccak256('transfer(address,uint256)')) ^
113         bytes4(keccak256('transferFrom(address,address,uint256)'));
114 
115     function() payable {
116         
117     }
118     
119     function adjustDefaultSpritePrice (uint _priceMultiplier, uint _priceDivider) onlyOwner {
120         require (_priceMultiplier > 0);
121         require (_priceDivider > 0);
122         priceMultiplier = _priceMultiplier;
123         priceDivider = _priceDivider;
124     }
125     
126     function adjustCut (uint _ownerCut, uint _charityCut) onlyOwner {
127         require (_ownerCut + _charityCut < 51); // Keep this contract honest by allowing the maximum combined cut to be no more than 5% (50/1000) of sales
128         ownerCut = _ownerCut;
129         charityCut = _charityCut;
130     }
131     
132     function adjustFeaturePrice (uint _featurePrice) onlyOwner {
133         require (_featurePrice > 0);
134         featurePrice = _featurePrice;
135     }
136     
137     function withdraw() onlyOwner {
138         owner.transfer(etherForOwner);
139         charityAddress.transfer(etherForCharity);
140         etherForOwner = 0;
141         etherForCharity = 0;
142     }
143     
144     function featureSprite (uint spriteId) payable {
145         // Do not need to require user to be the owner of a Sprite to feature it
146         // require (msg.sender == broughtSprites[spriteId].owner);
147         require (msg.value == featurePrice);
148         broughtSprites[spriteId].featured = true;
149 
150         if (broughtSprites[spriteId].timesTraded == 0) {
151             address kittyOwner = KittyCore(KittyCoreAddress).ownerOf(spriteId);
152             uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(spriteId);
153             
154             // When featuring a Sprite that hasn't been traded before, if the original Kitty is for sale, update this Sprite with a price and set forSale = true - as long as msg.sender is the owner of the Kitty. Otherwise it could be that the owner of the Kitty removed the Sprite for sale and a different user could feature the Sprite and have it listed for sale
155             if (priceIfAny > 0 && msg.sender == kittyOwner) {
156                 broughtSprites[spriteId].price = priceIfAny * priceMultiplier / priceDivider;
157                 broughtSprites[spriteId].forSale = true;
158             }
159             
160             broughtSprites[spriteId].owner = kittyOwner;
161             broughtSprites[spriteId].spriteImageID = uint(block.blockhash(block.number-1))%360 + 1;
162             
163             numberOfSpritesOwnedByUser[kittyOwner]++;
164         }
165         
166         totalFeatures++;
167         etherForOwner += msg.value;
168         featuredSprites.push(spriteId);
169     }
170     
171     function calculatePrice (uint kittyId) view returns (uint) {
172         
173         uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(kittyId);
174         
175         var _ownerCut = ((priceIfAny / 1000) * ownerCut) * priceMultiplier / priceDivider;
176         var _charityCut = ((priceIfAny / 1000) * charityCut) * priceMultiplier / priceDivider;
177         
178         return (priceIfAny * priceMultiplier / priceDivider) + _ownerCut + _charityCut;
179         
180     }
181     
182     function buySprite (uint spriteId) payable {
183         
184         uint _ownerCut;
185         uint _charityCut;
186         
187         if (broughtSprites[spriteId].forSale == true) {
188             
189             // Buying a sprite that has been purchased or featured before, from a player of this game who has listed it for sale
190             
191             _ownerCut = ((broughtSprites[spriteId].price / 1000) * ownerCut);
192             _charityCut = ((broughtSprites[spriteId].price / 1000) * charityCut);
193             
194             require (msg.value == broughtSprites[spriteId].price + _ownerCut + _charityCut);
195             
196             broughtSprites[spriteId].owner.transfer(broughtSprites[spriteId].price);
197             
198             numberOfSpritesOwnedByUser[broughtSprites[spriteId].owner]--;
199             
200             if (broughtSprites[spriteId].timesTraded == 0) {
201                 // Featured sprite that is being purchased for the first time
202                 allPurchasedSprites.push(spriteId);
203             }
204             
205             Transfer (msg.sender, broughtSprites[spriteId].owner, spriteId);
206             
207         } else {
208             
209             // Buying a sprite that has never been brought before, from a kitten currently listed for sale in the CryptoKitties contract. The sale price will go to the owner of the kitten in the CryptoKitties contract (who very possibly would have never even heard of this game)
210             
211             require (broughtSprites[spriteId].timesTraded == 0);
212             require (broughtSprites[spriteId].price == 0);
213             
214             // Here we are looking up the price of the Sprite's corresponding Kitty
215             
216             uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(spriteId);
217             require (priceIfAny > 0); // If the kitten in the CryptoKitties contract isn't for sale, a Sprite for it won't be for sale either
218             
219             _ownerCut = ((priceIfAny / 1000) * ownerCut) * priceMultiplier / priceDivider;
220             _charityCut = ((priceIfAny / 1000) * charityCut) * priceMultiplier / priceDivider;
221             
222             // Crypto Kitty prices decrease every few seconds by a fractional amount, so use >=
223             
224             require (msg.value >= (priceIfAny * priceMultiplier / priceDivider) + _ownerCut + _charityCut);
225             
226             // Get the owner of the Kitty for sale
227             
228             var (kittyOwner,,,,) = SaleClockAuction(SaleClockAuctionAddress).getAuction(spriteId);
229             
230             kittyOwner.transfer(priceIfAny * priceMultiplier / priceDivider);
231             
232             allPurchasedSprites.push(spriteId);
233             
234             broughtSprites[spriteId].spriteImageID = uint(block.blockhash(block.number-1))%360 + 1; // Random number to determine what image/character the sprite will be
235             
236             Transfer (kittyOwner, msg.sender, spriteId);
237             
238         }
239         
240         totalBuys++;
241         
242         spriteOwningHistory[msg.sender].push(spriteId);
243         numberOfSpritesOwnedByUser[msg.sender]++;
244         
245         broughtSprites[spriteId].owner = msg.sender;
246         broughtSprites[spriteId].forSale = false;
247         broughtSprites[spriteId].timesTraded++;
248         broughtSprites[spriteId].featured = false;
249             
250         etherForOwner += _ownerCut;
251         etherForCharity += _charityCut;
252         
253     }
254     
255     // Also used to adjust price if already for sale
256     function listSpriteForSale (uint spriteId, uint price) {
257         require (price > 0);
258         if (broughtSprites[spriteId].owner != msg.sender) {
259             require (broughtSprites[spriteId].timesTraded == 0);
260             
261             // This will be the owner of a Crypto Kitty, who can control the price of their unbrought Sprite
262             address kittyOwner = KittyCore(KittyCoreAddress).ownerOf(spriteId);
263             require (kittyOwner == msg.sender);
264             
265             broughtSprites[spriteId].owner = msg.sender;
266             broughtSprites[spriteId].spriteImageID = uint(block.blockhash(block.number-1))%360 + 1; 
267         }
268         broughtSprites[spriteId].forSale = true;
269         broughtSprites[spriteId].price = price;
270     }
271     
272     function removeSpriteFromSale (uint spriteId) {
273         if (broughtSprites[spriteId].owner != msg.sender) {
274             require (broughtSprites[spriteId].timesTraded == 0);
275             address kittyOwner = KittyCore(KittyCoreAddress).ownerOf(spriteId);
276             require (kittyOwner == msg.sender);
277             broughtSprites[spriteId].price = 1; // When a user buys a Sprite Id that isn't for sale in the buySprite() function (ie. would be a Sprite that's never been brought before, for a Crypto Kitty that's for sale), one of the requirements is broughtSprites[spriteId].price == 0, which will be the case by default. By making the price = 1 this will throw and the Sprite won't be able to be brought
278         } 
279         broughtSprites[spriteId].forSale = false;
280     }
281     
282     // The following functions are in case a different contract wants to pull this data, which requires a function returning it (even if the variables are public) since solidity contracts can't directly pull storage of another contract
283     
284     function featuredSpritesLength() view external returns (uint) {
285         return featuredSprites.length;
286     }
287     
288     function usersSpriteOwningHistory (address user) view external returns (uint[]) {
289         return spriteOwningHistory[user];
290     }
291     
292     function lookupSprite (uint spriteId) view external returns (address, uint, bool, uint, uint, bool) {
293         return (broughtSprites[spriteId].owner, broughtSprites[spriteId].spriteImageID, broughtSprites[spriteId].forSale, broughtSprites[spriteId].price, broughtSprites[spriteId].timesTraded, broughtSprites[spriteId].featured);
294     }
295     
296     function lookupFeaturedSprites (uint spriteId) view external returns (uint) {
297         return featuredSprites[spriteId];
298     }
299     
300     function lookupAllSprites (uint spriteId) view external returns (uint) {
301         return allPurchasedSprites[spriteId];
302     }
303     
304     // Will call SaleClockAuction to get the owner of a kitten and check its price (if it's for sale). We're calling the getAuction() function in the SaleClockAuction to get the kitty owner (that function returns 5 variables, we only want the owner). ownerOf() in the KittyCore contract won't return the kitty owner if the kitty is for sale, and this probably won't be used (including it in case it's needed to lookup an owner of a kitty not for sale later for any reason)
305     
306     function lookupKitty (uint kittyId) view returns (address, uint, address) {
307         
308         var (kittyOwner,,,,) = SaleClockAuction(SaleClockAuctionAddress).getAuction(kittyId);
309 
310         uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(kittyId);
311         
312         address kittyOwnerNotForSale = KittyCore(KittyCoreAddress).ownerOf(kittyId);
313 
314         return (kittyOwner, priceIfAny, kittyOwnerNotForSale);
315 
316     }
317     
318     // The below two functions will pull all info of a kitten. Split into two functions otherwise stack too deep errors. These may not even be needed, may just be used so the website can display all info of a kitten when someone looks it up.
319     
320     function lookupKittyDetails1 (uint kittyId) view returns (bool, bool, uint, uint, uint) {
321         
322         var (isGestating, isReady, cooldownIndex, nextActionAt, siringWithId,,,,,) = KittyCore(KittyCoreAddress).getKitty(kittyId);
323         
324         return (isGestating, isReady, cooldownIndex, nextActionAt, siringWithId);
325         
326     }
327     
328     function lookupKittyDetails2 (uint kittyId) view returns (uint, uint, uint, uint, uint) {
329         
330         var(,,,,,birthTime, matronId, sireId, generation, genes) = KittyCore(KittyCoreAddress).getKitty(kittyId);
331         
332         return (birthTime, matronId, sireId, generation, genes);
333         
334     }
335     
336     // ERC-721 required functions below
337     
338     string public name = 'Crypto Sprites';
339     string public symbol = 'CRS';
340     uint8 public decimals = 0; // Sprites are non-fungible, ie. can't be divided into pieces
341     
342     function name() public view returns (string) {
343         return name;
344     }
345     
346     function symbol() public view returns (string) {
347         return symbol;
348     }
349     
350     function totalSupply() public view returns (uint) {
351         return allPurchasedSprites.length;
352     }
353     
354     function balanceOf (address _owner) public view returns (uint) {
355         return numberOfSpritesOwnedByUser[_owner];
356     }
357     
358     function ownerOf (uint _tokenId) external view returns (address){
359         return broughtSprites[_tokenId].owner;
360     }
361     
362     function approve (address _to, uint256 _tokenId) external {
363         require (broughtSprites[_tokenId].owner == msg.sender);
364         allowed [msg.sender][_to].push(_tokenId);
365         Approval (msg.sender, _to, _tokenId);
366     }
367     
368     function transfer (address _to, uint _tokenId) external {
369         require (broughtSprites[_tokenId].owner == msg.sender);
370         broughtSprites[_tokenId].owner = _to;
371         numberOfSpritesOwnedByUser[msg.sender]--;
372         numberOfSpritesOwnedByUser[_to]++;
373         spriteOwningHistory[_to].push(_tokenId);
374         Transfer (msg.sender, _to, _tokenId);
375     }
376 
377     function transferFrom (address _from, address _to, uint256 _tokenId) external {
378         // This array shouldn't be big at all (if it's even more than 1 item) unless someone owns a huge number of Sprites and has called approve() on each of their Sprites to allow a certain address to transfer each one of them
379         for (uint i = 0; i < allowed[_from][msg.sender].length; i++) {
380             if (allowed[_from][msg.sender][i] == _tokenId) {
381                 require (broughtSprites[_tokenId].owner == _from);
382                 numberOfSpritesOwnedByUser[broughtSprites[_tokenId].owner]--;
383                 numberOfSpritesOwnedByUser[_to]++;
384                 spriteOwningHistory[_to].push(_tokenId);
385                 broughtSprites[_tokenId].owner = _to;
386                 Transfer (broughtSprites[_tokenId].owner, _to, _tokenId);
387             } 
388         }
389     }
390     
391     function allowance (address _owner, address _spender) view returns (uint) {
392         return allowed[_owner][_spender].length;
393     }
394     
395     function supportsInterface (bytes4 _interfaceID) external view returns (bool) {
396 
397         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
398     }
399     
400 }