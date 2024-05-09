1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
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
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
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
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 pragma solidity ^0.5.2;
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://eips.ethereum.org/EIPS/eip-20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
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
442 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
443 
444 pragma solidity ^0.5.2;
445 
446 
447 contract PauserRole {
448     using Roles for Roles.Role;
449 
450     event PauserAdded(address indexed account);
451     event PauserRemoved(address indexed account);
452 
453     Roles.Role private _pausers;
454 
455     constructor () internal {
456         _addPauser(msg.sender);
457     }
458 
459     modifier onlyPauser() {
460         require(isPauser(msg.sender));
461         _;
462     }
463 
464     function isPauser(address account) public view returns (bool) {
465         return _pausers.has(account);
466     }
467 
468     function addPauser(address account) public onlyPauser {
469         _addPauser(account);
470     }
471 
472     function renouncePauser() public {
473         _removePauser(msg.sender);
474     }
475 
476     function _addPauser(address account) internal {
477         _pausers.add(account);
478         emit PauserAdded(account);
479     }
480 
481     function _removePauser(address account) internal {
482         _pausers.remove(account);
483         emit PauserRemoved(account);
484     }
485 }
486 
487 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
488 
489 pragma solidity ^0.5.2;
490 
491 
492 /**
493  * @title Pausable
494  * @dev Base contract which allows children to implement an emergency stop mechanism.
495  */
496 contract Pausable is PauserRole {
497     event Paused(address account);
498     event Unpaused(address account);
499 
500     bool private _paused;
501 
502     constructor () internal {
503         _paused = false;
504     }
505 
506     /**
507      * @return true if the contract is paused, false otherwise.
508      */
509     function paused() public view returns (bool) {
510         return _paused;
511     }
512 
513     /**
514      * @dev Modifier to make a function callable only when the contract is not paused.
515      */
516     modifier whenNotPaused() {
517         require(!_paused);
518         _;
519     }
520 
521     /**
522      * @dev Modifier to make a function callable only when the contract is paused.
523      */
524     modifier whenPaused() {
525         require(_paused);
526         _;
527     }
528 
529     /**
530      * @dev called by the owner to pause, triggers stopped state
531      */
532     function pause() public onlyPauser whenNotPaused {
533         _paused = true;
534         emit Paused(msg.sender);
535     }
536 
537     /**
538      * @dev called by the owner to unpause, returns to normal state
539      */
540     function unpause() public onlyPauser whenPaused {
541         _paused = false;
542         emit Unpaused(msg.sender);
543     }
544 }
545 
546 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
547 
548 pragma solidity ^0.5.2;
549 
550 
551 
552 /**
553  * @title Pausable token
554  * @dev ERC20 modified with pausable transfers.
555  */
556 contract ERC20Pausable is ERC20, Pausable {
557     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
558         return super.transfer(to, value);
559     }
560 
561     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
562         return super.transferFrom(from, to, value);
563     }
564 
565     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
566         return super.approve(spender, value);
567     }
568 
569     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
570         return super.increaseAllowance(spender, addedValue);
571     }
572 
573     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
574         return super.decreaseAllowance(spender, subtractedValue);
575     }
576 }
577 
578 // File: contracts/Donut.sol
579 
580 pragma solidity 0.5.6;
581 
582 
583 
584 
585 
586 
587 contract Donut is ERC20, ERC20Detailed, ERC20Mintable, ERC20Pausable {
588   using SafeMath for uint256;
589 
590   mapping (address => bool) _usedWithdrawalNonces;
591 
592   event Deposit(
593       address from,
594       address depositId,
595       uint256 value);
596 
597   event Withdraw(
598       address to,
599       uint256 value);
600 
601   constructor()
602       ERC20Mintable()
603       ERC20Pausable()
604       ERC20Detailed('Donut', 'DONUT', 18)
605       ERC20()
606       public {}
607 
608   function deposit(
609       address depositId,
610       uint256 value)
611       public
612       whenNotPaused
613       returns (bool) {
614     // Require deposits to be in whole number amounts.
615     require(value.mod(1e18) == 0);
616     _burn(msg.sender, value);
617     emit Deposit(msg.sender, depositId, value);
618     return true;
619   }
620 
621   function depositFrom(
622       address depositId,
623       address from,
624       uint256 value)
625       public
626       whenNotPaused
627       returns (bool) {
628     // Require deposits to be in whole number amounts.
629     require(value.mod(1e18) == 0);
630     _burnFrom(from, value);
631     emit Deposit(from, depositId, value);
632     return true;
633   }
634 
635   function withdraw(
636       uint8 v,
637       bytes32 r,
638       bytes32 s,
639       address nonce,
640       uint256 value)
641       public
642       whenNotPaused
643       returns (bool) {
644     return withdrawTo(v, r, s, nonce, msg.sender, value);
645   }
646 
647   function withdrawTo(
648       uint8 v,
649       bytes32 r,
650       bytes32 s,
651       address nonce,
652       address to,
653       uint256 value)
654       public
655       whenNotPaused
656       returns (bool) {
657     require(!_usedWithdrawalNonces[nonce]);
658     _usedWithdrawalNonces[nonce] = true;
659     bytes32 message = getWithdrawalMessage(nonce, value);
660     address signer = ecrecover(message, v, r, s);
661     require(signer != address(0));
662     require(isMinter(signer));
663     _mint(to, value);
664     emit Withdraw(to, value);
665     return true;
666   }
667 
668   function getWithdrawalMessage(
669       address nonce,
670       uint256 value)
671       public
672       pure
673       returns (bytes32) {
674     bytes memory prefix = '\x1aPillsbury Signed Message:\n';
675     return keccak256(abi.encodePacked(prefix, nonce, value));
676   }
677 }