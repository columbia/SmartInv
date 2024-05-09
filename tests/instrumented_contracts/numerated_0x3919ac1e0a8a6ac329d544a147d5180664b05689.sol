1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.2;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.2;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://eips.ethereum.org/EIPS/eip-20
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123      * @dev Total number of tokens in existence
124      */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130      * @dev Gets the balance of the specified address.
131      * @param owner The address to query the balance of.
132      * @return A uint256 representing the amount owned by the passed address.
133      */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149      * @dev Transfer token to a specified address
150      * @param to The address to transfer to.
151      * @param value The amount to be transferred.
152      */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0));
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(account != address(0));
239 
240         _totalSupply = _totalSupply.add(value);
241         _balances[account] = _balances[account].add(value);
242         emit Transfer(address(0), account, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account.
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.sub(value);
255         _balances[account] = _balances[account].sub(value);
256         emit Transfer(account, address(0), value);
257     }
258 
259     /**
260      * @dev Approve an address to spend another addresses' tokens.
261      * @param owner The address that owns the tokens.
262      * @param spender The address that will spend the tokens.
263      * @param value The number of tokens that can be spent.
264      */
265     function _approve(address owner, address spender, uint256 value) internal {
266         require(spender != address(0));
267         require(owner != address(0));
268 
269         _allowed[owner][spender] = value;
270         emit Approval(owner, spender, value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _burn(account, value);
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
288 
289 pragma solidity ^0.5.2;
290 
291 
292 /**
293  * @title ERC20Detailed token
294  * @dev The decimals are only for visualization purposes.
295  * All the operations are done using the smallest and indivisible token unit,
296  * just as on Ethereum all the operations are done in wei.
297  */
298 contract ERC20Detailed is IERC20 {
299     string private _name;
300     string private _symbol;
301     uint8 private _decimals;
302 
303     constructor (string memory name, string memory symbol, uint8 decimals) public {
304         _name = name;
305         _symbol = symbol;
306         _decimals = decimals;
307     }
308 
309     /**
310      * @return the name of the token.
311      */
312     function name() public view returns (string memory) {
313         return _name;
314     }
315 
316     /**
317      * @return the symbol of the token.
318      */
319     function symbol() public view returns (string memory) {
320         return _symbol;
321     }
322 
323     /**
324      * @return the number of decimals of the token.
325      */
326     function decimals() public view returns (uint8) {
327         return _decimals;
328     }
329 }
330 
331 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
332 
333 pragma solidity ^0.5.2;
334 
335 
336 /**
337  * @title Burnable Token
338  * @dev Token that can be irreversibly burned (destroyed).
339  */
340 contract ERC20Burnable is ERC20 {
341     /**
342      * @dev Burns a specific amount of tokens.
343      * @param value The amount of token to be burned.
344      */
345     function burn(uint256 value) public {
346         _burn(msg.sender, value);
347     }
348 
349     /**
350      * @dev Burns a specific amount of tokens from the target address and decrements allowance
351      * @param from address The account whose tokens will be burned.
352      * @param value uint256 The amount of token to be burned.
353      */
354     function burnFrom(address from, uint256 value) public {
355         _burnFrom(from, value);
356     }
357 }
358 
359 // File: openzeppelin-solidity/contracts/access/Roles.sol
360 
361 pragma solidity ^0.5.2;
362 
363 /**
364  * @title Roles
365  * @dev Library for managing addresses assigned to a Role.
366  */
367 library Roles {
368     struct Role {
369         mapping (address => bool) bearer;
370     }
371 
372     /**
373      * @dev give an account access to this role
374      */
375     function add(Role storage role, address account) internal {
376         require(account != address(0));
377         require(!has(role, account));
378 
379         role.bearer[account] = true;
380     }
381 
382     /**
383      * @dev remove an account's access to this role
384      */
385     function remove(Role storage role, address account) internal {
386         require(account != address(0));
387         require(has(role, account));
388 
389         role.bearer[account] = false;
390     }
391 
392     /**
393      * @dev check if an account has this role
394      * @return bool
395      */
396     function has(Role storage role, address account) internal view returns (bool) {
397         require(account != address(0));
398         return role.bearer[account];
399     }
400 }
401 
402 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
403 
404 pragma solidity ^0.5.2;
405 
406 
407 contract PauserRole {
408     using Roles for Roles.Role;
409 
410     event PauserAdded(address indexed account);
411     event PauserRemoved(address indexed account);
412 
413     Roles.Role private _pausers;
414 
415     constructor () internal {
416         _addPauser(msg.sender);
417     }
418 
419     modifier onlyPauser() {
420         require(isPauser(msg.sender));
421         _;
422     }
423 
424     function isPauser(address account) public view returns (bool) {
425         return _pausers.has(account);
426     }
427 
428     function addPauser(address account) public onlyPauser {
429         _addPauser(account);
430     }
431 
432     function renouncePauser() public {
433         _removePauser(msg.sender);
434     }
435 
436     function _addPauser(address account) internal {
437         _pausers.add(account);
438         emit PauserAdded(account);
439     }
440 
441     function _removePauser(address account) internal {
442         _pausers.remove(account);
443         emit PauserRemoved(account);
444     }
445 }
446 
447 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
448 
449 pragma solidity ^0.5.2;
450 
451 
452 /**
453  * @title Pausable
454  * @dev Base contract which allows children to implement an emergency stop mechanism.
455  */
456 contract Pausable is PauserRole {
457     event Paused(address account);
458     event Unpaused(address account);
459 
460     bool private _paused;
461 
462     constructor () internal {
463         _paused = false;
464     }
465 
466     /**
467      * @return true if the contract is paused, false otherwise.
468      */
469     function paused() public view returns (bool) {
470         return _paused;
471     }
472 
473     /**
474      * @dev Modifier to make a function callable only when the contract is not paused.
475      */
476     modifier whenNotPaused() {
477         require(!_paused);
478         _;
479     }
480 
481     /**
482      * @dev Modifier to make a function callable only when the contract is paused.
483      */
484     modifier whenPaused() {
485         require(_paused);
486         _;
487     }
488 
489     /**
490      * @dev called by the owner to pause, triggers stopped state
491      */
492     function pause() public onlyPauser whenNotPaused {
493         _paused = true;
494         emit Paused(msg.sender);
495     }
496 
497     /**
498      * @dev called by the owner to unpause, returns to normal state
499      */
500     function unpause() public onlyPauser whenPaused {
501         _paused = false;
502         emit Unpaused(msg.sender);
503     }
504 }
505 
506 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
507 
508 pragma solidity ^0.5.2;
509 
510 
511 
512 /**
513  * @title Pausable token
514  * @dev ERC20 modified with pausable transfers.
515  */
516 contract ERC20Pausable is ERC20, Pausable {
517     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
518         return super.transfer(to, value);
519     }
520 
521     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
522         return super.transferFrom(from, to, value);
523     }
524 
525     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
526         return super.approve(spender, value);
527     }
528 
529     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
530         return super.increaseAllowance(spender, addedValue);
531     }
532 
533     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
534         return super.decreaseAllowance(spender, subtractedValue);
535     }
536 }
537 
538 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
539 
540 pragma solidity ^0.5.2;
541 
542 /**
543  * @title Ownable
544  * @dev The Ownable contract has an owner address, and provides basic authorization control
545  * functions, this simplifies the implementation of "user permissions".
546  */
547 contract Ownable {
548     address private _owner;
549 
550     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
551 
552     /**
553      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
554      * account.
555      */
556     constructor () internal {
557         _owner = msg.sender;
558         emit OwnershipTransferred(address(0), _owner);
559     }
560 
561     /**
562      * @return the address of the owner.
563      */
564     function owner() public view returns (address) {
565         return _owner;
566     }
567 
568     /**
569      * @dev Throws if called by any account other than the owner.
570      */
571     modifier onlyOwner() {
572         require(isOwner());
573         _;
574     }
575 
576     /**
577      * @return true if `msg.sender` is the owner of the contract.
578      */
579     function isOwner() public view returns (bool) {
580         return msg.sender == _owner;
581     }
582 
583     /**
584      * @dev Allows the current owner to relinquish control of the contract.
585      * It will not be possible to call the functions with the `onlyOwner`
586      * modifier anymore.
587      * @notice Renouncing ownership will leave the contract without an owner,
588      * thereby removing any functionality that is only available to the owner.
589      */
590     function renounceOwnership() public onlyOwner {
591         emit OwnershipTransferred(_owner, address(0));
592         _owner = address(0);
593     }
594 
595     /**
596      * @dev Allows the current owner to transfer control of the contract to a newOwner.
597      * @param newOwner The address to transfer ownership to.
598      */
599     function transferOwnership(address newOwner) public onlyOwner {
600         _transferOwnership(newOwner);
601     }
602 
603     /**
604      * @dev Transfers control of the contract to a newOwner.
605      * @param newOwner The address to transfer ownership to.
606      */
607     function _transferOwnership(address newOwner) internal {
608         require(newOwner != address(0));
609         emit OwnershipTransferred(_owner, newOwner);
610         _owner = newOwner;
611     }
612 }
613 
614 // File: openzeppelin-solidity/contracts/math/Math.sol
615 
616 pragma solidity ^0.5.2;
617 
618 /**
619  * @title Math
620  * @dev Assorted math operations
621  */
622 library Math {
623     /**
624      * @dev Returns the largest of two numbers.
625      */
626     function max(uint256 a, uint256 b) internal pure returns (uint256) {
627         return a >= b ? a : b;
628     }
629 
630     /**
631      * @dev Returns the smallest of two numbers.
632      */
633     function min(uint256 a, uint256 b) internal pure returns (uint256) {
634         return a < b ? a : b;
635     }
636 
637     /**
638      * @dev Calculates the average of two numbers. Since these are integers,
639      * averages of an even and odd number cannot be represented, and will be
640      * rounded down.
641      */
642     function average(uint256 a, uint256 b) internal pure returns (uint256) {
643         // (a + b) / 2 can overflow, so we distribute
644         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
645     }
646 }
647 
648 // File: contracts/token/ERC20/library/Snapshots.sol
649 
650 /**
651  * @title Snapshot
652  * @dev Utility library of the Snapshot structure, including getting value.
653  * @author Validity Labs AG <info@validitylabs.org>
654  */
655 pragma solidity 0.5.7;
656 
657 
658 
659 
660 library Snapshots {
661     using Math for uint256;
662     using SafeMath for uint256;
663 
664     /**
665      * @notice This structure stores the historical value associate at a particular blocknumber
666      * @param fromBlock The blocknumber of the creation of the snapshot
667      * @param value The value to be recorded
668      */
669     struct Snapshot {
670         uint256 fromBlock;
671         uint256 value;
672     }
673 
674     struct SnapshotList {
675         Snapshot[] history;
676     }
677 
678     /**
679      * @notice This function creates snapshots for certain value...
680      * @dev To avoid having two Snapshots with the same block.number, we check if the last
681      * existing one is the current block.number, we update the last Snapshot
682      * @param item The SnapshotList to be operated
683      * @param _value The value associated the the item that is going to have a snapshot
684      */
685     function createSnapshot(SnapshotList storage item, uint256 _value) internal {
686         uint256 length = item.history.length;
687         if (length == 0 || (item.history[length.sub(1)].fromBlock < block.number)) {
688             item.history.push(Snapshot(block.number, _value));
689         } else {
690             // When the last existing snapshot is ready to be updated
691             item.history[length.sub(1)].value = _value;
692         }
693     }
694 
695     /**
696      * @notice Find the index of the item in the SnapshotList that contains information
697      * corresponding to the blockNumber. (FindLowerBond of the array)
698      * @dev The binary search logic is inspired by the Arrays.sol from Openzeppelin
699      * @param item The list of Snapshots to be queried
700      * @param blockNumber The block number of the queried moment
701      * @return The index of the Snapshot array
702      */
703     function findBlockIndex(
704         SnapshotList storage item, 
705         uint256 blockNumber
706     ) 
707         internal
708         view 
709         returns (uint256)
710     {
711         // Find lower bound of the array
712         uint256 length = item.history.length;
713 
714         // Return value for extreme cases: If no snapshot exists and/or the last snapshot
715         if (item.history[length.sub(1)].fromBlock <= blockNumber) {
716             return length.sub(1);
717         } else {
718             // Need binary search for the value
719             uint256 low = 0;
720             uint256 high = length.sub(1);
721 
722             while (low < high.sub(1)) {
723                 uint256 mid = Math.average(low, high);
724                 // mid will always be strictly less than high and it rounds down
725                 if (item.history[mid].fromBlock <= blockNumber) {
726                     low = mid;
727                 } else {
728                     high = mid;
729                 }
730             }
731             return low;
732         }   
733     }
734 
735     /**
736      * @notice This function returns the value of the corresponding Snapshot
737      * @param item The list of Snapshots to be queried
738      * @param blockNumber The block number of the queried moment
739      * @return The value of the queried moment
740      */
741     function getValueAt(
742         SnapshotList storage item, 
743         uint256 blockNumber
744     )
745         internal
746         view
747         returns (uint256)
748     {
749         if (item.history.length == 0 || blockNumber < item.history[0].fromBlock) {
750             return 0;
751         } else {
752             uint256 index = findBlockIndex(item, blockNumber);
753             return item.history[index].value;
754         }
755     }
756 }
757 
758 // File: contracts/token/ERC20/IERC20Snapshot.sol
759 
760 /**
761  * @title Interface ERC20 SnapshotToken (abstract contract)
762  * @author Validity Labs AG <info@validitylabs.org>
763  */
764 
765 pragma solidity 0.5.7;  
766 
767 
768 /* solhint-disable no-empty-blocks */
769 interface IERC20Snapshot {   
770     /**
771     * @dev Queries the balance of `_owner` at a specific `_blockNumber`
772     * @param _owner The address from which the balance will be retrieved
773     * @param _blockNumber The block number when the balance is queried
774     * @return The balance at `_blockNumber`
775     */
776     function balanceOfAt(address _owner, uint _blockNumber) external view returns (uint256);
777 
778     /**
779     * @notice Total amount of tokens at a specific `_blockNumber`.
780     * @param _blockNumber The block number when the totalSupply is queried
781     * @return The total amount of tokens at `_blockNumber`
782     */
783     function totalSupplyAt(uint _blockNumber) external view returns(uint256);
784 }
785 
786 // File: contracts/token/ERC20/ERC20Snapshot.sol
787 
788 /**
789  * @title Snapshot Token
790  * @dev This is an ERC20 compatible token that takes snapshots of account balances.
791  * @author Validity Labs AG <info@validitylabs.org>
792  */
793 pragma solidity 0.5.7;  
794 
795 
796 
797 
798 
799 contract ERC20Snapshot is ERC20, IERC20Snapshot {
800     using Snapshots for Snapshots.SnapshotList;
801 
802     mapping(address => Snapshots.SnapshotList) private _snapshotBalances; 
803     Snapshots.SnapshotList private _snapshotTotalSupply;   
804 
805     event AccountSnapshotCreated(address indexed account, uint256 indexed blockNumber, uint256 value);
806     event TotalSupplySnapshotCreated(uint256 indexed blockNumber, uint256 value);
807 
808     /**
809      * @notice Return the historical supply of the token at a certain time
810      * @param blockNumber The block number of the moment when token supply is queried
811      * @return The total supply at "blockNumber"
812      */
813     function totalSupplyAt(uint256 blockNumber) external view returns (uint256) {
814         return _snapshotTotalSupply.getValueAt(blockNumber);
815     }
816 
817     /**
818      * @notice Return the historical balance of an account at a certain time
819      * @param owner The address of the token holder
820      * @param blockNumber The block number of the moment when token supply is queried
821      * @return The balance of the queried token holder at "blockNumber"
822      */
823     function balanceOfAt(address owner, uint256 blockNumber) 
824         external 
825         view 
826         returns (uint256) 
827     {
828         return _snapshotBalances[owner].getValueAt(blockNumber);
829     }
830 
831     /** OVERRIDE
832      * @notice Transfer tokens between two accounts while enforcing the update of Snapshots
833      * @param from The address to transfer from
834      * @param to The address to transfer to
835      * @param value The amount to be transferred
836      */
837     function _transfer(address from, address to, uint256 value) internal {
838         super._transfer(from, to, value);
839 
840         _snapshotBalances[from].createSnapshot(balanceOf(from));
841         _snapshotBalances[to].createSnapshot(balanceOf(to));
842 
843         emit AccountSnapshotCreated(from, block.number, balanceOf(from));
844         emit AccountSnapshotCreated(to, block.number, balanceOf(to));
845     }
846 
847     /** OVERRIDE
848      * @notice Mint tokens to one account while enforcing the update of Snapshots
849      * @param account The address that receives tokens
850      * @param value The amount of tokens to be created
851      */
852     function _mint(address account, uint256 value) internal {
853         super._mint(account, value);
854 
855         _snapshotBalances[account].createSnapshot(balanceOf(account));
856         _snapshotTotalSupply.createSnapshot(totalSupply());
857         
858         emit AccountSnapshotCreated(account, block.number, balanceOf(account));
859         emit TotalSupplySnapshotCreated(block.number, totalSupply());
860     }
861 
862     /** OVERRIDE
863      * @notice Burn tokens of one account
864      * @param account The address whose tokens will be burnt
865      * @param value The amount of tokens to be burnt
866      */
867     function _burn(address account, uint256 value) internal {
868         super._burn(account, value);
869 
870         _snapshotBalances[account].createSnapshot(balanceOf(account));
871         _snapshotTotalSupply.createSnapshot(totalSupply());
872 
873         emit AccountSnapshotCreated(account, block.number, balanceOf(account));
874         emit TotalSupplySnapshotCreated(block.number, totalSupply());
875     }
876 }
877 
878 // File: contracts/token/ERC20/ERC20ForcedTransfer.sol
879 
880 /**
881  * @title ERC20Confiscatable
882  * @author Validity Labs AG <info@validitylabs.org>
883  */
884 
885 pragma solidity 0.5.7;  
886 
887 
888 
889 
890 
891 contract ERC20ForcedTransfer is Ownable, ERC20 {
892     /*** EVENTS ***/
893     event ForcedTransfer(address indexed account, uint256 amount, address indexed receiver);
894 
895     /*** FUNCTIONS ***/
896     /**
897     * @notice takes funds from _confiscatee and sends them to _receiver
898     * @param _confiscatee address who's funds are being confiscated
899     * @param _receiver address who's receiving the funds 
900     * @param _amount uint256 amount of tokens to force transfer away
901     */
902     function forceTransfer(address _confiscatee, address _receiver, uint256 _amount) public onlyOwner {
903         _transfer(_confiscatee, _receiver, _amount);
904 
905         emit ForcedTransfer(_confiscatee, _amount, _receiver);
906     }
907 }
908 
909 // File: contracts/utils/Utils.sol
910 
911 /**
912  * @title Manageable Contract
913  * @author Validity Labs AG <info@validitylabs.org>
914  */
915  
916 pragma solidity 0.5.7;
917 
918 
919 contract Utils {
920     /** MODIFIERS **/
921     modifier onlyValidAddress(address _address) {
922         require(_address != address(0), "invalid address");
923         _;
924     }
925 }
926 
927 // File: contracts/management/Manageable.sol
928 
929 /**
930  * @title Manageable Contract
931  * @author Validity Labs AG <info@validitylabs.org>
932  */
933  
934  pragma solidity 0.5.7;
935 
936 
937 
938 contract Manageable is Ownable, Utils {
939     mapping(address => bool) public isManager;     // manager accounts
940 
941     /** EVENTS **/
942     event ChangedManager(address indexed manager, bool active);
943 
944     /** MODIFIERS **/
945     modifier onlyManager() {
946         require(isManager[msg.sender], "is not manager");
947         _;
948     }
949 
950     /**
951     * @notice constructor sets the deployer as a manager
952     */
953     constructor() public {
954         setManager(msg.sender, true);
955     }
956 
957     /**
958      * @notice enable/disable an account to be a manager
959      * @param _manager address address of the manager to create/alter
960      * @param _active bool flag that shows if the manager account is active
961      */
962     function setManager(address _manager, bool _active) public onlyOwner onlyValidAddress(_manager) {
963         isManager[_manager] = _active;
964         emit ChangedManager(_manager, _active);
965     }
966 
967     /** OVERRIDE 
968     * @notice does not allow owner to give up ownership
969     */
970     function renounceOwnership() public onlyOwner {
971         revert("Cannot renounce ownership");
972     }
973 }
974 
975 // File: contracts/whitelist/GlobalWhitelist.sol
976 
977 /**
978  * @title Global Whitelist Contract
979  * @author Validity Labs AG <info@validitylabs.org>
980  */
981 
982 pragma solidity 0.5.7;
983 
984 
985 
986 
987 contract GlobalWhitelist is Ownable, Manageable {
988     mapping(address => bool) public isWhitelisted; // addresses of who's whitelisted
989     bool public isWhitelisting = true;             // whitelisting enabled by default
990 
991     /** EVENTS **/
992     event ChangedWhitelisting(address indexed registrant, bool whitelisted);
993     event GlobalWhitelistDisabled(address indexed manager);
994     event GlobalWhitelistEnabled(address indexed manager);
995 
996     /**
997     * @dev add an address to the whitelist
998     * @param _address address
999     */
1000     function addAddressToWhitelist(address _address) public onlyManager onlyValidAddress(_address) {
1001         isWhitelisted[_address] = true;
1002         emit ChangedWhitelisting(_address, true);
1003     }
1004 
1005     /**
1006     * @dev add addresses to the whitelist
1007     * @param _addresses addresses array
1008     */
1009     function addAddressesToWhitelist(address[] calldata _addresses) external {
1010         for (uint256 i = 0; i < _addresses.length; i++) {
1011             addAddressToWhitelist(_addresses[i]);
1012         }
1013     }
1014 
1015     /**
1016     * @dev remove an address from the whitelist
1017     * @param _address address
1018     */
1019     function removeAddressFromWhitelist(address _address) public onlyManager onlyValidAddress(_address) {
1020         isWhitelisted[_address] = false;
1021         emit ChangedWhitelisting(_address, false);
1022     }
1023 
1024     /**
1025     * @dev remove addresses from the whitelist
1026     * @param _addresses addresses
1027     */
1028     function removeAddressesFromWhitelist(address[] calldata _addresses) external {
1029         for (uint256 i = 0; i < _addresses.length; i++) {
1030             removeAddressFromWhitelist(_addresses[i]);
1031         }
1032     }
1033 
1034     /** 
1035     * @notice toggle the whitelist by the parent contract; ExporoTokenFactory
1036     */
1037     function toggleWhitelist() external onlyOwner {
1038         isWhitelisting = isWhitelisting ? false : true;
1039 
1040         if (isWhitelisting) {
1041             emit GlobalWhitelistEnabled(msg.sender);
1042         } else {
1043             emit GlobalWhitelistDisabled(msg.sender);
1044         }
1045     }
1046 }
1047 
1048 // File: contracts/token/ERC20/ERC20Whitelist.sol
1049 
1050 /**
1051  * @title ERC20Whitelist
1052  * @author Validity Labs AG <info@validitylabs.org>
1053  */
1054 
1055 pragma solidity 0.5.7;  
1056 
1057 
1058 
1059 
1060 
1061 contract ERC20Whitelist is Ownable, ERC20 {   
1062     GlobalWhitelist public whitelist;
1063     bool public isWhitelisting = true;  // default to true
1064 
1065     /** EVENTS **/
1066     event ESTWhitelistingEnabled();
1067     event ESTWhitelistingDisabled();
1068 
1069     /*** FUNCTIONS ***/
1070     /**
1071     * @notice disables whitelist per individual EST
1072     * @dev parnent contract, ExporoTokenFactory, is owner
1073     */
1074     function toggleWhitelist() external onlyOwner {
1075         isWhitelisting = isWhitelisting ? false : true;
1076         
1077         if (isWhitelisting) {
1078             emit ESTWhitelistingEnabled();
1079         } else {
1080             emit ESTWhitelistingDisabled();
1081         }
1082     }
1083 
1084     /** OVERRIDE
1085     * @dev transfer token for a specified address
1086     * @param _to The address to transfer to.
1087     * @param _value The amount to be transferred.
1088     * @return bool
1089     */
1090     function transfer(address _to, uint256 _value) public returns (bool) {
1091         if (checkWhitelistEnabled()) {
1092             checkIfWhitelisted(msg.sender);
1093             checkIfWhitelisted(_to);
1094         }
1095         return super.transfer(_to, _value);
1096     }
1097 
1098     /** OVERRIDE
1099     * @dev Transfer tokens from one address to another
1100     * @param _from address The address which you want to send tokens from
1101     * @param _to address The address which you want to transfer to
1102     * @param _value uint256 the amount of tokens to be transferred
1103     * @return bool
1104     */
1105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1106         if (checkWhitelistEnabled()) {
1107             checkIfWhitelisted(_from);
1108             checkIfWhitelisted(_to);
1109         }
1110         return super.transferFrom(_from, _to, _value);
1111     }
1112 
1113     /**
1114     * @dev check if whitelisting is in effect versus local and global bools
1115     * @return bool
1116     */
1117     function checkWhitelistEnabled() public view returns (bool) {
1118         // local whitelist
1119         if (isWhitelisting) {
1120             // global whitelist
1121             if (whitelist.isWhitelisting()) {
1122                 return true;
1123             }
1124         }
1125 
1126         return false;
1127     }
1128 
1129     /*** INTERNAL/PRIVATE ***/
1130     /**
1131     * @dev check if the address has been whitelisted by the Whitelist contract
1132     * @param _account address of the account to check
1133     */
1134     function checkIfWhitelisted(address _account) internal view {
1135         require(whitelist.isWhitelisted(_account), "not whitelisted");
1136     }
1137 }
1138 
1139 // File: contracts/token/ERC20/ERC20DocumentRegistry.sol
1140 
1141 /**
1142  * @title ERC20 Document Registry Contract
1143  * @author Validity Labs AG <info@validitylabs.org>
1144  */
1145  
1146  pragma solidity 0.5.7;
1147 
1148 
1149 
1150 
1151 /**
1152  * @notice Prospectus and Quarterly Reports stored hashes via IPFS
1153  * @dev read IAgreement for details under /contracts/neufund/standards
1154 */
1155 // solhint-disable not-rely-on-time
1156 contract ERC20DocumentRegistry is Ownable {
1157     using SafeMath for uint256;
1158 
1159     struct HashedDocument {
1160         uint256 timestamp;
1161         string documentUri;
1162     }
1163 
1164     // array of all documents 
1165     HashedDocument[] private _documents;
1166 
1167     event LogDocumentedAdded(string documentUri, uint256 indexed documentIndex);
1168 
1169     /**
1170     * @notice adds a document's uri from IPFS to the array
1171     * @param documentUri string
1172     */
1173     function addDocument(string calldata documentUri) external onlyOwner {
1174         require(bytes(documentUri).length > 0, "invalid documentUri");
1175 
1176         HashedDocument memory document = HashedDocument({
1177             timestamp: block.timestamp,
1178             documentUri: documentUri
1179         });
1180 
1181         _documents.push(document);
1182 
1183         emit LogDocumentedAdded(documentUri, _documents.length.sub(1));
1184     }
1185 
1186     /**
1187     * @notice fetch the latest document on the array
1188     * @return uint256, string, uint256 
1189     */
1190     function currentDocument() external view 
1191         returns (uint256 timestamp, string memory documentUri, uint256 index) {
1192             require(_documents.length > 0, "no documents exist");
1193             uint256 last = _documents.length.sub(1);
1194 
1195             HashedDocument storage document = _documents[last];
1196             return (document.timestamp, document.documentUri, last);
1197         }
1198 
1199     /**
1200     * @notice fetches a document's uri
1201     * @param documentIndex uint256
1202     * @return uint256, string, uint256 
1203     */
1204     function getDocument(uint256 documentIndex) external view
1205         returns (uint256 timestamp, string memory documentUri, uint256 index) {
1206             require(documentIndex < _documents.length, "invalid index");
1207 
1208             HashedDocument storage document = _documents[documentIndex];
1209             return (document.timestamp, document.documentUri, documentIndex);
1210         }
1211 
1212     /**
1213     * @notice return the total amount of documents in the array
1214     * @return uint256
1215     */
1216     function documentCount() external view returns (uint256) {
1217         return _documents.length;
1218     }
1219 }
1220 
1221 // File: contracts/token/ERC20/ERC20BatchSend.sol
1222 
1223 /**
1224  * @title Batch Send
1225  * @author Validity Labs AG <info@validitylabs.org>
1226  */
1227 
1228 pragma solidity 0.5.7;
1229 
1230 
1231 
1232 contract ERC20BatchSend is ERC20 {
1233     /**
1234      * @dev Allows the transfer of token amounts to multiple addresses.
1235      * @param beneficiaries Array of addresses that would receive the tokens.
1236      * @param amounts Array of amounts to be transferred per beneficiary.
1237      */
1238     function batchSend(address[] calldata beneficiaries, uint256[] calldata amounts) external {
1239         require(beneficiaries.length == amounts.length, "mismatched array lengths");
1240 
1241         uint256 length = beneficiaries.length;
1242 
1243         for (uint256 i = 0; i < length; i++) {
1244             transfer(beneficiaries[i], amounts[i]);
1245         }
1246     }
1247 }
1248 
1249 // File: contracts/exporo/ExporoToken.sol
1250 
1251 /**
1252  * @title Exporo Token Contract
1253  * @author Validity Labs AG <info@validitylabs.org>
1254  */
1255 
1256 pragma solidity 0.5.7;
1257 
1258 
1259 
1260 
1261 
1262 
1263 
1264 
1265 
1266 
1267 
1268 
1269 contract ExporoToken is Ownable, ERC20Snapshot, ERC20Detailed, ERC20Burnable, ERC20ForcedTransfer, ERC20Whitelist, ERC20BatchSend, ERC20Pausable, ERC20DocumentRegistry {
1270     /*** FUNCTIONS ***/
1271     /**
1272     * @dev constructor
1273     * @param _name string
1274     * @param _symbol string
1275     * @param _decimal uint8
1276     * @param _whitelist address
1277     * @param _initialSupply uint256 initial total supply cap. can be 0
1278     * @param _recipient address to recieve the tokens
1279     */
1280     /* solhint-disable */
1281     constructor(string memory _name, string memory _symbol, uint8 _decimal, address _whitelist, uint256 _initialSupply, address _recipient)
1282         public 
1283         ERC20Detailed(_name, _symbol, _decimal) {
1284             _mint(_recipient, _initialSupply);
1285 
1286             whitelist = GlobalWhitelist(_whitelist);
1287         }
1288     /* solhint-enable */
1289 }