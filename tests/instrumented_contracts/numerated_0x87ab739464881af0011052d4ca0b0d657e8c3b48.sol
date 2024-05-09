1 pragma solidity ^0.5.0;
2 
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
25 pragma solidity ^0.5.0;
26 
27 /**
28  * @title Roles
29  * @dev Library for managing addresses assigned to a Role.
30  */
31 library Roles {
32     struct Role {
33         mapping (address => bool) bearer;
34     }
35 
36     /**
37      * @dev Give an account access to this role.
38      */
39     function add(Role storage role, address account) internal {
40         require(!has(role, account), "Roles: account already has role");
41         role.bearer[account] = true;
42     }
43 
44     /**
45      * @dev Remove an account's access to this role.
46      */
47     function remove(Role storage role, address account) internal {
48         require(has(role, account), "Roles: account does not have role");
49         role.bearer[account] = false;
50     }
51 
52     /**
53      * @dev Check if an account has this role.
54      * @return bool
55      */
56     function has(Role storage role, address account) internal view returns (bool) {
57         require(account != address(0), "Roles: account is the zero address");
58         return role.bearer[account];
59     }
60 }
61 
62 pragma solidity ^0.5.0;
63 
64 contract MinterRole {
65     using Roles for Roles.Role;
66 
67     event MinterAdded(address indexed account);
68     event MinterRemoved(address indexed account);
69 
70     Roles.Role private _minters;
71 
72     constructor () internal {
73         _addMinter(msg.sender);
74     }
75 
76     modifier onlyMinter() {
77         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
78         _;
79     }
80 
81     function isMinter(address account) public view returns (bool) {
82         return _minters.has(account);
83     }
84 
85     function addMinter(address account) public onlyMinter {
86         _addMinter(account);
87     }
88 
89     function renounceMinter() public {
90         _removeMinter(msg.sender);
91     }
92 
93     function _addMinter(address account) internal {
94         _minters.add(account);
95         emit MinterAdded(account);
96     }
97 
98     function _removeMinter(address account) internal {
99         _minters.remove(account);
100         emit MinterRemoved(account);
101     }
102 }
103 
104 pragma solidity ^0.5.0;
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://eips.ethereum.org/EIPS/eip-20
111  * Originally based on code by FirstBlood:
112  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  *
114  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
115  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
116  * compliant implementations may not do it.
117  */
118 contract ERC20 is IERC20 {
119     using SafeMath for uint256;
120 
121     mapping (address => uint256) private _balances;
122 
123     mapping (address => mapping (address => uint256)) private _allowed;
124 
125     uint256 private _totalSupply;
126 
127     /**
128      * @dev Total number of tokens in existence.
129      */
130     function totalSupply() public view returns (uint256) {
131         return _totalSupply;
132     }
133 
134     /**
135      * @dev Gets the balance of the specified address.
136      * @param owner The address to query the balance of.
137      * @return A uint256 representing the amount owned by the passed address.
138      */
139     function balanceOf(address owner) public view returns (uint256) {
140         return _balances[owner];
141     }
142 
143     /**
144      * @dev Function to check the amount of tokens that an owner allowed to a spender.
145      * @param owner address The address which owns the funds.
146      * @param spender address The address which will spend the funds.
147      * @return A uint256 specifying the amount of tokens still available for the spender.
148      */
149     function allowance(address owner, address spender) public view returns (uint256) {
150         return _allowed[owner][spender];
151     }
152 
153     /**
154      * @dev Transfer token to a specified address.
155      * @param to The address to transfer to.
156      * @param value The amount to be transferred.
157      */
158     function transfer(address to, uint256 value) public returns (bool) {
159         _transfer(msg.sender, to, value);
160         return true;
161     }
162 
163     /**
164      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165      * Beware that changing an allowance with this method brings the risk that someone may use both the old
166      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      * @param spender The address which will spend the funds.
170      * @param value The amount of tokens to be spent.
171      */
172     function approve(address spender, uint256 value) public returns (bool) {
173         _approve(msg.sender, spender, value);
174         return true;
175     }
176 
177     /**
178      * @dev Transfer tokens from one address to another.
179      * Note that while this function emits an Approval event, this is not required as per the specification,
180      * and other compliant implementations may not emit the event.
181      * @param from address The address which you want to send tokens from
182      * @param to address The address which you want to transfer to
183      * @param value uint256 the amount of tokens to be transferred
184      */
185     function transferFrom(address from, address to, uint256 value) public returns (bool) {
186         _transfer(from, to, value);
187         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
188         return true;
189     }
190 
191     /**
192      * @dev Increase the amount of tokens that an owner allowed to a spender.
193      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
194      * allowed value is better to use this function to avoid 2 calls (and wait until
195      * the first transaction is mined)
196      * From MonolithDAO Token.sol
197      * Emits an Approval event.
198      * @param spender The address which will spend the funds.
199      * @param addedValue The amount of tokens to increase the allowance by.
200      */
201     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
202         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
203         return true;
204     }
205 
206     /**
207      * @dev Decrease the amount of tokens that an owner allowed to a spender.
208      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
209      * allowed value is better to use this function to avoid 2 calls (and wait until
210      * the first transaction is mined)
211      * From MonolithDAO Token.sol
212      * Emits an Approval event.
213      * @param spender The address which will spend the funds.
214      * @param subtractedValue The amount of tokens to decrease the allowance by.
215      */
216     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
217         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
218         return true;
219     }
220 
221     /**
222      * @dev Transfer token for a specified addresses.
223      * @param from The address to transfer from.
224      * @param to The address to transfer to.
225      * @param value The amount to be transferred.
226      */
227     function _transfer(address from, address to, uint256 value) internal {
228         require(to != address(0), "ERC20: transfer to the zero address");
229 
230         _balances[from] = _balances[from].sub(value);
231         _balances[to] = _balances[to].add(value);
232         emit Transfer(from, to, value);
233     }
234 
235     /**
236      * @dev Internal function that mints an amount of the token and assigns it to
237      * an account. This encapsulates the modification of balances such that the
238      * proper events are emitted.
239      * @param account The account that will receive the created tokens.
240      * @param value The amount that will be created.
241      */
242     function _mint(address account, uint256 value) internal {
243         require(account != address(0), "ERC20: mint to the zero address");
244 
245         _totalSupply = _totalSupply.add(value);
246         _balances[account] = _balances[account].add(value);
247         emit Transfer(address(0), account, value);
248     }
249 
250     /**
251      * @dev Internal function that burns an amount of the token of a given
252      * account.
253      * @param account The account whose tokens will be burnt.
254      * @param value The amount that will be burnt.
255      */
256     function _burn(address account, uint256 value) internal {
257         require(account != address(0), "ERC20: burn from the zero address");
258 
259         _totalSupply = _totalSupply.sub(value);
260         _balances[account] = _balances[account].sub(value);
261         emit Transfer(account, address(0), value);
262     }
263 
264     /**
265      * @dev Approve an address to spend another addresses' tokens.
266      * @param owner The address that owns the tokens.
267      * @param spender The address that will spend the tokens.
268      * @param value The number of tokens that can be spent.
269      */
270     function _approve(address owner, address spender, uint256 value) internal {
271         require(owner != address(0), "ERC20: approve from the zero address");
272         require(spender != address(0), "ERC20: approve to the zero address");
273 
274         _allowed[owner][spender] = value;
275         emit Approval(owner, spender, value);
276     }
277 
278     /**
279      * @dev Internal function that burns an amount of the token of a given
280      * account, deducting from the sender's allowance for said account. Uses the
281      * internal burn function.
282      * Emits an Approval event (reflecting the reduced allowance).
283      * @param account The account whose tokens will be burnt.
284      * @param value The amount that will be burnt.
285      */
286     function _burnFrom(address account, uint256 value) internal {
287         _burn(account, value);
288         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
289     }
290 }
291 
292 pragma solidity ^0.5.0;
293 
294 /**
295  * @title ERC20Mintable
296  * @dev ERC20 minting logic.
297  */
298 contract ERC20Mintable is ERC20, MinterRole {
299     /**
300      * @dev Function to mint tokens
301      * @param to The address that will receive the minted tokens.
302      * @param value The amount of tokens to mint.
303      * @return A boolean that indicates if the operation was successful.
304      */
305     function mint(address to, uint256 value) public onlyMinter returns (bool) {
306         _mint(to, value);
307         return true;
308     }
309 }
310 
311 pragma solidity ^0.5.0;
312 
313 /**
314  * @title Capped token
315  * @dev Mintable token with a token cap.
316  */
317 contract ERC20Capped is ERC20Mintable {
318     uint256 private _cap;
319 
320     constructor (uint256 cap) public {
321         require(cap > 0, "ERC20Capped: cap is 0");
322         _cap = cap;
323     }
324 
325     /**
326      * @return the cap for the token minting.
327      */
328     function cap() public view returns (uint256) {
329         return _cap;
330     }
331 
332     function _mint(address account, uint256 value) internal {
333         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
334         super._mint(account, value);
335     }
336 }
337 
338 pragma solidity ^0.5.0;
339 
340 /**
341  * @title SafeMath
342  * @dev Unsigned math operations with safety checks that revert on error.
343  */
344 library SafeMath {
345     /**
346      * @dev Multiplies two unsigned integers, reverts on overflow.
347      */
348     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
349         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
350         // benefit is lost if 'b' is also tested.
351         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
352         if (a == 0) {
353             return 0;
354         }
355 
356         uint256 c = a * b;
357         require(c / a == b, "SafeMath: multiplication overflow");
358 
359         return c;
360     }
361 
362     /**
363      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
364      */
365     function div(uint256 a, uint256 b) internal pure returns (uint256) {
366         // Solidity only automatically asserts when dividing by 0
367         require(b > 0, "SafeMath: division by zero");
368         uint256 c = a / b;
369         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
370 
371         return c;
372     }
373 
374     /**
375      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
376      */
377     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
378         require(b <= a, "SafeMath: subtraction overflow");
379         uint256 c = a - b;
380 
381         return c;
382     }
383 
384     /**
385      * @dev Adds two unsigned integers, reverts on overflow.
386      */
387     function add(uint256 a, uint256 b) internal pure returns (uint256) {
388         uint256 c = a + b;
389         require(c >= a, "SafeMath: addition overflow");
390 
391         return c;
392     }
393 
394     /**
395      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
396      * reverts when dividing by zero.
397      */
398     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
399         require(b != 0, "SafeMath: modulo by zero");
400         return a % b;
401     }
402 }
403 
404 pragma solidity ^0.5.0;
405 
406 contract PauserRole {
407     using Roles for Roles.Role;
408 
409     event PauserAdded(address indexed account);
410     event PauserRemoved(address indexed account);
411 
412     Roles.Role private _pausers;
413 
414     constructor () internal {
415         _addPauser(msg.sender);
416     }
417 
418     modifier onlyPauser() {
419         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
420         _;
421     }
422 
423     function isPauser(address account) public view returns (bool) {
424         return _pausers.has(account);
425     }
426 
427     function addPauser(address account) public onlyPauser {
428         _addPauser(account);
429     }
430 
431     function renouncePauser() public {
432         _removePauser(msg.sender);
433     }
434 
435     function _addPauser(address account) internal {
436         _pausers.add(account);
437         emit PauserAdded(account);
438     }
439 
440     function _removePauser(address account) internal {
441         _pausers.remove(account);
442         emit PauserRemoved(account);
443     }
444 }
445 
446 pragma solidity ^0.5.0;
447 
448 /**
449  * @title Pausable
450  * @dev Base contract which allows children to implement an emergency stop mechanism.
451  */
452 contract Pausable is PauserRole {
453     event Paused(address account);
454     event Unpaused(address account);
455 
456     bool private _paused;
457 
458     constructor () internal {
459         _paused = false;
460     }
461 
462     /**
463      * @return True if the contract is paused, false otherwise.
464      */
465     function paused() public view returns (bool) {
466         return _paused;
467     }
468 
469     /**
470      * @dev Modifier to make a function callable only when the contract is not paused.
471      */
472     modifier whenNotPaused() {
473         require(!_paused, "Pausable: paused");
474         _;
475     }
476 
477     /**
478      * @dev Modifier to make a function callable only when the contract is paused.
479      */
480     modifier whenPaused() {
481         require(_paused, "Pausable: not paused");
482         _;
483     }
484 
485     /**
486      * @dev Called by a pauser to pause, triggers stopped state.
487      */
488     function pause() public onlyPauser whenNotPaused {
489         _paused = true;
490         emit Paused(msg.sender);
491     }
492 
493     /**
494      * @dev Called by a pauser to unpause, returns to normal state.
495      */
496     function unpause() public onlyPauser whenPaused {
497         _paused = false;
498         emit Unpaused(msg.sender);
499     }
500 }
501 
502 pragma solidity ^0.5.0;
503 
504 /**
505  * @title Pausable token
506  * @dev ERC20 modified with pausable transfers.
507  */
508 contract ERC20Pausable is ERC20, Pausable {
509     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
510         return super.transfer(to, value);
511     }
512 
513     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
514         return super.transferFrom(from, to, value);
515     }
516 
517     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
518         return super.approve(spender, value);
519     }
520 
521     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
522         return super.increaseAllowance(spender, addedValue);
523     }
524 
525     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
526         return super.decreaseAllowance(spender, subtractedValue);
527     }
528 }
529 
530 pragma solidity ^0.5.0;
531 
532 /**
533  * @title Burnable Token
534  * @dev Token that can be irreversibly burned (destroyed).
535  */
536 contract ERC20Burnable is ERC20 {
537     /**
538      * @dev Burns a specific amount of tokens.
539      * @param value The amount of token to be burned.
540      */
541     function burn(uint256 value) public {
542         _burn(msg.sender, value);
543     }
544 
545     /**
546      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
547      * @param from address The account whose tokens will be burned.
548      * @param value uint256 The amount of token to be burned.
549      */
550     function burnFrom(address from, uint256 value) public {
551         _burnFrom(from, value);
552     }
553 }
554 
555 pragma solidity ^0.5.0;
556 
557 /**
558  * @title ERC20Detailed token
559  * @dev The decimals are only for visualization purposes.
560  * All the operations are done using the smallest and indivisible token unit,
561  * just as on Ethereum all the operations are done in wei.
562  */
563 contract ERC20Detailed is IERC20 {
564     string private _name;
565     string private _symbol;
566     uint8 private _decimals;
567 
568     constructor (string memory name, string memory symbol, uint8 decimals) public {
569         _name = name;
570         _symbol = symbol;
571         _decimals = decimals;
572     }
573 
574     /**
575      * @return the name of the token.
576      */
577     function name() public view returns (string memory) {
578         return _name;
579     }
580 
581     /**
582      * @return the symbol of the token.
583      */
584     function symbol() public view returns (string memory) {
585         return _symbol;
586     }
587 
588     /**
589      * @return the number of decimals of the token.
590      */
591     function decimals() public view returns (uint8) {
592         return _decimals;
593     }
594 }
595 
596 contract MTB19 is ERC20Pausable, ERC20Burnable, ERC20Capped, ERC20Detailed {
597 
598 	constructor(uint256 cap, address prefund, uint256 amount) public ERC20Capped(cap) ERC20Detailed("MikeTangoBravo19", "MTB19", 18) {
599       mint(prefund, amount);
600    }
601 
602 }