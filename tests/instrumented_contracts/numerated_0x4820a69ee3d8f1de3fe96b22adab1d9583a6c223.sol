1 /* file: openzeppelin-solidity/contracts/ownership/Ownable.sol */
2 pragma solidity ^0.5.0;
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address private _owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     constructor () internal {
19         _owner = msg.sender;
20         emit OwnershipTransferred(address(0), _owner);
21     }
22 
23     /**
24      * @return the address of the owner.
25      */
26     function owner() public view returns (address) {
27         return _owner;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(isOwner());
35         _;
36     }
37 
38     /**
39      * @return true if `msg.sender` is the owner of the contract.
40      */
41     function isOwner() public view returns (bool) {
42         return msg.sender == _owner;
43     }
44 
45     /**
46      * @dev Allows the current owner to relinquish control of the contract.
47      * @notice Renouncing to ownership will leave the contract without an owner.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 /* eof (openzeppelin-solidity/contracts/ownership/Ownable.sol) */
76 /* file: openzeppelin-solidity/contracts/math/SafeMath.sol */
77 pragma solidity ^0.5.0;
78 
79 /**
80  * @title SafeMath
81  * @dev Unsigned math operations with safety checks that revert on error
82  */
83 library SafeMath {
84     /**
85     * @dev Multiplies two unsigned integers, reverts on overflow.
86     */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b);
97 
98         return c;
99     }
100 
101     /**
102     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
103     */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Solidity only automatically asserts when dividing by 0
106         require(b > 0);
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 
113     /**
114     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
115     */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b <= a);
118         uint256 c = a - b;
119 
120         return c;
121     }
122 
123     /**
124     * @dev Adds two unsigned integers, reverts on overflow.
125     */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a);
129 
130         return c;
131     }
132 
133     /**
134     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
135     * reverts when dividing by zero.
136     */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b != 0);
139         return a % b;
140     }
141 }
142 
143 /* eof (openzeppelin-solidity/contracts/math/SafeMath.sol) */
144 /* file: ./contracts/utils/Utils.sol */
145 /**
146  * @title Manageable Contract
147  * @author Validity Labs AG <info@validitylabs.org>
148  */
149  
150 pragma solidity ^0.5.4;
151 
152 
153 contract Utils {
154     /** MODIFIERS **/
155     modifier onlyValidAddress(address _address) {
156         require(_address != address(0), "invalid address");
157         _;
158     }
159 }
160 
161 /* eof (./contracts/utils/Utils.sol) */
162 /* file: ./contracts/management/Manageable.sol */
163 /**
164  * @title Manageable Contract
165  * @author Validity Labs AG <info@validitylabs.org>
166  */
167  
168  pragma solidity ^0.5.4;
169 
170 
171 contract Manageable is Ownable, Utils {
172     mapping(address => bool) public isManager;     // manager accounts
173 
174     /** EVENTS **/
175     event ChangedManager(address indexed manager, bool active);
176 
177     /** MODIFIERS **/
178     modifier onlyManager() {
179         require(isManager[msg.sender], "is not manager");
180         _;
181     }
182 
183     /**
184     * @notice constructor sets the deployer as a manager
185     */
186     constructor() public {
187         setManager(msg.sender, true);
188     }
189 
190     /**
191      * @notice enable/disable an account to be a manager
192      * @param _manager address address of the manager to create/alter
193      * @param _active bool flag that shows if the manager account is active
194      */
195     function setManager(address _manager, bool _active) public onlyOwner onlyValidAddress(_manager) {
196         isManager[_manager] = _active;
197         emit ChangedManager(_manager, _active);
198     }
199 }
200 
201 /* eof (./contracts/management/Manageable.sol) */
202 /* file: ./contracts/whitelist/GlobalWhitelist.sol */
203 /**
204  * @title Global Whitelist Contract
205  * @author Validity Labs AG <info@validitylabs.org>
206  */
207 
208 pragma solidity ^0.5.4;
209 
210 
211 
212 contract GlobalWhitelist is Ownable, Manageable {
213     using SafeMath for uint256;
214     
215     mapping(address => bool) public isWhitelisted; // addresses of who's whitelisted
216     bool public isWhitelisting = true;             // whitelisting enabled by default
217 
218     /** EVENTS **/
219     event ChangedWhitelisting(address indexed registrant, bool whitelisted);
220     event GlobalWhitelistDisabled(address indexed manager);
221     event GlobalWhitelistEnabled(address indexed manager);
222 
223     /**
224     * @dev add an address to the whitelist
225     * @param _address address
226     */
227     function addAddressToWhitelist(address _address) public onlyManager onlyValidAddress(_address) {
228         isWhitelisted[_address] = true;
229         emit ChangedWhitelisting(_address, true);
230     }
231 
232     /**
233     * @dev add addresses to the whitelist
234     * @param _addresses addresses array
235     */
236     function addAddressesToWhitelist(address[] memory _addresses) public {
237         for (uint256 i = 0; i < _addresses.length; i++) {
238             addAddressToWhitelist(_addresses[i]);
239         }
240     }
241 
242     /**
243     * @dev remove an address from the whitelist
244     * @param _address address
245     */
246     function removeAddressFromWhitelist(address _address) public onlyManager onlyValidAddress(_address) {
247         isWhitelisted[_address] = false;
248         emit ChangedWhitelisting(_address, false);
249     }
250 
251     /**
252     * @dev remove addresses from the whitelist
253     * @param _addresses addresses
254     */
255     function removeAddressesFromWhitelist(address[] memory _addresses) public {
256         for (uint256 i = 0; i < _addresses.length; i++) {
257             removeAddressFromWhitelist(_addresses[i]);
258         }
259     }
260 
261     /** 
262     * @notice toggle the whitelist by the parent contract; ExporoTokenFactory
263     */
264     function toggleWhitelist() public onlyOwner {
265         isWhitelisting ? isWhitelisting = false : isWhitelisting = true;
266         if (isWhitelisting) {
267             emit GlobalWhitelistEnabled(msg.sender);
268         } else {
269             emit GlobalWhitelistDisabled(msg.sender);
270         }
271     }
272 }
273 
274 /* eof (./contracts/whitelist/GlobalWhitelist.sol) */
275 /* file: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol */
276 pragma solidity ^0.5.0;
277 
278 /**
279  * @title ERC20 interface
280  * @dev see https://github.com/ethereum/EIPs/issues/20
281  */
282 interface IERC20 {
283     function transfer(address to, uint256 value) external returns (bool);
284 
285     function approve(address spender, uint256 value) external returns (bool);
286 
287     function transferFrom(address from, address to, uint256 value) external returns (bool);
288 
289     function totalSupply() external view returns (uint256);
290 
291     function balanceOf(address who) external view returns (uint256);
292 
293     function allowance(address owner, address spender) external view returns (uint256);
294 
295     event Transfer(address indexed from, address indexed to, uint256 value);
296 
297     event Approval(address indexed owner, address indexed spender, uint256 value);
298 }
299 
300 /* eof (openzeppelin-solidity/contracts/token/ERC20/IERC20.sol) */
301 /* file: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol */
302 pragma solidity ^0.5.0;
303 
304 
305 /**
306  * @title Standard ERC20 token
307  *
308  * @dev Implementation of the basic standard token.
309  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
310  * Originally based on code by FirstBlood:
311  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
312  *
313  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
314  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
315  * compliant implementations may not do it.
316  */
317 contract ERC20 is IERC20 {
318     using SafeMath for uint256;
319 
320     mapping (address => uint256) private _balances;
321 
322     mapping (address => mapping (address => uint256)) private _allowed;
323 
324     uint256 private _totalSupply;
325 
326     /**
327     * @dev Total number of tokens in existence
328     */
329     function totalSupply() public view returns (uint256) {
330         return _totalSupply;
331     }
332 
333     /**
334     * @dev Gets the balance of the specified address.
335     * @param owner The address to query the balance of.
336     * @return An uint256 representing the amount owned by the passed address.
337     */
338     function balanceOf(address owner) public view returns (uint256) {
339         return _balances[owner];
340     }
341 
342     /**
343      * @dev Function to check the amount of tokens that an owner allowed to a spender.
344      * @param owner address The address which owns the funds.
345      * @param spender address The address which will spend the funds.
346      * @return A uint256 specifying the amount of tokens still available for the spender.
347      */
348     function allowance(address owner, address spender) public view returns (uint256) {
349         return _allowed[owner][spender];
350     }
351 
352     /**
353     * @dev Transfer token for a specified address
354     * @param to The address to transfer to.
355     * @param value The amount to be transferred.
356     */
357     function transfer(address to, uint256 value) public returns (bool) {
358         _transfer(msg.sender, to, value);
359         return true;
360     }
361 
362     /**
363      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
364      * Beware that changing an allowance with this method brings the risk that someone may use both the old
365      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
366      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
367      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
368      * @param spender The address which will spend the funds.
369      * @param value The amount of tokens to be spent.
370      */
371     function approve(address spender, uint256 value) public returns (bool) {
372         require(spender != address(0));
373 
374         _allowed[msg.sender][spender] = value;
375         emit Approval(msg.sender, spender, value);
376         return true;
377     }
378 
379     /**
380      * @dev Transfer tokens from one address to another.
381      * Note that while this function emits an Approval event, this is not required as per the specification,
382      * and other compliant implementations may not emit the event.
383      * @param from address The address which you want to send tokens from
384      * @param to address The address which you want to transfer to
385      * @param value uint256 the amount of tokens to be transferred
386      */
387     function transferFrom(address from, address to, uint256 value) public returns (bool) {
388         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
389         _transfer(from, to, value);
390         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
391         return true;
392     }
393 
394     /**
395      * @dev Increase the amount of tokens that an owner allowed to a spender.
396      * approve should be called when allowed_[_spender] == 0. To increment
397      * allowed value is better to use this function to avoid 2 calls (and wait until
398      * the first transaction is mined)
399      * From MonolithDAO Token.sol
400      * Emits an Approval event.
401      * @param spender The address which will spend the funds.
402      * @param addedValue The amount of tokens to increase the allowance by.
403      */
404     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
405         require(spender != address(0));
406 
407         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
408         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
409         return true;
410     }
411 
412     /**
413      * @dev Decrease the amount of tokens that an owner allowed to a spender.
414      * approve should be called when allowed_[_spender] == 0. To decrement
415      * allowed value is better to use this function to avoid 2 calls (and wait until
416      * the first transaction is mined)
417      * From MonolithDAO Token.sol
418      * Emits an Approval event.
419      * @param spender The address which will spend the funds.
420      * @param subtractedValue The amount of tokens to decrease the allowance by.
421      */
422     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
423         require(spender != address(0));
424 
425         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
426         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
427         return true;
428     }
429 
430     /**
431     * @dev Transfer token for a specified addresses
432     * @param from The address to transfer from.
433     * @param to The address to transfer to.
434     * @param value The amount to be transferred.
435     */
436     function _transfer(address from, address to, uint256 value) internal {
437         require(to != address(0));
438 
439         _balances[from] = _balances[from].sub(value);
440         _balances[to] = _balances[to].add(value);
441         emit Transfer(from, to, value);
442     }
443 
444     /**
445      * @dev Internal function that mints an amount of the token and assigns it to
446      * an account. This encapsulates the modification of balances such that the
447      * proper events are emitted.
448      * @param account The account that will receive the created tokens.
449      * @param value The amount that will be created.
450      */
451     function _mint(address account, uint256 value) internal {
452         require(account != address(0));
453 
454         _totalSupply = _totalSupply.add(value);
455         _balances[account] = _balances[account].add(value);
456         emit Transfer(address(0), account, value);
457     }
458 
459     /**
460      * @dev Internal function that burns an amount of the token of a given
461      * account.
462      * @param account The account whose tokens will be burnt.
463      * @param value The amount that will be burnt.
464      */
465     function _burn(address account, uint256 value) internal {
466         require(account != address(0));
467 
468         _totalSupply = _totalSupply.sub(value);
469         _balances[account] = _balances[account].sub(value);
470         emit Transfer(account, address(0), value);
471     }
472 
473     /**
474      * @dev Internal function that burns an amount of the token of a given
475      * account, deducting from the sender's allowance for said account. Uses the
476      * internal burn function.
477      * Emits an Approval event (reflecting the reduced allowance).
478      * @param account The account whose tokens will be burnt.
479      * @param value The amount that will be burnt.
480      */
481     function _burnFrom(address account, uint256 value) internal {
482         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
483         _burn(account, value);
484         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
485     }
486 }
487 
488 /* eof (openzeppelin-solidity/contracts/token/ERC20/ERC20.sol) */
489 /* file: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol */
490 pragma solidity ^0.5.0;
491 
492 
493 /**
494  * @title ERC20Detailed token
495  * @dev The decimals are only for visualization purposes.
496  * All the operations are done using the smallest and indivisible token unit,
497  * just as on Ethereum all the operations are done in wei.
498  */
499 contract ERC20Detailed is IERC20 {
500     string private _name;
501     string private _symbol;
502     uint8 private _decimals;
503 
504     constructor (string memory name, string memory symbol, uint8 decimals) public {
505         _name = name;
506         _symbol = symbol;
507         _decimals = decimals;
508     }
509 
510     /**
511      * @return the name of the token.
512      */
513     function name() public view returns (string memory) {
514         return _name;
515     }
516 
517     /**
518      * @return the symbol of the token.
519      */
520     function symbol() public view returns (string memory) {
521         return _symbol;
522     }
523 
524     /**
525      * @return the number of decimals of the token.
526      */
527     function decimals() public view returns (uint8) {
528         return _decimals;
529     }
530 }
531 
532 /* eof (openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol) */
533 /* file: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol */
534 pragma solidity ^0.5.0;
535 
536 
537 /**
538  * @title Burnable Token
539  * @dev Token that can be irreversibly burned (destroyed).
540  */
541 contract ERC20Burnable is ERC20 {
542     /**
543      * @dev Burns a specific amount of tokens.
544      * @param value The amount of token to be burned.
545      */
546     function burn(uint256 value) public {
547         _burn(msg.sender, value);
548     }
549 
550     /**
551      * @dev Burns a specific amount of tokens from the target address and decrements allowance
552      * @param from address The address which you want to send tokens from
553      * @param value uint256 The amount of token to be burned
554      */
555     function burnFrom(address from, uint256 value) public {
556         _burnFrom(from, value);
557     }
558 }
559 
560 /* eof (openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol) */
561 /* file: openzeppelin-solidity/contracts/access/Roles.sol */
562 pragma solidity ^0.5.0;
563 
564 /**
565  * @title Roles
566  * @dev Library for managing addresses assigned to a Role.
567  */
568 library Roles {
569     struct Role {
570         mapping (address => bool) bearer;
571     }
572 
573     /**
574      * @dev give an account access to this role
575      */
576     function add(Role storage role, address account) internal {
577         require(account != address(0));
578         require(!has(role, account));
579 
580         role.bearer[account] = true;
581     }
582 
583     /**
584      * @dev remove an account's access to this role
585      */
586     function remove(Role storage role, address account) internal {
587         require(account != address(0));
588         require(has(role, account));
589 
590         role.bearer[account] = false;
591     }
592 
593     /**
594      * @dev check if an account has this role
595      * @return bool
596      */
597     function has(Role storage role, address account) internal view returns (bool) {
598         require(account != address(0));
599         return role.bearer[account];
600     }
601 }
602 
603 /* eof (openzeppelin-solidity/contracts/access/Roles.sol) */
604 /* file: openzeppelin-solidity/contracts/access/roles/PauserRole.sol */
605 pragma solidity ^0.5.0;
606 
607 
608 contract PauserRole {
609     using Roles for Roles.Role;
610 
611     event PauserAdded(address indexed account);
612     event PauserRemoved(address indexed account);
613 
614     Roles.Role private _pausers;
615 
616     constructor () internal {
617         _addPauser(msg.sender);
618     }
619 
620     modifier onlyPauser() {
621         require(isPauser(msg.sender));
622         _;
623     }
624 
625     function isPauser(address account) public view returns (bool) {
626         return _pausers.has(account);
627     }
628 
629     function addPauser(address account) public onlyPauser {
630         _addPauser(account);
631     }
632 
633     function renouncePauser() public {
634         _removePauser(msg.sender);
635     }
636 
637     function _addPauser(address account) internal {
638         _pausers.add(account);
639         emit PauserAdded(account);
640     }
641 
642     function _removePauser(address account) internal {
643         _pausers.remove(account);
644         emit PauserRemoved(account);
645     }
646 }
647 
648 /* eof (openzeppelin-solidity/contracts/access/roles/PauserRole.sol) */
649 /* file: openzeppelin-solidity/contracts/lifecycle/Pausable.sol */
650 pragma solidity ^0.5.0;
651 
652 
653 /**
654  * @title Pausable
655  * @dev Base contract which allows children to implement an emergency stop mechanism.
656  */
657 contract Pausable is PauserRole {
658     event Paused(address account);
659     event Unpaused(address account);
660 
661     bool private _paused;
662 
663     constructor () internal {
664         _paused = false;
665     }
666 
667     /**
668      * @return true if the contract is paused, false otherwise.
669      */
670     function paused() public view returns (bool) {
671         return _paused;
672     }
673 
674     /**
675      * @dev Modifier to make a function callable only when the contract is not paused.
676      */
677     modifier whenNotPaused() {
678         require(!_paused);
679         _;
680     }
681 
682     /**
683      * @dev Modifier to make a function callable only when the contract is paused.
684      */
685     modifier whenPaused() {
686         require(_paused);
687         _;
688     }
689 
690     /**
691      * @dev called by the owner to pause, triggers stopped state
692      */
693     function pause() public onlyPauser whenNotPaused {
694         _paused = true;
695         emit Paused(msg.sender);
696     }
697 
698     /**
699      * @dev called by the owner to unpause, returns to normal state
700      */
701     function unpause() public onlyPauser whenPaused {
702         _paused = false;
703         emit Unpaused(msg.sender);
704     }
705 }
706 
707 /* eof (openzeppelin-solidity/contracts/lifecycle/Pausable.sol) */
708 /* file: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol */
709 pragma solidity ^0.5.0;
710 
711 
712 /**
713  * @title Pausable token
714  * @dev ERC20 modified with pausable transfers.
715  **/
716 contract ERC20Pausable is ERC20, Pausable {
717     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
718         return super.transfer(to, value);
719     }
720 
721     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
722         return super.transferFrom(from, to, value);
723     }
724 
725     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
726         return super.approve(spender, value);
727     }
728 
729     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
730         return super.increaseAllowance(spender, addedValue);
731     }
732 
733     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
734         return super.decreaseAllowance(spender, subtractedValue);
735     }
736 }
737 
738 /* eof (openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol) */
739 /* file: ./contracts/token/ERC20/IERC20Snapshot.sol */
740 /**
741  * @title Interface ERC20 SnapshotToken (abstract contract)
742  * @author Validity Labs AG <info@validitylabs.org>
743  */
744 
745 pragma solidity ^0.5.4;  
746 
747 
748 /* solhint-disable no-empty-blocks */
749 contract IERC20Snapshot {   
750     /**
751     * @dev Queries the balance of `_owner` at a specific `_blockNumber`
752     * @param _owner The address from which the balance will be retrieved
753     * @param _blockNumber The block number when the balance is queried
754     * @return The balance at `_blockNumber`
755     */
756     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint256) {}
757 
758     /**
759     * @notice Total amount of tokens at a specific `_blockNumber`.
760     * @param _blockNumber The block number when the totalSupply is queried
761     * @return The total amount of tokens at `_blockNumber`
762     */
763     function totalSupplyAt(uint _blockNumber) public view returns(uint256) {}
764 }
765 
766 /* eof (./contracts/token/ERC20/IERC20Snapshot.sol) */
767 /* file: ./contracts/token/ERC20/ERC20Snapshot.sol */
768 /**
769  * @title ERC20 Snapshot Token
770  * inspired by Jordi Baylina's MiniMeToken to record historical balances
771  * @author Validity Labs AG <info@validitylabs.org>
772  */
773 
774 pragma solidity ^0.5.4;  
775 
776 
777 
778 contract ERC20Snapshot is IERC20Snapshot, ERC20 {   
779     using SafeMath for uint256;
780 
781     /**
782     * @dev `Snapshot` is the structure that attaches a block number to a
783     * given value. The block number attached is the one that last changed the value
784     */
785     struct Snapshot {
786         uint128 fromBlock;  // `fromBlock` is the block number at which the value was generated from
787         uint128 value;  // `value` is the amount of tokens at a specific block number
788     }
789 
790     /**
791     * @dev `_snapshotBalances` is the map that tracks the balance of each address, in this
792     * contract when the balance changes the block number that the change
793     * occurred is also included in the map
794     */
795     mapping (address => Snapshot[]) private _snapshotBalances;
796 
797     // Tracks the history of the `_totalSupply` & '_mintedSupply' of the token
798     Snapshot[] private _snapshotTotalSupply;
799 
800     /*** FUNCTIONS ***/
801     /** OVERRIDE
802     * @dev Send `_value` tokens to `_to` from `msg.sender`
803     * @param _to The address of the recipient
804     * @param _value The amount of tokens to be transferred
805     * @return Whether the transfer was successful or not
806     */
807     function transfer(address _to, uint256 _value) public returns (bool result) {
808         result = super.transfer(_to, _value);
809         createSnapshot(msg.sender, _to);
810     }
811 
812     /** OVERRIDE
813     * @dev Send `_value` tokens to `_to` from `_from` on the condition it is approved by `_from`
814     * @param _from The address holding the tokens being transferred
815     * @param _to The address of the recipient
816     * @param _value The amount of tokens to be transferred
817     * @return True if the transfer was successful
818     */
819     function transferFrom(address _from, address _to, uint256 _value) public returns (bool result) {
820         result = super.transferFrom(_from, _to, _value);
821         createSnapshot(_from, _to);
822     }
823 
824     /**
825     * @dev Queries the balance of `_owner` at a specific `_blockNumber`
826     * @param _owner The address from which the balance will be retrieved
827     * @param _blockNumber The block number when the balance is queried
828     * @return The balance at `_blockNumber`
829     */
830     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint256) {
831         return getValueAt(_snapshotBalances[_owner], _blockNumber);
832     }
833 
834     /**
835     * @dev Total supply cap of tokens at a specific `_blockNumber`.
836     * @param _blockNumber The block number when the totalSupply is queried
837     * @return The total supply cap of tokens at `_blockNumber`
838     */
839     function totalSupplyAt(uint _blockNumber) public view returns(uint256) {
840         return getValueAt(_snapshotTotalSupply, _blockNumber);
841     }
842 
843     /*** Internal functions ***/
844     /**
845     * @dev Updates snapshot mappings for _from and _to and emit an event
846     * @param _from The address holding the tokens being transferred
847     * @param _to The address of the recipient
848     * @return True if the transfer was successful
849     */
850     function createSnapshot(address _from, address _to) internal {
851         updateValueAtNow(_snapshotBalances[_from], balanceOf(_from));
852         updateValueAtNow(_snapshotBalances[_to], balanceOf(_to));
853     }
854 
855     /**
856     * @dev `getValueAt` retrieves the number of tokens at a given block number
857     * @param checkpoints The history of values being queried
858     * @param _block The block number to retrieve the value at
859     * @return The number of tokens being queried
860     */
861     function getValueAt(Snapshot[] storage checkpoints, uint _block) internal view returns (uint) {
862         if (checkpoints.length == 0) return 0;
863 
864         // Shortcut for the actual value
865         if (_block >= checkpoints[checkpoints.length.sub(1)].fromBlock) {
866             return checkpoints[checkpoints.length.sub(1)].value;
867         }
868 
869         if (_block < checkpoints[0].fromBlock) {
870             return 0;
871         } 
872 
873         // Binary search of the value in the array
874         uint min;
875         uint max = checkpoints.length.sub(1);
876 
877         while (max > min) {
878             uint mid = (max.add(min).add(1)).div(2);
879             if (checkpoints[mid].fromBlock <= _block) {
880                 min = mid;
881             } else {
882                 max = mid.sub(1);
883             }
884         }
885 
886         return checkpoints[min].value;
887     }
888 
889     /**
890     * @dev `updateValueAtNow` used to update the `_snapshotBalances` map and the `_snapshotTotalSupply`
891     * @param checkpoints The history of data being updated
892     * @param _value The new number of tokens
893     */
894     function updateValueAtNow(Snapshot[] storage checkpoints, uint _value) internal {
895         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length.sub(1)].fromBlock < block.number)) {
896             checkpoints.push(Snapshot(uint128(block.number), uint128(_value)));
897         } else {
898             checkpoints[checkpoints.length.sub(1)].value = uint128(_value);
899         }
900     }
901 }
902 
903 /* eof (./contracts/token/ERC20/ERC20Snapshot.sol) */
904 /* file: ./contracts/token/ERC20/ERC20ForcedTransfer.sol */
905 /**
906  * @title ERC20Confiscatable
907  * @author Validity Labs AG <info@validitylabs.org>
908  */
909 
910 pragma solidity ^0.5.4;  
911 
912 
913 
914 contract ERC20ForcedTransfer is Ownable, ERC20 {
915     /*** EVENTS ***/
916     event ForcedTransfer(address indexed account, uint256 amount, address indexed receiver);
917 
918     /*** FUNCTIONS ***/
919     /**
920     * @notice takes funds from _confiscatee and sends them to _receiver
921     * @param _confiscatee address who's funds are being confiscated
922     * @param _receiver address who's receiving the funds 
923     */
924     function forceTransfer(address _confiscatee, address _receiver) public onlyOwner {
925         uint256 balance = balanceOf(_confiscatee);
926         _transfer(_confiscatee, _receiver, balance);
927         emit ForcedTransfer(_confiscatee, balance, _receiver);
928     }
929 }
930 
931 /* eof (./contracts/token/ERC20/ERC20ForcedTransfer.sol) */
932 /* file: ./contracts/token/ERC20/ERC20Whitelist.sol */
933 /**
934  * @title ERC20Whitelist
935  * @author Validity Labs AG <info@validitylabs.org>
936  */
937 
938 pragma solidity ^0.5.4;  
939 
940 
941 
942 contract ERC20Whitelist is Ownable, ERC20 {   
943     GlobalWhitelist public whitelist;
944     bool public isWhitelisting = true;  // default to true
945 
946     /** EVENTS **/
947     event ESTWhitelistingEnabled();
948     event ESTWhitelistingDisabled();
949 
950     /*** FUNCTIONS ***/
951     /**
952     * @notice disables whitelist per individual EST
953     * @dev parnent contract, ExporoTokenFactory, is owner
954     */
955     function toggleWhitelist() external onlyOwner {
956         isWhitelisting ? isWhitelisting = false : isWhitelisting = true;
957         if (isWhitelisting) {
958             emit ESTWhitelistingEnabled();
959         } else {
960             emit ESTWhitelistingDisabled();
961         }
962     }
963 
964     /** OVERRIDE
965     * @dev transfer token for a specified address
966     * @param _to The address to transfer to.
967     * @param _value The amount to be transferred.
968     * @return bool
969     */
970     function transfer(address _to, uint256 _value) public returns (bool) {
971         if (checkWhitelistEnabled()) {
972             checkIfWhitelisted(msg.sender);
973             checkIfWhitelisted(_to);
974         }
975         return super.transfer(_to, _value);
976     }
977 
978     /** OVERRIDE
979     * @dev Transfer tokens from one address to another
980     * @param _from address The address which you want to send tokens from
981     * @param _to address The address which you want to transfer to
982     * @param _value uint256 the amount of tokens to be transferred
983     * @return bool
984     */
985     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
986         if (checkWhitelistEnabled()) {
987             checkIfWhitelisted(_from);
988             checkIfWhitelisted(_to);
989         }
990         return super.transferFrom(_from, _to, _value);
991     }
992 
993     /**
994     * @dev check if whitelisting is in effect versus local and global bools
995     * @return bool
996     */
997     function checkWhitelistEnabled() public view returns (bool) {
998         // local whitelist
999         if (isWhitelisting) {
1000             // global whitelist
1001             if (whitelist.isWhitelisting()) {
1002                 return true;
1003             }
1004         }
1005 
1006         return false;
1007     }
1008 
1009     /*** INTERNAL/PRIVATE ***/
1010     /**
1011     * @dev check if the address has been whitelisted by the Whitelist contract
1012     * @param _account address of the account to check
1013     */
1014     function checkIfWhitelisted(address _account) internal view {
1015         require(whitelist.isWhitelisted(_account), "not whitelisted");
1016     }
1017 }
1018 
1019 /* eof (./contracts/token/ERC20/ERC20Whitelist.sol) */
1020 /* file: ./contracts/token/ERC20/ERC20DocumentRegistry.sol */
1021 /**
1022  * @title ERC20 Document Registry Contract
1023  * @author Validity Labs AG <info@validitylabs.org>
1024  */
1025  
1026  pragma solidity ^0.5.4;
1027 
1028 
1029 
1030 /**
1031  * @notice Prospectus and Quarterly Reports stored hashes via IPFS
1032  * @dev read IAgreement for details under /contracts/neufund/standards
1033 */
1034 // solhint-disable not-rely-on-time
1035 contract ERC20DocumentRegistry is Ownable {
1036     using SafeMath for uint256;
1037 
1038     struct HashedDocument {
1039         uint256 timestamp;
1040         string documentUri;
1041     }
1042 
1043     // array of all documents 
1044     HashedDocument[] private _documents;
1045 
1046     event LogDocumentedAdded(string documentUri, uint256 documentIndex);
1047 
1048     /**
1049     * @notice adds a document's uri from IPFS to the array
1050     * @param documentUri string
1051     */
1052     function addDocument(string memory documentUri) public onlyOwner {
1053         require(bytes(documentUri).length > 0, "invalid documentUri");
1054 
1055         HashedDocument memory document = HashedDocument({
1056             timestamp: block.timestamp,
1057             documentUri: documentUri
1058         });
1059 
1060         _documents.push(document);
1061 
1062         emit LogDocumentedAdded(documentUri, _documents.length.sub(1));
1063     }
1064 
1065     /**
1066     * @notice fetch the latest document on the array
1067     * @return uint256, string, uint256 
1068     */
1069     function currentDocument() public view 
1070         returns (uint256 timestamp, string memory documentUri, uint256 index) {
1071             require(_documents.length > 0, "no documents exist");
1072             uint256 last = _documents.length.sub(1);
1073 
1074             HashedDocument storage document = _documents[last];
1075             return (document.timestamp, document.documentUri, last);
1076         }
1077 
1078     /**
1079     * @notice adds a document's uri from IPFS to the array
1080     * @param documentIndex uint256
1081     * @return uint256, string, uint256 
1082     */
1083     function getDocument(uint256 documentIndex) public view
1084         returns (uint256 timestamp, string memory documentUri, uint256 index) {
1085             require(documentIndex < _documents.length, "invalid index");
1086 
1087             HashedDocument storage document = _documents[documentIndex];
1088             return (document.timestamp, document.documentUri, documentIndex);
1089         }
1090 
1091     /**
1092     * @notice return the total amount of documents in the array
1093     * @return uint256
1094     */
1095     function documentCount() public view returns (uint256) {
1096         return _documents.length;
1097     }
1098 }
1099 
1100 /* eof (./contracts/token/ERC20/ERC20DocumentRegistry.sol) */
1101 /* file: ./contracts/exporo/ExporoToken.sol */
1102 /**
1103  * @title Exporo Token Contract
1104  * @author Validity Labs AG <info@validitylabs.org>
1105  */
1106 
1107 pragma solidity ^0.5.4;
1108 
1109 
1110 
1111 contract SampleToken is Ownable, ERC20, ERC20Detailed {
1112     /*** FUNCTIONS ***/
1113     /**
1114     * @dev constructor
1115     * @param _name string
1116     * @param _symbol string
1117     * @param _decimal uint8
1118     * @param _initialSupply uint256 initial total supply cap. can be 0
1119     * @param _recipient address to recieve the tokens
1120     */
1121     /* solhint-disable */
1122     constructor(string memory _name, string memory _symbol, uint8 _decimal, uint256 _initialSupply, address _recipient)
1123         public 
1124         ERC20Detailed(_name, _symbol, _decimal) {
1125             _mint(_recipient, _initialSupply);
1126         }
1127     /* solhint-enable */
1128 }
1129 
1130 /* eof (./contracts/exporo/ExporoToken.sol) */
1131 /* file: ./contracts/exporo/ExporoTokenFactory.sol */
1132 /**
1133  * @title Exporo Token Factory Contract
1134  * @author Validity Labs AG <info@validitylabs.org>
1135  */
1136 
1137 pragma solidity ^0.5.4;
1138 
1139 
1140 
1141 /* solhint-disable max-line-length */
1142 /* solhint-disable separate-by-one-line-in-contract */
1143 contract SampleTokenFactory is Ownable, Manageable {
1144     address public whitelist;
1145 
1146     /*** EVENTS ***/
1147     event NewTokenDeployed(address indexed contractAddress, string name, string symbol, uint8 decimals);
1148    
1149 
1150     /**
1151     * @dev allows owner to launch a new token with a new name, symbol, and decimals.
1152     * Defaults to using whitelist stored in this contract. If _whitelist is address(0), else it will use
1153     * _whitelist as the param to pass into the new token's constructor upon deployment 
1154     * @param _name string
1155     * @param _symbol string
1156     * @param _decimals uint8 
1157     * @param _initialSupply uint256 initial total supply cap
1158     * @param _recipient address to recieve the initial token supply
1159     */
1160     function newToken(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply, address _recipient) 
1161         public 
1162         onlyManager 
1163         onlyValidAddress(_recipient)
1164         returns (address) {
1165             require(bytes(_name).length > 0, "name cannot be blank");
1166             require(bytes(_symbol).length > 0, "symbol cannot be blank");
1167             require(_initialSupply > 0, "supply cannot be 0");
1168 
1169             SampleToken token = new SampleToken(_name, _symbol, _decimals, _initialSupply, _recipient);
1170 
1171             emit NewTokenDeployed(address(token), _name, _symbol, _decimals);
1172             
1173             return address(token);
1174         }
1175 }
1176 
1177 /* eof (./contracts/exporo/ExporoTokenFactory.sol) */