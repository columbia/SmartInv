1 pragma solidity ^0.4.8;
2 
3 contract WinMatrix
4  {
5    function getCoeff(uint16 n) external returns (uint256);
6    function getBetsProcessed() external constant returns (uint16);
7  }
8 
9 contract SmartRoulette
10 {
11     address developer;
12     address operator;
13 
14     // Wait BlockDelay blocks before spin the wheel 
15     uint8 BlockDelay;
16 
17     // Maximum bet value for game
18     uint256 currentMaxBet;    
19 
20     // maximum games count per block
21     uint64 maxBetsPerBlock;
22     uint64 nbBetsCurrentBlock;
23     
24     // Enable\disable to place new bets
25     bool ContractState;
26 
27     // table with winner coefficients
28     WinMatrix winMatrix;
29 
30     uint16 constant maxTypeBets = 157;
31 
32     //
33     uint256 private SmartRouletteLimit = 1;
34 
35    // last game index for player (used for fast access)
36    mapping (address => uint64) private gambleIndex;   
37    
38    // 
39    uint8 defaultMinCreditsOnBet; 
40    //
41    mapping (uint8 => uint8) private minCreditsOnBet;
42 
43    struct Gamble
44    {
45         address player;
46         uint256 blockNumber;
47         uint256 blockSpinned;
48         uint8 wheelResult;
49         uint256 bets;
50         bytes32 values;
51         bytes32 values2;
52    }
53        
54    Gamble[] private gambles;
55 
56    enum BetTypes{number0, number1,number2,number3,number4,number5,number6,number7,number8,number9,
57      number10,number11,number12,number13,number14,number15,number16,number17,number18,number19,number20,number21,
58      number22,number23,number24,number25,number26,number27,number28,number29,number30,number31,number32,number33,
59      number34,number35,number36, red, black, odd, even, dozen1,dozen2,dozen3, column1,column2,column3, low,high,
60      pair_01, pair_02, pair_03, pair_12, pair_23, pair_36, pair_25, pair_14, pair_45, pair_56, pair_69, pair_58, pair_47,
61      pair_78, pair_89, pair_912, pair_811, pair_710, pair_1011, pair_1112, pair_1215, pair_1518, pair_1617, pair_1718, pair_1720,
62      pair_1619, pair_1922, pair_2023, pair_2124, pair_2223, pair_2324, pair_2528, pair_2629, pair_2730, pair_2829, pair_2930, pair_1114,
63      pair_1013, pair_1314, pair_1415, pair_1316, pair_1417, pair_1821, pair_1920, pair_2021, pair_2225, pair_2326, pair_2427, pair_2526,
64      pair_2627, pair_2831, pair_2932, pair_3033, pair_3132, pair_3233, pair_3134, pair_3235, pair_3336, pair_3435, pair_3536, corner_0_1_2_3,
65      corner_1_2_5_4, corner_2_3_6_5, corner_4_5_8_7, corner_5_6_9_8, corner_7_8_11_10, corner_8_9_12_11, corner_10_11_14_13, corner_11_12_15_14,
66      corner_13_14_17_16, corner_14_15_18_17, corner_16_17_20_19, corner_17_18_21_20, corner_19_20_23_22, corner_20_21_24_23, corner_22_23_26_25,
67      corner_23_24_27_26, corner_25_26_29_28, corner_26_27_30_29, corner_28_29_32_31, corner_29_30_33_32, corner_31_32_35_34, corner_32_33_36_35,
68      three_0_2_3, three_0_1_2, three_1_2_3, three_4_5_6, three_7_8_9, three_10_11_12, three_13_14_15, three_16_17_18, three_19_20_21, three_22_23_24,
69      three_25_26_27, three_28_29_30, three_31_32_33, three_34_35_36, six_1_2_3_4_5_6, six_4_5_6_7_8_9, six_7_8_9_10_11_12, six_10_11_12_13_14_15,
70      six_13_14_15_16_17_18, six_16_17_18_19_20_21, six_19_20_21_22_23_24, six_22_23_24_25_26_27, six_25_26_27_28_29_30, six_28_29_30_31_32_33,
71      six_31_32_33_34_35_36}
72    
73 
74    function SmartRoulette() internal
75    {        
76         developer  = msg.sender;
77         operator   = msg.sender;
78         
79         winMatrix = WinMatrix(0xDA16251B2977F86cB8d4C3318e9c6F92D7fC1A8f);
80         if (winMatrix.getBetsProcessed() != maxTypeBets) throw;
81 
82         BlockDelay = 1;        
83         maxBetsPerBlock = 5;
84         defaultMinCreditsOnBet = 1;   
85         ContractState  = true;  
86    }
87 
88    function updateMaxBet() private onlyDeveloper 
89    {      
90       uint256 newMaxBet = this.balance/(35*SmartRouletteLimit);
91 
92       // rounds to 2 digts
93       newMaxBet = newMaxBet / 2560000000000000000 * 2560000000000000000;  
94       if (newMaxBet != currentMaxBet) 
95       {
96         currentMaxBet = newMaxBet;
97         SettingsChanged(currentMaxBet, currentMaxBet / 256,  defaultMinCreditsOnBet, minCreditsOnBet[uint8(BetTypes.low)], minCreditsOnBet[uint8(BetTypes.dozen1)], BlockDelay, ContractState);
98       }
99    }
100 
101    function changeSettings(uint256 NewSmartRouletteLimit, uint64 NewMaxBetsPerBlock, uint8 NewBlockDelay, uint8 MinCreditsOnBet50, uint8 MinCreditsOnBet33, uint8 NewDefaultMinCreditsOnBet) onlyDeveloper
102    {
103      if (NewSmartRouletteLimit > 0) SmartRouletteLimit = NewSmartRouletteLimit;
104 
105      BlockDelay = NewBlockDelay;     
106 
107      if (NewMaxBetsPerBlock != 0) maxBetsPerBlock = NewMaxBetsPerBlock;     
108 
109       if (MinCreditsOnBet50 > 0)
110       {
111         minCreditsOnBet[uint8(BetTypes.low)] = MinCreditsOnBet50;
112         minCreditsOnBet[uint8(BetTypes.high)] = MinCreditsOnBet50;
113         minCreditsOnBet[uint8(BetTypes.red)] = MinCreditsOnBet50;
114         minCreditsOnBet[uint8(BetTypes.black)] = MinCreditsOnBet50;
115         minCreditsOnBet[uint8(BetTypes.odd)] = MinCreditsOnBet50;
116         minCreditsOnBet[uint8(BetTypes.even)] = MinCreditsOnBet50;
117       }  
118 
119       if (MinCreditsOnBet33 > 0)
120       {
121         minCreditsOnBet[uint8(BetTypes.dozen1)] = MinCreditsOnBet33;
122         minCreditsOnBet[uint8(BetTypes.dozen2)] = MinCreditsOnBet33;
123         minCreditsOnBet[uint8(BetTypes.dozen3)] = MinCreditsOnBet33;
124         minCreditsOnBet[uint8(BetTypes.column1)] = MinCreditsOnBet33;
125         minCreditsOnBet[uint8(BetTypes.column2)] = MinCreditsOnBet33;
126         minCreditsOnBet[uint8(BetTypes.column3)] = MinCreditsOnBet33;
127       }
128 
129       if (NewDefaultMinCreditsOnBet > 0) defaultMinCreditsOnBet = NewDefaultMinCreditsOnBet;
130 
131      updateMaxBet();
132    }
133    
134    function deleteContract() onlyDeveloper  
135    {
136         suicide(msg.sender);
137    }
138 
139    // bit from 0 to 255
140    function isBitSet(uint256 data, uint8 bit) private constant returns (bool ret)
141    {
142        assembly {
143             ret := iszero(iszero(and(data, exp(2,bit))))
144         }
145         return ret;
146    }
147 
148    // unique combination of bet and wheelResult, used for access to WinMatrix
149    function getIndex(uint16 bet, uint16 wheelResult) private constant returns (uint16)
150    {
151       return (bet+1)*256 + (wheelResult+1);
152    }
153 
154    // n form 1 <= to <= 32
155    function getBetValue(bytes32 values, uint8 n) private constant returns (uint256)
156    {
157         // bet in credits (1..256) 
158         uint256 bet = uint256(values[32-n])+1;
159 
160          // check min bet
161         uint8 minCredits = minCreditsOnBet[n];
162         if (minCredits == 0) minCredits = defaultMinCreditsOnBet;
163         if (bet < minCredits) throw;
164         
165         // bet in wei
166         bet = currentMaxBet*bet/256;
167         if (bet > currentMaxBet) throw;         
168 
169         return bet;        
170    }
171 
172    function getBetValueByGamble(Gamble gamble, uint8 n) private constant returns (uint256) 
173    {
174       if (n<=32) return getBetValue(gamble.values, n);
175       if (n<=64) return getBetValue(gamble.values2, n-32);
176       // there are 64 maximum unique bets (positions) in one game
177       throw;
178    }
179   
180    function totalGames() constant returns (uint256)
181    {
182        return gambles.length;
183    }
184    
185    function getSettings() constant returns(uint256 maxBet, uint256 oneCredit, uint8 MinBetInCredits, uint8 MinBetInCredits_50,uint8 MinBetInCredits_33, uint8 blockDelayBeforeSpin, bool contractState)
186     {
187         maxBet=currentMaxBet;
188         oneCredit=currentMaxBet / 256; 
189         blockDelayBeforeSpin=BlockDelay;        
190         MinBetInCredits = defaultMinCreditsOnBet;
191         MinBetInCredits_50 = minCreditsOnBet[uint8(BetTypes.low)]; 
192         MinBetInCredits_33 = minCreditsOnBet[uint8(BetTypes.column1)]; 
193         contractState = ContractState;
194         return;
195     }
196    
197     modifier onlyDeveloper() 
198     {
199        if (msg.sender != developer) throw;
200        _;
201     }
202 
203     modifier onlyDeveloperOrOperator() 
204     {
205        if (msg.sender != developer && msg.sender != operator) throw;
206        _;
207     }
208 
209    function disableBetting_only_Dev()
210     onlyDeveloperOrOperator
211     {
212         ContractState=false;
213     }
214 
215 
216     function changeOperator(address newOperator) onlyDeveloper
217     {
218        operator = newOperator;
219     }
220 
221     function enableBetting_only_Dev()
222     onlyDeveloperOrOperator
223     {
224         ContractState=true;
225 
226     }
227 
228     event PlayerBet(address player, uint256 block, uint256 gambleId);
229     event EndGame(address player, uint8 result, uint256 gambleId);
230     event SettingsChanged(uint256 maxBet, uint256 oneCredit, uint8 DefaultMinBetInCredits, uint8 MinBetInCredits50, uint8 MinBetInCredits33, uint8 blockDelayBeforeSpin, bool contractState);
231     event ErrorLog(address player, string message);
232 
233    function totalBetValue(Gamble g) private constant returns (uint256)
234    {              
235        uint256 totalBetsValue = 0; 
236        uint8 nPlayerBetNo = 0;
237        for(uint8 i=0; i < maxTypeBets;i++) 
238         if (isBitSet(g.bets, i))
239         {
240           totalBetsValue += getBetValueByGamble(g, nPlayerBetNo+1);
241           nPlayerBetNo++;
242         }
243 
244        return totalBetsValue;
245    }
246 
247    function totalBetCount(Gamble g) private constant returns (uint256)
248    {              
249        uint256 totalBets = 0; 
250        for(uint8 i=0; i < maxTypeBets;i++) 
251         if (isBitSet(g.bets, i)) totalBets++;          
252        return totalBets;   
253    }
254 
255    function placeBet(uint256 bets, bytes32 values1,bytes32 values2)  payable
256    {
257        if (ContractState == false)
258        {
259          ErrorLog(msg.sender, "ContractDisabled");
260          if (msg.sender.send(msg.value) == false) throw;
261          return;
262        } 
263 
264        if (nbBetsCurrentBlock >= maxBetsPerBlock) 
265        {
266          ErrorLog(msg.sender, "checkNbBetsCurrentBlock");
267          if (msg.sender.send(msg.value) == false) throw;
268          return;
269        }
270 
271        if (msg.value < currentMaxBet/256 || bets == 0)
272        {
273           ErrorLog(msg.sender, "Wrong bet value");
274           if (msg.sender.send(msg.value) == false) throw;
275           return;
276        }
277 
278        if (msg.value > currentMaxBet)
279        {
280           ErrorLog(msg.sender, "Limit for table");
281           if (msg.sender.send(msg.value) == false) throw;
282           return;
283        }
284 
285        Gamble memory g = Gamble(msg.sender, block.number, 0, 37, bets, values1,values2);
286 
287        if (totalBetValue(g) != msg.value)
288        {
289           ErrorLog(msg.sender, "Wrong bet value");
290           if (msg.sender.send(msg.value) == false) throw;
291           return;
292        }       
293 
294        uint64 index = gambleIndex[msg.sender];
295        if (index != 0)
296        {
297           if (gambles[index-1].wheelResult == 37) 
298           {
299             ErrorLog(msg.sender, "previous game is not finished");
300             if (msg.sender.send(msg.value) == false) throw;
301             return;
302           }
303        }
304 
305        if (gambles.length != 0 && block.number==gambles[gambles.length-1].blockNumber) 
306         nbBetsCurrentBlock++;
307        else 
308         nbBetsCurrentBlock = 0;
309 
310        // gambleIndex is index of gambles array + 1
311        gambleIndex[msg.sender] = uint64(gambles.length + 1);
312 
313        gambles.push(g);
314             
315        PlayerBet(msg.sender, block.number, gambles.length - 1);
316    }
317 
318     function Invest() payable
319     {
320       updateMaxBet();
321     }
322 
323     function SpinTheWheel(address playerSpinned) 
324     {
325         if (playerSpinned==0){
326            playerSpinned=msg.sender;
327         }
328 
329         uint64 index = gambleIndex[playerSpinned];
330         if (index == 0) 
331         {
332           ErrorLog(playerSpinned, "No games for player");
333           return;
334         }
335         index--;        
336 
337         if (gambles[index].wheelResult != 37)
338         {
339           ErrorLog(playerSpinned, "Gamble already spinned");
340           return;
341         } 
342 
343         uint256 playerblock = gambles[index].blockNumber;
344         
345         if (block.number <= playerblock + BlockDelay) 
346         {
347           ErrorLog(msg.sender, "Wait for playerblock+blockDelay");
348           return;          
349         }
350 
351         gambles[index].wheelResult = getRandomNumber(gambles[index].player, playerblock);
352         gambles[index].blockSpinned = block.number;
353         
354         if (gambles[index].player.send(getGameResult(index)) == false) throw;
355 
356         EndGame(gambles[index].player, gambles[index].wheelResult, index);        
357     }
358 
359     function getRandomNumber(address player, uint256 playerblock) private returns(uint8 wheelResult)
360     {
361         // block.blockhash - hash of the given block - only works for 256 most recent blocks excluding current
362         bytes32 blockHash = block.blockhash(playerblock+BlockDelay); 
363         
364         if (blockHash==0) 
365         {
366           ErrorLog(msg.sender, "Cannot generate random number");
367           wheelResult = 200;
368         }
369         else
370         {
371           bytes32 shaPlayer = sha3(player, blockHash);
372     
373           wheelResult = uint8(uint256(shaPlayer)%37);
374         }    
375     }
376 
377     function calculateRandomNumberByBlockhash(uint256 blockHash, address player) public constant returns (uint8 wheelResult) 
378     { 
379           bytes32 shaPlayer = sha3(player, blockHash);
380     
381           wheelResult = uint8(uint256(shaPlayer)%37);
382     }
383 
384     function emergencyFixGameResult(uint64 gambleId, uint256 blockHash) onlyDeveloperOrOperator
385     {
386       // Probably this function will never be called, but
387       // if game was not spinned in 256 blocks then block.blockhash will returns always 0 and 
388       // we should fix this manually (you can check result with public function calculateRandomNumberByBlockhash)
389       Gamble memory gamble = gambles[gambleId];
390       if (gamble.wheelResult != 200) throw;
391 
392       gambles[gambleId].wheelResult = calculateRandomNumberByBlockhash(blockHash, gamble.player);
393       gambles[gambleId].blockSpinned = block.number;
394 
395       if (gamble.player.send(getGameResult(gambleId)) == false) throw;
396 
397       EndGame(gamble.player, gamble.wheelResult, gambleId);
398     }
399 
400     // 
401     function checkGameResult(address playerSpinned) constant returns (uint64 gambleId, address player, uint256 blockNumber, uint256 blockSpinned, uint256 totalWin, uint8 wheelResult, uint256 bets, uint256 values1, uint256 values2, uint256 nTotalBetValue, uint256 nTotalBetCount) 
402     {
403         if (playerSpinned==0){
404            playerSpinned=msg.sender;
405         }
406 
407         uint64 index = gambleIndex[playerSpinned];
408         if (index == 0) throw;
409         index--;        
410 
411         uint256 playerblock = gambles[index].blockNumber;        
412         if (block.number <= playerblock + BlockDelay) throw;
413         
414         gambles[index].wheelResult = getRandomNumber(gambles[index].player, playerblock);
415         gambles[index].blockSpinned = block.number;
416         
417         return getGame(index);      
418     }
419 
420     function getGameResult(uint64 index) private constant returns (uint256 totalWin) 
421     {
422         Gamble memory game = gambles[index];
423         totalWin = 0;
424         uint8 nPlayerBetNo = 0;
425         for(uint8 i=0; i<maxTypeBets; i++)
426         {                      
427             if (isBitSet(game.bets, i))
428             {              
429               var winMul = winMatrix.getCoeff(getIndex(i, game.wheelResult)); // get win coef
430               if (winMul > 0) winMul++; // + return player bet
431               totalWin += winMul * getBetValueByGamble(game, nPlayerBetNo+1);
432               nPlayerBetNo++; 
433             }
434         }
435         if (totalWin == 0) totalWin = 1 wei; // 1 wei if lose                      
436     }
437 
438     function getGame(uint64 index) constant returns (uint64 gambleId, address player, uint256 blockNumber, uint256 blockSpinned, uint256 totalWin, uint8 wheelResult, uint256 bets, uint256 values1, uint256 values2, uint256 nTotalBetValue, uint256 nTotalBetCount) 
439     {
440         gambleId = index;
441         player = gambles[index].player;
442         totalWin = getGameResult(index);
443         blockNumber = gambles[index].blockNumber;
444         blockSpinned = gambles[index].blockSpinned;
445         wheelResult = gambles[index].wheelResult;
446         nTotalBetValue = totalBetValue(gambles[index]);
447         nTotalBetCount = totalBetCount(gambles[index]);
448         bets = gambles[index].bets;
449         values1 = uint256(gambles[index].values);
450         values2 = uint256(gambles[index].values2);        
451     }
452 
453    function() 
454    {
455       throw;
456    }
457    
458 
459 }