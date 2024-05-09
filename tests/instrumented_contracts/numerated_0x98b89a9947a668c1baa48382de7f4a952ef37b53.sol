1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
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
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
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
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
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
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
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
123     * @dev Total number of tokens in existence
124     */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param owner The address to query the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
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
149     * @dev Transfer token for a specified address
150     * @param to The address to transfer to.
151     * @param value The amount to be transferred.
152     */
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
168         require(spender != address(0));
169 
170         _allowed[msg.sender][spender] = value;
171         emit Approval(msg.sender, spender, value);
172         return true;
173     }
174 
175     /**
176      * @dev Transfer tokens from one address to another.
177      * Note that while this function emits an Approval event, this is not required as per the specification,
178      * and other compliant implementations may not emit the event.
179      * @param from address The address which you want to send tokens from
180      * @param to address The address which you want to transfer to
181      * @param value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address from, address to, uint256 value) public returns (bool) {
184         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
185         _transfer(from, to, value);
186         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed_[_spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         require(spender != address(0));
202 
203         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
204         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when allowed_[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         require(spender != address(0));
220 
221         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
222         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Transfer token for a specified addresses
228     * @param from The address to transfer from.
229     * @param to The address to transfer to.
230     * @param value The amount to be transferred.
231     */
232     function _transfer(address from, address to, uint256 value) internal {
233         require(to != address(0));
234 
235         _balances[from] = _balances[from].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(from, to, value);
238     }
239 
240     /**
241      * @dev Internal function that mints an amount of the token and assigns it to
242      * an account. This encapsulates the modification of balances such that the
243      * proper events are emitted.
244      * @param account The account that will receive the created tokens.
245      * @param value The amount that will be created.
246      */
247     function _mint(address account, uint256 value) internal {
248         require(account != address(0));
249 
250         _totalSupply = _totalSupply.add(value);
251         _balances[account] = _balances[account].add(value);
252         emit Transfer(address(0), account, value);
253     }
254 
255     /**
256      * @dev Internal function that burns an amount of the token of a given
257      * account.
258      * @param account The account whose tokens will be burnt.
259      * @param value The amount that will be burnt.
260      */
261     function _burn(address account, uint256 value) internal {
262         require(account != address(0));
263 
264         _totalSupply = _totalSupply.sub(value);
265         _balances[account] = _balances[account].sub(value);
266         emit Transfer(account, address(0), value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account, deducting from the sender's allowance for said account. Uses the
272      * internal burn function.
273      * Emits an Approval event (reflecting the reduced allowance).
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burnFrom(address account, uint256 value) internal {
278         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
279         _burn(account, value);
280         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
281     }
282 }
283 
284 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
285 
286 pragma solidity ^0.5.0;
287 
288 
289 /**
290  * @title ERC20Detailed token
291  * @dev The decimals are only for visualization purposes.
292  * All the operations are done using the smallest and indivisible token unit,
293  * just as on Ethereum all the operations are done in wei.
294  */
295 contract ERC20Detailed is IERC20 {
296     string private _name;
297     string private _symbol;
298     uint8 private _decimals;
299 
300     constructor (string memory name, string memory symbol, uint8 decimals) public {
301         _name = name;
302         _symbol = symbol;
303         _decimals = decimals;
304     }
305 
306     /**
307      * @return the name of the token.
308      */
309     function name() public view returns (string memory) {
310         return _name;
311     }
312 
313     /**
314      * @return the symbol of the token.
315      */
316     function symbol() public view returns (string memory) {
317         return _symbol;
318     }
319 
320     /**
321      * @return the number of decimals of the token.
322      */
323     function decimals() public view returns (uint8) {
324         return _decimals;
325     }
326 }
327 
328 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
329 
330 pragma solidity ^0.5.0;
331 
332 
333 /**
334  * @title Burnable Token
335  * @dev Token that can be irreversibly burned (destroyed).
336  */
337 contract ERC20Burnable is ERC20 {
338     /**
339      * @dev Burns a specific amount of tokens.
340      * @param value The amount of token to be burned.
341      */
342     function burn(uint256 value) public {
343         _burn(msg.sender, value);
344     }
345 
346     /**
347      * @dev Burns a specific amount of tokens from the target address and decrements allowance
348      * @param from address The address which you want to send tokens from
349      * @param value uint256 The amount of token to be burned
350      */
351     function burnFrom(address from, uint256 value) public {
352         _burnFrom(from, value);
353     }
354 }
355 
356 // File: openzeppelin-solidity/contracts/access/Roles.sol
357 
358 pragma solidity ^0.5.0;
359 
360 /**
361  * @title Roles
362  * @dev Library for managing addresses assigned to a Role.
363  */
364 library Roles {
365     struct Role {
366         mapping (address => bool) bearer;
367     }
368 
369     /**
370      * @dev give an account access to this role
371      */
372     function add(Role storage role, address account) internal {
373         require(account != address(0));
374         require(!has(role, account));
375 
376         role.bearer[account] = true;
377     }
378 
379     /**
380      * @dev remove an account's access to this role
381      */
382     function remove(Role storage role, address account) internal {
383         require(account != address(0));
384         require(has(role, account));
385 
386         role.bearer[account] = false;
387     }
388 
389     /**
390      * @dev check if an account has this role
391      * @return bool
392      */
393     function has(Role storage role, address account) internal view returns (bool) {
394         require(account != address(0));
395         return role.bearer[account];
396     }
397 }
398 
399 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
400 
401 pragma solidity ^0.5.0;
402 
403 
404 contract MinterRole {
405     using Roles for Roles.Role;
406 
407     event MinterAdded(address indexed account);
408     event MinterRemoved(address indexed account);
409 
410     Roles.Role private _minters;
411 
412     constructor () internal {
413         _addMinter(msg.sender);
414     }
415 
416     modifier onlyMinter() {
417         require(isMinter(msg.sender));
418         _;
419     }
420 
421     function isMinter(address account) public view returns (bool) {
422         return _minters.has(account);
423     }
424 
425     function addMinter(address account) public onlyMinter {
426         _addMinter(account);
427     }
428 
429     function renounceMinter() public {
430         _removeMinter(msg.sender);
431     }
432 
433     function _addMinter(address account) internal {
434         _minters.add(account);
435         emit MinterAdded(account);
436     }
437 
438     function _removeMinter(address account) internal {
439         _minters.remove(account);
440         emit MinterRemoved(account);
441     }
442 }
443 
444 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
445 
446 pragma solidity ^0.5.0;
447 
448 
449 
450 /**
451  * @title ERC20Mintable
452  * @dev ERC20 minting logic
453  */
454 contract ERC20Mintable is ERC20, MinterRole {
455     /**
456      * @dev Function to mint tokens
457      * @param to The address that will receive the minted tokens.
458      * @param value The amount of tokens to mint.
459      * @return A boolean that indicates if the operation was successful.
460      */
461     function mint(address to, uint256 value) public onlyMinter returns (bool) {
462         _mint(to, value);
463         return true;
464     }
465 }
466 
467 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
468 
469 pragma solidity ^0.5.0;
470 
471 
472 contract PauserRole {
473     using Roles for Roles.Role;
474 
475     event PauserAdded(address indexed account);
476     event PauserRemoved(address indexed account);
477 
478     Roles.Role private _pausers;
479 
480     constructor () internal {
481         _addPauser(msg.sender);
482     }
483 
484     modifier onlyPauser() {
485         require(isPauser(msg.sender));
486         _;
487     }
488 
489     function isPauser(address account) public view returns (bool) {
490         return _pausers.has(account);
491     }
492 
493     function addPauser(address account) public onlyPauser {
494         _addPauser(account);
495     }
496 
497     function renouncePauser() public {
498         _removePauser(msg.sender);
499     }
500 
501     function _addPauser(address account) internal {
502         _pausers.add(account);
503         emit PauserAdded(account);
504     }
505 
506     function _removePauser(address account) internal {
507         _pausers.remove(account);
508         emit PauserRemoved(account);
509     }
510 }
511 
512 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
513 
514 pragma solidity ^0.5.0;
515 
516 
517 /**
518  * @title Pausable
519  * @dev Base contract which allows children to implement an emergency stop mechanism.
520  */
521 contract Pausable is PauserRole {
522     event Paused(address account);
523     event Unpaused(address account);
524 
525     bool private _paused;
526 
527     constructor () internal {
528         _paused = false;
529     }
530 
531     /**
532      * @return true if the contract is paused, false otherwise.
533      */
534     function paused() public view returns (bool) {
535         return _paused;
536     }
537 
538     /**
539      * @dev Modifier to make a function callable only when the contract is not paused.
540      */
541     modifier whenNotPaused() {
542         require(!_paused);
543         _;
544     }
545 
546     /**
547      * @dev Modifier to make a function callable only when the contract is paused.
548      */
549     modifier whenPaused() {
550         require(_paused);
551         _;
552     }
553 
554     /**
555      * @dev called by the owner to pause, triggers stopped state
556      */
557     function pause() public onlyPauser whenNotPaused {
558         _paused = true;
559         emit Paused(msg.sender);
560     }
561 
562     /**
563      * @dev called by the owner to unpause, returns to normal state
564      */
565     function unpause() public onlyPauser whenPaused {
566         _paused = false;
567         emit Unpaused(msg.sender);
568     }
569 }
570 
571 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
572 
573 pragma solidity ^0.5.0;
574 
575 /**
576  * @title Ownable
577  * @dev The Ownable contract has an owner address, and provides basic authorization control
578  * functions, this simplifies the implementation of "user permissions".
579  */
580 contract Ownable {
581     address private _owner;
582 
583     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
584 
585     /**
586      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
587      * account.
588      */
589     constructor () internal {
590         _owner = msg.sender;
591         emit OwnershipTransferred(address(0), _owner);
592     }
593 
594     /**
595      * @return the address of the owner.
596      */
597     function owner() public view returns (address) {
598         return _owner;
599     }
600 
601     /**
602      * @dev Throws if called by any account other than the owner.
603      */
604     modifier onlyOwner() {
605         require(isOwner());
606         _;
607     }
608 
609     /**
610      * @return true if `msg.sender` is the owner of the contract.
611      */
612     function isOwner() public view returns (bool) {
613         return msg.sender == _owner;
614     }
615 
616     /**
617      * @dev Allows the current owner to relinquish control of the contract.
618      * @notice Renouncing to ownership will leave the contract without an owner.
619      * It will not be possible to call the functions with the `onlyOwner`
620      * modifier anymore.
621      */
622     function renounceOwnership() public onlyOwner {
623         emit OwnershipTransferred(_owner, address(0));
624         _owner = address(0);
625     }
626 
627     /**
628      * @dev Allows the current owner to transfer control of the contract to a newOwner.
629      * @param newOwner The address to transfer ownership to.
630      */
631     function transferOwnership(address newOwner) public onlyOwner {
632         _transferOwnership(newOwner);
633     }
634 
635     /**
636      * @dev Transfers control of the contract to a newOwner.
637      * @param newOwner The address to transfer ownership to.
638      */
639     function _transferOwnership(address newOwner) internal {
640         require(newOwner != address(0));
641         emit OwnershipTransferred(_owner, newOwner);
642         _owner = newOwner;
643     }
644 }
645 
646 // File: contracts/ERC20PartialLock.sol
647 
648 pragma solidity ^0.5.0;
649 
650 
651 
652 
653 
654 
655 /**
656  * @title Pausable token
657  * @dev ERC20 modified with pausable transfers.
658  */
659 
660  contract ERC20PartialLock is ERC20, Ownable, Pausable {
661 
662    using SafeMath for uint256;
663    mapping (address => uint256) private _locked;
664    mapping (address => uint256) private _totalAllowed;
665 
666     function _lock(address account, uint256 value) internal {
667         require(account != address(0));
668         require(balanceOf(account) >= _locked[account].add(value));
669         _locked[account] = _locked[account].add(value);
670     }
671 
672      function _release(address account, uint256 value) internal {
673          require(account != address(0));
674          _locked[account] = _locked[account].sub(value);
675      }
676 
677      function lockedOf(address owner) public view returns (uint256) {
678         return _locked[owner];
679     }
680 
681 
682     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
683         require(balanceOf(msg.sender).sub(_locked[msg.sender]) >= value);
684         return super.transfer(to, value);
685     }
686 
687     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
688         return super.transferFrom(from, to, value);
689     }
690 
691     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
692         require(balanceOf(msg.sender).sub(_totalAllowed[msg.sender]).sub(_locked[msg.sender]) >= value);
693         _totalAllowed[msg.sender] = _totalAllowed[msg.sender].add(value);
694         return super.approve(spender, value);
695     }
696 
697     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
698         require(balanceOf(msg.sender).sub(_totalAllowed[msg.sender]).sub(_locked[msg.sender]) >= addedValue);
699         _totalAllowed[msg.sender] = _totalAllowed[msg.sender].add(addedValue);
700         return super.increaseAllowance(spender, addedValue);
701     }
702 
703     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
704         _totalAllowed[msg.sender] = _totalAllowed[msg.sender].sub(subtractedValue);
705         return super.decreaseAllowance(spender, subtractedValue);
706     }
707 
708     function Lock(address lockee, uint256 value) public onlyOwner returns (bool) {
709       _lock(lockee, value);
710       return true;
711     }
712 
713     function Release(address lockee, uint256 value) public onlyOwner returns (bool) {
714       _release(lockee, value);
715       return true;
716     }
717 }
718 
719 // File: contracts/PUKAO.sol
720 
721 pragma solidity ^0.5.0;
722 
723 
724 
725 
726 
727 
728 
729 /**
730  * @title PUKAO
731  * @dev For testing now
732  */
733 contract PUKAO is ERC20, ERC20Detailed, ERC20PartialLock, ERC20Mintable, ERC20Burnable {
734     uint8 public constant DECIMALS = 18;
735     uint256 public constant INITIAL_SUPPLY = 1500000000 * (10 ** uint256(DECIMALS));
736 
737     constructor () public ERC20Detailed("PUKAO", "PKO", DECIMALS) {
738         _mint(msg.sender, INITIAL_SUPPLY);
739     }
740 }