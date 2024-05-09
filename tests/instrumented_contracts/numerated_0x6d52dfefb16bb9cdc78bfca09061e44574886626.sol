1 pragma solidity ^0.5.7;
2 
3 contract Identity {
4     mapping(address => string) private _names;
5 
6     /**
7      * Handy function to associate a short name with the account.
8      */
9     function iAm(string memory shortName) public {
10         _names[msg.sender] = shortName;
11     }
12 
13     /**
14      * Handy function to confirm address of the current account.
15      */
16     function whereAmI() public view returns (address yourAddress) {
17         address myself = msg.sender;
18         return myself;
19     }
20 
21     /**
22      * Handy function to confirm short name of the current account.
23      */
24     function whoAmI() public view returns (string memory yourName) {
25         return (_names[msg.sender]);
26     }
27 }
28 
29 
30 pragma solidity ^0.5.0;
31 
32 /**
33  * @title ERC20 interface
34  * @dev see https://eips.ethereum.org/EIPS/eip-20
35  */
36 interface IERC20 {
37     function transfer(address to, uint256 value) external returns (bool);
38 
39     function approve(address spender, uint256 value) external returns (bool);
40 
41     function transferFrom(address from, address to, uint256 value) external returns (bool);
42 
43     function totalSupply() external view returns (uint256);
44 
45     function balanceOf(address who) external view returns (uint256);
46 
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 
55 pragma solidity ^0.5.0;
56 
57 /**
58  * @title SafeMath
59  * @dev Unsigned math operations with safety checks that revert on error.
60  */
61 library SafeMath {
62     /**
63      * @dev Multiplies two unsigned integers, reverts on overflow.
64      */
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
67         // benefit is lost if 'b' is also tested.
68         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
69         if (a == 0) {
70             return 0;
71         }
72 
73         uint256 c = a * b;
74         require(c / a == b);
75 
76         return c;
77     }
78 
79     /**
80      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
81      */
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Solidity only automatically asserts when dividing by 0
84         require(b > 0);
85         uint256 c = a / b;
86         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87 
88         return c;
89     }
90 
91     /**
92      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
93      */
94     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b <= a, "Insufficient funds");
96         uint256 c = a - b;
97 
98         return c;
99     }
100 
101     /**
102      * @dev Adds two unsigned integers, reverts on overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a);
107 
108         return c;
109     }
110 
111     /**
112      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
113      * reverts when dividing by zero.
114      */
115     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b != 0);
117         return a % b;
118     }
119 }
120 
121 
122 pragma solidity ^0.5.0;
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * https://eips.ethereum.org/EIPS/eip-20
130  * Originally based on code by FirstBlood:
131  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  *
133  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
134  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
135  * compliant implementations may not do it.
136  */
137 contract ERC20 is IERC20 {
138     using SafeMath for uint256;
139 
140     mapping (address => uint256) private _balances;
141 
142     mapping (address => mapping (address => uint256)) private _allowed;
143 
144     uint256 private _totalSupply;
145 
146     /**
147      * @dev Total number of tokens in existence.
148      */
149     function totalSupply() public view returns (uint256) {
150         return _totalSupply;
151     }
152 
153     /**
154      * @dev Gets the balance of the specified address.
155      * @param owner The address to query the balance of.
156      * @return A uint256 representing the amount owned by the passed address.
157      */
158     function balanceOf(address owner) public view returns (uint256) {
159         return _balances[owner];
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param owner address The address which owns the funds.
165      * @param spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address owner, address spender) public view returns (uint256) {
169         return _allowed[owner][spender];
170     }
171 
172     /**
173      * @dev Transfer token to a specified address.
174      * @param to The address to transfer to.
175      * @param value The amount to be transferred.
176      */
177     function transfer(address to, uint256 value) public returns (bool) {
178         _transfer(msg.sender, to, value);
179         return true;
180     }
181 
182     /**
183      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184      * Beware that changing an allowance with this method brings the risk that someone may use both the old
185      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      * @param spender The address which will spend the funds.
189      * @param value The amount of tokens to be spent.
190      */
191     function approve(address spender, uint256 value) public returns (bool) {
192         _approve(msg.sender, spender, value);
193         return true;
194     }
195 
196     /**
197      * @dev Transfer tokens from one address to another.
198      * Note that while this function emits an Approval event, this is not required as per the specification,
199      * and other compliant implementations may not emit the event.
200      * @param from address The address which you want to send tokens from
201      * @param to address The address which you want to transfer to
202      * @param value uint256 the amount of tokens to be transferred
203      */
204     function transferFrom(address from, address to, uint256 value) public returns (bool) {
205         _transfer(from, to, value);
206         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
207         return true;
208     }
209 
210     /**
211      * @dev Increase the amount of tokens that an owner allowed to a spender.
212      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
213      * allowed value is better to use this function to avoid 2 calls (and wait until
214      * the first transaction is mined)
215      * From MonolithDAO Token.sol
216      * Emits an Approval event.
217      * @param spender The address which will spend the funds.
218      * @param addedValue The amount of tokens to increase the allowance by.
219      */
220     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
221         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
222         return true;
223     }
224 
225     /**
226      * @dev Decrease the amount of tokens that an owner allowed to a spender.
227      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
228      * allowed value is better to use this function to avoid 2 calls (and wait until
229      * the first transaction is mined)
230      * From MonolithDAO Token.sol
231      * Emits an Approval event.
232      * @param spender The address which will spend the funds.
233      * @param subtractedValue The amount of tokens to decrease the allowance by.
234      */
235     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
236         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
237         return true;
238     }
239 
240     /**
241      * @dev Transfer token for a specified addresses.
242      * @param from The address to transfer from.
243      * @param to The address to transfer to.
244      * @param value The amount to be transferred.
245      */
246     function _transfer(address from, address to, uint256 value) internal {
247         require(to != address(0));
248 
249         _balances[from] = _balances[from].sub(value);
250         _balances[to] = _balances[to].add(value);
251         emit Transfer(from, to, value);
252     }
253 
254     /**
255      * @dev Internal function that mints an amount of the token and assigns it to
256      * an account. This encapsulates the modification of balances such that the
257      * proper events are emitted.
258      * @param account The account that will receive the created tokens.
259      * @param value The amount that will be created.
260      */
261     function _mint(address account, uint256 value) internal {
262         require(account != address(0));
263 
264         _totalSupply = _totalSupply.add(value);
265         _balances[account] = _balances[account].add(value);
266         emit Transfer(address(0), account, value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account.
272      * @param account The account whose tokens will be burnt.
273      * @param value The amount that will be burnt.
274      */
275     function _burn(address account, uint256 value) internal {
276         require(account != address(0));
277 
278         _totalSupply = _totalSupply.sub(value);
279         _balances[account] = _balances[account].sub(value);
280         emit Transfer(account, address(0), value);
281     }
282 
283     /**
284      * @dev Approve an address to spend another addresses' tokens.
285      * @param owner The address that owns the tokens.
286      * @param spender The address that will spend the tokens.
287      * @param value The number of tokens that can be spent.
288      */
289     function _approve(address owner, address spender, uint256 value) internal {
290         require(owner != address(0));
291         require(spender != address(0));
292 
293         _allowed[owner][spender] = value;
294         emit Approval(owner, spender, value);
295     }
296 
297     /**
298      * @dev Internal function that burns an amount of the token of a given
299      * account, deducting from the sender's allowance for said account. Uses the
300      * internal burn function.
301      * Emits an Approval event (reflecting the reduced allowance).
302      * @param account The account whose tokens will be burnt.
303      * @param value The amount that will be burnt.
304      */
305     function _burnFrom(address account, uint256 value) internal {
306         _burn(account, value);
307         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
308     }
309 }
310 
311 
312 pragma solidity ^0.5.0;
313 
314 
315 /**
316  * @title Burnable Token
317  * @dev Token that can be irreversibly burned (destroyed).
318  */
319 contract ERC20Burnable is ERC20 {
320     /**
321      * @dev Burns a specific amount of tokens.
322      * @param value The amount of token to be burned.
323      */
324     function burn(uint256 value) public {
325         _burn(msg.sender, value);
326     }
327 
328     /**
329      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
330      * @param from address The account whose tokens will be burned.
331      * @param value uint256 The amount of token to be burned.
332      */
333     function burnFrom(address from, uint256 value) public {
334         _burnFrom(from, value);
335     }
336 }
337 
338 
339 pragma solidity ^0.5.0;
340 
341 
342 /**
343  * @title ERC20Detailed token
344  * @dev The decimals are only for visualization purposes.
345  * All the operations are done using the smallest and indivisible token unit,
346  * just as on Ethereum all the operations are done in wei.
347  */
348 contract ERC20Detailed is IERC20 {
349     string private _name;
350     string private _symbol;
351     uint8 private _decimals;
352 
353     constructor (string memory name, string memory symbol, uint8 decimals) public {
354         _name = name;
355         _symbol = symbol;
356         _decimals = decimals;
357     }
358 
359     /**
360      * @return the name of the token.
361      */
362     function name() public view returns (string memory) {
363         return _name;
364     }
365 
366     /**
367      * @return the symbol of the token.
368      */
369     function symbol() public view returns (string memory) {
370         return _symbol;
371     }
372 
373     /**
374      * @return the number of decimals of the token.
375      */
376     function decimals() public view returns (uint8) {
377         return _decimals;
378     }
379 }
380 
381 
382 pragma solidity ^0.5.0;
383 
384 /**
385  * @title Ownable
386  * @dev The Ownable contract has an owner address, and provides basic authorization control
387  * functions, this simplifies the implementation of "user permissions".
388  */
389 contract Ownable {
390     address private _owner;
391 
392     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
393 
394     /**
395      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
396      * account.
397      */
398     constructor () internal {
399         _owner = msg.sender;
400         emit OwnershipTransferred(address(0), _owner);
401     }
402 
403     /**
404      * @return the address of the owner.
405      */
406     function owner() public view returns (address) {
407         return _owner;
408     }
409 
410     /**
411      * @dev Throws if called by any account other than the owner.
412      */
413     modifier onlyOwner() {
414         require(isOwner());
415         _;
416     }
417 
418     /**
419      * @return true if `msg.sender` is the owner of the contract.
420      */
421     function isOwner() public view returns (bool) {
422         return msg.sender == _owner;
423     }
424 
425     /**
426      * @dev Allows the current owner to relinquish control of the contract.
427      * It will not be possible to call the functions with the `onlyOwner`
428      * modifier anymore.
429      * @notice Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public onlyOwner {
433         emit OwnershipTransferred(_owner, address(0));
434         _owner = address(0);
435     }
436 
437     /**
438      * @dev Allows the current owner to transfer control of the contract to a newOwner.
439      * @param newOwner The address to transfer ownership to.
440      */
441     function transferOwnership(address newOwner) public onlyOwner {
442         _transferOwnership(newOwner);
443     }
444 
445     /**
446      * @dev Transfers control of the contract to a newOwner.
447      * @param newOwner The address to transfer ownership to.
448      */
449     function _transferOwnership(address newOwner) internal {
450         require(newOwner != address(0));
451         emit OwnershipTransferred(_owner, newOwner);
452         _owner = newOwner;
453     }
454 }
455 
456 
457 pragma solidity ^0.5.0;
458 
459 /**
460  * @title Roles
461  * @dev Library for managing addresses assigned to a Role.
462  */
463 library Roles {
464     struct Role {
465         mapping (address => bool) bearer;
466     }
467 
468     /**
469      * @dev Give an account access to this role.
470      */
471     function add(Role storage role, address account) internal {
472         require(!has(role, account));
473         role.bearer[account] = true;
474     }
475 
476     /**
477      * @dev Remove an account's access to this role.
478      */
479     function remove(Role storage role, address account) internal {
480         require(has(role, account));
481         role.bearer[account] = false;
482     }
483 
484     /**
485      * @dev Check if an account has this role.
486      * @return bool
487      */
488     function has(Role storage role, address account) internal view returns (bool) {
489         require(account != address(0));
490         return role.bearer[account];
491     }
492 }
493 
494 
495 pragma solidity ^0.5.7;
496 
497 
498 /**
499  * @dev This role allows the contract to be paused, so that in case something goes horribly wrong
500  * during an ICO, the owner/administrator has an ability to suspend all transactions while things
501  * are sorted out.
502  *
503  * NOTE: We have implemented a role model only the contract owner can assign/un-assign roles.
504  * This is necessary to support enterprise software, which requires a permissions model in which
505  * roles can be owner-administered, in contrast to a blockchain community approach in which
506  * permissions can be self-administered. Therefore, this implementation replaces the self-service
507  * "renounce" approach with one where only the owner is allowed to makes role changes.
508  *
509  * Owner is not allowed to renounce ownership, lest the contract go without administration. But
510  * it is ok for owner to shed initially granted roles by removing role from self.
511  */
512 contract PauserRole is Ownable {
513     using Roles for Roles.Role;
514 
515     event PauserAdded(address indexed account);
516     event PauserRemoved(address indexed account);
517 
518     Roles.Role private _pausers;
519 
520     constructor () internal {
521         _addPauser(msg.sender);
522     }
523 
524     modifier onlyPauser() {
525         require(isPauser(msg.sender), "onlyPauser");
526         _;
527     }
528 
529     function isPauser(address account) public view returns (bool) {
530         return _pausers.has(account);
531     }
532 
533     function addPauser(address account) public onlyOwner {
534         _addPauser(account);
535     }
536 
537     function removePauser(address account) public onlyOwner {
538         _removePauser(account);
539     }
540 
541     function _addPauser(address account) private {
542         require(account != address(0));
543         _pausers.add(account);
544         emit PauserAdded(account);
545     }
546 
547     function _removePauser(address account) private {
548         require(account != address(0));
549         _pausers.remove(account);
550         emit PauserRemoved(account);
551     }
552 
553 
554     // =========================================================================
555     // === Overridden ERC20 functionality
556     // =========================================================================
557 
558     /**
559      * Ensure there is no way for the contract to end up with no owner. That would inadvertently result in
560      * pauser administration becoming impossible. We override this to always disallow it.
561      */
562     function renounceOwnership() public onlyOwner {
563         require(false, "forbidden");
564     }
565 
566     /**
567      * @dev Allows the current owner to transfer control of the contract to a newOwner.
568      * @param newOwner The address to transfer ownership to.
569      */
570     function transferOwnership(address newOwner) public onlyOwner {
571         _removePauser(msg.sender);
572         super.transferOwnership(newOwner);
573         _addPauser(newOwner);
574     }
575 }
576 
577 
578 pragma solidity ^0.5.0;
579 
580 
581 /**
582  * @title Pausable
583  * @dev Base contract which allows children to implement an emergency stop mechanism.
584  */
585 contract Pausable is PauserRole {
586     event Paused(address account);
587     event Unpaused(address account);
588 
589     bool private _paused;
590 
591     constructor () internal {
592         _paused = false;
593     }
594 
595     /**
596      * @return True if the contract is paused, false otherwise.
597      */
598     function paused() public view returns (bool) {
599         return _paused;
600     }
601 
602     /**
603      * @dev Modifier to make a function callable only when the contract is not paused.
604      */
605     modifier whenNotPaused() {
606         require(!_paused);
607         _;
608     }
609 
610     /**
611      * @dev Modifier to make a function callable only when the contract is paused.
612      */
613     modifier whenPaused() {
614         require(_paused);
615         _;
616     }
617 
618     /**
619      * @dev Called by a pauser to pause, triggers stopped state.
620      */
621     function pause() public onlyPauser whenNotPaused {
622         _paused = true;
623         emit Paused(msg.sender);
624     }
625 
626     /**
627      * @dev Called by a pauser to unpause, returns to normal state.
628      */
629     function unpause() public onlyPauser whenPaused {
630         _paused = false;
631         emit Unpaused(msg.sender);
632     }
633 }
634 
635 
636 pragma solidity ^0.5.0;
637 
638 
639 /**
640  * @title Pausable token
641  * @dev ERC20 modified with pausable transfers.
642  */
643 contract ERC20Pausable is ERC20, Pausable {
644     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
645         return super.transfer(to, value);
646     }
647 
648     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
649         return super.transferFrom(from, to, value);
650     }
651 
652     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
653         return super.approve(spender, value);
654     }
655 
656     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
657         return super.increaseAllowance(spender, addedValue);
658     }
659 
660     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
661         return super.decreaseAllowance(spender, subtractedValue);
662     }
663 }
664 
665 
666 pragma solidity ^0.5.7;
667 
668 
669 contract VerifiedAccount is ERC20, Ownable {
670 
671     mapping(address => bool) private _isRegistered;
672 
673     constructor () internal {
674         // The smart contract starts off registering itself, since address is known.
675         registerAccount();
676     }
677 
678     event AccountRegistered(address indexed account);
679 
680     /**
681      * This registers the calling wallet address as a known address. Operations that transfer responsibility
682      * may require the target account to be a registered account, to protect the system from getting into a
683      * state where administration or a large amount of funds can become forever inaccessible.
684      */
685     function registerAccount() public returns (bool ok) {
686         _isRegistered[msg.sender] = true;
687         emit AccountRegistered(msg.sender);
688         return true;
689     }
690 
691     function isRegistered(address account) public view returns (bool ok) {
692         return _isRegistered[account];
693     }
694 
695     function _accountExists(address account) internal view returns (bool exists) {
696         return account == msg.sender || _isRegistered[account];
697     }
698 
699     modifier onlyExistingAccount(address account) {
700         require(_accountExists(account), "account not registered");
701         _;
702     }
703 
704 
705     // =========================================================================
706     // === Safe ERC20 methods
707     // =========================================================================
708 
709     function safeTransfer(address to, uint256 value) public onlyExistingAccount(to) returns (bool ok) {
710         transfer(to, value);
711         return true;
712     }
713 
714     function safeApprove(address spender, uint256 value) public onlyExistingAccount(spender) returns (bool ok) {
715         approve(spender, value);
716         return true;
717     }
718 
719     function safeTransferFrom(address from, address to, uint256 value) public onlyExistingAccount(to) returns (bool ok) {
720         transferFrom(from, to, value);
721         return true;
722     }
723 
724 
725     // =========================================================================
726     // === Safe ownership transfer
727     // =========================================================================
728 
729     /**
730      * @dev Allows the current owner to transfer control of the contract to a newOwner.
731      * @param newOwner The address to transfer ownership to.
732      */
733     function transferOwnership(address newOwner) public onlyExistingAccount(newOwner) onlyOwner {
734         super.transferOwnership(newOwner);
735     }
736 }
737 
738 
739 pragma solidity ^0.5.7;
740 
741 
742 /**
743  * @dev GrantorRole trait
744  *
745  * This adds support for a role that allows creation of vesting token grants, allocated from the
746  * role holder's wallet.
747  *
748  * NOTE: We have implemented a role model only the contract owner can assign/un-assign roles.
749  * This is necessary to support enterprise software, which requires a permissions model in which
750  * roles can be owner-administered, in contrast to a blockchain community approach in which
751  * permissions can be self-administered. Therefore, this implementation replaces the self-service
752  * "renounce" approach with one where only the owner is allowed to makes role changes.
753  *
754  * Owner is not allowed to renounce ownership, lest the contract go without administration. But
755  * it is ok for owner to shed initially granted roles by removing role from self.
756  */
757 contract GrantorRole is Ownable {
758     bool private constant OWNER_UNIFORM_GRANTOR_FLAG = false;
759 
760     using Roles for Roles.Role;
761 
762     event GrantorAdded(address indexed account);
763     event GrantorRemoved(address indexed account);
764 
765     Roles.Role private _grantors;
766     mapping(address => bool) private _isUniformGrantor;
767 
768     constructor () internal {
769         _addGrantor(msg.sender, OWNER_UNIFORM_GRANTOR_FLAG);
770     }
771 
772     modifier onlyGrantor() {
773         require(isGrantor(msg.sender), "onlyGrantor");
774         _;
775     }
776 
777     modifier onlyGrantorOrSelf(address account) {
778         require(isGrantor(msg.sender) || msg.sender == account, "onlyGrantorOrSelf");
779         _;
780     }
781 
782     function isGrantor(address account) public view returns (bool) {
783         return _grantors.has(account);
784     }
785 
786     function addGrantor(address account, bool isUniformGrantor) public onlyOwner {
787         _addGrantor(account, isUniformGrantor);
788     }
789 
790     function removeGrantor(address account) public onlyOwner {
791         _removeGrantor(account);
792     }
793 
794     function _addGrantor(address account, bool isUniformGrantor) private {
795         require(account != address(0));
796         _grantors.add(account);
797         _isUniformGrantor[account] = isUniformGrantor;
798         emit GrantorAdded(account);
799     }
800 
801     function _removeGrantor(address account) private {
802         require(account != address(0));
803         _grantors.remove(account);
804         emit GrantorRemoved(account);
805     }
806 
807     function isUniformGrantor(address account) public view returns (bool) {
808         return isGrantor(account) && _isUniformGrantor[account];
809     }
810 
811     modifier onlyUniformGrantor() {
812         require(isUniformGrantor(msg.sender), "onlyUniformGrantor");
813         // Only grantor role can do this.
814         _;
815     }
816 
817 
818     // =========================================================================
819     // === Overridden ERC20 functionality
820     // =========================================================================
821 
822     /**
823      * Ensure there is no way for the contract to end up with no owner. That would inadvertently result in
824      * token grant administration becoming impossible. We override this to always disallow it.
825      */
826     function renounceOwnership() public onlyOwner {
827         require(false, "forbidden");
828     }
829 
830     /**
831      * @dev Allows the current owner to transfer control of the contract to a newOwner.
832      * @param newOwner The address to transfer ownership to.
833      */
834     function transferOwnership(address newOwner) public onlyOwner {
835         _removeGrantor(msg.sender);
836         super.transferOwnership(newOwner);
837         _addGrantor(newOwner, OWNER_UNIFORM_GRANTOR_FLAG);
838     }
839 }
840 
841 
842 pragma solidity ^0.5.7;
843 
844 
845 interface IERC20Vestable {
846     function getIntrinsicVestingSchedule(address grantHolder)
847     external
848     view
849     returns (
850         uint32 cliffDuration,
851         uint32 vestDuration,
852         uint32 vestIntervalDays
853     );
854 
855     function grantVestingTokens(
856         address beneficiary,
857         uint256 totalAmount,
858         uint256 vestingAmount,
859         uint32 startDay,
860         uint32 duration,
861         uint32 cliffDuration,
862         uint32 interval,
863         bool isRevocable
864     ) external returns (bool ok);
865 
866     function today() external view returns (uint32 dayNumber);
867 
868     function vestingForAccountAsOf(
869         address grantHolder,
870         uint32 onDayOrToday
871     )
872     external
873     view
874     returns (
875         uint256 amountVested,
876         uint256 amountNotVested,
877         uint256 amountOfGrant,
878         uint32 vestStartDay,
879         uint32 cliffDuration,
880         uint32 vestDuration,
881         uint32 vestIntervalDays,
882         bool isActive,
883         bool wasRevoked
884     );
885 
886     function vestingAsOf(uint32 onDayOrToday) external view returns (
887         uint256 amountVested,
888         uint256 amountNotVested,
889         uint256 amountOfGrant,
890         uint32 vestStartDay,
891         uint32 cliffDuration,
892         uint32 vestDuration,
893         uint32 vestIntervalDays,
894         bool isActive,
895         bool wasRevoked
896     );
897 
898     function revokeGrant(address grantHolder, uint32 onDay) external returns (bool);
899 
900 
901     event VestingScheduleCreated(
902         address indexed vestingLocation,
903         uint32 cliffDuration, uint32 indexed duration, uint32 interval,
904         bool indexed isRevocable);
905 
906     event VestingTokensGranted(
907         address indexed beneficiary,
908         uint256 indexed vestingAmount,
909         uint32 startDay,
910         address vestingLocation,
911         address indexed grantor);
912 
913     event GrantRevoked(address indexed grantHolder, uint32 indexed onDay);
914 }
915 
916 
917 pragma solidity ^0.5.7;
918 
919 
920 /**
921  * @title Contract for grantable ERC20 token vesting schedules
922  *
923  * @notice Adds to an ERC20 support for grantor wallets, which are able to grant vesting tokens to
924  *   beneficiary wallets, following per-wallet custom vesting schedules.
925  *
926  * @dev Contract which gives subclass contracts the ability to act as a pool of funds for allocating
927  *   tokens to any number of other addresses. Token grants support the ability to vest over time in
928  *   accordance a predefined vesting schedule. A given wallet can receive no more than one token grant.
929  *
930  *   Tokens are transferred from the pool to the recipient at the time of grant, but the recipient
931  *   will only able to transfer tokens out of their wallet after they have vested. Transfers of non-
932  *   vested tokens are prevented.
933  *
934  *   Two types of toke grants are supported:
935  *   - Irrevocable grants, intended for use in cases when vesting tokens have been issued in exchange
936  *     for value, such as with tokens that have been purchased in an ICO.
937  *   - Revocable grants, intended for use in cases when vesting tokens have been gifted to the holder,
938  *     such as with employee grants that are given as compensation.
939  */
940 contract ERC20Vestable is ERC20, VerifiedAccount, GrantorRole, IERC20Vestable {
941     using SafeMath for uint256;
942 
943     // Date-related constants for sanity-checking dates to reject obvious erroneous inputs
944     // and conversions from seconds to days and years that are more or less leap year-aware.
945     uint32 private constant THOUSAND_YEARS_DAYS = 365243;                   /* See https://www.timeanddate.com/date/durationresult.html?m1=1&d1=1&y1=2000&m2=1&d2=1&y2=3000 */
946     uint32 private constant TEN_YEARS_DAYS = THOUSAND_YEARS_DAYS / 100;     /* Includes leap years (though it doesn't really matter) */
947     uint32 private constant SECONDS_PER_DAY = 24 * 60 * 60;                 /* 86400 seconds in a day */
948     uint32 private constant JAN_1_2000_SECONDS = 946684800;                 /* Saturday, January 1, 2000 0:00:00 (GMT) (see https://www.epochconverter.com/) */
949     uint32 private constant JAN_1_2000_DAYS = JAN_1_2000_SECONDS / SECONDS_PER_DAY;
950     uint32 private constant JAN_1_3000_DAYS = JAN_1_2000_DAYS + THOUSAND_YEARS_DAYS;
951 
952     struct vestingSchedule {
953         bool isValid;               /* true if an entry exists and is valid */
954         bool isRevocable;           /* true if the vesting option is revocable (a gift), false if irrevocable (purchased) */
955         uint32 cliffDuration;       /* Duration of the cliff, with respect to the grant start day, in days. */
956         uint32 duration;            /* Duration of the vesting schedule, with respect to the grant start day, in days. */
957         uint32 interval;            /* Duration in days of the vesting interval. */
958     }
959 
960     struct tokenGrant {
961         bool isActive;              /* true if this vesting entry is active and in-effect entry. */
962         bool wasRevoked;            /* true if this vesting schedule was revoked. */
963         uint32 startDay;            /* Start day of the grant, in days since the UNIX epoch (start of day). */
964         uint256 amount;             /* Total number of tokens that vest. */
965         address vestingLocation;    /* Address of wallet that is holding the vesting schedule. */
966         address grantor;            /* Grantor that made the grant */
967     }
968 
969     mapping(address => vestingSchedule) private _vestingSchedules;
970     mapping(address => tokenGrant) private _tokenGrants;
971 
972 
973     // =========================================================================
974     // === Methods for administratively creating a vesting schedule for an account.
975     // =========================================================================
976 
977     /**
978      * @dev This one-time operation permanently establishes a vesting schedule in the given account.
979      *
980      * For standard grants, this establishes the vesting schedule in the beneficiary's account.
981      * For uniform grants, this establishes the vesting schedule in the linked grantor's account.
982      *
983      * @param vestingLocation = Account into which to store the vesting schedule. Can be the account
984      *   of the beneficiary (for one-off grants) or the account of the grantor (for uniform grants
985      *   made from grant pools).
986      * @param cliffDuration = Duration of the cliff, with respect to the grant start day, in days.
987      * @param duration = Duration of the vesting schedule, with respect to the grant start day, in days.
988      * @param interval = Number of days between vesting increases.
989      * @param isRevocable = True if the grant can be revoked (i.e. was a gift) or false if it cannot
990      *   be revoked (i.e. tokens were purchased).
991      */
992     function _setVestingSchedule(
993         address vestingLocation,
994         uint32 cliffDuration, uint32 duration, uint32 interval,
995         bool isRevocable) internal returns (bool ok) {
996 
997         // Check for a valid vesting schedule given (disallow absurd values to reject likely bad input).
998         require(
999             duration > 0 && duration <= TEN_YEARS_DAYS
1000             && cliffDuration < duration
1001             && interval >= 1,
1002             "invalid vesting schedule"
1003         );
1004 
1005         // Make sure the duration values are in harmony with interval (both should be an exact multiple of interval).
1006         require(
1007             duration % interval == 0 && cliffDuration % interval == 0,
1008             "invalid cliff/duration for interval"
1009         );
1010 
1011         // Create and populate a vesting schedule.
1012         _vestingSchedules[vestingLocation] = vestingSchedule(
1013             true/*isValid*/,
1014             isRevocable,
1015             cliffDuration, duration, interval
1016         );
1017 
1018         // Emit the event and return success.
1019         emit VestingScheduleCreated(
1020             vestingLocation,
1021             cliffDuration, duration, interval,
1022             isRevocable);
1023         return true;
1024     }
1025 
1026     function _hasVestingSchedule(address account) internal view returns (bool ok) {
1027         return _vestingSchedules[account].isValid;
1028     }
1029 
1030     /**
1031      * @dev returns all information about the vesting schedule directly associated with the given
1032      * account. This can be used to double check that a uniform grantor has been set up with a
1033      * correct vesting schedule. Also, recipients of standard (non-uniform) grants can use this.
1034      * This method is only callable by the account holder or a grantor, so this is mainly intended
1035      * for administrative use.
1036      *
1037      * Holders of uniform grants must use vestingAsOf() to view their vesting schedule, as it is
1038      * stored in the grantor account.
1039      *
1040      * @param grantHolder = The address to do this for.
1041      *   the special value 0 to indicate today.
1042      * @return = A tuple with the following values:
1043      *   vestDuration = grant duration in days.
1044      *   cliffDuration = duration of the cliff.
1045      *   vestIntervalDays = number of days between vesting periods.
1046      */
1047     function getIntrinsicVestingSchedule(address grantHolder)
1048     public
1049     view
1050     onlyGrantorOrSelf(grantHolder)
1051     returns (
1052         uint32 vestDuration,
1053         uint32 cliffDuration,
1054         uint32 vestIntervalDays
1055     )
1056     {
1057         return (
1058         _vestingSchedules[grantHolder].duration,
1059         _vestingSchedules[grantHolder].cliffDuration,
1060         _vestingSchedules[grantHolder].interval
1061         );
1062     }
1063 
1064 
1065     // =========================================================================
1066     // === Token grants (general-purpose)
1067     // === Methods to be used for administratively creating one-off token grants with vesting schedules.
1068     // =========================================================================
1069 
1070     /**
1071      * @dev Immediately grants tokens to an account, referencing a vesting schedule which may be
1072      * stored in the same account (individual/one-off) or in a different account (shared/uniform).
1073      *
1074      * @param beneficiary = Address to which tokens will be granted.
1075      * @param totalAmount = Total number of tokens to deposit into the account.
1076      * @param vestingAmount = Out of totalAmount, the number of tokens subject to vesting.
1077      * @param startDay = Start day of the grant's vesting schedule, in days since the UNIX epoch
1078      *   (start of day). The startDay may be given as a date in the future or in the past, going as far
1079      *   back as year 2000.
1080      * @param vestingLocation = Account where the vesting schedule is held (must already exist).
1081      * @param grantor = Account which performed the grant. Also the account from where the granted
1082      *   funds will be withdrawn.
1083      */
1084     function _grantVestingTokens(
1085         address beneficiary,
1086         uint256 totalAmount,
1087         uint256 vestingAmount,
1088         uint32 startDay,
1089         address vestingLocation,
1090         address grantor
1091     )
1092     internal returns (bool ok)
1093     {
1094         // Make sure no prior grant is in effect.
1095         require(!_tokenGrants[beneficiary].isActive, "grant already exists");
1096 
1097         // Check for valid vestingAmount
1098         require(
1099             vestingAmount <= totalAmount && vestingAmount > 0
1100             && startDay >= JAN_1_2000_DAYS && startDay < JAN_1_3000_DAYS,
1101             "invalid vesting params");
1102 
1103         // Make sure the vesting schedule we are about to use is valid.
1104         require(_hasVestingSchedule(vestingLocation), "no such vesting schedule");
1105 
1106         // Transfer the total number of tokens from grantor into the account's holdings.
1107         _transfer(grantor, beneficiary, totalAmount);
1108         /* Emits a Transfer event. */
1109 
1110         // Create and populate a token grant, referencing vesting schedule.
1111         _tokenGrants[beneficiary] = tokenGrant(
1112             true/*isActive*/,
1113             false/*wasRevoked*/,
1114             startDay,
1115             vestingAmount,
1116             vestingLocation, /* The wallet address where the vesting schedule is kept. */
1117             grantor             /* The account that performed the grant (where revoked funds would be sent) */
1118         );
1119 
1120         // Emit the event and return success.
1121         emit VestingTokensGranted(beneficiary, vestingAmount, startDay, vestingLocation, grantor);
1122         return true;
1123     }
1124 
1125     /**
1126      * @dev Immediately grants tokens to an address, including a portion that will vest over time
1127      * according to a set vesting schedule. The overall duration and cliff duration of the grant must
1128      * be an even multiple of the vesting interval.
1129      *
1130      * @param beneficiary = Address to which tokens will be granted.
1131      * @param totalAmount = Total number of tokens to deposit into the account.
1132      * @param vestingAmount = Out of totalAmount, the number of tokens subject to vesting.
1133      * @param startDay = Start day of the grant's vesting schedule, in days since the UNIX epoch
1134      *   (start of day). The startDay may be given as a date in the future or in the past, going as far
1135      *   back as year 2000.
1136      * @param duration = Duration of the vesting schedule, with respect to the grant start day, in days.
1137      * @param cliffDuration = Duration of the cliff, with respect to the grant start day, in days.
1138      * @param interval = Number of days between vesting increases.
1139      * @param isRevocable = True if the grant can be revoked (i.e. was a gift) or false if it cannot
1140      *   be revoked (i.e. tokens were purchased).
1141      */
1142     function grantVestingTokens(
1143         address beneficiary,
1144         uint256 totalAmount,
1145         uint256 vestingAmount,
1146         uint32 startDay,
1147         uint32 duration,
1148         uint32 cliffDuration,
1149         uint32 interval,
1150         bool isRevocable
1151     ) public onlyGrantor returns (bool ok) {
1152         // Make sure no prior vesting schedule has been set.
1153         require(!_tokenGrants[beneficiary].isActive, "grant already exists");
1154 
1155         // The vesting schedule is unique to this wallet and so will be stored here,
1156         _setVestingSchedule(beneficiary, cliffDuration, duration, interval, isRevocable);
1157 
1158         // Issue grantor tokens to the beneficiary, using beneficiary's own vesting schedule.
1159         _grantVestingTokens(beneficiary, totalAmount, vestingAmount, startDay, beneficiary, msg.sender);
1160 
1161         return true;
1162     }
1163 
1164     /**
1165      * @dev This variant only grants tokens if the beneficiary account has previously self-registered.
1166      */
1167     function safeGrantVestingTokens(
1168         address beneficiary, uint256 totalAmount, uint256 vestingAmount,
1169         uint32 startDay, uint32 duration, uint32 cliffDuration, uint32 interval,
1170         bool isRevocable) public onlyGrantor onlyExistingAccount(beneficiary) returns (bool ok) {
1171 
1172         return grantVestingTokens(
1173             beneficiary, totalAmount, vestingAmount,
1174             startDay, duration, cliffDuration, interval,
1175             isRevocable);
1176     }
1177 
1178 
1179     // =========================================================================
1180     // === Check vesting.
1181     // =========================================================================
1182 
1183     /**
1184      * @dev returns the day number of the current day, in days since the UNIX epoch.
1185      */
1186     function today() public view returns (uint32 dayNumber) {
1187         return uint32(block.timestamp / SECONDS_PER_DAY);
1188     }
1189 
1190     function _effectiveDay(uint32 onDayOrToday) internal view returns (uint32 dayNumber) {
1191         return onDayOrToday == 0 ? today() : onDayOrToday;
1192     }
1193 
1194     /**
1195      * @dev Determines the amount of tokens that have not vested in the given account.
1196      *
1197      * The math is: not vested amount = vesting amount * (end date - on date)/(end date - start date)
1198      *
1199      * @param grantHolder = The account to check.
1200      * @param onDayOrToday = The day to check for, in days since the UNIX epoch. Can pass
1201      *   the special value 0 to indicate today.
1202      */
1203     function _getNotVestedAmount(address grantHolder, uint32 onDayOrToday) internal view returns (uint256 amountNotVested) {
1204         tokenGrant storage grant = _tokenGrants[grantHolder];
1205         vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
1206         uint32 onDay = _effectiveDay(onDayOrToday);
1207 
1208         // If there's no schedule, or before the vesting cliff, then the full amount is not vested.
1209         if (!grant.isActive || onDay < grant.startDay + vesting.cliffDuration)
1210         {
1211             // None are vested (all are not vested)
1212             return grant.amount;
1213         }
1214         // If after end of vesting, then the not vested amount is zero (all are vested).
1215         else if (onDay >= grant.startDay + vesting.duration)
1216         {
1217             // All are vested (none are not vested)
1218             return uint256(0);
1219         }
1220         // Otherwise a fractional amount is vested.
1221         else
1222         {
1223             // Compute the exact number of days vested.
1224             uint32 daysVested = onDay - grant.startDay;
1225             // Adjust result rounding down to take into consideration the interval.
1226             uint32 effectiveDaysVested = (daysVested / vesting.interval) * vesting.interval;
1227 
1228             // Compute the fraction vested from schedule using 224.32 fixed point math for date range ratio.
1229             // Note: This is safe in 256-bit math because max value of X billion tokens = X*10^27 wei, and
1230             // typical token amounts can fit into 90 bits. Scaling using a 32 bits value results in only 125
1231             // bits before reducing back to 90 bits by dividing. There is plenty of room left, even for token
1232             // amounts many orders of magnitude greater than mere billions.
1233             uint256 vested = grant.amount.mul(effectiveDaysVested).div(vesting.duration);
1234             return grant.amount.sub(vested);
1235         }
1236     }
1237 
1238     /**
1239      * @dev Computes the amount of funds in the given account which are available for use as of
1240      * the given day. If there's no vesting schedule then 0 tokens are considered to be vested and
1241      * this just returns the full account balance.
1242      *
1243      * The math is: available amount = total funds - notVestedAmount.
1244      *
1245      * @param grantHolder = The account to check.
1246      * @param onDay = The day to check for, in days since the UNIX epoch.
1247      */
1248     function _getAvailableAmount(address grantHolder, uint32 onDay) internal view returns (uint256 amountAvailable) {
1249         uint256 totalTokens = balanceOf(grantHolder);
1250         uint256 vested = totalTokens.sub(_getNotVestedAmount(grantHolder, onDay));
1251         return vested;
1252     }
1253 
1254     /**
1255      * @dev returns all information about the grant's vesting as of the given day
1256      * for the given account. Only callable by the account holder or a grantor, so
1257      * this is mainly intended for administrative use.
1258      *
1259      * @param grantHolder = The address to do this for.
1260      * @param onDayOrToday = The day to check for, in days since the UNIX epoch. Can pass
1261      *   the special value 0 to indicate today.
1262      * @return = A tuple with the following values:
1263      *   amountVested = the amount out of vestingAmount that is vested
1264      *   amountNotVested = the amount that is vested (equal to vestingAmount - vestedAmount)
1265      *   amountOfGrant = the amount of tokens subject to vesting.
1266      *   vestStartDay = starting day of the grant (in days since the UNIX epoch).
1267      *   vestDuration = grant duration in days.
1268      *   cliffDuration = duration of the cliff.
1269      *   vestIntervalDays = number of days between vesting periods.
1270      *   isActive = true if the vesting schedule is currently active.
1271      *   wasRevoked = true if the vesting schedule was revoked.
1272      */
1273     function vestingForAccountAsOf(
1274         address grantHolder,
1275         uint32 onDayOrToday
1276     )
1277     public
1278     view
1279     onlyGrantorOrSelf(grantHolder)
1280     returns (
1281         uint256 amountVested,
1282         uint256 amountNotVested,
1283         uint256 amountOfGrant,
1284         uint32 vestStartDay,
1285         uint32 vestDuration,
1286         uint32 cliffDuration,
1287         uint32 vestIntervalDays,
1288         bool isActive,
1289         bool wasRevoked
1290     )
1291     {
1292         tokenGrant storage grant = _tokenGrants[grantHolder];
1293         vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
1294         uint256 notVestedAmount = _getNotVestedAmount(grantHolder, onDayOrToday);
1295         uint256 grantAmount = grant.amount;
1296 
1297         return (
1298         grantAmount.sub(notVestedAmount),
1299         notVestedAmount,
1300         grantAmount,
1301         grant.startDay,
1302         vesting.duration,
1303         vesting.cliffDuration,
1304         vesting.interval,
1305         grant.isActive,
1306         grant.wasRevoked
1307         );
1308     }
1309 
1310     /**
1311      * @dev returns all information about the grant's vesting as of the given day
1312      * for the current account, to be called by the account holder.
1313      *
1314      * @param onDayOrToday = The day to check for, in days since the UNIX epoch. Can pass
1315      *   the special value 0 to indicate today.
1316      * @return = A tuple with the following values:
1317      *   amountVested = the amount out of vestingAmount that is vested
1318      *   amountNotVested = the amount that is vested (equal to vestingAmount - vestedAmount)
1319      *   amountOfGrant = the amount of tokens subject to vesting.
1320      *   vestStartDay = starting day of the grant (in days since the UNIX epoch).
1321      *   cliffDuration = duration of the cliff.
1322      *   vestDuration = grant duration in days.
1323      *   vestIntervalDays = number of days between vesting periods.
1324      *   isActive = true if the vesting schedule is currently active.
1325      *   wasRevoked = true if the vesting schedule was revoked.
1326      */
1327     function vestingAsOf(uint32 onDayOrToday) public view returns (
1328         uint256 amountVested,
1329         uint256 amountNotVested,
1330         uint256 amountOfGrant,
1331         uint32 vestStartDay,
1332         uint32 vestDuration,
1333         uint32 cliffDuration,
1334         uint32 vestIntervalDays,
1335         bool isActive,
1336         bool wasRevoked
1337     )
1338     {
1339         return vestingForAccountAsOf(msg.sender, onDayOrToday);
1340     }
1341 
1342     /**
1343      * @dev returns true if the account has sufficient funds available to cover the given amount,
1344      *   including consideration for vesting tokens.
1345      *
1346      * @param account = The account to check.
1347      * @param amount = The required amount of vested funds.
1348      * @param onDay = The day to check for, in days since the UNIX epoch.
1349      */
1350     function _fundsAreAvailableOn(address account, uint256 amount, uint32 onDay) internal view returns (bool ok) {
1351         return (amount <= _getAvailableAmount(account, onDay));
1352     }
1353 
1354     /**
1355      * @dev Modifier to make a function callable only when the amount is sufficiently vested right now.
1356      *
1357      * @param account = The account to check.
1358      * @param amount = The required amount of vested funds.
1359      */
1360     modifier onlyIfFundsAvailableNow(address account, uint256 amount) {
1361         // Distinguish insufficient overall balance from insufficient vested funds balance in failure msg.
1362         require(_fundsAreAvailableOn(account, amount, today()),
1363             balanceOf(account) < amount ? "insufficient funds" : "insufficient vested funds");
1364         _;
1365     }
1366 
1367 
1368     // =========================================================================
1369     // === Grant revocation
1370     // =========================================================================
1371 
1372     /**
1373      * @dev If the account has a revocable grant, this forces the grant to end based on computing
1374      * the amount vested up to the given date. All tokens that would no longer vest are returned
1375      * to the account of the original grantor.
1376      *
1377      * @param grantHolder = Address to which tokens will be granted.
1378      * @param onDay = The date upon which the vesting schedule will be effectively terminated,
1379      *   in days since the UNIX epoch (start of day).
1380      */
1381     function revokeGrant(address grantHolder, uint32 onDay) public onlyGrantor returns (bool ok) {
1382         tokenGrant storage grant = _tokenGrants[grantHolder];
1383         vestingSchedule storage vesting = _vestingSchedules[grant.vestingLocation];
1384         uint256 notVestedAmount;
1385 
1386         // Make sure grantor can only revoke from own pool.
1387         require(msg.sender == owner() || msg.sender == grant.grantor, "not allowed");
1388         // Make sure a vesting schedule has previously been set.
1389         require(grant.isActive, "no active grant");
1390         // Make sure it's revocable.
1391         require(vesting.isRevocable, "irrevocable");
1392         // Fail on likely erroneous input.
1393         require(onDay <= grant.startDay + vesting.duration, "no effect");
1394         // Don"t let grantor revoke anf portion of vested amount.
1395         require(onDay >= today(), "cannot revoke vested holdings");
1396 
1397         notVestedAmount = _getNotVestedAmount(grantHolder, onDay);
1398 
1399         // Use ERC20 _approve() to forcibly approve grantor to take back not-vested tokens from grantHolder.
1400         _approve(grantHolder, grant.grantor, notVestedAmount);
1401         /* Emits an Approval Event. */
1402         transferFrom(grantHolder, grant.grantor, notVestedAmount);
1403         /* Emits a Transfer and an Approval Event. */
1404 
1405         // Kill the grant by updating wasRevoked and isActive.
1406         _tokenGrants[grantHolder].wasRevoked = true;
1407         _tokenGrants[grantHolder].isActive = false;
1408 
1409         emit GrantRevoked(grantHolder, onDay);
1410         /* Emits the GrantRevoked event. */
1411         return true;
1412     }
1413 
1414 
1415     // =========================================================================
1416     // === Overridden ERC20 functionality
1417     // =========================================================================
1418 
1419     /**
1420      * @dev Methods transfer() and approve() require an additional available funds check to
1421      * prevent spending held but non-vested tokens. Note that transferFrom() does NOT have this
1422      * additional check because approved funds come from an already set-aside allowance, not from the wallet.
1423      */
1424     function transfer(address to, uint256 value) public onlyIfFundsAvailableNow(msg.sender, value) returns (bool ok) {
1425         return super.transfer(to, value);
1426     }
1427 
1428     /**
1429      * @dev Additional available funds check to prevent spending held but non-vested tokens.
1430      */
1431     function approve(address spender, uint256 value) public onlyIfFundsAvailableNow(msg.sender, value) returns (bool ok) {
1432         return super.approve(spender, value);
1433     }
1434 }
1435 
1436 
1437 pragma solidity ^0.5.7;
1438 
1439 
1440 /**
1441  * @title Contract for uniform granting of vesting tokens
1442  *
1443  * @notice Adds methods for programmatic creation of uniform or standard token vesting grants.
1444  *
1445  * @dev This is primarily for use by exchanges and scripted internal employee incentive grant creation.
1446  */
1447 contract UniformTokenGrantor is ERC20Vestable {
1448 
1449     struct restrictions {
1450         bool isValid;
1451         uint32 minStartDay;        /* The smallest value for startDay allowed in grant creation. */
1452         uint32 maxStartDay;        /* The maximum value for startDay allowed in grant creation. */
1453         uint32 expirationDay;       /* The last day this grantor may make grants. */
1454     }
1455 
1456     mapping(address => restrictions) private _restrictions;
1457 
1458 
1459     // =========================================================================
1460     // === Uniform token grant setup
1461     // === Methods used by owner to set up uniform grants on restricted grantor
1462     // =========================================================================
1463 
1464     event GrantorRestrictionsSet(
1465         address indexed grantor,
1466         uint32 minStartDay,
1467         uint32 maxStartDay,
1468         uint32 expirationDay);
1469 
1470     /**
1471      * @dev Lets owner set or change existing specific restrictions. Restrictions must be established
1472      * before the grantor will be allowed to issue grants.
1473      *
1474      * All date values are expressed as number of days since the UNIX epoch. Note that the inputs are
1475      * themselves not very thoroughly restricted. However, this method can be called more than once
1476      * if incorrect values need to be changed, or to extend a grantor's expiration date.
1477      *
1478      * @param grantor = Address which will receive the uniform grantable vesting schedule.
1479      * @param minStartDay = The smallest value for startDay allowed in grant creation.
1480      * @param maxStartDay = The maximum value for startDay allowed in grant creation.
1481      * @param expirationDay = The last day this grantor may make grants.
1482      */
1483     function setRestrictions(
1484         address grantor,
1485         uint32 minStartDay,
1486         uint32 maxStartDay,
1487         uint32 expirationDay
1488     )
1489     public
1490     onlyOwner
1491     onlyExistingAccount(grantor)
1492     returns (bool ok)
1493     {
1494         require(
1495             isUniformGrantor(grantor)
1496          && maxStartDay > minStartDay
1497          && expirationDay > today(), "invalid params");
1498 
1499         // We allow owner to set or change existing specific restrictions.
1500         _restrictions[grantor] = restrictions(
1501             true/*isValid*/,
1502             minStartDay,
1503             maxStartDay,
1504             expirationDay
1505         );
1506 
1507         // Emit the event and return success.
1508         emit GrantorRestrictionsSet(grantor, minStartDay, maxStartDay, expirationDay);
1509         return true;
1510     }
1511 
1512     /**
1513      * @dev Lets owner permanently establish a vesting schedule for a restricted grantor to use when
1514      * creating uniform token grants. Grantee accounts forever refer to the grantor's account to look up
1515      * vesting, so this method can only be used once per grantor.
1516      *
1517      * @param grantor = Address which will receive the uniform grantable vesting schedule.
1518      * @param duration = Duration of the vesting schedule, with respect to the grant start day, in days.
1519      * @param cliffDuration = Duration of the cliff, with respect to the grant start day, in days.
1520      * @param interval = Number of days between vesting increases.
1521      * @param isRevocable = True if the grant can be revoked (i.e. was a gift) or false if it cannot
1522      *   be revoked (i.e. tokens were purchased).
1523      */
1524     function setGrantorVestingSchedule(
1525         address grantor,
1526         uint32 duration,
1527         uint32 cliffDuration,
1528         uint32 interval,
1529         bool isRevocable
1530     )
1531     public
1532     onlyOwner
1533     onlyExistingAccount(grantor)
1534     returns (bool ok)
1535     {
1536         // Only allow doing this to restricted grantor role account.
1537         require(isUniformGrantor(grantor), "uniform grantor only");
1538         // Make sure no prior vesting schedule has been set!
1539         require(!_hasVestingSchedule(grantor), "schedule already exists");
1540 
1541         // The vesting schedule is unique to this grantor wallet and so will be stored here to be
1542         // referenced by future grants. Emits VestingScheduleCreated event.
1543         _setVestingSchedule(grantor, cliffDuration, duration, interval, isRevocable);
1544 
1545         return true;
1546     }
1547 
1548 
1549     // =========================================================================
1550     // === Uniform token grants
1551     // === Methods to be used by exchanges to use for creating tokens.
1552     // =========================================================================
1553 
1554     function isUniformGrantorWithSchedule(address account) internal view returns (bool ok) {
1555         // Check for grantor that has a uniform vesting schedule already set.
1556         return isUniformGrantor(account) && _hasVestingSchedule(account);
1557     }
1558 
1559     modifier onlyUniformGrantorWithSchedule(address account) {
1560         require(isUniformGrantorWithSchedule(account), "grantor account not ready");
1561         _;
1562     }
1563 
1564     modifier whenGrantorRestrictionsMet(uint32 startDay) {
1565         restrictions storage restriction = _restrictions[msg.sender];
1566         require(restriction.isValid, "set restrictions first");
1567 
1568         require(
1569             startDay >= restriction.minStartDay
1570             && startDay < restriction.maxStartDay, "startDay too early");
1571 
1572         require(today() < restriction.expirationDay, "grantor expired");
1573         _;
1574     }
1575 
1576     /**
1577      * @dev Immediately grants tokens to an address, including a portion that will vest over time
1578      * according to the uniform vesting schedule already established in the grantor's account.
1579      *
1580      * @param beneficiary = Address to which tokens will be granted.
1581      * @param totalAmount = Total number of tokens to deposit into the account.
1582      * @param vestingAmount = Out of totalAmount, the number of tokens subject to vesting.
1583      * @param startDay = Start day of the grant's vesting schedule, in days since the UNIX epoch
1584      *   (start of day). The startDay may be given as a date in the future or in the past, going as far
1585      *   back as year 2000.
1586      */
1587     function grantUniformVestingTokens(
1588         address beneficiary,
1589         uint256 totalAmount,
1590         uint256 vestingAmount,
1591         uint32 startDay
1592     )
1593     public
1594     onlyUniformGrantorWithSchedule(msg.sender)
1595     whenGrantorRestrictionsMet(startDay)
1596     returns (bool ok)
1597     {
1598         // Issue grantor tokens to the beneficiary, using beneficiary's own vesting schedule.
1599         // Emits VestingTokensGranted event.
1600         return _grantVestingTokens(beneficiary, totalAmount, vestingAmount, startDay, msg.sender, msg.sender);
1601     }
1602 
1603     /**
1604      * @dev This variant only grants tokens if the beneficiary account has previously self-registered.
1605      */
1606     function safeGrantUniformVestingTokens(
1607         address beneficiary,
1608         uint256 totalAmount,
1609         uint256 vestingAmount,
1610         uint32 startDay
1611     )
1612     public
1613     onlyUniformGrantorWithSchedule(msg.sender)
1614     whenGrantorRestrictionsMet(startDay)
1615     onlyExistingAccount(beneficiary)
1616     returns (bool ok)
1617     {
1618         // Issue grantor tokens to the beneficiary, using beneficiary's own vesting schedule.
1619         // Emits VestingTokensGranted event.
1620         return _grantVestingTokens(beneficiary, totalAmount, vestingAmount, startDay, msg.sender, msg.sender);
1621     }
1622 }
1623 
1624 
1625 pragma solidity ^0.5.7;
1626 
1627 
1628 /**
1629  * @dev An ERC20 implementation of the CPUcoin ecosystem token. All tokens are initially pre-assigned to
1630  * the creator, and can later be distributed freely using transfer transferFrom and other ERC20
1631  * functions.
1632  */
1633 contract CpuCoin is Identity, ERC20, ERC20Pausable, ERC20Burnable, ERC20Detailed, UniformTokenGrantor {
1634     uint32 public constant VERSION = 8;
1635 
1636     uint8 private constant DECIMALS = 18;
1637     uint256 private constant TOKEN_WEI = 10 ** uint256(DECIMALS);
1638 
1639     uint256 private constant INITIAL_WHOLE_TOKENS = uint256(5 * (10 ** 9));
1640     uint256 private constant INITIAL_SUPPLY = uint256(INITIAL_WHOLE_TOKENS) * uint256(TOKEN_WEI);
1641 
1642     /**
1643      * @dev Constructor that gives msg.sender all of existing tokens.
1644      */
1645     constructor () ERC20Detailed("CPUcoin", "CPU", DECIMALS) public {
1646         // This is the only place where we ever mint tokens.
1647         _mint(msg.sender, INITIAL_SUPPLY);
1648     }
1649 
1650     event DepositReceived(address indexed from, uint256 value);
1651 
1652     /**
1653      * fallback function: collect any ether sent to us (whether we asked for it or not).
1654      */
1655     function() payable external {
1656         // Track where unexpected ETH came from so we can follow up later.
1657         emit DepositReceived(msg.sender, msg.value);
1658     }
1659 
1660     /**
1661      * @dev Allow only the owner to burn tokens from the owner's wallet, also decreasing the total
1662      * supply. There is no reason for a token holder to EVER call this method directly. It will be
1663      * used by the future Dyncoin contract to implement the CpuCoin side of of token redemption.
1664      */
1665     function burn(uint256 value) onlyIfFundsAvailableNow(msg.sender, value) public {
1666         // This is the only place where we ever burn tokens.
1667         _burn(msg.sender, value);
1668     }
1669 
1670     /**
1671      * @dev Allow pauser to kill the contract (which must already be paused), with enough restrictions
1672      * in place to ensure this could not happen by accident very easily. ETH is returned to owner wallet.
1673      */
1674     function kill() whenPaused onlyPauser public returns (bool itsDeadJim) {
1675         require(isPauser(msg.sender), "onlyPauser");
1676         address payable payableOwner = address(uint160(owner()));
1677         selfdestruct(payableOwner);
1678         return true;
1679     }
1680 }