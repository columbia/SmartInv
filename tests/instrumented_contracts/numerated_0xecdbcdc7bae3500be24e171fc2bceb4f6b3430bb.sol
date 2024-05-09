1 pragma solidity ^0.5.2;
2 
3 // 
4 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12     address private _owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     constructor () internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @return the address of the owner.
27      */
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner());
37         _;
38     }
39 
40     /**
41      * @return true if `msg.sender` is the owner of the contract.
42      */
43     function isOwner() public view returns (bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Allows the current owner to relinquish control of the contract.
49      * @notice Renouncing to ownership will leave the contract without an owner.
50      * It will not be possible to call the functions with the `onlyOwner`
51      * modifier anymore.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: @daostack/infra/contracts/Reputation.sol
78 
79 /**
80  * @title Reputation system
81  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
82  * A reputation is use to assign influence measure to a DAO'S peers.
83  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
84  * The Reputation contract maintain a map of address to reputation value.
85  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
86  */
87 
88 contract Reputation is Ownable {
89 
90     uint8 public decimals = 18;             //Number of decimals of the smallest unit
91     // Event indicating minting of reputation to an address.
92     event Mint(address indexed _to, uint256 _amount);
93     // Event indicating burning of reputation for an address.
94     event Burn(address indexed _from, uint256 _amount);
95 
96       /// @dev `Checkpoint` is the structure that attaches a block number to a
97       ///  given value, the block number attached is the one that last changed the
98       ///  value
99     struct Checkpoint {
100 
101     // `fromBlock` is the block number that the value was generated from
102         uint128 fromBlock;
103 
104           // `value` is the amount of reputation at a specific block number
105         uint128 value;
106     }
107 
108       // `balances` is the map that tracks the balance of each address, in this
109       //  contract when the balance changes the block number that the change
110       //  occurred is also included in the map
111     mapping (address => Checkpoint[]) balances;
112 
113       // Tracks the history of the `totalSupply` of the reputation
114     Checkpoint[] totalSupplyHistory;
115 
116     /// @notice Constructor to create a Reputation
117     constructor(
118     ) public
119     {
120     }
121 
122     /// @dev This function makes it easy to get the total number of reputation
123     /// @return The total number of reputation
124     function totalSupply() public view returns (uint256) {
125         return totalSupplyAt(block.number);
126     }
127 
128   ////////////////
129   // Query balance and totalSupply in History
130   ////////////////
131     /**
132     * @dev return the reputation amount of a given owner
133     * @param _owner an address of the owner which we want to get his reputation
134     */
135     function balanceOf(address _owner) public view returns (uint256 balance) {
136         return balanceOfAt(_owner, block.number);
137     }
138 
139       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
140       /// @param _owner The address from which the balance will be retrieved
141       /// @param _blockNumber The block number when the balance is queried
142       /// @return The balance at `_blockNumber`
143     function balanceOfAt(address _owner, uint256 _blockNumber)
144     public view returns (uint256)
145     {
146         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
147             return 0;
148           // This will return the expected balance during normal situations
149         } else {
150             return getValueAt(balances[_owner], _blockNumber);
151         }
152     }
153 
154       /// @notice Total amount of reputation at a specific `_blockNumber`.
155       /// @param _blockNumber The block number when the totalSupply is queried
156       /// @return The total amount of reputation at `_blockNumber`
157     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
158         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
159             return 0;
160           // This will return the expected totalSupply during normal situations
161         } else {
162             return getValueAt(totalSupplyHistory, _blockNumber);
163         }
164     }
165 
166       /// @notice Generates `_amount` reputation that are assigned to `_owner`
167       /// @param _user The address that will be assigned the new reputation
168       /// @param _amount The quantity of reputation generated
169       /// @return True if the reputation are generated correctly
170     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
171         uint256 curTotalSupply = totalSupply();
172         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
173         uint256 previousBalanceTo = balanceOf(_user);
174         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
175         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
176         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
177         emit Mint(_user, _amount);
178         return true;
179     }
180 
181       /// @notice Burns `_amount` reputation from `_owner`
182       /// @param _user The address that will lose the reputation
183       /// @param _amount The quantity of reputation to burn
184       /// @return True if the reputation are burned correctly
185     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
186         uint256 curTotalSupply = totalSupply();
187         uint256 amountBurned = _amount;
188         uint256 previousBalanceFrom = balanceOf(_user);
189         if (previousBalanceFrom < amountBurned) {
190             amountBurned = previousBalanceFrom;
191         }
192         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
193         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
194         emit Burn(_user, amountBurned);
195         return true;
196     }
197 
198   ////////////////
199   // Internal helper functions to query and set a value in a snapshot array
200   ////////////////
201 
202       /// @dev `getValueAt` retrieves the number of reputation at a given block number
203       /// @param checkpoints The history of values being queried
204       /// @param _block The block number to retrieve the value at
205       /// @return The number of reputation being queried
206     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
207         if (checkpoints.length == 0) {
208             return 0;
209         }
210 
211           // Shortcut for the actual value
212         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
213             return checkpoints[checkpoints.length-1].value;
214         }
215         if (_block < checkpoints[0].fromBlock) {
216             return 0;
217         }
218 
219           // Binary search of the value in the array
220         uint256 min = 0;
221         uint256 max = checkpoints.length-1;
222         while (max > min) {
223             uint256 mid = (max + min + 1) / 2;
224             if (checkpoints[mid].fromBlock<=_block) {
225                 min = mid;
226             } else {
227                 max = mid-1;
228             }
229         }
230         return checkpoints[min].value;
231     }
232 
233       /// @dev `updateValueAtNow` used to update the `balances` map and the
234       ///  `totalSupplyHistory`
235       /// @param checkpoints The history of data being updated
236       /// @param _value The new number of reputation
237     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
238         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
239         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
240             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
241             newCheckPoint.fromBlock = uint128(block.number);
242             newCheckPoint.value = uint128(_value);
243         } else {
244             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
245             oldCheckPoint.value = uint128(_value);
246         }
247     }
248 }
249 
250 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
251 
252 /**
253  * @title ERC20 interface
254  * @dev see https://github.com/ethereum/EIPs/issues/20
255  */
256 interface IERC20 {
257     function transfer(address to, uint256 value) external returns (bool);
258 
259     function approve(address spender, uint256 value) external returns (bool);
260 
261     function transferFrom(address from, address to, uint256 value) external returns (bool);
262 
263     function totalSupply() external view returns (uint256);
264 
265     function balanceOf(address who) external view returns (uint256);
266 
267     function allowance(address owner, address spender) external view returns (uint256);
268 
269     event Transfer(address indexed from, address indexed to, uint256 value);
270 
271     event Approval(address indexed owner, address indexed spender, uint256 value);
272 }
273 
274 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
275 
276 /**
277  * @title SafeMath
278  * @dev Unsigned math operations with safety checks that revert on error
279  */
280 library SafeMath {
281     /**
282     * @dev Multiplies two unsigned integers, reverts on overflow.
283     */
284     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
285         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
286         // benefit is lost if 'b' is also tested.
287         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
288         if (a == 0) {
289             return 0;
290         }
291 
292         uint256 c = a * b;
293         require(c / a == b);
294 
295         return c;
296     }
297 
298     /**
299     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
300     */
301     function div(uint256 a, uint256 b) internal pure returns (uint256) {
302         // Solidity only automatically asserts when dividing by 0
303         require(b > 0);
304         uint256 c = a / b;
305         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
306 
307         return c;
308     }
309 
310     /**
311     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
312     */
313     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
314         require(b <= a);
315         uint256 c = a - b;
316 
317         return c;
318     }
319 
320     /**
321     * @dev Adds two unsigned integers, reverts on overflow.
322     */
323     function add(uint256 a, uint256 b) internal pure returns (uint256) {
324         uint256 c = a + b;
325         require(c >= a);
326 
327         return c;
328     }
329 
330     /**
331     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
332     * reverts when dividing by zero.
333     */
334     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
335         require(b != 0);
336         return a % b;
337     }
338 }
339 
340 // File: /Users/anxo/code/gnosis/dx-daostack/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
341 
342 /**
343  * @title Standard ERC20 token
344  *
345  * @dev Implementation of the basic standard token.
346  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
347  * Originally based on code by FirstBlood:
348  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
349  *
350  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
351  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
352  * compliant implementations may not do it.
353  */
354 contract ERC20 is IERC20 {
355     using SafeMath for uint256;
356 
357     mapping (address => uint256) private _balances;
358 
359     mapping (address => mapping (address => uint256)) private _allowed;
360 
361     uint256 private _totalSupply;
362 
363     /**
364     * @dev Total number of tokens in existence
365     */
366     function totalSupply() public view returns (uint256) {
367         return _totalSupply;
368     }
369 
370     /**
371     * @dev Gets the balance of the specified address.
372     * @param owner The address to query the balance of.
373     * @return An uint256 representing the amount owned by the passed address.
374     */
375     function balanceOf(address owner) public view returns (uint256) {
376         return _balances[owner];
377     }
378 
379     /**
380      * @dev Function to check the amount of tokens that an owner allowed to a spender.
381      * @param owner address The address which owns the funds.
382      * @param spender address The address which will spend the funds.
383      * @return A uint256 specifying the amount of tokens still available for the spender.
384      */
385     function allowance(address owner, address spender) public view returns (uint256) {
386         return _allowed[owner][spender];
387     }
388 
389     /**
390     * @dev Transfer token for a specified address
391     * @param to The address to transfer to.
392     * @param value The amount to be transferred.
393     */
394     function transfer(address to, uint256 value) public returns (bool) {
395         _transfer(msg.sender, to, value);
396         return true;
397     }
398 
399     /**
400      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
401      * Beware that changing an allowance with this method brings the risk that someone may use both the old
402      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
403      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
404      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
405      * @param spender The address which will spend the funds.
406      * @param value The amount of tokens to be spent.
407      */
408     function approve(address spender, uint256 value) public returns (bool) {
409         require(spender != address(0));
410 
411         _allowed[msg.sender][spender] = value;
412         emit Approval(msg.sender, spender, value);
413         return true;
414     }
415 
416     /**
417      * @dev Transfer tokens from one address to another.
418      * Note that while this function emits an Approval event, this is not required as per the specification,
419      * and other compliant implementations may not emit the event.
420      * @param from address The address which you want to send tokens from
421      * @param to address The address which you want to transfer to
422      * @param value uint256 the amount of tokens to be transferred
423      */
424     function transferFrom(address from, address to, uint256 value) public returns (bool) {
425         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
426         _transfer(from, to, value);
427         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
428         return true;
429     }
430 
431     /**
432      * @dev Increase the amount of tokens that an owner allowed to a spender.
433      * approve should be called when allowed_[_spender] == 0. To increment
434      * allowed value is better to use this function to avoid 2 calls (and wait until
435      * the first transaction is mined)
436      * From MonolithDAO Token.sol
437      * Emits an Approval event.
438      * @param spender The address which will spend the funds.
439      * @param addedValue The amount of tokens to increase the allowance by.
440      */
441     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
442         require(spender != address(0));
443 
444         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
445         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
446         return true;
447     }
448 
449     /**
450      * @dev Decrease the amount of tokens that an owner allowed to a spender.
451      * approve should be called when allowed_[_spender] == 0. To decrement
452      * allowed value is better to use this function to avoid 2 calls (and wait until
453      * the first transaction is mined)
454      * From MonolithDAO Token.sol
455      * Emits an Approval event.
456      * @param spender The address which will spend the funds.
457      * @param subtractedValue The amount of tokens to decrease the allowance by.
458      */
459     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
460         require(spender != address(0));
461 
462         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
463         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
464         return true;
465     }
466 
467     /**
468     * @dev Transfer token for a specified addresses
469     * @param from The address to transfer from.
470     * @param to The address to transfer to.
471     * @param value The amount to be transferred.
472     */
473     function _transfer(address from, address to, uint256 value) internal {
474         require(to != address(0));
475 
476         _balances[from] = _balances[from].sub(value);
477         _balances[to] = _balances[to].add(value);
478         emit Transfer(from, to, value);
479     }
480 
481     /**
482      * @dev Internal function that mints an amount of the token and assigns it to
483      * an account. This encapsulates the modification of balances such that the
484      * proper events are emitted.
485      * @param account The account that will receive the created tokens.
486      * @param value The amount that will be created.
487      */
488     function _mint(address account, uint256 value) internal {
489         require(account != address(0));
490 
491         _totalSupply = _totalSupply.add(value);
492         _balances[account] = _balances[account].add(value);
493         emit Transfer(address(0), account, value);
494     }
495 
496     /**
497      * @dev Internal function that burns an amount of the token of a given
498      * account.
499      * @param account The account whose tokens will be burnt.
500      * @param value The amount that will be burnt.
501      */
502     function _burn(address account, uint256 value) internal {
503         require(account != address(0));
504 
505         _totalSupply = _totalSupply.sub(value);
506         _balances[account] = _balances[account].sub(value);
507         emit Transfer(account, address(0), value);
508     }
509 
510     /**
511      * @dev Internal function that burns an amount of the token of a given
512      * account, deducting from the sender's allowance for said account. Uses the
513      * internal burn function.
514      * Emits an Approval event (reflecting the reduced allowance).
515      * @param account The account whose tokens will be burnt.
516      * @param value The amount that will be burnt.
517      */
518     function _burnFrom(address account, uint256 value) internal {
519         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
520         _burn(account, value);
521         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
522     }
523 }
524 
525 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
526 
527 /**
528  * @title Burnable Token
529  * @dev Token that can be irreversibly burned (destroyed).
530  */
531 contract ERC20Burnable is ERC20 {
532     /**
533      * @dev Burns a specific amount of tokens.
534      * @param value The amount of token to be burned.
535      */
536     function burn(uint256 value) public {
537         _burn(msg.sender, value);
538     }
539 
540     /**
541      * @dev Burns a specific amount of tokens from the target address and decrements allowance
542      * @param from address The address which you want to send tokens from
543      * @param value uint256 The amount of token to be burned
544      */
545     function burnFrom(address from, uint256 value) public {
546         _burnFrom(from, value);
547     }
548 }
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
1015 // File: @daostack/arc/contracts/schemes/Auction4Reputation.sol
1016 
1017 /**
1018  * @title A scheme for conduct ERC20 Tokens auction for reputation
1019  */
1020 
1021 
1022 contract Auction4Reputation is Ownable {
1023     using SafeMath for uint256;
1024     using SafeERC20 for address;
1025 
1026     event Bid(address indexed _bidder, uint256 indexed _auctionId, uint256 _amount);
1027     event Redeem(uint256 indexed _auctionId, address indexed _beneficiary, uint256 _amount);
1028 
1029     struct Auction {
1030         uint256 totalBid;
1031         // A mapping from bidder addresses to their bids.
1032         mapping(address=>uint) bids;
1033     }
1034 
1035     // A mapping from auction index to auction.
1036     mapping(uint=>Auction) public auctions;
1037 
1038     Avatar public avatar;
1039     uint256 public reputationRewardLeft;
1040     uint256 public auctionsEndTime;
1041     uint256 public auctionsStartTime;
1042     uint256 public numberOfAuctions;
1043     uint256 public auctionReputationReward;
1044     uint256 public auctionPeriod;
1045     uint256 public redeemEnableTime;
1046     IERC20 public token;
1047     address public wallet;
1048 
1049     /**
1050      * @dev initialize
1051      * @param _avatar the avatar to mint reputation from
1052      * @param _auctionReputationReward the reputation reward per auction this contract will reward
1053      *        for the token locking
1054      * @param _auctionsStartTime auctions period start time
1055      * @param _auctionPeriod auctions period time.
1056      *        auctionsEndTime is set to _auctionsStartTime + _auctionPeriod*_numberOfAuctions
1057      *        bidding is disable after auctionsEndTime.
1058      * @param _numberOfAuctions number of auctions.
1059      * @param _redeemEnableTime redeem enable time .
1060      *        redeem reputation can be done after this time.
1061      * @param _token the bidding token
1062      * @param  _wallet the address of the wallet the token will be transfer to.
1063      *         Please note that _wallet address should be a trusted account.
1064      *         Normally this address should be set as the DAO's avatar address.
1065      */
1066     function initialize(
1067         Avatar _avatar,
1068         uint256 _auctionReputationReward,
1069         uint256 _auctionsStartTime,
1070         uint256 _auctionPeriod,
1071         uint256 _numberOfAuctions,
1072         uint256 _redeemEnableTime,
1073         IERC20 _token,
1074         address _wallet)
1075     external
1076     onlyOwner
1077     {
1078         require(avatar == Avatar(0), "can be called only one time");
1079         require(_avatar != Avatar(0), "avatar cannot be zero");
1080         require(_numberOfAuctions > 0, "number of auctions cannot be zero");
1081         //_auctionPeriod should be greater than block interval
1082         require(_auctionPeriod > 15, "auctionPeriod should be > 15");
1083         auctionPeriod = _auctionPeriod;
1084         auctionsEndTime = _auctionsStartTime + _auctionPeriod.mul(_numberOfAuctions);
1085         require(_redeemEnableTime >= auctionsEndTime, "_redeemEnableTime >= auctionsEndTime");
1086         token = _token;
1087         avatar = _avatar;
1088         auctionsStartTime = _auctionsStartTime;
1089         numberOfAuctions = _numberOfAuctions;
1090         wallet = _wallet;
1091         auctionReputationReward = _auctionReputationReward;
1092         reputationRewardLeft = _auctionReputationReward.mul(_numberOfAuctions);
1093         redeemEnableTime = _redeemEnableTime;
1094     }
1095 
1096     /**
1097      * @dev redeem reputation function
1098      * @param _beneficiary the beneficiary to redeem.
1099      * @param _auctionId the auction id to redeem from.
1100      * @return uint256 reputation rewarded
1101      */
1102     function redeem(address _beneficiary, uint256 _auctionId) public returns(uint256 reputation) {
1103         // solhint-disable-next-line not-rely-on-time
1104         require(now > redeemEnableTime, "now > redeemEnableTime");
1105         Auction storage auction = auctions[_auctionId];
1106         uint256 bid = auction.bids[_beneficiary];
1107         require(bid > 0, "bidding amount should be > 0");
1108         auction.bids[_beneficiary] = 0;
1109         uint256 repRelation = bid.mul(auctionReputationReward);
1110         reputation = repRelation.div(auction.totalBid);
1111         // check that the reputation is sum zero
1112         reputationRewardLeft = reputationRewardLeft.sub(reputation);
1113         require(
1114         ControllerInterface(avatar.owner())
1115         .mintReputation(reputation, _beneficiary, address(avatar)), "mint reputation should succeed");
1116         emit Redeem(_auctionId, _beneficiary, reputation);
1117     }
1118 
1119     /**
1120      * @dev bid function
1121      * @param _amount the amount to bid with
1122      * @return auctionId
1123      */
1124     function bid(uint256 _amount) public returns(uint256 auctionId) {
1125         require(_amount > 0, "bidding amount should be > 0");
1126         // solhint-disable-next-line not-rely-on-time
1127         require(now <= auctionsEndTime, "bidding should be within the allowed bidding period");
1128         // solhint-disable-next-line not-rely-on-time
1129         require(now >= auctionsStartTime, "bidding is enable only after bidding auctionsStartTime");
1130         address(token).safeTransferFrom(msg.sender, address(this), _amount);
1131         // solhint-disable-next-line not-rely-on-time
1132         auctionId = (now - auctionsStartTime) / auctionPeriod;
1133         Auction storage auction = auctions[auctionId];
1134         auction.totalBid = auction.totalBid.add(_amount);
1135         auction.bids[msg.sender] = auction.bids[msg.sender].add(_amount);
1136         emit Bid(msg.sender, auctionId, _amount);
1137     }
1138 
1139     /**
1140      * @dev getBid get bid for specific bidder and _auctionId
1141      * @param _bidder the bidder
1142      * @param _auctionId auction id
1143      * @return uint
1144      */
1145     function getBid(address _bidder, uint256 _auctionId) public view returns(uint256) {
1146         return auctions[_auctionId].bids[_bidder];
1147     }
1148 
1149     /**
1150      * @dev transferToWallet transfer the tokens to the wallet.
1151      *      can be called only after auctionsEndTime
1152      */
1153     function transferToWallet() public {
1154       // solhint-disable-next-line not-rely-on-time
1155         require(now > auctionsEndTime, "now > auctionsEndTime");
1156         uint256 tokenBalance = token.balanceOf(address(this));
1157         address(token).safeTransfer(wallet, tokenBalance);
1158     }
1159 
1160 }
1161 
1162 // File: contracts/schemes/bootstrap/DxGenAuction4Rep.sol
1163 
1164 /**
1165  * @title Scheme for conducting ERC20 Tokens auctions for reputation
1166  */
1167 contract DxGenAuction4Rep is Auction4Reputation {
1168     constructor() public {}
1169 }