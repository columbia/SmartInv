1 pragma solidity ^0.4.23;
2 
3 // File: contracts/NokuPricingPlan.sol
4 
5 /**
6 * @dev The NokuPricingPlan contract defines the responsibilities of a Noku pricing plan.
7 */
8 contract NokuPricingPlan {
9     /**
10     * @dev Pay the fee for the service identified by the specified name.
11     * The fee amount shall already be approved by the client.
12     * @param serviceName The name of the target service.
13     * @param multiplier The multiplier of the base service fee to apply.
14     * @param client The client of the target service.
15     * @return true if fee has been paid.
16     */
17     function payFee(bytes32 serviceName, uint256 multiplier, address client) public returns(bool paid);
18 
19     /**
20     * @dev Get the usage fee for the service identified by the specified name.
21     * The returned fee amount shall be approved before using #payFee method.
22     * @param serviceName The name of the target service.
23     * @param multiplier The multiplier of the base service fee to apply.
24     * @return The amount to approve before really paying such fee.
25     */
26     function usageFee(bytes32 serviceName, uint256 multiplier) public constant returns(uint fee);
27 }
28 
29 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) public onlyOwner {
64     require(newOwner != address(0));
65     emit OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 // File: contracts/NokuCustomToken.sol
72 
73 contract NokuCustomToken is Ownable {
74 
75     event LogBurnFinished();
76     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
77 
78     // The pricing plan determining the fee to be paid in NOKU tokens by customers for using Noku services
79     NokuPricingPlan public pricingPlan;
80 
81     // The entity acting as Custom Token service provider i.e. Noku
82     address public serviceProvider;
83 
84     // Flag indicating if Custom Token burning has been permanently finished or not.
85     bool public burningFinished;
86 
87     /**
88     * @dev Modifier to make a function callable only by service provider i.e. Noku.
89     */
90     modifier onlyServiceProvider() {
91         require(msg.sender == serviceProvider, "caller is not service provider");
92         _;
93     }
94 
95     modifier canBurn() {
96         require(!burningFinished, "burning finished");
97         _;
98     }
99 
100     constructor(address _pricingPlan, address _serviceProvider) internal {
101         require(_pricingPlan != 0, "_pricingPlan is zero");
102         require(_serviceProvider != 0, "_serviceProvider is zero");
103 
104         pricingPlan = NokuPricingPlan(_pricingPlan);
105         serviceProvider = _serviceProvider;
106     }
107 
108     /**
109     * @dev Presence of this function indicates the contract is a Custom Token.
110     */
111     function isCustomToken() public pure returns(bool isCustom) {
112         return true;
113     }
114 
115     /**
116     * @dev Stop burning new tokens.
117     * @return true if the operation was successful.
118     */
119     function finishBurning() public onlyOwner canBurn returns(bool finished) {
120         burningFinished = true;
121 
122         emit LogBurnFinished();
123 
124         return true;
125     }
126 
127     /**
128     * @dev Change the pricing plan of service fee to be paid in NOKU tokens.
129     * @param _pricingPlan The pricing plan of NOKU token to be paid, zero means flat subscription.
130     */
131     function setPricingPlan(address _pricingPlan) public onlyServiceProvider {
132         require(_pricingPlan != 0, "_pricingPlan is 0");
133         require(_pricingPlan != address(pricingPlan), "_pricingPlan == pricingPlan");
134 
135         pricingPlan = NokuPricingPlan(_pricingPlan);
136 
137         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
138     }
139 }
140 
141 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
142 
143 /**
144  * @title Pausable
145  * @dev Base contract which allows children to implement an emergency stop mechanism.
146  */
147 contract Pausable is Ownable {
148   event Pause();
149   event Unpause();
150 
151   bool public paused = false;
152 
153 
154   /**
155    * @dev Modifier to make a function callable only when the contract is not paused.
156    */
157   modifier whenNotPaused() {
158     require(!paused);
159     _;
160   }
161 
162   /**
163    * @dev Modifier to make a function callable only when the contract is paused.
164    */
165   modifier whenPaused() {
166     require(paused);
167     _;
168   }
169 
170   /**
171    * @dev called by the owner to pause, triggers stopped state
172    */
173   function pause() onlyOwner whenNotPaused public {
174     paused = true;
175     emit Pause();
176   }
177 
178   /**
179    * @dev called by the owner to unpause, returns to normal state
180    */
181   function unpause() onlyOwner whenPaused public {
182     paused = false;
183     emit Unpause();
184   }
185 }
186 
187 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
188 
189 /**
190  * @title SafeMath
191  * @dev Math operations with safety checks that throw on error
192  */
193 library SafeMath {
194 
195   /**
196   * @dev Multiplies two numbers, throws on overflow.
197   */
198   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
199     if (a == 0) {
200       return 0;
201     }
202     c = a * b;
203     assert(c / a == b);
204     return c;
205   }
206 
207   /**
208   * @dev Integer division of two numbers, truncating the quotient.
209   */
210   function div(uint256 a, uint256 b) internal pure returns (uint256) {
211     // assert(b > 0); // Solidity automatically throws when dividing by 0
212     // uint256 c = a / b;
213     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214     return a / b;
215   }
216 
217   /**
218   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
219   */
220   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
221     assert(b <= a);
222     return a - b;
223   }
224 
225   /**
226   * @dev Adds two numbers, throws on overflow.
227   */
228   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
229     c = a + b;
230     assert(c >= a);
231     return c;
232   }
233 }
234 
235 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
236 
237 /**
238  * @title ERC20Basic
239  * @dev Simpler version of ERC20 interface
240  * @dev see https://github.com/ethereum/EIPs/issues/179
241  */
242 contract ERC20Basic {
243   function totalSupply() public view returns (uint256);
244   function balanceOf(address who) public view returns (uint256);
245   function transfer(address to, uint256 value) public returns (bool);
246   event Transfer(address indexed from, address indexed to, uint256 value);
247 }
248 
249 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
250 
251 /**
252  * @title ERC20 interface
253  * @dev see https://github.com/ethereum/EIPs/issues/20
254  */
255 contract ERC20 is ERC20Basic {
256   function allowance(address owner, address spender) public view returns (uint256);
257   function transferFrom(address from, address to, uint256 value) public returns (bool);
258   function approve(address spender, uint256 value) public returns (bool);
259   event Approval(address indexed owner, address indexed spender, uint256 value);
260 }
261 
262 // File: contracts/NokuTokenBurner.sol
263 
264 contract BurnableERC20 is ERC20 {
265     function burn(uint256 amount) public returns (bool burned);
266 }
267 
268 /**
269 * @dev The NokuTokenBurner contract has the responsibility to burn the configured fraction of received
270 * ERC20-compliant tokens and distribute the remainder to the configured wallet.
271 */
272 contract NokuTokenBurner is Pausable {
273     using SafeMath for uint256;
274 
275     event LogNokuTokenBurnerCreated(address indexed caller, address indexed wallet);
276     event LogBurningPercentageChanged(address indexed caller, uint256 indexed burningPercentage);
277 
278     // The wallet receiving the unburnt tokens.
279     address public wallet;
280 
281     // The percentage of tokens to burn after being received (range [0, 100])
282     uint256 public burningPercentage;
283 
284     // The cumulative amount of burnt tokens.
285     uint256 public burnedTokens;
286 
287     // The cumulative amount of tokens transferred back to the wallet.
288     uint256 public transferredTokens;
289 
290     /**
291     * @dev Create a new NokuTokenBurner with predefined burning fraction.
292     * @param _wallet The wallet receiving the unburnt tokens.
293     */
294     constructor(address _wallet) public {
295         require(_wallet != address(0), "_wallet is zero");
296         
297         wallet = _wallet;
298         burningPercentage = 100;
299 
300         emit LogNokuTokenBurnerCreated(msg.sender, _wallet);
301     }
302 
303     /**
304     * @dev Change the percentage of tokens to burn after being received.
305     * @param _burningPercentage The percentage of tokens to be burnt.
306     */
307     function setBurningPercentage(uint256 _burningPercentage) public onlyOwner {
308         require(0 <= _burningPercentage && _burningPercentage <= 100, "_burningPercentage not in [0, 100]");
309         require(_burningPercentage != burningPercentage, "_burningPercentage equal to current one");
310         
311         burningPercentage = _burningPercentage;
312 
313         emit LogBurningPercentageChanged(msg.sender, _burningPercentage);
314     }
315 
316     /**
317     * @dev Called after burnable tokens has been transferred for burning.
318     * @param _token THe extended ERC20 interface supported by the sent tokens.
319     * @param _amount The amount of burnable tokens just arrived ready for burning.
320     */
321     function tokenReceived(address _token, uint256 _amount) public whenNotPaused {
322         require(_token != address(0), "_token is zero");
323         require(_amount > 0, "_amount is zero");
324 
325         uint256 amountToBurn = _amount.mul(burningPercentage).div(100);
326         if (amountToBurn > 0) {
327             assert(BurnableERC20(_token).burn(amountToBurn));
328             
329             burnedTokens = burnedTokens.add(amountToBurn);
330         }
331 
332         uint256 amountToTransfer = _amount.sub(amountToBurn);
333         if (amountToTransfer > 0) {
334             assert(BurnableERC20(_token).transfer(wallet, amountToTransfer));
335 
336             transferredTokens = transferredTokens.add(amountToTransfer);
337         }
338     }
339 }
340 
341 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
342 
343 /**
344  * @title Basic token
345  * @dev Basic version of StandardToken, with no allowances.
346  */
347 contract BasicToken is ERC20Basic {
348   using SafeMath for uint256;
349 
350   mapping(address => uint256) balances;
351 
352   uint256 totalSupply_;
353 
354   /**
355   * @dev total number of tokens in existence
356   */
357   function totalSupply() public view returns (uint256) {
358     return totalSupply_;
359   }
360 
361   /**
362   * @dev transfer token for a specified address
363   * @param _to The address to transfer to.
364   * @param _value The amount to be transferred.
365   */
366   function transfer(address _to, uint256 _value) public returns (bool) {
367     require(_to != address(0));
368     require(_value <= balances[msg.sender]);
369 
370     balances[msg.sender] = balances[msg.sender].sub(_value);
371     balances[_to] = balances[_to].add(_value);
372     emit Transfer(msg.sender, _to, _value);
373     return true;
374   }
375 
376   /**
377   * @dev Gets the balance of the specified address.
378   * @param _owner The address to query the the balance of.
379   * @return An uint256 representing the amount owned by the passed address.
380   */
381   function balanceOf(address _owner) public view returns (uint256) {
382     return balances[_owner];
383   }
384 
385 }
386 
387 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
388 
389 /**
390  * @title Burnable Token
391  * @dev Token that can be irreversibly burned (destroyed).
392  */
393 contract BurnableToken is BasicToken {
394 
395   event Burn(address indexed burner, uint256 value);
396 
397   /**
398    * @dev Burns a specific amount of tokens.
399    * @param _value The amount of token to be burned.
400    */
401   function burn(uint256 _value) public {
402     _burn(msg.sender, _value);
403   }
404 
405   function _burn(address _who, uint256 _value) internal {
406     require(_value <= balances[_who]);
407     // no need to require value <= totalSupply, since that would imply the
408     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
409 
410     balances[_who] = balances[_who].sub(_value);
411     totalSupply_ = totalSupply_.sub(_value);
412     emit Burn(_who, _value);
413     emit Transfer(_who, address(0), _value);
414   }
415 }
416 
417 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
418 
419 contract DetailedERC20 is ERC20 {
420   string public name;
421   string public symbol;
422   uint8 public decimals;
423 
424   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
425     name = _name;
426     symbol = _symbol;
427     decimals = _decimals;
428   }
429 }
430 
431 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
432 
433 /**
434  * @title Standard ERC20 token
435  *
436  * @dev Implementation of the basic standard token.
437  * @dev https://github.com/ethereum/EIPs/issues/20
438  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
439  */
440 contract StandardToken is ERC20, BasicToken {
441 
442   mapping (address => mapping (address => uint256)) internal allowed;
443 
444 
445   /**
446    * @dev Transfer tokens from one address to another
447    * @param _from address The address which you want to send tokens from
448    * @param _to address The address which you want to transfer to
449    * @param _value uint256 the amount of tokens to be transferred
450    */
451   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
452     require(_to != address(0));
453     require(_value <= balances[_from]);
454     require(_value <= allowed[_from][msg.sender]);
455 
456     balances[_from] = balances[_from].sub(_value);
457     balances[_to] = balances[_to].add(_value);
458     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
459     emit Transfer(_from, _to, _value);
460     return true;
461   }
462 
463   /**
464    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
465    *
466    * Beware that changing an allowance with this method brings the risk that someone may use both the old
467    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
468    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
469    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
470    * @param _spender The address which will spend the funds.
471    * @param _value The amount of tokens to be spent.
472    */
473   function approve(address _spender, uint256 _value) public returns (bool) {
474     allowed[msg.sender][_spender] = _value;
475     emit Approval(msg.sender, _spender, _value);
476     return true;
477   }
478 
479   /**
480    * @dev Function to check the amount of tokens that an owner allowed to a spender.
481    * @param _owner address The address which owns the funds.
482    * @param _spender address The address which will spend the funds.
483    * @return A uint256 specifying the amount of tokens still available for the spender.
484    */
485   function allowance(address _owner, address _spender) public view returns (uint256) {
486     return allowed[_owner][_spender];
487   }
488 
489   /**
490    * @dev Increase the amount of tokens that an owner allowed to a spender.
491    *
492    * approve should be called when allowed[_spender] == 0. To increment
493    * allowed value is better to use this function to avoid 2 calls (and wait until
494    * the first transaction is mined)
495    * From MonolithDAO Token.sol
496    * @param _spender The address which will spend the funds.
497    * @param _addedValue The amount of tokens to increase the allowance by.
498    */
499   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
500     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
501     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
502     return true;
503   }
504 
505   /**
506    * @dev Decrease the amount of tokens that an owner allowed to a spender.
507    *
508    * approve should be called when allowed[_spender] == 0. To decrement
509    * allowed value is better to use this function to avoid 2 calls (and wait until
510    * the first transaction is mined)
511    * From MonolithDAO Token.sol
512    * @param _spender The address which will spend the funds.
513    * @param _subtractedValue The amount of tokens to decrease the allowance by.
514    */
515   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
516     uint oldValue = allowed[msg.sender][_spender];
517     if (_subtractedValue > oldValue) {
518       allowed[msg.sender][_spender] = 0;
519     } else {
520       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
521     }
522     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
523     return true;
524   }
525 
526 }
527 
528 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
529 
530 /**
531  * @title Mintable token
532  * @dev Simple ERC20 Token example, with mintable token creation
533  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
534  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
535  */
536 contract MintableToken is StandardToken, Ownable {
537   event Mint(address indexed to, uint256 amount);
538   event MintFinished();
539 
540   bool public mintingFinished = false;
541 
542 
543   modifier canMint() {
544     require(!mintingFinished);
545     _;
546   }
547 
548   /**
549    * @dev Function to mint tokens
550    * @param _to The address that will receive the minted tokens.
551    * @param _amount The amount of tokens to mint.
552    * @return A boolean that indicates if the operation was successful.
553    */
554   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
555     totalSupply_ = totalSupply_.add(_amount);
556     balances[_to] = balances[_to].add(_amount);
557     emit Mint(_to, _amount);
558     emit Transfer(address(0), _to, _amount);
559     return true;
560   }
561 
562   /**
563    * @dev Function to stop minting new tokens.
564    * @return True if the operation was successful.
565    */
566   function finishMinting() onlyOwner canMint public returns (bool) {
567     mintingFinished = true;
568     emit MintFinished();
569     return true;
570   }
571 }
572 
573 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
574 
575 /**
576  * @title SafeERC20
577  * @dev Wrappers around ERC20 operations that throw on failure.
578  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
579  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
580  */
581 library SafeERC20 {
582   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
583     assert(token.transfer(to, value));
584   }
585 
586   function safeTransferFrom(
587     ERC20 token,
588     address from,
589     address to,
590     uint256 value
591   )
592     internal
593   {
594     assert(token.transferFrom(from, to, value));
595   }
596 
597   function safeApprove(ERC20 token, address spender, uint256 value) internal {
598     assert(token.approve(spender, value));
599   }
600 }
601 
602 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
603 
604 /**
605  * @title TokenTimelock
606  * @dev TokenTimelock is a token holder contract that will allow a
607  * beneficiary to extract the tokens after a given release time
608  */
609 contract TokenTimelock {
610   using SafeERC20 for ERC20Basic;
611 
612   // ERC20 basic token contract being held
613   ERC20Basic public token;
614 
615   // beneficiary of tokens after they are released
616   address public beneficiary;
617 
618   // timestamp when token release is enabled
619   uint256 public releaseTime;
620 
621   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
622     // solium-disable-next-line security/no-block-members
623     require(_releaseTime > block.timestamp);
624     token = _token;
625     beneficiary = _beneficiary;
626     releaseTime = _releaseTime;
627   }
628 
629   /**
630    * @notice Transfers tokens held by timelock to beneficiary.
631    */
632   function release() public {
633     // solium-disable-next-line security/no-block-members
634     require(block.timestamp >= releaseTime);
635 
636     uint256 amount = token.balanceOf(this);
637     require(amount > 0);
638 
639     token.safeTransfer(beneficiary, amount);
640   }
641 }
642 
643 // File: openzeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
644 
645 /* solium-disable security/no-block-members */
646 
647 pragma solidity ^0.4.21;
648 
649 
650 
651 
652 
653 
654 /**
655  * @title TokenVesting
656  * @dev A token holder contract that can release its token balance gradually like a
657  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
658  * owner.
659  */
660 contract TokenVesting is Ownable {
661   using SafeMath for uint256;
662   using SafeERC20 for ERC20Basic;
663 
664   event Released(uint256 amount);
665   event Revoked();
666 
667   // beneficiary of tokens after they are released
668   address public beneficiary;
669 
670   uint256 public cliff;
671   uint256 public start;
672   uint256 public duration;
673 
674   bool public revocable;
675 
676   mapping (address => uint256) public released;
677   mapping (address => bool) public revoked;
678 
679   /**
680    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
681    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
682    * of the balance will have vested.
683    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
684    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
685    * @param _duration duration in seconds of the period in which the tokens will vest
686    * @param _revocable whether the vesting is revocable or not
687    */
688   function TokenVesting(
689     address _beneficiary,
690     uint256 _start,
691     uint256 _cliff,
692     uint256 _duration,
693     bool _revocable
694   )
695     public
696   {
697     require(_beneficiary != address(0));
698     require(_cliff <= _duration);
699 
700     beneficiary = _beneficiary;
701     revocable = _revocable;
702     duration = _duration;
703     cliff = _start.add(_cliff);
704     start = _start;
705   }
706 
707   /**
708    * @notice Transfers vested tokens to beneficiary.
709    * @param token ERC20 token which is being vested
710    */
711   function release(ERC20Basic token) public {
712     uint256 unreleased = releasableAmount(token);
713 
714     require(unreleased > 0);
715 
716     released[token] = released[token].add(unreleased);
717 
718     token.safeTransfer(beneficiary, unreleased);
719 
720     emit Released(unreleased);
721   }
722 
723   /**
724    * @notice Allows the owner to revoke the vesting. Tokens already vested
725    * remain in the contract, the rest are returned to the owner.
726    * @param token ERC20 token which is being vested
727    */
728   function revoke(ERC20Basic token) public onlyOwner {
729     require(revocable);
730     require(!revoked[token]);
731 
732     uint256 balance = token.balanceOf(this);
733 
734     uint256 unreleased = releasableAmount(token);
735     uint256 refund = balance.sub(unreleased);
736 
737     revoked[token] = true;
738 
739     token.safeTransfer(owner, refund);
740 
741     emit Revoked();
742   }
743 
744   /**
745    * @dev Calculates the amount that has already vested but hasn't been released yet.
746    * @param token ERC20 token which is being vested
747    */
748   function releasableAmount(ERC20Basic token) public view returns (uint256) {
749     return vestedAmount(token).sub(released[token]);
750   }
751 
752   /**
753    * @dev Calculates the amount that has already vested.
754    * @param token ERC20 token which is being vested
755    */
756   function vestedAmount(ERC20Basic token) public view returns (uint256) {
757     uint256 currentBalance = token.balanceOf(this);
758     uint256 totalBalance = currentBalance.add(released[token]);
759 
760     if (block.timestamp < cliff) {
761       return 0;
762     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
763       return totalBalance;
764     } else {
765       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
766     }
767   }
768 }
769 
770 // File: contracts/NokuCustomERC20.sol
771 
772 /**
773 * @dev The NokuCustomERC20Token contract is a custom ERC20-compliant token available in the Noku Service Platform (NSP).
774 * The Noku customer is able to choose the token name, symbol, decimals, initial supply and to administer its lifecycle
775 * by minting or burning tokens in order to increase or decrease the token supply.
776 */
777 contract NokuCustomERC20 is NokuCustomToken, DetailedERC20, MintableToken, BurnableToken {
778     using SafeMath for uint256;
779 
780     event LogNokuCustomERC20Created(
781         address indexed caller,
782         string indexed name,
783         string indexed symbol,
784         uint8 decimals,
785         uint256 transferableFromBlock,
786         uint256 lockEndBlock,
787         address pricingPlan,
788         address serviceProvider
789     );
790     event LogMintingFeeEnabledChanged(address indexed caller, bool indexed mintingFeeEnabled);
791     event LogInformationChanged(address indexed caller, string name, string symbol);
792     event LogTransferFeePaymentFinished(address indexed caller);
793     event LogTransferFeePercentageChanged(address indexed caller, uint256 indexed transferFeePercentage);
794 
795     // Flag indicating if minting fees are enabled or disabled
796     bool public mintingFeeEnabled;
797 
798     // Block number from which tokens are initially transferable
799     uint256 public transferableFromBlock;
800 
801     // Block number from which initial lock ends
802     uint256 public lockEndBlock;
803 
804     // The initially locked balances by address
805     mapping (address => uint256) public initiallyLockedBalanceOf;
806 
807     // The fee percentage for Custom Token transfer or zero if transfer is free of charge
808     uint256 public transferFeePercentage;
809 
810     // Flag indicating if fee payment in Custom Token transfer has been permanently finished or not. 
811     bool public transferFeePaymentFinished;
812 
813     bytes32 public constant BURN_SERVICE_NAME = "NokuCustomERC20.burn";
814     bytes32 public constant MINT_SERVICE_NAME = "NokuCustomERC20.mint";
815 
816     modifier canTransfer(address _from, uint _value) {
817         require(block.number >= transferableFromBlock, "token not transferable");
818 
819         if (block.number < lockEndBlock) {
820             uint256 locked = lockedBalanceOf(_from);
821             if (locked > 0) {
822                 uint256 newBalance = balanceOf(_from).sub(_value);
823                 require(newBalance >= locked, "_value exceeds locked amount");
824             }
825         }
826         _;
827     }
828 
829     constructor(
830         string _name,
831         string _symbol,
832         uint8 _decimals,
833         uint256 _transferableFromBlock,
834         uint256 _lockEndBlock,
835         address _pricingPlan,
836         address _serviceProvider
837     )
838     NokuCustomToken(_pricingPlan, _serviceProvider)
839     DetailedERC20(_name, _symbol, _decimals) public
840     {
841         require(bytes(_name).length > 0, "_name is empty");
842         require(bytes(_symbol).length > 0, "_symbol is empty");
843         require(_lockEndBlock >= _transferableFromBlock, "_lockEndBlock lower than _transferableFromBlock");
844 
845         transferableFromBlock = _transferableFromBlock;
846         lockEndBlock = _lockEndBlock;
847         mintingFeeEnabled = true;
848 
849         emit LogNokuCustomERC20Created(
850             msg.sender,
851             _name,
852             _symbol,
853             _decimals,
854             _transferableFromBlock,
855             _lockEndBlock,
856             _pricingPlan,
857             _serviceProvider
858         );
859     }
860 
861     function setMintingFeeEnabled(bool _mintingFeeEnabled) public onlyOwner returns(bool successful) {
862         require(_mintingFeeEnabled != mintingFeeEnabled, "_mintingFeeEnabled == mintingFeeEnabled");
863 
864         mintingFeeEnabled = _mintingFeeEnabled;
865 
866         emit LogMintingFeeEnabledChanged(msg.sender, _mintingFeeEnabled);
867 
868         return true;
869     }
870 
871     /**
872     * @dev Change the Custom Token detailed information after creation.
873     * @param _name The name to assign to the Custom Token.
874     * @param _symbol The symbol to assign to the Custom Token.
875     */
876     function setInformation(string _name, string _symbol) public onlyOwner returns(bool successful) {
877         require(bytes(_name).length > 0, "_name is empty");
878         require(bytes(_symbol).length > 0, "_symbol is empty");
879 
880         name = _name;
881         symbol = _symbol;
882 
883         emit LogInformationChanged(msg.sender, _name, _symbol);
884 
885         return true;
886     }
887 
888     /**
889     * @dev Stop trasfer fee payment for tokens.
890     * @return true if the operation was successful.
891     */
892     function finishTransferFeePayment() public onlyOwner returns(bool finished) {
893         require(!transferFeePaymentFinished, "transfer fee finished");
894 
895         transferFeePaymentFinished = true;
896 
897         emit LogTransferFeePaymentFinished(msg.sender);
898 
899         return true;
900     }
901 
902     /**
903     * @dev Change the transfer fee percentage to be paid in Custom tokens.
904     * @param _transferFeePercentage The fee percentage to be paid for transfer in range [0, 100].
905     */
906     function setTransferFeePercentage(uint256 _transferFeePercentage) public onlyOwner {
907         require(0 <= _transferFeePercentage && _transferFeePercentage <= 100, "_transferFeePercentage not in [0, 100]");
908         require(_transferFeePercentage != transferFeePercentage, "_transferFeePercentage equal to current value");
909 
910         transferFeePercentage = _transferFeePercentage;
911 
912         emit LogTransferFeePercentageChanged(msg.sender, _transferFeePercentage);
913     }
914 
915     function lockedBalanceOf(address _to) public constant returns(uint256 locked) {
916         uint256 initiallyLocked = initiallyLockedBalanceOf[_to];
917         if (block.number >= lockEndBlock) return 0;
918         else if (block.number <= transferableFromBlock) return initiallyLocked;
919 
920         uint256 releaseForBlock = initiallyLocked.div(lockEndBlock.sub(transferableFromBlock));
921         uint256 released = block.number.sub(transferableFromBlock).mul(releaseForBlock);
922         return initiallyLocked.sub(released);
923     }
924 
925     /**
926     * @dev Get the fee to be paid for the transfer of NOKU tokens.
927     * @param _value The amount of NOKU tokens to be transferred.
928     */
929     function transferFee(uint256 _value) public view returns(uint256 usageFee) {
930         return _value.mul(transferFeePercentage).div(100);
931     }
932 
933     /**
934     * @dev Check if token transfer is free of any charge or not.
935     * @return true if transfer is free of any charge.
936     */
937     function freeTransfer() public view returns (bool isTransferFree) {
938         return transferFeePaymentFinished || transferFeePercentage == 0;
939     }
940 
941     /**
942     * @dev Override #transfer for optionally paying fee to Custom token owner.
943     */
944     function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns(bool transferred) {
945         if (freeTransfer()) {
946             return super.transfer(_to, _value);
947         }
948         else {
949             uint256 usageFee = transferFee(_value);
950             uint256 netValue = _value.sub(usageFee);
951 
952             bool feeTransferred = super.transfer(owner, usageFee);
953             bool netValueTransferred = super.transfer(_to, netValue);
954 
955             return feeTransferred && netValueTransferred;
956         }
957     }
958 
959     /**
960     * @dev Override #transferFrom for optionally paying fee to Custom token owner.
961     */
962     function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns(bool transferred) {
963         if (freeTransfer()) {
964             return super.transferFrom(_from, _to, _value);
965         }
966         else {
967             uint256 usageFee = transferFee(_value);
968             uint256 netValue = _value.sub(usageFee);
969 
970             bool feeTransferred = super.transferFrom(_from, owner, usageFee);
971             bool netValueTransferred = super.transferFrom(_from, _to, netValue);
972 
973             return feeTransferred && netValueTransferred;
974         }
975     }
976 
977     /**
978     * @dev Burn a specific amount of tokens, paying the service fee.
979     * @param _amount The amount of token to be burned.
980     */
981     function burn(uint256 _amount) public canBurn {
982         require(_amount > 0, "_amount is zero");
983 
984         super.burn(_amount);
985 
986         require(pricingPlan.payFee(BURN_SERVICE_NAME, _amount, msg.sender), "burn fee failed");
987     }
988 
989     /**
990     * @dev Mint a specific amount of tokens, paying the service fee.
991     * @param _to The address that will receive the minted tokens.
992     * @param _amount The amount of tokens to mint.
993     * @return A boolean that indicates if the operation was successful.
994     */
995     function mint(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {
996         require(_to != 0, "_to is zero");
997         require(_amount > 0, "_amount is zero");
998 
999         super.mint(_to, _amount);
1000 
1001         if (mintingFeeEnabled) {
1002             require(pricingPlan.payFee(MINT_SERVICE_NAME, _amount, msg.sender), "mint fee failed");
1003         }
1004 
1005         return true;
1006     }
1007 
1008     /**
1009     * @dev Mint new locked tokens, which will unlock progressively.
1010     * @param _to The address that will receieve the minted locked tokens.
1011     * @param _amount The amount of tokens to mint.
1012     * @return A boolean that indicates if the operation was successful.
1013     */
1014     function mintLocked(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {
1015         initiallyLockedBalanceOf[_to] = initiallyLockedBalanceOf[_to].add(_amount);
1016         
1017         return mint(_to, _amount);
1018     }
1019 
1020     /**
1021      * @dev Mint timelocked tokens.
1022      * @param _to The address that will receieve the minted locked tokens.
1023      * @param _amount The amount of tokens to mint.
1024      * @param _releaseTime The token release time as timestamp from Unix epoch.
1025      * @return A boolean that indicates if the operation was successful.
1026      */
1027     /*function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public onlyOwner canMint
1028     returns (TokenTimelock tokenTimelock)
1029     {
1030         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
1031         mint(timelock, _amount);
1032 
1033         return timelock;
1034     }*/
1035 
1036     /**
1037     * @dev Mint vested tokens.
1038     * @param _to The address that will receieve the minted vested tokens.
1039     * @param _amount The amount of tokens to mint.
1040     * @param _startTime When the vesting starts as timestamp in seconds from Unix epoch.
1041     * @param _duration The duration in seconds of the period in which the tokens will vest.
1042     * @return A boolean that indicates if the operation was successful.
1043     */
1044     /*function mintVested(address _to, uint256 _amount, uint256 _startTime, uint256 _duration) public onlyOwner canMint
1045     returns (TokenVesting tokenVesting)
1046     {
1047         TokenVesting vesting = new TokenVesting(_to, _startTime, 0, _duration, true);
1048         mint(vesting, _amount);
1049 
1050         return vesting;
1051     }*/
1052 
1053     /**
1054      * @dev Release vested tokens to beneficiary.
1055      * @param _vesting The token vesting to release.
1056      */
1057     /*function releaseVested(TokenVesting _vesting) public {
1058         require(_vesting != address(0));
1059 
1060         _vesting.release(this);
1061     }*/
1062 
1063     /**
1064      * @dev Revoke vested tokens. Just the token can revoke because it is the vesting owner.
1065      * @param _vesting The token vesting to revoke.
1066      */
1067     /*function revokeVested(TokenVesting _vesting) public onlyOwner {
1068         require(_vesting != address(0));
1069 
1070         _vesting.revoke(this);
1071     }*/
1072 }
1073 
1074 // File: openzeppelin-solidity/contracts/AddressUtils.sol
1075 
1076 /**
1077  * Utility library of inline functions on addresses
1078  */
1079 library AddressUtils {
1080 
1081   /**
1082    * Returns whether the target address is a contract
1083    * @dev This function will return false if invoked during the constructor of a contract,
1084    *  as the code is not actually created until after the constructor finishes.
1085    * @param addr address to check
1086    * @return whether the target address is a contract
1087    */
1088   function isContract(address addr) internal view returns (bool) {
1089     uint256 size;
1090     // XXX Currently there is no better way to check if there is a contract in an address
1091     // than to check the size of the code at that address.
1092     // See https://ethereum.stackexchange.com/a/14016/36603
1093     // for more details about how this works.
1094     // TODO Check this again before the Serenity release, because all addresses will be
1095     // contracts then.
1096     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
1097     return size > 0;
1098   }
1099 
1100 }
1101 
1102 // File: contracts/NokuCustomService.sol
1103 
1104 contract NokuCustomService is Pausable {
1105     using AddressUtils for address;
1106 
1107     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
1108 
1109     // The pricing plan determining the fee to be paid in NOKU tokens by customers
1110     NokuPricingPlan public pricingPlan;
1111 
1112     constructor(address _pricingPlan) internal {
1113         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
1114 
1115         pricingPlan = NokuPricingPlan(_pricingPlan);
1116     }
1117 
1118     function setPricingPlan(address _pricingPlan) public onlyOwner {
1119         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
1120         require(NokuPricingPlan(_pricingPlan) != pricingPlan, "_pricingPlan equal to current");
1121         
1122         pricingPlan = NokuPricingPlan(_pricingPlan);
1123 
1124         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
1125     }
1126 }
1127 
1128 // File: contracts/NokuCustomERC20Service.sol
1129 
1130 /**
1131 * @dev The NokuCustomERC2Service contract .
1132 */
1133 contract NokuCustomERC20Service is NokuCustomService {
1134     event LogNokuCustomERC20ServiceCreated(address caller, address indexed pricingPlan);
1135 
1136     uint256 public constant CREATE_AMOUNT = 1 * 10**18;
1137 
1138     uint8 public constant DECIMALS = 18;
1139 
1140     bytes32 public constant CUSTOM_ERC20_CREATE_SERVICE_NAME = "NokuCustomERC20.create";
1141 
1142     constructor(address _pricingPlan) NokuCustomService(_pricingPlan) public {
1143         emit LogNokuCustomERC20ServiceCreated(msg.sender, _pricingPlan);
1144     }
1145 
1146     // TODO: REMOVE
1147     function createCustomToken(string _name, string _symbol, uint8 /*_decimals*/) public returns(NokuCustomERC20 customToken) {
1148         customToken = new NokuCustomERC20(
1149             _name,
1150             _symbol,
1151             DECIMALS,
1152             block.number,
1153             block.number,
1154             pricingPlan,
1155             owner
1156         );
1157 
1158         // Transfer NokuCustomERC20 ownership to the client
1159         customToken.transferOwnership(msg.sender);
1160 
1161         require(pricingPlan.payFee(CUSTOM_ERC20_CREATE_SERVICE_NAME, CREATE_AMOUNT, msg.sender), "fee payment failed");
1162     }
1163 
1164     function createCustomToken(
1165         string _name,
1166         string _symbol,
1167         uint8 /*_decimals*/,
1168         uint256 transferableFromBlock,
1169         uint256 lockEndBlock
1170     )
1171     public returns(NokuCustomERC20 customToken)
1172     {
1173         customToken = new NokuCustomERC20(
1174             _name,
1175             _symbol,
1176             DECIMALS,
1177             transferableFromBlock,
1178             lockEndBlock,
1179             pricingPlan,
1180             owner
1181         );
1182 
1183         // Transfer NokuCustomERC20 ownership to the client
1184         customToken.transferOwnership(msg.sender);
1185 
1186         require(pricingPlan.payFee(CUSTOM_ERC20_CREATE_SERVICE_NAME, CREATE_AMOUNT, msg.sender), "fee payment failed");
1187     }
1188 }