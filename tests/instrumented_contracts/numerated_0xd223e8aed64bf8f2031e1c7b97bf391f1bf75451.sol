1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52   address public owner;
53 
54   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 /*
87   ____      _   _ _   _               _       
88  |  _ \ ___| |_(_) |_(_) ___  _ __   (_) ___  
89  | |_) / _ \ __| | __| |/ _ \| '_ \  | |/ _ \ 
90  |  __/  __/ |_| | |_| | (_) | | | |_| | (_) |
91  |_|   \___|\__|_|\__|_|\___/|_| |_(_)_|\___/ 
92 
93 */
94 
95 contract PetitionFactory is Ownable {
96 
97     using SafeMath for uint;
98 
99     event NewPetition(uint petitionId, string name, string message, address creator, uint signaturesNeeded, bool featured, uint featuredExpires, uint totalSignatures, uint created, string connectingHash, uint advertisingBudget);
100     event NewPetitionSigner(uint petitionSignerId, uint petitionId, address petitionSignerAddress, uint signed);
101     event NewPetitionShareholder(uint PetitionShareholderId, address PetitionShareholderAddress, uint shares, uint sharesListedForSale, uint lastDividend);
102     event DividendClaim(uint divId, uint PetitionShareholderId, uint amt, uint time, address userAddress);
103     event NewShareholderListing(uint shareholderListingId, uint petitionShareholderId, uint sharesForSale, uint price, bool sold);
104 
105     struct Petition {
106         string name;
107         string message;
108         address creator;
109         uint signaturesNeeded;
110         bool featured;
111         uint featuredExpires;
112         uint totalSignatures;
113         uint created;
114         string connectingHash;
115         uint advertisingBudget; // an easy way for people to donate to the petition cause. We will use this budget for CPC, CPM text and banner ads around petition.io
116     }
117 
118     struct PetitionSigner {
119         uint petitionId;
120         address petitionSignerAddress;
121         uint signed;
122     }
123 
124     struct PetitionShareholder {
125         address PetitionShareholderAddress;
126         uint shares;
127         uint sharesListedForSale; // prevent being able to double list shares for sale
128         uint lastDividend;
129     }
130 
131     struct DividendHistory {
132         uint PetitionShareholderId;
133         uint amt;
134         uint time;
135         address userAddress;
136     }
137 
138     struct ShareholderListing {
139         uint petitionShareholderId;
140         uint sharesForSale;
141         uint price;
142         bool sold;
143     }
144 
145     Petition[] public petitions;
146 
147     PetitionSigner[] public petitionsigners;
148     mapping(address => mapping(uint => uint)) ownerPetitionSignerArrayCreated;
149     mapping(address => mapping(uint => uint)) petitionSignerMap;
150 
151     PetitionShareholder[] public PetitionShareholders;
152     mapping(address => uint) ownerPetitionShareholderArrayCreated;
153     mapping(address => uint) PetitionShareholderMap;
154 
155     DividendHistory[] public divs;
156 
157     ShareholderListing[] public listings;
158 
159     uint createPetitionFee = 1000000000000000; // 0.001 ETH
160     uint featurePetitionFee = 100000000000000000; // 0.1 ETH
161     uint featuredLength = 604800; // 1 week
162 
163     /********************************* */
164     // shareholder details
165 
166     //uint petitionIoShares = 1000000; // 1,000,000 (20%) of shares given to Petition.io Inc. This is needed so Petition.io Inc can collect 20% of the fees to keep the lights on and continually improve the platform
167 
168     uint sharesSold = 0;
169 
170     uint maxShares = 5000000; // 5,000,000 shares exist
171 
172     // initial price per share from Petition.io (until all shares are sold). But can also be listed and sold p2p on our marketplace at the price set by shareholder
173     uint initialPricePerShare  = 5000000000000000; // 0.005 ETH -> 
174         // notice of bonuses: 
175         // 10 ETH + get a 10% bonus
176         // 50 ETH + get a 20% bonus 
177         // 100 ETH + get a 30% bonus
178         // 500 ETH + get a 40% bonus
179         // 1000 ETH + get a 50% bonus
180     
181     uint initialOwnerSharesClaimed = 0; // owner can only claim their 1,000,000 shares once
182     address ownerShareAddress;
183 
184     uint dividendCooldown = 604800; // 1 week
185 
186     uint peerToPeerMarketplaceTransactionFee = 100; // 1% (1 / 100 = 0.01, 2 / 100 = 0.02, etc)
187 
188     uint dividendPoolStarts = 0;
189     uint dividendPoolEnds = 0;
190     uint claimableDividendPool = 0; // (from the last dividendCooldown time pool)
191     uint claimedThisPool = 0;
192     uint currentDividendPool = 0; // (from this dividendCooldown pool)
193 
194     uint availableForWithdraw = 0;
195 
196     /********************************* */
197     // shareholder functions
198 
199     function invest() payable public {
200         require(sharesSold < maxShares);
201         // calc how many shares
202         uint numberOfShares = SafeMath.div(msg.value, initialPricePerShare); // example is 1 ETH (1000000000000000000) / 0.01 ETH (10000000000000000) = 100 shares
203 
204         // calc bonus
205         uint numberOfSharesBonus;
206         uint numberOfSharesBonusOne;
207         uint numberOfSharesBonusTwo;
208         if (msg.value >= 1000000000000000000000) { // 1000 ETH
209             numberOfSharesBonus = SafeMath.div(numberOfShares, 2); // 50%
210             numberOfShares = SafeMath.add(numberOfShares, numberOfSharesBonus);
211 
212         } else if (msg.value >= 500000000000000000000) { // 500 ETH
213             numberOfSharesBonusOne = SafeMath.div(numberOfShares, 5); // 20%
214             numberOfSharesBonusTwo = SafeMath.div(numberOfShares, 5); // 20%
215             numberOfShares = numberOfShares + numberOfSharesBonusOne + numberOfSharesBonusTwo; // 40%
216 
217         } else if (msg.value >= 100000000000000000000) { // 100 ETH
218             numberOfSharesBonusOne = SafeMath.div(numberOfShares, 5); // 20%
219             numberOfSharesBonusTwo = SafeMath.div(numberOfShares, 10); // 10%
220             numberOfShares = numberOfShares + numberOfSharesBonusOne + numberOfSharesBonusTwo; // 30%
221         
222         } else if (msg.value >= 50000000000000000000) { // 50 ETH
223             numberOfSharesBonus = SafeMath.div(numberOfShares, 5); // 20%
224             numberOfShares = numberOfShares + numberOfSharesBonus; // 20%
225 
226         } else if (msg.value >= 10000000000000000000) { // 10 ETH
227             numberOfSharesBonus = SafeMath.div(numberOfShares, 10); // 10%
228             numberOfShares = numberOfShares + numberOfSharesBonus; // 10%
229         
230         }
231 
232         require((numberOfShares + sharesSold) < maxShares);
233 
234         if (ownerPetitionShareholderArrayCreated[msg.sender] == 0) {
235             // new investor
236             uint id = PetitionShareholders.push(PetitionShareholder(msg.sender, numberOfShares, 0, now)) - 1;
237             emit NewPetitionShareholder(id, msg.sender, numberOfShares, 0, now);
238             PetitionShareholderMap[msg.sender] = id;
239             ownerPetitionShareholderArrayCreated[msg.sender] = 1;
240             
241             sharesSold = sharesSold + numberOfShares;
242 
243             availableForWithdraw = availableForWithdraw + msg.value;
244 
245         } else {
246             // add to amount
247             PetitionShareholders[PetitionShareholderMap[msg.sender]].shares = PetitionShareholders[PetitionShareholderMap[msg.sender]].shares + numberOfShares;
248             
249             sharesSold = sharesSold + numberOfShares;
250 
251             availableForWithdraw = availableForWithdraw + msg.value;
252 
253         }
254 
255         // new div pool?
256         endDividendPool();
257 
258     }
259 
260     function viewSharesSold() public view returns(uint) {
261         return sharesSold;
262     }
263 
264     function viewMaxShares() public view returns(uint) {
265         return maxShares;
266     }
267 
268     function viewPetitionShareholderWithAddress(address _investorAddress) view public returns (uint, address, uint, uint) {
269         require (ownerPetitionShareholderArrayCreated[_investorAddress] > 0);
270 
271         PetitionShareholder storage investors = PetitionShareholders[PetitionShareholderMap[_investorAddress]];
272         return (PetitionShareholderMap[_investorAddress], investors.PetitionShareholderAddress, investors.shares, investors.lastDividend);
273     }
274 
275     function viewPetitionShareholder(uint _PetitionShareholderId) view public returns (uint, address, uint, uint) {
276         PetitionShareholder storage investors = PetitionShareholders[_PetitionShareholderId];
277         return (_PetitionShareholderId, investors.PetitionShareholderAddress, investors.shares, investors.lastDividend);
278     }
279 
280     /********************************* */
281     // dividend functions
282 
283     function endDividendPool() public {
284         // we do if instead of require so we can call it throughout the smart contract. This way if someone signs, creates a petition, etc. It can ding to the next dividend pool.
285         if (now > dividendPoolEnds) {
286 
287             // unclaimed dividends go to admin available
288             availableForWithdraw = availableForWithdraw + (claimableDividendPool - claimedThisPool);
289 
290             // current div pool to claimable div pool
291             claimableDividendPool = currentDividendPool;
292             claimedThisPool = 0;
293 
294             // reset current div pool
295             currentDividendPool = 0;
296 
297             // start new pool period
298             dividendPoolStarts = now;
299             dividendPoolEnds = (now + dividendCooldown);
300 
301         }
302 
303     }
304 
305     function collectDividend() payable public {
306         require (ownerPetitionShareholderArrayCreated[msg.sender] > 0);
307         require ((PetitionShareholders[PetitionShareholderMap[msg.sender]].lastDividend + dividendCooldown) < now);
308         require (claimableDividendPool > 0);
309 
310         // calc amount
311         uint divAmt = claimableDividendPool / (sharesSold / PetitionShareholders[PetitionShareholderMap[msg.sender]].shares);
312 
313         claimedThisPool = claimedThisPool + divAmt;
314 
315         //
316         PetitionShareholders[PetitionShareholderMap[msg.sender]].lastDividend = now;
317 
318         // the actual ETH transfer
319         PetitionShareholders[PetitionShareholderMap[msg.sender]].PetitionShareholderAddress.transfer(divAmt);
320 
321         uint id = divs.push(DividendHistory(PetitionShareholderMap[msg.sender], divAmt, now, PetitionShareholders[PetitionShareholderMap[msg.sender]].PetitionShareholderAddress)) - 1;
322         emit DividendClaim(id, PetitionShareholderMap[msg.sender], divAmt, now, PetitionShareholders[PetitionShareholderMap[msg.sender]].PetitionShareholderAddress);
323     }
324 
325     function viewInvestorDividendHistory(uint _divId) public view returns(uint, uint, uint, uint, address) {
326         return(_divId, divs[_divId].PetitionShareholderId, divs[_divId].amt, divs[_divId].time, divs[_divId].userAddress);
327     }
328 
329     function viewInvestorDividendPool() public view returns(uint) {
330         return currentDividendPool;
331     }
332 
333     function viewClaimableInvestorDividendPool() public view returns(uint) {
334         return claimableDividendPool;
335     }
336 
337     function viewClaimedThisPool() public view returns(uint) {
338         return claimedThisPool;
339     }
340 
341     function viewLastClaimedDividend(address _address) public view returns(uint) {
342         return PetitionShareholders[PetitionShareholderMap[_address]].lastDividend;
343     }
344 
345     function ViewDividendPoolEnds() public view returns(uint) {
346         return dividendPoolEnds;
347     }
348 
349     function viewDividendCooldown() public view returns(uint) {
350         return dividendCooldown;
351     }
352 
353 
354     // transfer shares
355     function transferShares(uint _amount, address _to) public {
356         require(ownerPetitionShareholderArrayCreated[msg.sender] > 0);
357         require((PetitionShareholders[PetitionShareholderMap[msg.sender]].shares - PetitionShareholders[PetitionShareholderMap[msg.sender]].sharesListedForSale) >= _amount);
358 
359         // give to receiver
360         if (ownerPetitionShareholderArrayCreated[_to] == 0) {
361             // new investor
362             uint id = PetitionShareholders.push(PetitionShareholder(_to, _amount, 0, now)) - 1;
363             emit NewPetitionShareholder(id, _to, _amount, 0, now);
364             PetitionShareholderMap[_to] = id;
365             ownerPetitionShareholderArrayCreated[_to] = 1;
366 
367         } else {
368             // add to amount
369             PetitionShareholders[PetitionShareholderMap[_to]].shares = PetitionShareholders[PetitionShareholderMap[_to]].shares + _amount;
370 
371         }
372 
373         // take from sender
374         PetitionShareholders[PetitionShareholderMap[msg.sender]].shares = PetitionShareholders[PetitionShareholderMap[msg.sender]].shares - _amount;
375         PetitionShareholders[PetitionShareholderMap[msg.sender]].sharesListedForSale = PetitionShareholders[PetitionShareholderMap[msg.sender]].sharesListedForSale - _amount;
376 
377         // new div pool?
378         endDividendPool();
379 
380     }
381 
382     // p2p share listing, selling and buying
383     function listSharesForSale(uint _amount, uint _price) public {
384         require(ownerPetitionShareholderArrayCreated[msg.sender] > 0);
385         require((PetitionShareholders[PetitionShareholderMap[msg.sender]].shares - PetitionShareholders[PetitionShareholderMap[msg.sender]].sharesListedForSale) >= _amount);
386         
387         PetitionShareholders[PetitionShareholderMap[msg.sender]].sharesListedForSale = PetitionShareholders[PetitionShareholderMap[msg.sender]].sharesListedForSale + _amount;
388 
389         uint id = listings.push(ShareholderListing(PetitionShareholderMap[msg.sender], _amount, _price, false)) - 1;
390         emit NewShareholderListing(id, PetitionShareholderMap[msg.sender], _amount, _price, false);
391 
392         // new div pool?
393         endDividendPool();
394         
395     }
396 
397     function viewShareholderListing(uint _shareholderListingId)view public returns (uint, uint, uint, uint, bool) {
398         ShareholderListing storage listing = listings[_shareholderListingId];
399         return (_shareholderListingId, listing.petitionShareholderId, listing.sharesForSale, listing.price, listing.sold);
400     }
401 
402     function removeShareholderListing(uint _shareholderListingId) public {
403         ShareholderListing storage listing = listings[_shareholderListingId];
404         require(PetitionShareholderMap[msg.sender] == listing.petitionShareholderId);
405 
406         PetitionShareholders[listing.petitionShareholderId].sharesListedForSale = PetitionShareholders[listing.petitionShareholderId].sharesListedForSale - listing.sharesForSale;
407 
408         delete listings[_shareholderListingId];
409 
410         // new div pool?
411         endDividendPool();
412         
413     }
414 
415     function buySharesFromListing(uint _shareholderListingId) payable public {
416         ShareholderListing storage listing = listings[_shareholderListingId];
417         require(msg.value >= listing.price);
418         require(listing.sold == false);
419         require(listing.sharesForSale > 0);
420         
421         // give to buyer
422         if (ownerPetitionShareholderArrayCreated[msg.sender] == 0) {
423             // new investor
424             uint id = PetitionShareholders.push(PetitionShareholder(msg.sender, listing.sharesForSale, 0, now)) - 1;
425             emit NewPetitionShareholder(id, msg.sender, listing.sharesForSale, 0, now);
426             PetitionShareholderMap[msg.sender] = id;
427             ownerPetitionShareholderArrayCreated[msg.sender] = 1;
428 
429         } else {
430             // add to amount
431             PetitionShareholders[PetitionShareholderMap[msg.sender]].shares = PetitionShareholders[PetitionShareholderMap[msg.sender]].shares + listing.sharesForSale;
432 
433         }
434 
435         listing.sold = true;
436 
437         // take from seller
438         PetitionShareholders[listing.petitionShareholderId].shares = PetitionShareholders[listing.petitionShareholderId].shares - listing.sharesForSale;
439         PetitionShareholders[listing.petitionShareholderId].sharesListedForSale = PetitionShareholders[listing.petitionShareholderId].sharesListedForSale - listing.sharesForSale;
440 
441         // 1% fee
442         uint calcFee = SafeMath.div(msg.value, peerToPeerMarketplaceTransactionFee);
443         cutToInvestorsDividendPool(calcFee);
444 
445         // transfer funds to seller
446         uint toSeller = SafeMath.sub(msg.value, calcFee);
447         PetitionShareholders[listing.petitionShareholderId].PetitionShareholderAddress.transfer(toSeller);
448 
449         // new div pool?
450         endDividendPool();
451 
452     }
453 
454     /********************************* */
455     // petition functions
456 
457     function createPetition(string _name, string _message, uint _signaturesNeeded, bool _featured, string _connectingHash) payable public {
458         require(msg.value >= createPetitionFee);
459         uint featuredExpires = 0;
460         uint totalPaid = createPetitionFee;
461         if (_featured) {
462             require(msg.value >= (createPetitionFee + featurePetitionFee));
463             featuredExpires = now + featuredLength;
464             totalPaid = totalPaid + featurePetitionFee;
465         }
466 
467         /////////////
468         // cut to shareholders dividend pool:
469         cutToInvestorsDividendPool(totalPaid);
470 
471         //////////
472 
473         uint id = petitions.push(Petition(_name, _message, msg.sender, _signaturesNeeded, _featured, featuredExpires, 0, now, _connectingHash, 0)) - 1;
474         emit NewPetition(id, _name, _message, msg.sender, _signaturesNeeded, _featured, featuredExpires, 0, now, _connectingHash, 0);
475 
476     }
477 
478     function renewFeatured(uint _petitionId) payable public {
479         require(msg.value >= featurePetitionFee);
480 
481         uint featuredExpires = 0;
482         if (now > petitions[_petitionId].featuredExpires) {
483             featuredExpires = now + featuredLength;
484         }else {
485             featuredExpires = petitions[_petitionId].featuredExpires + featuredLength;
486         }
487 
488         petitions[_petitionId].featuredExpires = featuredExpires;
489 
490         /////////////
491         // cut to shareholders dividend pool:
492         cutToInvestorsDividendPool(msg.value);
493 
494     }
495 
496     function viewPetition(uint _petitionId) view public returns (uint, string, string, address, uint, bool, uint, uint, uint, string, uint) {
497         Petition storage petition = petitions[_petitionId];
498         return (_petitionId, petition.name, petition.message, petition.creator, petition.signaturesNeeded, petition.featured, petition.featuredExpires, petition.totalSignatures, petition.created, petition.connectingHash, petition.advertisingBudget);
499     }
500 
501     function viewPetitionSignerWithAddress(address _ownerAddress, uint _petitionId) view public returns (uint, uint, address, uint) {
502         require (ownerPetitionSignerArrayCreated[_ownerAddress][_petitionId] > 0);
503 
504         PetitionSigner storage signers = petitionsigners[petitionSignerMap[_ownerAddress][_petitionId]];
505         return (petitionSignerMap[_ownerAddress][_petitionId], signers.petitionId, signers.petitionSignerAddress, signers.signed);
506     }
507 
508     function viewPetitionSigner(uint _petitionSignerId) view public returns (uint, uint, address, uint) {
509         PetitionSigner storage signers = petitionsigners[_petitionSignerId];
510         return (_petitionSignerId, signers.petitionId, signers.petitionSignerAddress, signers.signed);
511     }
512 
513     function advertisingDeposit (uint _petitionId) payable public {
514         petitions[_petitionId].advertisingBudget = SafeMath.add(petitions[_petitionId].advertisingBudget, msg.value);
515 
516         /////////////
517         // cut to shareholders dividend pool -> since its advertising we can cut 100% of the msg.value to everyone
518         cutToInvestorsDividendPool(msg.value);
519 
520     }
521 
522     function cutToInvestorsDividendPool(uint totalPaid) internal {
523         //
524         // removed this because as petition.io we still have to claim owned shares % worth from the dividendpool.
525 
526         // calc cut for Petition.io
527         //uint firstDiv = SafeMath.div(PetitionShareholders[PetitionShareholderMap[ownerShareAddress]].shares, sharesSold);
528         //uint petitionIoDivAmt = SafeMath.mul(totalPaid, firstDiv);
529         //availableForWithdraw = availableForWithdraw + petitionIoDivAmt;
530         // calc for shareholders
531         //uint divAmt = SafeMath.sub(totalPaid, petitionIoDivAmt);
532         // add to investors dividend pool
533         //currentDividendPool = SafeMath.add(currentDividendPool, divAmt);
534 
535         currentDividendPool = SafeMath.add(currentDividendPool, totalPaid);
536 
537         // new div pool?
538         endDividendPool();
539 
540     }
541 
542     function advertisingUse (uint _petitionId, uint amount) public {
543         require(petitions[_petitionId].creator == msg.sender);
544         require(petitions[_petitionId].advertisingBudget >= amount);
545         // (fills out advertising information on website and funds it here)
546         petitions[_petitionId].advertisingBudget = petitions[_petitionId].advertisingBudget - amount;
547 
548     }
549 
550     /********************************* */
551     // sign function
552 
553     function sign (uint _petitionId) public {
554         // cant send it to a non existing petition
555         require (keccak256(petitions[_petitionId].name) != keccak256(""));
556         require (ownerPetitionSignerArrayCreated[msg.sender][_petitionId] == 0);
557 
558         //if (ownerPetitionSignerArrayCreated[msg.sender][_petitionId] == 0) {
559             
560         uint id = petitionsigners.push(PetitionSigner(_petitionId, msg.sender, now)) - 1;
561         emit NewPetitionSigner(id, _petitionId, msg.sender, now);
562         petitionSignerMap[msg.sender][_petitionId] = id;
563         ownerPetitionSignerArrayCreated[msg.sender][_petitionId] = 1;
564         
565         petitions[_petitionId].totalSignatures = petitions[_petitionId].totalSignatures + 1;
566 
567         //}
568 
569         // new div pool?
570         endDividendPool();
571 
572     }
573 
574     /********************************* */
575     // unsign function
576 
577     function unsign (uint _petitionId) public {
578         require (ownerPetitionSignerArrayCreated[msg.sender][_petitionId] == 1);
579 
580         ownerPetitionSignerArrayCreated[msg.sender][_petitionId] = 0;
581 
582         petitions[_petitionId].totalSignatures = petitions[_petitionId].totalSignatures - 1;
583 
584         delete petitionsigners[petitionSignerMap[msg.sender][_petitionId]];
585 
586         delete petitionSignerMap[msg.sender][_petitionId];
587 
588     }
589 
590     /********************************* */
591     // start admin functions
592 
593     function initialOwnersShares() public onlyOwner(){
594         require(initialOwnerSharesClaimed == 0);
595 
596         uint numberOfShares = 1000000;
597 
598         uint id = PetitionShareholders.push(PetitionShareholder(msg.sender, numberOfShares, 0, now)) - 1;
599         emit NewPetitionShareholder(id, msg.sender, numberOfShares, 0, now);
600         PetitionShareholderMap[msg.sender] = id;
601         ownerPetitionShareholderArrayCreated[msg.sender] = 1;
602         
603         sharesSold = sharesSold + numberOfShares;
604 
605         ownerShareAddress = msg.sender;
606 
607         // dividend pool
608         dividendPoolStarts = now;
609         dividendPoolEnds = (now + dividendCooldown);
610 
611         initialOwnerSharesClaimed = 1; // owner can only claim the intial 1,000,000 shares once
612     }
613 
614     function companyShares() public view returns(uint){
615         return PetitionShareholders[PetitionShareholderMap[ownerShareAddress]].shares;
616     }
617     
618     function alterDividendCooldown (uint _dividendCooldown) public onlyOwner() {
619         dividendCooldown = _dividendCooldown;
620     }
621 
622     function spendAdvertising(uint _petitionId, uint amount) public onlyOwner() {
623         require(petitions[_petitionId].advertisingBudget >= amount);
624 
625         petitions[_petitionId].advertisingBudget = petitions[_petitionId].advertisingBudget - amount;
626     }
627 
628     function viewFeaturedLength() public view returns(uint) {
629         return featuredLength;
630     }
631 
632     function alterFeaturedLength (uint _newFeaturedLength) public onlyOwner() {
633         featuredLength = _newFeaturedLength;
634     }
635 
636     function viewInitialPricePerShare() public view returns(uint) {
637         return initialPricePerShare;
638     }
639 
640     function alterInitialPricePerShare (uint _initialPricePerShare) public onlyOwner() {
641         initialPricePerShare = _initialPricePerShare;
642     }
643 
644     function viewCreatePetitionFee() public view returns(uint) {
645         return createPetitionFee;
646     }
647 
648     function alterCreatePetitionFee (uint _createPetitionFee) public onlyOwner() {
649         createPetitionFee = _createPetitionFee;
650     }
651 
652     function alterPeerToPeerMarketplaceTransactionFee (uint _peerToPeerMarketplaceTransactionFee) public onlyOwner() {
653         peerToPeerMarketplaceTransactionFee = _peerToPeerMarketplaceTransactionFee;
654     }
655 
656     function viewPeerToPeerMarketplaceTransactionFee() public view returns(uint) {
657         return peerToPeerMarketplaceTransactionFee;
658     }
659 
660     function viewFeaturePetitionFee() public view returns(uint) {
661         return featurePetitionFee;
662     }
663 
664     function alterFeaturePetitionFee (uint _featurePetitionFee) public onlyOwner() {
665         featurePetitionFee = _featurePetitionFee;
666     }
667 
668     function withdrawFromAmt() public view returns(uint) {
669         return availableForWithdraw;
670     }
671 
672     function withdrawFromContract(address _to, uint _amount) payable external onlyOwner() {
673         require(_amount <= availableForWithdraw);
674         availableForWithdraw = availableForWithdraw - _amount;
675         _to.transfer(_amount);
676 
677         // new div pool?
678         endDividendPool();
679 
680     }
681 
682     /*
683     NOTE: Instead of adding this function to the smart contract and have the power of deleting a petition (having this power doesnt sound very decentralized), in case of anything inappropriate: Petition.io will instead flag the said petition from showing up on the website. Sure someone can make their own website and link to our smart contract and show all the dirty stuff people will inevitably post.. go for it.
684     function deletePetition(uint _petitionId) public onlyOwner() {
685         delete petitions[_petitionId];
686     }*/
687 
688 }