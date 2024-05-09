1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   /**
16   * @dev transfer token for a specified address
17   * @param _to The address to transfer to.
18   * @param _value The amount to be transferred.
19   */
20   function transfer(address _to, uint256 _value) public returns (bool) {
21     require(_to != address(0));
22 
23     // SafeMath.sub will throw if there is not enough balance.
24     balances[msg.sender] = balances[msg.sender].sub(_value);
25     balances[_to] = balances[_to].add(_value);
26     Transfer(msg.sender, _to, _value);
27     return true;
28   }
29 
30   /**
31   * @dev Gets the balance of the specified address.
32   * @param _owner The address to query the the balance of.
33   * @return An uint256 representing the amount owned by the passed address.
34   */
35   function balanceOf(address _owner) public constant returns (uint256 balance) {
36     return balances[_owner];
37   }
38 
39 }
40 
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender) public constant returns (uint256);
43   function transferFrom(address from, address to, uint256 value) public returns (bool);
44   function approve(address spender, uint256 value) public returns (bool);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 contract LimitedTransferToken is ERC20 {
49 
50   /**
51    * @dev Checks whether it can transfer or otherwise throws.
52    */
53   modifier canTransfer(address _sender, uint256 _value) {
54    require(_value <= transferableTokens(_sender, uint64(now)));
55    _;
56   }
57 
58   /**
59    * @dev Checks modifier and allows transfer if tokens are not locked.
60    * @param _to The address that will receive the tokens.
61    * @param _value The amount of tokens to be transferred.
62    */
63   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
64     return super.transfer(_to, _value);
65   }
66 
67   /**
68   * @dev Checks modifier and allows transfer if tokens are not locked.
69   * @param _from The address that will send the tokens.
70   * @param _to The address that will receive the tokens.
71   * @param _value The amount of tokens to be transferred.
72   */
73   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
74     return super.transferFrom(_from, _to, _value);
75   }
76 
77   /**
78    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
79    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
80    * specific logic for limiting token transferability for a holder over time.
81    */
82   function transferableTokens(address holder, uint64 /*time*/) public constant returns (uint256) {
83     return balanceOf(holder);
84   }
85 }
86 
87 library Math {
88   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
89     return a >= b ? a : b;
90   }
91 
92   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
93     return a < b ? a : b;
94   }
95 
96   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
97     return a >= b ? a : b;
98   }
99 
100   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
101     return a < b ? a : b;
102   }
103 }
104 
105 contract Ownable {
106   address public owner;
107 
108 
109   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111 
112   /**
113    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
114    * account.
115    */
116   function Ownable() {
117     owner = msg.sender;
118   }
119 
120 
121   /**
122    * @dev Throws if called by any account other than the owner.
123    */
124   modifier onlyOwner() {
125     require(msg.sender == owner);
126     _;
127   }
128 
129 
130   /**
131    * @dev Allows the current owner to transfer control of the contract to a newOwner.
132    * @param newOwner The address to transfer ownership to.
133    */
134   function transferOwnership(address newOwner) onlyOwner public {
135     require(newOwner != address(0));
136     OwnershipTransferred(owner, newOwner);
137     owner = newOwner;
138   }
139 
140 }
141 
142 contract CanReclaimToken is Ownable {
143   using SafeERC20 for ERC20Basic;
144 
145   /**
146    * @dev Reclaim all ERC20Basic compatible tokens
147    * @param token ERC20Basic The address of the token contract
148    */
149   function reclaimToken(ERC20Basic token) external onlyOwner {
150     uint256 balance = token.balanceOf(this);
151     token.safeTransfer(owner, balance);
152   }
153 
154 }
155 
156 contract HasNoEther is Ownable {
157 
158   /**
159   * @dev Constructor that rejects incoming Ether
160   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
161   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
162   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
163   * we could use assembly to access msg.value.
164   */
165   function HasNoEther() payable {
166     require(msg.value == 0);
167   }
168 
169   /**
170    * @dev Disallows direct send by settings a default function without the `payable` flag.
171    */
172   function() external {
173   }
174 
175   /**
176    * @dev Transfer all Ether held by the contract to the owner.
177    */
178   function reclaimEther() external onlyOwner {
179     assert(owner.send(this.balance));
180   }
181 }
182 
183 contract HasNoTokens is CanReclaimToken {
184 
185  /**
186   * @dev Reject all ERC23 compatible tokens
187     **/
188   function tokenFallback(address /*from_*/, uint256 /*value_*/, bytes /*data_*/) external {
189     revert();
190   }
191 
192 }
193 
194 contract Pausable is Ownable {
195   event Pause();
196   event Unpause();
197 
198   bool public paused = false;
199 
200 
201   /**
202    * @dev Modifier to make a function callable only when the contract is not paused.
203    */
204   modifier whenNotPaused() {
205     require(!paused);
206     _;
207   }
208 
209   /**
210    * @dev Modifier to make a function callable only when the contract is paused.
211    */
212   modifier whenPaused() {
213     require(paused);
214     _;
215   }
216 
217   /**
218    * @dev called by the owner to pause, triggers stopped state
219    */
220   function pause() onlyOwner whenNotPaused public {
221     paused = true;
222     Pause();
223   }
224 
225   /**
226    * @dev called by the owner to unpause, returns to normal state
227    */
228   function unpause() onlyOwner whenPaused public {
229     paused = false;
230     Unpause();
231   }
232 }
233 
234 library SafeERC20 {
235   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
236     assert(token.transfer(to, value));
237   }
238 
239   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
240     assert(token.transferFrom(from, to, value));
241   }
242 
243   function safeApprove(ERC20 token, address spender, uint256 value) internal {
244     assert(token.approve(spender, value));
245   }
246 }
247 
248 library SafeMath {
249   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
250     uint256 c = a * b;
251     assert(a == 0 || c / a == b);
252     return c;
253   }
254 
255   function div(uint256 a, uint256 b) internal constant returns (uint256) {
256     // assert(b > 0); // Solidity automatically throws when dividing by 0
257     uint256 c = a / b;
258     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
259     return c;
260   }
261 
262   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
263     assert(b <= a);
264     return a - b;
265   }
266 
267   function add(uint256 a, uint256 b) internal constant returns (uint256) {
268     uint256 c = a + b;
269     assert(c >= a);
270     return c;
271   }
272 }
273 
274 contract StandardToken is ERC20, BasicToken {
275 
276   mapping (address => mapping (address => uint256)) allowed;
277 
278 
279   /**
280    * @dev Transfer tokens from one address to another
281    * @param _from address The address which you want to send tokens from
282    * @param _to address The address which you want to transfer to
283    * @param _value uint256 the amount of tokens to be transferred
284    */
285   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
286     require(_to != address(0));
287 
288     uint256 _allowance = allowed[_from][msg.sender];
289 
290     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
291     // require (_value <= _allowance);
292 
293     balances[_from] = balances[_from].sub(_value);
294     balances[_to] = balances[_to].add(_value);
295     allowed[_from][msg.sender] = _allowance.sub(_value);
296     Transfer(_from, _to, _value);
297     return true;
298   }
299 
300   /**
301    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
302    *
303    * Beware that changing an allowance with this method brings the risk that someone may use both the old
304    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
305    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
306    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307    * @param _spender The address which will spend the funds.
308    * @param _value The amount of tokens to be spent.
309    */
310   function approve(address _spender, uint256 _value) public returns (bool) {
311       require(_value == 0 || allowed[msg.sender][_spender] == 0);
312       allowed[msg.sender][_spender] = _value;
313       Approval(msg.sender, _spender, _value);
314     return true;
315   }
316 
317   /**
318    * @dev Function to check the amount of tokens that an owner allowed to a spender.
319    * @param _owner address The address which owns the funds.
320    * @param _spender address The address which will spend the funds.
321    * @return A uint256 specifying the amount of tokens still available for the spender.
322    */
323   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
324     return allowed[_owner][_spender];
325   }
326 
327   /**
328    * approve should be called when allowed[_spender] == 0. To increment
329    * allowed value is better to use this function to avoid 2 calls (and wait until
330    * the first transaction is mined)
331    * From MonolithDAO Token.sol
332    */
333   function increaseApproval (address _spender, uint _addedValue)
334     returns (bool success) {
335     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
336     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
337     return true;
338   }
339 
340   function decreaseApproval (address _spender, uint _subtractedValue)
341     returns (bool success) {
342     uint oldValue = allowed[msg.sender][_spender];
343     if (_subtractedValue > oldValue) {
344       allowed[msg.sender][_spender] = 0;
345     } else {
346       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
347     }
348     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
349     return true;
350   }
351 
352 }
353 
354 contract PausableToken is StandardToken, Pausable {
355 
356   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
357     return super.transfer(_to, _value);
358   }
359 
360   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
361     return super.transferFrom(_from, _to, _value);
362   }
363 
364   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
365     return super.approve(_spender, _value);
366   }
367 
368   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
369     return super.increaseApproval(_spender, _addedValue);
370   }
371 
372   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
373     return super.decreaseApproval(_spender, _subtractedValue);
374   }
375 }
376 
377 contract RegulatedToken is StandardToken, PausableToken, LimitedTransferToken, HasNoEther, HasNoTokens {
378 
379     using SafeMath for uint256;
380     using SafeERC20 for ERC20Basic;
381     uint256 constant MAX_LOCKS_PER_ADDRESS = 20;
382 
383     enum RedeemReason{RegulatoryRedemption, Buyback, Other}
384     enum LockReason{PreICO, Vesting, USPerson, FundOriginated, Other}
385 
386     struct TokenLock {
387         uint64 id;
388         LockReason reason;
389         uint256 value;
390         uint64 autoReleaseTime;       //May be 0, for no release time
391     }
392 
393     struct TokenRedemption {
394         uint64 redemptionId;
395         RedeemReason reason;
396         uint256 value;
397     }
398 
399     uint256 public totalInactive;
400     uint64 private lockCounter = 1;
401 
402     //token admins
403     mapping(address => bool) private admins;
404 
405     //locks
406     mapping(address => TokenLock[]) private locks;
407 
408     //burn wallets
409     mapping(address => bool) private burnWallets;
410 
411     //Redemptions made for users
412     mapping(address => TokenRedemption[]) private tokenRedemptions;
413 
414     event Issued(address indexed to, uint256 value, uint256 valueLocked);
415     event Locked(address indexed who, uint256 value, LockReason reason, uint releaseTime, uint64 lockId);
416     event Unlocked(address indexed who, uint256 value, uint64 lockId);
417     event AddedBurnWallet(address indexed burnWallet);
418     event Redeemed(address indexed from, address indexed burnWallet, uint256 value, RedeemReason reason, uint64 indexed redemptionId);
419     event Burned(address indexed burnWallet, uint256 value);
420     event Destroyed();
421     event AdminAdded(address admin);
422     event AdminRemoved(address admin);
423 
424 
425 
426     /**
427     * @dev destroys the token
428     * Only works from the owner, and when the total balance of all users is 0 (nobody has tokens).
429     */
430     function destroy() onlyOwner public {
431         require(totalSupply == 0);
432         Destroyed();
433         selfdestruct(owner);
434     }
435 
436     /*******************************
437         CONTRACT ADMIN
438 
439         The contract can have 0 or more admins
440         some functions are accessible on the admin level rather than the owner level
441         the owner is always an admin
442     ********************************/
443 
444     function addAdmin(address _address) onlyOwner public{
445         admins[_address] = true;
446         AdminAdded(_address);
447     }
448 
449     function removeAdmin(address _address) onlyOwner public{
450         admins[_address] = false;
451         AdminRemoved(_address);
452     }
453     /**
454     * @dev Throws if called by any account other than an admin.
455     */
456     modifier onlyAdmin() {
457         require(msg.sender == owner || admins[msg.sender] == true);
458         _;
459     }
460 
461 
462     /******************************
463          TOKEN ISSUING
464      *******************************/
465 
466 
467     /**
468     * @dev Issues unlocked tokens
469     * @param _to address The address which is going to receive the newly issued tokens
470     * @param _value uint256 the value of tokens to issue
471     * @return true if successful
472     */
473 
474     function issueTokens(address _to, uint256 _value) onlyAdmin public returns (bool){
475         issueTokensWithLocking(_to, _value, 0, LockReason.Other, 0);
476     }
477 
478     /**
479     * @dev Issuing tokens from the fund
480     * @param _to address The address which is going to receive the newly issued tokens
481     * @param _value uint256 the value of tokens to issue
482     * @param _valueLocked uint256 value of tokens, from those issued, to lock immediately.
483     * @param _why reason for token locking
484     * @param _releaseTime timestamp to release the lock (or 0 for locks which can only released by an unlockTokens call)
485     * @return true if successful
486     */
487     function issueTokensWithLocking(address _to, uint256 _value, uint256 _valueLocked, LockReason _why, uint64 _releaseTime) onlyAdmin public returns (bool){
488 
489         //Check input values
490         require(_to != address(0));
491         require(_value > 0);
492         require(_valueLocked >= 0 && _valueLocked <= _value);
493 
494         //Make sure we have enough inactive tokens to issue
495         require(totalInactive >= _value);
496 
497         //Adding and subtracting is done through safemath
498         totalSupply = totalSupply.add(_value);
499         totalInactive = totalInactive.sub(_value);
500         balances[_to] = balances[_to].add(_value);
501 
502         Issued(_to, _value, _valueLocked);
503         Transfer(0x0, _to, _value);
504 
505         if (_valueLocked > 0) {
506             lockTokens(_to, _valueLocked, _why, _releaseTime);
507         }
508     }
509 
510 
511 
512     /******************************
513         TOKEN LOCKING
514 
515         Locking tokens means freezing a number of tokens belonging to an address.
516         Locked tokens can not be transferred by the user to any other address.
517         The contract owner (the fund) may still redeem those tokens, or unfreeze them.
518         The token lock may expire automatically at a certain timestamp, or exist forever until the owner unlocks it.
519 
520     *******************************/
521 
522 
523     /**
524     * @dev lock tokens
525     * @param _who address to lock the tokens at
526     * @param _value value of tokens to lock
527     * @param _reason reason for lock
528     * @param _releaseTime timestamp to release the lock (or 0 for locks which can only released by an unlockTokens call)
529     * @return A unique id for the newly created lock.
530     * Note: The user MAY have at a certain time more locked tokens than actual tokens
531     */
532     function lockTokens(address _who, uint _value, LockReason _reason, uint64 _releaseTime) onlyAdmin public returns (uint64){
533         require(_who != address(0));
534         require(_value > 0);
535         require(_releaseTime == 0 || _releaseTime > uint64(now));
536         //Only allow 20 locks per address, to prevent out-of-gas at transfer scenarios
537         require(locks[_who].length < MAX_LOCKS_PER_ADDRESS);
538 
539         uint64 lockId = lockCounter++;
540 
541         //Create the lock
542         locks[_who].push(TokenLock(lockId, _reason, _value, _releaseTime));
543         Locked(_who, _value, _reason, _releaseTime, lockId);
544 
545         return lockId;
546     }
547 
548     /**
549     * @dev Releases a specific token lock
550     * @param _who address to release the tokens for
551     * @param _lockId the unique lock-id to release
552     *
553     * note - this may change the order of the locks on an address, so if iterating the iteration should be restarted.
554     * @return true on success
555     */
556     function unlockTokens(address _who, uint64 _lockId) onlyAdmin public returns (bool) {
557         require(_who != address(0));
558         require(_lockId > 0);
559 
560         for (uint8 i = 0; i < locks[_who].length; i++) {
561             if (locks[_who][i].id == _lockId) {
562                 Unlocked(_who, locks[_who][i].value, _lockId);
563                 delete locks[_who][i];
564                 locks[_who][i] = locks[_who][locks[_who].length.sub(1)];
565                 locks[_who].length -= 1;
566 
567                 return true;
568             }
569         }
570         return false;
571     }
572 
573     /**
574     * @dev Get number of locks currently associated with an address
575     * @param _who address to get token lock for
576     *
577     * @return number of locks
578     *
579     * Note - a lock can be inactive (due to its time expired) but still exists for a specific address
580     */
581     function lockCount(address _who) public constant returns (uint8){
582         require(_who != address(0));
583         return uint8(locks[_who].length);
584     }
585 
586     /**
587     * @dev Get details of a specific lock associated with an address
588     * can be used to iterate through the locks of a user
589     * @param _who address to get token lock for
590     * @param _index the 0 based index of the lock.
591     * @return id the unique lock id
592     * @return reason the reason for the lock
593     * @return value the value of tokens locked
594     * @return the timestamp in which the lock will be inactive (or 0 if it's always active until removed)
595     *
596     * Note - a lock can be inactive (due to its time expired) but still exists for a specific address
597     */
598     function lockInfo(address _who, uint64 _index) public constant returns (uint64 id, uint8 reason, uint value, uint64 autoReleaseTime){
599         require(_who != address(0));
600         require(_index < locks[_who].length);
601         id = locks[_who][_index].id;
602         reason = uint8(locks[_who][_index].reason);
603         value = locks[_who][_index].value;
604         autoReleaseTime = locks[_who][_index].autoReleaseTime;
605     }
606 
607     /**
608     * @dev Get the total number of transferable (not locked) tokens the user has at a specific time
609     * used by the LimitedTransferToken base class to block ERC20 transfer for locked tokens
610     * @param holder address to get transferable count for
611     * @param time block timestamp to check time-locks with.
612     * @return total number of unlocked, transferable tokens
613     *
614     * Note - the timestamp is only used to check time-locks, the base balance used to check is always the current one.
615     */
616     function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
617         require(time > 0);
618 
619         //If it's a burn wallet, tokens cannot be moved out
620         if (isBurnWallet(holder)){
621             return 0;
622         }
623 
624         uint8 holderLockCount = uint8(locks[holder].length);
625 
626         //No locks, go to base class implementation
627         if (holderLockCount == 0) return super.transferableTokens(holder, time);
628 
629         uint256 totalLockedTokens = 0;
630         for (uint8 i = 0; i < holderLockCount; i ++) {
631 
632             if (locks[holder][i].autoReleaseTime == 0 || locks[holder][i].autoReleaseTime > time) {
633                 totalLockedTokens = SafeMath.add(totalLockedTokens, locks[holder][i].value);
634             }
635         }
636         uint balanceOfHolder = balanceOf(holder);
637 
638         //there may be more locked tokens than actual tokens, so the minimum between the two
639         uint256 transferable = SafeMath.sub(balanceOfHolder, Math.min256(totalLockedTokens, balanceOfHolder));
640 
641         //Check with super implementation for further reductions
642         return Math.min256(transferable, super.transferableTokens(holder, time));
643     }
644 
645     /******************************
646         REDEMPTION AND BURNING
647 
648         Redeeming tokens involves removing them from an address's wallet and moving them to a (one or more)
649         specially designed "burn wallets".
650         The process is implemented such as the owner can choose to burn or not to burn the tokens after redeeming them,
651         which is legally necessary on some buy-back scenarios
652         Each redemption is associated with a global "redemption event" (a unique id, supplied by the owner),
653         which can later be used to query the total value redeemed for the user in this event (and on the owner's
654         backend, through event logs processing, the total value redeemed for all users in this event)
655     *******************************/
656 
657 
658     /**
659     * @dev designates an address as a burn wallet (there can be an unlimited number of burn wallets).
660     * a burn wallet can only burn tokens - tokens may not be transferred out of it, and tokens do not participate
661     * in redemptions
662     * @param _burnWalletAddress the address to add to the burn wallet list
663     */
664     function addBurnWallet(address _burnWalletAddress) onlyAdmin {
665         require(_burnWalletAddress != address(0));
666         burnWallets[_burnWalletAddress] = true;
667         AddedBurnWallet(_burnWalletAddress);
668     }
669 
670     /**
671     * @dev redeems (removes) tokens for an address and moves to to a burn wallet
672     * @param _from the address to redeem tokens from
673     * @param _burnWallet the burn wallet to move the tokens to
674     * @param _reason the reason for the redemption
675     * @param _redemptionId a redemptionId, supplied by the contract owner. usually assigned to a single global
676     * redemption event (token buyback, or such).
677     */
678     function redeemTokens(address _from, address _burnWallet, uint256 _value, RedeemReason _reason, uint64 _redemptionId) onlyAdmin {
679         require(_from != address(0));
680         require(_redemptionId > 0);
681         require(isBurnWallet(_burnWallet));
682         require(balances[_from] >= _value);
683         balances[_from] = balances[_from].sub(_value);
684         balances[_burnWallet] = balances[_burnWallet].add(_value);
685         tokenRedemptions[_from].push(TokenRedemption(_redemptionId, _reason, _value));
686         Transfer(_from, _burnWallet, _value);
687         Redeemed(_from, _burnWallet, _value, _reason, _redemptionId);
688     }
689 
690     /**
691     * @dev Burns tokens inside a burn wallet
692     * The total number of inactive token is NOT increased
693     * this means there is a finite number amount that can ever exist of this token
694     * @param _burnWallet the address of the burn wallet
695     * @param _value value of tokens to burn
696     */
697     function burnTokens(address _burnWallet, uint256 _value) onlyAdmin {
698         require(_value > 0);
699         require(isBurnWallet(_burnWallet));
700         require(balances[_burnWallet] >= _value);
701         balances[_burnWallet] = balances[_burnWallet].sub(_value);
702         totalSupply = totalSupply.sub(_value);
703         Burned(_burnWallet, _value);
704         Transfer(_burnWallet,0x0,_value);
705     }
706 
707     /**
708     * @dev checks if a wallet is a burn wallet
709     * @param _burnWalletAddress address to check
710     */
711     function isBurnWallet(address _burnWalletAddress) constant public returns (bool){
712         return burnWallets[_burnWalletAddress];
713     }
714 
715     /**
716     * @dev gets number of redemptions done on a specific address
717     * @param _who address to check
718     */
719     function redemptionCount(address _who) public constant returns (uint64){
720         require(_who != address(0));
721         return uint64(tokenRedemptions[_who].length);
722     }
723 
724     /**
725     * @dev gets data about a specific redemption done on a specific address
726     * @param _who address to check
727     * @param _index zero based index of the redemption
728     * @return redemptionId the global redemptionId associated with this redemption
729     * @return reason the reason for the redemption
730     * @return value the value for the redemption
731     */
732     function redemptionInfo(address _who, uint64 _index) public constant returns (uint64 redemptionId, uint8 reason, uint value){
733         require(_who != address(0));
734         require(_index < tokenRedemptions[_who].length);
735         redemptionId = tokenRedemptions[_who][_index].redemptionId;
736         reason = uint8(tokenRedemptions[_who][_index].reason);
737         value = tokenRedemptions[_who][_index].value;
738     }
739 
740     /**
741     * @dev gets the total value redemeed from a specific address, for a single global redemption event
742     * @param _who address to check
743     * @param _redemptionId the global redemption event id
744     * @return the total value associated with the redemption event
745     */
746 
747     function totalRedemptionIdValue(address _who, uint64 _redemptionId) public constant returns (uint256){
748         require(_who != address(0));
749         uint256 total = 0;
750         uint64 numberOfRedemptions = redemptionCount(_who);
751         for (uint64 i = 0; i < numberOfRedemptions; i++) {
752             if (tokenRedemptions[_who][i].redemptionId == _redemptionId) {
753                 total = SafeMath.add(total, tokenRedemptions[_who][i].value);
754             }
755         }
756         return total;
757     }
758 
759 }
760 
761 contract SpiceToken is RegulatedToken {
762 
763     string public constant name = "SPiCE VC Token";
764     string public constant symbol = "SPICE";
765     uint8 public constant decimals = 8;
766     uint256 private constant INITIAL_INACTIVE_TOKENS = 130 * 1000000 * (10 ** uint256(decimals));  //130 million tokens
767 
768 
769     function SpiceToken() RegulatedToken() {
770         totalInactive = INITIAL_INACTIVE_TOKENS;
771         totalSupply = 0;
772     }
773 
774 }