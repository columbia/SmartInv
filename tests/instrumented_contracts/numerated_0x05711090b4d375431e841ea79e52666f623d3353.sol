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
767     string constant TOKEN_NAME = "GlobalSpy";
768     string constant TOKEN_SYMBOL = "SPY";
769     bool constant PAUSED = true;
770     address constant TARGET_USER = 0xC46E5282CA98B982B9cd5d7B029a77573b2f8307;
771     uint constant START_TIME = 1521507420;
772     bool constant CONTINUE_MINTING = true;
773 }
774 
775 
776 
777 contract MainToken is usingConsts, FreezableMintableToken, BurnableToken, Pausable {
778     function MainToken() {
779     }
780 
781     function name() constant public returns (string _name) {
782         return TOKEN_NAME;
783     }
784 
785     function symbol() constant public returns (string _symbol) {
786         return TOKEN_SYMBOL;
787     }
788 
789     function decimals() constant public returns (uint8 _decimals) {
790         return TOKEN_DECIMALS_UINT8;
791     }
792 
793     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
794         require(!paused);
795         return super.transferFrom(_from, _to, _value);
796     }
797 
798     function transfer(address _to, uint256 _value) returns (bool _success) {
799         require(!paused);
800         return super.transfer(_to, _value);
801     }
802 }
803 
804 
805 /**
806  * @title CappedCrowdsale
807  * @dev Extension of Crowdsale with a max amount of funds raised
808  */
809 contract CappedCrowdsale is Crowdsale {
810   using SafeMath for uint256;
811 
812   uint256 public cap;
813 
814   function CappedCrowdsale(uint256 _cap) public {
815     require(_cap > 0);
816     cap = _cap;
817   }
818 
819   // overriding Crowdsale#validPurchase to add extra cap logic
820   // @return true if investors can buy at the moment
821   function validPurchase() internal view returns (bool) {
822     bool withinCap = weiRaised.add(msg.value) <= cap;
823     return super.validPurchase() && withinCap;
824   }
825 
826   // overriding Crowdsale#hasEnded to add cap logic
827   // @return true if crowdsale event has ended
828   function hasEnded() public view returns (bool) {
829     bool capReached = weiRaised >= cap;
830     return super.hasEnded() || capReached;
831   }
832 
833 }
834 
835 
836 
837 /**
838  * @title RefundableCrowdsale
839  * @dev Extension of Crowdsale contract that adds a funding goal, and
840  * the possibility of users getting a refund if goal is not met.
841  * Uses a RefundVault as the crowdsale's vault.
842  */
843 contract RefundableCrowdsale is FinalizableCrowdsale {
844   using SafeMath for uint256;
845 
846   // minimum amount of funds to be raised in weis
847   uint256 public goal;
848 
849   // refund vault used to hold funds while crowdsale is running
850   RefundVault public vault;
851 
852   function RefundableCrowdsale(uint256 _goal) public {
853     require(_goal > 0);
854     vault = new RefundVault(wallet);
855     goal = _goal;
856   }
857 
858   // We're overriding the fund forwarding from Crowdsale.
859   // In addition to sending the funds, we want to call
860   // the RefundVault deposit function
861   function forwardFunds() internal {
862     vault.deposit.value(msg.value)(msg.sender);
863   }
864 
865   // if crowdsale is unsuccessful, investors can claim refunds here
866   function claimRefund() public {
867     require(isFinalized);
868     require(!goalReached());
869 
870     vault.refund(msg.sender);
871   }
872 
873   // vault finalization task, called when owner calls finalize()
874   function finalization() internal {
875     if (goalReached()) {
876       vault.close();
877     } else {
878       vault.enableRefunds();
879     }
880 
881     super.finalization();
882   }
883 
884   function goalReached() public view returns (bool) {
885     return weiRaised >= goal;
886   }
887 
888 }
889 
890 
891 contract MainCrowdsale is usingConsts, FinalizableCrowdsale {
892     function hasStarted() public constant returns (bool) {
893         return now >= startTime;
894     }
895 
896     function finalization() internal {
897         super.finalization();
898 
899         if (PAUSED) {
900             MainToken(token).unpause();
901         }
902 
903         if (!CONTINUE_MINTING) {
904             token.finishMinting();
905         }
906 
907         token.transferOwnership(TARGET_USER);
908     }
909 
910     function buyTokens(address beneficiary) public payable {
911         require(beneficiary != address(0));
912         require(validPurchase());
913 
914         uint256 weiAmount = msg.value;
915 
916         // calculate token amount to be created
917         uint256 tokens = weiAmount.mul(rate).div(1 ether);
918 
919         // update state
920         weiRaised = weiRaised.add(weiAmount);
921 
922         token.mint(beneficiary, tokens);
923         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
924 
925         forwardFunds();
926     }
927 }
928 
929 
930 contract Checkable {
931     address private serviceAccount;
932     /**
933      * Flag means that contract accident already occurs.
934      */
935     bool private triggered = false;
936 
937     // Occurs when accident happened.
938     event Triggered(uint balance);
939 
940     function Checkable() public {
941         serviceAccount = msg.sender;
942     }
943 
944     /**
945      * @dev Replace service account with new one.
946      * @param _account Valid service account address.
947      */
948     function changeServiceAccount(address _account) onlyService public {
949         assert(_account != 0);
950         serviceAccount = _account;
951     }
952 
953     /**
954      * @dev Is caller (sender) service account.
955      */
956     function isServiceAccount() constant public returns (bool) {
957         return msg.sender == serviceAccount;
958     }
959 
960     /**
961      * Public check method.
962      */
963     function check() onlyService notTriggered payable public {
964         if (internalCheck()) {
965             Triggered(this.balance);
966             triggered = true;
967             internalAction();
968         }
969     }
970 
971     /**
972      * @dev Do inner check.
973      * @return bool true of accident triggered, false otherwise.
974      */
975     function internalCheck() internal returns (bool);
976 
977     /**
978      * @dev Do inner action if check was success.
979      */
980     function internalAction() internal;
981 
982     modifier onlyService {
983         require(msg.sender == serviceAccount);
984         _;
985     }
986 
987     modifier notTriggered() {
988         require(!triggered);
989         _;
990     }
991 }
992 
993 
994 contract BonusableCrowdsale is usingConsts, Crowdsale {
995 
996     function buyTokens(address beneficiary) public payable {
997         require(beneficiary != address(0));
998         require(validPurchase());
999 
1000         uint256 weiAmount = msg.value;
1001 
1002         // calculate token amount to be created
1003         uint256 bonusRate = getBonusRate(weiAmount);
1004         uint256 tokens = weiAmount.mul(bonusRate).div(1 ether);
1005 
1006         // update state
1007         weiRaised = weiRaised.add(weiAmount);
1008 
1009         token.mint(beneficiary, tokens);
1010         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1011 
1012         forwardFunds();
1013     }
1014 
1015     function getBonusRate(uint256 weiAmount) internal returns (uint256) {
1016         uint256 bonusRate = rate;
1017 
1018         
1019         // apply bonus for time & weiRaised
1020         uint[2] memory weiRaisedStartsBoundaries = [uint(0),uint(0)];
1021         uint[2] memory weiRaisedEndsBoundaries = [uint(30000000000000000000000),uint(30000000000000000000000)];
1022         uint64[2] memory timeStartsBoundaries = [uint64(1521507420),uint64(1521702000)];
1023         uint64[2] memory timeEndsBoundaries = [uint64(1521702000),uint64(1522303200)];
1024         uint[2] memory weiRaisedAndTimeRates = [uint(200),uint(100)];
1025 
1026         for (uint i = 0; i < 2; i++) {
1027             bool weiRaisedInBound = (weiRaisedStartsBoundaries[i] <= weiRaised) && (weiRaised < weiRaisedEndsBoundaries[i]);
1028             bool timeInBound = (timeStartsBoundaries[i] <= now) && (now < timeEndsBoundaries[i]);
1029             if (weiRaisedInBound && timeInBound) {
1030                 bonusRate += bonusRate * weiRaisedAndTimeRates[i] / 1000;
1031             }
1032         }
1033         
1034 
1035         
1036         // apply amount
1037         uint[4] memory weiAmountBoundaries = [uint(10000000000000000000),uint(5000000000000000000),uint(5000000000000000000),uint(1000000000000000000)];
1038         uint[4] memory weiAmountRates = [uint(200),uint(100),uint(0),uint(50)];
1039 
1040         for (uint j = 0; j < 4; j++) {
1041             if (weiAmount >= weiAmountBoundaries[j]) {
1042                 bonusRate += bonusRate * weiAmountRates[j] / 1000;
1043                 break;
1044             }
1045         }
1046         
1047 
1048         return bonusRate;
1049     }
1050 }
1051 
1052 
1053 
1054 contract TemplateCrowdsale is usingConsts, MainCrowdsale
1055     
1056     , BonusableCrowdsale
1057     
1058     
1059     , RefundableCrowdsale
1060     
1061     , CappedCrowdsale
1062     
1063 {
1064     event Initialized();
1065     bool public initialized = false;
1066 
1067     function TemplateCrowdsale(MintableToken _token)
1068         Crowdsale(START_TIME > now ? START_TIME : now, 1526364000, 5000 * TOKEN_DECIMAL_MULTIPLIER, 0xC46E5282CA98B982B9cd5d7B029a77573b2f8307)
1069         CappedCrowdsale(30000000000000000000000)
1070         
1071         RefundableCrowdsale(1000000000000000000000)
1072         
1073     {
1074         token = _token;
1075     }
1076 
1077     function init() public onlyOwner {
1078         require(!initialized);
1079         initialized = true;
1080 
1081         if (PAUSED) {
1082             MainToken(token).pause();
1083         }
1084 
1085         
1086         address[1] memory addresses = [address(0xc46e5282ca98b982b9cd5d7b029a77573b2f8307)];
1087         uint[1] memory amounts = [uint(20000000000000000000000000)];
1088         uint64[1] memory freezes = [uint64(0)];
1089 
1090         for (uint i = 0; i < addresses.length; i ++) {
1091             if (freezes[i] == 0) {
1092                 token.mint(addresses[i], amounts[i]);
1093             }
1094             else {
1095                 FreezableMintableToken(token).mintAndFreeze(addresses[i], amounts[i], freezes[i]);
1096             }
1097         }
1098         
1099 
1100         transferOwnership(TARGET_USER);
1101         Initialized();
1102     }
1103 
1104     /**
1105      * @dev override token creation to set token address in constructor.
1106      */
1107     function createTokenContract() internal returns (MintableToken) {
1108         return MintableToken(0);
1109     }
1110 
1111     
1112 }