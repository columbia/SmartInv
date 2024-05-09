1 pragma solidity 0.4.24;
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
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 contract MintableToken is StandardToken, Ownable {
273   event Mint(address indexed to, uint256 amount);
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply_ = totalSupply_.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     Mint(_to, _amount);
294     Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   /**
299    * @dev Function to stop minting new tokens.
300    * @return True if the operation was successful.
301    */
302   function finishMinting() onlyOwner canMint public returns (bool) {
303     mintingFinished = true;
304     MintFinished();
305     return true;
306   }
307 }
308 
309 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
310 
311 /**
312  * @title Pausable
313  * @dev Base contract which allows children to implement an emergency stop mechanism.
314  */
315 contract Pausable is Ownable {
316   event Pause();
317   event Unpause();
318 
319   bool public paused = false;
320 
321 
322   /**
323    * @dev Modifier to make a function callable only when the contract is not paused.
324    */
325   modifier whenNotPaused() {
326     require(!paused);
327     _;
328   }
329 
330   /**
331    * @dev Modifier to make a function callable only when the contract is paused.
332    */
333   modifier whenPaused() {
334     require(paused);
335     _;
336   }
337 
338   /**
339    * @dev called by the owner to pause, triggers stopped state
340    */
341   function pause() onlyOwner whenNotPaused public {
342     paused = true;
343     Pause();
344   }
345 
346   /**
347    * @dev called by the owner to unpause, returns to normal state
348    */
349   function unpause() onlyOwner whenPaused public {
350     paused = false;
351     Unpause();
352   }
353 }
354 
355 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
356 
357 /**
358  * @title Pausable token
359  * @dev StandardToken modified with pausable transfers.
360  **/
361 contract PausableToken is StandardToken, Pausable {
362 
363   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
364     return super.transfer(_to, _value);
365   }
366 
367   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
368     return super.transferFrom(_from, _to, _value);
369   }
370 
371   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
372     return super.approve(_spender, _value);
373   }
374 
375   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
376     return super.increaseApproval(_spender, _addedValue);
377   }
378 
379   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
380     return super.decreaseApproval(_spender, _subtractedValue);
381   }
382 }
383 
384 // File: contracts/GolixToken.sol
385 
386 /**
387  * @title Golix Token contract - ERC20 compatible token contract.
388  * @author Gustavo Guimaraes - <gustavoguimaraes@gmail.com>
389  */
390 contract GolixToken is PausableToken, MintableToken {
391     string public constant name = "Golix Token";
392     string public constant symbol = "GLX";
393     uint8 public constant decimals = 18;
394 
395     /**
396      * @dev Allow for staking of GLX tokens
397      * function is called only from owner which is the GLX token distribution contract
398      * is only triggered for a period of time and only if there are still tokens from crowdsale
399      * @param staker Address of token holder
400      * @param glxStakingContract Address where staking tokens goes to
401      */
402     function stakeGLX(address staker, address glxStakingContract) public onlyOwner {
403         uint256 stakerGLXBalance = balanceOf(staker);
404         balances[staker] = 0;
405         balances[glxStakingContract] = balances[glxStakingContract].add(stakerGLXBalance);
406         emit Transfer(staker, glxStakingContract, stakerGLXBalance);
407     }
408 }
409 
410 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
411 
412 /**
413  * @title SafeERC20
414  * @dev Wrappers around ERC20 operations that throw on failure.
415  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
416  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
417  */
418 library SafeERC20 {
419   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
420     assert(token.transfer(to, value));
421   }
422 
423   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
424     assert(token.transferFrom(from, to, value));
425   }
426 
427   function safeApprove(ERC20 token, address spender, uint256 value) internal {
428     assert(token.approve(spender, value));
429   }
430 }
431 
432 // File: contracts/VestTokenAllocation.sol
433 
434 /**
435  * @title VestTokenAllocation contract
436  * @author Gustavo Guimaraes - <gustavoguimaraes@gmail.com>
437  */
438 contract VestTokenAllocation is Ownable {
439     using SafeMath for uint256;
440     using SafeERC20 for ERC20;
441 
442     uint256 public cliff;
443     uint256 public start;
444     uint256 public duration;
445     uint256 public allocatedTokens;
446     uint256 public canSelfDestruct;
447 
448     mapping (address => uint256) public totalTokensLocked;
449     mapping (address => uint256) public releasedTokens;
450 
451     ERC20 public golix;
452     address public tokenDistribution;
453 
454     event Released(address beneficiary, uint256 amount);
455 
456     /**
457      * @dev creates the locking contract with vesting mechanism
458      * as well as ability to set tokens for addresses and time contract can self-destruct
459      * @param _token GolixToken address
460      * @param _tokenDistribution GolixTokenDistribution contract address
461      * @param _start timestamp representing the beginning of the token vesting process
462      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest. ie 1 year in secs
463      * @param _duration time in seconds of the period in which the tokens completely vest. ie 4 years in secs
464      * @param _canSelfDestruct timestamp of when contract is able to selfdestruct
465      */
466     function VestTokenAllocation
467         (
468             ERC20 _token,
469             address _tokenDistribution,
470             uint256 _start,
471             uint256 _cliff,
472             uint256 _duration,
473             uint256 _canSelfDestruct
474         )
475         public
476     {
477         require(_token != address(0) && _cliff != 0);
478         require(_cliff <= _duration);
479         require(_start > now);
480         require(_canSelfDestruct > _duration.add(_start));
481 
482         duration = _duration;
483         cliff = _start.add(_cliff);
484         start = _start;
485 
486         golix = ERC20(_token);
487         tokenDistribution = _tokenDistribution;
488         canSelfDestruct = _canSelfDestruct;
489     }
490 
491     modifier onlyOwnerOrTokenDistributionContract() {
492         require(msg.sender == address(owner) || msg.sender == address(tokenDistribution));
493         _;
494     }
495     /**
496      * @dev Adds vested token allocation
497      * @param beneficiary Ethereum address of a person
498      * @param allocationValue Number of tokens allocated to person
499      */
500     function addVestTokenAllocation(address beneficiary, uint256 allocationValue)
501         external
502         onlyOwnerOrTokenDistributionContract
503     {
504         require(totalTokensLocked[beneficiary] == 0 && beneficiary != address(0)); // can only add once.
505 
506         allocatedTokens = allocatedTokens.add(allocationValue);
507         require(allocatedTokens <= golix.balanceOf(this));
508 
509         totalTokensLocked[beneficiary] = allocationValue;
510     }
511 
512     /**
513      * @notice Transfers vested tokens to beneficiary.
514      */
515     function release() public {
516         uint256 unreleased = releasableAmount();
517 
518         require(unreleased > 0);
519 
520         releasedTokens[msg.sender] = releasedTokens[msg.sender].add(unreleased);
521 
522         golix.safeTransfer(msg.sender, unreleased);
523 
524         emit Released(msg.sender, unreleased);
525     }
526 
527     /**
528      * @dev Calculates the amount that has already vested but hasn't been released yet.
529      */
530     function releasableAmount() public view returns (uint256) {
531         return vestedAmount().sub(releasedTokens[msg.sender]);
532     }
533 
534     /**
535      * @dev Calculates the amount that has already vested.
536      */
537     function vestedAmount() public view returns (uint256) {
538         uint256 totalBalance = totalTokensLocked[msg.sender];
539 
540         if (now < cliff) {
541             return 0;
542         } else if (now >= start.add(duration)) {
543             return totalBalance;
544         } else {
545             return totalBalance.mul(now.sub(start)).div(duration);
546         }
547     }
548 
549     /**
550      * @dev allow for selfdestruct possibility and sending funds to owner
551      */
552     function kill() public onlyOwner {
553         require(now >= canSelfDestruct);
554         uint256 balance = golix.balanceOf(this);
555 
556         if (balance > 0) {
557             golix.transfer(msg.sender, balance);
558         }
559 
560         selfdestruct(owner);
561     }
562 }
563 
564 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
565 
566 /**
567  * @title Crowdsale
568  * @dev Crowdsale is a base contract for managing a token crowdsale.
569  * Crowdsales have a start and end timestamps, where investors can make
570  * token purchases and the crowdsale will assign them tokens based
571  * on a token per ETH rate. Funds collected are forwarded to a wallet
572  * as they arrive.
573  */
574 contract Crowdsale {
575   using SafeMath for uint256;
576 
577   // The token being sold
578   MintableToken public token;
579 
580   // start and end timestamps where investments are allowed (both inclusive)
581   uint256 public startTime;
582   uint256 public endTime;
583 
584   // address where funds are collected
585   address public wallet;
586 
587   // how many token units a buyer gets per wei
588   uint256 public rate;
589 
590   // amount of raised money in wei
591   uint256 public weiRaised;
592 
593   /**
594    * event for token purchase logging
595    * @param purchaser who paid for the tokens
596    * @param beneficiary who got the tokens
597    * @param value weis paid for purchase
598    * @param amount amount of tokens purchased
599    */
600   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
601 
602 
603   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
604     require(_startTime >= now);
605     require(_endTime >= _startTime);
606     require(_rate > 0);
607     require(_wallet != address(0));
608 
609     token = createTokenContract();
610     startTime = _startTime;
611     endTime = _endTime;
612     rate = _rate;
613     wallet = _wallet;
614   }
615 
616   // fallback function can be used to buy tokens
617   function () external payable {
618     buyTokens(msg.sender);
619   }
620 
621   // low level token purchase function
622   function buyTokens(address beneficiary) public payable {
623     require(beneficiary != address(0));
624     require(validPurchase());
625 
626     uint256 weiAmount = msg.value;
627 
628     // calculate token amount to be created
629     uint256 tokens = getTokenAmount(weiAmount);
630 
631     // update state
632     weiRaised = weiRaised.add(weiAmount);
633 
634     token.mint(beneficiary, tokens);
635     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
636 
637     forwardFunds();
638   }
639 
640   // @return true if crowdsale event has ended
641   function hasEnded() public view returns (bool) {
642     return now > endTime;
643   }
644 
645   // creates the token to be sold.
646   // override this method to have crowdsale of a specific mintable token.
647   function createTokenContract() internal returns (MintableToken) {
648     return new MintableToken();
649   }
650 
651   // Override this method to have a way to add business logic to your crowdsale when buying
652   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
653     return weiAmount.mul(rate);
654   }
655 
656   // send ether to the fund collection wallet
657   // override to create custom fund forwarding mechanisms
658   function forwardFunds() internal {
659     wallet.transfer(msg.value);
660   }
661 
662   // @return true if the transaction can buy tokens
663   function validPurchase() internal view returns (bool) {
664     bool withinPeriod = now >= startTime && now <= endTime;
665     bool nonZeroPurchase = msg.value != 0;
666     return withinPeriod && nonZeroPurchase;
667   }
668 
669 }
670 
671 // File: zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
672 
673 /**
674  * @title FinalizableCrowdsale
675  * @dev Extension of Crowdsale where an owner can do extra work
676  * after finishing.
677  */
678 contract FinalizableCrowdsale is Crowdsale, Ownable {
679   using SafeMath for uint256;
680 
681   bool public isFinalized = false;
682 
683   event Finalized();
684 
685   /**
686    * @dev Must be called after crowdsale ends, to do some extra finalization
687    * work. Calls the contract's finalization function.
688    */
689   function finalize() onlyOwner public {
690     require(!isFinalized);
691     require(hasEnded());
692 
693     finalization();
694     Finalized();
695 
696     isFinalized = true;
697   }
698 
699   /**
700    * @dev Can be overridden to add finalization logic. The overriding function
701    * should call super.finalization() to ensure the chain of finalization is
702    * executed entirely.
703    */
704   function finalization() internal {
705   }
706 }
707 
708 // File: contracts/GolixTokenDistribution.sol
709 
710 /**
711  * @title Golix token distribution contract - crowdsale contract for the Golix tokens.
712  * @author Gustavo Guimaraes - <gustavoguimaraes@gmail.com>
713  */
714 contract GolixTokenDistribution is FinalizableCrowdsale {
715     uint256 constant public TOTAL_TOKENS_SUPPLY = 1274240097e18; // 1,274,240,097 tokens
716     // =~ 10% for Marketing, investment fund, partners
717     uint256 constant public MARKETING_SHARE = 127424009e18;
718     // =~ 15% for issued to investors, shareholders
719     uint256 constant public SHAREHOLDERS_SHARE = 191136015e18;
720     // =~ 25% for founding team, future employees
721     uint256 constant public FOUNDERS_SHARE = 318560024e18;
722     uint256 constant public TOTAL_TOKENS_FOR_CROWDSALE = 637120049e18; // =~ 50 % of total token supply
723 
724     VestTokenAllocation public teamVestTokenAllocation;
725     VestTokenAllocation public contributorsVestTokenAllocation;
726     address public marketingWallet;
727     address public shareHoldersWallet;
728 
729     bool public canFinalizeEarly;
730     bool public isStakingPeriod;
731 
732     mapping (address => uint256) public icoContributions;
733 
734     event MintedTokensFor(address indexed investor, uint256 tokensPurchased);
735     event GLXStaked(address indexed staker, uint256 amount);
736 
737     /**
738      * @dev Contract constructor function
739      * @param _startTime The timestamp of the beginning of the crowdsale
740      * @param _endTime Timestamp when the crowdsale will finish
741      * @param _rate The token rate per ETH
742      * @param _wallet Multisig wallet that will hold the crowdsale funds.
743      * @param _marketingWallet address that will hold tokens for marketing campaign.
744      * @param _shareHoldersWallet address that will distribute shareholders tokens.
745      */
746     function GolixTokenDistribution
747         (
748             uint256 _startTime,
749             uint256 _endTime,
750             uint256 _rate,
751             address _wallet,
752             address _marketingWallet,
753             address _shareHoldersWallet
754         )
755         public
756         FinalizableCrowdsale()
757         Crowdsale(_startTime, _endTime, _rate, _wallet)
758     {
759         require(_marketingWallet != address(0) && _shareHoldersWallet != address(0));
760         require(
761             MARKETING_SHARE + SHAREHOLDERS_SHARE + FOUNDERS_SHARE + TOTAL_TOKENS_FOR_CROWDSALE
762             == TOTAL_TOKENS_SUPPLY
763         );
764 
765         marketingWallet = _marketingWallet;
766         shareHoldersWallet = _shareHoldersWallet;
767 
768         GolixToken(token).pause();
769     }
770 
771     /**
772      * @dev Mint tokens for crowdsale participants
773      * @param investorsAddress List of Purchasers addresses
774      * @param amountOfTokens List of token amounts for investor
775      */
776     function mintTokensForCrowdsaleParticipants(address[] investorsAddress, uint256[] amountOfTokens)
777         external
778         onlyOwner
779     {
780         require(investorsAddress.length == amountOfTokens.length);
781 
782         for (uint256 i = 0; i < investorsAddress.length; i++) {
783             require(token.totalSupply().add(amountOfTokens[i]) <= TOTAL_TOKENS_FOR_CROWDSALE);
784 
785             token.mint(investorsAddress[i], amountOfTokens[i]);
786             icoContributions[investorsAddress[i]] = icoContributions[investorsAddress[i]].add(amountOfTokens[i]);
787 
788             emit MintedTokensFor(investorsAddress[i], amountOfTokens[i]);
789         }
790     }
791     
792     // override buytokens so all minting comes from Golix
793     function buyTokens(address beneficiary) public payable {
794         revert();
795     }
796     
797     /**
798      * @dev Set addresses which should receive the vested team tokens share on finalization
799      * @param _teamVestTokenAllocation address of team and advisor allocation contract
800      * @param _contributorsVestTokenAllocation address of ico contributors
801      * who for glx staking event in case there is still left over tokens from crowdsale
802      */
803     function setVestTokenAllocationAddresses
804         (
805             address _teamVestTokenAllocation,
806             address _contributorsVestTokenAllocation
807         )
808         public
809         onlyOwner
810     {
811         require(_teamVestTokenAllocation != address(0) && _contributorsVestTokenAllocation != address(0));
812 
813         teamVestTokenAllocation = VestTokenAllocation(_teamVestTokenAllocation);
814         contributorsVestTokenAllocation = VestTokenAllocation(_contributorsVestTokenAllocation);
815     }
816 
817     // overriding Crowdsale#hasEnded to add cap logic
818     // @return true if crowdsale event has ended
819     function hasEnded() public view returns (bool) {
820         if (canFinalizeEarly) {
821             return true;
822         }
823 
824         return super.hasEnded();
825     }
826 
827     /**
828      * @dev Allow for staking of GLX tokens from crowdsale participants
829      * only works if tokens from token distribution are not sold out.
830      * investors must have GLX tokens in the same amount as it purchased during crowdsale
831      */
832     function stakeGLXForContributors() public {
833         uint256 senderGlxBalance = token.balanceOf(msg.sender);
834         require(senderGlxBalance == icoContributions[msg.sender] && isStakingPeriod);
835 
836         GolixToken(token).stakeGLX(msg.sender, contributorsVestTokenAllocation);
837         contributorsVestTokenAllocation.addVestTokenAllocation(msg.sender, senderGlxBalance);
838         emit GLXStaked(msg.sender, senderGlxBalance);
839     }
840 
841     /**
842     * @dev enables early finalization of crowdsale
843     */
844     function prepareForEarlyFinalization() public onlyOwner {
845         canFinalizeEarly = true;
846     }
847 
848     /**
849     * @dev disables staking period
850     */
851     function disableStakingPeriod() public onlyOwner {
852         isStakingPeriod = false;
853     }
854 
855     /**
856      * @dev Creates Golix token contract. This is called on the constructor function of the Crowdsale contract
857      */
858     function createTokenContract() internal returns (MintableToken) {
859         return new GolixToken();
860     }
861 
862     /**
863      * @dev finalizes crowdsale
864      */
865     function finalization() internal {
866         // This must have been set manually prior to finalize() call.
867         require(teamVestTokenAllocation != address(0) && contributorsVestTokenAllocation != address(0));
868 
869         if (TOTAL_TOKENS_FOR_CROWDSALE > token.totalSupply()) {
870             uint256 remainingTokens = TOTAL_TOKENS_FOR_CROWDSALE.sub(token.totalSupply());
871             token.mint(contributorsVestTokenAllocation, remainingTokens);
872             isStakingPeriod = true;
873         }
874 
875         // final minting
876         token.mint(marketingWallet, MARKETING_SHARE);
877         token.mint(shareHoldersWallet, SHAREHOLDERS_SHARE);
878         token.mint(teamVestTokenAllocation, FOUNDERS_SHARE);
879 
880         token.finishMinting();
881         GolixToken(token).unpause();
882         super.finalization();
883     }
884 }