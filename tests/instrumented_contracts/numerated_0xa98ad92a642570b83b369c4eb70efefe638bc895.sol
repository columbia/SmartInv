1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() public {
21         owner = msg.sender;
22     }
23 
24 
25     /**
26      * @dev Throws if called by any account other than the owner.
27      */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address newOwner) public onlyOwner {
39         require(newOwner != address(0));
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 
44 }
45 
46 
47 
48 
49 
50 
51 
52 
53 contract Beneficiary is Ownable {
54 
55     address public beneficiary;
56 
57     function Beneficiary() public {
58         beneficiary = msg.sender;
59     }
60 
61     function setBeneficiary(address _beneficiary) onlyOwner public {
62         beneficiary = _beneficiary;
63     }
64 
65 
66 }
67 
68 
69 
70 contract ChestsStore is Beneficiary {
71 
72 
73     struct chestProduct {
74         uint256 price; // Price in wei
75         bool isLimited; // is limited sale chest
76         uint32 limit; // Sell limit
77         uint16 boosters; // count of boosters
78         uint24 raiseChance;// in 1/10 of percent
79         uint24 raiseStrength;// in 1/10 of percent for params or minutes for timebased boosters
80         uint8 onlyBoosterType;//If set chest will produce only this type
81         uint8 onlyBoosterStrength;
82     }
83 
84 
85     chestProduct[255] public chestProducts;
86     FishbankChests chests;
87 
88 
89     function ChestsStore(address _chests) public {
90         chests = FishbankChests(_chests);
91         //set chests to this address
92     }
93 
94     function initChestsStore() public onlyOwner {
95         // Create basic chests types
96         setChestProduct(1, 0, 1, false, 0, 0, 0, 0, 0);
97         setChestProduct(2, 15 finney, 3, false, 0, 0, 0, 0, 0);
98         setChestProduct(3, 20 finney, 5, false, 0, 0, 0, 0, 0);
99     }
100 
101     function setChestProduct(uint16 chestId, uint256 price, uint16 boosters, bool isLimited, uint32 limit, uint24 raiseChance, uint24 raiseStrength, uint8 onlyBoosterType, uint8 onlyBoosterStrength) onlyOwner public {
102         chestProduct storage newProduct = chestProducts[chestId];
103         newProduct.price = price;
104         newProduct.boosters = boosters;
105         newProduct.isLimited = isLimited;
106         newProduct.limit = limit;
107         newProduct.raiseChance = raiseChance;
108         newProduct.raiseStrength = raiseStrength;
109         newProduct.onlyBoosterType = onlyBoosterType;
110         newProduct.onlyBoosterStrength = onlyBoosterStrength;
111     }
112 
113     function setChestPrice(uint16 chestId, uint256 price) onlyOwner public {
114         chestProducts[chestId].price = price;
115     }
116 
117     function buyChest(uint16 _chestId) payable public {
118         chestProduct memory tmpChestProduct = chestProducts[_chestId];
119 
120         require(tmpChestProduct.price > 0);
121         // only chests with price
122         require(msg.value >= tmpChestProduct.price);
123         //check if enough ether is send
124         require(!tmpChestProduct.isLimited || tmpChestProduct.limit > 0);
125         //check limits if they exists
126 
127         chests.mintChest(msg.sender, tmpChestProduct.boosters, tmpChestProduct.raiseStrength, tmpChestProduct.raiseChance, tmpChestProduct.onlyBoosterType, tmpChestProduct.onlyBoosterStrength);
128 
129         if (msg.value > chestProducts[_chestId].price) {//send to much ether send some back
130             msg.sender.transfer(msg.value - chestProducts[_chestId].price);
131         }
132 
133         beneficiary.transfer(chestProducts[_chestId].price);
134         //send paid eth to beneficiary
135 
136     }
137 
138 
139 }
140 
141 
142 
143 
144 
145 contract FishbankBoosters is Ownable {
146 
147     struct Booster {
148         address owner;
149         uint32 duration;
150         uint8 boosterType;
151         uint24 raiseValue;
152         uint8 strength;
153         uint32 amount;
154     }
155 
156     Booster[] public boosters;
157     bool public implementsERC721 = true;
158     string public name = "Fishbank Boosters";
159     string public symbol = "FISHB";
160     mapping(uint256 => address) public approved;
161     mapping(address => uint256) public balances;
162     address public fishbank;
163     address public chests;
164     address public auction;
165 
166     modifier onlyBoosterOwner(uint256 _tokenId) {
167         require(boosters[_tokenId].owner == msg.sender);
168         _;
169     }
170 
171     modifier onlyChest() {
172         require(chests == msg.sender);
173         _;
174     }
175 
176     function FishbankBoosters() public {
177         //nothing yet
178     }
179 
180     //mints the boosters can only be called by owner. could be a smart contract
181     function mintBooster(address _owner, uint32 _duration, uint8 _type, uint8 _strength, uint32 _amount, uint24 _raiseValue) onlyChest public {
182         boosters.length ++;
183 
184         Booster storage tempBooster = boosters[boosters.length - 1];
185 
186         tempBooster.owner = _owner;
187         tempBooster.duration = _duration;
188         tempBooster.boosterType = _type;
189         tempBooster.strength = _strength;
190         tempBooster.amount = _amount;
191         tempBooster.raiseValue = _raiseValue;
192 
193         Transfer(address(0), _owner, boosters.length - 1);
194     }
195 
196     function setFishbank(address _fishbank) onlyOwner public {
197         fishbank = _fishbank;
198     }
199 
200     function setChests(address _chests) onlyOwner public {
201         if (chests != address(0)) {
202             revert();
203         }
204         chests = _chests;
205     }
206 
207     function setAuction(address _auction) onlyOwner public {
208         auction = _auction;
209     }
210 
211     function getBoosterType(uint256 _tokenId) view public returns (uint8 boosterType) {
212         boosterType = boosters[_tokenId].boosterType;
213     }
214 
215     function getBoosterAmount(uint256 _tokenId) view public returns (uint32 boosterAmount) {
216         boosterAmount = boosters[_tokenId].amount;
217     }
218 
219     function getBoosterDuration(uint256 _tokenId) view public returns (uint32) {
220         if (boosters[_tokenId].boosterType == 4 || boosters[_tokenId].boosterType == 2) {
221             return boosters[_tokenId].duration + boosters[_tokenId].raiseValue * 60;
222         }
223         return boosters[_tokenId].duration;
224     }
225 
226     function getBoosterStrength(uint256 _tokenId) view public returns (uint8 strength) {
227         strength = boosters[_tokenId].strength;
228     }
229 
230     function getBoosterRaiseValue(uint256 _tokenId) view public returns (uint24 raiseValue) {
231         raiseValue = boosters[_tokenId].raiseValue;
232     }
233 
234     //ERC721 functionality
235     //could split this to a different contract but doesn't make it easier to read
236     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
237     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
238 
239     function totalSupply() public view returns (uint256 total) {
240         total = boosters.length;
241     }
242 
243     function balanceOf(address _owner) public view returns (uint256 balance){
244         balance = balances[_owner];
245     }
246 
247     function ownerOf(uint256 _tokenId) public view returns (address owner){
248         owner = boosters[_tokenId].owner;
249     }
250 
251     function _transfer(address _from, address _to, uint256 _tokenId) internal {
252         require(boosters[_tokenId].owner == _from);
253         //can only transfer if previous owner equals from
254         boosters[_tokenId].owner = _to;
255         approved[_tokenId] = address(0);
256         //reset approved of fish on every transfer
257         balances[_from] -= 1;
258         //underflow can only happen on 0x
259         balances[_to] += 1;
260         //overflows only with very very large amounts of fish
261         Transfer(_from, _to, _tokenId);
262     }
263 
264     function transfer(address _to, uint256 _tokenId) public
265     onlyBoosterOwner(_tokenId) //check if msg.sender is the owner of this fish
266     returns (bool)
267     {
268         _transfer(msg.sender, _to, _tokenId);
269         //after master modifier invoke internal transfer
270         return true;
271     }
272 
273     function approve(address _to, uint256 _tokenId) public
274     onlyBoosterOwner(_tokenId)
275     {
276         approved[_tokenId] = _to;
277         Approval(msg.sender, _to, _tokenId);
278     }
279 
280     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {
281         require(approved[_tokenId] == msg.sender || msg.sender == fishbank || msg.sender == auction);
282         //require msg.sender to be approved for this token or to be the fishbank contract
283         _transfer(_from, _to, _tokenId);
284         //handles event, balances and approval reset
285         return true;
286     }
287 
288 
289     function takeOwnership(uint256 _tokenId) public {
290         require(approved[_tokenId] == msg.sender);
291         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
292     }
293 
294 
295 }
296 
297 
298 
299 
300 
301 
302 contract FishbankChests is Ownable {
303 
304     struct Chest {
305         address owner;
306         uint16 boosters;
307         uint16 chestType;
308         uint24 raiseChance;//Increace chance to catch bigger chest (1 = 1:10000)
309         uint8 onlySpecificType;
310         uint8 onlySpecificStrength;
311         uint24 raiseStrength;
312     }
313 
314     Chest[] public chests;
315     FishbankBoosters public boosterContract;
316     mapping(uint256 => address) public approved;
317     mapping(address => uint256) public balances;
318     mapping(address => bool) public minters;
319 
320     modifier onlyChestOwner(uint256 _tokenId) {
321         require(chests[_tokenId].owner == msg.sender);
322         _;
323     }
324 
325     modifier onlyMinters() {
326         require(minters[msg.sender]);
327         _;
328     }
329 
330     function FishbankChests(address _boosterAddress) public {
331         boosterContract = FishbankBoosters(_boosterAddress);
332     }
333 
334     function addMinter(address _minter) onlyOwner public {
335         minters[_minter] = true;
336     }
337 
338     function removeMinter(address _minter) onlyOwner public {
339         minters[_minter] = false;
340     }
341 
342     //create a chest
343 
344     function mintChest(address _owner, uint16 _boosters, uint24 _raiseStrength, uint24 _raiseChance, uint8 _onlySpecificType, uint8 _onlySpecificStrength) onlyMinters public {
345 
346         chests.length++;
347         chests[chests.length - 1].owner = _owner;
348         chests[chests.length - 1].boosters = _boosters;
349         chests[chests.length - 1].raiseStrength = _raiseStrength;
350         chests[chests.length - 1].raiseChance = _raiseChance;
351         chests[chests.length - 1].onlySpecificType = _onlySpecificType;
352         chests[chests.length - 1].onlySpecificStrength = _onlySpecificStrength;
353         Transfer(address(0), _owner, chests.length - 1);
354     }
355 
356     function convertChest(uint256 _tokenId) onlyChestOwner(_tokenId) public {
357 
358         Chest memory chest = chests[_tokenId];
359         uint16 numberOfBoosters = chest.boosters;
360 
361         if (chest.onlySpecificType != 0) {//Specific boosters
362             if (chest.onlySpecificType == 1 || chest.onlySpecificType == 3) {
363                 boosterContract.mintBooster(msg.sender, 2 days, chest.onlySpecificType, chest.onlySpecificStrength, chest.boosters, chest.raiseStrength);
364             } else if (chest.onlySpecificType == 5) {//Instant attack
365                 boosterContract.mintBooster(msg.sender, 0, 5, 1, chest.boosters, chest.raiseStrength);
366             } else if (chest.onlySpecificType == 2) {//Freeze
367                 uint32 freezeTime = 7 days;
368                 if (chest.onlySpecificStrength == 2) {
369                     freezeTime = 14 days;
370                 } else if (chest.onlySpecificStrength == 3) {
371                     freezeTime = 30 days;
372                 }
373                 boosterContract.mintBooster(msg.sender, freezeTime, 5, chest.onlySpecificType, chest.boosters, chest.raiseStrength);
374             } else if (chest.onlySpecificType == 4) {//Watch
375                 uint32 watchTime = 12 hours;
376                 if (chest.onlySpecificStrength == 2) {
377                     watchTime = 48 hours;
378                 } else if (chest.onlySpecificStrength == 3) {
379                     watchTime = 3 days;
380                 }
381                 boosterContract.mintBooster(msg.sender, watchTime, 4, chest.onlySpecificStrength, chest.boosters, chest.raiseStrength);
382             }
383 
384         } else {//Regular chest
385 
386             for (uint8 i = 0; i < numberOfBoosters; i ++) {
387                 uint24 random = uint16(keccak256(block.coinbase, block.blockhash(block.number - 1), i, chests.length)) % 1000
388                 - chest.raiseChance;
389                 //get random 0 - 9999 minus raiseChance
390 
391                 if (random > 850) {
392                     boosterContract.mintBooster(msg.sender, 2 days, 1, 1, 1, chest.raiseStrength); //Small Agility Booster
393                 } else if (random > 700) {
394                     boosterContract.mintBooster(msg.sender, 7 days, 2, 1, 1, chest.raiseStrength); //Small Freezer
395                 } else if (random > 550) {
396                     boosterContract.mintBooster(msg.sender, 2 days, 3, 1, 1, chest.raiseStrength); //Small Power Booster
397                 } else if (random > 400) {
398                     boosterContract.mintBooster(msg.sender, 12 hours, 4, 1, 1, chest.raiseStrength); //Tiny Watch
399                 } else if (random > 325) {
400                     boosterContract.mintBooster(msg.sender, 48 hours, 4, 2, 1, chest.raiseStrength); //Small Watch
401                 } else if (random > 250) {
402                     boosterContract.mintBooster(msg.sender, 2 days, 1, 2, 1, chest.raiseStrength); //Mid Agility Booster
403                 } else if (random > 175) {
404                     boosterContract.mintBooster(msg.sender, 14 days, 2, 2, 1, chest.raiseStrength); //Mid Freezer
405                 } else if (random > 100) {
406                     boosterContract.mintBooster(msg.sender, 2 days, 3, 2, 1, chest.raiseStrength); //Mid Power Booster
407                 } else if (random > 80) {
408                     boosterContract.mintBooster(msg.sender, 2 days, 1, 3, 1, chest.raiseStrength); //Big Agility Booster
409                 } else if (random > 60) {
410                     boosterContract.mintBooster(msg.sender, 30 days, 2, 3, 1, chest.raiseStrength); //Big Freezer
411                 } else if (random > 40) {
412                     boosterContract.mintBooster(msg.sender, 2 days, 3, 3, 1, chest.raiseStrength); //Big Power Booster
413                 } else if (random > 20) {
414                     boosterContract.mintBooster(msg.sender, 0, 5, 1, 1, 0); //Instant Attack
415                 } else {
416                     boosterContract.mintBooster(msg.sender, 3 days, 4, 3, 1, 0); //Gold Watch
417                 }
418             }
419         }
420 
421         _transfer(msg.sender, address(0), _tokenId); //burn chest
422     }
423 
424     //ERC721 functionality
425     //could split this to a different contract but doesn't make it easier to read
426     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
427     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
428 
429     function totalSupply() public view returns (uint256 total) {
430         total = chests.length;
431     }
432 
433     function balanceOf(address _owner) public view returns (uint256 balance){
434         balance = balances[_owner];
435     }
436 
437     function ownerOf(uint256 _tokenId) public view returns (address owner){
438         owner = chests[_tokenId].owner;
439     }
440 
441     function _transfer(address _from, address _to, uint256 _tokenId) internal {
442         require(chests[_tokenId].owner == _from); //can only transfer if previous owner equals from
443         chests[_tokenId].owner = _to;
444         approved[_tokenId] = address(0); //reset approved of fish on every transfer
445         balances[_from] -= 1; //underflow can only happen on 0x
446         balances[_to] += 1; //overflows only with very very large amounts of fish
447         Transfer(_from, _to, _tokenId);
448     }
449 
450     function transfer(address _to, uint256 _tokenId) public
451     onlyChestOwner(_tokenId) //check if msg.sender is the owner of this fish
452     returns (bool)
453     {
454         _transfer(msg.sender, _to, _tokenId);
455         //after master modifier invoke internal transfer
456         return true;
457     }
458 
459     function approve(address _to, uint256 _tokenId) public
460     onlyChestOwner(_tokenId)
461     {
462         approved[_tokenId] = _to;
463         Approval(msg.sender, _to, _tokenId);
464     }
465 
466     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {
467         require(approved[_tokenId] == msg.sender);
468         //require msg.sender to be approved for this token
469         _transfer(_from, _to, _tokenId);
470         //handles event, balances and approval reset
471         return true;
472     }
473 
474 }
475 
476 
477 
478 
479 
480 contract FishbankUtils is Ownable {
481 
482     uint32[100] cooldowns = [
483         720 minutes, 720 minutes, 720 minutes, 720 minutes, 720 minutes, //1-5
484         660 minutes, 660 minutes, 660 minutes, 660 minutes, 660 minutes, //6-10
485         600 minutes, 600 minutes, 600 minutes, 600 minutes, 600 minutes, //11-15
486         540 minutes, 540 minutes, 540 minutes, 540 minutes, 540 minutes, //16-20
487         480 minutes, 480 minutes, 480 minutes, 480 minutes, 480 minutes, //21-25
488         420 minutes, 420 minutes, 420 minutes, 420 minutes, 420 minutes, //26-30
489         360 minutes, 360 minutes, 360 minutes, 360 minutes, 360 minutes, //31-35
490         300 minutes, 300 minutes, 300 minutes, 300 minutes, 300 minutes, //36-40
491         240 minutes, 240 minutes, 240 minutes, 240 minutes, 240 minutes, //41-45
492         180 minutes, 180 minutes, 180 minutes, 180 minutes, 180 minutes, //46-50
493         120 minutes, 120 minutes, 120 minutes, 120 minutes, 120 minutes, //51-55
494         90 minutes,  90 minutes,  90 minutes,  90 minutes,  90 minutes,  //56-60
495         75 minutes,  75 minutes,  75 minutes,  75 minutes,  75 minutes,  //61-65
496         60 minutes,  60 minutes,  60 minutes,  60 minutes,  60 minutes,  //66-70
497         50 minutes,  50 minutes,  50 minutes,  50 minutes,  50 minutes,  //71-75
498         40 minutes,  40 minutes,  40 minutes,  40 minutes,  40 minutes,  //76-80
499         30 minutes,  30 minutes,  30 minutes,  30 minutes,  30 minutes,  //81-85
500         20 minutes,  20 minutes,  20 minutes,  20 minutes,  20 minutes,  //86-90
501         10 minutes,  10 minutes,  10 minutes,  10 minutes,  10 minutes,  //91-95
502         5 minutes,   5 minutes,   5 minutes,   5 minutes,   5 minutes    //96-100
503     ];
504 
505 
506     function setCooldowns(uint32[100] _cooldowns) onlyOwner public {
507         cooldowns = _cooldowns;
508     }
509 
510     function getFishParams(uint256 hashSeed1, uint256 hashSeed2, uint256 fishesLength, address coinbase) external pure returns (uint32[4]) {
511 
512         bytes32[5] memory hashSeeds;
513         hashSeeds[0] = keccak256(hashSeed1 ^ hashSeed2); //xor both seed from owner and user so no one can cheat
514         hashSeeds[1] = keccak256(hashSeeds[0], fishesLength);
515         hashSeeds[2] = keccak256(hashSeeds[1], coinbase);
516         hashSeeds[3] = keccak256(hashSeeds[2], coinbase, fishesLength);
517         hashSeeds[4] = keccak256(hashSeeds[1], hashSeeds[2], hashSeeds[0]);
518 
519         uint24[6] memory seeds = [
520             uint24(uint(hashSeeds[3]) % 10e6 + 1), //whale chance
521             uint24(uint(hashSeeds[0]) % 420 + 1), //power
522             uint24(uint(hashSeeds[1]) % 420 + 1), //agility
523             uint24(uint(hashSeeds[2]) % 150 + 1), //speed
524             uint24(uint(hashSeeds[4]) % 16 + 1), //whale type
525             uint24(uint(hashSeeds[4]) % 5000 + 1) //rarity
526         ];
527 
528         uint32[4] memory fishParams;
529 
530         if (seeds[0] == 1000000) {//This is a whale 1:1 000 000 chance
531 
532             if (seeds[4] == 1) {//Orca
533                 fishParams = [140 + uint8(seeds[1] / 42), 140 + uint8(seeds[2] / 42), 75 + uint8(seeds[3] / 6), uint32(500000)];
534                 if(fishParams[0] == 140) {
535                     fishParams[0]++;
536                 }
537                 if(fishParams[1] == 140) {
538                     fishParams[1]++;
539                 }
540                 if(fishParams[2] == 75) {
541                     fishParams[2]++;
542                 }
543             } else if (seeds[4] < 4) {//Blue whale
544                 fishParams = [130 + uint8(seeds[1] / 42), 130 + uint8(seeds[2] / 42), 75 + uint8(seeds[3] / 6), uint32(500000)];
545                 if(fishParams[0] == 130) {
546                     fishParams[0]++;
547                 }
548                 if(fishParams[1] == 130) {
549                     fishParams[1]++;
550                 }
551                 if(fishParams[2] == 75) {
552                     fishParams[2]++;
553                 }
554             } else {//Cachalot
555                 fishParams = [115 + uint8(seeds[1] / 28), 115 + uint8(seeds[2] / 28), 75 + uint8(seeds[3] / 6), uint32(500000)];
556                 if(fishParams[0] == 115) {
557                     fishParams[0]++;
558                 }
559                 if(fishParams[1] == 115) {
560                     fishParams[1]++;
561                 }
562                 if(fishParams[2] == 75) {
563                     fishParams[2]++;
564                 }
565             }
566         } else {
567             if (seeds[5] == 5000) {//Legendary
568                 fishParams = [85 + uint8(seeds[1] / 14), 85 + uint8(seeds[2] / 14), uint8(50 + seeds[3] / 3), uint32(1000)];
569                 if(fishParams[0] == 85) {
570                     fishParams[0]++;
571                 }
572                 if(fishParams[1] == 85) {
573                     fishParams[1]++;
574                 }
575             } else if (seeds[5] > 4899) {//Epic
576                 fishParams = [50 + uint8(seeds[1] / 12), 50 + uint8(seeds[2] / 12), uint8(25 + seeds[3] / 2), uint32(300)];
577                 if(fishParams[0] == 50) {
578                     fishParams[0]++;
579                 }
580                 if(fishParams[1] == 50) {
581                     fishParams[1]++;
582                 }
583 
584             } else if (seeds[5] > 4000) {//Rare
585                 fishParams = [20 + uint8(seeds[1] / 14), 20 + uint8(seeds[2] / 14), uint8(25 + seeds[3] / 3), uint32(100)];
586                 if(fishParams[0] == 20) {
587                     fishParams[0]++;
588                 }
589                 if(fishParams[1] == 20) {
590                     fishParams[1]++;
591                 }
592             } else {//Common
593                 fishParams = [uint8(seeds[1] / 21), uint8(seeds[2] / 21), uint8(seeds[3] / 3), uint32(36)];
594                 if (fishParams[0] == 0) {
595                     fishParams[0] = 1;
596                 }
597                 if (fishParams[1] == 0) {
598                     fishParams[1] = 1;
599                 }
600                 if (fishParams[2] == 0) {
601                     fishParams[2] = 1;
602                 }
603             }
604         }
605 
606         return fishParams;
607     }
608 
609     function getCooldown(uint16 speed) external view returns (uint64){
610         return uint64(now + cooldowns[speed - 1]);
611     }
612 
613     //Ceiling function for fish generator
614     function ceil(uint base, uint divider) internal pure returns (uint) {
615         return base / divider + ((base % divider > 0) ? 1 : 0);
616     }
617 }
618 
619 
620 
621 
622 /// @title Auction contract for any type of erc721 token
623 /// @author Fishbank
624 
625 contract ERC721 {
626 
627     function implementsERC721() public pure returns (bool);
628 
629     function totalSupply() public view returns (uint256 total);
630 
631     function balanceOf(address _owner) public view returns (uint256 balance);
632 
633     function ownerOf(uint256 _tokenId) public view returns (address owner);
634 
635     function approve(address _to, uint256 _tokenId) public;
636 
637     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool);
638 
639     function transfer(address _to, uint256 _tokenId) public returns (bool);
640 
641     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
642 
643     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
644 
645     // Optional
646     // function name() public view returns (string name);
647     // function symbol() public view returns (string symbol);
648     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
649     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
650 }
651 
652 
653 contract ERC721Auction is Beneficiary {
654 
655     struct Auction {
656         address seller;
657         uint256 tokenId;
658         uint64 auctionBegin;
659         uint64 auctionEnd;
660         uint256 startPrice;
661         uint256 endPrice;
662     }
663 
664     uint32 public auctionDuration = 7 days;
665 
666     ERC721 public ERC721Contract;
667     uint256 public fee = 45000; //in 1 10000th of a percent so 4.5% at the start
668     uint256 constant FEE_DIVIDER = 1000000;
669     mapping(uint256 => Auction) public auctions;
670 
671     event AuctionWon(uint256 indexed tokenId, address indexed winner, address indexed seller, uint256 price);
672 
673     event AuctionStarted(uint256 indexed tokenId, address indexed seller);
674 
675     event AuctionFinalized(uint256 indexed tokenId, address indexed seller);
676 
677 
678     function startAuction(uint256 _tokenId, uint256 _startPrice, uint256 _endPrice) external {
679         require(ERC721Contract.transferFrom(msg.sender, address(this), _tokenId));
680         //Prices must be in range from 0.01 Eth and 10 000 Eth
681         require(_startPrice <= 10000 ether && _endPrice <= 10000 ether);
682         require(_startPrice >= (1 ether / 100) && _endPrice >= (1 ether / 100));
683 
684         Auction memory auction;
685 
686         auction.seller = msg.sender;
687         auction.tokenId = _tokenId;
688         auction.auctionBegin = uint64(now);
689         auction.auctionEnd = uint64(now + auctionDuration);
690         require(auction.auctionEnd > auction.auctionBegin);
691         auction.startPrice = _startPrice;
692         auction.endPrice = _endPrice;
693 
694         auctions[_tokenId] = auction;
695 
696         AuctionStarted(_tokenId, msg.sender);
697     }
698 
699 
700     function buyAuction(uint256 _tokenId) payable external {
701         Auction storage auction = auctions[_tokenId];
702 
703         uint256 price = calculateBid(_tokenId);
704         uint256 totalFee = price * fee / FEE_DIVIDER; //safe math needed?
705 
706         require(price <= msg.value); //revert if not enough ether send
707 
708         if (price != msg.value) {//send back to much eth
709             msg.sender.transfer(msg.value - price);
710         }
711 
712         beneficiary.transfer(totalFee);
713 
714         auction.seller.transfer(price - totalFee);
715 
716         if (!ERC721Contract.transfer(msg.sender, _tokenId)) {
717             revert();
718             //can't complete transfer if this fails
719         }
720 
721         AuctionWon(_tokenId, msg.sender, auction.seller, price);
722 
723         delete auctions[_tokenId];
724         //deletes auction
725     }
726 
727     function saveToken(uint256 _tokenId) external {
728         require(auctions[_tokenId].auctionEnd < now);
729         //auction must have ended
730         require(ERC721Contract.transfer(auctions[_tokenId].seller, _tokenId));
731         //transfer fish back to seller
732 
733         AuctionFinalized(_tokenId, auctions[_tokenId].seller);
734 
735         delete auctions[_tokenId];
736         //delete auction
737     }
738 
739     function ERC721Auction(address _ERC721Contract) public {
740         ERC721Contract = ERC721(_ERC721Contract);
741     }
742 
743     function setFee(uint256 _fee) onlyOwner public {
744         if (_fee > fee) {
745             revert(); //fee can only be set to lower value to prevent attacks by owner
746         }
747         fee = _fee; // all is well set fee
748     }
749 
750     function calculateBid(uint256 _tokenId) public view returns (uint256) {
751         Auction storage auction = auctions[_tokenId];
752 
753         if (now >= auction.auctionEnd) {//if auction ended return auction end price
754             return auction.endPrice;
755         }
756         //get hours passed
757         uint256 hoursPassed = (now - auction.auctionBegin) / 1 hours;
758         uint256 currentPrice;
759         //get total hours
760         uint16 totalHours = uint16(auctionDuration /1 hours) - 1;
761 
762         if (auction.endPrice > auction.startPrice) {
763             currentPrice = auction.startPrice + (hoursPassed * (auction.endPrice - auction.startPrice))/ totalHours;
764         } else if(auction.endPrice < auction.startPrice) {
765             currentPrice = auction.startPrice - (hoursPassed * (auction.startPrice - auction.endPrice))/ totalHours;
766         } else {//start and end are the same
767             currentPrice = auction.endPrice;
768         }
769 
770         return uint256(currentPrice);
771         //return the price at this very moment
772     }
773 
774     /// return token if case when need to redeploy auction contract
775     function returnToken(uint256 _tokenId) onlyOwner public {
776         require(ERC721Contract.transfer(auctions[_tokenId].seller, _tokenId));
777         //transfer fish back to seller
778 
779         AuctionFinalized(_tokenId, auctions[_tokenId].seller);
780 
781         delete auctions[_tokenId];
782     }
783 }
784 
785 
786 /// @title Core contract of fishbank
787 /// @author Fishbank
788 
789 contract Fishbank is ChestsStore {
790 
791     struct Fish {
792         address owner;
793         uint8 activeBooster;
794         uint64 boostedTill;
795         uint8 boosterStrength;
796         uint24 boosterRaiseValue;
797         uint64 weight;
798         uint16 power;
799         uint16 agility;
800         uint16 speed;
801         bytes16 color;
802         uint64 canFightAgain;
803         uint64 canBeAttackedAgain;
804     }
805 
806     struct FishingAttempt {
807         address fisher;
808         uint256 feePaid;
809         address affiliate;
810         uint256 seed;
811         uint64 deadline;//till when does the contract owner have time to resolve;
812     }
813 
814     modifier onlyFishOwner(uint256 _tokenId) {
815         require(fishes[_tokenId].owner == msg.sender);
816         _;
817     }
818 
819     modifier onlyResolver() {
820         require(msg.sender == resolver);
821         _;
822     }
823 
824     modifier onlyMinter() {
825         require(msg.sender == minter);
826         _;
827     }
828 
829     Fish[] public fishes;
830     address public resolver;
831     address public auction;
832     address public minter;
833     bool public implementsERC721 = true;
834     string public name = "Fishbank";
835     string public symbol = "FISH";
836     bytes32[] public randomHashes;
837     uint256 public hashesUsed;
838     uint256 public aquariumCost = 1 ether / 100 * 3;//fee for fishing starts at 0.03 ether
839     uint256 public resolveTime = 30 minutes;//how long does the contract owner have to resolve hashes
840     uint16 public weightLostPartLimit = 5;
841     FishbankBoosters public boosters;
842     FishbankChests public chests;
843     FishbankUtils private utils;
844 
845 
846     mapping(bytes32 => FishingAttempt) public pendingFishing;//attempts that need solving;
847 
848     mapping(uint256 => address) public approved;
849     mapping(address => uint256) public balances;
850     mapping(address => bool) public affiliated;
851 
852     event AquariumFished(
853         bytes32 hash,
854         address fisher,
855         uint256 feePaid
856     ); //event broadcated when someone fishes in aqaurium
857 
858     event AquariumResolved(bytes32 hash, address fisher);
859 
860     event Attack(
861         uint256 attacker,
862         uint256 victim,
863         uint256 winner,
864         uint64 weight,
865         uint256 ap, uint256 vp, uint256 random
866     );
867 
868     event BoosterApplied(uint256 tokenId, uint256 boosterId);
869 
870     /// @notice Constructor of the contract. Sets resolver, beneficiary, boosters and chests
871     /// @param _boosters the address of the boosters smart contract
872     /// @param _chests the address of the chests smart contract
873 
874     function Fishbank(address _boosters, address _chests, address _utils) ChestsStore(_chests) public {
875 
876         resolver = msg.sender;
877         beneficiary = msg.sender;
878         boosters = FishbankBoosters(_boosters);
879         chests = FishbankChests(_chests);
880         utils = FishbankUtils(_utils);
881     }
882 
883     /// @notice Mints fishes according to params can only be called by the owner
884     /// @param _owner array of addresses the fishes should be owned by
885     /// @param _weight array of weights for the fishes
886     /// @param _power array of power levels for the fishes
887     /// @param _agility array of agility levels for the fishes
888     /// @param _speed array of speed levels for the fishes
889     /// @param _color array of color params for the fishes
890 
891     function mintFish(address[] _owner, uint32[] _weight, uint8[] _power, uint8[] _agility, uint8[] _speed, bytes16[] _color) onlyMinter public {
892 
893         for (uint i = 0; i < _owner.length; i ++) {
894             _mintFish(_owner[i], _weight[i], _power[i], _agility[i], _speed[i], _color[i]);
895         }
896     }
897 
898     /// @notice Internal method for minting a fish
899     /// @param _owner address of owner for the fish
900     /// @param _weight weight param for fish
901     /// @param _power power param for fish
902     /// @param _agility agility param for the fish
903     /// @param _speed speed param for the fish
904     /// @param _color color param for the fish
905 
906     function _mintFish(address _owner, uint32 _weight, uint8 _power, uint8 _agility, uint8 _speed, bytes16 _color) internal {
907 
908         fishes.length += 1;
909         uint256 newFishId = fishes.length - 1;
910 
911         Fish storage newFish = fishes[newFishId];
912 
913         newFish.owner = _owner;
914         newFish.weight = _weight;
915         newFish.power = _power;
916         newFish.agility = _agility;
917         newFish.speed = _speed;
918         newFish.color = _color;
919 
920         balances[_owner] ++;
921 
922         Transfer(address(0), _owner, newFishId);
923     }
924 
925     function setWeightLostPartLimit(uint8 _weightPart) onlyOwner public {
926         weightLostPartLimit = _weightPart;
927     }
928 
929     /// @notice Sets the cost for fishing in the aquarium
930     /// @param _fee new fee for fishing in wei
931     function setAquariumCost(uint256 _fee) onlyOwner public {
932         aquariumCost = _fee;
933     }
934 
935     /// @notice Sets address that resolves hashes for fishing can only be called by the owner
936     /// @param _resolver address of the resolver
937     function setResolver(address _resolver) onlyOwner public {
938         resolver = _resolver;
939     }
940 
941 
942     /// @notice Sets the address getting the proceedings from fishing in the aquarium
943     /// @param _beneficiary address of the new beneficiary
944     function setBeneficiary(address _beneficiary) onlyOwner public {
945         beneficiary = _beneficiary;
946     }
947 
948     function setAuction(address _auction) onlyOwner public {
949         auction = _auction;
950     }
951 
952     function setBoosters(address _boosters) onlyOwner public {
953         boosters = FishbankBoosters(_boosters);
954     }
955 
956     function setMinter(address _minter) onlyOwner public {
957         minter = _minter;
958     }
959 
960     function setUtils(address _utils) onlyOwner public {
961         utils = FishbankUtils(_utils);
962     }
963 
964     /// batch fishing from 1 to 10 times
965     function batchFishAquarium(uint256[] _seeds, address _affiliate) payable public {
966         require(_seeds.length > 0 && _seeds.length <= 10);
967         require(msg.value >= aquariumCost * _seeds.length);
968         //must send enough ether to cover costs
969         require(randomHashes.length > hashesUsed + _seeds.length);
970         //there needs to be a hash left
971 
972         if (msg.value > aquariumCost * _seeds.length) {
973             msg.sender.transfer(msg.value - aquariumCost * _seeds.length);
974             //send to much ether back
975         }
976 
977         for (uint256 i = 0; i < _seeds.length; i ++) {
978             _fishAquarium(_seeds[i]);
979         }
980 
981         if(_affiliate != address(0)) {
982             pendingFishing[randomHashes[hashesUsed - 1]].affiliate = _affiliate;
983         }
984     }
985 
986     function _fishAquarium(uint256 _seed) internal {
987         //this loop prevents from using the same hash as another fishing attempt if the owner submits the same hash multiple times
988         while (pendingFishing[randomHashes[hashesUsed]].fisher != address(0)) {
989             hashesUsed++;
990             //increase hashesUsed and try next one
991         }
992 
993         FishingAttempt storage newAttempt = pendingFishing[randomHashes[hashesUsed]];
994 
995         newAttempt.fisher = msg.sender;
996         newAttempt.feePaid = aquariumCost;
997         //set the fee paid so it can be returned if the hash doesn't get resolved fast enough
998         newAttempt.seed = _seed;
999         //sets the seed that gets combined with the random seed of the owner
1000         newAttempt.deadline = uint64(now + resolveTime);
1001         //saves deadline after which the fisher can redeem his fishing fee
1002 
1003         hashesUsed++;
1004         //increase hashes used so it cannot be used again
1005 
1006         AquariumFished(randomHashes[hashesUsed - 1], msg.sender, aquariumCost);
1007         //broadcast event
1008     }
1009 
1010     /// @notice Call this to resolve hashes and generate fish/chests
1011     /// @param _seed seed that corresponds to the hash
1012     function _resolveAquarium(uint256 _seed) internal {
1013         bytes32 tempHash = keccak256(_seed);
1014         FishingAttempt storage tempAttempt = pendingFishing[tempHash];
1015 
1016         require(tempAttempt.fisher != address(0));
1017         //attempt must be set so we look if fisher is set
1018 
1019         if (tempAttempt.affiliate != address(0) && !affiliated[tempAttempt.fisher]) {//if affiliate is set
1020             chests.mintChest(tempAttempt.affiliate, 1, 0, 0, 0, 0);
1021             //Chest with one random booster
1022             affiliated[tempAttempt.fisher] = true;
1023         }
1024 
1025         uint32[4] memory fishParams = utils.getFishParams(_seed, tempAttempt.seed, fishes.length, block.coinbase);
1026 
1027         _mintFish(tempAttempt.fisher, fishParams[3], uint8(fishParams[0]), uint8(fishParams[1]), uint8(fishParams[2]), bytes16(keccak256(_seed ^ tempAttempt.seed)));
1028 
1029         beneficiary.transfer(tempAttempt.feePaid);
1030         AquariumResolved(tempHash, tempAttempt.fisher);
1031         //broadcast event
1032 
1033         delete pendingFishing[tempHash];
1034         //delete fishing attempt
1035     }
1036 
1037     /// @notice Batch resolve fishing attempts
1038     /// @param _seeds array of seeds that correspond to hashes that need resolving
1039     function batchResolveAquarium(uint256[] _seeds) onlyResolver public {
1040         for (uint256 i = 0; i < _seeds.length; i ++) {
1041             _resolveAquarium(_seeds[i]);
1042         }
1043     }
1044 
1045 
1046     /// @notice Adds an array of hashes to be used for resolving
1047     /// @param _hashes array of hashes to add
1048     function addHash(bytes32[] _hashes) onlyResolver public {
1049         for (uint i = 0; i < _hashes.length; i ++) {
1050             randomHashes.push(_hashes[i]);
1051         }
1052     }
1053 
1054     /// @notice Call this function to attack another fish
1055     /// @param _attacker ID of fish that is attacking
1056     /// @param _victim ID of fish to attack
1057     function attack(uint256 _attacker, uint256 _victim) onlyFishOwner(_attacker) public {
1058 
1059         Fish memory attacker = fishes[_attacker];
1060         Fish memory victim = fishes[_victim];
1061 
1062         //check if attacker is sleeping
1063         if (attacker.activeBooster == 2 && attacker.boostedTill > now) {//if your fish is sleeping auto awake it
1064             fishes[_attacker].activeBooster = 0;
1065             attacker.boostedTill = uint64(now);
1066             //set booster to invalid one so it has no effect
1067         }
1068 
1069         //check if victim has active sleeping booster
1070         require(!((victim.activeBooster == 2) && victim.boostedTill >= now));
1071         //cannot attack a sleeping fish
1072         require(now >= attacker.canFightAgain);
1073         //check if attacking fish is cooled down
1074         require(now >= victim.canBeAttackedAgain);
1075         //check if victim fish can be attacked again
1076 
1077 
1078         if (msg.sender == victim.owner) {
1079             uint64 weight = attacker.weight < victim.weight ? attacker.weight : victim.weight;
1080             fishes[_attacker].weight += weight;
1081             fishes[_victim].weight -= weight;
1082             fishes[_attacker].canFightAgain = uint64(utils.getCooldown(attacker.speed));
1083 
1084             if (fishes[_victim].weight == 0) {
1085                 _transfer(msg.sender, address(0), _victim);
1086                 balances[fishes[_victim].owner] --;
1087                 //burn token
1088             } else {
1089                 fishes[_victim].canBeAttackedAgain = uint64(now + 1 hours);
1090                 //set victim cooldown 1 hour
1091             }
1092 
1093             Attack(_attacker, _victim, _attacker, weight, 0, 0, 0);
1094             return;
1095         }
1096 
1097         if (victim.weight < 2 || attacker.weight < 2) {
1098             revert();
1099             //revert if one of the fish is below fighting weight
1100         }
1101 
1102         uint256 AP = getFightingAmounts(attacker, true);
1103         // get attacker power
1104         uint256 VP = getFightingAmounts(victim, false);
1105         // get victim power
1106 
1107         bytes32 randomHash = keccak256(block.coinbase, block.blockhash(block.number - 1), fishes.length);
1108 
1109         uint256 max = AP > VP ? AP : VP;
1110         uint256 attackRange = max * 2;
1111         uint256 random = uint256(randomHash) % attackRange + 1;
1112 
1113         uint64 weightLost;
1114 
1115         if (random <= (max + AP - VP)) {
1116             weightLost = _handleWin(_attacker, _victim);
1117             Attack(_attacker, _victim, _attacker, weightLost, AP, VP, random);
1118         } else {
1119             weightLost = _handleWin(_victim, _attacker);
1120             Attack(_attacker, _victim, _victim, weightLost, AP, VP, random);
1121             //broadcast event
1122         }
1123 
1124         fishes[_attacker].canFightAgain = uint64(utils.getCooldown(attacker.speed));
1125         fishes[_victim].canBeAttackedAgain = uint64(now + 1 hours);
1126         //set victim cooldown 1 hour
1127     }
1128 
1129     /// @notice Handles lost gained weight after fight
1130     /// @param _winner the winner of the fight
1131     /// @param _loser the loser of the fight
1132     function _handleWin(uint256 _winner, uint256 _loser) internal returns (uint64) {
1133         Fish storage winner = fishes[_winner];
1134         Fish storage loser = fishes[_loser];
1135 
1136         uint64 fullWeightLost = loser.weight / sqrt(winner.weight);
1137         uint64 maxWeightLost = loser.weight / weightLostPartLimit;
1138 
1139         uint64 weightLost = maxWeightLost < fullWeightLost ? maxWeightLost : fullWeightLost;
1140 
1141         if (weightLost < 1) {
1142             weightLost = 1;
1143             // Minimum 1
1144         }
1145 
1146         winner.weight += weightLost;
1147         loser.weight -= weightLost;
1148 
1149         return weightLost;
1150     }
1151 
1152     /// @notice get attack and defence from fish
1153     /// @param _fish is Fish token
1154     /// @param _is_attacker true if fish is attacker otherwise false
1155     function getFightingAmounts(Fish _fish, bool _is_attacker) internal view returns (uint256){
1156         return (getFishPower(_fish) * (_is_attacker ? 60 : 40) + getFishAgility(_fish) * (_is_attacker ? 40 : 60)) * _fish.weight;
1157     }
1158 
1159     /// @notice Apply a booster to a fish
1160     /// @param _tokenId the fish the booster should be applied to
1161     /// @param _booster the Id of the booster the token should be applied to
1162     function applyBooster(uint256 _tokenId, uint256 _booster) onlyFishOwner(_tokenId) public {
1163         require(msg.sender == boosters.ownerOf(_booster));
1164         //only owner can do this
1165         require(boosters.getBoosterAmount(_booster) >= 1);
1166         Fish storage tempFish = fishes[_tokenId];
1167         uint8 boosterType = uint8(boosters.getBoosterType(_booster));
1168 
1169         if (boosterType == 1 || boosterType == 2 || boosterType == 3) {//if booster is attack or agility or sleep
1170             tempFish.boosterStrength = boosters.getBoosterStrength(_booster);
1171             tempFish.activeBooster = boosterType;
1172             tempFish.boostedTill = boosters.getBoosterDuration(_booster) * boosters.getBoosterAmount(_booster) + uint64(now);
1173             tempFish.boosterRaiseValue = boosters.getBoosterRaiseValue(_booster);
1174         }
1175         else if (boosterType == 4) {//watch booster
1176             require(tempFish.boostedTill > uint64(now));
1177             //revert on using watch on booster that has passed;
1178             tempFish.boosterStrength = boosters.getBoosterStrength(_booster);
1179             tempFish.boostedTill += boosters.getBoosterDuration(_booster) * boosters.getBoosterAmount(_booster);
1180             //add time to booster
1181         }
1182         else if (boosterType == 5) {//Instant attack
1183             require(boosters.getBoosterAmount(_booster) == 1);
1184             //Can apply only one instant attack booster
1185             tempFish.canFightAgain = 0;
1186         }
1187 
1188         require(boosters.transferFrom(msg.sender, address(0), _booster));
1189         //burn booster
1190 
1191         BoosterApplied(_tokenId, _booster);
1192     }
1193 
1194     /// @notice square root function used for weight gain/loss
1195     /// @param x uint64 to get square root from
1196     function sqrt(uint64 x) pure internal returns (uint64 y) {
1197         uint64 z = (x + 1) / 2;
1198         y = x;
1199         while (z < y) {
1200             y = z;
1201             z = (x / z + z) / 2;
1202         }
1203     }
1204 
1205     //utlitiy function for easy testing can be removed later
1206     function doKeccak256(uint256 _input) pure public returns (bytes32) {
1207         return keccak256(_input);
1208     }
1209 
1210     function getFishPower(Fish _fish) internal view returns (uint24 power) {
1211         power = _fish.power;
1212         if (_fish.activeBooster == 1 && _fish.boostedTill > now) {// check if booster active
1213             uint24 boosterPower = (10 * _fish.boosterStrength + _fish.boosterRaiseValue + 100) * power / 100 - power;
1214             if (boosterPower < 1 && _fish.boosterStrength == 1) {
1215                 power += 1;
1216             } else if (boosterPower < 3 && _fish.boosterStrength == 2) {
1217                 power += 3;
1218             } else if (boosterPower < 5 && _fish.boosterStrength == 3) {
1219                 power += 5;
1220             } else {
1221                 power = boosterPower + power;
1222             }
1223         }
1224     }
1225 
1226     function getFishAgility(Fish _fish) internal view returns (uint24 agility) {
1227         agility = _fish.agility;
1228         if (_fish.activeBooster == 3 && _fish.boostedTill > now) {// check if booster active
1229             uint24 boosterPower = (10 * _fish.boosterStrength + _fish.boosterRaiseValue + 100) * agility / 100 - agility;
1230             if (boosterPower < 1 && _fish.boosterStrength == 1) {
1231                 agility += 1;
1232             } else if (boosterPower < 3 && _fish.boosterStrength == 2) {
1233                 agility += 3;
1234             } else if (boosterPower < 5 && _fish.boosterStrength == 3) {
1235                 agility += 5;
1236             } else {
1237                 agility = boosterPower + agility;
1238             }
1239         }
1240     }
1241 
1242 
1243     //ERC721 functionality
1244     //could split this to a different contract but doesn't make it easier to read
1245     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1246     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1247 
1248     function totalSupply() public view returns (uint256 total) {
1249         total = fishes.length;
1250     }
1251 
1252     function balanceOf(address _owner) public view returns (uint256 balance){
1253         balance = balances[_owner];
1254     }
1255 
1256     function ownerOf(uint256 _tokenId) public view returns (address owner){
1257         owner = fishes[_tokenId].owner;
1258     }
1259 
1260     function _transfer(address _from, address _to, uint256 _tokenId) internal {
1261         require(fishes[_tokenId].owner == _from);
1262         //can only transfer if previous owner equals from
1263         fishes[_tokenId].owner = _to;
1264         approved[_tokenId] = address(0);
1265         //reset approved of fish on every transfer
1266         balances[_from] -= 1;
1267         //underflow can only happen on 0x
1268         balances[_to] += 1;
1269         //overflows only with very very large amounts of fish
1270         Transfer(_from, _to, _tokenId);
1271     }
1272 
1273     function transfer(address _to, uint256 _tokenId) public
1274     onlyFishOwner(_tokenId) //check if msg.sender is the owner of this fish
1275     returns (bool)
1276     {
1277         _transfer(msg.sender, _to, _tokenId);
1278         //after master modifier invoke internal transfer
1279         return true;
1280     }
1281 
1282     function approve(address _to, uint256 _tokenId) public
1283     onlyFishOwner(_tokenId)
1284     {
1285         approved[_tokenId] = _to;
1286         Approval(msg.sender, _to, _tokenId);
1287     }
1288 
1289     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {
1290         require(approved[_tokenId] == msg.sender || msg.sender == auction);
1291         Fish storage fish = fishes[_tokenId];
1292 
1293         if (msg.sender == auction) {
1294             fish.activeBooster = 2;
1295             //Freeze for auction
1296             fish.boostedTill = uint64(now + 7 days);
1297             fish.boosterStrength = 1;
1298         }
1299         //require msg.sender to be approved for this token
1300         _transfer(_from, _to, _tokenId);
1301         //handles event, balances and approval reset
1302         return true;
1303     }
1304 
1305     function takeOwnership(uint256 _tokenId) public {
1306         require(approved[_tokenId] == msg.sender);
1307         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
1308     }
1309 
1310 }