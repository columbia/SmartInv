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
47 
48 interface ERC20I {
49     function transfer(address _recipient, uint256 _amount) external returns (bool);
50     function balanceOf(address _holder) external view returns (uint256);
51 }
52 
53 
54 contract BWService {
55     address private owner;
56     address private bw;
57     address private bwMarket;
58     BWData private bwData;
59     uint private seed = 42;
60     uint private WITHDRAW_FEE = 20; //1/20 = 5%
61     
62     modifier isOwner {
63         if (msg.sender != owner) {
64             revert();
65         }
66         _;
67     }  
68 
69     modifier isValidCaller {
70         if (msg.sender != bw && msg.sender != bwMarket) {
71             revert();
72         }
73         _;
74     }
75 
76     event TileClaimed(uint16 tileId, address newClaimer, uint priceInWei, uint creationTime);
77     event TileFortified(uint16 tileId, address claimer, uint addedValueInWei, uint priceInWei, uint fortifyTime); // Sent when a user fortifies an existing claim by bumping its value.
78     event TileAttackedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint attackTime); // Sent when a user successfully attacks a tile.    
79     event TileDefendedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint defendTime); // Sent when a user successfully defends a tile when attacked.    
80     event BlockValueMoved(uint16 sourceTileId, uint16 destTileId, address owner, uint movedBlockValue, uint postSourceValue, uint postDestValue, uint moveTime); // Sent when a user buys a tile from another user, by accepting a tile offer
81     event UserBattleValueUpdated(address userAddress, uint battleValue, bool isWithdraw);
82 
83     // Constructor.
84     constructor(address _bwData) public {
85         bwData = BWData(_bwData);
86         owner = msg.sender;
87     }
88 
89     // Can't send funds straight to this contract. Avoid people sending by mistake.
90     function () payable public {
91         revert();
92     }
93 
94     // OWNER-ONLY FUNCTIONS
95     function kill() public isOwner {
96         selfdestruct(owner);
97     }
98 
99     function setValidBwCaller(address _bw) public isOwner {
100         bw = _bw;
101     }
102     
103     function setValidBwMarketCaller(address _bwMarket) public isOwner {
104         bwMarket = _bwMarket;
105     }
106 
107 
108     // TILE-RELATED FUNCTIONS
109     // This function claims multiple previously unclaimed tiles in a single transaction.
110     // The value assigned to each tile is the msg.value divided by the number of tiles claimed.
111     // The msg.value is required to be an even multiple of the number of tiles claimed.
112     function storeInitialClaim(address _msgSender, uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) public isValidCaller {
113         uint tileCount = _claimedTileIds.length;
114         require(tileCount > 0);
115         require(_claimAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
116         require(_claimAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles claimed
117 
118         uint valuePerBlockInWei = _claimAmount / tileCount; // Due to requires above this is guaranteed to be an even number
119 
120         if (_useBattleValue) {
121             subUserBattleValue(_msgSender, _claimAmount, false);  
122         }
123 
124         addGlobalBlockValueBalance(_claimAmount);
125 
126         uint16 tileId;
127         bool isNewTile;
128         for (uint16 i = 0; i < tileCount; i++) {
129             tileId = _claimedTileIds[i];
130             isNewTile = bwData.isNewTile(tileId); // Is length 0 if first time purchased
131             require(isNewTile); // Can only claim previously unclaimed tiles.
132 
133             // Send claim event
134             emit TileClaimed(tileId, _msgSender, valuePerBlockInWei, block.timestamp);
135 
136             // Update contract state with new tile ownership.
137             bwData.storeClaim(tileId, _msgSender, valuePerBlockInWei);
138         }
139     }
140 
141     function fortifyClaims(address _msgSender, uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) public isValidCaller {
142         uint tileCount = _claimedTileIds.length;
143         require(tileCount > 0);
144 
145         uint balance = address(this).balance;
146         require(balance + _fortifyAmount > balance); // prevent overflow
147         require(_fortifyAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles fortified
148         uint addedValuePerTileInWei = _fortifyAmount / tileCount; // Due to requires above this is guaranteed to be an even number
149         require(_fortifyAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
150 
151         address claimer;
152         uint blockValue;
153         for (uint16 i = 0; i < tileCount; i++) {
154             (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_claimedTileIds[i]);
155             require(claimer != 0); // Can't do this on never-owned tiles
156             require(claimer == _msgSender); // Only current claimer can fortify claim
157 
158             if (_useBattleValue) {
159                 subUserBattleValue(_msgSender, addedValuePerTileInWei, false);
160             }
161             
162             fortifyClaim(_msgSender, _claimedTileIds[i], addedValuePerTileInWei);
163         }
164     }
165 
166     function fortifyClaim(address _msgSender, uint16 _claimedTileId, uint _fortifyAmount) private {
167         uint blockValue;
168         uint sellPrice;
169         (blockValue, sellPrice) = bwData.getCurrentBlockValueAndSellPriceForTile(_claimedTileId);
170         uint updatedBlockValue = blockValue + _fortifyAmount;
171         // Send fortify event
172         emit TileFortified(_claimedTileId, _msgSender, _fortifyAmount, updatedBlockValue, block.timestamp);
173         
174         // Update tile value. The tile has been fortified by bumping up its value.
175         bwData.updateTileBlockValue(_claimedTileId, updatedBlockValue);
176 
177         // Track addition to global block value
178         addGlobalBlockValueBalance(_fortifyAmount);
179     }
180 
181     // Return a pseudo random number between lower and upper bounds
182     // given the number of previous blocks it should hash.
183     // Random function copied from https://github.com/axiomzen/eth-random/blob/master/contracts/Random.sol.
184     // Changed sha3 to keccak256.
185     // Changed random range from uint64 to uint (=uint256).
186     function random(uint _upper) private returns (uint)  {
187         seed = uint(keccak256(keccak256(blockhash(block.number), seed), now));
188         return seed % _upper;
189     }
190 
191     // A user tries to claim a tile that's already owned by another user. A battle ensues.
192     // A random roll is done with % based on attacking vs defending amounts.
193     function attackTile(address _msgSender, uint16 _tileId, uint _attackAmount, bool _useBattleValue, bool _autoFortify) public isValidCaller {
194         require(_attackAmount >= 1 finney);         // Don't allow attacking with less than one base tile price.
195         require(_attackAmount % 1 finney == 0);
196 
197         address claimer;
198         uint blockValue;
199         (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_tileId);
200         
201         require(claimer != 0); // Can't do this on never-owned tiles
202         require(claimer != _msgSender); // Can't attack one's own tiles
203         require(claimer != owner); // Can't attack owner's tiles because it is used for raffle.
204 
205         // Calculate boosted amounts for attacker and defender
206         // The base attack amount is sent in the by the user.
207         // The base defend amount is the attacked tile's current blockValue.
208         uint attackBoost;
209         uint defendBoost;
210         (attackBoost, defendBoost) = bwData.calculateBattleBoost(_tileId, _msgSender, claimer);
211         uint totalAttackAmount = _attackAmount + attackBoost;
212         uint totalDefendAmount = blockValue + defendBoost;
213         require(totalAttackAmount >= _attackAmount); // prevent overflow
214         require(totalDefendAmount >= blockValue); // prevent overflow
215         require(totalAttackAmount + totalDefendAmount > totalAttackAmount && totalAttackAmount + totalDefendAmount > totalDefendAmount); // Prevent overflow
216 
217         // Verify that attack odds are within allowed range.
218         require(totalAttackAmount / 10 <= blockValue); // Disallow attacks with more than 1000% of defendAmount
219         require(totalAttackAmount >= blockValue / 10); // Disallow attacks with less than 10% of defendAmount
220 
221         // The battle considers boosts.
222         uint attackRoll = random(totalAttackAmount + totalDefendAmount); // This is where the excitement happens!
223         if (attackRoll > totalDefendAmount) {
224             // Send update event
225             emit TileAttackedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
226 
227             // Change block owner but keep same block value (attacker got battlevalue instead)
228             bwData.setClaimerForTile(_tileId, _msgSender);
229 
230             // Tile successfully attacked!
231             if (_useBattleValue) {
232                 if (_autoFortify) {
233                     // Fortify the won tile using battle value
234                     fortifyClaim(_msgSender, _tileId, _attackAmount);
235                     subUserBattleValue(_msgSender, _attackAmount, false);
236                 } else {
237                     // No reason to withdraw followed by deposit of same amount
238                 }
239             } else {
240                 if (_autoFortify) {
241                     // Fortify the won tile using attack amount
242                     fortifyClaim(_msgSender, _tileId, _attackAmount);
243                 } else {
244                     addUserBattleValue(_msgSender, _attackAmount); // Don't include boost here!
245                 }
246             }
247         } else {
248             // Tile successfully defended!
249             if (_useBattleValue) {
250                 subUserBattleValue(_msgSender, _attackAmount, false); // Don't include boost here!
251             }
252             addUserBattleValue(claimer, _attackAmount); // Don't include boost here!
253 
254             // Send update event
255             emit TileDefendedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
256 
257             // Update the timestamp for the defended block.
258             bwData.updateTileTimeStamp(_tileId);
259         }
260     }
261 
262     function moveBlockValue(address _msgSender, uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isValidCaller {
263         uint16 sourceTileId = BWUtility.toTileId(_xSource, _ySource);
264         uint16 destTileId = BWUtility.toTileId(_xDest, _yDest);
265 
266         address sourceTileClaimer;
267         address destTileClaimer;
268         uint sourceTileBlockValue;
269         uint destTileBlockValue;
270         (sourceTileClaimer, sourceTileBlockValue) = bwData.getTileClaimerAndBlockValue(sourceTileId);
271         (destTileClaimer, destTileBlockValue) = bwData.getTileClaimerAndBlockValue(destTileId);
272 
273         require(sourceTileClaimer == _msgSender);
274         require(destTileClaimer == _msgSender);
275         require(_moveAmount >= 1 finney); // Can't be less
276         require(_moveAmount % 1 finney == 0); // Move amount must be in multiples of 1 finney
277         // require(sourceTile.blockValue - _moveAmount >= BASE_TILE_PRICE_WEI); // Must always leave some at source
278         
279         require(sourceTileBlockValue - _moveAmount < sourceTileBlockValue); // Prevent overflow
280         require(destTileBlockValue + _moveAmount > destTileBlockValue); // Prevent overflow
281         require(BWUtility.isAdjacent(_xSource, _ySource, _xDest, _yDest));
282 
283         sourceTileBlockValue -= _moveAmount;
284         destTileBlockValue += _moveAmount;
285 
286         // If ALL block value was moved away from the source tile, we lose our claim to it. It becomes ownerless.
287         if (sourceTileBlockValue == 0) {
288             bwData.deleteTile(sourceTileId);
289         } else {
290             bwData.updateTileBlockValue(sourceTileId, sourceTileBlockValue);
291             bwData.deleteOffer(sourceTileId); // Offer invalid since block value has changed
292         }
293 
294         bwData.updateTileBlockValue(destTileId, destTileBlockValue);
295         bwData.deleteOffer(destTileId);   // Offer invalid since block value has changed
296         emit BlockValueMoved(sourceTileId, destTileId, _msgSender, _moveAmount, sourceTileBlockValue, destTileBlockValue, block.timestamp);        
297     }
298 
299 
300     // BATTLE VALUE FUNCTIONS
301     function withdrawBattleValue(address msgSender, uint _battleValueInWei) public isValidCaller returns (uint) {
302         require(bwData.hasUser(msgSender));
303         require(_battleValueInWei % 1 finney == 0); // Must be divisible by 1 finney
304         uint fee = _battleValueInWei / WITHDRAW_FEE; // Since we divide by 20 we can never create infinite fractions, so we'll always count in whole wei amounts.
305         require(_battleValueInWei - fee < _battleValueInWei); // prevent underflow
306 
307         uint amountToWithdraw = _battleValueInWei - fee;
308         uint feeBalance = bwData.getFeeBalance();
309         require(feeBalance + fee >= feeBalance); // prevent overflow
310         feeBalance += fee;
311         bwData.setFeeBalance(feeBalance);
312         subUserBattleValue(msgSender, _battleValueInWei, true);
313         return amountToWithdraw;
314     }
315 
316     function addUserBattleValue(address _userId, uint _amount) public isValidCaller {
317         uint userBattleValue = bwData.getUserBattleValue(_userId);
318         require(userBattleValue + _amount > userBattleValue); // prevent overflow
319         uint newBattleValue = userBattleValue + _amount;
320         bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
321         emit UserBattleValueUpdated(_userId, newBattleValue, false);
322     }
323     
324     function subUserBattleValue(address _userId, uint _amount, bool _isWithdraw) public isValidCaller {
325         uint userBattleValue = bwData.getUserBattleValue(_userId);
326         require(_amount <= userBattleValue); // Must be less than user's battle value - also implicitly checks that underflow isn't possible
327         uint newBattleValue = userBattleValue - _amount;
328         bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
329         emit UserBattleValueUpdated(_userId, newBattleValue, _isWithdraw);
330     }
331 
332     function addGlobalBlockValueBalance(uint _amount) public isValidCaller {
333         // Track addition to global block value.
334         uint blockValueBalance = bwData.getBlockValueBalance();
335         require(blockValueBalance + _amount > blockValueBalance); // Prevent overflow
336         bwData.setBlockValueBalance(blockValueBalance + _amount);
337     }
338 
339     // Allow us to transfer out airdropped tokens if we ever receive any
340     function transferTokens(address _tokenAddress, address _recipient) public isOwner {
341         ERC20I token = ERC20I(_tokenAddress);
342         require(token.transfer(_recipient, token.balanceOf(this)));
343     }
344 }
345 
346 contract BWData {
347     address public owner;
348     address private bwService;
349     address private bw;
350     address private bwMarket;
351 
352     uint private blockValueBalance = 0;
353     uint private feeBalance = 0;
354     uint private BASE_TILE_PRICE_WEI = 1 finney; // 1 milli-ETH.
355     
356     mapping (address => User) private users; // user address -> user information
357     mapping (uint16 => Tile) private tiles; // tileId -> list of TileClaims for that particular tile
358     
359     // Info about the users = those who have purchased tiles.
360     struct User {
361         uint creationTime;
362         bool censored;
363         uint battleValue;
364     }
365 
366     // Info about a tile ownership
367     struct Tile {
368         address claimer;
369         uint blockValue;
370         uint creationTime;
371         uint sellPrice;    // If 0 -> not on marketplace. If > 0 -> on marketplace.
372     }
373 
374     struct Boost {
375         uint8 numAttackBoosts;
376         uint8 numDefendBoosts;
377         uint attackBoost;
378         uint defendBoost;
379     }
380 
381     constructor() public {
382         owner = msg.sender;
383     }
384 
385     // Can't send funds straight to this contract. Avoid people sending by mistake.
386     function () payable public {
387         revert();
388     }
389 
390     function kill() public isOwner {
391         selfdestruct(owner);
392     }
393 
394     modifier isValidCaller {
395         if (msg.sender != bwService && msg.sender != bw && msg.sender != bwMarket) {
396             revert();
397         }
398         _;
399     }
400     
401     modifier isOwner {
402         if (msg.sender != owner) {
403             revert();
404         }
405         _;
406     }
407     
408     function setBwServiceValidCaller(address _bwService) public isOwner {
409         bwService = _bwService;
410     }
411 
412     function setBwValidCaller(address _bw) public isOwner {
413         bw = _bw;
414     }
415 
416     function setBwMarketValidCaller(address _bwMarket) public isOwner {
417         bwMarket = _bwMarket;
418     }    
419     
420     // ----------USER-RELATED GETTER FUNCTIONS------------
421     
422     //function getUser(address _user) view public returns (bytes32) {
423         //BWUtility.User memory user = users[_user];
424         //require(user.creationTime != 0);
425         //return (user.creationTime, user.imageUrl, user.tag, user.email, user.homeUrl, user.creationTime, user.censored, user.battleValue);
426     //}
427     
428     function addUser(address _msgSender) public isValidCaller {
429         User storage user = users[_msgSender];
430         require(user.creationTime == 0);
431         user.creationTime = block.timestamp;
432     }
433 
434     function hasUser(address _user) view public isValidCaller returns (bool) {
435         return users[_user].creationTime != 0;
436     }
437     
438 
439     // ----------TILE-RELATED GETTER FUNCTIONS------------
440 
441     function getTile(uint16 _tileId) view public isValidCaller returns (address, uint, uint, uint) {
442         Tile storage currentTile = tiles[_tileId];
443         return (currentTile.claimer, currentTile.blockValue, currentTile.creationTime, currentTile.sellPrice);
444     }
445     
446     function getTileClaimerAndBlockValue(uint16 _tileId) view public isValidCaller returns (address, uint) {
447         Tile storage currentTile = tiles[_tileId];
448         return (currentTile.claimer, currentTile.blockValue);
449     }
450     
451     function isNewTile(uint16 _tileId) view public isValidCaller returns (bool) {
452         Tile storage currentTile = tiles[_tileId];
453         return currentTile.creationTime == 0;
454     }
455     
456     function storeClaim(uint16 _tileId, address _claimer, uint _blockValue) public isValidCaller {
457         tiles[_tileId] = Tile(_claimer, _blockValue, block.timestamp, 0);
458     }
459 
460     function updateTileBlockValue(uint16 _tileId, uint _blockValue) public isValidCaller {
461         tiles[_tileId].blockValue = _blockValue;
462     }
463 
464     function setClaimerForTile(uint16 _tileId, address _claimer) public isValidCaller {
465         tiles[_tileId].claimer = _claimer;
466     }
467 
468     function updateTileTimeStamp(uint16 _tileId) public isValidCaller {
469         tiles[_tileId].creationTime = block.timestamp;
470     }
471     
472     function getCurrentClaimerForTile(uint16 _tileId) view public isValidCaller returns (address) {
473         Tile storage currentTile = tiles[_tileId];
474         if (currentTile.creationTime == 0) {
475             return 0;
476         }
477         return currentTile.claimer;
478     }
479 
480     function getCurrentBlockValueAndSellPriceForTile(uint16 _tileId) view public isValidCaller returns (uint, uint) {
481         Tile storage currentTile = tiles[_tileId];
482         if (currentTile.creationTime == 0) {
483             return (0, 0);
484         }
485         return (currentTile.blockValue, currentTile.sellPrice);
486     }
487     
488     function getBlockValueBalance() view public isValidCaller returns (uint){
489         return blockValueBalance;
490     }
491 
492     function setBlockValueBalance(uint _blockValueBalance) public isValidCaller {
493         blockValueBalance = _blockValueBalance;
494     }
495 
496     function getFeeBalance() view public isValidCaller returns (uint) {
497         return feeBalance;
498     }
499 
500     function setFeeBalance(uint _feeBalance) public isValidCaller {
501         feeBalance = _feeBalance;
502     }
503     
504     function getUserBattleValue(address _userId) view public isValidCaller returns (uint) {
505         return users[_userId].battleValue;
506     }
507     
508     function setUserBattleValue(address _userId, uint _battleValue) public  isValidCaller {
509         users[_userId].battleValue = _battleValue;
510     }
511     
512     function verifyAmount(address _msgSender, uint _msgValue, uint _amount, bool _useBattleValue) view public isValidCaller {
513         User storage user = users[_msgSender];
514         require(user.creationTime != 0);
515 
516         if (_useBattleValue) {
517             require(_msgValue == 0);
518             require(user.battleValue >= _amount);
519         } else {
520             require(_amount == _msgValue);
521         }
522     }
523     
524     function addBoostFromTile(Tile _tile, address _attacker, address _defender, Boost memory _boost) pure private {
525         if (_tile.claimer == _attacker) {
526             require(_boost.attackBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
527             _boost.attackBoost += _tile.blockValue;
528             _boost.numAttackBoosts += 1;
529         } else if (_tile.claimer == _defender) {
530             require(_boost.defendBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
531             _boost.defendBoost += _tile.blockValue;
532             _boost.numDefendBoosts += 1;
533         }
534     }
535 
536     function calculateBattleBoost(uint16 _tileId, address _attacker, address _defender) view public isValidCaller returns (uint, uint) {
537         uint8 x;
538         uint8 y;
539 
540         (x, y) = BWUtility.fromTileId(_tileId);
541 
542         Boost memory boost = Boost(0, 0, 0, 0);
543         // We overflow x, y on purpose here if x or y is 0 or 255 - the map overflows and so should adjacency.
544         // Go through all adjacent tiles to (x, y).
545         if (y != 255) {
546             if (x != 255) {
547                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y+1)], _attacker, _defender, boost);
548             }
549             
550             addBoostFromTile(tiles[BWUtility.toTileId(x, y+1)], _attacker, _defender, boost);
551 
552             if (x != 0) {
553                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y+1)], _attacker, _defender, boost);
554             }
555         }
556 
557         if (x != 255) {
558             addBoostFromTile(tiles[BWUtility.toTileId(x+1, y)], _attacker, _defender, boost);
559         }
560 
561         if (x != 0) {
562             addBoostFromTile(tiles[BWUtility.toTileId(x-1, y)], _attacker, _defender, boost);
563         }
564 
565         if (y != 0) {
566             if(x != 255) {
567                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y-1)], _attacker, _defender, boost);
568             }
569 
570             addBoostFromTile(tiles[BWUtility.toTileId(x, y-1)], _attacker, _defender, boost);
571 
572             if(x != 0) {
573                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y-1)], _attacker, _defender, boost);
574             }
575         }
576         // The benefit of boosts is multiplicative (quadratic):
577         // - More boost tiles gives a higher total blockValue (the sum of the adjacent tiles)
578         // - More boost tiles give a higher multiple of that total blockValue that can be used (10% per adjacent tie)
579         // Example:
580         //   A) I boost attack with 1 single tile worth 10 finney
581         //      -> Total boost is 10 * 1 / 10 = 1 finney
582         //   B) I boost attack with 3 tiles worth 1 finney each
583         //      -> Total boost is (1+1+1) * 3 / 10 = 0.9 finney
584         //   C) I boost attack with 8 tiles worth 2 finney each
585         //      -> Total boost is (2+2+2+2+2+2+2+2) * 8 / 10 = 14.4 finney
586         //   D) I boost attack with 3 tiles of 1, 5 and 10 finney respectively
587         //      -> Total boost is (ss1+5+10) * 3 / 10 = 4.8 finney
588         // This division by 10 can't create fractions since our uint is wei, and we can't have overflow from the multiplication
589         // We do allow fractions of finney here since the boosted values aren't stored anywhere, only used for attack rolls and sent in events
590         boost.attackBoost = (boost.attackBoost / 10 * boost.numAttackBoosts);
591         boost.defendBoost = (boost.defendBoost / 10 * boost.numDefendBoosts);
592 
593         return (boost.attackBoost, boost.defendBoost);
594     }
595     
596     function censorUser(address _userAddress, bool _censored) public isValidCaller {
597         User storage user = users[_userAddress];
598         require(user.creationTime != 0);
599         user.censored = _censored;
600     }
601     
602     function deleteTile(uint16 _tileId) public isValidCaller {
603         delete tiles[_tileId];
604     }
605     
606     function setSellPrice(uint16 _tileId, uint _sellPrice) public isValidCaller {
607         tiles[_tileId].sellPrice = _sellPrice;  //testrpc cannot estimate gas when delete is used.
608     }
609 
610     function deleteOffer(uint16 _tileId) public isValidCaller {
611         tiles[_tileId].sellPrice = 0;  //testrpc cannot estimate gas when delete is used.
612     }
613 }
614 
615 /**
616  * Copyright 2018 Block Wars Team
617  *
618  */
619 
620 contract BW { 
621     address public owner;
622     BWService private bwService;
623     BWData private bwData;
624     bool public paused = false;
625     
626     modifier isOwner {
627         if (msg.sender != owner) {
628             revert();
629         }
630         _;
631     }
632 
633     // Checks if entire game (except battle value withdraw) is paused or not.
634     modifier isNotPaused {
635         if (paused) {
636             revert();
637         }
638         _;
639     }
640 
641     // Only allow wallets to call this function, not contracts.
642     modifier isNotContractCaller {
643         require(msg.sender == tx.origin);
644         _;
645     }
646 
647     // All contract event types.
648     event UserCreated(address userAddress, bytes32 name, bytes imageUrl, bytes32 tag, bytes32 homeUrl, uint creationTime, address invitedBy);
649     event UserCensored(address userAddress, bool isCensored);
650     event TransferTileFromOwner(uint16 tileId, address seller, address buyer, uint acceptTime); // Sent when a user buys a tile from another user, by accepting a tile offer
651     event UserUpdated(address userAddress, bytes32 name, bytes imageUrl, bytes32 tag, bytes32 homeUrl, uint updateTime);    
652 
653     // BASIC CONTRACT FUNCTIONS
654     // Constructor.
655     constructor(address _bwService, address _bwData) public {
656         bwService = BWService(_bwService);
657         bwData = BWData(_bwData);
658         owner = msg.sender;
659     }
660 
661     // Can't send funds straight to this contract. Avoid people sending by mistake.
662     function () payable public {
663         revert();
664     }
665 
666     // Allow a new user to claim one or more previously unclaimed tiles by paying Ether.
667     function claimTilesForNewUser(bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl, uint16[] _claimedTileIds, address _invitedBy) payable public isNotPaused isNotContractCaller {
668         bwData.addUser(msg.sender);
669         emit UserCreated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp, _invitedBy);
670         bwService.storeInitialClaim(msg.sender, _claimedTileIds, msg.value, false);
671     }
672 
673     // Allow an existing user to claim one or more previously unclaimed tiles by paying Ether.
674     function claimTilesForExistingUser(uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) payable public isNotPaused isNotContractCaller {
675         bwData.verifyAmount(msg.sender, msg.value, _claimAmount, _useBattleValue);
676         bwService.storeInitialClaim(msg.sender, _claimedTileIds, _claimAmount, _useBattleValue);
677     }
678 
679     // Allow users to change name, image URL, tag and home URL. Not censored status or battle value though.
680     function updateUser(bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl) public isNotPaused isNotContractCaller {
681         require(bwData.hasUser(msg.sender));
682         // All the updated values are stored in events only so there's no state to update on the contract here.
683         emit UserUpdated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp);
684     }
685     
686     // This function fortifies multiple previously claimed tiles in a single transaction.
687     // The value assigned to each tile is the msg.value divided by the number of tiles fortified.
688     // The msg.value is required to be an even multiple of the number of tiles fortified.
689     // Only tiles owned by msg.sender can be fortified.
690     function fortifyClaims(uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) payable public isNotPaused isNotContractCaller {
691         bwData.verifyAmount(msg.sender, msg.value, _fortifyAmount, _useBattleValue);
692         bwService.fortifyClaims(msg.sender, _claimedTileIds, _fortifyAmount, _useBattleValue);
693     }
694 
695     // A new user attacks a tile claimed by someone else, trying to make it theirs through battle.
696     function attackTileForNewUser(uint16 _tileId, bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl, address _invitedBy) payable public isNotPaused isNotContractCaller {
697         bwData.addUser(msg.sender);
698         emit UserCreated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp, _invitedBy);
699         bwService.attackTile(msg.sender, _tileId, msg.value, false, false);
700     }
701 
702         // An existing user attacks a tile claimed by someone else, trying to make it theirs through battle.
703     function attackTileForExistingUser(uint16 _tileId, uint _attackAmount, bool _useBattleValue, bool _autoFortify) payable public isNotPaused isNotContractCaller {
704         bwData.verifyAmount(msg.sender, msg.value, _attackAmount, _useBattleValue);
705         bwService.attackTile(msg.sender, _tileId, _attackAmount, _useBattleValue, _autoFortify);
706     }
707     
708     // Move "army" = block value from one block to an adjacent block. Moving ALL value equates giving up ownership of the source tile.
709     function moveBlockValue(uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isNotPaused isNotContractCaller {
710         bwService.moveBlockValue(msg.sender, _xSource, _ySource, _xDest, _yDest, _moveAmount);
711     }
712 
713     // Allow users to withdraw battle value in Ether.
714     function withdrawBattleValue(uint _battleValueInWei) public isNotContractCaller {
715         uint amountToWithdraw = bwService.withdrawBattleValue(msg.sender, _battleValueInWei);
716         msg.sender.transfer(amountToWithdraw);
717     }
718 
719     // -------- OWNER-ONLY FUNCTIONS ----------
720 
721 
722     // Only used by owner for raffle. Owner need name, address and picture from user.
723     // These users can then be given tiles by owner using transferTileFromOwner.
724     function createNewUser(bytes32 _name, bytes _imageUrl, address _user) public isOwner {
725         bwData.addUser(_user);
726         emit UserCreated(msg.sender, _name, _imageUrl, 0x0, 0x0, block.timestamp, 0x0);
727     }
728 
729     // Allow updating censored status. Owner only. In case someone uploads offensive content.
730     // The contract owners reserve the right to apply censorship. This will mean that the
731     // name, tag or URL images might not be displayed for a censored user.
732     function censorUser(address _userAddress, bool _censored) public isOwner {
733         bwData.censorUser(_userAddress, _censored);
734         emit UserCensored(_userAddress, _censored);
735     }
736 
737     // Pause the entire game, but let users keep withdrawing battle value
738     function setPaused(bool _paused) public isOwner {
739         paused = _paused;
740     }
741 
742     function kill() public isOwner {
743         selfdestruct(owner);
744     }
745     
746     function withdrawValue(bool _isFee) public isOwner {
747         uint balance = address(this).balance;
748         uint amountToWithdraw;
749         
750         if (_isFee) {
751             amountToWithdraw = bwData.getFeeBalance();
752 
753             if (balance < amountToWithdraw) { // Should never happen, but paranoia
754                 amountToWithdraw = balance;
755             }
756             bwData.setFeeBalance(0);
757         } else {
758             amountToWithdraw = bwData.getBlockValueBalance();
759 
760             if (balance < amountToWithdraw) { // Should never happen, but paranoia
761                 amountToWithdraw = balance;
762             }
763             bwData.setBlockValueBalance(0);
764         }
765 
766         owner.transfer(amountToWithdraw);
767     }
768 
769     function depositBattleValue(address _user) payable public isOwner {
770         require(bwData.hasUser(_user));
771         require(msg.value % 1 finney == 0); // Must be divisible by 1 finney
772         bwService.addUserBattleValue(_user, msg.value);
773     }
774 
775     // The owner can transfer ownership of own tiles to other users, as prizes in competitions.
776     function transferTileFromOwner(uint16 _tileId, address _newOwner) public payable isOwner {
777         address claimer = bwData.getCurrentClaimerForTile(_tileId);
778         require(claimer == owner);
779         require(bwData.hasUser(_newOwner));
780         require(msg.value % 1 finney == 0); // Must be divisible by 1 finney
781         uint balance = address(this).balance;
782         require(balance + msg.value >= balance); // prevent overflow
783         bwData.setClaimerForTile(_tileId, _newOwner);
784         bwService.addUserBattleValue(_newOwner, msg.value);
785         
786         emit TransferTileFromOwner(_tileId, _newOwner, msg.sender, block.timestamp);
787     }
788 
789     // Allow us to transfer out airdropped tokens if we ever receive any
790     function transferTokens(address _tokenAddress, address _recipient) public isOwner {
791         ERC20I token = ERC20I(_tokenAddress);
792         require(token.transfer(_recipient, token.balanceOf(this)));
793     }
794 }