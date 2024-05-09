1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70     if (a == 0) {
71       return 0;
72     }
73     uint256 c = a * b;
74     assert(c / a == b);
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers, truncating the quotient.
80   */
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   /**
89   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   /**
97   * @dev Adds two numbers, throws on overflow.
98   */
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 
107 
108 
109 
110 
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 
125 
126 /**
127  * @title SafeERC20
128  * @dev Wrappers around ERC20 operations that throw on failure.
129  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
130  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
131  */
132 library SafeERC20 {
133   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
134     assert(token.transfer(to, value));
135   }
136 
137   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
138     assert(token.transferFrom(from, to, value));
139   }
140 
141   function safeApprove(ERC20 token, address spender, uint256 value) internal {
142     assert(token.approve(spender, value));
143   }
144 }
145 
146 
147 
148 
149 contract Administrated is Ownable {
150 
151   mapping(address => bool) internal admins;
152 
153   function Administrated() public {
154   }
155 
156   modifier onlyAdmin() {
157     require(isAdmin(msg.sender));
158     _;
159   }
160 
161   function setAdmin(address _admin, bool _isAdmin) public {
162     require(_admin != address(0));
163     require(msg.sender == owner || admins[msg.sender] == true);
164     admins[_admin] = _isAdmin;
165   }
166 
167   function isAdmin(address _address) public view returns (bool) {
168     return admins[_address];
169   }
170 
171 }
172 
173 
174 
175 
176 
177 
178 
179 
180 
181 
182 
183 
184 
185 
186 
187 /**
188  * @title Basic token
189  * @dev Basic version of StandardToken, with no allowances.
190  */
191 contract BasicToken is ERC20Basic {
192   using SafeMath for uint256;
193 
194   mapping(address => uint256) balances;
195 
196   uint256 totalSupply_;
197 
198   /**
199   * @dev total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return totalSupply_;
203   }
204 
205   /**
206   * @dev transfer token for a specified address
207   * @param _to The address to transfer to.
208   * @param _value The amount to be transferred.
209   */
210   function transfer(address _to, uint256 _value) public returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[msg.sender]);
213 
214     // SafeMath.sub will throw if there is not enough balance.
215     balances[msg.sender] = balances[msg.sender].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     Transfer(msg.sender, _to, _value);
218     return true;
219   }
220 
221   /**
222   * @dev Gets the balance of the specified address.
223   * @param _owner The address to query the the balance of.
224   * @return An uint256 representing the amount owned by the passed address.
225   */
226   function balanceOf(address _owner) public view returns (uint256 balance) {
227     return balances[_owner];
228   }
229 
230 }
231 
232 
233 
234 
235 /**
236  * @title Standard ERC20 token
237  *
238  * @dev Implementation of the basic standard token.
239  * @dev https://github.com/ethereum/EIPs/issues/20
240  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
241  */
242 contract StandardToken is ERC20, BasicToken {
243 
244   mapping (address => mapping (address => uint256)) internal allowed;
245 
246 
247   /**
248    * @dev Transfer tokens from one address to another
249    * @param _from address The address which you want to send tokens from
250    * @param _to address The address which you want to transfer to
251    * @param _value uint256 the amount of tokens to be transferred
252    */
253   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
254     require(_to != address(0));
255     require(_value <= balances[_from]);
256     require(_value <= allowed[_from][msg.sender]);
257 
258     balances[_from] = balances[_from].sub(_value);
259     balances[_to] = balances[_to].add(_value);
260     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
261     Transfer(_from, _to, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
267    *
268    * Beware that changing an allowance with this method brings the risk that someone may use both the old
269    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
270    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
271    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
272    * @param _spender The address which will spend the funds.
273    * @param _value The amount of tokens to be spent.
274    */
275   function approve(address _spender, uint256 _value) public returns (bool) {
276     allowed[msg.sender][_spender] = _value;
277     Approval(msg.sender, _spender, _value);
278     return true;
279   }
280 
281   /**
282    * @dev Function to check the amount of tokens that an owner allowed to a spender.
283    * @param _owner address The address which owns the funds.
284    * @param _spender address The address which will spend the funds.
285    * @return A uint256 specifying the amount of tokens still available for the spender.
286    */
287   function allowance(address _owner, address _spender) public view returns (uint256) {
288     return allowed[_owner][_spender];
289   }
290 
291   /**
292    * @dev Increase the amount of tokens that an owner allowed to a spender.
293    *
294    * approve should be called when allowed[_spender] == 0. To increment
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _addedValue The amount of tokens to increase the allowance by.
300    */
301   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
302     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
303     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307   /**
308    * @dev Decrease the amount of tokens that an owner allowed to a spender.
309    *
310    * approve should be called when allowed[_spender] == 0. To decrement
311    * allowed value is better to use this function to avoid 2 calls (and wait until
312    * the first transaction is mined)
313    * From MonolithDAO Token.sol
314    * @param _spender The address which will spend the funds.
315    * @param _subtractedValue The amount of tokens to decrease the allowance by.
316    */
317   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
318     uint oldValue = allowed[msg.sender][_spender];
319     if (_subtractedValue > oldValue) {
320       allowed[msg.sender][_spender] = 0;
321     } else {
322       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
323     }
324     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
325     return true;
326   }
327 
328 }
329 
330 
331 
332 
333 /**
334  * @title Mintable token
335  * @dev Simple ERC20 Token example, with mintable token creation
336  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
337  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
338  */
339 contract MintableToken is StandardToken, Ownable {
340   event Mint(address indexed to, uint256 amount);
341   event MintFinished();
342 
343   bool public mintingFinished = false;
344 
345 
346   modifier canMint() {
347     require(!mintingFinished);
348     _;
349   }
350 
351   /**
352    * @dev Function to mint tokens
353    * @param _to The address that will receive the minted tokens.
354    * @param _amount The amount of tokens to mint.
355    * @return A boolean that indicates if the operation was successful.
356    */
357   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
358     totalSupply_ = totalSupply_.add(_amount);
359     balances[_to] = balances[_to].add(_amount);
360     Mint(_to, _amount);
361     Transfer(address(0), _to, _amount);
362     return true;
363   }
364 
365   /**
366    * @dev Function to stop minting new tokens.
367    * @return True if the operation was successful.
368    */
369   function finishMinting() onlyOwner canMint public returns (bool) {
370     mintingFinished = true;
371     MintFinished();
372     return true;
373   }
374 }
375 
376 
377 
378 /**
379  * @title Capped token
380  * @dev Mintable token with a token cap.
381  */
382 contract CappedToken is MintableToken {
383 
384   uint256 public cap;
385 
386   function CappedToken(uint256 _cap) public {
387     require(_cap > 0);
388     cap = _cap;
389   }
390 
391   /**
392    * @dev Function to mint tokens
393    * @param _to The address that will receive the minted tokens.
394    * @param _amount The amount of tokens to mint.
395    * @return A boolean that indicates if the operation was successful.
396    */
397   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
398     require(totalSupply_.add(_amount) <= cap);
399 
400     return super.mint(_to, _amount);
401   }
402 
403 }
404 
405 
406 
407 
408 
409 
410 
411 
412 
413 
414 /**
415  * @title Pausable
416  * @dev Base contract which allows children to implement an emergency stop mechanism.
417  */
418 contract Pausable is Ownable {
419   event Pause();
420   event Unpause();
421 
422   bool public paused = false;
423 
424 
425   /**
426    * @dev Modifier to make a function callable only when the contract is not paused.
427    */
428   modifier whenNotPaused() {
429     require(!paused);
430     _;
431   }
432 
433   /**
434    * @dev Modifier to make a function callable only when the contract is paused.
435    */
436   modifier whenPaused() {
437     require(paused);
438     _;
439   }
440 
441   /**
442    * @dev called by the owner to pause, triggers stopped state
443    */
444   function pause() onlyOwner whenNotPaused public {
445     paused = true;
446     Pause();
447   }
448 
449   /**
450    * @dev called by the owner to unpause, returns to normal state
451    */
452   function unpause() onlyOwner whenPaused public {
453     paused = false;
454     Unpause();
455   }
456 }
457 
458 
459 
460 /**
461  * @title Pausable token
462  * @dev StandardToken modified with pausable transfers.
463  **/
464 contract PausableToken is StandardToken, Pausable {
465 
466   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
467     return super.transfer(_to, _value);
468   }
469 
470   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
471     return super.transferFrom(_from, _to, _value);
472   }
473 
474   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
475     return super.approve(_spender, _value);
476   }
477 
478   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
479     return super.increaseApproval(_spender, _addedValue);
480   }
481 
482   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
483     return super.decreaseApproval(_spender, _subtractedValue);
484   }
485 }
486 
487 
488 
489 contract VIVAToken is CappedToken, PausableToken {
490 
491   using SafeERC20 for ERC20;
492 
493   string public name = "VIVA Token";
494   string public symbol = "VIVA";
495   uint8 public decimals = 18;
496 
497   function VIVAToken(uint256 _cap) public
498     CappedToken(_cap * 10**18)
499     PausableToken() { }
500 
501 }
502 
503 
504 
505 
506 
507 
508 
509 library CrowdsaleTokenUtils {
510 
511   // Events
512   event MintTokens(address beneficiary, uint256 tokens);
513 
514   using SafeMath for uint256;
515 
516   function mintTokens(VIVAToken token, address beneficiary, uint256 tokens) public returns (bool) {
517     require(beneficiary != address(0));
518     require(tokens > 0);
519     MintTokens(beneficiary, tokens);
520     return token.mint(beneficiary, tokens);
521   }
522 
523 }
524 
525 
526 
527 contract Testable is Ownable {
528 
529   bool internal testing;
530   uint256 public _now;
531 
532   function Testable(bool _testing) public {
533     testing = _testing;
534     _now = now;
535   }
536 
537   modifier whenTesting() {
538     require(testing);
539     _;
540   }
541 
542   function getNow() public view returns (uint256) {
543     if(testing) {
544       return _now;
545     } else {
546       return now;
547     }
548   }
549 
550   function setNow(uint256 __now) public onlyOwner whenTesting {
551     _now = __now;
552   }
553 
554 }
555 
556 
557 
558 
559 // Not a generalized vesting contract - just our compensation protocol
560 contract VIVAVestingVault is Administrated, Testable {
561 
562   using SafeMath for uint256;
563 
564   event Released(address beneficiary, uint256 amount);
565 
566   VIVAToken public token;
567 
568   uint256 public d1;
569   uint256 public d2;
570 
571   mapping(address => uint256) internal totalDue;
572   mapping(address => uint256) internal released;
573 
574   function VIVAVestingVault(
575     VIVAToken _token,
576     uint256 _d1,
577     uint256 _d2,
578     bool _testing
579   ) public
580     Testable(_testing) {
581     token = _token;
582     d1 = _d1;
583     d2 = _d2;
584   }
585 
586   function register(address beneficiary, uint256 due) public onlyAdmin {
587     require(beneficiary != address(0));
588     require(due >= released[beneficiary]);
589     totalDue[beneficiary] = due;
590   }
591 
592   function release(address beneficiary, uint256 tokens) public {
593     require(beneficiary != address(0));
594     require(tokens > 0);
595     uint256 releasable = releasableAmount(beneficiary);
596     require(releasable > 0);
597     uint256 toRelease = releasable;
598     require(releasable >= tokens);
599     if(tokens < releasable) {
600       toRelease = tokens;
601     }
602     require(token.balanceOf(this) >= toRelease);
603     assert(released[beneficiary].add(toRelease) <= totalDue[beneficiary]);
604     released[beneficiary] = released[beneficiary].add(toRelease);
605     assert(token.transfer(beneficiary, toRelease));
606     Released(beneficiary, toRelease);
607   }
608 
609   function releasableAmount(address beneficiary) public view returns (uint256) {
610     uint256 vestedAmount;
611     if (getNow() < d1) {
612       vestedAmount = 0;
613     } else if (getNow() < d2) {
614       vestedAmount = totalDue[beneficiary].div(2);
615     } else {
616       if(isAdmin(msg.sender)) {
617         vestedAmount = totalDue[beneficiary];
618       } else {
619         vestedAmount = totalDue[beneficiary].div(2);
620       }
621     }
622     return vestedAmount.sub(released[beneficiary]);
623   }
624 
625   function setSchedule(uint256 _d1, uint256 _d2) public onlyAdmin {
626     require(_d1 <= _d2);
627     d1 = _d1;
628     d2 = _d2;
629   }
630 
631 }
632 
633 
634 
635 
636 
637 
638 
639 
640 
641 
642 
643 
644 contract VIVACrowdsaleRound is Ownable, Testable {
645 
646   using SafeMath for uint256;
647 
648   struct Bonus {
649     uint256 tier;
650     uint256 rate;
651   }
652 
653   bool public refundable;
654   uint256 public capAtWei;
655   uint256 public capAtDuration;
656 
657   Bonus[] bonuses;
658 
659   function VIVACrowdsaleRound(
660     bool _refundable,
661     uint256 _capAtWei,
662     uint256 _capAtDuration,
663     bool _testing
664   ) Testable(_testing) public {
665     refundable = _refundable;
666     capAtWei = _capAtWei;
667     capAtDuration = _capAtDuration;
668   }
669 
670   function addBonus(uint256 tier, uint256 rate) public onlyOwner {
671     Bonus memory bonus;
672     bonus.tier = tier;
673     bonus.rate = rate;
674     bonuses.push(bonus);
675   }
676 
677   function setCapAtDuration(uint256 _capAtDuration) onlyOwner public returns (uint256) {
678     capAtDuration = _capAtDuration;
679   }
680 
681   function setCapAtWei(uint256 _capAtWei) onlyOwner whenTesting public {
682     capAtWei = _capAtWei;
683   }
684 
685   function getBonusRate(uint256 baseRate, uint256 weiAmount) public view returns (uint256) {
686     uint256 r = baseRate;
687     for(uint i = 0; i < bonuses.length; i++) {
688       if(weiAmount >= bonuses[i].tier) {
689         r = bonuses[i].rate;
690       } else {
691         break;
692       }
693     }
694     return r;
695   }
696 
697 }
698 
699 
700 
701 
702 
703 
704 
705 
706 
707 
708 /**
709  * @title RefundVault
710  * @dev This contract is used for storing funds while a crowdsale
711  * is in progress. Supports refunding the money if crowdsale fails,
712  * and forwarding it if crowdsale is successful.
713  */
714 contract RefundVault is Ownable {
715   using SafeMath for uint256;
716 
717   enum State { Active, Refunding, Closed }
718 
719   mapping (address => uint256) public deposited;
720   address public wallet;
721   State public state;
722 
723   event Closed();
724   event RefundsEnabled();
725   event Refunded(address indexed beneficiary, uint256 weiAmount);
726 
727   function RefundVault(address _wallet) public {
728     require(_wallet != address(0));
729     wallet = _wallet;
730     state = State.Active;
731   }
732 
733   function deposit(address investor) onlyOwner public payable {
734     require(state == State.Active);
735     deposited[investor] = deposited[investor].add(msg.value);
736   }
737 
738   function close() onlyOwner public {
739     require(state == State.Active);
740     state = State.Closed;
741     Closed();
742     wallet.transfer(this.balance);
743   }
744 
745   function enableRefunds() onlyOwner public {
746     require(state == State.Active);
747     state = State.Refunding;
748     RefundsEnabled();
749   }
750 
751   function refund(address investor) public {
752     require(state == State.Refunding);
753     uint256 depositedValue = deposited[investor];
754     deposited[investor] = 0;
755     investor.transfer(depositedValue);
756     Refunded(investor, depositedValue);
757   }
758 }
759 
760 
761 contract VIVARefundVault is RefundVault {
762 
763   function VIVARefundVault(
764     address _wallet
765   ) RefundVault(_wallet) public { }
766 
767   function setWallet(address _wallet) onlyOwner public {
768     require(state == State.Active);
769     require(_wallet != address(0));
770     wallet = _wallet;
771   }
772 
773   function getWallet() public view returns (address) {
774     return wallet;
775   }
776 
777 }
778 
779 
780 
781 contract VIVACrowdsaleData is Administrated {
782 
783   using SafeMath for uint256;
784 
785   // Events
786   event MintTokens(address beneficiary, uint256 tokens);
787 
788   event CloseRefundVault(bool refund);
789   event Finalize(address tokenOwner, bool refundable);
790   event RegisterPrivateContribution(address beneficiary, uint256 tokens);
791   event RegisterPurchase(VIVACrowdsaleRound round, address beneficiary, uint256 tokens, uint256 weiAmount);
792   event UnregisterPurchase(address beneficiary, uint256 tokens, uint256 weiAmount);
793 
794   VIVAToken public token;
795 
796   uint256 public startTime;
797 
798   bool public isFinalized = false;
799 
800   VIVACrowdsaleRound[] public rounds;
801 
802   // Main fund collection (refundable)
803   address public wallet;
804   VIVARefundVault public refundVault;
805   bool public refundVaultClosed = false;
806 
807   // Distribution vaults
808   address public bountyVault;
809   address public reserveVault;
810   address public teamVault;
811   address public advisorVault;
812 
813   // Track general sale progress
814   uint256 public privateContributionTokens;
815   mapping(address => uint256) internal weiContributed;
816   uint256 public mintedForSaleTokens; // Total general sale tokens minted
817   uint256 public weiRaisedForSale;
818 
819   // Verified investors only for > 7ETH (must be pre-approved)
820   uint256 public largeInvestorWei = 7000000000000000000; // 7 ETH
821   mapping(address => uint256) internal approvedLargeInvestors; // And their authorized limits
822 
823   function VIVACrowdsaleData(
824     VIVAToken _token,
825     address _wallet,
826     uint256 _startTime
827   )  public {
828       require(_token != address(0));
829       require(_wallet != address(0));
830       token = _token;
831       wallet = _wallet;
832       startTime = _startTime;
833       refundVault = new VIVARefundVault(_wallet);
834   }
835 
836   function getNumRounds() public view returns (uint256) {
837     return rounds.length;
838   }
839 
840   function addRound(VIVACrowdsaleRound round) public onlyAdmin {
841     require(address(round) != address(0));
842     rounds.push(round);
843   }
844 
845   function removeRound(uint256 i) public onlyAdmin {
846     while (i < rounds.length - 1) {
847       rounds[i] = rounds[i+1];
848       i++;
849     }
850     rounds.length--;
851   }
852 
853   function setStartTime(uint256 _startTime) public onlyAdmin {
854     startTime = _startTime;
855   }
856 
857   function mintTokens(address beneficiary, uint256 tokens) public onlyAdmin returns (bool) {
858     return CrowdsaleTokenUtils.mintTokens(token, beneficiary, tokens);
859   }
860 
861   function registerPrivateContribution(address beneficiary, uint256 tokens) public onlyAdmin returns (bool) {
862     require(beneficiary != address(0));
863     privateContributionTokens = privateContributionTokens.add(tokens);
864     RegisterPrivateContribution(beneficiary, tokens);
865     return true;
866   }
867 
868   function registerPurchase(VIVACrowdsaleRound round, address beneficiary, uint256 tokens) public payable onlyAdmin returns (bool) {
869     require(address(round) != address(0));
870     require(beneficiary != address(0));
871     if(round.refundable()) {
872       refundVault.deposit.value(msg.value)(beneficiary);
873     } else {
874       wallet.transfer(msg.value);
875     }
876     weiContributed[beneficiary] = msg.value.add(weiContributed[beneficiary]);
877     weiRaisedForSale = weiRaisedForSale.add(msg.value);
878     mintedForSaleTokens = mintedForSaleTokens.add(tokens);
879     RegisterPurchase(round, beneficiary, tokens, msg.value);
880     return true;
881   }
882 
883   function getWeiContributed(address from) public view returns (uint256) { return weiContributed[from];  }
884 
885   function closeRefundVault(bool refund) public onlyAdmin {
886     require(!refundVaultClosed);
887     refundVaultClosed = true;
888     if(refund) {
889       refundVault.enableRefunds();
890     } else {
891       refundVault.close();
892     }
893     CloseRefundVault(refund);
894   }
895 
896   function finalize(address tokenOwner, bool refundable) public onlyAdmin {
897     require(tokenOwner != address(0));
898     require(!isFinalized);
899     isFinalized = true;
900     if(!refundVaultClosed) {
901       closeRefundVault(refundable);
902     }
903     token.finishMinting();
904     token.transferOwnership(tokenOwner);
905     Finalize(tokenOwner, refundable);
906   }
907 
908   function setWallet(address _wallet) public onlyAdmin {
909     require(_wallet != address(0));
910     wallet = _wallet;
911     refundVault.setWallet(_wallet);
912   }
913 
914   function setLargeInvestorWei(uint256 _largeInvestorWei) public onlyAdmin {
915     require(_largeInvestorWei >= 0);
916     largeInvestorWei = _largeInvestorWei;
917   }
918 
919   function getLargeInvestorApproval(address beneficiary) public view returns (uint256) {
920     require(beneficiary != address(0));
921     return approvedLargeInvestors[beneficiary];
922   }
923 
924   function setLargeInvestorApproval(address beneficiary, uint256 weiLimit) public onlyAdmin {
925     require(beneficiary != address(0));
926     require(weiLimit >= largeInvestorWei);
927     approvedLargeInvestors[beneficiary] = weiLimit;
928   }
929 
930   function setBountyVault(address vault) public onlyAdmin  { bountyVault = vault;  }
931   function setReserveVault(address vault) public onlyAdmin { reserveVault = vault; }
932   function setTeamVault(address vault) public onlyAdmin    { teamVault = vault;    }
933   function setAdvisorVault(address vault) public onlyAdmin { advisorVault = vault; }
934 
935 }
936 
937 
938 
939 
940 
941 
942 
943 contract VIVAVault is Administrated {
944 
945   using SafeMath for uint256;
946 
947   event Released(address beneficiary, uint256 amount);
948 
949   VIVAToken public token;
950 
951   function VIVAVault(
952     VIVAToken _token
953   ) public {
954     token = _token;
955   }
956 
957   function release(address beneficiary, uint256 amount) public onlyAdmin {
958     require(beneficiary != address(0));
959     require(amount > 0);
960 
961     uint256 releasable = releasableAmount(beneficiary);
962     require(releasable > 0);
963     require(token.balanceOf(this) >= releasable);
964     require(amount <= releasable);
965 
966     assert(token.transfer(beneficiary, amount));
967 
968     Released(beneficiary, amount);
969   }
970 
971   function releasableAmount(address beneficiary) public view returns (uint256) {
972     require(beneficiary != address(0));
973     // Any other restrictions we want
974     return token.balanceOf(this);
975   }
976 
977 }
978 
979 
980 
981 
982 
983 
984 
985 
986 library VaultUtils {
987 
988   using SafeMath for uint256;
989 
990   function createVestingVault(VIVACrowdsaleData data, address admin, uint256 tokens, uint256 d1, uint256 d2, bool testing) public returns (VIVAVestingVault) {
991     require(admin != address(0));
992     VIVAVestingVault vault = new VIVAVestingVault(data.token(), d1, d2, testing);
993     vault.setAdmin(admin, true);
994     assert(data.mintTokens(address(vault), tokens));
995     return vault;
996   }
997 
998   function createVault(VIVACrowdsaleData data, address admin, uint256 tokens) public returns (VIVAVault) {
999     require(admin != address(0));
1000     VIVAVault vault = new VIVAVault(data.token());
1001     vault.setAdmin(admin, true);
1002     assert(data.mintTokens(address(vault), tokens));
1003     return vault;
1004   }
1005 
1006 }
1007 
1008 
1009 
1010 
1011 
1012 
1013 
1014 
1015 library CrowdsaleUtils {
1016 
1017   using SafeMath for uint256;
1018 
1019   function getCurrentRound(VIVACrowdsaleData data, uint256 valuationDate, uint256 weiRaisedForSale) public view returns (VIVACrowdsaleRound) {
1020     uint256 time = data.startTime();
1021     bool hadTimeRange = false;
1022     for(uint i = 0; i < data.getNumRounds(); i++) {
1023       bool inTimeRange = valuationDate >= time && valuationDate < time.add(data.rounds(i).capAtDuration());
1024       bool inCapRange = weiRaisedForSale < data.rounds(i).capAtWei();
1025       if(inTimeRange) {
1026         if(inCapRange) {
1027           return data.rounds(i);
1028         }
1029         hadTimeRange = true;
1030       } else {
1031         if(hadTimeRange) {
1032           if(inCapRange) {
1033             return data.rounds(i);
1034           }
1035         }
1036       }
1037       time = time.add(data.rounds(i).capAtDuration());
1038     }
1039   }
1040 
1041   function validPurchase(VIVACrowdsaleData data, VIVACrowdsaleRound round, address beneficiary, uint256 weiAmount, uint256 tokens, uint256 minContributionWeiAmount, uint256 tokensForSale) public view returns (bool) {
1042     // Crowdsale must be active
1043     if(address(round) == address(0)) {
1044       return false;
1045     }
1046     if(data.isFinalized()) {
1047       return false;
1048     }
1049 
1050     // Ensure exceeds min contribution size
1051     if(weiAmount < minContributionWeiAmount) {
1052       return false;
1053     }
1054     if(tokens <= 0) {
1055       return false;
1056     }
1057 
1058     // Ensure we have enough tokens left for sale
1059     if(tokens.add(data.mintedForSaleTokens()) > tokensForSale) {
1060       return false;
1061     }
1062 
1063     // Ensure cap not exceeded
1064     if(weiAmount.add(data.weiRaisedForSale()) > round.capAtWei()) {
1065       return false;
1066     }
1067 
1068     uint256 contributed = weiAmount.add(data.getWeiContributed(beneficiary));
1069     // Ensure large investors are approved
1070     if(contributed > data.largeInvestorWei()) {
1071       if(data.getLargeInvestorApproval(beneficiary) < contributed) {
1072         return false;
1073       }
1074     }
1075 
1076     // It's valid!
1077     return true;
1078   }
1079 
1080 }
1081 
1082 
1083 
1084 
1085 
1086 
1087 
1088 
1089 
1090 
1091 
1092 
1093 
1094 
1095 
1096 
1097 contract VIVACrowdsale is Administrated, Testable {
1098 
1099   using SafeMath for uint256;
1100 
1101   // Events (more bubble up from VIVACrowdsaleData)
1102   event Cancelled();
1103   event Debug(uint256 value);
1104 
1105   // ms time constants
1106   uint256 public constant SECOND = 1000;
1107   uint256 public constant MINUTE = SECOND * 60;
1108   uint256 public constant HOUR = MINUTE * 60;
1109   uint256 public constant DAY = HOUR * 24;
1110   uint256 public constant WEEK = DAY * 7;
1111 
1112   // Crowdsale data store separated from logic
1113   VIVACrowdsaleData public data;
1114 
1115   // ===== Main TGE Parameters (Constant) =================================================
1116   uint256 public constant baseRate                 = 35714;
1117   uint256 public constant minContributionWeiAmount = 1000000000000000;
1118   uint256 public constant tokensPrivateInvesting   = 50000000 * 10**18;
1119   uint256 public constant tokensMarketing          = 500000000 * 10**18;
1120   uint256 public constant tokensTeam               = 300000000 * 10**18;
1121   uint256 public constant tokensAdvisor            = 150000000 * 10**18;
1122   uint256 public constant tokensBounty             = 50000000 * 10**18;
1123   uint256 public constant tokensReserved           = 400000000 * 10**18;
1124   uint256 public constant tokensForSale            = 3000000000 * 10**18;
1125   // ======================================================================================
1126 
1127   function VIVACrowdsale(
1128     VIVACrowdsaleData _data,
1129     bool _testing
1130   ) Testable(_testing) public {
1131       require(_data != address(0));
1132       data = _data;
1133   }
1134 
1135   function privateContribution(address beneficiary, uint256 tokens) public onlyAdmin {
1136     require(beneficiary != address(0));
1137     require(tokens > 0);
1138     require(!data.isFinalized());
1139     require(tokens.add(data.privateContributionTokens()) <= tokensPrivateInvesting.add(tokensMarketing));
1140     assert(data.registerPrivateContribution(beneficiary, tokens));
1141     assert(data.mintTokens(beneficiary, tokens));
1142   }
1143 
1144   function getTokenAmount(VIVACrowdsaleRound round, uint256 weiAmount) public view returns(uint256) {
1145     require(address(round) != address(0));
1146     if(weiAmount == 0) return 0;
1147     return weiAmount.mul(round.getBonusRate(baseRate, weiAmount));
1148   }
1149 
1150   function () external payable {
1151     buyTokens();
1152   }
1153 
1154   function buyTokens() public payable {
1155     require(!data.isFinalized());
1156     VIVACrowdsaleRound round = getCurrentRound(getNow(), data.weiRaisedForSale());
1157     require(address(round) != address(0));
1158     uint256 tokens = getTokenAmount(round, msg.value);
1159     require(CrowdsaleUtils.validPurchase(data, round, msg.sender, msg.value, tokens, minContributionWeiAmount, tokensForSale));
1160     assert(data.registerPurchase.value(msg.value)(round, msg.sender, tokens));
1161     assert(data.mintTokens(msg.sender, tokens));
1162   }
1163 
1164   function getCurrentRound(uint256 valuationDate, uint256 weiRaisedForSale) public view returns (VIVACrowdsaleRound) {
1165     return CrowdsaleUtils.getCurrentRound(data, valuationDate, weiRaisedForSale);
1166   }
1167 
1168   function cancel() onlyAdmin public {
1169     require(!data.isFinalized());
1170     data.finalize(msg.sender, true);
1171     Cancelled();
1172   }
1173 
1174   function finalize() onlyAdmin public {
1175     require(!data.isFinalized());
1176     data.setBountyVault(VaultUtils.createVault(data, msg.sender, tokensBounty));
1177     data.setReserveVault(VaultUtils.createVault(data, msg.sender, tokensReserved));
1178     data.setTeamVault(VaultUtils.createVestingVault(data, msg.sender, tokensTeam, getNow() + (365 * DAY), getNow() + (365 * DAY), testing));
1179     data.setAdvisorVault(VaultUtils.createVestingVault(data, msg.sender, tokensAdvisor, getNow() + (30 * DAY), getNow() + (90 * DAY), testing));
1180     data.finalize(msg.sender, false);
1181     // Unsold tokens are burnt (i.e. never minted)
1182   }
1183 
1184 }