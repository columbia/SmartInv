1 pragma solidity ^0.5.2;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9     function transfer(address to, uint256 value) external returns (bool);
10 
11     function approve(address spender, uint256 value) external returns (bool);
12 
13     function transferFrom(address from, address to, uint256 value) external returns (bool);
14 
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address who) external view returns (uint256);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31     * @dev Multiplies two unsigned integers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70     * @dev Adds two unsigned integers, reverts on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81     * reverts when dividing by zero.
82     */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
94  * Originally based on code by FirstBlood:
95  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  *
97  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
98  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
99  * compliant implementations may not do it.
100  */
101 contract ERC20 is IERC20 {
102     using SafeMath for uint256;
103 
104     mapping (address => uint256) private _balances;
105 
106     mapping (address => mapping (address => uint256)) private _allowed;
107 
108     uint256 private _totalSupply;
109 
110     /**
111     * @dev Total number of tokens in existence
112     */
113     function totalSupply() public view returns (uint256) {
114         return _totalSupply;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param owner The address to query the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address owner) public view returns (uint256) {
123         return _balances[owner];
124     }
125 
126     /**
127      * @dev Function to check the amount of tokens that an owner allowed to a spender.
128      * @param owner address The address which owns the funds.
129      * @param spender address The address which will spend the funds.
130      * @return A uint256 specifying the amount of tokens still available for the spender.
131      */
132     function allowance(address owner, address spender) public view returns (uint256) {
133         return _allowed[owner][spender];
134     }
135 
136     /**
137     * @dev Transfer token for a specified address
138     * @param to The address to transfer to.
139     * @param value The amount to be transferred.
140     */
141     function transfer(address to, uint256 value) public returns (bool) {
142         _transfer(msg.sender, to, value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      * @param spender The address which will spend the funds.
153      * @param value The amount of tokens to be spent.
154      */
155     function approve(address spender, uint256 value) public returns (bool) {
156         _approve(msg.sender, spender, value);
157         return true;
158     }
159 
160     /**
161      * @dev Transfer tokens from one address to another.
162      * Note that while this function emits an Approval event, this is not required as per the specification,
163      * and other compliant implementations may not emit the event.
164      * @param from address The address which you want to send tokens from
165      * @param to address The address which you want to transfer to
166      * @param value uint256 the amount of tokens to be transferred
167      */
168     function transferFrom(address from, address to, uint256 value) public returns (bool) {
169         _transfer(from, to, value);
170         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
171         return true;
172     }
173 
174     /**
175      * @dev Increase the amount of tokens that an owner allowed to a spender.
176      * approve should be called when allowed_[_spender] == 0. To increment
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * Emits an Approval event.
181      * @param spender The address which will spend the funds.
182      * @param addedValue The amount of tokens to increase the allowance by.
183      */
184     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
185         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
186         return true;
187     }
188 
189     /**
190      * @dev Decrease the amount of tokens that an owner allowed to a spender.
191      * approve should be called when allowed_[_spender] == 0. To decrement
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * Emits an Approval event.
196      * @param spender The address which will spend the funds.
197      * @param subtractedValue The amount of tokens to decrease the allowance by.
198      */
199     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
200         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
201         return true;
202     }
203 
204     /**
205     * @dev Transfer token for a specified addresses
206     * @param from The address to transfer from.
207     * @param to The address to transfer to.
208     * @param value The amount to be transferred.
209     */
210     function _transfer(address from, address to, uint256 value) internal {
211         require(to != address(0));
212 
213         _balances[from] = _balances[from].sub(value);
214         _balances[to] = _balances[to].add(value);
215         emit Transfer(from, to, value);
216     }
217 
218     /**
219      * @dev Internal function that mints an amount of the token and assigns it to
220      * an account. This encapsulates the modification of balances such that the
221      * proper events are emitted.
222      * @param account The account that will receive the created tokens.
223      * @param value The amount that will be created.
224      */
225     function _mint(address account, uint256 value) internal {
226         require(account != address(0));
227 
228         _totalSupply = _totalSupply.add(value);
229         _balances[account] = _balances[account].add(value);
230         emit Transfer(address(0), account, value);
231     }
232 
233     /**
234      * @dev Internal function that burns an amount of the token of a given
235      * account.
236      * @param account The account whose tokens will be burnt.
237      * @param value The amount that will be burnt.
238      */
239     function _burn(address account, uint256 value) internal {
240         require(account != address(0));
241 
242         _totalSupply = _totalSupply.sub(value);
243         _balances[account] = _balances[account].sub(value);
244         emit Transfer(account, address(0), value);
245     }
246 
247     /**
248      * @dev Approve an address to spend another addresses' tokens.
249      * @param owner The address that owns the tokens.
250      * @param spender The address that will spend the tokens.
251      * @param value The number of tokens that can be spent.
252      */
253     function _approve(address owner, address spender, uint256 value) internal {
254         require(spender != address(0));
255         require(owner != address(0));
256 
257         _allowed[owner][spender] = value;
258         emit Approval(owner, spender, value);
259     }
260 
261     /**
262      * @dev Internal function that burns an amount of the token of a given
263      * account, deducting from the sender's allowance for said account. Uses the
264      * internal burn function.
265      * Emits an Approval event (reflecting the reduced allowance).
266      * @param account The account whose tokens will be burnt.
267      * @param value The amount that will be burnt.
268      */
269     function _burnFrom(address account, uint256 value) internal {
270         _burn(account, value);
271         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
272     }
273 }
274 
275 /**
276  * @title Burnable Token
277  * @dev Token that can be irreversibly burned (destroyed).
278  */
279 contract ERC20Burnable is ERC20 {
280     /**
281      * @dev Burns a specific amount of tokens.
282      * @param value The amount of token to be burned.
283      */
284     function burn(uint256 value) public {
285         _burn(msg.sender, value);
286     }
287 
288     /**
289      * @dev Burns a specific amount of tokens from the target address and decrements allowance
290      * @param from address The address which you want to send tokens from
291      * @param value uint256 The amount of token to be burned
292      */
293     function burnFrom(address from, uint256 value) public {
294         _burnFrom(from, value);
295     }
296 }
297 /**
298  * @title Roles
299  * @dev Library for managing addresses assigned to a Role.
300  */
301 library Roles {
302     struct Role {
303         mapping (address => bool) bearer;
304     }
305 
306     /**
307      * @dev give an account access to this role
308      */
309     function add(Role storage role, address account) internal {
310         require(account != address(0));
311         require(!has(role, account));
312 
313         role.bearer[account] = true;
314     }
315 
316     /**
317      * @dev remove an account's access to this role
318      */
319     function remove(Role storage role, address account) internal {
320         require(account != address(0));
321         require(has(role, account));
322 
323         role.bearer[account] = false;
324     }
325 
326     /**
327      * @dev check if an account has this role
328      * @return bool
329      */
330     function has(Role storage role, address account) internal view returns (bool) {
331         require(account != address(0));
332         return role.bearer[account];
333     }
334 }
335 
336 contract PauserRole {
337     using Roles for Roles.Role;
338 
339     event PauserAdded(address indexed account);
340     event PauserRemoved(address indexed account);
341 
342     Roles.Role private _pausers;
343 
344     constructor () internal {
345         _addPauser(msg.sender);
346     }
347 
348     modifier onlyPauser() {
349         require(isPauser(msg.sender));
350         _;
351     }
352 
353     function isPauser(address account) public view returns (bool) {
354         return _pausers.has(account);
355     }
356 
357     function addPauser(address account) public onlyPauser {
358         _addPauser(account);
359     }
360 
361     function renouncePauser() public {
362         _removePauser(msg.sender);
363     }
364 
365     function _addPauser(address account) internal {
366         _pausers.add(account);
367         emit PauserAdded(account);
368     }
369 
370     function _removePauser(address account) internal {
371         _pausers.remove(account);
372         emit PauserRemoved(account);
373     }
374 }
375 
376 /**
377  * @title Pausable
378  * @dev Base contract which allows children to implement an emergency stop mechanism.
379  */
380 contract Pausable is PauserRole {
381     event Paused(address account);
382     event Unpaused(address account);
383 
384     bool private _paused;
385 
386     constructor () internal {
387         _paused = false;
388     }
389 
390     /**
391      * @return true if the contract is paused, false otherwise.
392      */
393     function paused() public view returns (bool) {
394         return _paused;
395     }
396 
397     /**
398      * @dev Modifier to make a function callable only when the contract is not paused.
399      */
400     modifier whenNotPaused() {
401         require(!_paused);
402         _;
403     }
404 
405     /**
406      * @dev Modifier to make a function callable only when the contract is paused.
407      */
408     modifier whenPaused() {
409         require(_paused);
410         _;
411     }
412 
413     /**
414      * @dev called by the owner to pause, triggers stopped state
415      */
416     function pause() public onlyPauser whenNotPaused {
417         _paused = true;
418         emit Paused(msg.sender);
419     }
420 
421     /**
422      * @dev called by the owner to unpause, returns to normal state
423      */
424     function unpause() public onlyPauser whenPaused {
425         _paused = false;
426         emit Unpaused(msg.sender);
427     }
428 }
429 
430 /**
431  * @title Pausable token
432  * @dev ERC20 modified with pausable transfers.
433  **/
434 contract ERC20Pausable is ERC20, Pausable {
435     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
436         return super.transfer(to, value);
437     }
438 
439     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
440         return super.transferFrom(from, to, value);
441     }
442 
443     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
444         return super.approve(spender, value);
445     }
446 
447     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
448         return super.increaseAllowance(spender, addedValue);
449     }
450 
451     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
452         return super.decreaseAllowance(spender, subtractedValue);
453     }
454 }
455 contract MinterRole {
456     using Roles for Roles.Role;
457 
458     event MinterAdded(address indexed account);
459     event MinterRemoved(address indexed account);
460 
461     Roles.Role private _minters;
462 
463     constructor () internal {
464         _addMinter(msg.sender);
465     }
466 
467     modifier onlyMinter() {
468         require(isMinter(msg.sender));
469         _;
470     }
471 
472     function isMinter(address account) public view returns (bool) {
473         return _minters.has(account);
474     }
475 
476     function addMinter(address account) public onlyMinter {
477         _addMinter(account);
478     }
479 
480     function renounceMinter() public {
481         _removeMinter(msg.sender);
482     }
483 
484     function _addMinter(address account) internal {
485         _minters.add(account);
486         emit MinterAdded(account);
487     }
488 
489     function _removeMinter(address account) internal {
490         _minters.remove(account);
491         emit MinterRemoved(account);
492     }
493 }
494 
495 /**
496  * @title ERC20Mintable
497  * @dev ERC20 minting logic
498  */
499 contract ERC20Mintable is ERC20, MinterRole {
500     /**
501      * @dev Function to mint tokens
502      * @param to The address that will receive the minted tokens.
503      * @param value The amount of tokens to mint.
504      * @return A boolean that indicates if the operation was successful.
505      */
506     function mint(address to, uint256 value) public onlyMinter returns (bool) {
507         _mint(to, value);
508         return true;
509     }
510 }
511 
512 /**
513  * @title Playzone token
514  * @dev The decimals are only for visualization purposes.
515  * All the operations are done using the smallest and indivisible token unit,
516  * just as on Ethereum all the operations are done in wei.
517  */
518 contract Playzone is IERC20, ERC20Burnable, ERC20Pausable, ERC20Mintable {
519     string private _name;
520     string private _symbol;
521     uint8 private _decimals;
522 
523     constructor (string memory name, string memory symbol, uint8 decimals) public {
524         _name = name;
525         _symbol = symbol;
526         _decimals = decimals;
527     }
528 
529     /**
530      * @return the name of the token.
531      */
532     function name() public view returns (string memory) {
533         return _name;
534     }
535 
536     /**
537      * @return the symbol of the token.
538      */
539     function symbol() public view returns (string memory) {
540         return _symbol;
541     }
542 
543     /**
544      * @return the number of decimals of the token.
545      */
546     function decimals() public view returns (uint8) {
547         return _decimals;
548     }
549 }