1 pragma solidity ^0.4.18;
2 
3 // ==== Open Zeppelin library ===
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
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 /**
63  * @title SafeERC20
64  * @dev Wrappers around ERC20 operations that throw on failure.
65  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
66  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
67  */
68 library SafeERC20 {
69   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
70     assert(token.transfer(to, value));
71   }
72 
73   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
74     assert(token.transferFrom(from, to, value));
75   }
76 
77   function safeApprove(ERC20 token, address spender, uint256 value) internal {
78     assert(token.approve(spender, value));
79   }
80 }
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable {
88   address public owner;
89 
90 
91   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93 
94   /**
95    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
96    * account.
97    */
98   function Ownable() public {
99     owner = msg.sender;
100   }
101 
102 
103   /**
104    * @dev Throws if called by any account other than the owner.
105    */
106   modifier onlyOwner() {
107     require(msg.sender == owner);
108     _;
109   }
110 
111 
112   /**
113    * @dev Allows the current owner to transfer control of the contract to a newOwner.
114    * @param newOwner The address to transfer ownership to.
115    */
116   function transferOwnership(address newOwner) public onlyOwner {
117     require(newOwner != address(0));
118     OwnershipTransferred(owner, newOwner);
119     owner = newOwner;
120   }
121 
122 }
123 
124 /**
125  * @title Contracts that should not own Ether
126  * @author Remco Bloemen <remco@2π.com>
127  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
128  * in the contract, it will allow the owner to reclaim this ether.
129  * @notice Ether can still be send to this contract by:
130  * calling functions labeled `payable`
131  * `selfdestruct(contract_address)`
132  * mining directly to the contract address
133 */
134 contract HasNoEther is Ownable {
135 
136   /**
137   * @dev Constructor that rejects incoming Ether
138   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
139   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
140   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
141   * we could use assembly to access msg.value.
142   */
143   function HasNoEther() public payable {
144     require(msg.value == 0);
145   }
146 
147   /**
148    * @dev Disallows direct send by settings a default function without the `payable` flag.
149    */
150   function() external {
151   }
152 
153   /**
154    * @dev Transfer all Ether held by the contract to the owner.
155    */
156   function reclaimEther() external onlyOwner {
157     assert(owner.send(this.balance));
158   }
159 }
160 
161 /**
162  * @title Contracts that should not own Contracts
163  * @author Remco Bloemen <remco@2π.com>
164  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
165  * of this contract to reclaim ownership of the contracts.
166  */
167 contract HasNoContracts is Ownable {
168 
169   /**
170    * @dev Reclaim ownership of Ownable contracts
171    * @param contractAddr The address of the Ownable to be reclaimed.
172    */
173   function reclaimContract(address contractAddr) external onlyOwner {
174     Ownable contractInst = Ownable(contractAddr);
175     contractInst.transferOwnership(owner);
176   }
177 }
178 
179 /**
180  * @title Contracts that should be able to recover tokens
181  * @author SylTi
182  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
183  * This will prevent any accidental loss of tokens.
184  */
185 contract CanReclaimToken is Ownable {
186   using SafeERC20 for ERC20Basic;
187 
188   /**
189    * @dev Reclaim all ERC20Basic compatible tokens
190    * @param token ERC20Basic The address of the token contract
191    */
192   function reclaimToken(ERC20Basic token) external onlyOwner {
193     uint256 balance = token.balanceOf(this);
194     token.safeTransfer(owner, balance);
195   }
196 
197 }
198 
199 /**
200  * @title Contracts that should not own Tokens
201  * @author Remco Bloemen <remco@2π.com>
202  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
203  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
204  * owner to reclaim the tokens.
205  */
206 contract HasNoTokens is CanReclaimToken {
207 
208  /**
209   * @dev Reject all ERC23 compatible tokens
210   * @param from_ address The address that is transferring the tokens
211   * @param value_ uint256 the amount of the specified token
212   * @param data_ Bytes The data passed from the caller.
213   */
214   function tokenFallback(address from_, uint256 value_, bytes data_) pure external {
215     from_;
216     value_;
217     data_;
218     revert();
219   }
220 
221 }
222 
223 /**
224  * @title Base contract for contracts that should not own things.
225  * @author Remco Bloemen <remco@2π.com>
226  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
227  * Owned contracts. See respective base contracts for details.
228  */
229 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
230 }
231 
232 /**
233  * @title Destructible
234  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
235  */
236 contract Destructible is Ownable {
237 
238   function Destructible() public payable { }
239 
240   /**
241    * @dev Transfers the current balance to the owner and terminates the contract.
242    */
243   function destroy() onlyOwner public {
244     selfdestruct(owner);
245   }
246 
247   function destroyAndSend(address _recipient) onlyOwner public {
248     selfdestruct(_recipient);
249   }
250 }
251 
252 /**
253  * @title Basic token
254  * @dev Basic version of StandardToken, with no allowances.
255  */
256 contract BasicToken is ERC20Basic {
257   using SafeMath for uint256;
258 
259   mapping(address => uint256) balances;
260 
261   /**
262   * @dev transfer token for a specified address
263   * @param _to The address to transfer to.
264   * @param _value The amount to be transferred.
265   */
266   function transfer(address _to, uint256 _value) public returns (bool) {
267     require(_to != address(0));
268     require(_value <= balances[msg.sender]);
269 
270     // SafeMath.sub will throw if there is not enough balance.
271     balances[msg.sender] = balances[msg.sender].sub(_value);
272     balances[_to] = balances[_to].add(_value);
273     Transfer(msg.sender, _to, _value);
274     return true;
275   }
276 
277   /**
278   * @dev Gets the balance of the specified address.
279   * @param _owner The address to query the the balance of.
280   * @return An uint256 representing the amount owned by the passed address.
281   */
282   function balanceOf(address _owner) public view returns (uint256 balance) {
283     return balances[_owner];
284   }
285 
286 }
287 
288 /**
289  * @title Standard ERC20 token
290  *
291  * @dev Implementation of the basic standard token.
292  * @dev https://github.com/ethereum/EIPs/issues/20
293  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
294  */
295 contract StandardToken is ERC20, BasicToken {
296 
297   mapping (address => mapping (address => uint256)) internal allowed;
298 
299 
300   /**
301    * @dev Transfer tokens from one address to another
302    * @param _from address The address which you want to send tokens from
303    * @param _to address The address which you want to transfer to
304    * @param _value uint256 the amount of tokens to be transferred
305    */
306   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
307     require(_to != address(0));
308     require(_value <= balances[_from]);
309     require(_value <= allowed[_from][msg.sender]);
310 
311     balances[_from] = balances[_from].sub(_value);
312     balances[_to] = balances[_to].add(_value);
313     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
314     Transfer(_from, _to, _value);
315     return true;
316   }
317 
318   /**
319    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
320    *
321    * Beware that changing an allowance with this method brings the risk that someone may use both the old
322    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
323    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
324    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
325    * @param _spender The address which will spend the funds.
326    * @param _value The amount of tokens to be spent.
327    */
328   function approve(address _spender, uint256 _value) public returns (bool) {
329     allowed[msg.sender][_spender] = _value;
330     Approval(msg.sender, _spender, _value);
331     return true;
332   }
333 
334   /**
335    * @dev Function to check the amount of tokens that an owner allowed to a spender.
336    * @param _owner address The address which owns the funds.
337    * @param _spender address The address which will spend the funds.
338    * @return A uint256 specifying the amount of tokens still available for the spender.
339    */
340   function allowance(address _owner, address _spender) public view returns (uint256) {
341     return allowed[_owner][_spender];
342   }
343 
344   /**
345    * approve should be called when allowed[_spender] == 0. To increment
346    * allowed value is better to use this function to avoid 2 calls (and wait until
347    * the first transaction is mined)
348    * From MonolithDAO Token.sol
349    */
350   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
351     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
352     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
353     return true;
354   }
355 
356   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
357     uint oldValue = allowed[msg.sender][_spender];
358     if (_subtractedValue > oldValue) {
359       allowed[msg.sender][_spender] = 0;
360     } else {
361       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
362     }
363     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
364     return true;
365   }
366 
367 }
368 
369 /**
370  * @title Mintable token
371  * @dev Simple ERC20 Token example, with mintable token creation
372  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
373  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
374  */
375 
376 contract MintableToken is StandardToken, Ownable {
377   event Mint(address indexed to, uint256 amount);
378   event MintFinished();
379 
380   bool public mintingFinished = false;
381 
382 
383   modifier canMint() {
384     require(!mintingFinished);
385     _;
386   }
387 
388   /**
389    * @dev Function to mint tokens
390    * @param _to The address that will receive the minted tokens.
391    * @param _amount The amount of tokens to mint.
392    * @return A boolean that indicates if the operation was successful.
393    */
394   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
395     totalSupply = totalSupply.add(_amount);
396     balances[_to] = balances[_to].add(_amount);
397     Mint(_to, _amount);
398     Transfer(address(0), _to, _amount);
399     return true;
400   }
401 
402   /**
403    * @dev Function to stop minting new tokens.
404    * @return True if the operation was successful.
405    */
406   function finishMinting() onlyOwner canMint public returns (bool) {
407     mintingFinished = true;
408     MintFinished();
409     return true;
410   }
411 }
412 
413 /**
414  * @title TokenVesting
415  * @dev A token holder contract that can release its token balance gradually like a
416  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
417  * owner.
418  */
419 contract TokenVesting is Ownable {
420   using SafeMath for uint256;
421   using SafeERC20 for ERC20Basic;
422 
423   event Released(uint256 amount);
424   event Revoked();
425 
426   // beneficiary of tokens after they are released
427   address public beneficiary;
428 
429   uint256 public cliff;
430   uint256 public start;
431   uint256 public duration;
432 
433   bool public revocable;
434 
435   mapping (address => uint256) public released;
436   mapping (address => bool) public revoked;
437 
438   /**
439    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
440    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
441    * of the balance will have vested.
442    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
443    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
444    * @param _duration duration in seconds of the period in which the tokens will vest
445    * @param _revocable whether the vesting is revocable or not
446    */
447   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
448     require(_beneficiary != address(0));
449     require(_cliff <= _duration);
450 
451     beneficiary = _beneficiary;
452     revocable = _revocable;
453     duration = _duration;
454     cliff = _start.add(_cliff);
455     start = _start;
456   }
457 
458   /**
459    * @notice Transfers vested tokens to beneficiary.
460    * @param token ERC20 token which is being vested
461    */
462   function release(ERC20Basic token) public {
463     uint256 unreleased = releasableAmount(token);
464 
465     require(unreleased > 0);
466 
467     released[token] = released[token].add(unreleased);
468 
469     token.safeTransfer(beneficiary, unreleased);
470 
471     Released(unreleased);
472   }
473 
474   /**
475    * @notice Allows the owner to revoke the vesting. Tokens already vested
476    * remain in the contract, the rest are returned to the owner.
477    * @param token ERC20 token which is being vested
478    */
479   function revoke(ERC20Basic token) public onlyOwner {
480     require(revocable);
481     require(!revoked[token]);
482 
483     uint256 balance = token.balanceOf(this);
484 
485     uint256 unreleased = releasableAmount(token);
486     uint256 refund = balance.sub(unreleased);
487 
488     revoked[token] = true;
489 
490     token.safeTransfer(owner, refund);
491 
492     Revoked();
493   }
494 
495   /**
496    * @dev Calculates the amount that has already vested but hasn't been released yet.
497    * @param token ERC20 token which is being vested
498    */
499   function releasableAmount(ERC20Basic token) public view returns (uint256) {
500     return vestedAmount(token).sub(released[token]);
501   }
502 
503   /**
504    * @dev Calculates the amount that has already vested.
505    * @param token ERC20 token which is being vested
506    */
507   function vestedAmount(ERC20Basic token) public view returns (uint256) {
508     uint256 currentBalance = token.balanceOf(this);
509     uint256 totalBalance = currentBalance.add(released[token]);
510 
511     if (now < cliff) {
512       return 0;
513     } else if (now >= start.add(duration) || revoked[token]) {
514       return totalBalance;
515     } else {
516       return totalBalance.mul(now.sub(start)).div(duration);
517     }
518   }
519 }
520 
521 
522 // ==== AALM Contracts ===
523 
524 contract AALMToken is MintableToken, NoOwner { //MintableToken is StandardToken, Ownable
525     string public symbol = 'AALM';
526     string public name = 'Alm Token';
527     uint8 public constant decimals = 18;
528 
529     address founder;    //founder address to allow him transfer tokens while minting
530     function init(address _founder) onlyOwner public{
531         founder = _founder;
532     }
533 
534     /**
535      * Allow transfer only after crowdsale finished
536      */
537     modifier canTransfer() {
538         require(mintingFinished || msg.sender == founder);
539         _;
540     }
541     
542     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
543         return super.transfer(_to, _value);
544     }
545 
546     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
547         return super.transferFrom(_from, _to, _value);
548     }
549 }
550 
551 contract AALMCrowdsale is Ownable, CanReclaimToken, Destructible {
552     using SafeMath for uint256;    
553 
554     uint32 private constant PERCENT_DIVIDER = 100;
555 
556     struct BulkBonus {
557         uint256 minAmount;      //Minimal amount to receive bonus (including this amount)
558         uint32 bonusPercent;    //a bonus percent, so that bonus = amount.mul(bonusPercent).div(PERCENT_DIVIDER)
559     }
560 
561     uint64 public startTimestamp;   //Crowdsale start timestamp
562     uint64 public endTimestamp;     //Crowdsale end timestamp
563     uint256 public minCap;          //minimal amount of sold tokens (if not reached - ETH may be refunded)
564     uint256 public hardCap;         //total amount of tokens available
565     uint256 public baseRate;        //how many tokens will be minted for 1 ETH (like 1000 AALM for 1 ETH) without bonuses
566 
567     uint32 public maxTimeBonusPercent;  //A maximum time bonus percent: at the start of crowdsale timeBonus = value.mul(baseRate).mul(maxTimeBonusPercent).div(PERCENT_DIVIDER)
568     uint32 public referrerBonusPercent; //A bonus percent that refferer will receive, so that referrerBonus = value.mul(baseRate).mul(referrerBonusPercent).div(PERCENT_DIVIDER)
569     uint32 public referralBonusPercent; //A bonus percent that refferal will receive, so that referralBonus = value.mul(baseRate).mul(referralBonusPercent).div(PERCENT_DIVIDER)
570     BulkBonus[] public bulkBonuses;     //Bulk Bonuses sorted by ether amount (minimal amount first)
571   
572 
573     uint256 public tokensMinted;    //total amount of minted tokens
574     uint256 public tokensSold;      //total amount of tokens sold(!) on ICO, including all bonuses
575     uint256 public collectedEther;  //total amount of ether collected during ICO (without Pre-ICO)
576 
577     mapping(address => uint256) contributions; //amount of ether (in wei)received from a buyer
578 
579     AALMToken public token;
580     TokenVesting public founderVestingContract; //Contract which holds Founder's tokens
581 
582     bool public finalized;
583 
584     function AALMCrowdsale(uint64 _startTimestamp, uint64 _endTimestamp, uint256 _hardCap, uint256 _minCap, 
585         uint256 _founderTokensImmediate, uint256 _founderTokensVested, uint256 _vestingDuration,
586         uint256 _baseRate, uint32 _maxTimeBonusPercent, uint32 _referrerBonusPercent, uint32 _referralBonusPercent, 
587         uint256[] bulkBonusMinAmounts, uint32[] bulkBonusPercents 
588         ) public {
589         require(_startTimestamp > now);
590         require(_startTimestamp < _endTimestamp);
591         startTimestamp = _startTimestamp;
592         endTimestamp = _endTimestamp;
593 
594         require(_hardCap > 0);
595         hardCap = _hardCap;
596 
597         minCap = _minCap;
598 
599         initRatesAndBonuses(_baseRate, _maxTimeBonusPercent, _referrerBonusPercent, _referralBonusPercent, bulkBonusMinAmounts, bulkBonusPercents);
600 
601         token = new AALMToken();
602         token.init(owner);
603 
604         require(_founderTokensImmediate.add(_founderTokensVested) < _hardCap);
605         mintTokens(owner, _founderTokensImmediate);
606 
607         founderVestingContract = new TokenVesting(owner, endTimestamp, 0, _vestingDuration, false);
608         mintTokens(founderVestingContract, _founderTokensVested);
609     }
610 
611     function initRatesAndBonuses(
612         uint256 _baseRate, uint32 _maxTimeBonusPercent, uint32 _referrerBonusPercent, uint32 _referralBonusPercent, 
613         uint256[] bulkBonusMinAmounts, uint32[] bulkBonusPercents 
614         ) internal {
615 
616         require(_baseRate > 0);
617         baseRate = _baseRate;
618 
619         maxTimeBonusPercent = _maxTimeBonusPercent;
620         referrerBonusPercent = _referrerBonusPercent;
621         referralBonusPercent = _referralBonusPercent;
622 
623         uint256 prevBulkAmount = 0;
624         require(bulkBonusMinAmounts.length == bulkBonusPercents.length);
625         bulkBonuses.length = bulkBonusMinAmounts.length;
626         for(uint8 i=0; i < bulkBonuses.length; i++){
627             bulkBonuses[i] = BulkBonus({minAmount:bulkBonusMinAmounts[i], bonusPercent:bulkBonusPercents[i]});
628             BulkBonus storage bb = bulkBonuses[i];
629             require(prevBulkAmount < bb.minAmount);
630             prevBulkAmount = bb.minAmount;
631         }
632     }
633 
634     /**
635     * @notice Distribute tokens sold during Pre-ICO
636     * @param beneficiaries Array of beneficiari addresses
637     * @param amounts Array of amounts of tokens to send
638     */
639     function distributePreICOTokens(address[] beneficiaries, uint256[] amounts) onlyOwner public {
640         require(beneficiaries.length == amounts.length);
641         for(uint256 i=0; i<beneficiaries.length; i++){
642             mintTokens(beneficiaries[i], amounts[i]);
643         }
644     }
645 
646     /**
647     * @notice Sell tokens directly, without referral bonuses
648     */
649     function () payable public {
650         sale(msg.sender, msg.value, address(0));
651     }
652     /**
653     * @notice Sell tokens via RefferalCrowdsale contract
654     * @param beneficiary Original sender (buyer)
655     * @param referrer The partner who referered the buyer
656     */
657     function referralSale(address beneficiary, address referrer) payable public returns(bool) {
658         sale(beneficiary, msg.value, referrer);
659         return true;
660     }
661     /**
662     * @dev Internal functions to sell tokens
663     * @param beneficiary who should receive tokens (the buyer)
664     * @param value of ether sent by buyer
665     * @param referrer who should receive referrer bonus, if any. Zero address if no referral bonuses should be paid
666     */
667     function sale(address beneficiary, uint256 value, address referrer) internal {
668         require(crowdsaleOpen());
669         require(value > 0);
670         collectedEther = collectedEther.add(value);
671         contributions[beneficiary] = contributions[beneficiary].add(value);
672         uint256 amount;
673         if(referrer == address(0)){
674             amount = getTokensWithBonuses(value, false);
675         } else{
676             amount = getTokensWithBonuses(value, true);
677             uint256 referrerAmount  = getReferrerBonus(value);
678             tokensSold = tokensSold.add(referrerAmount);
679             mintTokens(referrer, referrerAmount);
680         }
681         tokensSold = tokensSold.add(amount);
682         mintTokens(beneficiary, amount);
683     }
684 
685     /**
686     * @notice Mint tokens for purshases with Non-Ether currencies
687     * @param beneficiary whom to send tokend
688     * @param amount how much tokens to send
689     * param message reason why we are sending tokens (not stored anythere, only in transaction itself)
690     */
691     function saleNonEther(address beneficiary, uint256 amount, string /*message*/) public onlyOwner {
692         mintTokens(beneficiary, amount);
693     }
694 
695     /**
696     * @notice If crowdsale is running
697     */
698     function crowdsaleOpen() view public returns(bool) {
699         return (!finalized) && (tokensMinted < hardCap) && (startTimestamp <= now) && (now <= endTimestamp);
700     }
701 
702     /**
703     * @notice Calculates how many tokens are left to sale
704     * @return amount of tokens left before hard cap reached
705     */
706     function getTokensLeft() view public returns(uint256) {
707         return hardCap.sub(tokensMinted);
708     }
709 
710     /**
711     * @notice Calculates how many tokens one should receive at curent time for a specified value of ether
712     * @param value of ether to get bonus for
713     * @param withReferralBonus if should add referral bonus
714     * @return bonus tokens
715     */
716     function getTokensWithBonuses(uint256 value, bool withReferralBonus) view public returns(uint256) {
717         uint256 amount = value.mul(baseRate);
718         amount = amount.add(getTimeBonus(value)).add(getBulkBonus(value));
719         if(withReferralBonus){
720             amount = amount.add(getReferralBonus(value));
721         }
722         return amount;
723     }
724 
725     /**
726     * @notice Calculates current time bonus
727     * @param value of ether to get bonus for
728     * @return bonus tokens
729     */
730     function getTimeBonus(uint256 value) view public returns(uint256) {
731         uint256 maxBonus = value.mul(baseRate).mul(maxTimeBonusPercent).div(PERCENT_DIVIDER);
732         return maxBonus.mul(endTimestamp - now).div(endTimestamp - startTimestamp);
733     }
734 
735     /**
736     * @notice Calculates a bulk bonus for a specified value of ether
737     * @param value of ether to get bonus for
738     * @return bonus tokens
739     */
740     function getBulkBonus(uint256 value) view public returns(uint256) {
741         for(uint8 i=uint8(bulkBonuses.length); i > 0; i--){
742             uint8 idx = i - 1; //if i  = bulkBonuses.length-1 to 0, i-- fails on last iteration
743             if (value >= bulkBonuses[idx].minAmount) {
744                 return value.mul(baseRate).mul(bulkBonuses[idx].bonusPercent).div(PERCENT_DIVIDER);
745             }
746         }
747         return 0;
748     }
749 
750     /**
751     * @notice Calculates referrer bonus
752     * @param value of ether  to get bonus for
753     * @return bonus tokens
754     */
755     function getReferrerBonus(uint256 value) view public returns(uint256) {
756         return value.mul(baseRate).mul(referrerBonusPercent).div(PERCENT_DIVIDER);
757     }
758     /**
759     * @notice Calculates referral bonus
760     * @param value of ether  to get bonus for
761     * @return bonus tokens
762     */
763     function getReferralBonus(uint256 value) view public returns(uint256) {
764         return value.mul(baseRate).mul(referralBonusPercent).div(PERCENT_DIVIDER);
765     }
766 
767     /**
768     * @dev Helper function to mint tokens and increase tokensMinted counter
769     */
770     function mintTokens(address beneficiary, uint256 amount) internal {
771         tokensMinted = tokensMinted.add(amount);
772         require(tokensMinted <= hardCap);
773         assert(token.mint(beneficiary, amount));
774     }
775 
776     /**
777     * @notice Sends all contributed ether back if minimum cap is not reached by the end of crowdsale
778     */
779     function refund() public returns(bool){
780         return refundTo(msg.sender);
781     }
782     function refundTo(address beneficiary) public returns(bool) {
783         require(contributions[beneficiary] > 0);
784         require(finalized || (now > endTimestamp));
785         require(tokensSold < minCap);
786 
787         uint256 _refund = contributions[beneficiary];
788         contributions[beneficiary] = 0;
789         beneficiary.transfer(_refund);
790         return true;
791     }
792 
793     /**
794     * @notice Closes crowdsale, finishes minting (allowing token transfers), transfers token ownership to the owner
795     */
796     function finalizeCrowdsale() public onlyOwner {
797         finalized = true;
798         token.finishMinting();
799         token.transferOwnership(owner);
800         if(tokensSold >= minCap && this.balance > 0){
801             owner.transfer(this.balance);
802         }
803     }
804     /**
805     * @notice Claim collected ether without closing crowdsale
806     */
807     function claimEther() public onlyOwner {
808         require(tokensSold >= minCap);
809         owner.transfer(this.balance);
810     }
811 
812 }