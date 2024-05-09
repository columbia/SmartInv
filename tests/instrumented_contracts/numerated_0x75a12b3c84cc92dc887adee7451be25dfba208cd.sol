1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   /**
63   * @dev transfer token for a specified address
64   * @param _to The address to transfer to.
65   * @param _value The amount to be transferred.
66   */
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[msg.sender]);
70 
71     // SafeMath.sub will throw if there is not enough balance.
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) public view returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public view returns (uint256) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183 }
184 
185 
186 
187 /**
188  * @title Ownable
189  * @dev The Ownable contract has an owner address, and provides basic authorization control
190  * functions, this simplifies the implementation of "user permissions".
191  */
192 contract Ownable {
193   address public owner;
194 
195 
196   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198 
199   /**
200    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
201    * account.
202    */
203   function Ownable() public {
204     owner = msg.sender;
205   }
206 
207 
208   /**
209    * @dev Throws if called by any account other than the owner.
210    */
211   modifier onlyOwner() {
212     require(msg.sender == owner);
213     _;
214   }
215 
216 
217   /**
218    * @dev Allows the current owner to transfer control of the contract to a newOwner.
219    * @param newOwner The address to transfer ownership to.
220    */
221   function transferOwnership(address newOwner) public onlyOwner {
222     require(newOwner != address(0));
223     OwnershipTransferred(owner, newOwner);
224     owner = newOwner;
225   }
226 
227 }
228 
229 
230 
231 /**
232  * @title Mintable token
233  * @dev Simple ERC20 Token example, with mintable token creation
234  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
235  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
236  */
237 
238 contract MintableToken is StandardToken, Ownable {
239   event Mint(address indexed to, uint256 amount);
240   event MintFinished();
241 
242   bool public mintingFinished = false;
243 
244 
245   modifier canMint() {
246     require(!mintingFinished);
247     _;
248   }
249 
250   /**
251    * @dev Function to mint tokens
252    * @param _to The address that will receive the minted tokens.
253    * @param _amount The amount of tokens to mint.
254    * @return A boolean that indicates if the operation was successful.
255    */
256   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
257     totalSupply = totalSupply.add(_amount);
258     balances[_to] = balances[_to].add(_amount);
259     Mint(_to, _amount);
260     Transfer(address(0), _to, _amount);
261     return true;
262   }
263 
264   /**
265    * @dev Function to stop minting new tokens.
266    * @return True if the operation was successful.
267    */
268   function finishMinting() onlyOwner canMint public returns (bool) {
269     mintingFinished = true;
270     MintFinished();
271     return true;
272   }
273 }
274 
275 
276 /**
277  * @title Crowdsale
278  * @dev Crowdsale is a base contract for managing a token crowdsale.
279  * Crowdsales have a start and end timestamps, where investors can make
280  * token purchases and the crowdsale will assign them tokens based
281  * on a token per ETH rate. Funds collected are forwarded to a wallet
282  * as they arrive.
283  */
284 contract Crowdsale {
285   using SafeMath for uint256;
286 
287   // The token being sold
288   MintableToken public token;
289 
290   // start and end timestamps where investments are allowed (both inclusive)
291   uint256 public startTime;
292   uint256 public endTime;
293 
294   // address where funds are collected
295   address public wallet;
296 
297   // how many token units a buyer gets per wei
298   uint256 public rate;
299 
300   // amount of raised money in wei
301   uint256 public weiRaised;
302 
303   /**
304    * event for token purchase logging
305    * @param purchaser who paid for the tokens
306    * @param beneficiary who got the tokens
307    * @param value weis paid for purchase
308    * @param amount amount of tokens purchased
309    */
310   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
311 
312 
313   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
314     require(_startTime >= now);
315     require(_endTime >= _startTime);
316     require(_rate > 0);
317     require(_wallet != address(0));
318 
319     token = createTokenContract();
320     startTime = _startTime;
321     endTime = _endTime;
322     rate = _rate;
323     wallet = _wallet;
324   }
325 
326   // creates the token to be sold.
327   // override this method to have crowdsale of a specific mintable token.
328   function createTokenContract() internal returns (MintableToken) {
329     return new MintableToken();
330   }
331 
332 
333   // fallback function can be used to buy tokens
334   function () external payable {
335     buyTokens(msg.sender);
336   }
337 
338   // low level token purchase function
339   function buyTokens(address beneficiary) public payable {
340     require(beneficiary != address(0));
341     require(validPurchase());
342 
343     uint256 weiAmount = msg.value;
344 
345     // calculate token amount to be created
346     uint256 tokens = weiAmount.mul(rate);
347 
348     // update state
349     weiRaised = weiRaised.add(weiAmount);
350 
351     token.mint(beneficiary, tokens);
352     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
353 
354     forwardFunds();
355   }
356 
357   // send ether to the fund collection wallet
358   // override to create custom fund forwarding mechanisms
359   function forwardFunds() internal {
360     wallet.transfer(msg.value);
361   }
362 
363   // @return true if the transaction can buy tokens
364   function validPurchase() internal view returns (bool) {
365     bool withinPeriod = now >= startTime && now <= endTime;
366     bool nonZeroPurchase = msg.value != 0;
367     return withinPeriod && nonZeroPurchase;
368   }
369 
370   // @return true if crowdsale event has ended
371   function hasEnded() public view returns (bool) {
372     return now > endTime;
373   }
374 
375 
376 }
377 
378 
379 /**
380  * @title FinalizableCrowdsale
381  * @dev Extension of Crowdsale where an owner can do extra work
382  * after finishing.
383  */
384 contract FinalizableCrowdsale is Crowdsale, Ownable {
385   using SafeMath for uint256;
386 
387   bool public isFinalized = false;
388 
389   event Finalized();
390 
391   /**
392    * @dev Must be called after crowdsale ends, to do some extra finalization
393    * work. Calls the contract's finalization function.
394    */
395   function finalize() onlyOwner public {
396     require(!isFinalized);
397     require(hasEnded());
398 
399     finalization();
400     Finalized();
401 
402     isFinalized = true;
403   }
404 
405   /**
406    * @dev Can be overridden to add finalization logic. The overriding function
407    * should call super.finalization() to ensure the chain of finalization is
408    * executed entirely.
409    */
410   function finalization() internal {
411   }
412 }
413 
414 
415 /**
416  * @title RefundVault
417  * @dev This contract is used for storing funds while a crowdsale
418  * is in progress. Supports refunding the money if crowdsale fails,
419  * and forwarding it if crowdsale is successful.
420  */
421 contract RefundVault is Ownable {
422   using SafeMath for uint256;
423 
424   enum State { Active, Refunding, Closed }
425 
426   mapping (address => uint256) public deposited;
427   address public wallet;
428   State public state;
429 
430   event Closed();
431   event RefundsEnabled();
432   event Refunded(address indexed beneficiary, uint256 weiAmount);
433 
434   function RefundVault(address _wallet) public {
435     require(_wallet != address(0));
436     wallet = _wallet;
437     state = State.Active;
438   }
439 
440   function deposit(address investor) onlyOwner public payable {
441     require(state == State.Active);
442     deposited[investor] = deposited[investor].add(msg.value);
443   }
444 
445   function close() onlyOwner public {
446     require(state == State.Active);
447     state = State.Closed;
448     Closed();
449     wallet.transfer(this.balance);
450   }
451 
452   function enableRefunds() onlyOwner public {
453     require(state == State.Active);
454     state = State.Refunding;
455     RefundsEnabled();
456   }
457 
458   function refund(address investor) public {
459     require(state == State.Refunding);
460     uint256 depositedValue = deposited[investor];
461     deposited[investor] = 0;
462     investor.transfer(depositedValue);
463     Refunded(investor, depositedValue);
464   }
465 }
466 
467 
468 
469 contract FreezableToken is StandardToken {
470     // freezing chains
471     mapping (bytes32 => uint64) internal chains;
472     // freezing amounts for each chain
473     mapping (bytes32 => uint) internal freezings;
474     // total freezing balance per address
475     mapping (address => uint) internal freezingBalance;
476 
477     event Freezed(address indexed to, uint64 release, uint amount);
478     event Released(address indexed owner, uint amount);
479 
480 
481     /**
482      * @dev Gets the balance of the specified address include freezing tokens.
483      * @param _owner The address to query the the balance of.
484      * @return An uint256 representing the amount owned by the passed address.
485      */
486     function balanceOf(address _owner) public view returns (uint256 balance) {
487         return super.balanceOf(_owner) + freezingBalance[_owner];
488     }
489 
490     /**
491      * @dev Gets the balance of the specified address without freezing tokens.
492      * @param _owner The address to query the the balance of.
493      * @return An uint256 representing the amount owned by the passed address.
494      */
495     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
496         return super.balanceOf(_owner);
497     }
498 
499     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
500         return freezingBalance[_owner];
501     }
502 
503     /**
504      * @dev gets freezing count
505      * @param _addr Address of freeze tokens owner.
506      */
507     function freezingCount(address _addr) public view returns (uint count) {
508         uint64 release = chains[toKey(_addr, 0)];
509         while (release != 0) {
510             count ++;
511             release = chains[toKey(_addr, release)];
512         }
513     }
514 
515     /**
516      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
517      * @param _addr Address of freeze tokens owner.
518      * @param _index Freezing portion index. It ordered by release date descending.
519      */
520     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
521         for (uint i = 0; i < _index + 1; i ++) {
522             _release = chains[toKey(_addr, _release)];
523             if (_release == 0) {
524                 return;
525             }
526         }
527         _balance = freezings[toKey(_addr, _release)];
528     }
529 
530     /**
531      * @dev freeze your tokens to the specified address.
532      *      Be careful, gas usage is not deterministic,
533      *      and depends on how many freezes _to address already has.
534      * @param _to Address to which token will be freeze.
535      * @param _amount Amount of token to freeze.
536      * @param _until Release date, must be in future.
537      */
538     function freezeTo(address _to, uint _amount, uint64 _until) public {
539         require(_to != address(0));
540         require(_amount <= balances[msg.sender]);
541 
542         balances[msg.sender] = balances[msg.sender].sub(_amount);
543 
544         bytes32 currentKey = toKey(_to, _until);
545         freezings[currentKey] = freezings[currentKey].add(_amount);
546         freezingBalance[_to] = freezingBalance[_to].add(_amount);
547 
548         freeze(_to, _until);
549         Freezed(_to, _until, _amount);
550     }
551 
552     /**
553      * @dev release first available freezing tokens.
554      */
555     function releaseOnce() public {
556         bytes32 headKey = toKey(msg.sender, 0);
557         uint64 head = chains[headKey];
558         require(head != 0);
559         require(uint64(block.timestamp) > head);
560         bytes32 currentKey = toKey(msg.sender, head);
561 
562         uint64 next = chains[currentKey];
563 
564         uint amount = freezings[currentKey];
565         delete freezings[currentKey];
566 
567         balances[msg.sender] = balances[msg.sender].add(amount);
568         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
569 
570         if (next == 0) {
571             delete chains[headKey];
572         }
573         else {
574             chains[headKey] = next;
575             delete chains[currentKey];
576         }
577         Released(msg.sender, amount);
578     }
579 
580     /**
581      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
582      * @return how many tokens was released
583      */
584     function releaseAll() public returns (uint tokens) {
585         uint release;
586         uint balance;
587         (release, balance) = getFreezing(msg.sender, 0);
588         while (release != 0 && block.timestamp > release) {
589             releaseOnce();
590             tokens += balance;
591             (release, balance) = getFreezing(msg.sender, 0);
592         }
593     }
594 
595     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
596         // WISH masc to increase entropy
597         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
598         assembly {
599             result := or(result, mul(_addr, 0x10000000000000000))
600             result := or(result, _release)
601         }
602     }
603 
604     function freeze(address _to, uint64 _until) internal {
605         require(_until > block.timestamp);
606         bytes32 key = toKey(_to, _until);
607         bytes32 parentKey = toKey(_to, uint64(0));
608         uint64 next = chains[parentKey];
609 
610         if (next == 0) {
611             chains[parentKey] = _until;
612             return;
613         }
614 
615         bytes32 nextKey = toKey(_to, next);
616         uint parent;
617 
618         while (next != 0 && _until > next) {
619             parent = next;
620             parentKey = nextKey;
621 
622             next = chains[nextKey];
623             nextKey = toKey(_to, next);
624         }
625 
626         if (_until == next) {
627             return;
628         }
629 
630         if (next != 0) {
631             chains[key] = next;
632         }
633 
634         chains[parentKey] = _until;
635     }
636 }
637 
638 /**
639 * @title Contract that will work with ERC223 tokens.
640 */
641 
642 contract ERC223Receiver {
643     /**
644      * @dev Standard ERC223 function that will handle incoming token transfers.
645      *
646      * @param _from  Token sender address.
647      * @param _value Amount of tokens.
648      * @param _data  Transaction metadata.
649      */
650     function tokenFallback(address _from, uint _value, bytes _data) public;
651 }
652 
653 contract ERC223Basic is ERC20Basic {
654     function transfer(address to, uint value, bytes data) public returns (bool);
655     event Transfer(address indexed from, address indexed to, uint value, bytes data);
656 }
657 
658 
659 contract SuccessfulERC223Receiver is ERC223Receiver {
660     event Invoked(address from, uint value, bytes data);
661 
662     function tokenFallback(address _from, uint _value, bytes _data) public {
663         Invoked(_from, _value, _data);
664     }
665 }
666 
667 contract FailingERC223Receiver is ERC223Receiver {
668     function tokenFallback(address, uint, bytes) public {
669         revert();
670     }
671 }
672 
673 contract ERC223ReceiverWithoutTokenFallback {
674 }
675 
676 /**
677  * @title Burnable Token
678  * @dev Token that can be irreversibly burned (destroyed).
679  */
680 contract BurnableToken is StandardToken {
681 
682     event Burn(address indexed burner, uint256 value);
683 
684     /**
685      * @dev Burns a specific amount of tokens.
686      * @param _value The amount of token to be burned.
687      */
688     function burn(uint256 _value) public {
689         require(_value > 0);
690         require(_value <= balances[msg.sender]);
691         // no need to require value <= totalSupply, since that would imply the
692         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
693 
694         address burner = msg.sender;
695         balances[burner] = balances[burner].sub(_value);
696         totalSupply = totalSupply.sub(_value);
697         Burn(burner, _value);
698     }
699 }
700 
701 
702 
703 /**
704  * @title Pausable
705  * @dev Base contract which allows children to implement an emergency stop mechanism.
706  */
707 contract Pausable is Ownable {
708   event Pause();
709   event Unpause();
710 
711   bool public paused = false;
712 
713 
714   /**
715    * @dev Modifier to make a function callable only when the contract is not paused.
716    */
717   modifier whenNotPaused() {
718     require(!paused);
719     _;
720   }
721 
722   /**
723    * @dev Modifier to make a function callable only when the contract is paused.
724    */
725   modifier whenPaused() {
726     require(paused);
727     _;
728   }
729 
730   /**
731    * @dev called by the owner to pause, triggers stopped state
732    */
733   function pause() onlyOwner whenNotPaused public {
734     paused = true;
735     Pause();
736   }
737 
738   /**
739    * @dev called by the owner to unpause, returns to normal state
740    */
741   function unpause() onlyOwner whenPaused public {
742     paused = false;
743     Unpause();
744   }
745 }
746 
747 
748 
749 contract FreezableMintableToken is FreezableToken, MintableToken {
750     /**
751      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
752      *      Be careful, gas usage is not deterministic,
753      *      and depends on how many freezes _to address already has.
754      * @param _to Address to which token will be freeze.
755      * @param _amount Amount of token to mint and freeze.
756      * @param _until Release date, must be in future.
757      * @return A boolean that indicates if the operation was successful.
758      */
759     function mintAndFreeze(address _to, uint _amount, uint64 _until) onlyOwner canMint public returns (bool) {
760         totalSupply = totalSupply.add(_amount);
761 
762         bytes32 currentKey = toKey(_to, _until);
763         freezings[currentKey] = freezings[currentKey].add(_amount);
764         freezingBalance[_to] = freezingBalance[_to].add(_amount);
765 
766         freeze(_to, _until);
767         Mint(_to, _amount);
768         Freezed(_to, _until, _amount);
769         return true;
770     }
771 }
772 
773 contract Consts {
774     uint constant TOKEN_DECIMALS = 18;
775     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
776     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
777 
778     string constant TOKEN_NAME = "CoinFastShares";
779     string constant TOKEN_SYMBOL = "CFSS";
780     bool constant PAUSED = false;
781     address constant TARGET_USER = 0xf4e50aF1555c2e86867561a8115f354eFCB7A4c5;
782     
783     uint constant START_TIME = 1522530000;
784     
785     bool constant CONTINUE_MINTING = false;
786 }
787 
788 
789 
790 
791 /**
792  * @title Reference implementation of the ERC223 standard token.
793  */
794 contract ERC223Token is ERC223Basic, BasicToken, FailingERC223Receiver {
795     using SafeMath for uint;
796 
797     /**
798      * @dev Transfer the specified amount of tokens to the specified address.
799      *      Invokes the `tokenFallback` function if the recipient is a contract.
800      *      The token transfer fails if the recipient is a contract
801      *      but does not implement the `tokenFallback` function
802      *      or the fallback function to receive funds.
803      *
804      * @param _to    Receiver address.
805      * @param _value Amount of tokens that will be transferred.
806      * @param _data  Transaction metadata.
807      */
808     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
809         // Standard function transfer similar to ERC20 transfer with no _data .
810         // Added due to backwards compatibility reasons .
811         uint codeLength;
812 
813         assembly {
814             // Retrieve the size of the code on target address, this needs assembly.
815             codeLength := extcodesize(_to)
816         }
817 
818         balances[msg.sender] = balances[msg.sender].sub(_value);
819         balances[_to] = balances[_to].add(_value);
820         if(codeLength > 0) {
821             ERC223Receiver receiver = ERC223Receiver(_to);
822             receiver.tokenFallback(msg.sender, _value, _data);
823         }
824         Transfer(msg.sender, _to, _value, _data);
825         return true;
826     }
827 
828     /**
829      * @dev Transfer the specified amount of tokens to the specified address.
830      *      This function works the same with the previous one
831      *      but doesn't contain `_data` param.
832      *      Added due to backwards compatibility reasons.
833      *
834      * @param _to    Receiver address.
835      * @param _value Amount of tokens that will be transferred.
836      */
837     function transfer(address _to, uint256 _value) public returns (bool) {
838         bytes memory empty;
839         return transfer(_to, _value, empty);
840     }
841 }
842 
843 
844 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
845     
846 {
847     
848 
849     function name() pure public returns (string _name) {
850         return TOKEN_NAME;
851     }
852 
853     function symbol() pure public returns (string _symbol) {
854         return TOKEN_SYMBOL;
855     }
856 
857     function decimals() pure public returns (uint8 _decimals) {
858         return TOKEN_DECIMALS_UINT8;
859     }
860 
861     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
862         require(!paused);
863         return super.transferFrom(_from, _to, _value);
864     }
865 
866     function transfer(address _to, uint256 _value) public returns (bool _success) {
867         require(!paused);
868         return super.transfer(_to, _value);
869     }
870 }
871 
872 
873 
874 
875 /**
876  * @title CappedCrowdsale
877  * @dev Extension of Crowdsale with a max amount of funds raised
878  */
879 contract CappedCrowdsale is Crowdsale {
880   using SafeMath for uint256;
881 
882   uint256 public cap;
883 
884   function CappedCrowdsale(uint256 _cap) public {
885     require(_cap > 0);
886     cap = _cap;
887   }
888 
889   // overriding Crowdsale#validPurchase to add extra cap logic
890   // @return true if investors can buy at the moment
891   function validPurchase() internal view returns (bool) {
892     bool withinCap = weiRaised.add(msg.value) <= cap;
893     return super.validPurchase() && withinCap;
894   }
895 
896   // overriding Crowdsale#hasEnded to add cap logic
897   // @return true if crowdsale event has ended
898   function hasEnded() public view returns (bool) {
899     bool capReached = weiRaised >= cap;
900     return super.hasEnded() || capReached;
901   }
902 
903 }
904 
905 
906 
907 /**
908  * @title RefundableCrowdsale
909  * @dev Extension of Crowdsale contract that adds a funding goal, and
910  * the possibility of users getting a refund if goal is not met.
911  * Uses a RefundVault as the crowdsale's vault.
912  */
913 contract RefundableCrowdsale is FinalizableCrowdsale {
914   using SafeMath for uint256;
915 
916   // minimum amount of funds to be raised in weis
917   uint256 public goal;
918 
919   // refund vault used to hold funds while crowdsale is running
920   RefundVault public vault;
921 
922   function RefundableCrowdsale(uint256 _goal) public {
923     require(_goal > 0);
924     vault = new RefundVault(wallet);
925     goal = _goal;
926   }
927 
928   // We're overriding the fund forwarding from Crowdsale.
929   // In addition to sending the funds, we want to call
930   // the RefundVault deposit function
931   function forwardFunds() internal {
932     vault.deposit.value(msg.value)(msg.sender);
933   }
934 
935   // if crowdsale is unsuccessful, investors can claim refunds here
936   function claimRefund() public {
937     require(isFinalized);
938     require(!goalReached());
939 
940     vault.refund(msg.sender);
941   }
942 
943   // vault finalization task, called when owner calls finalize()
944   function finalization() internal {
945     if (goalReached()) {
946       vault.close();
947     } else {
948       vault.enableRefunds();
949     }
950 
951     super.finalization();
952   }
953 
954   function goalReached() public view returns (bool) {
955     return weiRaised >= goal;
956   }
957 
958 }
959 
960 
961 contract MainCrowdsale is Consts, FinalizableCrowdsale {
962     function hasStarted() public constant returns (bool) {
963         return now >= startTime;
964     }
965 
966     function finalization() internal {
967         super.finalization();
968 
969         if (PAUSED) {
970             MainToken(token).unpause();
971         }
972 
973         if (!CONTINUE_MINTING) {
974             token.finishMinting();
975         }
976 
977         token.transferOwnership(TARGET_USER);
978     }
979 
980     function buyTokens(address beneficiary) public payable {
981         require(beneficiary != address(0));
982         require(validPurchase());
983 
984         uint256 weiAmount = msg.value;
985 
986         // calculate token amount to be created
987         uint256 tokens = weiAmount.mul(rate).div(1 ether);
988 
989         // update state
990         weiRaised = weiRaised.add(weiAmount);
991 
992         token.mint(beneficiary, tokens);
993         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
994 
995         forwardFunds();
996     }
997 }
998 
999 
1000 contract Checkable {
1001     address private serviceAccount;
1002     /**
1003      * Flag means that contract accident already occurs.
1004      */
1005     bool private triggered = false;
1006 
1007     // Occurs when accident happened.
1008     event Triggered(uint balance);
1009 
1010     function Checkable() public {
1011         serviceAccount = msg.sender;
1012     }
1013 
1014     /**
1015      * @dev Replace service account with new one.
1016      * @param _account Valid service account address.
1017      */
1018     function changeServiceAccount(address _account) onlyService public {
1019         assert(_account != 0);
1020         serviceAccount = _account;
1021     }
1022 
1023     /**
1024      * @dev Is caller (sender) service account.
1025      */
1026     function isServiceAccount() view public returns (bool) {
1027         return msg.sender == serviceAccount;
1028     }
1029 
1030     /**
1031      * Public check method.
1032      */
1033     function check() onlyService notTriggered payable public {
1034         if (internalCheck()) {
1035             Triggered(this.balance);
1036             triggered = true;
1037             internalAction();
1038         }
1039     }
1040 
1041     /**
1042      * @dev Do inner check.
1043      * @return bool true of accident triggered, false otherwise.
1044      */
1045     function internalCheck() internal returns (bool);
1046 
1047     /**
1048      * @dev Do inner action if check was success.
1049      */
1050     function internalAction() internal;
1051 
1052     modifier onlyService {
1053         require(msg.sender == serviceAccount);
1054         _;
1055     }
1056 
1057     modifier notTriggered() {
1058         require(!triggered);
1059         _;
1060     }
1061 }
1062 
1063 
1064 contract BonusableCrowdsale is Consts, Crowdsale {
1065 
1066     function buyTokens(address beneficiary) public payable {
1067         require(beneficiary != address(0));
1068         require(validPurchase());
1069 
1070         uint256 weiAmount = msg.value;
1071 
1072         // calculate token amount to be created
1073         uint256 bonusRate = getBonusRate(weiAmount);
1074         uint256 tokens = weiAmount.mul(bonusRate).div(1 ether);
1075 
1076         // update state
1077         weiRaised = weiRaised.add(weiAmount);
1078 
1079         token.mint(beneficiary, tokens);
1080         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1081 
1082         forwardFunds();
1083     }
1084 
1085     function getBonusRate(uint256 weiAmount) internal view returns (uint256) {
1086         uint256 bonusRate = rate;
1087 
1088         
1089         // apply bonus for time & weiRaised
1090         uint[7] memory weiRaisedStartsBoundaries = [uint(0),uint(0),uint(0),uint(0),uint(0),uint(0),uint(0)];
1091         uint[7] memory weiRaisedEndsBoundaries = [uint(198018199980000000000000),uint(198018199980000000000000),uint(198018199980000000000000),uint(198018199980000000000000),uint(198018199980000000000000),uint(198018199980000000000000),uint(198018199980000000000000)];
1092         uint64[7] memory timeStartsBoundaries = [uint64(1522530000),uint64(1527800400),uint64(1532984400),uint64(1535662800),uint64(1538254800),uint64(1540933200),uint64(1543525200)];
1093         uint64[7] memory timeEndsBoundaries = [uint64(1527800400),uint64(1532984400),uint64(1535662800),uint64(1538254800),uint64(1540933200),uint64(1543525200),uint64(1546203600)];
1094         uint[7] memory weiRaisedAndTimeRates = [uint(490),uint(410),uint(330),uint(250),uint(170),uint(90),uint(50)];
1095 
1096         for (uint i = 0; i < 7; i++) {
1097             bool weiRaisedInBound = (weiRaisedStartsBoundaries[i] <= weiRaised) && (weiRaised < weiRaisedEndsBoundaries[i]);
1098             bool timeInBound = (timeStartsBoundaries[i] <= now) && (now < timeEndsBoundaries[i]);
1099             if (weiRaisedInBound && timeInBound) {
1100                 bonusRate += bonusRate * weiRaisedAndTimeRates[i] / 1000;
1101             }
1102         }
1103         
1104 
1105         
1106 
1107         return bonusRate;
1108     }
1109 }
1110 
1111 
1112 
1113 contract TemplateCrowdsale is Consts, MainCrowdsale
1114     
1115     , BonusableCrowdsale
1116     
1117     
1118     , CappedCrowdsale
1119     
1120 {
1121     event Initialized();
1122     bool public initialized = false;
1123 
1124     function TemplateCrowdsale(MintableToken _token) public
1125         Crowdsale(START_TIME > now ? START_TIME : now, 1546290000, 50000 * TOKEN_DECIMAL_MULTIPLIER, 0xf4e50aF1555c2e86867561a8115f354eFCB7A4c5)
1126         CappedCrowdsale(198018199980000000000000)
1127         
1128     {
1129         token = _token;
1130     }
1131 
1132     function init() public onlyOwner {
1133         require(!initialized);
1134         initialized = true;
1135 
1136         if (PAUSED) {
1137             MainToken(token).pause();
1138         }
1139 
1140         
1141 
1142         transferOwnership(TARGET_USER);
1143 
1144         Initialized();
1145     }
1146 
1147     /**
1148      * @dev override token creation to set token address in constructor.
1149      */
1150     function createTokenContract() internal returns (MintableToken) {
1151         return MintableToken(0);
1152     }
1153 
1154     
1155 }