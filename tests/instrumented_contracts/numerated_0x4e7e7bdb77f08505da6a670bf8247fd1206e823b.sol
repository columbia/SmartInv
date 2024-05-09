1 pragma solidity ^0.5.2;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor () internal {
86         _owner = msg.sender;
87         emit OwnershipTransferred(address(0), _owner);
88     }
89 
90     /**
91      * @return the address of the owner.
92      */
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     /**
98      * @dev Throws if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(isOwner());
102         _;
103     }
104 
105     /**
106      * @return true if `msg.sender` is the owner of the contract.
107      */
108     function isOwner() public view returns (bool) {
109         return msg.sender == _owner;
110     }
111 
112     /**
113      * @dev Allows the current owner to relinquish control of the contract.
114      * @notice Renouncing to ownership will leave the contract without an owner.
115      * It will not be possible to call the functions with the `onlyOwner`
116      * modifier anymore.
117      */
118     function renounceOwnership() public onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 
123     /**
124      * @dev Allows the current owner to transfer control of the contract to a newOwner.
125      * @param newOwner The address to transfer ownership to.
126      */
127     function transferOwnership(address newOwner) public onlyOwner {
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers control of the contract to a newOwner.
133      * @param newOwner The address to transfer ownership to.
134      */
135     function _transferOwnership(address newOwner) internal {
136         require(newOwner != address(0));
137         emit OwnershipTransferred(_owner, newOwner);
138         _owner = newOwner;
139     }
140 }
141 
142 // File: @daostack/infra/contracts/Reputation.sol
143 
144 /**
145  * @title Reputation system
146  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
147  * A reputation is use to assign influence measure to a DAO'S peers.
148  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
149  * The Reputation contract maintain a map of address to reputation value.
150  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
151  */
152 
153 contract Reputation is Ownable {
154 
155     uint8 public decimals = 18;             //Number of decimals of the smallest unit
156     // Event indicating minting of reputation to an address.
157     event Mint(address indexed _to, uint256 _amount);
158     // Event indicating burning of reputation for an address.
159     event Burn(address indexed _from, uint256 _amount);
160 
161       /// @dev `Checkpoint` is the structure that attaches a block number to a
162       ///  given value, the block number attached is the one that last changed the
163       ///  value
164     struct Checkpoint {
165 
166     // `fromBlock` is the block number that the value was generated from
167         uint128 fromBlock;
168 
169           // `value` is the amount of reputation at a specific block number
170         uint128 value;
171     }
172 
173       // `balances` is the map that tracks the balance of each address, in this
174       //  contract when the balance changes the block number that the change
175       //  occurred is also included in the map
176     mapping (address => Checkpoint[]) balances;
177 
178       // Tracks the history of the `totalSupply` of the reputation
179     Checkpoint[] totalSupplyHistory;
180 
181     /// @notice Constructor to create a Reputation
182     constructor(
183     ) public
184     {
185     }
186 
187     /// @dev This function makes it easy to get the total number of reputation
188     /// @return The total number of reputation
189     function totalSupply() public view returns (uint256) {
190         return totalSupplyAt(block.number);
191     }
192 
193   ////////////////
194   // Query balance and totalSupply in History
195   ////////////////
196     /**
197     * @dev return the reputation amount of a given owner
198     * @param _owner an address of the owner which we want to get his reputation
199     */
200     function balanceOf(address _owner) public view returns (uint256 balance) {
201         return balanceOfAt(_owner, block.number);
202     }
203 
204       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
205       /// @param _owner The address from which the balance will be retrieved
206       /// @param _blockNumber The block number when the balance is queried
207       /// @return The balance at `_blockNumber`
208     function balanceOfAt(address _owner, uint256 _blockNumber)
209     public view returns (uint256)
210     {
211         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
212             return 0;
213           // This will return the expected balance during normal situations
214         } else {
215             return getValueAt(balances[_owner], _blockNumber);
216         }
217     }
218 
219       /// @notice Total amount of reputation at a specific `_blockNumber`.
220       /// @param _blockNumber The block number when the totalSupply is queried
221       /// @return The total amount of reputation at `_blockNumber`
222     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
223         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
224             return 0;
225           // This will return the expected totalSupply during normal situations
226         } else {
227             return getValueAt(totalSupplyHistory, _blockNumber);
228         }
229     }
230 
231       /// @notice Generates `_amount` reputation that are assigned to `_owner`
232       /// @param _user The address that will be assigned the new reputation
233       /// @param _amount The quantity of reputation generated
234       /// @return True if the reputation are generated correctly
235     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
236         uint256 curTotalSupply = totalSupply();
237         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
238         uint256 previousBalanceTo = balanceOf(_user);
239         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
240         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
241         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
242         emit Mint(_user, _amount);
243         return true;
244     }
245 
246       /// @notice Burns `_amount` reputation from `_owner`
247       /// @param _user The address that will lose the reputation
248       /// @param _amount The quantity of reputation to burn
249       /// @return True if the reputation are burned correctly
250     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
251         uint256 curTotalSupply = totalSupply();
252         uint256 amountBurned = _amount;
253         uint256 previousBalanceFrom = balanceOf(_user);
254         if (previousBalanceFrom < amountBurned) {
255             amountBurned = previousBalanceFrom;
256         }
257         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
258         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
259         emit Burn(_user, amountBurned);
260         return true;
261     }
262 
263   ////////////////
264   // Internal helper functions to query and set a value in a snapshot array
265   ////////////////
266 
267       /// @dev `getValueAt` retrieves the number of reputation at a given block number
268       /// @param checkpoints The history of values being queried
269       /// @param _block The block number to retrieve the value at
270       /// @return The number of reputation being queried
271     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
272         if (checkpoints.length == 0) {
273             return 0;
274         }
275 
276           // Shortcut for the actual value
277         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
278             return checkpoints[checkpoints.length-1].value;
279         }
280         if (_block < checkpoints[0].fromBlock) {
281             return 0;
282         }
283 
284           // Binary search of the value in the array
285         uint256 min = 0;
286         uint256 max = checkpoints.length-1;
287         while (max > min) {
288             uint256 mid = (max + min + 1) / 2;
289             if (checkpoints[mid].fromBlock<=_block) {
290                 min = mid;
291             } else {
292                 max = mid-1;
293             }
294         }
295         return checkpoints[min].value;
296     }
297 
298       /// @dev `updateValueAtNow` used to update the `balances` map and the
299       ///  `totalSupplyHistory`
300       /// @param checkpoints The history of data being updated
301       /// @param _value The new number of reputation
302     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
303         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
304         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
305             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
306             newCheckPoint.fromBlock = uint128(block.number);
307             newCheckPoint.value = uint128(_value);
308         } else {
309             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
310             oldCheckPoint.value = uint128(_value);
311         }
312     }
313 }
314 
315 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
316 
317 /**
318  * @title ERC20 interface
319  * @dev see https://github.com/ethereum/EIPs/issues/20
320  */
321 interface IERC20 {
322     function transfer(address to, uint256 value) external returns (bool);
323 
324     function approve(address spender, uint256 value) external returns (bool);
325 
326     function transferFrom(address from, address to, uint256 value) external returns (bool);
327 
328     function totalSupply() external view returns (uint256);
329 
330     function balanceOf(address who) external view returns (uint256);
331 
332     function allowance(address owner, address spender) external view returns (uint256);
333 
334     event Transfer(address indexed from, address indexed to, uint256 value);
335 
336     event Approval(address indexed owner, address indexed spender, uint256 value);
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
1017 // File: @daostack/arc/contracts/schemes/Auction4Reputation.sol
1018 
1019 /**
1020  * @title A scheme for conduct ERC20 Tokens auction for reputation
1021  */
1022 
1023 
1024 contract Auction4Reputation is Ownable {
1025     using SafeMath for uint256;
1026     using SafeERC20 for address;
1027 
1028     event Bid(address indexed _bidder, uint256 indexed _auctionId, uint256 _amount);
1029     event Redeem(uint256 indexed _auctionId, address indexed _beneficiary, uint256 _amount);
1030 
1031     struct Auction {
1032         uint256 totalBid;
1033         // A mapping from bidder addresses to their bids.
1034         mapping(address=>uint) bids;
1035     }
1036 
1037     // A mapping from auction index to auction.
1038     mapping(uint=>Auction) public auctions;
1039 
1040     Avatar public avatar;
1041     uint256 public reputationRewardLeft;
1042     uint256 public auctionsEndTime;
1043     uint256 public auctionsStartTime;
1044     uint256 public numberOfAuctions;
1045     uint256 public auctionReputationReward;
1046     uint256 public auctionPeriod;
1047     uint256 public redeemEnableTime;
1048     IERC20 public token;
1049     address public wallet;
1050 
1051     /**
1052      * @dev initialize
1053      * @param _avatar the avatar to mint reputation from
1054      * @param _auctionReputationReward the reputation reward per auction this contract will reward
1055      *        for the token locking
1056      * @param _auctionsStartTime auctions period start time
1057      * @param _auctionPeriod auctions period time.
1058      *        auctionsEndTime is set to _auctionsStartTime + _auctionPeriod*_numberOfAuctions
1059      *        bidding is disable after auctionsEndTime.
1060      * @param _numberOfAuctions number of auctions.
1061      * @param _redeemEnableTime redeem enable time .
1062      *        redeem reputation can be done after this time.
1063      * @param _token the bidding token
1064      * @param  _wallet the address of the wallet the token will be transfer to.
1065      *         Please note that _wallet address should be a trusted account.
1066      *         Normally this address should be set as the DAO's avatar address.
1067      */
1068     function initialize(
1069         Avatar _avatar,
1070         uint256 _auctionReputationReward,
1071         uint256 _auctionsStartTime,
1072         uint256 _auctionPeriod,
1073         uint256 _numberOfAuctions,
1074         uint256 _redeemEnableTime,
1075         IERC20 _token,
1076         address _wallet)
1077     external
1078     onlyOwner
1079     {
1080         require(avatar == Avatar(0), "can be called only one time");
1081         require(_avatar != Avatar(0), "avatar cannot be zero");
1082         require(_numberOfAuctions > 0, "number of auctions cannot be zero");
1083         //_auctionPeriod should be greater than block interval
1084         require(_auctionPeriod > 15, "auctionPeriod should be > 15");
1085         auctionPeriod = _auctionPeriod;
1086         auctionsEndTime = _auctionsStartTime + _auctionPeriod.mul(_numberOfAuctions);
1087         require(_redeemEnableTime >= auctionsEndTime, "_redeemEnableTime >= auctionsEndTime");
1088         token = _token;
1089         avatar = _avatar;
1090         auctionsStartTime = _auctionsStartTime;
1091         numberOfAuctions = _numberOfAuctions;
1092         wallet = _wallet;
1093         auctionReputationReward = _auctionReputationReward;
1094         reputationRewardLeft = _auctionReputationReward.mul(_numberOfAuctions);
1095         redeemEnableTime = _redeemEnableTime;
1096     }
1097 
1098     /**
1099      * @dev redeem reputation function
1100      * @param _beneficiary the beneficiary to redeem.
1101      * @param _auctionId the auction id to redeem from.
1102      * @return uint256 reputation rewarded
1103      */
1104     function redeem(address _beneficiary, uint256 _auctionId) public returns(uint256 reputation) {
1105         // solhint-disable-next-line not-rely-on-time
1106         require(now > redeemEnableTime, "now > redeemEnableTime");
1107         Auction storage auction = auctions[_auctionId];
1108         uint256 bid = auction.bids[_beneficiary];
1109         require(bid > 0, "bidding amount should be > 0");
1110         auction.bids[_beneficiary] = 0;
1111         uint256 repRelation = bid.mul(auctionReputationReward);
1112         reputation = repRelation.div(auction.totalBid);
1113         // check that the reputation is sum zero
1114         reputationRewardLeft = reputationRewardLeft.sub(reputation);
1115         require(
1116         ControllerInterface(avatar.owner())
1117         .mintReputation(reputation, _beneficiary, address(avatar)), "mint reputation should succeed");
1118         emit Redeem(_auctionId, _beneficiary, reputation);
1119     }
1120 
1121     /**
1122      * @dev bid function
1123      * @param _amount the amount to bid with
1124      * @return auctionId
1125      */
1126     function bid(uint256 _amount) public returns(uint256 auctionId) {
1127         require(_amount > 0, "bidding amount should be > 0");
1128         // solhint-disable-next-line not-rely-on-time
1129         require(now <= auctionsEndTime, "bidding should be within the allowed bidding period");
1130         // solhint-disable-next-line not-rely-on-time
1131         require(now >= auctionsStartTime, "bidding is enable only after bidding auctionsStartTime");
1132         address(token).safeTransferFrom(msg.sender, address(this), _amount);
1133         // solhint-disable-next-line not-rely-on-time
1134         auctionId = (now - auctionsStartTime) / auctionPeriod;
1135         Auction storage auction = auctions[auctionId];
1136         auction.totalBid = auction.totalBid.add(_amount);
1137         auction.bids[msg.sender] = auction.bids[msg.sender].add(_amount);
1138         emit Bid(msg.sender, auctionId, _amount);
1139     }
1140 
1141     /**
1142      * @dev getBid get bid for specific bidder and _auctionId
1143      * @param _bidder the bidder
1144      * @param _auctionId auction id
1145      * @return uint
1146      */
1147     function getBid(address _bidder, uint256 _auctionId) public view returns(uint256) {
1148         return auctions[_auctionId].bids[_bidder];
1149     }
1150 
1151     /**
1152      * @dev transferToWallet transfer the tokens to the wallet.
1153      *      can be called only after auctionsEndTime
1154      */
1155     function transferToWallet() public {
1156       // solhint-disable-next-line not-rely-on-time
1157         require(now > auctionsEndTime, "now > auctionsEndTime");
1158         uint256 tokenBalance = token.balanceOf(address(this));
1159         address(token).safeTransfer(wallet, tokenBalance);
1160     }
1161 
1162 }
1163 
1164 // File: contracts/schemes/bootstrap/DxGenAuction4Rep.sol
1165 
1166 /**
1167  * @title Scheme for conducting ERC20 Tokens auctions for reputation
1168  */
1169 contract DxGenAuction4Rep is Auction4Reputation {
1170     constructor() public {}
1171 }