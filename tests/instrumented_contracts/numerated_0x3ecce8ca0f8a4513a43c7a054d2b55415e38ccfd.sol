1 pragma solidity ^0.5.6;
2 
3 
4 interface IERC20 {
5     function transfer(address to, uint256 value) external returns (bool);
6 
7     function approve(address spender, uint256 value) external returns (bool);
8 
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     /**
24      * @dev Multiplies two unsigned integers, reverts on overflow.
25      */
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36 
37         return c;
38     }
39 
40     /**
41      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
42      */
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         // Solidity only automatically asserts when dividing by 0
45         require(b > 0, "SafeMath: division by zero");
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48 
49         return c;
50     }
51 
52     /**
53      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
54      */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b <= a, "SafeMath: subtraction overflow");
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63      * @dev Adds two unsigned integers, reverts on overflow.
64      */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
74      * reverts when dividing by zero.
75      */
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b != 0, "SafeMath: modulo by zero");
78         return a % b;
79     }
80 }
81 
82 library Roles {
83     struct Role {
84         mapping (address => bool) bearer;
85     }
86 
87     /**
88      * @dev Give an account access to this role.
89      */
90     function add(Role storage role, address account) internal {
91         require(!has(role, account), "Roles: account already has role");
92         role.bearer[account] = true;
93     }
94 
95     /**
96      * @dev Remove an account's access to this role.
97      */
98     function remove(Role storage role, address account) internal {
99         require(has(role, account), "Roles: account does not have role");
100         role.bearer[account] = false;
101     }
102 
103     /**
104      * @dev Check if an account has this role.
105      * @return bool
106      */
107     function has(Role storage role, address account) internal view returns (bool) {
108         require(account != address(0), "Roles: account is the zero address");
109         return role.bearer[account];
110     }
111 }
112 
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
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
145         return _allowed[owner][spender];
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
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
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
269         _allowed[owner][spender] = value;
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
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 contract ERC20Detailed is IERC20 {
288     string private _name;
289     string private _symbol;
290     uint8 private _decimals;
291 
292     constructor (string memory name, string memory symbol, uint8 decimals) public {
293         _name = name;
294         _symbol = symbol;
295         _decimals = decimals;
296     }
297 
298     /**
299      * @return the name of the token.
300      */
301     function name() public view returns (string memory) {
302         return _name;
303     }
304 
305     /**
306      * @return the symbol of the token.
307      */
308     function symbol() public view returns (string memory) {
309         return _symbol;
310     }
311 
312     /**
313      * @return the number of decimals of the token.
314      */
315     function decimals() public view returns (uint8) {
316         return _decimals;
317     }
318 }
319 
320 contract ERC20Burnable is ERC20 {
321     /**
322      * @dev Burns a specific amount of tokens.
323      * @param value The amount of token to be burned.
324      */
325     function burn(uint256 value) public {
326         _burn(msg.sender, value);
327     }
328 
329     /**
330      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
331      * @param from address The account whose tokens will be burned.
332      * @param value uint256 The amount of token to be burned.
333      */
334     function burnFrom(address from, uint256 value) public {
335         _burnFrom(from, value);
336     }
337 }
338 
339 contract MinterRole {
340     using Roles for Roles.Role;
341 
342     event MinterAdded(address indexed account);
343     event MinterRemoved(address indexed account);
344 
345     Roles.Role private _minters;
346 
347     constructor () internal {
348         _addMinter(msg.sender);
349     }
350 
351     modifier onlyMinter() {
352         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
353         _;
354     }
355 
356     function isMinter(address account) public view returns (bool) {
357         return _minters.has(account);
358     }
359 
360     function addMinter(address account) public onlyMinter {
361         _addMinter(account);
362     }
363 
364     function renounceMinter() public {
365         _removeMinter(msg.sender);
366     }
367 
368     function _addMinter(address account) internal {
369         _minters.add(account);
370         emit MinterAdded(account);
371     }
372 
373     function _removeMinter(address account) internal {
374         _minters.remove(account);
375         emit MinterRemoved(account);
376     }
377 }
378 
379 contract PauserRole {
380     using Roles for Roles.Role;
381 
382     event PauserAdded(address indexed account);
383     event PauserRemoved(address indexed account);
384 
385     Roles.Role private _pausers;
386 
387     constructor () internal {
388         _addPauser(msg.sender);
389     }
390 
391     modifier onlyPauser() {
392         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
393         _;
394     }
395 
396     function isPauser(address account) public view returns (bool) {
397         return _pausers.has(account);
398     }
399 
400     function addPauser(address account) public onlyPauser {
401         _addPauser(account);
402     }
403 
404     function renouncePauser() public {
405         _removePauser(msg.sender);
406     }
407 
408     function _addPauser(address account) internal {
409         _pausers.add(account);
410         emit PauserAdded(account);
411     }
412 
413     function _removePauser(address account) internal {
414         _pausers.remove(account);
415         emit PauserRemoved(account);
416     }
417 }
418 
419 contract Pausable is PauserRole {
420     event Paused(address account);
421     event Unpaused(address account);
422 
423     bool private _paused;
424 
425     constructor () internal {
426         _paused = false;
427     }
428 
429     /**
430      * @return True if the contract is paused, false otherwise.
431      */
432     function paused() public view returns (bool) {
433         return _paused;
434     }
435 
436     /**
437      * @dev Modifier to make a function callable only when the contract is not paused.
438      */
439     modifier whenNotPaused() {
440         require(!_paused, "Pausable: paused");
441         _;
442     }
443 
444     /**
445      * @dev Modifier to make a function callable only when the contract is paused.
446      */
447     modifier whenPaused() {
448         require(_paused, "Pausable: not paused");
449         _;
450     }
451 
452     /**
453      * @dev Called by a pauser to pause, triggers stopped state.
454      */
455     function pause() public onlyPauser whenNotPaused {
456         _paused = true;
457         emit Paused(msg.sender);
458     }
459 
460     /**
461      * @dev Called by a pauser to unpause, returns to normal state.
462      */
463     function unpause() public onlyPauser whenPaused {
464         _paused = false;
465         emit Unpaused(msg.sender);
466     }
467 }
468 
469 contract ERC20Pausable is ERC20, Pausable {
470     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
471         return super.transfer(to, value);
472     }
473 
474     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
475         return super.transferFrom(from, to, value);
476     }
477 
478     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
479         return super.approve(spender, value);
480     }
481 
482     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
483         return super.increaseAllowance(spender, addedValue);
484     }
485 
486     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
487         return super.decreaseAllowance(spender, subtractedValue);
488     }
489 }
490 
491 contract ERC20Mintable is ERC20, MinterRole {
492     /**
493      * @dev Function to mint tokens
494      * @param to The address that will receive the minted tokens.
495      * @param value The amount of tokens to mint.
496      * @return A boolean that indicates if the operation was successful.
497      */
498     function mint(address to, uint256 value) public onlyMinter returns (bool) {
499         _mint(to, value);
500         return true;
501     }
502 }
503 
504 contract SimpleToken is ERC20Pausable,ERC20Mintable,ERC20Burnable, ERC20Detailed {
505      //uint8 public constant DECIMALS = 18;
506      uint256 public  INITIAL_SUPPLY = 10000 * (10 ** uint256(18));
507 
508     /**
509      * @dev Constructor that gives msg.sender all of existing tokens.
510      */
511     constructor(string memory name, string memory symbol, uint8  decimals, uint256  initial_supply) public  ERC20Detailed(name, symbol, decimals){
512         
513     
514      
515         INITIAL_SUPPLY = initial_supply * (10 ** uint256(decimals)) ;
516         _mint(msg.sender, INITIAL_SUPPLY);
517     }
518     
519     function () external {
520         revert();
521     }
522 }