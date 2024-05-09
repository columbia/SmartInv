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
71 // File: openzeppelin-solidity/contracts/access/Roles.sol
72 
73 pragma solidity ^0.5.2;
74 
75 /**
76  * @title Roles
77  * @dev Library for managing addresses assigned to a Role.
78  */
79 library Roles {
80     struct Role {
81         mapping (address => bool) bearer;
82     }
83 
84     /**
85      * @dev give an account access to this role
86      */
87     function add(Role storage role, address account) internal {
88         require(account != address(0));
89         require(!has(role, account));
90 
91         role.bearer[account] = true;
92     }
93 
94     /**
95      * @dev remove an account's access to this role
96      */
97     function remove(Role storage role, address account) internal {
98         require(account != address(0));
99         require(has(role, account));
100 
101         role.bearer[account] = false;
102     }
103 
104     /**
105      * @dev check if an account has this role
106      * @return bool
107      */
108     function has(Role storage role, address account) internal view returns (bool) {
109         require(account != address(0));
110         return role.bearer[account];
111     }
112 }
113 
114 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
115 
116 pragma solidity ^0.5.2;
117 
118 
119 contract PauserRole {
120     using Roles for Roles.Role;
121 
122     event PauserAdded(address indexed account);
123     event PauserRemoved(address indexed account);
124 
125     Roles.Role private _pausers;
126 
127     constructor () internal {
128         _addPauser(msg.sender);
129     }
130 
131     modifier onlyPauser() {
132         require(isPauser(msg.sender));
133         _;
134     }
135 
136     function isPauser(address account) public view returns (bool) {
137         return _pausers.has(account);
138     }
139 
140     function addPauser(address account) public onlyPauser {
141         _addPauser(account);
142     }
143 
144     function renouncePauser() public {
145         _removePauser(msg.sender);
146     }
147 
148     function _addPauser(address account) internal {
149         _pausers.add(account);
150         emit PauserAdded(account);
151     }
152 
153     function _removePauser(address account) internal {
154         _pausers.remove(account);
155         emit PauserRemoved(account);
156     }
157 }
158 
159 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
160 
161 pragma solidity ^0.5.2;
162 
163 
164 /**
165  * @title Pausable
166  * @dev Base contract which allows children to implement an emergency stop mechanism.
167  */
168 contract Pausable is PauserRole {
169     event Paused(address account);
170     event Unpaused(address account);
171 
172     bool private _paused;
173 
174     constructor () internal {
175         _paused = false;
176     }
177 
178     /**
179      * @return true if the contract is paused, false otherwise.
180      */
181     function paused() public view returns (bool) {
182         return _paused;
183     }
184 
185     /**
186      * @dev Modifier to make a function callable only when the contract is not paused.
187      */
188     modifier whenNotPaused() {
189         require(!_paused);
190         _;
191     }
192 
193     /**
194      * @dev Modifier to make a function callable only when the contract is paused.
195      */
196     modifier whenPaused() {
197         require(_paused);
198         _;
199     }
200 
201     /**
202      * @dev called by the owner to pause, triggers stopped state
203      */
204     function pause() public onlyPauser whenNotPaused {
205         _paused = true;
206         emit Paused(msg.sender);
207     }
208 
209     /**
210      * @dev called by the owner to unpause, returns to normal state
211      */
212     function unpause() public onlyPauser whenPaused {
213         _paused = false;
214         emit Unpaused(msg.sender);
215     }
216 }
217 
218 // File: contracts/interfaces/IModerator.sol
219 
220 pragma solidity 0.5.4;
221 
222 
223 interface IModerator {
224     function verifyIssue(address _tokenHolder, uint256 _value, bytes calldata _data) external view
225         returns (bool allowed, byte statusCode, bytes32 applicationCode);
226 
227     function verifyTransfer(address _from, address _to, uint256 _amount, bytes calldata _data) external view 
228         returns (bool allowed, byte statusCode, bytes32 applicationCode);
229 
230     function verifyTransferFrom(address _from, address _to, address _forwarder, uint256 _amount, bytes calldata _data) external view 
231         returns (bool allowed, byte statusCode, bytes32 applicationCode);
232 
233     function verifyRedeem(address _sender, uint256 _amount, bytes calldata _data) external view 
234         returns (bool allowed, byte statusCode, bytes32 applicationCode);
235 
236     function verifyRedeemFrom(address _sender, address _tokenHolder, uint256 _amount, bytes calldata _data) external view
237         returns (bool allowed, byte statusCode, bytes32 applicationCode);        
238 
239     function verifyControllerTransfer(address _controller, address _from, address _to, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external view
240         returns (bool allowed, byte statusCode, bytes32 applicationCode);
241 
242     function verifyControllerRedeem(address _controller, address _tokenHolder, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external view
243         returns (bool allowed, byte statusCode, bytes32 applicationCode);
244 }
245 
246 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
247 
248 pragma solidity ^0.5.2;
249 
250 /**
251  * @title SafeMath
252  * @dev Unsigned math operations with safety checks that revert on error
253  */
254 library SafeMath {
255     /**
256      * @dev Multiplies two unsigned integers, reverts on overflow.
257      */
258     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
259         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
260         // benefit is lost if 'b' is also tested.
261         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
262         if (a == 0) {
263             return 0;
264         }
265 
266         uint256 c = a * b;
267         require(c / a == b);
268 
269         return c;
270     }
271 
272     /**
273      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
274      */
275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
276         // Solidity only automatically asserts when dividing by 0
277         require(b > 0);
278         uint256 c = a / b;
279         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
280 
281         return c;
282     }
283 
284     /**
285      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
286      */
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         require(b <= a);
289         uint256 c = a - b;
290 
291         return c;
292     }
293 
294     /**
295      * @dev Adds two unsigned integers, reverts on overflow.
296      */
297     function add(uint256 a, uint256 b) internal pure returns (uint256) {
298         uint256 c = a + b;
299         require(c >= a);
300 
301         return c;
302     }
303 
304     /**
305      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
306      * reverts when dividing by zero.
307      */
308     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
309         require(b != 0);
310         return a % b;
311     }
312 }
313 
314 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
315 
316 pragma solidity ^0.5.2;
317 
318 /**
319  * @title Ownable
320  * @dev The Ownable contract has an owner address, and provides basic authorization control
321  * functions, this simplifies the implementation of "user permissions".
322  */
323 contract Ownable {
324     address private _owner;
325 
326     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
327 
328     /**
329      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
330      * account.
331      */
332     constructor () internal {
333         _owner = msg.sender;
334         emit OwnershipTransferred(address(0), _owner);
335     }
336 
337     /**
338      * @return the address of the owner.
339      */
340     function owner() public view returns (address) {
341         return _owner;
342     }
343 
344     /**
345      * @dev Throws if called by any account other than the owner.
346      */
347     modifier onlyOwner() {
348         require(isOwner());
349         _;
350     }
351 
352     /**
353      * @return true if `msg.sender` is the owner of the contract.
354      */
355     function isOwner() public view returns (bool) {
356         return msg.sender == _owner;
357     }
358 
359     /**
360      * @dev Allows the current owner to relinquish control of the contract.
361      * It will not be possible to call the functions with the `onlyOwner`
362      * modifier anymore.
363      * @notice Renouncing ownership will leave the contract without an owner,
364      * thereby removing any functionality that is only available to the owner.
365      */
366     function renounceOwnership() public onlyOwner {
367         emit OwnershipTransferred(_owner, address(0));
368         _owner = address(0);
369     }
370 
371     /**
372      * @dev Allows the current owner to transfer control of the contract to a newOwner.
373      * @param newOwner The address to transfer ownership to.
374      */
375     function transferOwnership(address newOwner) public onlyOwner {
376         _transferOwnership(newOwner);
377     }
378 
379     /**
380      * @dev Transfers control of the contract to a newOwner.
381      * @param newOwner The address to transfer ownership to.
382      */
383     function _transferOwnership(address newOwner) internal {
384         require(newOwner != address(0));
385         emit OwnershipTransferred(_owner, newOwner);
386         _owner = newOwner;
387     }
388 }
389 
390 // File: openzeppelin-solidity/contracts/utils/Address.sol
391 
392 pragma solidity ^0.5.2;
393 
394 /**
395  * Utility library of inline functions on addresses
396  */
397 library Address {
398     /**
399      * Returns whether the target address is a contract
400      * @dev This function will return false if invoked during the constructor of a contract,
401      * as the code is not actually created until after the constructor finishes.
402      * @param account address of the account to check
403      * @return whether the target address is a contract
404      */
405     function isContract(address account) internal view returns (bool) {
406         uint256 size;
407         // XXX Currently there is no better way to check if there is a contract in an address
408         // than to check the size of the code at that address.
409         // See https://ethereum.stackexchange.com/a/14016/36603
410         // for more details about how this works.
411         // TODO Check this again before the Serenity release, because all addresses will be
412         // contracts then.
413         // solhint-disable-next-line no-inline-assembly
414         assembly { size := extcodesize(account) }
415         return size > 0;
416     }
417 }
418 
419 // File: contracts/interfaces/IRewardsUpdatable.sol
420 
421 pragma solidity 0.5.4;
422 
423 
424 interface IRewardsUpdatable {
425     event NotifierUpdated(address implementation);
426 
427     function updateOnTransfer(address from, address to, uint amount) external returns (bool);
428     function updateOnBurn(address account, uint amount) external returns (bool);
429     function setRewardsNotifier(address notifier) external;
430 }
431 
432 // File: contracts/interfaces/IRewardable.sol
433 
434 pragma solidity 0.5.4;
435 
436 
437 
438 interface IRewardable {
439     event RewardsUpdated(address implementation);
440 
441     function setRewards(IRewardsUpdatable rewards) external;
442 }
443 
444 // File: contracts/rewards/Rewardable.sol
445 
446 pragma solidity 0.5.4;
447 
448 
449 
450 
451 
452 
453 
454 /**
455  * @notice A contract with an associated Rewards contract to calculate rewards during token movements.
456  */
457 contract Rewardable is IRewardable, Ownable {
458     using SafeMath for uint;
459 
460     IRewardsUpdatable public rewards; // The rewards contract
461 
462     event RewardsUpdated(address implementation);
463 
464     /**
465     * @notice Calculates and updates _dampings[address] based on the token movement.
466     * @notice This modifier is applied to mint(), transfer(), and transferFrom().
467     * @param _from Address of sender
468     * @param _to Address of recipient
469     * @param _value Amount of tokens
470     */
471     modifier updatesRewardsOnTransfer(address _from, address _to, uint _value) {
472         _;
473         require(rewards.updateOnTransfer(_from, _to, _value), "Rewards updateOnTransfer failed."); // [External contract call]
474     }
475 
476     /**
477     * @notice Calculates and updates _dampings[address] based on the token burning.
478     * @notice This modifier is applied to burn()
479     * @param _account Address of owner
480     * @param _value Amount of tokens
481     */
482     modifier updatesRewardsOnBurn(address _account, uint _value) {
483         _;
484         require(rewards.updateOnBurn(_account, _value), "Rewards updateOnBurn failed."); // [External contract call]
485     }
486 
487     /**
488     * @notice Links a Rewards contract to this contract.
489     * @param _rewards Rewards contract address.
490     */
491     function setRewards(IRewardsUpdatable _rewards) external onlyOwner {
492         require(address(_rewards) != address(0), "Rewards address must not be a zero address.");
493         require(Address.isContract(address(_rewards)), "Address must point to a contract.");
494         rewards = _rewards;
495         emit RewardsUpdated(address(_rewards));
496     }
497 }
498 
499 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
500 
501 pragma solidity ^0.5.2;
502 
503 
504 
505 /**
506  * @title Standard ERC20 token
507  *
508  * @dev Implementation of the basic standard token.
509  * https://eips.ethereum.org/EIPS/eip-20
510  * Originally based on code by FirstBlood:
511  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
512  *
513  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
514  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
515  * compliant implementations may not do it.
516  */
517 contract ERC20 is IERC20 {
518     using SafeMath for uint256;
519 
520     mapping (address => uint256) private _balances;
521 
522     mapping (address => mapping (address => uint256)) private _allowed;
523 
524     uint256 private _totalSupply;
525 
526     /**
527      * @dev Total number of tokens in existence
528      */
529     function totalSupply() public view returns (uint256) {
530         return _totalSupply;
531     }
532 
533     /**
534      * @dev Gets the balance of the specified address.
535      * @param owner The address to query the balance of.
536      * @return A uint256 representing the amount owned by the passed address.
537      */
538     function balanceOf(address owner) public view returns (uint256) {
539         return _balances[owner];
540     }
541 
542     /**
543      * @dev Function to check the amount of tokens that an owner allowed to a spender.
544      * @param owner address The address which owns the funds.
545      * @param spender address The address which will spend the funds.
546      * @return A uint256 specifying the amount of tokens still available for the spender.
547      */
548     function allowance(address owner, address spender) public view returns (uint256) {
549         return _allowed[owner][spender];
550     }
551 
552     /**
553      * @dev Transfer token to a specified address
554      * @param to The address to transfer to.
555      * @param value The amount to be transferred.
556      */
557     function transfer(address to, uint256 value) public returns (bool) {
558         _transfer(msg.sender, to, value);
559         return true;
560     }
561 
562     /**
563      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
564      * Beware that changing an allowance with this method brings the risk that someone may use both the old
565      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
566      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
567      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
568      * @param spender The address which will spend the funds.
569      * @param value The amount of tokens to be spent.
570      */
571     function approve(address spender, uint256 value) public returns (bool) {
572         _approve(msg.sender, spender, value);
573         return true;
574     }
575 
576     /**
577      * @dev Transfer tokens from one address to another.
578      * Note that while this function emits an Approval event, this is not required as per the specification,
579      * and other compliant implementations may not emit the event.
580      * @param from address The address which you want to send tokens from
581      * @param to address The address which you want to transfer to
582      * @param value uint256 the amount of tokens to be transferred
583      */
584     function transferFrom(address from, address to, uint256 value) public returns (bool) {
585         _transfer(from, to, value);
586         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
587         return true;
588     }
589 
590     /**
591      * @dev Increase the amount of tokens that an owner allowed to a spender.
592      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
593      * allowed value is better to use this function to avoid 2 calls (and wait until
594      * the first transaction is mined)
595      * From MonolithDAO Token.sol
596      * Emits an Approval event.
597      * @param spender The address which will spend the funds.
598      * @param addedValue The amount of tokens to increase the allowance by.
599      */
600     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
601         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
602         return true;
603     }
604 
605     /**
606      * @dev Decrease the amount of tokens that an owner allowed to a spender.
607      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
608      * allowed value is better to use this function to avoid 2 calls (and wait until
609      * the first transaction is mined)
610      * From MonolithDAO Token.sol
611      * Emits an Approval event.
612      * @param spender The address which will spend the funds.
613      * @param subtractedValue The amount of tokens to decrease the allowance by.
614      */
615     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
616         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
617         return true;
618     }
619 
620     /**
621      * @dev Transfer token for a specified addresses
622      * @param from The address to transfer from.
623      * @param to The address to transfer to.
624      * @param value The amount to be transferred.
625      */
626     function _transfer(address from, address to, uint256 value) internal {
627         require(to != address(0));
628 
629         _balances[from] = _balances[from].sub(value);
630         _balances[to] = _balances[to].add(value);
631         emit Transfer(from, to, value);
632     }
633 
634     /**
635      * @dev Internal function that mints an amount of the token and assigns it to
636      * an account. This encapsulates the modification of balances such that the
637      * proper events are emitted.
638      * @param account The account that will receive the created tokens.
639      * @param value The amount that will be created.
640      */
641     function _mint(address account, uint256 value) internal {
642         require(account != address(0));
643 
644         _totalSupply = _totalSupply.add(value);
645         _balances[account] = _balances[account].add(value);
646         emit Transfer(address(0), account, value);
647     }
648 
649     /**
650      * @dev Internal function that burns an amount of the token of a given
651      * account.
652      * @param account The account whose tokens will be burnt.
653      * @param value The amount that will be burnt.
654      */
655     function _burn(address account, uint256 value) internal {
656         require(account != address(0));
657 
658         _totalSupply = _totalSupply.sub(value);
659         _balances[account] = _balances[account].sub(value);
660         emit Transfer(account, address(0), value);
661     }
662 
663     /**
664      * @dev Approve an address to spend another addresses' tokens.
665      * @param owner The address that owns the tokens.
666      * @param spender The address that will spend the tokens.
667      * @param value The number of tokens that can be spent.
668      */
669     function _approve(address owner, address spender, uint256 value) internal {
670         require(spender != address(0));
671         require(owner != address(0));
672 
673         _allowed[owner][spender] = value;
674         emit Approval(owner, spender, value);
675     }
676 
677     /**
678      * @dev Internal function that burns an amount of the token of a given
679      * account, deducting from the sender's allowance for said account. Uses the
680      * internal burn function.
681      * Emits an Approval event (reflecting the reduced allowance).
682      * @param account The account whose tokens will be burnt.
683      * @param value The amount that will be burnt.
684      */
685     function _burnFrom(address account, uint256 value) internal {
686         _burn(account, value);
687         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
688     }
689 }
690 
691 // File: contracts/token/ERC20Redeemable.sol
692 
693 pragma solidity 0.5.4;
694 
695 
696 
697 
698 contract ERC20Redeemable is ERC20 {
699     using SafeMath for uint256;
700 
701     uint256 public totalRedeemed;
702 
703     /**
704      * @dev Internal function that burns an amount of the token of a given
705      * account. Overriden to track totalRedeemed.
706      * @param account The account whose tokens will be burnt.
707      * @param value The amount that will be burnt.
708      */
709     function _burn(address account, uint256 value) internal {
710         totalRedeemed = totalRedeemed.add(value); // Keep track of total for Rewards calculation
711         super._burn(account, value);
712     }
713 }
714 
715 // File: contracts/interfaces/IERC1594.sol
716 
717 pragma solidity 0.5.4;
718 
719 
720 /// @title IERC1594 Security Token Standard
721 /// @dev See https://github.com/SecurityTokenStandard/EIP-Spec
722 interface IERC1594 {
723     // Issuance / Redemption Events
724     event Issued(address indexed _operator, address indexed _to, uint256 _value, bytes _data);
725     event Redeemed(address indexed _operator, address indexed _from, uint256 _value, bytes _data);
726 
727     // Transfers
728     function transferWithData(address _to, uint256 _value, bytes calldata _data) external;
729     function transferFromWithData(address _from, address _to, uint256 _value, bytes calldata _data) external;
730 
731     // Token Redemption
732     function redeem(uint256 _value, bytes calldata _data) external;
733     function redeemFrom(address _tokenHolder, uint256 _value, bytes calldata _data) external;
734 
735     // Token Issuance
736     function issue(address _tokenHolder, uint256 _value, bytes calldata _data) external;
737     function isIssuable() external view returns (bool);
738 
739     // Transfer Validity
740     function canTransfer(address _to, uint256 _value, bytes calldata _data) external view returns (bool, byte, bytes32);
741     function canTransferFrom(address _from, address _to, uint256 _value, bytes calldata _data) external view returns (bool, byte, bytes32);
742 }
743 
744 // File: contracts/interfaces/IHasIssuership.sol
745 
746 pragma solidity 0.5.4;
747 
748 
749 interface IHasIssuership {
750     event IssuershipTransferred(address indexed from, address indexed to);
751 
752     function transferIssuership(address newIssuer) external;
753 }
754 
755 // File: contracts/roles/IssuerRole.sol
756 
757 pragma solidity 0.5.4;
758 
759 
760 
761 // @notice Issuers are capable of issuing new TENX tokens from the TENXToken contract.
762 contract IssuerRole {
763     using Roles for Roles.Role;
764 
765     event IssuerAdded(address indexed account);
766     event IssuerRemoved(address indexed account);
767 
768     Roles.Role internal _issuers;
769 
770     modifier onlyIssuer() {
771         require(isIssuer(msg.sender), "Only Issuers can execute this function.");
772         _;
773     }
774 
775     constructor() internal {
776         _addIssuer(msg.sender);
777     }
778 
779     function isIssuer(address account) public view returns (bool) {
780         return _issuers.has(account);
781     }
782 
783     function addIssuer(address account) public onlyIssuer {
784         _addIssuer(account);
785     }
786 
787     function renounceIssuer() public {
788         _removeIssuer(msg.sender);
789     }
790 
791     function _addIssuer(address account) internal {
792         _issuers.add(account);
793         emit IssuerAdded(account);
794     }
795 
796     function _removeIssuer(address account) internal {
797         _issuers.remove(account);
798         emit IssuerRemoved(account);
799     }
800 }
801 
802 // File: contracts/roles/ControllerRole.sol
803 
804 pragma solidity 0.5.4;
805 
806 
807 
808 // @notice Controllers are capable of performing ERC1644 forced transfers.
809 contract ControllerRole {
810     using Roles for Roles.Role;
811 
812     event ControllerAdded(address indexed account);
813     event ControllerRemoved(address indexed account);
814 
815     Roles.Role internal _controllers;
816 
817     modifier onlyController() {
818         require(isController(msg.sender), "Only Controllers can execute this function.");
819         _;
820     }
821 
822     constructor() internal {
823         _addController(msg.sender);
824     }
825 
826     function isController(address account) public view returns (bool) {
827         return _controllers.has(account);
828     }
829 
830     function addController(address account) public onlyController {
831         _addController(account);
832     }
833 
834     function renounceController() public {
835         _removeController(msg.sender);
836     }
837 
838     function _addController(address account) internal {
839         _controllers.add(account);
840         emit ControllerAdded(account);
841     }    
842 
843     function _removeController(address account) internal {
844         _controllers.remove(account);
845         emit ControllerRemoved(account);
846     }
847 }
848 
849 // File: contracts/compliance/Moderated.sol
850 
851 pragma solidity 0.5.4;
852 
853 
854 
855 
856 
857 contract Moderated is ControllerRole {
858     IModerator public moderator; // External moderator contract
859 
860     event ModeratorUpdated(address moderator);
861 
862     constructor(IModerator _moderator) public {
863         moderator = _moderator;
864     }
865 
866     /**
867     * @notice Links a Moderator contract to this contract.
868     * @param _moderator Moderator contract address.
869     */
870     function setModerator(IModerator _moderator) external onlyController {
871         require(address(moderator) != address(0), "Moderator address must not be a zero address.");
872         require(Address.isContract(address(_moderator)), "Address must point to a contract.");
873         moderator = _moderator;
874         emit ModeratorUpdated(address(_moderator));
875     }
876 }
877 
878 // File: contracts/token/ERC1594.sol
879 
880 pragma solidity 0.5.4;
881 
882 
883 
884 
885 
886 
887 
888 
889 contract ERC1594 is IERC1594, IHasIssuership, Moderated, ERC20Redeemable, IssuerRole {
890     bool public isIssuable = true;
891 
892     event Issued(address indexed operator, address indexed to, uint256 value, bytes data);
893     event Redeemed(address indexed operator, address indexed from, uint256 value, bytes data);
894     event IssuershipTransferred(address indexed from, address indexed to);
895     event IssuanceFinished();
896 
897     /**
898     * @notice Modifier to check token issuance status
899     */
900     modifier whenIssuable() {
901         require(isIssuable, "Issuance period has ended.");
902         _;
903     }
904 
905     /**
906      * @notice Transfer the token's singleton Issuer role to another address.
907      */
908     function transferIssuership(address _newIssuer) public whenIssuable onlyIssuer {
909         require(_newIssuer != address(0), "New Issuer cannot be zero address.");
910         require(msg.sender != _newIssuer, "New Issuer cannot have the same address as the old issuer.");
911         _addIssuer(_newIssuer);
912         _removeIssuer(msg.sender);
913         emit IssuershipTransferred(msg.sender, _newIssuer);
914     }
915 
916     /**
917      * @notice End token issuance period permanently.
918      */
919     function finishIssuance() public whenIssuable onlyIssuer {
920         isIssuable = false;
921         emit IssuanceFinished();
922     }
923 
924     function issue(address _tokenHolder, uint256 _value, bytes memory _data) public whenIssuable onlyIssuer {
925         bool allowed;
926         (allowed, , ) = moderator.verifyIssue(_tokenHolder, _value, _data);
927         require(allowed, "Issue is not allowed.");
928         _mint(_tokenHolder, _value);
929         emit Issued(msg.sender, _tokenHolder, _value, _data);
930     }
931 
932     function redeem(uint256 _value, bytes memory _data) public {
933         bool allowed;
934         (allowed, , ) = moderator.verifyRedeem(msg.sender, _value, _data);
935         require(allowed, "Redeem is not allowed.");
936 
937         _burn(msg.sender, _value);
938         emit Redeemed(msg.sender, msg.sender, _value, _data);
939     }
940 
941     function redeemFrom(address _tokenHolder, uint256 _value, bytes memory _data) public {
942         bool allowed;
943         (allowed, , ) = moderator.verifyRedeemFrom(msg.sender, _tokenHolder, _value, _data);
944         require(allowed, "RedeemFrom is not allowed.");
945 
946         _burnFrom(_tokenHolder, _value);
947         emit Redeemed(msg.sender, _tokenHolder, _value, _data);
948     }
949 
950     function transfer(address _to, uint256 _value) public returns (bool success) {
951         bool allowed;
952         (allowed, , ) = canTransfer(_to, _value, "");
953         require(allowed, "Transfer is not allowed.");
954 
955         success = super.transfer(_to, _value);
956     }
957 
958     function transferWithData(address _to, uint256 _value, bytes memory _data) public {
959         bool allowed;
960         (allowed, , ) = canTransfer(_to, _value, _data);
961         require(allowed, "Transfer is not allowed.");
962 
963         require(super.transfer(_to, _value), "Transfer failed.");
964     }
965 
966     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
967         bool allowed;
968         (allowed, , ) = canTransferFrom(_from, _to, _value, "");
969         require(allowed, "TransferFrom is not allowed.");
970 
971         success = super.transferFrom(_from, _to, _value);
972     }    
973 
974     function transferFromWithData(address _from, address _to, uint256 _value, bytes memory _data) public {
975         bool allowed;
976         (allowed, , ) = canTransferFrom(_from, _to, _value, _data);
977         require(allowed, "TransferFrom is not allowed.");
978 
979         require(super.transferFrom(_from, _to, _value), "TransferFrom failed.");
980     }
981 
982     function canTransfer(address _to, uint256 _value, bytes memory _data) public view 
983         returns (bool success, byte statusCode, bytes32 applicationCode) 
984     {
985         return moderator.verifyTransfer(msg.sender, _to, _value, _data);
986     }
987 
988     function canTransferFrom(address _from, address _to, uint256 _value, bytes memory _data) public view 
989         returns (bool success, byte statusCode, bytes32 applicationCode) 
990     {
991         return moderator.verifyTransferFrom(_from, _to, msg.sender, _value, _data);
992     }
993 }
994 
995 // File: contracts/interfaces/IERC1644.sol
996 
997 pragma solidity 0.5.4;
998 
999 
1000 
1001 /// @title IERC1644 Controller Token Operation (part of the ERC1400 Security Token Standards)
1002 /// @dev See https://github.com/SecurityTokenStandard/EIP-Spec
1003 interface IERC1644 {
1004     // Controller Events
1005     event ControllerTransfer(
1006         address _controller,
1007         address indexed _from,
1008         address indexed _to,
1009         uint256 _value,
1010         bytes _data,
1011         bytes _operatorData
1012     );
1013 
1014     event ControllerRedemption(
1015         address _controller,
1016         address indexed _tokenHolder,
1017         uint256 _value,
1018         bytes _data,
1019         bytes _operatorData
1020     );
1021 
1022     // Controller Operation
1023     function controllerTransfer(address _from, address _to, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external;
1024     function controllerRedeem(address _tokenHolder, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external;
1025     function isControllable() external view returns (bool);
1026 }
1027 
1028 // File: contracts/token/ERC1644.sol
1029 
1030 pragma solidity 0.5.4;
1031 
1032 
1033 
1034 
1035 
1036 
1037 
1038 contract ERC1644 is IERC1644, Moderated, ERC20Redeemable {
1039     event ControllerTransfer(
1040         address controller,
1041         address indexed from,
1042         address indexed to,
1043         uint256 value,
1044         bytes data,
1045         bytes operatorData
1046     );
1047 
1048     event ControllerRedemption(
1049         address controller,
1050         address indexed tokenHolder,
1051         uint256 value,
1052         bytes data,
1053         bytes operatorData
1054     );
1055 
1056     function controllerTransfer(
1057         address _from,
1058         address _to,
1059         uint256 _value,
1060         bytes memory _data,
1061         bytes memory _operatorData
1062     ) public onlyController {
1063         bool allowed;
1064         (allowed, , ) = moderator.verifyControllerTransfer(
1065             msg.sender,
1066             _from,
1067             _to,
1068             _value,
1069             _data,
1070             _operatorData
1071         );
1072         require(allowed, "controllerTransfer is not allowed.");
1073         require(_value <= balanceOf(_from), "Insufficient balance.");
1074         _transfer(_from, _to, _value);
1075         emit ControllerTransfer(msg.sender, _from, _to, _value, _data, _operatorData);
1076     }
1077 
1078     function controllerRedeem(
1079         address _tokenHolder,
1080         uint256 _value,
1081         bytes memory _data,
1082         bytes memory _operatorData
1083     ) public onlyController {
1084         bool allowed;
1085         (allowed, , ) = moderator.verifyControllerRedeem(
1086             msg.sender,
1087             _tokenHolder,
1088             _value,
1089             _data,
1090             _operatorData
1091         );
1092         require(allowed, "controllerRedeem is not allowed.");
1093         require(_value <= balanceOf(_tokenHolder), "Insufficient balance.");
1094         _burn(_tokenHolder, _value);
1095         emit ControllerRedemption(msg.sender, _tokenHolder, _value, _data, _operatorData);
1096     }
1097 
1098     function isControllable() public view returns (bool) {
1099         return true;
1100     }
1101 }
1102 
1103 // File: contracts/token/ERC1400.sol
1104 
1105 pragma solidity 0.5.4;
1106 
1107 
1108 
1109 
1110 
1111 contract ERC1400 is ERC1594, ERC1644 {
1112     constructor(IModerator _moderator) public Moderated(_moderator) {}
1113 }
1114 
1115 // File: contracts/token/ERC20Capped.sol
1116 
1117 pragma solidity 0.5.4;
1118 
1119 
1120 
1121 
1122 /**
1123  * @notice Capped ERC20 token
1124  * @dev ERC20 token with a token cap on mints, to ensure a 1:1 mint ratio of TENX to PAY.
1125  */
1126 contract ERC20Capped is ERC20 {
1127     using SafeMath for uint256;
1128 
1129     uint public cap;
1130     uint public totalMinted;
1131 
1132     constructor (uint _cap) public {
1133         require(_cap > 0, "Cap must be above zero.");
1134         cap = _cap;
1135         totalMinted = 0;
1136     }
1137 
1138     /**
1139     * @notice Modifier to check that an operation does not exceed the token cap.
1140     * @param _newValue Token mint amount
1141     */
1142     modifier capped(uint _newValue) {
1143         require(totalMinted.add(_newValue) <= cap, "Cannot mint beyond cap.");
1144         _;
1145     }
1146 
1147     /**
1148     * @dev Cannot _mint beyond cap.
1149     */
1150     function _mint(address _account, uint _value) internal capped(_value) {
1151         totalMinted = totalMinted.add(_value);
1152         super._mint(_account, _value);
1153     }
1154 }
1155 
1156 // File: contracts/token/RewardableToken.sol
1157 
1158 pragma solidity 0.5.4;
1159 
1160 
1161 
1162 
1163 
1164 
1165 
1166 /**
1167  * @notice RewardableToken
1168  * @dev ERC1400 token with a token cap and amortized rewards calculations. It's pausable for contract migrations.
1169  */
1170 contract RewardableToken is ERC1400, ERC20Capped, Rewardable, Pausable {
1171     constructor(IModerator _moderator, uint _cap) public ERC1400(_moderator) ERC20Capped(_cap) {}
1172 
1173     // ERC20
1174     function transfer(address _to, uint _value) 
1175         public 
1176         whenNotPaused
1177         updatesRewardsOnTransfer(msg.sender, _to, _value) returns (bool success) 
1178     {
1179         success = super.transfer(_to, _value);
1180     }
1181 
1182     function transferFrom(address _from, address _to, uint _value) 
1183         public 
1184         whenNotPaused
1185         updatesRewardsOnTransfer(_from, _to, _value) returns (bool success) 
1186     {
1187         success = super.transferFrom(_from, _to, _value);
1188     }
1189 
1190     // ERC1400: ERC1594
1191     function issue(address _tokenHolder, uint256 _value, bytes memory _data) 
1192         public 
1193         whenNotPaused
1194         // No damping updates, uses unallocated rewards
1195     {
1196         super.issue(_tokenHolder, _value, _data);
1197     }
1198 
1199     function redeem(uint256 _value, bytes memory _data) 
1200         public 
1201         whenNotPaused
1202         updatesRewardsOnBurn(msg.sender, _value)
1203     {
1204         super.redeem(_value, _data);
1205     }
1206 
1207     function redeemFrom(address _tokenHolder, uint256 _value, bytes memory _data) 
1208         public
1209         whenNotPaused
1210         updatesRewardsOnBurn(_tokenHolder, _value)
1211     {
1212         super.redeemFrom(_tokenHolder, _value, _data);
1213     }
1214 
1215     // ERC1400: ERC1644
1216     function controllerTransfer(address _from, address _to, uint256 _value, bytes memory _data, bytes memory _operatorData) 
1217         public
1218         updatesRewardsOnTransfer(_from, _to, _value) 
1219     {
1220         super.controllerTransfer(_from, _to, _value, _data, _operatorData);
1221     }
1222 
1223     function controllerRedeem(address _tokenHolder, uint256 _value, bytes memory _data, bytes memory _operatorData) 
1224         public
1225         updatesRewardsOnBurn(_tokenHolder, _value)
1226     {
1227         super.controllerRedeem(_tokenHolder, _value, _data, _operatorData);
1228     }
1229 }
1230 
1231 // File: contracts/token/TENXToken.sol
1232 
1233 pragma solidity 0.5.4;
1234 
1235 
1236 
1237 
1238 
1239 /**
1240  * @notice TENXToken
1241  */
1242 contract TENXToken is RewardableToken, ERC20Detailed("TenX Token", "TENX", 18) {
1243     constructor(IModerator _moderator, uint _cap) public RewardableToken(_moderator, _cap) {}
1244 }