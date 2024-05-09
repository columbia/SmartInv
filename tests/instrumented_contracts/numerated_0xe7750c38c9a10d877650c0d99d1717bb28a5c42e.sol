1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 /**
69  * @title Math
70  * @dev Assorted math operations
71  */
72 library Math {
73     /**
74      * @dev Returns the largest of two numbers.
75      */
76     function max(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a >= b ? a : b;
78     }
79 
80     /**
81      * @dev Returns the smallest of two numbers.
82      */
83     function min(uint256 a, uint256 b) internal pure returns (uint256) {
84         return a < b ? a : b;
85     }
86 
87     /**
88      * @dev Calculates the average of two numbers. Since these are integers,
89      * averages of an even and odd number cannot be represented, and will be
90      * rounded down.
91      */
92     function average(uint256 a, uint256 b) internal pure returns (uint256) {
93         // (a + b) / 2 can overflow, so we distribute
94         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
95     }
96 }
97 
98 /**
99  * Utility library of inline functions on addresses
100  */
101 library Address {
102     /**
103      * Returns whether the target address is a contract
104      * @dev This function will return false if invoked during the constructor of a contract,
105      * as the code is not actually created until after the constructor finishes.
106      * @param account address of the account to check
107      * @return whether the target address is a contract
108      */
109     function isContract(address account) internal view returns (bool) {
110         uint256 size;
111         // XXX Currently there is no better way to check if there is a contract in an address
112         // than to check the size of the code at that address.
113         // See https://ethereum.stackexchange.com/a/14016/36603
114         // for more details about how this works.
115         // TODO Check this again before the Serenity release, because all addresses will be
116         // contracts then.
117         // solhint-disable-next-line no-inline-assembly
118         assembly { size := extcodesize(account) }
119         return size > 0;
120     }
121 }
122 
123 /**
124  * @title Roles
125  * @dev Library for managing addresses assigned to a Role.
126  */
127 library Roles {
128     struct Role {
129         mapping (address => bool) bearer;
130     }
131 
132     /**
133      * @dev give an account access to this role
134      */
135     function add(Role storage role, address account) internal {
136         require(account != address(0));
137         require(!has(role, account));
138 
139         role.bearer[account] = true;
140     }
141 
142     /**
143      * @dev remove an account's access to this role
144      */
145     function remove(Role storage role, address account) internal {
146         require(account != address(0));
147         require(has(role, account));
148 
149         role.bearer[account] = false;
150     }
151 
152     /**
153      * @dev check if an account has this role
154      * @return bool
155      */
156     function has(Role storage role, address account) internal view returns (bool) {
157         require(account != address(0));
158         return role.bearer[account];
159     }
160 }
161 
162 contract MinterRole {
163     using Roles for Roles.Role;
164 
165     event MinterAdded(address indexed account);
166     event MinterRemoved(address indexed account);
167 
168     Roles.Role private _minters;
169 
170     constructor () internal {
171         _addMinter(msg.sender);
172     }
173 
174     modifier onlyMinter() {
175         require(isMinter(msg.sender));
176         _;
177     }
178 
179     function isMinter(address account) public view returns (bool) {
180         return _minters.has(account);
181     }
182 
183     function addMinter(address account) public onlyMinter {
184         _addMinter(account);
185     }
186 
187     function renounceMinter() public {
188         _removeMinter(msg.sender);
189     }
190 
191     function _addMinter(address account) internal {
192         _minters.add(account);
193         emit MinterAdded(account);
194     }
195 
196     function _removeMinter(address account) internal {
197         _minters.remove(account);
198         emit MinterRemoved(account);
199     }
200 }
201 
202 /**
203  * @title Helps contracts guard against reentrancy attacks.
204  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
205  * @dev If you mark a function `nonReentrant`, you should also
206  * mark it `external`.
207  */
208 contract ReentrancyGuard {
209     /// @dev counter to allow mutex lock with only one SSTORE operation
210     uint256 private _guardCounter;
211 
212     constructor () internal {
213         // The counter starts at one to prevent changing it from zero to a non-zero
214         // value, which is a more expensive operation.
215         _guardCounter = 1;
216     }
217 
218     /**
219      * @dev Prevents a contract from calling itself, directly or indirectly.
220      * Calling a `nonReentrant` function from another `nonReentrant`
221      * function is not supported. It is possible to prevent this from happening
222      * by making the `nonReentrant` function external, and make it call a
223      * `private` function that does the actual work.
224      */
225     modifier nonReentrant() {
226         _guardCounter += 1;
227         uint256 localCounter = _guardCounter;
228         _;
229         require(localCounter == _guardCounter);
230     }
231 }
232 
233 // ERC20 ------------------------------------------------------------------------------
234 /**
235  * @title ERC20 interface
236  * @dev see https://eips.ethereum.org/EIPS/eip-20
237  */
238 interface IERC20 {
239     function transfer(address to, uint256 value) external returns (bool);
240 
241     function approve(address spender, uint256 value) external returns (bool);
242 
243     function transferFrom(address from, address to, uint256 value) external returns (bool);
244 
245     function totalSupply() external view returns (uint256);
246 
247     function balanceOf(address who) external view returns (uint256);
248 
249     function allowance(address owner, address spender) external view returns (uint256);
250 
251     event Transfer(address indexed from, address indexed to, uint256 value);
252 
253     event Approval(address indexed owner, address indexed spender, uint256 value);
254 }
255 
256 /**
257  * @title SafeERC20
258  * @dev Wrappers around ERC20 operations that throw on failure (when the token
259  * contract returns false). Tokens that return no value (and instead revert or
260  * throw on failure) are also supported, non-reverting calls are assumed to be
261  * successful.
262  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
263  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
264  */
265 library SafeERC20 {
266     using SafeMath for uint256;
267     using Address for address;
268 
269     function safeTransfer(IERC20 token, address to, uint256 value) internal {
270         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
271     }
272 
273     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
274         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
275     }
276 
277     function safeApprove(IERC20 token, address spender, uint256 value) internal {
278         // safeApprove should only be called when setting an initial allowance,
279         // or when resetting it to zero. To increase and decrease it, use
280         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
281         require((value == 0) || (token.allowance(address(this), spender) == 0));
282         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
283     }
284 
285     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
286         uint256 newAllowance = token.allowance(address(this), spender).add(value);
287         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
288     }
289 
290     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
291         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
292         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
293     }
294 
295     /**
296      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
297      * on the return value: the return value is optional (but if data is returned, it must equal true).
298      * @param token The token targeted by the call.
299      * @param data The call data (encoded using abi.encode or one of its variants).
300      */
301     function callOptionalReturn(IERC20 token, bytes memory data) private {
302         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
303         // we're implementing it ourselves.
304 
305         // A Solidity high level call has three parts:
306         //  1. The target address is checked to verify it contains contract code
307         //  2. The call itself is made, and success asserted
308         //  3. The return value is decoded, which in turn checks the size of the returned data.
309 
310         require(address(token).isContract());
311 
312         // solhint-disable-next-line avoid-low-level-calls
313         (bool success, bytes memory returndata) = address(token).call(data);
314         require(success);
315 
316         if (returndata.length > 0) { // Return data is optional
317             require(abi.decode(returndata, (bool)));
318         }
319     }
320 }
321 
322 /**
323  * @title Standard ERC20 token
324  *
325  * @dev Implementation of the basic standard token.
326  * https://eips.ethereum.org/EIPS/eip-20
327  * Originally based on code by FirstBlood:
328  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
329  *
330  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
331  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
332  * compliant implementations may not do it.
333  */
334 contract ERC20 is IERC20 {
335     using SafeMath for uint256;
336 
337     mapping (address => uint256) private _balances;
338 
339     mapping (address => mapping (address => uint256)) private _allowed;
340 
341     uint256 private _totalSupply;
342 
343     /**
344      * @dev Total number of tokens in existence
345      */
346     function totalSupply() public view returns (uint256) {
347         return _totalSupply;
348     }
349 
350     /**
351      * @dev Gets the balance of the specified address.
352      * @param owner The address to query the balance of.
353      * @return A uint256 representing the amount owned by the passed address.
354      */
355     function balanceOf(address owner) public view returns (uint256) {
356         return _balances[owner];
357     }
358 
359     /**
360      * @dev Function to check the amount of tokens that an owner allowed to a spender.
361      * @param owner address The address which owns the funds.
362      * @param spender address The address which will spend the funds.
363      * @return A uint256 specifying the amount of tokens still available for the spender.
364      */
365     function allowance(address owner, address spender) public view returns (uint256) {
366         return _allowed[owner][spender];
367     }
368 
369     /**
370      * @dev Transfer token to a specified address
371      * @param to The address to transfer to.
372      * @param value The amount to be transferred.
373      */
374     function transfer(address to, uint256 value) public returns (bool) {
375         _transfer(msg.sender, to, value);
376         return true;
377     }
378 
379     /**
380      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
381      * Beware that changing an allowance with this method brings the risk that someone may use both the old
382      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
383      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
384      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
385      * @param spender The address which will spend the funds.
386      * @param value The amount of tokens to be spent.
387      */
388     function approve(address spender, uint256 value) public returns (bool) {
389         _approve(msg.sender, spender, value);
390         return true;
391     }
392 
393     /**
394      * @dev Transfer tokens from one address to another.
395      * Note that while this function emits an Approval event, this is not required as per the specification,
396      * and other compliant implementations may not emit the event.
397      * @param from address The address which you want to send tokens from
398      * @param to address The address which you want to transfer to
399      * @param value uint256 the amount of tokens to be transferred
400      */
401     function transferFrom(address from, address to, uint256 value) public returns (bool) {
402         _transfer(from, to, value);
403         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
404         return true;
405     }
406 
407     /**
408      * @dev Increase the amount of tokens that an owner allowed to a spender.
409      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
410      * allowed value is better to use this function to avoid 2 calls (and wait until
411      * the first transaction is mined)
412      * From MonolithDAO Token.sol
413      * Emits an Approval event.
414      * @param spender The address which will spend the funds.
415      * @param addedValue The amount of tokens to increase the allowance by.
416      */
417     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
418         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
419         return true;
420     }
421 
422     /**
423      * @dev Decrease the amount of tokens that an owner allowed to a spender.
424      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
425      * allowed value is better to use this function to avoid 2 calls (and wait until
426      * the first transaction is mined)
427      * From MonolithDAO Token.sol
428      * Emits an Approval event.
429      * @param spender The address which will spend the funds.
430      * @param subtractedValue The amount of tokens to decrease the allowance by.
431      */
432     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
433         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
434         return true;
435     }
436 
437     /**
438      * @dev Transfer token for a specified addresses
439      * @param from The address to transfer from.
440      * @param to The address to transfer to.
441      * @param value The amount to be transferred.
442      */
443     function _transfer(address from, address to, uint256 value) internal {
444         require(to != address(0));
445 
446         _balances[from] = _balances[from].sub(value);
447         _balances[to] = _balances[to].add(value);
448         emit Transfer(from, to, value);
449     }
450 
451     /**
452      * @dev Internal function that mints an amount of the token and assigns it to
453      * an account. This encapsulates the modification of balances such that the
454      * proper events are emitted.
455      * @param account The account that will receive the created tokens.
456      * @param value The amount that will be created.
457      */
458     function _mint(address account, uint256 value) internal {
459         require(account != address(0));
460 
461         _totalSupply = _totalSupply.add(value);
462         _balances[account] = _balances[account].add(value);
463         emit Transfer(address(0), account, value);
464     }
465 
466     /**
467      * @dev Internal function that burns an amount of the token of a given
468      * account.
469      * @param account The account whose tokens will be burnt.
470      * @param value The amount that will be burnt.
471      */
472     function _burn(address account, uint256 value) internal {
473         require(account != address(0));
474 
475         _totalSupply = _totalSupply.sub(value);
476         _balances[account] = _balances[account].sub(value);
477         emit Transfer(account, address(0), value);
478     }
479 
480     /**
481      * @dev Approve an address to spend another addresses' tokens.
482      * @param owner The address that owns the tokens.
483      * @param spender The address that will spend the tokens.
484      * @param value The number of tokens that can be spent.
485      */
486     function _approve(address owner, address spender, uint256 value) internal {
487         require(spender != address(0));
488         require(owner != address(0));
489 
490         _allowed[owner][spender] = value;
491         emit Approval(owner, spender, value);
492     }
493 
494     /**
495      * @dev Internal function that burns an amount of the token of a given
496      * account, deducting from the sender's allowance for said account. Uses the
497      * internal burn function.
498      * Emits an Approval event (reflecting the reduced allowance).
499      * @param account The account whose tokens will be burnt.
500      * @param value The amount that will be burnt.
501      */
502     function _burnFrom(address account, uint256 value) internal {
503         _burn(account, value);
504         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
505     }
506 }
507 
508 /**
509  * @title ERC20Detailed token
510  * @dev The decimals are only for visualization purposes.
511  * All the operations are done using the smallest and indivisible token unit,
512  * just as on Ethereum all the operations are done in wei.
513  */
514 contract ERC20Detailed is IERC20 {
515     string private _name;
516     string private _symbol;
517     uint8 private _decimals;
518 
519     constructor (string memory name, string memory symbol, uint8 decimals) public {
520         _name = name;
521         _symbol = symbol;
522         _decimals = decimals;
523     }
524 
525     /**
526      * @return the name of the token.
527      */
528     function name() public view returns (string memory) {
529         return _name;
530     }
531 
532     /**
533      * @return the symbol of the token.
534      */
535     function symbol() public view returns (string memory) {
536         return _symbol;
537     }
538 
539     /**
540      * @return the number of decimals of the token.
541      */
542     function decimals() public view returns (uint8) {
543         return _decimals;
544     }
545 }
546 
547 /**
548  * @title ERC20Mintable
549  * @dev ERC20 minting logic
550  */
551 contract ERC20Mintable is ERC20, MinterRole {
552     /**
553      * @dev Function to mint tokens
554      * @param to The address that will receive the minted tokens.
555      * @param value The amount of tokens to mint.
556      * @return A boolean that indicates if the operation was successful.
557      */
558     function mint(address to, uint256 value) public onlyMinter returns (bool) {
559         _mint(to, value);
560         return true;
561     }
562 }
563 
564 /**
565  * @title Capped token
566  * @dev Mintable token with a token cap.
567  */
568 contract ERC20Capped is ERC20Mintable {
569     uint256 private _cap;
570 
571     constructor (uint256 cap) public {
572         require(cap > 0);
573         _cap = cap;
574     }
575 
576     /**
577      * @return the cap for the token minting.
578      */
579     function cap() public view returns (uint256) {
580         return _cap;
581     }
582 
583     function _mint(address account, uint256 value) internal {
584         require(totalSupply().add(value) <= _cap);
585         super._mint(account, value);
586     }
587 }
588 
589 
590 //-------------------------------------------------------------------------------------
591 contract ZikToken is ERC20Capped, ERC20Detailed {
592     constructor() public 
593         ERC20Detailed( "Ziktalk Token", "ZIK", 18 )
594         ERC20Capped( 1e28 )
595     {
596     }
597 
598     /**
599      * @dev Burns a specific amount of tokens.
600      * @param value The amount of token to be burned.
601      */
602     function burn(uint256 value) public {
603         _burn(msg.sender, value);
604     }
605 
606     /**
607      * @dev Burns a specific amount of tokens from the target address and decrements allowance
608      * @param from address The account whose tokens will be burned.
609      * @param value uint256 The amount of token to be burned.
610      */
611     function burnFrom(address from, uint256 value) public {
612         _burnFrom(from, value);
613     }
614 }