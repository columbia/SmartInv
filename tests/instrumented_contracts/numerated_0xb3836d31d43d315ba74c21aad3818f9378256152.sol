1 pragma solidity ^0.4.18;
2 
3 /**
4 * Ponzi Trust Pyramid Game Smart Contracts 
5 * Code is published on https://github.com/PonziTrust/PyramidGame
6 * Ponzi Trust https://ponzitrust.com/
7 */
8 
9 // contract to store all info about players 
10 contract PlayersStorage {
11   struct Player {
12     uint256 input; 
13     uint256 timestamp;
14     bool exist;
15   }
16   mapping (address => Player) private m_players;
17   address private m_owner;
18     
19   modifier onlyOwner() {
20     require(msg.sender == m_owner);
21     _;
22   }
23   
24   function PlayersStorage() public {
25     m_owner = msg.sender;  
26   }
27 
28   // http://solidity.readthedocs.io/en/develop/contracts.html#fallback-function 
29   // Contracts that receive Ether directly (without a function call, i.e. using send 
30   // or transfer) but do not define a fallback function throw an exception, 
31   // sending back the Ether (this was different before Solidity v0.4.0).
32   // function() payable { revert(); }
33 
34 
35   /**
36   * @dev Try create new player in storage.
37   * @param addr Adrress of player.
38   * @param input Input of player.
39   * @param timestamp Timestamp of player.
40   */
41   function newPlayer(address addr, uint256 input, uint256 timestamp) 
42     public 
43     onlyOwner() 
44     returns(bool)
45   {
46     if (m_players[addr].exist) {
47       return false;
48     }
49     m_players[addr].input = input;
50     m_players[addr].timestamp = timestamp;
51     m_players[addr].exist = true;
52     return true;
53   }
54   
55   /**
56   * @dev Delet specified player from storage.
57   * @param addr Adrress of specified player.
58   */
59   function deletePlayer(address addr) public onlyOwner() {
60     delete m_players[addr];
61   }
62   
63   /**
64   * @dev Get info about specified player.
65   * @param addr Adrress of specified player.
66   * @return input Input of specified player.
67   * @return timestamp Timestamp of specified player.
68   * @return exist Whether specified player in storage or not.
69   */
70   function playerInfo(address addr) 
71     public
72     view
73     onlyOwner() 
74     returns(uint256 input, uint256 timestamp, bool exist) 
75   {
76     input = m_players[addr].input;
77     timestamp = m_players[addr].timestamp;
78     exist = m_players[addr].exist;
79   }
80   
81   /**
82   * @dev Get input of specified player.
83   * @param addr Adrress of specified player.
84   * @return input Input of specified player.
85   */
86   function playerInput(address addr) 
87     public
88     view
89     onlyOwner() 
90     returns(uint256 input) 
91   {
92     input = m_players[addr].input;
93   }
94   
95   /**
96   * @dev Get whether specified player in storage or not.
97   * @param addr Adrress of specified player.
98   * @return exist Whether specified player in storage or not.
99   */
100   function playerExist(address addr) 
101     public
102     view
103     onlyOwner() 
104     returns(bool exist) 
105   {
106     exist = m_players[addr].exist;
107   }
108   
109   /**
110   * @dev Get Timestamp of specified player.
111   * @param addr Adrress of specified player.
112   * @return timestamp Timestamp of specified player.
113   */
114   function playerTimestamp(address addr) 
115     public
116     view
117     onlyOwner() 
118     returns(uint256 timestamp) 
119   {
120     timestamp = m_players[addr].timestamp;
121   }
122   
123   /**
124   * @dev Try set input of specified player.
125   * @param addr Adrress of specified player.
126   * @param newInput New input of specified player.
127   * @return  Whether successful or not.
128   */
129   function playerSetInput(address addr, uint256 newInput)
130     public
131     onlyOwner()
132     returns(bool) 
133   {
134     if (!m_players[addr].exist) {
135       return false;
136     }
137     m_players[addr].input = newInput;
138     return true;
139   }
140   
141   /**
142   * @dev Do selfdestruct.
143   */
144   function kill() public onlyOwner() {
145     selfdestruct(m_owner);
146   }
147 }
148 
149 
150 // see: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
151 library SafeMath {
152   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153     if (a == 0) {
154       return 0;
155     }
156     uint256 c = a * b;
157     assert(c / a == b);
158     return c;
159   }
160 
161   function div(uint256 a, uint256 b) internal pure returns (uint256) {
162     // assert(b > 0); // Solidity automatically throws when dividing by 0
163     uint256 c = a / b;
164     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165     return c;
166   }
167 
168   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169     assert(b <= a);
170     return a - b;
171   }
172 
173   function add(uint256 a, uint256 b) internal pure returns (uint256) {
174     uint256 c = a + b;
175     assert(c >= a);
176     return c;
177   }
178 }
179 
180 
181 // see: https://github.com/ethereum/EIPs/issues/677
182 contract ERC677Recipient {
183   function tokenFallback(address from, uint256 amount, bytes data) public returns (bool success);
184 } 
185 
186 
187 // Ponzi Token Minimal Interface
188 contract PonziTokenMinInterface {
189   function balanceOf(address owner) public view returns(uint256);
190   function transfer(address to, uint256 value) public returns (bool);
191   function transferFrom(address from, address to, uint256 value) public returns (bool);
192 }
193 
194 
195 /**
196 * @dev TheGame contract implement ERC667 Recipient 
197 * see: https://github.com/ethereum/EIPs/issues/677) 
198 * and can receive token/ether only from Ponzi Token
199 * see: https://github.com/PonziTrust/Token).
200 */
201 contract TheGame is ERC677Recipient {
202   using SafeMath for uint256;
203 
204   enum State {
205     NotActive, //NotActive
206     Active     //Active
207   }
208 
209   State private m_state;
210   address private m_owner;
211   uint256 private m_level;
212   PlayersStorage private m_playersStorage;
213   PonziTokenMinInterface private m_ponziToken;
214   uint256 private m_interestRateNumerator;
215   uint256 private constant INTEREST_RATE_DENOMINATOR = 1000;
216   uint256 private m_creationTimestamp;
217   uint256 private constant DURATION_TO_ACCESS_FOR_OWNER = 144 days;
218   uint256 private constant COMPOUNDING_FREQ = 1 days;
219   uint256 private constant DELAY_ON_EXIT = 100 hours;
220   uint256 private constant DELAY_ON_NEW_LEVEL = 7 days;
221   string private constant NOT_ACTIVE_STR = "NotActive";
222   uint256 private constant PERCENT_TAX_ON_EXIT = 10;
223   string private constant ACTIVE_STR = "Active";
224   uint256 private constant PERCENT_REFERRAL_BOUNTY = 1;
225   uint256 private m_levelStartupTimestamp;
226   uint256 private m_ponziPriceInWei;
227   address private m_priceSetter;
228 
229 ////////////////
230 // EVENTS
231 // 
232   event NewPlayer(address indexed addr, uint256 input, uint256 when);
233   event DeletePlayer(address indexed addr, uint256 when);
234   event NewLevel(uint256 when, uint256 newLevel);
235   event StateChanged(address indexed who, State newState);
236   event PonziPriceChanged(address indexed who, uint256 newPrice);
237   
238 ////////////////
239 // MODIFIERS - Restricting Access and State Machine patterns
240 //
241   modifier onlyOwner() {
242     require(msg.sender == m_owner);
243     _;
244   }
245   modifier onlyPonziToken() {
246     require(msg.sender == address(m_ponziToken));
247     _;
248   }
249   modifier atState(State state) {
250     require(m_state == state);
251     _;
252   }
253   
254   modifier checkAccess() {
255     require(m_state == State.NotActive  // solium-disable-line indentation, operator-whitespace
256       || now.sub(m_creationTimestamp) <= DURATION_TO_ACCESS_FOR_OWNER); 
257     _;
258   }
259   
260   modifier isPlayer(address addr) {
261     require(m_playersStorage.playerExist(addr));
262     _;
263   }
264   
265   modifier gameIsAvailable() {
266     require(now >= m_levelStartupTimestamp.add(DELAY_ON_NEW_LEVEL));
267     _;
268   }
269 
270 ///////////////
271 // CONSTRUCTOR
272 //  
273   /**
274   * @dev Constructor PonziToken.
275   */
276   function TheGame(address ponziTokenAddr) public {
277     require(ponziTokenAddr != address(0));
278     m_ponziToken = PonziTokenMinInterface(ponziTokenAddr);
279     m_owner = msg.sender;
280     m_creationTimestamp = now;
281     m_state = State.NotActive;
282     m_level = 1;
283     m_interestRateNumerator = calcInterestRateNumerator(m_level);
284   }
285 
286   /**
287   * @dev Fallback func can recive eth only from Ponzi token
288   */
289   function() public payable onlyPonziToken() {  }
290   
291   
292   /**
293   * Contract calc output of sender and transfer token/eth it to him. 
294   * If token/ethnot enough on balance, then transfer all and gp to next level.
295   * 
296   * @dev Sender exit from the game. Sender must be player.
297   */
298   function exit() 
299     external
300     atState(State.Active) 
301     gameIsAvailable()
302     isPlayer(msg.sender) 
303   {
304     uint256 input;
305     uint256 timestamp;
306     timestamp = m_playersStorage.playerTimestamp(msg.sender);
307     input = m_playersStorage.playerInput(msg.sender);
308     
309     // Check whether the player is DELAY_ON_EXIT hours in the game
310     require(now >= timestamp.add(DELAY_ON_EXIT));
311     
312     // calc output
313     uint256 outputInPonzi = calcOutput(input, now.sub(timestamp).div(COMPOUNDING_FREQ));
314     
315     assert(outputInPonzi > 0);
316     
317     // convert ponzi to eth
318     uint256 outputInWei = ponziToWei(outputInPonzi, m_ponziPriceInWei);
319     
320     // set zero before sending to prevent Re-Entrancy 
321     m_playersStorage.deletePlayer(msg.sender);
322     
323     if (m_ponziPriceInWei > 0 && address(this).balance >= outputInWei) {
324       // if we have enough eth on address(this).balance 
325       // send it to sender
326       
327       // WARNING
328       // untrusted Transfer !!!
329       uint256 oldBalance = address(this).balance;
330       msg.sender.transfer(outputInWei);
331       assert(address(this).balance.add(outputInWei) >= oldBalance);
332       
333     } else if (m_ponziToken.balanceOf(address(this)) >= outputInPonzi) {
334       // else if we have enough ponzi on balance
335       // send it to sender
336       
337       uint256 oldPonziBalance = m_ponziToken.balanceOf(address(this));
338       assert(m_ponziToken.transfer(msg.sender, outputInPonzi));
339       assert(m_ponziToken.balanceOf(address(this)).add(outputInPonzi) == oldPonziBalance);
340     } else {
341       // if we dont have nor eth, nor ponzi then transfer all avaliable ponzi to 
342       // msg.sender and go to next Level
343       assert(m_ponziToken.transfer(msg.sender, m_ponziToken.balanceOf(address(this))));
344       assert(m_ponziToken.balanceOf(address(this)) == 0);
345       nextLevel();
346     }
347   }
348   
349   /**
350   * @dev Get info about specified player.
351   * @param addr Adrress of specified player.
352   * @return input Input of specified player.
353   * @return timestamp Timestamp of specified player.
354   * @return inGame Whether specified player in game or not.
355   */
356   function playerInfo(address addr) 
357     public 
358     view 
359     atState(State.Active)
360     gameIsAvailable()
361     returns(uint256 input, uint256 timestamp, bool inGame) 
362   {
363     (input, timestamp, inGame) = m_playersStorage.playerInfo(addr);
364   }
365   
366   /**
367   * @dev Get possible output for specified player at now.
368   * @param addr Adrress of specified player.
369   * @return input Possible output for specified player at now.
370   */
371   function playerOutputAtNow(address addr) 
372     public 
373     view 
374     atState(State.Active) 
375     gameIsAvailable()
376     returns(uint256 amount)
377   {
378     if (!m_playersStorage.playerExist(addr)) {
379       return 0;
380     }
381     uint256 input = m_playersStorage.playerInput(addr);
382     uint256 timestamp = m_playersStorage.playerTimestamp(addr);
383     uint256 numberOfPayout = now.sub(timestamp).div(COMPOUNDING_FREQ);
384     amount = calcOutput(input, numberOfPayout);
385   }
386   
387   /**
388   * @dev Get delay on opportunity to exit for specified player at now.
389   * @param addr Adrress of specified player.
390   * @return input Delay for specified player at now.
391   */
392   function playerDelayOnExit(address addr) 
393     public 
394     view 
395     atState(State.Active) 
396     gameIsAvailable()
397     returns(uint256 delay) 
398   {
399     if (!m_playersStorage.playerExist(addr)) {
400       return 0;
401     }
402     uint256 timestamp = m_playersStorage.playerTimestamp(msg.sender);
403     if (now >= timestamp.add(DELAY_ON_EXIT)) {
404       delay = 0;
405     } else {
406       delay = timestamp.add(DELAY_ON_EXIT).sub(now);
407     }
408   }
409   
410   /**
411   * Sender try enter to the game.
412   * 
413   * @dev Sender enter to the game. Sender must not be player.
414   * @param input Input of new player.
415   * @param referralAddress The referral address.
416   */
417   function enter(uint256 input, address referralAddress) 
418     external 
419     atState(State.Active)
420     gameIsAvailable()
421   {
422     require(m_ponziToken.transferFrom(msg.sender, address(this), input));
423     require(newPlayer(msg.sender, input, referralAddress));
424   }
425   
426   /**
427   * @dev Address of the price setter.
428   * @return Address of the price setter.
429   */
430   function priceSetter() external view returns(address) {
431     return m_priceSetter;
432   }
433   
434 
435   /**
436   * @dev Price of one Ponzi token in wei.
437   * @return Price of one Ponzi token in wei.
438   */
439   function ponziPriceInWei() 
440     external 
441     view 
442     atState(State.Active)  
443     returns(uint256) 
444   {
445     return m_ponziPriceInWei;
446   }
447   
448   /**
449   * @dev Сompounding freq of the game. Olways 1 day.
450   * @return Compounding freq of the game.
451   */
452   function compoundingFreq() 
453     external 
454     view 
455     atState(State.Active) 
456     returns(uint256) 
457   {
458     return COMPOUNDING_FREQ;
459   }
460   
461   /**
462   * @dev Interest rate  of the game as numerator/denominator.From 5% to 0.1%.
463   * @return numerator Interest rate numerator of the game.
464   * @return denominator Interest rate denominator of the game.
465   */
466   function interestRate() 
467     external 
468     view
469     atState(State.Active)
470     returns(uint256 numerator, uint256 denominator) 
471   {
472     numerator = m_interestRateNumerator;
473     denominator = INTEREST_RATE_DENOMINATOR;
474   }
475   
476   /**
477   * @dev Level of the game.
478   * @return Level of the game.
479   */
480   function level() 
481     external 
482     view 
483     atState(State.Active)
484     returns(uint256) 
485   {
486     return m_level;
487   }
488   
489   /**
490   * @dev Get contract work state.
491   * @return Contract work state via string.
492   */
493   function state() external view returns(string) {
494     if (m_state == State.NotActive) 
495       return NOT_ACTIVE_STR;
496     else
497       return ACTIVE_STR;
498   }
499   
500   /**
501   * @dev Get timestamp of the level startup.
502   * @return Timestamp of the level startup.
503   */
504   function levelStartupTimestamp() 
505     external 
506     view 
507     atState(State.Active)
508     returns(uint256) 
509   {
510     return m_levelStartupTimestamp;
511   }
512   
513   /**
514   * @dev Get amount of Ponzi tokens in the game.Ponzi tokens balanceOf the game.
515   * @return Contract work state via string.
516   */
517   function totalPonziInGame() 
518     external 
519     view 
520     returns(uint256) 
521   {
522     return m_ponziToken.balanceOf(address(this));
523   }
524   
525   /**
526   * @dev Get current delay on new level.
527   * @return Current delay on new level.
528   */
529   function currentDelayOnNewLevel() 
530     external 
531     view 
532     atState(State.Active)
533     returns(uint256 delay) 
534   {
535     if (now >= m_levelStartupTimestamp.add(DELAY_ON_NEW_LEVEL)) {
536       delay = 0;
537     } else {
538       delay = m_levelStartupTimestamp.add(DELAY_ON_NEW_LEVEL).sub(now);
539     }  
540   }
541 
542 ///////////////////
543 // ERC677 ERC677Recipient Methods
544 //
545   /**
546   * see: https://github.com/ethereum/EIPs/issues/677
547   *
548   * @dev ERC677 token fallback. Called when received Ponzi token
549   * and sender try enter to the game.
550   *
551   * @param from Received tokens from the address.
552   * @param amount Amount of recived tokens.
553   * @param data Received extra data.
554   * @return Whether successful entrance or not.
555   */
556   function tokenFallback(address from, uint256 amount, bytes data) 
557     public
558     atState(State.Active)
559     gameIsAvailable()
560     onlyPonziToken()
561     returns (bool)
562   {
563     address referralAddress = bytesToAddress(data);
564     require(newPlayer(from, amount, referralAddress));
565     return true;
566   }
567   
568   /**
569   * @dev Set price of one Ponzi token in wei.
570   * @param newPrice Price of one Ponzi token in wei.
571   */ 
572   function setPonziPriceinWei(uint256 newPrice) 
573     public
574     atState(State.Active)   
575   {
576     require(msg.sender == m_owner || msg.sender == m_priceSetter);
577     m_ponziPriceInWei = newPrice;
578     PonziPriceChanged(msg.sender, m_ponziPriceInWei);
579   }
580   
581   /**
582   * @dev Owner do disown.
583   */ 
584   function disown() public onlyOwner() atState(State.Active) {
585     delete m_owner;
586   }
587   
588   /**
589   * @dev Set state of contract working.
590   * @param newState String representation of new state.
591   */ 
592   function setState(string newState) public onlyOwner() checkAccess() {
593     if (keccak256(newState) == keccak256(NOT_ACTIVE_STR)) {
594       m_state = State.NotActive;
595     } else if (keccak256(newState) == keccak256(ACTIVE_STR)) {
596       if (address(m_playersStorage) == address(0)) 
597         m_playersStorage = (new PlayersStorage());
598       m_state = State.Active;
599     } else {
600       // if newState not valid string
601       revert();
602     }
603     StateChanged(msg.sender, m_state);
604   }
605 
606   /**
607   * @dev Set the PriceSetter address, which has access to set one Ponzi 
608   * token price in wei.
609   * @param newPriceSetter The address of new PriceSetter.
610   */
611   function setPriceSetter(address newPriceSetter) 
612     public 
613     onlyOwner() 
614     checkAccess()
615     atState(State.Active) 
616   {
617     m_priceSetter = newPriceSetter;
618   }
619   
620   /**
621   * @dev Try create new player. 
622   * @param addr Adrress of pretender player.
623   * @param inputAmount Input tokens amount of pretender player.
624   * @param referralAddr Referral address of pretender player.
625   * @return Whether specified player in game or not.
626   */
627   function newPlayer(address addr, uint256 inputAmount, address referralAddr)
628     private
629     returns(bool)
630   {
631     uint256 input = inputAmount;
632     // return false if player already in game or if input < 1000,
633     // because calcOutput() use INTEREST_RATE_DENOMINATOR = 1000.
634     // and input must div by INTEREST_RATE_DENOMINATOR, if 
635     // input <1000 then dividing always equal 0.
636     if (m_playersStorage.playerExist(addr) || input < 1000) 
637       return false;
638     
639     // check if referralAddr is player
640     if (m_playersStorage.playerExist(referralAddr)) {
641       // transfer 1% input form addr to referralAddr :
642       // newPlayerInput = input * (100-PERCENT_REFERRAL_BOUNTY) %;
643       // referralInput  = (current referral input) + input * PERCENT_REFERRAL_BOUNTY %
644       uint256 newPlayerInput = inputAmount.mul(uint256(100).sub(PERCENT_REFERRAL_BOUNTY)).div(100);
645       uint256 referralInput = m_playersStorage.playerInput(referralAddr);
646       referralInput = referralInput.add(inputAmount.sub(newPlayerInput));
647       
648       // try set input of referralAddr player
649       assert(m_playersStorage.playerSetInput(referralAddr, referralInput));
650       // if success, set input of new player = newPlayerInput
651       input = newPlayerInput;
652     }
653     // try create new player
654     assert(m_playersStorage.newPlayer(addr, input, now));
655     NewPlayer(addr, input, now);
656     return true;
657   }
658   
659   /**
660   * @dev Calc possibly output (compounding interest) for specified input and number of payout.
661   * @param input Input amount.
662   * @param numberOfPayout Number of payout.
663   * @return Possibly output.
664   */
665   function calcOutput(uint256 input, uint256 numberOfPayout) 
666     private
667     view
668     returns(uint256 output)
669   {
670     output = input;
671     uint256 counter = numberOfPayout;
672     // calc compound interest 
673     while (counter > 0) {
674       output = output.add(output.mul(m_interestRateNumerator).div(INTEREST_RATE_DENOMINATOR));
675       counter = counter.sub(1);
676     }
677     // save tax % on exit; output = output * (100-tax) / 100;
678     output = output.mul(uint256(100).sub(PERCENT_TAX_ON_EXIT)).div(100); 
679   }
680   
681   /**
682   * @dev The game go no next level. 
683   */
684   function nextLevel() private {
685     m_playersStorage.kill();
686     m_playersStorage = (new PlayersStorage());
687     m_level = m_level.add(1);
688     m_interestRateNumerator = calcInterestRateNumerator(m_level);
689     m_levelStartupTimestamp = now;
690     NewLevel(now, m_level);
691   }
692   
693   /**
694   * @dev Calc numerator of interest rate for specified level. 
695   * @param newLevel Specified level.
696   * @return Result numerator.
697   */
698   function calcInterestRateNumerator(uint256 newLevel) 
699     internal 
700     pure 
701     returns(uint256 numerator) 
702   {
703     // constant INTEREST_RATE_DENOMINATOR = 1000
704     // numerator we calc
705     // 
706     // level 1 : 5% interest rate = 50 / 1000    |
707     // level 2 : 4% interest rate = 40 / 1000    |  first stage
708     //        ...                                |
709     // level 5 : 1% interest rate = 10 / 1000    |
710     
711     // level 6 : 0.9% interest rate = 9 / 1000   |  second stage
712     // level 7 : 0.8% interest rate = 8 / 1000   |
713     //        ...                                |
714     // level 14 : 0.1% interest rate = 1 / 1000  |  
715     
716     // level >14 : 0.1% interest rate = 1 / 1000 |  third stage
717 
718     if (newLevel <= 5) {
719       // first stage from 5% to 1%. numerator from 50 to 10
720       numerator = uint256(6).sub(newLevel).mul(10);
721     } else if ( newLevel >= 6 && newLevel <= 14) {
722       // second stage from 0.9% to 0.1%. numerator from 9 to 1
723       numerator = uint256(15).sub(newLevel);
724     } else {
725       // third stage 0.1%. numerator 1
726       numerator = 1;
727     }
728   }
729   
730   /**
731   * @dev Convert Ponzi token to wei.
732   * @param tokensAmount Amout of tokens.
733   * @param tokenPrice One token price in wei.
734   * @return weiAmount Result of convertation. 
735   */
736   function ponziToWei(uint256 tokensAmount, uint256 tokenPrice) 
737     internal
738     pure
739     returns(uint256 weiAmount)
740   {
741     weiAmount = tokensAmount.mul(tokenPrice); 
742   } 
743 
744   /**
745   * @dev Conver bytes data to address. 
746   * @param source Bytes data.
747   * @return Result address of convertation.
748   */
749   function bytesToAddress(bytes source) internal pure returns(address parsedReferer) {
750     assembly {
751       parsedReferer := mload(add(source,0x14))
752     }
753     return parsedReferer;
754   }
755 }