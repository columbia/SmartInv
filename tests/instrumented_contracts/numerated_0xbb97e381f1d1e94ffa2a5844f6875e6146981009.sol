1 /**
2  * This smart contract code is Copyright 2018 WiBX. For more information see https://wibx.io
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/wibxcoin/Contracts/blob/master/LICENSE
5  * It includes parts of OpenZeppelin, licensed under the MIT License: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
6  */
7 
8 pragma solidity ^0.5.0;
9 
10 /**
11  * @title Roles
12  * @dev Library for managing addresses assigned to a Role.
13  */
14 library Roles {
15     struct Role {
16         mapping (address => bool) bearer;
17     }
18 
19     /**
20      * @dev give an account access to this role
21      */
22     function add(Role storage role, address account) internal {
23         require(account != address(0));
24         require(!has(role, account));
25 
26         role.bearer[account] = true;
27     }
28 
29     /**
30      * @dev remove an account's access to this role
31      */
32     function remove(Role storage role, address account) internal {
33         require(account != address(0));
34         require(has(role, account));
35 
36         role.bearer[account] = false;
37     }
38 
39     /**
40      * @dev check if an account has this role
41      * @return bool
42      */
43     function has(Role storage role, address account) internal view returns (bool) {
44         require(account != address(0));
45         return role.bearer[account];
46     }
47 }
48 
49 
50 
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 interface IERC20 {
57     function transfer(address to, uint256 value) external returns (bool);
58 
59     function approve(address spender, uint256 value) external returns (bool);
60 
61     function transferFrom(address from, address to, uint256 value) external returns (bool);
62 
63     function totalSupply() external view returns (uint256);
64 
65     function balanceOf(address who) external view returns (uint256);
66 
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 
76 
77 contract PauserRole {
78     using Roles for Roles.Role;
79 
80     event PauserAdded(address indexed account);
81     event PauserRemoved(address indexed account);
82 
83     Roles.Role private _pausers;
84 
85     constructor () internal {
86         _addPauser(msg.sender);
87     }
88 
89     modifier onlyPauser() {
90         require(isPauser(msg.sender));
91         _;
92     }
93 
94     function isPauser(address account) public view returns (bool) {
95         return _pausers.has(account);
96     }
97 
98     function addPauser(address account) public onlyPauser {
99         _addPauser(account);
100     }
101 
102     function renouncePauser() public {
103         _removePauser(msg.sender);
104     }
105 
106     function _addPauser(address account) internal {
107         _pausers.add(account);
108         emit PauserAdded(account);
109     }
110 
111     function _removePauser(address account) internal {
112         _pausers.remove(account);
113         emit PauserRemoved(account);
114     }
115 }
116 
117 
118 /**
119  * @title SafeMath
120  * @dev Unsigned math operations with safety checks that revert on error
121  */
122 library SafeMath {
123     /**
124     * @dev Multiplies two unsigned integers, reverts on overflow.
125     */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
128         // benefit is lost if 'b' is also tested.
129         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
130         if (a == 0) {
131             return 0;
132         }
133 
134         uint256 c = a * b;
135         require(c / a == b);
136 
137         return c;
138     }
139 
140     /**
141     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
142     */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         // Solidity only automatically asserts when dividing by 0
145         require(b > 0);
146         uint256 c = a / b;
147         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148 
149         return c;
150     }
151 
152     /**
153     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
154     */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         require(b <= a);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163     * @dev Adds two unsigned integers, reverts on overflow.
164     */
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         uint256 c = a + b;
167         require(c >= a);
168 
169         return c;
170     }
171 
172     /**
173     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
174     * reverts when dividing by zero.
175     */
176     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177         require(b != 0);
178         return a % b;
179     }
180 }
181 
182 
183 
184 
185 
186 /**
187  * @title Taxation Library
188  *
189  * @dev Helpers for taxation
190  */
191 library TaxLib
192 {
193     using SafeMath for uint256;
194 
195     /**
196      * Modifiable tax container
197      */
198     struct DynamicTax
199     {
200         /**
201          * Tax amount per each transaction (in %).
202          */
203         uint256 amount;
204 
205         /**
206          * The shift value.
207          * Represents: 100 * 10 ** shift
208          */
209         uint256 shift;
210     }
211 
212     /**
213      * @dev Apply percentage to the value.
214      *
215      * @param taxAmount The amount of tax
216      * @param shift The shift division amount
217      * @param value The total amount
218      * @return The tax amount to be payed (in WEI)
219      */
220     function applyTax(uint256 taxAmount, uint256 shift, uint256 value) internal pure returns (uint256)
221     {
222         uint256 temp = value.mul(taxAmount);
223 
224         return temp.div(shift);
225     }
226 
227     /**
228      * @dev Normalize the shift value
229      *
230      * @param shift The power chosen
231      */
232     function normalizeShiftAmount(uint256 shift) internal pure returns (uint256)
233     {
234         require(shift >= 0 && shift <= 2, "You can't set more than 2 decimal places");
235 
236         uint256 value = 100;
237 
238         return value.mul(10 ** shift);
239     }
240 }
241 
242 
243 
244 
245 /**
246  * @title Standard ERC20 token
247  *
248  * @dev Implementation of the basic standard token.
249  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
250  * Originally based on code by FirstBlood:
251  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
252  *
253  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
254  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
255  * compliant implementations may not do it.
256  */
257 contract ERC20 is IERC20 {
258     using SafeMath for uint256;
259 
260     mapping (address => uint256) private _balances;
261 
262     mapping (address => mapping (address => uint256)) private _allowed;
263 
264     uint256 private _totalSupply;
265 
266     /**
267     * @dev Total number of tokens in existence
268     */
269     function totalSupply() public view returns (uint256) {
270         return _totalSupply;
271     }
272 
273     /**
274     * @dev Gets the balance of the specified address.
275     * @param owner The address to query the balance of.
276     * @return An uint256 representing the amount owned by the passed address.
277     */
278     function balanceOf(address owner) public view returns (uint256) {
279         return _balances[owner];
280     }
281 
282     /**
283      * @dev Function to check the amount of tokens that an owner allowed to a spender.
284      * @param owner address The address which owns the funds.
285      * @param spender address The address which will spend the funds.
286      * @return A uint256 specifying the amount of tokens still available for the spender.
287      */
288     function allowance(address owner, address spender) public view returns (uint256) {
289         return _allowed[owner][spender];
290     }
291 
292     /**
293     * @dev Transfer token for a specified address
294     * @param to The address to transfer to.
295     * @param value The amount to be transferred.
296     */
297     function transfer(address to, uint256 value) public returns (bool) {
298         _transfer(msg.sender, to, value);
299         return true;
300     }
301 
302     /**
303      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
304      * Beware that changing an allowance with this method brings the risk that someone may use both the old
305      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
306      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
307      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308      * @param spender The address which will spend the funds.
309      * @param value The amount of tokens to be spent.
310      */
311     function approve(address spender, uint256 value) public returns (bool) {
312         require(spender != address(0));
313 
314         _allowed[msg.sender][spender] = value;
315         emit Approval(msg.sender, spender, value);
316         return true;
317     }
318 
319     /**
320      * @dev Transfer tokens from one address to another.
321      * Note that while this function emits an Approval event, this is not required as per the specification,
322      * and other compliant implementations may not emit the event.
323      * @param from address The address which you want to send tokens from
324      * @param to address The address which you want to transfer to
325      * @param value uint256 the amount of tokens to be transferred
326      */
327     function transferFrom(address from, address to, uint256 value) public returns (bool) {
328         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
329         _transfer(from, to, value);
330         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
331         return true;
332     }
333 
334     /**
335      * @dev Increase the amount of tokens that an owner allowed to a spender.
336      * approve should be called when allowed_[_spender] == 0. To increment
337      * allowed value is better to use this function to avoid 2 calls (and wait until
338      * the first transaction is mined)
339      * From MonolithDAO Token.sol
340      * Emits an Approval event.
341      * @param spender The address which will spend the funds.
342      * @param addedValue The amount of tokens to increase the allowance by.
343      */
344     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
345         require(spender != address(0));
346 
347         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
348         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
349         return true;
350     }
351 
352     /**
353      * @dev Decrease the amount of tokens that an owner allowed to a spender.
354      * approve should be called when allowed_[_spender] == 0. To decrement
355      * allowed value is better to use this function to avoid 2 calls (and wait until
356      * the first transaction is mined)
357      * From MonolithDAO Token.sol
358      * Emits an Approval event.
359      * @param spender The address which will spend the funds.
360      * @param subtractedValue The amount of tokens to decrease the allowance by.
361      */
362     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
363         require(spender != address(0));
364 
365         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
366         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
367         return true;
368     }
369 
370     /**
371     * @dev Transfer token for a specified addresses
372     * @param from The address to transfer from.
373     * @param to The address to transfer to.
374     * @param value The amount to be transferred.
375     */
376     function _transfer(address from, address to, uint256 value) internal {
377         require(to != address(0));
378 
379         _balances[from] = _balances[from].sub(value);
380         _balances[to] = _balances[to].add(value);
381         emit Transfer(from, to, value);
382     }
383 
384     /**
385      * @dev Internal function that mints an amount of the token and assigns it to
386      * an account. This encapsulates the modification of balances such that the
387      * proper events are emitted.
388      * @param account The account that will receive the created tokens.
389      * @param value The amount that will be created.
390      */
391     function _mint(address account, uint256 value) internal {
392         require(account != address(0));
393 
394         _totalSupply = _totalSupply.add(value);
395         _balances[account] = _balances[account].add(value);
396         emit Transfer(address(0), account, value);
397     }
398 
399     /**
400      * @dev Internal function that burns an amount of the token of a given
401      * account.
402      * @param account The account whose tokens will be burnt.
403      * @param value The amount that will be burnt.
404      */
405     function _burn(address account, uint256 value) internal {
406         require(account != address(0));
407 
408         _totalSupply = _totalSupply.sub(value);
409         _balances[account] = _balances[account].sub(value);
410         emit Transfer(account, address(0), value);
411     }
412 
413     /**
414      * @dev Internal function that burns an amount of the token of a given
415      * account, deducting from the sender's allowance for said account. Uses the
416      * internal burn function.
417      * Emits an Approval event (reflecting the reduced allowance).
418      * @param account The account whose tokens will be burnt.
419      * @param value The amount that will be burnt.
420      */
421     function _burnFrom(address account, uint256 value) internal {
422         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
423         _burn(account, value);
424         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
425     }
426 }
427 
428 
429 
430 
431 
432 /**
433  * @title Pausable
434  * @dev Base contract which allows children to implement an emergency stop mechanism.
435  */
436 contract Pausable is PauserRole {
437     event Paused(address account);
438     event Unpaused(address account);
439 
440     bool private _paused;
441 
442     constructor () internal {
443         _paused = false;
444     }
445 
446     /**
447      * @return true if the contract is paused, false otherwise.
448      */
449     function paused() public view returns (bool) {
450         return _paused;
451     }
452 
453     /**
454      * @dev Modifier to make a function callable only when the contract is not paused.
455      */
456     modifier whenNotPaused() {
457         require(!_paused);
458         _;
459     }
460 
461     /**
462      * @dev Modifier to make a function callable only when the contract is paused.
463      */
464     modifier whenPaused() {
465         require(_paused);
466         _;
467     }
468 
469     /**
470      * @dev called by the owner to pause, triggers stopped state
471      */
472     function pause() public onlyPauser whenNotPaused {
473         _paused = true;
474         emit Paused(msg.sender);
475     }
476 
477     /**
478      * @dev called by the owner to unpause, returns to normal state
479      */
480     function unpause() public onlyPauser whenPaused {
481         _paused = false;
482         emit Unpaused(msg.sender);
483     }
484 }
485 
486 
487 
488 
489 /**
490  * @title Pausable token
491  * @dev ERC20 modified with pausable transfers.
492  **/
493 contract ERC20Pausable is ERC20, Pausable {
494     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
495         return super.transfer(to, value);
496     }
497 
498     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
499         return super.transferFrom(from, to, value);
500     }
501 
502     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
503         return super.approve(spender, value);
504     }
505 
506     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
507         return super.increaseAllowance(spender, addedValue);
508     }
509 
510     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
511         return super.decreaseAllowance(spender, subtractedValue);
512     }
513 }
514 
515 
516 
517 
518 
519 /**
520  * @title ERC20Detailed token
521  * @dev The decimals are only for visualization purposes.
522  * All the operations are done using the smallest and indivisible token unit,
523  * just as on Ethereum all the operations are done in wei.
524  */
525 contract ERC20Detailed is IERC20 {
526     string private _name;
527     string private _symbol;
528     uint8 private _decimals;
529 
530     constructor (string memory name, string memory symbol, uint8 decimals) public {
531         _name = name;
532         _symbol = symbol;
533         _decimals = decimals;
534     }
535 
536     /**
537      * @return the name of the token.
538      */
539     function name() public view returns (string memory) {
540         return _name;
541     }
542 
543     /**
544      * @return the symbol of the token.
545      */
546     function symbol() public view returns (string memory) {
547         return _symbol;
548     }
549 
550     /**
551      * @return the number of decimals of the token.
552      */
553     function decimals() public view returns (uint8) {
554         return _decimals;
555     }
556 }
557 
558 
559 
560 
561 /**
562  * @title Burnable Token
563  * @dev Token that can be irreversibly burned (destroyed).
564  */
565 contract ERC20Burnable is ERC20 {
566     /**
567      * @dev Burns a specific amount of tokens.
568      * @param value The amount of token to be burned.
569      */
570     function burn(uint256 value) public {
571         _burn(msg.sender, value);
572     }
573 
574     /**
575      * @dev Burns a specific amount of tokens from the target address and decrements allowance
576      * @param from address The address which you want to send tokens from
577      * @param value uint256 The amount of token to be burned
578      */
579     function burnFrom(address from, uint256 value) public {
580         _burnFrom(from, value);
581     }
582 }
583 
584 
585 
586 
587 
588 /**
589  * @title Ownable
590  * @dev The Ownable contract has an owner address, and provides basic authorization control
591  * functions, this simplifies the implementation of "user permissions".
592  */
593 contract Ownable {
594     address private _owner;
595 
596     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
597 
598     /**
599      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
600      * account.
601      */
602     constructor () internal {
603         _owner = msg.sender;
604         emit OwnershipTransferred(address(0), _owner);
605     }
606 
607     /**
608      * @return the address of the owner.
609      */
610     function owner() public view returns (address) {
611         return _owner;
612     }
613 
614     /**
615      * @dev Throws if called by any account other than the owner.
616      */
617     modifier onlyOwner() {
618         require(isOwner());
619         _;
620     }
621 
622     /**
623      * @return true if `msg.sender` is the owner of the contract.
624      */
625     function isOwner() public view returns (bool) {
626         return msg.sender == _owner;
627     }
628 
629     /**
630      * @dev Allows the current owner to relinquish control of the contract.
631      * @notice Renouncing to ownership will leave the contract without an owner.
632      * It will not be possible to call the functions with the `onlyOwner`
633      * modifier anymore.
634      */
635     function renounceOwnership() public onlyOwner {
636         emit OwnershipTransferred(_owner, address(0));
637         _owner = address(0);
638     }
639 
640     /**
641      * @dev Allows the current owner to transfer control of the contract to a newOwner.
642      * @param newOwner The address to transfer ownership to.
643      */
644     function transferOwnership(address newOwner) public onlyOwner {
645         _transferOwnership(newOwner);
646     }
647 
648     /**
649      * @dev Transfers control of the contract to a newOwner.
650      * @param newOwner The address to transfer ownership to.
651      */
652     function _transferOwnership(address newOwner) internal {
653         require(newOwner != address(0));
654         emit OwnershipTransferred(_owner, newOwner);
655         _owner = newOwner;
656     }
657 }
658 
659 
660 
661 
662 
663 /**
664  * @title Taxable token
665  *
666  * @dev Manages dynamic taxes
667  */
668 contract Taxable is Ownable
669 {
670     /**
671      * Tax recipient.
672      */
673     address internal _taxRecipientAddr;
674 
675     /**
676      * Modifiable tax container.
677      */
678     TaxLib.DynamicTax private _taxContainer;
679 
680     constructor(address taxRecipientAddr) public
681     {
682         _taxRecipientAddr = taxRecipientAddr;
683 
684         /**
685          * Tax: Starting at 0.9%
686          */
687         changeTax(9, 1);
688     }
689 
690     /**
691      * Returns the tax recipient account
692      */
693     function taxRecipientAddr() public view returns (address)
694     {
695         return _taxRecipientAddr;
696     }
697 
698     /**
699      * @dev Get the current tax amount.
700      */
701     function currentTaxAmount() public view returns (uint256)
702     {
703         return _taxContainer.amount;
704     }
705 
706     /**
707      * @dev Get the current tax shift.
708      */
709     function currentTaxShift() public view returns (uint256)
710     {
711         return _taxContainer.shift;
712     }
713 
714     /**
715      * @dev Change the dynamic tax.
716      *
717      * Just the contract admin can change the taxes.
718      * The possible tax range is 0% ~ 3% and cannot exceed it.
719      *
720      * Reference table:
721      * 3, 0 (3 / 100)   = 3%
722      * 3, 1 (3 / 1000)  = 0.3%
723      * 3, 2 (3 / 10000) = 0.03%
724      *
725      * @param amount The new tax amount chosen
726      */
727     function changeTax(uint256 amount, uint256 shift) public onlyOwner
728     {
729         if (shift == 0)
730         {
731             require(amount <= 3, "You can't set a tax greater than 3%");
732         }
733 
734         _taxContainer = TaxLib.DynamicTax(
735             amount,
736 
737             // The maximum decimal places value is checked here
738             TaxLib.normalizeShiftAmount(shift)
739         );
740     }
741 
742     /**
743      * @dev Apply the tax based on the dynamic tax container
744      *
745      * @param value The value of transaction
746      */
747     function _applyTax(uint256 value) internal view returns (uint256)
748     {
749         return TaxLib.applyTax(
750             _taxContainer.amount,
751             _taxContainer.shift,
752             value
753         );
754     }
755 }
756 
757 
758 
759 
760 /**
761  * @title BCH Handled tokens contract
762  *
763  * @dev Addresses owned by BCH
764  */
765 contract BCHHandled
766 {
767     /**
768      * The BCH module address.
769      */
770     address private _bchAddress;
771 
772     /**
773      * Accounts managed by BCH.
774      */
775     mapping (address => bool) private _bchAllowed;
776 
777     /**
778      * BCH Approval event
779      */
780     event BchApproval(address indexed to, bool state);
781 
782     constructor(address bchAddress) public
783     {
784         _bchAddress = bchAddress;
785     }
786 
787     /**
788      * @dev Check if the address is handled by BCH.
789      *
790      * @param wallet The address to check
791      */
792     function isBchHandled(address wallet) public view returns (bool)
793     {
794         return _bchAllowed[wallet];
795     }
796 
797     /**
798      * @dev Authorize the full control of BCH.
799      */
800     function bchAuthorize() public returns (bool)
801     {
802         return _changeState(true);
803     }
804 
805     /**
806      * @dev Revoke the BCH access.
807      */
808     function bchRevoke() public returns (bool)
809     {
810         return _changeState(false);
811     }
812 
813     /**
814      * @dev Check if the transaction can be handled by BCH and its authenticity.
815      *
816      * @param from The spender address
817      */
818     function canBchHandle(address from) internal view returns (bool)
819     {
820         return isBchHandled(from) && msg.sender == _bchAddress;
821     }
822 
823     /**
824      * @dev Change the BCH ownership state
825      *
826      * @param state The new state
827      */
828     function _changeState(bool state) private returns (bool)
829     {
830         emit BchApproval(msg.sender, _bchAllowed[msg.sender] = state);
831 
832         return true;
833     }
834 }
835 
836 
837 
838 
839 /**
840  * @title WiBX Utility Token
841  *
842  * @dev Implementation of the main WiBX token smart contract.
843  */
844 contract WibxToken is ERC20Pausable, ERC20Burnable, ERC20Detailed, Taxable, BCHHandled
845 {
846     /**
847      * 12 billion tokens raised by 18 decimal places.
848      */
849     uint256 public constant INITIAL_SUPPLY = 12000000000 * (10 ** 18);
850 
851     constructor(address bchAddress, address taxRecipientAddr) public ERC20Detailed("WiBX Utility Token", "WBX", 18)
852                                                                      BCHHandled(bchAddress)
853                                                                      Taxable(taxRecipientAddr)
854     {
855         _mint(msg.sender, INITIAL_SUPPLY);
856     }
857 
858     /**
859      * @dev Overrides the OpenZeppelin default transfer
860      *
861      * @param to The address to transfer to.
862      * @param value The amount to be transferred.
863      * @return If the operation was successful
864      */
865     function transfer(address to, uint256 value) public returns (bool)
866     {
867         return _fullTransfer(msg.sender, to, value);
868     }
869 
870     /**
871      * @dev Special WBX transfer tokens from one address to another checking the access for BCH
872      *
873      * @param from address The address which you want to send tokens from
874      * @param to address The address which you want to transfer to
875      * @param value uint256 the amount of tokens to be transferred
876      * @return If the operation was successful
877      */
878     function transferFrom(address from, address to, uint256 value) public returns (bool)
879     {
880         if (canBchHandle(from))
881         {
882             return _fullTransfer(from, to, value);
883         }
884 
885         /*
886          * Exempting the tax account to avoid an infinite loop in transferring values from this wallet.
887          */
888         if (from == taxRecipientAddr() || to == taxRecipientAddr())
889         {
890             super.transferFrom(from, to, value);
891 
892             return true;
893         }
894 
895         uint256 taxValue = _applyTax(value);
896 
897         // Transfer the tax to the recipient
898         super.transferFrom(from, taxRecipientAddr(), taxValue);
899 
900         // Transfer user's tokens
901         super.transferFrom(from, to, value);
902 
903         return true;
904     }
905 
906     /**
907      * @dev Batch token transfer (maxium 100 transfers)
908      *
909      * @param recipients The recipients for transfer to
910      * @param values The values
911      * @param from Spender address
912      * @return If the operation was successful
913      */
914     function sendBatch(address[] memory recipients, uint256[] memory values, address from) public returns (bool)
915     {
916         /*
917          * The maximum batch send should be 100 transactions.
918          * Each transaction we recommend 65000 of GAS limit and the maximum block size is 6700000.
919          * 6700000 / 65000 = ~103.0769 ∴ 100 transacitons (safe rounded).
920          */
921         uint maxTransactionCount = 100;
922         uint transactionCount = recipients.length;
923 
924         require(transactionCount <= maxTransactionCount, "Max transaction count violated");
925         require(transactionCount == values.length, "Wrong data");
926 
927         if (msg.sender == from)
928         {
929             return _sendBatchSelf(recipients, values, transactionCount);
930         }
931 
932         return _sendBatchFrom(recipients, values, from, transactionCount);
933     }
934 
935     /**
936      * @dev Batch token transfer from MSG sender
937      *
938      * @param recipients The recipients for transfer to
939      * @param values The values
940      * @param transactionCount Total transaction count
941      * @return If the operation was successful
942      */
943     function _sendBatchSelf(address[] memory recipients, uint256[] memory values, uint transactionCount) private returns (bool)
944     {
945         for (uint i = 0; i < transactionCount; i++)
946         {
947             _fullTransfer(msg.sender, recipients[i], values[i]);
948         }
949 
950         return true;
951     }
952 
953     /**
954      * @dev Batch token transfer from other sender
955      *
956      * @param recipients The recipients for transfer to
957      * @param values The values
958      * @param from Spender address
959      * @param transactionCount Total transaction count
960      * @return If the operation was successful
961      */
962     function _sendBatchFrom(address[] memory recipients, uint256[] memory values, address from, uint transactionCount) private returns (bool)
963     {
964         for (uint i = 0; i < transactionCount; i++)
965         {
966             transferFrom(from, recipients[i], values[i]);
967         }
968 
969         return true;
970     }
971 
972     /**
973      * @dev Special WBX transfer token for a specified address.
974      *
975      * @param from The address of the spender
976      * @param to The address to transfer to.
977      * @param value The amount to be transferred.
978      * @return If the operation was successful
979      */
980     function _fullTransfer(address from, address to, uint256 value) private returns (bool)
981     {
982         /*
983          * Exempting the tax account to avoid an infinite loop in transferring values from this wallet.
984          */
985         if (from == taxRecipientAddr() || to == taxRecipientAddr())
986         {
987             _transfer(from, to, value);
988 
989             return true;
990         }
991 
992         uint256 taxValue = _applyTax(value);
993 
994         // Transfer the tax to the recipient
995         _transfer(from, taxRecipientAddr(), taxValue);
996 
997         // Transfer user's tokens
998         _transfer(from, to, value);
999 
1000         return true;
1001     }
1002 }