1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      * @notice Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
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
75 
76 /**
77  * @title Roles
78  * @dev Library for managing addresses assigned to a Role.
79  */
80 library Roles {
81     struct Role {
82         mapping (address => bool) bearer;
83     }
84 
85     /**
86      * @dev give an account access to this role
87      */
88     function add(Role storage role, address account) internal {
89         require(account != address(0));
90         require(!has(role, account));
91 
92         role.bearer[account] = true;
93     }
94 
95     /**
96      * @dev remove an account's access to this role
97      */
98     function remove(Role storage role, address account) internal {
99         require(account != address(0));
100         require(has(role, account));
101 
102         role.bearer[account] = false;
103     }
104 
105     /**
106      * @dev check if an account has this role
107      * @return bool
108      */
109     function has(Role storage role, address account) internal view returns (bool) {
110         require(account != address(0));
111         return role.bearer[account];
112     }
113 }
114 
115 
116 contract MinterRole {
117     using Roles for Roles.Role;
118 
119     event MinterAdded(address indexed account);
120     event MinterRemoved(address indexed account);
121 
122     Roles.Role private _minters;
123 
124     constructor () internal {
125         _addMinter(msg.sender);
126     }
127 
128     modifier onlyMinter() {
129         require(isMinter(msg.sender));
130         _;
131     }
132 
133     function isMinter(address account) public view returns (bool) {
134         return _minters.has(account);
135     }
136 
137     function addMinter(address account) public onlyMinter {
138         _addMinter(account);
139     }
140 
141     function renounceMinter() public {
142         _removeMinter(msg.sender);
143     }
144 
145     function _addMinter(address account) internal {
146         _minters.add(account);
147         emit MinterAdded(account);
148     }
149 
150     function _removeMinter(address account) internal {
151         _minters.remove(account);
152         emit MinterRemoved(account);
153     }
154 }
155 
156 
157 contract PauserRole {
158     using Roles for Roles.Role;
159 
160     event PauserAdded(address indexed account);
161     event PauserRemoved(address indexed account);
162 
163     Roles.Role private _pausers;
164 
165     constructor () internal {
166         _addPauser(msg.sender);
167     }
168 
169     modifier onlyPauser() {
170         require(isPauser(msg.sender));
171         _;
172     }
173 
174     function isPauser(address account) public view returns (bool) {
175         return _pausers.has(account);
176     }
177 
178     function addPauser(address account) public onlyPauser {
179         _addPauser(account);
180     }
181 
182     function renouncePauser() public {
183         _removePauser(msg.sender);
184     }
185 
186     function _addPauser(address account) internal {
187         _pausers.add(account);
188         emit PauserAdded(account);
189     }
190 
191     function _removePauser(address account) internal {
192         _pausers.remove(account);
193         emit PauserRemoved(account);
194     }
195 }
196 
197 
198 /**
199  * @title Pausable
200  * @dev Base contract which allows children to implement an emergency stop mechanism.
201  */
202 contract Pausable is PauserRole {
203     event Paused(address account);
204     event Unpaused(address account);
205 
206     bool private _paused;
207 
208     constructor () internal {
209         _paused = false;
210     }
211 
212     /**
213      * @return true if the contract is paused, false otherwise.
214      */
215     function paused() public view returns (bool) {
216         return _paused;
217     }
218 
219     /**
220      * @dev Modifier to make a function callable only when the contract is not paused.
221      */
222     modifier whenNotPaused() {
223         require(!_paused);
224         _;
225     }
226 
227     /**
228      * @dev Modifier to make a function callable only when the contract is paused.
229      */
230     modifier whenPaused() {
231         require(_paused);
232         _;
233     }
234 
235     /**
236      * @dev called by the owner to pause, triggers stopped state
237      */
238     function pause() public onlyPauser whenNotPaused {
239         _paused = true;
240         emit Paused(msg.sender);
241     }
242 
243     /**
244      * @dev called by the owner to unpause, returns to normal state
245      */
246     function unpause() public onlyPauser whenPaused {
247         _paused = false;
248         emit Unpaused(msg.sender);
249     }
250 }
251 
252 
253 /**
254  * @title SafeMath
255  * @dev Unsigned math operations with safety checks that revert on error
256  */
257 library SafeMath {
258     /**
259      * @dev Multiplies two unsigned integers, reverts on overflow.
260      */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263         // benefit is lost if 'b' is also tested.
264         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
265         if (a == 0) {
266             return 0;
267         }
268 
269         uint256 c = a * b;
270         require(c / a == b);
271 
272         return c;
273     }
274 
275     /**
276      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
277      */
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         // Solidity only automatically asserts when dividing by 0
280         require(b > 0);
281         uint256 c = a / b;
282         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283 
284         return c;
285     }
286 
287     /**
288      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
289      */
290     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291         require(b <= a);
292         uint256 c = a - b;
293 
294         return c;
295     }
296 
297     /**
298      * @dev Adds two unsigned integers, reverts on overflow.
299      */
300     function add(uint256 a, uint256 b) internal pure returns (uint256) {
301         uint256 c = a + b;
302         require(c >= a);
303 
304         return c;
305     }
306 
307     /**
308      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
309      * reverts when dividing by zero.
310      */
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         require(b != 0);
313         return a % b;
314     }
315 }
316 
317 
318 /**
319  * @title ERC20 interface
320  * @dev see https://eips.ethereum.org/EIPS/eip-20
321  */
322 interface IERC20 {
323     function transfer(address to, uint256 value) external returns (bool);
324 
325     function approve(address spender, uint256 value) external returns (bool);
326 
327     function transferFrom(address from, address to, uint256 value) external returns (bool);
328 
329     function totalSupply() external view returns (uint256);
330 
331     function balanceOf(address who) external view returns (uint256);
332 
333     function allowance(address owner, address spender) external view returns (uint256);
334 
335     event Transfer(address indexed from, address indexed to, uint256 value);
336 
337     event Approval(address indexed owner, address indexed spender, uint256 value);
338 }
339 
340 
341 /**
342  * @title Standard ERC20 token
343  *
344  * @dev Implementation of the basic standard token.
345  * https://eips.ethereum.org/EIPS/eip-20
346  * Originally based on code by FirstBlood:
347  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
348  *
349  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
350  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
351  * compliant implementations may not do it.
352  */
353 contract ERC20 is IERC20 {
354     using SafeMath for uint256;
355 
356     mapping (address => uint256) private _balances;
357 
358     mapping (address => mapping (address => uint256)) private _allowed;
359 
360     uint256 private _totalSupply;
361 
362     // map for lock
363     mapping (address => uint) public lockedAccount;
364     
365     // event for lock
366     event Lock(address target, uint amount);
367     event UnLock(address target, uint amount);
368 
369     /**
370      * @dev Total number of tokens in existence
371      */
372     function totalSupply() public view returns (uint256) {
373         return _totalSupply;
374     }
375 
376     /**
377      * @dev Gets the balance of the specified address.
378      * @param owner The address to query the balance of.
379      * @return A uint256 representing the amount owned by the passed address.
380      */
381     function balanceOf(address owner) public view returns (uint256) {
382         return _balances[owner];
383     }
384 
385     /**
386      * @dev Function to check the amount of tokens that an owner allowed to a spender.
387      * @param owner address The address which owns the funds.
388      * @param spender address The address which will spend the funds.
389      * @return A uint256 specifying the amount of tokens still available for the spender.
390      */
391     function allowance(address owner, address spender) public view returns (uint256) {
392         return _allowed[owner][spender];
393     }
394 
395     /**
396      * @dev Transfer token to a specified address
397      * @param to The address to transfer to.
398      * @param value The amount to be transferred.
399      */
400     function transfer(address to, uint256 value) public returns (bool) {
401         _transfer(msg.sender, to, value);
402         return true;
403     }
404 
405     /**
406      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
407      * Beware that changing an allowance with this method brings the risk that someone may use both the old
408      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
409      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
410      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
411      * @param spender The address which will spend the funds.
412      * @param value The amount of tokens to be spent.
413      */
414     function approve(address spender, uint256 value) public returns (bool) {
415         _approve(msg.sender, spender, value);
416         return true;
417     }
418 
419     /**
420      * @dev Transfer tokens from one address to another.
421      * Note that while this function emits an Approval event, this is not required as per the specification,
422      * and other compliant implementations may not emit the event.
423      * @param from address The address which you want to send tokens from
424      * @param to address The address which you want to transfer to
425      * @param value uint256 the amount of tokens to be transferred
426      */
427     function transferFrom(address from, address to, uint256 value) public returns (bool) {
428         _transfer(from, to, value);
429         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
430         return true;
431     }
432 
433     /**
434      * @dev Increase the amount of tokens that an owner allowed to a spender.
435      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
436      * allowed value is better to use this function to avoid 2 calls (and wait until
437      * the first transaction is mined)
438      * From MonolithDAO Token.sol
439      * Emits an Approval event.
440      * @param spender The address which will spend the funds.
441      * @param addedValue The amount of tokens to increase the allowance by.
442      */
443     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
444         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
445         return true;
446     }
447 
448     /**
449      * @dev Decrease the amount of tokens that an owner allowed to a spender.
450      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
451      * allowed value is better to use this function to avoid 2 calls (and wait until
452      * the first transaction is mined)
453      * From MonolithDAO Token.sol
454      * Emits an Approval event.
455      * @param spender The address which will spend the funds.
456      * @param subtractedValue The amount of tokens to decrease the allowance by.
457      */
458     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
459         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
460         return true;
461     }
462 
463     /**
464      * @dev Function to lock tokens of address
465      * @param amount The amount of tokens that is locked.
466      */
467     function lockAccount(uint amount) public returns (bool) {
468         _lockAccount(msg.sender, amount);
469         return true;
470     }
471 
472     /**
473      * @dev Function to unlock tokens of address
474      * @param amount The amount of tokens that is unlocked.
475      */
476     function unLockAccount(uint amount) public returns (bool) {
477         _unLockAccount(msg.sender, amount);
478         return true;
479     }
480 
481     /**
482      * @dev Transfer token for a specified addresses
483      * @param from The address to transfer from.
484      * @param to The address to transfer to.
485      * @param value The amount to be transferred.
486      */
487     function _transfer(address from, address to, uint256 value) internal {
488         require(to != address(0));
489 
490         _balances[from] = _balances[from].sub(value);
491         _balances[to] = _balances[to].add(value);
492         emit Transfer(from, to, value);
493     }
494 
495     /**
496      * @dev Internal function that mints an amount of the token and assigns it to
497      * an account. This encapsulates the modification of balances such that the
498      * proper events are emitted.
499      * @param account The account that will receive the created tokens.
500      * @param value The amount that will be created.
501      */
502     function _mint(address account, uint256 value) internal {
503         require(account != address(0));
504 
505         _totalSupply = _totalSupply.add(value);
506         _balances[account] = _balances[account].add(value);
507         emit Transfer(address(0), account, value);
508     }
509 
510     /**
511      * @dev Internal function that burns an amount of the token of a given
512      * account.
513      * @param account The account whose tokens will be burnt.
514      * @param value The amount that will be burnt.
515      */
516     function _burn(address account, uint256 value) internal {
517         require(account != address(0));
518 
519         _totalSupply = _totalSupply.sub(value);
520         _balances[account] = _balances[account].sub(value);
521         emit Transfer(account, address(0), value);
522     }
523 
524     /**
525      * @dev Approve an address to spend another addresses' tokens.
526      * @param owner The address that owns the tokens.
527      * @param spender The address that will spend the tokens.
528      * @param value The number of tokens that can be spent.
529      */
530     function _approve(address owner, address spender, uint256 value) internal {
531         require(spender != address(0));
532         require(owner != address(0));
533 
534         _allowed[owner][spender] = value;
535         emit Approval(owner, spender, value);
536     }
537 
538     /**
539      * @dev Internal function that burns an amount of the token of a given
540      * account, deducting from the sender's allowance for said account. Uses the
541      * internal burn function.
542      * Emits an Approval event (reflecting the reduced allowance).
543      * @param account The account whose tokens will be burnt.
544      * @param value The amount that will be burnt.
545      */
546     function _burnFrom(address account, uint256 value) internal {
547         _burn(account, value);
548         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
549     }
550     
551     /**
552      * @dev Function to lock tokens of address
553      * @param amount The amount of tokens that is locked.
554      */
555     function _lockAccount(address account, uint amount) public returns (bool) {
556         require(account != address(0));
557         require(_balances[account] >= amount);
558         _balances[account] = _balances[account].sub(amount);
559         lockedAccount[account] = lockedAccount[account].add(amount);
560         emit Lock(account, lockedAccount[account]);
561 
562         return true;
563     }
564 
565     /**
566      * @dev Function to unlock tokens of address
567      * @param amount The amount of tokens that is unlocked.
568      */
569     function _unLockAccount(address account, uint amount) public returns (bool) {
570         require(account != address(0));
571         require(lockedAccount[account] >= amount);
572         lockedAccount[account] = lockedAccount[account].sub(amount);
573         _balances[account] = _balances[account].add(amount);
574         emit UnLock(account, lockedAccount[account]);
575         
576         return true;
577     }
578 }
579 
580 
581 /**
582  * @title Burnable Token
583  * @dev Token that can be irreversibly burned (destroyed).
584  */
585 contract ERC20Burnable is ERC20 {
586     /**
587      * @dev Burns a specific amount of tokens.
588      * @param value The amount of token to be burned.
589      */
590     function burn(uint256 value) public {
591         _burn(msg.sender, value);
592     }
593 
594     /**
595      * @dev Burns a specific amount of tokens from the target address and decrements allowance
596      * @param from address The account whose tokens will be burned.
597      * @param value uint256 The amount of token to be burned.
598      */
599     function burnFrom(address from, uint256 value) public {
600         _burnFrom(from, value);
601     }
602 }
603 
604 
605 /**
606  * @title ERC20Mintable
607  * @dev ERC20 minting logic
608  */
609 contract ERC20Mintable is ERC20, MinterRole {
610     /**
611      * @dev Function to mint tokens
612      * @param to The address that will receive the minted tokens.
613      * @param value The amount of tokens to mint.
614      * @return A boolean that indicates if the operation was successful.
615      */
616     function mint(address to, uint256 value) public onlyMinter returns (bool) {
617         _mint(to, value);
618         return true;
619     }
620 }
621 
622 
623 /**
624  * @title Pausable token
625  * @dev ERC20 modified with pausable transfers.
626  */
627 contract ERC20Pausable is ERC20, Pausable {
628     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
629         return super.transfer(to, value);
630     }
631 
632     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
633         return super.transferFrom(from, to, value);
634     }
635 
636     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
637         return super.approve(spender, value);
638     }
639 
640     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
641         return super.increaseAllowance(spender, addedValue);
642     }
643 
644     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
645         return super.decreaseAllowance(spender, subtractedValue);
646     }
647 }
648 
649 
650 /**
651  * @title UXB token
652  *
653  * @dev Implementation of the UXB token 
654  */
655 contract UXBToken is Ownable, ERC20Burnable, ERC20Mintable, ERC20Pausable {
656 
657     string public name = "UXB Token";
658     string public symbol = "UXB";
659     uint8 public decimals = 18;
660     uint public INITIAL_SUPPLY = 2000000000000000000000000000;
661 
662     // map for freeze
663     mapping (address => bool) public frozenAccount;
664 
665     // event for freeze
666     event Freeze(address target);
667     event UnFreeze(address target);
668 
669     /**
670      * @dev constructor for UXBToken
671      */
672     constructor() public {
673         _mint(msg.sender, INITIAL_SUPPLY);
674     }
675 
676     /**
677      * @dev fallback function ***DO NOT OVERRIDE***
678      */
679     function () external payable {
680         revert();
681     }
682 
683     /**
684      * @dev Function to freeze address
685      * @param _target The address that will be freezed.
686      */
687     function freezeAccount(address _target) onlyOwner public {
688         require(_target != address(0));
689         require(frozenAccount[_target] != true);
690         frozenAccount[_target] = true;
691         emit Freeze(_target);
692     }
693 
694     /**
695      * @dev Function to unfreeze address
696      * @param _target The address that will be unfreezed.
697      */
698     function unFreezeAccount(address _target) onlyOwner public {
699         require(_target != address(0));
700         require(frozenAccount[_target] != false);
701         frozenAccount[_target] = false;
702         emit UnFreeze(_target);
703     }
704 
705     /**
706      * @dev Transfer token for a specified address
707      * @param _to The address to transfer to.
708      * @param _value The amount to be transferred.
709      */
710     function transfer(address _to, uint256 _value) public returns (bool) {
711         require(!frozenAccount[msg.sender]);        // Check if sender is frozen
712         require(!frozenAccount[_to]);               // Check if recipient is frozen
713         return super.transfer(_to,_value);
714     }
715 
716     /**
717      * @dev Transfer tokens from one address to another
718      * @param _from address The address which you want to send tokens from
719      * @param _to address The address which you want to transfer to
720      * @param _value uint256 the amount of tokens to be transferred
721      */
722     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
723         require(!frozenAccount[msg.sender]);        // Check if approved is frozen
724         require(!frozenAccount[_from]);             // Check if sender is frozen
725         require(!frozenAccount[_to]);               // Check if recipient is frozen
726         return super.transferFrom(_from, _to, _value);
727     }
728 }