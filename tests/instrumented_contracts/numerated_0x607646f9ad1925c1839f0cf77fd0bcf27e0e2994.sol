1 pragma solidity 0.4.18;
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
47 // File: zeppelin-solidity/contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228 }
229 
230 // File: zeppelin-solidity/contracts/token/MintableToken.sol
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   /**
252    * @dev Function to mint tokens
253    * @param _to The address that will receive the minted tokens.
254    * @param _amount The amount of tokens to mint.
255    * @return A boolean that indicates if the operation was successful.
256    */
257   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
258     totalSupply = totalSupply.add(_amount);
259     balances[_to] = balances[_to].add(_amount);
260     Mint(_to, _amount);
261     Transfer(address(0), _to, _amount);
262     return true;
263   }
264 
265   /**
266    * @dev Function to stop minting new tokens.
267    * @return True if the operation was successful.
268    */
269   function finishMinting() onlyOwner canMint public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 }
275 
276 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
277 
278 /**
279  * @title Pausable
280  * @dev Base contract which allows children to implement an emergency stop mechanism.
281  */
282 contract Pausable is Ownable {
283   event Pause();
284   event Unpause();
285 
286   bool public paused = false;
287 
288 
289   /**
290    * @dev Modifier to make a function callable only when the contract is not paused.
291    */
292   modifier whenNotPaused() {
293     require(!paused);
294     _;
295   }
296 
297   /**
298    * @dev Modifier to make a function callable only when the contract is paused.
299    */
300   modifier whenPaused() {
301     require(paused);
302     _;
303   }
304 
305   /**
306    * @dev called by the owner to pause, triggers stopped state
307    */
308   function pause() onlyOwner whenNotPaused public {
309     paused = true;
310     Pause();
311   }
312 
313   /**
314    * @dev called by the owner to unpause, returns to normal state
315    */
316   function unpause() onlyOwner whenPaused public {
317     paused = false;
318     Unpause();
319   }
320 }
321 
322 // File: zeppelin-solidity/contracts/token/PausableToken.sol
323 
324 /**
325  * @title Pausable token
326  *
327  * @dev StandardToken modified with pausable transfers.
328  **/
329 
330 contract PausableToken is StandardToken, Pausable {
331 
332   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
333     return super.transfer(_to, _value);
334   }
335 
336   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
337     return super.transferFrom(_from, _to, _value);
338   }
339 
340   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
341     return super.approve(_spender, _value);
342   }
343 
344   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
345     return super.increaseApproval(_spender, _addedValue);
346   }
347 
348   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
349     return super.decreaseApproval(_spender, _subtractedValue);
350   }
351 }
352 
353 // File: contracts/ODEMToken.sol
354 
355 /**
356  * @title ODEM Token contract - ERC20 compatible token contract.
357  * @author Gustavo Guimaraes - <gustavo@odem.io>
358  */
359 
360 contract ODEMToken is PausableToken, MintableToken {
361     string public constant name = "ODEM Token";
362     string public constant symbol = "ODEM";
363     uint8 public constant decimals = 18;
364 }
365 
366 // File: contracts/TeamAndAdvisorsAllocation.sol
367 
368 /**
369  * @title Team and Advisors Token Allocation contract
370  * @author Gustavo Guimaraes - <gustavo@odem.io>
371  */
372 
373 contract TeamAndAdvisorsAllocation is Ownable {
374     using SafeMath for uint;
375 
376     uint256 public unlockedAt;
377     uint256 public canSelfDestruct;
378     uint256 public tokensCreated;
379     uint256 public allocatedTokens;
380     uint256 private totalTeamAndAdvisorsAllocation = 38763636e18; // 38 mm
381 
382     mapping (address => uint256) public teamAndAdvisorsAllocations;
383 
384     ODEMToken public odem;
385 
386     /**
387      * @dev constructor function that sets owner and token for the TeamAndAdvisorsAllocation contract
388      * @param token Token contract address for ODEMToken
389      */
390     function TeamAndAdvisorsAllocation(address token) public {
391         odem = ODEMToken(token);
392         unlockedAt = now.add(182 days);
393         canSelfDestruct = now.add(365 days);
394     }
395 
396     /**
397      * @dev Adds founders' token allocation
398      * @param teamOrAdvisorsAddress Address of a founder
399      * @param allocationValue Number of tokens allocated to a founder
400      * @return true if address is correctly added
401      */
402     function addTeamAndAdvisorsAllocation(address teamOrAdvisorsAddress, uint256 allocationValue)
403         external
404         onlyOwner
405         returns(bool)
406     {
407         assert(teamAndAdvisorsAllocations[teamOrAdvisorsAddress] == 0); // can only add once.
408 
409         allocatedTokens = allocatedTokens.add(allocationValue);
410         require(allocatedTokens <= totalTeamAndAdvisorsAllocation);
411 
412         teamAndAdvisorsAllocations[teamOrAdvisorsAddress] = allocationValue;
413         return true;
414     }
415 
416     /**
417      * @dev Allow company to unlock allocated tokens by transferring them whitelisted addresses.
418      * Need to be called by each address
419      */
420     function unlock() external {
421         assert(now >= unlockedAt);
422 
423         // During first unlock attempt fetch total number of locked tokens.
424         if (tokensCreated == 0) {
425             tokensCreated = odem.balanceOf(this);
426         }
427 
428         uint256 transferAllocation = teamAndAdvisorsAllocations[msg.sender];
429         teamAndAdvisorsAllocations[msg.sender] = 0;
430 
431         // Will fail if allocation (and therefore toTransfer) is 0.
432         require(odem.transfer(msg.sender, transferAllocation));
433     }
434 
435     /**
436      * @dev allow for selfdestruct possibility and sending funds to owner
437      */
438     function kill() public onlyOwner {
439         assert(now >= canSelfDestruct);
440         uint256 balance = odem.balanceOf(this);
441 
442         if (balance > 0) {
443             odem.transfer(owner, balance);
444         }
445 
446         selfdestruct(owner);
447     }
448 }
449 
450 // File: contracts/Whitelist.sol
451 
452 contract Whitelist is Ownable {
453     mapping(address => bool) public allowedAddresses;
454 
455     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
456 
457     function addToWhitelist(address[] _addresses) public onlyOwner {
458         for (uint256 i = 0; i < _addresses.length; i++) {
459             allowedAddresses[_addresses[i]] = true;
460             WhitelistUpdated(now, "Added", _addresses[i]);
461         }
462     }
463 
464     function removeFromWhitelist(address[] _addresses) public onlyOwner {
465         for (uint256 i = 0; i < _addresses.length; i++) {
466             allowedAddresses[_addresses[i]] = false;
467             WhitelistUpdated(now, "Removed", _addresses[i]);
468         }
469     }
470 
471     function isWhitelisted(address _address) public view returns (bool) {
472         return allowedAddresses[_address];
473     }
474 }
475 
476 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
477 
478 /**
479  * @title Crowdsale
480  * @dev Crowdsale is a base contract for managing a token crowdsale.
481  * Crowdsales have a start and end timestamps, where investors can make
482  * token purchases and the crowdsale will assign them tokens based
483  * on a token per ETH rate. Funds collected are forwarded to a wallet
484  * as they arrive.
485  */
486 contract Crowdsale {
487   using SafeMath for uint256;
488 
489   // The token being sold
490   MintableToken public token;
491 
492   // start and end timestamps where investments are allowed (both inclusive)
493   uint256 public startTime;
494   uint256 public endTime;
495 
496   // address where funds are collected
497   address public wallet;
498 
499   // how many token units a buyer gets per wei
500   uint256 public rate;
501 
502   // amount of raised money in wei
503   uint256 public weiRaised;
504 
505   /**
506    * event for token purchase logging
507    * @param purchaser who paid for the tokens
508    * @param beneficiary who got the tokens
509    * @param value weis paid for purchase
510    * @param amount amount of tokens purchased
511    */
512   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
513 
514 
515   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
516     require(_startTime >= now);
517     require(_endTime >= _startTime);
518     require(_rate > 0);
519     require(_wallet != address(0));
520 
521     token = createTokenContract();
522     startTime = _startTime;
523     endTime = _endTime;
524     rate = _rate;
525     wallet = _wallet;
526   }
527 
528   // creates the token to be sold.
529   // override this method to have crowdsale of a specific mintable token.
530   function createTokenContract() internal returns (MintableToken) {
531     return new MintableToken();
532   }
533 
534 
535   // fallback function can be used to buy tokens
536   function () external payable {
537     buyTokens(msg.sender);
538   }
539 
540   // low level token purchase function
541   function buyTokens(address beneficiary) public payable {
542     require(beneficiary != address(0));
543     require(validPurchase());
544 
545     uint256 weiAmount = msg.value;
546 
547     // calculate token amount to be created
548     uint256 tokens = weiAmount.mul(rate);
549 
550     // update state
551     weiRaised = weiRaised.add(weiAmount);
552 
553     token.mint(beneficiary, tokens);
554     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
555 
556     forwardFunds();
557   }
558 
559   // send ether to the fund collection wallet
560   // override to create custom fund forwarding mechanisms
561   function forwardFunds() internal {
562     wallet.transfer(msg.value);
563   }
564 
565   // @return true if the transaction can buy tokens
566   function validPurchase() internal view returns (bool) {
567     bool withinPeriod = now >= startTime && now <= endTime;
568     bool nonZeroPurchase = msg.value != 0;
569     return withinPeriod && nonZeroPurchase;
570   }
571 
572   // @return true if crowdsale event has ended
573   function hasEnded() public view returns (bool) {
574     return now > endTime;
575   }
576 
577 
578 }
579 
580 // File: zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
581 
582 /**
583  * @title FinalizableCrowdsale
584  * @dev Extension of Crowdsale where an owner can do extra work
585  * after finishing.
586  */
587 contract FinalizableCrowdsale is Crowdsale, Ownable {
588   using SafeMath for uint256;
589 
590   bool public isFinalized = false;
591 
592   event Finalized();
593 
594   /**
595    * @dev Must be called after crowdsale ends, to do some extra finalization
596    * work. Calls the contract's finalization function.
597    */
598   function finalize() onlyOwner public {
599     require(!isFinalized);
600     require(hasEnded());
601 
602     finalization();
603     Finalized();
604 
605     isFinalized = true;
606   }
607 
608   /**
609    * @dev Can be overridden to add finalization logic. The overriding function
610    * should call super.finalization() to ensure the chain of finalization is
611    * executed entirely.
612    */
613   function finalization() internal {
614   }
615 }
616 
617 // File: contracts/ODEMCrowdsale.sol
618 
619 /**
620  * @title ODEM Crowdsale contract - crowdsale contract for the ODEM tokens.
621  * @author Gustavo Guimaraes - <gustavo@odem.io>
622  */
623 
624 contract ODEMCrowdsale is FinalizableCrowdsale, Pausable {
625     uint256 constant public BOUNTY_REWARD_SHARE =           43666667e18; // 43 mm
626     uint256 constant public VESTED_TEAM_ADVISORS_SHARE =    38763636e18; // 38 mm
627     uint256 constant public NON_VESTED_TEAM_ADVISORS_SHARE = 5039200e18; //  5 mm
628     uint256 constant public COMPANY_SHARE =                 71300194e18; // 71 mm
629 
630     uint256 constant public PRE_CROWDSALE_CAP =      58200000e18; //  58 mm
631     uint256 constant public PUBLIC_CROWDSALE_CAP =  180000000e18; // 180 mm
632     uint256 constant public TOTAL_TOKENS_FOR_CROWDSALE = PRE_CROWDSALE_CAP + PUBLIC_CROWDSALE_CAP;
633     uint256 constant public TOTAL_TOKENS_SUPPLY =   396969697e18; // 396 mm
634     uint256 constant public PERSONAL_FIRST_HOUR_CAP = 2000000e18; //   2 mm
635 
636     address public rewardWallet;
637     address public teamAndAdvisorsAllocation;
638     uint256 public oneHourAfterStartTime;
639 
640     // remainderPurchaser and remainderTokens info saved in the contract
641     // used for reference for contract owner to send refund if any to last purchaser after end of crowdsale
642     address public remainderPurchaser;
643     uint256 public remainderAmount;
644 
645     mapping (address => uint256) public trackBuyersPurchases;
646 
647     // external contracts
648     Whitelist public whitelist;
649 
650     event PrivateInvestorTokenPurchase(address indexed investor, uint256 tokensPurchased);
651     event TokenRateChanged(uint256 previousRate, uint256 newRate);
652 
653     /**
654      * @dev Contract constructor function
655      * @param _startTime The timestamp of the beginning of the crowdsale
656      * @param _endTime Timestamp when the crowdsale will finish
657      * @param _whitelist contract containing the whitelisted addresses
658      * @param _rate The token rate per ETH
659      * @param _wallet Multisig wallet that will hold the crowdsale funds.
660      * @param _rewardWallet wallet that will hold tokens bounty and rewards campaign
661      */
662     function ODEMCrowdsale
663         (
664             uint256 _startTime,
665             uint256 _endTime,
666             address _whitelist,
667             uint256 _rate,
668             address _wallet,
669             address _rewardWallet
670         )
671         public
672         FinalizableCrowdsale()
673         Crowdsale(_startTime, _endTime, _rate, _wallet)
674     {
675 
676         require(_whitelist != address(0) && _wallet != address(0) && _rewardWallet != address(0));
677         whitelist = Whitelist(_whitelist);
678         rewardWallet = _rewardWallet;
679         oneHourAfterStartTime = startTime.add(1 hours);
680 
681         ODEMToken(token).pause();
682     }
683 
684     modifier whitelisted(address beneficiary) {
685         require(whitelist.isWhitelisted(beneficiary));
686         _;
687     }
688 
689     /**
690      * @dev change crowdsale rate
691      * @param newRate Figure that corresponds to the new rate per token
692      */
693     function setRate(uint256 newRate) external onlyOwner {
694         require(newRate != 0);
695 
696         TokenRateChanged(rate, newRate);
697         rate = newRate;
698     }
699 
700     /**
701      * @dev Mint tokens for pre crowdsale putchases before crowdsale starts
702      * @param investorsAddress Purchaser's address
703      * @param tokensPurchased Tokens purchased during pre crowdsale
704      */
705     function mintTokenForPreCrowdsale(address investorsAddress, uint256 tokensPurchased)
706         external
707         onlyOwner
708     {
709         require(now < startTime && investorsAddress != address(0));
710         require(token.totalSupply().add(tokensPurchased) <= PRE_CROWDSALE_CAP);
711 
712         token.mint(investorsAddress, tokensPurchased);
713         PrivateInvestorTokenPurchase(investorsAddress, tokensPurchased);
714     }
715 
716     /**
717      * @dev Set the address which should receive the vested team tokens share on finalization
718      * @param _teamAndAdvisorsAllocation address of team and advisor allocation contract
719      */
720     function setTeamWalletAddress(address _teamAndAdvisorsAllocation) public onlyOwner {
721         require(_teamAndAdvisorsAllocation != address(0x0));
722         teamAndAdvisorsAllocation = _teamAndAdvisorsAllocation;
723     }
724 
725     /**
726      * @dev payable function that allow token purchases
727      * @param beneficiary Address of the purchaser
728      */
729     function buyTokens(address beneficiary)
730         public
731         whenNotPaused
732         whitelisted(beneficiary)
733         payable
734     {
735         require(beneficiary != address(0));
736         require(msg.sender == beneficiary);
737         require(validPurchase() && token.totalSupply() < TOTAL_TOKENS_FOR_CROWDSALE);
738 
739         uint256 weiAmount = msg.value;
740 
741         // calculate token amount to be created
742         uint256 tokens = weiAmount.mul(rate);
743 
744         // checks whether personal token purchase cap has been reached within crowdsale first hour
745         if (now < oneHourAfterStartTime)
746             require(trackBuyersPurchases[msg.sender].add(tokens) <= PERSONAL_FIRST_HOUR_CAP);
747 
748         trackBuyersPurchases[beneficiary] = trackBuyersPurchases[beneficiary].add(tokens);
749 
750         //remainder logic
751         if (token.totalSupply().add(tokens) > TOTAL_TOKENS_FOR_CROWDSALE) {
752             tokens = TOTAL_TOKENS_FOR_CROWDSALE.sub(token.totalSupply());
753             weiAmount = tokens.div(rate);
754 
755             // save info so as to refund purchaser after crowdsale's end
756             remainderPurchaser = msg.sender;
757             remainderAmount = msg.value.sub(weiAmount);
758         }
759 
760         // update state
761         weiRaised = weiRaised.add(weiAmount);
762 
763         token.mint(beneficiary, tokens);
764         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
765 
766         forwardFunds();
767     }
768 
769     // overriding Crowdsale#hasEnded to add cap logic
770     // @return true if crowdsale event has ended
771     function hasEnded() public view returns (bool) {
772         if (token.totalSupply() == TOTAL_TOKENS_FOR_CROWDSALE) {
773             return true;
774         }
775 
776         return super.hasEnded();
777     }
778 
779     /**
780      * @dev Creates ODEM token contract. This is called on the constructor function of the Crowdsale contract
781      */
782     function createTokenContract() internal returns (MintableToken) {
783         return new ODEMToken();
784     }
785 
786     /**
787      * @dev finalizes crowdsale
788      */
789     function finalization() internal {
790         // This must have been set manually prior to finalize().
791         require(teamAndAdvisorsAllocation != address(0x0));
792 
793         // final minting
794         token.mint(teamAndAdvisorsAllocation, VESTED_TEAM_ADVISORS_SHARE);
795         token.mint(wallet, NON_VESTED_TEAM_ADVISORS_SHARE);
796         token.mint(wallet, COMPANY_SHARE);
797         token.mint(rewardWallet, BOUNTY_REWARD_SHARE);
798 
799         if (TOTAL_TOKENS_SUPPLY > token.totalSupply()) {
800             uint256 remainingTokens = TOTAL_TOKENS_SUPPLY.sub(token.totalSupply());
801 
802             token.mint(wallet, remainingTokens);
803         }
804 
805         token.finishMinting();
806         ODEMToken(token).unpause();
807         super.finalization();
808     }
809 }