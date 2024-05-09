1 pragma solidity ^0.5.9;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Calculates the average of two numbers. Since these are integers,
24      * averages of an even and odd number cannot be represented, and will be
25      * rounded down.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 
34 /**
35  * @title Roles
36  * @dev Library for managing addresses assigned to a Role.
37  */
38 library Roles {
39     struct Role {
40         mapping (address => bool) bearer;
41     }
42 
43     /**
44      * @dev give an account access to this role
45      */
46     function add(Role storage role, address account) internal {
47         require(account != address(0));
48         require(!has(role, account));
49 
50         role.bearer[account] = true;
51     }
52 
53     /**
54      * @dev remove an account's access to this role
55      */
56     function remove(Role storage role, address account) internal {
57         require(account != address(0));
58         require(has(role, account));
59 
60         role.bearer[account] = false;
61     }
62 
63     /**
64      * @dev check if an account has this role
65      * @return bool
66      */
67     function has(Role storage role, address account) internal view returns (bool) {
68         require(account != address(0));
69         return role.bearer[account];
70     }
71 }
72 
73 
74 /**
75  * @title SafeMath
76  * @dev Unsigned math operations with safety checks that revert on error
77  */
78 library SafeMath {
79     /**
80      * @dev Multiplies two unsigned integers, reverts on overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b);
92 
93         return c;
94     }
95 
96     /**
97      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Solidity only automatically asserts when dividing by 0
101         require(b > 0);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     /**
109      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         require(b <= a);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     /**
119      * @dev Adds two unsigned integers, reverts on overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a);
124 
125         return c;
126     }
127 
128     /**
129      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
130      * reverts when dividing by zero.
131      */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b != 0);
134         return a % b;
135     }
136 }
137 
138 
139 
140 
141 contract MinterRole {
142     using Roles for Roles.Role;
143 
144     event MinterAdded(address indexed account);
145     event MinterRemoved(address indexed account);
146 
147     Roles.Role private _minters;
148 
149     constructor () internal {
150         _addMinter(msg.sender);
151     }
152 
153     modifier onlyMinter() {
154         require(isMinter(msg.sender));
155         _;
156     }
157 
158     function isMinter(address account) public view returns (bool) {
159         return _minters.has(account);
160     }
161 
162     function addMinter(address account) public onlyMinter {
163         _addMinter(account);
164     }
165 
166     function renounceMinter() public {
167         _removeMinter(msg.sender);
168     }
169 
170     function _addMinter(address account) internal {
171         _minters.add(account);
172         emit MinterAdded(account);
173     }
174 
175     function _removeMinter(address account) internal {
176         _minters.remove(account);
177         emit MinterRemoved(account);
178     }
179 }
180 
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://eips.ethereum.org/EIPS/eip-20
185  */
186 interface IERC20 {
187     function transfer(address to, uint256 value) external returns (bool);
188 
189     function approve(address spender, uint256 value) external returns (bool);
190 
191     function transferFrom(address from, address to, uint256 value) external returns (bool);
192 
193     function totalSupply() external view returns (uint256);
194 
195     function balanceOf(address who) external view returns (uint256);
196 
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     event Transfer(address indexed from, address indexed to, uint256 value);
200 
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 
205 contract ApproveAndCallFallBack {
206     function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public;
207 }
208 
209 
210 
211 
212 
213 
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * https://eips.ethereum.org/EIPS/eip-20
220  * Originally based on code by FirstBlood:
221  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  *
223  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
224  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
225  * compliant implementations may not do it.
226  */
227 contract ERC20 is IERC20 {
228     using SafeMath for uint256;
229 
230     mapping (address => uint256) private _balances;
231 
232     mapping (address => mapping (address => uint256)) private _allowed;
233 
234     uint256 private _totalSupply;
235 
236     /**
237      * @dev Total number of tokens in existence
238      */
239     function totalSupply() public view returns (uint256) {
240         return _totalSupply;
241     }
242 
243     /**
244      * @dev Gets the balance of the specified address.
245      * @param owner The address to query the balance of.
246      * @return A uint256 representing the amount owned by the passed address.
247      */
248     function balanceOf(address owner) public view returns (uint256) {
249         return _balances[owner];
250     }
251 
252     /**
253      * @dev Function to check the amount of tokens that an owner allowed to a spender.
254      * @param owner address The address which owns the funds.
255      * @param spender address The address which will spend the funds.
256      * @return A uint256 specifying the amount of tokens still available for the spender.
257      */
258     function allowance(address owner, address spender) public view returns (uint256) {
259         return _allowed[owner][spender];
260     }
261 
262     /**
263      * @dev Transfer token to a specified address
264      * @param to The address to transfer to.
265      * @param value The amount to be transferred.
266      */
267     function transfer(address to, uint256 value) public returns (bool) {
268         _transfer(msg.sender, to, value);
269         return true;
270     }
271 
272     /**
273      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
274      * Beware that changing an allowance with this method brings the risk that someone may use both the old
275      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
276      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
277      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278      * @param spender The address which will spend the funds.
279      * @param value The amount of tokens to be spent.
280      */
281     function approve(address spender, uint256 value) public returns (bool) {
282         _approve(msg.sender, spender, value);
283         return true;
284     }
285 
286     /**
287      * @dev Transfer tokens from one address to another.
288      * Note that while this function emits an Approval event, this is not required as per the specification,
289      * and other compliant implementations may not emit the event.
290      * @param from address The address which you want to send tokens from
291      * @param to address The address which you want to transfer to
292      * @param value uint256 the amount of tokens to be transferred
293      */
294     function transferFrom(address from, address to, uint256 value) public returns (bool) {
295         _transfer(from, to, value);
296         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
297         return true;
298     }
299 
300     /**
301      * @dev Increase the amount of tokens that an owner allowed to a spender.
302      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
303      * allowed value is better to use this function to avoid 2 calls (and wait until
304      * the first transaction is mined)
305      * From MonolithDAO Token.sol
306      * Emits an Approval event.
307      * @param spender The address which will spend the funds.
308      * @param addedValue The amount of tokens to increase the allowance by.
309      */
310     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
311         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
312         return true;
313     }
314 
315     /**
316      * @dev Decrease the amount of tokens that an owner allowed to a spender.
317      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
318      * allowed value is better to use this function to avoid 2 calls (and wait until
319      * the first transaction is mined)
320      * From MonolithDAO Token.sol
321      * Emits an Approval event.
322      * @param spender The address which will spend the funds.
323      * @param subtractedValue The amount of tokens to decrease the allowance by.
324      */
325     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
326         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
327         return true;
328     }
329 
330     /**
331      * @dev Transfer token for a specified addresses
332      * @param from The address to transfer from.
333      * @param to The address to transfer to.
334      * @param value The amount to be transferred.
335      */
336     function _transfer(address from, address to, uint256 value) internal {
337         require(to != address(0));
338 
339         _balances[from] = _balances[from].sub(value);
340         _balances[to] = _balances[to].add(value);
341         emit Transfer(from, to, value);
342     }
343 
344     /**
345      * @dev Internal function that mints an amount of the token and assigns it to
346      * an account. This encapsulates the modification of balances such that the
347      * proper events are emitted.
348      * @param account The account that will receive the created tokens.
349      * @param value The amount that will be created.
350      */
351     function _mint(address account, uint256 value) internal {
352         require(account != address(0));
353 
354         _totalSupply = _totalSupply.add(value);
355         _balances[account] = _balances[account].add(value);
356         emit Transfer(address(0), account, value);
357     }
358 
359     /**
360      * @dev Internal function that burns an amount of the token of a given
361      * account.
362      * @param account The account whose tokens will be burnt.
363      * @param value The amount that will be burnt.
364      */
365     function _burn(address account, uint256 value) internal {
366         require(account != address(0));
367 
368         _totalSupply = _totalSupply.sub(value);
369         _balances[account] = _balances[account].sub(value);
370         emit Transfer(account, address(0), value);
371     }
372 
373     /**
374      * @dev Approve an address to spend another addresses' tokens.
375      * @param owner The address that owns the tokens.
376      * @param spender The address that will spend the tokens.
377      * @param value The number of tokens that can be spent.
378      */
379     function _approve(address owner, address spender, uint256 value) internal {
380         require(spender != address(0));
381         require(owner != address(0));
382 
383         _allowed[owner][spender] = value;
384         emit Approval(owner, spender, value);
385     }
386 
387     /**
388      * @dev Internal function that burns an amount of the token of a given
389      * account, deducting from the sender's allowance for said account. Uses the
390      * internal burn function.
391      * Emits an Approval event (reflecting the reduced allowance).
392      * @param account The account whose tokens will be burnt.
393      * @param value The amount that will be burnt.
394      */
395     function _burnFrom(address account, uint256 value) internal {
396         _burn(account, value);
397         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
398     }
399 }
400  
401 
402 
403 
404 
405 /**
406  * @title ERC20Detailed token
407  * @dev The decimals are only for visualization purposes.
408  * All the operations are done using the smallest and indivisible token unit,
409  * just as on Ethereum all the operations are done in wei.
410  */
411 contract ERC20Detailed is IERC20 {
412     string private _name;
413     string private _symbol;
414     uint8 private _decimals;
415 
416     constructor (string memory name, string memory symbol, uint8 decimals) public {
417         _name = name;
418         _symbol = symbol;
419         _decimals = decimals;
420     }
421 
422     /**
423      * @return the name of the token.
424      */
425     function name() public view returns (string memory) {
426         return _name;
427     }
428 
429     /**
430      * @return the symbol of the token.
431      */
432     function symbol() public view returns (string memory) {
433         return _symbol;
434     }
435 
436     /**
437      * @return the number of decimals of the token.
438      */
439     function decimals() public view returns (uint8) {
440         return _decimals;
441     }
442 }
443  
444 
445 
446 
447 
448 
449 /**
450  * @title ERC20Mintable
451  * @dev ERC20 minting logic
452  */
453 contract ERC20Mintable is ERC20, MinterRole {
454     /**
455      * @dev Function to mint tokens
456      * @param to The address that will receive the minted tokens.
457      * @param value The amount of tokens to mint.
458      * @return A boolean that indicates if the operation was successful.
459      */
460     function mint(address to, uint256 value) public onlyMinter returns (bool) {
461         _mint(to, value);
462         return true;
463     }
464 }
465  
466 
467 
468 
469 
470 /**
471  * @title Capped token
472  * @dev Mintable token with a token cap.
473  */
474 contract ERC20Capped is ERC20Mintable {
475     uint256 private _cap;
476 
477     constructor (uint256 cap) public {
478         require(cap > 0);
479         _cap = cap;
480     }
481 
482     /**
483      * @return the cap for the token minting.
484      */
485     function cap() public view returns (uint256) {
486         return _cap;
487     }
488 
489     function _mint(address account, uint256 value) internal {
490         require(totalSupply().add(value) <= _cap);
491         super._mint(account, value);
492     }
493 }
494  
495 
496 
497 
498 
499 
500 
501 
502 
503 /**
504  * @title Arrays
505  * @dev Utility library of inline array functions
506  */
507 library Arrays {
508     /**
509      * @dev Upper bound search function which is kind of binary search algorithm. It searches sorted
510      * array to find index of the element value. If element is found then returns its index otherwise
511      * it returns index of first element which is greater than searched value. If searched element is
512      * bigger than any array element function then returns first index after last element (i.e. all
513      * values inside the array are smaller than the target). Complexity O(log n).
514      * @param array The array sorted in ascending order.
515      * @param element The element's value to be found.
516      * @return The calculated index value. Returns 0 for empty array.
517      */
518     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
519         if (array.length == 0) {
520             return 0;
521         }
522 
523         uint256 low = 0;
524         uint256 high = array.length;
525 
526         while (low < high) {
527             uint256 mid = Math.average(low, high);
528 
529             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
530             // because Math.average rounds down (it does integer division with truncation).
531             if (array[mid] > element) {
532                 high = mid;
533             } else {
534                 low = mid + 1;
535             }
536         }
537 
538         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
539         if (low > 0 && array[low - 1] == element) {
540             return low - 1;
541         } else {
542             return low;
543         }
544     }
545 }
546 
547 
548 
549 
550 
551 /**
552  * @title Counters
553  * @author Matt Condon (@shrugs)
554  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
555  * of elements in a mapping, issuing ERC721 ids, or counting request ids
556  *
557  * Include with `using Counters for Counters.Counter;`
558  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
559  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
560  * directly accessed.
561  */
562 library Counters {
563     using SafeMath for uint256;
564 
565     struct Counter {
566         // This variable should never be directly accessed by users of the library: interactions must be restricted to
567         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
568         // this feature: see https://github.com/ethereum/solidity/issues/4637
569         uint256 _value; // default: 0
570     }
571 
572     function current(Counter storage counter) internal view returns (uint256) {
573         return counter._value;
574     }
575 
576     function increment(Counter storage counter) internal {
577         counter._value += 1;
578     }
579 
580     function decrement(Counter storage counter) internal {
581         counter._value = counter._value.sub(1);
582     }
583 }
584 
585 
586 
587 /**
588  * @title ERC20 token with snapshots.
589  * @dev Inspired by Jordi Baylina's MiniMeToken to record historical balances:
590  * https://github.com/Giveth/minime/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
591  * When a snapshot is made, the balances and totalSupply at the time of the snapshot are recorded for later
592  * access.
593  *
594  * To make a snapshot, call the `snapshot` function, which will emit the `Snapshot` event and return a snapshot id.
595  * To get the total supply from a snapshot, call the function `totalSupplyAt` with the snapshot id.
596  * To get the balance of an account from a snapshot, call the `balanceOfAt` function with the snapshot id and the
597  * account address.
598  * @author Validity Labs AG <info@validitylabs.org>
599  */
600 contract ERC20Snapshot is ERC20 {
601     using SafeMath for uint256;
602     using Arrays for uint256[];
603     using Counters for Counters.Counter;
604 
605     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
606     // Snapshot struct, but that would impede usage of functions that work on an array.
607     struct Snapshots {
608         uint256[] ids;
609         uint256[] values;
610     }
611 
612     mapping (address => Snapshots) private _accountBalanceSnapshots;
613     Snapshots private _totalSupplySnaphots;
614 
615     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
616     Counters.Counter private _currentSnapshotId;
617 
618     event Snapshot(uint256 id);
619 
620     // Creates a new snapshot id. Balances are only stored in snapshots on demand: unless a snapshot was taken, a
621     // balance change will not be recorded. This means the extra added cost of storing snapshotted balances is only paid
622     // when required, but is also flexible enough that it allows for e.g. daily snapshots.
623     function snapshot() public returns (uint256) {
624         _currentSnapshotId.increment();
625 
626         uint256 currentId = _currentSnapshotId.current();
627         emit Snapshot(currentId);
628         return currentId;
629     }
630 
631     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
632         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
633 
634         return snapshotted ? value : balanceOf(account);
635     }
636 
637     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
638         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnaphots);
639 
640         return snapshotted ? value : totalSupply();
641     }
642 
643     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
644     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
645     // The same is true for the total supply and _mint and _burn.
646     function _transfer(address from, address to, uint256 value) internal {
647         _updateAccountSnapshot(from);
648         _updateAccountSnapshot(to);
649 
650         super._transfer(from, to, value);
651     }
652 
653     function _mint(address account, uint256 value) internal {
654         _updateAccountSnapshot(account);
655         _updateTotalSupplySnapshot();
656 
657         super._mint(account, value);
658     }
659 
660     function _burn(address account, uint256 value) internal {
661         _updateAccountSnapshot(account);
662         _updateTotalSupplySnapshot();
663 
664         super._burn(account, value);
665     }
666 
667     // When a valid snapshot is queried, there are three possibilities:
668     //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
669     //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
670     //  to this id is the current one.
671     //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
672     //  requested id, and its value is the one to return.
673     //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
674     //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
675     //  larger than the requested one.
676     //
677     // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
678     // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
679     // exactly this.
680     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
681         private view returns (bool, uint256)
682     {
683         require(snapshotId > 0);
684         require(snapshotId <= _currentSnapshotId.current());
685 
686         uint256 index = snapshots.ids.findUpperBound(snapshotId);
687 
688         if (index == snapshots.ids.length) {
689             return (false, 0);
690         } else {
691             return (true, snapshots.values[index]);
692         }
693     }
694 
695     function _updateAccountSnapshot(address account) private {
696         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
697     }
698 
699     function _updateTotalSupplySnapshot() private {
700         _updateSnapshot(_totalSupplySnaphots, totalSupply());
701     }
702 
703     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
704         uint256 currentId = _currentSnapshotId.current();
705         if (_lastSnapshotId(snapshots.ids) < currentId) {
706             snapshots.ids.push(currentId);
707             snapshots.values.push(currentValue);
708         }
709     }
710 
711     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
712         if (ids.length == 0) {
713             return 0;
714         } else {
715             return ids[ids.length - 1];
716         }
717     }
718 }
719 
720 
721 
722 /**
723  * @title Ownable
724  * @dev The Ownable contract has an owner address, and provides basic authorization control
725  * functions, this simplifies the implementation of "user permissions".
726  */
727 contract Ownable {
728     address private _owner;
729 
730     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
731 
732     /**
733      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
734      * account.
735      */
736     constructor () internal {
737         _owner = msg.sender;
738         emit OwnershipTransferred(address(0), _owner);
739     }
740 
741     /**
742      * @return the address of the owner.
743      */
744     function owner() public view returns (address) {
745         return _owner;
746     }
747 
748     /**
749      * @dev Throws if called by any account other than the owner.
750      */
751     modifier onlyOwner() {
752         require(isOwner());
753         _;
754     }
755 
756     /**
757      * @return true if `msg.sender` is the owner of the contract.
758      */
759     function isOwner() public view returns (bool) {
760         return msg.sender == _owner;
761     }
762 
763     /**
764      * @dev Allows the current owner to relinquish control of the contract.
765      * It will not be possible to call the functions with the `onlyOwner`
766      * modifier anymore.
767      * @notice Renouncing ownership will leave the contract without an owner,
768      * thereby removing any functionality that is only available to the owner.
769      */
770     function renounceOwnership() public onlyOwner {
771         emit OwnershipTransferred(_owner, address(0));
772         _owner = address(0);
773     }
774 
775     /**
776      * @dev Allows the current owner to transfer control of the contract to a newOwner.
777      * @param newOwner The address to transfer ownership to.
778      */
779     function transferOwnership(address newOwner) public onlyOwner {
780         _transferOwnership(newOwner);
781     }
782 
783     /**
784      * @dev Transfers control of the contract to a newOwner.
785      * @param newOwner The address to transfer ownership to.
786      */
787     function _transferOwnership(address newOwner) internal {
788         require(newOwner != address(0));
789         emit OwnershipTransferred(_owner, newOwner);
790         _owner = newOwner;
791     }
792 }
793  
794 
795 
796 contract PictosisToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Capped, ERC20Snapshot, Ownable {
797     uint transfersEnabledDate;
798 
799     modifier onlyTransfersEnabled() {
800         require(block.timestamp >= transfersEnabledDate, "Transfers disabled");
801         _;
802     }
803 
804     constructor(uint _enableTransfersDate, uint _cap)
805         ERC20Capped(_cap)
806         ERC20Mintable()
807         ERC20Detailed("Pictosis Token", "PICTO", 18)
808         ERC20()
809         Ownable()
810         public
811     {
812         transfersEnabledDate = _enableTransfersDate;
813     }
814 
815     function areTransfersEnabled() public view returns(bool) {
816         return block.timestamp >= transfersEnabledDate;
817     }
818 
819     function transfer(
820             address to,
821             uint256 value
822         )
823         public
824         onlyTransfersEnabled
825         returns (bool)
826     {
827         return super.transfer(to, value);
828     }
829 
830     function transferFrom(
831             address from,
832             address to,
833             uint256 value
834         )
835         public
836         onlyTransfersEnabled
837         returns (bool)
838     {
839         return super.transferFrom(from, to, value);
840     }
841 
842     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
843     ///  its behalf, and then a function is triggered in the contract that is
844     ///  being approved, `_spender`. This allows users to use their tokens to
845     ///  interact with contracts in one function call instead of two
846     /// @param _spender The address of the contract able to transfer the tokens
847     /// @param _amount The amount of tokens to be approved for transfer
848     /// @return True if the function call was successful
849     function approveAndCall(
850             address _spender,
851             uint256 _amount,
852             bytes memory _extraData
853         )
854         public
855         returns (bool success)
856     {
857         require(approve(_spender, _amount), "Couldn't approve spender");
858 
859         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _amount, address(this), _extraData);
860 
861         return true;
862     }
863 }