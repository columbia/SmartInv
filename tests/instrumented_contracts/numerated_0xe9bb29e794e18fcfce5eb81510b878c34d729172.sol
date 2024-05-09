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
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.2;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
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
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.2;
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
123      * @dev Total number of tokens in existence
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
149      * @dev Transfer token to a specified address
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
217      * @dev Transfer token for a specified addresses
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
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _burn(account, value);
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
288 
289 pragma solidity ^0.5.2;
290 
291 
292 /**
293  * @title ERC20Detailed token
294  * @dev The decimals are only for visualization purposes.
295  * All the operations are done using the smallest and indivisible token unit,
296  * just as on Ethereum all the operations are done in wei.
297  */
298 contract ERC20Detailed is IERC20 {
299     string private _name;
300     string private _symbol;
301     uint8 private _decimals;
302 
303     constructor (string memory name, string memory symbol, uint8 decimals) public {
304         _name = name;
305         _symbol = symbol;
306         _decimals = decimals;
307     }
308 
309     /**
310      * @return the name of the token.
311      */
312     function name() public view returns (string memory) {
313         return _name;
314     }
315 
316     /**
317      * @return the symbol of the token.
318      */
319     function symbol() public view returns (string memory) {
320         return _symbol;
321     }
322 
323     /**
324      * @return the number of decimals of the token.
325      */
326     function decimals() public view returns (uint8) {
327         return _decimals;
328     }
329 }
330 
331 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
332 
333 pragma solidity ^0.5.2;
334 
335 
336 /**
337  * @title Burnable Token
338  * @dev Token that can be irreversibly burned (destroyed).
339  */
340 contract ERC20Burnable is ERC20 {
341     /**
342      * @dev Burns a specific amount of tokens.
343      * @param value The amount of token to be burned.
344      */
345     function burn(uint256 value) public {
346         _burn(msg.sender, value);
347     }
348 
349     /**
350      * @dev Burns a specific amount of tokens from the target address and decrements allowance
351      * @param from address The account whose tokens will be burned.
352      * @param value uint256 The amount of token to be burned.
353      */
354     function burnFrom(address from, uint256 value) public {
355         _burnFrom(from, value);
356     }
357 }
358 
359 // File: openzeppelin-solidity/contracts/access/Roles.sol
360 
361 pragma solidity ^0.5.2;
362 
363 /**
364  * @title Roles
365  * @dev Library for managing addresses assigned to a Role.
366  */
367 library Roles {
368     struct Role {
369         mapping (address => bool) bearer;
370     }
371 
372     /**
373      * @dev give an account access to this role
374      */
375     function add(Role storage role, address account) internal {
376         require(account != address(0));
377         require(!has(role, account));
378 
379         role.bearer[account] = true;
380     }
381 
382     /**
383      * @dev remove an account's access to this role
384      */
385     function remove(Role storage role, address account) internal {
386         require(account != address(0));
387         require(has(role, account));
388 
389         role.bearer[account] = false;
390     }
391 
392     /**
393      * @dev check if an account has this role
394      * @return bool
395      */
396     function has(Role storage role, address account) internal view returns (bool) {
397         require(account != address(0));
398         return role.bearer[account];
399     }
400 }
401 
402 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
403 
404 pragma solidity ^0.5.2;
405 
406 
407 contract MinterRole {
408     using Roles for Roles.Role;
409 
410     event MinterAdded(address indexed account);
411     event MinterRemoved(address indexed account);
412 
413     Roles.Role private _minters;
414 
415     constructor () internal {
416         _addMinter(msg.sender);
417     }
418 
419     modifier onlyMinter() {
420         require(isMinter(msg.sender));
421         _;
422     }
423 
424     function isMinter(address account) public view returns (bool) {
425         return _minters.has(account);
426     }
427 
428     function addMinter(address account) public onlyMinter {
429         _addMinter(account);
430     }
431 
432     function renounceMinter() public {
433         _removeMinter(msg.sender);
434     }
435 
436     function _addMinter(address account) internal {
437         _minters.add(account);
438         emit MinterAdded(account);
439     }
440 
441     function _removeMinter(address account) internal {
442         _minters.remove(account);
443         emit MinterRemoved(account);
444     }
445 }
446 
447 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
448 
449 pragma solidity ^0.5.2;
450 
451 
452 
453 /**
454  * @title ERC20Mintable
455  * @dev ERC20 minting logic
456  */
457 contract ERC20Mintable is ERC20, MinterRole {
458     /**
459      * @dev Function to mint tokens
460      * @param to The address that will receive the minted tokens.
461      * @param value The amount of tokens to mint.
462      * @return A boolean that indicates if the operation was successful.
463      */
464     function mint(address to, uint256 value) public onlyMinter returns (bool) {
465         _mint(to, value);
466         return true;
467     }
468 }
469 
470 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
471 
472 pragma solidity ^0.5.2;
473 
474 
475 contract PauserRole {
476     using Roles for Roles.Role;
477 
478     event PauserAdded(address indexed account);
479     event PauserRemoved(address indexed account);
480 
481     Roles.Role private _pausers;
482 
483     constructor () internal {
484         _addPauser(msg.sender);
485     }
486 
487     modifier onlyPauser() {
488         require(isPauser(msg.sender));
489         _;
490     }
491 
492     function isPauser(address account) public view returns (bool) {
493         return _pausers.has(account);
494     }
495 
496     function addPauser(address account) public onlyPauser {
497         _addPauser(account);
498     }
499 
500     function renouncePauser() public {
501         _removePauser(msg.sender);
502     }
503 
504     function _addPauser(address account) internal {
505         _pausers.add(account);
506         emit PauserAdded(account);
507     }
508 
509     function _removePauser(address account) internal {
510         _pausers.remove(account);
511         emit PauserRemoved(account);
512     }
513 }
514 
515 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
516 
517 pragma solidity ^0.5.2;
518 
519 
520 /**
521  * @title Pausable
522  * @dev Base contract which allows children to implement an emergency stop mechanism.
523  */
524 contract Pausable is PauserRole {
525     event Paused(address account);
526     event Unpaused(address account);
527 
528     bool private _paused;
529 
530     constructor () internal {
531         _paused = false;
532     }
533 
534     /**
535      * @return true if the contract is paused, false otherwise.
536      */
537     function paused() public view returns (bool) {
538         return _paused;
539     }
540 
541     /**
542      * @dev Modifier to make a function callable only when the contract is not paused.
543      */
544     modifier whenNotPaused() {
545         require(!_paused);
546         _;
547     }
548 
549     /**
550      * @dev Modifier to make a function callable only when the contract is paused.
551      */
552     modifier whenPaused() {
553         require(_paused);
554         _;
555     }
556 
557     /**
558      * @dev called by the owner to pause, triggers stopped state
559      */
560     function pause() public onlyPauser whenNotPaused {
561         _paused = true;
562         emit Paused(msg.sender);
563     }
564 
565     /**
566      * @dev called by the owner to unpause, returns to normal state
567      */
568     function unpause() public onlyPauser whenPaused {
569         _paused = false;
570         emit Unpaused(msg.sender);
571     }
572 }
573 
574 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
575 
576 pragma solidity ^0.5.2;
577 
578 
579 
580 /**
581  * @title Pausable token
582  * @dev ERC20 modified with pausable transfers.
583  */
584 contract ERC20Pausable is ERC20, Pausable {
585     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
586         return super.transfer(to, value);
587     }
588 
589     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
590         return super.transferFrom(from, to, value);
591     }
592 
593     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
594         return super.approve(spender, value);
595     }
596 
597     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
598         return super.increaseAllowance(spender, addedValue);
599     }
600 
601     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
602         return super.decreaseAllowance(spender, subtractedValue);
603     }
604 }
605 
606 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
607 
608 pragma solidity ^0.5.2;
609 
610 /**
611  * @title Ownable
612  * @dev The Ownable contract has an owner address, and provides basic authorization control
613  * functions, this simplifies the implementation of "user permissions".
614  */
615 contract Ownable {
616     address private _owner;
617 
618     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
619 
620     /**
621      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
622      * account.
623      */
624     constructor () internal {
625         _owner = msg.sender;
626         emit OwnershipTransferred(address(0), _owner);
627     }
628 
629     /**
630      * @return the address of the owner.
631      */
632     function owner() public view returns (address) {
633         return _owner;
634     }
635 
636     /**
637      * @dev Throws if called by any account other than the owner.
638      */
639     modifier onlyOwner() {
640         require(isOwner());
641         _;
642     }
643 
644     /**
645      * @return true if `msg.sender` is the owner of the contract.
646      */
647     function isOwner() public view returns (bool) {
648         return msg.sender == _owner;
649     }
650 
651     /**
652      * @dev Allows the current owner to relinquish control of the contract.
653      * It will not be possible to call the functions with the `onlyOwner`
654      * modifier anymore.
655      * @notice Renouncing ownership will leave the contract without an owner,
656      * thereby removing any functionality that is only available to the owner.
657      */
658     function renounceOwnership() public onlyOwner {
659         emit OwnershipTransferred(_owner, address(0));
660         _owner = address(0);
661     }
662 
663     /**
664      * @dev Allows the current owner to transfer control of the contract to a newOwner.
665      * @param newOwner The address to transfer ownership to.
666      */
667     function transferOwnership(address newOwner) public onlyOwner {
668         _transferOwnership(newOwner);
669     }
670 
671     /**
672      * @dev Transfers control of the contract to a newOwner.
673      * @param newOwner The address to transfer ownership to.
674      */
675     function _transferOwnership(address newOwner) internal {
676         require(newOwner != address(0));
677         emit OwnershipTransferred(_owner, newOwner);
678         _owner = newOwner;
679     }
680 }
681 
682 // File: contracts/Token.sol
683 
684 pragma solidity >=0.4.21 <0.6.0;
685 
686 
687 
688 
689 
690 
691 
692 contract Token is ERC20, ERC20Detailed, ERC20Burnable, ERC20Mintable, ERC20Pausable, Ownable {
693 
694     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply)
695 
696     ERC20Detailed(name, symbol, decimals)
697 
698     public {
699         _mint(owner(), totalSupply * (10 ** uint(decimals)));
700     }
701 }