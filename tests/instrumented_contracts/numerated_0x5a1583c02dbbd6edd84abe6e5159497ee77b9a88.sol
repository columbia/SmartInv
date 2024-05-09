1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[msg.sender]);
63 
64     // SafeMath.sub will throw if there is not enough balance.
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     Transfer(msg.sender, _to, _value);
68     return true;
69   }
70 
71   /**
72   * @dev Gets the balance of the specified address.
73   * @param _owner The address to query the the balance of.
74   * @return An uint256 representing the amount owned by the passed address.
75   */
76   function balanceOf(address _owner) public view returns (uint256 balance) {
77     return balances[_owner];
78   }
79 
80 }
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender) public view returns (uint256);
88   function transferFrom(address from, address to, uint256 value) public returns (bool);
89   function approve(address spender, uint256 value) public returns (bool);
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * @dev https://github.com/ethereum/EIPs/issues/20
98  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  */
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public view returns (uint256) {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * approve should be called when allowed[_spender] == 0. To increment
151    * allowed value is better to use this function to avoid 2 calls (and wait until
152    * the first transaction is mined)
153    * From MonolithDAO Token.sol
154    */
155   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
156     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 
161   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172 }
173 
174 /**
175  * @title Ownable
176  * @dev The Ownable contract has an owner address, and provides basic authorization control
177  * functions, this simplifies the implementation of "user permissions".
178  */
179 contract Ownable {
180   address public owner;
181 
182 
183   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185 
186   /**
187    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
188    * account.
189    */
190   function Ownable() public {
191     owner = msg.sender;
192   }
193 
194 
195   /**
196    * @dev Throws if called by any account other than the owner.
197    */
198   modifier onlyOwner() {
199     require(msg.sender == owner);
200     _;
201   }
202 
203 
204   /**
205    * @dev Allows the current owner to transfer control of the contract to a newOwner.
206    * @param newOwner The address to transfer ownership to.
207    */
208   function transferOwnership(address newOwner) public onlyOwner {
209     require(newOwner != address(0));
210     OwnershipTransferred(owner, newOwner);
211     owner = newOwner;
212   }
213 
214 }
215 
216 /**
217  * @title Mintable token
218  * @dev Simple ERC20 Token example, with mintable token creation
219  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
220  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
221  */
222 
223 contract MintableToken is StandardToken, Ownable {
224   event Mint(address indexed to, uint256 amount);
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228 
229 
230   modifier canMint() {
231     require(!mintingFinished);
232     _;
233   }
234 
235   /**
236    * @dev Function to mint tokens
237    * @param _to The address that will receive the minted tokens.
238    * @param _amount The amount of tokens to mint.
239    * @return A boolean that indicates if the operation was successful.
240    */
241   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
242     totalSupply = totalSupply.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     Mint(_to, _amount);
245     Transfer(address(0), _to, _amount);
246     return true;
247   }
248 
249   /**
250    * @dev Function to stop minting new tokens.
251    * @return True if the operation was successful.
252    */
253   function finishMinting() onlyOwner canMint public returns (bool) {
254     mintingFinished = true;
255     MintFinished();
256     return true;
257   }
258 }
259 
260 /**
261  * @title Capped token
262  * @dev Mintable token with a token cap.
263  */
264 
265 contract CappedToken is MintableToken {
266 
267   uint256 public cap;
268 
269   function CappedToken(uint256 _cap) public {
270     require(_cap > 0);
271     cap = _cap;
272   }
273 
274   /**
275    * @dev Function to mint tokens
276    * @param _to The address that will receive the minted tokens.
277    * @param _amount The amount of tokens to mint.
278    * @return A boolean that indicates if the operation was successful.
279    */
280   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
281     require(totalSupply.add(_amount) <= cap);
282 
283     return super.mint(_to, _amount);
284   }
285 
286 }
287 
288 /**
289  * @title SafeERC20
290  * @dev Wrappers around ERC20 operations that throw on failure.
291  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
292  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
293  */
294 library SafeERC20 {
295   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
296     assert(token.transfer(to, value));
297   }
298 
299   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
300     assert(token.transferFrom(from, to, value));
301   }
302 
303   function safeApprove(ERC20 token, address spender, uint256 value) internal {
304     assert(token.approve(spender, value));
305   }
306 }
307 
308 /**
309  * @title TokenVesting
310  * @dev A token holder contract that can release its token balance gradually like a
311  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
312  * owner.
313  */
314 contract TokenVesting is Ownable {
315   using SafeMath for uint256;
316   using SafeERC20 for ERC20Basic;
317 
318   event Released(uint256 amount);
319   event Revoked();
320 
321   // beneficiary of tokens after they are released
322   address public beneficiary;
323 
324   uint256 public cliff;
325   uint256 public start;
326   uint256 public duration;
327 
328   bool public revocable;
329 
330   mapping (address => uint256) public released;
331   mapping (address => bool) public revoked;
332 
333   /**
334    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
335    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
336    * of the balance will have vested.
337    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
338    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
339    * @param _duration duration in seconds of the period in which the tokens will vest
340    * @param _revocable whether the vesting is revocable or not
341    */
342   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
343     require(_beneficiary != address(0));
344     require(_cliff <= _duration);
345 
346     beneficiary = _beneficiary;
347     revocable = _revocable;
348     duration = _duration;
349     cliff = _start.add(_cliff);
350     start = _start;
351   }
352 
353   /**
354    * @notice Transfers vested tokens to beneficiary.
355    * @param token ERC20 token which is being vested
356    */
357   function release(ERC20Basic token) public {
358     uint256 unreleased = releasableAmount(token);
359 
360     require(unreleased > 0);
361 
362     released[token] = released[token].add(unreleased);
363 
364     token.safeTransfer(beneficiary, unreleased);
365 
366     Released(unreleased);
367   }
368 
369   /**
370    * @notice Allows the owner to revoke the vesting. Tokens already vested
371    * remain in the contract, the rest are returned to the owner.
372    * @param token ERC20 token which is being vested
373    */
374   function revoke(ERC20Basic token) public onlyOwner {
375     require(revocable);
376     require(!revoked[token]);
377 
378     uint256 balance = token.balanceOf(this);
379 
380     uint256 unreleased = releasableAmount(token);
381     uint256 refund = balance.sub(unreleased);
382 
383     revoked[token] = true;
384 
385     token.safeTransfer(owner, refund);
386 
387     Revoked();
388   }
389 
390   /**
391    * @dev Calculates the amount that has already vested but hasn't been released yet.
392    * @param token ERC20 token which is being vested
393    */
394   function releasableAmount(ERC20Basic token) public view returns (uint256) {
395     return vestedAmount(token).sub(released[token]);
396   }
397 
398   /**
399    * @dev Calculates the amount that has already vested.
400    * @param token ERC20 token which is being vested
401    */
402   function vestedAmount(ERC20Basic token) public view returns (uint256) {
403     uint256 currentBalance = token.balanceOf(this);
404     uint256 totalBalance = currentBalance.add(released[token]);
405 
406     if (now < cliff) {
407       return 0;
408     } else if (now >= start.add(duration) || revoked[token]) {
409       return totalBalance;
410     } else {
411       return totalBalance.mul(now.sub(start)).div(duration);
412     }
413   }
414 }
415 
416 contract MonthlyTokenVesting is TokenVesting {
417 
418     uint256 public previousTokenVesting = 0;
419 
420     function MonthlyTokenVesting(
421         address _beneficiary,
422         uint256 _start,
423         uint256 _cliff,
424         uint256 _duration,
425         bool _revocable
426     ) public
427     TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable)
428     { }
429 
430 
431     function release(ERC20Basic token) public onlyOwner {
432         require(now >= previousTokenVesting + 30 days);
433         super.release(token);
434         previousTokenVesting = now;
435     }
436 }
437 
438 contract CREDToken is CappedToken {
439     using SafeMath for uint256;
440 
441     /**
442      * Constant fields
443      */
444 
445     string public constant name = "Verify Token";
446     uint8 public constant decimals = 18;
447     string public constant symbol = "CRED";
448 
449     /**
450      * Immutable state variables
451      */
452 
453     // Time when team and reserved tokens are unlocked
454     uint256 public reserveUnlockTime;
455 
456     address public teamWallet;
457     address public reserveWallet;
458     address public advisorsWallet;
459 
460     /**
461      * State variables
462      */
463 
464     uint256 teamLocked;
465     uint256 reserveLocked;
466     uint256 advisorsLocked;
467 
468     // Are the tokens non-transferrable?
469     bool public locked = true;
470 
471     // When tokens can be unfreezed.
472     uint256 public unfreezeTime = 0;
473 
474     bool public unlockedReserveAndTeamFunds = false;
475 
476     MonthlyTokenVesting public advisorsVesting = MonthlyTokenVesting(address(0));
477 
478     /**
479      * Events
480      */
481 
482     event MintLocked(address indexed to, uint256 amount);
483 
484     event Unlocked(address indexed to, uint256 amount);
485 
486     /**
487      * Modifiers
488      */
489 
490     // Tokens must not be locked.
491     modifier whenLiquid {
492         require(!locked);
493         _;
494     }
495 
496     modifier afterReserveUnlockTime {
497         require(now >= reserveUnlockTime);
498         _;
499     }
500 
501     modifier unlockReserveAndTeamOnce {
502         require(!unlockedReserveAndTeamFunds);
503         _;
504     }
505 
506     /**
507      * Constructor
508      */
509     function CREDToken(
510         uint256 _cap,
511         uint256 _yearLockEndTime,
512         address _teamWallet,
513         address _reserveWallet,
514         address _advisorsWallet
515     )
516     CappedToken(_cap)
517     public
518     {
519         require(_yearLockEndTime != 0);
520         require(_teamWallet != address(0));
521         require(_reserveWallet != address(0));
522         require(_advisorsWallet != address(0));
523 
524         reserveUnlockTime = _yearLockEndTime;
525         teamWallet = _teamWallet;
526         reserveWallet = _reserveWallet;
527         advisorsWallet = _advisorsWallet;
528     }
529 
530     // Mint a certain number of tokens that are locked up.
531     // _value has to be bounded not to overflow.
532     function mintAdvisorsTokens(uint256 _value) public onlyOwner canMint {
533         require(advisorsLocked == 0);
534         require(_value.add(totalSupply) <= cap);
535         advisorsLocked = _value;
536         MintLocked(advisorsWallet, _value);
537     }
538 
539     function mintTeamTokens(uint256 _value) public onlyOwner canMint {
540         require(teamLocked == 0);
541         require(_value.add(totalSupply) <= cap);
542         teamLocked = _value;
543         MintLocked(teamWallet, _value);
544     }
545 
546     function mintReserveTokens(uint256 _value) public onlyOwner canMint {
547         require(reserveLocked == 0);
548         require(_value.add(totalSupply) <= cap);
549         reserveLocked = _value;
550         MintLocked(reserveWallet, _value);
551     }
552 
553 
554     /// Finalise any minting operations. Resets the owner and causes normal tokens
555     /// to be frozen. Also begins the countdown for locked-up tokens.
556     function finalise() public onlyOwner {
557         require(reserveLocked > 0);
558         require(teamLocked > 0);
559         require(advisorsLocked > 0);
560 
561         advisorsVesting = new MonthlyTokenVesting(advisorsWallet, now, 92 days, 2 years, false);
562         mint(advisorsVesting, advisorsLocked);
563         finishMinting();
564 
565         owner = 0;
566         unfreezeTime = now + 1 weeks;
567     }
568 
569 
570     // Causes tokens to be liquid 1 week after the tokensale is completed
571     function unfreeze() public {
572         require(unfreezeTime > 0);
573         require(now >= unfreezeTime);
574         locked = false;
575     }
576 
577 
578     /// Unlock any now freeable tokens that are locked up for team and reserve accounts .
579     function unlockTeamAndReserveTokens() public whenLiquid afterReserveUnlockTime unlockReserveAndTeamOnce {
580         require(totalSupply.add(teamLocked).add(reserveLocked) <= cap);
581 
582         totalSupply = totalSupply.add(teamLocked).add(reserveLocked);
583         balances[teamWallet] = balances[teamWallet].add(teamLocked);
584         balances[reserveWallet] = balances[reserveWallet].add(reserveLocked);
585         teamLocked = 0;
586         reserveLocked = 0;
587         unlockedReserveAndTeamFunds = true;
588 
589         Transfer(address(0), teamWallet, teamLocked);
590         Transfer(address(0), reserveWallet, reserveLocked);
591         Unlocked(teamWallet, teamLocked);
592         Unlocked(reserveWallet, reserveLocked);
593     }
594 
595     function unlockAdvisorTokens() public whenLiquid {
596         advisorsVesting.release(this);
597     }
598 
599 
600     /**
601      * Methods overriding some OpenZeppelin functions to prevent calling them when token is not liquid.
602      */
603 
604     function transfer(address _to, uint256 _value) public whenLiquid returns (bool) {
605         return super.transfer(_to, _value);
606     }
607 
608     function transferFrom(address _from, address _to, uint256 _value) public whenLiquid returns (bool) {
609         return super.transferFrom(_from, _to, _value);
610     }
611 
612     function approve(address _spender, uint256 _value) public whenLiquid returns (bool) {
613         return super.approve(_spender, _value);
614     }
615 
616     function increaseApproval(address _spender, uint256 _addedValue) public whenLiquid returns (bool) {
617         return super.increaseApproval(_spender, _addedValue);
618     }
619 
620     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenLiquid returns (bool) {
621         return super.decreaseApproval(_spender, _subtractedValue);
622     }
623 
624 }
625 
626 /**
627  * @title Crowdsale
628  * @dev Crowdsale is a base contract for managing a token crowdsale.
629  * Crowdsales have a start and end timestamps, where investors can make
630  * token purchases and the crowdsale will assign them tokens based
631  * on a token per ETH rate. Funds collected are forwarded to a wallet
632  * as they arrive.
633  */
634 contract Crowdsale {
635   using SafeMath for uint256;
636 
637   // The token being sold
638   MintableToken public token;
639 
640   // start and end timestamps where investments are allowed (both inclusive)
641   uint256 public startTime;
642   uint256 public endTime;
643 
644   // address where funds are collected
645   address public wallet;
646 
647   // how many token units a buyer gets per wei
648   uint256 public rate;
649 
650   // amount of raised money in wei
651   uint256 public weiRaised;
652 
653   /**
654    * event for token purchase logging
655    * @param purchaser who paid for the tokens
656    * @param beneficiary who got the tokens
657    * @param value weis paid for purchase
658    * @param amount amount of tokens purchased
659    */
660   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
661 
662 
663   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
664     require(_startTime >= now);
665     require(_endTime >= _startTime);
666     require(_rate > 0);
667     require(_wallet != address(0));
668 
669     token = createTokenContract();
670     startTime = _startTime;
671     endTime = _endTime;
672     rate = _rate;
673     wallet = _wallet;
674   }
675 
676   // creates the token to be sold.
677   // override this method to have crowdsale of a specific mintable token.
678   function createTokenContract() internal returns (MintableToken) {
679     return new MintableToken();
680   }
681 
682 
683   // fallback function can be used to buy tokens
684   function () external payable {
685     buyTokens(msg.sender);
686   }
687 
688   // low level token purchase function
689   function buyTokens(address beneficiary) public payable {
690     require(beneficiary != address(0));
691     require(validPurchase());
692 
693     uint256 weiAmount = msg.value;
694 
695     // calculate token amount to be created
696     uint256 tokens = weiAmount.mul(rate);
697 
698     // update state
699     weiRaised = weiRaised.add(weiAmount);
700 
701     token.mint(beneficiary, tokens);
702     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
703 
704     forwardFunds();
705   }
706 
707   // send ether to the fund collection wallet
708   // override to create custom fund forwarding mechanisms
709   function forwardFunds() internal {
710     wallet.transfer(msg.value);
711   }
712 
713   // @return true if the transaction can buy tokens
714   function validPurchase() internal view returns (bool) {
715     bool withinPeriod = now >= startTime && now <= endTime;
716     bool nonZeroPurchase = msg.value != 0;
717     return withinPeriod && nonZeroPurchase;
718   }
719 
720   // @return true if crowdsale event has ended
721   function hasEnded() public view returns (bool) {
722     return now > endTime;
723   }
724 
725 
726 }
727 /**
728  * @title CappedCrowdsale
729  * @dev Extension of Crowdsale with a max amount of funds raised
730  */
731 contract CappedCrowdsale is Crowdsale {
732   using SafeMath for uint256;
733 
734   uint256 public cap;
735 
736   function CappedCrowdsale(uint256 _cap) public {
737     require(_cap > 0);
738     cap = _cap;
739   }
740 
741   // overriding Crowdsale#validPurchase to add extra cap logic
742   // @return true if investors can buy at the moment
743   function validPurchase() internal view returns (bool) {
744     bool withinCap = weiRaised.add(msg.value) <= cap;
745     return super.validPurchase() && withinCap;
746   }
747 
748   // overriding Crowdsale#hasEnded to add cap logic
749   // @return true if crowdsale event has ended
750   function hasEnded() public view returns (bool) {
751     bool capReached = weiRaised >= cap;
752     return super.hasEnded() || capReached;
753   }
754 
755 }
756 
757 /**
758  * @title Pausable
759  * @dev Base contract which allows children to implement an emergency stop mechanism.
760  */
761 contract Pausable is Ownable {
762   event Pause();
763   event Unpause();
764 
765   bool public paused = false;
766 
767 
768   /**
769    * @dev Modifier to make a function callable only when the contract is not paused.
770    */
771   modifier whenNotPaused() {
772     require(!paused);
773     _;
774   }
775 
776   /**
777    * @dev Modifier to make a function callable only when the contract is paused.
778    */
779   modifier whenPaused() {
780     require(paused);
781     _;
782   }
783 
784   /**
785    * @dev called by the owner to pause, triggers stopped state
786    */
787   function pause() onlyOwner whenNotPaused public {
788     paused = true;
789     Pause();
790   }
791 
792   /**
793    * @dev called by the owner to unpause, returns to normal state
794    */
795   function unpause() onlyOwner whenPaused public {
796     paused = false;
797     Unpause();
798   }
799 }
800 
801 contract Tokensale is CappedCrowdsale, Pausable{
802     using SafeMath for uint256;
803 
804     uint256 constant public MAX_SUPPLY = 50000000 ether;
805     uint256 constant public SALE_TOKENS_SUPPLY = 11125000 ether;
806     uint256 constant public INVESTMENT_FUND_TOKENS_SUPPLY = 10500000 ether;
807     uint256 constant public MISCELLANEOUS_TOKENS_SUPPLY = 2875000 ether;
808     uint256 constant public TEAM_TOKENS_SUPPLY = 10000000 ether;
809     uint256 constant public RESERVE_TOKENS_SUPPLY = 10000000 ether;
810     uint256 constant public ADVISORS_TOKENS_SUPPLY = 5500000 ether;
811 
812 
813     uint256 public totalSold;
814     uint256 public soldDuringTokensale;
815 
816     uint256 public presaleStartTime;
817 
818     mapping(address => uint256) public presaleLimit;
819 
820 
821     modifier beforeSale() {
822         require(now < startTime);
823         _;
824     }
825 
826     modifier duringSale() {
827         require(now >= startTime && !hasEnded() && !paused);
828         _;
829     }
830 
831     function Tokensale(
832         uint256 _presaleStartTime,
833         uint256 _startTime,
834         uint256 _hardCap,
835         address _investmentFundWallet,
836         address _miscellaneousWallet,
837         address _treasury,
838         address _teamWallet,
839         address _reserveWallet,
840         address _advisorsWallet
841     )
842     CappedCrowdsale(_hardCap)
843     Crowdsale(_startTime, _startTime + 30 days, SALE_TOKENS_SUPPLY.div(_hardCap), _treasury)
844     public
845     {
846         require(_startTime > _presaleStartTime);
847         require(now < _presaleStartTime);
848 
849         token = new CREDToken(
850             MAX_SUPPLY,
851             _startTime + 1 years,
852             _teamWallet,
853             _reserveWallet,
854             _advisorsWallet
855         );
856         presaleStartTime = _presaleStartTime;
857         mintInvestmentFundAndMiscellaneous(_investmentFundWallet, _miscellaneousWallet);
858         castedToken().mintTeamTokens(TEAM_TOKENS_SUPPLY);
859         castedToken().mintReserveTokens(RESERVE_TOKENS_SUPPLY);
860         castedToken().mintAdvisorsTokens(ADVISORS_TOKENS_SUPPLY);
861 
862     }
863 
864     function setHardCap(uint256 _cap) public onlyOwner {
865         require(now < presaleStartTime);
866         require(_cap > 0);
867         cap = _cap;
868         rate = SALE_TOKENS_SUPPLY.div(_cap);
869     }
870 
871     // Function for setting presale buy limits for list of accounts
872     function addPresaleWallets(address[] _wallets, uint256[] _weiLimit) external onlyOwner {
873         require(now < startTime);
874         require(_wallets.length == _weiLimit.length);
875         for (uint256 i = 0; i < _wallets.length; i++) {
876             presaleLimit[_wallets[i]] = _weiLimit[i];
877         }
878     }
879 
880     // Override to track sold tokens
881     function buyTokens(address beneficiary) public payable {
882         super.buyTokens(beneficiary);
883         // If bought in presale, decrease limit
884         if (now < startTime) {
885             presaleLimit[msg.sender] = presaleLimit[msg.sender].sub(msg.value);
886         }
887         totalSold = totalSold.add(msg.value.mul(rate));
888     }
889 
890     function finalise() public {
891         require(hasEnded());
892         castedToken().finalise();
893     }
894 
895     function mintInvestmentFundAndMiscellaneous(
896         address _investmentFundWallet,
897         address _miscellaneousWallet
898     ) internal {
899         require(_investmentFundWallet != address(0));
900         require(_miscellaneousWallet != address(0));
901 
902         token.mint(_investmentFundWallet, INVESTMENT_FUND_TOKENS_SUPPLY);
903         token.mint(_miscellaneousWallet, MISCELLANEOUS_TOKENS_SUPPLY);
904     }
905 
906     function castedToken() internal view returns (CREDToken) {
907         return CREDToken(token);
908     }
909 
910     // Overrides Crowdsale#createTokenContract not to create new token
911     // CRED Token is created in the constructor
912     function createTokenContract() internal returns (MintableToken) {
913         return MintableToken(address(0));
914     }
915 
916     function validSalePurchase() internal view returns (bool) {
917         return super.validPurchase();
918     }
919 
920     function validPreSalePurchase() internal view returns (bool) {
921         if (msg.value > presaleLimit[msg.sender]) { return false; }
922         if (weiRaised.add(msg.value) > cap) { return false; }
923         if (now < presaleStartTime) { return false; }
924         if (now >= startTime) { return false; }
925         return true;
926     }
927 
928     // Overrides CappedCrowdsale#validPurchase to check if not paused
929     function validPurchase() internal view returns (bool) {
930         require(!paused);
931         return validSalePurchase() || validPreSalePurchase();
932     }
933 
934 }