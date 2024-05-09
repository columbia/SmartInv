1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
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
27 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
28 
29 pragma solidity ^0.5.2;
30 
31 
32 /**
33  * @title ERC20Detailed token
34  * @dev The decimals are only for visualization purposes.
35  * All the operations are done using the smallest and indivisible token unit,
36  * just as on Ethereum all the operations are done in wei.
37  */
38 contract ERC20Detailed is IERC20 {
39     string private _name;
40     string private _symbol;
41     uint8 private _decimals;
42 
43     constructor (string memory name, string memory symbol, uint8 decimals) public {
44         _name = name;
45         _symbol = symbol;
46         _decimals = decimals;
47     }
48 
49     /**
50      * @return the name of the token.
51      */
52     function name() public view returns (string memory) {
53         return _name;
54     }
55 
56     /**
57      * @return the symbol of the token.
58      */
59     function symbol() public view returns (string memory) {
60         return _symbol;
61     }
62 
63     /**
64      * @return the number of decimals of the token.
65      */
66     function decimals() public view returns (uint8) {
67         return _decimals;
68     }
69 }
70 
71 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
72 
73 pragma solidity ^0.5.2;
74 
75 /**
76  * @title SafeMath
77  * @dev Unsigned math operations with safety checks that revert on error
78  */
79 library SafeMath {
80     /**
81      * @dev Multiplies two unsigned integers, reverts on overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b);
93 
94         return c;
95     }
96 
97     /**
98      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b > 0);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Adds two unsigned integers, reverts on overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a);
125 
126         return c;
127     }
128 
129     /**
130      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
131      * reverts when dividing by zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b != 0);
135         return a % b;
136     }
137 }
138 
139 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
140 
141 pragma solidity ^0.5.2;
142 
143 
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * https://eips.ethereum.org/EIPS/eip-20
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
167      * @dev Total number of tokens in existence
168      */
169     function totalSupply() public view returns (uint256) {
170         return _totalSupply;
171     }
172 
173     /**
174      * @dev Gets the balance of the specified address.
175      * @param owner The address to query the balance of.
176      * @return A uint256 representing the amount owned by the passed address.
177      */
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
193      * @dev Transfer token to a specified address
194      * @param to The address to transfer to.
195      * @param value The amount to be transferred.
196      */
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
212         _approve(msg.sender, spender, value);
213         return true;
214     }
215 
216     /**
217      * @dev Transfer tokens from one address to another.
218      * Note that while this function emits an Approval event, this is not required as per the specification,
219      * and other compliant implementations may not emit the event.
220      * @param from address The address which you want to send tokens from
221      * @param to address The address which you want to transfer to
222      * @param value uint256 the amount of tokens to be transferred
223      */
224     function transferFrom(address from, address to, uint256 value) public returns (bool) {
225         _transfer(from, to, value);
226         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
227         return true;
228     }
229 
230     /**
231      * @dev Increase the amount of tokens that an owner allowed to a spender.
232      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
233      * allowed value is better to use this function to avoid 2 calls (and wait until
234      * the first transaction is mined)
235      * From MonolithDAO Token.sol
236      * Emits an Approval event.
237      * @param spender The address which will spend the funds.
238      * @param addedValue The amount of tokens to increase the allowance by.
239      */
240     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
241         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
242         return true;
243     }
244 
245     /**
246      * @dev Decrease the amount of tokens that an owner allowed to a spender.
247      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
248      * allowed value is better to use this function to avoid 2 calls (and wait until
249      * the first transaction is mined)
250      * From MonolithDAO Token.sol
251      * Emits an Approval event.
252      * @param spender The address which will spend the funds.
253      * @param subtractedValue The amount of tokens to decrease the allowance by.
254      */
255     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
256         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
257         return true;
258     }
259 
260     /**
261      * @dev Transfer token for a specified addresses
262      * @param from The address to transfer from.
263      * @param to The address to transfer to.
264      * @param value The amount to be transferred.
265      */
266     function _transfer(address from, address to, uint256 value) internal {
267         require(to != address(0));
268 
269         _balances[from] = _balances[from].sub(value);
270         _balances[to] = _balances[to].add(value);
271         emit Transfer(from, to, value);
272     }
273 
274     /**
275      * @dev Internal function that mints an amount of the token and assigns it to
276      * an account. This encapsulates the modification of balances such that the
277      * proper events are emitted.
278      * @param account The account that will receive the created tokens.
279      * @param value The amount that will be created.
280      */
281     function _mint(address account, uint256 value) internal {
282         require(account != address(0));
283 
284         _totalSupply = _totalSupply.add(value);
285         _balances[account] = _balances[account].add(value);
286         emit Transfer(address(0), account, value);
287     }
288 
289     /**
290      * @dev Internal function that burns an amount of the token of a given
291      * account.
292      * @param account The account whose tokens will be burnt.
293      * @param value The amount that will be burnt.
294      */
295     function _burn(address account, uint256 value) internal {
296         require(account != address(0));
297 
298         _totalSupply = _totalSupply.sub(value);
299         _balances[account] = _balances[account].sub(value);
300         emit Transfer(account, address(0), value);
301     }
302 
303     /**
304      * @dev Approve an address to spend another addresses' tokens.
305      * @param owner The address that owns the tokens.
306      * @param spender The address that will spend the tokens.
307      * @param value The number of tokens that can be spent.
308      */
309     function _approve(address owner, address spender, uint256 value) internal {
310         require(spender != address(0));
311         require(owner != address(0));
312 
313         _allowed[owner][spender] = value;
314         emit Approval(owner, spender, value);
315     }
316 
317     /**
318      * @dev Internal function that burns an amount of the token of a given
319      * account, deducting from the sender's allowance for said account. Uses the
320      * internal burn function.
321      * Emits an Approval event (reflecting the reduced allowance).
322      * @param account The account whose tokens will be burnt.
323      * @param value The amount that will be burnt.
324      */
325     function _burnFrom(address account, uint256 value) internal {
326         _burn(account, value);
327         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
328     }
329 }
330 
331 // File: openzeppelin-solidity/contracts/access/Roles.sol
332 
333 pragma solidity ^0.5.2;
334 
335 /**
336  * @title Roles
337  * @dev Library for managing addresses assigned to a Role.
338  */
339 library Roles {
340     struct Role {
341         mapping (address => bool) bearer;
342     }
343 
344     /**
345      * @dev give an account access to this role
346      */
347     function add(Role storage role, address account) internal {
348         require(account != address(0));
349         require(!has(role, account));
350 
351         role.bearer[account] = true;
352     }
353 
354     /**
355      * @dev remove an account's access to this role
356      */
357     function remove(Role storage role, address account) internal {
358         require(account != address(0));
359         require(has(role, account));
360 
361         role.bearer[account] = false;
362     }
363 
364     /**
365      * @dev check if an account has this role
366      * @return bool
367      */
368     function has(Role storage role, address account) internal view returns (bool) {
369         require(account != address(0));
370         return role.bearer[account];
371     }
372 }
373 
374 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
375 
376 pragma solidity ^0.5.2;
377 
378 
379 contract MinterRole {
380     using Roles for Roles.Role;
381 
382     event MinterAdded(address indexed account);
383     event MinterRemoved(address indexed account);
384 
385     Roles.Role private _minters;
386 
387     constructor () internal {
388         _addMinter(msg.sender);
389     }
390 
391     modifier onlyMinter() {
392         require(isMinter(msg.sender));
393         _;
394     }
395 
396     function isMinter(address account) public view returns (bool) {
397         return _minters.has(account);
398     }
399 
400     function addMinter(address account) public onlyMinter {
401         _addMinter(account);
402     }
403 
404     function renounceMinter() public {
405         _removeMinter(msg.sender);
406     }
407 
408     function _addMinter(address account) internal {
409         _minters.add(account);
410         emit MinterAdded(account);
411     }
412 
413     function _removeMinter(address account) internal {
414         _minters.remove(account);
415         emit MinterRemoved(account);
416     }
417 }
418 
419 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
420 
421 pragma solidity ^0.5.2;
422 
423 
424 
425 /**
426  * @title ERC20Mintable
427  * @dev ERC20 minting logic
428  */
429 contract ERC20Mintable is ERC20, MinterRole {
430     /**
431      * @dev Function to mint tokens
432      * @param to The address that will receive the minted tokens.
433      * @param value The amount of tokens to mint.
434      * @return A boolean that indicates if the operation was successful.
435      */
436     function mint(address to, uint256 value) public onlyMinter returns (bool) {
437         _mint(to, value);
438         return true;
439     }
440 }
441 
442 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
443 
444 pragma solidity ^0.5.2;
445 
446 /**
447  * @title Ownable
448  * @dev The Ownable contract has an owner address, and provides basic authorization control
449  * functions, this simplifies the implementation of "user permissions".
450  */
451 contract Ownable {
452     address private _owner;
453 
454     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
455 
456     /**
457      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
458      * account.
459      */
460     constructor () internal {
461         _owner = msg.sender;
462         emit OwnershipTransferred(address(0), _owner);
463     }
464 
465     /**
466      * @return the address of the owner.
467      */
468     function owner() public view returns (address) {
469         return _owner;
470     }
471 
472     /**
473      * @dev Throws if called by any account other than the owner.
474      */
475     modifier onlyOwner() {
476         require(isOwner());
477         _;
478     }
479 
480     /**
481      * @return true if `msg.sender` is the owner of the contract.
482      */
483     function isOwner() public view returns (bool) {
484         return msg.sender == _owner;
485     }
486 
487     /**
488      * @dev Allows the current owner to relinquish control of the contract.
489      * It will not be possible to call the functions with the `onlyOwner`
490      * modifier anymore.
491      * @notice Renouncing ownership will leave the contract without an owner,
492      * thereby removing any functionality that is only available to the owner.
493      */
494     function renounceOwnership() public onlyOwner {
495         emit OwnershipTransferred(_owner, address(0));
496         _owner = address(0);
497     }
498 
499     /**
500      * @dev Allows the current owner to transfer control of the contract to a newOwner.
501      * @param newOwner The address to transfer ownership to.
502      */
503     function transferOwnership(address newOwner) public onlyOwner {
504         _transferOwnership(newOwner);
505     }
506 
507     /**
508      * @dev Transfers control of the contract to a newOwner.
509      * @param newOwner The address to transfer ownership to.
510      */
511     function _transferOwnership(address newOwner) internal {
512         require(newOwner != address(0));
513         emit OwnershipTransferred(_owner, newOwner);
514         _owner = newOwner;
515     }
516 }
517 
518 // File: contracts/ComplianceService.sol
519 
520 pragma solidity ^0.5.2;
521 
522 /// @notice Standard interface for `ComplianceService`s
523 contract ComplianceService {
524 
525     /*
526     * @notice This method *MUST* be called by `BlueshareToken`s during `transfer()` and `transferFrom()`.
527     *         The implementation *SHOULD* check whether or not a transfer can be approved.
528     *
529     * @dev    This method *MAY* call back to the token contract specified by `_token` for
530     *         more information needed to enforce trade approval.
531     *
532     * @param  _token The address of the token to be transfered
533     * @param  _spender The address of the spender of the token
534     * @param  _from The address of the sender account
535     * @param  _to The address of the receiver account
536     * @param  _amount The quantity of the token to trade
537     *
538     * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation
539     *               to assign meaning.
540     */
541     function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);
542 
543     /*
544     * @notice This method *MUST* be called by `BlueshareToken`s during `forceTransferFrom()`. 
545     *         Accessible only by admins, used for forced tokens transfer
546     *         The implementation *SHOULD* check whether or not a transfer can be approved.
547     *
548     * @dev    This method *MAY* call back to the token contract specified by `_token` for
549     *         more information needed to enforce trade approval.
550     *
551     * @param  _token The address of the token to be transfered
552     * @param  _spender The address of the spender of the token *Admin or Owner*
553     * @param  _from The address of the sender account
554     * @param  _to The address of the receiver account
555     * @param  _amount The quantity of the token to trade
556     *
557     * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation
558     *               to assign meaning.
559     */
560     function forceCheck(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);
561 
562     /**
563     * @notice This method *MUST* be called by `BlueshareToken`s during  during `transfer()` and `transferFrom()`.
564     *         The implementation *SHOULD* check whether or not a transfer can be approved.
565     *
566     * @dev    This method  *MAY* call back to the token contract specified by `_token` for
567     *         information needed to enforce trade approval if needed
568     *
569     * @param  _token The address of the token to be transfered
570     * @param  _spender The address of the spender of the token (unused in this implementation)
571     * @param  _holder The address of the sender account, our holder
572     * @param  _balance The balance of our holder
573     * @param  _amount The amount he or she whants to send
574     *
575     * @return `true` if the trade should be approved and `false` if the trade should not be approved
576     */
577     function checkVested(address _token, address _spender, address _holder, uint256 _balance, uint256 _amount) public returns (bool);
578 }
579 
580 // File: contracts/DividendService.sol
581 
582 pragma solidity ^0.5.2;
583 
584 /// @notice Standard interface for `DividendService`s
585 contract DividendService {
586 
587     /**
588     * @param _token The address of the token assigned with this `DividendService`
589     * @param _spender The address of the spender for this transaction
590     * @param _holder The address of the holder of the token
591     * @param _interval The time interval / year for which the dividends are paid or not
592     * @return uint8 The reason code: 0 means not paid.  Non-zero values are left to the implementation
593     *               to assign meaning.
594     */
595     function check(address _token, address _spender, address _holder, uint _interval) public returns (uint8);
596 }
597 
598 // File: contracts/ServiceRegistry.sol
599 
600 pragma solidity ^0.5.2;
601 
602 
603 
604 
605 /// @notice regulator - A service that points to a `ComplianceService` contract
606 /// @notice dividend - A service that points to a `DividendService` contract
607 contract ServiceRegistry is Ownable {
608     address public regulator;
609     address public dividend;
610 
611     /**
612     * @notice Triggered when regulator or dividend service address is replaced
613     */
614     event ReplaceService(address oldService, address newService);
615 
616     /**
617     * @dev Validate contract address
618     * Credit: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol#L107-L114
619     *
620     * @param _addr The address of a smart contract
621     */
622     modifier withContract(address _addr) {
623         uint length;
624         assembly { length := extcodesize(_addr) }
625         require(length > 0);
626         _;
627     }
628 
629     /**
630     * @notice Constructor
631     *
632     * @param _regulator The address of the `ComplianceService` contract
633     * @param _dividend The address of the `DividendService` contract
634     *
635     */
636     constructor(address _regulator, address _dividend) public {
637         regulator = _regulator;
638         dividend = _dividend;
639     }
640 
641     /**
642     * @notice Replaces the address pointer to the `ComplianceService` contract
643     *
644     * @dev This method is only callable by the contract's owner
645     *
646     * @param _regulator The address of the new `ComplianceService` contract
647     */
648     function replaceRegulator(address _regulator) public onlyOwner withContract(_regulator) {
649         require(regulator != _regulator, "The address cannot be the same");
650 
651         address oldRegulator = regulator;
652         regulator = _regulator;
653         emit ReplaceService(oldRegulator, regulator);
654     }
655 
656     /**
657     * @notice Replaces the address pointer to the `DividendService` contract
658     *
659     * @dev This method is only callable by the contract's owner
660     *
661     * @param _dividend The address of the new `DividendService` contract
662     */
663     function replaceDividend(address _dividend) public onlyOwner withContract(_dividend) {
664         require(dividend != _dividend, "The address cannot be the same");
665 
666         address oldDividend = dividend;
667         dividend = _dividend;
668         emit ReplaceService(oldDividend, dividend);
669     }
670 }
671 
672 // File: contracts/BlueshareToken.sol
673 
674 pragma solidity ^0.5.2;
675 
676 
677 
678 
679 
680 
681 
682 /// @notice An ERC-20 token that has the ability to check for trade validity
683 contract BlueshareToken is ERC20Detailed, ERC20Mintable, Ownable {
684 
685     /**
686     * @notice Token decimals setting (used when constructing ERC20Detailed)
687     */
688     uint8 constant public BLUESHARETOKEN_DECIMALS = 0;
689 
690     /**
691     * International Securities Identification Number (ISIN)
692     */
693     string constant public ISIN = "CH0465030796";
694 
695     /**
696     * @notice Triggered when regulator checks pass or fail
697     */
698     event CheckComplianceStatus(uint8 reason, address indexed spender, address indexed from, address indexed to, uint256 value);
699 
700     /**
701     * @notice Triggered when regulator checks pass or fail
702     */
703     event CheckVestingStatus(bool reason, address indexed spender, address indexed from, uint256 balance, uint256 value);
704 
705     /**
706     * @notice Triggered when dividend checks pass or fail
707     */
708     event CheckDividendStatus(uint8 reason, address indexed spender, address indexed holder, uint interval);
709 
710     /**
711     * @notice Address of the `ServiceRegistry` that has the location of the
712     *         `ComplianceService` contract responsible for checking trade permissions and 
713     *         `DividendService` contract responsible for checking dividend state.
714     */
715     ServiceRegistry public registry;
716 
717     /**
718     * @notice Constructor
719     *
720     * @param _registry Address of `ServiceRegistry` contract
721     * @param _name Name of the token: See ERC20Detailed
722     * @param _symbol Symbol of the token: See ERC20Detailed
723     */
724     constructor(ServiceRegistry _registry, string memory _name, string memory _symbol) public
725       ERC20Detailed(_name, _symbol, BLUESHARETOKEN_DECIMALS)
726     {
727         require(address(_registry) != address(0), "Uninitialized or undefined address");
728 
729         registry = _registry;
730     }
731 
732     /**
733     * @notice ERC-20 overridden function that include logic to check for trade validity.
734     *
735     * @param _to The address of the receiver
736     * @param _value The number of tokens to transfer
737     *
738     * @return `true` if successful and `false` if unsuccessful
739     */
740     function transfer(address _to, uint256 _value) public returns (bool) {
741         require(_checkVested(msg.sender, balanceOf(msg.sender), _value), "Cannot send vested amount!");
742         require(_check(msg.sender, _to, _value), "Cannot transfer!");
743 
744         return super.transfer(_to, _value);
745     }
746 
747     /**
748     * @notice ERC-20 overridden function that include logic to check for trade validity.
749     *
750     * @param _from The address of the sender
751     * @param _to The address of the receiver
752     * @param _value The number of tokens to transfer
753     *
754     * @return `true` if successful and `false` if unsuccessful
755     */
756     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
757         require(_checkVested(_from, balanceOf(_from), _value), "Cannot send vested amount!");
758         require(_check(_from, _to, _value), "Cannot transfer!");
759         
760         return super.transferFrom(_from, _to, _value);
761     }
762 
763     /**
764     * @notice ERC-20 extended function that include logic to check for trade validity with admin rights.
765     *
766     * @param _from The address of the old wallet
767     * @param _to The address of the new wallet
768     * @param _value The number of tokens to transfer
769     *
770     */
771     function forceTransferFrom(address _from, address _to, uint256 _value) public returns (bool) {
772         require(_forceCheck(_from, _to, _value), "Not allowed!");
773 
774         _transfer(_from, _to, _value);
775         return true;
776     }
777 
778     /**
779     * @notice The public function for checking divident payout status
780     *
781     * @param _holder The address of the token's holder
782     * @param _interval The interval for divident's status
783     */
784     function dividendStatus(address _holder, uint _interval) public returns (uint8) {
785         return _checkDividend(_holder, _interval);
786     }
787 
788     /**
789     * @notice Performs the regulator check
790     *
791     * @dev This method raises a CheckComplianceStatus event indicating success or failure of the check
792     *
793     * @param _from The address of the sender
794     * @param _to The address of the receiver
795     * @param _value The number of tokens to transfer
796     *
797     * @return `true` if the check was successful and `false` if unsuccessful
798     */
799     function _check(address _from, address _to, uint256 _value) private returns (bool) {
800         uint8 reason = _regulator().check(address(this), msg.sender, _from, _to, _value);
801 
802         emit CheckComplianceStatus(reason, msg.sender, _from, _to, _value);
803 
804         return reason == 0;
805     }
806 
807     /**
808     * @notice Performs the regulator forceCheck, accessable only by admins
809     *
810     * @dev This method raises a CheckComplianceStatus event indicating success or failure of the check
811     *
812     * @param _from The address of the sender
813     * @param _to The address of the receiver
814     * @param _value The number of tokens to transfer
815     *
816     * @return `true` if the check was successful and `false` if unsuccessful
817     */
818     function _forceCheck(address _from, address _to, uint256 _value) private returns (bool) {
819         uint8 allowance = _regulator().forceCheck(address(this), msg.sender, _from, _to, _value);
820 
821         emit CheckComplianceStatus(allowance, msg.sender, _from, _to, _value);
822 
823         return allowance == 0;
824     }
825 
826     /**
827     * @notice Performs the regulator check
828     *
829     * @dev This method raises a CheckVestingStatus event indicating success or failure of the check
830     *
831     * @param _participant The address of the participant
832     * @param _balance The balance of the sender
833     * @param _value The number of tokens to transfer
834     *
835     * @return `true` if the check was successful and `false` if unsuccessful
836     */
837     function _checkVested(address _participant, uint256 _balance, uint256 _value) private returns (bool) {
838         bool allowed = _regulator().checkVested(address(this), msg.sender, _participant, _balance, _value);
839 
840         emit CheckVestingStatus(allowed, msg.sender, _participant, _balance, _value);
841 
842         return allowed;
843     }
844 
845     /**
846     * @notice Performs the dividend check
847     *
848     * @dev This method raises a CheckDividendStatus event indicating success or failure of the check
849     *
850     * @param _address The address of the holder
851     * @param _interval The time interval / year for which the dividends are paid or not
852     *
853     * @return `true` if the check was successful and `false` if unsuccessful
854     */
855     function _checkDividend(address _address, uint _interval) private returns (uint8) {
856         uint8 status = _dividend().check(address(this), msg.sender, _address, _interval);
857 
858         emit CheckDividendStatus(status, msg.sender, _address, _interval);
859 
860         return status;
861     }
862 
863     /**
864     * @notice Retreives the address of the `ComplianceService` that manages this token.
865     *
866     * @dev This function *MUST NOT* memoize the `ComplianceService` address.  This would
867     *      break the ability to upgrade the `ComplianceService`.
868     *
869     * @return The `ComplianceService` that manages this token.
870     */
871     function _regulator() public view returns (ComplianceService) {
872         return ComplianceService(registry.regulator());
873     }
874 
875     /**
876     * @notice Retreives the address of the `DividendService` that manages this token.
877     *
878     * @dev This function *MUST NOT* memoize the `DividendService` address.  This would
879     *      break the ability to upgrade the `DividendService`.
880     *
881     * @return The `DividendService` that manages this token.
882     */
883     function _dividend() public view returns (DividendService) {
884         return DividendService(registry.dividend());
885     }
886 }