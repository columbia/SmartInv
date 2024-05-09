1 pragma solidity >=0.5.0;
2 
3 contract WhitelistAdminRole {
4     using Roles for Roles.Role;
5 
6     event WhitelistAdminAdded(address indexed account);
7     event WhitelistAdminRemoved(address indexed account);
8 
9     Roles.Role private _whitelistAdmins;
10 
11     constructor () internal {
12         _addWhitelistAdmin(msg.sender);
13     }
14 
15     modifier onlyWhitelistAdmin() {
16         require(isWhitelistAdmin(msg.sender));
17         _;
18     }
19 
20     function isWhitelistAdmin(address account) public view returns (bool) {
21         return _whitelistAdmins.has(account);
22     }
23 
24     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
25         _addWhitelistAdmin(account);
26     }
27 
28     function renounceWhitelistAdmin() public {
29         _removeWhitelistAdmin(msg.sender);
30     }
31 
32     function _addWhitelistAdmin(address account) internal {
33         _whitelistAdmins.add(account);
34         emit WhitelistAdminAdded(account);
35     }
36 
37     function _removeWhitelistAdmin(address account) internal {
38         _whitelistAdmins.remove(account);
39         emit WhitelistAdminRemoved(account);
40     }
41 }
42 
43 interface IExchangeInteractor {
44     function updatePrice() external;
45 
46     function getCurrentPrice() external view returns (uint256);
47 
48     event PriceUpdated(uint256 newPrice);
49 }
50 
51 contract PauserRole {
52     using Roles for Roles.Role;
53 
54     event PauserAdded(address indexed account);
55     event PauserRemoved(address indexed account);
56 
57     Roles.Role private _pausers;
58 
59     constructor () internal {
60         _addPauser(msg.sender);
61     }
62 
63     modifier onlyPauser() {
64         require(isPauser(msg.sender));
65         _;
66     }
67 
68     function isPauser(address account) public view returns (bool) {
69         return _pausers.has(account);
70     }
71 
72     function addPauser(address account) public onlyPauser {
73         _addPauser(account);
74     }
75 
76     function renouncePauser() public {
77         _removePauser(msg.sender);
78     }
79 
80     function _addPauser(address account) internal {
81         _pausers.add(account);
82         emit PauserAdded(account);
83     }
84 
85     function _removePauser(address account) internal {
86         _pausers.remove(account);
87         emit PauserRemoved(account);
88     }
89 }
90 
91 library SafeERC20 {
92     using SafeMath for uint256;
93 
94     function safeTransfer(IERC20 token, address to, uint256 value) internal {
95         require(token.transfer(to, value));
96     }
97 
98     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
99         require(token.transferFrom(from, to, value));
100     }
101 
102     function safeApprove(IERC20 token, address spender, uint256 value) internal {
103         // safeApprove should only be called when setting an initial allowance,
104         // or when resetting it to zero. To increase and decrease it, use
105         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
106         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
107         require(token.approve(spender, value));
108     }
109 
110     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
111         uint256 newAllowance = token.allowance(address(this), spender).add(value);
112         require(token.approve(spender, newAllowance));
113     }
114 
115     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
116         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
117         require(token.approve(spender, newAllowance));
118     }
119 }
120 
121 contract Ownable {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
128      * account.
129      */
130     constructor () internal {
131         _owner = msg.sender;
132         emit OwnershipTransferred(address(0), _owner);
133     }
134 
135     /**
136      * @return the address of the owner.
137      */
138     function owner() public view returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         require(isOwner());
147         _;
148     }
149 
150     /**
151      * @return true if `msg.sender` is the owner of the contract.
152      */
153     function isOwner() public view returns (bool) {
154         return msg.sender == _owner;
155     }
156 
157     /**
158      * @dev Allows the current owner to relinquish control of the contract.
159      * @notice Renouncing to ownership will leave the contract without an owner.
160      * It will not be possible to call the functions with the `onlyOwner`
161      * modifier anymore.
162      */
163     function renounceOwnership() public onlyOwner {
164         emit OwnershipTransferred(_owner, address(0));
165         _owner = address(0);
166     }
167 
168     /**
169      * @dev Allows the current owner to transfer control of the contract to a newOwner.
170      * @param newOwner The address to transfer ownership to.
171      */
172     function transferOwnership(address newOwner) public onlyOwner {
173         _transferOwnership(newOwner);
174     }
175 
176     /**
177      * @dev Transfers control of the contract to a newOwner.
178      * @param newOwner The address to transfer ownership to.
179      */
180     function _transferOwnership(address newOwner) internal {
181         require(newOwner != address(0));
182         emit OwnershipTransferred(_owner, newOwner);
183         _owner = newOwner;
184     }
185 }
186 
187 contract WhitelistedRole is WhitelistAdminRole {
188     using Roles for Roles.Role;
189 
190     event WhitelistedAdded(address indexed account);
191     event WhitelistedRemoved(address indexed account);
192 
193     Roles.Role private _whitelisteds;
194 
195     modifier onlyWhitelisted() {
196         require(isWhitelisted(msg.sender));
197         _;
198     }
199 
200     function isWhitelisted(address account) public view returns (bool) {
201         return _whitelisteds.has(account);
202     }
203 
204     function addWhitelisted(address account) public onlyWhitelistAdmin {
205         _addWhitelisted(account);
206     }
207 
208     function removeWhitelisted(address account) public onlyWhitelistAdmin {
209         _removeWhitelisted(account);
210     }
211 
212     function renounceWhitelisted() public {
213         _removeWhitelisted(msg.sender);
214     }
215 
216     function _addWhitelisted(address account) internal {
217         _whitelisteds.add(account);
218         emit WhitelistedAdded(account);
219     }
220 
221     function _removeWhitelisted(address account) internal {
222         _whitelisteds.remove(account);
223         emit WhitelistedRemoved(account);
224     }
225 }
226 
227 library Roles {
228     struct Role {
229         mapping (address => bool) bearer;
230     }
231 
232     /**
233      * @dev give an account access to this role
234      */
235     function add(Role storage role, address account) internal {
236         require(account != address(0));
237         require(!has(role, account));
238 
239         role.bearer[account] = true;
240     }
241 
242     /**
243      * @dev remove an account's access to this role
244      */
245     function remove(Role storage role, address account) internal {
246         require(account != address(0));
247         require(has(role, account));
248 
249         role.bearer[account] = false;
250     }
251 
252     /**
253      * @dev check if an account has this role
254      * @return bool
255      */
256     function has(Role storage role, address account) internal view returns (bool) {
257         require(account != address(0));
258         return role.bearer[account];
259     }
260 }
261 
262 contract MinterRole {
263     using Roles for Roles.Role;
264 
265     event MinterAdded(address indexed account);
266     event MinterRemoved(address indexed account);
267 
268     Roles.Role private _minters;
269 
270     constructor () internal {
271         _addMinter(msg.sender);
272     }
273 
274     modifier onlyMinter() {
275         require(isMinter(msg.sender));
276         _;
277     }
278 
279     function isMinter(address account) public view returns (bool) {
280         return _minters.has(account);
281     }
282 
283     function addMinter(address account) public onlyMinter {
284         _addMinter(account);
285     }
286 
287     function renounceMinter() public {
288         _removeMinter(msg.sender);
289     }
290 
291     function _addMinter(address account) internal {
292         _minters.add(account);
293         emit MinterAdded(account);
294     }
295 
296     function _removeMinter(address account) internal {
297         _minters.remove(account);
298         emit MinterRemoved(account);
299     }
300 }
301 
302 contract ReentrancyGuard {
303     /// @dev counter to allow mutex lock with only one SSTORE operation
304     uint256 private _guardCounter;
305 
306     constructor () internal {
307         // The counter starts at one to prevent changing it from zero to a non-zero
308         // value, which is a more expensive operation.
309         _guardCounter = 1;
310     }
311 
312     /**
313      * @dev Prevents a contract from calling itself, directly or indirectly.
314      * Calling a `nonReentrant` function from another `nonReentrant`
315      * function is not supported. It is possible to prevent this from happening
316      * by making the `nonReentrant` function external, and make it call a
317      * `private` function that does the actual work.
318      */
319     modifier nonReentrant() {
320         _guardCounter += 1;
321         uint256 localCounter = _guardCounter;
322         _;
323         require(localCounter == _guardCounter);
324     }
325 }
326 
327 contract Crowdsale is ReentrancyGuard {
328     using SafeMath for uint256;
329     using SafeERC20 for IERC20;
330 
331     // The token being sold
332     IERC20 private _token;
333 
334     // Address where funds are collected
335     address payable private _wallet;
336 
337     // How many token units a buyer gets per wei.
338     // The rate is the conversion between wei and the smallest and indivisible token unit.
339     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
340     // 1 wei will give you 1 unit, or 0.001 TOK.
341     uint256 private _rate;
342 
343     // Amount of wei raised
344     uint256 private _weiRaised;
345 
346     /**
347      * Event for token purchase logging
348      * @param purchaser who paid for the tokens
349      * @param beneficiary who got the tokens
350      * @param value weis paid for purchase
351      * @param amount amount of tokens purchased
352      */
353     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
354 
355     /**
356      * @param rate Number of token units a buyer gets per wei
357      * @dev The rate is the conversion between wei and the smallest and indivisible
358      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
359      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
360      * @param wallet Address where collected funds will be forwarded to
361      * @param token Address of the token being sold
362      */
363     constructor (uint256 rate, address payable wallet, IERC20 token) public {
364         require(rate > 0);
365         require(wallet != address(0));
366         require(address(token) != address(0));
367 
368         _rate = rate;
369         _wallet = wallet;
370         _token = token;
371     }
372 
373     /**
374      * @dev fallback function ***DO NOT OVERRIDE***
375      * Note that other contracts will transfer fund with a base gas stipend
376      * of 2300, which is not enough to call buyTokens. Consider calling
377      * buyTokens directly when purchasing tokens from a contract.
378      */
379     function () external payable {
380         buyTokens(msg.sender);
381     }
382 
383     /**
384      * @return the token being sold.
385      */
386     function token() public view returns (IERC20) {
387         return _token;
388     }
389 
390     /**
391      * @return the address where funds are collected.
392      */
393     function wallet() public view returns (address payable) {
394         return _wallet;
395     }
396 
397     /**
398      * @return the number of token units a buyer gets per wei.
399      */
400     function rate() public view returns (uint256) {
401         return _rate;
402     }
403 
404     /**
405      * @return the amount of wei raised.
406      */
407     function weiRaised() public view returns (uint256) {
408         return _weiRaised;
409     }
410 
411     /**
412      * @dev low level token purchase ***DO NOT OVERRIDE***
413      * This function has a non-reentrancy guard, so it shouldn't be called by
414      * another `nonReentrant` function.
415      * @param beneficiary Recipient of the token purchase
416      */
417     function buyTokens(address beneficiary) public nonReentrant payable {
418         uint256 weiAmount = msg.value;
419         _preValidatePurchase(beneficiary, weiAmount);
420 
421         // calculate token amount to be created
422         uint256 tokens = _getTokenAmount(weiAmount);
423 
424         // update state
425         _weiRaised = _weiRaised.add(weiAmount);
426 
427         _processPurchase(beneficiary, tokens);
428         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
429 
430         _updatePurchasingState(beneficiary, weiAmount);
431 
432         _forwardFunds();
433         _postValidatePurchase(beneficiary, weiAmount);
434     }
435 
436     /**
437      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
438      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
439      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
440      *     super._preValidatePurchase(beneficiary, weiAmount);
441      *     require(weiRaised().add(weiAmount) <= cap);
442      * @param beneficiary Address performing the token purchase
443      * @param weiAmount Value in wei involved in the purchase
444      */
445     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
446         require(beneficiary != address(0));
447         require(weiAmount != 0);
448     }
449 
450     /**
451      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
452      * conditions are not met.
453      * @param beneficiary Address performing the token purchase
454      * @param weiAmount Value in wei involved in the purchase
455      */
456     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
457         // solhint-disable-previous-line no-empty-blocks
458     }
459 
460     /**
461      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
462      * its tokens.
463      * @param beneficiary Address performing the token purchase
464      * @param tokenAmount Number of tokens to be emitted
465      */
466     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
467         _token.safeTransfer(beneficiary, tokenAmount);
468     }
469 
470     /**
471      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
472      * tokens.
473      * @param beneficiary Address receiving the tokens
474      * @param tokenAmount Number of tokens to be purchased
475      */
476     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
477         _deliverTokens(beneficiary, tokenAmount);
478     }
479 
480     /**
481      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
482      * etc.)
483      * @param beneficiary Address receiving the tokens
484      * @param weiAmount Value in wei involved in the purchase
485      */
486     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
487         // solhint-disable-previous-line no-empty-blocks
488     }
489 
490     /**
491      * @dev Override to extend the way in which ether is converted to tokens.
492      * @param weiAmount Value in wei to be converted into tokens
493      * @return Number of tokens that can be purchased with the specified _weiAmount
494      */
495     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
496         return weiAmount.mul(_rate);
497     }
498 
499     /**
500      * @dev Determines how ETH is stored/forwarded on purchases.
501      */
502     function _forwardFunds() internal {
503         _wallet.transfer(msg.value);
504     }
505 }
506 
507 contract MintedCrowdsale is Crowdsale {
508     /**
509      * @dev Overrides delivery by minting tokens upon purchase.
510      * @param beneficiary Token purchaser
511      * @param tokenAmount Number of tokens to be minted
512      */
513     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
514         // Potentially dangerous assumption about the type of the token.
515         require(ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
516     }
517 }
518 
519 contract ThresholdWhitelistedCrowdsale is WhitelistedRole, Crowdsale {
520 
521     uint256 public threshold;
522 
523     constructor (uint256 _threshold) public {
524         threshold = _threshold;
525     }
526 
527     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
528         if (_weiAmount >= threshold) {
529             require(isWhitelisted(_beneficiary), "Investors with large sums must be whitelisted");
530 	}
531         super._preValidatePurchase(_beneficiary, _weiAmount);
532     }
533 
534 }
535 
536 contract TimedCrowdsale is Crowdsale {
537     using SafeMath for uint256;
538 
539     uint256 private _openingTime;
540     uint256 private _closingTime;
541 
542     /**
543      * @dev Reverts if not in crowdsale time range.
544      */
545     modifier onlyWhileOpen {
546         require(isOpen());
547         _;
548     }
549 
550     /**
551      * @dev Constructor, takes crowdsale opening and closing times.
552      * @param openingTime Crowdsale opening time
553      * @param closingTime Crowdsale closing time
554      */
555     constructor (uint256 openingTime, uint256 closingTime) public {
556         // solhint-disable-next-line not-rely-on-time
557         require(openingTime >= block.timestamp);
558         require(closingTime > openingTime);
559 
560         _openingTime = openingTime;
561         _closingTime = closingTime;
562     }
563 
564     /**
565      * @return the crowdsale opening time.
566      */
567     function openingTime() public view returns (uint256) {
568         return _openingTime;
569     }
570 
571     /**
572      * @return the crowdsale closing time.
573      */
574     function closingTime() public view returns (uint256) {
575         return _closingTime;
576     }
577 
578     /**
579      * @return true if the crowdsale is open, false otherwise.
580      */
581     function isOpen() public view returns (bool) {
582         // solhint-disable-next-line not-rely-on-time
583         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
584     }
585 
586     /**
587      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
588      * @return Whether crowdsale period has elapsed
589      */
590     function hasClosed() public view returns (bool) {
591         // solhint-disable-next-line not-rely-on-time
592         return block.timestamp > _closingTime;
593     }
594 
595     /**
596      * @dev Extend parent behavior requiring to be within contributing period
597      * @param beneficiary Token purchaser
598      * @param weiAmount Amount of wei contributed
599      */
600     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
601         super._preValidatePurchase(beneficiary, weiAmount);
602     }
603 }
604 
605 contract CappedCrowdsale is Crowdsale {
606     using SafeMath for uint256;
607 
608     uint256 private _cap;
609 
610     /**
611      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
612      * @param cap Max amount of wei to be contributed
613      */
614     constructor (uint256 cap) public {
615         require(cap > 0);
616         _cap = cap;
617     }
618 
619     /**
620      * @return the cap of the crowdsale.
621      */
622     function cap() public view returns (uint256) {
623         return _cap;
624     }
625 
626     /**
627      * @dev Checks whether the cap has been reached.
628      * @return Whether the cap was reached
629      */
630     function capReached() public view returns (bool) {
631         return weiRaised() >= _cap;
632     }
633 
634     /**
635      * @dev Extend parent behavior requiring purchase to respect the funding cap.
636      * @param beneficiary Token purchaser
637      * @param weiAmount Amount of wei contributed
638      */
639     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
640         super._preValidatePurchase(beneficiary, weiAmount);
641         require(weiRaised().add(weiAmount) <= _cap);
642     }
643 }
644 
645 interface IERC20 {
646     function transfer(address to, uint256 value) external returns (bool);
647 
648     function approve(address spender, uint256 value) external returns (bool);
649 
650     function transferFrom(address from, address to, uint256 value) external returns (bool);
651 
652     function totalSupply() external view returns (uint256);
653 
654     function balanceOf(address who) external view returns (uint256);
655 
656     function allowance(address owner, address spender) external view returns (uint256);
657 
658     event Transfer(address indexed from, address indexed to, uint256 value);
659 
660     event Approval(address indexed owner, address indexed spender, uint256 value);
661 }
662 
663 contract ERC20Detailed is IERC20 {
664     string private _name;
665     string private _symbol;
666     uint8 private _decimals;
667 
668     constructor (string memory name, string memory symbol, uint8 decimals) public {
669         _name = name;
670         _symbol = symbol;
671         _decimals = decimals;
672     }
673 
674     /**
675      * @return the name of the token.
676      */
677     function name() public view returns (string memory) {
678         return _name;
679     }
680 
681     /**
682      * @return the symbol of the token.
683      */
684     function symbol() public view returns (string memory) {
685         return _symbol;
686     }
687 
688     /**
689      * @return the number of decimals of the token.
690      */
691     function decimals() public view returns (uint8) {
692         return _decimals;
693     }
694 }
695 
696 contract ERC20 is IERC20 {
697     using SafeMath for uint256;
698 
699     mapping (address => uint256) private _balances;
700 
701     mapping (address => mapping (address => uint256)) private _allowed;
702 
703     uint256 private _totalSupply;
704 
705     /**
706     * @dev Total number of tokens in existence
707     */
708     function totalSupply() public view returns (uint256) {
709         return _totalSupply;
710     }
711 
712     /**
713     * @dev Gets the balance of the specified address.
714     * @param owner The address to query the balance of.
715     * @return An uint256 representing the amount owned by the passed address.
716     */
717     function balanceOf(address owner) public view returns (uint256) {
718         return _balances[owner];
719     }
720 
721     /**
722      * @dev Function to check the amount of tokens that an owner allowed to a spender.
723      * @param owner address The address which owns the funds.
724      * @param spender address The address which will spend the funds.
725      * @return A uint256 specifying the amount of tokens still available for the spender.
726      */
727     function allowance(address owner, address spender) public view returns (uint256) {
728         return _allowed[owner][spender];
729     }
730 
731     /**
732     * @dev Transfer token for a specified address
733     * @param to The address to transfer to.
734     * @param value The amount to be transferred.
735     */
736     function transfer(address to, uint256 value) public returns (bool) {
737         _transfer(msg.sender, to, value);
738         return true;
739     }
740 
741     /**
742      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
743      * Beware that changing an allowance with this method brings the risk that someone may use both the old
744      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
745      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
746      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
747      * @param spender The address which will spend the funds.
748      * @param value The amount of tokens to be spent.
749      */
750     function approve(address spender, uint256 value) public returns (bool) {
751         require(spender != address(0));
752 
753         _allowed[msg.sender][spender] = value;
754         emit Approval(msg.sender, spender, value);
755         return true;
756     }
757 
758     /**
759      * @dev Transfer tokens from one address to another.
760      * Note that while this function emits an Approval event, this is not required as per the specification,
761      * and other compliant implementations may not emit the event.
762      * @param from address The address which you want to send tokens from
763      * @param to address The address which you want to transfer to
764      * @param value uint256 the amount of tokens to be transferred
765      */
766     function transferFrom(address from, address to, uint256 value) public returns (bool) {
767         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
768         _transfer(from, to, value);
769         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
770         return true;
771     }
772 
773     /**
774      * @dev Increase the amount of tokens that an owner allowed to a spender.
775      * approve should be called when allowed_[_spender] == 0. To increment
776      * allowed value is better to use this function to avoid 2 calls (and wait until
777      * the first transaction is mined)
778      * From MonolithDAO Token.sol
779      * Emits an Approval event.
780      * @param spender The address which will spend the funds.
781      * @param addedValue The amount of tokens to increase the allowance by.
782      */
783     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
784         require(spender != address(0));
785 
786         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
787         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
788         return true;
789     }
790 
791     /**
792      * @dev Decrease the amount of tokens that an owner allowed to a spender.
793      * approve should be called when allowed_[_spender] == 0. To decrement
794      * allowed value is better to use this function to avoid 2 calls (and wait until
795      * the first transaction is mined)
796      * From MonolithDAO Token.sol
797      * Emits an Approval event.
798      * @param spender The address which will spend the funds.
799      * @param subtractedValue The amount of tokens to decrease the allowance by.
800      */
801     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
802         require(spender != address(0));
803 
804         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
805         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
806         return true;
807     }
808 
809     /**
810     * @dev Transfer token for a specified addresses
811     * @param from The address to transfer from.
812     * @param to The address to transfer to.
813     * @param value The amount to be transferred.
814     */
815     function _transfer(address from, address to, uint256 value) internal {
816         require(to != address(0));
817 
818         _balances[from] = _balances[from].sub(value);
819         _balances[to] = _balances[to].add(value);
820         emit Transfer(from, to, value);
821     }
822 
823     /**
824      * @dev Internal function that mints an amount of the token and assigns it to
825      * an account. This encapsulates the modification of balances such that the
826      * proper events are emitted.
827      * @param account The account that will receive the created tokens.
828      * @param value The amount that will be created.
829      */
830     function _mint(address account, uint256 value) internal {
831         require(account != address(0));
832 
833         _totalSupply = _totalSupply.add(value);
834         _balances[account] = _balances[account].add(value);
835         emit Transfer(address(0), account, value);
836     }
837 
838     /**
839      * @dev Internal function that burns an amount of the token of a given
840      * account.
841      * @param account The account whose tokens will be burnt.
842      * @param value The amount that will be burnt.
843      */
844     function _burn(address account, uint256 value) internal {
845         require(account != address(0));
846 
847         _totalSupply = _totalSupply.sub(value);
848         _balances[account] = _balances[account].sub(value);
849         emit Transfer(account, address(0), value);
850     }
851 
852     /**
853      * @dev Internal function that burns an amount of the token of a given
854      * account, deducting from the sender's allowance for said account. Uses the
855      * internal burn function.
856      * Emits an Approval event (reflecting the reduced allowance).
857      * @param account The account whose tokens will be burnt.
858      * @param value The amount that will be burnt.
859      */
860     function _burnFrom(address account, uint256 value) internal {
861         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
862         _burn(account, value);
863         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
864     }
865 }
866 
867 contract ERC20Mintable is ERC20, MinterRole {
868     /**
869      * @dev Function to mint tokens
870      * @param to The address that will receive the minted tokens.
871      * @param value The amount of tokens to mint.
872      * @return A boolean that indicates if the operation was successful.
873      */
874     function mint(address to, uint256 value) public onlyMinter returns (bool) {
875         _mint(to, value);
876         return true;
877     }
878 }
879 
880 contract ERC20Capped is ERC20Mintable {
881     uint256 private _cap;
882 
883     constructor (uint256 cap) public {
884         require(cap > 0);
885         _cap = cap;
886     }
887 
888     /**
889      * @return the cap for the token minting.
890      */
891     function cap() public view returns (uint256) {
892         return _cap;
893     }
894 
895     function _mint(address account, uint256 value) internal {
896         require(totalSupply().add(value) <= _cap);
897         super._mint(account, value);
898     }
899 }
900 
901 contract VrParkToken is ERC20Mintable, ERC20Capped, ERC20Detailed, Ownable {
902 
903     uint8 internal constant DECIMALS = 18;
904 
905     constructor (uint256 _cap) public ERC20Detailed("VR", "VR", DECIMALS)
906         ERC20Capped(_cap) {
907         // empty block
908     }
909 
910     function removeMinter(address account) public onlyOwner {
911         _removeMinter(account);
912     }
913 
914 }
915 
916 contract Pausable is PauserRole {
917     event Paused(address account);
918     event Unpaused(address account);
919 
920     bool private _paused;
921 
922     constructor () internal {
923         _paused = false;
924     }
925 
926     /**
927      * @return true if the contract is paused, false otherwise.
928      */
929     function paused() public view returns (bool) {
930         return _paused;
931     }
932 
933     /**
934      * @dev Modifier to make a function callable only when the contract is not paused.
935      */
936     modifier whenNotPaused() {
937         require(!_paused);
938         _;
939     }
940 
941     /**
942      * @dev Modifier to make a function callable only when the contract is paused.
943      */
944     modifier whenPaused() {
945         require(_paused);
946         _;
947     }
948 
949     /**
950      * @dev called by the owner to pause, triggers stopped state
951      */
952     function pause() public onlyPauser whenNotPaused {
953         _paused = true;
954         emit Paused(msg.sender);
955     }
956 
957     /**
958      * @dev called by the owner to unpause, returns to normal state
959      */
960     function unpause() public onlyPauser whenPaused {
961         _paused = false;
962         emit Unpaused(msg.sender);
963     }
964 }
965 
966 contract PausableCrowdsale is Crowdsale, Pausable {
967     /**
968      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
969      * Use super to concatenate validations.
970      * Adds the validation that the crowdsale must not be paused.
971      * @param _beneficiary Address performing the token purchase
972      * @param _weiAmount Value in wei involved in the purchase
973      */
974     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view whenNotPaused {
975         return super._preValidatePurchase(_beneficiary, _weiAmount);
976     }
977 }
978 
979 contract VrParkIcoStep is TimedCrowdsale, PausableCrowdsale, MintedCrowdsale, CappedCrowdsale {
980 
981     using SafeMath for uint256;
982 
983     uint256 public bonusMultiplier;
984     uint256 public constant ONE_HUNDRED_PERCENT = 100;
985     
986     IExchangeInteractor public interactor;
987 
988     constructor (uint256 _openTime, uint256 _closeTime, uint256 _rate, uint256 _cap, 
989 		 uint256 _bonusMultiplier, address payable _wallet, 
990 		 VrParkToken _token, IExchangeInteractor _interactor) public
991         CappedCrowdsale(_cap)
992         TimedCrowdsale(_openTime, _closeTime)
993         Crowdsale(_rate, _wallet, _token) {
994         require(_bonusMultiplier > 0, "Bonus multiplier must be greater than zero");
995 
996         bonusMultiplier = _bonusMultiplier;
997         interactor = _interactor;
998     }
999 
1000     function _getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
1001         uint256 usdEth = interactor.getCurrentPrice();
1002         uint256 rate = rate();
1003         return usdEth.mul(weiAmount).mul(bonusMultiplier).div(ONE_HUNDRED_PERCENT).div(rate);
1004     }
1005 }
1006 
1007 
1008 library SafeMath {
1009     /**
1010     * @dev Multiplies two unsigned integers, reverts on overflow.
1011     */
1012     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1013         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1014         // benefit is lost if 'b' is also tested.
1015         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1016         if (a == 0) {
1017             return 0;
1018         }
1019 
1020         uint256 c = a * b;
1021         require(c / a == b);
1022 
1023         return c;
1024     }
1025 
1026     /**
1027     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
1028     */
1029     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1030         // Solidity only automatically asserts when dividing by 0
1031         require(b > 0);
1032         uint256 c = a / b;
1033         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1034 
1035         return c;
1036     }
1037 
1038     /**
1039     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1040     */
1041     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1042         require(b <= a);
1043         uint256 c = a - b;
1044 
1045         return c;
1046     }
1047 
1048     /**
1049     * @dev Adds two unsigned integers, reverts on overflow.
1050     */
1051     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1052         uint256 c = a + b;
1053         require(c >= a);
1054 
1055         return c;
1056     }
1057 
1058     /**
1059     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
1060     * reverts when dividing by zero.
1061     */
1062     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1063         require(b != 0);
1064         return a % b;
1065     }
1066 }
1067 
1068 
1069 /*
1070 
1071 ORACLIZE_API
1072 
1073 Copyright (c) 2015-2016 Oraclize SRL
1074 Copyright (c) 2016 Oraclize LTD
1075 
1076 Permission is hereby granted, free of charge, to any person obtaining a copy
1077 of this software and associated documentation files (the "Software"), to deal
1078 in the Software without restriction, including without limitation the rights
1079 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1080 copies of the Software, and to permit persons to whom the Software is
1081 furnished to do so, subject to the following conditions:
1082 
1083 The above copyright notice and this permission notice shall be included in
1084 all copies or substantial portions of the Software.
1085 
1086 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1087 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1088 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
1089 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1090 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1091 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
1092 THE SOFTWARE.
1093 
1094 */
1095 pragma solidity >= 0.5.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
1096 
1097 // Dummy contract only used to emit to end-user they are using wrong solc
1098 contract solcChecker {
1099 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
1100 }
1101 
1102 contract OraclizeI {
1103 
1104     address public cbAddress;
1105 
1106     function setProofType(byte _proofType) external;
1107     function setCustomGasPrice(uint _gasPrice) external;
1108     function getPrice(string memory _datasource) public returns (uint _dsprice);
1109     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
1110     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
1111     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
1112     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
1113     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
1114     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
1115     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
1116     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
1117 }
1118 
1119 contract OraclizeAddrResolverI {
1120     function getAddress() public returns (address _address);
1121 }
1122 /*
1123 
1124 Begin solidity-cborutils
1125 
1126 https://github.com/smartcontractkit/solidity-cborutils
1127 
1128 MIT License
1129 
1130 Copyright (c) 2018 SmartContract ChainLink, Ltd.
1131 
1132 Permission is hereby granted, free of charge, to any person obtaining a copy
1133 of this software and associated documentation files (the "Software"), to deal
1134 in the Software without restriction, including without limitation the rights
1135 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1136 copies of the Software, and to permit persons to whom the Software is
1137 furnished to do so, subject to the following conditions:
1138 
1139 The above copyright notice and this permission notice shall be included in all
1140 copies or substantial portions of the Software.
1141 
1142 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1143 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1144 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1145 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1146 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1147 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1148 SOFTWARE.
1149 
1150 */
1151 library Buffer {
1152 
1153     struct buffer {
1154         bytes buf;
1155         uint capacity;
1156     }
1157 
1158     function init(buffer memory _buf, uint _capacity) internal pure {
1159         uint capacity = _capacity;
1160         if (capacity % 32 != 0) {
1161             capacity += 32 - (capacity % 32);
1162         }
1163         _buf.capacity = capacity; // Allocate space for the buffer data
1164         assembly {
1165             let ptr := mload(0x40)
1166             mstore(_buf, ptr)
1167             mstore(ptr, 0)
1168             mstore(0x40, add(ptr, capacity))
1169         }
1170     }
1171 
1172     function resize(buffer memory _buf, uint _capacity) private pure {
1173         bytes memory oldbuf = _buf.buf;
1174         init(_buf, _capacity);
1175         append(_buf, oldbuf);
1176     }
1177 
1178     function max(uint _a, uint _b) private pure returns (uint _max) {
1179         if (_a > _b) {
1180             return _a;
1181         }
1182         return _b;
1183     }
1184     /**
1185       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
1186       *      would exceed the capacity of the buffer.
1187       * @param _buf The buffer to append to.
1188       * @param _data The data to append.
1189       * @return The original buffer.
1190       *
1191       */
1192     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
1193         if (_data.length + _buf.buf.length > _buf.capacity) {
1194             resize(_buf, max(_buf.capacity, _data.length) * 2);
1195         }
1196         uint dest;
1197         uint src;
1198         uint len = _data.length;
1199         assembly {
1200             let bufptr := mload(_buf) // Memory address of the buffer data
1201             let buflen := mload(bufptr) // Length of existing buffer data
1202             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
1203             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
1204             src := add(_data, 32)
1205         }
1206         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
1207             assembly {
1208                 mstore(dest, mload(src))
1209             }
1210             dest += 32;
1211             src += 32;
1212         }
1213         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
1214         assembly {
1215             let srcpart := and(mload(src), not(mask))
1216             let destpart := and(mload(dest), mask)
1217             mstore(dest, or(destpart, srcpart))
1218         }
1219         return _buf;
1220     }
1221     /**
1222       *
1223       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
1224       * exceed the capacity of the buffer.
1225       * @param _buf The buffer to append to.
1226       * @param _data The data to append.
1227       * @return The original buffer.
1228       *
1229       */
1230     function append(buffer memory _buf, uint8 _data) internal pure {
1231         if (_buf.buf.length + 1 > _buf.capacity) {
1232             resize(_buf, _buf.capacity * 2);
1233         }
1234         assembly {
1235             let bufptr := mload(_buf) // Memory address of the buffer data
1236             let buflen := mload(bufptr) // Length of existing buffer data
1237             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
1238             mstore8(dest, _data)
1239             mstore(bufptr, add(buflen, 1)) // Update buffer length
1240         }
1241     }
1242     /**
1243       *
1244       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
1245       * exceed the capacity of the buffer.
1246       * @param _buf The buffer to append to.
1247       * @param _data The data to append.
1248       * @return The original buffer.
1249       *
1250       */
1251     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
1252         if (_len + _buf.buf.length > _buf.capacity) {
1253             resize(_buf, max(_buf.capacity, _len) * 2);
1254         }
1255         uint mask = 256 ** _len - 1;
1256         assembly {
1257             let bufptr := mload(_buf) // Memory address of the buffer data
1258             let buflen := mload(bufptr) // Length of existing buffer data
1259             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
1260             mstore(dest, or(and(mload(dest), not(mask)), _data))
1261             mstore(bufptr, add(buflen, _len)) // Update buffer length
1262         }
1263         return _buf;
1264     }
1265 }
1266 
1267 library CBOR {
1268 
1269     using Buffer for Buffer.buffer;
1270 
1271     uint8 private constant MAJOR_TYPE_INT = 0;
1272     uint8 private constant MAJOR_TYPE_MAP = 5;
1273     uint8 private constant MAJOR_TYPE_BYTES = 2;
1274     uint8 private constant MAJOR_TYPE_ARRAY = 4;
1275     uint8 private constant MAJOR_TYPE_STRING = 3;
1276     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
1277     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
1278 
1279     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
1280         if (_value <= 23) {
1281             _buf.append(uint8((_major << 5) | _value));
1282         } else if (_value <= 0xFF) {
1283             _buf.append(uint8((_major << 5) | 24));
1284             _buf.appendInt(_value, 1);
1285         } else if (_value <= 0xFFFF) {
1286             _buf.append(uint8((_major << 5) | 25));
1287             _buf.appendInt(_value, 2);
1288         } else if (_value <= 0xFFFFFFFF) {
1289             _buf.append(uint8((_major << 5) | 26));
1290             _buf.appendInt(_value, 4);
1291         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
1292             _buf.append(uint8((_major << 5) | 27));
1293             _buf.appendInt(_value, 8);
1294         }
1295     }
1296 
1297     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
1298         _buf.append(uint8((_major << 5) | 31));
1299     }
1300 
1301     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
1302         encodeType(_buf, MAJOR_TYPE_INT, _value);
1303     }
1304 
1305     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
1306         if (_value >= 0) {
1307             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
1308         } else {
1309             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
1310         }
1311     }
1312 
1313     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
1314         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
1315         _buf.append(_value);
1316     }
1317 
1318     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
1319         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
1320         _buf.append(bytes(_value));
1321     }
1322 
1323     function startArray(Buffer.buffer memory _buf) internal pure {
1324         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
1325     }
1326 
1327     function startMap(Buffer.buffer memory _buf) internal pure {
1328         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
1329     }
1330 
1331     function endSequence(Buffer.buffer memory _buf) internal pure {
1332         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
1333     }
1334 }
1335 /*
1336 
1337 End solidity-cborutils
1338 
1339 */
1340 contract usingOraclize {
1341 
1342     using CBOR for Buffer.buffer;
1343 
1344     OraclizeI oraclize;
1345     OraclizeAddrResolverI OAR;
1346 
1347     uint constant day = 60 * 60 * 24;
1348     uint constant week = 60 * 60 * 24 * 7;
1349     uint constant month = 60 * 60 * 24 * 30;
1350 
1351     byte constant proofType_NONE = 0x00;
1352     byte constant proofType_Ledger = 0x30;
1353     byte constant proofType_Native = 0xF0;
1354     byte constant proofStorage_IPFS = 0x01;
1355     byte constant proofType_Android = 0x40;
1356     byte constant proofType_TLSNotary = 0x10;
1357 
1358     string oraclize_network_name;
1359     uint8 constant networkID_auto = 0;
1360     uint8 constant networkID_morden = 2;
1361     uint8 constant networkID_mainnet = 1;
1362     uint8 constant networkID_testnet = 2;
1363     uint8 constant networkID_consensys = 161;
1364 
1365     mapping(bytes32 => bytes32) oraclize_randomDS_args;
1366     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
1367 
1368     modifier oraclizeAPI {
1369         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
1370             oraclize_setNetwork(networkID_auto);
1371         }
1372         if (address(oraclize) != OAR.getAddress()) {
1373             oraclize = OraclizeI(OAR.getAddress());
1374         }
1375         _;
1376     }
1377 
1378     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
1379         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1380         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
1381         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1382         require(proofVerified);
1383         _;
1384     }
1385 
1386     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
1387       return oraclize_setNetwork();
1388       _networkID; // silence the warning and remain backwards compatible
1389     }
1390 
1391     function oraclize_setNetworkName(string memory _network_name) internal {
1392         oraclize_network_name = _network_name;
1393     }
1394 
1395     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
1396         return oraclize_network_name;
1397     }
1398 
1399     function oraclize_setNetwork() internal returns (bool _networkSet) {
1400         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
1401             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1402             oraclize_setNetworkName("eth_mainnet");
1403             return true;
1404         }
1405         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
1406             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1407             oraclize_setNetworkName("eth_ropsten3");
1408             return true;
1409         }
1410         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
1411             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1412             oraclize_setNetworkName("eth_kovan");
1413             return true;
1414         }
1415         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
1416             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1417             oraclize_setNetworkName("eth_rinkeby");
1418             return true;
1419         }
1420         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
1421             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1422             return true;
1423         }
1424         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
1425             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1426             return true;
1427         }
1428         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
1429             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1430             return true;
1431         }
1432         return false;
1433     }
1434 
1435     function __callback(bytes32 _myid, string memory _result) public {
1436         __callback(_myid, _result, new bytes(0));
1437     }
1438 
1439     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
1440       return;
1441       _myid; _result; _proof; // Silence compiler warnings
1442     }
1443 
1444     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
1445         return oraclize.getPrice(_datasource);
1446     }
1447 
1448     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
1449         return oraclize.getPrice(_datasource, _gasLimit);
1450     }
1451 
1452     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
1453         uint price = oraclize.getPrice(_datasource);
1454         if (price > 1 ether + tx.gasprice * 200000) {
1455             return 0; // Unexpectedly high price
1456         }
1457         return oraclize.query.value(price)(0, _datasource, _arg);
1458     }
1459 
1460     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
1461         uint price = oraclize.getPrice(_datasource);
1462         if (price > 1 ether + tx.gasprice * 200000) {
1463             return 0; // Unexpectedly high price
1464         }
1465         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
1466     }
1467 
1468     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1469         uint price = oraclize.getPrice(_datasource,_gasLimit);
1470         if (price > 1 ether + tx.gasprice * _gasLimit) {
1471             return 0; // Unexpectedly high price
1472         }
1473         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
1474     }
1475 
1476     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1477         uint price = oraclize.getPrice(_datasource, _gasLimit);
1478         if (price > 1 ether + tx.gasprice * _gasLimit) {
1479            return 0; // Unexpectedly high price
1480         }
1481         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
1482     }
1483 
1484     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
1485         uint price = oraclize.getPrice(_datasource);
1486         if (price > 1 ether + tx.gasprice * 200000) {
1487             return 0; // Unexpectedly high price
1488         }
1489         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
1490     }
1491 
1492     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
1493         uint price = oraclize.getPrice(_datasource);
1494         if (price > 1 ether + tx.gasprice * 200000) {
1495             return 0; // Unexpectedly high price
1496         }
1497         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
1498     }
1499 
1500     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1501         uint price = oraclize.getPrice(_datasource, _gasLimit);
1502         if (price > 1 ether + tx.gasprice * _gasLimit) {
1503             return 0; // Unexpectedly high price
1504         }
1505         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
1506     }
1507 
1508     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1509         uint price = oraclize.getPrice(_datasource, _gasLimit);
1510         if (price > 1 ether + tx.gasprice * _gasLimit) {
1511             return 0; // Unexpectedly high price
1512         }
1513         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
1514     }
1515 
1516     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1517         uint price = oraclize.getPrice(_datasource);
1518         if (price > 1 ether + tx.gasprice * 200000) {
1519             return 0; // Unexpectedly high price
1520         }
1521         bytes memory args = stra2cbor(_argN);
1522         return oraclize.queryN.value(price)(0, _datasource, args);
1523     }
1524 
1525     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1526         uint price = oraclize.getPrice(_datasource);
1527         if (price > 1 ether + tx.gasprice * 200000) {
1528             return 0; // Unexpectedly high price
1529         }
1530         bytes memory args = stra2cbor(_argN);
1531         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
1532     }
1533 
1534     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1535         uint price = oraclize.getPrice(_datasource, _gasLimit);
1536         if (price > 1 ether + tx.gasprice * _gasLimit) {
1537             return 0; // Unexpectedly high price
1538         }
1539         bytes memory args = stra2cbor(_argN);
1540         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
1541     }
1542 
1543     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1544         uint price = oraclize.getPrice(_datasource, _gasLimit);
1545         if (price > 1 ether + tx.gasprice * _gasLimit) {
1546             return 0; // Unexpectedly high price
1547         }
1548         bytes memory args = stra2cbor(_argN);
1549         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
1550     }
1551 
1552     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1553         string[] memory dynargs = new string[](1);
1554         dynargs[0] = _args[0];
1555         return oraclize_query(_datasource, dynargs);
1556     }
1557 
1558     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1559         string[] memory dynargs = new string[](1);
1560         dynargs[0] = _args[0];
1561         return oraclize_query(_timestamp, _datasource, dynargs);
1562     }
1563 
1564     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1565         string[] memory dynargs = new string[](1);
1566         dynargs[0] = _args[0];
1567         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1568     }
1569 
1570     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1571         string[] memory dynargs = new string[](1);
1572         dynargs[0] = _args[0];
1573         return oraclize_query(_datasource, dynargs, _gasLimit);
1574     }
1575 
1576     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1577         string[] memory dynargs = new string[](2);
1578         dynargs[0] = _args[0];
1579         dynargs[1] = _args[1];
1580         return oraclize_query(_datasource, dynargs);
1581     }
1582 
1583     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1584         string[] memory dynargs = new string[](2);
1585         dynargs[0] = _args[0];
1586         dynargs[1] = _args[1];
1587         return oraclize_query(_timestamp, _datasource, dynargs);
1588     }
1589 
1590     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1591         string[] memory dynargs = new string[](2);
1592         dynargs[0] = _args[0];
1593         dynargs[1] = _args[1];
1594         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1595     }
1596 
1597     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1598         string[] memory dynargs = new string[](2);
1599         dynargs[0] = _args[0];
1600         dynargs[1] = _args[1];
1601         return oraclize_query(_datasource, dynargs, _gasLimit);
1602     }
1603 
1604     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1605         string[] memory dynargs = new string[](3);
1606         dynargs[0] = _args[0];
1607         dynargs[1] = _args[1];
1608         dynargs[2] = _args[2];
1609         return oraclize_query(_datasource, dynargs);
1610     }
1611 
1612     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1613         string[] memory dynargs = new string[](3);
1614         dynargs[0] = _args[0];
1615         dynargs[1] = _args[1];
1616         dynargs[2] = _args[2];
1617         return oraclize_query(_timestamp, _datasource, dynargs);
1618     }
1619 
1620     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1621         string[] memory dynargs = new string[](3);
1622         dynargs[0] = _args[0];
1623         dynargs[1] = _args[1];
1624         dynargs[2] = _args[2];
1625         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1626     }
1627 
1628     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1629         string[] memory dynargs = new string[](3);
1630         dynargs[0] = _args[0];
1631         dynargs[1] = _args[1];
1632         dynargs[2] = _args[2];
1633         return oraclize_query(_datasource, dynargs, _gasLimit);
1634     }
1635 
1636     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1637         string[] memory dynargs = new string[](4);
1638         dynargs[0] = _args[0];
1639         dynargs[1] = _args[1];
1640         dynargs[2] = _args[2];
1641         dynargs[3] = _args[3];
1642         return oraclize_query(_datasource, dynargs);
1643     }
1644 
1645     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1646         string[] memory dynargs = new string[](4);
1647         dynargs[0] = _args[0];
1648         dynargs[1] = _args[1];
1649         dynargs[2] = _args[2];
1650         dynargs[3] = _args[3];
1651         return oraclize_query(_timestamp, _datasource, dynargs);
1652     }
1653 
1654     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1655         string[] memory dynargs = new string[](4);
1656         dynargs[0] = _args[0];
1657         dynargs[1] = _args[1];
1658         dynargs[2] = _args[2];
1659         dynargs[3] = _args[3];
1660         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1661     }
1662 
1663     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1664         string[] memory dynargs = new string[](4);
1665         dynargs[0] = _args[0];
1666         dynargs[1] = _args[1];
1667         dynargs[2] = _args[2];
1668         dynargs[3] = _args[3];
1669         return oraclize_query(_datasource, dynargs, _gasLimit);
1670     }
1671 
1672     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1673         string[] memory dynargs = new string[](5);
1674         dynargs[0] = _args[0];
1675         dynargs[1] = _args[1];
1676         dynargs[2] = _args[2];
1677         dynargs[3] = _args[3];
1678         dynargs[4] = _args[4];
1679         return oraclize_query(_datasource, dynargs);
1680     }
1681 
1682     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1683         string[] memory dynargs = new string[](5);
1684         dynargs[0] = _args[0];
1685         dynargs[1] = _args[1];
1686         dynargs[2] = _args[2];
1687         dynargs[3] = _args[3];
1688         dynargs[4] = _args[4];
1689         return oraclize_query(_timestamp, _datasource, dynargs);
1690     }
1691 
1692     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1693         string[] memory dynargs = new string[](5);
1694         dynargs[0] = _args[0];
1695         dynargs[1] = _args[1];
1696         dynargs[2] = _args[2];
1697         dynargs[3] = _args[3];
1698         dynargs[4] = _args[4];
1699         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1700     }
1701 
1702     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1703         string[] memory dynargs = new string[](5);
1704         dynargs[0] = _args[0];
1705         dynargs[1] = _args[1];
1706         dynargs[2] = _args[2];
1707         dynargs[3] = _args[3];
1708         dynargs[4] = _args[4];
1709         return oraclize_query(_datasource, dynargs, _gasLimit);
1710     }
1711 
1712     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1713         uint price = oraclize.getPrice(_datasource);
1714         if (price > 1 ether + tx.gasprice * 200000) {
1715             return 0; // Unexpectedly high price
1716         }
1717         bytes memory args = ba2cbor(_argN);
1718         return oraclize.queryN.value(price)(0, _datasource, args);
1719     }
1720 
1721     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1722         uint price = oraclize.getPrice(_datasource);
1723         if (price > 1 ether + tx.gasprice * 200000) {
1724             return 0; // Unexpectedly high price
1725         }
1726         bytes memory args = ba2cbor(_argN);
1727         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
1728     }
1729 
1730     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1731         uint price = oraclize.getPrice(_datasource, _gasLimit);
1732         if (price > 1 ether + tx.gasprice * _gasLimit) {
1733             return 0; // Unexpectedly high price
1734         }
1735         bytes memory args = ba2cbor(_argN);
1736         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
1737     }
1738 
1739     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1740         uint price = oraclize.getPrice(_datasource, _gasLimit);
1741         if (price > 1 ether + tx.gasprice * _gasLimit) {
1742             return 0; // Unexpectedly high price
1743         }
1744         bytes memory args = ba2cbor(_argN);
1745         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
1746     }
1747 
1748     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1749         bytes[] memory dynargs = new bytes[](1);
1750         dynargs[0] = _args[0];
1751         return oraclize_query(_datasource, dynargs);
1752     }
1753 
1754     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1755         bytes[] memory dynargs = new bytes[](1);
1756         dynargs[0] = _args[0];
1757         return oraclize_query(_timestamp, _datasource, dynargs);
1758     }
1759 
1760     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1761         bytes[] memory dynargs = new bytes[](1);
1762         dynargs[0] = _args[0];
1763         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1764     }
1765 
1766     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1767         bytes[] memory dynargs = new bytes[](1);
1768         dynargs[0] = _args[0];
1769         return oraclize_query(_datasource, dynargs, _gasLimit);
1770     }
1771 
1772     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1773         bytes[] memory dynargs = new bytes[](2);
1774         dynargs[0] = _args[0];
1775         dynargs[1] = _args[1];
1776         return oraclize_query(_datasource, dynargs);
1777     }
1778 
1779     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1780         bytes[] memory dynargs = new bytes[](2);
1781         dynargs[0] = _args[0];
1782         dynargs[1] = _args[1];
1783         return oraclize_query(_timestamp, _datasource, dynargs);
1784     }
1785 
1786     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1787         bytes[] memory dynargs = new bytes[](2);
1788         dynargs[0] = _args[0];
1789         dynargs[1] = _args[1];
1790         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1791     }
1792 
1793     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1794         bytes[] memory dynargs = new bytes[](2);
1795         dynargs[0] = _args[0];
1796         dynargs[1] = _args[1];
1797         return oraclize_query(_datasource, dynargs, _gasLimit);
1798     }
1799 
1800     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1801         bytes[] memory dynargs = new bytes[](3);
1802         dynargs[0] = _args[0];
1803         dynargs[1] = _args[1];
1804         dynargs[2] = _args[2];
1805         return oraclize_query(_datasource, dynargs);
1806     }
1807 
1808     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1809         bytes[] memory dynargs = new bytes[](3);
1810         dynargs[0] = _args[0];
1811         dynargs[1] = _args[1];
1812         dynargs[2] = _args[2];
1813         return oraclize_query(_timestamp, _datasource, dynargs);
1814     }
1815 
1816     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1817         bytes[] memory dynargs = new bytes[](3);
1818         dynargs[0] = _args[0];
1819         dynargs[1] = _args[1];
1820         dynargs[2] = _args[2];
1821         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1822     }
1823 
1824     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1825         bytes[] memory dynargs = new bytes[](3);
1826         dynargs[0] = _args[0];
1827         dynargs[1] = _args[1];
1828         dynargs[2] = _args[2];
1829         return oraclize_query(_datasource, dynargs, _gasLimit);
1830     }
1831 
1832     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1833         bytes[] memory dynargs = new bytes[](4);
1834         dynargs[0] = _args[0];
1835         dynargs[1] = _args[1];
1836         dynargs[2] = _args[2];
1837         dynargs[3] = _args[3];
1838         return oraclize_query(_datasource, dynargs);
1839     }
1840 
1841     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1842         bytes[] memory dynargs = new bytes[](4);
1843         dynargs[0] = _args[0];
1844         dynargs[1] = _args[1];
1845         dynargs[2] = _args[2];
1846         dynargs[3] = _args[3];
1847         return oraclize_query(_timestamp, _datasource, dynargs);
1848     }
1849 
1850     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1851         bytes[] memory dynargs = new bytes[](4);
1852         dynargs[0] = _args[0];
1853         dynargs[1] = _args[1];
1854         dynargs[2] = _args[2];
1855         dynargs[3] = _args[3];
1856         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1857     }
1858 
1859     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1860         bytes[] memory dynargs = new bytes[](4);
1861         dynargs[0] = _args[0];
1862         dynargs[1] = _args[1];
1863         dynargs[2] = _args[2];
1864         dynargs[3] = _args[3];
1865         return oraclize_query(_datasource, dynargs, _gasLimit);
1866     }
1867 
1868     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1869         bytes[] memory dynargs = new bytes[](5);
1870         dynargs[0] = _args[0];
1871         dynargs[1] = _args[1];
1872         dynargs[2] = _args[2];
1873         dynargs[3] = _args[3];
1874         dynargs[4] = _args[4];
1875         return oraclize_query(_datasource, dynargs);
1876     }
1877 
1878     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1879         bytes[] memory dynargs = new bytes[](5);
1880         dynargs[0] = _args[0];
1881         dynargs[1] = _args[1];
1882         dynargs[2] = _args[2];
1883         dynargs[3] = _args[3];
1884         dynargs[4] = _args[4];
1885         return oraclize_query(_timestamp, _datasource, dynargs);
1886     }
1887 
1888     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1889         bytes[] memory dynargs = new bytes[](5);
1890         dynargs[0] = _args[0];
1891         dynargs[1] = _args[1];
1892         dynargs[2] = _args[2];
1893         dynargs[3] = _args[3];
1894         dynargs[4] = _args[4];
1895         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1896     }
1897 
1898     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1899         bytes[] memory dynargs = new bytes[](5);
1900         dynargs[0] = _args[0];
1901         dynargs[1] = _args[1];
1902         dynargs[2] = _args[2];
1903         dynargs[3] = _args[3];
1904         dynargs[4] = _args[4];
1905         return oraclize_query(_datasource, dynargs, _gasLimit);
1906     }
1907 
1908     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
1909         return oraclize.setProofType(_proofP);
1910     }
1911 
1912 
1913     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
1914         return oraclize.cbAddress();
1915     }
1916 
1917     function getCodeSize(address _addr) view internal returns (uint _size) {
1918         assembly {
1919             _size := extcodesize(_addr)
1920         }
1921     }
1922 
1923     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
1924         return oraclize.setCustomGasPrice(_gasPrice);
1925     }
1926 
1927     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
1928         return oraclize.randomDS_getSessionPubKeyHash();
1929     }
1930 
1931     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
1932         bytes memory tmp = bytes(_a);
1933         uint160 iaddr = 0;
1934         uint160 b1;
1935         uint160 b2;
1936         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
1937             iaddr *= 256;
1938             b1 = uint160(uint8(tmp[i]));
1939             b2 = uint160(uint8(tmp[i + 1]));
1940             if ((b1 >= 97) && (b1 <= 102)) {
1941                 b1 -= 87;
1942             } else if ((b1 >= 65) && (b1 <= 70)) {
1943                 b1 -= 55;
1944             } else if ((b1 >= 48) && (b1 <= 57)) {
1945                 b1 -= 48;
1946             }
1947             if ((b2 >= 97) && (b2 <= 102)) {
1948                 b2 -= 87;
1949             } else if ((b2 >= 65) && (b2 <= 70)) {
1950                 b2 -= 55;
1951             } else if ((b2 >= 48) && (b2 <= 57)) {
1952                 b2 -= 48;
1953             }
1954             iaddr += (b1 * 16 + b2);
1955         }
1956         return address(iaddr);
1957     }
1958 
1959     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
1960         bytes memory a = bytes(_a);
1961         bytes memory b = bytes(_b);
1962         uint minLength = a.length;
1963         if (b.length < minLength) {
1964             minLength = b.length;
1965         }
1966         for (uint i = 0; i < minLength; i ++) {
1967             if (a[i] < b[i]) {
1968                 return -1;
1969             } else if (a[i] > b[i]) {
1970                 return 1;
1971             }
1972         }
1973         if (a.length < b.length) {
1974             return -1;
1975         } else if (a.length > b.length) {
1976             return 1;
1977         } else {
1978             return 0;
1979         }
1980     }
1981 
1982     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
1983         bytes memory h = bytes(_haystack);
1984         bytes memory n = bytes(_needle);
1985         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
1986             return -1;
1987         } else if (h.length > (2 ** 128 - 1)) {
1988             return -1;
1989         } else {
1990             uint subindex = 0;
1991             for (uint i = 0; i < h.length; i++) {
1992                 if (h[i] == n[0]) {
1993                     subindex = 1;
1994                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
1995                         subindex++;
1996                     }
1997                     if (subindex == n.length) {
1998                         return int(i);
1999                     }
2000                 }
2001             }
2002             return -1;
2003         }
2004     }
2005 
2006     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
2007         return strConcat(_a, _b, "", "", "");
2008     }
2009 
2010     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
2011         return strConcat(_a, _b, _c, "", "");
2012     }
2013 
2014     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
2015         return strConcat(_a, _b, _c, _d, "");
2016     }
2017 
2018     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
2019         bytes memory _ba = bytes(_a);
2020         bytes memory _bb = bytes(_b);
2021         bytes memory _bc = bytes(_c);
2022         bytes memory _bd = bytes(_d);
2023         bytes memory _be = bytes(_e);
2024         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
2025         bytes memory babcde = bytes(abcde);
2026         uint k = 0;
2027         uint i = 0;
2028         for (i = 0; i < _ba.length; i++) {
2029             babcde[k++] = _ba[i];
2030         }
2031         for (i = 0; i < _bb.length; i++) {
2032             babcde[k++] = _bb[i];
2033         }
2034         for (i = 0; i < _bc.length; i++) {
2035             babcde[k++] = _bc[i];
2036         }
2037         for (i = 0; i < _bd.length; i++) {
2038             babcde[k++] = _bd[i];
2039         }
2040         for (i = 0; i < _be.length; i++) {
2041             babcde[k++] = _be[i];
2042         }
2043         return string(babcde);
2044     }
2045 
2046     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
2047         return safeParseInt(_a, 0);
2048     }
2049 
2050     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
2051         bytes memory bresult = bytes(_a);
2052         uint mint = 0;
2053         bool decimals = false;
2054         for (uint i = 0; i < bresult.length; i++) {
2055             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
2056                 if (decimals) {
2057                    if (_b == 0) break;
2058                     else _b--;
2059                 }
2060                 mint *= 10;
2061                 mint += uint(uint8(bresult[i])) - 48;
2062             } else if (uint(uint8(bresult[i])) == 46) {
2063                 require(!decimals, 'More than one decimal encountered in string!');
2064                 decimals = true;
2065             } else {
2066                 revert("Non-numeral character encountered in string!");
2067             }
2068         }
2069         if (_b > 0) {
2070             mint *= 10 ** _b;
2071         }
2072         return mint;
2073     }
2074 
2075     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
2076         return parseInt(_a, 0);
2077     }
2078 
2079     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
2080         bytes memory bresult = bytes(_a);
2081         uint mint = 0;
2082         bool decimals = false;
2083         for (uint i = 0; i < bresult.length; i++) {
2084             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
2085                 if (decimals) {
2086                    if (_b == 0) {
2087                        break;
2088                    } else {
2089                        _b--;
2090                    }
2091                 }
2092                 mint *= 10;
2093                 mint += uint(uint8(bresult[i])) - 48;
2094             } else if (uint(uint8(bresult[i])) == 46) {
2095                 decimals = true;
2096             }
2097         }
2098         if (_b > 0) {
2099             mint *= 10 ** _b;
2100         }
2101         return mint;
2102     }
2103 
2104     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
2105         if (_i == 0) {
2106             return "0";
2107         }
2108         uint j = _i;
2109         uint len;
2110         while (j != 0) {
2111             len++;
2112             j /= 10;
2113         }
2114         bytes memory bstr = new bytes(len);
2115         uint k = len - 1;
2116         while (_i != 0) {
2117             bstr[k--] = byte(uint8(48 + _i % 10));
2118             _i /= 10;
2119         }
2120         return string(bstr);
2121     }
2122 
2123     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
2124         safeMemoryCleaner();
2125         Buffer.buffer memory buf;
2126         Buffer.init(buf, 1024);
2127         buf.startArray();
2128         for (uint i = 0; i < _arr.length; i++) {
2129             buf.encodeString(_arr[i]);
2130         }
2131         buf.endSequence();
2132         return buf.buf;
2133     }
2134 
2135     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
2136         safeMemoryCleaner();
2137         Buffer.buffer memory buf;
2138         Buffer.init(buf, 1024);
2139         buf.startArray();
2140         for (uint i = 0; i < _arr.length; i++) {
2141             buf.encodeBytes(_arr[i]);
2142         }
2143         buf.endSequence();
2144         return buf.buf;
2145     }
2146 
2147     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
2148         require((_nbytes > 0) && (_nbytes <= 32));
2149         _delay *= 10; // Convert from seconds to ledger timer ticks
2150         bytes memory nbytes = new bytes(1);
2151         nbytes[0] = byte(uint8(_nbytes));
2152         bytes memory unonce = new bytes(32);
2153         bytes memory sessionKeyHash = new bytes(32);
2154         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
2155         assembly {
2156             mstore(unonce, 0x20)
2157             /*
2158              The following variables can be relaxed.
2159              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
2160              for an idea on how to override and replace commit hash variables.
2161             */
2162             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
2163             mstore(sessionKeyHash, 0x20)
2164             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
2165         }
2166         bytes memory delay = new bytes(32);
2167         assembly {
2168             mstore(add(delay, 0x20), _delay)
2169         }
2170         bytes memory delay_bytes8 = new bytes(8);
2171         copyBytes(delay, 24, 8, delay_bytes8, 0);
2172         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
2173         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
2174         bytes memory delay_bytes8_left = new bytes(8);
2175         assembly {
2176             let x := mload(add(delay_bytes8, 0x20))
2177             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
2178             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
2179             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
2180             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
2181             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
2182             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
2183             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
2184             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
2185         }
2186         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
2187         return queryId;
2188     }
2189 
2190     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
2191         oraclize_randomDS_args[_queryId] = _commitment;
2192     }
2193 
2194     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
2195         bool sigok;
2196         address signer;
2197         bytes32 sigr;
2198         bytes32 sigs;
2199         bytes memory sigr_ = new bytes(32);
2200         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
2201         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
2202         bytes memory sigs_ = new bytes(32);
2203         offset += 32 + 2;
2204         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
2205         assembly {
2206             sigr := mload(add(sigr_, 32))
2207             sigs := mload(add(sigs_, 32))
2208         }
2209         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
2210         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
2211             return true;
2212         } else {
2213             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
2214             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
2215         }
2216     }
2217 
2218     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
2219         bool sigok;
2220         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
2221         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
2222         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
2223         bytes memory appkey1_pubkey = new bytes(64);
2224         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
2225         bytes memory tosign2 = new bytes(1 + 65 + 32);
2226         tosign2[0] = byte(uint8(1)); //role
2227         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
2228         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
2229         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
2230         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
2231         if (!sigok) {
2232             return false;
2233         }
2234         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
2235         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
2236         bytes memory tosign3 = new bytes(1 + 65);
2237         tosign3[0] = 0xFE;
2238         copyBytes(_proof, 3, 65, tosign3, 1);
2239         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
2240         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
2241         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
2242         return sigok;
2243     }
2244 
2245     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
2246         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
2247         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
2248             return 1;
2249         }
2250         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
2251         if (!proofVerified) {
2252             return 2;
2253         }
2254         return 0;
2255     }
2256 
2257     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
2258         bool match_ = true;
2259         require(_prefix.length == _nRandomBytes);
2260         for (uint256 i = 0; i< _nRandomBytes; i++) {
2261             if (_content[i] != _prefix[i]) {
2262                 match_ = false;
2263             }
2264         }
2265         return match_;
2266     }
2267 
2268     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
2269         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
2270         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
2271         bytes memory keyhash = new bytes(32);
2272         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
2273         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
2274             return false;
2275         }
2276         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
2277         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
2278         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
2279         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
2280             return false;
2281         }
2282         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
2283         // This is to verify that the computed args match with the ones specified in the query.
2284         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
2285         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
2286         bytes memory sessionPubkey = new bytes(64);
2287         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
2288         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
2289         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
2290         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
2291             delete oraclize_randomDS_args[_queryId];
2292         } else return false;
2293         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
2294         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
2295         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
2296         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
2297             return false;
2298         }
2299         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
2300         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
2301             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
2302         }
2303         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
2304     }
2305     /*
2306      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2307     */
2308     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
2309         uint minLength = _length + _toOffset;
2310         require(_to.length >= minLength); // Buffer too small. Should be a better way?
2311         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
2312         uint j = 32 + _toOffset;
2313         while (i < (32 + _fromOffset + _length)) {
2314             assembly {
2315                 let tmp := mload(add(_from, i))
2316                 mstore(add(_to, j), tmp)
2317             }
2318             i += 32;
2319             j += 32;
2320         }
2321         return _to;
2322     }
2323     /*
2324      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2325      Duplicate Solidity's ecrecover, but catching the CALL return value
2326     */
2327     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
2328         /*
2329          We do our own memory management here. Solidity uses memory offset
2330          0x40 to store the current end of memory. We write past it (as
2331          writes are memory extensions), but don't update the offset so
2332          Solidity will reuse it. The memory used here is only needed for
2333          this context.
2334          FIXME: inline assembly can't access return values
2335         */
2336         bool ret;
2337         address addr;
2338         assembly {
2339             let size := mload(0x40)
2340             mstore(size, _hash)
2341             mstore(add(size, 32), _v)
2342             mstore(add(size, 64), _r)
2343             mstore(add(size, 96), _s)
2344             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
2345             addr := mload(size)
2346         }
2347         return (ret, addr);
2348     }
2349     /*
2350      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2351     */
2352     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
2353         bytes32 r;
2354         bytes32 s;
2355         uint8 v;
2356         if (_sig.length != 65) {
2357             return (false, address(0));
2358         }
2359         /*
2360          The signature format is a compact form of:
2361            {bytes32 r}{bytes32 s}{uint8 v}
2362          Compact means, uint8 is not padded to 32 bytes.
2363         */
2364         assembly {
2365             r := mload(add(_sig, 32))
2366             s := mload(add(_sig, 64))
2367             /*
2368              Here we are loading the last 32 bytes. We exploit the fact that
2369              'mload' will pad with zeroes if we overread.
2370              There is no 'mload8' to do this, but that would be nicer.
2371             */
2372             v := byte(0, mload(add(_sig, 96)))
2373             /*
2374               Alternative solution:
2375               'byte' is not working due to the Solidity parser, so lets
2376               use the second best option, 'and'
2377               v := and(mload(add(_sig, 65)), 255)
2378             */
2379         }
2380         /*
2381          albeit non-transactional signatures are not specified by the YP, one would expect it
2382          to match the YP range of [27, 28]
2383          geth uses [0, 1] and some clients have followed. This might change, see:
2384          https://github.com/ethereum/go-ethereum/issues/2053
2385         */
2386         if (v < 27) {
2387             v += 27;
2388         }
2389         if (v != 27 && v != 28) {
2390             return (false, address(0));
2391         }
2392         return safer_ecrecover(_hash, v, r, s);
2393     }
2394 
2395     function safeMemoryCleaner() internal pure {
2396         assembly {
2397             let fmem := mload(0x40)
2398             codecopy(fmem, codesize, sub(msize, fmem))
2399         }
2400     }
2401 }
2402 /*
2403 
2404 END ORACLIZE_API
2405 
2406 */
2407 
2408 
2409 /**
2410  * @title Exchange interactor for Monoreto ICO.
2411  * 
2412  */
2413 contract ExchangeInteractor is usingOraclize, IExchangeInteractor, Ownable {
2414 
2415     using SafeMath for uint256;
2416 
2417     // 4 hours
2418     uint256 public constant QUERY_TIME_PERIOD = 14400;
2419 
2420     uint256 public usdEthRate;
2421     string public jsonPath = "json(json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0)";
2422 
2423     event NewUsdEthRate(uint256 rate);
2424     event NewQuery(string comment);
2425     event EthReceived(uint256 eth);
2426 
2427     constructor (uint256 _initialUsdEthRate) public {
2428         require(_initialUsdEthRate > 0, "Initial USDETH rate must be greater than zero!");
2429 
2430         usdEthRate = _initialUsdEthRate;
2431 
2432         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
2433         updatePrice();
2434     }
2435 
2436     /**
2437      * @dev when using oraclize, ETH are withdrawed from contract address
2438      * so it should be able to receive ETH.
2439      */
2440     function () external payable {
2441         emit EthReceived(msg.value);
2442     }
2443 
2444     function setJsonPath(string calldata _jsonPath) external onlyOwner {
2445         jsonPath = _jsonPath;
2446     }
2447 
2448     function __callback(bytes32 myid, string memory result, bytes memory proof) public {
2449         require(msg.sender == oraclize_cbAddress(), "Invoked not by oraclize address!");
2450         usdEthRate = parseInt(result, 5).div(100000);
2451         emit NewUsdEthRate(usdEthRate);
2452         updatePrice();
2453     }
2454 
2455     function updatePrice() public onlyOwner {
2456         if (oraclize.getPrice("URL") > address(this).balance) {
2457             emit NewQuery("Insufficient funds");
2458         } else {
2459             oraclize_query(QUERY_TIME_PERIOD, "URL", jsonPath);
2460         }
2461     }
2462 
2463     function getCurrentPrice() public view returns (uint256) {
2464         return usdEthRate;
2465     }
2466 
2467     function close() public onlyOwner {
2468         msg.sender.transfer(address(this).balance);
2469     }
2470 
2471 }