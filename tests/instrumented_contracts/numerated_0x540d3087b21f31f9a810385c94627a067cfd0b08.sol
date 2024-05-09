1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender)
15         external
16         view
17         returns (uint256);
18 
19     function transfer(address to, uint256 value) external returns (bool);
20 
21     function approve(address spender, uint256 value) external returns (bool);
22 
23     function transferFrom(
24         address from,
25         address to,
26         uint256 value
27     ) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
39 
40 pragma solidity ^0.4.24;
41 
42 /**
43  * @title ERC20Detailed token
44  * @dev The decimals are only for visualization purposes.
45  * All the operations are done using the smallest and indivisible token unit,
46  * just as on Ethereum all the operations are done in wei.
47  */
48 contract ERC20Detailed is IERC20 {
49     string private _name;
50     string private _symbol;
51     uint8 private _decimals;
52 
53     constructor(
54         string name,
55         string symbol,
56         uint8 decimals
57     ) public {
58         _name = name;
59         _symbol = symbol;
60         _decimals = decimals;
61     }
62 
63     /**
64      * @return the name of the token.
65      */
66     function name() public view returns (string) {
67         return _name;
68     }
69 
70     /**
71      * @return the symbol of the token.
72      */
73     function symbol() public view returns (string) {
74         return _symbol;
75     }
76 
77     /**
78      * @return the number of decimals of the token.
79      */
80     function decimals() public view returns (uint8) {
81         return _decimals;
82     }
83 }
84 
85 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
86 
87 pragma solidity ^0.4.24;
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that revert on error
92  */
93 library SafeMath {
94     /**
95      * @dev Multiplies two numbers, reverts on overflow.
96      */
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
99         // benefit is lost if 'b' is also tested.
100         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
101         if (a == 0) {
102             return 0;
103         }
104 
105         uint256 c = a * b;
106         require(c / a == b);
107 
108         return c;
109     }
110 
111     /**
112      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
113      */
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b > 0); // Solidity only automatically asserts when dividing by 0
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b <= a);
127         uint256 c = a - b;
128 
129         return c;
130     }
131 
132     /**
133      * @dev Adds two numbers, reverts on overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a);
138 
139         return c;
140     }
141 
142     /**
143      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
144      * reverts when dividing by zero.
145      */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         require(b != 0);
148         return a % b;
149     }
150 }
151 
152 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
153 
154 pragma solidity ^0.4.24;
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
161  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract ERC20 is IERC20 {
164     using SafeMath for uint256;
165 
166     mapping(address => uint256) private _balances;
167 
168     mapping(address => mapping(address => uint256)) private _allowed;
169 
170     uint256 private _totalSupply;
171 
172     /**
173      * @dev Total number of tokens in existence
174      */
175     function totalSupply() public view returns (uint256) {
176         return _totalSupply;
177     }
178 
179     /**
180      * @dev Gets the balance of the specified address.
181      * @param owner The address to query the balance of.
182      * @return An uint256 representing the amount owned by the passed address.
183      */
184     function balanceOf(address owner) public view returns (uint256) {
185         return _balances[owner];
186     }
187 
188     /**
189      * @dev Function to check the amount of tokens that an owner allowed to a spender.
190      * @param owner address The address which owns the funds.
191      * @param spender address The address which will spend the funds.
192      * @return A uint256 specifying the amount of tokens still available for the spender.
193      */
194     function allowance(address owner, address spender)
195         public
196         view
197         returns (uint256)
198     {
199         return _allowed[owner][spender];
200     }
201 
202     /**
203      * @dev Transfer token for a specified address
204      * @param to The address to transfer to.
205      * @param value The amount to be transferred.
206      */
207     function transfer(address to, uint256 value) public returns (bool) {
208         _transfer(msg.sender, to, value);
209         return true;
210     }
211 
212     /**
213      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214      * Beware that changing an allowance with this method brings the risk that someone may use both the old
215      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      * @param spender The address which will spend the funds.
219      * @param value The amount of tokens to be spent.
220      */
221     function approve(address spender, uint256 value) public returns (bool) {
222         require(spender != address(0));
223 
224         _allowed[msg.sender][spender] = value;
225         emit Approval(msg.sender, spender, value);
226         return true;
227     }
228 
229     /**
230      * @dev Transfer tokens from one address to another
231      * @param from address The address which you want to send tokens from
232      * @param to address The address which you want to transfer to
233      * @param value uint256 the amount of tokens to be transferred
234      */
235     function transferFrom(
236         address from,
237         address to,
238         uint256 value
239     ) public returns (bool) {
240         require(value <= _allowed[from][msg.sender]);
241 
242         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
243         _transfer(from, to, value);
244         return true;
245     }
246 
247     /**
248      * @dev Increase the amount of tokens that an owner allowed to a spender.
249      * approve should be called when allowed_[_spender] == 0. To increment
250      * allowed value is better to use this function to avoid 2 calls (and wait until
251      * the first transaction is mined)
252      * From MonolithDAO Token.sol
253      * @param spender The address which will spend the funds.
254      * @param addedValue The amount of tokens to increase the allowance by.
255      */
256     function increaseAllowance(address spender, uint256 addedValue)
257         public
258         returns (bool)
259     {
260         require(spender != address(0));
261 
262         _allowed[msg.sender][spender] = (
263             _allowed[msg.sender][spender].add(addedValue)
264         );
265         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
266         return true;
267     }
268 
269     /**
270      * @dev Decrease the amount of tokens that an owner allowed to a spender.
271      * approve should be called when allowed_[_spender] == 0. To decrement
272      * allowed value is better to use this function to avoid 2 calls (and wait until
273      * the first transaction is mined)
274      * From MonolithDAO Token.sol
275      * @param spender The address which will spend the funds.
276      * @param subtractedValue The amount of tokens to decrease the allowance by.
277      */
278     function decreaseAllowance(address spender, uint256 subtractedValue)
279         public
280         returns (bool)
281     {
282         require(spender != address(0));
283 
284         _allowed[msg.sender][spender] = (
285             _allowed[msg.sender][spender].sub(subtractedValue)
286         );
287         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
288         return true;
289     }
290 
291     /**
292      * @dev Transfer token for a specified addresses
293      * @param from The address to transfer from.
294      * @param to The address to transfer to.
295      * @param value The amount to be transferred.
296      */
297     function _transfer(
298         address from,
299         address to,
300         uint256 value
301     ) internal {
302         require(value <= _balances[from]);
303         require(to != address(0));
304 
305         _balances[from] = _balances[from].sub(value);
306         _balances[to] = _balances[to].add(value);
307         emit Transfer(from, to, value);
308     }
309 
310     /**
311      * @dev Internal function that mints an amount of the token and assigns it to
312      * an account. This encapsulates the modification of balances such that the
313      * proper events are emitted.
314      * @param account The account that will receive the created tokens.
315      * @param value The amount that will be created.
316      */
317     function _mint(address account, uint256 value) internal {
318         require(account != 0);
319         _totalSupply = _totalSupply.add(value);
320         _balances[account] = _balances[account].add(value);
321         emit Transfer(address(0), account, value);
322     }
323 
324     /**
325      * @dev Internal function that burns an amount of the token of a given
326      * account.
327      * @param account The account whose tokens will be burnt.
328      * @param value The amount that will be burnt.
329      */
330     function _burn(address account, uint256 value) internal {
331         require(account != 0);
332         require(value <= _balances[account]);
333 
334         _totalSupply = _totalSupply.sub(value);
335         _balances[account] = _balances[account].sub(value);
336         emit Transfer(account, address(0), value);
337     }
338 
339     /**
340      * @dev Internal function that burns an amount of the token of a given
341      * account, deducting from the sender's allowance for said account. Uses the
342      * internal burn function.
343      * @param account The account whose tokens will be burnt.
344      * @param value The amount that will be burnt.
345      */
346     function _burnFrom(address account, uint256 value) internal {
347         require(value <= _allowed[account][msg.sender]);
348 
349         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
350         // this function needs to emit an event with the updated approval.
351         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
352             value
353         );
354         _burn(account, value);
355     }
356 }
357 
358 // File: openzeppelin-solidity/contracts/access/Roles.sol
359 
360 pragma solidity ^0.4.24;
361 
362 /**
363  * @title Roles
364  * @dev Library for managing addresses assigned to a Role.
365  */
366 library Roles {
367     struct Role {
368         mapping(address => bool) bearer;
369     }
370 
371     /**
372      * @dev give an account access to this role
373      */
374     function add(Role storage role, address account) internal {
375         require(account != address(0));
376         require(!has(role, account));
377 
378         role.bearer[account] = true;
379     }
380 
381     /**
382      * @dev remove an account's access to this role
383      */
384     function remove(Role storage role, address account) internal {
385         require(account != address(0));
386         require(has(role, account));
387 
388         role.bearer[account] = false;
389     }
390 
391     /**
392      * @dev check if an account has this role
393      * @return bool
394      */
395     function has(Role storage role, address account)
396         internal
397         view
398         returns (bool)
399     {
400         require(account != address(0));
401         return role.bearer[account];
402     }
403 }
404 
405 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
406 
407 pragma solidity ^0.4.24;
408 
409 contract PauserRole {
410     using Roles for Roles.Role;
411 
412     event PauserAdded(address indexed account);
413     event PauserRemoved(address indexed account);
414 
415     Roles.Role private pausers;
416 
417     constructor() internal {
418         _addPauser(msg.sender);
419     }
420 
421     modifier onlyPauser() {
422         require(isPauser(msg.sender));
423         _;
424     }
425 
426     function isPauser(address account) public view returns (bool) {
427         return pausers.has(account);
428     }
429 
430     function addPauser(address account) public onlyPauser {
431         _addPauser(account);
432     }
433 
434     function renouncePauser() public {
435         _removePauser(msg.sender);
436     }
437 
438     function _addPauser(address account) internal {
439         pausers.add(account);
440         emit PauserAdded(account);
441     }
442 
443     function _removePauser(address account) internal {
444         pausers.remove(account);
445         emit PauserRemoved(account);
446     }
447 }
448 
449 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
450 
451 pragma solidity ^0.4.24;
452 
453 /**
454  * @title Pausable
455  * @dev Base contract which allows children to implement an emergency stop mechanism.
456  */
457 contract Pausable is PauserRole {
458     event Paused(address account);
459     event Unpaused(address account);
460 
461     bool private _paused;
462 
463     constructor() internal {
464         _paused = false;
465     }
466 
467     /**
468      * @return true if the contract is paused, false otherwise.
469      */
470     function paused() public view returns (bool) {
471         return _paused;
472     }
473 
474     /**
475      * @dev Modifier to make a function callable only when the contract is not paused.
476      */
477     modifier whenNotPaused() {
478         require(!_paused);
479         _;
480     }
481 
482     /**
483      * @dev Modifier to make a function callable only when the contract is paused.
484      */
485     modifier whenPaused() {
486         require(_paused);
487         _;
488     }
489 
490     /**
491      * @dev called by the owner to pause, triggers stopped state
492      */
493     function pause() public onlyPauser whenNotPaused {
494         _paused = true;
495         emit Paused(msg.sender);
496     }
497 
498     /**
499      * @dev called by the owner to unpause, returns to normal state
500      */
501     function unpause() public onlyPauser whenPaused {
502         _paused = false;
503         emit Unpaused(msg.sender);
504     }
505 }
506 
507 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
508 
509 pragma solidity ^0.4.24;
510 
511 /**
512  * @title Pausable token
513  * @dev ERC20 modified with pausable transfers.
514  **/
515 contract ERC20Pausable is ERC20, Pausable {
516     function transfer(address to, uint256 value)
517         public
518         whenNotPaused
519         returns (bool)
520     {
521         return super.transfer(to, value);
522     }
523 
524     function transferFrom(
525         address from,
526         address to,
527         uint256 value
528     ) public whenNotPaused returns (bool) {
529         return super.transferFrom(from, to, value);
530     }
531 
532     function approve(address spender, uint256 value)
533         public
534         whenNotPaused
535         returns (bool)
536     {
537         return super.approve(spender, value);
538     }
539 
540     function increaseAllowance(address spender, uint256 addedValue)
541         public
542         whenNotPaused
543         returns (bool success)
544     {
545         return super.increaseAllowance(spender, addedValue);
546     }
547 
548     function decreaseAllowance(address spender, uint256 subtractedValue)
549         public
550         whenNotPaused
551         returns (bool success)
552     {
553         return super.decreaseAllowance(spender, subtractedValue);
554     }
555 }
556 
557 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
558 
559 pragma solidity ^0.4.24;
560 
561 /**
562  * @title Burnable Token
563  * @dev Token that can be irreversibly burned (destroyed).
564  */
565 contract ERC20Burnable is ERC20 {
566     /**
567      * @dev Burns a specific amount of tokens.
568      * @param value The amount of token to be burned.
569      */
570     function burn(uint256 value) public {
571         _burn(msg.sender, value);
572     }
573 
574     /**
575      * @dev Burns a specific amount of tokens from the target address and decrements allowance
576      * @param from address The address which you want to send tokens from
577      * @param value uint256 The amount of token to be burned
578      */
579     function burnFrom(address from, uint256 value) public {
580         _burnFrom(from, value);
581     }
582 }
583 
584 // File: contracts/token/CandyToken.sol
585 
586 pragma solidity ^0.4.24;
587 
588 contract CandyToken is ERC20Detailed, ERC20Pausable, ERC20Burnable {
589     /**
590      * @dev constructor to mint initial tokens
591      * @param name string
592      * @param symbol string
593      * @param decimals uint8
594      * @param initialSupply uint256
595      */
596     constructor(
597         string name,
598         string symbol,
599         uint8 decimals,
600         uint256 initialSupply
601     ) public ERC20Detailed(name, symbol, decimals) {
602         // Mint the initial supply
603         require(initialSupply > 0, "initialSupply must be greater than zero.");
604         _mint(msg.sender, initialSupply * (10**uint256(decimals)));
605     }
606 }