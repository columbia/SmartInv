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
858 // File: contracts/globalConstraints/GlobalConstraintInterface.sol
859 
860 pragma solidity ^0.5.4;
861 
862 
863 contract GlobalConstraintInterface {
864 
865     enum CallPhase { Pre, Post, PreAndPost }
866 
867     function pre( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
868     function post( address _scheme, bytes32 _params, bytes32 _method ) public returns(bool);
869     /**
870      * @dev when return if this globalConstraints is pre, post or both.
871      * @return CallPhase enum indication  Pre, Post or PreAndPost.
872      */
873     function when() public returns(CallPhase);
874 }
875 
876 // File: contracts/controller/ControllerInterface.sol
877 
878 pragma solidity ^0.5.4;
879 
880 
881 
882 /**
883  * @title Controller contract
884  * @dev A controller controls the organizations tokens ,reputation and avatar.
885  * It is subject to a set of schemes and constraints that determine its behavior.
886  * Each scheme has it own parameters and operation permissions.
887  */
888 interface ControllerInterface {
889 
890     /**
891      * @dev Mint `_amount` of reputation that are assigned to `_to` .
892      * @param  _amount amount of reputation to mint
893      * @param _to beneficiary address
894      * @return bool which represents a success
895     */
896     function mintReputation(uint256 _amount, address _to, address _avatar)
897     external
898     returns(bool);
899 
900     /**
901      * @dev Burns `_amount` of reputation from `_from`
902      * @param _amount amount of reputation to burn
903      * @param _from The address that will lose the reputation
904      * @return bool which represents a success
905      */
906     function burnReputation(uint256 _amount, address _from, address _avatar)
907     external
908     returns(bool);
909 
910     /**
911      * @dev mint tokens .
912      * @param  _amount amount of token to mint
913      * @param _beneficiary beneficiary address
914      * @param _avatar address
915      * @return bool which represents a success
916      */
917     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
918     external
919     returns(bool);
920 
921   /**
922    * @dev register or update a scheme
923    * @param _scheme the address of the scheme
924    * @param _paramsHash a hashed configuration of the usage of the scheme
925    * @param _permissions the permissions the new scheme will have
926    * @param _avatar address
927    * @return bool which represents a success
928    */
929     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
930     external
931     returns(bool);
932 
933     /**
934      * @dev unregister a scheme
935      * @param _avatar address
936      * @param _scheme the address of the scheme
937      * @return bool which represents a success
938      */
939     function unregisterScheme(address _scheme, address _avatar)
940     external
941     returns(bool);
942 
943     /**
944      * @dev unregister the caller's scheme
945      * @param _avatar address
946      * @return bool which represents a success
947      */
948     function unregisterSelf(address _avatar) external returns(bool);
949 
950     /**
951      * @dev add or update Global Constraint
952      * @param _globalConstraint the address of the global constraint to be added.
953      * @param _params the constraint parameters hash.
954      * @param _avatar the avatar of the organization
955      * @return bool which represents a success
956      */
957     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
958     external returns(bool);
959 
960     /**
961      * @dev remove Global Constraint
962      * @param _globalConstraint the address of the global constraint to be remove.
963      * @param _avatar the organization avatar.
964      * @return bool which represents a success
965      */
966     function removeGlobalConstraint (address _globalConstraint, address _avatar)
967     external  returns(bool);
968 
969   /**
970     * @dev upgrade the Controller
971     *      The function will trigger an event 'UpgradeController'.
972     * @param  _newController the address of the new controller.
973     * @param _avatar address
974     * @return bool which represents a success
975     */
976     function upgradeController(address _newController, Avatar _avatar)
977     external returns(bool);
978 
979     /**
980     * @dev perform a generic call to an arbitrary contract
981     * @param _contract  the contract's address to call
982     * @param _data ABI-encoded contract call to call `_contract` address.
983     * @param _avatar the controller's avatar address
984     * @param _value value (ETH) to transfer with the transaction
985     * @return bool -success
986     *         bytes  - the return value of the called _contract's function.
987     */
988     function genericCall(address _contract, bytes calldata _data, Avatar _avatar, uint256 _value)
989     external
990     returns(bool, bytes memory);
991 
992   /**
993    * @dev send some ether
994    * @param _amountInWei the amount of ether (in Wei) to send
995    * @param _to address of the beneficiary
996    * @param _avatar address
997    * @return bool which represents a success
998    */
999     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
1000     external returns(bool);
1001 
1002     /**
1003     * @dev send some amount of arbitrary ERC20 Tokens
1004     * @param _externalToken the address of the Token Contract
1005     * @param _to address of the beneficiary
1006     * @param _value the amount of ether (in Wei) to send
1007     * @param _avatar address
1008     * @return bool which represents a success
1009     */
1010     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1011     external
1012     returns(bool);
1013 
1014     /**
1015     * @dev transfer token "from" address "to" address
1016     *      One must to approve the amount of tokens which can be spend from the
1017     *      "from" account.This can be done using externalTokenApprove.
1018     * @param _externalToken the address of the Token Contract
1019     * @param _from address of the account to send from
1020     * @param _to address of the beneficiary
1021     * @param _value the amount of ether (in Wei) to send
1022     * @param _avatar address
1023     * @return bool which represents a success
1024     */
1025     function externalTokenTransferFrom(
1026     IERC20 _externalToken,
1027     address _from,
1028     address _to,
1029     uint256 _value,
1030     Avatar _avatar)
1031     external
1032     returns(bool);
1033 
1034     /**
1035     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1036     *      on behalf of msg.sender.
1037     * @param _externalToken the address of the Token Contract
1038     * @param _spender address
1039     * @param _value the amount of ether (in Wei) which the approval is referring to.
1040     * @return bool which represents a success
1041     */
1042     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1043     external
1044     returns(bool);
1045 
1046     /**
1047     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1048     * @param _metaData a string representing a hash of the meta data
1049     * @param _avatar Avatar
1050     * @return bool which represents a success
1051     */
1052     function metaData(string calldata _metaData, Avatar _avatar) external returns(bool);
1053 
1054     /**
1055      * @dev getNativeReputation
1056      * @param _avatar the organization avatar.
1057      * @return organization native reputation
1058      */
1059     function getNativeReputation(address _avatar)
1060     external
1061     view
1062     returns(address);
1063 
1064     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool);
1065 
1066     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32);
1067 
1068     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32);
1069 
1070     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4);
1071 
1072     /**
1073      * @dev globalConstraintsCount return the global constraint pre and post count
1074      * @return uint256 globalConstraintsPre count.
1075      * @return uint256 globalConstraintsPost count.
1076      */
1077     function globalConstraintsCount(address _avatar) external view returns(uint, uint);
1078 
1079     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool);
1080 }
1081 
1082 // File: contracts/controller/UController.sol
1083 
1084 pragma solidity ^0.5.4;
1085 
1086 
1087 
1088 
1089 
1090 /**
1091  * @title Universal Controller contract
1092  * @dev A universal controller hold organizations and controls their tokens ,reputations
1093  *       and avatar.
1094  * It is subject to a set of schemes and constraints that determine its behavior.
1095  * Each scheme has it own parameters and operation permissions.
1096  */
1097 contract UController is ControllerInterface {
1098 
1099     struct Scheme {
1100         bytes32 paramsHash;  // a hash "configuration" of the scheme
1101         bytes4  permissions; // A bitwise flags of permissions,
1102                             // All 0: Not registered,
1103                             // 1st bit: Flag if the scheme is registered,
1104                             // 2nd bit: Scheme can register other schemes
1105                             // 3th bit: Scheme can add/remove global constraints
1106                             // 4rd bit: Scheme can upgrade the controller
1107                             // 5th bit: Scheme can call delegatecall
1108     }
1109 
1110     struct GlobalConstraint {
1111         address gcAddress;
1112         bytes32 params;
1113     }
1114 
1115     struct GlobalConstraintRegister {
1116         bool isRegistered; //is registered
1117         uint256 index;    //index at globalConstraints
1118     }
1119 
1120     struct Organization {
1121         DAOToken                  nativeToken;
1122         Reputation                nativeReputation;
1123         mapping(address=>Scheme)  schemes;
1124       // globalConstraintsPre that determine pre- conditions for all actions on the controller
1125         GlobalConstraint[] globalConstraintsPre;
1126         // globalConstraintsPost that determine post-conditions for all actions on the controller
1127         GlobalConstraint[] globalConstraintsPost;
1128       // globalConstraintsRegisterPre indicate if a globalConstraints is registered as a Pre global constraint.
1129         mapping(address=>GlobalConstraintRegister) globalConstraintsRegisterPre;
1130       // globalConstraintsRegisterPost indicate if a globalConstraints is registered as a Post global constraint.
1131         mapping(address=>GlobalConstraintRegister) globalConstraintsRegisterPost;
1132     }
1133 
1134     //mapping between organization's avatar address to Organization
1135     mapping(address=>Organization) public organizations;
1136     // newController will point to the new controller after the present controller is upgraded
1137     //  address external newController;
1138     mapping(address=>address) public newControllers;//mapping between avatar address and newController address
1139     //mapping for all reputation system and tokens addresses registered.
1140     mapping(address=>bool) public actors;
1141 
1142     event MintReputation (address indexed _sender, address indexed _to, uint256 _amount, address indexed _avatar);
1143     event BurnReputation (address indexed _sender, address indexed _from, uint256 _amount, address indexed _avatar);
1144     event MintTokens (address indexed _sender, address indexed _beneficiary, uint256 _amount, address indexed _avatar);
1145     event RegisterScheme (address indexed _sender, address indexed _scheme, address indexed _avatar);
1146     event UnregisterScheme (address indexed _sender, address indexed _scheme, address indexed _avatar);
1147     event UpgradeController(address indexed _oldController, address _newController, address _avatar);
1148 
1149     event AddGlobalConstraint(
1150         address indexed _globalConstraint,
1151         bytes32 _params,
1152         GlobalConstraintInterface.CallPhase _when,
1153         address indexed _avatar
1154     );
1155 
1156     event RemoveGlobalConstraint(
1157         address indexed _globalConstraint,
1158         uint256 _index,
1159         bool _isPre,
1160         address indexed _avatar
1161     );
1162 
1163    /**
1164     * @dev newOrganization set up a new organization with default daoCreator.
1165     * @param _avatar the organization avatar
1166     */
1167     function newOrganization(
1168         Avatar _avatar
1169     ) external
1170     {
1171         require(!actors[address(_avatar)]);
1172         actors[address(_avatar)] = true;
1173         require(_avatar.owner() == address(this));
1174         DAOToken nativeToken = _avatar.nativeToken();
1175         Reputation nativeReputation = _avatar.nativeReputation();
1176         require(nativeToken.owner() == address(this));
1177         require(nativeReputation.owner() == address(this));
1178         //To guaranty uniqueness for the reputation systems.
1179         require(!actors[address(nativeReputation)]);
1180         actors[address(nativeReputation)] = true;
1181         //To guaranty uniqueness for the nativeToken.
1182         require(!actors[address(nativeToken)]);
1183         actors[address(nativeToken)] = true;
1184         organizations[address(_avatar)].nativeToken = nativeToken;
1185         organizations[address(_avatar)].nativeReputation = nativeReputation;
1186         organizations[address(_avatar)].schemes[msg.sender] =
1187         Scheme({paramsHash: bytes32(0), permissions: bytes4(0x0000001f)});
1188         emit RegisterScheme(msg.sender, msg.sender, address(_avatar));
1189     }
1190 
1191   // Modifiers:
1192     modifier onlyRegisteredScheme(address avatar) {
1193         require(organizations[avatar].schemes[msg.sender].permissions&bytes4(0x00000001) == bytes4(0x00000001));
1194         _;
1195     }
1196 
1197     modifier onlyRegisteringSchemes(address avatar) {
1198         require(organizations[avatar].schemes[msg.sender].permissions&bytes4(0x00000002) == bytes4(0x00000002));
1199         _;
1200     }
1201 
1202     modifier onlyGlobalConstraintsScheme(address avatar) {
1203         require(organizations[avatar].schemes[msg.sender].permissions&bytes4(0x00000004) == bytes4(0x00000004));
1204         _;
1205     }
1206 
1207     modifier onlyUpgradingScheme(address _avatar) {
1208         require(organizations[_avatar].schemes[msg.sender].permissions&bytes4(0x00000008) == bytes4(0x00000008));
1209         _;
1210     }
1211 
1212     modifier onlyGenericCallScheme(address _avatar) {
1213         require(organizations[_avatar].schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1214         _;
1215     }
1216 
1217     modifier onlyMetaDataScheme(address _avatar) {
1218         require(organizations[_avatar].schemes[msg.sender].permissions&bytes4(0x00000010) == bytes4(0x00000010));
1219         _;
1220     }
1221 
1222     modifier onlySubjectToConstraint(bytes32 func, address _avatar) {
1223         uint256 idx;
1224         GlobalConstraint[] memory globalConstraintsPre = organizations[_avatar].globalConstraintsPre;
1225         GlobalConstraint[] memory globalConstraintsPost = organizations[_avatar].globalConstraintsPost;
1226         for (idx = 0; idx < globalConstraintsPre.length; idx++) {
1227             require(
1228             (GlobalConstraintInterface(globalConstraintsPre[idx].gcAddress))
1229             .pre(msg.sender, globalConstraintsPre[idx].params, func));
1230         }
1231         _;
1232         for (idx = 0; idx < globalConstraintsPost.length; idx++) {
1233             require(
1234             (GlobalConstraintInterface(globalConstraintsPost[idx].gcAddress))
1235             .post(msg.sender, globalConstraintsPost[idx].params, func));
1236         }
1237     }
1238 
1239     /**
1240      * @dev Mint `_amount` of reputation that are assigned to `_to` .
1241      * @param  _amount amount of reputation to mint
1242      * @param _to beneficiary address
1243      * @param _avatar the address of the organization's avatar
1244      * @return bool which represents a success
1245      */
1246     function mintReputation(uint256 _amount, address _to, address _avatar)
1247     external
1248     onlyRegisteredScheme(_avatar)
1249     onlySubjectToConstraint("mintReputation", _avatar)
1250     returns(bool)
1251     {
1252         emit MintReputation(msg.sender, _to, _amount, _avatar);
1253         return organizations[_avatar].nativeReputation.mint(_to, _amount);
1254     }
1255 
1256     /**
1257      * @dev Burns `_amount` of reputation from `_from`
1258      * @param _amount amount of reputation to burn
1259      * @param _from The address that will lose the reputation
1260      * @return bool which represents a success
1261      */
1262     function burnReputation(uint256 _amount, address _from, address _avatar)
1263     external
1264     onlyRegisteredScheme(_avatar)
1265     onlySubjectToConstraint("burnReputation", _avatar)
1266     returns(bool)
1267     {
1268         emit BurnReputation(msg.sender, _from, _amount, _avatar);
1269         return organizations[_avatar].nativeReputation.burn(_from, _amount);
1270     }
1271 
1272     /**
1273      * @dev mint tokens .
1274      * @param  _amount amount of token to mint
1275      * @param _beneficiary beneficiary address
1276      * @param _avatar the organization avatar.
1277      * @return bool which represents a success
1278      */
1279     function mintTokens(uint256 _amount, address _beneficiary, address _avatar)
1280     external
1281     onlyRegisteredScheme(_avatar)
1282     onlySubjectToConstraint("mintTokens", _avatar)
1283     returns(bool)
1284     {
1285         emit MintTokens(msg.sender, _beneficiary, _amount, _avatar);
1286         return organizations[_avatar].nativeToken.mint(_beneficiary, _amount);
1287     }
1288 
1289   /**
1290    * @dev register or update a scheme
1291    * @param _scheme the address of the scheme
1292    * @param _paramsHash a hashed configuration of the usage of the scheme
1293    * @param _permissions the permissions the new scheme will have
1294    * @param _avatar the organization avatar.
1295    * @return bool which represents a success
1296    */
1297     function registerScheme(address _scheme, bytes32 _paramsHash, bytes4 _permissions, address _avatar)
1298     external
1299     onlyRegisteringSchemes(_avatar)
1300     onlySubjectToConstraint("registerScheme", _avatar)
1301     returns(bool)
1302     {
1303         bytes4 schemePermission = organizations[_avatar].schemes[_scheme].permissions;
1304         bytes4 senderPermission = organizations[_avatar].schemes[msg.sender].permissions;
1305     // Check scheme has at least the permissions it is changing, and at least the current permissions:
1306     // Implementation is a bit messy. One must recall logic-circuits ^^
1307 
1308     // produces non-zero if sender does not have all of the perms that are changing between old and new
1309         require(bytes4(0x0000001f)&(_permissions^schemePermission)&(~senderPermission) == bytes4(0));
1310 
1311     // produces non-zero if sender does not have all of the perms in the old scheme
1312         require(bytes4(0x0000001f)&(schemePermission&(~senderPermission)) == bytes4(0));
1313 
1314     // Add or change the scheme:
1315         organizations[_avatar].schemes[_scheme] =
1316         Scheme({paramsHash:_paramsHash, permissions:_permissions|bytes4(0x00000001)});
1317         emit RegisterScheme(msg.sender, _scheme, _avatar);
1318         return true;
1319     }
1320 
1321     /**
1322      * @dev unregister a scheme
1323      * @param _scheme the address of the scheme
1324      * @param _avatar the organization avatar.
1325      * @return bool which represents a success
1326      */
1327     function unregisterScheme(address _scheme, address _avatar)
1328     external
1329     onlyRegisteringSchemes(_avatar)
1330     onlySubjectToConstraint("unregisterScheme", _avatar)
1331     returns(bool)
1332     {
1333         bytes4 schemePermission = organizations[_avatar].schemes[_scheme].permissions;
1334     //check if the scheme is registered
1335         if (schemePermission&bytes4(0x00000001) == bytes4(0)) {
1336             return false;
1337         }
1338     // Check the unregistering scheme has enough permissions:
1339         require(
1340         bytes4(0x0000001f)&(schemePermission&(~organizations[_avatar].schemes[msg.sender].permissions)) == bytes4(0));
1341 
1342     // Unregister:
1343         emit UnregisterScheme(msg.sender, _scheme, _avatar);
1344         delete organizations[_avatar].schemes[_scheme];
1345         return true;
1346     }
1347 
1348     /**
1349      * @dev unregister the caller's scheme
1350      * @param _avatar the organization avatar.
1351      * @return bool which represents a success
1352      */
1353     function unregisterSelf(address _avatar) external returns(bool) {
1354         if (_isSchemeRegistered(msg.sender, _avatar) == false) {
1355             return false;
1356         }
1357         delete organizations[_avatar].schemes[msg.sender];
1358         emit UnregisterScheme(msg.sender, msg.sender, _avatar);
1359         return true;
1360     }
1361 
1362     /**
1363      * @dev add or update Global Constraint
1364      * @param _globalConstraint the address of the global constraint to be added.
1365      * @param _params the constraint parameters hash.
1366      * @param _avatar the avatar of the organization
1367      * @return bool which represents a success
1368      */
1369     function addGlobalConstraint(address _globalConstraint, bytes32 _params, address _avatar)
1370     external onlyGlobalConstraintsScheme(_avatar) returns(bool)
1371     {
1372         Organization storage organization = organizations[_avatar];
1373         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1374         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1375             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1376             if (!organization.globalConstraintsRegisterPre[_globalConstraint].isRegistered) {
1377                 organization.globalConstraintsPre.push(GlobalConstraint(_globalConstraint, _params));
1378                 organization.globalConstraintsRegisterPre[_globalConstraint] =
1379                 GlobalConstraintRegister(true, organization.globalConstraintsPre.length-1);
1380             }else {
1381                 organization
1382                 .globalConstraintsPre[organization.globalConstraintsRegisterPre[_globalConstraint].index]
1383                 .params = _params;
1384             }
1385         }
1386 
1387         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1388             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1389             if (!organization.globalConstraintsRegisterPost[_globalConstraint].isRegistered) {
1390                 organization.globalConstraintsPost.push(GlobalConstraint(_globalConstraint, _params));
1391                 organization.globalConstraintsRegisterPost[_globalConstraint] =
1392                 GlobalConstraintRegister(true, organization.globalConstraintsPost.length-1);
1393             } else {
1394                 organization
1395                 .globalConstraintsPost[organization.globalConstraintsRegisterPost[_globalConstraint].index]
1396                 .params = _params;
1397             }
1398         }
1399         emit AddGlobalConstraint(_globalConstraint, _params, when, _avatar);
1400         return true;
1401     }
1402 
1403     /**
1404      * @dev remove Global Constraint
1405      * @param _globalConstraint the address of the global constraint to be remove.
1406      * @param _avatar the organization avatar.
1407      * @return bool which represents a success
1408      */
1409     function removeGlobalConstraint (address _globalConstraint, address _avatar)
1410     external onlyGlobalConstraintsScheme(_avatar) returns(bool)
1411     {
1412         GlobalConstraintInterface.CallPhase when = GlobalConstraintInterface(_globalConstraint).when();
1413         if ((when == GlobalConstraintInterface.CallPhase.Pre)||
1414             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1415             removeGlobalConstraintPre(_globalConstraint, _avatar);
1416         }
1417         if ((when == GlobalConstraintInterface.CallPhase.Post)||
1418             (when == GlobalConstraintInterface.CallPhase.PreAndPost)) {
1419             removeGlobalConstraintPost(_globalConstraint, _avatar);
1420         }
1421         return true;
1422     }
1423 
1424   /**
1425     * @dev upgrade the Controller
1426     *      The function will trigger an event 'UpgradeController'.
1427     * @param  _newController the address of the new controller.
1428     * @param _avatar the organization avatar.
1429     * @return bool which represents a success
1430     */
1431     function upgradeController(address _newController, Avatar _avatar)
1432     external onlyUpgradingScheme(address(_avatar)) returns(bool)
1433     {
1434         require(newControllers[address(_avatar)] == address(0));   // so the upgrade could be done once for a contract.
1435         require(_newController != address(0));
1436         newControllers[address(_avatar)] = _newController;
1437         _avatar.transferOwnership(_newController);
1438         require(_avatar.owner() == _newController);
1439         if (organizations[address(_avatar)].nativeToken.owner() == address(this)) {
1440             organizations[address(_avatar)].nativeToken.transferOwnership(_newController);
1441             require(organizations[address(_avatar)].nativeToken.owner() == _newController);
1442         }
1443         if (organizations[address(_avatar)].nativeReputation.owner() == address(this)) {
1444             organizations[address(_avatar)].nativeReputation.transferOwnership(_newController);
1445             require(organizations[address(_avatar)].nativeReputation.owner() == _newController);
1446         }
1447         emit UpgradeController(address(this), _newController, address(_avatar));
1448         return true;
1449     }
1450 
1451     /**
1452     * @dev perform a generic call to an arbitrary contract
1453     * @param _contract  the contract's address to call
1454     * @param _data ABI-encoded contract call to call `_contract` address.
1455     * @param _avatar the controller's avatar address
1456     * @param _value value (ETH) to transfer with the transaction
1457     * @return bool -success
1458     *         bytes  - the return value of the called _contract's function.
1459     */
1460     function genericCall(address _contract, bytes calldata _data, Avatar _avatar, uint256 _value)
1461     external
1462     onlyGenericCallScheme(address(_avatar))
1463     onlySubjectToConstraint("genericCall", address(_avatar))
1464     returns (bool, bytes memory)
1465     {
1466         return _avatar.genericCall(_contract, _data, _value);
1467     }
1468 
1469   /**
1470    * @dev send some ether
1471    * @param _amountInWei the amount of ether (in Wei) to send
1472    * @param _to address of the beneficiary
1473    * @param _avatar the organization avatar.
1474    * @return bool which represents a success
1475    */
1476     function sendEther(uint256 _amountInWei, address payable _to, Avatar _avatar)
1477     external
1478     onlyRegisteredScheme(address(_avatar))
1479     onlySubjectToConstraint("sendEther", address(_avatar))
1480     returns(bool)
1481     {
1482         return _avatar.sendEther(_amountInWei, _to);
1483     }
1484 
1485     /**
1486     * @dev send some amount of arbitrary ERC20 Tokens
1487     * @param _externalToken the address of the Token Contract
1488     * @param _to address of the beneficiary
1489     * @param _value the amount of ether (in Wei) to send
1490     * @param _avatar the organization avatar.
1491     * @return bool which represents a success
1492     */
1493     function externalTokenTransfer(IERC20 _externalToken, address _to, uint256 _value, Avatar _avatar)
1494     external
1495     onlyRegisteredScheme(address(_avatar))
1496     onlySubjectToConstraint("externalTokenTransfer", address(_avatar))
1497     returns(bool)
1498     {
1499         return _avatar.externalTokenTransfer(_externalToken, _to, _value);
1500     }
1501 
1502     /**
1503     * @dev transfer token "from" address "to" address
1504     *      One must to approve the amount of tokens which can be spend from the
1505     *      "from" account.This can be done using externalTokenApprove.
1506     * @param _externalToken the address of the Token Contract
1507     * @param _from address of the account to send from
1508     * @param _to address of the beneficiary
1509     * @param _value the amount of ether (in Wei) to send
1510     * @param _avatar the organization avatar.
1511     * @return bool which represents a success
1512     */
1513     function externalTokenTransferFrom(
1514     IERC20 _externalToken,
1515     address _from,
1516     address _to,
1517     uint256 _value,
1518     Avatar _avatar)
1519     external
1520     onlyRegisteredScheme(address(_avatar))
1521     onlySubjectToConstraint("externalTokenTransferFrom", address(_avatar))
1522     returns(bool)
1523     {
1524         return _avatar.externalTokenTransferFrom(_externalToken, _from, _to, _value);
1525     }
1526 
1527     /**
1528     * @dev externalTokenApproval approve the spender address to spend a specified amount of tokens
1529     *      on behalf of msg.sender.
1530     * @param _externalToken the address of the Token Contract
1531     * @param _spender address
1532     * @param _value the amount of ether (in Wei) which the approval is referring to.
1533     * @return bool which represents a success
1534     */
1535     function externalTokenApproval(IERC20 _externalToken, address _spender, uint256 _value, Avatar _avatar)
1536     external
1537     onlyRegisteredScheme(address(_avatar))
1538     onlySubjectToConstraint("externalTokenApproval", address(_avatar))
1539     returns(bool)
1540     {
1541         return _avatar.externalTokenApproval(_externalToken, _spender, _value);
1542     }
1543 
1544     /**
1545     * @dev metaData emits an event with a string, should contain the hash of some meta data.
1546     * @param _metaData a string representing a hash of the meta data
1547     * @param _avatar Avatar
1548     * @return bool which represents a success
1549     */
1550     function metaData(string calldata _metaData, Avatar _avatar)
1551         external
1552         onlyMetaDataScheme(address(_avatar))
1553         returns(bool)
1554         {
1555         return _avatar.metaData(_metaData);
1556     }
1557 
1558     function isSchemeRegistered( address _scheme, address _avatar) external view returns(bool) {
1559         return _isSchemeRegistered(_scheme, _avatar);
1560     }
1561 
1562     function getSchemeParameters(address _scheme, address _avatar) external view returns(bytes32) {
1563         return organizations[_avatar].schemes[_scheme].paramsHash;
1564     }
1565 
1566     function getSchemePermissions(address _scheme, address _avatar) external view returns(bytes4) {
1567         return organizations[_avatar].schemes[_scheme].permissions;
1568     }
1569 
1570     function getGlobalConstraintParameters(address _globalConstraint, address _avatar) external view returns(bytes32) {
1571 
1572         Organization storage organization = organizations[_avatar];
1573 
1574         GlobalConstraintRegister memory register = organization.globalConstraintsRegisterPre[_globalConstraint];
1575 
1576         if (register.isRegistered) {
1577             return organization.globalConstraintsPre[register.index].params;
1578         }
1579 
1580         register = organization.globalConstraintsRegisterPost[_globalConstraint];
1581 
1582         if (register.isRegistered) {
1583             return organization.globalConstraintsPost[register.index].params;
1584         }
1585     }
1586 
1587    /**
1588    * @dev globalConstraintsCount return the global constraint pre and post count
1589    * @return uint256 globalConstraintsPre count.
1590    * @return uint256 globalConstraintsPost count.
1591    */
1592     function globalConstraintsCount(address _avatar) external view returns(uint, uint) {
1593         return (
1594         organizations[_avatar].globalConstraintsPre.length,
1595         organizations[_avatar].globalConstraintsPost.length
1596         );
1597     }
1598 
1599     function isGlobalConstraintRegistered(address _globalConstraint, address _avatar) external view returns(bool) {
1600         return (organizations[_avatar].globalConstraintsRegisterPre[_globalConstraint].isRegistered ||
1601         organizations[_avatar].globalConstraintsRegisterPost[_globalConstraint].isRegistered);
1602     }
1603 
1604     /**
1605      * @dev getNativeReputation
1606      * @param _avatar the organization avatar.
1607      * @return organization native reputation
1608      */
1609     function getNativeReputation(address _avatar) external view returns(address) {
1610         return address(organizations[_avatar].nativeReputation);
1611     }
1612 
1613     /**
1614      * @dev removeGlobalConstraintPre
1615      * @param _globalConstraint the address of the global constraint to be remove.
1616      * @param _avatar the organization avatar.
1617      * @return bool which represents a success
1618      */
1619     function removeGlobalConstraintPre(address _globalConstraint, address _avatar)
1620     private returns(bool)
1621     {
1622         GlobalConstraintRegister memory globalConstraintRegister =
1623         organizations[_avatar].globalConstraintsRegisterPre[_globalConstraint];
1624         GlobalConstraint[] storage globalConstraints = organizations[_avatar].globalConstraintsPre;
1625 
1626         if (globalConstraintRegister.isRegistered) {
1627             if (globalConstraintRegister.index < globalConstraints.length-1) {
1628                 GlobalConstraint memory globalConstraint = globalConstraints[globalConstraints.length-1];
1629                 globalConstraints[globalConstraintRegister.index] = globalConstraint;
1630                 organizations[_avatar].globalConstraintsRegisterPre[globalConstraint.gcAddress].index =
1631                 globalConstraintRegister.index;
1632             }
1633             globalConstraints.length--;
1634             delete organizations[_avatar].globalConstraintsRegisterPre[_globalConstraint];
1635             emit RemoveGlobalConstraint(_globalConstraint, globalConstraintRegister.index, true, _avatar);
1636             return true;
1637         }
1638         return false;
1639     }
1640 
1641     /**
1642      * @dev removeGlobalConstraintPost
1643      * @param _globalConstraint the address of the global constraint to be remove.
1644      * @param _avatar the organization avatar.
1645      * @return bool which represents a success
1646      */
1647     function removeGlobalConstraintPost(address _globalConstraint, address _avatar)
1648     private returns(bool)
1649     {
1650         GlobalConstraintRegister memory globalConstraintRegister =
1651         organizations[_avatar].globalConstraintsRegisterPost[_globalConstraint];
1652         GlobalConstraint[] storage globalConstraints = organizations[_avatar].globalConstraintsPost;
1653 
1654         if (globalConstraintRegister.isRegistered) {
1655             if (globalConstraintRegister.index < globalConstraints.length-1) {
1656                 GlobalConstraint memory globalConstraint = globalConstraints[globalConstraints.length-1];
1657                 globalConstraints[globalConstraintRegister.index] = globalConstraint;
1658                 organizations[_avatar].globalConstraintsRegisterPost[globalConstraint.gcAddress].index =
1659                 globalConstraintRegister.index;
1660             }
1661             globalConstraints.length--;
1662             delete organizations[_avatar].globalConstraintsRegisterPost[_globalConstraint];
1663             emit RemoveGlobalConstraint(_globalConstraint, globalConstraintRegister.index, false, _avatar);
1664             return true;
1665         }
1666         return false;
1667     }
1668 
1669     function _isSchemeRegistered( address _scheme, address _avatar) private view returns(bool) {
1670         return (organizations[_avatar].schemes[_scheme].permissions&bytes4(0x00000001) != bytes4(0));
1671     }
1672 }
