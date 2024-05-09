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
80  * @title Utilities Contract
81  * @author Validity Labs AG <info@validitylabs.org>
82  */
83  
84 pragma solidity ^0.5.7;
85 
86 
87 contract Utils {
88     /** MODIFIERS **/
89     /**
90      * @notice Check if the address is not zero
91      */
92     modifier onlyValidAddress(address _address) {
93         require(_address != address(0), "Invalid address");
94         _;
95     }
96 
97     /**
98      * @notice Check if the address is not the sender's address
99     */
100     modifier isSenderNot(address _address) {
101         require(_address != msg.sender, "Address is the same as the sender");
102         _;
103     }
104 
105     /**
106      * @notice Check if the address is the sender's address
107     */
108     modifier isSender(address _address) {
109         require(_address == msg.sender, "Address is different from the sender");
110         _;
111     }
112 
113     /**
114      * @notice Controle if a boolean attribute (false by default) was updated to true.
115      * @dev This attribute is designed specifically for recording an action.
116      * @param criterion The boolean attribute that records if an action has taken place
117      */
118     modifier onlyOnce(bool criterion) {
119         require(criterion == false, "Already been set");
120         _;
121         criterion = true;
122     }
123 }
124 
125 // File: contracts/utils/Managed.sol
126 
127 pragma solidity ^0.5.7;
128 
129 
130 
131 
132 contract Managed is Utils, Ownable {
133     // managers can be set and altered by owner, multiple manager accounts are possible
134     mapping(address => bool) public isManager;
135     
136     /** EVENTS **/
137     event ChangedManager(address indexed manager, bool active);
138 
139     /*** MODIFIERS ***/
140     modifier onlyManager() {
141         require(isManager[msg.sender], "not manager");
142         _;
143     }
144     
145     /**
146      * @dev Set / alter manager / whitelister "account". This can be done from owner only
147      * @param manager address address of the manager to create/alter
148      * @param active bool flag that shows if the manager account is active
149      */
150     function setManager(address manager, bool active) public onlyOwner onlyValidAddress(manager) {
151         isManager[manager] = active;
152         emit ChangedManager(manager, active);
153     }
154 }
155 
156 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
157 
158 pragma solidity ^0.5.2;
159 
160 /**
161  * @title ERC20 interface
162  * @dev see https://eips.ethereum.org/EIPS/eip-20
163  */
164 interface IERC20 {
165     function transfer(address to, uint256 value) external returns (bool);
166 
167     function approve(address spender, uint256 value) external returns (bool);
168 
169     function transferFrom(address from, address to, uint256 value) external returns (bool);
170 
171     function totalSupply() external view returns (uint256);
172 
173     function balanceOf(address who) external view returns (uint256);
174 
175     function allowance(address owner, address spender) external view returns (uint256);
176 
177     event Transfer(address indexed from, address indexed to, uint256 value);
178 
179     event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
183 
184 pragma solidity ^0.5.2;
185 
186 
187 /**
188  * @title ERC20Detailed token
189  * @dev The decimals are only for visualization purposes.
190  * All the operations are done using the smallest and indivisible token unit,
191  * just as on Ethereum all the operations are done in wei.
192  */
193 contract ERC20Detailed is IERC20 {
194     string private _name;
195     string private _symbol;
196     uint8 private _decimals;
197 
198     constructor (string memory name, string memory symbol, uint8 decimals) public {
199         _name = name;
200         _symbol = symbol;
201         _decimals = decimals;
202     }
203 
204     /**
205      * @return the name of the token.
206      */
207     function name() public view returns (string memory) {
208         return _name;
209     }
210 
211     /**
212      * @return the symbol of the token.
213      */
214     function symbol() public view returns (string memory) {
215         return _symbol;
216     }
217 
218     /**
219      * @return the number of decimals of the token.
220      */
221     function decimals() public view returns (uint8) {
222         return _decimals;
223     }
224 }
225 
226 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
227 
228 pragma solidity ^0.5.2;
229 
230 /**
231  * @title SafeMath
232  * @dev Unsigned math operations with safety checks that revert on error
233  */
234 library SafeMath {
235     /**
236      * @dev Multiplies two unsigned integers, reverts on overflow.
237      */
238     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
239         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
240         // benefit is lost if 'b' is also tested.
241         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
242         if (a == 0) {
243             return 0;
244         }
245 
246         uint256 c = a * b;
247         require(c / a == b);
248 
249         return c;
250     }
251 
252     /**
253      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
254      */
255     function div(uint256 a, uint256 b) internal pure returns (uint256) {
256         // Solidity only automatically asserts when dividing by 0
257         require(b > 0);
258         uint256 c = a / b;
259         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
260 
261         return c;
262     }
263 
264     /**
265      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
266      */
267     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
268         require(b <= a);
269         uint256 c = a - b;
270 
271         return c;
272     }
273 
274     /**
275      * @dev Adds two unsigned integers, reverts on overflow.
276      */
277     function add(uint256 a, uint256 b) internal pure returns (uint256) {
278         uint256 c = a + b;
279         require(c >= a);
280 
281         return c;
282     }
283 
284     /**
285      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
286      * reverts when dividing by zero.
287      */
288     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
289         require(b != 0);
290         return a % b;
291     }
292 }
293 
294 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
295 
296 pragma solidity ^0.5.2;
297 
298 
299 
300 /**
301  * @title Standard ERC20 token
302  *
303  * @dev Implementation of the basic standard token.
304  * https://eips.ethereum.org/EIPS/eip-20
305  * Originally based on code by FirstBlood:
306  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
307  *
308  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
309  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
310  * compliant implementations may not do it.
311  */
312 contract ERC20 is IERC20 {
313     using SafeMath for uint256;
314 
315     mapping (address => uint256) private _balances;
316 
317     mapping (address => mapping (address => uint256)) private _allowed;
318 
319     uint256 private _totalSupply;
320 
321     /**
322      * @dev Total number of tokens in existence
323      */
324     function totalSupply() public view returns (uint256) {
325         return _totalSupply;
326     }
327 
328     /**
329      * @dev Gets the balance of the specified address.
330      * @param owner The address to query the balance of.
331      * @return A uint256 representing the amount owned by the passed address.
332      */
333     function balanceOf(address owner) public view returns (uint256) {
334         return _balances[owner];
335     }
336 
337     /**
338      * @dev Function to check the amount of tokens that an owner allowed to a spender.
339      * @param owner address The address which owns the funds.
340      * @param spender address The address which will spend the funds.
341      * @return A uint256 specifying the amount of tokens still available for the spender.
342      */
343     function allowance(address owner, address spender) public view returns (uint256) {
344         return _allowed[owner][spender];
345     }
346 
347     /**
348      * @dev Transfer token to a specified address
349      * @param to The address to transfer to.
350      * @param value The amount to be transferred.
351      */
352     function transfer(address to, uint256 value) public returns (bool) {
353         _transfer(msg.sender, to, value);
354         return true;
355     }
356 
357     /**
358      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
359      * Beware that changing an allowance with this method brings the risk that someone may use both the old
360      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
361      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
362      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
363      * @param spender The address which will spend the funds.
364      * @param value The amount of tokens to be spent.
365      */
366     function approve(address spender, uint256 value) public returns (bool) {
367         _approve(msg.sender, spender, value);
368         return true;
369     }
370 
371     /**
372      * @dev Transfer tokens from one address to another.
373      * Note that while this function emits an Approval event, this is not required as per the specification,
374      * and other compliant implementations may not emit the event.
375      * @param from address The address which you want to send tokens from
376      * @param to address The address which you want to transfer to
377      * @param value uint256 the amount of tokens to be transferred
378      */
379     function transferFrom(address from, address to, uint256 value) public returns (bool) {
380         _transfer(from, to, value);
381         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
382         return true;
383     }
384 
385     /**
386      * @dev Increase the amount of tokens that an owner allowed to a spender.
387      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
388      * allowed value is better to use this function to avoid 2 calls (and wait until
389      * the first transaction is mined)
390      * From MonolithDAO Token.sol
391      * Emits an Approval event.
392      * @param spender The address which will spend the funds.
393      * @param addedValue The amount of tokens to increase the allowance by.
394      */
395     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
396         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
397         return true;
398     }
399 
400     /**
401      * @dev Decrease the amount of tokens that an owner allowed to a spender.
402      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
403      * allowed value is better to use this function to avoid 2 calls (and wait until
404      * the first transaction is mined)
405      * From MonolithDAO Token.sol
406      * Emits an Approval event.
407      * @param spender The address which will spend the funds.
408      * @param subtractedValue The amount of tokens to decrease the allowance by.
409      */
410     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
411         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
412         return true;
413     }
414 
415     /**
416      * @dev Transfer token for a specified addresses
417      * @param from The address to transfer from.
418      * @param to The address to transfer to.
419      * @param value The amount to be transferred.
420      */
421     function _transfer(address from, address to, uint256 value) internal {
422         require(to != address(0));
423 
424         _balances[from] = _balances[from].sub(value);
425         _balances[to] = _balances[to].add(value);
426         emit Transfer(from, to, value);
427     }
428 
429     /**
430      * @dev Internal function that mints an amount of the token and assigns it to
431      * an account. This encapsulates the modification of balances such that the
432      * proper events are emitted.
433      * @param account The account that will receive the created tokens.
434      * @param value The amount that will be created.
435      */
436     function _mint(address account, uint256 value) internal {
437         require(account != address(0));
438 
439         _totalSupply = _totalSupply.add(value);
440         _balances[account] = _balances[account].add(value);
441         emit Transfer(address(0), account, value);
442     }
443 
444     /**
445      * @dev Internal function that burns an amount of the token of a given
446      * account.
447      * @param account The account whose tokens will be burnt.
448      * @param value The amount that will be burnt.
449      */
450     function _burn(address account, uint256 value) internal {
451         require(account != address(0));
452 
453         _totalSupply = _totalSupply.sub(value);
454         _balances[account] = _balances[account].sub(value);
455         emit Transfer(account, address(0), value);
456     }
457 
458     /**
459      * @dev Approve an address to spend another addresses' tokens.
460      * @param owner The address that owns the tokens.
461      * @param spender The address that will spend the tokens.
462      * @param value The number of tokens that can be spent.
463      */
464     function _approve(address owner, address spender, uint256 value) internal {
465         require(spender != address(0));
466         require(owner != address(0));
467 
468         _allowed[owner][spender] = value;
469         emit Approval(owner, spender, value);
470     }
471 
472     /**
473      * @dev Internal function that burns an amount of the token of a given
474      * account, deducting from the sender's allowance for said account. Uses the
475      * internal burn function.
476      * Emits an Approval event (reflecting the reduced allowance).
477      * @param account The account whose tokens will be burnt.
478      * @param value The amount that will be burnt.
479      */
480     function _burnFrom(address account, uint256 value) internal {
481         _burn(account, value);
482         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
483     }
484 }
485 
486 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
487 
488 pragma solidity ^0.5.2;
489 
490 
491 /**
492  * @title Burnable Token
493  * @dev Token that can be irreversibly burned (destroyed).
494  */
495 contract ERC20Burnable is ERC20 {
496     /**
497      * @dev Burns a specific amount of tokens.
498      * @param value The amount of token to be burned.
499      */
500     function burn(uint256 value) public {
501         _burn(msg.sender, value);
502     }
503 
504     /**
505      * @dev Burns a specific amount of tokens from the target address and decrements allowance
506      * @param from address The account whose tokens will be burned.
507      * @param value uint256 The amount of token to be burned.
508      */
509     function burnFrom(address from, uint256 value) public {
510         _burnFrom(from, value);
511     }
512 }
513 
514 // File: openzeppelin-solidity/contracts/access/Roles.sol
515 
516 pragma solidity ^0.5.2;
517 
518 /**
519  * @title Roles
520  * @dev Library for managing addresses assigned to a Role.
521  */
522 library Roles {
523     struct Role {
524         mapping (address => bool) bearer;
525     }
526 
527     /**
528      * @dev give an account access to this role
529      */
530     function add(Role storage role, address account) internal {
531         require(account != address(0));
532         require(!has(role, account));
533 
534         role.bearer[account] = true;
535     }
536 
537     /**
538      * @dev remove an account's access to this role
539      */
540     function remove(Role storage role, address account) internal {
541         require(account != address(0));
542         require(has(role, account));
543 
544         role.bearer[account] = false;
545     }
546 
547     /**
548      * @dev check if an account has this role
549      * @return bool
550      */
551     function has(Role storage role, address account) internal view returns (bool) {
552         require(account != address(0));
553         return role.bearer[account];
554     }
555 }
556 
557 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
558 
559 pragma solidity ^0.5.2;
560 
561 
562 contract PauserRole {
563     using Roles for Roles.Role;
564 
565     event PauserAdded(address indexed account);
566     event PauserRemoved(address indexed account);
567 
568     Roles.Role private _pausers;
569 
570     constructor () internal {
571         _addPauser(msg.sender);
572     }
573 
574     modifier onlyPauser() {
575         require(isPauser(msg.sender));
576         _;
577     }
578 
579     function isPauser(address account) public view returns (bool) {
580         return _pausers.has(account);
581     }
582 
583     function addPauser(address account) public onlyPauser {
584         _addPauser(account);
585     }
586 
587     function renouncePauser() public {
588         _removePauser(msg.sender);
589     }
590 
591     function _addPauser(address account) internal {
592         _pausers.add(account);
593         emit PauserAdded(account);
594     }
595 
596     function _removePauser(address account) internal {
597         _pausers.remove(account);
598         emit PauserRemoved(account);
599     }
600 }
601 
602 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
603 
604 pragma solidity ^0.5.2;
605 
606 
607 /**
608  * @title Pausable
609  * @dev Base contract which allows children to implement an emergency stop mechanism.
610  */
611 contract Pausable is PauserRole {
612     event Paused(address account);
613     event Unpaused(address account);
614 
615     bool private _paused;
616 
617     constructor () internal {
618         _paused = false;
619     }
620 
621     /**
622      * @return true if the contract is paused, false otherwise.
623      */
624     function paused() public view returns (bool) {
625         return _paused;
626     }
627 
628     /**
629      * @dev Modifier to make a function callable only when the contract is not paused.
630      */
631     modifier whenNotPaused() {
632         require(!_paused);
633         _;
634     }
635 
636     /**
637      * @dev Modifier to make a function callable only when the contract is paused.
638      */
639     modifier whenPaused() {
640         require(_paused);
641         _;
642     }
643 
644     /**
645      * @dev called by the owner to pause, triggers stopped state
646      */
647     function pause() public onlyPauser whenNotPaused {
648         _paused = true;
649         emit Paused(msg.sender);
650     }
651 
652     /**
653      * @dev called by the owner to unpause, returns to normal state
654      */
655     function unpause() public onlyPauser whenPaused {
656         _paused = false;
657         emit Unpaused(msg.sender);
658     }
659 }
660 
661 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
662 
663 pragma solidity ^0.5.2;
664 
665 
666 
667 /**
668  * @title Pausable token
669  * @dev ERC20 modified with pausable transfers.
670  */
671 contract ERC20Pausable is ERC20, Pausable {
672     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
673         return super.transfer(to, value);
674     }
675 
676     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
677         return super.transferFrom(from, to, value);
678     }
679 
680     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
681         return super.approve(spender, value);
682     }
683 
684     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
685         return super.increaseAllowance(spender, addedValue);
686     }
687 
688     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
689         return super.decreaseAllowance(spender, subtractedValue);
690     }
691 }
692 
693 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
694 
695 pragma solidity ^0.5.2;
696 
697 
698 contract MinterRole {
699     using Roles for Roles.Role;
700 
701     event MinterAdded(address indexed account);
702     event MinterRemoved(address indexed account);
703 
704     Roles.Role private _minters;
705 
706     constructor () internal {
707         _addMinter(msg.sender);
708     }
709 
710     modifier onlyMinter() {
711         require(isMinter(msg.sender));
712         _;
713     }
714 
715     function isMinter(address account) public view returns (bool) {
716         return _minters.has(account);
717     }
718 
719     function addMinter(address account) public onlyMinter {
720         _addMinter(account);
721     }
722 
723     function renounceMinter() public {
724         _removeMinter(msg.sender);
725     }
726 
727     function _addMinter(address account) internal {
728         _minters.add(account);
729         emit MinterAdded(account);
730     }
731 
732     function _removeMinter(address account) internal {
733         _minters.remove(account);
734         emit MinterRemoved(account);
735     }
736 }
737 
738 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
739 
740 pragma solidity ^0.5.2;
741 
742 
743 
744 /**
745  * @title ERC20Mintable
746  * @dev ERC20 minting logic
747  */
748 contract ERC20Mintable is ERC20, MinterRole {
749     /**
750      * @dev Function to mint tokens
751      * @param to The address that will receive the minted tokens.
752      * @param value The amount of tokens to mint.
753      * @return A boolean that indicates if the operation was successful.
754      */
755     function mint(address to, uint256 value) public onlyMinter returns (bool) {
756         _mint(to, value);
757         return true;
758     }
759 }
760 
761 // File: openzeppelin-solidity/contracts/utils/Address.sol
762 
763 pragma solidity ^0.5.2;
764 
765 /**
766  * Utility library of inline functions on addresses
767  */
768 library Address {
769     /**
770      * Returns whether the target address is a contract
771      * @dev This function will return false if invoked during the constructor of a contract,
772      * as the code is not actually created until after the constructor finishes.
773      * @param account address of the account to check
774      * @return whether the target address is a contract
775      */
776     function isContract(address account) internal view returns (bool) {
777         uint256 size;
778         // XXX Currently there is no better way to check if there is a contract in an address
779         // than to check the size of the code at that address.
780         // See https://ethereum.stackexchange.com/a/14016/36603
781         // for more details about how this works.
782         // TODO Check this again before the Serenity release, because all addresses will be
783         // contracts then.
784         // solhint-disable-next-line no-inline-assembly
785         assembly { size := extcodesize(account) }
786         return size > 0;
787     }
788 }
789 
790 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
791 
792 pragma solidity ^0.5.2;
793 
794 
795 
796 
797 /**
798  * @title SafeERC20
799  * @dev Wrappers around ERC20 operations that throw on failure (when the token
800  * contract returns false). Tokens that return no value (and instead revert or
801  * throw on failure) are also supported, non-reverting calls are assumed to be
802  * successful.
803  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
804  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
805  */
806 library SafeERC20 {
807     using SafeMath for uint256;
808     using Address for address;
809 
810     function safeTransfer(IERC20 token, address to, uint256 value) internal {
811         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
812     }
813 
814     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
815         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
816     }
817 
818     function safeApprove(IERC20 token, address spender, uint256 value) internal {
819         // safeApprove should only be called when setting an initial allowance,
820         // or when resetting it to zero. To increase and decrease it, use
821         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
822         require((value == 0) || (token.allowance(address(this), spender) == 0));
823         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
824     }
825 
826     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
827         uint256 newAllowance = token.allowance(address(this), spender).add(value);
828         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
829     }
830 
831     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
832         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
833         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
834     }
835 
836     /**
837      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
838      * on the return value: the return value is optional (but if data is returned, it must equal true).
839      * @param token The token targeted by the call.
840      * @param data The call data (encoded using abi.encode or one of its variants).
841      */
842     function callOptionalReturn(IERC20 token, bytes memory data) private {
843         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
844         // we're implementing it ourselves.
845 
846         // A Solidity high level call has three parts:
847         //  1. The target address is checked to verify it contains contract code
848         //  2. The call itself is made, and success asserted
849         //  3. The return value is decoded, which in turn checks the size of the returned data.
850 
851         require(address(token).isContract());
852 
853         // solhint-disable-next-line avoid-low-level-calls
854         (bool success, bytes memory returndata) = address(token).call(data);
855         require(success);
856 
857         if (returndata.length > 0) { // Return data is optional
858             require(abi.decode(returndata, (bool)));
859         }
860     }
861 }
862 
863 // File: contracts/utils/Reclaimable.sol
864 
865 /**
866  * @title Reclaimable
867  * @dev This contract gives owner right to recover any ERC20 tokens accidentally sent to 
868  * the token contract. The recovered token will be sent to the owner of token. 
869  * @author Validity Labs AG <info@validitylabs.org>
870  */
871 // solhint-disable-next-line compiler-fixed, compiler-gt-0_5
872 pragma solidity ^0.5.7;
873 
874 
875 
876 
877 
878 contract Reclaimable is Ownable {
879     using SafeERC20 for IERC20;
880 
881     /**
882      * @notice Let the owner to retrieve other tokens accidentally sent to this contract.
883      * @dev This function is suitable when no token of any kind shall be stored under
884      * the address of the inherited contract.
885      * @param tokenToBeRecovered address of the token to be recovered.
886      */
887     function reclaimToken(IERC20 tokenToBeRecovered) external onlyOwner {
888         uint256 balance = tokenToBeRecovered.balanceOf(address(this));
889         tokenToBeRecovered.safeTransfer(msg.sender, balance);
890     }
891 }
892 
893 // File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
894 
895 pragma solidity ^0.5.2;
896 
897 
898 /**
899  * @title WhitelistAdminRole
900  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
901  */
902 contract WhitelistAdminRole {
903     using Roles for Roles.Role;
904 
905     event WhitelistAdminAdded(address indexed account);
906     event WhitelistAdminRemoved(address indexed account);
907 
908     Roles.Role private _whitelistAdmins;
909 
910     constructor () internal {
911         _addWhitelistAdmin(msg.sender);
912     }
913 
914     modifier onlyWhitelistAdmin() {
915         require(isWhitelistAdmin(msg.sender));
916         _;
917     }
918 
919     function isWhitelistAdmin(address account) public view returns (bool) {
920         return _whitelistAdmins.has(account);
921     }
922 
923     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
924         _addWhitelistAdmin(account);
925     }
926 
927     function renounceWhitelistAdmin() public {
928         _removeWhitelistAdmin(msg.sender);
929     }
930 
931     function _addWhitelistAdmin(address account) internal {
932         _whitelistAdmins.add(account);
933         emit WhitelistAdminAdded(account);
934     }
935 
936     function _removeWhitelistAdmin(address account) internal {
937         _whitelistAdmins.remove(account);
938         emit WhitelistAdminRemoved(account);
939     }
940 }
941 
942 // File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
943 
944 pragma solidity ^0.5.2;
945 
946 
947 
948 /**
949  * @title WhitelistedRole
950  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
951  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
952  * it), and not Whitelisteds themselves.
953  */
954 contract WhitelistedRole is WhitelistAdminRole {
955     using Roles for Roles.Role;
956 
957     event WhitelistedAdded(address indexed account);
958     event WhitelistedRemoved(address indexed account);
959 
960     Roles.Role private _whitelisteds;
961 
962     modifier onlyWhitelisted() {
963         require(isWhitelisted(msg.sender));
964         _;
965     }
966 
967     function isWhitelisted(address account) public view returns (bool) {
968         return _whitelisteds.has(account);
969     }
970 
971     function addWhitelisted(address account) public onlyWhitelistAdmin {
972         _addWhitelisted(account);
973     }
974 
975     function removeWhitelisted(address account) public onlyWhitelistAdmin {
976         _removeWhitelisted(account);
977     }
978 
979     function renounceWhitelisted() public {
980         _removeWhitelisted(msg.sender);
981     }
982 
983     function _addWhitelisted(address account) internal {
984         _whitelisteds.add(account);
985         emit WhitelistedAdded(account);
986     }
987 
988     function _removeWhitelisted(address account) internal {
989         _whitelisteds.remove(account);
990         emit WhitelistedRemoved(account);
991     }
992 }
993 
994 // File: openzeppelin-solidity/contracts/math/Math.sol
995 
996 pragma solidity ^0.5.2;
997 
998 /**
999  * @title Math
1000  * @dev Assorted math operations
1001  */
1002 library Math {
1003     /**
1004      * @dev Returns the largest of two numbers.
1005      */
1006     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1007         return a >= b ? a : b;
1008     }
1009 
1010     /**
1011      * @dev Returns the smallest of two numbers.
1012      */
1013     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1014         return a < b ? a : b;
1015     }
1016 
1017     /**
1018      * @dev Calculates the average of two numbers. Since these are integers,
1019      * averages of an even and odd number cannot be represented, and will be
1020      * rounded down.
1021      */
1022     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1023         // (a + b) / 2 can overflow, so we distribute
1024         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1025     }
1026 }
1027 
1028 // File: contracts/token/ERC20/library/Snapshots.sol
1029 
1030 /**
1031  * @title Snapshot
1032  * @dev Utility library of the Snapshot structure, including getting value.
1033  * @author Validity Labs AG <info@validitylabs.org>
1034  */
1035 pragma solidity ^0.5.7;
1036 
1037 
1038 
1039 
1040 library Snapshots {
1041     using Math for uint256;
1042     using SafeMath for uint256;
1043 
1044     /**
1045      * @notice This structure stores the historical value associate at a particular timestamp
1046      * @param timestamp The timestamp of the creation of the snapshot
1047      * @param value The value to be recorded
1048      */
1049     struct Snapshot {
1050         uint256 timestamp;
1051         uint256 value;
1052     }
1053 
1054     struct SnapshotList {
1055         Snapshot[] history;
1056     }
1057 
1058     /** TODO: within 1 block: transfer w/ snapshot, then dividend distrubtion, transfer w/ snapshot
1059      *
1060      * @notice This function creates snapshots for certain value...
1061      * @dev To avoid having two Snapshots with the same block.timestamp, we check if the last
1062      * existing one is the current block.timestamp, we update the last Snapshot
1063      * @param item The SnapshotList to be operated
1064      * @param _value The value associated the the item that is going to have a snapshot
1065      */
1066     function createSnapshot(SnapshotList storage item, uint256 _value) internal {
1067         uint256 length = item.history.length;
1068         if (length == 0 || (item.history[length.sub(1)].timestamp < block.timestamp)) {
1069             item.history.push(Snapshot(block.timestamp, _value));
1070         } else {
1071             // When the last existing snapshot is ready to be updated
1072             item.history[length.sub(1)].value = _value;
1073         }
1074     }
1075 
1076     /**
1077      * @notice Find the index of the item in the SnapshotList that contains information
1078      * corresponding to the timestamp. (FindLowerBond of the array)
1079      * @dev The binary search logic is inspired by the Arrays.sol from Openzeppelin
1080      * @param item The list of Snapshots to be queried
1081      * @param timestamp The timestamp of the queried moment
1082      * @return The index of the Snapshot array
1083      */
1084     function findBlockIndex(
1085         SnapshotList storage item, 
1086         uint256 timestamp
1087     ) 
1088         internal
1089         view 
1090         returns (uint256)
1091     {
1092         // Find lower bound of the array
1093         uint256 length = item.history.length;
1094 
1095         // Return value for extreme cases: If no snapshot exists and/or the last snapshot
1096         if (item.history[length.sub(1)].timestamp <= timestamp) {
1097             return length.sub(1);
1098         } else {
1099             // Need binary search for the value
1100             uint256 low = 0;
1101             uint256 high = length.sub(1);
1102 
1103             while (low < high.sub(1)) {
1104                 uint256 mid = Math.average(low, high);
1105                 // mid will always be strictly less than high and it rounds down
1106                 if (item.history[mid].timestamp <= timestamp) {
1107                     low = mid;
1108                 } else {
1109                     high = mid;
1110                 }
1111             }
1112             return low;
1113         }   
1114     }
1115 
1116     /**
1117      * @notice This function returns the value of the corresponding Snapshot
1118      * @param item The list of Snapshots to be queried
1119      * @param timestamp The timestamp of the queried moment
1120      * @return The value of the queried moment
1121      */
1122     function getValueAt(
1123         SnapshotList storage item, 
1124         uint256 timestamp
1125     )
1126         internal
1127         view
1128         returns (uint256)
1129     {
1130         if (item.history.length == 0 || timestamp < item.history[0].timestamp) {
1131             return 0;
1132         } else {
1133             uint256 index = findBlockIndex(item, timestamp);
1134             return item.history[index].value;
1135         }
1136     }
1137 }
1138 
1139 // File: contracts/token/ERC20/ERC20Snapshot.sol
1140 
1141 /**
1142  * @title ERC20 Snapshot Token
1143  * @dev This is an ERC20 compatible token that takes snapshots of account balances.
1144  * @author Validity Labs AG <info@validitylabs.org>
1145  */
1146 pragma solidity ^0.5.7;  
1147 
1148 
1149 
1150 
1151 contract ERC20Snapshot is ERC20 {
1152     using Snapshots for Snapshots.SnapshotList;
1153 
1154     mapping(address => Snapshots.SnapshotList) private _snapshotBalances; 
1155     Snapshots.SnapshotList private _snapshotTotalSupply;   
1156 
1157     event CreatedAccountSnapshot(address indexed account, uint256 indexed timestamp, uint256 value);
1158     event CreatedTotalSupplySnapshot(uint256 indexed timestamp, uint256 value);
1159 
1160     /**
1161      * @notice Return the historical supply of the token at a certain time
1162      * @param timestamp The block number of the moment when token supply is queried
1163      * @return The total supply at "timestamp"
1164      */
1165     function totalSupplyAt(uint256 timestamp) public view returns (uint256) {
1166         return _snapshotTotalSupply.getValueAt(timestamp);
1167     }
1168 
1169     /**
1170      * @notice Return the historical balance of an account at a certain time
1171      * @param owner The address of the token holder
1172      * @param timestamp The block number of the moment when token supply is queried
1173      * @return The balance of the queried token holder at "timestamp"
1174      */
1175     function balanceOfAt(address owner, uint256 timestamp) 
1176         public 
1177         view 
1178         returns (uint256) {
1179             return _snapshotBalances[owner].getValueAt(timestamp);
1180         }
1181 
1182     /** OVERRIDE
1183      * @notice Transfer tokens between two accounts while enforcing the update of Snapshots
1184      * @param from The address to transfer from
1185      * @param to The address to transfer to
1186      * @param value The amount to be transferred
1187      */
1188     function _transfer(address from, address to, uint256 value) internal {
1189         super._transfer(from, to, value); // ERC20 transfer
1190 
1191         _createAccountSnapshot(from, balanceOf(from));
1192         _createAccountSnapshot(to, balanceOf(to));
1193     }
1194 
1195     /** OVERRIDE
1196      * @notice Mint tokens to one account while enforcing the update of Snapshots
1197      * @param account The address that receives tokens
1198      * @param value The amount of tokens to be created
1199      */
1200     function _mint(address account, uint256 value) internal {
1201         super._mint(account, value);
1202         
1203         _createAccountSnapshot(account, balanceOf(account));
1204         _createTotalSupplySnapshot(account, totalSupplyAt(block.timestamp).add(value));
1205     }
1206 
1207     /** OVERRIDE
1208      * @notice Burn tokens of one account
1209      * @param account The address whose tokens will be burnt
1210      * @param value The amount of tokens to be burnt
1211      */
1212     function _burn(address account, uint256 value) internal {
1213         super._burn(account, value);
1214 
1215         _createAccountSnapshot(account, balanceOf(account));
1216         _createTotalSupplySnapshot(account, totalSupplyAt(block.timestamp).sub(value));
1217     }
1218 
1219     /**
1220     * @notice creates a total supply snapshot & emits event
1221     * @param amount uint256 
1222     * @param account address
1223     */
1224     function _createTotalSupplySnapshot(address account, uint256 amount) internal {
1225         _snapshotTotalSupply.createSnapshot(amount);
1226 
1227         emit CreatedTotalSupplySnapshot(block.timestamp, amount);
1228     }
1229 
1230     /**
1231     * @notice creates an account snapshot & emits event
1232     * @param amount uint256 
1233     * @param account address
1234     */
1235     function _createAccountSnapshot(address account, uint256 amount) internal {
1236         _snapshotBalances[account].createSnapshot(amount);
1237 
1238         emit CreatedAccountSnapshot(account, block.timestamp, amount);
1239     }
1240 
1241     function _precheckSnapshot() internal {
1242         // FILL LATER TODO: comment on how this is utilized
1243         // Why it's not being abstract
1244     }
1245 }
1246 
1247 // File: contracts/STO/token/WhitelistedSnapshot.sol
1248 
1249 /**
1250  * @title Whitelisted Snapshot Token
1251  * @author Validity Labs AG <info@validitylabs.org>
1252  */
1253 pragma solidity ^0.5.7;
1254 
1255 
1256 
1257 
1258 /**
1259 * Whitelisted Snapshot repurposes the following 2 variables inherited from ERC20Snapshot:
1260 * _snapshotBalances: only whitelisted accounts get snapshots
1261 * _snapshotTotalSupply: only the total sum of whitelisted
1262 */
1263 contract WhitelistedSnapshot is ERC20Snapshot, WhitelistedRole {
1264     /** OVERRIDE
1265     * @notice add account to whitelist & create a snapshot of current balance
1266     * @param account address
1267     */
1268     function addWhitelisted(address account) public {
1269         super.addWhitelisted(account);
1270 
1271         uint256 balance = balanceOf(account);
1272         _createAccountSnapshot(account, balance);
1273 
1274         uint256 newSupplyValue = totalSupplyAt(now).add(balance);
1275         _createTotalSupplySnapshot(account, newSupplyValue);
1276     }
1277     
1278     /** OVERRIDE
1279     * @notice remove account from white & create a snapshot of 0 balance
1280     * @param account address
1281     */
1282     function removeWhitelisted(address account) public {
1283         super.removeWhitelisted(account);
1284 
1285         _createAccountSnapshot(account, 0);
1286 
1287         uint256 balance = balanceOf(account);
1288         uint256 newSupplyValue = totalSupplyAt(now).sub(balance);
1289         _createTotalSupplySnapshot(account, newSupplyValue);
1290     }
1291 
1292     /** OVERRIDE & call parent
1293      * @notice Transfer tokens between two accounts while enforcing the update of Snapshots
1294      * @dev the super._transfer call handles the snapshot of each account. See the internal functions 
1295      * below: _createTotalSupplySnapshot & _createAccountSnapshot
1296      * @param from address The address to transfer from
1297      * @param to address The address to transfer to
1298      * @param value uint256 The amount to be transferred
1299      */
1300     function _transfer(address from, address to, uint256 value) internal {
1301         // if available will call the sibiling's inherited function before calling the parent's
1302         super._transfer(from, to, value);
1303 
1304         /**
1305         * Possibilities:
1306         * Homogeneous Transfers:
1307         *   0: _whitelist to _whitelist: 0 total supply snapshot
1308         *   1: nonwhitelist to nonwhitelist: 0 total supply snapshot
1309         * Heterogeneous Transfers:
1310         *   2: _whitelist to nonwhitelist: 1 whitelisted total supply snapshot
1311         *   3: nonwhitelist to _whitelist: 1 whitelisted total supply snapshot
1312         */
1313         // isWhitelistedHetero tells us to/from is a mix of whitelisted/not whitelisted accounts
1314         // isAdding tell us whether or not to add or subtract from the whitelisted total supply value
1315         (bool isWhitelistedHetero, bool isAdding) = _isWhitelistedHeterogeneousTransfer(from, to);
1316 
1317         if (isWhitelistedHetero) { // one account is whitelisted, the other is not
1318             uint256 newSupplyValue = totalSupplyAt(block.timestamp);
1319             address account;
1320 
1321             if (isAdding) { 
1322                 newSupplyValue = newSupplyValue.add(value);
1323                 account = to;
1324             } else { 
1325                 newSupplyValue = newSupplyValue.sub(value);
1326                 account = from;
1327             }
1328 
1329             _createTotalSupplySnapshot(account, newSupplyValue);
1330         }
1331     }
1332 
1333     /**
1334     * @notice returns true (isHetero) for a mix-match of whitelisted & nonwhitelisted account transfers
1335     * returns true (isAdding) if total supply is increasing or false for decreasing
1336     * @param from address
1337     * @param to address
1338     * @return isHetero, isAdding. bool, bool
1339     */
1340     function _isWhitelistedHeterogeneousTransfer(address from, address to) 
1341         internal 
1342         view 
1343         returns (bool isHetero, bool isAdding) {
1344             bool _isToWhitelisted = isWhitelisted(to);
1345             bool _isFromWhitelisted = isWhitelisted(from);
1346 
1347             if (!_isFromWhitelisted && _isToWhitelisted) {
1348                 isHetero = true;    
1349                 isAdding = true;    // increase whitelisted total supply
1350             } else if (_isFromWhitelisted && !_isToWhitelisted) {
1351                 isHetero = true;    
1352             }
1353         }
1354 
1355     /** OVERRIDE
1356     * @notice creates a total supply snapshot & emits event
1357     * @param amount uint256 
1358     * @param account address
1359     */
1360     function _createTotalSupplySnapshot(address account, uint256 amount) internal {
1361         if (isWhitelisted(account)) {
1362             super._createTotalSupplySnapshot(account, amount);
1363         }
1364     }
1365 
1366     /** OVERRIDE
1367     * @notice only snapshot if account is whitelisted
1368     * @param account address
1369     * @param amount uint256 
1370     */
1371     function _createAccountSnapshot(address account, uint256 amount) internal {
1372         if (isWhitelisted(account)) {
1373             super._createAccountSnapshot(account, amount);
1374         }
1375     }
1376 
1377     function _precheckSnapshot() internal onlyWhitelisted {}
1378 }
1379 
1380 // File: contracts/STO/BaseOptedIn.sol
1381 
1382 /**
1383  * @title Base Opt In
1384  * @author Validity Labs AG <info@validitylabs.org>
1385  * This allows accounts to "opt out" or "opt in"
1386  * Defaults everyone to opted in 
1387  * Example: opt out from onchain dividend payments
1388  */
1389 pragma solidity ^0.5.7;
1390 
1391 
1392 contract BaseOptedIn {
1393     // uint256 = timestamp. Default: 0 = opted in. > 0 = opted out
1394     mapping(address => uint256) public optedOutAddresses; // whitelisters who've opted to receive offchain dividends
1395 
1396     /** EVENTS **/
1397     event OptedOut(address indexed account);
1398     event OptedIn(address indexed account);
1399 
1400     modifier onlyOptedBool(bool isIn) { // true for onlyOptedIn, false for onlyOptedOut
1401         if (isIn) {
1402             require(optedOutAddresses[msg.sender] > 0, "already opted in");
1403         } else {
1404             require(optedOutAddresses[msg.sender] == 0, "already opted out");
1405         }
1406         _;
1407     }
1408 
1409     /**
1410     * @notice accounts who have opted out from onchain dividend payments
1411     */
1412     function optOut() public onlyOptedBool(false) {
1413         optedOutAddresses[msg.sender] = block.timestamp;
1414         
1415         emit OptedOut(msg.sender);
1416     }
1417 
1418     /**
1419     * @notice accounts who previously opted out, who opt back in
1420     */
1421     function optIn() public onlyOptedBool(true) {
1422         optedOutAddresses[msg.sender] = 0;
1423 
1424         emit OptedIn(msg.sender);
1425     }
1426 
1427     /**
1428     * @notice returns true if opted in
1429     * @param account address 
1430     * @return optedIn bool 
1431     */
1432     function isOptedIn(address account) public view returns (bool optedIn) {
1433         if (optedOutAddresses[account] == 0) {
1434             optedIn = true;
1435         }
1436     }
1437 }
1438 
1439 // File: contracts/STO/token/OptedInSnapshot.sol
1440 
1441 /**
1442  * @title Opted In Snapshot
1443  * @author Validity Labs AG <info@validitylabs.org>
1444  */
1445 pragma solidity ^0.5.7;
1446 
1447 
1448 
1449 
1450 /**
1451 * Opted In Snapshot repurposes the following 2 variables inherited from ERC20Snapshot:
1452 * _snapshotBalances: snapshots of opted in accounts
1453 * _snapshotTotalSupply: only the total sum of opted in accounts
1454 */
1455 contract OptedInSnapshot is ERC20Snapshot, BaseOptedIn {
1456     /** OVERRIDE
1457     * @notice accounts who previously opted out, who opt back in
1458     */
1459     function optIn() public {
1460         // protects against TODO: Fill later
1461         super._precheckSnapshot();
1462         super.optIn();
1463 
1464         address account = msg.sender;
1465         uint256 balance = balanceOf(account);
1466         _createAccountSnapshot(account, balance);
1467 
1468         _createTotalSupplySnapshot(account, totalSupplyAt(now).add(balance));
1469     }
1470 
1471     /** OVERRIDE
1472     * @notice call parent f(x) & 
1473     * create new snapshot for account: setting to 0
1474     * create new shapshot for total supply: oldTotalSupply.sub(balance)
1475     */
1476     function optOut() public {
1477         // protects against TODO: Fill later
1478         super._precheckSnapshot();
1479         super.optOut();
1480 
1481         address account = msg.sender;
1482         _createAccountSnapshot(account, 0);
1483 
1484         _createTotalSupplySnapshot(account, totalSupplyAt(now).sub(balanceOf(account)));
1485     }
1486 
1487     /** OVERRIDE
1488      * @notice Transfer tokens between two accounts while enforcing the update of Snapshots
1489      * @param from The address to transfer from
1490      * @param to The address to transfer to
1491      * @param value The amount to be transferred
1492      */
1493     function _transfer(address from, address to, uint256 value) internal {
1494         // if available will call the sibiling's inherited function before calling the parent's
1495         super._transfer(from, to, value);
1496 
1497         /**
1498         * Possibilities:
1499         * Homogeneous Transfers:
1500         *   0: opted in to opted in: 0 total supply snapshot
1501         *   1: opted out to opted out: 0 total supply snapshot
1502         * Heterogeneous Transfers:
1503         *   2: opted out to opted in: 1 whitelisted total supply snapshot
1504         *   3: opted in to opted out: 1 whitelisted total supply snapshot
1505         */
1506         // isOptedHetero tells us to/from is a mix of opted in/out accounts
1507         // isAdding tell us whether or not to add or subtract from the opted in total supply value
1508         (bool isOptedHetero, bool isAdding) = _isOptedHeterogeneousTransfer(from, to);
1509 
1510         if (isOptedHetero) { // one account is whitelisted, the other is not
1511             uint256 newSupplyValue = totalSupplyAt(block.timestamp);
1512             address account;
1513 
1514             if (isAdding) {
1515                 newSupplyValue = newSupplyValue.add(value);
1516                 account = to;
1517             } else {
1518                 newSupplyValue = newSupplyValue.sub(value);
1519                 account = from;
1520             }
1521 
1522             _createTotalSupplySnapshot(account, newSupplyValue);
1523         }
1524     }
1525 
1526     /**
1527     * @notice returns true for a mix-match of opted in & opted out transfers. 
1528     *         if true, returns true/false for increasing either optedIn or opetedOut total supply balances
1529     * @dev should only be calling if both to and from accounts are whitelisted
1530     * @param from address
1531     * @param to address
1532     * @return isOptedHetero, isOptedInIncrease. bool, bool
1533     */
1534     function _isOptedHeterogeneousTransfer(address from, address to) 
1535         internal 
1536         view 
1537         returns (bool isOptedHetero, bool isOptedInIncrease) {
1538             bool _isToOptedIn = isOptedIn(to);
1539             bool _isFromOptedIn = isOptedIn(from);
1540             
1541             if (!_isFromOptedIn && _isToOptedIn) {
1542                 isOptedHetero = true;    
1543                 isOptedInIncrease = true;    // increase opted in total supply
1544             } else if (_isFromOptedIn && !_isToOptedIn) {
1545                 isOptedHetero = true; 
1546             }
1547         }
1548 
1549     /** OVERRIDE
1550     * @notice creates a total supply snapshot & emits event
1551     * @param amount uint256 
1552     * @param account address
1553     */
1554     function _createTotalSupplySnapshot(address account, uint256 amount) internal {
1555         if (isOptedIn(account)) {
1556             super._createTotalSupplySnapshot(account, amount);
1557         }
1558     }
1559 
1560     /** OVERRIDE
1561     * @notice only snapshot if opted in
1562     * @param account address
1563     * @param amount uint256 
1564     */
1565     function _createAccountSnapshot(address account, uint256 amount) internal {
1566         if (isOptedIn(account)) {
1567             super._createAccountSnapshot(account, amount);
1568         }
1569     }
1570 }
1571 
1572 // File: contracts/STO/token/ERC20ForceTransfer.sol
1573 
1574 /**
1575  * @title ERC20 ForceTransfer
1576  * @author Validity Labs AG <info@validitylabs.org>
1577  */
1578 pragma solidity ^0.5.7;  
1579 
1580 
1581 
1582 
1583 /**
1584 * @dev inherit contract, create external/public function that calls these internal functions
1585 * to activate the ability for one or both forceTransfer implementations
1586 */
1587 contract ERC20ForceTransfer is Ownable, ERC20 {
1588     event ForcedTransfer(address indexed confiscatee, uint256 amount, address indexed receiver);
1589 
1590     /**
1591     * @notice takes all funds from confiscatee and sends them to receiver
1592     * @param confiscatee address who's funds are being confiscated
1593     * @param receiver address who's receiving the funds 
1594     */
1595     function forceTransfer(address confiscatee, address receiver) external onlyOwner {
1596         uint256 balance = balanceOf(confiscatee);
1597         _transfer(confiscatee, receiver, balance);
1598 
1599         emit ForcedTransfer(confiscatee, balance, receiver);
1600     }
1601 
1602     /**
1603     * @notice takes an amount of funds from confiscatee and sends them to receiver
1604     * @param confiscatee address who's funds are being confiscated
1605     * @param receiver address who's receiving the funds 
1606     */
1607     function forceTransfer(address confiscatee, address receiver, uint256 amount) external onlyOwner {
1608         _transfer(confiscatee, receiver, amount);
1609 
1610         emit ForcedTransfer(confiscatee, amount, receiver);
1611     }
1612 }
1613 
1614 // File: contracts/STO/BaseDocumentRegistry.sol
1615 
1616 /**
1617  * @title Base Document Registry Contract
1618  * @author Validity Labs AG <info@validitylabs.org>
1619  * inspired by Neufund's iAgreement smart contract
1620  */
1621 pragma solidity ^0.5.7;
1622 
1623 
1624 
1625 
1626 // solhint-disable not-rely-on-time
1627 contract BaseDocumentRegistry is Ownable {
1628     using SafeMath for uint256;
1629     
1630     struct HashedDocument {
1631         uint256 timestamp;
1632         string documentUri;
1633     }
1634 
1635     HashedDocument[] private _documents;
1636 
1637     event AddedLogDocumented(string documentUri, uint256 documentIndex);
1638 
1639     /**
1640     * @notice adds a document's uri from IPFS to the array
1641     * @param documentUri string
1642     */
1643     function addDocument(string calldata documentUri) external onlyOwner {
1644         require(bytes(documentUri).length > 0, "invalid documentUri");
1645 
1646         HashedDocument memory document = HashedDocument({
1647             timestamp: block.timestamp,
1648             documentUri: documentUri
1649         });
1650 
1651         _documents.push(document);
1652 
1653         emit AddedLogDocumented(documentUri, _documents.length.sub(1));
1654     }
1655 
1656     /**
1657     * @notice fetch the latest document on the array
1658     * @return uint256, string, uint256 
1659     */
1660     function currentDocument() 
1661         public 
1662         view 
1663         returns (uint256 timestamp, string memory documentUri, uint256 index) {
1664             require(_documents.length > 0, "no documents exist");
1665             uint256 last = _documents.length.sub(1);
1666 
1667             HashedDocument storage document = _documents[last];
1668             return (document.timestamp, document.documentUri, last);
1669         }
1670 
1671     /**
1672     * @notice adds a document's uri from IPFS to the array
1673     * @param documentIndex uint256
1674     * @return uint256, string, uint256 
1675     */
1676     function getDocument(uint256 documentIndex) 
1677         public 
1678         view
1679         returns (uint256 timestamp, string memory documentUri, uint256 index) {
1680             require(documentIndex < _documents.length, "invalid index");
1681 
1682             HashedDocument storage document = _documents[documentIndex];
1683             return (document.timestamp, document.documentUri, documentIndex);
1684         }
1685 
1686     /**
1687     * @notice return the total amount of documents in the array
1688     * @return uint256
1689     */
1690     function documentCount() public view returns (uint256) {
1691         return _documents.length;
1692     }
1693 }
1694 
1695 // File: contracts/examples/ExampleSecurityToken.sol
1696 
1697 /**
1698  * @title Example Security Token
1699  * @author Validity Labs AG <info@validitylabs.org>
1700  */
1701 pragma solidity ^0.5.7;
1702 
1703 
1704 
1705 
1706 
1707 
1708 
1709 
1710 
1711 
1712 
1713 
1714 contract ExampleSecurityToken is 
1715     Utils, 
1716     Reclaimable, 
1717     ERC20Detailed, 
1718     WhitelistedSnapshot, 
1719     OptedInSnapshot,
1720     ERC20Mintable, 
1721     ERC20Burnable, 
1722     ERC20Pausable,
1723     ERC20ForceTransfer,
1724     BaseDocumentRegistry {
1725     
1726     bool private _isSetup;
1727 
1728     /**
1729     * @notice contructor for the token contract
1730     */
1731     constructor(string memory name, string memory symbol, address initialAccount, uint256 initialBalance) 
1732         public
1733         ERC20Detailed(name, symbol, 0) {
1734             // pause();
1735             _mint(initialAccount, initialBalance);
1736             roleSetup(initialAccount);
1737         }
1738 
1739     /**
1740     * @notice setup roles and contract addresses for the new token
1741     * @param board Address of the owner who is also a manager 
1742     */
1743     function roleSetup(address board) internal onlyOwner onlyOnce(_isSetup) {   
1744         addMinter(board);
1745         addPauser(board);
1746         _addWhitelistAdmin(board);
1747     }
1748 
1749     /** OVERRIDE - onlyOwner role (the board) can call 
1750      * @notice Burn tokens of one account
1751      * @param account The address whose tokens will be burnt
1752      * @param value The amount of tokens to be burnt
1753      */
1754     function _burn(address account, uint256 value) internal onlyOwner {
1755         super._burn(account, value);
1756     } 
1757 }
1758 
1759 // File: contracts/STO/dividends/Dividends.sol
1760 
1761 /**
1762  * @title Dividend contract for STO
1763  * @author Validity Labs AG <info@validitylabs.org>
1764  */
1765 pragma solidity ^0.5.7;
1766 
1767 
1768 
1769 
1770 
1771 
1772 
1773 
1774 contract Dividends is Utils, Ownable {
1775     using SafeMath for uint256;
1776     using SafeERC20 for IERC20;
1777 
1778     address public _wallet;  // set at deploy time
1779     
1780     struct Dividend {
1781         uint256 recordDate;     // timestamp of the record date
1782         uint256 claimPeriod;    // claim period, in seconds, of the claiming period
1783         address payoutToken;    // payout token, which could be different each time.
1784         uint256 payoutAmount;   // the total amount of tokens deposit
1785         uint256 claimedAmount;  // the total amount of tokens being claimed
1786         uint256 totalSupply;    // the total supply of sto token when deposit was made
1787         bool reclaimed;          // If the unclaimed deposit was reclaimed by the team
1788         mapping(address => bool) claimed; // If investors have claimed their dividends.
1789     }
1790 
1791     address public _token;
1792     Dividend[] public dividends;
1793 
1794     // Record the balance of each ERC20 token deposited to this contract as dividends.
1795     mapping(address => uint256) public totalBalance;
1796 
1797     // EVENTS
1798     event DepositedDividend(uint256 indexed dividendIndex, address indexed payoutToken, uint256 payoutAmount, uint256 recordDate, uint256 claimPeriod);
1799     event ReclaimedDividend(uint256 indexed dividendIndex, address indexed claimer, uint256 claimedAmount);
1800     event RecycledDividend(uint256 indexed dividendIndex, uint256 timestamp, uint256 recycledAmount);
1801 
1802     /**
1803      * @notice Check if the index is valid
1804      */
1805     modifier validDividendIndex(uint256 _dividendIndex) {
1806         require(_dividendIndex < dividends.length, "Such dividend does not exist");
1807         _;
1808     } 
1809 
1810     /**
1811     * @notice initialize the Dividend contract with the STO Token contract and the new owner
1812     * @param stoToken The token address, of which the holders could claim dividends.
1813     * @param wallet the address of the wallet to receive the reclaimed funds
1814     */
1815     /* solhint-disable */
1816     constructor(address stoToken, address wallet) public onlyValidAddress(stoToken) onlyValidAddress(wallet) {
1817         _token = stoToken;
1818         _wallet = wallet;
1819         transferOwnership(wallet);
1820     }
1821     /* solhint-enable */
1822 
1823     /**
1824     * @notice deposit payoutDividend tokens (ERC20) into this contract
1825     * @param payoutToken ERC20 address of the token used for payout the current dividend 
1826     * @param amount uint256 total amount of the ERC20 tokens deposited to payout to all 
1827     * token holders as of previous block from when this function is included
1828     * @dev The owner should first call approve(STODividendsContractAddress, amount) 
1829     * in the payoutToken contract
1830     */
1831     function depositDividend(address payoutToken, uint256 recordDate, uint256 claimPeriod, uint256 amount)
1832         public
1833         onlyOwner
1834         onlyValidAddress(payoutToken)
1835     {
1836         require(amount > 0, "invalid deposit amount");
1837         require(recordDate > 0, "invalid recordDate");
1838         require(claimPeriod > 0, "invalid claimPeriod");
1839 
1840         IERC20(payoutToken).safeTransferFrom(msg.sender, address(this), amount);     // transfer ERC20 to this contract
1841         totalBalance[payoutToken] = totalBalance[payoutToken].add(amount); // update global balance of ERC20 token
1842 
1843         dividends.push(
1844             Dividend(
1845                 recordDate,
1846                 claimPeriod,
1847                 payoutToken,
1848                 amount,
1849                 0,
1850                 ERC20Snapshot(_token).totalSupplyAt(block.timestamp), //eligible supply
1851                 false
1852             )
1853         );
1854 
1855         emit DepositedDividend((dividends.length).sub(1), payoutToken, amount, block.timestamp, claimPeriod);
1856     }
1857 
1858     /** TODO: check for "recycle" or "recycled" - replace with reclaimed
1859      * @notice Token holder claim their dividends
1860      * @param dividendIndex The index of the deposit dividend to be claimed.
1861      */
1862     function claimDividend(uint256 dividendIndex) 
1863         public 
1864         validDividendIndex(dividendIndex) 
1865     {
1866         Dividend storage dividend = dividends[dividendIndex];
1867         require(dividend.claimed[msg.sender] == false, "Dividend already claimed");
1868         require(dividend.reclaimed == false, "Dividend already reclaimed");
1869         require((dividend.recordDate).add(dividend.claimPeriod) >= block.timestamp, "No longer claimable");
1870 
1871         _claimDividend(dividendIndex, msg.sender);
1872     }
1873 
1874     /**
1875      * @notice Claim dividends from a startingIndex to all possible dividends
1876      * @param startingIndex The index from which the loop of claiming dividend starts
1877      * @dev To claim all dividends from the beginning, set this value to 0.
1878      * This parameter may help reducing the risk of running out-of-gas due to many loops
1879      */
1880     function claimAllDividends(uint256 startingIndex) 
1881         public 
1882         validDividendIndex(startingIndex) 
1883     {
1884         for (uint256 i = startingIndex; i < dividends.length; i++) {
1885             Dividend storage dividend = dividends[i];
1886 
1887             if (dividend.claimed[msg.sender] == false 
1888                 && (dividend.recordDate).add(dividend.claimPeriod) >= block.timestamp && dividend.reclaimed == false) {
1889                 _claimDividend(i, msg.sender);
1890             }
1891         }
1892     }
1893 
1894     /**
1895      * @notice recycle the dividend. Transfer tokens back to the _wallet
1896      * @param dividendIndex the storage index of the dividend in the pushed array.
1897      */
1898     function reclaimDividend(uint256 dividendIndex) 
1899         public
1900         onlyOwner
1901         validDividendIndex(dividendIndex)     
1902     {
1903         Dividend storage dividend = dividends[dividendIndex];
1904         require(dividend.reclaimed == false, "Dividend already reclaimed");
1905         require((dividend.recordDate).add(dividend.claimPeriod) < block.timestamp, "Still claimable");
1906 
1907         dividend.reclaimed = true;
1908         uint256 recycledAmount = (dividend.payoutAmount).sub(dividend.claimedAmount);
1909         totalBalance[dividend.payoutToken] = totalBalance[dividend.payoutToken].sub(recycledAmount);
1910         IERC20(dividend.payoutToken).safeTransfer(_wallet, recycledAmount);
1911 
1912         emit RecycledDividend(dividendIndex, block.timestamp, recycledAmount);
1913     }
1914 
1915     /**
1916     * @notice get dividend info at index
1917     * @param dividendIndex the storage index of the dividend in the pushed array. 
1918     * @return recordDate (uint256) of the dividend
1919     * @return claimPeriod (uint256) of the dividend
1920     * @return payoutToken (address) of the dividend
1921     * @return payoutAmount (uint256) of the dividend
1922     * @return claimedAmount (uint256) of the dividend
1923     * @return the total supply (uint256) of the dividend
1924     * @return Whether this dividend was reclaimed (bool) of the dividend
1925     */
1926     function getDividend(uint256 dividendIndex) 
1927         public
1928         view 
1929         validDividendIndex(dividendIndex)
1930         returns (uint256, uint256, address, uint256, uint256, uint256, bool)
1931     {
1932         Dividend memory result = dividends[dividendIndex];
1933         return (
1934             result.recordDate,
1935             result.claimPeriod,
1936             address(result.payoutToken),
1937             result.payoutAmount,
1938             result.claimedAmount,
1939             result.totalSupply,
1940             result.reclaimed);
1941     }
1942 
1943     /**
1944      * @notice Internal function that claim the dividend
1945      * @param dividendIndex the index of the dividend to be claimed
1946      * @param account address of the account to receive dividend
1947      */
1948     function _claimDividend(uint256 dividendIndex, address account) internal {
1949         Dividend storage dividend = dividends[dividendIndex];
1950 
1951         uint256 claimAmount = _calcClaim(dividendIndex, account);
1952         
1953         dividend.claimed[account] = true;
1954         dividend.claimedAmount = (dividend.claimedAmount).add(claimAmount);
1955         totalBalance[dividend.payoutToken] = totalBalance[dividend.payoutToken].sub(claimAmount);
1956 
1957         IERC20(dividend.payoutToken).safeTransfer(account, claimAmount);
1958         emit ReclaimedDividend(dividendIndex, account, claimAmount);
1959     }
1960 
1961     /**
1962     * @notice calculate dividend claim amount
1963     */
1964     function _calcClaim(uint256 dividendIndex, address account) internal view returns (uint256) {
1965         Dividend memory dividend = dividends[dividendIndex];
1966 
1967         uint256 balance = ERC20Snapshot(_token).balanceOfAt(account, dividend.recordDate);
1968         return balance.mul(dividend.payoutAmount).div(dividend.totalSupply);
1969     }
1970 }
1971 
1972 // File: contracts/examples/ExampleTokenFactory.sol
1973 
1974 /**
1975  * @title Example Token Factory Contract
1976  * @author Validity Labs AG <info@validitylabs.org>
1977  */
1978 
1979 pragma solidity 0.5.7;
1980 
1981 
1982 
1983 
1984 
1985 /* solhint-disable max-line-length */
1986 /* solhint-disable separate-by-one-line-in-contract */
1987 contract ExampleTokenFactory is Managed {
1988 
1989     mapping(address => address) public tokenToDividend;
1990 
1991     /*** EVENTS ***/
1992     event DeployedToken(address indexed contractAddress, string name, string symbol, address indexed clientOwner);
1993     event DeployedDividend(address indexed contractAddress);
1994    
1995     /*** FUNCTIONS ***/
1996     function newToken(string calldata _name, string calldata _symbol, address _clientOwner, uint256 _initialAmount) external onlyOwner {
1997         address tokenAddress = _deployToken(_name, _symbol, _clientOwner, _initialAmount);
1998     }
1999 
2000     function newTokenAndDividend(string calldata _name, string calldata _symbol, address _clientOwner, uint256 _initialAmount) external onlyOwner {
2001         address tokenAddress = _deployToken(_name, _symbol, _clientOwner, _initialAmount);
2002         address dividendAddress = _deployDividend(tokenAddress, _clientOwner);
2003         tokenToDividend[tokenAddress] = dividendAddress;
2004     }
2005     
2006     /** MANGER FUNCTIONS **/
2007     /**
2008     * @notice Prospectus and Quarterly Reports 
2009     * @dev string null check is done at the token level - see ERC20DocumentRegistry
2010     * @param _est address of the targeted EST
2011     * @param _documentUri string IPFS URI to the document
2012     */
2013     function addDocument(address _est, string calldata _documentUri) external onlyValidAddress(_est) onlyManager {
2014         ExampleSecurityToken(_est).addDocument(_documentUri);
2015     }
2016 
2017     /**
2018     * @notice pause or unpause individual EST
2019     * @param _est address of the targeted EST
2020     */
2021     function togglePauseEST(address _est) public onlyValidAddress(_est) onlyManager {
2022         ExampleSecurityToken est = ExampleSecurityToken(_est);
2023         bool result = est.paused();
2024         result ? est.unpause() : est.pause();
2025     }
2026 
2027     /**
2028     * @notice force the transfer of tokens from _confiscatee to _receiver
2029     * @param _est address of the targeted EST
2030     * @param _confiscatee address to confiscate tokens from
2031     * @param _receiver address to receive the balance of tokens
2032     * @param _amount uint256 amount to take away from _confiscatee
2033     */
2034     function forceTransferEST(address _est, address _confiscatee, address _receiver, uint256 _amount) 
2035         public 
2036         onlyValidAddress(_est) 
2037         onlyValidAddress(_confiscatee)
2038         onlyValidAddress(_receiver)
2039         onlyManager {
2040             require(_amount > 0, "invalid amount");
2041 
2042             ExampleSecurityToken est = ExampleSecurityToken(_est);
2043             est.forceTransfer(_confiscatee, _receiver, _amount);
2044         }
2045 
2046     function _deployToken(string memory _name, string memory _symbol, address _clientOwner, uint256 _initialAmount) internal returns (address) {
2047         require(bytes(_name).length > 0, "name cannot be blank");
2048         require(bytes(_symbol).length > 0, "symbol cannot be blank");
2049 
2050         ExampleSecurityToken tokenContract = new ExampleSecurityToken(_name, _symbol, _clientOwner, _initialAmount);
2051         
2052         emit DeployedToken(address(tokenContract), _name, _symbol, _clientOwner);
2053         return address(tokenContract);
2054     }
2055 
2056     function _deployDividend(address tokenAddress, address wallet) internal returns (address) {
2057         Dividends dividendContract = new Dividends(tokenAddress, wallet);
2058 
2059         emit DeployedDividend(address(dividendContract));
2060         return address(dividendContract);
2061     }
2062 }