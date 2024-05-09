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
11    function emission(address player, address partner, uint256 value_bet, uint256 coef_player, uint256 coef_partner) external returns(uint256, uint8);
12    function isOperationBlocked() external constant returns (bool);
13 }
14 
15 contract SmartAffiliate 
16 {   
17    function getAffiliateInfo(address player) external constant returns(address affiliate, uint16 coef_affiliate, uint16 coef_player);
18 }
19 
20 /*
21 ** User interface for SmartRoulette https://smartroulette.io
22 */
23 contract SmartRoulette
24 {
25   address developer;
26   address operator;
27 
28   // Wait BlockDelay blocks before generate random number
29   uint8 BlockDelay;
30 
31   // Maximum bet value for game (one credit is currentMaxBet/256)
32   uint256 currentMaxBet;    
33 
34   // maximum games count per block
35   uint64 maxGamblesPerBlock;
36         
37   // Enable\disable to place new bets
38   bool ContractState;
39 
40   // table with winner coefficients
41   WinMatrix winMatrix;
42 
43   SmartRouletteToken smartToken;
44 
45   address public profitDistributionContract;
46 
47   SmartAffiliate smartAffiliateContract;
48 
49   uint16 constant maxTypeBets = 157;
50   
51   // Default coef for token emission (if SmartAffiliate contract is not setup)
52   uint16 CoefPlayerEmission;   
53   // 
54   mapping (uint8 => uint8) private minCreditsOnBet;
55   mapping (uint8 => uint8) private maxCreditsOnBet;
56 
57   struct GameInfo
58   {
59        address player;
60        uint256 blockNumber;
61        uint8 wheelResult;
62        uint256 bets;
63        bytes32 values;
64        bytes32 values2;
65   } 
66        
67   GameInfo[] private gambles;
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
94         winMatrix = WinMatrix(0x073D6621E9150bFf9d1D450caAd3c790b6F071F2);
95         if (winMatrix.getBetsProcessed() != maxTypeBets) throw;
96         
97         smartToken = SmartRouletteToken(0xcced5b8288086be8c38e23567e684c3740be4d48);
98 
99         currentMaxBet = 2560 finney; // 2.56 ether
100         BlockDelay = 1;        
101         maxGamblesPerBlock = 5;        
102         ContractState  = true;  
103         bankrolLimit = 277 ether;
104         profitLimit  = 50 ether;
105         CoefPlayerEmission = 100; // default 1%
106    }
107 
108    function changeSettings(uint256 newMaxBet, uint8 newBlockDelay) public onlyDeveloper 
109    {             
110       BlockDelay = newBlockDelay;
111       // rounds to 2 digts
112       newMaxBet = newMaxBet / 2560000000000000000 * 2560000000000000000;  
113       if (newMaxBet != currentMaxBet) 
114       {
115         currentMaxBet = newMaxBet;
116         SettingsChanged();
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
156       Coef_player = CoefPlayerEmission;      
157       BankrolLimit = bankrolLimit;
158       ProfitLimit = profitLimit;
159    }
160 
161    function changeTokenSettings(uint16 newCoef_player, uint256 newBankrolLimit, uint256 newProfitLimit) onlyDeveloper
162    {
163       CoefPlayerEmission  = newCoef_player;      
164       bankrolLimit = newBankrolLimit;
165       profitLimit  = newProfitLimit;
166    }
167 
168    function changeMinBet(uint8[157] value) onlyDeveloper
169    {
170      // value[i] == 0 means skip this value
171      // value[i] == 255 means value will be 0
172      // Raw mapping minCreditsOnBet changes from 0 to 254, 
173      // when compare with real bet we add +1, so min credits changes from 1 to 255
174      for(var i=0;i<157;i++) 
175      {
176         if (value[i] > 0) 
177         {
178            if (value[i] == 255)
179              minCreditsOnBet[i] = 0;     
180            else  
181              minCreditsOnBet[i] = value[i];
182         }
183      }
184      SettingsChanged();
185    }
186 
187    function changeMaxBet(uint8[157] value) onlyDeveloper
188    {
189      // value[i] == 0 means skip this value
190      // value[i] == 255 means value will be 0
191      // Raw mapping maxCreditsOnBet hold values that reduce max bet from 255 to 0     
192      // If we want to calculate real max bet value we should do: 256 - maxCreditsOnBet[i]
193      // example: if mapping holds 0 it means, that max bet will be 256 - 0 = 256
194      //          if mapping holds 50 it means, that max bet will be 256 - 50 = 206 
195      for(var i=0;i<157;i++) 
196      {
197        if (value[i] > 0) 
198        {
199           if (value[i] == 255)
200              maxCreditsOnBet[i] = 0;     
201            else  
202              maxCreditsOnBet[i] = 255 - value[i];              
203        }
204      }
205      SettingsChanged();
206    }
207    
208    function deleteContract() onlyDeveloper  
209    {
210         suicide(msg.sender);
211    }
212 
213    // bit from 0 to 255
214    function isBitSet(uint256 data, uint8 bit) private constant returns (bool ret)
215    {
216        assembly {
217             ret := iszero(iszero(and(data, exp(2,bit))))
218         }
219         return ret;
220    }
221 
222    // unique combination of bet and wheelResult, used for access to WinMatrix
223    function getIndex(uint16 bet, uint16 wheelResult) private constant returns (uint16)
224    {
225       return (bet+1)*256 + (wheelResult+1);
226    }
227 
228    // n form 1 <= to <= 32
229    function getBetValue(bytes32 values, uint8 n, uint8 nBit) private constant returns (uint256)
230    {
231         // bet in credits (1..256) 
232         uint256 bet = uint256(values[32 - n]) + 1;
233 
234         if (bet < uint256(minCreditsOnBet[nBit]+1)) throw;   //default: bet < 0+1
235         if (bet > uint256(256-maxCreditsOnBet[nBit])) throw; //default: bet > 256-0      
236 
237         return currentMaxBet * bet / 256;        
238    }
239 
240    // n - number player bet
241    // nBit - betIndex
242    function getBetValueByGamble(GameInfo memory gamble, uint8 n, uint8 nBit) private constant returns (uint256) 
243    {
244       if (n <= 32) return getBetValue(gamble.values , n, nBit);
245       if (n <= 64) return getBetValue(gamble.values2, n - 32, nBit);
246       // there are 64 maximum unique bets (positions) in one game
247       throw;
248    }
249   
250    function totalGames() constant returns (uint256)
251    {
252        return gambles.length;
253    }
254    
255    function getSettings() constant returns(uint256 maxBet, uint256 oneCredit, uint8[157] _minCreditsOnBet, uint8[157] _maxCreditsOnBet, uint8 blockDelay, bool contractState)
256     {
257         maxBet    = currentMaxBet;
258         oneCredit = currentMaxBet / 256; 
259         blockDelay = BlockDelay;      
260         for(var i = 0;i < maxTypeBets;i++)  
261         {
262           _minCreditsOnBet[i] = minCreditsOnBet[i] + 1;
263           _maxCreditsOnBet[i] = 255 - maxCreditsOnBet[i];
264         }     
265         contractState        = ContractState;
266     }
267    
268     modifier onlyDeveloper() 
269     {
270        if (msg.sender != developer) throw;
271        _;
272     }
273 
274     modifier onlyDeveloperOrOperator() 
275     {
276        if (msg.sender != developer && msg.sender != operator) throw;
277        _;
278     }
279 
280    function disableBetting_only_Dev()
281     onlyDeveloperOrOperator
282     {
283         ContractState=false;
284     }
285 
286 
287     function changeOperator(address newOperator) onlyDeveloper
288     {
289        operator = newOperator;
290     }
291 
292     function enableBetting_only_Dev()
293     onlyDeveloperOrOperator
294     {
295         ContractState=true;
296 
297     }
298 
299     event PlayerBet(uint256 gambleId, uint256 playerTokens);
300     event EndGame(address player, uint8 result, uint256 gambleId);
301     event SettingsChanged();
302     event ErrorLog(address player, string message);
303     event GasLog(string msg, uint256 level, uint256 gas);
304 
305    function totalBetValue(GameInfo memory g) private constant returns (uint256)
306    {              
307        uint256 totalBetsValue = 0; 
308        uint8 nPlayerBetNo = 0;
309        uint8 betsCount = uint8(bytes32(g.bets)[0]);
310 
311        for(uint8 i = 0; i < maxTypeBets;i++) 
312         if (isBitSet(g.bets, i))
313         {
314           totalBetsValue += getBetValueByGamble(g, nPlayerBetNo+1, i);
315           nPlayerBetNo++;
316 
317           if (betsCount == 1) break;
318           betsCount--;          
319         }
320 
321        return totalBetsValue;
322    }
323 
324    function totalBetCount(GameInfo memory g) private constant returns (uint256)
325    {              
326        uint256 totalBets = 0; 
327        for(uint8 i=0; i < maxTypeBets;i++) 
328         if (isBitSet(g.bets, i)) totalBets++;          
329        return totalBets;   
330    }
331 
332    function placeBet(uint256 bets, bytes32 values1,bytes32 values2) public payable
333    {
334        if (ContractState == false)
335        {
336          ErrorLog(msg.sender, "ContractDisabled");
337          if (msg.sender.send(msg.value) == false) throw;
338          return;
339        }
340 
341        var gamblesLength = gambles.length;
342 
343        if (gamblesLength > 0)
344        {
345           uint8 gamblesCountInCurrentBlock = 0;
346           for(var i = gamblesLength - 1;i > 0; i--)
347           {
348             if (gambles[i].blockNumber == block.number) 
349             {
350                if (gambles[i].player == msg.sender)
351                {
352                    ErrorLog(msg.sender, "Play twice the same block");
353                    if (msg.sender.send(msg.value) == false) throw;
354                    return;
355                }
356 
357                gamblesCountInCurrentBlock++;
358                if (gamblesCountInCurrentBlock >= maxGamblesPerBlock)
359                {
360                   ErrorLog(msg.sender, "maxGamblesPerBlock");
361                   if (msg.sender.send(msg.value) == false) throw;
362                   return;
363                }
364             }
365             else
366             {
367                break;
368             }
369           }
370        }
371        
372        var _currentMaxBet = currentMaxBet;
373 
374        if (msg.value < _currentMaxBet/256 || bets == 0)
375        {
376           ErrorLog(msg.sender, "Wrong bet value");
377           if (msg.sender.send(msg.value) == false) throw;
378           return;
379        }
380 
381        if (msg.value > _currentMaxBet)
382        {
383           ErrorLog(msg.sender, "Limit for table");
384           if (msg.sender.send(msg.value) == false) throw;
385           return;
386        }
387 
388        GameInfo memory g = GameInfo(msg.sender, block.number, 37, bets, values1,values2);
389 
390        if (totalBetValue(g) != msg.value)
391        {
392           ErrorLog(msg.sender, "Wrong bet value");
393           if (msg.sender.send(msg.value) == false) throw;
394           return;
395        }       
396 
397        address affiliate = 0;
398        uint16 coef_affiliate = 0;
399        uint16 coef_player;
400        if (address(smartAffiliateContract) > 0)
401        {        
402          (affiliate, coef_affiliate, coef_player) = smartAffiliateContract.getAffiliateInfo(msg.sender);   
403        }
404        else
405        {
406          coef_player = CoefPlayerEmission;
407        }
408 
409        uint256 playerTokens;
410        uint8 errorCodeEmission;
411        
412        (playerTokens, errorCodeEmission) = smartToken.emission(msg.sender, affiliate, msg.value, coef_player, coef_affiliate);
413        if (errorCodeEmission != 0)
414        {
415           if (errorCodeEmission == 1) 
416             ErrorLog(msg.sender, "token operations stopped");
417           else if (errorCodeEmission == 2) 
418             ErrorLog(msg.sender, "contract is not in a games list");
419           else if (errorCodeEmission == 3) 
420             ErrorLog(msg.sender, "incorect player address");
421           else if (errorCodeEmission == 4) 
422             ErrorLog(msg.sender, "incorect value bet");
423           else if (errorCodeEmission == 5) 
424             ErrorLog(msg.sender, "incorect Coefficient emissions");
425           
426           if (msg.sender.send(msg.value) == false) throw;
427           return;
428        }
429 
430        gambles.push(g);
431 
432        PlayerBet(gamblesLength, playerTokens); 
433    }
434 
435     function Invest() payable onlyDeveloper
436     {      
437     }
438 
439     function GetGameIndexesToProcess() public constant returns (uint256[64] gameIndexes)
440     {           
441       uint8 index = 0;
442       for(int256 i = int256(gambles.length) - 1;i >= 0;i--)
443       {      
444          GameInfo memory g = gambles[uint256(i)];
445          if (block.number - g.blockNumber >= 256) break;
446 
447          if (g.wheelResult == 37 && block.number >= g.blockNumber + BlockDelay)
448          { 
449             gameIndexes[index++] = uint256(i + 1);
450          }
451       }      
452     }
453 
454     uint256 lastBlockGamesProcessed;
455 
456     function ProcessGames(uint256[] gameIndexes, bool simulate) 
457     {
458       if (!simulate)
459       {
460          if (lastBlockGamesProcessed == block.number)  return;
461          lastBlockGamesProcessed = block.number;
462       }
463 
464       uint8 delay = BlockDelay;
465       uint256 length = gameIndexes.length;
466       bool success = false;
467       for(uint256 i = 0;i < length;i++)
468       {      
469          if (ProcessGame(gameIndexes[i], delay) == GameStatus.Success) success = true;         
470       }      
471       if (simulate && !success) throw;
472     }
473     
474     function ProcessGameExt(uint256 index) public returns (GameStatus)
475     {
476       return ProcessGame(index, BlockDelay);
477     }
478 
479     function ProcessGame(uint256 index, uint256 delay) private returns (GameStatus)
480     {            
481       GameInfo memory g = gambles[index];
482       if (block.number - g.blockNumber >= 256) return GameStatus.Stop;
483 
484       if (g.wheelResult == 37 && block.number > g.blockNumber + delay)
485       {            
486          gambles[index].wheelResult = getRandomNumber(g.player, g.blockNumber);
487                  
488          uint256 playerWinnings = getGameResult(gambles[index]);
489          if (playerWinnings > 0) 
490          {
491             if (g.player.send(playerWinnings) == false) throw;
492          }
493 
494          EndGame(g.player, gambles[index].wheelResult, index);
495          return GameStatus.Success;
496       }
497 
498       return GameStatus.Skipped;
499     }
500 
501     function getRandomNumber(address player, uint256 playerblock) private returns(uint8 wheelResult)
502     {
503         // block.blockhash - hash of the given block - only works for 256 most recent blocks excluding current
504         bytes32 blockHash = block.blockhash(playerblock+BlockDelay); 
505         
506         if (blockHash==0) 
507         {
508           ErrorLog(msg.sender, "Cannot generate random number");
509           wheelResult = 200;
510         }
511         else
512         {
513           bytes32 shaPlayer = sha3(player, blockHash);
514     
515           wheelResult = uint8(uint256(shaPlayer)%37);
516         }    
517     }
518 
519     function calculateRandomNumberByBlockhash(uint256 blockHash, address player) public constant returns (uint8 wheelResult) 
520     { 
521           bytes32 shaPlayer = sha3(player, blockHash);
522     
523           wheelResult = uint8(uint256(shaPlayer)%37);
524     }
525 
526     function emergencyFixGameResult(uint64 gambleId, uint256 blockHash) onlyDeveloperOrOperator
527     {
528       // Probably this function will never be called, but
529       // if game was not spinned in 256 blocks then block.blockhash will returns always 0 and 
530       // we should fix this manually (you can check result with public function calculateRandomNumberByBlockhash)
531       GameInfo memory gamble = gambles[gambleId];
532       if (gamble.wheelResult != 200) throw;
533 
534       gambles[gambleId].wheelResult = calculateRandomNumberByBlockhash(blockHash, gamble.player);      
535 
536       uint256 playerWinnings = getGameResult(gambles[gambleId]);
537       if (playerWinnings > 0)
538       {
539         if (gamble.player.send(playerWinnings) == false) throw;
540       }      
541 
542       EndGame(gamble.player, gamble.wheelResult, gambleId);
543     }
544 
545 
546     function preliminaryGameResult(uint64 gambleIndex) constant returns (uint64 gambleId, address player, uint256 blockNumber, uint256 totalWin, uint8 wheelResult, uint256 bets, uint256 values1, uint256 values2, uint256 nTotalBetValue, uint256 nTotalBetCount) 
547     { 
548       GameInfo memory g = gambles[uint256(gambleIndex)];
549       
550       if (g.wheelResult == 37 && block.number > g.blockNumber + BlockDelay)
551       {
552          gambles[gambleIndex].wheelResult = getRandomNumber(g.player, g.blockNumber);
553          return getGame(gambleIndex);
554       }
555       throw;      
556     }
557 
558     // Preliminary game result before real transaction is mined
559     function calcRandomNumberAndGetPreliminaryGameResult(uint256 blockHash, uint64 gambleIndex) constant returns (uint64 gambleId, address player, uint256 blockNumber, uint256 totalWin, uint8 wheelResult, uint256 bets, uint256 values1, uint256 values2, uint256 nTotalBetValue, uint256 nTotalBetCount)
560     { 
561       GameInfo memory g = gambles[uint256(gambleIndex)];      
562       g.wheelResult = calculateRandomNumberByBlockhash(blockHash, g.player);      
563 
564       gambleId = gambleIndex;
565       player = g.player;
566       wheelResult = g.wheelResult;      
567       totalWin = getGameResult(g);
568       blockNumber = g.blockNumber;              
569       nTotalBetValue = totalBetValue(g);
570       nTotalBetCount = totalBetCount(g);
571       bets = g.bets;
572       values1 = uint256(g.values);
573       values2 = uint256(g.values2);     
574     }
575 
576     function getGameResult(GameInfo memory game) private constant returns (uint256 totalWin) 
577     {
578         totalWin = 0;
579         uint8 nPlayerBetNo = 0;
580         // we sent count bets at last byte 
581         uint8 betsCount = uint8(bytes32(game.bets)[0]); 
582         for(uint8 i=0; i<maxTypeBets; i++)
583         {                      
584             if (isBitSet(game.bets, i))
585             {              
586               var winMul = winMatrix.getCoeff(getIndex(i, game.wheelResult)); // get win coef
587               if (winMul > 0) winMul++; // + return player bet
588               totalWin += winMul * getBetValueByGamble(game, nPlayerBetNo+1,i);
589               nPlayerBetNo++; 
590 
591               if (betsCount == 1) break;
592               betsCount--;
593             }
594         }        
595     }
596 
597     function getGame(uint64 index) constant returns (uint64 gambleId, address player, uint256 blockNumber, uint256 totalWin, uint8 wheelResult, uint256 bets, uint256 values1, uint256 values2, uint256 nTotalBetValue, uint256 nTotalBetCount) 
598     {
599         gambleId = index;
600         player = gambles[index].player;
601         totalWin = getGameResult(gambles[index]);
602         blockNumber = gambles[index].blockNumber;        
603         wheelResult = gambles[index].wheelResult;
604         nTotalBetValue = totalBetValue(gambles[index]);
605         nTotalBetCount = totalBetCount(gambles[index]);
606         bets = gambles[index].bets;
607         values1 = uint256(gambles[index].values);
608         values2 = uint256(gambles[index].values2);        
609     }
610 
611    function() 
612    {
613       throw;
614    }
615    
616 
617 }