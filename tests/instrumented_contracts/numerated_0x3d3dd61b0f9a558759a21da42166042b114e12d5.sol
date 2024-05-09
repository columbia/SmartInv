1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 pragma solidity ^0.5.0;
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 /**
101  * @title ERC20Detailed token
102  * @dev The decimals are only for visualization purposes.
103  * All the operations are done using the smallest and indivisible token unit,
104  * just as on Ethereum all the operations are done in wei.
105  */
106 contract ERC20Detailed is IERC20 {
107     string private _name;
108     string private _symbol;
109     uint8 private _decimals;
110 
111     constructor (string memory name, string memory symbol, uint8 decimals) public {
112         _name = name;
113         _symbol = symbol;
114         _decimals = decimals;
115     }
116 
117     /**
118      * @return the name of the token.
119      */
120     function name() public view returns (string memory) {
121         return _name;
122     }
123 
124     /**
125      * @return the symbol of the token.
126      */
127     function symbol() public view returns (string memory) {
128         return _symbol;
129     }
130 
131     /**
132      * @return the number of decimals of the token.
133      */
134     function decimals() public view returns (uint8) {
135         return _decimals;
136     }
137 }
138 
139 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
140 
141 pragma solidity ^0.5.0;
142 
143 
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
150  * Originally based on code by FirstBlood:
151  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  *
153  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
154  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
155  * compliant implementations may not do it.
156  */
157 contract ERC20 is IERC20 {
158     using SafeMath for uint256;
159 
160     mapping (address => uint256) private _balances;
161 
162     mapping (address => mapping (address => uint256)) private _allowed;
163 
164     uint256 private _totalSupply;
165 
166     /**
167     * @dev Total number of tokens in existence
168     */
169     function totalSupply() public view returns (uint256) {
170         return _totalSupply;
171     }
172 
173     /**
174     * @dev Gets the balance of the specified address.
175     * @param owner The address to query the balance of.
176     * @return An uint256 representing the amount owned by the passed address.
177     */
178     function balanceOf(address owner) public view returns (uint256) {
179         return _balances[owner];
180     }
181 
182     /**
183      * @dev Function to check the amount of tokens that an owner allowed to a spender.
184      * @param owner address The address which owns the funds.
185      * @param spender address The address which will spend the funds.
186      * @return A uint256 specifying the amount of tokens still available for the spender.
187      */
188     function allowance(address owner, address spender) public view returns (uint256) {
189         return _allowed[owner][spender];
190     }
191 
192     /**
193     * @dev Transfer token for a specified address
194     * @param to The address to transfer to.
195     * @param value The amount to be transferred.
196     */
197     function transfer(address to, uint256 value) public returns (bool) {
198         _transfer(msg.sender, to, value);
199         return true;
200     }
201 
202     /**
203      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204      * Beware that changing an allowance with this method brings the risk that someone may use both the old
205      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      * @param spender The address which will spend the funds.
209      * @param value The amount of tokens to be spent.
210      */
211     function approve(address spender, uint256 value) public returns (bool) {
212         require(spender != address(0));
213 
214         _allowed[msg.sender][spender] = value;
215         emit Approval(msg.sender, spender, value);
216         return true;
217     }
218 
219     /**
220      * @dev Transfer tokens from one address to another.
221      * Note that while this function emits an Approval event, this is not required as per the specification,
222      * and other compliant implementations may not emit the event.
223      * @param from address The address which you want to send tokens from
224      * @param to address The address which you want to transfer to
225      * @param value uint256 the amount of tokens to be transferred
226      */
227     function transferFrom(address from, address to, uint256 value) public returns (bool) {
228         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
229         _transfer(from, to, value);
230         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
231         return true;
232     }
233 
234     /**
235      * @dev Increase the amount of tokens that an owner allowed to a spender.
236      * approve should be called when allowed_[_spender] == 0. To increment
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      * Emits an Approval event.
241      * @param spender The address which will spend the funds.
242      * @param addedValue The amount of tokens to increase the allowance by.
243      */
244     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
245         require(spender != address(0));
246 
247         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
248         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
249         return true;
250     }
251 
252     /**
253      * @dev Decrease the amount of tokens that an owner allowed to a spender.
254      * approve should be called when allowed_[_spender] == 0. To decrement
255      * allowed value is better to use this function to avoid 2 calls (and wait until
256      * the first transaction is mined)
257      * From MonolithDAO Token.sol
258      * Emits an Approval event.
259      * @param spender The address which will spend the funds.
260      * @param subtractedValue The amount of tokens to decrease the allowance by.
261      */
262     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
263         require(spender != address(0));
264 
265         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
266         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
267         return true;
268     }
269 
270     /**
271     * @dev Transfer token for a specified addresses
272     * @param from The address to transfer from.
273     * @param to The address to transfer to.
274     * @param value The amount to be transferred.
275     */
276     function _transfer(address from, address to, uint256 value) internal {
277         require(to != address(0));
278 
279         _balances[from] = _balances[from].sub(value);
280         _balances[to] = _balances[to].add(value);
281         emit Transfer(from, to, value);
282     }
283 
284     /**
285      * @dev Internal function that mints an amount of the token and assigns it to
286      * an account. This encapsulates the modification of balances such that the
287      * proper events are emitted.
288      * @param account The account that will receive the created tokens.
289      * @param value The amount that will be created.
290      */
291     function _mint(address account, uint256 value) internal {
292         require(account != address(0));
293 
294         _totalSupply = _totalSupply.add(value);
295         _balances[account] = _balances[account].add(value);
296         emit Transfer(address(0), account, value);
297     }
298 
299     /**
300      * @dev Internal function that burns an amount of the token of a given
301      * account.
302      * @param account The account whose tokens will be burnt.
303      * @param value The amount that will be burnt.
304      */
305     function _burn(address account, uint256 value) internal {
306         require(account != address(0));
307 
308         _totalSupply = _totalSupply.sub(value);
309         _balances[account] = _balances[account].sub(value);
310         emit Transfer(account, address(0), value);
311     }
312 
313     /**
314      * @dev Internal function that burns an amount of the token of a given
315      * account, deducting from the sender's allowance for said account. Uses the
316      * internal burn function.
317      * Emits an Approval event (reflecting the reduced allowance).
318      * @param account The account whose tokens will be burnt.
319      * @param value The amount that will be burnt.
320      */
321     function _burnFrom(address account, uint256 value) internal {
322         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
323         _burn(account, value);
324         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
325     }
326 }
327 
328 // File: openzeppelin-solidity/contracts/access/Roles.sol
329 
330 pragma solidity ^0.5.0;
331 
332 /**
333  * @title Roles
334  * @dev Library for managing addresses assigned to a Role.
335  */
336 library Roles {
337     struct Role {
338         mapping (address => bool) bearer;
339     }
340 
341     /**
342      * @dev give an account access to this role
343      */
344     function add(Role storage role, address account) internal {
345         require(account != address(0));
346         require(!has(role, account));
347 
348         role.bearer[account] = true;
349     }
350 
351     /**
352      * @dev remove an account's access to this role
353      */
354     function remove(Role storage role, address account) internal {
355         require(account != address(0));
356         require(has(role, account));
357 
358         role.bearer[account] = false;
359     }
360 
361     /**
362      * @dev check if an account has this role
363      * @return bool
364      */
365     function has(Role storage role, address account) internal view returns (bool) {
366         require(account != address(0));
367         return role.bearer[account];
368     }
369 }
370 
371 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
372 
373 pragma solidity ^0.5.0;
374 
375 
376 contract PauserRole {
377     using Roles for Roles.Role;
378 
379     event PauserAdded(address indexed account);
380     event PauserRemoved(address indexed account);
381 
382     Roles.Role private _pausers;
383 
384     constructor () internal {
385         _addPauser(msg.sender);
386     }
387 
388     modifier onlyPauser() {
389         require(isPauser(msg.sender));
390         _;
391     }
392 
393     function isPauser(address account) public view returns (bool) {
394         return _pausers.has(account);
395     }
396 
397     function addPauser(address account) public onlyPauser {
398         _addPauser(account);
399     }
400 
401     function renouncePauser() public {
402         _removePauser(msg.sender);
403     }
404 
405     function _addPauser(address account) internal {
406         _pausers.add(account);
407         emit PauserAdded(account);
408     }
409 
410     function _removePauser(address account) internal {
411         _pausers.remove(account);
412         emit PauserRemoved(account);
413     }
414 }
415 
416 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
417 
418 pragma solidity ^0.5.0;
419 
420 
421 /**
422  * @title Pausable
423  * @dev Base contract which allows children to implement an emergency stop mechanism.
424  */
425 contract Pausable is PauserRole {
426     event Paused(address account);
427     event Unpaused(address account);
428 
429     bool private _paused;
430 
431     constructor () internal {
432         _paused = false;
433     }
434 
435     /**
436      * @return true if the contract is paused, false otherwise.
437      */
438     function paused() public view returns (bool) {
439         return _paused;
440     }
441 
442     /**
443      * @dev Modifier to make a function callable only when the contract is not paused.
444      */
445     modifier whenNotPaused() {
446         require(!_paused);
447         _;
448     }
449 
450     /**
451      * @dev Modifier to make a function callable only when the contract is paused.
452      */
453     modifier whenPaused() {
454         require(_paused);
455         _;
456     }
457 
458     /**
459      * @dev called by the owner to pause, triggers stopped state
460      */
461     function pause() public onlyPauser whenNotPaused {
462         _paused = true;
463         emit Paused(msg.sender);
464     }
465 
466     /**
467      * @dev called by the owner to unpause, returns to normal state
468      */
469     function unpause() public onlyPauser whenPaused {
470         _paused = false;
471         emit Unpaused(msg.sender);
472     }
473 }
474 
475 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
476 
477 pragma solidity ^0.5.0;
478 
479 
480 
481 /**
482  * @title Pausable token
483  * @dev ERC20 modified with pausable transfers.
484  **/
485 contract ERC20Pausable is ERC20, Pausable {
486     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
487         return super.transfer(to, value);
488     }
489 
490     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
491         return super.transferFrom(from, to, value);
492     }
493 
494     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
495         return super.approve(spender, value);
496     }
497 
498     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
499         return super.increaseAllowance(spender, addedValue);
500     }
501 
502     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
503         return super.decreaseAllowance(spender, subtractedValue);
504     }
505 }
506 
507 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
508 
509 pragma solidity ^0.5.0;
510 
511 
512 contract MinterRole {
513     using Roles for Roles.Role;
514 
515     event MinterAdded(address indexed account);
516     event MinterRemoved(address indexed account);
517 
518     Roles.Role private _minters;
519 
520     constructor () internal {
521         _addMinter(msg.sender);
522     }
523 
524     modifier onlyMinter() {
525         require(isMinter(msg.sender));
526         _;
527     }
528 
529     function isMinter(address account) public view returns (bool) {
530         return _minters.has(account);
531     }
532 
533     function addMinter(address account) public onlyMinter {
534         _addMinter(account);
535     }
536 
537     function renounceMinter() public {
538         _removeMinter(msg.sender);
539     }
540 
541     function _addMinter(address account) internal {
542         _minters.add(account);
543         emit MinterAdded(account);
544     }
545 
546     function _removeMinter(address account) internal {
547         _minters.remove(account);
548         emit MinterRemoved(account);
549     }
550 }
551 
552 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
553 
554 pragma solidity ^0.5.0;
555 
556 
557 
558 /**
559  * @title ERC20Mintable
560  * @dev ERC20 minting logic
561  */
562 contract ERC20Mintable is ERC20, MinterRole {
563     /**
564      * @dev Function to mint tokens
565      * @param to The address that will receive the minted tokens.
566      * @param value The amount of tokens to mint.
567      * @return A boolean that indicates if the operation was successful.
568      */
569     function mint(address to, uint256 value) public onlyMinter returns (bool) {
570         _mint(to, value);
571         return true;
572     }
573 }
574 
575 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
576 
577 pragma solidity ^0.5.0;
578 
579 /**
580  * @title Ownable
581  * @dev The Ownable contract has an owner address, and provides basic authorization control
582  * functions, this simplifies the implementation of "user permissions".
583  */
584 contract Ownable {
585     address private _owner;
586 
587     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
588 
589     /**
590      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
591      * account.
592      */
593     constructor () internal {
594         _owner = msg.sender;
595         emit OwnershipTransferred(address(0), _owner);
596     }
597 
598     /**
599      * @return the address of the owner.
600      */
601     function owner() public view returns (address) {
602         return _owner;
603     }
604 
605     /**
606      * @dev Throws if called by any account other than the owner.
607      */
608     modifier onlyOwner() {
609         require(isOwner());
610         _;
611     }
612 
613     /**
614      * @return true if `msg.sender` is the owner of the contract.
615      */
616     function isOwner() public view returns (bool) {
617         return msg.sender == _owner;
618     }
619 
620     /**
621      * @dev Allows the current owner to relinquish control of the contract.
622      * @notice Renouncing to ownership will leave the contract without an owner.
623      * It will not be possible to call the functions with the `onlyOwner`
624      * modifier anymore.
625      */
626     function renounceOwnership() public onlyOwner {
627         emit OwnershipTransferred(_owner, address(0));
628         _owner = address(0);
629     }
630 
631     /**
632      * @dev Allows the current owner to transfer control of the contract to a newOwner.
633      * @param newOwner The address to transfer ownership to.
634      */
635     function transferOwnership(address newOwner) public onlyOwner {
636         _transferOwnership(newOwner);
637     }
638 
639     /**
640      * @dev Transfers control of the contract to a newOwner.
641      * @param newOwner The address to transfer ownership to.
642      */
643     function _transferOwnership(address newOwner) internal {
644         require(newOwner != address(0));
645         emit OwnershipTransferred(_owner, newOwner);
646         _owner = newOwner;
647     }
648 }
649 
650 // File: contracts/whitelist/IWhitelist.sol
651 
652 pragma solidity ^0.5.0;
653 
654 
655 // Interface to be implemented by the Whitelist contract.
656 contract IWhitelist {
657     function isWhitelisted(address account) public view returns (bool);
658 }
659 
660 // File: contracts/token/BurnerRole.sol
661 
662 pragma solidity ^0.5.0;
663 
664 
665 
666 contract BurnerRole {
667     using Roles for Roles.Role;
668 
669     event BurnerAdded(address indexed account);
670     event BurnerRemoved(address indexed account);
671 
672     Roles.Role private _burners;
673 
674     constructor () internal {
675         _addBurner(msg.sender);
676     }
677 
678     modifier onlyBurner() {
679         require(isBurner(msg.sender));
680         _;
681     }
682 
683     function isBurner(address account) public view returns (bool) {
684         return _burners.has(account);
685     }
686 
687     function addBurner(address account) public onlyBurner {
688         _addBurner(account);
689     }
690 
691     function renounceBurner() public {
692         _removeBurner(msg.sender);
693     }
694 
695     function _addBurner(address account) internal {
696         _burners.add(account);
697         emit BurnerAdded(account);
698     }
699 
700     function _removeBurner(address account) internal {
701         _burners.remove(account);
702         emit BurnerRemoved(account);
703     }
704 }
705 
706 // File: contracts/token/ERC20Burnable.sol
707 
708 pragma solidity ^0.5.0;
709 
710 
711 
712 
713 // Only allow accounts with the burner role to burn tokens.
714 contract ERC20Burnable is ERC20, BurnerRole {
715     function burn(uint256 value) public onlyBurner() {
716         _burn(msg.sender, value);
717     }
718 
719     function burnFrom(address from, uint256 value) public onlyBurner() {
720         _burnFrom(from, value);
721     }
722 }
723 
724 // File: contracts/token/ERC20Whitelistable.sol
725 
726 pragma solidity ^0.5.0;
727 
728 
729 
730 
731 
732 
733 // Disallow transfers of the token to or from blacklisted accounts.
734 contract ERC20Whitelistable is ERC20Mintable, ERC20Burnable, Ownable {
735     event WhitelistChanged(IWhitelist indexed account);
736 
737     IWhitelist public whitelist;
738 
739     function setWhitelist(IWhitelist _whitelist) public onlyOwner {
740         whitelist = _whitelist;
741         emit WhitelistChanged(_whitelist);
742     }
743 
744     modifier onlyWhitelisted(address account) {
745         require(isWhitelisted(account));
746         _;
747     }
748 
749     modifier notWhitelisted(address account) {
750         require(!isWhitelisted(account));
751         _;
752     }
753 
754     // Returns true if the account is allowed to send and receive tokens.
755     function isWhitelisted(address account) public view returns (bool) {
756         return whitelist.isWhitelisted(account);
757     }
758 
759     function transfer(address to, uint256 value)
760         public
761         onlyWhitelisted(msg.sender)
762         onlyWhitelisted(to)
763         returns (bool)
764     {
765         return super.transfer(to, value);
766     }
767 
768     function transferFrom(address from, address to, uint256 value)
769         public
770         onlyWhitelisted(from)
771         onlyWhitelisted(to)
772         returns (bool)
773     {
774         return super.transferFrom(from, to, value);
775     }
776 
777     function mint(address to, uint256 value) public onlyWhitelisted(to) returns (bool) {
778         return super.mint(to, value);
779     }
780 
781     // Destroy the tokens held by a blacklisted account.
782     function burnBlacklisted(address from, uint256 value)
783         public
784         onlyBurner()
785         notWhitelisted(from)
786     {
787         _burn(from, value);
788     }
789 }
790 
791 // File: contracts/utils/CanReclaimEther.sol
792 
793 pragma solidity ^0.5.0;
794 
795 
796 
797 // Ether should not be sent to this contract. If any ether is accidentally sent to this
798 // contract, allow the contract owner to recover it.
799 // Copied from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/2441fd7d17bffa1944f6f539b2cddd6d19997a31/contracts/ownership/HasNoEther.sol
800 contract CanReclaimEther is Ownable {
801     function reclaimEther() external onlyOwner {
802         msg.sender.transfer(address(this).balance);
803     }
804 }
805 
806 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
807 
808 pragma solidity ^0.5.0;
809 
810 
811 
812 /**
813  * @title SafeERC20
814  * @dev Wrappers around ERC20 operations that throw on failure.
815  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
816  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
817  */
818 library SafeERC20 {
819     using SafeMath for uint256;
820 
821     function safeTransfer(IERC20 token, address to, uint256 value) internal {
822         require(token.transfer(to, value));
823     }
824 
825     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
826         require(token.transferFrom(from, to, value));
827     }
828 
829     function safeApprove(IERC20 token, address spender, uint256 value) internal {
830         // safeApprove should only be called when setting an initial allowance,
831         // or when resetting it to zero. To increase and decrease it, use
832         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
833         require((value == 0) || (token.allowance(address(this), spender) == 0));
834         require(token.approve(spender, value));
835     }
836 
837     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
838         uint256 newAllowance = token.allowance(address(this), spender).add(value);
839         require(token.approve(spender, newAllowance));
840     }
841 
842     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
843         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
844         require(token.approve(spender, newAllowance));
845     }
846 }
847 
848 // File: contracts/utils/CanReclaimToken.sol
849 
850 pragma solidity ^0.5.0;
851 
852 
853 
854 
855 // Tokens should not be sent to this contract.  If any tokens are accidentally sent to
856 // this contract, allow the contract owner to recover them.
857 // Copied from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/6c4c8989b399510a66d8b98ad75a0979482436d2/contracts/ownership/CanReclaimToken.sol
858 contract CanReclaimToken is Ownable {
859     using SafeERC20 for IERC20;
860 
861     function reclaimToken(IERC20 token) external onlyOwner {
862         uint256 balance = token.balanceOf(address(this));
863         token.safeTransfer(owner(), balance);
864     }
865 }
866 
867 // File: contracts/token/LeveragedToken.sol
868 
869 pragma solidity ^0.5.0;
870 
871 
872 
873 
874 
875 
876 
877 
878 
879 
880 contract LeveragedToken is
881     ERC20Detailed,
882     ERC20Pausable,
883     ERC20Mintable,
884     ERC20Burnable,
885     ERC20Whitelistable,
886     CanReclaimEther,
887     CanReclaimToken
888 {
889     string public underlying;
890     int8 public leverage;
891 
892     constructor(string memory name, string memory symbol, string memory _underlying, int8 _leverage)
893         ERC20Detailed(name, symbol, 18)
894         public
895     {
896         underlying = _underlying;
897         leverage = _leverage;
898     }
899 }