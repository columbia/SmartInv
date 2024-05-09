1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     require(newOwner != address(0));      
31     owner = newOwner;
32   }
33 
34 }
35 
36 library SafeMath {
37   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal constant returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal constant returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 contract ERC20Basic {
63   uint256 public totalSupply;
64   function balanceOf(address who) constant returns (uint256);
65   function transfer(address to, uint256 value) returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) /* internal? */ returns (bool) {
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of. 
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) constant returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) constant returns (uint256);
99   function transferFrom(address from, address to, uint256 value) returns (bool);
100   function approve(address spender, uint256 value) returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amout of tokens to be transfered
114    */
115   function transferFrom(address _from, address _to, uint256 _value) /* internal */ returns (bool) {
116     var _allowance = allowed[_from][msg.sender];
117 
118     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
119     // require (_value <= _allowance);
120 
121     balances[_to] = balances[_to].add(_value);
122     balances[_from] = balances[_from].sub(_value);
123     allowed[_from][msg.sender] = _allowance.sub(_value);
124     Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) returns (bool) {
134 
135     // To change the approve amount you first have to reduce the addresses`
136     //  allowance to zero by calling `approve(_spender, 0)` if it is not
137     //  already 0 to mitigate the race condition described here:
138     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
140 
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifing the amount of tokens still available for the spender.
151    */
152   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
153     return allowed[_owner][_spender];
154   }
155 
156 }
157 
158 contract MintableToken is StandardToken, Ownable {
159   bool public mintingFinished = false;
160   
161   /** List of agents that are allowed to create new tokens */
162   mapping (address => bool) public mintAgents;
163 
164   event MintingAgentChanged(address addr, bool state  );
165   event Mint(address indexed to, uint256 amount);
166   event MintFinished();
167 
168   modifier onlyMintAgent() {
169     // Only crowdsale contracts are allowed to mint new tokens
170     if(!mintAgents[msg.sender]) {
171         revert();
172     }
173     _;
174   }
175   
176   modifier canMint() {
177     require(!mintingFinished);
178     _;
179   }
180   
181   /**
182    * Owner can allow a crowdsale contract to mint new tokens.
183    */
184   function setMintAgent(address addr, bool state) onlyOwner canMint public {
185     mintAgents[addr] = state;
186     MintingAgentChanged(addr, state);
187   }
188 
189   /**
190    * @dev Function to mint tokens
191    * @param _to The address that will recieve the minted tokens.
192    * @param _amount The amount of tokens to mint.
193    * @return A boolean that indicates if the operation was successful.
194    */
195   function mint(address _to, uint256 _amount) onlyMintAgent canMint returns (bool) {
196     totalSupply = totalSupply.add(_amount);
197     balances[_to] = balances[_to].add(_amount);
198     Mint(_to, _amount);
199     return true;
200   }
201 
202   /**
203    * @dev Function to stop minting new tokens.
204    * @return True if the operation was successful.
205    */
206   function finishMinting() onlyMintAgent returns (bool) {
207     mintingFinished = true;
208     MintFinished();
209     return true;
210   }
211 }
212 
213 contract ReleasableToken is ERC20, Ownable {
214 
215   /* The finalizer contract that allows unlift the transfer limits on this token */
216   address public releaseAgent;
217 
218   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
219   bool public released = false;
220 
221   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
222   mapping (address => bool) public transferAgents;
223   
224   //dtco : time lock with specific address
225   mapping(address => uint) public lock_addresses;
226   
227   event AddLockAddress(address addr, uint lock_time);  
228 
229   /**
230    * Limit token transfer until the crowdsale is over.
231    *
232    */
233   modifier canTransfer(address _sender) {
234 
235     if(!released) {
236         if(!transferAgents[_sender]) {
237             revert();
238         }
239     }
240 	else {
241 		//check time lock with team
242 		if(now < lock_addresses[_sender]) {
243 			revert();
244 		}
245 	}
246     _;
247   }
248   
249   function ReleasableToken() {
250 	releaseAgent = msg.sender;
251   }
252   
253   //lock new team release time
254   function addLockAddressInternal(address addr, uint lock_time) inReleaseState(false) internal {
255 	if(addr == 0x0) revert();
256 	lock_addresses[addr]= lock_time;
257 	AddLockAddress(addr, lock_time);
258   }
259   
260   
261   /**
262    * Set the contract that can call release and make the token transferable.
263    *
264    * Design choice. Allow reset the release agent to fix fat finger mistakes.
265    */
266   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
267 
268     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
269     releaseAgent = addr;
270   }
271 
272   /**
273    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
274    */
275   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
276     transferAgents[addr] = state;
277   }
278   
279   /** The function can be called only by a whitelisted release agent. */
280   modifier onlyReleaseAgent() {
281     if(msg.sender != releaseAgent) {
282         revert();
283     }
284     _;
285   }
286 
287   /**
288    * One way function to release the tokens to the wild.
289    *
290    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
291    */
292   function releaseTokenTransfer() public onlyReleaseAgent {
293     released = true;
294   }
295 
296   /** The function can be called only before or after the tokens have been releasesd */
297   modifier inReleaseState(bool releaseState) {
298     if(releaseState != released) {
299         revert();
300     }
301     _;
302   }  
303 
304   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
305     // Call StandardToken.transfer()
306    return super.transfer(_to, _value);
307   }
308 
309   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
310     // Call StandardToken.transferForm()
311     return super.transferFrom(_from, _to, _value);
312   }
313 
314 }
315 
316 contract Haltable is Ownable {
317   bool public halted;
318 
319   modifier stopInEmergency {
320     if (halted) revert();
321     _;
322   }
323 
324   modifier onlyInEmergency {
325     if (!halted) revert();
326     _;
327   }
328 
329   // called by the owner on emergency, triggers stopped state
330   function halt() external onlyOwner {
331     halted = true;
332   }
333 
334   // called by the owner on end of emergency, returns to normal state
335   function unhalt() external onlyOwner onlyInEmergency {
336     halted = false;
337   }
338 
339 }
340 
341 contract CrowdsaleLimit {
342   using SafeMath for uint256;
343 
344   // the UNIX timestamp start date of the crowdsale
345   uint public startsAt;
346   // the UNIX timestamp end date of the crowdsale
347   uint public endsAt;
348   // setting the max token 
349   uint public TOKEN_MAX;
350   // seting the wei value for one token in presale stage
351   uint public PRESALE_TOKEN_IN_WEI = 9 finney;
352   // total eth fund in presale stage
353   uint public presale_eth_fund= 0;
354   
355   // seting the wei value for one token in crowdsale stage
356   uint public CROWDSALE_TOKEN_IN_WEI = 10 finney;  
357   
358   // seting the max fund of presale with eth
359   uint public PRESALE_ETH_IN_WEI_FUND_MAX = 0 ether; 
360   // seting the min fund of crowdsale with eth
361   uint public CROWDSALE_ETH_IN_WEI_FUND_MIN = 100 ether;
362   // seting the max fund of crowdsale with eth
363   uint public CROWDSALE_ETH_IN_WEI_FUND_MAX = 1000 ether;
364   // seting the min acceptable invest with eth
365   uint public CROWDSALE_ETH_IN_WEI_ACCEPTED_MIN = 100 finney;   //0.1 ether
366   // seting the gasprice to limit big buyer, default to disable
367   uint public CROWDSALE_GASPRICE_IN_WEI_MAX = 0;
368  
369   // total eth fund
370   uint public crowdsale_eth_fund= 0;
371   // total eth refund
372   uint public crowdsale_eth_refund = 0;
373    
374   // setting team list and set percentage of tokens
375   mapping(address => uint) public team_addresses_token_percentage;
376   mapping(uint => address) public team_addresses_idx;
377   uint public team_address_count= 0;
378   uint public team_token_percentage_total= 0;
379   uint public team_token_percentage_max= 0;
380     
381   event EndsAtChanged(uint newEndsAt);
382   event AddTeamAddress(address addr, uint release_time, uint token_percentage);
383   event Refund(address investor, uint weiAmount);
384     
385   // limitation of buying tokens
386   modifier allowCrowdsaleAmountLimit(){	
387 	if (msg.value == 0) revert();
388 	if (msg.value < CROWDSALE_ETH_IN_WEI_ACCEPTED_MIN) revert();
389 	if((crowdsale_eth_fund.add(msg.value)) > CROWDSALE_ETH_IN_WEI_FUND_MAX) revert();
390 	if((CROWDSALE_GASPRICE_IN_WEI_MAX > 0) && (tx.gasprice > CROWDSALE_GASPRICE_IN_WEI_MAX)) revert();
391 	_;
392   }  
393    
394   function CrowdsaleLimit(uint _start, uint _end, uint _token_max, uint _presale_token_in_wei, uint _crowdsale_token_in_wei, uint _presale_eth_inwei_fund_max, uint _crowdsale_eth_inwei_fund_min, uint _crowdsale_eth_inwei_fund_max, uint _crowdsale_eth_inwei_accepted_min, uint _crowdsale_gasprice_inwei_max, uint _team_token_percentage_max) {
395 	require(_start != 0);
396 	require(_end != 0);
397 	require(_start < _end);
398 	
399 	if( (_presale_token_in_wei == 0) ||
400 	    (_crowdsale_token_in_wei == 0) ||
401 		(_crowdsale_eth_inwei_fund_min == 0) ||
402 		(_crowdsale_eth_inwei_fund_max == 0) ||
403 		(_crowdsale_eth_inwei_accepted_min == 0) ||
404 		(_team_token_percentage_max >= 100))  //example 20%=20
405 		revert();
406 		
407 	startsAt = _start;
408     endsAt = _end;
409 	
410 	TOKEN_MAX = _token_max;
411 		
412 	PRESALE_TOKEN_IN_WEI = _presale_token_in_wei;
413 	
414 	CROWDSALE_TOKEN_IN_WEI = _crowdsale_token_in_wei;	
415 	PRESALE_ETH_IN_WEI_FUND_MAX = _presale_eth_inwei_fund_max;
416 	CROWDSALE_ETH_IN_WEI_FUND_MIN = _crowdsale_eth_inwei_fund_min;
417 	CROWDSALE_ETH_IN_WEI_FUND_MAX = _crowdsale_eth_inwei_fund_max;
418 	CROWDSALE_ETH_IN_WEI_ACCEPTED_MIN = _crowdsale_eth_inwei_accepted_min;
419 	CROWDSALE_GASPRICE_IN_WEI_MAX = _crowdsale_gasprice_inwei_max;
420 	
421 	team_token_percentage_max= _team_token_percentage_max;
422   }
423     
424   // caculate amount of token in presale stage
425   function calculateTokenPresale(uint value, uint decimals) /*internal*/ public constant returns (uint) {
426     uint multiplier = 10 ** decimals;
427     return value.mul(multiplier).div(PRESALE_TOKEN_IN_WEI);
428   }
429   
430   // caculate amount of token in crowdsale stage
431   function calculateTokenCrowsale(uint value, uint decimals) /*internal*/ public constant returns (uint) {
432     uint multiplier = 10 ** decimals;
433     return value.mul(multiplier).div(CROWDSALE_TOKEN_IN_WEI);
434   }
435   
436   // check if the goal is reached
437   function isMinimumGoalReached() public constant returns (bool) {
438     return crowdsale_eth_fund >= CROWDSALE_ETH_IN_WEI_FUND_MIN;
439   }
440   
441   // add new team percentage of tokens
442   function addTeamAddressInternal(address addr, uint release_time, uint token_percentage) internal {
443 	if((team_token_percentage_total.add(token_percentage)) > team_token_percentage_max) revert();
444 	if((team_token_percentage_total.add(token_percentage)) > 100) revert();
445 	if(team_addresses_token_percentage[addr] != 0) revert();
446 	
447 	team_addresses_token_percentage[addr]= token_percentage;
448 	team_addresses_idx[team_address_count]= addr;
449 	team_address_count++;
450 	
451 	team_token_percentage_total = team_token_percentage_total.add(token_percentage);
452 
453 	AddTeamAddress(addr, release_time, token_percentage);
454   }
455    
456   // @return true if crowdsale event has ended
457   function hasEnded() public constant returns (bool) {
458     return now > endsAt;
459   }
460 }
461 
462 contract Crowdsale is CrowdsaleLimit, Haltable {
463   using SafeMath for uint256;
464 
465   CrowdsaleToken public token;
466   
467   /* tokens will be transfered from this address */
468   address public multisigWallet;
469     
470   /** How much ETH each address has invested to this crowdsale */
471   mapping (address => uint256) public investedAmountOf;
472 
473   /** How much tokens this crowdsale has credited for each investor address */
474   mapping (address => uint256) public tokenAmountOf;
475   
476   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
477   mapping (address => bool) public presaleWhitelist;
478   
479   bool public whitelist_enable= true;
480   
481   /* the number of tokens already sold through this contract*/
482   uint public tokensSold = 0;
483   
484   /* How many distinct addresses have invested */
485   uint public investorCount = 0;
486   
487   /* How much wei we have returned back to the contract after a failed crowdfund. */
488   uint public loadedRefund = 0;
489   
490   /* Has this crowdsale been finalized */
491   bool public finalized;
492   
493   enum State{Unknown, PreFunding, Funding, Success, Failure, Finalized, Refunding}
494     
495   // A new investment was made
496   event Invested(address investor, uint weiAmount, uint tokenAmount);
497   
498   // Address early participation whitelist status changed
499   event Whitelisted(address addr, bool status);
500   
501   event createTeamTokenEvent(address addr, uint tokens);
502   
503   event Finalized();
504   
505   /** Modified allowing execution only if the crowdsale is currently running.  */
506   modifier inState(State state) {
507     if(getState() != state) revert();
508     _;
509   }
510 
511   function Crowdsale(address _token, address _multisigWallet, uint _start, uint _end, uint _token_max, uint _presale_token_in_wei, uint _crowdsale_token_in_wei, uint _presale_eth_inwei_fund_max, uint _crowdsale_eth_inwei_fund_min, uint _crowdsale_eth_inwei_fund_max, uint _crowdsale_eth_inwei_accepted_min, uint _crowdsale_gasprice_inwei_max, uint _team_token_percentage_max, bool _whitelist_enable) 
512            CrowdsaleLimit(_start, _end, _token_max, _presale_token_in_wei, _crowdsale_token_in_wei, _presale_eth_inwei_fund_max, _crowdsale_eth_inwei_fund_min, _crowdsale_eth_inwei_fund_max, _crowdsale_eth_inwei_accepted_min, _crowdsale_gasprice_inwei_max, _team_token_percentage_max)
513   {
514     require(_token != 0x0);
515     require(_multisigWallet != 0x0);
516 	
517 	token = CrowdsaleToken(_token);	
518 	multisigWallet = _multisigWallet;
519 	
520 	whitelist_enable= _whitelist_enable;
521   }
522   
523   /* Crowdfund state machine management. */
524   function getState() public constant returns (State) {
525     if(finalized) return State.Finalized;
526     else if (now < startsAt) return State.PreFunding;
527     else if (now <= endsAt && !isMinimumGoalReached()) return State.Funding;
528     else if (isMinimumGoalReached()) return State.Success;
529     else if (!isMinimumGoalReached() && crowdsale_eth_fund > 0 && loadedRefund >= crowdsale_eth_fund) return State.Refunding;
530     else return State.Failure;
531   }
532    
533   /**
534    * Allow addresses to do early participation.
535    *
536    * TODO: Fix spelling error in the name
537    */
538   function setPresaleWhitelist(address addr, bool status) onlyOwner inState(State.PreFunding) {
539 	require(whitelist_enable==true);
540 
541     presaleWhitelist[addr] = status;
542     Whitelisted(addr, status);
543   }
544   
545   //add new team percentage of tokens and lock their release time
546   function addTeamAddress(address addr, uint release_time, uint token_percentage) onlyOwner inState(State.PreFunding) external {
547 	super.addTeamAddressInternal(addr, release_time, token_percentage);
548 	token.addLockAddress(addr, release_time);  //not use delegatecall
549   }
550   
551   //generate team tokens in accordance with percentage of total issue tokens, not preallocate
552   function createTeamTokenByPercentage() onlyOwner internal {
553 	uint total= token.totalSupply();
554 	//uint tokens= total.mul(100).div(100-team_token_percentage_total).sub(total);
555 	uint tokens= total.mul(team_token_percentage_total).div(100-team_token_percentage_total);
556 	
557 	for(uint i=0; i<team_address_count; i++) {
558 		address addr= team_addresses_idx[i];
559 		if(addr==0x0) continue;
560 		
561 		uint ntoken= tokens.mul(team_addresses_token_percentage[addr]).div(team_token_percentage_total);
562 		token.mint(addr, ntoken);		
563 		createTeamTokenEvent(addr, ntoken);
564 	}
565   }
566   
567   // fallback function can be used to buy tokens
568   function () stopInEmergency allowCrowdsaleAmountLimit payable {
569 	require(msg.sender != 0x0);
570     buyTokensCrowdsale(msg.sender);
571   }
572 
573   // low level token purchase function
574   function buyTokensCrowdsale(address receiver) internal /*stopInEmergency allowCrowdsaleAmountLimit payable*/ {
575 	uint256 weiAmount = msg.value;
576 	uint256 tokenAmount= 0;
577 	
578 	if(getState() == State.PreFunding) {
579 		if(whitelist_enable==true) {
580 			if(!presaleWhitelist[receiver]) {
581 				revert();
582 			}
583 		}
584 		
585 		if((PRESALE_ETH_IN_WEI_FUND_MAX > 0) && ((presale_eth_fund.add(weiAmount)) > PRESALE_ETH_IN_WEI_FUND_MAX)) revert();		
586 		
587 		tokenAmount = calculateTokenPresale(weiAmount, token.decimals());
588 		presale_eth_fund = presale_eth_fund.add(weiAmount);
589 	}
590 	else if((getState() == State.Funding) || (getState() == State.Success)) {
591 		tokenAmount = calculateTokenCrowsale(weiAmount, token.decimals());
592 		
593     } else {
594       // Unwanted state
595       revert();
596     }
597 	
598 	if(tokenAmount == 0) {
599 		revert();
600 	}	
601 	
602 	if(investedAmountOf[receiver] == 0) {
603        investorCount++;
604     }
605     
606 	// Update investor
607     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
608     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
609 	
610     // Update totals
611 	crowdsale_eth_fund = crowdsale_eth_fund.add(weiAmount);
612 	tokensSold = tokensSold.add(tokenAmount);
613 	
614 	if((TOKEN_MAX > 0) && (tokensSold > TOKEN_MAX)) revert();
615 
616     token.mint(receiver, tokenAmount);
617 
618     if(!multisigWallet.send(weiAmount)) revert();
619 	
620 	// Tell us invest was success
621     Invested(receiver, weiAmount, tokenAmount);
622   }
623  
624   /**
625    * Allow load refunds back on the contract for the refunding.
626    *
627    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
628    */
629   function loadRefund() public payable inState(State.Failure) {
630     if(msg.value == 0) revert();
631     loadedRefund = loadedRefund.add(msg.value);
632   }
633   
634   /**
635    * Investors can claim refund.
636    *
637    * Note that any refunds from proxy buyers should be handled separately,
638    * and not through this contract.
639    */
640   function refund() public inState(State.Refunding) {
641     uint256 weiValue = investedAmountOf[msg.sender];
642     if (weiValue == 0) revert();
643     investedAmountOf[msg.sender] = 0;
644     crowdsale_eth_refund = crowdsale_eth_refund.add(weiValue);
645     Refund(msg.sender, weiValue);
646     if (!msg.sender.send(weiValue)) revert();
647   }
648   
649   function setEndsAt(uint time) onlyOwner {
650     if(now > time) {
651       revert();
652     }
653 
654     endsAt = time;
655     EndsAtChanged(endsAt);
656   }
657   
658   // should be called after crowdsale ends, to do
659   // some extra finalization work
660   function doFinalize() public inState(State.Success) onlyOwner stopInEmergency {
661     
662 	if(finalized) {
663       revert();
664     }
665 
666 	createTeamTokenByPercentage();
667     token.finishMinting();	
668         
669     finalized = true;
670 	Finalized();
671   }
672   
673 }
674 
675 contract CrowdsaleToken is ReleasableToken, MintableToken {
676 
677   string public name;
678 
679   string public symbol;
680 
681   uint public decimals;
682     
683   /**
684    * Construct the token.
685    *
686    * @param _name Token name
687    * @param _symbol Token symbol - should be all caps
688    * @param _initialSupply How many tokens we start with
689    * @param _decimals Number of decimal places
690    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
691    */
692   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) {
693 
694     owner = msg.sender;
695 
696     name = _name;
697     symbol = _symbol;
698 
699     totalSupply = _initialSupply;
700 
701     decimals = _decimals;
702 
703     balances[owner] = totalSupply;
704 
705     if(totalSupply > 0) {
706       Mint(owner, totalSupply);
707     }
708 
709     // No more new supply allowed after the token creation
710     if(!_mintable) {
711       mintingFinished = true;
712       if(totalSupply == 0) {
713         revert(); // Cannot create a token without supply and no minting
714       }
715     }
716   }
717 
718   /**
719    * When token is released to be transferable, enforce no new tokens can be created.
720    */
721    
722   function releaseTokenTransfer() public onlyReleaseAgent {
723     mintingFinished = true;
724     super.releaseTokenTransfer();
725   }
726   
727   //lock team address by crowdsale
728   function addLockAddress(address addr, uint lock_time) onlyMintAgent inReleaseState(false) public {
729 	super.addLockAddressInternal(addr, lock_time);
730   }
731 
732 }