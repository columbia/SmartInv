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
69 * @title Contract that will work with ERC223 tokens.
70 */
71 
72 contract ERC223ReceivingContract {
73     /**
74      * @dev Standard ERC223 function that will handle incoming token transfers.
75      *
76      * @param _from  Token sender address.
77      * @param _value Amount of tokens.
78      * @param _data  Transaction metadata.
79      */
80     function tokenFallback(address _from, uint _value, bytes memory _data) public;
81 }
82 
83 
84 contract IERC223 {
85     /* IERC20 */
86     function approve(address spender, uint256 value) public returns (bool);
87     function transferFrom(address from, address to, uint256 value) public returns (bool);
88     function totalSupply() public view returns (uint256);
89     function balanceOf(address who) public view returns (uint256);
90     function allowance(address owner, address spender) public view returns (uint256);
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93 
94     /* IERC223 */
95     function transfer(address to, uint256 value) public returns (bool);
96     function transfer(address to, uint256 value, bytes memory data) public returns (bool);
97     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
98 }
99 
100 
101 /**
102  * @title Roles
103  * @dev Library for managing addresses assigned to a Role.
104  */
105 library Roles {
106     struct Role {
107         mapping (address => bool) bearer;
108     }
109 
110     /**
111      * @dev give an account access to this role
112      */
113     function add(Role storage role, address account) internal {
114         require(account != address(0));
115         require(!has(role, account));
116 
117         role.bearer[account] = true;
118     }
119 
120     /**
121      * @dev remove an account's access to this role
122      */
123     function remove(Role storage role, address account) internal {
124         require(account != address(0));
125         require(has(role, account));
126 
127         role.bearer[account] = false;
128     }
129 
130     /**
131      * @dev check if an account has this role
132      * @return bool
133      */
134     function has(Role storage role, address account) internal view returns (bool) {
135         require(account != address(0));
136         return role.bearer[account];
137     }
138 }
139 
140 
141 
142 
143 contract BurnerRole {
144     using Roles for Roles.Role;
145 
146     event BurnerAdded(address indexed account);
147     event BurnerRemoved(address indexed account);
148 
149     Roles.Role private _burners;
150 
151     constructor () internal {
152         _addBurner(msg.sender);
153     }
154 
155     modifier onlyBurner() {
156         require(isBurner(msg.sender));
157         _;
158     }
159 
160     function isBurner(address account) public view returns (bool) {
161         return _burners.has(account);
162     }
163 
164     function addBurner(address account) public onlyBurner {
165         _addBurner(account);
166     }
167 
168     function renounceBurner() public {
169         _removeBurner(msg.sender);
170     }
171 
172     function _addBurner(address account) internal {
173         _burners.add(account);
174         emit BurnerAdded(account);
175     }
176 
177     function _removeBurner(address account) internal {
178         _burners.remove(account);
179         emit BurnerRemoved(account);
180     }
181 }
182 
183 
184 
185 
186 
187 
188 
189 
190 
191 
192 /**
193  * @dev Collection of functions related to the address type,
194  */
195 library Address {
196     /**
197      * @dev Returns true if `account` is a contract.
198      *
199      * This test is non-exhaustive, and there may be false-negatives: during the
200      * execution of a contract's constructor, its address will be reported as
201      * not containing a contract.
202      *
203      * > It is unsafe to assume that an address for which this function returns
204      * false is an externally-owned account (EOA) and not a contract.
205      */
206     function isContract(address account) internal view returns (bool) {
207         // This method relies in extcodesize, which returns 0 for contracts in
208         // construction, since the code is only stored at the end of the
209         // constructor execution.
210 
211         uint256 size;
212         // solhint-disable-next-line no-inline-assembly
213         assembly { size := extcodesize(account) }
214         return size > 0;
215     }
216 }
217 
218 
219 /**
220  * @title SafeERC223
221  * @dev Wrappers around ERC223 operations that throw on failure (when the token
222  * contract returns false). Tokens that return no value (and instead revert or
223  * throw on failure) are also supported, non-reverting calls are assumed to be
224  * successful.
225  * To use this library you can add a `using SafeERC223 for ERC223;` statement to your contract,
226  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
227  */
228 library SafeERC223 {
229     using SafeMath for uint256;
230     using Address for address;
231 
232     function safeTransfer(IERC223 token, address to, uint256 value) internal {
233         //        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
234         require(token.transfer(to, value));
235     }
236 
237     function safeTransfer(IERC223 token, address to, uint256 value, bytes memory data) internal {
238         //        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value, data));
239         require(token.transfer(to, value, data));
240     }
241 
242     function safeTransferFrom(IERC223 token, address from, address to, uint256 value) internal {
243         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
244     }
245 
246     function safeApprove(IERC223 token, address spender, uint256 value) internal {
247         // safeApprove should only be called when setting an initial allowance,
248         // or when resetting it to zero. To increase and decrease it, use
249         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
250         // solhint-disable-next-line max-line-length
251         require((value == 0) || (token.allowance(address(this), spender) == 0),
252             "SafeERC223: approve from non-zero to non-zero allowance"
253         );
254         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
255     }
256 
257     function safeIncreaseAllowance(IERC223 token, address spender, uint256 value) internal {
258         uint256 newAllowance = token.allowance(address(this), spender).add(value);
259         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
260     }
261 
262     function safeDecreaseAllowance(IERC223 token, address spender, uint256 value) internal {
263         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
264         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
265     }
266 
267     /**
268      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
269      * on the return value: the return value is optional (but if data is returned, it must not be false).
270      * @param token The token targeted by the call.
271      * @param data The call data (encoded using abi.encode or one of its variants).
272      */
273     function callOptionalReturn(IERC223 token, bytes memory data) private {
274         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
275         // we're implementing it ourselves.
276 
277         // A Solidity high level call has three parts:
278         //  1. The target address is checked to verify it contains contract code
279         //  2. The call itself is made, and success asserted
280         //  3. The return value is decoded, which in turn checks the size of the returned data.
281         // solhint-disable-next-line max-line-length
282         require(address(token).isContract(), "SafeERC223: call to non-contract");
283 
284         // solhint-disable-next-line avoid-low-level-calls
285         (bool success, bytes memory returndata) = address(token).call(data);
286         require(success, "SafeERC223: low-level call failed");
287 
288         if (returndata.length > 0) { // Return data is optional
289             // solhint-disable-next-line max-line-length
290             require(abi.decode(returndata, (bool)), "SafeERC223: ERC223 operation did not succeed");
291         }
292     }
293 }
294 
295 
296 
297 /**
298  * @dev A token holder contract that will allow a beneficiary to extract the
299  * tokens after a given release time.
300  */
301 contract TokenTimelock is ERC223ReceivingContract {
302     using SafeERC223 for IERC223;
303 
304     // ERC20 basic token contract being held
305     IERC223 private _token;
306 
307     // beneficiary of tokens after they are released
308     address private _beneficiary;
309 
310     // timestamp when token release is enabled
311     uint256 private _releaseTime;
312 
313     constructor (IERC223 token, address beneficiary, uint256 releaseTime) public {
314         // solhint-disable-next-line not-rely-on-time
315         require(releaseTime > block.timestamp, "TokenTimelock: release time is before current time");
316         _token = token;
317         _beneficiary = beneficiary;
318         _releaseTime = releaseTime;
319     }
320 
321     /**
322      * @return the token being held.
323      */
324     function token() public view returns (IERC223) {
325         return _token;
326     }
327 
328     /**
329      * @return the beneficiary of the tokens.
330      */
331     function beneficiary() public view returns (address) {
332         return _beneficiary;
333     }
334 
335     /**
336      * @return the time when the tokens are released.
337      */
338     function releaseTime() public view returns (uint256) {
339         return _releaseTime;
340     }
341 
342     /**
343      * @notice Transfers tokens held by timelock to beneficiary.
344      */
345     function release() public {
346         // solhint-disable-next-line not-rely-on-time
347         require(block.timestamp >= _releaseTime, "TokenTimelock: current time is before release time");
348 
349         uint256 amount = _token.balanceOf(address(this));
350         require(amount > 0, "TokenTimelock: no tokens to release");
351 
352         _token.safeTransfer(_beneficiary, amount);
353     }
354 
355     /**
356      * Empty implementation
357      */
358     function tokenFallback(address /*_from*/, uint /*_value*/, bytes memory /*_data*/) public {
359         return;
360     }
361 }
362 
363 
364 
365 
366 
367 
368 
369 
370 
371 /**
372  * @title Reference implementation of the ERC223 standard token.
373  */
374 contract ERC223 is IERC223 {
375     using SafeMath for uint;
376     using SafeMath for uint256;
377     using Address for address;
378 
379     string private _name;
380     string private _symbol;
381     uint8 private _decimals;
382     uint256 private _totalSupply;
383 
384     mapping (address => uint256) private _balances;
385 
386     mapping (address => mapping (address => uint256)) private _allowed;
387 
388     constructor (string memory name, string memory symbol, uint8 decimals) public {
389         _name = name;
390         _symbol = symbol;
391         _decimals = decimals;
392     }
393 
394     /**
395      * @return the name of the token.
396      */
397     function name() public view returns (string memory) {
398         return _name;
399     }
400 
401     /**
402      * @return the symbol of the token.
403      */
404     function symbol() public view returns (string memory) {
405         return _symbol;
406     }
407 
408     /**
409      * @return the number of decimals of the token.
410      */
411     function decimals() public view returns (uint8) {
412         return _decimals;
413     }
414 
415     /**
416      * @dev Total number of tokens in existence
417      */
418     function totalSupply() public view returns (uint256) {
419         return _totalSupply;
420     }
421 
422     /**
423      * @dev Gets the balance of the specified address.
424      * @param owner The address to query the balance of.
425      * @return A uint256 representing the amount owned by the passed address.
426      */
427     function balanceOf(address owner) public view returns (uint256) {
428         return _balances[owner];
429     }
430 
431     /**
432      * @dev Function to check the amount of tokens that an owner allowed to a spender.
433      * @param owner address The address which owns the funds.
434      * @param spender address The address which will spend the funds.
435      * @return A uint256 specifying the amount of tokens still available for the spender.
436      */
437     function allowance(address owner, address spender) public view returns (uint256) {
438         return _allowed[owner][spender];
439     }
440 
441     /**
442     * @dev Transfer token for a specified address
443     * @param _to The address to transfer to.
444     * @param _value The amount to be transferred.
445     */
446     function transfer(address _to, uint256 _value) public returns (bool) {
447         bytes memory empty;
448         _transfer(msg.sender, _to, _value, empty);
449         return true;
450     }
451 
452 
453     /**
454      * @dev Transfer the specified amount of tokens to the specified address.
455      * Standard function transfer similar to ERC20 transfer with no _data .
456      * Added due to backwards compatibility reasons .
457      *
458      * @param _to    Receiver address.
459      * @param _value Amount of tokens that will be transferred.
460      * @param _data  Transaction metadata.
461      */
462     function transfer(address _to, uint256 _value, bytes memory _data) public returns (bool) {
463         _transfer(msg.sender, _to, _value, _data);
464         return true;
465     }
466 
467     /**
468      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
469      * Beware that changing an allowance with this method brings the risk that someone may use both the old
470      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
471      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
472      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
473      * @param spender The address which will spend the funds.
474      * @param value The amount of tokens to be spent.
475      */
476     function approve(address spender, uint256 value) public returns (bool) {
477         _approve(msg.sender, spender, value);
478         return true;
479     }
480 
481     /**
482      * @dev Transfer tokens from one address to another.
483      * Note that while this function emits an Approval event, this is not required as per the specification,
484      * and other compliant implementations may not emit the event.
485      * @param from address The address which you want to send tokens from
486      * @param to address The address which you want to transfer to
487      * @param value uint256 the amount of tokens to be transferred
488      */
489     function transferFrom(address from, address to, uint256 value) public returns (bool) {
490         bytes memory empty;
491         _transfer(from, to, value, empty);
492         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
493         return true;
494     }
495 
496     /**
497      * @dev Increase the amount of tokens that an owner allowed to a spender.
498      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
499      * allowed value is better to use this function to avoid 2 calls (and wait until
500      * the first transaction is mined)
501      * From MonolithDAO Token.sol
502      * Emits an Approval event.
503      * @param spender The address which will spend the funds.
504      * @param addedValue The amount of tokens to increase the allowance by.
505      */
506     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
507         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
508         return true;
509     }
510 
511     /**
512      * @dev Decrease the amount of tokens that an owner allowed to a spender.
513      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
514      * allowed value is better to use this function to avoid 2 calls (and wait until
515      * the first transaction is mined)
516      * From MonolithDAO Token.sol
517      * Emits an Approval event.
518      * @param spender The address which will spend the funds.
519      * @param subtractedValue The amount of tokens to decrease the allowance by.
520      */
521     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
522         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
523         return true;
524     }
525 
526 
527     /**
528      * @dev Transfer the specified amount of tokens to the specified address.
529      *      Invokes the `tokenFallback` function if the recipient is a contract.
530      *      The token transfer fails if the recipient is a contract
531      *      but does not implement the `tokenFallback` function
532      *      or the fallback function to receive funds.
533      *
534      * @param _to    Receiver address.
535      * @param _value Amount of tokens that will be transferred.
536      * @param _data  Transaction metadata.
537      */
538     function _transfer(address _from, address _to, uint256 _value, bytes memory _data) internal {
539         _balances[_from] = _balances[_from].sub(_value);
540         _balances[_to] = _balances[_to].add(_value);
541 
542         if (_to.isContract()) {
543             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
544             receiver.tokenFallback(_from, _value, _data);
545         }
546 
547         emit Transfer(_from, _to, _value, _data);
548         emit Transfer(_from, _to, _value);
549     }
550 
551     /**
552      * @dev Internal function that mints an amount of the token and assigns it to
553      * an account. This encapsulates the modification of balances such that the
554      * proper events are emitted.
555      * @param account The account that will receive the created tokens.
556      * @param value The amount that will be created.
557      */
558     function _mint(address account, uint256 value) internal {
559         require(account != address(0));
560 
561         _totalSupply = _totalSupply.add(value);
562         _balances[account] = _balances[account].add(value);
563 
564         bytes memory empty;
565 
566         if (account.isContract()) {
567             ERC223ReceivingContract receiver = ERC223ReceivingContract(account);
568             receiver.tokenFallback(address(0), value, empty);
569         }
570 
571         emit Transfer(address(0), account, value, empty);
572         emit Transfer(address(0), account, value);
573     }
574 
575     /**
576      * @dev Internal function that burns an amount of the token of a given
577      * account.
578      * @param account The account whose tokens will be burnt.
579      * @param value The amount that will be burnt.
580      */
581     function _burn(address account, uint256 value) internal {
582         require(account != address(0));
583 
584         _totalSupply = _totalSupply.sub(value);
585         _balances[account] = _balances[account].sub(value);
586 
587         bytes memory empty;
588         emit Transfer(account, address(0), value, empty);
589         emit Transfer(account, address(0), value);
590     }
591 
592     /**
593      * @dev Internal function that burns an amount of the token of a given
594      * account, deducting from the sender's allowance for said account. Uses the
595      * internal burn function.
596      * Emits an Approval event (reflecting the reduced allowance).
597      * @param account The account whose tokens will be burnt.
598      * @param value The amount that will be burnt.
599      */
600     function _burnFrom(address account, uint256 value) internal {
601         _burn(account, value);
602         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
603     }
604 
605     /**
606      * @dev Approve an address to spend another addresses' tokens.
607      * @param owner The address that owns the tokens.
608      * @param spender The address that will spend the tokens.
609      * @param value The number of tokens that can be spent.
610      */
611     function _approve(address owner, address spender, uint256 value) internal {
612         require(spender != address(0));
613         require(owner != address(0));
614 
615         _allowed[owner][spender] = value;
616         emit Approval(owner, spender, value);
617     }
618 
619 }
620 
621 
622 
623 contract BcnxToken is ERC223, BurnerRole {
624     string private constant NAME = "Bcnex Token";
625     string private constant SYMBOL = "BCNX";
626     uint8 private constant DECIMALS = 18;
627     uint256 private constant TOTAL_SUPPLY = 200 * (10 ** 6) * (10 ** uint256(DECIMALS));
628 
629 
630     constructor()
631     ERC223(NAME, SYMBOL, DECIMALS)
632     public {
633         _mint(msg.sender, TOTAL_SUPPLY);
634     }
635 
636     /**
637        * @dev Burns a specific amount of tokens.
638        * @param value The amount of token to be burned.
639        */
640     function burn(uint256 value) public onlyBurner {
641         _burn(msg.sender, value);
642     }
643 
644     /**
645      * @dev Burns a specific amount of tokens from the target address and decrements allowance
646      * @param from address The address which you want to send tokens from
647      * @param value uint256 The amount of token to be burned
648      */
649     function burnFrom(address from, uint256 value) public onlyBurner {
650         _burnFrom(from, value);
651     }
652 }
653 
654 contract BcnxDistribution {
655     using SafeMath for uint256;
656 
657     event NewTimeLock(address addr, BcnxToken _token, address _beneficiary, uint256 _releaseTime);
658 
659     BcnxToken public token;
660     uint256 private constant TEAM_TOKENS = 76 * (10 ** 6) * (10 ** uint256(18));
661     uint256 [] public LOCK_END = [
662     1577750400, // Tue, 31 Dec 2019 00:00:00 GMT
663     1609372800, // Thu, 31 Dec 2020 00:00:00 GMT
664     1640908800, // Fri, 31 Dec 2021 00:00:00 GMT
665     1672444800  // Sat, 31 Dec 2022 00:00:00 GMT
666     ];
667 
668     constructor () public {
669         // create the Bcnx Token contract
670         token = new BcnxToken();
671 
672         // create timelocks for tokens
673         uint256 AMOUNT_PER_RELEASE = TEAM_TOKENS.div(LOCK_END.length);
674         for (uint i = 0; i < LOCK_END.length; i++) {
675             uint256 releaseTime = LOCK_END[i];
676             TokenTimelock timelock = new TokenTimelock(token, msg.sender, releaseTime);
677             token.transfer(address(timelock), AMOUNT_PER_RELEASE);
678             emit NewTimeLock(address(timelock), token, msg.sender, releaseTime);
679         }
680 
681         // send all remaining tokens to wallet
682         uint256 remainingBalance = token.balanceOf(address(this));
683         token.transfer(msg.sender, remainingBalance);
684 
685         // add the contract owner as a Burner
686         token.addBurner(msg.sender);
687     }
688 }