1 //File: node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol
2 pragma solidity ^0.4.18;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 //File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
18 pragma solidity ^0.4.18;
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 //File: node_modules/zeppelin-solidity/contracts/token/BasicToken.sol
55 pragma solidity ^0.4.18;
56 
57 
58 
59 
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 //File: node_modules/zeppelin-solidity/contracts/token/ERC20.sol
99 pragma solidity ^0.4.18;
100 
101 
102 
103 
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 //File: node_modules/zeppelin-solidity/contracts/token/StandardToken.sol
117 pragma solidity ^0.4.18;
118 
119 
120 
121 
122 
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) internal allowed;
134 
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint256 the amount of tokens to be transferred
141    */
142   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[_from]);
145     require(_value <= allowed[_from][msg.sender]);
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150     Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    *
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) public view returns (uint256) {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181    * @dev Increase the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To increment
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _addedValue The amount of tokens to increase the allowance by.
189    */
190   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
191     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196   /**
197    * @dev Decrease the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To decrement
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _subtractedValue The amount of tokens to decrease the allowance by.
205    */
206   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 
219 //File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
220 pragma solidity ^0.4.18;
221 
222 
223 /**
224  * @title Ownable
225  * @dev The Ownable contract has an owner address, and provides basic authorization control
226  * functions, this simplifies the implementation of "user permissions".
227  */
228 contract Ownable {
229   address public owner;
230 
231 
232   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234 
235   /**
236    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
237    * account.
238    */
239   function Ownable() public {
240     owner = msg.sender;
241   }
242 
243 
244   /**
245    * @dev Throws if called by any account other than the owner.
246    */
247   modifier onlyOwner() {
248     require(msg.sender == owner);
249     _;
250   }
251 
252 
253   /**
254    * @dev Allows the current owner to transfer control of the contract to a newOwner.
255    * @param newOwner The address to transfer ownership to.
256    */
257   function transferOwnership(address newOwner) public onlyOwner {
258     require(newOwner != address(0));
259     OwnershipTransferred(owner, newOwner);
260     owner = newOwner;
261   }
262 
263 }
264 
265 //File: node_modules/zeppelin-solidity/contracts/token/MintableToken.sol
266 pragma solidity ^0.4.18;
267 
268 
269 
270 
271 
272 
273 
274 /**
275  * @title Mintable token
276  * @dev Simple ERC20 Token example, with mintable token creation
277  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
278  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
279  */
280 
281 contract MintableToken is StandardToken, Ownable {
282   event Mint(address indexed to, uint256 amount);
283   event MintFinished();
284 
285   bool public mintingFinished = false;
286 
287 
288   modifier canMint() {
289     require(!mintingFinished);
290     _;
291   }
292 
293   /**
294    * @dev Function to mint tokens
295    * @param _to The address that will receive the minted tokens.
296    * @param _amount The amount of tokens to mint.
297    * @return A boolean that indicates if the operation was successful.
298    */
299   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
300     totalSupply = totalSupply.add(_amount);
301     balances[_to] = balances[_to].add(_amount);
302     Mint(_to, _amount);
303     Transfer(address(0), _to, _amount);
304     return true;
305   }
306 
307   /**
308    * @dev Function to stop minting new tokens.
309    * @return True if the operation was successful.
310    */
311   function finishMinting() onlyOwner canMint public returns (bool) {
312     mintingFinished = true;
313     MintFinished();
314     return true;
315   }
316 }
317 
318 //File: node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
319 pragma solidity ^0.4.18;
320 
321 
322 
323 
324 /**
325  * @title Crowdsale
326  * @dev Crowdsale is a base contract for managing a token crowdsale.
327  * Crowdsales have a start and end timestamps, where investors can make
328  * token purchases and the crowdsale will assign them tokens based
329  * on a token per ETH rate. Funds collected are forwarded to a wallet
330  * as they arrive.
331  */
332 contract Crowdsale {
333   using SafeMath for uint256;
334 
335   // The token being sold
336   MintableToken public token;
337 
338   // start and end timestamps where investments are allowed (both inclusive)
339   uint256 public startTime;
340   uint256 public endTime;
341 
342   // address where funds are collected
343   address public wallet;
344 
345   // how many token units a buyer gets per wei
346   uint256 public rate;
347 
348   // amount of raised money in wei
349   uint256 public weiRaised;
350 
351   /**
352    * event for token purchase logging
353    * @param purchaser who paid for the tokens
354    * @param beneficiary who got the tokens
355    * @param value weis paid for purchase
356    * @param amount amount of tokens purchased
357    */
358   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
359 
360 
361   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
362     require(_startTime >= now);
363     require(_endTime >= _startTime);
364     require(_rate > 0);
365     require(_wallet != address(0));
366 
367     token = createTokenContract();
368     startTime = _startTime;
369     endTime = _endTime;
370     rate = _rate;
371     wallet = _wallet;
372   }
373 
374   // creates the token to be sold.
375   // override this method to have crowdsale of a specific mintable token.
376   function createTokenContract() internal returns (MintableToken) {
377     return new MintableToken();
378   }
379 
380 
381   // fallback function can be used to buy tokens
382   function () external payable {
383     buyTokens(msg.sender);
384   }
385 
386   // low level token purchase function
387   function buyTokens(address beneficiary) public payable {
388     require(beneficiary != address(0));
389     require(validPurchase());
390 
391     uint256 weiAmount = msg.value;
392 
393     // calculate token amount to be created
394     uint256 tokens = weiAmount.mul(rate);
395 
396     // update state
397     weiRaised = weiRaised.add(weiAmount);
398 
399     token.mint(beneficiary, tokens);
400     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
401 
402     forwardFunds();
403   }
404 
405   // send ether to the fund collection wallet
406   // override to create custom fund forwarding mechanisms
407   function forwardFunds() internal {
408     wallet.transfer(msg.value);
409   }
410 
411   // @return true if the transaction can buy tokens
412   function validPurchase() internal view returns (bool) {
413     bool withinPeriod = now >= startTime && now <= endTime;
414     bool nonZeroPurchase = msg.value != 0;
415     return withinPeriod && nonZeroPurchase;
416   }
417 
418   // @return true if crowdsale event has ended
419   function hasEnded() public view returns (bool) {
420     return now > endTime;
421   }
422 
423 
424 }
425 
426 //File: node_modules/zeppelin-solidity/contracts/token/SafeERC20.sol
427 pragma solidity ^0.4.18;
428 
429 
430 
431 
432 /**
433  * @title SafeERC20
434  * @dev Wrappers around ERC20 operations that throw on failure.
435  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
436  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
437  */
438 library SafeERC20 {
439   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
440     assert(token.transfer(to, value));
441   }
442 
443   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
444     assert(token.transferFrom(from, to, value));
445   }
446 
447   function safeApprove(ERC20 token, address spender, uint256 value) internal {
448     assert(token.approve(spender, value));
449   }
450 }
451 
452 //File: node_modules/zeppelin-solidity/contracts/token/TokenVesting.sol
453 pragma solidity ^0.4.18;
454 
455 
456 
457 
458 
459 
460 /**
461  * @title TokenVesting
462  * @dev A token holder contract that can release its token balance gradually like a
463  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
464  * owner.
465  */
466 contract TokenVesting is Ownable {
467   using SafeMath for uint256;
468   using SafeERC20 for ERC20Basic;
469 
470   event Released(uint256 amount);
471   event Revoked();
472 
473   // beneficiary of tokens after they are released
474   address public beneficiary;
475 
476   uint256 public cliff;
477   uint256 public start;
478   uint256 public duration;
479 
480   bool public revocable;
481 
482   mapping (address => uint256) public released;
483   mapping (address => bool) public revoked;
484 
485   /**
486    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
487    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
488    * of the balance will have vested.
489    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
490    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
491    * @param _duration duration in seconds of the period in which the tokens will vest
492    * @param _revocable whether the vesting is revocable or not
493    */
494   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
495     require(_beneficiary != address(0));
496     require(_cliff <= _duration);
497 
498     beneficiary = _beneficiary;
499     revocable = _revocable;
500     duration = _duration;
501     cliff = _start.add(_cliff);
502     start = _start;
503   }
504 
505   /**
506    * @notice Transfers vested tokens to beneficiary.
507    * @param token ERC20 token which is being vested
508    */
509   function release(ERC20Basic token) public {
510     uint256 unreleased = releasableAmount(token);
511 
512     require(unreleased > 0);
513 
514     released[token] = released[token].add(unreleased);
515 
516     token.safeTransfer(beneficiary, unreleased);
517 
518     Released(unreleased);
519   }
520 
521   /**
522    * @notice Allows the owner to revoke the vesting. Tokens already vested
523    * remain in the contract, the rest are returned to the owner.
524    * @param token ERC20 token which is being vested
525    */
526   function revoke(ERC20Basic token) public onlyOwner {
527     require(revocable);
528     require(!revoked[token]);
529 
530     uint256 balance = token.balanceOf(this);
531 
532     uint256 unreleased = releasableAmount(token);
533     uint256 refund = balance.sub(unreleased);
534 
535     revoked[token] = true;
536 
537     token.safeTransfer(owner, refund);
538 
539     Revoked();
540   }
541 
542   /**
543    * @dev Calculates the amount that has already vested but hasn't been released yet.
544    * @param token ERC20 token which is being vested
545    */
546   function releasableAmount(ERC20Basic token) public view returns (uint256) {
547     return vestedAmount(token).sub(released[token]);
548   }
549 
550   /**
551    * @dev Calculates the amount that has already vested.
552    * @param token ERC20 token which is being vested
553    */
554   function vestedAmount(ERC20Basic token) public view returns (uint256) {
555     uint256 currentBalance = token.balanceOf(this);
556     uint256 totalBalance = currentBalance.add(released[token]);
557 
558     if (now < cliff) {
559       return 0;
560     } else if (now >= start.add(duration) || revoked[token]) {
561       return totalBalance;
562     } else {
563       return totalBalance.mul(now.sub(start)).div(duration);
564     }
565   }
566 }
567 
568 //File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
569 pragma solidity ^0.4.18;
570 
571 
572 
573 
574 
575 /**
576  * @title Pausable
577  * @dev Base contract which allows children to implement an emergency stop mechanism.
578  */
579 contract Pausable is Ownable {
580   event Pause();
581   event Unpause();
582 
583   bool public paused = false;
584 
585 
586   /**
587    * @dev Modifier to make a function callable only when the contract is not paused.
588    */
589   modifier whenNotPaused() {
590     require(!paused);
591     _;
592   }
593 
594   /**
595    * @dev Modifier to make a function callable only when the contract is paused.
596    */
597   modifier whenPaused() {
598     require(paused);
599     _;
600   }
601 
602   /**
603    * @dev called by the owner to pause, triggers stopped state
604    */
605   function pause() onlyOwner whenNotPaused public {
606     paused = true;
607     Pause();
608   }
609 
610   /**
611    * @dev called by the owner to unpause, returns to normal state
612    */
613   function unpause() onlyOwner whenPaused public {
614     paused = false;
615     Unpause();
616   }
617 }
618 
619 //File: node_modules/zeppelin-solidity/contracts/token/PausableToken.sol
620 pragma solidity ^0.4.18;
621 
622 
623 
624 
625 /**
626  * @title Pausable token
627  *
628  * @dev StandardToken modified with pausable transfers.
629  **/
630 
631 contract PausableToken is StandardToken, Pausable {
632 
633   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
634     return super.transfer(_to, _value);
635   }
636 
637   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
638     return super.transferFrom(_from, _to, _value);
639   }
640 
641   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
642     return super.approve(_spender, _value);
643   }
644 
645   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
646     return super.increaseApproval(_spender, _addedValue);
647   }
648 
649   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
650     return super.decreaseApproval(_spender, _subtractedValue);
651   }
652 }
653 
654 //File: src/contracts/ico/MtnToken.sol
655 /**
656  * @title MTN token
657  *
658  * @version 1.0
659  * @author Validity Labs AG <info@validitylabs.org>
660  */
661 pragma solidity ^0.4.18;
662 
663 
664 
665 
666 contract MtnToken is MintableToken, PausableToken {
667     string public constant name = "MedToken";
668     string public constant symbol = "MTN";
669     uint8 public constant decimals = 18;
670 
671     /**
672      * @dev Constructor of MtnToken that instantiates a new Mintable Pauseable Token
673      */
674     function MtnToken() public {
675         // token should not be transferrable until after all tokens have been issued
676         paused = true;
677     }
678 }
679 
680 //File: src/contracts/ico/MtnCrowdsale.sol
681 /**
682  * @title MtnCrowdsale
683  *
684  * Simple time and TOKEN_CAPped based crowdsale.
685  *
686  * @version 1.0
687  * @author Validity Labs AG <info@validitylabs.org>
688  */
689 pragma solidity ^0.4.18;
690 
691 
692 
693 
694 
695 
696 contract MtnCrowdsale is Ownable, Crowdsale {
697     /*** CONSTANTS ***/
698     uint256 public constant TOTAL_TOKEN_CAP = 500e6 * 1e18;   // 500 million * 1e18 - smallest unit of MTN token
699     uint256 public constant CROWDSALE_TOKENS = 175e6 * 1e18;  // 175 million * 1e18 - presale and crowdsale tokens
700     uint256 public constant TOTAL_TEAM_TOKENS = 170e6 * 1e18; // 170 million * 1e18 - team tokens
701     uint256 public constant TEAM_TOKENS0 = 50e6 * 1e18;       // 50 million * 1e18 - team tokens, already vested
702     uint256 public constant TEAM_TOKENS1 = 60e6 * 1e18;       // 60 million * 1e18 - team tokens, vesting over 2 years
703     uint256 public constant TEAM_TOKENS2 = 60e6 * 1e18;       // 60 million * 1e18 - team tokens, vesting over 4 years
704     uint256 public constant COMMUNITY_TOKENS = 155e6 * 1e18;  // 155 million * 1e18 - community tokens, vesting over 4 years
705 
706     uint256 public constant MAX_CONTRIBUTION_USD = 5000;      //  USD
707     uint256 public constant USD_CENT_PER_TOKEN = 25;          // in cents - smallest unit of USD E.g. 100 = 1 USD
708 
709     uint256 public constant VESTING_DURATION_4Y = 4 years;
710     uint256 public constant VESTING_DURATION_2Y = 2 years;
711 
712     // true if address is allowed to invest
713     mapping(address => bool) public isWhitelisted;
714 
715     // allow managers to whitelist and confirm contributions by manager accounts
716     // managers can be set and altered by owner, multiple manager accounts are possible
717     mapping(address => bool) public isManager;
718 
719     uint256 public maxContributionInWei;
720     uint256 public tokensMinted;                            // already minted tokens (maximally = TOKEN_CAP)
721     bool public capReached;                                 // set to true when cap has been reached when minting tokens
722     mapping(address => uint256) public totalInvestedPerAddress;
723 
724     address public beneficiaryWallet;
725 
726     // for convenience we store vesting wallets
727     address public teamVesting2Years;
728     address public teamVesting4Years;
729     address public communityVesting4Years;
730 
731     /*** Tracking Crowdsale Stages ***/
732     bool public isCrowdsaleOver;
733 
734     /*** EVENTS  ***/
735     event ChangedManager(address manager, bool active);
736     event PresaleMinted(address indexed beneficiary, uint256 tokenAmount);
737     event ChangedInvestorWhitelisting(address indexed investor, bool whitelisted);
738 
739     /*** MODIFIERS ***/
740     modifier onlyManager() {
741         require(isManager[msg.sender]);
742         _;
743     }
744 
745     // trying to accompish using already existing variables to determine stage - prevents manual updating of the enum stage states
746     modifier onlyPresalePhase() {
747         require(now < startTime);
748         _;
749     }
750 
751     modifier onlyCrowdsalePhase() {
752         require(now >= startTime && now < endTime && !isCrowdsaleOver);
753         _;
754     }
755 
756     modifier respectCrowdsaleCap(uint256 _amount) {
757         require(tokensMinted.add(_amount) <= CROWDSALE_TOKENS);
758         _;
759     }
760 
761     modifier onlyCrowdSaleOver() {
762         require(isCrowdsaleOver || now > endTime || capReached);
763         _;
764     }
765 
766     modifier onlyValidAddress(address _address) {
767         require(_address != address(0));
768         _;
769     }
770 
771     /**
772      * @dev Deploy MTN Token Crowdsale
773      * @param _startTime uint256 Start time of the crowdsale
774      * @param _endTime uint256 End time of the crowdsale
775      * @param _usdPerEth uint256 issueing rate tokens per wei
776      * @param _wallet address Wallet address of the crowdsale
777      * @param _beneficiaryWallet address wallet holding team and community tokens
778      */
779     function MtnCrowdsale(
780         uint256 _startTime,
781         uint256 _endTime,
782         uint256 _usdPerEth,
783         address _wallet,
784         address _beneficiaryWallet
785         )
786         Crowdsale(_startTime, _endTime, (_usdPerEth.mul(1e2)).div(USD_CENT_PER_TOKEN), _wallet)
787         public
788         onlyValidAddress(_beneficiaryWallet)
789     {
790         require(TOTAL_TOKEN_CAP == CROWDSALE_TOKENS.add(TOTAL_TEAM_TOKENS).add(COMMUNITY_TOKENS));
791         require(TOTAL_TEAM_TOKENS == TEAM_TOKENS0.add(TEAM_TOKENS1).add(TEAM_TOKENS2));
792         setManager(msg.sender, true);
793 
794         beneficiaryWallet = _beneficiaryWallet;
795 
796         maxContributionInWei = (MAX_CONTRIBUTION_USD.mul(1e18)).div(_usdPerEth);
797 
798         mintTeamTokens();
799         mintCommunityTokens();
800     }
801 
802     /**
803      * @dev Create new instance of mtn token contract
804      */
805     function createTokenContract() internal returns (MintableToken) {
806         return new MtnToken();
807     }
808 
809     /**
810      * @dev Set / alter manager / whitelister "account". This can be done from owner only
811      * @param _manager address address of the manager to create/alter
812      * @param _active bool flag that shows if the manager account is active
813      */
814     function setManager(address _manager, bool _active) public onlyOwner onlyValidAddress(_manager) {
815         isManager[_manager] = _active;
816         ChangedManager(_manager, _active);
817     }
818 
819     /**
820      * @dev whitelist investors to allow the direct investment of this crowdsale
821      * @param _investor address address of the investor to be whitelisted
822      */
823     function whiteListInvestor(address _investor) public onlyManager onlyValidAddress(_investor) {
824         isWhitelisted[_investor] = true;
825         ChangedInvestorWhitelisting(_investor, true);
826     }
827 
828     /**
829      * @dev whitelist several investors via a batch method
830      * @param _investors address[] array of addresses of the beneficiaries to receive tokens after they have been confirmed
831      */
832     function batchWhiteListInvestors(address[] _investors) public onlyManager {
833         for (uint256 c; c < _investors.length; c = c.add(1)) {
834             whiteListInvestor(_investors[c]);
835         }
836     }
837 
838     /**
839      * @dev unwhitelist investor from participating in the crowdsale
840      * @param _investor address address of the investor to disallowed participation
841      */
842     function unWhiteListInvestor(address _investor) public onlyManager onlyValidAddress(_investor) {
843         isWhitelisted[_investor] = false;
844         ChangedInvestorWhitelisting(_investor, false);
845     }
846 
847    /**
848     * @dev onlyOwner allowed to mint tokens, respecting the cap, and only before the crowdsale starts
849     * @param _beneficiary address
850     * @param _amount uint256
851     */
852     function mintTokenPreSale(address _beneficiary, uint256 _amount) public onlyOwner onlyPresalePhase onlyValidAddress(_beneficiary) respectCrowdsaleCap(_amount) {
853         require(_amount > 0);
854 
855         tokensMinted = tokensMinted.add(_amount);
856         token.mint(_beneficiary, _amount);
857         PresaleMinted(_beneficiary, _amount);
858     }
859 
860    /**
861     * @dev onlyOwner allowed to handle batch presale minting
862     * @param _beneficiaries address[]
863     * @param _amounts uint256[]
864     */
865     function batchMintTokenPresale(address[] _beneficiaries, uint256[] _amounts) public onlyOwner onlyPresalePhase {
866         require(_beneficiaries.length == _amounts.length);
867 
868         for (uint256 i; i < _beneficiaries.length; i = i.add(1)) {
869             mintTokenPreSale(_beneficiaries[i], _amounts[i]);
870         }
871     }
872 
873    /**
874     * @dev override core functionality by whitelist check
875     * @param _beneficiary address
876     */
877     function buyTokens(address _beneficiary) public payable onlyCrowdsalePhase onlyValidAddress(_beneficiary) {
878         require(isWhitelisted[msg.sender]);
879         require(validPurchase());
880 
881         uint256 overflowTokens;
882         uint256 refundWeiAmount;
883         bool overMaxInvestmentAllowed;
884 
885         uint256 investedWeiAmount = msg.value;
886 
887         // Is this specific investment over the MAX_CONTRIBUTION_USD limit?
888         // if so, calcuate wei refunded and tokens to mint for the allowed investment amount
889         uint256 totalInvestedWeiAmount = investedWeiAmount.add(totalInvestedPerAddress[msg.sender]);
890         if (totalInvestedWeiAmount > maxContributionInWei) {
891             overMaxInvestmentAllowed = true;
892             refundWeiAmount = totalInvestedWeiAmount.sub(maxContributionInWei);
893             investedWeiAmount = investedWeiAmount.sub(refundWeiAmount);
894         }
895 
896         uint256 tokenAmount = investedWeiAmount.mul(rate);
897         uint256 tempMintedTokens = tokensMinted.add(tokenAmount); // gas optimization, do not inline twice
898 
899         // check to see if this purchase sets it over the crowdsale token cap
900         // if so, calculate tokens to mint, then refund the remaining ether investment
901         if (tempMintedTokens >= CROWDSALE_TOKENS) {
902             capReached = true;
903             overflowTokens = tempMintedTokens.sub(CROWDSALE_TOKENS);
904             tokenAmount = tokenAmount.sub(overflowTokens);
905             refundWeiAmount = overflowTokens.div(rate);
906             investedWeiAmount = investedWeiAmount.sub(refundWeiAmount);
907         }
908 
909         weiRaised = weiRaised.add(investedWeiAmount);
910 
911         tokensMinted = tokensMinted.add(tokenAmount);
912         TokenPurchase(msg.sender, _beneficiary, investedWeiAmount, tokenAmount);
913         totalInvestedPerAddress[msg.sender] = totalInvestedPerAddress[msg.sender].add(investedWeiAmount);
914         token.mint(_beneficiary, tokenAmount);
915 
916         // if investor breached cap and has remaining ether not invested
917         // refund remaining ether to investor
918         if (capReached || overMaxInvestmentAllowed) {
919             msg.sender.transfer(refundWeiAmount);
920             wallet.transfer(investedWeiAmount);
921         } else {
922             forwardFunds();
923         }
924     }
925 
926    /**
927     * @dev onlyOwner to close Crowdsale manually if before endTime
928     */
929     function closeCrowdsale() public onlyOwner onlyCrowdsalePhase {
930         isCrowdsaleOver = true;
931     }
932 
933    /**
934     * @dev onlyOwner allows tokens to be tradeable
935     */
936     function finalize() public onlyOwner onlyCrowdSaleOver {
937         // do not allow new owner to mint further tokens & unpause token to allow trading
938         MintableToken(token).finishMinting();
939         PausableToken(token).unpause();
940     }
941 
942     /*** INTERNAL/PRIVATE FUNCTIONS ***/
943 
944     /**
945      * @dev allows contract owner to mint all team tokens per TEAM_TOKENS and have 50m immediately available, 60m 2 years vested, and 60m over 4 years vesting
946      */
947     function mintTeamTokens() private {
948         token.mint(beneficiaryWallet, TEAM_TOKENS0);
949 
950         TokenVesting newVault1 = new TokenVesting(beneficiaryWallet, now, 0, VESTING_DURATION_2Y, false);
951         teamVesting2Years = address(newVault1); // for convenience we keep them in storage so that they are easily accessible via MEW or etherscan
952         token.mint(address(newVault1), TEAM_TOKENS1);
953 
954         TokenVesting newVault2 = new TokenVesting(beneficiaryWallet, now, 0, VESTING_DURATION_4Y, false);
955         teamVesting4Years = address(newVault2); // for convenience we keep them in storage so that they are easily accessible via MEW or etherscan
956         token.mint(address(newVault2), TEAM_TOKENS2);
957     }
958 
959     /**
960      * @dev allows contract owner to mint all community tokens per COMMUNITY_TOKENS and have the vested to the beneficiaryWallet
961      */
962     function mintCommunityTokens() private {
963         TokenVesting newVault = new TokenVesting(beneficiaryWallet, now, 0, VESTING_DURATION_4Y, false);
964         communityVesting4Years = address(newVault); // for convenience we keep them in storage so that they are easily accessible via MEW or etherscan
965         token.mint(address(newVault), COMMUNITY_TOKENS);
966     }
967 
968     /**
969      * @dev extend base functionality with min investment amount
970      */
971     function validPurchase() internal view respectCrowdsaleCap(0) returns (bool) {
972         require(!capReached);
973         require(totalInvestedPerAddress[msg.sender] < maxContributionInWei);
974 
975         return super.validPurchase();
976     }
977 }