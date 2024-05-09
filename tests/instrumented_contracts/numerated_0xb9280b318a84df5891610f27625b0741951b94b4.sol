1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that revert on error
4  */
5 library SafeMath {
6     int256 constant private INT256_MIN = -2**255;
7 
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Multiplies two signed integers, reverts on overflow.
27     */
28     function mul(int256 a, int256 b) internal pure returns (int256) {
29         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
30         // benefit is lost if 'b' is also tested.
31         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32         if (a == 0) {
33             return 0;
34         }
35 
36         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
37 
38         int256 c = a * b;
39         require(c / a == b);
40 
41         return c;
42     }
43 
44     /**
45     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
46     */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Solidity only automatically asserts when dividing by 0
49         require(b > 0);
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53         return c;
54     }
55 
56     /**
57     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
58     */
59     function div(int256 a, int256 b) internal pure returns (int256) {
60         require(b != 0); // Solidity only automatically asserts when dividing by 0
61         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
62 
63         int256 c = a / b;
64 
65         return c;
66     }
67 
68     /**
69     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
70     */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79     * @dev Subtracts two signed integers, reverts on overflow.
80     */
81     function sub(int256 a, int256 b) internal pure returns (int256) {
82         int256 c = a - b;
83         require((b >= 0 && c <= a) || (b < 0 && c > a));
84 
85         return c;
86     }
87 
88     /**
89     * @dev Adds two unsigned integers, reverts on overflow.
90     */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a);
94 
95         return c;
96     }
97 
98     /**
99     * @dev Adds two signed integers, reverts on overflow.
100     */
101     function add(int256 a, int256 b) internal pure returns (int256) {
102         int256 c = a + b;
103         require((b >= 0 && c >= a) || (b < 0 && c < a));
104 
105         return c;
106     }
107 
108     /**
109     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
110     * reverts when dividing by zero.
111     */
112     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b != 0);
114         return a % b;
115     }
116 }
117 
118 
119 /**
120  * @title Roles
121  * @dev Library for managing addresses assigned to a Role.
122  */
123 library Roles {
124     struct Role {
125         mapping (address => bool) bearer;
126     }
127 
128     /**
129      * @dev give an account access to this role
130      */
131     function add(Role storage role, address account) internal {
132         require(account != address(0));
133         require(!has(role, account));
134 
135         role.bearer[account] = true;
136     }
137 
138     /**
139      * @dev remove an account's access to this role
140      */
141     function remove(Role storage role, address account) internal {
142         require(account != address(0));
143         require(has(role, account));
144 
145         role.bearer[account] = false;
146     }
147 
148     /**
149      * @dev check if an account has this role
150      * @return bool
151      */
152     function has(Role storage role, address account) internal view returns (bool) {
153         require(account != address(0));
154         return role.bearer[account];
155     }
156 }
157 
158 contract MinterRole {
159     using Roles for Roles.Role;
160 
161     event MinterAdded(address indexed account);
162     event MinterRemoved(address indexed account);
163 
164     Roles.Role private _minters;
165 
166     constructor () internal {
167         _addMinter(msg.sender);
168     }
169 
170     modifier onlyMinter() {
171         require(isMinter(msg.sender));
172         _;
173     }
174 
175     function isMinter(address account) public view returns (bool) {
176         return _minters.has(account);
177     }
178 
179     function addMinter(address account) public onlyMinter {
180         _addMinter(account);
181     }
182 
183     function renounceMinter() public {
184         _removeMinter(msg.sender);
185     }
186 
187     function _addMinter(address account) internal {
188         _minters.add(account);
189         emit MinterAdded(account);
190     }
191 
192     function _removeMinter(address account) internal {
193         _minters.remove(account);
194         emit MinterRemoved(account);
195     }
196 }
197 /**
198  * @title ERC20 interface
199  * @dev see https://github.com/ethereum/EIPs/issues/20
200  */
201 interface IERC20 {
202     function totalSupply() external view returns (uint256);
203 
204     function balanceOf(address who) external view returns (uint256);
205 
206     function allowance(address owner, address spender) external view returns (uint256);
207 
208     function transfer(address to, uint256 value) external returns (bool);
209 
210     function approve(address spender, uint256 value) external returns (bool);
211 
212     function transferFrom(address from, address to, uint256 value) external returns (bool);
213 
214     event Transfer(address indexed from, address indexed to, uint256 value);
215 
216     event Approval(address indexed owner, address indexed spender, uint256 value);
217 }
218 
219 contract ERC20 is IERC20 {
220     using SafeMath for uint256;
221 
222     mapping (address => uint256) private _balances;
223 
224     mapping (address => mapping (address => uint256)) private _allowed;
225 
226     uint256 private _totalSupply;
227 
228     /**
229     * @dev Total number of tokens in existence
230     */
231     function totalSupply() public view returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236     * @dev Gets the balance of the specified address.
237     * @param owner The address to query the balance of.
238     * @return An uint256 representing the amount owned by the passed address.
239     */
240     function balanceOf(address owner) public view returns (uint256) {
241         return _balances[owner];
242     }
243 
244     /**
245      * @dev Function to check the amount of tokens that an owner allowed to a spender.
246      * @param owner address The address which owns the funds.
247      * @param spender address The address which will spend the funds.
248      * @return A uint256 specifying the amount of tokens still available for the spender.
249      */
250     function allowance(address owner, address spender) public view returns (uint256) {
251         return _allowed[owner][spender];
252     }
253 
254     /**
255     * @dev Transfer token for a specified address
256     * @param to The address to transfer to.
257     * @param value The amount to be transferred.
258     */
259     function transfer(address to, uint256 value) public returns (bool) {
260         _transfer(msg.sender, to, value);
261         return true;
262     }
263 
264     /**
265      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
266      * Beware that changing an allowance with this method brings the risk that someone may use both the old
267      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
268      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
269      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270      * @param spender The address which will spend the funds.
271      * @param value The amount of tokens to be spent.
272      */
273     function approve(address spender, uint256 value) public returns (bool) {
274         require(spender != address(0));
275 
276         _allowed[msg.sender][spender] = value;
277         emit Approval(msg.sender, spender, value);
278         return true;
279     }
280 
281     /**
282      * @dev Transfer tokens from one address to another.
283      * Note that while this function emits an Approval event, this is not required as per the specification,
284      * and other compliant implementations may not emit the event.
285      * @param from address The address which you want to send tokens from
286      * @param to address The address which you want to transfer to
287      * @param value uint256 the amount of tokens to be transferred
288      */
289     function transferFrom(address from, address to, uint256 value) public returns (bool) {
290         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
291         _transfer(from, to, value);
292         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
293         return true;
294     }
295 
296     /**
297      * @dev Increase the amount of tokens that an owner allowed to a spender.
298      * approve should be called when allowed_[_spender] == 0. To increment
299      * allowed value is better to use this function to avoid 2 calls (and wait until
300      * the first transaction is mined)
301      * From MonolithDAO Token.sol
302      * Emits an Approval event.
303      * @param spender The address which will spend the funds.
304      * @param addedValue The amount of tokens to increase the allowance by.
305      */
306     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
307         require(spender != address(0));
308 
309         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
310         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
311         return true;
312     }
313 
314     /**
315      * @dev Decrease the amount of tokens that an owner allowed to a spender.
316      * approve should be called when allowed_[_spender] == 0. To decrement
317      * allowed value is better to use this function to avoid 2 calls (and wait until
318      * the first transaction is mined)
319      * From MonolithDAO Token.sol
320      * Emits an Approval event.
321      * @param spender The address which will spend the funds.
322      * @param subtractedValue The amount of tokens to decrease the allowance by.
323      */
324     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
325         require(spender != address(0));
326 
327         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
328         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
329         return true;
330     }
331 
332     /**
333     * @dev Transfer token for a specified addresses
334     * @param from The address to transfer from.
335     * @param to The address to transfer to.
336     * @param value The amount to be transferred.
337     */
338     function _transfer(address from, address to, uint256 value) internal {
339         require(to != address(0));
340 
341         _balances[from] = _balances[from].sub(value);
342         _balances[to] = _balances[to].add(value);
343         emit Transfer(from, to, value);
344     }
345 
346     /**
347      * @dev Internal function that mints an amount of the token and assigns it to
348      * an account. This encapsulates the modification of balances such that the
349      * proper events are emitted.
350      * @param account The account that will receive the created tokens.
351      * @param value The amount that will be created.
352      */
353     function _mint(address account, uint256 value) internal {
354         require(account != address(0));
355 
356         _totalSupply = _totalSupply.add(value);
357         _balances[account] = _balances[account].add(value);
358         emit Transfer(address(0), account, value);
359     }
360 
361     /**
362      * @dev Internal function that burns an amount of the token of a given
363      * account.
364      * @param account The account whose tokens will be burnt.
365      * @param value The amount that will be burnt.
366      */
367     function _burn(address account, uint256 value) internal {
368         require(account != address(0));
369 
370         _totalSupply = _totalSupply.sub(value);
371         _balances[account] = _balances[account].sub(value);
372         emit Transfer(account, address(0), value);
373     }
374 
375     /**
376      * @dev Internal function that burns an amount of the token of a given
377      * account, deducting from the sender's allowance for said account. Uses the
378      * internal burn function.
379      * Emits an Approval event (reflecting the reduced allowance).
380      * @param account The account whose tokens will be burnt.
381      * @param value The amount that will be burnt.
382      */
383     function _burnFrom(address account, uint256 value) internal {
384         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
385         _burn(account, value);
386         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
387     }
388 }
389 
390 
391 contract PauserRole {
392     using Roles for Roles.Role;
393 
394     event PauserAdded(address indexed account);
395     event PauserRemoved(address indexed account);
396 
397     Roles.Role private _pausers;
398 
399     constructor () internal {
400         _addPauser(msg.sender);
401     }
402 
403     modifier onlyPauser() {
404         require(isPauser(msg.sender));
405         _;
406     }
407 
408     function isPauser(address account) public view returns (bool) {
409         return _pausers.has(account);
410     }
411 
412     function addPauser(address account) public onlyPauser {
413         _addPauser(account);
414     }
415 
416     function renouncePauser() public {
417         _removePauser(msg.sender);
418     }
419 
420     function _addPauser(address account) internal {
421         _pausers.add(account);
422         emit PauserAdded(account);
423     }
424 
425     function _removePauser(address account) internal {
426         _pausers.remove(account);
427         emit PauserRemoved(account);
428     }
429 }
430 
431 /**
432  * @title Pausable
433  * @dev Base contract which allows children to implement an emergency stop mechanism.
434  */
435 contract Pausable is PauserRole {
436     event Paused(address account);
437     event Unpaused(address account);
438 
439     bool private _paused;
440 
441     constructor () internal {
442         _paused = false;
443     }
444 
445     /**
446      * @return true if the contract is paused, false otherwise.
447      */
448     function paused() public view returns (bool) {
449         return _paused;
450     }
451 
452     /**
453      * @dev Modifier to make a function callable only when the contract is not paused.
454      */
455     modifier whenNotPaused() {
456         require(!_paused);
457         _;
458     }
459 
460     /**
461      * @dev Modifier to make a function callable only when the contract is paused.
462      */
463     modifier whenPaused() {
464         require(_paused);
465         _;
466     }
467 
468     /**
469      * @dev called by the owner to pause, triggers stopped state
470      */
471     function pause() public onlyPauser whenNotPaused {
472         _paused = true;
473         emit Paused(msg.sender);
474     }
475 
476     /**
477      * @dev called by the owner to unpause, returns to normal state
478      */
479     function unpause() public onlyPauser whenPaused {
480         _paused = false;
481         emit Unpaused(msg.sender);
482     }
483 }
484 
485 /**
486  * @title Pausable token
487  * @dev ERC20 modified with pausable transfers.
488  **/
489 contract ERC20Pausable is ERC20, Pausable {
490     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
491         return super.transfer(to, value);
492     }
493 
494     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
495         return super.transferFrom(from, to, value);
496     }
497 
498     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
499         return super.approve(spender, value);
500     }
501 
502     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
503         return super.increaseAllowance(spender, addedValue);
504     }
505 
506     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
507         return super.decreaseAllowance(spender, subtractedValue);
508     }
509 }
510 
511 /**
512  * @title ERC20Mintable
513  * @dev ERC20 minting logic
514  */
515 contract ERC20Mintable is ERC20, MinterRole {
516     /**
517      * @dev Function to mint tokens
518      * @param to The address that will receive the minted tokens.
519      * @param value The amount of tokens to mint.
520      * @return A boolean that indicates if the operation was successful.
521      */
522     function mint(address to, uint256 value) public onlyMinter returns (bool) {
523         _mint(to, value);
524         return true;
525     }
526 }
527 
528 contract MIMI is  ERC20Mintable,ERC20Pausable{
529     string public name;
530     uint8  public decimals;
531     string public symbol;
532     uint256 private _cap;
533 
534     constructor (string memory _name,string memory _symbol,uint8 _decimals) public {
535         decimals = _decimals;
536         name = _name;
537         symbol = _symbol;
538         _cap = 10000000000000000000000000000;
539     }
540 
541     /**
542      * @return the cap for the token minting.
543      */
544     function cap() public view returns (uint256) {
545         return _cap;
546     }
547 
548     function _mint(address account, uint256 value) internal {
549         require(totalSupply().add(value) <= _cap);
550         super._mint(account, value);
551     }    
552   
553 }