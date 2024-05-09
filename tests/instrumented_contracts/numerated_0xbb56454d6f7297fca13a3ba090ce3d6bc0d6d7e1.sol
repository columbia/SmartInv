1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35     * @dev Multiplies two unsigned integers, reverts on overflow.
36     */
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
52     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53     */
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
64     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Adds two unsigned integers, reverts on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85     * reverts when dividing by zero.
86     */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
100  * Originally based on code by FirstBlood:
101  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  *
103  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
104  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
105  * compliant implementations may not do it.
106  */
107 contract ERC20 is IERC20 {
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) private _balances;
111 
112     mapping (address => mapping (address => uint256)) private _allowed;
113 
114     uint256 private _totalSupply;
115 
116     /**
117     * @dev Total number of tokens in existence
118     */
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param owner The address to query the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address owner) public view returns (uint256) {
129         return _balances[owner];
130     }
131 
132     /**
133      * @dev Function to check the amount of tokens that an owner allowed to a spender.
134      * @param owner address The address which owns the funds.
135      * @param spender address The address which will spend the funds.
136      * @return A uint256 specifying the amount of tokens still available for the spender.
137      */
138     function allowance(address owner, address spender) public view returns (uint256) {
139         return _allowed[owner][spender];
140     }
141 
142     /**
143     * @dev Transfer token for a specified address
144     * @param to The address to transfer to.
145     * @param value The amount to be transferred.
146     */
147     function transfer(address to, uint256 value) public returns (bool) {
148         _transfer(msg.sender, to, value);
149         return true;
150     }
151 
152     /**
153      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param spender The address which will spend the funds.
159      * @param value The amount of tokens to be spent.
160      */
161     function approve(address spender, uint256 value) public returns (bool) {
162         require(spender != address(0));
163 
164         _allowed[msg.sender][spender] = value;
165         emit Approval(msg.sender, spender, value);
166         return true;
167     }
168 
169     /**
170      * @dev Transfer tokens from one address to another.
171      * Note that while this function emits an Approval event, this is not required as per the specification,
172      * and other compliant implementations may not emit the event.
173      * @param from address The address which you want to send tokens from
174      * @param to address The address which you want to transfer to
175      * @param value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address from, address to, uint256 value) public returns (bool) {
178         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
179         _transfer(from, to, value);
180         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed_[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         require(spender != address(0));
196 
197         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
198         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      * approve should be called when allowed_[_spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
213         require(spender != address(0));
214 
215         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
216         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
217         return true;
218     }
219 
220     /**
221     * @dev Transfer token for a specified addresses
222     * @param from The address to transfer from.
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function _transfer(address from, address to, uint256 value) internal {
227         require(to != address(0));
228 
229         _balances[from] = _balances[from].sub(value);
230         _balances[to] = _balances[to].add(value);
231         emit Transfer(from, to, value);
232     }
233 
234     /**
235      * @dev Internal function that mints an amount of the token and assigns it to
236      * an account. This encapsulates the modification of balances such that the
237      * proper events are emitted.
238      * @param account The account that will receive the created tokens.
239      * @param value The amount that will be created.
240      */
241     function _mint(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.add(value);
245         _balances[account] = _balances[account].add(value);
246         emit Transfer(address(0), account, value);
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account.
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burn(address account, uint256 value) internal {
256         require(account != address(0));
257 
258         _totalSupply = _totalSupply.sub(value);
259         _balances[account] = _balances[account].sub(value);
260         emit Transfer(account, address(0), value);
261     }
262 
263     /**
264      * @dev Internal function that burns an amount of the token of a given
265      * account, deducting from the sender's allowance for said account. Uses the
266      * internal burn function.
267      * Emits an Approval event (reflecting the reduced allowance).
268      * @param account The account whose tokens will be burnt.
269      * @param value The amount that will be burnt.
270      */
271     function _burnFrom(address account, uint256 value) internal {
272         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
273         _burn(account, value);
274         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
275     }
276 }
277 
278 // File: openzeppelin-solidity/contracts/access/Roles.sol
279 
280 /**
281  * @title Roles
282  * @dev Library for managing addresses assigned to a Role.
283  */
284 library Roles {
285     struct Role {
286         mapping (address => bool) bearer;
287     }
288 
289     /**
290      * @dev give an account access to this role
291      */
292     function add(Role storage role, address account) internal {
293         require(account != address(0));
294         require(!has(role, account));
295 
296         role.bearer[account] = true;
297     }
298 
299     /**
300      * @dev remove an account's access to this role
301      */
302     function remove(Role storage role, address account) internal {
303         require(account != address(0));
304         require(has(role, account));
305 
306         role.bearer[account] = false;
307     }
308 
309     /**
310      * @dev check if an account has this role
311      * @return bool
312      */
313     function has(Role storage role, address account) internal view returns (bool) {
314         require(account != address(0));
315         return role.bearer[account];
316     }
317 }
318 
319 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
320 
321 contract MinterRole {
322     using Roles for Roles.Role;
323 
324     event MinterAdded(address indexed account);
325     event MinterRemoved(address indexed account);
326 
327     Roles.Role private _minters;
328 
329     constructor () internal {
330         _addMinter(msg.sender);
331     }
332 
333     modifier onlyMinter() {
334         require(isMinter(msg.sender));
335         _;
336     }
337 
338     function isMinter(address account) public view returns (bool) {
339         return _minters.has(account);
340     }
341 
342     function addMinter(address account) public onlyMinter {
343         _addMinter(account);
344     }
345 
346     function renounceMinter() public {
347         _removeMinter(msg.sender);
348     }
349 
350     function _addMinter(address account) internal {
351         _minters.add(account);
352         emit MinterAdded(account);
353     }
354 
355     function _removeMinter(address account) internal {
356         _minters.remove(account);
357         emit MinterRemoved(account);
358     }
359 }
360 
361 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
362 
363 /**
364  * @title ERC20Mintable
365  * @dev ERC20 minting logic
366  */
367 contract ERC20Mintable is ERC20, MinterRole {
368     /**
369      * @dev Function to mint tokens
370      * @param to The address that will receive the minted tokens.
371      * @param value The amount of tokens to mint.
372      * @return A boolean that indicates if the operation was successful.
373      */
374     function mint(address to, uint256 value) public onlyMinter returns (bool) {
375         _mint(to, value);
376         return true;
377     }
378 }
379 
380 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
381 
382 /**
383  * @title Burnable Token
384  * @dev Token that can be irreversibly burned (destroyed).
385  */
386 contract ERC20Burnable is ERC20 {
387     /**
388      * @dev Burns a specific amount of tokens.
389      * @param value The amount of token to be burned.
390      */
391     function burn(uint256 value) public {
392         _burn(msg.sender, value);
393     }
394 
395     /**
396      * @dev Burns a specific amount of tokens from the target address and decrements allowance
397      * @param from address The address which you want to send tokens from
398      * @param value uint256 The amount of token to be burned
399      */
400     function burnFrom(address from, uint256 value) public {
401         _burnFrom(from, value);
402     }
403 }
404 
405 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
406 
407 /**
408  * @title ERC20Detailed token
409  * @dev The decimals are only for visualization purposes.
410  * All the operations are done using the smallest and indivisible token unit,
411  * just as on Ethereum all the operations are done in wei.
412  */
413 contract ERC20Detailed is IERC20 {
414     string private _name;
415     string private _symbol;
416     uint8 private _decimals;
417 
418     constructor (string memory name, string memory symbol, uint8 decimals) public {
419         _name = name;
420         _symbol = symbol;
421         _decimals = decimals;
422     }
423 
424     /**
425      * @return the name of the token.
426      */
427     function name() public view returns (string memory) {
428         return _name;
429     }
430 
431     /**
432      * @return the symbol of the token.
433      */
434     function symbol() public view returns (string memory) {
435         return _symbol;
436     }
437 
438     /**
439      * @return the number of decimals of the token.
440      */
441     function decimals() public view returns (uint8) {
442         return _decimals;
443     }
444 }
445 
446 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
447 
448 contract PauserRole {
449     using Roles for Roles.Role;
450 
451     event PauserAdded(address indexed account);
452     event PauserRemoved(address indexed account);
453 
454     Roles.Role private _pausers;
455 
456     constructor () internal {
457         _addPauser(msg.sender);
458     }
459 
460     modifier onlyPauser() {
461         require(isPauser(msg.sender));
462         _;
463     }
464 
465     function isPauser(address account) public view returns (bool) {
466         return _pausers.has(account);
467     }
468 
469     function addPauser(address account) public onlyPauser {
470         _addPauser(account);
471     }
472 
473     function renouncePauser() public {
474         _removePauser(msg.sender);
475     }
476 
477     function _addPauser(address account) internal {
478         _pausers.add(account);
479         emit PauserAdded(account);
480     }
481 
482     function _removePauser(address account) internal {
483         _pausers.remove(account);
484         emit PauserRemoved(account);
485     }
486 }
487 
488 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
489 
490 /**
491  * @title Pausable
492  * @dev Base contract which allows children to implement an emergency stop mechanism.
493  */
494 contract Pausable is PauserRole {
495     event Paused(address account);
496     event Unpaused(address account);
497 
498     bool private _paused;
499 
500     constructor () internal {
501         _paused = false;
502     }
503 
504     /**
505      * @return true if the contract is paused, false otherwise.
506      */
507     function paused() public view returns (bool) {
508         return _paused;
509     }
510 
511     /**
512      * @dev Modifier to make a function callable only when the contract is not paused.
513      */
514     modifier whenNotPaused() {
515         require(!_paused);
516         _;
517     }
518 
519     /**
520      * @dev Modifier to make a function callable only when the contract is paused.
521      */
522     modifier whenPaused() {
523         require(_paused);
524         _;
525     }
526 
527     /**
528      * @dev called by the owner to pause, triggers stopped state
529      */
530     function pause() public onlyPauser whenNotPaused {
531         _paused = true;
532         emit Paused(msg.sender);
533     }
534 
535     /**
536      * @dev called by the owner to unpause, returns to normal state
537      */
538     function unpause() public onlyPauser whenPaused {
539         _paused = false;
540         emit Unpaused(msg.sender);
541     }
542 }
543 
544 // File: contracts/BlacklistAdminRole.sol
545 
546 contract BlacklistAdminRole {
547     using Roles for Roles.Role;
548 
549     event BlacklistAdminAdded(address indexed account);
550     event BlacklistAdminRemoved(address indexed account);
551 
552     Roles.Role private _blacklistAdmins;
553 
554     constructor () internal {
555         _addBlacklistAdmin(msg.sender);
556     }
557 
558     modifier onlyBlacklistAdmin() {
559         require(isBlacklistAdmin(msg.sender));
560         _;
561     }
562 
563     function isBlacklistAdmin(address account) public view returns (bool) {
564         return _blacklistAdmins.has(account);
565     }
566 
567     function addBlacklistAdmin(address account) public onlyBlacklistAdmin {
568         _addBlacklistAdmin(account);
569     }
570 
571     function renounceBlacklistAdmin() public {
572         _removeBlacklistAdmin(msg.sender);
573     }
574 
575     function _addBlacklistAdmin(address account) internal {
576         _blacklistAdmins.add(account);
577         emit BlacklistAdminAdded(account);
578     }
579 
580     function _removeBlacklistAdmin(address account) internal {
581         _blacklistAdmins.remove(account);
582         emit BlacklistAdminRemoved(account);
583     }
584 }
585 
586 // File: contracts/BlacklistedRole.sol
587 
588 contract BlacklistedRole is BlacklistAdminRole {
589     using Roles for Roles.Role;
590 
591     event BlacklistedAdded(address indexed account);
592     event BlacklistedRemoved(address indexed account);
593 
594     Roles.Role private _blacklisteds;
595 
596     modifier onlyBlacklisted() {
597         require(isBlacklisted(msg.sender));
598         _;
599     }
600 
601     modifier onlyNotBlacklisted() {
602         require(!isBlacklisted(msg.sender));
603         _;
604     }
605 
606     function isBlacklisted(address account) public view returns (bool) {
607         return _blacklisteds.has(account);
608     }
609 
610     function addBlacklisted(address account) public onlyBlacklistAdmin {
611         _addBlacklisted(account);
612     }
613 
614     function removeBlacklisted(address account) public onlyBlacklistAdmin {
615         _removeBlacklisted(account);
616     }
617 
618     function renounceBlacklisted() public {
619         _removeBlacklisted(msg.sender);
620     }
621 
622     function _addBlacklisted(address account) internal {
623         _blacklisteds.add(account);
624         emit BlacklistedAdded(account);
625     }
626 
627     function _removeBlacklisted(address account) internal {
628         _blacklisteds.remove(account);
629         emit BlacklistedRemoved(account);
630     }
631 }
632 
633 // File: contracts/GoldTokenPausable.sol
634 
635 /**
636  * @title Pausable token
637  * @dev ERC20 modified with pausable transfers.
638  **/
639 contract GoldTokenPausable is ERC20, Pausable, BlacklistedRole {
640     function transfer(address to, uint256 value) public whenNotPaused onlyNotBlacklisted returns (bool) {
641         return super.transfer(to, value);
642     }
643 
644     function transferFrom(address from, address to, uint256 value) public whenNotPaused onlyNotBlacklisted returns (bool) {
645         return super.transferFrom(from, to, value);
646     }
647 
648     function approve(address spender, uint256 value) public whenNotPaused onlyNotBlacklisted returns (bool) {
649         return super.approve(spender, value);
650     }
651 
652     function increaseAllowance(address spender, uint addedValue) public whenNotPaused onlyNotBlacklisted returns (bool success) {
653         return super.increaseAllowance(spender, addedValue);
654     }
655 
656     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused onlyNotBlacklisted returns (bool success) {
657         return super.decreaseAllowance(spender, subtractedValue);
658     }
659 }
660 
661 // File: contracts/GoldChainCoin.sol
662 
663 contract GoldChainCoin is ERC20Detailed, ERC20Burnable, ERC20Mintable, GoldTokenPausable {
664     uint8 public constant DECIMALS = 18;
665     uint256 public constant INITIAL_SUPPLY = 20000000000 * (10 ** uint256(DECIMALS));
666 
667     constructor () public ERC20Detailed("Gold Chain Coin", "GCC", DECIMALS) {
668         _mint(msg.sender, INITIAL_SUPPLY);
669     }
670 }