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
25 /**
26  * @title Math
27  * @dev Assorted math operations
28  */
29 library Math {
30     /**
31     * @dev Returns the largest of two numbers.
32     */
33     function max(uint256 a, uint256 b) internal pure returns (uint256) {
34         return a >= b ? a : b;
35     }
36 
37     /**
38     * @dev Returns the smallest of two numbers.
39     */
40     function min(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a < b ? a : b;
42     }
43 
44     /**
45     * @dev Calculates the average of two numbers. Since these are integers,
46     * averages of an even and odd number cannot be represented, and will be
47     * rounded down.
48     */
49     function average(uint256 a, uint256 b) internal pure returns (uint256) {
50         // (a + b) / 2 can overflow, so we distribute
51         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
52     }
53 }
54 
55 /**
56  * @title Roles
57  * @dev Library for managing addresses assigned to a Role.
58  */
59 library Roles {
60     struct Role {
61         mapping (address => bool) bearer;
62     }
63 
64     /**
65      * @dev give an account access to this role
66      */
67     function add(Role storage role, address account) internal {
68         require(account != address(0));
69         require(!has(role, account));
70 
71         role.bearer[account] = true;
72     }
73 
74     /**
75      * @dev remove an account's access to this role
76      */
77     function remove(Role storage role, address account) internal {
78         require(account != address(0));
79         require(has(role, account));
80 
81         role.bearer[account] = false;
82     }
83 
84     /**
85      * @dev check if an account has this role
86      * @return bool
87      */
88     function has(Role storage role, address account) internal view returns (bool) {
89         require(account != address(0));
90         return role.bearer[account];
91     }
92 }
93 
94 /**
95  * @title SafeERC20
96  * @dev Wrappers around ERC20 operations that throw on failure.
97  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
98  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
99  */
100 library SafeERC20 {
101     using SafeMath for uint256;
102 
103     function safeTransfer(IERC20 token, address to, uint256 value) internal {
104         require(token.transfer(to, value));
105     }
106 
107     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
108         require(token.transferFrom(from, to, value));
109     }
110 
111     function safeApprove(IERC20 token, address spender, uint256 value) internal {
112         // safeApprove should only be called when setting an initial allowance,
113         // or when resetting it to zero. To increase and decrease it, use
114         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
115         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
116         require(token.approve(spender, value));
117     }
118 
119     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
120         uint256 newAllowance = token.allowance(address(this), spender).add(value);
121         require(token.approve(spender, newAllowance));
122     }
123 
124     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
125         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
126         require(token.approve(spender, newAllowance));
127     }
128 }
129 
130 /**
131  * @title SafeMath
132  * @dev Unsigned math operations with safety checks that revert on error
133 */
134 library SafeMath {
135     /**
136     * @dev Multiplies two unsigned integers, reverts on overflow.
137     */
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
140         // benefit is lost if 'b' is also tested.
141         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
142         if (a == 0) {
143             return 0;
144         }
145 
146         uint256 c = a * b;
147         require(c / a == b);
148 
149         return c;
150     }
151 
152     /**
153     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
154     */
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Solidity only automatically asserts when dividing by 0
157         require(b > 0);
158         uint256 c = a / b;
159         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160 
161         return c;
162     }
163 
164     /**
165     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
166     */
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         require(b <= a);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175     * @dev Adds two unsigned integers, reverts on overflow.
176     */
177     function add(uint256 a, uint256 b) internal pure returns (uint256) {
178         uint256 c = a + b;
179         require(c >= a);
180 
181         return c;
182     }
183 
184     /**
185     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
186     * reverts when dividing by zero.
187     */
188     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b != 0);
190         return a % b;
191     }
192 }
193 
194 /**
195  * @title Standard ERC20 token
196  *
197  * @dev Implementation of the basic standard token.
198  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
199  * Originally based on code by FirstBlood:
200  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  *
202  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
203  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
204  * compliant implementations may not do it.
205  */
206 contract ERC20 is IERC20 {
207     using SafeMath for uint256;
208 
209     mapping (address => uint256) private _balances;
210 
211     mapping (address => mapping (address => uint256)) private _allowed;
212 
213     uint256 private _totalSupply;
214 
215     /**
216     * @dev Total number of tokens in existence
217     */
218     function totalSupply() public view returns (uint256) {
219         return _totalSupply;
220     }
221 
222     /**
223     * @dev Gets the balance of the specified address.
224     * @param owner The address to query the balance of.
225     * @return An uint256 representing the amount owned by the passed address.
226     */
227     function balanceOf(address owner) public view returns (uint256) {
228         return _balances[owner];
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens that an owner allowed to a spender.
233      * @param owner address The address which owns the funds.
234      * @param spender address The address which will spend the funds.
235      * @return A uint256 specifying the amount of tokens still available for the spender.
236      */
237     function allowance(address owner, address spender) public view returns (uint256) {
238         return _allowed[owner][spender];
239     }
240 
241     /**
242     * @dev Transfer token for a specified address
243     * @param to The address to transfer to.
244     * @param value The amount to be transferred.
245     */
246     function transfer(address to, uint256 value) public returns (bool) {
247         _transfer(msg.sender, to, value);
248         return true;
249     }
250 
251     /**
252      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253      * Beware that changing an allowance with this method brings the risk that someone may use both the old
254      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257      * @param spender The address which will spend the funds.
258      * @param value The amount of tokens to be spent.
259      */
260     function approve(address spender, uint256 value) public returns (bool) {
261         require(spender != address(0));
262 
263         _allowed[msg.sender][spender] = value;
264         emit Approval(msg.sender, spender, value);
265         return true;
266     }
267 
268     /**
269      * @dev Transfer tokens from one address to another.
270      * Note that while this function emits an Approval event, this is not required as per the specification,
271      * and other compliant implementations may not emit the event.
272      * @param from address The address which you want to send tokens from
273      * @param to address The address which you want to transfer to
274      * @param value uint256 the amount of tokens to be transferred
275      */
276     function transferFrom(address from, address to, uint256 value) public returns (bool) {
277         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
278         _transfer(from, to, value);
279         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
280         return true;
281     }
282 
283     /**
284      * @dev Increase the amount of tokens that an owner allowed to a spender.
285      * approve should be called when allowed_[_spender] == 0. To increment
286      * allowed value is better to use this function to avoid 2 calls (and wait until
287      * the first transaction is mined)
288      * From MonolithDAO Token.sol
289      * Emits an Approval event.
290      * @param spender The address which will spend the funds.
291      * @param addedValue The amount of tokens to increase the allowance by.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
294         require(spender != address(0));
295 
296         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
297         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
298         return true;
299     }
300 
301     /**
302      * @dev Decrease the amount of tokens that an owner allowed to a spender.
303      * approve should be called when allowed_[_spender] == 0. To decrement
304      * allowed value is better to use this function to avoid 2 calls (and wait until
305      * the first transaction is mined)
306      * From MonolithDAO Token.sol
307      * Emits an Approval event.
308      * @param spender The address which will spend the funds.
309      * @param subtractedValue The amount of tokens to decrease the allowance by.
310      */
311     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
312         require(spender != address(0));
313 
314         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
315         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
316         return true;
317     }
318 
319     /**
320     * @dev Transfer token for a specified addresses
321     * @param from The address to transfer from.
322     * @param to The address to transfer to.
323     * @param value The amount to be transferred.
324     */
325     function _transfer(address from, address to, uint256 value) internal {
326         require(to != address(0));
327 
328         _balances[from] = _balances[from].sub(value);
329         _balances[to] = _balances[to].add(value);
330         emit Transfer(from, to, value);
331     }
332 
333     /**
334      * @dev Internal function that mints an amount of the token and assigns it to
335      * an account. This encapsulates the modification of balances such that the
336      * proper events are emitted.
337      * @param account The account that will receive the created tokens.
338      * @param value The amount that will be created.
339      */
340     function _mint(address account, uint256 value) internal {
341         require(account != address(0));
342 
343         _totalSupply = _totalSupply.add(value);
344         _balances[account] = _balances[account].add(value);
345         emit Transfer(address(0), account, value);
346     }
347 
348     /**
349      * @dev Internal function that burns an amount of the token of a given
350      * account.
351      * @param account The account whose tokens will be burnt.
352      * @param value The amount that will be burnt.
353      */
354     function _burn(address account, uint256 value) internal {
355         require(account != address(0));
356 
357         _totalSupply = _totalSupply.sub(value);
358         _balances[account] = _balances[account].sub(value);
359         emit Transfer(account, address(0), value);
360     }
361 
362     /**
363      * @dev Internal function that burns an amount of the token of a given
364      * account, deducting from the sender's allowance for said account. Uses the
365      * internal burn function.
366      * Emits an Approval event (reflecting the reduced allowance).
367      * @param account The account whose tokens will be burnt.
368      * @param value The amount that will be burnt.
369      */
370     function _burnFrom(address account, uint256 value) internal {
371         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
372         _burn(account, value);
373         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
374     }
375 }
376 
377 /**
378  * @title Helps contracts guard against reentrancy attacks.
379  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
380  * @dev If you mark a function `nonReentrant`, you should also
381  * mark it `external`.
382  */
383 contract ReentrancyGuard {
384     /// @dev counter to allow mutex lock with only one SSTORE operation
385     uint256 private _guardCounter;
386 
387     constructor () internal {
388         // The counter starts at one to prevent changing it from zero to a non-zero
389         // value, which is a more expensive operation.
390         _guardCounter = 1;
391     }
392 
393     /**
394      * @dev Prevents a contract from calling itself, directly or indirectly.
395      * Calling a `nonReentrant` function from another `nonReentrant`
396      * function is not supported. It is possible to prevent this from happening
397      * by making the `nonReentrant` function external, and make it call a
398      * `private` function that does the actual work.
399      */
400     modifier nonReentrant() {
401         _guardCounter += 1;
402         uint256 localCounter = _guardCounter;
403         _;
404         require(localCounter == _guardCounter);
405     }
406 }
407 
408 /**
409  * @title Crowdsale
410  * @dev Crowdsale is a base contract for managing a token crowdsale,
411  * allowing investors to purchase tokens with ether. This contract implements
412  * such functionality in its most fundamental form and can be extended to provide additional
413  * functionality and/or custom behavior.
414  * The external interface represents the basic interface for purchasing tokens, and conform
415  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
416  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
417  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
418  * behavior.
419  */
420 contract Crowdsale is ReentrancyGuard {
421     using SafeMath for uint256;
422     using SafeERC20 for IERC20;
423 
424     // The token being sold
425     IERC20 private _token;
426 
427     // Address where funds are collected
428     address payable private _wallet;
429 
430     // How many token units a buyer gets per wei.
431     // The rate is the conversion between wei and the smallest and indivisible token unit.
432     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
433     // 1 wei will give you 1 unit, or 0.001 TOK.
434     uint256 private _rate;
435 
436     // Amount of wei raised
437     uint256 private _weiRaised;
438 
439     /**
440      * Event for token purchase logging
441      * @param purchaser who paid for the tokens
442      * @param beneficiary who got the tokens
443      * @param value weis paid for purchase
444      * @param amount amount of tokens purchased
445      */
446     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
447 
448     /**
449      * @param rate Number of token units a buyer gets per wei
450      * @dev The rate is the conversion between wei and the smallest and indivisible
451      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
452      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
453      * @param wallet Address where collected funds will be forwarded to
454      * @param token Address of the token being sold
455      */
456     constructor (uint256 rate, address payable wallet, IERC20 token) public {
457         require(rate > 0);
458         require(wallet != address(0));
459         require(address(token) != address(0));
460 
461         _rate = rate;
462         _wallet = wallet;
463         _token = token;
464     }
465 
466     /**
467      * @dev fallback function ***DO NOT OVERRIDE***
468      * Note that other contracts will transfer fund with a base gas stipend
469      * of 2300, which is not enough to call buyTokens. Consider calling
470      * buyTokens directly when purchasing tokens from a contract.
471      */
472     function () external payable {
473         buyTokens(msg.sender);
474     }
475 
476     /**
477      * @return the token being sold.
478      */
479     function token() public view returns (IERC20) {
480         return _token;
481     }
482 
483     /**
484      * @return the address where funds are collected.
485      */
486     function wallet() public view returns (address payable) {
487         return _wallet;
488     }
489 
490     /**
491      * @return the number of token units a buyer gets per wei.
492      */
493     function rate() public view returns (uint256) {
494         return _rate;
495     }
496 
497     /**
498      * @return the amount of wei raised.
499      */
500     function weiRaised() public view returns (uint256) {
501         return _weiRaised;
502     }
503 
504     /**
505      * @dev low level token purchase ***DO NOT OVERRIDE***
506      * This function has a non-reentrancy guard, so it shouldn't be called by
507      * another `nonReentrant` function.
508      * @param beneficiary Recipient of the token purchase
509      */
510     function buyTokens(address beneficiary) public nonReentrant payable {
511         uint256 weiAmount = msg.value;
512         _preValidatePurchase(beneficiary, weiAmount);
513 
514         // calculate token amount to be created
515         uint256 tokens = _getTokenAmount(weiAmount);
516 
517         // update state
518         _weiRaised = _weiRaised.add(weiAmount);
519 
520         _processPurchase(beneficiary, tokens);
521         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
522 
523         _updatePurchasingState(beneficiary, weiAmount);
524 
525         _forwardFunds();
526         _postValidatePurchase(beneficiary, weiAmount);
527     }
528 
529     /**
530      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
531      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
532      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
533      *     super._preValidatePurchase(beneficiary, weiAmount);
534      *     require(weiRaised().add(weiAmount) <= cap);
535      * @param beneficiary Address performing the token purchase
536      * @param weiAmount Value in wei involved in the purchase
537      */
538     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
539         require(beneficiary != address(0));
540         require(weiAmount != 0);
541     }
542 
543     /**
544      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
545      * conditions are not met.
546      * @param beneficiary Address performing the token purchase
547      * @param weiAmount Value in wei involved in the purchase
548      */
549     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
550         // solhint-disable-previous-line no-empty-blocks
551     }
552 
553     /**
554      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
555      * its tokens.
556      * @param beneficiary Address performing the token purchase
557      * @param tokenAmount Number of tokens to be emitted
558      */
559     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
560         _token.safeTransfer(beneficiary, tokenAmount);
561     }
562 
563     /**
564      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
565      * tokens.
566      * @param beneficiary Address receiving the tokens
567      * @param tokenAmount Number of tokens to be purchased
568      */
569     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
570         _deliverTokens(beneficiary, tokenAmount);
571     }
572 
573     /**
574      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
575      * etc.)
576      * @param beneficiary Address receiving the tokens
577      * @param weiAmount Value in wei involved in the purchase
578      */
579     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
580         // solhint-disable-previous-line no-empty-blocks
581     }
582 
583     /**
584      * @dev Override to extend the way in which ether is converted to tokens.
585      * @param weiAmount Value in wei to be converted into tokens
586      * @return Number of tokens that can be purchased with the specified _weiAmount
587      */
588     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
589         return weiAmount.mul(_rate);
590     }
591 
592     /**
593      * @dev Determines how ETH is stored/forwarded on purchases.
594      */
595     function _forwardFunds() internal {
596         _wallet.transfer(msg.value);
597     }
598 }
599 
600 /**
601  * @title AllowanceCrowdsale
602  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
603  */
604 contract AllowanceCrowdsale is Crowdsale {
605     using SafeMath for uint256;
606     using SafeERC20 for IERC20;
607 
608     address private _tokenWallet;
609 
610     /**
611      * @dev Constructor, takes token wallet address.
612      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
613      */
614     constructor (address tokenWallet) public {
615         require(tokenWallet != address(0));
616         _tokenWallet = tokenWallet;
617     }
618 
619     /**
620      * @return the address of the wallet that will hold the tokens.
621      */
622     function tokenWallet() public view returns (address) {
623         return _tokenWallet;
624     }
625 
626     /**
627      * @dev Checks the amount of tokens left in the allowance.
628      * @return Amount of tokens left in the allowance
629      */
630     function remainingTokens() public view returns (uint256) {
631         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
632     }
633 
634     /**
635      * @dev Overrides parent behavior by transferring tokens from wallet.
636      * @param beneficiary Token purchaser
637      * @param tokenAmount Amount of tokens purchased
638      */
639     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
640         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
641     }
642 }
643 
644 /**
645  * @title WhitelistAdminRole
646  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
647  */
648 contract WhitelistAdminRole {
649     using Roles for Roles.Role;
650 
651     event WhitelistAdminAdded(address indexed account);
652     event WhitelistAdminRemoved(address indexed account);
653 
654     Roles.Role private _whitelistAdmins;
655 
656     constructor () internal {
657         _addWhitelistAdmin(msg.sender);
658     }
659 
660     modifier onlyWhitelistAdmin() {
661         require(isWhitelistAdmin(msg.sender));
662         _;
663     }
664 
665     function isWhitelistAdmin(address account) public view returns (bool) {
666         return _whitelistAdmins.has(account);
667     }
668 
669     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
670         _addWhitelistAdmin(account);
671     }
672 
673     function renounceWhitelistAdmin() public {
674         _removeWhitelistAdmin(msg.sender);
675     }
676 
677     function _addWhitelistAdmin(address account) internal {
678         _whitelistAdmins.add(account);
679         emit WhitelistAdminAdded(account);
680     }
681 
682     function _removeWhitelistAdmin(address account) internal {
683         _whitelistAdmins.remove(account);
684         emit WhitelistAdminRemoved(account);
685     }
686 }
687 
688 /**
689  * @title WhitelistedRole
690  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
691  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
692  * it), and not Whitelisteds themselves.
693  */
694 contract WhitelistedRole is WhitelistAdminRole {
695     using Roles for Roles.Role;
696 
697     event WhitelistedAdded(address indexed account);
698     event WhitelistedRemoved(address indexed account);
699 
700     Roles.Role private _whitelisteds;
701 
702     modifier onlyWhitelisted() {
703         require(isWhitelisted(msg.sender));
704         _;
705     }
706 
707     function isWhitelisted(address account) public view returns (bool) {
708         return _whitelisteds.has(account);
709     }
710 
711     function addWhitelisted(address account) public onlyWhitelistAdmin {
712         _addWhitelisted(account);
713     }
714 
715     function removeWhitelisted(address account) public onlyWhitelistAdmin {
716         _removeWhitelisted(account);
717     }
718 
719     function renounceWhitelisted() public {
720         _removeWhitelisted(msg.sender);
721     }
722 
723     function _addWhitelisted(address account) internal {
724         _whitelisteds.add(account);
725         emit WhitelistedAdded(account);
726     }
727 
728     function _removeWhitelisted(address account) internal {
729         _whitelisteds.remove(account);
730         emit WhitelistedRemoved(account);
731     }
732 }
733 
734 
735 contract KicksCrowdsale is Crowdsale, AllowanceCrowdsale, WhitelistedRole {
736 
737     using SafeMath for uint256;
738 
739     uint256 private _rate;
740 
741     uint256 private _kickMinPay = 100 ether;
742 
743     address private _manualSeller;
744     address private _rateSetter;
745     address private _whitelistAdmin;
746 
747     bool private _KYC = true;
748     bool private _running = true;
749 
750     event ChangeRate(uint256 rate);
751 
752     constructor(
753         uint256 rate, // eth to kick rate
754         ERC20 token, // the kick token address
755         address payable wallet, // accumulation eth address
756         address tokenWallet, // kick storage address
757         address manualSeller, // can sell tokens
758         address rateSetter // can change eth rate
759     )
760     Crowdsale(rate, wallet, token)
761     AllowanceCrowdsale(tokenWallet)
762     public
763     {
764         _rate = rate;
765         _manualSeller = manualSeller;
766         _rateSetter = rateSetter;
767         _whitelistAdmin = msg.sender;
768     }
769 
770     /**
771      * Base crowdsale override
772      */
773     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
774         require(!_running, 'Closed');
775         if (_KYC) {
776             require(isWhitelisted(beneficiary), 'Only whitelisted');
777         }
778         uint256 kickAmount = weiAmount.mul(_rate);
779         require(kickAmount >= _kickMinPay, 'Min purchase 100 kick');
780         super._preValidatePurchase(beneficiary, weiAmount);
781     }
782 
783     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
784         uint256 tokenAmount = weiAmount.mul(_rate);
785         return tokenAmount;
786     }
787 
788     /**
789      * Manual sell
790      */
791     function manualSell(address beneficiary, uint256 weiAmount) public {
792         require(msg.sender == _manualSeller);
793         _preValidatePurchase(beneficiary, weiAmount);
794         uint256 tokens = _getTokenAmount(weiAmount);
795         _processPurchase(beneficiary, tokens);
796         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
797         _updatePurchasingState(beneficiary, weiAmount);
798         _postValidatePurchase(beneficiary, weiAmount);
799     }
800 
801 
802     /**
803      * Change eth rate
804      */
805     function setRate(uint256 rate) public {
806         require(msg.sender == _rateSetter);
807         _rate = rate;
808         emit ChangeRate(rate);
809     }
810 
811     /**
812      * Change KYC status
813      */
814     function onKYC() public {
815         require(msg.sender == _whitelistAdmin);
816         require(!_KYC);
817         _KYC = true;
818     }
819 
820     function offKYC() public {
821         require(msg.sender == _whitelistAdmin);
822         require(_KYC);
823         _KYC = false;
824     }
825 
826 
827     /**
828      * Change KYC status
829      */
830     function onRunning() public {
831         require(msg.sender == _whitelistAdmin);
832         require(!_running);
833         _running = true;
834     }
835 
836     function offRunning() public {
837         require(msg.sender == _whitelistAdmin);
838         require(_running);
839         _running = false;
840     }
841 
842 
843     /**
844      * Getters
845      */
846     function rate() public view returns (uint256) {
847         return _rate;
848     }
849 
850     function kickMinPay() public view returns (uint256) {
851         return _kickMinPay;
852     }
853 
854     function KYC() public view returns (bool) {
855         return _KYC;
856     }
857 
858     function running() public view returns (bool) {
859         return _running;
860     }
861 }