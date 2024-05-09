1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 pragma solidity ^0.5.2;
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32      * @dev Multiplies two unsigned integers, reverts on overflow.
33      */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50      */
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
61      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Adds two unsigned integers, reverts on overflow.
72      */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82      * reverts when dividing by zero.
83      */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
91 
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * https://eips.ethereum.org/EIPS/eip-20
98  * Originally based on code by FirstBlood:
99  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  *
101  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
102  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
103  * compliant implementations may not do it.
104  */
105 contract ERC20 is IERC20 {
106     using SafeMath for uint256;
107 
108     mapping (address => uint256) private _balances;
109 
110     mapping (address => mapping (address => uint256)) private _allowed;
111 
112     uint256 private _totalSupply;
113 
114     /**
115      * @dev Total number of tokens in existence
116      */
117     function totalSupply() public view returns (uint256) {
118         return _totalSupply;
119     }
120 
121     /**
122      * @dev Gets the balance of the specified address.
123      * @param owner The address to query the balance of.
124      * @return A uint256 representing the amount owned by the passed address.
125      */
126     function balanceOf(address owner) public view returns (uint256) {
127         return _balances[owner];
128     }
129 
130     /**
131      * @dev Function to check the amount of tokens that an owner allowed to a spender.
132      * @param owner address The address which owns the funds.
133      * @param spender address The address which will spend the funds.
134      * @return A uint256 specifying the amount of tokens still available for the spender.
135      */
136     function allowance(address owner, address spender) public view returns (uint256) {
137         return _allowed[owner][spender];
138     }
139 
140     /**
141      * @dev Transfer token to a specified address
142      * @param to The address to transfer to.
143      * @param value The amount to be transferred.
144      */
145     function transfer(address to, uint256 value) public returns (bool) {
146         _transfer(msg.sender, to, value);
147         return true;
148     }
149 
150     /**
151      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152      * Beware that changing an allowance with this method brings the risk that someone may use both the old
153      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      * @param spender The address which will spend the funds.
157      * @param value The amount of tokens to be spent.
158      */
159     function approve(address spender, uint256 value) public returns (bool) {
160         _approve(msg.sender, spender, value);
161         return true;
162     }
163 
164     /**
165      * @dev Transfer tokens from one address to another.
166      * Note that while this function emits an Approval event, this is not required as per the specification,
167      * and other compliant implementations may not emit the event.
168      * @param from address The address which you want to send tokens from
169      * @param to address The address which you want to transfer to
170      * @param value uint256 the amount of tokens to be transferred
171      */
172     function transferFrom(address from, address to, uint256 value) public returns (bool) {
173         _transfer(from, to, value);
174         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
175         return true;
176     }
177 
178     /**
179      * @dev Increase the amount of tokens that an owner allowed to a spender.
180      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * Emits an Approval event.
185      * @param spender The address which will spend the funds.
186      * @param addedValue The amount of tokens to increase the allowance by.
187      */
188     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
189         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
190         return true;
191     }
192 
193     /**
194      * @dev Decrease the amount of tokens that an owner allowed to a spender.
195      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
196      * allowed value is better to use this function to avoid 2 calls (and wait until
197      * the first transaction is mined)
198      * From MonolithDAO Token.sol
199      * Emits an Approval event.
200      * @param spender The address which will spend the funds.
201      * @param subtractedValue The amount of tokens to decrease the allowance by.
202      */
203     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
204         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
205         return true;
206     }
207 
208     /**
209      * @dev Transfer token for a specified addresses
210      * @param from The address to transfer from.
211      * @param to The address to transfer to.
212      * @param value The amount to be transferred.
213      */
214     function _transfer(address from, address to, uint256 value) internal {
215         require(to != address(0));
216 
217         _balances[from] = _balances[from].sub(value);
218         _balances[to] = _balances[to].add(value);
219         emit Transfer(from, to, value);
220     }
221 
222     /**
223      * @dev Internal function that mints an amount of the token and assigns it to
224      * an account. This encapsulates the modification of balances such that the
225      * proper events are emitted.
226      * @param account The account that will receive the created tokens.
227      * @param value The amount that will be created.
228      */
229     function _mint(address account, uint256 value) internal {
230         require(account != address(0));
231 
232         _totalSupply = _totalSupply.add(value);
233         _balances[account] = _balances[account].add(value);
234         emit Transfer(address(0), account, value);
235     }
236 
237     /**
238      * @dev Internal function that burns an amount of the token of a given
239      * account.
240      * @param account The account whose tokens will be burnt.
241      * @param value The amount that will be burnt.
242      */
243     function _burn(address account, uint256 value) internal {
244         require(account != address(0));
245 
246         _totalSupply = _totalSupply.sub(value);
247         _balances[account] = _balances[account].sub(value);
248         emit Transfer(account, address(0), value);
249     }
250 
251     /**
252      * @dev Approve an address to spend another addresses' tokens.
253      * @param owner The address that owns the tokens.
254      * @param spender The address that will spend the tokens.
255      * @param value The number of tokens that can be spent.
256      */
257     function _approve(address owner, address spender, uint256 value) internal {
258         require(spender != address(0));
259         require(owner != address(0));
260 
261         _allowed[owner][spender] = value;
262         emit Approval(owner, spender, value);
263     }
264 
265     /**
266      * @dev Internal function that burns an amount of the token of a given
267      * account, deducting from the sender's allowance for said account. Uses the
268      * internal burn function.
269      * Emits an Approval event (reflecting the reduced allowance).
270      * @param account The account whose tokens will be burnt.
271      * @param value The amount that will be burnt.
272      */
273     function _burnFrom(address account, uint256 value) internal {
274         _burn(account, value);
275         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
276     }
277 }
278 
279 // File: openzeppelin-solidity/contracts/access/Roles.sol
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
363 
364 /**
365  * @title ERC20Mintable
366  * @dev ERC20 minting logic
367  */
368 contract ERC20Mintable is ERC20, MinterRole {
369     /**
370      * @dev Function to mint tokens
371      * @param to The address that will receive the minted tokens.
372      * @param value The amount of tokens to mint.
373      * @return A boolean that indicates if the operation was successful.
374      */
375     function mint(address to, uint256 value) public onlyMinter returns (bool) {
376         _mint(to, value);
377         return true;
378     }
379 }
380 
381 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
382 
383 /**
384  * @title Capped token
385  * @dev Mintable token with a token cap.
386  */
387 contract ERC20Capped is ERC20Mintable {
388     uint256 private _cap;
389 
390     constructor (uint256 cap) public {
391         require(cap > 0);
392         _cap = cap;
393     }
394 
395     /**
396      * @return the cap for the token minting.
397      */
398     function cap() public view returns (uint256) {
399         return _cap;
400     }
401 
402     function _mint(address account, uint256 value) internal {
403         require(totalSupply().add(value) <= _cap);
404         super._mint(account, value);
405     }
406 }
407 
408 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
409 
410 /**
411  * @title Burnable Token
412  * @dev Token that can be irreversibly burned (destroyed).
413  */
414 contract ERC20Burnable is ERC20 {
415     /**
416      * @dev Burns a specific amount of tokens.
417      * @param value The amount of token to be burned.
418      */
419     function burn(uint256 value) public {
420         _burn(msg.sender, value);
421     }
422 
423     /**
424      * @dev Burns a specific amount of tokens from the target address and decrements allowance
425      * @param from address The account whose tokens will be burned.
426      * @param value uint256 The amount of token to be burned.
427      */
428     function burnFrom(address from, uint256 value) public {
429         _burnFrom(from, value);
430     }
431 }
432 
433 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
434 
435 /**
436  * @title ERC20Detailed token
437  * @dev The decimals are only for visualization purposes.
438  * All the operations are done using the smallest and indivisible token unit,
439  * just as on Ethereum all the operations are done in wei.
440  */
441 contract ERC20Detailed is IERC20 {
442     string private _name;
443     string private _symbol;
444     uint8 private _decimals;
445 
446     constructor (string memory name, string memory symbol, uint8 decimals) public {
447         _name = name;
448         _symbol = symbol;
449         _decimals = decimals;
450     }
451 
452     /**
453      * @return the name of the token.
454      */
455     function name() public view returns (string memory) {
456         return _name;
457     }
458 
459     /**
460      * @return the symbol of the token.
461      */
462     function symbol() public view returns (string memory) {
463         return _symbol;
464     }
465 
466     /**
467      * @return the number of decimals of the token.
468      */
469     function decimals() public view returns (uint8) {
470         return _decimals;
471     }
472 }
473 
474 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
475 
476 contract PauserRole {
477     using Roles for Roles.Role;
478 
479     event PauserAdded(address indexed account);
480     event PauserRemoved(address indexed account);
481 
482     Roles.Role private _pausers;
483 
484     constructor () internal {
485         _addPauser(msg.sender);
486     }
487 
488     modifier onlyPauser() {
489         require(isPauser(msg.sender));
490         _;
491     }
492 
493     function isPauser(address account) public view returns (bool) {
494         return _pausers.has(account);
495     }
496 
497     function addPauser(address account) public onlyPauser {
498         _addPauser(account);
499     }
500 
501     function renouncePauser() public {
502         _removePauser(msg.sender);
503     }
504 
505     function _addPauser(address account) internal {
506         _pausers.add(account);
507         emit PauserAdded(account);
508     }
509 
510     function _removePauser(address account) internal {
511         _pausers.remove(account);
512         emit PauserRemoved(account);
513     }
514 }
515 
516 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
517 
518 /**
519  * @title Pausable
520  * @dev Base contract which allows children to implement an emergency stop mechanism.
521  */
522 contract Pausable is PauserRole {
523     event Paused(address account);
524     event Unpaused(address account);
525 
526     bool private _paused;
527 
528     constructor () internal {
529         _paused = false;
530     }
531 
532     /**
533      * @return true if the contract is paused, false otherwise.
534      */
535     function paused() public view returns (bool) {
536         return _paused;
537     }
538 
539     /**
540      * @dev Modifier to make a function callable only when the contract is not paused.
541      */
542     modifier whenNotPaused() {
543         require(!_paused);
544         _;
545     }
546 
547     /**
548      * @dev Modifier to make a function callable only when the contract is paused.
549      */
550     modifier whenPaused() {
551         require(_paused);
552         _;
553     }
554 
555     /**
556      * @dev called by the owner to pause, triggers stopped state
557      */
558     function pause() public onlyPauser whenNotPaused {
559         _paused = true;
560         emit Paused(msg.sender);
561     }
562 
563     /**
564      * @dev called by the owner to unpause, returns to normal state
565      */
566     function unpause() public onlyPauser whenPaused {
567         _paused = false;
568         emit Unpaused(msg.sender);
569     }
570 }
571 
572 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
573 
574 
575 /**
576  * @title Pausable token
577  * @dev ERC20 modified with pausable transfers.
578  */
579 contract ERC20Pausable is ERC20, Pausable {
580     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
581         return super.transfer(to, value);
582     }
583 
584     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
585         return super.transferFrom(from, to, value);
586     }
587 
588     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
589         return super.approve(spender, value);
590     }
591 
592     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
593         return super.increaseAllowance(spender, addedValue);
594     }
595 
596     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
597         return super.decreaseAllowance(spender, subtractedValue);
598     }
599 }
600 
601 // File: contracts/eraswaptoken.sol
602 contract Eraswap is ERC20Detailed,ERC20Burnable,ERC20Capped,ERC20Pausable {
603 
604 event NRTManagerAdded(address NRTManager);
605 
606     constructor()
607         public
608          ERC20Detailed ("Era Swap", "ES", 18) ERC20Capped(9100000000000000000000000000) {
609              mint(msg.sender, 910000000000000000000000000);
610         }
611         
612         
613     /**
614     * @dev Function to add NRT Manager to have minting rights
615     * It will transfer the minting rights to NRTManager and revokes it from existing minter
616     * @param NRTManager Address of NRT Manager C ontract
617     */
618     function AddNRTManager(address NRTManager) public onlyMinter returns (bool) {
619         addMinter(NRTManager);
620         addPauser(NRTManager);
621         renounceMinter();
622         renouncePauser();
623         emit NRTManagerAdded(NRTManager);
624         return true;
625       }
626 
627 }