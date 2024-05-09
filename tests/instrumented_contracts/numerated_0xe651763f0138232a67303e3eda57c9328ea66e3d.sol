1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.2;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/utils/Address.sol
96 
97 pragma solidity ^0.5.2;
98 
99 /**
100  * Utility library of inline functions on addresses
101  */
102 library Address {
103     /**
104      * Returns whether the target address is a contract
105      * @dev This function will return false if invoked during the constructor of a contract,
106      * as the code is not actually created until after the constructor finishes.
107      * @param account address of the account to check
108      * @return whether the target address is a contract
109      */
110     function isContract(address account) internal view returns (bool) {
111         uint256 size;
112         // XXX Currently there is no better way to check if there is a contract in an address
113         // than to check the size of the code at that address.
114         // See https://ethereum.stackexchange.com/a/14016/36603
115         // for more details about how this works.
116         // TODO Check this again before the Serenity release, because all addresses will be
117         // contracts then.
118         // solhint-disable-next-line no-inline-assembly
119         assembly { size := extcodesize(account) }
120         return size > 0;
121     }
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
125 
126 pragma solidity ^0.5.2;
127 
128 
129 
130 
131 /**
132  * @title SafeERC20
133  * @dev Wrappers around ERC20 operations that throw on failure (when the token
134  * contract returns false). Tokens that return no value (and instead revert or
135  * throw on failure) are also supported, non-reverting calls are assumed to be
136  * successful.
137  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
138  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
139  */
140 library SafeERC20 {
141     using SafeMath for uint256;
142     using Address for address;
143 
144     function safeTransfer(IERC20 token, address to, uint256 value) internal {
145         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
146     }
147 
148     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
149         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
150     }
151 
152     function safeApprove(IERC20 token, address spender, uint256 value) internal {
153         // safeApprove should only be called when setting an initial allowance,
154         // or when resetting it to zero. To increase and decrease it, use
155         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
156         require((value == 0) || (token.allowance(address(this), spender) == 0));
157         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
158     }
159 
160     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
161         uint256 newAllowance = token.allowance(address(this), spender).add(value);
162         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
163     }
164 
165     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
166         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
167         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
168     }
169 
170     /**
171      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
172      * on the return value: the return value is optional (but if data is returned, it must equal true).
173      * @param token The token targeted by the call.
174      * @param data The call data (encoded using abi.encode or one of its variants).
175      */
176     function callOptionalReturn(IERC20 token, bytes memory data) private {
177         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
178         // we're implementing it ourselves.
179 
180         // A Solidity high level call has three parts:
181         //  1. The target address is checked to verify it contains contract code
182         //  2. The call itself is made, and success asserted
183         //  3. The return value is decoded, which in turn checks the size of the returned data.
184 
185         require(address(token).isContract());
186 
187         // solhint-disable-next-line avoid-low-level-calls
188         (bool success, bytes memory returndata) = address(token).call(data);
189         require(success);
190 
191         if (returndata.length > 0) { // Return data is optional
192             require(abi.decode(returndata, (bool)));
193         }
194     }
195 }
196 
197 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
198 
199 pragma solidity ^0.5.2;
200 
201 /**
202  * @title Helps contracts guard against reentrancy attacks.
203  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
204  * @dev If you mark a function `nonReentrant`, you should also
205  * mark it `external`.
206  */
207 contract ReentrancyGuard {
208     /// @dev counter to allow mutex lock with only one SSTORE operation
209     uint256 private _guardCounter;
210 
211     constructor () internal {
212         // The counter starts at one to prevent changing it from zero to a non-zero
213         // value, which is a more expensive operation.
214         _guardCounter = 1;
215     }
216 
217     /**
218      * @dev Prevents a contract from calling itself, directly or indirectly.
219      * Calling a `nonReentrant` function from another `nonReentrant`
220      * function is not supported. It is possible to prevent this from happening
221      * by making the `nonReentrant` function external, and make it call a
222      * `private` function that does the actual work.
223      */
224     modifier nonReentrant() {
225         _guardCounter += 1;
226         uint256 localCounter = _guardCounter;
227         _;
228         require(localCounter == _guardCounter);
229     }
230 }
231 
232 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
233 
234 pragma solidity ^0.5.2;
235 
236 
237 
238 
239 
240 /**
241  * @title Crowdsale
242  * @dev Crowdsale is a base contract for managing a token crowdsale,
243  * allowing investors to purchase tokens with ether. This contract implements
244  * such functionality in its most fundamental form and can be extended to provide additional
245  * functionality and/or custom behavior.
246  * The external interface represents the basic interface for purchasing tokens, and conforms
247  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
248  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
249  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
250  * behavior.
251  */
252 contract Crowdsale is ReentrancyGuard {
253     using SafeMath for uint256;
254     using SafeERC20 for IERC20;
255 
256     // The token being sold
257     IERC20 private _token;
258 
259     // Address where funds are collected
260     address payable private _wallet;
261 
262     // How many token units a buyer gets per wei.
263     // The rate is the conversion between wei and the smallest and indivisible token unit.
264     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
265     // 1 wei will give you 1 unit, or 0.001 TOK.
266     uint256 private _rate;
267 
268     // Amount of wei raised
269     uint256 private _weiRaised;
270 
271     /**
272      * Event for token purchase logging
273      * @param purchaser who paid for the tokens
274      * @param beneficiary who got the tokens
275      * @param value weis paid for purchase
276      * @param amount amount of tokens purchased
277      */
278     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
279 
280     /**
281      * @param rate Number of token units a buyer gets per wei
282      * @dev The rate is the conversion between wei and the smallest and indivisible
283      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
284      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
285      * @param wallet Address where collected funds will be forwarded to
286      * @param token Address of the token being sold
287      */
288     constructor (uint256 rate, address payable wallet, IERC20 token) public {
289         require(rate > 0);
290         require(wallet != address(0));
291         require(address(token) != address(0));
292 
293         _rate = rate;
294         _wallet = wallet;
295         _token = token;
296     }
297 
298     /**
299      * @dev fallback function ***DO NOT OVERRIDE***
300      * Note that other contracts will transfer funds with a base gas stipend
301      * of 2300, which is not enough to call buyTokens. Consider calling
302      * buyTokens directly when purchasing tokens from a contract.
303      */
304     function () external payable {
305         buyTokens(msg.sender);
306     }
307 
308     /**
309      * @return the token being sold.
310      */
311     function token() public view returns (IERC20) {
312         return _token;
313     }
314 
315     /**
316      * @return the address where funds are collected.
317      */
318     function wallet() public view returns (address payable) {
319         return _wallet;
320     }
321 
322     /**
323      * @return the number of token units a buyer gets per wei.
324      */
325     function rate() public view returns (uint256) {
326         return _rate;
327     }
328 
329     /**
330      * @return the amount of wei raised.
331      */
332     function weiRaised() public view returns (uint256) {
333         return _weiRaised;
334     }
335 
336     /**
337      * @dev low level token purchase ***DO NOT OVERRIDE***
338      * This function has a non-reentrancy guard, so it shouldn't be called by
339      * another `nonReentrant` function.
340      * @param beneficiary Recipient of the token purchase
341      */
342     function buyTokens(address beneficiary) public nonReentrant payable {
343         uint256 weiAmount = msg.value;
344         _preValidatePurchase(beneficiary, weiAmount);
345 
346         // calculate token amount to be created
347         uint256 tokens = _getTokenAmount(weiAmount);
348 
349         // update state
350         _weiRaised = _weiRaised.add(weiAmount);
351 
352         _processPurchase(beneficiary, tokens);
353         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
354 
355         _updatePurchasingState(beneficiary, weiAmount);
356 
357         _forwardFunds();
358         _postValidatePurchase(beneficiary, weiAmount);
359     }
360 
361     /**
362      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
363      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
364      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
365      *     super._preValidatePurchase(beneficiary, weiAmount);
366      *     require(weiRaised().add(weiAmount) <= cap);
367      * @param beneficiary Address performing the token purchase
368      * @param weiAmount Value in wei involved in the purchase
369      */
370     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
371         require(beneficiary != address(0));
372         require(weiAmount != 0);
373     }
374 
375     /**
376      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
377      * conditions are not met.
378      * @param beneficiary Address performing the token purchase
379      * @param weiAmount Value in wei involved in the purchase
380      */
381     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
382         // solhint-disable-previous-line no-empty-blocks
383     }
384 
385     /**
386      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
387      * its tokens.
388      * @param beneficiary Address performing the token purchase
389      * @param tokenAmount Number of tokens to be emitted
390      */
391     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
392         _token.safeTransfer(beneficiary, tokenAmount);
393     }
394 
395     /**
396      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
397      * tokens.
398      * @param beneficiary Address receiving the tokens
399      * @param tokenAmount Number of tokens to be purchased
400      */
401     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
402         _deliverTokens(beneficiary, tokenAmount);
403     }
404 
405     /**
406      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
407      * etc.)
408      * @param beneficiary Address receiving the tokens
409      * @param weiAmount Value in wei involved in the purchase
410      */
411     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
412         // solhint-disable-previous-line no-empty-blocks
413     }
414 
415     /**
416      * @dev Override to extend the way in which ether is converted to tokens.
417      * @param weiAmount Value in wei to be converted into tokens
418      * @return Number of tokens that can be purchased with the specified _weiAmount
419      */
420     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
421         return weiAmount.mul(_rate);
422     }
423 
424     /**
425      * @dev Determines how ETH is stored/forwarded on purchases.
426      */
427     function _forwardFunds() internal {
428         _wallet.transfer(msg.value);
429     }
430 }
431 
432 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
433 
434 pragma solidity ^0.5.2;
435 
436 
437 
438 /**
439  * @title TimedCrowdsale
440  * @dev Crowdsale accepting contributions only within a time frame.
441  */
442 contract TimedCrowdsale is Crowdsale {
443     using SafeMath for uint256;
444 
445     uint256 private _openingTime;
446     uint256 private _closingTime;
447 
448     /**
449      * Event for crowdsale extending
450      * @param newClosingTime new closing time
451      * @param prevClosingTime old closing time
452      */
453     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
454 
455     /**
456      * @dev Reverts if not in crowdsale time range.
457      */
458     modifier onlyWhileOpen {
459         require(isOpen());
460         _;
461     }
462 
463     /**
464      * @dev Constructor, takes crowdsale opening and closing times.
465      * @param openingTime Crowdsale opening time
466      * @param closingTime Crowdsale closing time
467      */
468     constructor (uint256 openingTime, uint256 closingTime) public {
469         // solhint-disable-next-line not-rely-on-time
470         require(openingTime >= block.timestamp);
471         require(closingTime > openingTime);
472 
473         _openingTime = openingTime;
474         _closingTime = closingTime;
475     }
476 
477     /**
478      * @return the crowdsale opening time.
479      */
480     function openingTime() public view returns (uint256) {
481         return _openingTime;
482     }
483 
484     /**
485      * @return the crowdsale closing time.
486      */
487     function closingTime() public view returns (uint256) {
488         return _closingTime;
489     }
490 
491     /**
492      * @return true if the crowdsale is open, false otherwise.
493      */
494     function isOpen() public view returns (bool) {
495         // solhint-disable-next-line not-rely-on-time
496         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
497     }
498 
499     /**
500      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
501      * @return Whether crowdsale period has elapsed
502      */
503     function hasClosed() public view returns (bool) {
504         // solhint-disable-next-line not-rely-on-time
505         return block.timestamp > _closingTime;
506     }
507 
508     /**
509      * @dev Extend parent behavior requiring to be within contributing period
510      * @param beneficiary Token purchaser
511      * @param weiAmount Amount of wei contributed
512      */
513     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
514         super._preValidatePurchase(beneficiary, weiAmount);
515     }
516 
517     /**
518      * @dev Extend crowdsale
519      * @param newClosingTime Crowdsale closing time
520      */
521     function _extendTime(uint256 newClosingTime) internal {
522         require(!hasClosed());
523         require(newClosingTime > _closingTime);
524 
525         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
526         _closingTime = newClosingTime;
527     }
528 }
529 
530 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
531 
532 pragma solidity ^0.5.2;
533 
534 
535 
536 /**
537  * @title CappedCrowdsale
538  * @dev Crowdsale with a limit for total contributions.
539  */
540 contract CappedCrowdsale is Crowdsale {
541     using SafeMath for uint256;
542 
543     uint256 private _cap;
544 
545     /**
546      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
547      * @param cap Max amount of wei to be contributed
548      */
549     constructor (uint256 cap) public {
550         require(cap > 0);
551         _cap = cap;
552     }
553 
554     /**
555      * @return the cap of the crowdsale.
556      */
557     function cap() public view returns (uint256) {
558         return _cap;
559     }
560 
561     /**
562      * @dev Checks whether the cap has been reached.
563      * @return Whether the cap was reached
564      */
565     function capReached() public view returns (bool) {
566         return weiRaised() >= _cap;
567     }
568 
569     /**
570      * @dev Extend parent behavior requiring purchase to respect the funding cap.
571      * @param beneficiary Token purchaser
572      * @param weiAmount Amount of wei contributed
573      */
574     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
575         super._preValidatePurchase(beneficiary, weiAmount);
576         require(weiRaised().add(weiAmount) <= _cap);
577     }
578 }
579 
580 // File: openzeppelin-solidity/contracts/access/Roles.sol
581 
582 pragma solidity ^0.5.2;
583 
584 /**
585  * @title Roles
586  * @dev Library for managing addresses assigned to a Role.
587  */
588 library Roles {
589     struct Role {
590         mapping (address => bool) bearer;
591     }
592 
593     /**
594      * @dev give an account access to this role
595      */
596     function add(Role storage role, address account) internal {
597         require(account != address(0));
598         require(!has(role, account));
599 
600         role.bearer[account] = true;
601     }
602 
603     /**
604      * @dev remove an account's access to this role
605      */
606     function remove(Role storage role, address account) internal {
607         require(account != address(0));
608         require(has(role, account));
609 
610         role.bearer[account] = false;
611     }
612 
613     /**
614      * @dev check if an account has this role
615      * @return bool
616      */
617     function has(Role storage role, address account) internal view returns (bool) {
618         require(account != address(0));
619         return role.bearer[account];
620     }
621 }
622 
623 // File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
624 
625 pragma solidity ^0.5.2;
626 
627 
628 /**
629  * @title WhitelistAdminRole
630  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
631  */
632 contract WhitelistAdminRole {
633     using Roles for Roles.Role;
634 
635     event WhitelistAdminAdded(address indexed account);
636     event WhitelistAdminRemoved(address indexed account);
637 
638     Roles.Role private _whitelistAdmins;
639 
640     constructor () internal {
641         _addWhitelistAdmin(msg.sender);
642     }
643 
644     modifier onlyWhitelistAdmin() {
645         require(isWhitelistAdmin(msg.sender));
646         _;
647     }
648 
649     function isWhitelistAdmin(address account) public view returns (bool) {
650         return _whitelistAdmins.has(account);
651     }
652 
653     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
654         _addWhitelistAdmin(account);
655     }
656 
657     function renounceWhitelistAdmin() public {
658         _removeWhitelistAdmin(msg.sender);
659     }
660 
661     function _addWhitelistAdmin(address account) internal {
662         _whitelistAdmins.add(account);
663         emit WhitelistAdminAdded(account);
664     }
665 
666     function _removeWhitelistAdmin(address account) internal {
667         _whitelistAdmins.remove(account);
668         emit WhitelistAdminRemoved(account);
669     }
670 }
671 
672 // File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
673 
674 pragma solidity ^0.5.2;
675 
676 
677 
678 /**
679  * @title WhitelistedRole
680  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
681  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
682  * it), and not Whitelisteds themselves.
683  */
684 contract WhitelistedRole is WhitelistAdminRole {
685     using Roles for Roles.Role;
686 
687     event WhitelistedAdded(address indexed account);
688     event WhitelistedRemoved(address indexed account);
689 
690     Roles.Role private _whitelisteds;
691 
692     modifier onlyWhitelisted() {
693         require(isWhitelisted(msg.sender));
694         _;
695     }
696 
697     function isWhitelisted(address account) public view returns (bool) {
698         return _whitelisteds.has(account);
699     }
700 
701     function addWhitelisted(address account) public onlyWhitelistAdmin {
702         _addWhitelisted(account);
703     }
704 
705     function removeWhitelisted(address account) public onlyWhitelistAdmin {
706         _removeWhitelisted(account);
707     }
708 
709     function renounceWhitelisted() public {
710         _removeWhitelisted(msg.sender);
711     }
712 
713     function _addWhitelisted(address account) internal {
714         _whitelisteds.add(account);
715         emit WhitelistedAdded(account);
716     }
717 
718     function _removeWhitelisted(address account) internal {
719         _whitelisteds.remove(account);
720         emit WhitelistedRemoved(account);
721     }
722 }
723 
724 // File: openzeppelin-solidity/contracts/crowdsale/validation/WhitelistCrowdsale.sol
725 
726 pragma solidity ^0.5.2;
727 
728 
729 
730 
731 /**
732  * @title WhitelistCrowdsale
733  * @dev Crowdsale in which only whitelisted users can contribute.
734  */
735 contract WhitelistCrowdsale is WhitelistedRole, Crowdsale {
736     /**
737      * @dev Extend parent behavior requiring beneficiary to be whitelisted. Note that no
738      * restriction is imposed on the account sending the transaction.
739      * @param _beneficiary Token beneficiary
740      * @param _weiAmount Amount of wei contributed
741      */
742     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
743         require(isWhitelisted(_beneficiary));
744         super._preValidatePurchase(_beneficiary, _weiAmount);
745     }
746 }
747 
748 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
749 
750 pragma solidity ^0.5.2;
751 
752 
753 
754 /**
755  * @title Standard ERC20 token
756  *
757  * @dev Implementation of the basic standard token.
758  * https://eips.ethereum.org/EIPS/eip-20
759  * Originally based on code by FirstBlood:
760  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
761  *
762  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
763  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
764  * compliant implementations may not do it.
765  */
766 contract ERC20 is IERC20 {
767     using SafeMath for uint256;
768 
769     mapping (address => uint256) private _balances;
770 
771     mapping (address => mapping (address => uint256)) private _allowed;
772 
773     uint256 private _totalSupply;
774 
775     /**
776      * @dev Total number of tokens in existence
777      */
778     function totalSupply() public view returns (uint256) {
779         return _totalSupply;
780     }
781 
782     /**
783      * @dev Gets the balance of the specified address.
784      * @param owner The address to query the balance of.
785      * @return A uint256 representing the amount owned by the passed address.
786      */
787     function balanceOf(address owner) public view returns (uint256) {
788         return _balances[owner];
789     }
790 
791     /**
792      * @dev Function to check the amount of tokens that an owner allowed to a spender.
793      * @param owner address The address which owns the funds.
794      * @param spender address The address which will spend the funds.
795      * @return A uint256 specifying the amount of tokens still available for the spender.
796      */
797     function allowance(address owner, address spender) public view returns (uint256) {
798         return _allowed[owner][spender];
799     }
800 
801     /**
802      * @dev Transfer token to a specified address
803      * @param to The address to transfer to.
804      * @param value The amount to be transferred.
805      */
806     function transfer(address to, uint256 value) public returns (bool) {
807         _transfer(msg.sender, to, value);
808         return true;
809     }
810 
811     /**
812      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
813      * Beware that changing an allowance with this method brings the risk that someone may use both the old
814      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
815      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
816      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
817      * @param spender The address which will spend the funds.
818      * @param value The amount of tokens to be spent.
819      */
820     function approve(address spender, uint256 value) public returns (bool) {
821         _approve(msg.sender, spender, value);
822         return true;
823     }
824 
825     /**
826      * @dev Transfer tokens from one address to another.
827      * Note that while this function emits an Approval event, this is not required as per the specification,
828      * and other compliant implementations may not emit the event.
829      * @param from address The address which you want to send tokens from
830      * @param to address The address which you want to transfer to
831      * @param value uint256 the amount of tokens to be transferred
832      */
833     function transferFrom(address from, address to, uint256 value) public returns (bool) {
834         _transfer(from, to, value);
835         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
836         return true;
837     }
838 
839     /**
840      * @dev Increase the amount of tokens that an owner allowed to a spender.
841      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
842      * allowed value is better to use this function to avoid 2 calls (and wait until
843      * the first transaction is mined)
844      * From MonolithDAO Token.sol
845      * Emits an Approval event.
846      * @param spender The address which will spend the funds.
847      * @param addedValue The amount of tokens to increase the allowance by.
848      */
849     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
850         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
851         return true;
852     }
853 
854     /**
855      * @dev Decrease the amount of tokens that an owner allowed to a spender.
856      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
857      * allowed value is better to use this function to avoid 2 calls (and wait until
858      * the first transaction is mined)
859      * From MonolithDAO Token.sol
860      * Emits an Approval event.
861      * @param spender The address which will spend the funds.
862      * @param subtractedValue The amount of tokens to decrease the allowance by.
863      */
864     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
865         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
866         return true;
867     }
868 
869     /**
870      * @dev Transfer token for a specified addresses
871      * @param from The address to transfer from.
872      * @param to The address to transfer to.
873      * @param value The amount to be transferred.
874      */
875     function _transfer(address from, address to, uint256 value) internal {
876         require(to != address(0));
877 
878         _balances[from] = _balances[from].sub(value);
879         _balances[to] = _balances[to].add(value);
880         emit Transfer(from, to, value);
881     }
882 
883     /**
884      * @dev Internal function that mints an amount of the token and assigns it to
885      * an account. This encapsulates the modification of balances such that the
886      * proper events are emitted.
887      * @param account The account that will receive the created tokens.
888      * @param value The amount that will be created.
889      */
890     function _mint(address account, uint256 value) internal {
891         require(account != address(0));
892 
893         _totalSupply = _totalSupply.add(value);
894         _balances[account] = _balances[account].add(value);
895         emit Transfer(address(0), account, value);
896     }
897 
898     /**
899      * @dev Internal function that burns an amount of the token of a given
900      * account.
901      * @param account The account whose tokens will be burnt.
902      * @param value The amount that will be burnt.
903      */
904     function _burn(address account, uint256 value) internal {
905         require(account != address(0));
906 
907         _totalSupply = _totalSupply.sub(value);
908         _balances[account] = _balances[account].sub(value);
909         emit Transfer(account, address(0), value);
910     }
911 
912     /**
913      * @dev Approve an address to spend another addresses' tokens.
914      * @param owner The address that owns the tokens.
915      * @param spender The address that will spend the tokens.
916      * @param value The number of tokens that can be spent.
917      */
918     function _approve(address owner, address spender, uint256 value) internal {
919         require(spender != address(0));
920         require(owner != address(0));
921 
922         _allowed[owner][spender] = value;
923         emit Approval(owner, spender, value);
924     }
925 
926     /**
927      * @dev Internal function that burns an amount of the token of a given
928      * account, deducting from the sender's allowance for said account. Uses the
929      * internal burn function.
930      * Emits an Approval event (reflecting the reduced allowance).
931      * @param account The account whose tokens will be burnt.
932      * @param value The amount that will be burnt.
933      */
934     function _burnFrom(address account, uint256 value) internal {
935         _burn(account, value);
936         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
937     }
938 }
939 
940 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
941 
942 pragma solidity ^0.5.2;
943 
944 
945 contract MinterRole {
946     using Roles for Roles.Role;
947 
948     event MinterAdded(address indexed account);
949     event MinterRemoved(address indexed account);
950 
951     Roles.Role private _minters;
952 
953     constructor () internal {
954         _addMinter(msg.sender);
955     }
956 
957     modifier onlyMinter() {
958         require(isMinter(msg.sender));
959         _;
960     }
961 
962     function isMinter(address account) public view returns (bool) {
963         return _minters.has(account);
964     }
965 
966     function addMinter(address account) public onlyMinter {
967         _addMinter(account);
968     }
969 
970     function renounceMinter() public {
971         _removeMinter(msg.sender);
972     }
973 
974     function _addMinter(address account) internal {
975         _minters.add(account);
976         emit MinterAdded(account);
977     }
978 
979     function _removeMinter(address account) internal {
980         _minters.remove(account);
981         emit MinterRemoved(account);
982     }
983 }
984 
985 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
986 
987 pragma solidity ^0.5.2;
988 
989 
990 
991 /**
992  * @title ERC20Mintable
993  * @dev ERC20 minting logic
994  */
995 contract ERC20Mintable is ERC20, MinterRole {
996     /**
997      * @dev Function to mint tokens
998      * @param to The address that will receive the minted tokens.
999      * @param value The amount of tokens to mint.
1000      * @return A boolean that indicates if the operation was successful.
1001      */
1002     function mint(address to, uint256 value) public onlyMinter returns (bool) {
1003         _mint(to, value);
1004         return true;
1005     }
1006 }
1007 
1008 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
1009 
1010 pragma solidity ^0.5.2;
1011 
1012 
1013 
1014 /**
1015  * @title MintedCrowdsale
1016  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1017  * Token ownership should be transferred to MintedCrowdsale for minting.
1018  */
1019 contract MintedCrowdsale is Crowdsale {
1020     /**
1021      * @dev Overrides delivery by minting tokens upon purchase.
1022      * @param beneficiary Token purchaser
1023      * @param tokenAmount Number of tokens to be minted
1024      */
1025     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
1026         // Potentially dangerous assumption about the type of the token.
1027         require(ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
1028     }
1029 }
1030 
1031 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
1032 
1033 pragma solidity ^0.5.2;
1034 
1035 
1036 
1037 /**
1038  * @title FinalizableCrowdsale
1039  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
1040  * can do extra work after finishing.
1041  */
1042 contract FinalizableCrowdsale is TimedCrowdsale {
1043     using SafeMath for uint256;
1044 
1045     bool private _finalized;
1046 
1047     event CrowdsaleFinalized();
1048 
1049     constructor () internal {
1050         _finalized = false;
1051     }
1052 
1053     /**
1054      * @return true if the crowdsale is finalized, false otherwise.
1055      */
1056     function finalized() public view returns (bool) {
1057         return _finalized;
1058     }
1059 
1060     /**
1061      * @dev Must be called after crowdsale ends, to do some extra finalization
1062      * work. Calls the contract's finalization function.
1063      */
1064     function finalize() public {
1065         require(!_finalized);
1066         require(hasClosed());
1067 
1068         _finalized = true;
1069 
1070         _finalization();
1071         emit CrowdsaleFinalized();
1072     }
1073 
1074     /**
1075      * @dev Can be overridden to add finalization logic. The overriding function
1076      * should call super._finalization() to ensure the chain of finalization is
1077      * executed entirely.
1078      */
1079     function _finalization() internal {
1080         // solhint-disable-previous-line no-empty-blocks
1081     }
1082 }
1083 
1084 // File: openzeppelin-solidity/contracts/ownership/Secondary.sol
1085 
1086 pragma solidity ^0.5.2;
1087 
1088 /**
1089  * @title Secondary
1090  * @dev A Secondary contract can only be used by its primary account (the one that created it)
1091  */
1092 contract Secondary {
1093     address private _primary;
1094 
1095     event PrimaryTransferred(
1096         address recipient
1097     );
1098 
1099     /**
1100      * @dev Sets the primary account to the one that is creating the Secondary contract.
1101      */
1102     constructor () internal {
1103         _primary = msg.sender;
1104         emit PrimaryTransferred(_primary);
1105     }
1106 
1107     /**
1108      * @dev Reverts if called from any account other than the primary.
1109      */
1110     modifier onlyPrimary() {
1111         require(msg.sender == _primary);
1112         _;
1113     }
1114 
1115     /**
1116      * @return the address of the primary.
1117      */
1118     function primary() public view returns (address) {
1119         return _primary;
1120     }
1121 
1122     /**
1123      * @dev Transfers contract to a new primary.
1124      * @param recipient The address of new primary.
1125      */
1126     function transferPrimary(address recipient) public onlyPrimary {
1127         require(recipient != address(0));
1128         _primary = recipient;
1129         emit PrimaryTransferred(_primary);
1130     }
1131 }
1132 
1133 // File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
1134 
1135 pragma solidity ^0.5.2;
1136 
1137 
1138 
1139  /**
1140   * @title Escrow
1141   * @dev Base escrow contract, holds funds designated for a payee until they
1142   * withdraw them.
1143   * @dev Intended usage: This contract (and derived escrow contracts) should be a
1144   * standalone contract, that only interacts with the contract that instantiated
1145   * it. That way, it is guaranteed that all Ether will be handled according to
1146   * the Escrow rules, and there is no need to check for payable functions or
1147   * transfers in the inheritance tree. The contract that uses the escrow as its
1148   * payment method should be its primary, and provide public methods redirecting
1149   * to the escrow's deposit and withdraw.
1150   */
1151 contract Escrow is Secondary {
1152     using SafeMath for uint256;
1153 
1154     event Deposited(address indexed payee, uint256 weiAmount);
1155     event Withdrawn(address indexed payee, uint256 weiAmount);
1156 
1157     mapping(address => uint256) private _deposits;
1158 
1159     function depositsOf(address payee) public view returns (uint256) {
1160         return _deposits[payee];
1161     }
1162 
1163     /**
1164      * @dev Stores the sent amount as credit to be withdrawn.
1165      * @param payee The destination address of the funds.
1166      */
1167     function deposit(address payee) public onlyPrimary payable {
1168         uint256 amount = msg.value;
1169         _deposits[payee] = _deposits[payee].add(amount);
1170 
1171         emit Deposited(payee, amount);
1172     }
1173 
1174     /**
1175      * @dev Withdraw accumulated balance for a payee.
1176      * @param payee The address whose funds will be withdrawn and transferred to.
1177      */
1178     function withdraw(address payable payee) public onlyPrimary {
1179         uint256 payment = _deposits[payee];
1180 
1181         _deposits[payee] = 0;
1182 
1183         payee.transfer(payment);
1184 
1185         emit Withdrawn(payee, payment);
1186     }
1187 }
1188 
1189 // File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
1190 
1191 pragma solidity ^0.5.2;
1192 
1193 
1194 /**
1195  * @title ConditionalEscrow
1196  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
1197  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1198  */
1199 contract ConditionalEscrow is Escrow {
1200     /**
1201      * @dev Returns whether an address is allowed to withdraw their funds. To be
1202      * implemented by derived contracts.
1203      * @param payee The destination address of the funds.
1204      */
1205     function withdrawalAllowed(address payee) public view returns (bool);
1206 
1207     function withdraw(address payable payee) public {
1208         require(withdrawalAllowed(payee));
1209         super.withdraw(payee);
1210     }
1211 }
1212 
1213 // File: openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol
1214 
1215 pragma solidity ^0.5.2;
1216 
1217 
1218 /**
1219  * @title RefundEscrow
1220  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
1221  * parties.
1222  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1223  * @dev The primary account (that is, the contract that instantiates this
1224  * contract) may deposit, close the deposit period, and allow for either
1225  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
1226  * with RefundEscrow will be made through the primary contract. See the
1227  * RefundableCrowdsale contract for an example of RefundEscrow’s use.
1228  */
1229 contract RefundEscrow is ConditionalEscrow {
1230     enum State { Active, Refunding, Closed }
1231 
1232     event RefundsClosed();
1233     event RefundsEnabled();
1234 
1235     State private _state;
1236     address payable private _beneficiary;
1237 
1238     /**
1239      * @dev Constructor.
1240      * @param beneficiary The beneficiary of the deposits.
1241      */
1242     constructor (address payable beneficiary) public {
1243         require(beneficiary != address(0));
1244         _beneficiary = beneficiary;
1245         _state = State.Active;
1246     }
1247 
1248     /**
1249      * @return the current state of the escrow.
1250      */
1251     function state() public view returns (State) {
1252         return _state;
1253     }
1254 
1255     /**
1256      * @return the beneficiary of the escrow.
1257      */
1258     function beneficiary() public view returns (address) {
1259         return _beneficiary;
1260     }
1261 
1262     /**
1263      * @dev Stores funds that may later be refunded.
1264      * @param refundee The address funds will be sent to if a refund occurs.
1265      */
1266     function deposit(address refundee) public payable {
1267         require(_state == State.Active);
1268         super.deposit(refundee);
1269     }
1270 
1271     /**
1272      * @dev Allows for the beneficiary to withdraw their funds, rejecting
1273      * further deposits.
1274      */
1275     function close() public onlyPrimary {
1276         require(_state == State.Active);
1277         _state = State.Closed;
1278         emit RefundsClosed();
1279     }
1280 
1281     /**
1282      * @dev Allows for refunds to take place, rejecting further deposits.
1283      */
1284     function enableRefunds() public onlyPrimary {
1285         require(_state == State.Active);
1286         _state = State.Refunding;
1287         emit RefundsEnabled();
1288     }
1289 
1290     /**
1291      * @dev Withdraws the beneficiary's funds.
1292      */
1293     function beneficiaryWithdraw() public {
1294         require(_state == State.Closed);
1295         _beneficiary.transfer(address(this).balance);
1296     }
1297 
1298     /**
1299      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
1300      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
1301      */
1302     function withdrawalAllowed(address) public view returns (bool) {
1303         return _state == State.Refunding;
1304     }
1305 }
1306 
1307 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
1308 
1309 pragma solidity ^0.5.2;
1310 
1311 
1312 
1313 
1314 /**
1315  * @title RefundableCrowdsale
1316  * @dev Extension of FinalizableCrowdsale contract that adds a funding goal, and the possibility of users
1317  * getting a refund if goal is not met.
1318  *
1319  * Deprecated, use RefundablePostDeliveryCrowdsale instead. Note that if you allow tokens to be traded before the goal
1320  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
1321  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
1322  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
1323  */
1324 contract RefundableCrowdsale is FinalizableCrowdsale {
1325     using SafeMath for uint256;
1326 
1327     // minimum amount of funds to be raised in weis
1328     uint256 private _goal;
1329 
1330     // refund escrow used to hold funds while crowdsale is running
1331     RefundEscrow private _escrow;
1332 
1333     /**
1334      * @dev Constructor, creates RefundEscrow.
1335      * @param goal Funding goal
1336      */
1337     constructor (uint256 goal) public {
1338         require(goal > 0);
1339         _escrow = new RefundEscrow(wallet());
1340         _goal = goal;
1341     }
1342 
1343     /**
1344      * @return minimum amount of funds to be raised in wei.
1345      */
1346     function goal() public view returns (uint256) {
1347         return _goal;
1348     }
1349 
1350     /**
1351      * @dev Investors can claim refunds here if crowdsale is unsuccessful
1352      * @param refundee Whose refund will be claimed.
1353      */
1354     function claimRefund(address payable refundee) public {
1355         require(finalized());
1356         require(!goalReached());
1357 
1358         _escrow.withdraw(refundee);
1359     }
1360 
1361     /**
1362      * @dev Checks whether funding goal was reached.
1363      * @return Whether funding goal was reached
1364      */
1365     function goalReached() public view returns (bool) {
1366         return weiRaised() >= _goal;
1367     }
1368 
1369     /**
1370      * @dev escrow finalization task, called when finalize() is called
1371      */
1372     function _finalization() internal {
1373         if (goalReached()) {
1374             _escrow.close();
1375             _escrow.beneficiaryWithdraw();
1376         } else {
1377             _escrow.enableRefunds();
1378         }
1379 
1380         super._finalization();
1381     }
1382 
1383     /**
1384      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1385      */
1386     function _forwardFunds() internal {
1387         _escrow.deposit.value(msg.value)(msg.sender);
1388     }
1389 }
1390 
1391 // File: openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
1392 
1393 pragma solidity ^0.5.2;
1394 
1395 
1396 
1397 /**
1398  * @title PostDeliveryCrowdsale
1399  * @dev Crowdsale that locks tokens from withdrawal until it ends.
1400  */
1401 contract PostDeliveryCrowdsale is TimedCrowdsale {
1402     using SafeMath for uint256;
1403 
1404     mapping(address => uint256) private _balances;
1405 
1406     /**
1407      * @dev Withdraw tokens only after crowdsale ends.
1408      * @param beneficiary Whose tokens will be withdrawn.
1409      */
1410     function withdrawTokens(address beneficiary) public {
1411         require(hasClosed());
1412         uint256 amount = _balances[beneficiary];
1413         require(amount > 0);
1414         _balances[beneficiary] = 0;
1415         _deliverTokens(beneficiary, amount);
1416     }
1417 
1418     /**
1419      * @return the balance of an account.
1420      */
1421     function balanceOf(address account) public view returns (uint256) {
1422         return _balances[account];
1423     }
1424 
1425     /**
1426      * @dev Overrides parent by storing balances instead of issuing tokens right away.
1427      * @param beneficiary Token purchaser
1428      * @param tokenAmount Amount of tokens purchased
1429      */
1430     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
1431         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
1432     }
1433 
1434 }
1435 
1436 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol
1437 
1438 pragma solidity ^0.5.2;
1439 
1440 
1441 
1442 
1443 /**
1444  * @title RefundablePostDeliveryCrowdsale
1445  * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
1446  * once the crowdsale has closed and the goal met, preventing refunds to be issued
1447  * to token holders.
1448  */
1449 contract RefundablePostDeliveryCrowdsale is RefundableCrowdsale, PostDeliveryCrowdsale {
1450     function withdrawTokens(address beneficiary) public {
1451         require(finalized());
1452         require(goalReached());
1453 
1454         super.withdrawTokens(beneficiary);
1455     }
1456 }
1457 
1458 // File: contracts/ClcgCrowdsale.sol
1459 
1460 pragma solidity 0.5.2;
1461 
1462 
1463 
1464 
1465 
1466 
1467 
1468 
1469 
1470 
1471 
1472 contract ClcgCrowdsale is Crowdsale, TimedCrowdsale, CappedCrowdsale, WhitelistCrowdsale, MintedCrowdsale, RefundableCrowdsale, RefundablePostDeliveryCrowdsale{
1473     constructor(uint256 _rate, address payable _wallet, ERC20 _token, uint256 _openingTime, uint256 _closingTime, uint256 _hardCap, uint256 _softCap)
1474         Crowdsale(_rate, _wallet, _token)
1475         TimedCrowdsale(_openingTime, _closingTime)
1476         CappedCrowdsale(_hardCap)
1477         RefundableCrowdsale(_softCap)
1478         public
1479         {
1480             
1481         }
1482 
1483     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
1484         // 0.04 ETH minimum contribution limit
1485         require(_weiAmount >= 40000000000000000);
1486         super._preValidatePurchase(_beneficiary, _weiAmount);
1487     }
1488 
1489     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
1490         // recalculate the tokenAmount to redistribute the total supply
1491         tokenAmount = (tokenAmount * cap()) / weiRaised();
1492         super._deliverTokens(beneficiary, tokenAmount);
1493     }
1494 }