1 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
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
69 // File: contracts\TaxLib.sol
70 
71 /**
72  * This smart contract code is Copyright 2018 WiBX. For more information see https://wibx.io
73  *
74  * Licensed under the Apache License, version 2.0: https://github.com/wibxcoin/Contracts/LICENSE.txt
75  */
76 
77 pragma solidity 0.5.0;
78 
79 
80 /**
81  * @title Taxation Library
82  *
83  * @dev Helpers for taxation
84  */
85 library TaxLib
86 {
87     using SafeMath for uint256;
88 
89     /**
90      * Modifiable tax container
91      */
92     struct DynamicTax
93     {
94         /**
95          * Tax amount per each transaction (in %).
96          */
97         uint256 amount;
98 
99         /**
100          * The shift value.
101          * Represents: 100 * 10 ** shift
102          */
103         uint256 shift;
104     }
105 
106     /**
107      * @dev Apply percentage to the value.
108      *
109      * @param taxAmount The amount of tax
110      * @param shift The shift division amount
111      * @param value The total amount
112      * @return The tax amount to be payed (in WEI)
113      */
114     function applyTax(uint256 taxAmount, uint256 shift, uint256 value) internal pure returns (uint256)
115     {
116         uint256 temp = value.mul(taxAmount);
117 
118         return temp.div(shift);
119     }
120 
121     /**
122      * @dev Normalize the shift value
123      *
124      * @param shift The power chosen
125      */
126     function normalizeShiftAmount(uint256 shift) internal pure returns (uint256)
127     {
128         require(shift >= 0 && shift <= 2, "You can't set more than 2 decimal places");
129 
130         uint256 value = 100;
131 
132         return value.mul(10 ** shift);
133     }
134 }
135 
136 // File: contracts\VestingLib.sol
137 
138 /**
139  * This smart contract code is Copyright 2019 WiBX. For more information see https://wibx.io
140  *
141  * Licensed under the Apache License, version 2.0: https://github.com/wibxcoin/Contracts/LICENSE.txt
142  */
143 
144 pragma solidity 0.5.0;
145 
146 
147 
148 /**
149  * @title Vesting Library
150  *
151  * @dev Helpers for vesting
152  */
153 library VestingLib
154 {
155     using SafeMath for uint256;
156 
157     /**
158      * Period to get tokens (bimester).
159      */
160     uint256 private constant _timeShiftPeriod = 60 days;
161 
162     struct TeamMember
163     {
164         /**
165          * User's next token withdrawal
166          */
167         uint256 nextWithdrawal;
168 
169         /**
170          * Remaining tokens to be released
171          */
172         uint256 totalRemainingAmount;
173 
174         /**
175          * GAS Optimization.
176          * Calculates the transfer value for the first time (20%)
177          */
178         uint256 firstTransferValue;
179 
180         /**
181          * GAS Optimization.
182          * Calculates the transfer value for each month (10%)
183          */
184         uint256 eachTransferValue;
185 
186         /**
187          * Check if this member is active
188          */
189         bool active;
190     }
191 
192     /**
193      * @dev Calculate the member earnings according to the rules of the board.
194      *
195      * @param tokenAmount The total user token amount
196      * @return The first transfer amount and the other months amount.
197      */
198     function _calculateMemberEarnings(uint256 tokenAmount) internal pure returns (uint256, uint256)
199     {
200         // 20% on the first transfer (act)
201         uint256 firstTransfer = TaxLib.applyTax(20, 100, tokenAmount);
202 
203         // 10% for the other months
204         uint256 eachMonthTransfer = TaxLib.applyTax(10, 100, tokenAmount.sub(firstTransfer));
205 
206         return (firstTransfer, eachMonthTransfer);
207     }
208 
209     /**
210      * @dev Updates the date to the next user's withdrawal.
211      *
212      * @param oldWithdrawal The last user's withdrawal
213      */
214     function _updateNextWithdrawalTime(uint256 oldWithdrawal) internal view returns (uint256)
215     {
216         uint currentTimestamp = block.timestamp;
217 
218         require(oldWithdrawal <= currentTimestamp, "You need to wait the next withdrawal period");
219 
220         /**
221          * If is the user's first withdrawal, get the time of the first transfer
222          * and adds plus the time shift period.
223          */
224         if (oldWithdrawal == 0)
225         {
226             return _timeShiftPeriod.add(currentTimestamp);
227         }
228 
229         /**
230          * Otherwise adds the time shift period to the previous withdrawal date to avoid
231          * unnecessary waitings.
232          */
233         return oldWithdrawal.add(_timeShiftPeriod);
234     }
235 
236     /**
237      * @dev Calculates the amount to pay taking into account the first transfer rule.
238      *
239      * @param member The team member container
240      * @return The amount for pay
241      */
242     function _checkAmountForPay(TeamMember memory member) internal pure returns (uint256)
243     {
244         /**
245          * First user transference. It should be 20%.
246          */
247         if (member.nextWithdrawal == 0)
248         {
249             return member.firstTransferValue;
250         }
251 
252         /**
253          * Check for avoid rounding errors.
254          */
255         return member.eachTransferValue >= member.totalRemainingAmount
256             ? member.totalRemainingAmount
257             : member.eachTransferValue;
258     }
259 }
260 
261 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
262 
263 pragma solidity ^0.5.0;
264 
265 /**
266  * @title ERC20 interface
267  * @dev see https://github.com/ethereum/EIPs/issues/20
268  */
269 interface IERC20 {
270     function transfer(address to, uint256 value) external returns (bool);
271 
272     function approve(address spender, uint256 value) external returns (bool);
273 
274     function transferFrom(address from, address to, uint256 value) external returns (bool);
275 
276     function totalSupply() external view returns (uint256);
277 
278     function balanceOf(address who) external view returns (uint256);
279 
280     function allowance(address owner, address spender) external view returns (uint256);
281 
282     event Transfer(address indexed from, address indexed to, uint256 value);
283 
284     event Approval(address indexed owner, address indexed spender, uint256 value);
285 }
286 
287 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
288 
289 pragma solidity ^0.5.0;
290 
291 
292 
293 /**
294  * @title Standard ERC20 token
295  *
296  * @dev Implementation of the basic standard token.
297  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
298  * Originally based on code by FirstBlood:
299  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
300  *
301  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
302  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
303  * compliant implementations may not do it.
304  */
305 contract ERC20 is IERC20 {
306     using SafeMath for uint256;
307 
308     mapping (address => uint256) private _balances;
309 
310     mapping (address => mapping (address => uint256)) private _allowed;
311 
312     uint256 private _totalSupply;
313 
314     /**
315     * @dev Total number of tokens in existence
316     */
317     function totalSupply() public view returns (uint256) {
318         return _totalSupply;
319     }
320 
321     /**
322     * @dev Gets the balance of the specified address.
323     * @param owner The address to query the balance of.
324     * @return An uint256 representing the amount owned by the passed address.
325     */
326     function balanceOf(address owner) public view returns (uint256) {
327         return _balances[owner];
328     }
329 
330     /**
331      * @dev Function to check the amount of tokens that an owner allowed to a spender.
332      * @param owner address The address which owns the funds.
333      * @param spender address The address which will spend the funds.
334      * @return A uint256 specifying the amount of tokens still available for the spender.
335      */
336     function allowance(address owner, address spender) public view returns (uint256) {
337         return _allowed[owner][spender];
338     }
339 
340     /**
341     * @dev Transfer token for a specified address
342     * @param to The address to transfer to.
343     * @param value The amount to be transferred.
344     */
345     function transfer(address to, uint256 value) public returns (bool) {
346         _transfer(msg.sender, to, value);
347         return true;
348     }
349 
350     /**
351      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
352      * Beware that changing an allowance with this method brings the risk that someone may use both the old
353      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
354      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
355      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
356      * @param spender The address which will spend the funds.
357      * @param value The amount of tokens to be spent.
358      */
359     function approve(address spender, uint256 value) public returns (bool) {
360         require(spender != address(0));
361 
362         _allowed[msg.sender][spender] = value;
363         emit Approval(msg.sender, spender, value);
364         return true;
365     }
366 
367     /**
368      * @dev Transfer tokens from one address to another.
369      * Note that while this function emits an Approval event, this is not required as per the specification,
370      * and other compliant implementations may not emit the event.
371      * @param from address The address which you want to send tokens from
372      * @param to address The address which you want to transfer to
373      * @param value uint256 the amount of tokens to be transferred
374      */
375     function transferFrom(address from, address to, uint256 value) public returns (bool) {
376         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
377         _transfer(from, to, value);
378         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
379         return true;
380     }
381 
382     /**
383      * @dev Increase the amount of tokens that an owner allowed to a spender.
384      * approve should be called when allowed_[_spender] == 0. To increment
385      * allowed value is better to use this function to avoid 2 calls (and wait until
386      * the first transaction is mined)
387      * From MonolithDAO Token.sol
388      * Emits an Approval event.
389      * @param spender The address which will spend the funds.
390      * @param addedValue The amount of tokens to increase the allowance by.
391      */
392     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
393         require(spender != address(0));
394 
395         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
396         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
397         return true;
398     }
399 
400     /**
401      * @dev Decrease the amount of tokens that an owner allowed to a spender.
402      * approve should be called when allowed_[_spender] == 0. To decrement
403      * allowed value is better to use this function to avoid 2 calls (and wait until
404      * the first transaction is mined)
405      * From MonolithDAO Token.sol
406      * Emits an Approval event.
407      * @param spender The address which will spend the funds.
408      * @param subtractedValue The amount of tokens to decrease the allowance by.
409      */
410     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
411         require(spender != address(0));
412 
413         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
414         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
415         return true;
416     }
417 
418     /**
419     * @dev Transfer token for a specified addresses
420     * @param from The address to transfer from.
421     * @param to The address to transfer to.
422     * @param value The amount to be transferred.
423     */
424     function _transfer(address from, address to, uint256 value) internal {
425         require(to != address(0));
426 
427         _balances[from] = _balances[from].sub(value);
428         _balances[to] = _balances[to].add(value);
429         emit Transfer(from, to, value);
430     }
431 
432     /**
433      * @dev Internal function that mints an amount of the token and assigns it to
434      * an account. This encapsulates the modification of balances such that the
435      * proper events are emitted.
436      * @param account The account that will receive the created tokens.
437      * @param value The amount that will be created.
438      */
439     function _mint(address account, uint256 value) internal {
440         require(account != address(0));
441 
442         _totalSupply = _totalSupply.add(value);
443         _balances[account] = _balances[account].add(value);
444         emit Transfer(address(0), account, value);
445     }
446 
447     /**
448      * @dev Internal function that burns an amount of the token of a given
449      * account.
450      * @param account The account whose tokens will be burnt.
451      * @param value The amount that will be burnt.
452      */
453     function _burn(address account, uint256 value) internal {
454         require(account != address(0));
455 
456         _totalSupply = _totalSupply.sub(value);
457         _balances[account] = _balances[account].sub(value);
458         emit Transfer(account, address(0), value);
459     }
460 
461     /**
462      * @dev Internal function that burns an amount of the token of a given
463      * account, deducting from the sender's allowance for said account. Uses the
464      * internal burn function.
465      * Emits an Approval event (reflecting the reduced allowance).
466      * @param account The account whose tokens will be burnt.
467      * @param value The amount that will be burnt.
468      */
469     function _burnFrom(address account, uint256 value) internal {
470         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
471         _burn(account, value);
472         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
473     }
474 }
475 
476 // File: node_modules\openzeppelin-solidity\contracts\access\Roles.sol
477 
478 pragma solidity ^0.5.0;
479 
480 /**
481  * @title Roles
482  * @dev Library for managing addresses assigned to a Role.
483  */
484 library Roles {
485     struct Role {
486         mapping (address => bool) bearer;
487     }
488 
489     /**
490      * @dev give an account access to this role
491      */
492     function add(Role storage role, address account) internal {
493         require(account != address(0));
494         require(!has(role, account));
495 
496         role.bearer[account] = true;
497     }
498 
499     /**
500      * @dev remove an account's access to this role
501      */
502     function remove(Role storage role, address account) internal {
503         require(account != address(0));
504         require(has(role, account));
505 
506         role.bearer[account] = false;
507     }
508 
509     /**
510      * @dev check if an account has this role
511      * @return bool
512      */
513     function has(Role storage role, address account) internal view returns (bool) {
514         require(account != address(0));
515         return role.bearer[account];
516     }
517 }
518 
519 // File: node_modules\openzeppelin-solidity\contracts\access\roles\PauserRole.sol
520 
521 pragma solidity ^0.5.0;
522 
523 
524 contract PauserRole {
525     using Roles for Roles.Role;
526 
527     event PauserAdded(address indexed account);
528     event PauserRemoved(address indexed account);
529 
530     Roles.Role private _pausers;
531 
532     constructor () internal {
533         _addPauser(msg.sender);
534     }
535 
536     modifier onlyPauser() {
537         require(isPauser(msg.sender));
538         _;
539     }
540 
541     function isPauser(address account) public view returns (bool) {
542         return _pausers.has(account);
543     }
544 
545     function addPauser(address account) public onlyPauser {
546         _addPauser(account);
547     }
548 
549     function renouncePauser() public {
550         _removePauser(msg.sender);
551     }
552 
553     function _addPauser(address account) internal {
554         _pausers.add(account);
555         emit PauserAdded(account);
556     }
557 
558     function _removePauser(address account) internal {
559         _pausers.remove(account);
560         emit PauserRemoved(account);
561     }
562 }
563 
564 // File: node_modules\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
565 
566 pragma solidity ^0.5.0;
567 
568 
569 /**
570  * @title Pausable
571  * @dev Base contract which allows children to implement an emergency stop mechanism.
572  */
573 contract Pausable is PauserRole {
574     event Paused(address account);
575     event Unpaused(address account);
576 
577     bool private _paused;
578 
579     constructor () internal {
580         _paused = false;
581     }
582 
583     /**
584      * @return true if the contract is paused, false otherwise.
585      */
586     function paused() public view returns (bool) {
587         return _paused;
588     }
589 
590     /**
591      * @dev Modifier to make a function callable only when the contract is not paused.
592      */
593     modifier whenNotPaused() {
594         require(!_paused);
595         _;
596     }
597 
598     /**
599      * @dev Modifier to make a function callable only when the contract is paused.
600      */
601     modifier whenPaused() {
602         require(_paused);
603         _;
604     }
605 
606     /**
607      * @dev called by the owner to pause, triggers stopped state
608      */
609     function pause() public onlyPauser whenNotPaused {
610         _paused = true;
611         emit Paused(msg.sender);
612     }
613 
614     /**
615      * @dev called by the owner to unpause, returns to normal state
616      */
617     function unpause() public onlyPauser whenPaused {
618         _paused = false;
619         emit Unpaused(msg.sender);
620     }
621 }
622 
623 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Pausable.sol
624 
625 pragma solidity ^0.5.0;
626 
627 
628 
629 /**
630  * @title Pausable token
631  * @dev ERC20 modified with pausable transfers.
632  **/
633 contract ERC20Pausable is ERC20, Pausable {
634     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
635         return super.transfer(to, value);
636     }
637 
638     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
639         return super.transferFrom(from, to, value);
640     }
641 
642     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
643         return super.approve(spender, value);
644     }
645 
646     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
647         return super.increaseAllowance(spender, addedValue);
648     }
649 
650     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
651         return super.decreaseAllowance(spender, subtractedValue);
652     }
653 }
654 
655 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Detailed.sol
656 
657 pragma solidity ^0.5.0;
658 
659 
660 /**
661  * @title ERC20Detailed token
662  * @dev The decimals are only for visualization purposes.
663  * All the operations are done using the smallest and indivisible token unit,
664  * just as on Ethereum all the operations are done in wei.
665  */
666 contract ERC20Detailed is IERC20 {
667     string private _name;
668     string private _symbol;
669     uint8 private _decimals;
670 
671     constructor (string memory name, string memory symbol, uint8 decimals) public {
672         _name = name;
673         _symbol = symbol;
674         _decimals = decimals;
675     }
676 
677     /**
678      * @return the name of the token.
679      */
680     function name() public view returns (string memory) {
681         return _name;
682     }
683 
684     /**
685      * @return the symbol of the token.
686      */
687     function symbol() public view returns (string memory) {
688         return _symbol;
689     }
690 
691     /**
692      * @return the number of decimals of the token.
693      */
694     function decimals() public view returns (uint8) {
695         return _decimals;
696     }
697 }
698 
699 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Burnable.sol
700 
701 pragma solidity ^0.5.0;
702 
703 
704 /**
705  * @title Burnable Token
706  * @dev Token that can be irreversibly burned (destroyed).
707  */
708 contract ERC20Burnable is ERC20 {
709     /**
710      * @dev Burns a specific amount of tokens.
711      * @param value The amount of token to be burned.
712      */
713     function burn(uint256 value) public {
714         _burn(msg.sender, value);
715     }
716 
717     /**
718      * @dev Burns a specific amount of tokens from the target address and decrements allowance
719      * @param from address The address which you want to send tokens from
720      * @param value uint256 The amount of token to be burned
721      */
722     function burnFrom(address from, uint256 value) public {
723         _burnFrom(from, value);
724     }
725 }
726 
727 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
728 
729 pragma solidity ^0.5.0;
730 
731 /**
732  * @title Ownable
733  * @dev The Ownable contract has an owner address, and provides basic authorization control
734  * functions, this simplifies the implementation of "user permissions".
735  */
736 contract Ownable {
737     address private _owner;
738 
739     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
740 
741     /**
742      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
743      * account.
744      */
745     constructor () internal {
746         _owner = msg.sender;
747         emit OwnershipTransferred(address(0), _owner);
748     }
749 
750     /**
751      * @return the address of the owner.
752      */
753     function owner() public view returns (address) {
754         return _owner;
755     }
756 
757     /**
758      * @dev Throws if called by any account other than the owner.
759      */
760     modifier onlyOwner() {
761         require(isOwner());
762         _;
763     }
764 
765     /**
766      * @return true if `msg.sender` is the owner of the contract.
767      */
768     function isOwner() public view returns (bool) {
769         return msg.sender == _owner;
770     }
771 
772     /**
773      * @dev Allows the current owner to relinquish control of the contract.
774      * @notice Renouncing to ownership will leave the contract without an owner.
775      * It will not be possible to call the functions with the `onlyOwner`
776      * modifier anymore.
777      */
778     function renounceOwnership() public onlyOwner {
779         emit OwnershipTransferred(_owner, address(0));
780         _owner = address(0);
781     }
782 
783     /**
784      * @dev Allows the current owner to transfer control of the contract to a newOwner.
785      * @param newOwner The address to transfer ownership to.
786      */
787     function transferOwnership(address newOwner) public onlyOwner {
788         _transferOwnership(newOwner);
789     }
790 
791     /**
792      * @dev Transfers control of the contract to a newOwner.
793      * @param newOwner The address to transfer ownership to.
794      */
795     function _transferOwnership(address newOwner) internal {
796         require(newOwner != address(0));
797         emit OwnershipTransferred(_owner, newOwner);
798         _owner = newOwner;
799     }
800 }
801 
802 // File: contracts\Taxable.sol
803 
804 /**
805  * This smart contract code is Copyright 2018 WiBX. For more information see https://wibx.io
806  *
807  * Licensed under the Apache License, version 2.0: https://github.com/wibxcoin/Contracts/LICENSE.txt
808  */
809 
810 pragma solidity 0.5.0;
811 
812 
813 
814 /**
815  * @title Taxable token
816  *
817  * @dev Manages dynamic taxes
818  */
819 contract Taxable is Ownable
820 {
821     /**
822      * Tax recipient.
823      */
824     address internal _taxRecipientAddr;
825 
826     /**
827      * Modifiable tax container.
828      */
829     TaxLib.DynamicTax private _taxContainer;
830 
831     constructor(address taxRecipientAddr) public
832     {
833         _taxRecipientAddr = taxRecipientAddr;
834 
835         /**
836          * Tax: Starting at 0.9%
837          */
838         changeTax(9, 1);
839     }
840 
841     /**
842      * Returns the tax recipient account
843      */
844     function taxRecipientAddr() public view returns (address)
845     {
846         return _taxRecipientAddr;
847     }
848 
849     /**
850      * @dev Get the current tax amount.
851      */
852     function currentTaxAmount() public view returns (uint256)
853     {
854         return _taxContainer.amount;
855     }
856 
857     /**
858      * @dev Get the current tax shift.
859      */
860     function currentTaxShift() public view returns (uint256)
861     {
862         return _taxContainer.shift;
863     }
864 
865     /**
866      * @dev Change the dynamic tax.
867      *
868      * Just the contract admin can change the taxes.
869      * The possible tax range is 0% ~ 3% and cannot exceed it.
870      *
871      * Reference table:
872      * 3, 0 (3 / 100)   = 3%
873      * 3, 1 (3 / 1000)  = 0.3%
874      * 3, 2 (3 / 10000) = 0.03%
875      *
876      * @param amount The new tax amount chosen
877      */
878     function changeTax(uint256 amount, uint256 shift) public onlyOwner
879     {
880         if (shift == 0)
881         {
882             require(amount <= 3, "You can't set a tax greater than 3%");
883         }
884 
885         _taxContainer = TaxLib.DynamicTax(
886             amount,
887 
888             // The maximum decimal places value is checked here
889             TaxLib.normalizeShiftAmount(shift)
890         );
891     }
892 
893     /**
894      * @dev Apply the tax based on the dynamic tax container
895      *
896      * @param value The value of transaction
897      */
898     function _applyTax(uint256 value) internal view returns (uint256)
899     {
900         return TaxLib.applyTax(
901             _taxContainer.amount,
902             _taxContainer.shift,
903             value
904         );
905     }
906 }
907 
908 // File: contracts\BCHHandled.sol
909 
910 /**
911  * This smart contract code is Copyright 2018 WiBX. For more information see https://wibx.io
912  *
913  * Licensed under the Apache License, version 2.0: https://github.com/wibxcoin/Contracts/LICENSE.txt
914  */
915 
916 pragma solidity 0.5.0;
917 
918 /**
919  * @title BCH Handled tokens contract
920  *
921  * @dev Addresses owned by BCH
922  */
923 contract BCHHandled
924 {
925     /**
926      * The BCH module address.
927      */
928     address private _bchAddress;
929 
930     /**
931      * Accounts managed by BCH.
932      */
933     mapping (address => bool) private _bchAllowed;
934 
935     /**
936      * BCH Approval event
937      */
938     event BchApproval(address indexed to, bool state);
939 
940     constructor(address bchAddress) public
941     {
942         _bchAddress = bchAddress;
943     }
944 
945     /**
946      * @dev Check if the address is handled by BCH.
947      *
948      * @param wallet The address to check
949      */
950     function isBchHandled(address wallet) public view returns (bool)
951     {
952         return _bchAllowed[wallet];
953     }
954 
955     /**
956      * @dev Authorize the full control of BCH.
957      */
958     function bchAuthorize() public returns (bool)
959     {
960         return _changeState(true);
961     }
962 
963     /**
964      * @dev Revoke the BCH access.
965      */
966     function bchRevoke() public returns (bool)
967     {
968         return _changeState(false);
969     }
970 
971     /**
972      * @dev Check if the transaction can be handled by BCH and its authenticity.
973      *
974      * @param from The spender address
975      */
976     function canBchHandle(address from) internal view returns (bool)
977     {
978         return isBchHandled(from) && msg.sender == _bchAddress;
979     }
980 
981     /**
982      * @dev Change the BCH ownership state
983      *
984      * @param state The new state
985      */
986     function _changeState(bool state) private returns (bool)
987     {
988         emit BchApproval(msg.sender, _bchAllowed[msg.sender] = state);
989 
990         return true;
991     }
992 }
993 
994 // File: contracts\WibxToken.sol
995 
996 /**
997  * This smart contract code is Copyright 2018 WiBX. For more information see https://wibx.io
998  *
999  * Licensed under the Apache License, version 2.0: https://github.com/wibxcoin/Contracts/LICENSE.txt
1000  */
1001 
1002 pragma solidity 0.5.0;
1003 
1004 
1005 
1006 
1007 
1008 
1009 
1010 
1011 /**
1012  * @title WiBX Utility Token
1013  *
1014  * @dev Implementation of the main WiBX token smart contract.
1015  */
1016 contract WibxToken is ERC20Pausable, ERC20Burnable, ERC20Detailed, Taxable, BCHHandled
1017 {
1018     /**
1019      * 12 billion tokens raised by 18 decimal places.
1020      */
1021     uint256 public constant INITIAL_SUPPLY = 12000000000 * (10 ** 18);
1022 
1023     constructor(address bchAddress, address taxRecipientAddr) public ERC20Detailed("WiBX Utility Token", "WBX", 18)
1024                                                                      BCHHandled(bchAddress)
1025                                                                      Taxable(taxRecipientAddr)
1026     {
1027         _mint(msg.sender, INITIAL_SUPPLY);
1028     }
1029 
1030     /**
1031      * @dev Overrides the OpenZeppelin default transfer
1032      *
1033      * @param to The address to transfer to.
1034      * @param value The amount to be transferred.
1035      * @return If the operation was successful
1036      */
1037     function transfer(address to, uint256 value) public returns (bool)
1038     {
1039         return _fullTransfer(msg.sender, to, value);
1040     }
1041 
1042     /**
1043      * @dev Special WBX transfer tokens from one address to another checking the access for BCH
1044      *
1045      * @param from address The address which you want to send tokens from
1046      * @param to address The address which you want to transfer to
1047      * @param value uint256 the amount of tokens to be transferred
1048      * @return If the operation was successful
1049      */
1050     function transferFrom(address from, address to, uint256 value) public returns (bool)
1051     {
1052         if (canBchHandle(from))
1053         {
1054             return _fullTransfer(from, to, value);
1055         }
1056 
1057         /*
1058          * Exempting the tax account to avoid an infinite loop in transferring values from this wallet.
1059          */
1060         if (from == taxRecipientAddr() || to == taxRecipientAddr())
1061         {
1062             super.transferFrom(from, to, value);
1063 
1064             return true;
1065         }
1066 
1067         uint256 taxValue = _applyTax(value);
1068 
1069         // Transfer the tax to the recipient
1070         super.transferFrom(from, taxRecipientAddr(), taxValue);
1071 
1072         // Transfer user's tokens
1073         super.transferFrom(from, to, value);
1074 
1075         return true;
1076     }
1077 
1078     /**
1079      * @dev Batch token transfer (maxium 100 transfers)
1080      *
1081      * @param recipients The recipients for transfer to
1082      * @param values The values
1083      * @param from Spender address
1084      * @return If the operation was successful
1085      */
1086     function sendBatch(address[] memory recipients, uint256[] memory values, address from) public returns (bool)
1087     {
1088         /*
1089          * The maximum batch send should be 100 transactions.
1090          * Each transaction we recommend 65000 of GAS limit and the maximum block size is 6700000.
1091          * 6700000 / 65000 = ~103.0769 ∴ 100 transacitons (safe rounded).
1092          */
1093         uint maxTransactionCount = 100;
1094         uint transactionCount = recipients.length;
1095 
1096         require(transactionCount <= maxTransactionCount, "Max transaction count violated");
1097         require(transactionCount == values.length, "Wrong data");
1098 
1099         if (msg.sender == from)
1100         {
1101             return _sendBatchSelf(recipients, values, transactionCount);
1102         }
1103 
1104         return _sendBatchFrom(recipients, values, from, transactionCount);
1105     }
1106 
1107     /**
1108      * @dev Batch token transfer from MSG sender
1109      *
1110      * @param recipients The recipients for transfer to
1111      * @param values The values
1112      * @param transactionCount Total transaction count
1113      * @return If the operation was successful
1114      */
1115     function _sendBatchSelf(address[] memory recipients, uint256[] memory values, uint transactionCount) private returns (bool)
1116     {
1117         for (uint i = 0; i < transactionCount; i++)
1118         {
1119             _fullTransfer(msg.sender, recipients[i], values[i]);
1120         }
1121 
1122         return true;
1123     }
1124 
1125     /**
1126      * @dev Batch token transfer from other sender
1127      *
1128      * @param recipients The recipients for transfer to
1129      * @param values The values
1130      * @param from Spender address
1131      * @param transactionCount Total transaction count
1132      * @return If the operation was successful
1133      */
1134     function _sendBatchFrom(address[] memory recipients, uint256[] memory values, address from, uint transactionCount) private returns (bool)
1135     {
1136         for (uint i = 0; i < transactionCount; i++)
1137         {
1138             transferFrom(from, recipients[i], values[i]);
1139         }
1140 
1141         return true;
1142     }
1143 
1144     /**
1145      * @dev Special WBX transfer token for a specified address.
1146      *
1147      * @param from The address of the spender
1148      * @param to The address to transfer to.
1149      * @param value The amount to be transferred.
1150      * @return If the operation was successful
1151      */
1152     function _fullTransfer(address from, address to, uint256 value) private returns (bool)
1153     {
1154         /*
1155          * Exempting the tax account to avoid an infinite loop in transferring values from this wallet.
1156          */
1157         if (from == taxRecipientAddr() || to == taxRecipientAddr())
1158         {
1159             _transfer(from, to, value);
1160 
1161             return true;
1162         }
1163 
1164         uint256 taxValue = _applyTax(value);
1165 
1166         // Transfer the tax to the recipient
1167         _transfer(from, taxRecipientAddr(), taxValue);
1168 
1169         // Transfer user's tokens
1170         _transfer(from, to, value);
1171 
1172         return true;
1173     }
1174 }
1175 
1176 // File: contracts\WibxTokenVesting.sol
1177 
1178 /**
1179  * This smart contract code is Copyright 2019 WiBX. For more information see https://wibx.io
1180  *
1181  * Licensed under the Apache License, version 2.0: https://github.com/wibxcoin/Contracts/LICENSE.txt
1182  */
1183 
1184 pragma solidity 0.5.0;
1185 
1186 
1187 
1188 
1189 
1190 /**
1191  * @title WiBX Token Vesting
1192  *
1193  * @dev Implementation of the team token vesting
1194  */
1195 contract WibxTokenVesting is Ownable
1196 {
1197     using SafeMath for uint256;
1198 
1199     /**
1200      * Wibx Token Instance
1201      */
1202     WibxToken private _wibxToken;
1203 
1204     /**
1205      * All team members
1206      */
1207     mapping (address => VestingLib.TeamMember) private _members;
1208 
1209     /**
1210      * Total Wibx tokens allocated in this vesting contract
1211      */
1212     uint256 private _alocatedWibxVestingTokens = 0;
1213 
1214     constructor(address wibxTokenAddress) public
1215     {
1216         _wibxToken = WibxToken(wibxTokenAddress);
1217     }
1218 
1219     /**
1220      * @dev Add a new team member to withdrawal tokens.
1221      *
1222      * @param wallet The member wallet address
1223      * @param tokenAmount The token amount desired by the team member
1224      * @return If the transaction was successful
1225      */
1226     function addTeamMember(address wallet, uint256 tokenAmount) public onlyOwner returns (bool)
1227     {
1228         require(!_members[wallet].active, "Member already added");
1229 
1230         uint256 firstTransfer;
1231         uint256 eachMonthTransfer;
1232 
1233         _alocatedWibxVestingTokens = _alocatedWibxVestingTokens.add(tokenAmount);
1234         (firstTransfer, eachMonthTransfer) = VestingLib._calculateMemberEarnings(tokenAmount);
1235 
1236         _members[wallet] = VestingLib.TeamMember({
1237             totalRemainingAmount: tokenAmount,
1238             firstTransferValue: firstTransfer,
1239             eachTransferValue: eachMonthTransfer,
1240             nextWithdrawal: 0,
1241             active: true
1242         });
1243 
1244         return _members[wallet].active;
1245     }
1246 
1247     /**
1248      * @dev Withdrawal team tokens to the selected wallet
1249      *
1250      * @param wallet The team member wallet
1251      * @return If the transaction was successful
1252      */
1253     function withdrawal(address wallet) public returns (bool)
1254     {
1255         VestingLib.TeamMember storage member = _members[wallet];
1256 
1257         require(member.active, "The team member is not found");
1258         require(member.totalRemainingAmount > 0, "There is no more tokens to transfer to this wallet");
1259 
1260         uint256 amountToTransfer = VestingLib._checkAmountForPay(member);
1261         require(totalWibxVestingSupply() >= amountToTransfer, "The contract doesnt have founds to pay");
1262 
1263         uint256 nextWithdrawalTime = VestingLib._updateNextWithdrawalTime(member.nextWithdrawal);
1264 
1265         _wibxToken.transfer(wallet, amountToTransfer);
1266 
1267         member.nextWithdrawal = nextWithdrawalTime;
1268         member.totalRemainingAmount = member.totalRemainingAmount.sub(amountToTransfer);
1269         _alocatedWibxVestingTokens = _alocatedWibxVestingTokens.sub(amountToTransfer);
1270 
1271         return true;
1272     }
1273 
1274     /**
1275      * @dev Clean everything and terminate this token vesting
1276      */
1277     function terminateTokenVesting() public onlyOwner
1278     {
1279         require(_alocatedWibxVestingTokens == 0, "All withdrawals have yet to take place");
1280 
1281         if (totalWibxVestingSupply() > 0)
1282         {
1283             _wibxToken.transfer(_wibxToken.taxRecipientAddr(), totalWibxVestingSupply());
1284         }
1285 
1286         /**
1287          * Due to the Owner's Ownable (from OpenZeppelin) is not flagged as payable,
1288          * we need to cast it here.
1289          */
1290         selfdestruct(address(uint160(owner())));
1291     }
1292 
1293     /**
1294      * @dev Get the token supply in this contract to be delivered to team members.
1295      */
1296     function totalWibxVestingSupply() public view returns (uint256)
1297     {
1298         return _wibxToken.balanceOf(address(this));
1299     }
1300 
1301     /**
1302      * @dev Returns all tokens allocated to users.
1303      */
1304     function totalAlocatedWibxVestingTokens() public view returns (uint256)
1305     {
1306         return _alocatedWibxVestingTokens;
1307     }
1308 
1309     /**
1310      * @dev Get the remaining token for some member.
1311      *
1312      * @param wallet The member's wallet address.
1313      */
1314     function remainingTokenAmount(address wallet) public view returns (uint256)
1315     {
1316         return _members[wallet].totalRemainingAmount;
1317     }
1318 
1319     /**
1320      * @dev Get the next withdrawal day of the user.
1321      *
1322      * @param wallet The member's wallet address.
1323      */
1324     function nextWithdrawalTime(address wallet) public view returns (uint256)
1325     {
1326         return _members[wallet].nextWithdrawal;
1327     }
1328 }