1 pragma solidity >=0.4.24;
2 /* @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (_a == 0) {
15       return 0;
16     }
17 
18     c = _a * _b;
19     assert(c / _a == _b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
27     // assert(_b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = _a / _b;
29     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
30     return _a / _b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
37     assert(_b <= _a);
38     return _a - _b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
45     c = _a + _b;
46     assert(c >= _a);
47     return c;
48   }
49 }
50 
51 // File: contracts/helpers/Ownable.sol
52 
53 
54 
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions". This adds two-phase
60  * ownership control to OpenZeppelin's Ownable class. In this model, the original owner 
61  * designates a new owner but does not actually transfer ownership. The new owner then accepts 
62  * ownership and completes the transfer.
63  */
64 contract Ownable {
65     address public owner;
66     address public pendingOwner;
67 
68 
69     event OwnershipTransferred(
70       address indexed previousOwner,
71       address indexed newOwner
72     );
73 
74 
75     /**
76     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77     * account.
78     */
79     constructor() public {
80         owner = msg.sender;
81         pendingOwner = address(0);
82     }
83 
84     /**
85     * @dev Throws if called by any account other than the owner.
86     */
87     modifier onlyOwner() {
88         require(msg.sender == owner, "Account is not owner");
89         _;
90     }
91 
92     /**
93     * @dev Throws if called by any account other than the owner.
94     */
95     modifier onlyPendingOwner() {
96         require(msg.sender == pendingOwner, "Account is not pending owner");
97         _;
98     }
99 
100     /**
101     * @dev Allows the current owner to transfer control of the contract to a newOwner.
102     * @param _newOwner The address to transfer ownership to.
103     */
104     function transferOwnership(address _newOwner) public onlyOwner {
105         require(_newOwner != address(0), "Empty address");
106         pendingOwner = _newOwner;
107     }
108 
109     /**
110     * @dev Allows the pendingOwner address to finalize the transfer.
111     */
112     function claimOwnership() onlyPendingOwner public {
113         emit OwnershipTransferred(owner, pendingOwner);
114         owner = pendingOwner;
115         pendingOwner = address(0);
116     }
117 }
118 
119 // File: contracts/token/dataStorage/AllowanceSheet.sol
120 
121 
122 
123 
124 
125 /**
126 * @title AllowanceSheet
127 * @notice A wrapper around an allowance mapping. 
128 */
129 contract AllowanceSheet is Ownable {
130     using SafeMath for uint256;
131 
132     mapping (address => mapping (address => uint256)) public allowanceOf;
133 
134     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
135         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
136     }
137 
138     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
139         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
140     }
141 
142     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
143         allowanceOf[_tokenHolder][_spender] = _value;
144     }
145 }
146 
147 // File: contracts/token/dataStorage/BalanceSheet.sol
148 
149 
150 
151 
152 
153 /**
154 * @title BalanceSheet
155 * @notice A wrapper around the balanceOf mapping. 
156 */
157 contract BalanceSheet is Ownable {
158     using SafeMath for uint256;
159 
160     mapping (address => uint256) public balanceOf;
161     uint256 public totalSupply;
162 
163     function addBalance(address _addr, uint256 _value) public onlyOwner {
164         balanceOf[_addr] = balanceOf[_addr].add(_value);
165     }
166 
167     function subBalance(address _addr, uint256 _value) public onlyOwner {
168         balanceOf[_addr] = balanceOf[_addr].sub(_value);
169     }
170 
171     function setBalance(address _addr, uint256 _value) public onlyOwner {
172         balanceOf[_addr] = _value;
173     }
174 
175     function addTotalSupply(uint256 _value) public onlyOwner {
176         totalSupply = totalSupply.add(_value);
177     }
178 
179     function subTotalSupply(uint256 _value) public onlyOwner {
180         totalSupply = totalSupply.sub(_value);
181     }
182 
183     function setTotalSupply(uint256 _value) public onlyOwner {
184         totalSupply = _value;
185     }
186 }
187 
188 // File: contracts/token/dataStorage/TokenStorage.sol
189 
190 
191 
192 
193 
194 /**
195 * @title TokenStorage
196 */
197 contract TokenStorage {
198     /**
199         Storage
200     */
201     BalanceSheet public balances;
202     AllowanceSheet public allowances;
203 
204 
205     string public name;   //name of Token                
206     uint8  public decimals;        //decimals of Token        
207     string public symbol;   //Symbol of Token
208 
209     /**
210     * @dev a TokenStorage consumer can set its storages only once, on construction
211     *
212     **/
213     constructor (address _balances, address _allowances, string _name, uint8 _decimals, string _symbol) public {
214         balances = BalanceSheet(_balances);
215         allowances = AllowanceSheet(_allowances);
216 
217         name = _name;
218         decimals = _decimals;
219         symbol = _symbol;
220     }
221 
222     /**
223     * @dev claim ownership of balance sheet passed into constructor.
224     **/
225     function claimBalanceOwnership() public {
226         balances.claimOwnership();
227     }
228 
229     /**
230     * @dev claim ownership of allowance sheet passed into constructor.
231     **/
232     function claimAllowanceOwnership() public {
233         allowances.claimOwnership();
234     }
235 }
236 
237 // File: openzeppelin-solidity/contracts/AddressUtils.sol
238 
239 pragma solidity ^0.4.24;
240 
241 
242 /**
243  * Utility library of inline functions on addresses
244  */
245 library AddressUtils {
246 
247   /**
248    * Returns whether the target address is a contract
249    * @dev This function will return false if invoked during the constructor of a contract,
250    * as the code is not actually created until after the constructor finishes.
251    * @param _addr address to check
252    * @return whether the target address is a contract
253    */
254   function isContract(address _addr) internal view returns (bool) {
255     uint256 size;
256     // XXX Currently there is no better way to check if there is a contract in an address
257     // than to check the size of the code at that address.
258     // See https://ethereum.stackexchange.com/a/14016/36603
259     // for more details about how this works.
260     // TODO Check this again before the Serenity release, because all addresses will be
261     // contracts then.
262     // solium-disable-next-line security/no-inline-assembly
263     assembly { size := extcodesize(_addr) }
264     return size > 0;
265   }
266 
267 }
268 
269 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
270 
271 pragma solidity ^0.4.24;
272 
273 
274 /**
275  * @title ERC20Basic
276  * @dev Simpler version of ERC20 interface
277  * See https://github.com/ethereum/EIPs/issues/179
278  */
279 contract ERC20Basic {
280   function totalSupply() public view returns (uint256);
281   function balanceOf(address _who) public view returns (uint256);
282   function transfer(address _to, uint256 _value) public returns (bool);
283   event Transfer(address indexed from, address indexed to, uint256 value);
284 }
285 
286 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
287 
288 pragma solidity ^0.4.24;
289 
290 
291 
292 /**
293  * @title ERC20 interface
294  * @dev see https://github.com/ethereum/EIPs/issues/20
295  */
296 contract ERC20 is ERC20Basic {
297   function allowance(address _owner, address _spender)
298     public view returns (uint256);
299 
300   function transferFrom(address _from, address _to, uint256 _value)
301     public returns (bool);
302 
303   function approve(address _spender, uint256 _value) public returns (bool);
304   event Approval(
305     address indexed owner,
306     address indexed spender,
307     uint256 value
308   );
309 }
310 
311 // File: contracts/token/AkropolisBaseToken.sol
312 
313 
314 
315 
316 
317 
318 
319 
320 /**
321 * @title AkropolisBaseToken
322 * @notice A basic ERC20 token with modular data storage
323 */
324 contract AkropolisBaseToken is ERC20, TokenStorage, Ownable {
325     using SafeMath for uint256;
326 
327     /** Events */
328     event Mint(address indexed to, uint256 value);
329     event MintFinished();
330     event Burn(address indexed burner, uint256 value);
331     event Transfer(address indexed from, address indexed to, uint256 value);
332     event Approval(address indexed owner, address indexed spender, uint256 value);
333 
334 
335     constructor (address _balances, address _allowances, string _name, uint8 _decimals, string _symbol) public 
336     TokenStorage(_balances, _allowances, _name, _decimals, _symbol) {}
337 
338     /** Modifiers **/
339 
340     modifier canMint() {
341         require(!isMintingFinished());
342         _;
343     }
344 
345     /** Functions **/
346 
347     function mint(address _to, uint256 _amount) public onlyOwner canMint {
348         _mint(_to, _amount);
349     }
350 
351     function burn(uint256 _amount) public onlyOwner {
352         _burn(msg.sender, _amount);
353     }
354 
355 
356     function isMintingFinished() public view returns (bool) {
357         bytes32 slot = keccak256(abi.encode("Minting", "mint"));
358         uint256 v;
359         assembly {
360             v := sload(slot)
361         }
362         return v != 0;
363     }
364 
365 
366     function setMintingFinished(bool value) internal {
367         bytes32 slot = keccak256(abi.encode("Minting", "mint"));
368         uint256 v = value ? 1 : 0;
369         assembly {
370             sstore(slot, v)
371         }
372     }
373 
374     function mintFinished() public onlyOwner {
375         setMintingFinished(true);
376         emit MintFinished();
377     }
378 
379 
380     function approve(address _spender, uint256 _value) 
381     public returns (bool) {
382         allowances.setAllowance(msg.sender, _spender, _value);
383         emit Approval(msg.sender, _spender, _value);
384         return true;
385     }
386 
387     function transfer(address _to, uint256 _amount) public returns (bool) {
388         require(_to != address(0),"to address cannot be 0x0");
389         require(_amount <= balanceOf(msg.sender),"not enough balance to transfer");
390 
391         balances.subBalance(msg.sender, _amount);
392         balances.addBalance(_to, _amount);
393         emit Transfer(msg.sender, _to, _amount);
394         return true;
395     }
396 
397     function transferFrom(address _from, address _to, uint256 _amount) 
398     public returns (bool) {
399         require(_amount <= allowance(_from, msg.sender),"not enough allowance to transfer");
400         require(_to != address(0),"to address cannot be 0x0");
401         require(_amount <= balanceOf(_from),"not enough balance to transfer");
402         
403         allowances.subAllowance(_from, msg.sender, _amount);
404         balances.addBalance(_to, _amount);
405         balances.subBalance(_from, _amount);
406         emit Transfer(_from, _to, _amount);
407         return true;
408     }
409 
410     /**
411     * @notice Implements balanceOf() as specified in the ERC20 standard.
412     */
413     function balanceOf(address who) public view returns (uint256) {
414         return balances.balanceOf(who);
415     }
416 
417     /**
418     * @notice Implements allowance() as specified in the ERC20 standard.
419     */
420     function allowance(address owner, address spender) public view returns (uint256) {
421         return allowances.allowanceOf(owner, spender);
422     }
423 
424     /**
425     * @notice Implements totalSupply() as specified in the ERC20 standard.
426     */
427     function totalSupply() public view returns (uint256) {
428         return balances.totalSupply();
429     }
430 
431 
432     /** Internal functions **/
433 
434     function _burn(address _tokensOf, uint256 _amount) internal {
435         require(_amount <= balanceOf(_tokensOf),"not enough balance to burn");
436         // no need to require value <= totalSupply, since that would imply the
437         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
438         balances.subBalance(_tokensOf, _amount);
439         balances.subTotalSupply(_amount);
440         emit Burn(_tokensOf, _amount);
441         emit Transfer(_tokensOf, address(0), _amount);
442     }
443 
444     function _mint(address _to, uint256 _amount) internal {
445         balances.addTotalSupply(_amount);
446         balances.addBalance(_to, _amount);
447         emit Mint(_to, _amount);
448         emit Transfer(address(0), _to, _amount);
449     }
450 
451 }
452 
453 // File: contracts/helpers/Lockable.sol
454 
455 
456 
457 
458 /**
459 * @title Lockable
460 * @dev Base contract which allows children to lock certain methods from being called by clients.
461 * Locked methods are deemed unsafe by default, but must be implemented in children functionality to adhere by
462 * some inherited standard, for example. 
463 */
464 
465 contract Lockable is Ownable {
466 	// Events
467 	event Unlocked();
468 	event Locked();
469 
470 	// Modifiers
471 	/**
472 	* @dev Modifier that disables functions by default unless they are explicitly enabled
473 	*/
474 	modifier whenUnlocked() {
475 		require(!isLocked(), "Contact is locked");
476 		_;
477 	}
478 
479 	/**
480 	* @dev called by the owner to disable method, back to normal state
481 	*/
482 	function lock() public  onlyOwner {
483 		setLock(true);
484 		emit Locked();
485 	}
486 
487 	// Methods
488 	/**
489 	* @dev called by the owner to enable method
490 	*/
491 	function unlock() public onlyOwner  {
492 		setLock(false);
493 		emit Unlocked();
494 	}
495 
496 	function setLock(bool value) internal {
497         bytes32 slot = keccak256(abi.encode("Lockable", "lock"));
498         uint256 v = value ? 1 : 0;
499         assembly {
500             sstore(slot, v)
501         }
502     }
503 
504     function isLocked() public view returns (bool) {
505         bytes32 slot = keccak256(abi.encode("Lockable", "lock"));
506         uint256 v;
507         assembly {
508             v := sload(slot)
509         }
510         return v != 0;
511     }
512 
513 }
514 
515 // File: contracts/helpers/Pausable.sol
516 
517 
518 
519 
520 
521 /**
522  * @title Pausable
523  * @dev Base contract which allows children to implement an emergency stop mechanism. Identical to OpenZeppelin version
524  * except that it uses local Ownable contract
525  */
526 contract Pausable is Ownable {
527     event Pause();
528     event Unpause();
529 
530     /**
531     * @dev Modifier to make a function callable only when the contract is not paused.
532     */
533     modifier whenNotPaused() {
534         require(!isPaused(), "Contract is paused");
535         _;
536     }
537 
538     /**
539     * @dev Modifier to make a function callable only when the contract is paused.
540     */
541     modifier whenPaused() {
542         require(isPaused(), "Contract is not paused");
543         _;
544     }
545 
546     /**
547     * @dev called by the owner to pause, triggers stopped state
548     */
549     function pause() public onlyOwner  whenNotPaused  {
550         setPause(true);
551         emit Pause();
552     }
553 
554     /**
555     * @dev called by the owner to unpause, returns to normal state
556     */
557     function unpause() public onlyOwner  whenPaused {
558         setPause(false);
559         emit Unpause();
560     }
561 
562     function setPause(bool value) internal {
563         bytes32 slot = keccak256(abi.encode("Pausable", "pause"));
564         uint256 v = value ? 1 : 0;
565         assembly {
566             sstore(slot, v)
567         }
568     }
569 
570     function isPaused() public view returns (bool) {
571         bytes32 slot = keccak256(abi.encode("Pausable", "pause"));
572         uint256 v;
573         assembly {
574             v := sload(slot)
575         }
576         return v != 0;
577     }
578 }
579 
580 // File: contracts/helpers/Whitelist.sol
581 
582 
583 
584 /**
585  * @title Whitelist
586  * @dev Base contract which allows children to implement an emergency whitelist mechanism. Identical to OpenZeppelin version
587  * except that it uses local Ownable contract
588  */
589  
590 contract Whitelist is Ownable {
591     event AddToWhitelist(address indexed to);
592     event RemoveFromWhitelist(address indexed to);
593     event EnableWhitelist();
594     event DisableWhitelist();
595     event AddPermBalanceToWhitelist(address indexed to, uint256 balance);
596     event RemovePermBalanceToWhitelist(address indexed to);
597 
598     mapping(address => bool) internal whitelist;
599     mapping (address => uint256) internal permBalancesForWhitelist;
600 
601     /**
602     * @dev Modifier to make a function callable only when msg.sender is in whitelist.
603     */
604     modifier onlyWhitelist() {
605         if (isWhitelisted() == true) {
606             require(whitelist[msg.sender] == true, "Address is not in whitelist");
607         }
608         _;
609     }
610 
611     /**
612     * @dev Modifier to make a function callable only when msg.sender is in permitted balance
613     */
614     modifier checkPermBalanceForWhitelist(uint256 value) {
615         if (isWhitelisted() == true) {
616             require(permBalancesForWhitelist[msg.sender]==0 || permBalancesForWhitelist[msg.sender]>=value, "Not permitted balance for transfer");
617         }
618         
619         _;
620     }
621 
622     /**
623     * @dev called by the owner to set permitted balance for transfer
624     */
625 
626     function addPermBalanceToWhitelist(address _owner, uint256 _balance) public onlyOwner {
627         permBalancesForWhitelist[_owner] = _balance;
628         emit AddPermBalanceToWhitelist(_owner, _balance);
629     }
630 
631     /**
632     * @dev called by the owner to remove permitted balance for transfer
633     */
634     function removePermBalanceToWhitelist(address _owner) public onlyOwner {
635         permBalancesForWhitelist[_owner] = 0;
636         emit RemovePermBalanceToWhitelist(_owner);
637     }
638    
639     /**
640     * @dev called by the owner to enable whitelist
641     */
642 
643     function enableWhitelist() public onlyOwner {
644         setWhitelisted(true);
645         emit EnableWhitelist();
646     }
647 
648 
649     /**
650     * @dev called by the owner to disable whitelist
651     */
652     function disableWhitelist() public onlyOwner {
653         setWhitelisted(false);
654         emit DisableWhitelist();
655     }
656 
657     /**
658     * @dev called by the owner to enable some address for whitelist
659     */
660     function addToWhitelist(address _address) public onlyOwner  {
661         whitelist[_address] = true;
662         emit AddToWhitelist(_address);
663     }
664 
665     /**
666     * @dev called by the owner to disable address for whitelist
667     */
668     function removeFromWhitelist(address _address) public onlyOwner {
669         whitelist[_address] = false;
670         emit RemoveFromWhitelist(_address);
671     }
672 
673 
674     // bool public whitelisted = false;
675 
676     function setWhitelisted(bool value) internal {
677         bytes32 slot = keccak256(abi.encode("Whitelist", "whitelisted"));
678         uint256 v = value ? 1 : 0;
679         assembly {
680             sstore(slot, v)
681         }
682     }
683 
684     function isWhitelisted() public view returns (bool) {
685         bytes32 slot = keccak256(abi.encode("Whitelist", "whitelisted"));
686         uint256 v;
687         assembly {
688             v := sload(slot)
689         }
690         return v != 0;
691     }
692 }
693 
694 // File: contracts/token/AkropolisToken.sol
695 
696 
697 
698 
699 
700 
701 
702 
703 /**
704 * @title AkropolisToken
705 * @notice Adds pausability and disables approve() to defend against double-spend attacks in addition
706 * to inherited AkropolisBaseToken behavior
707 */
708 contract AkropolisToken is AkropolisBaseToken, Pausable, Lockable, Whitelist {
709     using SafeMath for uint256;
710 
711     /** Events */
712 
713     constructor (address _balances, address _allowances, string _name, uint8 _decimals, string _symbol) public 
714     AkropolisBaseToken(_balances, _allowances, _name, _decimals, _symbol) {}
715 
716     /** Modifiers **/
717 
718     /** Functions **/
719 
720     function mint(address _to, uint256 _amount) public {
721         super.mint(_to, _amount);
722     }
723 
724     function burn(uint256 _amount) public whenUnlocked  {
725         super.burn(_amount);
726     }
727 
728     /**
729     * @notice Implements ERC-20 standard approve function.
730     * double spend attacks. To modify allowances, clients should call safer increase/decreaseApproval methods.
731     * Upon construction, all calls to approve() will revert unless this contract owner explicitly unlocks approve()
732     */
733     function approve(address _spender, uint256 _value) 
734     public whenNotPaused  whenUnlocked returns (bool) {
735         return super.approve(_spender, _value);
736     }
737 
738     /**
739      * @dev Increase the amount of tokens that an owner allowed to a spender.
740      * @notice increaseApproval should be used instead of approve when the user's allowance
741      * is greater than 0. Using increaseApproval protects against potential double-spend attacks
742      * by moving the check of whether the user has spent their allowance to the time that the transaction 
743      * is mined, removing the user's ability to double-spend
744      * @param _spender The address which will spend the funds.
745      * @param _addedValue The amount of tokens to increase the allowance by.
746      */
747     function increaseApproval(address _spender, uint256 _addedValue) 
748     public whenNotPaused returns (bool) {
749         increaseApprovalAllArgs(_spender, _addedValue, msg.sender);
750         return true;
751     }
752 
753     /**
754      * @dev Decrease the amount of tokens that an owner allowed to a spender.
755      * @notice decreaseApproval should be used instead of approve when the user's allowance
756      * is greater than 0. Using decreaseApproval protects against potential double-spend attacks
757      * by moving the check of whether the user has spent their allowance to the time that the transaction 
758      * is mined, removing the user's ability to double-spend
759      * @param _spender The address which will spend the funds.
760      * @param _subtractedValue The amount of tokens to decrease the allowance by.
761      */
762     function decreaseApproval(address _spender, uint256 _subtractedValue) 
763     public whenNotPaused returns (bool) {
764         decreaseApprovalAllArgs(_spender, _subtractedValue, msg.sender);
765         return true;
766     }
767 
768     function transfer(address _to, uint256 _amount) public whenNotPaused onlyWhitelist checkPermBalanceForWhitelist(_amount) returns (bool) {
769         return super.transfer(_to, _amount);
770     }
771 
772     /**
773     * @notice Initiates a transfer operation between address `_from` and `_to`. Requires that the
774     * message sender is an approved spender on the _from account.
775     * @dev When implemented, it should use the transferFromConditionsRequired() modifier.
776     * @param _to The address of the recipient. This address must not be blacklisted.
777     * @param _from The address of the origin of funds. This address _could_ be blacklisted, because
778     * a regulator may want to transfer tokens out of a blacklisted account, for example.
779     * In order to do so, the regulator would have to add themselves as an approved spender
780     * on the account via `addBlacklistAddressSpender()`, and would then be able to transfer tokens out of it.
781     * @param _amount The number of tokens to transfer
782     * @return `true` if successful 
783     */
784     function transferFrom(address _from, address _to, uint256 _amount) 
785     public whenNotPaused onlyWhitelist checkPermBalanceForWhitelist(_amount) returns (bool) {
786         return super.transferFrom(_from, _to, _amount);
787     }
788 
789 
790     /** Internal functions **/
791     
792     function decreaseApprovalAllArgs(address _spender, uint256 _subtractedValue, address _tokenHolder) internal {
793         uint256 oldValue = allowances.allowanceOf(_tokenHolder, _spender);
794         if (_subtractedValue > oldValue) {
795             allowances.setAllowance(_tokenHolder, _spender, 0);
796         } else {
797             allowances.subAllowance(_tokenHolder, _spender, _subtractedValue);
798         }
799         emit Approval(_tokenHolder, _spender, allowances.allowanceOf(_tokenHolder, _spender));
800     }
801 
802     function increaseApprovalAllArgs(address _spender, uint256 _addedValue, address _tokenHolder) internal {
803         allowances.addAllowance(_tokenHolder, _spender, _addedValue);
804         emit Approval(_tokenHolder, _spender, allowances.allowanceOf(_tokenHolder, _spender));
805     }
806 }