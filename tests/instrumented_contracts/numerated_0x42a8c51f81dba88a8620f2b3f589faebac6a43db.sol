1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 library Math {
8     /**
9     * @dev Returns the largest of two numbers.
10     */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16     * @dev Returns the smallest of two numbers.
17     */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23     * @dev Calculates the average of two numbers. Since these are integers,
24     * averages of an even and odd number cannot be represented, and will be
25     * rounded down.
26     */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 
34 /**
35  * @title ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/20
37  */
38 interface IERC20 {
39     function transfer(address to, uint256 value) external returns (bool);
40 
41     function approve(address spender, uint256 value) external returns (bool);
42 
43     function transferFrom(address from, address to, uint256 value) external returns (bool);
44 
45     function totalSupply() external view returns (uint256);
46 
47     function balanceOf(address who) external view returns (uint256);
48 
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title SafeERC20
58  * @dev Wrappers around ERC20 operations that throw on failure.
59  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
60  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
61  */
62 library SafeERC20 {
63     using SafeMath for uint256;
64 
65     function safeTransfer(IERC20 token, address to, uint256 value) internal {
66         require(token.transfer(to, value));
67     }
68 
69     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
70         require(token.transferFrom(from, to, value));
71     }
72 
73     function safeApprove(IERC20 token, address spender, uint256 value) internal {
74         // safeApprove should only be called when setting an initial allowance,
75         // or when resetting it to zero. To increase and decrease it, use
76         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
77         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
78         require(token.approve(spender, value));
79     }
80 
81     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
82         uint256 newAllowance = token.allowance(address(this), spender).add(value);
83         require(token.approve(spender, newAllowance));
84     }
85 
86     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
87         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
88         require(token.approve(spender, newAllowance));
89     }
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
97  * Originally based on code by FirstBlood:
98  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  *
100  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
101  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
102  * compliant implementations may not do it.
103  */
104 contract ERC20 is IERC20 {
105     using SafeMath for uint256;
106 
107     mapping (address => uint256) private _balances;
108 
109     mapping (address => mapping (address => uint256)) private _allowed;
110 
111     uint256 private _totalSupply;
112 
113     /**
114     * @dev Total number of tokens in existence
115     */
116     function totalSupply() public view returns (uint256) {
117         return _totalSupply;
118     }
119 
120     /**
121     * @dev Gets the balance of the specified address.
122     * @param owner The address to query the balance of.
123     * @return An uint256 representing the amount owned by the passed address.
124     */
125     function balanceOf(address owner) public view returns (uint256) {
126         return _balances[owner];
127     }
128 
129     /**
130      * @dev Function to check the amount of tokens that an owner allowed to a spender.
131      * @param owner address The address which owns the funds.
132      * @param spender address The address which will spend the funds.
133      * @return A uint256 specifying the amount of tokens still available for the spender.
134      */
135     function allowance(address owner, address spender) public view returns (uint256) {
136         return _allowed[owner][spender];
137     }
138 
139     /**
140     * @dev Transfer token for a specified address
141     * @param to The address to transfer to.
142     * @param value The amount to be transferred.
143     */
144     function transfer(address to, uint256 value) public returns (bool) {
145         _transfer(msg.sender, to, value);
146         return true;
147     }
148 
149     /**
150      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151      * Beware that changing an allowance with this method brings the risk that someone may use both the old
152      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      * @param spender The address which will spend the funds.
156      * @param value The amount of tokens to be spent.
157      */
158     function approve(address spender, uint256 value) public returns (bool) {
159         require(spender != address(0));
160 
161         _allowed[msg.sender][spender] = value;
162         emit Approval(msg.sender, spender, value);
163         return true;
164     }
165 
166     /**
167      * @dev Transfer tokens from one address to another.
168      * Note that while this function emits an Approval event, this is not required as per the specification,
169      * and other compliant implementations may not emit the event.
170      * @param from address The address which you want to send tokens from
171      * @param to address The address which you want to transfer to
172      * @param value uint256 the amount of tokens to be transferred
173      */
174     function transferFrom(address from, address to, uint256 value) public returns (bool) {
175         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
176         _transfer(from, to, value);
177         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
178         return true;
179     }
180 
181     /**
182      * @dev Increase the amount of tokens that an owner allowed to a spender.
183      * approve should be called when allowed_[_spender] == 0. To increment
184      * allowed value is better to use this function to avoid 2 calls (and wait until
185      * the first transaction is mined)
186      * From MonolithDAO Token.sol
187      * Emits an Approval event.
188      * @param spender The address which will spend the funds.
189      * @param addedValue The amount of tokens to increase the allowance by.
190      */
191     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
192         require(spender != address(0));
193 
194         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
195         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
196         return true;
197     }
198 
199     /**
200      * @dev Decrease the amount of tokens that an owner allowed to a spender.
201      * approve should be called when allowed_[_spender] == 0. To decrement
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * Emits an Approval event.
206      * @param spender The address which will spend the funds.
207      * @param subtractedValue The amount of tokens to decrease the allowance by.
208      */
209     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
210         require(spender != address(0));
211 
212         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
213         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
214         return true;
215     }
216 
217     /**
218     * @dev Transfer token for a specified addresses
219     * @param from The address to transfer from.
220     * @param to The address to transfer to.
221     * @param value The amount to be transferred.
222     */
223     function _transfer(address from, address to, uint256 value) internal {
224         require(to != address(0));
225 
226         _balances[from] = _balances[from].sub(value);
227         _balances[to] = _balances[to].add(value);
228         emit Transfer(from, to, value);
229     }
230 
231     /**
232      * @dev Internal function that mints an amount of the token and assigns it to
233      * an account. This encapsulates the modification of balances such that the
234      * proper events are emitted.
235      * @param account The account that will receive the created tokens.
236      * @param value The amount that will be created.
237      */
238     function _mint(address account, uint256 value) internal {
239         require(account != address(0));
240 
241         _totalSupply = _totalSupply.add(value);
242         _balances[account] = _balances[account].add(value);
243         emit Transfer(address(0), account, value);
244     }
245 
246     /**
247      * @dev Internal function that burns an amount of the token of a given
248      * account.
249      * @param account The account whose tokens will be burnt.
250      * @param value The amount that will be burnt.
251      */
252     function _burn(address account, uint256 value) internal {
253         require(account != address(0));
254 
255         _totalSupply = _totalSupply.sub(value);
256         _balances[account] = _balances[account].sub(value);
257         emit Transfer(account, address(0), value);
258     }
259 
260     /**
261      * @dev Internal function that burns an amount of the token of a given
262      * account, deducting from the sender's allowance for said account. Uses the
263      * internal burn function.
264      * Emits an Approval event (reflecting the reduced allowance).
265      * @param account The account whose tokens will be burnt.
266      * @param value The amount that will be burnt.
267      */
268     function _burnFrom(address account, uint256 value) internal {
269         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
270         _burn(account, value);
271         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
272     }
273 }
274 
275 
276 /**
277  * @title Helps contracts guard against reentrancy attacks.
278  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
279  * @dev If you mark a function `nonReentrant`, you should also
280  * mark it `external`.
281  */
282 contract ReentrancyGuard {
283     /// @dev counter to allow mutex lock with only one SSTORE operation
284     uint256 private _guardCounter;
285 
286     constructor () internal {
287         // The counter starts at one to prevent changing it from zero to a non-zero
288         // value, which is a more expensive operation.
289         _guardCounter = 1;
290     }
291 
292     /**
293      * @dev Prevents a contract from calling itself, directly or indirectly.
294      * Calling a `nonReentrant` function from another `nonReentrant`
295      * function is not supported. It is possible to prevent this from happening
296      * by making the `nonReentrant` function external, and make it call a
297      * `private` function that does the actual work.
298      */
299     modifier nonReentrant() {
300         _guardCounter += 1;
301         uint256 localCounter = _guardCounter;
302         _;
303         require(localCounter == _guardCounter);
304     }
305 }
306 
307 /**
308  * @title Crowdsale
309  * @dev Crowdsale is a base contract for managing a token crowdsale,
310  * allowing investors to purchase tokens with ether. This contract implements
311  * such functionality in its most fundamental form and can be extended to provide additional
312  * functionality and/or custom behavior.
313  * The external interface represents the basic interface for purchasing tokens, and conform
314  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
315  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
316  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
317  * behavior.
318  */
319 contract Crowdsale is ReentrancyGuard {
320     using SafeMath for uint256;
321     using SafeERC20 for IERC20;
322 
323     // The token being sold
324     IERC20 private _token;
325 
326     // Address where funds are collected
327     address payable private _wallet;
328 
329     // How many token units a buyer gets per wei.
330     // The rate is the conversion between wei and the smallest and indivisible token unit.
331     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
332     // 1 wei will give you 1 unit, or 0.001 TOK.
333     uint256 private _rate;
334 
335     // Amount of wei raised
336     uint256 private _weiRaised;
337 
338     /**
339      * Event for token purchase logging
340      * @param purchaser who paid for the tokens
341      * @param beneficiary who got the tokens
342      * @param value weis paid for purchase
343      * @param amount amount of tokens purchased
344      */
345     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
346 
347     /**
348      * @param rate Number of token units a buyer gets per wei
349      * @dev The rate is the conversion between wei and the smallest and indivisible
350      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
351      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
352      * @param wallet Address where collected funds will be forwarded to
353      * @param token Address of the token being sold
354      */
355     constructor (uint256 rate, address payable wallet, IERC20 token) public {
356         require(rate > 0);
357         require(wallet != address(0));
358         require(address(token) != address(0));
359 
360         _rate = rate;
361         _wallet = wallet;
362         _token = token;
363     }
364 
365     /**
366      * @dev fallback function ***DO NOT OVERRIDE***
367      * Note that other contracts will transfer fund with a base gas stipend
368      * of 2300, which is not enough to call buyTokens. Consider calling
369      * buyTokens directly when purchasing tokens from a contract.
370      */
371     function () external payable {
372         buyTokens(msg.sender);
373     }
374 
375     /**
376      * @return the token being sold.
377      */
378     function token() public view returns (IERC20) {
379         return _token;
380     }
381 
382     /**
383      * @return the address where funds are collected.
384      */
385     function wallet() public view returns (address payable) {
386         return _wallet;
387     }
388 
389     /**
390      * @return the number of token units a buyer gets per wei.
391      */
392     function rate() public view returns (uint256) {
393         return _rate;
394     }
395 
396     /**
397      * @return the amount of wei raised.
398      */
399     function weiRaised() public view returns (uint256) {
400         return _weiRaised;
401     }
402 
403     /**
404      * @dev low level token purchase ***DO NOT OVERRIDE***
405      * This function has a non-reentrancy guard, so it shouldn't be called by
406      * another `nonReentrant` function.
407      * @param beneficiary Recipient of the token purchase
408      */
409     function buyTokens(address beneficiary) public nonReentrant payable {
410         uint256 weiAmount = msg.value;
411         _preValidatePurchase(beneficiary, weiAmount);
412 
413         // calculate token amount to be created
414         uint256 tokens = _getTokenAmount(weiAmount);
415 
416         // update state
417         _weiRaised = _weiRaised.add(weiAmount);
418 
419         _processPurchase(beneficiary, tokens);
420         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
421 
422         _updatePurchasingState(beneficiary, weiAmount);
423 
424         _forwardFunds();
425         _postValidatePurchase(beneficiary, weiAmount);
426     }
427 
428     /**
429      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
430      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
431      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
432      *     super._preValidatePurchase(beneficiary, weiAmount);
433      *     require(weiRaised().add(weiAmount) <= cap);
434      * @param beneficiary Address performing the token purchase
435      * @param weiAmount Value in wei involved in the purchase
436      */
437     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
438         require(beneficiary != address(0));
439         require(weiAmount != 0);
440     }
441 
442     /**
443      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
444      * conditions are not met.
445      * @param beneficiary Address performing the token purchase
446      * @param weiAmount Value in wei involved in the purchase
447      */
448     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
449         // solhint-disable-previous-line no-empty-blocks
450     }
451 
452     /**
453      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
454      * its tokens.
455      * @param beneficiary Address performing the token purchase
456      * @param tokenAmount Number of tokens to be emitted
457      */
458     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
459         _token.safeTransfer(beneficiary, tokenAmount);
460     }
461 
462     /**
463      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
464      * tokens.
465      * @param beneficiary Address receiving the tokens
466      * @param tokenAmount Number of tokens to be purchased
467      */
468     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
469         _deliverTokens(beneficiary, tokenAmount);
470     }
471 
472     /**
473      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
474      * etc.)
475      * @param beneficiary Address receiving the tokens
476      * @param weiAmount Value in wei involved in the purchase
477      */
478     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
479         // solhint-disable-previous-line no-empty-blocks
480     }
481 
482     /**
483      * @dev Override to extend the way in which ether is converted to tokens.
484      * @param weiAmount Value in wei to be converted into tokens
485      * @return Number of tokens that can be purchased with the specified _weiAmount
486      */
487     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
488         return weiAmount.mul(_rate);
489     }
490 
491     /**
492      * @dev Determines how ETH is stored/forwarded on purchases.
493      */
494     function _forwardFunds() internal {
495         _wallet.transfer(msg.value);
496     }
497 }
498 
499 /**
500  * @title AllowanceCrowdsale
501  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
502  */
503 contract AllowanceCrowdsale is Crowdsale {
504     using SafeMath for uint256;
505     using SafeERC20 for IERC20;
506 
507     address private _tokenWallet;
508 
509     /**
510      * @dev Constructor, takes token wallet address.
511      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
512      */
513     constructor (address tokenWallet) public {
514         require(tokenWallet != address(0));
515         _tokenWallet = tokenWallet;
516     }
517 
518     /**
519      * @return the address of the wallet that will hold the tokens.
520      */
521     function tokenWallet() public view returns (address) {
522         return _tokenWallet;
523     }
524 
525     /**
526      * @dev Checks the amount of tokens left in the allowance.
527      * @return Amount of tokens left in the allowance
528      */
529     function remainingTokens() public view returns (uint256) {
530         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
531     }
532 
533     /**
534      * @dev Overrides parent behavior by transferring tokens from wallet.
535      * @param beneficiary Token purchaser
536      * @param tokenAmount Amount of tokens purchased
537      */
538     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
539         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
540     }
541 }
542 
543 /**
544  * @title TimedCrowdsale
545  * @dev Crowdsale accepting contributions only within a time frame.
546  */
547 contract TimedCrowdsale is Crowdsale {
548     using SafeMath for uint256;
549 
550     uint256 private _openingTime;
551     uint256 private _closingTime;
552 
553     /**
554      * @dev Reverts if not in crowdsale time range.
555      */
556     modifier onlyWhileOpen {
557         require(isOpen());
558         _;
559     }
560 
561     /**
562      * @dev Constructor, takes crowdsale opening and closing times.
563      * @param openingTime Crowdsale opening time
564      * @param closingTime Crowdsale closing time
565      */
566     constructor (uint256 openingTime, uint256 closingTime) public {
567         // solhint-disable-next-line not-rely-on-time
568         require(openingTime >= block.timestamp);
569         require(closingTime > openingTime);
570 
571         _openingTime = openingTime;
572         _closingTime = closingTime;
573     }
574 
575     /**
576      * @return the crowdsale opening time.
577      */
578     function openingTime() public view returns (uint256) {
579         return _openingTime;
580     }
581 
582     /**
583      * @return the crowdsale closing time.
584      */
585     function closingTime() public view returns (uint256) {
586         return _closingTime;
587     }
588 
589     /**
590      * @return true if the crowdsale is open, false otherwise.
591      */
592     function isOpen() public view returns (bool) {
593         // solhint-disable-next-line not-rely-on-time
594         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
595     }
596 
597     /**
598      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
599      * @return Whether crowdsale period has elapsed
600      */
601     function hasClosed() public view returns (bool) {
602         // solhint-disable-next-line not-rely-on-time
603         return block.timestamp > _closingTime;
604     }
605 
606     /**
607      * @dev Extend parent behavior requiring to be within contributing period
608      * @param beneficiary Token purchaser
609      * @param weiAmount Amount of wei contributed
610      */
611     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
612         super._preValidatePurchase(beneficiary, weiAmount);
613     }
614 }
615 
616 
617 /**
618  * @title SafeMath
619  * @dev Unsigned math operations with safety checks that revert on error
620  */
621 library SafeMath {
622     /**
623     * @dev Multiplies two unsigned integers, reverts on overflow.
624     */
625     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
626         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
627         // benefit is lost if 'b' is also tested.
628         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
629         if (a == 0) {
630             return 0;
631         }
632 
633         uint256 c = a * b;
634         require(c / a == b);
635 
636         return c;
637     }
638 
639     /**
640     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
641     */
642     function div(uint256 a, uint256 b) internal pure returns (uint256) {
643         // Solidity only automatically asserts when dividing by 0
644         require(b > 0);
645         uint256 c = a / b;
646         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
647 
648         return c;
649     }
650 
651     /**
652     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
653     */
654     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
655         require(b <= a);
656         uint256 c = a - b;
657 
658         return c;
659     }
660 
661     /**
662     * @dev Adds two unsigned integers, reverts on overflow.
663     */
664     function add(uint256 a, uint256 b) internal pure returns (uint256) {
665         uint256 c = a + b;
666         require(c >= a);
667 
668         return c;
669     }
670 
671     /**
672     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
673     * reverts when dividing by zero.
674     */
675     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
676         require(b != 0);
677         return a % b;
678     }
679 }
680 
681 /**
682  * @title Roles
683  * @dev Library for managing addresses assigned to a Role.
684  */
685 library Roles {
686     struct Role {
687         mapping (address => bool) bearer;
688     }
689 
690     /**
691      * @dev give an account access to this role
692      */
693     function add(Role storage role, address account) internal {
694         require(account != address(0));
695         require(!has(role, account));
696 
697         role.bearer[account] = true;
698     }
699 
700     /**
701      * @dev remove an account's access to this role
702      */
703     function remove(Role storage role, address account) internal {
704         require(account != address(0));
705         require(has(role, account));
706 
707         role.bearer[account] = false;
708     }
709 
710     /**
711      * @dev check if an account has this role
712      * @return bool
713      */
714     function has(Role storage role, address account) internal view returns (bool) {
715         require(account != address(0));
716         return role.bearer[account];
717     }
718 }
719 
720 
721 /**
722  * @title WhitelistAdminRole
723  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
724  */
725 contract WhitelistAdminRole {
726     using Roles for Roles.Role;
727 
728     event WhitelistAdminAdded(address indexed account);
729     event WhitelistAdminRemoved(address indexed account);
730 
731     Roles.Role private _whitelistAdmins;
732 
733     constructor () internal {
734         _addWhitelistAdmin(msg.sender);
735     }
736 
737     modifier onlyWhitelistAdmin() {
738         require(isWhitelistAdmin(msg.sender));
739         _;
740     }
741 
742     function isWhitelistAdmin(address account) public view returns (bool) {
743         return _whitelistAdmins.has(account);
744     }
745 
746     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
747         _addWhitelistAdmin(account);
748     }
749 
750     function renounceWhitelistAdmin() public {
751         _removeWhitelistAdmin(msg.sender);
752     }
753 
754     function _addWhitelistAdmin(address account) internal {
755         _whitelistAdmins.add(account);
756         emit WhitelistAdminAdded(account);
757     }
758 
759     function _removeWhitelistAdmin(address account) internal {
760         _whitelistAdmins.remove(account);
761         emit WhitelistAdminRemoved(account);
762     }
763 }
764 
765 
766 /**
767  * @title WhitelistedRole
768  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
769  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
770  * it), and not Whitelisteds themselves.
771  */
772 contract WhitelistedRole is WhitelistAdminRole {
773     using Roles for Roles.Role;
774 
775     event WhitelistedAdded(address indexed account);
776     event WhitelistedRemoved(address indexed account);
777 
778     Roles.Role private _whitelisteds;
779 
780     modifier onlyWhitelisted() {
781         require(isWhitelisted(msg.sender));
782         _;
783     }
784 
785     function isWhitelisted(address account) public view returns (bool) {
786         return _whitelisteds.has(account);
787     }
788 
789     function addWhitelisted(address account) public onlyWhitelistAdmin {
790         _addWhitelisted(account);
791     }
792 
793     function removeWhitelisted(address account) public onlyWhitelistAdmin {
794         _removeWhitelisted(account);
795     }
796 
797     function renounceWhitelisted() public {
798         _removeWhitelisted(msg.sender);
799     }
800 
801     function _addWhitelisted(address account) internal {
802         _whitelisteds.add(account);
803         emit WhitelistedAdded(account);
804     }
805 
806     function _removeWhitelisted(address account) internal {
807         _whitelisteds.remove(account);
808         emit WhitelistedRemoved(account);
809     }
810 }
811 
812 
813 contract KicksCrowdsale is Crowdsale, TimedCrowdsale, AllowanceCrowdsale, WhitelistedRole {
814 
815     using SafeMath for uint256;
816 
817     uint256 private _rate;
818 
819     uint256 private _kickCap = 33333333333333333333333333; // $50M
820     uint256 private _kickMinPay = 100 ether;
821     uint256 private _kickPurchased = 0;
822 
823     uint256 private _bonus20capBoundary = 800000000000000000000000; // $1.2M
824     uint256 private _bonus10capBoundary = 1533333333333333333333333; // $2.3M
825 
826     address private _manualSeller;
827     address private _rateSetter;
828     address private _whitelistAdmin;
829 
830     bool private _KYC = false;
831 
832     event Bonus(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
833     event ChangeRate(uint256 rate);
834 
835     constructor(
836         uint256 rate, // eth to kick rate
837         ERC20 token, // the kick token address
838         address payable wallet, // accumulation eth address
839         address tokenWallet, // kick storage address
840         address manualSeller, // can sell tokens
841         address rateSetter, // can change eth rate
842         uint256 openingTime,
843         uint256 closingTime
844     )
845     Crowdsale(rate, wallet, token)
846     AllowanceCrowdsale(tokenWallet)
847     TimedCrowdsale(openingTime, closingTime)
848     public
849     {
850         _rate = rate;
851         _manualSeller = manualSeller;
852         _rateSetter = rateSetter;
853         _whitelistAdmin = msg.sender;
854     }
855 
856 
857     /**
858      * Base crowdsale override
859      */
860     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
861         if (_KYC) {
862             require(isWhitelisted(beneficiary), 'Only whitelisted');
863         }
864         uint256 kickAmount = weiAmount.mul(_rate);
865         require(kickAmount >= _kickMinPay, 'Min purchase 100 kick');
866         require(_kickPurchased.add(kickAmount) <= _kickCap, 'Cap has been reached');
867         super._preValidatePurchase(beneficiary, weiAmount);
868     }
869 
870     function calcBonus(uint256 tokenAmount) internal view returns (uint256) {
871         uint256 bonus = 0;
872         if (_kickPurchased.add(tokenAmount) <= _bonus20capBoundary) {
873             bonus = tokenAmount.mul(20).div(100);
874         } else if (_kickPurchased.add(tokenAmount) <= _bonus10capBoundary) {
875             bonus = tokenAmount.mul(10).div(100);
876         }
877         return bonus;
878     }
879 
880     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
881         uint256 tokenAmount = weiAmount.mul(_rate);
882         return tokenAmount.add(calcBonus(tokenAmount));
883     }
884 
885     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
886         uint256 tokenAmount = weiAmount.mul(_rate);
887         uint256 bonus = calcBonus(tokenAmount);
888         if (bonus != 0) {
889             emit Bonus(msg.sender, beneficiary, weiAmount, bonus);
890             tokenAmount = tokenAmount.add(bonus);
891         }
892         _kickPurchased = _kickPurchased.add(tokenAmount);
893     }
894 
895 
896     /**
897      * Manual sell
898      */
899     function manualSell(address beneficiary, uint256 weiAmount) public onlyWhileOpen {
900         require(msg.sender == _manualSeller);
901         _preValidatePurchase(beneficiary, weiAmount);
902         uint256 tokens = _getTokenAmount(weiAmount);
903         _processPurchase(beneficiary, tokens);
904         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
905         _updatePurchasingState(beneficiary, weiAmount);
906         _postValidatePurchase(beneficiary, weiAmount);
907     }
908 
909 
910     /**
911      * Change eth rate
912      */
913     function setRate(uint256 rate) public {
914         require(msg.sender == _rateSetter);
915         _rate = rate;
916         emit ChangeRate(rate);
917     }
918 
919     /**
920      * Change KYC status
921      */
922     function onKYC() public {
923         require(msg.sender == _whitelistAdmin);
924         require(!_KYC);
925         _KYC = true;
926     }
927 
928     function offKYC() public {
929         require(msg.sender == _whitelistAdmin);
930         require(_KYC);
931         _KYC = false;
932     }
933 
934 
935     /**
936      * Getters
937      */
938     function rate() public view returns (uint256) {
939         return _rate;
940     }
941 
942     function kickCap() public view returns (uint256) {
943         return _kickCap;
944     }
945 
946     function kickMinPay() public view returns (uint256) {
947         return _kickMinPay;
948     }
949 
950     function kickPurchased() public view returns (uint256) {
951         return _kickPurchased;
952     }
953 
954     function bonus20capBoundary() public view returns (uint256) {
955         return _bonus20capBoundary;
956     }
957 
958     function bonus10capBoundary() public view returns (uint256) {
959         return _bonus10capBoundary;
960     }
961 
962     function KYC() public view returns (bool) {
963         return _KYC;
964     }
965 }