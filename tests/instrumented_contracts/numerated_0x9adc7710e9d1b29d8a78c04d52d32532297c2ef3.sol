1 pragma solidity ^0.5.2;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // flattened :  Friday, 01-Mar-19 15:50:13 UTC
6 interface IERC20 {
7     function transfer(address to, uint256 value) external returns (bool);
8 
9     function approve(address spender, uint256 value) external returns (bool);
10 
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library Roles {
25     struct Role {
26         mapping (address => bool) bearer;
27     }
28 
29     /**
30      * @dev give an account access to this role
31      */
32     function add(Role storage role, address account) internal {
33         require(account != address(0));
34         require(!has(role, account));
35 
36         role.bearer[account] = true;
37     }
38 
39     /**
40      * @dev remove an account's access to this role
41      */
42     function remove(Role storage role, address account) internal {
43         require(account != address(0));
44         require(has(role, account));
45 
46         role.bearer[account] = false;
47     }
48 
49     /**
50      * @dev check if an account has this role
51      * @return bool
52      */
53     function has(Role storage role, address account) internal view returns (bool) {
54         require(account != address(0));
55         return role.bearer[account];
56     }
57 }
58 
59 library SafeMath {
60     /**
61      * @dev Multiplies two unsigned integers, reverts on overflow.
62      */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b);
73 
74         return c;
75     }
76 
77     /**
78      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
79      */
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Solidity only automatically asserts when dividing by 0
82         require(b > 0);
83         uint256 c = a / b;
84         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85 
86         return c;
87     }
88 
89     /**
90      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
91      */
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         require(b <= a);
94         uint256 c = a - b;
95 
96         return c;
97     }
98 
99     /**
100      * @dev Adds two unsigned integers, reverts on overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a);
105 
106         return c;
107     }
108 
109     /**
110      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
111      * reverts when dividing by zero.
112      */
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         require(b != 0);
115         return a % b;
116     }
117 }
118 
119 contract PauserRole {
120     using Roles for Roles.Role;
121 
122     event PauserAdded(address indexed account);
123     event PauserRemoved(address indexed account);
124 
125     Roles.Role private _pausers;
126 
127     constructor () internal {
128         _addPauser(msg.sender);
129     }
130 
131     modifier onlyPauser() {
132         require(isPauser(msg.sender));
133         _;
134     }
135 
136     function isPauser(address account) public view returns (bool) {
137         return _pausers.has(account);
138     }
139 
140     function addPauser(address account) public onlyPauser {
141         _addPauser(account);
142     }
143 
144     function renouncePauser() public {
145         _removePauser(msg.sender);
146     }
147 
148     function _addPauser(address account) internal {
149         _pausers.add(account);
150         emit PauserAdded(account);
151     }
152 
153     function _removePauser(address account) internal {
154         _pausers.remove(account);
155         emit PauserRemoved(account);
156     }
157 }
158 
159 contract MinterRole {
160     using Roles for Roles.Role;
161 
162     event MinterAdded(address indexed account);
163     event MinterRemoved(address indexed account);
164 
165     Roles.Role private _minters;
166 
167     constructor () internal {
168         _addMinter(msg.sender);
169     }
170 
171     modifier onlyMinter() {
172         require(isMinter(msg.sender));
173         _;
174     }
175 
176     function isMinter(address account) public view returns (bool) {
177         return _minters.has(account);
178     }
179 
180     function addMinter(address account) public onlyMinter {
181         _addMinter(account);
182     }
183 
184     function renounceMinter() public {
185         _removeMinter(msg.sender);
186     }
187 
188     function _addMinter(address account) internal {
189         _minters.add(account);
190         emit MinterAdded(account);
191     }
192 
193     function _removeMinter(address account) internal {
194         _minters.remove(account);
195         emit MinterRemoved(account);
196     }
197 }
198 
199 library SafeERC20 {
200     using SafeMath for uint256;
201 
202     function safeTransfer(IERC20 token, address to, uint256 value) internal {
203         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
204     }
205 
206     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
207         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
208     }
209 
210     function safeApprove(IERC20 token, address spender, uint256 value) internal {
211         // safeApprove should only be called when setting an initial allowance,
212         // or when resetting it to zero. To increase and decrease it, use
213         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
214         require((value == 0) || (token.allowance(address(this), spender) == 0));
215         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
216     }
217 
218     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
219         uint256 newAllowance = token.allowance(address(this), spender).add(value);
220         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
221     }
222 
223     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
224         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
225         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
226     }
227 
228     /**
229      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
230      * on the return value: the return value is optional (but if data is returned, it must equal true).
231      * @param token The token targeted by the call.
232      * @param data The call data (encoded using abi.encode or one of its variants).
233      */
234     function callOptionalReturn(IERC20 token, bytes memory data) private {
235         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
236         // we're implementing it ourselves.
237 
238         // solhint-disable-next-line avoid-low-level-calls
239         (bool success, bytes memory returndata) = address(token).call(data);
240         require(success);
241 
242         if (returndata.length > 0) {
243             require(abi.decode(returndata, (bool)));
244         }
245     }
246 }
247 
248 contract ERC20Detailed is IERC20 {
249     string private _name;
250     string private _symbol;
251     uint8 private _decimals;
252 
253     constructor (string memory name, string memory symbol, uint8 decimals) public {
254         _name = name;
255         _symbol = symbol;
256         _decimals = decimals;
257     }
258 
259     /**
260      * @return the name of the token.
261      */
262     function name() public view returns (string memory) {
263         return _name;
264     }
265 
266     /**
267      * @return the symbol of the token.
268      */
269     function symbol() public view returns (string memory) {
270         return _symbol;
271     }
272 
273     /**
274      * @return the number of decimals of the token.
275      */
276     function decimals() public view returns (uint8) {
277         return _decimals;
278     }
279 }
280 
281 contract Pausable is PauserRole {
282     event Paused(address account);
283     event Unpaused(address account);
284 
285     bool private _paused;
286 
287     constructor () internal {
288         _paused = false;
289     }
290 
291     /**
292      * @return true if the contract is paused, false otherwise.
293      */
294     function paused() public view returns (bool) {
295         return _paused;
296     }
297 
298     /**
299      * @dev Modifier to make a function callable only when the contract is not paused.
300      */
301     modifier whenNotPaused() {
302         require(!_paused);
303         _;
304     }
305 
306     /**
307      * @dev Modifier to make a function callable only when the contract is paused.
308      */
309     modifier whenPaused() {
310         require(_paused);
311         _;
312     }
313 
314     /**
315      * @dev called by the owner to pause, triggers stopped state
316      */
317     function pause() public onlyPauser whenNotPaused {
318         _paused = true;
319         emit Paused(msg.sender);
320     }
321 
322     /**
323      * @dev called by the owner to unpause, returns to normal state
324      */
325     function unpause() public onlyPauser whenPaused {
326         _paused = false;
327         emit Unpaused(msg.sender);
328     }
329 }
330 
331 contract ERC20 is IERC20 {
332     using SafeMath for uint256;
333 
334     mapping (address => uint256) private _balances;
335 
336     mapping (address => mapping (address => uint256)) private _allowed;
337 
338     uint256 private _totalSupply;
339 
340     /**
341      * @dev Total number of tokens in existence
342      */
343     function totalSupply() public view returns (uint256) {
344         return _totalSupply;
345     }
346 
347     /**
348      * @dev Gets the balance of the specified address.
349      * @param owner The address to query the balance of.
350      * @return A uint256 representing the amount owned by the passed address.
351      */
352     function balanceOf(address owner) public view returns (uint256) {
353         return _balances[owner];
354     }
355 
356     /**
357      * @dev Function to check the amount of tokens that an owner allowed to a spender.
358      * @param owner address The address which owns the funds.
359      * @param spender address The address which will spend the funds.
360      * @return A uint256 specifying the amount of tokens still available for the spender.
361      */
362     function allowance(address owner, address spender) public view returns (uint256) {
363         return _allowed[owner][spender];
364     }
365 
366     /**
367      * @dev Transfer token to a specified address
368      * @param to The address to transfer to.
369      * @param value The amount to be transferred.
370      */
371     function transfer(address to, uint256 value) public returns (bool) {
372         _transfer(msg.sender, to, value);
373         return true;
374     }
375 
376     /**
377      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
378      * Beware that changing an allowance with this method brings the risk that someone may use both the old
379      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
380      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
381      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
382      * @param spender The address which will spend the funds.
383      * @param value The amount of tokens to be spent.
384      */
385     function approve(address spender, uint256 value) public returns (bool) {
386         _approve(msg.sender, spender, value);
387         return true;
388     }
389 
390     /**
391      * @dev Transfer tokens from one address to another.
392      * Note that while this function emits an Approval event, this is not required as per the specification,
393      * and other compliant implementations may not emit the event.
394      * @param from address The address which you want to send tokens from
395      * @param to address The address which you want to transfer to
396      * @param value uint256 the amount of tokens to be transferred
397      */
398     function transferFrom(address from, address to, uint256 value) public returns (bool) {
399         _transfer(from, to, value);
400         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
401         return true;
402     }
403 
404     /**
405      * @dev Increase the amount of tokens that an owner allowed to a spender.
406      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
407      * allowed value is better to use this function to avoid 2 calls (and wait until
408      * the first transaction is mined)
409      * From MonolithDAO Token.sol
410      * Emits an Approval event.
411      * @param spender The address which will spend the funds.
412      * @param addedValue The amount of tokens to increase the allowance by.
413      */
414     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
415         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
416         return true;
417     }
418 
419     /**
420      * @dev Decrease the amount of tokens that an owner allowed to a spender.
421      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
422      * allowed value is better to use this function to avoid 2 calls (and wait until
423      * the first transaction is mined)
424      * From MonolithDAO Token.sol
425      * Emits an Approval event.
426      * @param spender The address which will spend the funds.
427      * @param subtractedValue The amount of tokens to decrease the allowance by.
428      */
429     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
430         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
431         return true;
432     }
433 
434     /**
435      * @dev Transfer token for a specified addresses
436      * @param from The address to transfer from.
437      * @param to The address to transfer to.
438      * @param value The amount to be transferred.
439      */
440     function _transfer(address from, address to, uint256 value) internal {
441         require(to != address(0));
442 
443         _balances[from] = _balances[from].sub(value);
444         _balances[to] = _balances[to].add(value);
445         emit Transfer(from, to, value);
446     }
447 
448     /**
449      * @dev Internal function that mints an amount of the token and assigns it to
450      * an account. This encapsulates the modification of balances such that the
451      * proper events are emitted.
452      * @param account The account that will receive the created tokens.
453      * @param value The amount that will be created.
454      */
455     function _mint(address account, uint256 value) internal {
456         require(account != address(0));
457 
458         _totalSupply = _totalSupply.add(value);
459         _balances[account] = _balances[account].add(value);
460         emit Transfer(address(0), account, value);
461     }
462 
463     /**
464      * @dev Internal function that burns an amount of the token of a given
465      * account.
466      * @param account The account whose tokens will be burnt.
467      * @param value The amount that will be burnt.
468      */
469     function _burn(address account, uint256 value) internal {
470         require(account != address(0));
471 
472         _totalSupply = _totalSupply.sub(value);
473         _balances[account] = _balances[account].sub(value);
474         emit Transfer(account, address(0), value);
475     }
476 
477     /**
478      * @dev Approve an address to spend another addresses' tokens.
479      * @param owner The address that owns the tokens.
480      * @param spender The address that will spend the tokens.
481      * @param value The number of tokens that can be spent.
482      */
483     function _approve(address owner, address spender, uint256 value) internal {
484         require(spender != address(0));
485         require(owner != address(0));
486 
487         _allowed[owner][spender] = value;
488         emit Approval(owner, spender, value);
489     }
490 
491     /**
492      * @dev Internal function that burns an amount of the token of a given
493      * account, deducting from the sender's allowance for said account. Uses the
494      * internal burn function.
495      * Emits an Approval event (reflecting the reduced allowance).
496      * @param account The account whose tokens will be burnt.
497      * @param value The amount that will be burnt.
498      */
499     function _burnFrom(address account, uint256 value) internal {
500         _burn(account, value);
501         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
502     }
503 }
504 
505 contract ERC20Pausable is ERC20, Pausable {
506     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
507         return super.transfer(to, value);
508     }
509 
510     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
511         return super.transferFrom(from, to, value);
512     }
513 
514     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
515         return super.approve(spender, value);
516     }
517 
518     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
519         return super.increaseAllowance(spender, addedValue);
520     }
521 
522     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
523         return super.decreaseAllowance(spender, subtractedValue);
524     }
525 }
526 
527 contract ERC20Mintable is ERC20, MinterRole {
528     /**
529      * @dev Function to mint tokens
530      * @param to The address that will receive the minted tokens.
531      * @param value The amount of tokens to mint.
532      * @return A boolean that indicates if the operation was successful.
533      */
534     function mint(address to, uint256 value) public onlyMinter returns (bool) {
535         _mint(to, value);
536         return true;
537     }
538 }
539 
540 contract ERC20Capped is ERC20Mintable {
541     uint256 private _cap;
542 
543     constructor (uint256 cap) public {
544         require(cap > 0);
545         _cap = cap;
546     }
547 
548     /**
549      * @return the cap for the token minting.
550      */
551     function cap() public view returns (uint256) {
552         return _cap;
553     }
554 
555     function _mint(address account, uint256 value) internal {
556         require(totalSupply().add(value) <= _cap);
557         super._mint(account, value);
558     }
559 }
560 
561 contract QuadransToken is ERC20, ERC20Detailed, ERC20Pausable, ERC20Capped {
562     
563     using SafeERC20 for ERC20;
564     
565     uint8 public constant DECIMALS = 18;
566     uint256 public constant INITIAL_SUPPLY = 600000000 * (10 ** uint256(DECIMALS));
567 
568     /**
569      * @dev Constructor that gives msg.sender all of existing tokens.
570      */
571     constructor () public ERC20Capped(INITIAL_SUPPLY) ERC20Detailed("QuadransToken", "QDT", DECIMALS) {
572         _mint(msg.sender, INITIAL_SUPPLY);
573     }
574 }