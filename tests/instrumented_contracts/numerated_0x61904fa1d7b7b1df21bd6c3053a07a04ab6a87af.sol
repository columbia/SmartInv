1 pragma solidity ^0.4.18;
2 
3 /** 
4  * DENTIX GLOBAL LIMITED
5  * https://dentix.io
6  */
7 
8 // ==== Open Zeppelin library ===
9 
10 /**
11  * @title ERC20Basic
12  * @dev Simpler version of ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/179
14  */
15 contract ERC20Basic {
16   uint256 public totalSupply;
17   function balanceOf(address who) public view returns (uint256);
18   function transfer(address to, uint256 value) public returns (bool);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 /**
23  * @title ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/20
25  */
26 contract ERC20 is ERC20Basic {
27   function allowance(address owner, address spender) public view returns (uint256);
28   function transferFrom(address from, address to, uint256 value) public returns (bool);
29   function approve(address spender, uint256 value) public returns (bool);
30   event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     if (a == 0) {
41       return 0;
42     }
43     uint256 c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 /**
68  * @title SafeERC20
69  * @dev Wrappers around ERC20 operations that throw on failure.
70  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
71  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
72  */
73 library SafeERC20 {
74   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
75     assert(token.transfer(to, value));
76   }
77 
78   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
79     assert(token.transferFrom(from, to, value));
80   }
81 
82   function safeApprove(ERC20 token, address spender, uint256 value) internal {
83     assert(token.approve(spender, value));
84   }
85 }
86 
87 /**
88  * @title Ownable
89  * @dev The Ownable contract has an owner address, and provides basic authorization control
90  * functions, this simplifies the implementation of "user permissions".
91  */
92 contract Ownable {
93   address public owner;
94 
95 
96   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98 
99   /**
100    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101    * account.
102    */
103   function Ownable() public {
104     owner = msg.sender;
105   }
106 
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116 
117   /**
118    * @dev Allows the current owner to transfer control of the contract to a newOwner.
119    * @param newOwner The address to transfer ownership to.
120    */
121   function transferOwnership(address newOwner) public onlyOwner {
122     require(newOwner != address(0));
123     OwnershipTransferred(owner, newOwner);
124     owner = newOwner;
125   }
126 
127 }
128 
129 /**
130  * @title Contracts that should not own Contracts
131  * @author Remco Bloemen <remco@2π.com>
132  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
133  * of this contract to reclaim ownership of the contracts.
134  */
135 contract HasNoContracts is Ownable {
136 
137   /**
138    * @dev Reclaim ownership of Ownable contracts
139    * @param contractAddr The address of the Ownable to be reclaimed.
140    */
141   function reclaimContract(address contractAddr) external onlyOwner {
142     Ownable contractInst = Ownable(contractAddr);
143     contractInst.transferOwnership(owner);
144   }
145 }
146 
147 /**
148  * @title Contracts that should be able to recover tokens
149  * @author SylTi
150  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
151  * This will prevent any accidental loss of tokens.
152  */
153 contract CanReclaimToken is Ownable {
154   using SafeERC20 for ERC20Basic;
155 
156   /**
157    * @dev Reclaim all ERC20Basic compatible tokens
158    * @param token ERC20Basic The address of the token contract
159    */
160   function reclaimToken(ERC20Basic token) external onlyOwner {
161     uint256 balance = token.balanceOf(this);
162     token.safeTransfer(owner, balance);
163   }
164 
165 }
166 
167 /**
168  * @title Contracts that should not own Tokens
169  * @author Remco Bloemen <remco@2π.com>
170  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
171  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
172  * owner to reclaim the tokens.
173  */
174 contract HasNoTokens is CanReclaimToken {
175 
176  /**
177   * @dev Reject all ERC23 compatible tokens
178   * @param from_ address The address that is transferring the tokens
179   * @param value_ uint256 the amount of the specified token
180   * @param data_ Bytes The data passed from the caller.
181   */
182   function tokenFallback(address from_, uint256 value_, bytes data_) pure external {
183     from_;
184     value_;
185     data_;
186     revert();
187   }
188 
189 }
190 
191 /**
192  * @title Destructible
193  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
194  */
195 contract Destructible is Ownable {
196 
197   function Destructible() public payable { }
198 
199   /**
200    * @dev Transfers the current balance to the owner and terminates the contract.
201    */
202   function destroy() onlyOwner public {
203     selfdestruct(owner);
204   }
205 
206   function destroyAndSend(address _recipient) onlyOwner public {
207     selfdestruct(_recipient);
208   }
209 }
210 
211 /**
212  * @title Basic token
213  * @dev Basic version of StandardToken, with no allowances.
214  */
215 contract BasicToken is ERC20Basic {
216   using SafeMath for uint256;
217 
218   mapping(address => uint256) balances;
219 
220   /**
221   * @dev transfer token for a specified address
222   * @param _to The address to transfer to.
223   * @param _value The amount to be transferred.
224   */
225   function transfer(address _to, uint256 _value) public returns (bool) {
226     require(_to != address(0));
227     require(_value <= balances[msg.sender]);
228 
229     // SafeMath.sub will throw if there is not enough balance.
230     balances[msg.sender] = balances[msg.sender].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     Transfer(msg.sender, _to, _value);
233     return true;
234   }
235 
236   /**
237   * @dev Gets the balance of the specified address.
238   * @param _owner The address to query the the balance of.
239   * @return An uint256 representing the amount owned by the passed address.
240   */
241   function balanceOf(address _owner) public view returns (uint256 balance) {
242     return balances[_owner];
243   }
244 
245 }
246 
247 /**
248  * @title Standard ERC20 token
249  *
250  * @dev Implementation of the basic standard token.
251  * @dev https://github.com/ethereum/EIPs/issues/20
252  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
253  */
254 contract StandardToken is ERC20, BasicToken {
255 
256   mapping (address => mapping (address => uint256)) internal allowed;
257 
258 
259   /**
260    * @dev Transfer tokens from one address to another
261    * @param _from address The address which you want to send tokens from
262    * @param _to address The address which you want to transfer to
263    * @param _value uint256 the amount of tokens to be transferred
264    */
265   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
266     require(_to != address(0));
267     require(_value <= balances[_from]);
268     require(_value <= allowed[_from][msg.sender]);
269 
270     balances[_from] = balances[_from].sub(_value);
271     balances[_to] = balances[_to].add(_value);
272     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
273     Transfer(_from, _to, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
279    *
280    * Beware that changing an allowance with this method brings the risk that someone may use both the old
281    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
282    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
283    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284    * @param _spender The address which will spend the funds.
285    * @param _value The amount of tokens to be spent.
286    */
287   function approve(address _spender, uint256 _value) public returns (bool) {
288     allowed[msg.sender][_spender] = _value;
289     Approval(msg.sender, _spender, _value);
290     return true;
291   }
292 
293   /**
294    * @dev Function to check the amount of tokens that an owner allowed to a spender.
295    * @param _owner address The address which owns the funds.
296    * @param _spender address The address which will spend the funds.
297    * @return A uint256 specifying the amount of tokens still available for the spender.
298    */
299   function allowance(address _owner, address _spender) public view returns (uint256) {
300     return allowed[_owner][_spender];
301   }
302 
303   /**
304    * approve should be called when allowed[_spender] == 0. To increment
305    * allowed value is better to use this function to avoid 2 calls (and wait until
306    * the first transaction is mined)
307    * From MonolithDAO Token.sol
308    */
309   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
310     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
311     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312     return true;
313   }
314 
315   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
316     uint oldValue = allowed[msg.sender][_spender];
317     if (_subtractedValue > oldValue) {
318       allowed[msg.sender][_spender] = 0;
319     } else {
320       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
321     }
322     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 
326 }
327 
328 /**
329  * @title Mintable token
330  * @dev Simple ERC20 Token example, with mintable token creation
331  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
332  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
333  */
334 
335 contract MintableToken is StandardToken, Ownable {
336   event Mint(address indexed to, uint256 amount);
337   event MintFinished();
338 
339   bool public mintingFinished = false;
340 
341 
342   modifier canMint() {
343     require(!mintingFinished);
344     _;
345   }
346 
347   /**
348    * @dev Function to mint tokens
349    * @param _to The address that will receive the minted tokens.
350    * @param _amount The amount of tokens to mint.
351    * @return A boolean that indicates if the operation was successful.
352    */
353   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
354     totalSupply = totalSupply.add(_amount);
355     balances[_to] = balances[_to].add(_amount);
356     Mint(_to, _amount);
357     Transfer(address(0), _to, _amount);
358     return true;
359   }
360 
361   /**
362    * @dev Function to stop minting new tokens.
363    * @return True if the operation was successful.
364    */
365   function finishMinting() onlyOwner canMint public returns (bool) {
366     mintingFinished = true;
367     MintFinished();
368     return true;
369   }
370 }
371 
372 /**
373  * @title TokenVesting
374  * @dev A token holder contract that can release its token balance gradually like a
375  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
376  * owner.
377  */
378 contract TokenVesting is Ownable {
379   using SafeMath for uint256;
380   using SafeERC20 for ERC20Basic;
381 
382   event Released(uint256 amount);
383   event Revoked();
384 
385   // beneficiary of tokens after they are released
386   address public beneficiary;
387 
388   uint256 public cliff;
389   uint256 public start;
390   uint256 public duration;
391 
392   bool public revocable;
393 
394   mapping (address => uint256) public released;
395   mapping (address => bool) public revoked;
396 
397   /**
398    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
399    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
400    * of the balance will have vested.
401    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
402    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
403    * @param _duration duration in seconds of the period in which the tokens will vest
404    * @param _revocable whether the vesting is revocable or not
405    */
406   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
407     require(_beneficiary != address(0));
408     require(_cliff <= _duration);
409 
410     beneficiary = _beneficiary;
411     revocable = _revocable;
412     duration = _duration;
413     cliff = _start.add(_cliff);
414     start = _start;
415   }
416 
417   /**
418    * @notice Transfers vested tokens to beneficiary.
419    * @param token ERC20 token which is being vested
420    */
421   function release(ERC20Basic token) public {
422     uint256 unreleased = releasableAmount(token);
423 
424     require(unreleased > 0);
425 
426     released[token] = released[token].add(unreleased);
427 
428     token.safeTransfer(beneficiary, unreleased);
429 
430     Released(unreleased);
431   }
432 
433   /**
434    * @notice Allows the owner to revoke the vesting. Tokens already vested
435    * remain in the contract, the rest are returned to the owner.
436    * @param token ERC20 token which is being vested
437    */
438   function revoke(ERC20Basic token) public onlyOwner {
439     require(revocable);
440     require(!revoked[token]);
441 
442     uint256 balance = token.balanceOf(this);
443 
444     uint256 unreleased = releasableAmount(token);
445     uint256 refund = balance.sub(unreleased);
446 
447     revoked[token] = true;
448 
449     token.safeTransfer(owner, refund);
450 
451     Revoked();
452   }
453 
454   /**
455    * @dev Calculates the amount that has already vested but hasn't been released yet.
456    * @param token ERC20 token which is being vested
457    */
458   function releasableAmount(ERC20Basic token) public view returns (uint256) {
459     return vestedAmount(token).sub(released[token]);
460   }
461 
462   /**
463    * @dev Calculates the amount that has already vested.
464    * @param token ERC20 token which is being vested
465    */
466   function vestedAmount(ERC20Basic token) public view returns (uint256) {
467     uint256 currentBalance = token.balanceOf(this);
468     uint256 totalBalance = currentBalance.add(released[token]);
469 
470     if (now < cliff) {
471       return 0;
472     } else if (now >= start.add(duration) || revoked[token]) {
473       return totalBalance;
474     } else {
475       return totalBalance.mul(now.sub(start)).div(duration);
476     }
477   }
478 }
479 
480 
481 // ==== AALM Contracts ===
482 
483 contract BurnableToken is StandardToken {
484     using SafeMath for uint256;
485 
486     event Burn(address indexed from, uint256 amount);
487     event BurnRewardIncreased(address indexed from, uint256 value);
488 
489     /**
490     * @dev Sending ether to contract increases burning reward 
491     */
492     function() public payable {
493         if(msg.value > 0){
494             BurnRewardIncreased(msg.sender, msg.value);    
495         }
496     }
497 
498     /**
499      * @dev Calculates how much ether one will receive in reward for burning tokens
500      * @param _amount of tokens to be burned
501      */
502     function burnReward(uint256 _amount) public constant returns(uint256){
503         return this.balance.mul(_amount).div(totalSupply);
504     }
505 
506     /**
507     * @dev Burns tokens and send reward
508     * This is internal function because it DOES NOT check 
509     * if _from has allowance to burn tokens.
510     * It is intended to be used in transfer() and transferFrom() which do this check.
511     * @param _from The address which you want to burn tokens from
512     * @param _amount of tokens to be burned
513     */
514     function burn(address _from, uint256 _amount) internal returns(bool){
515         require(balances[_from] >= _amount);
516         
517         uint256 reward = burnReward(_amount);
518         assert(this.balance - reward > 0);
519 
520         balances[_from] = balances[_from].sub(_amount);
521         totalSupply = totalSupply.sub(_amount);
522         //assert(totalSupply >= 0); //Check is not needed because totalSupply.sub(value) will already throw if this condition is not met
523         
524         _from.transfer(reward);
525         Burn(_from, _amount);
526         Transfer(_from, address(0), _amount);
527         return true;
528     }
529 
530     /**
531     * @dev Transfers or burns tokens
532     * Burns tokens transferred to this contract itself or to zero address
533     * @param _to The address to transfer to or token contract address to burn.
534     * @param _value The amount to be transferred.
535     */
536     function transfer(address _to, uint256 _value) public returns (bool) {
537         if( (_to == address(this)) || (_to == 0) ){
538             return burn(msg.sender, _value);
539         }else{
540             return super.transfer(_to, _value);
541         }
542     }
543 
544     /**
545     * @dev Transfer tokens from one address to another 
546     * or burns them if _to is this contract or zero address
547     * @param _from address The address which you want to send tokens from
548     * @param _to address The address which you want to transfer to
549     * @param _value uint256 the amout of tokens to be transfered
550     */
551     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
552         if( (_to == address(this)) || (_to == 0) ){
553             var _allowance = allowed[_from][msg.sender];
554             //require (_value <= _allowance); //Check is not needed because _allowance.sub(_value) will already throw if this condition is not met
555             allowed[_from][msg.sender] = _allowance.sub(_value);
556             return burn(_from, _value);
557         }else{
558             return super.transferFrom(_from, _to, _value);
559         }
560     }
561 
562 }
563 contract DNTXToken is BurnableToken, MintableToken, HasNoContracts, HasNoTokens {
564     string public symbol = 'DNTX';
565     string public name = 'Dentix';
566     uint8 public constant decimals = 18;
567 
568     address founder;    //founder address to allow him transfer tokens while minting
569     function init(address _founder) onlyOwner public{
570         founder = _founder;
571     }
572 
573     /**
574      * Allow transfer only after crowdsale finished
575      */
576     modifier canTransfer() {
577         require(mintingFinished || msg.sender == founder);
578         _;
579     }
580     
581     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
582         return BurnableToken.transfer(_to, _value);
583     }
584 
585     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
586         return BurnableToken.transferFrom(_from, _to, _value);
587     }
588 }
589 
590 contract DNTXCrowdsale is Ownable, Destructible {
591     using SafeMath for uint256;
592     
593     uint8 private constant PERCENT_DIVIDER = 100;              
594 
595     event SpecialMint(address beneficiary, uint256 amount, string description);
596 
597     enum State { NotStarted, PreICO, ICO, Finished }
598     State public state;         //Current contract state                     
599 
600     struct ICOBonus {
601         uint32 expire;       //timestamp of date when this bonus expires (purshases before this time will use the bonus)
602         uint8 percent;
603     }
604     ICOBonus[] public icoBonuses;    //Array of ICO bonuses
605 
606     uint256 public baseRate;           //how many DNTX one will get for 1 ETH during main sale without bonus
607     uint8   public preICOBonusPercent; //Pre-ICO bonus percent
608     uint32  public icoStartTimestamp;  //timestamp of ICO start
609     uint32  public icoEndTimestamp;    //timestamp of ICO end
610     uint256 public icoGoal;            //How much ether we need to collect to assume ICO is successfull
611     uint256 public hardCap;            //Max amount possibly collected
612 
613     DNTXToken public token;                                 
614 
615     uint256 public icoCollected;
616     uint256 public totalCollected;
617     mapping(address => uint256) public icoContributions; //amount of ether received from an investor during ICO
618 
619     function DNTXCrowdsale() public{
620         state = State.NotStarted;
621         token = new DNTXToken();
622         token.init(owner);
623     }   
624 
625     function() public payable {
626         require(msg.value > 0);
627         require(isOpen());
628 
629         totalCollected = totalCollected.add(msg.value);
630         if(state == State.ICO){
631             require(totalCollected <= hardCap);
632             icoCollected = icoCollected.add(msg.value);
633             icoContributions[msg.sender] = icoContributions[msg.sender].add(msg.value);
634         }
635 
636         uint256 rate = currentRate();
637         assert(rate > 0);
638 
639         uint256 amount = rate.mul(msg.value);
640         assert(token.mint(msg.sender, amount));
641     }
642 
643     function mintTokens(address beneficiary, uint256 amount, string description) onlyOwner public {
644         assert(token.mint(beneficiary, amount));
645         SpecialMint(beneficiary, amount, description);
646     }
647 
648 
649     function isOpen() view public returns(bool){
650         if(baseRate == 0) return false;
651         if(state == State.NotStarted || state == State.Finished) return false;
652         if(state == State.PreICO) return true;
653         if(state == State.ICO){
654             if(totalCollected >= hardCap) return false;
655             return (icoStartTimestamp <= now) && (now <= icoEndTimestamp);
656         }
657     }
658     function currentRate() view public returns(uint256){
659         if(state == State.PreICO) {
660             return baseRate.add( baseRate.mul(preICOBonusPercent).div(PERCENT_DIVIDER) );
661         }else if(state == State.ICO){
662             for(uint8 i=0; i < icoBonuses.length; i++){
663                 ICOBonus storage b = icoBonuses[i];
664                 if(now <= b.expire){
665                     return baseRate.add( baseRate.mul(b.percent).div(PERCENT_DIVIDER) );
666                 }
667             }
668             return baseRate;
669         }else{
670             return 0;
671         }
672     }
673 
674     function setBaseRate(uint256 rate) onlyOwner public {
675         require(state != State.ICO && state != State.Finished);
676         baseRate = rate;
677     }
678     function setPreICOBonus(uint8 percent) onlyOwner public {
679         preICOBonusPercent = percent;
680     }
681     function setupAndStartPreICO(uint256 rate, uint8 percent) onlyOwner external {
682         setBaseRate(rate);
683         setPreICOBonus(percent);
684         startPreICO();
685     }
686 
687     function setupICO(uint32 startTimestamp, uint32 endTimestamp, uint256 goal, uint256 cap, uint32[] expires, uint8[] percents) onlyOwner external {
688         require(state != State.ICO && state != State.Finished);
689         icoStartTimestamp = startTimestamp;
690         icoEndTimestamp = endTimestamp;
691         icoGoal = goal;
692         hardCap = cap;
693 
694         require(expires.length == percents.length);
695         uint32 prevExpire;
696         for(uint8 i=0;  i < expires.length; i++){
697             require(prevExpire < expires[i]);
698             icoBonuses.push(ICOBonus({expire:expires[i], percent:percents[i]}));
699             prevExpire = expires[i];
700         }
701     }
702 
703     /**
704     * @notice Start PreICO stage
705     */
706     function startPreICO() onlyOwner public {
707         require(state == State.NotStarted);
708         require(baseRate != 0);
709         state = State.PreICO;
710     }
711     /**
712     * @notice Finish PreICO stage and start ICO (after time comes)
713     */
714     function finishPreICO() onlyOwner external {
715         require(state == State.PreICO);
716         require(icoStartTimestamp != 0 && icoEndTimestamp != 0);
717         state = State.ICO;
718     }
719     /**
720     * @notice Close crowdsale, finish minting (allowing token transfers), transfers token ownership to the founder
721     */
722     function finalizeCrowdsale() onlyOwner external {
723         state = State.Finished;
724         token.finishMinting();
725         token.transferOwnership(owner);
726         if(icoCollected >= icoGoal && this.balance > 0) {
727             claimEther();
728         }
729     }
730     /**
731     * @notice Claim collected ether without closing crowdsale
732     */
733     function claimEther() onlyOwner public {
734         require(state == State.PreICO || icoCollected >= icoGoal);
735         require(this.balance > 0);
736         owner.transfer(this.balance);
737     }
738 
739     /**
740     * @notice Sends all contributed ether back if minimum cap is not reached by the end of crowdsale
741     */
742     function refund() public returns(bool){
743         return refundTo(msg.sender);
744     }
745     function refundTo(address beneficiary) public returns(bool) {
746         require(icoCollected < icoGoal);
747         require(icoContributions[beneficiary] > 0);
748         require( (state == State.Finished) || (state == State.ICO && (now > icoEndTimestamp)) );
749 
750         uint256 _refund = icoContributions[beneficiary];
751         icoContributions[beneficiary] = 0;
752         beneficiary.transfer(_refund);
753         return true;
754     }
755 
756 }