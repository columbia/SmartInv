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
249 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
273 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
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
339 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
549 
550 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/controller/DAOToken.sol
551 
552 /**
553  * @title DAOToken, base on zeppelin contract.
554  * @dev ERC20 compatible token. It is a mintable, burnable token.
555  */
556 
557 contract DAOToken is ERC20, ERC20Burnable, Ownable {
558 
559     string public name;
560     string public symbol;
561     // solhint-disable-next-line const-name-snakecase
562     uint8 public constant decimals = 18;
563     uint256 public cap;
564 
565     /**
566     * @dev Constructor
567     * @param _name - token name
568     * @param _symbol - token symbol
569     * @param _cap - token cap - 0 value means no cap
570     */
571     constructor(string memory _name, string memory _symbol, uint256 _cap)
572     public {
573         name = _name;
574         symbol = _symbol;
575         cap = _cap;
576     }
577 
578     /**
579      * @dev Function to mint tokens
580      * @param _to The address that will receive the minted tokens.
581      * @param _amount The amount of tokens to mint.
582      */
583     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
584         if (cap > 0)
585             require(totalSupply().add(_amount) <= cap);
586         _mint(_to, _amount);
587         return true;
588     }
589 }
590 
591 // File: openzeppelin-solidity/contracts/utils/Address.sol
592 
593 /**
594  * Utility library of inline functions on addresses
595  */
596 library Address {
597     /**
598      * Returns whether the target address is a contract
599      * @dev This function will return false if invoked during the constructor of a contract,
600      * as the code is not actually created until after the constructor finishes.
601      * @param account address of the account to check
602      * @return whether the target address is a contract
603      */
604     function isContract(address account) internal view returns (bool) {
605         uint256 size;
606         // XXX Currently there is no better way to check if there is a contract in an address
607         // than to check the size of the code at that address.
608         // See https://ethereum.stackexchange.com/a/14016/36603
609         // for more details about how this works.
610         // TODO Check this again before the Serenity release, because all addresses will be
611         // contracts then.
612         // solhint-disable-next-line no-inline-assembly
613         assembly { size := extcodesize(account) }
614         return size > 0;
615     }
616 }
617 
618 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/libs/SafeERC20.sol
619 
620 /*
621 
622 SafeERC20 by daostack.
623 The code is based on a fix by SECBIT Team.
624 
625 USE WITH CAUTION & NO WARRANTY
626 
627 REFERENCE & RELATED READING
628 - https://github.com/ethereum/solidity/issues/4116
629 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
630 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
631 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
632 
633 */
634 
635 library SafeERC20 {
636     using Address for address;
637 
638     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
639     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
640     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
641 
642     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
643 
644         // Must be a contract addr first!
645         require(_erc20Addr.isContract());
646 
647         (bool success, bytes memory returnValue) =
648         // solhint-disable-next-line avoid-low-level-calls
649         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
650         // call return false when something wrong
651         require(success);
652         //check return value
653         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
654     }
655 
656     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
657 
658         // Must be a contract addr first!
659         require(_erc20Addr.isContract());
660 
661         (bool success, bytes memory returnValue) =
662         // solhint-disable-next-line avoid-low-level-calls
663         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
664         // call return false when something wrong
665         require(success);
666         //check return value
667         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
668     }
669 
670     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
671 
672         // Must be a contract addr first!
673         require(_erc20Addr.isContract());
674 
675         // safeApprove should only be called when setting an initial allowance,
676         // or when resetting it to zero.
677         require((_value == 0) || (IERC20(_erc20Addr).allowance(msg.sender, _spender) == 0));
678 
679         (bool success, bytes memory returnValue) =
680         // solhint-disable-next-line avoid-low-level-calls
681         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
682         // call return false when something wrong
683         require(success);
684         //check return value
685         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
686     }
687 }
688 
689 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/controller/Avatar.sol
690 
691 /**
692  * @title An Avatar holds tokens, reputation and ether for a controller
693  */
694 contract Avatar is Ownable {
695     using SafeERC20 for address;
696 
697     string public orgName;
698     DAOToken public nativeToken;
699     Reputation public nativeReputation;
700 
701     event GenericCall(address indexed _contract, bytes _params, bool _success);
702     event SendEther(uint256 _amountInWei, address indexed _to);
703     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint256 _value);
704     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint256 _value);
705     event ExternalTokenApproval(address indexed _externalToken, address _spender, uint256 _value);
706     event ReceiveEther(address indexed _sender, uint256 _value);
707 
708     /**
709     * @dev the constructor takes organization name, native token and reputation system
710     and creates an avatar for a controller
711     */
712     constructor(string memory _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
713         orgName = _orgName;
714         nativeToken = _nativeToken;
715         nativeReputation = _nativeReputation;
716     }
717 
718     /**
719     * @dev enables an avatar to receive ethers
720     */
721     function() external payable {
722         emit ReceiveEther(msg.sender, msg.value);
723     }
724 
725     /**
726     * @dev perform a generic call to an arbitrary contract
727     * @param _contract  the contract's address to call
728     * @param _data ABI-encoded contract call to call `_contract` address.
729     * @return bool    success or fail
730     *         bytes - the return bytes of the called contract's function.
731     */
732     function genericCall(address _contract, bytes memory _data)
733     public
734     onlyOwner
735     returns(bool success, bytes memory returnValue) {
736       // solhint-disable-next-line avoid-low-level-calls
737         (success, returnValue) = _contract.call(_data);
738         emit GenericCall(_contract, _data, success);
739     }
740 
741     /**
742     * @dev send ethers from the avatar's wallet
743     * @param _amountInWei amount to send in Wei units
744     * @param _to send the ethers to this address
745     * @return bool which represents success
746     */
747     function sendEther(uint256 _amountInWei, address payable _to) public onlyOwner returns(bool) {
748         _to.transfer(_amountInWei);
749         emit SendEther(_amountInWei, _to);
750         return true;
751     }
752 
753     /**
754     * @dev external token transfer
755     * @param _externalToken the token contract
756     * @param _to the destination address
757     * @param _value the amount of tokens to transfer
758     * @return bool which represents success
759     */
760     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
761     public onlyOwner returns(bool)
762     {
763         address(_externalToken).safeTransfer(_to, _value);
764         emit ExternalTokenTransfer(address(_externalToken), _to, _value);
765         return true;
766     }
767 
768     /**
769     * @dev external token transfer from a specific account
770     * @param _externalToken the token contract
771     * @param _from the account to spend token from
772     * @param _to the destination address
773     * @param _value the amount of tokens to transfer
774     * @return bool which represents success
775     */
776     function externalTokenTransferFrom(
777         IERC20 _externalToken,
778         address _from,
779         address _to,
780         uint256 _value
781     )
782     public onlyOwner returns(bool)
783     {
784         address(_externalToken).safeTransferFrom(_from, _to, _value);
785         emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
786         return true;
787     }
788 
789     /**
790     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
791     *      on behalf of msg.sender.
792     * @param _externalToken the address of the Token Contract
793     * @param _spender address
794     * @param _value the amount of ether (in Wei) which the approval is referring to.
795     * @return bool which represents a success
796     */
797     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
798     public onlyOwner returns(bool)
799     {
800         address(_externalToken).safeApprove(_spender, _value);
801         emit ExternalTokenApproval(address(_externalToken), _spender, _value);
802         return true;
803     }
804 
805 }
806 
807 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/globalConstraints/GlobalConstraintInterface.sol
808 
809 contract GlobalConstraintInterface {
810 
811     enum CallPhase { Pre, Post, PreAndPost }
812 
813     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
814     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
815     /**
816      * @dev when return if this globalConstraints is pre, post or both.
817      * @return CallPhase enum indication  Pre, Post or PreAndPost.
818      */
819     function when() public returns(CallPhase);
820 }
821 
822 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/controller/ControllerInterface.sol
823 
824 /**
825  * @title Controller contract
826  * @dev A controller controls the organizations tokens ,reputation and avatar.
827  * It is subject to a set of schemes and constraints that determine its behavior.
828  * Each scheme has it own parameters and operation permissions.
829  */
830 interface ControllerInterface {
831 
832     /**
833      * @dev Mint `_amount` of reputation that are assigned to `_to` .
834      * @param  _amount amount of reputation to mint
835      * @param _to beneficiary address
836      * @return bool which represents a success
837     */
838     function mintReputation(uint256 _amount, address _to, address _avatar)
839     external
840     returns(bool);
841 
842     /**
843      * @dev Burns `_amount` of reputation from `_from`
844      * @param _amount amount of reputation to burn
845      * @param _from The address that will lose the reputation
846      * @return bool which represents a success
847      */
848     function burnReputation(uint256 _amount, address _from, address _avatar)
849     external
850     returns(bool);
851 
852     /**
853      * @dev mint tokens .
854      * @param  _amount amount of token to mint
855      * @param _beneficiary beneficiary address
856      * @param _avatar address
857      * @return bool which represents a success
858      */
859     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
860     external
861     returns(bool);
862 
863   /**
864    * @dev register or update a scheme
865    * @param _scheme the address of the scheme
866    * @param _paramsHash a hashed configuration of the usage of the scheme
867    * @param _permissions the permissions the new scheme will have
868    * @param _avatar address
869    * @return bool which represents a success
870    */
871     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
872     external
873     returns(bool);
874 
875     /**
876      * @dev unregister a scheme
877      * @param _avatar address
878      * @param _scheme the address of the scheme
879      * @return bool which represents a success
880      */
881     function unregisterScheme(address _scheme, address _avatar)
882     external
883     returns(bool);
884 
885     /**
886      * @dev unregister the caller's scheme
887      * @param _avatar address
888      * @return bool which represents a success
889      */
890     function unregisterSelf(address _avatar) external returns(bool);
891 
892     /**
893      * @dev add or update Global Constraint
894      * @param _globalConstraint the address of the global constraint to be added.
895      * @param _params the constraint parameters hash.
896      * @param _avatar the avatar of the organization
897      * @return bool which represents a success
898      */
899     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
900     external returns(bool);
901 
902     /**
903      * @dev remove Global Constraint
904      * @param _globalConstraint the address of the global constraint to be remove.
905      * @param _avatar the organization avatar.
906      * @return bool which represents a success
907      */
908     function removeGlobalConstraint (address _globalConstraint, address _avatar)
909     external  returns(bool);
910 
911   /**
912     * @dev upgrade the Controller
913     *      The function will trigger an event 'UpgradeController'.
914     * @param  _newController the address of the new controller.
915     * @param _avatar address
916     * @return bool which represents a success
917     */
918     function upgradeController(address _newController, Avatar _avatar)
919     external returns(bool);
920 
921     /**
922     * @dev perform a generic call to an arbitrary contract
923     * @param _contract  the contract's address to call
924     * @param _data ABI-encoded contract call to call `_contract` address.
925     * @param _avatar the controller's avatar address
926     * @return bool -success
927     *         bytes  - the return value of the called _contract's function.
928     */
929     function genericCall(address _contract, bytes calldata _data, Avatar _avatar)
930     external
931     returns(bool, bytes memory);
932 
933   /**
934    * @dev send some ether
935    * @param _amountInWei the amount of ether (in Wei) to send
936    * @param _to address of the beneficiary
937    * @param _avatar address
938    * @return bool which represents a success
939    */
940     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
941     external returns(bool);
942 
943     /**
944     * @dev send some amount of arbitrary ERC20 Tokens
945     * @param _externalToken the address of the Token Contract
946     * @param _to address of the beneficiary
947     * @param _value the amount of ether (in Wei) to send
948     * @param _avatar address
949     * @return bool which represents a success
950     */
951     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
952     external
953     returns(bool);
954 
955     /**
956     * @dev transfer token "from" address "to" address
957     *      One must to approve the amount of tokens which can be spend from the
958     *      "from" account.This can be done using externalTokenApprove.
959     * @param _externalToken the address of the Token Contract
960     * @param _from address of the account to send from
961     * @param _to address of the beneficiary
962     * @param _value the amount of ether (in Wei) to send
963     * @param _avatar address
964     * @return bool which represents a success
965     */
966     function externalTokenTransferFrom(
967     IERC20 _externalToken,
968     address _from,
969     address _to,
970     uint256 _value,
971     Avatar _avatar)
972     external
973     returns(bool);
974 
975     /**
976     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
977     *      on behalf of msg.sender.
978     * @param _externalToken the address of the Token Contract
979     * @param _spender address
980     * @param _value the amount of ether (in Wei) which the approval is referring to.
981     * @return bool which represents a success
982     */
983     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
984     external
985     returns(bool);
986 
987     /**
988      * @dev getNativeReputation
989      * @param _avatar the organization avatar.
990      * @return organization native reputation
991      */
992     function getNativeReputation(address _avatar)
993     external
994     view
995     returns(address);
996 
997     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
998 
999     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1000 
1001     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1002 
1003     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1004 
1005     /**
1006      * @dev globalConstraintsCount return the global constraint pre and post count
1007      * @return uint256 globalConstraintsPre count.
1008      * @return uint256 globalConstraintsPost count.
1009      */
1010     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1011 
1012     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1013 }
1014 
1015 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/schemes/Locking4Reputation.sol
1016 
1017 /**
1018  * @title A locker contract
1019  */
1020 
1021 contract Locking4Reputation {
1022     using SafeMath for uint256;
1023 
1024     event Redeem(address indexed _beneficiary, uint256 _amount);
1025     event Release(bytes32 indexed _lockingId, address indexed _beneficiary, uint256 _amount);
1026     event Lock(address indexed _locker, bytes32 indexed _lockingId, uint256 _amount, uint256 _period);
1027 
1028     struct Locker {
1029         uint256 amount;
1030         uint256 releaseTime;
1031     }
1032 
1033     Avatar public avatar;
1034 
1035     // A mapping from lockers addresses their lock balances.
1036     mapping(address => mapping(bytes32=>Locker)) public lockers;
1037     // A mapping from lockers addresses to their scores.
1038     mapping(address => uint) public scores;
1039 
1040     uint256 public totalLocked;
1041     uint256 public totalLockedLeft;
1042     uint256 public totalScore;
1043     uint256 public lockingsCounter; // Total number of lockings
1044     uint256 public reputationReward;
1045     uint256 public reputationRewardLeft;
1046     uint256 public lockingEndTime;
1047     uint256 public maxLockingPeriod;
1048     uint256 public lockingStartTime;
1049     uint256 public redeemEnableTime;
1050 
1051     /**
1052      * @dev redeem reputation function
1053      * @param _beneficiary the beneficiary for the release
1054      * @return uint256 reputation rewarded
1055      */
1056     function redeem(address _beneficiary) public returns(uint256 reputation) {
1057         // solhint-disable-next-line not-rely-on-time
1058         require(block.timestamp > redeemEnableTime, "now > redeemEnableTime");
1059         require(scores[_beneficiary] > 0, "score should be > 0");
1060         uint256 score = scores[_beneficiary];
1061         scores[_beneficiary] = 0;
1062         uint256 repRelation = score.mul(reputationReward);
1063         reputation = repRelation.div(totalScore);
1064 
1065         //check that the reputation is sum zero
1066         reputationRewardLeft = reputationRewardLeft.sub(reputation);
1067         require(
1068         ControllerInterface(
1069         avatar.owner())
1070         .mintReputation(reputation, _beneficiary, address(avatar)), "mint reputation should succeed");
1071 
1072         emit Redeem(_beneficiary, reputation);
1073     }
1074 
1075     /**
1076      * @dev release function
1077      * @param _beneficiary the beneficiary for the release
1078      * @param _lockingId the locking id to release
1079      * @return bool
1080      */
1081     function _release(address _beneficiary, bytes32 _lockingId) internal returns(uint256 amount) {
1082         Locker storage locker = lockers[_beneficiary][_lockingId];
1083         require(locker.amount > 0, "amount should be > 0");
1084         amount = locker.amount;
1085         locker.amount = 0;
1086         // solhint-disable-next-line not-rely-on-time
1087         require(block.timestamp > locker.releaseTime, "check the lock period pass");
1088         totalLockedLeft = totalLockedLeft.sub(amount);
1089 
1090         emit Release(_lockingId, _beneficiary, amount);
1091     }
1092 
1093     /**
1094      * @dev lock function
1095      * @param _amount the amount to lock
1096      * @param _period the locking period
1097      * @param _locker the locker
1098      * @param _numerator price numerator
1099      * @param _denominator price denominator
1100      * @return lockingId
1101      */
1102     function _lock(
1103         uint256 _amount,
1104         uint256 _period,
1105         address _locker,
1106         uint256 _numerator,
1107         uint256 _denominator)
1108         internal
1109         returns(bytes32 lockingId)
1110         {
1111         require(_amount > 0, "locking amount should be > 0");
1112         require(_period <= maxLockingPeriod, "locking period should be <= maxLockingPeriod");
1113         require(_period > 0, "locking period should be > 0");
1114         // solhint-disable-next-line not-rely-on-time
1115         require(now <= lockingEndTime, "lock should be within the allowed locking period");
1116         // solhint-disable-next-line not-rely-on-time
1117         require(now >= lockingStartTime, "lock should start after lockingStartTime");
1118 
1119         lockingId = keccak256(abi.encodePacked(address(this), lockingsCounter));
1120         lockingsCounter = lockingsCounter.add(1);
1121 
1122         Locker storage locker = lockers[_locker][lockingId];
1123         locker.amount = _amount;
1124         // solhint-disable-next-line not-rely-on-time
1125         locker.releaseTime = now + _period;
1126         totalLocked = totalLocked.add(_amount);
1127         totalLockedLeft = totalLocked;
1128         uint256 score = _period.mul(_amount).mul(_numerator).div(_denominator);
1129         require(score > 0, "score must me > 0");
1130         scores[_locker] = scores[_locker].add(score);
1131         //verify that redeem will not overflow for this locker
1132         require((scores[_locker] * reputationReward)/scores[_locker] == reputationReward,
1133         "score is too high");
1134         totalScore = totalScore.add(score);
1135 
1136         emit Lock(_locker, lockingId, _amount, _period);
1137     }
1138 
1139     /**
1140      * @dev _initialize
1141      * @param _avatar the avatar to mint reputation from
1142      * @param _reputationReward the total reputation this contract will reward
1143      *        for eth/token locking
1144      * @param _lockingStartTime the locking start time.
1145      * @param _lockingEndTime the locking end time.
1146      *        locking is disable after this time.
1147      * @param _redeemEnableTime redeem enable time .
1148      *        redeem reputation can be done after this time.
1149      * @param _maxLockingPeriod maximum locking period allowed.
1150      */
1151     function _initialize(
1152         Avatar _avatar,
1153         uint256 _reputationReward,
1154         uint256 _lockingStartTime,
1155         uint256 _lockingEndTime,
1156         uint256 _redeemEnableTime,
1157         uint256 _maxLockingPeriod)
1158     internal
1159     {
1160         require(avatar == Avatar(0), "can be called only one time");
1161         require(_avatar != Avatar(0), "avatar cannot be zero");
1162         require(_lockingEndTime > _lockingStartTime, "locking end time should be greater than locking start time");
1163         require(_redeemEnableTime >= _lockingEndTime, "redeemEnableTime >= lockingEndTime");
1164 
1165         reputationReward = _reputationReward;
1166         reputationRewardLeft = _reputationReward;
1167         lockingEndTime = _lockingEndTime;
1168         maxLockingPeriod = _maxLockingPeriod;
1169         avatar = _avatar;
1170         lockingStartTime = _lockingStartTime;
1171         redeemEnableTime = _redeemEnableTime;
1172     }
1173 
1174 }
1175 
1176 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/schemes/PriceOracleInterface.sol
1177 
1178 interface PriceOracleInterface {
1179 
1180     function getPrice(address token) external view returns (uint, uint);
1181 
1182 }
1183 
1184 // File: @daostack/arc/contracts/schemes/LockingToken4Reputation.sol
1185 
1186 /**
1187  * @title A scheme for locking ERC20 Tokens for reputation
1188  */
1189 
1190 contract LockingToken4Reputation is Locking4Reputation, Ownable {
1191     using SafeERC20 for address;
1192 
1193     PriceOracleInterface public priceOracleContract;
1194     //      lockingId => token
1195     mapping(bytes32   => address) public lockedTokens;
1196 
1197     event LockToken(bytes32 indexed _lockingId, address indexed _token, uint256 _numerator, uint256 _denominator);
1198 
1199     /**
1200      * @dev initialize
1201      * @param _avatar the avatar to mint reputation from
1202      * @param _reputationReward the total reputation this contract will reward
1203      *        for the token locking
1204      * @param _lockingStartTime locking starting period time.
1205      * @param _lockingEndTime the locking end time.
1206      *        locking is disable after this time.
1207      * @param _redeemEnableTime redeem enable time .
1208      *        redeem reputation can be done after this time.
1209      * @param _maxLockingPeriod maximum locking period allowed.
1210      * @param _priceOracleContract the price oracle contract which the locked token will be
1211      *        validated against
1212      */
1213     function initialize(
1214         Avatar _avatar,
1215         uint256 _reputationReward,
1216         uint256 _lockingStartTime,
1217         uint256 _lockingEndTime,
1218         uint256 _redeemEnableTime,
1219         uint256 _maxLockingPeriod,
1220         PriceOracleInterface _priceOracleContract)
1221     external
1222     onlyOwner
1223     {
1224         priceOracleContract = _priceOracleContract;
1225         super._initialize(
1226         _avatar,
1227         _reputationReward,
1228         _lockingStartTime,
1229         _lockingEndTime,
1230         _redeemEnableTime,
1231         _maxLockingPeriod);
1232     }
1233 
1234     /**
1235      * @dev release locked tokens
1236      * @param _beneficiary the release _beneficiary
1237      * @param _lockingId the locking id
1238      * @return bool
1239      */
1240     function release(address _beneficiary, bytes32 _lockingId) public returns(bool) {
1241         uint256 amount = super._release(_beneficiary, _lockingId);
1242         lockedTokens[_lockingId].safeTransfer(_beneficiary, amount);
1243 
1244         return true;
1245     }
1246 
1247     /**
1248      * @dev lock function
1249      * @param _amount the amount to lock
1250      * @param _period the locking period
1251      * @param _token the token to lock - this should be whitelisted at the priceOracleContract
1252      * @return lockingId
1253      */
1254     function lock(uint256 _amount, uint256 _period, address _token) public returns(bytes32 lockingId) {
1255 
1256         uint256 numerator;
1257         uint256 denominator;
1258 
1259         (numerator, denominator) = priceOracleContract.getPrice(_token);
1260 
1261         require(numerator > 0, "numerator should be > 0");
1262         require(denominator > 0, "denominator should be > 0");
1263 
1264         _token.safeTransferFrom(msg.sender, address(this), _amount);
1265 
1266         lockingId = super._lock(_amount, _period, msg.sender, numerator, denominator);
1267 
1268         lockedTokens[lockingId] = _token;
1269 
1270         emit LockToken(lockingId, _token, numerator, denominator);
1271     }
1272 }
1273 
1274 // File: contracts/schemes/bootstrap/DxLockWhitelisted4Rep.sol
1275 
1276 /**
1277  * @title Scheme for locking GNO tokens for reputation
1278  */
1279 contract DxLockWhitelisted4Rep is LockingToken4Reputation {
1280     // TODO: Extend the new LockWhitelisted4Rep once it's implemented
1281     constructor() public {}
1282 }