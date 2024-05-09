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
549 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
550 
551 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/controller/DAOToken.sol
552 
553 /**
554  * @title DAOToken, base on zeppelin contract.
555  * @dev ERC20 compatible token. It is a mintable, burnable token.
556  */
557 
558 contract DAOToken is ERC20, ERC20Burnable, Ownable {
559 
560     string public name;
561     string public symbol;
562     // solhint-disable-next-line const-name-snakecase
563     uint8 public constant decimals = 18;
564     uint256 public cap;
565 
566     /**
567     * @dev Constructor
568     * @param _name - token name
569     * @param _symbol - token symbol
570     * @param _cap - token cap - 0 value means no cap
571     */
572     constructor(string memory _name, string memory _symbol, uint256 _cap)
573     public {
574         name = _name;
575         symbol = _symbol;
576         cap = _cap;
577     }
578 
579     /**
580      * @dev Function to mint tokens
581      * @param _to The address that will receive the minted tokens.
582      * @param _amount The amount of tokens to mint.
583      */
584     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
585         if (cap > 0)
586             require(totalSupply().add(_amount) <= cap);
587         _mint(_to, _amount);
588         return true;
589     }
590 }
591 
592 // File: openzeppelin-solidity/contracts/utils/Address.sol
593 
594 /**
595  * Utility library of inline functions on addresses
596  */
597 library Address {
598     /**
599      * Returns whether the target address is a contract
600      * @dev This function will return false if invoked during the constructor of a contract,
601      * as the code is not actually created until after the constructor finishes.
602      * @param account address of the account to check
603      * @return whether the target address is a contract
604      */
605     function isContract(address account) internal view returns (bool) {
606         uint256 size;
607         // XXX Currently there is no better way to check if there is a contract in an address
608         // than to check the size of the code at that address.
609         // See https://ethereum.stackexchange.com/a/14016/36603
610         // for more details about how this works.
611         // TODO Check this again before the Serenity release, because all addresses will be
612         // contracts then.
613         // solhint-disable-next-line no-inline-assembly
614         assembly { size := extcodesize(account) }
615         return size > 0;
616     }
617 }
618 
619 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/libs/SafeERC20.sol
620 
621 /*
622 
623 SafeERC20 by daostack.
624 The code is based on a fix by SECBIT Team.
625 
626 USE WITH CAUTION & NO WARRANTY
627 
628 REFERENCE & RELATED READING
629 - https://github.com/ethereum/solidity/issues/4116
630 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
631 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
632 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
633 
634 */
635 
636 library SafeERC20 {
637     using Address for address;
638 
639     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
640     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
641     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
642 
643     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
644 
645         // Must be a contract addr first!
646         require(_erc20Addr.isContract());
647 
648         (bool success, bytes memory returnValue) =
649         // solhint-disable-next-line avoid-low-level-calls
650         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
651         // call return false when something wrong
652         require(success);
653         //check return value
654         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
655     }
656 
657     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
658 
659         // Must be a contract addr first!
660         require(_erc20Addr.isContract());
661 
662         (bool success, bytes memory returnValue) =
663         // solhint-disable-next-line avoid-low-level-calls
664         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
665         // call return false when something wrong
666         require(success);
667         //check return value
668         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
669     }
670 
671     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
672 
673         // Must be a contract addr first!
674         require(_erc20Addr.isContract());
675 
676         // safeApprove should only be called when setting an initial allowance,
677         // or when resetting it to zero.
678         require((_value == 0) || (IERC20(_erc20Addr).allowance(msg.sender, _spender) == 0));
679 
680         (bool success, bytes memory returnValue) =
681         // solhint-disable-next-line avoid-low-level-calls
682         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
683         // call return false when something wrong
684         require(success);
685         //check return value
686         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
687     }
688 }
689 
690 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/controller/Avatar.sol
691 
692 /**
693  * @title An Avatar holds tokens, reputation and ether for a controller
694  */
695 contract Avatar is Ownable {
696     using SafeERC20 for address;
697 
698     string public orgName;
699     DAOToken public nativeToken;
700     Reputation public nativeReputation;
701 
702     event GenericCall(address indexed _contract, bytes _params, bool _success);
703     event SendEther(uint256 _amountInWei, address indexed _to);
704     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint256 _value);
705     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint256 _value);
706     event ExternalTokenApproval(address indexed _externalToken, address _spender, uint256 _value);
707     event ReceiveEther(address indexed _sender, uint256 _value);
708 
709     /**
710     * @dev the constructor takes organization name, native token and reputation system
711     and creates an avatar for a controller
712     */
713     constructor(string memory _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
714         orgName = _orgName;
715         nativeToken = _nativeToken;
716         nativeReputation = _nativeReputation;
717     }
718 
719     /**
720     * @dev enables an avatar to receive ethers
721     */
722     function() external payable {
723         emit ReceiveEther(msg.sender, msg.value);
724     }
725 
726     /**
727     * @dev perform a generic call to an arbitrary contract
728     * @param _contract  the contract's address to call
729     * @param _data ABI-encoded contract call to call `_contract` address.
730     * @return bool    success or fail
731     *         bytes - the return bytes of the called contract's function.
732     */
733     function genericCall(address _contract, bytes memory _data)
734     public
735     onlyOwner
736     returns(bool success, bytes memory returnValue) {
737       // solhint-disable-next-line avoid-low-level-calls
738         (success, returnValue) = _contract.call(_data);
739         emit GenericCall(_contract, _data, success);
740     }
741 
742     /**
743     * @dev send ethers from the avatar's wallet
744     * @param _amountInWei amount to send in Wei units
745     * @param _to send the ethers to this address
746     * @return bool which represents success
747     */
748     function sendEther(uint256 _amountInWei, address payable _to) public onlyOwner returns(bool) {
749         _to.transfer(_amountInWei);
750         emit SendEther(_amountInWei, _to);
751         return true;
752     }
753 
754     /**
755     * @dev external token transfer
756     * @param _externalToken the token contract
757     * @param _to the destination address
758     * @param _value the amount of tokens to transfer
759     * @return bool which represents success
760     */
761     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
762     public onlyOwner returns(bool)
763     {
764         address(_externalToken).safeTransfer(_to, _value);
765         emit ExternalTokenTransfer(address(_externalToken), _to, _value);
766         return true;
767     }
768 
769     /**
770     * @dev external token transfer from a specific account
771     * @param _externalToken the token contract
772     * @param _from the account to spend token from
773     * @param _to the destination address
774     * @param _value the amount of tokens to transfer
775     * @return bool which represents success
776     */
777     function externalTokenTransferFrom(
778         IERC20 _externalToken,
779         address _from,
780         address _to,
781         uint256 _value
782     )
783     public onlyOwner returns(bool)
784     {
785         address(_externalToken).safeTransferFrom(_from, _to, _value);
786         emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
787         return true;
788     }
789 
790     /**
791     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
792     *      on behalf of msg.sender.
793     * @param _externalToken the address of the Token Contract
794     * @param _spender address
795     * @param _value the amount of ether (in Wei) which the approval is referring to.
796     * @return bool which represents a success
797     */
798     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
799     public onlyOwner returns(bool)
800     {
801         address(_externalToken).safeApprove(_spender, _value);
802         emit ExternalTokenApproval(address(_externalToken), _spender, _value);
803         return true;
804     }
805 
806 }
807 
808 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/globalConstraints/GlobalConstraintInterface.sol
809 
810 contract GlobalConstraintInterface {
811 
812     enum CallPhase { Pre, Post, PreAndPost }
813 
814     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
815     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
816     /**
817      * @dev when return if this globalConstraints is pre, post or both.
818      * @return CallPhase enum indication  Pre, Post or PreAndPost.
819      */
820     function when() public returns(CallPhase);
821 }
822 
823 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/controller/ControllerInterface.sol
824 
825 /**
826  * @title Controller contract
827  * @dev A controller controls the organizations tokens ,reputation and avatar.
828  * It is subject to a set of schemes and constraints that determine its behavior.
829  * Each scheme has it own parameters and operation permissions.
830  */
831 interface ControllerInterface {
832 
833     /**
834      * @dev Mint `_amount` of reputation that are assigned to `_to` .
835      * @param  _amount amount of reputation to mint
836      * @param _to beneficiary address
837      * @return bool which represents a success
838     */
839     function mintReputation(uint256 _amount, address _to, address _avatar)
840     external
841     returns(bool);
842 
843     /**
844      * @dev Burns `_amount` of reputation from `_from`
845      * @param _amount amount of reputation to burn
846      * @param _from The address that will lose the reputation
847      * @return bool which represents a success
848      */
849     function burnReputation(uint256 _amount, address _from, address _avatar)
850     external
851     returns(bool);
852 
853     /**
854      * @dev mint tokens .
855      * @param  _amount amount of token to mint
856      * @param _beneficiary beneficiary address
857      * @param _avatar address
858      * @return bool which represents a success
859      */
860     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
861     external
862     returns(bool);
863 
864   /**
865    * @dev register or update a scheme
866    * @param _scheme the address of the scheme
867    * @param _paramsHash a hashed configuration of the usage of the scheme
868    * @param _permissions the permissions the new scheme will have
869    * @param _avatar address
870    * @return bool which represents a success
871    */
872     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
873     external
874     returns(bool);
875 
876     /**
877      * @dev unregister a scheme
878      * @param _avatar address
879      * @param _scheme the address of the scheme
880      * @return bool which represents a success
881      */
882     function unregisterScheme(address _scheme, address _avatar)
883     external
884     returns(bool);
885 
886     /**
887      * @dev unregister the caller's scheme
888      * @param _avatar address
889      * @return bool which represents a success
890      */
891     function unregisterSelf(address _avatar) external returns(bool);
892 
893     /**
894      * @dev add or update Global Constraint
895      * @param _globalConstraint the address of the global constraint to be added.
896      * @param _params the constraint parameters hash.
897      * @param _avatar the avatar of the organization
898      * @return bool which represents a success
899      */
900     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
901     external returns(bool);
902 
903     /**
904      * @dev remove Global Constraint
905      * @param _globalConstraint the address of the global constraint to be remove.
906      * @param _avatar the organization avatar.
907      * @return bool which represents a success
908      */
909     function removeGlobalConstraint (address _globalConstraint, address _avatar)
910     external  returns(bool);
911 
912   /**
913     * @dev upgrade the Controller
914     *      The function will trigger an event 'UpgradeController'.
915     * @param  _newController the address of the new controller.
916     * @param _avatar address
917     * @return bool which represents a success
918     */
919     function upgradeController(address _newController, Avatar _avatar)
920     external returns(bool);
921 
922     /**
923     * @dev perform a generic call to an arbitrary contract
924     * @param _contract  the contract's address to call
925     * @param _data ABI-encoded contract call to call `_contract` address.
926     * @param _avatar the controller's avatar address
927     * @return bool -success
928     *         bytes  - the return value of the called _contract's function.
929     */
930     function genericCall(address _contract, bytes calldata _data, Avatar _avatar)
931     external
932     returns(bool, bytes memory);
933 
934   /**
935    * @dev send some ether
936    * @param _amountInWei the amount of ether (in Wei) to send
937    * @param _to address of the beneficiary
938    * @param _avatar address
939    * @return bool which represents a success
940    */
941     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
942     external returns(bool);
943 
944     /**
945     * @dev send some amount of arbitrary ERC20 Tokens
946     * @param _externalToken the address of the Token Contract
947     * @param _to address of the beneficiary
948     * @param _value the amount of ether (in Wei) to send
949     * @param _avatar address
950     * @return bool which represents a success
951     */
952     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
953     external
954     returns(bool);
955 
956     /**
957     * @dev transfer token "from" address "to" address
958     *      One must to approve the amount of tokens which can be spend from the
959     *      "from" account.This can be done using externalTokenApprove.
960     * @param _externalToken the address of the Token Contract
961     * @param _from address of the account to send from
962     * @param _to address of the beneficiary
963     * @param _value the amount of ether (in Wei) to send
964     * @param _avatar address
965     * @return bool which represents a success
966     */
967     function externalTokenTransferFrom(
968     IERC20 _externalToken,
969     address _from,
970     address _to,
971     uint256 _value,
972     Avatar _avatar)
973     external
974     returns(bool);
975 
976     /**
977     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
978     *      on behalf of msg.sender.
979     * @param _externalToken the address of the Token Contract
980     * @param _spender address
981     * @param _value the amount of ether (in Wei) which the approval is referring to.
982     * @return bool which represents a success
983     */
984     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
985     external
986     returns(bool);
987 
988     /**
989      * @dev getNativeReputation
990      * @param _avatar the organization avatar.
991      * @return organization native reputation
992      */
993     function getNativeReputation(address _avatar)
994     external
995     view
996     returns(address);
997 
998     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
999 
1000     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1001 
1002     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1003 
1004     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1005 
1006     /**
1007      * @dev globalConstraintsCount return the global constraint pre and post count
1008      * @return uint256 globalConstraintsPre count.
1009      * @return uint256 globalConstraintsPost count.
1010      */
1011     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1012 
1013     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1014 }
1015 
1016 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/@daostack/arc/contracts/schemes/Locking4Reputation.sol
1017 
1018 /**
1019  * @title A locker contract
1020  */
1021 
1022 contract Locking4Reputation {
1023     using SafeMath for uint256;
1024 
1025     event Redeem(address indexed _beneficiary, uint256 _amount);
1026     event Release(bytes32 indexed _lockingId, address indexed _beneficiary, uint256 _amount);
1027     event Lock(address indexed _locker, bytes32 indexed _lockingId, uint256 _amount, uint256 _period);
1028 
1029     struct Locker {
1030         uint256 amount;
1031         uint256 releaseTime;
1032     }
1033 
1034     Avatar public avatar;
1035 
1036     // A mapping from lockers addresses their lock balances.
1037     mapping(address => mapping(bytes32=>Locker)) public lockers;
1038     // A mapping from lockers addresses to their scores.
1039     mapping(address => uint) public scores;
1040 
1041     uint256 public totalLocked;
1042     uint256 public totalLockedLeft;
1043     uint256 public totalScore;
1044     uint256 public lockingsCounter; // Total number of lockings
1045     uint256 public reputationReward;
1046     uint256 public reputationRewardLeft;
1047     uint256 public lockingEndTime;
1048     uint256 public maxLockingPeriod;
1049     uint256 public lockingStartTime;
1050     uint256 public redeemEnableTime;
1051 
1052     /**
1053      * @dev redeem reputation function
1054      * @param _beneficiary the beneficiary for the release
1055      * @return uint256 reputation rewarded
1056      */
1057     function redeem(address _beneficiary) public returns(uint256 reputation) {
1058         // solhint-disable-next-line not-rely-on-time
1059         require(block.timestamp > redeemEnableTime, "now > redeemEnableTime");
1060         require(scores[_beneficiary] > 0, "score should be > 0");
1061         uint256 score = scores[_beneficiary];
1062         scores[_beneficiary] = 0;
1063         uint256 repRelation = score.mul(reputationReward);
1064         reputation = repRelation.div(totalScore);
1065 
1066         //check that the reputation is sum zero
1067         reputationRewardLeft = reputationRewardLeft.sub(reputation);
1068         require(
1069         ControllerInterface(
1070         avatar.owner())
1071         .mintReputation(reputation, _beneficiary, address(avatar)), "mint reputation should succeed");
1072 
1073         emit Redeem(_beneficiary, reputation);
1074     }
1075 
1076     /**
1077      * @dev release function
1078      * @param _beneficiary the beneficiary for the release
1079      * @param _lockingId the locking id to release
1080      * @return bool
1081      */
1082     function _release(address _beneficiary, bytes32 _lockingId) internal returns(uint256 amount) {
1083         Locker storage locker = lockers[_beneficiary][_lockingId];
1084         require(locker.amount > 0, "amount should be > 0");
1085         amount = locker.amount;
1086         locker.amount = 0;
1087         // solhint-disable-next-line not-rely-on-time
1088         require(block.timestamp > locker.releaseTime, "check the lock period pass");
1089         totalLockedLeft = totalLockedLeft.sub(amount);
1090 
1091         emit Release(_lockingId, _beneficiary, amount);
1092     }
1093 
1094     /**
1095      * @dev lock function
1096      * @param _amount the amount to lock
1097      * @param _period the locking period
1098      * @param _locker the locker
1099      * @param _numerator price numerator
1100      * @param _denominator price denominator
1101      * @return lockingId
1102      */
1103     function _lock(
1104         uint256 _amount,
1105         uint256 _period,
1106         address _locker,
1107         uint256 _numerator,
1108         uint256 _denominator)
1109         internal
1110         returns(bytes32 lockingId)
1111         {
1112         require(_amount > 0, "locking amount should be > 0");
1113         require(_period <= maxLockingPeriod, "locking period should be <= maxLockingPeriod");
1114         require(_period > 0, "locking period should be > 0");
1115         // solhint-disable-next-line not-rely-on-time
1116         require(now <= lockingEndTime, "lock should be within the allowed locking period");
1117         // solhint-disable-next-line not-rely-on-time
1118         require(now >= lockingStartTime, "lock should start after lockingStartTime");
1119 
1120         lockingId = keccak256(abi.encodePacked(address(this), lockingsCounter));
1121         lockingsCounter = lockingsCounter.add(1);
1122 
1123         Locker storage locker = lockers[_locker][lockingId];
1124         locker.amount = _amount;
1125         // solhint-disable-next-line not-rely-on-time
1126         locker.releaseTime = now + _period;
1127         totalLocked = totalLocked.add(_amount);
1128         totalLockedLeft = totalLocked;
1129         uint256 score = _period.mul(_amount).mul(_numerator).div(_denominator);
1130         require(score > 0, "score must me > 0");
1131         scores[_locker] = scores[_locker].add(score);
1132         //verify that redeem will not overflow for this locker
1133         require((scores[_locker] * reputationReward)/scores[_locker] == reputationReward,
1134         "score is too high");
1135         totalScore = totalScore.add(score);
1136 
1137         emit Lock(_locker, lockingId, _amount, _period);
1138     }
1139 
1140     /**
1141      * @dev _initialize
1142      * @param _avatar the avatar to mint reputation from
1143      * @param _reputationReward the total reputation this contract will reward
1144      *        for eth/token locking
1145      * @param _lockingStartTime the locking start time.
1146      * @param _lockingEndTime the locking end time.
1147      *        locking is disable after this time.
1148      * @param _redeemEnableTime redeem enable time .
1149      *        redeem reputation can be done after this time.
1150      * @param _maxLockingPeriod maximum locking period allowed.
1151      */
1152     function _initialize(
1153         Avatar _avatar,
1154         uint256 _reputationReward,
1155         uint256 _lockingStartTime,
1156         uint256 _lockingEndTime,
1157         uint256 _redeemEnableTime,
1158         uint256 _maxLockingPeriod)
1159     internal
1160     {
1161         require(avatar == Avatar(0), "can be called only one time");
1162         require(_avatar != Avatar(0), "avatar cannot be zero");
1163         require(_lockingEndTime > _lockingStartTime, "locking end time should be greater than locking start time");
1164         require(_redeemEnableTime >= _lockingEndTime, "redeemEnableTime >= lockingEndTime");
1165 
1166         reputationReward = _reputationReward;
1167         reputationRewardLeft = _reputationReward;
1168         lockingEndTime = _lockingEndTime;
1169         maxLockingPeriod = _maxLockingPeriod;
1170         avatar = _avatar;
1171         lockingStartTime = _lockingStartTime;
1172         redeemEnableTime = _redeemEnableTime;
1173     }
1174 
1175 }
1176 
1177 // File: @daostack/arc/contracts/schemes/ExternalLocking4Reputation.sol
1178 
1179 /**
1180  * @title A scheme for external locking Tokens for reputation
1181  */
1182 
1183 contract ExternalLocking4Reputation is Locking4Reputation, Ownable {
1184 
1185     event Register(address indexed _beneficiary);
1186 
1187     address public externalLockingContract;
1188     string public getBalanceFuncSignature;
1189 
1190     // locker -> bool
1191     mapping(address => bool) public externalLockers;
1192     //      beneficiary -> bool
1193     mapping(address     => bool) public registrar;
1194 
1195     /**
1196      * @dev initialize
1197      * @param _avatar the avatar to mint reputation from
1198      * @param _reputationReward the total reputation this contract will reward
1199      *        for the token locking
1200      * @param _claimingStartTime claiming starting period time.
1201      * @param _claimingEndTime the claiming end time.
1202      *        claiming is disable after this time.
1203      * @param _redeemEnableTime redeem enable time .
1204      *        redeem reputation can be done after this time.
1205      * @param _externalLockingContract the contract which lock the token.
1206      * @param _getBalanceFuncSignature get balance function signature
1207      *        e.g "lockedTokenBalances(address)"
1208      */
1209     function initialize(
1210         Avatar _avatar,
1211         uint256 _reputationReward,
1212         uint256 _claimingStartTime,
1213         uint256 _claimingEndTime,
1214         uint256 _redeemEnableTime,
1215         address _externalLockingContract,
1216         string calldata _getBalanceFuncSignature)
1217     external
1218     onlyOwner
1219     {
1220         require(_claimingEndTime > _claimingStartTime, "_claimingEndTime should be greater than _claimingStartTime");
1221         externalLockingContract = _externalLockingContract;
1222         getBalanceFuncSignature = _getBalanceFuncSignature;
1223         super._initialize(
1224         _avatar,
1225         _reputationReward,
1226         _claimingStartTime,
1227         _claimingEndTime,
1228         _redeemEnableTime,
1229         1);
1230     }
1231 
1232     /**
1233      * @dev claim function
1234      * @param _beneficiary the beneficiary address to claim for
1235      *        if _beneficiary == 0 the claim will be for the msg.sender.
1236      * @return claimId
1237      */
1238     function claim(address _beneficiary) public returns(bytes32) {
1239         require(avatar != Avatar(0), "should initialize first");
1240         address beneficiary;
1241         if (_beneficiary == address(0)) {
1242             beneficiary = msg.sender;
1243         } else {
1244             require(registrar[_beneficiary], "beneficiary should be register");
1245             beneficiary = _beneficiary;
1246         }
1247         require(externalLockers[beneficiary] == false, "claiming twice for the same beneficiary is not allowed");
1248         externalLockers[beneficiary] = true;
1249         (bool result, bytes memory returnValue) =
1250         // solhint-disable-next-line avoid-call-value,avoid-low-level-calls
1251         externalLockingContract.call(abi.encodeWithSignature(getBalanceFuncSignature, beneficiary));
1252         require(result, "call to external contract should succeed");
1253         uint256 lockedAmount;
1254         // solhint-disable-next-line no-inline-assembly
1255         assembly {
1256             lockedAmount := mload(add(returnValue, add(0x20, 0)))
1257         }
1258         return super._lock(lockedAmount, 1, beneficiary, 1, 1);
1259     }
1260 
1261    /**
1262     * @dev register function
1263     *      register for external locking claim
1264     */
1265     function register() public {
1266         registrar[msg.sender] = true;
1267         emit Register(msg.sender);
1268     }
1269 }
1270 
1271 // File: contracts/schemes/bootstrap/DxLockMgnForRep.sol
1272 
1273 /**
1274  * @title Scheme that allows to get GEN by locking MGN
1275  */
1276 contract DxLockMgnForRep is ExternalLocking4Reputation {
1277     constructor() public {}
1278 }