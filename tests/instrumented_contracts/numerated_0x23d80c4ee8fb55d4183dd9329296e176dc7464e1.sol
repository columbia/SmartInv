1 pragma solidity 0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     int256 constant private INT256_MIN = -2**255;
11 
12     /**
13     * @dev Multiplies two unsigned integers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Multiplies two signed integers, reverts on overflow.
31     */
32     function mul(int256 a, int256 b) internal pure returns (int256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (a == 0) {
37             return 0;
38         }
39 
40         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
41 
42         int256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
62     */
63     function div(int256 a, int256 b) internal pure returns (int256) {
64         require(b != 0); // Solidity only automatically asserts when dividing by 0
65         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
66 
67         int256 c = a / b;
68 
69         return c;
70     }
71 
72     /**
73     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74     */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b <= a);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83     * @dev Subtracts two signed integers, reverts on overflow.
84     */
85     function sub(int256 a, int256 b) internal pure returns (int256) {
86         int256 c = a - b;
87         require((b >= 0 && c <= a) || (b < 0 && c > a));
88 
89         return c;
90     }
91 
92     /**
93     * @dev Adds two unsigned integers, reverts on overflow.
94     */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Adds two signed integers, reverts on overflow.
104     */
105     function add(int256 a, int256 b) internal pure returns (int256) {
106         int256 c = a + b;
107         require((b >= 0 && c >= a) || (b < 0 && c < a));
108 
109         return c;
110     }
111 
112     /**
113     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
114     * reverts when dividing by zero.
115     */
116     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b != 0);
118         return a % b;
119     }
120 }
121 
122 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 interface IERC20 {
129     function totalSupply() external view returns (uint256);
130 
131     function balanceOf(address who) external view returns (uint256);
132 
133     function allowance(address owner, address spender) external view returns (uint256);
134 
135     function transfer(address to, uint256 value) external returns (bool);
136 
137     function approve(address spender, uint256 value) external returns (bool);
138 
139     function transferFrom(address from, address to, uint256 value) external returns (bool);
140 
141     event Transfer(address indexed from, address indexed to, uint256 value);
142 
143     event Approval(address indexed owner, address indexed spender, uint256 value);
144 }
145 
146 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
153  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  *
155  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
156  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
157  * compliant implementations may not do it.
158  */
159 contract ERC20 is IERC20 {
160     using SafeMath for uint256;
161 
162     mapping (address => uint256) private _balances;
163 
164     mapping (address => mapping (address => uint256)) private _allowed;
165 
166     uint256 private _totalSupply;
167 
168     /**
169     * @dev Total number of tokens in existence
170     */
171     function totalSupply() public view returns (uint256) {
172         return _totalSupply;
173     }
174 
175     /**
176     * @dev Gets the balance of the specified address.
177     * @param owner The address to query the balance of.
178     * @return An uint256 representing the amount owned by the passed address.
179     */
180     function balanceOf(address owner) public view returns (uint256) {
181         return _balances[owner];
182     }
183 
184     /**
185      * @dev Function to check the amount of tokens that an owner allowed to a spender.
186      * @param owner address The address which owns the funds.
187      * @param spender address The address which will spend the funds.
188      * @return A uint256 specifying the amount of tokens still available for the spender.
189      */
190     function allowance(address owner, address spender) public view returns (uint256) {
191         return _allowed[owner][spender];
192     }
193 
194     /**
195     * @dev Transfer token for a specified address
196     * @param to The address to transfer to.
197     * @param value The amount to be transferred.
198     */
199     function transfer(address to, uint256 value) public returns (bool) {
200         _transfer(msg.sender, to, value);
201         return true;
202     }
203 
204     /**
205      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206      * Beware that changing an allowance with this method brings the risk that someone may use both the old
207      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      * @param spender The address which will spend the funds.
211      * @param value The amount of tokens to be spent.
212      */
213     function approve(address spender, uint256 value) public returns (bool) {
214         require(spender != address(0));
215 
216         _allowed[msg.sender][spender] = value;
217         emit Approval(msg.sender, spender, value);
218         return true;
219     }
220 
221     /**
222      * @dev Transfer tokens from one address to another.
223      * Note that while this function emits an Approval event, this is not required as per the specification,
224      * and other compliant implementations may not emit the event.
225      * @param from address The address which you want to send tokens from
226      * @param to address The address which you want to transfer to
227      * @param value uint256 the amount of tokens to be transferred
228      */
229     function transferFrom(address from, address to, uint256 value) public returns (bool) {
230         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
231         _transfer(from, to, value);
232         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
233         return true;
234     }
235 
236     /**
237      * @dev Increase the amount of tokens that an owner allowed to a spender.
238      * approve should be called when allowed_[_spender] == 0. To increment
239      * allowed value is better to use this function to avoid 2 calls (and wait until
240      * the first transaction is mined)
241      * From MonolithDAO Token.sol
242      * Emits an Approval event.
243      * @param spender The address which will spend the funds.
244      * @param addedValue The amount of tokens to increase the allowance by.
245      */
246     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
247         require(spender != address(0));
248 
249         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
250         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
251         return true;
252     }
253 
254     /**
255      * @dev Decrease the amount of tokens that an owner allowed to a spender.
256      * approve should be called when allowed_[_spender] == 0. To decrement
257      * allowed value is better to use this function to avoid 2 calls (and wait until
258      * the first transaction is mined)
259      * From MonolithDAO Token.sol
260      * Emits an Approval event.
261      * @param spender The address which will spend the funds.
262      * @param subtractedValue The amount of tokens to decrease the allowance by.
263      */
264     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
265         require(spender != address(0));
266 
267         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
268         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
269         return true;
270     }
271 
272     /**
273     * @dev Transfer token for a specified addresses
274     * @param from The address to transfer from.
275     * @param to The address to transfer to.
276     * @param value The amount to be transferred.
277     */
278     function _transfer(address from, address to, uint256 value) internal {
279         require(to != address(0));
280 
281         _balances[from] = _balances[from].sub(value);
282         _balances[to] = _balances[to].add(value);
283         emit Transfer(from, to, value);
284     }
285 
286     /**
287      * @dev Internal function that mints an amount of the token and assigns it to
288      * an account. This encapsulates the modification of balances such that the
289      * proper events are emitted.
290      * @param account The account that will receive the created tokens.
291      * @param value The amount that will be created.
292      */
293     function _mint(address account, uint256 value) internal {
294         require(account != address(0));
295 
296         _totalSupply = _totalSupply.add(value);
297         _balances[account] = _balances[account].add(value);
298         emit Transfer(address(0), account, value);
299     }
300 
301     /**
302      * @dev Internal function that burns an amount of the token of a given
303      * account.
304      * @param account The account whose tokens will be burnt.
305      * @param value The amount that will be burnt.
306      */
307     function _burn(address account, uint256 value) internal {
308         require(account != address(0));
309 
310         _totalSupply = _totalSupply.sub(value);
311         _balances[account] = _balances[account].sub(value);
312         emit Transfer(account, address(0), value);
313     }
314 
315     /**
316      * @dev Internal function that burns an amount of the token of a given
317      * account, deducting from the sender's allowance for said account. Uses the
318      * internal burn function.
319      * Emits an Approval event (reflecting the reduced allowance).
320      * @param account The account whose tokens will be burnt.
321      * @param value The amount that will be burnt.
322      */
323     function _burnFrom(address account, uint256 value) internal {
324         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
325         _burn(account, value);
326         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
327     }
328 }
329 
330 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
331 
332 /**
333  * @title ERC20Detailed token
334  * @dev The decimals are only for visualization purposes.
335  * All the operations are done using the smallest and indivisible token unit,
336  * just as on Ethereum all the operations are done in wei.
337  */
338 contract ERC20Detailed is IERC20 {
339     string private _name;
340     string private _symbol;
341     uint8 private _decimals;
342 
343     constructor (string name, string symbol, uint8 decimals) public {
344         _name = name;
345         _symbol = symbol;
346         _decimals = decimals;
347     }
348 
349     /**
350      * @return the name of the token.
351      */
352     function name() public view returns (string) {
353         return _name;
354     }
355 
356     /**
357      * @return the symbol of the token.
358      */
359     function symbol() public view returns (string) {
360         return _symbol;
361     }
362 
363     /**
364      * @return the number of decimals of the token.
365      */
366     function decimals() public view returns (uint8) {
367         return _decimals;
368     }
369 }
370 
371 // File: openzeppelin-solidity/contracts/access/Roles.sol
372 
373 /**
374  * @title Roles
375  * @dev Library for managing addresses assigned to a Role.
376  */
377 library Roles {
378     struct Role {
379         mapping (address => bool) bearer;
380     }
381 
382     /**
383      * @dev give an account access to this role
384      */
385     function add(Role storage role, address account) internal {
386         require(account != address(0));
387         require(!has(role, account));
388 
389         role.bearer[account] = true;
390     }
391 
392     /**
393      * @dev remove an account's access to this role
394      */
395     function remove(Role storage role, address account) internal {
396         require(account != address(0));
397         require(has(role, account));
398 
399         role.bearer[account] = false;
400     }
401 
402     /**
403      * @dev check if an account has this role
404      * @return bool
405      */
406     function has(Role storage role, address account) internal view returns (bool) {
407         require(account != address(0));
408         return role.bearer[account];
409     }
410 }
411 
412 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
413 
414 contract MinterRole {
415     using Roles for Roles.Role;
416 
417     event MinterAdded(address indexed account);
418     event MinterRemoved(address indexed account);
419 
420     Roles.Role private _minters;
421 
422     constructor () internal {
423         _addMinter(msg.sender);
424     }
425 
426     modifier onlyMinter() {
427         require(isMinter(msg.sender));
428         _;
429     }
430 
431     function isMinter(address account) public view returns (bool) {
432         return _minters.has(account);
433     }
434 
435     function addMinter(address account) public onlyMinter {
436         _addMinter(account);
437     }
438 
439     function renounceMinter() public {
440         _removeMinter(msg.sender);
441     }
442 
443     function _addMinter(address account) internal {
444         _minters.add(account);
445         emit MinterAdded(account);
446     }
447 
448     function _removeMinter(address account) internal {
449         _minters.remove(account);
450         emit MinterRemoved(account);
451     }
452 }
453 
454 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
455 
456 /**
457  * @title ERC20Mintable
458  * @dev ERC20 minting logic
459  */
460 contract ERC20Mintable is ERC20, MinterRole {
461     /**
462      * @dev Function to mint tokens
463      * @param to The address that will receive the minted tokens.
464      * @param value The amount of tokens to mint.
465      * @return A boolean that indicates if the operation was successful.
466      */
467     function mint(address to, uint256 value) public onlyMinter returns (bool) {
468         _mint(to, value);
469         return true;
470     }
471 }
472 
473 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
474 
475 contract PauserRole {
476     using Roles for Roles.Role;
477 
478     event PauserAdded(address indexed account);
479     event PauserRemoved(address indexed account);
480 
481     Roles.Role private _pausers;
482 
483     constructor () internal {
484         _addPauser(msg.sender);
485     }
486 
487     modifier onlyPauser() {
488         require(isPauser(msg.sender));
489         _;
490     }
491 
492     function isPauser(address account) public view returns (bool) {
493         return _pausers.has(account);
494     }
495 
496     function addPauser(address account) public onlyPauser {
497         _addPauser(account);
498     }
499 
500     function renouncePauser() public {
501         _removePauser(msg.sender);
502     }
503 
504     function _addPauser(address account) internal {
505         _pausers.add(account);
506         emit PauserAdded(account);
507     }
508 
509     function _removePauser(address account) internal {
510         _pausers.remove(account);
511         emit PauserRemoved(account);
512     }
513 }
514 
515 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
516 
517 /**
518  * @title Pausable
519  * @dev Base contract which allows children to implement an emergency stop mechanism.
520  */
521 contract Pausable is PauserRole {
522     event Paused(address account);
523     event Unpaused(address account);
524 
525     bool private _paused;
526 
527     constructor () internal {
528         _paused = false;
529     }
530 
531     /**
532      * @return true if the contract is paused, false otherwise.
533      */
534     function paused() public view returns (bool) {
535         return _paused;
536     }
537 
538     /**
539      * @dev Modifier to make a function callable only when the contract is not paused.
540      */
541     modifier whenNotPaused() {
542         require(!_paused);
543         _;
544     }
545 
546     /**
547      * @dev Modifier to make a function callable only when the contract is paused.
548      */
549     modifier whenPaused() {
550         require(_paused);
551         _;
552     }
553 
554     /**
555      * @dev called by the owner to pause, triggers stopped state
556      */
557     function pause() public onlyPauser whenNotPaused {
558         _paused = true;
559         emit Paused(msg.sender);
560     }
561 
562     /**
563      * @dev called by the owner to unpause, returns to normal state
564      */
565     function unpause() public onlyPauser whenPaused {
566         _paused = false;
567         emit Unpaused(msg.sender);
568     }
569 }
570 
571 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
572 
573 /**
574  * @title Pausable token
575  * @dev ERC20 modified with pausable transfers.
576  **/
577 contract ERC20Pausable is ERC20, Pausable {
578     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
579         return super.transfer(to, value);
580     }
581 
582     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
583         return super.transferFrom(from, to, value);
584     }
585 
586     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
587         return super.approve(spender, value);
588     }
589 
590     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
591         return super.increaseAllowance(spender, addedValue);
592     }
593 
594     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
595         return super.decreaseAllowance(spender, subtractedValue);
596     }
597 }
598 
599 // File: contracts/Donut.sol
600 
601 contract Donut is ERC20, ERC20Detailed, ERC20Mintable, ERC20Pausable {
602   using SafeMath for uint256;
603 
604   event Deposit(
605       address from,
606       address indexed accountId,
607       uint256 value);
608 
609   constructor()
610       ERC20Mintable()
611       ERC20Pausable()
612       ERC20Detailed('Donut', 'DONUT', 18)
613       ERC20()
614       public {}
615 
616   function deposit(
617       address accountId,
618       uint256 value)
619       public
620       whenNotPaused
621       returns (bool) {
622     // Require deposits to be in whole number amounts.
623     require(value.mod(1e18) == 0);
624     _burn(msg.sender, value);
625     emit Deposit(msg.sender, accountId, value);
626     return true;
627   }
628 
629   function depositFrom(
630       address accountId,
631       address from,
632       uint256 value)
633       public
634       whenNotPaused
635       returns (bool) {
636     // Require deposits to be in whole number amounts.
637     require(value.mod(1e18) == 0);
638     _burnFrom(from, value);
639     emit Deposit(from, accountId, value);
640     return true;
641   }
642 }