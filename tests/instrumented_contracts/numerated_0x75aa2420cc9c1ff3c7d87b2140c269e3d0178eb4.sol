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
78 pragma solidity ^0.5.2;
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
253 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
279 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
564 // File: contracts/controller/DAOToken.sol
565 
566 pragma solidity ^0.5.2;
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
656 pragma solidity ^0.5.2;
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
702         require((_value == 0) || (IERC20(_erc20Addr).allowance(msg.sender, _spender) == 0));
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
716 pragma solidity ^0.5.2;
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
740 
741     /**
742     * @dev the constructor takes organization name, native token and reputation system
743     and creates an avatar for a controller
744     */
745     constructor(string memory _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
746         orgName = _orgName;
747         nativeToken = _nativeToken;
748         nativeReputation = _nativeReputation;
749     }
750 
751     /**
752     * @dev enables an avatar to receive ethers
753     */
754     function() external payable {
755         emit ReceiveEther(msg.sender, msg.value);
756     }
757 
758     /**
759     * @dev perform a generic call to an arbitrary contract
760     * @param _contract  the contract's address to call
761     * @param _data ABI-encoded contract call to call `_contract` address.
762     * @return bool    success or fail
763     *         bytes - the return bytes of the called contract's function.
764     */
765     function genericCall(address _contract, bytes memory _data)
766     public
767     onlyOwner
768     returns(bool success, bytes memory returnValue) {
769       // solhint-disable-next-line avoid-low-level-calls
770         (success, returnValue) = _contract.call(_data);
771         emit GenericCall(_contract, _data, success);
772     }
773 
774     /**
775     * @dev send ethers from the avatar's wallet
776     * @param _amountInWei amount to send in Wei units
777     * @param _to send the ethers to this address
778     * @return bool which represents success
779     */
780     function sendEther(uint256 _amountInWei, address payable _to) public onlyOwner returns(bool) {
781         _to.transfer(_amountInWei);
782         emit SendEther(_amountInWei, _to);
783         return true;
784     }
785 
786     /**
787     * @dev external token transfer
788     * @param _externalToken the token contract
789     * @param _to the destination address
790     * @param _value the amount of tokens to transfer
791     * @return bool which represents success
792     */
793     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
794     public onlyOwner returns(bool)
795     {
796         address(_externalToken).safeTransfer(_to, _value);
797         emit ExternalTokenTransfer(address(_externalToken), _to, _value);
798         return true;
799     }
800 
801     /**
802     * @dev external token transfer from a specific account
803     * @param _externalToken the token contract
804     * @param _from the account to spend token from
805     * @param _to the destination address
806     * @param _value the amount of tokens to transfer
807     * @return bool which represents success
808     */
809     function externalTokenTransferFrom(
810         IERC20 _externalToken,
811         address _from,
812         address _to,
813         uint256 _value
814     )
815     public onlyOwner returns(bool)
816     {
817         address(_externalToken).safeTransferFrom(_from, _to, _value);
818         emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
819         return true;
820     }
821 
822     /**
823     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
824     *      on behalf of msg.sender.
825     * @param _externalToken the address of the Token Contract
826     * @param _spender address
827     * @param _value the amount of ether (in Wei) which the approval is referring to.
828     * @return bool which represents a success
829     */
830     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
831     public onlyOwner returns(bool)
832     {
833         address(_externalToken).safeApprove(_spender, _value);
834         emit ExternalTokenApproval(address(_externalToken), _spender, _value);
835         return true;
836     }
837 
838 }
839 
840 // File: contracts/globalConstraints/GlobalConstraintInterface.sol
841 
842 pragma solidity ^0.5.2;
843 
844 
845 contract GlobalConstraintInterface {
846 
847     enum CallPhase { Pre, Post, PreAndPost }
848 
849     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
850     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
851     /**
852      * @dev when return if this globalConstraints is pre, post or both.
853      * @return CallPhase enum indication  Pre, Post or PreAndPost.
854      */
855     function when() public returns(CallPhase);
856 }
857 
858 // File: contracts/controller/ControllerInterface.sol
859 
860 pragma solidity ^0.5.2;
861 
862 
863 
864 /**
865  * @title Controller contract
866  * @dev A controller controls the organizations tokens ,reputation and avatar.
867  * It is subject to a set of schemes and constraints that determine its behavior.
868  * Each scheme has it own parameters and operation permissions.
869  */
870 interface ControllerInterface {
871 
872     /**
873      * @dev Mint `_amount` of reputation that are assigned to `_to` .
874      * @param  _amount amount of reputation to mint
875      * @param _to beneficiary address
876      * @return bool which represents a success
877     */
878     function mintReputation(uint256 _amount, address _to, address _avatar)
879     external
880     returns(bool);
881 
882     /**
883      * @dev Burns `_amount` of reputation from `_from`
884      * @param _amount amount of reputation to burn
885      * @param _from The address that will lose the reputation
886      * @return bool which represents a success
887      */
888     function burnReputation(uint256 _amount, address _from, address _avatar)
889     external
890     returns(bool);
891 
892     /**
893      * @dev mint tokens .
894      * @param  _amount amount of token to mint
895      * @param _beneficiary beneficiary address
896      * @param _avatar address
897      * @return bool which represents a success
898      */
899     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
900     external
901     returns(bool);
902 
903   /**
904    * @dev register or update a scheme
905    * @param _scheme the address of the scheme
906    * @param _paramsHash a hashed configuration of the usage of the scheme
907    * @param _permissions the permissions the new scheme will have
908    * @param _avatar address
909    * @return bool which represents a success
910    */
911     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
912     external
913     returns(bool);
914 
915     /**
916      * @dev unregister a scheme
917      * @param _avatar address
918      * @param _scheme the address of the scheme
919      * @return bool which represents a success
920      */
921     function unregisterScheme(address _scheme, address _avatar)
922     external
923     returns(bool);
924 
925     /**
926      * @dev unregister the caller's scheme
927      * @param _avatar address
928      * @return bool which represents a success
929      */
930     function unregisterSelf(address _avatar) external returns(bool);
931 
932     /**
933      * @dev add or update Global Constraint
934      * @param _globalConstraint the address of the global constraint to be added.
935      * @param _params the constraint parameters hash.
936      * @param _avatar the avatar of the organization
937      * @return bool which represents a success
938      */
939     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
940     external returns(bool);
941 
942     /**
943      * @dev remove Global Constraint
944      * @param _globalConstraint the address of the global constraint to be remove.
945      * @param _avatar the organization avatar.
946      * @return bool which represents a success
947      */
948     function removeGlobalConstraint (address _globalConstraint, address _avatar)
949     external  returns(bool);
950 
951   /**
952     * @dev upgrade the Controller
953     *      The function will trigger an event 'UpgradeController'.
954     * @param  _newController the address of the new controller.
955     * @param _avatar address
956     * @return bool which represents a success
957     */
958     function upgradeController(address _newController, Avatar _avatar)
959     external returns(bool);
960 
961     /**
962     * @dev perform a generic call to an arbitrary contract
963     * @param _contract  the contract's address to call
964     * @param _data ABI-encoded contract call to call `_contract` address.
965     * @param _avatar the controller's avatar address
966     * @return bool -success
967     *         bytes  - the return value of the called _contract's function.
968     */
969     function genericCall(address _contract, bytes calldata _data, Avatar _avatar)
970     external
971     returns(bool, bytes memory);
972 
973   /**
974    * @dev send some ether
975    * @param _amountInWei the amount of ether (in Wei) to send
976    * @param _to address of the beneficiary
977    * @param _avatar address
978    * @return bool which represents a success
979    */
980     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
981     external returns(bool);
982 
983     /**
984     * @dev send some amount of arbitrary ERC20 Tokens
985     * @param _externalToken the address of the Token Contract
986     * @param _to address of the beneficiary
987     * @param _value the amount of ether (in Wei) to send
988     * @param _avatar address
989     * @return bool which represents a success
990     */
991     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
992     external
993     returns(bool);
994 
995     /**
996     * @dev transfer token "from" address "to" address
997     *      One must to approve the amount of tokens which can be spend from the
998     *      "from" account.This can be done using externalTokenApprove.
999     * @param _externalToken the address of the Token Contract
1000     * @param _from address of the account to send from
1001     * @param _to address of the beneficiary
1002     * @param _value the amount of ether (in Wei) to send
1003     * @param _avatar address
1004     * @return bool which represents a success
1005     */
1006     function externalTokenTransferFrom(
1007     IERC20 _externalToken,
1008     address _from,
1009     address _to,
1010     uint256 _value,
1011     Avatar _avatar)
1012     external
1013     returns(bool);
1014 
1015     /**
1016     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1017     *      on behalf of msg.sender.
1018     * @param _externalToken the address of the Token Contract
1019     * @param _spender address
1020     * @param _value the amount of ether (in Wei) which the approval is referring to.
1021     * @return bool which represents a success
1022     */
1023     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1024     external
1025     returns(bool);
1026 
1027     /**
1028      * @dev getNativeReputation
1029      * @param _avatar the organization avatar.
1030      * @return organization native reputation
1031      */
1032     function getNativeReputation(address _avatar)
1033     external
1034     view
1035     returns(address);
1036 
1037     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
1038 
1039     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1040 
1041     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1042 
1043     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1044 
1045     /**
1046      * @dev globalConstraintsCount return the global constraint pre and post count
1047      * @return uint256 globalConstraintsPre count.
1048      * @return uint256 globalConstraintsPost count.
1049      */
1050     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1051 
1052     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1053 }
1054 
1055 // File: contracts/schemes/Locking4Reputation.sol
1056 
1057 pragma solidity ^0.5.2;
1058 
1059 
1060 
1061 /**
1062  * @title A locker contract
1063  */
1064 
1065 contract Locking4Reputation {
1066     using SafeMath for uint256;
1067 
1068     event Redeem(address indexed _beneficiary, uint256 _amount);
1069     event Release(bytes32 indexed _lockingId, address indexed _beneficiary, uint256 _amount);
1070     event Lock(address indexed _locker, bytes32 indexed _lockingId, uint256 _amount, uint256 _period);
1071 
1072     struct Locker {
1073         uint256 amount;
1074         uint256 releaseTime;
1075     }
1076 
1077     Avatar public avatar;
1078 
1079     // A mapping from lockers addresses their lock balances.
1080     mapping(address => mapping(bytes32=>Locker)) public lockers;
1081     // A mapping from lockers addresses to their scores.
1082     mapping(address => uint) public scores;
1083 
1084     uint256 public totalLocked;
1085     uint256 public totalLockedLeft;
1086     uint256 public totalScore;
1087     uint256 public lockingsCounter; // Total number of lockings
1088     uint256 public reputationReward;
1089     uint256 public reputationRewardLeft;
1090     uint256 public lockingEndTime;
1091     uint256 public maxLockingPeriod;
1092     uint256 public lockingStartTime;
1093     uint256 public redeemEnableTime;
1094 
1095     /**
1096      * @dev redeem reputation function
1097      * @param _beneficiary the beneficiary for the release
1098      * @return uint256 reputation rewarded
1099      */
1100     function redeem(address _beneficiary) public returns(uint256 reputation) {
1101         // solhint-disable-next-line not-rely-on-time
1102         require(block.timestamp > redeemEnableTime, "now > redeemEnableTime");
1103         require(scores[_beneficiary] > 0, "score should be > 0");
1104         uint256 score = scores[_beneficiary];
1105         scores[_beneficiary] = 0;
1106         uint256 repRelation = score.mul(reputationReward);
1107         reputation = repRelation.div(totalScore);
1108 
1109         //check that the reputation is sum zero
1110         reputationRewardLeft = reputationRewardLeft.sub(reputation);
1111         require(
1112         ControllerInterface(
1113         avatar.owner())
1114         .mintReputation(reputation, _beneficiary, address(avatar)), "mint reputation should succeed");
1115 
1116         emit Redeem(_beneficiary, reputation);
1117     }
1118 
1119     /**
1120      * @dev release function
1121      * @param _beneficiary the beneficiary for the release
1122      * @param _lockingId the locking id to release
1123      * @return bool
1124      */
1125     function _release(address _beneficiary, bytes32 _lockingId) internal returns(uint256 amount) {
1126         Locker storage locker = lockers[_beneficiary][_lockingId];
1127         require(locker.amount > 0, "amount should be > 0");
1128         amount = locker.amount;
1129         locker.amount = 0;
1130         // solhint-disable-next-line not-rely-on-time
1131         require(block.timestamp > locker.releaseTime, "check the lock period pass");
1132         totalLockedLeft = totalLockedLeft.sub(amount);
1133 
1134         emit Release(_lockingId, _beneficiary, amount);
1135     }
1136 
1137     /**
1138      * @dev lock function
1139      * @param _amount the amount to lock
1140      * @param _period the locking period
1141      * @param _locker the locker
1142      * @param _numerator price numerator
1143      * @param _denominator price denominator
1144      * @return lockingId
1145      */
1146     function _lock(
1147         uint256 _amount,
1148         uint256 _period,
1149         address _locker,
1150         uint256 _numerator,
1151         uint256 _denominator)
1152         internal
1153         returns(bytes32 lockingId)
1154         {
1155         require(_amount > 0, "locking amount should be > 0");
1156         require(_period <= maxLockingPeriod, "locking period should be <= maxLockingPeriod");
1157         require(_period > 0, "locking period should be > 0");
1158         // solhint-disable-next-line not-rely-on-time
1159         require(now <= lockingEndTime, "lock should be within the allowed locking period");
1160         // solhint-disable-next-line not-rely-on-time
1161         require(now >= lockingStartTime, "lock should start after lockingStartTime");
1162 
1163         lockingId = keccak256(abi.encodePacked(address(this), lockingsCounter));
1164         lockingsCounter = lockingsCounter.add(1);
1165 
1166         Locker storage locker = lockers[_locker][lockingId];
1167         locker.amount = _amount;
1168         // solhint-disable-next-line not-rely-on-time
1169         locker.releaseTime = now + _period;
1170         totalLocked = totalLocked.add(_amount);
1171         totalLockedLeft = totalLocked;
1172         uint256 score = _period.mul(_amount).mul(_numerator).div(_denominator);
1173         require(score > 0, "score must me > 0");
1174         scores[_locker] = scores[_locker].add(score);
1175         //verify that redeem will not overflow for this locker
1176         require((scores[_locker] * reputationReward)/scores[_locker] == reputationReward,
1177         "score is too high");
1178         totalScore = totalScore.add(score);
1179 
1180         emit Lock(_locker, lockingId, _amount, _period);
1181     }
1182 
1183     /**
1184      * @dev _initialize
1185      * @param _avatar the avatar to mint reputation from
1186      * @param _reputationReward the total reputation this contract will reward
1187      *        for eth/token locking
1188      * @param _lockingStartTime the locking start time.
1189      * @param _lockingEndTime the locking end time.
1190      *        locking is disable after this time.
1191      * @param _redeemEnableTime redeem enable time .
1192      *        redeem reputation can be done after this time.
1193      * @param _maxLockingPeriod maximum locking period allowed.
1194      */
1195     function _initialize(
1196         Avatar _avatar,
1197         uint256 _reputationReward,
1198         uint256 _lockingStartTime,
1199         uint256 _lockingEndTime,
1200         uint256 _redeemEnableTime,
1201         uint256 _maxLockingPeriod)
1202     internal
1203     {
1204         require(avatar == Avatar(0), "can be called only one time");
1205         require(_avatar != Avatar(0), "avatar cannot be zero");
1206         require(_lockingEndTime > _lockingStartTime, "locking end time should be greater than locking start time");
1207         require(_redeemEnableTime >= _lockingEndTime, "redeemEnableTime >= lockingEndTime");
1208 
1209         reputationReward = _reputationReward;
1210         reputationRewardLeft = _reputationReward;
1211         lockingEndTime = _lockingEndTime;
1212         maxLockingPeriod = _maxLockingPeriod;
1213         avatar = _avatar;
1214         lockingStartTime = _lockingStartTime;
1215         redeemEnableTime = _redeemEnableTime;
1216     }
1217 
1218 }
1219 
1220 // File: contracts/schemes/LockingEth4Reputation.sol
1221 
1222 pragma solidity ^0.5.2;
1223 
1224 
1225 
1226 
1227 /**
1228  * @title A scheme for locking ETH for reputation
1229  */
1230 
1231 contract LockingEth4Reputation is Locking4Reputation, Ownable {
1232 
1233     /**
1234      * @dev initialize
1235      * @param _avatar the avatar to mint reputation from
1236      * @param _reputationReward the total reputation this contract will reward
1237      *        for eth locking
1238      * @param _lockingStartTime locking starting period time.
1239      * @param _lockingEndTime the locking end time.
1240      *        locking is disable after this time.
1241      * @param _redeemEnableTime redeem enable time .
1242      *        redeem reputation can be done after this time.
1243      * @param _maxLockingPeriod maximum locking period allowed.
1244      */
1245     function initialize(
1246         Avatar _avatar,
1247         uint256 _reputationReward,
1248         uint256 _lockingStartTime,
1249         uint256 _lockingEndTime,
1250         uint256 _redeemEnableTime,
1251         uint256 _maxLockingPeriod)
1252     external
1253     onlyOwner
1254     {
1255         super._initialize(
1256         _avatar,
1257         _reputationReward,
1258         _lockingStartTime,
1259         _lockingEndTime,
1260         _redeemEnableTime,
1261         _maxLockingPeriod);
1262     }
1263 
1264     /**
1265      * @dev release locked eth
1266      * @param _beneficiary the release _beneficiary
1267      * @param _lockingId the locking id
1268      * @return bool
1269      */
1270     function release(address payable _beneficiary, bytes32 _lockingId) public returns(bool) {
1271         uint256 amount = super._release(_beneficiary, _lockingId);
1272         _beneficiary.transfer(amount);
1273 
1274         return true;
1275     }
1276 
1277     /**
1278      * @dev lock function
1279      * @param _period the locking period
1280      * @return lockingId the unique Id
1281      */
1282     function lock(uint256 _period) public payable returns(bytes32 lockingId) {
1283         return super._lock(msg.value, _period, msg.sender, 1, 1);
1284     }
1285 
1286 }