1 // File: openzeppelin-solidity/contracts/access/Roles.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
45 
46 pragma solidity ^0.5.0;
47 
48 /**
49  * @title SafeMath
50  * @dev Unsigned math operations with safety checks that revert on error
51  */
52 library SafeMath {
53     /**
54     * @dev Multiplies two unsigned integers, reverts on overflow.
55     */
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
58         // benefit is lost if 'b' is also tested.
59         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
60         if (a == 0) {
61             return 0;
62         }
63 
64         uint256 c = a * b;
65         require(c / a == b);
66 
67         return c;
68     }
69 
70     /**
71     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
72     */
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Solidity only automatically asserts when dividing by 0
75         require(b > 0);
76         uint256 c = a / b;
77         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 
79         return c;
80     }
81 
82     /**
83     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
84     */
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b <= a);
87         uint256 c = a - b;
88 
89         return c;
90     }
91 
92     /**
93     * @dev Adds two unsigned integers, reverts on overflow.
94     */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
104     * reverts when dividing by zero.
105     */
106     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
107         require(b != 0);
108         return a % b;
109     }
110 }
111 
112 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
113 
114 pragma solidity ^0.5.0;
115 
116 
117 contract PauserRole {
118     using Roles for Roles.Role;
119 
120     event PauserAdded(address indexed account);
121     event PauserRemoved(address indexed account);
122 
123     Roles.Role private _pausers;
124 
125     constructor () internal {
126         _addPauser(msg.sender);
127     }
128 
129     modifier onlyPauser() {
130         require(isPauser(msg.sender));
131         _;
132     }
133 
134     function isPauser(address account) public view returns (bool) {
135         return _pausers.has(account);
136     }
137 
138     function addPauser(address account) public onlyPauser {
139         _addPauser(account);
140     }
141 
142     function renouncePauser() public {
143         _removePauser(msg.sender);
144     }
145 
146     function _addPauser(address account) internal {
147         _pausers.add(account);
148         emit PauserAdded(account);
149     }
150 
151     function _removePauser(address account) internal {
152         _pausers.remove(account);
153         emit PauserRemoved(account);
154     }
155 }
156 
157 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
158 
159 pragma solidity ^0.5.0;
160 
161 
162 /**
163  * @title Pausable
164  * @dev Base contract which allows children to implement an emergency stop mechanism.
165  */
166 contract Pausable is PauserRole {
167     event Paused(address account);
168     event Unpaused(address account);
169 
170     bool private _paused;
171 
172     constructor () internal {
173         _paused = false;
174     }
175 
176     /**
177      * @return true if the contract is paused, false otherwise.
178      */
179     function paused() public view returns (bool) {
180         return _paused;
181     }
182 
183     /**
184      * @dev Modifier to make a function callable only when the contract is not paused.
185      */
186     modifier whenNotPaused() {
187         require(!_paused);
188         _;
189     }
190 
191     /**
192      * @dev Modifier to make a function callable only when the contract is paused.
193      */
194     modifier whenPaused() {
195         require(_paused);
196         _;
197     }
198 
199     /**
200      * @dev called by the owner to pause, triggers stopped state
201      */
202     function pause() public onlyPauser whenNotPaused {
203         _paused = true;
204         emit Paused(msg.sender);
205     }
206 
207     /**
208      * @dev called by the owner to unpause, returns to normal state
209      */
210     function unpause() public onlyPauser whenPaused {
211         _paused = false;
212         emit Unpaused(msg.sender);
213     }
214 }
215 
216 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
217 
218 pragma solidity ^0.5.0;
219 
220 /**
221  * @title Ownable
222  * @dev The Ownable contract has an owner address, and provides basic authorization control
223  * functions, this simplifies the implementation of "user permissions".
224  */
225 contract Ownable {
226     address private _owner;
227 
228     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
229 
230     /**
231      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
232      * account.
233      */
234     constructor () internal {
235         _owner = msg.sender;
236         emit OwnershipTransferred(address(0), _owner);
237     }
238 
239     /**
240      * @return the address of the owner.
241      */
242     function owner() public view returns (address) {
243         return _owner;
244     }
245 
246     /**
247      * @dev Throws if called by any account other than the owner.
248      */
249     modifier onlyOwner() {
250         require(isOwner());
251         _;
252     }
253 
254     /**
255      * @return true if `msg.sender` is the owner of the contract.
256      */
257     function isOwner() public view returns (bool) {
258         return msg.sender == _owner;
259     }
260 
261     /**
262      * @dev Allows the current owner to relinquish control of the contract.
263      * @notice Renouncing to ownership will leave the contract without an owner.
264      * It will not be possible to call the functions with the `onlyOwner`
265      * modifier anymore.
266      */
267     function renounceOwnership() public onlyOwner {
268         emit OwnershipTransferred(_owner, address(0));
269         _owner = address(0);
270     }
271 
272     /**
273      * @dev Allows the current owner to transfer control of the contract to a newOwner.
274      * @param newOwner The address to transfer ownership to.
275      */
276     function transferOwnership(address newOwner) public onlyOwner {
277         _transferOwnership(newOwner);
278     }
279 
280     /**
281      * @dev Transfers control of the contract to a newOwner.
282      * @param newOwner The address to transfer ownership to.
283      */
284     function _transferOwnership(address newOwner) internal {
285         require(newOwner != address(0));
286         emit OwnershipTransferred(_owner, newOwner);
287         _owner = newOwner;
288     }
289 }
290 
291 // File: @daostack/infra/contracts/Reputation.sol
292 
293 pragma solidity ^0.5.4;
294 
295 
296 
297 /**
298  * @title Reputation system
299  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
300  * A reputation is use to assign influence measure to a DAO'S peers.
301  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
302  * The Reputation contract maintain a map of address to reputation value.
303  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
304  */
305 
306 contract Reputation is Ownable {
307 
308     uint8 public decimals = 18;             //Number of decimals of the smallest unit
309     // Event indicating minting of reputation to an address.
310     event Mint(address indexed _to, uint256 _amount);
311     // Event indicating burning of reputation for an address.
312     event Burn(address indexed _from, uint256 _amount);
313 
314       /// @dev `Checkpoint` is the structure that attaches a block number to a
315       ///  given value, the block number attached is the one that last changed the
316       ///  value
317     struct Checkpoint {
318 
319     // `fromBlock` is the block number that the value was generated from
320         uint128 fromBlock;
321 
322           // `value` is the amount of reputation at a specific block number
323         uint128 value;
324     }
325 
326       // `balances` is the map that tracks the balance of each address, in this
327       //  contract when the balance changes the block number that the change
328       //  occurred is also included in the map
329     mapping (address => Checkpoint[]) balances;
330 
331       // Tracks the history of the `totalSupply` of the reputation
332     Checkpoint[] totalSupplyHistory;
333 
334     /// @notice Constructor to create a Reputation
335     constructor(
336     ) public
337     {
338     }
339 
340     /// @dev This function makes it easy to get the total number of reputation
341     /// @return The total number of reputation
342     function totalSupply() public view returns (uint256) {
343         return totalSupplyAt(block.number);
344     }
345 
346   ////////////////
347   // Query balance and totalSupply in History
348   ////////////////
349     /**
350     * @dev return the reputation amount of a given owner
351     * @param _owner an address of the owner which we want to get his reputation
352     */
353     function balanceOf(address _owner) public view returns (uint256 balance) {
354         return balanceOfAt(_owner, block.number);
355     }
356 
357       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
358       /// @param _owner The address from which the balance will be retrieved
359       /// @param _blockNumber The block number when the balance is queried
360       /// @return The balance at `_blockNumber`
361     function balanceOfAt(address _owner, uint256 _blockNumber)
362     public view returns (uint256)
363     {
364         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
365             return 0;
366           // This will return the expected balance during normal situations
367         } else {
368             return getValueAt(balances[_owner], _blockNumber);
369         }
370     }
371 
372       /// @notice Total amount of reputation at a specific `_blockNumber`.
373       /// @param _blockNumber The block number when the totalSupply is queried
374       /// @return The total amount of reputation at `_blockNumber`
375     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
376         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
377             return 0;
378           // This will return the expected totalSupply during normal situations
379         } else {
380             return getValueAt(totalSupplyHistory, _blockNumber);
381         }
382     }
383 
384       /// @notice Generates `_amount` reputation that are assigned to `_owner`
385       /// @param _user The address that will be assigned the new reputation
386       /// @param _amount The quantity of reputation generated
387       /// @return True if the reputation are generated correctly
388     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
389         uint256 curTotalSupply = totalSupply();
390         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
391         uint256 previousBalanceTo = balanceOf(_user);
392         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
393         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
394         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
395         emit Mint(_user, _amount);
396         return true;
397     }
398 
399       /// @notice Burns `_amount` reputation from `_owner`
400       /// @param _user The address that will lose the reputation
401       /// @param _amount The quantity of reputation to burn
402       /// @return True if the reputation are burned correctly
403     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
404         uint256 curTotalSupply = totalSupply();
405         uint256 amountBurned = _amount;
406         uint256 previousBalanceFrom = balanceOf(_user);
407         if (previousBalanceFrom < amountBurned) {
408             amountBurned = previousBalanceFrom;
409         }
410         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
411         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
412         emit Burn(_user, amountBurned);
413         return true;
414     }
415 
416   ////////////////
417   // Internal helper functions to query and set a value in a snapshot array
418   ////////////////
419 
420       /// @dev `getValueAt` retrieves the number of reputation at a given block number
421       /// @param checkpoints The history of values being queried
422       /// @param _block The block number to retrieve the value at
423       /// @return The number of reputation being queried
424     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
425         if (checkpoints.length == 0) {
426             return 0;
427         }
428 
429           // Shortcut for the actual value
430         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
431             return checkpoints[checkpoints.length-1].value;
432         }
433         if (_block < checkpoints[0].fromBlock) {
434             return 0;
435         }
436 
437           // Binary search of the value in the array
438         uint256 min = 0;
439         uint256 max = checkpoints.length-1;
440         while (max > min) {
441             uint256 mid = (max + min + 1) / 2;
442             if (checkpoints[mid].fromBlock<=_block) {
443                 min = mid;
444             } else {
445                 max = mid-1;
446             }
447         }
448         return checkpoints[min].value;
449     }
450 
451       /// @dev `updateValueAtNow` used to update the `balances` map and the
452       ///  `totalSupplyHistory`
453       /// @param checkpoints The history of data being updated
454       /// @param _value The new number of reputation
455     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
456         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
457         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
458             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
459             newCheckPoint.fromBlock = uint128(block.number);
460             newCheckPoint.value = uint128(_value);
461         } else {
462             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
463             oldCheckPoint.value = uint128(_value);
464         }
465     }
466 }
467 
468 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
469 
470 pragma solidity ^0.5.0;
471 
472 /**
473  * @title ERC20 interface
474  * @dev see https://github.com/ethereum/EIPs/issues/20
475  */
476 interface IERC20 {
477     function transfer(address to, uint256 value) external returns (bool);
478 
479     function approve(address spender, uint256 value) external returns (bool);
480 
481     function transferFrom(address from, address to, uint256 value) external returns (bool);
482 
483     function totalSupply() external view returns (uint256);
484 
485     function balanceOf(address who) external view returns (uint256);
486 
487     function allowance(address owner, address spender) external view returns (uint256);
488 
489     event Transfer(address indexed from, address indexed to, uint256 value);
490 
491     event Approval(address indexed owner, address indexed spender, uint256 value);
492 }
493 
494 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
495 
496 pragma solidity ^0.5.0;
497 
498 
499 
500 /**
501  * @title Standard ERC20 token
502  *
503  * @dev Implementation of the basic standard token.
504  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
505  * Originally based on code by FirstBlood:
506  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
507  *
508  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
509  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
510  * compliant implementations may not do it.
511  */
512 contract ERC20 is IERC20 {
513     using SafeMath for uint256;
514 
515     mapping (address => uint256) private _balances;
516 
517     mapping (address => mapping (address => uint256)) private _allowed;
518 
519     uint256 private _totalSupply;
520 
521     /**
522     * @dev Total number of tokens in existence
523     */
524     function totalSupply() public view returns (uint256) {
525         return _totalSupply;
526     }
527 
528     /**
529     * @dev Gets the balance of the specified address.
530     * @param owner The address to query the balance of.
531     * @return An uint256 representing the amount owned by the passed address.
532     */
533     function balanceOf(address owner) public view returns (uint256) {
534         return _balances[owner];
535     }
536 
537     /**
538      * @dev Function to check the amount of tokens that an owner allowed to a spender.
539      * @param owner address The address which owns the funds.
540      * @param spender address The address which will spend the funds.
541      * @return A uint256 specifying the amount of tokens still available for the spender.
542      */
543     function allowance(address owner, address spender) public view returns (uint256) {
544         return _allowed[owner][spender];
545     }
546 
547     /**
548     * @dev Transfer token for a specified address
549     * @param to The address to transfer to.
550     * @param value The amount to be transferred.
551     */
552     function transfer(address to, uint256 value) public returns (bool) {
553         _transfer(msg.sender, to, value);
554         return true;
555     }
556 
557     /**
558      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
559      * Beware that changing an allowance with this method brings the risk that someone may use both the old
560      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
561      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
562      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
563      * @param spender The address which will spend the funds.
564      * @param value The amount of tokens to be spent.
565      */
566     function approve(address spender, uint256 value) public returns (bool) {
567         require(spender != address(0));
568 
569         _allowed[msg.sender][spender] = value;
570         emit Approval(msg.sender, spender, value);
571         return true;
572     }
573 
574     /**
575      * @dev Transfer tokens from one address to another.
576      * Note that while this function emits an Approval event, this is not required as per the specification,
577      * and other compliant implementations may not emit the event.
578      * @param from address The address which you want to send tokens from
579      * @param to address The address which you want to transfer to
580      * @param value uint256 the amount of tokens to be transferred
581      */
582     function transferFrom(address from, address to, uint256 value) public returns (bool) {
583         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
584         _transfer(from, to, value);
585         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
586         return true;
587     }
588 
589     /**
590      * @dev Increase the amount of tokens that an owner allowed to a spender.
591      * approve should be called when allowed_[_spender] == 0. To increment
592      * allowed value is better to use this function to avoid 2 calls (and wait until
593      * the first transaction is mined)
594      * From MonolithDAO Token.sol
595      * Emits an Approval event.
596      * @param spender The address which will spend the funds.
597      * @param addedValue The amount of tokens to increase the allowance by.
598      */
599     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
600         require(spender != address(0));
601 
602         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
603         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
604         return true;
605     }
606 
607     /**
608      * @dev Decrease the amount of tokens that an owner allowed to a spender.
609      * approve should be called when allowed_[_spender] == 0. To decrement
610      * allowed value is better to use this function to avoid 2 calls (and wait until
611      * the first transaction is mined)
612      * From MonolithDAO Token.sol
613      * Emits an Approval event.
614      * @param spender The address which will spend the funds.
615      * @param subtractedValue The amount of tokens to decrease the allowance by.
616      */
617     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
618         require(spender != address(0));
619 
620         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
621         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
622         return true;
623     }
624 
625     /**
626     * @dev Transfer token for a specified addresses
627     * @param from The address to transfer from.
628     * @param to The address to transfer to.
629     * @param value The amount to be transferred.
630     */
631     function _transfer(address from, address to, uint256 value) internal {
632         require(to != address(0));
633 
634         _balances[from] = _balances[from].sub(value);
635         _balances[to] = _balances[to].add(value);
636         emit Transfer(from, to, value);
637     }
638 
639     /**
640      * @dev Internal function that mints an amount of the token and assigns it to
641      * an account. This encapsulates the modification of balances such that the
642      * proper events are emitted.
643      * @param account The account that will receive the created tokens.
644      * @param value The amount that will be created.
645      */
646     function _mint(address account, uint256 value) internal {
647         require(account != address(0));
648 
649         _totalSupply = _totalSupply.add(value);
650         _balances[account] = _balances[account].add(value);
651         emit Transfer(address(0), account, value);
652     }
653 
654     /**
655      * @dev Internal function that burns an amount of the token of a given
656      * account.
657      * @param account The account whose tokens will be burnt.
658      * @param value The amount that will be burnt.
659      */
660     function _burn(address account, uint256 value) internal {
661         require(account != address(0));
662 
663         _totalSupply = _totalSupply.sub(value);
664         _balances[account] = _balances[account].sub(value);
665         emit Transfer(account, address(0), value);
666     }
667 
668     /**
669      * @dev Internal function that burns an amount of the token of a given
670      * account, deducting from the sender's allowance for said account. Uses the
671      * internal burn function.
672      * Emits an Approval event (reflecting the reduced allowance).
673      * @param account The account whose tokens will be burnt.
674      * @param value The amount that will be burnt.
675      */
676     function _burnFrom(address account, uint256 value) internal {
677         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
678         _burn(account, value);
679         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
680     }
681 }
682 
683 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
684 
685 pragma solidity ^0.5.0;
686 
687 
688 /**
689  * @title Burnable Token
690  * @dev Token that can be irreversibly burned (destroyed).
691  */
692 contract ERC20Burnable is ERC20 {
693     /**
694      * @dev Burns a specific amount of tokens.
695      * @param value The amount of token to be burned.
696      */
697     function burn(uint256 value) public {
698         _burn(msg.sender, value);
699     }
700 
701     /**
702      * @dev Burns a specific amount of tokens from the target address and decrements allowance
703      * @param from address The address which you want to send tokens from
704      * @param value uint256 The amount of token to be burned
705      */
706     function burnFrom(address from, uint256 value) public {
707         _burnFrom(from, value);
708     }
709 }
710 
711 // File: @daostack/arc/contracts/controller/DAOToken.sol
712 
713 pragma solidity ^0.5.4;
714 
715 
716 
717 
718 
719 /**
720  * @title DAOToken, base on zeppelin contract.
721  * @dev ERC20 compatible token. It is a mintable, burnable token.
722  */
723 
724 contract DAOToken is ERC20, ERC20Burnable, Ownable {
725 
726     string public name;
727     string public symbol;
728     // solhint-disable-next-line const-name-snakecase
729     uint8 public constant decimals = 18;
730     uint256 public cap;
731 
732     /**
733     * @dev Constructor
734     * @param _name - token name
735     * @param _symbol - token symbol
736     * @param _cap - token cap - 0 value means no cap
737     */
738     constructor(string memory _name, string memory _symbol, uint256 _cap)
739     public {
740         name = _name;
741         symbol = _symbol;
742         cap = _cap;
743     }
744 
745     /**
746      * @dev Function to mint tokens
747      * @param _to The address that will receive the minted tokens.
748      * @param _amount The amount of tokens to mint.
749      */
750     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
751         if (cap > 0)
752             require(totalSupply().add(_amount) <= cap);
753         _mint(_to, _amount);
754         return true;
755     }
756 }
757 
758 // File: openzeppelin-solidity/contracts/utils/Address.sol
759 
760 pragma solidity ^0.5.0;
761 
762 /**
763  * Utility library of inline functions on addresses
764  */
765 library Address {
766     /**
767      * Returns whether the target address is a contract
768      * @dev This function will return false if invoked during the constructor of a contract,
769      * as the code is not actually created until after the constructor finishes.
770      * @param account address of the account to check
771      * @return whether the target address is a contract
772      */
773     function isContract(address account) internal view returns (bool) {
774         uint256 size;
775         // XXX Currently there is no better way to check if there is a contract in an address
776         // than to check the size of the code at that address.
777         // See https://ethereum.stackexchange.com/a/14016/36603
778         // for more details about how this works.
779         // TODO Check this again before the Serenity release, because all addresses will be
780         // contracts then.
781         // solhint-disable-next-line no-inline-assembly
782         assembly { size := extcodesize(account) }
783         return size > 0;
784     }
785 }
786 
787 // File: @daostack/arc/contracts/libs/SafeERC20.sol
788 
789 /*
790 
791 SafeERC20 by daostack.
792 The code is based on a fix by SECBIT Team.
793 
794 USE WITH CAUTION & NO WARRANTY
795 
796 REFERENCE & RELATED READING
797 - https://github.com/ethereum/solidity/issues/4116
798 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
799 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
800 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
801 
802 */
803 pragma solidity ^0.5.4;
804 
805 
806 
807 library SafeERC20 {
808     using Address for address;
809 
810     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
811     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
812     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
813 
814     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
815 
816         // Must be a contract addr first!
817         require(_erc20Addr.isContract());
818 
819         (bool success, bytes memory returnValue) =
820         // solhint-disable-next-line avoid-low-level-calls
821         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
822         // call return false when something wrong
823         require(success);
824         //check return value
825         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
826     }
827 
828     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
829 
830         // Must be a contract addr first!
831         require(_erc20Addr.isContract());
832 
833         (bool success, bytes memory returnValue) =
834         // solhint-disable-next-line avoid-low-level-calls
835         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
836         // call return false when something wrong
837         require(success);
838         //check return value
839         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
840     }
841 
842     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
843 
844         // Must be a contract addr first!
845         require(_erc20Addr.isContract());
846 
847         // safeApprove should only be called when setting an initial allowance,
848         // or when resetting it to zero.
849         require((_value == 0) || (IERC20(_erc20Addr).allowance(address(this), _spender) == 0));
850 
851         (bool success, bytes memory returnValue) =
852         // solhint-disable-next-line avoid-low-level-calls
853         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
854         // call return false when something wrong
855         require(success);
856         //check return value
857         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
858     }
859 }
860 
861 // File: @daostack/arc/contracts/controller/Avatar.sol
862 
863 pragma solidity ^0.5.4;
864 
865 
866 
867 
868 
869 
870 
871 /**
872  * @title An Avatar holds tokens, reputation and ether for a controller
873  */
874 contract Avatar is Ownable {
875     using SafeERC20 for address;
876 
877     string public orgName;
878     DAOToken public nativeToken;
879     Reputation public nativeReputation;
880 
881     event GenericCall(address indexed _contract, bytes _data, uint _value, bool _success);
882     event SendEther(uint256 _amountInWei, address indexed _to);
883     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint256 _value);
884     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint256 _value);
885     event ExternalTokenApproval(address indexed _externalToken, address _spender, uint256 _value);
886     event ReceiveEther(address indexed _sender, uint256 _value);
887     event MetaData(string _metaData);
888 
889     /**
890     * @dev the constructor takes organization name, native token and reputation system
891     and creates an avatar for a controller
892     */
893     constructor(string memory _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
894         orgName = _orgName;
895         nativeToken = _nativeToken;
896         nativeReputation = _nativeReputation;
897     }
898 
899     /**
900     * @dev enables an avatar to receive ethers
901     */
902     function() external payable {
903         emit ReceiveEther(msg.sender, msg.value);
904     }
905 
906     /**
907     * @dev perform a generic call to an arbitrary contract
908     * @param _contract  the contract's address to call
909     * @param _data ABI-encoded contract call to call `_contract` address.
910     * @param _value value (ETH) to transfer with the transaction
911     * @return bool    success or fail
912     *         bytes - the return bytes of the called contract's function.
913     */
914     function genericCall(address _contract, bytes memory _data, uint256 _value)
915     public
916     onlyOwner
917     returns(bool success, bytes memory returnValue) {
918       // solhint-disable-next-line avoid-call-value
919         (success, returnValue) = _contract.call.value(_value)(_data);
920         emit GenericCall(_contract, _data, _value, success);
921     }
922 
923     /**
924     * @dev send ethers from the avatar's wallet
925     * @param _amountInWei amount to send in Wei units
926     * @param _to send the ethers to this address
927     * @return bool which represents success
928     */
929     function sendEther(uint256 _amountInWei, address payable _to) public onlyOwner returns(bool) {
930         _to.transfer(_amountInWei);
931         emit SendEther(_amountInWei, _to);
932         return true;
933     }
934 
935     /**
936     * @dev external token transfer
937     * @param _externalToken the token contract
938     * @param _to the destination address
939     * @param _value the amount of tokens to transfer
940     * @return bool which represents success
941     */
942     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
943     public onlyOwner returns(bool)
944     {
945         address(_externalToken).safeTransfer(_to, _value);
946         emit ExternalTokenTransfer(address(_externalToken), _to, _value);
947         return true;
948     }
949 
950     /**
951     * @dev external token transfer from a specific account
952     * @param _externalToken the token contract
953     * @param _from the account to spend token from
954     * @param _to the destination address
955     * @param _value the amount of tokens to transfer
956     * @return bool which represents success
957     */
958     function externalTokenTransferFrom(
959         IERC20 _externalToken,
960         address _from,
961         address _to,
962         uint256 _value
963     )
964     public onlyOwner returns(bool)
965     {
966         address(_externalToken).safeTransferFrom(_from, _to, _value);
967         emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
968         return true;
969     }
970 
971     /**
972     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
973     *      on behalf of msg.sender.
974     * @param _externalToken the address of the Token Contract
975     * @param _spender address
976     * @param _value the amount of ether (in Wei) which the approval is referring to.
977     * @return bool which represents a success
978     */
979     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
980     public onlyOwner returns(bool)
981     {
982         address(_externalToken).safeApprove(_spender, _value);
983         emit ExternalTokenApproval(address(_externalToken), _spender, _value);
984         return true;
985     }
986 
987     /**
988     * @dev metaData emits an event with a string, should contain the hash of some meta data.
989     * @param _metaData a string representing a hash of the meta data
990     * @return bool which represents a success
991     */
992     function metaData(string memory _metaData) public onlyOwner returns(bool) {
993         emit MetaData(_metaData);
994         return true;
995     }
996 
997 
998 }
999 
1000 // File: @daostack/arc/contracts/globalConstraints/GlobalConstraintInterface.sol
1001 
1002 pragma solidity ^0.5.4;
1003 
1004 
1005 contract GlobalConstraintInterface {
1006 
1007     enum CallPhase { Pre, Post, PreAndPost }
1008 
1009     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
1010     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
1011     /**
1012      * @dev when return if this globalConstraints is pre, post or both.
1013      * @return CallPhase enum indication  Pre, Post or PreAndPost.
1014      */
1015     function when() public returns(CallPhase);
1016 }
1017 
1018 // File: @daostack/arc/contracts/controller/ControllerInterface.sol
1019 
1020 pragma solidity ^0.5.4;
1021 
1022 
1023 
1024 /**
1025  * @title Controller contract
1026  * @dev A controller controls the organizations tokens ,reputation and avatar.
1027  * It is subject to a set of schemes and constraints that determine its behavior.
1028  * Each scheme has it own parameters and operation permissions.
1029  */
1030 interface ControllerInterface {
1031 
1032     /**
1033      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1034      * @param  _amount amount of reputation to mint
1035      * @param _to beneficiary address
1036      * @return bool which represents a success
1037     */
1038     function mintReputation(uint256 _amount, address _to, address _avatar)
1039     external
1040     returns(bool);
1041 
1042     /**
1043      * @dev Burns `_amount` of reputation from `_from`
1044      * @param _amount amount of reputation to burn
1045      * @param _from The address that will lose the reputation
1046      * @return bool which represents a success
1047      */
1048     function burnReputation(uint256 _amount, address _from, address _avatar)
1049     external
1050     returns(bool);
1051 
1052     /**
1053      * @dev mint tokens .
1054      * @param  _amount amount of token to mint
1055      * @param _beneficiary beneficiary address
1056      * @param _avatar address
1057      * @return bool which represents a success
1058      */
1059     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
1060     external
1061     returns(bool);
1062 
1063   /**
1064    * @dev register or update a scheme
1065    * @param _scheme the address of the scheme
1066    * @param _paramsHash a hashed configuration of the usage of the scheme
1067    * @param _permissions the permissions the new scheme will have
1068    * @param _avatar address
1069    * @return bool which represents a success
1070    */
1071     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
1072     external
1073     returns(bool);
1074 
1075     /**
1076      * @dev unregister a scheme
1077      * @param _avatar address
1078      * @param _scheme the address of the scheme
1079      * @return bool which represents a success
1080      */
1081     function unregisterScheme(address _scheme, address _avatar)
1082     external
1083     returns(bool);
1084 
1085     /**
1086      * @dev unregister the caller's scheme
1087      * @param _avatar address
1088      * @return bool which represents a success
1089      */
1090     function unregisterSelf(address _avatar) external returns(bool);
1091 
1092     /**
1093      * @dev add or update Global Constraint
1094      * @param _globalConstraint the address of the global constraint to be added.
1095      * @param _params the constraint parameters hash.
1096      * @param _avatar the avatar of the organization
1097      * @return bool which represents a success
1098      */
1099     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
1100     external returns(bool);
1101 
1102     /**
1103      * @dev remove Global Constraint
1104      * @param _globalConstraint the address of the global constraint to be remove.
1105      * @param _avatar the organization avatar.
1106      * @return bool which represents a success
1107      */
1108     function removeGlobalConstraint (address _globalConstraint, address _avatar)
1109     external  returns(bool);
1110 
1111   /**
1112     * @dev upgrade the Controller
1113     *      The function will trigger an event 'UpgradeController'.
1114     * @param  _newController the address of the new controller.
1115     * @param _avatar address
1116     * @return bool which represents a success
1117     */
1118     function upgradeController(address _newController, Avatar _avatar)
1119     external returns(bool);
1120 
1121     /**
1122     * @dev perform a generic call to an arbitrary contract
1123     * @param _contract  the contract's address to call
1124     * @param _data ABI-encoded contract call to call `_contract` address.
1125     * @param _avatar the controller's avatar address
1126     * @param _value value (ETH) to transfer with the transaction
1127     * @return bool -success
1128     *         bytes  - the return value of the called _contract's function.
1129     */
1130     function genericCall(address _contract, bytes calldata _data, Avatar _avatar, uint256 _value)
1131     external
1132     returns(bool, bytes memory);
1133 
1134   /**
1135    * @dev send some ether
1136    * @param _amountInWei the amount of ether (in Wei) to send
1137    * @param _to address of the beneficiary
1138    * @param _avatar address
1139    * @return bool which represents a success
1140    */
1141     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
1142     external returns(bool);
1143 
1144     /**
1145     * @dev send some amount of arbitrary ERC20 Tokens
1146     * @param _externalToken the address of the Token Contract
1147     * @param _to address of the beneficiary
1148     * @param _value the amount of ether (in Wei) to send
1149     * @param _avatar address
1150     * @return bool which represents a success
1151     */
1152     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1153     external
1154     returns(bool);
1155 
1156     /**
1157     * @dev transfer token "from" address "to" address
1158     *      One must to approve the amount of tokens which can be spend from the
1159     *      "from" account.This can be done using externalTokenApprove.
1160     * @param _externalToken the address of the Token Contract
1161     * @param _from address of the account to send from
1162     * @param _to address of the beneficiary
1163     * @param _value the amount of ether (in Wei) to send
1164     * @param _avatar address
1165     * @return bool which represents a success
1166     */
1167     function externalTokenTransferFrom(
1168     IERC20 _externalToken,
1169     address _from,
1170     address _to,
1171     uint256 _value,
1172     Avatar _avatar)
1173     external
1174     returns(bool);
1175 
1176     /**
1177     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1178     *      on behalf of msg.sender.
1179     * @param _externalToken the address of the Token Contract
1180     * @param _spender address
1181     * @param _value the amount of ether (in Wei) which the approval is referring to.
1182     * @return bool which represents a success
1183     */
1184     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1185     external
1186     returns(bool);
1187 
1188     /**
1189     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1190     * @param _metaData a string representing a hash of the meta data
1191     * @param _avatar Avatar
1192     * @return bool which represents a success
1193     */
1194     function metaData(string calldata _metaData, Avatar _avatar) external returns(bool);
1195 
1196     /**
1197      * @dev getNativeReputation
1198      * @param _avatar the organization avatar.
1199      * @return organization native reputation
1200      */
1201     function getNativeReputation(address _avatar)
1202     external
1203     view
1204     returns(address);
1205 
1206     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
1207 
1208     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1209 
1210     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1211 
1212     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1213 
1214     /**
1215      * @dev globalConstraintsCount return the global constraint pre and post count
1216      * @return uint256 globalConstraintsPre count.
1217      * @return uint256 globalConstraintsPost count.
1218      */
1219     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1220 
1221     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1222 }
1223 
1224 // File: contracts/dao/schemes/SchemeGuard.sol
1225 
1226 pragma solidity >0.5.4;
1227 
1228 
1229 
1230 
1231 /* @dev abstract contract for ensuring that schemes have been registered properly
1232  * Allows setting zero Avatar in situations where the Avatar hasn't been created yet
1233  */
1234 contract SchemeGuard is Ownable {
1235     Avatar avatar;
1236     ControllerInterface internal controller = ControllerInterface(0);
1237 
1238     /** @dev Constructor. only sets controller if given avatar is not null.
1239      * @param _avatar The avatar of the DAO.
1240      */
1241     constructor(Avatar _avatar) public {
1242         avatar = _avatar;
1243 
1244         if (avatar != Avatar(0)) {
1245             controller = ControllerInterface(avatar.owner());
1246         }
1247     }
1248 
1249     /** @dev modifier to check if caller is avatar
1250      */
1251     modifier onlyAvatar() {
1252         require(address(avatar) == msg.sender, "only Avatar can call this method");
1253         _;
1254     }
1255 
1256     /** @dev modifier to check if scheme is registered
1257      */
1258     modifier onlyRegistered() {
1259         require(isRegistered(), "Scheme is not registered");
1260         _;
1261     }
1262 
1263     /** @dev modifier to check if scheme is not registered
1264      */
1265     modifier onlyNotRegistered() {
1266         require(!isRegistered(), "Scheme is registered");
1267         _;
1268     }
1269 
1270     /** @dev modifier to check if call is a scheme that is registered
1271      */
1272     modifier onlyRegisteredCaller() {
1273         require(isRegistered(msg.sender), "Calling scheme is not registered");
1274         _;
1275     }
1276 
1277     /** @dev Function to set a new avatar and controller for scheme
1278      * can only be done by owner of scheme
1279      */
1280     function setAvatar(Avatar _avatar) public onlyOwner {
1281         avatar = _avatar;
1282         controller = ControllerInterface(avatar.owner());
1283     }
1284 
1285     /** @dev function to see if an avatar has been set and if this scheme is registered
1286      * @return true if scheme is registered
1287      */
1288     function isRegistered() public view returns (bool) {
1289         return isRegistered(address(this));
1290     }
1291 
1292     /** @dev function to see if an avatar has been set and if this scheme is registered
1293      * @return true if scheme is registered
1294      */
1295     function isRegistered(address scheme) public view returns (bool) {
1296         require(avatar != Avatar(0), "Avatar is not set");
1297 
1298         if (!(controller.isSchemeRegistered(scheme, address(avatar)))) {
1299             return false;
1300         }
1301         return true;
1302     }
1303 }
1304 
1305 // File: contracts/identity/IdentityAdminRole.sol
1306 
1307 pragma solidity >0.5.4;
1308 
1309 
1310 
1311 /**
1312  * @title Contract managing the identity admin role
1313  */
1314 contract IdentityAdminRole is Ownable {
1315     using Roles for Roles.Role;
1316 
1317     event IdentityAdminAdded(address indexed account);
1318     event IdentityAdminRemoved(address indexed account);
1319 
1320     Roles.Role private IdentityAdmins;
1321 
1322     /* @dev constructor. Adds caller as an admin
1323      */
1324     constructor() internal {
1325         _addIdentityAdmin(msg.sender);
1326     }
1327 
1328     /* @dev Modifier to check if caller is an admin
1329      */
1330     modifier onlyIdentityAdmin() {
1331         require(isIdentityAdmin(msg.sender), "not IdentityAdmin");
1332         _;
1333     }
1334 
1335     /**
1336      * @dev Checks if account is identity admin
1337      * @param account Account to check
1338      * @return Boolean indicating if account is identity admin
1339      */
1340     function isIdentityAdmin(address account) public view returns (bool) {
1341         return IdentityAdmins.has(account);
1342     }
1343 
1344     /**
1345      * @dev Adds a identity admin account. Is only callable by owner.
1346      * @param account Address to be added
1347      * @return true if successful
1348      */
1349     function addIdentityAdmin(address account) public onlyOwner returns (bool) {
1350         _addIdentityAdmin(account);
1351         return true;
1352     }
1353 
1354     /**
1355      * @dev Removes a identity admin account. Is only callable by owner.
1356      * @param account Address to be removed
1357      * @return true if successful
1358      */
1359     function removeIdentityAdmin(address account) public onlyOwner returns (bool) {
1360         _removeIdentityAdmin(account);
1361         return true;
1362     }
1363 
1364     /**
1365      * @dev Allows an admin to renounce their role
1366      */
1367     function renounceIdentityAdmin() public {
1368         _removeIdentityAdmin(msg.sender);
1369     }
1370 
1371     /**
1372      * @dev Internal implementation of addIdentityAdmin
1373      */
1374     function _addIdentityAdmin(address account) internal {
1375         IdentityAdmins.add(account);
1376         emit IdentityAdminAdded(account);
1377     }
1378 
1379     /**
1380      * @dev Internal implementation of removeIdentityAdmin
1381      */
1382     function _removeIdentityAdmin(address account) internal {
1383         IdentityAdmins.remove(account);
1384         emit IdentityAdminRemoved(account);
1385     }
1386 }
1387 
1388 // File: contracts/identity/Identity.sol
1389 
1390 pragma solidity >0.5.4;
1391 
1392 
1393 
1394 
1395 
1396 
1397 
1398 /* @title Identity contract responsible for whitelisting
1399  * and keeping track of amount of whitelisted users
1400  */
1401 contract Identity is IdentityAdminRole, SchemeGuard, Pausable {
1402     using Roles for Roles.Role;
1403     using SafeMath for uint256;
1404 
1405     Roles.Role private blacklist;
1406     Roles.Role private whitelist;
1407     Roles.Role private contracts;
1408 
1409     uint256 public whitelistedCount = 0;
1410     uint256 public whitelistedContracts = 0;
1411     uint256 public authenticationPeriod = 14;
1412 
1413     mapping(address => uint256) public dateAuthenticated;
1414     mapping(address => uint256) public dateAdded;
1415 
1416     mapping(address => string) public addrToDID;
1417     mapping(bytes32 => address) public didHashToAddress;
1418 
1419     event BlacklistAdded(address indexed account);
1420     event BlacklistRemoved(address indexed account);
1421 
1422     event WhitelistedAdded(address indexed account);
1423     event WhitelistedRemoved(address indexed account);
1424 
1425     event ContractAdded(address indexed account);
1426     event ContractRemoved(address indexed account);
1427 
1428     constructor() public SchemeGuard(Avatar(0)) {}
1429 
1430     /* @dev Sets a new value for authenticationPeriod.
1431      * Can only be called by Identity Administrators.
1432      * @param period new value for authenticationPeriod
1433      */
1434     function setAuthenticationPeriod(uint256 period) public onlyOwner whenNotPaused {
1435         authenticationPeriod = period;
1436     }
1437 
1438     /* @dev Sets the authentication date of `account`
1439      * to the current time.
1440      * Can only be called by Identity Administrators.
1441      * @param account address to change its auth date
1442      */
1443     function authenticate(address account)
1444         public
1445         onlyRegistered
1446         onlyIdentityAdmin
1447         whenNotPaused
1448     {
1449         dateAuthenticated[account] = now;
1450     }
1451 
1452     /* @dev Adds an address as whitelisted.
1453      * Can only be called by Identity Administrators.
1454      * @param account address to add as whitelisted
1455      */
1456     function addWhitelisted(address account)
1457         public
1458         onlyRegistered
1459         onlyIdentityAdmin
1460         whenNotPaused
1461     {
1462         _addWhitelisted(account);
1463     }
1464 
1465     /* @dev Adds an address as whitelisted under a specific ID
1466      * @param account The address to add
1467      * @param did the ID to add account under
1468      */
1469     function addWhitelistedWithDID(address account, string memory did)
1470         public
1471         onlyRegistered
1472         onlyIdentityAdmin
1473         whenNotPaused
1474     {
1475         _addWhitelistedWithDID(account, did);
1476     }
1477 
1478     /* @dev Removes an address as whitelisted.
1479      * Can only be called by Identity Administrators.
1480      * @param account address to remove as whitelisted
1481      */
1482     function removeWhitelisted(address account)
1483         public
1484         onlyRegistered
1485         onlyIdentityAdmin
1486         whenNotPaused
1487     {
1488         _removeWhitelisted(account);
1489     }
1490 
1491     /* @dev Renounces message sender from whitelisted
1492      */
1493     function renounceWhitelisted() public whenNotPaused {
1494         _removeWhitelisted(msg.sender);
1495     }
1496 
1497     /* @dev Returns true if given address has been added to whitelist
1498      * @param account the address to check
1499      * @return a bool indicating weather the address is present in whitelist
1500      */
1501     function isWhitelisted(address account) public view returns (bool) {
1502         uint256 daysSinceAuthentication = (now.sub(dateAuthenticated[account])) / 1 days;
1503         return
1504             (daysSinceAuthentication <= authenticationPeriod) && whitelist.has(account);
1505     }
1506 
1507     /* @dev Function that gives the date the given user was added
1508      * @param account The address to check
1509      * @return The date the address was added
1510      */
1511     function lastAuthenticated(address account) public view returns (uint256) {
1512         return dateAuthenticated[account];
1513     }
1514 
1515     // /**
1516     //  *
1517     //  * @dev Function to transfer whitelisted privilege to another address
1518     //  * relocates did of sender to give address
1519     //  * @param account The address to transfer to
1520     //  */
1521     // function transferAccount(address account) public whenNotPaused {
1522     //     ERC20 token = avatar.nativeToken();
1523     //     require(!isBlacklisted(account), "Cannot transfer to blacklisted");
1524     //     require(token.balanceOf(account) == 0, "Account is already in use");
1525     //     require(isWhitelisted(msg.sender), "Requester need to be whitelisted");
1526 
1527     //     require(
1528     //         keccak256(bytes(addrToDID[account])) == keccak256(bytes("")),
1529     //         "address already has DID"
1530     //     );
1531 
1532     //     string memory did = addrToDID[msg.sender];
1533     //     bytes32 pHash = keccak256(bytes(did));
1534 
1535     //     uint256 balance = token.balanceOf(msg.sender);
1536     //     token.transferFrom(msg.sender, account, balance);
1537     //     _removeWhitelisted(msg.sender);
1538     //     _addWhitelisted(account);
1539     //     addrToDID[account] = did;
1540     //     didHashToAddress[pHash] = account;
1541     // }
1542 
1543     /* @dev Adds an address to blacklist.
1544      * Can only be called by Identity Administrators.
1545      * @param account address to add as blacklisted
1546      */
1547     function addBlacklisted(address account)
1548         public
1549         onlyRegistered
1550         onlyIdentityAdmin
1551         whenNotPaused
1552     {
1553         blacklist.add(account);
1554         emit BlacklistAdded(account);
1555     }
1556 
1557     /* @dev Removes an address from blacklist
1558      * Can only be called by Identity Administrators.
1559      * @param account address to remove as blacklisted
1560      */
1561     function removeBlacklisted(address account)
1562         public
1563         onlyRegistered
1564         onlyIdentityAdmin
1565         whenNotPaused
1566     {
1567         blacklist.remove(account);
1568         emit BlacklistRemoved(account);
1569     }
1570 
1571     /* @dev Function to add a Contract to list of contracts
1572      * @param account The address to add
1573      */
1574     function addContract(address account)
1575         public
1576         onlyRegistered
1577         onlyIdentityAdmin
1578         whenNotPaused
1579     {
1580         require(isContract(account), "Given address is not a contract");
1581         contracts.add(account);
1582         _addWhitelisted(account);
1583 
1584         emit ContractAdded(account);
1585     }
1586 
1587     /* @dev Function to remove a Contract from list of contracts
1588      * @param account The address to add
1589      */
1590     function removeContract(address account)
1591         public
1592         onlyRegistered
1593         onlyIdentityAdmin
1594         whenNotPaused
1595     {
1596         contracts.remove(account);
1597         _removeWhitelisted(account);
1598 
1599         emit ContractRemoved(account);
1600     }
1601 
1602     /* @dev Function to check if given contract is on list of contracts.
1603      * @param address to check
1604      * @return a bool indicating if address is on list of contracts
1605      */
1606     function isDAOContract(address account) public view returns (bool) {
1607         return contracts.has(account);
1608     }
1609 
1610     /* @dev Internal function to add to whitelisted
1611      * @param account the address to add
1612      */
1613     function _addWhitelisted(address account) internal {
1614         whitelist.add(account);
1615 
1616         whitelistedCount += 1;
1617         dateAdded[account] = now;
1618         dateAuthenticated[account] = now;
1619 
1620         if (isContract(account)) {
1621             whitelistedContracts += 1;
1622         }
1623 
1624         emit WhitelistedAdded(account);
1625     }
1626 
1627     /* @dev Internal whitelisting with did function.
1628      * @param account the address to add
1629      * @param did the id to register account under
1630      */
1631     function _addWhitelistedWithDID(address account, string memory did) internal {
1632         bytes32 pHash = keccak256(bytes(did));
1633         require(didHashToAddress[pHash] == address(0), "DID already registered");
1634 
1635         addrToDID[account] = did;
1636         didHashToAddress[pHash] = account;
1637 
1638         _addWhitelisted(account);
1639     }
1640 
1641     /* @dev Internal function to remove from whitelisted
1642      * @param account the address to add
1643      */
1644     function _removeWhitelisted(address account) internal {
1645         whitelist.remove(account);
1646 
1647         whitelistedCount -= 1;
1648         delete dateAuthenticated[account];
1649 
1650         if (isContract(account)) {
1651             whitelistedContracts -= 1;
1652         }
1653 
1654         string memory did = addrToDID[account];
1655         bytes32 pHash = keccak256(bytes(did));
1656 
1657         delete dateAuthenticated[account];
1658         delete addrToDID[account];
1659         delete didHashToAddress[pHash];
1660 
1661         emit WhitelistedRemoved(account);
1662     }
1663 
1664     /* @dev Returns true if given address has been added to the blacklist
1665      * @param account the address to check
1666      * @return a bool indicating weather the address is present in the blacklist
1667      */
1668     function isBlacklisted(address account) public view returns (bool) {
1669         return blacklist.has(account);
1670     }
1671 
1672     /* @dev Function to see if given address is a contract
1673      * @return true if address is a contract
1674      */
1675     function isContract(address _addr) internal view returns (bool) {
1676         uint256 length;
1677         assembly {
1678             length := extcodesize(_addr)
1679         }
1680         return length > 0;
1681     }
1682 }
1683 
1684 // File: contracts/identity/IdentityGuard.sol
1685 
1686 pragma solidity >0.5.4;
1687 
1688 
1689 
1690 /* @title The IdentityGuard contract
1691  * @dev Contract containing an identity and
1692  * modifiers to ensure proper access
1693  */
1694 contract IdentityGuard is Ownable {
1695     Identity public identity;
1696 
1697     /* @dev Constructor. Checks if identity is a zero address
1698      * @param _identity The identity contract.
1699      */
1700     constructor(Identity _identity) public {
1701         require(_identity != Identity(0), "Supplied identity is null");
1702         identity = _identity;
1703     }
1704 
1705     /* @dev Modifier that requires the sender to be not blacklisted
1706      */
1707     modifier onlyNotBlacklisted() {
1708         require(!identity.isBlacklisted(msg.sender), "Caller is blacklisted");
1709         _;
1710     }
1711 
1712     /* @dev Modifier that requires the given address to be not blacklisted
1713      * @param _account The address to be checked
1714      */
1715     modifier requireNotBlacklisted(address _account) {
1716         require(!identity.isBlacklisted(_account), "Receiver is blacklisted");
1717         _;
1718     }
1719 
1720     /* @dev Modifier that requires the sender to be whitelisted
1721      */
1722     modifier onlyWhitelisted() {
1723         require(identity.isWhitelisted(msg.sender), "is not whitelisted");
1724         _;
1725     }
1726 
1727     /* @dev Modifier that requires the given address to be whitelisted
1728      * @param _account the given address
1729      */
1730     modifier requireWhitelisted(address _account) {
1731         require(identity.isWhitelisted(_account), "is not whitelisted");
1732         _;
1733     }
1734 
1735     /* @dev Modifier that requires the sender to be an approved DAO contract
1736      */
1737     modifier onlyDAOContract() {
1738         require(identity.isDAOContract(msg.sender), "is not whitelisted contract");
1739         _;
1740     }
1741 
1742     /* @dev Modifier that requires the given address to be whitelisted
1743      * @param _account the given address
1744      */
1745     modifier requireDAOContract(address _contract) {
1746         require(identity.isDAOContract(_contract), "is not whitelisted contract");
1747         _;
1748     }
1749 
1750     /* @dev Modifier that requires the sender to have been whitelisted
1751      * before or on the given date
1752      * @param date The time sender must have been added before
1753      */
1754     modifier onlyAddedBefore(uint256 date) {
1755         require(
1756             identity.lastAuthenticated(msg.sender) <= date,
1757             "Was not added within period"
1758         );
1759         _;
1760     }
1761 
1762     /* @dev Modifier that requires sender to be an identity admin
1763      */
1764     modifier onlyIdentityAdmin() {
1765         require(identity.isIdentityAdmin(msg.sender), "not IdentityAdmin");
1766         _;
1767     }
1768 
1769     /* @dev Allows owner to set a new identity contract if
1770      * the given identity contract has been registered as a scheme
1771      */
1772     function setIdentity(Identity _identity) public onlyOwner {
1773         require(_identity.isRegistered(), "Identity is not registered");
1774         identity = _identity;
1775     }
1776 }
1777 
1778 // File: contracts/dao/schemes/FeeFormula.sol
1779 
1780 pragma solidity >0.5.4;
1781 
1782 
1783 
1784 
1785 /**
1786  * @title Fee formula abstract contract
1787  */
1788 contract AbstractFees is SchemeGuard {
1789     constructor() public SchemeGuard(Avatar(0)) {}
1790 
1791     function getTxFees(
1792         uint256 _value,
1793         address _sender,
1794         address _recipient
1795     ) public view returns (uint256, bool);
1796 }
1797 
1798 /**
1799  * @title Fee formula contract
1800  * contract that provides a function to calculate
1801  * fees as a percentage of any given value
1802  */
1803 contract FeeFormula is AbstractFees {
1804     using SafeMath for uint256;
1805 
1806     uint256 public percentage;
1807     bool public constant senderPays = false;
1808 
1809     /**
1810      * @dev Constructor. Requires the given percentage parameter
1811      * to be less than 100.
1812      * @param _percentage the percentage to calculate fees of
1813      */
1814     constructor(uint256 _percentage) public {
1815         require(_percentage < 100, "Percentage should be <100");
1816         percentage = _percentage;
1817     }
1818 
1819     /**  @dev calculates the fee of given value.
1820      * @param _value the value of the transaction to calculate fees from
1821      * @param _sender address sending.
1822      *  @param _recipient address receiving.
1823      * @return the transactional fee for given value
1824      */
1825     function getTxFees(
1826         uint256 _value,
1827         address _sender,
1828         address _recipient
1829     ) public view returns (uint256, bool) {
1830         return (_value.mul(percentage).div(100), senderPays);
1831     }
1832 }
1833 
1834 // File: contracts/dao/schemes/FormulaHolder.sol
1835 
1836 pragma solidity >0.5.4;
1837 
1838 
1839 
1840 /* @title Contract in charge of setting registered fee formula schemes to contract
1841  */
1842 contract FormulaHolder is Ownable {
1843     AbstractFees public formula;
1844 
1845     /* @dev Constructor. Requires that given formula is a valid contract.
1846      * @param _formula The fee formula contract.
1847      */
1848     constructor(AbstractFees _formula) public {
1849         require(_formula != AbstractFees(0), "Supplied formula is null");
1850         formula = _formula;
1851     }
1852 
1853     /* @dev Sets the given fee formula contract. Is only callable by owner.
1854      * Reverts if formula has not been registered by DAO.
1855      * @param _formula the new fee formula scheme
1856      */
1857     function setFormula(AbstractFees _formula) public onlyOwner {
1858         _formula.isRegistered();
1859         formula = _formula;
1860     }
1861 }
1862 
1863 // File: contracts/token/ERC677/ERC677.sol
1864 
1865 pragma solidity >0.5.4;
1866 
1867 /* @title ERC677 interface
1868  */
1869 interface ERC677 {
1870     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
1871 
1872     function transferAndCall(
1873         address,
1874         uint256,
1875         bytes calldata
1876     ) external returns (bool);
1877 }
1878 
1879 // File: contracts/token/ERC677/ERC677Receiver.sol
1880 
1881 pragma solidity >0.5.4;
1882 
1883 /* @title ERC677Receiver interface
1884  */
1885 interface ERC677Receiver {
1886     function onTokenTransfer(
1887         address _from,
1888         uint256 _value,
1889         bytes calldata _data
1890     ) external returns (bool);
1891 }
1892 
1893 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
1894 
1895 pragma solidity ^0.5.0;
1896 
1897 
1898 
1899 /**
1900  * @title Pausable token
1901  * @dev ERC20 modified with pausable transfers.
1902  **/
1903 contract ERC20Pausable is ERC20, Pausable {
1904     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
1905         return super.transfer(to, value);
1906     }
1907 
1908     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
1909         return super.transferFrom(from, to, value);
1910     }
1911 
1912     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
1913         return super.approve(spender, value);
1914     }
1915 
1916     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
1917         return super.increaseAllowance(spender, addedValue);
1918     }
1919 
1920     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
1921         return super.decreaseAllowance(spender, subtractedValue);
1922     }
1923 }
1924 
1925 // File: contracts/token/ERC677Token.sol
1926 
1927 pragma solidity >0.5.4;
1928 
1929 
1930 
1931 
1932 
1933 /* @title ERC677Token contract.
1934  */
1935 contract ERC677Token is ERC677, DAOToken, ERC20Pausable {
1936     constructor(
1937         string memory _name,
1938         string memory _symbol,
1939         uint256 _cap
1940     ) public DAOToken(_name, _symbol, _cap) {}
1941 
1942     /**
1943      * @dev transfer token to a contract address with additional data if the recipient is a contact.
1944      * @param _to The address to transfer to.
1945      * @param _value The amount to be transferred.
1946      * @param _data The extra data to be passed to the receiving contract.
1947      * @return true if transfer is successful
1948      */
1949     function _transferAndCall(
1950         address _to,
1951         uint256 _value,
1952         bytes memory _data
1953     ) internal whenNotPaused returns (bool) {
1954         bool res = super.transfer(_to, _value);
1955         emit Transfer(msg.sender, _to, _value, _data);
1956 
1957         if (isContract(_to)) {
1958             require(contractFallback(_to, _value, _data), "Contract fallback failed");
1959         }
1960         return res;
1961     }
1962 
1963     /* @dev Contract fallback function. Is called if transferAndCall is called
1964      * to a contract
1965      */
1966     function contractFallback(
1967         address _to,
1968         uint256 _value,
1969         bytes memory _data
1970     ) private returns (bool) {
1971         ERC677Receiver receiver = ERC677Receiver(_to);
1972         require(
1973             receiver.onTokenTransfer(msg.sender, _value, _data),
1974             "Contract Fallback failed"
1975         );
1976         return true;
1977     }
1978 
1979     /* @dev Function to check if given address is a contract
1980      * @param _addr Address to check
1981      * @return true if given address is a contract
1982      */
1983 
1984     function isContract(address _addr) internal view returns (bool) {
1985         uint256 length;
1986         assembly {
1987             length := extcodesize(_addr)
1988         }
1989         return length > 0;
1990     }
1991 }
1992 
1993 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1994 
1995 pragma solidity ^0.5.0;
1996 
1997 
1998 contract MinterRole {
1999     using Roles for Roles.Role;
2000 
2001     event MinterAdded(address indexed account);
2002     event MinterRemoved(address indexed account);
2003 
2004     Roles.Role private _minters;
2005 
2006     constructor () internal {
2007         _addMinter(msg.sender);
2008     }
2009 
2010     modifier onlyMinter() {
2011         require(isMinter(msg.sender));
2012         _;
2013     }
2014 
2015     function isMinter(address account) public view returns (bool) {
2016         return _minters.has(account);
2017     }
2018 
2019     function addMinter(address account) public onlyMinter {
2020         _addMinter(account);
2021     }
2022 
2023     function renounceMinter() public {
2024         _removeMinter(msg.sender);
2025     }
2026 
2027     function _addMinter(address account) internal {
2028         _minters.add(account);
2029         emit MinterAdded(account);
2030     }
2031 
2032     function _removeMinter(address account) internal {
2033         _minters.remove(account);
2034         emit MinterRemoved(account);
2035     }
2036 }
2037 
2038 // File: contracts/token/ERC677BridgeToken.sol
2039 
2040 pragma solidity >0.5.4;
2041 
2042 
2043 
2044 contract ERC677BridgeToken is ERC677Token, MinterRole {
2045     address public bridgeContract;
2046 
2047     constructor(
2048         string memory _name,
2049         string memory _symbol,
2050         uint256 _cap
2051     ) public ERC677Token(_name, _symbol, _cap) {}
2052 
2053     function setBridgeContract(address _bridgeContract) public onlyMinter {
2054         require(
2055             _bridgeContract != address(0) && isContract(_bridgeContract),
2056             "Invalid bridge contract"
2057         );
2058         bridgeContract = _bridgeContract;
2059     }
2060 }
2061 
2062 // File: contracts/token/GoodDollar.sol
2063 
2064 pragma solidity >0.5.4;
2065 
2066 
2067 
2068 
2069 /**
2070  * @title The GoodDollar ERC677 token contract
2071  */
2072 contract GoodDollar is ERC677BridgeToken, IdentityGuard, FormulaHolder {
2073     address feeRecipient;
2074 
2075     // Overrides hard-coded decimal in DAOToken
2076     uint256 public constant decimals = 2;
2077 
2078     /**
2079      * @dev constructor
2080      * @param _name The name of the token
2081      * @param _symbol The symbol of the token
2082      * @param _cap the cap of the token. no cap if 0
2083      * @param _formula the fee formula contract
2084      * @param _identity the identity contract
2085      * @param _feeRecipient the address that receives transaction fees
2086      */
2087     constructor(
2088         string memory _name,
2089         string memory _symbol,
2090         uint256 _cap,
2091         AbstractFees _formula,
2092         Identity _identity,
2093         address _feeRecipient
2094     )
2095         public
2096         ERC677BridgeToken(_name, _symbol, _cap)
2097         IdentityGuard(_identity)
2098         FormulaHolder(_formula)
2099     {
2100         feeRecipient = _feeRecipient;
2101     }
2102 
2103     /**
2104      * @dev Processes fees from given value and sends
2105      * remainder to given address
2106      * @param to the address to be sent to
2107      * @param value the value to be processed and then
2108      * transferred
2109      * @return a boolean that indicates if the operation was successful
2110      */
2111     function transfer(address to, uint256 value) public returns (bool) {
2112         uint256 bruttoValue = processFees(msg.sender, to, value);
2113         return super.transfer(to, bruttoValue);
2114     }
2115 
2116     /**
2117      * @dev Approve the passed address to spend the specified
2118      * amount of tokens on behalf of msg.sender
2119      * @param spender The address which will spend the funds
2120      * @param value The amount of tokens to be spent
2121      * @return a boolean that indicates if the operation was successful
2122      */
2123     function approve(address spender, uint256 value) public returns (bool) {
2124         return super.approve(spender, value);
2125     }
2126 
2127     /**
2128      * @dev Transfer tokens from one address to another
2129      * @param from The address which you want to send tokens from
2130      * @param to The address which you want to transfer to
2131      * @param value the amount of tokens to be transferred
2132      * @return a boolean that indicates if the operation was successful
2133      */
2134     function transferFrom(
2135         address from,
2136         address to,
2137         uint256 value
2138     ) public returns (bool) {
2139         uint256 bruttoValue = processFees(from, to, value);
2140         return super.transferFrom(from, to, bruttoValue);
2141     }
2142 
2143     /**
2144      * @dev Processes transfer fees and calls ERC677Token transferAndCall function
2145      * @param to address to transfer to
2146      * @param value the amount to transfer
2147      * @param data The data to pass to transferAndCall
2148      * @return a bool indicating if transfer function succeeded
2149      */
2150     function transferAndCall(
2151         address to,
2152         uint256 value,
2153         bytes calldata data
2154     ) external returns (bool) {
2155         uint256 bruttoValue = processFees(msg.sender, to, value);
2156         return super._transferAndCall(to, bruttoValue, data);
2157     }
2158 
2159     /**
2160      * @dev Minting function
2161      * @param to the address that will receive the minted tokens
2162      * @param value the amount of tokens to mint
2163      * @return a boolean that indicated if the operation was successful
2164      */
2165     function mint(address to, uint256 value)
2166         public
2167         onlyMinter
2168         requireNotBlacklisted(to)
2169         returns (bool)
2170     {
2171         if (cap > 0) {
2172             require(totalSupply().add(value) <= cap, "Cannot increase supply beyond cap");
2173         }
2174         super._mint(to, value);
2175         return true;
2176     }
2177 
2178     /**
2179      * @dev Burns a specific amount of tokens.
2180      * @param value The amount of token to be burned.
2181      */
2182     function burn(uint256 value) public onlyNotBlacklisted {
2183         super.burn(value);
2184     }
2185 
2186     /**
2187      * @dev Burns a specific amount of tokens from the target address and decrements allowance
2188      * @param from address The address which you want to send tokens from
2189      * @param value uint256 The amount of token to be burned
2190      */
2191     function burnFrom(address from, uint256 value)
2192         public
2193         onlyNotBlacklisted
2194         requireNotBlacklisted(from)
2195     {
2196         super.burnFrom(from, value);
2197     }
2198 
2199     /**
2200      * @dev Increase the amount of tokens that an owner allows a spender
2201      * @param spender The address which will spend the funds
2202      * @param addedValue The amount of tokens to increase the allowance by
2203      * @return a boolean that indicated if the operation was successful
2204      */
2205     function increaseAllowance(address spender, uint256 addedValue)
2206         public
2207         returns (bool)
2208     {
2209         return super.increaseAllowance(spender, addedValue);
2210     }
2211 
2212     /**
2213      * @dev Decrease the amount of tokens that an owner allowed to a spender
2214      * @param spender The address which will spend the funds
2215      * @param subtractedValue The amount of tokens to decrease the allowance by
2216      * @return a boolean that indicated if the operation was successful
2217      */
2218     function decreaseAllowance(address spender, uint256 subtractedValue)
2219         public
2220         returns (bool)
2221     {
2222         return super.decreaseAllowance(spender, subtractedValue);
2223     }
2224 
2225     /**
2226      * @dev Gets the current transaction fees
2227      * @return an uint256 that represents
2228      * the current transaction fees
2229      */
2230     function getFees(uint256 value) public view returns (uint256, bool) {
2231         return formula.getTxFees(value, address(0), address(0));
2232     }
2233 
2234     /**
2235      * @dev Gets the current transaction fees
2236      * @return an uint256 that represents
2237      * the current transaction fees
2238      */
2239     function getFees(
2240         uint256 value,
2241         address sender,
2242         address recipient
2243     ) public view returns (uint256, bool) {
2244         return formula.getTxFees(value, sender, recipient);
2245     }
2246 
2247     /**
2248      * @dev Sets the address that receives the transactional fees.
2249      * can only be called by owner
2250      * @param _feeRecipient The new address to receive transactional fees
2251      */
2252     function setFeeRecipient(address _feeRecipient) public onlyOwner {
2253         feeRecipient = _feeRecipient;
2254     }
2255 
2256     /**
2257      * @dev Sends transactional fees to feeRecipient address from given address
2258      * @param account The account that sends the fees
2259      * @param value The amount to subtract fees from
2260      * @return an uint256 that represents the given value minus the transactional fees
2261      */
2262     function processFees(
2263         address account,
2264         address recipient,
2265         uint256 value
2266     ) internal returns (uint256) {
2267         (uint256 txFees, bool senderPays) = getFees(value, account, recipient);
2268         if (txFees > 0 && !identity.isDAOContract(msg.sender)) {
2269             require(
2270                 senderPays == false || value.add(txFees) <= balanceOf(account),
2271                 "Not enough balance to pay TX fee"
2272             );
2273             if (account == msg.sender) {
2274                 super.transfer(feeRecipient, txFees);
2275             } else {
2276                 super.transferFrom(account, feeRecipient, txFees);
2277             }
2278 
2279             return senderPays ? value : value.sub(txFees);
2280         }
2281         return value;
2282     }
2283 }