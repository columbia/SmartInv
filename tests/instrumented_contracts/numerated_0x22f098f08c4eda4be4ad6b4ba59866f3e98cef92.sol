1 // File: contracts/base/IERC20.sol
2 
3 pragma solidity ^0.5.0;
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
27 // File: contracts/base/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error.
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
95 // File: contracts/base/ERC20.sol
96 
97 pragma solidity ^0.5.0;
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
123      * @dev Total number of tokens in existence.
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
149      * @dev Transfer token to a specified address.
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
217      * @dev Transfer token for a specified addresses.
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
272 }
273 
274 // File: contracts/base/ERC20Detailed.sol
275 
276 pragma solidity ^0.5.0;
277 
278 
279 /**
280  * @title ERC20Detailed token
281  * @dev The decimals are only for visualization purposes.
282  * All the operations are done using the smallest and indivisible token unit,
283  * just as on Ethereum all the operations are done in wei.
284  */
285 contract ERC20Detailed is IERC20 {
286     string private _name;
287     string private _symbol;
288     uint8 private _decimals;
289 
290     constructor (string memory name, string memory symbol, uint8 decimals) public {
291         _name = name;
292         _symbol = symbol;
293         _decimals = decimals;
294     }
295 
296     /**
297      * @return the name of the token.
298      */
299     function name() public view returns (string memory) {
300         return _name;
301     }
302 
303     /**
304      * @return the symbol of the token.
305      */
306     function symbol() public view returns (string memory) {
307         return _symbol;
308     }
309 
310     /**
311      * @return the number of decimals of the token.
312      */
313     function decimals() public view returns (uint8) {
314         return _decimals;
315     }
316 }
317 
318 // File: contracts/base/Roles.sol
319 
320 pragma solidity ^0.5.0;
321 
322 /**
323  * @title Roles
324  * @dev Library for managing addresses assigned to a Role.
325  */
326 library Roles {
327     struct Role {
328         mapping (address => bool) bearer;
329     }
330 
331     /**
332      * @dev Give an account access to this role.
333      */
334     function add(Role storage role, address account) internal {
335         require(account != address(0));
336         require(!has(role, account));
337 
338         role.bearer[account] = true;
339     }
340 
341     /**
342      * @dev Remove an account's access to this role.
343      */
344     function remove(Role storage role, address account) internal {
345         require(account != address(0));
346         require(has(role, account));
347 
348         role.bearer[account] = false;
349     }
350 
351     /**
352      * @dev Check if an account has this role.
353      * @return bool
354      */
355     function has(Role storage role, address account) internal view returns (bool) {
356         require(account != address(0));
357         return role.bearer[account];
358     }
359 }
360 
361 // File: contracts/base/BurnRole.sol
362 
363 pragma solidity ^0.5.0;
364 
365 contract BurnRole {
366     using Roles for Roles.Role;
367 
368     event BurnerAdded(address indexed account);
369     event BurnerRemoved(address indexed account);
370 
371     Roles.Role private _burners;
372 
373     constructor () internal {
374         _addBurner(msg.sender);
375     }
376 
377     modifier onlyBurner() {
378         require(isBurner(msg.sender));
379         _;
380     }
381 
382     function isBurner(address account) public view returns (bool) {
383         return _burners.has(account);
384     }
385 
386     function addBurner(address account) public onlyBurner {
387         _addBurner(account);
388     }
389 
390     function renounceBurner() public {
391         _removeBurner(msg.sender);
392     }
393 
394     function _addBurner(address account) internal {
395         _burners.add(account);
396         emit BurnerAdded(account);
397     }
398 
399     function _removeBurner(address account) internal {
400         _burners.remove(account);
401         emit BurnerRemoved(account);
402     }
403 }
404 
405 // File: contracts/base/PauserRole.sol
406 
407 pragma solidity ^0.5.0;
408 
409 
410 contract PauserRole {
411     using Roles for Roles.Role;
412 
413     event PauserAdded(address indexed account);
414     event PauserRemoved(address indexed account);
415 
416     Roles.Role private _pausers;
417 
418     constructor () internal {
419         _addPauser(msg.sender);
420     }
421 
422     modifier onlyPauser() {
423         require(isPauser(msg.sender));
424         _;
425     }
426 
427     function isPauser(address account) public view returns (bool) {
428         return _pausers.has(account);
429     }
430 
431     function addPauser(address account) public onlyPauser {
432         _addPauser(account);
433     }
434 
435     function renouncePauser() public {
436         _removePauser(msg.sender);
437     }
438 
439     function _addPauser(address account) internal {
440         _pausers.add(account);
441         emit PauserAdded(account);
442     }
443 
444     function _removePauser(address account) internal {
445         _pausers.remove(account);
446         emit PauserRemoved(account);
447     }
448 }
449 
450 // File: contracts/base/Pausable.sol
451 
452 pragma solidity ^0.5.0;
453 
454 
455 /**
456  * @title Pausable
457  * @dev Base contract which allows children to implement an emergency stop mechanism.
458  */
459 contract Pausable is PauserRole {
460     event Paused(address account);
461     event Unpaused(address account);
462 
463     bool private _paused;
464 
465     constructor () internal {
466         _paused = false;
467     }
468 
469     /**
470      * @return True if the contract is paused, false otherwise.
471      */
472     function paused() public view returns (bool) {
473         return _paused;
474     }
475 
476     /**
477      * @dev Modifier to make a function callable only when the contract is not paused.
478      */
479     modifier whenNotPaused() {
480         require(!_paused);
481         _;
482     }
483 
484     /**
485      * @dev Modifier to make a function callable only when the contract is paused.
486      */
487     modifier whenPaused() {
488         require(_paused);
489         _;
490     }
491 
492     /**
493      * @dev Called by a pauser to pause, triggers stopped state.
494      */
495     function pause() public onlyPauser whenNotPaused {
496         _paused = true;
497         emit Paused(msg.sender);
498     }
499 
500     /**
501      * @dev Called by a pauser to unpause, returns to normal state.
502      */
503     function unpause() public onlyPauser whenPaused {
504         _paused = false;
505         emit Unpaused(msg.sender);
506     }
507 }
508 
509 // File: contracts/base/ERC20Burnable.sol
510 
511 pragma solidity ^0.5.0;
512 
513 
514 
515 
516 /**
517  * @title Burnable Token
518  * @dev Token that can be irreversibly burned (destroyed).
519  */
520 contract ERC20Burnable is ERC20, BurnRole, Pausable{
521     /**
522      * @dev Burns a specific amount of tokens.
523      * @param value The amount of token to be burned.
524      */
525     function burn(uint256 value) public onlyBurner whenNotPaused returns (bool){
526         _burn(msg.sender, value);
527         return true;
528     }
529 }
530 
531 // File: contracts/base/ERC20Pausable.sol
532 
533 pragma solidity ^0.5.0;
534 
535 
536 
537 /**
538  * @title Pausable token
539  * @dev ERC20 modified with pausable transfers.
540  */
541 contract ERC20Pausable is ERC20, Pausable {
542     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
543         return super.transfer(to, value);
544     }
545 
546     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
547         return super.transferFrom(from, to, value);
548     }
549 
550     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
551         return super.approve(spender, value);
552     }
553 
554     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
555         return super.increaseAllowance(spender, addedValue);
556     }
557 
558     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
559         return super.decreaseAllowance(spender, subtractedValue);
560     }
561 }
562 
563 // File: contracts/base/MinterRole.sol
564 
565 pragma solidity ^0.5.0;
566 
567 
568 contract MinterRole {
569     using Roles for Roles.Role;
570 
571     event MinterAdded(address indexed account);
572     event MinterRemoved(address indexed account);
573 
574     Roles.Role private _minters;
575 
576     constructor () internal {
577         _addMinter(msg.sender);
578     }
579 
580     modifier onlyMinter() {
581         require(isMinter(msg.sender));
582         _;
583     }
584 
585     function isMinter(address account) public view returns (bool) {
586         return _minters.has(account);
587     }
588 
589     function addMinter(address account) public onlyMinter {
590         _addMinter(account);
591     }
592 
593     function renounceMinter() public {
594         _removeMinter(msg.sender);
595     }
596 
597     function _addMinter(address account) internal {
598         _minters.add(account);
599         emit MinterAdded(account);
600     }
601 
602     function _removeMinter(address account) internal {
603         _minters.remove(account);
604         emit MinterRemoved(account);
605     }
606 }
607 
608 // File: contracts/base/ERC20Mintable.sol
609 
610 pragma solidity ^0.5.0;
611 
612 
613 
614 
615 /**
616  * @title ERC20Mintable
617  * @dev ERC20 minting logic.
618  */
619 contract ERC20Mintable is ERC20, MinterRole, Pausable{
620     /**
621      * @dev Function to mint tokens
622      * @param to The address that will receive the minted tokens.
623      * @param value The amount of tokens to mint.
624      * @return A boolean that indicates if the operation was successful.
625      */
626     function mint(address to, uint256 value) public onlyMinter whenNotPaused returns (bool) {
627         _mint(to, value);
628         return true;
629     }
630 }
631 
632 // File: contracts/base/ERC20Capped.sol
633 
634 pragma solidity ^0.5.0;
635 
636 
637 /**
638  * @title Capped token
639  * @dev Mintable token with a token cap.
640  */
641 contract ERC20Capped is ERC20Mintable {
642     uint256 private _cap;
643 
644     constructor (uint256 cap) public {
645         require(cap > 0);
646         _cap = cap;
647     }
648 
649     /**
650      * @return the cap for the token minting.
651      */
652     function cap() public view returns (uint256) {
653         return _cap;
654     }
655 
656     function _mint(address account, uint256 value) internal {
657         require(totalSupply().add(value) <= _cap);
658         super._mint(account, value);
659     }
660 }
661 
662 // File: contracts/base/Address.sol
663 
664 pragma solidity ^0.5.0;
665 
666 /**
667  * Utility library of inline functions on addresses
668  */
669 library Address {
670     /**
671      * Returns whether the target address is a contract
672      * @dev This function will return false if invoked during the constructor of a contract,
673      * as the code is not actually created until after the constructor finishes.
674      * @param account address of the account to check
675      * @return whether the target address is a contract
676      */
677     function isContract(address account) internal view returns (bool) {
678         uint256 size;
679         // XXX Currently there is no better way to check if there is a contract in an address
680         // than to check the size of the code at that address.
681         // See https://ethereum.stackexchange.com/a/14016/36603
682         // for more details about how this works.
683         // TODO Check this again before the Serenity release, because all addresses will be
684         // contracts then.
685         // solhint-disable-next-line no-inline-assembly
686         assembly { size := extcodesize(account) }
687         return size > 0;
688     }
689 }
690 
691 // File: contracts/base/Ownable.sol
692 
693 pragma solidity ^0.5.0;
694 
695 /**
696  * @title Ownable
697  * @dev The Ownable contract has an owner address, and provides basic authorization control
698  * functions, this simplifies the implementation of \"user permissions\".
699  */
700 contract Ownable {
701     address private _owner;
702 
703     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
704 
705     /**
706      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
707      * account.
708      */
709     constructor () internal {
710         _owner = msg.sender;
711         emit OwnershipTransferred(address(0), _owner);
712     }
713 
714     /**
715      * @return the address of the owner.
716      */
717     function owner() public view returns (address) {
718         return _owner;
719     }
720 
721     /**
722      * @dev Throws if called by any account other than the owner.
723      */
724     modifier onlyOwner() {
725         require(isOwner());
726         _;
727     }
728 
729     /**
730      * @return true if `msg.sender` is the owner of the contract.
731      */
732     function isOwner() public view returns (bool) {
733         return msg.sender == _owner;
734     }
735 
736     /**
737      * @dev Allows the current owner to relinquish control of the contract.
738      * It will not be possible to call the functions with the `onlyOwner`
739      * modifier anymore.
740      * @notice Renouncing ownership will leave the contract without an owner,
741      * thereby removing any functionality that is only available to the owner.
742      */
743     function renounceOwnership() public onlyOwner {
744         emit OwnershipTransferred(_owner, address(0));
745         _owner = address(0);
746     }
747 
748     /**
749      * @dev Allows the current owner to transfer control of the contract to a newOwner.
750      * @param newOwner The address to transfer ownership to.
751      */
752     function transferOwnership(address newOwner) public onlyOwner {
753         _transferOwnership(newOwner);
754     }
755 
756     /**
757      * @dev Transfers control of the contract to a newOwner.
758      * @param newOwner The address to transfer ownership to.
759      */
760     function _transferOwnership(address newOwner) internal {
761         require(newOwner != address(0));
762         emit OwnershipTransferred(_owner, newOwner);
763         _owner = newOwner;
764     }
765 }
766 
767 // File: contracts/fff/FFFBurn.sol
768 
769 pragma solidity ^0.5.0;
770 
771 
772 
773 
774 
775 
776 contract FFFBurn is Ownable {
777     using Address for address;
778     using SafeMath for uint256;
779 
780     ERC20Burnable private _token;
781 
782     constructor(ERC20Burnable token) public {
783         _token = token;
784     }
785 
786     function burn(uint256 value) onlyOwner public {
787         _token.burn(value);
788     }
789 }
790 
791 // File: contracts/fff/FFF.sol
792 
793 pragma solidity ^0.5.0;
794 
795 
796 
797 
798 
799 
800 
801 
802 
803 contract FFF_All is
804     ERC20,
805     ERC20Detailed,
806     ERC20Pausable,
807     ERC20Burnable,
808     ERC20Capped,
809     Ownable
810 {
811     using Address for address;
812     uint256 public INITIAL_SUPPLY = 10000000000 * (10**18);
813     mapping(address => uint8) public limit;
814     FFFBurn public burnContract;
815 
816     constructor(string memory name, string memory symbol)
817         public
818         Ownable()
819         ERC20Pausable()
820         ERC20Capped(INITIAL_SUPPLY)
821         ERC20Burnable()
822         ERC20Detailed(name, symbol, 18)
823         ERC20()
824     {
825         // mint all tokens
826         _mint(msg.sender, INITIAL_SUPPLY);
827 
828         // create burner contract
829         burnContract = new FFFBurn(this);
830         addBurner(address(burnContract));
831     }
832 
833     /**
834      * Set target address transfer limit
835      * @param addr target address
836      * @param mode limit mode (0: no limit, 1: can not transfer token, 2: can not receive token)
837      */
838     function setTransferLimit(address addr, uint8 mode) public onlyOwner {
839         require(mode == 0 || mode == 1 || mode == 2);
840 
841         if (mode == 0) {
842             delete limit[addr];
843         } else {
844             limit[addr] = mode;
845         }
846     }
847 
848     /**
849      * @dev Transfer token to a specified address.
850      * @param to The address to transfer to.
851      * @param value The amount to be transferred.
852      */
853     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
854         require(limit[msg.sender] != 1, 'from address is limited.');
855         require(limit[to] != 2, 'to address is limited.');
856         
857         _transfer(msg.sender, to, value);
858 
859         return true;
860     }
861 
862     function burnFromContract(uint256 value) onlyBurner public {
863         burnContract.burn(value);
864     }
865 }