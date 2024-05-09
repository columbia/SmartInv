1 /**
2  * Invictus Capital - CRYPTO10 Hedged
3  * https://invictuscapital.com
4  * MIT License - https://github.com/invictuscapital/smartcontracts/
5  * Uses code from the OpenZeppelin project
6  */
7 
8 
9 // File: contracts/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
10 
11 pragma solidity ^0.5.6;
12 
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
16  */
17 interface IERC20 {
18     function transfer(address to, uint256 value) external returns (bool);
19 
20     function approve(address spender, uint256 value) external returns (bool);
21 
22     function transferFrom(address from, address to, uint256 value) external returns (bool);
23 
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address who) external view returns (uint256);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 // File: contracts/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
36 
37 pragma solidity ^0.5.6;
38 
39 /**
40  * @title ERC20Detailed token
41  * @dev The decimals are only for visualization purposes.
42  * All the operations are done using the smallest and indivisible token unit,
43  * just as on Ethereum all the operations are done in wei.
44  */
45 contract ERC20Detailed is IERC20 {
46     string private _name;
47     string private _symbol;
48     uint8 private _decimals;
49 
50     constructor (string memory name, string memory symbol, uint8 decimals) public {
51         _name = name;
52         _symbol = symbol;
53         _decimals = decimals;
54     }
55 
56     /**
57      * @return the name of the token.
58      */
59     function name() public view returns (string memory) {
60         return _name;
61     }
62 
63     /**
64      * @return the symbol of the token.
65      */
66     function symbol() public view returns (string memory) {
67         return _symbol;
68     }
69 
70     /**
71      * @return the number of decimals of the token.
72      */
73     function decimals() public view returns (uint8) {
74         return _decimals;
75     }
76 }
77 
78 // File: contracts/openzeppelin-solidity/contracts/math/SafeMath.sol
79 
80 pragma solidity ^0.5.6;
81 
82 /**
83  * @title SafeMath
84  * @dev Unsigned math operations with safety checks that revert on error
85  */
86 library SafeMath {
87     /**
88     * @dev Multiplies two unsigned integers, reverts on overflow.
89     */
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92         // benefit is lost if 'b' is also tested.
93         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint256 c = a * b;
99         require(c / a == b);
100 
101         return c;
102     }
103 
104     /**
105     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
106     */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Solidity only automatically asserts when dividing by 0
109         require(b > 0);
110         uint256 c = a / b;
111         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112 
113         return c;
114     }
115 
116     /**
117     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
118     */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b <= a);
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127     * @dev Adds two unsigned integers, reverts on overflow.
128     */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a);
132 
133         return c;
134     }
135 
136     /**
137     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
138     * reverts when dividing by zero.
139     */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b != 0);
142         return a % b;
143     }
144 }
145 
146 // File: contracts/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
147 
148 pragma solidity ^0.5.6;
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implementation of the basic standard token.
154  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
155  * Originally based on code by FirstBlood:
156  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  *
158  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
159  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
160  * compliant implementations may not do it.
161  */
162 contract ERC20 is IERC20 {
163     using SafeMath for uint256;
164 
165     mapping (address => uint256) private _balances;
166 
167     mapping (address => mapping (address => uint256)) private _allowed;
168 
169     uint256 private _totalSupply;
170 
171     /**
172     * @dev Total number of tokens in existence
173     */
174     function totalSupply() public view returns (uint256) {
175         return _totalSupply;
176     }
177 
178     /**
179     * @dev Gets the balance of the specified address.
180     * @param owner The address to query the balance of.
181     * @return An uint256 representing the amount owned by the passed address.
182     */
183     function balanceOf(address owner) public view returns (uint256) {
184         return _balances[owner];
185     }
186 
187     /**
188      * @dev Function to check the amount of tokens that an owner allowed to a spender.
189      * @param owner address The address which owns the funds.
190      * @param spender address The address which will spend the funds.
191      * @return A uint256 specifying the amount of tokens still available for the spender.
192      */
193     function allowance(address owner, address spender) public view returns (uint256) {
194         return _allowed[owner][spender];
195     }
196 
197     /**
198     * @dev Transfer token for a specified address
199     * @param to The address to transfer to.
200     * @param value The amount to be transferred.
201     */
202     function transfer(address to, uint256 value) public returns (bool) {
203         _transfer(msg.sender, to, value);
204         return true;
205     }
206 
207     /**
208      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209      * Beware that changing an allowance with this method brings the risk that someone may use both the old
210      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213      * @param spender The address which will spend the funds.
214      * @param value The amount of tokens to be spent.
215      */
216     function approve(address spender, uint256 value) public returns (bool) {
217         require(spender != address(0));
218 
219         _allowed[msg.sender][spender] = value;
220         emit Approval(msg.sender, spender, value);
221         return true;
222     }
223 
224     /**
225      * @dev Transfer tokens from one address to another.
226      * Note that while this function emits an Approval event, this is not required as per the specification,
227      * and other compliant implementations may not emit the event.
228      * @param from address The address which you want to send tokens from
229      * @param to address The address which you want to transfer to
230      * @param value uint256 the amount of tokens to be transferred
231      */
232     function transferFrom(address from, address to, uint256 value) public returns (bool) {
233         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
234         _transfer(from, to, value);
235         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
236         return true;
237     }
238 
239     /**
240      * @dev Increase the amount of tokens that an owner allowed to a spender.
241      * approve should be called when allowed_[_spender] == 0. To increment
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * From MonolithDAO Token.sol
245      * Emits an Approval event.
246      * @param spender The address which will spend the funds.
247      * @param addedValue The amount of tokens to increase the allowance by.
248      */
249     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
250         require(spender != address(0));
251 
252         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
253         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
254         return true;
255     }
256 
257     /**
258      * @dev Decrease the amount of tokens that an owner allowed to a spender.
259      * approve should be called when allowed_[_spender] == 0. To decrement
260      * allowed value is better to use this function to avoid 2 calls (and wait until
261      * the first transaction is mined)
262      * From MonolithDAO Token.sol
263      * Emits an Approval event.
264      * @param spender The address which will spend the funds.
265      * @param subtractedValue The amount of tokens to decrease the allowance by.
266      */
267     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
268         require(spender != address(0));
269 
270         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
271         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
272         return true;
273     }
274 
275     /**
276     * @dev Transfer token for a specified addresses
277     * @param from The address to transfer from.
278     * @param to The address to transfer to.
279     * @param value The amount to be transferred.
280     */
281     function _transfer(address from, address to, uint256 value) internal {
282         require(to != address(0));
283 
284         _balances[from] = _balances[from].sub(value);
285         _balances[to] = _balances[to].add(value);
286         emit Transfer(from, to, value);
287     }
288 
289     /**
290      * @dev Internal function that mints an amount of the token and assigns it to
291      * an account. This encapsulates the modification of balances such that the
292      * proper events are emitted.
293      * @param account The account that will receive the created tokens.
294      * @param value The amount that will be created.
295      */
296     function _mint(address account, uint256 value) internal {
297         require(account != address(0));
298 
299         _totalSupply = _totalSupply.add(value);
300         _balances[account] = _balances[account].add(value);
301         emit Transfer(address(0), account, value);
302     }
303 
304     /**
305      * @dev Internal function that burns an amount of the token of a given
306      * account.
307      * @param account The account whose tokens will be burnt.
308      * @param value The amount that will be burnt.
309      */
310     function _burn(address account, uint256 value) internal {
311         require(account != address(0));
312 
313         _totalSupply = _totalSupply.sub(value);
314         _balances[account] = _balances[account].sub(value);
315         emit Transfer(account, address(0), value);
316     }
317 
318     /**
319      * @dev Internal function that burns an amount of the token of a given
320      * account, deducting from the sender's allowance for said account. Uses the
321      * internal burn function.
322      * Emits an Approval event (reflecting the reduced allowance).
323      * @param account The account whose tokens will be burnt.
324      * @param value The amount that will be burnt.
325      */
326     function _burnFrom(address account, uint256 value) internal {
327         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
328         _burn(account, value);
329         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
330     }
331 }
332 
333 // File: contracts/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
334 
335 pragma solidity ^0.5.6;
336 
337 /**
338  * @title Burnable Token
339  * @dev Token that can be irreversibly burned (destroyed).
340  */
341 contract ERC20Burnable is ERC20 {
342     /**
343      * @dev Burns a specific amount of tokens.
344      * @param value The amount of token to be burned.
345      */
346     function burn(uint256 value) public {
347         _burn(msg.sender, value);
348     }
349 
350     /**
351      * @dev Burns a specific amount of tokens from the target address and decrements allowance
352      * @param from address The address which you want to send tokens from
353      * @param value uint256 The amount of token to be burned
354      */
355     function burnFrom(address from, uint256 value) public {
356         _burnFrom(from, value);
357     }
358 }
359 
360 // File: contracts/openzeppelin-solidity/contracts/ownership/Ownable.sol
361 
362 pragma solidity ^0.5.6;
363 
364 /**
365  * @title Ownable
366  * @dev The Ownable contract has an owner address, and provides basic authorization control
367  * functions, this simplifies the implementation of "user permissions".
368  */
369 contract Ownable {
370     address private _owner;
371 
372     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
373 
374     /**
375      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
376      * account.
377      */
378     constructor () internal {
379         _owner = msg.sender;
380         emit OwnershipTransferred(address(0), _owner);
381     }
382 
383     /**
384      * @return the address of the owner.
385      */
386     function owner() public view returns (address) {
387         return _owner;
388     }
389 
390     /**
391      * @dev Throws if called by any account other than the owner.
392      */
393     modifier onlyOwner() {
394         require(isOwner());
395         _;
396     }
397 
398     /**
399      * @return true if `msg.sender` is the owner of the contract.
400      */
401     function isOwner() public view returns (bool) {
402         return msg.sender == _owner;
403     }
404 
405     /**
406      * @dev Allows the current owner to relinquish control of the contract.
407      * @notice Renouncing to ownership will leave the contract without an owner.
408      * It will not be possible to call the functions with the `onlyOwner`
409      * modifier anymore.
410      */
411     function renounceOwnership() public onlyOwner {
412         emit OwnershipTransferred(_owner, address(0));
413         _owner = address(0);
414     }
415 
416     /**
417      * @dev Allows the current owner to transfer control of the contract to a newOwner.
418      * @param newOwner The address to transfer ownership to.
419      */
420     function transferOwnership(address newOwner) public onlyOwner {
421         _transferOwnership(newOwner);
422     }
423 
424     /**
425      * @dev Transfers control of the contract to a newOwner.
426      * @param newOwner The address to transfer ownership to.
427      */
428     function _transferOwnership(address newOwner) internal {
429         require(newOwner != address(0));
430         emit OwnershipTransferred(_owner, newOwner);
431         _owner = newOwner;
432     }
433 }
434 
435 // File: contracts/openzeppelin-solidity/contracts/access/Roles.sol
436 
437 pragma solidity ^0.5.6;
438 
439 /**
440  * @title Roles
441  * @dev Library for managing addresses assigned to a Role.
442  */
443 library Roles {
444     struct Role {
445         mapping (address => bool) bearer;
446     }
447 
448     /**
449      * @dev give an account access to this role
450      */
451     function add(Role storage role, address account) internal {
452         require(account != address(0));
453         require(!has(role, account));
454 
455         role.bearer[account] = true;
456     }
457 
458     /**
459      * @dev remove an account's access to this role
460      */
461     function remove(Role storage role, address account) internal {
462         require(account != address(0));
463         require(has(role, account));
464 
465         role.bearer[account] = false;
466     }
467 
468     /**
469      * @dev check if an account has this role
470      * @return bool
471      */
472     function has(Role storage role, address account) internal view returns (bool) {
473         require(account != address(0));
474         return role.bearer[account];
475     }
476 }
477 
478 // File: contracts/openzeppelin-solidity/contracts/access/roles/PauserRole.sol
479 
480 pragma solidity ^0.5.6;
481 
482 
483 contract PauserRole {
484     using Roles for Roles.Role;
485 
486     event PauserAdded(address indexed account);
487     event PauserRemoved(address indexed account);
488 
489     Roles.Role private _pausers;
490 
491     constructor () internal {
492         _addPauser(msg.sender);
493     }
494 
495     modifier onlyPauser() {
496         require(isPauser(msg.sender));
497         _;
498     }
499 
500     function isPauser(address account) public view returns (bool) {
501         return _pausers.has(account);
502     }
503 
504     function addPauser(address account) public onlyPauser {
505         _addPauser(account);
506     }
507 
508     function renouncePauser() public {
509         _removePauser(msg.sender);
510     }
511 
512     function _addPauser(address account) internal {
513         _pausers.add(account);
514         emit PauserAdded(account);
515     }
516 
517     function _removePauser(address account) internal {
518         _pausers.remove(account);
519         emit PauserRemoved(account);
520     }
521 }
522 
523 // File: contracts/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
524 
525 pragma solidity ^0.5.6;
526 
527 /**
528  * @title Pausable
529  * @dev Base contract which allows children to implement an emergency stop mechanism.
530  */
531 contract Pausable is PauserRole {
532     event Paused(address account);
533     event Unpaused(address account);
534 
535     bool private _paused;
536 
537     constructor () internal {
538         _paused = false;
539     }
540 
541     /**
542      * @return true if the contract is paused, false otherwise.
543      */
544     function paused() public view returns (bool) {
545         return _paused;
546     }
547 
548     /**
549      * @dev Modifier to make a function callable only when the contract is not paused.
550      */
551     modifier whenNotPaused() {
552         require(!_paused);
553         _;
554     }
555 
556     /**
557      * @dev Modifier to make a function callable only when the contract is paused.
558      */
559     modifier whenPaused() {
560         require(_paused);
561         _;
562     }
563 
564     /**
565      * @dev called by the owner to pause, triggers stopped state
566      */
567     function pause() public onlyPauser whenNotPaused {
568         _paused = true;
569         emit Paused(msg.sender);
570     }
571 
572     /**
573      * @dev called by the owner to unpause, returns to normal state
574      */
575     function unpause() public onlyPauser whenPaused {
576         _paused = false;
577         emit Unpaused(msg.sender);
578     }
579 }
580 
581 // File: contracts/openzeppelin-solidity/contracts/access/roles/MinterRole.sol
582 
583 pragma solidity ^0.5.6;
584 
585 contract MinterRole {
586     using Roles for Roles.Role;
587 
588     event MinterAdded(address indexed account);
589     event MinterRemoved(address indexed account);
590 
591     Roles.Role private _minters;
592 
593     constructor () internal {
594         _addMinter(msg.sender);
595     }
596 
597     modifier onlyMinter() {
598         require(isMinter(msg.sender));
599         _;
600     }
601 
602     function isMinter(address account) public view returns (bool) {
603         return _minters.has(account);
604     }
605 
606     function addMinter(address account) public onlyMinter {
607         _addMinter(account);
608     }
609 
610     function renounceMinter() public {
611         _removeMinter(msg.sender);
612     }
613 
614     function _addMinter(address account) internal {
615         _minters.add(account);
616         emit MinterAdded(account);
617     }
618 
619     function _removeMinter(address account) internal {
620         _minters.remove(account);
621         emit MinterRemoved(account);
622     }
623 }
624 
625 // File: contracts/openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
626 
627 pragma solidity ^0.5.6;
628 
629 /**
630  * @title WhitelistAdminRole
631  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
632  */
633 contract WhitelistAdminRole {
634     using Roles for Roles.Role;
635 
636     event WhitelistAdminAdded(address indexed account);
637     event WhitelistAdminRemoved(address indexed account);
638 
639     Roles.Role private _whitelistAdmins;
640 
641     constructor () internal {
642         _addWhitelistAdmin(msg.sender);
643     }
644 
645     modifier onlyWhitelistAdmin() {
646         require(isWhitelistAdmin(msg.sender));
647         _;
648     }
649 
650     function isWhitelistAdmin(address account) public view returns (bool) {
651         return _whitelistAdmins.has(account);
652     }
653 
654     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
655         _addWhitelistAdmin(account);
656     }
657 
658     function renounceWhitelistAdmin() public {
659         _removeWhitelistAdmin(msg.sender);
660     }
661 
662     function _addWhitelistAdmin(address account) internal {
663         _whitelistAdmins.add(account);
664         emit WhitelistAdminAdded(account);
665     }
666 
667     function _removeWhitelistAdmin(address account) internal {
668         _whitelistAdmins.remove(account);
669         emit WhitelistAdminRemoved(account);
670     }
671 }
672 
673 // File: contracts/openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
674 
675 pragma solidity ^0.5.6;
676 
677 /**
678  * @title WhitelistedRole
679  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
680  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
681  * it), and not Whitelisteds themselves.
682  */
683 contract WhitelistedRole is WhitelistAdminRole {
684     using Roles for Roles.Role;
685 
686     event WhitelistedAdded(address indexed account);
687     event WhitelistedRemoved(address indexed account);
688 
689     Roles.Role private _whitelisteds;
690 
691     modifier onlyWhitelisted() {
692         require(isWhitelisted(msg.sender));
693         _;
694     }
695 
696     function isWhitelisted(address account) public view returns (bool) {
697         return _whitelisteds.has(account);
698     }
699 
700     function addWhitelisted(address account) public onlyWhitelistAdmin {
701         _addWhitelisted(account);
702     }
703 
704     function removeWhitelisted(address account) public onlyWhitelistAdmin {
705         _removeWhitelisted(account);
706     }
707 
708     function renounceWhitelisted() public {
709         _removeWhitelisted(msg.sender);
710     }
711 
712     function _addWhitelisted(address account) internal {
713         _whitelisteds.add(account);
714         emit WhitelistedAdded(account);
715     }
716 
717     function _removeWhitelisted(address account) internal {
718         _whitelisteds.remove(account);
719         emit WhitelistedRemoved(account);
720     }
721 }
722 
723 // File: contracts/InvictusWhitelist.sol
724 
725 pragma solidity ^0.5.6;
726 
727 /**
728  * Manages whitelisted addresses.
729  *
730  */
731 contract InvictusWhitelist is Ownable, WhitelistedRole {
732     constructor ()
733         WhitelistedRole() public {
734     }
735 
736     /// @dev override to support legacy name
737     function verifyParticipant(address participant) public onlyWhitelistAdmin {
738         if (!isWhitelisted(participant)) {
739             addWhitelisted(participant);
740         }
741     }
742 
743     /// Allow the owner to remove a whitelistAdmin
744     function removeWhitelistAdmin(address account) public onlyOwner {
745         require(account != msg.sender, "Use renounceWhitelistAdmin");
746         _removeWhitelistAdmin(account);
747     }
748 }
749 
750 // File: contracts/C10Token.sol
751 
752 pragma solidity ^0.5.6;
753 
754 /**
755  * Contract for CRYPTO10 Hedged (C10) fund.
756  *
757  */
758 contract C10Token is ERC20Detailed, ERC20Burnable, Ownable, Pausable, MinterRole {
759 
760     // Maps participant addresses to the eth balance pending token issuance
761     mapping(address => uint256) public pendingBuys;
762     // The participant accounts waiting for token issuance
763     address[] public participantAddresses;
764 
765     // Maps participant addresses to the withdrawal request
766     mapping (address => uint256) public pendingWithdrawals;
767     address payable[] public withdrawals;
768 
769     uint256 public minimumWei = 50 finney;
770     uint256 public entryFee = 50;  // 0.5% , or 50 bips
771     uint256 public exitFee = 50;  // 0.5% , or 50 bips
772     uint256 public minTokenRedemption = 1 ether;
773     uint256 public maxAllocationsPerTx = 50;
774     uint256 public maxWithdrawalsPerTx = 50;
775     Price public price;
776 
777     address public whitelistContract;
778 
779     struct Price {
780         uint256 numerator;
781         uint256 denominator;
782     }
783 
784     event PriceUpdate(uint256 numerator, uint256 denominator);
785     event AddLiquidity(uint256 value);
786     event RemoveLiquidity(uint256 value);
787     event DepositReceived(address indexed participant, uint256 value);
788     event TokensIssued(address indexed participant, uint256 amountTokens, uint256 etherAmount);
789     event WithdrawRequest(address indexed participant, uint256 amountTokens);
790     event Withdraw(address indexed participant, uint256 amountTokens, uint256 etherAmount);
791     event WithdrawInvalidAddress(address indexed participant, uint256 amountTokens);
792     event WithdrawFailed(address indexed participant, uint256 amountTokens);
793     event TokensClaimed(address indexed token, uint256 balance);
794 
795     constructor (uint256 priceNumeratorInput, address whitelistContractInput)
796         ERC20Detailed("CRYPTO10 Hedged", "C10", 18)
797         ERC20Burnable()
798         Pausable() public {
799             price = Price(priceNumeratorInput, 1000);
800             require(priceNumeratorInput > 0, "Invalid price numerator");
801             require(whitelistContractInput != address(0), "Invalid whitelist address");
802             whitelistContract = whitelistContractInput;
803     }
804 
805     /**
806      * @dev fallback function that buys tokens if the sender is whitelisted.
807      */
808     function () external payable {
809         buyTokens(msg.sender);
810     }
811 
812     /**
813      * @dev Explicitly buy via contract.
814      */
815     function buy() external payable {
816         buyTokens(msg.sender);
817     }
818 
819     /**
820      * Sets the maximum number of allocations in a single transaction.
821      * @dev Allows us to configure batch sizes and avoid running out of gas.
822      */
823     function setMaxAllocationsPerTx(uint256 newMaxAllocationsPerTx) external onlyOwner {
824         require(newMaxAllocationsPerTx > 0, "Must be greater than 0");
825         maxAllocationsPerTx = newMaxAllocationsPerTx;
826     }
827 
828     /**
829      * Sets the maximum number of withdrawals in a single transaction.
830      * @dev Allows us to configure batch sizes and avoid running out of gas.
831      */
832     function setMaxWithdrawalsPerTx(uint256 newMaxWithdrawalsPerTx) external onlyOwner {
833         require(newMaxWithdrawalsPerTx > 0, "Must be greater than 0");
834         maxWithdrawalsPerTx = newMaxWithdrawalsPerTx;
835     }
836 
837     function setEntryFee(uint256 newFee) external onlyOwner {
838         require(newFee < 10000, "Must be less than 100 percent");
839         entryFee = newFee;
840     }
841 
842     function setExitFee(uint256 newFee) external onlyOwner {
843         require(newFee < 10000, "Must be less than 100 percent");
844         exitFee = newFee;
845     }
846 
847     /// Sets the minimum wei when buying tokens.
848     function setMinimumBuyValue(uint256 newMinimumWei) external onlyOwner {
849         require(newMinimumWei > 0, "Minimum must be greater than 0");
850         minimumWei = newMinimumWei;
851     }
852 
853     /// Sets the minimum number of tokens to redeem.
854     function setMinimumTokenRedemption(uint256 newMinTokenRedemption) external onlyOwner {
855         require(newMinTokenRedemption > 0, "Minimum must be greater than 0");
856         minTokenRedemption = newMinTokenRedemption;
857     }
858 
859     /// Updates the price numerator.
860     function updatePrice(uint256 newNumerator) external onlyMinter {
861         require(newNumerator > 0, "Must be positive value");
862 
863         price.numerator = newNumerator;
864 
865         allocateTokens();
866         processWithdrawals();
867         emit PriceUpdate(price.numerator, price.denominator);
868     }
869 
870     /// Updates the price denominator.
871     function updatePriceDenominator(uint256 newDenominator) external onlyMinter {
872         require(newDenominator > 0, "Must be positive value");
873 
874         price.denominator = newDenominator;
875     }
876 
877     /**
878      * Whitelisted token holders can request token redemption, and withdraw ETH.
879      * @param amountTokensToWithdraw The number of tokens to withdraw.
880      * @dev withdrawn tokens are burnt.
881      */
882     function requestWithdrawal(uint256 amountTokensToWithdraw) external whenNotPaused 
883         onlyWhitelisted {
884 
885         address payable participant = msg.sender;
886         require(balanceOf(participant) >= amountTokensToWithdraw, 
887             "Cannot withdraw more than balance held");
888         require(amountTokensToWithdraw >= minTokenRedemption, "Too few tokens");
889 
890         burn(amountTokensToWithdraw);
891 
892         uint256 pendingAmount = pendingWithdrawals[participant];
893         if (pendingAmount == 0) {
894             withdrawals.push(participant);
895         }
896         pendingWithdrawals[participant] = pendingAmount.add(amountTokensToWithdraw);
897         emit WithdrawRequest(participant, amountTokensToWithdraw);
898     }
899 
900     /// Allows owner to claim any ERC20 tokens.
901     function claimTokens(ERC20 token) external onlyOwner {
902         require(address(token) != address(0), "Invalid address");
903         uint256 balance = token.balanceOf(address(this));
904         token.transfer(owner(), token.balanceOf(address(this)));
905         emit TokensClaimed(address(token), balance);
906     }
907     
908     /**
909      * @dev Allows the owner to burn a specific amount of tokens on a participant's behalf.
910      * @param value The amount of tokens to be burned.
911      */
912     function burnForParticipant(address account, uint256 value) external onlyOwner {
913         _burn(account, value);
914     }
915 
916 
917     /// Adds liquidity to the contract, allowing anyone to deposit ETH
918     function addLiquidity() external payable {
919         require(msg.value > 0, "Must be positive value");
920         emit AddLiquidity(msg.value);
921     }
922 
923     /// Removes liquidity, allowing owner to transfer eth to the owner.
924     function removeLiquidity(uint256 amount) external onlyOwner {
925         require(amount <= address(this).balance, "Insufficient balance");
926 
927         msg.sender.transfer(amount);
928         emit RemoveLiquidity(amount);
929     }
930 
931     /// Allow the owner to remove a minter
932     function removeMinter(address account) external onlyOwner {
933         require(account != msg.sender, "Use renounceMinter");
934         _removeMinter(account);
935     }
936 
937     /// Allow the owner to remove a pauser
938     function removePauser(address account) external onlyOwner {
939         require(account != msg.sender, "Use renouncePauser");
940         _removePauser(account);
941     }
942 
943     /// returns the number of withdrawals pending.
944     function numberWithdrawalsPending() external view returns (uint256) {
945         return withdrawals.length;
946     }
947 
948     /// returns the number of pending buys, waiting for token issuance.
949     function numberBuysPending() external view returns (uint256) {
950         return participantAddresses.length;
951     }
952 
953     /**
954      * @dev Function to mint tokens when not paused.
955      * @param to The address that will receive the minted tokens.
956      * @param value The amount of tokens to mint.
957      * @return A boolean that indicates if the operation was successful.
958      */
959     function mint(address to, uint256 value) public onlyMinter whenNotPaused returns (bool) {
960         _mint(to, value);
961         return true;
962     }
963 
964     /**
965      * First phase of the 2-part buy, the participant deposits eth and waits
966      * for a price to be set so the tokens can be minted.
967      * @param participant whitelisted buyer.
968      */
969     function buyTokens(address participant) internal whenNotPaused onlyWhitelisted {
970         assert(participant != address(0));
971 
972         // Ensure minimum investment is met
973         require(msg.value >= minimumWei, "Minimum wei not met");
974 
975         uint256 pendingAmount = pendingBuys[participant];
976         if (pendingAmount == 0) {
977             participantAddresses.push(participant);
978         }
979 
980         // Increase the pending balance and wait for the price update
981         pendingBuys[participant] = pendingAmount.add(msg.value);
982 
983         emit DepositReceived(participant, msg.value);
984     }
985 
986     /// Internal function to allocate token.
987     function allocateTokens() internal {
988         uint256 numberOfAllocations = min(participantAddresses.length, maxAllocationsPerTx);
989         uint256 startingIndex = participantAddresses.length;
990         uint256 endingIndex = participantAddresses.length.sub(numberOfAllocations);
991 
992         for (uint256 i = startingIndex; i > endingIndex; i--) {
993             handleAllocation(i - 1);
994         }
995     }
996 
997     function handleAllocation(uint256 index) internal {
998         address participant = participantAddresses[index];
999         uint256 deposit = pendingBuys[participant];
1000         uint256 feeAmount = deposit.mul(entryFee) / 10000;
1001         uint256 balance = deposit.sub(feeAmount);
1002 
1003         uint256 newTokens = balance.mul(price.numerator) / price.denominator;
1004         pendingBuys[participant] = 0;
1005         participantAddresses.pop();
1006 
1007         if (feeAmount > 0) {
1008             address(uint160(owner())).transfer(feeAmount);
1009         }
1010 
1011         mint(participant, newTokens);
1012         emit TokensIssued(participant, newTokens, balance);
1013     }
1014 
1015     /// Internal function to process withdrawals.
1016     function processWithdrawals() internal {
1017         uint256 numberOfWithdrawals = min(withdrawals.length, maxWithdrawalsPerTx);
1018         uint256 startingIndex = withdrawals.length;
1019         uint256 endingIndex = withdrawals.length.sub(numberOfWithdrawals);
1020 
1021         for (uint256 i = startingIndex; i > endingIndex; i--) {
1022             handleWithdrawal(i - 1);
1023         }
1024     }
1025 
1026     function handleWithdrawal(uint256 index) internal {
1027         address payable participant = withdrawals[index];
1028         uint256 tokens = pendingWithdrawals[participant];
1029         uint256 withdrawValue = tokens.mul(price.denominator) / price.numerator;
1030         pendingWithdrawals[participant] = 0;
1031         withdrawals.pop();
1032 
1033         if (address(this).balance < withdrawValue) {
1034             mint(participant, tokens);
1035             emit WithdrawFailed(participant, tokens);
1036             return;
1037         }
1038 
1039         uint256 feeAmount = withdrawValue.mul(exitFee) / 10000;
1040         uint256 balance = withdrawValue.sub(feeAmount);
1041         if (participant.send(balance)) {
1042             if (feeAmount > 0) {
1043                 address(uint160(owner())).transfer(feeAmount);
1044             }
1045             emit Withdraw(participant, tokens, balance);
1046         } else {
1047             mint(participant, tokens);
1048             emit WithdrawInvalidAddress(participant, tokens);
1049         }
1050     }
1051 
1052     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1053         return a < b ? a : b;
1054     }
1055 
1056     modifier onlyWhitelisted() {
1057         require(InvictusWhitelist(whitelistContract).isWhitelisted(msg.sender), "Must be whitelisted");
1058         _;
1059     }
1060 }