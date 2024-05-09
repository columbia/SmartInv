1 pragma solidity ^0.5.0;
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
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed_[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         require(spender != address(0));
196 
197         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
198         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      * approve should be called when allowed_[_spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
213         require(spender != address(0));
214 
215         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
216         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
217         return true;
218     }
219 
220     /**
221     * @dev Transfer token for a specified addresses
222     * @param from The address to transfer from.
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function _transfer(address from, address to, uint256 value) internal {
227         require(to != address(0));
228 
229         _balances[from] = _balances[from].sub(value);
230         _balances[to] = _balances[to].add(value);
231         emit Transfer(from, to, value);
232     }
233 
234     /**
235      * @dev Internal function that mints an amount of the token and assigns it to
236      * an account. This encapsulates the modification of balances such that the
237      * proper events are emitted.
238      * @param account The account that will receive the created tokens.
239      * @param value The amount that will be created.
240      */
241     function _mint(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.add(value);
245         _balances[account] = _balances[account].add(value);
246         emit Transfer(address(0), account, value);
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account.
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burn(address account, uint256 value) internal {
256         require(account != address(0));
257 
258         _totalSupply = _totalSupply.sub(value);
259         _balances[account] = _balances[account].sub(value);
260         emit Transfer(account, address(0), value);
261     }
262 
263     /**
264      * @dev Internal function that burns an amount of the token of a given
265      * account, deducting from the sender's allowance for said account. Uses the
266      * internal burn function.
267      * Emits an Approval event (reflecting the reduced allowance).
268      * @param account The account whose tokens will be burnt.
269      * @param value The amount that will be burnt.
270      */
271     function _burnFrom(address account, uint256 value) internal {
272         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
273         _burn(account, value);
274         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
275     }
276 }
277 
278 // File: openzeppelin-solidity/contracts/access/Roles.sol
279 
280 /**
281  * @title Roles
282  * @dev Library for managing addresses assigned to a Role.
283  */
284 library Roles {
285     struct Role {
286         mapping (address => bool) bearer;
287     }
288 
289     /**
290      * @dev give an account access to this role
291      */
292     function add(Role storage role, address account) internal {
293         require(account != address(0));
294         require(!has(role, account));
295 
296         role.bearer[account] = true;
297     }
298 
299     /**
300      * @dev remove an account's access to this role
301      */
302     function remove(Role storage role, address account) internal {
303         require(account != address(0));
304         require(has(role, account));
305 
306         role.bearer[account] = false;
307     }
308 
309     /**
310      * @dev check if an account has this role
311      * @return bool
312      */
313     function has(Role storage role, address account) internal view returns (bool) {
314         require(account != address(0));
315         return role.bearer[account];
316     }
317 }
318 
319 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
320 
321 contract MinterRole {
322     using Roles for Roles.Role;
323 
324     event MinterAdded(address indexed account);
325     event MinterRemoved(address indexed account);
326 
327     Roles.Role private _minters;
328 
329     constructor () internal {
330         _addMinter(msg.sender);
331     }
332 
333     modifier onlyMinter() {
334         require(isMinter(msg.sender));
335         _;
336     }
337 
338     function isMinter(address account) public view returns (bool) {
339         return _minters.has(account);
340     }
341 
342     function addMinter(address account) public onlyMinter {
343         _addMinter(account);
344     }
345 
346     function renounceMinter() public {
347         _removeMinter(msg.sender);
348     }
349 
350     function _addMinter(address account) internal {
351         _minters.add(account);
352         emit MinterAdded(account);
353     }
354 
355     function _removeMinter(address account) internal {
356         _minters.remove(account);
357         emit MinterRemoved(account);
358     }
359 }
360 
361 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
362 
363 /**
364  * @title ERC20Mintable
365  * @dev ERC20 minting logic
366  */
367 contract ERC20Mintable is ERC20, MinterRole {
368     /**
369      * @dev Function to mint tokens
370      * @param to The address that will receive the minted tokens.
371      * @param value The amount of tokens to mint.
372      * @return A boolean that indicates if the operation was successful.
373      */
374     function mint(address to, uint256 value) public onlyMinter returns (bool) {
375         _mint(to, value);
376         return true;
377     }
378 }
379 
380 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
381 
382 /**
383  * @title ERC20Detailed token
384  * @dev The decimals are only for visualization purposes.
385  * All the operations are done using the smallest and indivisible token unit,
386  * just as on Ethereum all the operations are done in wei.
387  */
388 contract ERC20Detailed is IERC20 {
389     string private _name;
390     string private _symbol;
391     uint8 private _decimals;
392 
393     constructor (string memory name, string memory symbol, uint8 decimals) public {
394         _name = name;
395         _symbol = symbol;
396         _decimals = decimals;
397     }
398 
399     /**
400      * @return the name of the token.
401      */
402     function name() public view returns (string memory) {
403         return _name;
404     }
405 
406     /**
407      * @return the symbol of the token.
408      */
409     function symbol() public view returns (string memory) {
410         return _symbol;
411     }
412 
413     /**
414      * @return the number of decimals of the token.
415      */
416     function decimals() public view returns (uint8) {
417         return _decimals;
418     }
419 }
420 
421 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
422 
423 contract PauserRole {
424     using Roles for Roles.Role;
425 
426     event PauserAdded(address indexed account);
427     event PauserRemoved(address indexed account);
428 
429     Roles.Role private _pausers;
430 
431     constructor () internal {
432         _addPauser(msg.sender);
433     }
434 
435     modifier onlyPauser() {
436         require(isPauser(msg.sender));
437         _;
438     }
439 
440     function isPauser(address account) public view returns (bool) {
441         return _pausers.has(account);
442     }
443 
444     function addPauser(address account) public onlyPauser {
445         _addPauser(account);
446     }
447 
448     function renouncePauser() public {
449         _removePauser(msg.sender);
450     }
451 
452     function _addPauser(address account) internal {
453         _pausers.add(account);
454         emit PauserAdded(account);
455     }
456 
457     function _removePauser(address account) internal {
458         _pausers.remove(account);
459         emit PauserRemoved(account);
460     }
461 }
462 
463 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
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
505     function pause() public onlyPauser whenNotPaused {
506         _paused = true;
507         emit Paused(msg.sender);
508     }
509 
510     /**
511      * @dev called by the owner to unpause, returns to normal state
512      */
513     function unpause() public onlyPauser whenPaused {
514         _paused = false;
515         emit Unpaused(msg.sender);
516     }
517 }
518 
519 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
520 
521 /**
522  * @title Pausable token
523  * @dev ERC20 modified with pausable transfers.
524  **/
525 contract ERC20Pausable is ERC20, Pausable {
526     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
527         return super.transfer(to, value);
528     }
529 
530     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
531         return super.transferFrom(from, to, value);
532     }
533 
534     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
535         return super.approve(spender, value);
536     }
537 
538     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
539         return super.increaseAllowance(spender, addedValue);
540     }
541 
542     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
543         return super.decreaseAllowance(spender, subtractedValue);
544     }
545 }
546 
547 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
548 
549 /**
550  * @title Burnable Token
551  * @dev Token that can be irreversibly burned (destroyed).
552  */
553 contract ERC20Burnable is ERC20 {
554     /**
555      * @dev Burns a specific amount of tokens.
556      * @param value The amount of token to be burned.
557      */
558     function burn(uint256 value) public {
559         _burn(msg.sender, value);
560     }
561 
562     /**
563      * @dev Burns a specific amount of tokens from the target address and decrements allowance
564      * @param from address The address which you want to send tokens from
565      * @param value uint256 The amount of token to be burned
566      */
567     function burnFrom(address from, uint256 value) public {
568         _burnFrom(from, value);
569     }
570 }
571 
572 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
573 
574 /**
575  * @title Ownable
576  * @dev The Ownable contract has an owner address, and provides basic authorization control
577  * functions, this simplifies the implementation of "user permissions".
578  */
579 contract Ownable {
580     address private _owner;
581 
582     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
583 
584     /**
585      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
586      * account.
587      */
588     constructor () internal {
589         _owner = msg.sender;
590         emit OwnershipTransferred(address(0), _owner);
591     }
592 
593     /**
594      * @return the address of the owner.
595      */
596     function owner() public view returns (address) {
597         return _owner;
598     }
599 
600     /**
601      * @dev Throws if called by any account other than the owner.
602      */
603     modifier onlyOwner() {
604         require(isOwner());
605         _;
606     }
607 
608     /**
609      * @return true if `msg.sender` is the owner of the contract.
610      */
611     function isOwner() public view returns (bool) {
612         return msg.sender == _owner;
613     }
614 
615     /**
616      * @dev Allows the current owner to relinquish control of the contract.
617      * @notice Renouncing to ownership will leave the contract without an owner.
618      * It will not be possible to call the functions with the `onlyOwner`
619      * modifier anymore.
620      */
621     function renounceOwnership() public onlyOwner {
622         emit OwnershipTransferred(_owner, address(0));
623         _owner = address(0);
624     }
625 
626     /**
627      * @dev Allows the current owner to transfer control of the contract to a newOwner.
628      * @param newOwner The address to transfer ownership to.
629      */
630     function transferOwnership(address newOwner) public onlyOwner {
631         _transferOwnership(newOwner);
632     }
633 
634     /**
635      * @dev Transfers control of the contract to a newOwner.
636      * @param newOwner The address to transfer ownership to.
637      */
638     function _transferOwnership(address newOwner) internal {
639         require(newOwner != address(0));
640         emit OwnershipTransferred(_owner, newOwner);
641         _owner = newOwner;
642     }
643 }
644 
645 // File: contracts/XSToken.sol
646 
647 contract XSToken is ERC20Detailed, ERC20, ERC20Mintable, ERC20Pausable, ERC20Burnable, Ownable {
648 
649     using SafeMath for uint256;
650     
651     constructor (
652             string memory name,
653             string memory symbol,
654             uint256 totalSupply,
655             uint8 decimals
656     ) ERC20Detailed(name, symbol, decimals)
657     public {
658         _mint(owner(), totalSupply * 10**uint(decimals));
659     }
660 }