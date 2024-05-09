1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev give an account access to this role
14      */
15     function add(Role storage role, address account) internal {
16         require(account != address(0));
17         require(!has(role, account));
18 
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev remove an account's access to this role
24      */
25     function remove(Role storage role, address account) internal {
26         require(account != address(0));
27         require(has(role, account));
28 
29         role.bearer[account] = false;
30     }
31 
32     /**
33      * @dev check if an account has this role
34      * @return bool
35      */
36     function has(Role storage role, address account) internal view returns (bool) {
37         require(account != address(0));
38         return role.bearer[account];
39     }
40 }
41 
42 contract MinterRole {
43     using Roles for Roles.Role;
44 
45     event MinterAdded(address indexed account);
46     event MinterRemoved(address indexed account);
47 
48     Roles.Role private _minters;
49 
50     constructor () internal {
51         _addMinter(msg.sender);
52     }
53 
54     modifier onlyMinter() {
55         require(isMinter(msg.sender));
56         _;
57     }
58 
59     function isMinter(address account) public view returns (bool) {
60         return _minters.has(account);
61     }
62 
63     function addMinter(address account) public onlyMinter {
64         _addMinter(account);
65     }
66 
67     function renounceMinter() public {
68         _removeMinter(msg.sender);
69     }
70 
71     function _addMinter(address account) internal {
72         _minters.add(account);
73         emit MinterAdded(account);
74     }
75 
76     function _removeMinter(address account) internal {
77         _minters.remove(account);
78         emit MinterRemoved(account);
79     }
80 }
81 
82 contract PauserRole {
83     using Roles for Roles.Role;
84 
85     event PauserAdded(address indexed account);
86     event PauserRemoved(address indexed account);
87 
88     Roles.Role private _pausers;
89 
90     constructor () internal {
91         _addPauser(msg.sender);
92     }
93 
94     modifier onlyPauser() {
95         require(isPauser(msg.sender));
96         _;
97     }
98 
99     function isPauser(address account) public view returns (bool) {
100         return _pausers.has(account);
101     }
102 
103     function addPauser(address account) public onlyPauser {
104         _addPauser(account);
105     }
106 
107     function renouncePauser() public {
108         _removePauser(msg.sender);
109     }
110 
111     function _addPauser(address account) internal {
112         _pausers.add(account);
113         emit PauserAdded(account);
114     }
115 
116     function _removePauser(address account) internal {
117         _pausers.remove(account);
118         emit PauserRemoved(account);
119     }
120 }
121 
122 /**
123  * @title Pausable
124  * @dev Base contract which allows children to implement an emergency stop mechanism.
125  */
126 contract Pausable is PauserRole {
127     event Paused(address account);
128     event Unpaused(address account);
129 
130     bool private _paused;
131 
132     constructor () internal {
133         _paused = false;
134     }
135 
136     /**
137      * @return true if the contract is paused, false otherwise.
138      */
139     function paused() public view returns (bool) {
140         return _paused;
141     }
142 
143     /**
144      * @dev Modifier to make a function callable only when the contract is not paused.
145      */
146     modifier whenNotPaused() {
147         require(!_paused);
148         _;
149     }
150 
151     /**
152      * @dev Modifier to make a function callable only when the contract is paused.
153      */
154     modifier whenPaused() {
155         require(_paused);
156         _;
157     }
158 
159     /**
160      * @dev called by the owner to pause, triggers stopped state
161      */
162     function pause() public onlyPauser whenNotPaused {
163         _paused = true;
164         emit Paused(msg.sender);
165     }
166 
167     /**
168      * @dev called by the owner to unpause, returns to normal state
169      */
170     function unpause() public onlyPauser whenPaused {
171         _paused = false;
172         emit Unpaused(msg.sender);
173     }
174 }
175 
176 /**
177  * @title SafeMath
178  * @dev Unsigned math operations with safety checks that revert on error
179  */
180 library SafeMath {
181     /**
182     * @dev Multiplies two unsigned integers, reverts on overflow.
183     */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b);
194 
195         return c;
196     }
197 
198     /**
199     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
200     */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         // Solidity only automatically asserts when dividing by 0
203         require(b > 0);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
212     */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         require(b <= a);
215         uint256 c = a - b;
216 
217         return c;
218     }
219 
220     /**
221     * @dev Adds two unsigned integers, reverts on overflow.
222     */
223     function add(uint256 a, uint256 b) internal pure returns (uint256) {
224         uint256 c = a + b;
225         require(c >= a);
226 
227         return c;
228     }
229 
230     /**
231     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
232     * reverts when dividing by zero.
233     */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b != 0);
236         return a % b;
237     }
238 }
239 
240 /**
241  * @title ERC20 interface
242  * @dev see https://github.com/ethereum/EIPs/issues/20
243  */
244 interface IERC20 {
245     function transfer(address to, uint256 value) external returns (bool);
246 
247     function approve(address spender, uint256 value) external returns (bool);
248 
249     function transferFrom(address from, address to, uint256 value) external returns (bool);
250 
251     function totalSupply() external view returns (uint256);
252 
253     function balanceOf(address who) external view returns (uint256);
254 
255     function allowance(address owner, address spender) external view returns (uint256);
256 
257     event Transfer(address indexed from, address indexed to, uint256 value);
258 
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260 }
261 
262 /**
263  * @title Standard ERC20 token
264  *
265  * @dev Implementation of the basic standard token.
266  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
267  * Originally based on code by FirstBlood:
268  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
269  *
270  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
271  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
272  * compliant implementations may not do it.
273  */
274 contract ERC20 is IERC20 {
275     using SafeMath for uint256;
276 
277     mapping (address => uint256) private _balances;
278 
279     mapping (address => mapping (address => uint256)) private _allowed;
280 
281     uint256 private _totalSupply;
282 
283     /**
284     * @dev Total number of tokens in existence
285     */
286     function totalSupply() public view returns (uint256) {
287         return _totalSupply;
288     }
289 
290     /**
291     * @dev Gets the balance of the specified address.
292     * @param owner The address to query the balance of.
293     * @return An uint256 representing the amount owned by the passed address.
294     */
295     function balanceOf(address owner) public view returns (uint256) {
296         return _balances[owner];
297     }
298 
299     /**
300      * @dev Function to check the amount of tokens that an owner allowed to a spender.
301      * @param owner address The address which owns the funds.
302      * @param spender address The address which will spend the funds.
303      * @return A uint256 specifying the amount of tokens still available for the spender.
304      */
305     function allowance(address owner, address spender) public view returns (uint256) {
306         return _allowed[owner][spender];
307     }
308 
309     /**
310     * @dev Transfer token for a specified address
311     * @param to The address to transfer to.
312     * @param value The amount to be transferred.
313     */
314     function transfer(address to, uint256 value) public returns (bool) {
315         _transfer(msg.sender, to, value);
316         return true;
317     }
318 
319     /**
320      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
321      * Beware that changing an allowance with this method brings the risk that someone may use both the old
322      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
323      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
324      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
325      * @param spender The address which will spend the funds.
326      * @param value The amount of tokens to be spent.
327      */
328     function approve(address spender, uint256 value) public returns (bool) {
329         require(spender != address(0));
330 
331         _allowed[msg.sender][spender] = value;
332         emit Approval(msg.sender, spender, value);
333         return true;
334     }
335 
336     /**
337      * @dev Transfer tokens from one address to another.
338      * Note that while this function emits an Approval event, this is not required as per the specification,
339      * and other compliant implementations may not emit the event.
340      * @param from address The address which you want to send tokens from
341      * @param to address The address which you want to transfer to
342      * @param value uint256 the amount of tokens to be transferred
343      */
344     function transferFrom(address from, address to, uint256 value) public returns (bool) {
345         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
346         _transfer(from, to, value);
347         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
348         return true;
349     }
350 
351     /**
352      * @dev Increase the amount of tokens that an owner allowed to a spender.
353      * approve should be called when allowed_[_spender] == 0. To increment
354      * allowed value is better to use this function to avoid 2 calls (and wait until
355      * the first transaction is mined)
356      * From MonolithDAO Token.sol
357      * Emits an Approval event.
358      * @param spender The address which will spend the funds.
359      * @param addedValue The amount of tokens to increase the allowance by.
360      */
361     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
362         require(spender != address(0));
363 
364         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
365         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
366         return true;
367     }
368 
369     /**
370      * @dev Decrease the amount of tokens that an owner allowed to a spender.
371      * approve should be called when allowed_[_spender] == 0. To decrement
372      * allowed value is better to use this function to avoid 2 calls (and wait until
373      * the first transaction is mined)
374      * From MonolithDAO Token.sol
375      * Emits an Approval event.
376      * @param spender The address which will spend the funds.
377      * @param subtractedValue The amount of tokens to decrease the allowance by.
378      */
379     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
380         require(spender != address(0));
381 
382         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
383         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
384         return true;
385     }
386 
387     /**
388     * @dev Transfer token for a specified addresses
389     * @param from The address to transfer from.
390     * @param to The address to transfer to.
391     * @param value The amount to be transferred.
392     */
393     function _transfer(address from, address to, uint256 value) internal {
394         _balances[from] = _balances[from].sub(value);
395         _balances[to] = _balances[to].add(value);
396         emit Transfer(from, to, value);
397     }
398 
399     /**
400      * @dev Internal function that mints an amount of the token and assigns it to
401      * an account. This encapsulates the modification of balances such that the
402      * proper events are emitted.
403      * @param account The account that will receive the created tokens.
404      * @param value The amount that will be created.
405      */
406     function _mint(address account, uint256 value) internal {
407         require(account != address(0));
408 
409         _totalSupply = _totalSupply.add(value);
410         _balances[account] = _balances[account].add(value);
411         emit Transfer(address(0), account, value);
412     }
413 
414     /**
415      * @dev Internal function that burns an amount of the token of a given
416      * account.
417      * @param account The account whose tokens will be burnt.
418      * @param value The amount that will be burnt.
419      */
420     function _burn(address account, uint256 value) internal {
421         require(account != address(0));
422 
423         _totalSupply = _totalSupply.sub(value);
424         _balances[account] = _balances[account].sub(value);
425         emit Transfer(account, address(0), value);
426     }
427 
428     /**
429      * @dev Internal function that burns an amount of the token of a given
430      * account, deducting from the sender's allowance for said account. Uses the
431      * internal burn function.
432      * Emits an Approval event (reflecting the reduced allowance).
433      * @param account The account whose tokens will be burnt.
434      * @param value The amount that will be burnt.
435      */
436     function _burnFrom(address account, uint256 value) internal {
437         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
438         _burn(account, value);
439         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
440     }
441 }
442 
443 /**
444  * @title Burnable Token
445  * @dev Token that can be irreversibly burned (destroyed).
446  */
447 contract ERC20Burnable is ERC20 {
448     /**
449      * @dev Burns a specific amount of tokens.
450      * @param value The amount of token to be burned.
451      */
452     function burn(uint256 value) public {
453         _burn(msg.sender, value);
454     }
455 
456     /**
457      * @dev Burns a specific amount of tokens from the target address and decrements allowance
458      * @param from address The address which you want to send tokens from
459      * @param value uint256 The amount of token to be burned
460      */
461     function burnFrom(address from, uint256 value) public {
462         _burnFrom(from, value);
463     }
464 }
465 
466 /**
467  * @title ERC20Detailed token
468  * @dev The decimals are only for visualization purposes.
469  * All the operations are done using the smallest and indivisible token unit,
470  * just as on Ethereum all the operations are done in wei.
471  */
472 contract ERC20Detailed is IERC20 {
473     string private _name;
474     string private _symbol;
475     uint8 private _decimals;
476 
477     constructor (string memory name, string memory symbol, uint8 decimals) public {
478         _name = name;
479         _symbol = symbol;
480         _decimals = decimals;
481     }
482 
483     /**
484      * @return the name of the token.
485      */
486     function name() public view returns (string memory) {
487         return _name;
488     }
489 
490     /**
491      * @return the symbol of the token.
492      */
493     function symbol() public view returns (string memory) {
494         return _symbol;
495     }
496 
497     /**
498      * @return the number of decimals of the token.
499      */
500     function decimals() public view returns (uint8) {
501         return _decimals;
502     }
503 }
504 
505 /**
506  * @title ERC20Mintable
507  * @dev ERC20 minting logic
508  */
509 contract ERC20Mintable is ERC20, MinterRole {
510     /**
511      * @dev Function to mint tokens
512      * @param to The address that will receive the minted tokens.
513      * @param value The amount of tokens to mint.
514      * @return A boolean that indicates if the operation was successful.
515      */
516     function mint(address to, uint256 value) public onlyMinter returns (bool) {
517         _mint(to, value);
518         return true;
519     }
520 }
521 
522 /**
523  * @title Pausable token
524  * @dev ERC20 modified with pausable transfers.
525  **/
526 contract ERC20Pausable is ERC20, Pausable {
527     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
528         return super.transfer(to, value);
529     }
530 
531     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
532         return super.transferFrom(from, to, value);
533     }
534 
535     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
536         return super.approve(spender, value);
537     }
538 
539     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
540         return super.increaseAllowance(spender, addedValue);
541     }
542 
543     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
544         return super.decreaseAllowance(spender, subtractedValue);
545     }
546 }
547 
548 /**
549  * @title PlusFoCoin token
550  * @dev Simple ERC20 Token example, with mintable token creation
551  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
552  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
553  */
554  
555 contract PlusFoCoin is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
556   uint public INITIAL_SUPPLY = 134056690;
557 
558   constructor()
559         ERC20Burnable()
560         ERC20Mintable()
561         ERC20Detailed("PlusFo Token", "FOT", 18)
562         ERC20()
563         public
564   {
565     _mint(msg.sender, INITIAL_SUPPLY.mul(10 ** uint256(decimals())));
566   }
567 }