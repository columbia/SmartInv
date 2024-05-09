1 pragma solidity ^0.4.24;
2 
3 //
4 //                       .#########'
5 //                    .###############+
6 //                  ,####################
7 //                `#######################+
8 //               ;##########################
9 //              #############################.
10 //             ###############################,
11 //           +##################,    ###########`
12 //          .###################     .###########
13 //         ##############,          .###########+
14 //         #############`            .############`
15 //         ###########+                ############
16 //        ###########;                  ###########
17 //        ##########'                    ###########                                                                                      
18 //       '##########    '#.        `,     ##########                                                                                    
19 //       ##########    ####'      ####.   :#########;                                                                                   
20 //      `#########'   :#####;    ######    ##########                                                                                 
21 //      :#########    #######:  #######    :#########         
22 //      +#########    :#######.########     #########`       
23 //      #########;     ###############'     #########:       
24 //      #########       #############+      '########'        
25 //      #########        ############       :#########        
26 //      #########         ##########        ,#########        
27 //      #########         :########         ,#########        
28 //      #########        ,##########        ,#########        
29 //      #########       ,############       :########+        
30 //      #########      .#############+      '########'        
31 //      #########:    `###############'     #########,        
32 //      +########+    ;#######`;#######     #########         
33 //      ,#########    '######`  '######    :#########         
34 //       #########;   .#####`    '#####    ##########         
35 //       ##########    '###`      +###    :#########:         
36 //       ;#########+     `                ##########          
37 //        ##########,                    ###########          
38 //         ###########;                ############
39 //         +############             .############`
40 //          ###########+           ,#############;
41 //          `###########     ;++#################
42 //           :##########,    ###################
43 //            '###########.'###################
44 //             +##############################
45 //              '############################`
46 //               .##########################
47 //                 #######################:
48 //                   ###################+
49 //                     +##############:
50 //                        :#######+`
51 //
52 //
53 //
54 // Play0x.com (The ONLY gaming platform for all ERC20 Tokens)
55 // -------------------------------------------------------------------------------------------------------
56 // * Multiple types of game platforms
57 // * Build your own game zone - Not only playing games, but also allowing other players to join your game.
58 // * Support all ERC20 tokens.
59 //
60 //
61 //
62 // 0xC Token (Contract address : 0x60d8234a662651e586173c17eb45ca9833a7aa6c)
63 // -------------------------------------------------------------------------------------------------------
64 // * 0xC Token is an ERC20 Token specifically for digital entertainment.
65 // * No ICO and private sales,fair access.
66 // * There will be hundreds of games using 0xC as a game token.
67 // * Token holders can permanently get ETH's profit sharing.
68 //
69 
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that revert on error
73  */
74 library SafeMath {
75 
76   /**
77   * @dev Multiplies two numbers, reverts on overflow.
78   */
79   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81     // benefit is lost if 'b' is also tested.
82     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
83     if (a == 0) {
84       return 0;
85     }
86 
87     uint256 c = a * b;
88     require(c / a == b);
89 
90     return c;
91   }
92 
93   /**
94   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
95   */
96   function div(uint256 a, uint256 b) internal pure returns (uint256) {
97     require(b > 0); // Solidity only automatically asserts when dividing by 0
98     uint256 c = a / b;
99     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101     return c;
102   }
103 
104   /**
105   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
106   */
107   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108     require(b <= a);
109     uint256 c = a - b;
110 
111     return c;
112   }
113 
114   /**
115   * @dev Adds two numbers, reverts on overflow.
116   */
117   function add(uint256 a, uint256 b) internal pure returns (uint256) {
118     uint256 c = a + b;
119     require(c >= a);
120 
121     return c;
122   }
123 
124   /**
125   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
126   * reverts when dividing by zero.
127   */
128   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129     require(b != 0);
130     return a % b;
131   }
132 }
133 
134 /**
135 * @title ERC20 interface
136 * @dev see https://github.com/ethereum/EIPs/issues/20
137 */
138 contract ERC20 {
139     function allowance(address owner, address spender) public constant returns (uint256);
140     function balanceOf(address who) public constant returns  (uint256);
141     function transferFrom(address from, address to, uint256 value) public returns (bool);
142     function transfer(address to, uint256 value) public returns (bool);
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 contract FutureGame {
147 
148     using SafeMath for uint256;
149     using SafeMath for uint128;
150     using SafeMath for uint32;
151     using SafeMath for uint8;
152     
153     // Standard contract ownership transfer.
154     address public owner;
155     address private nextOwner;
156 
157     //Basic Setting
158     address ERC20ContractAddres;
159     address public ERC20WalletAddress;
160 
161     bool IsEther = false;
162     bool IsInitialized = false;
163     uint256 BaseTimestamp = 1534377600; //2018 08 16
164     uint StartBetTime = 0;
165     uint LastBetTime = 0;
166     uint SettleBetTime = 0;
167     uint FinalAnswer;
168     uint LoseTokenRate; 
169     
170     //Options
171     uint256 optionOneAmount = 0;
172     uint256 optionTwoAmount = 0;
173     uint256 optionThreeAmount = 0;
174     uint256 optionFourAmount = 0;
175     uint256 optionFiveAmount = 0;
176     uint256 optionSixAmount = 0;
177     
178     //Place Limit
179     uint256 optionOneLimit = 0;
180     uint256 optionTwoLimit = 0;
181     uint256 optionThreeLimit = 0;
182     uint256 optionFourLimit = 0;
183     uint256 optionFiveLimit = 0;
184     uint256 optionSixLimit = 0;
185 
186     //Options - Address - amount
187     mapping(address => uint256) optionOneBet;
188     mapping(address => uint256) optionTwoBet;
189     mapping(address => uint256) optionThreeBet;
190     mapping(address => uint256) optionFourBet;
191     mapping(address => uint256) optionFiveBet;
192     mapping(address => uint256) optionSixBet;
193 
194     uint256 feePool = 0;
195     
196     //event
197     event BetLog(address playerAddress, uint256 amount, uint256 Option);
198     event OpenBet(uint AnswerOption);
199 
200     //withdraw 
201     mapping(address => uint256) EtherBalances;
202     mapping(address => uint256) TokenBalances;
203 
204     constructor () public{
205         owner = msg.sender;
206         IsInitialized = true;
207     }
208     
209     //Initialize the time period.
210     function initialize(uint256 _StartBetTime, uint256 _LastBetTime, uint256 _SettleBetTime,
211                         uint256 _optionOneLimit, uint256 _optionTwoLimit, uint256 _optionThreeLimit,
212                         uint256 _optionFourLimit, uint256 _optionFiveLimit, uint256 _optionSixLimit,
213                         uint256 _LoseTokenRate, address _ERC20Contract, address _ERC20Wallet,
214                         bool _IsEther) public {
215         require( _LastBetTime > _StartBetTime);
216         require(_SettleBetTime > _LastBetTime);
217         // require(OpenBetTime == 0);
218         StartBetTime = _StartBetTime;
219         LastBetTime = _LastBetTime;
220         SettleBetTime = _SettleBetTime;
221         LoseTokenRate = _LoseTokenRate;
222         
223         //Limit Setting
224         optionOneLimit = _optionOneLimit;
225         optionTwoLimit = _optionTwoLimit;
226         optionThreeLimit = _optionThreeLimit;
227         optionFourLimit = _optionFourLimit;
228         optionFiveLimit = _optionFiveLimit;
229         optionSixLimit = _optionSixLimit;
230         
231         ERC20ContractAddres = _ERC20Contract;
232         ERC20WalletAddress = _ERC20Wallet;
233         IsEther = _IsEther;
234     
235         IsInitialized = true;
236     }
237     
238     // Standard modifier on methods invokable only by contract owner.
239     modifier onlyOwner {
240         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
241         _;
242     }
243 
244     // Standard contract ownership transfer implementation,
245     function approveNextOwner(address _nextOwner) external onlyOwner {
246         require (_nextOwner != owner, "Cannot approve current owner.");
247         nextOwner = _nextOwner;
248     }
249 
250     function acceptNextOwner() external {
251         require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
252         owner = nextOwner;
253     }
254 
255     //Payable without commit is not accepted.
256     function () public payable
257     {
258         revert();
259     }
260 
261     //Place by Ether
262     function PlaceBet(uint optionNumber) public payable 
263     {
264         require(LastBetTime > now);
265         //Make sure initialized
266         require(IsInitialized == true,'This is not opened yet.');
267         require(IsEther == true, 'This is a Token Game');
268         require(msg.value >= 0.01 ether);
269 
270         uint256 _amount = msg.value;
271         if(optionNumber == 1){
272             require( optionOneAmount.add(_amount) <= optionOneLimit );
273             optionOneBet[msg.sender] = optionOneBet[msg.sender].add(_amount);
274             optionOneAmount = optionOneAmount.add(_amount);
275         }else if(optionNumber == 2){
276             require( optionTwoAmount.add(_amount) <= optionTwoLimit );
277             optionTwoBet[msg.sender] = optionTwoBet[msg.sender].add(_amount);
278             optionTwoAmount = optionTwoAmount.add(_amount);
279         }else if(optionNumber == 3){
280             require( optionThreeAmount.add(_amount) <= optionThreeLimit );
281             optionThreeBet[msg.sender] = optionThreeBet[msg.sender].add(_amount);
282             optionThreeAmount = optionThreeAmount.add(_amount);
283         }else if(optionNumber == 4){
284             require( optionFourAmount.add(_amount) <= optionFourLimit );
285             optionFourBet[msg.sender] = optionFourBet[msg.sender].add(_amount);
286             optionFourAmount = optionFourAmount.add(_amount);
287         }else if(optionNumber == 5){
288             require( optionFiveAmount.add(_amount) <= optionFiveLimit );
289             optionFiveBet[msg.sender] = optionFiveBet[msg.sender].add(_amount);
290             optionFiveAmount = optionFiveAmount.add(_amount);
291         }else if(optionNumber == 6){
292             require( optionSixAmount.add(_amount) <= optionSixLimit );
293             optionSixBet[msg.sender] = optionSixBet[msg.sender].add(_amount);
294             optionSixAmount = optionSixAmount.add(_amount);
295         }
296         
297         feePool = feePool .add( _amount.mul(20).div(1000));
298         
299         emit BetLog(msg.sender, _amount, optionNumber);
300     }
301 
302     //Place by Token 
303     function PlaceTokenBet(address player, uint optionNumber, uint _amount) public onlyOwner
304     {
305         require(LastBetTime > now);
306         require(IsInitialized == true,'This is not opened yet.');
307         require(IsEther == false, 'This is not an Ether Game');
308         
309         if(optionNumber == 1){
310             require( optionOneAmount.add(_amount) <= optionOneLimit );
311             optionOneBet[player] = optionOneBet[player].add(_amount);
312             optionOneAmount = optionOneAmount.add(_amount);
313         }else if(optionNumber == 2){
314             require( optionTwoAmount.add(_amount) <= optionTwoLimit );
315             optionTwoBet[player] = optionTwoBet[player].add(_amount);
316             optionTwoAmount = optionTwoAmount.add(_amount);
317         }else if(optionNumber == 3){
318             require( optionTwoAmount.add(_amount) <= optionTwoLimit );
319             optionThreeBet[player] = optionThreeBet[player].add(_amount);
320             optionThreeAmount = optionThreeAmount.add(_amount);
321         }else if(optionNumber == 4){
322             require( optionTwoAmount.add(_amount) <= optionTwoLimit );
323             optionFourBet[player] = optionFourBet[player].add(_amount);
324             optionFourAmount = optionFourAmount.add(_amount);
325         }else if(optionNumber == 5){
326             require( optionTwoAmount.add(_amount) <= optionTwoLimit );
327             optionFiveBet[player] = optionFiveBet[player].add(_amount);
328             optionFiveAmount = optionFiveAmount.add(_amount);
329         }else if(optionNumber == 6){
330             require( optionTwoAmount.add(_amount) <= optionTwoLimit );
331             optionSixBet[player] = optionSixBet[player].add(_amount);
332             optionSixAmount = optionSixAmount.add(_amount);
333         }
334         emit BetLog(msg.sender, _amount, optionNumber);
335     }
336     
337     //Set Answer
338     function FinishGame(uint256 _finalOption) public onlyOwner
339     {
340         require(now > SettleBetTime);
341         FinalAnswer = _finalOption;
342     }
343 
344     //Get contract information.
345     function getGameInfo() public view returns(bool _IsInitialized, bool _IsEther, 
346         uint256 _optionOneAmount, uint256 _optionTwoAmount,
347         uint256 _optionThreeAmount, uint256 _optionFourAmount, uint256 _optionFiveAmount,
348         uint256 _optionSixAmount,
349         uint256 _StartBetTime, uint256 _LastBetTime, 
350         uint256 _SettleBetTime, uint256 _FinalAnswer, uint256 _LoseTokenRate )
351     {
352         return(IsInitialized, IsEther, optionOneAmount, optionTwoAmount, optionThreeAmount, optionFourAmount,
353         optionFiveAmount, optionSixAmount,  StartBetTime, LastBetTime, SettleBetTime, FinalAnswer, LoseTokenRate );
354     }
355     
356     function getOptionLimit() public view returns(
357         uint256 _optionOneLimit, uint256 _optionTwoLimit, uint256 _optionThreeLimit,
358         uint256 _optionFourLimit, uint256 _optionFiveLimit, uint256 _optionSixLimit)
359     {
360         return( optionOneLimit, optionTwoLimit, optionThreeLimit, optionFourLimit,optionFiveLimit, optionSixLimit);
361     }
362     
363     //Purge the time in the timestamp.
364     function DateConverter(uint256 ts) public view returns(uint256 currentDayWithoutTime){
365         uint256 dayInterval = ts.sub(BaseTimestamp);
366         uint256 dayCount = dayInterval.div(86400);
367         return BaseTimestamp.add(dayCount.mul(86400));
368     }
369     
370     //Get count of days that contract started
371     function getDateInterval() public view returns(uint256 intervalDays){
372         uint256 intervalTs = DateConverter(now).sub(BaseTimestamp);
373         intervalDays = intervalTs.div(86400).sub(1);
374     }
375     
376     function checkVault() public view returns(uint myReward)
377     {
378         uint256 myAward = 0;
379         
380         uint256 realReward = 
381             optionOneAmount.add(optionTwoAmount).add(optionThreeAmount)
382             .add(optionFourAmount).add(optionFiveAmount).add(optionSixAmount);
383         
384         uint256 myshare = 0;
385         
386         realReward = realReward.mul(980).div(1000);
387         if(FinalAnswer == 1){
388             myshare = optionOneBet[msg.sender].mul(100).div(optionOneAmount) ;
389             myAward = myshare.mul(realReward).div(100);
390         }else if(FinalAnswer == 2){
391             myshare = optionTwoBet[msg.sender].mul(100).div(optionTwoAmount) ;
392             myAward = myshare.mul(realReward).div(100);
393         }else if(FinalAnswer == 3){
394             myshare = optionThreeBet[msg.sender].mul(100).div(optionThreeAmount) ;
395             myAward = myshare.mul(realReward).div(100);
396         }else if(FinalAnswer == 4){
397             myshare = optionFourBet[msg.sender].mul(100).div(optionFourAmount) ;
398             myAward = myshare.mul(realReward).div(100);
399         }else if(FinalAnswer == 5){
400             myshare = optionFiveBet[msg.sender].mul(100).div(optionFiveAmount) ;
401             myAward = myshare.mul(realReward).div(100);
402         }else if(FinalAnswer == 6){
403             myshare = optionSixBet[msg.sender].mul(100).div(optionSixAmount) ;
404             myAward = myshare.mul(realReward).div(100);
405         }
406         
407         return myAward;
408     }
409     
410     function getVaultInfo() public view returns(uint256 _myReward, uint256 _totalBets, uint256 _realReward, uint256 _myShare)
411     {
412         uint256 myAward = 0;
413         
414         uint256 totalBets = 
415              optionOneAmount.add(optionTwoAmount).add(optionThreeAmount)
416             .add(optionFourAmount).add(optionFiveAmount).add(optionSixAmount);
417         
418         uint256 myshare = 0;
419         
420         uint256 realReward = totalBets.mul(980).div(1000);
421         if(FinalAnswer == 1){
422             myshare = optionOneBet[msg.sender].mul(100).div(optionOneAmount) ;
423             myAward = myshare.mul(realReward).div(100);
424         }else if(FinalAnswer == 2){
425             myshare = optionTwoBet[msg.sender].mul(100).div(optionTwoAmount) ;
426             myAward = myshare.mul(realReward).div(100);
427         }else if(FinalAnswer == 3){
428             myshare = optionThreeBet[msg.sender].mul(100).div(optionThreeAmount) ;
429             myAward = myshare.mul(realReward).div(100);
430         }else if(FinalAnswer == 4){
431             myshare = optionFourBet[msg.sender].mul(100).div(optionFourAmount) ;
432             myAward = myshare.mul(realReward).div(100);
433         }else if(FinalAnswer == 5){
434             myshare = optionFiveBet[msg.sender].mul(100).div(optionFiveAmount) ;
435             myAward = myshare.mul(realReward).div(100);
436         }else if(FinalAnswer == 6){
437             myshare = optionSixBet[msg.sender].mul(100).div(optionSixAmount) ;
438             myAward = myshare.mul(realReward).div(100);
439         }
440         
441         return (myAward, totalBets, realReward, myshare);
442     }
443 
444     function getBet(uint number) public view returns(uint result)
445     {
446         if(number == 1){
447             result = optionOneBet[msg.sender];
448         }else if(number == 2){
449             result = optionTwoBet[msg.sender];
450         }else if(number == 3){
451             result = optionThreeBet[msg.sender];
452         }else if(number == 4){
453             result = optionFourBet[msg.sender];
454         }else if(number == 5){
455             result = optionFiveBet[msg.sender];
456         }else if(number == 6){
457             result = optionSixBet[msg.sender];
458         }
459     }
460 
461     //Get your profit back.
462     function withdraw() public
463     {
464         require(FinalAnswer != 0);
465 
466         uint256 myReward = checkVault();
467 
468         if(myReward ==0 && IsEther == true)
469         {
470             uint256 totalBet = optionOneBet[msg.sender] 
471             .add(optionTwoBet[msg.sender]).add(optionThreeBet[msg.sender])
472             .add(optionFourBet[msg.sender]).add(optionFiveBet[msg.sender])
473             .add(optionSixBet[msg.sender]);
474             
475             uint256 TokenEarned = totalBet.mul(LoseTokenRate);
476 
477             ERC20(ERC20ContractAddres).transferFrom(ERC20WalletAddress, msg.sender, TokenEarned);
478         }
479         optionOneBet[msg.sender] = 0;
480         optionTwoBet[msg.sender] = 0;
481         optionThreeBet[msg.sender] = 0;
482         optionFourBet[msg.sender] = 0;
483         optionFiveBet[msg.sender] = 0;
484         optionSixBet[msg.sender] = 0;
485         
486         if(IsEther)
487         {
488             msg.sender.transfer(myReward);
489         }
490         else
491         {
492             ERC20(ERC20ContractAddres).transferFrom(ERC20WalletAddress, msg.sender, myReward);
493         }
494     }
495     
496     function updateERC20WalletAddress(address newAddress) public onlyOwner
497     {
498         ERC20WalletAddress = newAddress;
499     }
500     
501     //Take service fee back.
502     function getServiceFeeBack() public onlyOwner
503     {
504         uint amount = feePool;
505         feePool = 0;
506         msg.sender.transfer(amount);
507     }
508 }