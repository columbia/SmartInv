1 pragma solidity 0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
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
26     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27     */
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
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72     function totalSupply() external view returns (uint256);
73 
74     function balanceOf(address who) external view returns (uint256);
75 
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * Utility library of inline functions on addresses
91  */
92 library Address {
93     /**
94      * Returns whether the target address is a contract
95      * @dev This function will return false if invoked during the constructor of a contract,
96      * as the code is not actually created until after the constructor finishes.
97      * @param account address of the account to check
98      * @return whether the target address is a contract
99      */
100     function isContract(address account) internal view returns (bool) {
101         uint256 size;
102         // XXX Currently there is no better way to check if there is a contract in an address
103         // than to check the size of the code at that address.
104         // See https://ethereum.stackexchange.com/a/14016/36603
105         // for more details about how this works.
106         // TODO Check this again before the Serenity release, because all addresses will be
107         // contracts then.
108         // solhint-disable-next-line no-inline-assembly
109         assembly { size := extcodesize(account) }
110         return size > 0;
111     }
112 }
113 
114 /**
115  * @title SafeERC20
116  * @dev Wrappers around ERC20 operations that throw on failure (when the token
117  * contract returns false). Tokens that return no value (and instead revert or
118  * throw on failure) are also supported, non-reverting calls are assumed to be
119  * successful.
120  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
121  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
122  */
123 library SafeERC20 {
124     using SafeMath for uint256;
125     using Address for address;
126 
127     function safeTransfer(IERC20 token, address to, uint256 value) internal {
128         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
129     }
130 
131     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
132         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
133     }
134 
135     function safeApprove(IERC20 token, address spender, uint256 value) internal {
136         // safeApprove should only be called when setting an initial allowance,
137         // or when resetting it to zero. To increase and decrease it, use
138         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
139         // solhint-disable-next-line max-line-length
140         require((value == 0) || (token.allowance(address(this), spender) == 0),
141             "SafeERC20: approve from non-zero to non-zero allowance"
142         );
143         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
144     }
145 
146     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
147         uint256 newAllowance = token.allowance(address(this), spender).add(value);
148         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
149     }
150 
151     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
152         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
153         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
154     }
155 
156     /**
157      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
158      * on the return value: the return value is optional (but if data is returned, it must not be false).
159      * @param token The token targeted by the call.
160      * @param data The call data (encoded using abi.encode or one of its variants).
161      */
162     function callOptionalReturn(IERC20 token, bytes memory data) private {
163         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
164         // we're implementing it ourselves.
165 
166         // A Solidity high level call has three parts:
167         //  1. The target address is checked to verify it contains contract code
168         //  2. The call itself is made, and success asserted
169         //  3. The return value is decoded, which in turn checks the size of the returned data.
170         // solhint-disable-next-line max-line-length
171         require(address(token).isContract(), "SafeERC20: call to non-contract");
172 
173         // solhint-disable-next-line avoid-low-level-calls
174         (bool success, bytes memory returndata) = address(token).call(data);
175         require(success, "SafeERC20: low-level call failed");
176 
177         if (returndata.length > 0) { // Return data is optional
178             // solhint-disable-next-line max-line-length
179             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
180         }
181     }
182 }
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
189  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  *
191  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
192  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
193  * compliant implementations may not do it.
194  */
195 contract ERC20 is IERC20 {
196     using SafeMath for uint256;
197 
198     mapping (address => uint256) private _balances;
199 
200     mapping (address => mapping (address => uint256)) private _allowed;
201 
202     uint256 private _totalSupply;
203 
204     /**
205     * @dev Total number of tokens in existence
206     */
207     function totalSupply() public view returns (uint256) {
208         return _totalSupply;
209     }
210 
211     /**
212     * @dev Gets the balance of the specified address.
213     * @param owner The address to query the balance of.
214     * @return An uint256 representing the amount owned by the passed address.
215     */
216     function balanceOf(address owner) public view returns (uint256) {
217         return _balances[owner];
218     }
219 
220     /**
221      * @dev Function to check the amount of tokens that an owner allowed to a spender.
222      * @param owner address The address which owns the funds.
223      * @param spender address The address which will spend the funds.
224      * @return A uint256 specifying the amount of tokens still available for the spender.
225      */
226     function allowance(address owner, address spender) public view returns (uint256) {
227         return _allowed[owner][spender];
228     }
229 
230     /**
231     * @dev Transfer token for a specified address
232     * @param to The address to transfer to.
233     * @param value The amount to be transferred.
234     */
235     function transfer(address to, uint256 value) public returns (bool) {
236         _transfer(msg.sender, to, value);
237         return true;
238     }
239 
240     /**
241      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
242      * Beware that changing an allowance with this method brings the risk that someone may use both the old
243      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
244      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
245      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246      * @param spender The address which will spend the funds.
247      * @param value The amount of tokens to be spent.
248      */
249     function approve(address spender, uint256 value) public returns (bool) {
250         require(spender != address(0));
251 
252         _allowed[msg.sender][spender] = value;
253         emit Approval(msg.sender, spender, value);
254         return true;
255     }
256 
257     /**
258      * @dev Transfer tokens from one address to another.
259      * Note that while this function emits an Approval event, this is not required as per the specification,
260      * and other compliant implementations may not emit the event.
261      * @param from address The address which you want to send tokens from
262      * @param to address The address which you want to transfer to
263      * @param value uint256 the amount of tokens to be transferred
264      */
265     function transferFrom(address from, address to, uint256 value) public returns (bool) {
266         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
267         _transfer(from, to, value);
268         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
269         return true;
270     }
271 
272     /**
273      * @dev Increase the amount of tokens that an owner allowed to a spender.
274      * approve should be called when allowed_[_spender] == 0. To increment
275      * allowed value is better to use this function to avoid 2 calls (and wait until
276      * the first transaction is mined)
277      * From MonolithDAO Token.sol
278      * Emits an Approval event.
279      * @param spender The address which will spend the funds.
280      * @param addedValue The amount of tokens to increase the allowance by.
281      */
282     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
283         require(spender != address(0));
284 
285         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
286         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
287         return true;
288     }
289 
290     /**
291      * @dev Decrease the amount of tokens that an owner allowed to a spender.
292      * approve should be called when allowed_[_spender] == 0. To decrement
293      * allowed value is better to use this function to avoid 2 calls (and wait until
294      * the first transaction is mined)
295      * From MonolithDAO Token.sol
296      * Emits an Approval event.
297      * @param spender The address which will spend the funds.
298      * @param subtractedValue The amount of tokens to decrease the allowance by.
299      */
300     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
301         require(spender != address(0));
302 
303         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
304         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
305         return true;
306     }
307 
308     /**
309     * @dev Transfer token for a specified addresses
310     * @param from The address to transfer from.
311     * @param to The address to transfer to.
312     * @param value The amount to be transferred.
313     */
314     function _transfer(address from, address to, uint256 value) internal {
315         require(to != address(0));
316 
317         _balances[from] = _balances[from].sub(value);
318         _balances[to] = _balances[to].add(value);
319         emit Transfer(from, to, value);
320     }
321 
322     /**
323      * @dev Internal function that mints an amount of the token and assigns it to
324      * an account. This encapsulates the modification of balances such that the
325      * proper events are emitted.
326      * @param account The account that will receive the created tokens.
327      * @param value The amount that will be created.
328      */
329     function _mint(address account, uint256 value) internal {
330         require(account != address(0));
331 
332         _totalSupply = _totalSupply.add(value);
333         _balances[account] = _balances[account].add(value);
334         emit Transfer(address(0), account, value);
335     }
336 
337     /**
338      * @dev Internal function that burns an amount of the token of a given
339      * account.
340      * @param account The account whose tokens will be burnt.
341      * @param value The amount that will be burnt.
342      */
343     function _burn(address account, uint256 value) internal {
344         require(account != address(0));
345 
346         _totalSupply = _totalSupply.sub(value);
347         _balances[account] = _balances[account].sub(value);
348         emit Transfer(account, address(0), value);
349     }
350 
351     /**
352      * @dev Internal function that burns an amount of the token of a given
353      * account, deducting from the sender's allowance for said account. Uses the
354      * internal burn function.
355      * Emits an Approval event (reflecting the reduced allowance).
356      * @param account The account whose tokens will be burnt.
357      * @param value The amount that will be burnt.
358      */
359     function _burnFrom(address account, uint256 value) internal {
360         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
361         _burn(account, value);
362         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
363     }
364 }
365 
366 /**
367  * @title ERC20Detailed token
368  * @dev The decimals are only for visualization purposes.
369  * All the operations are done using the smallest and indivisible token unit,
370  * just as on Ethereum all the operations are done in wei.
371  */
372 contract ERC20Detailed is ERC20 {
373     string private _name;
374     string private _symbol;
375     uint8 private _decimals;
376 
377     constructor (string memory name, string memory symbol, uint8 decimals) public {
378         _name = name;
379         _symbol = symbol;
380         _decimals = decimals;
381     }
382 
383     /**
384      * @return the name of the token.
385      */
386     function name() public view returns (string memory) {
387         return _name;
388     }
389 
390     /**
391      * @return the symbol of the token.
392      */
393     function symbol() public view returns (string memory) {
394         return _symbol;
395     }
396 
397     /**
398      * @return the number of decimals of the token.
399      */
400     function decimals() public view returns (uint8) {
401         return _decimals;
402     }
403 }
404 
405 /**
406  * @title Ownable
407  * @dev The Ownable contract has an owner address, and provides basic authorization control
408  * functions, this simplifies the implementation of "user permissions".
409  */
410 contract Ownable {
411     address private _owner;
412 
413     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
414 
415     /**
416      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
417      * account.
418      */
419     constructor () internal {
420         _owner = msg.sender;
421         emit OwnershipTransferred(address(0), _owner);
422     }
423 
424     /**
425      * @return the address of the owner.
426      */
427     function owner() public view returns (address) {
428         return _owner;
429     }
430 
431     /**
432      * @dev Throws if called by any account other than the owner.
433      */
434     modifier onlyOwner() {
435         require(isOwner(), "Ownable: caller is not the owner");
436         _;
437     }
438 
439     /**
440      * @return true if `msg.sender` is the owner of the contract.
441      */
442     function isOwner() public view returns (bool) {
443         return msg.sender == _owner;
444     }
445 
446     /**
447      * @dev Allows the current owner to relinquish control of the contract.
448      * It will not be possible to call the functions with the `onlyOwner`
449      * modifier anymore.
450      * @notice Renouncing ownership will leave the contract without an owner,
451      * thereby removing any functionality that is only available to the owner.
452      */
453     function renounceOwnership() public onlyOwner {
454         emit OwnershipTransferred(_owner, address(0));
455         _owner = address(0);
456     }
457 
458     /**
459      * @dev Allows the current owner to transfer control of the contract to a newOwner.
460      * @param newOwner The address to transfer ownership to.
461      */
462     function transferOwnership(address newOwner) public onlyOwner {
463         _transferOwnership(newOwner);
464     }
465 
466     /**
467      * @dev Transfers control of the contract to a newOwner.
468      * @param newOwner The address to transfer ownership to.
469      */
470     function _transferOwnership(address newOwner) internal {
471         require(newOwner != address(0), "Ownable: new owner is the zero address");
472         emit OwnershipTransferred(_owner, newOwner);
473         _owner = newOwner;
474     }
475 }
476 
477 /**
478  * @title TokenVesting
479  * @dev A token holder contract that can release its token balance gradually like a
480  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
481  * owner.
482  */
483 contract TokenVesting is Ownable {
484     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
485     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
486     // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a
487     // cliff period of a year and a duration of four years, are safe to use.
488     // solhint-disable not-rely-on-time
489 
490     using SafeMath for uint256;
491     using SafeERC20 for IERC20;
492 
493     event TokensReleased(address token, uint256 amount);
494     event TokenVestingRevoked(address token);
495 
496     // beneficiary of tokens after they are released
497     address private _beneficiary;
498 
499     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
500     uint256 private _cliff;
501     uint256 private _start;
502     uint256 private _duration;
503 
504     bool private _revocable;
505 
506     mapping (address => uint256) private _released;
507     mapping (address => bool) private _revoked;
508 
509     /**
510      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
511      * beneficiary, gradually in a linear fashion until start + duration. By then all
512      * of the balance will have vested.
513      * @param beneficiary address of the beneficiary to whom vested tokens are transferred
514      * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
515      * @param start the time (as Unix time) at which point vesting starts
516      * @param duration duration in seconds of the period in which the tokens will vest
517      * @param revocable whether the vesting is revocable or not
518      */
519     constructor (address beneficiary, uint256 start, uint256 cliffDuration, uint256 duration, bool revocable) public {
520         require(beneficiary != address(0), "TokenVesting: beneficiary is the zero address");
521         // solhint-disable-next-line max-line-length
522         require(cliffDuration <= duration, "TokenVesting: cliff is longer than duration");
523         require(duration > 0, "TokenVesting: duration is 0");
524         // solhint-disable-next-line max-line-length
525         require(start.add(duration) > block.timestamp, "TokenVesting: final time is before current time");
526 
527         _beneficiary = beneficiary;
528         _revocable = revocable;
529         _duration = duration;
530         _cliff = start.add(cliffDuration);
531         _start = start;
532     }
533 
534     /**
535      * @return the beneficiary of the tokens.
536      */
537     function beneficiary() public view returns (address) {
538         return _beneficiary;
539     }
540 
541     /**
542      * @return the cliff time of the token vesting.
543      */
544     function cliff() public view returns (uint256) {
545         return _cliff;
546     }
547 
548     /**
549      * @return the start time of the token vesting.
550      */
551     function start() public view returns (uint256) {
552         return _start;
553     }
554 
555     /**
556      * @return the duration of the token vesting.
557      */
558     function duration() public view returns (uint256) {
559         return _duration;
560     }
561 
562     /**
563      * @return true if the vesting is revocable.
564      */
565     function revocable() public view returns (bool) {
566         return _revocable;
567     }
568 
569     /**
570      * @return the amount of the token released.
571      */
572     function released(address token) public view returns (uint256) {
573         return _released[token];
574     }
575 
576     /**
577      * @return true if the token is revoked.
578      */
579     function revoked(address token) public view returns (bool) {
580         return _revoked[token];
581     }
582 
583     /**
584      * @notice Transfers vested tokens to beneficiary.
585      * @param token ERC20 token which is being vested
586      */
587     function release(IERC20 token) public {
588         uint256 unreleased = _releasableAmount(token);
589 
590         require(unreleased > 0, "TokenVesting: no tokens are due");
591 
592         _released[address(token)] = _released[address(token)].add(unreleased);
593 
594         token.safeTransfer(_beneficiary, unreleased);
595 
596         emit TokensReleased(address(token), unreleased);
597     }
598 
599     /**
600      * @notice Allows the owner to revoke the vesting. Tokens already vested
601      * remain in the contract, the rest are returned to the owner.
602      * @param token ERC20 token which is being vested
603      */
604     function revoke(IERC20 token) public onlyOwner {
605         require(_revocable, "TokenVesting: cannot revoke");
606         require(!_revoked[address(token)], "TokenVesting: token already revoked");
607 
608         uint256 balance = token.balanceOf(address(this));
609 
610         uint256 unreleased = _releasableAmount(token);
611         uint256 refund = balance.sub(unreleased);
612 
613         _revoked[address(token)] = true;
614 
615         token.safeTransfer(owner(), refund);
616 
617         emit TokenVestingRevoked(address(token));
618     }
619 
620     /**
621      * @dev Calculates the amount that has already vested but hasn't been released yet.
622      * @param token ERC20 token which is being vested
623      */
624     function _releasableAmount(IERC20 token) private view returns (uint256) {
625         return _vestedAmount(token).sub(_released[address(token)]);
626     }
627 
628     /**
629      * @dev Calculates the amount that has already vested.
630      * @param token ERC20 token which is being vested
631      */
632     function _vestedAmount(IERC20 token) private view returns (uint256) {
633         uint256 currentBalance = token.balanceOf(address(this));
634         uint256 totalBalance = currentBalance.add(_released[address(token)]);
635 
636         if (block.timestamp < _cliff) {
637             return 0;
638         } else if (block.timestamp >= _start.add(_duration) || _revoked[address(token)]) {
639             return totalBalance;
640         } else {
641             return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
642         }
643     }
644 }
645 
646 contract TapToken is ERC20Detailed, Ownable {
647     address public tapTokensAddress;
648 
649     TokenVesting public teamTokensVesting;
650 
651     bool public tokenSaleClosed = false;
652 
653     modifier beforeEnd {
654         assert(!tokenSaleClosed);
655         _;
656     }
657 
658     constructor(address _tapTokensAddress) public ERC20Detailed("Tap", "XTP", 18) {
659         require(_tapTokensAddress != address(0));
660 
661         tapTokensAddress = _tapTokensAddress;
662 
663         teamTokensVesting = new TokenVesting(tapTokensAddress, now + 91 days, 0 days, 274 days, false);
664 
665         // 3B tokens (= 790M seed + 2.21B private)
666         _mint(tapTokensAddress, 3000000000 * (10 ** uint256(decimals())));
667 
668         // 7B tokens (= 1.17B marketing + 2.58B reserve + 1.2B development + 500M bounty + 1.55 team&advisors)
669         _mint(address(teamTokensVesting), 7000000000 * (10 ** uint256(decimals())));
670 
671         require(totalSupply() == 10000000000 * 10**uint256(decimals()));
672     }
673 
674     function closeSale() beforeEnd onlyOwner public {
675         tokenSaleClosed = true;
676     }
677 
678     function burn(uint256 value) public {
679         super._burn(msg.sender, value);
680     }
681 }