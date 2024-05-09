1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.2;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.2;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://eips.ethereum.org/EIPS/eip-20
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123      * @dev Total number of tokens in existence
124      */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130      * @dev Gets the balance of the specified address.
131      * @param owner The address to query the balance of.
132      * @return A uint256 representing the amount owned by the passed address.
133      */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149      * @dev Transfer token to a specified address
150      * @param to The address to transfer to.
151      * @param value The amount to be transferred.
152      */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0));
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(account != address(0));
239 
240         _totalSupply = _totalSupply.add(value);
241         _balances[account] = _balances[account].add(value);
242         emit Transfer(address(0), account, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account.
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.sub(value);
255         _balances[account] = _balances[account].sub(value);
256         emit Transfer(account, address(0), value);
257     }
258 
259     /**
260      * @dev Approve an address to spend another addresses' tokens.
261      * @param owner The address that owns the tokens.
262      * @param spender The address that will spend the tokens.
263      * @param value The number of tokens that can be spent.
264      */
265     function _approve(address owner, address spender, uint256 value) internal {
266         require(spender != address(0));
267         require(owner != address(0));
268 
269         _allowed[owner][spender] = value;
270         emit Approval(owner, spender, value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _burn(account, value);
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: openzeppelin-solidity/contracts/access/Roles.sol
288 
289 pragma solidity ^0.5.2;
290 
291 /**
292  * @title Roles
293  * @dev Library for managing addresses assigned to a Role.
294  */
295 library Roles {
296     struct Role {
297         mapping (address => bool) bearer;
298     }
299 
300     /**
301      * @dev give an account access to this role
302      */
303     function add(Role storage role, address account) internal {
304         require(account != address(0));
305         require(!has(role, account));
306 
307         role.bearer[account] = true;
308     }
309 
310     /**
311      * @dev remove an account's access to this role
312      */
313     function remove(Role storage role, address account) internal {
314         require(account != address(0));
315         require(has(role, account));
316 
317         role.bearer[account] = false;
318     }
319 
320     /**
321      * @dev check if an account has this role
322      * @return bool
323      */
324     function has(Role storage role, address account) internal view returns (bool) {
325         require(account != address(0));
326         return role.bearer[account];
327     }
328 }
329 
330 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
331 
332 pragma solidity ^0.5.2;
333 
334 
335 contract PauserRole {
336     using Roles for Roles.Role;
337 
338     event PauserAdded(address indexed account);
339     event PauserRemoved(address indexed account);
340 
341     Roles.Role private _pausers;
342 
343     constructor () internal {
344         _addPauser(msg.sender);
345     }
346 
347     modifier onlyPauser() {
348         require(isPauser(msg.sender));
349         _;
350     }
351 
352     function isPauser(address account) public view returns (bool) {
353         return _pausers.has(account);
354     }
355 
356     function addPauser(address account) public onlyPauser {
357         _addPauser(account);
358     }
359 
360     function renouncePauser() public {
361         _removePauser(msg.sender);
362     }
363 
364     function _addPauser(address account) internal {
365         _pausers.add(account);
366         emit PauserAdded(account);
367     }
368 
369     function _removePauser(address account) internal {
370         _pausers.remove(account);
371         emit PauserRemoved(account);
372     }
373 }
374 
375 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
376 
377 pragma solidity ^0.5.2;
378 
379 
380 /**
381  * @title Pausable
382  * @dev Base contract which allows children to implement an emergency stop mechanism.
383  */
384 contract Pausable is PauserRole {
385     event Paused(address account);
386     event Unpaused(address account);
387 
388     bool private _paused;
389 
390     constructor () internal {
391         _paused = false;
392     }
393 
394     /**
395      * @return true if the contract is paused, false otherwise.
396      */
397     function paused() public view returns (bool) {
398         return _paused;
399     }
400 
401     /**
402      * @dev Modifier to make a function callable only when the contract is not paused.
403      */
404     modifier whenNotPaused() {
405         require(!_paused);
406         _;
407     }
408 
409     /**
410      * @dev Modifier to make a function callable only when the contract is paused.
411      */
412     modifier whenPaused() {
413         require(_paused);
414         _;
415     }
416 
417     /**
418      * @dev called by the owner to pause, triggers stopped state
419      */
420     function pause() public onlyPauser whenNotPaused {
421         _paused = true;
422         emit Paused(msg.sender);
423     }
424 
425     /**
426      * @dev called by the owner to unpause, returns to normal state
427      */
428     function unpause() public onlyPauser whenPaused {
429         _paused = false;
430         emit Unpaused(msg.sender);
431     }
432 }
433 
434 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
435 
436 pragma solidity ^0.5.2;
437 
438 
439 
440 /**
441  * @title Pausable token
442  * @dev ERC20 modified with pausable transfers.
443  */
444 contract ERC20Pausable is ERC20, Pausable {
445     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
446         return super.transfer(to, value);
447     }
448 
449     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
450         return super.transferFrom(from, to, value);
451     }
452 
453     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
454         return super.approve(spender, value);
455     }
456 
457     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
458         return super.increaseAllowance(spender, addedValue);
459     }
460 
461     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
462         return super.decreaseAllowance(spender, subtractedValue);
463     }
464 }
465 
466 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
467 
468 pragma solidity ^0.5.2;
469 
470 
471 /**
472  * @title Burnable Token
473  * @dev Token that can be irreversibly burned (destroyed).
474  */
475 contract ERC20Burnable is ERC20 {
476     /**
477      * @dev Burns a specific amount of tokens.
478      * @param value The amount of token to be burned.
479      */
480     function burn(uint256 value) public {
481         _burn(msg.sender, value);
482     }
483 
484     /**
485      * @dev Burns a specific amount of tokens from the target address and decrements allowance
486      * @param from address The account whose tokens will be burned.
487      * @param value uint256 The amount of token to be burned.
488      */
489     function burnFrom(address from, uint256 value) public {
490         _burnFrom(from, value);
491     }
492 }
493 
494 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
495 
496 pragma solidity ^0.5.2;
497 
498 
499 /**
500  * @title ERC20Detailed token
501  * @dev The decimals are only for visualization purposes.
502  * All the operations are done using the smallest and indivisible token unit,
503  * just as on Ethereum all the operations are done in wei.
504  */
505 contract ERC20Detailed is IERC20 {
506     string private _name;
507     string private _symbol;
508     uint8 private _decimals;
509 
510     constructor (string memory name, string memory symbol, uint8 decimals) public {
511         _name = name;
512         _symbol = symbol;
513         _decimals = decimals;
514     }
515 
516     /**
517      * @return the name of the token.
518      */
519     function name() public view returns (string memory) {
520         return _name;
521     }
522 
523     /**
524      * @return the symbol of the token.
525      */
526     function symbol() public view returns (string memory) {
527         return _symbol;
528     }
529 
530     /**
531      * @return the number of decimals of the token.
532      */
533     function decimals() public view returns (uint8) {
534         return _decimals;
535     }
536 }
537 
538 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
539 
540 pragma solidity ^0.5.2;
541 
542 /**
543  * @title Ownable
544  * @dev The Ownable contract has an owner address, and provides basic authorization control
545  * functions, this simplifies the implementation of "user permissions".
546  */
547 contract Ownable {
548     address private _owner;
549 
550     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
551 
552     /**
553      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
554      * account.
555      */
556     constructor () internal {
557         _owner = msg.sender;
558         emit OwnershipTransferred(address(0), _owner);
559     }
560 
561     /**
562      * @return the address of the owner.
563      */
564     function owner() public view returns (address) {
565         return _owner;
566     }
567 
568     /**
569      * @dev Throws if called by any account other than the owner.
570      */
571     modifier onlyOwner() {
572         require(isOwner());
573         _;
574     }
575 
576     /**
577      * @return true if `msg.sender` is the owner of the contract.
578      */
579     function isOwner() public view returns (bool) {
580         return msg.sender == _owner;
581     }
582 
583     /**
584      * @dev Allows the current owner to relinquish control of the contract.
585      * It will not be possible to call the functions with the `onlyOwner`
586      * modifier anymore.
587      * @notice Renouncing ownership will leave the contract without an owner,
588      * thereby removing any functionality that is only available to the owner.
589      */
590     function renounceOwnership() public onlyOwner {
591         emit OwnershipTransferred(_owner, address(0));
592         _owner = address(0);
593     }
594 
595     /**
596      * @dev Allows the current owner to transfer control of the contract to a newOwner.
597      * @param newOwner The address to transfer ownership to.
598      */
599     function transferOwnership(address newOwner) public onlyOwner {
600         _transferOwnership(newOwner);
601     }
602 
603     /**
604      * @dev Transfers control of the contract to a newOwner.
605      * @param newOwner The address to transfer ownership to.
606      */
607     function _transferOwnership(address newOwner) internal {
608         require(newOwner != address(0));
609         emit OwnershipTransferred(_owner, newOwner);
610         _owner = newOwner;
611     }
612 }
613 
614 // File: contracts/XcelDefi.sol
615 
616 pragma solidity >=0.4.25 <0.6.0;
617 
618 
619 
620 
621 
622 contract XcelDefi is ERC20Detailed, ERC20Pausable, ERC20Burnable, Ownable {
623 
624   uint256 public constant INITIAL_SUPPLY = 277 * (10**6) * (10**18);
625 
626   uint256 public vestingSupply = 37.5 * (10**6) * (10**18);
627 
628   uint256 public publicSaleSupply = 177 * (10**6) * (10**18);
629 
630   uint256 public foundationSupply = 37.5 * (10**6) * (10**18);
631 
632   uint256 public reserveSupply = 25 * (10**6) * (10**18);
633 
634   address public publicSaleAddress;
635   address public vestingAddress;
636   address public foundationAddress;
637   address public reserveAddress;
638 //safety measure , disputes are visible here and is expected to resolve via community concensus.
639   mapping(address => bool) internal lockedAccounts;
640 
641 
642   constructor(string memory _name,
643     string memory _symbol,
644     uint8 _decimals,
645     address _vestingAddress,
646     address _publicSaleAddress,
647     address _foundationAddress,
648     address _reserveAddress)
649     ERC20Detailed(_name, _symbol, _decimals)
650     public {
651       //mint all tokens to contract owner address;
652       _mint(msg.sender, INITIAL_SUPPLY);
653 
654       publicSaleAddress = _publicSaleAddress;
655       vestingAddress = _vestingAddress;
656       foundationAddress = _foundationAddress;
657       reserveAddress = _reserveAddress;
658       transfer(_vestingAddress, vestingSupply);
659       transfer(_publicSaleAddress, publicSaleSupply);
660       transfer(_foundationAddress,foundationSupply);
661       transfer(_reserveAddress,reserveSupply);
662 
663   }
664 
665   event TokensBought(address indexed _to, uint256 _totalAmount, bytes4 _currency, bytes32 _txHash);
666 
667   event LockedAccount(address indexed _targetAddress);
668 
669   event UnlockedAccount(address indexed _targetAddress);
670 
671   modifier onlyPublicSaleAdmin() {
672       require(msg.sender == publicSaleAddress);
673       _;
674   }
675 
676   //Allow contract owner to burn token
677   //To burn token, it first needs to be transferred to the owner
678   function burn(uint256 _value)
679     public
680     onlyOwner {
681       super.burn(_value);
682   }
683 
684   /**
685   external function for publicSaleSupply
686   **/
687 
688     function buyTokens(address _to, uint256 _totalWeiAmount, bytes4 _currency, bytes32 _txHash)
689       external
690       onlyPublicSaleAdmin
691       returns(bool) {
692           require(_totalWeiAmount > 0 && balanceOf(msg.sender) >= _totalWeiAmount);
693           require(transfer(_to, _totalWeiAmount));
694           emit TokensBought(_to, _totalWeiAmount, _currency, _txHash);
695           return true;
696       }
697 
698    /** lock the Account for security
699   **/
700 
701   function lockAccount(address _targetAddress) external onlyOwner returns(bool){
702       require(_targetAddress != address(0));
703       require(!lockedAccounts[_targetAddress]);
704       //can't lockyourself out
705       require(owner() != _targetAddress);
706       lockedAccounts[_targetAddress] = true;
707       emit LockedAccount(_targetAddress);
708       return true;
709   }
710 
711   /** unlock the Account for security
712   **/
713 
714   function unlockAccount(address _targetAddress) external onlyOwner returns(bool){
715       require(_targetAddress != address(0));
716       require(lockedAccounts[_targetAddress]);
717       delete lockedAccounts[_targetAddress];
718       emit UnlockedAccount(_targetAddress);
719       return true;
720   }
721 
722   /** get locked/unlocked satus of the account
723   **/
724 
725   function isAddressLocked(address _targetAddress) public view returns(bool){
726      //if address not in mapping , returns false
727      return lockedAccounts[_targetAddress];
728   }
729 
730 
731 
732   /** hold the transfer for locked account
733   **/
734 
735     function transfer(address to, uint256 value) public returns (bool) {
736         require(!lockedAccounts[msg.sender]);
737         require(to != address(this)); // do not accept transfer to the contract address
738         super.transfer(to, value);
739         return true;
740     }
741 
742   // Sending Ether to this contract will cause an exception,
743   // because the fallback function does not have the `payable`
744   // modifier.
745   function() external {  }
746 
747 }