1 pragma solidity ^0.4.21;
2 
3 library BWUtility {
4     
5     // -------- UTILITY FUNCTIONS ----------
6 
7 
8     // Return next higher even _multiple for _amount parameter (e.g used to round up to even finneys).
9     function ceil(uint _amount, uint _multiple) pure public returns (uint) {
10         return ((_amount + _multiple - 1) / _multiple) * _multiple;
11     }
12 
13     // Checks if two coordinates are adjacent:
14     // xxx
15     // xox
16     // xxx
17     // All x (_x2, _xy2) are adjacent to o (_x1, _y1) in this ascii image. 
18     // Adjacency does not wrapp around map edges so if y2 = 255 and y1 = 0 then they are not ajacent
19     function isAdjacent(uint8 _x1, uint8 _y1, uint8 _x2, uint8 _y2) pure public returns (bool) {
20         return ((_x1 == _x2 &&      (_y2 - _y1 == 1 || _y1 - _y2 == 1))) ||      // Same column
21                ((_y1 == _y2 &&      (_x2 - _x1 == 1 || _x1 - _x2 == 1))) ||      // Same row
22                ((_x2 - _x1 == 1 &&  (_y2 - _y1 == 1 || _y1 - _y2 == 1))) ||      // Right upper or lower diagonal
23                ((_x1 - _x2 == 1 &&  (_y2 - _y1 == 1 || _y1 - _y2 == 1)));        // Left upper or lower diagonal
24     }
25 
26     // Converts (x, y) to tileId xy
27     function toTileId(uint8 _x, uint8 _y) pure public returns (uint16) {
28         return uint16(_x) << 8 | uint16(_y);
29     }
30 
31     // Converts _tileId to (x, y)
32     function fromTileId(uint16 _tileId) pure public returns (uint8, uint8) {
33         uint8 y = uint8(_tileId);
34         uint8 x = uint8(_tileId >> 8);
35         return (x, y);
36     }
37     
38     function getBoostFromTile(address _claimer, address _attacker, address _defender, uint _blockValue) pure public returns (uint, uint) {
39         if (_claimer == _attacker) {
40             return (_blockValue, 0);
41         } else if (_claimer == _defender) {
42             return (0, _blockValue);
43         }
44     }
45 }
46 
47 contract BWData {
48     address public owner;
49     address private bwService;
50     address private bw;
51     address private bwMarket;
52 
53     uint private blockValueBalance = 0;
54     uint private feeBalance = 0;
55     uint private BASE_TILE_PRICE_WEI = 1 finney; // 1 milli-ETH.
56     
57     mapping (address => User) private users; // user address -> user information
58     mapping (uint16 => Tile) private tiles; // tileId -> list of TileClaims for that particular tile
59     
60     // Info about the users = those who have purchased tiles.
61     struct User {
62         uint creationTime;
63         bool censored;
64         uint battleValue;
65     }
66 
67     // Info about a tile ownership
68     struct Tile {
69         address claimer;
70         uint blockValue;
71         uint creationTime;
72         uint sellPrice;    // If 0 -> not on marketplace. If > 0 -> on marketplace.
73     }
74 
75     struct Boost {
76         uint8 numAttackBoosts;
77         uint8 numDefendBoosts;
78         uint attackBoost;
79         uint defendBoost;
80     }
81 
82     constructor() public {
83         owner = msg.sender;
84     }
85 
86     // Can't send funds straight to this contract. Avoid people sending by mistake.
87     function () payable public {
88         revert();
89     }
90 
91     function kill() public isOwner {
92         selfdestruct(owner);
93     }
94 
95     modifier isValidCaller {
96         if (msg.sender != bwService && msg.sender != bw && msg.sender != bwMarket) {
97             revert();
98         }
99         _;
100     }
101     
102     modifier isOwner {
103         if (msg.sender != owner) {
104             revert();
105         }
106         _;
107     }
108     
109     function setBwServiceValidCaller(address _bwService) public isOwner {
110         bwService = _bwService;
111     }
112 
113     function setBwValidCaller(address _bw) public isOwner {
114         bw = _bw;
115     }
116 
117     function setBwMarketValidCaller(address _bwMarket) public isOwner {
118         bwMarket = _bwMarket;
119     }    
120     
121     // ----------USER-RELATED GETTER FUNCTIONS------------
122     
123     //function getUser(address _user) view public returns (bytes32) {
124         //BWUtility.User memory user = users[_user];
125         //require(user.creationTime != 0);
126         //return (user.creationTime, user.imageUrl, user.tag, user.email, user.homeUrl, user.creationTime, user.censored, user.battleValue);
127     //}
128     
129     function addUser(address _msgSender) public isValidCaller {
130         User storage user = users[_msgSender];
131         require(user.creationTime == 0);
132         user.creationTime = block.timestamp;
133     }
134 
135     function hasUser(address _user) view public isValidCaller returns (bool) {
136         return users[_user].creationTime != 0;
137     }
138     
139 
140     // ----------TILE-RELATED GETTER FUNCTIONS------------
141 
142     function getTile(uint16 _tileId) view public isValidCaller returns (address, uint, uint, uint) {
143         Tile storage currentTile = tiles[_tileId];
144         return (currentTile.claimer, currentTile.blockValue, currentTile.creationTime, currentTile.sellPrice);
145     }
146     
147     function getTileClaimerAndBlockValue(uint16 _tileId) view public isValidCaller returns (address, uint) {
148         Tile storage currentTile = tiles[_tileId];
149         return (currentTile.claimer, currentTile.blockValue);
150     }
151     
152     function isNewTile(uint16 _tileId) view public isValidCaller returns (bool) {
153         Tile storage currentTile = tiles[_tileId];
154         return currentTile.creationTime == 0;
155     }
156     
157     function storeClaim(uint16 _tileId, address _claimer, uint _blockValue) public isValidCaller {
158         tiles[_tileId] = Tile(_claimer, _blockValue, block.timestamp, 0);
159     }
160 
161     function updateTileBlockValue(uint16 _tileId, uint _blockValue) public isValidCaller {
162         tiles[_tileId].blockValue = _blockValue;
163     }
164 
165     function setClaimerForTile(uint16 _tileId, address _claimer) public isValidCaller {
166         tiles[_tileId].claimer = _claimer;
167     }
168 
169     function updateTileTimeStamp(uint16 _tileId) public isValidCaller {
170         tiles[_tileId].creationTime = block.timestamp;
171     }
172     
173     function getCurrentClaimerForTile(uint16 _tileId) view public isValidCaller returns (address) {
174         Tile storage currentTile = tiles[_tileId];
175         if (currentTile.creationTime == 0) {
176             return 0;
177         }
178         return currentTile.claimer;
179     }
180 
181     function getCurrentBlockValueAndSellPriceForTile(uint16 _tileId) view public isValidCaller returns (uint, uint) {
182         Tile storage currentTile = tiles[_tileId];
183         if (currentTile.creationTime == 0) {
184             return (0, 0);
185         }
186         return (currentTile.blockValue, currentTile.sellPrice);
187     }
188     
189     function getBlockValueBalance() view public isValidCaller returns (uint){
190         return blockValueBalance;
191     }
192 
193     function setBlockValueBalance(uint _blockValueBalance) public isValidCaller {
194         blockValueBalance = _blockValueBalance;
195     }
196 
197     function getFeeBalance() view public isValidCaller returns (uint) {
198         return feeBalance;
199     }
200 
201     function setFeeBalance(uint _feeBalance) public isValidCaller {
202         feeBalance = _feeBalance;
203     }
204     
205     function getUserBattleValue(address _userId) view public isValidCaller returns (uint) {
206         return users[_userId].battleValue;
207     }
208     
209     function setUserBattleValue(address _userId, uint _battleValue) public  isValidCaller {
210         users[_userId].battleValue = _battleValue;
211     }
212     
213     function verifyAmount(address _msgSender, uint _msgValue, uint _amount, bool _useBattleValue) view public isValidCaller {
214         User storage user = users[_msgSender];
215         require(user.creationTime != 0);
216 
217         if (_useBattleValue) {
218             require(_msgValue == 0);
219             require(user.battleValue >= _amount);
220         } else {
221             require(_amount == _msgValue);
222         }
223     }
224     
225     function addBoostFromTile(Tile _tile, address _attacker, address _defender, Boost memory _boost) pure private {
226         if (_tile.claimer == _attacker) {
227             require(_boost.attackBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
228             _boost.attackBoost += _tile.blockValue;
229             _boost.numAttackBoosts += 1;
230         } else if (_tile.claimer == _defender) {
231             require(_boost.defendBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
232             _boost.defendBoost += _tile.blockValue;
233             _boost.numDefendBoosts += 1;
234         }
235     }
236 
237     function calculateBattleBoost(uint16 _tileId, address _attacker, address _defender) view public isValidCaller returns (uint, uint) {
238         uint8 x;
239         uint8 y;
240 
241         (x, y) = BWUtility.fromTileId(_tileId);
242 
243         Boost memory boost = Boost(0, 0, 0, 0);
244         // We overflow x, y on purpose here if x or y is 0 or 255 - the map overflows and so should adjacency.
245         // Go through all adjacent tiles to (x, y).
246         if (y != 255) {
247             if (x != 255) {
248                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y+1)], _attacker, _defender, boost);
249             }
250             
251             addBoostFromTile(tiles[BWUtility.toTileId(x, y+1)], _attacker, _defender, boost);
252 
253             if (x != 0) {
254                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y+1)], _attacker, _defender, boost);
255             }
256         }
257 
258         if (x != 255) {
259             addBoostFromTile(tiles[BWUtility.toTileId(x+1, y)], _attacker, _defender, boost);
260         }
261 
262         if (x != 0) {
263             addBoostFromTile(tiles[BWUtility.toTileId(x-1, y)], _attacker, _defender, boost);
264         }
265 
266         if (y != 0) {
267             if(x != 255) {
268                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y-1)], _attacker, _defender, boost);
269             }
270 
271             addBoostFromTile(tiles[BWUtility.toTileId(x, y-1)], _attacker, _defender, boost);
272 
273             if(x != 0) {
274                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y-1)], _attacker, _defender, boost);
275             }
276         }
277         // The benefit of boosts is multiplicative (quadratic):
278         // - More boost tiles gives a higher total blockValue (the sum of the adjacent tiles)
279         // - More boost tiles give a higher multiple of that total blockValue that can be used (10% per adjacent tie)
280         // Example:
281         //   A) I boost attack with 1 single tile worth 10 finney
282         //      -> Total boost is 10 * 1 / 10 = 1 finney
283         //   B) I boost attack with 3 tiles worth 1 finney each
284         //      -> Total boost is (1+1+1) * 3 / 10 = 0.9 finney
285         //   C) I boost attack with 8 tiles worth 2 finney each
286         //      -> Total boost is (2+2+2+2+2+2+2+2) * 8 / 10 = 14.4 finney
287         //   D) I boost attack with 3 tiles of 1, 5 and 10 finney respectively
288         //      -> Total boost is (ss1+5+10) * 3 / 10 = 4.8 finney
289         // This division by 10 can't create fractions since our uint is wei, and we can't have overflow from the multiplication
290         // We do allow fractions of finney here since the boosted values aren't stored anywhere, only used for attack rolls and sent in events
291         boost.attackBoost = (boost.attackBoost / 10 * boost.numAttackBoosts);
292         boost.defendBoost = (boost.defendBoost / 10 * boost.numDefendBoosts);
293 
294         return (boost.attackBoost, boost.defendBoost);
295     }
296     
297     function censorUser(address _userAddress, bool _censored) public isValidCaller {
298         User storage user = users[_userAddress];
299         require(user.creationTime != 0);
300         user.censored = _censored;
301     }
302     
303     function deleteTile(uint16 _tileId) public isValidCaller {
304         delete tiles[_tileId];
305     }
306     
307     function setSellPrice(uint16 _tileId, uint _sellPrice) public isValidCaller {
308         tiles[_tileId].sellPrice = _sellPrice;  //testrpc cannot estimate gas when delete is used.
309     }
310 
311     function deleteOffer(uint16 _tileId) public isValidCaller {
312         tiles[_tileId].sellPrice = 0;  //testrpc cannot estimate gas when delete is used.
313     }
314 }
315 
316 interface ERC20I {
317     function transfer(address _recipient, uint256 _amount) external returns (bool);
318     function balanceOf(address _holder) external view returns (uint256);
319 }
320 
321 
322 contract BWService {
323     address private owner;
324     address private bw;
325     address private bwMarket;
326     BWData private bwData;
327     uint private seed = 42;
328     uint private WITHDRAW_FEE = 20; //1/20 = 5%
329     
330     modifier isOwner {
331         if (msg.sender != owner) {
332             revert();
333         }
334         _;
335     }  
336 
337     modifier isValidCaller {
338         if (msg.sender != bw && msg.sender != bwMarket) {
339             revert();
340         }
341         _;
342     }
343 
344     event TileClaimed(uint16 tileId, address newClaimer, uint priceInWei, uint creationTime);
345     event TileFortified(uint16 tileId, address claimer, uint addedValueInWei, uint priceInWei, uint fortifyTime); // Sent when a user fortifies an existing claim by bumping its value.
346     event TileAttackedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint attackTime); // Sent when a user successfully attacks a tile.    
347     event TileDefendedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint defendTime); // Sent when a user successfully defends a tile when attacked.    
348     event BlockValueMoved(uint16 sourceTileId, uint16 destTileId, address owner, uint movedBlockValue, uint postSourceValue, uint postDestValue, uint moveTime); // Sent when a user buys a tile from another user, by accepting a tile offer
349     event UserBattleValueUpdated(address userAddress, uint battleValue, bool isWithdraw);
350 
351     // Constructor.
352     constructor(address _bwData) public {
353         bwData = BWData(_bwData);
354         owner = msg.sender;
355     }
356 
357     // Can't send funds straight to this contract. Avoid people sending by mistake.
358     function () payable public {
359         revert();
360     }
361 
362     // OWNER-ONLY FUNCTIONS
363     function kill() public isOwner {
364         selfdestruct(owner);
365     }
366 
367     function setValidBwCaller(address _bw) public isOwner {
368         bw = _bw;
369     }
370     
371     function setValidBwMarketCaller(address _bwMarket) public isOwner {
372         bwMarket = _bwMarket;
373     }
374 
375 
376     // TILE-RELATED FUNCTIONS
377     // This function claims multiple previously unclaimed tiles in a single transaction.
378     // The value assigned to each tile is the msg.value divided by the number of tiles claimed.
379     // The msg.value is required to be an even multiple of the number of tiles claimed.
380     function storeInitialClaim(address _msgSender, uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) public isValidCaller {
381         uint tileCount = _claimedTileIds.length;
382         require(tileCount > 0);
383         require(_claimAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
384         require(_claimAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles claimed
385 
386         uint valuePerBlockInWei = _claimAmount / tileCount; // Due to requires above this is guaranteed to be an even number
387 
388         if (_useBattleValue) {
389             subUserBattleValue(_msgSender, _claimAmount, false);  
390         }
391 
392         addGlobalBlockValueBalance(_claimAmount);
393 
394         uint16 tileId;
395         bool isNewTile;
396         for (uint16 i = 0; i < tileCount; i++) {
397             tileId = _claimedTileIds[i];
398             isNewTile = bwData.isNewTile(tileId); // Is length 0 if first time purchased
399             require(isNewTile); // Can only claim previously unclaimed tiles.
400 
401             // Send claim event
402             emit TileClaimed(tileId, _msgSender, valuePerBlockInWei, block.timestamp);
403 
404             // Update contract state with new tile ownership.
405             bwData.storeClaim(tileId, _msgSender, valuePerBlockInWei);
406         }
407     }
408 
409     function fortifyClaims(address _msgSender, uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) public isValidCaller {
410         uint tileCount = _claimedTileIds.length;
411         require(tileCount > 0);
412 
413         uint balance = address(this).balance;
414         require(balance + _fortifyAmount > balance); // prevent overflow
415         require(_fortifyAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles fortified
416         uint addedValuePerTileInWei = _fortifyAmount / tileCount; // Due to requires above this is guaranteed to be an even number
417         require(_fortifyAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
418 
419         address claimer;
420         uint blockValue;
421         for (uint16 i = 0; i < tileCount; i++) {
422             (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_claimedTileIds[i]);
423             require(claimer != 0); // Can't do this on never-owned tiles
424             require(claimer == _msgSender); // Only current claimer can fortify claim
425 
426             if (_useBattleValue) {
427                 subUserBattleValue(_msgSender, addedValuePerTileInWei, false);
428             }
429             
430             fortifyClaim(_msgSender, _claimedTileIds[i], addedValuePerTileInWei);
431         }
432     }
433 
434     function fortifyClaim(address _msgSender, uint16 _claimedTileId, uint _fortifyAmount) private {
435         uint blockValue;
436         uint sellPrice;
437         (blockValue, sellPrice) = bwData.getCurrentBlockValueAndSellPriceForTile(_claimedTileId);
438         uint updatedBlockValue = blockValue + _fortifyAmount;
439         // Send fortify event
440         emit TileFortified(_claimedTileId, _msgSender, _fortifyAmount, updatedBlockValue, block.timestamp);
441         
442         // Update tile value. The tile has been fortified by bumping up its value.
443         bwData.updateTileBlockValue(_claimedTileId, updatedBlockValue);
444 
445         // Track addition to global block value
446         addGlobalBlockValueBalance(_fortifyAmount);
447     }
448 
449     // Return a pseudo random number between lower and upper bounds
450     // given the number of previous blocks it should hash.
451     // Random function copied from https://github.com/axiomzen/eth-random/blob/master/contracts/Random.sol.
452     // Changed sha3 to keccak256.
453     // Changed random range from uint64 to uint (=uint256).
454     function random(uint _upper) private returns (uint)  {
455         seed = uint(keccak256(keccak256(blockhash(block.number), seed), now));
456         return seed % _upper;
457     }
458 
459     // A user tries to claim a tile that's already owned by another user. A battle ensues.
460     // A random roll is done with % based on attacking vs defending amounts.
461     function attackTile(address _msgSender, uint16 _tileId, uint _attackAmount, bool _useBattleValue, bool _autoFortify) public isValidCaller {
462         require(_attackAmount >= 1 finney);         // Don't allow attacking with less than one base tile price.
463         require(_attackAmount % 1 finney == 0);
464 
465         address claimer;
466         uint blockValue;
467         (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_tileId);
468         
469         require(claimer != 0); // Can't do this on never-owned tiles
470         require(claimer != _msgSender); // Can't attack one's own tiles
471         require(claimer != owner); // Can't attack owner's tiles because it is used for raffle.
472 
473         // Calculate boosted amounts for attacker and defender
474         // The base attack amount is sent in the by the user.
475         // The base defend amount is the attacked tile's current blockValue.
476         uint attackBoost;
477         uint defendBoost;
478         (attackBoost, defendBoost) = bwData.calculateBattleBoost(_tileId, _msgSender, claimer);
479         uint totalAttackAmount = _attackAmount + attackBoost;
480         uint totalDefendAmount = blockValue + defendBoost;
481         require(totalAttackAmount >= _attackAmount); // prevent overflow
482         require(totalDefendAmount >= blockValue); // prevent overflow
483         require(totalAttackAmount + totalDefendAmount > totalAttackAmount && totalAttackAmount + totalDefendAmount > totalDefendAmount); // Prevent overflow
484 
485         // Verify that attack odds are within allowed range.
486         require(_attackAmount / 10 <= blockValue); // Disallow attacks with more than 1000% of defendAmount
487         require(_attackAmount >= blockValue / 10); // Disallow attacks with less than 10% of defendAmount
488 
489         // The battle considers boosts.
490         uint attackRoll = random(totalAttackAmount + totalDefendAmount); // This is where the excitement happens!
491         if (attackRoll > totalDefendAmount) {
492             // Send update event
493             emit TileAttackedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
494 
495             // Change block owner but keep same block value (attacker got battlevalue instead)
496             bwData.setClaimerForTile(_tileId, _msgSender);
497 
498             // Tile successfully attacked!
499             if (_useBattleValue) {
500                 if (_autoFortify) {
501                     // Fortify the won tile using battle value
502                     fortifyClaim(_msgSender, _tileId, _attackAmount);
503                     subUserBattleValue(_msgSender, _attackAmount, false);
504                 } else {
505                     // No reason to withdraw followed by deposit of same amount
506                 }
507             } else {
508                 if (_autoFortify) {
509                     // Fortify the won tile using attack amount
510                     fortifyClaim(_msgSender, _tileId, _attackAmount);
511                 } else {
512                     addUserBattleValue(_msgSender, _attackAmount); // Don't include boost here!
513                 }
514             }
515         } else {
516             // Tile successfully defended!
517             if (_useBattleValue) {
518                 subUserBattleValue(_msgSender, _attackAmount, false); // Don't include boost here!
519             }
520             addUserBattleValue(claimer, _attackAmount); // Don't include boost here!
521 
522             // Send update event
523             emit TileDefendedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
524 
525             // Update the timestamp for the defended block.
526             bwData.updateTileTimeStamp(_tileId);
527         }
528     }
529 
530     function moveBlockValue(address _msgSender, uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isValidCaller {
531         uint16 sourceTileId = BWUtility.toTileId(_xSource, _ySource);
532         uint16 destTileId = BWUtility.toTileId(_xDest, _yDest);
533 
534         address sourceTileClaimer;
535         address destTileClaimer;
536         uint sourceTileBlockValue;
537         uint destTileBlockValue;
538         (sourceTileClaimer, sourceTileBlockValue) = bwData.getTileClaimerAndBlockValue(sourceTileId);
539         (destTileClaimer, destTileBlockValue) = bwData.getTileClaimerAndBlockValue(destTileId);
540 
541         require(sourceTileClaimer == _msgSender);
542         require(destTileClaimer == _msgSender);
543         require(_moveAmount >= 1 finney); // Can't be less
544         require(_moveAmount % 1 finney == 0); // Move amount must be in multiples of 1 finney
545         // require(sourceTile.blockValue - _moveAmount >= BASE_TILE_PRICE_WEI); // Must always leave some at source
546         
547         require(sourceTileBlockValue - _moveAmount < sourceTileBlockValue); // Prevent overflow
548         require(destTileBlockValue + _moveAmount > destTileBlockValue); // Prevent overflow
549         require(BWUtility.isAdjacent(_xSource, _ySource, _xDest, _yDest));
550 
551         sourceTileBlockValue -= _moveAmount;
552         destTileBlockValue += _moveAmount;
553 
554         // If ALL block value was moved away from the source tile, we lose our claim to it. It becomes ownerless.
555         if (sourceTileBlockValue == 0) {
556             bwData.deleteTile(sourceTileId);
557         } else {
558             bwData.updateTileBlockValue(sourceTileId, sourceTileBlockValue);
559             bwData.deleteOffer(sourceTileId); // Offer invalid since block value has changed
560         }
561 
562         bwData.updateTileBlockValue(destTileId, destTileBlockValue);
563         bwData.deleteOffer(destTileId);   // Offer invalid since block value has changed
564         emit BlockValueMoved(sourceTileId, destTileId, _msgSender, _moveAmount, sourceTileBlockValue, destTileBlockValue, block.timestamp);        
565     }
566 
567 
568     // BATTLE VALUE FUNCTIONS
569     function withdrawBattleValue(address msgSender, uint _battleValueInWei) public isValidCaller returns (uint) {
570         require(bwData.hasUser(msgSender));
571         require(_battleValueInWei % 1 finney == 0); // Must be divisible by 1 finney
572         uint fee = _battleValueInWei / WITHDRAW_FEE; // Since we divide by 20 we can never create infinite fractions, so we'll always count in whole wei amounts.
573         require(_battleValueInWei - fee < _battleValueInWei); // prevent underflow
574 
575         uint amountToWithdraw = _battleValueInWei - fee;
576         uint feeBalance = bwData.getFeeBalance();
577         require(feeBalance + fee >= feeBalance); // prevent overflow
578         feeBalance += fee;
579         bwData.setFeeBalance(feeBalance);
580         subUserBattleValue(msgSender, _battleValueInWei, true);
581         return amountToWithdraw;
582     }
583 
584     function addUserBattleValue(address _userId, uint _amount) public isValidCaller {
585         uint userBattleValue = bwData.getUserBattleValue(_userId);
586         require(userBattleValue + _amount > userBattleValue); // prevent overflow
587         uint newBattleValue = userBattleValue + _amount;
588         bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
589         emit UserBattleValueUpdated(_userId, newBattleValue, false);
590     }
591     
592     function subUserBattleValue(address _userId, uint _amount, bool _isWithdraw) public isValidCaller {
593         uint userBattleValue = bwData.getUserBattleValue(_userId);
594         require(_amount <= userBattleValue); // Must be less than user's battle value - also implicitly checks that underflow isn't possible
595         uint newBattleValue = userBattleValue - _amount;
596         bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
597         emit UserBattleValueUpdated(_userId, newBattleValue, _isWithdraw);
598     }
599 
600     function addGlobalBlockValueBalance(uint _amount) public isValidCaller {
601         // Track addition to global block value.
602         uint blockValueBalance = bwData.getBlockValueBalance();
603         require(blockValueBalance + _amount > blockValueBalance); // Prevent overflow
604         bwData.setBlockValueBalance(blockValueBalance + _amount);
605     }
606 
607     // Allow us to transfer out airdropped tokens if we ever receive any
608     function transferTokens(address _tokenAddress, address _recipient) public isOwner {
609         ERC20I token = ERC20I(_tokenAddress);
610         require(token.transfer(_recipient, token.balanceOf(this)));
611     }
612 }