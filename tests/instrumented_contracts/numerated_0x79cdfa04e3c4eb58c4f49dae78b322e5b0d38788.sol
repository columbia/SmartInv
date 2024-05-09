1 pragma solidity 0.5.2;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
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
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35     * @dev Multiplies two unsigned integers, reverts on overflow.
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53     */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Adds two unsigned integers, reverts on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85     * reverts when dividing by zero.
86     */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
100  * Originally based on code by FirstBlood:
101  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  *
103  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
104  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
105  * compliant implementations may not do it.
106  */
107 contract ERC20 is IERC20 {
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) private _balances;
111 
112     mapping (address => mapping (address => uint256)) private _allowed;
113 
114     uint256 private _totalSupply;
115 
116     /**
117     * @dev Total number of tokens in existence
118     */
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param owner The address to query the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address owner) public view returns (uint256) {
129         return _balances[owner];
130     }
131 
132     /**
133      * @dev Function to check the amount of tokens that an owner allowed to a spender.
134      * @param owner address The address which owns the funds.
135      * @param spender address The address which will spend the funds.
136      * @return A uint256 specifying the amount of tokens still available for the spender.
137      */
138     function allowance(address owner, address spender) public view returns (uint256) {
139         return _allowed[owner][spender];
140     }
141 
142     /**
143     * @dev Transfer token for a specified address
144     * @param to The address to transfer to.
145     * @param value The amount to be transferred.
146     */
147     function transfer(address to, uint256 value) public returns (bool) {
148         _transfer(msg.sender, to, value);
149         return true;
150     }
151 
152     /**
153      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param spender The address which will spend the funds.
159      * @param value The amount of tokens to be spent.
160      */
161     function approve(address spender, uint256 value) public returns (bool) {
162         require(spender != address(0));
163 
164         _allowed[msg.sender][spender] = value;
165         emit Approval(msg.sender, spender, value);
166         return true;
167     }
168 
169     /**
170      * @dev Transfer tokens from one address to another.
171      * Note that while this function emits an Approval event, this is not required as per the specification,
172      * and other compliant implementations may not emit the event.
173      * @param from address The address which you want to send tokens from
174      * @param to address The address which you want to transfer to
175      * @param value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address from, address to, uint256 value) public returns (bool) {
178         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
179         _transfer(from, to, value);
180         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
181         return true;
182     }
183 
184     
185     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
186         require(spender != address(0));
187 
188         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
189         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
190         return true;
191     }
192 
193     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
194         require(spender != address(0));
195 
196         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
197         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
198         return true;
199     }
200 
201     /**
202     * @dev Transfer token for a specified addresses
203     * @param from The address to transfer from.
204     * @param to The address to transfer to.
205     * @param value The amount to be transferred.
206     */
207     function _transfer(address from, address to, uint256 value) internal {
208         require(to != address(0));
209 
210         _balances[from] = _balances[from].sub(value);
211         _balances[to] = _balances[to].add(value);
212         emit Transfer(from, to, value);
213     }
214 
215     /**
216      * @dev Internal function that mints an amount of the token and assigns it to
217      * an account. This encapsulates the modification of balances such that the
218      * proper events are emitted.
219      * @param account The account that will receive the created tokens.
220      * @param value The amount that will be created.
221      */
222     function _mint(address account, uint256 value) internal {
223         require(account != address(0));
224 
225         _totalSupply = _totalSupply.add(value);
226         _balances[account] = _balances[account].add(value);
227         emit Transfer(address(0), account, value);
228     }
229 
230     /**
231      * @dev Internal function that burns an amount of the token of a given
232      * account.
233      * @param account The account whose tokens will be burnt.
234      * @param value The amount that will be burnt.
235      */
236     function _burn(address account, uint256 value) internal {
237         require(account != address(0));
238 
239         _totalSupply = _totalSupply.sub(value);
240         _balances[account] = _balances[account].sub(value);
241         emit Transfer(account, address(0), value);
242     }
243 
244     /**
245      * @dev Internal function that burns an amount of the token of a given
246      * account, deducting from the sender's allowance for said account. Uses the
247      * internal burn function.
248      * Emits an Approval event (reflecting the reduced allowance).
249      * @param account The account whose tokens will be burnt.
250      * @param value The amount that will be burnt.
251      */
252     function _burnFrom(address account, uint256 value) internal {
253         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
254         _burn(account, value);
255         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
256     }
257 }
258 
259 // File: openzeppelin-solidity/contracts/access/Roles.sol
260 
261 /**
262  * @title Roles
263  * @dev Library for managing addresses assigned to a Role.
264  */
265 library Roles {
266     struct Role {
267         mapping (address => bool) bearer;
268     }
269 
270     /**
271      * @dev give an account access to this role
272      */
273     function add(Role storage role, address account) internal {
274         require(account != address(0));
275         require(!has(role, account));
276 
277         role.bearer[account] = true;
278     }
279 
280     /**
281      * @dev remove an account's access to this role
282      */
283     function remove(Role storage role, address account) internal {
284         require(account != address(0));
285         require(has(role, account));
286 
287         role.bearer[account] = false;
288     }
289 
290     /**
291      * @dev check if an account has this role
292      * @return bool
293      */
294     function has(Role storage role, address account) internal view returns (bool) {
295         require(account != address(0));
296         return role.bearer[account];
297     }
298 }
299 
300 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
301 
302 contract PauserRole {
303     using Roles for Roles.Role;
304 
305     event PauserAdded(address indexed account);
306     event PauserRemoved(address indexed account);
307 
308     Roles.Role private _pausers;
309 
310     constructor () internal {
311         _addPauser(msg.sender);
312     }
313 
314     modifier onlyPauser() {
315         require(isPauser(msg.sender));
316         _;
317     }
318 
319     function isPauser(address account) public view returns (bool) {
320         return _pausers.has(account);
321     }
322 
323     function addPauser(address account) public onlyPauser {
324         _addPauser(account);
325     }
326 
327     function renouncePauser() public {
328         _removePauser(msg.sender);
329     }
330 
331     function _addPauser(address account) internal {
332         _pausers.add(account);
333         emit PauserAdded(account);
334     }
335 
336     function _removePauser(address account) internal {
337         _pausers.remove(account);
338         emit PauserRemoved(account);
339     }
340 }
341 
342 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
343 
344 /**
345  * @title Pausable
346  * @dev Base contract which allows children to implement an emergency stop mechanism.
347  */
348 contract Pausable is PauserRole {
349     event Paused(address account);
350     event Unpaused(address account);
351 
352     bool private _paused;
353 
354     constructor () internal {
355         _paused = false;
356     }
357 
358     /**
359      * @return true if the contract is paused, false otherwise.
360      */
361     function paused() public view returns (bool) {
362         return _paused;
363     }
364 
365     /**
366      * @dev Modifier to make a function callable only when the contract is not paused.
367      */
368     modifier whenNotPaused() {
369         require(!_paused);
370         _;
371     }
372 
373     /**
374      * @dev Modifier to make a function callable only when the contract is paused.
375      */
376     modifier whenPaused() {
377         require(_paused);
378         _;
379     }
380 
381     /**
382      * @dev called by the owner to pause, triggers stopped state
383      */
384     function pause() public onlyPauser whenNotPaused {
385         _paused = true;
386         emit Paused(msg.sender);
387     }
388 
389     /**
390      * @dev called by the owner to unpause, returns to normal state
391      */
392     function unpause() public onlyPauser whenPaused {
393         _paused = false;
394         emit Unpaused(msg.sender);
395     }
396 }
397 
398 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
399 
400 /**
401  * @title Pausable token
402  * @dev ERC20 modified with pausable transfers.
403  **/
404 contract ERC20Pausable is ERC20, Pausable {
405     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
406         return super.transfer(to, value);
407     }
408 
409     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
410         return super.transferFrom(from, to, value);
411     }
412 
413     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
414         return super.approve(spender, value);
415     }
416 
417     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
418         return super.increaseAllowance(spender, addedValue);
419     }
420 
421     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
422         return super.decreaseAllowance(spender, subtractedValue);
423     }
424 }
425 
426 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
427 
428 /**
429  * @title ERC20Detailed token
430  * @dev The decimals are only for visualization purposes.
431  * All the operations are done using the smallest and indivisible token unit,
432  * just as on Ethereum all the operations are done in wei.
433  */
434 contract ERC20Detailed is IERC20 {
435     string private _name;
436     string private _symbol;
437     uint8 private _decimals;
438 
439     constructor (string memory name, string memory symbol, uint8 decimals) public {
440         _name = name;
441         _symbol = symbol;
442         _decimals = decimals;
443     }
444 
445     /**
446      * @return the name of the token.
447      */
448     function name() public view returns (string memory) {
449         return _name;
450     }
451 
452     /**
453      * @return the symbol of the token.
454      */
455     function symbol() public view returns (string memory) {
456         return _symbol;
457     }
458 
459     /**
460      * @return the number of decimals of the token.
461      */
462     function decimals() public view returns (uint8) {
463         return _decimals;
464     }
465 }
466 
467 // File: contracts/TrueFeedBack.sol
468 
469 contract TrueFeedBack is ERC20Pausable, ERC20Detailed {
470     constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply)
471     public
472     ERC20Detailed (name, symbol, decimals) {
473         _mint(msg.sender, totalSupply);
474     }
475 }