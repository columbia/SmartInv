1 pragma solidity ^0.4.18;
2 
3 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol
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
96 // File: node_modules/zeppelin-solidity/contracts/token/BasicToken.sol
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
134 // File: node_modules/zeppelin-solidity/contracts/token/ERC20.sol
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
147 // File: node_modules/zeppelin-solidity/contracts/token/StandardToken.sol
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
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: node_modules/zeppelin-solidity/contracts/token/MintableToken.sol
245 
246 /**
247  * @title Mintable token
248  * @dev Simple ERC20 Token example, with mintable token creation
249  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
250  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
251  */
252 
253 contract MintableToken is StandardToken, Ownable {
254   event Mint(address indexed to, uint256 amount);
255   event MintFinished();
256 
257   bool public mintingFinished = false;
258 
259 
260   modifier canMint() {
261     require(!mintingFinished);
262     _;
263   }
264 
265   /**
266    * @dev Function to mint tokens
267    * @param _to The address that will receive the minted tokens.
268    * @param _amount The amount of tokens to mint.
269    * @return A boolean that indicates if the operation was successful.
270    */
271   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
272     totalSupply = totalSupply.add(_amount);
273     balances[_to] = balances[_to].add(_amount);
274     Mint(_to, _amount);
275     Transfer(address(0), _to, _amount);
276     return true;
277   }
278 
279   /**
280    * @dev Function to stop minting new tokens.
281    * @return True if the operation was successful.
282    */
283   function finishMinting() onlyOwner canMint public returns (bool) {
284     mintingFinished = true;
285     MintFinished();
286     return true;
287   }
288 }
289 
290 // File: node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
291 
292 /**
293  * @title Crowdsale
294  * @dev Crowdsale is a base contract for managing a token crowdsale.
295  * Crowdsales have a start and end timestamps, where investors can make
296  * token purchases and the crowdsale will assign them tokens based
297  * on a token per ETH rate. Funds collected are forwarded to a wallet
298  * as they arrive.
299  */
300 contract Crowdsale {
301   using SafeMath for uint256;
302 
303   // The token being sold
304   MintableToken public token;
305 
306   // start and end timestamps where investments are allowed (both inclusive)
307   uint256 public startTime;
308   uint256 public endTime;
309 
310   // address where funds are collected
311   address public wallet;
312 
313   // how many token units a buyer gets per wei
314   uint256 public rate;
315 
316   // amount of raised money in wei
317   uint256 public weiRaised;
318 
319   /**
320    * event for token purchase logging
321    * @param purchaser who paid for the tokens
322    * @param beneficiary who got the tokens
323    * @param value weis paid for purchase
324    * @param amount amount of tokens purchased
325    */
326   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
327 
328 
329   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
330     require(_startTime >= now);
331     require(_endTime >= _startTime);
332     require(_rate > 0);
333     require(_wallet != address(0));
334 
335     token = createTokenContract();
336     startTime = _startTime;
337     endTime = _endTime;
338     rate = _rate;
339     wallet = _wallet;
340   }
341 
342   // creates the token to be sold.
343   // override this method to have crowdsale of a specific mintable token.
344   function createTokenContract() internal returns (MintableToken) {
345     return new MintableToken();
346   }
347 
348 
349   // fallback function can be used to buy tokens
350   function () external payable {
351     buyTokens(msg.sender);
352   }
353 
354   // low level token purchase function
355   function buyTokens(address beneficiary) public payable {
356     require(beneficiary != address(0));
357     require(validPurchase());
358 
359     uint256 weiAmount = msg.value;
360 
361     // calculate token amount to be created
362     uint256 tokens = weiAmount.mul(rate);
363 
364     // update state
365     weiRaised = weiRaised.add(weiAmount);
366 
367     token.mint(beneficiary, tokens);
368     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
369 
370     forwardFunds();
371   }
372 
373   // send ether to the fund collection wallet
374   // override to create custom fund forwarding mechanisms
375   function forwardFunds() internal {
376     wallet.transfer(msg.value);
377   }
378 
379   // @return true if the transaction can buy tokens
380   function validPurchase() internal view returns (bool) {
381     bool withinPeriod = now >= startTime && now <= endTime;
382     bool nonZeroPurchase = msg.value != 0;
383     return withinPeriod && nonZeroPurchase;
384   }
385 
386   // @return true if crowdsale event has ended
387   function hasEnded() public view returns (bool) {
388     return now > endTime;
389   }
390 
391 
392 }
393 
394 // File: node_modules/zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
395 
396 /**
397  * @title FinalizableCrowdsale
398  * @dev Extension of Crowdsale where an owner can do extra work
399  * after finishing.
400  */
401 contract FinalizableCrowdsale is Crowdsale, Ownable {
402   using SafeMath for uint256;
403 
404   bool public isFinalized = false;
405 
406   event Finalized();
407 
408   /**
409    * @dev Must be called after crowdsale ends, to do some extra finalization
410    * work. Calls the contract's finalization function.
411    */
412   function finalize() onlyOwner public {
413     require(!isFinalized);
414     require(hasEnded());
415 
416     finalization();
417     Finalized();
418 
419     isFinalized = true;
420   }
421 
422   /**
423    * @dev Can be overridden to add finalization logic. The overriding function
424    * should call super.finalization() to ensure the chain of finalization is
425    * executed entirely.
426    */
427   function finalization() internal {
428   }
429 }
430 
431 // File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
432 
433 /**
434  * @title Pausable
435  * @dev Base contract which allows children to implement an emergency stop mechanism.
436  */
437 contract Pausable is Ownable {
438   event Pause();
439   event Unpause();
440 
441   bool public paused = false;
442 
443 
444   /**
445    * @dev Modifier to make a function callable only when the contract is not paused.
446    */
447   modifier whenNotPaused() {
448     require(!paused);
449     _;
450   }
451 
452   /**
453    * @dev Modifier to make a function callable only when the contract is paused.
454    */
455   modifier whenPaused() {
456     require(paused);
457     _;
458   }
459 
460   /**
461    * @dev called by the owner to pause, triggers stopped state
462    */
463   function pause() onlyOwner whenNotPaused public {
464     paused = true;
465     Pause();
466   }
467 
468   /**
469    * @dev called by the owner to unpause, returns to normal state
470    */
471   function unpause() onlyOwner whenPaused public {
472     paused = false;
473     Unpause();
474   }
475 }
476 
477 // File: contracts/KeyrptoToken.sol
478 
479 contract KeyrptoToken is MintableToken, Pausable {
480   string public constant name = "Keyrpto Token";
481   string public constant symbol = "KYT";
482   uint8 public constant decimals = 18;
483   uint256 internal constant MILLION_TOKENS = 1e6 * 1e18;
484 
485   address public teamWallet;
486   bool public teamTokensMinted = false;
487   uint256 public circulationStartTime;
488 
489   event Burn(address indexed burnedFrom, uint256 value);
490 
491   function KeyrptoToken() public {
492     paused = true;
493   }
494 
495   function setTeamWallet(address _teamWallet) public onlyOwner canMint {
496     require(teamWallet == address(0));
497     require(_teamWallet != address(0));
498 
499     teamWallet = _teamWallet;
500   }
501 
502   function mintTeamTokens(uint256 _extraTokensMintedDuringPresale) public onlyOwner canMint {
503     require(!teamTokensMinted);
504 
505     teamTokensMinted = true;
506     mint(teamWallet, (490 * MILLION_TOKENS).sub(_extraTokensMintedDuringPresale));
507   }
508 
509   /*
510    * @overrides Pausable#unpause
511    * Change: store the time when it was first unpaused
512    */
513   function unpause() onlyOwner whenPaused public {
514     if (circulationStartTime == 0) {
515       circulationStartTime = now;
516     }
517 
518     super.unpause();
519   }
520 
521   /*
522    * @overrides BasicToken#transfer
523    * Changes:
524    * - added whenNotPaused modifier
525    * - added validation that teamWallet balance must not fall below amount of locked tokens
526    */
527   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
528     require(validTransfer(msg.sender, _value));
529     return super.transfer(_to, _value);
530   }
531 
532   /*
533    * @overrides StandardToken#transferFrom
534    * Changes:
535    * - added whenNotPaused modifier
536    * - added validation that teamWallet balance must not fall below amount of locked tokens
537    */
538   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
539     require(validTransfer(_from, _value));
540     return super.transferFrom(_from, _to, _value);
541   }
542 
543   function validTransfer(address _from, uint256 _amount) internal view returns (bool) {
544     if (_from != teamWallet) {
545       return true;
546     }
547 
548     uint256 balanceAfterTransfer = balanceOf(_from).sub(_amount);
549     return balanceAfterTransfer >= minimumTeamWalletBalance();
550   }
551 
552   /*
553    * 100M tokens in teamWallet are locked for 6 months
554    * 200M tokens in teamWallet are locked for 12 months
555    */
556   function minimumTeamWalletBalance() internal view returns (uint256) {
557     if (now < circulationStartTime + 26 weeks) {
558       return 300 * MILLION_TOKENS;
559     } else if (now < circulationStartTime + 1 years) {
560       return 200 * MILLION_TOKENS;
561     } else {
562       return 0;
563     }
564   }
565 
566   /*
567    * Copy of BurnableToken#burn
568    * Changes:
569    * - only allow owner to burn tokens and burn from given address, not msg.sender
570    */
571   function burn(address _from, uint256 _value) external onlyOwner {
572     require(_value <= balances[_from]);
573 
574     balances[_from] = balances[_from].sub(_value);
575     totalSupply = totalSupply.sub(_value);
576     Burn(_from, _value);
577   }
578 }
579 
580 // File: contracts/KeyrptoCrowdsale.sol
581 
582 contract KeyrptoCrowdsale is FinalizableCrowdsale {
583   uint256 internal constant ONE_TOKEN = 1e18;
584   uint256 internal constant MILLION_TOKENS = 1e6 * ONE_TOKEN;
585   uint256 internal constant PRESALE_TOKEN_CAP = 62500000 * ONE_TOKEN;
586   uint256 internal constant MAIN_SALE_TOKEN_CAP = 510 * MILLION_TOKENS;
587   uint256 internal constant MINIMUM_CONTRIBUTION_IN_WEI = 100 finney;
588 
589   mapping (address => bool) public whitelist;
590 
591   uint256 public mainStartTime;
592   uint256 public extraTokensMintedDuringPresale;
593 
594   function KeyrptoCrowdsale(
595                   uint256 _startTime,
596                   uint256 _mainStartTime,
597                   uint256 _endTime,
598                   uint256 _rate,
599                   address _wallet) public
600     Crowdsale(_startTime, _endTime, _rate, _wallet)
601   {
602     require(_startTime < _mainStartTime && _mainStartTime < _endTime);
603 
604     mainStartTime = _mainStartTime;
605 
606     KeyrptoToken(token).setTeamWallet(_wallet);
607   }
608 
609   function createTokenContract() internal returns (MintableToken) {
610     return new KeyrptoToken();
611   }
612 
613   /*
614    * Disable fallback function
615    */
616   function() external payable {
617     revert();
618   }
619 
620   function updateRate(uint256 _rate) external onlyOwner {
621     require(_rate > 0);
622     require(now < endTime);
623 
624     rate = _rate;
625   }
626 
627   function whitelist(address _address) external onlyOwner {
628     whitelist[_address] = true;
629   }
630 
631   function blacklist(address _address) external onlyOwner {
632     delete whitelist[_address];
633   }
634 
635   /*
636    * @overrides Crowdsale#buyTokens
637    * Changes:
638    * - Pass number of tokens to be created and beneficiary for purchase validation
639    * - After presale has ended, record number of extra tokens minted during presale
640    */
641   function buyTokens(address _beneficiary) public payable {
642     require(_beneficiary != address(0));
643 
644     uint256 weiAmount = msg.value;
645     uint256 tokens = weiAmount.mul(getRate());
646 
647     require(validPurchase(tokens, _beneficiary));
648 
649     if(!presale()) {
650       setExtraTokensMintedDuringPresaleIfNotYetSet();
651     }
652 
653     if (extraTokensMintedDuringPresale == 0 && !presale()) {
654       extraTokensMintedDuringPresale = token.totalSupply() / 5;
655     }
656 
657     // update state
658     weiRaised = weiRaised.add(weiAmount);
659 
660     token.mint(_beneficiary, tokens);
661     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
662 
663     forwardFunds();
664   }
665 
666   /*
667    * @overrides Crowdsale#validPurchase
668    * Changes:
669    * - Added restriction to sell only to whitelisted addresses
670    * - Added minimum purchase amount of 0.1 ETH
671    * - Added presale restriction: max contribution of 20 ETH per address
672    * - Added presale restriction: max total supply of 62.5M KYT
673    */
674   function validPurchase(uint256 _tokens, address _beneficiary) internal view returns (bool) {
675     uint256 totalSupplyAfterTransaction = token.totalSupply() + _tokens;
676 
677     if (presale()) {
678       bool withinPerAddressLimit = (token.balanceOf(_beneficiary) + _tokens) <= getRate().mul(20 ether);
679       bool withinTotalSupplyLimit = totalSupplyAfterTransaction <= PRESALE_TOKEN_CAP;
680       if (!withinPerAddressLimit || !withinTotalSupplyLimit) {
681         return false;
682       }
683     }
684 
685     bool aboveMinContribution = msg.value >= MINIMUM_CONTRIBUTION_IN_WEI;
686     bool whitelistedSender = whitelisted(msg.sender);
687     bool withinCap = totalSupplyAfterTransaction <= tokenSupplyCap();
688     return aboveMinContribution && whitelistedSender && withinCap && super.validPurchase();
689   }
690 
691   function whitelisted(address _address) public view returns (bool) {
692     return whitelist[_address];
693   }
694 
695   function getRate() internal view returns (uint256) {
696     return presale() ? rate.mul(5).div(4) : rate;
697   }
698 
699   function presale() internal view returns (bool) {
700     return now < mainStartTime;
701   }
702 
703   /*
704    * @overrides Crowdsale#hasEnded
705    * Changes:
706    * - Added token cap logic based on token supply
707    */
708   function hasEnded() public view returns (bool) {
709     bool capReached = token.totalSupply() >= tokenSupplyCap();
710     return capReached || super.hasEnded();
711   }
712 
713   function tokenSupplyCap() public view returns (uint256) {
714     return MAIN_SALE_TOKEN_CAP + extraTokensMintedDuringPresale;
715   }
716 
717   function finalization() internal {
718     setExtraTokensMintedDuringPresaleIfNotYetSet();
719 
720     KeyrptoToken(token).mintTeamTokens(extraTokensMintedDuringPresale);
721     token.finishMinting();
722     token.transferOwnership(wallet);
723   }
724 
725   function setExtraTokensMintedDuringPresaleIfNotYetSet() internal {
726     if (extraTokensMintedDuringPresale == 0) {
727       extraTokensMintedDuringPresale = token.totalSupply() / 5;
728     }
729   }
730 
731   function hasPresaleEnded() external view returns (bool) {
732     if (!presale()) {
733       return true;
734     }
735 
736     uint256 minPurchaseInTokens = MINIMUM_CONTRIBUTION_IN_WEI.mul(getRate());
737     return token.totalSupply() + minPurchaseInTokens > PRESALE_TOKEN_CAP;
738   }
739 }