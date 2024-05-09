1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.2;
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
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
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
77 // File: contracts/utils/Utils.sol
78 
79 /**
80  * @title Manageable Contract
81  * @author Validity Labs AG <info@validitylabs.org>
82  */
83  
84 pragma solidity 0.5.7;
85 
86 
87 contract Utils {
88     /** MODIFIERS **/
89     modifier onlyValidAddress(address _address) {
90         require(_address != address(0), "invalid address");
91         _;
92     }
93 }
94 
95 // File: contracts/management/Manageable.sol
96 
97 /**
98  * @title Manageable Contract
99  * @author Validity Labs AG <info@validitylabs.org>
100  */
101  
102  pragma solidity 0.5.7;
103 
104 
105 
106 contract Manageable is Ownable, Utils {
107     mapping(address => bool) public isManager;     // manager accounts
108 
109     /** EVENTS **/
110     event ChangedManager(address indexed manager, bool active);
111 
112     /** MODIFIERS **/
113     modifier onlyManager() {
114         require(isManager[msg.sender], "is not manager");
115         _;
116     }
117 
118     /**
119     * @notice constructor sets the deployer as a manager
120     */
121     constructor() public {
122         setManager(msg.sender, true);
123     }
124 
125     /**
126      * @notice enable/disable an account to be a manager
127      * @param _manager address address of the manager to create/alter
128      * @param _active bool flag that shows if the manager account is active
129      */
130     function setManager(address _manager, bool _active) public onlyOwner onlyValidAddress(_manager) {
131         isManager[_manager] = _active;
132         emit ChangedManager(_manager, _active);
133     }
134 
135     /** OVERRIDE 
136     * @notice does not allow owner to give up ownership
137     */
138     function renounceOwnership() public onlyOwner {
139         revert("Cannot renounce ownership");
140     }
141 }
142 
143 // File: contracts/whitelist/GlobalWhitelist.sol
144 
145 /**
146  * @title Global Whitelist Contract
147  * @author Validity Labs AG <info@validitylabs.org>
148  */
149 
150 pragma solidity 0.5.7;
151 
152 
153 
154 
155 contract GlobalWhitelist is Ownable, Manageable {
156     mapping(address => bool) public isWhitelisted; // addresses of who's whitelisted
157     bool public isWhitelisting = true;             // whitelisting enabled by default
158 
159     /** EVENTS **/
160     event ChangedWhitelisting(address indexed registrant, bool whitelisted);
161     event GlobalWhitelistDisabled(address indexed manager);
162     event GlobalWhitelistEnabled(address indexed manager);
163 
164     /**
165     * @dev add an address to the whitelist
166     * @param _address address
167     */
168     function addAddressToWhitelist(address _address) public onlyManager onlyValidAddress(_address) {
169         isWhitelisted[_address] = true;
170         emit ChangedWhitelisting(_address, true);
171     }
172 
173     /**
174     * @dev add addresses to the whitelist
175     * @param _addresses addresses array
176     */
177     function addAddressesToWhitelist(address[] calldata _addresses) external {
178         for (uint256 i = 0; i < _addresses.length; i++) {
179             addAddressToWhitelist(_addresses[i]);
180         }
181     }
182 
183     /**
184     * @dev remove an address from the whitelist
185     * @param _address address
186     */
187     function removeAddressFromWhitelist(address _address) public onlyManager onlyValidAddress(_address) {
188         isWhitelisted[_address] = false;
189         emit ChangedWhitelisting(_address, false);
190     }
191 
192     /**
193     * @dev remove addresses from the whitelist
194     * @param _addresses addresses
195     */
196     function removeAddressesFromWhitelist(address[] calldata _addresses) external {
197         for (uint256 i = 0; i < _addresses.length; i++) {
198             removeAddressFromWhitelist(_addresses[i]);
199         }
200     }
201 
202     /** 
203     * @notice toggle the whitelist by the parent contract; ExporoTokenFactory
204     */
205     function toggleWhitelist() external onlyOwner {
206         isWhitelisting = isWhitelisting ? false : true;
207 
208         if (isWhitelisting) {
209             emit GlobalWhitelistEnabled(msg.sender);
210         } else {
211             emit GlobalWhitelistDisabled(msg.sender);
212         }
213     }
214 }
215 
216 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
217 
218 pragma solidity ^0.5.2;
219 
220 /**
221  * @title ERC20 interface
222  * @dev see https://eips.ethereum.org/EIPS/eip-20
223  */
224 interface IERC20 {
225     function transfer(address to, uint256 value) external returns (bool);
226 
227     function approve(address spender, uint256 value) external returns (bool);
228 
229     function transferFrom(address from, address to, uint256 value) external returns (bool);
230 
231     function totalSupply() external view returns (uint256);
232 
233     function balanceOf(address who) external view returns (uint256);
234 
235     function allowance(address owner, address spender) external view returns (uint256);
236 
237     event Transfer(address indexed from, address indexed to, uint256 value);
238 
239     event Approval(address indexed owner, address indexed spender, uint256 value);
240 }
241 
242 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
243 
244 pragma solidity ^0.5.2;
245 
246 /**
247  * @title SafeMath
248  * @dev Unsigned math operations with safety checks that revert on error
249  */
250 library SafeMath {
251     /**
252      * @dev Multiplies two unsigned integers, reverts on overflow.
253      */
254     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
255         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
256         // benefit is lost if 'b' is also tested.
257         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
258         if (a == 0) {
259             return 0;
260         }
261 
262         uint256 c = a * b;
263         require(c / a == b);
264 
265         return c;
266     }
267 
268     /**
269      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         // Solidity only automatically asserts when dividing by 0
273         require(b > 0);
274         uint256 c = a / b;
275         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
276 
277         return c;
278     }
279 
280     /**
281      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
282      */
283     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
284         require(b <= a);
285         uint256 c = a - b;
286 
287         return c;
288     }
289 
290     /**
291      * @dev Adds two unsigned integers, reverts on overflow.
292      */
293     function add(uint256 a, uint256 b) internal pure returns (uint256) {
294         uint256 c = a + b;
295         require(c >= a);
296 
297         return c;
298     }
299 
300     /**
301      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
302      * reverts when dividing by zero.
303      */
304     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
305         require(b != 0);
306         return a % b;
307     }
308 }
309 
310 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
311 
312 pragma solidity ^0.5.2;
313 
314 
315 
316 /**
317  * @title Standard ERC20 token
318  *
319  * @dev Implementation of the basic standard token.
320  * https://eips.ethereum.org/EIPS/eip-20
321  * Originally based on code by FirstBlood:
322  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
323  *
324  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
325  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
326  * compliant implementations may not do it.
327  */
328 contract ERC20 is IERC20 {
329     using SafeMath for uint256;
330 
331     mapping (address => uint256) private _balances;
332 
333     mapping (address => mapping (address => uint256)) private _allowed;
334 
335     uint256 private _totalSupply;
336 
337     /**
338      * @dev Total number of tokens in existence
339      */
340     function totalSupply() public view returns (uint256) {
341         return _totalSupply;
342     }
343 
344     /**
345      * @dev Gets the balance of the specified address.
346      * @param owner The address to query the balance of.
347      * @return A uint256 representing the amount owned by the passed address.
348      */
349     function balanceOf(address owner) public view returns (uint256) {
350         return _balances[owner];
351     }
352 
353     /**
354      * @dev Function to check the amount of tokens that an owner allowed to a spender.
355      * @param owner address The address which owns the funds.
356      * @param spender address The address which will spend the funds.
357      * @return A uint256 specifying the amount of tokens still available for the spender.
358      */
359     function allowance(address owner, address spender) public view returns (uint256) {
360         return _allowed[owner][spender];
361     }
362 
363     /**
364      * @dev Transfer token to a specified address
365      * @param to The address to transfer to.
366      * @param value The amount to be transferred.
367      */
368     function transfer(address to, uint256 value) public returns (bool) {
369         _transfer(msg.sender, to, value);
370         return true;
371     }
372 
373     /**
374      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
375      * Beware that changing an allowance with this method brings the risk that someone may use both the old
376      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
377      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
378      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
379      * @param spender The address which will spend the funds.
380      * @param value The amount of tokens to be spent.
381      */
382     function approve(address spender, uint256 value) public returns (bool) {
383         _approve(msg.sender, spender, value);
384         return true;
385     }
386 
387     /**
388      * @dev Transfer tokens from one address to another.
389      * Note that while this function emits an Approval event, this is not required as per the specification,
390      * and other compliant implementations may not emit the event.
391      * @param from address The address which you want to send tokens from
392      * @param to address The address which you want to transfer to
393      * @param value uint256 the amount of tokens to be transferred
394      */
395     function transferFrom(address from, address to, uint256 value) public returns (bool) {
396         _transfer(from, to, value);
397         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
398         return true;
399     }
400 
401     /**
402      * @dev Increase the amount of tokens that an owner allowed to a spender.
403      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
404      * allowed value is better to use this function to avoid 2 calls (and wait until
405      * the first transaction is mined)
406      * From MonolithDAO Token.sol
407      * Emits an Approval event.
408      * @param spender The address which will spend the funds.
409      * @param addedValue The amount of tokens to increase the allowance by.
410      */
411     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
412         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
413         return true;
414     }
415 
416     /**
417      * @dev Decrease the amount of tokens that an owner allowed to a spender.
418      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
419      * allowed value is better to use this function to avoid 2 calls (and wait until
420      * the first transaction is mined)
421      * From MonolithDAO Token.sol
422      * Emits an Approval event.
423      * @param spender The address which will spend the funds.
424      * @param subtractedValue The amount of tokens to decrease the allowance by.
425      */
426     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
427         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
428         return true;
429     }
430 
431     /**
432      * @dev Transfer token for a specified addresses
433      * @param from The address to transfer from.
434      * @param to The address to transfer to.
435      * @param value The amount to be transferred.
436      */
437     function _transfer(address from, address to, uint256 value) internal {
438         require(to != address(0));
439 
440         _balances[from] = _balances[from].sub(value);
441         _balances[to] = _balances[to].add(value);
442         emit Transfer(from, to, value);
443     }
444 
445     /**
446      * @dev Internal function that mints an amount of the token and assigns it to
447      * an account. This encapsulates the modification of balances such that the
448      * proper events are emitted.
449      * @param account The account that will receive the created tokens.
450      * @param value The amount that will be created.
451      */
452     function _mint(address account, uint256 value) internal {
453         require(account != address(0));
454 
455         _totalSupply = _totalSupply.add(value);
456         _balances[account] = _balances[account].add(value);
457         emit Transfer(address(0), account, value);
458     }
459 
460     /**
461      * @dev Internal function that burns an amount of the token of a given
462      * account.
463      * @param account The account whose tokens will be burnt.
464      * @param value The amount that will be burnt.
465      */
466     function _burn(address account, uint256 value) internal {
467         require(account != address(0));
468 
469         _totalSupply = _totalSupply.sub(value);
470         _balances[account] = _balances[account].sub(value);
471         emit Transfer(account, address(0), value);
472     }
473 
474     /**
475      * @dev Approve an address to spend another addresses' tokens.
476      * @param owner The address that owns the tokens.
477      * @param spender The address that will spend the tokens.
478      * @param value The number of tokens that can be spent.
479      */
480     function _approve(address owner, address spender, uint256 value) internal {
481         require(spender != address(0));
482         require(owner != address(0));
483 
484         _allowed[owner][spender] = value;
485         emit Approval(owner, spender, value);
486     }
487 
488     /**
489      * @dev Internal function that burns an amount of the token of a given
490      * account, deducting from the sender's allowance for said account. Uses the
491      * internal burn function.
492      * Emits an Approval event (reflecting the reduced allowance).
493      * @param account The account whose tokens will be burnt.
494      * @param value The amount that will be burnt.
495      */
496     function _burnFrom(address account, uint256 value) internal {
497         _burn(account, value);
498         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
499     }
500 }
501 
502 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
503 
504 pragma solidity ^0.5.2;
505 
506 
507 /**
508  * @title ERC20Detailed token
509  * @dev The decimals are only for visualization purposes.
510  * All the operations are done using the smallest and indivisible token unit,
511  * just as on Ethereum all the operations are done in wei.
512  */
513 contract ERC20Detailed is IERC20 {
514     string private _name;
515     string private _symbol;
516     uint8 private _decimals;
517 
518     constructor (string memory name, string memory symbol, uint8 decimals) public {
519         _name = name;
520         _symbol = symbol;
521         _decimals = decimals;
522     }
523 
524     /**
525      * @return the name of the token.
526      */
527     function name() public view returns (string memory) {
528         return _name;
529     }
530 
531     /**
532      * @return the symbol of the token.
533      */
534     function symbol() public view returns (string memory) {
535         return _symbol;
536     }
537 
538     /**
539      * @return the number of decimals of the token.
540      */
541     function decimals() public view returns (uint8) {
542         return _decimals;
543     }
544 }
545 
546 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
547 
548 pragma solidity ^0.5.2;
549 
550 
551 /**
552  * @title Burnable Token
553  * @dev Token that can be irreversibly burned (destroyed).
554  */
555 contract ERC20Burnable is ERC20 {
556     /**
557      * @dev Burns a specific amount of tokens.
558      * @param value The amount of token to be burned.
559      */
560     function burn(uint256 value) public {
561         _burn(msg.sender, value);
562     }
563 
564     /**
565      * @dev Burns a specific amount of tokens from the target address and decrements allowance
566      * @param from address The account whose tokens will be burned.
567      * @param value uint256 The amount of token to be burned.
568      */
569     function burnFrom(address from, uint256 value) public {
570         _burnFrom(from, value);
571     }
572 }
573 
574 // File: openzeppelin-solidity/contracts/access/Roles.sol
575 
576 pragma solidity ^0.5.2;
577 
578 /**
579  * @title Roles
580  * @dev Library for managing addresses assigned to a Role.
581  */
582 library Roles {
583     struct Role {
584         mapping (address => bool) bearer;
585     }
586 
587     /**
588      * @dev give an account access to this role
589      */
590     function add(Role storage role, address account) internal {
591         require(account != address(0));
592         require(!has(role, account));
593 
594         role.bearer[account] = true;
595     }
596 
597     /**
598      * @dev remove an account's access to this role
599      */
600     function remove(Role storage role, address account) internal {
601         require(account != address(0));
602         require(has(role, account));
603 
604         role.bearer[account] = false;
605     }
606 
607     /**
608      * @dev check if an account has this role
609      * @return bool
610      */
611     function has(Role storage role, address account) internal view returns (bool) {
612         require(account != address(0));
613         return role.bearer[account];
614     }
615 }
616 
617 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
618 
619 pragma solidity ^0.5.2;
620 
621 
622 contract PauserRole {
623     using Roles for Roles.Role;
624 
625     event PauserAdded(address indexed account);
626     event PauserRemoved(address indexed account);
627 
628     Roles.Role private _pausers;
629 
630     constructor () internal {
631         _addPauser(msg.sender);
632     }
633 
634     modifier onlyPauser() {
635         require(isPauser(msg.sender));
636         _;
637     }
638 
639     function isPauser(address account) public view returns (bool) {
640         return _pausers.has(account);
641     }
642 
643     function addPauser(address account) public onlyPauser {
644         _addPauser(account);
645     }
646 
647     function renouncePauser() public {
648         _removePauser(msg.sender);
649     }
650 
651     function _addPauser(address account) internal {
652         _pausers.add(account);
653         emit PauserAdded(account);
654     }
655 
656     function _removePauser(address account) internal {
657         _pausers.remove(account);
658         emit PauserRemoved(account);
659     }
660 }
661 
662 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
663 
664 pragma solidity ^0.5.2;
665 
666 
667 /**
668  * @title Pausable
669  * @dev Base contract which allows children to implement an emergency stop mechanism.
670  */
671 contract Pausable is PauserRole {
672     event Paused(address account);
673     event Unpaused(address account);
674 
675     bool private _paused;
676 
677     constructor () internal {
678         _paused = false;
679     }
680 
681     /**
682      * @return true if the contract is paused, false otherwise.
683      */
684     function paused() public view returns (bool) {
685         return _paused;
686     }
687 
688     /**
689      * @dev Modifier to make a function callable only when the contract is not paused.
690      */
691     modifier whenNotPaused() {
692         require(!_paused);
693         _;
694     }
695 
696     /**
697      * @dev Modifier to make a function callable only when the contract is paused.
698      */
699     modifier whenPaused() {
700         require(_paused);
701         _;
702     }
703 
704     /**
705      * @dev called by the owner to pause, triggers stopped state
706      */
707     function pause() public onlyPauser whenNotPaused {
708         _paused = true;
709         emit Paused(msg.sender);
710     }
711 
712     /**
713      * @dev called by the owner to unpause, returns to normal state
714      */
715     function unpause() public onlyPauser whenPaused {
716         _paused = false;
717         emit Unpaused(msg.sender);
718     }
719 }
720 
721 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
722 
723 pragma solidity ^0.5.2;
724 
725 
726 
727 /**
728  * @title Pausable token
729  * @dev ERC20 modified with pausable transfers.
730  */
731 contract ERC20Pausable is ERC20, Pausable {
732     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
733         return super.transfer(to, value);
734     }
735 
736     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
737         return super.transferFrom(from, to, value);
738     }
739 
740     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
741         return super.approve(spender, value);
742     }
743 
744     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
745         return super.increaseAllowance(spender, addedValue);
746     }
747 
748     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
749         return super.decreaseAllowance(spender, subtractedValue);
750     }
751 }
752 
753 // File: openzeppelin-solidity/contracts/math/Math.sol
754 
755 pragma solidity ^0.5.2;
756 
757 /**
758  * @title Math
759  * @dev Assorted math operations
760  */
761 library Math {
762     /**
763      * @dev Returns the largest of two numbers.
764      */
765     function max(uint256 a, uint256 b) internal pure returns (uint256) {
766         return a >= b ? a : b;
767     }
768 
769     /**
770      * @dev Returns the smallest of two numbers.
771      */
772     function min(uint256 a, uint256 b) internal pure returns (uint256) {
773         return a < b ? a : b;
774     }
775 
776     /**
777      * @dev Calculates the average of two numbers. Since these are integers,
778      * averages of an even and odd number cannot be represented, and will be
779      * rounded down.
780      */
781     function average(uint256 a, uint256 b) internal pure returns (uint256) {
782         // (a + b) / 2 can overflow, so we distribute
783         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
784     }
785 }
786 
787 // File: contracts/token/ERC20/library/Snapshots.sol
788 
789 /**
790  * @title Snapshot
791  * @dev Utility library of the Snapshot structure, including getting value.
792  * @author Validity Labs AG <info@validitylabs.org>
793  */
794 pragma solidity 0.5.7;
795 
796 
797 
798 
799 library Snapshots {
800     using Math for uint256;
801     using SafeMath for uint256;
802 
803     /**
804      * @notice This structure stores the historical value associate at a particular blocknumber
805      * @param fromBlock The blocknumber of the creation of the snapshot
806      * @param value The value to be recorded
807      */
808     struct Snapshot {
809         uint256 fromBlock;
810         uint256 value;
811     }
812 
813     struct SnapshotList {
814         Snapshot[] history;
815     }
816 
817     /**
818      * @notice This function creates snapshots for certain value...
819      * @dev To avoid having two Snapshots with the same block.number, we check if the last
820      * existing one is the current block.number, we update the last Snapshot
821      * @param item The SnapshotList to be operated
822      * @param _value The value associated the the item that is going to have a snapshot
823      */
824     function createSnapshot(SnapshotList storage item, uint256 _value) internal {
825         uint256 length = item.history.length;
826         if (length == 0 || (item.history[length.sub(1)].fromBlock < block.number)) {
827             item.history.push(Snapshot(block.number, _value));
828         } else {
829             // When the last existing snapshot is ready to be updated
830             item.history[length.sub(1)].value = _value;
831         }
832     }
833 
834     /**
835      * @notice Find the index of the item in the SnapshotList that contains information
836      * corresponding to the blockNumber. (FindLowerBond of the array)
837      * @dev The binary search logic is inspired by the Arrays.sol from Openzeppelin
838      * @param item The list of Snapshots to be queried
839      * @param blockNumber The block number of the queried moment
840      * @return The index of the Snapshot array
841      */
842     function findBlockIndex(
843         SnapshotList storage item, 
844         uint256 blockNumber
845     ) 
846         internal
847         view 
848         returns (uint256)
849     {
850         // Find lower bound of the array
851         uint256 length = item.history.length;
852 
853         // Return value for extreme cases: If no snapshot exists and/or the last snapshot
854         if (item.history[length.sub(1)].fromBlock <= blockNumber) {
855             return length.sub(1);
856         } else {
857             // Need binary search for the value
858             uint256 low = 0;
859             uint256 high = length.sub(1);
860 
861             while (low < high.sub(1)) {
862                 uint256 mid = Math.average(low, high);
863                 // mid will always be strictly less than high and it rounds down
864                 if (item.history[mid].fromBlock <= blockNumber) {
865                     low = mid;
866                 } else {
867                     high = mid;
868                 }
869             }
870             return low;
871         }   
872     }
873 
874     /**
875      * @notice This function returns the value of the corresponding Snapshot
876      * @param item The list of Snapshots to be queried
877      * @param blockNumber The block number of the queried moment
878      * @return The value of the queried moment
879      */
880     function getValueAt(
881         SnapshotList storage item, 
882         uint256 blockNumber
883     )
884         internal
885         view
886         returns (uint256)
887     {
888         if (item.history.length == 0 || blockNumber < item.history[0].fromBlock) {
889             return 0;
890         } else {
891             uint256 index = findBlockIndex(item, blockNumber);
892             return item.history[index].value;
893         }
894     }
895 }
896 
897 // File: contracts/token/ERC20/IERC20Snapshot.sol
898 
899 /**
900  * @title Interface ERC20 SnapshotToken (abstract contract)
901  * @author Validity Labs AG <info@validitylabs.org>
902  */
903 
904 pragma solidity 0.5.7;  
905 
906 
907 /* solhint-disable no-empty-blocks */
908 interface IERC20Snapshot {   
909     /**
910     * @dev Queries the balance of `_owner` at a specific `_blockNumber`
911     * @param _owner The address from which the balance will be retrieved
912     * @param _blockNumber The block number when the balance is queried
913     * @return The balance at `_blockNumber`
914     */
915     function balanceOfAt(address _owner, uint _blockNumber) external view returns (uint256);
916 
917     /**
918     * @notice Total amount of tokens at a specific `_blockNumber`.
919     * @param _blockNumber The block number when the totalSupply is queried
920     * @return The total amount of tokens at `_blockNumber`
921     */
922     function totalSupplyAt(uint _blockNumber) external view returns(uint256);
923 }
924 
925 // File: contracts/token/ERC20/ERC20Snapshot.sol
926 
927 /**
928  * @title Snapshot Token
929  * @dev This is an ERC20 compatible token that takes snapshots of account balances.
930  * @author Validity Labs AG <info@validitylabs.org>
931  */
932 pragma solidity 0.5.7;  
933 
934 
935 
936 
937 
938 contract ERC20Snapshot is ERC20, IERC20Snapshot {
939     using Snapshots for Snapshots.SnapshotList;
940 
941     mapping(address => Snapshots.SnapshotList) private _snapshotBalances; 
942     Snapshots.SnapshotList private _snapshotTotalSupply;   
943 
944     event AccountSnapshotCreated(address indexed account, uint256 indexed blockNumber, uint256 value);
945     event TotalSupplySnapshotCreated(uint256 indexed blockNumber, uint256 value);
946 
947     /**
948      * @notice Return the historical supply of the token at a certain time
949      * @param blockNumber The block number of the moment when token supply is queried
950      * @return The total supply at "blockNumber"
951      */
952     function totalSupplyAt(uint256 blockNumber) external view returns (uint256) {
953         return _snapshotTotalSupply.getValueAt(blockNumber);
954     }
955 
956     /**
957      * @notice Return the historical balance of an account at a certain time
958      * @param owner The address of the token holder
959      * @param blockNumber The block number of the moment when token supply is queried
960      * @return The balance of the queried token holder at "blockNumber"
961      */
962     function balanceOfAt(address owner, uint256 blockNumber) 
963         external 
964         view 
965         returns (uint256) 
966     {
967         return _snapshotBalances[owner].getValueAt(blockNumber);
968     }
969 
970     /** OVERRIDE
971      * @notice Transfer tokens between two accounts while enforcing the update of Snapshots
972      * @param from The address to transfer from
973      * @param to The address to transfer to
974      * @param value The amount to be transferred
975      */
976     function _transfer(address from, address to, uint256 value) internal {
977         super._transfer(from, to, value);
978 
979         _snapshotBalances[from].createSnapshot(balanceOf(from));
980         _snapshotBalances[to].createSnapshot(balanceOf(to));
981 
982         emit AccountSnapshotCreated(from, block.number, balanceOf(from));
983         emit AccountSnapshotCreated(to, block.number, balanceOf(to));
984     }
985 
986     /** OVERRIDE
987      * @notice Mint tokens to one account while enforcing the update of Snapshots
988      * @param account The address that receives tokens
989      * @param value The amount of tokens to be created
990      */
991     function _mint(address account, uint256 value) internal {
992         super._mint(account, value);
993 
994         _snapshotBalances[account].createSnapshot(balanceOf(account));
995         _snapshotTotalSupply.createSnapshot(totalSupply());
996         
997         emit AccountSnapshotCreated(account, block.number, balanceOf(account));
998         emit TotalSupplySnapshotCreated(block.number, totalSupply());
999     }
1000 
1001     /** OVERRIDE
1002      * @notice Burn tokens of one account
1003      * @param account The address whose tokens will be burnt
1004      * @param value The amount of tokens to be burnt
1005      */
1006     function _burn(address account, uint256 value) internal {
1007         super._burn(account, value);
1008 
1009         _snapshotBalances[account].createSnapshot(balanceOf(account));
1010         _snapshotTotalSupply.createSnapshot(totalSupply());
1011 
1012         emit AccountSnapshotCreated(account, block.number, balanceOf(account));
1013         emit TotalSupplySnapshotCreated(block.number, totalSupply());
1014     }
1015 }
1016 
1017 // File: contracts/token/ERC20/ERC20ForcedTransfer.sol
1018 
1019 /**
1020  * @title ERC20Confiscatable
1021  * @author Validity Labs AG <info@validitylabs.org>
1022  */
1023 
1024 pragma solidity 0.5.7;  
1025 
1026 
1027 
1028 
1029 
1030 contract ERC20ForcedTransfer is Ownable, ERC20 {
1031     /*** EVENTS ***/
1032     event ForcedTransfer(address indexed account, uint256 amount, address indexed receiver);
1033 
1034     /*** FUNCTIONS ***/
1035     /**
1036     * @notice takes funds from _confiscatee and sends them to _receiver
1037     * @param _confiscatee address who's funds are being confiscated
1038     * @param _receiver address who's receiving the funds 
1039     * @param _amount uint256 amount of tokens to force transfer away
1040     */
1041     function forceTransfer(address _confiscatee, address _receiver, uint256 _amount) public onlyOwner {
1042         _transfer(_confiscatee, _receiver, _amount);
1043 
1044         emit ForcedTransfer(_confiscatee, _amount, _receiver);
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
1290 
1291 // File: contracts/exporo/ExporoTokenFactory.sol
1292 
1293 /**
1294  * @title Exporo Token Factory Contract
1295  * @author Validity Labs AG <info@validitylabs.org>
1296  */
1297 
1298 pragma solidity 0.5.7;
1299 
1300 
1301 
1302 
1303 
1304 /* solhint-disable max-line-length */
1305 /* solhint-disable separate-by-one-line-in-contract */
1306 contract ExporoTokenFactory is Manageable {
1307     address public whitelist;
1308 
1309     /*** EVENTS ***/
1310     event NewTokenDeployed(address indexed contractAddress, string name, string symbol, uint8 decimals);
1311    
1312     /*** FUNCTIONS ***/
1313     /**
1314     * @dev constructor
1315     * @param _whitelist address of the whitelist
1316     */
1317     constructor(address _whitelist) 
1318         public 
1319         onlyValidAddress(_whitelist) {
1320             whitelist = _whitelist;
1321         }
1322 
1323     /**
1324     * @dev allows a manager to launch a new token with a new name, symbol, and decimals.
1325     * Defaults to using whitelist stored in this contract. If _whitelist is address(0), else it will use
1326     * _whitelist as the param to pass into the new token's constructor upon deployment 
1327     * @param _name string
1328     * @param _symbol string
1329     * @param _decimals uint8 
1330     * @param _initialSupply uint256 initial total supply cap
1331     * @param _recipient address to recieve the initial token supply
1332     */
1333     function newToken(string calldata _name, string calldata _symbol, uint8 _decimals, uint256 _initialSupply, address _recipient) 
1334         external 
1335         onlyManager 
1336         onlyValidAddress(_recipient)
1337         returns (address) {
1338             require(bytes(_name).length > 0, "name cannot be blank");
1339             require(bytes(_symbol).length > 0, "symbol cannot be blank");
1340             require(_initialSupply > 0, "supply cannot be 0");
1341 
1342             ExporoToken token = new ExporoToken(_name, _symbol, _decimals, whitelist, _initialSupply, _recipient);
1343 
1344             emit NewTokenDeployed(address(token), _name, _symbol, _decimals);
1345             
1346             return address(token);
1347         }
1348     
1349     /** MANGER FUNCTIONS **/
1350     /**
1351     * @notice Prospectus and Quarterly Reports 
1352     * @dev string null check is done at the token level - see ERC20DocumentRegistry
1353     * @param _est address of the targeted EST
1354     * @param _documentUri string IPFS URI to the document
1355     */
1356     function addDocument(address _est, string calldata _documentUri) external onlyValidAddress(_est) onlyManager {
1357         ExporoToken(_est).addDocument(_documentUri);
1358     }
1359 
1360     /**
1361     * @notice enable/disable whitelisting per individual EST
1362     * @param _est address of the targeted EST
1363     */
1364     function toggleESTWhitelist(address _est) public onlyValidAddress(_est) onlyManager {
1365         ExporoToken(_est).toggleWhitelist();
1366     }
1367 
1368     /**
1369     * @notice pause or unpause individual EST
1370     * @param _est address of the targeted EST
1371     */
1372     function togglePauseEST(address _est) public onlyValidAddress(_est) onlyManager {
1373         ExporoToken est = ExporoToken(_est);
1374         bool result = est.paused();
1375         result ? est.unpause() : est.pause();
1376     }
1377 
1378     /**
1379     * @notice force the transfer of tokens from _confiscatee to _receiver
1380     * @param _est address of the targeted EST
1381     * @param _confiscatee address to confiscate tokens from
1382     * @param _receiver address to receive the balance of tokens
1383     * @param _amount uint256 amount to take away from _confiscatee
1384     */
1385     function forceTransferEST(address _est, address _confiscatee, address _receiver, uint256 _amount) 
1386         public 
1387         onlyValidAddress(_est) 
1388         onlyValidAddress(_confiscatee)
1389         onlyValidAddress(_receiver)
1390         onlyManager {
1391             require(_amount > 0, "invalid amount");
1392 
1393             ExporoToken est = ExporoToken(_est);
1394             est.forceTransfer(_confiscatee, _receiver, _amount);
1395         }
1396 
1397     /**
1398     * @notice enable/disable Global Whitelisting
1399     */
1400     function toggleGlobalWhitelist() public onlyManager {
1401         GlobalWhitelist(whitelist).toggleWhitelist();
1402     }
1403 
1404     /**
1405     * @notice configure managers for the Global Whitelisting contract
1406     * @param _manager address
1407     * @param _active address
1408     */
1409     function whitelistSetManager(address _manager, bool _active) public onlyValidAddress(_manager) onlyManager {
1410         GlobalWhitelist(whitelist).setManager(_manager, _active);
1411     }
1412 }