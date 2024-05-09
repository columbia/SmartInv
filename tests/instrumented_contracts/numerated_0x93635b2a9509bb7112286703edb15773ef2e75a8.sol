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
549         Transfer(msg.sender, _to, _amount);
550         Freezed(_to, _until, _amount);
551     }
552 
553     /**
554      * @dev release first available freezing tokens.
555      */
556     function releaseOnce() public {
557         bytes32 headKey = toKey(msg.sender, 0);
558         uint64 head = chains[headKey];
559         require(head != 0);
560         require(uint64(block.timestamp) > head);
561         bytes32 currentKey = toKey(msg.sender, head);
562 
563         uint64 next = chains[currentKey];
564 
565         uint amount = freezings[currentKey];
566         delete freezings[currentKey];
567 
568         balances[msg.sender] = balances[msg.sender].add(amount);
569         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
570 
571         if (next == 0) {
572             delete chains[headKey];
573         }
574         else {
575             chains[headKey] = next;
576             delete chains[currentKey];
577         }
578         Released(msg.sender, amount);
579     }
580 
581     /**
582      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
583      * @return how many tokens was released
584      */
585     function releaseAll() public returns (uint tokens) {
586         uint release;
587         uint balance;
588         (release, balance) = getFreezing(msg.sender, 0);
589         while (release != 0 && block.timestamp > release) {
590             releaseOnce();
591             tokens += balance;
592             (release, balance) = getFreezing(msg.sender, 0);
593         }
594     }
595 
596     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
597         // WISH masc to increase entropy
598         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
599         assembly {
600             result := or(result, mul(_addr, 0x10000000000000000))
601             result := or(result, _release)
602         }
603     }
604 
605     function freeze(address _to, uint64 _until) internal {
606         require(_until > block.timestamp);
607         bytes32 key = toKey(_to, _until);
608         bytes32 parentKey = toKey(_to, uint64(0));
609         uint64 next = chains[parentKey];
610 
611         if (next == 0) {
612             chains[parentKey] = _until;
613             return;
614         }
615 
616         bytes32 nextKey = toKey(_to, next);
617         uint parent;
618 
619         while (next != 0 && _until > next) {
620             parent = next;
621             parentKey = nextKey;
622 
623             next = chains[nextKey];
624             nextKey = toKey(_to, next);
625         }
626 
627         if (_until == next) {
628             return;
629         }
630 
631         if (next != 0) {
632             chains[key] = next;
633         }
634 
635         chains[parentKey] = _until;
636     }
637 }
638 
639 /**
640 * @title Contract that will work with ERC223 tokens.
641 */
642 
643 contract ERC223Receiver {
644     /**
645      * @dev Standard ERC223 function that will handle incoming token transfers.
646      *
647      * @param _from  Token sender address.
648      * @param _value Amount of tokens.
649      * @param _data  Transaction metadata.
650      */
651     function tokenFallback(address _from, uint _value, bytes _data) public;
652 }
653 
654 contract ERC223Basic is ERC20Basic {
655     function transfer(address to, uint value, bytes data) public returns (bool);
656     event Transfer(address indexed from, address indexed to, uint value, bytes data);
657 }
658 
659 
660 contract SuccessfulERC223Receiver is ERC223Receiver {
661     event Invoked(address from, uint value, bytes data);
662 
663     function tokenFallback(address _from, uint _value, bytes _data) public {
664         Invoked(_from, _value, _data);
665     }
666 }
667 
668 contract FailingERC223Receiver is ERC223Receiver {
669     function tokenFallback(address, uint, bytes) public {
670         revert();
671     }
672 }
673 
674 contract ERC223ReceiverWithoutTokenFallback {
675 }
676 
677 /**
678  * @title Burnable Token
679  * @dev Token that can be irreversibly burned (destroyed).
680  */
681 contract BurnableToken is StandardToken {
682 
683     event Burn(address indexed burner, uint256 value);
684 
685     /**
686      * @dev Burns a specific amount of tokens.
687      * @param _value The amount of token to be burned.
688      */
689     function burn(uint256 _value) public {
690         require(_value > 0);
691         require(_value <= balances[msg.sender]);
692         // no need to require value <= totalSupply, since that would imply the
693         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
694 
695         address burner = msg.sender;
696         balances[burner] = balances[burner].sub(_value);
697         totalSupply = totalSupply.sub(_value);
698         Burn(burner, _value);
699     }
700 }
701 
702 
703 
704 /**
705  * @title Pausable
706  * @dev Base contract which allows children to implement an emergency stop mechanism.
707  */
708 contract Pausable is Ownable {
709   event Pause();
710   event Unpause();
711 
712   bool public paused = false;
713 
714 
715   /**
716    * @dev Modifier to make a function callable only when the contract is not paused.
717    */
718   modifier whenNotPaused() {
719     require(!paused);
720     _;
721   }
722 
723   /**
724    * @dev Modifier to make a function callable only when the contract is paused.
725    */
726   modifier whenPaused() {
727     require(paused);
728     _;
729   }
730 
731   /**
732    * @dev called by the owner to pause, triggers stopped state
733    */
734   function pause() onlyOwner whenNotPaused public {
735     paused = true;
736     Pause();
737   }
738 
739   /**
740    * @dev called by the owner to unpause, returns to normal state
741    */
742   function unpause() onlyOwner whenPaused public {
743     paused = false;
744     Unpause();
745   }
746 }
747 
748 
749 
750 contract FreezableMintableToken is FreezableToken, MintableToken {
751     /**
752      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
753      *      Be careful, gas usage is not deterministic,
754      *      and depends on how many freezes _to address already has.
755      * @param _to Address to which token will be freeze.
756      * @param _amount Amount of token to mint and freeze.
757      * @param _until Release date, must be in future.
758      * @return A boolean that indicates if the operation was successful.
759      */
760     function mintAndFreeze(address _to, uint _amount, uint64 _until) onlyOwner canMint public returns (bool) {
761         totalSupply = totalSupply.add(_amount);
762 
763         bytes32 currentKey = toKey(_to, _until);
764         freezings[currentKey] = freezings[currentKey].add(_amount);
765         freezingBalance[_to] = freezingBalance[_to].add(_amount);
766 
767         freeze(_to, _until);
768         Mint(_to, _amount);
769         Freezed(_to, _until, _amount);
770         Transfer(msg.sender, _to, _amount);
771         return true;
772     }
773 }
774 
775 contract Consts {
776     uint constant TOKEN_DECIMALS = 18;
777     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
778     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
779 
780     string constant TOKEN_NAME = "ArgusNodeToken";
781     string constant TOKEN_SYMBOL = "ArNT";
782     bool constant PAUSED = false;
783     address constant TARGET_USER = 0x504FB379a29654A604FDe7B95972C74BFE07C118;
784     
785     uint constant START_TIME = 1527818400;
786     
787     bool constant CONTINUE_MINTING = false;
788 }
789 
790 
791 
792 
793 /**
794  * @title Reference implementation of the ERC223 standard token.
795  */
796 contract ERC223Token is ERC223Basic, BasicToken, FailingERC223Receiver {
797     using SafeMath for uint;
798 
799     /**
800      * @dev Transfer the specified amount of tokens to the specified address.
801      *      Invokes the `tokenFallback` function if the recipient is a contract.
802      *      The token transfer fails if the recipient is a contract
803      *      but does not implement the `tokenFallback` function
804      *      or the fallback function to receive funds.
805      *
806      * @param _to    Receiver address.
807      * @param _value Amount of tokens that will be transferred.
808      * @param _data  Transaction metadata.
809      */
810     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
811         // Standard function transfer similar to ERC20 transfer with no _data .
812         // Added due to backwards compatibility reasons .
813         uint codeLength;
814 
815         assembly {
816             // Retrieve the size of the code on target address, this needs assembly.
817             codeLength := extcodesize(_to)
818         }
819 
820         balances[msg.sender] = balances[msg.sender].sub(_value);
821         balances[_to] = balances[_to].add(_value);
822         if(codeLength > 0) {
823             ERC223Receiver receiver = ERC223Receiver(_to);
824             receiver.tokenFallback(msg.sender, _value, _data);
825         }
826         Transfer(msg.sender, _to, _value, _data);
827         return true;
828     }
829 
830     /**
831      * @dev Transfer the specified amount of tokens to the specified address.
832      *      This function works the same with the previous one
833      *      but doesn't contain `_data` param.
834      *      Added due to backwards compatibility reasons.
835      *
836      * @param _to    Receiver address.
837      * @param _value Amount of tokens that will be transferred.
838      */
839     function transfer(address _to, uint256 _value) public returns (bool) {
840         bytes memory empty;
841         return transfer(_to, _value, empty);
842     }
843 }
844 
845 
846 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
847     
848 {
849     
850 
851     function name() pure public returns (string _name) {
852         return TOKEN_NAME;
853     }
854 
855     function symbol() pure public returns (string _symbol) {
856         return TOKEN_SYMBOL;
857     }
858 
859     function decimals() pure public returns (uint8 _decimals) {
860         return TOKEN_DECIMALS_UINT8;
861     }
862 
863     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
864         require(!paused);
865         return super.transferFrom(_from, _to, _value);
866     }
867 
868     function transfer(address _to, uint256 _value) public returns (bool _success) {
869         require(!paused);
870         return super.transfer(_to, _value);
871     }
872 }
873 
874 
875 
876 
877 /**
878  * @title CappedCrowdsale
879  * @dev Extension of Crowdsale with a max amount of funds raised
880  */
881 contract CappedCrowdsale is Crowdsale {
882   using SafeMath for uint256;
883 
884   uint256 public cap;
885 
886   function CappedCrowdsale(uint256 _cap) public {
887     require(_cap > 0);
888     cap = _cap;
889   }
890 
891   // overriding Crowdsale#validPurchase to add extra cap logic
892   // @return true if investors can buy at the moment
893   function validPurchase() internal view returns (bool) {
894     bool withinCap = weiRaised.add(msg.value) <= cap;
895     return super.validPurchase() && withinCap;
896   }
897 
898   // overriding Crowdsale#hasEnded to add cap logic
899   // @return true if crowdsale event has ended
900   function hasEnded() public view returns (bool) {
901     bool capReached = weiRaised >= cap;
902     return super.hasEnded() || capReached;
903   }
904 
905 }
906 
907 
908 
909 /**
910  * @title RefundableCrowdsale
911  * @dev Extension of Crowdsale contract that adds a funding goal, and
912  * the possibility of users getting a refund if goal is not met.
913  * Uses a RefundVault as the crowdsale's vault.
914  */
915 contract RefundableCrowdsale is FinalizableCrowdsale {
916   using SafeMath for uint256;
917 
918   // minimum amount of funds to be raised in weis
919   uint256 public goal;
920 
921   // refund vault used to hold funds while crowdsale is running
922   RefundVault public vault;
923 
924   function RefundableCrowdsale(uint256 _goal) public {
925     require(_goal > 0);
926     vault = new RefundVault(wallet);
927     goal = _goal;
928   }
929 
930   // We're overriding the fund forwarding from Crowdsale.
931   // In addition to sending the funds, we want to call
932   // the RefundVault deposit function
933   function forwardFunds() internal {
934     vault.deposit.value(msg.value)(msg.sender);
935   }
936 
937   // if crowdsale is unsuccessful, investors can claim refunds here
938   function claimRefund() public {
939     require(isFinalized);
940     require(!goalReached());
941 
942     vault.refund(msg.sender);
943   }
944 
945   // vault finalization task, called when owner calls finalize()
946   function finalization() internal {
947     if (goalReached()) {
948       vault.close();
949     } else {
950       vault.enableRefunds();
951     }
952 
953     super.finalization();
954   }
955 
956   function goalReached() public view returns (bool) {
957     return weiRaised >= goal;
958   }
959 
960 }
961 
962 
963 contract MainCrowdsale is Consts, FinalizableCrowdsale {
964     function hasStarted() public constant returns (bool) {
965         return now >= startTime;
966     }
967 
968     function finalization() internal {
969         super.finalization();
970 
971         if (PAUSED) {
972             MainToken(token).unpause();
973         }
974 
975         if (!CONTINUE_MINTING) {
976             token.finishMinting();
977         }
978 
979         token.transferOwnership(TARGET_USER);
980     }
981 
982     function buyTokens(address beneficiary) public payable {
983         require(beneficiary != address(0));
984         require(validPurchase());
985 
986         uint256 weiAmount = msg.value;
987 
988         // calculate token amount to be created
989         uint256 tokens = weiAmount.mul(rate).div(1 ether);
990 
991         // update state
992         weiRaised = weiRaised.add(weiAmount);
993 
994         token.mint(beneficiary, tokens);
995         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
996 
997         forwardFunds();
998     }
999 }
1000 
1001 
1002 contract Checkable {
1003     address private serviceAccount;
1004     /**
1005      * Flag means that contract accident already occurs.
1006      */
1007     bool private triggered = false;
1008 
1009     /**
1010      * Occurs when accident happened.
1011      */
1012     event Triggered(uint balance);
1013     /**
1014      * Occurs when check finished.
1015      */
1016     event Checked(bool isAccident);
1017 
1018     function Checkable() public {
1019         serviceAccount = msg.sender;
1020     }
1021 
1022     /**
1023      * @dev Replace service account with new one.
1024      * @param _account Valid service account address.
1025      */
1026     function changeServiceAccount(address _account) onlyService public {
1027         assert(_account != 0);
1028         serviceAccount = _account;
1029     }
1030 
1031     /**
1032      * @dev Is caller (sender) service account.
1033      */
1034     function isServiceAccount() view public returns (bool) {
1035         return msg.sender == serviceAccount;
1036     }
1037 
1038     /**
1039      * Public check method.
1040      */
1041     function check() onlyService notTriggered payable public {
1042         if (internalCheck()) {
1043             Triggered(this.balance);
1044             triggered = true;
1045             internalAction();
1046         }
1047     }
1048 
1049     /**
1050      * @dev Do inner check.
1051      * @return bool true of accident triggered, false otherwise.
1052      */
1053     function internalCheck() internal returns (bool);
1054 
1055     /**
1056      * @dev Do inner action if check was success.
1057      */
1058     function internalAction() internal;
1059 
1060     modifier onlyService {
1061         require(msg.sender == serviceAccount);
1062         _;
1063     }
1064 
1065     modifier notTriggered() {
1066         require(!triggered);
1067         _;
1068     }
1069 }
1070 
1071 
1072 contract BonusableCrowdsale is Consts, Crowdsale {
1073 
1074     function buyTokens(address beneficiary) public payable {
1075         require(beneficiary != address(0));
1076         require(validPurchase());
1077 
1078         uint256 weiAmount = msg.value;
1079 
1080         // calculate token amount to be created
1081         uint256 bonusRate = getBonusRate(weiAmount);
1082         uint256 tokens = weiAmount.mul(bonusRate).div(1 ether);
1083 
1084         // update state
1085         weiRaised = weiRaised.add(weiAmount);
1086 
1087         token.mint(beneficiary, tokens);
1088         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1089 
1090         forwardFunds();
1091     }
1092 
1093     function getBonusRate(uint256 weiAmount) internal view returns (uint256) {
1094         uint256 bonusRate = rate;
1095 
1096         
1097         // apply bonus for time & weiRaised
1098         uint[3] memory weiRaisedStartsBoundaries = [uint(0),uint(100000000000000000000),uint(250000000000000000000)];
1099         uint[3] memory weiRaisedEndsBoundaries = [uint(100000000000000000000),uint(250000000000000000000),uint(450000000000000000000)];
1100         uint64[3] memory timeStartsBoundaries = [uint64(1527818400),uint64(1527818400),uint64(1527818400)];
1101         uint64[3] memory timeEndsBoundaries = [uint64(1536544795),uint64(1536544795),uint64(1536544795)];
1102         uint[3] memory weiRaisedAndTimeRates = [uint(150),uint(100),uint(50)];
1103 
1104         for (uint i = 0; i < 3; i++) {
1105             bool weiRaisedInBound = (weiRaisedStartsBoundaries[i] <= weiRaised) && (weiRaised < weiRaisedEndsBoundaries[i]);
1106             bool timeInBound = (timeStartsBoundaries[i] <= now) && (now < timeEndsBoundaries[i]);
1107             if (weiRaisedInBound && timeInBound) {
1108                 bonusRate += bonusRate * weiRaisedAndTimeRates[i] / 1000;
1109             }
1110         }
1111         
1112 
1113         
1114 
1115         return bonusRate;
1116     }
1117 }
1118 
1119 
1120 
1121 contract TemplateCrowdsale is Consts, MainCrowdsale
1122     
1123     , BonusableCrowdsale
1124     
1125     
1126     , CappedCrowdsale
1127     
1128     , Checkable
1129     
1130 {
1131     event Initialized();
1132     bool public initialized = false;
1133 
1134     function TemplateCrowdsale(MintableToken _token) public
1135         Crowdsale(START_TIME > now ? START_TIME : now, 1536544800, 1000 * TOKEN_DECIMAL_MULTIPLIER, 0x504FB379a29654A604FDe7B95972C74BFE07C118)
1136         CappedCrowdsale(740000000000000000000)
1137         
1138     {
1139         token = _token;
1140     }
1141 
1142     function init() public onlyOwner {
1143         require(!initialized);
1144         initialized = true;
1145 
1146         if (PAUSED) {
1147             MainToken(token).pause();
1148         }
1149 
1150         
1151         address[1] memory addresses = [address(0x504fb379a29654a604fde7b95972c74bfe07c118)];
1152         uint[1] memory amounts = [uint(460000000000000000000000)];
1153         uint64[1] memory freezes = [uint64(0)];
1154 
1155         for (uint i = 0; i < addresses.length; i++) {
1156             if (freezes[i] == 0) {
1157                 MainToken(token).mint(addresses[i], amounts[i]);
1158             } else {
1159                 MainToken(token).mintAndFreeze(addresses[i], amounts[i], freezes[i]);
1160             }
1161         }
1162         
1163 
1164         transferOwnership(TARGET_USER);
1165 
1166         Initialized();
1167     }
1168 
1169     /**
1170      * @dev override token creation to set token address in constructor.
1171      */
1172     function createTokenContract() internal returns (MintableToken) {
1173         return MintableToken(0);
1174     }
1175 
1176     
1177     /**
1178      * @dev Do inner check.
1179      * @return bool true of accident triggered, false otherwise.
1180      */
1181     function internalCheck() internal returns (bool) {
1182         bool result = !isFinalized && hasEnded();
1183         Checked(result);
1184         return result;
1185     }
1186 
1187     /**
1188      * @dev Do inner action if check was success.
1189      */
1190     function internalAction() internal {
1191         finalization();
1192         Finalized();
1193 
1194         isFinalized = true;
1195     }
1196     
1197 
1198     
1199 
1200     
1201 
1202 }