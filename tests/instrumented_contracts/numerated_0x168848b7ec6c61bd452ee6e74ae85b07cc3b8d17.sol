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
52 contract BWData {
53     address public owner;
54     address private bwService;
55     address private bw;
56     address private bwMarket;
57 
58     uint private blockValueBalance = 0;
59     uint private feeBalance = 0;
60     uint private BASE_TILE_PRICE_WEI = 1 finney; // 1 milli-ETH.
61     
62     mapping (address => User) private users; // user address -> user information
63     mapping (uint16 => Tile) private tiles; // tileId -> list of TileClaims for that particular tile
64     
65     // Info about the users = those who have purchased tiles.
66     struct User {
67         uint creationTime;
68         bool censored;
69         uint battleValue;
70     }
71 
72     // Info about a tile ownership
73     struct Tile {
74         address claimer;
75         uint blockValue;
76         uint creationTime;
77         uint sellPrice;    // If 0 -> not on marketplace. If > 0 -> on marketplace.
78     }
79 
80     struct Boost {
81         uint8 numAttackBoosts;
82         uint8 numDefendBoosts;
83         uint attackBoost;
84         uint defendBoost;
85     }
86 
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91     // Can't send funds straight to this contract. Avoid people sending by mistake.
92     function () payable public {
93         revert();
94     }
95 
96     function kill() public isOwner {
97         selfdestruct(owner);
98     }
99 
100     modifier isValidCaller {
101         if (msg.sender != bwService && msg.sender != bw && msg.sender != bwMarket) {
102             revert();
103         }
104         _;
105     }
106     
107     modifier isOwner {
108         if (msg.sender != owner) {
109             revert();
110         }
111         _;
112     }
113     
114     function setBwServiceValidCaller(address _bwService) public isOwner {
115         bwService = _bwService;
116     }
117 
118     function setBwValidCaller(address _bw) public isOwner {
119         bw = _bw;
120     }
121 
122     function setBwMarketValidCaller(address _bwMarket) public isOwner {
123         bwMarket = _bwMarket;
124     }    
125     
126     // ----------USER-RELATED GETTER FUNCTIONS------------
127     
128     //function getUser(address _user) view public returns (bytes32) {
129         //BWUtility.User memory user = users[_user];
130         //require(user.creationTime != 0);
131         //return (user.creationTime, user.imageUrl, user.tag, user.email, user.homeUrl, user.creationTime, user.censored, user.battleValue);
132     //}
133     
134     function addUser(address _msgSender) public isValidCaller {
135         User storage user = users[_msgSender];
136         require(user.creationTime == 0);
137         user.creationTime = block.timestamp;
138     }
139 
140     function hasUser(address _user) view public isValidCaller returns (bool) {
141         return users[_user].creationTime != 0;
142     }
143     
144 
145     // ----------TILE-RELATED GETTER FUNCTIONS------------
146 
147     function getTile(uint16 _tileId) view public isValidCaller returns (address, uint, uint, uint) {
148         Tile storage currentTile = tiles[_tileId];
149         return (currentTile.claimer, currentTile.blockValue, currentTile.creationTime, currentTile.sellPrice);
150     }
151     
152     function getTileClaimerAndBlockValue(uint16 _tileId) view public isValidCaller returns (address, uint) {
153         Tile storage currentTile = tiles[_tileId];
154         return (currentTile.claimer, currentTile.blockValue);
155     }
156     
157     function isNewTile(uint16 _tileId) view public isValidCaller returns (bool) {
158         Tile storage currentTile = tiles[_tileId];
159         return currentTile.creationTime == 0;
160     }
161     
162     function storeClaim(uint16 _tileId, address _claimer, uint _blockValue) public isValidCaller {
163         tiles[_tileId] = Tile(_claimer, _blockValue, block.timestamp, 0);
164     }
165 
166     function updateTileBlockValue(uint16 _tileId, uint _blockValue) public isValidCaller {
167         tiles[_tileId].blockValue = _blockValue;
168     }
169 
170     function setClaimerForTile(uint16 _tileId, address _claimer) public isValidCaller {
171         tiles[_tileId].claimer = _claimer;
172     }
173 
174     function updateTileTimeStamp(uint16 _tileId) public isValidCaller {
175         tiles[_tileId].creationTime = block.timestamp;
176     }
177     
178     function getCurrentClaimerForTile(uint16 _tileId) view public isValidCaller returns (address) {
179         Tile storage currentTile = tiles[_tileId];
180         if (currentTile.creationTime == 0) {
181             return 0;
182         }
183         return currentTile.claimer;
184     }
185 
186     function getCurrentBlockValueAndSellPriceForTile(uint16 _tileId) view public isValidCaller returns (uint, uint) {
187         Tile storage currentTile = tiles[_tileId];
188         if (currentTile.creationTime == 0) {
189             return (0, 0);
190         }
191         return (currentTile.blockValue, currentTile.sellPrice);
192     }
193     
194     function getBlockValueBalance() view public isValidCaller returns (uint){
195         return blockValueBalance;
196     }
197 
198     function setBlockValueBalance(uint _blockValueBalance) public isValidCaller {
199         blockValueBalance = _blockValueBalance;
200     }
201 
202     function getFeeBalance() view public isValidCaller returns (uint) {
203         return feeBalance;
204     }
205 
206     function setFeeBalance(uint _feeBalance) public isValidCaller {
207         feeBalance = _feeBalance;
208     }
209     
210     function getUserBattleValue(address _userId) view public isValidCaller returns (uint) {
211         return users[_userId].battleValue;
212     }
213     
214     function setUserBattleValue(address _userId, uint _battleValue) public  isValidCaller {
215         users[_userId].battleValue = _battleValue;
216     }
217     
218     function verifyAmount(address _msgSender, uint _msgValue, uint _amount, bool _useBattleValue) view public isValidCaller {
219         User storage user = users[_msgSender];
220         require(user.creationTime != 0);
221 
222         if (_useBattleValue) {
223             require(_msgValue == 0);
224             require(user.battleValue >= _amount);
225         } else {
226             require(_amount == _msgValue);
227         }
228     }
229     
230     function addBoostFromTile(Tile _tile, address _attacker, address _defender, Boost memory _boost) pure private {
231         if (_tile.claimer == _attacker) {
232             require(_boost.attackBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
233             _boost.attackBoost += _tile.blockValue;
234             _boost.numAttackBoosts += 1;
235         } else if (_tile.claimer == _defender) {
236             require(_boost.defendBoost + _tile.blockValue >= _tile.blockValue); // prevent overflow
237             _boost.defendBoost += _tile.blockValue;
238             _boost.numDefendBoosts += 1;
239         }
240     }
241 
242     function calculateBattleBoost(uint16 _tileId, address _attacker, address _defender) view public isValidCaller returns (uint, uint) {
243         uint8 x;
244         uint8 y;
245 
246         (x, y) = BWUtility.fromTileId(_tileId);
247 
248         Boost memory boost = Boost(0, 0, 0, 0);
249         // We overflow x, y on purpose here if x or y is 0 or 255 - the map overflows and so should adjacency.
250         // Go through all adjacent tiles to (x, y).
251         if (y != 255) {
252             if (x != 255) {
253                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y+1)], _attacker, _defender, boost);
254             }
255             
256             addBoostFromTile(tiles[BWUtility.toTileId(x, y+1)], _attacker, _defender, boost);
257 
258             if (x != 0) {
259                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y+1)], _attacker, _defender, boost);
260             }
261         }
262 
263         if (x != 255) {
264             addBoostFromTile(tiles[BWUtility.toTileId(x+1, y)], _attacker, _defender, boost);
265         }
266 
267         if (x != 0) {
268             addBoostFromTile(tiles[BWUtility.toTileId(x-1, y)], _attacker, _defender, boost);
269         }
270 
271         if (y != 0) {
272             if(x != 255) {
273                 addBoostFromTile(tiles[BWUtility.toTileId(x+1, y-1)], _attacker, _defender, boost);
274             }
275 
276             addBoostFromTile(tiles[BWUtility.toTileId(x, y-1)], _attacker, _defender, boost);
277 
278             if(x != 0) {
279                 addBoostFromTile(tiles[BWUtility.toTileId(x-1, y-1)], _attacker, _defender, boost);
280             }
281         }
282         // The benefit of boosts is multiplicative (quadratic):
283         // - More boost tiles gives a higher total blockValue (the sum of the adjacent tiles)
284         // - More boost tiles give a higher multiple of that total blockValue that can be used (10% per adjacent tie)
285         // Example:
286         //   A) I boost attack with 1 single tile worth 10 finney
287         //      -> Total boost is 10 * 1 / 10 = 1 finney
288         //   B) I boost attack with 3 tiles worth 1 finney each
289         //      -> Total boost is (1+1+1) * 3 / 10 = 0.9 finney
290         //   C) I boost attack with 8 tiles worth 2 finney each
291         //      -> Total boost is (2+2+2+2+2+2+2+2) * 8 / 10 = 14.4 finney
292         //   D) I boost attack with 3 tiles of 1, 5 and 10 finney respectively
293         //      -> Total boost is (ss1+5+10) * 3 / 10 = 4.8 finney
294         // This division by 10 can't create fractions since our uint is wei, and we can't have overflow from the multiplication
295         // We do allow fractions of finney here since the boosted values aren't stored anywhere, only used for attack rolls and sent in events
296         boost.attackBoost = (boost.attackBoost / 10 * boost.numAttackBoosts);
297         boost.defendBoost = (boost.defendBoost / 10 * boost.numDefendBoosts);
298 
299         return (boost.attackBoost, boost.defendBoost);
300     }
301     
302     function censorUser(address _userAddress, bool _censored) public isValidCaller {
303         User storage user = users[_userAddress];
304         require(user.creationTime != 0);
305         user.censored = _censored;
306     }
307     
308     function deleteTile(uint16 _tileId) public isValidCaller {
309         delete tiles[_tileId];
310     }
311     
312     function setSellPrice(uint16 _tileId, uint _sellPrice) public isValidCaller {
313         tiles[_tileId].sellPrice = _sellPrice;  //testrpc cannot estimate gas when delete is used.
314     }
315 
316     function deleteOffer(uint16 _tileId) public isValidCaller {
317         tiles[_tileId].sellPrice = 0;  //testrpc cannot estimate gas when delete is used.
318     }
319 }
320 
321 
322 
323 /**
324  * @title SafeMath
325  * @dev Math operations with safety checks that throw on error
326  */
327 library SafeMath {
328 
329   /**
330   * @dev Multiplies two numbers, throws on overflow.
331   */
332   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
333     if (a == 0) {
334       return 0;
335     }
336     c = a * b;
337     assert(c / a == b);
338     return c;
339   }
340 
341   /**
342   * @dev Integer division of two numbers, truncating the quotient.
343   */
344   function div(uint256 a, uint256 b) internal pure returns (uint256) {
345     // assert(b > 0); // Solidity automatically throws when dividing by 0
346     // uint256 c = a / b;
347     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
348     return a / b;
349   }
350 
351   /**
352   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
353   */
354   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
355     assert(b <= a);
356     return a - b;
357   }
358 
359   /**
360   * @dev Adds two numbers, throws on overflow.
361   */
362   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
363     c = a + b;
364     assert(c >= a);
365     return c;
366   }
367 }
368 
369 
370 interface ERC20I {
371     function transfer(address _recipient, uint256 _amount) external returns (bool);
372     function balanceOf(address _holder) external view returns (uint256);
373 }
374 
375 
376 contract BWService {
377     using SafeMath for uint256;
378     address private owner;
379     address private bw;
380     address private bwMarket;
381     BWData private bwData;
382     uint private seed = 42;
383     uint private WITHDRAW_FEE = 5; // 5%
384     uint private ATTACK_FEE = 5; // 5%
385     uint private ATTACK_BOOST_CAP = 300; // 300%
386     uint private DEFEND_BOOST_CAP = 300; // 300%
387     uint private ATTACK_BOOST_MULTIPLIER = 100; // 100%
388     uint private DEFEND_BOOST_MULTIPLIER = 100; // 100%
389     mapping (uint16 => address) private localGames;
390     
391     modifier isOwner {
392         if (msg.sender != owner) {
393             revert();
394         }
395         _;
396     }  
397 
398     modifier isValidCaller {
399         if (msg.sender != bw && msg.sender != bwMarket) {
400             revert();
401         }
402         _;
403     }
404 
405     event TileClaimed(uint16 tileId, address newClaimer, uint priceInWei, uint creationTime);
406     event TileFortified(uint16 tileId, address claimer, uint addedValueInWei, uint priceInWei, uint fortifyTime); // Sent when a user fortifies an existing claim by bumping its value.
407     event TileAttackedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint attackTime); // Sent when a user successfully attacks a tile.    
408     event TileDefendedSuccessfully(uint16 tileId, address attacker, uint attackAmount, uint totalAttackAmount, address defender, uint defendAmount, uint totalDefendAmount, uint attackRoll, uint defendTime); // Sent when a user successfully defends a tile when attacked.    
409     event BlockValueMoved(uint16 sourceTileId, uint16 destTileId, address owner, uint movedBlockValue, uint postSourceValue, uint postDestValue, uint moveTime); // Sent when a user buys a tile from another user, by accepting a tile offer
410     event UserBattleValueUpdated(address userAddress, uint battleValue, bool isWithdraw);
411 
412     // Constructor.
413     constructor(address _bwData) public {
414         bwData = BWData(_bwData);
415         owner = msg.sender;
416     }
417 
418     // Can't send funds straight to this contract. Avoid people sending by mistake.
419     function () payable public {
420         revert();
421     }
422 
423     // OWNER-ONLY FUNCTIONS
424     function kill() public isOwner {
425         selfdestruct(owner);
426     }
427 
428     function setValidBwCaller(address _bw) public isOwner {
429         bw = _bw;
430     }
431     
432     function setValidBwMarketCaller(address _bwMarket) public isOwner {
433         bwMarket = _bwMarket;
434     }
435 
436     function setWithdrawFee(uint _feePercentage) public isOwner {
437         WITHDRAW_FEE = _feePercentage;
438     }
439 
440     function setAttackFee(uint _feePercentage) public isOwner {
441         ATTACK_FEE = _feePercentage;
442     }
443 
444     function setAttackBoostMultipler(uint _multiplierPercentage) public isOwner {
445         ATTACK_BOOST_MULTIPLIER = _multiplierPercentage;
446     }
447 
448     function setDefendBoostMultiplier(uint _multiplierPercentage) public isOwner {
449         DEFEND_BOOST_MULTIPLIER = _multiplierPercentage;
450     }
451 
452     function setAttackBoostCap(uint _capPercentage) public isOwner {
453         ATTACK_BOOST_CAP = _capPercentage;
454     }
455 
456     function setDefendBoostCap(uint _capPercentage) public isOwner {
457         DEFEND_BOOST_CAP = _capPercentage;
458     }
459 
460     // TILE-RELATED FUNCTIONS
461     // This function claims multiple previously unclaimed tiles in a single transaction.
462     // The value assigned to each tile is the msg.value divided by the number of tiles claimed.
463     // The msg.value is required to be an even multiple of the number of tiles claimed.
464     function storeInitialClaim(address _msgSender, uint16[] _claimedTileIds, uint _claimAmount, bool _useBattleValue) public isValidCaller {
465         uint tileCount = _claimedTileIds.length;
466         require(tileCount > 0);
467         require(_claimAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
468         require(_claimAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles claimed
469 
470         uint valuePerBlockInWei = _claimAmount.div(tileCount); // Due to requires above this is guaranteed to be an even number
471         require(valuePerBlockInWei >= 5 finney);
472 
473         if (_useBattleValue) {
474             subUserBattleValue(_msgSender, _claimAmount, false);  
475         }
476 
477         addGlobalBlockValueBalance(_claimAmount);
478 
479         uint16 tileId;
480         bool isNewTile;
481         for (uint16 i = 0; i < tileCount; i++) {
482             tileId = _claimedTileIds[i];
483             isNewTile = bwData.isNewTile(tileId); // Is length 0 if first time purchased
484             require(isNewTile); // Can only claim previously unclaimed tiles.
485 
486             // Send claim event
487             emit TileClaimed(tileId, _msgSender, valuePerBlockInWei, block.timestamp);
488 
489             // Update contract state with new tile ownership.
490             bwData.storeClaim(tileId, _msgSender, valuePerBlockInWei);
491         }
492     }
493 
494     function fortifyClaims(address _msgSender, uint16[] _claimedTileIds, uint _fortifyAmount, bool _useBattleValue) public isValidCaller {
495         uint tileCount = _claimedTileIds.length;
496         require(tileCount > 0);
497 
498         address(this).balance.add(_fortifyAmount); // prevent overflow with SafeMath
499         require(_fortifyAmount % tileCount == 0); // ensure payment is an even multiple of number of tiles fortified
500         uint addedValuePerTileInWei = _fortifyAmount.div(tileCount); // Due to requires above this is guaranteed to be an even number
501         require(_fortifyAmount >= 1 finney * tileCount); // ensure enough funds paid for all tiles
502 
503         address claimer;
504         uint blockValue;
505         for (uint16 i = 0; i < tileCount; i++) {
506             (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_claimedTileIds[i]);
507             require(claimer != 0); // Can't do this on never-owned tiles
508             require(claimer == _msgSender); // Only current claimer can fortify claim
509 
510             if (_useBattleValue) {
511                 subUserBattleValue(_msgSender, addedValuePerTileInWei, false);
512             }
513             
514             fortifyClaim(_msgSender, _claimedTileIds[i], addedValuePerTileInWei);
515         }
516     }
517 
518     function fortifyClaim(address _msgSender, uint16 _claimedTileId, uint _fortifyAmount) private {
519         uint blockValue;
520         uint sellPrice;
521         (blockValue, sellPrice) = bwData.getCurrentBlockValueAndSellPriceForTile(_claimedTileId);
522         uint updatedBlockValue = blockValue.add(_fortifyAmount);
523         // Send fortify event
524         emit TileFortified(_claimedTileId, _msgSender, _fortifyAmount, updatedBlockValue, block.timestamp);
525         
526         // Update tile value. The tile has been fortified by bumping up its value.
527         bwData.updateTileBlockValue(_claimedTileId, updatedBlockValue);
528 
529         // Track addition to global block value
530         addGlobalBlockValueBalance(_fortifyAmount);
531     }
532 
533     // Return a pseudo random number between lower and upper bounds
534     // given the number of previous blocks it should hash.
535     // Random function copied from https://github.com/axiomzen/eth-random/blob/master/contracts/Random.sol.
536     // Changed sha3 to keccak256, then modified.
537     // Changed random range from uint64 to uint (=uint256).
538     function random(uint _upper) private returns (uint)  {
539         seed = uint(keccak256(blockhash(block.number - 1), block.coinbase, block.timestamp, seed, address(0x3f5CE5FBFe3E9af3971dD833D26bA9b5C936f0bE).balance));
540         return seed % _upper;
541     }
542 
543     // A user tries to claim a tile that's already owned by another user. A battle ensues.
544     // A random roll is done with % based on attacking vs defending amounts.
545     function attackTile(address _msgSender, uint16 _tileId, uint _attackAmount, bool _useBattleValue) public isValidCaller {
546         require(_attackAmount >= 1 finney);         // Don't allow attacking with less than one base tile price.
547         require(_attackAmount % 1 finney == 0);
548 
549         address claimer;
550         uint blockValue;
551         (claimer, blockValue) = bwData.getTileClaimerAndBlockValue(_tileId);
552         
553         require(claimer != 0); // Can't do this on never-owned tiles
554         require(claimer != _msgSender); // Can't attack one's own tiles
555         require(claimer != owner); // Can't attack owner's tiles because it is used for raffle.
556 
557         // Calculate boosted amounts for attacker and defender
558         // The base attack amount is sent in the by the user.
559         // The base defend amount is the attacked tile's current blockValue.
560         uint attackBoost;
561         uint defendBoost;
562         (attackBoost, defendBoost) = bwData.calculateBattleBoost(_tileId, _msgSender, claimer);
563 
564         // Adjust boost to optimize game strategy
565         attackBoost = attackBoost.mul(ATTACK_BOOST_MULTIPLIER).div(100);
566         defendBoost = defendBoost.mul(DEFEND_BOOST_MULTIPLIER).div(100);
567         
568         // Cap the boost to minimize its impact (prevents whales somehow)
569         if (attackBoost > _attackAmount.mul(ATTACK_BOOST_CAP).div(100)) {
570             attackBoost = _attackAmount.mul(ATTACK_BOOST_CAP).div(100);
571         }
572         if (defendBoost > blockValue.mul(DEFEND_BOOST_CAP).div(100)) {
573             defendBoost = blockValue.mul(DEFEND_BOOST_CAP).div(100);
574         }
575 
576         uint totalAttackAmount = _attackAmount.add(attackBoost);
577         uint totalDefendAmount = blockValue.add(defendBoost);
578 
579         // Verify that attack odds are within allowed range.
580         require(totalAttackAmount.div(10) <= totalDefendAmount); // Disallow attacks with more than 1000% of defendAmount
581         require(totalAttackAmount >= totalDefendAmount.div(10)); // Disallow attacks with less than 10% of defendAmount
582 
583         uint attackFeeAmount = _attackAmount.mul(ATTACK_FEE).div(100);
584         uint attackAmountAfterFee = _attackAmount.sub(attackFeeAmount);
585         
586         updateFeeBalance(attackFeeAmount);
587 
588         // The battle considers boosts.
589         uint attackRoll = random(totalAttackAmount.add(totalDefendAmount)); // This is where the excitement happens!
590 
591         //gas cost of attack branch is higher than denfense branch solving MSB1
592         if (attackRoll > totalDefendAmount) {
593             // Change block owner but keep same block value (attacker got battlevalue instead)
594             bwData.setClaimerForTile(_tileId, _msgSender);
595 
596             // Tile successfully attacked!
597             if (_useBattleValue) {
598                 // Withdraw followed by deposit of same amount to prevent MSB1
599                 addUserBattleValue(_msgSender, attackAmountAfterFee); // Don't include boost here!
600                 subUserBattleValue(_msgSender, attackAmountAfterFee, false);
601             } else {
602                 addUserBattleValue(_msgSender, attackAmountAfterFee); // Don't include boost here!
603             }
604             addUserBattleValue(claimer, 0);
605 
606             bwData.updateTileTimeStamp(_tileId);
607             // Send update event
608             emit TileAttackedSuccessfully(_tileId, _msgSender, attackAmountAfterFee, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
609         } else {
610             bwData.setClaimerForTile(_tileId, claimer); //should be old owner
611             // Tile successfully defended!
612             if (_useBattleValue) {
613                 subUserBattleValue(_msgSender, attackAmountAfterFee, false); // Don't include boost here!
614             }
615             addUserBattleValue(claimer, attackAmountAfterFee); // Don't include boost here!
616             
617             // Send update event
618             emit TileDefendedSuccessfully(_tileId, _msgSender, attackAmountAfterFee, totalAttackAmount, claimer, blockValue, totalDefendAmount, attackRoll, block.timestamp);
619         }
620     }
621 
622     function updateFeeBalance(uint attackFeeAmount) private {
623         uint feeBalance = bwData.getFeeBalance();
624         feeBalance = feeBalance.add(attackFeeAmount);
625         bwData.setFeeBalance(feeBalance);
626     }
627 
628     function moveBlockValue(address _msgSender, uint8 _xSource, uint8 _ySource, uint8 _xDest, uint8 _yDest, uint _moveAmount) public isValidCaller {
629         uint16 sourceTileId = BWUtility.toTileId(_xSource, _ySource);
630         uint16 destTileId = BWUtility.toTileId(_xDest, _yDest);
631 
632         address sourceTileClaimer;
633         address destTileClaimer;
634         uint sourceTileBlockValue;
635         uint destTileBlockValue;
636         (sourceTileClaimer, sourceTileBlockValue) = bwData.getTileClaimerAndBlockValue(sourceTileId);
637         (destTileClaimer, destTileBlockValue) = bwData.getTileClaimerAndBlockValue(destTileId);
638 
639         uint newBlockValue = sourceTileBlockValue.sub(_moveAmount);
640         // Must transfer the entire block value or leave at least 5
641         require(newBlockValue == 0 || newBlockValue >= 5 finney);
642 
643         require(sourceTileClaimer == _msgSender);
644         require(destTileClaimer == _msgSender);
645         require(_moveAmount >= 1 finney); // Can't be less
646         require(_moveAmount % 1 finney == 0); // Move amount must be in multiples of 1 finney
647         // require(sourceTile.blockValue - _moveAmount >= BASE_TILE_PRICE_WEI); // Must always leave some at source
648         
649         require(BWUtility.isAdjacent(_xSource, _ySource, _xDest, _yDest));
650 
651         sourceTileBlockValue = sourceTileBlockValue.sub(_moveAmount);
652         destTileBlockValue = destTileBlockValue.add(_moveAmount);
653 
654         // If ALL block value was moved away from the source tile, we lose our claim to it. It becomes ownerless.
655         if (sourceTileBlockValue == 0) {
656             bwData.deleteTile(sourceTileId);
657         } else {
658             bwData.updateTileBlockValue(sourceTileId, sourceTileBlockValue);
659             bwData.deleteOffer(sourceTileId); // Offer invalid since block value has changed
660         }
661 
662         bwData.updateTileBlockValue(destTileId, destTileBlockValue);
663         bwData.deleteOffer(destTileId);   // Offer invalid since block value has changed
664         emit BlockValueMoved(sourceTileId, destTileId, _msgSender, _moveAmount, sourceTileBlockValue, destTileBlockValue, block.timestamp);        
665     }
666 
667     function verifyAmount(address _msgSender, uint _msgValue, uint _amount, bool _useBattleValue) view public isValidCaller {
668         if (_useBattleValue) {
669             require(_msgValue == 0);
670             require(bwData.getUserBattleValue(_msgSender) >= _amount);
671         } else {
672             require(_amount == _msgValue);
673         }
674     }
675 
676     function setLocalGame(uint16 _tileId, address localGameAddress) public isOwner {
677         localGames[_tileId] = localGameAddress;
678     }
679 
680     function getLocalGame(uint16 _tileId) view public isValidCaller returns (address) {
681         return localGames[_tileId];
682     }
683 
684     // BATTLE VALUE FUNCTIONS
685     function withdrawBattleValue(address msgSender, uint _battleValueInWei) public isValidCaller returns (uint) {
686         //require(_battleValueInWei % 1 finney == 0); // Must be divisible by 1 finney
687         uint fee = _battleValueInWei.mul(WITHDRAW_FEE).div(100); // Since we divide by 20 we can never create infinite fractions, so we'll always count in whole wei amounts.
688         uint amountToWithdraw = _battleValueInWei.sub(fee);
689         uint feeBalance = bwData.getFeeBalance();
690         feeBalance = feeBalance.add(fee);
691         bwData.setFeeBalance(feeBalance);
692         subUserBattleValue(msgSender, _battleValueInWei, true);
693         return amountToWithdraw;
694     }
695 
696     function addUserBattleValue(address _userId, uint _amount) public isValidCaller {
697         uint userBattleValue = bwData.getUserBattleValue(_userId);
698         uint newBattleValue = userBattleValue.add(_amount);
699         bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
700         emit UserBattleValueUpdated(_userId, newBattleValue, false);
701     }
702     
703     function subUserBattleValue(address _userId, uint _amount, bool _isWithdraw) public isValidCaller {
704         uint userBattleValue = bwData.getUserBattleValue(_userId);
705         require(_amount <= userBattleValue); // Must be less than user's battle value - also implicitly checks that underflow isn't possible
706         uint newBattleValue = userBattleValue.sub(_amount);
707         bwData.setUserBattleValue(_userId, newBattleValue); // Don't include boost here!
708         emit UserBattleValueUpdated(_userId, newBattleValue, _isWithdraw);
709     }
710 
711     function addGlobalBlockValueBalance(uint _amount) public isValidCaller {
712         // Track addition to global block value.
713         uint blockValueBalance = bwData.getBlockValueBalance();
714         bwData.setBlockValueBalance(blockValueBalance.add(_amount));
715     }
716 
717     function subGlobalBlockValueBalance(uint _amount) public isValidCaller {
718         // Track addition to global block value.
719         uint blockValueBalance = bwData.getBlockValueBalance();
720         bwData.setBlockValueBalance(blockValueBalance.sub(_amount));
721     }
722 
723     // Allow us to transfer out airdropped tokens if we ever receive any
724     function transferTokens(address _tokenAddress, address _recipient) public isOwner {
725         ERC20I token = ERC20I(_tokenAddress);
726         require(token.transfer(_recipient, token.balanceOf(this)));
727     }
728 }