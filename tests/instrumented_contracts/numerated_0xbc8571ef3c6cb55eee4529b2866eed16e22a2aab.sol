1 /*
2     Moon Token for MoonTrader Platform and projects
3     More information at https://moontrader.io/
4 
5     MoonTrader is a successor of the  MoonBot project, https://moon-bot.com/en/
6 
7     Mail us to: info@moontrader.io 
8 
9     Join the Telegram channel https://t.me/moontrader_news_en, 
10     Visit BTT forum thread https://bitcointalk.org/index.php?topic=5143969 for more information.
11 
12  */
13 
14 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
15 
16 pragma solidity ^0.5.2;
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://eips.ethereum.org/EIPS/eip-20
21  */
22 interface IERC20 {
23     function transfer(address to, uint256 value) external returns (bool);
24 
25     function approve(address spender, uint256 value) external returns (bool);
26 
27     function transferFrom(address from, address to, uint256 value) external returns (bool);
28 
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address who) external view returns (uint256);
32 
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
41 
42 pragma solidity ^0.5.2;
43 
44 /**
45  * @title SafeMath
46  * @dev Unsigned math operations with safety checks that revert on error
47  */
48 library SafeMath {
49     /**
50      * @dev Multiplies two unsigned integers, reverts on overflow.
51      */
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b);
62 
63         return c;
64     }
65 
66     /**
67      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
68      */
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         // Solidity only automatically asserts when dividing by 0
71         require(b > 0);
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     /**
79      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
80      */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b <= a);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Adds two unsigned integers, reverts on overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a);
94 
95         return c;
96     }
97 
98     /**
99      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
100      * reverts when dividing by zero.
101      */
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b != 0);
104         return a % b;
105     }
106 }
107 
108 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
109 
110 pragma solidity ^0.5.2;
111 
112 
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * https://eips.ethereum.org/EIPS/eip-20
119  * Originally based on code by FirstBlood:
120  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  *
122  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
123  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
124  * compliant implementations may not do it.
125  */
126 contract ERC20 is IERC20 {
127     using SafeMath for uint256;
128 
129     mapping (address => uint256) private _balances;
130 
131     mapping (address => mapping (address => uint256)) private _allowed;
132 
133     uint256 private _totalSupply;
134 
135     /**
136      * @dev Total number of tokens in existence
137      */
138     function totalSupply() public view returns (uint256) {
139         return _totalSupply;
140     }
141 
142     /**
143      * @dev Gets the balance of the specified address.
144      * @param owner The address to query the balance of.
145      * @return A uint256 representing the amount owned by the passed address.
146      */
147     function balanceOf(address owner) public view returns (uint256) {
148         return _balances[owner];
149     }
150 
151     /**
152      * @dev Function to check the amount of tokens that an owner allowed to a spender.
153      * @param owner address The address which owns the funds.
154      * @param spender address The address which will spend the funds.
155      * @return A uint256 specifying the amount of tokens still available for the spender.
156      */
157     function allowance(address owner, address spender) public view returns (uint256) {
158         return _allowed[owner][spender];
159     }
160 
161     /**
162      * @dev Transfer token to a specified address
163      * @param to The address to transfer to.
164      * @param value The amount to be transferred.
165      */
166     function transfer(address to, uint256 value) public returns (bool) {
167         _transfer(msg.sender, to, value);
168         return true;
169     }
170 
171     /**
172      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173      * Beware that changing an allowance with this method brings the risk that someone may use both the old
174      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      * @param spender The address which will spend the funds.
178      * @param value The amount of tokens to be spent.
179      */
180     function approve(address spender, uint256 value) public returns (bool) {
181         _approve(msg.sender, spender, value);
182         return true;
183     }
184 
185     /**
186      * @dev Transfer tokens from one address to another.
187      * Note that while this function emits an Approval event, this is not required as per the specification,
188      * and other compliant implementations may not emit the event.
189      * @param from address The address which you want to send tokens from
190      * @param to address The address which you want to transfer to
191      * @param value uint256 the amount of tokens to be transferred
192      */
193     function transferFrom(address from, address to, uint256 value) public returns (bool) {
194         _transfer(from, to, value);
195         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
196         return true;
197     }
198 
199     /**
200      * @dev Increase the amount of tokens that an owner allowed to a spender.
201      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * Emits an Approval event.
206      * @param spender The address which will spend the funds.
207      * @param addedValue The amount of tokens to increase the allowance by.
208      */
209     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
210         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
211         return true;
212     }
213 
214     /**
215      * @dev Decrease the amount of tokens that an owner allowed to a spender.
216      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
217      * allowed value is better to use this function to avoid 2 calls (and wait until
218      * the first transaction is mined)
219      * From MonolithDAO Token.sol
220      * Emits an Approval event.
221      * @param spender The address which will spend the funds.
222      * @param subtractedValue The amount of tokens to decrease the allowance by.
223      */
224     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
225         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
226         return true;
227     }
228 
229     /**
230      * @dev Transfer token for a specified addresses
231      * @param from The address to transfer from.
232      * @param to The address to transfer to.
233      * @param value The amount to be transferred.
234      */
235     function _transfer(address from, address to, uint256 value) internal {
236         require(to != address(0));
237 
238         _balances[from] = _balances[from].sub(value);
239         _balances[to] = _balances[to].add(value);
240         emit Transfer(from, to, value);
241     }
242 
243     /**
244      * @dev Internal function that mints an amount of the token and assigns it to
245      * an account. This encapsulates the modification of balances such that the
246      * proper events are emitted.
247      * @param account The account that will receive the created tokens.
248      * @param value The amount that will be created.
249      */
250     function _mint(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.add(value);
254         _balances[account] = _balances[account].add(value);
255         emit Transfer(address(0), account, value);
256     }
257 
258     /**
259      * @dev Internal function that burns an amount of the token of a given
260      * account.
261      * @param account The account whose tokens will be burnt.
262      * @param value The amount that will be burnt.
263      */
264     function _burn(address account, uint256 value) internal {
265         require(account != address(0));
266 
267         _totalSupply = _totalSupply.sub(value);
268         _balances[account] = _balances[account].sub(value);
269         emit Transfer(account, address(0), value);
270     }
271 
272     /**
273      * @dev Approve an address to spend another addresses' tokens.
274      * @param owner The address that owns the tokens.
275      * @param spender The address that will spend the tokens.
276      * @param value The number of tokens that can be spent.
277      */
278     function _approve(address owner, address spender, uint256 value) internal {
279         require(spender != address(0));
280         require(owner != address(0));
281 
282         _allowed[owner][spender] = value;
283         emit Approval(owner, spender, value);
284     }
285 
286     /**
287      * @dev Internal function that burns an amount of the token of a given
288      * account, deducting from the sender's allowance for said account. Uses the
289      * internal burn function.
290      * Emits an Approval event (reflecting the reduced allowance).
291      * @param account The account whose tokens will be burnt.
292      * @param value The amount that will be burnt.
293      */
294     function _burnFrom(address account, uint256 value) internal {
295         _burn(account, value);
296         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
297     }
298 }
299 
300 // File: openzeppelin-solidity/contracts/access/Roles.sol
301 
302 pragma solidity ^0.5.2;
303 
304 /**
305  * @title Roles
306  * @dev Library for managing addresses assigned to a Role.
307  */
308 library Roles {
309     struct Role {
310         mapping (address => bool) bearer;
311     }
312 
313     /**
314      * @dev give an account access to this role
315      */
316     function add(Role storage role, address account) internal {
317         require(account != address(0));
318         require(!has(role, account));
319 
320         role.bearer[account] = true;
321     }
322 
323     /**
324      * @dev remove an account's access to this role
325      */
326     function remove(Role storage role, address account) internal {
327         require(account != address(0));
328         require(has(role, account));
329 
330         role.bearer[account] = false;
331     }
332 
333     /**
334      * @dev check if an account has this role
335      * @return bool
336      */
337     function has(Role storage role, address account) internal view returns (bool) {
338         require(account != address(0));
339         return role.bearer[account];
340     }
341 }
342 
343 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
344 
345 pragma solidity ^0.5.2;
346 
347 
348 contract MinterRole {
349     using Roles for Roles.Role;
350 
351     event MinterAdded(address indexed account);
352     event MinterRemoved(address indexed account);
353 
354     Roles.Role private _minters;
355 
356     constructor () internal {
357         _addMinter(msg.sender);
358     }
359 
360     modifier onlyMinter() {
361         require(isMinter(msg.sender));
362         _;
363     }
364 
365     function isMinter(address account) public view returns (bool) {
366         return _minters.has(account);
367     }
368 
369     function addMinter(address account) public onlyMinter {
370         _addMinter(account);
371     }
372 
373     function renounceMinter() public {
374         _removeMinter(msg.sender);
375     }
376 
377     function _addMinter(address account) internal {
378         _minters.add(account);
379         emit MinterAdded(account);
380     }
381 
382     function _removeMinter(address account) internal {
383         _minters.remove(account);
384         emit MinterRemoved(account);
385     }
386 }
387 
388 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
389 
390 pragma solidity ^0.5.2;
391 
392 
393 
394 /**
395  * @title ERC20Mintable
396  * @dev ERC20 minting logic
397  */
398 contract ERC20Mintable is ERC20, MinterRole {
399     /**
400      * @dev Function to mint tokens
401      * @param to The address that will receive the minted tokens.
402      * @param value The amount of tokens to mint.
403      * @return A boolean that indicates if the operation was successful.
404      */
405     function mint(address to, uint256 value) public onlyMinter returns (bool) {
406         _mint(to, value);
407         return true;
408     }
409 }
410 
411 // File: openzeppelin-solidity/contracts/utils/Address.sol
412 
413 pragma solidity ^0.5.2;
414 
415 /**
416  * Utility library of inline functions on addresses
417  */
418 library Address {
419     /**
420      * Returns whether the target address is a contract
421      * @dev This function will return false if invoked during the constructor of a contract,
422      * as the code is not actually created until after the constructor finishes.
423      * @param account address of the account to check
424      * @return whether the target address is a contract
425      */
426     function isContract(address account) internal view returns (bool) {
427         uint256 size;
428         // XXX Currently there is no better way to check if there is a contract in an address
429         // than to check the size of the code at that address.
430         // See https://ethereum.stackexchange.com/a/14016/36603
431         // for more details about how this works.
432         // TODO Check this again before the Serenity release, because all addresses will be
433         // contracts then.
434         // solhint-disable-next-line no-inline-assembly
435         assembly { size := extcodesize(account) }
436         return size > 0;
437     }
438 }
439 
440 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
441 
442 pragma solidity ^0.5.2;
443 
444 
445 
446 
447 /**
448  * @title SafeERC20
449  * @dev Wrappers around ERC20 operations that throw on failure (when the token
450  * contract returns false). Tokens that return no value (and instead revert or
451  * throw on failure) are also supported, non-reverting calls are assumed to be
452  * successful.
453  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
454  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
455  */
456 library SafeERC20 {
457     using SafeMath for uint256;
458     using Address for address;
459 
460     function safeTransfer(IERC20 token, address to, uint256 value) internal {
461         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
462     }
463 
464     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
465         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
466     }
467 
468     function safeApprove(IERC20 token, address spender, uint256 value) internal {
469         // safeApprove should only be called when setting an initial allowance,
470         // or when resetting it to zero. To increase and decrease it, use
471         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
472         require((value == 0) || (token.allowance(address(this), spender) == 0));
473         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
474     }
475 
476     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
477         uint256 newAllowance = token.allowance(address(this), spender).add(value);
478         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
479     }
480 
481     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
482         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
483         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
484     }
485 
486     /**
487      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
488      * on the return value: the return value is optional (but if data is returned, it must equal true).
489      * @param token The token targeted by the call.
490      * @param data The call data (encoded using abi.encode or one of its variants).
491      */
492     function callOptionalReturn(IERC20 token, bytes memory data) private {
493         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
494         // we're implementing it ourselves.
495 
496         // A Solidity high level call has three parts:
497         //  1. The target address is checked to verify it contains contract code
498         //  2. The call itself is made, and success asserted
499         //  3. The return value is decoded, which in turn checks the size of the returned data.
500 
501         require(address(token).isContract());
502 
503         // solhint-disable-next-line avoid-low-level-calls
504         (bool success, bytes memory returndata) = address(token).call(data);
505         require(success);
506 
507         if (returndata.length > 0) { // Return data is optional
508             require(abi.decode(returndata, (bool)));
509         }
510     }
511 }
512 
513 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
514 
515 pragma solidity ^0.5.2;
516 
517 /**
518  * @title Helps contracts guard against reentrancy attacks.
519  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
520  * @dev If you mark a function `nonReentrant`, you should also
521  * mark it `external`.
522  */
523 contract ReentrancyGuard {
524     /// @dev counter to allow mutex lock with only one SSTORE operation
525     uint256 private _guardCounter;
526 
527     constructor () internal {
528         // The counter starts at one to prevent changing it from zero to a non-zero
529         // value, which is a more expensive operation.
530         _guardCounter = 1;
531     }
532 
533     /**
534      * @dev Prevents a contract from calling itself, directly or indirectly.
535      * Calling a `nonReentrant` function from another `nonReentrant`
536      * function is not supported. It is possible to prevent this from happening
537      * by making the `nonReentrant` function external, and make it call a
538      * `private` function that does the actual work.
539      */
540     modifier nonReentrant() {
541         _guardCounter += 1;
542         uint256 localCounter = _guardCounter;
543         _;
544         require(localCounter == _guardCounter);
545     }
546 }
547 
548 // File: contracts/Crowdsale/Core/Crowdsale.sol
549 
550 pragma solidity ^0.5.2;
551 
552 
553 
554 
555 
556 /**
557  * @title Crowdsale
558  * @dev Crowdsale is a base contract for managing a token crowdsale,
559  * allowing investors to purchase tokens with ether. This contract implements
560  * such functionality in its most fundamental form and can be extended to provide additional
561  * functionality and/or custom behavior.
562  * The external interface represents the basic interface for purchasing tokens, and conforms
563  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
564  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
565  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
566  * behavior.
567  */
568 contract Crowdsale is ReentrancyGuard {
569     using SafeMath for uint256;
570     using SafeERC20 for IERC20;
571 
572     // The token being sold
573     IERC20 private _token;
574 
575     // Address where funds are collected
576     address payable private _wallet;
577 
578     // How many token units a buyer gets per wei.
579     // The rate is the conversion between wei and the smallest and indivisible token unit.
580     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
581     // 1 wei will give you 1 unit, or 0.001 TOK.
582     uint256 private _rate;
583 
584     // Amount of wei raised
585     uint256 private _weiRaised;
586 
587     // Hardcap in tokens
588     uint256 private _supply;
589 
590     // Amount of sold tokens
591     uint256 private _sold;
592 
593     /**
594      * Event for token purchase logging
595      * @param purchaser who paid for the tokens
596      * @param beneficiary who got the tokens
597      * @param value weis paid for purchase
598      * @param amount amount of tokens purchased
599      */
600     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
601 
602     /**
603      * Event for conversion rate changes logging
604      * @param rate New rate
605      */
606     event RateUpdated(uint256 indexed rate);
607 
608     /**
609      * Events for crowdsale state tracking
610      */
611     event CrowdsalePaused();
612     event CrowdsaleUnpaused();
613 
614     /**
615      * @param rate Number of token units a buyer gets per wei
616      * @dev The rate is the conversion between wei and the smallest and indivisible
617      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
618      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
619      * @param wallet Address where collected funds will be forwarded to
620      * @param token Address of the token being sold
621      */
622     constructor (uint256 rate, uint256 supply, address payable wallet, IERC20 token) public {
623         require(rate > 0);
624         require(wallet != address(0));
625         require(address(token) != address(0));
626 
627         _rate = rate;
628         _supply = supply;
629         _wallet = wallet;
630         _token = token;
631     }
632 
633     /**
634      * @dev fallback function ***DO NOT OVERRIDE***
635      * Note that other contracts will transfer funds with a base gas stipend
636      * of 2300, which is not enough to call buyTokens. Consider calling
637      * buyTokens directly when purchasing tokens from a contract.
638      */
639     function() external payable {
640         buyTokens(msg.sender);
641     }
642 
643     /**
644      * @return the token being sold.
645      */
646     function token() public view returns (IERC20) {
647         return _token;
648     }
649 
650     /**
651      * @return amount of supplied tokens.
652      */
653     function supply() internal view returns (uint256) {
654         return _supply;
655     }
656 
657     /**
658      * @return amount of sold tokens.
659      */
660     function sold() public view returns (uint256) {
661         return _sold;
662     }
663 
664     /**
665      * @dev Increase amount of sold tokens by tokenAmount.
666      * @param tokenAmount Amount of last-purchased tokens
667      */
668     function _addSold(uint256 tokenAmount) internal {
669         _sold = _sold.add(tokenAmount);
670     }
671 
672     /**
673      * @return the address where funds are collected.
674      */
675     function wallet() public view returns (address payable) {
676         return _wallet;
677     }
678 
679     /**
680      * @return the number of token units a buyer gets per wei.
681      */
682     function rate() public view returns (uint256) {
683         return _rate;
684     }
685 
686     /**
687      * @return the amount of wei raised.
688      */
689     function weiRaised() public view returns (uint256) {
690         return _weiRaised;
691     }
692 
693 
694     /**
695      * @dev low level token purchase ***DO NOT OVERRIDE***
696      * This function has a non-reentrancy guard, so it shouldn't be called by
697      * another `nonReentrant` function.
698      * @param beneficiary Recipient of the token purchase
699      */
700     function buyTokens(address beneficiary) public nonReentrant payable {
701         uint256 weiAmount = msg.value;
702         _preValidatePurchase(beneficiary, weiAmount);
703 
704         uint256 surplus = _countSurplus(weiAmount);
705         weiAmount -= surplus;
706 
707         // calculate token amount to be created
708         uint256 tokens = _getTokenAmount(weiAmount);
709 
710         // update state
711         _weiRaised = _weiRaised.add(weiAmount);
712 
713         _processPurchase(beneficiary, tokens);
714         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
715 
716         _updatePurchasingState(beneficiary, weiAmount);
717 
718         _forwardFunds(weiAmount);
719         _returnSurplus(surplus);
720 
721         _postValidatePurchase(beneficiary, weiAmount);
722     }
723 
724     /**
725      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
726      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
727      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
728      *     super._preValidatePurchase(beneficiary, weiAmount);
729      *     require(weiRaised().add(weiAmount) <= cap);
730      * @param beneficiary Address performing the token purchase
731      * @param weiAmount Value in wei involved in the purchase
732      */
733     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
734         require(beneficiary != address(0));
735         require(weiAmount != 0);
736         require(rate() > 0);
737         require(_supply >= _sold + _getTokenAmount(weiAmount)); //todo
738     }
739 
740     /**
741      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
742      * conditions are not met.
743      * @param beneficiary Address performing the token purchase
744      * @param weiAmount Value in wei involved in the purchase
745      */
746     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
747         // solhint-disable-previous-line no-empty-blocks
748     }
749 
750     /**
751      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
752      * its tokens.
753      * @param beneficiary Address performing the token purchase
754      * @param tokenAmount Number of tokens to be emitted
755      */
756     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
757         _token.safeTransfer(beneficiary, tokenAmount);
758     }
759 
760     /**
761      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
762      * tokens.
763      * @param beneficiary Address receiving the tokens
764      * @param tokenAmount Number of tokens to be purchased
765      */
766     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
767         _deliverTokens(beneficiary, tokenAmount);
768         _addSold(tokenAmount);
769     }
770 
771     /**
772      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
773      * etc.)
774      * @param beneficiary Address receiving the tokens
775      * @param weiAmount Value in wei involved in the purchase
776      */
777     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
778         // solhint-disable-previous-line no-empty-blocks
779     }
780 
781     /**
782      * @dev Override to extend the way in which ether is converted to tokens.
783      * @param weiAmount Value in wei to be converted into tokens
784      * @return Number of tokens that can be purchased with the specified _weiAmount
785      */
786     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
787         return weiAmount.mul(_rate);
788     }
789 
790     /**
791      * @param tokenAmount amount of tokens to be converted in wei
792      * @return amount of wei to be spent on the purchase of tokenAmount tokens
793      */
794     function _getWeiAmount(uint256 tokenAmount) internal view returns (uint256) {
795         return tokenAmount.div(_rate);
796     }
797 
798     /**
799      * @dev Determines how ETH is stored/forwarded on purchases.
800      */
801     function _forwardFunds(uint256 weiAmount) internal {
802         _wallet.transfer(weiAmount);
803     }
804 
805     /*
806      * @dev Override to define the way in which surplus will be counted
807      * @param weiAmount Amount of wei sent by user
808      * @return surplus to be returned
809      */
810     function _countSurplus(uint256 weiAmount) internal returns (uint256){
811         // solhint-disable-previous-line no-empty-blocks
812     }
813 
814     /**
815      * @dev Override to change the way in which wei surplus returns to user
816      * @param weiAmount Amount of wei to be returned
817      */
818     function _returnSurplus(uint256 weiAmount) internal {
819         if (weiAmount > 0) {
820             msg.sender.transfer(weiAmount);
821         }
822     }
823 
824     /**
825      * @dev Changes conversion rate. Override for extend the way in which rate changing affects on crowdsale
826      * @param newRate Value in tokens to be paid per 1 wei
827      */
828     function _changeRate(uint256 newRate) internal {
829         if ((newRate > 0) && (_rate == 0)) {
830             emit CrowdsaleUnpaused();
831         } else if (newRate == 0) {
832             emit CrowdsalePaused();
833         }
834 
835         _rate = newRate;
836         emit RateUpdated(newRate);
837     }
838 
839 }
840 
841 // File: contracts/Crowdsale/Util/Role.sol
842 
843 pragma solidity ^0.5.2;
844 
845 library Role {
846 
847     struct RoleContainer {
848         address[] bearer;
849     }
850 
851     /**
852      * @param role role storage
853      * @return amount of accounts in this role
854      */
855     function total (RoleContainer storage role) internal view returns (uint count) {
856         for (uint i = 0; i < role.bearer.length; i++) {
857             count += (role.bearer[i] == address(0)) ? 0 : 1;
858         }
859         return count;
860     }
861 
862 
863     /**
864      * @dev check if an account has this role
865      * @return bool
866      */
867     function has(RoleContainer storage role, address account) internal view returns (bool) {
868         require(account != address(0));
869         address[] memory list = role.bearer;
870         uint len = role.bearer.length;
871         for (uint index = 0; index < len; index++) {
872             if (list[index] == account) {
873                 return true;
874             }
875         }
876         return false;
877     }
878 
879     /**
880      * @dev give an account access to this role
881      */
882     function add(RoleContainer storage role, address account) internal {
883         require(account != address(0));
884         require(!has(role, account));
885 
886         role.bearer.push(account);
887     }
888 
889     /**
890      * @dev remove an account's access to this role
891      */
892     function remove(RoleContainer storage role, address account) internal {
893         require(account != address(0));
894         require(has(role, account));
895 
896         removeFromList(role, account);
897     }
898 
899     /**
900      * @dev Helper function. Iterates over array to find and
901        remove given account from it
902        @param role Role storage
903        @param account Expelled account
904      */
905     function removeFromList(RoleContainer storage role, address account) private {
906         address[] storage list = role.bearer;
907         uint len = role.bearer.length;
908 
909         for (uint index = 0; index <= len; index++) {
910             if (list[index] != account) {
911                 continue;
912             }
913             list[index] = list[len - 1];
914             delete list[len - 1];
915             return;
916         }
917     }
918 }
919 
920 // File: contracts/Crowdsale/Util/Helpers.sol
921 
922 pragma solidity ^0.5.2;
923 
924 library Helpers {
925     function majority(uint total) internal pure returns (uint) {
926         return uint(total / 2) + 1;
927     }
928 
929     function idFromAddress(address addr) internal pure returns (bytes32) {
930         return keccak256(abi.encode(addr));
931     }
932 
933     function idFromUint256(uint256 x) internal pure returns (bytes32) {
934         return keccak256(abi.encode(x));
935     }
936 
937     function mixId(address addr, uint256 x) internal pure returns (bytes32) {
938         return keccak256(abi.encode(addr, x));
939     }
940 }
941 
942 // File: contracts/Crowdsale/Util/Votings.sol
943 
944 pragma solidity ^0.5.2;
945 
946 
947 library Votings {
948 
949     struct Voting {
950         mapping(bytes32 => address[]) process;
951     }
952 
953     /**
954      * @dev Votes and check if voting is completed. If vote is completed - deletes it
955      * @param voting Storage
956      * @param index Of voting process
957      * @param issuer Voter
958      * @param required Amount of votes for this process to be successful
959      * @return (is voting completed?)
960      */
961     function voteAndCheck(Voting storage voting,
962         bytes32 index, address issuer, uint required) internal returns (bool)
963     {
964         vote(voting, index, issuer);
965         return isComplete(voting, index, required);
966     }
967 
968     /**
969      * @dev Check if voting is completed. If vote is completed - deletes it
970      * @param voting Storage
971      * @param index Of voting process
972      * @param required Amount of votes for this process to be successful
973      * @return (is voting completed?)
974      */
975     function isComplete(Voting storage voting,
976         bytes32 index, uint required) internal returns (bool)
977     {
978         if (voting.process[index].length < required) {
979             return false;
980         }
981 
982         delete voting.process[index];
983         return true;
984     }
985 
986 
987 
988     /**
989      * @dev Vote
990      * @param voting Storage
991      * @param index Of voting process
992      * @param issuer Voter
993      */
994     function vote(Voting storage voting,
995         bytes32 index, address issuer) internal
996     {
997         require(!hadVoted(voting, index, issuer));
998         voting.process[index].push(issuer);
999     }
1000 
1001     /**
1002      * @dev Check of issuer had voted on this process
1003      * @param voting Storage
1004      * @param index Of voting process
1005      * @param issuer Voter
1006      * @return bool
1007      */
1008     function hadVoted(Voting storage voting,
1009         bytes32 index, address issuer) internal view returns (bool)
1010     {
1011         address[] storage _process = voting.process[index];
1012 
1013         for (uint ind = 0; ind < _process.length; ind++) {
1014             if (_process[ind] == issuer) {
1015                 return true;
1016             }
1017         }
1018 
1019         return false;
1020     }
1021 }
1022 
1023 // File: contracts/Crowdsale/Roles/AdminRole.sol
1024 
1025 pragma solidity ^0.5.2;
1026 
1027 
1028 
1029 
1030 
1031 contract AdminRole {
1032     using Role for Role.RoleContainer;
1033     using Votings for Votings.Voting;
1034 
1035     //admin storage
1036     Role.RoleContainer private _admins;
1037 
1038     //voting storage
1039     Votings.Voting private _addVoting;
1040     Votings.Voting private _expelVoting;
1041 
1042     /**
1043      * @dev events for "add admin" action logging
1044      * @param account New admin
1045      */
1046     event AdminAdded(address indexed account);
1047 
1048     /**
1049      * @dev events for "expel admin" action logging
1050      * @param account Expelled admin
1051      */
1052     event AdminRemoved(address indexed account);
1053 
1054     modifier AdminOnly() {
1055         require(isAdmin(msg.sender));
1056         _;
1057     }
1058 
1059     modifier WhileSetup() {
1060         require(isAdmin(msg.sender));
1061         require(countAdmins() == 1);
1062         _;
1063     }
1064 
1065     constructor () internal {
1066         _add(msg.sender);
1067     }
1068 
1069     /**
1070      * @param account to check
1071      * @return is this account contains in admin list
1072      */
1073     function isAdmin(address account) public view returns (bool) {
1074         return _admins.has(account);
1075     }
1076 
1077     /**
1078      * @return list of admins
1079      */
1080     function listAdmins() public view returns (address[] memory) {
1081         return _admins.bearer;
1082     }
1083 
1084     /**
1085      * @return amount of admins
1086      */
1087     function countAdmins() public view returns (uint) {
1088         return _admins.total();
1089     }
1090 
1091     /**
1092      * @dev initialize admin list while setup-stage of sale
1093      * @param defaultAdmins list of default admins
1094      */
1095     function initAdmins(address[] memory defaultAdmins) WhileSetup internal {
1096         for (uint256 index = 0; index < defaultAdmins.length; index++) {
1097             _add(defaultAdmins[index]);
1098         }
1099     }
1100 
1101     /**
1102      * @dev Vote and append given account to the admin list after consensus
1103      * @param account Account to be appended
1104      */
1105     function addAdmin(address account) AdminOnly public {
1106         if (_addAdminVoting(account)) {
1107             _add(account);
1108         }
1109     }
1110 
1111     /**
1112      * @dev Vote and remove given account from admin list after consensus
1113      * @param account Account to be removed
1114      */
1115     function expelAdmin(address account) AdminOnly public {
1116         if (_expelAdminVoting(account)) {
1117             _expel(account);
1118         }
1119     }
1120 
1121 
1122     /**
1123      * @dev require (N/2)+1 admins to be agreed with the add proposal
1124      * @param account Account to be appended
1125      * @return do (N/2)+1  admins agreed with the proposal?
1126      */
1127     function _addAdminVoting(address account) private returns (bool) {
1128         return _addVoting.voteAndCheck(
1129             Helpers.idFromAddress(account),
1130             msg.sender,
1131             Helpers.majority(countAdmins())
1132         );
1133     }
1134 
1135     /**
1136      * @dev require (N/2)+1 admins to be agreed with the removal proposal
1137      * @param account Account to be removed
1138      * @return do (N/2)+1  admins agreed with the proposal?
1139      */
1140     function _expelAdminVoting(address account) private returns (bool) {
1141         require(msg.sender != account);
1142         return _expelVoting.voteAndCheck(
1143             Helpers.idFromAddress(account),
1144             msg.sender,
1145             Helpers.majority(countAdmins())
1146         );
1147     }
1148 
1149 
1150     /**
1151      * @dev appends given account to admin list
1152      * @param account Account to be appended
1153      */
1154     function _add(address account) private {
1155         _admins.add(account);
1156         emit AdminAdded(account);
1157     }
1158 
1159     /**
1160      * @dev removes given account to admin list
1161      * @param account Account to be excluded
1162      */
1163     function _expel(address account) private {
1164         _admins.remove(account);
1165         emit AdminRemoved(account);
1166     }
1167 
1168 
1169 }
1170 
1171 // File: contracts/Crowdsale/Functionalities/InvestOnBehalf.sol
1172 
1173 pragma solidity ^0.5.2;
1174 
1175 
1176 
1177 
1178 
1179 contract InvestOnBehalf is AdminRole, Crowdsale {
1180     using Votings for Votings.Voting;
1181 
1182     // Current vote processes
1183     Votings.Voting private _votings;
1184 
1185     /**
1186      * Event for investOnBehalf actions logging
1187      * @param account Transfer target
1188      * @param tokens Amount of transferred tokens
1189      */
1190     event InvestedOnBehalf(address indexed account, uint256 indexed tokens);
1191 
1192     /**
1193      * @dev require (N/2)+1 admins to be agreed with the proposal
1194      * @param account Transfer target
1195      * @param tokens Amount of tokens to be transferred
1196      * @return do all admins agreed with the proposal?
1197      */
1198     function consensus(address account, uint256 tokens) private returns (bool) {
1199         return _votings.voteAndCheck(Helpers.mixId(account, tokens), msg.sender, Helpers.majority(countAdmins()));
1200     }
1201 
1202 
1203     /*
1204      * @dev Vote and add X tokens to the user balance after consensus
1205      * @param to Transfer target
1206      * @param tokens Amount of tokens to be transferred
1207      */
1208     function investOnBehalf(address to, uint256 tokens) AdminOnly public {
1209         if (consensus(to, tokens)) {
1210             _processPurchase(to, tokens * 1e18);
1211             emit InvestedOnBehalf(to, tokens * 1e18);
1212         }
1213     }
1214 }
1215 
1216 // File: contracts/Crowdsale/Functionalities/MilestonedCrowdsale.sol
1217 
1218 pragma solidity ^0.5.2;
1219 
1220 
1221 
1222 contract MilestonedCrowdsale is AdminRole, Crowdsale {
1223     event MilestoneReached(uint256 indexed milestone);
1224 
1225     /**
1226      * @dev Container for milestone ranges
1227      * @param start Milestone start timestamp
1228      * @param finish Milestone finish timestamp
1229      * @param fired
1230      */
1231     struct Milestone {
1232         uint256 start;
1233         uint256 finish;
1234         bool fired;
1235     }
1236 
1237     Milestone[] private _milestones;
1238 
1239     /**
1240      * @dev Creates single milestone in storage
1241      * @param start Timestamp from
1242      * @param finish Timestamp to
1243      */
1244     function _newMilestone(uint256 start, uint256 finish) private {
1245         require(start < finish);
1246         _milestones.push(Milestone(start, finish, false));
1247     }
1248 
1249     /**
1250      * @dev Initialize milestone storage
1251      * @param milestones Timerow of timestamps
1252      */
1253     function initMilestones(uint256[] memory milestones) WhileSetup internal {
1254         for (uint256 index = 0; index < milestones.length - 1; index++) {
1255             _newMilestone(milestones[index], milestones[index + 1]);
1256         }
1257     }
1258 
1259     /**
1260      * @dev Extends parent with counting surplus from milestones
1261      * @param weiAmount Amount of wei received
1262      * @return surplus above the last milestone
1263      */
1264     function _countSurplus(uint256 weiAmount) internal returns (uint256){
1265         return _getMilestoneOverhead(weiAmount);
1266     }
1267 
1268     /**
1269      * @dev Extends parent with pausing crowdsale if any surplus is returned
1270      * @param weiAmount Amount of surplus wei
1271      */
1272     function _returnSurplus(uint256 weiAmount) internal {
1273         super._returnSurplus(weiAmount);
1274 
1275         if (weiAmount > 0) {
1276             _changeRate(0);
1277         }
1278     }
1279 
1280     /**
1281      * @dev Iterates over milestones to make sure
1282      * that current transaction hasn't passed current milestone.
1283      * @param weiAmount Amount of wei received
1284      * @return If milestone has been reached, returns amount of wei above
1285      * milestone finish-line
1286      */
1287     function _getMilestoneOverhead(uint256 weiAmount) private returns (uint256){
1288         for (uint256 index = 0; index < _milestones.length; index++) {
1289             //every milestone could be reached only once
1290             if (_milestones[index].fired) {
1291                 continue;
1292             }
1293 
1294             uint256 start = _milestones[index].start;
1295             uint256 finish = _milestones[index].finish;
1296 
1297             uint256 surplus = _checkStage(start, finish, weiAmount);
1298             if (surplus == 0) {
1299                 continue;
1300             }
1301 
1302             _milestones[index].fired = true;
1303             emit MilestoneReached(finish);
1304 
1305             return surplus;
1306         }
1307     }
1308 
1309     /**
1310      * @param from Milestone start
1311      * @param to Milestone finish
1312      * @return surplus wei amount above the milestone
1313      */
1314     function _checkStage(uint256 from, uint256 to, uint256 weiAmount) private view returns (uint256) {
1315         uint256 afterPayment = sold() + _getTokenAmount(weiAmount);
1316         bool inRange = (sold() >= from) && (sold() < to);
1317 
1318         if (inRange && (afterPayment >= to)) {
1319             return _getWeiAmount(afterPayment - to) + 1;
1320         }
1321     }
1322 }
1323 
1324 // File: contracts/Crowdsale/Functionalities/UpdatableRateCrowdsale.sol
1325 
1326 pragma solidity ^0.5.2;
1327 
1328 
1329 
1330 
1331 
1332 
1333 contract UpdatableRateCrowdsale is AdminRole, Crowdsale {
1334     using Votings for Votings.Voting;
1335 
1336     // Current vote processes
1337     Votings.Voting private _votings;
1338 
1339     /**
1340      * @dev require (N/2)+1 admins to be agreed with the proposal
1341      * @param rate New conversion rate
1342      * @return do (N/2)+1 admins agreed with the proposal?
1343      */
1344     function consensus(uint256 rate) private returns (bool) {
1345         return _votings.voteAndCheck(Helpers.idFromUint256(rate), msg.sender, Helpers.majority(countAdmins()));
1346     }
1347 
1348     /**
1349      * @dev Vote and apply new conversion rates after consensus
1350      */
1351     function changeRate(uint256 rate) AdminOnly public {
1352         if (consensus(rate)) {
1353             _changeRate(rate);
1354         }
1355     }
1356 }
1357 
1358 // File: contracts/Crowdsale/Core/Emission/MintedCrowdsale.sol
1359 
1360 pragma solidity ^0.5.2;
1361 
1362 
1363 
1364 /**
1365  * @title MintedCrowdsale
1366  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1367  * Token ownership should be transferred to MintedCrowdsale for minting.
1368  */
1369 contract MintedCrowdsale is Crowdsale {
1370     /**
1371      * @dev Overrides delivery by minting tokens upon purchase.
1372      * @param beneficiary Token purchaser
1373      * @param tokenAmount Number of tokens to be minted
1374      */
1375     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
1376         // Potentially dangerous assumption about the type of the token.
1377         require(ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
1378     }
1379 }
1380 
1381 // File: contracts/Crowdsale/Core/Validation/SoftcappedCrowdsale.sol
1382 
1383 pragma solidity ^0.5.2;
1384 
1385 
1386 
1387 contract SoftcappedCrowdsale is AdminRole, Crowdsale {
1388     // minimum amount of tokens to be sold
1389     uint256 private _goal;
1390 
1391     // minimum amount of wei to be accepted
1392     // from a single user before softcap collected
1393     uint256 private _minimalPay = 0;
1394 
1395     /**
1396      * @dev Constructor, creates RefundEscrow.
1397      * @param goal Funding goal
1398      */
1399     constructor (uint256 goal) public {
1400         require(goal > 0);
1401         _goal = goal;
1402     }
1403 
1404     /**
1405      * @return minimum amount of tokens to be sold.
1406      */
1407     function goal() public view returns (uint256) {
1408         return _goal;
1409     }
1410 
1411     /**
1412      * @return minimum amount of wei to be paid until softcap is reached.
1413      */
1414     function minimalPay() public view returns (uint256) {
1415         return goalReached() ? 0 : _minimalPay;
1416     }
1417 
1418     /**
1419      * @return minimum amount of wei to be paid until softcap is reached.
1420      */
1421     function setMinimalPay(uint256 weiAmount) WhileSetup internal {
1422         _minimalPay = weiAmount;
1423     }
1424 
1425     /**
1426      * @dev Checks whether funding goal was reached.
1427      * @return Whether funding goal was reached
1428      */
1429     function goalReached() public view returns (bool) {
1430         return sold() >= _goal;
1431     }
1432 
1433     /**
1434      * @dev Extends parent with additional wei amount check sent by user
1435      * @param beneficiary Token purchaser
1436      * @param weiAmount Amount of received wei
1437      */
1438     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1439         super._preValidatePurchase(beneficiary, weiAmount);
1440 
1441         if (!goalReached() && _minimalPay != 0) {
1442             require(weiAmount >= _minimalPay);
1443         }
1444     }
1445 
1446 }
1447 
1448 // File: contracts/Crowdsale/Core/Validation/TimedCrowdsale.sol
1449 
1450 pragma solidity ^0.5.2;
1451 
1452 
1453 
1454 /**
1455  * @title TimedCrowdsale
1456  * @dev Crowdsale closes if softcap not reached within a time frame.
1457  */
1458 contract TimedCrowdsale is SoftcappedCrowdsale {
1459     using SafeMath for uint256;
1460 
1461     uint256 private _openingTime;
1462     uint256 private _softcapDeadline;
1463     uint256 private _closingTime;
1464 
1465     /**
1466      * Event for crowdsale extending
1467      * @param newClosingTime new closing time
1468      * @param prevClosingTime old closing time
1469      */
1470     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
1471 
1472     /**
1473      * @dev Reverts if not in crowdsale time range.
1474      */
1475     modifier onlyWhileOpen {
1476         require(!hasClosed());
1477         _;
1478     }
1479 
1480     /**
1481      * @dev Constructor, takes crowdsale opening and closing times.
1482      * @param openingTime Crowdsale opening time
1483      * @param softcapDeadline Crowdsale closing time
1484      */
1485     constructor (uint256 openingTime, uint256 softcapDeadline, uint256 closingTime) public {
1486         // solhint-disable-next-line not-rely-on-time
1487         //todo require(openingTime >= block.timestamp);
1488         require(softcapDeadline > openingTime);
1489         require(closingTime > softcapDeadline);
1490 
1491         _openingTime = openingTime;
1492         _softcapDeadline = softcapDeadline;
1493         _closingTime = closingTime;
1494     }
1495 
1496     /**
1497      * @return the crowdsale opening time.
1498      */
1499     function openingTime() public view returns (uint256) {
1500         return _openingTime;
1501     }
1502 
1503     /**
1504      * @return the crowdsale softcap deadline.
1505      */
1506     function softcapDeadline() public view returns (uint256) {
1507         return _softcapDeadline;
1508     }
1509 
1510     /**
1511      * @return the crowdsale closing time.
1512      */
1513     function closingTime() public view returns (uint256) {
1514         return _closingTime;
1515     }
1516 
1517 
1518     /**
1519      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1520      * @return Whether crowdsale period has elapsed and goal hasn't been reached
1521      */
1522     function hasClosed() public view returns (bool) {
1523         // solhint-disable-next-line not-rely-on-time
1524         return ((block.timestamp > _softcapDeadline) && !goalReached()) ||
1525         ((block.timestamp > _closingTime) && goalReached());
1526     }
1527 
1528     /**
1529      * @dev Extend parent behavior requiring to be within contributing period
1530      * @param beneficiary Token purchaser
1531      * @param weiAmount Amount of wei contributed
1532      */
1533     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
1534         super._preValidatePurchase(beneficiary, weiAmount);
1535     }
1536 
1537 
1538 }
1539 
1540 // File: contracts/Crowdsale/Core/Distribution/FinalizableCrowdsale.sol
1541 
1542 pragma solidity ^0.5.2;
1543 
1544 
1545 
1546 
1547 /**
1548  * @title FinalizableCrowdsale
1549  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
1550  * can do extra work after finishing.
1551  */
1552 contract FinalizableCrowdsale is AdminRole, TimedCrowdsale {
1553     using SafeMath for uint256;
1554 
1555     bool private _finalized;
1556 
1557     event CrowdsaleFinalized();
1558 
1559     constructor () internal {
1560         _finalized = false;
1561     }
1562 
1563     /**
1564      * @return true if the crowdsale is finalized, false otherwise.
1565      */
1566     function finalized() public view returns (bool) {
1567         return _finalized;
1568     }
1569 
1570     /**
1571      * @dev Must be called after crowdsale ends, to do some extra finalization
1572      * work. Calls the contract's finalization function.
1573      */
1574     function finalize() AdminOnly public {
1575         require(!_finalized);
1576         require(hasClosed() || goalReached());
1577 
1578         _finalized = true;
1579 
1580         _finalization();
1581         emit CrowdsaleFinalized();
1582     }
1583 
1584     /**
1585      * @dev Can be overridden to add finalization logic. The overriding function
1586      * should call super._finalization() to ensure the chain of finalization is
1587      * executed entirely.
1588      */
1589     function _finalization() internal {
1590         // solhint-disable-previous-line no-empty-blocks
1591     }
1592 }
1593 
1594 // File: openzeppelin-solidity/contracts/ownership/Secondary.sol
1595 
1596 pragma solidity ^0.5.2;
1597 
1598 /**
1599  * @title Secondary
1600  * @dev A Secondary contract can only be used by its primary account (the one that created it)
1601  */
1602 contract Secondary {
1603     address private _primary;
1604 
1605     event PrimaryTransferred(
1606         address recipient
1607     );
1608 
1609     /**
1610      * @dev Sets the primary account to the one that is creating the Secondary contract.
1611      */
1612     constructor () internal {
1613         _primary = msg.sender;
1614         emit PrimaryTransferred(_primary);
1615     }
1616 
1617     /**
1618      * @dev Reverts if called from any account other than the primary.
1619      */
1620     modifier onlyPrimary() {
1621         require(msg.sender == _primary);
1622         _;
1623     }
1624 
1625     /**
1626      * @return the address of the primary.
1627      */
1628     function primary() public view returns (address) {
1629         return _primary;
1630     }
1631 
1632     /**
1633      * @dev Transfers contract to a new primary.
1634      * @param recipient The address of new primary.
1635      */
1636     function transferPrimary(address recipient) public onlyPrimary {
1637         require(recipient != address(0));
1638         _primary = recipient;
1639         emit PrimaryTransferred(_primary);
1640     }
1641 }
1642 
1643 // File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
1644 
1645 pragma solidity ^0.5.2;
1646 
1647 
1648 
1649  /**
1650   * @title Escrow
1651   * @dev Base escrow contract, holds funds designated for a payee until they
1652   * withdraw them.
1653   * @dev Intended usage: This contract (and derived escrow contracts) should be a
1654   * standalone contract, that only interacts with the contract that instantiated
1655   * it. That way, it is guaranteed that all Ether will be handled according to
1656   * the Escrow rules, and there is no need to check for payable functions or
1657   * transfers in the inheritance tree. The contract that uses the escrow as its
1658   * payment method should be its primary, and provide public methods redirecting
1659   * to the escrow's deposit and withdraw.
1660   */
1661 contract Escrow is Secondary {
1662     using SafeMath for uint256;
1663 
1664     event Deposited(address indexed payee, uint256 weiAmount);
1665     event Withdrawn(address indexed payee, uint256 weiAmount);
1666 
1667     mapping(address => uint256) private _deposits;
1668 
1669     function depositsOf(address payee) public view returns (uint256) {
1670         return _deposits[payee];
1671     }
1672 
1673     /**
1674      * @dev Stores the sent amount as credit to be withdrawn.
1675      * @param payee The destination address of the funds.
1676      */
1677     function deposit(address payee) public onlyPrimary payable {
1678         uint256 amount = msg.value;
1679         _deposits[payee] = _deposits[payee].add(amount);
1680 
1681         emit Deposited(payee, amount);
1682     }
1683 
1684     /**
1685      * @dev Withdraw accumulated balance for a payee.
1686      * @param payee The address whose funds will be withdrawn and transferred to.
1687      */
1688     function withdraw(address payable payee) public onlyPrimary {
1689         uint256 payment = _deposits[payee];
1690 
1691         _deposits[payee] = 0;
1692 
1693         payee.transfer(payment);
1694 
1695         emit Withdrawn(payee, payment);
1696     }
1697 }
1698 
1699 // File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
1700 
1701 pragma solidity ^0.5.2;
1702 
1703 
1704 /**
1705  * @title ConditionalEscrow
1706  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
1707  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1708  */
1709 contract ConditionalEscrow is Escrow {
1710     /**
1711      * @dev Returns whether an address is allowed to withdraw their funds. To be
1712      * implemented by derived contracts.
1713      * @param payee The destination address of the funds.
1714      */
1715     function withdrawalAllowed(address payee) public view returns (bool);
1716 
1717     function withdraw(address payable payee) public {
1718         require(withdrawalAllowed(payee));
1719         super.withdraw(payee);
1720     }
1721 }
1722 
1723 // File: contracts/Crowdsale/Core/Independent/RefundEscrow.sol
1724 
1725 pragma solidity ^0.5.2;
1726 
1727 
1728 
1729 /**
1730  * @title RefundEscrow
1731  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
1732  * parties.
1733  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1734  * @dev The primary account (that is, the contract that instantiates this
1735  * contract) may deposit, close the deposit period, and allow for either
1736  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
1737  * with RefundEscrow will be made through the primary contract. See the
1738  * RefundableCrowdsale contract for an example of RefundEscrow’s use.
1739  */
1740 contract RefundEscrow is ConditionalEscrow {
1741     enum State { Active, Refunding, Closed }
1742 
1743     event RefundsClosed();
1744     event RefundsEnabled();
1745 
1746     State private _state;
1747     address payable private _beneficiary;
1748 
1749     /**
1750      * @dev Constructor.
1751      * @param beneficiary The beneficiary of the deposits.
1752      */
1753     constructor (address payable beneficiary) public {
1754         require(beneficiary != address(0));
1755         _beneficiary = beneficiary;
1756         _state = State.Active;
1757     }
1758 
1759     /**
1760      * @return the current state of the escrow.
1761      */
1762     function state() public view returns (State) {
1763         return _state;
1764     }
1765 
1766     /**
1767      * @return the beneficiary of the escrow.
1768      */
1769     function beneficiary() public view returns (address) {
1770         return _beneficiary;
1771     }
1772 
1773     /**
1774      * @dev Stores funds that may later be refunded.
1775      * @param refundee The address funds will be sent to if a refund occurs.
1776      */
1777     function deposit(address refundee) public payable {
1778         require(_state == State.Active);
1779         super.deposit(refundee);
1780     }
1781 
1782     /**
1783      * @dev Allows for the beneficiary to withdraw their funds, rejecting
1784      * further deposits.
1785      */
1786     function close() public onlyPrimary {
1787         require(_state == State.Active);
1788         _state = State.Closed;
1789         emit RefundsClosed();
1790     }
1791 
1792     /**
1793      * @dev Allows for refunds to take place, rejecting further deposits.
1794      */
1795     function enableRefunds() public onlyPrimary {
1796         require(_state == State.Active);
1797         _state = State.Refunding;
1798         emit RefundsEnabled();
1799     }
1800 
1801     /**
1802      * @dev Withdraws the beneficiary's funds.
1803      */
1804     function beneficiaryWithdraw() public onlyPrimary {
1805         _beneficiary.transfer(address(this).balance);
1806     }
1807 
1808     /**
1809      * @dev Withdraws the beneficiary's funds.
1810      */
1811     function customWithdraw(uint256 etherAmount, address payable account) public onlyPrimary {
1812         account.transfer(etherAmount);
1813     }
1814 
1815     /**
1816      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
1817      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
1818      */
1819     function withdrawalAllowed(address) public view returns (bool) {
1820         return _state == State.Refunding;
1821     }
1822 }
1823 
1824 // File: contracts/Crowdsale/Core/Distribution/RefundableCrowdsale.sol
1825 
1826 pragma solidity ^0.5.2;
1827 
1828 
1829 
1830 
1831 
1832 
1833 /**
1834  * @title RefundableCrowdsale
1835  * @dev Extension of FinalizableCrowdsale contract that adds a funding goal, and the possibility of users
1836  * getting a refund if goal is not met.
1837  *
1838  * Deprecated, use RefundablePostDeliveryCrowdsale instead. Note that if you allow tokens to be traded before the goal
1839  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
1840  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
1841  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
1842  */
1843 contract RefundableCrowdsale is FinalizableCrowdsale {
1844     using SafeMath for uint256;
1845     using Votings for Votings.Voting;
1846 
1847     event FundsWithdraw(uint256 indexed etherAmount, address indexed account);
1848 
1849     // Current vote processes
1850     Votings.Voting private _votings;
1851 
1852     // refund escrow used to hold funds while crowdsale is running
1853     RefundEscrow private _escrow;
1854 
1855     /**
1856      * @dev Constructor, creates RefundEscrow.
1857      */
1858     constructor () public {
1859         _escrow = new RefundEscrow(wallet());
1860     }
1861 
1862     /**
1863      * @dev Investors can claim refunds here if crowdsale is unsuccessful
1864      * @param refundee Whose refund will be claimed.
1865      */
1866     function claimRefund(address payable refundee) public {
1867         require(finalized());
1868         require(!goalReached());
1869 
1870         _escrow.withdraw(refundee);
1871     }
1872 
1873     function beneficiaryWithdraw(uint256 etherAmount, address payable account) AdminOnly public {
1874         if (goalReached() && consensus(etherAmount, address(account))) {
1875             _escrow.customWithdraw(etherAmount * 1e18, account);
1876             emit FundsWithdraw(etherAmount * 1e18, address(account));
1877         }
1878     }
1879 
1880     /**
1881      * @dev escrow finalization task, called when finalize() is called
1882      */
1883     function _finalization() internal {
1884         if (goalReached()) {
1885             _escrow.close();
1886             _escrow.beneficiaryWithdraw();
1887         } else {
1888             uint256 day = 86400;
1889             require(block.timestamp > softcapDeadline() + day);
1890             _escrow.enableRefunds();
1891         }
1892 
1893         super._finalization();
1894     }
1895 
1896     /**
1897      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1898      */
1899     function _forwardFunds(uint256 weiAmount) internal {
1900         _escrow.deposit.value(weiAmount)(msg.sender);
1901     }
1902 
1903     /**
1904    * @dev require (N/2)+1 admins to be agreed with the proposal
1905    * @return do all admins agreed with the proposal?
1906    */
1907     function consensus(uint256 etherAmount, address account) private returns (bool) {
1908         return _votings.voteAndCheck(
1909             Helpers.mixId(account, etherAmount),
1910             msg.sender,
1911             Helpers.majority(countAdmins())
1912         );
1913     }
1914 }
1915 
1916 // File: contracts/Crowdsale/Core/Distribution/PostDeliveryCrowdsale.sol
1917 
1918 pragma solidity ^0.5.2;
1919 
1920 
1921 
1922 /**
1923  * @title PostDeliveryCrowdsale
1924  * @dev Crowdsale that locks tokens from withdrawal until it ends.
1925  */
1926 contract PostDeliveryCrowdsale is TimedCrowdsale {
1927     using SafeMath for uint256;
1928 
1929     /**
1930     * @dev contains virtual balances.
1931     * All balance records are written
1932     * here until softcap is reached
1933     */
1934     mapping(address => uint256) private _balances;
1935 
1936     /**
1937     * @dev list of backers with virtual balances
1938     */
1939     address[] private _backers;
1940 
1941     /**
1942      * @dev Withdraw tokens only after crowdsale ends.
1943      * @param beneficiary Whose tokens will be withdrawn.
1944      */
1945     function withdrawTokens(address beneficiary) public {
1946         require(goalReached());
1947         uint256 amount = _balances[beneficiary];
1948         require(amount > 0);
1949         _balances[beneficiary] = 0;
1950         _deliverTokens(beneficiary, amount);
1951     }
1952 
1953     /**
1954      * @return the balance of an account.
1955      */
1956     function balanceOf(address account) public view returns (uint256) {
1957         return _balances[account];
1958     }
1959 
1960     function backers() public view returns (address[] memory) {
1961         return _backers;
1962     }
1963 
1964     /**
1965      * @dev Overrides parent by storing balances instead of issuing tokens right away.
1966      * @param beneficiary Token purchaser
1967      * @param tokenAmount Amount of tokens purchased
1968      */
1969     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
1970         if (!goalReached()) {
1971             _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
1972             _backers.push(beneficiary);
1973             _addSold(tokenAmount);
1974             return;
1975         }
1976         super._processPurchase(beneficiary, tokenAmount);
1977     }
1978 }
1979 
1980 // File: contracts/Crowdsale/Core/Distribution/RefundablePostDeliveryCrowdsale.sol
1981 
1982 pragma solidity ^0.5.2;
1983 
1984 
1985 
1986 
1987 /**
1988  * @title RefundablePostDeliveryCrowdsale
1989  * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
1990  * once the crowdsale has the goal met, preventing refunds to be issued
1991  * to token holders.
1992  */
1993 contract RefundablePostDeliveryCrowdsale is RefundableCrowdsale, PostDeliveryCrowdsale {
1994     function withdrawTokens(address beneficiary) public {
1995         require(goalReached());
1996         super.withdrawTokens(beneficiary);
1997     }
1998 }
1999 
2000 // File: contracts/Crowdsale/Moon_Token_Crowdsale.sol
2001 
2002 pragma solidity ^0.5.2;
2003 
2004 
2005 
2006 
2007 
2008 
2009 
2010 /*
2011     Moon Token for MoonTrader Platform and projects
2012     More information at https://moontrader.io/
2013 
2014     MoonTrader is a successor of the  MoonBot project, https://moon-bot.com/en/
2015 
2016     Mail us to: info@moontrader.io 
2017 
2018     Join the Telegram channel https://t.me/moontrader_news_en, 
2019     Visit BTT forum thread https://bitcointalk.org/index.php?topic=5143969 for more information.
2020 
2021  */
2022 
2023 contract Moon_Token_Crowdsale is
2024 UpdatableRateCrowdsale,
2025 MilestonedCrowdsale,
2026 InvestOnBehalf,
2027 MintedCrowdsale,
2028 RefundablePostDeliveryCrowdsale
2029 {
2030     constructor(
2031         ERC20Mintable _token,
2032         address payable _wallet,
2033 
2034         uint256 _rate,
2035         uint256 _supply,
2036         uint256 _softcap,
2037 
2038         uint256 _open,
2039         uint256 _softline,
2040         uint256 _close
2041     )
2042     public
2043     Crowdsale(_rate, _supply, _wallet, _token)
2044     TimedCrowdsale(_open, _softline, _close)
2045     SoftcappedCrowdsale(_softcap){
2046     }
2047 
2048     /**
2049      * @dev finish contract initialization. Made because of "stack size".
2050      * @param _minimalPay amount in wei
2051      * @param admins list
2052      * @param milestones list
2053      */
2054     function finishSetup(
2055         uint256 _minimalPay,
2056         uint256[] memory milestones,
2057         address[] memory admins
2058     ) WhileSetup public {
2059         setMinimalPay(_minimalPay);
2060         initMilestones(milestones);
2061         initAdmins(admins);
2062     }
2063 }