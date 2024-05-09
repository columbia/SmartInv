1 pragma solidity ^0.4.24;
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
26 library SafeMath {
27     /**
28     * @dev Multiplies two unsigned integers, reverts on overflow.
29     */
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint256 c = a * b;
39         require(c / a == b);
40 
41         return c;
42     }
43 
44     /**
45     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
46     */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Solidity only automatically asserts when dividing by 0
49         require(b > 0);
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53         return c;
54     }
55 
56     /**
57     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
58     */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b <= a);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67     * @dev Adds two unsigned integers, reverts on overflow.
68     */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a);
72 
73         return c;
74     }
75 
76     /**
77     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
78     * reverts when dividing by zero.
79     */
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b != 0);
82         return a % b;
83     }
84 }
85 
86 
87 contract ERC20 is IERC20 {
88     using SafeMath for uint256;
89 
90     mapping (address => uint256) private _balances;
91 
92     mapping (address => mapping (address => uint256)) private _allowed;
93 
94     uint256 private _totalSupply;
95 
96     /**
97     * @dev Total number of tokens in existence
98     */
99     function totalSupply() public view returns (uint256) {
100         return _totalSupply;
101     }
102 
103     /**
104     * @dev Gets the balance of the specified address.
105     * @param owner The address to query the balance of.
106     * @return An uint256 representing the amount owned by the passed address.
107     */
108     function balanceOf(address owner) public view returns (uint256) {
109         return _balances[owner];
110     }
111 
112     /**
113      * @dev Function to check the amount of tokens that an owner allowed to a spender.
114      * @param owner address The address which owns the funds.
115      * @param spender address The address which will spend the funds.
116      * @return A uint256 specifying the amount of tokens still available for the spender.
117      */
118     function allowance(address owner, address spender) public view returns (uint256) {
119         return _allowed[owner][spender];
120     }
121 
122     /**
123     * @dev Transfer token for a specified address
124     * @param to The address to transfer to.
125     * @param value The amount to be transferred.
126     */
127     function transfer(address to, uint256 value) public returns (bool) {
128         _transfer(msg.sender, to, value);
129         return true;
130     }
131 
132     /**
133      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134      * Beware that changing an allowance with this method brings the risk that someone may use both the old
135      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      * @param spender The address which will spend the funds.
139      * @param value The amount of tokens to be spent.
140      */
141     function approve(address spender, uint256 value) public returns (bool) {
142         _approve(msg.sender, spender, value);
143         return true;
144     }
145 
146     /**
147      * @dev Transfer tokens from one address to another.
148      * Note that while this function emits an Approval event, this is not required as per the specification,
149      * and other compliant implementations may not emit the event.
150      * @param from address The address which you want to send tokens from
151      * @param to address The address which you want to transfer to
152      * @param value uint256 the amount of tokens to be transferred
153      */
154     function transferFrom(address from, address to, uint256 value) public returns (bool) {
155         _transfer(from, to, value);
156         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
157         return true;
158     }
159 
160     /**
161      * @dev Increase the amount of tokens that an owner allowed to a spender.
162      * approve should be called when allowed_[_spender] == 0. To increment
163      * allowed value is better to use this function to avoid 2 calls (and wait until
164      * the first transaction is mined)
165      * From MonolithDAO Token.sol
166      * Emits an Approval event.
167      * @param spender The address which will spend the funds.
168      * @param addedValue The amount of tokens to increase the allowance by.
169      */
170     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
171         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
172         return true;
173     }
174 
175     /**
176      * @dev Decrease the amount of tokens that an owner allowed to a spender.
177      * approve should be called when allowed_[_spender] == 0. To decrement
178      * allowed value is better to use this function to avoid 2 calls (and wait until
179      * the first transaction is mined)
180      * From MonolithDAO Token.sol
181      * Emits an Approval event.
182      * @param spender The address which will spend the funds.
183      * @param subtractedValue The amount of tokens to decrease the allowance by.
184      */
185     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
186         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
187         return true;
188     }
189 
190     /**
191     * @dev Transfer token for a specified addresses
192     * @param from The address to transfer from.
193     * @param to The address to transfer to.
194     * @param value The amount to be transferred.
195     */
196     function _transfer(address from, address to, uint256 value) internal {
197         require(to != address(0));
198 
199         _balances[from] = _balances[from].sub(value);
200         _balances[to] = _balances[to].add(value);
201         emit Transfer(from, to, value);
202     }
203 
204     /**
205      * @dev Internal function that mints an amount of the token and assigns it to
206      * an account. This encapsulates the modification of balances such that the
207      * proper events are emitted.
208      * @param account The account that will receive the created tokens.
209      * @param value The amount that will be created.
210      */
211     function _mint(address account, uint256 value) internal {
212         require(account != address(0));
213 
214         _totalSupply = _totalSupply.add(value);
215         _balances[account] = _balances[account].add(value);
216         emit Transfer(address(0), account, value);
217     }
218 
219     /**
220      * @dev Internal function that burns an amount of the token of a given
221      * account.
222      * @param account The account whose tokens will be burnt.
223      * @param value The amount that will be burnt.
224      */
225     function _burn(address account, uint256 value) internal {
226         require(account != address(0));
227 
228         _totalSupply = _totalSupply.sub(value);
229         _balances[account] = _balances[account].sub(value);
230         emit Transfer(account, address(0), value);
231     }
232 
233     /**
234      * @dev Approve an address to spend another addresses' tokens.
235      * @param owner The address that owns the tokens.
236      * @param spender The address that will spend the tokens.
237      * @param value The number of tokens that can be spent.
238      */
239     function _approve(address owner, address spender, uint256 value) internal {
240         require(spender != address(0));
241         require(owner != address(0));
242 
243         _allowed[owner][spender] = value;
244         emit Approval(owner, spender, value);
245     }
246 
247     /**
248      * @dev Internal function that burns an amount of the token of a given
249      * account, deducting from the sender's allowance for said account. Uses the
250      * internal burn function.
251      * Emits an Approval event (reflecting the reduced allowance).
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burnFrom(address account, uint256 value) internal {
256         _burn(account, value);
257         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
258     }
259     
260     
261 }
262 
263 contract ERC20Burnable is ERC20 {
264     /**
265      * @dev Burns a specific amount of tokens.
266      * @param value The amount of token to be burned.
267      */
268     function burn(uint256 value) public {
269         _burn(msg.sender, value);
270     }
271 
272     /**
273      * @dev Burns a specific amount of tokens from the target address and decrements allowance
274      * @param from address The address which you want to send tokens from
275      * @param value uint256 The amount of token to be burned
276      */
277     function burnFrom(address from, uint256 value) public {
278         _burnFrom(from, value);
279     }
280 }
281 
282 contract ERC20Detailed is IERC20 {
283     string private _name;
284     string private _symbol;
285     uint8 private _decimals;
286 
287     constructor (string memory name, string memory symbol, uint8 decimals) public {
288         _name = name;
289         _symbol = symbol;
290         _decimals = decimals;
291     }
292 
293     /**
294      * @return the name of the token.
295      */
296     function name() public view returns (string memory) {
297         return _name;
298     }
299 
300     /**
301      * @return the symbol of the token.
302      */
303     function symbol() public view returns (string memory) {
304         return _symbol;
305     }
306 
307     /**
308      * @return the number of decimals of the token.
309      */
310     function decimals() public view returns (uint8) {
311         return _decimals;
312     }
313 }
314 
315 
316 contract Ownable {
317     address private _owner;
318 
319     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
320 
321     /**
322      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
323      * account.
324      */
325     constructor () internal {
326         _owner = msg.sender;
327         emit OwnershipTransferred(address(0), _owner);
328     }
329 
330     /**
331      * @return the address of the owner.
332      */
333     function owner() public view returns (address) {
334         return _owner;
335     }
336 
337     /**
338      * @dev Throws if called by any account other than the owner.
339      */
340     modifier onlyOwner() {
341         require(isOwner());
342         _;
343     }
344 
345     /**
346      * @return true if `msg.sender` is the owner of the contract.
347      */
348     function isOwner() public view returns (bool) {
349         return msg.sender == _owner;
350     }
351 
352     /**
353      * @dev Allows the current owner to relinquish control of the contract.
354      * It will not be possible to call the functions with the `onlyOwner`
355      * modifier anymore.
356      * @notice Renouncing ownership will leave the contract without an owner,
357      * thereby removing any functionality that is only available to the owner.
358      */
359     function renounceOwnership() public onlyOwner {
360         emit OwnershipTransferred(_owner, address(0));
361         _owner = address(0);
362     }
363 
364     /**
365      * @dev Allows the current owner to transfer control of the contract to a newOwner.
366      * @param newOwner The address to transfer ownership to.
367      */
368     function transferOwnership(address newOwner) public onlyOwner {
369         _transferOwnership(newOwner);
370     }
371 
372     /**
373      * @dev Transfers control of the contract to a newOwner.
374      * @param newOwner The address to transfer ownership to.
375      */
376     function _transferOwnership(address newOwner) internal {
377         require(newOwner != address(0));
378         emit OwnershipTransferred(_owner, newOwner);
379         _owner = newOwner;
380     }
381 }
382 
383 
384 library Roles {
385     struct Role {
386         mapping (address => bool) bearer;
387     }
388 
389     /**
390      * @dev Give an account access to this role.
391      */
392     function add(Role storage role, address account) internal {
393         require(account != address(0));
394         require(!has(role, account));
395 
396         role.bearer[account] = true;
397     }
398 
399     /**
400      * @dev Remove an account's access to this role.
401      */
402     function remove(Role storage role, address account) internal {
403         require(account != address(0));
404         require(has(role, account));
405 
406         role.bearer[account] = false;
407     }
408 
409     /**
410      * @dev Check if an account has this role.
411      * @return bool
412      */
413     function has(Role storage role, address account) internal view returns (bool) {
414         require(account != address(0));
415         return role.bearer[account];
416     }
417 }
418 
419 
420 contract MinterRole {
421     using Roles for Roles.Role;
422 
423     event MinterAdded(address indexed account);
424     event MinterRemoved(address indexed account);
425 
426     Roles.Role private _minters;
427 
428     constructor () internal {
429         _addMinter(msg.sender);
430     }
431 
432     modifier onlyMinter() {
433         require(isMinter(msg.sender));
434         _;
435     }
436 
437     function isMinter(address account) public view returns (bool) {
438         return _minters.has(account);
439     }
440 
441     function addMinter(address account) public onlyMinter {
442         _addMinter(account);
443     }
444 
445     function renounceMinter() public {
446         _removeMinter(msg.sender);
447     }
448 
449     function _addMinter(address account) internal {
450         _minters.add(account);
451         emit MinterAdded(account);
452     }
453 
454     function _removeMinter(address account) internal {
455         _minters.remove(account);
456         emit MinterRemoved(account);
457     }
458 }
459 
460 contract ERC1132 {
461     /**
462      * @dev Reasons why a user's tokens have been locked
463      */
464     mapping(address => bytes32[]) public lockReason;
465 
466     /**
467      * @dev locked token structure
468      */
469     struct lockToken {
470         uint256 amount;
471         uint256 validity;
472         bool claimed;
473     }
474 
475     /**
476      * @dev Holds number & validity of tokens locked for a given reason for
477      *      a specified address
478      */
479     mapping(address => mapping(bytes32 => lockToken)) public locked;
480 
481     /**
482      * @dev Records data of all the tokens Locked
483      */
484     event Locked(
485         address indexed _of,
486         bytes32 indexed _reason,
487         uint256 _amount,
488         uint256 _validity
489     );
490 
491     /**
492      * @dev Records data of all the tokens unlocked
493      */
494     event Unlocked(
495         address indexed _of,
496         bytes32 indexed _reason,
497         uint256 _amount
498     );
499     
500     /**
501      * @dev Locks a specified amount of tokens against an address,
502      *      for a specified reason and time
503      * @param _reason The reason to lock tokens
504      * @param _amount Number of tokens to be locked
505      * @param _time Lock time in seconds
506      */
507     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
508         public returns (bool);
509   
510     /**
511      * @dev Returns tokens locked for a specified address for a
512      *      specified reason
513      *
514      * @param _of The address whose tokens are locked
515      * @param _reason The reason to query the lock tokens for
516      */
517     function tokensLocked(address _of, bytes32 _reason)
518         public view returns (uint256 amount);
519     
520     /**
521      * @dev Returns tokens locked for a specified address for a
522      *      specified reason at a specific time
523      *
524      * @param _of The address whose tokens are locked
525      * @param _reason The reason to query the lock tokens for
526      * @param _time The timestamp to query the lock tokens for
527      */
528     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
529         public view returns (uint256 amount);
530     
531     /**
532      * @dev Returns total tokens held by an address (locked + transferable)
533      * @param _of The address to query the total balance of
534      */
535     function totalBalanceOf(address _of)
536         public view returns (uint256 amount);
537     
538     /**
539      * @dev Extends lock for a specified reason and time
540      * @param _reason The reason to lock tokens
541      * @param _time Lock extension time in seconds
542      */
543     function extendLock(bytes32 _reason, uint256 _time)
544         public returns (bool);
545     
546     /**
547      * @dev Increase number of tokens locked for a specified reason
548      * @param _reason The reason to lock tokens
549      * @param _amount Number of tokens to be increased
550      */
551     function increaseLockAmount(bytes32 _reason, uint256 _amount)
552         public returns (bool);
553 
554     /**
555      * @dev Returns unlockable tokens for a specified address for a specified reason
556      * @param _of The address to query the the unlockable token count of
557      * @param _reason The reason to query the unlockable tokens for
558      */
559     function tokensUnlockable(address _of, bytes32 _reason)
560         public view returns (uint256 amount);
561  
562     /**
563      * @dev Unlocks the unlockable tokens of a specified address
564      * @param _of Address of user, claiming back unlockable tokens
565      */
566     function unlock(address _of)
567         public returns (uint256 unlockableTokens);
568 
569     /**
570      * @dev Gets the unlockable tokens of a specified address
571      * @param _of The address to query the the unlockable token count of
572      */
573     function getUnlockableTokens(address _of)
574         public view returns (uint256 unlockableTokens);
575 
576 }
577 
578 
579 contract SimpleToken is ERC20, ERC20Detailed, ERC20Burnable,  Ownable {
580     uint8 public constant DECIMALS = 18;
581     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(DECIMALS));
582 
583     /**
584      * @dev Constructor that gives msg.sender all of existing tokens.
585      */
586     constructor () public ERC20Detailed("Tiger", "Tiger", DECIMALS) {
587         _mint(msg.sender, INITIAL_SUPPLY);
588     }
589 }