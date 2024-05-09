1 /**
2 
3 ██╗    ██╗██████╗ ███████╗███╗   ███╗ █████╗ ██████╗ ████████╗ ██████╗ ██████╗ ███╗   ██╗████████╗██████╗  █████╗  ██████╗████████╗███████╗    ██████╗ ██████╗ ███╗   ███╗
4 ██║    ██║██╔══██╗██╔════╝████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝   ██╔════╝██╔═══██╗████╗ ████║
5 ██║ █╗ ██║██████╔╝███████╗██╔████╔██║███████║██████╔╝   ██║   ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝███████║██║        ██║   ███████╗   ██║     ██║   ██║██╔████╔██║
6 ██║███╗██║██╔═══╝ ╚════██║██║╚██╔╝██║██╔══██║██╔══██╗   ██║   ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██╔══██║██║        ██║   ╚════██║   ██║     ██║   ██║██║╚██╔╝██║
7 ╚███╔███╔╝██║     ███████║██║ ╚═╝ ██║██║  ██║██║  ██║   ██║   ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║  ██║╚██████╗   ██║   ███████║██╗╚██████╗╚██████╔╝██║ ╚═╝ ██║
8  ╚══╝╚══╝ ╚═╝     ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚══════╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝
9 
10 Blockchain Made Easy
11 
12 http://wpsmartcontracts.com/
13 
14 */
15 
16 pragma solidity ^0.5.7;
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that revert on error
21  */
22 library SafeMath {
23     
24     int256 constant private INT256_MIN = -2**255;
25 
26     /**
27     * @dev Multiplies two unsigned integers, reverts on overflow.
28     */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44     * @dev Multiplies two signed integers, reverts on overflow.
45     */
46     function mul(int256 a, int256 b) internal pure returns (int256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50         if (a == 0) {
51             return 0;
52         }
53 
54         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
55 
56         int256 c = a * b;
57         require(c / a == b);
58 
59         return c;
60     }
61 
62     /**
63     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
64     */
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Solidity only automatically asserts when dividing by 0
67         require(b > 0);
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71         return c;
72     }
73 
74     /**
75     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
76     */
77     function div(int256 a, int256 b) internal pure returns (int256) {
78         require(b != 0); // Solidity only automatically asserts when dividing by 0
79         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
80 
81         int256 c = a / b;
82 
83         return c;
84     }
85 
86     /**
87     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
88     */
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b <= a);
91         uint256 c = a - b;
92 
93         return c;
94     }
95 
96     /**
97     * @dev Subtracts two signed integers, reverts on overflow.
98     */
99     function sub(int256 a, int256 b) internal pure returns (int256) {
100         int256 c = a - b;
101         require((b >= 0 && c <= a) || (b < 0 && c > a));
102 
103         return c;
104     }
105 
106     /**
107     * @dev Adds two unsigned integers, reverts on overflow.
108     */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a);
112 
113         return c;
114     }
115 
116     /**
117     * @dev Adds two signed integers, reverts on overflow.
118     */
119     function add(int256 a, int256 b) internal pure returns (int256) {
120         int256 c = a + b;
121         require((b >= 0 && c >= a) || (b < 0 && c < a));
122 
123         return c;
124     }
125 
126     /**
127     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
128     * reverts when dividing by zero.
129     */
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         require(b != 0);
132         return a % b;
133     }
134 }
135 
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 interface IERC20 {
142     function totalSupply() external view returns (uint256);
143 
144     function balanceOf(address who) external view returns (uint256);
145 
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     function transfer(address to, uint256 value) external returns (bool);
149 
150     function approve(address spender, uint256 value) external returns (bool);
151 
152     function transferFrom(address from, address to, uint256 value) external returns (bool);
153 
154     event Transfer(address indexed from, address indexed to, uint256 value);
155 
156     event Approval(address indexed owner, address indexed spender, uint256 value);
157 }
158 
159 contract ERC20Pistachio is IERC20 {
160 
161     using SafeMath for uint256;
162 
163     mapping (address => uint256) private _balances;
164 
165     mapping (address => mapping (address => uint256)) private _allowed;
166 
167     uint256 private _totalSupply;
168 
169     /**
170     * @dev Public parameters to define the token
171     */
172 
173     // Token symbol (short)
174     string public symbol;
175 
176     // Token name (Long)
177     string public  name;
178 
179     // Decimals (18 maximum)
180     uint8 public decimals;
181 
182     /**
183     * @dev Public functions to make the contract accesible
184     */
185     constructor (address initialAccount, string memory _tokenSymbol, string memory _tokenName, uint256 initialBalance) public {
186 
187         // Initialize Contract Parameters
188         symbol = _tokenSymbol;
189         name = _tokenName;
190         decimals = 18;  // default decimals is going to be 18 always
191 
192         _mint(initialAccount, initialBalance);
193 
194     }
195 
196     /**
197     * @dev Total number of tokens in existence
198     */
199     function totalSupply() public view returns (uint256) {
200         return _totalSupply;
201     }
202 
203     /**
204     * @dev Gets the balance of the specified address.
205     * @param owner The address to query the balance of.
206     * @return An uint256 representing the amount owned by the passed address.
207     */
208     function balanceOf(address owner) public view returns (uint256) {
209         return _balances[owner];
210     }
211 
212     /**
213      * @dev Function to check the amount of tokens that an owner allowed to a spender.
214      * @param owner address The address which owns the funds.
215      * @param spender address The address which will spend the funds.
216      * @return A uint256 specifying the amount of tokens still available for the spender.
217      */
218     function allowance(address owner, address spender) public view returns (uint256) {
219         return _allowed[owner][spender];
220     }
221 
222     /**
223     * @dev Transfer token for a specified address
224     * @param to The address to transfer to.
225     * @param value The amount to be transferred.
226     */
227     function transfer(address to, uint256 value) public returns (bool) {
228         _transfer(msg.sender, to, value);
229         return true;
230     }
231 
232     /**
233      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234      * Beware that changing an allowance with this method brings the risk that someone may use both the old
235      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      * @param spender The address which will spend the funds.
239      * @param value The amount of tokens to be spent.
240      */
241     function approve(address spender, uint256 value) public returns (bool) {
242         require(spender != address(0));
243 
244         _allowed[msg.sender][spender] = value;
245         emit Approval(msg.sender, spender, value);
246         return true;
247     }
248 
249     /**
250      * @dev Transfer tokens from one address to another.
251      * Note that while this function emits an Approval event, this is not required as per the specification,
252      * and other compliant implementations may not emit the event.
253      * @param from address The address which you want to send tokens from
254      * @param to address The address which you want to transfer to
255      * @param value uint256 the amount of tokens to be transferred
256      */
257     function transferFrom(address from, address to, uint256 value) public returns (bool) {
258         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
259         _transfer(from, to, value);
260         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
261         return true;
262     }
263 
264     /**
265      * @dev Increase the amount of tokens that an owner allowed to a spender.
266      * approve should be called when allowed_[_spender] == 0. To increment
267      * allowed value is better to use this function to avoid 2 calls (and wait until
268      * the first transaction is mined)
269      * From MonolithDAO Token.sol
270      * Emits an Approval event.
271      * @param spender The address which will spend the funds.
272      * @param addedValue The amount of tokens to increase the allowance by.
273      */
274     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
275         require(spender != address(0));
276 
277         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
278         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
279         return true;
280     }
281 
282     /**
283      * @dev Decrease the amount of tokens that an owner allowed to a spender.
284      * approve should be called when allowed_[_spender] == 0. To decrement
285      * allowed value is better to use this function to avoid 2 calls (and wait until
286      * the first transaction is mined)
287      * From MonolithDAO Token.sol
288      * Emits an Approval event.
289      * @param spender The address which will spend the funds.
290      * @param subtractedValue The amount of tokens to decrease the allowance by.
291      */
292     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
293         require(spender != address(0));
294 
295         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
296         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
297         return true;
298     }
299 
300     /**
301     * @dev Transfer token for a specified addresses
302     * @param from The address to transfer from.
303     * @param to The address to transfer to.
304     * @param value The amount to be transferred.
305     */
306     function _transfer(address from, address to, uint256 value) internal {
307         require(to != address(0));
308 
309         _balances[from] = _balances[from].sub(value);
310         _balances[to] = _balances[to].add(value);
311         emit Transfer(from, to, value);
312     }
313 
314     /**
315      * @dev Internal function that mints an amount of the token and assigns it to
316      * an account. This encapsulates the modification of balances such that the
317      * proper events are emitted.
318      * @param account The account that will receive the created tokens.
319      * @param value The amount that will be created.
320      */
321     function _mint(address account, uint256 value) internal {
322         require(account != address(0));
323 
324         _totalSupply = _totalSupply.add(value);
325         _balances[account] = _balances[account].add(value);
326         emit Transfer(address(0), account, value);
327     }
328 
329     /**
330      * @dev Internal function that burns an amount of the token of a given
331      * account.
332      * @param account The account whose tokens will be burnt.
333      * @param value The amount that will be burnt.
334      */
335     function _burn(address account, uint256 value) internal {
336         require(account != address(0));
337 
338         _totalSupply = _totalSupply.sub(value);
339         _balances[account] = _balances[account].sub(value);
340         emit Transfer(account, address(0), value);
341     }
342 
343     /**
344      * @dev Internal function that burns an amount of the token of a given
345      * account, deducting from the sender's allowance for said account. Uses the
346      * internal burn function.
347      * Emits an Approval event (reflecting the reduced allowance).
348      * @param account The account whose tokens will be burnt.
349      * @param value The amount that will be burnt.
350      */
351     function _burnFrom(address account, uint256 value) internal {
352         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
353         _burn(account, value);
354         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
355     }
356 
357 }
358 
359 /**
360  * @title Burnable Token
361  * @dev Token that can be irreversibly burned (destroyed).
362  */
363 contract ERC20Burnable is ERC20Pistachio {
364 
365     bool private _burnableActive;
366 
367     /**
368      * @dev Burns a specific amount of tokens.
369      * @param value The amount of token to be burned.
370      */
371     function burn(uint256 value) public whenBurnableActive {
372         _burn(msg.sender, value);
373     }
374 
375     /**
376      * @dev Burns a specific amount of tokens from the target address and decrements allowance
377      * @param from address The address which you want to send tokens from
378      * @param value uint256 The amount of token to be burned
379      */
380     function burnFrom(address from, uint256 value) public whenBurnableActive {
381         _burnFrom(from, value);
382     }
383 
384     /**
385      * @dev Options to activate or deactivate Burn ability
386      */
387 
388     function _setBurnableActive(bool _active) internal {
389         _burnableActive = _active;
390     }
391 
392     modifier whenBurnableActive() {
393         require(_burnableActive);
394         _;
395     }
396 
397 }
398 
399 /**
400  * @title Roles
401  * @dev Library for managing addresses assigned to a Role.
402  */
403 library Roles {
404     struct Role {
405         mapping (address => bool) bearer;
406     }
407 
408     /**
409      * @dev give an account access to this role
410      */
411     function add(Role storage role, address account) internal {
412         require(account != address(0));
413         require(!has(role, account));
414 
415         role.bearer[account] = true;
416     }
417 
418     /**
419      * @dev remove an account's access to this role
420      */
421     function remove(Role storage role, address account) internal {
422         require(account != address(0));
423         require(has(role, account));
424 
425         role.bearer[account] = false;
426     }
427 
428     /**
429      * @dev check if an account has this role
430      * @return bool
431      */
432     function has(Role storage role, address account) internal view returns (bool) {
433         require(account != address(0));
434         return role.bearer[account];
435     }
436 }
437 
438 contract MinterRole {
439     using Roles for Roles.Role;
440 
441     event MinterAdded(address indexed account);
442     event MinterRemoved(address indexed account);
443 
444     Roles.Role private _minters;
445 
446     constructor () internal {
447         _addMinter(msg.sender);
448     }
449 
450     modifier onlyMinter() {
451         require(isMinter(msg.sender));
452         _;
453     }
454 
455     function isMinter(address account) public view returns (bool) {
456         return _minters.has(account);
457     }
458 
459     function addMinter(address account) public onlyMinter {
460         _addMinter(account);
461     }
462 
463     function renounceMinter() public {
464         _removeMinter(msg.sender);
465     }
466 
467     function _addMinter(address account) internal {
468         _minters.add(account);
469         emit MinterAdded(account);
470     }
471 
472     function _removeMinter(address account) internal {
473         _minters.remove(account);
474         emit MinterRemoved(account);
475     }
476 }
477 
478 /**
479  * @title ERC20Mintable
480  * @dev ERC20 minting logic
481  */
482 contract ERC20Mintable is ERC20Pistachio, MinterRole {
483 
484     bool private _mintableActive;
485     /**
486      * @dev Function to mint tokens
487      * @param to The address that will receive the minted tokens.
488      * @param value The amount of tokens to mint.
489      * @return A boolean that indicates if the operation was successful.
490      */
491     function mint(address to, uint256 value) public onlyMinter whenMintableActive returns (bool) {
492         _mint(to, value);
493         return true;
494     }
495 
496     /**
497      * @dev Options to activate or deactivate Burn ability
498      */
499 
500     function _setMintableActive(bool _active) internal {
501         _mintableActive = _active;
502     }
503 
504     modifier whenMintableActive() {
505         require(_mintableActive);
506         _;
507     }
508 
509 }
510 
511 contract PauserRole {
512     using Roles for Roles.Role;
513 
514     event PauserAdded(address indexed account);
515     event PauserRemoved(address indexed account);
516 
517     Roles.Role private _pausers;
518 
519     constructor () internal {
520         _addPauser(msg.sender);
521     }
522 
523     modifier onlyPauser() {
524         require(isPauser(msg.sender));
525         _;
526     }
527 
528     function isPauser(address account) public view returns (bool) {
529         return _pausers.has(account);
530     }
531 
532     function addPauser(address account) public onlyPauser {
533         _addPauser(account);
534     }
535 
536     function renouncePauser() public {
537         _removePauser(msg.sender);
538     }
539 
540     function _addPauser(address account) internal {
541         _pausers.add(account);
542         emit PauserAdded(account);
543     }
544 
545     function _removePauser(address account) internal {
546         _pausers.remove(account);
547         emit PauserRemoved(account);
548     }
549 }
550 
551 /**
552  * @title Pausable
553  * @dev Base contract which allows children to implement an emergency stop mechanism.
554  */
555 contract Pausable is PauserRole {
556     event Paused(address account);
557     event Unpaused(address account);
558 
559     bool private _pausableActive;
560     bool private _paused;
561 
562     constructor () internal {
563         _paused = false;
564     }
565 
566     /**
567      * @return true if the contract is paused, false otherwise.
568      */
569     function paused() public view returns (bool) {
570         return _paused;
571     }
572 
573     /**
574      * @dev Modifier to make a function callable only when the contract is not paused.
575      */
576     modifier whenNotPaused() {
577         require(!_paused);
578         _;
579     }
580 
581     /**
582      * @dev Modifier to make a function callable only when the contract is paused.
583      */
584     modifier whenPaused() {
585         require(_paused);
586         _;
587     }
588 
589     /**
590      * @dev called by the owner to pause, triggers stopped state
591      */
592     function pause() public onlyPauser whenNotPaused whenPausableActive {
593         _paused = true;
594         emit Paused(msg.sender);
595     }
596 
597     /**
598      * @dev called by the owner to unpause, returns to normal state
599      */
600     function unpause() public onlyPauser whenPaused whenPausableActive {
601         _paused = false;
602         emit Unpaused(msg.sender);
603     }
604 
605     /**
606      * @dev Options to activate or deactivate Pausable ability
607      */
608 
609     function _setPausableActive(bool _active) internal {
610         _pausableActive = _active;
611     }
612 
613     modifier whenPausableActive() {
614         require(_pausableActive);
615         _;
616     }
617 
618 }
619 
620 /**
621  * @title Advanced ERC20 token
622  *
623  * @dev Implementation of the basic standard token plus mint and burn public functions.
624  *
625  * Version 2. This version delegates the minter and pauser renounce to parent-factory contract
626  * that allows ICOs to be minter for token selling
627  *
628  */
629 contract ERC20Chocolate is ERC20Pistachio, ERC20Burnable, ERC20Mintable, Pausable {
630 
631     // maximum capital, if defined > 0
632     uint256 private _cap;
633 
634     constructor (
635         address initialAccount, string memory _tokenSymbol, string memory _tokenName, uint256 initialBalance, uint256 cap,
636         bool _burnableOption, bool _mintableOption, bool _pausableOption
637     ) public 
638         ERC20Pistachio(initialAccount, _tokenSymbol, _tokenName, initialBalance) {
639 
640         // we must add customer account as the first minter
641         addMinter(initialAccount);
642 
643         // add customer as pauser
644         addPauser(initialAccount);
645 
646         if (cap > 0) {
647             _cap = cap; // maximum capitalization limited
648         } else {
649             _cap = 0; // unlimited capitalization
650         }
651 
652         // activate or deactivate options
653         _setBurnableActive(_burnableOption);
654         _setMintableActive(_mintableOption);
655         _setPausableActive(_pausableOption);
656 
657     }
658 
659     /**
660      * @return the cap for the token minting.
661      */
662     function cap() public view returns (uint256) {
663         return _cap;
664     }
665 
666     /**
667      * limit the mint to a maximum cap only if cap is defined
668      */
669     function _mint(address account, uint256 value) internal {
670         if (_cap > 0) {
671             require(totalSupply().add(value) <= _cap);
672         }
673         super._mint(account, value);
674     }
675 
676     /**
677      * Pausable options
678      */
679     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
680         return super.transfer(to, value);
681     }
682 
683     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
684         return super.transferFrom(from, to, value);
685     }
686 
687     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
688         return super.approve(spender, value);
689     }
690 
691     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
692         return super.increaseAllowance(spender, addedValue);
693     }
694 
695     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
696         return super.decreaseAllowance(spender, subtractedValue);
697     }
698 
699 }