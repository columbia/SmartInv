1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
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
71 pragma solidity ^0.5.0;
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79     address private _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor () internal {
88         _owner = msg.sender;
89         emit OwnershipTransferred(address(0), _owner);
90     }
91 
92     /**
93      * @return the address of the owner.
94      */
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(isOwner());
104         _;
105     }
106 
107     /**
108      * @return true if `msg.sender` is the owner of the contract.
109      */
110     function isOwner() public view returns (bool) {
111         return msg.sender == _owner;
112     }
113 
114     /**
115      * @dev Allows the current owner to relinquish control of the contract.
116      * @notice Renouncing to ownership will leave the contract without an owner.
117      * It will not be possible to call the functions with the `onlyOwner`
118      * modifier anymore.
119      */
120     function renounceOwnership() public onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124 
125     /**
126      * @dev Allows the current owner to transfer control of the contract to a newOwner.
127      * @param newOwner The address to transfer ownership to.
128      */
129     function transferOwnership(address newOwner) public onlyOwner {
130         _transferOwnership(newOwner);
131     }
132 
133     /**
134      * @dev Transfers control of the contract to a newOwner.
135      * @param newOwner The address to transfer ownership to.
136      */
137     function _transferOwnership(address newOwner) internal {
138         require(newOwner != address(0));
139         emit OwnershipTransferred(_owner, newOwner);
140         _owner = newOwner;
141     }
142 }
143 
144 // File: @daostack/infra/contracts/Reputation.sol
145 
146 pragma solidity ^0.5.4;
147 
148 
149 
150 /**
151  * @title Reputation system
152  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
153  * A reputation is use to assign influence measure to a DAO'S peers.
154  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
155  * The Reputation contract maintain a map of address to reputation value.
156  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
157  */
158 
159 contract Reputation is Ownable {
160 
161     uint8 public decimals = 18;             //Number of decimals of the smallest unit
162     // Event indicating minting of reputation to an address.
163     event Mint(address indexed _to, uint256 _amount);
164     // Event indicating burning of reputation for an address.
165     event Burn(address indexed _from, uint256 _amount);
166 
167       /// @dev `Checkpoint` is the structure that attaches a block number to a
168       ///  given value, the block number attached is the one that last changed the
169       ///  value
170     struct Checkpoint {
171 
172     // `fromBlock` is the block number that the value was generated from
173         uint128 fromBlock;
174 
175           // `value` is the amount of reputation at a specific block number
176         uint128 value;
177     }
178 
179       // `balances` is the map that tracks the balance of each address, in this
180       //  contract when the balance changes the block number that the change
181       //  occurred is also included in the map
182     mapping (address => Checkpoint[]) balances;
183 
184       // Tracks the history of the `totalSupply` of the reputation
185     Checkpoint[] totalSupplyHistory;
186 
187     /// @notice Constructor to create a Reputation
188     constructor(
189     ) public
190     {
191     }
192 
193     /// @dev This function makes it easy to get the total number of reputation
194     /// @return The total number of reputation
195     function totalSupply() public view returns (uint256) {
196         return totalSupplyAt(block.number);
197     }
198 
199   ////////////////
200   // Query balance and totalSupply in History
201   ////////////////
202     /**
203     * @dev return the reputation amount of a given owner
204     * @param _owner an address of the owner which we want to get his reputation
205     */
206     function balanceOf(address _owner) public view returns (uint256 balance) {
207         return balanceOfAt(_owner, block.number);
208     }
209 
210       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
211       /// @param _owner The address from which the balance will be retrieved
212       /// @param _blockNumber The block number when the balance is queried
213       /// @return The balance at `_blockNumber`
214     function balanceOfAt(address _owner, uint256 _blockNumber)
215     public view returns (uint256)
216     {
217         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
218             return 0;
219           // This will return the expected balance during normal situations
220         } else {
221             return getValueAt(balances[_owner], _blockNumber);
222         }
223     }
224 
225       /// @notice Total amount of reputation at a specific `_blockNumber`.
226       /// @param _blockNumber The block number when the totalSupply is queried
227       /// @return The total amount of reputation at `_blockNumber`
228     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
229         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
230             return 0;
231           // This will return the expected totalSupply during normal situations
232         } else {
233             return getValueAt(totalSupplyHistory, _blockNumber);
234         }
235     }
236 
237       /// @notice Generates `_amount` reputation that are assigned to `_owner`
238       /// @param _user The address that will be assigned the new reputation
239       /// @param _amount The quantity of reputation generated
240       /// @return True if the reputation are generated correctly
241     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
242         uint256 curTotalSupply = totalSupply();
243         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
244         uint256 previousBalanceTo = balanceOf(_user);
245         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
246         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
247         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
248         emit Mint(_user, _amount);
249         return true;
250     }
251 
252       /// @notice Burns `_amount` reputation from `_owner`
253       /// @param _user The address that will lose the reputation
254       /// @param _amount The quantity of reputation to burn
255       /// @return True if the reputation are burned correctly
256     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
257         uint256 curTotalSupply = totalSupply();
258         uint256 amountBurned = _amount;
259         uint256 previousBalanceFrom = balanceOf(_user);
260         if (previousBalanceFrom < amountBurned) {
261             amountBurned = previousBalanceFrom;
262         }
263         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
264         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
265         emit Burn(_user, amountBurned);
266         return true;
267     }
268 
269   ////////////////
270   // Internal helper functions to query and set a value in a snapshot array
271   ////////////////
272 
273       /// @dev `getValueAt` retrieves the number of reputation at a given block number
274       /// @param checkpoints The history of values being queried
275       /// @param _block The block number to retrieve the value at
276       /// @return The number of reputation being queried
277     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
278         if (checkpoints.length == 0) {
279             return 0;
280         }
281 
282           // Shortcut for the actual value
283         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
284             return checkpoints[checkpoints.length-1].value;
285         }
286         if (_block < checkpoints[0].fromBlock) {
287             return 0;
288         }
289 
290           // Binary search of the value in the array
291         uint256 min = 0;
292         uint256 max = checkpoints.length-1;
293         while (max > min) {
294             uint256 mid = (max + min + 1) / 2;
295             if (checkpoints[mid].fromBlock<=_block) {
296                 min = mid;
297             } else {
298                 max = mid-1;
299             }
300         }
301         return checkpoints[min].value;
302     }
303 
304       /// @dev `updateValueAtNow` used to update the `balances` map and the
305       ///  `totalSupplyHistory`
306       /// @param checkpoints The history of data being updated
307       /// @param _value The new number of reputation
308     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
309         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
310         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
311             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
312             newCheckPoint.fromBlock = uint128(block.number);
313             newCheckPoint.value = uint128(_value);
314         } else {
315             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
316             oldCheckPoint.value = uint128(_value);
317         }
318     }
319 }
320 
321 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
322 
323 pragma solidity ^0.5.0;
324 
325 /**
326  * @title ERC20 interface
327  * @dev see https://github.com/ethereum/EIPs/issues/20
328  */
329 interface IERC20 {
330     function transfer(address to, uint256 value) external returns (bool);
331 
332     function approve(address spender, uint256 value) external returns (bool);
333 
334     function transferFrom(address from, address to, uint256 value) external returns (bool);
335 
336     function totalSupply() external view returns (uint256);
337 
338     function balanceOf(address who) external view returns (uint256);
339 
340     function allowance(address owner, address spender) external view returns (uint256);
341 
342     event Transfer(address indexed from, address indexed to, uint256 value);
343 
344     event Approval(address indexed owner, address indexed spender, uint256 value);
345 }
346 
347 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
348 
349 pragma solidity ^0.5.0;
350 
351 
352 
353 /**
354  * @title Standard ERC20 token
355  *
356  * @dev Implementation of the basic standard token.
357  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
358  * Originally based on code by FirstBlood:
359  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
360  *
361  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
362  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
363  * compliant implementations may not do it.
364  */
365 contract ERC20 is IERC20 {
366     using SafeMath for uint256;
367 
368     mapping (address => uint256) private _balances;
369 
370     mapping (address => mapping (address => uint256)) private _allowed;
371 
372     uint256 private _totalSupply;
373 
374     /**
375     * @dev Total number of tokens in existence
376     */
377     function totalSupply() public view returns (uint256) {
378         return _totalSupply;
379     }
380 
381     /**
382     * @dev Gets the balance of the specified address.
383     * @param owner The address to query the balance of.
384     * @return An uint256 representing the amount owned by the passed address.
385     */
386     function balanceOf(address owner) public view returns (uint256) {
387         return _balances[owner];
388     }
389 
390     /**
391      * @dev Function to check the amount of tokens that an owner allowed to a spender.
392      * @param owner address The address which owns the funds.
393      * @param spender address The address which will spend the funds.
394      * @return A uint256 specifying the amount of tokens still available for the spender.
395      */
396     function allowance(address owner, address spender) public view returns (uint256) {
397         return _allowed[owner][spender];
398     }
399 
400     /**
401     * @dev Transfer token for a specified address
402     * @param to The address to transfer to.
403     * @param value The amount to be transferred.
404     */
405     function transfer(address to, uint256 value) public returns (bool) {
406         _transfer(msg.sender, to, value);
407         return true;
408     }
409 
410     /**
411      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
412      * Beware that changing an allowance with this method brings the risk that someone may use both the old
413      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
414      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
415      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
416      * @param spender The address which will spend the funds.
417      * @param value The amount of tokens to be spent.
418      */
419     function approve(address spender, uint256 value) public returns (bool) {
420         require(spender != address(0));
421 
422         _allowed[msg.sender][spender] = value;
423         emit Approval(msg.sender, spender, value);
424         return true;
425     }
426 
427     /**
428      * @dev Transfer tokens from one address to another.
429      * Note that while this function emits an Approval event, this is not required as per the specification,
430      * and other compliant implementations may not emit the event.
431      * @param from address The address which you want to send tokens from
432      * @param to address The address which you want to transfer to
433      * @param value uint256 the amount of tokens to be transferred
434      */
435     function transferFrom(address from, address to, uint256 value) public returns (bool) {
436         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
437         _transfer(from, to, value);
438         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
439         return true;
440     }
441 
442     /**
443      * @dev Increase the amount of tokens that an owner allowed to a spender.
444      * approve should be called when allowed_[_spender] == 0. To increment
445      * allowed value is better to use this function to avoid 2 calls (and wait until
446      * the first transaction is mined)
447      * From MonolithDAO Token.sol
448      * Emits an Approval event.
449      * @param spender The address which will spend the funds.
450      * @param addedValue The amount of tokens to increase the allowance by.
451      */
452     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
453         require(spender != address(0));
454 
455         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
456         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
457         return true;
458     }
459 
460     /**
461      * @dev Decrease the amount of tokens that an owner allowed to a spender.
462      * approve should be called when allowed_[_spender] == 0. To decrement
463      * allowed value is better to use this function to avoid 2 calls (and wait until
464      * the first transaction is mined)
465      * From MonolithDAO Token.sol
466      * Emits an Approval event.
467      * @param spender The address which will spend the funds.
468      * @param subtractedValue The amount of tokens to decrease the allowance by.
469      */
470     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
471         require(spender != address(0));
472 
473         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
474         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
475         return true;
476     }
477 
478     /**
479     * @dev Transfer token for a specified addresses
480     * @param from The address to transfer from.
481     * @param to The address to transfer to.
482     * @param value The amount to be transferred.
483     */
484     function _transfer(address from, address to, uint256 value) internal {
485         require(to != address(0));
486 
487         _balances[from] = _balances[from].sub(value);
488         _balances[to] = _balances[to].add(value);
489         emit Transfer(from, to, value);
490     }
491 
492     /**
493      * @dev Internal function that mints an amount of the token and assigns it to
494      * an account. This encapsulates the modification of balances such that the
495      * proper events are emitted.
496      * @param account The account that will receive the created tokens.
497      * @param value The amount that will be created.
498      */
499     function _mint(address account, uint256 value) internal {
500         require(account != address(0));
501 
502         _totalSupply = _totalSupply.add(value);
503         _balances[account] = _balances[account].add(value);
504         emit Transfer(address(0), account, value);
505     }
506 
507     /**
508      * @dev Internal function that burns an amount of the token of a given
509      * account.
510      * @param account The account whose tokens will be burnt.
511      * @param value The amount that will be burnt.
512      */
513     function _burn(address account, uint256 value) internal {
514         require(account != address(0));
515 
516         _totalSupply = _totalSupply.sub(value);
517         _balances[account] = _balances[account].sub(value);
518         emit Transfer(account, address(0), value);
519     }
520 
521     /**
522      * @dev Internal function that burns an amount of the token of a given
523      * account, deducting from the sender's allowance for said account. Uses the
524      * internal burn function.
525      * Emits an Approval event (reflecting the reduced allowance).
526      * @param account The account whose tokens will be burnt.
527      * @param value The amount that will be burnt.
528      */
529     function _burnFrom(address account, uint256 value) internal {
530         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
531         _burn(account, value);
532         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
533     }
534 }
535 
536 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
537 
538 pragma solidity ^0.5.0;
539 
540 
541 /**
542  * @title Burnable Token
543  * @dev Token that can be irreversibly burned (destroyed).
544  */
545 contract ERC20Burnable is ERC20 {
546     /**
547      * @dev Burns a specific amount of tokens.
548      * @param value The amount of token to be burned.
549      */
550     function burn(uint256 value) public {
551         _burn(msg.sender, value);
552     }
553 
554     /**
555      * @dev Burns a specific amount of tokens from the target address and decrements allowance
556      * @param from address The address which you want to send tokens from
557      * @param value uint256 The amount of token to be burned
558      */
559     function burnFrom(address from, uint256 value) public {
560         _burnFrom(from, value);
561     }
562 }
563 
564 // File: @daostack/arc/contracts/controller/DAOToken.sol
565 
566 pragma solidity ^0.5.4;
567 
568 
569 
570 
571 
572 /**
573  * @title DAOToken, base on zeppelin contract.
574  * @dev ERC20 compatible token. It is a mintable, burnable token.
575  */
576 
577 contract DAOToken is ERC20, ERC20Burnable, Ownable {
578 
579     string public name;
580     string public symbol;
581     // solhint-disable-next-line const-name-snakecase
582     uint8 public constant decimals = 18;
583     uint256 public cap;
584 
585     /**
586     * @dev Constructor
587     * @param _name - token name
588     * @param _symbol - token symbol
589     * @param _cap - token cap - 0 value means no cap
590     */
591     constructor(string memory _name, string memory _symbol, uint256 _cap)
592     public {
593         name = _name;
594         symbol = _symbol;
595         cap = _cap;
596     }
597 
598     /**
599      * @dev Function to mint tokens
600      * @param _to The address that will receive the minted tokens.
601      * @param _amount The amount of tokens to mint.
602      */
603     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
604         if (cap > 0)
605             require(totalSupply().add(_amount) <= cap);
606         _mint(_to, _amount);
607         return true;
608     }
609 }
610 
611 // File: openzeppelin-solidity/contracts/utils/Address.sol
612 
613 pragma solidity ^0.5.0;
614 
615 /**
616  * Utility library of inline functions on addresses
617  */
618 library Address {
619     /**
620      * Returns whether the target address is a contract
621      * @dev This function will return false if invoked during the constructor of a contract,
622      * as the code is not actually created until after the constructor finishes.
623      * @param account address of the account to check
624      * @return whether the target address is a contract
625      */
626     function isContract(address account) internal view returns (bool) {
627         uint256 size;
628         // XXX Currently there is no better way to check if there is a contract in an address
629         // than to check the size of the code at that address.
630         // See https://ethereum.stackexchange.com/a/14016/36603
631         // for more details about how this works.
632         // TODO Check this again before the Serenity release, because all addresses will be
633         // contracts then.
634         // solhint-disable-next-line no-inline-assembly
635         assembly { size := extcodesize(account) }
636         return size > 0;
637     }
638 }
639 
640 // File: @daostack/arc/contracts/libs/SafeERC20.sol
641 
642 /*
643 
644 SafeERC20 by daostack.
645 The code is based on a fix by SECBIT Team.
646 
647 USE WITH CAUTION & NO WARRANTY
648 
649 REFERENCE & RELATED READING
650 - https://github.com/ethereum/solidity/issues/4116
651 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
652 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
653 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
654 
655 */
656 pragma solidity ^0.5.4;
657 
658 
659 
660 library SafeERC20 {
661     using Address for address;
662 
663     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
664     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
665     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
666 
667     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
668 
669         // Must be a contract addr first!
670         require(_erc20Addr.isContract());
671 
672         (bool success, bytes memory returnValue) =
673         // solhint-disable-next-line avoid-low-level-calls
674         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
675         // call return false when something wrong
676         require(success);
677         //check return value
678         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
679     }
680 
681     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
682 
683         // Must be a contract addr first!
684         require(_erc20Addr.isContract());
685 
686         (bool success, bytes memory returnValue) =
687         // solhint-disable-next-line avoid-low-level-calls
688         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
689         // call return false when something wrong
690         require(success);
691         //check return value
692         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
693     }
694 
695     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
696 
697         // Must be a contract addr first!
698         require(_erc20Addr.isContract());
699 
700         // safeApprove should only be called when setting an initial allowance,
701         // or when resetting it to zero.
702         require((_value == 0) || (IERC20(_erc20Addr).allowance(address(this), _spender) == 0));
703 
704         (bool success, bytes memory returnValue) =
705         // solhint-disable-next-line avoid-low-level-calls
706         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
707         // call return false when something wrong
708         require(success);
709         //check return value
710         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
711     }
712 }
713 
714 // File: @daostack/arc/contracts/controller/Avatar.sol
715 
716 pragma solidity ^0.5.4;
717 
718 
719 
720 
721 
722 
723 
724 /**
725  * @title An Avatar holds tokens, reputation and ether for a controller
726  */
727 contract Avatar is Ownable {
728     using SafeERC20 for address;
729 
730     string public orgName;
731     DAOToken public nativeToken;
732     Reputation public nativeReputation;
733 
734     event GenericCall(address indexed _contract, bytes _data, uint _value, bool _success);
735     event SendEther(uint256 _amountInWei, address indexed _to);
736     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint256 _value);
737     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint256 _value);
738     event ExternalTokenApproval(address indexed _externalToken, address _spender, uint256 _value);
739     event ReceiveEther(address indexed _sender, uint256 _value);
740     event MetaData(string _metaData);
741 
742     /**
743     * @dev the constructor takes organization name, native token and reputation system
744     and creates an avatar for a controller
745     */
746     constructor(string memory _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
747         orgName = _orgName;
748         nativeToken = _nativeToken;
749         nativeReputation = _nativeReputation;
750     }
751 
752     /**
753     * @dev enables an avatar to receive ethers
754     */
755     function() external payable {
756         emit ReceiveEther(msg.sender, msg.value);
757     }
758 
759     /**
760     * @dev perform a generic call to an arbitrary contract
761     * @param _contract  the contract's address to call
762     * @param _data ABI-encoded contract call to call `_contract` address.
763     * @param _value value (ETH) to transfer with the transaction
764     * @return bool    success or fail
765     *         bytes - the return bytes of the called contract's function.
766     */
767     function genericCall(address _contract, bytes memory _data, uint256 _value)
768     public
769     onlyOwner
770     returns(bool success, bytes memory returnValue) {
771       // solhint-disable-next-line avoid-call-value
772         (success, returnValue) = _contract.call.value(_value)(_data);
773         emit GenericCall(_contract, _data, _value, success);
774     }
775 
776     /**
777     * @dev send ethers from the avatar's wallet
778     * @param _amountInWei amount to send in Wei units
779     * @param _to send the ethers to this address
780     * @return bool which represents success
781     */
782     function sendEther(uint256 _amountInWei, address payable _to) public onlyOwner returns(bool) {
783         _to.transfer(_amountInWei);
784         emit SendEther(_amountInWei, _to);
785         return true;
786     }
787 
788     /**
789     * @dev external token transfer
790     * @param _externalToken the token contract
791     * @param _to the destination address
792     * @param _value the amount of tokens to transfer
793     * @return bool which represents success
794     */
795     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
796     public onlyOwner returns(bool)
797     {
798         address(_externalToken).safeTransfer(_to, _value);
799         emit ExternalTokenTransfer(address(_externalToken), _to, _value);
800         return true;
801     }
802 
803     /**
804     * @dev external token transfer from a specific account
805     * @param _externalToken the token contract
806     * @param _from the account to spend token from
807     * @param _to the destination address
808     * @param _value the amount of tokens to transfer
809     * @return bool which represents success
810     */
811     function externalTokenTransferFrom(
812         IERC20 _externalToken,
813         address _from,
814         address _to,
815         uint256 _value
816     )
817     public onlyOwner returns(bool)
818     {
819         address(_externalToken).safeTransferFrom(_from, _to, _value);
820         emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
821         return true;
822     }
823 
824     /**
825     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
826     *      on behalf of msg.sender.
827     * @param _externalToken the address of the Token Contract
828     * @param _spender address
829     * @param _value the amount of ether (in Wei) which the approval is referring to.
830     * @return bool which represents a success
831     */
832     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
833     public onlyOwner returns(bool)
834     {
835         address(_externalToken).safeApprove(_spender, _value);
836         emit ExternalTokenApproval(address(_externalToken), _spender, _value);
837         return true;
838     }
839 
840     /**
841     * @dev metaData emits an event with a string, should contain the hash of some meta data.
842     * @param _metaData a string representing a hash of the meta data
843     * @return bool which represents a success
844     */
845     function metaData(string memory _metaData) public onlyOwner returns(bool) {
846         emit MetaData(_metaData);
847         return true;
848     }
849 
850 
851 }
852 
853 // File: @daostack/arc/contracts/globalConstraints/GlobalConstraintInterface.sol
854 
855 pragma solidity ^0.5.4;
856 
857 
858 contract GlobalConstraintInterface {
859 
860     enum CallPhase { Pre, Post, PreAndPost }
861 
862     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
863     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
864     /**
865      * @dev when return if this globalConstraints is pre, post or both.
866      * @return CallPhase enum indication  Pre, Post or PreAndPost.
867      */
868     function when() public returns(CallPhase);
869 }
870 
871 // File: @daostack/arc/contracts/controller/ControllerInterface.sol
872 
873 pragma solidity ^0.5.4;
874 
875 
876 
877 /**
878  * @title Controller contract
879  * @dev A controller controls the organizations tokens ,reputation and avatar.
880  * It is subject to a set of schemes and constraints that determine its behavior.
881  * Each scheme has it own parameters and operation permissions.
882  */
883 interface ControllerInterface {
884 
885     /**
886      * @dev Mint `_amount` of reputation that are assigned to `_to` .
887      * @param  _amount amount of reputation to mint
888      * @param _to beneficiary address
889      * @return bool which represents a success
890     */
891     function mintReputation(uint256 _amount, address _to, address _avatar)
892     external
893     returns(bool);
894 
895     /**
896      * @dev Burns `_amount` of reputation from `_from`
897      * @param _amount amount of reputation to burn
898      * @param _from The address that will lose the reputation
899      * @return bool which represents a success
900      */
901     function burnReputation(uint256 _amount, address _from, address _avatar)
902     external
903     returns(bool);
904 
905     /**
906      * @dev mint tokens .
907      * @param  _amount amount of token to mint
908      * @param _beneficiary beneficiary address
909      * @param _avatar address
910      * @return bool which represents a success
911      */
912     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
913     external
914     returns(bool);
915 
916   /**
917    * @dev register or update a scheme
918    * @param _scheme the address of the scheme
919    * @param _paramsHash a hashed configuration of the usage of the scheme
920    * @param _permissions the permissions the new scheme will have
921    * @param _avatar address
922    * @return bool which represents a success
923    */
924     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
925     external
926     returns(bool);
927 
928     /**
929      * @dev unregister a scheme
930      * @param _avatar address
931      * @param _scheme the address of the scheme
932      * @return bool which represents a success
933      */
934     function unregisterScheme(address _scheme, address _avatar)
935     external
936     returns(bool);
937 
938     /**
939      * @dev unregister the caller's scheme
940      * @param _avatar address
941      * @return bool which represents a success
942      */
943     function unregisterSelf(address _avatar) external returns(bool);
944 
945     /**
946      * @dev add or update Global Constraint
947      * @param _globalConstraint the address of the global constraint to be added.
948      * @param _params the constraint parameters hash.
949      * @param _avatar the avatar of the organization
950      * @return bool which represents a success
951      */
952     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
953     external returns(bool);
954 
955     /**
956      * @dev remove Global Constraint
957      * @param _globalConstraint the address of the global constraint to be remove.
958      * @param _avatar the organization avatar.
959      * @return bool which represents a success
960      */
961     function removeGlobalConstraint (address _globalConstraint, address _avatar)
962     external  returns(bool);
963 
964   /**
965     * @dev upgrade the Controller
966     *      The function will trigger an event 'UpgradeController'.
967     * @param  _newController the address of the new controller.
968     * @param _avatar address
969     * @return bool which represents a success
970     */
971     function upgradeController(address _newController, Avatar _avatar)
972     external returns(bool);
973 
974     /**
975     * @dev perform a generic call to an arbitrary contract
976     * @param _contract  the contract's address to call
977     * @param _data ABI-encoded contract call to call `_contract` address.
978     * @param _avatar the controller's avatar address
979     * @param _value value (ETH) to transfer with the transaction
980     * @return bool -success
981     *         bytes  - the return value of the called _contract's function.
982     */
983     function genericCall(address _contract, bytes calldata _data, Avatar _avatar, uint256 _value)
984     external
985     returns(bool, bytes memory);
986 
987   /**
988    * @dev send some ether
989    * @param _amountInWei the amount of ether (in Wei) to send
990    * @param _to address of the beneficiary
991    * @param _avatar address
992    * @return bool which represents a success
993    */
994     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
995     external returns(bool);
996 
997     /**
998     * @dev send some amount of arbitrary ERC20 Tokens
999     * @param _externalToken the address of the Token Contract
1000     * @param _to address of the beneficiary
1001     * @param _value the amount of ether (in Wei) to send
1002     * @param _avatar address
1003     * @return bool which represents a success
1004     */
1005     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1006     external
1007     returns(bool);
1008 
1009     /**
1010     * @dev transfer token "from" address "to" address
1011     *      One must to approve the amount of tokens which can be spend from the
1012     *      "from" account.This can be done using externalTokenApprove.
1013     * @param _externalToken the address of the Token Contract
1014     * @param _from address of the account to send from
1015     * @param _to address of the beneficiary
1016     * @param _value the amount of ether (in Wei) to send
1017     * @param _avatar address
1018     * @return bool which represents a success
1019     */
1020     function externalTokenTransferFrom(
1021     IERC20 _externalToken,
1022     address _from,
1023     address _to,
1024     uint256 _value,
1025     Avatar _avatar)
1026     external
1027     returns(bool);
1028 
1029     /**
1030     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1031     *      on behalf of msg.sender.
1032     * @param _externalToken the address of the Token Contract
1033     * @param _spender address
1034     * @param _value the amount of ether (in Wei) which the approval is referring to.
1035     * @return bool which represents a success
1036     */
1037     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1038     external
1039     returns(bool);
1040 
1041     /**
1042     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1043     * @param _metaData a string representing a hash of the meta data
1044     * @param _avatar Avatar
1045     * @return bool which represents a success
1046     */
1047     function metaData(string calldata _metaData, Avatar _avatar) external returns(bool);
1048 
1049     /**
1050      * @dev getNativeReputation
1051      * @param _avatar the organization avatar.
1052      * @return organization native reputation
1053      */
1054     function getNativeReputation(address _avatar)
1055     external
1056     view
1057     returns(address);
1058 
1059     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
1060 
1061     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1062 
1063     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1064 
1065     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1066 
1067     /**
1068      * @dev globalConstraintsCount return the global constraint pre and post count
1069      * @return uint256 globalConstraintsPre count.
1070      * @return uint256 globalConstraintsPost count.
1071      */
1072     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1073 
1074     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1075 }
1076 
1077 // File: @daostack/arc/contracts/schemes/Auction4Reputation.sol
1078 
1079 pragma solidity ^0.5.4;
1080 
1081 
1082 
1083 
1084 /**
1085  * @title A scheme for conduct ERC20 Tokens auction for reputation
1086  */
1087 
1088 
1089 contract Auction4Reputation is Ownable {
1090     using SafeMath for uint256;
1091     using SafeERC20 for address;
1092 
1093     event Bid(address indexed _bidder, uint256 indexed _auctionId, uint256 _amount);
1094     event Redeem(uint256 indexed _auctionId, address indexed _beneficiary, uint256 _amount);
1095 
1096     struct Auction {
1097         uint256 totalBid;
1098         // A mapping from bidder addresses to their bids.
1099         mapping(address=>uint) bids;
1100     }
1101 
1102     // A mapping from auction index to auction.
1103     mapping(uint=>Auction) public auctions;
1104 
1105     Avatar public avatar;
1106     uint256 public reputationRewardLeft;
1107     uint256 public auctionsEndTime;
1108     uint256 public auctionsStartTime;
1109     uint256 public numberOfAuctions;
1110     uint256 public auctionReputationReward;
1111     uint256 public auctionPeriod;
1112     uint256 public redeemEnableTime;
1113     IERC20 public token;
1114     address public wallet;
1115 
1116     /**
1117      * @dev initialize
1118      * @param _avatar the avatar to mint reputation from
1119      * @param _auctionReputationReward the reputation reward per auction this contract will reward
1120      *        for the token locking
1121      * @param _auctionsStartTime auctions period start time
1122      * @param _auctionPeriod auctions period time.
1123      *        auctionsEndTime is set to _auctionsStartTime + _auctionPeriod*_numberOfAuctions
1124      *        bidding is disable after auctionsEndTime.
1125      * @param _numberOfAuctions number of auctions.
1126      * @param _redeemEnableTime redeem enable time .
1127      *        redeem reputation can be done after this time.
1128      * @param _token the bidding token
1129      * @param  _wallet the address of the wallet the token will be transfer to.
1130      *         Please note that _wallet address should be a trusted account.
1131      *         Normally this address should be set as the DAO's avatar address.
1132      */
1133     function initialize(
1134         Avatar _avatar,
1135         uint256 _auctionReputationReward,
1136         uint256 _auctionsStartTime,
1137         uint256 _auctionPeriod,
1138         uint256 _numberOfAuctions,
1139         uint256 _redeemEnableTime,
1140         IERC20 _token,
1141         address _wallet)
1142     external
1143     {
1144         require(avatar == Avatar(0), "can be called only one time");
1145         require(_avatar != Avatar(0), "avatar cannot be zero");
1146         require(_numberOfAuctions > 0, "number of auctions cannot be zero");
1147         //_auctionPeriod should be greater than block interval
1148         require(_auctionPeriod > 15, "auctionPeriod should be > 15");
1149         auctionPeriod = _auctionPeriod;
1150         auctionsEndTime = _auctionsStartTime + _auctionPeriod.mul(_numberOfAuctions);
1151         require(_redeemEnableTime >= auctionsEndTime, "_redeemEnableTime >= auctionsEndTime");
1152         token = _token;
1153         avatar = _avatar;
1154         auctionsStartTime = _auctionsStartTime;
1155         numberOfAuctions = _numberOfAuctions;
1156         wallet = _wallet;
1157         auctionReputationReward = _auctionReputationReward;
1158         reputationRewardLeft = _auctionReputationReward.mul(_numberOfAuctions);
1159         redeemEnableTime = _redeemEnableTime;
1160     }
1161 
1162     /**
1163      * @dev redeem reputation function
1164      * @param _beneficiary the beneficiary to redeem.
1165      * @param _auctionId the auction id to redeem from.
1166      * @return uint256 reputation rewarded
1167      */
1168     function redeem(address _beneficiary, uint256 _auctionId) public returns(uint256 reputation) {
1169         // solhint-disable-next-line not-rely-on-time
1170         require(now > redeemEnableTime, "now > redeemEnableTime");
1171         Auction storage auction = auctions[_auctionId];
1172         uint256 bid = auction.bids[_beneficiary];
1173         require(bid > 0, "bidding amount should be > 0");
1174         auction.bids[_beneficiary] = 0;
1175         uint256 repRelation = bid.mul(auctionReputationReward);
1176         reputation = repRelation.div(auction.totalBid);
1177         // check that the reputation is sum zero
1178         reputationRewardLeft = reputationRewardLeft.sub(reputation);
1179         require(
1180         ControllerInterface(avatar.owner())
1181         .mintReputation(reputation, _beneficiary, address(avatar)), "mint reputation should succeed");
1182         emit Redeem(_auctionId, _beneficiary, reputation);
1183     }
1184 
1185     /**
1186      * @dev bid function
1187      * @param _amount the amount to bid with
1188      * @param _auctionId the auction id to bid at .
1189      * @return auctionId
1190      */
1191     function bid(uint256 _amount, uint256 _auctionId) public returns(uint256 auctionId) {
1192         require(_amount > 0, "bidding amount should be > 0");
1193         // solhint-disable-next-line not-rely-on-time
1194         require(now < auctionsEndTime, "bidding should be within the allowed bidding period");
1195         // solhint-disable-next-line not-rely-on-time
1196         require(now >= auctionsStartTime, "bidding is enable only after bidding auctionsStartTime");
1197         address(token).safeTransferFrom(msg.sender, address(this), _amount);
1198         // solhint-disable-next-line not-rely-on-time
1199         auctionId = (now - auctionsStartTime) / auctionPeriod;
1200         require(auctionId == _auctionId, "auction is not active");
1201         Auction storage auction = auctions[auctionId];
1202         auction.totalBid = auction.totalBid.add(_amount);
1203         auction.bids[msg.sender] = auction.bids[msg.sender].add(_amount);
1204         emit Bid(msg.sender, auctionId, _amount);
1205     }
1206 
1207     /**
1208      * @dev getBid get bid for specific bidder and _auctionId
1209      * @param _bidder the bidder
1210      * @param _auctionId auction id
1211      * @return uint
1212      */
1213     function getBid(address _bidder, uint256 _auctionId) public view returns(uint256) {
1214         return auctions[_auctionId].bids[_bidder];
1215     }
1216 
1217     /**
1218      * @dev transferToWallet transfer the tokens to the wallet.
1219      *      can be called only after auctionsEndTime
1220      */
1221     function transferToWallet() public {
1222       // solhint-disable-next-line not-rely-on-time
1223         require(now > auctionsEndTime, "now > auctionsEndTime");
1224         uint256 tokenBalance = token.balanceOf(address(this));
1225         address(token).safeTransfer(wallet, tokenBalance);
1226     }
1227 
1228 }
1229 
1230 // File: contracts/schemes/bootstrap/DxGenAuction4Rep.sol
1231 
1232 pragma solidity ^0.5.4;
1233 
1234 
1235 /**
1236  * @title Scheme for conducting ERC20 Tokens auctions for reputation
1237  */
1238 contract DxGenAuction4Rep is Auction4Reputation {
1239     constructor() public {}
1240 }