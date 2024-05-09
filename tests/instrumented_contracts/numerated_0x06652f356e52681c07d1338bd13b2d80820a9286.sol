1 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
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
27 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Detailed.sol
28 
29 pragma solidity ^0.5.0;
30 
31 
32 /**
33  * @title ERC20Detailed token
34  * @dev The decimals are only for visualization purposes.
35  * All the operations are done using the smallest and indivisible token unit,
36  * just as on Ethereum all the operations are done in wei.
37  */
38 contract ERC20Detailed is IERC20 {
39     string private _name;
40     string private _symbol;
41     uint8 private _decimals;
42 
43     constructor (string memory name, string memory symbol, uint8 decimals) public {
44         _name = name;
45         _symbol = symbol;
46         _decimals = decimals;
47     }
48 
49     /**
50      * @return the name of the token.
51      */
52     function name() public view returns (string memory) {
53         return _name;
54     }
55 
56     /**
57      * @return the symbol of the token.
58      */
59     function symbol() public view returns (string memory) {
60         return _symbol;
61     }
62 
63     /**
64      * @return the number of decimals of the token.
65      */
66     function decimals() public view returns (uint8) {
67         return _decimals;
68     }
69 }
70 
71 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
72 
73 pragma solidity ^0.5.0;
74 
75 /**
76  * @title SafeMath
77  * @dev Unsigned math operations with safety checks that revert on error
78  */
79 library SafeMath {
80     /**
81      * @dev Multiplies two unsigned integers, reverts on overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b);
93 
94         return c;
95     }
96 
97     /**
98      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b > 0);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Adds two unsigned integers, reverts on overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a);
125 
126         return c;
127     }
128 
129     /**
130      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
131      * reverts when dividing by zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b != 0);
135         return a % b;
136     }
137 }
138 
139 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
140 
141 pragma solidity ^0.5.0;
142 
143 
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * https://eips.ethereum.org/EIPS/eip-20
150  * Originally based on code by FirstBlood:
151  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  *
153  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
154  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
155  * compliant implementations may not do it.
156  */
157 contract ERC20 is IERC20 {
158     using SafeMath for uint256;
159 
160     mapping (address => uint256) private _balances;
161 
162     mapping (address => mapping (address => uint256)) private _allowed;
163 
164     uint256 private _totalSupply;
165 
166     /**
167      * @dev Total number of tokens in existence
168      */
169     function totalSupply() public view returns (uint256) {
170         return _totalSupply;
171     }
172 
173     /**
174      * @dev Gets the balance of the specified address.
175      * @param owner The address to query the balance of.
176      * @return A uint256 representing the amount owned by the passed address.
177      */
178     function balanceOf(address owner) public view returns (uint256) {
179         return _balances[owner];
180     }
181 
182     /**
183      * @dev Function to check the amount of tokens that an owner allowed to a spender.
184      * @param owner address The address which owns the funds.
185      * @param spender address The address which will spend the funds.
186      * @return A uint256 specifying the amount of tokens still available for the spender.
187      */
188     function allowance(address owner, address spender) public view returns (uint256) {
189         return _allowed[owner][spender];
190     }
191 
192     /**
193      * @dev Transfer token to a specified address
194      * @param to The address to transfer to.
195      * @param value The amount to be transferred.
196      */
197     function transfer(address to, uint256 value) public returns (bool) {
198         _transfer(msg.sender, to, value);
199         return true;
200     }
201 
202     /**
203      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204      * Beware that changing an allowance with this method brings the risk that someone may use both the old
205      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      * @param spender The address which will spend the funds.
209      * @param value The amount of tokens to be spent.
210      */
211     function approve(address spender, uint256 value) public returns (bool) {
212         _approve(msg.sender, spender, value);
213         return true;
214     }
215 
216     /**
217      * @dev Transfer tokens from one address to another.
218      * Note that while this function emits an Approval event, this is not required as per the specification,
219      * and other compliant implementations may not emit the event.
220      * @param from address The address which you want to send tokens from
221      * @param to address The address which you want to transfer to
222      * @param value uint256 the amount of tokens to be transferred
223      */
224     function transferFrom(address from, address to, uint256 value) public returns (bool) {
225         _transfer(from, to, value);
226         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
227         return true;
228     }
229 
230     /**
231      * @dev Increase the amount of tokens that an owner allowed to a spender.
232      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
233      * allowed value is better to use this function to avoid 2 calls (and wait until
234      * the first transaction is mined)
235      * From MonolithDAO Token.sol
236      * Emits an Approval event.
237      * @param spender The address which will spend the funds.
238      * @param addedValue The amount of tokens to increase the allowance by.
239      */
240     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
241         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
242         return true;
243     }
244 
245     /**
246      * @dev Decrease the amount of tokens that an owner allowed to a spender.
247      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
248      * allowed value is better to use this function to avoid 2 calls (and wait until
249      * the first transaction is mined)
250      * From MonolithDAO Token.sol
251      * Emits an Approval event.
252      * @param spender The address which will spend the funds.
253      * @param subtractedValue The amount of tokens to decrease the allowance by.
254      */
255     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
256         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
257         return true;
258     }
259 
260     /**
261      * @dev Transfer token for a specified addresses
262      * @param from The address to transfer from.
263      * @param to The address to transfer to.
264      * @param value The amount to be transferred.
265      */
266     function _transfer(address from, address to, uint256 value) internal {
267         require(to != address(0));
268 
269         _balances[from] = _balances[from].sub(value);
270         _balances[to] = _balances[to].add(value);
271         emit Transfer(from, to, value);
272     }
273 
274     /**
275      * @dev Internal function that mints an amount of the token and assigns it to
276      * an account. This encapsulates the modification of balances such that the
277      * proper events are emitted.
278      * @param account The account that will receive the created tokens.
279      * @param value The amount that will be created.
280      */
281     function _mint(address account, uint256 value) internal {
282         require(account != address(0));
283 
284         _totalSupply = _totalSupply.add(value);
285         _balances[account] = _balances[account].add(value);
286         emit Transfer(address(0), account, value);
287     }
288 
289     /**
290      * @dev Internal function that burns an amount of the token of a given
291      * account.
292      * @param account The account whose tokens will be burnt.
293      * @param value The amount that will be burnt.
294      */
295     function _burn(address account, uint256 value) internal {
296         require(account != address(0));
297 
298         _totalSupply = _totalSupply.sub(value);
299         _balances[account] = _balances[account].sub(value);
300         emit Transfer(account, address(0), value);
301     }
302 
303     /**
304      * @dev Approve an address to spend another addresses' tokens.
305      * @param owner The address that owns the tokens.
306      * @param spender The address that will spend the tokens.
307      * @param value The number of tokens that can be spent.
308      */
309     function _approve(address owner, address spender, uint256 value) internal {
310         require(spender != address(0));
311         require(owner != address(0));
312 
313         _allowed[owner][spender] = value;
314         emit Approval(owner, spender, value);
315     }
316 
317     /**
318      * @dev Internal function that burns an amount of the token of a given
319      * account, deducting from the sender's allowance for said account. Uses the
320      * internal burn function.
321      * Emits an Approval event (reflecting the reduced allowance).
322      * @param account The account whose tokens will be burnt.
323      * @param value The amount that will be burnt.
324      */
325     function _burnFrom(address account, uint256 value) internal {
326         _burn(account, value);
327         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
328     }
329 }
330 
331 // File: node_modules\openzeppelin-solidity\contracts\access\Roles.sol
332 
333 pragma solidity ^0.5.0;
334 
335 /**
336  * @title Roles
337  * @dev Library for managing addresses assigned to a Role.
338  */
339 library Roles {
340     struct Role {
341         mapping (address => bool) bearer;
342     }
343 
344     /**
345      * @dev give an account access to this role
346      */
347     function add(Role storage role, address account) internal {
348         require(account != address(0));
349         require(!has(role, account));
350 
351         role.bearer[account] = true;
352     }
353 
354     /**
355      * @dev remove an account's access to this role
356      */
357     function remove(Role storage role, address account) internal {
358         require(account != address(0));
359         require(has(role, account));
360 
361         role.bearer[account] = false;
362     }
363 
364     /**
365      * @dev check if an account has this role
366      * @return bool
367      */
368     function has(Role storage role, address account) internal view returns (bool) {
369         require(account != address(0));
370         return role.bearer[account];
371     }
372 }
373 
374 // File: node_modules\openzeppelin-solidity\contracts\access\roles\PauserRole.sol
375 
376 pragma solidity ^0.5.0;
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
419 // File: node_modules\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
420 
421 pragma solidity ^0.5.0;
422 
423 
424 /**
425  * @title Pausable
426  * @dev Base contract which allows children to implement an emergency stop mechanism.
427  */
428 contract Pausable is PauserRole {
429     event Paused(address account);
430     event Unpaused(address account);
431 
432     bool private _paused;
433 
434     constructor () internal {
435         _paused = false;
436     }
437 
438     /**
439      * @return true if the contract is paused, false otherwise.
440      */
441     function paused() public view returns (bool) {
442         return _paused;
443     }
444 
445     /**
446      * @dev Modifier to make a function callable only when the contract is not paused.
447      */
448     modifier whenNotPaused() {
449         require(!_paused);
450         _;
451     }
452 
453     /**
454      * @dev Modifier to make a function callable only when the contract is paused.
455      */
456     modifier whenPaused() {
457         require(_paused);
458         _;
459     }
460 
461     /**
462      * @dev called by the owner to pause, triggers stopped state
463      */
464     function pause() public onlyPauser whenNotPaused {
465         _paused = true;
466         emit Paused(msg.sender);
467     }
468 
469     /**
470      * @dev called by the owner to unpause, returns to normal state
471      */
472     function unpause() public onlyPauser whenPaused {
473         _paused = false;
474         emit Unpaused(msg.sender);
475     }
476 }
477 
478 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Pausable.sol
479 
480 pragma solidity ^0.5.0;
481 
482 
483 
484 /**
485  * @title Pausable token
486  * @dev ERC20 modified with pausable transfers.
487  */
488 contract ERC20Pausable is ERC20, Pausable {
489     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
490         return super.transfer(to, value);
491     }
492 
493     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
494         return super.transferFrom(from, to, value);
495     }
496 
497     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
498         return super.approve(spender, value);
499     }
500 
501     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
502         return super.increaseAllowance(spender, addedValue);
503     }
504 
505     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
506         return super.decreaseAllowance(spender, subtractedValue);
507     }
508 }
509 
510 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
511 
512 pragma solidity ^0.5.0;
513 
514 /**
515  * @title Ownable
516  * @dev The Ownable contract has an owner address, and provides basic authorization control
517  * functions, this simplifies the implementation of "user permissions".
518  */
519 contract Ownable {
520     address private _owner;
521 
522     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
523 
524     /**
525      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
526      * account.
527      */
528     constructor () internal {
529         _owner = msg.sender;
530         emit OwnershipTransferred(address(0), _owner);
531     }
532 
533     /**
534      * @return the address of the owner.
535      */
536     function owner() public view returns (address) {
537         return _owner;
538     }
539 
540     /**
541      * @dev Throws if called by any account other than the owner.
542      */
543     modifier onlyOwner() {
544         require(isOwner());
545         _;
546     }
547 
548     /**
549      * @return true if `msg.sender` is the owner of the contract.
550      */
551     function isOwner() public view returns (bool) {
552         return msg.sender == _owner;
553     }
554 
555     /**
556      * @dev Allows the current owner to relinquish control of the contract.
557      * It will not be possible to call the functions with the `onlyOwner`
558      * modifier anymore.
559      * @notice Renouncing ownership will leave the contract without an owner,
560      * thereby removing any functionality that is only available to the owner.
561      */
562     function renounceOwnership() public onlyOwner {
563         emit OwnershipTransferred(_owner, address(0));
564         _owner = address(0);
565     }
566 
567     /**
568      * @dev Allows the current owner to transfer control of the contract to a newOwner.
569      * @param newOwner The address to transfer ownership to.
570      */
571     function transferOwnership(address newOwner) public onlyOwner {
572         _transferOwnership(newOwner);
573     }
574 
575     /**
576      * @dev Transfers control of the contract to a newOwner.
577      * @param newOwner The address to transfer ownership to.
578      */
579     function _transferOwnership(address newOwner) internal {
580         require(newOwner != address(0));
581         emit OwnershipTransferred(_owner, newOwner);
582         _owner = newOwner;
583     }
584 }
585 
586 // File: contracts\token\SnowdaqToken.sol
587 
588 pragma solidity ^0.5.0;
589 
590 
591 
592 
593 
594 contract SDCToken is ERC20Detailed, ERC20Pausable, Ownable {
595     uint256 constant public SDC_TotalSupply = 1 * 10 ** 9;
596     bool private _isDistribute = false;
597 
598 
599     constructor (string memory name, string memory symbol)
600     ERC20Detailed(name, symbol, 18)
601     public {
602         uint256 initialSupply = SDC_TotalSupply * 10 ** uint256(decimals());
603         _mint(msg.sender, initialSupply);
604     }
605 
606 
607     function distribute(address teams, address advisors, address reserve)
608     public
609     onlyOwner {
610         require(_isDistribute == false);
611         require(teams != address(0x0));
612         require(advisors != address(0x0));
613         require(reserve != address(0x0));
614 
615         _transfer(msg.sender, teams, (totalSupply().mul(10)).div(100));
616         _transfer(msg.sender, advisors, (totalSupply().mul(17)).div(100));
617         _transfer(msg.sender, reserve, (totalSupply().mul(10)).div(100));
618 
619         _isDistribute = true;
620     }
621 }