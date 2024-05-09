1 /**
2  * Source Code first verified at https://etherscan.io on Sunday, April 28, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.7;
6 
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://eips.ethereum.org/EIPS/eip-20
11  */
12 interface IERC20 {
13     function transfer(address to, uint256 value) external returns (bool);
14 
15     function approve(address spender, uint256 value) external returns (bool);
16 
17     function transferFrom(address from, address to, uint256 value) external returns (bool);
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address who) external view returns (uint256);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28     
29     event Freeze(address indexed from, uint256 value);
30     
31     event Unfreeze(address indexed from, uint256 value);
32 }
33 
34 
35 
36 /**
37  * @title SafeMath
38  * @dev Unsigned math operations with safety checks that revert on error.
39  */
40 library SafeMath {
41     /**
42      * @dev Multiplies two unsigned integers, reverts on overflow.
43      */
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48         if (a == 0) {
49             return 0;
50         }
51 
52         uint256 c = a * b;
53         require(c / a == b);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
60      */
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         // Solidity only automatically asserts when dividing by 0
63         require(b > 0);
64         uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67         return c;
68     }
69 
70     /**
71      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72      */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b <= a);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81      * @dev Adds two unsigned integers, reverts on overflow.
82      */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a);
86 
87         return c;
88     }
89 
90     /**
91      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
92      * reverts when dividing by zero.
93      */
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0);
96         return a % b;
97     }
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://eips.ethereum.org/EIPS/eip-20
105  * Originally based on code by FirstBlood:
106  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  *
108  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
109  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
110  * compliant implementations may not do it.
111  */
112 contract ERC20 is IERC20 {
113     using SafeMath for uint256;
114 
115     mapping (address => uint256) private _balances;
116 
117     mapping (address => mapping (address => uint256)) private _allowed;
118     
119     mapping (address => uint256) private _freezeOf;
120     
121     uint256 private _totalSupply;
122 
123     /**
124      * @dev Total number of tokens in existence.
125      */
126     function totalSupply() public view returns (uint256) {
127         return _totalSupply;
128     }
129 
130     /**
131      * @dev Gets the balance of the specified address.
132      * @param owner The address to query the balance of.
133      * @return A uint256 representing the amount owned by the passed address.
134      */
135     function balanceOf(address owner) public view returns (uint256) {
136         return _balances[owner];
137     }
138     
139     /**
140      * @dev Gets the balance of the specified freeze address.
141      * @param owner The address to query the balance of.
142      * @return A uint256 representing the amount owned by the freeze address.
143      */
144     function freezeOf(address owner) public view returns (uint256) {
145         return _freezeOf[owner];
146     }
147 
148     /**
149      * @dev Function to check the amount of tokens that an owner allowed to a spender.
150      * @param owner address The address which owns the funds.
151      * @param spender address The address which will spend the funds.
152      * @return A uint256 specifying the amount of tokens still available for the spender.
153      */
154     function allowance(address owner, address spender) public view returns (uint256) {
155         return _allowed[owner][spender];
156     }
157 
158     /**
159      * @dev Transfer token to a specified address.
160      * @param to The address to transfer to.
161      * @param value The amount to be transferred.
162      */
163     function transfer(address to, uint256 value) public returns (bool) {
164         _transfer(msg.sender, to, value);
165         return true;
166     }
167 
168     /**
169      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param spender The address which will spend the funds.
175      * @param value The amount of tokens to be spent.
176      */
177     function approve(address spender, uint256 value) public returns (bool) {
178         _approve(msg.sender, spender, value);
179         return true;
180     }
181 
182     /**
183      * @dev Transfer tokens from one address to another.
184      * Note that while this function emits an Approval event, this is not required as per the specification,
185      * and other compliant implementations may not emit the event.
186      * @param from address The address which you want to send tokens from
187      * @param to address The address which you want to transfer to
188      * @param value uint256 the amount of tokens to be transferred
189      */
190     function transferFrom(address from, address to, uint256 value) public returns (bool) {
191         _transfer(from, to, value);
192         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
193         return true;
194     }
195 
196     /**
197      * @dev Increase the amount of tokens that an owner allowed to a spender.
198      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * Emits an Approval event.
203      * @param spender The address which will spend the funds.
204      * @param addedValue The amount of tokens to increase the allowance by.
205      */
206     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
207         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
208         return true;
209     }
210 
211     /**
212      * @dev Decrease the amount of tokens that an owner allowed to a spender.
213      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
214      * allowed value is better to use this function to avoid 2 calls (and wait until
215      * the first transaction is mined)
216      * From MonolithDAO Token.sol
217      * Emits an Approval event.
218      * @param spender The address which will spend the funds.
219      * @param subtractedValue The amount of tokens to decrease the allowance by.
220      */
221     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
222         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
223         return true;
224     }
225 
226     /**
227      * @dev Transfer token for a specified addresses.
228      * @param from The address to transfer from.
229      * @param to The address to transfer to.
230      * @param value The amount to be transferred.
231      */
232     function _transfer(address from, address to, uint256 value) internal {
233         require(to != address(0));
234 
235         _balances[from] = _balances[from].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(from, to, value);
238     }
239 
240     /**
241      * @dev Internal function that mints an amount of the token and assigns it to
242      * an account. This encapsulates the modification of balances such that the
243      * proper events are emitted.
244      * @param account The account that will receive the created tokens.
245      * @param value The amount that will be created.
246      */
247     function _mint(address account, uint256 value) internal {
248         require(account != address(0));
249         _totalSupply = _totalSupply.add(value);
250         _balances[account] = _balances[account].add(value);
251         emit Transfer(address(0), account, value);
252     }
253 
254     /**
255      * @dev Internal function that burns an amount of the token of a given
256      * account.
257      * @param account The account whose tokens will be burnt.
258      * @param value The amount that will be burnt.
259      */
260     function _burn(address account, uint256 value) internal {
261         require(account != address(0));
262         
263         _totalSupply = _totalSupply.sub(value);
264         _balances[account] = _balances[account].sub(value);
265         emit Transfer(account, address(0), value);
266     }
267     
268     function _freeze(uint256 value) internal {
269         require(_balances[msg.sender]>=value); // Check if the sender has enough
270         require(value > 0);
271         _balances[msg.sender] = _balances[msg.sender].sub(value);
272         _freezeOf[msg.sender] = _freezeOf[msg.sender].add(value);
273         emit Freeze(msg.sender, value);
274     }
275     
276     function _unfreeze(uint256 value) internal{
277         require(_freezeOf[msg.sender]>=value); 
278 		require(value > 0);
279         _freezeOf[msg.sender] = _freezeOf[msg.sender].sub(value); 
280 		_balances[msg.sender] = _balances[msg.sender].add(value);
281         emit Unfreeze(msg.sender, value);
282 
283     }
284     
285     /**
286      * @dev Approve an address to spend another addresses' tokens.
287      * @param owner The address that owns the tokens.
288      * @param spender The address that will spend the tokens.
289      * @param value The number of tokens that can be spent.
290      */
291     function _approve(address owner, address spender, uint256 value) internal {
292         require(spender != address(0));
293         require(owner != address(0));
294 
295         _allowed[owner][spender] = value;
296         emit Approval(owner, spender, value);
297     }
298 
299 }
300 
301 
302 /**
303  * @title ERC20Detailed token
304  * @dev The decimals are only for visualization purposes.
305  * All the operations are done using the smallest and indivisible token unit,
306  * just as on Ethereum all the operations are done in wei.
307  */
308 contract ERC20Detailed is IERC20 {
309     string private _name;
310     string private _symbol;
311     uint8 private _decimals;
312 
313     constructor (string memory name, string memory symbol, uint8 decimals) public {
314         _name = name;
315         _symbol = symbol;
316         _decimals = decimals;
317     }
318 
319     /**
320      * @return the name of the token.
321      */
322     function name() public view returns (string memory) {
323         return _name;
324     }
325 
326     /**
327      * @return the symbol of the token.
328      */
329     function symbol() public view returns (string memory) {
330         return _symbol;
331     }
332 
333     /**
334      * @return the number of decimals of the token.
335      */
336     function decimals() public view returns (uint8) {
337         return _decimals;
338     }
339 }
340 
341 /**
342  * @title Roles
343  * @dev Library for managing addresses assigned to a Role.
344  */
345 library Roles {
346     struct Role {
347         mapping (address => bool) bearer;
348     }
349 
350     /**
351      * @dev Give an account access to this role.
352      */
353     function add(Role storage role, address account) internal {
354         require(!has(role, account));
355 
356         role.bearer[account] = true;
357     }
358 
359     /**
360      * @dev Remove an account's access to this role.
361      */
362     function remove(Role storage role, address account) internal {
363         require(has(role, account));
364 
365         role.bearer[account] = false;
366     }
367 
368     /**
369      * @dev Check if an account has this role.
370      * @return bool
371      */
372     function has(Role storage role, address account) internal view returns (bool) {
373         require(account != address(0));
374         return role.bearer[account];
375     }
376 }
377 
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
392         require(isPauser(msg.sender));
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
419 
420 
421 /**
422  * @title Pausable
423  * @dev Base contract which allows children to implement an emergency stop mechanism.
424  */
425 contract Pausable is PauserRole {
426     event Paused(address account);
427     event Unpaused(address account);
428 
429     bool private _paused;
430 
431     constructor () internal {
432         _paused = false;
433     }
434 
435     /**
436      * @return True if the contract is paused, false otherwise.
437      */
438     function paused() public view returns (bool) {
439         return _paused;
440     }
441 
442     /**
443      * @dev Modifier to make a function callable only when the contract is not paused.
444      */
445     modifier whenNotPaused() {
446         require(!_paused);
447         _;
448     }
449 
450     /**
451      * @dev Modifier to make a function callable only when the contract is paused.
452      */
453     modifier whenPaused() {
454         require(_paused);
455         _;
456     }
457 
458     /**
459      * @dev Called by a pauser to pause, triggers stopped state.
460      */
461     function pause() public onlyPauser whenNotPaused {
462         _paused = true;
463         emit Paused(msg.sender);
464     }
465 
466     /**
467      * @dev Called by a pauser to unpause, returns to normal state.
468      */
469     function unpause() public onlyPauser whenPaused {
470         _paused = false;
471         emit Unpaused(msg.sender);
472     }
473 }
474 
475 /**
476  * @title Pausable
477  * @dev Base contract which allows children to implement an emergency stop mechanism.
478  */
479 contract Lockable is PauserRole{
480     
481 
482     mapping (address => bool) private lockers;
483     
484 
485     event LockAccount(address account, bool islock);
486     
487     
488     /**
489      * @dev Check if the account is locked.
490      * @param account specific account address.
491      */
492     function isLock(address account) public view returns (bool) {
493         return lockers[account];
494     }
495     
496     /**
497      * @dev Lock or thaw account address
498      * @param account specific account address.
499      * @param islock true lock, false thaw.
500      */
501     function lock(address account, bool islock)  public onlyPauser {
502         lockers[account] = islock;
503         emit LockAccount(account, islock);
504     }
505     
506 }
507 
508 
509 
510 
511 /**
512  * @title Pausable token
513  * @dev ERC20 modified with pausable transfers. 
514  */
515 contract ERC20Pausable is ERC20, Pausable,Lockable {
516     
517     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
518         require(!isLock(msg.sender));
519         require(!isLock(to));
520         return super.transfer(to, value);
521     }
522 
523     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
524         require(!isLock(msg.sender));
525         require(!isLock(from));
526         require(!isLock(to));
527         return super.transferFrom(from, to, value);
528     }
529 
530     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
531         require(!isLock(msg.sender));
532         require(!isLock(spender));
533         return super.approve(spender, value);
534     }
535 
536     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
537         require(!isLock(msg.sender));
538         require(!isLock(spender));
539         return super.increaseAllowance(spender, addedValue);
540     }
541 
542     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
543         require(!isLock(msg.sender));
544         require(!isLock(spender));
545         return super.decreaseAllowance(spender, subtractedValue);
546     }
547 }
548 
549 
550 contract RRB is ERC20, ERC20Detailed, ERC20Pausable {
551     
552     constructor(string memory name, string memory symbol, uint8 decimals,uint256 _totalSupply) ERC20Pausable()  ERC20Detailed(name, symbol, decimals) ERC20() public {
553         require(_totalSupply > 0);
554         _mint(msg.sender, _totalSupply);
555     }
556     
557     /**
558      * @dev Burns a specific amount of tokens.
559      * @param value The amount of token to be burned.
560      */
561     function burn(uint256 value) public whenNotPaused {
562         require(!isLock(msg.sender));
563         _burn(msg.sender, value);
564     }
565     
566     /**
567      * @dev Freeze a specific amount of tokens.
568      * @param value The amount of token to be Freeze.
569      */
570     function freeze(uint256 value) public whenNotPaused {
571         require(!isLock(msg.sender));
572         _freeze(value);
573     }
574     
575         /**
576      * @dev unFreeze a specific amount of tokens.
577      * @param value The amount of token to be unFreeze.
578      */
579     function unfreeze(uint256 value) public whenNotPaused {
580         require(!isLock(msg.sender));
581         _unfreeze(value);
582     }
583     
584 }