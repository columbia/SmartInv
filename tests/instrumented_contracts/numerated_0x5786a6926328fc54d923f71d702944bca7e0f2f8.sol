1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
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
78 pragma solidity ^0.5.4;
79 
80 
81 
82 /**
83  * @title Reputation system
84  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
85  * A reputation is use to assign influence measure to a DAO'S peers.
86  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
87  * The Reputation contract maintain a map of address to reputation value.
88  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
89  */
90 
91 contract Reputation is Ownable {
92 
93     uint8 public decimals = 18;             //Number of decimals of the smallest unit
94     // Event indicating minting of reputation to an address.
95     event Mint(address indexed _to, uint256 _amount);
96     // Event indicating burning of reputation for an address.
97     event Burn(address indexed _from, uint256 _amount);
98 
99       /// @dev `Checkpoint` is the structure that attaches a block number to a
100       ///  given value, the block number attached is the one that last changed the
101       ///  value
102     struct Checkpoint {
103 
104     // `fromBlock` is the block number that the value was generated from
105         uint128 fromBlock;
106 
107           // `value` is the amount of reputation at a specific block number
108         uint128 value;
109     }
110 
111       // `balances` is the map that tracks the balance of each address, in this
112       //  contract when the balance changes the block number that the change
113       //  occurred is also included in the map
114     mapping (address => Checkpoint[]) balances;
115 
116       // Tracks the history of the `totalSupply` of the reputation
117     Checkpoint[] totalSupplyHistory;
118 
119     /// @notice Constructor to create a Reputation
120     constructor(
121     ) public
122     {
123     }
124 
125     /// @dev This function makes it easy to get the total number of reputation
126     /// @return The total number of reputation
127     function totalSupply() public view returns (uint256) {
128         return totalSupplyAt(block.number);
129     }
130 
131   ////////////////
132   // Query balance and totalSupply in History
133   ////////////////
134     /**
135     * @dev return the reputation amount of a given owner
136     * @param _owner an address of the owner which we want to get his reputation
137     */
138     function balanceOf(address _owner) public view returns (uint256 balance) {
139         return balanceOfAt(_owner, block.number);
140     }
141 
142       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
143       /// @param _owner The address from which the balance will be retrieved
144       /// @param _blockNumber The block number when the balance is queried
145       /// @return The balance at `_blockNumber`
146     function balanceOfAt(address _owner, uint256 _blockNumber)
147     public view returns (uint256)
148     {
149         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
150             return 0;
151           // This will return the expected balance during normal situations
152         } else {
153             return getValueAt(balances[_owner], _blockNumber);
154         }
155     }
156 
157       /// @notice Total amount of reputation at a specific `_blockNumber`.
158       /// @param _blockNumber The block number when the totalSupply is queried
159       /// @return The total amount of reputation at `_blockNumber`
160     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
161         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
162             return 0;
163           // This will return the expected totalSupply during normal situations
164         } else {
165             return getValueAt(totalSupplyHistory, _blockNumber);
166         }
167     }
168 
169       /// @notice Generates `_amount` reputation that are assigned to `_owner`
170       /// @param _user The address that will be assigned the new reputation
171       /// @param _amount The quantity of reputation generated
172       /// @return True if the reputation are generated correctly
173     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
174         uint256 curTotalSupply = totalSupply();
175         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
176         uint256 previousBalanceTo = balanceOf(_user);
177         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
178         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
179         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
180         emit Mint(_user, _amount);
181         return true;
182     }
183 
184       /// @notice Burns `_amount` reputation from `_owner`
185       /// @param _user The address that will lose the reputation
186       /// @param _amount The quantity of reputation to burn
187       /// @return True if the reputation are burned correctly
188     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
189         uint256 curTotalSupply = totalSupply();
190         uint256 amountBurned = _amount;
191         uint256 previousBalanceFrom = balanceOf(_user);
192         if (previousBalanceFrom < amountBurned) {
193             amountBurned = previousBalanceFrom;
194         }
195         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
196         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
197         emit Burn(_user, amountBurned);
198         return true;
199     }
200 
201   ////////////////
202   // Internal helper functions to query and set a value in a snapshot array
203   ////////////////
204 
205       /// @dev `getValueAt` retrieves the number of reputation at a given block number
206       /// @param checkpoints The history of values being queried
207       /// @param _block The block number to retrieve the value at
208       /// @return The number of reputation being queried
209     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
210         if (checkpoints.length == 0) {
211             return 0;
212         }
213 
214           // Shortcut for the actual value
215         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
216             return checkpoints[checkpoints.length-1].value;
217         }
218         if (_block < checkpoints[0].fromBlock) {
219             return 0;
220         }
221 
222           // Binary search of the value in the array
223         uint256 min = 0;
224         uint256 max = checkpoints.length-1;
225         while (max > min) {
226             uint256 mid = (max + min + 1) / 2;
227             if (checkpoints[mid].fromBlock<=_block) {
228                 min = mid;
229             } else {
230                 max = mid-1;
231             }
232         }
233         return checkpoints[min].value;
234     }
235 
236       /// @dev `updateValueAtNow` used to update the `balances` map and the
237       ///  `totalSupplyHistory`
238       /// @param checkpoints The history of data being updated
239       /// @param _value The new number of reputation
240     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
241         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
242         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
243             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
244             newCheckPoint.fromBlock = uint128(block.number);
245             newCheckPoint.value = uint128(_value);
246         } else {
247             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
248             oldCheckPoint.value = uint128(_value);
249         }
250     }
251 }
252 
253 // File: ../../openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
254 
255 pragma solidity ^0.5.0;
256 
257 /**
258  * @title ERC20 interface
259  * @dev see https://github.com/ethereum/EIPs/issues/20
260  */
261 interface IERC20 {
262     function transfer(address to, uint256 value) external returns (bool);
263 
264     function approve(address spender, uint256 value) external returns (bool);
265 
266     function transferFrom(address from, address to, uint256 value) external returns (bool);
267 
268     function totalSupply() external view returns (uint256);
269 
270     function balanceOf(address who) external view returns (uint256);
271 
272     function allowance(address owner, address spender) external view returns (uint256);
273 
274     event Transfer(address indexed from, address indexed to, uint256 value);
275 
276     event Approval(address indexed owner, address indexed spender, uint256 value);
277 }
278 
279 // File: ../../openzeppelin-solidity/contracts/math/SafeMath.sol
280 
281 pragma solidity ^0.5.0;
282 
283 /**
284  * @title SafeMath
285  * @dev Unsigned math operations with safety checks that revert on error
286  */
287 library SafeMath {
288     /**
289     * @dev Multiplies two unsigned integers, reverts on overflow.
290     */
291     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
293         // benefit is lost if 'b' is also tested.
294         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
295         if (a == 0) {
296             return 0;
297         }
298 
299         uint256 c = a * b;
300         require(c / a == b);
301 
302         return c;
303     }
304 
305     /**
306     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
307     */
308     function div(uint256 a, uint256 b) internal pure returns (uint256) {
309         // Solidity only automatically asserts when dividing by 0
310         require(b > 0);
311         uint256 c = a / b;
312         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
313 
314         return c;
315     }
316 
317     /**
318     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
319     */
320     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
321         require(b <= a);
322         uint256 c = a - b;
323 
324         return c;
325     }
326 
327     /**
328     * @dev Adds two unsigned integers, reverts on overflow.
329     */
330     function add(uint256 a, uint256 b) internal pure returns (uint256) {
331         uint256 c = a + b;
332         require(c >= a);
333 
334         return c;
335     }
336 
337     /**
338     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
339     * reverts when dividing by zero.
340     */
341     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
342         require(b != 0);
343         return a % b;
344     }
345 }
346 
347 // File: ../../openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
564 // File: contracts/controller/DAOToken.sol
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
640 // File: contracts/libs/SafeERC20.sol
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
714 // File: contracts/controller/Avatar.sol
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
734     event GenericCall(address indexed _contract, bytes _params, bool _success);
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
763     * @return bool    success or fail
764     *         bytes - the return bytes of the called contract's function.
765     */
766     function genericCall(address _contract, bytes memory _data)
767     public
768     onlyOwner
769     returns(bool success, bytes memory returnValue) {
770       // solhint-disable-next-line avoid-low-level-calls
771         (success, returnValue) = _contract.call(_data);
772         emit GenericCall(_contract, _data, success);
773     }
774 
775     /**
776     * @dev send ethers from the avatar's wallet
777     * @param _amountInWei amount to send in Wei units
778     * @param _to send the ethers to this address
779     * @return bool which represents success
780     */
781     function sendEther(uint256 _amountInWei, address payable _to) public onlyOwner returns(bool) {
782         _to.transfer(_amountInWei);
783         emit SendEther(_amountInWei, _to);
784         return true;
785     }
786 
787     /**
788     * @dev external token transfer
789     * @param _externalToken the token contract
790     * @param _to the destination address
791     * @param _value the amount of tokens to transfer
792     * @return bool which represents success
793     */
794     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
795     public onlyOwner returns(bool)
796     {
797         address(_externalToken).safeTransfer(_to, _value);
798         emit ExternalTokenTransfer(address(_externalToken), _to, _value);
799         return true;
800     }
801 
802     /**
803     * @dev external token transfer from a specific account
804     * @param _externalToken the token contract
805     * @param _from the account to spend token from
806     * @param _to the destination address
807     * @param _value the amount of tokens to transfer
808     * @return bool which represents success
809     */
810     function externalTokenTransferFrom(
811         IERC20 _externalToken,
812         address _from,
813         address _to,
814         uint256 _value
815     )
816     public onlyOwner returns(bool)
817     {
818         address(_externalToken).safeTransferFrom(_from, _to, _value);
819         emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
820         return true;
821     }
822 
823     /**
824     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
825     *      on behalf of msg.sender.
826     * @param _externalToken the address of the Token Contract
827     * @param _spender address
828     * @param _value the amount of ether (in Wei) which the approval is referring to.
829     * @return bool which represents a success
830     */
831     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
832     public onlyOwner returns(bool)
833     {
834         address(_externalToken).safeApprove(_spender, _value);
835         emit ExternalTokenApproval(address(_externalToken), _spender, _value);
836         return true;
837     }
838 
839     /**
840     * @dev metaData emits an event with a string, should contain the hash of some meta data.
841     * @param _metaData a string representing a hash of the meta data
842     * @return bool which represents a success
843     */
844     function metaData(string memory _metaData) public onlyOwner returns(bool) {
845         emit MetaData(_metaData);
846         return true;
847     }
848 
849 
850 }
851 
852 // File: contracts/globalConstraints/GlobalConstraintInterface.sol
853 
854 pragma solidity ^0.5.4;
855 
856 
857 contract GlobalConstraintInterface {
858 
859     enum CallPhase { Pre, Post, PreAndPost }
860 
861     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
862     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
863     /**
864      * @dev when return if this globalConstraints is pre, post or both.
865      * @return CallPhase enum indication  Pre, Post or PreAndPost.
866      */
867     function when() public returns(CallPhase);
868 }
869 
870 // File: contracts/controller/ControllerInterface.sol
871 
872 pragma solidity ^0.5.4;
873 
874 
875 
876 /**
877  * @title Controller contract
878  * @dev A controller controls the organizations tokens ,reputation and avatar.
879  * It is subject to a set of schemes and constraints that determine its behavior.
880  * Each scheme has it own parameters and operation permissions.
881  */
882 interface ControllerInterface {
883 
884     /**
885      * @dev Mint `_amount` of reputation that are assigned to `_to` .
886      * @param  _amount amount of reputation to mint
887      * @param _to beneficiary address
888      * @return bool which represents a success
889     */
890     function mintReputation(uint256 _amount, address _to, address _avatar)
891     external
892     returns(bool);
893 
894     /**
895      * @dev Burns `_amount` of reputation from `_from`
896      * @param _amount amount of reputation to burn
897      * @param _from The address that will lose the reputation
898      * @return bool which represents a success
899      */
900     function burnReputation(uint256 _amount, address _from, address _avatar)
901     external
902     returns(bool);
903 
904     /**
905      * @dev mint tokens .
906      * @param  _amount amount of token to mint
907      * @param _beneficiary beneficiary address
908      * @param _avatar address
909      * @return bool which represents a success
910      */
911     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
912     external
913     returns(bool);
914 
915   /**
916    * @dev register or update a scheme
917    * @param _scheme the address of the scheme
918    * @param _paramsHash a hashed configuration of the usage of the scheme
919    * @param _permissions the permissions the new scheme will have
920    * @param _avatar address
921    * @return bool which represents a success
922    */
923     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
924     external
925     returns(bool);
926 
927     /**
928      * @dev unregister a scheme
929      * @param _avatar address
930      * @param _scheme the address of the scheme
931      * @return bool which represents a success
932      */
933     function unregisterScheme(address _scheme, address _avatar)
934     external
935     returns(bool);
936 
937     /**
938      * @dev unregister the caller's scheme
939      * @param _avatar address
940      * @return bool which represents a success
941      */
942     function unregisterSelf(address _avatar) external returns(bool);
943 
944     /**
945      * @dev add or update Global Constraint
946      * @param _globalConstraint the address of the global constraint to be added.
947      * @param _params the constraint parameters hash.
948      * @param _avatar the avatar of the organization
949      * @return bool which represents a success
950      */
951     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
952     external returns(bool);
953 
954     /**
955      * @dev remove Global Constraint
956      * @param _globalConstraint the address of the global constraint to be remove.
957      * @param _avatar the organization avatar.
958      * @return bool which represents a success
959      */
960     function removeGlobalConstraint (address _globalConstraint, address _avatar)
961     external  returns(bool);
962 
963   /**
964     * @dev upgrade the Controller
965     *      The function will trigger an event 'UpgradeController'.
966     * @param  _newController the address of the new controller.
967     * @param _avatar address
968     * @return bool which represents a success
969     */
970     function upgradeController(address _newController, Avatar _avatar)
971     external returns(bool);
972 
973     /**
974     * @dev perform a generic call to an arbitrary contract
975     * @param _contract  the contract's address to call
976     * @param _data ABI-encoded contract call to call `_contract` address.
977     * @param _avatar the controller's avatar address
978     * @return bool -success
979     *         bytes  - the return value of the called _contract's function.
980     */
981     function genericCall(address _contract, bytes calldata _data, Avatar _avatar)
982     external
983     returns(bool, bytes memory);
984 
985   /**
986    * @dev send some ether
987    * @param _amountInWei the amount of ether (in Wei) to send
988    * @param _to address of the beneficiary
989    * @param _avatar address
990    * @return bool which represents a success
991    */
992     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
993     external returns(bool);
994 
995     /**
996     * @dev send some amount of arbitrary ERC20 Tokens
997     * @param _externalToken the address of the Token Contract
998     * @param _to address of the beneficiary
999     * @param _value the amount of ether (in Wei) to send
1000     * @param _avatar address
1001     * @return bool which represents a success
1002     */
1003     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1004     external
1005     returns(bool);
1006 
1007     /**
1008     * @dev transfer token "from" address "to" address
1009     *      One must to approve the amount of tokens which can be spend from the
1010     *      "from" account.This can be done using externalTokenApprove.
1011     * @param _externalToken the address of the Token Contract
1012     * @param _from address of the account to send from
1013     * @param _to address of the beneficiary
1014     * @param _value the amount of ether (in Wei) to send
1015     * @param _avatar address
1016     * @return bool which represents a success
1017     */
1018     function externalTokenTransferFrom(
1019     IERC20 _externalToken,
1020     address _from,
1021     address _to,
1022     uint256 _value,
1023     Avatar _avatar)
1024     external
1025     returns(bool);
1026 
1027     /**
1028     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1029     *      on behalf of msg.sender.
1030     * @param _externalToken the address of the Token Contract
1031     * @param _spender address
1032     * @param _value the amount of ether (in Wei) which the approval is referring to.
1033     * @return bool which represents a success
1034     */
1035     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1036     external
1037     returns(bool);
1038 
1039     /**
1040     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1041     * @param _metaData a string representing a hash of the meta data
1042     * @param _avatar Avatar
1043     * @return bool which represents a success
1044     */
1045     function metaData(string calldata _metaData, Avatar _avatar) external returns(bool);
1046 
1047     /**
1048      * @dev getNativeReputation
1049      * @param _avatar the organization avatar.
1050      * @return organization native reputation
1051      */
1052     function getNativeReputation(address _avatar)
1053     external
1054     view
1055     returns(address);
1056 
1057     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
1058 
1059     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1060 
1061     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1062 
1063     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1064 
1065     /**
1066      * @dev globalConstraintsCount return the global constraint pre and post count
1067      * @return uint256 globalConstraintsPre count.
1068      * @return uint256 globalConstraintsPost count.
1069      */
1070     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1071 
1072     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1073 }
1074 
1075 // File: controller/UController.sol
1076 
1077 pragma solidity ^0.5.4;
1078 
1079 
1080 
1081 
1082 
1083 /**
1084  * @title Universal Controller contract
1085  * @dev A universal controller hold organizations and controls their tokens ,reputations
1086  *       and avatar.
1087  * It is subject to a set of schemes and constraints that determine its behavior.
1088  * Each scheme has it own parameters and operation permissions.
1089  */
1090 contract UController is ControllerInterface {
1091 
1092     struct Scheme {
1093         bytes32 paramsHash;  // a hash "configuration" of the scheme
1094         bytes4  permissions; // A bitwise flags of permissions,
1095                             // All 0: Not registered,
1096                             // 1st bit: Flag if the scheme is registered,
1097                             // 2nd bit: Scheme can register other schemes
1098                             // 3th bit: Scheme can add/remove global constraints
1099                             // 4rd bit: Scheme can upgrade the controller
1100                             // 5th bit: Scheme can call delegatecall
1101     }
1102 
1103     struct GlobalConstraint {
1104         address gcAddress;
1105         bytes32 params;
1106     }
1107 
1108     struct GlobalConstraintRegister {
1109         bool isRegistered; //is registered
1110         uint256 index;    //index at globalConstraints
1111     }
1112 
1113     struct Organization {
1114         DAOToken                  nativeToken;
1115         Reputation                nativeReputation;
1116         mapping(address=>Scheme)  schemes;
1117       // globalConstraintsPre that determine pre- conditions for all actions on the controller
1118         GlobalConstraint[] globalConstraintsPre;
1119         // globalConstraintsPost that determine post-conditions for all actions on the controller
1120         GlobalConstraint[] globalConstraintsPost;
1121       // globalConstraintsRegisterPre indicate if a globalConstraints is registered as a Pre global constraint.
1122         mapping(address=>GlobalConstraintRegister) globalConstraintsRegisterPre;
1123       // globalConstraintsRegisterPost indicate if a globalConstraints is registered as a Post global constraint.
1124         mapping(address=>GlobalConstraintRegister) globalConstraintsRegisterPost;
1125         bool exist;
1126     }
1127 
1128     //mapping between organization's avatar address to Organization
1129     mapping(address=>Organization) public organizations;
1130   // newController will point to the new controller after the present controller is upgraded
1131   //  address external newController;
1132     mapping(address=>address) public newControllers;//mapping between avatar address and newController address
1133 
1134     //mapping for all reputation system addresses registered.
1135     mapping(address=>bool) public reputations;
1136     //mapping for all tokens addresses registered.
1137     mapping(address=>bool) public tokens;
1138 
1139 
1140     event MintReputation (address indexed _sender, address indexed _to, uint256 _amount, address indexed _avatar);
1141     event BurnReputation (address indexed _sender, address indexed _from, uint256 _amount, address indexed _avatar);
1142     event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount, address indexed _avatar);
1143     event RegisterScheme (address indexed _sender, address indexed _scheme, address indexed _avatar);
1144     event UnregisterScheme (address indexed _sender, address indexed _scheme, address indexed _avatar);
1145     event UpgradeController(address indexed _oldController, address _newController, address _avatar);
1146 
1147     event AddGlobalConstraint(
1148         address indexed _globalConstraint,
1149         bytes32 _params,
1150         GlobalConstraintInterface.CallPhase _when,
1151         address indexed _avatar
1152     );
1153 
1154     event RemoveGlobalConstraint(
1155         address indexed _globalConstraint,
1156         uint256 _index,
1157         bool _isPre,
1158         address indexed _avatar
1159     );
1160 
1161    /**
1162     * @dev newOrganization set up a new organization with default daoCreator.
1163     * @param _avatar the organization avatar
1164     */
1165     function newOrganization(
1166         Avatar _avatar
1167     ) external
1168     {
1169         require(!organizations[address(_avatar)].exist);
1170         require(_avatar.owner() == address(this));
1171         DAOToken nativeToken = _avatar.nativeToken();
1172         Reputation nativeReputation = _avatar.nativeReputation();
1173         //To guaranty uniqueness for the reputation systems.
1174         require(!reputations[address(nativeReputation)]);
1175         //To guaranty uniqueness for the nativeToken.
1176         require(!tokens[address(nativeToken)]);
1177         organizations[address(_avatar)].exist = true;
1178         organizations[address(_avatar)].nativeToken = nativeToken;
1179         organizations[address(_avatar)].nativeReputation = nativeReputation;
1180         reputations[address(nativeReputation)] = true;
1181         tokens[address(nativeToken)] = true;
1182         organizations[address(_avatar)].schemes[msg.sender] =
1183         Scheme({paramsHash: bytes32(0), permissions: bytes4(0x0000001f)});
1184         emit RegisterScheme(msg.sender, msg.sender, address(_avatar));
1185     }
1186 
1187   // Modifiers:
1188     modifier onlyRegisteredScheme(address avatar) {
1189         require(organizations[avatar].schemes[msg.sender].permissions&bytes4(0x00000001) == bytes4(0x00000001));
1190         _;
1191     }
1192 
1193     modifier onlyRegisteringSchemes(address avatar) {
1194         require(organizations[avatar].schemes[msg.sender].permissions&bytes4(0x00000002) == bytes4(0x00000002));
1195         _;
1196     }
1197 
1198     modifier onlyGlobalConstraintsScheme(address avatar) {
1199         require(organizations[avatar].schemes[msg.sender].permissions&bytes4(0x00000004) == bytes4(0x00000004));
1200         _;
1201     }
1202 
1203     modifier onlyUpgradingScheme(address _avatar) {
1204         require(organizations[_avatar].schemes[msg.sender].permissions&bytes4(0x00000008) == bytes4(0x00000008));
1205         _;
1206     }
1207 
1208     modifier onlyGenericCallScheme(address _avatar) {
1209         require(organizations[_avatar].schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1210         _;
1211     }
1212 
1213     modifier onlyMetaDataScheme(address _avatar) {
1214         require(organizations[_avatar].schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1215         _;
1216     }
1217 
1218     modifier onlySubjectToConstraint(bytes32 func, address _avatar) {
1219         uint256 idx;
1220         GlobalConstraint[] memory globalConstraintsPre = organizations[_avatar].globalConstraintsPre;
1221         GlobalConstraint[] memory globalConstraintsPost = organizations[_avatar].globalConstraintsPost;
1222         for (idx = 0; idx < globalConstraintsPre.length; idx++) {
1223             require(
1224             (GlobalConstraintInterface(globalConstraintsPre[idx].gcAddress))
1225             .pre(msg.sender, globalConstraintsPre[idx].params, func));
1226         }
1227         _;
1228         for (idx = 0; idx < globalConstraintsPost.length; idx++) {
1229             require(
1230             (GlobalConstraintInterface(globalConstraintsPost[idx].gcAddress))
1231             .post(msg.sender, globalConstraintsPost[idx].params, func));
1232         }
1233     }
1234 
1235     /**
1236      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1237      * @param  _amount amount of reputation to mint
1238      * @param _to beneficiary address
1239      * @param _avatar the address of the organization's avatar
1240      * @return bool which represents a success
1241      */
1242     function mintReputation(uint256 _amount, address _to, address _avatar)
1243     external
1244     onlyRegisteredScheme(_avatar)
1245     onlySubjectToConstraint("mintReputation", _avatar)
1246     returns(bool)
1247     {
1248         emit MintReputation(msg.sender, _to, _amount, _avatar);
1249         return organizations[_avatar].nativeReputation.mint(_to, _amount);
1250     }
1251 
1252     /**
1253      * @dev Burns `_amount` of reputation from `_from`
1254      * @param _amount amount of reputation to burn
1255      * @param _from The address that will lose the reputation
1256      * @return bool which represents a success
1257      */
1258     function burnReputation(uint256 _amount, address _from, address _avatar)
1259     external
1260     onlyRegisteredScheme(_avatar)
1261     onlySubjectToConstraint("burnReputation", _avatar)
1262     returns(bool)
1263     {
1264         emit BurnReputation(msg.sender, _from, _amount, _avatar);
1265         return organizations[_avatar].nativeReputation.burn(_from, _amount);
1266     }
1267 
1268     /**
1269      * @dev mint tokens .
1270      * @param  _amount amount of token to mint
1271      * @param _beneficiary beneficiary address
1272      * @param _avatar the organization avatar.
1273      * @return bool which represents a success
1274      */
1275     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
1276     external
1277     onlyRegisteredScheme(_avatar)
1278     onlySubjectToConstraint("mintTokens", _avatar)
1279     returns(bool)
1280     {
1281         emit MintTokens(msg.sender, _beneficiary, _amount, _avatar);
1282         return organizations[_avatar].nativeToken.mint(_beneficiary, _amount);
1283     }
1284 
1285   /**
1286    * @dev register or update a scheme
1287    * @param _scheme the address of the scheme
1288    * @param _paramsHash a hashed configuration of the usage of the scheme
1289    * @param _permissions the permissions the new scheme will have
1290    * @param _avatar the organization avatar.
1291    * @return bool which represents a success
1292    */
1293     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
1294     external
1295     onlyRegisteringSchemes(_avatar)
1296     onlySubjectToConstraint("registerScheme", _avatar)
1297     returns(bool)
1298     {
1299         bytes4 schemePermission = organizations[_avatar].schemes[_scheme].permissions;
1300         bytes4 senderPermission = organizations[_avatar].schemes[msg.sender].permissions;
1301     // Check scheme has at least the permissions it is changing, and at least the current permissions:
1302     // Implementation is a bit messy. One must recall logic-circuits ^^
1303 
1304     // produces non-zero if sender does not have all of the perms that are changing between old and new
1305         require(bytes4(0x0000001f)&(_permissions^schemePermission)&(~senderPermission) == bytes4(0));
1306 
1307     // produces non-zero if sender does not have all of the perms in the old scheme
1308         require(bytes4(0x0000001f)&(schemePermission&(~senderPermission)) == bytes4(0));
1309 
1310     // Add or change the scheme:
1311         organizations[_avatar].schemes[_scheme] =
1312         Scheme({paramsHash:_paramsHash, permissions:_permissions|bytes4(0x00000001)});
1313         emit RegisterScheme(msg.sender, _scheme, _avatar);
1314         return true;
1315     }
1316 
1317     /**
1318      * @dev unregister a scheme
1319      * @param _scheme the address of the scheme
1320      * @param _avatar the organization avatar.
1321      * @return bool which represents a success
1322      */
1323     function unregisterScheme(address _scheme, address _avatar)
1324     external
1325     onlyRegisteringSchemes(_avatar)
1326     onlySubjectToConstraint("unregisterScheme", _avatar)
1327     returns(bool)
1328     {
1329         bytes4 schemePermission = organizations[_avatar].schemes[_scheme].permissions;
1330     //check if the scheme is registered
1331         if (schemePermission&bytes4(0x00000001) == bytes4(0)) {
1332             return false;
1333         }
1334     // Check the unregistering scheme has enough permissions:
1335         require(
1336         bytes4(0x0000001f)&(schemePermission&(~organizations[_avatar].schemes[msg.sender].permissions)) == bytes4(0));
1337 
1338     // Unregister:
1339         emit UnregisterScheme(msg.sender, _scheme, _avatar);
1340         delete organizations[_avatar].schemes[_scheme];
1341         return true;
1342     }
1343 
1344     /**
1345      * @dev unregister the caller's scheme
1346      * @param _avatar the organization avatar.
1347      * @return bool which represents a success
1348      */
1349     function unregisterSelf(address _avatar) external returns(bool) {
1350         if (_isSchemeRegistered(msg.sender, _avatar) == false) {
1351             return false;
1352         }
1353         delete organizations[_avatar].schemes[msg.sender];
1354         emit UnregisterScheme(msg.sender, msg.sender, _avatar);
1355         return true;
1356     }
1357 
1358     /**
1359      * @dev add or update Global Constraint
1360      * @param _globalConstraint the address of the global constraint to be added.
1361      * @param _params the constraint parameters hash.
1362      * @param _avatar the avatar of the organization
1363      * @return bool which represents a success
1364      */
1365     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
1366     external onlyGlobalConstraintsScheme(_avatar) returns(bool)
1367     {
1368         Organization storage organization = organizations[_avatar];
1369         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1370         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1371             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1372             if (!organization.globalConstraintsRegisterPre[_globalConstraint].isRegistered) {
1373                 organization.globalConstraintsPre.push(GlobalConstraint(_globalConstraint, _params));
1374                 organization.globalConstraintsRegisterPre[_globalConstraint] =
1375                 GlobalConstraintRegister(true, organization.globalConstraintsPre.length-1);
1376             }else {
1377                 organization
1378                 .globalConstraintsPre[organization.globalConstraintsRegisterPre[_globalConstraint].index]
1379                 .params = _params;
1380             }
1381         }
1382 
1383         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1384             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1385             if (!organization.globalConstraintsRegisterPost[_globalConstraint].isRegistered) {
1386                 organization.globalConstraintsPost.push(GlobalConstraint(_globalConstraint, _params));
1387                 organization.globalConstraintsRegisterPost[_globalConstraint] =
1388                 GlobalConstraintRegister(true, organization.globalConstraintsPost.length-1);
1389             } else {
1390                 organization
1391                 .globalConstraintsPost[organization.globalConstraintsRegisterPost[_globalConstraint].index]
1392                 .params = _params;
1393             }
1394         }
1395         emit AddGlobalConstraint(_globalConstraint, _params, when, _avatar);
1396         return true;
1397     }
1398 
1399     /**
1400      * @dev remove Global Constraint
1401      * @param _globalConstraint the address of the global constraint to be remove.
1402      * @param _avatar the organization avatar.
1403      * @return bool which represents a success
1404      */
1405     function removeGlobalConstraint (address _globalConstraint, address _avatar)
1406     external onlyGlobalConstraintsScheme(_avatar) returns(bool)
1407     {
1408         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1409         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1410             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1411             removeGlobalConstraintPre(_globalConstraint, _avatar);
1412         }
1413         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1414             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1415             removeGlobalConstraintPost(_globalConstraint, _avatar);
1416         }
1417         return true;
1418     }
1419 
1420   /**
1421     * @dev upgrade the Controller
1422     *      The function will trigger an event 'UpgradeController'.
1423     * @param  _newController the address of the new controller.
1424     * @param _avatar the organization avatar.
1425     * @return bool which represents a success
1426     */
1427     function upgradeController(address _newController, Avatar _avatar)
1428     external onlyUpgradingScheme(address(_avatar)) returns(bool)
1429     {
1430         require(newControllers[address(_avatar)] == address(0));   // so the upgrade could be done once for a contract.
1431         require(_newController != address(0));
1432         newControllers[address(_avatar)] = _newController;
1433         _avatar.transferOwnership(_newController);
1434         require(_avatar.owner() == _newController);
1435         if (organizations[address(_avatar)].nativeToken.owner() == address(this)) {
1436             organizations[address(_avatar)].nativeToken.transferOwnership(_newController);
1437             require(organizations[address(_avatar)].nativeToken.owner() == _newController);
1438         }
1439         if (organizations[address(_avatar)].nativeReputation.owner() == address(this)) {
1440             organizations[address(_avatar)].nativeReputation.transferOwnership(_newController);
1441             require(organizations[address(_avatar)].nativeReputation.owner() == _newController);
1442         }
1443         emit UpgradeController(address(this), _newController, address(_avatar));
1444         return true;
1445     }
1446 
1447     /**
1448     * @dev perform a generic call to an arbitrary contract
1449     * @param _contract  the contract's address to call
1450     * @param _data ABI-encoded contract call to call `_contract` address.
1451     * @return bool -success
1452     *         bytes  - the return value of the called _contract's function.
1453     */
1454     function genericCall(address _contract, bytes calldata _data, Avatar _avatar)
1455     external
1456     onlyGenericCallScheme(address(_avatar))
1457     onlySubjectToConstraint("genericCall", address(_avatar))
1458     returns (bool, bytes memory)
1459     {
1460         return _avatar.genericCall(_contract, _data);
1461     }
1462 
1463   /**
1464    * @dev send some ether
1465    * @param _amountInWei the amount of ether (in Wei) to send
1466    * @param _to address of the beneficiary
1467    * @param _avatar the organization avatar.
1468    * @return bool which represents a success
1469    */
1470     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
1471     external
1472     onlyRegisteredScheme(address(_avatar))
1473     onlySubjectToConstraint("sendEther", address(_avatar))
1474     returns(bool)
1475     {
1476         return _avatar.sendEther(_amountInWei, _to);
1477     }
1478 
1479     /**
1480     * @dev send some amount of arbitrary ERC20 Tokens
1481     * @param _externalToken the address of the Token Contract
1482     * @param _to address of the beneficiary
1483     * @param _value the amount of ether (in Wei) to send
1484     * @param _avatar the organization avatar.
1485     * @return bool which represents a success
1486     */
1487     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1488     external
1489     onlyRegisteredScheme(address(_avatar))
1490     onlySubjectToConstraint("externalTokenTransfer", address(_avatar))
1491     returns(bool)
1492     {
1493         return _avatar.externalTokenTransfer(_externalToken, _to, _value);
1494     }
1495 
1496     /**
1497     * @dev transfer token "from" address "to" address
1498     *      One must to approve the amount of tokens which can be spend from the
1499     *      "from" account.This can be done using externalTokenApprove.
1500     * @param _externalToken the address of the Token Contract
1501     * @param _from address of the account to send from
1502     * @param _to address of the beneficiary
1503     * @param _value the amount of ether (in Wei) to send
1504     * @param _avatar the organization avatar.
1505     * @return bool which represents a success
1506     */
1507     function externalTokenTransferFrom(
1508     IERC20 _externalToken,
1509     address _from,
1510     address _to,
1511     uint256 _value,
1512     Avatar _avatar)
1513     external
1514     onlyRegisteredScheme(address(_avatar))
1515     onlySubjectToConstraint("externalTokenTransferFrom", address(_avatar))
1516     returns(bool)
1517     {
1518         return _avatar.externalTokenTransferFrom(_externalToken, _from, _to, _value);
1519     }
1520 
1521     /**
1522     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1523     *      on behalf of msg.sender.
1524     * @param _externalToken the address of the Token Contract
1525     * @param _spender address
1526     * @param _value the amount of ether (in Wei) which the approval is referring to.
1527     * @return bool which represents a success
1528     */
1529     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1530     external
1531     onlyRegisteredScheme(address(_avatar))
1532     onlySubjectToConstraint("externalTokenApproval", address(_avatar))
1533     returns(bool)
1534     {
1535         return _avatar.externalTokenApproval(_externalToken, _spender, _value);
1536     }
1537 
1538     /**
1539     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1540     * @param _metaData a string representing a hash of the meta data
1541     * @param _avatar Avatar
1542     * @return bool which represents a success
1543     */
1544     function metaData(string calldata _metaData, Avatar _avatar)
1545         external
1546         onlyMetaDataScheme(address(_avatar))
1547         returns(bool)
1548         {
1549         return _avatar.metaData(_metaData);
1550     }
1551 
1552     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool) {
1553         return _isSchemeRegistered(_scheme, _avatar);
1554     }
1555 
1556     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32) {
1557         return organizations[_avatar].schemes[_scheme].paramsHash;
1558     }
1559 
1560     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4) {
1561         return organizations[_avatar].schemes[_scheme].permissions;
1562     }
1563 
1564     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32) {
1565 
1566         Organization storage organization = organizations[_avatar];
1567 
1568         GlobalConstraintRegister memory register = organization.globalConstraintsRegisterPre[_globalConstraint];
1569 
1570         if (register.isRegistered) {
1571             return organization.globalConstraintsPre[register.index].params;
1572         }
1573 
1574         register = organization.globalConstraintsRegisterPost[_globalConstraint];
1575 
1576         if (register.isRegistered) {
1577             return organization.globalConstraintsPost[register.index].params;
1578         }
1579     }
1580 
1581    /**
1582    * @dev globalConstraintsCount return the global constraint pre and post count
1583    * @return uint256 globalConstraintsPre count.
1584    * @return uint256 globalConstraintsPost count.
1585    */
1586     function globalConstraintsCount(address _avatar) external view returns(uint, uint) {
1587         return (
1588         organizations[_avatar].globalConstraintsPre.length,
1589         organizations[_avatar].globalConstraintsPost.length
1590         );
1591     }
1592 
1593     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool) {
1594         return (organizations[_avatar].globalConstraintsRegisterPre[_globalConstraint].isRegistered ||
1595         organizations[_avatar].globalConstraintsRegisterPost[_globalConstraint].isRegistered);
1596     }
1597 
1598     /**
1599      * @dev getNativeReputation
1600      * @param _avatar the organization avatar.
1601      * @return organization native reputation
1602      */
1603     function getNativeReputation(address _avatar) external view returns(address) {
1604         return address(organizations[_avatar].nativeReputation);
1605     }
1606 
1607     /**
1608      * @dev removeGlobalConstraintPre
1609      * @param _globalConstraint the address of the global constraint to be remove.
1610      * @param _avatar the organization avatar.
1611      * @return bool which represents a success
1612      */
1613     function removeGlobalConstraintPre(address _globalConstraint, address _avatar)
1614     private returns(bool)
1615     {
1616         GlobalConstraintRegister memory globalConstraintRegister =
1617         organizations[_avatar].globalConstraintsRegisterPre[_globalConstraint];
1618         GlobalConstraint[] storage globalConstraints = organizations[_avatar].globalConstraintsPre;
1619 
1620         if (globalConstraintRegister.isRegistered) {
1621             if (globalConstraintRegister.index < globalConstraints.length-1) {
1622                 GlobalConstraint memory globalConstraint = globalConstraints[globalConstraints.length-1];
1623                 globalConstraints[globalConstraintRegister.index] = globalConstraint;
1624                 organizations[_avatar].globalConstraintsRegisterPre[globalConstraint.gcAddress].index =
1625                 globalConstraintRegister.index;
1626             }
1627             globalConstraints.length--;
1628             delete organizations[_avatar].globalConstraintsRegisterPre[_globalConstraint];
1629             emit RemoveGlobalConstraint(_globalConstraint, globalConstraintRegister.index, true, _avatar);
1630             return true;
1631         }
1632         return false;
1633     }
1634 
1635     /**
1636      * @dev removeGlobalConstraintPost
1637      * @param _globalConstraint the address of the global constraint to be remove.
1638      * @param _avatar the organization avatar.
1639      * @return bool which represents a success
1640      */
1641     function removeGlobalConstraintPost(address _globalConstraint, address _avatar)
1642     private returns(bool)
1643     {
1644         GlobalConstraintRegister memory globalConstraintRegister =
1645         organizations[_avatar].globalConstraintsRegisterPost[_globalConstraint];
1646         GlobalConstraint[] storage globalConstraints = organizations[_avatar].globalConstraintsPost;
1647 
1648         if (globalConstraintRegister.isRegistered) {
1649             if (globalConstraintRegister.index < globalConstraints.length-1) {
1650                 GlobalConstraint memory globalConstraint = globalConstraints[globalConstraints.length-1];
1651                 globalConstraints[globalConstraintRegister.index] = globalConstraint;
1652                 organizations[_avatar].globalConstraintsRegisterPost[globalConstraint.gcAddress].index =
1653                 globalConstraintRegister.index;
1654             }
1655             globalConstraints.length--;
1656             delete organizations[_avatar].globalConstraintsRegisterPost[_globalConstraint];
1657             emit RemoveGlobalConstraint(_globalConstraint, globalConstraintRegister.index, false, _avatar);
1658             return true;
1659         }
1660         return false;
1661     }
1662 
1663     function _isSchemeRegistered( address _scheme, address _avatar) private view returns(bool) {
1664         return (organizations[_avatar].schemes[_scheme].permissions&bytes4(0x00000001) != bytes4(0));
1665     }
1666 }