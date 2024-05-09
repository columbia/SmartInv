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
47     interface ERC20I {
48         function transfer(address _recipient, uint256 _amount) external returns (bool);
49         function balanceOf(address _holder) external view returns (uint256);
50     }
51     
52     
53     contract BWService {
54         address private owner;
55         address private bw;
56         address private bwMarket;
57         BWData private bwData;
58         uint private seed = 42;
59         uint private WITHDRAW_FEE = 20; //1/20 = 5%
60         
61         modifier isOwner {
62             if (msg.sender != owner) {
63                 revert();
64             }
65             _;
66         }  
67     
68         modifier isValidCaller {
69             if (msg.sender != bw && msg.sender != bwMarket) {
70                 revert();
71             }
72             _;
73         }
74     
75         event TileClaimed(uint16 tileId, address newClaimer, uint priceInWei, uint creationTime);
76         event TileFortified(uint16 tileId, address claimer, uint addedValueInWei, uint priceInWei, uint fortifyTime); // Sent when a user fortifies an existing claim by bumping its value.
77         event TileAttackedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint attackTime); // Sent when a user successfully attacks a tile.    
78         event TileDefendedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint defendTime); // Sent when a user successfully defends a tile when attacked.    
79         event BlockValueMoved(uint16 sourceTileId, uint16 destTileId, address owner, uint movedBlockValue, uint postSourceValue, uint postDestValue, uint moveTime); // Sent when a user buys a tile from another user, by accepting a tile offer
80         event UserBattleValueUpdated(address userAddress, uint battleValue, bool isWithdraw);
81     
82         // Constructor.
83         constructor(address _bwData) public {
84             bwData = BWData(_bwData);
85             owner = msg.sender;
86         }
87     
88         // Can't send funds straight to this contract. Avoid people sending by mistake.
89         function () payable public {
90             revert();
91         }
92     
93         // OWNER-ONLY FUNCTIONS
94         function kill() public isOwner {
95             selfdestruct(owner);
96         }
97     
98         function setValidBwCaller(address _bw) public isOwner {
99             bw = _bw;
100         }
101         
102         function setValidBwMarketCaller(address _bwMarket) public isOwner {
103             bwMarket = _bwMarket;
104         }
105     
106     
107         // TILE-RELATED FUNCTIONS
108         // This function claims multiple previously unclaimed tiles in a single transaction.
109         // The value assigned to each tile is the msg.value divided by the number of tiles claimed.
110         // The msg.value is required to be an even multiple of the number of tiles claimed.
111         function storeInitialClaim(address _msgSender, uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) public isValidCaller {
112             uint tileCount = _claimedTileIds.length;
113             require(tileCount > 0);
114             require(_claimAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
115             require(_claimAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles claimed
116     
117             uint valuePerBlockInWei = _claimAmount / tileCount; // Due to requires above this is guaranteed to be an even number
118     
119             if (_useBattleValue) {
120                 subUserBattleValue(_msgSender, _claimAmount, false);  
121             }
122     
123             addGlobalBlockValueBalance(_claimAmount);
124     
125             uint16 tileId;
126             bool isNewTile;
127             for (uint16 i = 0; i < tileCount; i++) {
128                 tileId = _claimedTileIds[i];
129                 isNewTile = bwData.isNewTile(tileId); // Is length 0 if first time purchased
130                 require(isNewTile); // Can only claim previously unclaimed tiles.
131     
132                 // Send claim event
133                 emit TileClaimed(tileId, _msgSender, valuePerBlockInWei, block.timestamp);
134     
135                 // Update contract state with new tile ownership.
136                 bwData.storeClaim(tileId, _msgSender, valuePerBlockInWei);
137             }
138         }
139     
140         function fortifyClaims(address _msgSender, uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) public isValidCaller {
141             uint tileCount = _claimedTileIds.length;
142             require(tileCount > 0);
143     
144             uint balance = address(this).balance;
145             require(balance + _fortifyAmount > balance); // prevent overflow
146             require(_fortifyAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles fortified
147             uint addedValuePerTileInWei = _fortifyAmount / tileCount; // Due to requires above this is guaranteed to be an even number
148             require(_fortifyAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
149     
150             address claimer;
151             uint blockValue;
152             for (uint16 i = 0; i < tileCount; i++) {
153                 (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_claimedTileIds[i]);
154                 require(claimer != 0); // Can't do this on never-owned tiles
155                 require(claimer == _msgSender); // Only current claimer can fortify claim
156     
157                 if (_useBattleValue) {
158                     subUserBattleValue(_msgSender, addedValuePerTileInWei, false);
159                 }
160                 
161                 fortifyClaim(_msgSender, _claimedTileIds[i], addedValuePerTileInWei);
162             }
163         }
164     
165         function fortifyClaim(address _msgSender, uint16 _claimedTileId, uint _fortifyAmount) private {
166             uint blockValue;
167             uint sellPrice;
168             (blockValue, sellPrice) = bwData.getCurrentBlockValueAndSellPriceForTile(_claimedTileId);
169             uint updatedBlockValue = blockValue + _fortifyAmount;
170             // Send fortify event
171             emit TileFortified(_claimedTileId, _msgSender, _fortifyAmount, updatedBlockValue, block.timestamp);
172             
173             // Update tile value. The tile has been fortified by bumping up its value.
174             bwData.updateTileBlockValue(_claimedTileId, updatedBlockValue);
175     
176             // Track addition to global block value
177             addGlobalBlockValueBalance(_fortifyAmount);
178         }
179     
180         // Return a pseudo random number between lower and upper bounds
181         // given the number of previous blocks it should hash.
182         // Random function copied from https://github.com/axiomzen/eth-random/blob/master/contracts/Random.sol.
183         // Changed sha3 to keccak256.
184         // Changed random range from uint64 to uint (=uint256).
185         function random(uint _upper) private returns (uint)  {
186             seed = uint(keccak256(keccak256(blockhash(block.number), seed), now));
187             return seed % _upper;
188         }
189     
190         // A user tries to claim a tile that's already owned by another user. A battle ensues.
191         // A random roll is done with % based on attacking vs defending amounts.
192         function attackTile(address _msgSender, uint16 _tileId, uint _attackAmount, bool _useBattleValue, bool _autoFortify) public isValidCaller {
193             require(_attackAmount >= 1 finney);         // Don't allow attacking with less than one base tile price.
194             require(_attackAmount % 1 finney == 0);
195     
196             address claimer;
197             uint blockValue;
198             (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_tileId);
199             
200             require(claimer != 0); // Can't do this on never-owned tiles
201             require(claimer != _msgSender); // Can't attack one's own tiles
202             require(claimer != owner); // Can't attack owner's tiles because it is used for raffle.
203     
204             // Calculate boosted amounts for attacker and defender
205             // The base attack amount is sent in the by the user.
206             // The base defend amount is the attacked tile's current blockValue.
207             uint attackBoost;
208             uint defendBoost;
209             (attackBoost, defendBoost) = bwData.calculateBattleBoost(_tileId, _msgSender, claimer);
210             uint totalAttackAmount = _attackAmount + attackBoost;
211             uint totalDefendAmount = blockValue + defendBoost;
212             require(totalAttackAmount >= _attackAmount); // prevent overflow
213             require(totalDefendAmount >= blockValue); // prevent overflow
214             require(totalAttackAmount + totalDefendAmount > totalAttackAmount && totalAttackAmount + totalDefendAmount > totalDefendAmount); // Prevent overflow
215     
216             // Verify that attack odds are within allowed range.
217             require(totalAttackAmount / 10 <= blockValue); // Disallow attacks with more than 1000% of defendAmount
218             require(totalAttackAmount >= blockValue / 10); // Disallow attacks with less than 10% of defendAmount
219     
220             // The battle considers boosts.
221             uint attackRoll = random(totalAttackAmount + totalDefendAmount); // This is where the excitement happens!
222             if (attackRoll > totalDefendAmount) {
223                 // Send update event
224                 emit TileAttackedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
225     
226                 // Change block owner but keep same block value (attacker got battlevalue instead)
227                 bwData.setClaimerForTile(_tileId, _msgSender);
228     
229                 // Tile successfully attacked!
230                 if (_useBattleValue) {
231                     if (_autoFortify) {
232                         // Fortify the won tile using battle value
233                         fortifyClaim(_msgSender, _tileId, _attackAmount);
234                         subUserBattleValue(_msgSender, _attackAmount, false);
235                     } else {
236                         // No reason to withdraw followed by deposit of same amount
237                     }
238                 } else {
239                     if (_autoFortify) {
240                         // Fortify the won tile using attack amount
241                         fortifyClaim(_msgSender, _tileId, _attackAmount);
242                     } else {
243                         addUserBattleValue(_msgSender, _attackAmount); // Don't include boost here!
244                     }
245                 }
246             } else {
247                 // Tile successfully defended!
248                 if (_useBattleValue) {
249                     subUserBattleValue(_msgSender, _attackAmount, false); // Don't include boost here!
250                 }
251                 addUserBattleValue(claimer, _attackAmount); // Don't include boost here!
252     
253                 // Send update event
254                 emit TileDefendedSuccessfully(_tileId, _msgSender, _attackAmount, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
255     
256                 // Update the timestamp for the defended block.
257                 bwData.updateTileTimeStamp(_tileId);
258             }
259         }
260     
261         function moveBlockValue(address _msgSender, uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isValidCaller {
262             uint16 sourceTileId = BWUtility.toTileId(_xSource, _ySource);
263             uint16 destTileId = BWUtility.toTileId(_xDest, _yDest);
264     
265             address sourceTileClaimer;
266             address destTileClaimer;
267             uint sourceTileBlockValue;
268             uint destTileBlockValue;
269             (sourceTileClaimer, sourceTileBlockValue) = bwData.getTileClaimerAndBlockValue(sourceTileId);
270             (destTileClaimer, destTileBlockValue) = bwData.getTileClaimerAndBlockValue(destTileId);
271     
272             require(sourceTileClaimer == _msgSender);
273             require(destTileClaimer == _msgSender);
274             require(_moveAmount >= 1 finney); // Can't be less
275             require(_moveAmount % 1 finney == 0); // Move amount must be in multiples of 1 finney
276             // require(sourceTile.blockValue - _moveAmount >= BASE_TILE_PRICE_WEI); // Must always leave some at source
277             
278             require(sourceTileBlockValue - _moveAmount < sourceTileBlockValue); // Prevent overflow
279             require(destTileBlockValue + _moveAmount > destTileBlockValue); // Prevent overflow
280             require(BWUtility.isAdjacent(_xSource, _ySource, _xDest, _yDest));
281     
282             sourceTileBlockValue -= _moveAmount;
283             destTileBlockValue += _moveAmount;
284     
285             // If ALL block value was moved away from the source tile, we lose our claim to it. It becomes ownerless.
286             if (sourceTileBlockValue == 0) {
287                 bwData.deleteTile(sourceTileId);
288             } else {
289                 bwData.updateTileBlockValue(sourceTileId, sourceTileBlockValue);
290                 bwData.deleteOffer(sourceTileId); // Offer invalid since block value has changed
291             }
292     
293             bwData.updateTileBlockValue(destTileId, destTileBlockValue);
294             bwData.deleteOffer(destTileId);   // Offer invalid since block value has changed
295             emit BlockValueMoved(sourceTileId, destTileId, _msgSender, _moveAmount, sourceTileBlockValue, destTileBlockValue, block.timestamp);        
296         }
297     
298     
299         // BATTLE VALUE FUNCTIONS
300         function withdrawBattleValue(address msgSender, uint _battleValueInWei) public isValidCaller returns (uint) {
301             require(bwData.hasUser(msgSender));
302             require(_battleValueInWei % 1 finney == 0); // Must be divisible by 1 finney
303             uint fee = _battleValueInWei / WITHDRAW_FEE; // Since we divide by 20 we can never create infinite fractions, so we'll always count in whole wei amounts.
304             require(_battleValueInWei - fee < _battleValueInWei); // prevent underflow
305     
306             uint amountToWithdraw = _battleValueInWei - fee;
307             uint feeBalance = bwData.getFeeBalance();
308             require(feeBalance + fee >= feeBalance); // prevent overflow
309             feeBalance += fee;
310             bwData.setFeeBalance(feeBalance);
311             subUserBattleValue(msgSender, _battleValueInWei, true);
312             return amountToWithdraw;
313         }
314     
315         function addUserBattleValue(address _userId, uint _amount) public isValidCaller {
316             uint userBattleValue = bwData.getUserBattleValue(_userId);
317             require(userBattleValue + _amount > userBattleValue); // prevent overflow
318             uint newBattleValue = userBattleValue + _amount;
319             bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
320             emit UserBattleValueUpdated(_userId, newBattleValue, false);
321         }
322         
323         function subUserBattleValue(address _userId, uint _amount, bool _isWithdraw) public isValidCaller {
324             uint userBattleValue = bwData.getUserBattleValue(_userId);
325             require(_amount <= userBattleValue); // Must be less than user's battle value - also implicitly checks that underflow isn't possible
326             uint newBattleValue = userBattleValue - _amount;
327             bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
328             emit UserBattleValueUpdated(_userId, newBattleValue, _isWithdraw);
329         }
330     
331         function addGlobalBlockValueBalance(uint _amount) public isValidCaller {
332             // Track addition to global block value.
333             uint blockValueBalance = bwData.getBlockValueBalance();
334             require(blockValueBalance + _amount > blockValueBalance); // Prevent overflow
335             bwData.setBlockValueBalance(blockValueBalance + _amount);
336         }
337     
338         // Allow us to transfer out airdropped tokens if we ever receive any
339         function transferTokens(address _tokenAddress, address _recipient) public isOwner {
340             ERC20I token = ERC20I(_tokenAddress);
341             require(token.transfer(_recipient, token.balanceOf(this)));
342         }
343     }
344 
345 contract BWData {
346     address public owner;
347     address private bwService;
348     address private bw;
349     address private bwMarket;
350 
351     uint private blockValueBalance = 0;
352     uint private feeBalance = 0;
353     uint private BASE_TILE_PRICE_WEI = 1 finney; // 1 milli-ETH.
354     
355     mapping (address => User) private users; // user address -> user information
356     mapping (uint16 => Tile) private tiles; // tileId -> list of TileClaims for that particular tile
357     
358     // Info about the users = those who have purchased tiles.
359     struct User {
360         uint creationTime;
361         bool censored;
362         uint battleValue;
363     }
364 
365     // Info about a tile ownership
366     struct Tile {
367         address claimer;
368         uint blockValue;
369         uint creationTime;
370         uint sellPrice;    // If 0 -> not on marketplace. If > 0 -> on marketplace.
371     }
372 
373     struct Boost {
374         uint8 numAttackBoosts;
375         uint8 numDefendBoosts;
376         uint attackBoost;
377         uint defendBoost;
378     }
379 
380     constructor() public {
381         owner = msg.sender;
382     }
383 
384     // Can't send funds straight to this contract. Avoid people sending by mistake.
385     function () payable public {
386         revert();
387     }
388 
389     function kill() public isOwner {
390         selfdestruct(owner);
391     }
392 
393     modifier isValidCaller {
394         if (msg.sender != bwService && msg.sender != bw && msg.sender != bwMarket) {
395             revert();
396         }
397         _;
398     }
399     
400     modifier isOwner {
401         if (msg.sender != owner) {
402             revert();
403         }
404         _;
405     }
406     
407     function setBwServiceValidCaller(address _bwService) public isOwner {
408         bwService = _bwService;
409     }
410 
411     function setBwValidCaller(address _bw) public isOwner {
412         bw = _bw;
413     }
414 
415     function setBwMarketValidCaller(address _bwMarket) public isOwner {
416         bwMarket = _bwMarket;
417     }    
418     
419     // ----------USER-RELATED GETTER FUNCTIONS------------
420     
421     //function getUser(address _user) view public returns (bytes32) {
422         //BWUtility.User memory user = users[_user];
423         //require(user.creationTime != 0);
424         //return (user.creationTime, user.imageUrl, user.tag, user.email, user.homeUrl, user.creationTime, user.censored, user.battleValue);
425     //}
426     
427     function addUser(address _msgSender) public isValidCaller {
428         User storage user = users[_msgSender];
429         require(user.creationTime == 0);
430         user.creationTime = block.timestamp;
431     }
432 
433     function hasUser(address _user) view public isValidCaller returns (bool) {
434         return users[_user].creationTime != 0;
435     }
436     
437 
438     // ----------TILE-RELATED GETTER FUNCTIONS------------
439 
440     function getTile(uint16 _tileId) view public isValidCaller returns (address, uint, uint, uint) {
441         Tile storage currentTile = tiles[_tileId];
442         return (currentTile.claimer, currentTile.blockValue, currentTile.creationTime, currentTile.sellPrice);
443     }
444     
445     function getTileClaimerAndBlockValue(uint16 _tileId) view public isValidCaller returns (address, uint) {
446         Tile storage currentTile = tiles[_tileId];
447         return (currentTile.claimer, currentTile.blockValue);
448     }
449     
450     function isNewTile(uint16 _tileId) view public isValidCaller returns (bool) {
451         Tile storage currentTile = tiles[_tileId];
452         return currentTile.creationTime == 0;
453     }
454     
455     function storeClaim(uint16 _tileId, address _claimer, uint _blockValue) public isValidCaller {
456         tiles[_tileId] = Tile(_claimer, _blockValue, block.timestamp, 0);
457     }
458 
459     function updateTileBlockValue(uint16 _tileId, uint _blockValue) public isValidCaller {
460         tiles[_tileId].blockValue = _blockValue;
461     }
462 
463     function setClaimerForTile(uint16 _tileId, address _claimer) public isValidCaller {
464         tiles[_tileId].claimer = _claimer;
465     }
466 
467     function updateTileTimeStamp(uint16 _tileId) public isValidCaller {
468         tiles[_tileId].creationTime = block.timestamp;
469     }
470     
471     function getCurrentClaimerForTile(uint16 _tileId) view public isValidCaller returns (address) {
472         Tile storage currentTile = tiles[_tileId];
473         if (currentTile.creationTime == 0) {
474             return 0;
475         }
476         return currentTile.claimer;
477     }
478 
479     function getCurrentBlockValueAndSellPriceForTile(uint16 _tileId) view public isValidCaller returns (uint, uint) {
480         Tile storage currentTile = tiles[_tileId];
481         if (currentTile.creationTime == 0) {
482             return (0, 0);
483         }
484         return (currentTile.blockValue, currentTile.sellPrice);
485     }
486     
487     function getBlockValueBalance() view public isValidCaller returns (uint){
488         return blockValueBalance;
489     }
490 
491     function setBlockValueBalance(uint _blockValueBalance) public isValidCaller {
492         blockValueBalance = _blockValueBalance;
493     }
494 
495     function getFeeBalance() view public isValidCaller returns (uint) {
496         return feeBalance;
497     }
498 
499     function setFeeBalance(uint _feeBalance) public isValidCaller {
500         feeBalance = _feeBalance;
501     }
502     
503     function getUserBattleValue(address _userId) view public isValidCaller returns (uint) {
504         return users[_userId].battleValue;
505     }
506     
507     function setUserBattleValue(address _userId, uint _battleValue) public  isValidCaller {
508         users[_userId].battleValue = _battleValue;
509     }
510     
511     function verifyAmount(address _msgSender, uint _msgValue, uint _amount, bool _useBattleValue) view public isValidCaller {
512         User storage user = users[_msgSender];
513         require(user.creationTime != 0);
514 
515         if (_useBattleValue) {
516             require(_msgValue == 0);
517             require(user.battleValue >= _amount);
518         } else {
519             require(_amount == _msgValue);
520         }
521     }
522     
523     function addBoostFromTile(Tile _tile, address _attacker, address _defender, Boost memory _boost) pure private {
524         if (_tile.claimer == _attacker) {
525             require(_boost.attackBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
526             _boost.attackBoost += _tile.blockValue;
527             _boost.numAttackBoosts += 1;
528         } else if (_tile.claimer == _defender) {
529             require(_boost.defendBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
530             _boost.defendBoost += _tile.blockValue;
531             _boost.numDefendBoosts += 1;
532         }
533     }
534 
535     function calculateBattleBoost(uint16 _tileId, address _attacker, address _defender) view public isValidCaller returns (uint, uint) {
536         uint8 x;
537         uint8 y;
538 
539         (x, y) = BWUtility.fromTileId(_tileId);
540 
541         Boost memory boost = Boost(0, 0, 0, 0);
542         // We overflow x, y on purpose here if x or y is 0 or 255 - the map overflows and so should adjacency.
543         // Go through all adjacent tiles to (x, y).
544         if (y != 255) {
545             if (x != 255) {
546                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y+1)], _attacker, _defender, boost);
547             }
548             
549             addBoostFromTile(tiles[BWUtility.toTileId(x, y+1)], _attacker, _defender, boost);
550 
551             if (x != 0) {
552                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y+1)], _attacker, _defender, boost);
553             }
554         }
555 
556         if (x != 255) {
557             addBoostFromTile(tiles[BWUtility.toTileId(x+1, y)], _attacker, _defender, boost);
558         }
559 
560         if (x != 0) {
561             addBoostFromTile(tiles[BWUtility.toTileId(x-1, y)], _attacker, _defender, boost);
562         }
563 
564         if (y != 0) {
565             if(x != 255) {
566                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y-1)], _attacker, _defender, boost);
567             }
568 
569             addBoostFromTile(tiles[BWUtility.toTileId(x, y-1)], _attacker, _defender, boost);
570 
571             if(x != 0) {
572                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y-1)], _attacker, _defender, boost);
573             }
574         }
575         // The benefit of boosts is multiplicative (quadratic):
576         // - More boost tiles gives a higher total blockValue (the sum of the adjacent tiles)
577         // - More boost tiles give a higher multiple of that total blockValue that can be used (10% per adjacent tie)
578         // Example:
579         //   A) I boost attack with 1 single tile worth 10 finney
580         //      -> Total boost is 10 * 1 / 10 = 1 finney
581         //   B) I boost attack with 3 tiles worth 1 finney each
582         //      -> Total boost is (1+1+1) * 3 / 10 = 0.9 finney
583         //   C) I boost attack with 8 tiles worth 2 finney each
584         //      -> Total boost is (2+2+2+2+2+2+2+2) * 8 / 10 = 14.4 finney
585         //   D) I boost attack with 3 tiles of 1, 5 and 10 finney respectively
586         //      -> Total boost is (ss1+5+10) * 3 / 10 = 4.8 finney
587         // This division by 10 can't create fractions since our uint is wei, and we can't have overflow from the multiplication
588         // We do allow fractions of finney here since the boosted values aren't stored anywhere, only used for attack rolls and sent in events
589         boost.attackBoost = (boost.attackBoost / 10 * boost.numAttackBoosts);
590         boost.defendBoost = (boost.defendBoost / 10 * boost.numDefendBoosts);
591 
592         return (boost.attackBoost, boost.defendBoost);
593     }
594     
595     function censorUser(address _userAddress, bool _censored) public isValidCaller {
596         User storage user = users[_userAddress];
597         require(user.creationTime != 0);
598         user.censored = _censored;
599     }
600     
601     function deleteTile(uint16 _tileId) public isValidCaller {
602         delete tiles[_tileId];
603     }
604     
605     function setSellPrice(uint16 _tileId, uint _sellPrice) public isValidCaller {
606         tiles[_tileId].sellPrice = _sellPrice;  //testrpc cannot estimate gas when delete is used.
607     }
608 
609     function deleteOffer(uint16 _tileId) public isValidCaller {
610         tiles[_tileId].sellPrice = 0;  //testrpc cannot estimate gas when delete is used.
611     }
612 }
613 
614 /**
615  * Copyright 2018 Block Wars Team
616  *
617  */
618 
619 contract BW { 
620     address public owner;
621     BWService private bwService;
622     BWData private bwData;
623     bool public paused = false;
624     
625     modifier isOwner {
626         if (msg.sender != owner) {
627             revert();
628         }
629         _;
630     }
631 
632     // Checks if entire game (except battle value withdraw) is paused or not.
633     modifier isNotPaused {
634         if (paused) {
635             revert();
636         }
637         _;
638     }
639 
640     // Only allow wallets to call this function, not contracts.
641     modifier isNotContractCaller {
642         require(msg.sender == tx.origin);
643         _;
644     }
645 
646     // All contract event types.
647     event UserCreated(address userAddress, bytes32 name, bytes imageUrl, bytes32 tag, bytes32 homeUrl, uint creationTime, address invitedBy);
648     event UserCensored(address userAddress, bool isCensored);
649     event TransferTileFromOwner(uint16 tileId, address seller, address buyer, uint acceptTime); // Sent when a user buys a tile from another user, by accepting a tile offer
650     event UserUpdated(address userAddress, bytes32 name, bytes imageUrl, bytes32 tag, bytes32 homeUrl, uint updateTime);    
651 
652     // BASIC CONTRACT FUNCTIONS
653     // Constructor.
654     constructor(address _bwService, address _bwData) public {
655         bwService = BWService(_bwService);
656         bwData = BWData(_bwData);
657         owner = msg.sender;
658     }
659 
660     // Can't send funds straight to this contract. Avoid people sending by mistake.
661     function () payable public {
662         revert();
663     }
664 
665     // Allow a new user to claim one or more previously unclaimed tiles by paying Ether.
666     function claimTilesForNewUser(bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl, uint16[] _claimedTileIds, address _invitedBy) payable public isNotPaused isNotContractCaller {
667         bwData.addUser(msg.sender);
668         emit UserCreated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp, _invitedBy);
669         bwService.storeInitialClaim(msg.sender, _claimedTileIds, msg.value, false);
670     }
671 
672     // Allow an existing user to claim one or more previously unclaimed tiles by paying Ether.
673     function claimTilesForExistingUser(uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) payable public isNotPaused isNotContractCaller {
674         bwData.verifyAmount(msg.sender, msg.value, _claimAmount, _useBattleValue);
675         bwService.storeInitialClaim(msg.sender, _claimedTileIds, _claimAmount, _useBattleValue);
676     }
677 
678     // Allow users to change name, image URL, tag and home URL. Not censored status or battle value though.
679     function updateUser(bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl) public isNotPaused isNotContractCaller {
680         require(bwData.hasUser(msg.sender));
681         // All the updated values are stored in events only so there's no state to update on the contract here.
682         emit UserUpdated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp);
683     }
684     
685     // This function fortifies multiple previously claimed tiles in a single transaction.
686     // The value assigned to each tile is the msg.value divided by the number of tiles fortified.
687     // The msg.value is required to be an even multiple of the number of tiles fortified.
688     // Only tiles owned by msg.sender can be fortified.
689     function fortifyClaims(uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) payable public isNotPaused isNotContractCaller {
690         bwData.verifyAmount(msg.sender, msg.value, _fortifyAmount, _useBattleValue);
691         bwService.fortifyClaims(msg.sender, _claimedTileIds, _fortifyAmount, _useBattleValue);
692     }
693 
694     // A new user attacks a tile claimed by someone else, trying to make it theirs through battle.
695     function attackTileForNewUser(uint16 _tileId, bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl, address _invitedBy) payable public isNotPaused isNotContractCaller {
696         bwData.addUser(msg.sender);
697         emit UserCreated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp, _invitedBy);
698         bwService.attackTile(msg.sender, _tileId, msg.value, false, false);
699     }
700 
701         // An existing user attacks a tile claimed by someone else, trying to make it theirs through battle.
702     function attackTileForExistingUser(uint16 _tileId, uint _attackAmount, bool _useBattleValue, bool _autoFortify) payable public isNotPaused isNotContractCaller {
703         bwData.verifyAmount(msg.sender, msg.value, _attackAmount, _useBattleValue);
704         bwService.attackTile(msg.sender, _tileId, _attackAmount, _useBattleValue, _autoFortify);
705     }
706     
707     // Move "army" = block value from one block to an adjacent block. Moving ALL value equates giving up ownership of the source tile.
708     function moveBlockValue(uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isNotPaused isNotContractCaller {
709         bwService.moveBlockValue(msg.sender, _xSource, _ySource, _xDest, _yDest, _moveAmount);
710     }
711 
712     // Allow users to withdraw battle value in Ether.
713     function withdrawBattleValue(uint _battleValueInWei) public isNotContractCaller {
714         uint amountToWithdraw = bwService.withdrawBattleValue(msg.sender, _battleValueInWei);
715         msg.sender.transfer(amountToWithdraw);
716     }
717 
718     // -------- OWNER-ONLY FUNCTIONS ----------
719 
720 
721     // Only used by owner for raffle. Owner need name, address and picture from user.
722     // These users can then be given tiles by owner using transferTileFromOwner.
723     function createNewUser(bytes32 _name, bytes _imageUrl, address _user) public isOwner {
724         bwData.addUser(_user);
725         emit UserCreated(msg.sender, _name, _imageUrl, 0x0, 0x0, block.timestamp, 0x0);
726     }
727 
728     // Allow updating censored status. Owner only. In case someone uploads offensive content.
729     // The contract owners reserve the right to apply censorship. This will mean that the
730     // name, tag or URL images might not be displayed for a censored user.
731     function censorUser(address _userAddress, bool _censored) public isOwner {
732         bwData.censorUser(_userAddress, _censored);
733         emit UserCensored(_userAddress, _censored);
734     }
735 
736     // Pause the entire game, but let users keep withdrawing battle value
737     function setPaused(bool _paused) public isOwner {
738         paused = _paused;
739     }
740 
741     function kill() public isOwner {
742         selfdestruct(owner);
743     }
744     
745     function withdrawValue(bool _isFee) public isOwner {
746         uint balance = address(this).balance;
747         uint amountToWithdraw;
748         
749         if (_isFee) {
750             amountToWithdraw = bwData.getFeeBalance();
751 
752             if (balance < amountToWithdraw) { // Should never happen, but paranoia
753                 amountToWithdraw = balance;
754             }
755             bwData.setFeeBalance(0);
756         } else {
757             amountToWithdraw = bwData.getBlockValueBalance();
758 
759             if (balance < amountToWithdraw) { // Should never happen, but paranoia
760                 amountToWithdraw = balance;
761             }
762             bwData.setBlockValueBalance(0);
763         }
764 
765         owner.transfer(amountToWithdraw);
766     }
767 
768     function depositBattleValue(address _user) payable public isOwner {
769         require(bwData.hasUser(_user));
770         require(msg.value % 1 finney == 0); // Must be divisible by 1 finney
771         bwService.addUserBattleValue(_user, msg.value);
772     }
773 
774     // The owner can transfer ownership of own tiles to other users, as prizes in competitions.
775     function transferTileFromOwner(uint16 _tileId, address _newOwner) public payable isOwner {
776         address claimer = bwData.getCurrentClaimerForTile(_tileId);
777         require(claimer == owner);
778         require(bwData.hasUser(_newOwner));
779         require(msg.value % 1 finney == 0); // Must be divisible by 1 finney
780         uint balance = address(this).balance;
781         require(balance + msg.value >= balance); // prevent overflow
782         bwData.setClaimerForTile(_tileId, _newOwner);
783         bwService.addUserBattleValue(_newOwner, msg.value);
784         
785         emit TransferTileFromOwner(_tileId, claimer, msg.sender, block.timestamp);
786     }
787 
788     // Allow us to transfer out airdropped tokens if we ever receive any
789     function transferTokens(address _tokenAddress, address _recipient) public isOwner {
790         ERC20I token = ERC20I(_tokenAddress);
791         require(token.transfer(_recipient, token.balanceOf(this)));
792     }
793 }