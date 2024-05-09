1 pragma solidity 0.4.24;
2 /*
3 Capital Technologies & Research - Capital (CALL) & CapitalGAS (CALLG) - Crowdsale Smart Contract
4 https://www.mycapitalco.in
5 */
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   uint256 totalSupply_;
79 
80   /**
81   * @dev total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[msg.sender]);
95 
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     emit Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public view returns (uint256) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender)
119     public view returns (uint256);
120 
121   function transferFrom(address from, address to, uint256 value)
122     public returns (bool);
123 
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(
126     address indexed owner,
127     address indexed spender,
128     uint256 value
129   );
130 }
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) internal allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amount of tokens to be transferred
149    */
150   function transferFrom(
151     address _from,
152     address _to,
153     uint256 _value
154   )
155     public
156     returns (bool)
157   {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     emit Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(
192     address _owner,
193     address _spender
194    )
195     public
196     view
197     returns (uint256)
198   {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * @dev Increase the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseApproval(
213     address _spender,
214     uint _addedValue
215   )
216     public
217     returns (bool)
218   {
219     allowed[msg.sender][_spender] = (
220       allowed[msg.sender][_spender].add(_addedValue));
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(
236     address _spender,
237     uint _subtractedValue
238   )
239     public
240     returns (bool)
241   {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 /**
255  * @title Ownable
256  * @dev The Ownable contract has an owner address, and provides basic authorization control
257  * functions, this simplifies the implementation of "user permissions".
258  */
259 contract Ownable {
260   address public owner;
261 
262 
263   event OwnershipRenounced(address indexed previousOwner);
264   event OwnershipTransferred(
265     address indexed previousOwner,
266     address indexed newOwner
267   );
268 
269 
270   /**
271    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
272    * account.
273    */
274   constructor() public {
275     owner = msg.sender;
276   }
277 
278   /**
279    * @dev Throws if called by any account other than the owner.
280    */
281   modifier onlyOwner() {
282     require(msg.sender == owner);
283     _;
284   }
285 
286   /**
287    * @dev Allows the current owner to relinquish control of the contract.
288    */
289   function renounceOwnership() public onlyOwner {
290     emit OwnershipRenounced(owner);
291     owner = address(0);
292   }
293 
294   /**
295    * @dev Allows the current owner to transfer control of the contract to a newOwner.
296    * @param _newOwner The address to transfer ownership to.
297    */
298   function transferOwnership(address _newOwner) public onlyOwner {
299     _transferOwnership(_newOwner);
300   }
301 
302   /**
303    * @dev Transfers control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function _transferOwnership(address _newOwner) internal {
307     require(_newOwner != address(0));
308     emit OwnershipTransferred(owner, _newOwner);
309     owner = _newOwner;
310   }
311 }
312 
313 /**
314  * @title Mintable token
315  * @dev Simple ERC20 Token example, with mintable token creation
316  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
317  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
318  */
319 contract MintableToken is StandardToken, Ownable {
320   event Mint(address indexed to, uint256 amount);
321   event MintFinished();
322 
323   bool public mintingFinished = false;
324 
325 
326   modifier canMint() {
327     require(!mintingFinished);
328     _;
329   }
330 
331   modifier hasMintPermission() {
332     require(msg.sender == owner);
333     _;
334   }
335 
336   /**
337    * @dev Function to mint tokens
338    * @param _to The address that will receive the minted tokens.
339    * @param _amount The amount of tokens to mint.
340    * @return A boolean that indicates if the operation was successful.
341    */
342   function mint(
343     address _to,
344     uint256 _amount
345   )
346     hasMintPermission
347     canMint
348     public
349     returns (bool)
350   {
351     totalSupply_ = totalSupply_.add(_amount);
352     balances[_to] = balances[_to].add(_amount);
353     emit Mint(_to, _amount);
354     emit Transfer(address(0), _to, _amount);
355     return true;
356   }
357 
358   /**
359    * @dev Function to stop minting new tokens.
360    * @return True if the operation was successful.
361    */
362   function finishMinting() onlyOwner canMint public returns (bool) {
363     mintingFinished = true;
364     emit MintFinished();
365     return true;
366   }
367 }
368 
369 /**
370  * @title CAPITAL GAS (CALLG) Token
371  * @dev Token representing CALLG.
372  */
373 contract CALLGToken is MintableToken {
374 	string public name = "CAPITAL GAS";
375 	string public symbol = "CALLG";
376 	uint8 public decimals = 18;
377 }
378 
379 /**
380  * @title CAPITAL (CALL) Token
381  * @dev Token representing CALL.
382  */
383 contract CALLToken is MintableToken {
384 	string public name = "CAPITAL";
385 	string public symbol = "CALL";
386 	uint8 public decimals = 18;
387 }
388 
389 contract TeamVault is Ownable {
390     using SafeMath for uint256;
391     ERC20 public token_call;
392     ERC20 public token_callg;
393     event TeamWithdrawn(address indexed teamWallet, uint256 token_call, uint256 token_callg);
394     constructor (ERC20 _token_call, ERC20 _token_callg) public {
395         require(_token_call != address(0));
396         require(_token_callg != address(0));
397         token_call = _token_call;
398         token_callg = _token_callg;
399     }
400     function () public payable {
401     }
402     function withdrawTeam(address teamWallet) public onlyOwner {
403         require(teamWallet != address(0));
404         uint call_balance = token_call.balanceOf(this);
405         uint callg_balance = token_callg.balanceOf(this);
406         token_call.transfer(teamWallet, call_balance);
407         token_callg.transfer(teamWallet, callg_balance);
408         emit TeamWithdrawn(teamWallet, call_balance, callg_balance);
409     }
410 }
411 
412 contract BountyVault is Ownable {
413     using SafeMath for uint256;
414     ERC20 public token_call;
415     ERC20 public token_callg;
416     event BountyWithdrawn(address indexed bountyWallet, uint256 token_call, uint256 token_callg);
417     constructor (ERC20 _token_call, ERC20 _token_callg) public {
418         require(_token_call != address(0));
419         require(_token_callg != address(0));
420         token_call = _token_call;
421         token_callg = _token_callg;
422     }
423     function () public payable {
424     }
425     function withdrawBounty(address bountyWallet) public onlyOwner {
426         require(bountyWallet != address(0));
427         uint call_balance = token_call.balanceOf(this);
428         uint callg_balance = token_callg.balanceOf(this);
429         token_call.transfer(bountyWallet, call_balance);
430         token_callg.transfer(bountyWallet, callg_balance);
431         emit BountyWithdrawn(bountyWallet, call_balance, callg_balance);
432     }
433 }
434 
435 /**
436  * @title RefundVault
437  * @dev This contract is used for storing funds while a crowdsale
438  * is in progress. Supports refunding the money if crowdsale fails,
439  * and forwarding it if crowdsale is successful.
440  */
441 contract RefundVault is Ownable {
442   using SafeMath for uint256;
443 
444   enum State { Active, Refunding, Closed }
445 
446   mapping (address => uint256) public deposited;
447   address public wallet;
448   State public state;
449 
450   event Closed();
451   event RefundsEnabled();
452   event Refunded(address indexed beneficiary, uint256 weiAmount);
453 
454   /**
455    * @param _wallet Vault address
456    */
457   constructor(address _wallet) public {
458     require(_wallet != address(0));
459     wallet = _wallet;
460     state = State.Active;
461   }
462 
463   /**
464    * @param investor Investor address
465    */
466   function deposit(address investor) onlyOwner public payable {
467     require(state == State.Active);
468     deposited[investor] = deposited[investor].add(msg.value);
469   }
470 
471   function close() onlyOwner public {
472     require(state == State.Active);
473     state = State.Closed;
474     emit Closed();
475     wallet.transfer(address(this).balance);
476   }
477 
478   function enableRefunds() onlyOwner public {
479     require(state == State.Active);
480     state = State.Refunding;
481     emit RefundsEnabled();
482   }
483 
484   /**
485    * @param investor Investor address
486    */
487   function refund(address investor) public {
488     require(state == State.Refunding);
489     uint256 depositedValue = deposited[investor];
490     deposited[investor] = 0;
491     investor.transfer(depositedValue);
492     emit Refunded(investor, depositedValue);
493   }
494 }
495 contract FiatContract {
496   function USD(uint _id) public view returns (uint256);
497 }
498 contract CapitalTechCrowdsale is Ownable {
499   using SafeMath for uint256;
500   ERC20 public token_call;
501   ERC20 public token_callg;
502   FiatContract public fiat_contract;
503   RefundVault public vault;
504   TeamVault public teamVault;
505   BountyVault public bountyVault;
506   enum stages { PRIVATE_SALE, PRE_SALE, MAIN_SALE_1, MAIN_SALE_2, MAIN_SALE_3, MAIN_SALE_4, FINALIZED }
507   address public wallet;
508   uint256 public maxContributionPerAddress;
509   uint256 public stageStartTime;
510   uint256 public weiRaised;
511   uint256 public minInvestment;
512   stages public stage;
513   bool public is_finalized;
514   bool public powered_up;
515   bool public distributed_team;
516   bool public distributed_bounty;
517   mapping(address => uint256) public contributions;
518   mapping(address => uint256) public userHistory;
519   mapping(uint256 => uint256) public stages_duration;
520   uint256 public callSoftCap;
521   uint256 public callgSoftCap;
522   uint256 public callDistributed;
523   uint256 public callgDistributed;
524   uint256 public constant decimals = 18;
525   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount_call, uint256 amount_callg);
526   event TokenTransfer(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount_call, uint256 amount_callg);
527   event StageChanged(stages stage, stages next_stage, uint256 stageStartTime);
528   event GoalReached(uint256 callSoftCap, uint256 callgSoftCap);
529   event Finalized(uint256 callDistributed, uint256 callgDistributed);
530   function () external payable {
531     buyTokens(msg.sender);
532   }
533   constructor(address _wallet, address _fiatcontract, ERC20 _token_call, ERC20 _token_callg) public {
534     require(_token_call != address(0));
535     require(_token_callg != address(0));
536     require(_wallet != address(0));
537     require(_fiatcontract != address(0));
538     token_call = _token_call;
539     token_callg = _token_callg;
540     wallet = _wallet;
541     fiat_contract = FiatContract(_fiatcontract);
542     vault = new RefundVault(_wallet);
543     bountyVault = new BountyVault(_token_call, _token_callg);
544     teamVault = new TeamVault(_token_call, _token_callg);
545   }
546   function powerUpContract() public onlyOwner {
547     require(!powered_up);
548     require(!is_finalized);
549     stageStartTime = 1498867200;
550     stage = stages.PRIVATE_SALE;
551     weiRaised = 0;
552   	distributeTeam();
553   	distributeBounty();
554 	  callDistributed = 7875000 * 10 ** decimals;
555     callgDistributed = 1575000000 * 10 ** decimals;
556     callSoftCap = 18049500 * 10 ** decimals;
557     callgSoftCap = 3609900000 * 10 ** decimals;
558     maxContributionPerAddress = 1500 ether;
559     minInvestment = 0.01 ether;
560     is_finalized = false;
561     powered_up = true;
562     stages_duration[uint256(stages.PRIVATE_SALE)] = 30 days;
563     stages_duration[uint256(stages.PRE_SALE)] = 30 days;
564     stages_duration[uint256(stages.MAIN_SALE_1)] = 7 days;
565     stages_duration[uint256(stages.MAIN_SALE_2)] = 7 days;
566     stages_duration[uint256(stages.MAIN_SALE_3)] = 7 days;
567     stages_duration[uint256(stages.MAIN_SALE_4)] = 7 days;
568   }
569   function distributeTeam() public onlyOwner {
570     require(!distributed_team);
571     uint256 _amount = 5250000 * 10 ** decimals;
572     distributed_team = true;
573     MintableToken(token_call).mint(teamVault, _amount);
574     MintableToken(token_callg).mint(teamVault, _amount.mul(200));
575     emit TokenTransfer(msg.sender, teamVault, _amount, _amount, _amount.mul(200));
576   }
577   function distributeBounty() public onlyOwner {
578     require(!distributed_bounty);
579     uint256 _amount = 2625000 * 10 ** decimals;
580     distributed_bounty = true;
581     MintableToken(token_call).mint(bountyVault, _amount);
582     MintableToken(token_callg).mint(bountyVault, _amount.mul(200));
583     emit TokenTransfer(msg.sender, bountyVault, _amount, _amount, _amount.mul(200));
584   }
585   function withdrawBounty(address _beneficiary) public onlyOwner {
586     require(distributed_bounty);
587     bountyVault.withdrawBounty(_beneficiary);
588   }
589   function withdrawTeam(address _beneficiary) public onlyOwner {
590     require(distributed_team);
591     teamVault.withdrawTeam(_beneficiary);
592   }
593   function getUserContribution(address _beneficiary) public view returns (uint256) {
594     return contributions[_beneficiary];
595   }
596   function getUserHistory(address _beneficiary) public view returns (uint256) {
597     return userHistory[_beneficiary];
598   }
599   function getReferrals(address[] _beneficiaries) public view returns (address[], uint256[]) {
600   	address[] memory addrs = new address[](_beneficiaries.length);
601   	uint256[] memory funds = new uint256[](_beneficiaries.length);
602   	for (uint256 i = 0; i < _beneficiaries.length; i++) {
603   		addrs[i] = _beneficiaries[i];
604   		funds[i] = getUserHistory(_beneficiaries[i]);
605   	}
606     return (addrs, funds);
607   }
608   function getAmountForCurrentStage(uint256 _amount) public view returns(uint256) {
609     uint256 tokenPrice = fiat_contract.USD(0);
610     if(stage == stages.PRIVATE_SALE) {
611       tokenPrice = tokenPrice.mul(35).div(10 ** 8);
612     } else if(stage == stages.PRE_SALE) {
613       tokenPrice = tokenPrice.mul(50).div(10 ** 8);
614     } else if(stage == stages.MAIN_SALE_1) {
615       tokenPrice = tokenPrice.mul(70).div(10 ** 8);
616     } else if(stage == stages.MAIN_SALE_2) {
617       tokenPrice = tokenPrice.mul(80).div(10 ** 8);
618     } else if(stage == stages.MAIN_SALE_3) {
619       tokenPrice = tokenPrice.mul(90).div(10 ** 8);
620     } else if(stage == stages.MAIN_SALE_4) {
621       tokenPrice = tokenPrice.mul(100).div(10 ** 8);
622     }
623     return _amount.div(tokenPrice).mul(10 ** 10);
624   }
625   function _getNextStage() internal view returns (stages) {
626     stages next_stage;
627     if (stage == stages.PRIVATE_SALE) {
628       next_stage = stages.PRE_SALE;
629     } else if (stage == stages.PRE_SALE) {
630       next_stage = stages.MAIN_SALE_1;
631     } else if (stage == stages.MAIN_SALE_1) {
632       next_stage = stages.MAIN_SALE_2;
633     } else if (stage == stages.MAIN_SALE_2) {
634       next_stage = stages.MAIN_SALE_3;
635     } else if (stage == stages.MAIN_SALE_3) {
636       next_stage = stages.MAIN_SALE_4;
637     } else {
638       next_stage = stages.FINALIZED;
639     }
640     return next_stage;
641   }
642   function getHardCap() public view returns (uint256, uint256) {
643     uint256 hardcap_call;
644     uint256 hardcap_callg;
645     if (stage == stages.PRIVATE_SALE) {
646       hardcap_call = 10842563;
647       hardcap_callg = 2168512500;
648     } else if (stage == stages.PRE_SALE) {
649       hardcap_call = 18049500;
650       hardcap_callg = 3609900000;
651     } else if (stage == stages.MAIN_SALE_1) {
652       hardcap_call = 30937200;
653       hardcap_callg = 6187440000;
654     } else if (stage == stages.MAIN_SALE_2) {
655       hardcap_call = 40602975;
656       hardcap_callg = 8120595000;
657     } else if (stage == stages.MAIN_SALE_3) {
658       hardcap_call = 47046825;
659       hardcap_callg = 9409365000;
660     } else {
661       hardcap_call = 52500000;
662       hardcap_callg = 10500000000;
663     }
664     return (hardcap_call.mul(10 ** decimals), hardcap_callg.mul(10 ** decimals));
665   }
666   function updateStage() public {
667     _updateStage(0, 0);
668   }
669   function _updateStage(uint256 weiAmount, uint256 callAmount) internal {
670     uint256 _duration = stages_duration[uint256(stage)];
671     uint256 call_tokens = 0;
672     if (weiAmount != 0) {
673       call_tokens = getAmountForCurrentStage(weiAmount);
674     } else {
675       call_tokens = callAmount;
676     }
677     uint256 callg_tokens = call_tokens.mul(200);
678     (uint256 _hardcapCall, uint256 _hardcapCallg) = getHardCap();
679     if(stageStartTime.add(_duration) <= block.timestamp || callDistributed.add(call_tokens) >= _hardcapCall || callgDistributed.add(callg_tokens) >= _hardcapCallg) {
680       stages next_stage = _getNextStage();
681       emit StageChanged(stage, next_stage, stageStartTime);
682       stage = next_stage;
683       if (next_stage != stages.FINALIZED) {
684         stageStartTime = block.timestamp;
685       } else {
686         finalization();
687       }
688     }
689   }
690   function buyTokens(address _beneficiary) public payable {
691     require(!is_finalized);
692     if (_beneficiary == address(0)) {
693       _beneficiary = msg.sender;
694     }
695     uint256 weiAmount = msg.value;
696     require(weiAmount > 0);
697     require(_beneficiary != address(0));
698     require(weiAmount >= minInvestment);
699     require(contributions[_beneficiary].add(weiAmount) <= maxContributionPerAddress);
700     _updateStage(weiAmount, 0);
701     uint256 call_tokens = getAmountForCurrentStage(weiAmount);
702     uint256 callg_tokens = call_tokens.mul(200);
703     weiRaised = weiRaised.add(weiAmount);
704     callDistributed = callDistributed.add(call_tokens);
705     callgDistributed = callgDistributed.add(callg_tokens);
706     MintableToken(token_call).mint(_beneficiary, call_tokens);
707     MintableToken(token_callg).mint(_beneficiary, callg_tokens);
708     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, call_tokens, callg_tokens);
709     contributions[_beneficiary] = contributions[_beneficiary].add(weiAmount);
710     userHistory[_beneficiary] = userHistory[_beneficiary].add(call_tokens);
711     vault.deposit.value(msg.value)(msg.sender);
712   }
713   function finalize() onlyOwner public {
714     stage = stages.FINALIZED;
715     finalization();
716   }
717   function extendPeriod(uint256 date) public onlyOwner {
718     stages_duration[uint256(stage)] = stages_duration[uint256(stage)].add(date);
719   }
720   function transferTokens(address _to, uint256 _amount) public onlyOwner {
721     require(!is_finalized);
722     require(_to != address(0));
723     require(_amount > 0);
724     _updateStage(0, _amount);
725     callDistributed = callDistributed.add(_amount);
726     callgDistributed = callgDistributed.add(_amount.mul(200));
727     if (stage == stages.FINALIZED) {
728       (uint256 _hardcapCall, uint256 _hardcapCallg) = getHardCap();
729       require(callDistributed.add(callDistributed) <= _hardcapCall);
730       require(callgDistributed.add(callgDistributed) <= _hardcapCallg);
731     }
732     MintableToken(token_call).mint(_to, _amount);
733     MintableToken(token_callg).mint(_to, _amount.mul(200));
734     userHistory[_to] = userHistory[_to].add(_amount);
735     emit TokenTransfer(msg.sender, _to, _amount, _amount, _amount.mul(200));
736   }
737   function claimRefund() public {
738 	  address _beneficiary = msg.sender;
739     require(is_finalized);
740     require(!goalReached());
741     userHistory[_beneficiary] = 0;
742     vault.refund(_beneficiary);
743   }
744   function goalReached() public view returns (bool) {
745     if (callDistributed >= callSoftCap && callgDistributed >= callgSoftCap) {
746       return true;
747     } else {
748       return false;
749     }
750   }
751   function finishMinting() public onlyOwner {
752     MintableToken(token_call).finishMinting();
753     MintableToken(token_callg).finishMinting();
754   }
755   function finalization() internal {
756     require(!is_finalized);
757     is_finalized = true;
758     finishMinting();
759     emit Finalized(callDistributed, callgDistributed);
760     if (goalReached()) {
761       emit GoalReached(callSoftCap, callgSoftCap);
762       vault.close();
763     } else {
764       vault.enableRefunds();
765     }
766   }
767 }