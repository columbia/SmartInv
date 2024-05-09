1 pragma solidity >=0.5.0 <0.6.0;
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
25 
26 
27 
28 /**
29  * @title SafeMath
30  * @dev Unsigned math operations with safety checks that revert on error
31  */
32 library SafeMath {
33     /**
34     * @dev Multiplies two unsigned integers, reverts on overflow.
35     */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b);
46 
47         return c;
48     }
49 
50     /**
51     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
52     */
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Solidity only automatically asserts when dividing by 0
55         require(b > 0);
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     /**
63     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b <= a);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73     * @dev Adds two unsigned integers, reverts on overflow.
74     */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a);
78 
79         return c;
80     }
81 
82     /**
83     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
84     * reverts when dividing by zero.
85     */
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         require(b != 0);
88         return a % b;
89     }
90 }
91 
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
98  * Originally based on code by FirstBlood:
99  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  *
101  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
102  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
103  * compliant implementations may not do it.
104  */
105 contract ERC20 is IERC20 {
106     using SafeMath for uint256;
107 
108     mapping (address => uint256) private _balances;
109 
110     mapping (address => mapping (address => uint256)) private _allowed;
111 
112     uint256 private _totalSupply;
113 
114     /**
115     * @dev Total number of tokens in existence
116     */
117     function totalSupply() public view returns (uint256) {
118         return _totalSupply;
119     }
120 
121     /**
122     * @dev Gets the balance of the specified address.
123     * @param owner The address to query the balance of.
124     * @return An uint256 representing the amount owned by the passed address.
125     */
126     function balanceOf(address owner) public view returns (uint256) {
127         return _balances[owner];
128     }
129 
130     /**
131      * @dev Function to check the amount of tokens that an owner allowed to a spender.
132      * @param owner address The address which owns the funds.
133      * @param spender address The address which will spend the funds.
134      * @return A uint256 specifying the amount of tokens still available for the spender.
135      */
136     function allowance(address owner, address spender) public view returns (uint256) {
137         return _allowed[owner][spender];
138     }
139 
140     /**
141     * @dev Transfer token for a specified address
142     * @param to The address to transfer to.
143     * @param value The amount to be transferred.
144     */
145     function transfer(address to, uint256 value) public returns (bool) {
146         _transfer(msg.sender, to, value);
147         return true;
148     }
149 
150     /**
151      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152      * Beware that changing an allowance with this method brings the risk that someone may use both the old
153      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      * @param spender The address which will spend the funds.
157      * @param value The amount of tokens to be spent.
158      */
159     function approve(address spender, uint256 value) public returns (bool) {
160         require(spender != address(0));
161 
162         _allowed[msg.sender][spender] = value;
163         emit Approval(msg.sender, spender, value);
164         return true;
165     }
166 
167     /**
168      * @dev Transfer tokens from one address to another.
169      * Note that while this function emits an Approval event, this is not required as per the specification,
170      * and other compliant implementations may not emit the event.
171      * @param from address The address which you want to send tokens from
172      * @param to address The address which you want to transfer to
173      * @param value uint256 the amount of tokens to be transferred
174      */
175     function transferFrom(address from, address to, uint256 value) public returns (bool) {
176         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
177         _transfer(from, to, value);
178         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
179         return true;
180     }
181 
182     /**
183      * @dev Increase the amount of tokens that an owner allowed to a spender.
184      * approve should be called when allowed_[_spender] == 0. To increment
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * Emits an Approval event.
189      * @param spender The address which will spend the funds.
190      * @param addedValue The amount of tokens to increase the allowance by.
191      */
192     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
193         require(spender != address(0));
194 
195         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
196         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
197         return true;
198     }
199 
200     /**
201      * @dev Decrease the amount of tokens that an owner allowed to a spender.
202      * approve should be called when allowed_[_spender] == 0. To decrement
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * Emits an Approval event.
207      * @param spender The address which will spend the funds.
208      * @param subtractedValue The amount of tokens to decrease the allowance by.
209      */
210     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
211         require(spender != address(0));
212 
213         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
214         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
215         return true;
216     }
217 
218     /**
219     * @dev Transfer token for a specified addresses
220     * @param from The address to transfer from.
221     * @param to The address to transfer to.
222     * @param value The amount to be transferred.
223     */
224     function _transfer(address from, address to, uint256 value) internal {
225         require(to != address(0));
226 
227         _balances[from] = _balances[from].sub(value);
228         _balances[to] = _balances[to].add(value);
229         emit Transfer(from, to, value);
230     }
231 
232     /**
233      * @dev Internal function that mints an amount of the token and assigns it to
234      * an account. This encapsulates the modification of balances such that the
235      * proper events are emitted.
236      * @param account The account that will receive the created tokens.
237      * @param value The amount that will be created.
238      */
239     function _mint(address account, uint256 value) internal {
240         require(account != address(0));
241 
242         _totalSupply = _totalSupply.add(value);
243         _balances[account] = _balances[account].add(value);
244         emit Transfer(address(0), account, value);
245     }
246 
247     /**
248      * @dev Internal function that burns an amount of the token of a given
249      * account.
250      * @param account The account whose tokens will be burnt.
251      * @param value The amount that will be burnt.
252      */
253     function _burn(address account, uint256 value) internal {
254         require(account != address(0));
255 
256         _totalSupply = _totalSupply.sub(value);
257         _balances[account] = _balances[account].sub(value);
258         emit Transfer(account, address(0), value);
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
270         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
271         _burn(account, value);
272         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
273     }
274 }
275 
276 /**
277  * @title Roles
278  * @dev Library for managing addresses assigned to a Role.
279  */
280 library Roles {
281     struct Role {
282         mapping (address => bool) bearer;
283     }
284 
285     /**
286      * @dev give an account access to this role
287      */
288     function add(Role storage role, address account) internal {
289         require(account != address(0));
290         require(!has(role, account));
291 
292         role.bearer[account] = true;
293     }
294 
295     /**
296      * @dev remove an account's access to this role
297      */
298     function remove(Role storage role, address account) internal {
299         require(account != address(0));
300         require(has(role, account));
301 
302         role.bearer[account] = false;
303     }
304 
305     /**
306      * @dev check if an account has this role
307      * @return bool
308      */
309     function has(Role storage role, address account) internal view returns (bool) {
310         require(account != address(0));
311         return role.bearer[account];
312     }
313 }
314 
315 
316 contract PauserRole {
317     using Roles for Roles.Role;
318 
319     event PauserAdded(address indexed account);
320     event PauserRemoved(address indexed account);
321 
322     Roles.Role private _pausers;
323 
324     constructor () internal {
325         _addPauser(msg.sender);
326     }
327 
328     modifier onlyPauser() {
329         require(isPauser(msg.sender));
330         _;
331     }
332 
333     function isPauser(address account) public view returns (bool) {
334         return _pausers.has(account);
335     }
336 
337     function addPauser(address account) public onlyPauser {
338         _addPauser(account);
339     }
340 
341     function renouncePauser() public {
342         _removePauser(msg.sender);
343     }
344 
345     function _addPauser(address account) internal {
346         _pausers.add(account);
347         emit PauserAdded(account);
348     }
349 
350     function _removePauser(address account) internal {
351         _pausers.remove(account);
352         emit PauserRemoved(account);
353     }
354 }
355 
356 
357 /**
358  * @title Pausable
359  * @dev Base contract which allows children to implement an emergency stop mechanism.
360  */
361 contract Pausable is PauserRole {
362     event Paused(address account);
363     event Unpaused(address account);
364 
365     bool private _paused;
366 
367     constructor () internal {
368         _paused = false;
369     }
370 
371     /**
372      * @return true if the contract is paused, false otherwise.
373      */
374     function paused() public view returns (bool) {
375         return _paused;
376     }
377 
378     /**
379      * @dev Modifier to make a function callable only when the contract is not paused.
380      */
381     modifier whenNotPaused() {
382         require(!_paused);
383         _;
384     }
385 
386     /**
387      * @dev Modifier to make a function callable only when the contract is paused.
388      */
389     modifier whenPaused() {
390         require(_paused);
391         _;
392     }
393 
394     /**
395      * @dev called by the owner to pause, triggers stopped state
396      */
397     function pause() public onlyPauser whenNotPaused {
398         _paused = true;
399         emit Paused(msg.sender);
400     }
401 
402     /**
403      * @dev called by the owner to unpause, returns to normal state
404      */
405     function unpause() public onlyPauser whenPaused {
406         _paused = false;
407         emit Unpaused(msg.sender);
408     }
409 }
410 
411 
412 /**
413  * @title Pausable token
414  * @dev ERC20 modified with pausable transfers.
415  **/
416 contract ERC20Pausable is ERC20, Pausable {
417     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
418         return super.transfer(to, value);
419     }
420 
421     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
422         return super.transferFrom(from, to, value);
423     }
424 
425     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
426         return super.approve(spender, value);
427     }
428 
429     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
430         return super.increaseAllowance(spender, addedValue);
431     }
432 
433     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
434         return super.decreaseAllowance(spender, subtractedValue);
435     }
436 }
437 
438 /**
439  * @title ERC20Detailed token
440  * @dev The decimals are only for visualization purposes.
441  * All the operations are done using the smallest and indivisible token unit,
442  * just as on Ethereum all the operations are done in wei.
443  */
444 contract ERC20Detailed is IERC20 {
445     string private _name;
446     string private _symbol;
447     uint8 private _decimals;
448 
449     constructor (string memory name, string memory symbol, uint8 decimals) public {
450         _name = name;
451         _symbol = symbol;
452         _decimals = decimals;
453     }
454 
455     /**
456      * @return the name of the token.
457      */
458     function name() public view returns (string memory) {
459         return _name;
460     }
461 
462     /**
463      * @return the symbol of the token.
464      */
465     function symbol() public view returns (string memory) {
466         return _symbol;
467     }
468 
469     /**
470      * @return the number of decimals of the token.
471      */
472     function decimals() public view returns (uint8) {
473         return _decimals;
474     }
475 }
476 
477 
478 
479 contract MESGToken is ERC20, ERC20Detailed, ERC20Pausable {
480   constructor(
481     string memory name,
482     string memory symbol,
483     uint8 decimals,
484     uint256 totalSupply
485   )
486     ERC20Detailed(name, symbol, decimals)
487     ERC20Pausable()
488     ERC20()
489     public
490   {
491     require(totalSupply > 0, "totalSupply has to be greater than 0");
492     _mint(msg.sender, totalSupply.mul(10 ** uint256(decimals)));
493   }
494 }