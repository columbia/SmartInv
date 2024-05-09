1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-18
3 */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Sunday, April 28, 2019
7  (UTC) */
8 
9 pragma solidity ^0.5.7;
10 
11 
12 /**
13  * @title ERC20 interface
14  * @dev see https://eips.ethereum.org/EIPS/eip-20
15  */
16 interface IERC20 {
17     function transfer(address to, uint256 value) external returns (bool);
18 
19     function approve(address spender, uint256 value) external returns (bool);
20 
21     function transferFrom(address from, address to, uint256 value) external returns (bool);
22 
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address who) external view returns (uint256);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32     
33     event Freeze(address indexed from, uint256 value);
34     
35     event Unfreeze(address indexed from, uint256 value);
36 }
37 
38 
39 
40 /**
41  * @title SafeMath
42  * @dev Unsigned math operations with safety checks that revert on error.
43  */
44 library SafeMath {
45     /**
46      * @dev Multiplies two unsigned integers, reverts on overflow.
47      */
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50         // benefit is lost if 'b' is also tested.
51         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b);
58 
59         return c;
60     }
61 
62     /**
63      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
64      */
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
75      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76      */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         require(b <= a);
79         uint256 c = a - b;
80 
81         return c;
82     }
83 
84     /**
85      * @dev Adds two unsigned integers, reverts on overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a);
90 
91         return c;
92     }
93 
94     /**
95      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
96      * reverts when dividing by zero.
97      */
98     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99         require(b != 0);
100         return a % b;
101     }
102 }
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * https://eips.ethereum.org/EIPS/eip-20
109  * Originally based on code by FirstBlood:
110  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  *
112  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
113  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
114  * compliant implementations may not do it.
115  */
116 contract ERC20 is IERC20 {
117     using SafeMath for uint256;
118 
119     mapping (address => uint256) private _balances;
120 
121     mapping (address => mapping (address => uint256)) private _allowed;
122     
123     mapping (address => uint256) private _freezeOf;
124     
125     uint256 private _totalSupply;
126 
127     /**
128      * @dev Total number of tokens in existence.
129      */
130     function totalSupply() public view returns (uint256) {
131         return _totalSupply;
132     }
133 
134     /**
135      * @dev Gets the balance of the specified address.
136      * @param owner The address to query the balance of.
137      * @return A uint256 representing the amount owned by the passed address.
138      */
139     function balanceOf(address owner) public view returns (uint256) {
140         return _balances[owner];
141     }
142     
143     /**
144      * @dev Gets the balance of the specified freeze address.
145      * @param owner The address to query the balance of.
146      * @return A uint256 representing the amount owned by the freeze address.
147      */
148     function freezeOf(address owner) public view returns (uint256) {
149         return _freezeOf[owner];
150     }
151 
152     /**
153      * @dev Function to check the amount of tokens that an owner allowed to a spender.
154      * @param owner address The address which owns the funds.
155      * @param spender address The address which will spend the funds.
156      * @return A uint256 specifying the amount of tokens still available for the spender.
157      */
158     function allowance(address owner, address spender) public view returns (uint256) {
159         return _allowed[owner][spender];
160     }
161 
162     /**
163      * @dev Transfer token to a specified address.
164      * @param to The address to transfer to.
165      * @param value The amount to be transferred.
166      */
167     function transfer(address to, uint256 value) public returns (bool) {
168         _transfer(msg.sender, to, value);
169         return true;
170     }
171 
172     /**
173      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174      * Beware that changing an allowance with this method brings the risk that someone may use both the old
175      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      * @param spender The address which will spend the funds.
179      * @param value The amount of tokens to be spent.
180      */
181     function approve(address spender, uint256 value) public returns (bool) {
182         _approve(msg.sender, spender, value);
183         return true;
184     }
185 
186     /**
187      * @dev Transfer tokens from one address to another.
188      * Note that while this function emits an Approval event, this is not required as per the specification,
189      * and other compliant implementations may not emit the event.
190      * @param from address The address which you want to send tokens from
191      * @param to address The address which you want to transfer to
192      * @param value uint256 the amount of tokens to be transferred
193      */
194     function transferFrom(address from, address to, uint256 value) public returns (bool) {
195         _transfer(from, to, value);
196         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
197         return true;
198     }
199 
200     /**
201      * @dev Increase the amount of tokens that an owner allowed to a spender.
202      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * Emits an Approval event.
207      * @param spender The address which will spend the funds.
208      * @param addedValue The amount of tokens to increase the allowance by.
209      */
210     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
211         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
212         return true;
213     }
214 
215     /**
216      * @dev Decrease the amount of tokens that an owner allowed to a spender.
217      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
218      * allowed value is better to use this function to avoid 2 calls (and wait until
219      * the first transaction is mined)
220      * From MonolithDAO Token.sol
221      * Emits an Approval event.
222      * @param spender The address which will spend the funds.
223      * @param subtractedValue The amount of tokens to decrease the allowance by.
224      */
225     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
226         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
227         return true;
228     }
229 
230     /**
231      * @dev Transfer token for a specified addresses.
232      * @param from The address to transfer from.
233      * @param to The address to transfer to.
234      * @param value The amount to be transferred.
235      */
236     function _transfer(address from, address to, uint256 value) internal {
237         require(to != address(0));
238 
239         _balances[from] = _balances[from].sub(value);
240         _balances[to] = _balances[to].add(value);
241         emit Transfer(from, to, value);
242     }
243 
244     /**
245      * @dev Internal function that mints an amount of the token and assigns it to
246      * an account. This encapsulates the modification of balances such that the
247      * proper events are emitted.
248      * @param account The account that will receive the created tokens.
249      * @param value The amount that will be created.
250      */
251     function _mint(address account, uint256 value) internal {
252         require(account != address(0));
253         _totalSupply = _totalSupply.add(value);
254         _balances[account] = _balances[account].add(value);
255         emit Transfer(address(0), account, value);
256     }
257 
258     /**
259      * @dev Internal function that burns an amount of the token of a given
260      * account.
261      * @param account The account whose tokens will be burnt.
262      * @param value The amount that will be burnt.
263      */
264     function _burn(address account, uint256 value) internal {
265         require(account != address(0));
266         
267         _totalSupply = _totalSupply.sub(value);
268         _balances[account] = _balances[account].sub(value);
269         emit Transfer(account, address(0), value);
270     }
271     
272     function _freeze(uint256 value) internal {
273         require(_balances[msg.sender]>=value); // Check if the sender has enough
274         require(value > 0);
275         _balances[msg.sender] = _balances[msg.sender].sub(value);
276         _freezeOf[msg.sender] = _freezeOf[msg.sender].add(value);
277         emit Freeze(msg.sender, value);
278     }
279     
280     function _unfreeze(uint256 value) internal{
281         require(_freezeOf[msg.sender]>=value); 
282 		require(value > 0);
283         _freezeOf[msg.sender] = _freezeOf[msg.sender].sub(value); 
284 		_balances[msg.sender] = _balances[msg.sender].add(value);
285         emit Unfreeze(msg.sender, value);
286 
287     }
288     
289     /**
290      * @dev Approve an address to spend another addresses' tokens.
291      * @param owner The address that owns the tokens.
292      * @param spender The address that will spend the tokens.
293      * @param value The number of tokens that can be spent.
294      */
295     function _approve(address owner, address spender, uint256 value) internal {
296         require(spender != address(0));
297         require(owner != address(0));
298 
299         _allowed[owner][spender] = value;
300         emit Approval(owner, spender, value);
301     }
302 
303 }
304 
305 
306 /**
307  * @title ERC20Detailed token
308  * @dev The decimals are only for visualization purposes.
309  * All the operations are done using the smallest and indivisible token unit,
310  * just as on Ethereum all the operations are done in wei.
311  */
312 contract ERC20Detailed is IERC20 {
313     string private _name;
314     string private _symbol;
315     uint8 private _decimals;
316 
317     constructor (string memory name, string memory symbol, uint8 decimals) public {
318         _name = name;
319         _symbol = symbol;
320         _decimals = decimals;
321     }
322 
323     /**
324      * @return the name of the token.
325      */
326     function name() public view returns (string memory) {
327         return _name;
328     }
329 
330     /**
331      * @return the symbol of the token.
332      */
333     function symbol() public view returns (string memory) {
334         return _symbol;
335     }
336 
337     /**
338      * @return the number of decimals of the token.
339      */
340     function decimals() public view returns (uint8) {
341         return _decimals;
342     }
343 }
344 
345 /**
346  * @title Roles
347  * @dev Library for managing addresses assigned to a Role.
348  */
349 library Roles {
350     struct Role {
351         mapping (address => bool) bearer;
352     }
353 
354     /**
355      * @dev Give an account access to this role.
356      */
357     function add(Role storage role, address account) internal {
358         require(!has(role, account));
359 
360         role.bearer[account] = true;
361     }
362 
363     /**
364      * @dev Remove an account's access to this role.
365      */
366     function remove(Role storage role, address account) internal {
367         require(has(role, account));
368 
369         role.bearer[account] = false;
370     }
371 
372     /**
373      * @dev Check if an account has this role.
374      * @return bool
375      */
376     function has(Role storage role, address account) internal view returns (bool) {
377         require(account != address(0));
378         return role.bearer[account];
379     }
380 }
381 
382 
383 contract PauserRole {
384     using Roles for Roles.Role;
385 
386     event PauserAdded(address indexed account);
387     event PauserRemoved(address indexed account);
388 
389     Roles.Role private _pausers;
390 
391     constructor () internal {
392         _addPauser(msg.sender);
393     }
394 
395     modifier onlyPauser() {
396         require(isPauser(msg.sender));
397         _;
398     }
399 
400     function isPauser(address account) public view returns (bool) {
401         return _pausers.has(account);
402     }
403 
404     function addPauser(address account) public onlyPauser {
405         _addPauser(account);
406     }
407 
408     function renouncePauser() public {
409         _removePauser(msg.sender);
410     }
411 
412     function _addPauser(address account) internal {
413         _pausers.add(account);
414         emit PauserAdded(account);
415     }
416 
417     function _removePauser(address account) internal {
418         _pausers.remove(account);
419         emit PauserRemoved(account);
420     }
421 }
422 
423 
424 
425 /**
426  * @title Pausable
427  * @dev Base contract which allows children to implement an emergency stop mechanism.
428  */
429 contract Pausable is PauserRole {
430     event Paused(address account);
431     event Unpaused(address account);
432 
433     bool private _paused;
434 
435     constructor () internal {
436         _paused = false;
437     }
438 
439     /**
440      * @return True if the contract is paused, false otherwise.
441      */
442     function paused() public view returns (bool) {
443         return _paused;
444     }
445 
446     /**
447      * @dev Modifier to make a function callable only when the contract is not paused.
448      */
449     modifier whenNotPaused() {
450         require(!_paused);
451         _;
452     }
453 
454     /**
455      * @dev Modifier to make a function callable only when the contract is paused.
456      */
457     modifier whenPaused() {
458         require(_paused);
459         _;
460     }
461 
462     /**
463      * @dev Called by a pauser to pause, triggers stopped state.
464      */
465     function pause() public onlyPauser whenNotPaused {
466         _paused = true;
467         emit Paused(msg.sender);
468     }
469 
470     /**
471      * @dev Called by a pauser to unpause, returns to normal state.
472      */
473     function unpause() public onlyPauser whenPaused {
474         _paused = false;
475         emit Unpaused(msg.sender);
476     }
477 }
478 
479 /**
480  * @title Pausable
481  * @dev Base contract which allows children to implement an emergency stop mechanism.
482  */
483 contract Lockable is PauserRole{
484     
485 
486     mapping (address => bool) private lockers;
487     
488 
489     event LockAccount(address account, bool islock);
490     
491     
492     /**
493      * @dev Check if the account is locked.
494      * @param account specific account address.
495      */
496     function isLock(address account) public view returns (bool) {
497         return lockers[account];
498     }
499     
500     /**
501      * @dev Lock or thaw account address
502      * @param account specific account address.
503      * @param islock true lock, false thaw.
504      */
505     function lock(address account, bool islock)  public onlyPauser {
506         lockers[account] = islock;
507         emit LockAccount(account, islock);
508     }
509     
510 }
511 
512 
513 
514 
515 /**
516  * @title Pausable token
517  * @dev ERC20 modified with pausable transfers. 
518  */
519 contract ERC20Pausable is ERC20, Pausable,Lockable {
520     
521     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
522         require(!isLock(msg.sender));
523         require(!isLock(to));
524         return super.transfer(to, value);
525     }
526 
527     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
528         require(!isLock(msg.sender));
529         require(!isLock(from));
530         require(!isLock(to));
531         return super.transferFrom(from, to, value);
532     }
533 
534     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
535         require(!isLock(msg.sender));
536         require(!isLock(spender));
537         return super.approve(spender, value);
538     }
539 
540     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
541         require(!isLock(msg.sender));
542         require(!isLock(spender));
543         return super.increaseAllowance(spender, addedValue);
544     }
545 
546     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
547         require(!isLock(msg.sender));
548         require(!isLock(spender));
549         return super.decreaseAllowance(spender, subtractedValue);
550     }
551 }
552 
553 
554 contract AGT is ERC20, ERC20Detailed, ERC20Pausable {
555     
556     constructor(string memory name, string memory symbol, uint8 decimals,uint256 _totalSupply) ERC20Pausable()  ERC20Detailed(name, symbol, decimals) ERC20() public {
557         require(_totalSupply > 0);
558         _mint(msg.sender, _totalSupply);
559     }
560     
561     /**
562      * @dev Burns a specific amount of tokens.
563      * @param value The amount of token to be burned.
564      */
565     function burn(uint256 value) public whenNotPaused {
566         require(!isLock(msg.sender));
567         _burn(msg.sender, value);
568     }
569     
570     /**
571      * @dev Freeze a specific amount of tokens.
572      * @param value The amount of token to be Freeze.
573      */
574     function freeze(uint256 value) public whenNotPaused {
575         require(!isLock(msg.sender));
576         _freeze(value);
577     }
578     
579         /**
580      * @dev unFreeze a specific amount of tokens.
581      * @param value The amount of token to be unFreeze.
582      */
583     function unfreeze(uint256 value) public whenNotPaused {
584         require(!isLock(msg.sender));
585         _unfreeze(value);
586     }
587     
588 }