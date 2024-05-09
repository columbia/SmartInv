1 // File: contracts/Token/IERC20.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender) external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value) external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: contracts/library/SafeMath.sol
28 
29 pragma solidity ^0.4.24;
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that revert on error
34  */
35 library SafeMath {
36 
37     /**
38     * @dev Multiplies two numbers, reverts on overflow.
39     */
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42         // benefit is lost if 'b' is also tested.
43         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b);
50 
51         return c;
52     }
53 
54     /**
55     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
56     */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b > 0); // Solidity only automatically asserts when dividing by 0
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two numbers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: contracts/Token/ERC20.sol
96 
97 pragma solidity ^0.4.24;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract ERC20 is IERC20 {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) internal _balances;
112 
113     mapping (address => mapping (address => uint256)) internal _allowed;
114 
115     uint256 internal _totalSupply;
116 
117     /**
118     * @dev Total number of tokens in existence
119     */
120     function totalSupply() public view returns (uint256) {
121         return _totalSupply;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param owner The address to query the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address owner) public view returns (uint256) {
130         return _balances[owner];
131     }
132 
133     /**
134      * @dev Function to check the amount of tokens that an owner allowed to a spender.
135      * @param owner address The address which owns the funds.
136      * @param spender address The address which will spend the funds.
137      * @return A uint256 specifying the amount of tokens still available for the spender.
138      */
139     function allowance(
140         address owner,
141         address spender
142     )
143         public
144         view
145         returns (uint256)
146     {
147         return _allowed[owner][spender];
148     }
149 
150     /**
151     * @dev Transfer token for a specified address
152     * @param to The address to transfer to.
153     * @param value The amount to be transferred.
154     */
155     function transfer(address to, uint256 value) public returns (bool) {
156         _transfer(msg.sender, to, value);
157         return true;
158     }
159 
160     /**
161      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162      * Beware that changing an allowance with this method brings the risk that someone may use both the old
163      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      * @param spender The address which will spend the funds.
167      * @param value The amount of tokens to be spent.
168      */
169     function approve(address spender, uint256 value) public returns (bool) {
170         require(spender != address(0));
171 
172         _allowed[msg.sender][spender] = value;
173         emit Approval(msg.sender, spender, value);
174         return true;
175     }
176 
177     /**
178      * @dev Transfer tokens from one address to another
179      * @param from address The address which you want to send tokens from
180      * @param to address The address which you want to transfer to
181      * @param value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(
184         address from,
185         address to,
186         uint256 value
187     )
188         public
189         returns (bool)
190     {
191         require(value <= _allowed[from][msg.sender]);
192 
193         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
194         _transfer(from, to, value);
195         return true;
196     }
197 
198     /**
199      * @dev Increase the amount of tokens that an owner allowed to a spender.
200      * approve should be called when allowed_[_spender] == 0. To increment
201      * allowed value is better to use this function to avoid 2 calls (and wait until
202      * the first transaction is mined)
203      * From MonolithDAO Token.sol
204      * @param spender The address which will spend the funds.
205      * @param addedValue The amount of tokens to increase the allowance by.
206      */
207     function increaseAllowance(
208         address spender,
209         uint256 addedValue
210     )
211         public
212         returns (bool)
213     {
214         require(spender != address(0));
215 
216         _allowed[msg.sender][spender] = (
217         _allowed[msg.sender][spender].add(addedValue));
218         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
219         return true;
220     }
221 
222     /**
223      * @dev Decrease the amount of tokens that an owner allowed to a spender.
224      * approve should be called when allowed_[_spender] == 0. To decrement
225      * allowed value is better to use this function to avoid 2 calls (and wait until
226      * the first transaction is mined)
227      * From MonolithDAO Token.sol
228      * @param spender The address which will spend the funds.
229      * @param subtractedValue The amount of tokens to decrease the allowance by.
230      */
231     function decreaseAllowance(
232         address spender,
233         uint256 subtractedValue
234     )
235         public
236         returns (bool)
237     {
238         require(spender != address(0));
239 
240         _allowed[msg.sender][spender] = (
241         _allowed[msg.sender][spender].sub(subtractedValue));
242         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
243         return true;
244     }
245 
246     /**
247     * @dev Transfer token for a specified addresses
248     * @param from The address to transfer from.
249     * @param to The address to transfer to.
250     * @param value The amount to be transferred.
251     */
252     function _transfer(address from, address to, uint256 value) internal {
253         require(value <= _balances[from]);
254         require(to != address(0));
255 
256         _balances[from] = _balances[from].sub(value);
257         _balances[to] = _balances[to].add(value);
258         emit Transfer(from, to, value);
259     }
260 
261     /**
262      * @dev Internal function that mints an amount of the token and assigns it to
263      * an account. This encapsulates the modification of balances such that the
264      * proper events are emitted.
265      * @param account The account that will receive the created tokens.
266      * @param value The amount that will be created.
267      */
268     function _mint(address account, uint256 value) internal {
269         require(account != 0);
270         _totalSupply = _totalSupply.add(value);
271         _balances[account] = _balances[account].add(value);
272         emit Transfer(address(0), account, value);
273     }
274 }
275 
276 // File: contracts/library/Ownable.sol
277 
278 pragma solidity ^0.4.24;
279 
280 /**
281  * @title Ownable
282  * @dev The Ownable contract has an owner address, and provides basic authorization control
283  * functions, this simplifies the implementation of "user permissions".
284  */
285 contract Ownable {
286     address private _owner;
287 
288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290     /**
291      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
292      * account.
293      */
294     constructor () internal {
295         _owner = msg.sender;
296         emit OwnershipTransferred(address(0), _owner);
297     }
298 
299     /**
300      * @return the address of the owner.
301      */
302     function owner() public view returns (address) {
303         return _owner;
304     }
305 
306     /**
307      * @dev Throws if called by any account other than the owner.
308      */
309     modifier onlyOwner() {
310         require(isOwner());
311         _;
312     }
313 
314     /**
315      * @return true if `msg.sender` is the owner of the contract.
316      */
317     function isOwner() public view returns (bool) {
318         return msg.sender == _owner;
319     }
320 
321     /**
322      * @dev Allows the current owner to transfer control of the contract to a newOwner.
323      * @param newOwner The address to transfer ownership to.
324      */
325     function transferOwnership(address newOwner) public onlyOwner {
326         _transferOwnership(newOwner);
327     }
328 
329     /**
330      * @dev Transfers control of the contract to a newOwner.
331      * @param newOwner The address to transfer ownership to.
332      */
333     function _transferOwnership(address newOwner) internal {
334         require(newOwner != address(0));
335         emit OwnershipTransferred(_owner, newOwner);
336         _owner = newOwner;
337     }
338 }
339 
340 // File: contracts/library/Pausable.sol
341 
342 pragma solidity ^0.4.24;
343 
344 
345 /**
346  * @title Pausable
347  * @dev Base contract which allows children to implement an emergency stop mechanism.
348  */
349 contract Pausable is Ownable {
350     event Pause();
351     event Unpause();
352 
353     bool public paused = false;
354 
355     /**
356      * @dev Modifier to make a function callable only when the contract is not paused.
357      */
358     modifier whenNotPaused() {
359         require(!paused);
360         _;
361     }
362 
363     /**
364      * @dev Modifier to make a function callable only when the contract is paused.
365      */
366     modifier whenPaused() {
367         require(paused);
368         _;
369     }
370 
371     /**
372      * @dev called by the owner to pause, triggers stopped state
373      */
374     function pause() public onlyOwner whenNotPaused {
375         paused = true;
376         emit Pause();
377     }
378 
379     /**
380      * @dev called by the owner to unpause, returns to normal state
381      */
382     function unpause() public onlyOwner whenPaused {
383         paused = false;
384         emit Unpause();
385     }
386 }
387 
388 // File: contracts/Token/ERC20Pausable.sol
389 
390 pragma solidity ^0.4.24;
391 
392 
393 
394 /**
395  * @title Pausable token
396  * @dev ERC20 modified with pausable transfers.
397  **/
398 contract ERC20Pausable is ERC20, Pausable {
399 
400     function transfer(
401         address to,
402         uint256 value
403     )
404         public
405         whenNotPaused
406         returns (bool)
407     {
408         return super.transfer(to, value);
409     }
410 
411     function transferFrom(
412         address from,
413         address to,
414         uint256 value
415     )
416         public
417         whenNotPaused
418         returns (bool)
419     {
420         return super.transferFrom(from, to, value);
421     }
422 
423     function approve(
424         address spender,
425         uint256 value
426     )
427         public
428         whenNotPaused
429         returns (bool)
430     {
431         return super.approve(spender, value);
432     }
433 
434     function increaseAllowance(
435         address spender,
436         uint addedValue
437     )
438         public
439         whenNotPaused
440         returns (bool success)
441     {
442         return super.increaseAllowance(spender, addedValue);
443     }
444 
445     function decreaseAllowance(
446         address spender,
447         uint subtractedValue
448     )
449         public
450         whenNotPaused
451         returns (bool success)
452     {
453         return super.decreaseAllowance(spender, subtractedValue);
454     }
455 }
456 
457 // File: contracts/whitelist/Roles.sol
458 
459 pragma solidity ^0.4.24;
460 
461 
462 /**
463  * @title Roles
464  * @author Francisco Giordano (@frangio)
465  * @dev Library for managing addresses assigned to a Role.
466  * See RBAC.sol for example usage.
467  */
468 library Roles {
469     struct Role {
470         mapping (address => bool) bearer;
471     }
472 
473     /**
474      * @dev give an address access to this role
475      */
476     function add(Role storage _role, address _addr) internal {
477         _role.bearer[_addr] = true;
478     }
479 
480     /**
481      * @dev remove an address' access to this role
482      */
483     function remove(Role storage _role, address _addr) internal {
484         _role.bearer[_addr] = false;
485     }
486 
487     /**
488      * @dev check if an address has this role
489      * // reverts
490      */
491     function check(Role storage _role, address _addr) internal view {
492         require(has(_role, _addr));
493     }
494 
495     /**
496      * @dev check if an address has this role
497      * @return bool
498      */
499     function has(Role storage _role, address _addr) internal view returns (bool) {
500         return _role.bearer[_addr];
501     }
502 }
503 
504 // File: contracts/whitelist/RBAC.sol
505 
506 pragma solidity ^0.4.24;
507 
508 
509 
510 /**
511  * @title RBAC (Role-Based Access Control)
512  * @author Matt Condon (@Shrugs)
513  * @dev Stores and provides setters and getters for roles and addresses.
514  * Supports unlimited numbers of roles and addresses.
515  * See //contracts/mocks/RBACMock.sol for an example of usage.
516  * This RBAC method uses strings to key roles. It may be beneficial
517  * for you to write your own implementation of this interface using Enums or similar.
518  */
519 contract RBAC {
520     using Roles for Roles.Role;
521 
522     mapping (string => Roles.Role) private roles;
523 
524     event RoleAdded(address indexed operator, string role);
525     event RoleRemoved(address indexed operator, string role);
526 
527     /**
528      * @dev reverts if addr does not have role
529      * @param _operator address
530      * @param _role the name of the role
531      * // reverts
532      */
533     function checkRole(address _operator, string _role)
534         public
535         view
536     {
537         roles[_role].check(_operator);
538     }
539 
540     /**
541      * @dev determine if addr has role
542      * @param _operator address
543      * @param _role the name of the role
544      * @return bool
545      */
546     function hasRole(address _operator, string _role)
547         public
548         view
549         returns (bool)
550     {
551         return roles[_role].has(_operator);
552     }
553 
554     /**
555      * @dev add a role to an address
556      * @param _operator address
557      * @param _role the name of the role
558      */
559     function addRole(address _operator, string _role) internal {
560         roles[_role].add(_operator);
561         emit RoleAdded(_operator, _role);
562     }
563 
564     /**
565      * @dev remove a role from an address
566      * @param _operator address
567      * @param _role the name of the role
568      */
569     function removeRole(address _operator, string _role) internal {
570         roles[_role].remove(_operator);
571         emit RoleRemoved(_operator, _role);
572     }
573 
574     /**
575      * @dev modifier to scope access to a single role (uses msg.sender as addr)
576      * @param _role the name of the role
577      * // reverts
578      */
579     modifier onlyRole(string _role) {
580         checkRole(msg.sender, _role);
581         _;
582     }
583 
584 }
585 
586 // File: contracts/whitelist/Whitelist.sol
587 
588 pragma solidity ^0.4.24;
589 
590 
591 
592 /**
593  * @title Whitelist
594  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
595  * This simplifies the implementation of "user permissions".
596  */
597 contract Whitelist is Ownable, RBAC {
598     string public constant ROLE_WHITELISTED = "whitelist";
599 
600     /**
601      * @dev Throws if operator is not whitelisted.
602      * @param _operator address
603      */
604     modifier onlyIfWhitelisted(address _operator) {
605         checkRole(_operator, ROLE_WHITELISTED);
606         _;
607     }
608 
609     /**
610      * @dev add an address to the whitelist
611      * @param _operator address
612      * @return true if the address was added to the whitelist, false if the address was already in the whitelist
613      */
614     function addAddressToWhitelist(address _operator)
615         public
616         onlyOwner
617     {
618         addRole(_operator, ROLE_WHITELISTED);
619     }
620 
621     /**
622      * @dev getter to determine if address is in whitelist
623      */
624     function whitelist(address _operator)
625         public
626         view
627         returns (bool)
628     {
629         return hasRole(_operator, ROLE_WHITELISTED);
630     }
631 
632     /**
633      * @dev add addresses to the whitelist
634      * @param _operators addresses
635      * @return true if at least one address was added to the whitelist,
636      * false if all addresses were already in the whitelist
637      */
638     function addAddressesToWhitelist(address[] _operators)
639         public
640         onlyOwner
641     {
642         for (uint256 i = 0; i < _operators.length; i++) {
643             addAddressToWhitelist(_operators[i]);
644         }
645     }
646 
647     /**
648      * @dev remove an address from the whitelist
649      * @param _operator address
650      * @return true if the address was removed from the whitelist,
651      * false if the address wasn't in the whitelist in the first place
652      */
653     function removeAddressFromWhitelist(address _operator)
654         public
655         onlyOwner
656     {
657         removeRole(_operator, ROLE_WHITELISTED);
658     }
659 
660     /**
661      * @dev remove addresses from the whitelist
662      * @param _operators addresses
663      * @return true if at least one address was removed from the whitelist,
664      * false if all addresses weren't in the whitelist in the first place
665      */
666     function removeAddressesFromWhitelist(address[] _operators)
667         public
668         onlyOwner
669     {
670         for (uint256 i = 0; i < _operators.length; i++) {
671             removeAddressFromWhitelist(_operators[i]);
672         }
673     }
674 }
675 
676 // File: contracts/Xcoin.sol
677 
678 pragma solidity ^0.4.24;
679 
680 
681 
682 contract Xcoin is ERC20Pausable {
683     string private _name;
684     string private _symbol;
685     uint8 private _decimals;
686     mapping (address => bool) private _frozenAccounts;
687 
688     Whitelist private _whitelistForBurn;
689     Pausable private _pauseForAll;
690 
691     event FrozenFunds(address indexed target, bool frozen);
692     event WhitelistForBurnChanged(address indexed oldAddress, address indexed newAddress);
693     event TransferWithMessage(address from, address to, uint256 value, bytes message);
694 
695     // Constructor
696     constructor(
697         string name,
698         string symbol,
699         uint8 decimals,
700         uint256 initialSupply,
701         address tokenHolder,
702         address owner,
703         address whitelistForBurn,
704         address pauseForAll
705     )
706     public
707     {
708         _transferOwnership(owner);
709 
710         _name = name;
711         _symbol = symbol;
712         _decimals = decimals;
713 
714         _whitelistForBurn = Whitelist(whitelistForBurn);
715         _pauseForAll = Pausable(pauseForAll);
716 
717         uint256 initialSupplyWithDecimals = initialSupply.mul(10 ** uint256(_decimals));
718         _mint(tokenHolder, initialSupplyWithDecimals);
719     }
720 
721     // Modifier to check _pauseForAll is not true
722     modifier whenNotPausedForAll() {
723         require(!_pauseForAll.paused(), "pausedForAll is paused");
724         _;
725     }
726 
727     /// @notice Return name of this token
728     /// @return token name
729     function name() public view returns (string) {
730         return _name;
731     }
732 
733     /// @notice Return symbol of this token
734     /// @return token symbol
735     function symbol() public view returns (string) {
736         return _symbol;
737     }
738 
739     /// @notice Return decimals of this token
740     /// @return token decimals
741     function decimals() public view returns (uint8) {
742         return _decimals;
743     }
744 
745     /// @notice Return flag whether account is freezed or not
746     /// @return true if account is freezed
747     function frozenAccounts(address target) public view returns (bool) {
748         return _frozenAccounts[target];
749     }
750 
751     /// @notice Return address of _whitelistForBurn contract
752     /// @return _whitelistForBurn address
753     function whitelistForBurn() public view returns (address) {
754         return _whitelistForBurn;
755     }
756 
757     /// @notice Return address of _pauseForAll contract
758     /// @return _pauseForAll address
759     function pauseForAll() public view returns (address) {
760         return _pauseForAll;
761     }
762 
763     /// @notice Change the address of _whitelistForBurn address.
764     ///         Owner can only execute this function
765     /// @param newWhitelistForBurn new _whitelistForBurn address
766     function changeWhitelistForBurn(address newWhitelistForBurn) public onlyOwner {
767         address oldWhitelist = _whitelistForBurn;
768         _whitelistForBurn = Whitelist(newWhitelistForBurn);
769         emit WhitelistForBurnChanged(oldWhitelist, newWhitelistForBurn);
770     }
771 
772     /// @notice Freezes specific addresses.
773     /// @param targets The array of target addresses.
774     function freeze(address[] targets) public onlyOwner {
775         require(targets.length > 0, "the length of targets is 0");
776 
777         for (uint i = 0; i < targets.length; i++) {
778             require(targets[i] != address(0), "targets has zero address.");
779             _frozenAccounts[targets[i]] = true;
780             emit FrozenFunds(targets[i], true);
781         }
782     }
783 
784     /// @notice Unfreezes specific addresses.
785     /// @param targets The array of target addresses.
786     function unfreeze(address[] targets) public onlyOwner {
787         require(targets.length > 0, "the length of targets is 0");
788 
789         for (uint i = 0; i < targets.length; i++) {
790             require(targets[i] != address(0), "targets has zero address.");
791             _frozenAccounts[targets[i]] = false;
792             emit FrozenFunds(targets[i], false);
793         }
794     }
795 
796     /// @notice transfer token. If msg.sender is frozen, this function will be reverted.
797     /// @param to Target address to transfer token.
798     /// @param value Amount of token msg.sender wants to transfer.
799     /// @return true if execution works correctly.
800     function transfer(address to, uint256 value) public whenNotPaused whenNotPausedForAll returns (bool) {
801         require(!frozenAccounts(msg.sender), "msg.sender address is frozen.");
802         return super.transfer(to, value);
803     }
804 
805     /// @notice transfer token with message.
806     /// @param to Target address to transfer token.
807     /// @param value Amount of token msg.sender wants to transfer.
808     /// @param message UTF-8 encoded Message sent from msg.sender to to address.
809     /// @return true if execution works correctly.
810     function transferWithMessage(
811         address to,
812         uint256 value,
813         bytes message
814     )
815     public
816     whenNotPaused
817     whenNotPausedForAll
818     returns (bool)
819     {
820         require(!_frozenAccounts[msg.sender], "msg.sender is frozen");
821         emit TransferWithMessage(msg.sender, to, value, message);
822         return super.transfer(to, value);
823     }
824 
825     /// @notice transfer token. If from address is frozen, this function will be reverted.
826     /// @param from The sender address.
827     /// @param to Target address to transfer token.
828     /// @param value Amount of token msg.sender wants to transfer.
829     /// @return true if execution works correctly.
830     function transferFrom(address from, address to, uint256 value) public whenNotPaused whenNotPausedForAll returns (bool) {
831         require(!frozenAccounts(from), "from address is frozen.");
832         return super.transferFrom(from, to, value);
833     }
834 
835     /// @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
836     ///         Beware that changing an allowance with this method brings the risk that someone may use both the old
837     ///         and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
838     ///         race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
839     /// @param spender The address which will spend the funds.
840     /// @param value The amount of tokens to be spent.
841     /// @return true if execution works correctly.
842     function approve(address spender, uint256 value) public whenNotPaused whenNotPausedForAll returns (bool) {
843         return super.approve(spender, value);
844     }
845 
846     /// @notice Increase the amount of tokens that an owner allowed to a spender.
847     ///         approve should be called when allowed_[_spender] == 0. To increment
848     ///         allowed value is better to use this function to avoid 2 calls (and wait until
849     ///         the first transaction is mined)
850     /// @param spender The address which will spend the funds.
851     /// @param addedValue The amount of tokens to increase the allowance by.
852     /// @return true if execution works correctly.
853     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused whenNotPausedForAll returns (bool) {
854         return super.increaseAllowance(spender, addedValue);
855     }
856 
857     /// @notice Decrease the amount of tokens that an owner allowed to a spender.
858     ///         approve should be called when allowed_[_spender] == 0. To decrement
859     ///         allowed value is better to use this function to avoid 2 calls (and wait until
860     ///         the first transaction is mined)
861     /// @param spender The address which will spend the funds.
862     /// @param subtractedValue The amount of tokens to decrease the allowance by.
863     /// @return true if execution works correctly.
864     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused whenNotPausedForAll returns (bool) {
865         return super.decreaseAllowance(spender, subtractedValue);
866     }
867 
868     /// @notice Function to mint tokens
869     ///         Owner can only execute this function.
870     /// @param to The address that will receive the minted tokens.
871     /// @param value The amount of tokens to mint.
872     /// @return A boolean that indicates if the operation was successful.
873     function mint(address to, uint256 value) public onlyOwner returns (bool) {
874         super._mint(to, value);
875         return true;
876     }
877 
878     /**
879     * @dev Burns a specific amount of tokens.
880     * @param _value The amount of token to be burned.
881     */
882     function burn(uint256 _value) public whenNotPaused whenNotPausedForAll {
883         require(_whitelistForBurn.whitelist(msg.sender), "msg.sender is not added on whitelist");
884         _burn(msg.sender, _value);
885     }
886 
887     function _burn(address _who, uint256 _value) internal {
888         require(_value <= _balances[_who]);
889         // no need to require value <= totalSupply, since that would imply the
890         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
891 
892         _balances[_who] = _balances[_who].sub(_value);
893         _totalSupply = _totalSupply.sub(_value);
894         emit Transfer(_who, address(0), _value);
895     }
896 }