1 pragma solidity ^0.5.9;
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
69  * @title ERC20 interface
70  * @dev see https://eips.ethereum.org/EIPS/eip-20
71  */
72 interface IERC20 {
73     function transfer(address to, uint256 value) external returns (bool);
74 
75     function approve(address spender, uint256 value) external returns (bool);
76 
77     function transferFrom(address from, address to, uint256 value) external returns (bool);
78 
79     function totalSupply() external view returns (uint256);
80 
81     function balanceOf(address who) external view returns (uint256);
82 
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 /**
92  * @title Roles
93  * @dev Library for managing addresses assigned to a Role.
94  */
95 library Roles {
96     struct Role {
97         mapping (address => bool) bearer;
98     }
99 
100     /**
101      * @dev give an account access to this role
102      */
103     function add(Role storage role, address account) internal {
104         require(account != address(0));
105         require(!has(role, account));
106 
107         role.bearer[account] = true;
108     }
109 
110     /**
111      * @dev remove an account's access to this role
112      */
113     function remove(Role storage role, address account) internal {
114         require(account != address(0));
115         require(has(role, account));
116 
117         role.bearer[account] = false;
118     }
119 
120     /**
121      * @dev check if an account has this role
122      * @return bool
123      */
124     function has(Role storage role, address account) internal view returns (bool) {
125         require(account != address(0));
126         return role.bearer[account];
127     }
128 }
129 
130 
131 
132 
133 contract MinterRole {
134     using Roles for Roles.Role;
135 
136     event MinterAdded(address indexed account);
137     event MinterRemoved(address indexed account);
138 
139     Roles.Role private _minters;
140 
141     constructor () internal {
142         _addMinter(msg.sender);
143     }
144 
145     modifier onlyMinter() {
146         require(isMinter(msg.sender));
147         _;
148     }
149 
150     function isMinter(address account) public view returns (bool) {
151         return _minters.has(account);
152     }
153 
154     function addMinter(address account) public onlyMinter {
155         _addMinter(account);
156     }
157 
158     function renounceMinter() public {
159         _removeMinter(msg.sender);
160     }
161 
162     function _addMinter(address account) internal {
163         _minters.add(account);
164         emit MinterAdded(account);
165     }
166 
167     function _removeMinter(address account) internal {
168         _minters.remove(account);
169         emit MinterRemoved(account);
170     }
171 }
172 
173 
174 
175 
176 
177 
178 
179 /**
180  * @title Standard ERC20 token
181  *
182  * @dev Implementation of the basic standard token.
183  * https://eips.ethereum.org/EIPS/eip-20
184  * Originally based on code by FirstBlood:
185  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  *
187  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
188  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
189  * compliant implementations may not do it.
190  */
191 contract ERC20 is IERC20 {
192     using SafeMath for uint256;
193 
194     mapping (address => uint256) private _balances;
195 
196     mapping (address => mapping (address => uint256)) private _allowed;
197 
198     uint256 private _totalSupply;
199 
200     /**
201      * @dev Total number of tokens in existence
202      */
203     function totalSupply() public view returns (uint256) {
204         return _totalSupply;
205     }
206 
207     /**
208      * @dev Gets the balance of the specified address.
209      * @param owner The address to query the balance of.
210      * @return A uint256 representing the amount owned by the passed address.
211      */
212     function balanceOf(address owner) public view returns (uint256) {
213         return _balances[owner];
214     }
215 
216     /**
217      * @dev Function to check the amount of tokens that an owner allowed to a spender.
218      * @param owner address The address which owns the funds.
219      * @param spender address The address which will spend the funds.
220      * @return A uint256 specifying the amount of tokens still available for the spender.
221      */
222     function allowance(address owner, address spender) public view returns (uint256) {
223         return _allowed[owner][spender];
224     }
225 
226     /**
227      * @dev Transfer token to a specified address
228      * @param to The address to transfer to.
229      * @param value The amount to be transferred.
230      */
231     function transfer(address to, uint256 value) public returns (bool) {
232         _transfer(msg.sender, to, value);
233         return true;
234     }
235 
236     /**
237      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238      * Beware that changing an allowance with this method brings the risk that someone may use both the old
239      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242      * @param spender The address which will spend the funds.
243      * @param value The amount of tokens to be spent.
244      */
245     function approve(address spender, uint256 value) public returns (bool) {
246         _approve(msg.sender, spender, value);
247         return true;
248     }
249 
250     /**
251      * @dev Transfer tokens from one address to another.
252      * Note that while this function emits an Approval event, this is not required as per the specification,
253      * and other compliant implementations may not emit the event.
254      * @param from address The address which you want to send tokens from
255      * @param to address The address which you want to transfer to
256      * @param value uint256 the amount of tokens to be transferred
257      */
258     function transferFrom(address from, address to, uint256 value) public returns (bool) {
259         _transfer(from, to, value);
260         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
261         return true;
262     }
263 
264     /**
265      * @dev Increase the amount of tokens that an owner allowed to a spender.
266      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
267      * allowed value is better to use this function to avoid 2 calls (and wait until
268      * the first transaction is mined)
269      * From MonolithDAO Token.sol
270      * Emits an Approval event.
271      * @param spender The address which will spend the funds.
272      * @param addedValue The amount of tokens to increase the allowance by.
273      */
274     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
275         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
276         return true;
277     }
278 
279     /**
280      * @dev Decrease the amount of tokens that an owner allowed to a spender.
281      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
282      * allowed value is better to use this function to avoid 2 calls (and wait until
283      * the first transaction is mined)
284      * From MonolithDAO Token.sol
285      * Emits an Approval event.
286      * @param spender The address which will spend the funds.
287      * @param subtractedValue The amount of tokens to decrease the allowance by.
288      */
289     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
290         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
291         return true;
292     }
293 
294     /**
295      * @dev Transfer token for a specified addresses
296      * @param from The address to transfer from.
297      * @param to The address to transfer to.
298      * @param value The amount to be transferred.
299      */
300     function _transfer(address from, address to, uint256 value) internal {
301         require(to != address(0));
302 
303         _balances[from] = _balances[from].sub(value);
304         _balances[to] = _balances[to].add(value);
305         emit Transfer(from, to, value);
306     }
307 
308     /**
309      * @dev Internal function that mints an amount of the token and assigns it to
310      * an account. This encapsulates the modification of balances such that the
311      * proper events are emitted.
312      * @param account The account that will receive the created tokens.
313      * @param value The amount that will be created.
314      */
315     function _mint(address account, uint256 value) internal {
316         require(account != address(0));
317 
318         _totalSupply = _totalSupply.add(value);
319         _balances[account] = _balances[account].add(value);
320         emit Transfer(address(0), account, value);
321     }
322 
323     /**
324      * @dev Internal function that burns an amount of the token of a given
325      * account.
326      * @param account The account whose tokens will be burnt.
327      * @param value The amount that will be burnt.
328      */
329     function _burn(address account, uint256 value) internal {
330         require(account != address(0));
331 
332         _totalSupply = _totalSupply.sub(value);
333         _balances[account] = _balances[account].sub(value);
334         emit Transfer(account, address(0), value);
335     }
336 
337     /**
338      * @dev Approve an address to spend another addresses' tokens.
339      * @param owner The address that owns the tokens.
340      * @param spender The address that will spend the tokens.
341      * @param value The number of tokens that can be spent.
342      */
343     function _approve(address owner, address spender, uint256 value) internal {
344         require(spender != address(0));
345         require(owner != address(0));
346 
347         _allowed[owner][spender] = value;
348         emit Approval(owner, spender, value);
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
360         _burn(account, value);
361         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
362     }
363 }
364 
365 
366 
367 /**
368  * @title ERC20Mintable
369  * @dev ERC20 minting logic
370  */
371 contract ERC20Mintable is ERC20, MinterRole {
372     /**
373      * @dev Function to mint tokens
374      * @param to The address that will receive the minted tokens.
375      * @param value The amount of tokens to mint.
376      * @return A boolean that indicates if the operation was successful.
377      */
378     function mint(address to, uint256 value) public onlyMinter returns (bool) {
379         _mint(to, value);
380         return true;
381     }
382 }
383 
384 
385 
386 
387 
388 
389 
390 
391 
392 
393 /**
394  * Utility library of inline functions on addresses
395  */
396 library Address {
397     /**
398      * Returns whether the target address is a contract
399      * @dev This function will return false if invoked during the constructor of a contract,
400      * as the code is not actually created until after the constructor finishes.
401      * @param account address of the account to check
402      * @return whether the target address is a contract
403      */
404     function isContract(address account) internal view returns (bool) {
405         uint256 size;
406         // XXX Currently there is no better way to check if there is a contract in an address
407         // than to check the size of the code at that address.
408         // See https://ethereum.stackexchange.com/a/14016/36603
409         // for more details about how this works.
410         // TODO Check this again before the Serenity release, because all addresses will be
411         // contracts then.
412         // solhint-disable-next-line no-inline-assembly
413         assembly { size := extcodesize(account) }
414         return size > 0;
415     }
416 }
417 
418 
419 /**
420  * @title SafeERC20
421  * @dev Wrappers around ERC20 operations that throw on failure (when the token
422  * contract returns false). Tokens that return no value (and instead revert or
423  * throw on failure) are also supported, non-reverting calls are assumed to be
424  * successful.
425  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
426  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
427  */
428 library SafeERC20 {
429     using SafeMath for uint256;
430     using Address for address;
431 
432     function safeTransfer(IERC20 token, address to, uint256 value) internal {
433         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
434     }
435 
436     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
437         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
438     }
439 
440     function safeApprove(IERC20 token, address spender, uint256 value) internal {
441         // safeApprove should only be called when setting an initial allowance,
442         // or when resetting it to zero. To increase and decrease it, use
443         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
444         require((value == 0) || (token.allowance(address(this), spender) == 0));
445         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
446     }
447 
448     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
449         uint256 newAllowance = token.allowance(address(this), spender).add(value);
450         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
451     }
452 
453     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
454         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
455         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
456     }
457 
458     /**
459      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
460      * on the return value: the return value is optional (but if data is returned, it must equal true).
461      * @param token The token targeted by the call.
462      * @param data The call data (encoded using abi.encode or one of its variants).
463      */
464     function callOptionalReturn(IERC20 token, bytes memory data) private {
465         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
466         // we're implementing it ourselves.
467 
468         // A Solidity high level call has three parts:
469         //  1. The target address is checked to verify it contains contract code
470         //  2. The call itself is made, and success asserted
471         //  3. The return value is decoded, which in turn checks the size of the returned data.
472 
473         require(address(token).isContract());
474 
475         // solhint-disable-next-line avoid-low-level-calls
476         (bool success, bytes memory returndata) = address(token).call(data);
477         require(success);
478 
479         if (returndata.length > 0) { // Return data is optional
480             require(abi.decode(returndata, (bool)));
481         }
482     }
483 }
484 
485 
486 
487 /**
488  * @title Helps contracts guard against reentrancy attacks.
489  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
490  * @dev If you mark a function `nonReentrant`, you should also
491  * mark it `external`.
492  */
493 contract ReentrancyGuard {
494     /// @dev counter to allow mutex lock with only one SSTORE operation
495     uint256 private _guardCounter;
496 
497     constructor () internal {
498         // The counter starts at one to prevent changing it from zero to a non-zero
499         // value, which is a more expensive operation.
500         _guardCounter = 1;
501     }
502 
503     /**
504      * @dev Prevents a contract from calling itself, directly or indirectly.
505      * Calling a `nonReentrant` function from another `nonReentrant`
506      * function is not supported. It is possible to prevent this from happening
507      * by making the `nonReentrant` function external, and make it call a
508      * `private` function that does the actual work.
509      */
510     modifier nonReentrant() {
511         _guardCounter += 1;
512         uint256 localCounter = _guardCounter;
513         _;
514         require(localCounter == _guardCounter);
515     }
516 }
517 
518 
519 /**
520  * @title Crowdsale
521  * @dev Crowdsale is a base contract for managing a token crowdsale,
522  * allowing investors to purchase tokens with ether. This contract implements
523  * such functionality in its most fundamental form and can be extended to provide additional
524  * functionality and/or custom behavior.
525  * The external interface represents the basic interface for purchasing tokens, and conforms
526  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
527  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
528  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
529  * behavior.
530  */
531 contract Crowdsale is ReentrancyGuard {
532     using SafeMath for uint256;
533     using SafeERC20 for IERC20;
534 
535     // The token being sold
536     IERC20 private _token;
537 
538     // Address where funds are collected
539     address payable private _wallet;
540 
541     // How many token units a buyer gets per wei.
542     // The rate is the conversion between wei and the smallest and indivisible token unit.
543     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
544     // 1 wei will give you 1 unit, or 0.001 TOK.
545     uint256 private _rate;
546 
547     // Amount of wei raised
548     uint256 private _weiRaised;
549 
550     /**
551      * Event for token purchase logging
552      * @param purchaser who paid for the tokens
553      * @param beneficiary who got the tokens
554      * @param value weis paid for purchase
555      * @param amount amount of tokens purchased
556      */
557     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
558 
559     /**
560      * @param rate Number of token units a buyer gets per wei
561      * @dev The rate is the conversion between wei and the smallest and indivisible
562      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
563      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
564      * @param wallet Address where collected funds will be forwarded to
565      * @param token Address of the token being sold
566      */
567     constructor (uint256 rate, address payable wallet, IERC20 token) public {
568         require(rate > 0);
569         require(wallet != address(0));
570         require(address(token) != address(0));
571 
572         _rate = rate;
573         _wallet = wallet;
574         _token = token;
575     }
576 
577     /**
578      * @dev fallback function ***DO NOT OVERRIDE***
579      * Note that other contracts will transfer funds with a base gas stipend
580      * of 2300, which is not enough to call buyTokens. Consider calling
581      * buyTokens directly when purchasing tokens from a contract.
582      */
583     function () external payable {
584         buyTokens(msg.sender);
585     }
586 
587     /**
588      * @return the token being sold.
589      */
590     function token() public view returns (IERC20) {
591         return _token;
592     }
593 
594     /**
595      * @return the address where funds are collected.
596      */
597     function wallet() public view returns (address payable) {
598         return _wallet;
599     }
600 
601     /**
602      * @return the number of token units a buyer gets per wei.
603      */
604     function rate() public view returns (uint256) {
605         return _rate;
606     }
607 
608     /**
609      * @return the amount of wei raised.
610      */
611     function weiRaised() public view returns (uint256) {
612         return _weiRaised;
613     }
614 
615     /**
616      * @dev low level token purchase ***DO NOT OVERRIDE***
617      * This function has a non-reentrancy guard, so it shouldn't be called by
618      * another `nonReentrant` function.
619      * @param beneficiary Recipient of the token purchase
620      */
621     function buyTokens(address beneficiary) public nonReentrant payable {
622         uint256 weiAmount = msg.value;
623         _preValidatePurchase(beneficiary, weiAmount);
624 
625         // calculate token amount to be created
626         uint256 tokens = _getTokenAmount(weiAmount);
627 
628         // update state
629         _weiRaised = _weiRaised.add(weiAmount);
630 
631         _processPurchase(beneficiary, tokens);
632         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
633 
634         _updatePurchasingState(beneficiary, weiAmount);
635 
636         _forwardFunds();
637         _postValidatePurchase(beneficiary, weiAmount);
638     }
639 
640     /**
641      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
642      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
643      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
644      *     super._preValidatePurchase(beneficiary, weiAmount);
645      *     require(weiRaised().add(weiAmount) <= cap);
646      * @param beneficiary Address performing the token purchase
647      * @param weiAmount Value in wei involved in the purchase
648      */
649     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
650         require(beneficiary != address(0));
651         require(weiAmount != 0);
652     }
653 
654     /**
655      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
656      * conditions are not met.
657      * @param beneficiary Address performing the token purchase
658      * @param weiAmount Value in wei involved in the purchase
659      */
660     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
661         // solhint-disable-previous-line no-empty-blocks
662     }
663 
664     /**
665      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
666      * its tokens.
667      * @param beneficiary Address performing the token purchase
668      * @param tokenAmount Number of tokens to be emitted
669      */
670     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
671         _token.safeTransfer(beneficiary, tokenAmount);
672     }
673 
674     /**
675      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
676      * tokens.
677      * @param beneficiary Address receiving the tokens
678      * @param tokenAmount Number of tokens to be purchased
679      */
680     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
681         _deliverTokens(beneficiary, tokenAmount);
682     }
683 
684     /**
685      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
686      * etc.)
687      * @param beneficiary Address receiving the tokens
688      * @param weiAmount Value in wei involved in the purchase
689      */
690     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
691         // solhint-disable-previous-line no-empty-blocks
692     }
693 
694     /**
695      * @dev Override to extend the way in which ether is converted to tokens.
696      * @param weiAmount Value in wei to be converted into tokens
697      * @return Number of tokens that can be purchased with the specified _weiAmount
698      */
699     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
700         return weiAmount.mul(_rate);
701     }
702 
703     /**
704      * @dev Determines how ETH is stored/forwarded on purchases.
705      */
706     function _forwardFunds() internal {
707         _wallet.transfer(msg.value);
708     }
709 }
710 
711 
712 
713 
714 
715 
716 
717 
718 /**
719  * @title TimedCrowdsale
720  * @dev Crowdsale accepting contributions only within a time frame.
721  */
722 contract TimedCrowdsale is Crowdsale {
723     using SafeMath for uint256;
724 
725     uint256 private _openingTime;
726     uint256 private _closingTime;
727 
728     /**
729      * Event for crowdsale extending
730      * @param newClosingTime new closing time
731      * @param prevClosingTime old closing time
732      */
733     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
734 
735     /**
736      * @dev Reverts if not in crowdsale time range.
737      */
738     modifier onlyWhileOpen {
739         require(isOpen());
740         _;
741     }
742 
743     /**
744      * @dev Constructor, takes crowdsale opening and closing times.
745      * @param openingTime Crowdsale opening time
746      * @param closingTime Crowdsale closing time
747      */
748     constructor (uint256 openingTime, uint256 closingTime) public {
749         // solhint-disable-next-line not-rely-on-time
750         require(openingTime >= block.timestamp);
751         require(closingTime > openingTime);
752 
753         _openingTime = openingTime;
754         _closingTime = closingTime;
755     }
756 
757     /**
758      * @return the crowdsale opening time.
759      */
760     function openingTime() public view returns (uint256) {
761         return _openingTime;
762     }
763 
764     /**
765      * @return the crowdsale closing time.
766      */
767     function closingTime() public view returns (uint256) {
768         return _closingTime;
769     }
770 
771     /**
772      * @return true if the crowdsale is open, false otherwise.
773      */
774     function isOpen() public view returns (bool) {
775         // solhint-disable-next-line not-rely-on-time
776         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
777     }
778 
779     /**
780      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
781      * @return Whether crowdsale period has elapsed
782      */
783     function hasClosed() public view returns (bool) {
784         // solhint-disable-next-line not-rely-on-time
785         return block.timestamp > _closingTime;
786     }
787 
788     /**
789      * @dev Extend parent behavior requiring to be within contributing period
790      * @param beneficiary Token purchaser
791      * @param weiAmount Amount of wei contributed
792      */
793     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
794         super._preValidatePurchase(beneficiary, weiAmount);
795     }
796 
797     /**
798      * @dev Extend crowdsale
799      * @param newClosingTime Crowdsale closing time
800      */
801     function _extendTime(uint256 newClosingTime) internal {
802         require(!hasClosed());
803         require(newClosingTime > _closingTime);
804 
805         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
806         _closingTime = newClosingTime;
807     }
808 }
809 
810 
811 /**
812  * @title FinalizableCrowdsale
813  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
814  * can do extra work after finishing.
815  */
816 contract FinalizableCrowdsale is TimedCrowdsale {
817     using SafeMath for uint256;
818 
819     bool private _finalized;
820 
821     event CrowdsaleFinalized();
822 
823     constructor () internal {
824         _finalized = false;
825     }
826 
827     /**
828      * @return true if the crowdsale is finalized, false otherwise.
829      */
830     function finalized() public view returns (bool) {
831         return _finalized;
832     }
833 
834     /**
835      * @dev Must be called after crowdsale ends, to do some extra finalization
836      * work. Calls the contract's finalization function.
837      */
838     function finalize() public {
839         require(!_finalized);
840         require(hasClosed());
841 
842         _finalized = true;
843 
844         _finalization();
845         emit CrowdsaleFinalized();
846     }
847 
848     /**
849      * @dev Can be overridden to add finalization logic. The overriding function
850      * should call super._finalization() to ensure the chain of finalization is
851      * executed entirely.
852      */
853     function _finalization() internal {
854         // solhint-disable-previous-line no-empty-blocks
855     }
856 }
857 
858 
859 
860 
861 
862 
863 
864 /**
865  * @title CappedCrowdsale
866  * @dev Crowdsale with a limit for total contributions.
867  */
868 contract CappedCrowdsale is Crowdsale {
869     using SafeMath for uint256;
870 
871     uint256 private _cap;
872 
873     /**
874      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
875      * @param cap Max amount of wei to be contributed
876      */
877     constructor (uint256 cap) public {
878         require(cap > 0);
879         _cap = cap;
880     }
881 
882     /**
883      * @return the cap of the crowdsale.
884      */
885     function cap() public view returns (uint256) {
886         return _cap;
887     }
888 
889     /**
890      * @dev Checks whether the cap has been reached.
891      * @return Whether the cap was reached
892      */
893     function capReached() public view returns (bool) {
894         return weiRaised() >= _cap;
895     }
896 
897     /**
898      * @dev Extend parent behavior requiring purchase to respect the funding cap.
899      * @param beneficiary Token purchaser
900      * @param weiAmount Amount of wei contributed
901      */
902     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
903         super._preValidatePurchase(beneficiary, weiAmount);
904         require(weiRaised().add(weiAmount) <= _cap);
905     }
906 }
907 
908 
909 
910 
911 
912 
913 
914 
915 
916 
917 
918 
919 
920 
921 /**
922  * @title Secondary
923  * @dev A Secondary contract can only be used by its primary account (the one that created it)
924  */
925 contract Secondary {
926     address private _primary;
927 
928     event PrimaryTransferred(
929         address recipient
930     );
931 
932     /**
933      * @dev Sets the primary account to the one that is creating the Secondary contract.
934      */
935     constructor () internal {
936         _primary = msg.sender;
937         emit PrimaryTransferred(_primary);
938     }
939 
940     /**
941      * @dev Reverts if called from any account other than the primary.
942      */
943     modifier onlyPrimary() {
944         require(msg.sender == _primary);
945         _;
946     }
947 
948     /**
949      * @return the address of the primary.
950      */
951     function primary() public view returns (address) {
952         return _primary;
953     }
954 
955     /**
956      * @dev Transfers contract to a new primary.
957      * @param recipient The address of new primary.
958      */
959     function transferPrimary(address recipient) public onlyPrimary {
960         require(recipient != address(0));
961         _primary = recipient;
962         emit PrimaryTransferred(_primary);
963     }
964 }
965 
966 
967  /**
968   * @title Escrow
969   * @dev Base escrow contract, holds funds designated for a payee until they
970   * withdraw them.
971   * @dev Intended usage: This contract (and derived escrow contracts) should be a
972   * standalone contract, that only interacts with the contract that instantiated
973   * it. That way, it is guaranteed that all Ether will be handled according to
974   * the Escrow rules, and there is no need to check for payable functions or
975   * transfers in the inheritance tree. The contract that uses the escrow as its
976   * payment method should be its primary, and provide public methods redirecting
977   * to the escrow's deposit and withdraw.
978   */
979 contract Escrow is Secondary {
980     using SafeMath for uint256;
981 
982     event Deposited(address indexed payee, uint256 weiAmount);
983     event Withdrawn(address indexed payee, uint256 weiAmount);
984 
985     mapping(address => uint256) private _deposits;
986 
987     function depositsOf(address payee) public view returns (uint256) {
988         return _deposits[payee];
989     }
990 
991     /**
992      * @dev Stores the sent amount as credit to be withdrawn.
993      * @param payee The destination address of the funds.
994      */
995     function deposit(address payee) public onlyPrimary payable {
996         uint256 amount = msg.value;
997         _deposits[payee] = _deposits[payee].add(amount);
998 
999         emit Deposited(payee, amount);
1000     }
1001 
1002     /**
1003      * @dev Withdraw accumulated balance for a payee.
1004      * @param payee The address whose funds will be withdrawn and transferred to.
1005      */
1006     function withdraw(address payable payee) public onlyPrimary {
1007         uint256 payment = _deposits[payee];
1008 
1009         _deposits[payee] = 0;
1010 
1011         payee.transfer(payment);
1012 
1013         emit Withdrawn(payee, payment);
1014     }
1015 }
1016 
1017 
1018 /**
1019  * @title ConditionalEscrow
1020  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
1021  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1022  */
1023 contract ConditionalEscrow is Escrow {
1024     /**
1025      * @dev Returns whether an address is allowed to withdraw their funds. To be
1026      * implemented by derived contracts.
1027      * @param payee The destination address of the funds.
1028      */
1029     function withdrawalAllowed(address payee) public view returns (bool);
1030 
1031     function withdraw(address payable payee) public {
1032         require(withdrawalAllowed(payee));
1033         super.withdraw(payee);
1034     }
1035 }
1036 
1037 
1038 /**
1039  * @title RefundEscrow
1040  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
1041  * parties.
1042  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1043  * @dev The primary account (that is, the contract that instantiates this
1044  * contract) may deposit, close the deposit period, and allow for either
1045  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
1046  * with RefundEscrow will be made through the primary contract. See the
1047  * RefundableCrowdsale contract for an example of RefundEscrow’s use.
1048  */
1049 contract RefundEscrow is ConditionalEscrow {
1050     enum State { Active, Refunding, Closed }
1051 
1052     event RefundsClosed();
1053     event RefundsEnabled();
1054 
1055     State private _state;
1056     address payable private _beneficiary;
1057 
1058     /**
1059      * @dev Constructor.
1060      * @param beneficiary The beneficiary of the deposits.
1061      */
1062     constructor (address payable beneficiary) public {
1063         require(beneficiary != address(0));
1064         _beneficiary = beneficiary;
1065         _state = State.Active;
1066     }
1067 
1068     /**
1069      * @return the current state of the escrow.
1070      */
1071     function state() public view returns (State) {
1072         return _state;
1073     }
1074 
1075     /**
1076      * @return the beneficiary of the escrow.
1077      */
1078     function beneficiary() public view returns (address) {
1079         return _beneficiary;
1080     }
1081 
1082     /**
1083      * @dev Stores funds that may later be refunded.
1084      * @param refundee The address funds will be sent to if a refund occurs.
1085      */
1086     function deposit(address refundee) public payable {
1087         require(_state == State.Active);
1088         super.deposit(refundee);
1089     }
1090 
1091     /**
1092      * @dev Allows for the beneficiary to withdraw their funds, rejecting
1093      * further deposits.
1094      */
1095     function close() public onlyPrimary {
1096         require(_state == State.Active);
1097         _state = State.Closed;
1098         emit RefundsClosed();
1099     }
1100 
1101     /**
1102      * @dev Allows for refunds to take place, rejecting further deposits.
1103      */
1104     function enableRefunds() public onlyPrimary {
1105         require(_state == State.Active);
1106         _state = State.Refunding;
1107         emit RefundsEnabled();
1108     }
1109 
1110     /**
1111      * @dev Withdraws the beneficiary's funds.
1112      */
1113     function beneficiaryWithdraw() public {
1114         require(_state == State.Closed);
1115         _beneficiary.transfer(address(this).balance);
1116     }
1117 
1118     /**
1119      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
1120      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
1121      */
1122     function withdrawalAllowed(address) public view returns (bool) {
1123         return _state == State.Refunding;
1124     }
1125 }
1126 
1127 
1128 /**
1129  * @title RefundableCrowdsale
1130  * @dev Extension of FinalizableCrowdsale contract that adds a funding goal, and the possibility of users
1131  * getting a refund if goal is not met.
1132  *
1133  * Deprecated, use RefundablePostDeliveryCrowdsale instead. Note that if you allow tokens to be traded before the goal
1134  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
1135  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
1136  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
1137  */
1138 contract RefundableCrowdsale is FinalizableCrowdsale {
1139     using SafeMath for uint256;
1140 
1141     // minimum amount of funds to be raised in weis
1142     uint256 private _goal;
1143 
1144     // refund escrow used to hold funds while crowdsale is running
1145     RefundEscrow private _escrow;
1146 
1147     /**
1148      * @dev Constructor, creates RefundEscrow.
1149      * @param goal Funding goal
1150      */
1151     constructor (uint256 goal) public {
1152         require(goal > 0);
1153         _escrow = new RefundEscrow(wallet());
1154         _goal = goal;
1155     }
1156 
1157     /**
1158      * @return minimum amount of funds to be raised in wei.
1159      */
1160     function goal() public view returns (uint256) {
1161         return _goal;
1162     }
1163 
1164     /**
1165      * @dev Investors can claim refunds here if crowdsale is unsuccessful
1166      * @param refundee Whose refund will be claimed.
1167      */
1168     function claimRefund(address payable refundee) public {
1169         require(finalized());
1170         require(!goalReached());
1171 
1172         _escrow.withdraw(refundee);
1173     }
1174 
1175     /**
1176      * @dev Checks whether funding goal was reached.
1177      * @return Whether funding goal was reached
1178      */
1179     function goalReached() public view returns (bool) {
1180         return weiRaised() >= _goal;
1181     }
1182 
1183     /**
1184      * @dev escrow finalization task, called when finalize() is called
1185      */
1186     function _finalization() internal {
1187         if (goalReached()) {
1188             _escrow.close();
1189             _escrow.beneficiaryWithdraw();
1190         } else {
1191             _escrow.enableRefunds();
1192         }
1193 
1194         super._finalization();
1195     }
1196 
1197     /**
1198      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1199      */
1200     function _forwardFunds() internal {
1201         _escrow.deposit.value(msg.value)(msg.sender);
1202     }
1203 }
1204 
1205 
1206 
1207 
1208 
1209 
1210 
1211 /**
1212  * @title MintedCrowdsale
1213  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1214  * Token ownership should be transferred to MintedCrowdsale for minting.
1215  */
1216 contract MintedCrowdsale is Crowdsale {
1217     /**
1218      * @dev Overrides delivery by minting tokens upon purchase.
1219      * @param beneficiary Token purchaser
1220      * @param tokenAmount Number of tokens to be minted
1221      */
1222     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
1223         // Potentially dangerous assumption about the type of the token.
1224         require(ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
1225     }
1226 }
1227 
1228 
1229 
1230 
1231 
1232 
1233 /**
1234  * @title Capped token
1235  * @dev Mintable token with a token cap.
1236  */
1237 contract ERC20Capped is ERC20Mintable {
1238     uint256 private _cap;
1239 
1240     constructor (uint256 cap) public {
1241         require(cap > 0);
1242         _cap = cap;
1243     }
1244 
1245     /**
1246      * @return the cap for the token minting.
1247      */
1248     function cap() public view returns (uint256) {
1249         return _cap;
1250     }
1251 
1252     function _mint(address account, uint256 value) internal {
1253         require(totalSupply().add(value) <= _cap);
1254         super._mint(account, value);
1255     }
1256 }
1257 
1258 
1259 
1260 /**
1261  * @title Ownable
1262  * @dev The Ownable contract has an owner address, and provides basic authorization control
1263  * functions, this simplifies the implementation of "user permissions".
1264  */
1265 contract Ownable {
1266     address private _owner;
1267 
1268     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1269 
1270     /**
1271      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1272      * account.
1273      */
1274     constructor () internal {
1275         _owner = msg.sender;
1276         emit OwnershipTransferred(address(0), _owner);
1277     }
1278 
1279     /**
1280      * @return the address of the owner.
1281      */
1282     function owner() public view returns (address) {
1283         return _owner;
1284     }
1285 
1286     /**
1287      * @dev Throws if called by any account other than the owner.
1288      */
1289     modifier onlyOwner() {
1290         require(isOwner());
1291         _;
1292     }
1293 
1294     /**
1295      * @return true if `msg.sender` is the owner of the contract.
1296      */
1297     function isOwner() public view returns (bool) {
1298         return msg.sender == _owner;
1299     }
1300 
1301     /**
1302      * @dev Allows the current owner to relinquish control of the contract.
1303      * It will not be possible to call the functions with the `onlyOwner`
1304      * modifier anymore.
1305      * @notice Renouncing ownership will leave the contract without an owner,
1306      * thereby removing any functionality that is only available to the owner.
1307      */
1308     function renounceOwnership() public onlyOwner {
1309         emit OwnershipTransferred(_owner, address(0));
1310         _owner = address(0);
1311     }
1312 
1313     /**
1314      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1315      * @param newOwner The address to transfer ownership to.
1316      */
1317     function transferOwnership(address newOwner) public onlyOwner {
1318         _transferOwnership(newOwner);
1319     }
1320 
1321     /**
1322      * @dev Transfers control of the contract to a newOwner.
1323      * @param newOwner The address to transfer ownership to.
1324      */
1325     function _transferOwnership(address newOwner) internal {
1326         require(newOwner != address(0));
1327         emit OwnershipTransferred(_owner, newOwner);
1328         _owner = newOwner;
1329     }
1330 }
1331  
1332 
1333 interface IMinterRole {
1334     function renounceMinter() external;
1335 }
1336 
1337 contract PictosisCrowdsale is CappedCrowdsale, MintedCrowdsale, TimedCrowdsale, FinalizableCrowdsale, Ownable {
1338     address public presaleAddress;
1339     uint public presaleSold = 0;
1340     bool public presaleActive = false;
1341     bool public presaleFinished = false;
1342 
1343     uint public presaleCap;
1344     uint public maxSupplyCap;
1345 
1346     uint public maxContribETH;
1347 
1348     address payable public teamMultisig;
1349 
1350     constructor (
1351         uint256 _openingTime,
1352         uint256 _closingTime,
1353         uint256 _rate,
1354         address payable _wallet,
1355         ERC20Mintable _token,
1356         uint _presaleCap,
1357         uint _maxSupplyCap,
1358         uint _maxContribETH
1359     )
1360         public
1361         Crowdsale(_rate, _wallet, _token)
1362         CappedCrowdsale(_maxSupplyCap)
1363         TimedCrowdsale(_openingTime, _closingTime)
1364     {
1365         teamMultisig = _wallet;
1366         presaleCap = _presaleCap;
1367         maxSupplyCap = _maxSupplyCap;
1368         maxContribETH = _maxContribETH;
1369     }
1370 
1371     event PresaleAddressSet(address presaleAddress);
1372 
1373     /// @notice Set presale address
1374     /// @param _presaleAddress address that will mint tokens
1375     function setPresaleAddress(address _presaleAddress) public onlyOwner {
1376         require(presaleAddress == address(0), "Presale address has been set already");
1377 
1378         presaleAddress = _presaleAddress;
1379         emit PresaleAddressSet(presaleAddress);
1380     }
1381 
1382     event PresaleStarted(uint blockNumber);
1383 
1384     /// @notice Enable presale period
1385     function startPresale() public onlyOwner {
1386         require(presaleActive == false, "Presale is already active");
1387         require(presaleFinished == false, "Presale already finished");
1388         require(presaleSold == 0, "Presale has already happened");
1389         require(presaleAddress != address(0), "Presale address hasn't been set");
1390 
1391         presaleActive = true;
1392         emit PresaleStarted(block.number);
1393     }
1394 
1395     /// @notice Mint tokens (can only be called by the presale address)
1396     /// @param _account Address to mint tokens
1397     /// @param _value Amount in token equivalents to mint
1398     function mint(address _account, uint256 _value) public {
1399         require(presaleActive == true, "Presale is not active");
1400         require(msg.sender == presaleAddress, "Only presale address can call this function");
1401 
1402         uint currentlySold = presaleSold;
1403         presaleSold = currentlySold.add(_value);
1404 
1405         require(presaleSold <= presaleCap, "Exceeds presale cap");
1406 
1407         ERC20Mintable(address(token())).mint(_account, _value);
1408     }
1409 
1410     event PresaleFinished(uint amountNotSold, uint blockNumber);
1411 
1412     /// @notice Finish presale period
1413     function finishPresale() public onlyOwner {
1414         require(presaleFinished == false, "Presale already finished");
1415         require(presaleActive == true, "Presale is not active");
1416 
1417         presaleActive = false;
1418         presaleFinished = true;
1419         presaleAddress = address(0);
1420 
1421         emit PresaleFinished(presaleSold, block.number);
1422     }
1423 
1424     function _finalization() internal {
1425         ERC20Capped tkn = ERC20Capped(address(token()));
1426         uint unmintedTokens = tkn.cap().sub(tkn.totalSupply());
1427         ERC20Mintable(address(token())).mint(teamMultisig, unmintedTokens);
1428         IMinterRole(address(token())).renounceMinter();
1429         super._finalization();
1430     }
1431 
1432     mapping(address => uint256) private _contributions;
1433 
1434     /**
1435      * @dev Returns the amount contributed so far by a specific beneficiary.
1436      * @param beneficiary Address of contributor
1437      * @return Beneficiary contribution so far
1438      */
1439     function getContribution(address beneficiary) public view returns (uint256) {
1440         return _contributions[beneficiary];
1441     }
1442 
1443     /**
1444      * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
1445      * @param beneficiary Token purchaser
1446      * @param weiAmount Amount of wei contributed
1447      */
1448     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1449         super._preValidatePurchase(beneficiary, weiAmount);
1450         require(_contributions[beneficiary].add(weiAmount) <= maxContribETH, "Max allowed is 100 ETH");
1451     }
1452 
1453     /**
1454      * @dev Extend parent behavior to update beneficiary contributions
1455      * @param beneficiary Token purchaser
1456      * @param weiAmount Amount of wei contributed
1457      */
1458     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
1459         super._updatePurchasingState(beneficiary, weiAmount);
1460         _contributions[beneficiary] = _contributions[beneficiary].add(weiAmount);
1461     }
1462 
1463     /// @notice This method can be used by the minter to extract mistakenly
1464     ///  sent tokens to this contract.
1465     /// @param _token The address of the token contract that you want to recover
1466     ///  set to 0x0000...0000 in case you want to extract ether.
1467     function claimTokens(address _token) public onlyOwner {
1468         if (_token == address(0)) {
1469             msg.sender.transfer(address(this).balance);
1470             return;
1471         }
1472 
1473         ERC20 token = ERC20(_token);
1474         uint256 balance = token.balanceOf(address(this));
1475         token.transfer(msg.sender, balance);
1476         emit ClaimedTokens(_token, msg.sender, balance);
1477     }
1478 
1479     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1480 }