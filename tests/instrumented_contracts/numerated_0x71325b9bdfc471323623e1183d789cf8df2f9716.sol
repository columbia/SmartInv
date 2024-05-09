1 pragma solidity >=0.4.22 <0.6.0;
2 
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
21 /**
22  * @title SafeMath
23  * @dev Unsigned math operations with safety checks that revert on error.
24  */
25 library SafeMath {
26     /**
27      * @dev Multiplies two unsigned integers, reverts on overflow.
28      */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
45      */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0);
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55     /**
56      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b <= a);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Adds two unsigned integers, reverts on overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71 
72         return c;
73     }
74 
75     /**
76      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
77      * reverts when dividing by zero.
78      */
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b != 0);
81         return a % b;
82     }
83 }
84 
85 /**
86  * @title Ownable
87  * @dev The Ownable contract has an owner address, and provides basic authorization control
88  * functions, this simplifies the implementation of "user permissions".
89  */
90 contract Ownable {
91     address private _owner;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     /**
96      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
97      * account.
98      */
99     constructor () internal {
100         _owner = msg.sender;
101         emit OwnershipTransferred(address(0), _owner);
102     }
103 
104     /**
105      * @return the address of the owner.
106      */
107     function owner() public view returns (address ) {
108         return _owner;
109     }
110 
111     /**
112      * @dev Throws if called by any account other than the owner.
113      */
114     modifier onlyOwner() {
115         require(isOwner(),"Invalid owner");
116         _;
117     }
118 
119     /**
120      * @return true if `msg.sender` is the owner of the contract.
121      */
122     function isOwner() public view returns (bool) {
123         return msg.sender == _owner;
124     }
125 
126     /**
127      * @dev Allows the current owner to transfer control of the contract to a newOwner.
128      * @param newOwner The address to transfer ownership to.
129      */
130     function transferOwnership(address newOwner) public onlyOwner {
131         _transferOwnership(newOwner);
132     }
133 
134     /**
135      * @dev Transfers control of the contract to a newOwner.
136      * @param newOwner The address to transfer ownership to.
137      */
138     function _transferOwnership(address newOwner) internal {
139         require(newOwner != address(0));
140         emit OwnershipTransferred(_owner, newOwner);
141         _owner = newOwner;
142     }
143 }
144 
145 /**
146  * @title ERC20Detailed token
147  */
148 contract ERC20Detailed is IERC20 {
149     string private _name;
150     string private _symbol;
151     uint8 public _decimals;
152 
153     constructor (string memory name, string memory symbol, uint8 decimals) public {
154         _name = name;
155         _symbol = symbol;
156         _decimals = decimals;
157     }
158 
159     /**
160      * @return the name of the token.
161      */
162     function name() public view returns (string memory) {
163         return _name;
164     }
165 
166     /**
167      * @return the symbol of the token.
168      */
169     function symbol() public view returns (string memory) {
170         return _symbol;
171     }
172 
173     /**
174      * @return the number of decimals of the token.
175      */
176     function decimals() public view returns (uint8) {
177         return _decimals;
178     }
179 }
180 
181 
182 /**
183  * @title Standard ERC20 token
184  */
185 contract ERC20 is IERC20 {
186     using SafeMath for uint256;
187 
188     mapping (address => uint256) public _balances;
189 
190     mapping (address => mapping (address => uint256)) private _allowed;
191     
192     mapping (address => bool) public frozenAccount;
193 
194     uint256 private _totalSupply;
195     
196     /**
197      * @dev Total number of tokens in existence.
198      */
199     function totalSupply() public view returns (uint256) {
200         return _totalSupply;
201     }
202 
203 
204     /**
205      * @dev Gets the balance of the specified address.
206      * @param owner The address to query the balance of.
207      * @return A uint256 representing the amount owned by the passed address.
208      */
209     function balanceOf(address owner) public view returns (uint256) {
210         return _balances[owner];
211     }
212 
213     /**
214      * @dev Function to check the amount of tokens that an owner allowed to a spender.
215      * @param owner address The address which owns the funds.
216      * @param spender address The address which will spend the funds.
217      * @return A uint256 specifying the amount of tokens still available for the spender.
218      */
219     function allowance(address owner, address spender) public view returns (uint256) {
220         return _allowed[owner][spender];
221     }
222 
223     /**
224      * @dev Transfer token to a specified address.
225      * @param to The address to transfer to.
226      * @param value The amount to be transferred.
227      */
228     function transfer(address to, uint256 value) public returns (bool) {
229         _transfer(msg.sender, to, value);
230         return true;
231     }
232 
233     /**
234      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235      * Beware that changing an allowance with this method brings the risk that someone may use both the old
236      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      * @param spender The address which will spend the funds.
240      * @param value The amount of tokens to be spent.
241      */
242     function approve(address spender, uint256 value) public returns (bool) {
243         _approve(msg.sender, spender, value);
244         return true;
245     }
246 
247     /**
248      * @dev Transfer tokens from one address to another.
249      * Note that while this function emits an Approval event, this is not required as per the specification,
250      * and other compliant implementations may not emit the event.
251      * @param from address The address which you want to send tokens from
252      * @param to address The address which you want to transfer to
253      * @param value uint256 the amount of tokens to be transferred
254      */
255     function transferFrom(address from, address to, uint256 value) public returns (bool) {
256         _transfer(from, to, value);
257         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
258         return true;
259     }
260 
261     /**
262      * @dev Transfer token for a specified addresses.
263      * @param from The address to transfer from.
264      * @param to The address to transfer to.
265      * @param value The amount to be transferred.
266      */
267     function _transfer(address from, address to, uint256 value) internal {
268         require(to != address(0),"Check recipient is owner");
269         // Check if sender is frozen
270         require(!frozenAccount[from],"Check if sender is frozen");
271         // Check if recipient is frozen
272         require(!frozenAccount[to],"Check if recipient is frozen");
273         
274         _balances[from] = _balances[from].sub(value);
275         _balances[to] = _balances[to].add(value);
276         emit Transfer(from, to, value);
277     }
278 
279     /**
280      * @dev Internal function that mints an amount of the token and assigns it to
281      * an account. This encapsulates the modification of balances such that the
282      * proper events are emitted.
283      * @param account The account that will receive the created tokens.
284      * @param value The amount that will be created.
285      */
286     function _mint(address account, uint256 value) internal {
287         require(account != address(0),"Check recipient is '0x0'");
288 
289         _totalSupply = _totalSupply.add(value);
290         _balances[account] = _balances[account].add(value);
291         emit Transfer(address(0), account, value);
292     }
293 
294     /**
295      * @dev Internal function that burns an amount of the token of a given
296      * account.
297      * @param account The account whose tokens will be burnt.
298      * @param value The amount that will be burnt.
299      */
300     function _burn(address account, uint256 value) internal {
301         require(account != address(0),"Check recipient is owner");
302 
303         _totalSupply = _totalSupply.sub(value);
304         _balances[account] = _balances[account].sub(value);
305         emit Transfer(account, address(0), value);
306     }
307     
308     /**
309      * @dev Internal function that burns an amount of the token of a given
310      * account, deducting from the sender's allowance for said account. Uses the
311      * internal burn function.
312      * Emits an Approval event (reflecting the reduced allowance).
313      * @param account The account whose tokens will be burnt.
314      * @param value The amount that will be burnt.
315      */
316     function _burnFrom(address account, uint256 value) internal {
317         _burn(account, value);
318         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
319     }
320     
321     
322  
323     /**
324      * @dev Approve an address to spend another addresses' tokens.
325      * @param owner The address that owns the tokens.
326      * @param spender The address that will spend the tokens.
327      * @param value The number of tokens that can be spent.
328      */
329     function _approve(address owner, address spender, uint256 value) internal {
330         require(spender != address(0));
331         require(owner != address(0));
332 
333         _allowed[owner][spender] = value;
334         emit Approval(owner, spender, value);
335     }
336 
337 
338     
339 }
340 
341 
342 /**
343  * @title ERC20Mintable
344  * @dev ERC20 minting logic.
345  */
346 contract ERC20Mintable is ERC20, Ownable {
347     /**
348      * @dev Function to mint tokens
349      * @param to The address that will receive the minted tokens.
350      * @param value The amount of tokens to mint.
351      * @return A boolean that indicates if the operation was successful.
352      */
353     function mint(address to, uint256 value) public onlyOwner returns (bool) {
354         _mint(to, value);
355         return true;
356     }
357 }
358 
359 
360 /**
361  * @title Burnable Token
362  * @dev Token that can be irreversibly burned (destroyed).
363  */
364 contract ERC20Burnable is ERC20,Ownable{
365     /**
366      * @dev Burns a specific amount of tokens.
367      * @param value The amount of token to be burned.
368      */
369     function burn(uint256 value) onlyOwner public {
370         _burn(msg.sender, value);
371     }
372 
373     
374     /**
375      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
376      * @param from address The account whose tokens will be burned.
377      * @param value uint256 The amount of token to be burned.
378      */
379     function burnFrom(address from, uint256 value) public {
380         _burnFrom(from, value);
381     }
382 
383 }
384 
385 /**
386  * @title Roles
387  * @dev Library for managing addresses assigned to a Role.
388  */
389 library Roles {
390     struct Role {
391         mapping (address => bool) bearer;
392     }
393 
394     /**
395      * @dev Give an account access to this role.
396      */
397     function add(Role storage role, address account) internal {
398         require(account != address(0));
399         require(!has(role, account));
400 
401         role.bearer[account] = true;
402     }
403 
404     /**
405      * @dev Remove an account's access to this role.
406      */
407     function remove(Role storage role, address account) internal {
408         require(account != address(0));
409         require(has(role, account));
410 
411         role.bearer[account] = false;
412     }
413 
414     /**
415      * @dev Check if an account has this role.
416      * @return bool
417      */
418     function has(Role storage role, address account) internal view returns (bool) {
419         require(account != address(0));
420         return role.bearer[account];
421     }
422 }
423 
424 
425 contract PauserRole is Ownable {
426     using Roles for Roles.Role;
427 
428     event PauserAdded(address indexed account);
429     event PauserRemoved(address indexed account);
430 
431     Roles.Role private _pausers;
432 
433     constructor () internal {
434         _addPauser(msg.sender);
435     }
436 
437     modifier onlyPauser() {
438         require(isPauser(msg.sender));
439         _;
440     }
441     
442      function isPauser(address account) public view returns (bool) {
443         return _pausers.has(account);
444     }
445 
446     function _addPauser(address account) internal {
447         _pausers.add(account);
448         emit PauserAdded(account);
449     }
450 
451     function _removePauser(address account) internal {
452         _pausers.remove(account);
453         emit PauserRemoved(account);
454     }
455 
456 }
457 
458 
459 /**
460  * @title Pausable
461  * @dev Base contract which allows children to implement an emergency stop mechanism.
462  */
463 contract Pausable is PauserRole {
464     event Paused(address account);
465     event Unpaused(address account);
466 
467     bool private _paused;
468 
469     constructor () internal {
470         _paused = false;
471     }
472     
473     // modifier onlyPauser() {
474     //     require(isPauser(msg.sender));
475     //     _;
476     // }
477     /**
478      * @return True if the contract is paused, false otherwise.
479      */
480     function paused() public view returns (bool) {
481         return _paused;
482     }
483 
484     /**
485      * @dev Modifier to make a function callable only when the contract is not paused.
486      */
487     modifier whenNotPaused() {
488         require(!_paused);
489         _;
490     }
491 
492     /**
493      * @dev Modifier to make a function callable only when the contract is paused.
494      */
495     modifier whenPaused() {
496         require(_paused);
497         _;
498     }
499 
500     /**
501      * @dev Called by a pauser to pause, triggers stopped state.
502      */
503     function pause() public onlyOwner whenNotPaused {
504         _paused = true;
505         emit Paused(msg.sender);
506     }
507 
508     /**
509      * @dev Called by a pauser to unpause, returns to normal state.
510      */
511     function unpause() public onlyOwner whenPaused {
512         _paused = false;
513         emit Unpaused(msg.sender);
514     }
515 }
516 
517 
518 /**
519  * @title Pausable token
520  * @dev ERC20 modified with pausable transfers.
521  */
522 contract ERC20Pausable is ERC20, Pausable {
523     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
524         return super.transfer(to, value);
525     }
526 
527     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
528         return super.transferFrom(from, to, value);
529     }
530 
531     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
532         return super.approve(spender, value);
533     }
534 
535 }
536 
537 
538 /**
539  * @title SJGC
540  * `ERC20` functions.
541  */
542 contract SJGC_TOKEN is ERC20, ERC20Detailed, ERC20Burnable, ERC20Mintable, ERC20Pausable {
543 
544     string private constant NAME = "SEJIN GOLD COIN"; 
545     string private constant SYMBOL = "SJGC"; 
546     uint8 private constant DECIMALS = 18; 
547     
548     /**
549      * This notifies clients about frozen accounts.
550      */
551     event FrozenFunds(address target, bool frozen);    
552     
553     
554     uint256 public constant INITIAL_SUPPLY = 10000000000 *(10 ** uint256(DECIMALS));
555 
556     
557     /**
558      * Constructor that gives msg.sender all of existing tokens.
559      */
560     constructor () public ERC20Detailed(NAME, SYMBOL, DECIMALS) {
561         _mint(msg.sender, INITIAL_SUPPLY);
562     }
563     
564     /**
565     * Freeze Account
566     */
567     function freezeAccount(address target, bool freeze) onlyOwner  public {
568         frozenAccount[target] = freeze;
569         emit FrozenFunds(target, freeze);
570     }
571     
572     /**
573     * Withdraw for Ether
574     */
575      function withdraw(uint withdrawAmount) onlyOwner public  {
576         require(withdrawAmount <= address(this).balance); 
577         owner().transfer(withdrawAmount);
578         
579     }
580     
581     /**
582     * Withdraw for Token
583     */
584     function withdrawToken(uint tokenAmount) onlyOwner public {
585         require(tokenAmount <= _balances[address(this)]);
586         _transfer(address(this),owner(),tokenAmount);
587     }
588     
589     
590 }