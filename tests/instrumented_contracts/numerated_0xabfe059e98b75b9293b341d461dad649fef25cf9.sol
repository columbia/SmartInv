1 pragma solidity ^0.5.7;
2 
3 /**
4  * @dev Implements a contract to add password-protection support to API calls of child contracts.
5  * This is secure through storage of only the keccak256 hash of the password, which is irreversible.
6  * Critically, all sensitive methods have private visibility.
7  *
8  * As implemented, the password has contract-wide scope. This does not implement per-account passwords,
9  * though that would not be difficult to do.
10  */
11 contract PasswordProtected {
12     bytes32 private passwordHash;
13 
14     /**
15      * A default contract password must be set at construction time.
16      */
17     constructor (string memory password) internal {
18         _setNewPassword(password);
19     }
20 
21     function _setNewPassword(string memory password) private {
22         passwordHash = keccak256(bytes(password));
23     }
24 
25     function _isValidPassword(string memory password) internal view returns (bool ok) {
26         return (bytes32(keccak256(bytes(password))) == passwordHash);
27     }
28 
29     /**
30      * Any contract functions requiring password-restricted access can use this modifier.
31      */
32     modifier onlyValidPassword(string memory password) {
33         require(_isValidPassword(password), "access denied");
34         _;
35     }
36 
37     /**
38      * Allow password to be changed.
39      */
40     function _changePassword(string memory oldPassword, string memory newPassword) onlyValidPassword(oldPassword) internal returns (bool ok) {
41         _setNewPassword(newPassword);
42         return true;
43     }
44 }
45 
46 
47 pragma solidity ^0.5.7;
48 
49 contract Identity {
50     mapping(address => string) private _names;
51 
52     /**
53      * Handy function to associate a short name with the account.
54      */
55     function iAm(string memory shortName) public {
56         _names[msg.sender] = shortName;
57     }
58 
59     /**
60      * Handy function to confirm address of the current account.
61      */
62     function whereAmI() public view returns (address yourAddress) {
63         address myself = msg.sender;
64         return myself;
65     }
66 
67     /**
68      * Handy function to confirm short name of the current account.
69      */
70     function whoAmI() public view returns (string memory yourName) {
71         return (_names[msg.sender]);
72     }
73 }
74 
75 
76 pragma solidity ^0.5.2;
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://eips.ethereum.org/EIPS/eip-20
81  */
82 interface IERC20 {
83     function transfer(address to, uint256 value) external returns (bool);
84 
85     function approve(address spender, uint256 value) external returns (bool);
86 
87     function transferFrom(address from, address to, uint256 value) external returns (bool);
88 
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address who) external view returns (uint256);
92 
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 pragma solidity ^0.5.2;
102 
103 /**
104  * @title SafeMath
105  * @dev Unsigned math operations with safety checks that revert on error.
106  */
107 library SafeMath {
108     /**
109      * @dev Multiplies two unsigned integers, reverts on overflow.
110      */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
113         // benefit is lost if 'b' is also tested.
114         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint256 c = a * b;
120         require(c / a == b);
121 
122         return c;
123     }
124 
125     /**
126      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
127      */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         // Solidity only automatically asserts when dividing by 0
130         require(b > 0);
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134         return c;
135     }
136 
137     /**
138      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b <= a);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Adds two unsigned integers, reverts on overflow.
149      */
150     function add(uint256 a, uint256 b) internal pure returns (uint256) {
151         uint256 c = a + b;
152         require(c >= a);
153 
154         return c;
155     }
156 
157     /**
158      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
159      * reverts when dividing by zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         require(b != 0);
163         return a % b;
164     }
165 }
166 
167 
168 pragma solidity ^0.5.2;
169 
170 
171 /**
172  * @title Standard ERC20 token
173  *
174  * @dev Implementation of the basic standard token.
175  * https://eips.ethereum.org/EIPS/eip-20
176  * Originally based on code by FirstBlood:
177  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
178  *
179  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
180  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
181  * compliant implementations may not do it.
182  */
183 contract ERC20 is IERC20 {
184     using SafeMath for uint256;
185 
186     mapping (address => uint256) private _balances;
187 
188     mapping (address => mapping (address => uint256)) private _allowed;
189 
190     uint256 private _totalSupply;
191 
192     /**
193      * @dev Total number of tokens in existence.
194      */
195     function totalSupply() public view returns (uint256) {
196         return _totalSupply;
197     }
198 
199     /**
200      * @dev Gets the balance of the specified address.
201      * @param owner The address to query the balance of.
202      * @return A uint256 representing the amount owned by the passed address.
203      */
204     function balanceOf(address owner) public view returns (uint256) {
205         return _balances[owner];
206     }
207 
208     /**
209      * @dev Function to check the amount of tokens that an owner allowed to a spender.
210      * @param owner address The address which owns the funds.
211      * @param spender address The address which will spend the funds.
212      * @return A uint256 specifying the amount of tokens still available for the spender.
213      */
214     function allowance(address owner, address spender) public view returns (uint256) {
215         return _allowed[owner][spender];
216     }
217 
218     /**
219      * @dev Transfer token to a specified address.
220      * @param to The address to transfer to.
221      * @param value The amount to be transferred.
222      */
223     function transfer(address to, uint256 value) public returns (bool) {
224         _transfer(msg.sender, to, value);
225         return true;
226     }
227 
228     /**
229      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230      * Beware that changing an allowance with this method brings the risk that someone may use both the old
231      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234      * @param spender The address which will spend the funds.
235      * @param value The amount of tokens to be spent.
236      */
237     function approve(address spender, uint256 value) public returns (bool) {
238         _approve(msg.sender, spender, value);
239         return true;
240     }
241 
242     /**
243      * @dev Transfer tokens from one address to another.
244      * Note that while this function emits an Approval event, this is not required as per the specification,
245      * and other compliant implementations may not emit the event.
246      * @param from address The address which you want to send tokens from
247      * @param to address The address which you want to transfer to
248      * @param value uint256 the amount of tokens to be transferred
249      */
250     function transferFrom(address from, address to, uint256 value) public returns (bool) {
251         _transfer(from, to, value);
252         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
253         return true;
254     }
255 
256     /**
257      * @dev Increase the amount of tokens that an owner allowed to a spender.
258      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
259      * allowed value is better to use this function to avoid 2 calls (and wait until
260      * the first transaction is mined)
261      * From MonolithDAO Token.sol
262      * Emits an Approval event.
263      * @param spender The address which will spend the funds.
264      * @param addedValue The amount of tokens to increase the allowance by.
265      */
266     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
267         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
268         return true;
269     }
270 
271     /**
272      * @dev Decrease the amount of tokens that an owner allowed to a spender.
273      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
274      * allowed value is better to use this function to avoid 2 calls (and wait until
275      * the first transaction is mined)
276      * From MonolithDAO Token.sol
277      * Emits an Approval event.
278      * @param spender The address which will spend the funds.
279      * @param subtractedValue The amount of tokens to decrease the allowance by.
280      */
281     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
282         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
283         return true;
284     }
285 
286     /**
287      * @dev Transfer token for a specified addresses.
288      * @param from The address to transfer from.
289      * @param to The address to transfer to.
290      * @param value The amount to be transferred.
291      */
292     function _transfer(address from, address to, uint256 value) internal {
293         require(to != address(0));
294 
295         _balances[from] = _balances[from].sub(value);
296         _balances[to] = _balances[to].add(value);
297         emit Transfer(from, to, value);
298     }
299 
300     /**
301      * @dev Internal function that mints an amount of the token and assigns it to
302      * an account. This encapsulates the modification of balances such that the
303      * proper events are emitted.
304      * @param account The account that will receive the created tokens.
305      * @param value The amount that will be created.
306      */
307     function _mint(address account, uint256 value) internal {
308         require(account != address(0));
309 
310         _totalSupply = _totalSupply.add(value);
311         _balances[account] = _balances[account].add(value);
312         emit Transfer(address(0), account, value);
313     }
314 
315     /**
316      * @dev Internal function that burns an amount of the token of a given
317      * account.
318      * @param account The account whose tokens will be burnt.
319      * @param value The amount that will be burnt.
320      */
321     function _burn(address account, uint256 value) internal {
322         require(account != address(0));
323 
324         _totalSupply = _totalSupply.sub(value);
325         _balances[account] = _balances[account].sub(value);
326         emit Transfer(account, address(0), value);
327     }
328 
329     /**
330      * @dev Approve an address to spend another addresses' tokens.
331      * @param owner The address that owns the tokens.
332      * @param spender The address that will spend the tokens.
333      * @param value The number of tokens that can be spent.
334      */
335     function _approve(address owner, address spender, uint256 value) internal {
336         require(spender != address(0));
337         require(owner != address(0));
338 
339         _allowed[owner][spender] = value;
340         emit Approval(owner, spender, value);
341     }
342 
343     /**
344      * @dev Internal function that burns an amount of the token of a given
345      * account, deducting from the sender's allowance for said account. Uses the
346      * internal burn function.
347      * Emits an Approval event (reflecting the reduced allowance).
348      * @param account The account whose tokens will be burnt.
349      * @param value The amount that will be burnt.
350      */
351     function _burnFrom(address account, uint256 value) internal {
352         _burn(account, value);
353         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
354     }
355 }
356 
357 
358 pragma solidity ^0.5.2;
359 
360 
361 /**
362  * @title Burnable Token
363  * @dev Token that can be irreversibly burned (destroyed).
364  */
365 contract ERC20Burnable is ERC20 {
366     /**
367      * @dev Burns a specific amount of tokens.
368      * @param value The amount of token to be burned.
369      */
370     function burn(uint256 value) public {
371         _burn(msg.sender, value);
372     }
373 
374     /**
375      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
376      * @param from address The account whose tokens will be burned.
377      * @param value uint256 The amount of token to be burned.
378      */
379     function burnFrom(address from, uint256 value) public {
380         _burnFrom(from, value);
381     }
382 }
383 
384 
385 pragma solidity ^0.5.2;
386 
387 
388 /**
389  * @title ERC20Detailed token
390  * @dev The decimals are only for visualization purposes.
391  * All the operations are done using the smallest and indivisible token unit,
392  * just as on Ethereum all the operations are done in wei.
393  */
394 contract ERC20Detailed is IERC20 {
395     string private _name;
396     string private _symbol;
397     uint8 private _decimals;
398 
399     constructor (string memory name, string memory symbol, uint8 decimals) public {
400         _name = name;
401         _symbol = symbol;
402         _decimals = decimals;
403     }
404 
405     /**
406      * @return the name of the token.
407      */
408     function name() public view returns (string memory) {
409         return _name;
410     }
411 
412     /**
413      * @return the symbol of the token.
414      */
415     function symbol() public view returns (string memory) {
416         return _symbol;
417     }
418 
419     /**
420      * @return the number of decimals of the token.
421      */
422     function decimals() public view returns (uint8) {
423         return _decimals;
424     }
425 }
426 
427 
428 pragma solidity ^0.5.2;
429 
430 /**
431  * @title Ownable
432  * @dev The Ownable contract has an owner address, and provides basic authorization control
433  * functions, this simplifies the implementation of "user permissions".
434  */
435 contract Ownable {
436     address private _owner;
437 
438     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
439 
440     /**
441      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
442      * account.
443      */
444     constructor () internal {
445         _owner = msg.sender;
446         emit OwnershipTransferred(address(0), _owner);
447     }
448 
449     /**
450      * @return the address of the owner.
451      */
452     function owner() public view returns (address) {
453         return _owner;
454     }
455 
456     /**
457      * @dev Throws if called by any account other than the owner.
458      */
459     modifier onlyOwner() {
460         require(isOwner());
461         _;
462     }
463 
464     /**
465      * @return true if `msg.sender` is the owner of the contract.
466      */
467     function isOwner() public view returns (bool) {
468         return msg.sender == _owner;
469     }
470 
471     /**
472      * @dev Allows the current owner to relinquish control of the contract.
473      * It will not be possible to call the functions with the `onlyOwner`
474      * modifier anymore.
475      * @notice Renouncing ownership will leave the contract without an owner,
476      * thereby removing any functionality that is only available to the owner.
477      */
478     function renounceOwnership() public onlyOwner {
479         emit OwnershipTransferred(_owner, address(0));
480         _owner = address(0);
481     }
482 
483     /**
484      * @dev Allows the current owner to transfer control of the contract to a newOwner.
485      * @param newOwner The address to transfer ownership to.
486      */
487     function transferOwnership(address newOwner) public onlyOwner {
488         _transferOwnership(newOwner);
489     }
490 
491     /**
492      * @dev Transfers control of the contract to a newOwner.
493      * @param newOwner The address to transfer ownership to.
494      */
495     function _transferOwnership(address newOwner) internal {
496         require(newOwner != address(0));
497         emit OwnershipTransferred(_owner, newOwner);
498         _owner = newOwner;
499     }
500 }
501 
502 
503 pragma solidity ^0.5.2;
504 
505 /**
506  * @title Roles
507  * @dev Library for managing addresses assigned to a Role.
508  */
509 library Roles {
510     struct Role {
511         mapping (address => bool) bearer;
512     }
513 
514     /**
515      * @dev Give an account access to this role.
516      */
517     function add(Role storage role, address account) internal {
518         require(account != address(0));
519         require(!has(role, account));
520 
521         role.bearer[account] = true;
522     }
523 
524     /**
525      * @dev Remove an account's access to this role.
526      */
527     function remove(Role storage role, address account) internal {
528         require(account != address(0));
529         require(has(role, account));
530 
531         role.bearer[account] = false;
532     }
533 
534     /**
535      * @dev Check if an account has this role.
536      * @return bool
537      */
538     function has(Role storage role, address account) internal view returns (bool) {
539         require(account != address(0));
540         return role.bearer[account];
541     }
542 }
543 
544 
545 pragma solidity ^0.5.7;
546 
547 
548 /**
549  * @dev This role allows the contract to be paused, so that in case something goes horribly wrong
550  * during an ICO, the owner/administrator has an ability to suspend all transactions while things
551  * are sorted out.
552  *
553  * NOTE: We have implemented a role model only the contract owner can assign/un-assign roles.
554  * This is necessary to support enterprise software, which requires a permissions model in which
555  * roles can be owner-administered, in contrast to a blockchain community approach in which
556  * permissions can be self-administered. Therefore, this implementation replaces the self-service
557  * "renounce" approach with one where only the owner is allowed to makes role changes.
558  *
559  * Owner is not allowed to renounce ownership, lest the contract go without administration. But
560  * it is ok for owner to shed initially granted roles by removing role from self.
561  */
562 contract PauserRole is Ownable {
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
575         require(isPauser(msg.sender), "onlyPauser");
576         _;
577     }
578 
579     function isPauser(address account) public view returns (bool) {
580         return _pausers.has(account);
581     }
582 
583     function addPauser(address account) public onlyOwner {
584         _addPauser(account);
585     }
586 
587     function removePauser(address account) public onlyOwner {
588         _removePauser(account);
589     }
590 
591     function _addPauser(address account) private {
592         require(account != address(0));
593         _pausers.add(account);
594         emit PauserAdded(account);
595     }
596 
597     function _removePauser(address account) private {
598         require(account != address(0));
599         _pausers.remove(account);
600         emit PauserRemoved(account);
601     }
602 
603 
604     // =========================================================================
605     // === Overridden ERC20 functionality
606     // =========================================================================
607 
608     /**
609      * Ensure there is no way for the contract to end up with no owner. That would inadvertently result in
610      * pauser administration becoming impossible. We override this to always disallow it.
611      */
612     function renounceOwnership() public onlyOwner {
613         require(false, "forbidden");
614     }
615 
616     /**
617      * @dev Allows the current owner to transfer control of the contract to a newOwner.
618      * @param newOwner The address to transfer ownership to.
619      */
620     function transferOwnership(address newOwner) public onlyOwner {
621         _removePauser(msg.sender);
622         super.transferOwnership(newOwner);
623         _addPauser(newOwner);
624     }
625 }
626 
627 
628 pragma solidity ^0.5.2;
629 
630 
631 /**
632  * @title Pausable
633  * @dev Base contract which allows children to implement an emergency stop mechanism.
634  */
635 contract Pausable is PauserRole {
636     event Paused(address account);
637     event Unpaused(address account);
638 
639     bool private _paused;
640 
641     constructor () internal {
642         _paused = false;
643     }
644 
645     /**
646      * @return True if the contract is paused, false otherwise.
647      */
648     function paused() public view returns (bool) {
649         return _paused;
650     }
651 
652     /**
653      * @dev Modifier to make a function callable only when the contract is not paused.
654      */
655     modifier whenNotPaused() {
656         require(!_paused);
657         _;
658     }
659 
660     /**
661      * @dev Modifier to make a function callable only when the contract is paused.
662      */
663     modifier whenPaused() {
664         require(_paused);
665         _;
666     }
667 
668     /**
669      * @dev Called by a pauser to pause, triggers stopped state.
670      */
671     function pause() public onlyPauser whenNotPaused {
672         _paused = true;
673         emit Paused(msg.sender);
674     }
675 
676     /**
677      * @dev Called by a pauser to unpause, returns to normal state.
678      */
679     function unpause() public onlyPauser whenPaused {
680         _paused = false;
681         emit Unpaused(msg.sender);
682     }
683 }
684 
685 
686 pragma solidity ^0.5.2;
687 
688 
689 /**
690  * @title Pausable token
691  * @dev ERC20 modified with pausable transfers.
692  */
693 contract ERC20Pausable is ERC20, Pausable {
694     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
695         return super.transfer(to, value);
696     }
697 
698     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
699         return super.transferFrom(from, to, value);
700     }
701 
702     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
703         return super.approve(spender, value);
704     }
705 
706     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
707         return super.increaseAllowance(spender, addedValue);
708     }
709 
710     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
711         return super.decreaseAllowance(spender, subtractedValue);
712     }
713 }
714 
715 
716 pragma solidity ^0.5.7;
717 
718 
719 contract VerifiedAccount is ERC20, Ownable {
720 
721     mapping(address => bool) private _isRegistered;
722 
723     constructor () internal {
724         // The smart contract starts off registering itself, since address is known.
725         registerAccount();
726     }
727 
728     event AccountRegistered(address indexed account);
729 
730     /**
731      * This registers the calling wallet address as a known address. Operations that transfer responsibility
732      * may require the target account to be a registered account, to protect the system from getting into a
733      * state where administration or a large amount of funds can become forever inaccessible.
734      */
735     function registerAccount() public returns (bool ok) {
736         _isRegistered[msg.sender] = true;
737         emit AccountRegistered(msg.sender);
738         return true;
739     }
740 
741     function isRegistered(address account) public view returns (bool ok) {
742         return _isRegistered[account];
743     }
744 
745     function _accountExists(address account) internal view returns (bool exists) {
746         return account == msg.sender || _isRegistered[account];
747     }
748 
749     modifier onlySafeAccount(address account) {
750         require(_accountExists(account), "account not registered");
751         _;
752     }
753 
754 
755     // =========================================================================
756     // === Safe ERC20 methods
757     // =========================================================================
758 
759     function safeTransfer(address to, uint256 value) public onlySafeAccount(to) returns (bool ok) {
760         transfer(to, value);
761         return true;
762     }
763 
764     function safeApprove(address spender, uint256 value) public onlySafeAccount(spender) returns (bool ok) {
765         approve(spender, value);
766         return true;
767     }
768 
769     function safeTransferFrom(address from, address to, uint256 value) public onlySafeAccount(to) returns (bool ok) {
770         transferFrom(from, to, value);
771         return true;
772     }
773 
774 
775     // =========================================================================
776     // === Safe ownership transfer
777     // =========================================================================
778 
779     /**
780      * @dev Allows the current owner to transfer control of the contract to a newOwner.
781      * @param newOwner The address to transfer ownership to.
782      */
783     function transferOwnership(address newOwner) public onlySafeAccount(newOwner) onlyOwner {
784         super.transferOwnership(newOwner);
785     }
786 }
787 
788 
789 pragma solidity ^0.5.7;
790 
791 
792 /**
793  * @dev GrantorRole trait
794  *
795  * This adds support for a role that allows creation of vesting token grants, allocated from the
796  * role holder's wallet.
797  *
798  * NOTE: We have implemented a role model only the contract owner can assign/un-assign roles.
799  * This is necessary to support enterprise software, which requires a permissions model in which
800  * roles can be owner-administered, in contrast to a blockchain community approach in which
801  * permissions can be self-administered. Therefore, this implementation replaces the self-service
802  * "renounce" approach with one where only the owner is allowed to makes role changes.
803  *
804  * Owner is not allowed to renounce ownership, lest the contract go without administration. But
805  * it is ok for owner to shed initially granted roles by removing role from self.
806  */
807 contract GrantorRole is Ownable {
808     bool private constant OWNER_UNIFORM_GRANTOR_FLAG = false;
809 
810     using Roles for Roles.Role;
811 
812     event GrantorAdded(address indexed account);
813     event GrantorRemoved(address indexed account);
814 
815     Roles.Role private _grantors;
816     mapping(address => bool) private _isUniformGrantor;
817 
818     constructor () internal {
819         _addGrantor(msg.sender, OWNER_UNIFORM_GRANTOR_FLAG);
820     }
821 
822     modifier onlyGrantor() {
823         require(isGrantor(msg.sender), "onlyGrantor");
824         _;
825     }
826 
827     modifier onlyGrantorOrSelf(address account) {
828         require(isGrantor(msg.sender) || msg.sender == account, "onlyGrantorOrSelf");
829         _;
830     }
831 
832     function isGrantor(address account) public view returns (bool) {
833         return _grantors.has(account);
834     }
835 
836     function addGrantor(address account, bool isUniformGrantor) public onlyOwner {
837         _addGrantor(account, isUniformGrantor);
838     }
839 
840     function removeGrantor(address account) public onlyOwner {
841         _removeGrantor(account);
842     }
843 
844     function _addGrantor(address account, bool isUniformGrantor) private {
845         require(account != address(0));
846         _grantors.add(account);
847         _isUniformGrantor[account] = isUniformGrantor;
848         emit GrantorAdded(account);
849     }
850 
851     function _removeGrantor(address account) private {
852         require(account != address(0));
853         _grantors.remove(account);
854         emit GrantorRemoved(account);
855     }
856 
857     function isUniformGrantor(address account) public view returns (bool) {
858         return isGrantor(account) && _isUniformGrantor[account];
859     }
860 
861     modifier onlyUniformGrantor() {
862         require(isUniformGrantor(msg.sender), "Only uniform grantor role can do this.");
863         // Only grantor role can do this.
864         _;
865     }
866 
867 
868     // =========================================================================
869     // === Overridden ERC20 functionality
870     // =========================================================================
871 
872     /**
873      * Ensure there is no way for the contract to end up with no owner. That would inadvertently result in
874      * token grant administration becoming impossible. We override this to always disallow it.
875      */
876     function renounceOwnership() public onlyOwner {
877         require(false, "forbidden");
878     }
879 
880     /**
881      * @dev Allows the current owner to transfer control of the contract to a newOwner.
882      * @param newOwner The address to transfer ownership to.
883      */
884     function transferOwnership(address newOwner) public onlyOwner {
885         _removeGrantor(msg.sender);
886         super.transferOwnership(newOwner);
887         _addGrantor(newOwner, OWNER_UNIFORM_GRANTOR_FLAG);
888     }
889 }
890 
891 
892 pragma solidity ^0.5.7;
893 
894 
895 interface IERC20Vestable {
896     function getIntrinsicVestingSchedule(address grantHolder)
897     external
898     view
899     returns (
900         uint32 cliffDuration,
901         uint32 vestDuration,
902         uint32 vestIntervalDays
903     );
904 
905     function grantVestingTokens(
906         address beneficiary,
907         uint256 totalAmount,
908         uint256 vestingAmount,
909         uint32 startDay,
910         uint32 duration,
911         uint32 cliffDuration,
912         uint32 interval,
913         bool isRevocable
914     ) external returns (bool ok);
915 
916     function today() external view returns (uint32 dayNumber);
917 
918     function vestingForAccountAsOf(
919         address grantHolder,
920         uint32 onDayOrToday
921     )
922     external
923     view
924     returns (
925         uint256 amountVested,
926         uint256 amountNotVested,
927         uint256 amountOfGrant,
928         uint32 vestStartDay,
929         uint32 cliffDuration,
930         uint32 vestDuration,
931         uint32 vestIntervalDays,
932         bool isActive,
933         bool wasRevoked
934     );
935 
936     function vestingAsOf(uint32 onDayOrToday) external view returns (
937         uint256 amountVested,
938         uint256 amountNotVested,
939         uint256 amountOfGrant,
940         uint32 vestStartDay,
941         uint32 cliffDuration,
942         uint32 vestDuration,
943         uint32 vestIntervalDays,
944         bool isActive,
945         bool wasRevoked
946     );
947 
948     function revokeGrant(address grantHolder, uint32 onDay) external returns (bool);
949 
950 
951     event VestingScheduleCreated(
952         address indexed vestingLocation,
953         uint32 cliffDuration, uint32 indexed duration, uint32 interval,
954         bool indexed isRevocable);
955 
956     event VestingTokensGranted(
957         address indexed beneficiary,
958         uint256 indexed vestingAmount,
959         uint32 startDay,
960         address vestingLocation,
961         address indexed grantor);
962 
963     event GrantRevoked(address indexed grantHolder, uint32 indexed onDay);
964 }
965 
966 
967 pragma solidity ^0.5.7;
968 
969 
970 /**
971  * @title Contract for grantable ERC20 token vesting schedules
972  *
973  * @notice Adds to an ERC20 support for grantor wallets, which are able to grant vesting tokens to
974  *   beneficiary wallets, following per-wallet custom vesting schedules.
975  *
976  * @dev Contract which gives subclass contracts the ability to act as a pool of funds for allocating
977  *   tokens to any number of other addresses. Token grants support the ability to vest over time in
978  *   accordance a predefined vesting schedule. A given wallet can receive no more than one token grant.
979  *
980  *   Tokens are transferred from the pool to the recipient at the time of grant, but the recipient
981  *   will only able to transfer tokens out of their wallet after they have vested. Transfers of non-
982  *   vested tokens are prevented.
983  *
984  *   Two types of toke grants are supported:
985  *   - Irrevocable grants, intended for use in cases when vesting tokens have been issued in exchange
986  *     for value, such as with tokens that have been purchased in an ICO.
987  *   - Revocable grants, intended for use in cases when vesting tokens have been gifted to the holder,
988  *     such as with employee grants that are given as compensation.
989  */
990 contract ERC20Vestable is ERC20, VerifiedAccount, GrantorRole, IERC20Vestable {
991     using SafeMath for uint256;
992 
993     // Date-related constants for sanity-checking dates to reject obvious erroneous inputs
994     // and conversions from seconds to days and years that are more or less leap year-aware.
995     uint32 private constant THOUSAND_YEARS_DAYS = 365243;                   /* See https://www.timeanddate.com/date/durationresult.html?m1=1&d1=1&y1=2000&m2=1&d2=1&y2=3000 */
996     uint32 private constant TEN_YEARS_DAYS = THOUSAND_YEARS_DAYS / 100;     /* Includes leap years (though it doesn't really matter) */
997     uint32 private constant SECONDS_PER_DAY = 24 * 60 * 60;                 /* 86400 seconds in a day */
998     uint32 private constant JAN_1_2000_SECONDS = 946684800;                 /* Saturday, January 1, 2000 0:00:00 (GMT) (see https://www.epochconverter.com/) */
999     uint32 private constant JAN_1_2000_DAYS = JAN_1_2000_SECONDS / SECONDS_PER_DAY;
1000     uint32 private constant JAN_1_3000_DAYS = JAN_1_2000_DAYS + THOUSAND_YEARS_DAYS;
1001 
1002     struct vestingSchedule {
1003         bool isValid;               /* true if an entry exists and is valid */
1004         bool isRevocable;           /* true if the vesting option is revocable (a gift), false if irrevocable (purchased) */
1005         uint32 cliffDuration;       /* Duration of the cliff, with respect to the grant start day, in days. */
1006         uint32 duration;            /* Duration of the vesting schedule, with respect to the grant start day, in days. */
1007         uint32 interval;            /* Duration in days of the vesting interval. */
1008     }
1009 
1010     struct tokenGrant {
1011         bool isActive;              /* true if this vesting entry is active and in-effect entry. */
1012         bool wasRevoked;            /* true if this vesting schedule was revoked. */
1013         uint32 startDay;            /* Start day of the grant, in days since the UNIX epoch (start of day). */
1014         uint256 amount;             /* Total number of tokens that vest. */
1015         address vestingLocation;    /* Address of wallet that is holding the vesting schedule. */
1016         address grantor;            /* Grantor that made the grant */
1017     }
1018 
1019     mapping(address => vestingSchedule) private _vestingSchedules;
1020     mapping(address => tokenGrant) private _tokenGrants;
1021 
1022 
1023     // =========================================================================
1024     // === Methods for administratively creating a vesting schedule for an account.
1025     // =========================================================================
1026 
1027     /**
1028      * @dev This one-time operation permanently establishes a vesting schedule in the given account.
1029      *
1030      * For standard grants, this establishes the vesting schedule in the beneficiary's account.
1031      * For uniform grants, this establishes the vesting schedule in the linked grantor's account.
1032      *
1033      * @param vestingLocation = Account into which to store the vesting schedule. Can be the account
1034      *   of the beneficiary (for one-off grants) or the account of the grantor (for uniform grants
1035      *   made from grant pools).
1036      * @param cliffDuration = Duration of the cliff, with respect to the grant start day, in days.
1037      * @param duration = Duration of the vesting schedule, with respect to the grant start day, in days.
1038      * @param interval = Number of days between vesting increases.
1039      * @param isRevocable = True if the grant can be revoked (i.e. was a gift) or false if it cannot
1040      *   be revoked (i.e. tokens were purchased).
1041      */
1042     function _setVestingSchedule(
1043         address vestingLocation,
1044         uint32 cliffDuration, uint32 duration, uint32 interval,
1045         bool isRevocable) internal returns (bool ok) {
1046 
1047         // Check for a valid vesting schedule given (disallow absurd values to reject likely bad input).
1048         require(
1049             duration > 0 && duration <= TEN_YEARS_DAYS
1050             && cliffDuration < duration
1051             && interval >= 1,
1052             "invalid vesting schedule"
1053         );
1054 
1055         // Make sure the duration values are in harmony with interval (both should be an exact multiple of interval).
1056         require(
1057             duration % interval == 0 && cliffDuration % interval == 0,
1058             "invalid cliff/duration for interval"
1059         );
1060 
1061         // Create and populate a vesting schedule.
1062         _vestingSchedules[vestingLocation] = vestingSchedule(
1063             true/*isValid*/,
1064             isRevocable,
1065             cliffDuration, duration, interval
1066         );
1067 
1068         // Emit the event and return success.
1069         emit VestingScheduleCreated(
1070             vestingLocation,
1071             cliffDuration, duration, interval,
1072             isRevocable);
1073         return true;
1074     }
1075 
1076     function _hasVestingSchedule(address account) internal view returns (bool ok) {
1077         return _vestingSchedules[account].isValid;
1078     }
1079 
1080     /**
1081      * @dev returns all information about the vesting schedule directly associated with the given
1082      * account. This can be used to double check that a uniform grantor has been set up with a
1083      * correct vesting schedule. Also, recipients of standard (non-uniform) grants can use this.
1084      * This method is only callable by the account holder or a grantor, so this is mainly intended
1085      * for administrative use.
1086      *
1087      * Holders of uniform grants must use vestingAsOf() to view their vesting schedule, as it is
1088      * stored in the grantor account.
1089      *
1090      * @param grantHolder = The address to do this for.
1091      *   the special value 0 to indicate today.
1092      * @return = A tuple with the following values:
1093      *   vestDuration = grant duration in days.
1094      *   cliffDuration = duration of the cliff.
1095      *   vestIntervalDays = number of days between vesting periods.
1096      */
1097     function getIntrinsicVestingSchedule(address grantHolder)
1098     public
1099     view
1100     onlyGrantorOrSelf(grantHolder)
1101     returns (
1102         uint32 vestDuration,
1103         uint32 cliffDuration,
1104         uint32 vestIntervalDays
1105     )
1106     {
1107         return (
1108         _vestingSchedules[grantHolder].duration,
1109         _vestingSchedules[grantHolder].cliffDuration,
1110         _vestingSchedules[grantHolder].interval
1111         );
1112     }
1113 
1114 
1115     // =========================================================================
1116     // === Token grants (general-purpose)
1117     // === Methods to be used for administratively creating one-off token grants with vesting schedules.
1118     // =========================================================================
1119 
1120     /**
1121      * @dev Immediately grants tokens to an account, referencing a vesting schedule which may be
1122      * stored in the same account (individual/one-off) or in a different account (shared/uniform).
1123      *
1124      * @param beneficiary = Address to which tokens will be granted.
1125      * @param totalAmount = Total number of tokens to deposit into the account.
1126      * @param vestingAmount = Out of totalAmount, the number of tokens subject to vesting.
1127      * @param startDay = Start day of the grant's vesting schedule, in days since the UNIX epoch
1128      *   (start of day). The startDay may be given as a date in the future or in the past, going as far
1129      *   back as year 2000.
1130      * @param vestingLocation = Account where the vesting schedule is held (must already exist).
1131      * @param grantor = Account which performed the grant. Also the account from where the granted
1132      *   funds will be withdrawn.
1133      */
1134     function _grantVestingTokens(
1135         address beneficiary,
1136         uint256 totalAmount,
1137         uint256 vestingAmount,
1138         uint32 startDay,
1139         address vestingLocation,
1140         address grantor
1141     )
1142     internal returns (bool ok)
1143     {
1144         // Make sure no prior grant is in effect.
1145         require(!_tokenGrants[beneficiary].isActive, "grant already exists");
1146 
1147         // Check for valid vestingAmount
1148         require(
1149             vestingAmount <= totalAmount && vestingAmount > 0
1150             && startDay >= JAN_1_2000_DAYS && startDay < JAN_1_3000_DAYS,
1151             "invalid vesting params");
1152 
1153         // Make sure the vesting schedule we are about to use is valid.
1154         require(_hasVestingSchedule(vestingLocation), "no such vesting schedule");
1155 
1156         // Transfer the total number of tokens from grantor into the account's holdings.
1157         _transfer(grantor, beneficiary, totalAmount);
1158         /* Emits a Transfer event. */
1159 
1160         // Create and populate a token grant, referencing vesting schedule.
1161         _tokenGrants[beneficiary] = tokenGrant(
1162             true/*isActive*/,
1163             false/*wasRevoked*/,
1164             startDay,
1165             vestingAmount,
1166             vestingLocation, /* The wallet address where the vesting schedule is kept. */
1167             grantor             /* The account that performed the grant (where revoked funds would be sent) */
1168         );
1169 
1170         // Emit the event and return success.
1171         emit VestingTokensGranted(beneficiary, vestingAmount, startDay, vestingLocation, grantor);
1172         return true;
1173     }
1174 
1175     /**
1176      * @dev Immediately grants tokens to an address, including a portion that will vest over time
1177      * according to a set vesting schedule. The overall duration and cliff duration of the grant must
1178      * be an even multiple of the vesting interval.
1179      *
1180      * @param beneficiary = Address to which tokens will be granted.
1181      * @param totalAmount = Total number of tokens to deposit into the account.
1182      * @param vestingAmount = Out of totalAmount, the number of tokens subject to vesting.
1183      * @param startDay = Start day of the grant's vesting schedule, in days since the UNIX epoch
1184      *   (start of day). The startDay may be given as a date in the future or in the past, going as far
1185      *   back as year 2000.
1186      * @param duration = Duration of the vesting schedule, with respect to the grant start day, in days.
1187      * @param cliffDuration = Duration of the cliff, with respect to the grant start day, in days.
1188      * @param interval = Number of days between vesting increases.
1189      * @param isRevocable = True if the grant can be revoked (i.e. was a gift) or false if it cannot
1190      *   be revoked (i.e. tokens were purchased).
1191      */
1192     function grantVestingTokens(
1193         address beneficiary,
1194         uint256 totalAmount,
1195         uint256 vestingAmount,
1196         uint32 startDay,
1197         uint32 duration,
1198         uint32 cliffDuration,
1199         uint32 interval,
1200         bool isRevocable
1201     ) public onlyGrantor returns (bool ok) {
1202         // Make sure no prior vesting schedule has been set.
1203         require(!_tokenGrants[beneficiary].isActive, "grant already exists");
1204 
1205         // The vesting schedule is unique to this wallet and so will be stored here,
1206         _setVestingSchedule(beneficiary, cliffDuration, duration, interval, isRevocable);
1207 
1208         // Issue grantor tokens to the beneficiary, using beneficiary's own vesting schedule.
1209         _grantVestingTokens(beneficiary, totalAmount, vestingAmount, startDay, beneficiary, msg.sender);
1210 
1211         return true;
1212     }
1213 
1214     /**
1215      * @dev This variant only grants tokens if the beneficiary account has previously self-registered.
1216      */
1217     function safeGrantVestingTokens(
1218         address beneficiary, uint256 totalAmount, uint256 vestingAmount,
1219         uint32 startDay, uint32 duration, uint32 cliffDuration, uint32 interval,
1220         bool isRevocable) public onlyGrantor onlySafeAccount(beneficiary) returns (bool ok) {
1221 
1222         return grantVestingTokens(
1223             beneficiary, totalAmount, vestingAmount,
1224             startDay, duration, cliffDuration, interval,
1225             isRevocable);
1226     }
1227 
1228 
1229     // =========================================================================
1230     // === Check vesting.
1231     // =========================================================================
1232 
1233     /**
1234      * @dev returns the day number of the current day, in days since the UNIX epoch.
1235      */
1236     function today() public view returns (uint32 dayNumber) {
1237         return uint32(block.timestamp / SECONDS_PER_DAY);
1238     }
1239 
1240     function _effectiveDay(uint32 onDayOrToday) internal view returns (uint32 dayNumber) {
1241         return onDayOrToday == 0 ? today() : onDayOrToday;
1242     }
1243 
1244     /**
1245      * @dev Determines the amount of tokens that have not vested in the given account.
1246      *
1247      * The math is: not vested amount = vesting amount * (end date - on date)/(end date - start date)
1248      *
1249      * @param grantHolder = The account to check.
1250      * @param onDayOrToday = The day to check for, in days since the UNIX epoch. Can pass
1251      *   the special value 0 to indicate today.
1252      */
1253     function _getNotVestedAmount(address grantHolder, uint32 onDayOrToday) internal view returns (uint256 amountNotVested) {
1254         tokenGrant storage grant = _tokenGrants[grantHolder];
1255         vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
1256         uint32 onDay = _effectiveDay(onDayOrToday);
1257 
1258         // If there's no schedule, or before the vesting cliff, then the full amount is not vested.
1259         if (!grant.isActive || onDay < grant.startDay + vesting.cliffDuration)
1260         {
1261             // None are vested (all are not vested)
1262             return grant.amount;
1263         }
1264         // If after end of vesting, then the not vested amount is zero (all are vested).
1265         else if (onDay >= grant.startDay + vesting.duration)
1266         {
1267             // All are vested (none are not vested)
1268             return uint256(0);
1269         }
1270         // Otherwise a fractional amount is vested.
1271         else
1272         {
1273             // Compute the exact number of days vested.
1274             uint32 daysVested = onDay - grant.startDay;
1275             // Adjust result rounding down to take into consideration the interval.
1276             uint32 effectiveDaysVested = (daysVested / vesting.interval) * vesting.interval;
1277 
1278             // Compute the fraction vested from schedule using 224.32 fixed point math for date range ratio.
1279             // Note: This is safe in 256-bit math because max value of X billion tokens = X*10^27 wei, and
1280             // typical token amounts can fit into 90 bits. Scaling using a 32 bits value results in only 125
1281             // bits before reducing back to 90 bits by dividing. There is plenty of room left, even for token
1282             // amounts many orders of magnitude greater than mere billions.
1283             uint256 vested = grant.amount.mul(effectiveDaysVested).div(vesting.duration);
1284             return grant.amount.sub(vested);
1285         }
1286     }
1287 
1288     /**
1289      * @dev Computes the amount of funds in the given account which are available for use as of
1290      * the given day. If there's no vesting schedule then 0 tokens are considered to be vested and
1291      * this just returns the full account balance.
1292      *
1293      * The math is: available amount = total funds - notVestedAmount.
1294      *
1295      * @param grantHolder = The account to check.
1296      * @param onDay = The day to check for, in days since the UNIX epoch.
1297      */
1298     function _getAvailableAmount(address grantHolder, uint32 onDay) internal view returns (uint256 amountAvailable) {
1299         uint256 totalTokens = balanceOf(grantHolder);
1300         uint256 vested = totalTokens.sub(_getNotVestedAmount(grantHolder, onDay));
1301         return vested;
1302     }
1303 
1304     /**
1305      * @dev returns all information about the grant's vesting as of the given day
1306      * for the given account. Only callable by the account holder or a grantor, so
1307      * this is mainly intended for administrative use.
1308      *
1309      * @param grantHolder = The address to do this for.
1310      * @param onDayOrToday = The day to check for, in days since the UNIX epoch. Can pass
1311      *   the special value 0 to indicate today.
1312      * @return = A tuple with the following values:
1313      *   amountVested = the amount out of vestingAmount that is vested
1314      *   amountNotVested = the amount that is vested (equal to vestingAmount - vestedAmount)
1315      *   amountOfGrant = the amount of tokens subject to vesting.
1316      *   vestStartDay = starting day of the grant (in days since the UNIX epoch).
1317      *   vestDuration = grant duration in days.
1318      *   cliffDuration = duration of the cliff.
1319      *   vestIntervalDays = number of days between vesting periods.
1320      *   isActive = true if the vesting schedule is currently active.
1321      *   wasRevoked = true if the vesting schedule was revoked.
1322      */
1323     function vestingForAccountAsOf(
1324         address grantHolder,
1325         uint32 onDayOrToday
1326     )
1327     public
1328     view
1329     onlyGrantorOrSelf(grantHolder)
1330     returns (
1331         uint256 amountVested,
1332         uint256 amountNotVested,
1333         uint256 amountOfGrant,
1334         uint32 vestStartDay,
1335         uint32 vestDuration,
1336         uint32 cliffDuration,
1337         uint32 vestIntervalDays,
1338         bool isActive,
1339         bool wasRevoked
1340     )
1341     {
1342         tokenGrant storage grant = _tokenGrants[grantHolder];
1343         vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
1344         uint256 notVestedAmount = _getNotVestedAmount(grantHolder, onDayOrToday);
1345         uint256 grantAmount = grant.amount;
1346 
1347         return (
1348         grantAmount.sub(notVestedAmount),
1349         notVestedAmount,
1350         grantAmount,
1351         grant.startDay,
1352         vesting.duration,
1353         vesting.cliffDuration,
1354         vesting.interval,
1355         grant.isActive,
1356         grant.wasRevoked
1357         );
1358     }
1359 
1360     /**
1361      * @dev returns all information about the grant's vesting as of the given day
1362      * for the current account, to be called by the account holder.
1363      *
1364      * @param onDayOrToday = The day to check for, in days since the UNIX epoch. Can pass
1365      *   the special value 0 to indicate today.
1366      * @return = A tuple with the following values:
1367      *   amountVested = the amount out of vestingAmount that is vested
1368      *   amountNotVested = the amount that is vested (equal to vestingAmount - vestedAmount)
1369      *   amountOfGrant = the amount of tokens subject to vesting.
1370      *   vestStartDay = starting day of the grant (in days since the UNIX epoch).
1371      *   cliffDuration = duration of the cliff.
1372      *   vestDuration = grant duration in days.
1373      *   vestIntervalDays = number of days between vesting periods.
1374      *   isActive = true if the vesting schedule is currently active.
1375      *   wasRevoked = true if the vesting schedule was revoked.
1376      */
1377     function vestingAsOf(uint32 onDayOrToday) public view returns (
1378         uint256 amountVested,
1379         uint256 amountNotVested,
1380         uint256 amountOfGrant,
1381         uint32 vestStartDay,
1382         uint32 cliffDuration,
1383         uint32 vestDuration,
1384         uint32 vestIntervalDays,
1385         bool isActive,
1386         bool wasRevoked
1387     )
1388     {
1389         return vestingForAccountAsOf(msg.sender, onDayOrToday);
1390     }
1391 
1392     /**
1393      * @dev returns true if the account has sufficient funds available to cover the given amount,
1394      *   including consideration for vesting tokens.
1395      *
1396      * @param account = The account to check.
1397      * @param amount = The required amount of vested funds.
1398      * @param onDay = The day to check for, in days since the UNIX epoch.
1399      */
1400     function _fundsAreAvailableOn(address account, uint256 amount, uint32 onDay) internal view returns (bool ok) {
1401         return (amount <= _getAvailableAmount(account, onDay));
1402     }
1403 
1404     /**
1405      * @dev Modifier to make a function callable only when the amount is sufficiently vested right now.
1406      *
1407      * @param account = The account to check.
1408      * @param amount = The required amount of vested funds.
1409      */
1410     modifier onlyIfFundsAvailableNow(address account, uint256 amount) {
1411         // Distinguish insufficient overall balance from insufficient vested funds balance in failure msg.
1412         require(_fundsAreAvailableOn(account, amount, today()),
1413             balanceOf(account) < amount ? "insufficient funds" : "insufficient vested funds");
1414         _;
1415     }
1416 
1417 
1418     // =========================================================================
1419     // === Grant revocation
1420     // =========================================================================
1421 
1422     /**
1423      * @dev If the account has a revocable grant, this forces the grant to end based on computing
1424      * the amount vested up to the given date. All tokens that would no longer vest are returned
1425      * to the account of the original grantor.
1426      *
1427      * @param grantHolder = Address to which tokens will be granted.
1428      * @param onDay = The date upon which the vesting schedule will be effectively terminated,
1429      *   in days since the UNIX epoch (start of day).
1430      */
1431     function revokeGrant(address grantHolder, uint32 onDay) public onlyGrantor returns (bool ok) {
1432         tokenGrant storage grant = _tokenGrants[grantHolder];
1433         vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
1434         uint256 notVestedAmount;
1435 
1436         // Make sure grantor can only revoke from own pool.
1437         require(msg.sender == owner() || msg.sender == grant.grantor, "not allowed");
1438         // Make sure a vesting schedule has previously been set.
1439         require(grant.isActive, "no active vesting schedule");
1440         // Make sure it's revocable.
1441         require(vesting.isRevocable, "irrevocable");
1442         // Fail on likely erroneous input.
1443         require(onDay <= grant.startDay + vesting.duration, "no effect");
1444         // Don"t let grantor revoke anf portion of vested amount.
1445         require(onDay >= today(), "cannot revoke vested holdings");
1446 
1447         notVestedAmount = _getNotVestedAmount(grantHolder, onDay);
1448 
1449         // Use ERC20 _approve() to forcibly approve grantor to take back not-vested tokens from grantHolder.
1450         _approve(grantHolder, grant.grantor, notVestedAmount);
1451         /* Emits an Approval Event. */
1452         transferFrom(grantHolder, grant.grantor, notVestedAmount);
1453         /* Emits a Transfer and an Approval Event. */
1454 
1455         // Kill the grant by updating wasRevoked and isActive.
1456         _tokenGrants[grantHolder].wasRevoked = true;
1457         _tokenGrants[grantHolder].isActive = false;
1458 
1459         emit GrantRevoked(grantHolder, onDay);
1460         /* Emits the GrantRevoked event. */
1461         return true;
1462     }
1463 
1464 
1465     // =========================================================================
1466     // === Overridden ERC20 functionality
1467     // =========================================================================
1468 
1469     /**
1470      * @dev Methods transfer() and approve() require an additional available funds check to
1471      * prevent spending held but non-vested tokens. Note that transferFrom() does NOT have this
1472      * additional check because approved funds come from an already set-aside allowance, not from the wallet.
1473      */
1474     function transfer(address to, uint256 value) public onlyIfFundsAvailableNow(msg.sender, value) returns (bool ok) {
1475         return super.transfer(to, value);
1476     }
1477 
1478     /**
1479      * @dev Additional available funds check to prevent spending held but non-vested tokens.
1480      */
1481     function approve(address spender, uint256 value) public onlyIfFundsAvailableNow(msg.sender, value) returns (bool ok) {
1482         return super.approve(spender, value);
1483     }
1484 }
1485 
1486 
1487 pragma solidity ^0.5.7;
1488 
1489 
1490 /**
1491  * @title Contract for uniform granting of vesting tokens
1492  *
1493  * @notice Adds methods for programmatic creation of uniform or standard token vesting grants.
1494  *
1495  * @dev This is primarily for use by exchanges and scripted internal employee incentive grant creation.
1496  */
1497 contract UniformTokenGrantor is ERC20Vestable {
1498 
1499     struct restrictions {
1500         bool isValid;
1501         uint32 minStartDay;        /* The smallest value for startDay allowed in grant creation. */
1502         uint32 maxStartDay;        /* The maximum value for startDay allowed in grant creation. */
1503         uint32 expirationDay;       /* The last day this grantor may make grants. */
1504     }
1505 
1506     mapping(address => restrictions) private _restrictions;
1507 
1508 
1509     // =========================================================================
1510     // === Uniform token grant setup
1511     // === Methods used by owner to set up uniform grants on restricted grantor
1512     // =========================================================================
1513 
1514     event GrantorRestrictionsSet(
1515         address indexed grantor,
1516         uint32 minStartDay,
1517         uint32 maxStartDay,
1518         uint32 expirationDay);
1519 
1520     /**
1521      * @dev Lets owner set or change existing specific restrictions. Restrictions must be established
1522      * before the grantor will be allowed to issue grants.
1523      *
1524      * All date values are expressed as number of days since the UNIX epoch. Note that the inputs are
1525      * themselves not very thoroughly restricted. However, this method can be called more than once
1526      * if incorrect values need to be changed, or to extend a grantor's expiration date.
1527      *
1528      * @param grantor = Address which will receive the uniform grantable vesting schedule.
1529      * @param minStartDay = The smallest value for startDay allowed in grant creation.
1530      * @param maxStartDay = The maximum value for startDay allowed in grant creation.
1531      * @param expirationDay = The last day this grantor may make grants.
1532      */
1533     function setRestrictions(
1534         address grantor,
1535         uint32 minStartDay,
1536         uint32 maxStartDay,
1537         uint32 expirationDay
1538     )
1539     public
1540     onlyOwner
1541     onlySafeAccount(grantor)
1542     returns (bool ok)
1543     {
1544         require(
1545             isUniformGrantor(grantor)
1546          && maxStartDay > minStartDay
1547          && expirationDay > today(), "invalid params");
1548 
1549         // We allow owner to set or change existing specific restrictions.
1550         _restrictions[grantor] = restrictions(
1551             true/*isValid*/,
1552             minStartDay,
1553             maxStartDay,
1554             expirationDay
1555         );
1556 
1557         // Emit the event and return success.
1558         emit GrantorRestrictionsSet(grantor, minStartDay, maxStartDay, expirationDay);
1559         return true;
1560     }
1561 
1562     /**
1563      * @dev Lets owner permanently establish a vesting schedule for a restricted grantor to use when
1564      * creating uniform token grants. Grantee accounts forever refer to the grantor's account to look up
1565      * vesting, so this method can only be used once per grantor.
1566      *
1567      * @param grantor = Address which will receive the uniform grantable vesting schedule.
1568      * @param duration = Duration of the vesting schedule, with respect to the grant start day, in days.
1569      * @param cliffDuration = Duration of the cliff, with respect to the grant start day, in days.
1570      * @param interval = Number of days between vesting increases.
1571      * @param isRevocable = True if the grant can be revoked (i.e. was a gift) or false if it cannot
1572      *   be revoked (i.e. tokens were purchased).
1573      */
1574     function setGrantorVestingSchedule(
1575         address grantor,
1576         uint32 duration,
1577         uint32 cliffDuration,
1578         uint32 interval,
1579         bool isRevocable
1580     )
1581     public
1582     onlyOwner
1583     onlySafeAccount(grantor)
1584     returns (bool ok)
1585     {
1586         // Only allow doing this to restricted grantor role account.
1587         require(isUniformGrantor(grantor), "uniform grantor only");
1588         // Make sure no prior vesting schedule has been set!
1589         require(!_hasVestingSchedule(grantor), "schedule already exists");
1590 
1591         // The vesting schedule is unique to this grantor wallet and so will be stored here to be
1592         // referenced by future grants. Emits VestingScheduleCreated event.
1593         _setVestingSchedule(grantor, cliffDuration, duration, interval, isRevocable);
1594 
1595         return true;
1596     }
1597 
1598 
1599     // =========================================================================
1600     // === Uniform token grants
1601     // === Methods to be used by exchanges to use for creating tokens.
1602     // =========================================================================
1603 
1604     function isUniformGrantorWithSchedule(address account) internal view returns (bool ok) {
1605         // Check for grantor that has a uniform vesting schedule already set.
1606         return isUniformGrantor(account) && _hasVestingSchedule(account);
1607     }
1608 
1609     modifier onlyUniformGrantorWithSchedule(address account) {
1610         require(isUniformGrantorWithSchedule(account), "grantor account not ready");
1611         _;
1612     }
1613 
1614     modifier whenGrantorRestrictionsMet(uint32 startDay) {
1615         restrictions storage restriction = _restrictions[msg.sender];
1616         require(restriction.isValid, "set restrictions first");
1617 
1618         require(
1619             startDay >= restriction.minStartDay
1620             && startDay < restriction.maxStartDay, "startDay too early");
1621 
1622         require(today() < restriction.expirationDay, "grantor expired");
1623         _;
1624     }
1625 
1626     /**
1627      * @dev Immediately grants tokens to an address, including a portion that will vest over time
1628      * according to the uniform vesting schedule already established in the grantor's account.
1629      *
1630      * @param beneficiary = Address to which tokens will be granted.
1631      * @param totalAmount = Total number of tokens to deposit into the account.
1632      * @param vestingAmount = Out of totalAmount, the number of tokens subject to vesting.
1633      * @param startDay = Start day of the grant's vesting schedule, in days since the UNIX epoch
1634      *   (start of day). The startDay may be given as a date in the future or in the past, going as far
1635      *   back as year 2000.
1636      */
1637     function grantUniformVestingTokens(
1638         address beneficiary,
1639         uint256 totalAmount,
1640         uint256 vestingAmount,
1641         uint32 startDay
1642     )
1643     public
1644     onlyUniformGrantorWithSchedule(msg.sender)
1645     whenGrantorRestrictionsMet(startDay)
1646     returns (bool ok)
1647     {
1648         // Issue grantor tokens to the beneficiary, using beneficiary's own vesting schedule.
1649         // Emits VestingTokensGranted event.
1650         return _grantVestingTokens(beneficiary, totalAmount, vestingAmount, startDay, msg.sender, msg.sender);
1651     }
1652 
1653     /**
1654      * @dev This variant only grants tokens if the beneficiary account has previously self-registered.
1655      */
1656     function safeGrantUniformVestingTokens(
1657         address beneficiary,
1658         uint256 totalAmount,
1659         uint256 vestingAmount,
1660         uint32 startDay
1661     )
1662     public
1663     onlyUniformGrantorWithSchedule(msg.sender)
1664     whenGrantorRestrictionsMet(startDay)
1665     onlySafeAccount(beneficiary)
1666     returns (bool ok)
1667     {
1668         // Issue grantor tokens to the beneficiary, using beneficiary's own vesting schedule.
1669         // Emits VestingTokensGranted event.
1670         return _grantVestingTokens(beneficiary, totalAmount, vestingAmount, startDay, msg.sender, msg.sender);
1671     }
1672 }
1673 
1674 
1675 pragma solidity ^0.5.7;
1676 
1677 
1678 /**
1679  * @dev An ERC20 implementation of the Dyncoin Proxy Token. All tokens are initially pre-assigned to
1680  * the creator, and can later be distributed freely using transfer transferFrom and other ERC20
1681  * functions.
1682  */
1683 contract ProxyToken is PasswordProtected, Identity, ERC20, ERC20Pausable, ERC20Burnable, ERC20Detailed, UniformTokenGrantor {
1684     uint32 public constant VERSION = 5;
1685 
1686     uint8 private constant DECIMALS = 18;
1687     uint256 private constant TOKEN_WEI = 10 ** uint256(DECIMALS);
1688 
1689     uint256 private constant INITIAL_WHOLE_TOKENS = uint256(5 * (10 ** 9));
1690     uint256 private constant INITIAL_SUPPLY = uint256(INITIAL_WHOLE_TOKENS) * uint256(TOKEN_WEI);
1691 
1692     /**
1693      * @dev Constructor that gives msg.sender all of existing tokens.
1694      */
1695     constructor (string memory defaultPassword) ERC20Detailed("MediaRich.io Dyncoin proxy token", "DYNP", DECIMALS) PasswordProtected(defaultPassword) public {
1696         // This is the only place where we ever mint tokens.
1697         _mint(msg.sender, INITIAL_SUPPLY);
1698     }
1699 
1700     event DepositReceived(address indexed from, uint256 value);
1701 
1702     /**
1703      * fallback function: collect any ether sent to us (whether we asked for it or not).
1704      */
1705     function() payable external {
1706         // Track where unexpected ETH came from so we can follow up later.
1707         emit DepositReceived(msg.sender, msg.value);
1708     }
1709 
1710     /**
1711      * @dev Allow only the owner to burn tokens from the owner's wallet, also decreasing the total
1712      * supply. There is no reason for a token holder to EVER call this method directly. It will be
1713      * used by the future Dyncoin contract to implement the ProxyToken side of of token redemption.
1714      */
1715     function burn(uint256 value) onlyIfFundsAvailableNow(msg.sender, value) public {
1716         // This is the only place where we ever burn tokens.
1717         _burn(msg.sender, value);
1718     }
1719 
1720     /**
1721      * Allow owner to change password.
1722      */
1723     function changePassword(string memory oldPassword, string memory newPassword) onlyOwner public returns (bool ok) {
1724         _changePassword(oldPassword, newPassword);
1725         return true;
1726     }
1727 
1728     /**
1729      * @dev Allow pauser to kill the contract (which must already be paused), with enough restrictions
1730      * in place to ensure this could not happen by accident very easily. ETH is returned to owner wallet.
1731      */
1732     function kill(string memory password) whenPaused onlyPauser onlyValidPassword(password) public returns (bool itsDeadJim) {
1733         require(isPauser(msg.sender), "onlyPauser");
1734         address payable payableOwner = address(uint160(owner()));
1735         selfdestruct(payableOwner);
1736         return true;
1737     }
1738 }