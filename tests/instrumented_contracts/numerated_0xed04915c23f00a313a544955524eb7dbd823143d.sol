1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4 
5     function transfer(address to, uint256 value) external returns (bool);
6 
7     function approve(address spender, uint256 value) external returns (bool);
8 
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 library SafeMath {
24 
25     /**
26      * @dev Multiplies two unsigned integers, reverts on overflow.
27      */
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
30         // benefit is lost if 'b' is also tested.
31         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32         if (a == 0) {
33             return 0;
34         }
35 
36         uint256 c = a * b;
37         require(c / a == b);
38 
39         return c;
40     }
41 
42     /**
43      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
44      */
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0);
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50         return c;
51     }
52 
53     /**
54      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
55      */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b <= a);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     /**
64      * @dev Adds two unsigned integers, reverts on overflow.
65      */
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a);
69 
70         return c;
71     }
72 
73     /**
74      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
75      * reverts when dividing by zero.
76      */
77     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
78         require(b != 0);
79         return a % b;
80     }
81 }
82 
83 library Roles {
84     struct Role {
85         mapping (address => bool) bearer;
86     }
87 
88     /**
89      * @dev give an account access to this role
90      */
91     function add(Role storage role, address account) internal {
92         require(account != address(0));
93         require(!has(role, account));
94 
95         role.bearer[account] = true;
96     }
97 
98     /**
99      * @dev remove an account's access to this role
100      */
101     function remove(Role storage role, address account) internal {
102         require(account != address(0));
103         require(has(role, account));
104 
105         role.bearer[account] = false;
106     }
107 
108     /**
109      * @dev check if an account has this role
110      * @return bool
111      */
112     function has(Role storage role, address account) internal view returns (bool) {
113         require(account != address(0));
114         return role.bearer[account];
115     }
116 }
117 
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
128      * @dev Total number of tokens in existence
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
154      * @dev Transfer token to a specified address
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
222      * @dev Transfer token for a specified addresses
223      * @param from The address to transfer from.
224      * @param to The address to transfer to.
225      * @param value The amount to be transferred.
226      */
227     function _transfer(address from, address to, uint256 value) internal {
228         require(to != address(0));
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
243         require(account != address(0));
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
257         require(account != address(0));
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
271         require(spender != address(0));
272         require(owner != address(0));
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
292 
293 contract ERC20Detailed is IERC20 {
294     string private _name;
295     string private _symbol;
296     uint8 private _decimals;
297 
298     constructor (string memory name, string memory symbol, uint8 decimals) public {
299         _name = name;
300         _symbol = symbol;
301         _decimals = decimals;
302     }
303 
304     /**
305      * @return the name of the token.
306      */
307     function name() public view returns (string memory) {
308         return _name;
309     }
310 
311     /**
312      * @return the symbol of the token.
313      */
314     function symbol() public view returns (string memory) {
315         return _symbol;
316     }
317 
318     /**
319      * @return the number of decimals of the token.
320      */
321     function decimals() public view returns (uint8) {
322         return _decimals;
323     }
324 }
325 library Address {
326     /**
327      * Returns whether the target address is a contract
328      * @dev This function will return false if invoked during the constructor of a contract,
329      * as the code is not actually created until after the constructor finishes.
330      * @param account address of the account to check
331      * @return whether the target address is a contract
332      */
333     function isContract(address account) internal view returns (bool) {
334         uint256 size;
335         // XXX Currently there is no better way to check if there is a contract in an address
336         // than to check the size of the code at that address.
337         // See https://ethereum.stackexchange.com/a/14016/36603
338         // for more details about how this works.
339         // TODO Check this again before the Serenity release, because all addresses will be
340         // contracts then.
341         // solhint-disable-next-line no-inline-assembly
342         assembly { size := extcodesize(account) }
343         return size > 0;
344     }
345 }
346 
347 
348 library SafeERC20 {
349     using SafeMath for uint256;
350     using Address for address;
351 
352     function safeTransfer(IERC20 token, address to, uint256 value) internal {
353         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
354     }
355 
356     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
357         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
358     }
359 
360     function safeApprove(IERC20 token, address spender, uint256 value) internal {
361         // safeApprove should only be called when setting an initial allowance,
362         // or when resetting it to zero. To increase and decrease it, use
363         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
364         require((value == 0) || (token.allowance(address(this), spender) == 0));
365         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
366     }
367 
368     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
369         uint256 newAllowance = token.allowance(address(this), spender).add(value);
370         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
371     }
372 
373     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
374         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
375         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
376     }
377 
378     /**
379      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
380      * on the return value: the return value is optional (but if data is returned, it must not be false).
381      * @param token The token targeted by the call.
382      * @param data The call data (encoded using abi.encode or one of its variants).
383      */
384     function callOptionalReturn(IERC20 token, bytes memory data) private {
385         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
386         // we're implementing it ourselves.
387 
388         // A Solidity high level call has three parts:
389         //  1. The target address is checked to verify it contains contract code
390         //  2. The call itself is made, and success asserted
391         //  3. The return value is decoded, which in turn checks the size of the returned data.
392 
393         require(address(token).isContract());
394 
395         // solhint-disable-next-line avoid-low-level-calls
396         (bool success, bytes memory returndata) = address(token).call(data);
397         require(success);
398 
399         if (returndata.length > 0) { // Return data is optional
400             require(abi.decode(returndata, (bool)));
401         }
402     }
403 }
404 contract TokenTimelock {
405     using SafeERC20 for IERC20;
406 
407     // ERC20 basic token contract being held
408     IERC20 private _token;
409 
410     // beneficiary of tokens after they are released
411     address private _beneficiary;
412 
413     // timestamp when token release is enabled
414     uint256 private _releaseTime;
415 
416     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
417         // solhint-disable-next-line not-rely-on-time
418         require(releaseTime > block.timestamp);
419         _token = token;
420         _beneficiary = beneficiary;
421         _releaseTime = releaseTime;
422     }
423 
424     /**
425      * @return the token being held.
426      */
427     function token() public view returns (IERC20) {
428         return _token;
429     }
430 
431     /**
432      * @return the beneficiary of the tokens.
433      */
434     function beneficiary() public view returns (address) {
435         return _beneficiary;
436     }
437 
438     /**
439      * @return the time when the tokens are released.
440      */
441     function releaseTime() public view returns (uint256) {
442         return _releaseTime;
443     }
444 
445     /**
446      * @notice Transfers tokens held by timelock to beneficiary.
447      */
448     function release() public {
449         // solhint-disable-next-line not-rely-on-time
450         require(block.timestamp >= _releaseTime);
451 
452         uint256 amount = _token.balanceOf(address(this));
453         require(amount > 0);
454 
455         _token.safeTransfer(_beneficiary, amount);
456     }
457 }
458 contract MinterRole {
459     using Roles for Roles.Role;
460 
461     event MinterAdded(address indexed account);
462     event MinterRemoved(address indexed account);
463 
464     Roles.Role private _minters;
465 
466     constructor () internal {
467         _addMinter(msg.sender);
468     }
469 
470     modifier onlyMinter() {
471         require(isMinter(msg.sender));
472         _;
473     }
474 
475     function isMinter(address account) public view returns (bool) {
476         return _minters.has(account);
477     }
478 
479     function addMinter(address account) public onlyMinter {
480         _addMinter(account);
481     }
482 
483     function renounceMinter() public {
484         _removeMinter(msg.sender);
485     }
486 
487     function _addMinter(address account) internal {
488         _minters.add(account);
489         emit MinterAdded(account);
490     }
491 
492     function _removeMinter(address account) internal {
493         _minters.remove(account);
494         emit MinterRemoved(account);
495     }
496 }
497 
498 contract ERC20Mintable is ERC20, MinterRole {
499     /**
500      * @dev Function to mint tokens
501      * @param to The address that will receive the minted tokens.
502      * @param value The amount of tokens to mint.
503      * @return A boolean that indicates if the operation was successful.
504      */
505     function mint(address to, uint256 value) public onlyMinter returns (bool) {
506         _mint(to, value);
507         return true;
508     }
509 }
510 
511 contract ERC20Burnable is ERC20 {
512     /**
513      * @dev Burns a specific amount of tokens.
514      * @param value The amount of token to be burned.
515      */
516     function burn(uint256 value) public {
517         _burn(msg.sender, value);
518     }
519 
520     /**
521      * @dev Burns a specific amount of tokens from the target address and decrements allowance
522      * @param from address The account whose tokens will be burned.
523      * @param value uint256 The amount of token to be burned.
524      */
525     function burnFrom(address from, uint256 value) public {
526         _burnFrom(from, value);
527     }
528 }
529 
530 contract PauserRole {
531     using Roles for Roles.Role;
532 
533     event PauserAdded(address indexed account);
534     event PauserRemoved(address indexed account);
535 
536     Roles.Role private _pausers;
537 
538     constructor () internal {
539         _addPauser(msg.sender);
540     }
541 
542     modifier onlyPauser() {
543         require(isPauser(msg.sender));
544         _;
545     }
546 
547     function isPauser(address account) public view returns (bool) {
548         return _pausers.has(account);
549     }
550 
551     function addPauser(address account) public onlyPauser {
552         _addPauser(account);
553     }
554 
555     function renouncePauser() public {
556         _removePauser(msg.sender);
557     }
558 
559     function _addPauser(address account) internal {
560         _pausers.add(account);
561         emit PauserAdded(account);
562     }
563 
564     function _removePauser(address account) internal {
565         _pausers.remove(account);
566         emit PauserRemoved(account);
567     }
568 }
569 
570 
571 contract Pausable is PauserRole {
572     event Paused(address account);
573     event Unpaused(address account);
574 
575     bool private _paused;
576 
577     constructor () internal {
578         _paused = false;
579     }
580 
581     /**
582      * @return true if the contract is paused, false otherwise.
583      */
584     function paused() public view returns (bool) {
585         return _paused;
586     }
587 
588     /**
589      * @dev Modifier to make a function callable only when the contract is not paused.
590      */
591     modifier whenNotPaused() {
592         require(!_paused);
593         _;
594     }
595 
596     /**
597      * @dev Modifier to make a function callable only when the contract is paused.
598      */
599     modifier whenPaused() {
600         require(_paused);
601         _;
602     }
603 
604     /**
605      * @dev called by the owner to pause, triggers stopped state
606      */
607     function pause() public onlyPauser whenNotPaused {
608         _paused = true;
609         emit Paused(msg.sender);
610     }
611 
612     /**
613      * @dev called by the owner to unpause, returns to normal state
614      */
615     function unpause() public onlyPauser whenPaused {
616         _paused = false;
617         emit Unpaused(msg.sender);
618     }
619 }
620 
621 
622 contract ERC20Pausable is ERC20, Pausable {
623     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
624         return super.transfer(to, value);
625     }
626 
627     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
628         return super.transferFrom(from, to, value);
629     }
630 
631     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
632         return super.approve(spender, value);
633     }
634 
635     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
636         return super.increaseAllowance(spender, addedValue);
637     }
638 
639     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
640         return super.decreaseAllowance(spender, subtractedValue);
641     }
642 }
643 
644 contract ACH is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable,ERC20Pausable {
645    uint private INITIAL_SUPPLY = 100e16;
646 
647     constructor () public ERC20Detailed("Alchemy", "ACH", 8) {
648         _mint(msg.sender, INITIAL_SUPPLY);
649         
650     }
651     
652 }