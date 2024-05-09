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
316     
317     interface ERC20I {
318         function transfer(address _recipient, uint256 _amount) external returns (bool);
319         function balanceOf(address _holder) external view returns (uint256);
320     }
321     
322     
323     contract BWService {
324         address private owner;
325         address private bw;
326         address private bwMarket;
327         BWData private bwData;
328         uint private seed = 42;
329         uint private WITHDRAW_FEE = 20; //1/20 = 5%
330         
331         modifier isOwner {
332             if (msg.sender != owner) {
333                 revert();
334             }
335             _;
336         }  
337     
338         modifier isValidCaller {
339             if (msg.sender != bw && msg.sender != bwMarket) {
340                 revert();
341             }
342             _;
343         }
344     
345         event TileClaimed(uint16 tileId, address newClaimer, uint priceInWei, uint creationTime);
346         event TileFortified(uint16 tileId, address claimer, uint addedValueInWei, uint priceInWei, uint fortifyTime); // Sent when a user fortifies an existing claim by bumping its value.
347         event TileAttackedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint attackTime); // Sent when a user successfully attacks a tile.    
348         event TileDefendedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint defendTime); // Sent when a user successfully defends a tile when attacked.    
349         event BlockValueMoved(uint16 sourceTileId, uint16 destTileId, address owner, uint movedBlockValue, uint postSourceValue, uint postDestValue, uint moveTime); // Sent when a user buys a tile from another user, by accepting a tile offer
350         event UserBattleValueUpdated(address userAddress, uint battleValue, bool isWithdraw);
351     
352         // Constructor.
353         constructor(address _bwData) public {
354             bwData = BWData(_bwData);
355             owner = msg.sender;
356         }
357     
358         // Can't send funds straight to this contract. Avoid people sending by mistake.
359         function () payable public {
360             revert();
361         }
362     
363         // OWNER-ONLY FUNCTIONS
364         function kill() public isOwner {
365             selfdestruct(owner);
366         }
367     
368         function setValidBwCaller(address _bw) public isOwner {
369             bw = _bw;
370         }
371         
372         function setValidBwMarketCaller(address _bwMarket) public isOwner {
373             bwMarket = _bwMarket;
374         }
375     
376     
377         // TILE-RELATED FUNCTIONS
378         // This function claims multiple previously unclaimed tiles in a single transaction.
379         // The value assigned to each tile is the msg.value divided by the number of tiles claimed.
380         // The msg.value is required to be an even multiple of the number of tiles claimed.
381         function storeInitialClaim(address _msgSender, uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) public isValidCaller {
382             uint tileCount = _claimedTileIds.length;
383             require(tileCount > 0);
384             require(_claimAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
385             require(_claimAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles claimed
386     
387             uint valuePerBlockInWei = _claimAmount / tileCount; // Due to requires above this is guaranteed to be an even number
388     
389             if (_useBattleValue) {
390                 subUserBattleValue(_msgSender, _claimAmount, false);  
391             }
392     
393             addGlobalBlockValueBalance(_claimAmount);
394     
395             uint16 tileId;
396             bool isNewTile;
397             for (uint16 i = 0; i < tileCount; i++) {
398                 tileId = _claimedTileIds[i];
399                 isNewTile = bwData.isNewTile(tileId); // Is length 0 if first time purchased
400                 require(isNewTile); // Can only claim previously unclaimed tiles.
401     
402                 // Send claim event
403                 emit TileClaimed(tileId, _msgSender, valuePerBlockInWei, block.timestamp);
404     
405                 // Update contract state with new tile ownership.
406                 bwData.storeClaim(tileId, _msgSender, valuePerBlockInWei);
407             }
408         }
409     
410         function fortifyClaims(address _msgSender, uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) public isValidCaller {
411             uint tileCount = _claimedTileIds.length;
412             require(tileCount > 0);
413     
414             uint balance = address(this).balance;
415             require(balance + _fortifyAmount > balance); // prevent overflow
416             require(_fortifyAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles fortified
417             uint addedValuePerTileInWei = _fortifyAmount / tileCount; // Due to requires above this is guaranteed to be an even number
418             require(_fortifyAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
419     
420             address claimer;
421             uint blockValue;
422             for (uint16 i = 0; i < tileCount; i++) {
423                 (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_claimedTileIds[i]);
424                 require(claimer != 0); // Can't do this on never-owned tiles
425                 require(claimer == _msgSender); // Only current claimer can fortify claim
426     
427                 if (_useBattleValue) {
428                     subUserBattleValue(_msgSender, addedValuePerTileInWei, false);
429                 }
430                 
431                 fortifyClaim(_msgSender, _claimedTileIds[i], addedValuePerTileInWei);
432             }
433         }
434     
435         function fortifyClaim(address _msgSender, uint16 _claimedTileId, uint _fortifyAmount) private {
436             uint blockValue;
437             uint sellPrice;
438             (blockValue, sellPrice) = bwData.getCurrentBlockValueAndSellPriceForTile(_claimedTileId);
439             uint updatedBlockValue = blockValue + _fortifyAmount;
440             // Send fortify event
441             emit TileFortified(_claimedTileId, _msgSender, _fortifyAmount, updatedBlockValue, block.timestamp);
442             
443             // Update tile value. The tile has been fortified by bumping up its value.
444             bwData.updateTileBlockValue(_claimedTileId, updatedBlockValue);
445     
446             // Track addition to global block value
447             addGlobalBlockValueBalance(_fortifyAmount);
448         }
449     
450         // Return a pseudo random number between lower and upper bounds
451         // given the number of previous blocks it should hash.
452         // Random function copied from https://github.com/axiomzen/eth-random/blob/master/contracts/Random.sol.
453         // Changed sha3 to keccak256.
454         // Changed random range from uint64 to uint (=uint256).
455         function random(uint _upper) private returns (uint)  {
456             seed = uint(keccak256(keccak256(blockhash(block.number), seed), now));
457             return seed % _upper;
458         }
459     
460         // A user tries to claim a tile that's already owned by another user. A battle ensues.
461         // A random roll is done with % based on attacking vs defending amounts.
462         function attackTile(address _msgSender, uint16 _tileId, uint _attackAmount, bool _useBattleValue, bool _autoFortify) public isValidCaller {
463             require(_attackAmount >= 1 finney);         // Don't allow attacking with less than one base tile price.
464             require(_attackAmount % 1 finney == 0);
465     
466             address claimer;
467             uint blockValue;
468             (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_tileId);
469             
470             require(claimer != 0); // Can't do this on never-owned tiles
471             require(claimer != _msgSender); // Can't attack one's own tiles
472             require(claimer != owner); // Can't attack owner's tiles because it is used for raffle.
473     
474             // Calculate boosted amounts for attacker and defender
475             // The base attack amount is sent in the by the user.
476             // The base defend amount is the attacked tile's current blockValue.
477             uint attackBoost;
478             uint defendBoost;
479             (attackBoost, defendBoost) = bwData.calculateBattleBoost(_tileId, _msgSender, claimer);
480             uint totalAttackAmount = _attackAmount + attackBoost;
481             uint totalDefendAmount = blockValue + defendBoost;
482             require(totalAttackAmount >= _attackAmount); // prevent overflow
483             require(totalDefendAmount >= blockValue); // prevent overflow
484             require(totalAttackAmount + totalDefendAmount > totalAttackAmount && totalAttackAmount + totalDefendAmount > totalDefendAmount); // Prevent overflow
485     
486             // Verify that attack odds are within allowed range.
487             require(totalAttackAmount / 10 <= blockValue); // Disallow attacks with more than 1000% of defendAmount
488             require(totalAttackAmount >= blockValue / 10); // Disallow attacks with less than 10% of defendAmount
489     
490             // The battle considers boosts.
491             uint attackRoll = random(totalAttackAmount + totalDefendAmount); // This is where the excitement happens!
492             if (attackRoll > totalDefendAmount) {
493                 // Send update event
494                 emit TileAttackedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
495     
496                 // Change block owner but keep same block value (attacker got battlevalue instead)
497                 bwData.setClaimerForTile(_tileId, _msgSender);
498     
499                 // Tile successfully attacked!
500                 if (_useBattleValue) {
501                     if (_autoFortify) {
502                         // Fortify the won tile using battle value
503                         fortifyClaim(_msgSender, _tileId, _attackAmount);
504                         subUserBattleValue(_msgSender, _attackAmount, false);
505                     } else {
506                         // No reason to withdraw followed by deposit of same amount
507                     }
508                 } else {
509                     if (_autoFortify) {
510                         // Fortify the won tile using attack amount
511                         fortifyClaim(_msgSender, _tileId, _attackAmount);
512                     } else {
513                         addUserBattleValue(_msgSender, _attackAmount); // Don't include boost here!
514                     }
515                 }
516             } else {
517                 // Tile successfully defended!
518                 if (_useBattleValue) {
519                     subUserBattleValue(_msgSender, _attackAmount, false); // Don't include boost here!
520                 }
521                 addUserBattleValue(claimer, _attackAmount); // Don't include boost here!
522     
523                 // Send update event
524                 emit TileDefendedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
525     
526                 // Update the timestamp for the defended block.
527                 bwData.updateTileTimeStamp(_tileId);
528             }
529         }
530     
531         function moveBlockValue(address _msgSender, uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isValidCaller {
532             uint16 sourceTileId = BWUtility.toTileId(_xSource, _ySource);
533             uint16 destTileId = BWUtility.toTileId(_xDest, _yDest);
534     
535             address sourceTileClaimer;
536             address destTileClaimer;
537             uint sourceTileBlockValue;
538             uint destTileBlockValue;
539             (sourceTileClaimer, sourceTileBlockValue) = bwData.getTileClaimerAndBlockValue(sourceTileId);
540             (destTileClaimer, destTileBlockValue) = bwData.getTileClaimerAndBlockValue(destTileId);
541     
542             require(sourceTileClaimer == _msgSender);
543             require(destTileClaimer == _msgSender);
544             require(_moveAmount >= 1 finney); // Can't be less
545             require(_moveAmount % 1 finney == 0); // Move amount must be in multiples of 1 finney
546             // require(sourceTile.blockValue - _moveAmount >= BASE_TILE_PRICE_WEI); // Must always leave some at source
547             
548             require(sourceTileBlockValue - _moveAmount < sourceTileBlockValue); // Prevent overflow
549             require(destTileBlockValue + _moveAmount > destTileBlockValue); // Prevent overflow
550             require(BWUtility.isAdjacent(_xSource, _ySource, _xDest, _yDest));
551     
552             sourceTileBlockValue -= _moveAmount;
553             destTileBlockValue += _moveAmount;
554     
555             // If ALL block value was moved away from the source tile, we lose our claim to it. It becomes ownerless.
556             if (sourceTileBlockValue == 0) {
557                 bwData.deleteTile(sourceTileId);
558             } else {
559                 bwData.updateTileBlockValue(sourceTileId, sourceTileBlockValue);
560                 bwData.deleteOffer(sourceTileId); // Offer invalid since block value has changed
561             }
562     
563             bwData.updateTileBlockValue(destTileId, destTileBlockValue);
564             bwData.deleteOffer(destTileId);   // Offer invalid since block value has changed
565             emit BlockValueMoved(sourceTileId, destTileId, _msgSender, _moveAmount, sourceTileBlockValue, destTileBlockValue, block.timestamp);        
566         }
567     
568     
569         // BATTLE VALUE FUNCTIONS
570         function withdrawBattleValue(address msgSender, uint _battleValueInWei) public isValidCaller returns (uint) {
571             require(bwData.hasUser(msgSender));
572             require(_battleValueInWei % 1 finney == 0); // Must be divisible by 1 finney
573             uint fee = _battleValueInWei / WITHDRAW_FEE; // Since we divide by 20 we can never create infinite fractions, so we'll always count in whole wei amounts.
574             require(_battleValueInWei - fee < _battleValueInWei); // prevent underflow
575     
576             uint amountToWithdraw = _battleValueInWei - fee;
577             uint feeBalance = bwData.getFeeBalance();
578             require(feeBalance + fee >= feeBalance); // prevent overflow
579             feeBalance += fee;
580             bwData.setFeeBalance(feeBalance);
581             subUserBattleValue(msgSender, _battleValueInWei, true);
582             return amountToWithdraw;
583         }
584     
585         function addUserBattleValue(address _userId, uint _amount) public isValidCaller {
586             uint userBattleValue = bwData.getUserBattleValue(_userId);
587             require(userBattleValue + _amount > userBattleValue); // prevent overflow
588             uint newBattleValue = userBattleValue + _amount;
589             bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
590             emit UserBattleValueUpdated(_userId, newBattleValue, false);
591         }
592         
593         function subUserBattleValue(address _userId, uint _amount, bool _isWithdraw) public isValidCaller {
594             uint userBattleValue = bwData.getUserBattleValue(_userId);
595             require(_amount <= userBattleValue); // Must be less than user's battle value - also implicitly checks that underflow isn't possible
596             uint newBattleValue = userBattleValue - _amount;
597             bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
598             emit UserBattleValueUpdated(_userId, newBattleValue, _isWithdraw);
599         }
600     
601         function addGlobalBlockValueBalance(uint _amount) public isValidCaller {
602             // Track addition to global block value.
603             uint blockValueBalance = bwData.getBlockValueBalance();
604             require(blockValueBalance + _amount > blockValueBalance); // Prevent overflow
605             bwData.setBlockValueBalance(blockValueBalance + _amount);
606         }
607     
608         // Allow us to transfer out airdropped tokens if we ever receive any
609         function transferTokens(address _tokenAddress, address _recipient) public isOwner {
610             ERC20I token = ERC20I(_tokenAddress);
611             require(token.transfer(_recipient, token.balanceOf(this)));
612         }
613     }
614 
615 
616 contract BWMarket {
617     address private owner;
618     BWService private bwService;
619     BWData private bwData;
620     bool private allowMarketplace = true;
621     bool public paused = false;
622     
623     modifier isOwner {
624         if (msg.sender != owner) {
625             revert();
626         }
627         _;
628     }
629     
630     modifier isMarketplaceEnabled {
631         if (!allowMarketplace) {
632             revert();
633         }
634         _;
635     }
636 
637     // Only allow wallets to call this function, not contracts.
638     modifier isNotContractCaller {
639         require(msg.sender == tx.origin);
640         _;
641     }
642     
643     event TileOfferCreated(uint16 tileId, address seller, uint priceInWei, uint creationTime); // Sent when user offers to sell a tile
644     event TileOfferUpdated(uint16 tileId, address seller, uint priceInWei, uint updateTime); // Sent when user updates the price of an offer to sell a tile
645     event TileOfferCancelled(uint16 tileId, uint cancelTime, address seller); // Sent when a seller withdraws an offer
646     event TileOfferAccepted(uint16 tileId, address seller, address buyer, uint priceInWei, uint acceptTime); // Sent when a user buys a tile from another user, by accepting a tile offer
647 
648     constructor(address _bwService, address _bwData) public {
649         bwService = BWService(_bwService);
650         bwData = BWData(_bwData);
651         owner = msg.sender;
652     }
653 
654     // Can't send funds straight to this contract. Avoid people sending by mistake.
655     function () payable public {
656         revert();
657     }
658 
659     function kill() public isOwner {
660         selfdestruct(owner);
661     }
662 
663     function setAllowMarketplace(bool _allowMarketplace) public isOwner {
664         allowMarketplace = _allowMarketplace;
665     }
666     
667     // Lets a tile owner offer a tile for sale.
668     function createOffer(uint16 _tileId, uint _offerInWei) public isMarketplaceEnabled isNotContractCaller {
669         require(_offerInWei % 1 finney == 0);           //Don't allow decimals
670         require(_offerInWei >= 1 finney);    //Check for > 1 finney
671         
672         address claimer;
673         uint blockValue;
674         uint creationTime;
675         uint sellPrice;
676         (claimer, blockValue, creationTime, sellPrice) = bwData.getTile(_tileId);
677         
678         require(creationTime > 0); // Can't do this on never-owned tiles
679         require(claimer == msg.sender); // Only current claimer can offer to sell tile
680 
681         bwData.setSellPrice(_tileId, _offerInWei);
682         // Create or update offer
683         if (sellPrice == 0) {   //TODO : Use on event? Looks similair
684             emit TileOfferCreated(_tileId, msg.sender, _offerInWei, block.timestamp);
685         } else {
686             emit TileOfferUpdated(_tileId, msg.sender, _offerInWei, block.timestamp);
687         }
688     }
689 
690     function acceptOffer(uint16 _tileId, uint _acceptedBlockValue) payable public isMarketplaceEnabled isNotContractCaller {
691         uint balance = address(this).balance;
692         require(balance + msg.value > balance);    // prevent overflow
693         
694         address claimer;
695         uint blockValue;
696         uint creationTime;
697         uint sellPrice;
698         (claimer, blockValue, creationTime, sellPrice) = bwData.getTile(_tileId);
699         // We don't check if buyer is not the seller to save gas
700         require(creationTime > 0); // Can't do this on never-owned tiles
701         require(sellPrice != 0); // Verify that there is an offer for this tile
702         require(sellPrice == msg.value); // Must pay the price of the offer
703 
704         // Prevent bait-and-switch sales (moving block value around in same mined Ethereum block as accept happens),
705         // this way we pass in the block value the buyer believes he's going to get and make sure it's actually still set to that value
706         require(blockValue == _acceptedBlockValue);
707 
708         // This is where we actually send ether AWAY from the contract. Will require careful testing.
709         require(balance >= sellPrice); // Ensure contract has funds to send to users.
710 
711         // Send offer accepted event
712         emit TileOfferAccepted(_tileId, claimer, msg.sender, sellPrice, block.timestamp); // Sent when a user buys a tile from another user, by accepting a tile offer
713 
714         // Save some values required for transfering funds
715         uint amountToSend = sellPrice;
716         address seller = claimer;
717 
718         // Update storage
719         bwData.deleteOffer(_tileId); // Must zero this before transfer() is called to avoid re-entrancy attacks.
720         bwData.setClaimerForTile(_tileId, msg.sender); // Update contract state with new tile ownership. Note that this changes the tile.claimer variable!
721 
722         // Send funds AFTER updating storage and AFTER zeroing sellPrice.
723         seller.transfer(amountToSend);
724     }
725 
726     function cancelOffer(uint16 _tileId) public isMarketplaceEnabled isNotContractCaller {
727         address claimer = bwData.getCurrentClaimerForTile(_tileId);
728         require(claimer == msg.sender); // Only the creator of an offer can withdraw it (this also catches the case where there is no offer)
729         bwData.deleteOffer(_tileId);
730         emit TileOfferCancelled(_tileId, now, msg.sender);    //now for future use in client.
731     }
732 
733     // Allow us to transfer out airdropped tokens if we ever receive any
734     function transferTokens(address _tokenAddress, address _recipient) public isOwner {
735         ERC20I token = ERC20I(_tokenAddress);
736         require(token.transfer(_recipient, token.balanceOf(this)));
737     }
738 }