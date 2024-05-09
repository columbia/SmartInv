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
12 }
13 
14 contract SmartAffiliate 
15 {
16    function register(address player, address affiliate) external;
17    function getAffiliateInfo(address player) external constant returns(address affiliate, uint16 coef_affiliate);
18 }
19 
20 contract SmartRoulette
21 {
22     address developer;
23     address operator;
24 
25     // Wait BlockDelay blocks before spin the wheel 
26     uint8 BlockDelay;
27 
28     // Maximum bet value for game
29     uint256 currentMaxBet;    
30 
31     // maximum games count per block
32     uint64 maxGamblesPerBlock;
33         
34     // Enable\disable to place new bets
35     bool ContractState;
36 
37     // table with winner coefficients
38     WinMatrix winMatrix;
39 
40     SmartRouletteToken smartToken;
41 
42     address profitDistributionContract;
43 
44     SmartAffiliate smartAffiliateContract;
45 
46     uint16 constant maxTypeBets = 157;
47       
48    // last game index for player (used for fast access)
49    //mapping (address => uint64) private gambleIndex;   
50    
51    uint16 coef_player;   
52    // 
53    uint8 defaultMinCreditsOnBet; 
54    //
55    mapping (uint8 => uint8) private minCreditsOnBet;
56 
57    struct GameInfo
58    {
59         address player;
60         uint256 blockNumber;
61         uint8 wheelResult;
62         uint256 bets;
63         bytes32 values;
64         bytes32 values2;
65    }
66        
67    GameInfo[] private gambles;
68 
69    enum GameStatus {Success, Skipped, Stop}
70 
71    enum BetTypes{number0, number1,number2,number3,number4,number5,number6,number7,number8,number9,
72      number10,number11,number12,number13,number14,number15,number16,number17,number18,number19,number20,number21,
73      number22,number23,number24,number25,number26,number27,number28,number29,number30,number31,number32,number33,
74      number34,number35,number36, red, black, odd, even, dozen1,dozen2,dozen3, column1,column2,column3, low,high,
75      pair_01, pair_02, pair_03, pair_12, pair_23, pair_36, pair_25, pair_14, pair_45, pair_56, pair_69, pair_58, pair_47,
76      pair_78, pair_89, pair_912, pair_811, pair_710, pair_1011, pair_1112, pair_1215, pair_1518, pair_1617, pair_1718, pair_1720,
77      pair_1619, pair_1922, pair_2023, pair_2124, pair_2223, pair_2324, pair_2528, pair_2629, pair_2730, pair_2829, pair_2930, pair_1114,
78      pair_1013, pair_1314, pair_1415, pair_1316, pair_1417, pair_1821, pair_1920, pair_2021, pair_2225, pair_2326, pair_2427, pair_2526,
79      pair_2627, pair_2831, pair_2932, pair_3033, pair_3132, pair_3233, pair_3134, pair_3235, pair_3336, pair_3435, pair_3536, corner_0_1_2_3,
80      corner_1_2_5_4, corner_2_3_6_5, corner_4_5_8_7, corner_5_6_9_8, corner_7_8_11_10, corner_8_9_12_11, corner_10_11_14_13, corner_11_12_15_14,
81      corner_13_14_17_16, corner_14_15_18_17, corner_16_17_20_19, corner_17_18_21_20, corner_19_20_23_22, corner_20_21_24_23, corner_22_23_26_25,
82      corner_23_24_27_26, corner_25_26_29_28, corner_26_27_30_29, corner_28_29_32_31, corner_29_30_33_32, corner_31_32_35_34, corner_32_33_36_35,
83      three_0_2_3, three_0_1_2, three_1_2_3, three_4_5_6, three_7_8_9, three_10_11_12, three_13_14_15, three_16_17_18, three_19_20_21, three_22_23_24,
84      three_25_26_27, three_28_29_30, three_31_32_33, three_34_35_36, six_1_2_3_4_5_6, six_4_5_6_7_8_9, six_7_8_9_10_11_12, six_10_11_12_13_14_15,
85      six_13_14_15_16_17_18, six_16_17_18_19_20_21, six_19_20_21_22_23_24, six_22_23_24_25_26_27, six_25_26_27_28_29_30, six_28_29_30_31_32_33,
86      six_31_32_33_34_35_36}
87    
88 
89    function SmartRoulette() internal
90    {        
91         developer  = msg.sender;
92         operator   = msg.sender;
93         
94         winMatrix = WinMatrix(0x073D6621E9150bFf9d1D450caAd3c790b6F071F2 );
95         if (winMatrix.getBetsProcessed() != maxTypeBets) throw;
96         
97         smartToken = SmartRouletteToken(0x7dD8D4c556d2005c5bafc3d5449A99Fb46279E6b);
98 
99         currentMaxBet = 2560 finney; // 2.56 ether
100         BlockDelay = 1;        
101         maxGamblesPerBlock = 5;
102         defaultMinCreditsOnBet = 1;   
103         ContractState  = true;  
104         bankrolLimit = 277 ether;
105         profitLimit  = 50 ether;
106         coef_player = 300;
107    }
108 
109    function changeMaxBet(uint256 newMaxBet) public onlyDeveloper 
110    {             
111       // rounds to 2 digts
112       newMaxBet = newMaxBet / 2560000000000000000 * 2560000000000000000;  
113       if (newMaxBet != currentMaxBet) 
114       {
115         currentMaxBet = newMaxBet;
116         SettingsChanged(currentMaxBet, currentMaxBet / 256,  defaultMinCreditsOnBet, minCreditsOnBet[uint8(BetTypes.low)], minCreditsOnBet[uint8(BetTypes.dozen1)], BlockDelay, ContractState);
117       }
118    }
119 
120    uint256 bankrolLimit;
121    uint256 profitLimit;
122    uint256 lastDistributedProfit;
123    uint256 lastDateDistributedProfit;
124    
125    function getDistributeProfitsInfo() public constant returns (uint256 lastProfit, uint256 lastDate)
126    {
127       lastProfit = lastDistributedProfit;
128       lastDate = lastDateDistributedProfit;
129    }
130 
131    function setProfitDistributionContract(address contractAddress) onlyDeveloper
132    {
133       if (profitDistributionContract > 0) throw;
134       profitDistributionContract = contractAddress;
135    }
136 
137    function setSmartAffiliateContract(address contractAddress) onlyDeveloper
138    {
139       if (address(smartAffiliateContract) > 0) throw;
140       smartAffiliateContract = SmartAffiliate(contractAddress);
141    }
142 
143    function distributeProfits(uint256 gasValue) onlyDeveloperOrOperator
144    {
145       if (profitDistributionContract > 0 && this.balance >= (bankrolLimit+profitLimit))
146       {
147          uint256 diff = this.balance - bankrolLimit;
148          if (address(profitDistributionContract).call.gas(gasValue).value(diff)() == false) throw;
149          lastDistributedProfit = diff;
150          lastDateDistributedProfit = block.timestamp;
151       }      
152    }
153 
154    function getTokenSettings() public constant returns(uint16 Coef_player, uint256 BankrolLimit, uint256 ProfitLimit)
155    {
156       Coef_player = coef_player;      
157       BankrolLimit = bankrolLimit;
158       ProfitLimit = profitLimit;
159    }
160 
161    function changeTokenSettings(uint16 newCoef_player, uint256 newBankrolLimit, uint256 newProfitLimit) onlyDeveloper
162    {
163       coef_player  = newCoef_player;      
164       bankrolLimit = newBankrolLimit;
165       profitLimit  = newProfitLimit;
166    }
167 
168    function changeSettings(uint64 NewMaxBetsPerBlock, uint8 NewBlockDelay, uint8 MinCreditsOnBet50, uint8 MinCreditsOnBet33, uint8 NewDefaultMinCreditsOnBet) onlyDeveloper
169    {     
170       BlockDelay = NewBlockDelay;     
171 
172       if (NewMaxBetsPerBlock != 0) maxGamblesPerBlock = NewMaxBetsPerBlock;     
173 
174       if (MinCreditsOnBet50 > 0)
175       {
176         minCreditsOnBet[uint8(BetTypes.low)]   = MinCreditsOnBet50;
177         minCreditsOnBet[uint8(BetTypes.high)]  = MinCreditsOnBet50;
178         minCreditsOnBet[uint8(BetTypes.red)]   = MinCreditsOnBet50;
179         minCreditsOnBet[uint8(BetTypes.black)] = MinCreditsOnBet50;
180         minCreditsOnBet[uint8(BetTypes.odd)]   = MinCreditsOnBet50;
181         minCreditsOnBet[uint8(BetTypes.even)]  = MinCreditsOnBet50;
182       }  
183 
184       if (MinCreditsOnBet33 > 0)
185       {
186         minCreditsOnBet[uint8(BetTypes.dozen1)] = MinCreditsOnBet33;
187         minCreditsOnBet[uint8(BetTypes.dozen2)] = MinCreditsOnBet33;
188         minCreditsOnBet[uint8(BetTypes.dozen3)] = MinCreditsOnBet33;
189         minCreditsOnBet[uint8(BetTypes.column1)] = MinCreditsOnBet33;
190         minCreditsOnBet[uint8(BetTypes.column2)] = MinCreditsOnBet33;
191         minCreditsOnBet[uint8(BetTypes.column3)] = MinCreditsOnBet33;
192       }
193 
194       if (NewDefaultMinCreditsOnBet > 0) defaultMinCreditsOnBet = NewDefaultMinCreditsOnBet;   
195    }
196    
197    function deleteContract() onlyDeveloper  
198    {
199         suicide(msg.sender);
200    }
201 
202    // bit from 0 to 255
203    function isBitSet(uint256 data, uint8 bit) private constant returns (bool ret)
204    {
205        assembly {
206             ret := iszero(iszero(and(data, exp(2,bit))))
207         }
208         return ret;
209    }
210 
211    // unique combination of bet and wheelResult, used for access to WinMatrix
212    function getIndex(uint16 bet, uint16 wheelResult) private constant returns (uint16)
213    {
214       return (bet+1)*256 + (wheelResult+1);
215    }
216 
217    // n form 1 <= to <= 32
218    function getBetValue(bytes32 values, uint8 n) private constant returns (uint256)
219    {
220         // bet in credits (1..256) 
221         uint256 bet = uint256(values[32-n])+1;
222 
223          // check min bet
224         uint8 minCredits = minCreditsOnBet[n];
225         if (minCredits == 0) minCredits = defaultMinCreditsOnBet;
226         if (bet < minCredits) throw;
227         
228         // bet in wei
229         bet = currentMaxBet*bet/256;
230         if (bet > currentMaxBet) throw;         
231 
232         return bet;        
233    }
234 
235    function getBetValueByGamble(GameInfo memory gamble, uint8 n) private constant returns (uint256) 
236    {
237       if (n<=32) return getBetValue(gamble.values, n);
238       if (n<=64) return getBetValue(gamble.values2, n-32);
239       // there are 64 maximum unique bets (positions) in one game
240       throw;
241    }
242   
243    function totalGames() constant returns (uint256)
244    {
245        return gambles.length;
246    }
247    
248    function getSettings() constant returns(uint256 maxBet, uint256 oneCredit, uint8 MinBetInCredits, uint8 MinBetInCredits_50,uint8 MinBetInCredits_33, uint8 blockDelayBeforeSpin, bool contractState)
249     {
250         maxBet    = currentMaxBet;
251         oneCredit = currentMaxBet / 256; 
252         blockDelayBeforeSpin = BlockDelay;        
253         MinBetInCredits      = defaultMinCreditsOnBet;
254         MinBetInCredits_50   = minCreditsOnBet[uint8(BetTypes.low)]; 
255         MinBetInCredits_33   = minCreditsOnBet[uint8(BetTypes.column1)]; 
256         contractState        = ContractState;
257     }
258    
259     modifier onlyDeveloper() 
260     {
261        if (msg.sender != developer) throw;
262        _;
263     }
264 
265     modifier onlyDeveloperOrOperator() 
266     {
267        if (msg.sender != developer && msg.sender != operator) throw;
268        _;
269     }
270 
271    function disableBetting_only_Dev()
272     onlyDeveloperOrOperator
273     {
274         ContractState=false;
275     }
276 
277 
278     function changeOperator(address newOperator) onlyDeveloper
279     {
280        operator = newOperator;
281     }
282 
283     function enableBetting_only_Dev()
284     onlyDeveloperOrOperator
285     {
286         ContractState=true;
287 
288     }
289 
290     event PlayerBet(uint256 gambleId, uint256 playerTokens);
291     event EndGame(address player, uint8 result, uint256 gambleId);
292     event SettingsChanged(uint256 maxBet, uint256 oneCredit, uint8 DefaultMinBetInCredits, uint8 MinBetInCredits50, uint8 MinBetInCredits33, uint8 blockDelayBeforeSpin, bool contractState);
293     event ErrorLog(address player, string message);
294     event GasLog(string msg, uint256 level, uint256 gas);
295 
296    function totalBetValue(GameInfo memory g) private constant returns (uint256)
297    {              
298        uint256 totalBetsValue = 0; 
299        uint8 nPlayerBetNo = 0;
300        uint8 betsCount = uint8(bytes32(g.bets)[0]);
301 
302        for(uint8 i = 0; i < maxTypeBets;i++) 
303         if (isBitSet(g.bets, i))
304         {
305           totalBetsValue += getBetValueByGamble(g, nPlayerBetNo+1);
306           nPlayerBetNo++;
307 
308           if (betsCount == 1) break;
309           betsCount--;          
310         }
311 
312        return totalBetsValue;
313    }
314 
315    function totalBetCount(GameInfo memory g) private constant returns (uint256)
316    {              
317        uint256 totalBets = 0; 
318        for(uint8 i=0; i < maxTypeBets;i++) 
319         if (isBitSet(g.bets, i)) totalBets++;          
320        return totalBets;   
321    }
322 
323    function placeBet(uint256 bets, bytes32 values1,bytes32 values2) public payable
324    {
325        if (ContractState == false)
326        {
327          ErrorLog(msg.sender, "ContractDisabled");
328          if (msg.sender.send(msg.value) == false) throw;
329          return;
330        } 
331 
332        var gamblesLength = gambles.length;
333 
334        if (gamblesLength > 0)
335        {
336           uint8 gamblesCountInCurrentBlock = 0;
337           for(var i = gamblesLength - 1;i > 0; i--)
338           {
339             if (gambles[i].blockNumber == block.number) 
340             {
341                if (gambles[i].player == msg.sender)
342                {
343                    ErrorLog(msg.sender, "Play twice the same block");
344                    if (msg.sender.send(msg.value) == false) throw;
345                    return;
346                }
347 
348                gamblesCountInCurrentBlock++;
349                if (gamblesCountInCurrentBlock >= maxGamblesPerBlock)
350                {
351                   ErrorLog(msg.sender, "maxGamblesPerBlock");
352                   if (msg.sender.send(msg.value) == false) throw;
353                   return;
354                }
355             }
356             else
357             {
358                break;
359             }
360           }
361        }
362        
363        var _currentMaxBet = currentMaxBet;
364 
365        if (msg.value < _currentMaxBet/256 || bets == 0)
366        {
367           ErrorLog(msg.sender, "Wrong bet value");
368           if (msg.sender.send(msg.value) == false) throw;
369           return;
370        }
371 
372        if (msg.value > _currentMaxBet)
373        {
374           ErrorLog(msg.sender, "Limit for table");
375           if (msg.sender.send(msg.value) == false) throw;
376           return;
377        }
378 
379        GameInfo memory g = GameInfo(msg.sender, block.number, 37, bets, values1,values2);
380 
381        if (totalBetValue(g) != msg.value)
382        {
383           ErrorLog(msg.sender, "Wrong bet value");
384           if (msg.sender.send(msg.value) == false) throw;
385           return;
386        }
387 
388        gambles.push(g);
389 
390        address affiliate = 0;
391        uint16 coef_affiliate = 0;
392        if (address(smartAffiliateContract) > 0)
393        {
394          (affiliate, coef_affiliate) = smartAffiliateContract.getAffiliateInfo(msg.sender);   
395        }
396        
397        uint256 playerTokens = smartToken.emission(msg.sender, affiliate, msg.value, coef_player, coef_affiliate);            
398 
399        PlayerBet(gamblesLength, playerTokens); 
400    }
401 
402     function Invest() payable onlyDeveloper
403     {
404       
405     }
406 
407     function GetGameIndexesToProcess() public constant returns (uint256[64] gameIndexes)
408     {           
409       uint8 index = 0;
410       for(int256 i = int256(gambles.length) - 1;i >= 0;i--)
411       {      
412          GameInfo memory g = gambles[uint256(i)];
413          if (block.number - g.blockNumber >= 256) break;
414 
415          if (g.wheelResult == 37 && block.number >= g.blockNumber + BlockDelay)
416          { 
417             gameIndexes[index++] = uint256(i + 1);
418          }
419       }      
420     }
421 
422     uint256 lastBlockGamesProcessed;
423 
424     function ProcessGames(uint256[] gameIndexes, bool simulate) 
425     {
426       if (!simulate)
427       {
428          if (lastBlockGamesProcessed == block.number)  return;
429          lastBlockGamesProcessed = block.number;
430       }
431 
432       uint8 delay = BlockDelay;
433       uint256 length = gameIndexes.length;
434       bool success = false;
435       for(uint256 i = 0;i < length;i++)
436       {      
437          if (ProcessGame(gameIndexes[i], delay) == GameStatus.Success) success = true;         
438       }      
439       if (simulate && !success) throw;
440     }
441     
442     function ProcessGameExt(uint256 index) public returns (GameStatus)
443     {
444       return ProcessGame(index, BlockDelay);
445     }
446 
447     function ProcessGame(uint256 index, uint256 delay) private returns (GameStatus)
448     {            
449       GameInfo memory g = gambles[index];
450       if (block.number - g.blockNumber >= 256) return GameStatus.Stop;
451 
452       if (g.wheelResult == 37 && block.number > g.blockNumber + delay)
453       {            
454          gambles[index].wheelResult = getRandomNumber(g.player, g.blockNumber);
455                  
456          uint256 playerWinnings = getGameResult(uint64(index));
457          if (playerWinnings > 0) 
458          {
459             if (g.player.send(playerWinnings) == false) throw;
460          }
461 
462          EndGame(g.player, gambles[index].wheelResult, index);
463          return GameStatus.Success;
464       }
465 
466       return GameStatus.Skipped;
467     }
468 
469     function getRandomNumber(address player, uint256 playerblock) private returns(uint8 wheelResult)
470     {
471         // block.blockhash - hash of the given block - only works for 256 most recent blocks excluding current
472         bytes32 blockHash = block.blockhash(playerblock+BlockDelay); 
473         
474         if (blockHash==0) 
475         {
476           ErrorLog(msg.sender, "Cannot generate random number");
477           wheelResult = 200;
478         }
479         else
480         {
481           bytes32 shaPlayer = sha3(player, blockHash);
482     
483           wheelResult = uint8(uint256(shaPlayer)%37);
484         }    
485     }
486 
487     function calculateRandomNumberByBlockhash(uint256 blockHash, address player) public constant returns (uint8 wheelResult) 
488     { 
489           bytes32 shaPlayer = sha3(player, blockHash);
490     
491           wheelResult = uint8(uint256(shaPlayer)%37);
492     }
493 
494     function emergencyFixGameResult(uint64 gambleId, uint256 blockHash) onlyDeveloperOrOperator
495     {
496       // Probably this function will never be called, but
497       // if game was not spinned in 256 blocks then block.blockhash will returns always 0 and 
498       // we should fix this manually (you can check result with public function calculateRandomNumberByBlockhash)
499       GameInfo memory gamble = gambles[gambleId];
500       if (gamble.wheelResult != 200) throw;
501 
502       gambles[gambleId].wheelResult = calculateRandomNumberByBlockhash(blockHash, gamble.player);
503       //gambles[gambleId].blockSpinned = block.number;
504 
505       if (gamble.player.send(getGameResult(gambleId)) == false) throw;
506 
507       EndGame(gamble.player, gamble.wheelResult, gambleId);
508     }
509 
510 
511     
512     //
513     function checkGamesReadyForSpinning() constant returns (int256[256] ret) 
514     { 
515       uint16 index = 0;    
516       for(int256 i = int256(gambles.length) - 1;i >= 0;i--)
517       {      
518          GameInfo memory g = gambles[uint256(i)];
519          if (block.number - g.blockNumber >= 256) return ;
520 
521          if (g.wheelResult == 37 && block.number > g.blockNumber + BlockDelay)
522          {            
523             ret[index++] = i+1;            
524          }               
525       } 
526     }
527 
528     function preliminaryGameResult(uint64 gambleIndex) constant returns (uint64 gambleId, address player, uint256 blockNumber, uint256 totalWin, uint8 wheelResult, uint256 bets, uint256 values1, uint256 values2, uint256 nTotalBetValue, uint256 nTotalBetCount) 
529     { 
530       GameInfo memory g = gambles[uint256(gambleIndex)];
531       
532       if (g.wheelResult == 37 && block.number > g.blockNumber + BlockDelay)
533       {
534          gambles[gambleIndex].wheelResult = getRandomNumber(g.player, g.blockNumber);
535          return getGame(gambleIndex);
536       }
537       throw;      
538     }
539 
540     function getGameResult(uint64 index) private constant returns (uint256 totalWin) 
541     {
542         GameInfo memory game = gambles[index];
543         totalWin = 0;
544         uint8 nPlayerBetNo = 0;
545         // we sent count bets at last byte 
546         uint8 betsCount = uint8(bytes32(game.bets)[0]); 
547         for(uint8 i=0; i<maxTypeBets; i++)
548         {                      
549             if (isBitSet(game.bets, i))
550             {              
551               var winMul = winMatrix.getCoeff(getIndex(i, game.wheelResult)); // get win coef
552               if (winMul > 0) winMul++; // + return player bet
553               totalWin += winMul * getBetValueByGamble(game, nPlayerBetNo+1);
554               nPlayerBetNo++; 
555 
556               if (betsCount == 1) break;
557               betsCount--;
558             }
559         }        
560     }
561 
562     function getGame(uint64 index) constant returns (uint64 gambleId, address player, uint256 blockNumber, uint256 totalWin, uint8 wheelResult, uint256 bets, uint256 values1, uint256 values2, uint256 nTotalBetValue, uint256 nTotalBetCount) 
563     {
564         gambleId = index;
565         player = gambles[index].player;
566         totalWin = getGameResult(index);
567         blockNumber = gambles[index].blockNumber;        
568         wheelResult = gambles[index].wheelResult;
569         nTotalBetValue = totalBetValue(gambles[index]);
570         nTotalBetCount = totalBetCount(gambles[index]);
571         bets = gambles[index].bets;
572         values1 = uint256(gambles[index].values);
573         values2 = uint256(gambles[index].values2);        
574     }
575 
576    function() 
577    {
578       throw;
579    }
580    
581 
582 }