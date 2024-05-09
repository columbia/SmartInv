1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
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
25 
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32     * @dev Multiplies two unsigned integers, reverts on overflow.
33     */
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
61     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Adds two unsigned integers, reverts on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82     * reverts when dividing by zero.
83     */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
95  * Originally based on code by FirstBlood:
96  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  *
98  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
99  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
100  * compliant implementations may not do it.
101  */
102 contract ERC20 is IERC20 {
103     using SafeMath for uint256;
104 
105     mapping (address => uint256) private _balances;
106 
107     mapping (address => mapping (address => uint256)) private _allowed;
108 
109     uint256 private _totalSupply;
110 
111     /**
112     * @dev Total number of tokens in existence
113     */
114     function totalSupply() public view returns (uint256) {
115         return _totalSupply;
116     }
117 
118     /**
119     * @dev Gets the balance of the specified address.
120     * @param owner The address to query the balance of.
121     * @return An uint256 representing the amount owned by the passed address.
122     */
123     function balanceOf(address owner) public view returns (uint256) {
124         return _balances[owner];
125     }
126 
127     /**
128      * @dev Function to check the amount of tokens that an owner allowed to a spender.
129      * @param owner address The address which owns the funds.
130      * @param spender address The address which will spend the funds.
131      * @return A uint256 specifying the amount of tokens still available for the spender.
132      */
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowed[owner][spender];
135     }
136 
137     /**
138     * @dev Transfer token for a specified address
139     * @param to The address to transfer to.
140     * @param value The amount to be transferred.
141     */
142     function transfer(address to, uint256 value) public returns (bool) {
143         _transfer(msg.sender, to, value);
144         return true;
145     }
146 
147     /**
148      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param spender The address which will spend the funds.
154      * @param value The amount of tokens to be spent.
155      */
156     function approve(address spender, uint256 value) public returns (bool) {
157         require(spender != address(0));
158 
159         _allowed[msg.sender][spender] = value;
160         emit Approval(msg.sender, spender, value);
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
173         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
174         _transfer(from, to, value);
175         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
176         return true;
177     }
178 
179     /**
180      * @dev Increase the amount of tokens that an owner allowed to a spender.
181      * approve should be called when allowed_[_spender] == 0. To increment
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * Emits an Approval event.
186      * @param spender The address which will spend the funds.
187      * @param addedValue The amount of tokens to increase the allowance by.
188      */
189     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
190         require(spender != address(0));
191 
192         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
193         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed_[_spender] == 0. To decrement
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * Emits an Approval event.
204      * @param spender The address which will spend the funds.
205      * @param subtractedValue The amount of tokens to decrease the allowance by.
206      */
207     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
208         require(spender != address(0));
209 
210         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
211         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
212         return true;
213     }
214 
215     /**
216     * @dev Transfer token for a specified addresses
217     * @param from The address to transfer from.
218     * @param to The address to transfer to.
219     * @param value The amount to be transferred.
220     */
221     function _transfer(address from, address to, uint256 value) internal {
222         require(to != address(0));
223 
224         _balances[from] = _balances[from].sub(value);
225         _balances[to] = _balances[to].add(value);
226         emit Transfer(from, to, value);
227     }
228 
229     /**
230      * @dev Internal function that mints an amount of the token and assigns it to
231      * an account. This encapsulates the modification of balances such that the
232      * proper events are emitted.
233      * @param account The account that will receive the created tokens.
234      * @param value The amount that will be created.
235      */
236     function _mint(address account, uint256 value) internal {
237         require(account != address(0));
238 
239         _totalSupply = _totalSupply.add(value);
240         _balances[account] = _balances[account].add(value);
241         emit Transfer(address(0), account, value);
242     }
243 
244     /**
245      * @dev Internal function that burns an amount of the token of a given
246      * account.
247      * @param account The account whose tokens will be burnt.
248      * @param value The amount that will be burnt.
249      */
250     function _burn(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.sub(value);
254         _balances[account] = _balances[account].sub(value);
255         emit Transfer(account, address(0), value);
256     }
257 
258     /**
259      * @dev Internal function that burns an amount of the token of a given
260      * account, deducting from the sender's allowance for said account. Uses the
261      * internal burn function.
262      * Emits an Approval event (reflecting the reduced allowance).
263      * @param account The account whose tokens will be burnt.
264      * @param value The amount that will be burnt.
265      */
266     function _burnFrom(address account, uint256 value) internal {
267         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
268         _burn(account, value);
269         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
270     }
271 }
272 
273 
274 /**
275  * @title Ownable
276  * @dev The Ownable contract has an owner address, and provides basic authorization control
277  * functions, this simplifies the implementation of "user permissions".
278  */
279 contract Ownable {
280     address private _owner;
281 
282     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
283 
284     /**
285      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
286      * account.
287      */
288     constructor () internal {
289         _owner = msg.sender;
290         emit OwnershipTransferred(address(0), _owner);
291     }
292 
293     /**
294      * @return the address of the owner.
295      */
296     function owner() public view returns (address) {
297         return _owner;
298     }
299 
300     /**
301      * @dev Throws if called by any account other than the owner.
302      */
303     modifier onlyOwner() {
304         require(isOwner());
305         _;
306     }
307 
308     /**
309      * @return true if `msg.sender` is the owner of the contract.
310      */
311     function isOwner() public view returns (bool) {
312         return msg.sender == _owner;
313     }
314 
315     /**
316      * @dev Allows the current owner to relinquish control of the contract.
317      * @notice Renouncing to ownership will leave the contract without an owner.
318      * It will not be possible to call the functions with the `onlyOwner`
319      * modifier anymore.
320      */
321     function renounceOwnership() public onlyOwner {
322         emit OwnershipTransferred(_owner, address(0));
323         _owner = address(0);
324     }
325 
326     /**
327      * @dev Allows the current owner to transfer control of the contract to a newOwner.
328      * @param newOwner The address to transfer ownership to.
329      */
330     function transferOwnership(address newOwner) public onlyOwner {
331         _transferOwnership(newOwner);
332     }
333 
334     /**
335      * @dev Transfers control of the contract to a newOwner.
336      * @param newOwner The address to transfer ownership to.
337      */
338     function _transferOwnership(address newOwner) internal {
339         require(newOwner != address(0));
340         emit OwnershipTransferred(_owner, newOwner);
341         _owner = newOwner;
342     }
343 }
344 
345 /**
346  * @title Burnable Token
347  * @dev Token that can be irreversibly burned (destroyed).
348  */
349 contract ERC20Burnable is ERC20 {
350     /**
351      * @dev Burns a specific amount of tokens.
352      * @param value The amount of token to be burned.
353      */
354     function burn(uint256 value) public {
355         _burn(msg.sender, value);
356     }
357 
358     /**
359      * @dev Burns a specific amount of tokens from the target address and decrements allowance
360      * @param from address The address which you want to send tokens from
361      * @param value uint256 The amount of token to be burned
362      */
363     function burnFrom(address from, uint256 value) public {
364         _burnFrom(from, value);
365     }
366 }
367 
368 /**
369  * @title Roles
370  * @dev Library for managing addresses assigned to a Role.
371  */
372 library Roles {
373     struct Role {
374         mapping (address => bool) bearer;
375     }
376 
377     /**
378      * @dev give an account access to this role
379      */
380     function add(Role storage role, address account) internal {
381         require(account != address(0));
382         require(!has(role, account));
383 
384         role.bearer[account] = true;
385     }
386 
387     /**
388      * @dev remove an account's access to this role
389      */
390     function remove(Role storage role, address account) internal {
391         require(account != address(0));
392         require(has(role, account));
393 
394         role.bearer[account] = false;
395     }
396 
397     /**
398      * @dev check if an account has this role
399      * @return bool
400      */
401     function has(Role storage role, address account) internal view returns (bool) {
402         require(account != address(0));
403         return role.bearer[account];
404     }
405 }
406 
407 
408 contract PauserRole {
409     using Roles for Roles.Role;
410 
411     event PauserAdded(address indexed account);
412     event PauserRemoved(address indexed account);
413 
414     Roles.Role private _pausers;
415 
416     constructor () internal {
417         _addPauser(msg.sender);
418     }
419 
420     modifier onlyPauser() {
421         require(isPauser(msg.sender));
422         _;
423     }
424 
425     function isPauser(address account) public view returns (bool) {
426         return _pausers.has(account);
427     }
428 
429     function addPauser(address account) public onlyPauser {
430         _addPauser(account);
431     }
432 
433     function renouncePauser() public {
434         _removePauser(msg.sender);
435     }
436 
437     function _addPauser(address account) internal {
438         _pausers.add(account);
439         emit PauserAdded(account);
440     }
441 
442     function _removePauser(address account) internal {
443         _pausers.remove(account);
444         emit PauserRemoved(account);
445     }
446 }
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
463      * @return true if the contract is paused, false otherwise.
464      */
465     function paused() public view returns (bool) {
466         return _paused;
467     }
468 
469     /**
470      * @dev Modifier to make a function callable only when the contract is not paused.
471      */
472     modifier whenNotPaused() {
473         require(!_paused);
474         _;
475     }
476 
477     /**
478      * @dev Modifier to make a function callable only when the contract is paused.
479      */
480     modifier whenPaused() {
481         require(_paused);
482         _;
483     }
484 
485     /**
486      * @dev called by the owner to pause, triggers stopped state
487      */
488     function pause() public onlyPauser whenNotPaused {
489         _paused = true;
490         emit Paused(msg.sender);
491     }
492 
493     /**
494      * @dev called by the owner to unpause, returns to normal state
495      */
496     function unpause() public onlyPauser whenPaused {
497         _paused = false;
498         emit Unpaused(msg.sender);
499     }
500 }
501 
502 
503 /**
504  * @title Pausable token
505  * @dev ERC20 modified with pausable transfers.
506  **/
507 contract ERC20Pausable is ERC20, Pausable {
508     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
509         return super.transfer(to, value);
510     }
511 
512     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
513         return super.transferFrom(from, to, value);
514     }
515 
516     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
517         return super.approve(spender, value);
518     }
519 
520     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
521         return super.increaseAllowance(spender, addedValue);
522     }
523 
524     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
525         return super.decreaseAllowance(spender, subtractedValue);
526     }
527 }
528 
529 
530 
531 /**
532  * @title ERC20Detailed token
533  * @dev The decimals are only for visualization purposes.
534  * All the operations are done using the smallest and indivisible token unit,
535  * just as on Ethereum all the operations are done in wei.
536  */
537 contract ERC20Detailed is IERC20 {
538     string private _name;
539     string private _symbol;
540     uint8 private _decimals;
541 
542     constructor (string memory name, string memory symbol, uint8 decimals) public {
543         _name = name;
544         _symbol = symbol;
545         _decimals = decimals;
546     }
547  
548     function _rename(string memory tokenname, string memory tokensymbol) internal {
549         _name = tokenname;
550         _symbol = tokensymbol;
551     }
552 
553     /**
554      * @return the name of the token.
555      */
556     function name() public view returns (string memory) {
557         return _name;
558     }
559 
560     /**
561      * @return the symbol of the token.
562      */
563     function symbol() public view returns (string memory) {
564         return _symbol;
565     }
566 
567     /**
568      * @return the number of decimals of the token.
569      */
570     function decimals() public view returns (uint8) {
571         return _decimals;
572     }
573 }
574 
575 
576 
577 contract JQKToken is ERC20,ERC20Burnable,ERC20Pausable,Ownable,ERC20Detailed {
578     
579     uint private nextminttime = 0;
580     
581     constructor()
582         ERC20Burnable() ERC20Pausable() ERC20() Ownable() ERC20Detailed("Pokersoon JQK Token", "JQK", 18) 
583      public {
584         _mint(msg.sender, 100000000000000000000000000); 
585         
586         //can mint after 14 years
587         nextminttime = now + 14 * 365 days;
588     }
589     
590     function mint(address account, uint256 value) public onlyOwner{
591         require(value > 0);
592         require(now > nextminttime);
593         // 2% every year max
594         uint256 canminttokenamount = totalSupply().mul(2).div(100);
595         require(canminttokenamount >= value);
596         uint year = now.sub(nextminttime).div(365 days);
597         nextminttime += (year + 1) * 365 days;
598         _mint(account,value);
599     }
600 
601     function rename(string memory tokenname, string memory tokensymbol) public onlyOwner{
602         _rename(tokenname, tokensymbol);
603     }
604 }