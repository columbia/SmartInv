1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   uint256 public totalSupply;
137   function balanceOf(address who) public view returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 // File: zeppelin-solidity/contracts/token/BasicToken.sol
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     // SafeMath.sub will throw if there is not enough balance.
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256 balance) {
175     return balances[_owner];
176   }
177 
178 }
179 
180 // File: zeppelin-solidity/contracts/token/ERC20.sol
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 contract ERC20 is ERC20Basic {
187   function allowance(address owner, address spender) public view returns (uint256);
188   function transferFrom(address from, address to, uint256 value) public returns (bool);
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 // File: zeppelin-solidity/contracts/token/StandardToken.sol
194 
195 /**
196  * @title Standard ERC20 token
197  *
198  * @dev Implementation of the basic standard token.
199  * @dev https://github.com/ethereum/EIPs/issues/20
200  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  */
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    *
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Function to check the amount of tokens that an owner allowed to a spender.
243    * @param _owner address The address which owns the funds.
244    * @param _spender address The address which will spend the funds.
245    * @return A uint256 specifying the amount of tokens still available for the spender.
246    */
247   function allowance(address _owner, address _spender) public view returns (uint256) {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * @dev Increase the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To increment
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _addedValue The amount of tokens to increase the allowance by.
260    */
261   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
262     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
278     uint oldValue = allowed[msg.sender][_spender];
279     if (_subtractedValue > oldValue) {
280       allowed[msg.sender][_spender] = 0;
281     } else {
282       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283     }
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288 }
289 
290 // File: contracts/Token.sol
291 
292 contract Token is StandardToken, Pausable {
293     string constant public name = "Bace Token";
294     string constant public symbol = "BACE";
295     uint8 constant public decimals =  18;
296 
297     uint256 constant public INITIAL_TOTAL_SUPPLY = 100 * 1E6 * (uint256(10) ** (decimals));
298 
299     address private addressIco;
300 
301     modifier onlyIco() {
302         require(msg.sender == addressIco);
303         _;
304     }
305 
306     /**
307     * @dev Create BACE Token contract and set pause
308     * @param _ico The address of ICO contract.
309     */
310     function Token(address _ico) public {
311         require(_ico != address(0));
312         addressIco = _ico;
313 
314         totalSupply = totalSupply.add(INITIAL_TOTAL_SUPPLY);
315         balances[_ico] = balances[_ico].add(INITIAL_TOTAL_SUPPLY);
316         Transfer(address(0), _ico, INITIAL_TOTAL_SUPPLY);
317 
318         pause();
319     }
320 
321     /**
322     * @dev Transfer token for a specified address with pause feature for owner.
323     * @dev Only applies when the transfer is allowed by the owner.
324     * @param _to The address to transfer to.
325     * @param _value The amount to be transferred.
326     */
327     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
328         super.transfer(_to, _value);
329     }
330 
331     /**
332     * @dev Transfer tokens from one address to another with pause feature for owner.
333     * @dev Only applies when the transfer is allowed by the owner.
334     * @param _from address The address which you want to send tokens from
335     * @param _to address The address which you want to transfer to
336     * @param _value uint256 the amount of tokens to be transferred
337     */
338     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
339         super.transferFrom(_from, _to, _value);
340     }
341 
342     /**
343     * @dev Transfer tokens from ICO address to another address.
344     * @param _to The address to transfer to.
345     * @param _value The amount to be transferred.
346     */
347     function transferFromIco(address _to, uint256 _value) onlyIco public returns (bool) {
348         super.transfer(_to, _value);
349     }
350 
351     /**
352     * @dev Burn remaining tokens from the ICO balance.
353     */
354     function burnFromIco() onlyIco public {
355         uint256 remainingTokens = balanceOf(addressIco);
356         balances[addressIco] = balances[addressIco].sub(remainingTokens);
357         totalSupply = totalSupply.sub(remainingTokens);
358         Transfer(addressIco, address(0), remainingTokens);
359     }
360 
361     /**
362     * @dev Refund tokens from the investor balance.
363     * @dev Function is needed for Refund investors ETH, if pre-ICO has failed.
364     */
365     function refund(address _to, uint256 _value) onlyIco public {
366         require(_value <= balances[_to]);
367 
368         address addr = _to;
369         balances[addr] = balances[addr].sub(_value);
370         balances[addressIco] = balances[addressIco].add(_value);
371         Transfer(_to, addressIco, _value);
372     }
373 }
374 
375 // File: contracts/Whitelist.sol
376 
377 /**
378  * @title Whitelist contract
379  * @dev Whitelist for wallets.
380 */
381 contract Whitelist is Ownable {
382     mapping(address => bool) whitelist;
383 
384     uint256 public whitelistLength = 0;
385 	
386 	address private addressApi;
387 	
388 	modifier onlyPrivilegeAddresses {
389         require(msg.sender == addressApi || msg.sender == owner);
390         _;
391     }
392 
393     /**
394     * @dev Set backend Api address.
395     * @dev Accept request from owner only.
396     * @param _api The address of backend API.
397     */
398     function setApiAddress(address _api) onlyOwner public {
399         require(_api != address(0));
400 
401         addressApi = _api;
402     }
403 
404 
405     /**
406     * @dev Add wallet to whitelist.
407     * @dev Accept request from the owner only.
408     * @param _wallet The address of wallet to add.
409     */  
410     function addWallet(address _wallet) onlyPrivilegeAddresses public {
411         require(_wallet != address(0));
412         require(!isWhitelisted(_wallet));
413         whitelist[_wallet] = true;
414         whitelistLength++;
415     }
416 
417     /**
418     * @dev Remove wallet from whitelist.
419     * @dev Accept request from the owner only.
420     * @param _wallet The address of whitelisted wallet to remove.
421     */  
422     function removeWallet(address _wallet) onlyOwner public {
423         require(_wallet != address(0));
424         require(isWhitelisted(_wallet));
425         whitelist[_wallet] = false;
426         whitelistLength--;
427     }
428 
429     /**
430     * @dev Check the specified wallet whether it is in the whitelist.
431     * @param _wallet The address of wallet to check.
432     */ 
433     function isWhitelisted(address _wallet) view public returns (bool) {
434         return whitelist[_wallet];
435     }
436 
437 }
438 
439 // File: contracts/Whitelistable.sol
440 
441 /**
442  * @title Whitelistable contract.
443  * @dev Contract that can be embedded in another contract, to add functionality "whitelist".
444  */
445 
446 
447 contract Whitelistable {
448     Whitelist public whitelist;
449 
450     modifier whenWhitelisted(address _wallet) {
451         require(whitelist.isWhitelisted(_wallet));
452         _;
453     }
454 
455     /**
456     * @dev Constructor for Whitelistable contract.
457     */
458     function Whitelistable() public {
459         whitelist = new Whitelist();
460     }
461 }
462 
463 // File: contracts/Crowdsale.sol
464 
465 contract Crowdsale is Pausable, Whitelistable {
466     using SafeMath for uint256;
467 
468     /////////////////////////////
469     //Constant block
470     //
471     // DECIMALS = 18
472     uint256 constant private DECIMALS = 18;
473     // rate 1 ETH = 180 BACE tokens
474     uint256 constant public BACE_ETH = 1800;
475     // Bonus: 20%
476     uint256 constant public PREICO_BONUS = 20;
477     // 20 000 000 * 10^18
478     uint256 constant public RESERVED_TOKENS_BACE_TEAM = 20 * 1E6 * (10 ** DECIMALS);
479     // 10 000 000 * 10^18
480     uint256 constant public RESERVED_TOKENS_ANGLE = 10 * 1E6 * (10 ** DECIMALS);
481     // 10 000 000 * 10^18
482     uint256 constant public HARDCAP_TOKENS_PRE_ICO = 10 * 1E6 * (10 ** DECIMALS);
483     // 70 000 000 * 10^18
484     uint256 constant public HARDCAP_TOKENS_ICO = 70 * 1E6 * (10 ** DECIMALS);
485     // 5 000 000 * 10^18
486     uint256 constant public MINCAP_TOKENS = 5 * 1E6 * (10 ** DECIMALS);
487     /////////////////////////////
488 
489     /////////////////////////////
490     //Live cycle block
491     //
492     uint256 public maxInvestments;
493 
494     uint256 public minInvestments;
495 
496     /**
497      * @dev test mode.
498      * @dev if test mode is "true" allows to change caps in an deployed contract
499      */
500     bool private testMode;
501 
502     /**
503      * @dev contract BACE token object.
504      */
505     Token public token;
506 
507     /**
508      * @dev start time of PreIco stage.
509      */
510     uint256 public preIcoStartTime;
511 
512     /**
513      * @dev finish time of PreIco stage.
514      */
515     uint256 public preIcoFinishTime;
516 
517     /**
518      * @dev start time of Ico stage.
519      */
520     uint256 public icoStartTime;
521 
522     /**
523      * @dev finish time of Ico stage.
524      */
525     uint256 public icoFinishTime;
526 
527     /**
528      * @dev were the Ico dates set?
529      */
530     bool public icoInstalled;
531 
532     /**
533      * @dev The address to backend program.
534      */
535     address private backendWallet;
536 
537     /**
538      * @dev The address to which raised funds will be withdrawn.
539      */
540     address private withdrawalWallet;
541 
542     /**
543      * @dev The guard interval.
544      */
545     uint256 public guardInterval;
546     ////////////////////////////
547 
548     /////////////////////////////
549     //ETH block
550     //
551     /**
552      * @dev Map of investors. Key = address, Value = Total ETH at PreIco.
553      */
554     mapping(address => uint256) public preIcoInvestors;
555 
556     /**
557      * @dev Array of addresses of investors at PreIco.
558      */
559     address[] public preIcoInvestorsAddresses;
560 
561     /**
562      * @dev Map of investors. Key = address, Value = Total ETH at Ico.
563      */
564     mapping(address => uint256) public icoInvestors;
565 
566     /**
567      * @dev Array of addresses of investors at Ico.
568      */
569     address[] public icoInvestorsAddresses;
570 
571     /**
572      * @dev Amount of investment collected in PreIco stage. (without BTC investment)
573      */
574     uint256 public preIcoTotalCollected;
575 
576     /**
577      * @dev Amount of investment collected in Ico stage. (without BTC investment)
578      */
579     uint256 public icoTotalCollected;
580     ////////////////////////////
581 
582     ////////////////////////////
583     //Tokens block
584     //
585 
586     /**
587      * @dev Map of investors. Key = address, Value = Total tokens at PreIco.
588      */
589     mapping(address => uint256) public preIcoTokenHolders;
590 
591     /**
592      * @dev Array of addresses of investors.
593      */
594     address[] public preIcoTokenHoldersAddresses;
595 
596     /**
597      * @dev Map of investors. Key = address, Value = Total tokens at PreIco.
598      */
599     mapping(address => uint256) public icoTokenHolders;
600 
601     /**
602      * @dev Array of addresses of investors.
603      */
604     address[] public icoTokenHoldersAddresses;
605 
606     /**
607      * @dev the minimum amount in tokens for the investment.
608      */
609     uint256 public minCap;
610 
611     /**
612      * @dev the maximum amount in tokens for the investment in the PreIco stage.
613      */
614     uint256 public hardCapPreIco;
615 
616     /**
617      * @dev the maximum amount in tokens for the investment in the Ico stage.
618      */
619     uint256 public hardCapIco;
620 
621     /**
622      * @dev number of sold tokens issued in  PreIco stage.
623      */
624     uint256 public preIcoSoldTokens;
625 
626     /**
627      * @dev number of sold tokens issued in Ico stage.
628      */
629     uint256 public icoSoldTokens;
630 
631     /**
632      * @dev The BACE token exchange rate for PreIco stage.
633      */
634     uint256 public exchangeRatePreIco;
635 
636     /**
637      * @dev The BACE token exchange rate for Ico stage.
638      */
639     uint256 public exchangeRateIco;
640 
641     /**
642      * @dev unsold BACE tokens burned?.
643      */
644     bool burnt;
645     ////////////////////////////
646 
647     /**
648      * @dev Constructor for Crowdsale contract.
649      * @dev Set the owner who can manage whitelist and token.
650      * @param _startTimePreIco The PreIco start time.
651      * @param _endTimePreIco The PreIco end time.
652      * @param _angelInvestorsWallet The address to which reserved tokens angel investors will be transferred.
653      * @param _foundersWallet The address to which reserved tokens for founders will be transferred.
654      * @param _backendWallet The address to backend program.
655      * @param _withdrawalWallet The address to which raised funds will be withdrawn.
656      * @param _testMode test mode is on?
657      */
658     function Crowdsale (
659         uint256 _startTimePreIco,
660         uint256 _endTimePreIco,
661         address _angelInvestorsWallet,
662         address _foundersWallet,
663         address _backendWallet,
664         address _withdrawalWallet,
665         uint256 _maxInvestments,
666         uint256 _minInvestments,
667         bool _testMode
668     ) public Whitelistable()
669     {
670         require(_angelInvestorsWallet != address(0) && _foundersWallet != address(0) && _backendWallet != address(0) && _withdrawalWallet != address(0));
671         require(_startTimePreIco >= now && _endTimePreIco > _startTimePreIco);
672         require(_maxInvestments != 0 && _minInvestments != 0 && _maxInvestments > _minInvestments);
673 
674         ////////////////////////////
675         //Live cycle block init
676         //
677         testMode = _testMode;
678         token = new Token(this);
679         maxInvestments = _maxInvestments;
680         minInvestments = _minInvestments;
681         preIcoStartTime = _startTimePreIco;
682         preIcoFinishTime = _endTimePreIco;
683         icoStartTime = 0;
684         icoFinishTime = 0;
685         icoInstalled = false;
686         guardInterval = uint256(86400).mul(7); //guard interval - 1 week
687         /////////////////////////////
688 
689         ////////////////////////////
690         //ETH block init
691         preIcoTotalCollected = 0;
692         icoTotalCollected = 0;
693         /////////////////////////////
694 
695         ////////////////////////////
696         //Tokens block init
697         //
698         minCap = MINCAP_TOKENS;
699         hardCapPreIco = HARDCAP_TOKENS_PRE_ICO;
700         hardCapIco = HARDCAP_TOKENS_ICO;
701         preIcoSoldTokens = 0;
702         icoSoldTokens = 0;
703         exchangeRateIco = BACE_ETH;
704         exchangeRatePreIco = exchangeRateIco.mul(uint256(100).add(PREICO_BONUS)).div(100);
705         burnt = false;
706         ////////////////////////////
707 
708         backendWallet = _backendWallet;
709         withdrawalWallet = _withdrawalWallet;
710 
711         whitelist.transferOwnership(msg.sender);
712 
713         token.transferFromIco(_angelInvestorsWallet, RESERVED_TOKENS_ANGLE);
714         token.transferFromIco(_foundersWallet, RESERVED_TOKENS_BACE_TEAM);
715         token.transferOwnership(msg.sender);
716     }
717 
718     modifier isTestMode() {
719         require(testMode);
720         _;
721     }
722 
723     /**
724      * @dev check Ico Failed.
725      * @return bool true if Ico Failed.
726      */
727     function isIcoFailed() public view returns (bool) {
728         return isIcoFinish() && icoSoldTokens.add(preIcoSoldTokens) < minCap;
729     }
730 
731     /**
732      * @dev check Ico Success.
733      * @return bool true if Ico Success.
734      */
735     function isIcoSuccess() public view returns (bool) {
736         return isIcoFinish() && icoSoldTokens.add(preIcoSoldTokens) >= minCap;
737     }
738 
739     /**
740      * @dev check PreIco Stage.
741      * @return bool true if PreIco Stage now.
742      */
743     function isPreIcoStage() public view returns (bool) {
744         return now > preIcoStartTime && now < preIcoFinishTime;
745     }
746 
747     /**
748      * @dev check Ico Stage.
749      * @return bool true if Ico Stage now.
750      */
751     function isIcoStage() public view returns (bool) {
752         return icoInstalled && now > icoStartTime && now < icoFinishTime;
753     }
754 
755     /**
756      * @dev check PreIco Finish.
757      * @return bool true if PreIco Finished.
758      */
759     function isPreIcoFinish() public view returns (bool) {
760         return now > preIcoFinishTime;
761     }
762 
763     /**
764      * @dev check Ico Finish.
765      * @return bool true if Ico Finished.
766      */
767     function isIcoFinish() public view returns (bool) {
768         return icoInstalled && now > icoFinishTime;
769     }
770 
771     /**
772      * @dev guard interval finished?
773      * @return bool true if guard Interval finished.
774      */
775     function guardIntervalFinished() public view returns (bool) {
776         return now > icoFinishTime.add(guardInterval);
777     }
778 
779     /**
780      * @dev Set start time and end time for Ico.
781      * @param _startTimeIco The Ico start time.
782      * @param _endTimeIco The Ico end time.
783      */
784     function setStartTimeIco(uint256 _startTimeIco, uint256 _endTimeIco) onlyOwner public {
785         require(_startTimeIco >= now && _endTimeIco > _startTimeIco && _startTimeIco > preIcoFinishTime);
786 
787         icoStartTime = _startTimeIco;
788         icoFinishTime = _endTimeIco;
789         icoInstalled = true;
790     }
791 
792     /**
793      * @dev Remaining amount of tokens for PreIco stage.
794      */
795     function tokensRemainingPreIco() public view returns(uint256) {
796         if (isPreIcoFinish()) {
797             return 0;
798         }
799         return hardCapPreIco.sub(preIcoSoldTokens);
800     }
801 
802     /**
803      * @dev Remaining amount of tokens for Ico stage.
804      */
805     function tokensRemainingIco() public view returns(uint256) {
806         if (burnt) {
807             return 0;
808         }
809         if (isPreIcoFinish()) {
810             return hardCapIco.sub(icoSoldTokens).sub(preIcoSoldTokens);
811         }
812         return hardCapIco.sub(hardCapPreIco).sub(icoSoldTokens);
813     }
814 
815     /**
816      * @dev Add information about the investment at the PreIco stage.
817      * @param _addr Investor's address.
818      * @param _weis Amount of wei(1 ETH = 1 * 10 ** 18 wei) received.
819      * @param _tokens Amount of Token for investor.
820      */
821     function addInvestInfoPreIco(address _addr,  uint256 _weis, uint256 _tokens) private {
822         if (preIcoTokenHolders[_addr] == 0) {
823             preIcoTokenHoldersAddresses.push(_addr);
824         }
825         preIcoTokenHolders[_addr] = preIcoTokenHolders[_addr].add(_tokens);
826         preIcoSoldTokens = preIcoSoldTokens.add(_tokens);
827         if (_weis > 0) {
828             if (preIcoInvestors[_addr] == 0) {
829                 preIcoInvestorsAddresses.push(_addr);
830             }
831             preIcoInvestors[_addr] = preIcoInvestors[_addr].add(_weis);
832             preIcoTotalCollected = preIcoTotalCollected.add(_weis);
833         }
834     }
835 
836     /**
837      * @dev Add information about the investment at the Ico stage.
838      * @param _addr Investor's address.
839      * @param _weis Amount of wei(1 ETH = 1 * 10 ** 18 wei) received.
840      * @param _tokens Amount of Token for investor.
841      */
842     function addInvestInfoIco(address _addr,  uint256 _weis, uint256 _tokens) private {
843         if (icoTokenHolders[_addr] == 0) {
844             icoTokenHoldersAddresses.push(_addr);
845         }
846         icoTokenHolders[_addr] = icoTokenHolders[_addr].add(_tokens);
847         icoSoldTokens = icoSoldTokens.add(_tokens);
848         if (_weis > 0) {
849             if (icoInvestors[_addr] == 0) {
850                 icoInvestorsAddresses.push(_addr);
851             }
852             icoInvestors[_addr] = icoInvestors[_addr].add(_weis);
853             icoTotalCollected = icoTotalCollected.add(_weis);
854         }
855     }
856 
857     /**
858      * @dev Fallback function can be used to buy tokens.
859      */
860     function() public payable {
861         acceptInvestments(msg.sender, msg.value);
862     }
863 
864     /**
865      * @dev function can be used to buy tokens by ETH investors.
866      */
867     function sellTokens() public payable {
868         acceptInvestments(msg.sender, msg.value);
869     }
870 
871     /**
872      * @dev Function processing new investments.
873      * @param _addr Investor's address.
874      * @param _amount The amount of wei(1 ETH = 1 * 10 ** 18 wei) received.
875      */
876     function acceptInvestments(address _addr, uint256 _amount) private whenWhitelisted(msg.sender) whenNotPaused {
877         require(_addr != address(0) && _amount >= minInvestments);
878 
879         bool preIco = isPreIcoStage();
880         bool ico = isIcoStage();
881 
882         require(preIco || ico);
883         require((preIco && tokensRemainingPreIco() > 0) || (ico && tokensRemainingIco() > 0));
884 
885         uint256 intermediateEthInvestment;
886         uint256 ethSurrender = 0;
887         uint256 currentEth = preIco ? preIcoInvestors[_addr] : icoInvestors[_addr];
888 
889         if (currentEth.add(_amount) > maxInvestments) {
890             intermediateEthInvestment = maxInvestments.sub(currentEth);
891             ethSurrender = ethSurrender.add(_amount.sub(intermediateEthInvestment));
892         } else {
893             intermediateEthInvestment = _amount;
894         }
895 
896         uint256 currentRate = preIco ? exchangeRatePreIco : exchangeRateIco;
897         uint256 intermediateTokenInvestment = intermediateEthInvestment.mul(currentRate);
898         uint256 tokensRemaining = preIco ? tokensRemainingPreIco() : tokensRemainingIco();
899         uint256 currentTokens = preIco ? preIcoTokenHolders[_addr] : icoTokenHolders[_addr];
900         uint256 weiToAccept;
901         uint256 tokensToSell;
902 
903         if (currentTokens.add(intermediateTokenInvestment) > tokensRemaining) {
904             tokensToSell = tokensRemaining;
905             weiToAccept = tokensToSell.div(currentRate);
906             ethSurrender = ethSurrender.add(intermediateEthInvestment.sub(weiToAccept));
907         } else {
908             tokensToSell = intermediateTokenInvestment;
909             weiToAccept = intermediateEthInvestment;
910         }
911 
912         if (preIco) {
913             addInvestInfoPreIco(_addr, weiToAccept, tokensToSell);
914         } else {
915             addInvestInfoIco(_addr, weiToAccept, tokensToSell);
916         }
917 
918         token.transferFromIco(_addr, tokensToSell);
919 
920         if (ethSurrender > 0) {
921             msg.sender.transfer(ethSurrender);
922         }
923     }
924 
925     /**
926      * @dev Function can be used to buy tokens by third-party investors.
927      * @dev Only the owner or the backend can call this function.
928      * @param _addr Investor's address.
929      * @param _value Amount of Token for investor.
930      */
931     function thirdPartyInvestments(address _addr, uint256 _value) public  whenWhitelisted(_addr) whenNotPaused {
932         require(msg.sender == backendWallet || msg.sender == owner);
933         require(_addr != address(0) && _value > 0);
934 
935         bool preIco = isPreIcoStage();
936         bool ico = isIcoStage();
937 
938         require(preIco || ico);
939         require((preIco && tokensRemainingPreIco() > 0) || (ico && tokensRemainingIco() > 0));
940 
941         uint256 currentRate = preIco ? exchangeRatePreIco : exchangeRateIco;
942         uint256 currentTokens = preIco ? preIcoTokenHolders[_addr] : icoTokenHolders[_addr];
943 
944         require(maxInvestments.mul(currentRate) >= currentTokens.add(_value));
945         require(minInvestments.mul(currentRate) <= _value);
946 
947         uint256 tokensRemaining = preIco ? tokensRemainingPreIco() : tokensRemainingIco();
948 
949         require(tokensRemaining >= _value);
950 
951         if (preIco) {
952             addInvestInfoPreIco(_addr, 0, _value);
953         } else {
954             addInvestInfoIco(_addr, 0, _value);
955         }
956 
957         token.transferFromIco(_addr, _value);
958     }
959 
960     /**
961      * @dev Send raised funds to the withdrawal wallet.
962      * @param _weiAmount The amount of raised funds to withdraw.
963      */
964     function forwardFunds(uint256 _weiAmount) public onlyOwner {
965         require(isIcoSuccess() || (isIcoFailed() && guardIntervalFinished()));
966         withdrawalWallet.transfer(_weiAmount);
967     }
968 
969     /**
970      * @dev Function for refund eth if Ico failed and guard interval has not expired.
971      * @dev Any wallet can call the function.
972      * @dev Function returns ETH for sender if it is a member of Ico or(and) PreIco.
973      */
974     function refund() public {
975         require(isIcoFailed() && !guardIntervalFinished());
976 
977         uint256 ethAmountPreIco = preIcoInvestors[msg.sender];
978         uint256 ethAmountIco = icoInvestors[msg.sender];
979         uint256 ethAmount = ethAmountIco.add(ethAmountPreIco);
980 
981         uint256 tokensAmountPreIco = preIcoTokenHolders[msg.sender];
982         uint256 tokensAmountIco = icoTokenHolders[msg.sender];
983         uint256 tokensAmount = tokensAmountPreIco.add(tokensAmountIco);
984 
985         require(ethAmount > 0 && tokensAmount > 0);
986 
987         preIcoInvestors[msg.sender] = 0;
988         icoInvestors[msg.sender] = 0;
989         preIcoTokenHolders[msg.sender] = 0;
990         icoTokenHolders[msg.sender] = 0;
991 
992         msg.sender.transfer(ethAmount);
993         token.refund(msg.sender, tokensAmount);
994     }
995 
996     /**
997      * @dev Set new withdrawal wallet address.
998      * @param _addr new withdrawal Wallet address.
999      */
1000     function setWithdrawalWallet(address _addr) public onlyOwner {
1001         require(_addr != address(0));
1002 
1003         withdrawalWallet = _addr;
1004     }
1005 
1006     /**
1007         * @dev Set new backend wallet address.
1008         * @param _addr new backend Wallet address.
1009         */
1010     function setBackendWallet(address _addr) public onlyOwner {
1011         require(_addr != address(0));
1012 
1013         backendWallet = _addr;
1014     }
1015 
1016     /**
1017     * @dev Burn unsold tokens from the Ico balance.
1018     * @dev Only applies when the Ico was ended.
1019     */
1020     function burnUnsoldTokens() onlyOwner public {
1021         require(isIcoFinish());
1022         token.burnFromIco();
1023         burnt = true;
1024     }
1025 
1026     /**
1027      * @dev Set new MinCap.
1028      * @param _newMinCap new MinCap,
1029      */
1030     function setMinCap(uint256 _newMinCap) public onlyOwner isTestMode {
1031         require(now < preIcoFinishTime);
1032         minCap = _newMinCap;
1033     }
1034 
1035     /**
1036      * @dev Set new PreIco HardCap.
1037      * @param _newPreIcoHardCap new PreIco HardCap,
1038      */
1039     function setPreIcoHardCap(uint256 _newPreIcoHardCap) public onlyOwner isTestMode {
1040         require(now < preIcoFinishTime);
1041         require(_newPreIcoHardCap <= hardCapIco);
1042         hardCapPreIco = _newPreIcoHardCap;
1043     }
1044 
1045     /**
1046      * @dev Set new Ico HardCap.
1047      * @param _newIcoHardCap new Ico HardCap,
1048      */
1049     function setIcoHardCap(uint256 _newIcoHardCap) public onlyOwner isTestMode {
1050         require(now < preIcoFinishTime);
1051         require(_newIcoHardCap > hardCapPreIco);
1052         hardCapIco = _newIcoHardCap;
1053     }
1054 
1055     /**
1056      * @dev Count the Ico investors total.
1057      */
1058     function getIcoTokenHoldersAddressesCount() public view returns(uint256) {
1059         return icoTokenHoldersAddresses.length;
1060     }
1061 
1062     /**
1063      * @dev Count the PreIco investors total.
1064      */
1065     function getPreIcoTokenHoldersAddressesCount() public view returns(uint256) {
1066         return preIcoTokenHoldersAddresses.length;
1067     }
1068 
1069     /**
1070      * @dev Count the Ico investors total (not including third-party investors).
1071      */
1072     function getIcoInvestorsAddressesCount() public view returns(uint256) {
1073         return icoInvestorsAddresses.length;
1074     }
1075 
1076     /**
1077      * @dev Count the PreIco investors total (not including third-party investors).
1078      */
1079     function getPreIcoInvestorsAddressesCount() public view returns(uint256) {
1080         return preIcoInvestorsAddresses.length;
1081     }
1082 
1083     /**
1084      * @dev Get backend wallet address.
1085      */
1086     function getBackendWallet() public view returns(address) {
1087         return backendWallet;
1088     }
1089 
1090     /**
1091      * @dev Get Withdrawal wallet address.
1092      */
1093     function getWithdrawalWallet() public view returns(address) {
1094         return withdrawalWallet;
1095     }
1096 }
1097 
1098 // File: contracts/CrowdsaleFactory.sol
1099 
1100 contract Factory {
1101     Crowdsale public crowdsale;
1102 
1103     function createCrowdsale (
1104         uint256 _startTimePreIco,
1105         uint256 _endTimePreIco,
1106         address _angelInvestorsWallet,
1107         address _foundersWallet,
1108         address _backendWallet,
1109         address _withdrawalWallet,
1110         uint256 _maxInvestments,
1111         uint256 _minInvestments,
1112         bool _testMode
1113     ) public
1114     {
1115         crowdsale = new Crowdsale(
1116             _startTimePreIco,
1117             _endTimePreIco,
1118             _angelInvestorsWallet,
1119             _foundersWallet,
1120             _backendWallet,
1121             _withdrawalWallet,
1122             _maxInvestments,
1123             _minInvestments,
1124             _testMode
1125         );
1126 
1127         Whitelist whitelist = crowdsale.whitelist();
1128         whitelist.transferOwnership(msg.sender);
1129 
1130         Token token = crowdsale.token();
1131         token.transferOwnership(msg.sender);
1132 
1133         crowdsale.transferOwnership(msg.sender);
1134     }
1135 }