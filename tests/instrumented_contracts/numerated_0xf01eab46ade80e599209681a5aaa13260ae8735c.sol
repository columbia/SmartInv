1 pragma solidity ^0.4.19;
2 
3 // File: contracts/utility/ContractReceiverInterface.sol
4 
5 contract ContractReceiverInterface {
6     function receiveApproval(
7         address from,
8         uint256 _amount,
9         address _token,
10         bytes _data) public;
11 }
12 
13 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: contracts/utility/SafeContract.sol
70 
71 contract SafeContract is Ownable {
72 
73     /**
74      * @notice Owner can transfer out any accidentally sent ERC20 tokens
75      */
76     function transferAnyERC20Token(address _tokenAddress, uint256 _tokens, address _beneficiary) public onlyOwner returns (bool success) {
77         return ERC20Basic(_tokenAddress).transfer(_beneficiary, _tokens);
78     }
79 }
80 
81 // File: zeppelin-solidity/contracts/math/SafeMath.sol
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     if (a == 0) {
94       return 0;
95     }
96     uint256 c = a * b;
97     assert(c / a == b);
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers, truncating the quotient.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   /**
112   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   /**
120   * @dev Adds two numbers, throws on overflow.
121   */
122   function add(uint256 a, uint256 b) internal pure returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }
128 
129 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   uint256 totalSupply_;
141 
142   /**
143   * @dev total number of tokens in existence
144   */
145   function totalSupply() public view returns (uint256) {
146     return totalSupply_;
147   }
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[msg.sender]);
157 
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256 balance) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
177 
178 /**
179  * @title Burnable Token
180  * @dev Token that can be irreversibly burned (destroyed).
181  */
182 contract BurnableToken is BasicToken {
183 
184   event Burn(address indexed burner, uint256 value);
185 
186   /**
187    * @dev Burns a specific amount of tokens.
188    * @param _value The amount of token to be burned.
189    */
190   function burn(uint256 _value) public {
191     require(_value <= balances[msg.sender]);
192     // no need to require value <= totalSupply, since that would imply the
193     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
194 
195     address burner = msg.sender;
196     balances[burner] = balances[burner].sub(_value);
197     totalSupply_ = totalSupply_.sub(_value);
198     Burn(burner, _value);
199   }
200 }
201 
202 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
203 
204 /**
205  * @title ERC20 interface
206  * @dev see https://github.com/ethereum/EIPs/issues/20
207  */
208 contract ERC20 is ERC20Basic {
209   function allowance(address owner, address spender) public view returns (uint256);
210   function transferFrom(address from, address to, uint256 value) public returns (bool);
211   function approve(address spender, uint256 value) public returns (bool);
212   event Approval(address indexed owner, address indexed spender, uint256 value);
213 }
214 
215 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
216 
217 contract DetailedERC20 is ERC20 {
218   string public name;
219   string public symbol;
220   uint8 public decimals;
221 
222   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
223     name = _name;
224     symbol = _symbol;
225     decimals = _decimals;
226   }
227 }
228 
229 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
230 
231 /**
232  * @title Standard ERC20 token
233  *
234  * @dev Implementation of the basic standard token.
235  * @dev https://github.com/ethereum/EIPs/issues/20
236  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
237  */
238 contract StandardToken is ERC20, BasicToken {
239 
240   mapping (address => mapping (address => uint256)) internal allowed;
241 
242 
243   /**
244    * @dev Transfer tokens from one address to another
245    * @param _from address The address which you want to send tokens from
246    * @param _to address The address which you want to transfer to
247    * @param _value uint256 the amount of tokens to be transferred
248    */
249   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
250     require(_to != address(0));
251     require(_value <= balances[_from]);
252     require(_value <= allowed[_from][msg.sender]);
253 
254     balances[_from] = balances[_from].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
257     Transfer(_from, _to, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
263    *
264    * Beware that changing an allowance with this method brings the risk that someone may use both the old
265    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
266    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
267    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    * @param _spender The address which will spend the funds.
269    * @param _value The amount of tokens to be spent.
270    */
271   function approve(address _spender, uint256 _value) public returns (bool) {
272     allowed[msg.sender][_spender] = _value;
273     Approval(msg.sender, _spender, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Function to check the amount of tokens that an owner allowed to a spender.
279    * @param _owner address The address which owns the funds.
280    * @param _spender address The address which will spend the funds.
281    * @return A uint256 specifying the amount of tokens still available for the spender.
282    */
283   function allowance(address _owner, address _spender) public view returns (uint256) {
284     return allowed[_owner][_spender];
285   }
286 
287   /**
288    * @dev Increase the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To increment
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _addedValue The amount of tokens to increase the allowance by.
296    */
297   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
298     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
299     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    *
306    * approve should be called when allowed[_spender] == 0. To decrement
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param _spender The address which will spend the funds.
311    * @param _subtractedValue The amount of tokens to decrease the allowance by.
312    */
313   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
314     uint oldValue = allowed[msg.sender][_spender];
315     if (_subtractedValue > oldValue) {
316       allowed[msg.sender][_spender] = 0;
317     } else {
318       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
319     }
320     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321     return true;
322   }
323 
324 }
325 
326 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
327 
328 /**
329  * @title Mintable token
330  * @dev Simple ERC20 Token example, with mintable token creation
331  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
332  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
333  */
334 contract MintableToken is StandardToken, Ownable {
335   event Mint(address indexed to, uint256 amount);
336   event MintFinished();
337 
338   bool public mintingFinished = false;
339 
340 
341   modifier canMint() {
342     require(!mintingFinished);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
353     totalSupply_ = totalSupply_.add(_amount);
354     balances[_to] = balances[_to].add(_amount);
355     Mint(_to, _amount);
356     Transfer(address(0), _to, _amount);
357     return true;
358   }
359 
360   /**
361    * @dev Function to stop minting new tokens.
362    * @return True if the operation was successful.
363    */
364   function finishMinting() onlyOwner canMint public returns (bool) {
365     mintingFinished = true;
366     MintFinished();
367     return true;
368   }
369 }
370 
371 // File: contracts/token/FriendsFingersToken.sol
372 
373 /**
374  * @title FriendsFingersToken
375  */
376 contract FriendsFingersToken is DetailedERC20, MintableToken, BurnableToken, SafeContract {
377 
378     address public builder;
379 
380     modifier canTransfer() {
381         require(mintingFinished);
382         _;
383     }
384 
385     function FriendsFingersToken(
386         string _name,
387         string _symbol,
388         uint8 _decimals
389     )
390     DetailedERC20 (_name, _symbol, _decimals)
391     public
392     {
393         builder = owner;
394     }
395 
396     function transfer(address _to, uint _value) canTransfer public returns (bool) {
397         return super.transfer(_to, _value);
398     }
399 
400     function transferFrom(address _from, address _to, uint _value) canTransfer public returns (bool) {
401         return super.transferFrom(_from, _to, _value);
402     }
403 
404     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
405         require(approve(_spender, _amount));
406 
407         ContractReceiverInterface(_spender).receiveApproval(
408             msg.sender,
409             _amount,
410             this,
411             _extraData
412         );
413 
414         return true;
415     }
416 
417 }
418 
419 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
420 
421 /**
422  * @title Crowdsale
423  * @dev Crowdsale is a base contract for managing a token crowdsale.
424  * Crowdsales have a start and end timestamps, where investors can make
425  * token purchases and the crowdsale will assign them tokens based
426  * on a token per ETH rate. Funds collected are forwarded to a wallet
427  * as they arrive.
428  */
429 contract Crowdsale {
430   using SafeMath for uint256;
431 
432   // The token being sold
433   MintableToken public token;
434 
435   // start and end timestamps where investments are allowed (both inclusive)
436   uint256 public startTime;
437   uint256 public endTime;
438 
439   // address where funds are collected
440   address public wallet;
441 
442   // how many token units a buyer gets per wei
443   uint256 public rate;
444 
445   // amount of raised money in wei
446   uint256 public weiRaised;
447 
448   /**
449    * event for token purchase logging
450    * @param purchaser who paid for the tokens
451    * @param beneficiary who got the tokens
452    * @param value weis paid for purchase
453    * @param amount amount of tokens purchased
454    */
455   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
456 
457 
458   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
459     require(_startTime >= now);
460     require(_endTime >= _startTime);
461     require(_rate > 0);
462     require(_wallet != address(0));
463 
464     token = createTokenContract();
465     startTime = _startTime;
466     endTime = _endTime;
467     rate = _rate;
468     wallet = _wallet;
469   }
470 
471   // fallback function can be used to buy tokens
472   function () external payable {
473     buyTokens(msg.sender);
474   }
475 
476   // low level token purchase function
477   function buyTokens(address beneficiary) public payable {
478     require(beneficiary != address(0));
479     require(validPurchase());
480 
481     uint256 weiAmount = msg.value;
482 
483     // calculate token amount to be created
484     uint256 tokens = getTokenAmount(weiAmount);
485 
486     // update state
487     weiRaised = weiRaised.add(weiAmount);
488 
489     token.mint(beneficiary, tokens);
490     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
491 
492     forwardFunds();
493   }
494 
495   // @return true if crowdsale event has ended
496   function hasEnded() public view returns (bool) {
497     return now > endTime;
498   }
499 
500   // creates the token to be sold.
501   // override this method to have crowdsale of a specific mintable token.
502   function createTokenContract() internal returns (MintableToken) {
503     return new MintableToken();
504   }
505 
506   // Override this method to have a way to add business logic to your crowdsale when buying
507   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
508     return weiAmount.mul(rate);
509   }
510 
511   // send ether to the fund collection wallet
512   // override to create custom fund forwarding mechanisms
513   function forwardFunds() internal {
514     wallet.transfer(msg.value);
515   }
516 
517   // @return true if the transaction can buy tokens
518   function validPurchase() internal view returns (bool) {
519     bool withinPeriod = now >= startTime && now <= endTime;
520     bool nonZeroPurchase = msg.value != 0;
521     return withinPeriod && nonZeroPurchase;
522   }
523 
524 }
525 
526 // File: zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol
527 
528 /**
529  * @title CappedCrowdsale
530  * @dev Extension of Crowdsale with a max amount of funds raised
531  */
532 contract CappedCrowdsale is Crowdsale {
533   using SafeMath for uint256;
534 
535   uint256 public cap;
536 
537   function CappedCrowdsale(uint256 _cap) public {
538     require(_cap > 0);
539     cap = _cap;
540   }
541 
542   // overriding Crowdsale#hasEnded to add cap logic
543   // @return true if crowdsale event has ended
544   function hasEnded() public view returns (bool) {
545     bool capReached = weiRaised >= cap;
546     return capReached || super.hasEnded();
547   }
548 
549   // overriding Crowdsale#validPurchase to add extra cap logic
550   // @return true if investors can buy at the moment
551   function validPurchase() internal view returns (bool) {
552     bool withinCap = weiRaised.add(msg.value) <= cap;
553     return withinCap && super.validPurchase();
554   }
555 
556 }
557 
558 // File: zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
559 
560 /**
561  * @title FinalizableCrowdsale
562  * @dev Extension of Crowdsale where an owner can do extra work
563  * after finishing.
564  */
565 contract FinalizableCrowdsale is Crowdsale, Ownable {
566   using SafeMath for uint256;
567 
568   bool public isFinalized = false;
569 
570   event Finalized();
571 
572   /**
573    * @dev Must be called after crowdsale ends, to do some extra finalization
574    * work. Calls the contract's finalization function.
575    */
576   function finalize() onlyOwner public {
577     require(!isFinalized);
578     require(hasEnded());
579 
580     finalization();
581     Finalized();
582 
583     isFinalized = true;
584   }
585 
586   /**
587    * @dev Can be overridden to add finalization logic. The overriding function
588    * should call super.finalization() to ensure the chain of finalization is
589    * executed entirely.
590    */
591   function finalization() internal {
592   }
593 }
594 
595 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
596 
597 /**
598  * @title Pausable
599  * @dev Base contract which allows children to implement an emergency stop mechanism.
600  */
601 contract Pausable is Ownable {
602   event Pause();
603   event Unpause();
604 
605   bool public paused = false;
606 
607 
608   /**
609    * @dev Modifier to make a function callable only when the contract is not paused.
610    */
611   modifier whenNotPaused() {
612     require(!paused);
613     _;
614   }
615 
616   /**
617    * @dev Modifier to make a function callable only when the contract is paused.
618    */
619   modifier whenPaused() {
620     require(paused);
621     _;
622   }
623 
624   /**
625    * @dev called by the owner to pause, triggers stopped state
626    */
627   function pause() onlyOwner whenNotPaused public {
628     paused = true;
629     Pause();
630   }
631 
632   /**
633    * @dev called by the owner to unpause, returns to normal state
634    */
635   function unpause() onlyOwner whenPaused public {
636     paused = false;
637     Unpause();
638   }
639 }
640 
641 // File: contracts/crowdsale/FriendsFingersCrowdsale.sol
642 
643 /**
644  * @title FriendsFingersCrowdsale
645  */
646 contract FriendsFingersCrowdsale is CappedCrowdsale, FinalizableCrowdsale, Pausable, SafeContract {
647 
648     enum State { Active, Refunding, Closed, Blocked, Expired }
649 
650     uint256 public id;
651     uint256 public previousRoundId;
652     uint256 public nextRoundId;
653 
654     // The token being sold
655     FriendsFingersToken public token;
656 
657     // the round of crowdsale
658     uint256 public round;
659 
660     // minimum amount of funds to be raised in weis
661     uint256 public goal;
662 
663     string public crowdsaleInfo;
664 
665     uint256 public friendsFingersRatePerMille;
666     address public friendsFingersWallet;
667 
668     uint256 public investorCount = 0;
669     mapping (address => uint256) public deposited;
670     State public state;
671 
672     event Closed();
673     event Expired();
674     event RefundsEnabled();
675     event Refunded(address indexed beneficiary, uint256 weiAmount);
676 
677     function FriendsFingersCrowdsale(
678         uint256 _id,
679         uint256 _cap,
680         uint256 _goal,
681         uint256 _startTime,
682         uint256 _endTime,
683         uint256 _rate,
684         address _wallet,
685         FriendsFingersToken _token,
686         string _crowdsaleInfo,
687         uint256 _round,
688         uint256 _previousRoundId,
689         uint256 _friendsFingersRatePerMille,
690         address _friendsFingersWallet
691     ) public
692     CappedCrowdsale (_cap)
693     FinalizableCrowdsale ()
694     Crowdsale (_startTime, _endTime, _rate, _wallet)
695     {
696         require(_endTime <= _startTime + 30 days);
697         require(_token != address(0));
698 
699         require(_round <= 5);
700         if (_round == 1) {
701             if (_id == 1) {
702                 require(_goal >= 0);
703             } else {
704                 require(_goal > 0);
705             }
706         } else {
707             require(_goal == 0);
708         }
709         require(_cap > 0);
710         require(_cap >= _goal);
711 
712         goal = _goal;
713 
714         crowdsaleInfo = _crowdsaleInfo;
715 
716         token = _token;
717 
718         round = _round;
719         previousRoundId = _previousRoundId;
720         state = State.Active;
721 
722         id = _id;
723 
724         friendsFingersRatePerMille = _friendsFingersRatePerMille;
725         friendsFingersWallet = _friendsFingersWallet;
726     }
727 
728     // low level token purchase function
729     function buyTokens(address beneficiary) whenNotPaused public payable {
730         require(beneficiary != address(0));
731         require(validPurchase());
732 
733         uint256 weiAmount = msg.value;
734 
735         // calculate token amount to be created
736         uint256 tokens = getTokenAmount(weiAmount);
737 
738         // update state
739         weiRaised = weiRaised.add(weiAmount);
740 
741         token.mint(beneficiary, tokens);
742         TokenPurchase(
743             msg.sender,
744             beneficiary,
745             weiAmount,
746             tokens
747         );
748 
749         forwardFunds();
750     }
751 
752     // Public methods
753 
754     // if crowdsale is unsuccessful or blocked, investors can claim refunds here
755     function claimRefund() whenNotPaused public {
756         require(state == State.Refunding || state == State.Blocked);
757         address investor = msg.sender;
758 
759         uint256 depositedValue = deposited[investor];
760         deposited[investor] = 0;
761         investor.transfer(depositedValue);
762         Refunded(investor, depositedValue);
763     }
764 
765     function finalize() whenNotPaused public {
766         super.finalize();
767     }
768 
769     // View methods
770 
771     function goalReached() view public returns (bool) {
772         return weiRaised >= goal;
773     }
774 
775     // Only owner methods
776 
777     function updateCrowdsaleInfo(string _crowdsaleInfo) onlyOwner public {
778         require(!hasEnded());
779         crowdsaleInfo = _crowdsaleInfo;
780     }
781 
782     function blockCrowdsale() onlyOwner public {
783         require(state == State.Active);
784         state = State.Blocked;
785     }
786 
787     function setnextRoundId(uint256 _nextRoundId) onlyOwner public {
788         nextRoundId = _nextRoundId;
789     }
790 
791     function setFriendsFingersRate(uint256 _newFriendsFingersRatePerMille) onlyOwner public {
792         require(_newFriendsFingersRatePerMille >= 0);
793         require(_newFriendsFingersRatePerMille <= friendsFingersRatePerMille);
794         friendsFingersRatePerMille = _newFriendsFingersRatePerMille;
795     }
796 
797     function setFriendsFingersWallet(address _friendsFingersWallet) onlyOwner public {
798         require(_friendsFingersWallet != address(0));
799         friendsFingersWallet = _friendsFingersWallet;
800     }
801 
802     // Emergency methods
803 
804     function safeWithdrawal() onlyOwner public {
805         require(now >= endTime + 1 years);
806         friendsFingersWallet.transfer(this.balance);
807     }
808 
809     function setExpiredAndWithdraw() onlyOwner public {
810         require((state == State.Refunding || state == State.Blocked) && now >= endTime + 1 years);
811         state = State.Expired;
812         friendsFingersWallet.transfer(this.balance);
813         Expired();
814     }
815 
816     // Internal methods
817 
818     /**
819      * @dev Create new instance of token contract
820      */
821     function createTokenContract() internal returns (MintableToken) {
822         return MintableToken(address(0));
823     }
824 
825     // overriding CappedCrowdsale#validPurchase to add extra cap logic
826     // @return true if investors can buy at the moment
827     function validPurchase() internal view returns (bool) {
828         bool isActive = state == State.Active;
829         return isActive && super.validPurchase();
830     }
831 
832     // We're overriding the fund forwarding from Crowdsale.
833     function forwardFunds() internal {
834         if (deposited[msg.sender] == 0) {
835             investorCount++;
836         }
837         deposited[msg.sender] = deposited[msg.sender].add(msg.value);
838     }
839 
840     // vault finalization task, called when owner calls finalize()
841     function finalization() internal {
842         require(state == State.Active);
843 
844         if (goalReached()) {
845             state = State.Closed;
846             Closed();
847 
848             if (friendsFingersRatePerMille > 0) {
849                 uint256 friendsFingersFee = weiRaised.mul(friendsFingersRatePerMille).div(1000);
850                 friendsFingersWallet.transfer(friendsFingersFee);
851             }
852 
853             wallet.transfer(this.balance);
854         } else {
855             state = State.Refunding;
856             RefundsEnabled();
857         }
858 
859         if (friendsFingersRatePerMille > 0) {
860             uint256 friendsFingersSupply = cap.mul(rate).mul(friendsFingersRatePerMille).div(1000);
861             token.mint(owner, friendsFingersSupply);
862         }
863 
864         token.transferOwnership(owner);
865 
866         super.finalization();
867     }
868 
869 }
870 
871 // File: contracts/FriendsFingersBuilder.sol
872 
873 /**
874  * @title FriendsFingersBuilder
875  */
876 contract FriendsFingersBuilder is Pausable, SafeContract {
877     using SafeMath for uint256;
878 
879     event CrowdsaleStarted(address ffCrowdsale);
880     event CrowdsaleClosed(address ffCrowdsale);
881 
882     uint public version = 1;
883     string public website = "https://www.friendsfingers.com";
884     uint256 public friendsFingersRatePerMille = 50; //5%
885     address public friendsFingersWallet;
886     mapping (address => bool) public enabledAddresses;
887 
888     uint256 public crowdsaleCount = 0;
889     mapping (uint256 => address) public crowdsaleList;
890     mapping (address => address) public crowdsaleCreators;
891 
892     modifier onlyOwnerOrEnabledAddress() {
893         require(enabledAddresses[msg.sender] || msg.sender == owner);
894         _;
895     }
896 
897     modifier onlyOwnerOrCreator(address _ffCrowdsale) {
898         require(msg.sender == crowdsaleCreators[_ffCrowdsale] || msg.sender == owner);
899         _;
900     }
901 
902     function FriendsFingersBuilder(address _friendsFingersWallet) public {
903         setMainWallet(_friendsFingersWallet);
904     }
905 
906     /**
907      * @notice This is for people who want to donate ETH to FriendsFingers
908      */
909     function () public payable {
910         require(msg.value != 0);
911         friendsFingersWallet.transfer(msg.value);
912     }
913 
914     // crowdsale utility methods
915 
916     function startCrowdsale(
917         string _tokenName,
918         string _tokenSymbol,
919         uint8 _tokenDecimals,
920         uint256 _cap,
921         uint256 _goal,
922         uint256 _creatorSupply,
923         uint256 _startTime,
924         uint256 _endTime,
925         uint256 _rate,
926         address _wallet,
927         string _crowdsaleInfo
928     ) whenNotPaused public returns (FriendsFingersCrowdsale)
929     {
930         crowdsaleCount++;
931         uint256 _round = 1;
932 
933         FriendsFingersToken token = new FriendsFingersToken(
934             _tokenName,
935             _tokenSymbol,
936             _tokenDecimals
937         );
938 
939         if (_creatorSupply > 0) {
940             token.mint(_wallet, _creatorSupply);
941         }
942 
943         FriendsFingersCrowdsale ffCrowdsale = new FriendsFingersCrowdsale(
944         crowdsaleCount,
945         _cap,
946         _goal,
947         _startTime,
948         _endTime,
949         _rate,
950         _wallet,
951         token,
952         _crowdsaleInfo,
953         _round,
954         0,
955         friendsFingersRatePerMille,
956         friendsFingersWallet
957         );
958 
959         if (crowdsaleCount > 1) {
960             ffCrowdsale.pause();
961         }
962 
963         token.transferOwnership(address(ffCrowdsale));
964 
965         addCrowdsaleToList(address(ffCrowdsale));
966 
967         return ffCrowdsale;
968     }
969 
970     function restartCrowdsale(
971         address _ffCrowdsale,
972         uint256 _cap,
973         uint256 _startTime,
974         uint256 _endTime,
975         uint256 _rate,
976         string _crowdsaleInfo
977     ) whenNotPaused onlyOwnerOrCreator(_ffCrowdsale) public returns (FriendsFingersCrowdsale)
978     {
979         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
980         // can't restart twice
981         require(ffCrowdsale.nextRoundId() == 0);
982         // can't restart if goal not reached or rate greater or equal old rate
983         require(ffCrowdsale.goalReached());
984         require(_rate < ffCrowdsale.rate());
985 
986         ffCrowdsale.finalize();
987 
988         crowdsaleCount++;
989         uint256 _round = ffCrowdsale.round();
990         _round++;
991 
992         FriendsFingersToken token = ffCrowdsale.token();
993 
994         FriendsFingersCrowdsale newFriendsFingersCrowdsale = new FriendsFingersCrowdsale(
995             crowdsaleCount,
996             _cap,
997             0,
998             _startTime,
999             _endTime,
1000             _rate,
1001             ffCrowdsale.wallet(),
1002             token,
1003             _crowdsaleInfo,
1004             _round,
1005             ffCrowdsale.id(),
1006             friendsFingersRatePerMille,
1007             friendsFingersWallet
1008         );
1009 
1010         token.transferOwnership(address(newFriendsFingersCrowdsale));
1011 
1012         ffCrowdsale.setnextRoundId(crowdsaleCount);
1013 
1014         addCrowdsaleToList(address(newFriendsFingersCrowdsale));
1015 
1016         return newFriendsFingersCrowdsale;
1017     }
1018 
1019     function closeCrowdsale(address _ffCrowdsale) onlyOwnerOrCreator(_ffCrowdsale) public {
1020         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
1021         ffCrowdsale.finalize();
1022 
1023         FriendsFingersToken token = ffCrowdsale.token();
1024         token.finishMinting();
1025         token.transferOwnership(crowdsaleCreators[_ffCrowdsale]);
1026 
1027         CrowdsaleClosed(ffCrowdsale);
1028     }
1029 
1030     function updateCrowdsaleInfo(address _ffCrowdsale, string _crowdsaleInfo) onlyOwnerOrCreator(_ffCrowdsale) public {
1031         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
1032         ffCrowdsale.updateCrowdsaleInfo(_crowdsaleInfo);
1033     }
1034 
1035     // Only builder owner methods
1036 
1037     function changeEnabledAddressStatus(address _address, bool _status) onlyOwner public {
1038         require(_address != address(0));
1039         enabledAddresses[_address] = _status;
1040     }
1041 
1042     function setDefaultFriendsFingersRate(uint256 _newFriendsFingersRatePerMille) onlyOwner public {
1043         require(_newFriendsFingersRatePerMille >= 0);
1044         require(_newFriendsFingersRatePerMille < friendsFingersRatePerMille);
1045         friendsFingersRatePerMille = _newFriendsFingersRatePerMille;
1046     }
1047 
1048     function setMainWallet(address _newFriendsFingersWallet) onlyOwner public {
1049         require(_newFriendsFingersWallet != address(0));
1050         friendsFingersWallet = _newFriendsFingersWallet;
1051     }
1052 
1053     function setFriendsFingersRateForCrowdsale(address _ffCrowdsale, uint256 _newFriendsFingersRatePerMille) onlyOwner public {
1054         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
1055         ffCrowdsale.setFriendsFingersRate(_newFriendsFingersRatePerMille);
1056     }
1057 
1058     function setFriendsFingersWalletForCrowdsale(address _ffCrowdsale, address _newFriendsFingersWallet) onlyOwner public {
1059         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
1060         ffCrowdsale.setFriendsFingersWallet(_newFriendsFingersWallet);
1061     }
1062 
1063     // Emergency methods (only builder owner or enabled addresses)
1064 
1065     function pauseCrowdsale(address _ffCrowdsale) onlyOwnerOrEnabledAddress public {
1066         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
1067         ffCrowdsale.pause();
1068     }
1069 
1070     function unpauseCrowdsale(address _ffCrowdsale) onlyOwnerOrEnabledAddress public {
1071         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
1072         ffCrowdsale.unpause();
1073     }
1074 
1075     function blockCrowdsale(address _ffCrowdsale) onlyOwnerOrEnabledAddress public {
1076         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
1077         ffCrowdsale.blockCrowdsale();
1078     }
1079 
1080     function safeTokenWithdrawalFromCrowdsale(address _ffCrowdsale, address _tokenAddress, uint256 _tokens) onlyOwnerOrEnabledAddress public {
1081         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
1082         ffCrowdsale.transferAnyERC20Token(_tokenAddress, _tokens, friendsFingersWallet);
1083     }
1084 
1085     function safeWithdrawalFromCrowdsale(address _ffCrowdsale) onlyOwnerOrEnabledAddress public {
1086         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
1087         ffCrowdsale.safeWithdrawal();
1088     }
1089 
1090     function setExpiredAndWithdraw(address _ffCrowdsale) onlyOwnerOrEnabledAddress public {
1091         FriendsFingersCrowdsale ffCrowdsale = FriendsFingersCrowdsale(_ffCrowdsale);
1092         ffCrowdsale.setExpiredAndWithdraw();
1093     }
1094 
1095     // Internal methods
1096 
1097     function addCrowdsaleToList(address ffCrowdsale) internal {
1098         crowdsaleList[crowdsaleCount] = ffCrowdsale;
1099         crowdsaleCreators[ffCrowdsale] = msg.sender;
1100 
1101         CrowdsaleStarted(ffCrowdsale);
1102     }
1103 
1104 }