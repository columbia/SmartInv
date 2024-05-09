1 pragma solidity ^0.4.18;
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
468 /**
469  * @title SafeERC20
470  * @dev Wrappers around ERC20 operations that throw on failure.
471  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
472  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
473  */
474 library SafeERC20 {
475   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
476     assert(token.transfer(to, value));
477   }
478 
479   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
480     assert(token.transferFrom(from, to, value));
481   }
482 
483   function safeApprove(ERC20 token, address spender, uint256 value) internal {
484     assert(token.approve(spender, value));
485   }
486 }
487 
488 
489 
490 contract FreezableToken is StandardToken {
491     mapping (address => uint64) internal roots;
492 
493     mapping (bytes32 => uint64) internal chains;
494 
495     event Freezed(address indexed to, uint64 release, uint amount);
496     event Released(address indexed owner, uint amount);
497 
498     /**
499      * @dev gets summary information about all freeze tokens for the specified address.
500      * @param _addr Address of freeze tokens owner.
501      */
502     function getFreezingSummaryOf(address _addr) public constant returns (uint tokenAmount, uint freezingCount) {
503         uint count;
504         uint total;
505         uint64 release = roots[_addr];
506         while (release != 0) {
507             count ++;
508             total += balanceOf(address(keccak256(toKey(_addr, release))));
509             release = chains[toKey(_addr, release)];
510         }
511 
512         return (total, count);
513     }
514 
515     /**
516      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
517      * @param _addr Address of freeze tokens owner.
518      * @param _index Freezing portion index. It ordered by release date descending.
519      */
520     function getFreezing(address _addr, uint _index) public constant returns (uint64 _release, uint _balance) {
521         uint64 release = roots[_addr];
522         for (uint i = 0; i < _index; i ++) {
523             release = chains[toKey(_addr, release)];
524         }
525         return (release, balanceOf(address(keccak256(toKey(_addr, release)))));
526     }
527 
528     /**
529      * @dev freeze your tokens to the specified address.
530      *      Be careful, gas usage is not deterministic,
531      *      and depends on how many freezes _to address already has.
532      * @param _to Address to which token will be freeze.
533      * @param _amount Amount of token to freeze.
534      * @param _until Release date, must be in future.
535      */
536     function freezeTo(address _to, uint _amount, uint64 _until) public {
537         bytes32 currentKey = toKey(_to, _until);
538         transfer(address(keccak256(currentKey)), _amount);
539 
540         freeze(_to, _until);
541         Freezed(_to, _until, _amount);
542     }
543 
544     /**
545      * @dev release first available freezing tokens.
546      */
547     function releaseOnce() public {
548         uint64 head = roots[msg.sender];
549         require(head != 0);
550         require(uint64(block.timestamp) > head);
551         bytes32 currentKey = toKey(msg.sender, head);
552 
553         uint64 next = chains[currentKey];
554 
555         address currentAddress = address(keccak256(currentKey));
556         uint amount = balances[currentAddress];
557         delete balances[currentAddress];
558 
559         balances[msg.sender] += amount;
560 
561         if (next == 0) {
562             delete roots[msg.sender];
563         }
564         else {
565             roots[msg.sender] = next;
566         }
567         Released(msg.sender, amount);
568     }
569 
570     /**
571      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
572      * @return how many tokens was released
573      */
574     function releaseAll() public returns (uint tokens) {
575         uint release;
576         uint balance;
577         (release, balance) = getFreezing(msg.sender, 0);
578         while (release != 0 && block.timestamp > release) {
579             releaseOnce();
580             tokens += balance;
581             (release, balance) = getFreezing(msg.sender, 0);
582         }
583     }
584 
585     function toKey(address _addr, uint _release) internal constant returns (bytes32 result) {
586         // WISH masc to increase entropy
587         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
588         assembly {
589             result := or(result, mul(_addr, 0x10000000000000000))
590             result := or(result, _release)
591         }
592     }
593 
594     function freeze(address _to, uint64 _until) internal {
595         require(_until > block.timestamp);
596         uint64 head = roots[_to];
597 
598         if (head == 0) {
599             roots[_to] = _until;
600             return;
601         }
602 
603         bytes32 headKey = toKey(_to, head);
604         uint parent;
605         bytes32 parentKey;
606 
607         while (head != 0 && _until > head) {
608             parent = head;
609             parentKey = headKey;
610 
611             head = chains[headKey];
612             headKey = toKey(_to, head);
613         }
614 
615         if (_until == head) {
616             return;
617         }
618 
619         if (head != 0) {
620             chains[toKey(_to, _until)] = head;
621         }
622 
623         if (parent == 0) {
624             roots[_to] = _until;
625         }
626         else {
627             chains[parentKey] = _until;
628         }
629     }
630 }
631 
632 /**
633  * @title Burnable Token
634  * @dev Token that can be irreversibly burned (destroyed).
635  */
636 contract BurnableToken is StandardToken {
637 
638     event Burn(address indexed burner, uint256 value);
639 
640     /**
641      * @dev Burns a specific amount of tokens.
642      * @param _value The amount of token to be burned.
643      */
644     function burn(uint256 _value) public {
645         require(_value > 0);
646         require(_value <= balances[msg.sender]);
647         // no need to require value <= totalSupply, since that would imply the
648         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
649 
650         address burner = msg.sender;
651         balances[burner] = balances[burner].sub(_value);
652         totalSupply = totalSupply.sub(_value);
653         Burn(burner, _value);
654     }
655 }
656 
657 
658 
659 /**
660  * @title Pausable
661  * @dev Base contract which allows children to implement an emergency stop mechanism.
662  */
663 contract Pausable is Ownable {
664   event Pause();
665   event Unpause();
666 
667   bool public paused = false;
668 
669 
670   /**
671    * @dev Modifier to make a function callable only when the contract is not paused.
672    */
673   modifier whenNotPaused() {
674     require(!paused);
675     _;
676   }
677 
678   /**
679    * @dev Modifier to make a function callable only when the contract is paused.
680    */
681   modifier whenPaused() {
682     require(paused);
683     _;
684   }
685 
686   /**
687    * @dev called by the owner to pause, triggers stopped state
688    */
689   function pause() onlyOwner whenNotPaused public {
690     paused = true;
691     Pause();
692   }
693 
694   /**
695    * @dev called by the owner to unpause, returns to normal state
696    */
697   function unpause() onlyOwner whenPaused public {
698     paused = false;
699     Unpause();
700   }
701 }
702 
703 
704 
705 /**
706  * @title TokenTimelock
707  * @dev TokenTimelock is a token holder contract that will allow a
708  * beneficiary to extract the tokens after a given release time
709  */
710 contract TokenTimelock {
711   using SafeERC20 for ERC20Basic;
712 
713   // ERC20 basic token contract being held
714   ERC20Basic public token;
715 
716   // beneficiary of tokens after they are released
717   address public beneficiary;
718 
719   // timestamp when token release is enabled
720   uint64 public releaseTime;
721 
722   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
723     require(_releaseTime > now);
724     token = _token;
725     beneficiary = _beneficiary;
726     releaseTime = _releaseTime;
727   }
728 
729   /**
730    * @notice Transfers tokens held by timelock to beneficiary.
731    */
732   function release() public {
733     require(now >= releaseTime);
734 
735     uint256 amount = token.balanceOf(this);
736     require(amount > 0);
737 
738     token.safeTransfer(beneficiary, amount);
739   }
740 }
741 
742 
743 
744 contract FreezableMintableToken is FreezableToken, MintableToken {
745     /**
746      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
747      *      Be careful, gas usage is not deterministic,
748      *      and depends on how many freezes _to address already has.
749      * @param _to Address to which token will be freeze.
750      * @param _amount Amount of token to mint and freeze.
751      * @param _until Release date, must be in future.
752      */
753     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner {
754         bytes32 currentKey = toKey(_to, _until);
755         mint(address(keccak256(currentKey)), _amount);
756 
757         freeze(_to, _until);
758         Freezed(_to, _until, _amount);
759     }
760 }
761 
762 contract usingConsts {
763     uint constant TOKEN_DECIMALS = 18;
764     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
765     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
766 
767     string constant TOKEN_NAME = "DAYToken";
768     string constant TOKEN_SYMBOL = "DAYT";
769     bool constant PAUSED = false;
770     address constant TARGET_USER = 0xA8eBce443fdDd76cC1AB018D96B4F5E3b629f1E6;
771     uint constant START_TIME = 1519858800;
772     bool constant CONTINUE_MINTING = false;
773 }
774 
775 
776 
777 contract MainToken is usingConsts, FreezableMintableToken, BurnableToken, Pausable {
778     function MainToken() {
779         if (PAUSED) {
780             pause();
781         }
782     }
783 
784     function name() constant public returns (string _name) {
785         return TOKEN_NAME;
786     }
787 
788     function symbol() constant public returns (string _symbol) {
789         return TOKEN_SYMBOL;
790     }
791 
792     function decimals() constant public returns (uint8 _decimals) {
793         return TOKEN_DECIMALS_UINT8;
794     }
795 
796     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
797         require(!paused);
798         return super.transferFrom(_from, _to, _value);
799     }
800 
801     function transfer(address _to, uint256 _value) returns (bool _success) {
802         require(!paused);
803         return super.transfer(_to, _value);
804     }
805 }
806 
807 
808 /**
809  * @title CappedCrowdsale
810  * @dev Extension of Crowdsale with a max amount of funds raised
811  */
812 contract CappedCrowdsale is Crowdsale {
813   using SafeMath for uint256;
814 
815   uint256 public cap;
816 
817   function CappedCrowdsale(uint256 _cap) public {
818     require(_cap > 0);
819     cap = _cap;
820   }
821 
822   // overriding Crowdsale#validPurchase to add extra cap logic
823   // @return true if investors can buy at the moment
824   function validPurchase() internal view returns (bool) {
825     bool withinCap = weiRaised.add(msg.value) <= cap;
826     return super.validPurchase() && withinCap;
827   }
828 
829   // overriding Crowdsale#hasEnded to add cap logic
830   // @return true if crowdsale event has ended
831   function hasEnded() public view returns (bool) {
832     bool capReached = weiRaised >= cap;
833     return super.hasEnded() || capReached;
834   }
835 
836 }
837 
838 
839 
840 /**
841  * @title RefundableCrowdsale
842  * @dev Extension of Crowdsale contract that adds a funding goal, and
843  * the possibility of users getting a refund if goal is not met.
844  * Uses a RefundVault as the crowdsale's vault.
845  */
846 contract RefundableCrowdsale is FinalizableCrowdsale {
847   using SafeMath for uint256;
848 
849   // minimum amount of funds to be raised in weis
850   uint256 public goal;
851 
852   // refund vault used to hold funds while crowdsale is running
853   RefundVault public vault;
854 
855   function RefundableCrowdsale(uint256 _goal) public {
856     require(_goal > 0);
857     vault = new RefundVault(wallet);
858     goal = _goal;
859   }
860 
861   // We're overriding the fund forwarding from Crowdsale.
862   // In addition to sending the funds, we want to call
863   // the RefundVault deposit function
864   function forwardFunds() internal {
865     vault.deposit.value(msg.value)(msg.sender);
866   }
867 
868   // if crowdsale is unsuccessful, investors can claim refunds here
869   function claimRefund() public {
870     require(isFinalized);
871     require(!goalReached());
872 
873     vault.refund(msg.sender);
874   }
875 
876   // vault finalization task, called when owner calls finalize()
877   function finalization() internal {
878     if (goalReached()) {
879       vault.close();
880     } else {
881       vault.enableRefunds();
882     }
883 
884     super.finalization();
885   }
886 
887   function goalReached() public view returns (bool) {
888     return weiRaised >= goal;
889   }
890 
891 }
892 
893 
894 contract MainCrowdsale is usingConsts, FinalizableCrowdsale {
895     function hasStarted() public constant returns (bool) {
896         return now >= startTime;
897     }
898 
899     /**
900      * @dev override token creation to integrate with MyWish token.
901      */
902     function createTokenContract() internal returns (MintableToken) {
903         return new MainToken();
904     }
905 
906     function finalization() internal {
907         super.finalization();
908         if (CONTINUE_MINTING) {
909             return;
910         }
911 
912         if (PAUSED) {
913             MainToken(token).unpause();
914         }
915         token.finishMinting();
916         token.transferOwnership(TARGET_USER);
917     }
918 
919     function buyTokens(address beneficiary) public payable {
920         require(beneficiary != address(0));
921         require(validPurchase());
922 
923         uint256 weiAmount = msg.value;
924 
925         // calculate token amount to be created
926         uint256 tokens = weiAmount.mul(rate).div(1 ether);
927 
928         // update state
929         weiRaised = weiRaised.add(weiAmount);
930 
931         token.mint(beneficiary, tokens);
932         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
933 
934         forwardFunds();
935     }
936 }
937 
938 
939 contract Checkable {
940     address private serviceAccount;
941     /**
942      * Flag means that contract accident already occurs.
943      */
944     bool private triggered = false;
945 
946     // Occurs when accident happened.
947     event Triggered(uint balance);
948 
949     function Checkable() public {
950         serviceAccount = msg.sender;
951     }
952 
953     /**
954      * @dev Replace service account with new one.
955      * @param _account Valid service account address.
956      */
957     function changeServiceAccount(address _account) onlyService public {
958         assert(_account != 0);
959         serviceAccount = _account;
960     }
961 
962     /**
963      * @dev Is caller (sender) service account.
964      */
965     function isServiceAccount() constant public returns (bool) {
966         return msg.sender == serviceAccount;
967     }
968 
969     /**
970      * Public check method.
971      */
972     function check() onlyService notTriggered payable public {
973         if (internalCheck()) {
974             Triggered(this.balance);
975             triggered = true;
976             internalAction();
977         }
978     }
979 
980     /**
981      * @dev Do inner check.
982      * @return bool true of accident triggered, false otherwise.
983      */
984     function internalCheck() internal returns (bool);
985 
986     /**
987      * @dev Do inner action if check was success.
988      */
989     function internalAction() internal;
990 
991     modifier onlyService {
992         require(msg.sender == serviceAccount);
993         _;
994     }
995 
996     modifier notTriggered() {
997         require(!triggered);
998         _;
999     }
1000 }
1001 
1002 
1003 contract BonusableCrowdsale is usingConsts, Crowdsale {
1004 
1005     function buyTokens(address beneficiary) public payable {
1006         require(beneficiary != address(0));
1007         require(validPurchase());
1008 
1009         uint256 weiAmount = msg.value;
1010 
1011         // calculate token amount to be created
1012         uint256 bonusRate = getBonusRate(weiAmount);
1013         uint256 tokens = weiAmount.mul(bonusRate).div(1 ether);
1014 
1015         // update state
1016         weiRaised = weiRaised.add(weiAmount);
1017 
1018         token.mint(beneficiary, tokens);
1019         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1020 
1021         forwardFunds();
1022     }
1023 
1024     function getBonusRate(uint256 weiAmount) internal returns (uint256) {
1025         uint256 bonusRate = rate;
1026 
1027         
1028 
1029         
1030         // apply amount
1031         uint[2] memory weiAmountBoundaries = [uint(5000000000000000000000),uint(10000000000000000000)];
1032         uint[2] memory weiAmountRates = [uint(0),uint(150)];
1033 
1034         for (uint j = 0; j < 2; j++) {
1035             if (weiAmount >= weiAmountBoundaries[j]) {
1036                 bonusRate += bonusRate * weiAmountRates[j] / 1000;
1037                 break;
1038             }
1039         }
1040         
1041 
1042         return bonusRate;
1043     }
1044 }
1045 
1046 
1047 
1048 contract TemplateCrowdsale is usingConsts, MainCrowdsale
1049     
1050     , BonusableCrowdsale
1051     
1052     
1053     , RefundableCrowdsale
1054     
1055     , CappedCrowdsale
1056     
1057     , Checkable
1058     
1059 {
1060     event Initialized();
1061     bool public initialized = false;
1062 
1063     function TemplateCrowdsale(MintableToken _token)
1064         Crowdsale(START_TIME > now ? START_TIME : now, 1526162400, 3000 * TOKEN_DECIMAL_MULTIPLIER, TARGET_USER)
1065         CappedCrowdsale(5000000000000000000000)
1066         
1067         RefundableCrowdsale(1000000000000000000000)
1068         
1069     {
1070         token = _token;
1071     }
1072 
1073     function init() public onlyOwner {
1074         require(!initialized);
1075         initialized = true;
1076 
1077         
1078         address[1] memory addresses = [address(0x0c24c748ddab4afe06bc44988f5fe6e788c019f3)];
1079         uint[1] memory amounts = [uint(1500000000000000000000000)];
1080         uint64[1] memory freezes = [uint64(0)];
1081 
1082         for (uint i = 0; i < addresses.length; i ++) {
1083             if (freezes[i] == 0) {
1084                 token.mint(addresses[i], amounts[i]);
1085             }
1086             else {
1087                 FreezableMintableToken(token).mintAndFreeze(addresses[i], amounts[i], freezes[i]);
1088             }
1089         }
1090         
1091 
1092         transferOwnership(TARGET_USER);
1093         Initialized();
1094     }
1095 
1096     /**
1097      * @dev override token creation to set token address in constructor.
1098      */
1099     function createTokenContract() internal returns (MintableToken) {
1100         return MintableToken(0);
1101     }
1102 
1103     function finalization() internal {
1104         super.finalization();
1105         
1106     }
1107 
1108     
1109     /**
1110      * @dev Do inner check.
1111      * @return bool true of accident triggered, false otherwise.
1112      */
1113     function internalCheck() internal returns (bool) {
1114         return !isFinalized && hasEnded();
1115     }
1116 
1117     /**
1118      * @dev Do inner action if check was success.
1119      */
1120     function internalAction() internal {
1121         finalization();
1122         Finalized();
1123 
1124         isFinalized = true;
1125     }
1126     
1127 }