1 //File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
68 pragma solidity ^0.4.24;
69 
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * See https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77   function totalSupply() public view returns (uint256);
78   function balanceOf(address _who) public view returns (uint256);
79   function transfer(address _to, uint256 _value) public returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
84 pragma solidity ^0.4.24;
85 
86 
87 
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94   function allowance(address _owner, address _spender)
95     public view returns (uint256);
96 
97   function transferFrom(address _from, address _to, uint256 _value)
98     public returns (bool);
99 
100   function approve(address _spender, uint256 _value) public returns (bool);
101   event Approval(
102     address indexed owner,
103     address indexed spender,
104     uint256 value
105   );
106 }
107 
108 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
109 pragma solidity ^0.4.24;
110 
111 
112 
113 
114 
115 /**
116  * @title SafeERC20
117  * @dev Wrappers around ERC20 operations that throw on failure.
118  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
119  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
120  */
121 library SafeERC20 {
122   function safeTransfer(
123     ERC20Basic _token,
124     address _to,
125     uint256 _value
126   )
127     internal
128   {
129     require(_token.transfer(_to, _value));
130   }
131 
132   function safeTransferFrom(
133     ERC20 _token,
134     address _from,
135     address _to,
136     uint256 _value
137   )
138     internal
139   {
140     require(_token.transferFrom(_from, _to, _value));
141   }
142 
143   function safeApprove(
144     ERC20 _token,
145     address _spender,
146     uint256 _value
147   )
148     internal
149   {
150     require(_token.approve(_spender, _value));
151   }
152 }
153 
154 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\TokenTimelock.sol
155 pragma solidity ^0.4.24;
156 
157 
158 
159 
160 /**
161  * @title TokenTimelock
162  * @dev TokenTimelock is a token holder contract that will allow a
163  * beneficiary to extract the tokens after a given release time
164  */
165 contract TokenTimelock {
166   using SafeERC20 for ERC20Basic;
167 
168   // ERC20 basic token contract being held
169   ERC20Basic public token;
170 
171   // beneficiary of tokens after they are released
172   address public beneficiary;
173 
174   // timestamp when token release is enabled
175   uint256 public releaseTime;
176 
177   constructor(
178     ERC20Basic _token,
179     address _beneficiary,
180     uint256 _releaseTime
181   )
182     public
183   {
184     // solium-disable-next-line security/no-block-members
185     require(_releaseTime > block.timestamp);
186     token = _token;
187     beneficiary = _beneficiary;
188     releaseTime = _releaseTime;
189   }
190 
191   /**
192    * @notice Transfers tokens held by timelock to beneficiary.
193    */
194   function release() public {
195     // solium-disable-next-line security/no-block-members
196     require(block.timestamp >= releaseTime);
197 
198     uint256 amount = token.balanceOf(address(this));
199     require(amount > 0);
200 
201     token.safeTransfer(beneficiary, amount);
202   }
203 }
204 
205 //File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
206 pragma solidity ^0.4.24;
207 
208 
209 /**
210  * @title SafeMath
211  * @dev Math operations with safety checks that throw on error
212  */
213 library SafeMath {
214 
215   /**
216   * @dev Multiplies two numbers, throws on overflow.
217   */
218   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
219     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
220     // benefit is lost if 'b' is also tested.
221     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
222     if (_a == 0) {
223       return 0;
224     }
225 
226     c = _a * _b;
227     assert(c / _a == _b);
228     return c;
229   }
230 
231   /**
232   * @dev Integer division of two numbers, truncating the quotient.
233   */
234   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
235     // assert(_b > 0); // Solidity automatically throws when dividing by 0
236     // uint256 c = _a / _b;
237     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
238     return _a / _b;
239   }
240 
241   /**
242   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
243   */
244   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
245     assert(_b <= _a);
246     return _a - _b;
247   }
248 
249   /**
250   * @dev Adds two numbers, throws on overflow.
251   */
252   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
253     c = _a + _b;
254     assert(c >= _a);
255     return c;
256   }
257 }
258 
259 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\TokenVesting.sol
260 /* solium-disable security/no-block-members */
261 
262 pragma solidity ^0.4.24;
263 
264 
265 
266 
267 
268 
269 
270 /**
271  * @title TokenVesting
272  * @dev A token holder contract that can release its token balance gradually like a
273  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
274  * owner.
275  */
276 contract TokenVesting is Ownable {
277   using SafeMath for uint256;
278   using SafeERC20 for ERC20Basic;
279 
280   event Released(uint256 amount);
281   event Revoked();
282 
283   // beneficiary of tokens after they are released
284   address public beneficiary;
285 
286   uint256 public cliff;
287   uint256 public start;
288   uint256 public duration;
289 
290   bool public revocable;
291 
292   mapping (address => uint256) public released;
293   mapping (address => bool) public revoked;
294 
295   /**
296    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
297    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
298    * of the balance will have vested.
299    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
300    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
301    * @param _start the time (as Unix time) at which point vesting starts
302    * @param _duration duration in seconds of the period in which the tokens will vest
303    * @param _revocable whether the vesting is revocable or not
304    */
305   constructor(
306     address _beneficiary,
307     uint256 _start,
308     uint256 _cliff,
309     uint256 _duration,
310     bool _revocable
311   )
312     public
313   {
314     require(_beneficiary != address(0));
315     require(_cliff <= _duration);
316 
317     beneficiary = _beneficiary;
318     revocable = _revocable;
319     duration = _duration;
320     cliff = _start.add(_cliff);
321     start = _start;
322   }
323 
324   /**
325    * @notice Transfers vested tokens to beneficiary.
326    * @param _token ERC20 token which is being vested
327    */
328   function release(ERC20Basic _token) public {
329     uint256 unreleased = releasableAmount(_token);
330 
331     require(unreleased > 0);
332 
333     released[_token] = released[_token].add(unreleased);
334 
335     _token.safeTransfer(beneficiary, unreleased);
336 
337     emit Released(unreleased);
338   }
339 
340   /**
341    * @notice Allows the owner to revoke the vesting. Tokens already vested
342    * remain in the contract, the rest are returned to the owner.
343    * @param _token ERC20 token which is being vested
344    */
345   function revoke(ERC20Basic _token) public onlyOwner {
346     require(revocable);
347     require(!revoked[_token]);
348 
349     uint256 balance = _token.balanceOf(address(this));
350 
351     uint256 unreleased = releasableAmount(_token);
352     uint256 refund = balance.sub(unreleased);
353 
354     revoked[_token] = true;
355 
356     _token.safeTransfer(owner, refund);
357 
358     emit Revoked();
359   }
360 
361   /**
362    * @dev Calculates the amount that has already vested but hasn't been released yet.
363    * @param _token ERC20 token which is being vested
364    */
365   function releasableAmount(ERC20Basic _token) public view returns (uint256) {
366     return vestedAmount(_token).sub(released[_token]);
367   }
368 
369   /**
370    * @dev Calculates the amount that has already vested.
371    * @param _token ERC20 token which is being vested
372    */
373   function vestedAmount(ERC20Basic _token) public view returns (uint256) {
374     uint256 currentBalance = _token.balanceOf(address(this));
375     uint256 totalBalance = currentBalance.add(released[_token]);
376 
377     if (block.timestamp < cliff) {
378       return 0;
379     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
380       return totalBalance;
381     } else {
382       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
383     }
384   }
385 }
386 
387 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
388 pragma solidity ^0.4.24;
389 
390 
391 
392 
393 
394 
395 /**
396  * @title Basic token
397  * @dev Basic version of StandardToken, with no allowances.
398  */
399 contract BasicToken is ERC20Basic {
400   using SafeMath for uint256;
401 
402   mapping(address => uint256) internal balances;
403 
404   uint256 internal totalSupply_;
405 
406   /**
407   * @dev Total number of tokens in existence
408   */
409   function totalSupply() public view returns (uint256) {
410     return totalSupply_;
411   }
412 
413   /**
414   * @dev Transfer token for a specified address
415   * @param _to The address to transfer to.
416   * @param _value The amount to be transferred.
417   */
418   function transfer(address _to, uint256 _value) public returns (bool) {
419     require(_value <= balances[msg.sender]);
420     require(_to != address(0));
421 
422     balances[msg.sender] = balances[msg.sender].sub(_value);
423     balances[_to] = balances[_to].add(_value);
424     emit Transfer(msg.sender, _to, _value);
425     return true;
426   }
427 
428   /**
429   * @dev Gets the balance of the specified address.
430   * @param _owner The address to query the the balance of.
431   * @return An uint256 representing the amount owned by the passed address.
432   */
433   function balanceOf(address _owner) public view returns (uint256) {
434     return balances[_owner];
435   }
436 
437 }
438 
439 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
440 pragma solidity ^0.4.24;
441 
442 
443 
444 
445 
446 /**
447  * @title Standard ERC20 token
448  *
449  * @dev Implementation of the basic standard token.
450  * https://github.com/ethereum/EIPs/issues/20
451  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
452  */
453 contract StandardToken is ERC20, BasicToken {
454 
455   mapping (address => mapping (address => uint256)) internal allowed;
456 
457 
458   /**
459    * @dev Transfer tokens from one address to another
460    * @param _from address The address which you want to send tokens from
461    * @param _to address The address which you want to transfer to
462    * @param _value uint256 the amount of tokens to be transferred
463    */
464   function transferFrom(
465     address _from,
466     address _to,
467     uint256 _value
468   )
469     public
470     returns (bool)
471   {
472     require(_value <= balances[_from]);
473     require(_value <= allowed[_from][msg.sender]);
474     require(_to != address(0));
475 
476     balances[_from] = balances[_from].sub(_value);
477     balances[_to] = balances[_to].add(_value);
478     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
479     emit Transfer(_from, _to, _value);
480     return true;
481   }
482 
483   /**
484    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
485    * Beware that changing an allowance with this method brings the risk that someone may use both the old
486    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
487    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
488    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
489    * @param _spender The address which will spend the funds.
490    * @param _value The amount of tokens to be spent.
491    */
492   function approve(address _spender, uint256 _value) public returns (bool) {
493     allowed[msg.sender][_spender] = _value;
494     emit Approval(msg.sender, _spender, _value);
495     return true;
496   }
497 
498   /**
499    * @dev Function to check the amount of tokens that an owner allowed to a spender.
500    * @param _owner address The address which owns the funds.
501    * @param _spender address The address which will spend the funds.
502    * @return A uint256 specifying the amount of tokens still available for the spender.
503    */
504   function allowance(
505     address _owner,
506     address _spender
507    )
508     public
509     view
510     returns (uint256)
511   {
512     return allowed[_owner][_spender];
513   }
514 
515   /**
516    * @dev Increase the amount of tokens that an owner allowed to a spender.
517    * approve should be called when allowed[_spender] == 0. To increment
518    * allowed value is better to use this function to avoid 2 calls (and wait until
519    * the first transaction is mined)
520    * From MonolithDAO Token.sol
521    * @param _spender The address which will spend the funds.
522    * @param _addedValue The amount of tokens to increase the allowance by.
523    */
524   function increaseApproval(
525     address _spender,
526     uint256 _addedValue
527   )
528     public
529     returns (bool)
530   {
531     allowed[msg.sender][_spender] = (
532       allowed[msg.sender][_spender].add(_addedValue));
533     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
534     return true;
535   }
536 
537   /**
538    * @dev Decrease the amount of tokens that an owner allowed to a spender.
539    * approve should be called when allowed[_spender] == 0. To decrement
540    * allowed value is better to use this function to avoid 2 calls (and wait until
541    * the first transaction is mined)
542    * From MonolithDAO Token.sol
543    * @param _spender The address which will spend the funds.
544    * @param _subtractedValue The amount of tokens to decrease the allowance by.
545    */
546   function decreaseApproval(
547     address _spender,
548     uint256 _subtractedValue
549   )
550     public
551     returns (bool)
552   {
553     uint256 oldValue = allowed[msg.sender][_spender];
554     if (_subtractedValue >= oldValue) {
555       allowed[msg.sender][_spender] = 0;
556     } else {
557       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
558     }
559     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
560     return true;
561   }
562 
563 }
564 
565 //File: contracts\ico\TileToken.sol
566 /**
567 * @title TILE Token - LOOMIA
568 * @author Pactum IO <dev@pactum.io>
569 */
570 pragma solidity ^0.4.24;
571 
572 
573 
574 
575 
576 contract TileToken is StandardToken {
577     string public constant NAME = "LOOMIA TILE";
578     string public constant SYMBOL = "TILE";
579     uint8 public constant DECIMALS = 18;
580 
581     uint256 public totalSupply = 109021227 * 1e18; // Supply is 109,021,227 plus the conversion to wei
582 
583     constructor() public {
584         balances[msg.sender] = totalSupply;
585     }
586 }
587 
588 //File: contracts\ico\TileDistribution.sol
589 /**
590  * @title TILE Token Distribution - LOOMIA
591  * @author Pactum IO <dev@pactum.io>
592  */
593 pragma solidity ^0.4.24;
594 
595 
596 
597 
598 
599 
600 
601 contract TileDistribution is Ownable {
602     using SafeMath for uint256;
603 
604     /*** CONSTANTS ***/
605     uint256 public constant VESTING_DURATION = 2 * 365 days;
606     uint256 public constant VESTING_START_TIME = 1504224000; // Friday, September 1, 2017 12:00:00 AM
607     uint256 public constant VESTING_CLIFF = 26 weeks; // 6 month cliff-- 52 weeks/2
608 
609     uint256 public constant TIMELOCK_DURATION = 365 days;
610 
611     address public constant LOOMIA1_ADDR = 0x1c59Aa1ec35Cfcc222B0e860066796Ccddbe10c8;
612     address public constant LOOMIA2_ADDR = 0x4c728E555E647214D834E4eBa37844424C0b7eFD;
613     address public constant LOOMIA_LOOMIA_REMAINDER_ADDR = 0x8b91Eaa35E694524274178586aCC7701CC56cd35;
614     address public constant BRANDS_ADDR = 0xe4D876bf0b67Bf4547DD6c55559097cC62058726;
615     address public constant ADVISORS_ADDR = 0x886E7DE436df0fA4593a8534b798995624DB5837;
616     address public constant THIRD_PARTY_LOCKUP_ADDR = 0x03a41aD81834E8831fFc65CdC3F61Cf04A31806E;
617 
618     uint256 public constant LOOMIA1 = 3270636.80 * 1e18;
619     uint256 public constant LOOMIA2 = 3270636.80 * 1e18;
620     uint256 public constant LOOMIA_REMAINDER = 9811910 * 1e18;
621     uint256 public constant BRANDS = 10902122.70 * 1e18;
622     uint256 public constant ADVISORS = 5451061.35 * 1e18;
623     uint256 public constant THIRD_PARTY_LOCKUP = 5451061.35 * 1e18;
624 
625 
626     /*** VARIABLES ***/
627     ERC20Basic public token; // The token being distributed
628     address[3] public tokenVestingAddresses; // address array for easy of access
629     address public tokenTimelockAddress;
630 
631     /*** EVENTS ***/
632     event AirDrop(address indexed _beneficiaryAddress, uint256 _amount);
633 
634     /*** MODIFIERS ***/
635     modifier validAddressAmount(address _beneficiaryWallet, uint256 _amount) {
636         require(_beneficiaryWallet != address(0));
637         require(_amount != 0);
638         _;
639     }
640 
641     /**
642      * @dev Constructor
643      */
644     constructor () public {
645         token = createTokenContract();
646         createVestingContract();
647         createTimeLockContract();
648     }
649 
650     /**
651     * @dev fallback function - do not accept payment
652     */
653     function () external payable {
654         revert();
655     }
656 
657     /*** PUBLIC || EXTERNAL ***/
658     /**
659      * @dev This function is the batch send function for Token distribution. It accepts an array of addresses and amounts
660      * @param _beneficiaryWallets the address where tokens will be deposited into
661      * @param _amounts the token amount in wei to send to the associated beneficiary
662      */
663     function batchDistributeTokens(address[] _beneficiaryWallets, uint256[] _amounts) external onlyOwner {
664         require(_beneficiaryWallets.length == _amounts.length);
665         for (uint i = 0; i < _beneficiaryWallets.length; i++) {
666             distributeTokens(_beneficiaryWallets[i], _amounts[i]);
667         }
668     }
669 
670     /**
671      * @dev Single token airdrop function. It is for a single transfer of tokens to beneficiary
672      * @param _beneficiaryWallet the address where tokens will be deposited into
673      * @param _amount the token amount in wei to send to the associated beneficiary
674      */
675     function distributeTokens(address _beneficiaryWallet, uint256 _amount) public onlyOwner validAddressAmount(_beneficiaryWallet, _amount) {
676         token.transfer(_beneficiaryWallet, _amount);
677         emit AirDrop(_beneficiaryWallet, _amount);
678     }
679 
680     /*** INTERNAL || PRIVATE ***/
681     /**
682      * @dev Creates the Vesting contracts to secure a percentage of tokens to be redistributed incrementally over time.
683      */
684     function createVestingContract() private {
685         TokenVesting newVault = new TokenVesting(
686             LOOMIA1_ADDR, VESTING_START_TIME, VESTING_CLIFF, VESTING_DURATION, false);
687 
688         tokenVestingAddresses[0] = address(newVault);
689         token.transfer(address(newVault), LOOMIA1);
690 
691         TokenVesting newVault2 = new TokenVesting(
692             LOOMIA2_ADDR, VESTING_START_TIME, VESTING_CLIFF, VESTING_DURATION, false);
693 
694         tokenVestingAddresses[1] = address(newVault2);
695         token.transfer(address(newVault2), LOOMIA2);
696 
697         TokenVesting newVault3 = new TokenVesting(
698             LOOMIA_LOOMIA_REMAINDER_ADDR, VESTING_START_TIME, VESTING_CLIFF, VESTING_DURATION, false);
699 
700         tokenVestingAddresses[2] = address(newVault3);
701         token.transfer(address(newVault3), LOOMIA_REMAINDER);
702     }
703 
704      /**
705      * @dev Creates the Timelock contract to secure a precentage of tokens for the predefined duration.
706      */
707     function createTimeLockContract() private {
708         TokenTimelock timelock = new TokenTimelock(token, THIRD_PARTY_LOCKUP_ADDR, now.add(TIMELOCK_DURATION));
709         tokenTimelockAddress = address(timelock);
710         token.transfer(tokenTimelockAddress, THIRD_PARTY_LOCKUP);
711     }
712 
713     /**
714      * Creates the Tile token contract
715      * Called by the constructor
716      */
717     function createTokenContract() private returns (ERC20Basic) {
718         return new TileToken();
719     }
720 }