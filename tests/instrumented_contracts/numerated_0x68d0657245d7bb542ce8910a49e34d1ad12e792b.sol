1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9     /**
10      * @dev Multiplies two numbers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two numbers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 /**
59  * @title ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 interface IERC20 {
63     function transfer(address to, uint256 value) external returns (bool);
64 
65     function approve(address spender, uint256 value) external returns (bool);
66 
67     function transferFrom(address from, address to, uint256 value) external returns (bool);
68 
69     function totalSupply() external view returns (uint256);
70 
71     function balanceOf(address who) external view returns (uint256);
72 
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     function mint(address to, uint256 value) external returns (bool);
76 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 /**
83  * @title Standard ERC20 token
84  *
85  * @dev Implementation of the basic standard token.
86  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
87  * Originally based on code by FirstBlood:
88  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89  *
90  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
91  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
92  * compliant implementations may not do it.
93  */
94 contract ERC20 is IERC20 {
95     using SafeMath for uint256;
96 
97     mapping (address => uint256) private _balances;
98 
99     mapping (address => mapping (address => uint256)) private _allowed;
100 
101     uint256 private _totalSupply;
102 
103     /**
104     * @dev Total number of tokens in existence
105     */
106     function totalSupply() public view returns (uint256) {
107         return _totalSupply;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param owner The address to query the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address owner) public view returns (uint256) {
116         return _balances[owner];
117     }
118 
119     /**
120      * @dev Function to check the amount of tokens that an owner allowed to a spender.
121      * @param owner address The address which owns the funds.
122      * @param spender address The address which will spend the funds.
123      * @return A uint256 specifying the amount of tokens still available for the spender.
124      */
125     function allowance(address owner, address spender) public view returns (uint256) {
126         return _allowed[owner][spender];
127     }
128 
129     /**
130     * @dev Transfer token for a specified address
131     * @param to The address to transfer to.
132     * @param value The amount to be transferred.
133     */
134     function transfer(address to, uint256 value) public returns (bool) {
135         _transfer(msg.sender, to, value);
136         return true;
137     }
138 
139     /**
140      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141      * Beware that changing an allowance with this method brings the risk that someone may use both the old
142      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      * @param spender The address which will spend the funds.
146      * @param value The amount of tokens to be spent.
147      */
148     function approve(address spender, uint256 value) public returns (bool) {
149         require(spender != address(0));
150 
151         _allowed[msg.sender][spender] = value;
152         emit Approval(msg.sender, spender, value);
153         return true;
154     }
155 
156     /**
157      * @dev Transfer tokens from one address to another.
158      * Note that while this function emits an Approval event, this is not required as per the specification,
159      * and other compliant implementations may not emit the event.
160      * @param from address The address which you want to send tokens from
161      * @param to address The address which you want to transfer to
162      * @param value uint256 the amount of tokens to be transferred
163      */
164     function transferFrom(address from, address to, uint256 value) public returns (bool) {
165         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
166         _transfer(from, to, value);
167         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
168         return true;
169     }
170 
171     /**
172      * @dev Increase the amount of tokens that an owner allowed to a spender.
173      * approve should be called when allowed_[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      * Emits an Approval event.
178      * @param spender The address which will spend the funds.
179      * @param addedValue The amount of tokens to increase the allowance by.
180      */
181     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
182         require(spender != address(0));
183 
184         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
185         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
186         return true;
187     }
188 
189     /**
190      * @dev Decrease the amount of tokens that an owner allowed to a spender.
191      * approve should be called when allowed_[_spender] == 0. To decrement
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * Emits an Approval event.
196      * @param spender The address which will spend the funds.
197      * @param subtractedValue The amount of tokens to decrease the allowance by.
198      */
199     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
200         require(spender != address(0));
201 
202         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
203         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
204         return true;
205     }
206 
207     /**
208     * @dev Transfer token for a specified addresses
209     * @param from The address to transfer from.
210     * @param to The address to transfer to.
211     * @param value The amount to be transferred.
212     */
213     function _transfer(address from, address to, uint256 value) internal {
214         require(to != address(0));
215 
216         _balances[from] = _balances[from].sub(value);
217         _balances[to] = _balances[to].add(value);
218         emit Transfer(from, to, value);
219     }
220 
221     /**
222      * @dev Internal function that mints an amount of the token and assigns it to
223      * an account. This encapsulates the modification of balances such that the
224      * proper events are emitted.
225      * @param account The account that will receive the created tokens.
226      * @param value The amount that will be created.
227      */
228     function _mint(address account, uint256 value) internal {
229         require(account != address(0));
230 
231         _totalSupply = _totalSupply.add(value);
232         _balances[account] = _balances[account].add(value);
233         emit Transfer(address(0), account, value);
234     }
235 
236     /**
237      * @dev Internal function that burns an amount of the token of a given
238      * account.
239      * @param account The account whose tokens will be burnt.
240      * @param value The amount that will be burnt.
241      */
242     function _burn(address account, uint256 value) internal {
243         require(account != address(0));
244 
245         _totalSupply = _totalSupply.sub(value);
246         _balances[account] = _balances[account].sub(value);
247         emit Transfer(account, address(0), value);
248     }
249 
250     /**
251      * @dev Internal function that burns an amount of the token of a given
252      * account, deducting from the sender's allowance for said account. Uses the
253      * internal burn function.
254      * Emits an Approval event (reflecting the reduced allowance).
255      * @param account The account whose tokens will be burnt.
256      * @param value The amount that will be burnt.
257      */
258     function _burnFrom(address account, uint256 value) internal {
259         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
260         _burn(account, value);
261         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
262     }
263 }
264 
265 /**
266  * @title Burnable Token
267  * @dev Token that can be irreversibly burned (destroyed).
268  */
269 contract ERC20Burnable is ERC20 {
270     /**
271      * @dev Burns a specific amount of tokens.
272      * @param value The amount of token to be burned.
273      */
274     function burn(uint256 value) public {
275         _burn(msg.sender, value);
276     }
277 
278     /**
279      * @dev Burns a specific amount of tokens from the target address and decrements allowance
280      * @param from address The address which you want to send tokens from
281      * @param value uint256 The amount of token to be burned
282      */
283     function burnFrom(address from, uint256 value) public {
284         _burnFrom(from, value);
285     }
286 }
287 
288 /**
289  * @title Roles
290  * @dev Library for managing addresses assigned to a Role.
291  */
292 library Roles {
293     struct Role {
294         mapping (address => bool) bearer;
295     }
296 
297     /**
298      * @dev give an account access to this role
299      */
300     function add(Role storage role, address account) internal {
301         require(account != address(0));
302         require(!has(role, account));
303 
304         role.bearer[account] = true;
305     }
306 
307     /**
308      * @dev remove an account's access to this role
309      */
310     function remove(Role storage role, address account) internal {
311         require(account != address(0));
312         require(has(role, account));
313 
314         role.bearer[account] = false;
315     }
316 
317     /**
318      * @dev check if an account has this role
319      * @return bool
320      */
321     function has(Role storage role, address account) internal view returns (bool) {
322         require(account != address(0));
323         return role.bearer[account];
324     }
325 }
326 
327 /**
328  * @title MinterRole
329  * @dev Only some specific address can mint new tokens
330  */
331 contract MinterRole {
332     using Roles for Roles.Role;
333 
334     event MinterAdded(address indexed account);
335 
336     Roles.Role private _minters;
337 
338     constructor () internal {
339         _addMinter(msg.sender);
340     }
341 
342     modifier onlyMinter() {
343         require(isMinter(msg.sender));
344         _;
345     }
346 
347     function isMinter(address account) public view returns (bool) {
348         return _minters.has(account);
349     }
350 
351     function _addMinter(address account) private {
352         _minters.add(account);
353         emit MinterAdded(account);
354     }
355 }
356 
357 /**
358  * @title ERC20Mintable
359  * @dev ERC20 minting logic
360  */
361 contract ERC20Mintable is ERC20, MinterRole {
362     /**
363      * @dev Function to mint tokens
364      * @param to The address that will receive the minted tokens.
365      * @param value The amount of tokens to mint.
366      * @return A boolean that indicates if the operation was successful.
367      */
368     function mint(address to, uint256 value) public onlyMinter returns (bool) {
369         _mint(to, value);
370         return true;
371     }
372 }
373 
374 /**
375  * @title ZOM Token smart contract
376  */
377 contract ZOMToken is ERC20Mintable, ERC20Burnable {
378     string private constant _name = "ZOM";
379     string private constant _symbol = "ZOM";
380     uint8 private constant _decimals = 18;
381     uint256 private constant _initialSupply = 50000000 * 1 ether; // 50,000,000.00 ZOM
382 
383     constructor () public {
384         _mint(msg.sender, initialSupply());
385     }
386 
387     /**
388      * @return the name of the token.
389      */
390     function name() public pure returns (string memory) {
391         return _name;
392     }
393 
394     /**
395      * @return the symbol of the token.
396      */
397     function symbol() public pure returns (string memory) {
398         return _symbol;
399     }
400 
401     /**
402      * @return the number of decimals of the token.
403      */
404     function decimals() public pure returns (uint8) {
405         return _decimals;
406     }
407 
408     /**
409      * @return the number of initial supply tokens.
410      */
411     function initialSupply() public pure returns (uint256) {
412         return _initialSupply;
413     }
414 }
415 
416 /**
417  * @title Helps contracts guard against reentrancy attacks.
418  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
419  * @dev If you mark a function `nonReentrant`, you should also
420  * mark it `external`.
421  */
422 contract ReentrancyGuard {
423     /// @dev counter to allow mutex lock with only one SSTORE operation
424     uint256 private _guardCounter;
425 
426     constructor () internal {
427         // The counter starts at one to prevent changing it from zero to a non-zero
428         // value, which is a more expensive operation.
429         _guardCounter = 1;
430     }
431 
432     /**
433      * @dev Prevents a contract from calling itself, directly or indirectly.
434      * Calling a `nonReentrant` function from another `nonReentrant`
435      * function is not supported. It is possible to prevent this from happening
436      * by making the `nonReentrant` function external, and make it call a
437      * `private` function that does the actual work.
438      */
439     modifier nonReentrant() {
440         _guardCounter += 1;
441         uint256 localCounter = _guardCounter;
442         _;
443         require(localCounter == _guardCounter);
444     }
445 }
446 
447 /**
448  * @title Reward
449  * @author Ararat Tonoyan <tonoyandeveloper@gmail.com>
450  * @dev The contract store the owner addresses, who can receive an reward
451  * tokens from ZOMToken smart contract once in 30 days 1 and 3 percent annually.
452  */
453 contract Reward is ReentrancyGuard {
454     using SafeMath for uint256;
455 
456     uint8 private constant _smallProcent = 1;
457     uint8 private constant _bigProcent = 3;
458     uint256 private constant _rewardDelay = 30 days;
459     uint256 private constant _firstGroupTokensLimit = 50000 * 1 ether; // 50,000.00 ZOM
460     uint256 private _contractCreationDate;
461 
462     struct Holder {
463         uint256 lastWithdrawDate;
464         uint256 amountOfWithdraws;
465     }
466 
467     IERC20 private _token;
468 
469     mapping(address => Holder) private _rewardTimeStamp;
470 
471     event NewTokensMinted(address indexed receiver, uint256 amount);
472 
473     modifier onlyHolder {
474         uint256 balanceOfHolder = _getTokenBalance(msg.sender);
475         require(balanceOfHolder > 0, "onlyHolder: the sender has no ZOM tokens");
476         _;
477     }
478 
479     // -----------------------------------------
480     // CONSTRUCTOR
481     // -----------------------------------------
482 
483     constructor() public {
484         address zom = address(new ZOMToken());
485         _token = IERC20(zom);
486         _contractCreationDate = block.timestamp;
487         _token.transfer(msg.sender, _token.totalSupply());
488     }
489 
490     // -----------------------------------------
491     // EXTERNAL
492     // -----------------------------------------
493 
494     function withdrawRewardTokens() external onlyHolder nonReentrant {
495         address holder = msg.sender;
496         uint256 lastWithdrawDate = _getLastWithdrawDate(holder);
497         uint256 howDelaysAvailable = (block.timestamp.sub(lastWithdrawDate)).div(_rewardDelay);
498 
499         require(howDelaysAvailable > 0, "withdrawRewardTokens: the holder can not withdraw tokens yet!");
500 
501         uint256 tokensAmount = _calculateRewardTokens(holder);
502 
503         // updating the last withdraw timestamp
504         uint256 timeAfterLastDelay = block.timestamp.sub(lastWithdrawDate) % _rewardDelay;
505         _rewardTimeStamp[holder].lastWithdrawDate = block.timestamp.sub(timeAfterLastDelay);
506 
507         // transfering the tokens
508         _mint(holder, tokensAmount);
509 
510         emit NewTokensMinted(holder, tokensAmount);
511     }
512 
513 
514     // -----------------------------------------
515     // GETTERS
516     // -----------------------------------------
517 
518     function getHolderData(address holder) external view returns (uint256, uint256, uint256) {
519         return (
520             _getTokenBalance(holder),
521             _rewardTimeStamp[holder].lastWithdrawDate,
522             _rewardTimeStamp[holder].amountOfWithdraws
523         );
524     }
525 
526     function getAvailableRewardTokens(address holder) external view returns (uint256) {
527         return _calculateRewardTokens(holder);
528     }
529 
530     function token() external view returns (address) {
531         return address(_token);
532     }
533 
534     function creationDate() external view returns (uint256) {
535         return _contractCreationDate;
536     }
537 
538     // -----------------------------------------
539     // INTERNAL
540     // -----------------------------------------
541 
542     function _mint(address holder, uint256 amount) private {
543         require(_token.mint(holder, amount),"_mint: the issue happens during tokens minting");
544         _rewardTimeStamp[holder].amountOfWithdraws = _rewardTimeStamp[holder].amountOfWithdraws.add(1);
545     }
546 
547     function _calculateRewardTokens(address holder) private view returns (uint256) {
548         uint256 lastWithdrawDate = _getLastWithdrawDate(holder);
549         uint256 howDelaysAvailable = (block.timestamp.sub(lastWithdrawDate)).div(_rewardDelay);
550         uint256 currentBalance = _getTokenBalance(holder);
551         uint8 procent = currentBalance >= _firstGroupTokensLimit ? _bigProcent : _smallProcent;
552         uint256 amount = currentBalance * howDelaysAvailable * procent / 100;
553 
554         return amount / 12;
555     }
556 
557     function _getTokenBalance(address holder) private view returns (uint256) {
558         return _token.balanceOf(holder);
559     }
560 
561     function _getLastWithdrawDate(address holder) private view returns (uint256) {
562         uint256 lastWithdrawDate = _rewardTimeStamp[holder].lastWithdrawDate;
563         if (lastWithdrawDate == 0) {
564             lastWithdrawDate = _contractCreationDate;
565         }
566 
567         return lastWithdrawDate;
568     }
569 }