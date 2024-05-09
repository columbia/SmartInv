1 pragma solidity 0.5.0;
2 // rsm
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     /**
23     * @dev Multiplies two unsigned integers, reverts on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b);
35 
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
53     */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b <= a);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     /**
62     * @dev Adds two unsigned integers, reverts on overflow.
63     */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a);
67 
68         return c;
69     }
70 
71     /**
72     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
73     * reverts when dividing by zero.
74     */
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79 }
80 
81 library Roles {
82     struct Role {
83         mapping(address => bool) bearer;
84     }
85 
86     /**
87      * @dev give an account access to this role
88      */
89     function add(Role storage role, address account) internal {
90         require(account != address(0));
91         require(!has(role, account));
92 
93         role.bearer[account] = true;
94     }
95 
96     /**
97      * @dev remove an account's access to this role
98      */
99     function remove(Role storage role, address account) internal {
100         require(account != address(0));
101         require(has(role, account));
102 
103         role.bearer[account] = false;
104     }
105 
106     /**
107      * @dev check if an account has this role
108      * @return bool
109      */
110     function has(Role storage role, address account) internal view returns (bool) {
111         require(account != address(0));
112         return role.bearer[account];
113     }
114 }
115 
116 contract MinterRole {
117     using Roles for Roles.Role;
118 
119     event MinterAdded(address indexed account);
120     event MinterRemoved(address indexed account);
121 
122     Roles.Role private _minters;
123 
124     constructor () internal {
125         _addMinter(msg.sender);
126     }
127 
128     modifier onlyMinter() {
129         require(isMinter(msg.sender));
130         _;
131     }
132 
133     function isMinter(address account) public view returns (bool) {
134         return _minters.has(account);
135     }
136 
137     function addMinter(address account) public onlyMinter {
138         _addMinter(account);
139     }
140 
141     function renounceMinter() public {
142         _removeMinter(msg.sender);
143     }
144 
145     function _addMinter(address account) internal {
146         _minters.add(account);
147         emit MinterAdded(account);
148     }
149 
150     function _removeMinter(address account) internal {
151         _minters.remove(account);
152         emit MinterRemoved(account);
153     }
154 }
155 
156 contract ERC20 is IERC20 {
157     using SafeMath for uint256;
158 
159     mapping(address => uint256) private _balances;
160 
161     mapping(address => mapping(address => uint256)) private _allowed;
162 
163     uint256 private _totalSupply;
164 
165     /**
166     * @dev Total number of tokens in existence
167     */
168     function totalSupply() public view returns (uint256) {
169         return _totalSupply;
170     }
171 
172     /**
173     * @dev Gets the balance of the specified address.
174     * @param owner The address to query the balance of.
175     * @return An uint256 representing the amount owned by the passed address.
176     */
177     function balanceOf(address owner) public view returns (uint256) {
178         return _balances[owner];
179     }
180 
181     /**
182      * @dev Function to check the amount of tokens that an owner allowed to a spender.
183      * @param owner address The address which owns the funds.
184      * @param spender address The address which will spend the funds.
185      * @return A uint256 specifying the amount of tokens still available for the spender.
186      */
187     function allowance(address owner, address spender) public view returns (uint256) {
188         return _allowed[owner][spender];
189     }
190 
191     /**
192     * @dev Transfer token for a specified address
193     * @param to The address to transfer to.
194     * @param value The amount to be transferred.
195     */
196     function transfer(address to, uint256 value) public returns (bool) {
197         _transfer(msg.sender, to, value);
198         return true;
199     }
200 
201     /**
202      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203      * Beware that changing an allowance with this method brings the risk that someone may use both the old
204      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207      * @param spender The address which will spend the funds.
208      * @param value The amount of tokens to be spent.
209      */
210     function approve(address spender, uint256 value) public returns (bool) {
211         require(spender != address(0));
212 
213         _allowed[msg.sender][spender] = value;
214         emit Approval(msg.sender, spender, value);
215         return true;
216     }
217 
218     /**
219      * @dev Transfer tokens from one address to another.
220      * Note that while this function emits an Approval event, this is not required as per the specification,
221      * and other compliant implementations may not emit the event.
222      * @param from address The address which you want to send tokens from
223      * @param to address The address which you want to transfer to
224      * @param value uint256 the amount of tokens to be transferred
225      */
226     function transferFrom(address from, address to, uint256 value) public returns (bool) {
227         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
228         _transfer(from, to, value);
229         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
230         return true;
231     }
232 
233     /**
234      * @dev Increase the amount of tokens that an owner allowed to a spender.
235      * approve should be called when allowed_[_spender] == 0. To increment
236      * allowed value is better to use this function to avoid 2 calls (and wait until
237      * the first transaction is mined)
238      * From MonolithDAO Token.sol
239      * Emits an Approval event.
240      * @param spender The address which will spend the funds.
241      * @param addedValue The amount of tokens to increase the allowance by.
242      */
243     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
244         require(spender != address(0));
245 
246         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
247         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
248         return true;
249     }
250 
251     /**
252      * @dev Decrease the amount of tokens that an owner allowed to a spender.
253      * approve should be called when allowed_[_spender] == 0. To decrement
254      * allowed value is better to use this function to avoid 2 calls (and wait until
255      * the first transaction is mined)
256      * From MonolithDAO Token.sol
257      * Emits an Approval event.
258      * @param spender The address which will spend the funds.
259      * @param subtractedValue The amount of tokens to decrease the allowance by.
260      */
261     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
262         require(spender != address(0));
263 
264         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
265         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
266         return true;
267     }
268 
269     /**
270     * @dev Transfer token for a specified addresses
271     * @param from The address to transfer from.
272     * @param to The address to transfer to.
273     * @param value The amount to be transferred.
274     */
275     function _transfer(address from, address to, uint256 value) internal {
276         require(to != address(0));
277 
278         _balances[from] = _balances[from].sub(value);
279         _balances[to] = _balances[to].add(value);
280         emit Transfer(from, to, value);
281     }
282 
283     /**
284      * @dev Internal function that mints an amount of the token and assigns it to
285      * an account. This encapsulates the modification of balances such that the
286      * proper events are emitted.
287      * @param account The account that will receive the created tokens.
288      * @param value The amount that will be created.
289      */
290     function _mint(address account, uint256 value) internal {
291         require(account != address(0));
292 
293         _totalSupply = _totalSupply.add(value);
294         _balances[account] = _balances[account].add(value);
295         emit Transfer(address(0), account, value);
296     }
297 
298     /**
299      * @dev Internal function that burns an amount of the token of a given
300      * account.
301      * @param account The account whose tokens will be burnt.
302      * @param value The amount that will be burnt.
303      */
304     function _burn(address account, uint256 value) internal {
305         require(account != address(0));
306 
307         _totalSupply = _totalSupply.sub(value);
308         _balances[account] = _balances[account].sub(value);
309         emit Transfer(account, address(0), value);
310     }
311 
312     /**
313      * @dev Internal function that burns an amount of the token of a given
314      * account, deducting from the sender's allowance for said account. Uses the
315      * internal burn function.
316      * Emits an Approval event (reflecting the reduced allowance).
317      * @param account The account whose tokens will be burnt.
318      * @param value The amount that will be burnt.
319      */
320     function _burnFrom(address account, uint256 value) internal {
321         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
322         _burn(account, value);
323         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
324     }
325 }
326 
327 contract ERC20Detailed is IERC20 {
328     string private _name;
329     string private _symbol;
330     uint8 private _decimals;
331 
332     constructor (string memory name, string memory symbol, uint8 decimals) public {
333         _name = name;
334         _symbol = symbol;
335         _decimals = decimals;
336     }
337 
338     /**
339      * @return the name of the token.
340      */
341     function name() public view returns (string memory) {
342         return _name;
343     }
344 
345     /**
346      * @return the symbol of the token.
347      */
348     function symbol() public view returns (string memory) {
349         return _symbol;
350     }
351 
352     /**
353      * @return the number of decimals of the token.
354      */
355     function decimals() public view returns (uint8) {
356         return _decimals;
357     }
358 }
359 
360 contract PauserRole {
361     using Roles for Roles.Role;
362 
363     event PauserAdded(address indexed account);
364     event PauserRemoved(address indexed account);
365 
366     Roles.Role private _pausers;
367 
368     constructor () internal {
369         _addPauser(msg.sender);
370     }
371 
372     modifier onlyPauser() {
373         require(isPauser(msg.sender));
374         _;
375     }
376 
377     function isPauser(address account) public view returns (bool) {
378         return _pausers.has(account);
379     }
380 
381     function addPauser(address account) public onlyPauser {
382         _addPauser(account);
383     }
384 
385     function renouncePauser() public {
386         _removePauser(msg.sender);
387     }
388 
389     function _addPauser(address account) internal {
390         _pausers.add(account);
391         emit PauserAdded(account);
392     }
393 
394     function _removePauser(address account) internal {
395         _pausers.remove(account);
396         emit PauserRemoved(account);
397     }
398 }
399 
400 contract ERC20Burnable is ERC20 {
401     /**
402      * @dev Burns a specific amount of tokens.
403      * @param value The amount of token to be burned.
404      */
405     function burn(uint256 value) public {
406         _burn(msg.sender, value);
407     }
408 
409     /**
410      * @dev Burns a specific amount of tokens from the target address and decrements allowance
411      * @param from address The address which you want to send tokens from
412      * @param value uint256 The amount of token to be burned
413      */
414     function burnFrom(address from, uint256 value) public {
415         _burnFrom(from, value);
416     }
417 }
418 
419 contract ERC20Mintable is ERC20, MinterRole {
420     /**
421      * @dev Function to mint tokens
422      * @param to The address that will receive the minted tokens.
423      * @param value The amount of tokens to mint.
424      * @return A boolean that indicates if the operation was successful.
425      */
426     function mint(address to, uint256 value) public onlyMinter returns (bool) {
427         _mint(to, value);
428         return true;
429     }
430 }
431 
432 contract Pausable is PauserRole {
433     event Paused(address account);
434     event Unpaused(address account);
435 
436     bool private _paused;
437 
438     constructor () internal {
439         _paused = false;
440     }
441 
442     /**
443      * @return true if the contract is paused, false otherwise.
444      */
445     function paused() public view returns (bool) {
446         return _paused;
447     }
448 
449     /**
450      * @dev Modifier to make a function callable only when the contract is not paused.
451      */
452     modifier whenNotPaused() {
453         require(!_paused);
454         _;
455     }
456 
457     /**
458      * @dev Modifier to make a function callable only when the contract is paused.
459      */
460     modifier whenPaused() {
461         require(_paused);
462         _;
463     }
464 
465     /**
466      * @dev called by the owner to pause, triggers stopped state
467      */
468     function pause() public onlyPauser whenNotPaused {
469         _paused = true;
470         emit Paused(msg.sender);
471     }
472 
473     /**
474      * @dev called by the owner to unpause, returns to normal state
475      */
476     function unpause() public onlyPauser whenPaused {
477         _paused = false;
478         emit Unpaused(msg.sender);
479     }
480 }
481 
482 contract ERC20Pausable is ERC20, Pausable {
483     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
484         return super.transfer(to, value);
485     }
486 
487     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
488         return super.transferFrom(from, to, value);
489     }
490 
491     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
492         return super.approve(spender, value);
493     }
494 
495     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
496         return super.increaseAllowance(spender, addedValue);
497     }
498 
499     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
500         return super.decreaseAllowance(spender, subtractedValue);
501     }
502 }
503 
504 contract BRZToken is ERC20, ERC20Pausable, ERC20Detailed, ERC20Mintable, ERC20Burnable {
505 
506     constructor(
507         string memory name,
508         string memory symbol,
509         uint8 decimals
510     )
511     ERC20Burnable()
512     ERC20Mintable()
513     ERC20Detailed(name, symbol, decimals)
514     ERC20()
515     public
516     {}
517 }