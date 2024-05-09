1 // File: contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
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
27 // File: contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error.
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
48         require(c / a == b, "SafeMath: multiplication overflow");
49 
50         return c;
51     }
52 
53     /**
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0, "SafeMath: division by zero");
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
69         require(b <= a, "SafeMath: subtraction overflow");
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
80         require(c >= a, "SafeMath: addition overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0, "SafeMath: modulo by zero");
91         return a % b;
92     }
93 }
94 
95 // File: contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.0;
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
118     mapping (address => mapping (address => uint256)) private _allowances;
119 
120     uint256 private _totalSupply;
121 
122     /**
123      * @dev Total number of tokens in existence.
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
145         return _allowances[owner][spender];
146     }
147 
148     /**
149      * @dev Transfer token to a specified address.
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
182         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses.
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0), "ERC20: transfer to the zero address");
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
238         require(account != address(0), "ERC20: mint to the zero address");
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
252         require(account != address(0), "ERC20: burn from the zero address");
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
266         require(owner != address(0), "ERC20: approve from the zero address");
267         require(spender != address(0), "ERC20: approve to the zero address");
268 
269         _allowances[owner][spender] = value;
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
283         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: contracts/token/ERC20/ERC20Detailed.sol
288 
289 pragma solidity ^0.5.0;
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
331 // File: contracts/access/Roles.sol
332 
333 pragma solidity ^0.5.0;
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
345      * @dev Give an account access to this role.
346      */
347     function add(Role storage role, address account) internal {
348         require(!has(role, account), "Roles: account already has role");
349         role.bearer[account] = true;
350     }
351 
352     /**
353      * @dev Remove an account's access to this role.
354      */
355     function remove(Role storage role, address account) internal {
356         require(has(role, account), "Roles: account does not have role");
357         role.bearer[account] = false;
358     }
359 
360     /**
361      * @dev Check if an account has this role.
362      * @return bool
363      */
364     function has(Role storage role, address account) internal view returns (bool) {
365         require(account != address(0), "Roles: account is the zero address");
366         return role.bearer[account];
367     }
368 }
369 
370 // File: contracts/access/roles/PauserRole.sol
371 
372 pragma solidity ^0.5.0;
373 
374 
375 contract PauserRole {
376     using Roles for Roles.Role;
377 
378     event PauserAdded(address indexed account);
379     event PauserRemoved(address indexed account);
380 
381     Roles.Role private _pausers;
382 
383     constructor () internal {
384         _addPauser(msg.sender);
385     }
386 
387     modifier onlyPauser() {
388         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
389         _;
390     }
391 
392     function isPauser(address account) public view returns (bool) {
393         return _pausers.has(account);
394     }
395 
396     function addPauser(address account) public onlyPauser {
397         _addPauser(account);
398     }
399 
400     function renouncePauser() public {
401         _removePauser(msg.sender);
402     }
403 
404     function _addPauser(address account) internal {
405         _pausers.add(account);
406         emit PauserAdded(account);
407     }
408 
409     function _removePauser(address account) internal {
410         _pausers.remove(account);
411         emit PauserRemoved(account);
412     }
413 }
414 
415 // File: contracts/lifecycle/Pausable.sol
416 
417 pragma solidity ^0.5.0;
418 
419 
420 /**
421  * @title Pausable
422  * @dev Base contract which allows children to implement an emergency stop mechanism.
423  */
424 contract Pausable is PauserRole {
425     event Paused(address account);
426     event Unpaused(address account);
427 
428     bool private _paused;
429 
430     constructor () internal {
431         _paused = false;
432     }
433 
434     /**
435      * @return True if the contract is paused, false otherwise.
436      */
437     function paused() public view returns (bool) {
438         return _paused;
439     }
440 
441     /**
442      * @dev Modifier to make a function callable only when the contract is not paused.
443      */
444     modifier whenNotPaused() {
445         require(!_paused, "Pausable: paused");
446         _;
447     }
448 
449     /**
450      * @dev Modifier to make a function callable only when the contract is paused.
451      */
452     modifier whenPaused() {
453         require(_paused, "Pausable: not paused");
454         _;
455     }
456 
457     /**
458      * @dev Called by a pauser to pause, triggers stopped state.
459      */
460     function pause() public onlyPauser whenNotPaused {
461         _paused = true;
462         emit Paused(msg.sender);
463     }
464 
465     /**
466      * @dev Called by a pauser to unpause, returns to normal state.
467      */
468     function unpause() public onlyPauser whenPaused {
469         _paused = false;
470         emit Unpaused(msg.sender);
471     }
472 }
473 
474 // File: contracts/token/ERC20/ERC20Pausable.sol
475 
476 pragma solidity ^0.5.0;
477 
478 
479 
480 /**
481  * @title Pausable token
482  * @dev ERC20 modified with pausable transfers.
483  */
484 contract ERC20Pausable is ERC20, Pausable {
485     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
486         return super.transfer(to, value);
487     }
488 
489     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
490         return super.transferFrom(from, to, value);
491     }
492 
493     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
494         return super.approve(spender, value);
495     }
496 
497     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
498         return super.increaseAllowance(spender, addedValue);
499     }
500 
501     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
502         return super.decreaseAllowance(spender, subtractedValue);
503     }
504 }
505 
506 // File: contracts/CA.sol
507 
508 pragma solidity ^0.5.0;
509 
510 
511 
512 
513 contract CA is ERC20, ERC20Detailed, ERC20Pausable {
514     string  public constant NAME = "CA-Chain Token";
515     string  public constant SYMBOL = "CA";
516     uint8   public constant DECIMALS = 18;
517     uint256 public constant TOTAL_SUPPLY = 5000000000 * (10 ** uint256(DECIMALS));
518     constructor(
519     )
520         ERC20()
521         ERC20Detailed(NAME, SYMBOL, DECIMALS)
522         ERC20Pausable()
523         public 
524     {
525         _mint(msg.sender, TOTAL_SUPPLY);
526     }
527 
528 	/**
529 	 * 批量转账
530 	 */
531 	function batchTransfer(address[] memory _receivers, uint256 _value) 
532 	public
533 	whenNotPaused  
534 	returns (bool) {
535 		uint _count = _receivers.length;
536 		uint256 _amount = _value.mul(uint(_count));
537 		require(_count > 0 && _count <= 20);
538 		require(_value > 0 && balanceOf(msg.sender) >= _amount);
539 
540         for (uint i = 0; i < _count; i++) {
541             _transfer(msg.sender, _receivers[i], _value);
542         }
543         return true;
544     }
545 }