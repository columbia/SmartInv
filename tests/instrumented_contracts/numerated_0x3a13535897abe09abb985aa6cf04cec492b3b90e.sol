1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
26 
27 pragma solidity ^0.5.2;
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53      */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Adds two unsigned integers, reverts on overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85      * reverts when dividing by zero.
86      */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
94 
95 pragma solidity ^0.5.2;
96 
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * https://eips.ethereum.org/EIPS/eip-20
104  * Originally based on code by FirstBlood:
105  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  *
107  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
108  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
109  * compliant implementations may not do it.
110  */
111 contract ERC20 is IERC20 {
112     using SafeMath for uint256;
113 
114     mapping (address => uint256) private _balances;
115 
116     mapping (address => mapping (address => uint256)) private _allowed;
117 
118     uint256 private _totalSupply;
119 
120     /**
121      * @dev Total number of tokens in existence
122      */
123     function totalSupply() public view returns (uint256) {
124         return _totalSupply;
125     }
126 
127     /**
128      * @dev Gets the balance of the specified address.
129      * @param owner The address to query the balance of.
130      * @return A uint256 representing the amount owned by the passed address.
131      */
132     function balanceOf(address owner) public view returns (uint256) {
133         return _balances[owner];
134     }
135 
136     /**
137      * @dev Function to check the amount of tokens that an owner allowed to a spender.
138      * @param owner address The address which owns the funds.
139      * @param spender address The address which will spend the funds.
140      * @return A uint256 specifying the amount of tokens still available for the spender.
141      */
142     function allowance(address owner, address spender) public view returns (uint256) {
143         return _allowed[owner][spender];
144     }
145 
146     /**
147      * @dev Transfer token to a specified address
148      * @param to The address to transfer to.
149      * @param value The amount to be transferred.
150      */
151     function transfer(address to, uint256 value) public returns (bool) {
152         _transfer(msg.sender, to, value);
153         return true;
154     }
155 
156     /**
157      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158      * Beware that changing an allowance with this method brings the risk that someone may use both the old
159      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      * @param spender The address which will spend the funds.
163      * @param value The amount of tokens to be spent.
164      */
165     function approve(address spender, uint256 value) public returns (bool) {
166         _approve(msg.sender, spender, value);
167         return true;
168     }
169 
170     /**
171      * @dev Transfer tokens from one address to another.
172      * Note that while this function emits an Approval event, this is not required as per the specification,
173      * and other compliant implementations may not emit the event.
174      * @param from address The address which you want to send tokens from
175      * @param to address The address which you want to transfer to
176      * @param value uint256 the amount of tokens to be transferred
177      */
178     function transferFrom(address from, address to, uint256 value) public returns (bool) {
179         _transfer(from, to, value);
180         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
196         return true;
197     }
198 
199     /**
200      * @dev Decrease the amount of tokens that an owner allowed to a spender.
201      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * Emits an Approval event.
206      * @param spender The address which will spend the funds.
207      * @param subtractedValue The amount of tokens to decrease the allowance by.
208      */
209     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
210         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
211         return true;
212     }
213 
214     /**
215      * @dev Transfer token for a specified addresses
216      * @param from The address to transfer from.
217      * @param to The address to transfer to.
218      * @param value The amount to be transferred.
219      */
220     function _transfer(address from, address to, uint256 value) internal {
221         require(to != address(0));
222 
223         _balances[from] = _balances[from].sub(value);
224         _balances[to] = _balances[to].add(value);
225         emit Transfer(from, to, value);
226     }
227 
228     /**
229      * @dev Internal function that mints an amount of the token and assigns it to
230      * an account. This encapsulates the modification of balances such that the
231      * proper events are emitted.
232      * @param account The account that will receive the created tokens.
233      * @param value The amount that will be created.
234      */
235     function _mint(address account, uint256 value) internal {
236         require(account != address(0));
237 
238         _totalSupply = _totalSupply.add(value);
239         _balances[account] = _balances[account].add(value);
240         emit Transfer(address(0), account, value);
241     }
242 
243     /**
244      * @dev Internal function that burns an amount of the token of a given
245      * account.
246      * @param account The account whose tokens will be burnt.
247      * @param value The amount that will be burnt.
248      */
249     function _burn(address account, uint256 value) internal {
250         require(account != address(0));
251 
252         _totalSupply = _totalSupply.sub(value);
253         _balances[account] = _balances[account].sub(value);
254         emit Transfer(account, address(0), value);
255     }
256 
257     /**
258      * @dev Approve an address to spend another addresses' tokens.
259      * @param owner The address that owns the tokens.
260      * @param spender The address that will spend the tokens.
261      * @param value The number of tokens that can be spent.
262      */
263     function _approve(address owner, address spender, uint256 value) internal {
264         require(spender != address(0));
265         require(owner != address(0));
266 
267         _allowed[owner][spender] = value;
268         emit Approval(owner, spender, value);
269     }
270 
271     /**
272      * @dev Internal function that burns an amount of the token of a given
273      * account, deducting from the sender's allowance for said account. Uses the
274      * internal burn function.
275      * Emits an Approval event (reflecting the reduced allowance).
276      * @param account The account whose tokens will be burnt.
277      * @param value The amount that will be burnt.
278      */
279     function _burnFrom(address account, uint256 value) internal {
280         _burn(account, value);
281         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
282     }
283 }
284 
285 // File: openzeppelin-solidity/contracts/access/Roles.sol
286 
287 pragma solidity ^0.5.2;
288 
289 /**
290  * @title Roles
291  * @dev Library for managing addresses assigned to a Role.
292  */
293 library Roles {
294     struct Role {
295         mapping (address => bool) bearer;
296     }
297 
298     /**
299      * @dev give an account access to this role
300      */
301     function add(Role storage role, address account) internal {
302         require(account != address(0));
303         require(!has(role, account));
304 
305         role.bearer[account] = true;
306     }
307 
308     /**
309      * @dev remove an account's access to this role
310      */
311     function remove(Role storage role, address account) internal {
312         require(account != address(0));
313         require(has(role, account));
314 
315         role.bearer[account] = false;
316     }
317 
318     /**
319      * @dev check if an account has this role
320      * @return bool
321      */
322     function has(Role storage role, address account) internal view returns (bool) {
323         require(account != address(0));
324         return role.bearer[account];
325     }
326 }
327 
328 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
329 
330 pragma solidity ^0.5.2;
331 
332 
333 contract PauserRole {
334     using Roles for Roles.Role;
335 
336     event PauserAdded(address indexed account);
337     event PauserRemoved(address indexed account);
338 
339     Roles.Role private _pausers;
340 
341     constructor () internal {
342         _addPauser(msg.sender);
343     }
344 
345     modifier onlyPauser() {
346         require(isPauser(msg.sender));
347         _;
348     }
349 
350     function isPauser(address account) public view returns (bool) {
351         return _pausers.has(account);
352     }
353 
354     function addPauser(address account) public onlyPauser {
355         _addPauser(account);
356     }
357 
358     function renouncePauser() public {
359         _removePauser(msg.sender);
360     }
361 
362     function _addPauser(address account) internal {
363         _pausers.add(account);
364         emit PauserAdded(account);
365     }
366 
367     function _removePauser(address account) internal {
368         _pausers.remove(account);
369         emit PauserRemoved(account);
370     }
371 }
372 
373 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
374 
375 pragma solidity ^0.5.2;
376 
377 
378 /**
379  * @title Pausable
380  * @dev Base contract which allows children to implement an emergency stop mechanism.
381  */
382 contract Pausable is PauserRole {
383     event Paused(address account);
384     event Unpaused(address account);
385 
386     bool private _paused;
387 
388     constructor () internal {
389         _paused = false;
390     }
391 
392     /**
393      * @return true if the contract is paused, false otherwise.
394      */
395     function paused() public view returns (bool) {
396         return _paused;
397     }
398 
399     /**
400      * @dev Modifier to make a function callable only when the contract is not paused.
401      */
402     modifier whenNotPaused() {
403         require(!_paused);
404         _;
405     }
406 
407     /**
408      * @dev Modifier to make a function callable only when the contract is paused.
409      */
410     modifier whenPaused() {
411         require(_paused);
412         _;
413     }
414 
415     /**
416      * @dev called by the owner to pause, triggers stopped state
417      */
418     function pause() public onlyPauser whenNotPaused {
419         _paused = true;
420         emit Paused(msg.sender);
421     }
422 
423     /**
424      * @dev called by the owner to unpause, returns to normal state
425      */
426     function unpause() public onlyPauser whenPaused {
427         _paused = false;
428         emit Unpaused(msg.sender);
429     }
430 }
431 
432 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
433 
434 pragma solidity ^0.5.2;
435 
436 
437 
438 /**
439  * @title Pausable token
440  * @dev ERC20 modified with pausable transfers.
441  */
442 contract ERC20Pausable is ERC20, Pausable {
443     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
444         return super.transfer(to, value);
445     }
446 
447     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
448         return super.transferFrom(from, to, value);
449     }
450 
451     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
452         return super.approve(spender, value);
453     }
454 
455     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
456         return super.increaseAllowance(spender, addedValue);
457     }
458 
459     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
460         return super.decreaseAllowance(spender, subtractedValue);
461     }
462 }
463 
464 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
465 
466 pragma solidity ^0.5.2;
467 
468 
469 /**
470  * @title ERC20Detailed token
471  * @dev The decimals are only for visualization purposes.
472  * All the operations are done using the smallest and indivisible token unit,
473  * just as on Ethereum all the operations are done in wei.
474  */
475 contract ERC20Detailed is IERC20 {
476     string private _name;
477     string private _symbol;
478     uint8 private _decimals;
479 
480     constructor (string memory name, string memory symbol, uint8 decimals) public {
481         _name = name;
482         _symbol = symbol;
483         _decimals = decimals;
484     }
485 
486     /**
487      * @return the name of the token.
488      */
489     function name() public view returns (string memory) {
490         return _name;
491     }
492 
493     /**
494      * @return the symbol of the token.
495      */
496     function symbol() public view returns (string memory) {
497         return _symbol;
498     }
499 
500     /**
501      * @return the number of decimals of the token.
502      */
503     function decimals() public view returns (uint8) {
504         return _decimals;
505     }
506 }
507 
508 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
509 
510 pragma solidity ^0.5.2;
511 
512 
513 contract MinterRole {
514     using Roles for Roles.Role;
515 
516     event MinterAdded(address indexed account);
517     event MinterRemoved(address indexed account);
518 
519     Roles.Role private _minters;
520 
521     constructor () internal {
522         _addMinter(msg.sender);
523     }
524 
525     modifier onlyMinter() {
526         require(isMinter(msg.sender));
527         _;
528     }
529 
530     function isMinter(address account) public view returns (bool) {
531         return _minters.has(account);
532     }
533 
534     function addMinter(address account) public onlyMinter {
535         _addMinter(account);
536     }
537 
538     function renounceMinter() public {
539         _removeMinter(msg.sender);
540     }
541 
542     function _addMinter(address account) internal {
543         _minters.add(account);
544         emit MinterAdded(account);
545     }
546 
547     function _removeMinter(address account) internal {
548         _minters.remove(account);
549         emit MinterRemoved(account);
550     }
551 }
552 
553 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
554 
555 pragma solidity ^0.5.2;
556 
557 
558 
559 /**
560  * @title ERC20Mintable
561  * @dev ERC20 minting logic
562  */
563 contract ERC20Mintable is ERC20, MinterRole {
564     /**
565      * @dev Function to mint tokens
566      * @param to The address that will receive the minted tokens.
567      * @param value The amount of tokens to mint.
568      * @return A boolean that indicates if the operation was successful.
569      */
570     function mint(address to, uint256 value) public onlyMinter returns (bool) {
571         _mint(to, value);
572         return true;
573     }
574 }
575 
576 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
577 
578 pragma solidity ^0.5.2;
579 
580 
581 /**
582  * @title Capped token
583  * @dev Mintable token with a token cap.
584  */
585 contract ERC20Capped is ERC20Mintable {
586     uint256 private _cap;
587 
588     constructor (uint256 cap) public {
589         require(cap > 0);
590         _cap = cap;
591     }
592 
593     /**
594      * @return the cap for the token minting.
595      */
596     function cap() public view returns (uint256) {
597         return _cap;
598     }
599 
600     function _mint(address account, uint256 value) internal {
601         require(totalSupply().add(value) <= _cap);
602         super._mint(account, value);
603     }
604 }
605 
606 // File: contracts/BankorusToken.sol
607 
608 pragma solidity ^0.5.2;
609 
610 
611 
612 
613 
614 contract BankorusToken is ERC20Capped, ERC20Pausable, ERC20Detailed {
615     event PausedAddress(address pausedAddress, address acount);
616     event UnpausedAddress(address unpausedAddress, address acount);
617 
618     event ApproveBurnEvent(address owner, address burner, uint256 amount);
619 
620     mapping(address => bool) _pausedAddress;
621 
622     mapping(address => mapping(address => uint256)) _burnApproved;
623 
624     constructor()
625     ERC20Capped(3500000000000000)
626     ERC20Pausable()
627     ERC20Detailed("Bankorus Token", "BKTS", 8)
628     public {}
629 
630     /**
631      * @dev Modifier to make a function callable only when the account is not paused.
632      */
633     modifier whenAddressIsNotPuased(address to) {
634         require(!_pausedAddress[msg.sender]);
635         require(!_pausedAddress[to]);
636         _;
637     }
638 
639     /**
640      * @dev true if the account is paused, false otherwise.
641      */
642     function addressPaused(address account) public view returns (bool) {
643         return _pausedAddress[account];
644     }
645 
646      /**
647      * @dev called by the owner to pause an address, returns to normal state
648      */
649     function pauseAddress(address pausedAddress) public onlyPauser whenNotPaused{
650         _pausedAddress[pausedAddress] = true;
651         emit PausedAddress(pausedAddress, msg.sender);
652     }
653 
654     /**
655      * @dev called by the owner to unpause an address, returns to normal state
656      */
657     function unpauseAddress(address unpausedAddress) public onlyPauser whenNotPaused {
658         _pausedAddress[unpausedAddress] = false;
659         emit UnpausedAddress(unpausedAddress, msg.sender);
660     }
661 
662     function transfer(address to, uint256 value) public whenAddressIsNotPuased(to) returns (bool) {
663         return super.transfer(to, value);
664     }
665 
666     function transferFrom(address from, address to, uint256 value) public whenAddressIsNotPuased(to) returns (bool) {
667         require(!_pausedAddress[from]);
668         return super.transferFrom(from, to, value);
669     }
670 
671     function approve(address spender, uint256 value) public whenAddressIsNotPuased(spender) returns (bool) {
672         return super.approve(spender, value);
673     }
674 
675     function increaseAllowance(address spender, uint addedValue) public whenAddressIsNotPuased(spender) returns (bool) {
676         return super.increaseAllowance(spender, addedValue);
677     }
678 
679     function decreaseAllowance(address spender, uint subtractedValue) public whenAddressIsNotPuased(spender) returns (bool) {
680         return super.decreaseAllowance(spender, subtractedValue);
681     }
682 
683     /**
684      * @dev Destoys `amount` tokens from the caller.
685      *
686      * See `ERC20._burn`.
687      */
688     function burn(uint256 amount) public whenNotPaused {
689         _burn(msg.sender, amount);
690     }
691 
692 
693     /**
694      * @dev allow account to burn `amount` tokens 
695      * Requirements:
696      * - `burner` cannot be zero address
697      * - 
698      */
699     function approveBurn(address burner, uint256 amount) public returns (bool) {
700         require(burner != address(0));
701         require(amount > 0);
702         _burnApproved[msg.sender][burner] = amount;
703     }
704 
705     /**
706      * @dev See `ERC20._burnFrom`.
707      */
708     function burnFrom(address from, uint256 amount) public whenNotPaused {
709         require(from != address(0));
710         require(amount > 0);
711         _burnApproved[from][msg.sender] = _burnApproved[from][msg.sender].sub(amount);
712         _burnFrom(from, amount);
713     }
714 
715     /**
716      * @dev batchMint
717      */
718 
719     function batchMint(address[] memory accounts, uint256[] memory amounts) public whenNotPaused onlyMinter {
720         require(accounts.length == amounts.length);
721         require(accounts.length < 50);
722 
723         for (uint i = 0; i < accounts.length; i++) {
724             mint(accounts[i], amounts[i]);
725         }
726         
727     }
728 }