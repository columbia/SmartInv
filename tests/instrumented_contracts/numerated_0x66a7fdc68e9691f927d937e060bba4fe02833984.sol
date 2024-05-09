1 
2 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
3 
4 pragma solidity ^0.5.2;
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
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      * @notice Renouncing ownership will leave the contract without an owner,
52      * thereby removing any functionality that is only available to the owner.
53      */
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function _transferOwnership(address newOwner) internal {
72         require(newOwner != address(0));
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 // File: @daostack/infra/contracts/Reputation.sol
79 
80 pragma solidity ^0.5.4;
81 
82 
83 
84 /**
85  * @title Reputation system
86  * @dev A DAO has Reputation System which allows peers to rate other peers in order to build trust .
87  * A reputation is use to assign influence measure to a DAO'S peers.
88  * Reputation is similar to regular tokens but with one crucial difference: It is non-transferable.
89  * The Reputation contract maintain a map of address to reputation value.
90  * It provides an onlyOwner functions to mint and burn reputation _to (or _from) a specific address.
91  */
92 
93 contract Reputation is Ownable {
94 
95     uint8 public decimals = 18;             //Number of decimals of the smallest unit
96     // Event indicating minting of reputation to an address.
97     event Mint(address indexed _to, uint256 _amount);
98     // Event indicating burning of reputation for an address.
99     event Burn(address indexed _from, uint256 _amount);
100 
101       /// @dev `Checkpoint` is the structure that attaches a block number to a
102       ///  given value, the block number attached is the one that last changed the
103       ///  value
104     struct Checkpoint {
105 
106     // `fromBlock` is the block number that the value was generated from
107         uint128 fromBlock;
108 
109           // `value` is the amount of reputation at a specific block number
110         uint128 value;
111     }
112 
113       // `balances` is the map that tracks the balance of each address, in this
114       //  contract when the balance changes the block number that the change
115       //  occurred is also included in the map
116     mapping (address => Checkpoint[]) balances;
117 
118       // Tracks the history of the `totalSupply` of the reputation
119     Checkpoint[] totalSupplyHistory;
120 
121     /// @notice Constructor to create a Reputation
122     constructor(
123     ) public
124     {
125     }
126 
127     /// @dev This function makes it easy to get the total number of reputation
128     /// @return The total number of reputation
129     function totalSupply() public view returns (uint256) {
130         return totalSupplyAt(block.number);
131     }
132 
133   ////////////////
134   // Query balance and totalSupply in History
135   ////////////////
136     /**
137     * @dev return the reputation amount of a given owner
138     * @param _owner an address of the owner which we want to get his reputation
139     */
140     function balanceOf(address _owner) public view returns (uint256 balance) {
141         return balanceOfAt(_owner, block.number);
142     }
143 
144       /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
145       /// @param _owner The address from which the balance will be retrieved
146       /// @param _blockNumber The block number when the balance is queried
147       /// @return The balance at `_blockNumber`
148     function balanceOfAt(address _owner, uint256 _blockNumber)
149     public view returns (uint256)
150     {
151         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
152             return 0;
153           // This will return the expected balance during normal situations
154         } else {
155             return getValueAt(balances[_owner], _blockNumber);
156         }
157     }
158 
159       /// @notice Total amount of reputation at a specific `_blockNumber`.
160       /// @param _blockNumber The block number when the totalSupply is queried
161       /// @return The total amount of reputation at `_blockNumber`
162     function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
163         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
164             return 0;
165           // This will return the expected totalSupply during normal situations
166         } else {
167             return getValueAt(totalSupplyHistory, _blockNumber);
168         }
169     }
170 
171       /// @notice Generates `_amount` reputation that are assigned to `_owner`
172       /// @param _user The address that will be assigned the new reputation
173       /// @param _amount The quantity of reputation generated
174       /// @return True if the reputation are generated correctly
175     function mint(address _user, uint256 _amount) public onlyOwner returns (bool) {
176         uint256 curTotalSupply = totalSupply();
177         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
178         uint256 previousBalanceTo = balanceOf(_user);
179         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
180         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
181         updateValueAtNow(balances[_user], previousBalanceTo + _amount);
182         emit Mint(_user, _amount);
183         return true;
184     }
185 
186       /// @notice Burns `_amount` reputation from `_owner`
187       /// @param _user The address that will lose the reputation
188       /// @param _amount The quantity of reputation to burn
189       /// @return True if the reputation are burned correctly
190     function burn(address _user, uint256 _amount) public onlyOwner returns (bool) {
191         uint256 curTotalSupply = totalSupply();
192         uint256 amountBurned = _amount;
193         uint256 previousBalanceFrom = balanceOf(_user);
194         if (previousBalanceFrom < amountBurned) {
195             amountBurned = previousBalanceFrom;
196         }
197         updateValueAtNow(totalSupplyHistory, curTotalSupply - amountBurned);
198         updateValueAtNow(balances[_user], previousBalanceFrom - amountBurned);
199         emit Burn(_user, amountBurned);
200         return true;
201     }
202 
203   ////////////////
204   // Internal helper functions to query and set a value in a snapshot array
205   ////////////////
206 
207       /// @dev `getValueAt` retrieves the number of reputation at a given block number
208       /// @param checkpoints The history of values being queried
209       /// @param _block The block number to retrieve the value at
210       /// @return The number of reputation being queried
211     function getValueAt(Checkpoint[] storage checkpoints, uint256 _block) internal view returns (uint256) {
212         if (checkpoints.length == 0) {
213             return 0;
214         }
215 
216           // Shortcut for the actual value
217         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
218             return checkpoints[checkpoints.length-1].value;
219         }
220         if (_block < checkpoints[0].fromBlock) {
221             return 0;
222         }
223 
224           // Binary search of the value in the array
225         uint256 min = 0;
226         uint256 max = checkpoints.length-1;
227         while (max > min) {
228             uint256 mid = (max + min + 1) / 2;
229             if (checkpoints[mid].fromBlock<=_block) {
230                 min = mid;
231             } else {
232                 max = mid-1;
233             }
234         }
235         return checkpoints[min].value;
236     }
237 
238       /// @dev `updateValueAtNow` used to update the `balances` map and the
239       ///  `totalSupplyHistory`
240       /// @param checkpoints The history of data being updated
241       /// @param _value The new number of reputation
242     function updateValueAtNow(Checkpoint[] storage checkpoints, uint256 _value) internal {
243         require(uint128(_value) == _value); //check value is in the 128 bits bounderies
244         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
245             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
246             newCheckPoint.fromBlock = uint128(block.number);
247             newCheckPoint.value = uint128(_value);
248         } else {
249             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
250             oldCheckPoint.value = uint128(_value);
251         }
252     }
253 }
254 
255 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
256 
257 pragma solidity ^0.5.2;
258 
259 /**
260  * @title ERC20 interface
261  * @dev see https://eips.ethereum.org/EIPS/eip-20
262  */
263 interface IERC20 {
264     function transfer(address to, uint256 value) external returns (bool);
265 
266     function approve(address spender, uint256 value) external returns (bool);
267 
268     function transferFrom(address from, address to, uint256 value) external returns (bool);
269 
270     function totalSupply() external view returns (uint256);
271 
272     function balanceOf(address who) external view returns (uint256);
273 
274     function allowance(address owner, address spender) external view returns (uint256);
275 
276     event Transfer(address indexed from, address indexed to, uint256 value);
277 
278     event Approval(address indexed owner, address indexed spender, uint256 value);
279 }
280 
281 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
282 
283 pragma solidity ^0.5.2;
284 
285 /**
286  * @title SafeMath
287  * @dev Unsigned math operations with safety checks that revert on error
288  */
289 library SafeMath {
290     /**
291      * @dev Multiplies two unsigned integers, reverts on overflow.
292      */
293     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
294         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
295         // benefit is lost if 'b' is also tested.
296         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
297         if (a == 0) {
298             return 0;
299         }
300 
301         uint256 c = a * b;
302         require(c / a == b);
303 
304         return c;
305     }
306 
307     /**
308      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
309      */
310     function div(uint256 a, uint256 b) internal pure returns (uint256) {
311         // Solidity only automatically asserts when dividing by 0
312         require(b > 0);
313         uint256 c = a / b;
314         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
315 
316         return c;
317     }
318 
319     /**
320      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
321      */
322     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
323         require(b <= a);
324         uint256 c = a - b;
325 
326         return c;
327     }
328 
329     /**
330      * @dev Adds two unsigned integers, reverts on overflow.
331      */
332     function add(uint256 a, uint256 b) internal pure returns (uint256) {
333         uint256 c = a + b;
334         require(c >= a);
335 
336         return c;
337     }
338 
339     /**
340      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
341      * reverts when dividing by zero.
342      */
343     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
344         require(b != 0);
345         return a % b;
346     }
347 }
348 
349 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
350 
351 pragma solidity ^0.5.2;
352 
353 
354 
355 /**
356  * @title Standard ERC20 token
357  *
358  * @dev Implementation of the basic standard token.
359  * https://eips.ethereum.org/EIPS/eip-20
360  * Originally based on code by FirstBlood:
361  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
362  *
363  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
364  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
365  * compliant implementations may not do it.
366  */
367 contract ERC20 is IERC20 {
368     using SafeMath for uint256;
369 
370     mapping (address => uint256) private _balances;
371 
372     mapping (address => mapping (address => uint256)) private _allowed;
373 
374     uint256 private _totalSupply;
375 
376     /**
377      * @dev Total number of tokens in existence
378      */
379     function totalSupply() public view returns (uint256) {
380         return _totalSupply;
381     }
382 
383     /**
384      * @dev Gets the balance of the specified address.
385      * @param owner The address to query the balance of.
386      * @return A uint256 representing the amount owned by the passed address.
387      */
388     function balanceOf(address owner) public view returns (uint256) {
389         return _balances[owner];
390     }
391 
392     /**
393      * @dev Function to check the amount of tokens that an owner allowed to a spender.
394      * @param owner address The address which owns the funds.
395      * @param spender address The address which will spend the funds.
396      * @return A uint256 specifying the amount of tokens still available for the spender.
397      */
398     function allowance(address owner, address spender) public view returns (uint256) {
399         return _allowed[owner][spender];
400     }
401 
402     /**
403      * @dev Transfer token to a specified address
404      * @param to The address to transfer to.
405      * @param value The amount to be transferred.
406      */
407     function transfer(address to, uint256 value) public returns (bool) {
408         _transfer(msg.sender, to, value);
409         return true;
410     }
411 
412     /**
413      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
414      * Beware that changing an allowance with this method brings the risk that someone may use both the old
415      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
416      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
417      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
418      * @param spender The address which will spend the funds.
419      * @param value The amount of tokens to be spent.
420      */
421     function approve(address spender, uint256 value) public returns (bool) {
422         _approve(msg.sender, spender, value);
423         return true;
424     }
425 
426     /**
427      * @dev Transfer tokens from one address to another.
428      * Note that while this function emits an Approval event, this is not required as per the specification,
429      * and other compliant implementations may not emit the event.
430      * @param from address The address which you want to send tokens from
431      * @param to address The address which you want to transfer to
432      * @param value uint256 the amount of tokens to be transferred
433      */
434     function transferFrom(address from, address to, uint256 value) public returns (bool) {
435         _transfer(from, to, value);
436         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
437         return true;
438     }
439 
440     /**
441      * @dev Increase the amount of tokens that an owner allowed to a spender.
442      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
443      * allowed value is better to use this function to avoid 2 calls (and wait until
444      * the first transaction is mined)
445      * From MonolithDAO Token.sol
446      * Emits an Approval event.
447      * @param spender The address which will spend the funds.
448      * @param addedValue The amount of tokens to increase the allowance by.
449      */
450     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
451         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
452         return true;
453     }
454 
455     /**
456      * @dev Decrease the amount of tokens that an owner allowed to a spender.
457      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
458      * allowed value is better to use this function to avoid 2 calls (and wait until
459      * the first transaction is mined)
460      * From MonolithDAO Token.sol
461      * Emits an Approval event.
462      * @param spender The address which will spend the funds.
463      * @param subtractedValue The amount of tokens to decrease the allowance by.
464      */
465     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
466         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
467         return true;
468     }
469 
470     /**
471      * @dev Transfer token for a specified addresses
472      * @param from The address to transfer from.
473      * @param to The address to transfer to.
474      * @param value The amount to be transferred.
475      */
476     function _transfer(address from, address to, uint256 value) internal {
477         require(to != address(0));
478 
479         _balances[from] = _balances[from].sub(value);
480         _balances[to] = _balances[to].add(value);
481         emit Transfer(from, to, value);
482     }
483 
484     /**
485      * @dev Internal function that mints an amount of the token and assigns it to
486      * an account. This encapsulates the modification of balances such that the
487      * proper events are emitted.
488      * @param account The account that will receive the created tokens.
489      * @param value The amount that will be created.
490      */
491     function _mint(address account, uint256 value) internal {
492         require(account != address(0));
493 
494         _totalSupply = _totalSupply.add(value);
495         _balances[account] = _balances[account].add(value);
496         emit Transfer(address(0), account, value);
497     }
498 
499     /**
500      * @dev Internal function that burns an amount of the token of a given
501      * account.
502      * @param account The account whose tokens will be burnt.
503      * @param value The amount that will be burnt.
504      */
505     function _burn(address account, uint256 value) internal {
506         require(account != address(0));
507 
508         _totalSupply = _totalSupply.sub(value);
509         _balances[account] = _balances[account].sub(value);
510         emit Transfer(account, address(0), value);
511     }
512 
513     /**
514      * @dev Approve an address to spend another addresses' tokens.
515      * @param owner The address that owns the tokens.
516      * @param spender The address that will spend the tokens.
517      * @param value The number of tokens that can be spent.
518      */
519     function _approve(address owner, address spender, uint256 value) internal {
520         require(spender != address(0));
521         require(owner != address(0));
522 
523         _allowed[owner][spender] = value;
524         emit Approval(owner, spender, value);
525     }
526 
527     /**
528      * @dev Internal function that burns an amount of the token of a given
529      * account, deducting from the sender's allowance for said account. Uses the
530      * internal burn function.
531      * Emits an Approval event (reflecting the reduced allowance).
532      * @param account The account whose tokens will be burnt.
533      * @param value The amount that will be burnt.
534      */
535     function _burnFrom(address account, uint256 value) internal {
536         _burn(account, value);
537         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
538     }
539 }
540 
541 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
542 
543 pragma solidity ^0.5.2;
544 
545 
546 /**
547  * @title Burnable Token
548  * @dev Token that can be irreversibly burned (destroyed).
549  */
550 contract ERC20Burnable is ERC20 {
551     /**
552      * @dev Burns a specific amount of tokens.
553      * @param value The amount of token to be burned.
554      */
555     function burn(uint256 value) public {
556         _burn(msg.sender, value);
557     }
558 
559     /**
560      * @dev Burns a specific amount of tokens from the target address and decrements allowance
561      * @param from address The account whose tokens will be burned.
562      * @param value uint256 The amount of token to be burned.
563      */
564     function burnFrom(address from, uint256 value) public {
565         _burnFrom(from, value);
566     }
567 }
568 
569 // File: contracts/controller/DAOToken.sol
570 
571 pragma solidity ^0.5.4;
572 
573 
574 
575 
576 
577 /**
578  * @title DAOToken, base on zeppelin contract.
579  * @dev ERC20 compatible token. It is a mintable, burnable token.
580  */
581 
582 contract DAOToken is ERC20, ERC20Burnable, Ownable {
583 
584     string public name;
585     string public symbol;
586     // solhint-disable-next-line const-name-snakecase
587     uint8 public constant decimals = 18;
588     uint256 public cap;
589 
590     /**
591     * @dev Constructor
592     * @param _name - token name
593     * @param _symbol - token symbol
594     * @param _cap - token cap - 0 value means no cap
595     */
596     constructor(string memory _name, string memory _symbol, uint256 _cap)
597     public {
598         name = _name;
599         symbol = _symbol;
600         cap = _cap;
601     }
602 
603     /**
604      * @dev Function to mint tokens
605      * @param _to The address that will receive the minted tokens.
606      * @param _amount The amount of tokens to mint.
607      */
608     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
609         if (cap > 0)
610             require(totalSupply().add(_amount) <= cap);
611         _mint(_to, _amount);
612         return true;
613     }
614 }
615 
616 // File: openzeppelin-solidity/contracts/utils/Address.sol
617 
618 pragma solidity ^0.5.2;
619 
620 /**
621  * Utility library of inline functions on addresses
622  */
623 library Address {
624     /**
625      * Returns whether the target address is a contract
626      * @dev This function will return false if invoked during the constructor of a contract,
627      * as the code is not actually created until after the constructor finishes.
628      * @param account address of the account to check
629      * @return whether the target address is a contract
630      */
631     function isContract(address account) internal view returns (bool) {
632         uint256 size;
633         // XXX Currently there is no better way to check if there is a contract in an address
634         // than to check the size of the code at that address.
635         // See https://ethereum.stackexchange.com/a/14016/36603
636         // for more details about how this works.
637         // TODO Check this again before the Serenity release, because all addresses will be
638         // contracts then.
639         // solhint-disable-next-line no-inline-assembly
640         assembly { size := extcodesize(account) }
641         return size > 0;
642     }
643 }
644 
645 // File: contracts/libs/SafeERC20.sol
646 
647 /*
648 
649 SafeERC20 by daostack.
650 The code is based on a fix by SECBIT Team.
651 
652 USE WITH CAUTION & NO WARRANTY
653 
654 REFERENCE & RELATED READING
655 - https://github.com/ethereum/solidity/issues/4116
656 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
657 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
658 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
659 
660 */
661 pragma solidity ^0.5.4;
662 
663 
664 
665 library SafeERC20 {
666     using Address for address;
667 
668     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
669     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
670     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
671 
672     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
673 
674         // Must be a contract addr first!
675         require(_erc20Addr.isContract());
676 
677         (bool success, bytes memory returnValue) =
678         // solhint-disable-next-line avoid-low-level-calls
679         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
680         // call return false when something wrong
681         require(success);
682         //check return value
683         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
684     }
685 
686     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
687 
688         // Must be a contract addr first!
689         require(_erc20Addr.isContract());
690 
691         (bool success, bytes memory returnValue) =
692         // solhint-disable-next-line avoid-low-level-calls
693         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
694         // call return false when something wrong
695         require(success);
696         //check return value
697         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
698     }
699 
700     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
701 
702         // Must be a contract addr first!
703         require(_erc20Addr.isContract());
704 
705         // safeApprove should only be called when setting an initial allowance,
706         // or when resetting it to zero.
707         require((_value == 0) || (IERC20(_erc20Addr).allowance(address(this), _spender) == 0));
708 
709         (bool success, bytes memory returnValue) =
710         // solhint-disable-next-line avoid-low-level-calls
711         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
712         // call return false when something wrong
713         require(success);
714         //check return value
715         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
716     }
717 }
718 
719 // File: contracts/controller/Avatar.sol
720 
721 pragma solidity ^0.5.4;
722 
723 
724 
725 
726 
727 
728 
729 /**
730  * @title An Avatar holds tokens, reputation and ether for a controller
731  */
732 contract Avatar is Ownable {
733     using SafeERC20 for address;
734 
735     string public orgName;
736     DAOToken public nativeToken;
737     Reputation public nativeReputation;
738 
739     event GenericCall(address indexed _contract, bytes _data, uint _value, bool _success);
740     event SendEther(uint256 _amountInWei, address indexed _to);
741     event ExternalTokenTransfer(address indexed _externalToken, address indexed _to, uint256 _value);
742     event ExternalTokenTransferFrom(address indexed _externalToken, address _from, address _to, uint256 _value);
743     event ExternalTokenApproval(address indexed _externalToken, address _spender, uint256 _value);
744     event ReceiveEther(address indexed _sender, uint256 _value);
745     event MetaData(string _metaData);
746 
747     /**
748     * @dev the constructor takes organization name, native token and reputation system
749     and creates an avatar for a controller
750     */
751     constructor(string memory _orgName, DAOToken _nativeToken, Reputation _nativeReputation) public {
752         orgName = _orgName;
753         nativeToken = _nativeToken;
754         nativeReputation = _nativeReputation;
755     }
756 
757     /**
758     * @dev enables an avatar to receive ethers
759     */
760     function() external payable {
761         emit ReceiveEther(msg.sender, msg.value);
762     }
763 
764     /**
765     * @dev perform a generic call to an arbitrary contract
766     * @param _contract  the contract's address to call
767     * @param _data ABI-encoded contract call to call `_contract` address.
768     * @param _value value (ETH) to transfer with the transaction
769     * @return bool    success or fail
770     *         bytes - the return bytes of the called contract's function.
771     */
772     function genericCall(address _contract, bytes memory _data, uint256 _value)
773     public
774     onlyOwner
775     returns(bool success, bytes memory returnValue) {
776       // solhint-disable-next-line avoid-call-value
777         (success, returnValue) = _contract.call.value(_value)(_data);
778         emit GenericCall(_contract, _data, _value, success);
779     }
780 
781     /**
782     * @dev send ethers from the avatar's wallet
783     * @param _amountInWei amount to send in Wei units
784     * @param _to send the ethers to this address
785     * @return bool which represents success
786     */
787     function sendEther(uint256 _amountInWei, address payable _to) public onlyOwner returns(bool) {
788         _to.transfer(_amountInWei);
789         emit SendEther(_amountInWei, _to);
790         return true;
791     }
792 
793     /**
794     * @dev external token transfer
795     * @param _externalToken the token contract
796     * @param _to the destination address
797     * @param _value the amount of tokens to transfer
798     * @return bool which represents success
799     */
800     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value)
801     public onlyOwner returns(bool)
802     {
803         address(_externalToken).safeTransfer(_to, _value);
804         emit ExternalTokenTransfer(address(_externalToken), _to, _value);
805         return true;
806     }
807 
808     /**
809     * @dev external token transfer from a specific account
810     * @param _externalToken the token contract
811     * @param _from the account to spend token from
812     * @param _to the destination address
813     * @param _value the amount of tokens to transfer
814     * @return bool which represents success
815     */
816     function externalTokenTransferFrom(
817         IERC20 _externalToken,
818         address _from,
819         address _to,
820         uint256 _value
821     )
822     public onlyOwner returns(bool)
823     {
824         address(_externalToken).safeTransferFrom(_from, _to, _value);
825         emit ExternalTokenTransferFrom(address(_externalToken), _from, _to, _value);
826         return true;
827     }
828 
829     /**
830     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
831     *      on behalf of msg.sender.
832     * @param _externalToken the address of the Token Contract
833     * @param _spender address
834     * @param _value the amount of ether (in Wei) which the approval is referring to.
835     * @return bool which represents a success
836     */
837     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value)
838     public onlyOwner returns(bool)
839     {
840         address(_externalToken).safeApprove(_spender, _value);
841         emit ExternalTokenApproval(address(_externalToken), _spender, _value);
842         return true;
843     }
844 
845     /**
846     * @dev metaData emits an event with a string, should contain the hash of some meta data.
847     * @param _metaData a string representing a hash of the meta data
848     * @return bool which represents a success
849     */
850     function metaData(string memory _metaData) public onlyOwner returns(bool) {
851         emit MetaData(_metaData);
852         return true;
853     }
854 
855 
856 }
857 
858 // File: contracts/universalSchemes/UniversalSchemeInterface.sol
859 
860 pragma solidity ^0.5.4;
861 
862 
863 contract UniversalSchemeInterface {
864 
865     function getParametersFromController(Avatar _avatar) internal view returns(bytes32);
866     
867 }
868 
869 // File: contracts/globalConstraints/GlobalConstraintInterface.sol
870 
871 pragma solidity ^0.5.4;
872 
873 
874 contract GlobalConstraintInterface {
875 
876     enum CallPhase { Pre, Post, PreAndPost }
877 
878     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
879     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
880     /**
881      * @dev when return if this globalConstraints is pre, post or both.
882      * @return CallPhase enum indication  Pre, Post or PreAndPost.
883      */
884     function when() public returns(CallPhase);
885 }
886 
887 // File: contracts/controller/ControllerInterface.sol
888 
889 pragma solidity ^0.5.4;
890 
891 
892 
893 /**
894  * @title Controller contract
895  * @dev A controller controls the organizations tokens ,reputation and avatar.
896  * It is subject to a set of schemes and constraints that determine its behavior.
897  * Each scheme has it own parameters and operation permissions.
898  */
899 interface ControllerInterface {
900 
901     /**
902      * @dev Mint `_amount` of reputation that are assigned to `_to` .
903      * @param  _amount amount of reputation to mint
904      * @param _to beneficiary address
905      * @return bool which represents a success
906     */
907     function mintReputation(uint256 _amount, address _to, address _avatar)
908     external
909     returns(bool);
910 
911     /**
912      * @dev Burns `_amount` of reputation from `_from`
913      * @param _amount amount of reputation to burn
914      * @param _from The address that will lose the reputation
915      * @return bool which represents a success
916      */
917     function burnReputation(uint256 _amount, address _from, address _avatar)
918     external
919     returns(bool);
920 
921     /**
922      * @dev mint tokens .
923      * @param  _amount amount of token to mint
924      * @param _beneficiary beneficiary address
925      * @param _avatar address
926      * @return bool which represents a success
927      */
928     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
929     external
930     returns(bool);
931 
932   /**
933    * @dev register or update a scheme
934    * @param _scheme the address of the scheme
935    * @param _paramsHash a hashed configuration of the usage of the scheme
936    * @param _permissions the permissions the new scheme will have
937    * @param _avatar address
938    * @return bool which represents a success
939    */
940     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
941     external
942     returns(bool);
943 
944     /**
945      * @dev unregister a scheme
946      * @param _avatar address
947      * @param _scheme the address of the scheme
948      * @return bool which represents a success
949      */
950     function unregisterScheme(address _scheme, address _avatar)
951     external
952     returns(bool);
953 
954     /**
955      * @dev unregister the caller's scheme
956      * @param _avatar address
957      * @return bool which represents a success
958      */
959     function unregisterSelf(address _avatar) external returns(bool);
960 
961     /**
962      * @dev add or update Global Constraint
963      * @param _globalConstraint the address of the global constraint to be added.
964      * @param _params the constraint parameters hash.
965      * @param _avatar the avatar of the organization
966      * @return bool which represents a success
967      */
968     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
969     external returns(bool);
970 
971     /**
972      * @dev remove Global Constraint
973      * @param _globalConstraint the address of the global constraint to be remove.
974      * @param _avatar the organization avatar.
975      * @return bool which represents a success
976      */
977     function removeGlobalConstraint (address _globalConstraint, address _avatar)
978     external  returns(bool);
979 
980   /**
981     * @dev upgrade the Controller
982     *      The function will trigger an event 'UpgradeController'.
983     * @param  _newController the address of the new controller.
984     * @param _avatar address
985     * @return bool which represents a success
986     */
987     function upgradeController(address _newController, Avatar _avatar)
988     external returns(bool);
989 
990     /**
991     * @dev perform a generic call to an arbitrary contract
992     * @param _contract  the contract's address to call
993     * @param _data ABI-encoded contract call to call `_contract` address.
994     * @param _avatar the controller's avatar address
995     * @param _value value (ETH) to transfer with the transaction
996     * @return bool -success
997     *         bytes  - the return value of the called _contract's function.
998     */
999     function genericCall(address _contract, bytes calldata _data, Avatar _avatar, uint256 _value)
1000     external
1001     returns(bool, bytes memory);
1002 
1003   /**
1004    * @dev send some ether
1005    * @param _amountInWei the amount of ether (in Wei) to send
1006    * @param _to address of the beneficiary
1007    * @param _avatar address
1008    * @return bool which represents a success
1009    */
1010     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
1011     external returns(bool);
1012 
1013     /**
1014     * @dev send some amount of arbitrary ERC20 Tokens
1015     * @param _externalToken the address of the Token Contract
1016     * @param _to address of the beneficiary
1017     * @param _value the amount of ether (in Wei) to send
1018     * @param _avatar address
1019     * @return bool which represents a success
1020     */
1021     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1022     external
1023     returns(bool);
1024 
1025     /**
1026     * @dev transfer token "from" address "to" address
1027     *      One must to approve the amount of tokens which can be spend from the
1028     *      "from" account.This can be done using externalTokenApprove.
1029     * @param _externalToken the address of the Token Contract
1030     * @param _from address of the account to send from
1031     * @param _to address of the beneficiary
1032     * @param _value the amount of ether (in Wei) to send
1033     * @param _avatar address
1034     * @return bool which represents a success
1035     */
1036     function externalTokenTransferFrom(
1037     IERC20 _externalToken,
1038     address _from,
1039     address _to,
1040     uint256 _value,
1041     Avatar _avatar)
1042     external
1043     returns(bool);
1044 
1045     /**
1046     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1047     *      on behalf of msg.sender.
1048     * @param _externalToken the address of the Token Contract
1049     * @param _spender address
1050     * @param _value the amount of ether (in Wei) which the approval is referring to.
1051     * @return bool which represents a success
1052     */
1053     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1054     external
1055     returns(bool);
1056 
1057     /**
1058     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1059     * @param _metaData a string representing a hash of the meta data
1060     * @param _avatar Avatar
1061     * @return bool which represents a success
1062     */
1063     function metaData(string calldata _metaData, Avatar _avatar) external returns(bool);
1064 
1065     /**
1066      * @dev getNativeReputation
1067      * @param _avatar the organization avatar.
1068      * @return organization native reputation
1069      */
1070     function getNativeReputation(address _avatar)
1071     external
1072     view
1073     returns(address);
1074 
1075     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
1076 
1077     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1078 
1079     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1080 
1081     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1082 
1083     /**
1084      * @dev globalConstraintsCount return the global constraint pre and post count
1085      * @return uint256 globalConstraintsPre count.
1086      * @return uint256 globalConstraintsPost count.
1087      */
1088     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1089 
1090     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1091 }
1092 
1093 // File: contracts/universalSchemes/UniversalScheme.sol
1094 
1095 pragma solidity ^0.5.4;
1096 
1097 
1098 
1099 
1100 
1101 contract UniversalScheme is UniversalSchemeInterface {
1102     /**
1103     *  @dev get the parameters for the current scheme from the controller
1104     */
1105     function getParametersFromController(Avatar _avatar) internal view returns(bytes32) {
1106         require(ControllerInterface(_avatar.owner()).isSchemeRegistered(address(this), address(_avatar)),
1107         "scheme is not registered");
1108         return ControllerInterface(_avatar.owner()).getSchemeParameters(address(this), address(_avatar));
1109     }
1110 }
1111 
1112 // File: contracts/universalSchemes/OrganizationRegister.sol
1113 
1114 pragma solidity ^0.5.4;
1115 
1116 
1117 
1118 /**
1119  * @title A universal organization registry.
1120  * @dev Organizations can use this scheme to open a registry.
1121  * Other organizations can then add and promote themselves on this registry.
1122  */
1123 
1124 contract OrganizationRegister is UniversalScheme {
1125     using SafeMath for uint;
1126     using SafeERC20 for address;
1127 
1128     struct Parameters {
1129         uint256 fee;
1130         IERC20 token;
1131         address beneficiary;
1132     }
1133 
1134     // A mapping from the organization (Avatar) address to the saved data of the organization:
1135     mapping(address=>mapping(address=>uint)) public organizationsRegistry;
1136 
1137     mapping(bytes32=>Parameters) public parameters;
1138 
1139     event OrgAdded( address indexed _registry, address indexed _org);
1140     event Promotion( address indexed _registry, address indexed _org, uint256 _amount);
1141 
1142     /**
1143     * @dev Hash the parameters, save if needed and return the hash value
1144     * @param _token -  the token to pay for register or promotion an address.
1145     * @param _fee  - fee needed for register an address.
1146     * @param _beneficiary  - the beneficiary payment address
1147     * @return bytes32 -the parameters hash
1148     */
1149     function setParameters(IERC20 _token, uint256 _fee, address _beneficiary) public returns(bytes32) {
1150         bytes32 paramsHash = getParametersHash(_token, _fee, _beneficiary);
1151         if (parameters[paramsHash].token == ERC20(0)) {
1152             parameters[paramsHash].token = _token;
1153             parameters[paramsHash].fee = _fee;
1154             parameters[paramsHash].beneficiary = _beneficiary;
1155         }
1156         return paramsHash;
1157     }
1158 
1159     /**
1160     * @dev Hash the parameters ,and return the hash value
1161     * @param _token -  the token to pay for register or promotion an address.
1162     * @param _fee  - fee needed for register an address.
1163     * @param _beneficiary  - the beneficiary payment address
1164     * @return bytes32 -the parameters hash
1165     */
1166     function getParametersHash(IERC20 _token, uint256 _fee, address _beneficiary)
1167     public pure returns(bytes32)
1168     {
1169         return (keccak256(abi.encodePacked(_token, _fee, _beneficiary)));
1170     }
1171 
1172     /**
1173      * @dev Adding or promoting an address on the registry.
1174      *      An address(record) to add or promote can be organization address or any contract address.
1175      *      Adding a record is done by paying at least the minimum required by the registry params.
1176      *      Promoting a record is done by paying(adding)amount of token to the registry beneficiary.
1177      * @param _avatar The _avatar of the organization which own the registry.
1178      * @param _record The address to add or promote.
1179      * @param _amount amount to pay for adding or promoting
1180      */
1181     function addOrPromoteAddress(Avatar _avatar, address _record, uint256 _amount)
1182     public
1183     {
1184         Parameters memory params = parameters[getParametersFromController(_avatar)];
1185         // Pay promotion, if the org was not listed the minimum is the fee:
1186         require((organizationsRegistry[address(_avatar)][_record] > 0) || (_amount >= params.fee));
1187 
1188         address(params.token).safeTransferFrom(msg.sender, params.beneficiary, _amount);
1189         if (organizationsRegistry[address(_avatar)][_record] == 0) {
1190             emit OrgAdded(address(_avatar), _record);
1191         }
1192         organizationsRegistry[address(_avatar)][_record] =
1193         organizationsRegistry[address(_avatar)][_record].add(_amount);
1194         emit Promotion(address(_avatar), _record, _amount);
1195     }
1196 }
