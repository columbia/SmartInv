1 
2 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
3 
4 pragma solidity ^0.5.0;
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
79 pragma solidity ^0.5.4;
80 
81 
82 
83 /**
84  * @title Reputation system
85  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
86  * A reputation is use to assign influence measure to a DAO'S peers.
87  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
88  * The Reputation contract maintain a map of address to reputation value.
89  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
90  */
91 
92 contract Reputation is Ownable {
93 
94     uint8 public decimals = 18;             //Number of decimals of the smallest unit
95     // Event indicating minting of reputation to an address.
96     event Mint(address indexed _to, uint256 _amount);
97     // Event indicating burning of reputation for an address.
98     event Burn(address indexed _from, uint256 _amount);
99 
100       /// @dev `Checkpoint` is the structure that attaches a block number to a
101       ///  given value, the block number attached is the one that last changed the
102       ///  value
103     struct Checkpoint {
104 
105     // `fromBlock` is the block number that the value was generated from
106         uint128 fromBlock;
107 
108           // `value` is the amount of reputation at a specific block number
109         uint128 value;
110     }
111 
112       // `balances` is the map that tracks the balance of each address, in this
113       //  contract when the balance changes the block number that the change
114       //  occurred is also included in the map
115     mapping (address => Checkpoint[]) balances;
116 
117       // Tracks the history of the `totalSupply` of the reputation
118     Checkpoint[] totalSupplyHistory;
119 
120     /// @notice Constructor to create a Reputation
121     constructor(
122     ) public
123     {
124     }
125 
126     /// @dev This function makes it easy to get the total number of reputation
127     /// @return The total number of reputation
128     function totalSupply() public view returns (uint256) {
129         return totalSupplyAt(block.number);
130     }
131 
132   ////////////////
133   // Query balance and totalSupply in History
134   ////////////////
135     /**
136     * @dev return the reputation amount of a given owner
137     * @param _owner an address of the owner which we want to get his reputation
138     */
139     function balanceOf(address _owner) public view returns (uint256 balance) {
140         return balanceOfAt(_owner, block.number);
141     }
142 
143       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
144       /// @param _owner The address from which the balance will be retrieved
145       /// @param _blockNumber The block number when the balance is queried
146       /// @return The balance at `_blockNumber`
147     function balanceOfAt(address _owner, uint256 _blockNumber)
148     public view returns (uint256)
149     {
150         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
151             return 0;
152           // This will return the expected balance during normal situations
153         } else {
154             return getValueAt(balances[_owner], _blockNumber);
155         }
156     }
157 
158       /// @notice Total amount of reputation at a specific `_blockNumber`.
159       /// @param _blockNumber The block number when the totalSupply is queried
160       /// @return The total amount of reputation at `_blockNumber`
161     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
162         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
163             return 0;
164           // This will return the expected totalSupply during normal situations
165         } else {
166             return getValueAt(totalSupplyHistory, _blockNumber);
167         }
168     }
169 
170       /// @notice Generates `_amount` reputation that are assigned to `_owner`
171       /// @param _user The address that will be assigned the new reputation
172       /// @param _amount The quantity of reputation generated
173       /// @return True if the reputation are generated correctly
174     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
175         uint256 curTotalSupply = totalSupply();
176         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
177         uint256 previousBalanceTo = balanceOf(_user);
178         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
179         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
180         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
181         emit Mint(_user, _amount);
182         return true;
183     }
184 
185       /// @notice Burns `_amount` reputation from `_owner`
186       /// @param _user The address that will lose the reputation
187       /// @param _amount The quantity of reputation to burn
188       /// @return True if the reputation are burned correctly
189     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
190         uint256 curTotalSupply = totalSupply();
191         uint256 amountBurned = _amount;
192         uint256 previousBalanceFrom = balanceOf(_user);
193         if (previousBalanceFrom < amountBurned) {
194             amountBurned = previousBalanceFrom;
195         }
196         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
197         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
198         emit Burn(_user, amountBurned);
199         return true;
200     }
201 
202   ////////////////
203   // Internal helper functions to query and set a value in a snapshot array
204   ////////////////
205 
206       /// @dev `getValueAt` retrieves the number of reputation at a given block number
207       /// @param checkpoints The history of values being queried
208       /// @param _block The block number to retrieve the value at
209       /// @return The number of reputation being queried
210     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
211         if (checkpoints.length == 0) {
212             return 0;
213         }
214 
215           // Shortcut for the actual value
216         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
217             return checkpoints[checkpoints.length-1].value;
218         }
219         if (_block < checkpoints[0].fromBlock) {
220             return 0;
221         }
222 
223           // Binary search of the value in the array
224         uint256 min = 0;
225         uint256 max = checkpoints.length-1;
226         while (max > min) {
227             uint256 mid = (max + min + 1) / 2;
228             if (checkpoints[mid].fromBlock<=_block) {
229                 min = mid;
230             } else {
231                 max = mid-1;
232             }
233         }
234         return checkpoints[min].value;
235     }
236 
237       /// @dev `updateValueAtNow` used to update the `balances` map and the
238       ///  `totalSupplyHistory`
239       /// @param checkpoints The history of data being updated
240       /// @param _value The new number of reputation
241     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
242         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
243         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
244             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
245             newCheckPoint.fromBlock = uint128(block.number);
246             newCheckPoint.value = uint128(_value);
247         } else {
248             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
249             oldCheckPoint.value = uint128(_value);
250         }
251     }
252 }
253 
254 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
255 
256 pragma solidity ^0.5.0;
257 
258 /**
259  * @title ERC20 interface
260  * @dev see https://github.com/ethereum/EIPs/issues/20
261  */
262 interface IERC20 {
263     function transfer(address to, uint256 value) external returns (bool);
264 
265     function approve(address spender, uint256 value) external returns (bool);
266 
267     function transferFrom(address from, address to, uint256 value) external returns (bool);
268 
269     function totalSupply() external view returns (uint256);
270 
271     function balanceOf(address who) external view returns (uint256);
272 
273     function allowance(address owner, address spender) external view returns (uint256);
274 
275     event Transfer(address indexed from, address indexed to, uint256 value);
276 
277     event Approval(address indexed owner, address indexed spender, uint256 value);
278 }
279 
280 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
281 
282 pragma solidity ^0.5.0;
283 
284 /**
285  * @title SafeMath
286  * @dev Unsigned math operations with safety checks that revert on error
287  */
288 library SafeMath {
289     /**
290     * @dev Multiplies two unsigned integers, reverts on overflow.
291     */
292     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
294         // benefit is lost if 'b' is also tested.
295         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
296         if (a == 0) {
297             return 0;
298         }
299 
300         uint256 c = a * b;
301         require(c / a == b);
302 
303         return c;
304     }
305 
306     /**
307     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
308     */
309     function div(uint256 a, uint256 b) internal pure returns (uint256) {
310         // Solidity only automatically asserts when dividing by 0
311         require(b > 0);
312         uint256 c = a / b;
313         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
314 
315         return c;
316     }
317 
318     /**
319     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
320     */
321     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
322         require(b <= a);
323         uint256 c = a - b;
324 
325         return c;
326     }
327 
328     /**
329     * @dev Adds two unsigned integers, reverts on overflow.
330     */
331     function add(uint256 a, uint256 b) internal pure returns (uint256) {
332         uint256 c = a + b;
333         require(c >= a);
334 
335         return c;
336     }
337 
338     /**
339     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
340     * reverts when dividing by zero.
341     */
342     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
343         require(b != 0);
344         return a % b;
345     }
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
1078 // File: @daostack/arc/contracts/schemes/Locking4Reputation.sol
1079 
1080 pragma solidity ^0.5.4;
1081 
1082 
1083 
1084 /**
1085  * @title A locker contract
1086  */
1087 
1088 contract Locking4Reputation {
1089     using SafeMath for uint256;
1090 
1091     event Redeem(address indexed _beneficiary, uint256 _amount);
1092     event Release(bytes32 indexed _lockingId, address indexed _beneficiary, uint256 _amount);
1093     event Lock(address indexed _locker, bytes32 indexed _lockingId, uint256 _amount, uint256 _period);
1094 
1095     struct Locker {
1096         uint256 amount;
1097         uint256 releaseTime;
1098     }
1099 
1100     Avatar public avatar;
1101 
1102     // A mapping from lockers addresses their lock balances.
1103     mapping(address => mapping(bytes32=>Locker)) public lockers;
1104     // A mapping from lockers addresses to their scores.
1105     mapping(address => uint) public scores;
1106 
1107     uint256 public totalLocked;
1108     uint256 public totalLockedLeft;
1109     uint256 public totalScore;
1110     uint256 public lockingsCounter; // Total number of lockings
1111     uint256 public reputationReward;
1112     uint256 public reputationRewardLeft;
1113     uint256 public lockingEndTime;
1114     uint256 public maxLockingPeriod;
1115     uint256 public lockingStartTime;
1116     uint256 public redeemEnableTime;
1117 
1118     /**
1119      * @dev redeem reputation function
1120      * @param _beneficiary the beneficiary for the release
1121      * @return uint256 reputation rewarded
1122      */
1123     function redeem(address _beneficiary) public returns(uint256 reputation) {
1124         // solhint-disable-next-line not-rely-on-time
1125         require(block.timestamp > redeemEnableTime, "now > redeemEnableTime");
1126         require(scores[_beneficiary] > 0, "score should be > 0");
1127         uint256 score = scores[_beneficiary];
1128         scores[_beneficiary] = 0;
1129         uint256 repRelation = score.mul(reputationReward);
1130         reputation = repRelation.div(totalScore);
1131 
1132         //check that the reputation is sum zero
1133         reputationRewardLeft = reputationRewardLeft.sub(reputation);
1134         require(
1135         ControllerInterface(
1136         avatar.owner())
1137         .mintReputation(reputation, _beneficiary, address(avatar)), "mint reputation should succeed");
1138 
1139         emit Redeem(_beneficiary, reputation);
1140     }
1141 
1142     /**
1143      * @dev release function
1144      * @param _beneficiary the beneficiary for the release
1145      * @param _lockingId the locking id to release
1146      * @return bool
1147      */
1148     function _release(address _beneficiary, bytes32 _lockingId) internal returns(uint256 amount) {
1149         Locker storage locker = lockers[_beneficiary][_lockingId];
1150         require(locker.amount > 0, "amount should be > 0");
1151         amount = locker.amount;
1152         locker.amount = 0;
1153         // solhint-disable-next-line not-rely-on-time
1154         require(block.timestamp > locker.releaseTime, "check the lock period pass");
1155         totalLockedLeft = totalLockedLeft.sub(amount);
1156 
1157         emit Release(_lockingId, _beneficiary, amount);
1158     }
1159 
1160     /**
1161      * @dev lock function
1162      * @param _amount the amount to lock
1163      * @param _period the locking period
1164      * @param _locker the locker
1165      * @param _numerator price numerator
1166      * @param _denominator price denominator
1167      * @return lockingId
1168      */
1169     function _lock(
1170         uint256 _amount,
1171         uint256 _period,
1172         address _locker,
1173         uint256 _numerator,
1174         uint256 _denominator)
1175         internal
1176         returns(bytes32 lockingId)
1177         {
1178         require(_amount > 0, "locking amount should be > 0");
1179         require(_period <= maxLockingPeriod, "locking period should be <= maxLockingPeriod");
1180         require(_period > 0, "locking period should be > 0");
1181         // solhint-disable-next-line not-rely-on-time
1182         require(now <= lockingEndTime, "lock should be within the allowed locking period");
1183         // solhint-disable-next-line not-rely-on-time
1184         require(now >= lockingStartTime, "lock should start after lockingStartTime");
1185 
1186         lockingId = keccak256(abi.encodePacked(address(this), lockingsCounter));
1187         lockingsCounter = lockingsCounter.add(1);
1188 
1189         Locker storage locker = lockers[_locker][lockingId];
1190         locker.amount = _amount;
1191         // solhint-disable-next-line not-rely-on-time
1192         locker.releaseTime = now + _period;
1193         totalLocked = totalLocked.add(_amount);
1194         totalLockedLeft = totalLockedLeft.add(_amount);
1195         uint256 score = _period.mul(_amount).mul(_numerator).div(_denominator);
1196         require(score > 0, "score must me > 0");
1197         scores[_locker] = scores[_locker].add(score);
1198         //verify that redeem will not overflow for this locker
1199         require((scores[_locker] * reputationReward)/scores[_locker] == reputationReward,
1200         "score is too high");
1201         totalScore = totalScore.add(score);
1202 
1203         emit Lock(_locker, lockingId, _amount, _period);
1204     }
1205 
1206     /**
1207      * @dev _initialize
1208      * @param _avatar the avatar to mint reputation from
1209      * @param _reputationReward the total reputation this contract will reward
1210      *        for eth/token locking
1211      * @param _lockingStartTime the locking start time.
1212      * @param _lockingEndTime the locking end time.
1213      *        locking is disable after this time.
1214      * @param _redeemEnableTime redeem enable time .
1215      *        redeem reputation can be done after this time.
1216      * @param _maxLockingPeriod maximum locking period allowed.
1217      */
1218     function _initialize(
1219         Avatar _avatar,
1220         uint256 _reputationReward,
1221         uint256 _lockingStartTime,
1222         uint256 _lockingEndTime,
1223         uint256 _redeemEnableTime,
1224         uint256 _maxLockingPeriod)
1225     internal
1226     {
1227         require(avatar == Avatar(0), "can be called only one time");
1228         require(_avatar != Avatar(0), "avatar cannot be zero");
1229         require(_lockingEndTime > _lockingStartTime, "locking end time should be greater than locking start time");
1230         require(_redeemEnableTime >= _lockingEndTime, "redeemEnableTime >= lockingEndTime");
1231 
1232         reputationReward = _reputationReward;
1233         reputationRewardLeft = _reputationReward;
1234         lockingEndTime = _lockingEndTime;
1235         maxLockingPeriod = _maxLockingPeriod;
1236         avatar = _avatar;
1237         lockingStartTime = _lockingStartTime;
1238         redeemEnableTime = _redeemEnableTime;
1239     }
1240 
1241 }
1242 
1243 // File: @daostack/arc/contracts/schemes/ExternalLocking4Reputation.sol
1244 
1245 pragma solidity ^0.5.4;
1246 
1247 
1248 /**
1249  * @title A scheme for external locking Tokens for reputation
1250  */
1251 
1252 contract ExternalLocking4Reputation is Locking4Reputation, Ownable {
1253 
1254     event Register(address indexed _beneficiary);
1255 
1256     address public externalLockingContract;
1257     string public getBalanceFuncSignature;
1258 
1259     // locker -> bool
1260     mapping(address => bool) public externalLockers;
1261     //      beneficiary -> bool
1262     mapping(address     => bool) public registrar;
1263 
1264     /**
1265      * @dev initialize
1266      * @param _avatar the avatar to mint reputation from
1267      * @param _reputationReward the total reputation this contract will reward
1268      *        for the token locking
1269      * @param _claimingStartTime claiming starting period time.
1270      * @param _claimingEndTime the claiming end time.
1271      *        claiming is disable after this time.
1272      * @param _redeemEnableTime redeem enable time .
1273      *        redeem reputation can be done after this time.
1274      * @param _externalLockingContract the contract which lock the token.
1275      * @param _getBalanceFuncSignature get balance function signature
1276      *        e.g "lockedTokenBalances(address)"
1277      */
1278     function initialize(
1279         Avatar _avatar,
1280         uint256 _reputationReward,
1281         uint256 _claimingStartTime,
1282         uint256 _claimingEndTime,
1283         uint256 _redeemEnableTime,
1284         address _externalLockingContract,
1285         string calldata _getBalanceFuncSignature)
1286     external
1287     {
1288         require(_claimingEndTime > _claimingStartTime, "_claimingEndTime should be greater than _claimingStartTime");
1289         externalLockingContract = _externalLockingContract;
1290         getBalanceFuncSignature = _getBalanceFuncSignature;
1291         super._initialize(
1292         _avatar,
1293         _reputationReward,
1294         _claimingStartTime,
1295         _claimingEndTime,
1296         _redeemEnableTime,
1297         1);
1298     }
1299 
1300     /**
1301      * @dev claim function
1302      * @param _beneficiary the beneficiary address to claim for
1303      *        if _beneficiary == 0 the claim will be for the msg.sender.
1304      * @return claimId
1305      */
1306     function claim(address _beneficiary) public returns(bytes32) {
1307         require(avatar != Avatar(0), "should initialize first");
1308         address beneficiary;
1309         if (_beneficiary == address(0)) {
1310             beneficiary = msg.sender;
1311         } else {
1312             require(registrar[_beneficiary], "beneficiary should be register");
1313             beneficiary = _beneficiary;
1314         }
1315         require(externalLockers[beneficiary] == false, "claiming twice for the same beneficiary is not allowed");
1316         externalLockers[beneficiary] = true;
1317         (bool result, bytes memory returnValue) =
1318         // solhint-disable-next-line avoid-call-value,avoid-low-level-calls
1319         externalLockingContract.call(abi.encodeWithSignature(getBalanceFuncSignature, beneficiary));
1320         require(result, "call to external contract should succeed");
1321         uint256 lockedAmount;
1322         // solhint-disable-next-line no-inline-assembly
1323         assembly {
1324             lockedAmount := mload(add(returnValue, 0x20))
1325         }
1326         return super._lock(lockedAmount, 1, beneficiary, 1, 1);
1327     }
1328 
1329    /**
1330     * @dev register function
1331     *      register for external locking claim
1332     */
1333     function register() public {
1334         registrar[msg.sender] = true;
1335         emit Register(msg.sender);
1336     }
1337 }
1338 
1339 // File: contracts/schemes/bootstrap/DxLockMgnForRep.sol
1340 
1341 pragma solidity ^0.5.4;
1342 
1343 
1344 /**
1345  * @title Scheme that allows to get GEN by locking MGN
1346  */
1347 contract DxLockMgnForRep is ExternalLocking4Reputation {
1348     constructor() public {}
1349 }
