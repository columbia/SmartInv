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
321 contract BWService {
322     address private owner;
323     address private bw;
324     address private bwMarket;
325     BWData private bwData;
326     uint private seed = 42;
327     uint private WITHDRAW_FEE = 20; //1/20 = 5%
328     
329     modifier isOwner {
330         if (msg.sender != owner) {
331             revert();
332         }
333         _;
334     }  
335 
336     modifier isValidCaller {
337         if (msg.sender != bw && msg.sender != bwMarket) {
338             revert();
339         }
340         _;
341     }
342 
343     event TileClaimed(uint16 tileId, address newClaimer, uint priceInWei, uint creationTime);
344     event TileFortified(uint16 tileId, address claimer, uint addedValueInWei, uint priceInWei, uint fortifyTime); // Sent when a user fortifies an existing claim by bumping its value.
345     event TileAttackedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint attackTime); // Sent when a user successfully attacks a tile.    
346     event TileDefendedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint defendTime); // Sent when a user successfully defends a tile when attacked.    
347     event BlockValueMoved(uint16 sourceTileId, uint16 destTileId, address owner, uint movedBlockValue, uint postSourceValue, uint postDestValue, uint moveTime); // Sent when a user buys a tile from another user, by accepting a tile offer
348     event UserBattleValueUpdated(address userAddress, uint battleValue, bool isWithdraw);
349 
350     // Constructor.
351     constructor(address _bwData) public {
352         bwData = BWData(_bwData);
353         owner = msg.sender;
354     }
355 
356     // Can't send funds straight to this contract. Avoid people sending by mistake.
357     function () payable public {
358         revert();
359     }
360 
361     // OWNER-ONLY FUNCTIONS
362     function kill() public isOwner {
363         selfdestruct(owner);
364     }
365 
366     function setValidBwCaller(address _bw) public isOwner {
367         bw = _bw;
368     }
369     
370     function setValidBwMarketCaller(address _bwMarket) public isOwner {
371         bwMarket = _bwMarket;
372     }
373 
374 
375     // TILE-RELATED FUNCTIONS
376     // This function claims multiple previously unclaimed tiles in a single transaction.
377     // The value assigned to each tile is the msg.value divided by the number of tiles claimed.
378     // The msg.value is required to be an even multiple of the number of tiles claimed.
379     function storeInitialClaim(address _msgSender, uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) public isValidCaller {
380         uint tileCount = _claimedTileIds.length;
381         require(tileCount > 0);
382         require(_claimAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
383         require(_claimAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles claimed
384 
385         uint valuePerBlockInWei = _claimAmount / tileCount; // Due to requires above this is guaranteed to be an even number
386 
387         if (_useBattleValue) {
388             subUserBattleValue(_msgSender, _claimAmount, false);  
389         }
390 
391         addGlobalBlockValueBalance(_claimAmount);
392 
393         uint16 tileId;
394         bool isNewTile;
395         for (uint16 i = 0; i < tileCount; i++) {
396             tileId = _claimedTileIds[i];
397             isNewTile = bwData.isNewTile(tileId); // Is length 0 if first time purchased
398             require(isNewTile); // Can only claim previously unclaimed tiles.
399 
400             // Send claim event
401             emit TileClaimed(tileId, _msgSender, valuePerBlockInWei, block.timestamp);
402 
403             // Update contract state with new tile ownership.
404             bwData.storeClaim(tileId, _msgSender, valuePerBlockInWei);
405         }
406     }
407 
408     function fortifyClaims(address _msgSender, uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) public isValidCaller {
409         uint tileCount = _claimedTileIds.length;
410         require(tileCount > 0);
411 
412         uint balance = address(this).balance;
413         require(balance + _fortifyAmount > balance); // prevent overflow
414         require(_fortifyAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles fortified
415         uint addedValuePerTileInWei = _fortifyAmount / tileCount; // Due to requires above this is guaranteed to be an even number
416         require(_fortifyAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
417 
418         address claimer;
419         uint blockValue;
420         for (uint16 i = 0; i < tileCount; i++) {
421             (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_claimedTileIds[i]);
422             require(claimer != 0); // Can't do this on never-owned tiles
423             require(claimer == _msgSender); // Only current claimer can fortify claim
424 
425             if (_useBattleValue) {
426                 subUserBattleValue(_msgSender, addedValuePerTileInWei, false);
427             }
428             
429             fortifyClaim(_msgSender, _claimedTileIds[i], addedValuePerTileInWei);
430         }
431     }
432 
433     function fortifyClaim(address _msgSender, uint16 _claimedTileId, uint _fortifyAmount) private {
434         uint blockValue;
435         uint sellPrice;
436         (blockValue, sellPrice) = bwData.getCurrentBlockValueAndSellPriceForTile(_claimedTileId);
437         uint updatedBlockValue = blockValue + _fortifyAmount;
438         // Send fortify event
439         emit TileFortified(_claimedTileId, _msgSender, _fortifyAmount, updatedBlockValue, block.timestamp);
440         
441         // Update tile value. The tile has been fortified by bumping up its value.
442         bwData.updateTileBlockValue(_claimedTileId, updatedBlockValue);
443 
444         // Track addition to global block value
445         addGlobalBlockValueBalance(_fortifyAmount);
446     }
447 
448     // Return a pseudo random number between lower and upper bounds
449     // given the number of previous blocks it should hash.
450     // Random function copied from https://github.com/axiomzen/eth-random/blob/master/contracts/Random.sol.
451     // Changed sha3 to keccak256.
452     // Changed random range from uint64 to uint (=uint256).
453     function random(uint _upper) private returns (uint)  {
454         seed = uint(keccak256(keccak256(blockhash(block.number), seed), now));
455         return seed % _upper;
456     }
457 
458     // A user tries to claim a tile that's already owned by another user. A battle ensues.
459     // A random roll is done with % based on attacking vs defending amounts.
460     function attackTile(address _msgSender, uint16 _tileId, uint _attackAmount, bool _useBattleValue, bool _autoFortify) public isValidCaller {
461         require(_attackAmount >= 1 finney);         // Don't allow attacking with less than one base tile price.
462         require(_attackAmount % 1 finney == 0);
463 
464         address claimer;
465         uint blockValue;
466         (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_tileId);
467         
468         require(claimer != 0); // Can't do this on never-owned tiles
469         require(claimer != _msgSender); // Can't attack one's own tiles
470         require(claimer != owner); // Can't attack owner's tiles because it is used for raffle.
471 
472         // Calculate boosted amounts for attacker and defender
473         // The base attack amount is sent in the by the user.
474         // The base defend amount is the attacked tile's current blockValue.
475         uint attackBoost;
476         uint defendBoost;
477         (attackBoost, defendBoost) = bwData.calculateBattleBoost(_tileId, _msgSender, claimer);
478         uint totalAttackAmount = _attackAmount + attackBoost;
479         uint totalDefendAmount = blockValue + defendBoost;
480         require(totalAttackAmount >= _attackAmount); // prevent overflow
481         require(totalDefendAmount >= blockValue); // prevent overflow
482         require(totalAttackAmount + totalDefendAmount > totalAttackAmount && totalAttackAmount + totalDefendAmount > totalDefendAmount); // Prevent overflow
483 
484         // Verify that attack odds are within allowed range.
485         require(_attackAmount / 10 <= blockValue); // Disallow attacks with more than 1000% of defendAmount
486         require(_attackAmount >= blockValue / 10); // Disallow attacks with less than 10% of defendAmount
487 
488         // The battle considers boosts.
489         uint attackRoll = random(totalAttackAmount + totalDefendAmount); // This is where the excitement happens!
490         if (attackRoll > totalDefendAmount) {
491             // Send update event
492             emit TileAttackedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
493 
494             // Change block owner but keep same block value (attacker got battlevalue instead)
495             bwData.setClaimerForTile(_tileId, _msgSender);
496 
497             // Tile successfully attacked!
498             if (_useBattleValue) {
499                 if (_autoFortify) {
500                     // Fortify the won tile using battle value
501                     fortifyClaim(_msgSender, _tileId, _attackAmount);
502                     subUserBattleValue(_msgSender, _attackAmount, false);
503                 } else {
504                     // No reason to withdraw followed by deposit of same amount
505                 }
506             } else {
507                 if (_autoFortify) {
508                     // Fortify the won tile using attack amount
509                     fortifyClaim(_msgSender, _tileId, _attackAmount);
510                 } else {
511                     addUserBattleValue(_msgSender, _attackAmount); // Don't include boost here!
512                 }
513             }
514         } else {
515             // Tile successfully defended!
516             if (_useBattleValue) {
517                 subUserBattleValue(_msgSender, _attackAmount, false); // Don't include boost here!
518             }
519             addUserBattleValue(claimer, _attackAmount); // Don't include boost here!
520 
521             // Send update event
522             emit TileDefendedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
523 
524             // Update the timestamp for the defended block.
525             bwData.updateTileTimeStamp(_tileId);
526         }
527     }
528 
529     function moveBlockValue(address _msgSender, uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isValidCaller {
530         uint16 sourceTileId = BWUtility.toTileId(_xSource, _ySource);
531         uint16 destTileId = BWUtility.toTileId(_xDest, _yDest);
532 
533         address sourceTileClaimer;
534         address destTileClaimer;
535         uint sourceTileBlockValue;
536         uint destTileBlockValue;
537         (sourceTileClaimer, sourceTileBlockValue) = bwData.getTileClaimerAndBlockValue(sourceTileId);
538         (destTileClaimer, destTileBlockValue) = bwData.getTileClaimerAndBlockValue(destTileId);
539 
540         require(sourceTileClaimer == _msgSender);
541         require(destTileClaimer == _msgSender);
542         require(_moveAmount >= 1 finney); // Can't be less
543         require(_moveAmount % 1 finney == 0); // Move amount must be in multiples of 1 finney
544         // require(sourceTile.blockValue - _moveAmount >= BASE_TILE_PRICE_WEI); // Must always leave some at source
545         
546         require(sourceTileBlockValue - _moveAmount < sourceTileBlockValue); // Prevent overflow
547         require(destTileBlockValue + _moveAmount > destTileBlockValue); // Prevent overflow
548         require(BWUtility.isAdjacent(_xSource, _ySource, _xDest, _yDest));
549 
550         sourceTileBlockValue -= _moveAmount;
551         destTileBlockValue += _moveAmount;
552 
553         // If ALL block value was moved away from the source tile, we lose our claim to it. It becomes ownerless.
554         if (sourceTileBlockValue == 0) {
555             bwData.deleteTile(sourceTileId);
556         } else {
557             bwData.updateTileBlockValue(sourceTileId, sourceTileBlockValue);
558             bwData.deleteOffer(sourceTileId); // Offer invalid since block value has changed
559         }
560 
561         bwData.updateTileBlockValue(destTileId, destTileBlockValue);
562         bwData.deleteOffer(destTileId);   // Offer invalid since block value has changed
563         emit BlockValueMoved(sourceTileId, destTileId, _msgSender, _moveAmount, sourceTileBlockValue, destTileBlockValue, block.timestamp);        
564     }
565 
566 
567     // BATTLE VALUE FUNCTIONS
568     function withdrawBattleValue(address msgSender, uint _battleValueInWei) public isValidCaller returns (uint) {
569         require(bwData.hasUser(msgSender));
570         require(_battleValueInWei % 1 finney == 0); // Must be divisible by 1 finney
571         uint fee = _battleValueInWei / WITHDRAW_FEE; // Since we divide by 20 we can never create infinite fractions, so we'll always count in whole wei amounts.
572         require(_battleValueInWei - fee < _battleValueInWei); // prevent underflow
573 
574         uint amountToWithdraw = _battleValueInWei - fee;
575         uint feeBalance = bwData.getFeeBalance();
576         require(feeBalance + fee >= feeBalance); // prevent overflow
577         feeBalance += fee;
578         bwData.setFeeBalance(feeBalance);
579         subUserBattleValue(msgSender, _battleValueInWei, true);
580         return amountToWithdraw;
581     }
582 
583     function addUserBattleValue(address _userId, uint _amount) public isValidCaller {
584         uint userBattleValue = bwData.getUserBattleValue(_userId);
585         require(userBattleValue + _amount > userBattleValue); // prevent overflow
586         uint newBattleValue = userBattleValue + _amount;
587         bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
588         emit UserBattleValueUpdated(_userId, newBattleValue, false);
589     }
590     
591     function subUserBattleValue(address _userId, uint _amount, bool _isWithdraw) public isValidCaller {
592         uint userBattleValue = bwData.getUserBattleValue(_userId);
593         require(_amount <= userBattleValue); // Must be less than user's battle value - also implicitly checks that underflow isn't possible
594         uint newBattleValue = userBattleValue - _amount;
595         bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
596         emit UserBattleValueUpdated(_userId, newBattleValue, _isWithdraw);
597     }
598 
599     function addGlobalBlockValueBalance(uint _amount) public isValidCaller {
600         // Track addition to global block value.
601         uint blockValueBalance = bwData.getBlockValueBalance();
602         require(blockValueBalance + _amount > blockValueBalance); // Prevent overflow
603         bwData.setBlockValueBalance(blockValueBalance + _amount);
604     }
605 
606     // Allow us to transfer out airdropped tokens if we ever receive any
607     function transferTokens(address _tokenAddress, address _recipient) public isOwner {
608         ERC20I token = ERC20I(_tokenAddress);
609         require(token.transfer(_recipient, token.balanceOf(this)));
610     }
611 }
612 
613 /**
614  * Copyright 2018 Block Wars Team
615  *
616  */
617 
618 contract BW { 
619     address public owner;
620     BWService private bwService;
621     BWData private bwData;
622     bool public paused = false;
623     
624     modifier isOwner {
625         if (msg.sender != owner) {
626             revert();
627         }
628         _;
629     }
630 
631     // Checks if entire game (except battle value withdraw) is paused or not.
632     modifier isNotPaused {
633         if (paused) {
634             revert();
635         }
636         _;
637     }
638 
639     // Only allow wallets to call this function, not contracts.
640     modifier isNotContractCaller {
641         require(msg.sender == tx.origin);
642         _;
643     }
644 
645     // All contract event types.
646     event UserCreated(address userAddress, bytes32 name, bytes imageUrl, bytes32 tag, bytes32 homeUrl, uint creationTime, address invitedBy);
647     event UserCensored(address userAddress, bool isCensored);
648     event TransferTileFromOwner(uint16 tileId, address seller, address buyer, uint acceptTime); // Sent when a user buys a tile from another user, by accepting a tile offer
649     event UserUpdated(address userAddress, bytes32 name, bytes imageUrl, bytes32 tag, bytes32 homeUrl, uint updateTime);    
650 
651     // BASIC CONTRACT FUNCTIONS
652     // Constructor.
653     constructor(address _bwService, address _bwData) public {
654         bwService = BWService(_bwService);
655         bwData = BWData(_bwData);
656         owner = msg.sender;
657     }
658 
659     // Can't send funds straight to this contract. Avoid people sending by mistake.
660     function () payable public {
661         revert();
662     }
663 
664     // Allow a new user to claim one or more previously unclaimed tiles by paying Ether.
665     function claimTilesForNewUser(bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl, uint16[] _claimedTileIds, address _invitedBy) payable public isNotPaused isNotContractCaller {
666         bwData.addUser(msg.sender);
667         emit UserCreated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp, _invitedBy);
668         bwService.storeInitialClaim(msg.sender, _claimedTileIds, msg.value, false);
669     }
670 
671     // Allow an existing user to claim one or more previously unclaimed tiles by paying Ether.
672     function claimTilesForExistingUser(uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) payable public isNotPaused isNotContractCaller {
673         bwData.verifyAmount(msg.sender, msg.value, _claimAmount, _useBattleValue);
674         bwService.storeInitialClaim(msg.sender, _claimedTileIds, _claimAmount, _useBattleValue);
675     }
676 
677     // Allow users to change name, image URL, tag and home URL. Not censored status or battle value though.
678     function updateUser(bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl) public isNotPaused isNotContractCaller {
679         require(bwData.hasUser(msg.sender));
680         // All the updated values are stored in events only so there's no state to update on the contract here.
681         emit UserUpdated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp);
682     }
683     
684     // This function fortifies multiple previously claimed tiles in a single transaction.
685     // The value assigned to each tile is the msg.value divided by the number of tiles fortified.
686     // The msg.value is required to be an even multiple of the number of tiles fortified.
687     // Only tiles owned by msg.sender can be fortified.
688     function fortifyClaims(uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) payable public isNotPaused isNotContractCaller {
689         bwData.verifyAmount(msg.sender, msg.value, _fortifyAmount, _useBattleValue);
690         bwService.fortifyClaims(msg.sender, _claimedTileIds, _fortifyAmount, _useBattleValue);
691     }
692 
693     // A new user attacks a tile claimed by someone else, trying to make it theirs through battle.
694     function attackTileForNewUser(uint16 _tileId, bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl, address _invitedBy) payable public isNotPaused isNotContractCaller {
695         bwData.addUser(msg.sender);
696         emit UserCreated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp, _invitedBy);
697         bwService.attackTile(msg.sender, _tileId, msg.value, false, false);
698     }
699 
700         // An existing user attacks a tile claimed by someone else, trying to make it theirs through battle.
701     function attackTileForExistingUser(uint16 _tileId, uint _attackAmount, bool _useBattleValue, bool _autoFortify) payable public isNotPaused isNotContractCaller {
702         bwData.verifyAmount(msg.sender, msg.value, _attackAmount, _useBattleValue);
703         bwService.attackTile(msg.sender, _tileId, _attackAmount, _useBattleValue, _autoFortify);
704     }
705     
706     // Move "army" = block value from one block to an adjacent block. Moving ALL value equates giving up ownership of the source tile.
707     function moveBlockValue(uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isNotPaused isNotContractCaller {
708         bwService.moveBlockValue(msg.sender, _xSource, _ySource, _xDest, _yDest, _moveAmount);
709     }
710 
711     // Allow users to withdraw battle value in Ether.
712     function withdrawBattleValue(uint _battleValueInWei) public isNotContractCaller {
713         uint amountToWithdraw = bwService.withdrawBattleValue(msg.sender, _battleValueInWei);
714         msg.sender.transfer(amountToWithdraw);
715     }
716 
717     // -------- OWNER-ONLY FUNCTIONS ----------
718 
719 
720     // Only used by owner for raffle. Owner need name, address and picture from user.
721     // These users can then be given tiles by owner using transferTileFromOwner.
722     function createNewUser(bytes32 _name, bytes _imageUrl, address _user) public isOwner {
723         bwData.addUser(_user);
724         emit UserCreated(msg.sender, _name, _imageUrl, 0x0, 0x0, block.timestamp, 0x0);
725     }
726 
727     // Allow updating censored status. Owner only. In case someone uploads offensive content.
728     // The contract owners reserve the right to apply censorship. This will mean that the
729     // name, tag or URL images might not be displayed for a censored user.
730     function censorUser(address _userAddress, bool _censored) public isOwner {
731         bwData.censorUser(_userAddress, _censored);
732         emit UserCensored(_userAddress, _censored);
733     }
734 
735     // Pause the entire game, but let users keep withdrawing battle value
736     function setPaused(bool _paused) public isOwner {
737         paused = _paused;
738     }
739 
740     function kill() public isOwner {
741         selfdestruct(owner);
742     }
743     
744     function withdrawValue(bool _isFee) public isOwner {
745         uint balance = address(this).balance;
746         uint amountToWithdraw;
747         
748         if (_isFee) {
749             amountToWithdraw = bwData.getFeeBalance();
750 
751             if (balance < amountToWithdraw) { // Should never happen, but paranoia
752                 amountToWithdraw = balance;
753             }
754             bwData.setFeeBalance(0);
755         } else {
756             amountToWithdraw = bwData.getBlockValueBalance();
757 
758             if (balance < amountToWithdraw) { // Should never happen, but paranoia
759                 amountToWithdraw = balance;
760             }
761             bwData.setBlockValueBalance(0);
762         }
763 
764         owner.transfer(amountToWithdraw);
765     }
766 
767     function depositBattleValue(address _user) payable public isOwner {
768         require(bwData.hasUser(_user));
769         require(msg.value % 1 finney == 0); // Must be divisible by 1 finney
770         bwService.addUserBattleValue(_user, msg.value);
771     }
772 
773     // The owner can transfer ownership of own tiles to other users, as prizes in competitions.
774     function transferTileFromOwner(uint16 _tileId, address _newOwner) public payable isOwner {
775         address claimer = bwData.getCurrentClaimerForTile(_tileId);
776         require(claimer == owner);
777         require(bwData.hasUser(_newOwner));
778         require(msg.value % 1 finney == 0); // Must be divisible by 1 finney
779         uint balance = address(this).balance;
780         require(balance + msg.value >= balance); // prevent overflow
781         bwData.setClaimerForTile(_tileId, _newOwner);
782         bwService.addUserBattleValue(_newOwner, msg.value);
783         
784         emit TransferTileFromOwner(_tileId, claimer, msg.sender, block.timestamp);
785     }
786 
787     // Allow us to transfer out airdropped tokens if we ever receive any
788     function transferTokens(address _tokenAddress, address _recipient) public isOwner {
789         ERC20I token = ERC20I(_tokenAddress);
790         require(token.transfer(_recipient, token.balanceOf(this)));
791     }
792 }