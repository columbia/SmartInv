1 pragma solidity 0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
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
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Roles
69  * @dev Library for managing addresses assigned to a Role.
70  */
71 library Roles {
72     struct Role {
73         mapping (address => bool) bearer;
74     }
75 
76     /**
77      * @dev give an account access to this role
78      */
79     function add(Role storage role, address account) internal {
80         require(account != address(0));
81         require(!has(role, account));
82 
83         role.bearer[account] = true;
84     }
85 
86     /**
87      * @dev remove an account's access to this role
88      */
89     function remove(Role storage role, address account) internal {
90         require(account != address(0));
91         require(has(role, account));
92 
93         role.bearer[account] = false;
94     }
95 
96     /**
97      * @dev check if an account has this role
98      * @return bool
99      */
100     function has(Role storage role, address account) internal view returns (bool) {
101         require(account != address(0));
102         return role.bearer[account];
103     }
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 interface IERC20 {
111     function transfer(address to, uint256 value) external returns (bool);
112 
113     function approve(address spender, uint256 value) external returns (bool);
114 
115     function transferFrom(address from, address to, uint256 value) external returns (bool);
116 
117     function totalSupply() external view returns (uint256);
118 
119     function balanceOf(address who) external view returns (uint256);
120 
121     function allowance(address owner, address spender) external view returns (uint256);
122 
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
133  * Originally based on code by FirstBlood:
134  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  *
136  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
137  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
138  * compliant implementations may not do it.
139  */
140 contract ERC20 is IERC20 {
141     using SafeMath for uint256;
142 
143     mapping (address => uint256) private _balances;
144 
145     mapping (address => mapping (address => uint256)) private _allowed;
146 
147     uint256 private _totalSupply;
148 
149     /**
150      * @dev Total number of tokens in existence
151      */
152     function totalSupply() public view returns (uint256) {
153         return _totalSupply;
154     }
155 
156     /**
157      * @dev Gets the balance of the specified address.
158      * @param owner The address to query the balance of.
159      * @return An uint256 representing the amount owned by the passed address.
160      */
161     function balanceOf(address owner) public view returns (uint256) {
162         return _balances[owner];
163     }
164 
165     /**
166      * @dev Function to check the amount of tokens that an owner allowed to a spender.
167      * @param owner address The address which owns the funds.
168      * @param spender address The address which will spend the funds.
169      * @return A uint256 specifying the amount of tokens still available for the spender.
170      */
171     function allowance(address owner, address spender) public view returns (uint256) {
172         return _allowed[owner][spender];
173     }
174 
175     /**
176      * @dev Transfer token for a specified address
177      * @param to The address to transfer to.
178      * @param value The amount to be transferred.
179      */
180     function transfer(address to, uint256 value) public returns (bool) {
181         _transfer(msg.sender, to, value);
182         return true;
183     }
184 
185     /**
186      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187      * Beware that changing an allowance with this method brings the risk that someone may use both the old
188      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      * @param spender The address which will spend the funds.
192      * @param value The amount of tokens to be spent.
193      */
194     function approve(address spender, uint256 value) public returns (bool) {
195         _approve(msg.sender, spender, value);
196         return true;
197     }
198 
199     /**
200      * @dev Transfer tokens from one address to another.
201      * Note that while this function emits an Approval event, this is not required as per the specification,
202      * and other compliant implementations may not emit the event.
203      * @param from address The address which you want to send tokens from
204      * @param to address The address which you want to transfer to
205      * @param value uint256 the amount of tokens to be transferred
206      */
207     function transferFrom(address from, address to, uint256 value) public returns (bool) {
208         _transfer(from, to, value);
209         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
210         return true;
211     }
212 
213     /**
214      * @dev Increase the amount of tokens that an owner allowed to a spender.
215      * approve should be called when allowed_[_spender] == 0. To increment
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      * Emits an Approval event.
220      * @param spender The address which will spend the funds.
221      * @param addedValue The amount of tokens to increase the allowance by.
222      */
223     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
224         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
225         return true;
226     }
227 
228     /**
229      * @dev Decrease the amount of tokens that an owner allowed to a spender.
230      * approve should be called when allowed_[_spender] == 0. To decrement
231      * allowed value is better to use this function to avoid 2 calls (and wait until
232      * the first transaction is mined)
233      * From MonolithDAO Token.sol
234      * Emits an Approval event.
235      * @param spender The address which will spend the funds.
236      * @param subtractedValue The amount of tokens to decrease the allowance by.
237      */
238     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
239         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
240         return true;
241     }
242 
243     /**
244      * @dev Transfer token for a specified addresses
245      * @param from The address to transfer from.
246      * @param to The address to transfer to.
247      * @param value The amount to be transferred.
248      */
249     function _transfer(address from, address to, uint256 value) internal {
250         require(to != address(0));
251 
252         _balances[from] = _balances[from].sub(value);
253         _balances[to] = _balances[to].add(value);
254         emit Transfer(from, to, value);
255     }
256 
257     /**
258      * @dev Internal function that mints an amount of the token and assigns it to
259      * an account. This encapsulates the modification of balances such that the
260      * proper events are emitted.
261      * @param account The account that will receive the created tokens.
262      * @param value The amount that will be created.
263      */
264     function _mint(address account, uint256 value) internal {
265         require(account != address(0));
266 
267         _totalSupply = _totalSupply.add(value);
268         _balances[account] = _balances[account].add(value);
269         emit Transfer(address(0), account, value);
270     }
271 
272     /**
273      * @dev Internal function that burns an amount of the token of a given
274      * account.
275      * @param account The account whose tokens will be burnt.
276      * @param value The amount that will be burnt.
277      */
278     function _burn(address account, uint256 value) internal {
279         require(account != address(0));
280 
281         _totalSupply = _totalSupply.sub(value);
282         _balances[account] = _balances[account].sub(value);
283         emit Transfer(account, address(0), value);
284     }
285 
286     /**
287      * @dev Approve an address to spend another addresses' tokens.
288      * @param owner The address that owns the tokens.
289      * @param spender The address that will spend the tokens.
290      * @param value The number of tokens that can be spent.
291      */
292     function _approve(address owner, address spender, uint256 value) internal {
293         require(spender != address(0));
294         require(owner != address(0));
295 
296         _allowed[owner][spender] = value;
297         emit Approval(owner, spender, value);
298     }
299 
300     /**
301      * @dev Internal function that burns an amount of the token of a given
302      * account, deducting from the sender's allowance for said account. Uses the
303      * internal burn function.
304      * Emits an Approval event (reflecting the reduced allowance).
305      * @param account The account whose tokens will be burnt.
306      * @param value The amount that will be burnt.
307      */
308     function _burnFrom(address account, uint256 value) internal {
309         _burn(account, value);
310         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
311     }
312 }
313 
314 /**
315  * @title ERC20Detailed token
316  * @dev The decimals are only for visualization purposes.
317  * All the operations are done using the smallest and indivisible token unit,
318  * just as on Ethereum all the operations are done in wei.
319  */
320 contract ERC20Detailed is IERC20 {
321     string private _name;
322     string private _symbol;
323     uint8 private _decimals;
324 
325     constructor (string memory name, string memory symbol, uint8 decimals) public {
326         _name = name;
327         _symbol = symbol;
328         _decimals = decimals;
329     }
330 
331     /**
332      * @return the name of the token.
333      */
334     function name() public view returns (string memory) {
335         return _name;
336     }
337 
338     /**
339      * @return the symbol of the token.
340      */
341     function symbol() public view returns (string memory) {
342         return _symbol;
343     }
344 
345     /**
346      * @return the number of decimals of the token.
347      */
348     function decimals() public view returns (uint8) {
349         return _decimals;
350     }
351 }
352 
353 contract PauserRole {
354     using Roles for Roles.Role;
355 
356     event PauserAdded(address indexed account);
357     event PauserRemoved(address indexed account);
358 
359     Roles.Role private _pausers;
360 
361     constructor () internal {
362         _addPauser(msg.sender);
363     }
364 
365     modifier onlyPauser() {
366         require(isPauser(msg.sender));
367         _;
368     }
369 
370     function isPauser(address account) public view returns (bool) {
371         return _pausers.has(account);
372     }
373 
374     function addPauser(address account) public onlyPauser {
375         _addPauser(account);
376     }
377 
378     function renouncePauser() public {
379         _removePauser(msg.sender);
380     }
381 
382     function _addPauser(address account) internal {
383         _pausers.add(account);
384         emit PauserAdded(account);
385     }
386 
387     function _removePauser(address account) internal {
388         _pausers.remove(account);
389         emit PauserRemoved(account);
390     }
391 }
392 
393 /**
394  * @title Pausable
395  * @dev Base contract which allows children to implement an emergency stop mechanism.
396  */
397 contract Pausable is PauserRole {
398     event Paused(address account);
399     event Unpaused(address account);
400 
401     bool private _paused;
402 
403     constructor () internal {
404         _paused = false;
405     }
406 
407     /**
408      * @return true if the contract is paused, false otherwise.
409      */
410     function paused() public view returns (bool) {
411         return _paused;
412     }
413 
414     /**
415      * @dev Modifier to make a function callable only when the contract is not paused.
416      */
417     modifier whenNotPaused() {
418         require(!_paused);
419         _;
420     }
421 
422     /**
423      * @dev Modifier to make a function callable only when the contract is paused.
424      */
425     modifier whenPaused() {
426         require(_paused);
427         _;
428     }
429 
430     /**
431      * @dev called by the owner to pause, triggers stopped state
432      */
433     function pause() public onlyPauser whenNotPaused {
434         _paused = true;
435         emit Paused(msg.sender);
436     }
437 
438     /**
439      * @dev called by the owner to unpause, returns to normal state
440      */
441     function unpause() public onlyPauser whenPaused {
442         _paused = false;
443         emit Unpaused(msg.sender);
444     }
445 }
446 
447 /**
448  * @title Pausable token
449  * @dev ERC20 modified with pausable transfers.
450  */
451 contract ERC20Pausable is ERC20, Pausable {
452     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
453         return super.transfer(to, value);
454     }
455 
456     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
457         return super.transferFrom(from, to, value);
458     }
459 
460     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
461         return super.approve(spender, value);
462     }
463 
464     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
465         return super.increaseAllowance(spender, addedValue);
466     }
467 
468     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
469         return super.decreaseAllowance(spender, subtractedValue);
470     }
471 }
472 
473 /**
474  * @title Burnable Token
475  * @dev Token that can be irreversibly burned (destroyed).
476  */
477 contract ERC20Burnable is ERC20Pausable {
478     /**
479      * @dev Burns a specific amount of tokens.
480      * @param value The amount of token to be burned.
481      */
482     function burn(uint256 value) public {
483         _burn(msg.sender, value);
484     }
485 
486     /**
487      * @dev Burns a specific amount of tokens from the target address and decrements allowance
488      * @param from address The account whose tokens will be burned.
489      * @param value uint256 The amount of token to be burned.
490      */
491     function burnFrom(address from, uint256 value) public {
492         _burnFrom(from, value);
493     }
494 }
495 
496 contract Streamity is ERC20Detailed, ERC20Burnable {
497     uint8 public constant DECIMALS = 18;
498     uint256 public constant INITIAL_SUPPLY = 180000000 * (10 ** uint256(DECIMALS));
499 
500     constructor () public ERC20Detailed("Streamity", "STM", DECIMALS) {
501         _mint(0xd69824B62D26E7f2316812b8c59F36328196Ca13, 23250000 ether); // Team
502         _mint(0x84726199Ac1579684d58F4A47C4c85f2C45B5a11, 18600000 ether); // Fund
503         _mint(0xa2C2f149e4b3EC671a61EAc9F12eAF2489e0Fb10, 3720000 ether); // Advisers & Partners
504         _mint(0xbBB9E0605f0BC7Af1B7238bAC2807a3A8DCb54b5, 4650000 ether); // Team, second part
505         _mint(0x464398aC8B96DdAd7e22AC37147822E1c69293Cb, 129780000 ether); // Rest
506     }
507     
508     function multiSend(address[] memory _beneficiaries, uint256[] memory _values) public {
509         require(_beneficiaries.length == _values.length);
510     
511         uint256 length = _beneficiaries.length;
512     
513         for (uint256 i = 0; i < length; i++) {
514           transfer(_beneficiaries[i], _values[i]);
515         }
516     }
517 }