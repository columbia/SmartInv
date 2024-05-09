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
48 
49 
50 
51 
52 interface ERC20I {
53     function transfer(address _recipient, uint256 _amount) external returns (bool);
54     function balanceOf(address _holder) external view returns (uint256);
55 }
56 
57 
58 contract BWService {
59     using SafeMath for uint256;
60     address private owner;
61     address private bw;
62     address private bwMarket;
63     BWData private bwData;
64     uint private seed = 42;
65     uint private WITHDRAW_FEE = 5; // 5%
66     uint private ATTACK_FEE = 5; // 5%
67     uint private ATTACK_BOOST_CAP = 300; // 300%
68     uint private DEFEND_BOOST_CAP = 300; // 300%
69     uint private ATTACK_BOOST_MULTIPLIER = 100; // 100%
70     uint private DEFEND_BOOST_MULTIPLIER = 100; // 100%
71     mapping (uint16 => address) private localGames;
72     
73     modifier isOwner {
74         if (msg.sender != owner) {
75             revert();
76         }
77         _;
78     }  
79 
80     modifier isValidCaller {
81         if (msg.sender != bw && msg.sender != bwMarket) {
82             revert();
83         }
84         _;
85     }
86 
87     event TileClaimed(uint16 tileId, address newClaimer, uint priceInWei, uint creationTime);
88     event TileFortified(uint16 tileId, address claimer, uint addedValueInWei, uint priceInWei, uint fortifyTime); // Sent when a user fortifies an existing claim by bumping its value.
89     event TileAttackedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint attackTime); // Sent when a user successfully attacks a tile.    
90     event TileDefendedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint defendTime); // Sent when a user successfully defends a tile when attacked.    
91     event BlockValueMoved(uint16 sourceTileId, uint16 destTileId, address owner, uint movedBlockValue, uint postSourceValue, uint postDestValue, uint moveTime); // Sent when a user buys a tile from another user, by accepting a tile offer
92     event UserBattleValueUpdated(address userAddress, uint battleValue, bool isWithdraw);
93 
94     // Constructor.
95     constructor(address _bwData) public {
96         bwData = BWData(_bwData);
97         owner = msg.sender;
98     }
99 
100     // Can't send funds straight to this contract. Avoid people sending by mistake.
101     function () payable public {
102         revert();
103     }
104 
105     // OWNER-ONLY FUNCTIONS
106     function kill() public isOwner {
107         selfdestruct(owner);
108     }
109 
110     function setValidBwCaller(address _bw) public isOwner {
111         bw = _bw;
112     }
113     
114     function setValidBwMarketCaller(address _bwMarket) public isOwner {
115         bwMarket = _bwMarket;
116     }
117 
118     function setWithdrawFee(uint _feePercentage) public isOwner {
119         WITHDRAW_FEE = _feePercentage;
120     }
121 
122     function setAttackFee(uint _feePercentage) public isOwner {
123         ATTACK_FEE = _feePercentage;
124     }
125 
126     function setAttackBoostMultipler(uint _multiplierPercentage) public isOwner {
127         ATTACK_BOOST_MULTIPLIER = _multiplierPercentage;
128     }
129 
130     function setDefendBoostMultiplier(uint _multiplierPercentage) public isOwner {
131         DEFEND_BOOST_MULTIPLIER = _multiplierPercentage;
132     }
133 
134     function setAttackBoostCap(uint _capPercentage) public isOwner {
135         ATTACK_BOOST_CAP = _capPercentage;
136     }
137 
138     function setDefendBoostCap(uint _capPercentage) public isOwner {
139         DEFEND_BOOST_CAP = _capPercentage;
140     }
141 
142     // TILE-RELATED FUNCTIONS
143     // This function claims multiple previously unclaimed tiles in a single transaction.
144     // The value assigned to each tile is the msg.value divided by the number of tiles claimed.
145     // The msg.value is required to be an even multiple of the number of tiles claimed.
146     function storeInitialClaim(address _msgSender, uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) public isValidCaller {
147         uint tileCount = _claimedTileIds.length;
148         require(tileCount > 0);
149         require(_claimAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
150         require(_claimAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles claimed
151 
152         uint valuePerBlockInWei = _claimAmount.div(tileCount); // Due to requires above this is guaranteed to be an even number
153         require(valuePerBlockInWei >= 5 finney);
154 
155         if (_useBattleValue) {
156             subUserBattleValue(_msgSender, _claimAmount, false);  
157         }
158 
159         addGlobalBlockValueBalance(_claimAmount);
160 
161         uint16 tileId;
162         bool isNewTile;
163         for (uint16 i = 0; i < tileCount; i++) {
164             tileId = _claimedTileIds[i];
165             isNewTile = bwData.isNewTile(tileId); // Is length 0 if first time purchased
166             require(isNewTile); // Can only claim previously unclaimed tiles.
167 
168             // Send claim event
169             emit TileClaimed(tileId, _msgSender, valuePerBlockInWei, block.timestamp);
170 
171             // Update contract state with new tile ownership.
172             bwData.storeClaim(tileId, _msgSender, valuePerBlockInWei);
173         }
174     }
175 
176     function fortifyClaims(address _msgSender, uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) public isValidCaller {
177         uint tileCount = _claimedTileIds.length;
178         require(tileCount > 0);
179 
180         address(this).balance.add(_fortifyAmount); // prevent overflow with SafeMath
181         require(_fortifyAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles fortified
182         uint addedValuePerTileInWei = _fortifyAmount.div(tileCount); // Due to requires above this is guaranteed to be an even number
183         require(_fortifyAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
184 
185         address claimer;
186         uint blockValue;
187         for (uint16 i = 0; i < tileCount; i++) {
188             (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_claimedTileIds[i]);
189             require(claimer != 0); // Can't do this on never-owned tiles
190             require(claimer == _msgSender); // Only current claimer can fortify claim
191 
192             if (_useBattleValue) {
193                 subUserBattleValue(_msgSender, addedValuePerTileInWei, false);
194             }
195             
196             fortifyClaim(_msgSender, _claimedTileIds[i], addedValuePerTileInWei);
197         }
198     }
199 
200     function fortifyClaim(address _msgSender, uint16 _claimedTileId, uint _fortifyAmount) private {
201         uint blockValue;
202         uint sellPrice;
203         (blockValue, sellPrice) = bwData.getCurrentBlockValueAndSellPriceForTile(_claimedTileId);
204         uint updatedBlockValue = blockValue.add(_fortifyAmount);
205         // Send fortify event
206         emit TileFortified(_claimedTileId, _msgSender, _fortifyAmount, updatedBlockValue, block.timestamp);
207         
208         // Update tile value. The tile has been fortified by bumping up its value.
209         bwData.updateTileBlockValue(_claimedTileId, updatedBlockValue);
210 
211         // Track addition to global block value
212         addGlobalBlockValueBalance(_fortifyAmount);
213     }
214 
215     // Return a pseudo random number between lower and upper bounds
216     // given the number of previous blocks it should hash.
217     // Random function copied from https://github.com/axiomzen/eth-random/blob/master/contracts/Random.sol.
218     // Changed sha3 to keccak256, then modified.
219     // Changed random range from uint64 to uint (=uint256).
220     function random(uint _upper) private returns (uint)  {
221         seed = uint(keccak256(blockhash(block.number - 1), block.coinbase, block.timestamp, seed, address(0x3f5CE5FBFe3E9af3971dD833D26bA9b5C936f0bE).balance));
222         return seed % _upper;
223     }
224 
225     // A user tries to claim a tile that's already owned by another user. A battle ensues.
226     // A random roll is done with % based on attacking vs defending amounts.
227     function attackTile(address _msgSender, uint16 _tileId, uint _attackAmount, bool _useBattleValue) public isValidCaller {
228         require(_attackAmount >= 1 finney);         // Don't allow attacking with less than one base tile price.
229         require(_attackAmount % 1 finney == 0);
230 
231         address claimer;
232         uint blockValue;
233         (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_tileId);
234         
235         require(claimer != 0); // Can't do this on never-owned tiles
236         require(claimer != _msgSender); // Can't attack one's own tiles
237         require(claimer != owner); // Can't attack owner's tiles because it is used for raffle.
238 
239         // Calculate boosted amounts for attacker and defender
240         // The base attack amount is sent in the by the user.
241         // The base defend amount is the attacked tile's current blockValue.
242         uint attackBoost;
243         uint defendBoost;
244         (attackBoost, defendBoost) = bwData.calculateBattleBoost(_tileId, _msgSender, claimer);
245 
246         // Adjust boost to optimize game strategy
247         attackBoost = attackBoost.mul(ATTACK_BOOST_MULTIPLIER).div(100);
248         defendBoost = defendBoost.mul(DEFEND_BOOST_MULTIPLIER).div(100);
249         
250         // Cap the boost to minimize its impact (prevents whales somehow)
251         if (attackBoost > _attackAmount.mul(ATTACK_BOOST_CAP).div(100)) {
252             attackBoost = _attackAmount.mul(ATTACK_BOOST_CAP).div(100);
253         }
254         if (defendBoost > blockValue.mul(DEFEND_BOOST_CAP).div(100)) {
255             defendBoost = blockValue.mul(DEFEND_BOOST_CAP).div(100);
256         }
257 
258         uint totalAttackAmount = _attackAmount.add(attackBoost);
259         uint totalDefendAmount = blockValue.add(defendBoost);
260 
261         // Verify that attack odds are within allowed range.
262         require(totalAttackAmount.div(10) <= totalDefendAmount); // Disallow attacks with more than 1000% of defendAmount
263         require(totalAttackAmount >= totalDefendAmount.div(10)); // Disallow attacks with less than 10% of defendAmount
264 
265         uint attackFeeAmount = _attackAmount.mul(ATTACK_FEE).div(100);
266         uint attackAmountAfterFee = _attackAmount.sub(attackFeeAmount);
267         
268         updateFeeBalance(attackFeeAmount);
269 
270         // The battle considers boosts.
271         uint attackRoll = random(totalAttackAmount.add(totalDefendAmount)); // This is where the excitement happens!
272 
273         //gas cost of attack branch is higher than denfense branch solving MSB1
274         if (attackRoll > totalDefendAmount) {
275             // Change block owner but keep same block value (attacker got battlevalue instead)
276             bwData.setClaimerForTile(_tileId, _msgSender);
277 
278             // Tile successfully attacked!
279             if (_useBattleValue) {
280                 // Withdraw followed by deposit of same amount to prevent MSB1
281                 addUserBattleValue(_msgSender, attackAmountAfterFee); // Don't include boost here!
282                 subUserBattleValue(_msgSender, attackAmountAfterFee, false);
283             } else {
284                 addUserBattleValue(_msgSender, attackAmountAfterFee); // Don't include boost here!
285             }
286             addUserBattleValue(claimer, 0);
287 
288             bwData.updateTileTimeStamp(_tileId);
289             // Send update event
290             emit TileAttackedSuccessfully(_tileId, _msgSender, attackAmountAfterFee, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
291         } else {
292             bwData.setClaimerForTile(_tileId, claimer); //should be old owner
293             // Tile successfully defended!
294             if (_useBattleValue) {
295                 subUserBattleValue(_msgSender, attackAmountAfterFee, false); // Don't include boost here!
296             }
297             addUserBattleValue(claimer, attackAmountAfterFee); // Don't include boost here!
298             
299             // Send update event
300             emit TileDefendedSuccessfully(_tileId, _msgSender, attackAmountAfterFee, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
301         }
302     }
303 
304     function updateFeeBalance(uint attackFeeAmount) private {
305         uint feeBalance = bwData.getFeeBalance();
306         feeBalance = feeBalance.add(attackFeeAmount);
307         bwData.setFeeBalance(feeBalance);
308     }
309 
310     function moveBlockValue(address _msgSender, uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isValidCaller {
311         uint16 sourceTileId = BWUtility.toTileId(_xSource, _ySource);
312         uint16 destTileId = BWUtility.toTileId(_xDest, _yDest);
313 
314         address sourceTileClaimer;
315         address destTileClaimer;
316         uint sourceTileBlockValue;
317         uint destTileBlockValue;
318         (sourceTileClaimer, sourceTileBlockValue) = bwData.getTileClaimerAndBlockValue(sourceTileId);
319         (destTileClaimer, destTileBlockValue) = bwData.getTileClaimerAndBlockValue(destTileId);
320 
321         uint newBlockValue = sourceTileBlockValue.sub(_moveAmount);
322         // Must transfer the entire block value or leave at least 5
323         require(newBlockValue == 0 || newBlockValue >= 5 finney);
324 
325         require(sourceTileClaimer == _msgSender);
326         require(destTileClaimer == _msgSender);
327         require(_moveAmount >= 1 finney); // Can't be less
328         require(_moveAmount % 1 finney == 0); // Move amount must be in multiples of 1 finney
329         // require(sourceTile.blockValue - _moveAmount >= BASE_TILE_PRICE_WEI); // Must always leave some at source
330         
331         require(BWUtility.isAdjacent(_xSource, _ySource, _xDest, _yDest));
332 
333         sourceTileBlockValue = sourceTileBlockValue.sub(_moveAmount);
334         destTileBlockValue = destTileBlockValue.add(_moveAmount);
335 
336         // If ALL block value was moved away from the source tile, we lose our claim to it. It becomes ownerless.
337         if (sourceTileBlockValue == 0) {
338             bwData.deleteTile(sourceTileId);
339         } else {
340             bwData.updateTileBlockValue(sourceTileId, sourceTileBlockValue);
341             bwData.deleteOffer(sourceTileId); // Offer invalid since block value has changed
342         }
343 
344         bwData.updateTileBlockValue(destTileId, destTileBlockValue);
345         bwData.deleteOffer(destTileId);   // Offer invalid since block value has changed
346         emit BlockValueMoved(sourceTileId, destTileId, _msgSender, _moveAmount, sourceTileBlockValue, destTileBlockValue, block.timestamp);        
347     }
348 
349     function verifyAmount(address _msgSender, uint _msgValue, uint _amount, bool _useBattleValue) view public isValidCaller {
350         if (_useBattleValue) {
351             require(_msgValue == 0);
352             require(bwData.getUserBattleValue(_msgSender) >= _amount);
353         } else {
354             require(_amount == _msgValue);
355         }
356     }
357 
358     function setLocalGame(uint16 _tileId, address localGameAddress) public isOwner {
359         localGames[_tileId] = localGameAddress;
360     }
361 
362     function getLocalGame(uint16 _tileId) view public isValidCaller returns (address) {
363         return localGames[_tileId];
364     }
365 
366     // BATTLE VALUE FUNCTIONS
367     function withdrawBattleValue(address msgSender, uint _battleValueInWei) public isValidCaller returns (uint) {
368         //require(_battleValueInWei % 1 finney == 0); // Must be divisible by 1 finney
369         uint fee = _battleValueInWei.mul(WITHDRAW_FEE).div(100); // Since we divide by 20 we can never create infinite fractions, so we'll always count in whole wei amounts.
370         uint amountToWithdraw = _battleValueInWei.sub(fee);
371         uint feeBalance = bwData.getFeeBalance();
372         feeBalance = feeBalance.add(fee);
373         bwData.setFeeBalance(feeBalance);
374         subUserBattleValue(msgSender, _battleValueInWei, true);
375         return amountToWithdraw;
376     }
377 
378     function addUserBattleValue(address _userId, uint _amount) public isValidCaller {
379         uint userBattleValue = bwData.getUserBattleValue(_userId);
380         uint newBattleValue = userBattleValue.add(_amount);
381         bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
382         emit UserBattleValueUpdated(_userId, newBattleValue, false);
383     }
384     
385     function subUserBattleValue(address _userId, uint _amount, bool _isWithdraw) public isValidCaller {
386         uint userBattleValue = bwData.getUserBattleValue(_userId);
387         require(_amount <= userBattleValue); // Must be less than user's battle value - also implicitly checks that underflow isn't possible
388         uint newBattleValue = userBattleValue.sub(_amount);
389         bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
390         emit UserBattleValueUpdated(_userId, newBattleValue, _isWithdraw);
391     }
392 
393     function addGlobalBlockValueBalance(uint _amount) public isValidCaller {
394         // Track addition to global block value.
395         uint blockValueBalance = bwData.getBlockValueBalance();
396         bwData.setBlockValueBalance(blockValueBalance.add(_amount));
397     }
398 
399     function subGlobalBlockValueBalance(uint _amount) public isValidCaller {
400         // Track addition to global block value.
401         uint blockValueBalance = bwData.getBlockValueBalance();
402         bwData.setBlockValueBalance(blockValueBalance.sub(_amount));
403     }
404 
405     // Allow us to transfer out airdropped tokens if we ever receive any
406     function transferTokens(address _tokenAddress, address _recipient) public isOwner {
407         ERC20I token = ERC20I(_tokenAddress);
408         require(token.transfer(_recipient, token.balanceOf(this)));
409     }
410 }
411 
412 
413 
414 
415 
416 contract BWData {
417     address public owner;
418     address private bwService;
419     address private bw;
420     address private bwMarket;
421 
422     uint private blockValueBalance = 0;
423     uint private feeBalance = 0;
424     uint private BASE_TILE_PRICE_WEI = 1 finney; // 1 milli-ETH.
425     
426     mapping (address => User) private users; // user address -> user information
427     mapping (uint16 => Tile) private tiles; // tileId -> list of TileClaims for that particular tile
428     
429     // Info about the users = those who have purchased tiles.
430     struct User {
431         uint creationTime;
432         bool censored;
433         uint battleValue;
434     }
435 
436     // Info about a tile ownership
437     struct Tile {
438         address claimer;
439         uint blockValue;
440         uint creationTime;
441         uint sellPrice;    // If 0 -> not on marketplace. If > 0 -> on marketplace.
442     }
443 
444     struct Boost {
445         uint8 numAttackBoosts;
446         uint8 numDefendBoosts;
447         uint attackBoost;
448         uint defendBoost;
449     }
450 
451     constructor() public {
452         owner = msg.sender;
453     }
454 
455     // Can't send funds straight to this contract. Avoid people sending by mistake.
456     function () payable public {
457         revert();
458     }
459 
460     function kill() public isOwner {
461         selfdestruct(owner);
462     }
463 
464     modifier isValidCaller {
465         if (msg.sender != bwService && msg.sender != bw && msg.sender != bwMarket) {
466             revert();
467         }
468         _;
469     }
470     
471     modifier isOwner {
472         if (msg.sender != owner) {
473             revert();
474         }
475         _;
476     }
477     
478     function setBwServiceValidCaller(address _bwService) public isOwner {
479         bwService = _bwService;
480     }
481 
482     function setBwValidCaller(address _bw) public isOwner {
483         bw = _bw;
484     }
485 
486     function setBwMarketValidCaller(address _bwMarket) public isOwner {
487         bwMarket = _bwMarket;
488     }    
489     
490     // ----------USER-RELATED GETTER FUNCTIONS------------
491     
492     //function getUser(address _user) view public returns (bytes32) {
493         //BWUtility.User memory user = users[_user];
494         //require(user.creationTime != 0);
495         //return (user.creationTime, user.imageUrl, user.tag, user.email, user.homeUrl, user.creationTime, user.censored, user.battleValue);
496     //}
497     
498     function addUser(address _msgSender) public isValidCaller {
499         User storage user = users[_msgSender];
500         require(user.creationTime == 0);
501         user.creationTime = block.timestamp;
502     }
503 
504     function hasUser(address _user) view public isValidCaller returns (bool) {
505         return users[_user].creationTime != 0;
506     }
507     
508 
509     // ----------TILE-RELATED GETTER FUNCTIONS------------
510 
511     function getTile(uint16 _tileId) view public isValidCaller returns (address, uint, uint, uint) {
512         Tile storage currentTile = tiles[_tileId];
513         return (currentTile.claimer, currentTile.blockValue, currentTile.creationTime, currentTile.sellPrice);
514     }
515     
516     function getTileClaimerAndBlockValue(uint16 _tileId) view public isValidCaller returns (address, uint) {
517         Tile storage currentTile = tiles[_tileId];
518         return (currentTile.claimer, currentTile.blockValue);
519     }
520     
521     function isNewTile(uint16 _tileId) view public isValidCaller returns (bool) {
522         Tile storage currentTile = tiles[_tileId];
523         return currentTile.creationTime == 0;
524     }
525     
526     function storeClaim(uint16 _tileId, address _claimer, uint _blockValue) public isValidCaller {
527         tiles[_tileId] = Tile(_claimer, _blockValue, block.timestamp, 0);
528     }
529 
530     function updateTileBlockValue(uint16 _tileId, uint _blockValue) public isValidCaller {
531         tiles[_tileId].blockValue = _blockValue;
532     }
533 
534     function setClaimerForTile(uint16 _tileId, address _claimer) public isValidCaller {
535         tiles[_tileId].claimer = _claimer;
536     }
537 
538     function updateTileTimeStamp(uint16 _tileId) public isValidCaller {
539         tiles[_tileId].creationTime = block.timestamp;
540     }
541     
542     function getCurrentClaimerForTile(uint16 _tileId) view public isValidCaller returns (address) {
543         Tile storage currentTile = tiles[_tileId];
544         if (currentTile.creationTime == 0) {
545             return 0;
546         }
547         return currentTile.claimer;
548     }
549 
550     function getCurrentBlockValueAndSellPriceForTile(uint16 _tileId) view public isValidCaller returns (uint, uint) {
551         Tile storage currentTile = tiles[_tileId];
552         if (currentTile.creationTime == 0) {
553             return (0, 0);
554         }
555         return (currentTile.blockValue, currentTile.sellPrice);
556     }
557     
558     function getBlockValueBalance() view public isValidCaller returns (uint){
559         return blockValueBalance;
560     }
561 
562     function setBlockValueBalance(uint _blockValueBalance) public isValidCaller {
563         blockValueBalance = _blockValueBalance;
564     }
565 
566     function getFeeBalance() view public isValidCaller returns (uint) {
567         return feeBalance;
568     }
569 
570     function setFeeBalance(uint _feeBalance) public isValidCaller {
571         feeBalance = _feeBalance;
572     }
573     
574     function getUserBattleValue(address _userId) view public isValidCaller returns (uint) {
575         return users[_userId].battleValue;
576     }
577     
578     function setUserBattleValue(address _userId, uint _battleValue) public  isValidCaller {
579         users[_userId].battleValue = _battleValue;
580     }
581     
582     function verifyAmount(address _msgSender, uint _msgValue, uint _amount, bool _useBattleValue) view public isValidCaller {
583         User storage user = users[_msgSender];
584         require(user.creationTime != 0);
585 
586         if (_useBattleValue) {
587             require(_msgValue == 0);
588             require(user.battleValue >= _amount);
589         } else {
590             require(_amount == _msgValue);
591         }
592     }
593     
594     function addBoostFromTile(Tile _tile, address _attacker, address _defender, Boost memory _boost) pure private {
595         if (_tile.claimer == _attacker) {
596             require(_boost.attackBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
597             _boost.attackBoost += _tile.blockValue;
598             _boost.numAttackBoosts += 1;
599         } else if (_tile.claimer == _defender) {
600             require(_boost.defendBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
601             _boost.defendBoost += _tile.blockValue;
602             _boost.numDefendBoosts += 1;
603         }
604     }
605 
606     function calculateBattleBoost(uint16 _tileId, address _attacker, address _defender) view public isValidCaller returns (uint, uint) {
607         uint8 x;
608         uint8 y;
609 
610         (x, y) = BWUtility.fromTileId(_tileId);
611 
612         Boost memory boost = Boost(0, 0, 0, 0);
613         // We overflow x, y on purpose here if x or y is 0 or 255 - the map overflows and so should adjacency.
614         // Go through all adjacent tiles to (x, y).
615         if (y != 255) {
616             if (x != 255) {
617                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y+1)], _attacker, _defender, boost);
618             }
619             
620             addBoostFromTile(tiles[BWUtility.toTileId(x, y+1)], _attacker, _defender, boost);
621 
622             if (x != 0) {
623                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y+1)], _attacker, _defender, boost);
624             }
625         }
626 
627         if (x != 255) {
628             addBoostFromTile(tiles[BWUtility.toTileId(x+1, y)], _attacker, _defender, boost);
629         }
630 
631         if (x != 0) {
632             addBoostFromTile(tiles[BWUtility.toTileId(x-1, y)], _attacker, _defender, boost);
633         }
634 
635         if (y != 0) {
636             if(x != 255) {
637                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y-1)], _attacker, _defender, boost);
638             }
639 
640             addBoostFromTile(tiles[BWUtility.toTileId(x, y-1)], _attacker, _defender, boost);
641 
642             if(x != 0) {
643                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y-1)], _attacker, _defender, boost);
644             }
645         }
646         // The benefit of boosts is multiplicative (quadratic):
647         // - More boost tiles gives a higher total blockValue (the sum of the adjacent tiles)
648         // - More boost tiles give a higher multiple of that total blockValue that can be used (10% per adjacent tie)
649         // Example:
650         //   A) I boost attack with 1 single tile worth 10 finney
651         //      -> Total boost is 10 * 1 / 10 = 1 finney
652         //   B) I boost attack with 3 tiles worth 1 finney each
653         //      -> Total boost is (1+1+1) * 3 / 10 = 0.9 finney
654         //   C) I boost attack with 8 tiles worth 2 finney each
655         //      -> Total boost is (2+2+2+2+2+2+2+2) * 8 / 10 = 14.4 finney
656         //   D) I boost attack with 3 tiles of 1, 5 and 10 finney respectively
657         //      -> Total boost is (ss1+5+10) * 3 / 10 = 4.8 finney
658         // This division by 10 can't create fractions since our uint is wei, and we can't have overflow from the multiplication
659         // We do allow fractions of finney here since the boosted values aren't stored anywhere, only used for attack rolls and sent in events
660         boost.attackBoost = (boost.attackBoost / 10 * boost.numAttackBoosts);
661         boost.defendBoost = (boost.defendBoost / 10 * boost.numDefendBoosts);
662 
663         return (boost.attackBoost, boost.defendBoost);
664     }
665     
666     function censorUser(address _userAddress, bool _censored) public isValidCaller {
667         User storage user = users[_userAddress];
668         require(user.creationTime != 0);
669         user.censored = _censored;
670     }
671     
672     function deleteTile(uint16 _tileId) public isValidCaller {
673         delete tiles[_tileId];
674     }
675     
676     function setSellPrice(uint16 _tileId, uint _sellPrice) public isValidCaller {
677         tiles[_tileId].sellPrice = _sellPrice;  //testrpc cannot estimate gas when delete is used.
678     }
679 
680     function deleteOffer(uint16 _tileId) public isValidCaller {
681         tiles[_tileId].sellPrice = 0;  //testrpc cannot estimate gas when delete is used.
682     }
683 }
684 
685 
686 
687 /**
688  * @title SafeMath
689  * @dev Math operations with safety checks that throw on error
690  */
691 library SafeMath {
692 
693   /**
694   * @dev Multiplies two numbers, throws on overflow.
695   */
696   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
697     if (a == 0) {
698       return 0;
699     }
700     c = a * b;
701     assert(c / a == b);
702     return c;
703   }
704 
705   /**
706   * @dev Integer division of two numbers, truncating the quotient.
707   */
708   function div(uint256 a, uint256 b) internal pure returns (uint256) {
709     // assert(b > 0); // Solidity automatically throws when dividing by 0
710     // uint256 c = a / b;
711     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
712     return a / b;
713   }
714 
715   /**
716   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
717   */
718   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
719     assert(b <= a);
720     return a - b;
721   }
722 
723   /**
724   * @dev Adds two numbers, throws on overflow.
725   */
726   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
727     c = a + b;
728     assert(c >= a);
729     return c;
730   }
731 }
732 
733 /**
734 * Copyright 2018 Block Wars Team
735 *
736 */
737 
738 interface LocalGameI {
739     function getBountyBalance() view external returns (uint);
740     function getTimeLeftToNextCollect(address _claimer, uint _latestClaimTime) view external returns (uint);
741     function collectBounty(address _msgSender, uint _latestClaimTime, uint _amount) external returns (uint);
742 }
743 
744 /*
745 * @title ERC721 interface
746 */
747 contract ERC721 {
748     /// @dev This emits when ownership of any NFT changes by any mechanism.
749     ///  This event emits when NFTs are created (`from` == 0) and destroyed
750     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
751     ///  may be created and assigned without emitting Transfer. At the time of
752     ///  any transfer, the approved address for that NFT (if any) is reset to none.
753     //event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
754 
755     /// @dev This emits when the approved address for an NFT is changed or
756     ///  reaffirmed. The zero address indicates there is no approved address.
757     ///  When a Transfer event emits, this also indicates that the approved
758     ///  address for that NFT (if any) is reset to none.
759     //event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
760 
761     /// @dev This emits when an operator is enabled or disabled for an owner.
762     ///  The operator can manage all NFTs of the owner.
763     //event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
764 
765     /// @notice Count all NFTs assigned to an owner
766     /// @dev NFTs assigned to the zero address are considered invalid, and this
767     ///  function throws for queries about the zero address.
768     /// @param _owner An address for whom to query the balance
769     /// @return The number of NFTs owned by `_owner`, possibly zero
770     function balanceOf(address _owner) external view returns (uint256);
771 
772     /// @notice Find the owner of an NFT
773     /// @param _tokenId The identifier for an NFT
774     /// @dev NFTs assigned to zero address are considered invalid, and queries
775     ///  about them do throw.
776     /// @return The address of the owner of the NFT
777     function ownerOf(uint256 _tokenId) external view returns (address);
778 
779     /// @notice Transfers the ownership of an NFT from one address to another address
780     /// @dev Throws unless `msg.sender` is the current owner, an authorized
781     ///  operator, or the approved address for this NFT. Throws if `_from` is
782     ///  not the current owner. Throws if `_to` is the zero address. Throws if
783     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
784     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
785     ///  `onERC721Received` on `_to` and throws if the return value is not
786     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
787     /// @param _from The current owner of the NFT
788     /// @param _to The new owner
789     /// @param _tokenId The NFT to transfer
790     /// @param data Additional data with no specified format, sent in call to `_to`
791     //function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
792 
793     /// @notice Transfers the ownership of an NFT from one address to another address
794     /// @dev This works identically to the other function with an extra data parameter,
795     ///  except this function just sets data to ""
796     /// @param _from The current owner of the NFT
797     /// @param _to The new owner
798     /// @param _tokenId The NFT to transfer
799     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
800 
801     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
802     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
803     ///  THEY MAY BE PERMANENTLY LOST
804     /// @dev Throws unless `msg.sender` is the current owner, an authorized
805     ///  operator, or the approved address for this NFT. Throws if `_from` is
806     ///  not the current owner. Throws if `_to` is the zero address. Throws if
807     ///  `_tokenId` is not a valid NFT.
808     /// @param _from The current owner of the NFT
809     /// @param _to The new owner
810     /// @param _tokenId The NFT to transfer
811     //function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
812 
813     /// @notice Set or reaffirm the approved address for an NFT
814     /// @dev The zero address indicates there is no approved address.
815     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
816     ///  operator of the current owner.
817     /// @param _approved The new approved NFT controller
818     /// @param _tokenId The NFT to approve
819     //function approve(address _approved, uint256 _tokenId) external payable;
820 
821     /// @notice Enable or disable approval for a third party ("operator") to manage
822     ///  all of `msg.sender`'s assets.
823     /// @dev Emits the ApprovalForAll event
824     /// @param _operator Address to add to the set of authorized operators.
825     /// @param _approved True if the operators is approved, false to revoke approval
826     //function setApprovalForAll(address _operator, bool _approved) external;
827 
828     /// @notice Get the approved address for a single NFT
829     /// @dev Throws if `_tokenId` is not a valid NFT
830     /// @param _tokenId The NFT to find the approved address for
831     /// @return The approved address for this NFT, or the zero address if there is none
832     //function getApproved(uint256 _tokenId) external view returns (address);
833 
834     /// @notice Query if an address is an authorized operator for another address
835     /// @param _owner The address that owns the NFTs
836     /// @param _operator The address that acts on behalf of the owner
837     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
838     //function isApprovedForAll(address _owner, address _operator) external view returns (bool);
839 
840     /// @notice Query if a contract implements an interface
841     /// @param interfaceID The interface identifier, as specified in ERC-165
842     /// @dev Interface identification is specified in ERC-165. This function
843     ///  uses less than 30,000 gas.
844     /// @return `true` if the contract implements `interfaceID` and
845     ///  `interfaceID` is not 0xffffffff, `false` otherwise
846     //function supportsInterface(bytes4 interfaceID) external view returns (bool);
847 }
848 
849 contract BW { 
850     using SafeMath for uint256;
851     address public owner;
852     BWService private bwService;
853     BWData private bwData;
854     bool public paused = false;
855     uint private BV_TO_BP_FEE = 5; // 5%
856     mapping (uint16 => Prize[]) private prizes; // Use mapping instead of array (key would be a unique priceId) - NO (we want to loop all prices)
857     
858     struct Prize {
859         address token; // BWT or CryptoKiities (ERC721)
860         uint tokenId; 
861         uint startTime; // To be able to add a price before the game starts
862         uint hodlPeriod; // Amount of seconds you have to own the tile before being able to claim this price. One block is ~15 sec.
863     }
864 
865     event PrizeCreated(uint16 tileId,  address token, uint tokenId, uint creationTime, uint startTime, uint hodlPeriod);
866     event PrizeRemoved(uint16 tileId, address token, uint tokenId, uint removeTime);
867     event PrizeClaimed(address token, uint tokenId);
868 
869     // Add price (only BW owner can do this)
870     function addPrize(uint16 _tileId, address _token, uint _tokenId, uint _startTime, uint _hodlPeriod) public isOwner {
871         //startTime must be same or after block.timestamp
872         uint startTime = _startTime;
873         if(startTime < block.timestamp) {
874             startTime = block.timestamp;
875         }
876         // we could check if token exists with ownerOf function in interface, 
877         // but if any erc721 token doesn't implement the function, this function would revert.
878         // also cheaper to not make an interface call
879         prizes[_tileId].push(Prize(_token, _tokenId, startTime, _hodlPeriod));
880         emit PrizeCreated(_tileId, _token, _tokenId, block.timestamp, startTime, _hodlPeriod);
881     }
882 
883     // Remove price (only BW owner can do this)
884     function removePrize(uint16 _tileId, address _token, uint _tokenId) public isOwner {
885         Prize[] storage prizeArr = prizes[_tileId];
886         require(prizeArr.length > 0);
887 
888         for(uint idx = 0; idx < prizeArr.length; ++idx) {
889             if(prizeArr[idx].tokenId == _tokenId && prizeArr[idx].token == _token) {
890                 delete prizeArr[idx];
891                 emit PrizeRemoved(_tileId, _token, _tokenId, block.timestamp);
892             }
893         }
894     }
895 
896     // Add price (only BW owner can do this)
897     function claimPrize(address _tokenAddress, uint16 _tileId) public isNotPaused isNotContractCaller {
898         ERC721 token = ERC721(_tokenAddress);
899         Prize[] storage prizeArr = prizes[_tileId];
900         require(prizeArr.length > 0);
901         address claimer;
902         uint blockValue;
903         uint lastClaimTime;
904         uint sellPrice;
905         (claimer, blockValue, lastClaimTime, sellPrice) = bwData.getTile(_tileId);
906         require(lastClaimTime != 0 && claimer == msg.sender);
907 
908         for(uint idx = 0; idx < prizeArr.length; ++idx) {
909             if(prizeArr[idx].startTime.add(prizeArr[idx].hodlPeriod) <= block.timestamp
910                 && lastClaimTime.add(prizeArr[idx].hodlPeriod) <= block.timestamp) {
911                 uint tokenId = prizeArr[idx].tokenId;
912                 address tokenOwner = token.ownerOf(tokenId);
913                 delete prizeArr[idx];
914                 token.safeTransferFrom(tokenOwner, msg.sender, tokenId); //Will revert if token does not exists
915                 emit PrizeClaimed(_tokenAddress, tokenId);
916             }
917         }
918     }
919 
920     modifier isOwner {
921         if (msg.sender != owner) {
922             revert();
923         }
924         _;
925     }
926 
927     // Checks if entire game (except battle value withdraw) is paused or not.
928     modifier isNotPaused {
929         if (paused) {
930             revert();
931         }
932         _;
933     }
934 
935     // Only allow wallets to call this function, not contracts.
936     modifier isNotContractCaller {
937         require(msg.sender == tx.origin);
938         _;
939     }
940 
941     // All contract event types.
942     event UserCreated(address userAddress, bytes32 name, bytes imageUrl, bytes32 tag, bytes32 homeUrl, uint creationTime, address invitedBy);
943     event UserCensored(address userAddress, bool isCensored);
944     event TransferTileFromOwner(uint16 tileId, address seller, address buyer, uint acceptTime); // Sent when a user buys a tile from another user, by accepting a tile offer
945     event UserUpdated(address userAddress, bytes32 name, bytes imageUrl, bytes32 tag, bytes32 homeUrl, uint updateTime);
946     event TileRetreated(uint16 tileId, address owner, uint amount, uint newBlockValue, uint retreatTime);
947     event BountyCollected(uint tile, address userAddress, uint amount, uint amountCollected, uint collectedTime, uint latestClaimTime);
948 
949     // BASIC CONTRACT FUNCTIONS
950     constructor(address _bwService, address _bwData) public {
951         bwService = BWService(_bwService);
952         bwData = BWData(_bwData);
953         owner = msg.sender;
954     }
955 
956     // Can't send funds straight to this contract. Avoid people sending by mistake.
957     function () payable public isOwner {
958 
959     }
960 
961     // Allow a new user to claim one or more previously unclaimed tiles by paying Ether.
962     function claimTilesForNewUser(bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl, uint16[] _claimedTileIds, address _invitedBy) payable public isNotPaused isNotContractCaller {
963         bwData.addUser(msg.sender);
964         emit UserCreated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp, _invitedBy);
965         bwService.storeInitialClaim(msg.sender, _claimedTileIds, msg.value, false);
966     }
967 
968     // Allow an existing user to claim one or more previously unclaimed tiles by paying Ether.
969     function claimTilesForExistingUser(uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) payable public isNotPaused isNotContractCaller {
970         bwService.verifyAmount(msg.sender, msg.value, _claimAmount, _useBattleValue);
971         bwService.storeInitialClaim(msg.sender, _claimedTileIds, _claimAmount, _useBattleValue);
972     }
973 
974     // Allow users to change name, image URL, tag and home URL. Not censored status or battle value though.
975     function updateUser(bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl) public isNotPaused isNotContractCaller {
976         require(bwData.hasUser(msg.sender));
977         // All the updated values are stored in events only so there's no state to update on the contract here.
978         emit UserUpdated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp);
979     }
980     
981     // This function fortifies multiple previously claimed tiles in a single transaction.
982     // The value assigned to each tile is the msg.value divided by the number of tiles fortified.
983     // The msg.value is required to be an even multiple of the number of tiles fortified.
984     // Only tiles owned by msg.sender can be fortified.
985     function fortifyClaims(uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) payable public isNotPaused isNotContractCaller {
986         bwService.verifyAmount(msg.sender, msg.value, _fortifyAmount, _useBattleValue);
987         bwService.fortifyClaims(msg.sender, _claimedTileIds, _fortifyAmount, _useBattleValue);
988     }
989 
990     // A new user attacks a tile claimed by someone else, trying to make it theirs through battle.
991     function attackTileForNewUser(uint16 _tileId, bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl, address _invitedBy) payable public isNotPaused isNotContractCaller {
992         bwData.addUser(msg.sender);
993         emit UserCreated(msg.sender, _name, _imageUrl, _tag, _homeUrl, block.timestamp, _invitedBy);
994         bwService.attackTile(msg.sender, _tileId, msg.value, false);
995     }
996 
997     // An existing user attacks a tile claimed by someone else, trying to make it theirs through battle.
998     function attackTileForExistingUser(uint16 _tileId, uint _attackAmount, bool _useBattleValue) payable public isNotPaused isNotContractCaller {
999         bwService.verifyAmount(msg.sender, msg.value, _attackAmount, _useBattleValue);
1000         bwService.attackTile(msg.sender, _tileId, _attackAmount, _useBattleValue);
1001     }
1002     
1003     // Move "army" = block value from one block to an adjacent block. Moving ALL value equates giving up ownership of the source tile.
1004     function moveBlockValue(uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isNotPaused isNotContractCaller {
1005         require(_moveAmount > 0);
1006         bwService.moveBlockValue(msg.sender, _xSource, _ySource, _xDest, _yDest, _moveAmount);
1007     }
1008 
1009     // Allow users to withdraw battle value in Ether.
1010     function withdrawBattleValue(uint _battleValueInWei) public isNotContractCaller {
1011         require(_battleValueInWei > 0);
1012         uint amountToWithdraw = bwService.withdrawBattleValue(msg.sender, _battleValueInWei);
1013         msg.sender.transfer(amountToWithdraw);
1014     }
1015 
1016     // Transfer block value to battle points for free 
1017     function transferBlockValueToBattleValue(uint16 _tileId, uint _amount) public isNotContractCaller {
1018         require(_amount > 0);
1019         address claimer;
1020         uint blockValue;
1021         (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_tileId);
1022         require(claimer == msg.sender);
1023         uint newBlockValue = blockValue.sub(_amount);
1024         // Must transfer the entire block value or leave at least 5
1025         require(newBlockValue == 0 || newBlockValue >= 5 finney);
1026         if(newBlockValue == 0) {
1027             bwData.deleteTile(_tileId);
1028         } else {
1029             bwData.updateTileBlockValue(_tileId, newBlockValue);
1030             bwData.deleteOffer(_tileId); // Offer invalid since block value has changed
1031         }
1032         
1033         uint fee = _amount.mul(BV_TO_BP_FEE).div(100);
1034         uint userAmount = _amount.sub(fee);
1035         uint feeBalance = bwData.getFeeBalance();
1036         feeBalance = feeBalance.add(fee);
1037         bwData.setFeeBalance(feeBalance);
1038 
1039         bwService.addUserBattleValue(msg.sender, userAmount);
1040         bwService.subGlobalBlockValueBalance(_amount);
1041         emit TileRetreated(_tileId, msg.sender, _amount, newBlockValue, block.timestamp);
1042     }
1043 
1044     // -------- LOCAL GAME FUNCTIONS ----------
1045 
1046     function getLocalBountyBalance(uint16 _tileId) view public isNotContractCaller returns (uint) {
1047         address localGameAddress = bwService.getLocalGame(_tileId);
1048         require(localGameAddress != 0);
1049         LocalGameI localGame = LocalGameI(localGameAddress);
1050         return localGame.getBountyBalance();
1051     }
1052 
1053     function getTimeLeftToNextLocalBountyCollect(uint16 _tileId) view public isNotContractCaller returns (uint) {
1054         address localGameAddress = bwService.getLocalGame(_tileId);
1055         require(localGameAddress != 0);
1056         LocalGameI localGame = LocalGameI(localGameAddress);
1057         address claimer;
1058         uint blockValue;
1059         uint latestClaimTime;
1060         uint sellPrice;
1061         (claimer, blockValue, latestClaimTime, sellPrice) = bwData.getTile(_tileId);
1062         return localGame.getTimeLeftToNextCollect(claimer, latestClaimTime);
1063     }
1064 
1065     function collectLocalBounty(uint16 _tileId, uint _amount) public isNotContractCaller {
1066         address localGameAddress = bwService.getLocalGame(_tileId);
1067         require(localGameAddress != 0);
1068         address claimer;
1069         uint blockValue;
1070         uint latestClaimTime;
1071         uint sellPrice;
1072         (claimer, blockValue, latestClaimTime, sellPrice) = bwData.getTile(_tileId);
1073         require(latestClaimTime != 0 && claimer == msg.sender);
1074         
1075         LocalGameI localGame = LocalGameI(localGameAddress);
1076         uint amountCollected = localGame.collectBounty(msg.sender, latestClaimTime, _amount);
1077         emit BountyCollected(_tileId, msg.sender, _amount, amountCollected, block.timestamp, latestClaimTime);
1078     }
1079 
1080     // -------- OWNER-ONLY FUNCTIONS ----------
1081 
1082     // Only used by owner for raffle. Owner need name, address and picture from user.
1083     // These users can then be given tiles by owner using transferTileFromOwner.
1084     function createNewUser(bytes32 _name, bytes _imageUrl, bytes32 _tag, bytes32 _homeUrl, address _user) public isOwner {
1085         bwData.addUser(_user);
1086         emit UserCreated(_user, _name, _imageUrl, _tag, _homeUrl, block.timestamp, msg.sender); //check on client if invitedBy is owner.
1087     }
1088 
1089     // Allow updating censored status. Owner only. In case someone uploads offensive content.
1090     // The contract owners reserve the right to apply censorship. This will mean that the
1091     // name, tag or URL images might not be displayed for a censored user.
1092     function censorUser(address _userAddress, bool _censored) public isOwner {
1093         bwData.censorUser(_userAddress, _censored);
1094         emit UserCensored(_userAddress, _censored);
1095     }
1096 
1097     // Pause the entire game, but let users keep withdrawing battle value
1098     function setPaused(bool _paused) public isOwner {
1099         paused = _paused;
1100     }
1101 
1102     function kill() public isOwner {
1103         selfdestruct(owner);
1104     }
1105     
1106     function withdrawFee() public isOwner {
1107         uint balance = address(this).balance;
1108         uint amountToWithdraw = bwData.getFeeBalance();
1109 
1110         if (balance < amountToWithdraw) { // Should never happen, but paranoia
1111             amountToWithdraw = balance;
1112         }
1113         bwData.setFeeBalance(0);
1114 
1115         owner.transfer(amountToWithdraw);
1116     }
1117 
1118     function getFee() view public isOwner returns (uint) {
1119         return bwData.getFeeBalance();
1120     }
1121 
1122     function setBvToBpFee(uint _feePercentage) public isOwner {
1123         BV_TO_BP_FEE = _feePercentage;
1124     }
1125 
1126     function depositBattleValue(address _user) payable public isOwner {
1127         require(msg.value % 1 finney == 0); // Must be divisible by 1 finney
1128         bwService.addUserBattleValue(_user, msg.value);
1129     }
1130 
1131     // The owner can transfer ownership of own tiles to other users, as prizes in competitions.
1132     function transferTileFromOwner(uint16[] _tileIds, address _newOwner) public isOwner {
1133         for(uint i = 0; i < _tileIds.length; ++i) {
1134             uint16 tileId = _tileIds[i];
1135             address claimer = bwData.getCurrentClaimerForTile(tileId);
1136             require(claimer == owner);
1137             bwData.setClaimerForTile(tileId, _newOwner);
1138             
1139             emit TransferTileFromOwner(tileId, _newOwner, msg.sender, block.timestamp);
1140         }
1141     }
1142 
1143     // Allow us to transfer out airdropped tokens if we ever receive any
1144     function transferTokens(address _tokenAddress, address _recipient) public isOwner {
1145         ERC20I token = ERC20I(_tokenAddress);
1146         require(token.transfer(_recipient, token.balanceOf(this)));
1147     }
1148 }