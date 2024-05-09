1 pragma solidity ^0.4.0;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 
129 /**
130  * @title ERC20Basic
131  * @dev Simpler version of ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/179
133  */
134 contract ERC20Basic {
135   uint256 public totalSupply;
136   function balanceOf(address who) public view returns (uint256);
137   function transfer(address to, uint256 value) public returns (bool);
138   event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 
141 
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20 is ERC20Basic {
148   function allowance(address owner, address spender) public view returns (uint256);
149   function transferFrom(address from, address to, uint256 value) public returns (bool);
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 
155 
156 
157 /**
158  * @title Basic token
159  * @dev Basic version of StandardToken, with no allowances.
160  */
161 contract BasicToken is ERC20Basic {
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) balances;
165 
166   /**
167   * @dev transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[msg.sender]);
174 
175     // SafeMath.sub will throw if there is not enough balance.
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256 balance) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 
194 /**
195  * @title SafeERC20
196  * @dev Wrappers around ERC20 operations that throw on failure.
197  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
198  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
199  */
200 library SafeERC20 {
201   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
202     assert(token.transfer(to, value));
203   }
204 
205   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
206     assert(token.transferFrom(from, to, value));
207   }
208 
209   function safeApprove(ERC20 token, address spender, uint256 value) internal {
210     assert(token.approve(spender, value));
211   }
212 }
213 
214 
215 contract Checkable {
216     address private serviceAccount;
217     /**
218      * Flag means that contract accident already occurs.
219      */
220     bool private triggered = false;
221 
222     // Occurs when accident happened.
223     event Triggered(uint balance);
224 
225     function Checkable() public {
226         serviceAccount = msg.sender;
227     }
228 
229     /**
230      * @dev Replace service account with new one.
231      * @param _account Valid service account address.
232      */
233     function changeServiceAccount(address _account) onlyService public {
234         assert(_account != 0);
235         serviceAccount = _account;
236     }
237 
238     /**
239      * @dev Is caller (sender) service account.
240      */
241     function isServiceAccount() constant public returns (bool) {
242         return msg.sender == serviceAccount;
243     }
244 
245     /**
246      * Public check method.
247      */
248     function check() onlyService notTriggered payable public {
249         if (internalCheck()) {
250             Triggered(this.balance);
251             triggered = true;
252             internalAction();
253         }
254     }
255 
256     /**
257      * @dev Do inner check.
258      * @return bool true of accident triggered, false otherwise.
259      */
260     function internalCheck() internal returns (bool);
261 
262     /**
263      * @dev Do inner action if check was success.
264      */
265     function internalAction() internal;
266 
267     modifier onlyService {
268         require(msg.sender == serviceAccount);
269         _;
270     }
271 
272     modifier notTriggered() {
273         require(!triggered);
274         _;
275     }
276 }
277 
278 
279 
280 /**
281  * @title Standard ERC20 token
282  *
283  * @dev Implementation of the basic standard token.
284  * @dev https://github.com/ethereum/EIPs/issues/20
285  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
286  */
287 contract StandardToken is ERC20, BasicToken {
288 
289   mapping (address => mapping (address => uint256)) internal allowed;
290 
291 
292   /**
293    * @dev Transfer tokens from one address to another
294    * @param _from address The address which you want to send tokens from
295    * @param _to address The address which you want to transfer to
296    * @param _value uint256 the amount of tokens to be transferred
297    */
298   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
299     require(_to != address(0));
300     require(_value <= balances[_from]);
301     require(_value <= allowed[_from][msg.sender]);
302 
303     balances[_from] = balances[_from].sub(_value);
304     balances[_to] = balances[_to].add(_value);
305     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
306     Transfer(_from, _to, _value);
307     return true;
308   }
309 
310   /**
311    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
312    *
313    * Beware that changing an allowance with this method brings the risk that someone may use both the old
314    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
315    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
316    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
317    * @param _spender The address which will spend the funds.
318    * @param _value The amount of tokens to be spent.
319    */
320   function approve(address _spender, uint256 _value) public returns (bool) {
321     allowed[msg.sender][_spender] = _value;
322     Approval(msg.sender, _spender, _value);
323     return true;
324   }
325 
326   /**
327    * @dev Function to check the amount of tokens that an owner allowed to a spender.
328    * @param _owner address The address which owns the funds.
329    * @param _spender address The address which will spend the funds.
330    * @return A uint256 specifying the amount of tokens still available for the spender.
331    */
332   function allowance(address _owner, address _spender) public view returns (uint256) {
333     return allowed[_owner][_spender];
334   }
335 
336   /**
337    * approve should be called when allowed[_spender] == 0. To increment
338    * allowed value is better to use this function to avoid 2 calls (and wait until
339    * the first transaction is mined)
340    * From MonolithDAO Token.sol
341    */
342   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
343     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
344     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
345     return true;
346   }
347 
348   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
349     uint oldValue = allowed[msg.sender][_spender];
350     if (_subtractedValue > oldValue) {
351       allowed[msg.sender][_spender] = 0;
352     } else {
353       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
354     }
355     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
356     return true;
357   }
358 
359 }
360 
361 
362 
363 
364 /**
365  * @title Mintable token
366  * @dev Simple ERC20 Token example, with mintable token creation
367  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
368  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
369  */
370 
371 contract MintableToken is StandardToken, Ownable {
372   event Mint(address indexed to, uint256 amount);
373   event MintFinished();
374 
375   bool public mintingFinished = false;
376 
377 
378   modifier canMint() {
379     require(!mintingFinished);
380     _;
381   }
382 
383   /**
384    * @dev Function to mint tokens
385    * @param _to The address that will receive the minted tokens.
386    * @param _amount The amount of tokens to mint.
387    * @return A boolean that indicates if the operation was successful.
388    */
389   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
390     totalSupply = totalSupply.add(_amount);
391     balances[_to] = balances[_to].add(_amount);
392     Mint(_to, _amount);
393     Transfer(address(0), _to, _amount);
394     return true;
395   }
396 
397   /**
398    * @dev Function to stop minting new tokens.
399    * @return True if the operation was successful.
400    */
401   function finishMinting() onlyOwner canMint public returns (bool) {
402     mintingFinished = true;
403     MintFinished();
404     return true;
405   }
406 }
407 
408 
409 
410 /**
411  * @title Burnable Token
412  * @dev Token that can be irreversibly burned (destroyed).
413  */
414 contract BurnableToken is StandardToken {
415 
416     event Burn(address indexed burner, uint256 value);
417 
418     /**
419      * @dev Burns a specific amount of tokens.
420      * @param _value The amount of token to be burned.
421      */
422     function burn(uint256 _value) public {
423         require(_value > 0);
424         require(_value <= balances[msg.sender]);
425         // no need to require value <= totalSupply, since that would imply the
426         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
427 
428         address burner = msg.sender;
429         balances[burner] = balances[burner].sub(_value);
430         totalSupply = totalSupply.sub(_value);
431         Burn(burner, _value);
432     }
433 }
434 
435 
436 
437 
438 /**
439  * @title TokenTimelock
440  * @dev TokenTimelock is a token holder contract that will allow a
441  * beneficiary to extract the tokens after a given release time
442  */
443 contract TokenTimelock {
444   using SafeERC20 for ERC20Basic;
445 
446   // ERC20 basic token contract being held
447   ERC20Basic public token;
448 
449   // beneficiary of tokens after they are released
450   address public beneficiary;
451 
452   // timestamp when token release is enabled
453   uint64 public releaseTime;
454 
455   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
456     require(_releaseTime > now);
457     token = _token;
458     beneficiary = _beneficiary;
459     releaseTime = _releaseTime;
460   }
461 
462   /**
463    * @notice Transfers tokens held by timelock to beneficiary.
464    */
465   function release() public {
466     require(now >= releaseTime);
467 
468     uint256 amount = token.balanceOf(this);
469     require(amount > 0);
470 
471     token.safeTransfer(beneficiary, amount);
472   }
473 }
474 
475 
476 contract usingConsts {
477     uint constant TOKEN_DECIMALS = 18;
478     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
479     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
480 
481     string constant TOKEN_NAME = "Cronos";
482     string constant TOKEN_SYMBOL = "CRS";
483     bool constant PAUSED = true;
484     address constant TARGET_USER = 0x216C619CB44BeEe746DC781740C215Bce23fA892;
485     uint constant START_TIME = 1518697500;
486     bool constant CONTINUE_MINTING = false;
487 }
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
632 
633 
634 
635 
636 
637 
638 contract FreezableMintableToken is FreezableToken, MintableToken {
639     /**
640      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
641      *      Be careful, gas usage is not deterministic,
642      *      and depends on how many freezes _to address already has.
643      * @param _to Address to which token will be freeze.
644      * @param _amount Amount of token to mint and freeze.
645      * @param _until Release date, must be in future.
646      */
647     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner {
648         bytes32 currentKey = toKey(_to, _until);
649         mint(address(keccak256(currentKey)), _amount);
650 
651         freeze(_to, _until);
652         Freezed(_to, _until, _amount);
653     }
654 }
655 
656 
657 
658 /**
659  * @title Crowdsale
660  * @dev Crowdsale is a base contract for managing a token crowdsale.
661  * Crowdsales have a start and end timestamps, where investors can make
662  * token purchases and the crowdsale will assign them tokens based
663  * on a token per ETH rate. Funds collected are forwarded to a wallet
664  * as they arrive.
665  */
666 contract Crowdsale {
667   using SafeMath for uint256;
668 
669   // The token being sold
670   MintableToken public token;
671 
672   // start and end timestamps where investments are allowed (both inclusive)
673   uint256 public startTime;
674   uint256 public endTime;
675 
676   // address where funds are collected
677   address public wallet;
678 
679   // how many token units a buyer gets per wei
680   uint256 public rate;
681 
682   // amount of raised money in wei
683   uint256 public weiRaised;
684 
685   /**
686    * event for token purchase logging
687    * @param purchaser who paid for the tokens
688    * @param beneficiary who got the tokens
689    * @param value weis paid for purchase
690    * @param amount amount of tokens purchased
691    */
692   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
693 
694 
695   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
696     require(_startTime >= now);
697     require(_endTime >= _startTime);
698     require(_rate > 0);
699     require(_wallet != address(0));
700 
701     token = createTokenContract();
702     startTime = _startTime;
703     endTime = _endTime;
704     rate = _rate;
705     wallet = _wallet;
706   }
707 
708   // creates the token to be sold.
709   // override this method to have crowdsale of a specific mintable token.
710   function createTokenContract() internal returns (MintableToken) {
711     return new MintableToken();
712   }
713 
714 
715   // fallback function can be used to buy tokens
716   function () external payable {
717     buyTokens(msg.sender);
718   }
719 
720   // low level token purchase function
721   function buyTokens(address beneficiary) public payable {
722     require(beneficiary != address(0));
723     require(validPurchase());
724 
725     uint256 weiAmount = msg.value;
726 
727     // calculate token amount to be created
728     uint256 tokens = weiAmount.mul(rate);
729 
730     // update state
731     weiRaised = weiRaised.add(weiAmount);
732 
733     token.mint(beneficiary, tokens);
734     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
735 
736     forwardFunds();
737   }
738 
739   // send ether to the fund collection wallet
740   // override to create custom fund forwarding mechanisms
741   function forwardFunds() internal {
742     wallet.transfer(msg.value);
743   }
744 
745   // @return true if the transaction can buy tokens
746   function validPurchase() internal view returns (bool) {
747     bool withinPeriod = now >= startTime && now <= endTime;
748     bool nonZeroPurchase = msg.value != 0;
749     return withinPeriod && nonZeroPurchase;
750   }
751 
752   // @return true if crowdsale event has ended
753   function hasEnded() public view returns (bool) {
754     return now > endTime;
755   }
756 
757 
758 }
759 
760 
761 
762 /**
763  * @title CappedCrowdsale
764  * @dev Extension of Crowdsale with a max amount of funds raised
765  */
766 contract CappedCrowdsale is Crowdsale {
767   using SafeMath for uint256;
768 
769   uint256 public cap;
770 
771   function CappedCrowdsale(uint256 _cap) public {
772     require(_cap > 0);
773     cap = _cap;
774   }
775 
776   // overriding Crowdsale#validPurchase to add extra cap logic
777   // @return true if investors can buy at the moment
778   function validPurchase() internal view returns (bool) {
779     bool withinCap = weiRaised.add(msg.value) <= cap;
780     return super.validPurchase() && withinCap;
781   }
782 
783   // overriding Crowdsale#hasEnded to add cap logic
784   // @return true if crowdsale event has ended
785   function hasEnded() public view returns (bool) {
786     bool capReached = weiRaised >= cap;
787     return super.hasEnded() || capReached;
788   }
789 
790 }
791 
792 
793 
794 /**
795  * @title FinalizableCrowdsale
796  * @dev Extension of Crowdsale where an owner can do extra work
797  * after finishing.
798  */
799 contract FinalizableCrowdsale is Crowdsale, Ownable {
800   using SafeMath for uint256;
801 
802   bool public isFinalized = false;
803 
804   event Finalized();
805 
806   /**
807    * @dev Must be called after crowdsale ends, to do some extra finalization
808    * work. Calls the contract's finalization function.
809    */
810   function finalize() onlyOwner public {
811     require(!isFinalized);
812     require(hasEnded());
813 
814     finalization();
815     Finalized();
816 
817     isFinalized = true;
818   }
819 
820   /**
821    * @dev Can be overridden to add finalization logic. The overriding function
822    * should call super.finalization() to ensure the chain of finalization is
823    * executed entirely.
824    */
825   function finalization() internal {
826   }
827 }
828 
829 
830 /**
831  * @title RefundVault
832  * @dev This contract is used for storing funds while a crowdsale
833  * is in progress. Supports refunding the money if crowdsale fails,
834  * and forwarding it if crowdsale is successful.
835  */
836 contract RefundVault is Ownable {
837   using SafeMath for uint256;
838 
839   enum State { Active, Refunding, Closed }
840 
841   mapping (address => uint256) public deposited;
842   address public wallet;
843   State public state;
844 
845   event Closed();
846   event RefundsEnabled();
847   event Refunded(address indexed beneficiary, uint256 weiAmount);
848 
849   function RefundVault(address _wallet) public {
850     require(_wallet != address(0));
851     wallet = _wallet;
852     state = State.Active;
853   }
854 
855   function deposit(address investor) onlyOwner public payable {
856     require(state == State.Active);
857     deposited[investor] = deposited[investor].add(msg.value);
858   }
859 
860   function close() onlyOwner public {
861     require(state == State.Active);
862     state = State.Closed;
863     Closed();
864     wallet.transfer(this.balance);
865   }
866 
867   function enableRefunds() onlyOwner public {
868     require(state == State.Active);
869     state = State.Refunding;
870     RefundsEnabled();
871   }
872 
873   function refund(address investor) public {
874     require(state == State.Refunding);
875     uint256 depositedValue = deposited[investor];
876     deposited[investor] = 0;
877     investor.transfer(depositedValue);
878     Refunded(investor, depositedValue);
879   }
880 }
881 
882 
883 
884 /**
885  * @title RefundableCrowdsale
886  * @dev Extension of Crowdsale contract that adds a funding goal, and
887  * the possibility of users getting a refund if goal is not met.
888  * Uses a RefundVault as the crowdsale's vault.
889  */
890 contract RefundableCrowdsale is FinalizableCrowdsale {
891   using SafeMath for uint256;
892 
893   // minimum amount of funds to be raised in weis
894   uint256 public goal;
895 
896   // refund vault used to hold funds while crowdsale is running
897   RefundVault public vault;
898 
899   function RefundableCrowdsale(uint256 _goal) public {
900     require(_goal > 0);
901     vault = new RefundVault(wallet);
902     goal = _goal;
903   }
904 
905   // We're overriding the fund forwarding from Crowdsale.
906   // In addition to sending the funds, we want to call
907   // the RefundVault deposit function
908   function forwardFunds() internal {
909     vault.deposit.value(msg.value)(msg.sender);
910   }
911 
912   // if crowdsale is unsuccessful, investors can claim refunds here
913   function claimRefund() public {
914     require(isFinalized);
915     require(!goalReached());
916 
917     vault.refund(msg.sender);
918   }
919 
920   // vault finalization task, called when owner calls finalize()
921   function finalization() internal {
922     if (goalReached()) {
923       vault.close();
924     } else {
925       vault.enableRefunds();
926     }
927 
928     super.finalization();
929   }
930 
931   function goalReached() public view returns (bool) {
932     return weiRaised >= goal;
933   }
934 
935 }
936 
937 
938 
939 
940 
941 contract BonusableCrowdsale is usingConsts, Crowdsale {
942 
943     function buyTokens(address beneficiary) public payable {
944         require(beneficiary != address(0));
945         require(validPurchase());
946 
947         uint256 weiAmount = msg.value;
948 
949         // calculate token amount to be created
950         uint256 bonusRate = getBonusRate(weiAmount);
951         uint256 tokens = weiAmount.mul(bonusRate).div(1 ether);
952 
953         // update state
954         weiRaised = weiRaised.add(weiAmount);
955 
956         token.mint(beneficiary, tokens);
957         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
958 
959         forwardFunds();
960     }
961 
962     function getBonusRate(uint256 weiAmount) internal returns (uint256) {
963         uint256 bonusRate = rate;
964 
965         
966 
967         
968         // apply amount
969         uint[2] memory weiAmountBoundaries = [uint(4333000000000000000000),uint(10000000000000000000)];
970         uint[2] memory weiAmountRates = [uint(0),uint(150)];
971 
972         for (uint j = 0; j < 2; j++) {
973             if (weiAmount >= weiAmountBoundaries[j]) {
974                 bonusRate += bonusRate * weiAmountRates[j] / 1000;
975                 break;
976             }
977         }
978         
979 
980         return bonusRate;
981     }
982 }
983 
984 
985 contract MainCrowdsale is usingConsts, FinalizableCrowdsale {
986     function hasStarted() public constant returns (bool) {
987         return now >= startTime;
988     }
989 
990     /**
991      * @dev override token creation to integrate with MyWish token.
992      */
993     function createTokenContract() internal returns (MintableToken) {
994         return new MainToken();
995     }
996 
997     function finalization() internal {
998         super.finalization();
999         if (CONTINUE_MINTING) {
1000             return;
1001         }
1002 
1003         if (PAUSED) {
1004             MainToken(token).unpause();
1005         }
1006         token.finishMinting();
1007         token.transferOwnership(TARGET_USER);
1008     }
1009 
1010     function buyTokens(address beneficiary) public payable {
1011         require(beneficiary != address(0));
1012         require(validPurchase());
1013 
1014         uint256 weiAmount = msg.value;
1015 
1016         // calculate token amount to be created
1017         uint256 tokens = weiAmount.mul(rate).div(1 ether);
1018 
1019         // update state
1020         weiRaised = weiRaised.add(weiAmount);
1021 
1022         token.mint(beneficiary, tokens);
1023         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1024 
1025         forwardFunds();
1026     }
1027 }
1028 
1029 
1030 contract MainToken is usingConsts, FreezableMintableToken, BurnableToken, Pausable {
1031     function MainToken() {
1032         if (PAUSED) {
1033             pause();
1034         }
1035     }
1036 
1037     function name() constant public returns (string _name) {
1038         return TOKEN_NAME;
1039     }
1040 
1041     function symbol() constant public returns (string _symbol) {
1042         return TOKEN_SYMBOL;
1043     }
1044 
1045     function decimals() constant public returns (uint8 _decimals) {
1046         return TOKEN_DECIMALS_UINT8;
1047     }
1048 
1049     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
1050         require(!paused);
1051         return super.transferFrom(_from, _to, _value);
1052     }
1053 
1054     function transfer(address _to, uint256 _value) returns (bool _success) {
1055         require(!paused);
1056         return super.transfer(_to, _value);
1057     }
1058 }
1059 
1060 contract TemplateCrowdsale is usingConsts, MainCrowdsale
1061 
1062 , BonusableCrowdsale
1063 
1064 
1065 , CappedCrowdsale
1066 
1067 {
1068     event Initialized();
1069     bool public initialized = false;
1070 
1071     function TemplateCrowdsale(MintableToken _token)
1072     Crowdsale(START_TIME > now ? START_TIME : now, 1518708780, 2500 * TOKEN_DECIMAL_MULTIPLIER, TARGET_USER)
1073     CappedCrowdsale(6000000000000000000000)
1074 
1075     {
1076         token = _token;
1077     }
1078 
1079     function init() public onlyOwner {
1080         require(!initialized);
1081         initialized = true;
1082 
1083 
1084         address[4] memory addresses = [address(0x47ad6812bd3b10464f88738ab305a12dc404e693),address(0xf5b0e286a93cabb5bf110e8b588f5d876a46ada4),address(0x38cfa2e5e94a51f6365d39f4529e5aef351ef035),address(0x3fc1a9e59b416f8f9e550bba6136e7b510b6205b)];
1085         uint[4] memory amounts = [uint(300000000000000000000000),uint(1600000000000000000000000),uint(500000000000000000000000),uint(800000000000000000000000)];
1086         uint64[4] memory freezes = [uint64(0),uint64(0),uint64(0),uint64(0)];
1087 
1088         for (uint i = 0; i < addresses.length; i ++) {
1089             if (freezes[i] == 0) {
1090                 token.mint(addresses[i], amounts[i]);
1091             }
1092             else {
1093                 FreezableMintableToken(token).mintAndFreeze(addresses[i], amounts[i], freezes[i]);
1094             }
1095         }
1096 
1097 
1098         transferOwnership(TARGET_USER);
1099         Initialized();
1100     }
1101 
1102     /**
1103      * @dev override token creation to set token address in constructor.
1104      */
1105     function createTokenContract() internal returns (MintableToken) {
1106         return MintableToken(0);
1107     }
1108 
1109     function finalization() internal {
1110         super.finalization();
1111 
1112     }
1113 
1114 
1115 }