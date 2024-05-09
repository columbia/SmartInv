1 pragma solidity ^0.5.2;
2 
3 
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 contract MinterRole {
45     using Roles for Roles.Role;
46 
47     event MinterAdded(address indexed account);
48     event MinterRemoved(address indexed account);
49 
50     Roles.Role private _minters;
51 
52     constructor () internal {
53         _addMinter(msg.sender);
54     }
55 
56     modifier onlyMinter() {
57         require(isMinter(msg.sender));
58         _;
59     }
60 
61     function isMinter(address account) public view returns (bool) {
62         return _minters.has(account);
63     }
64 
65     function addMinter(address account) public onlyMinter {
66         _addMinter(account);
67     }
68 
69     function renounceMinter() public {
70         _removeMinter(msg.sender);
71     }
72 
73     function _addMinter(address account) internal {
74         _minters.add(account);
75         emit MinterAdded(account);
76     }
77 
78     function _removeMinter(address account) internal {
79         _minters.remove(account);
80         emit MinterRemoved(account);
81     }
82 }
83 
84 contract PauserRole {
85     using Roles for Roles.Role;
86 
87     event PauserAdded(address indexed account);
88     event PauserRemoved(address indexed account);
89 
90     Roles.Role private _pausers;
91 
92     constructor () internal {
93         _addPauser(msg.sender);
94     }
95 
96     modifier onlyPauser() {
97         require(isPauser(msg.sender));
98         _;
99     }
100 
101     function isPauser(address account) public view returns (bool) {
102         return _pausers.has(account);
103     }
104 
105     function addPauser(address account) public onlyPauser {
106         _addPauser(account);
107     }
108 
109     function renouncePauser() public {
110         _removePauser(msg.sender);
111     }
112 
113     function _addPauser(address account) internal {
114         _pausers.add(account);
115         emit PauserAdded(account);
116     }
117 
118     function _removePauser(address account) internal {
119         _pausers.remove(account);
120         emit PauserRemoved(account);
121     }
122 }
123 
124 /**
125  * @title Pausable
126  * @dev Base contract which allows children to implement an emergency stop mechanism.
127  */
128 contract Pausable is PauserRole {
129     event Paused(address account);
130     event Unpaused(address account);
131 
132     bool private _paused;
133 
134     constructor () internal {
135         _paused = false;
136     }
137 
138     /**
139      * @return true if the contract is paused, false otherwise.
140      */
141     function paused() public view returns (bool) {
142         return _paused;
143     }
144 
145     /**
146      * @dev Modifier to make a function callable only when the contract is not paused.
147      */
148     modifier whenNotPaused() {
149         require(!_paused);
150         _;
151     }
152 
153     /**
154      * @dev Modifier to make a function callable only when the contract is paused.
155      */
156     modifier whenPaused() {
157         require(_paused);
158         _;
159     }
160 
161     /**
162      * @dev called by the owner to pause, triggers stopped state
163      */
164     function pause() public onlyPauser whenNotPaused {
165         _paused = true;
166         emit Paused(msg.sender);
167     }
168 
169     /**
170      * @dev called by the owner to unpause, returns to normal state
171      */
172     function unpause() public onlyPauser whenPaused {
173         _paused = false;
174         emit Unpaused(msg.sender);
175     }
176 }
177 
178 /**
179  * @title SafeMath
180  * @dev Unsigned math operations with safety checks that revert on error
181  */
182 library SafeMath {
183     /**
184     * @dev Multiplies two unsigned integers, reverts on overflow.
185     */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b);
196 
197         return c;
198     }
199 
200     /**
201     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
202     */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         // Solidity only automatically asserts when dividing by 0
205         require(b > 0);
206         uint256 c = a / b;
207         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208 
209         return c;
210     }
211 
212     /**
213     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
214     */
215     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216         require(b <= a);
217         uint256 c = a - b;
218 
219         return c;
220     }
221 
222     /**
223     * @dev Adds two unsigned integers, reverts on overflow.
224     */
225     function add(uint256 a, uint256 b) internal pure returns (uint256) {
226         uint256 c = a + b;
227         require(c >= a);
228 
229         return c;
230     }
231 
232     /**
233     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
234     * reverts when dividing by zero.
235     */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         require(b != 0);
238         return a % b;
239     }
240 }
241 
242 /**
243  * @title ERC20 interface
244  * @dev see https://github.com/ethereum/EIPs/issues/20
245  */
246 interface IERC20 {
247     function transfer(address to, uint256 value) external returns (bool);
248 
249     function approve(address spender, uint256 value) external returns (bool);
250 
251     function transferFrom(address from, address to, uint256 value) external returns (bool);
252 
253     function totalSupply() external view returns (uint256);
254 
255     function balanceOf(address who) external view returns (uint256);
256 
257     function allowance(address owner, address spender) external view returns (uint256);
258 
259     event Transfer(address indexed from, address indexed to, uint256 value);
260 
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 /**
265  * @title SafeERC20
266  * @dev Wrappers around ERC20 operations that throw on failure.
267  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
268  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
269  */
270 library SafeERC20 {
271     using SafeMath for uint256;
272 
273     function safeTransfer(IERC20 token, address to, uint256 value) internal {
274         require(token.transfer(to, value));
275     }
276 
277     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
278         require(token.transferFrom(from, to, value));
279     }
280 
281     function safeApprove(IERC20 token, address spender, uint256 value) internal {
282         // safeApprove should only be called when setting an initial allowance,
283         // or when resetting it to zero. To increase and decrease it, use
284         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
285         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
286         require(token.approve(spender, value));
287     }
288 
289     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
290         uint256 newAllowance = token.allowance(address(this), spender).add(value);
291         require(token.approve(spender, newAllowance));
292     }
293 
294     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
295         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
296         require(token.approve(spender, newAllowance));
297     }
298 }
299 
300 /**
301  * @title ERC20Detailed token
302  * @dev The decimals are only for visualization purposes.
303  * All the operations are done using the smallest and indivisible token unit,
304  * just as on Ethereum all the operations are done in wei.
305  */
306 contract ERC20Detailed is IERC20 {
307     string private _name;
308     string private _symbol;
309     uint8 private _decimals;
310 
311     constructor (string memory name, string memory symbol, uint8 decimals) public {
312         _name = name;
313         _symbol = symbol;
314         _decimals = decimals;
315     }
316 
317     /**
318      * @return the name of the token.
319      */
320     function name() public view returns (string memory) {
321         return _name;
322     }
323 
324     /**
325      * @return the symbol of the token.
326      */
327     function symbol() public view returns (string memory) {
328         return _symbol;
329     }
330 
331     /**
332      * @return the number of decimals of the token.
333      */
334     function decimals() public view returns (uint8) {
335         return _decimals;
336     }
337 }
338 
339 /**
340  * @title Standard ERC20 token
341  *
342  * @dev Implementation of the basic standard token.
343  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
344  * Originally based on code by FirstBlood:
345  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
346  *
347  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
348  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
349  * compliant implementations may not do it.
350  */
351 contract ERC20 is IERC20 {
352     using SafeMath for uint256;
353 
354     mapping (address => uint256) private _balances;
355 
356     mapping (address => mapping (address => uint256)) private _allowed;
357 
358     uint256 private _totalSupply;
359 
360     /**
361     * @dev Total number of tokens in existence
362     */
363     function totalSupply() public view returns (uint256) {
364         return _totalSupply;
365     }
366 
367     /**
368     * @dev Gets the balance of the specified address.
369     * @param owner The address to query the balance of.
370     * @return An uint256 representing the amount owned by the passed address.
371     */
372     function balanceOf(address owner) public view returns (uint256) {
373         return _balances[owner];
374     }
375 
376     /**
377      * @dev Function to check the amount of tokens that an owner allowed to a spender.
378      * @param owner address The address which owns the funds.
379      * @param spender address The address which will spend the funds.
380      * @return A uint256 specifying the amount of tokens still available for the spender.
381      */
382     function allowance(address owner, address spender) public view returns (uint256) {
383         return _allowed[owner][spender];
384     }
385 
386     /**
387     * @dev Transfer token for a specified address
388     * @param to The address to transfer to.
389     * @param value The amount to be transferred.
390     */
391     function transfer(address to, uint256 value) public returns (bool) {
392         _transfer(msg.sender, to, value);
393         return true;
394     }
395 
396     /**
397      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
398      * Beware that changing an allowance with this method brings the risk that someone may use both the old
399      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
400      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
401      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
402      * @param spender The address which will spend the funds.
403      * @param value The amount of tokens to be spent.
404      */
405     function approve(address spender, uint256 value) public returns (bool) {
406         _approve(msg.sender, spender, value);
407         return true;
408     }
409 
410     /**
411      * @dev Transfer tokens from one address to another.
412      * Note that while this function emits an Approval event, this is not required as per the specification,
413      * and other compliant implementations may not emit the event.
414      * @param from address The address which you want to send tokens from
415      * @param to address The address which you want to transfer to
416      * @param value uint256 the amount of tokens to be transferred
417      */
418     function transferFrom(address from, address to, uint256 value) public returns (bool) {
419         _transfer(from, to, value);
420         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
421         return true;
422     }
423 
424     /**
425      * @dev Increase the amount of tokens that an owner allowed to a spender.
426      * approve should be called when allowed_[_spender] == 0. To increment
427      * allowed value is better to use this function to avoid 2 calls (and wait until
428      * the first transaction is mined)
429      * From MonolithDAO Token.sol
430      * Emits an Approval event.
431      * @param spender The address which will spend the funds.
432      * @param addedValue The amount of tokens to increase the allowance by.
433      */
434     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
435         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
436         return true;
437     }
438 
439     /**
440      * @dev Decrease the amount of tokens that an owner allowed to a spender.
441      * approve should be called when allowed_[_spender] == 0. To decrement
442      * allowed value is better to use this function to avoid 2 calls (and wait until
443      * the first transaction is mined)
444      * From MonolithDAO Token.sol
445      * Emits an Approval event.
446      * @param spender The address which will spend the funds.
447      * @param subtractedValue The amount of tokens to decrease the allowance by.
448      */
449     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
450         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
451         return true;
452     }
453 
454     /**
455     * @dev Transfer token for a specified addresses
456     * @param from The address to transfer from.
457     * @param to The address to transfer to.
458     * @param value The amount to be transferred.
459     */
460     function _transfer(address from, address to, uint256 value) internal {
461         require(to != address(0));
462 
463         _balances[from] = _balances[from].sub(value);
464         _balances[to] = _balances[to].add(value);
465         emit Transfer(from, to, value);
466     }
467 
468     /**
469      * @dev Internal function that mints an amount of the token and assigns it to
470      * an account. This encapsulates the modification of balances such that the
471      * proper events are emitted.
472      * @param account The account that will receive the created tokens.
473      * @param value The amount that will be created.
474      */
475     function _mint(address account, uint256 value) internal {
476         require(account != address(0));
477 
478         _totalSupply = _totalSupply.add(value);
479         _balances[account] = _balances[account].add(value);
480         emit Transfer(address(0), account, value);
481     }
482 
483     /**
484      * @dev Internal function that burns an amount of the token of a given
485      * account.
486      * @param account The account whose tokens will be burnt.
487      * @param value The amount that will be burnt.
488      */
489     function _burn(address account, uint256 value) internal {
490         require(account != address(0));
491 
492         _totalSupply = _totalSupply.sub(value);
493         _balances[account] = _balances[account].sub(value);
494         emit Transfer(account, address(0), value);
495     }
496 
497     /**
498      * @dev Approve an address to spend another addresses' tokens.
499      * @param owner The address that owns the tokens.
500      * @param spender The address that will spend the tokens.
501      * @param value The number of tokens that can be spent.
502      */
503     function _approve(address owner, address spender, uint256 value) internal {
504         require(spender != address(0));
505         require(owner != address(0));
506 
507         _allowed[owner][spender] = value;
508         emit Approval(owner, spender, value);
509     }
510 
511     /**
512      * @dev Internal function that burns an amount of the token of a given
513      * account, deducting from the sender's allowance for said account. Uses the
514      * internal burn function.
515      * Emits an Approval event (reflecting the reduced allowance).
516      * @param account The account whose tokens will be burnt.
517      * @param value The amount that will be burnt.
518      */
519     function _burnFrom(address account, uint256 value) internal {
520         _burn(account, value);
521         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
522     }
523 }
524 
525 /**
526  * @title ERC20Mintable
527  * @dev ERC20 minting logic
528  */
529 contract ERC20Mintable is ERC20, MinterRole {
530     /**
531      * @dev Function to mint tokens
532      * @param to The address that will receive the minted tokens.
533      * @param value The amount of tokens to mint.
534      * @return A boolean that indicates if the operation was successful.
535      */
536     function mint(address to, uint256 value) public onlyMinter returns (bool) {
537         _mint(to, value);
538         return true;
539     }
540 }
541 
542 /**
543  * @title Pausable token
544  * @dev ERC20 modified with pausable transfers.
545  **/
546 contract ERC20Pausable is ERC20, Pausable {
547     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
548         return super.transfer(to, value);
549     }
550 
551     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
552         return super.transferFrom(from, to, value);
553     }
554 
555     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
556         return super.approve(spender, value);
557     }
558 
559     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
560         return super.increaseAllowance(spender, addedValue);
561     }
562 
563     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
564         return super.decreaseAllowance(spender, subtractedValue);
565     }
566 }
567 
568 contract SpyBatCoinFixo is ERC20Pausable, ERC20Detailed {
569     
570     using SafeERC20 for ERC20;
571     uint private INITIAL_SUPPLY = 6000000000000000;
572 
573     constructor () public 
574         ERC20Detailed("SpyBatCoin", "SBAT", 6)
575     {
576         _mint(msg.sender, INITIAL_SUPPLY);
577     }
578 }
579 
580 contract SpyBatCoinAumentavel is ERC20Pausable, ERC20Detailed, ERC20Mintable {
581     
582     using SafeERC20 for ERC20;
583     
584     uint private INITIAL_SUPPLY = 6000000000000000;
585 
586     constructor () public 
587         ERC20Detailed("SpyBatCoin", "SBAT", 6)
588     {
589         _mint(msg.sender, INITIAL_SUPPLY);
590     }    
591 }