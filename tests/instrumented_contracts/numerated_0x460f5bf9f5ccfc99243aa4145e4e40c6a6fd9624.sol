1 pragma solidity ^0.4.8;
2 
3 contract WinMatrix
4  {
5    function getCoeff(uint16 n) external returns (uint256);
6    function getBetsProcessed() external constant returns (uint16);
7  }
8 
9 contract SmartRouletteToken 
10 {
11    function emission(address player, address partner, uint256 value_bet, uint16 coef_player, uint16 coef_partner) external returns(uint256);
12    function isOperationBlocked() external constant returns (bool);
13 }
14 
15 contract SmartAffiliate 
16 {
17    function register(address player, address affiliate) external;
18    function getAffiliateInfo(address player) external constant returns(address affiliate, uint16 coef_affiliate);
19 }
20 
21 contract SmartRoulette
22 {
23   address developer;
24   address operator;
25 
26   // Wait BlockDelay blocks before spin the wheel 
27   uint8 BlockDelay;
28 
29   // Maximum bet value for game
30   uint256 currentMaxBet;    
31 
32   // maximum games count per block
33   uint64 maxGamblesPerBlock;
34         
35   // Enable\disable to place new bets
36   bool ContractState;
37 
38   // table with winner coefficients
39   WinMatrix winMatrix;
40 
41   SmartRouletteToken smartToken;
42 
43   address profitDistributionContract;
44 
45   SmartAffiliate smartAffiliateContract;
46 
47   uint16 constant maxTypeBets = 157;
48    
49    uint16 coef_player;   
50    // 
51    uint8 defaultMinCreditsOnBet; 
52    //
53    mapping (uint8 => uint8) private minCreditsOnBet;
54 
55    struct GameInfo
56    {
57         address player;
58         uint256 blockNumber;
59         uint8 wheelResult;
60         uint256 bets;
61         bytes32 values;
62         bytes32 values2;
63    }
64        
65    GameInfo[] private gambles;
66 
67    enum GameStatus {Success, Skipped, Stop}
68 
69    enum BetTypes{number0, number1,number2,number3,number4,number5,number6,number7,number8,number9,
70      number10,number11,number12,number13,number14,number15,number16,number17,number18,number19,number20,number21,
71      number22,number23,number24,number25,number26,number27,number28,number29,number30,number31,number32,number33,
72      number34,number35,number36, red, black, odd, even, dozen1,dozen2,dozen3, column1,column2,column3, low,high,
73      pair_01, pair_02, pair_03, pair_12, pair_23, pair_36, pair_25, pair_14, pair_45, pair_56, pair_69, pair_58, pair_47,
74      pair_78, pair_89, pair_912, pair_811, pair_710, pair_1011, pair_1112, pair_1215, pair_1518, pair_1617, pair_1718, pair_1720,
75      pair_1619, pair_1922, pair_2023, pair_2124, pair_2223, pair_2324, pair_2528, pair_2629, pair_2730, pair_2829, pair_2930, pair_1114,
76      pair_1013, pair_1314, pair_1415, pair_1316, pair_1417, pair_1821, pair_1920, pair_2021, pair_2225, pair_2326, pair_2427, pair_2526,
77      pair_2627, pair_2831, pair_2932, pair_3033, pair_3132, pair_3233, pair_3134, pair_3235, pair_3336, pair_3435, pair_3536, corner_0_1_2_3,
78      corner_1_2_5_4, corner_2_3_6_5, corner_4_5_8_7, corner_5_6_9_8, corner_7_8_11_10, corner_8_9_12_11, corner_10_11_14_13, corner_11_12_15_14,
79      corner_13_14_17_16, corner_14_15_18_17, corner_16_17_20_19, corner_17_18_21_20, corner_19_20_23_22, corner_20_21_24_23, corner_22_23_26_25,
80      corner_23_24_27_26, corner_25_26_29_28, corner_26_27_30_29, corner_28_29_32_31, corner_29_30_33_32, corner_31_32_35_34, corner_32_33_36_35,
81      three_0_2_3, three_0_1_2, three_1_2_3, three_4_5_6, three_7_8_9, three_10_11_12, three_13_14_15, three_16_17_18, three_19_20_21, three_22_23_24,
82      three_25_26_27, three_28_29_30, three_31_32_33, three_34_35_36, six_1_2_3_4_5_6, six_4_5_6_7_8_9, six_7_8_9_10_11_12, six_10_11_12_13_14_15,
83      six_13_14_15_16_17_18, six_16_17_18_19_20_21, six_19_20_21_22_23_24, six_22_23_24_25_26_27, six_25_26_27_28_29_30, six_28_29_30_31_32_33,
84      six_31_32_33_34_35_36}
85    
86 
87    function SmartRoulette() internal
88    {        
89         developer  = msg.sender;
90         operator   = msg.sender;
91         
92         winMatrix = WinMatrix(0x073D6621E9150bFf9d1D450caAd3c790b6F071F2);
93         if (winMatrix.getBetsProcessed() != maxTypeBets) throw;
94         
95         smartToken = SmartRouletteToken(0x2a650356bd894370cc1d6aba71b36c0ad6b3dc18);
96 
97         currentMaxBet = 2560 finney; // 2.56 ether
98         BlockDelay = 1;        
99         maxGamblesPerBlock = 5;
100         defaultMinCreditsOnBet = 1;   
101         ContractState  = true;  
102         bankrolLimit = 277 ether;
103         profitLimit  = 50 ether;
104         coef_player = 300;
105    }
106 
107    function changeMaxBet(uint256 newMaxBet) public onlyDeveloper 
108    {             
109       // rounds to 2 digts
110       newMaxBet = newMaxBet / 2560000000000000000 * 2560000000000000000;  
111       if (newMaxBet != currentMaxBet) 
112       {
113         currentMaxBet = newMaxBet;
114         SettingsChanged(currentMaxBet, currentMaxBet / 256,  defaultMinCreditsOnBet, minCreditsOnBet[uint8(BetTypes.low)], minCreditsOnBet[uint8(BetTypes.dozen1)], BlockDelay, ContractState);
115       }
116    }
117 
118    uint256 bankrolLimit;
119    uint256 profitLimit;
120    uint256 lastDistributedProfit;
121    uint256 lastDateDistributedProfit;
122    
123    function getDistributeProfitsInfo() public constant returns (uint256 lastProfit, uint256 lastDate)
124    {
125       lastProfit = lastDistributedProfit;
126       lastDate = lastDateDistributedProfit;
127    }
128 
129    function setProfitDistributionContract(address contractAddress) onlyDeveloper
130    {
131       if (profitDistributionContract > 0) throw;
132       profitDistributionContract = contractAddress;
133    }
134 
135    function setSmartAffiliateContract(address contractAddress) onlyDeveloper
136    {
137       if (address(smartAffiliateContract) > 0) throw;
138       smartAffiliateContract = SmartAffiliate(contractAddress);
139    }
140 
141    function distributeProfits(uint256 gasValue) onlyDeveloperOrOperator
142    {
143       if (profitDistributionContract > 0 && this.balance >= (bankrolLimit+profitLimit))
144       {
145          uint256 diff = this.balance - bankrolLimit;
146          if (address(profitDistributionContract).call.gas(gasValue).value(diff)() == false) throw;
147          lastDistributedProfit = diff;
148          lastDateDistributedProfit = block.timestamp;
149       }      
150    }
151 
152    function getTokenSettings() public constant returns(uint16 Coef_player, uint256 BankrolLimit, uint256 ProfitLimit)
153    {
154       Coef_player = coef_player;      
155       BankrolLimit = bankrolLimit;
156       ProfitLimit = profitLimit;
157    }
158 
159    function changeTokenSettings(uint16 newCoef_player, uint256 newBankrolLimit, uint256 newProfitLimit) onlyDeveloper
160    {
161       coef_player  = newCoef_player;      
162       bankrolLimit = newBankrolLimit;
163       profitLimit  = newProfitLimit;
164    }
165 
166    function changeSettings(uint64 NewMaxBetsPerBlock, uint8 NewBlockDelay, uint8 MinCreditsOnBet50, uint8 MinCreditsOnBet33, uint8 NewDefaultMinCreditsOnBet) onlyDeveloper
167    {     
168       BlockDelay = NewBlockDelay;     
169 
170       if (NewMaxBetsPerBlock != 0) maxGamblesPerBlock = NewMaxBetsPerBlock;     
171 
172       if (MinCreditsOnBet50 > 0)
173       {
174         minCreditsOnBet[uint8(BetTypes.low)]   = MinCreditsOnBet50;
175         minCreditsOnBet[uint8(BetTypes.high)]  = MinCreditsOnBet50;
176         minCreditsOnBet[uint8(BetTypes.red)]   = MinCreditsOnBet50;
177         minCreditsOnBet[uint8(BetTypes.black)] = MinCreditsOnBet50;
178         minCreditsOnBet[uint8(BetTypes.odd)]   = MinCreditsOnBet50;
179         minCreditsOnBet[uint8(BetTypes.even)]  = MinCreditsOnBet50;
180       }  
181 
182       if (MinCreditsOnBet33 > 0)
183       {
184         minCreditsOnBet[uint8(BetTypes.dozen1)] = MinCreditsOnBet33;
185         minCreditsOnBet[uint8(BetTypes.dozen2)] = MinCreditsOnBet33;
186         minCreditsOnBet[uint8(BetTypes.dozen3)] = MinCreditsOnBet33;
187         minCreditsOnBet[uint8(BetTypes.column1)] = MinCreditsOnBet33;
188         minCreditsOnBet[uint8(BetTypes.column2)] = MinCreditsOnBet33;
189         minCreditsOnBet[uint8(BetTypes.column3)] = MinCreditsOnBet33;
190       }
191 
192       if (NewDefaultMinCreditsOnBet > 0) defaultMinCreditsOnBet = NewDefaultMinCreditsOnBet;   
193    }
194    
195    function deleteContract() onlyDeveloper  
196    {
197         suicide(msg.sender);
198    }
199 
200    // bit from 0 to 255
201    function isBitSet(uint256 data, uint8 bit) private constant returns (bool ret)
202    {
203        assembly {
204             ret := iszero(iszero(and(data, exp(2,bit))))
205         }
206         return ret;
207    }
208 
209    // unique combination of bet and wheelResult, used for access to WinMatrix
210    function getIndex(uint16 bet, uint16 wheelResult) private constant returns (uint16)
211    {
212       return (bet+1)*256 + (wheelResult+1);
213    }
214 
215    // n form 1 <= to <= 32
216    function getBetValue(bytes32 values, uint8 n) private constant returns (uint256)
217    {
218         // bet in credits (1..256) 
219         uint256 bet = uint256(values[32-n])+1;
220 
221          // check min bet
222         uint8 minCredits = minCreditsOnBet[n];
223         if (minCredits == 0) minCredits = defaultMinCreditsOnBet;
224         if (bet < minCredits) throw;
225         
226         // bet in wei
227         bet = currentMaxBet*bet/256;
228         if (bet > currentMaxBet) throw;         
229 
230         return bet;        
231    }
232 
233    function getBetValueByGamble(GameInfo memory gamble, uint8 n) private constant returns (uint256) 
234    {
235       if (n<=32) return getBetValue(gamble.values, n);
236       if (n<=64) return getBetValue(gamble.values2, n-32);
237       // there are 64 maximum unique bets (positions) in one game
238       throw;
239    }
240   
241    function totalGames() constant returns (uint256)
242    {
243        return gambles.length;
244    }
245    
246    function getSettings() constant returns(uint256 maxBet, uint256 oneCredit, uint8 MinBetInCredits, uint8 MinBetInCredits_50,uint8 MinBetInCredits_33, uint8 blockDelayBeforeSpin, bool contractState)
247     {
248         maxBet    = currentMaxBet;
249         oneCredit = currentMaxBet / 256; 
250         blockDelayBeforeSpin = BlockDelay;        
251         MinBetInCredits      = defaultMinCreditsOnBet;
252         MinBetInCredits_50   = minCreditsOnBet[uint8(BetTypes.low)]; 
253         MinBetInCredits_33   = minCreditsOnBet[uint8(BetTypes.column1)]; 
254         contractState        = ContractState;
255     }
256    
257     modifier onlyDeveloper() 
258     {
259        if (msg.sender != developer) throw;
260        _;
261     }
262 
263     modifier onlyDeveloperOrOperator() 
264     {
265        if (msg.sender != developer && msg.sender != operator) throw;
266        _;
267     }
268 
269    function disableBetting_only_Dev()
270     onlyDeveloperOrOperator
271     {
272         ContractState=false;
273     }
274 
275 
276     function changeOperator(address newOperator) onlyDeveloper
277     {
278        operator = newOperator;
279     }
280 
281     function enableBetting_only_Dev()
282     onlyDeveloperOrOperator
283     {
284         ContractState=true;
285 
286     }
287 
288     event PlayerBet(uint256 gambleId, uint256 playerTokens);
289     event EndGame(address player, uint8 result, uint256 gambleId);
290     event SettingsChanged(uint256 maxBet, uint256 oneCredit, uint8 DefaultMinBetInCredits, uint8 MinBetInCredits50, uint8 MinBetInCredits33, uint8 blockDelayBeforeSpin, bool contractState);
291     event ErrorLog(address player, string message);
292     event GasLog(string msg, uint256 level, uint256 gas);
293 
294    function totalBetValue(GameInfo memory g) private constant returns (uint256)
295    {              
296        uint256 totalBetsValue = 0; 
297        uint8 nPlayerBetNo = 0;
298        uint8 betsCount = uint8(bytes32(g.bets)[0]);
299 
300        for(uint8 i = 0; i < maxTypeBets;i++) 
301         if (isBitSet(g.bets, i))
302         {
303           totalBetsValue += getBetValueByGamble(g, nPlayerBetNo+1);
304           nPlayerBetNo++;
305 
306           if (betsCount == 1) break;
307           betsCount--;          
308         }
309 
310        return totalBetsValue;
311    }
312 
313    function totalBetCount(GameInfo memory g) private constant returns (uint256)
314    {              
315        uint256 totalBets = 0; 
316        for(uint8 i=0; i < maxTypeBets;i++) 
317         if (isBitSet(g.bets, i)) totalBets++;          
318        return totalBets;   
319    }
320 
321    function placeBet(uint256 bets, bytes32 values1,bytes32 values2) public payable
322    {
323        if (ContractState == false)
324        {
325          ErrorLog(msg.sender, "ContractDisabled");
326          if (msg.sender.send(msg.value) == false) throw;
327          return;
328        }
329 
330        if (smartToken.isOperationBlocked())
331        {
332          ErrorLog(msg.sender, "EmissionBlocked");
333          if (msg.sender.send(msg.value) == false) throw;
334          return;
335        }
336 
337        var gamblesLength = gambles.length;
338 
339        if (gamblesLength > 0)
340        {
341           uint8 gamblesCountInCurrentBlock = 0;
342           for(var i = gamblesLength - 1;i > 0; i--)
343           {
344             if (gambles[i].blockNumber == block.number) 
345             {
346                if (gambles[i].player == msg.sender)
347                {
348                    ErrorLog(msg.sender, "Play twice the same block");
349                    if (msg.sender.send(msg.value) == false) throw;
350                    return;
351                }
352 
353                gamblesCountInCurrentBlock++;
354                if (gamblesCountInCurrentBlock >= maxGamblesPerBlock)
355                {
356                   ErrorLog(msg.sender, "maxGamblesPerBlock");
357                   if (msg.sender.send(msg.value) == false) throw;
358                   return;
359                }
360             }
361             else
362             {
363                break;
364             }
365           }
366        }
367        
368        var _currentMaxBet = currentMaxBet;
369 
370        if (msg.value < _currentMaxBet/256 || bets == 0)
371        {
372           ErrorLog(msg.sender, "Wrong bet value");
373           if (msg.sender.send(msg.value) == false) throw;
374           return;
375        }
376 
377        if (msg.value > _currentMaxBet)
378        {
379           ErrorLog(msg.sender, "Limit for table");
380           if (msg.sender.send(msg.value) == false) throw;
381           return;
382        }
383 
384        GameInfo memory g = GameInfo(msg.sender, block.number, 37, bets, values1,values2);
385 
386        if (totalBetValue(g) != msg.value)
387        {
388           ErrorLog(msg.sender, "Wrong bet value");
389           if (msg.sender.send(msg.value) == false) throw;
390           return;
391        }
392 
393        gambles.push(g);
394 
395        address affiliate = 0;
396        uint16 coef_affiliate = 0;
397        if (address(smartAffiliateContract) > 0)
398        {
399          (affiliate, coef_affiliate) = smartAffiliateContract.getAffiliateInfo(msg.sender);   
400        }
401 
402        uint256 playerTokens = smartToken.emission(msg.sender, affiliate, msg.value, coef_player, coef_affiliate);            
403 
404        PlayerBet(gamblesLength, playerTokens); 
405    }
406 
407     function Invest() payable onlyDeveloper
408     {
409       
410     }
411 
412     function GetGameIndexesToProcess() public constant returns (uint256[64] gameIndexes)
413     {           
414       uint8 index = 0;
415       for(int256 i = int256(gambles.length) - 1;i >= 0;i--)
416       {      
417          GameInfo memory g = gambles[uint256(i)];
418          if (block.number - g.blockNumber >= 256) break;
419 
420          if (g.wheelResult == 37 && block.number >= g.blockNumber + BlockDelay)
421          { 
422             gameIndexes[index++] = uint256(i + 1);
423          }
424       }      
425     }
426 
427     uint256 lastBlockGamesProcessed;
428 
429     function ProcessGames(uint256[] gameIndexes, bool simulate) 
430     {
431       if (!simulate)
432       {
433          if (lastBlockGamesProcessed == block.number)  return;
434          lastBlockGamesProcessed = block.number;
435       }
436 
437       uint8 delay = BlockDelay;
438       uint256 length = gameIndexes.length;
439       bool success = false;
440       for(uint256 i = 0;i < length;i++)
441       {      
442          if (ProcessGame(gameIndexes[i], delay) == GameStatus.Success) success = true;         
443       }      
444       if (simulate && !success) throw;
445     }
446     
447     function ProcessGameExt(uint256 index) public returns (GameStatus)
448     {
449       return ProcessGame(index, BlockDelay);
450     }
451 
452     function ProcessGame(uint256 index, uint256 delay) private returns (GameStatus)
453     {            
454       GameInfo memory g = gambles[index];
455       if (block.number - g.blockNumber >= 256) return GameStatus.Stop;
456 
457       if (g.wheelResult == 37 && block.number > g.blockNumber + delay)
458       {            
459          gambles[index].wheelResult = getRandomNumber(g.player, g.blockNumber);
460                  
461          uint256 playerWinnings = getGameResult(gambles[index]);
462          if (playerWinnings > 0) 
463          {
464             if (g.player.send(playerWinnings) == false) throw;
465          }
466 
467          EndGame(g.player, gambles[index].wheelResult, index);
468          return GameStatus.Success;
469       }
470 
471       return GameStatus.Skipped;
472     }
473 
474     function getRandomNumber(address player, uint256 playerblock) private returns(uint8 wheelResult)
475     {
476         // block.blockhash - hash of the given block - only works for 256 most recent blocks excluding current
477         bytes32 blockHash = block.blockhash(playerblock+BlockDelay); 
478         
479         if (blockHash==0) 
480         {
481           ErrorLog(msg.sender, "Cannot generate random number");
482           wheelResult = 200;
483         }
484         else
485         {
486           bytes32 shaPlayer = sha3(player, blockHash);
487     
488           wheelResult = uint8(uint256(shaPlayer)%37);
489         }    
490     }
491 
492     function calculateRandomNumberByBlockhash(uint256 blockHash, address player) public constant returns (uint8 wheelResult) 
493     { 
494           bytes32 shaPlayer = sha3(player, blockHash);
495     
496           wheelResult = uint8(uint256(shaPlayer)%37);
497     }
498 
499     function emergencyFixGameResult(uint64 gambleId, uint256 blockHash) onlyDeveloperOrOperator
500     {
501       // Probably this function will never be called, but
502       // if game was not spinned in 256 blocks then block.blockhash will returns always 0 and 
503       // we should fix this manually (you can check result with public function calculateRandomNumberByBlockhash)
504       GameInfo memory gamble = gambles[gambleId];
505       if (gamble.wheelResult != 200) throw;
506 
507       gambles[gambleId].wheelResult = calculateRandomNumberByBlockhash(blockHash, gamble.player);      
508 
509       uint256 playerWinnings = getGameResult(gambles[gambleId]);
510       if (playerWinnings > 0)
511       {
512         if (gamble.player.send(playerWinnings) == false) throw;
513       }      
514 
515       EndGame(gamble.player, gamble.wheelResult, gambleId);
516     }
517 
518 
519     function checkGamesReadyForSpinning() constant returns (int256[256] ret) 
520     { 
521       uint16 index = 0;    
522       for(int256 i = int256(gambles.length) - 1;i >= 0;i--)
523       {      
524          GameInfo memory g = gambles[uint256(i)];
525          if (block.number - g.blockNumber >= 256) return ;
526 
527          if (g.wheelResult == 37 && block.number > g.blockNumber + BlockDelay)
528          {            
529             ret[index++] = i+1;            
530          }               
531       } 
532     }
533 
534     function preliminaryGameResult(uint64 gambleIndex) constant returns (uint64 gambleId, address player, uint256 blockNumber, uint256 totalWin, uint8 wheelResult, uint256 bets, uint256 values1, uint256 values2, uint256 nTotalBetValue, uint256 nTotalBetCount) 
535     { 
536       GameInfo memory g = gambles[uint256(gambleIndex)];
537       
538       if (g.wheelResult == 37 && block.number > g.blockNumber + BlockDelay)
539       {
540          gambles[gambleIndex].wheelResult = getRandomNumber(g.player, g.blockNumber);
541          return getGame(gambleIndex);
542       }
543       throw;      
544     }
545     
546     function getGameResult(GameInfo memory game) private constant returns (uint256 totalWin) 
547     {
548         totalWin = 0;
549         uint8 nPlayerBetNo = 0;
550         // we sent count bets at last byte 
551         uint8 betsCount = uint8(bytes32(game.bets)[0]); 
552         for(uint8 i=0; i<maxTypeBets; i++)
553         {                      
554             if (isBitSet(game.bets, i))
555             {              
556               var winMul = winMatrix.getCoeff(getIndex(i, game.wheelResult)); // get win coef
557               if (winMul > 0) winMul++; // + return player bet
558               totalWin += winMul * getBetValueByGamble(game, nPlayerBetNo+1);
559               nPlayerBetNo++; 
560 
561               if (betsCount == 1) break;
562               betsCount--;
563             }
564         }        
565     }
566 
567     function getGame(uint64 index) constant returns (uint64 gambleId, address player, uint256 blockNumber, uint256 totalWin, uint8 wheelResult, uint256 bets, uint256 values1, uint256 values2, uint256 nTotalBetValue, uint256 nTotalBetCount) 
568     {
569         gambleId = index;
570         player = gambles[index].player;
571         totalWin = getGameResult(gambles[index]);
572         blockNumber = gambles[index].blockNumber;        
573         wheelResult = gambles[index].wheelResult;
574         nTotalBetValue = totalBetValue(gambles[index]);
575         nTotalBetCount = totalBetCount(gambles[index]);
576         bets = gambles[index].bets;
577         values1 = uint256(gambles[index].values);
578         values2 = uint256(gambles[index].values2);        
579     }
580 
581    function() 
582    {
583       throw;
584    }
585    
586 
587 }