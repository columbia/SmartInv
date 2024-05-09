1 pragma solidity ^0.4.18;
2 
3 contract SubPrimeCrypto {
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
49 
50     uint public buildPrice = 150 finney;
51     uint public additionPrice = 100 finney;
52     uint public saleFee = 2; // percent
53 
54     House[] public houses;
55     Trait[] public traits;
56 
57     mapping (uint => uint[4]) public houseTraits;
58     mapping (uint => Listing) public listings;
59 
60     mapping (address => uint) public houseCredits;
61     mapping (address => uint) public ownedHouses;
62     mapping (uint => uint) public classVariants;
63     mapping (uint => address) approvedTransfers;
64 
65     string[] colors;
66     string[] streetNames;
67     string[] streetTypes;
68 
69     modifier onlyBy(address _authorized) {
70         require(msg.sender == _authorized);
71         _;
72     }
73 
74     modifier onlyByOwnerOrDev {
75         require(msg.sender == gameOwner || msg.sender == gameDeveloper);
76         _;
77     }
78 
79     modifier onlyByAssetOwner(uint _tokenId) {
80         require(ownerOf(_tokenId) == msg.sender);
81         _;
82     }
83 
84     modifier onlyDuringPresale {
85         require(presaleOngoing);
86         _;
87     }
88 
89     function SubPrimeCrypto() public {
90         gameOwner = msg.sender;
91         gameDeveloper = msg.sender;
92     }
93 
94     /* ERC-20 Compatibility */
95     function name() pure public returns (string) {
96         return "SubPrimeCrypto";
97     }
98 
99     function symbol() pure public returns (string) {
100         return "HOUSE";
101     }
102 
103     function totalSupply() view public returns (uint) {
104         return houses.length;
105     }
106 
107     function balanceOf(address _owner) constant public returns (uint) {
108         return ownedHouses[_owner];
109     }
110 
111     /* ERC-20 + ERC-721 Token Events */
112     event Transfer(address indexed _from, address indexed _to, uint _numTokens);
113     event Approval(address indexed _owner, address indexed _approved, uint _tokenId);
114 
115     /* ERC-721 Token Ownership */
116     function ownerOf(uint _tokenId) constant public returns (address) {
117         return houses[_tokenId].owner;
118     }
119 
120     function approve(address _to, uint _tokenId) onlyByAssetOwner(_tokenId) public {
121         require(msg.sender != _to);
122         approvedTransfers[_tokenId] = _to;
123         Approval(msg.sender, _to, _tokenId);
124     }
125 
126     function approveAndTransfer(address _to, uint _tokenId) internal {
127         House storage house = houses[_tokenId];
128 
129         address oldOwner = house.owner;
130         address newOwner = _to;
131 
132         ownedHouses[oldOwner]--;
133         ownedHouses[newOwner]++;
134         house.owner = newOwner;
135 
136         Approval(oldOwner, newOwner, _tokenId);
137         Transfer(oldOwner, newOwner, 1);
138     }
139 
140     function takeOwnership(uint _tokenId) public {
141         House storage house = houses[_tokenId];
142 
143         address oldOwner = house.owner;
144         address newOwner = msg.sender;
145 
146         require(approvedTransfers[_tokenId] == newOwner);
147 
148         ownedHouses[oldOwner] -= 1;
149         ownedHouses[newOwner] += 1;
150         house.owner = newOwner;
151 
152         Transfer(oldOwner, newOwner, 1);
153     }
154 
155     function transfer(address _to, uint _tokenId) public {
156         House storage house = houses[_tokenId];
157 
158         address oldOwner = house.owner;
159         address newOwner = _to;
160 
161         require(oldOwner != newOwner);
162         require(
163             (msg.sender == oldOwner) ||
164             (approvedTransfers[_tokenId] == newOwner)
165         );
166 
167         ownedHouses[oldOwner]--;
168         ownedHouses[newOwner]++;
169         house.owner = newOwner;
170 
171         Transfer(oldOwner, newOwner, 1);
172     }
173 
174     /* Token-Specific Events */
175     event Minted(uint _tokenId);
176     event Upgraded(uint _tokenId);
177     event Destroyed(uint _tokenId);
178 
179     /* Public Functionality */
180     function buildHouse() payable public {
181         if (houseCredits[msg.sender] > 0) {
182             houseCredits[msg.sender]--;
183         } else {
184             require(msg.value >= buildPrice);
185             if (presaleOngoing) presaleSales++;
186         }
187 
188         generateHouse(msg.sender);
189     }
190 
191     function buildAddition(uint _tokenId) onlyByAssetOwner(_tokenId) payable public {
192         require(msg.value >= additionPrice);
193         House storage house = houses[_tokenId];
194 
195         upgradeAsset(_tokenId, false);
196 
197         house.numBedrooms++;
198         house.numBathrooms++;
199         house.statusValue += house.statusValue / 10;
200 
201         Upgraded(_tokenId);
202     }
203 
204     function burnForInsurance(uint _tokenId) onlyByAssetOwner(_tokenId) public {
205         House storage house = houses[_tokenId];
206         uint rand = notRandomWithSeed(1000, _tokenId);
207 
208         // 80% chance "claim" is investigated
209         if (rand > 799) {
210             upgradeAsset(_tokenId, true);
211         } else {
212             // investigations yield equal chance of upgrade or permanent loss
213             if (rand > 499) {
214                 upgradeAsset(_tokenId, true);
215             } else {
216                 house.class = HouseClasses.Ashes;
217                 house.statusValue = 0;
218                 house.numBedrooms = 0;
219                 house.numBathrooms = 0;
220                 house.propertyValue = 0;
221                 Destroyed(_tokenId);
222             }
223         }
224     }
225 
226     function purchaseAsset(uint _tokenId) payable public {
227         Listing storage listing = listings[_tokenId];
228 
229         uint currentPrice = calculateCurrentPrice(listing);
230         require(currentPrice > 0 && msg.value >= currentPrice);
231         require(listing.isAvailable && listing.endsAt > now);
232         listing.isAvailable = false;
233 
234         if (houses[_tokenId].owner != address(this)) {
235             uint fee = currentPrice / (100 / saleFee);
236             houses[_tokenId].owner.transfer(currentPrice - fee);
237         } else {
238             if (++presaleSales >= presaleLimit) {
239                 presaleOngoing = false;
240             }
241         }
242 
243         approveAndTransfer(msg.sender, _tokenId);
244     }
245 
246     function listAsset(uint _tokenId, uint _startPrice, uint _endPrice, uint _numHours) onlyByAssetOwner(_tokenId) public {
247         createListing(_tokenId, _startPrice, _endPrice, _numHours);
248     }
249 
250     function removeAssetListing(uint _tokenId) public onlyByAssetOwner(_tokenId) {
251         listings[_tokenId].isAvailable = false;
252     }
253 
254     function getHouseTraits(uint _tokenId) public view returns (uint[4]) {
255         return houseTraits[_tokenId];
256     }
257 
258     function getTraitCount() public view returns (uint) {
259         return traits.length;
260     }
261 
262     /* Admin Functionality */
263     function addNewColor(string _colorCode) public onlyByOwnerOrDev {
264         colors[colors.length++] = _colorCode;
265     }
266 
267     function addNewTrait(string _name, bool _isNegative) public onlyByOwnerOrDev {
268         uint traitId = traits.length++;
269         traits[traitId].name = _name;
270         traits[traitId].isNegative = _isNegative;
271     }
272 
273     function add5NewTraits(string _one, string _two, string _three, string _four, string _five, bool _isNegative) public onlyByOwnerOrDev {
274         addNewTrait(_one, _isNegative);
275         addNewTrait(_two, _isNegative);
276         addNewTrait(_three, _isNegative);
277         addNewTrait(_four, _isNegative);
278         addNewTrait(_five, _isNegative);
279     }
280 
281     function addNewStreetName(string _name) public onlyByOwnerOrDev {
282         streetNames[streetNames.length++] = _name;
283     }
284 
285     function add5NewStreetNames(string _one, string _two, string _three, string _four, string _five) public onlyByOwnerOrDev {
286         addNewStreetName(_one);
287         addNewStreetName(_two);
288         addNewStreetName(_three);
289         addNewStreetName(_four);
290         addNewStreetName(_five);
291     }
292 
293     function addNewStreetType(string _type) public onlyByOwnerOrDev {
294         streetTypes[streetTypes.length++] = _type;
295     }
296 
297     function addHouseCredits(address _address, uint _numCredits) public onlyByOwnerOrDev {
298         houseCredits[_address] += _numCredits;
299     }
300 
301     function generatePresaleHouses() public onlyByOwnerOrDev onlyDuringPresale {
302         uint initialGas = msg.gas;
303         generateAndListPresaleHouse();
304 
305         while (msg.gas > (initialGas - msg.gas)) {
306             generateAndListPresaleHouse();
307         }
308     }
309 
310     function setBuildPrice(uint _buildPrice) public onlyBy(gameOwner) {
311         buildPrice = _buildPrice;
312     }
313 
314     function setAdditionPrice(uint _additionPrice) public onlyBy(gameOwner) {
315         additionPrice = _additionPrice;
316     }
317 
318     function setSaleFee(uint _saleFee) public onlyBy(gameOwner) {
319         saleFee = _saleFee;
320     }
321 
322     function setVariantCount(uint _houseClass, uint _variantCount) public onlyByOwnerOrDev {
323         classVariants[_houseClass] = _variantCount;
324     }
325 
326     function withdrawFees() public onlyByOwnerOrDev {
327         if (presaleOngoing) gameDeveloper.transfer(this.balance / 5);
328         gameOwner.transfer(this.balance);
329     }
330 
331     function transferGameOwnership(address _newOwner) public onlyBy(gameOwner) {
332         gameOwner = _newOwner;
333     }
334 
335     /* Internal Functionality */
336     function generateHouse(address owner) internal returns (uint houseId) {
337         houseId = houses.length++;
338 
339         HouseClasses houseClass = randomHouseClass();
340         uint numBedrooms = randomBedrooms(houseClass);
341         uint numBathrooms = randomBathrooms(numBedrooms);
342         uint squareFootage = calculateSquareFootage(houseClass, numBedrooms, numBathrooms);
343         uint propertyValue = calculatePropertyValue(houseClass, squareFootage, numBathrooms, numBedrooms);
344 
345         houses[houseId] = House({
346             owner: owner,
347             class: houseClass,
348             streetNumber: notRandomWithSeed(9999, squareFootage + houseId),
349             streetName: streetNames[notRandom(streetNames.length)],
350             streetType: streetTypes[notRandom(streetTypes.length)],
351             propertyValue: propertyValue,
352             statusValue: propertyValue / 10000,
353             colorCode: colors[notRandom(colors.length)],
354             numBathrooms: numBathrooms,
355             numBedrooms: numBedrooms,
356             squareFootage: squareFootage,
357             classVariant: randomClassVariant(houseClass)
358         });
359 
360         houseTraits[houseId] = [
361             notRandomWithSeed(traits.length, propertyValue + houseId * 5),
362             notRandomWithSeed(traits.length, squareFootage + houseId * 4),
363             notRandomWithSeed(traits.length, numBathrooms + houseId * 3),
364             notRandomWithSeed(traits.length, numBedrooms + houseId * 2)
365         ];
366 
367         ownedHouses[owner]++;
368         Minted(houseId);
369         Transfer(address(0), owner, 1);
370 
371         return houseId;
372     }
373 
374     function generateAndListPresaleHouse() internal {
375         uint houseId = generateHouse(this);
376         uint sellPrice = (houses[houseId].propertyValue / 5000) * 1 finney;
377 
378         if (sellPrice > 250 finney) sellPrice = 250 finney;
379         if (sellPrice < 50 finney) sellPrice = 50 finney;
380 
381         createListing(houseId, sellPrice, sellPrice, 365 * 24);
382     }
383 
384     function createListing(uint tokenId, uint startPrice, uint endPrice, uint numHours) internal {
385         listings[tokenId] = Listing({
386             startPrice: startPrice,
387             endPrice: endPrice,
388             startedAt: now,
389             endsAt: now + (numHours * 1 hours),
390             isAvailable: true
391         });
392     }
393 
394     function calculateCurrentPrice(Listing listing) internal view returns (uint) {
395         if (listing.endPrice == listing.startPrice || listing.endPrice == 0) {
396             return listing.startPrice;
397         } else {
398             uint totalNumberOfSeconds = listing.endsAt - listing.startedAt;
399             uint secondSinceStart = now - listing.startedAt;
400             int priceChangePerSecond = int(listing.endPrice - listing.startPrice) / int(totalNumberOfSeconds);
401 
402             return uint(int(listing.startPrice) + int(priceChangePerSecond * int(secondSinceStart)));
403         }
404     }
405 
406     function calculatePropertyValue(HouseClasses houseClass, uint squareFootage, uint numBathrooms, uint numBedrooms) pure internal returns (uint) {
407         uint propertyValue = (uint(houseClass) + 1) * 10;
408         propertyValue += (numBathrooms + 1) * 10;
409         propertyValue += (numBedrooms + 1) * 25;
410         propertyValue += squareFootage * 25;
411         propertyValue *= 5;
412 
413         return uint(houseClass) > 4 ? propertyValue * 5 : propertyValue;
414     }
415 
416     function randomHouseClass() internal view returns (HouseClasses) {
417         uint rand = notRandom(1000);
418 
419         if (rand < 200) {
420             return HouseClasses.Shack;
421         } else if (rand > 200 && rand < 400) {
422             return HouseClasses.Apartment;
423         } else if (rand > 400 && rand < 600) {
424             return HouseClasses.Bungalow;
425         } else if (rand > 600 && rand < 800) {
426             return HouseClasses.House;
427         } else {
428             return HouseClasses.Mansion;
429         }
430     }
431 
432     function randomClassVariant(HouseClasses houseClass) internal view returns (uint) {
433         uint possibleVariants = 10;
434         if (classVariants[uint(houseClass)] != 0) possibleVariants = classVariants[uint(houseClass)];
435         return notRandom(possibleVariants);
436     }
437 
438     function randomBedrooms(HouseClasses houseClass) internal view returns (uint) {
439         uint class = uint(houseClass);
440         return class >= 1 ? class + notRandom(4) : 0;
441     }
442 
443     function randomBathrooms(uint numBedrooms) internal view returns (uint) {
444         return numBedrooms < 2 ? numBedrooms : numBedrooms - notRandom(3);
445     }
446 
447     function calculateSquareFootage(HouseClasses houseClass, uint numBedrooms, uint numBathrooms) internal pure returns (uint) {
448         uint baseSqft = uint(houseClass) >= 4 ? 50 : 25;
449         uint multiplier = uint(houseClass) + 1;
450 
451         uint bedroomSqft = (numBedrooms + 1) * 10 * baseSqft;
452         uint bathroomSqft = (numBathrooms + 1) * 5 * baseSqft;
453 
454         return (bedroomSqft + bathroomSqft) * multiplier;
455     }
456 
457     function upgradeAsset(uint tokenId, bool allowClassUpgrade) internal {
458         House storage house = houses[tokenId];
459 
460         house.numBedrooms++;
461         house.numBathrooms++;
462 
463         if (allowClassUpgrade) {
464             uint class = uint(house.class);
465             if (class <= house.numBedrooms) {
466                 house.class = HouseClasses.Bungalow;
467             } else if (class < 2 && house.numBedrooms > 5) {
468                 house.class = HouseClasses.Penthouse;
469             } else if (class < 4 && house.numBedrooms > 10) {
470                 house.class = HouseClasses.Mansion;
471             } else if (class < 6 && house.numBedrooms > 15) {
472                 house.class = HouseClasses.Estate;
473             }
474         }
475 
476         house.squareFootage = calculateSquareFootage(
477             house.class, house.numBedrooms, house.numBathrooms
478         );
479 
480         house.propertyValue = calculatePropertyValue(
481             house.class, house.squareFootage, house.numBathrooms, house.numBedrooms
482         );
483 
484         house.statusValue += house.statusValue / 10;
485         Upgraded(tokenId);
486     }
487 
488     function notRandom(uint lessThan) public view returns (uint) {
489         return uint(keccak256(
490             (houses.length + 1) + (tx.gasprice * lessThan) +
491             (block.difficulty * block.number + now) * msg.gas
492         )) % lessThan;
493     }
494 
495     function notRandomWithSeed(uint lessThan, uint seed) public view returns (uint) {
496         return uint(keccak256(
497             seed + block.gaslimit + block.number
498         )) % lessThan;
499     }
500 }