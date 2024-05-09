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
119         etherForOwner += msg.value;
120     }
121     
122     function adjustDefaultSpritePrice (uint _priceMultiplier, uint _priceDivider) onlyOwner {
123         require (_priceMultiplier > 0);
124         require (_priceDivider > 0);
125         priceMultiplier = _priceMultiplier;
126         priceDivider = _priceDivider;
127     }
128     
129     function adjustCut (uint _ownerCut, uint _charityCut) onlyOwner {
130         require (_ownerCut + _charityCut < 51); // Keep this contract honest by allowing the maximum combined cut to be no more than 5% (50/1000) of sales
131         ownerCut = _ownerCut;
132         charityCut = _charityCut;
133     }
134     
135     function adjustFeaturePrice (uint _featurePrice) onlyOwner {
136         require (_featurePrice > 0);
137         featurePrice = _featurePrice;
138     }
139     
140     function withdraw() onlyOwner {
141         owner.transfer(etherForOwner);
142         charityAddress.transfer(etherForCharity);
143         etherForOwner = 0;
144         etherForCharity = 0;
145     }
146     
147     function changeOwner (address _owner) onlyOwner {
148         owner = _owner;
149     }
150     
151     function featureSprite (uint spriteId) payable {
152         // Do not need to require user to be the owner of a Sprite to feature it
153         // require (msg.sender == broughtSprites[spriteId].owner);
154         require (msg.value == featurePrice);
155         broughtSprites[spriteId].featured = true;
156 
157         if (broughtSprites[spriteId].timesTraded == 0) {
158             var (kittyOwner,,,,) = SaleClockAuction(SaleClockAuctionAddress).getAuction(spriteId);
159             uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(spriteId);
160             address kittyOwnerNotForSale = KittyCore(KittyCoreAddress).ownerOf(spriteId);
161             
162             // When featuring a Sprite that hasn't been traded before, if the original Kitty is for sale, update this Sprite with a price and set forSale = true - as long as msg.sender is the owner of the Kitty. Otherwise it could be that the owner of the Kitty removed the Sprite for sale and a different user could feature the Sprite and have it listed for sale
163             if (priceIfAny > 0 && msg.sender == kittyOwner) {
164                 broughtSprites[spriteId].price = priceIfAny * priceMultiplier / priceDivider;
165                 broughtSprites[spriteId].forSale = true;
166                 broughtSprites[spriteId].owner = kittyOwner;
167                 numberOfSpritesOwnedByUser[msg.sender]++;
168             } else if (kittyOwnerNotForSale == msg.sender) {
169                 // User featuring the sprite owns its kitty, but hasn't listed the kitty for sale
170                 broughtSprites[spriteId].owner = kittyOwnerNotForSale;
171                 numberOfSpritesOwnedByUser[msg.sender]++;
172             }
173             
174             broughtSprites[spriteId].spriteImageID = uint(block.blockhash(block.number-1))%360 + 1;
175             
176         }
177         
178         totalFeatures++;
179         etherForOwner += msg.value;
180         featuredSprites.push(spriteId);
181     }
182     
183     function calculatePrice (uint kittyId) view returns (uint) {
184         
185         uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(kittyId);
186         
187         var _ownerCut = ((priceIfAny / 1000) * ownerCut) * priceMultiplier / priceDivider;
188         var _charityCut = ((priceIfAny / 1000) * charityCut) * priceMultiplier / priceDivider;
189         
190         return (priceIfAny * priceMultiplier / priceDivider) + _ownerCut + _charityCut;
191         
192     }
193     
194     function buySprite (uint spriteId) payable {
195         
196         uint _ownerCut;
197         uint _charityCut;
198         
199         if (broughtSprites[spriteId].forSale == true) {
200             
201             // Buying a sprite that has been purchased or featured before, from a player of this game who has listed it for sale
202             
203             _ownerCut = ((broughtSprites[spriteId].price / 1000) * ownerCut);
204             _charityCut = ((broughtSprites[spriteId].price / 1000) * charityCut);
205             
206             require (msg.value == broughtSprites[spriteId].price + _ownerCut + _charityCut);
207             
208             broughtSprites[spriteId].owner.transfer(broughtSprites[spriteId].price);
209             
210             numberOfSpritesOwnedByUser[broughtSprites[spriteId].owner]--;
211             
212             if (broughtSprites[spriteId].timesTraded == 0) {
213                 // Featured sprite that is being purchased for the first time
214                 allPurchasedSprites.push(spriteId);
215             }
216             
217             Transfer (broughtSprites[spriteId].owner, msg.sender, spriteId);
218             
219         } else {
220             
221             // Buying a sprite that has never been brought before, from a kitten currently listed for sale in the CryptoKitties contract. The sale price will go to the owner of the kitten in the CryptoKitties contract (who very possibly would have never even heard of this game)
222             
223             require (broughtSprites[spriteId].timesTraded == 0);
224             require (broughtSprites[spriteId].price == 0);
225             
226             // Here we are looking up the price of the Sprite's corresponding Kitty
227             
228             uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(spriteId);
229             require (priceIfAny > 0); // If the kitten in the CryptoKitties contract isn't for sale, a Sprite for it won't be for sale either
230             
231             _ownerCut = ((priceIfAny / 1000) * ownerCut) * priceMultiplier / priceDivider;
232             _charityCut = ((priceIfAny / 1000) * charityCut) * priceMultiplier / priceDivider;
233             
234             // Crypto Kitty prices decrease every few seconds by a fractional amount, so use >=
235             
236             require (msg.value >= (priceIfAny * priceMultiplier / priceDivider) + _ownerCut + _charityCut);
237             
238             // Get the owner of the Kitty for sale
239             
240             var (kittyOwner,,,,) = SaleClockAuction(SaleClockAuctionAddress).getAuction(spriteId);
241             
242             kittyOwner.transfer(priceIfAny * priceMultiplier / priceDivider);
243             
244             allPurchasedSprites.push(spriteId);
245             
246             broughtSprites[spriteId].spriteImageID = uint(block.blockhash(block.number-1))%360 + 1; // Random number to determine what image/character the sprite will be
247             
248             Transfer (kittyOwner, msg.sender, spriteId);
249             
250         }
251         
252         totalBuys++;
253         
254         spriteOwningHistory[msg.sender].push(spriteId);
255         numberOfSpritesOwnedByUser[msg.sender]++;
256         
257         broughtSprites[spriteId].owner = msg.sender;
258         broughtSprites[spriteId].forSale = false;
259         broughtSprites[spriteId].timesTraded++;
260         broughtSprites[spriteId].featured = false;
261             
262         etherForOwner += _ownerCut;
263         etherForCharity += _charityCut;
264         
265     }
266     
267     // Also used to adjust price if already for sale
268     function listSpriteForSale (uint spriteId, uint price) {
269         require (price > 0);
270         if (broughtSprites[spriteId].owner != msg.sender) {
271             require (broughtSprites[spriteId].timesTraded == 0);
272             
273             // This will be the owner of a Crypto Kitty, who can control the price of their unbrought Sprite
274             var (kittyOwner,,,,) = SaleClockAuction(SaleClockAuctionAddress).getAuction(spriteId);
275             
276             if (kittyOwner != msg.sender) {
277                 // May be that the kitty owner hasn't listed it for sale, in which case the owner of the kitty has to be retrieved from the KittyCore contract
278                 address kittyOwnerNotForSale = KittyCore(KittyCoreAddress).ownerOf(spriteId);
279                 require (kittyOwnerNotForSale == msg.sender);
280             }
281 
282             broughtSprites[spriteId].owner = msg.sender;
283             broughtSprites[spriteId].spriteImageID = uint(block.blockhash(block.number-1))%360 + 1; 
284         }
285         broughtSprites[spriteId].forSale = true;
286         broughtSprites[spriteId].price = price;
287     }
288     
289     function removeSpriteFromSale (uint spriteId) {
290         if (broughtSprites[spriteId].owner != msg.sender) {
291             require (broughtSprites[spriteId].timesTraded == 0);
292             var (kittyOwner,,,,) = SaleClockAuction(SaleClockAuctionAddress).getAuction(spriteId);
293             
294             if (kittyOwner != msg.sender) {
295                 address kittyOwnerNotForSale = KittyCore(KittyCoreAddress).ownerOf(spriteId);
296                 require (kittyOwnerNotForSale == msg.sender);
297             }
298             
299             broughtSprites[spriteId].price = 1; // When a user buys a Sprite Id that isn't for sale in the buySprite() function (ie. would be a Sprite that's never been brought before, for a Crypto Kitty that's for sale), one of the requirements is broughtSprites[spriteId].price == 0, which will be the case by default. By making the price = 1 this will throw and the Sprite won't be able to be brought
300         } 
301         broughtSprites[spriteId].forSale = false;
302     }
303     
304     // The following functions are in case a different contract wants to pull this data, which requires a function returning it (even if the variables are public) since solidity contracts can't directly pull storage of another contract
305     
306     function featuredSpritesLength() view external returns (uint) {
307         return featuredSprites.length;
308     }
309     
310     function usersSpriteOwningHistory (address user) view external returns (uint[]) {
311         return spriteOwningHistory[user];
312     }
313     
314     function lookupSprite (uint spriteId) view external returns (address, uint, bool, uint, uint, bool) {
315         return (broughtSprites[spriteId].owner, broughtSprites[spriteId].spriteImageID, broughtSprites[spriteId].forSale, broughtSprites[spriteId].price, broughtSprites[spriteId].timesTraded, broughtSprites[spriteId].featured);
316     }
317     
318     function lookupFeaturedSprites (uint _index) view external returns (uint) {
319         return featuredSprites[_index];
320     }
321     
322     function lookupAllSprites (uint _index) view external returns (uint) {
323         return allPurchasedSprites[_index];
324     }
325     
326     // Will call SaleClockAuction to get the owner of a kitten and check its price (if it's for sale). We're calling the getAuction() function in the SaleClockAuction to get the kitty owner (that function returns 5 variables, we only want the owner). ownerOf() in the KittyCore contract won't return the kitty owner if the kitty is for sale, and this probably won't be used (including it in case it's needed to lookup an owner of a kitty not for sale later for any reason)
327     
328     function lookupKitty (uint kittyId) view returns (address, uint, address) {
329         
330         var (kittyOwner,,,,) = SaleClockAuction(SaleClockAuctionAddress).getAuction(kittyId);
331 
332         uint priceIfAny = SaleClockAuction(SaleClockAuctionAddress).getCurrentPrice(kittyId);
333         
334         address kittyOwnerNotForSale = KittyCore(KittyCoreAddress).ownerOf(kittyId);
335 
336         return (kittyOwner, priceIfAny, kittyOwnerNotForSale);
337 
338     }
339     
340     // The below two functions will pull all info of a kitten. Split into two functions otherwise stack too deep errors. These may not even be needed, may just be used so the website can display all info of a kitten when someone looks it up.
341     
342     function lookupKittyDetails1 (uint kittyId) view returns (bool, bool, uint, uint, uint) {
343         
344         var (isGestating, isReady, cooldownIndex, nextActionAt, siringWithId,,,,,) = KittyCore(KittyCoreAddress).getKitty(kittyId);
345         
346         return (isGestating, isReady, cooldownIndex, nextActionAt, siringWithId);
347         
348     }
349     
350     function lookupKittyDetails2 (uint kittyId) view returns (uint, uint, uint, uint, uint) {
351         
352         var(,,,,,birthTime, matronId, sireId, generation, genes) = KittyCore(KittyCoreAddress).getKitty(kittyId);
353         
354         return (birthTime, matronId, sireId, generation, genes);
355         
356     }
357     
358     // ERC-721 required functions below
359     
360     string public name = 'Crypto Sprites';
361     string public symbol = 'CRS';
362     uint8 public decimals = 0; // Sprites are non-fungible, ie. can't be divided into pieces
363     
364     function name() public view returns (string) {
365         return name;
366     }
367     
368     function symbol() public view returns (string) {
369         return symbol;
370     }
371     
372     function totalSupply() public view returns (uint) {
373         return allPurchasedSprites.length;
374     }
375     
376     function balanceOf (address _owner) public view returns (uint) {
377         return numberOfSpritesOwnedByUser[_owner];
378     }
379     
380     function ownerOf (uint _tokenId) external view returns (address){
381         return broughtSprites[_tokenId].owner;
382     }
383     
384     function approve (address _to, uint256 _tokenId) external {
385         require (broughtSprites[_tokenId].owner == msg.sender);
386         require (addressToReceiverToAllowedSprite[msg.sender][_to][_tokenId] == false);
387         addressToReceiverToAllowedSprite[msg.sender][_to][_tokenId] = true;
388         addressToReceiverToAmountAllowed[msg.sender][_to]++;
389         Approval (msg.sender, _to, _tokenId);
390     }
391     
392     function disapprove (address _to, uint256 _tokenId) external {
393         require (broughtSprites[_tokenId].owner == msg.sender);
394         require (addressToReceiverToAllowedSprite[msg.sender][_to][_tokenId] == true); // Else the next line may be 0 - 1 and underflow
395         addressToReceiverToAmountAllowed[msg.sender][_to]--;
396         addressToReceiverToAllowedSprite[msg.sender][_to][_tokenId] = false;
397     }
398     
399     // Not strictly necessary - this can be done with transferFrom() as well
400     function takeOwnership (uint256 _tokenId) external {
401         require (addressToReceiverToAllowedSprite[broughtSprites[_tokenId].owner][msg.sender][_tokenId] == true);
402         addressToReceiverToAllowedSprite[broughtSprites[_tokenId].owner][msg.sender][_tokenId] = false;
403         addressToReceiverToAmountAllowed[broughtSprites[_tokenId].owner][msg.sender]--;
404         numberOfSpritesOwnedByUser[broughtSprites[_tokenId].owner]--;
405         numberOfSpritesOwnedByUser[msg.sender]++;
406         spriteOwningHistory[msg.sender].push(_tokenId);
407         Transfer (broughtSprites[_tokenId].owner, msg.sender, _tokenId);
408         broughtSprites[_tokenId].owner = msg.sender;
409     }
410     
411     function transfer (address _to, uint _tokenId) external {
412         require (broughtSprites[_tokenId].owner == msg.sender);
413         broughtSprites[_tokenId].owner = _to;
414         numberOfSpritesOwnedByUser[msg.sender]--;
415         numberOfSpritesOwnedByUser[_to]++;
416         spriteOwningHistory[_to].push(_tokenId);
417         Transfer (msg.sender, _to, _tokenId);
418     }
419 
420     function transferFrom (address _from, address _to, uint256 _tokenId) external {
421         require (addressToReceiverToAllowedSprite[_from][msg.sender][_tokenId] == true);
422         require (broughtSprites[_tokenId].owner == _from);
423         addressToReceiverToAllowedSprite[_from][msg.sender][_tokenId] = false;
424         addressToReceiverToAmountAllowed[_from][msg.sender]--;
425         numberOfSpritesOwnedByUser[_from]--;
426         numberOfSpritesOwnedByUser[_to]++;
427         spriteOwningHistory[_to].push(_tokenId);
428         broughtSprites[_tokenId].owner = _to;
429         Transfer (_from, _to, _tokenId);
430     }
431     
432     function allowance (address _owner, address _spender) view returns (uint) {
433         return addressToReceiverToAmountAllowed[_owner][_spender];
434     }
435     
436     function supportsInterface (bytes4 _interfaceID) external view returns (bool) {
437         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
438     }
439     
440 }