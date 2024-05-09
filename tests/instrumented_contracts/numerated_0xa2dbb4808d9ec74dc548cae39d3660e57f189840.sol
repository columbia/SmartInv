1 pragma solidity ^0.5.2;
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
42 
43 
44 
45 contract PauserRole {
46     using Roles for Roles.Role;
47 
48     event PauserAdded(address indexed account);
49     event PauserRemoved(address indexed account);
50 
51     Roles.Role private _pausers;
52 
53     constructor () internal {
54         _addPauser(msg.sender);
55     }
56 
57     modifier onlyPauser() {
58         require(isPauser(msg.sender));
59         _;
60     }
61 
62     function isPauser(address account) public view returns (bool) {
63         return _pausers.has(account);
64     }
65 
66     function addPauser(address account) public onlyPauser {
67         _addPauser(account);
68     }
69 
70     function renouncePauser() public {
71         _removePauser(msg.sender);
72     }
73 
74     function _addPauser(address account) internal {
75         _pausers.add(account);
76         emit PauserAdded(account);
77     }
78 
79     function _removePauser(address account) internal {
80         _pausers.remove(account);
81         emit PauserRemoved(account);
82     }
83 }
84 
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://eips.ethereum.org/EIPS/eip-20
89  */
90 interface IERC20 {
91     function transfer(address to, uint256 value) external returns (bool);
92 
93     function approve(address spender, uint256 value) external returns (bool);
94 
95     function transferFrom(address from, address to, uint256 value) external returns (bool);
96 
97     function totalSupply() external view returns (uint256);
98 
99     function balanceOf(address who) external view returns (uint256);
100 
101     function allowance(address owner, address spender) external view returns (uint256);
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 
110 
111 
112 
113 /**
114  * @title ERC20Detailed token
115  * @dev The decimals are only for visualization purposes.
116  * All the operations are done using the smallest and indivisible token unit,
117  * just as on Ethereum all the operations are done in wei.
118  */
119 contract ERC20Detailed is IERC20 {
120     string private _name;
121     string private _symbol;
122     uint8 private _decimals;
123 
124     constructor (string memory name, string memory symbol, uint8 decimals) public {
125         _name = name;
126         _symbol = symbol;
127         _decimals = decimals;
128     }
129 
130     /**
131      * @return the name of the token.
132      */
133     function name() public view returns (string memory) {
134         return _name;
135     }
136 
137     /**
138      * @return the symbol of the token.
139      */
140     function symbol() public view returns (string memory) {
141         return _symbol;
142     }
143 
144     /**
145      * @return the number of decimals of the token.
146      */
147     function decimals() public view returns (uint8) {
148         return _decimals;
149     }
150 }
151 
152 
153 
154 
155 
156 
157 
158 
159 /**
160  * @title SafeMath
161  * @dev Unsigned math operations with safety checks that revert on error
162  */
163 library SafeMath {
164     /**
165      * @dev Multiplies two unsigned integers, reverts on overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b);
177 
178         return c;
179     }
180 
181     /**
182      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Solidity only automatically asserts when dividing by 0
186         require(b > 0);
187         uint256 c = a / b;
188         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
189 
190         return c;
191     }
192 
193     /**
194      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
195      */
196     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
197         require(b <= a);
198         uint256 c = a - b;
199 
200         return c;
201     }
202 
203     /**
204      * @dev Adds two unsigned integers, reverts on overflow.
205      */
206     function add(uint256 a, uint256 b) internal pure returns (uint256) {
207         uint256 c = a + b;
208         require(c >= a);
209 
210         return c;
211     }
212 
213     /**
214      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
215      * reverts when dividing by zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         require(b != 0);
219         return a % b;
220     }
221 }
222 
223 
224 /**
225  * @title Standard ERC20 token
226  *
227  * @dev Implementation of the basic standard token.
228  * https://eips.ethereum.org/EIPS/eip-20
229  * Originally based on code by FirstBlood:
230  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
231  *
232  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
233  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
234  * compliant implementations may not do it.
235  */
236 contract ERC20 is IERC20 {
237     using SafeMath for uint256;
238 
239     mapping (address => uint256) private _balances;
240 
241     mapping (address => mapping (address => uint256)) private _allowed;
242 
243     uint256 private _totalSupply;
244 
245     /**
246      * @dev Total number of tokens in existence
247      */
248     function totalSupply() public view returns (uint256) {
249         return _totalSupply;
250     }
251 
252     /**
253      * @dev Gets the balance of the specified address.
254      * @param owner The address to query the balance of.
255      * @return A uint256 representing the amount owned by the passed address.
256      */
257     function balanceOf(address owner) public view returns (uint256) {
258         return _balances[owner];
259     }
260 
261     /**
262      * @dev Function to check the amount of tokens that an owner allowed to a spender.
263      * @param owner address The address which owns the funds.
264      * @param spender address The address which will spend the funds.
265      * @return A uint256 specifying the amount of tokens still available for the spender.
266      */
267     function allowance(address owner, address spender) public view returns (uint256) {
268         return _allowed[owner][spender];
269     }
270 
271     /**
272      * @dev Transfer token to a specified address
273      * @param to The address to transfer to.
274      * @param value The amount to be transferred.
275      */
276     function transfer(address to, uint256 value) public returns (bool) {
277         _transfer(msg.sender, to, value);
278         return true;
279     }
280 
281     /**
282      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
283      * Beware that changing an allowance with this method brings the risk that someone may use both the old
284      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
285      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
286      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287      * @param spender The address which will spend the funds.
288      * @param value The amount of tokens to be spent.
289      */
290     function approve(address spender, uint256 value) public returns (bool) {
291         _approve(msg.sender, spender, value);
292         return true;
293     }
294 
295     /**
296      * @dev Transfer tokens from one address to another.
297      * Note that while this function emits an Approval event, this is not required as per the specification,
298      * and other compliant implementations may not emit the event.
299      * @param from address The address which you want to send tokens from
300      * @param to address The address which you want to transfer to
301      * @param value uint256 the amount of tokens to be transferred
302      */
303     function transferFrom(address from, address to, uint256 value) public returns (bool) {
304         _transfer(from, to, value);
305         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
306         return true;
307     }
308 
309     /**
310      * @dev Increase the amount of tokens that an owner allowed to a spender.
311      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
312      * allowed value is better to use this function to avoid 2 calls (and wait until
313      * the first transaction is mined)
314      * From MonolithDAO Token.sol
315      * Emits an Approval event.
316      * @param spender The address which will spend the funds.
317      * @param addedValue The amount of tokens to increase the allowance by.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
320         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
321         return true;
322     }
323 
324     /**
325      * @dev Decrease the amount of tokens that an owner allowed to a spender.
326      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
327      * allowed value is better to use this function to avoid 2 calls (and wait until
328      * the first transaction is mined)
329      * From MonolithDAO Token.sol
330      * Emits an Approval event.
331      * @param spender The address which will spend the funds.
332      * @param subtractedValue The amount of tokens to decrease the allowance by.
333      */
334     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
335         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
336         return true;
337     }
338 
339     /**
340      * @dev Transfer token for a specified addresses
341      * @param from The address to transfer from.
342      * @param to The address to transfer to.
343      * @param value The amount to be transferred.
344      */
345     function _transfer(address from, address to, uint256 value) internal {
346         require(to != address(0));
347 
348         _balances[from] = _balances[from].sub(value);
349         _balances[to] = _balances[to].add(value);
350         emit Transfer(from, to, value);
351     }
352 
353     /**
354      * @dev Internal function that mints an amount of the token and assigns it to
355      * an account. This encapsulates the modification of balances such that the
356      * proper events are emitted.
357      * @param account The account that will receive the created tokens.
358      * @param value The amount that will be created.
359      */
360     function _mint(address account, uint256 value) internal {
361         require(account != address(0));
362 
363         _totalSupply = _totalSupply.add(value);
364         _balances[account] = _balances[account].add(value);
365         emit Transfer(address(0), account, value);
366     }
367 
368     /**
369      * @dev Internal function that burns an amount of the token of a given
370      * account.
371      * @param account The account whose tokens will be burnt.
372      * @param value The amount that will be burnt.
373      */
374     function _burn(address account, uint256 value) internal {
375         require(account != address(0));
376 
377         _totalSupply = _totalSupply.sub(value);
378         _balances[account] = _balances[account].sub(value);
379         emit Transfer(account, address(0), value);
380     }
381 
382     /**
383      * @dev Approve an address to spend another addresses' tokens.
384      * @param owner The address that owns the tokens.
385      * @param spender The address that will spend the tokens.
386      * @param value The number of tokens that can be spent.
387      */
388     function _approve(address owner, address spender, uint256 value) internal {
389         require(spender != address(0));
390         require(owner != address(0));
391 
392         _allowed[owner][spender] = value;
393         emit Approval(owner, spender, value);
394     }
395 
396     /**
397      * @dev Internal function that burns an amount of the token of a given
398      * account, deducting from the sender's allowance for said account. Uses the
399      * internal burn function.
400      * Emits an Approval event (reflecting the reduced allowance).
401      * @param account The account whose tokens will be burnt.
402      * @param value The amount that will be burnt.
403      */
404     function _burnFrom(address account, uint256 value) internal {
405         _burn(account, value);
406         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
407     }
408 }
409 
410 
411 
412 
413 
414 /**
415  * @title Pausable
416  * @dev Base contract which allows children to implement an emergency stop mechanism.
417  */
418 contract Pausable is PauserRole {
419     event Paused(address account);
420     event Unpaused(address account);
421 
422     bool private _paused;
423 
424     constructor () internal {
425         _paused = false;
426     }
427 
428     /**
429      * @return true if the contract is paused, false otherwise.
430      */
431     function paused() public view returns (bool) {
432         return _paused;
433     }
434 
435     /**
436      * @dev Modifier to make a function callable only when the contract is not paused.
437      */
438     modifier whenNotPaused() {
439         require(!_paused);
440         _;
441     }
442 
443     /**
444      * @dev Modifier to make a function callable only when the contract is paused.
445      */
446     modifier whenPaused() {
447         require(_paused);
448         _;
449     }
450 
451     /**
452      * @dev called by the owner to pause, triggers stopped state
453      */
454     function pause() public onlyPauser whenNotPaused {
455         _paused = true;
456         emit Paused(msg.sender);
457     }
458 
459     /**
460      * @dev called by the owner to unpause, returns to normal state
461      */
462     function unpause() public onlyPauser whenPaused {
463         _paused = false;
464         emit Unpaused(msg.sender);
465     }
466 }
467 
468 
469 /**
470  * @title Pausable token
471  * @dev ERC20 modified with pausable transfers.
472  */
473 contract ERC20Pausable is ERC20, Pausable {
474     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
475         return super.transfer(to, value);
476     }
477 
478     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
479         return super.transferFrom(from, to, value);
480     }
481 
482     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
483         return super.approve(spender, value);
484     }
485 
486     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
487         return super.increaseAllowance(spender, addedValue);
488     }
489 
490     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
491         return super.decreaseAllowance(spender, subtractedValue);
492     }
493 }
494 
495 
496 contract DeepCloud is ERC20Pausable, ERC20Detailed {
497     uint8 public constant DECIMALS = 18;
498     uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(DECIMALS));
499     uint256 public constant CROWDSALE = 90000000 * (10 ** uint256(DECIMALS));
500     uint256 public constant BOOTSTRAP = 30000000 * (10 ** uint256(DECIMALS));
501     uint256 public constant RESERVES = 30000000 * (10 ** uint256(DECIMALS));
502     uint256 public constant ADVISORS = 10000000 * (10 ** uint256(DECIMALS));
503     uint256 public constant DEVELOPMENT = 30000000 * (10 ** uint256(DECIMALS));
504     uint256 public constant MARKETING = 10000000 * (10 ** uint256(DECIMALS));
505 
506     uint256 public unblock = 1623974399;
507     address private _owner;
508     uint256 private CrowdSale = 0;
509     uint256 private Bootstrap = 0;
510     uint256 private Reserves = 0;
511     uint256 private Advisors = 0;
512     uint256 private Development = 0;
513     uint256 private Marketing = 0;
514 
515 
516     mapping(address => bool) public capAddress;
517     uint256[] caps = [CROWDSALE,BOOTSTRAP,RESERVES,ADVISORS,DEVELOPMENT,MARKETING];
518     uint256[] supplied = [0,0,0,0,0,0];
519 
520     constructor () public ERC20Detailed("DeepCloud", "DEEP", DECIMALS) {
521       _owner = msg.sender;
522       _mint(msg.sender, INITIAL_SUPPLY);
523     }
524 
525     function initialTransfer(uint index,address to, uint256 value) public onlyOwner returns (bool){
526       _checkAvailableCap(index, value);
527       _updateCapSupply(index, value);
528       capAddress[to] = true;
529       transfer(to, value);
530       return true;
531     }
532 
533     function _updateCapSupply(uint index, uint256 value)  internal  {
534       supplied[index] += value;
535     }
536 
537     function _checkAvailableCap(uint index, uint256 value) internal view  {
538       require(caps[index] >= (supplied[index] + value), "Balance: Low balance");
539     }
540 
541     function transfer(address to, uint256 value) public returns (bool) {
542         require(checkLock());
543         return super.transfer(to, value);
544     }
545 
546     function transferFrom(address from, address to, uint256 value) public returns (bool) {
547         checkLock();
548         return super.transferFrom(from, to, value);
549     }
550 
551     function approve(address spender, uint256 value) public returns (bool) {
552         checkLock();
553         return super.approve(spender, value);
554     }
555 
556     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
557         checkLock();
558         return super.increaseAllowance(spender, addedValue);
559     }
560 
561     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
562         checkLock();
563         return super.decreaseAllowance(spender, subtractedValue);
564     }
565     function isOwner() public view returns (bool) {
566         return msg.sender == _owner;
567     }
568     modifier onlyOwner() {
569         require(isOwner(), "Ownable: caller is not the owner");
570         _;
571     }
572     function checkLock() internal view returns (bool){
573       if(capAddress[msg.sender]){
574           return now > unblock;
575       } else {
576           return true;
577       }
578     }
579 }