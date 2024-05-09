1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-02
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-10-01
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-09-29
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2019-12-12
15 */
16 
17 pragma solidity ^0.5.0;
18 
19 /**
20  * @dev Wrappers over Solidity's arithmetic operations with added overflow
21  * checks.
22  *
23  * Arithmetic operations in Solidity wrap on overflow. This can easily result
24  * in bugs, because programmers usually assume that an overflow raises an
25  * error, which is the standard behavior in high level programming languages.
26  * `SafeMath` restores this intuition by reverting the transaction when an
27  * operation overflows.
28  *
29  * Using this library instead of the unchecked operations eliminates an entire
30  * class of bugs, so it's recommended to use it always.
31  */
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, reverting on
35      * overflow.
36      *
37      * Counterpart to Solidity's `+` operator.
38      *
39      * Requirements:
40      * - Addition cannot overflow.
41      */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      * - Multiplication cannot overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         return mod(a, b, "SafeMath: modulo by zero");
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts with custom message when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b != 0, errorMessage);
163         return a % b;
164     }
165 }
166 
167 library Roles {
168     struct Role {
169         mapping (address => bool) bearer;
170     }
171 
172     /**
173      * @dev give an account access to this role
174      */
175     function add(Role storage role, address account) internal {
176         require(account != address(0));
177         require(!has(role, account));
178 
179         role.bearer[account] = true;
180     }
181 
182     /**
183      * @dev remove an account's access to this role
184      */
185     function remove(Role storage role, address account) internal {
186         require(account != address(0));
187         require(has(role, account));
188 
189         role.bearer[account] = false;
190     }
191 
192     /**
193      * @dev check if an account has this role
194      * @return bool
195      */
196     function has(Role storage role, address account) internal view returns (bool) {
197         require(account != address(0));
198         return role.bearer[account];
199     }
200 }
201 
202 contract Ownable {
203     address public owner;
204     address public newOwner;
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208     constructor() public {
209         owner = msg.sender;
210         newOwner = address(0);
211     }
212 
213     modifier onlyOwner() {
214         require(msg.sender == owner);
215         _;
216     }
217     modifier onlyNewOwner() {
218         require(msg.sender != address(0));
219         require(msg.sender == newOwner);
220         _;
221     }
222 
223     function isOwner(address account) public view returns (bool) {
224         if( account == owner ){
225             return true;
226         }
227         else {
228             return false;
229         }
230     }
231 
232     function transferOwnership(address _newOwner) public onlyOwner {
233         require(_newOwner != address(0));
234         newOwner = _newOwner;
235     }
236 
237     function acceptOwnership() public onlyNewOwner returns(bool) {
238         emit OwnershipTransferred(owner, newOwner);
239         owner = newOwner;
240         newOwner = address(0);
241     }
242 }
243 
244 contract PauserRole is Ownable{
245     using Roles for Roles.Role;
246 
247     event PauserAdded(address indexed account);
248     event PauserRemoved(address indexed account);
249 
250     Roles.Role private _pausers;
251 
252     constructor () internal {
253         _addPauser(msg.sender);
254     }
255 
256     modifier onlyPauser() {
257         require(isPauser(msg.sender)|| isOwner(msg.sender));
258         _;
259     }
260 
261     function isPauser(address account) public view returns (bool) {
262         return _pausers.has(account);
263     }
264 
265     function addPauser(address account) public onlyPauser {
266         _addPauser(account);
267     }
268 
269     function removePauser(address account) public onlyOwner {
270         _removePauser(account);
271     }
272 
273     function renouncePauser() public {
274         _removePauser(msg.sender);
275     }
276 
277     function _addPauser(address account) internal {
278         _pausers.add(account);
279         emit PauserAdded(account);
280     }
281 
282     function _removePauser(address account) internal {
283         _pausers.remove(account);
284         emit PauserRemoved(account);
285     }
286 }
287 
288 contract Pausable is PauserRole {
289     event Paused(address account);
290     event Unpaused(address account);
291 
292     bool private _paused;
293 
294     constructor () internal {
295         _paused = false;
296     }
297 
298     /**
299      * @return true if the contract is paused, false otherwise.
300      */
301     function paused() public view returns (bool) {
302         return _paused;
303     }
304 
305     /**
306      * @dev Modifier to make a function callable only when the contract is not paused.
307      */
308     modifier whenNotPaused() {
309         require(!_paused);
310         _;
311     }
312 
313     /**
314      * @dev Modifier to make a function callable only when the contract is paused.
315      */
316     modifier whenPaused() {
317         require(_paused);
318         _;
319     }
320 
321     /**
322      * @dev called by the owner to pause, triggers stopped state
323      */
324     function pause() public onlyPauser whenNotPaused {
325         _paused = true;
326         emit Paused(msg.sender);
327     }
328 
329     /**
330      * @dev called by the owner to unpause, returns to normal state
331      */
332     function unpause() public onlyPauser whenPaused {
333         _paused = false;
334         emit Unpaused(msg.sender);
335     }
336 }
337 
338 interface IERC20 {
339     function transfer(address to, uint256 value) external returns (bool);
340 
341     function approve(address spender, uint256 value) external returns (bool);
342 
343     function transferFrom(address from, address to, uint256 value) external returns (bool);
344 
345     function totalSupply() external view returns (uint256);
346 
347     function balanceOf(address who) external view returns (uint256);
348 
349     function allowance(address owner, address spender) external view returns (uint256);
350 
351     event Transfer(address indexed from, address indexed to, uint256 value);
352 
353     event Approval(address indexed owner, address indexed spender, uint256 value);
354 }
355 
356 contract ERC20 is IERC20 {
357     using SafeMath for uint256;
358 
359     mapping (address => uint256) internal _balances;
360 
361     mapping (address => mapping (address => uint256)) internal _allowed;
362 
363     uint256 private _totalSupply;
364 
365     /**
366     * @dev Total number of tokens in existence
367     */
368     function totalSupply() public view returns (uint256) {
369         return _totalSupply;
370     }
371 
372     /**
373     * @dev Gets the balance of the specified address.
374     * @param owner The address to query the balance of.
375     * @return An uint256 representing the amount owned by the passed address.
376     */
377     function balanceOf(address owner) public view returns (uint256) {
378         return _balances[owner];
379     }
380 
381     /**
382      * @dev Function to check the amount of tokens that an owner allowed to a spender.
383      * @param owner address The address which owns the funds.
384      * @param spender address The address which will spend the funds.
385      * @return A uint256 specifying the amount of tokens still available for the spender.
386      */
387     function allowance(address owner, address spender) public view returns (uint256) {
388         return _allowed[owner][spender];
389     }
390 
391     /**
392      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
393      * Beware that changing an allowance with this method brings the risk that someone may use both the old
394      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
395      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
396      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
397      * @param spender The address which will spend the funds.
398      * @param value The amount of tokens to be spent.
399      */
400     function approve(address spender, uint256 value) public returns (bool) {
401         require(spender != address(0));
402 
403         _allowed[msg.sender][spender] = value;
404         emit Approval(msg.sender, spender, value);
405         return true;
406     }
407 
408     /**
409      * @dev Transfer tokens from one address to another.
410      * Note that while this function emits an Approval event, this is not required as per the specification,
411      * and other compliant implementations may not emit the event.
412      * @param from address The address which you want to send tokens from
413      * @param to address The address which you want to transfer to
414      * @param value uint256 the amount of tokens to be transferred
415      */
416     function transferFrom(address from, address to, uint256 value) public returns (bool) {
417         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
418         _transfer(from, to, value);
419         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
420         return true;
421     }
422 
423     /**
424      * @dev Increase the amount of tokens that an owner allowed to a spender.
425      * approve should be called when allowed_[_spender] == 0. To increment
426      * allowed value is better to use this function to avoid 2 calls (and wait until
427      * the first transaction is mined)
428      * From MonolithDAO Token.sol
429      * Emits an Approval event.
430      * @param spender The address which will spend the funds.
431      * @param addedValue The amount of tokens to increase the allowance by.
432      */
433     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
434         require(spender != address(0));
435 
436         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
437         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
438         return true;
439     }
440 
441     /**
442      * @dev Decrease the amount of tokens that an owner allowed to a spender.
443      * approve should be called when allowed_[_spender] == 0. To decrement
444      * allowed value is better to use this function to avoid 2 calls (and wait until
445      * the first transaction is mined)
446      * From MonolithDAO Token.sol
447      * Emits an Approval event.
448      * @param spender The address which will spend the funds.
449      * @param subtractedValue The amount of tokens to decrease the allowance by.
450      */
451     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
452         require(spender != address(0));
453 
454         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
455         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
456         return true;
457     }
458 
459 
460     /**
461     * @dev Transfer token for a specified address
462     * @param to The address to transfer to.
463     * @param value The amount to be transferred.
464     */
465     function transfer(address to, uint256 value) public returns (bool) {
466         _transfer(msg.sender, to, value);
467         return true;
468     }
469 
470     /**
471     * @dev Transfer token for a specified addresses
472     * @param from The address to transfer from.
473     * @param to The address to transfer to.
474     * @param value The amount to be transferred.
475     */
476     function _transfer(address from, address to, uint256 value) internal {
477         require(to != address(0));
478         require(from != address(0));
479 
480         _balances[from] = _balances[from].sub(value);
481         _balances[to] = _balances[to].add(value);
482         emit Transfer(from, to, value);
483     }
484 
485     /**
486      * @dev Destroys `amount` tokens from the caller.
487      *
488      * See {ERC20-_burn}.
489      */
490     function burn(uint256 value) public returns (bool) {
491         _burn(msg.sender, value);
492         return true;
493     }
494     
495     /**
496      * @dev Internal function that burns an amount of the token of a given
497      * account.
498      * @param account The account whose tokens will be burnt.
499      * @param value The amount that will be burnt.
500      */
501     function _burn(address account, uint256 value) internal {
502         require(account != address(0));
503 
504         _totalSupply = _totalSupply.sub(value);
505         _balances[account] = _balances[account].sub(value);
506         emit Transfer(account, address(0), value);
507     }
508 
509 
510     /**
511      * @dev Internal function that burns an amount of the token of a given
512      * account, deducting from the sender's allowance for said account. Uses the
513      * internal burn function.
514      * Emits an Approval event (reflecting the reduced allowance).
515      * @param account The account whose tokens will be burnt.
516      * @param value The amount that will be burnt.
517      */
518     function _burnFrom(address account, uint256 value) internal {
519         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
520         _burn(account, value);
521         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
522     }
523 
524     /**
525      * @dev Internal function that mints an amount of the token and assigns it to
526      * an account. This encapsulates the modification of balances such that the
527      * proper events are emitted.
528      * @param account The account that will receive the created tokens.
529      * @param value The amount that will be created.
530      */
531     function _mint(address account, uint256 value) internal {
532         require(account != address(0));
533 
534         _totalSupply = _totalSupply.add(value);
535         _balances[account] = _balances[account].add(value);
536         emit Transfer(address(0), account, value);
537     }
538 }
539 
540 contract ERC20Pausable is ERC20, Pausable {
541     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
542         return super.transfer(to, value);
543     }
544 
545     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
546         return super.transferFrom(from, to, value);
547     }
548 }
549 
550 contract ERC20Detailed is IERC20 {
551     string private _name;
552     string private _symbol;
553     uint8 private _decimals;
554 
555     constructor (string memory name, string memory symbol, uint8 decimals) public {
556         _name = name;
557         _symbol = symbol;
558         _decimals = decimals;
559     }
560 
561     /**
562      * @return the name of the token.
563      */
564     function name() public view returns (string memory) {
565         return _name;
566     }
567 
568     /**
569      * @return the symbol of the token.
570      */
571     function symbol() public view returns (string memory) {
572         return _symbol;
573     }
574 
575     /**
576      * @return the number of decimals of the token.
577      */
578     function decimals() public view returns (uint8) {
579         return _decimals;
580     }
581 }
582 
583 contract ERC20Custom is ERC20Detailed, ERC20Pausable {
584 
585 
586 
587     constructor(
588         uint256 initialSupply,
589         uint8 decimals,
590         string memory tokenName,
591         string memory tokenSymbol
592     ) ERC20Detailed(tokenName, tokenSymbol, decimals) public  {
593         _mint(msg.sender, initialSupply * (10 ** uint256(decimals)));
594     }
595 
596 
597 
598    function balanceOf(address owner) public view returns (uint256) {
599         return _balances[owner];
600     }
601 
602 
603     function transfer(address to, uint256 value) public  returns (bool) {
604  
605         return super.transfer(to, value);
606     }
607 
608     function transferFrom(address from, address to, uint256 value) public  returns (bool) {
609  
610         return super.transferFrom(from, to, value);
611     }
612 
613     
614 
615 }