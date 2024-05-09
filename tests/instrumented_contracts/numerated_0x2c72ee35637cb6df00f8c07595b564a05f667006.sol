1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeERC20
5  * @dev Wrappers around ERC20 operations that throw on failure.
6  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
7  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
8  */
9 library SafeERC20 {
10     using SafeMath for uint256;
11 
12     function safeTransfer(IERC20 token, address to, uint256 value) internal {
13         require(token.transfer(to, value));
14     }
15 
16     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
17         require(token.transferFrom(from, to, value));
18     }
19 
20     function safeApprove(IERC20 token, address spender, uint256 value) internal {
21         // safeApprove should only be called when setting an initial allowance,
22         // or when resetting it to zero. To increase and decrease it, use
23         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
24         require((value == 0) || (token.allowance(address(this), spender) == 0));
25         require(token.approve(spender, value));
26     }
27 
28     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
29         uint256 newAllowance = token.allowance(address(this), spender).add(value);
30         require(token.approve(spender, newAllowance));
31     }
32 
33     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
34         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
35         require(token.approve(spender, newAllowance));
36     }
37 }
38 
39 /**
40  * @title ERC20 interface
41  * @dev see https://eips.ethereum.org/EIPS/eip-20
42  */
43 interface IERC20 {
44     function transfer(address to, uint256 value) external returns (bool);
45 
46     function approve(address spender, uint256 value) external returns (bool);
47 
48     function transferFrom(address from, address to, uint256 value) external returns (bool);
49 
50     function totalSupply() external view returns (uint256);
51 
52     function balanceOf(address who) external view returns (uint256);
53 
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /**
63  * @title SafeMath
64  * @dev Unsigned math operations with safety checks that revert on error
65  */
66 library SafeMath {
67     /**
68      * @dev Multiplies two unsigned integers, reverts on overflow.
69      */
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
72         // benefit is lost if 'b' is also tested.
73         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b);
80 
81         return c;
82     }
83 
84     /**
85      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0);
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     /**
97      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
98      */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b <= a);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Adds two unsigned integers, reverts on overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a);
112 
113         return c;
114     }
115 
116     /**
117      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
118      * reverts when dividing by zero.
119      */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b != 0);
122         return a % b;
123     }
124 }
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * https://eips.ethereum.org/EIPS/eip-20
131  * Originally based on code by FirstBlood:
132  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  *
134  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
135  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
136  * compliant implementations may not do it.
137  */
138 contract ERC20 is IERC20 {
139     using SafeMath for uint256;
140 
141     mapping (address => uint256) private _balances;
142 
143     mapping (address => mapping (address => uint256)) private _allowed;
144 
145     uint256 private _totalSupply;
146 
147     /**
148      * @dev Total number of tokens in existence
149      */
150     function totalSupply() public view returns (uint256) {
151         return _totalSupply;
152     }
153 
154     /**
155      * @dev Gets the balance of the specified address.
156      * @param owner The address to query the balance of.
157      * @return An uint256 representing the amount owned by the passed address.
158      */
159     function balanceOf(address owner) public view returns (uint256) {
160         return _balances[owner];
161     }
162 
163     /**
164      * @dev Function to check the amount of tokens that an owner allowed to a spender.
165      * @param owner address The address which owns the funds.
166      * @param spender address The address which will spend the funds.
167      * @return A uint256 specifying the amount of tokens still available for the spender.
168      */
169     function allowance(address owner, address spender) public view returns (uint256) {
170         return _allowed[owner][spender];
171     }
172 
173     /**
174      * @dev Transfer token for a specified address
175      * @param to The address to transfer to.
176      * @param value The amount to be transferred.
177      */
178     function transfer(address to, uint256 value) public returns (bool) {
179         _transfer(msg.sender, to, value);
180         return true;
181     }
182 
183     /**
184      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185      * Beware that changing an allowance with this method brings the risk that someone may use both the old
186      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      * @param spender The address which will spend the funds.
190      * @param value The amount of tokens to be spent.
191      */
192     function approve(address spender, uint256 value) public returns (bool) {
193         _approve(msg.sender, spender, value);
194         return true;
195     }
196 
197     /**
198      * @dev Transfer tokens from one address to another.
199      * Note that while this function emits an Approval event, this is not required as per the specification,
200      * and other compliant implementations may not emit the event.
201      * @param from address The address which you want to send tokens from
202      * @param to address The address which you want to transfer to
203      * @param value uint256 the amount of tokens to be transferred
204      */
205     function transferFrom(address from, address to, uint256 value) public returns (bool) {
206         _transfer(from, to, value);
207         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
208         return true;
209     }
210 
211     /**
212      * @dev Increase the amount of tokens that an owner allowed to a spender.
213      * approve should be called when allowed_[_spender] == 0. To increment
214      * allowed value is better to use this function to avoid 2 calls (and wait until
215      * the first transaction is mined)
216      * From MonolithDAO Token.sol
217      * Emits an Approval event.
218      * @param spender The address which will spend the funds.
219      * @param addedValue The amount of tokens to increase the allowance by.
220      */
221     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
222         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
223         return true;
224     }
225 
226     /**
227      * @dev Decrease the amount of tokens that an owner allowed to a spender.
228      * approve should be called when allowed_[_spender] == 0. To decrement
229      * allowed value is better to use this function to avoid 2 calls (and wait until
230      * the first transaction is mined)
231      * From MonolithDAO Token.sol
232      * Emits an Approval event.
233      * @param spender The address which will spend the funds.
234      * @param subtractedValue The amount of tokens to decrease the allowance by.
235      */
236     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
237         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
238         return true;
239     }
240 
241     /**
242      * @dev Transfer token for a specified addresses
243      * @param from The address to transfer from.
244      * @param to The address to transfer to.
245      * @param value The amount to be transferred.
246      */
247     function _transfer(address from, address to, uint256 value) internal {
248         require(to != address(0));
249 
250         _balances[from] = _balances[from].sub(value);
251         _balances[to] = _balances[to].add(value);
252         emit Transfer(from, to, value);
253     }
254 
255     /**
256      * @dev Internal function that mints an amount of the token and assigns it to
257      * an account. This encapsulates the modification of balances such that the
258      * proper events are emitted.
259      * @param account The account that will receive the created tokens.
260      * @param value The amount that will be created.
261      */
262     function _mint(address account, uint256 value) internal {
263         require(account != address(0));
264 
265         _totalSupply = _totalSupply.add(value);
266         _balances[account] = _balances[account].add(value);
267         emit Transfer(address(0), account, value);
268     }
269 
270     /**
271      * @dev Internal function that burns an amount of the token of a given
272      * account.
273      * @param account The account whose tokens will be burnt.
274      * @param value The amount that will be burnt.
275      */
276     function _burn(address account, uint256 value) internal {
277         require(account != address(0));
278 
279         _totalSupply = _totalSupply.sub(value);
280         _balances[account] = _balances[account].sub(value);
281         emit Transfer(account, address(0), value);
282     }
283 
284     /**
285      * @dev Approve an address to spend another addresses' tokens.
286      * @param owner The address that owns the tokens.
287      * @param spender The address that will spend the tokens.
288      * @param value The number of tokens that can be spent.
289      */
290     function _approve(address owner, address spender, uint256 value) internal {
291         require(spender != address(0));
292         require(owner != address(0));
293 
294         _allowed[owner][spender] = value;
295         emit Approval(owner, spender, value);
296     }
297 
298     /**
299      * @dev Internal function that burns an amount of the token of a given
300      * account, deducting from the sender's allowance for said account. Uses the
301      * internal burn function.
302      * Emits an Approval event (reflecting the reduced allowance).
303      * @param account The account whose tokens will be burnt.
304      * @param value The amount that will be burnt.
305      */
306     function _burnFrom(address account, uint256 value) internal {
307         _burn(account, value);
308         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
309     }
310 }
311 
312 /**
313  * @title Roles
314  * @dev Library for managing addresses assigned to a Role.
315  */
316 library Roles {
317     struct Role {
318         mapping (address => bool) bearer;
319     }
320 
321     /**
322      * @dev give an account access to this role
323      */
324     function add(Role storage role, address account) internal {
325         require(account != address(0));
326         require(!has(role, account));
327 
328         role.bearer[account] = true;
329     }
330 
331     /**
332      * @dev remove an account's access to this role
333      */
334     function remove(Role storage role, address account) internal {
335         require(account != address(0));
336         require(has(role, account));
337 
338         role.bearer[account] = false;
339     }
340 
341     /**
342      * @dev check if an account has this role
343      * @return bool
344      */
345     function has(Role storage role, address account) internal view returns (bool) {
346         require(account != address(0));
347         return role.bearer[account];
348     }
349 }
350 
351 contract PauserRole {
352     using Roles for Roles.Role;
353 
354     event PauserAdded(address indexed account);
355     event PauserRemoved(address indexed account);
356 
357     Roles.Role private _pausers;
358 
359     constructor () internal {
360         _addPauser(msg.sender);
361     }
362 
363     modifier onlyPauser() {
364         require(isPauser(msg.sender));
365         _;
366     }
367 
368     function isPauser(address account) public view returns (bool) {
369         return _pausers.has(account);
370     }
371 
372     function addPauser(address account) public onlyPauser {
373         _addPauser(account);
374     }
375 
376     function renouncePauser() public {
377         _removePauser(msg.sender);
378     }
379 
380     function _addPauser(address account) internal {
381         _pausers.add(account);
382         emit PauserAdded(account);
383     }
384 
385     function _removePauser(address account) internal {
386         _pausers.remove(account);
387         emit PauserRemoved(account);
388     }
389 }
390 
391 /**
392  * @title Pausable
393  * @dev Base contract which allows children to implement an emergency stop mechanism.
394  */
395 contract Pausable is PauserRole {
396     event Paused(address account);
397     event Unpaused(address account);
398 
399     bool private _paused;
400 
401     constructor () internal {
402         _paused = false;
403     }
404 
405     /**
406      * @return true if the contract is paused, false otherwise.
407      */
408     function paused() public view returns (bool) {
409         return _paused;
410     }
411 
412     /**
413      * @dev Modifier to make a function callable only when the contract is not paused.
414      */
415     modifier whenNotPaused() {
416         require(!_paused);
417         _;
418     }
419 
420     /**
421      * @dev Modifier to make a function callable only when the contract is paused.
422      */
423     modifier whenPaused() {
424         require(_paused);
425         _;
426     }
427 
428     /**
429      * @dev called by the owner to pause, triggers stopped state
430      */
431     function pause() public onlyPauser whenNotPaused {
432         _paused = true;
433         emit Paused(msg.sender);
434     }
435 
436     /**
437      * @dev called by the owner to unpause, returns to normal state
438      */
439     function unpause() public onlyPauser whenPaused {
440         _paused = false;
441         emit Unpaused(msg.sender);
442     }
443 }
444 
445 /**
446  * @title Pausable token
447  * @dev ERC20 modified with pausable transfers.
448  */
449 contract ERC20Pausable is ERC20, Pausable {
450     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
451         return super.transfer(to, value);
452     }
453 
454     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
455         return super.transferFrom(from, to, value);
456     }
457 
458     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
459         return super.approve(spender, value);
460     }
461 
462     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
463         return super.increaseAllowance(spender, addedValue);
464     }
465 
466     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
467         return super.decreaseAllowance(spender, subtractedValue);
468     }
469 }
470 /**
471  * @title ERC20Detailed token
472  * @dev The decimals are only for visualization purposes.
473  * All the operations are done using the smallest and indivisible token unit,
474  * just as on Ethereum all the operations are done in wei.
475  */
476 contract ERC20Detailed is IERC20 {
477     string private _name;
478     string private _symbol;
479     uint8 private _decimals;
480 
481     constructor (string memory name, string memory symbol, uint8 decimals) public {
482         _name = name;
483         _symbol = symbol;
484         _decimals = decimals;
485     }
486 
487     /**
488      * @return the name of the token.
489      */
490     function name() public view returns (string memory) {
491         return _name;
492     }
493 
494     /**
495      * @return the symbol of the token.
496      */
497     function symbol() public view returns (string memory) {
498         return _symbol;
499     }
500 
501     /**
502      * @return the number of decimals of the token.
503      */
504     function decimals() public view returns (uint8) {
505         return _decimals;
506     }
507 }
508 /**
509  * @title Burnable Token
510  * @dev Token that can be irreversibly burned (destroyed).
511  */
512 contract ERC20Burnable is ERC20 {
513     /**
514      * @dev Burns a specific amount of tokens.
515      * @param value The amount of token to be burned.
516      */
517     function burn(uint256 value) public {
518         _burn(msg.sender, value);
519     }
520 
521     /**
522      * @dev Burns a specific amount of tokens from the target address and decrements allowance
523      * @param from address The account whose tokens will be burned.
524      * @param value uint256 The amount of token to be burned.
525      */
526     function burnFrom(address from, uint256 value) public {
527         _burnFrom(from, value);
528     }
529 }
530 
531 
532 contract MinterRole {
533     using Roles for Roles.Role;
534 
535     event MinterAdded(address indexed account);
536     event MinterRemoved(address indexed account);
537 
538     Roles.Role private _minters;
539 
540     constructor () internal {
541         _addMinter(msg.sender);
542     }
543 
544     modifier onlyMinter() {
545         require(isMinter(msg.sender));
546         _;
547     }
548 
549     function isMinter(address account) public view returns (bool) {
550         return _minters.has(account);
551     }
552 
553     function addMinter(address account) public onlyMinter {
554         _addMinter(account);
555     }
556 
557     function renounceMinter() public {
558         _removeMinter(msg.sender);
559     }
560 
561     function _addMinter(address account) internal {
562         _minters.add(account);
563         emit MinterAdded(account);
564     }
565 
566     function _removeMinter(address account) internal {
567         _minters.remove(account);
568         emit MinterRemoved(account);
569     }
570 }
571 /**
572  * @title ERC20Mintable
573  * @dev ERC20 minting logic
574  */
575 contract ERC20Mintable is ERC20, MinterRole {
576     /**
577      * @dev Function to mint tokens
578      * @param to The address that will receive the minted tokens.
579      * @param value The amount of tokens to mint.
580      * @return A boolean that indicates if the operation was successful.
581      */
582     function mint(address to, uint256 value) public onlyMinter returns (bool) {
583         _mint(to, value);
584         return true;
585     }
586 }
587 
588 /**
589  * @title ECP
590  * @dev ECP ERC20 Token, where all tokens are pre-assigned to the creator.
591  * Note they can later distribute these tokens as they wish using `transfer` and other
592  * `ERC20` functions.
593  */
594 contract ECP is ERC20Mintable, ERC20Burnable, ERC20Pausable, ERC20Detailed {
595     uint8 public constant DECIMALS = 8;
596     uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(DECIMALS));
597 
598     /**
599      * @dev Constructor that gives msg.sender all of existing tokens.
600      */
601     constructor () public ERC20Detailed("ECP+", "ECP+", DECIMALS) {
602         _mint(msg.sender, INITIAL_SUPPLY);
603     }
604 }