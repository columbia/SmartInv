1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-20
3 */
4 
5 pragma solidity 0.5.2;
6 
7 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
8 
9 /**
10  * @title ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/20
12  */
13 interface IERC20 {
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address who) external view returns (uint256);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
32 
33 /**
34  * @title SafeMath
35  * @dev Unsigned math operations with safety checks that revert on error
36  */
37 library SafeMath {
38     /**
39     * @dev Multiplies two unsigned integers, reverts on overflow.
40     */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     /**
56     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
57     */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0);
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     /**
68     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69     */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78     * @dev Adds two unsigned integers, reverts on overflow.
79     */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a);
83 
84         return c;
85     }
86 
87     /**
88     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
89     * reverts when dividing by zero.
90     */
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b != 0);
93         return a % b;
94     }
95 }
96 
97 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
104  * Originally based on code by FirstBlood:
105  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  *
107  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
108  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
109  * compliant implementations may not do it.
110  */
111 contract ERC20 is IERC20 {
112     using SafeMath for uint256;
113 
114     mapping (address => uint256) private _balances;
115 
116     mapping (address => mapping (address => uint256)) private _allowed;
117 
118     uint256 private _totalSupply;
119 
120     /**
121     * @dev Total number of tokens in existence
122     */
123     function totalSupply() public view returns (uint256) {
124         return _totalSupply;
125     }
126 
127     /**
128     * @dev Gets the balance of the specified address.
129     * @param owner The address to query the balance of.
130     * @return An uint256 representing the amount owned by the passed address.
131     */
132     function balanceOf(address owner) public view returns (uint256) {
133         return _balances[owner];
134     }
135 
136     /**
137      * @dev Function to check the amount of tokens that an owner allowed to a spender.
138      * @param owner address The address which owns the funds.
139      * @param spender address The address which will spend the funds.
140      * @return A uint256 specifying the amount of tokens still available for the spender.
141      */
142     function allowance(address owner, address spender) public view returns (uint256) {
143         return _allowed[owner][spender];
144     }
145 
146     /**
147     * @dev Transfer token for a specified address
148     * @param to The address to transfer to.
149     * @param value The amount to be transferred.
150     */
151     function transfer(address to, uint256 value) public returns (bool) {
152         _transfer(msg.sender, to, value);
153         return true;
154     }
155 
156     /**
157      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158      * Beware that changing an allowance with this method brings the risk that someone may use both the old
159      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      * @param spender The address which will spend the funds.
163      * @param value The amount of tokens to be spent.
164      */
165     function approve(address spender, uint256 value) public returns (bool) {
166         require(spender != address(0));
167 
168         _allowed[msg.sender][spender] = value;
169         emit Approval(msg.sender, spender, value);
170         return true;
171     }
172 
173     /**
174      * @dev Transfer tokens from one address to another.
175      * Note that while this function emits an Approval event, this is not required as per the specification,
176      * and other compliant implementations may not emit the event.
177      * @param from address The address which you want to send tokens from
178      * @param to address The address which you want to transfer to
179      * @param value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(address from, address to, uint256 value) public returns (bool) {
182         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
183         _transfer(from, to, value);
184         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
185         return true;
186     }
187 
188     /**
189      * @dev Increase the amount of tokens that an owner allowed to a spender.
190      * approve should be called when allowed_[_spender] == 0. To increment
191      * allowed value is better to use this function to avoid 2 calls (and wait until
192      * the first transaction is mined)
193      * From MonolithDAO Token.sol
194      * Emits an Approval event.
195      * @param spender The address which will spend the funds.
196      * @param addedValue The amount of tokens to increase the allowance by.
197      */
198     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
199         require(spender != address(0));
200 
201         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
202         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
203         return true;
204     }
205 
206     /**
207      * @dev Decrease the amount of tokens that an owner allowed to a spender.
208      * approve should be called when allowed_[_spender] == 0. To decrement
209      * allowed value is better to use this function to avoid 2 calls (and wait until
210      * the first transaction is mined)
211      * From MonolithDAO Token.sol
212      * Emits an Approval event.
213      * @param spender The address which will spend the funds.
214      * @param subtractedValue The amount of tokens to decrease the allowance by.
215      */
216     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
217         require(spender != address(0));
218 
219         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
220         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
221         return true;
222     }
223 
224     /**
225     * @dev Transfer token for a specified addresses
226     * @param from The address to transfer from.
227     * @param to The address to transfer to.
228     * @param value The amount to be transferred.
229     */
230     function _transfer(address from, address to, uint256 value) internal {
231         require(to != address(0));
232 
233         _balances[from] = _balances[from].sub(value);
234         _balances[to] = _balances[to].add(value);
235         emit Transfer(from, to, value);
236     }
237 
238     /**
239      * @dev Internal function that mints an amount of the token and assigns it to
240      * an account. This encapsulates the modification of balances such that the
241      * proper events are emitted.
242      * @param account The account that will receive the created tokens.
243      * @param value The amount that will be created.
244      */
245     function _mint(address account, uint256 value) internal {
246         require(account != address(0));
247 
248         _totalSupply = _totalSupply.add(value);
249         _balances[account] = _balances[account].add(value);
250         emit Transfer(address(0), account, value);
251     }
252 
253     /**
254      * @dev Internal function that burns an amount of the token of a given
255      * account.
256      * @param account The account whose tokens will be burnt.
257      * @param value The amount that will be burnt.
258      */
259     function _burn(address account, uint256 value) internal {
260         require(account != address(0));
261 
262         _totalSupply = _totalSupply.sub(value);
263         _balances[account] = _balances[account].sub(value);
264         emit Transfer(account, address(0), value);
265     }
266 
267     /**
268      * @dev Internal function that burns an amount of the token of a given
269      * account, deducting from the sender's allowance for said account. Uses the
270      * internal burn function.
271      * Emits an Approval event (reflecting the reduced allowance).
272      * @param account The account whose tokens will be burnt.
273      * @param value The amount that will be burnt.
274      */
275     function _burnFrom(address account, uint256 value) internal {
276         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
277         _burn(account, value);
278         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
279     }
280 }
281 
282 // File: openzeppelin-solidity/contracts/access/Roles.sol
283 
284 /**
285  * @title Roles
286  * @dev Library for managing addresses assigned to a Role.
287  */
288 library Roles {
289     struct Role {
290         mapping (address => bool) bearer;
291     }
292 
293     /**
294      * @dev give an account access to this role
295      */
296     function add(Role storage role, address account) internal {
297         require(account != address(0));
298         require(!has(role, account));
299 
300         role.bearer[account] = true;
301     }
302 
303     /**
304      * @dev remove an account's access to this role
305      */
306     function remove(Role storage role, address account) internal {
307         require(account != address(0));
308         require(has(role, account));
309 
310         role.bearer[account] = false;
311     }
312 
313     /**
314      * @dev check if an account has this role
315      * @return bool
316      */
317     function has(Role storage role, address account) internal view returns (bool) {
318         require(account != address(0));
319         return role.bearer[account];
320     }
321 }
322 
323 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
324 
325 contract PauserRole {
326     using Roles for Roles.Role;
327 
328     event PauserAdded(address indexed account);
329     event PauserRemoved(address indexed account);
330 
331     Roles.Role private _pausers;
332 
333     constructor () internal {
334         _addPauser(msg.sender);
335     }
336 
337     modifier onlyPauser() {
338         require(isPauser(msg.sender));
339         _;
340     }
341 
342     function isPauser(address account) public view returns (bool) {
343         return _pausers.has(account);
344     }
345 
346     function addPauser(address account) public onlyPauser {
347         _addPauser(account);
348     }
349 
350     function renouncePauser() public {
351         _removePauser(msg.sender);
352     }
353 
354     function _addPauser(address account) internal {
355         _pausers.add(account);
356         emit PauserAdded(account);
357     }
358 
359     function _removePauser(address account) internal {
360         _pausers.remove(account);
361         emit PauserRemoved(account);
362     }
363 }
364 
365 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
366 
367 /**
368  * @title Pausable
369  * @dev Base contract which allows children to implement an emergency stop mechanism.
370  */
371 contract Pausable is PauserRole {
372     event Paused(address account);
373     event Unpaused(address account);
374 
375     bool private _paused;
376 
377     constructor () internal {
378         _paused = false;
379     }
380 
381     /**
382      * @return true if the contract is paused, false otherwise.
383      */
384     function paused() public view returns (bool) {
385         return _paused;
386     }
387 
388     /**
389      * @dev Modifier to make a function callable only when the contract is not paused.
390      */
391     modifier whenNotPaused() {
392         require(!_paused);
393         _;
394     }
395 
396     /**
397      * @dev Modifier to make a function callable only when the contract is paused.
398      */
399     modifier whenPaused() {
400         require(_paused);
401         _;
402     }
403 
404     /**
405      * @dev called by the owner to pause, triggers stopped state
406      */
407     function pause() public onlyPauser whenNotPaused {
408         _paused = true;
409         emit Paused(msg.sender);
410     }
411 
412     /**
413      * @dev called by the owner to unpause, returns to normal state
414      */
415     function unpause() public onlyPauser whenPaused {
416         _paused = false;
417         emit Unpaused(msg.sender);
418     }
419 }
420 
421 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
422 
423 /**
424  * @title Pausable token
425  * @dev ERC20 modified with pausable transfers.
426  **/
427 contract ERC20Pausable is ERC20, Pausable {
428     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
429         return super.transfer(to, value);
430     }
431 
432     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
433         return super.transferFrom(from, to, value);
434     }
435 
436     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
437         return super.approve(spender, value);
438     }
439 
440     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
441         return super.increaseAllowance(spender, addedValue);
442     }
443 
444     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
445         return super.decreaseAllowance(spender, subtractedValue);
446     }
447 }
448 
449 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
450 
451 /**
452  * @title ERC20Detailed token
453  * @dev The decimals are only for visualization purposes.
454  * All the operations are done using the smallest and indivisible token unit,
455  * just as on Ethereum all the operations are done in wei.
456  */
457 contract ERC20Detailed is IERC20 {
458     string private _name;
459     string private _symbol;
460     uint8 private _decimals;
461 
462     constructor (string memory name, string memory symbol, uint8 decimals) public {
463         _name = name;
464         _symbol = symbol;
465         _decimals = decimals;
466     }
467 
468     /**
469      * @return the name of the token.
470      */
471     function name() public view returns (string memory) {
472         return _name;
473     }
474 
475     /**
476      * @return the symbol of the token.
477      */
478     function symbol() public view returns (string memory) {
479         return _symbol;
480     }
481 
482     /**
483      * @return the number of decimals of the token.
484      */
485     function decimals() public view returns (uint8) {
486         return _decimals;
487     }
488 }
489 
490 // File: contracts/DeerExToken.sol
491 
492 contract DeerExToken is ERC20Pausable, ERC20Detailed {
493     constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply)
494     public
495     ERC20Detailed (name, symbol, decimals) {
496         _mint(msg.sender, totalSupply);
497     }
498 }