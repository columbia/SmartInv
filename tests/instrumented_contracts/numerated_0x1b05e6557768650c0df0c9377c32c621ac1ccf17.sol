1 pragma solidity ^0.4.18;
2 
3 contract NFTHouseGame {
4     struct Listing {
5         uint startPrice;
6         uint endPrice;
7         uint startedAt;
8         uint endsAt;
9         bool isAvailable;
10     }
11 
12     enum HouseClasses {
13         Shack,
14         Apartment,
15         Bungalow,
16         House,
17         Mansion,
18         Estate,
19         Penthouse,
20         Ashes
21     }
22 
23     struct House {
24         address owner;
25         uint streetNumber;
26         string streetName;
27         string streetType;
28         string colorCode;
29         uint numBedrooms;
30         uint numBathrooms;
31         uint squareFootage;
32         uint propertyValue;
33         uint statusValue;
34         HouseClasses class;
35         uint classVariant;
36     }
37 
38     struct Trait {
39         string name;
40         bool isNegative;
41     }
42 
43     address public gameOwner;
44     address public gameDeveloper;
45 
46     uint public presaleSales;
47     uint public presaleLimit = 5000;
48     bool public presaleOngoing = true;
49     uint presaleDevFee = 20;
50     uint presaleProceeds;
51     uint presaleDevPayout;
52 
53     uint public buildPrice = 150 finney;
54     uint public additionPrice = 100 finney;
55     uint public saleFee = 2; // percent
56 
57     House[] public houses;
58     Trait[] public traits;
59 
60     mapping (uint => uint[4]) public houseTraits;
61     mapping (uint => Listing) public listings;
62 
63     mapping (address => uint) public ownedHouses;
64     mapping (uint => uint) public classVariants;
65     mapping (uint => address) approvedTransfers;
66 
67     string[] colors = ["e96b63"];
68     string[] streetNames = ["Main"];
69     string[] streetTypes = ["Street"];
70 
71     modifier onlyBy(address _authorized) {
72         require(msg.sender == _authorized);
73         _;
74     }
75 
76     modifier onlyByOwnerOrDev {
77         require(msg.sender == gameOwner || msg.sender == gameDeveloper);
78         _;
79     }
80 
81     modifier onlyByAssetOwner(uint _tokenId) {
82         require(ownerOf(_tokenId) == msg.sender);
83         _;
84     }
85 
86     modifier onlyDuringPresale {
87         require(presaleOngoing);
88         _;
89     }
90 
91     function NFTHouseGame() public {
92         gameOwner = msg.sender;
93         gameDeveloper = msg.sender;
94 
95         presaleOngoing = true;
96         presaleLimit = 5000;
97         presaleDevFee = 20;
98 
99         buildPrice = 150 finney;
100         additionPrice = 10 finney;
101         saleFee = 2;
102     }
103 
104     /* ERC-20 Compatibility */
105     function name() pure public returns (string) {
106         return "SubPrimeCrypto";
107     }
108 
109     function symbol() pure public returns (string) {
110        return "HOUSE";
111     }
112 
113     function totalSupply() view public returns (uint) {
114         return houses.length;
115     }
116 
117     function balanceOf(address _owner) constant public returns (uint) {
118         return ownedHouses[_owner];
119     }
120 
121     /* ERC-20 + ERC-721 Token Events */
122     event Transfer(address indexed _from, address indexed _to, uint _numTokens);
123     event Approval(address indexed _owner, address indexed _approved, uint _tokenId);
124 
125     /* ERC-721 Token Ownership */
126     function ownerOf(uint _tokenId) constant public returns (address) {
127         return houses[_tokenId].owner;
128     }
129 
130     function approve(address _to, uint _tokenId) onlyByAssetOwner(_tokenId) public {
131         require(msg.sender != _to);
132         approvedTransfers[_tokenId] = _to;
133         Approval(msg.sender, _to, _tokenId);
134     }
135 
136     function approveAndTransfer(address _to, uint _tokenId) internal {
137       House storage house = houses[_tokenId];
138 
139       address oldOwner = house.owner;
140       address newOwner = _to;
141 
142       ownedHouses[oldOwner]--;
143       ownedHouses[newOwner]++;
144       house.owner = newOwner;
145 
146       Approval(oldOwner, newOwner, _tokenId);
147       Transfer(oldOwner, newOwner, 1);
148     }
149 
150     function takeOwnership(uint _tokenId) public {
151         House storage house = houses[_tokenId];
152 
153         address oldOwner = house.owner;
154         address newOwner = msg.sender;
155 
156         require(approvedTransfers[_tokenId] == newOwner);
157 
158         ownedHouses[oldOwner] -= 1;
159         ownedHouses[newOwner] += 1;
160         house.owner = newOwner;
161 
162         Transfer(oldOwner, newOwner, 1);
163     }
164 
165     function transfer(address _to, uint _tokenId) public {
166         House storage house = houses[_tokenId];
167 
168         address oldOwner = house.owner;
169         address newOwner = _to;
170 
171         require(oldOwner != newOwner);
172         require(
173             (msg.sender == oldOwner) ||
174             (approvedTransfers[_tokenId] == newOwner)
175         );
176 
177         ownedHouses[oldOwner]--;
178         ownedHouses[newOwner]++;
179         house.owner = newOwner;
180 
181         Transfer(oldOwner, newOwner, 1);
182     }
183 
184     /* Token-Specific Events */
185     event Minted(uint _tokenId);
186     event Upgraded(uint _tokenId);
187     event Destroyed(uint _tokenId);
188 
189     /* Public Functionality */
190     function buildHouse() payable public {
191         require(
192           msg.value >= buildPrice ||
193           msg.sender == gameOwner ||
194           msg.sender == gameDeveloper
195         );
196 
197         if (presaleOngoing) {
198           presaleSales++;
199           presaleProceeds += msg.value;
200         }
201 
202         generateHouse(msg.sender);
203     }
204 
205     function buildAddition(uint _tokenId) onlyByAssetOwner(_tokenId) payable public {
206         House storage house = houses[_tokenId];
207         require(msg.value >= additionPrice);
208 
209         if (presaleOngoing) presaleProceeds += msg.value;
210 
211         house.numBedrooms += (msg.value / additionPrice);
212         processUpgrades(house);
213     }
214 
215     function burnForInsurance(uint _tokenId) onlyByAssetOwner(_tokenId) public {
216         House storage house = houses[_tokenId];
217         uint rand = notRandomWithSeed(1000, _tokenId);
218 
219         // 80% chance "claim" is investigated
220         if (rand > 799) {
221             upgradeAsset(_tokenId);
222         } else {
223             // investigations yield equal chance of upgrade or permanent loss
224             if (rand > 499) {
225                 upgradeAsset(_tokenId);
226             } else {
227                 house.class = HouseClasses.Ashes;
228                 house.statusValue = 0;
229                 house.numBedrooms = 0;
230                 house.numBathrooms = 0;
231                 house.propertyValue = 0;
232                 Destroyed(_tokenId);
233             }
234         }
235     }
236 
237     function purchaseAsset(uint _tokenId) payable public {
238         Listing storage listing = listings[_tokenId];
239 
240         uint currentPrice = calculateCurrentPrice(listing);
241         require(msg.value >= currentPrice);
242 
243         require(listing.isAvailable && listing.endsAt > now);
244         listing.isAvailable = false;
245 
246         if (presaleOngoing && (++presaleSales >= presaleLimit)) {
247           presaleOngoing = false;
248         }
249 
250         if (houses[_tokenId].owner != address(this)) {
251             uint fee = currentPrice / (100 / saleFee);
252             uint sellerProceeds = currentPrice - fee;
253             presaleProceeds += (msg.value - sellerProceeds);
254             houses[_tokenId].owner.transfer(sellerProceeds);
255         } else {
256             presaleProceeds += msg.value;
257         }
258 
259         approveAndTransfer(msg.sender, _tokenId);
260     }
261 
262     function listAsset(uint _tokenId, uint _startPrice, uint _endPrice, uint _numDays) onlyByAssetOwner(_tokenId) public {
263         createListing(_tokenId, _startPrice, _endPrice, _numDays);
264     }
265 
266     function removeAssetListing(uint _tokenId) public onlyByAssetOwner(_tokenId) {
267         listings[_tokenId].isAvailable = false;
268     }
269 
270     function getHouseTraits(uint _tokenId) public view returns (uint[4]) {
271         return houseTraits[_tokenId];
272     }
273 
274     function getTraitCount() public view returns (uint) {
275         return traits.length;
276     }
277 
278     /* Admin Functionality */
279     function addNewColor(string _colorCode) public onlyByOwnerOrDev {
280         colors[colors.length++] = _colorCode;
281     }
282 
283     function addNewTrait(string _name, bool _isNegative) public onlyByOwnerOrDev {
284         uint traitId = traits.length++;
285         traits[traitId].name = _name;
286         traits[traitId].isNegative = _isNegative;
287     }
288 
289     function addNewStreetName(string _name) public onlyByOwnerOrDev {
290         streetNames[streetNames.length++] = _name;
291     }
292 
293     function addNewStreetType(string _type) public onlyByOwnerOrDev {
294         streetTypes[streetTypes.length++] = _type;
295     }
296 
297     function generatePresaleHouse() onlyByOwnerOrDev onlyDuringPresale public {
298         uint houseId = generateHouse(this);
299         uint sellPrice = (houses[houseId].propertyValue / 5000) * 1 finney;
300 
301         if (sellPrice > 250 finney) sellPrice = 250 finney;
302         if (sellPrice < 50 finney) sellPrice = 50 finney;
303 
304         createListing(houseId, sellPrice, 0, 30);
305     }
306 
307     function setVariantCount(uint _houseClass, uint _variantCount) public onlyByOwnerOrDev {
308         classVariants[_houseClass] = _variantCount;
309     }
310 
311     function withdrawFees(address _destination) public onlyBy(gameOwner) {
312         uint remainingPresaleProceeds = presaleProceeds - presaleDevPayout;
313         uint devsShare = remainingPresaleProceeds / (100 / presaleDevFee);
314 
315         if (devsShare > 0) {
316           presaleDevPayout += devsShare;
317           gameDeveloper.transfer(devsShare);
318         }
319 
320         _destination.transfer(this.balance);
321     }
322 
323     function withdrawDevFees(address _destination) public onlyBy(gameDeveloper) {
324         uint remainingPresaleProceeds = presaleProceeds - presaleDevPayout;
325         uint devsShare = remainingPresaleProceeds / (100 / presaleDevFee);
326 
327         if (devsShare > 0) {
328           presaleDevPayout += devsShare;
329           _destination.transfer(devsShare);
330         }
331     }
332 
333     function transferGameOwnership(address _newOwner) public onlyBy(gameOwner) {
334         gameOwner = _newOwner;
335     }
336 
337     /* Internal Functionality */
338     function generateHouse(address owner) internal returns (uint houseId) {
339         houseId = houses.length++;
340 
341         HouseClasses houseClass = randomHouseClass();
342         uint numBedrooms = randomBedrooms(houseClass);
343         uint numBathrooms = randomBathrooms(numBedrooms);
344         uint squareFootage = calculateSquareFootage(houseClass, numBedrooms, numBathrooms);
345         uint propertyValue = calculatePropertyValue(houseClass, squareFootage, numBathrooms, numBedrooms);
346 
347         houses[houseId] = House({
348           owner: owner,
349           class: houseClass,
350           streetNumber: notRandomWithSeed(9999, squareFootage + houseId),
351           streetName: streetNames[notRandom(streetNames.length)],
352           streetType: streetTypes[notRandom(streetTypes.length)],
353           propertyValue: propertyValue,
354           statusValue: propertyValue / 10000,
355           colorCode: colors[notRandom(colors.length)],
356           numBathrooms: numBathrooms,
357           numBedrooms: numBedrooms,
358           squareFootage: squareFootage,
359           classVariant: randomClassVariant(houseClass)
360         });
361 
362         houseTraits[houseId] = [
363             notRandomWithSeed(traits.length, propertyValue + houseId * 5),
364             notRandomWithSeed(traits.length, squareFootage + houseId * 4),
365             notRandomWithSeed(traits.length, numBathrooms + houseId * 3),
366             notRandomWithSeed(traits.length, numBedrooms + houseId * 2)
367         ];
368 
369         ownedHouses[owner]++;
370         Minted(houseId);
371         Transfer(address(0), owner, 1);
372 
373         return houseId;
374     }
375 
376     function createListing(uint tokenId, uint startPrice, uint endPrice, uint numDays) internal {
377         listings[tokenId] = Listing({
378           startPrice: startPrice,
379           endPrice: endPrice,
380           startedAt: now,
381           endsAt: now + (numDays * 24 hours),
382           isAvailable: true
383         });
384     }
385 
386     function calculateCurrentPrice(Listing listing) internal view returns (uint) {
387         if (listing.endPrice != listing.startPrice) {
388           uint numberOfPeriods = listing.endsAt - listing.startedAt;
389           uint currentPeriod = (now - listing.startedAt) / numberOfPeriods;
390           return currentPeriod * (listing.startPrice + listing.endPrice);
391         } else {
392           return listing.startPrice;
393         }
394     }
395 
396     function calculatePropertyValue(HouseClasses houseClass, uint squareFootage, uint numBathrooms, uint numBedrooms) pure internal returns (uint) {
397         uint propertyValue = (uint(houseClass) + 1) * 10;
398         propertyValue += (numBathrooms + 1) * 10;
399         propertyValue += (numBedrooms + 1) * 25;
400         propertyValue += squareFootage * 25;
401         propertyValue *= 5;
402 
403         return uint(houseClass) > 4 ? propertyValue * 5 : propertyValue;
404     }
405 
406     function randomHouseClass() internal view returns (HouseClasses) {
407         uint rand = notRandom(1000);
408 
409         if (rand < 300) {
410             return HouseClasses.Shack;
411         } else if (rand > 300 && rand < 550) {
412             return HouseClasses.Apartment;
413         } else if (rand > 550 && rand < 750) {
414             return HouseClasses.Bungalow;
415         } else if (rand > 750 && rand < 900) {
416             return HouseClasses.House;
417         } else {
418             return HouseClasses.Mansion;
419         }
420     }
421 
422     function randomClassVariant(HouseClasses houseClass) internal view returns (uint) {
423         uint possibleVariants = 10;
424         if (classVariants[uint(houseClass)] != 0) possibleVariants = classVariants[uint(houseClass)];
425         return notRandom(possibleVariants);
426     }
427 
428     function randomBedrooms(HouseClasses houseClass) internal view returns (uint) {
429         uint class = uint(houseClass);
430         return class >= 1 ? class + notRandom(4) : 0;
431     }
432 
433     function randomBathrooms(uint numBedrooms) internal view returns (uint) {
434         return numBedrooms < 2 ? numBedrooms : numBedrooms - notRandom(3);
435     }
436 
437     function calculateSquareFootage(HouseClasses houseClass, uint numBedrooms, uint numBathrooms) internal pure returns (uint) {
438         uint baseSqft = uint(houseClass) >= 4 ? 50 : 25;
439         uint multiplier = uint(houseClass) + 1;
440 
441         uint bedroomSqft = (numBedrooms + 1) * 10 * baseSqft;
442         uint bathroomSqft = (numBathrooms + 1) * 5 * baseSqft;
443 
444         return (bedroomSqft + bathroomSqft) * multiplier;
445     }
446 
447     function upgradeAsset(uint tokenId) internal {
448         House storage house = houses[tokenId];
449 
450         if (uint(house.class) < 5) {
451           house.class = HouseClasses(uint(house.class) + 1);
452         }
453 
454         house.numBedrooms++;
455         house.numBathrooms++;
456         processUpgrades(house);
457         Upgraded(tokenId);
458     }
459 
460     function processUpgrades(House storage house) internal {
461         uint class = uint(house.class);
462         if (class <= house.numBedrooms) {
463             house.class = HouseClasses.Bungalow;
464         } else if (class < 2 && house.numBedrooms > 5) {
465             house.class = HouseClasses.Penthouse;
466         } else if (class < 4 && house.numBedrooms > 10) {
467             house.class = HouseClasses.Mansion;
468         } else if (class < 6 && house.numBedrooms > 15) {
469             house.class = HouseClasses.Estate;
470         }
471 
472         house.squareFootage = calculateSquareFootage(
473           house.class, house.numBedrooms, house.numBathrooms
474         );
475 
476         house.propertyValue = calculatePropertyValue(
477           house.class, house.squareFootage, house.numBathrooms, house.numBedrooms
478         );
479 
480         house.statusValue += house.statusValue / 10;
481     }
482 
483     function notRandom(uint lessThan) public view returns (uint) {
484         return uint(keccak256(
485             (houses.length + 1) + (tx.gasprice * lessThan) +
486             (block.difficulty * block.number + now) * msg.gas
487         )) % lessThan;
488     }
489 
490     function notRandomWithSeed(uint lessThan, uint seed) public view returns (uint) {
491         return uint(keccak256(
492             seed + block.gaslimit + block.number
493         )) % lessThan;
494     }
495 }