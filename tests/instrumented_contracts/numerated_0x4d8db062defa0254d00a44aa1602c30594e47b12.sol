1 
2 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
3 
4 pragma solidity ^0.5.0;
5 
6 /**
7  * @title SafeMath
8  * @dev Unsigned math operations with safety checks that revert on error
9  */
10 library SafeMath {
11     /**
12     * @dev Multiplies two unsigned integers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Solidity only automatically asserts when dividing by 0
33         require(b > 0);
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     /**
41     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51     * @dev Adds two unsigned integers, reverts on overflow.
52     */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a);
56 
57         return c;
58     }
59 
60     /**
61     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
62     * reverts when dividing by zero.
63     */
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0);
66         return a % b;
67     }
68 }
69 
70 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
71 
72 pragma solidity ^0.5.0;
73 
74 /**
75  * @title Ownable
76  * @dev The Ownable contract has an owner address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Ownable {
80     address private _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     /**
85      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86      * account.
87      */
88     constructor () internal {
89         _owner = msg.sender;
90         emit OwnershipTransferred(address(0), _owner);
91     }
92 
93     /**
94      * @return the address of the owner.
95      */
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(isOwner());
105         _;
106     }
107 
108     /**
109      * @return true if `msg.sender` is the owner of the contract.
110      */
111     function isOwner() public view returns (bool) {
112         return msg.sender == _owner;
113     }
114 
115     /**
116      * @dev Allows the current owner to relinquish control of the contract.
117      * @notice Renouncing to ownership will leave the contract without an owner.
118      * It will not be possible to call the functions with the `onlyOwner`
119      * modifier anymore.
120      */
121     function renounceOwnership() public onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 
126     /**
127      * @dev Allows the current owner to transfer control of the contract to a newOwner.
128      * @param newOwner The address to transfer ownership to.
129      */
130     function transferOwnership(address newOwner) public onlyOwner {
131         _transferOwnership(newOwner);
132     }
133 
134     /**
135      * @dev Transfers control of the contract to a newOwner.
136      * @param newOwner The address to transfer ownership to.
137      */
138     function _transferOwnership(address newOwner) internal {
139         require(newOwner != address(0));
140         emit OwnershipTransferred(_owner, newOwner);
141         _owner = newOwner;
142     }
143 }
144 
145 // File: @daostack/infra/contracts/Reputation.sol
146 
147 pragma solidity ^0.5.4;
148 
149 
150 
151 /**
152  * @title Reputation system
153  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
154  * A reputation is use to assign influence measure to a DAO'S peers.
155  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
156  * The Reputation contract maintain a map of address to reputation value.
157  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
158  */
159 
160 contract Reputation is Ownable {
161 
162     uint8 public decimals = 18;             //Number of decimals of the smallest unit
163     // Event indicating minting of reputation to an address.
164     event Mint(address indexed _to, uint256 _amount);
165     // Event indicating burning of reputation for an address.
166     event Burn(address indexed _from, uint256 _amount);
167 
168       /// @dev `Checkpoint` is the structure that attaches a block number to a
169       ///  given value, the block number attached is the one that last changed the
170       ///  value
171     struct Checkpoint {
172 
173     // `fromBlock` is the block number that the value was generated from
174         uint128 fromBlock;
175 
176           // `value` is the amount of reputation at a specific block number
177         uint128 value;
178     }
179 
180       // `balances` is the map that tracks the balance of each address, in this
181       //  contract when the balance changes the block number that the change
182       //  occurred is also included in the map
183     mapping (address => Checkpoint[]) balances;
184 
185       // Tracks the history of the `totalSupply` of the reputation
186     Checkpoint[] totalSupplyHistory;
187 
188     /// @notice Constructor to create a Reputation
189     constructor(
190     ) public
191     {
192     }
193 
194     /// @dev This function makes it easy to get the total number of reputation
195     /// @return The total number of reputation
196     function totalSupply() public view returns (uint256) {
197         return totalSupplyAt(block.number);
198     }
199 
200   ////////////////
201   // Query balance and totalSupply in History
202   ////////////////
203     /**
204     * @dev return the reputation amount of a given owner
205     * @param _owner an address of the owner which we want to get his reputation
206     */
207     function balanceOf(address _owner) public view returns (uint256 balance) {
208         return balanceOfAt(_owner, block.number);
209     }
210 
211       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
212       /// @param _owner The address from which the balance will be retrieved
213       /// @param _blockNumber The block number when the balance is queried
214       /// @return The balance at `_blockNumber`
215     function balanceOfAt(address _owner, uint256 _blockNumber)
216     public view returns (uint256)
217     {
218         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
219             return 0;
220           // This will return the expected balance during normal situations
221         } else {
222             return getValueAt(balances[_owner], _blockNumber);
223         }
224     }
225 
226       /// @notice Total amount of reputation at a specific `_blockNumber`.
227       /// @param _blockNumber The block number when the totalSupply is queried
228       /// @return The total amount of reputation at `_blockNumber`
229     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
230         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
231             return 0;
232           // This will return the expected totalSupply during normal situations
233         } else {
234             return getValueAt(totalSupplyHistory, _blockNumber);
235         }
236     }
237 
238       /// @notice Generates `_amount` reputation that are assigned to `_owner`
239       /// @param _user The address that will be assigned the new reputation
240       /// @param _amount The quantity of reputation generated
241       /// @return True if the reputation are generated correctly
242     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
243         uint256 curTotalSupply = totalSupply();
244         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
245         uint256 previousBalanceTo = balanceOf(_user);
246         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
247         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
248         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
249         emit Mint(_user, _amount);
250         return true;
251     }
252 
253       /// @notice Burns `_amount` reputation from `_owner`
254       /// @param _user The address that will lose the reputation
255       /// @param _amount The quantity of reputation to burn
256       /// @return True if the reputation are burned correctly
257     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
258         uint256 curTotalSupply = totalSupply();
259         uint256 amountBurned = _amount;
260         uint256 previousBalanceFrom = balanceOf(_user);
261         if (previousBalanceFrom < amountBurned) {
262             amountBurned = previousBalanceFrom;
263         }
264         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
265         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
266         emit Burn(_user, amountBurned);
267         return true;
268     }
269 
270   ////////////////
271   // Internal helper functions to query and set a value in a snapshot array
272   ////////////////
273 
274       /// @dev `getValueAt` retrieves the number of reputation at a given block number
275       /// @param checkpoints The history of values being queried
276       /// @param _block The block number to retrieve the value at
277       /// @return The number of reputation being queried
278     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
279         if (checkpoints.length == 0) {
280             return 0;
281         }
282 
283           // Shortcut for the actual value
284         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
285             return checkpoints[checkpoints.length-1].value;
286         }
287         if (_block < checkpoints[0].fromBlock) {
288             return 0;
289         }
290 
291           // Binary search of the value in the array
292         uint256 min = 0;
293         uint256 max = checkpoints.length-1;
294         while (max > min) {
295             uint256 mid = (max + min + 1) / 2;
296             if (checkpoints[mid].fromBlock<=_block) {
297                 min = mid;
298             } else {
299                 max = mid-1;
300             }
301         }
302         return checkpoints[min].value;
303     }
304 
305       /// @dev `updateValueAtNow` used to update the `balances` map and the
306       ///  `totalSupplyHistory`
307       /// @param checkpoints The history of data being updated
308       /// @param _value The new number of reputation
309     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
310         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
311         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
312             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
313             newCheckPoint.fromBlock = uint128(block.number);
314             newCheckPoint.value = uint128(_value);
315         } else {
316             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
317             oldCheckPoint.value = uint128(_value);
318         }
319     }
320 }
321 
322 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
323 
324 pragma solidity ^0.5.0;
325 
326 /**
327  * @title ERC20 interface
328  * @dev see https://github.com/ethereum/EIPs/issues/20
329  */
330 interface IERC20 {
331     function transfer(address to, uint256 value) external returns (bool);
332 
333     function approve(address spender, uint256 value) external returns (bool);
334 
335     function transferFrom(address from, address to, uint256 value) external returns (bool);
336 
337     function totalSupply() external view returns (uint256);
338 
339     function balanceOf(address who) external view returns (uint256);
340 
341     function allowance(address owner, address spender) external view returns (uint256);
342 
343     event Transfer(address indexed from, address indexed to, uint256 value);
344 
345     event Approval(address indexed owner, address indexed spender, uint256 value);
346 }
347 
348 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
349 
350 pragma solidity ^0.5.0;
351 
352 
353 
354 /**
355  * @title Standard ERC20 token
356  *
357  * @dev Implementation of the basic standard token.
358  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
359  * Originally based on code by FirstBlood:
360  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
361  *
362  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
363  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
364  * compliant implementations may not do it.
365  */
366 contract ERC20 is IERC20 {
367     using SafeMath for uint256;
368 
369     mapping (address => uint256) private _balances;
370 
371     mapping (address => mapping (address => uint256)) private _allowed;
372 
373     uint256 private _totalSupply;
374 
375     /**
376     * @dev Total number of tokens in existence
377     */
378     function totalSupply() public view returns (uint256) {
379         return _totalSupply;
380     }
381 
382     /**
383     * @dev Gets the balance of the specified address.
384     * @param owner The address to query the balance of.
385     * @return An uint256 representing the amount owned by the passed address.
386     */
387     function balanceOf(address owner) public view returns (uint256) {
388         return _balances[owner];
389     }
390 
391     /**
392      * @dev Function to check the amount of tokens that an owner allowed to a spender.
393      * @param owner address The address which owns the funds.
394      * @param spender address The address which will spend the funds.
395      * @return A uint256 specifying the amount of tokens still available for the spender.
396      */
397     function allowance(address owner, address spender) public view returns (uint256) {
398         return _allowed[owner][spender];
399     }
400 
401     /**
402     * @dev Transfer token for a specified address
403     * @param to The address to transfer to.
404     * @param value The amount to be transferred.
405     */
406     function transfer(address to, uint256 value) public returns (bool) {
407         _transfer(msg.sender, to, value);
408         return true;
409     }
410 
411     /**
412      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
413      * Beware that changing an allowance with this method brings the risk that someone may use both the old
414      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
415      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
416      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
417      * @param spender The address which will spend the funds.
418      * @param value The amount of tokens to be spent.
419      */
420     function approve(address spender, uint256 value) public returns (bool) {
421         require(spender != address(0));
422 
423         _allowed[msg.sender][spender] = value;
424         emit Approval(msg.sender, spender, value);
425         return true;
426     }
427 
428     /**
429      * @dev Transfer tokens from one address to another.
430      * Note that while this function emits an Approval event, this is not required as per the specification,
431      * and other compliant implementations may not emit the event.
432      * @param from address The address which you want to send tokens from
433      * @param to address The address which you want to transfer to
434      * @param value uint256 the amount of tokens to be transferred
435      */
436     function transferFrom(address from, address to, uint256 value) public returns (bool) {
437         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
438         _transfer(from, to, value);
439         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
440         return true;
441     }
442 
443     /**
444      * @dev Increase the amount of tokens that an owner allowed to a spender.
445      * approve should be called when allowed_[_spender] == 0. To increment
446      * allowed value is better to use this function to avoid 2 calls (and wait until
447      * the first transaction is mined)
448      * From MonolithDAO Token.sol
449      * Emits an Approval event.
450      * @param spender The address which will spend the funds.
451      * @param addedValue The amount of tokens to increase the allowance by.
452      */
453     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
454         require(spender != address(0));
455 
456         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
457         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
458         return true;
459     }
460 
461     /**
462      * @dev Decrease the amount of tokens that an owner allowed to a spender.
463      * approve should be called when allowed_[_spender] == 0. To decrement
464      * allowed value is better to use this function to avoid 2 calls (and wait until
465      * the first transaction is mined)
466      * From MonolithDAO Token.sol
467      * Emits an Approval event.
468      * @param spender The address which will spend the funds.
469      * @param subtractedValue The amount of tokens to decrease the allowance by.
470      */
471     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
472         require(spender != address(0));
473 
474         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
475         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
476         return true;
477     }
478 
479     /**
480     * @dev Transfer token for a specified addresses
481     * @param from The address to transfer from.
482     * @param to The address to transfer to.
483     * @param value The amount to be transferred.
484     */
485     function _transfer(address from, address to, uint256 value) internal {
486         require(to != address(0));
487 
488         _balances[from] = _balances[from].sub(value);
489         _balances[to] = _balances[to].add(value);
490         emit Transfer(from, to, value);
491     }
492 
493     /**
494      * @dev Internal function that mints an amount of the token and assigns it to
495      * an account. This encapsulates the modification of balances such that the
496      * proper events are emitted.
497      * @param account The account that will receive the created tokens.
498      * @param value The amount that will be created.
499      */
500     function _mint(address account, uint256 value) internal {
501         require(account != address(0));
502 
503         _totalSupply = _totalSupply.add(value);
504         _balances[account] = _balances[account].add(value);
505         emit Transfer(address(0), account, value);
506     }
507 
508     /**
509      * @dev Internal function that burns an amount of the token of a given
510      * account.
511      * @param account The account whose tokens will be burnt.
512      * @param value The amount that will be burnt.
513      */
514     function _burn(address account, uint256 value) internal {
515         require(account != address(0));
516 
517         _totalSupply = _totalSupply.sub(value);
518         _balances[account] = _balances[account].sub(value);
519         emit Transfer(account, address(0), value);
520     }
521 
522     /**
523      * @dev Internal function that burns an amount of the token of a given
524      * account, deducting from the sender's allowance for said account. Uses the
525      * internal burn function.
526      * Emits an Approval event (reflecting the reduced allowance).
527      * @param account The account whose tokens will be burnt.
528      * @param value The amount that will be burnt.
529      */
530     function _burnFrom(address account, uint256 value) internal {
531         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
532         _burn(account, value);
533         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
534     }
535 }
536 
537 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
538 
539 pragma solidity ^0.5.0;
540 
541 
542 /**
543  * @title Burnable Token
544  * @dev Token that can be irreversibly burned (destroyed).
545  */
546 contract ERC20Burnable is ERC20 {
547     /**
548      * @dev Burns a specific amount of tokens.
549      * @param value The amount of token to be burned.
550      */
551     function burn(uint256 value) public {
552         _burn(msg.sender, value);
553     }
554 
555     /**
556      * @dev Burns a specific amount of tokens from the target address and decrements allowance
557      * @param from address The address which you want to send tokens from
558      * @param value uint256 The amount of token to be burned
559      */
560     function burnFrom(address from, uint256 value) public {
561         _burnFrom(from, value);
562     }
563 }
564 
565 // File: @daostack/arc/contracts/controller/DAOToken.sol
566 
567 pragma solidity ^0.5.4;
568 
569 
570 
571 
572 
573 /**
574  * @title DAOToken, base on zeppelin contract.
575  * @dev ERC20 compatible token. It is a mintable, burnable token.
576  */
577 
578 contract DAOToken is ERC20, ERC20Burnable, Ownable {
579 
580     string public name;
581     string public symbol;
582     // solhint-disable-next-line const-name-snakecase
583     uint8 public constant decimals = 18;
584     uint256 public cap;
585 
586     /**
587     * @dev Constructor
588     * @param _name - token name
589     * @param _symbol - token symbol
590     * @param _cap - token cap - 0 value means no cap
591     */
592     constructor(string memory _name, string memory _symbol, uint256 _cap)
593     public {
594         name = _name;
595         symbol = _symbol;
596         cap = _cap;
597     }
598 
599     /**
600      * @dev Function to mint tokens
601      * @param _to The address that will receive the minted tokens.
602      * @param _amount The amount of tokens to mint.
603      */
604     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
605         if (cap > 0)
606             require(totalSupply().add(_amount) <= cap);
607         _mint(_to, _amount);
608         return true;
609     }
610 }
611 
612 // File: openzeppelin-solidity/contracts/utils/Address.sol
613 
614 pragma solidity ^0.5.0;
615 
616 /**
617  * Utility library of inline functions on addresses
618  */
619 library Address {
620     /**
621      * Returns whether the target address is a contract
622      * @dev This function will return false if invoked during the constructor of a contract,
623      * as the code is not actually created until after the constructor finishes.
624      * @param account address of the account to check
625      * @return whether the target address is a contract
626      */
627     function isContract(address account) internal view returns (bool) {
628         uint256 size;
629         // XXX Currently there is no better way to check if there is a contract in an address
630         // than to check the size of the code at that address.
631         // See https://ethereum.stackexchange.com/a/14016/36603
632         // for more details about how this works.
633         // TODO Check this again before the Serenity release, because all addresses will be
634         // contracts then.
635         // solhint-disable-next-line no-inline-assembly
636         assembly { size := extcodesize(account) }
637         return size > 0;
638     }
639 }
640 
641 // File: @daostack/arc/contracts/libs/SafeERC20.sol
642 
643 /*
644 
645 SafeERC20 by daostack.
646 The code is based on a fix by SECBIT Team.
647 
648 USE WITH CAUTION & NO WARRANTY
649 
650 REFERENCE & RELATED READING
651 - https://github.com/ethereum/solidity/issues/4116
652 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
653 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
654 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
655 
656 */
657 pragma solidity ^0.5.4;
658 
659 
660 
661 library SafeERC20 {
662     using Address for address;
663 
664     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
665     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
666     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
667 
668     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
669 
670         // Must be a contract addr first!
671         require(_erc20Addr.isContract());
672 
673         (bool success, bytes memory returnValue) =
674         // solhint-disable-next-line avoid-low-level-calls
675         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
676         // call return false when something wrong
677         require(success);
678         //check return value
679         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
680     }
681 
682     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
683 
684         // Must be a contract addr first!
685         require(_erc20Addr.isContract());
686 
687         (bool success, bytes memory returnValue) =
688         // solhint-disable-next-line avoid-low-level-calls
689         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
690         // call return false when something wrong
691         require(success);
692         //check return value
693         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
694     }
695 
696     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
697 
698         // Must be a contract addr first!
699         require(_erc20Addr.isContract());
700 
701         // safeApprove should only be called when setting an initial allowance,
702         // or when resetting it to zero.
703         require((_value == 0) || (IERC20(_erc20Addr).allowance(address(this), _spender) == 0));
704 
705         (bool success, bytes memory returnValue) =
706         // solhint-disable-next-line avoid-low-level-calls
707         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
708         // call return false when something wrong
709         require(success);
710         //check return value
711         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
712     }
713 }
714 
715 // File: @daostack/arc/contracts/controller/Avatar.sol
716 
717 pragma solidity ^0.5.4;
718 
719 
720 
721 
722 
723 
724 
725 /**
726  * @title An Avatar holds tokens, reputation and ether for a controller
727  */
728 contract Avatar is Ownable {
729     using SafeERC20 for address;
730 
731     string public orgName;
732     DAOToken public nativeToken;
733     Reputation public nativeReputation;
734 
735     event GenericCall(address indexed _contract, bytes _data, uint _value, bool _success);
736     event SendEther(uint256 _amountInWei, address indexed _to);
737     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint256 _value);
738     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint256 _value);
739     event ExternalTokenApproval(address indexed _externalToken, address _spender, uint256 _value);
740     event ReceiveEther(address indexed _sender, uint256 _value);
741     event MetaData(string _metaData);
742 
743     /**
744     * @dev the constructor takes organization name, native token and reputation system
745     and creates an avatar for a controller
746     */
747     constructor(string memory _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
748         orgName = _orgName;
749         nativeToken = _nativeToken;
750         nativeReputation = _nativeReputation;
751     }
752 
753     /**
754     * @dev enables an avatar to receive ethers
755     */
756     function() external payable {
757         emit ReceiveEther(msg.sender, msg.value);
758     }
759 
760     /**
761     * @dev perform a generic call to an arbitrary contract
762     * @param _contract  the contract's address to call
763     * @param _data ABI-encoded contract call to call `_contract` address.
764     * @param _value value (ETH) to transfer with the transaction
765     * @return bool    success or fail
766     *         bytes - the return bytes of the called contract's function.
767     */
768     function genericCall(address _contract, bytes memory _data, uint256 _value)
769     public
770     onlyOwner
771     returns(bool success, bytes memory returnValue) {
772       // solhint-disable-next-line avoid-call-value
773         (success, returnValue) = _contract.call.value(_value)(_data);
774         emit GenericCall(_contract, _data, _value, success);
775     }
776 
777     /**
778     * @dev send ethers from the avatar's wallet
779     * @param _amountInWei amount to send in Wei units
780     * @param _to send the ethers to this address
781     * @return bool which represents success
782     */
783     function sendEther(uint256 _amountInWei, address payable _to) public onlyOwner returns(bool) {
784         _to.transfer(_amountInWei);
785         emit SendEther(_amountInWei, _to);
786         return true;
787     }
788 
789     /**
790     * @dev external token transfer
791     * @param _externalToken the token contract
792     * @param _to the destination address
793     * @param _value the amount of tokens to transfer
794     * @return bool which represents success
795     */
796     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
797     public onlyOwner returns(bool)
798     {
799         address(_externalToken).safeTransfer(_to, _value);
800         emit ExternalTokenTransfer(address(_externalToken), _to, _value);
801         return true;
802     }
803 
804     /**
805     * @dev external token transfer from a specific account
806     * @param _externalToken the token contract
807     * @param _from the account to spend token from
808     * @param _to the destination address
809     * @param _value the amount of tokens to transfer
810     * @return bool which represents success
811     */
812     function externalTokenTransferFrom(
813         IERC20 _externalToken,
814         address _from,
815         address _to,
816         uint256 _value
817     )
818     public onlyOwner returns(bool)
819     {
820         address(_externalToken).safeTransferFrom(_from, _to, _value);
821         emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
822         return true;
823     }
824 
825     /**
826     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
827     *      on behalf of msg.sender.
828     * @param _externalToken the address of the Token Contract
829     * @param _spender address
830     * @param _value the amount of ether (in Wei) which the approval is referring to.
831     * @return bool which represents a success
832     */
833     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
834     public onlyOwner returns(bool)
835     {
836         address(_externalToken).safeApprove(_spender, _value);
837         emit ExternalTokenApproval(address(_externalToken), _spender, _value);
838         return true;
839     }
840 
841     /**
842     * @dev metaData emits an event with a string, should contain the hash of some meta data.
843     * @param _metaData a string representing a hash of the meta data
844     * @return bool which represents a success
845     */
846     function metaData(string memory _metaData) public onlyOwner returns(bool) {
847         emit MetaData(_metaData);
848         return true;
849     }
850 
851 
852 }
853 
854 // File: @daostack/arc/contracts/globalConstraints/GlobalConstraintInterface.sol
855 
856 pragma solidity ^0.5.4;
857 
858 
859 contract GlobalConstraintInterface {
860 
861     enum CallPhase { Pre, Post, PreAndPost }
862 
863     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
864     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
865     /**
866      * @dev when return if this globalConstraints is pre, post or both.
867      * @return CallPhase enum indication  Pre, Post or PreAndPost.
868      */
869     function when() public returns(CallPhase);
870 }
871 
872 // File: @daostack/arc/contracts/controller/ControllerInterface.sol
873 
874 pragma solidity ^0.5.4;
875 
876 
877 
878 /**
879  * @title Controller contract
880  * @dev A controller controls the organizations tokens ,reputation and avatar.
881  * It is subject to a set of schemes and constraints that determine its behavior.
882  * Each scheme has it own parameters and operation permissions.
883  */
884 interface ControllerInterface {
885 
886     /**
887      * @dev Mint `_amount` of reputation that are assigned to `_to` .
888      * @param  _amount amount of reputation to mint
889      * @param _to beneficiary address
890      * @return bool which represents a success
891     */
892     function mintReputation(uint256 _amount, address _to, address _avatar)
893     external
894     returns(bool);
895 
896     /**
897      * @dev Burns `_amount` of reputation from `_from`
898      * @param _amount amount of reputation to burn
899      * @param _from The address that will lose the reputation
900      * @return bool which represents a success
901      */
902     function burnReputation(uint256 _amount, address _from, address _avatar)
903     external
904     returns(bool);
905 
906     /**
907      * @dev mint tokens .
908      * @param  _amount amount of token to mint
909      * @param _beneficiary beneficiary address
910      * @param _avatar address
911      * @return bool which represents a success
912      */
913     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
914     external
915     returns(bool);
916 
917   /**
918    * @dev register or update a scheme
919    * @param _scheme the address of the scheme
920    * @param _paramsHash a hashed configuration of the usage of the scheme
921    * @param _permissions the permissions the new scheme will have
922    * @param _avatar address
923    * @return bool which represents a success
924    */
925     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
926     external
927     returns(bool);
928 
929     /**
930      * @dev unregister a scheme
931      * @param _avatar address
932      * @param _scheme the address of the scheme
933      * @return bool which represents a success
934      */
935     function unregisterScheme(address _scheme, address _avatar)
936     external
937     returns(bool);
938 
939     /**
940      * @dev unregister the caller's scheme
941      * @param _avatar address
942      * @return bool which represents a success
943      */
944     function unregisterSelf(address _avatar) external returns(bool);
945 
946     /**
947      * @dev add or update Global Constraint
948      * @param _globalConstraint the address of the global constraint to be added.
949      * @param _params the constraint parameters hash.
950      * @param _avatar the avatar of the organization
951      * @return bool which represents a success
952      */
953     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
954     external returns(bool);
955 
956     /**
957      * @dev remove Global Constraint
958      * @param _globalConstraint the address of the global constraint to be remove.
959      * @param _avatar the organization avatar.
960      * @return bool which represents a success
961      */
962     function removeGlobalConstraint (address _globalConstraint, address _avatar)
963     external  returns(bool);
964 
965   /**
966     * @dev upgrade the Controller
967     *      The function will trigger an event 'UpgradeController'.
968     * @param  _newController the address of the new controller.
969     * @param _avatar address
970     * @return bool which represents a success
971     */
972     function upgradeController(address _newController, Avatar _avatar)
973     external returns(bool);
974 
975     /**
976     * @dev perform a generic call to an arbitrary contract
977     * @param _contract  the contract's address to call
978     * @param _data ABI-encoded contract call to call `_contract` address.
979     * @param _avatar the controller's avatar address
980     * @param _value value (ETH) to transfer with the transaction
981     * @return bool -success
982     *         bytes  - the return value of the called _contract's function.
983     */
984     function genericCall(address _contract, bytes calldata _data, Avatar _avatar, uint256 _value)
985     external
986     returns(bool, bytes memory);
987 
988   /**
989    * @dev send some ether
990    * @param _amountInWei the amount of ether (in Wei) to send
991    * @param _to address of the beneficiary
992    * @param _avatar address
993    * @return bool which represents a success
994    */
995     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
996     external returns(bool);
997 
998     /**
999     * @dev send some amount of arbitrary ERC20 Tokens
1000     * @param _externalToken the address of the Token Contract
1001     * @param _to address of the beneficiary
1002     * @param _value the amount of ether (in Wei) to send
1003     * @param _avatar address
1004     * @return bool which represents a success
1005     */
1006     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1007     external
1008     returns(bool);
1009 
1010     /**
1011     * @dev transfer token "from" address "to" address
1012     *      One must to approve the amount of tokens which can be spend from the
1013     *      "from" account.This can be done using externalTokenApprove.
1014     * @param _externalToken the address of the Token Contract
1015     * @param _from address of the account to send from
1016     * @param _to address of the beneficiary
1017     * @param _value the amount of ether (in Wei) to send
1018     * @param _avatar address
1019     * @return bool which represents a success
1020     */
1021     function externalTokenTransferFrom(
1022     IERC20 _externalToken,
1023     address _from,
1024     address _to,
1025     uint256 _value,
1026     Avatar _avatar)
1027     external
1028     returns(bool);
1029 
1030     /**
1031     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1032     *      on behalf of msg.sender.
1033     * @param _externalToken the address of the Token Contract
1034     * @param _spender address
1035     * @param _value the amount of ether (in Wei) which the approval is referring to.
1036     * @return bool which represents a success
1037     */
1038     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1039     external
1040     returns(bool);
1041 
1042     /**
1043     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1044     * @param _metaData a string representing a hash of the meta data
1045     * @param _avatar Avatar
1046     * @return bool which represents a success
1047     */
1048     function metaData(string calldata _metaData, Avatar _avatar) external returns(bool);
1049 
1050     /**
1051      * @dev getNativeReputation
1052      * @param _avatar the organization avatar.
1053      * @return organization native reputation
1054      */
1055     function getNativeReputation(address _avatar)
1056     external
1057     view
1058     returns(address);
1059 
1060     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
1061 
1062     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1063 
1064     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1065 
1066     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1067 
1068     /**
1069      * @dev globalConstraintsCount return the global constraint pre and post count
1070      * @return uint256 globalConstraintsPre count.
1071      * @return uint256 globalConstraintsPost count.
1072      */
1073     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1074 
1075     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1076 }
1077 
1078 // File: @daostack/arc/contracts/schemes/Agreement.sol
1079 
1080 pragma solidity ^0.5.4;
1081 
1082 /**
1083  * @title A scheme for conduct ERC20 Tokens auction for reputation
1084  */
1085 
1086 
1087 contract Agreement {
1088 
1089     bytes32 private agreementHash;
1090 
1091     modifier onlyAgree(bytes32 _agreementHash) {
1092         require(_agreementHash == agreementHash, "Sender must send the right agreementHash");
1093         _;
1094     }
1095 
1096     /**
1097      * @dev getAgreementHash
1098      * @return bytes32 agreementHash
1099      */
1100     function getAgreementHash() external  view returns(bytes32)
1101     {
1102         return agreementHash;
1103     }
1104 
1105     /**
1106      * @dev setAgreementHash
1107      * @param _agreementHash is a hash of agreement required to be added to the TX by participants
1108      */
1109     function setAgreementHash(bytes32 _agreementHash) internal
1110     {
1111         require(agreementHash == bytes32(0), "Can not set agreement twice");
1112         agreementHash = _agreementHash;
1113     }
1114 
1115 
1116 }
1117 
1118 // File: @daostack/arc/contracts/schemes/Auction4Reputation.sol
1119 
1120 pragma solidity ^0.5.4;
1121 
1122 
1123 
1124 
1125 
1126 /**
1127  * @title A scheme for conduct ERC20 Tokens auction for reputation
1128  */
1129 
1130 
1131 contract Auction4Reputation is Agreement {
1132     using SafeMath for uint256;
1133     using SafeERC20 for address;
1134 
1135     event Bid(address indexed _bidder, uint256 indexed _auctionId, uint256 _amount);
1136     event Redeem(uint256 indexed _auctionId, address indexed _beneficiary, uint256 _amount);
1137 
1138     struct Auction {
1139         uint256 totalBid;
1140         // A mapping from bidder addresses to their bids.
1141         mapping(address=>uint) bids;
1142     }
1143 
1144     // A mapping from auction index to auction.
1145     mapping(uint=>Auction) public auctions;
1146 
1147     Avatar public avatar;
1148     uint256 public reputationRewardLeft;
1149     uint256 public auctionsEndTime;
1150     uint256 public auctionsStartTime;
1151     uint256 public numberOfAuctions;
1152     uint256 public auctionReputationReward;
1153     uint256 public auctionPeriod;
1154     uint256 public redeemEnableTime;
1155     IERC20 public token;
1156     address public wallet;
1157 
1158     /**
1159      * @dev initialize
1160      * @param _avatar the avatar to mint reputation from
1161      * @param _auctionReputationReward the reputation reward per auction this contract will reward
1162      *        for the token locking
1163      * @param _auctionsStartTime auctions period start time
1164      * @param _auctionPeriod auctions period time.
1165      *        auctionsEndTime is set to _auctionsStartTime + _auctionPeriod*_numberOfAuctions
1166      *        bidding is disable after auctionsEndTime.
1167      * @param _numberOfAuctions number of auctions.
1168      * @param _redeemEnableTime redeem enable time .
1169      *        redeem reputation can be done after this time.
1170      * @param _token the bidding token
1171      * @param  _wallet the address of the wallet the token will be transfer to.
1172      *         Please note that _wallet address should be a trusted account.
1173      *         Normally this address should be set as the DAO's avatar address.
1174      * @param _agreementHash is a hash of agreement required to be added to the TX by participants
1175      */
1176     function initialize(
1177         Avatar _avatar,
1178         uint256 _auctionReputationReward,
1179         uint256 _auctionsStartTime,
1180         uint256 _auctionPeriod,
1181         uint256 _numberOfAuctions,
1182         uint256 _redeemEnableTime,
1183         IERC20 _token,
1184         address _wallet,
1185         bytes32 _agreementHash )
1186     external
1187     {
1188         require(avatar == Avatar(0), "can be called only one time");
1189         require(_avatar != Avatar(0), "avatar cannot be zero");
1190         require(_numberOfAuctions > 0, "number of auctions cannot be zero");
1191         //_auctionPeriod should be greater than block interval
1192         require(_auctionPeriod > 15, "auctionPeriod should be > 15");
1193         auctionPeriod = _auctionPeriod;
1194         auctionsEndTime = _auctionsStartTime + _auctionPeriod.mul(_numberOfAuctions);
1195         require(_redeemEnableTime >= auctionsEndTime, "_redeemEnableTime >= auctionsEndTime");
1196         token = _token;
1197         avatar = _avatar;
1198         auctionsStartTime = _auctionsStartTime;
1199         numberOfAuctions = _numberOfAuctions;
1200         wallet = _wallet;
1201         auctionReputationReward = _auctionReputationReward;
1202         reputationRewardLeft = _auctionReputationReward.mul(_numberOfAuctions);
1203         redeemEnableTime = _redeemEnableTime;
1204         super.setAgreementHash(_agreementHash);
1205     }
1206 
1207     /**
1208      * @dev redeem reputation function
1209      * @param _beneficiary the beneficiary to redeem.
1210      * @param _auctionId the auction id to redeem from.
1211      * @return uint256 reputation rewarded
1212      */
1213     function redeem(address _beneficiary, uint256 _auctionId) public returns(uint256 reputation) {
1214         // solhint-disable-next-line not-rely-on-time
1215         require(now > redeemEnableTime, "now > redeemEnableTime");
1216         Auction storage auction = auctions[_auctionId];
1217         uint256 bid = auction.bids[_beneficiary];
1218         require(bid > 0, "bidding amount should be > 0");
1219         auction.bids[_beneficiary] = 0;
1220         uint256 repRelation = bid.mul(auctionReputationReward);
1221         reputation = repRelation.div(auction.totalBid);
1222         // check that the reputation is sum zero
1223         reputationRewardLeft = reputationRewardLeft.sub(reputation);
1224         require(
1225         ControllerInterface(avatar.owner())
1226         .mintReputation(reputation, _beneficiary, address(avatar)), "mint reputation should succeed");
1227         emit Redeem(_auctionId, _beneficiary, reputation);
1228     }
1229 
1230     /**
1231      * @dev bid function
1232      * @param _amount the amount to bid with
1233      * @param _auctionId the auction id to bid at .
1234      * @return auctionId
1235      */
1236     function bid(uint256 _amount, uint256 _auctionId, bytes32 _agreementHash)
1237     public
1238     onlyAgree(_agreementHash)
1239     returns(uint256 auctionId)
1240     {
1241         require(_amount > 0, "bidding amount should be > 0");
1242         // solhint-disable-next-line not-rely-on-time
1243         require(now < auctionsEndTime, "bidding should be within the allowed bidding period");
1244         // solhint-disable-next-line not-rely-on-time
1245         require(now >= auctionsStartTime, "bidding is enable only after bidding auctionsStartTime");
1246         address(token).safeTransferFrom(msg.sender, address(this), _amount);
1247         // solhint-disable-next-line not-rely-on-time
1248         auctionId = (now - auctionsStartTime) / auctionPeriod;
1249         require(auctionId == _auctionId, "auction is not active");
1250         Auction storage auction = auctions[auctionId];
1251         auction.totalBid = auction.totalBid.add(_amount);
1252         auction.bids[msg.sender] = auction.bids[msg.sender].add(_amount);
1253         emit Bid(msg.sender, auctionId, _amount);
1254     }
1255 
1256     /**
1257      * @dev getBid get bid for specific bidder and _auctionId
1258      * @param _bidder the bidder
1259      * @param _auctionId auction id
1260      * @return uint
1261      */
1262     function getBid(address _bidder, uint256 _auctionId) public view returns(uint256) {
1263         return auctions[_auctionId].bids[_bidder];
1264     }
1265 
1266     /**
1267      * @dev transferToWallet transfer the tokens to the wallet.
1268      *      can be called only after auctionsEndTime
1269      */
1270     function transferToWallet() public {
1271       // solhint-disable-next-line not-rely-on-time
1272         require(now > auctionsEndTime, "now > auctionsEndTime");
1273         uint256 tokenBalance = token.balanceOf(address(this));
1274         address(token).safeTransfer(wallet, tokenBalance);
1275     }
1276 
1277 }
1278 
1279 // File: contracts/schemes/bootstrap/DxGenAuction4Rep.sol
1280 
1281 pragma solidity ^0.5.4;
1282 
1283 
1284 /**
1285  * @title Scheme for conducting ERC20 Tokens auctions for reputation
1286  */
1287 contract DxGenAuction4Rep is Auction4Reputation {
1288     constructor() public {}
1289 }
