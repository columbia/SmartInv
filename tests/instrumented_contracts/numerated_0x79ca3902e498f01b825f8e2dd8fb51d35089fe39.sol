1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
31 
32 /**
33  * @title SafeERC20
34  * @dev Wrappers around ERC20 operations that throw on failure.
35  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
36  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
37  */
38 library SafeERC20 {
39   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
40     assert(token.transfer(to, value));
41   }
42 
43   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
44     assert(token.transferFrom(from, to, value));
45   }
46 
47   function safeApprove(ERC20 token, address spender, uint256 value) internal {
48     assert(token.approve(spender, value));
49   }
50 }
51 
52 // File: zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
53 
54 /**
55  * @title TokenTimelock
56  * @dev TokenTimelock is a token holder contract that will allow a
57  * beneficiary to extract the tokens after a given release time
58  */
59 contract TokenTimelock {
60   using SafeERC20 for ERC20Basic;
61 
62   // ERC20 basic token contract being held
63   ERC20Basic public token;
64 
65   // beneficiary of tokens after they are released
66   address public beneficiary;
67 
68   // timestamp when token release is enabled
69   uint256 public releaseTime;
70 
71   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
72     require(_releaseTime > now);
73     token = _token;
74     beneficiary = _beneficiary;
75     releaseTime = _releaseTime;
76   }
77 
78   /**
79    * @notice Transfers tokens held by timelock to beneficiary.
80    */
81   function release() public {
82     require(now >= releaseTime);
83 
84     uint256 amount = token.balanceOf(this);
85     require(amount > 0);
86 
87     token.safeTransfer(beneficiary, amount);
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
140 
141 /**
142  * @title Ownable
143  * @dev The Ownable contract has an owner address, and provides basic authorization control
144  * functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147   address public owner;
148 
149 
150   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   function Ownable() public {
158     owner = msg.sender;
159   }
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) public onlyOwner {
174     require(newOwner != address(0));
175     OwnershipTransferred(owner, newOwner);
176     owner = newOwner;
177   }
178 
179 }
180 
181 // File: zeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
182 
183 /**
184  * @title TokenVesting
185  * @dev A token holder contract that can release its token balance gradually like a
186  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
187  * owner.
188  */
189 contract TokenVesting is Ownable {
190   using SafeMath for uint256;
191   using SafeERC20 for ERC20Basic;
192 
193   event Released(uint256 amount);
194   event Revoked();
195 
196   // beneficiary of tokens after they are released
197   address public beneficiary;
198 
199   uint256 public cliff;
200   uint256 public start;
201   uint256 public duration;
202 
203   bool public revocable;
204 
205   mapping (address => uint256) public released;
206   mapping (address => bool) public revoked;
207 
208   /**
209    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
210    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
211    * of the balance will have vested.
212    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
213    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
214    * @param _duration duration in seconds of the period in which the tokens will vest
215    * @param _revocable whether the vesting is revocable or not
216    */
217   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
218     require(_beneficiary != address(0));
219     require(_cliff <= _duration);
220 
221     beneficiary = _beneficiary;
222     revocable = _revocable;
223     duration = _duration;
224     cliff = _start.add(_cliff);
225     start = _start;
226   }
227 
228   /**
229    * @notice Transfers vested tokens to beneficiary.
230    * @param token ERC20 token which is being vested
231    */
232   function release(ERC20Basic token) public {
233     uint256 unreleased = releasableAmount(token);
234 
235     require(unreleased > 0);
236 
237     released[token] = released[token].add(unreleased);
238 
239     token.safeTransfer(beneficiary, unreleased);
240 
241     Released(unreleased);
242   }
243 
244   /**
245    * @notice Allows the owner to revoke the vesting. Tokens already vested
246    * remain in the contract, the rest are returned to the owner.
247    * @param token ERC20 token which is being vested
248    */
249   function revoke(ERC20Basic token) public onlyOwner {
250     require(revocable);
251     require(!revoked[token]);
252 
253     uint256 balance = token.balanceOf(this);
254 
255     uint256 unreleased = releasableAmount(token);
256     uint256 refund = balance.sub(unreleased);
257 
258     revoked[token] = true;
259 
260     token.safeTransfer(owner, refund);
261 
262     Revoked();
263   }
264 
265   /**
266    * @dev Calculates the amount that has already vested but hasn't been released yet.
267    * @param token ERC20 token which is being vested
268    */
269   function releasableAmount(ERC20Basic token) public view returns (uint256) {
270     return vestedAmount(token).sub(released[token]);
271   }
272 
273   /**
274    * @dev Calculates the amount that has already vested.
275    * @param token ERC20 token which is being vested
276    */
277   function vestedAmount(ERC20Basic token) public view returns (uint256) {
278     uint256 currentBalance = token.balanceOf(this);
279     uint256 totalBalance = currentBalance.add(released[token]);
280 
281     if (now < cliff) {
282       return 0;
283     } else if (now >= start.add(duration) || revoked[token]) {
284       return totalBalance;
285     } else {
286       return totalBalance.mul(now.sub(start)).div(duration);
287     }
288   }
289 }
290 
291 // File: contracts/InitialTokenDistribution.sol
292 
293 contract InitialTokenDistribution is Ownable {
294     using SafeMath for uint256;
295 
296     ERC20 public token;
297     mapping (address => TokenTimelock) public timelocked;
298     mapping (address => uint256) public initiallyDistributed;
299     bool public initialDistributionDone = false;
300 
301     modifier onInitialDistribution() {
302         require(!initialDistributionDone);
303         _;
304     }
305 
306     function InitialTokenDistribution(
307         ERC20 _token
308     ) public {
309         token = _token;
310     }
311 
312     /**
313      * @dev override for initial distribution logic
314      */
315     function initialDistribution() internal;
316 
317     /**
318      * @dev override for initial distribution logic
319      */
320     function totalTokensDistributed() view public returns (uint256);
321 
322     /**
323      * @dev call to initialize distribution  ***DO NOT OVERRIDE***
324      */
325     function processInitialDistribution() onInitialDistribution public onlyOwner {
326         initialDistribution();
327         initialDistributionDone = true;
328     }
329 
330     function initialTransfer(address to, uint256 amount) public onInitialDistribution {
331         require(to != address(0));
332         initiallyDistributed[to] = amount;
333         token.transferFrom(msg.sender, to, amount);
334     }
335 
336     function lock(address to, uint256 amount, uint256 releaseTime) public onInitialDistribution {
337         require(to != address(0));
338         timelocked[to] = new TokenTimelock(token, to, releaseTime);
339         token.transferFrom(msg.sender, address(timelocked[to]), amount);
340     }
341 }
342 
343 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
344 
345 contract DetailedERC20 is ERC20 {
346   string public name;
347   string public symbol;
348   uint8 public decimals;
349 
350   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
351     name = _name;
352     symbol = _symbol;
353     decimals = _decimals;
354   }
355 }
356 
357 // File: contracts/AbacasInitialTokenDistribution.sol
358 
359 contract AbacasInitialTokenDistribution is InitialTokenDistribution {
360 
361     uint256 public reservedTokensFutureSale;
362     uint256 public reservedTokensCommunity;
363     uint256 public reservedTokensFoundation;
364     uint256 public reservedTokensFounders;
365     uint256 public reservedTokensPublicPrivateSale;
366 
367     address public futureSaleWallet;
368     address public communityWallet;
369     address public foundationWallet;
370     address public foundersWallet;
371     address public publicPrivateSaleWallet;
372     uint256 foundersLockStartTime;
373     uint256 foundersLockPeriod;
374 
375     function AbacasInitialTokenDistribution(
376         DetailedERC20 _token,
377         address _futureSaleWallet,
378         address _communityWallet,
379         address _foundationWallet,
380         address _foundersWallet,
381         address _publicPrivateSaleWallet,
382         uint256 _foundersLockStartTime,
383         uint256 _foundersLockPeriod
384     )
385         public
386         InitialTokenDistribution(_token)
387     {
388         futureSaleWallet = _futureSaleWallet;
389         communityWallet = _communityWallet;
390         foundationWallet = _foundationWallet;
391         foundersWallet = _foundersWallet;
392         publicPrivateSaleWallet = _publicPrivateSaleWallet;
393         foundersLockStartTime = _foundersLockStartTime;
394         foundersLockPeriod = _foundersLockPeriod;
395 
396         uint8 decimals = _token.decimals();
397         reservedTokensFutureSale = 45e6 * (10 ** uint256(decimals));
398         reservedTokensCommunity = 10e6 * (10 ** uint256(decimals));
399         reservedTokensFoundation = 10e6 * (10 ** uint256(decimals));
400         reservedTokensFounders = 5e6 * (10 ** uint256(decimals));
401         reservedTokensPublicPrivateSale = 30e6 * (10 ** uint256(decimals));
402     }
403 
404     function initialDistribution() internal {
405         initialTransfer(futureSaleWallet, reservedTokensFutureSale);
406         initialTransfer(communityWallet, reservedTokensCommunity);
407         initialTransfer(foundationWallet, reservedTokensFoundation);
408         initialTransfer(publicPrivateSaleWallet, reservedTokensPublicPrivateSale);
409         lock(foundersWallet, reservedTokensFounders, foundersLockStartTime + foundersLockPeriod);
410     }
411 
412     function totalTokensDistributed() view public returns (uint256) {
413         // solium-disable-next-line max-len
414         return reservedTokensFutureSale + reservedTokensCommunity + reservedTokensFoundation + reservedTokensFounders + reservedTokensPublicPrivateSale;
415     }
416 }
417 
418 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
419 
420 /**
421  * @title Pausable
422  * @dev Base contract which allows children to implement an emergency stop mechanism.
423  */
424 contract Pausable is Ownable {
425   event Pause();
426   event Unpause();
427 
428   bool public paused = false;
429 
430 
431   /**
432    * @dev Modifier to make a function callable only when the contract is not paused.
433    */
434   modifier whenNotPaused() {
435     require(!paused);
436     _;
437   }
438 
439   /**
440    * @dev Modifier to make a function callable only when the contract is paused.
441    */
442   modifier whenPaused() {
443     require(paused);
444     _;
445   }
446 
447   /**
448    * @dev called by the owner to pause, triggers stopped state
449    */
450   function pause() onlyOwner whenNotPaused public {
451     paused = true;
452     Pause();
453   }
454 
455   /**
456    * @dev called by the owner to unpause, returns to normal state
457    */
458   function unpause() onlyOwner whenPaused public {
459     paused = false;
460     Unpause();
461   }
462 }
463 
464 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
465 
466 /**
467  * @title Basic token
468  * @dev Basic version of StandardToken, with no allowances.
469  */
470 contract BasicToken is ERC20Basic {
471   using SafeMath for uint256;
472 
473   mapping(address => uint256) balances;
474 
475   uint256 totalSupply_;
476 
477   /**
478   * @dev total number of tokens in existence
479   */
480   function totalSupply() public view returns (uint256) {
481     return totalSupply_;
482   }
483 
484   /**
485   * @dev transfer token for a specified address
486   * @param _to The address to transfer to.
487   * @param _value The amount to be transferred.
488   */
489   function transfer(address _to, uint256 _value) public returns (bool) {
490     require(_to != address(0));
491     require(_value <= balances[msg.sender]);
492 
493     // SafeMath.sub will throw if there is not enough balance.
494     balances[msg.sender] = balances[msg.sender].sub(_value);
495     balances[_to] = balances[_to].add(_value);
496     Transfer(msg.sender, _to, _value);
497     return true;
498   }
499 
500   /**
501   * @dev Gets the balance of the specified address.
502   * @param _owner The address to query the the balance of.
503   * @return An uint256 representing the amount owned by the passed address.
504   */
505   function balanceOf(address _owner) public view returns (uint256 balance) {
506     return balances[_owner];
507   }
508 
509 }
510 
511 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
512 
513 /**
514  * @title Standard ERC20 token
515  *
516  * @dev Implementation of the basic standard token.
517  * @dev https://github.com/ethereum/EIPs/issues/20
518  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
519  */
520 contract StandardToken is ERC20, BasicToken {
521 
522   mapping (address => mapping (address => uint256)) internal allowed;
523 
524 
525   /**
526    * @dev Transfer tokens from one address to another
527    * @param _from address The address which you want to send tokens from
528    * @param _to address The address which you want to transfer to
529    * @param _value uint256 the amount of tokens to be transferred
530    */
531   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
532     require(_to != address(0));
533     require(_value <= balances[_from]);
534     require(_value <= allowed[_from][msg.sender]);
535 
536     balances[_from] = balances[_from].sub(_value);
537     balances[_to] = balances[_to].add(_value);
538     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
539     Transfer(_from, _to, _value);
540     return true;
541   }
542 
543   /**
544    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
545    *
546    * Beware that changing an allowance with this method brings the risk that someone may use both the old
547    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
548    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
549    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
550    * @param _spender The address which will spend the funds.
551    * @param _value The amount of tokens to be spent.
552    */
553   function approve(address _spender, uint256 _value) public returns (bool) {
554     allowed[msg.sender][_spender] = _value;
555     Approval(msg.sender, _spender, _value);
556     return true;
557   }
558 
559   /**
560    * @dev Function to check the amount of tokens that an owner allowed to a spender.
561    * @param _owner address The address which owns the funds.
562    * @param _spender address The address which will spend the funds.
563    * @return A uint256 specifying the amount of tokens still available for the spender.
564    */
565   function allowance(address _owner, address _spender) public view returns (uint256) {
566     return allowed[_owner][_spender];
567   }
568 
569   /**
570    * @dev Increase the amount of tokens that an owner allowed to a spender.
571    *
572    * approve should be called when allowed[_spender] == 0. To increment
573    * allowed value is better to use this function to avoid 2 calls (and wait until
574    * the first transaction is mined)
575    * From MonolithDAO Token.sol
576    * @param _spender The address which will spend the funds.
577    * @param _addedValue The amount of tokens to increase the allowance by.
578    */
579   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
580     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
581     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
582     return true;
583   }
584 
585   /**
586    * @dev Decrease the amount of tokens that an owner allowed to a spender.
587    *
588    * approve should be called when allowed[_spender] == 0. To decrement
589    * allowed value is better to use this function to avoid 2 calls (and wait until
590    * the first transaction is mined)
591    * From MonolithDAO Token.sol
592    * @param _spender The address which will spend the funds.
593    * @param _subtractedValue The amount of tokens to decrease the allowance by.
594    */
595   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
596     uint oldValue = allowed[msg.sender][_spender];
597     if (_subtractedValue > oldValue) {
598       allowed[msg.sender][_spender] = 0;
599     } else {
600       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
601     }
602     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
603     return true;
604   }
605 
606 }
607 
608 // File: contracts/PausableToken.sol
609 
610 contract PausableToken is StandardToken, Pausable {
611 
612     address public allowedTransferWallet;
613 
614     constructor(address _allowedTransferWallet) public {
615         allowedTransferWallet = _allowedTransferWallet;
616     }
617 
618     modifier whenNotPausedOrOwnerOrAllowed() {
619         require(!paused || msg.sender == owner || msg.sender == allowedTransferWallet);
620         _;
621     }
622 
623     function changeAllowTransferWallet(address _allowedTransferWallet) public onlyOwner {
624         allowedTransferWallet = _allowedTransferWallet;
625     }
626 
627     /**
628     * @dev Transfer token for a specified address with pause feature for owner.
629     * @dev Only applies when the transfer is allowed by the owner.
630     * @param _to The address to transfer to.
631     * @param _value The amount to be transferred.
632     */
633     function transfer(address _to, uint256 _value) public whenNotPausedOrOwnerOrAllowed returns (bool) {
634         return super.transfer(_to, _value);
635     }
636 
637     /**
638     * @dev Transfer tokens from one address to another with pause feature for owner.
639     * @dev Only applies when the transfer is allowed by the owner.
640     * @param _from address The address which you want to send tokens from
641     * @param _to address The address which you want to transfer to
642     * @param _value uint256 the amount of tokens to be transferred
643     */
644     function transferFrom(address _from, address _to, uint256 _value) public whenNotPausedOrOwnerOrAllowed returns (bool) {
645         return super.transferFrom(_from, _to, _value);
646     }
647 }
648 
649 // File: contracts/AbacasToken.sol
650 
651 contract AbacasToken is DetailedERC20("AbacasXchange [Abacas] Token", "ABCS", 9), PausableToken {
652 
653     constructor(address _allowedTransferWallet) PausableToken(_allowedTransferWallet) public {
654         totalSupply_ = 100e6 * (uint256(10) ** decimals);
655         balances[msg.sender] = totalSupply_;
656         emit Transfer(address(0), msg.sender, totalSupply_);
657     }
658 }
659 
660 // File: contracts/AbacasTokenFactory.sol
661 
662 contract AbacasTokenFactory {
663 
664     uint256 constant public FOUNDERS_LOCK_START_TIME  = 1541030400;
665     uint256 constant public FOUNDERS_LOCK_PERIOD  = 90 days;
666 
667     AbacasToken public token;
668     InitialTokenDistribution public initialDistribution;
669 
670     function create(
671         address _allowedToTransferWallet,
672         address _futureSaleWallet,
673         address _communityWallet,
674         address _foundationWallet,
675         address _foundersWallet,
676         address _publicPrivateSaleWallet
677     ) public
678     {
679         token = new AbacasToken(_allowedToTransferWallet);
680         // solium-disable-next-line max-len
681         initialDistribution = new AbacasInitialTokenDistribution(token, _futureSaleWallet, _communityWallet, _foundationWallet, _foundersWallet, _publicPrivateSaleWallet, FOUNDERS_LOCK_START_TIME, FOUNDERS_LOCK_PERIOD);
682         token.approve(initialDistribution, token.balanceOf(this));
683         initialDistribution.processInitialDistribution();
684         token.pause();
685         transfer();
686     }
687 
688 
689     function transfer() private {
690         token.transferOwnership(msg.sender);
691         initialDistribution.transferOwnership(msg.sender);
692     }
693 }