1 pragma solidity ^0.4.19;
2 
3 contract CrowdsaleLimit {
4   using SafeMath for uint256;
5 
6   // the UNIX timestamp start date of the crowdsale
7   uint public startsAt;
8   // the UNIX timestamp end date of the crowdsale
9   uint public endsAt;
10   // setting the max token 
11   uint public TOKEN_MAX;
12   // seting the wei value for one token in presale stage
13   uint public PRESALE_TOKEN_IN_WEI = 9 finney;
14   // total eth fund in presale stage
15   uint public presale_eth_fund= 0;
16   
17   // seting the wei value for one token in crowdsale stage
18   uint public CROWDSALE_TOKEN_IN_WEI = 10 finney;  
19   
20   // seting the max fund of presale with eth
21   uint public PRESALE_ETH_IN_WEI_FUND_MAX = 0 ether; 
22   // seting the min fund of crowdsale with eth
23   uint public CROWDSALE_ETH_IN_WEI_FUND_MIN = 100 ether;
24   // seting the max fund of crowdsale with eth
25   uint public CROWDSALE_ETH_IN_WEI_FUND_MAX = 1000 ether;
26   // seting the min acceptable invest with eth
27   uint public CROWDSALE_ETH_IN_WEI_ACCEPTED_MIN = 100 finney;   //0.1 ether
28   // seting the gasprice to limit big buyer, default to disable
29   uint public CROWDSALE_GASPRICE_IN_WEI_MAX = 0;
30  
31   // total eth fund
32   uint public crowdsale_eth_fund= 0;
33   // total eth refund
34   uint public crowdsale_eth_refund = 0;
35    
36   // setting team list and set percentage of tokens
37   mapping(address => uint) public team_addresses_token_percentage;
38   mapping(uint => address) public team_addresses_idx;
39   uint public team_address_count= 0;
40   uint public team_token_percentage_total= 0;
41   uint public team_token_percentage_max= 0;
42     
43   event EndsAtChanged(uint newEndsAt);
44   event AddTeamAddress(address addr, uint release_time, uint token_percentage);
45   event Refund(address investor, uint weiAmount);
46     
47   // limitation of buying tokens
48   modifier allowCrowdsaleAmountLimit(){	
49 	if (msg.value == 0) revert();
50 	if (msg.value < CROWDSALE_ETH_IN_WEI_ACCEPTED_MIN) revert();
51 	if((crowdsale_eth_fund.add(msg.value)) > CROWDSALE_ETH_IN_WEI_FUND_MAX) revert();
52 	if((CROWDSALE_GASPRICE_IN_WEI_MAX > 0) && (tx.gasprice > CROWDSALE_GASPRICE_IN_WEI_MAX)) revert();
53 	_;
54   }  
55    
56   function CrowdsaleLimit(uint _start, uint _end, uint _token_max, uint _presale_token_in_wei, uint _crowdsale_token_in_wei, uint _presale_eth_inwei_fund_max, uint _crowdsale_eth_inwei_fund_min, uint _crowdsale_eth_inwei_fund_max, uint _crowdsale_eth_inwei_accepted_min, uint _crowdsale_gasprice_inwei_max, uint _team_token_percentage_max) {
57 	require(_start != 0);
58 	require(_end != 0);
59 	require(_start < _end);
60 	
61 	if( (_presale_token_in_wei == 0) ||
62 	    (_crowdsale_token_in_wei == 0) ||
63 		(_crowdsale_eth_inwei_fund_min == 0) ||
64 		(_crowdsale_eth_inwei_fund_max == 0) ||
65 		(_crowdsale_eth_inwei_accepted_min == 0) ||
66 		(_team_token_percentage_max >= 100))  //example 20%=20
67 		revert();
68 		
69 	startsAt = _start;
70     endsAt = _end;
71 	
72 	TOKEN_MAX = _token_max;
73 		
74 	PRESALE_TOKEN_IN_WEI = _presale_token_in_wei;
75 	
76 	CROWDSALE_TOKEN_IN_WEI = _crowdsale_token_in_wei;	
77 	PRESALE_ETH_IN_WEI_FUND_MAX = _presale_eth_inwei_fund_max;
78 	CROWDSALE_ETH_IN_WEI_FUND_MIN = _crowdsale_eth_inwei_fund_min;
79 	CROWDSALE_ETH_IN_WEI_FUND_MAX = _crowdsale_eth_inwei_fund_max;
80 	CROWDSALE_ETH_IN_WEI_ACCEPTED_MIN = _crowdsale_eth_inwei_accepted_min;
81 	CROWDSALE_GASPRICE_IN_WEI_MAX = _crowdsale_gasprice_inwei_max;
82 	
83 	team_token_percentage_max= _team_token_percentage_max;
84   }
85     
86   // caculate amount of token in presale stage
87   function calculateTokenPresale(uint value, uint decimals) /*internal*/ public constant returns (uint) {
88     uint multiplier = 10 ** decimals;
89     return value.mul(multiplier).div(PRESALE_TOKEN_IN_WEI);
90   }
91   
92   // caculate amount of token in crowdsale stage
93   function calculateTokenCrowsale(uint value, uint decimals) /*internal*/ public constant returns (uint) {
94     uint multiplier = 10 ** decimals;
95     return value.mul(multiplier).div(CROWDSALE_TOKEN_IN_WEI);
96   }
97   
98   // check if the goal is reached
99   function isMinimumGoalReached() public constant returns (bool) {
100     return crowdsale_eth_fund >= CROWDSALE_ETH_IN_WEI_FUND_MIN;
101   }
102   
103   // add new team percentage of tokens
104   function addTeamAddressInternal(address addr, uint release_time, uint token_percentage) internal {
105 	if((team_token_percentage_total.add(token_percentage)) > team_token_percentage_max) revert();
106 	if((team_token_percentage_total.add(token_percentage)) > 100) revert();
107 	if(team_addresses_token_percentage[addr] != 0) revert();
108 	
109 	team_addresses_token_percentage[addr]= token_percentage;
110 	team_addresses_idx[team_address_count]= addr;
111 	team_address_count++;
112 	
113 	team_token_percentage_total = team_token_percentage_total.add(token_percentage);
114 
115 	AddTeamAddress(addr, release_time, token_percentage);
116   }
117    
118   // @return true if crowdsale event has ended
119   function hasEnded() public constant returns (bool) {
120     return now > endsAt;
121   }
122 }
123 
124 contract Ownable {
125   address public owner;
126 
127 
128   /**
129    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
130    * account.
131    */
132   function Ownable() {
133     owner = msg.sender;
134   }
135 
136 
137   /**
138    * @dev Throws if called by any account other than the owner.
139    */
140   modifier onlyOwner() {
141     require(msg.sender == owner);
142     _;
143   }
144 
145 
146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address newOwner) onlyOwner {
151     require(newOwner != address(0));      
152     owner = newOwner;
153   }
154 
155 }
156 
157 contract ERC20Basic {
158   function totalSupply() public view returns (uint256);
159   function balanceOf(address who) public view returns (uint256);
160   function transfer(address to, uint256 value) public returns (bool);
161   event Transfer(address indexed from, address indexed to, uint256 value);
162 }
163 
164 contract ERC20 is ERC20Basic {
165   function allowance(address owner, address spender) public view returns (uint256);
166   function transferFrom(address from, address to, uint256 value) public returns (bool);
167   function approve(address spender, uint256 value) public returns (bool);
168   event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 contract Haltable is Ownable {
172   bool public halted;
173 
174   modifier stopInEmergency {
175     if (halted) revert();
176     _;
177   }
178 
179   modifier onlyInEmergency {
180     if (!halted) revert();
181     _;
182   }
183 
184   // called by the owner on emergency, triggers stopped state
185   function halt() external onlyOwner {
186     halted = true;
187   }
188 
189   // called by the owner on end of emergency, returns to normal state
190   function unhalt() external onlyOwner onlyInEmergency {
191     halted = false;
192   }
193 
194 }
195 
196 contract Crowdsale is CrowdsaleLimit, Haltable {
197   using SafeMath for uint256;
198 
199   CrowdsaleToken public token;
200   
201   /* tokens will be transfered from this address */
202   address public multisigWallet;
203     
204   /** How much ETH each address has invested to this crowdsale */
205   mapping (address => uint256) public investedAmountOf;
206 
207   /** How much tokens this crowdsale has credited for each investor address */
208   mapping (address => uint256) public tokenAmountOf;
209   
210   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
211   mapping (address => bool) public presaleWhitelist;
212   
213   bool public whitelist_enable= true;
214   
215   /* the number of tokens already sold through this contract*/
216   uint public tokensSold = 0;
217   
218   /* How many distinct addresses have invested */
219   uint public investorCount = 0;
220   
221   /* How much wei we have returned back to the contract after a failed crowdfund. */
222   uint public loadedRefund = 0;
223   
224   /* Has this crowdsale been finalized */
225   bool public finalized;
226   
227   enum State{Unknown, PreFunding, Funding, Success, Failure, Finalized, Refunding}
228     
229   // A new investment was made
230   event Invested(address investor, uint weiAmount, uint tokenAmount);
231   
232   // Address early participation whitelist status changed
233   event Whitelisted(address addr, bool status);
234   
235   event createTeamTokenEvent(address addr, uint tokens);
236   
237   event Finalized();
238   
239   /** Modified allowing execution only if the crowdsale is currently running.  */
240   modifier inState(State state) {
241     if(getState() != state) revert();
242     _;
243   }
244 
245   function Crowdsale(address _token, address _multisigWallet, uint _start, uint _end, uint _token_max, uint _presale_token_in_wei, uint _crowdsale_token_in_wei, uint _presale_eth_inwei_fund_max, uint _crowdsale_eth_inwei_fund_min, uint _crowdsale_eth_inwei_fund_max, uint _crowdsale_eth_inwei_accepted_min, uint _crowdsale_gasprice_inwei_max, uint _team_token_percentage_max, bool _whitelist_enable) 
246            CrowdsaleLimit(_start, _end, _token_max, _presale_token_in_wei, _crowdsale_token_in_wei, _presale_eth_inwei_fund_max, _crowdsale_eth_inwei_fund_min, _crowdsale_eth_inwei_fund_max, _crowdsale_eth_inwei_accepted_min, _crowdsale_gasprice_inwei_max, _team_token_percentage_max)
247   {
248     require(_token != 0x0);
249     require(_multisigWallet != 0x0);
250 	
251 	token = CrowdsaleToken(_token);	
252 	multisigWallet = _multisigWallet;
253 	
254 	whitelist_enable= _whitelist_enable;
255   }
256   
257   /* Crowdfund state machine management. */
258   function getState() public constant returns (State) {
259     if(finalized) return State.Finalized;
260     else if (now < startsAt) return State.PreFunding;
261     else if (now <= endsAt && !isMinimumGoalReached()) return State.Funding;
262     else if (isMinimumGoalReached()) return State.Success;
263     else if (!isMinimumGoalReached() && crowdsale_eth_fund > 0 && loadedRefund >= crowdsale_eth_fund) return State.Refunding;
264     else return State.Failure;
265   }
266    
267   /**
268    * Allow addresses to do early participation.
269    *
270    * TODO: Fix spelling error in the name
271    */
272   function setPresaleWhitelist(address addr, bool status) onlyOwner inState(State.PreFunding) {
273 	require(whitelist_enable==true);
274 
275     presaleWhitelist[addr] = status;
276     Whitelisted(addr, status);
277   }
278   
279   //add new team percentage of tokens and lock their release time
280   function addTeamAddress(address addr, uint release_time, uint token_percentage) onlyOwner inState(State.PreFunding) external {
281 	super.addTeamAddressInternal(addr, release_time, token_percentage);
282 	token.addLockAddress(addr, release_time);  //not use delegatecall
283   }
284   
285   //generate team tokens in accordance with percentage of total issue tokens, not preallocate
286   function createTeamTokenByPercentage() onlyOwner internal {
287 	//uint total= token.totalSupply();
288 	uint total= tokensSold;
289 	
290 	//uint tokens= total.mul(100).div(100-team_token_percentage_total).sub(total);
291 	uint tokens= total.mul(team_token_percentage_total).div(100-team_token_percentage_total);
292 	
293 	for(uint i=0; i<team_address_count; i++) {
294 		address addr= team_addresses_idx[i];
295 		if(addr==0x0) continue;
296 		
297 		uint ntoken= tokens.mul(team_addresses_token_percentage[addr]).div(team_token_percentage_total);
298 		token.mint(addr, ntoken);		
299 		createTeamTokenEvent(addr, ntoken);
300 	}
301   }
302   
303   // fallback function can be used to buy tokens
304   function () stopInEmergency allowCrowdsaleAmountLimit payable {
305 	require(msg.sender != 0x0);
306     buyTokensCrowdsale(msg.sender);
307   }
308 
309   // low level token purchase function
310   function buyTokensCrowdsale(address receiver) internal /*stopInEmergency allowCrowdsaleAmountLimit payable*/ {
311 	uint256 weiAmount = msg.value;
312 	uint256 tokenAmount= 0;
313 	
314 	if(getState() == State.PreFunding) {
315 		if(whitelist_enable==true) {
316 			if(!presaleWhitelist[receiver]) {
317 				revert();
318 			}
319 		}
320 		
321 		if((PRESALE_ETH_IN_WEI_FUND_MAX > 0) && ((presale_eth_fund.add(weiAmount)) > PRESALE_ETH_IN_WEI_FUND_MAX)) revert();		
322 		
323 		tokenAmount = calculateTokenPresale(weiAmount, token.decimals());
324 		presale_eth_fund = presale_eth_fund.add(weiAmount);
325 	}
326 	else if((getState() == State.Funding) || (getState() == State.Success)) {
327 		tokenAmount = calculateTokenCrowsale(weiAmount, token.decimals());
328 		
329     } else {
330       // Unwanted state
331       revert();
332     }
333 	
334 	if(tokenAmount == 0) {
335 		revert();
336 	}	
337 	
338 	if(investedAmountOf[receiver] == 0) {
339        investorCount++;
340     }
341     
342 	// Update investor
343     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
344     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
345 	
346     // Update totals
347 	crowdsale_eth_fund = crowdsale_eth_fund.add(weiAmount);
348 	tokensSold = tokensSold.add(tokenAmount);
349 	
350 	if((TOKEN_MAX > 0) && (tokensSold > TOKEN_MAX)) revert();
351 
352     token.mint(receiver, tokenAmount);
353 
354     if(!multisigWallet.send(weiAmount)) revert();
355 	
356 	// Tell us invest was success
357     Invested(receiver, weiAmount, tokenAmount);
358   }
359  
360   /**
361    * Allow load refunds back on the contract for the refunding.
362    *
363    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
364    */
365   function loadRefund() public payable inState(State.Failure) {
366     if(msg.value == 0) revert();
367     loadedRefund = loadedRefund.add(msg.value);
368   }
369   
370   /**
371    * Investors can claim refund.
372    *
373    * Note that any refunds from proxy buyers should be handled separately,
374    * and not through this contract.
375    */
376   function refund() public inState(State.Refunding) {
377     uint256 weiValue = investedAmountOf[msg.sender];
378     if (weiValue == 0) revert();
379     investedAmountOf[msg.sender] = 0;
380     crowdsale_eth_refund = crowdsale_eth_refund.add(weiValue);
381     Refund(msg.sender, weiValue);
382     if (!msg.sender.send(weiValue)) revert();
383   }
384   
385   function setEndsAt(uint time) onlyOwner {
386     if(now > time) {
387       revert();
388     }
389 
390     endsAt = time;
391     EndsAtChanged(endsAt);
392   }
393   
394   // should be called after crowdsale ends, to do
395   // some extra finalization work
396   function doFinalize() public inState(State.Success) onlyOwner stopInEmergency {
397     
398 	if(finalized) {
399       revert();
400     }
401 
402 	createTeamTokenByPercentage();
403     token.finishMinting();	
404         
405     finalized = true;
406 	Finalized();
407   }
408   
409 }
410 
411 contract BasicToken is ERC20Basic {
412   using SafeMath for uint256;
413 
414   mapping(address => uint256) balances;
415 
416   uint256 totalSupply_;
417 
418   /**
419   * @dev total number of tokens in existence
420   */
421   function totalSupply() public view returns (uint256) {
422     return totalSupply_;
423   }
424 
425   /**
426   * @dev transfer token for a specified address
427   * @param _to The address to transfer to.
428   * @param _value The amount to be transferred.
429   */
430   function transfer(address _to, uint256 _value) public returns (bool) {
431     require(_to != address(0));
432     require(_value <= balances[msg.sender]);
433 
434     // SafeMath.sub will throw if there is not enough balance.
435     balances[msg.sender] = balances[msg.sender].sub(_value);
436     balances[_to] = balances[_to].add(_value);
437     Transfer(msg.sender, _to, _value);
438     return true;
439   }
440 
441   /**
442   * @dev Gets the balance of the specified address.
443   * @param _owner The address to query the the balance of.
444   * @return An uint256 representing the amount owned by the passed address.
445   */
446   function balanceOf(address _owner) public view returns (uint256 balance) {
447     return balances[_owner];
448   }
449 
450 }
451 
452 contract StandardToken is ERC20, BasicToken {
453 
454   mapping (address => mapping (address => uint256)) internal allowed;
455 
456 
457   /**
458    * @dev Transfer tokens from one address to another
459    * @param _from address The address which you want to send tokens from
460    * @param _to address The address which you want to transfer to
461    * @param _value uint256 the amount of tokens to be transferred
462    */
463   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
464     require(_to != address(0));
465     require(_value <= balances[_from]);
466     require(_value <= allowed[_from][msg.sender]);
467 
468     balances[_from] = balances[_from].sub(_value);
469     balances[_to] = balances[_to].add(_value);
470     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
471     Transfer(_from, _to, _value);
472     return true;
473   }
474 
475   /**
476    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
477    *
478    * Beware that changing an allowance with this method brings the risk that someone may use both the old
479    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
480    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
481    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
482    * @param _spender The address which will spend the funds.
483    * @param _value The amount of tokens to be spent.
484    */
485   function approve(address _spender, uint256 _value) public returns (bool) {
486     allowed[msg.sender][_spender] = _value;
487     Approval(msg.sender, _spender, _value);
488     return true;
489   }
490 
491   /**
492    * @dev Function to check the amount of tokens that an owner allowed to a spender.
493    * @param _owner address The address which owns the funds.
494    * @param _spender address The address which will spend the funds.
495    * @return A uint256 specifying the amount of tokens still available for the spender.
496    */
497   function allowance(address _owner, address _spender) public view returns (uint256) {
498     return allowed[_owner][_spender];
499   }
500 
501   /**
502    * @dev Increase the amount of tokens that an owner allowed to a spender.
503    *
504    * approve should be called when allowed[_spender] == 0. To increment
505    * allowed value is better to use this function to avoid 2 calls (and wait until
506    * the first transaction is mined)
507    * From MonolithDAO Token.sol
508    * @param _spender The address which will spend the funds.
509    * @param _addedValue The amount of tokens to increase the allowance by.
510    */
511   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
512     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
513     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
514     return true;
515   }
516 
517   /**
518    * @dev Decrease the amount of tokens that an owner allowed to a spender.
519    *
520    * approve should be called when allowed[_spender] == 0. To decrement
521    * allowed value is better to use this function to avoid 2 calls (and wait until
522    * the first transaction is mined)
523    * From MonolithDAO Token.sol
524    * @param _spender The address which will spend the funds.
525    * @param _subtractedValue The amount of tokens to decrease the allowance by.
526    */
527   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
528     uint oldValue = allowed[msg.sender][_spender];
529     if (_subtractedValue > oldValue) {
530       allowed[msg.sender][_spender] = 0;
531     } else {
532       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
533     }
534     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
535     return true;
536   }
537 
538 }
539 
540 contract MintableToken is StandardToken, Ownable {
541   bool public mintingFinished = false;
542   
543   /** List of agents that are allowed to create new tokens */
544   mapping (address => bool) public mintAgents;
545 
546   event MintingAgentChanged(address addr, bool state  );
547   event Mint(address indexed to, uint256 amount);
548   event MintFinished();
549 
550   modifier onlyMintAgent() {
551     // Only crowdsale contracts are allowed to mint new tokens
552     if(!mintAgents[msg.sender]) {
553         revert();
554     }
555     _;
556   }
557   
558   modifier canMint() {
559     require(!mintingFinished);
560     _;
561   }
562   
563   /**
564    * Owner can allow a crowdsale contract to mint new tokens.
565    */
566   function setMintAgent(address addr, bool state) onlyOwner canMint public {
567     mintAgents[addr] = state;
568     MintingAgentChanged(addr, state);
569   }
570 
571   /**
572    * @dev Function to mint tokens
573    * @param _to The address that will recieve the minted tokens.
574    * @param _amount The amount of tokens to mint.
575    * @return A boolean that indicates if the operation was successful.
576    */
577   function mint(address _to, uint256 _amount) onlyMintAgent canMint public returns (bool) {
578     totalSupply_ = totalSupply_.add(_amount);
579     balances[_to] = balances[_to].add(_amount);
580     Mint(_to, _amount);
581 	
582 	Transfer(address(0), _to, _amount);
583     return true;
584   }
585 
586   /**
587    * @dev Function to stop minting new tokens.
588    * @return True if the operation was successful.
589    */
590   function finishMinting() onlyMintAgent public returns (bool) {
591     mintingFinished = true;
592     MintFinished();
593     return true;
594   }
595 }
596 
597 contract ReleasableToken is ERC20, Ownable {
598 
599   /* The finalizer contract that allows unlift the transfer limits on this token */
600   address public releaseAgent;
601 
602   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
603   bool public released = false;
604 
605   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
606   mapping (address => bool) public transferAgents;
607   
608   //dtco : time lock with specific address
609   mapping(address => uint) public lock_addresses;
610   
611   event AddLockAddress(address addr, uint lock_time);  
612 
613   /**
614    * Limit token transfer until the crowdsale is over.
615    *
616    */
617   modifier canTransfer(address _sender) {
618 
619     if(!released) {
620         if(!transferAgents[_sender]) {
621             revert();
622         }
623     }
624 	else {
625 		//check time lock with team
626 		if(now < lock_addresses[_sender]) {
627 			revert();
628 		}
629 	}
630     _;
631   }
632   
633   function ReleasableToken() {
634 	releaseAgent = msg.sender;
635   }
636   
637   //lock new team release time
638   function addLockAddressInternal(address addr, uint lock_time) inReleaseState(false) internal {
639 	if(addr == 0x0) revert();
640 	lock_addresses[addr]= lock_time;
641 	AddLockAddress(addr, lock_time);
642   }
643   
644   
645   /**
646    * Set the contract that can call release and make the token transferable.
647    *
648    * Design choice. Allow reset the release agent to fix fat finger mistakes.
649    */
650   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
651 
652     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
653     releaseAgent = addr;
654   }
655 
656   /**
657    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
658    */
659   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
660     transferAgents[addr] = state;
661   }
662   
663   /** The function can be called only by a whitelisted release agent. */
664   modifier onlyReleaseAgent() {
665     if(msg.sender != releaseAgent) {
666         revert();
667     }
668     _;
669   }
670 
671   /**
672    * One way function to release the tokens to the wild.
673    *
674    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
675    */
676   function releaseTokenTransfer() public onlyReleaseAgent {
677     released = true;
678   }
679 
680   /** The function can be called only before or after the tokens have been releasesd */
681   modifier inReleaseState(bool releaseState) {
682     if(releaseState != released) {
683         revert();
684     }
685     _;
686   }  
687 
688   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
689     // Call StandardToken.transfer()
690    return super.transfer(_to, _value);
691   }
692 
693   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
694     // Call StandardToken.transferForm()
695     return super.transferFrom(_from, _to, _value);
696   }
697 
698 }
699 
700 contract CrowdsaleToken is ReleasableToken, MintableToken {
701 
702   string public name;
703 
704   string public symbol;
705 
706   uint public decimals;
707     
708   /**
709    * Construct the token.
710    *
711    * @param _name Token name
712    * @param _symbol Token symbol - should be all caps
713    * @param _initialSupply How many tokens we start with
714    * @param _decimals Number of decimal places
715    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
716    */
717   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) {
718 
719     owner = msg.sender;
720 
721     name = _name;
722     symbol = _symbol;
723 
724     totalSupply_ = _initialSupply;
725 
726     decimals = _decimals;
727 
728     balances[owner] = totalSupply_;
729 
730     if(totalSupply_ > 0) {
731       Mint(owner, totalSupply_);
732     }
733 
734     // No more new supply allowed after the token creation
735     if(!_mintable) {
736       mintingFinished = true;
737       if(totalSupply_ == 0) {
738         revert(); // Cannot create a token without supply and no minting
739       }
740     }
741   }
742 
743   /**
744    * When token is released to be transferable, enforce no new tokens can be created.
745    */
746    
747   function releaseTokenTransfer() public onlyReleaseAgent {
748     mintingFinished = true;
749     super.releaseTokenTransfer();
750   }
751   
752   //lock team address by crowdsale
753   function addLockAddress(address addr, uint lock_time) onlyMintAgent inReleaseState(false) public {
754 	super.addLockAddressInternal(addr, lock_time);
755   }
756 
757 }
758 
759 library SafeMath {
760   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
761     uint256 c = a * b;
762     assert(a == 0 || c / a == b);
763     return c;
764   }
765 
766   function div(uint256 a, uint256 b) internal constant returns (uint256) {
767     // assert(b > 0); // Solidity automatically throws when dividing by 0
768     uint256 c = a / b;
769     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
770     return c;
771   }
772 
773   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
774     assert(b <= a);
775     return a - b;
776   }
777 
778   function add(uint256 a, uint256 b) internal constant returns (uint256) {
779     uint256 c = a + b;
780     assert(c >= a);
781     return c;
782   }
783 }