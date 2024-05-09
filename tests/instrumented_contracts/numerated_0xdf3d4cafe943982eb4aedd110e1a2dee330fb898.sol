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
565 // File: contracts/controller/DAOToken.sol
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
641 // File: contracts/libs/SafeERC20.sol
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
715 // File: contracts/controller/Avatar.sol
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
854 // File: contracts/universalSchemes/UniversalSchemeInterface.sol
855 
856 pragma solidity ^0.5.4;
857 
858 
859 contract UniversalSchemeInterface {
860 
861     function getParametersFromController(Avatar _avatar) internal view returns(bytes32);
862     
863 }
864 
865 // File: contracts/globalConstraints/GlobalConstraintInterface.sol
866 
867 pragma solidity ^0.5.4;
868 
869 
870 contract GlobalConstraintInterface {
871 
872     enum CallPhase { Pre, Post, PreAndPost }
873 
874     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
875     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
876     /**
877      * @dev when return if this globalConstraints is pre, post or both.
878      * @return CallPhase enum indication  Pre, Post or PreAndPost.
879      */
880     function when() public returns(CallPhase);
881 }
882 
883 // File: contracts/controller/ControllerInterface.sol
884 
885 pragma solidity ^0.5.4;
886 
887 
888 
889 /**
890  * @title Controller contract
891  * @dev A controller controls the organizations tokens ,reputation and avatar.
892  * It is subject to a set of schemes and constraints that determine its behavior.
893  * Each scheme has it own parameters and operation permissions.
894  */
895 interface ControllerInterface {
896 
897     /**
898      * @dev Mint `_amount` of reputation that are assigned to `_to` .
899      * @param  _amount amount of reputation to mint
900      * @param _to beneficiary address
901      * @return bool which represents a success
902     */
903     function mintReputation(uint256 _amount, address _to, address _avatar)
904     external
905     returns(bool);
906 
907     /**
908      * @dev Burns `_amount` of reputation from `_from`
909      * @param _amount amount of reputation to burn
910      * @param _from The address that will lose the reputation
911      * @return bool which represents a success
912      */
913     function burnReputation(uint256 _amount, address _from, address _avatar)
914     external
915     returns(bool);
916 
917     /**
918      * @dev mint tokens .
919      * @param  _amount amount of token to mint
920      * @param _beneficiary beneficiary address
921      * @param _avatar address
922      * @return bool which represents a success
923      */
924     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
925     external
926     returns(bool);
927 
928   /**
929    * @dev register or update a scheme
930    * @param _scheme the address of the scheme
931    * @param _paramsHash a hashed configuration of the usage of the scheme
932    * @param _permissions the permissions the new scheme will have
933    * @param _avatar address
934    * @return bool which represents a success
935    */
936     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
937     external
938     returns(bool);
939 
940     /**
941      * @dev unregister a scheme
942      * @param _avatar address
943      * @param _scheme the address of the scheme
944      * @return bool which represents a success
945      */
946     function unregisterScheme(address _scheme, address _avatar)
947     external
948     returns(bool);
949 
950     /**
951      * @dev unregister the caller's scheme
952      * @param _avatar address
953      * @return bool which represents a success
954      */
955     function unregisterSelf(address _avatar) external returns(bool);
956 
957     /**
958      * @dev add or update Global Constraint
959      * @param _globalConstraint the address of the global constraint to be added.
960      * @param _params the constraint parameters hash.
961      * @param _avatar the avatar of the organization
962      * @return bool which represents a success
963      */
964     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
965     external returns(bool);
966 
967     /**
968      * @dev remove Global Constraint
969      * @param _globalConstraint the address of the global constraint to be remove.
970      * @param _avatar the organization avatar.
971      * @return bool which represents a success
972      */
973     function removeGlobalConstraint (address _globalConstraint, address _avatar)
974     external  returns(bool);
975 
976   /**
977     * @dev upgrade the Controller
978     *      The function will trigger an event 'UpgradeController'.
979     * @param  _newController the address of the new controller.
980     * @param _avatar address
981     * @return bool which represents a success
982     */
983     function upgradeController(address _newController, Avatar _avatar)
984     external returns(bool);
985 
986     /**
987     * @dev perform a generic call to an arbitrary contract
988     * @param _contract  the contract's address to call
989     * @param _data ABI-encoded contract call to call `_contract` address.
990     * @param _avatar the controller's avatar address
991     * @param _value value (ETH) to transfer with the transaction
992     * @return bool -success
993     *         bytes  - the return value of the called _contract's function.
994     */
995     function genericCall(address _contract, bytes calldata _data, Avatar _avatar, uint256 _value)
996     external
997     returns(bool, bytes memory);
998 
999   /**
1000    * @dev send some ether
1001    * @param _amountInWei the amount of ether (in Wei) to send
1002    * @param _to address of the beneficiary
1003    * @param _avatar address
1004    * @return bool which represents a success
1005    */
1006     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
1007     external returns(bool);
1008 
1009     /**
1010     * @dev send some amount of arbitrary ERC20 Tokens
1011     * @param _externalToken the address of the Token Contract
1012     * @param _to address of the beneficiary
1013     * @param _value the amount of ether (in Wei) to send
1014     * @param _avatar address
1015     * @return bool which represents a success
1016     */
1017     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1018     external
1019     returns(bool);
1020 
1021     /**
1022     * @dev transfer token "from" address "to" address
1023     *      One must to approve the amount of tokens which can be spend from the
1024     *      "from" account.This can be done using externalTokenApprove.
1025     * @param _externalToken the address of the Token Contract
1026     * @param _from address of the account to send from
1027     * @param _to address of the beneficiary
1028     * @param _value the amount of ether (in Wei) to send
1029     * @param _avatar address
1030     * @return bool which represents a success
1031     */
1032     function externalTokenTransferFrom(
1033     IERC20 _externalToken,
1034     address _from,
1035     address _to,
1036     uint256 _value,
1037     Avatar _avatar)
1038     external
1039     returns(bool);
1040 
1041     /**
1042     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1043     *      on behalf of msg.sender.
1044     * @param _externalToken the address of the Token Contract
1045     * @param _spender address
1046     * @param _value the amount of ether (in Wei) which the approval is referring to.
1047     * @return bool which represents a success
1048     */
1049     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1050     external
1051     returns(bool);
1052 
1053     /**
1054     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1055     * @param _metaData a string representing a hash of the meta data
1056     * @param _avatar Avatar
1057     * @return bool which represents a success
1058     */
1059     function metaData(string calldata _metaData, Avatar _avatar) external returns(bool);
1060 
1061     /**
1062      * @dev getNativeReputation
1063      * @param _avatar the organization avatar.
1064      * @return organization native reputation
1065      */
1066     function getNativeReputation(address _avatar)
1067     external
1068     view
1069     returns(address);
1070 
1071     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
1072 
1073     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1074 
1075     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1076 
1077     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1078 
1079     /**
1080      * @dev globalConstraintsCount return the global constraint pre and post count
1081      * @return uint256 globalConstraintsPre count.
1082      * @return uint256 globalConstraintsPost count.
1083      */
1084     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1085 
1086     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1087 }
1088 
1089 // File: contracts/universalSchemes/UniversalScheme.sol
1090 
1091 pragma solidity ^0.5.4;
1092 
1093 
1094 
1095 
1096 
1097 contract UniversalScheme is UniversalSchemeInterface {
1098     /**
1099     *  @dev get the parameters for the current scheme from the controller
1100     */
1101     function getParametersFromController(Avatar _avatar) internal view returns(bytes32) {
1102         require(ControllerInterface(_avatar.owner()).isSchemeRegistered(address(this), address(_avatar)),
1103         "scheme is not registered");
1104         return ControllerInterface(_avatar.owner()).getSchemeParameters(address(this), address(_avatar));
1105     }
1106 }
1107 
1108 // File: contracts/controller/UController.sol
1109 
1110 pragma solidity ^0.5.4;
1111 
1112 
1113 
1114 
1115 
1116 /**
1117  * @title Universal Controller contract
1118  * @dev A universal controller hold organizations and controls their tokens ,reputations
1119  *       and avatar.
1120  * It is subject to a set of schemes and constraints that determine its behavior.
1121  * Each scheme has it own parameters and operation permissions.
1122  */
1123 contract UController is ControllerInterface {
1124 
1125     struct Scheme {
1126         bytes32 paramsHash;  // a hash "configuration" of the scheme
1127         bytes4  permissions; // A bitwise flags of permissions,
1128                             // All 0: Not registered,
1129                             // 1st bit: Flag if the scheme is registered,
1130                             // 2nd bit: Scheme can register other schemes
1131                             // 3th bit: Scheme can add/remove global constraints
1132                             // 4rd bit: Scheme can upgrade the controller
1133                             // 5th bit: Scheme can call delegatecall
1134     }
1135 
1136     struct GlobalConstraint {
1137         address gcAddress;
1138         bytes32 params;
1139     }
1140 
1141     struct GlobalConstraintRegister {
1142         bool isRegistered; //is registered
1143         uint256 index;    //index at globalConstraints
1144     }
1145 
1146     struct Organization {
1147         DAOToken                  nativeToken;
1148         Reputation                nativeReputation;
1149         mapping(address=>Scheme)  schemes;
1150       // globalConstraintsPre that determine pre- conditions for all actions on the controller
1151         GlobalConstraint[] globalConstraintsPre;
1152         // globalConstraintsPost that determine post-conditions for all actions on the controller
1153         GlobalConstraint[] globalConstraintsPost;
1154       // globalConstraintsRegisterPre indicate if a globalConstraints is registered as a Pre global constraint.
1155         mapping(address=>GlobalConstraintRegister) globalConstraintsRegisterPre;
1156       // globalConstraintsRegisterPost indicate if a globalConstraints is registered as a Post global constraint.
1157         mapping(address=>GlobalConstraintRegister) globalConstraintsRegisterPost;
1158     }
1159 
1160     //mapping between organization's avatar address to Organization
1161     mapping(address=>Organization) public organizations;
1162     // newController will point to the new controller after the present controller is upgraded
1163     //  address external newController;
1164     mapping(address=>address) public newControllers;//mapping between avatar address and newController address
1165     //mapping for all reputation system and tokens addresses registered.
1166     mapping(address=>bool) public actors;
1167 
1168     event MintReputation (address indexed _sender, address indexed _to, uint256 _amount, address indexed _avatar);
1169     event BurnReputation (address indexed _sender, address indexed _from, uint256 _amount, address indexed _avatar);
1170     event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount, address indexed _avatar);
1171     event RegisterScheme (address indexed _sender, address indexed _scheme, address indexed _avatar);
1172     event UnregisterScheme (address indexed _sender, address indexed _scheme, address indexed _avatar);
1173     event UpgradeController(address indexed _oldController, address _newController, address _avatar);
1174 
1175     event AddGlobalConstraint(
1176         address indexed _globalConstraint,
1177         bytes32 _params,
1178         GlobalConstraintInterface.CallPhase _when,
1179         address indexed _avatar
1180     );
1181 
1182     event RemoveGlobalConstraint(
1183         address indexed _globalConstraint,
1184         uint256 _index,
1185         bool _isPre,
1186         address indexed _avatar
1187     );
1188 
1189    /**
1190     * @dev newOrganization set up a new organization with default daoCreator.
1191     * @param _avatar the organization avatar
1192     */
1193     function newOrganization(
1194         Avatar _avatar
1195     ) external
1196     {
1197         require(!actors[address(_avatar)]);
1198         actors[address(_avatar)] = true;
1199         require(_avatar.owner() == address(this));
1200         DAOToken nativeToken = _avatar.nativeToken();
1201         Reputation nativeReputation = _avatar.nativeReputation();
1202         require(nativeToken.owner() == address(this));
1203         require(nativeReputation.owner() == address(this));
1204         //To guaranty uniqueness for the reputation systems.
1205         require(!actors[address(nativeReputation)]);
1206         actors[address(nativeReputation)] = true;
1207         //To guaranty uniqueness for the nativeToken.
1208         require(!actors[address(nativeToken)]);
1209         actors[address(nativeToken)] = true;
1210         organizations[address(_avatar)].nativeToken = nativeToken;
1211         organizations[address(_avatar)].nativeReputation = nativeReputation;
1212         organizations[address(_avatar)].schemes[msg.sender] =
1213         Scheme({paramsHash: bytes32(0), permissions: bytes4(0x0000001f)});
1214         emit RegisterScheme(msg.sender, msg.sender, address(_avatar));
1215     }
1216 
1217   // Modifiers:
1218     modifier onlyRegisteredScheme(address avatar) {
1219         require(organizations[avatar].schemes[msg.sender].permissions&bytes4(0x00000001) == bytes4(0x00000001));
1220         _;
1221     }
1222 
1223     modifier onlyRegisteringSchemes(address avatar) {
1224         require(organizations[avatar].schemes[msg.sender].permissions&bytes4(0x00000002) == bytes4(0x00000002));
1225         _;
1226     }
1227 
1228     modifier onlyGlobalConstraintsScheme(address avatar) {
1229         require(organizations[avatar].schemes[msg.sender].permissions&bytes4(0x00000004) == bytes4(0x00000004));
1230         _;
1231     }
1232 
1233     modifier onlyUpgradingScheme(address _avatar) {
1234         require(organizations[_avatar].schemes[msg.sender].permissions&bytes4(0x00000008) == bytes4(0x00000008));
1235         _;
1236     }
1237 
1238     modifier onlyGenericCallScheme(address _avatar) {
1239         require(organizations[_avatar].schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1240         _;
1241     }
1242 
1243     modifier onlyMetaDataScheme(address _avatar) {
1244         require(organizations[_avatar].schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1245         _;
1246     }
1247 
1248     modifier onlySubjectToConstraint(bytes32 func, address _avatar) {
1249         uint256 idx;
1250         GlobalConstraint[] memory globalConstraintsPre = organizations[_avatar].globalConstraintsPre;
1251         GlobalConstraint[] memory globalConstraintsPost = organizations[_avatar].globalConstraintsPost;
1252         for (idx = 0; idx < globalConstraintsPre.length; idx++) {
1253             require(
1254             (GlobalConstraintInterface(globalConstraintsPre[idx].gcAddress))
1255             .pre(msg.sender, globalConstraintsPre[idx].params, func));
1256         }
1257         _;
1258         for (idx = 0; idx < globalConstraintsPost.length; idx++) {
1259             require(
1260             (GlobalConstraintInterface(globalConstraintsPost[idx].gcAddress))
1261             .post(msg.sender, globalConstraintsPost[idx].params, func));
1262         }
1263     }
1264 
1265     /**
1266      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1267      * @param  _amount amount of reputation to mint
1268      * @param _to beneficiary address
1269      * @param _avatar the address of the organization's avatar
1270      * @return bool which represents a success
1271      */
1272     function mintReputation(uint256 _amount, address _to, address _avatar)
1273     external
1274     onlyRegisteredScheme(_avatar)
1275     onlySubjectToConstraint("mintReputation", _avatar)
1276     returns(bool)
1277     {
1278         emit MintReputation(msg.sender, _to, _amount, _avatar);
1279         return organizations[_avatar].nativeReputation.mint(_to, _amount);
1280     }
1281 
1282     /**
1283      * @dev Burns `_amount` of reputation from `_from`
1284      * @param _amount amount of reputation to burn
1285      * @param _from The address that will lose the reputation
1286      * @return bool which represents a success
1287      */
1288     function burnReputation(uint256 _amount, address _from, address _avatar)
1289     external
1290     onlyRegisteredScheme(_avatar)
1291     onlySubjectToConstraint("burnReputation", _avatar)
1292     returns(bool)
1293     {
1294         emit BurnReputation(msg.sender, _from, _amount, _avatar);
1295         return organizations[_avatar].nativeReputation.burn(_from, _amount);
1296     }
1297 
1298     /**
1299      * @dev mint tokens .
1300      * @param  _amount amount of token to mint
1301      * @param _beneficiary beneficiary address
1302      * @param _avatar the organization avatar.
1303      * @return bool which represents a success
1304      */
1305     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
1306     external
1307     onlyRegisteredScheme(_avatar)
1308     onlySubjectToConstraint("mintTokens", _avatar)
1309     returns(bool)
1310     {
1311         emit MintTokens(msg.sender, _beneficiary, _amount, _avatar);
1312         return organizations[_avatar].nativeToken.mint(_beneficiary, _amount);
1313     }
1314 
1315   /**
1316    * @dev register or update a scheme
1317    * @param _scheme the address of the scheme
1318    * @param _paramsHash a hashed configuration of the usage of the scheme
1319    * @param _permissions the permissions the new scheme will have
1320    * @param _avatar the organization avatar.
1321    * @return bool which represents a success
1322    */
1323     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
1324     external
1325     onlyRegisteringSchemes(_avatar)
1326     onlySubjectToConstraint("registerScheme", _avatar)
1327     returns(bool)
1328     {
1329         bytes4 schemePermission = organizations[_avatar].schemes[_scheme].permissions;
1330         bytes4 senderPermission = organizations[_avatar].schemes[msg.sender].permissions;
1331     // Check scheme has at least the permissions it is changing, and at least the current permissions:
1332     // Implementation is a bit messy. One must recall logic-circuits ^^
1333 
1334     // produces non-zero if sender does not have all of the perms that are changing between old and new
1335         require(bytes4(0x0000001f)&(_permissions^schemePermission)&(~senderPermission) == bytes4(0));
1336 
1337     // produces non-zero if sender does not have all of the perms in the old scheme
1338         require(bytes4(0x0000001f)&(schemePermission&(~senderPermission)) == bytes4(0));
1339 
1340     // Add or change the scheme:
1341         organizations[_avatar].schemes[_scheme] =
1342         Scheme({paramsHash:_paramsHash, permissions:_permissions|bytes4(0x00000001)});
1343         emit RegisterScheme(msg.sender, _scheme, _avatar);
1344         return true;
1345     }
1346 
1347     /**
1348      * @dev unregister a scheme
1349      * @param _scheme the address of the scheme
1350      * @param _avatar the organization avatar.
1351      * @return bool which represents a success
1352      */
1353     function unregisterScheme(address _scheme, address _avatar)
1354     external
1355     onlyRegisteringSchemes(_avatar)
1356     onlySubjectToConstraint("unregisterScheme", _avatar)
1357     returns(bool)
1358     {
1359         bytes4 schemePermission = organizations[_avatar].schemes[_scheme].permissions;
1360     //check if the scheme is registered
1361         if (schemePermission&bytes4(0x00000001) == bytes4(0)) {
1362             return false;
1363         }
1364     // Check the unregistering scheme has enough permissions:
1365         require(
1366         bytes4(0x0000001f)&(schemePermission&(~organizations[_avatar].schemes[msg.sender].permissions)) == bytes4(0));
1367 
1368     // Unregister:
1369         emit UnregisterScheme(msg.sender, _scheme, _avatar);
1370         delete organizations[_avatar].schemes[_scheme];
1371         return true;
1372     }
1373 
1374     /**
1375      * @dev unregister the caller's scheme
1376      * @param _avatar the organization avatar.
1377      * @return bool which represents a success
1378      */
1379     function unregisterSelf(address _avatar) external returns(bool) {
1380         if (_isSchemeRegistered(msg.sender, _avatar) == false) {
1381             return false;
1382         }
1383         delete organizations[_avatar].schemes[msg.sender];
1384         emit UnregisterScheme(msg.sender, msg.sender, _avatar);
1385         return true;
1386     }
1387 
1388     /**
1389      * @dev add or update Global Constraint
1390      * @param _globalConstraint the address of the global constraint to be added.
1391      * @param _params the constraint parameters hash.
1392      * @param _avatar the avatar of the organization
1393      * @return bool which represents a success
1394      */
1395     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
1396     external onlyGlobalConstraintsScheme(_avatar) returns(bool)
1397     {
1398         Organization storage organization = organizations[_avatar];
1399         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1400         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1401             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1402             if (!organization.globalConstraintsRegisterPre[_globalConstraint].isRegistered) {
1403                 organization.globalConstraintsPre.push(GlobalConstraint(_globalConstraint, _params));
1404                 organization.globalConstraintsRegisterPre[_globalConstraint] =
1405                 GlobalConstraintRegister(true, organization.globalConstraintsPre.length-1);
1406             }else {
1407                 organization
1408                 .globalConstraintsPre[organization.globalConstraintsRegisterPre[_globalConstraint].index]
1409                 .params = _params;
1410             }
1411         }
1412 
1413         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1414             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1415             if (!organization.globalConstraintsRegisterPost[_globalConstraint].isRegistered) {
1416                 organization.globalConstraintsPost.push(GlobalConstraint(_globalConstraint, _params));
1417                 organization.globalConstraintsRegisterPost[_globalConstraint] =
1418                 GlobalConstraintRegister(true, organization.globalConstraintsPost.length-1);
1419             } else {
1420                 organization
1421                 .globalConstraintsPost[organization.globalConstraintsRegisterPost[_globalConstraint].index]
1422                 .params = _params;
1423             }
1424         }
1425         emit AddGlobalConstraint(_globalConstraint, _params, when, _avatar);
1426         return true;
1427     }
1428 
1429     /**
1430      * @dev remove Global Constraint
1431      * @param _globalConstraint the address of the global constraint to be remove.
1432      * @param _avatar the organization avatar.
1433      * @return bool which represents a success
1434      */
1435     function removeGlobalConstraint (address _globalConstraint, address _avatar)
1436     external onlyGlobalConstraintsScheme(_avatar) returns(bool)
1437     {
1438         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1439         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1440             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1441             removeGlobalConstraintPre(_globalConstraint, _avatar);
1442         }
1443         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1444             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1445             removeGlobalConstraintPost(_globalConstraint, _avatar);
1446         }
1447         return true;
1448     }
1449 
1450   /**
1451     * @dev upgrade the Controller
1452     *      The function will trigger an event 'UpgradeController'.
1453     * @param  _newController the address of the new controller.
1454     * @param _avatar the organization avatar.
1455     * @return bool which represents a success
1456     */
1457     function upgradeController(address _newController, Avatar _avatar)
1458     external onlyUpgradingScheme(address(_avatar)) returns(bool)
1459     {
1460         require(newControllers[address(_avatar)] == address(0));   // so the upgrade could be done once for a contract.
1461         require(_newController != address(0));
1462         newControllers[address(_avatar)] = _newController;
1463         _avatar.transferOwnership(_newController);
1464         require(_avatar.owner() == _newController);
1465         if (organizations[address(_avatar)].nativeToken.owner() == address(this)) {
1466             organizations[address(_avatar)].nativeToken.transferOwnership(_newController);
1467             require(organizations[address(_avatar)].nativeToken.owner() == _newController);
1468         }
1469         if (organizations[address(_avatar)].nativeReputation.owner() == address(this)) {
1470             organizations[address(_avatar)].nativeReputation.transferOwnership(_newController);
1471             require(organizations[address(_avatar)].nativeReputation.owner() == _newController);
1472         }
1473         emit UpgradeController(address(this), _newController, address(_avatar));
1474         return true;
1475     }
1476 
1477     /**
1478     * @dev perform a generic call to an arbitrary contract
1479     * @param _contract  the contract's address to call
1480     * @param _data ABI-encoded contract call to call `_contract` address.
1481     * @param _avatar the controller's avatar address
1482     * @param _value value (ETH) to transfer with the transaction
1483     * @return bool -success
1484     *         bytes  - the return value of the called _contract's function.
1485     */
1486     function genericCall(address _contract, bytes calldata _data, Avatar _avatar, uint256 _value)
1487     external
1488     onlyGenericCallScheme(address(_avatar))
1489     onlySubjectToConstraint("genericCall", address(_avatar))
1490     returns (bool, bytes memory)
1491     {
1492         return _avatar.genericCall(_contract, _data, _value);
1493     }
1494 
1495   /**
1496    * @dev send some ether
1497    * @param _amountInWei the amount of ether (in Wei) to send
1498    * @param _to address of the beneficiary
1499    * @param _avatar the organization avatar.
1500    * @return bool which represents a success
1501    */
1502     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
1503     external
1504     onlyRegisteredScheme(address(_avatar))
1505     onlySubjectToConstraint("sendEther", address(_avatar))
1506     returns(bool)
1507     {
1508         return _avatar.sendEther(_amountInWei, _to);
1509     }
1510 
1511     /**
1512     * @dev send some amount of arbitrary ERC20 Tokens
1513     * @param _externalToken the address of the Token Contract
1514     * @param _to address of the beneficiary
1515     * @param _value the amount of ether (in Wei) to send
1516     * @param _avatar the organization avatar.
1517     * @return bool which represents a success
1518     */
1519     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1520     external
1521     onlyRegisteredScheme(address(_avatar))
1522     onlySubjectToConstraint("externalTokenTransfer", address(_avatar))
1523     returns(bool)
1524     {
1525         return _avatar.externalTokenTransfer(_externalToken, _to, _value);
1526     }
1527 
1528     /**
1529     * @dev transfer token "from" address "to" address
1530     *      One must to approve the amount of tokens which can be spend from the
1531     *      "from" account.This can be done using externalTokenApprove.
1532     * @param _externalToken the address of the Token Contract
1533     * @param _from address of the account to send from
1534     * @param _to address of the beneficiary
1535     * @param _value the amount of ether (in Wei) to send
1536     * @param _avatar the organization avatar.
1537     * @return bool which represents a success
1538     */
1539     function externalTokenTransferFrom(
1540     IERC20 _externalToken,
1541     address _from,
1542     address _to,
1543     uint256 _value,
1544     Avatar _avatar)
1545     external
1546     onlyRegisteredScheme(address(_avatar))
1547     onlySubjectToConstraint("externalTokenTransferFrom", address(_avatar))
1548     returns(bool)
1549     {
1550         return _avatar.externalTokenTransferFrom(_externalToken, _from, _to, _value);
1551     }
1552 
1553     /**
1554     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1555     *      on behalf of msg.sender.
1556     * @param _externalToken the address of the Token Contract
1557     * @param _spender address
1558     * @param _value the amount of ether (in Wei) which the approval is referring to.
1559     * @return bool which represents a success
1560     */
1561     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1562     external
1563     onlyRegisteredScheme(address(_avatar))
1564     onlySubjectToConstraint("externalTokenApproval", address(_avatar))
1565     returns(bool)
1566     {
1567         return _avatar.externalTokenApproval(_externalToken, _spender, _value);
1568     }
1569 
1570     /**
1571     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1572     * @param _metaData a string representing a hash of the meta data
1573     * @param _avatar Avatar
1574     * @return bool which represents a success
1575     */
1576     function metaData(string calldata _metaData, Avatar _avatar)
1577         external
1578         onlyMetaDataScheme(address(_avatar))
1579         returns(bool)
1580         {
1581         return _avatar.metaData(_metaData);
1582     }
1583 
1584     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool) {
1585         return _isSchemeRegistered(_scheme, _avatar);
1586     }
1587 
1588     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32) {
1589         return organizations[_avatar].schemes[_scheme].paramsHash;
1590     }
1591 
1592     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4) {
1593         return organizations[_avatar].schemes[_scheme].permissions;
1594     }
1595 
1596     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32) {
1597 
1598         Organization storage organization = organizations[_avatar];
1599 
1600         GlobalConstraintRegister memory register = organization.globalConstraintsRegisterPre[_globalConstraint];
1601 
1602         if (register.isRegistered) {
1603             return organization.globalConstraintsPre[register.index].params;
1604         }
1605 
1606         register = organization.globalConstraintsRegisterPost[_globalConstraint];
1607 
1608         if (register.isRegistered) {
1609             return organization.globalConstraintsPost[register.index].params;
1610         }
1611     }
1612 
1613    /**
1614    * @dev globalConstraintsCount return the global constraint pre and post count
1615    * @return uint256 globalConstraintsPre count.
1616    * @return uint256 globalConstraintsPost count.
1617    */
1618     function globalConstraintsCount(address _avatar) external view returns(uint, uint) {
1619         return (
1620         organizations[_avatar].globalConstraintsPre.length,
1621         organizations[_avatar].globalConstraintsPost.length
1622         );
1623     }
1624 
1625     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool) {
1626         return (organizations[_avatar].globalConstraintsRegisterPre[_globalConstraint].isRegistered ||
1627         organizations[_avatar].globalConstraintsRegisterPost[_globalConstraint].isRegistered);
1628     }
1629 
1630     /**
1631      * @dev getNativeReputation
1632      * @param _avatar the organization avatar.
1633      * @return organization native reputation
1634      */
1635     function getNativeReputation(address _avatar) external view returns(address) {
1636         return address(organizations[_avatar].nativeReputation);
1637     }
1638 
1639     /**
1640      * @dev removeGlobalConstraintPre
1641      * @param _globalConstraint the address of the global constraint to be remove.
1642      * @param _avatar the organization avatar.
1643      * @return bool which represents a success
1644      */
1645     function removeGlobalConstraintPre(address _globalConstraint, address _avatar)
1646     private returns(bool)
1647     {
1648         GlobalConstraintRegister memory globalConstraintRegister =
1649         organizations[_avatar].globalConstraintsRegisterPre[_globalConstraint];
1650         GlobalConstraint[] storage globalConstraints = organizations[_avatar].globalConstraintsPre;
1651 
1652         if (globalConstraintRegister.isRegistered) {
1653             if (globalConstraintRegister.index < globalConstraints.length-1) {
1654                 GlobalConstraint memory globalConstraint = globalConstraints[globalConstraints.length-1];
1655                 globalConstraints[globalConstraintRegister.index] = globalConstraint;
1656                 organizations[_avatar].globalConstraintsRegisterPre[globalConstraint.gcAddress].index =
1657                 globalConstraintRegister.index;
1658             }
1659             globalConstraints.length--;
1660             delete organizations[_avatar].globalConstraintsRegisterPre[_globalConstraint];
1661             emit RemoveGlobalConstraint(_globalConstraint, globalConstraintRegister.index, true, _avatar);
1662             return true;
1663         }
1664         return false;
1665     }
1666 
1667     /**
1668      * @dev removeGlobalConstraintPost
1669      * @param _globalConstraint the address of the global constraint to be remove.
1670      * @param _avatar the organization avatar.
1671      * @return bool which represents a success
1672      */
1673     function removeGlobalConstraintPost(address _globalConstraint, address _avatar)
1674     private returns(bool)
1675     {
1676         GlobalConstraintRegister memory globalConstraintRegister =
1677         organizations[_avatar].globalConstraintsRegisterPost[_globalConstraint];
1678         GlobalConstraint[] storage globalConstraints = organizations[_avatar].globalConstraintsPost;
1679 
1680         if (globalConstraintRegister.isRegistered) {
1681             if (globalConstraintRegister.index < globalConstraints.length-1) {
1682                 GlobalConstraint memory globalConstraint = globalConstraints[globalConstraints.length-1];
1683                 globalConstraints[globalConstraintRegister.index] = globalConstraint;
1684                 organizations[_avatar].globalConstraintsRegisterPost[globalConstraint.gcAddress].index =
1685                 globalConstraintRegister.index;
1686             }
1687             globalConstraints.length--;
1688             delete organizations[_avatar].globalConstraintsRegisterPost[_globalConstraint];
1689             emit RemoveGlobalConstraint(_globalConstraint, globalConstraintRegister.index, false, _avatar);
1690             return true;
1691         }
1692         return false;
1693     }
1694 
1695     function _isSchemeRegistered( address _scheme, address _avatar) private view returns(bool) {
1696         return (organizations[_avatar].schemes[_scheme].permissions&bytes4(0x00000001) != bytes4(0));
1697     }
1698 }
1699 
1700 // File: contracts/controller/Controller.sol
1701 
1702 pragma solidity ^0.5.4;
1703 
1704 
1705 
1706 
1707 
1708 /**
1709  * @title Controller contract
1710  * @dev A controller controls the organizations tokens, reputation and avatar.
1711  * It is subject to a set of schemes and constraints that determine its behavior.
1712  * Each scheme has it own parameters and operation permissions.
1713  */
1714 contract Controller is ControllerInterface {
1715 
1716     struct Scheme {
1717         bytes32 paramsHash;  // a hash "configuration" of the scheme
1718         bytes4  permissions; // A bitwise flags of permissions,
1719                              // All 0: Not registered,
1720                              // 1st bit: Flag if the scheme is registered,
1721                              // 2nd bit: Scheme can register other schemes
1722                              // 3rd bit: Scheme can add/remove global constraints
1723                              // 4th bit: Scheme can upgrade the controller
1724                              // 5th bit: Scheme can call genericCall on behalf of
1725                              //          the organization avatar
1726     }
1727 
1728     struct GlobalConstraint {
1729         address gcAddress;
1730         bytes32 params;
1731     }
1732 
1733     struct GlobalConstraintRegister {
1734         bool isRegistered; //is registered
1735         uint256 index;    //index at globalConstraints
1736     }
1737 
1738     mapping(address=>Scheme) public schemes;
1739 
1740     Avatar public avatar;
1741     DAOToken public nativeToken;
1742     Reputation public nativeReputation;
1743   // newController will point to the new controller after the present controller is upgraded
1744     address public newController;
1745   // globalConstraintsPre that determine pre conditions for all actions on the controller
1746 
1747     GlobalConstraint[] public globalConstraintsPre;
1748   // globalConstraintsPost that determine post conditions for all actions on the controller
1749     GlobalConstraint[] public globalConstraintsPost;
1750   // globalConstraintsRegisterPre indicate if a globalConstraints is registered as a pre global constraint
1751     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPre;
1752   // globalConstraintsRegisterPost indicate if a globalConstraints is registered as a post global constraint
1753     mapping(address=>GlobalConstraintRegister) public globalConstraintsRegisterPost;
1754 
1755     event MintReputation (address indexed _sender, address indexed _to, uint256 _amount);
1756     event BurnReputation (address indexed _sender, address indexed _from, uint256 _amount);
1757     event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount);
1758     event RegisterScheme (address indexed _sender, address indexed _scheme);
1759     event UnregisterScheme (address indexed _sender, address indexed _scheme);
1760     event UpgradeController(address indexed _oldController, address _newController);
1761 
1762     event AddGlobalConstraint(
1763         address indexed _globalConstraint,
1764         bytes32 _params,
1765         GlobalConstraintInterface.CallPhase _when);
1766 
1767     event RemoveGlobalConstraint(address indexed _globalConstraint, uint256 _index, bool _isPre);
1768 
1769     constructor( Avatar _avatar) public {
1770         avatar = _avatar;
1771         nativeToken = avatar.nativeToken();
1772         nativeReputation = avatar.nativeReputation();
1773         schemes[msg.sender] = Scheme({paramsHash: bytes32(0), permissions: bytes4(0x0000001F)});
1774     }
1775 
1776   // Do not allow mistaken calls:
1777    // solhint-disable-next-line payable-fallback
1778     function() external {
1779         revert();
1780     }
1781 
1782   // Modifiers:
1783     modifier onlyRegisteredScheme() {
1784         require(schemes[msg.sender].permissions&bytes4(0x00000001) == bytes4(0x00000001));
1785         _;
1786     }
1787 
1788     modifier onlyRegisteringSchemes() {
1789         require(schemes[msg.sender].permissions&bytes4(0x00000002) == bytes4(0x00000002));
1790         _;
1791     }
1792 
1793     modifier onlyGlobalConstraintsScheme() {
1794         require(schemes[msg.sender].permissions&bytes4(0x00000004) == bytes4(0x00000004));
1795         _;
1796     }
1797 
1798     modifier onlyUpgradingScheme() {
1799         require(schemes[msg.sender].permissions&bytes4(0x00000008) == bytes4(0x00000008));
1800         _;
1801     }
1802 
1803     modifier onlyGenericCallScheme() {
1804         require(schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1805         _;
1806     }
1807 
1808     modifier onlyMetaDataScheme() {
1809         require(schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1810         _;
1811     }
1812 
1813     modifier onlySubjectToConstraint(bytes32 func) {
1814         uint256 idx;
1815         for (idx = 0; idx < globalConstraintsPre.length; idx++) {
1816             require(
1817             (GlobalConstraintInterface(globalConstraintsPre[idx].gcAddress))
1818             .pre(msg.sender, globalConstraintsPre[idx].params, func));
1819         }
1820         _;
1821         for (idx = 0; idx < globalConstraintsPost.length; idx++) {
1822             require(
1823             (GlobalConstraintInterface(globalConstraintsPost[idx].gcAddress))
1824             .post(msg.sender, globalConstraintsPost[idx].params, func));
1825         }
1826     }
1827 
1828     modifier isAvatarValid(address _avatar) {
1829         require(_avatar == address(avatar));
1830         _;
1831     }
1832 
1833     /**
1834      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1835      * @param  _amount amount of reputation to mint
1836      * @param _to beneficiary address
1837      * @return bool which represents a success
1838      */
1839     function mintReputation(uint256 _amount, address _to, address _avatar)
1840     external
1841     onlyRegisteredScheme
1842     onlySubjectToConstraint("mintReputation")
1843     isAvatarValid(_avatar)
1844     returns(bool)
1845     {
1846         emit MintReputation(msg.sender, _to, _amount);
1847         return nativeReputation.mint(_to, _amount);
1848     }
1849 
1850     /**
1851      * @dev Burns `_amount` of reputation from `_from`
1852      * @param _amount amount of reputation to burn
1853      * @param _from The address that will lose the reputation
1854      * @return bool which represents a success
1855      */
1856     function burnReputation(uint256 _amount, address _from, address _avatar)
1857     external
1858     onlyRegisteredScheme
1859     onlySubjectToConstraint("burnReputation")
1860     isAvatarValid(_avatar)
1861     returns(bool)
1862     {
1863         emit BurnReputation(msg.sender, _from, _amount);
1864         return nativeReputation.burn(_from, _amount);
1865     }
1866 
1867     /**
1868      * @dev mint tokens .
1869      * @param  _amount amount of token to mint
1870      * @param _beneficiary beneficiary address
1871      * @return bool which represents a success
1872      */
1873     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
1874     external
1875     onlyRegisteredScheme
1876     onlySubjectToConstraint("mintTokens")
1877     isAvatarValid(_avatar)
1878     returns(bool)
1879     {
1880         emit MintTokens(msg.sender, _beneficiary, _amount);
1881         return nativeToken.mint(_beneficiary, _amount);
1882     }
1883 
1884   /**
1885    * @dev register a scheme
1886    * @param _scheme the address of the scheme
1887    * @param _paramsHash a hashed configuration of the usage of the scheme
1888    * @param _permissions the permissions the new scheme will have
1889    * @return bool which represents a success
1890    */
1891     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
1892     external
1893     onlyRegisteringSchemes
1894     onlySubjectToConstraint("registerScheme")
1895     isAvatarValid(_avatar)
1896     returns(bool)
1897     {
1898 
1899         Scheme memory scheme = schemes[_scheme];
1900 
1901     // Check scheme has at least the permissions it is changing, and at least the current permissions:
1902     // Implementation is a bit messy. One must recall logic-circuits ^^
1903 
1904     // produces non-zero if sender does not have all of the perms that are changing between old and new
1905         require(bytes4(0x0000001f)&(_permissions^scheme.permissions)&(~schemes[msg.sender].permissions) == bytes4(0));
1906 
1907     // produces non-zero if sender does not have all of the perms in the old scheme
1908         require(bytes4(0x0000001f)&(scheme.permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1909 
1910     // Add or change the scheme:
1911         schemes[_scheme].paramsHash = _paramsHash;
1912         schemes[_scheme].permissions = _permissions|bytes4(0x00000001);
1913         emit RegisterScheme(msg.sender, _scheme);
1914         return true;
1915     }
1916 
1917     /**
1918      * @dev unregister a scheme
1919      * @param _scheme the address of the scheme
1920      * @return bool which represents a success
1921      */
1922     function unregisterScheme( address _scheme, address _avatar)
1923     external
1924     onlyRegisteringSchemes
1925     onlySubjectToConstraint("unregisterScheme")
1926     isAvatarValid(_avatar)
1927     returns(bool)
1928     {
1929     //check if the scheme is registered
1930         if (_isSchemeRegistered(_scheme) == false) {
1931             return false;
1932         }
1933     // Check the unregistering scheme has enough permissions:
1934         require(bytes4(0x0000001f)&(schemes[_scheme].permissions&(~schemes[msg.sender].permissions)) == bytes4(0));
1935 
1936     // Unregister:
1937         emit UnregisterScheme(msg.sender, _scheme);
1938         delete schemes[_scheme];
1939         return true;
1940     }
1941 
1942     /**
1943      * @dev unregister the caller's scheme
1944      * @return bool which represents a success
1945      */
1946     function unregisterSelf(address _avatar) external isAvatarValid(_avatar) returns(bool) {
1947         if (_isSchemeRegistered(msg.sender) == false) {
1948             return false;
1949         }
1950         delete schemes[msg.sender];
1951         emit UnregisterScheme(msg.sender, msg.sender);
1952         return true;
1953     }
1954 
1955     /**
1956      * @dev add or update Global Constraint
1957      * @param _globalConstraint the address of the global constraint to be added.
1958      * @param _params the constraint parameters hash.
1959      * @return bool which represents a success
1960      */
1961     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
1962     external
1963     onlyGlobalConstraintsScheme
1964     isAvatarValid(_avatar)
1965     returns(bool)
1966     {
1967         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1968         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1969             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1970             if (!globalConstraintsRegisterPre[_globalConstraint].isRegistered) {
1971                 globalConstraintsPre.push(GlobalConstraint(_globalConstraint, _params));
1972                 globalConstraintsRegisterPre[_globalConstraint] =
1973                 GlobalConstraintRegister(true, globalConstraintsPre.length-1);
1974             }else {
1975                 globalConstraintsPre[globalConstraintsRegisterPre[_globalConstraint].index].params = _params;
1976             }
1977         }
1978         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1979             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1980             if (!globalConstraintsRegisterPost[_globalConstraint].isRegistered) {
1981                 globalConstraintsPost.push(GlobalConstraint(_globalConstraint, _params));
1982                 globalConstraintsRegisterPost[_globalConstraint] =
1983                 GlobalConstraintRegister(true, globalConstraintsPost.length-1);
1984             }else {
1985                 globalConstraintsPost[globalConstraintsRegisterPost[_globalConstraint].index].params = _params;
1986             }
1987         }
1988         emit AddGlobalConstraint(_globalConstraint, _params, when);
1989         return true;
1990     }
1991 
1992     /**
1993      * @dev remove Global Constraint
1994      * @param _globalConstraint the address of the global constraint to be remove.
1995      * @return bool which represents a success
1996      */
1997      // solhint-disable-next-line code-complexity
1998     function removeGlobalConstraint (address _globalConstraint, address _avatar)
1999     external
2000     onlyGlobalConstraintsScheme
2001     isAvatarValid(_avatar)
2002     returns(bool)
2003     {
2004         GlobalConstraintRegister memory globalConstraintRegister;
2005         GlobalConstraint memory globalConstraint;
2006         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
2007         bool retVal = false;
2008 
2009         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
2010             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
2011             globalConstraintRegister = globalConstraintsRegisterPre[_globalConstraint];
2012             if (globalConstraintRegister.isRegistered) {
2013                 if (globalConstraintRegister.index < globalConstraintsPre.length-1) {
2014                     globalConstraint = globalConstraintsPre[globalConstraintsPre.length-1];
2015                     globalConstraintsPre[globalConstraintRegister.index] = globalConstraint;
2016                     globalConstraintsRegisterPre[globalConstraint.gcAddress].index = globalConstraintRegister.index;
2017                 }
2018                 globalConstraintsPre.length--;
2019                 delete globalConstraintsRegisterPre[_globalConstraint];
2020                 retVal = true;
2021             }
2022         }
2023         if ((when == GlobalConstraintInterface.CallPhase.Post)||
2024             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
2025             globalConstraintRegister = globalConstraintsRegisterPost[_globalConstraint];
2026             if (globalConstraintRegister.isRegistered) {
2027                 if (globalConstraintRegister.index < globalConstraintsPost.length-1) {
2028                     globalConstraint = globalConstraintsPost[globalConstraintsPost.length-1];
2029                     globalConstraintsPost[globalConstraintRegister.index] = globalConstraint;
2030                     globalConstraintsRegisterPost[globalConstraint.gcAddress].index = globalConstraintRegister.index;
2031                 }
2032                 globalConstraintsPost.length--;
2033                 delete globalConstraintsRegisterPost[_globalConstraint];
2034                 retVal = true;
2035             }
2036         }
2037         if (retVal) {
2038             emit RemoveGlobalConstraint(
2039             _globalConstraint,
2040             globalConstraintRegister.index,
2041             when == GlobalConstraintInterface.CallPhase.Pre
2042             );
2043         }
2044         return retVal;
2045     }
2046 
2047   /**
2048     * @dev upgrade the Controller
2049     *      The function will trigger an event 'UpgradeController'.
2050     * @param  _newController the address of the new controller.
2051     * @return bool which represents a success
2052     */
2053     function upgradeController(address _newController, Avatar _avatar)
2054     external
2055     onlyUpgradingScheme
2056     isAvatarValid(address(_avatar))
2057     returns(bool)
2058     {
2059         require(newController == address(0));   // so the upgrade could be done once for a contract.
2060         require(_newController != address(0));
2061         newController = _newController;
2062         avatar.transferOwnership(_newController);
2063         require(avatar.owner() == _newController);
2064         if (nativeToken.owner() == address(this)) {
2065             nativeToken.transferOwnership(_newController);
2066             require(nativeToken.owner() == _newController);
2067         }
2068         if (nativeReputation.owner() == address(this)) {
2069             nativeReputation.transferOwnership(_newController);
2070             require(nativeReputation.owner() == _newController);
2071         }
2072         emit UpgradeController(address(this), newController);
2073         return true;
2074     }
2075 
2076     /**
2077     * @dev perform a generic call to an arbitrary contract
2078     * @param _contract  the contract's address to call
2079     * @param _data ABI-encoded contract call to call `_contract` address.
2080     * @param _avatar the controller's avatar address
2081     * @param _value value (ETH) to transfer with the transaction
2082     * @return bool -success
2083     *         bytes  - the return value of the called _contract's function.
2084     */
2085     function genericCall(address _contract, bytes calldata _data, Avatar _avatar, uint256 _value)
2086     external
2087     onlyGenericCallScheme
2088     onlySubjectToConstraint("genericCall")
2089     isAvatarValid(address(_avatar))
2090     returns (bool, bytes memory)
2091     {
2092         return avatar.genericCall(_contract, _data, _value);
2093     }
2094 
2095   /**
2096    * @dev send some ether
2097    * @param _amountInWei the amount of ether (in Wei) to send
2098    * @param _to address of the beneficiary
2099    * @return bool which represents a success
2100    */
2101     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
2102     external
2103     onlyRegisteredScheme
2104     onlySubjectToConstraint("sendEther")
2105     isAvatarValid(address(_avatar))
2106     returns(bool)
2107     {
2108         return avatar.sendEther(_amountInWei, _to);
2109     }
2110 
2111     /**
2112     * @dev send some amount of arbitrary ERC20 Tokens
2113     * @param _externalToken the address of the Token Contract
2114     * @param _to address of the beneficiary
2115     * @param _value the amount of ether (in Wei) to send
2116     * @return bool which represents a success
2117     */
2118     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
2119     external
2120     onlyRegisteredScheme
2121     onlySubjectToConstraint("externalTokenTransfer")
2122     isAvatarValid(address(_avatar))
2123     returns(bool)
2124     {
2125         return avatar.externalTokenTransfer(_externalToken, _to, _value);
2126     }
2127 
2128     /**
2129     * @dev transfer token "from" address "to" address
2130     *      One must to approve the amount of tokens which can be spend from the
2131     *      "from" account.This can be done using externalTokenApprove.
2132     * @param _externalToken the address of the Token Contract
2133     * @param _from address of the account to send from
2134     * @param _to address of the beneficiary
2135     * @param _value the amount of ether (in Wei) to send
2136     * @return bool which represents a success
2137     */
2138     function externalTokenTransferFrom(
2139     IERC20 _externalToken,
2140     address _from,
2141     address _to,
2142     uint256 _value,
2143     Avatar _avatar)
2144     external
2145     onlyRegisteredScheme
2146     onlySubjectToConstraint("externalTokenTransferFrom")
2147     isAvatarValid(address(_avatar))
2148     returns(bool)
2149     {
2150         return avatar.externalTokenTransferFrom(_externalToken, _from, _to, _value);
2151     }
2152 
2153     /**
2154     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
2155     *      on behalf of msg.sender.
2156     * @param _externalToken the address of the Token Contract
2157     * @param _spender address
2158     * @param _value the amount of ether (in Wei) which the approval is referring to.
2159     * @return bool which represents a success
2160     */
2161     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
2162     external
2163     onlyRegisteredScheme
2164     onlySubjectToConstraint("externalTokenIncreaseApproval")
2165     isAvatarValid(address(_avatar))
2166     returns(bool)
2167     {
2168         return avatar.externalTokenApproval(_externalToken, _spender, _value);
2169     }
2170 
2171     /**
2172     * @dev metaData emits an event with a string, should contain the hash of some meta data.
2173     * @param _metaData a string representing a hash of the meta data
2174     * @param _avatar Avatar
2175     * @return bool which represents a success
2176     */
2177     function metaData(string calldata _metaData, Avatar _avatar)
2178         external
2179         onlyMetaDataScheme
2180         isAvatarValid(address(_avatar))
2181         returns(bool)
2182         {
2183         return avatar.metaData(_metaData);
2184     }
2185 
2186     /**
2187      * @dev getNativeReputation
2188      * @param _avatar the organization avatar.
2189      * @return organization native reputation
2190      */
2191     function getNativeReputation(address _avatar) external isAvatarValid(_avatar) view returns(address) {
2192         return address(nativeReputation);
2193     }
2194 
2195     function isSchemeRegistered(address _scheme, address _avatar) external isAvatarValid(_avatar) view returns(bool) {
2196         return _isSchemeRegistered(_scheme);
2197     }
2198 
2199     function getSchemeParameters(address _scheme, address _avatar)
2200     external
2201     isAvatarValid(_avatar)
2202     view
2203     returns(bytes32)
2204     {
2205         return schemes[_scheme].paramsHash;
2206     }
2207 
2208     function getSchemePermissions(address _scheme, address _avatar)
2209     external
2210     isAvatarValid(_avatar)
2211     view
2212     returns(bytes4)
2213     {
2214         return schemes[_scheme].permissions;
2215     }
2216 
2217     function getGlobalConstraintParameters(address _globalConstraint, address) external view returns(bytes32) {
2218 
2219         GlobalConstraintRegister memory register = globalConstraintsRegisterPre[_globalConstraint];
2220 
2221         if (register.isRegistered) {
2222             return globalConstraintsPre[register.index].params;
2223         }
2224 
2225         register = globalConstraintsRegisterPost[_globalConstraint];
2226 
2227         if (register.isRegistered) {
2228             return globalConstraintsPost[register.index].params;
2229         }
2230     }
2231 
2232    /**
2233     * @dev globalConstraintsCount return the global constraint pre and post count
2234     * @return uint256 globalConstraintsPre count.
2235     * @return uint256 globalConstraintsPost count.
2236     */
2237     function globalConstraintsCount(address _avatar)
2238         external
2239         isAvatarValid(_avatar)
2240         view
2241         returns(uint, uint)
2242         {
2243         return (globalConstraintsPre.length, globalConstraintsPost.length);
2244     }
2245 
2246     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar)
2247         external
2248         isAvatarValid(_avatar)
2249         view
2250         returns(bool)
2251         {
2252         return (globalConstraintsRegisterPre[_globalConstraint].isRegistered ||
2253                 globalConstraintsRegisterPost[_globalConstraint].isRegistered);
2254     }
2255 
2256     function _isSchemeRegistered(address _scheme) private view returns(bool) {
2257         return (schemes[_scheme].permissions&bytes4(0x00000001) != bytes4(0));
2258     }
2259 }
2260 
2261 // File: contracts/universalSchemes/DaoCreator.sol
2262 
2263 pragma solidity ^0.5.4;
2264 
2265 
2266 
2267 
2268 
2269 /**
2270  * @title ControllerCreator for creating a single controller.
2271  */
2272 
2273 contract ControllerCreator {
2274 
2275     function create(Avatar _avatar) public returns(address) {
2276         Controller controller = new Controller(_avatar);
2277         controller.registerScheme(msg.sender, bytes32(0), bytes4(0x0000001f), address(_avatar));
2278         controller.unregisterScheme(address(this), address(_avatar));
2279         return address(controller);
2280     }
2281 }
2282 
2283 /**
2284  * @title Genesis Scheme that creates organizations
2285  */
2286 
2287 
2288 contract DaoCreator {
2289 
2290     mapping(address=>address) public locks;
2291 
2292     event NewOrg (address _avatar);
2293     event InitialSchemesSet (address _avatar);
2294 
2295     ControllerCreator private controllerCreator;
2296 
2297     constructor(ControllerCreator _controllerCreator) public {
2298         controllerCreator = _controllerCreator;
2299     }
2300 
2301     /**
2302       * @dev addFounders add founders to the organization.
2303       *      this function can be called only after forgeOrg and before setSchemes
2304       * @param _avatar the organization avatar
2305       * @param _founders An array with the addresses of the founders of the organization
2306       * @param _foundersTokenAmount An array of amount of tokens that the founders
2307       *  receive in the new organization
2308       * @param _foundersReputationAmount An array of amount of reputation that the
2309       *   founders receive in the new organization
2310       * @return bool true or false
2311       */
2312     function addFounders (
2313         Avatar _avatar,
2314         address[] calldata _founders,
2315         uint[] calldata _foundersTokenAmount,
2316         uint[] calldata _foundersReputationAmount
2317     )
2318     external
2319     returns(bool)
2320     {
2321         require(_founders.length == _foundersTokenAmount.length);
2322         require(_founders.length == _foundersReputationAmount.length);
2323         require(_founders.length > 0);
2324         require(locks[address(_avatar)] == msg.sender);
2325         // Mint token and reputation for founders:
2326         for (uint256 i = 0; i < _founders.length; i++) {
2327             require(_founders[i] != address(0));
2328             if (_foundersTokenAmount[i] > 0) {
2329                 ControllerInterface(
2330                 _avatar.owner()).mintTokens(_foundersTokenAmount[i], _founders[i], address(_avatar));
2331             }
2332             if (_foundersReputationAmount[i] > 0) {
2333                 ControllerInterface(
2334                 _avatar.owner()).mintReputation(_foundersReputationAmount[i], _founders[i], address(_avatar));
2335             }
2336         }
2337         return true;
2338     }
2339 
2340   /**
2341     * @dev Create a new organization
2342     * @param _orgName The name of the new organization
2343     * @param _tokenName The name of the token associated with the organization
2344     * @param _tokenSymbol The symbol of the token
2345     * @param _founders An array with the addresses of the founders of the organization
2346     * @param _foundersTokenAmount An array of amount of tokens that the founders
2347     *  receive in the new organization
2348     * @param _foundersReputationAmount An array of amount of reputation that the
2349     *   founders receive in the new organization
2350     * @param  _uController universal controller instance
2351     *         if _uController address equal to zero the organization will use none universal controller.
2352     * @param  _cap token cap - 0 for no cap.
2353     * @return The address of the avatar of the controller
2354     */
2355     function forgeOrg (
2356         string calldata _orgName,
2357         string calldata _tokenName,
2358         string calldata _tokenSymbol,
2359         address[] calldata _founders,
2360         uint[] calldata _foundersTokenAmount,
2361         uint[] calldata _foundersReputationAmount,
2362         UController _uController,
2363         uint256 _cap
2364     )
2365     external
2366     returns(address)
2367     {
2368         //The call for the private function is needed to bypass a deep stack issues
2369         return _forgeOrg(
2370             _orgName,
2371             _tokenName,
2372             _tokenSymbol,
2373             _founders,
2374             _foundersTokenAmount,
2375             _foundersReputationAmount,
2376             _uController,
2377             _cap);
2378     }
2379 
2380      /**
2381       * @dev Set initial schemes for the organization.
2382       * @param _avatar organization avatar (returns from forgeOrg)
2383       * @param _schemes the schemes to register for the organization
2384       * @param _params the schemes's params
2385       * @param _permissions the schemes permissions.
2386       * @param _metaData dao meta data hash
2387       */
2388     function setSchemes (
2389         Avatar _avatar,
2390         address[] calldata _schemes,
2391         bytes32[] calldata _params,
2392         bytes4[] calldata _permissions,
2393         string calldata _metaData
2394     )
2395         external
2396     {
2397         // this action can only be executed by the account that holds the lock
2398         // for this controller
2399         require(locks[address(_avatar)] == msg.sender);
2400         // register initial schemes:
2401         ControllerInterface controller = ControllerInterface(_avatar.owner());
2402         for (uint256 i = 0; i < _schemes.length; i++) {
2403             controller.registerScheme(_schemes[i], _params[i], _permissions[i], address(_avatar));
2404         }
2405         controller.metaData(_metaData, _avatar);
2406         // Unregister self:
2407         controller.unregisterScheme(address(this), address(_avatar));
2408         // Remove lock:
2409         delete locks[address(_avatar)];
2410         emit InitialSchemesSet(address(_avatar));
2411     }
2412 
2413     /**
2414      * @dev Create a new organization
2415      * @param _orgName The name of the new organization
2416      * @param _tokenName The name of the token associated with the organization
2417      * @param _tokenSymbol The symbol of the token
2418      * @param _founders An array with the addresses of the founders of the organization
2419      * @param _foundersTokenAmount An array of amount of tokens that the founders
2420      *  receive in the new organization
2421      * @param _foundersReputationAmount An array of amount of reputation that the
2422      *   founders receive in the new organization
2423      * @param  _uController universal controller instance
2424      *         if _uController address equal to zero the organization will use none universal controller.
2425      * @param  _cap token cap - 0 for no cap.
2426      * @return The address of the avatar of the controller
2427      */
2428     function _forgeOrg (
2429         string memory _orgName,
2430         string memory _tokenName,
2431         string memory _tokenSymbol,
2432         address[] memory _founders,
2433         uint[] memory _foundersTokenAmount,
2434         uint[] memory _foundersReputationAmount,
2435         UController _uController,
2436         uint256 _cap
2437     ) private returns(address)
2438     {
2439         // Create Token, Reputation and Avatar:
2440         require(_founders.length == _foundersTokenAmount.length);
2441         require(_founders.length == _foundersReputationAmount.length);
2442         require(_founders.length > 0);
2443         DAOToken  nativeToken = new DAOToken(_tokenName, _tokenSymbol, _cap);
2444         Reputation  nativeReputation = new Reputation();
2445         Avatar  avatar = new Avatar(_orgName, nativeToken, nativeReputation);
2446         ControllerInterface  controller;
2447 
2448         // Mint token and reputation for founders:
2449         for (uint256 i = 0; i < _founders.length; i++) {
2450             require(_founders[i] != address(0));
2451             if (_foundersTokenAmount[i] > 0) {
2452                 nativeToken.mint(_founders[i], _foundersTokenAmount[i]);
2453             }
2454             if (_foundersReputationAmount[i] > 0) {
2455                 nativeReputation.mint(_founders[i], _foundersReputationAmount[i]);
2456             }
2457         }
2458 
2459         // Create Controller:
2460         if (UController(0) == _uController) {
2461             controller = ControllerInterface(controllerCreator.create(avatar));
2462             avatar.transferOwnership(address(controller));
2463             // Transfer ownership:
2464             nativeToken.transferOwnership(address(controller));
2465             nativeReputation.transferOwnership(address(controller));
2466         } else {
2467             controller = _uController;
2468             avatar.transferOwnership(address(controller));
2469             // Transfer ownership:
2470             nativeToken.transferOwnership(address(controller));
2471             nativeReputation.transferOwnership(address(controller));
2472             _uController.newOrganization(avatar);
2473         }
2474 
2475         locks[address(avatar)] = msg.sender;
2476 
2477         emit NewOrg (address(avatar));
2478         return (address(avatar));
2479     }
2480 }
