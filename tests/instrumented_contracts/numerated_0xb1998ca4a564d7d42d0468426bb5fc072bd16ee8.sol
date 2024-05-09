1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipRenounced(address indexed previousOwner);
77   event OwnershipTransferred(
78     address indexed previousOwner,
79     address indexed newOwner
80   );
81 
82 
83   /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87   constructor() public {
88     owner = msg.sender;
89   }
90 
91   /**
92    * @dev Throws if called by any account other than the owner.
93    */
94   modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98 
99   /**
100    * @dev Allows the current owner to relinquish control of the contract.
101    * @notice Renouncing to ownership will leave the contract without an owner.
102    * It will not be possible to call the functions with the `onlyOwner`
103    * modifier anymore.
104    */
105   function renounceOwnership() public onlyOwner {
106     emit OwnershipRenounced(owner);
107     owner = address(0);
108   }
109 
110   /**
111    * @dev Allows the current owner to transfer control of the contract to a newOwner.
112    * @param _newOwner The address to transfer ownership to.
113    */
114   function transferOwnership(address _newOwner) public onlyOwner {
115     _transferOwnership(_newOwner);
116   }
117 
118   /**
119    * @dev Transfers control of the contract to a newOwner.
120    * @param _newOwner The address to transfer ownership to.
121    */
122   function _transferOwnership(address _newOwner) internal {
123     require(_newOwner != address(0));
124     emit OwnershipTransferred(owner, _newOwner);
125     owner = _newOwner;
126   }
127 }
128 
129 
130 
131 /**
132  * @title Whitelist contract
133  * @dev Whitelist for wallets.
134 */
135 contract Whitelist is Ownable {
136     mapping(address => bool) whitelist;
137 
138     uint256 public whitelistLength = 0;
139 
140     address private addressApi;
141 
142     modifier onlyPrivilegeAddresses {
143         require(msg.sender == addressApi || msg.sender == owner);
144         _;
145     }
146 
147     /**
148     * @dev Set backend Api address.
149     * @dev Accept request from the owner only.
150     * @param _api The address of backend API to set.
151     */
152     function setApiAddress(address _api) public onlyOwner {
153         require(_api != address(0));
154         addressApi = _api;
155     }
156 
157     /**
158     * @dev Add wallet to whitelist.
159     * @dev Accept request from the privileged addresses only.
160     * @param _wallet The address of wallet to add.
161     */  
162     function addWallet(address _wallet) public onlyPrivilegeAddresses {
163         require(_wallet != address(0));
164         require(!isWhitelisted(_wallet));
165         whitelist[_wallet] = true;
166         whitelistLength++;
167     }
168 
169     /**
170     * @dev Remove wallet from whitelist.
171     * @dev Accept request from the owner only.
172     * @param _wallet The address of whitelisted wallet to remove.
173     */  
174     function removeWallet(address _wallet) public onlyOwner {
175         require(_wallet != address(0));
176         require(isWhitelisted(_wallet));
177         whitelist[_wallet] = false;
178         whitelistLength--;
179     }
180 
181     /**
182     * @dev Check the specified wallet whether it is in the whitelist.
183     * @param _wallet The address of wallet to check.
184     */ 
185     function isWhitelisted(address _wallet) public view returns (bool) {
186         return whitelist[_wallet];
187     }
188 
189 }
190 
191 /**
192  * @title Pausable
193  * @dev Base contract which allows children to implement an emergency stop mechanism.
194  */
195 contract Pausable is Ownable {
196   event Pause();
197   event Unpause();
198 
199   bool public paused = false;
200 
201 
202   /**
203    * @dev Modifier to make a function callable only when the contract is not paused.
204    */
205   modifier whenNotPaused() {
206     require(!paused);
207     _;
208   }
209 
210   /**
211    * @dev Modifier to make a function callable only when the contract is paused.
212    */
213   modifier whenPaused() {
214     require(paused);
215     _;
216   }
217 
218   /**
219    * @dev called by the owner to pause, triggers stopped state
220    */
221   function pause() public onlyOwner whenNotPaused {
222     paused = true;
223     emit Pause();
224   }
225 
226   /**
227    * @dev called by the owner to unpause, returns to normal state
228    */
229   function unpause() public onlyOwner whenPaused {
230     paused = false;
231     emit Unpause();
232   }
233 }
234 
235 /**
236  * @title ERC20Basic
237  * @dev Simpler version of ERC20 interface
238  * See https://github.com/ethereum/EIPs/issues/179
239  */
240 contract ERC20Basic {
241   function totalSupply() public view returns (uint256);
242   function balanceOf(address _who) public view returns (uint256);
243   function transfer(address _to, uint256 _value) public returns (bool);
244   event Transfer(address indexed from, address indexed to, uint256 value);
245 }
246 
247 /**
248  * @title Basic token
249  * @dev Basic version of StandardToken, with no allowances.
250  */
251 contract BasicToken is ERC20Basic {
252   using SafeMath for uint256;
253 
254   mapping(address => uint256) internal balances;
255 
256   uint256 internal totalSupply_;
257 
258   /**
259   * @dev Total number of tokens in existence
260   */
261   function totalSupply() public view returns (uint256) {
262     return totalSupply_;
263   }
264 
265   /**
266   * @dev Transfer token for a specified address
267   * @param _to The address to transfer to.
268   * @param _value The amount to be transferred.
269   */
270   function transfer(address _to, uint256 _value) public returns (bool) {
271     require(_value <= balances[msg.sender]);
272     require(_to != address(0));
273 
274     balances[msg.sender] = balances[msg.sender].sub(_value);
275     balances[_to] = balances[_to].add(_value);
276     emit Transfer(msg.sender, _to, _value);
277     return true;
278   }
279 
280   /**
281   * @dev Gets the balance of the specified address.
282   * @param _owner The address to query the the balance of.
283   * @return An uint256 representing the amount owned by the passed address.
284   */
285   function balanceOf(address _owner) public view returns (uint256) {
286     return balances[_owner];
287   }
288 
289 }
290 
291 
292 
293 /**
294  * @title ERC20 interface
295  * @dev see https://github.com/ethereum/EIPs/issues/20
296  */
297 contract ERC20 is ERC20Basic {
298   function allowance(address _owner, address _spender)
299     public view returns (uint256);
300 
301   function transferFrom(address _from, address _to, uint256 _value)
302     public returns (bool);
303 
304   function approve(address _spender, uint256 _value) public returns (bool);
305   event Approval(
306     address indexed owner,
307     address indexed spender,
308     uint256 value
309   );
310 }
311 
312 
313 
314 /**
315  * @title Standard ERC20 token
316  *
317  * @dev Implementation of the basic standard token.
318  * https://github.com/ethereum/EIPs/issues/20
319  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
320  */
321 contract StandardToken is ERC20, BasicToken {
322 
323   mapping (address => mapping (address => uint256)) internal allowed;
324 
325 
326   /**
327    * @dev Transfer tokens from one address to another
328    * @param _from address The address which you want to send tokens from
329    * @param _to address The address which you want to transfer to
330    * @param _value uint256 the amount of tokens to be transferred
331    */
332   function transferFrom(
333     address _from,
334     address _to,
335     uint256 _value
336   )
337     public
338     returns (bool)
339   {
340     require(_value <= balances[_from]);
341     require(_value <= allowed[_from][msg.sender]);
342     require(_to != address(0));
343 
344     balances[_from] = balances[_from].sub(_value);
345     balances[_to] = balances[_to].add(_value);
346     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
347     emit Transfer(_from, _to, _value);
348     return true;
349   }
350 
351   /**
352    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
353    * Beware that changing an allowance with this method brings the risk that someone may use both the old
354    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
355    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
356    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
357    * @param _spender The address which will spend the funds.
358    * @param _value The amount of tokens to be spent.
359    */
360   function approve(address _spender, uint256 _value) public returns (bool) {
361     allowed[msg.sender][_spender] = _value;
362     emit Approval(msg.sender, _spender, _value);
363     return true;
364   }
365 
366   /**
367    * @dev Function to check the amount of tokens that an owner allowed to a spender.
368    * @param _owner address The address which owns the funds.
369    * @param _spender address The address which will spend the funds.
370    * @return A uint256 specifying the amount of tokens still available for the spender.
371    */
372   function allowance(
373     address _owner,
374     address _spender
375    )
376     public
377     view
378     returns (uint256)
379   {
380     return allowed[_owner][_spender];
381   }
382 
383   /**
384    * @dev Increase the amount of tokens that an owner allowed to a spender.
385    * approve should be called when allowed[_spender] == 0. To increment
386    * allowed value is better to use this function to avoid 2 calls (and wait until
387    * the first transaction is mined)
388    * From MonolithDAO Token.sol
389    * @param _spender The address which will spend the funds.
390    * @param _addedValue The amount of tokens to increase the allowance by.
391    */
392   function increaseApproval(
393     address _spender,
394     uint256 _addedValue
395   )
396     public
397     returns (bool)
398   {
399     allowed[msg.sender][_spender] = (
400       allowed[msg.sender][_spender].add(_addedValue));
401     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
402     return true;
403   }
404 
405   /**
406    * @dev Decrease the amount of tokens that an owner allowed to a spender.
407    * approve should be called when allowed[_spender] == 0. To decrement
408    * allowed value is better to use this function to avoid 2 calls (and wait until
409    * the first transaction is mined)
410    * From MonolithDAO Token.sol
411    * @param _spender The address which will spend the funds.
412    * @param _subtractedValue The amount of tokens to decrease the allowance by.
413    */
414   function decreaseApproval(
415     address _spender,
416     uint256 _subtractedValue
417   )
418     public
419     returns (bool)
420   {
421     uint256 oldValue = allowed[msg.sender][_spender];
422     if (_subtractedValue >= oldValue) {
423       allowed[msg.sender][_spender] = 0;
424     } else {
425       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
426     }
427     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
428     return true;
429   }
430 
431 }
432 
433 contract VeiagToken is StandardToken, Ownable, Pausable {
434     string constant public name = "Veiag Token";
435     string constant public symbol = "VEIAG";
436     uint8 constant public decimals = 18;
437 
438     uint256 constant public INITIAL_TOTAL_SUPPLY = 1e9 * (uint256(10) ** decimals);
439 
440     address private addressIco;
441 
442     modifier onlyIco() {
443         require(msg.sender == addressIco);
444         _;
445     }
446     
447     /**
448     * @dev Create VeiagToken contract and set pause
449     * @param _ico The address of ICO contract.
450     */
451     function VeiagToken (address _ico) public {
452         require(_ico != address(0));
453 
454         addressIco = _ico;
455 
456         totalSupply_ = totalSupply_.add(INITIAL_TOTAL_SUPPLY);
457         balances[_ico] = balances[_ico].add(INITIAL_TOTAL_SUPPLY);
458         Transfer(address(0), _ico, INITIAL_TOTAL_SUPPLY);
459 
460         pause();
461     }
462 
463      /**
464     * @dev Transfer token for a specified address with pause feature for owner.
465     * @dev Only applies when the transfer is allowed by the owner.
466     * @param _to The address to transfer to.
467     * @param _value The amount to be transferred.
468     */
469     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
470         super.transfer(_to, _value);
471     }
472 
473     /**
474     * @dev Transfer tokens from one address to another with pause feature for owner.
475     * @dev Only applies when the transfer is allowed by the owner.
476     * @param _from address The address which you want to send tokens from
477     * @param _to address The address which you want to transfer to
478     * @param _value uint256 the amount of tokens to be transferred
479     */
480     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
481         super.transferFrom(_from, _to, _value);
482     }
483 
484     /**
485     * @dev Transfer tokens from ICO address to another address.
486     * @param _to The address to transfer to.
487     * @param _value The amount to be transferred.
488     */
489     function transferFromIco(address _to, uint256 _value) public onlyIco returns (bool) {
490         super.transfer(_to, _value);
491     }
492 }
493 
494 /**
495  * @title SafeERC20
496  * @dev Wrappers around ERC20 operations that throw on failure.
497  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
498  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
499  */
500 library SafeERC20 {
501   function safeTransfer(
502     ERC20Basic _token,
503     address _to,
504     uint256 _value
505   )
506     internal
507   {
508     require(_token.transfer(_to, _value));
509   }
510 
511   function safeTransferFrom(
512     ERC20 _token,
513     address _from,
514     address _to,
515     uint256 _value
516   )
517     internal
518   {
519     require(_token.transferFrom(_from, _to, _value));
520   }
521 
522   function safeApprove(
523     ERC20 _token,
524     address _spender,
525     uint256 _value
526   )
527     internal
528   {
529     require(_token.approve(_spender, _value));
530   }
531 }
532 
533 
534 /**
535  * @title TokenTimelock
536  * @dev TokenTimelock is a token holder contract that will allow a
537  * beneficiary to extract the tokens after a given release time
538  */
539 contract TokenTimelock {
540   using SafeERC20 for ERC20Basic;
541 
542   // ERC20 basic token contract being held
543   ERC20Basic public token;
544 
545   // beneficiary of tokens after they are released
546   address public beneficiary;
547 
548   // timestamp when token release is enabled
549   uint256 public releaseTime;
550 
551   constructor(
552     ERC20Basic _token,
553     address _beneficiary,
554     uint256 _releaseTime
555   )
556     public
557   {
558     // solium-disable-next-line security/no-block-members
559     require(_releaseTime > block.timestamp);
560     token = _token;
561     beneficiary = _beneficiary;
562     releaseTime = _releaseTime;
563   }
564 
565   /**
566    * @notice Transfers tokens held by timelock to beneficiary.
567    */
568   function release() public {
569     // solium-disable-next-line security/no-block-members
570     require(block.timestamp >= releaseTime);
571 
572     uint256 amount = token.balanceOf(address(this));
573     require(amount > 0);
574 
575     token.transfer(beneficiary, amount);
576   }
577 }
578 
579 
580 
581 /**
582  * @title Mintable token
583  * @dev Simple ERC20 Token example, with mintable token creation
584  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
585  */
586 contract MintableToken is StandardToken, Ownable {
587   event Mint(address indexed to, uint256 amount);
588   event MintFinished();
589 
590   bool public mintingFinished = false;
591 
592 
593   modifier canMint() {
594     require(!mintingFinished);
595     _;
596   }
597 
598   modifier hasMintPermission() {
599     require(msg.sender == owner);
600     _;
601   }
602 
603   /**
604    * @dev Function to mint tokens
605    * @param _to The address that will receive the minted tokens.
606    * @param _amount The amount of tokens to mint.
607    * @return A boolean that indicates if the operation was successful.
608    */
609   function mint(
610     address _to,
611     uint256 _amount
612   )
613     public
614     hasMintPermission
615     canMint
616     returns (bool)
617   {
618     totalSupply_ = totalSupply_.add(_amount);
619     balances[_to] = balances[_to].add(_amount);
620     emit Mint(_to, _amount);
621     emit Transfer(address(0), _to, _amount);
622     return true;
623   }
624 
625   /**
626    * @dev Function to stop minting new tokens.
627    * @return True if the operation was successful.
628    */
629   function finishMinting() public onlyOwner canMint returns (bool) {
630     mintingFinished = true;
631     emit MintFinished();
632     return true;
633   }
634 }
635 
636 
637 
638 contract LockedOutTokens is TokenTimelock {
639     function LockedOutTokens(
640         ERC20Basic _token,
641         address _beneficiary,
642         uint256 _releaseTime
643     ) public TokenTimelock(_token, _beneficiary, _releaseTime)
644     {
645     }
646 
647     function release() public {
648         require(beneficiary == msg.sender);
649 
650         super.release();
651     }
652 }
653 /* solium-disable security/no-block-members */
654 
655 
656 /**
657  * @title TokenVesting
658  * @dev A token holder contract that can release its token balance gradually like a
659  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
660  * owner.
661  */
662 contract TokenVesting is Ownable {
663   using SafeMath for uint256;
664   using SafeERC20 for ERC20Basic;
665 
666   event Released(uint256 amount);
667   event Revoked();
668 
669   // beneficiary of tokens after they are released
670   address public beneficiary;
671 
672   uint256 public cliff;
673   uint256 public start;
674   uint256 public duration;
675 
676   bool public revocable;
677 
678   mapping (address => uint256) public released;
679   mapping (address => bool) public revoked;
680 
681   /**
682    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
683    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
684    * of the balance will have vested.
685    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
686    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
687    * @param _start the time (as Unix time) at which point vesting starts
688    * @param _duration duration in seconds of the period in which the tokens will vest
689    * @param _revocable whether the vesting is revocable or not
690    */
691   constructor(
692     address _beneficiary,
693     uint256 _start,
694     uint256 _cliff,
695     uint256 _duration,
696     bool _revocable
697   )
698     public
699   {
700     require(_beneficiary != address(0));
701     require(_cliff <= _duration);
702 
703     beneficiary = _beneficiary;
704     revocable = _revocable;
705     duration = _duration;
706     cliff = _start.add(_cliff);
707     start = _start;
708   }
709 
710   function setStart(uint256 _start) onlyOwner public {
711     start = _start;  
712   }
713   /**
714    * @notice Transfers vested tokens to beneficiary.
715    * @param _token ERC20 token which is being vested
716    */
717   function release(ERC20Basic _token) public {
718     uint256 unreleased = releasableAmount(_token);
719 
720     require(unreleased > 0);
721 
722     released[_token] = released[_token].add(unreleased);
723 
724     _token.transfer(beneficiary, unreleased);
725 
726     emit Released(unreleased);
727   }
728 
729   /**
730    * @notice Allows the owner to revoke the vesting. Tokens already vested
731    * remain in the contract, the rest are returned to the owner.
732    * @param _token ERC20 token which is being vested
733    */
734   function revoke(ERC20Basic _token) public onlyOwner {
735     require(revocable);
736     require(!revoked[_token]);
737 
738     uint256 balance = _token.balanceOf(address(this));
739 
740     uint256 unreleased = releasableAmount(_token);
741     uint256 refund = balance.sub(unreleased);
742 
743     revoked[_token] = true;
744 
745     _token.transfer(owner, refund);
746 
747     emit Revoked();
748   }
749 
750   /**
751    * @dev Calculates the amount that has already vested but hasn't been released yet.
752    * @param _token ERC20 token which is being vested
753    */
754   function releasableAmount(ERC20Basic _token) public view returns (uint256) {
755     return vestedAmount(_token).sub(released[_token]);
756   }
757 
758   /**
759    * @dev Calculates the amount that has already vested.
760    * @param _token ERC20 token which is being vested
761    */
762   function vestedAmount(ERC20Basic _token) public view returns (uint256) {
763     uint256 currentBalance = _token.balanceOf(address(this));
764     uint256 totalBalance = currentBalance.add(released[_token]);
765 
766     if (block.timestamp < cliff) {
767       return 0;
768     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
769       return totalBalance;
770     } else {
771       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
772     }
773   }
774 }
775 
776 contract VeiagTokenVesting is TokenVesting {
777     ERC20Basic public token;
778 
779     function VeiagTokenVesting(
780         ERC20Basic _token,
781         address _beneficiary,
782         uint256 _start,
783         uint256 _cliff,
784         uint256 _duration,
785         bool _revocable
786     ) TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable) public
787     {
788         require(_token != address(0));
789 
790         token = _token;
791     }
792 
793     function grant() public {
794         release(token);
795     }
796 
797     function release(ERC20Basic _token) public {
798         require(beneficiary == msg.sender);
799         super.release(_token);
800     }
801 }
802 
803 contract Whitelistable {
804     Whitelist public whitelist;
805 
806     modifier whenWhitelisted(address _wallet) {
807    //     require(whitelist.isWhitelisted(_wallet));
808         _;
809     }
810 
811     /**
812     * @dev Constructor for Whitelistable contract.
813     */
814     function Whitelistable() public {
815         whitelist = new Whitelist();
816     }
817 }
818 
819 contract VeiagCrowdsale is Pausable, Whitelistable {
820     using SafeMath for uint256;
821 
822     uint256 constant private DECIMALS = 18;
823 
824     uint256 constant public RESERVED_LOCKED_TOKENS = 250e6 * (10 ** DECIMALS);
825     uint256 constant public RESERVED_TEAMS_TOKENS = 100e6 * (10 ** DECIMALS);
826     uint256 constant public RESERVED_FOUNDERS_TOKENS = 100e6 * (10 ** DECIMALS);
827     uint256 constant public RESERVED_MARKETING_TOKENS = 50e6 * (10 ** DECIMALS);
828 
829     uint256 constant public MAXCAP_TOKENS_PRE_ICO = 100e6 * (10 ** DECIMALS);
830     
831     uint256 constant public MAXCAP_TOKENS_ICO = 400e6 * (10 ** DECIMALS);
832 
833     uint256 constant public MIN_INVESTMENT = (10 ** 16);   // 0.01  ETH
834 
835     uint256 constant public MAX_INVESTMENT = 100 * (10 ** DECIMALS); // 100  ETH
836 
837     uint256 public startTimePreIco = 0;
838     uint256 public endTimePreIco = 0;
839 
840     uint256 public startTimeIco = 0;
841     uint256 public endTimeIco = 0;
842 
843     // rate = 0.005 ETH, 1 ETH = 200 tokens
844     uint256 public exchangeRatePreIco = 200;
845 
846     uint256 public icoFirstWeekRate = 150;
847     uint256 public icoSecondWeekRate = 125;
848     uint256 public icoThirdWeekRate = 110;
849     // rate = 0.01 ETH, 1 ETH = 100 tokens
850     uint256 public icoRate = 100;
851 
852     uint256 public tokensRemainingPreIco = MAXCAP_TOKENS_PRE_ICO;
853     uint256 public tokensRemainingIco = MAXCAP_TOKENS_ICO;
854 
855     uint256 public tokensSoldPreIco = 0;
856     uint256 public tokensSoldIco = 0;
857     uint256 public tokensSoldTotal = 0;
858 
859     uint256 public weiRaisedPreIco = 0;
860     uint256 public weiRaisedIco = 0;
861     uint256 public weiRaisedTotal = 0;
862 
863     VeiagToken public token = new VeiagToken(this);
864     LockedOutTokens public lockedTokens;
865     VeiagTokenVesting public teamsTokenVesting;
866     VeiagTokenVesting public foundersTokenVesting;
867 
868     mapping (address => uint256) private totalInvestedAmount;
869 
870     modifier beforeReachingPreIcoMaxCap() {
871         require(tokensRemainingPreIco > 0);
872         _;
873     }
874 
875     modifier beforeReachingIcoMaxCap() {
876         require(tokensRemainingIco > 0);
877         _;
878     }
879 
880     /**
881     * @dev Constructor for VeiagCrowdsale contract.
882     * @dev Set the owner who can manage whitelist and token.
883     * @param _startTimePreIco The pre-ICO start time.
884     * @param _endTimePreIco The pre-ICO end time.
885     * @param _startTimeIco The ICO start time.
886     * @param _endTimeIco The ICO end time.
887     * @param _lockedWallet The address for future sale.
888     * @param _teamsWallet The address for reserved tokens for teams.
889     * @param _foundersWallet The address for reserved tokens for founders.
890     * @param _marketingWallet The address for reserved tokens for marketing.
891     */
892     function VeiagCrowdsale(
893         uint256 _startTimePreIco,
894         uint256 _endTimePreIco, 
895         uint256 _startTimeIco,
896         uint256 _endTimeIco,
897         address _lockedWallet,
898         address _teamsWallet,
899         address _foundersWallet,
900         address _marketingWallet
901     ) public Whitelistable()
902     {
903         require(_lockedWallet != address(0) && _teamsWallet != address(0) && _foundersWallet != address(0) && _marketingWallet != address(0));
904         require(_startTimePreIco > now && _endTimePreIco > _startTimePreIco);
905         require(_startTimeIco > _endTimePreIco && _endTimeIco > _startTimeIco);
906         startTimePreIco = _startTimePreIco;
907         endTimePreIco = _endTimePreIco;
908 
909         startTimeIco = _startTimeIco;
910         endTimeIco = _endTimeIco;
911 
912         lockedTokens = new LockedOutTokens(token, _lockedWallet, RESERVED_LOCKED_TOKENS);
913         teamsTokenVesting = new VeiagTokenVesting(token, _teamsWallet, 0, 1 days, 365 days, false);
914         foundersTokenVesting = new VeiagTokenVesting(token, _foundersWallet, 0, 1 days, 100 days, false);
915 
916         token.transferFromIco(lockedTokens, RESERVED_LOCKED_TOKENS);
917         token.transferFromIco(teamsTokenVesting, RESERVED_TEAMS_TOKENS);
918         token.transferFromIco(foundersTokenVesting, RESERVED_FOUNDERS_TOKENS);
919         token.transferFromIco(_marketingWallet, RESERVED_MARKETING_TOKENS);
920         teamsTokenVesting.transferOwnership(this);
921         foundersTokenVesting.transferOwnership(this);        
922         
923         whitelist.transferOwnership(msg.sender);
924         token.transferOwnership(msg.sender);
925     }
926 	function SetStartVesting(uint256 _startTimeVestingForFounders) public onlyOwner{
927 	    require(now > endTimeIco);
928 	    require(_startTimeVestingForFounders > endTimeIco);
929 	    teamsTokenVesting.setStart(_startTimeVestingForFounders);
930 	    foundersTokenVesting.setStart(endTimeIco);
931         teamsTokenVesting.transferOwnership(msg.sender);
932         foundersTokenVesting.transferOwnership(msg.sender);	    
933 	}
934 
935 	function SetStartTimeIco(uint256 _startTimeIco) public onlyOwner{
936         uint256 deltaTime;  
937         require(_startTimeIco > now && startTimeIco > now);
938         if (_startTimeIco > startTimeIco){
939           deltaTime = _startTimeIco.sub(startTimeIco);
940 	      endTimePreIco = endTimePreIco.add(deltaTime);
941 	      startTimeIco = startTimeIco.add(deltaTime);
942 	      endTimeIco = endTimeIco.add(deltaTime);
943         }
944         if (_startTimeIco < startTimeIco){
945           deltaTime = startTimeIco.sub(_startTimeIco);
946           endTimePreIco = endTimePreIco.sub(deltaTime);
947 	      startTimeIco = startTimeIco.sub(deltaTime);
948 	      endTimeIco = endTimeIco.sub(deltaTime);
949         }  
950     }
951 	
952 	
953     
954     /**
955     * @dev Fallback function can be used to buy tokens.
956     */
957     function() public payable {
958         if (isPreIco()) {
959             sellTokensPreIco();
960         } else if (isIco()) {
961             sellTokensIco();
962         } else {
963             revert();
964         }
965     }
966 
967     /**
968     * @dev Check whether the pre-ICO is active at the moment.
969     */
970     function isPreIco() public view returns (bool) {
971         return now >= startTimePreIco && now <= endTimePreIco;
972     }
973 
974     /**
975     * @dev Check whether the ICO is active at the moment.
976     */
977     function isIco() public view returns (bool) {
978         return now >= startTimeIco && now <= endTimeIco;
979     }
980 
981     /**
982     * @dev Calculate rate for ICO phase.
983     */
984     function exchangeRateIco() public view returns(uint256) {
985         require(now >= startTimeIco && now <= endTimeIco);
986 
987         if (now < startTimeIco + 1 weeks)
988             return icoFirstWeekRate;
989 
990         if (now < startTimeIco + 2 weeks)
991             return icoSecondWeekRate;
992 
993         if (now < startTimeIco + 3 weeks)
994             return icoThirdWeekRate;
995 
996         return icoRate;
997     }
998 	
999     function setExchangeRatePreIco(uint256 _exchangeRatePreIco) public onlyOwner{
1000 	  exchangeRatePreIco = _exchangeRatePreIco;
1001 	} 
1002 	
1003     function setIcoFirstWeekRate(uint256 _icoFirstWeekRate) public onlyOwner{
1004 	  icoFirstWeekRate = _icoFirstWeekRate;
1005 	} 	
1006 	
1007     function setIcoSecondWeekRate(uint256 _icoSecondWeekRate) public onlyOwner{
1008 	  icoSecondWeekRate = _icoSecondWeekRate;
1009 	} 
1010 	
1011     function setIcoThirdWeekRate(uint256 _icoThirdWeekRate) public onlyOwner{
1012 	  icoThirdWeekRate = _icoThirdWeekRate;
1013 	}
1014 	
1015     function setIcoRate(uint256 _icoRate) public onlyOwner{
1016 	  icoRate = _icoRate;
1017 	}
1018 	
1019     /**
1020     * @dev Sell tokens during Pre-ICO stage.
1021     */
1022     function sellTokensPreIco() public payable whenWhitelisted(msg.sender) beforeReachingPreIcoMaxCap whenNotPaused {
1023         require(isPreIco());
1024         require(msg.value >= MIN_INVESTMENT);
1025         uint256 senderTotalInvestment = totalInvestedAmount[msg.sender].add(msg.value);
1026         require(senderTotalInvestment <= MAX_INVESTMENT);
1027 
1028         uint256 weiAmount = msg.value;
1029         uint256 excessiveFunds = 0;
1030 
1031         uint256 tokensAmount = weiAmount.mul(exchangeRatePreIco);
1032 
1033         if (tokensAmount > tokensRemainingPreIco) {
1034             uint256 weiToAccept = tokensRemainingPreIco.div(exchangeRatePreIco);
1035             excessiveFunds = weiAmount.sub(weiToAccept);
1036 
1037             tokensAmount = tokensRemainingPreIco;
1038             weiAmount = weiToAccept;
1039         }
1040 
1041         addPreIcoPurchaseInfo(weiAmount, tokensAmount);
1042 
1043         owner.transfer(weiAmount);
1044 
1045         token.transferFromIco(msg.sender, tokensAmount);
1046 
1047         if (excessiveFunds > 0) {
1048             msg.sender.transfer(excessiveFunds);
1049         }
1050     }
1051 
1052     /**
1053     * @dev Sell tokens during ICO stage.
1054     */
1055     function sellTokensIco() public payable whenWhitelisted(msg.sender) beforeReachingIcoMaxCap whenNotPaused {
1056         require(isIco());
1057         require(msg.value >= MIN_INVESTMENT);
1058         uint256 senderTotalInvestment = totalInvestedAmount[msg.sender].add(msg.value);
1059         require(senderTotalInvestment <= MAX_INVESTMENT);
1060 
1061         uint256 weiAmount = msg.value;
1062         uint256 excessiveFunds = 0;
1063 
1064         uint256 tokensAmount = weiAmount.mul(exchangeRateIco());
1065 
1066         if (tokensAmount > tokensRemainingIco) {
1067             uint256 weiToAccept = tokensRemainingIco.div(exchangeRateIco());
1068             excessiveFunds = weiAmount.sub(weiToAccept);
1069 
1070             tokensAmount = tokensRemainingIco;
1071             weiAmount = weiToAccept;
1072         }
1073 
1074         addIcoPurchaseInfo(weiAmount, tokensAmount);
1075 
1076         owner.transfer(weiAmount);
1077 
1078         token.transferFromIco(msg.sender, tokensAmount);
1079 
1080         if (excessiveFunds > 0) {
1081             msg.sender.transfer(excessiveFunds);
1082         }
1083     }
1084 
1085     /**
1086     * @dev Manual send tokens to the specified address.
1087     * @param _address The address of a investor.
1088     * @param _tokensAmount Amount of tokens.
1089     */
1090     function manualSendTokens(address _address, uint256 _tokensAmount) public whenWhitelisted(_address) onlyOwner {
1091         require(_address != address(0));
1092         require(_tokensAmount > 0);
1093         
1094         if (isPreIco() && _tokensAmount <= tokensRemainingPreIco) {
1095             token.transferFromIco(_address, _tokensAmount);
1096             addPreIcoPurchaseInfo(0, _tokensAmount);
1097         } else if (isIco() && _tokensAmount <= tokensRemainingIco) {
1098             token.transferFromIco(_address, _tokensAmount);
1099             addIcoPurchaseInfo(0, _tokensAmount);
1100         } else {
1101             revert();
1102         }
1103     }
1104 
1105     /**
1106     * @dev Update the pre-ICO investments statistic.
1107     * @param _weiAmount The investment received from a pre-ICO investor.
1108     * @param _tokensAmount The tokens that will be sent to pre-ICO investor.
1109     */
1110     function addPreIcoPurchaseInfo(uint256 _weiAmount, uint256 _tokensAmount) internal {
1111         totalInvestedAmount[msg.sender] = totalInvestedAmount[msg.sender].add(_weiAmount);
1112 
1113         tokensSoldPreIco = tokensSoldPreIco.add(_tokensAmount);
1114         tokensSoldTotal = tokensSoldTotal.add(_tokensAmount);
1115         tokensRemainingPreIco = tokensRemainingPreIco.sub(_tokensAmount);
1116 
1117         weiRaisedPreIco = weiRaisedPreIco.add(_weiAmount);
1118         weiRaisedTotal = weiRaisedTotal.add(_weiAmount);
1119     }
1120 
1121     /**
1122     * @dev Update the ICO investments statistic.
1123     * @param _weiAmount The investment received from a ICO investor.
1124     * @param _tokensAmount The tokens that will be sent to ICO investor.
1125     */
1126     function addIcoPurchaseInfo(uint256 _weiAmount, uint256 _tokensAmount) internal {
1127         totalInvestedAmount[msg.sender] = totalInvestedAmount[msg.sender].add(_weiAmount);
1128 
1129         tokensSoldIco = tokensSoldIco.add(_tokensAmount);
1130         tokensSoldTotal = tokensSoldTotal.add(_tokensAmount);
1131         tokensRemainingIco = tokensRemainingIco.sub(_tokensAmount);
1132 
1133         weiRaisedIco = weiRaisedIco.add(_weiAmount);
1134         weiRaisedTotal = weiRaisedTotal.add(_weiAmount);
1135     }
1136 }
1137 contract Factory {
1138     VeiagCrowdsale public crowdsale;
1139 
1140     function createCrowdsale (
1141         uint256 _startTimePreIco,
1142         uint256 _endTimePreIco,
1143         uint256 _startTimeIco,
1144         uint256 _endTimeIco,
1145         address _lockedWallet,
1146         address _teamsWallet,
1147         address _foundersWallet,
1148         address _marketingWallet
1149     ) public
1150     {
1151         crowdsale = new VeiagCrowdsale(
1152             _startTimePreIco,
1153             _endTimePreIco,
1154             _startTimeIco,
1155             _endTimeIco,
1156             _lockedWallet,
1157             _teamsWallet,
1158             _foundersWallet,
1159             _marketingWallet
1160         );
1161 
1162         Whitelist whitelist = crowdsale.whitelist();
1163         whitelist.transferOwnership(msg.sender);
1164 
1165         VeiagToken token = crowdsale.token();
1166         token.transferOwnership(msg.sender);
1167         crowdsale.transferOwnership(msg.sender);
1168     }
1169 }