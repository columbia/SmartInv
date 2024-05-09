1 pragma solidity ^0.4.8;
2 
3 contract OwnedByWinsome {
4 
5   address public owner;
6   mapping (address => bool) allowedWorker;
7 
8   function initOwnership(address _owner, address _worker) internal{
9     owner = _owner;
10     allowedWorker[_owner] = true;
11     allowedWorker[_worker] = true;
12   }
13 
14   function allowWorker(address _new_worker) onlyOwner{
15     allowedWorker[_new_worker] = true;
16   }
17   function removeWorker(address _old_worker) onlyOwner{
18     allowedWorker[_old_worker] = false;
19   }
20   function changeOwner(address _new_owner) onlyOwner{
21     owner = _new_owner;
22   }
23 						    
24   modifier onlyAllowedWorker{
25     if (!allowedWorker[msg.sender]){
26       throw;
27     }
28     _;
29   }
30 
31   modifier onlyOwner{
32     if (msg.sender != owner){
33       throw;
34     }
35     _;
36   }
37 
38   
39 }
40 
41 /**
42  * Math operations with safety checks
43  */
44 library SafeMath {
45   function mul(uint a, uint b) internal returns (uint) {
46     uint c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint a, uint b) internal returns (uint) {
52     assert(b > 0);
53     uint c = a / b;
54     assert(a == b * c + a % b);
55     return c;
56   }
57 
58   function sub(uint a, uint b) internal returns (uint) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint a, uint b) internal returns (uint) {
64     uint c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 
69   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
70     return a >= b ? a : b;
71   }
72 
73   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
74     return a < b ? a : b;
75   }
76 
77   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
78     return a >= b ? a : b;
79   }
80 
81   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
82     return a < b ? a : b;
83   }
84 
85   function assert(bool assertion) internal {
86     if (!assertion) {
87       throw;
88     }
89   }
90 }
91 
92 
93 /*
94  * Basic token
95  * Basic version of StandardToken, with no allowances
96  */
97 contract BasicToken {
98   using SafeMath for uint;
99   event Transfer(address indexed from, address indexed to, uint value);
100   mapping(address => uint) balances;
101   uint public     totalSupply =    0;    			 // Total supply of 500 million Tokens
102   
103   /*
104    * Fix for the ERC20 short address attack  
105    */
106   modifier onlyPayloadSize(uint size) {
107      if(msg.data.length < size + 4) {
108        throw;
109      }
110      _;
111   }
112 
113   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     Transfer(msg.sender, _to, _value);
117   }
118 
119   function balanceOf(address _owner) constant returns (uint balance) {
120     return balances[_owner];
121   }
122   
123 }
124 
125 
126 contract StandardToken is BasicToken{
127   
128   event Approval(address indexed owner, address indexed spender, uint value);
129 
130   
131   mapping (address => mapping (address => uint)) allowed;
132 
133   function transferFrom(address _from, address _to, uint _value) {
134     var _allowance = allowed[_from][msg.sender];
135 
136     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
137     // if (_value > _allowance) throw;
138 
139     balances[_to] = balances[_to].add(_value);
140     balances[_from] = balances[_from].sub(_value);
141     allowed[_from][msg.sender] = _allowance.sub(_value);
142     Transfer(_from, _to, _value);
143   }
144 
145   function approve(address _spender, uint _value) {
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148   }
149 
150   function allowance(address _owner, address _spender) constant returns (uint remaining) {
151     return allowed[_owner][_spender];
152   }
153 
154 }
155 
156 
157 contract WinToken is StandardToken, OwnedByWinsome{
158 
159   string public   name =           "Winsome.io Token";
160   string public   symbol =         "WIN";
161   uint public     decimals =       18;
162   
163   mapping (address => bool) allowedMinter;
164 
165   function WinToken(address _owner){
166     allowedMinter[_owner] = true;
167     initOwnership(_owner, _owner);
168   }
169 
170   function allowMinter(address _new_minter) onlyOwner{
171     allowedMinter[_new_minter] = true;
172   }
173   function removeMinter(address _old_minter) onlyOwner{
174     allowedMinter[_old_minter] = false;
175   }
176 
177   modifier onlyAllowedMinter{
178     if (!allowedMinter[msg.sender]){
179       throw;
180     }
181     _;
182   }
183   function mintTokens(address _for, uint _value_wei) onlyAllowedMinter {
184     balances[_for] = balances[_for].add(_value_wei);
185     totalSupply = totalSupply.add(_value_wei) ;
186     Transfer(address(0), _for, _value_wei);
187   }
188   function destroyTokens(address _for, uint _value_wei) onlyAllowedMinter {
189     balances[_for] = balances[_for].sub(_value_wei);
190     totalSupply = totalSupply.sub(_value_wei);
191     Transfer(_for, address(0), _value_wei);    
192   }
193   
194 }
195 
196 contract Rouleth
197 {
198   //Game and Global Variables, Structure of gambles
199   address public developer;
200   uint8 public blockDelay; //nb of blocks to wait before spin
201   uint8 public blockExpiration; //nb of blocks before bet expiration (due to hash storage limits)
202   uint256 public maxGamble; //max gamble value manually set by config
203   uint256 public minGamble; //min gamble value manually set by config
204 
205   mapping (address => uint) pendingTokens;
206   
207   address public WINTOKENADDRESS;
208   WinToken winTokenInstance;
209 
210   uint public emissionRate;
211   
212   //Gambles
213   enum BetTypes{number, color, parity, dozen, column, lowhigh} 
214   struct Gamble
215   {
216     address player;
217     bool spinned; //Was the rouleth spinned ?
218     bool win;
219     //Possible bet types
220     BetTypes betType;
221     uint input; //stores number, color, dozen or oddeven
222     uint256 wager;
223     uint256 blockNumber; //block of bet
224     uint256 blockSpinned; //block of spin
225     uint8 wheelResult;
226   }
227   Gamble[] private gambles;
228 
229   //Tracking progress of players
230   mapping (address=>uint) gambleIndex; //current gamble index of the player
231   //records current status of player
232   enum Status {waitingForBet, waitingForSpin} mapping (address=>Status) playerStatus; 
233 
234 
235   //**********************************************
236   //        Management & Config FUNCTIONS        //
237   //**********************************************
238 
239   function  Rouleth(address _developer, address _winToken) //creation settings
240   {
241     WINTOKENADDRESS = _winToken;
242     winTokenInstance = WinToken(_winToken);
243     developer = _developer;
244     blockDelay=0; //indicates which block after bet will be used for RNG
245     blockExpiration=245; //delay after which gamble expires
246     minGamble=10 finney; //configurable min bet
247     maxGamble=1 ether; //configurable max bet
248     emissionRate = 5;
249   }
250     
251   modifier onlyDeveloper() 
252   {
253     if (msg.sender!=developer) throw;
254     _;
255   }
256 
257   function addBankroll()
258     onlyDeveloper
259     payable {
260   }
261 
262   function removeBankroll(uint256 _amount_wei)
263     onlyDeveloper
264   {
265     if (!developer.send(_amount_wei)) throw;
266   }
267     
268   function changeDeveloper_only_Dev(address new_dev)
269     onlyDeveloper
270   {
271     developer=new_dev;
272   }
273 
274 
275 
276 
277 
278   //Change some settings within safety bounds
279   function changeSettings_only_Dev(uint256 newMinGamble, uint256 newMaxGamble, uint8 newBlockDelay, uint8 newBlockExpiration, uint newEmissionRate)
280     onlyDeveloper
281   {
282     emissionRate = newEmissionRate;
283     //MAX BET : limited by payroll/(casinoStatisticalLimit*35)
284     if (newMaxGamble<newMinGamble) throw;  
285     maxGamble=newMaxGamble; 
286     minGamble=newMinGamble;
287     //Delay before spin :
288     blockDelay=newBlockDelay;
289     if (newBlockExpiration < blockDelay + 250) throw;
290     blockExpiration=newBlockExpiration;
291   }
292 
293 
294   //**********************************************
295   //                 BETTING FUNCTIONS                    //
296   //**********************************************
297 
298   //***//basic betting without Mist or contract call
299   //activates when the player only sends eth to the contract
300   //without specifying any type of bet.
301   function ()
302     payable
303     {
304       //defaut bet : bet on red
305       betOnColor(false);
306     } 
307 
308   //***//Guarantees that gamble is under max bet and above min.
309   // returns bet value
310   function checkBetValue() private returns(uint256)
311   {
312     if (msg.value < minGamble) throw;
313     if (msg.value > maxGamble){
314       return maxGamble;
315     }
316     else{
317       return msg.value;
318     }
319   }
320 
321 
322 
323   //Function record bet called by all others betting functions
324   function placeBet(BetTypes betType, uint input) private
325   {
326 
327     if (playerStatus[msg.sender] != Status.waitingForBet) {
328       if (!SpinTheWheel(msg.sender)) throw;
329     }
330 
331     //Once this is done, we can record the new bet
332     playerStatus[msg.sender] = Status.waitingForSpin;
333     gambleIndex[msg.sender] = gambles.length;
334     
335     //adapts wager to casino limits
336     uint256 betValue = checkBetValue();
337     pendingTokens[msg.sender] += betValue * emissionRate;
338 
339     
340     gambles.push(Gamble(msg.sender, false, false, betType, input, betValue, block.number, 0, 37)); //37 indicates not spinned yet
341     
342     //refund excess bet (at last step vs re-entry)
343     if (betValue < msg.value) {
344       if (msg.sender.send(msg.value-betValue)==false) throw;
345     }
346   }
347 
348   function getPendingTokens(address account) constant returns (uint){
349     return pendingTokens[account];
350   }
351   
352   function redeemTokens(){
353     uint totalTokens = pendingTokens[msg.sender];
354     if (totalTokens == 0) return;
355     pendingTokens[msg.sender] = 0;
356 
357     //ADD POTENTIAL BONUS BASED ON How long waited!
358     
359     //mint WIN Tokens
360     winTokenInstance.mintTokens(msg.sender, totalTokens);
361   }
362 
363   
364 
365   //***//bet on Number	
366   function betOnNumber(uint numberChosen)
367     payable
368   {
369     //check that number chosen is valid and records bet
370     if (numberChosen>36) throw;
371     placeBet(BetTypes.number, numberChosen);
372   }
373 
374   //***// function betOnColor
375   //bet type : color
376   //input : 0 for red
377   //input : 1 for black
378   function betOnColor(bool Black)
379     payable
380   {
381     uint input;
382     if (!Black) 
383       { 
384 	input=0;
385       }
386     else{
387       input=1;
388     }
389     placeBet(BetTypes.color, input);
390   }
391 
392   //***// function betOnLow_High
393   //bet type : lowhigh
394   //input : 0 for low
395   //input : 1 for low
396   function betOnLowHigh(bool High)
397     payable
398   {
399     uint input;
400     if (!High) 
401       { 
402 	input=0;
403       }
404     else 
405       {
406 	input=1;
407       }
408     placeBet(BetTypes.lowhigh, input);
409   }
410 
411   //***// function betOnOddEven
412   //bet type : parity
413   //input : 0 for even
414   //input : 1 for odd
415   function betOnOddEven(bool Odd)
416     payable
417   {
418     uint input;
419     if (!Odd) 
420       { 
421 	input=0;
422       }
423     else{
424       input=1;
425     }
426     placeBet(BetTypes.parity, input);
427   }
428 
429   //***// function betOnDozen
430   //     //bet type : dozen
431   //     //input : 0 for first dozen
432   //     //input : 1 for second dozen
433   //     //input : 2 for third dozen
434   function betOnDozen(uint dozen_selected_0_1_2)
435     payable
436 
437   {
438     if (dozen_selected_0_1_2 > 2) throw;
439     placeBet(BetTypes.dozen, dozen_selected_0_1_2);
440   }
441 
442 
443   // //***// function betOnColumn
444   //     //bet type : column
445   //     //input : 0 for first column
446   //     //input : 1 for second column
447   //     //input : 2 for third column
448   function betOnColumn(uint column_selected_0_1_2)
449     payable
450   {
451     if (column_selected_0_1_2 > 2) throw;
452     placeBet(BetTypes.column, column_selected_0_1_2);
453   }
454 
455   //**********************************************
456   // Spin The Wheel & Check Result FUNCTIONS//
457   //**********************************************
458 
459   event Win(address player, uint8 result, uint value_won, bytes32 bHash, bytes32 sha3Player, uint gambleId, uint bet);
460   event Loss(address player, uint8 result, uint value_loss, bytes32 bHash, bytes32 sha3Player, uint gambleId, uint bet);
461 
462   //***//function to spin callable
463   // no eth allowed
464   function spinTheWheel(address spin_for_player)
465   {
466     SpinTheWheel(spin_for_player);
467   }
468 
469 
470   function SpinTheWheel(address playerSpinned) private returns(bool)
471   {
472     if (playerSpinned==0)
473       {
474 	playerSpinned=msg.sender;         //if no index spins for the sender
475       }
476 
477     //check that player has to spin
478     if (playerStatus[playerSpinned] != Status.waitingForSpin) return false;
479 
480     //redundent double check : check that gamble has not been spinned already
481     if (gambles[gambleIndex[playerSpinned]].spinned == true) throw;
482 
483     
484     //check that the player waited for the delay before spin
485     //and also that the bet is not expired
486     uint playerblock = gambles[gambleIndex[playerSpinned]].blockNumber;
487     //too early to spin
488     if (block.number <= playerblock+blockDelay) throw;
489     //too late, bet expired, player lost
490     else if (block.number > playerblock+blockExpiration) solveBet(playerSpinned, 255, false, 1, 0, 0) ;
491     //spin !
492     else
493       {
494 	uint8 wheelResult;
495 	//Spin the wheel, 
496 	bytes32 blockHash= block.blockhash(playerblock+blockDelay);
497 	//security check that the Hash is not empty
498 	if (blockHash==0) throw;
499 	// generate the hash for RNG from the blockHash and the player's address
500 	bytes32 shaPlayer = sha3(playerSpinned, blockHash, this);
501 	// get the final wheel result
502 	wheelResult = uint8(uint256(shaPlayer)%37);
503 	//check result against bet and pay if win
504 	checkBetResult(wheelResult, playerSpinned, blockHash, shaPlayer);
505       }
506     return true;
507   }
508     
509 
510   //CHECK BETS FUNCTIONS private
511   function checkBetResult(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
512   {
513     BetTypes betType=gambles[gambleIndex[player]].betType;
514     //bet on Number
515     if (betType==BetTypes.number) checkBetNumber(result, player, blockHash, shaPlayer);
516     else if (betType==BetTypes.parity) checkBetParity(result, player, blockHash, shaPlayer);
517     else if (betType==BetTypes.color) checkBetColor(result, player, blockHash, shaPlayer);
518     else if (betType==BetTypes.lowhigh) checkBetLowhigh(result, player, blockHash, shaPlayer);
519     else if (betType==BetTypes.dozen) checkBetDozen(result, player, blockHash, shaPlayer);
520     else if (betType==BetTypes.column) checkBetColumn(result, player, blockHash, shaPlayer);
521   }
522 
523   // function solve Bet once result is determined : sends to winner, adds loss to profit
524   function solveBet(address player, uint8 result, bool win, uint8 multiplier, bytes32 blockHash, bytes32 shaPlayer) private
525   {
526     //Update status and record spinned
527     playerStatus[player]=Status.waitingForBet;
528     gambles[gambleIndex[player]].wheelResult=result;
529     gambles[gambleIndex[player]].spinned=true;
530     gambles[gambleIndex[player]].blockSpinned=block.number;
531     uint bet_v = gambles[gambleIndex[player]].wager;
532 	
533     if (win)
534       {
535 	gambles[gambleIndex[player]].win=true;
536 	uint win_v = (multiplier-1)*bet_v;
537 	Win(player, result, win_v, blockHash, shaPlayer, gambleIndex[player], bet_v);
538 	//send win!
539 	//safe send vs potential callstack overflowed spins
540 	if (player.send(win_v+bet_v)==false) throw;
541       }
542     else
543       {
544 	Loss(player, result, bet_v-1, blockHash, shaPlayer, gambleIndex[player], bet_v);
545 	//send 1 wei to confirm spin if loss
546 	if (player.send(1)==false) throw;
547       }
548 
549   }
550 
551   // checkbeton number(input)
552   // bet type : number
553   // input : chosen number
554   function checkBetNumber(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
555   {
556     bool win;
557     //win
558     if (result==gambles[gambleIndex[player]].input)
559       {
560 	win=true;  
561       }
562     solveBet(player, result,win,36, blockHash, shaPlayer);
563   }
564 
565 
566   // checkbet on oddeven
567   // bet type : parity
568   // input : 0 for even, 1 for odd
569   function checkBetParity(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
570   {
571     bool win;
572     //win
573     if (result%2==gambles[gambleIndex[player]].input && result!=0)
574       {
575 	win=true;                
576       }
577     solveBet(player,result,win,2, blockHash, shaPlayer);
578   }
579     
580   // checkbet on lowhigh
581   // bet type : lowhigh
582   // input : 0 low, 1 high
583   function checkBetLowhigh(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
584   {
585     bool win;
586     //win
587     if (result!=0 && ( (result<19 && gambles[gambleIndex[player]].input==0)
588 		       || (result>18 && gambles[gambleIndex[player]].input==1)
589 		       ) )
590       {
591 	win=true;
592       }
593     solveBet(player,result,win,2, blockHash, shaPlayer);
594   }
595 
596   // checkbet on color
597   // bet type : color
598   // input : 0 red, 1 black
599   uint[18] red_list=[1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36];
600   function checkBetColor(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
601   {
602     bool red;
603     //check if red
604     for (uint8 k; k<18; k++)
605       { 
606 	if (red_list[k]==result) 
607 	  { 
608 	    red=true; 
609 	    break;
610 	  }
611       }
612     bool win;
613     //win
614     if ( result!=0
615 	 && ( (gambles[gambleIndex[player]].input==0 && red)  
616 	      || ( gambles[gambleIndex[player]].input==1 && !red)  ) )
617       {
618 	win=true;
619       }
620     solveBet(player,result,win,2, blockHash, shaPlayer);
621   }
622 
623   // checkbet on dozen
624   // bet type : dozen
625   // input : 0 first, 1 second, 2 third
626   function checkBetDozen(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
627   { 
628     bool win;
629     //win on first dozen
630     if ( result!=0 &&
631 	 ( (result<13 && gambles[gambleIndex[player]].input==0)
632 	   ||
633 	   (result>12 && result<25 && gambles[gambleIndex[player]].input==1)
634 	   ||
635 	   (result>24 && gambles[gambleIndex[player]].input==2) ) )
636       {
637 	win=true;                
638       }
639     solveBet(player,result,win,3, blockHash, shaPlayer);
640   }
641 
642   // checkbet on column
643   // bet type : column
644   // input : 0 first, 1 second, 2 third
645   function checkBetColumn(uint8 result, address player, bytes32 blockHash, bytes32 shaPlayer) private
646   {
647     bool win;
648     //win
649     if ( result!=0
650 	 && ( (gambles[gambleIndex[player]].input==0 && result%3==1)  
651 	      || ( gambles[gambleIndex[player]].input==1 && result%3==2)
652 	      || ( gambles[gambleIndex[player]].input==2 && result%3==0)  ) )
653       {
654 	win=true;
655       }
656     solveBet(player,result,win,3, blockHash, shaPlayer);
657   }
658 
659 
660   function checkMyBet(address player) constant returns(Status player_status, BetTypes bettype, uint input, uint value, uint8 result, bool wheelspinned, bool win, uint blockNb, uint blockSpin, uint gambleID)
661   {
662     player_status=playerStatus[player];
663     bettype=gambles[gambleIndex[player]].betType;
664     input=gambles[gambleIndex[player]].input;
665     value=gambles[gambleIndex[player]].wager;
666     result=gambles[gambleIndex[player]].wheelResult;
667     wheelspinned=gambles[gambleIndex[player]].spinned;
668     win=gambles[gambleIndex[player]].win;
669     blockNb=gambles[gambleIndex[player]].blockNumber;
670     blockSpin=gambles[gambleIndex[player]].blockSpinned;
671     gambleID=gambleIndex[player];
672     return;
673   }
674 
675   function getTotalGambles() constant returns(uint){
676     return gambles.length;
677   }
678 
679   
680   function getGamblesList(uint256 index) constant returns(address player, BetTypes bettype, uint input, uint value, uint8 result, bool wheelspinned, bool win, uint blockNb, uint blockSpin)
681   {
682     player=gambles[index].player;
683     bettype=gambles[index].betType;
684     input=gambles[index].input;
685     value=gambles[index].wager;
686     result=gambles[index].wheelResult;
687     wheelspinned=gambles[index].spinned;
688     win=gambles[index].win;
689     blockNb=gambles[index].blockNumber;
690     blockSpin=gambles[index].blockSpinned;
691     return;
692   }
693 
694 } //end of contract