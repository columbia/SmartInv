1 /**
2  *Submitted for verification at Etherscan.io on 2020-03-15
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-02-27
7 */
8 
9 pragma solidity ^0.5.2;
10 
11 /**
12  * @title SafeERC20
13  * @dev Wrappers around ERC20 operations that throw on failure.
14  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
15  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
16  */
17 library SafeERC20 {
18     using SafeMath for uint256;
19 
20     function safeTransfer(IERC20 token, address to, uint256 value) internal {
21         require(token.transfer(to, value));
22     }
23 
24     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
25         require(token.transferFrom(from, to, value));
26     }
27 
28     function safeApprove(IERC20 token, address spender, uint256 value) internal {
29         // safeApprove should only be called when setting an initial allowance,
30         // or when resetting it to zero. To increase and decrease it, use
31         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
32         require((value == 0) || (token.allowance(address(this), spender) == 0));
33         require(token.approve(spender, value));
34     }
35 
36     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
37         uint256 newAllowance = token.allowance(address(this), spender).add(value);
38         require(token.approve(spender, newAllowance));
39     }
40 
41     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
42         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
43         require(token.approve(spender, newAllowance));
44     }
45 }
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://eips.ethereum.org/EIPS/eip-20
50  */
51 interface IERC20 {
52     function transfer(address to, uint256 value) external returns (bool);
53 
54     function approve(address spender, uint256 value) external returns (bool);
55 
56     function transferFrom(address from, address to, uint256 value) external returns (bool);
57 
58     function totalSupply() external view returns (uint256);
59 
60     function balanceOf(address who) external view returns (uint256);
61 
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 
70 /**
71  * @title SafeMath
72  * @dev Unsigned math operations with safety checks that revert on error
73  */
74 library SafeMath {
75     /**
76      * @dev Multiplies two unsigned integers, reverts on overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b);
88 
89         return c;
90     }
91 
92     /**
93      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
94      */
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Solidity only automatically asserts when dividing by 0
97         require(b > 0);
98         uint256 c = a / b;
99         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101         return c;
102     }
103 
104     /**
105      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
106      */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b <= a);
109         uint256 c = a - b;
110 
111         return c;
112     }
113 
114     /**
115      * @dev Adds two unsigned integers, reverts on overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a);
120 
121         return c;
122     }
123 
124     /**
125      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
126      * reverts when dividing by zero.
127      */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b != 0);
130         return a % b;
131     }
132 }
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * https://eips.ethereum.org/EIPS/eip-20
139  * Originally based on code by FirstBlood:
140  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  *
142  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
143  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
144  * compliant implementations may not do it.
145  */
146 contract ERC20 is IERC20 {
147     using SafeMath for uint256;
148 
149     mapping (address => uint256) private _balances;
150 
151     mapping (address => mapping (address => uint256)) private _allowed;
152 
153     uint256 private _totalSupply;
154 
155     /**
156      * @dev Total number of tokens in existence
157      */
158     function totalSupply() public view returns (uint256) {
159         return _totalSupply;
160     }
161 
162     /**
163      * @dev Gets the balance of the specified address.
164      * @param owner The address to query the balance of.
165      * @return An uint256 representing the amount owned by the passed address.
166      */
167     function balanceOf(address owner) public view returns (uint256) {
168         return _balances[owner];
169     }
170 
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param owner address The address which owns the funds.
174      * @param spender address The address which will spend the funds.
175      * @return A uint256 specifying the amount of tokens still available for the spender.
176      */
177     function allowance(address owner, address spender) public view returns (uint256) {
178         return _allowed[owner][spender];
179     }
180 
181     /**
182      * @dev Transfer token for a specified address
183      * @param to The address to transfer to.
184      * @param value The amount to be transferred.
185      */
186     function transfer(address to, uint256 value) public returns (bool) {
187         _transfer(msg.sender, to, value);
188         return true;
189     }
190 
191     /**
192      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193      * Beware that changing an allowance with this method brings the risk that someone may use both the old
194      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      * @param spender The address which will spend the funds.
198      * @param value The amount of tokens to be spent.
199      */
200     function approve(address spender, uint256 value) public returns (bool) {
201         _approve(msg.sender, spender, value);
202         return true;
203     }
204 
205     /**
206      * @dev Transfer tokens from one address to another.
207      * Note that while this function emits an Approval event, this is not required as per the specification,
208      * and other compliant implementations may not emit the event.
209      * @param from address The address which you want to send tokens from
210      * @param to address The address which you want to transfer to
211      * @param value uint256 the amount of tokens to be transferred
212      */
213     function transferFrom(address from, address to, uint256 value) public returns (bool) {
214         _transfer(from, to, value);
215         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
216         return true;
217     }
218 
219     /**
220      * @dev Increase the amount of tokens that an owner allowed to a spender.
221      * approve should be called when allowed_[_spender] == 0. To increment
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * Emits an Approval event.
226      * @param spender The address which will spend the funds.
227      * @param addedValue The amount of tokens to increase the allowance by.
228      */
229     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
230         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
231         return true;
232     }
233 
234     /**
235      * @dev Decrease the amount of tokens that an owner allowed to a spender.
236      * approve should be called when allowed_[_spender] == 0. To decrement
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      * Emits an Approval event.
241      * @param spender The address which will spend the funds.
242      * @param subtractedValue The amount of tokens to decrease the allowance by.
243      */
244     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
245         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
246         return true;
247     }
248 
249     /**
250      * @dev Transfer token for a specified addresses
251      * @param from The address to transfer from.
252      * @param to The address to transfer to.
253      * @param value The amount to be transferred.
254      */
255     function _transfer(address from, address to, uint256 value) internal {
256         require(to != address(0));
257 
258         _balances[from] = _balances[from].sub(value);
259         _balances[to] = _balances[to].add(value);
260         emit Transfer(from, to, value);
261     }
262 
263     /**
264      * @dev Internal function that mints an amount of the token and assigns it to
265      * an account. This encapsulates the modification of balances such that the
266      * proper events are emitted.
267      * @param account The account that will receive the created tokens.
268      * @param value The amount that will be created.
269      */
270     function _mint(address account, uint256 value) internal {
271         require(account != address(0));
272 
273         _totalSupply = _totalSupply.add(value);
274         _balances[account] = _balances[account].add(value);
275         emit Transfer(address(0), account, value);
276     }
277 
278     /**
279      * @dev Internal function that burns an amount of the token of a given
280      * account.
281      * @param account The account whose tokens will be burnt.
282      * @param value The amount that will be burnt.
283      */
284     function _burn(address account, uint256 value) internal {
285         require(account != address(0));
286 
287         _totalSupply = _totalSupply.sub(value);
288         _balances[account] = _balances[account].sub(value);
289         emit Transfer(account, address(0), value);
290     }
291 
292     /**
293      * @dev Approve an address to spend another addresses' tokens.
294      * @param owner The address that owns the tokens.
295      * @param spender The address that will spend the tokens.
296      * @param value The number of tokens that can be spent.
297      */
298     function _approve(address owner, address spender, uint256 value) internal {
299         require(spender != address(0));
300         require(owner != address(0));
301 
302         _allowed[owner][spender] = value;
303         emit Approval(owner, spender, value);
304     }
305 
306     /**
307      * @dev Internal function that burns an amount of the token of a given
308      * account, deducting from the sender's allowance for said account. Uses the
309      * internal burn function.
310      * Emits an Approval event (reflecting the reduced allowance).
311      * @param account The account whose tokens will be burnt.
312      * @param value The amount that will be burnt.
313      */
314     function _burnFrom(address account, uint256 value) internal {
315         _burn(account, value);
316         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
317     }
318 }
319 
320 /**
321  * @title Roles
322  * @dev Library for managing addresses assigned to a Role.
323  */
324 library Roles {
325     struct Role {
326         mapping (address => bool) bearer;
327     }
328 
329     /**
330      * @dev give an account access to this role
331      */
332     function add(Role storage role, address account) internal {
333         require(account != address(0));
334         require(!has(role, account));
335 
336         role.bearer[account] = true;
337     }
338 
339     /**
340      * @dev remove an account's access to this role
341      */
342     function remove(Role storage role, address account) internal {
343         require(account != address(0));
344         require(has(role, account));
345 
346         role.bearer[account] = false;
347     }
348 
349     /**
350      * @dev check if an account has this role
351      * @return bool
352      */
353     function has(Role storage role, address account) internal view returns (bool) {
354         require(account != address(0));
355         return role.bearer[account];
356     }
357 }
358 
359 contract PauserRole {
360     using Roles for Roles.Role;
361 
362     event PauserAdded(address indexed account);
363     event PauserRemoved(address indexed account);
364 
365     Roles.Role private _pausers;
366 
367     constructor () internal {
368         _addPauser(msg.sender);
369     }
370 
371     modifier onlyPauser() {
372         require(isPauser(msg.sender));
373         _;
374     }
375 
376     function isPauser(address account) public view returns (bool) {
377         return _pausers.has(account);
378     }
379 
380     function addPauser(address account) public onlyPauser {
381         _addPauser(account);
382     }
383 
384     function renouncePauser() public {
385         _removePauser(msg.sender);
386     }
387 
388     function _addPauser(address account) internal {
389         _pausers.add(account);
390         emit PauserAdded(account);
391     }
392 
393     function _removePauser(address account) internal {
394         _pausers.remove(account);
395         emit PauserRemoved(account);
396     }
397 }
398 
399 /**
400  * @title Pausable
401  * @dev Base contract which allows children to implement an emergency stop mechanism.
402  */
403 contract Pausable is PauserRole {
404     event Paused(address account);
405     event Unpaused(address account);
406 
407     bool private _paused;
408 
409     constructor () internal {
410         _paused = false;
411     }
412 
413     /**
414      * @return true if the contract is paused, false otherwise.
415      */
416     function paused() public view returns (bool) {
417         return _paused;
418     }
419 
420     /**
421      * @dev Modifier to make a function callable only when the contract is not paused.
422      */
423     modifier whenNotPaused() {
424         require(!_paused);
425         _;
426     }
427 
428     /**
429      * @dev Modifier to make a function callable only when the contract is paused.
430      */
431     modifier whenPaused() {
432         require(_paused);
433         _;
434     }
435 
436     /**
437      * @dev called by the owner to pause, triggers stopped state
438      */
439     function pause() public onlyPauser whenNotPaused {
440         _paused = true;
441         emit Paused(msg.sender);
442     }
443 
444     /**
445      * @dev called by the owner to unpause, returns to normal state
446      */
447     function unpause() public onlyPauser whenPaused {
448         _paused = false;
449         emit Unpaused(msg.sender);
450     }
451 }
452 
453 /**
454  * @title Pausable token
455  * @dev ERC20 modified with pausable transfers.
456  */
457 contract ERC20Pausable is ERC20, Pausable {
458     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
459         return super.transfer(to, value);
460     }
461 
462     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
463         return super.transferFrom(from, to, value);
464     }
465 
466     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
467         return super.approve(spender, value);
468     }
469 
470     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
471         return super.increaseAllowance(spender, addedValue);
472     }
473 
474     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
475         return super.decreaseAllowance(spender, subtractedValue);
476     }
477 }
478 /**
479  * @title ERC20Detailed token
480  * @dev The decimals are only for visualization purposes.
481  * All the operations are done using the smallest and indivisible token unit,
482  * just as on Ethereum all the operations are done in wei.
483  */
484 contract ERC20Detailed is IERC20 {
485     string private _name;
486     string private _symbol;
487     uint8 private _decimals;
488 
489     constructor (string memory name, string memory symbol, uint8 decimals) public {
490         _name = name;
491         _symbol = symbol;
492         _decimals = decimals;
493     }
494 
495     /**
496      * @return the name of the token.
497      */
498     function name() public view returns (string memory) {
499         return _name;
500     }
501 
502     /**
503      * @return the symbol of the token.
504      */
505     function symbol() public view returns (string memory) {
506         return _symbol;
507     }
508 
509     /**
510      * @return the number of decimals of the token.
511      */
512     function decimals() public view returns (uint8) {
513         return _decimals;
514     }
515 }
516 /**
517  * @title Burnable Token
518  * @dev Token that can be irreversibly burned (destroyed).
519  */
520 contract ERC20Burnable is ERC20 {
521     /**
522      * @dev Burns a specific amount of tokens.
523      * @param value The amount of token to be burned.
524      */
525     function burn(uint256 value) public {
526         _burn(msg.sender, value);
527     }
528 
529     /**
530      * @dev Burns a specific amount of tokens from the target address and decrements allowance
531      * @param from address The account whose tokens will be burned.
532      * @param value uint256 The amount of token to be burned.
533      */
534     function burnFrom(address from, uint256 value) public {
535         _burnFrom(from, value);
536     }
537 }
538 
539 
540 contract MinterRole {
541     using Roles for Roles.Role;
542 
543     event MinterAdded(address indexed account);
544     event MinterRemoved(address indexed account);
545 
546     Roles.Role private _minters;
547 
548     constructor () internal {
549         _addMinter(msg.sender);
550     }
551 
552     modifier onlyMinter() {
553         require(isMinter(msg.sender));
554         _;
555     }
556 
557     function isMinter(address account) public view returns (bool) {
558         return _minters.has(account);
559     }
560 
561     function addMinter(address account) public onlyMinter {
562         _addMinter(account);
563     }
564 
565     function renounceMinter() public {
566         _removeMinter(msg.sender);
567     }
568 
569     function _addMinter(address account) internal {
570         _minters.add(account);
571         emit MinterAdded(account);
572     }
573 
574     function _removeMinter(address account) internal {
575         _minters.remove(account);
576         emit MinterRemoved(account);
577     }
578 }
579 /**
580  * @title ERC20Mintable
581  * @dev ERC20 minting logic
582  */
583 contract ERC20Mintable is ERC20, MinterRole {
584     /**
585      * @dev Function to mint tokens
586      * @param to The address that will receive the minted tokens.
587      * @param value The amount of tokens to mint.
588      * @return A boolean that indicates if the operation was successful.
589      */
590     function mint(address to, uint256 value) public onlyMinter returns (bool) {
591         _mint(to, value);
592         return true;
593     }
594 }
595 
596 /**
597  * @title ACI
598  * @dev ACI ERC20 Token, where all tokens are pre-assigned to the creator.
599  * Note they can later distribute these tokens as they wish using `transfer` and other
600  * `ERC20` functions.
601  */
602 contract ACI is ERC20Mintable, ERC20Burnable, ERC20Pausable, ERC20Detailed {
603     uint8 public constant DECIMALS = 8;
604     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(DECIMALS));
605 
606     /**
607      * @dev Constructor that gives msg.sender all of existing tokens.
608      */
609     constructor () public ERC20Detailed("ACI", "ACI", DECIMALS) {
610         _mint(msg.sender, INITIAL_SUPPLY);
611     }
612 }