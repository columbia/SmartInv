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
16     function getAuction (uint256 _tokenId) external view returns (address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt);
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
32     function takeOwnership(uint256 _tokenId) external;
33 
34     // Events
35     event Transfer(address indexed from, address indexed to, uint256 tokenId);
36     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
37 
38     function name() public view returns (string);
39     function symbol() public view returns (string);
40     
41     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
42     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
43 
44     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
45     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
46 }
47 
48 contract CryptoSprites is ERC721 {
49     
50     address public owner;
51     
52     address KittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
53 
54     address SaleClockAuctionAddress = 0xb1690C08E213a35Ed9bAb7B318DE14420FB57d8C;
55 
56     // 1.5% of Sprite sales to go to Heifer International: https://www.heifer.org/what-you-can-do/give/digital-currency.html (not affiliated with this game)
57     address charityAddress = 0xb30cb3b3E03A508Db2A0a3e07BA1297b47bb0fb1;
58     
59     uint public etherForOwner;
60     uint public etherForCharity;
61     
62     uint public ownerCut = 15; // 1.5% (15/1000 - see the buySprite() function) of Sprite sales go to owner of this contract
63     uint public charityCut = 15; // 1.5% of Sprite sales also go to an established charity (Heifer International)
64     
65     uint public featurePrice = 10**16; // 0.01 Ether to feature a sprite
66     
67     // With the below the default price of a Sprite of a kitty would be only 10% of the kitties price. If for example priceMultiplier = 15 and priceDivider = 10, then the default price of a sprite would be 1.5 times the price of its kitty. Since Solidity doesn't allow decimals, two numbers are needed for  flexibility in setting the default price a sprite would be in relation to the price of its kitten, in case that's needed later (owner of this contract can change the default price of Sprites anytime). 
68     // The default price of a Sprite may easily increase later to be more than 10%
69     uint public priceMultiplier = 1;
70     uint public priceDivider = 10;
71     
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76     
77     function CryptoSprites() {
78         owner = msg.sender;
79     }
80     
81     uint[] public featuredSprites;
82     
83     uint[] public allPurchasedSprites;
84     
85     uint public totalFeatures;
86     uint public totalBuys;
87     
88     struct BroughtSprites {
89         address owner;
90         uint spriteImageID;
91         bool forSale;
92         uint price;
93         uint timesTraded;
94         bool featured;
95     }
96     
97     mapping (uint => BroughtSprites) public broughtSprites;
98     
99     // This may include Sprites the user previously owned but doesn't anymore
100     mapping (address => uint[]) public spriteOwningHistory;
101     
102     mapping (address => uint) public numberOfSpritesOwnedByUser;
103     
104     mapping (address => mapping(address => mapping(uint256 => bool))) public addressToReceiverToAllowedSprite;
105     
106     mapping (address => mapping(address => uint256)) public addressToReceiverToAmountAllowed;
107     
108     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
109     
110     bytes4 constant InterfaceSignature_ERC721 =
111         bytes4(keccak256('totalSupply()')) ^
112         bytes4(keccak256('balanceOf(address)')) ^
113         bytes4(keccak256('ownerOf(uint256)')) ^
114         bytes4(keccak256('approve(address,uint256)')) ^
115         bytes4(keccak256('transfer(address,uint256)')) ^
116         bytes4(keccak256('transferFrom(address,address,uint256)'));
117 
118     function() payable {
119         etherForOwner += msg.value / 2;
120         etherForCharity += msg.value / 2;
121     }
122     
123     function adjustDefaultSpritePrice (uint _priceMultiplier, uint _priceDivider) onlyOwner {
124         require (_priceMultiplier > 0);
125         require (_priceDivider > 0);
126         priceMultiplier = _priceMultiplier;
127         priceDivider = _priceDivider;
128     }
129     
130     function adjustCut (uint _ownerCut, uint _charityCut) onlyOwner {
131         require (_ownerCut + _charityCut < 51); // Keep this contract honest by allowing the maximum combined cut to be no more than 5% (50/1000) of sales
132         ownerCut = _ownerCut;
133         charityCut = _charityCut;
134     }
135     
136     function adjustFeaturePrice (uint _featurePrice) onlyOwner {
137         require (_featurePrice > 0);
138         featurePrice = _featurePrice;
139     }
140     
141     function withdraw() onlyOwner {
142         owner.transfer(etherForOwner);
143         charityAddress.transfer(etherForCharity);
144         etherForOwner = 0;
145         etherForCharity = 0;
146     }
147     
148     function changeOwner (address _owner) onlyOwner {
149         owner = _owner;
150     }
151     
152     function featureSprite (uint spriteId) payable {
153         // Do not need to require user to be the owner of a Sprite to feature it
154         // require (msg.sender == broughtSprites[spriteId].owner);
155         require (msg.value == featurePrice);
156         broughtSprites[spriteId].featured = true;
157 
158         if (broughtSprites[spriteId].timesTraded == 0) {
159             address kittyOwner = KittyCore(KittyCoreAddress).ownerOf(spriteId);
160             uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(spriteId);
161             
162             // When featuring a Sprite that hasn't been traded before, if the original Kitty is for sale, update this Sprite with a price and set forSale = true - as long as msg.sender is the owner of the Kitty. Otherwise it could be that the owner of the Kitty removed the Sprite for sale and a different user could feature the Sprite and have it listed for sale
163             if (priceIfAny > 0 && msg.sender == kittyOwner) {
164                 broughtSprites[spriteId].price = priceIfAny * priceMultiplier / priceDivider;
165                 broughtSprites[spriteId].forSale = true;
166             }
167             
168             broughtSprites[spriteId].owner = kittyOwner;
169             broughtSprites[spriteId].spriteImageID = uint(block.blockhash(block.number-1))%360 + 1;
170             
171             numberOfSpritesOwnedByUser[kittyOwner]++;
172         }
173         
174         totalFeatures++;
175         etherForOwner += msg.value;
176         featuredSprites.push(spriteId);
177     }
178     
179     function calculatePrice (uint kittyId) view returns (uint) {
180         
181         uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(kittyId);
182         
183         var _ownerCut = ((priceIfAny / 1000) * ownerCut) * priceMultiplier / priceDivider;
184         var _charityCut = ((priceIfAny / 1000) * charityCut) * priceMultiplier / priceDivider;
185         
186         return (priceIfAny * priceMultiplier / priceDivider) + _ownerCut + _charityCut;
187         
188     }
189     
190     function buySprite (uint spriteId) payable {
191         
192         uint _ownerCut;
193         uint _charityCut;
194         
195         if (broughtSprites[spriteId].forSale == true) {
196             
197             // Buying a sprite that has been purchased or featured before, from a player of this game who has listed it for sale
198             
199             _ownerCut = ((broughtSprites[spriteId].price / 1000) * ownerCut);
200             _charityCut = ((broughtSprites[spriteId].price / 1000) * charityCut);
201             
202             require (msg.value == broughtSprites[spriteId].price + _ownerCut + _charityCut);
203             
204             broughtSprites[spriteId].owner.transfer(broughtSprites[spriteId].price);
205             
206             numberOfSpritesOwnedByUser[broughtSprites[spriteId].owner]--;
207             
208             if (broughtSprites[spriteId].timesTraded == 0) {
209                 // Featured sprite that is being purchased for the first time
210                 allPurchasedSprites.push(spriteId);
211             }
212             
213             Transfer (broughtSprites[spriteId].owner, msg.sender, spriteId);
214             
215         } else {
216             
217             // Buying a sprite that has never been brought before, from a kitten currently listed for sale in the CryptoKitties contract. The sale price will go to the owner of the kitten in the CryptoKitties contract (who very possibly would have never even heard of this game)
218             
219             require (broughtSprites[spriteId].timesTraded == 0);
220             require (broughtSprites[spriteId].price == 0);
221             
222             // Here we are looking up the price of the Sprite's corresponding Kitty
223             
224             uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(spriteId);
225             require (priceIfAny > 0); // If the kitten in the CryptoKitties contract isn't for sale, a Sprite for it won't be for sale either
226             
227             _ownerCut = ((priceIfAny / 1000) * ownerCut) * priceMultiplier / priceDivider;
228             _charityCut = ((priceIfAny / 1000) * charityCut) * priceMultiplier / priceDivider;
229             
230             // Crypto Kitty prices decrease every few seconds by a fractional amount, so use >=
231             
232             require (msg.value >= (priceIfAny * priceMultiplier / priceDivider) + _ownerCut + _charityCut);
233             
234             // Get the owner of the Kitty for sale
235             
236             var (kittyOwner,,,,) = SaleClockAuction(SaleClockAuctionAddress).getAuction(spriteId);
237             
238             kittyOwner.transfer(priceIfAny * priceMultiplier / priceDivider);
239             
240             allPurchasedSprites.push(spriteId);
241             
242             broughtSprites[spriteId].spriteImageID = uint(block.blockhash(block.number-1))%360 + 1; // Random number to determine what image/character the sprite will be
243             
244             Transfer (kittyOwner, msg.sender, spriteId);
245             
246         }
247         
248         totalBuys++;
249         
250         spriteOwningHistory[msg.sender].push(spriteId);
251         numberOfSpritesOwnedByUser[msg.sender]++;
252         
253         broughtSprites[spriteId].owner = msg.sender;
254         broughtSprites[spriteId].forSale = false;
255         broughtSprites[spriteId].timesTraded++;
256         broughtSprites[spriteId].featured = false;
257             
258         etherForOwner += _ownerCut;
259         etherForCharity += _charityCut;
260         
261     }
262     
263     // Also used to adjust price if already for sale
264     function listSpriteForSale (uint spriteId, uint price) {
265         require (price > 0);
266         if (broughtSprites[spriteId].owner != msg.sender) {
267             require (broughtSprites[spriteId].timesTraded == 0);
268             
269             // This will be the owner of a Crypto Kitty, who can control the price of their unbrought Sprite
270             address kittyOwner = KittyCore(KittyCoreAddress).ownerOf(spriteId);
271             require (kittyOwner == msg.sender);
272             
273             broughtSprites[spriteId].owner = msg.sender;
274             broughtSprites[spriteId].spriteImageID = uint(block.blockhash(block.number-1))%360 + 1; 
275         }
276         broughtSprites[spriteId].forSale = true;
277         broughtSprites[spriteId].price = price;
278     }
279     
280     function removeSpriteFromSale (uint spriteId) {
281         if (broughtSprites[spriteId].owner != msg.sender) {
282             require (broughtSprites[spriteId].timesTraded == 0);
283             address kittyOwner = KittyCore(KittyCoreAddress).ownerOf(spriteId);
284             require (kittyOwner == msg.sender);
285             broughtSprites[spriteId].price = 1; // When a user buys a Sprite Id that isn't for sale in the buySprite() function (ie. would be a Sprite that's never been brought before, for a Crypto Kitty that's for sale), one of the requirements is broughtSprites[spriteId].price == 0, which will be the case by default. By making the price = 1 this will throw and the Sprite won't be able to be brought
286         } 
287         broughtSprites[spriteId].forSale = false;
288     }
289     
290     // The following functions are in case a different contract wants to pull this data, which requires a function returning it (even if the variables are public) since solidity contracts can't directly pull storage of another contract
291     
292     function featuredSpritesLength() view external returns (uint) {
293         return featuredSprites.length;
294     }
295     
296     function usersSpriteOwningHistory (address user) view external returns (uint[]) {
297         return spriteOwningHistory[user];
298     }
299     
300     function lookupSprite (uint spriteId) view external returns (address, uint, bool, uint, uint, bool) {
301         return (broughtSprites[spriteId].owner, broughtSprites[spriteId].spriteImageID, broughtSprites[spriteId].forSale, broughtSprites[spriteId].price, broughtSprites[spriteId].timesTraded, broughtSprites[spriteId].featured);
302     }
303     
304     function lookupFeaturedSprites (uint _index) view external returns (uint) {
305         return featuredSprites[_index];
306     }
307     
308     function lookupAllSprites (uint _index) view external returns (uint) {
309         return allPurchasedSprites[_index];
310     }
311     
312     // Will call SaleClockAuction to get the owner of a kitten and check its price (if it's for sale). We're calling the getAuction() function in the SaleClockAuction to get the kitty owner (that function returns 5 variables, we only want the owner). ownerOf() in the KittyCore contract won't return the kitty owner if the kitty is for sale, and this probably won't be used (including it in case it's needed to lookup an owner of a kitty not for sale later for any reason)
313     
314     function lookupKitty (uint kittyId) view returns (address, uint, address) {
315         
316         var (kittyOwner,,,,) = SaleClockAuction(SaleClockAuctionAddress).getAuction(kittyId);
317 
318         uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(kittyId);
319         
320         address kittyOwnerNotForSale = KittyCore(KittyCoreAddress).ownerOf(kittyId);
321 
322         return (kittyOwner, priceIfAny, kittyOwnerNotForSale);
323 
324     }
325     
326     // The below two functions will pull all info of a kitten. Split into two functions otherwise stack too deep errors. These may not even be needed, may just be used so the website can display all info of a kitten when someone looks it up.
327     
328     function lookupKittyDetails1 (uint kittyId) view returns (bool, bool, uint, uint, uint) {
329         
330         var (isGestating, isReady, cooldownIndex, nextActionAt, siringWithId,,,,,) = KittyCore(KittyCoreAddress).getKitty(kittyId);
331         
332         return (isGestating, isReady, cooldownIndex, nextActionAt, siringWithId);
333         
334     }
335     
336     function lookupKittyDetails2 (uint kittyId) view returns (uint, uint, uint, uint, uint) {
337         
338         var(,,,,,birthTime, matronId, sireId, generation, genes) = KittyCore(KittyCoreAddress).getKitty(kittyId);
339         
340         return (birthTime, matronId, sireId, generation, genes);
341         
342     }
343     
344     // ERC-721 required functions below
345     
346     string public name = 'Crypto Sprites';
347     string public symbol = 'CRS';
348     uint8 public decimals = 0; // Sprites are non-fungible, ie. can't be divided into pieces
349     
350     function name() public view returns (string) {
351         return name;
352     }
353     
354     function symbol() public view returns (string) {
355         return symbol;
356     }
357     
358     function totalSupply() public view returns (uint) {
359         return allPurchasedSprites.length;
360     }
361     
362     function balanceOf (address _owner) public view returns (uint) {
363         return numberOfSpritesOwnedByUser[_owner];
364     }
365     
366     function ownerOf (uint _tokenId) external view returns (address){
367         return broughtSprites[_tokenId].owner;
368     }
369     
370     function approve (address _to, uint256 _tokenId) external {
371         require (broughtSprites[_tokenId].owner == msg.sender);
372         require (addressToReceiverToAllowedSprite[msg.sender][_to][_tokenId] == false);
373         addressToReceiverToAllowedSprite[msg.sender][_to][_tokenId] = true;
374         addressToReceiverToAmountAllowed[msg.sender][_to]++;
375         Approval (msg.sender, _to, _tokenId);
376     }
377     
378     function disapprove (address _to, uint256 _tokenId) external {
379         require (broughtSprites[_tokenId].owner == msg.sender);
380         require (addressToReceiverToAllowedSprite[msg.sender][_to][_tokenId] == true); // Else the next line may be 0 - 1 and underflow
381         addressToReceiverToAmountAllowed[msg.sender][_to]--;
382         addressToReceiverToAllowedSprite[msg.sender][_to][_tokenId] = false;
383     }
384     
385     // Not strictly necessary - this can be done with transferFrom() as well
386     function takeOwnership (uint256 _tokenId) external {
387         require (addressToReceiverToAllowedSprite[broughtSprites[_tokenId].owner][msg.sender][_tokenId] == true);
388         addressToReceiverToAllowedSprite[broughtSprites[_tokenId].owner][msg.sender][_tokenId] = false;
389         addressToReceiverToAmountAllowed[broughtSprites[_tokenId].owner][msg.sender]--;
390         numberOfSpritesOwnedByUser[broughtSprites[_tokenId].owner]--;
391         numberOfSpritesOwnedByUser[msg.sender]++;
392         spriteOwningHistory[msg.sender].push(_tokenId);
393         Transfer (broughtSprites[_tokenId].owner, msg.sender, _tokenId);
394         broughtSprites[_tokenId].owner = msg.sender;
395     }
396     
397     function transfer (address _to, uint _tokenId) external {
398         require (broughtSprites[_tokenId].owner == msg.sender);
399         broughtSprites[_tokenId].owner = _to;
400         numberOfSpritesOwnedByUser[msg.sender]--;
401         numberOfSpritesOwnedByUser[_to]++;
402         spriteOwningHistory[_to].push(_tokenId);
403         Transfer (msg.sender, _to, _tokenId);
404     }
405 
406     function transferFrom (address _from, address _to, uint256 _tokenId) external {
407         require (addressToReceiverToAllowedSprite[_from][msg.sender][_tokenId] == true);
408         require (broughtSprites[_tokenId].owner == _from);
409         addressToReceiverToAllowedSprite[_from][msg.sender][_tokenId] = false;
410         addressToReceiverToAmountAllowed[_from][msg.sender]--;
411         numberOfSpritesOwnedByUser[_from]--;
412         numberOfSpritesOwnedByUser[_to]++;
413         spriteOwningHistory[_to].push(_tokenId);
414         broughtSprites[_tokenId].owner = _to;
415         Transfer (_from, _to, _tokenId);
416     }
417     
418     function allowance (address _owner, address _spender) view returns (uint) {
419         return addressToReceiverToAmountAllowed[_owner][_spender];
420     }
421     
422     function supportsInterface (bytes4 _interfaceID) external view returns (bool) {
423         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
424     }
425     
426 }