1 pragma solidity 0.4.19;
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
353 // File: contracts/ICNQToken.sol
354 
355 /**
356  * @title ICNQ Token contract - ERC20 compatible token contract.
357  * @author Gustavo Guimaraes - <gustavoguimaraes@gmail.com>
358  */
359 contract ICNQToken is PausableToken, MintableToken {
360     string public constant name = "Iconiq Lab Token";
361     string public constant symbol = "ICNQ";
362     uint8 public constant decimals = 18;
363 }
364 
365 // File: contracts/Whitelist.sol
366 
367 contract Whitelist is Ownable {
368     mapping(address => bool) public allowedAddresses;
369 
370     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
371 
372     function addToWhitelist(address[] _addresses) public onlyOwner {
373         for (uint256 i = 0; i < _addresses.length; i++) {
374             allowedAddresses[_addresses[i]] = true;
375             WhitelistUpdated(now, "Added", _addresses[i]);
376         }
377     }
378 
379     function removeFromWhitelist(address[] _addresses) public onlyOwner {
380         for (uint256 i = 0; i < _addresses.length; i++) {
381             allowedAddresses[_addresses[i]] = false;
382             WhitelistUpdated(now, "Removed", _addresses[i]);
383         }
384     }
385 
386     function isWhitelisted(address _address) public view returns (bool) {
387         return allowedAddresses[_address];
388     }
389 }
390 
391 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
392 
393 /**
394  * @title Crowdsale
395  * @dev Crowdsale is a base contract for managing a token crowdsale.
396  * Crowdsales have a start and end timestamps, where investors can make
397  * token purchases and the crowdsale will assign them tokens based
398  * on a token per ETH rate. Funds collected are forwarded to a wallet
399  * as they arrive.
400  */
401 contract Crowdsale {
402   using SafeMath for uint256;
403 
404   // The token being sold
405   MintableToken public token;
406 
407   // start and end timestamps where investments are allowed (both inclusive)
408   uint256 public startTime;
409   uint256 public endTime;
410 
411   // address where funds are collected
412   address public wallet;
413 
414   // how many token units a buyer gets per wei
415   uint256 public rate;
416 
417   // amount of raised money in wei
418   uint256 public weiRaised;
419 
420   /**
421    * event for token purchase logging
422    * @param purchaser who paid for the tokens
423    * @param beneficiary who got the tokens
424    * @param value weis paid for purchase
425    * @param amount amount of tokens purchased
426    */
427   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
428 
429 
430   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
431     require(_startTime >= now);
432     require(_endTime >= _startTime);
433     require(_rate > 0);
434     require(_wallet != address(0));
435 
436     token = createTokenContract();
437     startTime = _startTime;
438     endTime = _endTime;
439     rate = _rate;
440     wallet = _wallet;
441   }
442 
443   // creates the token to be sold.
444   // override this method to have crowdsale of a specific mintable token.
445   function createTokenContract() internal returns (MintableToken) {
446     return new MintableToken();
447   }
448 
449 
450   // fallback function can be used to buy tokens
451   function () external payable {
452     buyTokens(msg.sender);
453   }
454 
455   // low level token purchase function
456   function buyTokens(address beneficiary) public payable {
457     require(beneficiary != address(0));
458     require(validPurchase());
459 
460     uint256 weiAmount = msg.value;
461 
462     // calculate token amount to be created
463     uint256 tokens = weiAmount.mul(rate);
464 
465     // update state
466     weiRaised = weiRaised.add(weiAmount);
467 
468     token.mint(beneficiary, tokens);
469     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
470 
471     forwardFunds();
472   }
473 
474   // send ether to the fund collection wallet
475   // override to create custom fund forwarding mechanisms
476   function forwardFunds() internal {
477     wallet.transfer(msg.value);
478   }
479 
480   // @return true if the transaction can buy tokens
481   function validPurchase() internal view returns (bool) {
482     bool withinPeriod = now >= startTime && now <= endTime;
483     bool nonZeroPurchase = msg.value != 0;
484     return withinPeriod && nonZeroPurchase;
485   }
486 
487   // @return true if crowdsale event has ended
488   function hasEnded() public view returns (bool) {
489     return now > endTime;
490   }
491 
492 
493 }
494 
495 // File: zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
496 
497 /**
498  * @title FinalizableCrowdsale
499  * @dev Extension of Crowdsale where an owner can do extra work
500  * after finishing.
501  */
502 contract FinalizableCrowdsale is Crowdsale, Ownable {
503   using SafeMath for uint256;
504 
505   bool public isFinalized = false;
506 
507   event Finalized();
508 
509   /**
510    * @dev Must be called after crowdsale ends, to do some extra finalization
511    * work. Calls the contract's finalization function.
512    */
513   function finalize() onlyOwner public {
514     require(!isFinalized);
515     require(hasEnded());
516 
517     finalization();
518     Finalized();
519 
520     isFinalized = true;
521   }
522 
523   /**
524    * @dev Can be overridden to add finalization logic. The overriding function
525    * should call super.finalization() to ensure the chain of finalization is
526    * executed entirely.
527    */
528   function finalization() internal {
529   }
530 }
531 
532 // File: contracts/ICNQCrowdsale.sol
533 
534 /**
535  * @title ICNQ Crowdsale contract - crowdsale contract for the ICNQ tokens.
536  * @author Gustavo Guimaraes - <gustavoguimaraes@gmail.com>
537  */
538 contract ICNQCrowdsale is FinalizableCrowdsale, Pausable {
539     uint256 public presaleEndTime;
540 
541     // token supply figures
542     uint256 constant public TOTAL_TOKENS_SUPPLY = 20000000e18; // 20M
543 
544     uint256 public constant OPTIONAL_POOL = 4650000e18; // 4.65M
545     uint256 public constant FINLAB_PRESALE = 2000000e18; // 2M
546     uint256 public constant EOS = 2000000e18; // 2M
547     uint256 public constant US_INSTITUTIONAL = 1500000e18; // 1.5M
548     uint256 public constant PRIVATE_SALE_TOTAL = OPTIONAL_POOL + FINLAB_PRESALE + EOS + US_INSTITUTIONAL; // 10.15M
549 
550     // 10.15 of the private sale + 750K for presale
551     uint256 constant public PRE_SALE_TOTAL_TOKENS = PRIVATE_SALE_TOTAL + 750000e18;
552     // 10.15 of the private sale + 750K for presale + 3M for crowdsale
553     uint256 constant public TOTAL_TOKENS_FOR_CROWDSALE = PRE_SALE_TOTAL_TOKENS + 3000000e18;
554 
555     uint256 public constant TEAM_ADVISORS_SHARE = 3100000e18; // 3.1M
556     uint256 public constant COMPANY_SHARE = 2000000e18; // 2M
557     uint256 public constant BOUNTY_CAMPAIGN_SHARE = 1000000e18; // 1M
558 
559     address public teamAndAdvisorsAllocation;
560 
561     event PrivateInvestorTokenPurchase(address indexed investor, uint256 tokensPurchased);
562     event TokenRateChanged(uint256 previousRate, uint256 newRate);
563 
564     // external contracts
565     Whitelist public whitelist;
566 
567     /**
568      * @dev Contract constructor function
569      * @param _startTime The timestamp of the beginning of the crowdsale
570      * @param _presaleEndTime End of presale in timestamp
571      * @param _endTime Timestamp when the crowdsale will finish
572      * @param _whitelist contract containing the whitelisted addresses
573      * @param _rate The token rate per ETH
574      * @param _wallet Multisig wallet that will hold the crowdsale funds.
575      */
576     function ICNQCrowdsale
577         (
578             uint256 _startTime,
579             uint256 _presaleEndTime,
580             uint256 _endTime,
581             address _whitelist,
582             uint256 _rate,
583             address _wallet
584         )
585         public
586         FinalizableCrowdsale()
587         Crowdsale(_startTime, _endTime, _rate, _wallet)
588     {
589         require(_whitelist != address(0));
590 
591         presaleEndTime = _presaleEndTime;
592         whitelist = Whitelist(_whitelist);
593         ICNQToken(token).pause();
594     }
595 
596     modifier whitelisted(address beneficiary) {
597         require(whitelist.isWhitelisted(beneficiary));
598         _;
599     }
600 
601     /**
602      * @dev Mint tokens for private investors before crowdsale starts
603      * @param investorsAddress Purchaser's address
604      * @param tokensPurchased Tokens purchased during pre crowdsale
605      */
606     function mintTokenForPrivateInvestors(address investorsAddress, uint256 tokensPurchased)
607         external
608         onlyOwner
609     {
610         require(now < startTime && investorsAddress != address(0));
611         require(token.totalSupply().add(tokensPurchased) <= PRIVATE_SALE_TOTAL);
612 
613         token.mint(investorsAddress, tokensPurchased);
614         PrivateInvestorTokenPurchase(investorsAddress, tokensPurchased);
615     }
616 
617     /**
618      * @dev change crowdsale rate
619      * @param newRate Figure that corresponds to the new rate per token
620      */
621     function setRate(uint256 newRate) external onlyOwner {
622         require(newRate != 0);
623 
624         TokenRateChanged(rate, newRate);
625         rate = newRate;
626     }
627 
628     /**
629      * @dev Set the address which should receive the vested team tokens share on finalization
630      * @param _teamAndAdvisorsAllocation address of team and advisor allocation contract
631      */
632     function setTeamWalletAddress(address _teamAndAdvisorsAllocation) public onlyOwner {
633         // only able to set teamAndAdvisorsAllocation once.
634         // TeamAndAdvisorsAllocation contract requires token contract already deployed.
635         // token contract is created within crowdsale,
636         // thus the TeamAndAdvisorsAllocation must be set up after crowdsale's deployment
637         require(teamAndAdvisorsAllocation == address(0x0) && _teamAndAdvisorsAllocation != address(0x0));
638 
639         teamAndAdvisorsAllocation = _teamAndAdvisorsAllocation;
640     }
641 
642     /**
643      * @dev payable function that allow token purchases
644      * @param beneficiary Address of the purchaser
645      */
646     function buyTokens(address beneficiary)
647         public
648         whenNotPaused
649         whitelisted(beneficiary)
650         payable
651     {
652         // minimum of 1 ether for purchase in the public presale and sale
653         require(beneficiary != address(0) && msg.value >= 1 ether);
654         require(validPurchase() && token.totalSupply() < TOTAL_TOKENS_FOR_CROWDSALE);
655 
656         uint256 weiAmount = msg.value;
657 
658         // calculate token amount to be created
659         uint256 tokens = weiAmount.mul(rate);
660 
661         if (now >= startTime && now <= presaleEndTime) {
662             uint256 bonus = 50;
663             uint256 bonusTokens = tokens.mul(bonus).div(100);
664 
665             tokens = tokens.add(bonusTokens);
666             require(token.totalSupply().add(tokens) <= PRE_SALE_TOTAL_TOKENS);
667         }
668 
669         //remainder logic
670         if (token.totalSupply().add(tokens) > TOTAL_TOKENS_FOR_CROWDSALE) {
671             tokens = TOTAL_TOKENS_FOR_CROWDSALE.sub(token.totalSupply());
672             weiAmount = tokens.div(rate);
673 
674             // send remainder wei to sender
675             uint256 remainderAmount = msg.value.sub(weiAmount);
676             msg.sender.transfer(remainderAmount);
677         }
678 
679         // update state
680         weiRaised = weiRaised.add(weiAmount);
681 
682         token.mint(beneficiary, tokens);
683 
684         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
685 
686         forwardFunds(weiAmount);
687     }
688 
689     // overriding Crowdsale#hasEnded to add cap logic
690     // @return true if crowdsale event has ended
691     function hasEnded() public view returns (bool) {
692         if (token.totalSupply() == TOTAL_TOKENS_FOR_CROWDSALE) {
693             return true;
694         }
695 
696         return super.hasEnded();
697     }
698 
699     // send ether to the fund collection wallet
700     // override to create custom fund forwarding mechanisms
701     function forwardFunds(uint256 weiAmount) internal {
702         wallet.transfer(weiAmount);
703     }
704 
705     /**
706      * @dev finalizes crowdsale
707      */
708     function finalization() internal {
709         // This must have been set manually prior to finalize().
710         require(teamAndAdvisorsAllocation != address(0));
711 
712         token.mint(wallet, COMPANY_SHARE);
713         token.mint(wallet, BOUNTY_CAMPAIGN_SHARE); // allocate BOUNTY_CAMPAIGN_SHARE to company wallet as well
714         token.mint(teamAndAdvisorsAllocation, TEAM_ADVISORS_SHARE);
715 
716         if (TOTAL_TOKENS_SUPPLY > token.totalSupply()) {
717             uint256 remainingTokens = TOTAL_TOKENS_SUPPLY.sub(token.totalSupply());
718             // burn remaining tokens
719             token.mint(address(0), remainingTokens);
720         }
721 
722         token.finishMinting();
723         ICNQToken(token).unpause();
724         super.finalization();
725     }
726 
727     /**
728      * @dev Creates ICNQ token contract. This is called on the constructor function of the Crowdsale contract
729      */
730     function createTokenContract() internal returns (MintableToken) {
731         return new ICNQToken();
732     }
733 }