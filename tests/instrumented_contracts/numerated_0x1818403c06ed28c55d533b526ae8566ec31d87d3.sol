1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable contract - base contract with an owner
5  */
6 contract Ownable {
7   
8   address public owner;
9   address public newOwner;
10 
11   event OwnershipTransferred(address indexed _from, address indexed _to);
12   
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     assert(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param _newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address _newOwner) public onlyOwner {
34     assert(_newOwner != address(0));      
35     newOwner = _newOwner;
36   }
37 
38   /**
39    * @dev Accept transferOwnership.
40    */
41   function acceptOwnership() public {
42     if (msg.sender == newOwner) {
43       OwnershipTransferred(owner, newOwner);
44       owner = newOwner;
45     }
46   }
47 }
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 contract SafeMath {
54 
55   function sub(uint256 x, uint256 y) internal constant returns (uint256) {
56     uint256 z = x - y;
57     assert(z <= x);
58 	  return z;
59   }
60 
61   function add(uint256 x, uint256 y) internal constant returns (uint256) {
62     uint256 z = x + y;
63 	  assert(z >= x);
64 	  return z;
65   }
66 	
67   function div(uint256 x, uint256 y) internal constant returns (uint256) {
68     uint256 z = x / y;
69     return z;
70   }
71 	
72   function mul(uint256 x, uint256 y) internal constant returns (uint256) {
73     uint256 z = x * y;
74     assert(x == 0 || z / x == y);
75     return z;
76   }
77 
78   function min(uint256 x, uint256 y) internal constant returns (uint256) {
79     uint256 z = x <= y ? x : y;
80     return z;
81   }
82 
83   function max(uint256 x, uint256 y) internal constant returns (uint256) {
84     uint256 z = x >= y ? x : y;
85     return z;
86   }
87 }
88 
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 {
95 	function totalSupply() public constant returns (uint);
96 	function balanceOf(address owner) public constant returns (uint);
97 	function allowance(address owner, address spender) public constant returns (uint);
98 	function transfer(address to, uint value) public returns (bool success);
99 	function transferFrom(address from, address to, uint value) public returns (bool success);
100 	function approve(address spender, uint value) public returns (bool success);
101 	function mint(address to, uint value) public returns (bool success);
102 	event Transfer(address indexed from, address indexed to, uint value);
103 	event Approval(address indexed owner, address indexed spender, uint value);
104 }
105 
106 
107 /**
108  * @title Standard ERC20 token
109  * @dev Implementation of the basic standard token.
110  * @dev https://github.com/ethereum/EIPs/issues/20
111  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract StandardToken is ERC20, SafeMath, Ownable{
114 	
115   uint256 _totalSupply;
116   mapping (address => uint256) balances;
117   mapping (address => mapping (address => uint256)) approvals;
118   address public crowdsaleAgent;
119   bool public released = false;  
120   
121   /**
122    * @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
123    * @param numwords payload size  
124    */
125   modifier onlyPayloadSize(uint numwords) {
126     assert(msg.data.length == numwords * 32 + 4);
127     _;
128   }
129   
130   /**
131    * @dev The function can be called only by crowdsale agent.
132    */
133   modifier onlyCrowdsaleAgent() {
134     assert(msg.sender == crowdsaleAgent);
135     _;
136   }
137 
138   /** Limit token mint after finishing crowdsale
139    * @dev Make sure we are not done yet.
140    */
141   modifier canMint() {
142     assert(!released);
143     _;
144   }
145   
146   /**
147    * @dev Limit token transfer until the crowdsale is over.
148    */
149   modifier canTransfer() {
150     assert(released);
151     _;
152   } 
153   
154   /** 
155    * @dev Total Supply
156    * @return _totalSupply 
157    */  
158   function totalSupply() public constant returns (uint256) {
159     return _totalSupply;
160   }
161   
162   /** 
163    * @dev Tokens balance
164    * @param _owner holder address
165    * @return balance amount 
166    */
167   function balanceOf(address _owner) public constant returns (uint256) {
168     return balances[_owner];
169   }
170   
171   /** 
172    * @dev Token allowance
173    * @param _owner holder address
174    * @param _spender spender address
175    * @return remain amount
176    */   
177   function allowance(address _owner, address _spender) public constant returns (uint256) {
178     return approvals[_owner][_spender];
179   }
180 
181   /** 
182    * @dev Tranfer tokens to address
183    * @param _to dest address
184    * @param _value tokens amount
185    * @return transfer result
186    */   
187   function transfer(address _to, uint _value) public canTransfer onlyPayloadSize(2) returns (bool success) {
188     assert(balances[msg.sender] >= _value);
189     balances[msg.sender] = sub(balances[msg.sender], _value);
190     balances[_to] = add(balances[_to], _value);
191     
192     Transfer(msg.sender, _to, _value);
193     return true;
194   }
195   
196   /**    
197    * @dev Tranfer tokens from one address to other
198    * @param _from source address
199    * @param _to dest address
200    * @param _value tokens amount
201    * @return transfer result
202    */    
203   function transferFrom(address _from, address _to, uint _value) public canTransfer onlyPayloadSize(3) returns (bool success) {
204     assert(balances[_from] >= _value);
205     assert(approvals[_from][msg.sender] >= _value);
206     approvals[_from][msg.sender] = sub(approvals[_from][msg.sender], _value);
207     balances[_from] = sub(balances[_from], _value);
208     balances[_to] = add(balances[_to], _value);
209     
210     Transfer(_from, _to, _value);
211     return true;
212   }
213   
214   /** 
215    * @dev Approve transfer
216    * @param _spender holder address
217    * @param _value tokens amount
218    * @return result  
219    */
220   function approve(address _spender, uint _value) public onlyPayloadSize(2) returns (bool success) {
221     // To change the approve amount you first have to reduce the addresses`
222     //  approvals to zero by calling `approve(_spender, 0)` if it is not
223     //  already 0 to mitigate the race condition described here:
224     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225     assert((_value == 0) || (approvals[msg.sender][_spender] == 0));
226     approvals[msg.sender][_spender] = _value;
227     
228     Approval(msg.sender, _spender, _value);
229     return true;
230   }
231   
232   /** 
233    * @dev Create new tokens and allocate them to an address. Only callably by a crowdsale contract
234    * @param _to dest address
235    * @param _value tokens amount
236    * @return mint result
237    */ 
238   function mint(address _to, uint _value) public onlyCrowdsaleAgent canMint onlyPayloadSize(2) returns (bool success) {
239     _totalSupply = add(_totalSupply, _value);
240     balances[_to] = add(balances[_to], _value);
241     
242     Transfer(0, _to, _value);
243     return true;
244 	
245   }
246   
247   /**
248    * @dev Set the contract that can call release and make the token transferable.
249    * @param _crowdsaleAgent crowdsale contract address
250    */
251   function setCrowdsaleAgent(address _crowdsaleAgent) public onlyOwner {
252     assert(!released);
253     crowdsaleAgent = _crowdsaleAgent;
254   }
255   
256   /**
257    * @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. 
258    */
259   function releaseTokenTransfer() public onlyCrowdsaleAgent {
260     released = true;
261   }
262 
263 }
264 
265 /** 
266  * @title DAOPlayMarket2.0 contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
267  */
268 contract DAOPlayMarketToken is StandardToken {
269   
270   string public name;
271   string public symbol;
272   uint public decimals;
273   
274   /** Name and symbol were updated. */
275   event UpdatedTokenInformation(string newName, string newSymbol);
276 
277   /**
278    * Construct the token.
279    *
280    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
281    *
282    * @param _name Token name
283    * @param _symbol Token symbol - should be all caps
284    * @param _initialSupply How many tokens we start with
285    * @param _decimals Number of decimal places
286    * @param _addr Address for team's tokens
287    */
288    
289   function DAOPlayMarketToken(string _name, string _symbol, uint _initialSupply, uint _decimals, address _addr) public {
290     require(_addr != 0x0);
291     name = _name;
292     symbol = _symbol;
293     decimals = _decimals;
294 	
295     _totalSupply = _initialSupply*10**_decimals;
296 
297     // Creating initial tokens
298     balances[_addr] = _totalSupply;
299   }   
300   
301    /**
302    * Owner can update token information here.
303    *
304    * It is often useful to conceal the actual token association, until
305    * the token operations, like central issuance or reissuance have been completed.
306    *
307    * This function allows the token owner to rename the token after the operations
308    * have been completed and then point the audience to use the token contract.
309    */
310   function setTokenInformation(string _name, string _symbol) public onlyOwner {
311     name = _name;
312     symbol = _symbol;
313 
314     UpdatedTokenInformation(name, symbol);
315   }
316 
317 }
318 
319 
320 /**
321  * @title Haltable
322  * @dev Abstract contract that allows children to implement an
323  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
324  */
325 contract Haltable is Ownable {
326   bool public halted;
327 
328   modifier stopInEmergency {
329     assert(!halted);
330     _;
331   }
332 
333   modifier onlyInEmergency {
334     assert(halted);
335     _;
336   }
337 
338   /**
339    *@dev Called by the owner on emergency, triggers stopped state
340    */
341   function halt() external onlyOwner {
342     halted = true;
343   }
344 
345   /**
346    * @dev Called by the owner on end of emergency, returns to normal state
347    */
348   function unhalt() external onlyOwner onlyInEmergency {
349     halted = false;
350   }
351 }
352 
353 
354 /** 
355  * @title Killable DAOPlayMarketTokenCrowdsale contract
356  */
357 contract Killable is Ownable {
358   function kill() onlyOwner {
359     selfdestruct(owner);
360   }
361 }
362 
363 /** 
364  * @title DAOPlayMarketTokenCrowdsale contract - contract for token sales.
365  */
366 contract DAOPlayMarketTokenCrowdsale is Haltable, SafeMath, Killable {
367   
368   /* The token we are selling */
369   DAOPlayMarketToken public token;
370 
371   /* tokens will be transfered from this address */
372   address public multisigWallet;
373 
374   /* the UNIX timestamp start date of the crowdsale */
375   uint public startsAt;
376   
377   /* the UNIX timestamp end date of the crowdsale */
378   uint public endsAt;
379   
380   /* the number of tokens already sold through this contract*/
381   uint public tokensSold = 0;
382   
383   /* How many wei of funding we have raised */
384   uint public weiRaised = 0;
385   
386   /* How many unique addresses that have invested */
387   uint public investorCount = 0;
388   
389   /* Has this crowdsale been finalized */
390   bool public finalized;
391   
392   /* Cap of tokens */
393   uint public CAP;
394   
395   /* How much ETH each address has invested to this crowdsale */
396   mapping (address => uint256) public investedAmountOf;
397   
398   /* How much tokens this crowdsale has credited for each investor address */
399   mapping (address => uint256) public tokenAmountOf;
400   
401   /* Contract address that can call invest other crypto */
402   address public cryptoAgent;
403   
404   /** How many tokens he charged for each investor's address in a particular period */
405   mapping (uint => mapping (address => uint256)) public tokenAmountOfPeriod;
406   
407   struct Stage {
408     // UNIX timestamp when the stage begins
409     uint start;
410     // UNIX timestamp when the stage is over
411     uint end;
412     // Number of period
413     uint period;
414     // Price#1 token in WEI
415     uint price1;
416     // Price#2 token in WEI
417     uint price2;
418     // Price#3 token in WEI
419     uint price3;
420     // Price#4 token in WEI
421     uint price4;
422     // Cap of period
423     uint cap;
424     // Token sold in period
425     uint tokenSold;
426   }
427   
428   /** Stages **/
429   Stage[] public stages;
430   uint public periodStage;
431   uint public stage;
432   
433   /** State machine
434    *
435    * - Preparing: All contract initialization calls and variables have not been set yet
436    * - Funding: Active crowdsale
437    * - Success: Minimum funding goal reached
438    * - Failure: Minimum funding goal not reached before ending time
439    * - Finalized: The finalized has been called and succesfully executed
440    */
441   enum State{Unknown, Preparing, Funding, Success, Failure, Finalized}
442   
443   // A new investment was made
444   event Invested(address investor, uint weiAmount, uint tokenAmount);
445   
446   // A new investment was made
447   event InvestedOtherCrypto(address investor, uint weiAmount, uint tokenAmount);
448 
449   // Crowdsale end time has been changed
450   event EndsAtChanged(uint _endsAt);
451   
452   // New distributions were made
453   event DistributedTokens(address investor, uint tokenAmount);
454   
455   /** 
456    * @dev Modified allowing execution only if the crowdsale is currently running
457    */
458   modifier inState(State state) {
459     require(getState() == state);
460     _;
461   }
462   
463   /**
464    * @dev The function can be called only by crowdsale agent.
465    */
466   modifier onlyCryptoAgent() {
467     assert(msg.sender == cryptoAgent);
468     _;
469   }
470   
471   /**
472    * @dev Constructor
473    * @param _token DAOPlayMarketToken token address
474    * @param _multisigWallet team wallet
475    * @param _start token ICO start date
476    * @param _cap token ICO 
477    * @param _price array of price 
478    * @param _periodStage period of stage
479    * @param _capPeriod cap of period
480    */
481   function DAOPlayMarketTokenCrowdsale(address _token, address _multisigWallet, uint _start, uint _cap, uint[20] _price, uint _periodStage, uint _capPeriod) public {
482   
483     require(_multisigWallet != 0x0);
484     require(_start >= block.timestamp);
485     require(_cap > 0);
486     require(_periodStage > 0);
487     require(_capPeriod > 0);
488 	
489     token = DAOPlayMarketToken(_token);
490     multisigWallet = _multisigWallet;
491     startsAt = _start;
492     CAP = _cap*10**token.decimals();
493 	
494     periodStage = _periodStage*1 days;
495     uint capPeriod = _capPeriod*10**token.decimals();
496     uint j = 0;
497     for(uint i=0; i<_price.length; i=i+4) {
498       stages.push(Stage(startsAt+j*periodStage, startsAt+(j+1)*periodStage, j, _price[i], _price[i+1], _price[i+2], _price[i+3], capPeriod, 0));
499       j++;
500     }
501     endsAt = stages[stages.length-1].end;
502     stage = 0;
503   }
504   
505   /**
506    * Buy tokens from the contract
507    */
508   function() public payable {
509     investInternal(msg.sender);
510   }
511 
512   /**
513    * Make an investment.
514    *
515    * Crowdsale must be running for one to invest.
516    * We must have not pressed the emergency brake.
517    *
518    * @param receiver The Ethereum address who receives the tokens
519    *
520    */
521   function investInternal(address receiver) private stopInEmergency {
522     require(msg.value > 0);
523 	
524     assert(getState() == State.Funding);
525 
526     // Determine in what period we hit
527     stage = getStage();
528 	
529     uint weiAmount = msg.value;
530 
531     // Account presale sales separately, so that they do not count against pricing tranches
532     uint tokenAmount = calculateToken(weiAmount, stage, token.decimals());
533 
534     assert(tokenAmount > 0);
535 
536 	// Check that we did not bust the cap in the period
537     assert(stages[stage].cap >= add(tokenAmount, stages[stage].tokenSold));
538 	
539     tokenAmountOfPeriod[stage][receiver]=add(tokenAmountOfPeriod[stage][receiver],tokenAmount);
540 	
541     stages[stage].tokenSold = add(stages[stage].tokenSold,tokenAmount);
542 	
543     if (stages[stage].cap == stages[stage].tokenSold){
544       updateStage(stage);
545       endsAt = stages[stages.length-1].end;
546     }
547 	
548 	// Check that we did not bust the cap
549     //assert(!isBreakingCap(tokenAmount, tokensSold));
550 	
551     if(investedAmountOf[receiver] == 0) {
552        // A new investor
553        investorCount++;
554     }
555 
556     // Update investor
557     investedAmountOf[receiver] = add(investedAmountOf[receiver],weiAmount);
558     tokenAmountOf[receiver] = add(tokenAmountOf[receiver],tokenAmount);
559 
560     // Update totals
561     weiRaised = add(weiRaised,weiAmount);
562     tokensSold = add(tokensSold,tokenAmount);
563 
564     assignTokens(receiver, tokenAmount);
565 
566     // send ether to the fund collection wallet
567     multisigWallet.transfer(weiAmount);
568 
569     // Tell us invest was success
570     Invested(receiver, weiAmount, tokenAmount);
571 	
572   }
573   
574   /**
575    * Make an investment.
576    *
577    * Crowdsale must be running for one to invest.
578    * We must have not pressed the emergency brake.
579    *
580    * @param receiver The Ethereum address who receives the tokens
581    * @param _weiAmount amount in Eth
582    *
583    */
584   function investOtherCrypto(address receiver, uint _weiAmount) public onlyCryptoAgent stopInEmergency {
585     require(_weiAmount > 0);
586 	
587     assert(getState() == State.Funding);
588 
589     // Determine in what period we hit
590     stage = getStage();
591 	
592     uint weiAmount = _weiAmount;
593 
594     // Account presale sales separately, so that they do not count against pricing tranches
595     uint tokenAmount = calculateToken(weiAmount, stage, token.decimals());
596 
597     assert(tokenAmount > 0);
598 
599 	// Check that we did not bust the cap in the period
600     assert(stages[stage].cap >= add(tokenAmount, stages[stage].tokenSold));
601 	
602     tokenAmountOfPeriod[stage][receiver]=add(tokenAmountOfPeriod[stage][receiver],tokenAmount);
603 	
604     stages[stage].tokenSold = add(stages[stage].tokenSold,tokenAmount);
605 	
606     if (stages[stage].cap == stages[stage].tokenSold){
607       updateStage(stage);
608       endsAt = stages[stages.length-1].end;
609     }
610 	
611 	// Check that we did not bust the cap
612     //assert(!isBreakingCap(tokenAmount, tokensSold));
613 	
614     if(investedAmountOf[receiver] == 0) {
615        // A new investor
616        investorCount++;
617     }
618 
619     // Update investor
620     investedAmountOf[receiver] = add(investedAmountOf[receiver],weiAmount);
621     tokenAmountOf[receiver] = add(tokenAmountOf[receiver],tokenAmount);
622 
623     // Update totals
624     weiRaised = add(weiRaised,weiAmount);
625     tokensSold = add(tokensSold,tokenAmount);
626 
627     assignTokens(receiver, tokenAmount);
628 	
629     // Tell us invest was success
630     InvestedOtherCrypto(receiver, weiAmount, tokenAmount);
631   }
632   
633   /**
634    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
635    */
636   function assignTokens(address receiver, uint tokenAmount) private {
637      token.mint(receiver, tokenAmount);
638   }
639    
640   /**
641    * Check if the current invested breaks our cap rules.
642    *
643    * Called from invest().
644    *
645    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
646    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
647    *
648    * @return true if taking this investment would break our cap rules
649    */
650   function isBreakingCap(uint tokenAmount, uint tokensSoldTotal) public constant returns (bool limitBroken){
651 	if(add(tokenAmount,tokensSoldTotal) <= CAP){
652 	  return false;
653 	}
654 	return true;
655   }
656 
657   /**
658    * @dev Distribution of remaining tokens.
659    */
660   function distributionOfTokens() public stopInEmergency {
661     require(block.timestamp >= endsAt);
662     require(!finalized);
663     uint amount;
664     for(uint i=0; i<stages.length; i++) {
665       if(tokenAmountOfPeriod[stages[i].period][msg.sender] != 0){
666         amount = add(amount,div(mul(sub(stages[i].cap,stages[i].tokenSold),tokenAmountOfPeriod[stages[i].period][msg.sender]),stages[i].tokenSold));
667         tokenAmountOfPeriod[stages[i].period][msg.sender] = 0;
668       }
669     }
670     assert(amount > 0);
671     assignTokens(msg.sender, amount);
672 	
673     // Tell us distributed was success
674     DistributedTokens(msg.sender, amount);
675   }
676   
677   /**
678    * @dev Finalize a succcesful crowdsale.
679    */
680   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
681     require(block.timestamp >= (endsAt+periodStage));
682     require(!finalized);
683 	
684     finalizeCrowdsale();
685     finalized = true;
686   }
687   
688   /**
689    * @dev Finalize a succcesful crowdsale.
690    */
691   function finalizeCrowdsale() internal {
692     token.releaseTokenTransfer();
693   }
694   
695   /**
696    * @dev Check if the ICO goal was reached.
697    * @return true if the crowdsale has raised enough money to be a success
698    */
699   function isCrowdsaleFull() public constant returns (bool) {
700     if(tokensSold >= CAP || block.timestamp >= endsAt){
701       return true;  
702     }
703     return false;
704   }
705   
706   /** 
707    * @dev Allow crowdsale owner to close early or extend the crowdsale.
708    * @param time timestamp
709    */
710   function setEndsAt(uint time) public onlyOwner {
711     require(!finalized);
712     require(time >= block.timestamp);
713     endsAt = time;
714     EndsAtChanged(endsAt);
715   }
716   
717    /**
718    * @dev Allow to change the team multisig address in the case of emergency.
719    */
720   function setMultisig(address addr) public onlyOwner {
721     require(addr != 0x0);
722     multisigWallet = addr;
723   }
724   
725   /**
726    * @dev Allow crowdsale owner to change the token address.
727    */
728   function setToken(address addr) public onlyOwner {
729     require(addr != 0x0);
730     token = DAOPlayMarketToken(addr);
731   }
732   
733   /** 
734    * @dev Crowdfund state machine management.
735    * @return State current state
736    */
737   function getState() public constant returns (State) {
738     if (finalized) return State.Finalized;
739     else if (address(token) == 0 || address(multisigWallet) == 0 || block.timestamp < startsAt) return State.Preparing;
740     else if (block.timestamp <= endsAt && block.timestamp >= startsAt && !isCrowdsaleFull()) return State.Funding;
741     else if (isCrowdsaleFull()) return State.Success;
742     else return State.Failure;
743   }
744   
745   /** 
746    * @dev Set base price for ICO.
747    */
748   function setBasePrice(uint[20] _price, uint _startDate, uint _periodStage, uint _cap, uint _decimals) public onlyOwner {
749     periodStage = _periodStage*1 days;
750     uint cap = _cap*10**_decimals;
751     uint j = 0;
752     delete stages;
753     for(uint i=0; i<_price.length; i=i+4) {
754       stages.push(Stage(_startDate+j*periodStage, _startDate+(j+1)*periodStage, j, _price[i], _price[i+1], _price[i+2], _price[i+3], cap, 0));
755       j++;
756     }
757     endsAt = stages[stages.length-1].end;
758     stage =0;
759   }
760   
761   /** 
762    * @dev Updates the ICO steps if the cap is reached.
763    */
764   function updateStage(uint number) private {
765     require(number>=0);
766     uint time = block.timestamp;
767     uint j = 0;
768     stages[number].end = time;
769     for (uint i = number+1; i < stages.length; i++) {
770       stages[i].start = time+periodStage*j;
771       stages[i].end = time+periodStage*(j+1);
772       j++;
773     }
774   }
775   
776   /** 
777    * @dev Gets the current stage.
778    * @return uint current stage
779    */
780   function getStage() private constant returns (uint){
781     for (uint i = 0; i < stages.length; i++) {
782       if (block.timestamp >= stages[i].start && block.timestamp < stages[i].end) {
783         return stages[i].period;
784       }
785     }
786     return stages[stages.length-1].period;
787   }
788   
789   /** 
790    * @dev Gets the cap of amount.
791    * @return uint cap of amount
792    */
793   function getAmountCap(uint value) private constant returns (uint ) {
794     if(value <= 10*10**18){
795       return 0;
796     }else if (value <= 50*10**18){
797       return 1;
798     }else if (value <= 300*10**18){
799       return 2;
800     }else {
801       return 3;
802     }
803   }
804   
805   /**
806    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
807    * @param value - The value of the transaction send in as wei
808    * @param _stage - The stage of ICO
809    * @param decimals - How many decimal places the token has
810    * @return Amount of tokens the investor receives
811    */
812    
813   function calculateToken(uint value, uint _stage, uint decimals) private constant returns (uint){
814     uint tokenAmount = 0;
815     uint saleAmountCap = getAmountCap(value); 
816 	
817     if(saleAmountCap == 0){
818       tokenAmount = div(value*10**decimals,stages[_stage].price1);
819     }else if(saleAmountCap == 1){
820       tokenAmount = div(value*10**decimals,stages[_stage].price2);
821     }else if(saleAmountCap == 2){
822       tokenAmount = div(value*10**decimals,stages[_stage].price3);
823     }else{
824       tokenAmount = div(value*10**decimals,stages[_stage].price4);
825     }
826     return tokenAmount;
827   }
828  
829   /**
830    * @dev Set the contract that can call the invest other crypto function.
831    * @param _cryptoAgent crowdsale contract address
832    */
833   function setCryptoAgent(address _cryptoAgent) public onlyOwner {
834     require(!finalized);
835     cryptoAgent = _cryptoAgent;
836   }
837 }