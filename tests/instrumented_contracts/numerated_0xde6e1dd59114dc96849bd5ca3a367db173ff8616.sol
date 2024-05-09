1 pragma solidity 0.5.6;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library Address {
7     /**
8      * Returns whether the target address is a contract
9      * @dev This function will return false if invoked during the constructor of a contract,
10      * as the code is not actually created until after the constructor finishes.
11      * @param account address of the account to check
12      * @return whether the target address is a contract
13      */
14     function isContract(address account) internal view returns (bool) {
15         uint256 size;
16         // XXX Currently there is no better way to check if there is a contract in an address
17         // than to check the size of the code at that address.
18         // See https://ethereum.stackexchange.com/a/14016/36603
19         // for more details about how this works.
20         // TODO Check this again before the Serenity release, because all addresses will be
21         // contracts then.
22         // solhint-disable-next-line no-inline-assembly
23         assembly { size := extcodesize(account) }
24         return size > 0;
25     }
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Unsigned math operations with safety checks that revert on error
31  */
32 library SafeMath {
33     /**
34      * @dev Multiplies two unsigned integers, reverts on overflow.
35      */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b);
46 
47         return c;
48     }
49 
50     /**
51      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
52      */
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Solidity only automatically asserts when dividing by 0
55         require(b > 0);
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     /**
63      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64      */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b <= a);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73      * @dev Adds two unsigned integers, reverts on overflow.
74      */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a);
78 
79         return c;
80     }
81 
82     /**
83      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
84      * reverts when dividing by zero.
85      */
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         require(b != 0);
88         return a % b;
89     }
90 }
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure (when the token
95  * contract returns false). Tokens that return no value (and instead revert or
96  * throw on failure) are also supported, non-reverting calls are assumed to be
97  * successful.
98  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
99  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
100  */
101 library SafeERC20 {
102     using SafeMath for uint256;
103     using Address for address;
104 
105     function safeTransfer(IERC20 token, address to, uint256 value) internal {
106         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
107     }
108 
109     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
110         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
111     }
112 
113     function safeApprove(IERC20 token, address spender, uint256 value) internal {
114         // safeApprove should only be called when setting an initial allowance,
115         // or when resetting it to zero. To increase and decrease it, use
116         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
117         require((value == 0) || (token.allowance(address(this), spender) == 0));
118         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
119     }
120 
121     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
122         uint256 newAllowance = token.allowance(address(this), spender).add(value);
123         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
124     }
125 
126     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
127         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
128         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
129     }
130 
131     /**
132      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
133      * on the return value: the return value is optional (but if data is returned, it must equal true).
134      * @param token The token targeted by the call.
135      * @param data The call data (encoded using abi.encode or one of its variants).
136      */
137     function callOptionalReturn(IERC20 token, bytes memory data) private {
138         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
139         // we're implementing it ourselves.
140 
141         // A Solidity high level call has three parts:
142         //  1. The target address is checked to verify it contains contract code
143         //  2. The call itself is made, and success asserted
144         //  3. The return value is decoded, which in turn checks the size of the returned data.
145 
146         require(address(token).isContract());
147 
148         // solhint-disable-next-line avoid-low-level-calls
149         (bool success, bytes memory returndata) = address(token).call(data);
150         require(success);
151 
152         if (returndata.length > 0) { // Return data is optional
153             require(abi.decode(returndata, (bool)));
154         }
155     }
156 }
157 
158 /**
159  * @title Ownable
160  * @dev The Ownable contract has an owner address, and provides basic authorization control
161  * functions, this simplifies the implementation of "user permissions".
162  */
163 contract Ownable {
164     address private _owner;
165 
166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167 
168     /**
169      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
170      * account.
171      */
172     constructor () internal {
173         _owner = msg.sender;
174         emit OwnershipTransferred(address(0), _owner);
175     }
176 
177     /**
178      * @return the address of the owner.
179      */
180     function owner() public view returns (address) {
181         return _owner;
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         require(isOwner());
189         _;
190     }
191 
192     /**
193      * @return true if `msg.sender` is the owner of the contract.
194      */
195     function isOwner() public view returns (bool) {
196         return msg.sender == _owner;
197     }
198 
199     /**
200      * @dev Allows the current owner to relinquish control of the contract.
201      * It will not be possible to call the functions with the `onlyOwner`
202      * modifier anymore.
203      * @notice Renouncing ownership will leave the contract without an owner,
204      * thereby removing any functionality that is only available to the owner.
205      */
206     function renounceOwnership() public onlyOwner {
207         emit OwnershipTransferred(_owner, address(0));
208         _owner = address(0);
209     }
210 
211     /**
212      * @dev Allows the current owner to transfer control of the contract to a newOwner.
213      * @param newOwner The address to transfer ownership to.
214      */
215     function transferOwnership(address newOwner) public onlyOwner {
216         _transferOwnership(newOwner);
217     }
218 
219     /**
220      * @dev Transfers control of the contract to a newOwner.
221      * @param newOwner The address to transfer ownership to.
222      */
223     function _transferOwnership(address newOwner) internal {
224         require(newOwner != address(0));
225         emit OwnershipTransferred(_owner, newOwner);
226         _owner = newOwner;
227     }
228 }
229 
230 /**
231  * @title ERC20 interface
232  * @dev see https://eips.ethereum.org/EIPS/eip-20
233  */
234 interface IERC20 {
235     function transfer(address to, uint256 value) external returns (bool);
236 
237     function approve(address spender, uint256 value) external returns (bool);
238 
239     function transferFrom(address from, address to, uint256 value) external returns (bool);
240 
241     function totalSupply() external view returns (uint256);
242 
243     function balanceOf(address who) external view returns (uint256);
244 
245     function allowance(address owner, address spender) external view returns (uint256);
246 
247     function transferOwnership(address newOwner) external;
248 
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     event Approval(address indexed owner, address indexed spender, uint256 value);
252 }
253 
254 /**
255  * @title Standard ERC20 token
256  *
257  * @dev Implementation of the basic standard token.
258  * https://eips.ethereum.org/EIPS/eip-20
259  * Originally based on code by FirstBlood:
260  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
261  *
262  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
263  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
264  * compliant implementations may not do it.
265  */
266 contract ERC20 is IERC20 {
267     using SafeMath for uint256;
268 
269     mapping (address => uint256) private _balances;
270 
271     mapping (address => mapping (address => uint256)) private _allowed;
272 
273     uint256 private _totalSupply;
274 
275     /**
276      * @dev Total number of tokens in existence
277      */
278     function totalSupply() public view returns (uint256) {
279         return _totalSupply;
280     }
281 
282     /**
283      * @dev Gets the balance of the specified address.
284      * @param owner The address to query the balance of.
285      * @return A uint256 representing the amount owned by the passed address.
286      */
287     function balanceOf(address owner) public view returns (uint256) {
288         return _balances[owner];
289     }
290 
291     /**
292      * @dev Function to check the amount of tokens that an owner allowed to a spender.
293      * @param owner address The address which owns the funds.
294      * @param spender address The address which will spend the funds.
295      * @return A uint256 specifying the amount of tokens still available for the spender.
296      */
297     function allowance(address owner, address spender) public view returns (uint256) {
298         return _allowed[owner][spender];
299     }
300 
301     /**
302      * @dev Transfer token to a specified address
303      * @param to The address to transfer to.
304      * @param value The amount to be transferred.
305      */
306     function transfer(address to, uint256 value) public returns (bool) {
307         _transfer(msg.sender, to, value);
308         return true;
309     }
310 
311     /**
312      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
313      * Beware that changing an allowance with this method brings the risk that someone may use both the old
314      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
315      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
316      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
317      * @param spender The address which will spend the funds.
318      * @param value The amount of tokens to be spent.
319      */
320     function approve(address spender, uint256 value) public returns (bool) {
321         _approve(msg.sender, spender, value);
322         return true;
323     }
324 
325     /**
326      * @dev Transfer tokens from one address to another.
327      * Note that while this function emits an Approval event, this is not required as per the specification,
328      * and other compliant implementations may not emit the event.
329      * @param from address The address which you want to send tokens from
330      * @param to address The address which you want to transfer to
331      * @param value uint256 the amount of tokens to be transferred
332      */
333     function transferFrom(address from, address to, uint256 value) public returns (bool) {
334         _transfer(from, to, value);
335         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
336         return true;
337     }
338 
339     /**
340      * @dev Increase the amount of tokens that an owner allowed to a spender.
341      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
342      * allowed value is better to use this function to avoid 2 calls (and wait until
343      * the first transaction is mined)
344      * From MonolithDAO Token.sol
345      * Emits an Approval event.
346      * @param spender The address which will spend the funds.
347      * @param addedValue The amount of tokens to increase the allowance by.
348      */
349     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
350         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
351         return true;
352     }
353 
354     /**
355      * @dev Decrease the amount of tokens that an owner allowed to a spender.
356      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
357      * allowed value is better to use this function to avoid 2 calls (and wait until
358      * the first transaction is mined)
359      * From MonolithDAO Token.sol
360      * Emits an Approval event.
361      * @param spender The address which will spend the funds.
362      * @param subtractedValue The amount of tokens to decrease the allowance by.
363      */
364     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
365         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
366         return true;
367     }
368 
369     /**
370      * @dev Transfer token for a specified addresses
371      * @param from The address to transfer from.
372      * @param to The address to transfer to.
373      * @param value The amount to be transferred.
374      */
375     function _transfer(address from, address to, uint256 value) internal {
376         require(to != address(0));
377 
378         _balances[from] = _balances[from].sub(value);
379         _balances[to] = _balances[to].add(value);
380         emit Transfer(from, to, value);
381     }
382 
383     /**
384      * @dev Internal function that mints an amount of the token and assigns it to
385      * an account. This encapsulates the modification of balances such that the
386      * proper events are emitted.
387      * @param account The account that will receive the created tokens.
388      * @param value The amount that will be created.
389      */
390     function _mint(address account, uint256 value) internal {
391         require(account != address(0));
392 
393         _totalSupply = _totalSupply.add(value);
394         _balances[account] = _balances[account].add(value);
395         emit Transfer(address(0), account, value);
396     }
397 
398     /**
399      * @dev Internal function that burns an amount of the token of a given
400      * account.
401      * @param account The account whose tokens will be burnt.
402      * @param value The amount that will be burnt.
403      */
404     function _burn(address account, uint256 value) internal {
405         require(account != address(0));
406 
407         _totalSupply = _totalSupply.sub(value);
408         _balances[account] = _balances[account].sub(value);
409         emit Transfer(account, address(0), value);
410     }
411 
412     /**
413      * @dev Approve an address to spend another addresses' tokens.
414      * @param owner The address that owns the tokens.
415      * @param spender The address that will spend the tokens.
416      * @param value The number of tokens that can be spent.
417      */
418     function _approve(address owner, address spender, uint256 value) internal {
419         require(spender != address(0));
420         require(owner != address(0));
421 
422         _allowed[owner][spender] = value;
423         emit Approval(owner, spender, value);
424     }
425 
426     /**
427      * @dev Internal function that burns an amount of the token of a given
428      * account, deducting from the sender's allowance for said account. Uses the
429      * internal burn function.
430      * Emits an Approval event (reflecting the reduced allowance).
431      * @param account The account whose tokens will be burnt.
432      * @param value The amount that will be burnt.
433      */
434     function _burnFrom(address account, uint256 value) internal {
435         _burn(account, value);
436         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
437     }
438 }
439 
440 /**
441  * @title Burnable Token
442  * @dev Token that can be irreversibly burned (destroyed).
443  */
444 contract ERC20Burnable is ERC20 {
445     /**
446      * @dev Burns a specific amount of tokens.
447      * @param value The amount of token to be burned.
448      */
449     function burn(uint256 value) public {
450         _burn(msg.sender, value);
451     }
452 
453     /**
454      * @dev Burns a specific amount of tokens from the target address and decrements allowance
455      * @param from address The account whose tokens will be burned.
456      * @param value uint256 The amount of token to be burned.
457      */
458     function burnFrom(address from, uint256 value) public {
459         _burnFrom(from, value);
460     }
461 }
462 
463 /**
464  * @title Pausable
465  * @dev Base contract which allows children to implement an emergency stop mechanism.
466  */
467 contract Pausable is Ownable {
468     event Paused(address account);
469     event Unpaused(address account);
470 
471     bool private _paused;
472 
473     constructor () internal {
474         _paused = false;
475     }
476 
477     /**
478      * @return true if the contract is paused, false otherwise.
479      */
480     function paused() public view returns (bool) {
481         return _paused;
482     }
483 
484     /**
485      * @dev Modifier to make a function callable only when the contract is not paused.
486      */
487     modifier whenNotPaused() {
488         require(!_paused);
489         _;
490     }
491 
492     /**
493      * @dev Modifier to make a function callable only when the contract is paused.
494      */
495     modifier whenPaused() {
496         require(_paused);
497         _;
498     }
499 
500     /**
501      * @dev called by the owner to pause, triggers stopped state
502      */
503     function pause() public onlyOwner whenNotPaused {
504         _paused = true;
505         emit Paused(msg.sender);
506     }
507 
508     /**
509      * @dev called by the owner to unpause, returns to normal state
510      */
511     function unpause() public onlyOwner whenPaused {
512         _paused = false;
513         emit Unpaused(msg.sender);
514     }
515 }
516 
517 /**
518  * @title Pausable token
519  * @dev ERC20 modified with pausable transfers.
520  */
521 contract ERC20Pausable is ERC20, Pausable {
522     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
523         return super.transfer(to, value);
524     }
525 
526     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
527         return super.transferFrom(from, to, value);
528     }
529 
530     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
531         return super.approve(spender, value);
532     }
533 
534     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
535         return super.increaseAllowance(spender, addedValue);
536     }
537 
538     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
539         return super.decreaseAllowance(spender, subtractedValue);
540     }
541 }
542 
543 /**
544  * @title FreezableToken
545  */
546 contract ERC20Freezable is ERC20, Ownable {
547     mapping(address => bool) public frozenAccounts;
548     event FrozenFunds(address target, bool frozen);
549 
550     function freezeAccount(address target) public onlyOwner {
551         frozenAccounts[target] = true;
552         emit FrozenFunds(target, true);
553     }
554 
555     function unFreezeAccount(address target) public onlyOwner {
556         frozenAccounts[target] = false;
557         emit FrozenFunds(target, false);
558     }
559 
560     function frozen(address _target) view public returns(bool) {
561         return frozenAccounts[_target];
562     }
563 
564     // @dev Limit token transfer if _sender is frozen.
565     modifier canTransfer(address _sender) {
566         require(!frozenAccounts[_sender]);
567         _;
568     }
569 
570     function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns(bool success) {
571         // Call StandardToken.transfer()
572         return super.transfer(_to, _value);
573     }
574 
575     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns(bool success) {
576         // Call StandardToken.transferForm()
577         return super.transferFrom(_from, _to, _value);
578     }
579 }
580 
581 /**
582  * @title AirSaveTravelToken
583  */
584 contract AirSaveTravelTokens is ERC20Freezable, ERC20Pausable, ERC20Burnable {
585     string private constant _name = "AirSaveTravel Tokens";
586     string private constant _symbol = "ASTC";
587     uint8 private constant _decimals = 18;
588 
589     /**
590      * @dev AirSaveTravelToken constructor method
591      */
592     constructor () public {
593         //sending 35 mln  tokens to the main wallet
594         //the number of tokens is fixed and cannot be minted in future
595         _mint(msg.sender, 35000000 * 1 ether);
596     }
597 
598     /**
599      * @return the name of the token.
600      */
601     function name() public pure returns (string memory) {
602         return _name;
603     }
604 
605     /**
606      * @return the symbol of the token.
607      */
608     function symbol() public pure returns (string memory) {
609         return _symbol;
610     }
611 
612     /**
613      * @return the number of decimals of the token.
614      */
615     function decimals() public pure returns (uint8) {
616         return _decimals;
617     }
618 }
619 
620 /**
621  * @title Helps contracts guard against reentrancy attacks.
622  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
623  * @dev If you mark a function `nonReentrant`, you should also
624  * mark it `external`.
625  */
626 contract ReentrancyGuard {
627     /// @dev counter to allow mutex lock with only one SSTORE operation
628     uint256 private _guardCounter;
629 
630     constructor () internal {
631         // The counter starts at one to prevent changing it from zero to a non-zero
632         // value, which is a more expensive operation.
633         _guardCounter = 1;
634     }
635 
636     /**
637      * @dev Prevents a contract from calling itself, directly or indirectly.
638      * Calling a `nonReentrant` function from another `nonReentrant`
639      * function is not supported. It is possible to prevent this from happening
640      * by making the `nonReentrant` function external, and make it call a
641      * `private` function that does the actual work.
642      */
643     modifier nonReentrant() {
644         _guardCounter += 1;
645         uint256 localCounter = _guardCounter;
646         _;
647         require(localCounter == _guardCounter);
648     }
649 }
650 
651 /**
652  * @title Crowdsale
653  * @dev Crowdsale is a base contract for managing a token crowdsale,
654  * allowing investors to purchase tokens with ether. This contract implements
655  * such functionality in its most fundamental form and can be extended to provide additional
656  * functionality and/or custom behavior.
657  * The external interface represents the basic interface for purchasing tokens, and conform
658  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
659  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
660  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
661  * behavior.
662  */
663 contract Crowdsale is ReentrancyGuard {
664     using SafeMath for uint256;
665     using SafeERC20 for IERC20;
666 
667     // The token being sold
668     IERC20 private _token;
669 
670     // Address where funds are collected
671     address payable private _wallet;
672 
673     // 1 ETH = 750 ASTC
674     uint256 private _rate = 750;
675 
676     // Amount of wei raised
677     uint256 private _weiRaised;
678 
679     /**
680      * Event for token purchase logging
681      * @param purchaser who paid for the tokens
682      * @param beneficiary who got the tokens
683      * @param value weis paid for purchase
684      * @param amount amount of tokens purchased
685      */
686     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
687 
688     constructor () public {
689         _wallet = msg.sender;
690         _token = IERC20(new AirSaveTravelTokens());
691         _token.safeTransfer(_wallet, 29750000000 * 1 finney); //29,75 mln tokens to owner
692         _token.transferOwnership(_wallet);
693     }
694 
695     /**
696      * @dev fallback function ***DO NOT OVERRIDE***
697      * Note that other contracts will transfer fund with a base gas stipend
698      * of 2300, which is not enough to call buyTokens. Consider calling
699      * buyTokens directly when purchasing tokens from a contract.
700      */
701     function () external payable {
702         buyTokens(msg.sender);
703     }
704 
705     /**
706      * @return the token being sold.
707      */
708     function token() public view returns (IERC20) {
709         return _token;
710     }
711 
712     /**
713      * @return the address where funds are collected.
714      */
715     function wallet() public view returns (address payable) {
716         return _wallet;
717     }
718 
719     /**
720      * @return the number of token units a buyer gets per wei.
721      */
722     function rate() public view returns (uint256) {
723         return _rate;
724     }
725 
726     /**
727      * @return the amount of wei raised.
728      */
729     function weiRaised() public view returns (uint256) {
730         return _weiRaised;
731     }
732 
733     /**
734      * @dev low level token purchase ***DO NOT OVERRIDE***
735      * This function has a non-reentrancy guard, so it shouldn't be called by
736      * another `nonReentrant` function.
737      * @param beneficiary Recipient of the token purchase
738      */
739     function buyTokens(address beneficiary) public nonReentrant payable {
740         uint256 weiAmount = msg.value;
741         _preValidatePurchase(beneficiary, weiAmount);
742 
743         // calculate token amount to be created
744         uint256 tokens = _getTokenAmount(weiAmount);
745 
746         require(_token.balanceOf(address(this)) >= tokens, "buyTokens:the contract has not enough token balance for purchasing");
747 
748         // update state
749         _weiRaised = _weiRaised.add(weiAmount);
750 
751         _processPurchase(beneficiary, tokens);
752         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
753 
754         _forwardFunds();
755     }
756 
757     function changeWallet(address payable newWallet) external {
758         require(newWallet != address(0), "changeWallet: invalid wallet address");
759         require(msg.sender == _wallet, "changeWallet: only current wallet can change it");
760 
761         _wallet = newWallet;
762     }
763 
764     /**
765      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
766      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
767      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
768      *     super._preValidatePurchase(beneficiary, weiAmount);
769      *     require(weiRaised().add(weiAmount) <= cap);
770      * @param beneficiary Address performing the token purchase
771      * @param weiAmount Value in wei involved in the purchase
772      */
773     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
774         require(beneficiary != address(0));
775         require(weiAmount != 0);
776     }
777 
778     /**
779      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
780      * its tokens.
781      * @param beneficiary Address performing the token purchase
782      * @param tokenAmount Number of tokens to be emitted
783      */
784     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
785         _token.safeTransfer(beneficiary, tokenAmount);
786     }
787 
788     /**
789      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
790      * tokens.
791      * @param beneficiary Address receiving the tokens
792      * @param tokenAmount Number of tokens to be purchased
793      */
794     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
795         _deliverTokens(beneficiary, tokenAmount);
796     }
797 
798     /**
799      * @dev Override to extend the way in which ether is converted to tokens.
800      * @param weiAmount Value in wei to be converted into tokens
801      * @return Number of tokens that can be purchased with the specified _weiAmount
802      */
803     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
804         return weiAmount.mul(_rate);
805     }
806 
807     /**
808      * @dev Determines how ETH is stored/forwarded on purchases.
809      */
810     function _forwardFunds() internal {
811         _wallet.transfer(msg.value);
812     }
813 }
814 
815 /**
816  * @title Roles
817  * @dev Library for managing addresses assigned to a Role.
818  */
819 library Roles {
820     struct Role {
821         mapping (address => bool) bearer;
822     }
823 
824     /**
825      * @dev give an account access to this role
826      */
827     function add(Role storage role, address account) internal {
828         require(account != address(0));
829         require(!has(role, account));
830 
831         role.bearer[account] = true;
832     }
833 
834     /**
835      * @dev remove an account's access to this role
836      */
837     function remove(Role storage role, address account) internal {
838         require(account != address(0));
839         require(has(role, account));
840 
841         role.bearer[account] = false;
842     }
843 
844     /**
845      * @dev check if an account has this role
846      * @return bool
847      */
848     function has(Role storage role, address account) internal view returns (bool) {
849         require(account != address(0));
850         return role.bearer[account];
851     }
852 }
853 
854 /**
855  * @title WhitelistAdminRole
856  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
857  */
858 contract WhitelistAdminRole {
859     using Roles for Roles.Role;
860 
861     event WhitelistAdminAdded(address indexed account);
862     event WhitelistAdminRemoved(address indexed account);
863 
864     Roles.Role private _whitelistAdmins;
865 
866     constructor () internal {
867         _addWhitelistAdmin(msg.sender);
868     }
869 
870     modifier onlyWhitelistAdmin() {
871         require(isWhitelistAdmin(msg.sender));
872         _;
873     }
874 
875     function isWhitelistAdmin(address account) public view returns (bool) {
876         return _whitelistAdmins.has(account);
877     }
878 
879     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
880         _addWhitelistAdmin(account);
881     }
882 
883     function renounceWhitelistAdmin() public {
884         _removeWhitelistAdmin(msg.sender);
885     }
886 
887     function _addWhitelistAdmin(address account) internal {
888         _whitelistAdmins.add(account);
889         emit WhitelistAdminAdded(account);
890     }
891 
892     function _removeWhitelistAdmin(address account) internal {
893         _whitelistAdmins.remove(account);
894         emit WhitelistAdminRemoved(account);
895     }
896 }
897 
898 /**
899  * @title WhitelistedRole
900  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
901  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
902  * it), and not Whitelisteds themselves.
903  */
904 contract WhitelistedRole is WhitelistAdminRole {
905     using Roles for Roles.Role;
906 
907     event WhitelistedAdded(address indexed account);
908     event WhitelistedRemoved(address indexed account);
909 
910     Roles.Role private _whitelisteds;
911 
912     modifier onlyWhitelisted() {
913         require(isWhitelisted(msg.sender));
914         _;
915     }
916 
917     function isWhitelisted(address account) public view returns (bool) {
918         return _whitelisteds.has(account);
919     }
920 
921     function addWhitelisted(address account) public onlyWhitelistAdmin {
922         _addWhitelisted(account);
923     }
924 
925     function removeWhitelisted(address account) public onlyWhitelistAdmin {
926         _removeWhitelisted(account);
927     }
928 
929     function renounceWhitelisted() public {
930         _removeWhitelisted(msg.sender);
931     }
932 
933     function _addWhitelisted(address account) internal {
934         _whitelisteds.add(account);
935         emit WhitelistedAdded(account);
936     }
937 
938     function _removeWhitelisted(address account) internal {
939         _whitelisteds.remove(account);
940         emit WhitelistedRemoved(account);
941     }
942 }
943 
944 /**
945  * @title WhitelistCrowdsale
946  * @dev Crowdsale in which only whitelisted users can contribute.
947  */
948 contract WhitelistCrowdsale is WhitelistedRole, Crowdsale {
949     /**
950      * @dev Extend parent behavior requiring beneficiary to be whitelisted. Note that no
951      * restriction is imposed on the account sending the transaction.
952      * @param _beneficiary Token beneficiary
953      * @param _weiAmount Amount of wei contributed
954      */
955     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
956         require(isWhitelisted(_beneficiary));
957         super._preValidatePurchase(_beneficiary, _weiAmount);
958     }
959 }