1 pragma solidity 0.4.24;
2 
3 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33  /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
107 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
121 
122 /**
123  * @title Crowdsale
124  * @dev Crowdsale is a base contract for managing a token crowdsale,
125  * allowing investors to purchase tokens with ether. This contract implements
126  * such functionality in its most fundamental form and can be extended to provide additional
127  * functionality and/or custom behavior.
128  * The external interface represents the basic interface for purchasing tokens, and conform
129  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
130  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
131  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
132  * behavior.
133  */
134 contract Crowdsale {
135   using SafeMath for uint256;
136 
137   // The token being sold
138   ERC20 public token;
139 
140   // Address where funds are collected
141   address public wallet;
142 
143   // How many token units a buyer gets per wei
144   uint256 public rate;
145 
146   // Amount of wei raised
147   uint256 public weiRaised;
148 
149   /**
150    * Event for token purchase logging
151    * @param purchaser who paid for the tokens
152    * @param beneficiary who got the tokens
153    * @param value weis paid for purchase
154    * @param amount amount of tokens purchased
155    */
156   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
157 
158   /**
159    * @param _rate Number of token units a buyer gets per wei
160    * @param _wallet Address where collected funds will be forwarded to
161    * @param _token Address of the token being sold
162    */
163   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
164     require(_rate > 0);
165     require(_wallet != address(0));
166     require(_token != address(0));
167 
168     rate = _rate;
169     wallet = _wallet;
170     token = _token;
171   }
172 
173   // -----------------------------------------
174   // Crowdsale external interface
175   // -----------------------------------------
176 
177   /**
178    * @dev fallback function ***DO NOT OVERRIDE***
179    */
180   function () external payable {
181     buyTokens(msg.sender);
182   }
183 
184   /**
185    * @dev low level token purchase ***DO NOT OVERRIDE***
186    * @param _beneficiary Address performing the token purchase
187    */
188   function buyTokens(address _beneficiary) public payable {
189 
190     uint256 weiAmount = msg.value;
191     _preValidatePurchase(_beneficiary, weiAmount);
192 
193     // calculate token amount to be created
194     uint256 tokens = _getTokenAmount(weiAmount);
195 
196     // update state
197     weiRaised = weiRaised.add(weiAmount);
198 
199     _processPurchase(_beneficiary, tokens);
200     emit TokenPurchase(
201       msg.sender,
202       _beneficiary,
203       weiAmount,
204       tokens
205     );
206 
207     _updatePurchasingState(_beneficiary, weiAmount);
208 
209     _forwardFunds();
210     _postValidatePurchase(_beneficiary, weiAmount);
211   }
212 
213   // -----------------------------------------
214   // Internal interface (extensible)
215   // -----------------------------------------
216 
217   /**
218    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
219    * @param _beneficiary Address performing the token purchase
220    * @param _weiAmount Value in wei involved in the purchase
221    */
222   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
223     require(_beneficiary != address(0));
224     require(_weiAmount != 0);
225   }
226 
227   /**
228    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
229    * @param _beneficiary Address performing the token purchase
230    * @param _weiAmount Value in wei involved in the purchase
231    */
232   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
233     // optional override
234   }
235 
236   /**
237    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
238    * @param _beneficiary Address performing the token purchase
239    * @param _tokenAmount Number of tokens to be emitted
240    */
241   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
242     token.transfer(_beneficiary, _tokenAmount);
243   }
244 
245   /**
246    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
247    * @param _beneficiary Address receiving the tokens
248    * @param _tokenAmount Number of tokens to be purchased
249    */
250   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
251     _deliverTokens(_beneficiary, _tokenAmount);
252   }
253 
254   /**
255    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
256    * @param _beneficiary Address receiving the tokens
257    * @param _weiAmount Value in wei involved in the purchase
258    */
259   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
260     // optional override
261   }
262 
263   /**
264    * @dev Override to extend the way in which ether is converted to tokens.
265    * @param _weiAmount Value in wei to be converted into tokens
266    * @return Number of tokens that can be purchased with the specified _weiAmount
267    */
268   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
269     return _weiAmount.mul(rate);
270   }
271 
272   /**
273    * @dev Determines how ETH is stored/forwarded on purchases.
274    */
275   function _forwardFunds() internal {
276     wallet.transfer(msg.value);
277   }
278 }
279 
280 // File: node_modules/zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
281 
282 /**
283  * @title TimedCrowdsale
284  * @dev Crowdsale accepting contributions only within a time frame.
285  */
286 contract TimedCrowdsale is Crowdsale {
287   using SafeMath for uint256;
288 
289   uint256 public openingTime;
290   uint256 public closingTime;
291 
292   /**
293    * @dev Reverts if not in crowdsale time range.
294    */
295   modifier onlyWhileOpen {
296     // solium-disable-next-line security/no-block-members
297     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
298     _;
299   }
300 
301   /**
302    * @dev Constructor, takes crowdsale opening and closing times.
303    * @param _openingTime Crowdsale opening time
304    * @param _closingTime Crowdsale closing time
305    */
306   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
307     // solium-disable-next-line security/no-block-members
308     require(_openingTime >= block.timestamp);
309     require(_closingTime >= _openingTime);
310 
311     openingTime = _openingTime;
312     closingTime = _closingTime;
313   }
314 
315   /**
316    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
317    * @return Whether crowdsale period has elapsed
318    */
319   function hasClosed() public view returns (bool) {
320     // solium-disable-next-line security/no-block-members
321     return block.timestamp > closingTime;
322   }
323 
324   /**
325    * @dev Extend parent behavior requiring to be within contributing period
326    * @param _beneficiary Token purchaser
327    * @param _weiAmount Amount of wei contributed
328    */
329   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
330     super._preValidatePurchase(_beneficiary, _weiAmount);
331   }
332 
333 }
334 
335 // File: node_modules/zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
336 
337 /**
338  * @title FinalizableCrowdsale
339  * @dev Extension of Crowdsale where an owner can do extra work
340  * after finishing.
341  */
342 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
343   using SafeMath for uint256;
344 
345   bool public isFinalized = false;
346 
347   event Finalized();
348 
349   /**
350    * @dev Must be called after crowdsale ends, to do some extra finalization
351    * work. Calls the contract's finalization function.
352    */
353   function finalize() onlyOwner public {
354     require(!isFinalized);
355     require(hasClosed());
356 
357     finalization();
358     emit Finalized();
359 
360     isFinalized = true;
361   }
362 
363   /**
364    * @dev Can be overridden to add finalization logic. The overriding function
365    * should call super.finalization() to ensure the chain of finalization is
366    * executed entirely.
367    */
368   function finalization() internal {
369   }
370 
371 }
372 
373 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
374 
375 /**
376  * @title Basic token
377  * @dev Basic version of StandardToken, with no allowances.
378  */
379 contract BasicToken is ERC20Basic {
380   using SafeMath for uint256;
381 
382   mapping(address => uint256) balances;
383 
384   uint256 totalSupply_;
385 
386   /**
387   * @dev total number of tokens in existence
388   */
389   function totalSupply() public view returns (uint256) {
390     return totalSupply_;
391   }
392 
393   /**
394   * @dev transfer token for a specified address
395   * @param _to The address to transfer to.
396   * @param _value The amount to be transferred.
397   */
398   function transfer(address _to, uint256 _value) public returns (bool) {
399     require(_to != address(0));
400     require(_value <= balances[msg.sender]);
401 
402     balances[msg.sender] = balances[msg.sender].sub(_value);
403     balances[_to] = balances[_to].add(_value);
404     emit Transfer(msg.sender, _to, _value);
405     return true;
406   }
407 
408   /**
409   * @dev Gets the balance of the specified address.
410   * @param _owner The address to query the the balance of.
411   * @return An uint256 representing the amount owned by the passed address.
412   */
413   function balanceOf(address _owner) public view returns (uint256) {
414     return balances[_owner];
415   }
416 
417 }
418 
419 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
420 
421 /**
422  * @title Standard ERC20 token
423  *
424  * @dev Implementation of the basic standard token.
425  * @dev https://github.com/ethereum/EIPs/issues/20
426  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
427  */
428 contract StandardToken is ERC20, BasicToken {
429 
430   mapping (address => mapping (address => uint256)) internal allowed;
431 
432 
433   /**
434    * @dev Transfer tokens from one address to another
435    * @param _from address The address which you want to send tokens from
436    * @param _to address The address which you want to transfer to
437    * @param _value uint256 the amount of tokens to be transferred
438    */
439   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
440     require(_to != address(0));
441     require(_value <= balances[_from]);
442     require(_value <= allowed[_from][msg.sender]);
443 
444     balances[_from] = balances[_from].sub(_value);
445     balances[_to] = balances[_to].add(_value);
446     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
447     emit Transfer(_from, _to, _value);
448     return true;
449   }
450 
451   /**
452    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
453    *
454    * Beware that changing an allowance with this method brings the risk that someone may use both the old
455    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
456    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
457    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
458    * @param _spender The address which will spend the funds.
459    * @param _value The amount of tokens to be spent.
460    */
461   function approve(address _spender, uint256 _value) public returns (bool) {
462     allowed[msg.sender][_spender] = _value;
463     emit Approval(msg.sender, _spender, _value);
464     return true;
465   }
466 
467   /**
468    * @dev Function to check the amount of tokens that an owner allowed to a spender.
469    * @param _owner address The address which owns the funds.
470    * @param _spender address The address which will spend the funds.
471    * @return A uint256 specifying the amount of tokens still available for the spender.
472    */
473   function allowance(address _owner, address _spender) public view returns (uint256) {
474     return allowed[_owner][_spender];
475   }
476 
477   /**
478    * @dev Increase the amount of tokens that an owner allowed to a spender.
479    *
480    * approve should be called when allowed[_spender] == 0. To increment
481    * allowed value is better to use this function to avoid 2 calls (and wait until
482    * the first transaction is mined)
483    * From MonolithDAO Token.sol
484    * @param _spender The address which will spend the funds.
485    * @param _addedValue The amount of tokens to increase the allowance by.
486    */
487   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
488     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
489     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
490     return true;
491   }
492 
493   /**
494    * @dev Decrease the amount of tokens that an owner allowed to a spender.
495    *
496    * approve should be called when allowed[_spender] == 0. To decrement
497    * allowed value is better to use this function to avoid 2 calls (and wait until
498    * the first transaction is mined)
499    * From MonolithDAO Token.sol
500    * @param _spender The address which will spend the funds.
501    * @param _subtractedValue The amount of tokens to decrease the allowance by.
502    */
503   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
504     uint oldValue = allowed[msg.sender][_spender];
505     if (_subtractedValue > oldValue) {
506       allowed[msg.sender][_spender] = 0;
507     } else {
508       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
509     }
510     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
511     return true;
512   }
513 
514 }
515 
516 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
517 
518 /**
519  * @title Mintable token
520  * @dev Simple ERC20 Token example, with mintable token creation
521  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
522  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
523  */
524 contract MintableToken is StandardToken, Ownable {
525   event Mint(address indexed to, uint256 amount);
526   event MintFinished();
527 
528   bool public mintingFinished = false;
529 
530 
531   modifier canMint() {
532     require(!mintingFinished);
533     _;
534   }
535 
536   /**
537    * @dev Function to mint tokens
538    * @param _to The address that will receive the minted tokens.
539    * @param _amount The amount of tokens to mint.
540    * @return A boolean that indicates if the operation was successful.
541    */
542   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
543     totalSupply_ = totalSupply_.add(_amount);
544     balances[_to] = balances[_to].add(_amount);
545     emit Mint(_to, _amount);
546     emit Transfer(address(0), _to, _amount);
547     return true;
548   }
549 
550   /**
551    * @dev Function to stop minting new tokens.
552    * @return True if the operation was successful.
553    */
554   function finishMinting() onlyOwner canMint public returns (bool) {
555     mintingFinished = true;
556     emit MintFinished();
557     return true;
558   }
559 }
560 
561 // File: node_modules/zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
562 
563 /**
564  * @title MintedCrowdsale
565  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
566  * Token ownership should be transferred to MintedCrowdsale for minting.
567  */
568 contract MintedCrowdsale is Crowdsale {
569 
570   /**
571    * @dev Overrides delivery by minting tokens upon purchase.
572    * @param _beneficiary Token purchaser
573    * @param _tokenAmount Number of tokens to be minted
574    */
575   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
576     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
577   }
578 }
579 
580 // File: contracts/PostKYCCrowdsale.sol
581 
582 /// @title PostKYCCrowdsale
583 /// @author Sicos et al.
584 contract PostKYCCrowdsale is Crowdsale, Ownable {
585 
586     struct Investment {
587         bool isVerified;         // wether or not the investor passed the KYC process
588         uint totalWeiInvested;   // total invested wei regardless of verification state
589         // amount of token an unverified investor bought. should be zero for verified investors
590         uint pendingTokenAmount;
591     }
592 
593     // total amount of wei held by unverified investors should never be larger than this.balance
594     uint public pendingWeiAmount = 0;
595 
596     // maps investor addresses to investment information
597     mapping(address => Investment) public investments;
598 
599     /// @dev Log entry on investor verified
600     /// @param investor the investor's Ethereum address
601     event InvestorVerified(address investor);
602 
603     /// @dev Log entry on tokens delivered
604     /// @param investor the investor's Ethereum address
605     /// @param amount token amount delivered
606     event TokensDelivered(address investor, uint amount);
607 
608     /// @dev Log entry on investment withdrawn
609     /// @param investor the investor's Ethereum address
610     /// @param value the wei amount withdrawn
611     event InvestmentWithdrawn(address investor, uint value);
612 
613     /// @dev Verify investors
614     /// @param _investors list of investors' Ethereum addresses
615     function verifyInvestors(address[] _investors) public onlyOwner {
616         for (uint i = 0; i < _investors.length; ++i) {
617             address investor = _investors[i];
618             Investment storage investment = investments[investor];
619 
620             if (!investment.isVerified) {
621                 investment.isVerified = true;
622 
623                 emit InvestorVerified(investor);
624 
625                 uint pendingTokenAmount = investment.pendingTokenAmount;
626                 // now we issue tokens to the verfied investor
627                 if (pendingTokenAmount > 0) {
628                     investment.pendingTokenAmount = 0;
629 
630                     _forwardFunds(investment.totalWeiInvested);
631                     _deliverTokens(investor, pendingTokenAmount);
632 
633                     emit TokensDelivered(investor, pendingTokenAmount);
634                 }
635             }
636         }
637     }
638 
639     /// @dev Withdraw investment
640     /// @dev Investors that are not verified can withdraw their funds
641     function withdrawInvestment() public {
642         Investment storage investment = investments[msg.sender];
643 
644         require(!investment.isVerified);
645 
646         uint totalWeiInvested = investment.totalWeiInvested;
647 
648         require(totalWeiInvested > 0);
649 
650         investment.totalWeiInvested = 0;
651         investment.pendingTokenAmount = 0;
652 
653         pendingWeiAmount = pendingWeiAmount.sub(totalWeiInvested);
654 
655         msg.sender.transfer(totalWeiInvested);
656 
657         emit InvestmentWithdrawn(msg.sender, totalWeiInvested);
658 
659         assert(pendingWeiAmount <= address(this).balance);
660     }
661 
662     /// @dev Prevalidate purchase
663     /// @param _beneficiary the investor's Ethereum address
664     /// @param _weiAmount the wei amount invested
665     function _preValidatePurchase(address _beneficiary, uint _weiAmount) internal {
666         // We only want the msg.sender to buy tokens
667         require(_beneficiary == msg.sender);
668 
669         super._preValidatePurchase(_beneficiary, _weiAmount);
670     }
671 
672     /// @dev Process purchase
673     /// @param _tokenAmount the token amount purchased
674     function _processPurchase(address, uint _tokenAmount) internal {
675         Investment storage investment = investments[msg.sender];
676         investment.totalWeiInvested = investment.totalWeiInvested.add(msg.value);
677 
678         if (investment.isVerified) {
679             // If the investor's KYC is already verified we issue the tokens imediatly
680             _deliverTokens(msg.sender, _tokenAmount);
681             emit TokensDelivered(msg.sender, _tokenAmount);
682         } else {
683             // If the investor's KYC is not verified we store the pending token amount
684             investment.pendingTokenAmount = investment.pendingTokenAmount.add(_tokenAmount);
685             pendingWeiAmount = pendingWeiAmount.add(msg.value);
686         }
687     }
688 
689     /// @dev Forward funds
690     function _forwardFunds() internal {
691         // Ensure the investor was verified, i.e. his purchased tokens were delivered,
692         // before forwarding funds.
693         if (investments[msg.sender].isVerified) {
694             super._forwardFunds();
695         }
696     }
697 
698     /// @dev Forward funds
699     /// @param _weiAmount the amount to be transfered
700     function _forwardFunds(uint _weiAmount) internal {
701         pendingWeiAmount = pendingWeiAmount.sub(_weiAmount);
702         wallet.transfer(_weiAmount);
703     }
704 
705     /// @dev Postvalidate purchase
706     /// @param _weiAmount the amount invested
707     function _postValidatePurchase(address, uint _weiAmount) internal {
708         super._postValidatePurchase(msg.sender, _weiAmount);
709         // checking invariant
710         assert(pendingWeiAmount <= address(this).balance);
711     }
712 
713 }
714 
715 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
716 
717 /**
718  * @title Burnable Token
719  * @dev Token that can be irreversibly burned (destroyed).
720  */
721 contract BurnableToken is BasicToken {
722 
723   event Burn(address indexed burner, uint256 value);
724 
725   /**
726    * @dev Burns a specific amount of tokens.
727    * @param _value The amount of token to be burned.
728    */
729   function burn(uint256 _value) public {
730     _burn(msg.sender, _value);
731   }
732 
733   function _burn(address _who, uint256 _value) internal {
734     require(_value <= balances[_who]);
735     // no need to require value <= totalSupply, since that would imply the
736     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
737 
738     balances[_who] = balances[_who].sub(_value);
739     totalSupply_ = totalSupply_.sub(_value);
740     emit Burn(_who, _value);
741     emit Transfer(_who, address(0), _value);
742   }
743 }
744 
745 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
746 
747 /**
748  * @title Capped token
749  * @dev Mintable token with a token cap.
750  */
751 contract CappedToken is MintableToken {
752 
753   uint256 public cap;
754 
755   function CappedToken(uint256 _cap) public {
756     require(_cap > 0);
757     cap = _cap;
758   }
759 
760   /**
761    * @dev Function to mint tokens
762    * @param _to The address that will receive the minted tokens.
763    * @param _amount The amount of tokens to mint.
764    * @return A boolean that indicates if the operation was successful.
765    */
766   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
767     require(totalSupply_.add(_amount) <= cap);
768 
769     return super.mint(_to, _amount);
770   }
771 
772 }
773 
774 // File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
775 
776 /**
777  * @title Pausable
778  * @dev Base contract which allows children to implement an emergency stop mechanism.
779  */
780 contract Pausable is Ownable {
781   event Pause();
782   event Unpause();
783 
784   bool public paused = false;
785 
786 
787   /**
788    * @dev Modifier to make a function callable only when the contract is not paused.
789    */
790   modifier whenNotPaused() {
791     require(!paused);
792     _;
793   }
794 
795   /**
796    * @dev Modifier to make a function callable only when the contract is paused.
797    */
798   modifier whenPaused() {
799     require(paused);
800     _;
801   }
802 
803   /**
804    * @dev called by the owner to pause, triggers stopped state
805    */
806   function pause() onlyOwner whenNotPaused public {
807     paused = true;
808     emit Pause();
809   }
810 
811   /**
812    * @dev called by the owner to unpause, returns to normal state
813    */
814   function unpause() onlyOwner whenPaused public {
815     paused = false;
816     emit Unpause();
817   }
818 }
819 
820 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
821 
822 /**
823  * @title Pausable token
824  * @dev StandardToken modified with pausable transfers.
825  **/
826 contract PausableToken is StandardToken, Pausable {
827 
828   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
829     return super.transfer(_to, _value);
830   }
831 
832   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
833     return super.transferFrom(_from, _to, _value);
834   }
835 
836   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
837     return super.approve(_spender, _value);
838   }
839 
840   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
841     return super.increaseApproval(_spender, _addedValue);
842   }
843 
844   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
845     return super.decreaseApproval(_spender, _subtractedValue);
846   }
847 }
848 
849 // File: contracts/VreoToken.sol
850 
851 /// @title VreoToken
852 /// @author Sicos et al.
853 contract VreoToken is CappedToken, PausableToken, BurnableToken {
854 
855     uint public constant TOTAL_TOKEN_CAP = 700000000e18;  // = 700.000.000 e18
856 
857     string public name = "VREO Token";
858     string public symbol = "VREO";
859     uint8 public decimals = 18;
860 
861     /// @dev Constructor
862     constructor() public CappedToken(TOTAL_TOKEN_CAP) {
863         pause();
864     }
865 
866 }
867 
868 // File: contracts/VreoTokenSale.sol
869 
870 /// @title VreoTokenSale
871 /// @author Sicos et al.
872 contract VreoTokenSale is PostKYCCrowdsale, FinalizableCrowdsale, MintedCrowdsale {
873 
874     // Maxmimum number of tokens sold in Presale+Iconiq+Vreo sales
875     uint public constant TOTAL_TOKEN_CAP_OF_SALE = 450000000e18;  // = 450.000.000 e18
876 
877     // Extra tokens minted upon finalization
878     uint public constant TOKEN_SHARE_OF_TEAM     =  85000000e18;  // =  85.000.000 e18
879     uint public constant TOKEN_SHARE_OF_ADVISORS =  58000000e18;  // =  58.000.000 e18
880     uint public constant TOKEN_SHARE_OF_LEGALS   =  57000000e18;  // =  57.000.000 e18
881     uint public constant TOKEN_SHARE_OF_BOUNTY   =  50000000e18;  // =  50.000.000 e18
882 
883     // Extra token percentages
884     uint public constant BONUS_PCT_IN_ICONIQ_SALE       = 30;  // TBD
885     uint public constant BONUS_PCT_IN_VREO_SALE_PHASE_1 = 20;
886     uint public constant BONUS_PCT_IN_VREO_SALE_PHASE_2 = 10;
887 
888     // Date/time constants
889     uint public constant ICONIQ_SALE_OPENING_TIME   = 1553673600;  // 2019-03-27 09:00:00 CEST
890     uint public constant ICONIQ_SALE_CLOSING_TIME   = 1553674600;  
891     uint public constant VREO_SALE_OPENING_TIME     = 1553675600;  
892     uint public constant VREO_SALE_PHASE_1_END_TIME = 1553676600;  
893     uint public constant VREO_SALE_PHASE_2_END_TIME = 1553760000;  // 2019-03-28 09:00:00 CEST
894     uint public constant VREO_SALE_CLOSING_TIME     = 1554026400;  // 2019-03-31 12:00:00 CEST
895     uint public constant KYC_VERIFICATION_END_TIME  = 1554033600;  // 2019-03-31 13:26:00 CEST
896 
897     // Amount of ICONIQ token investors need per Wei invested in ICONIQ PreSale.
898     uint public constant ICONIQ_TOKENS_NEEDED_PER_INVESTED_WEI = 450;
899 
900     // ICONIQ Token
901     ERC20Basic public iconiqToken;
902 
903     // addresses token shares are minted to in finalization
904     address public teamAddress;
905     address public advisorsAddress;
906     address public legalsAddress;
907     address public bountyAddress;
908 
909     // Amount of token available for purchase
910     uint public remainingTokensForSale;
911 
912     /// @dev Log entry on rate changed
913     /// @param newRate the new rate
914     event RateChanged(uint newRate);
915 
916     /// @dev Constructor
917     /// @param _token A VreoToken
918     /// @param _rate the initial rate.
919     /// @param _iconiqToken An IconiqInterface
920     /// @param _teamAddress Ethereum address of Team
921     /// @param _advisorsAddress Ethereum address of Advisors
922     /// @param _legalsAddress Ethereum address of Legals
923     /// @param _bountyAddress A VreoTokenBounty
924     /// @param _wallet MultiSig wallet address the ETH is forwarded to.
925     constructor(
926         VreoToken _token,
927         uint _rate,
928         ERC20Basic _iconiqToken,
929         address _teamAddress,
930         address _advisorsAddress,
931         address _legalsAddress,
932         address _bountyAddress,
933         address _wallet
934     )
935         public
936         Crowdsale(_rate, _wallet, _token)
937         TimedCrowdsale(ICONIQ_SALE_OPENING_TIME, VREO_SALE_CLOSING_TIME)
938     {
939         // Token sanity check
940         require(_token.cap() >= TOTAL_TOKEN_CAP_OF_SALE
941                                 + TOKEN_SHARE_OF_TEAM
942                                 + TOKEN_SHARE_OF_ADVISORS
943                                 + TOKEN_SHARE_OF_LEGALS
944                                 + TOKEN_SHARE_OF_BOUNTY);
945 
946         // Sanity check of addresses
947         require(address(_iconiqToken) != address(0)
948                 && _teamAddress != address(0)
949                 && _advisorsAddress != address(0)
950                 && _legalsAddress != address(0)
951                 && _bountyAddress != address(0));
952 
953         iconiqToken = _iconiqToken;
954         teamAddress = _teamAddress;
955         advisorsAddress = _advisorsAddress;
956         legalsAddress = _legalsAddress;
957         bountyAddress = _bountyAddress;
958 
959         remainingTokensForSale = TOTAL_TOKEN_CAP_OF_SALE;
960     }
961 
962     /// @dev Distribute presale
963     /// @param _investors  list of investor addresses
964     /// @param _amounts  list of token amounts purchased by investors
965     function distributePresale(address[] _investors, uint[] _amounts) public onlyOwner {
966         require(!hasClosed());
967         require(_investors.length == _amounts.length);
968 
969         uint totalAmount = 0;
970 
971         for (uint i = 0; i < _investors.length; ++i) {
972             VreoToken(token).mint(_investors[i], _amounts[i]);
973             totalAmount = totalAmount.add(_amounts[i]);
974         }
975 
976         require(remainingTokensForSale >= totalAmount);
977         remainingTokensForSale = remainingTokensForSale.sub(totalAmount);
978     }
979 
980     /// @dev Set rate
981     /// @param _newRate the new rate
982     function setRate(uint _newRate) public onlyOwner {
983         // A rate change by a magnitude order of ten and above is rather a typo than intention.
984         // If it was indeed desired, several setRate transactions have to be sent.
985         require(rate / 10 < _newRate && _newRate < 10 * rate);
986 
987         rate = _newRate;
988 
989         emit RateChanged(_newRate);
990     }
991 
992     /// @dev unverified investors can withdraw their money only after the VREO Sale ended
993     function withdrawInvestment() public {
994         require(hasClosed());
995 
996         super.withdrawInvestment();
997     }
998 
999     /// @dev Is the sale for ICONIQ investors ongoing?
1000     /// @return bool
1001     function iconiqSaleOngoing() public view returns (bool) {
1002         return ICONIQ_SALE_OPENING_TIME <= now && now <= ICONIQ_SALE_CLOSING_TIME;
1003     }
1004 
1005     /// @dev Is the Vreo main sale ongoing?
1006     /// @return bool
1007     function vreoSaleOngoing() public view returns (bool) {
1008         return VREO_SALE_OPENING_TIME <= now && now <= VREO_SALE_CLOSING_TIME;
1009     }
1010 
1011     /// @dev Get maximum possible wei investment while Iconiq sale
1012     /// @param _investor an investors Ethereum address
1013     /// @return Maximum allowed wei investment
1014     function getIconiqMaxInvestment(address _investor) public view returns (uint) {
1015         uint iconiqBalance = iconiqToken.balanceOf(_investor);
1016         uint prorataLimit = iconiqBalance.div(ICONIQ_TOKENS_NEEDED_PER_INVESTED_WEI);
1017 
1018         // Substract Wei amount already invested.
1019         require(prorataLimit >= investments[_investor].totalWeiInvested);
1020         return prorataLimit.sub(investments[_investor].totalWeiInvested);
1021     }
1022 
1023     /// @dev Pre validate purchase
1024     /// @param _beneficiary an investors Ethereum address
1025     /// @param _weiAmount wei amount invested
1026     function _preValidatePurchase(address _beneficiary, uint _weiAmount) internal {
1027         super._preValidatePurchase(_beneficiary, _weiAmount);
1028 
1029         require(iconiqSaleOngoing() && getIconiqMaxInvestment(msg.sender) >= _weiAmount || vreoSaleOngoing());
1030     }
1031 
1032     /// @dev Get token amount
1033     /// @param _weiAmount wei amount invested
1034     /// @return token amount with bonus
1035     function _getTokenAmount(uint _weiAmount) internal view returns (uint) {
1036         uint tokenAmount = super._getTokenAmount(_weiAmount);
1037 
1038         if (now <= ICONIQ_SALE_CLOSING_TIME) {
1039             return tokenAmount.mul(100 + BONUS_PCT_IN_ICONIQ_SALE).div(100);
1040         }
1041 
1042         if (now <= VREO_SALE_PHASE_1_END_TIME) {
1043             return tokenAmount.mul(100 + BONUS_PCT_IN_VREO_SALE_PHASE_1).div(100);
1044         }
1045 
1046         if (now <= VREO_SALE_PHASE_2_END_TIME) {
1047             return tokenAmount.mul(100 + BONUS_PCT_IN_VREO_SALE_PHASE_2).div(100);
1048         }
1049 
1050         return tokenAmount;  // No bonus
1051     }
1052 
1053     /// @dev Deliver tokens
1054     /// @param _beneficiary an investors Ethereum address
1055     /// @param _tokenAmount token amount to deliver
1056     function _deliverTokens(address _beneficiary, uint _tokenAmount) internal {
1057         require(remainingTokensForSale >= _tokenAmount);
1058         remainingTokensForSale = remainingTokensForSale.sub(_tokenAmount);
1059 
1060         super._deliverTokens(_beneficiary, _tokenAmount);
1061     }
1062 
1063     /// @dev Finalization
1064     function finalization() internal {
1065         require(now >= KYC_VERIFICATION_END_TIME);
1066 
1067         VreoToken(token).mint(teamAddress, TOKEN_SHARE_OF_TEAM);
1068         VreoToken(token).mint(advisorsAddress, TOKEN_SHARE_OF_ADVISORS);
1069         VreoToken(token).mint(legalsAddress, TOKEN_SHARE_OF_LEGALS);
1070         VreoToken(token).mint(bountyAddress, TOKEN_SHARE_OF_BOUNTY);
1071 
1072         VreoToken(token).finishMinting();
1073         VreoToken(token).unpause();
1074 
1075         super.finalization();
1076     }
1077 
1078 }