1 pragma solidity ^0.4.18;
2 
3 /**
4  * Bob's Repair Token
5  * https://bobsrepair.com/
6  * Using Blockchain to eliminate review fraud and provide lower pricing in the home repair industry through a decentralized platform.
7  */
8 
9 //=== OpenZeppelin Library Contracts https://github.com/OpenZeppelin/zeppelin-solidity ===
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 /**
24  * @title ERC20 interface
25  * @dev see https://github.com/ethereum/EIPs/issues/20
26  */
27 contract ERC20 is ERC20Basic {
28   function allowance(address owner, address spender) public view returns (uint256);
29   function transferFrom(address from, address to, uint256 value) public returns (bool);
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 /**
35  * @title SafeERC20
36  * @dev Wrappers around ERC20 operations that throw on failure.
37  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
38  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
39  */
40 library SafeERC20 {
41   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
42     assert(token.transfer(to, value));
43   }
44 
45   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
46     assert(token.transferFrom(from, to, value));
47   }
48 
49   function safeApprove(ERC20 token, address spender, uint256 value) internal {
50     assert(token.approve(spender, value));
51   }
52 }
53 
54 /**
55    @title ERC827 interface, an extension of ERC20 token standard
56 
57    Interface of a ERC827 token, following the ERC20 standard with extra
58    methods to transfer value and data and execute calls in transfers and
59    approvals.
60  */
61 contract ERC827 is ERC20 {
62 
63   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
64   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
65   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
66 
67 }
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75     if (a == 0) {
76       return 0;
77     }
78     uint256 c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return c;
88   }
89 
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   function add(uint256 a, uint256 b) internal pure returns (uint256) {
96     uint256 c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   uint256 totalSupply_;
112 
113   /**
114   * @dev total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return totalSupply_;
118   }
119 
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is ERC20, BasicToken {
155 
156   mapping (address => mapping (address => uint256)) internal allowed;
157 
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[_from]);
168     require(_value <= allowed[_from][msg.sender]);
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(address _owner, address _spender) public view returns (uint256) {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
214     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To decrement
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _subtractedValue The amount of tokens to decrease the allowance by.
228    */
229   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
230     uint oldValue = allowed[msg.sender][_spender];
231     if (_subtractedValue > oldValue) {
232       allowed[msg.sender][_spender] = 0;
233     } else {
234       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235     }
236     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240 }
241 
242 /**
243    @title ERC827, an extension of ERC20 token standard
244 
245    Implementation the ERC827, following the ERC20 standard with extra
246    methods to transfer value and data and execute calls in transfers and
247    approvals.
248    Uses OpenZeppelin StandardToken.
249  */
250 contract ERC827Token is ERC827, StandardToken {
251 
252   /**
253      @dev Addition to ERC20 token methods. It allows to
254      approve the transfer of value and execute a call with the sent data.
255 
256      Beware that changing an allowance with this method brings the risk that
257      someone may use both the old and the new allowance by unfortunate
258      transaction ordering. One possible solution to mitigate this race condition
259      is to first reduce the spender's allowance to 0 and set the desired value
260      afterwards:
261      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262 
263      @param _spender The address that will spend the funds.
264      @param _value The amount of tokens to be spent.
265      @param _data ABI-encoded contract call to call `_to` address.
266 
267      @return true if the call function was executed successfully
268    */
269   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
270     require(_spender != address(this));
271 
272     super.approve(_spender, _value);
273 
274     require(_spender.call(_data));
275 
276     return true;
277   }
278 
279   /**
280      @dev Addition to ERC20 token methods. Transfer tokens to a specified
281      address and execute a call with the sent data on the same transaction
282 
283      @param _to address The address which you want to transfer to
284      @param _value uint256 the amout of tokens to be transfered
285      @param _data ABI-encoded contract call to call `_to` address.
286 
287      @return true if the call function was executed successfully
288    */
289   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
290     require(_to != address(this));
291 
292     super.transfer(_to, _value);
293 
294     require(_to.call(_data));
295     return true;
296   }
297 
298   /**
299      @dev Addition to ERC20 token methods. Transfer tokens from one address to
300      another and make a contract call on the same transaction
301 
302      @param _from The address which you want to send tokens from
303      @param _to The address which you want to transfer to
304      @param _value The amout of tokens to be transferred
305      @param _data ABI-encoded contract call to call `_to` address.
306 
307      @return true if the call function was executed successfully
308    */
309   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
310     require(_to != address(this));
311 
312     super.transferFrom(_from, _to, _value);
313 
314     require(_to.call(_data));
315     return true;
316   }
317 
318   /**
319    * @dev Addition to StandardToken methods. Increase the amount of tokens that
320    * an owner allowed to a spender and execute a call with the sent data.
321    *
322    * approve should be called when allowed[_spender] == 0. To increment
323    * allowed value is better to use this function to avoid 2 calls (and wait until
324    * the first transaction is mined)
325    * From MonolithDAO Token.sol
326    * @param _spender The address which will spend the funds.
327    * @param _addedValue The amount of tokens to increase the allowance by.
328    * @param _data ABI-encoded contract call to call `_spender` address.
329    */
330   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
331     require(_spender != address(this));
332 
333     super.increaseApproval(_spender, _addedValue);
334 
335     require(_spender.call(_data));
336 
337     return true;
338   }
339 
340   /**
341    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
342    * an owner allowed to a spender and execute a call with the sent data.
343    *
344    * approve should be called when allowed[_spender] == 0. To decrement
345    * allowed value is better to use this function to avoid 2 calls (and wait until
346    * the first transaction is mined)
347    * From MonolithDAO Token.sol
348    * @param _spender The address which will spend the funds.
349    * @param _subtractedValue The amount of tokens to decrease the allowance by.
350    * @param _data ABI-encoded contract call to call `_spender` address.
351    */
352   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
353     require(_spender != address(this));
354 
355     super.decreaseApproval(_spender, _subtractedValue);
356 
357     require(_spender.call(_data));
358 
359     return true;
360   }
361 
362 }
363 
364 /**
365  * @title Ownable
366  * @dev The Ownable contract has an owner address, and provides basic authorization control
367  * functions, this simplifies the implementation of "user permissions".
368  */
369 contract Ownable {
370   address public owner;
371 
372 
373   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375 
376   /**
377    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
378    * account.
379    */
380   function Ownable() public {
381     owner = msg.sender;
382   }
383 
384 
385   /**
386    * @dev Throws if called by any account other than the owner.
387    */
388   modifier onlyOwner() {
389     require(msg.sender == owner);
390     _;
391   }
392 
393 
394   /**
395    * @dev Allows the current owner to transfer control of the contract to a newOwner.
396    * @param newOwner The address to transfer ownership to.
397    */
398   function transferOwnership(address newOwner) public onlyOwner {
399     require(newOwner != address(0));
400     OwnershipTransferred(owner, newOwner);
401     owner = newOwner;
402   }
403 
404 }
405 
406 /**
407  * @title Mintable token
408  * @dev Simple ERC20 Token example, with mintable token creation
409  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
410  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
411  */
412 contract MintableToken is StandardToken, Ownable {
413   event Mint(address indexed to, uint256 amount);
414   event MintFinished();
415 
416   bool public mintingFinished = false;
417 
418 
419   modifier canMint() {
420     require(!mintingFinished);
421     _;
422   }
423 
424   /**
425    * @dev Function to mint tokens
426    * @param _to The address that will receive the minted tokens.
427    * @param _amount The amount of tokens to mint.
428    * @return A boolean that indicates if the operation was successful.
429    */
430   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
431     totalSupply_ = totalSupply_.add(_amount);
432     balances[_to] = balances[_to].add(_amount);
433     Mint(_to, _amount);
434     Transfer(address(0), _to, _amount);
435     return true;
436   }
437 
438   /**
439    * @dev Function to stop minting new tokens.
440    * @return True if the operation was successful.
441    */
442   function finishMinting() onlyOwner canMint public returns (bool) {
443     mintingFinished = true;
444     MintFinished();
445     return true;
446   }
447 }
448 
449 /**
450  * @title Destructible
451  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
452  */
453 contract Destructible is Ownable {
454 
455   function Destructible() public payable { }
456 
457   /**
458    * @dev Transfers the current balance to the owner and terminates the contract.
459    */
460   function destroy() onlyOwner public {
461     selfdestruct(owner);
462   }
463 
464   function destroyAndSend(address _recipient) onlyOwner public {
465     selfdestruct(_recipient);
466   }
467 }
468 
469 /**
470  * @title Pausable
471  * @dev Base contract which allows children to implement an emergency stop mechanism.
472  */
473 contract Pausable is Ownable {
474   event Pause();
475   event Unpause();
476 
477   bool public paused = false;
478 
479 
480   /**
481    * @dev Modifier to make a function callable only when the contract is not paused.
482    */
483   modifier whenNotPaused() {
484     require(!paused);
485     _;
486   }
487 
488   /**
489    * @dev Modifier to make a function callable only when the contract is paused.
490    */
491   modifier whenPaused() {
492     require(paused);
493     _;
494   }
495 
496   /**
497    * @dev called by the owner to pause, triggers stopped state
498    */
499   function pause() onlyOwner whenNotPaused public {
500     paused = true;
501     Pause();
502   }
503 
504   /**
505    * @dev called by the owner to unpause, returns to normal state
506    */
507   function unpause() onlyOwner whenPaused public {
508     paused = false;
509     Unpause();
510   }
511 }
512 
513 /**
514  * @title Contracts that should not own Ether
515  * @author Remco Bloemen <remco@2π.com>
516  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
517  * in the contract, it will allow the owner to reclaim this ether.
518  * @notice Ether can still be send to this contract by:
519  * calling functions labeled `payable`
520  * `selfdestruct(contract_address)`
521  * mining directly to the contract address
522 */
523 contract HasNoEther is Ownable {
524 
525   /**
526   * @dev Constructor that rejects incoming Ether
527   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
528   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
529   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
530   * we could use assembly to access msg.value.
531   */
532   function HasNoEther() public payable {
533     require(msg.value == 0);
534   }
535 
536   /**
537    * @dev Disallows direct send by settings a default function without the `payable` flag.
538    */
539   function() external {
540   }
541 
542   /**
543    * @dev Transfer all Ether held by the contract to the owner.
544    */
545   function reclaimEther() external onlyOwner {
546     assert(owner.send(this.balance));
547   }
548 }
549 
550 /**
551  * @title Contracts that should not own Contracts
552  * @author Remco Bloemen <remco@2π.com>
553  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
554  * of this contract to reclaim ownership of the contracts.
555  */
556 contract HasNoContracts is Ownable {
557 
558   /**
559    * @dev Reclaim ownership of Ownable contracts
560    * @param contractAddr The address of the Ownable to be reclaimed.
561    */
562   function reclaimContract(address contractAddr) external onlyOwner {
563     Ownable contractInst = Ownable(contractAddr);
564     contractInst.transferOwnership(owner);
565   }
566 }
567 
568 /**
569  * @title Contracts that should be able to recover tokens
570  * @author SylTi
571  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
572  * This will prevent any accidental loss of tokens.
573  */
574 contract CanReclaimToken is Ownable {
575   using SafeERC20 for ERC20Basic;
576 
577   /**
578    * @dev Reclaim all ERC20Basic compatible tokens
579    * @param token ERC20Basic The address of the token contract
580    */
581   function reclaimToken(ERC20Basic token) external onlyOwner {
582     uint256 balance = token.balanceOf(this);
583     token.safeTransfer(owner, balance);
584   }
585 
586 }
587 
588 
589 /**
590  * @title Contracts that should not own Tokens
591  * @author Remco Bloemen <remco@2π.com>
592  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
593  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
594  * owner to reclaim the tokens.
595  */
596 contract HasNoTokens is CanReclaimToken {
597 
598  /**
599   * @dev Reject all ERC23 compatible tokens
600   * @param from_ address The address that is transferring the tokens
601   * @param value_ uint256 the amount of the specified token
602   * @param data_ Bytes The data passed from the caller.
603   */
604   function tokenFallback(address from_, uint256 value_, bytes data_) pure external {
605     from_;
606     value_;
607     data_;
608     revert();
609   }
610 
611 }
612 
613 /**
614  * @title Base contract for contracts that should not own things.
615  * @author Remco Bloemen <remco@2π.com>
616  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
617  * Owned contracts. See respective base contracts for details.
618  */
619 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
620 }
621 
622 /**
623  * @title TokenVesting
624  * @dev A token holder contract that can release its token balance gradually like a
625  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
626  * owner.
627  */
628 contract TokenVesting is Ownable {
629   using SafeMath for uint256;
630   using SafeERC20 for ERC20Basic;
631 
632   event Released(uint256 amount);
633   event Revoked();
634 
635   // beneficiary of tokens after they are released
636   address public beneficiary;
637 
638   uint256 public cliff;
639   uint256 public start;
640   uint256 public duration;
641 
642   bool public revocable;
643 
644   mapping (address => uint256) public released;
645   mapping (address => bool) public revoked;
646 
647   /**
648    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
649    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
650    * of the balance will have vested.
651    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
652    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
653    * @param _duration duration in seconds of the period in which the tokens will vest
654    * @param _revocable whether the vesting is revocable or not
655    */
656   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
657     require(_beneficiary != address(0));
658     require(_cliff <= _duration);
659 
660     beneficiary = _beneficiary;
661     revocable = _revocable;
662     duration = _duration;
663     cliff = _start.add(_cliff);
664     start = _start;
665   }
666 
667   /**
668    * @notice Transfers vested tokens to beneficiary.
669    * @param token ERC20 token which is being vested
670    */
671   function release(ERC20Basic token) public {
672     uint256 unreleased = releasableAmount(token);
673 
674     require(unreleased > 0);
675 
676     released[token] = released[token].add(unreleased);
677 
678     token.safeTransfer(beneficiary, unreleased);
679 
680     Released(unreleased);
681   }
682 
683   /**
684    * @notice Allows the owner to revoke the vesting. Tokens already vested
685    * remain in the contract, the rest are returned to the owner.
686    * @param token ERC20 token which is being vested
687    */
688   function revoke(ERC20Basic token) public onlyOwner {
689     require(revocable);
690     require(!revoked[token]);
691 
692     uint256 balance = token.balanceOf(this);
693 
694     uint256 unreleased = releasableAmount(token);
695     uint256 refund = balance.sub(unreleased);
696 
697     revoked[token] = true;
698 
699     token.safeTransfer(owner, refund);
700 
701     Revoked();
702   }
703 
704   /**
705    * @dev Calculates the amount that has already vested but hasn't been released yet.
706    * @param token ERC20 token which is being vested
707    */
708   function releasableAmount(ERC20Basic token) public view returns (uint256) {
709     return vestedAmount(token).sub(released[token]);
710   }
711 
712   /**
713    * @dev Calculates the amount that has already vested.
714    * @param token ERC20 token which is being vested
715    */
716   function vestedAmount(ERC20Basic token) public view returns (uint256) {
717     uint256 currentBalance = token.balanceOf(this);
718     uint256 totalBalance = currentBalance.add(released[token]);
719 
720     if (now < cliff) {
721       return 0;
722     } else if (now >= start.add(duration) || revoked[token]) {
723       return totalBalance;
724     } else {
725       return totalBalance.mul(now.sub(start)).div(duration);
726     }
727   }
728 }
729 
730 // === Modified OpenZeppelin contracts ===
731 
732 /**
733  * @title Burnable Token
734  * @dev Token that can be irreversibly burned (destroyed).
735  * Based on https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
736  */
737 contract BurnableToken is BasicToken {
738 
739     event Burn(address indexed burner, uint256 value);
740 
741     /**
742      * @dev Burns a specific amount of tokens.
743      * @param _value The amount of token to be burned.
744      */
745     function burn(uint256 _value) public returns (bool) {
746         require(_value <= balances[msg.sender]);
747         // no need to require value <= totalSupply, since that would imply the
748         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
749 
750         address burner = msg.sender;
751         balances[burner] = balances[burner].sub(_value);
752         totalSupply_ = totalSupply_.sub(_value);
753         Burn(burner, _value);
754         Transfer(burner, address(0), _value);
755         return true;
756     }
757 }
758 
759 /**
760  * @title BOBTokenVesting
761  * @dev Extends TokenVesting contract to allow reclaim ether and contracts, if transfered to this by mistake.
762  */
763 contract BOBTokenVesting is TokenVesting, HasNoEther, HasNoContracts, Destructible {
764 
765     /**
766      * @dev Call consturctor of TokenVesting with exactly same parameters
767      */
768     function BOBTokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) 
769                 TokenVesting(        _beneficiary,         _start,         _cliff,         _duration,      _revocable) public {}
770 
771 }
772 
773 
774 /**
775  * @title Pausable ERC827token
776  * @dev ERC827Token modified with pausable transfers. Based on OpenZeppelin's PausableToken
777  **/
778 contract PausableERC827Token is ERC827Token, Pausable {
779 
780     // ERC20 functions
781     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
782         return super.transfer(_to, _value);
783     }
784     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
785         return super.transferFrom(_from, _to, _value);
786     }
787     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
788         return super.approve(_spender, _value);
789     }
790 
791     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
792         return super.increaseApproval(_spender, _addedValue);
793     }
794     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
795         return super.decreaseApproval(_spender, _subtractedValue);
796     }
797 
798     //ERC827 functions
799     function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
800         return super.transfer(_to, _value, _data);
801     }
802     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
803         return super.transferFrom(_from, _to, _value, _data);
804     }
805     function approve(address _spender, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
806         return super.approve(_spender, _value, _data);
807     }
808     function increaseApproval(address _spender, uint _addedValue, bytes _data) public whenNotPaused returns (bool success) {
809         return super.increaseApproval(_spender, _addedValue, _data);
810     }
811     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public whenNotPaused returns (bool success) {
812         return super.decreaseApproval(_spender, _subtractedValue, _data);
813     }
814 }
815 
816 // === Bob's Repair Contracts ===
817 
818 /**
819  * @title Airdroppable Token
820  */
821 contract AirdropToken is PausableERC827Token {
822     using SafeMath for uint256;
823     uint8 private constant PERCENT_DIVIDER = 100;  
824 
825     event AirdropStart(uint256 multiplierPercent, uint256 airdropNumber);
826     event AirdropComplete(uint256 airdropNumber);
827 
828     uint256 public multiplierPercent = 0;               //Multiplier of current airdrop (for example, multiplierPercent = 200 and holder balance is 1 TOKEN, after airdrop it will be 2 TOKEN)
829     uint256 public currentAirdrop = 0;                  //Number of current airdrop. If 0 - no airdrop started
830     uint256 public undropped;                           //Amount not yet airdropped
831     mapping(address => uint256) public airdropped;        //map of alreday airdropped addresses       
832 
833     /**
834     * @notice Start airdrop
835     * @param _multiplierPercent Multiplier of the airdrop
836     */
837     function startAirdrop(uint256 _multiplierPercent) onlyOwner external returns(bool){
838         pause();
839         require(multiplierPercent == 0);                 //This means airdrop was finished
840         require(_multiplierPercent > PERCENT_DIVIDER);   //Require that after airdrop amount of tokens will be greater than before
841         currentAirdrop = currentAirdrop.add(1);
842         multiplierPercent = _multiplierPercent;
843         undropped = totalSupply();
844         assert(multiplierPercent.mul(undropped) > 0);   //Assert that wrong multiplier will not result in owerflow in airdropAmount()
845         AirdropStart(multiplierPercent, currentAirdrop);
846     }
847     /**
848     * @notice Finish airdrop, unpause token transfers
849     * @dev Anyone can call this function after all addresses are airdropped
850     */
851     function finishAirdrop() external returns(bool){
852         require(undropped == 0);
853         multiplierPercent = 0;
854         AirdropComplete(currentAirdrop);
855         unpause();
856     }
857 
858     /**
859     * @notice Execute airdrop for a bunch of addresses. Should be repeated for all addresses with non-zero amount of tokens.
860     * @dev This function can be called by anyone, not only the owner
861     * @param holders Array of token holder addresses.
862     * @return true if success
863     */
864     function drop(address[] holders) external returns(bool){
865         for(uint256 i=0; i < holders.length; i++){
866             address holder = holders[i];
867             if(!isAirdropped(holder)){
868                 uint256 balance = balances[holder];
869                 undropped = undropped.sub(balance);
870                 balances[holder] = airdropAmount(balance);
871                 uint256 amount = balances[holder].sub(balance);
872                 totalSupply_ = totalSupply_.add(amount);
873                 Transfer(address(0), holder, amount);
874                 setAirdropped(holder);
875             }
876         }
877     }
878     /**
879     * @notice Calculates amount of tokens after airdrop
880     * @param amount Balance before airdrop
881     * @return Amount of tokens after airdrop
882     */
883     function airdropAmount(uint256 amount) view public returns(uint256){
884         require(multiplierPercent > 0);
885         return multiplierPercent.mul(amount).div(PERCENT_DIVIDER);
886     }
887 
888     /**
889     * @dev Check if address was already airdropped
890     * @param holder Address of token holder
891     * @return true if address was airdropped
892     */
893     function isAirdropped(address holder) view internal returns(bool){
894         return (airdropped[holder] == currentAirdrop);
895     }
896     /**
897     * @dev Mark address as airdropped
898     * @param holder Address of token holder
899     */
900     function setAirdropped(address holder) internal {
901         airdropped[holder] = currentAirdrop;
902     }
903 }
904 
905 contract BOBToken is AirdropToken, MintableToken, BurnableToken, NoOwner {
906     string public symbol = 'BOB';
907     string public name = 'BOB Token';
908     uint8 public constant decimals = 18;
909 
910     address founder;                //founder address to allow him transfer tokens even when transfers disabled
911     bool public transferEnabled;    //allows to dissable transfers while minting and in case of emergency
912 
913     function setFounder(address _founder) onlyOwner public {
914         founder = _founder;
915     }
916     function setTransferEnabled(bool enable) onlyOwner public {
917         transferEnabled = enable;
918     }
919 
920     /**
921      * Allow transfer only after crowdsale finished
922      */
923     modifier canTransfer() {
924         require( transferEnabled || msg.sender == founder || msg.sender == owner);
925         _;
926     }
927     
928     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
929         return super.transfer(_to, _value);
930     }
931 
932     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
933         return super.transferFrom(_from, _to, _value);
934     }
935 
936     function transfer(address _to, uint256 _value, bytes _data) canTransfer public returns (bool) {
937         return super.transfer(_to, _value, _data);
938     }
939 
940     function transferFrom(address _from, address _to, uint256 _value, bytes _data) canTransfer public returns (bool) {
941         return super.transferFrom(_from, _to, _value, _data);
942     }
943 }