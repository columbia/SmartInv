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
27 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
28 
29 pragma solidity ^0.5.2;
30 
31 
32 /**
33  * @title ERC20Detailed token
34  * @dev The decimals are only for visualization purposes.
35  * All the operations are done using the smallest and indivisible token unit,
36  * just as on Ethereum all the operations are done in wei.
37  */
38 contract ERC20Detailed is IERC20 {
39     string private _name;
40     string private _symbol;
41     uint8 private _decimals;
42 
43     constructor (string memory name, string memory symbol, uint8 decimals) public {
44         _name = name;
45         _symbol = symbol;
46         _decimals = decimals;
47     }
48 
49     /**
50      * @return the name of the token.
51      */
52     function name() public view returns (string memory) {
53         return _name;
54     }
55 
56     /**
57      * @return the symbol of the token.
58      */
59     function symbol() public view returns (string memory) {
60         return _symbol;
61     }
62 
63     /**
64      * @return the number of decimals of the token.
65      */
66     function decimals() public view returns (uint8) {
67         return _decimals;
68     }
69 }
70 
71 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
72 
73 pragma solidity ^0.5.2;
74 
75 /**
76  * @title SafeMath
77  * @dev Unsigned math operations with safety checks that revert on error
78  */
79 library SafeMath {
80     /**
81      * @dev Multiplies two unsigned integers, reverts on overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b);
93 
94         return c;
95     }
96 
97     /**
98      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b > 0);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Adds two unsigned integers, reverts on overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a);
125 
126         return c;
127     }
128 
129     /**
130      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
131      * reverts when dividing by zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b != 0);
135         return a % b;
136     }
137 }
138 
139 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
140 
141 pragma solidity ^0.5.2;
142 
143 
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * https://eips.ethereum.org/EIPS/eip-20
150  * Originally based on code by FirstBlood:
151  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  *
153  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
154  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
155  * compliant implementations may not do it.
156  */
157 contract ERC20 is IERC20 {
158     using SafeMath for uint256;
159 
160     mapping (address => uint256) private _balances;
161 
162     mapping (address => mapping (address => uint256)) private _allowed;
163 
164     uint256 private _totalSupply;
165 
166     /**
167      * @dev Total number of tokens in existence
168      */
169     function totalSupply() public view returns (uint256) {
170         return _totalSupply;
171     }
172 
173     /**
174      * @dev Gets the balance of the specified address.
175      * @param owner The address to query the balance of.
176      * @return A uint256 representing the amount owned by the passed address.
177      */
178     function balanceOf(address owner) public view returns (uint256) {
179         return _balances[owner];
180     }
181 
182     /**
183      * @dev Function to check the amount of tokens that an owner allowed to a spender.
184      * @param owner address The address which owns the funds.
185      * @param spender address The address which will spend the funds.
186      * @return A uint256 specifying the amount of tokens still available for the spender.
187      */
188     function allowance(address owner, address spender) public view returns (uint256) {
189         return _allowed[owner][spender];
190     }
191 
192     /**
193      * @dev Transfer token to a specified address
194      * @param to The address to transfer to.
195      * @param value The amount to be transferred.
196      */
197     function transfer(address to, uint256 value) public returns (bool) {
198         _transfer(msg.sender, to, value);
199         return true;
200     }
201 
202     /**
203      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204      * Beware that changing an allowance with this method brings the risk that someone may use both the old
205      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      * @param spender The address which will spend the funds.
209      * @param value The amount of tokens to be spent.
210      */
211     function approve(address spender, uint256 value) public returns (bool) {
212         _approve(msg.sender, spender, value);
213         return true;
214     }
215 
216     /**
217      * @dev Transfer tokens from one address to another.
218      * Note that while this function emits an Approval event, this is not required as per the specification,
219      * and other compliant implementations may not emit the event.
220      * @param from address The address which you want to send tokens from
221      * @param to address The address which you want to transfer to
222      * @param value uint256 the amount of tokens to be transferred
223      */
224     function transferFrom(address from, address to, uint256 value) public returns (bool) {
225         _transfer(from, to, value);
226         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
227         return true;
228     }
229 
230     /**
231      * @dev Increase the amount of tokens that an owner allowed to a spender.
232      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
233      * allowed value is better to use this function to avoid 2 calls (and wait until
234      * the first transaction is mined)
235      * From MonolithDAO Token.sol
236      * Emits an Approval event.
237      * @param spender The address which will spend the funds.
238      * @param addedValue The amount of tokens to increase the allowance by.
239      */
240     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
241         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
242         return true;
243     }
244 
245     /**
246      * @dev Decrease the amount of tokens that an owner allowed to a spender.
247      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
248      * allowed value is better to use this function to avoid 2 calls (and wait until
249      * the first transaction is mined)
250      * From MonolithDAO Token.sol
251      * Emits an Approval event.
252      * @param spender The address which will spend the funds.
253      * @param subtractedValue The amount of tokens to decrease the allowance by.
254      */
255     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
256         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
257         return true;
258     }
259 
260     /**
261      * @dev Transfer token for a specified addresses
262      * @param from The address to transfer from.
263      * @param to The address to transfer to.
264      * @param value The amount to be transferred.
265      */
266     function _transfer(address from, address to, uint256 value) internal {
267         require(to != address(0));
268 
269         _balances[from] = _balances[from].sub(value);
270         _balances[to] = _balances[to].add(value);
271         emit Transfer(from, to, value);
272     }
273 
274     /**
275      * @dev Internal function that mints an amount of the token and assigns it to
276      * an account. This encapsulates the modification of balances such that the
277      * proper events are emitted.
278      * @param account The account that will receive the created tokens.
279      * @param value The amount that will be created.
280      */
281     function _mint(address account, uint256 value) internal {
282         require(account != address(0));
283 
284         _totalSupply = _totalSupply.add(value);
285         _balances[account] = _balances[account].add(value);
286         emit Transfer(address(0), account, value);
287     }
288 
289     /**
290      * @dev Internal function that burns an amount of the token of a given
291      * account.
292      * @param account The account whose tokens will be burnt.
293      * @param value The amount that will be burnt.
294      */
295     function _burn(address account, uint256 value) internal {
296         require(account != address(0));
297 
298         _totalSupply = _totalSupply.sub(value);
299         _balances[account] = _balances[account].sub(value);
300         emit Transfer(account, address(0), value);
301     }
302 
303     /**
304      * @dev Approve an address to spend another addresses' tokens.
305      * @param owner The address that owns the tokens.
306      * @param spender The address that will spend the tokens.
307      * @param value The number of tokens that can be spent.
308      */
309     function _approve(address owner, address spender, uint256 value) internal {
310         require(spender != address(0));
311         require(owner != address(0));
312 
313         _allowed[owner][spender] = value;
314         emit Approval(owner, spender, value);
315     }
316 
317     /**
318      * @dev Internal function that burns an amount of the token of a given
319      * account, deducting from the sender's allowance for said account. Uses the
320      * internal burn function.
321      * Emits an Approval event (reflecting the reduced allowance).
322      * @param account The account whose tokens will be burnt.
323      * @param value The amount that will be burnt.
324      */
325     function _burnFrom(address account, uint256 value) internal {
326         _burn(account, value);
327         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
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
402 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
403 
404 pragma solidity ^0.5.2;
405 
406 
407 contract PauserRole {
408     using Roles for Roles.Role;
409 
410     event PauserAdded(address indexed account);
411     event PauserRemoved(address indexed account);
412 
413     Roles.Role private _pausers;
414 
415     constructor () internal {
416         _addPauser(msg.sender);
417     }
418 
419     modifier onlyPauser() {
420         require(isPauser(msg.sender));
421         _;
422     }
423 
424     function isPauser(address account) public view returns (bool) {
425         return _pausers.has(account);
426     }
427 
428     function addPauser(address account) public onlyPauser {
429         _addPauser(account);
430     }
431 
432     function renouncePauser() public {
433         _removePauser(msg.sender);
434     }
435 
436     function _addPauser(address account) internal {
437         _pausers.add(account);
438         emit PauserAdded(account);
439     }
440 
441     function _removePauser(address account) internal {
442         _pausers.remove(account);
443         emit PauserRemoved(account);
444     }
445 }
446 
447 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
448 
449 pragma solidity ^0.5.2;
450 
451 
452 /**
453  * @title Pausable
454  * @dev Base contract which allows children to implement an emergency stop mechanism.
455  */
456 contract Pausable is PauserRole {
457     event Paused(address account);
458     event Unpaused(address account);
459 
460     bool private _paused;
461 
462     constructor () internal {
463         _paused = false;
464     }
465 
466     /**
467      * @return true if the contract is paused, false otherwise.
468      */
469     function paused() public view returns (bool) {
470         return _paused;
471     }
472 
473     /**
474      * @dev Modifier to make a function callable only when the contract is not paused.
475      */
476     modifier whenNotPaused() {
477         require(!_paused);
478         _;
479     }
480 
481     /**
482      * @dev Modifier to make a function callable only when the contract is paused.
483      */
484     modifier whenPaused() {
485         require(_paused);
486         _;
487     }
488 
489     /**
490      * @dev called by the owner to pause, triggers stopped state
491      */
492     function pause() public onlyPauser whenNotPaused {
493         _paused = true;
494         emit Paused(msg.sender);
495     }
496 
497     /**
498      * @dev called by the owner to unpause, returns to normal state
499      */
500     function unpause() public onlyPauser whenPaused {
501         _paused = false;
502         emit Unpaused(msg.sender);
503     }
504 }
505 
506 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
507 
508 pragma solidity ^0.5.2;
509 
510 
511 
512 /**
513  * @title Pausable token
514  * @dev ERC20 modified with pausable transfers.
515  */
516 contract ERC20Pausable is ERC20, Pausable {
517     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
518         return super.transfer(to, value);
519     }
520 
521     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
522         return super.transferFrom(from, to, value);
523     }
524 
525     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
526         return super.approve(spender, value);
527     }
528 
529     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
530         return super.increaseAllowance(spender, addedValue);
531     }
532 
533     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
534         return super.decreaseAllowance(spender, subtractedValue);
535     }
536 }
537 
538 // File: contracts/Aria20.sol
539 
540 pragma solidity ^0.5.2;
541 
542 
543 
544 
545 /**
546  * @title Aria20 token
547  *
548  * @dev Implementation of the basic standard token.
549  * https://eips.ethereum.org/EIPS/eip-20
550  *
551  * Using already audited OpenZeppelin functionality of: ERC20, ERC20Detailed, ERC20Pausable and ERC20Burnable tokens
552  */
553 contract Aria20 is ERC20Detailed, ERC20Pausable, ERC20Burnable {
554 
555     // Note: Being a Burnable token the current supply should always be fetch by "totalSupply()" function
556     uint public constant INITIAL_SUPPLY = 200000000 * (10 ** uint (18));
557 
558     /**
559      * Constructor to init token detail parameters and mint the initial and final supply
560      * @param name The display name of the token (Expected: "ARIANEE").
561      * @param symbol The symbol of the token (Expected: "ARIA20").
562      * @param decimals The amount token decimals (Expected: 18).
563      */
564     constructor(
565         string memory name,
566         string memory symbol,
567         uint8 decimals
568     )
569         ERC20Burnable()
570         ERC20Pausable()
571         ERC20Detailed(name, symbol, decimals)
572         public
573     {
574         // Mint initial supply to the token creator
575         _mint(msg.sender, INITIAL_SUPPLY);
576     }
577 
578     /**
579      * Mass distribution function to multi-transfer tokens between received addresses and amounts
580      * @param _recipients The list of addresses to receive tokens
581      * @param _amounts The list amounts of tokens to transfer to each address received
582      * @return A boolean that indicates if the all transfers were successful.
583      */
584     function distributeTokens(address[] memory _recipients, uint256[] memory _amounts) public whenNotPaused returns (bool) {
585         // Optimization: Verify than both lists have the save amount of items
586         require(_recipients.length == _amounts.length);
587 
588         // Optimization: Verify than sender has some tokens to distribute
589         require(balanceOf(msg.sender) > 0);
590 
591         // Iterate over recipients addresses and transfer received amount
592         for (uint i = 0; i < _recipients.length; i++) {
593             require(transfer(_recipients[i], _amounts[i]));
594         }
595 
596         return true;
597     }
598 
599 }