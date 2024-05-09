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
14         
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
107  * @title Ownable
108  * @dev The Ownable contract has an owner address, and provides basic authorization control
109  * functions, this simplifies the implementation of "user permissions".
110  */
111 contract Ownable {
112     address private _owner;
113 
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116     /**
117      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
118      * account.
119      */
120     constructor () internal {
121         _owner = msg.sender;
122         emit OwnershipTransferred(address(0), _owner);
123     }
124 
125     /**
126      * @return the address of the owner.
127      */
128     function owner() public view returns (address) {
129         return _owner;
130     }
131 
132     /**
133      * @dev Throws if called by any account other than the owner.
134      */
135     modifier onlyOwner() {
136         require(isOwner());
137         _;
138     }
139 
140     /**
141      * @return true if `msg.sender` is the owner of the contract.
142      */
143     function isOwner() public view returns (bool) {
144         return msg.sender == _owner;
145     }
146 
147     /**
148      * @dev Allows the current owner to relinquish control of the contract.
149      * @notice Renouncing to ownership will leave the contract without an owner.
150      * It will not be possible to call the functions with the `onlyOwner`
151      * modifier anymore.
152      */
153     function renounceOwnership() public onlyOwner {
154         emit OwnershipTransferred(_owner, address(0));
155         _owner = address(0);
156     }
157 
158     /**
159      * @dev Allows the current owner to transfer control of the contract to a newOwner.
160      * @param newOwner The address to transfer ownership to.
161      */
162     function transferOwnership(address newOwner) public onlyOwner {
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers control of the contract to a newOwner.
168      * @param newOwner The address to transfer ownership to.
169      */
170     function _transferOwnership(address newOwner) internal {
171         require(newOwner != address(0));
172         emit OwnershipTransferred(_owner, newOwner);
173         _owner = newOwner;
174     }
175 }
176 
177 contract DelegateOwnerRole is Ownable{
178   using Roles for Roles.Role;
179 
180   event DelegateOwnerAdded(address indexed account);
181   event DelegateOwnerRemoved(address indexed account);
182 
183   Roles.Role private delegateOwners;
184 
185   constructor() internal {
186     _addDelegateOwner(msg.sender);
187   }
188 
189   modifier onlyDelegateOwner() {
190     require(isDelegateOwner(msg.sender));
191     _;
192   }
193 
194   function isDelegateOwner(address account) public view returns (bool) {
195     return delegateOwners.has(account);
196   }
197 
198   function addDelegateOwner(address account) public onlyOwner {
199     _addDelegateOwner(account);
200   }
201 
202   function renounceDelegateOwner(address account) public onlyOwner {
203     _removeDelegateOwner(account);
204   }
205 
206   function _addDelegateOwner(address account) internal {
207     delegateOwners.add(account);
208     emit DelegateOwnerAdded(account);
209   }
210 
211   function _removeDelegateOwner(address account) internal {
212     delegateOwners.remove(account);
213     emit DelegateOwnerRemoved(account);
214   }
215 }
216 
217 contract PauserRole is DelegateOwnerRole{
218     using Roles for Roles.Role;
219 
220     event PauserAdded(address indexed account);
221     event PauserRemoved(address indexed account);
222 
223     Roles.Role private _pausers;
224 
225     constructor () internal {
226         _addPauser(msg.sender);
227     }
228 
229     modifier onlyPauser() {
230         require(isPauser(msg.sender));
231         _;
232     }
233 
234     function isPauser(address account) public view returns (bool) {
235         return _pausers.has(account);
236     }
237 
238     function addPauser(address account) public onlyDelegateOwner {
239         _addPauser(account);
240     }
241 
242     function renouncePauser(address account) public onlyDelegateOwner {
243         _removePauser(account);
244     }
245 
246     function _addPauser(address account) internal {
247         _pausers.add(account);
248         emit PauserAdded(account);
249     }
250 
251     function _removePauser(address account) internal {
252         _pausers.remove(account);
253         emit PauserRemoved(account);
254     }
255 }
256 
257 /**
258  * @title ERC20 interface
259  * @dev see https://github.com/ethereum/EIPs/issues/20
260  */
261 interface IERC20 {
262     function transfer(address to, uint256 value) external returns (bool);
263 
264     function approve(address spender, uint256 value) external returns (bool);
265 
266     function transferFrom(address from, address to, uint256 value) external returns (bool);
267 
268     function totalSupply() external view returns (uint256);
269 
270     function balanceOf(address who) external view returns (uint256);
271 
272     function allowance(address owner, address spender) external view returns (uint256);
273 
274     event Transfer(address indexed from, address indexed to, uint256 value);
275 
276     event Approval(address indexed owner, address indexed spender, uint256 value);
277 }
278 
279 /**
280  * @title Standard ERC20 token
281  *
282  * @dev Implementation of the basic standard token.
283  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
284  * Originally based on code by FirstBlood:
285  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
286  *
287  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
288  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
289  * compliant implementations may not do it.
290  */
291 contract ERC20 is IERC20 {
292     using SafeMath for uint256;
293 
294     mapping (address => uint256) private _balances;
295 
296     mapping (address => mapping (address => uint256)) private _allowed;
297 
298     uint256 private _totalSupply;
299 
300     /**
301      * @dev Total number of tokens in existence
302      */
303     function totalSupply() public view returns (uint256) {
304         return _totalSupply;
305     }
306 
307     /**
308      * @dev Gets the balance of the specified address.
309      * @param owner The address to query the balance of.
310      * @return An uint256 representing the amount owned by the passed address.
311      */
312     function balanceOf(address owner) public view returns (uint256) {
313         return _balances[owner];
314     }
315 
316     /**
317      * @dev Function to check the amount of tokens that an owner allowed to a spender.
318      * @param owner address The address which owns the funds.
319      * @param spender address The address which will spend the funds.
320      * @return A uint256 specifying the amount of tokens still available for the spender.
321      */
322     function allowance(address owner, address spender) public view returns (uint256) {
323         return _allowed[owner][spender];
324     }
325 
326     /**
327      * @dev Transfer token for a specified address
328      * @param to The address to transfer to.
329      * @param value The amount to be transferred.
330      */
331     function transfer(address to, uint256 value) public returns (bool) {
332         _transfer(msg.sender, to, value);
333         return true;
334     }
335 
336     /**
337      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
338      * Beware that changing an allowance with this method brings the risk that someone may use both the old
339      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
340      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
341      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
342      * @param spender The address which will spend the funds.
343      * @param value The amount of tokens to be spent.
344      */
345     function approve(address spender, uint256 value) public returns (bool) {
346         _approve(msg.sender, spender, value);
347         return true;
348     }
349 
350     /**
351      * @dev Transfer tokens from one address to another.
352      * Note that while this function emits an Approval event, this is not required as per the specification,
353      * and other compliant implementations may not emit the event.
354      * @param from address The address which you want to send tokens from
355      * @param to address The address which you want to transfer to
356      * @param value uint256 the amount of tokens to be transferred
357      */
358     function transferFrom(address from, address to, uint256 value) public returns (bool) {
359         _transfer(from, to, value);
360         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
361         return true;
362     }
363 
364     /**
365      * @dev Increase the amount of tokens that an owner allowed to a spender.
366      * approve should be called when allowed_[_spender] == 0. To increment
367      * allowed value is better to use this function to avoid 2 calls (and wait until
368      * the first transaction is mined)
369      * From MonolithDAO Token.sol
370      * Emits an Approval event.
371      * @param spender The address which will spend the funds.
372      * @param addedValue The amount of tokens to increase the allowance by.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
375         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
376         return true;
377     }
378 
379     /**
380      * @dev Decrease the amount of tokens that an owner allowed to a spender.
381      * approve should be called when allowed_[_spender] == 0. To decrement
382      * allowed value is better to use this function to avoid 2 calls (and wait until
383      * the first transaction is mined)
384      * From MonolithDAO Token.sol
385      * Emits an Approval event.
386      * @param spender The address which will spend the funds.
387      * @param subtractedValue The amount of tokens to decrease the allowance by.
388      */
389     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
390         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
391         return true;
392     }
393 
394     /**
395      * @dev Transfer token for a specified addresses
396      * @param from The address to transfer from.
397      * @param to The address to transfer to.
398      * @param value The amount to be transferred.
399      */
400     function _transfer(address from, address to, uint256 value) internal {
401         require(to != address(0));
402 
403         _balances[from] = _balances[from].sub(value);
404         _balances[to] = _balances[to].add(value);
405         emit Transfer(from, to, value);
406     }
407 
408     /**
409      * @dev Internal function that mints an amount of the token and assigns it to
410      * an account. This encapsulates the modification of balances such that the
411      * proper events are emitted.
412      * @param account The account that will receive the created tokens.
413      * @param value The amount that will be created.
414      */
415     function _mint(address account, uint256 value) internal {
416         require(account != address(0));
417 
418         _totalSupply = _totalSupply.add(value);
419         _balances[account] = _balances[account].add(value);
420         emit Transfer(address(0), account, value);
421     }
422 
423     /**
424      * @dev Internal function that burns an amount of the token of a given
425      * account.
426      * @param account The account whose tokens will be burnt.
427      * @param value The amount that will be burnt.
428      */
429     function _burn(address account, uint256 value) internal {
430         require(account != address(0));
431 
432         _totalSupply = _totalSupply.sub(value);
433         _balances[account] = _balances[account].sub(value);
434         emit Transfer(account, address(0), value);
435     }
436 
437     /**
438      * @dev Approve an address to spend another addresses' tokens.
439      * @param owner The address that owns the tokens.
440      * @param spender The address that will spend the tokens.
441      * @param value The number of tokens that can be spent.
442      */
443     function _approve(address owner, address spender, uint256 value) internal {
444         require(spender != address(0));
445         require(owner != address(0));
446 
447         _allowed[owner][spender] = value;
448         emit Approval(owner, spender, value);
449     }
450 
451     /**
452      * @dev Internal function that burns an amount of the token of a given
453      * account, deducting from the sender's allowance for said account. Uses the
454      * internal burn function.
455      * Emits an Approval event (reflecting the reduced allowance).
456      * @param account The account whose tokens will be burnt.
457      * @param value The amount that will be burnt.
458      */
459     function _burnFrom(address account, uint256 value) internal {
460         _burn(account, value);
461         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
462     }
463 }
464 
465 /**
466  * @title Pausable
467  * @dev Base contract which allows children to implement an emergency stop mechanism.
468  */
469 contract Pausable is PauserRole {
470     event Paused(address account);
471     event Unpaused(address account);
472 
473     bool private _paused;
474 
475     constructor () internal {
476         _paused = false;
477     }
478 
479     /**
480      * @return true if the contract is paused, false otherwise.
481      */
482     function paused() public view returns (bool) {
483         return _paused;
484     }
485 
486     /**
487      * @dev Modifier to make a function callable only when the contract is not paused.
488      */
489     modifier whenNotPaused() {
490         require(!_paused);
491         _;
492     }
493 
494     /**
495      * @dev Modifier to make a function callable only when the contract is paused.
496      */
497     modifier whenPaused() {
498         require(_paused);
499         _;
500     }
501 
502     /**
503      * @dev called by the owner to pause, triggers stopped state
504      */
505     function pause() public onlyPauser onlyDelegateOwner whenNotPaused {
506         _paused = true;
507         emit Paused(msg.sender);
508     }
509 
510     /**
511      * @dev called by the owner to unpause, returns to normal state
512      */
513     function unpause() public onlyPauser onlyDelegateOwner whenPaused {
514         _paused = false;
515         emit Unpaused(msg.sender);
516     }
517 }
518 
519 /**
520  * @title Pausable token
521  * @dev ERC20 modified with pausable transfers.
522  */
523 contract ERC20Pausable is ERC20, Pausable {
524     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
525         return super.transfer(to, value);
526     }
527 
528     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
529         return super.transferFrom(from, to, value);
530     }
531 
532     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
533         return super.approve(spender, value);
534     }
535 
536     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
537         return super.increaseAllowance(spender, addedValue);
538     }
539 
540     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
541         return super.decreaseAllowance(spender, subtractedValue);
542     }
543 }
544 
545 /**
546  * @title Burnable Token
547  * @dev Token that can be irreversibly burned (destroyed).
548  */
549 contract ERC20Burnable is ERC20Pausable {
550     /**
551      * @dev Burns a specific amount of tokens.
552      * @param value The amount of token to be burned.
553      */
554     function burn(uint256 value) public onlyDelegateOwner{
555         _burn(msg.sender, value);
556     }
557 
558     /**
559      * @dev Burns a specific amount of tokens from the target address and decrements allowance
560      * @param from address The account whose tokens will be burned.
561      * @param value uint256 The amount of token to be burned.
562      */
563     function burnFrom(address from, uint256 value) public onlyDelegateOwner{
564         _burnFrom(from, value);
565     }
566 }
567 
568 contract SolareX is ERC20Burnable{
569      
570      
571   string public name;                   
572   uint8 public decimals;                //How many decimals to show. ie. There could 1000000 base units with 6 decimals. Meaning 0.980900 SRX = 980900 base units. It's like comparing 1 wei to 1 ether.
573   string public symbol;                 
574   string public version;       
575   
576   
577     constructor() public
578     {
579       super._mint(msg.sender,2400000000000000);
580       name = "SolareX";
581       decimals = 6;
582       symbol = "SRX";
583       version = "V2.0";
584       
585     }
586     
587 }