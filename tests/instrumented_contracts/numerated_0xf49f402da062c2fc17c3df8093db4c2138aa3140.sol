1 pragma solidity ^0.5.2;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: @daostack/infra/contracts/Reputation.sol
77 
78 /**
79  * @title Reputation system
80  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
81  * A reputation is use to assign influence measure to a DAO'S peers.
82  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
83  * The Reputation contract maintain a map of address to reputation value.
84  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
85  */
86 
87 contract Reputation is Ownable {
88 
89     uint8 public decimals = 18;             //Number of decimals of the smallest unit
90     // Event indicating minting of reputation to an address.
91     event Mint(address indexed _to, uint256 _amount);
92     // Event indicating burning of reputation for an address.
93     event Burn(address indexed _from, uint256 _amount);
94 
95       /// @dev `Checkpoint` is the structure that attaches a block number to a
96       ///  given value, the block number attached is the one that last changed the
97       ///  value
98     struct Checkpoint {
99 
100     // `fromBlock` is the block number that the value was generated from
101         uint128 fromBlock;
102 
103           // `value` is the amount of reputation at a specific block number
104         uint128 value;
105     }
106 
107       // `balances` is the map that tracks the balance of each address, in this
108       //  contract when the balance changes the block number that the change
109       //  occurred is also included in the map
110     mapping (address => Checkpoint[]) balances;
111 
112       // Tracks the history of the `totalSupply` of the reputation
113     Checkpoint[] totalSupplyHistory;
114 
115     /// @notice Constructor to create a Reputation
116     constructor(
117     ) public
118     {
119     }
120 
121     /// @dev This function makes it easy to get the total number of reputation
122     /// @return The total number of reputation
123     function totalSupply() public view returns (uint256) {
124         return totalSupplyAt(block.number);
125     }
126 
127   ////////////////
128   // Query balance and totalSupply in History
129   ////////////////
130     /**
131     * @dev return the reputation amount of a given owner
132     * @param _owner an address of the owner which we want to get his reputation
133     */
134     function balanceOf(address _owner) public view returns (uint256 balance) {
135         return balanceOfAt(_owner, block.number);
136     }
137 
138       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
139       /// @param _owner The address from which the balance will be retrieved
140       /// @param _blockNumber The block number when the balance is queried
141       /// @return The balance at `_blockNumber`
142     function balanceOfAt(address _owner, uint256 _blockNumber)
143     public view returns (uint256)
144     {
145         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
146             return 0;
147           // This will return the expected balance during normal situations
148         } else {
149             return getValueAt(balances[_owner], _blockNumber);
150         }
151     }
152 
153       /// @notice Total amount of reputation at a specific `_blockNumber`.
154       /// @param _blockNumber The block number when the totalSupply is queried
155       /// @return The total amount of reputation at `_blockNumber`
156     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
157         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
158             return 0;
159           // This will return the expected totalSupply during normal situations
160         } else {
161             return getValueAt(totalSupplyHistory, _blockNumber);
162         }
163     }
164 
165       /// @notice Generates `_amount` reputation that are assigned to `_owner`
166       /// @param _user The address that will be assigned the new reputation
167       /// @param _amount The quantity of reputation generated
168       /// @return True if the reputation are generated correctly
169     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
170         uint256 curTotalSupply = totalSupply();
171         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
172         uint256 previousBalanceTo = balanceOf(_user);
173         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
174         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
175         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
176         emit Mint(_user, _amount);
177         return true;
178     }
179 
180       /// @notice Burns `_amount` reputation from `_owner`
181       /// @param _user The address that will lose the reputation
182       /// @param _amount The quantity of reputation to burn
183       /// @return True if the reputation are burned correctly
184     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
185         uint256 curTotalSupply = totalSupply();
186         uint256 amountBurned = _amount;
187         uint256 previousBalanceFrom = balanceOf(_user);
188         if (previousBalanceFrom < amountBurned) {
189             amountBurned = previousBalanceFrom;
190         }
191         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
192         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
193         emit Burn(_user, amountBurned);
194         return true;
195     }
196 
197   ////////////////
198   // Internal helper functions to query and set a value in a snapshot array
199   ////////////////
200 
201       /// @dev `getValueAt` retrieves the number of reputation at a given block number
202       /// @param checkpoints The history of values being queried
203       /// @param _block The block number to retrieve the value at
204       /// @return The number of reputation being queried
205     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
206         if (checkpoints.length == 0) {
207             return 0;
208         }
209 
210           // Shortcut for the actual value
211         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
212             return checkpoints[checkpoints.length-1].value;
213         }
214         if (_block < checkpoints[0].fromBlock) {
215             return 0;
216         }
217 
218           // Binary search of the value in the array
219         uint256 min = 0;
220         uint256 max = checkpoints.length-1;
221         while (max > min) {
222             uint256 mid = (max + min + 1) / 2;
223             if (checkpoints[mid].fromBlock<=_block) {
224                 min = mid;
225             } else {
226                 max = mid-1;
227             }
228         }
229         return checkpoints[min].value;
230     }
231 
232       /// @dev `updateValueAtNow` used to update the `balances` map and the
233       ///  `totalSupplyHistory`
234       /// @param checkpoints The history of data being updated
235       /// @param _value The new number of reputation
236     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
237         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
238         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
239             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
240             newCheckPoint.fromBlock = uint128(block.number);
241             newCheckPoint.value = uint128(_value);
242         } else {
243             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
244             oldCheckPoint.value = uint128(_value);
245         }
246     }
247 }
248 
249 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
250 
251 /**
252  * @title ERC20 interface
253  * @dev see https://github.com/ethereum/EIPs/issues/20
254  */
255 interface IERC20 {
256     function transfer(address to, uint256 value) external returns (bool);
257 
258     function approve(address spender, uint256 value) external returns (bool);
259 
260     function transferFrom(address from, address to, uint256 value) external returns (bool);
261 
262     function totalSupply() external view returns (uint256);
263 
264     function balanceOf(address who) external view returns (uint256);
265 
266     function allowance(address owner, address spender) external view returns (uint256);
267 
268     event Transfer(address indexed from, address indexed to, uint256 value);
269 
270     event Approval(address indexed owner, address indexed spender, uint256 value);
271 }
272 
273 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
274 
275 /**
276  * @title SafeMath
277  * @dev Unsigned math operations with safety checks that revert on error
278  */
279 library SafeMath {
280     /**
281     * @dev Multiplies two unsigned integers, reverts on overflow.
282     */
283     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
284         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
285         // benefit is lost if 'b' is also tested.
286         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
287         if (a == 0) {
288             return 0;
289         }
290 
291         uint256 c = a * b;
292         require(c / a == b);
293 
294         return c;
295     }
296 
297     /**
298     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
299     */
300     function div(uint256 a, uint256 b) internal pure returns (uint256) {
301         // Solidity only automatically asserts when dividing by 0
302         require(b > 0);
303         uint256 c = a / b;
304         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
305 
306         return c;
307     }
308 
309     /**
310     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
311     */
312     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
313         require(b <= a);
314         uint256 c = a - b;
315 
316         return c;
317     }
318 
319     /**
320     * @dev Adds two unsigned integers, reverts on overflow.
321     */
322     function add(uint256 a, uint256 b) internal pure returns (uint256) {
323         uint256 c = a + b;
324         require(c >= a);
325 
326         return c;
327     }
328 
329     /**
330     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
331     * reverts when dividing by zero.
332     */
333     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
334         require(b != 0);
335         return a % b;
336     }
337 }
338 
339 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
340 
341 /**
342  * @title Standard ERC20 token
343  *
344  * @dev Implementation of the basic standard token.
345  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
346  * Originally based on code by FirstBlood:
347  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
348  *
349  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
350  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
351  * compliant implementations may not do it.
352  */
353 contract ERC20 is IERC20 {
354     using SafeMath for uint256;
355 
356     mapping (address => uint256) private _balances;
357 
358     mapping (address => mapping (address => uint256)) private _allowed;
359 
360     uint256 private _totalSupply;
361 
362     /**
363     * @dev Total number of tokens in existence
364     */
365     function totalSupply() public view returns (uint256) {
366         return _totalSupply;
367     }
368 
369     /**
370     * @dev Gets the balance of the specified address.
371     * @param owner The address to query the balance of.
372     * @return An uint256 representing the amount owned by the passed address.
373     */
374     function balanceOf(address owner) public view returns (uint256) {
375         return _balances[owner];
376     }
377 
378     /**
379      * @dev Function to check the amount of tokens that an owner allowed to a spender.
380      * @param owner address The address which owns the funds.
381      * @param spender address The address which will spend the funds.
382      * @return A uint256 specifying the amount of tokens still available for the spender.
383      */
384     function allowance(address owner, address spender) public view returns (uint256) {
385         return _allowed[owner][spender];
386     }
387 
388     /**
389     * @dev Transfer token for a specified address
390     * @param to The address to transfer to.
391     * @param value The amount to be transferred.
392     */
393     function transfer(address to, uint256 value) public returns (bool) {
394         _transfer(msg.sender, to, value);
395         return true;
396     }
397 
398     /**
399      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
400      * Beware that changing an allowance with this method brings the risk that someone may use both the old
401      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
402      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
403      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
404      * @param spender The address which will spend the funds.
405      * @param value The amount of tokens to be spent.
406      */
407     function approve(address spender, uint256 value) public returns (bool) {
408         require(spender != address(0));
409 
410         _allowed[msg.sender][spender] = value;
411         emit Approval(msg.sender, spender, value);
412         return true;
413     }
414 
415     /**
416      * @dev Transfer tokens from one address to another.
417      * Note that while this function emits an Approval event, this is not required as per the specification,
418      * and other compliant implementations may not emit the event.
419      * @param from address The address which you want to send tokens from
420      * @param to address The address which you want to transfer to
421      * @param value uint256 the amount of tokens to be transferred
422      */
423     function transferFrom(address from, address to, uint256 value) public returns (bool) {
424         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
425         _transfer(from, to, value);
426         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
427         return true;
428     }
429 
430     /**
431      * @dev Increase the amount of tokens that an owner allowed to a spender.
432      * approve should be called when allowed_[_spender] == 0. To increment
433      * allowed value is better to use this function to avoid 2 calls (and wait until
434      * the first transaction is mined)
435      * From MonolithDAO Token.sol
436      * Emits an Approval event.
437      * @param spender The address which will spend the funds.
438      * @param addedValue The amount of tokens to increase the allowance by.
439      */
440     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
441         require(spender != address(0));
442 
443         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
444         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
445         return true;
446     }
447 
448     /**
449      * @dev Decrease the amount of tokens that an owner allowed to a spender.
450      * approve should be called when allowed_[_spender] == 0. To decrement
451      * allowed value is better to use this function to avoid 2 calls (and wait until
452      * the first transaction is mined)
453      * From MonolithDAO Token.sol
454      * Emits an Approval event.
455      * @param spender The address which will spend the funds.
456      * @param subtractedValue The amount of tokens to decrease the allowance by.
457      */
458     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
459         require(spender != address(0));
460 
461         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
462         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
463         return true;
464     }
465 
466     /**
467     * @dev Transfer token for a specified addresses
468     * @param from The address to transfer from.
469     * @param to The address to transfer to.
470     * @param value The amount to be transferred.
471     */
472     function _transfer(address from, address to, uint256 value) internal {
473         require(to != address(0));
474 
475         _balances[from] = _balances[from].sub(value);
476         _balances[to] = _balances[to].add(value);
477         emit Transfer(from, to, value);
478     }
479 
480     /**
481      * @dev Internal function that mints an amount of the token and assigns it to
482      * an account. This encapsulates the modification of balances such that the
483      * proper events are emitted.
484      * @param account The account that will receive the created tokens.
485      * @param value The amount that will be created.
486      */
487     function _mint(address account, uint256 value) internal {
488         require(account != address(0));
489 
490         _totalSupply = _totalSupply.add(value);
491         _balances[account] = _balances[account].add(value);
492         emit Transfer(address(0), account, value);
493     }
494 
495     /**
496      * @dev Internal function that burns an amount of the token of a given
497      * account.
498      * @param account The account whose tokens will be burnt.
499      * @param value The amount that will be burnt.
500      */
501     function _burn(address account, uint256 value) internal {
502         require(account != address(0));
503 
504         _totalSupply = _totalSupply.sub(value);
505         _balances[account] = _balances[account].sub(value);
506         emit Transfer(account, address(0), value);
507     }
508 
509     /**
510      * @dev Internal function that burns an amount of the token of a given
511      * account, deducting from the sender's allowance for said account. Uses the
512      * internal burn function.
513      * Emits an Approval event (reflecting the reduced allowance).
514      * @param account The account whose tokens will be burnt.
515      * @param value The amount that will be burnt.
516      */
517     function _burnFrom(address account, uint256 value) internal {
518         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
519         _burn(account, value);
520         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
521     }
522 }
523 
524 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
525 
526 /**
527  * @title Burnable Token
528  * @dev Token that can be irreversibly burned (destroyed).
529  */
530 contract ERC20Burnable is ERC20 {
531     /**
532      * @dev Burns a specific amount of tokens.
533      * @param value The amount of token to be burned.
534      */
535     function burn(uint256 value) public {
536         _burn(msg.sender, value);
537     }
538 
539     /**
540      * @dev Burns a specific amount of tokens from the target address and decrements allowance
541      * @param from address The address which you want to send tokens from
542      * @param value uint256 The amount of token to be burned
543      */
544     function burnFrom(address from, uint256 value) public {
545         _burnFrom(from, value);
546     }
547 }
548 
549 // File: @daostack/arc/contracts/controller/DAOToken.sol
550 
551 /**
552  * @title DAOToken, base on zeppelin contract.
553  * @dev ERC20 compatible token. It is a mintable, burnable token.
554  */
555 
556 contract DAOToken is ERC20, ERC20Burnable, Ownable {
557 
558     string public name;
559     string public symbol;
560     // solhint-disable-next-line const-name-snakecase
561     uint8 public constant decimals = 18;
562     uint256 public cap;
563 
564     /**
565     * @dev Constructor
566     * @param _name - token name
567     * @param _symbol - token symbol
568     * @param _cap - token cap - 0 value means no cap
569     */
570     constructor(string memory _name, string memory _symbol, uint256 _cap)
571     public {
572         name = _name;
573         symbol = _symbol;
574         cap = _cap;
575     }
576 
577     /**
578      * @dev Function to mint tokens
579      * @param _to The address that will receive the minted tokens.
580      * @param _amount The amount of tokens to mint.
581      */
582     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
583         if (cap > 0)
584             require(totalSupply().add(_amount) <= cap);
585         _mint(_to, _amount);
586         return true;
587     }
588 }
589 
590 // File: openzeppelin-solidity/contracts/utils/Address.sol
591 
592 /**
593  * Utility library of inline functions on addresses
594  */
595 library Address {
596     /**
597      * Returns whether the target address is a contract
598      * @dev This function will return false if invoked during the constructor of a contract,
599      * as the code is not actually created until after the constructor finishes.
600      * @param account address of the account to check
601      * @return whether the target address is a contract
602      */
603     function isContract(address account) internal view returns (bool) {
604         uint256 size;
605         // XXX Currently there is no better way to check if there is a contract in an address
606         // than to check the size of the code at that address.
607         // See https://ethereum.stackexchange.com/a/14016/36603
608         // for more details about how this works.
609         // TODO Check this again before the Serenity release, because all addresses will be
610         // contracts then.
611         // solhint-disable-next-line no-inline-assembly
612         assembly { size := extcodesize(account) }
613         return size > 0;
614     }
615 }
616 
617 // File: @daostack/arc/contracts/libs/SafeERC20.sol
618 
619 /*
620 
621 SafeERC20 by daostack.
622 The code is based on a fix by SECBIT Team.
623 
624 USE WITH CAUTION & NO WARRANTY
625 
626 REFERENCE & RELATED READING
627 - https://github.com/ethereum/solidity/issues/4116
628 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
629 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
630 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
631 
632 */
633 pragma solidity ^0.5.2;
634 
635 
636 
637 library SafeERC20 {
638     using Address for address;
639 
640     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
641     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
642     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
643 
644     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
645 
646         // Must be a contract addr first!
647         require(_erc20Addr.isContract());
648 
649         (bool success, bytes memory returnValue) =
650         // solhint-disable-next-line avoid-low-level-calls
651         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
652         // call return false when something wrong
653         require(success);
654         //check return value
655         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
656     }
657 
658     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
659 
660         // Must be a contract addr first!
661         require(_erc20Addr.isContract());
662 
663         (bool success, bytes memory returnValue) =
664         // solhint-disable-next-line avoid-low-level-calls
665         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
666         // call return false when something wrong
667         require(success);
668         //check return value
669         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
670     }
671 
672     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
673 
674         // Must be a contract addr first!
675         require(_erc20Addr.isContract());
676 
677         // safeApprove should only be called when setting an initial allowance,
678         // or when resetting it to zero.
679         require((_value == 0) || (IERC20(_erc20Addr).allowance(msg.sender, _spender) == 0));
680 
681         (bool success, bytes memory returnValue) =
682         // solhint-disable-next-line avoid-low-level-calls
683         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
684         // call return false when something wrong
685         require(success);
686         //check return value
687         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
688     }
689 }
690 
691 // File: @daostack/arc/contracts/controller/Avatar.sol
692 
693 /**
694  * @title An Avatar holds tokens, reputation and ether for a controller
695  */
696 contract Avatar is Ownable {
697     using SafeERC20 for address;
698 
699     string public orgName;
700     DAOToken public nativeToken;
701     Reputation public nativeReputation;
702 
703     event GenericCall(address indexed _contract, bytes _params, bool _success);
704     event SendEther(uint256 _amountInWei, address indexed _to);
705     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint256 _value);
706     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint256 _value);
707     event ExternalTokenApproval(address indexed _externalToken, address _spender, uint256 _value);
708     event ReceiveEther(address indexed _sender, uint256 _value);
709 
710     /**
711     * @dev the constructor takes organization name, native token and reputation system
712     and creates an avatar for a controller
713     */
714     constructor(string memory _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
715         orgName = _orgName;
716         nativeToken = _nativeToken;
717         nativeReputation = _nativeReputation;
718     }
719 
720     /**
721     * @dev enables an avatar to receive ethers
722     */
723     function() external payable {
724         emit ReceiveEther(msg.sender, msg.value);
725     }
726 
727     /**
728     * @dev perform a generic call to an arbitrary contract
729     * @param _contract  the contract's address to call
730     * @param _data ABI-encoded contract call to call `_contract` address.
731     * @return bool    success or fail
732     *         bytes - the return bytes of the called contract's function.
733     */
734     function genericCall(address _contract, bytes memory _data)
735     public
736     onlyOwner
737     returns(bool success, bytes memory returnValue) {
738       // solhint-disable-next-line avoid-low-level-calls
739         (success, returnValue) = _contract.call(_data);
740         emit GenericCall(_contract, _data, success);
741     }
742 
743     /**
744     * @dev send ethers from the avatar's wallet
745     * @param _amountInWei amount to send in Wei units
746     * @param _to send the ethers to this address
747     * @return bool which represents success
748     */
749     function sendEther(uint256 _amountInWei, address payable _to) public onlyOwner returns(bool) {
750         _to.transfer(_amountInWei);
751         emit SendEther(_amountInWei, _to);
752         return true;
753     }
754 
755     /**
756     * @dev external token transfer
757     * @param _externalToken the token contract
758     * @param _to the destination address
759     * @param _value the amount of tokens to transfer
760     * @return bool which represents success
761     */
762     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
763     public onlyOwner returns(bool)
764     {
765         address(_externalToken).safeTransfer(_to, _value);
766         emit ExternalTokenTransfer(address(_externalToken), _to, _value);
767         return true;
768     }
769 
770     /**
771     * @dev external token transfer from a specific account
772     * @param _externalToken the token contract
773     * @param _from the account to spend token from
774     * @param _to the destination address
775     * @param _value the amount of tokens to transfer
776     * @return bool which represents success
777     */
778     function externalTokenTransferFrom(
779         IERC20 _externalToken,
780         address _from,
781         address _to,
782         uint256 _value
783     )
784     public onlyOwner returns(bool)
785     {
786         address(_externalToken).safeTransferFrom(_from, _to, _value);
787         emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
788         return true;
789     }
790 
791     /**
792     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
793     *      on behalf of msg.sender.
794     * @param _externalToken the address of the Token Contract
795     * @param _spender address
796     * @param _value the amount of ether (in Wei) which the approval is referring to.
797     * @return bool which represents a success
798     */
799     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
800     public onlyOwner returns(bool)
801     {
802         address(_externalToken).safeApprove(_spender, _value);
803         emit ExternalTokenApproval(address(_externalToken), _spender, _value);
804         return true;
805     }
806 
807 }
808 
809 // File: @daostack/arc/contracts/globalConstraints/GlobalConstraintInterface.sol
810 
811 contract GlobalConstraintInterface {
812 
813     enum CallPhase { Pre, Post, PreAndPost }
814 
815     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
816     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
817     /**
818      * @dev when return if this globalConstraints is pre, post or both.
819      * @return CallPhase enum indication  Pre, Post or PreAndPost.
820      */
821     function when() public returns(CallPhase);
822 }
823 
824 // File: @daostack/arc/contracts/controller/ControllerInterface.sol
825 
826 /**
827  * @title Controller contract
828  * @dev A controller controls the organizations tokens ,reputation and avatar.
829  * It is subject to a set of schemes and constraints that determine its behavior.
830  * Each scheme has it own parameters and operation permissions.
831  */
832 interface ControllerInterface {
833 
834     /**
835      * @dev Mint `_amount` of reputation that are assigned to `_to` .
836      * @param  _amount amount of reputation to mint
837      * @param _to beneficiary address
838      * @return bool which represents a success
839     */
840     function mintReputation(uint256 _amount, address _to, address _avatar)
841     external
842     returns(bool);
843 
844     /**
845      * @dev Burns `_amount` of reputation from `_from`
846      * @param _amount amount of reputation to burn
847      * @param _from The address that will lose the reputation
848      * @return bool which represents a success
849      */
850     function burnReputation(uint256 _amount, address _from, address _avatar)
851     external
852     returns(bool);
853 
854     /**
855      * @dev mint tokens .
856      * @param  _amount amount of token to mint
857      * @param _beneficiary beneficiary address
858      * @param _avatar address
859      * @return bool which represents a success
860      */
861     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
862     external
863     returns(bool);
864 
865   /**
866    * @dev register or update a scheme
867    * @param _scheme the address of the scheme
868    * @param _paramsHash a hashed configuration of the usage of the scheme
869    * @param _permissions the permissions the new scheme will have
870    * @param _avatar address
871    * @return bool which represents a success
872    */
873     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
874     external
875     returns(bool);
876 
877     /**
878      * @dev unregister a scheme
879      * @param _avatar address
880      * @param _scheme the address of the scheme
881      * @return bool which represents a success
882      */
883     function unregisterScheme(address _scheme, address _avatar)
884     external
885     returns(bool);
886 
887     /**
888      * @dev unregister the caller's scheme
889      * @param _avatar address
890      * @return bool which represents a success
891      */
892     function unregisterSelf(address _avatar) external returns(bool);
893 
894     /**
895      * @dev add or update Global Constraint
896      * @param _globalConstraint the address of the global constraint to be added.
897      * @param _params the constraint parameters hash.
898      * @param _avatar the avatar of the organization
899      * @return bool which represents a success
900      */
901     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
902     external returns(bool);
903 
904     /**
905      * @dev remove Global Constraint
906      * @param _globalConstraint the address of the global constraint to be remove.
907      * @param _avatar the organization avatar.
908      * @return bool which represents a success
909      */
910     function removeGlobalConstraint (address _globalConstraint, address _avatar)
911     external  returns(bool);
912 
913   /**
914     * @dev upgrade the Controller
915     *      The function will trigger an event 'UpgradeController'.
916     * @param  _newController the address of the new controller.
917     * @param _avatar address
918     * @return bool which represents a success
919     */
920     function upgradeController(address _newController, Avatar _avatar)
921     external returns(bool);
922 
923     /**
924     * @dev perform a generic call to an arbitrary contract
925     * @param _contract  the contract's address to call
926     * @param _data ABI-encoded contract call to call `_contract` address.
927     * @param _avatar the controller's avatar address
928     * @return bool -success
929     *         bytes  - the return value of the called _contract's function.
930     */
931     function genericCall(address _contract, bytes calldata _data, Avatar _avatar)
932     external
933     returns(bool, bytes memory);
934 
935   /**
936    * @dev send some ether
937    * @param _amountInWei the amount of ether (in Wei) to send
938    * @param _to address of the beneficiary
939    * @param _avatar address
940    * @return bool which represents a success
941    */
942     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
943     external returns(bool);
944 
945     /**
946     * @dev send some amount of arbitrary ERC20 Tokens
947     * @param _externalToken the address of the Token Contract
948     * @param _to address of the beneficiary
949     * @param _value the amount of ether (in Wei) to send
950     * @param _avatar address
951     * @return bool which represents a success
952     */
953     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
954     external
955     returns(bool);
956 
957     /**
958     * @dev transfer token "from" address "to" address
959     *      One must to approve the amount of tokens which can be spend from the
960     *      "from" account.This can be done using externalTokenApprove.
961     * @param _externalToken the address of the Token Contract
962     * @param _from address of the account to send from
963     * @param _to address of the beneficiary
964     * @param _value the amount of ether (in Wei) to send
965     * @param _avatar address
966     * @return bool which represents a success
967     */
968     function externalTokenTransferFrom(
969     IERC20 _externalToken,
970     address _from,
971     address _to,
972     uint256 _value,
973     Avatar _avatar)
974     external
975     returns(bool);
976 
977     /**
978     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
979     *      on behalf of msg.sender.
980     * @param _externalToken the address of the Token Contract
981     * @param _spender address
982     * @param _value the amount of ether (in Wei) which the approval is referring to.
983     * @return bool which represents a success
984     */
985     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
986     external
987     returns(bool);
988 
989     /**
990      * @dev getNativeReputation
991      * @param _avatar the organization avatar.
992      * @return organization native reputation
993      */
994     function getNativeReputation(address _avatar)
995     external
996     view
997     returns(address);
998 
999     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
1000 
1001     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1002 
1003     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1004 
1005     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1006 
1007     /**
1008      * @dev globalConstraintsCount return the global constraint pre and post count
1009      * @return uint256 globalConstraintsPre count.
1010      * @return uint256 globalConstraintsPost count.
1011      */
1012     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1013 
1014     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1015 }
1016 
1017 // File: @daostack/arc/contracts/controller/Controller.sol
1018 
1019 /**
1020  * @title Controller contract
1021  * @dev A controller controls the organizations tokens, reputation and avatar.
1022  * It is subject to a set of schemes and constraints that determine its behavior.
1023  * Each scheme has it own parameters and operation permissions.
1024  */
1025 contract Controller is ControllerInterface {
1026 
1027     struct Scheme {
1028         bytes32 paramsHash;  // a hash "configuration" of the scheme
1029         bytes4  permissions; // A bitwise flags of permissions,
1030                              // All 0: Not registered,
1031                              // 1st bit: Flag if the scheme is registered,
1032                              // 2nd bit: Scheme can register other schemes
1033                              // 3rd bit: Scheme can add/remove global constraints
1034                              // 4th bit: Scheme can upgrade the controller
1035                              // 5th bit: Scheme can call genericCall on behalf of
1036                              //          the organization avatar
1037     }
1038 
1039     struct GlobalConstraint {
1040         address gcAddress;
1041         bytes32 params;
1042     }
1043 
1044     struct GlobalConstraintRegister {
1045         bool isRegistered; //is registered
1046         uint256 index;    //index at globalConstraints
1047     }
1048 
1049     mapping(address=>Scheme) public schemes;
1050 
1051     Avatar public avatar;
1052     DAOToken public nativeToken;
1053     Reputation public nativeReputation;
1054   // newController will point to the new controller after the present controller is upgraded
1055     address public newController;
1056   // globalConstraintsPre that determine pre conditions for all actions on the controller
1057 
1058     GlobalConstraint[] public globalConstraintsPre;
1059   // globalConstraintsPost that determine post conditions for all actions on the controller
1060     GlobalConstraint[] public globalConstraintsPost;
1061   // globalConstraintsRegisterPre indicate if a globalConstraints is registered as a pre global constraint
1062     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPre;
1063   // globalConstraintsRegisterPost indicate if a globalConstraints is registered as a post global constraint
1064     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPost;
1065 
1066     event MintReputation (address indexed _sender, address indexed _to, uint256 _amount);
1067     event BurnReputation (address indexed _sender, address indexed _from, uint256 _amount);
1068     event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);
1069     event RegisterScheme (address indexed _sender, address indexed _scheme);
1070     event UnregisterScheme (address indexed _sender, address indexed _scheme);
1071     event UpgradeController(address indexed _oldController, address _newController);
1072 
1073     event AddGlobalConstraint(
1074         address indexed _globalConstraint,
1075         bytes32 _params,
1076         GlobalConstraintInterface.CallPhase _when);
1077 
1078     event RemoveGlobalConstraint(address indexed _globalConstraint, uint256 _index, bool _isPre);
1079 
1080     constructor( Avatar _avatar) public {
1081         avatar = _avatar;
1082         nativeToken = avatar.nativeToken();
1083         nativeReputation = avatar.nativeReputation();
1084         schemes[msg.sender] = Scheme({paramsHash: bytes32(0), permissions: bytes4(0x0000001F)});
1085     }
1086 
1087   // Do not allow mistaken calls:
1088    // solhint-disable-next-line payable-fallback
1089     function() external {
1090         revert();
1091     }
1092 
1093   // Modifiers:
1094     modifier onlyRegisteredScheme() {
1095         require(schemes[msg.sender].permissions&bytes4(0x00000001) == bytes4(0x00000001));
1096         _;
1097     }
1098 
1099     modifier onlyRegisteringSchemes() {
1100         require(schemes[msg.sender].permissions&bytes4(0x00000002) == bytes4(0x00000002));
1101         _;
1102     }
1103 
1104     modifier onlyGlobalConstraintsScheme() {
1105         require(schemes[msg.sender].permissions&bytes4(0x00000004) == bytes4(0x00000004));
1106         _;
1107     }
1108 
1109     modifier onlyUpgradingScheme() {
1110         require(schemes[msg.sender].permissions&bytes4(0x00000008) == bytes4(0x00000008));
1111         _;
1112     }
1113 
1114     modifier onlyGenericCallScheme() {
1115         require(schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1116         _;
1117     }
1118 
1119     modifier onlySubjectToConstraint(bytes32 func) {
1120         uint256 idx;
1121         for (idx = 0; idx < globalConstraintsPre.length; idx++) {
1122             require(
1123             (GlobalConstraintInterface(globalConstraintsPre[idx].gcAddress))
1124             .pre(msg.sender, globalConstraintsPre[idx].params, func));
1125         }
1126         _;
1127         for (idx = 0; idx < globalConstraintsPost.length; idx++) {
1128             require(
1129             (GlobalConstraintInterface(globalConstraintsPost[idx].gcAddress))
1130             .post(msg.sender, globalConstraintsPost[idx].params, func));
1131         }
1132     }
1133 
1134     modifier isAvatarValid(address _avatar) {
1135         require(_avatar == address(avatar));
1136         _;
1137     }
1138 
1139     /**
1140      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1141      * @param  _amount amount of reputation to mint
1142      * @param _to beneficiary address
1143      * @return bool which represents a success
1144      */
1145     function mintReputation(uint256 _amount, address _to, address _avatar)
1146     external
1147     onlyRegisteredScheme
1148     onlySubjectToConstraint("mintReputation")
1149     isAvatarValid(_avatar)
1150     returns(bool)
1151     {
1152         emit MintReputation(msg.sender, _to, _amount);
1153         return nativeReputation.mint(_to, _amount);
1154     }
1155 
1156     /**
1157      * @dev Burns `_amount` of reputation from `_from`
1158      * @param _amount amount of reputation to burn
1159      * @param _from The address that will lose the reputation
1160      * @return bool which represents a success
1161      */
1162     function burnReputation(uint256 _amount, address _from, address _avatar)
1163     external
1164     onlyRegisteredScheme
1165     onlySubjectToConstraint("burnReputation")
1166     isAvatarValid(_avatar)
1167     returns(bool)
1168     {
1169         emit BurnReputation(msg.sender, _from, _amount);
1170         return nativeReputation.burn(_from, _amount);
1171     }
1172 
1173     /**
1174      * @dev mint tokens .
1175      * @param  _amount amount of token to mint
1176      * @param _beneficiary beneficiary address
1177      * @return bool which represents a success
1178      */
1179     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
1180     external
1181     onlyRegisteredScheme
1182     onlySubjectToConstraint("mintTokens")
1183     isAvatarValid(_avatar)
1184     returns(bool)
1185     {
1186         emit MintTokens(msg.sender, _beneficiary, _amount);
1187         return nativeToken.mint(_beneficiary, _amount);
1188     }
1189 
1190   /**
1191    * @dev register a scheme
1192    * @param _scheme the address of the scheme
1193    * @param _paramsHash a hashed configuration of the usage of the scheme
1194    * @param _permissions the permissions the new scheme will have
1195    * @return bool which represents a success
1196    */
1197     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
1198     external
1199     onlyRegisteringSchemes
1200     onlySubjectToConstraint("registerScheme")
1201     isAvatarValid(_avatar)
1202     returns(bool)
1203     {
1204 
1205         Scheme memory scheme = schemes[_scheme];
1206 
1207     // Check scheme has at least the permissions it is changing, and at least the current permissions:
1208     // Implementation is a bit messy. One must recall logic-circuits ^^
1209 
1210     // produces non-zero if sender does not have all of the perms that are changing between old and new
1211         require(bytes4(0x0000001f)&(_permissions^scheme.permissions)&(~schemes[msg.sender].permissions) == bytes4(0));
1212 
1213     // produces non-zero if sender does not have all of the perms in the old scheme
1214         require(bytes4(0x0000001f)&(scheme.permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1215 
1216     // Add or change the scheme:
1217         schemes[_scheme].paramsHash = _paramsHash;
1218         schemes[_scheme].permissions = _permissions|bytes4(0x00000001);
1219         emit RegisterScheme(msg.sender, _scheme);
1220         return true;
1221     }
1222 
1223     /**
1224      * @dev unregister a scheme
1225      * @param _scheme the address of the scheme
1226      * @return bool which represents a success
1227      */
1228     function unregisterScheme( address _scheme, address _avatar)
1229     external
1230     onlyRegisteringSchemes
1231     onlySubjectToConstraint("unregisterScheme")
1232     isAvatarValid(_avatar)
1233     returns(bool)
1234     {
1235     //check if the scheme is registered
1236         if (_isSchemeRegistered(_scheme) == false) {
1237             return false;
1238         }
1239     // Check the unregistering scheme has enough permissions:
1240         require(bytes4(0x0000001f)&(schemes[_scheme].permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1241 
1242     // Unregister:
1243         emit UnregisterScheme(msg.sender, _scheme);
1244         delete schemes[_scheme];
1245         return true;
1246     }
1247 
1248     /**
1249      * @dev unregister the caller's scheme
1250      * @return bool which represents a success
1251      */
1252     function unregisterSelf(address _avatar) external isAvatarValid(_avatar) returns(bool) {
1253         if (_isSchemeRegistered(msg.sender) == false) {
1254             return false;
1255         }
1256         delete schemes[msg.sender];
1257         emit UnregisterScheme(msg.sender, msg.sender);
1258         return true;
1259     }
1260 
1261     /**
1262      * @dev add or update Global Constraint
1263      * @param _globalConstraint the address of the global constraint to be added.
1264      * @param _params the constraint parameters hash.
1265      * @return bool which represents a success
1266      */
1267     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
1268     external
1269     onlyGlobalConstraintsScheme
1270     isAvatarValid(_avatar)
1271     returns(bool)
1272     {
1273         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1274         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1275             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1276             if (!globalConstraintsRegisterPre[_globalConstraint].isRegistered) {
1277                 globalConstraintsPre.push(GlobalConstraint(_globalConstraint, _params));
1278                 globalConstraintsRegisterPre[_globalConstraint] =
1279                 GlobalConstraintRegister(true, globalConstraintsPre.length-1);
1280             }else {
1281                 globalConstraintsPre[globalConstraintsRegisterPre[_globalConstraint].index].params = _params;
1282             }
1283         }
1284         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1285             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1286             if (!globalConstraintsRegisterPost[_globalConstraint].isRegistered) {
1287                 globalConstraintsPost.push(GlobalConstraint(_globalConstraint, _params));
1288                 globalConstraintsRegisterPost[_globalConstraint] =
1289                 GlobalConstraintRegister(true, globalConstraintsPost.length-1);
1290             }else {
1291                 globalConstraintsPost[globalConstraintsRegisterPost[_globalConstraint].index].params = _params;
1292             }
1293         }
1294         emit AddGlobalConstraint(_globalConstraint, _params, when);
1295         return true;
1296     }
1297 
1298     /**
1299      * @dev remove Global Constraint
1300      * @param _globalConstraint the address of the global constraint to be remove.
1301      * @return bool which represents a success
1302      */
1303      // solhint-disable-next-line code-complexity
1304     function removeGlobalConstraint (address _globalConstraint, address _avatar)
1305     external
1306     onlyGlobalConstraintsScheme
1307     isAvatarValid(_avatar)
1308     returns(bool)
1309     {
1310         GlobalConstraintRegister memory globalConstraintRegister;
1311         GlobalConstraint memory globalConstraint;
1312         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1313         bool retVal = false;
1314 
1315         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1316             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1317             globalConstraintRegister = globalConstraintsRegisterPre[_globalConstraint];
1318             if (globalConstraintRegister.isRegistered) {
1319                 if (globalConstraintRegister.index < globalConstraintsPre.length-1) {
1320                     globalConstraint = globalConstraintsPre[globalConstraintsPre.length-1];
1321                     globalConstraintsPre[globalConstraintRegister.index] = globalConstraint;
1322                     globalConstraintsRegisterPre[globalConstraint.gcAddress].index = globalConstraintRegister.index;
1323                 }
1324                 globalConstraintsPre.length--;
1325                 delete globalConstraintsRegisterPre[_globalConstraint];
1326                 retVal = true;
1327             }
1328         }
1329         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1330             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1331             globalConstraintRegister = globalConstraintsRegisterPost[_globalConstraint];
1332             if (globalConstraintRegister.isRegistered) {
1333                 if (globalConstraintRegister.index < globalConstraintsPost.length-1) {
1334                     globalConstraint = globalConstraintsPost[globalConstraintsPost.length-1];
1335                     globalConstraintsPost[globalConstraintRegister.index] = globalConstraint;
1336                     globalConstraintsRegisterPost[globalConstraint.gcAddress].index = globalConstraintRegister.index;
1337                 }
1338                 globalConstraintsPost.length--;
1339                 delete globalConstraintsRegisterPost[_globalConstraint];
1340                 retVal = true;
1341             }
1342         }
1343         if (retVal) {
1344             emit RemoveGlobalConstraint(
1345             _globalConstraint,
1346             globalConstraintRegister.index,
1347             when == GlobalConstraintInterface.CallPhase.Pre
1348             );
1349         }
1350         return retVal;
1351     }
1352 
1353   /**
1354     * @dev upgrade the Controller
1355     *      The function will trigger an event 'UpgradeController'.
1356     * @param  _newController the address of the new controller.
1357     * @return bool which represents a success
1358     */
1359     function upgradeController(address _newController, Avatar _avatar)
1360     external
1361     onlyUpgradingScheme
1362     isAvatarValid(address(_avatar))
1363     returns(bool)
1364     {
1365         require(newController == address(0));   // so the upgrade could be done once for a contract.
1366         require(_newController != address(0));
1367         newController = _newController;
1368         avatar.transferOwnership(_newController);
1369         require(avatar.owner() == _newController);
1370         if (nativeToken.owner() == address(this)) {
1371             nativeToken.transferOwnership(_newController);
1372             require(nativeToken.owner() == _newController);
1373         }
1374         if (nativeReputation.owner() == address(this)) {
1375             nativeReputation.transferOwnership(_newController);
1376             require(nativeReputation.owner() == _newController);
1377         }
1378         emit UpgradeController(address(this), newController);
1379         return true;
1380     }
1381 
1382     /**
1383     * @dev perform a generic call to an arbitrary contract
1384     * @param _contract  the contract's address to call
1385     * @param _data ABI-encoded contract call to call `_contract` address.
1386     * @param _avatar the controller's avatar address
1387     * @return bool -success
1388     *         bytes  - the return value of the called _contract's function.
1389     */
1390     function genericCall(address _contract, bytes calldata _data, Avatar _avatar)
1391     external
1392     onlyGenericCallScheme
1393     onlySubjectToConstraint("genericCall")
1394     isAvatarValid(address(_avatar))
1395     returns (bool, bytes memory)
1396     {
1397         return avatar.genericCall(_contract, _data);
1398     }
1399 
1400   /**
1401    * @dev send some ether
1402    * @param _amountInWei the amount of ether (in Wei) to send
1403    * @param _to address of the beneficiary
1404    * @return bool which represents a success
1405    */
1406     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
1407     external
1408     onlyRegisteredScheme
1409     onlySubjectToConstraint("sendEther")
1410     isAvatarValid(address(_avatar))
1411     returns(bool)
1412     {
1413         return avatar.sendEther(_amountInWei, _to);
1414     }
1415 
1416     /**
1417     * @dev send some amount of arbitrary ERC20 Tokens
1418     * @param _externalToken the address of the Token Contract
1419     * @param _to address of the beneficiary
1420     * @param _value the amount of ether (in Wei) to send
1421     * @return bool which represents a success
1422     */
1423     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1424     external
1425     onlyRegisteredScheme
1426     onlySubjectToConstraint("externalTokenTransfer")
1427     isAvatarValid(address(_avatar))
1428     returns(bool)
1429     {
1430         return avatar.externalTokenTransfer(_externalToken, _to, _value);
1431     }
1432 
1433     /**
1434     * @dev transfer token "from" address "to" address
1435     *      One must to approve the amount of tokens which can be spend from the
1436     *      "from" account.This can be done using externalTokenApprove.
1437     * @param _externalToken the address of the Token Contract
1438     * @param _from address of the account to send from
1439     * @param _to address of the beneficiary
1440     * @param _value the amount of ether (in Wei) to send
1441     * @return bool which represents a success
1442     */
1443     function externalTokenTransferFrom(
1444     IERC20 _externalToken,
1445     address _from,
1446     address _to,
1447     uint256 _value,
1448     Avatar _avatar)
1449     external
1450     onlyRegisteredScheme
1451     onlySubjectToConstraint("externalTokenTransferFrom")
1452     isAvatarValid(address(_avatar))
1453     returns(bool)
1454     {
1455         return avatar.externalTokenTransferFrom(_externalToken, _from, _to, _value);
1456     }
1457 
1458     /**
1459     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1460     *      on behalf of msg.sender.
1461     * @param _externalToken the address of the Token Contract
1462     * @param _spender address
1463     * @param _value the amount of ether (in Wei) which the approval is referring to.
1464     * @return bool which represents a success
1465     */
1466     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1467     external
1468     onlyRegisteredScheme
1469     onlySubjectToConstraint("externalTokenIncreaseApproval")
1470     isAvatarValid(address(_avatar))
1471     returns(bool)
1472     {
1473         return avatar.externalTokenApproval(_externalToken, _spender, _value);
1474     }
1475 
1476     /**
1477      * @dev getNativeReputation
1478      * @param _avatar the organization avatar.
1479      * @return organization native reputation
1480      */
1481     function getNativeReputation(address _avatar) external isAvatarValid(_avatar) view returns(address) {
1482         return address(nativeReputation);
1483     }
1484 
1485     function isSchemeRegistered(address _scheme, address _avatar) external isAvatarValid(_avatar) view returns(bool) {
1486         return _isSchemeRegistered(_scheme);
1487     }
1488 
1489     function getSchemeParameters(address _scheme, address _avatar)
1490     external
1491     isAvatarValid(_avatar)
1492     view
1493     returns(bytes32)
1494     {
1495         return schemes[_scheme].paramsHash;
1496     }
1497 
1498     function getSchemePermissions(address _scheme, address _avatar)
1499     external
1500     isAvatarValid(_avatar)
1501     view
1502     returns(bytes4)
1503     {
1504         return schemes[_scheme].permissions;
1505     }
1506 
1507     function getGlobalConstraintParameters(address _globalConstraint, address) external view returns(bytes32) {
1508 
1509         GlobalConstraintRegister memory register = globalConstraintsRegisterPre[_globalConstraint];
1510 
1511         if (register.isRegistered) {
1512             return globalConstraintsPre[register.index].params;
1513         }
1514 
1515         register = globalConstraintsRegisterPost[_globalConstraint];
1516 
1517         if (register.isRegistered) {
1518             return globalConstraintsPost[register.index].params;
1519         }
1520     }
1521 
1522    /**
1523     * @dev globalConstraintsCount return the global constraint pre and post count
1524     * @return uint256 globalConstraintsPre count.
1525     * @return uint256 globalConstraintsPost count.
1526     */
1527     function globalConstraintsCount(address _avatar)
1528         external
1529         isAvatarValid(_avatar)
1530         view
1531         returns(uint, uint)
1532         {
1533         return (globalConstraintsPre.length, globalConstraintsPost.length);
1534     }
1535 
1536     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar)
1537         external
1538         isAvatarValid(_avatar)
1539         view
1540         returns(bool)
1541         {
1542         return (globalConstraintsRegisterPre[_globalConstraint].isRegistered ||
1543                 globalConstraintsRegisterPost[_globalConstraint].isRegistered);
1544     }
1545 
1546     function _isSchemeRegistered(address _scheme) private view returns(bool) {
1547         return (schemes[_scheme].permissions&bytes4(0x00000001) != bytes4(0));
1548     }
1549 }
1550 
1551 // File: contracts/DxController.sol
1552 
1553 contract DxController is Controller {
1554     constructor(Avatar _avatar) public Controller(_avatar) {}
1555 }