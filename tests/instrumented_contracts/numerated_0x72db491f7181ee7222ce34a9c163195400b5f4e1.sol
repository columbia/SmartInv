1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 library Math {
8   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
9     return _a >= _b ? _a : _b;
10   }
11 
12   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
13     return _a < _b ? _a : _b;
14   }
15 
16   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
17     return _a >= _b ? _a : _b;
18   }
19 
20   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
21     return _a < _b ? _a : _b;
22   }
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
35     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (_a == 0) {
39       return 0;
40     }
41 
42     c = _a * _b;
43     assert(c / _a == _b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     // assert(_b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = _a / _b;
53     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
54     return _a / _b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
61     assert(_b <= _a);
62     return _a - _b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
69     c = _a + _b;
70     assert(c >= _a);
71     return c;
72   }
73 }
74 
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * See https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address _who) public view returns (uint256);
84   function transfer(address _to, uint256 _value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address _owner, address _spender)
93     public view returns (uint256);
94 
95   function transferFrom(address _from, address _to, uint256 _value)
96     public returns (bool);
97 
98   function approve(address _spender, uint256 _value) public returns (bool);
99   event Approval(
100     address indexed owner,
101     address indexed spender,
102     uint256 value
103   );
104 }
105 /**
106  * @title SafeERC20
107  * @dev Wrappers around ERC20 operations that throw on failure.
108  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
109  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
110  */
111 library SafeERC20 {
112   function safeTransfer(
113     ERC20Basic _token,
114     address _to,
115     uint256 _value
116   )
117     internal
118   {
119     require(_token.transfer(_to, _value));
120   }
121 
122   function safeTransferFrom(
123     ERC20 _token,
124     address _from,
125     address _to,
126     uint256 _value
127   )
128     internal
129   {
130     require(_token.transferFrom(_from, _to, _value));
131   }
132 
133   function safeApprove(
134     ERC20 _token,
135     address _spender,
136     uint256 _value
137   )
138     internal
139   {
140     require(_token.approve(_spender, _value));
141   }
142 }
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipRenounced(address indexed previousOwner);
154   event OwnershipTransferred(
155     address indexed previousOwner,
156     address indexed newOwner
157   );
158 
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   constructor() public {
165     owner = msg.sender;
166   }
167 
168   /**
169    * @dev Throws if called by any account other than the owner.
170    */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177    * @dev Allows the current owner to relinquish control of the contract.
178    * @notice Renouncing to ownership will leave the contract without an owner.
179    * It will not be possible to call the functions with the `onlyOwner`
180    * modifier anymore.
181    */
182   function renounceOwnership() public onlyOwner {
183     emit OwnershipRenounced(owner);
184     owner = address(0);
185   }
186 
187   /**
188    * @dev Allows the current owner to transfer control of the contract to a newOwner.
189    * @param _newOwner The address to transfer ownership to.
190    */
191   function transferOwnership(address _newOwner) public onlyOwner {
192     _transferOwnership(_newOwner);
193   }
194 
195   /**
196    * @dev Transfers control of the contract to a newOwner.
197    * @param _newOwner The address to transfer ownership to.
198    */
199   function _transferOwnership(address _newOwner) internal {
200     require(_newOwner != address(0));
201     emit OwnershipTransferred(owner, _newOwner);
202     owner = _newOwner;
203   }
204 }
205 
206 /**
207  * @title Basic token
208  * @dev Basic version of StandardToken, with no allowances.
209  */
210 contract BasicToken is ERC20Basic {
211   using SafeMath for uint256;
212 
213   mapping(address => uint256) internal balances;
214 
215   uint256 internal totalSupply_;
216 
217   /**
218   * @dev Total number of tokens in existence
219   */
220   function totalSupply() public view returns (uint256) {
221     return totalSupply_;
222   }
223 
224   /**
225   * @dev Transfer token for a specified address
226   * @param _to The address to transfer to.
227   * @param _value The amount to be transferred.
228   */
229   function transfer(address _to, uint256 _value) public returns (bool) {
230     require(_value <= balances[msg.sender]);
231     require(_to != address(0));
232 
233     balances[msg.sender] = balances[msg.sender].sub(_value);
234     balances[_to] = balances[_to].add(_value);
235     emit Transfer(msg.sender, _to, _value);
236     return true;
237   }
238 
239   /**
240   * @dev Gets the balance of the specified address.
241   * @param _owner The address to query the the balance of.
242   * @return An uint256 representing the amount owned by the passed address.
243   */
244   function balanceOf(address _owner) public view returns (uint256) {
245     return balances[_owner];
246   }
247 
248 }
249 
250 
251 /**
252  * @title Standard ERC20 token
253  *
254  * @dev Implementation of the basic standard token.
255  * https://github.com/ethereum/EIPs/issues/20
256  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
257  */
258 contract StandardToken is ERC20, BasicToken {
259 
260   mapping (address => mapping (address => uint256)) internal allowed;
261 
262 
263   /**
264    * @dev Transfer tokens from one address to another
265    * @param _from address The address which you want to send tokens from
266    * @param _to address The address which you want to transfer to
267    * @param _value uint256 the amount of tokens to be transferred
268    */
269   function transferFrom(
270     address _from,
271     address _to,
272     uint256 _value
273   )
274     public
275     returns (bool)
276   {
277     require(_value <= balances[_from]);
278     require(_value <= allowed[_from][msg.sender]);
279     require(_to != address(0));
280 
281     balances[_from] = balances[_from].sub(_value);
282     balances[_to] = balances[_to].add(_value);
283     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
284     emit Transfer(_from, _to, _value);
285     return true;
286   }
287 
288   /**
289    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
290    * Beware that changing an allowance with this method brings the risk that someone may use both the old
291    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
292    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
293    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294    * @param _spender The address which will spend the funds.
295    * @param _value The amount of tokens to be spent.
296    */
297   function approve(address _spender, uint256 _value) public returns (bool) {
298     allowed[msg.sender][_spender] = _value;
299     emit Approval(msg.sender, _spender, _value);
300     return true;
301   }
302 
303   /**
304    * @dev Function to check the amount of tokens that an owner allowed to a spender.
305    * @param _owner address The address which owns the funds.
306    * @param _spender address The address which will spend the funds.
307    * @return A uint256 specifying the amount of tokens still available for the spender.
308    */
309   function allowance(
310     address _owner,
311     address _spender
312    )
313     public
314     view
315     returns (uint256)
316   {
317     return allowed[_owner][_spender];
318   }
319 
320   /**
321    * @dev Increase the amount of tokens that an owner allowed to a spender.
322    * approve should be called when allowed[_spender] == 0. To increment
323    * allowed value is better to use this function to avoid 2 calls (and wait until
324    * the first transaction is mined)
325    * From MonolithDAO Token.sol
326    * @param _spender The address which will spend the funds.
327    * @param _addedValue The amount of tokens to increase the allowance by.
328    */
329   function increaseApproval(
330     address _spender,
331     uint256 _addedValue
332   )
333     public
334     returns (bool)
335   {
336     allowed[msg.sender][_spender] = (
337       allowed[msg.sender][_spender].add(_addedValue));
338     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
339     return true;
340   }
341 
342   /**
343    * @dev Decrease the amount of tokens that an owner allowed to a spender.
344    * approve should be called when allowed[_spender] == 0. To decrement
345    * allowed value is better to use this function to avoid 2 calls (and wait until
346    * the first transaction is mined)
347    * From MonolithDAO Token.sol
348    * @param _spender The address which will spend the funds.
349    * @param _subtractedValue The amount of tokens to decrease the allowance by.
350    */
351   function decreaseApproval(
352     address _spender,
353     uint256 _subtractedValue
354   )
355     public
356     returns (bool)
357   {
358     uint256 oldValue = allowed[msg.sender][_spender];
359     if (_subtractedValue >= oldValue) {
360       allowed[msg.sender][_spender] = 0;
361     } else {
362       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
363     }
364     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365     return true;
366   }
367 
368 }
369 
370 /**
371  * @title Burnable Token
372  * @dev Token that can be irreversibly burned (destroyed).
373  */
374 contract BurnableToken is BasicToken {
375 
376   event Burn(address indexed burner, uint256 value);
377 
378   /**
379    * @dev Burns a specific amount of tokens.
380    * @param _value The amount of token to be burned.
381    */
382   function burn(uint256 _value) public {
383     _burn(msg.sender, _value);
384   }
385 
386   function _burn(address _who, uint256 _value) internal {
387     require(_value <= balances[_who]);
388     // no need to require value <= totalSupply, since that would imply the
389     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
390 
391     balances[_who] = balances[_who].sub(_value);
392     totalSupply_ = totalSupply_.sub(_value);
393     emit Burn(_who, _value);
394     emit Transfer(_who, address(0), _value);
395   }
396 }
397 
398 
399 /**
400  * @title Mintable token
401  * @dev Simple ERC20 Token example, with mintable token creation
402  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
403  */
404 contract MintableToken is StandardToken, Ownable {
405   event Mint(address indexed to, uint256 amount);
406   event MintFinished();
407 
408   bool public mintingFinished = false;
409 
410 
411   modifier canMint() {
412     require(!mintingFinished);
413     _;
414   }
415 
416   modifier hasMintPermission() {
417     require(msg.sender == owner);
418     _;
419   }
420 
421   /**
422    * @dev Function to mint tokens
423    * @param _to The address that will receive the minted tokens.
424    * @param _amount The amount of tokens to mint.
425    * @return A boolean that indicates if the operation was successful.
426    */
427   function mint(
428     address _to,
429     uint256 _amount
430   )
431     public
432     hasMintPermission
433     canMint
434     returns (bool)
435   {
436     totalSupply_ = totalSupply_.add(_amount);
437     balances[_to] = balances[_to].add(_amount);
438     emit Mint(_to, _amount);
439     emit Transfer(address(0), _to, _amount);
440     return true;
441   }
442 
443   /**
444    * @dev Function to stop minting new tokens.
445    * @return True if the operation was successful.
446    */
447   function finishMinting() public onlyOwner canMint returns (bool) {
448     mintingFinished = true;
449     emit MintFinished();
450     return true;
451   }
452 }
453 
454 
455 /**
456  * @title Contracts that should not own Ether
457  * @author Remco Bloemen <remco@2π.com>
458  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
459  * in the contract, it will allow the owner to reclaim this Ether.
460  * @notice Ether can still be sent to this contract by:
461  * calling functions labeled `payable`
462  * `selfdestruct(contract_address)`
463  * mining directly to the contract address
464  */
465 contract HasNoEther is Ownable {
466 
467   /**
468   * @dev Constructor that rejects incoming Ether
469   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
470   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
471   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
472   * we could use assembly to access msg.value.
473   */
474   constructor() public payable {
475     require(msg.value == 0);
476   }
477 
478   /**
479    * @dev Disallows direct send by setting a default function without the `payable` flag.
480    */
481   function() external {
482   }
483 
484   /**
485    * @dev Transfer all Ether held by the contract to the owner.
486    */
487   function reclaimEther() external onlyOwner {
488     owner.transfer(address(this).balance);
489   }
490 }
491 
492 /**
493  * @title Contracts that should be able to recover tokens
494  * @author SylTi
495  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
496  * This will prevent any accidental loss of tokens.
497  */
498 contract CanReclaimToken is Ownable {
499   using SafeERC20 for ERC20Basic;
500 
501   /**
502    * @dev Reclaim all ERC20Basic compatible tokens
503    * @param _token ERC20Basic The address of the token contract
504    */
505   function reclaimToken(ERC20Basic _token) external onlyOwner {
506     uint256 balance = _token.balanceOf(this);
507     _token.safeTransfer(owner, balance);
508   }
509 
510 }
511 
512 /**
513  * @title Contracts that should not own Tokens
514  * @author Remco Bloemen <remco@2π.com>
515  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
516  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
517  * owner to reclaim the tokens.
518  */
519 contract HasNoTokens is CanReclaimToken {
520 
521  /**
522   * @dev Reject all ERC223 compatible tokens
523   * @param _from address The address that is transferring the tokens
524   * @param _value uint256 the amount of the specified token
525   * @param _data Bytes The data passed from the caller.
526   */
527   function tokenFallback(
528     address _from,
529     uint256 _value,
530     bytes _data
531   )
532     external
533     pure
534   {
535     _from;
536     _value;
537     _data;
538     revert();
539   }
540 
541 }
542 
543 
544 /**
545  * @title Contracts that should not own Contracts
546  * @author Remco Bloemen <remco@2π.com>
547  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
548  * of this contract to reclaim ownership of the contracts.
549  */
550 contract HasNoContracts is Ownable {
551 
552   /**
553    * @dev Reclaim ownership of Ownable contracts
554    * @param _contractAddr The address of the Ownable to be reclaimed.
555    */
556   function reclaimContract(address _contractAddr) external onlyOwner {
557     Ownable contractInst = Ownable(_contractAddr);
558     contractInst.transferOwnership(owner);
559   }
560 }
561 
562 /**
563  * @title Base contract for contracts that should not own things.
564  * @author Remco Bloemen <remco@2π.com>
565  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
566  * Owned contracts. See respective base contracts for details.
567  */
568 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
569 }
570 
571 /**
572  * @title Pausable Token
573  * @dev Token that can be paused and unpaused. Only whitelisted addresses can transfer when paused
574  */
575 contract PausableToken is StandardToken, Ownable {
576     event Pause();
577     event Unpause();
578 
579     bool public paused = false;
580     mapping(address => bool) public whitelist;
581 
582     /**
583     * @dev called by the owner to pause, triggers stopped state
584     */
585     function pause() onlyOwner public {
586         require(!paused);
587         paused = true;
588         emit Pause();
589     }
590 
591     /**
592     * @dev called by the owner to unpause, returns to normal state
593     */
594     function unpause() onlyOwner public {
595         require(paused);
596         paused = false;
597         emit Unpause();
598     }
599     /**
600      * @notice add/remove whitelisted addresses
601      * @param who Address which is added or removed
602      * @param allowTransfers allow or deny dtransfers when paused to the who
603      */
604     function setWhitelisted(address who, bool allowTransfers) onlyOwner public {
605         whitelist[who] = allowTransfers;
606     }
607 
608     function transfer(address _to, uint256 _value) public returns (bool){
609         require(!paused || whitelist[msg.sender]);
610         return super.transfer(_to, _value);
611     }
612 
613     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
614         require(!paused || whitelist[msg.sender] || whitelist[_from]);
615         return super.transferFrom(_from, _to, _value);
616     }
617 
618 }
619 
620 /**
621  * @title Revocable Token
622  * @dev Token that can be revokend until minting is not finished.
623  */
624 contract RevocableToken is MintableToken {
625 
626     event Revoke(address indexed from, uint256 value);
627 
628     modifier canRevoke() {
629         require(!mintingFinished);
630         _;
631     }
632 
633     /**
634      * @dev Revokes minted tokens
635      * @param _from The address whose tokens are revoked
636      * @param _value The amount of token to revoke
637      */
638     function revoke(address _from, uint256 _value) onlyOwner canRevoke public returns (bool) {
639         require(_value <= balances[_from]);
640         // no need to require value <= totalSupply, since that would imply the
641         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
642 
643         balances[_from] = balances[_from].sub(_value);
644         totalSupply_ = totalSupply_.sub(_value);
645 
646         emit Revoke(_from, _value);
647         emit Transfer(_from, address(0), _value);
648         return true;
649     }
650 }
651 
652 contract RewardsToken is RevocableToken, /*MintableToken,*/ PausableToken, BurnableToken, NoOwner {
653     string public symbol = 'RWRD';
654     string public name = 'Rewards Cash';
655     uint8 public constant decimals = 18;
656 
657     uint256 public hardCap = 10 ** (18 + 9); //1B tokens. Max amount of tokens which can be minted
658 
659     /**
660     * @notice Function to mint tokens
661     * @dev This function checks hardCap and calls MintableToken.mint()
662     * @param _to The address that will receive the minted tokens.
663     * @param _amount The amount of tokens to mint.
664     * @return A boolean that indicates if the operation was successful.
665     */
666     function mint(address _to, uint256 _amount) public returns (bool){
667         require(totalSupply_.add(_amount) <= hardCap);
668         return super.mint(_to, _amount);
669     }
670 
671 
672 }