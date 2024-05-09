1 /**
2  * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
3  * No license
4  */
5 
6 pragma solidity ^0.5.4;
7 
8 library Roles {
9     struct Role {
10         mapping (address => bool) bearer;
11     }
12 
13     /**
14      * @dev give an account access to this role
15      */
16     function add(Role storage role, address account) internal {
17         require(account != address(0));
18         require(!has(role, account));
19 
20         role.bearer[account] = true;
21     }
22 
23     /**
24      * @dev remove an account's access to this role
25      */
26     function remove(Role storage role, address account) internal {
27         require(account != address(0));
28         require(has(role, account));
29 
30         role.bearer[account] = false;
31     }
32 
33     /**
34      * @dev check if an account has this role
35      * @return bool
36      */
37     function has(Role storage role, address account) internal view returns (bool) {
38         require(account != address(0));
39         return role.bearer[account];
40     }
41 }
42 
43 contract PauserRole {
44     using Roles for Roles.Role;
45 
46     event PauserAdded(address indexed account);
47     event PauserRemoved(address indexed account);
48 
49     Roles.Role private _pausers;
50 
51     constructor () internal {
52         _addPauser(msg.sender);
53     }
54 
55     modifier onlyPauser() {
56         require(isPauser(msg.sender));
57         _;
58     }
59 
60     function isPauser(address account) public view returns (bool) {
61         return _pausers.has(account);
62     }
63 
64     function addPauser(address account) public onlyPauser {
65         _addPauser(account);
66     }
67 
68     function renouncePauser() public {
69         _removePauser(msg.sender);
70     }
71 
72     function _addPauser(address account) internal {
73         _pausers.add(account);
74         emit PauserAdded(account);
75     }
76 
77     function _removePauser(address account) internal {
78         _pausers.remove(account);
79         emit PauserRemoved(account);
80     }
81 }
82 
83 contract Pausable is PauserRole {
84     event Paused(address account);
85     event Unpaused(address account);
86 
87     bool private _paused;
88 
89     constructor () internal {
90         _paused = false;
91     }
92 
93     /**
94      * @return true if the contract is paused, false otherwise.
95      */
96     function paused() public view returns (bool) {
97         return _paused;
98     }
99 
100     /**
101      * @dev Modifier to make a function callable only when the contract is not paused.
102      */
103     modifier whenNotPaused() {
104         require(!_paused);
105         _;
106     }
107 
108     /**
109      * @dev Modifier to make a function callable only when the contract is paused.
110      */
111     modifier whenPaused() {
112         require(_paused);
113         _;
114     }
115 
116     /**
117      * @dev called by the owner to pause, triggers stopped state
118      */
119     function pause() public onlyPauser whenNotPaused {
120         _paused = true;
121         emit Paused(msg.sender);
122     }
123 
124     /**
125      * @dev called by the owner to unpause, returns to normal state
126      */
127     function unpause() public onlyPauser whenPaused {
128         _paused = false;
129         emit Unpaused(msg.sender);
130     }
131 }
132 
133 library SafeMath {
134     /**
135      * @dev Multiplies two unsigned integers, reverts on overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 c = a * b;
146         require(c / a == b);
147 
148         return c;
149     }
150 
151     /**
152      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
153      */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Solidity only automatically asserts when dividing by 0
156         require(b > 0);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 
163     /**
164      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         require(b <= a);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Adds two unsigned integers, reverts on overflow.
175      */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         uint256 c = a + b;
178         require(c >= a);
179 
180         return c;
181     }
182 
183     /**
184      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
185      * reverts when dividing by zero.
186      */
187     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188         require(b != 0);
189         return a % b;
190     }
191 }
192 
193 contract Ownable {
194     address private _owner;
195 
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198     /**
199      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200      * account.
201      */
202     constructor () internal {
203         _owner = msg.sender;
204         emit OwnershipTransferred(address(0), _owner);
205     }
206 
207     /**
208      * @return the address of the owner.
209      */
210     function owner() public view returns (address) {
211         return _owner;
212     }
213 
214     /**
215      * @dev Throws if called by any account other than the owner.
216      */
217     modifier onlyOwner() {
218         require(isOwner());
219         _;
220     }
221 
222     /**
223      * @return true if `msg.sender` is the owner of the contract.
224      */
225     function isOwner() public view returns (bool) {
226         return msg.sender == _owner;
227     }
228 
229     /**
230      * @dev Allows the current owner to relinquish control of the contract.
231      * It will not be possible to call the functions with the `onlyOwner`
232      * modifier anymore.
233      * @notice Renouncing ownership will leave the contract without an owner,
234      * thereby removing any functionality that is only available to the owner.
235      */
236     function renounceOwnership() public onlyOwner {
237         emit OwnershipTransferred(_owner, address(0));
238         _owner = address(0);
239     }
240 
241     /**
242      * @dev Allows the current owner to transfer control of the contract to a newOwner.
243      * @param newOwner The address to transfer ownership to.
244      */
245     function transferOwnership(address newOwner) public onlyOwner {
246         _transferOwnership(newOwner);
247     }
248 
249     /**
250      * @dev Transfers control of the contract to a newOwner.
251      * @param newOwner The address to transfer ownership to.
252      */
253     function _transferOwnership(address newOwner) internal {
254         require(newOwner != address(0));
255         emit OwnershipTransferred(_owner, newOwner);
256         _owner = newOwner;
257     }
258 }
259 
260 interface IERC20 {
261     function transfer(address to, uint256 value) external returns (bool);
262 
263     function approve(address spender, uint256 value) external returns (bool);
264 
265     function transferFrom(address from, address to, uint256 value) external returns (bool);
266 
267     function totalSupply() external view returns (uint256);
268 
269     function balanceOf(address who) external view returns (uint256);
270 
271     function allowance(address owner, address spender) external view returns (uint256);
272 
273     event Transfer(address indexed from, address indexed to, uint256 value);
274 
275     event Approval(address indexed owner, address indexed spender, uint256 value);
276 }
277 
278 contract ERC20 is IERC20 {
279     using SafeMath for uint256;
280 
281     mapping (address => uint256) private _balances;
282 
283     mapping (address => mapping (address => uint256)) private _allowed;
284 
285     uint256 private _totalSupply;
286 
287     /**
288      * @dev Total number of tokens in existence
289      */
290     function totalSupply() public view returns (uint256) {
291         return _totalSupply;
292     }
293 
294     /**
295      * @dev Gets the balance of the specified address.
296      * @param owner The address to query the balance of.
297      * @return A uint256 representing the amount owned by the passed address.
298      */
299     function balanceOf(address owner) public view returns (uint256) {
300         return _balances[owner];
301     }
302 
303     /**
304      * @dev Function to check the amount of tokens that an owner allowed to a spender.
305      * @param owner address The address which owns the funds.
306      * @param spender address The address which will spend the funds.
307      * @return A uint256 specifying the amount of tokens still available for the spender.
308      */
309     function allowance(address owner, address spender) public view returns (uint256) {
310         return _allowed[owner][spender];
311     }
312 
313     /**
314      * @dev Transfer token to a specified address
315      * @param to The address to transfer to.
316      * @param value The amount to be transferred.
317      */
318     function transfer(address to, uint256 value) public returns (bool) {
319         _transfer(msg.sender, to, value);
320         return true;
321     }
322 
323     /**
324      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
325      * Beware that changing an allowance with this method brings the risk that someone may use both the old
326      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
327      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
328      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
329      * @param spender The address which will spend the funds.
330      * @param value The amount of tokens to be spent.
331      */
332     function approve(address spender, uint256 value) public returns (bool) {
333         _approve(msg.sender, spender, value);
334         return true;
335     }
336 
337     /**
338      * @dev Transfer tokens from one address to another.
339      * Note that while this function emits an Approval event, this is not required as per the specification,
340      * and other compliant implementations may not emit the event.
341      * @param from address The address which you want to send tokens from
342      * @param to address The address which you want to transfer to
343      * @param value uint256 the amount of tokens to be transferred
344      */
345     function transferFrom(address from, address to, uint256 value) public returns (bool) {
346         _transfer(from, to, value);
347         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
348         return true;
349     }
350 
351     /**
352      * @dev Increase the amount of tokens that an owner allowed to a spender.
353      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
354      * allowed value is better to use this function to avoid 2 calls (and wait until
355      * the first transaction is mined)
356      * From MonolithDAO Token.sol
357      * Emits an Approval event.
358      * @param spender The address which will spend the funds.
359      * @param addedValue The amount of tokens to increase the allowance by.
360      */
361     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
362         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
363         return true;
364     }
365 
366     /**
367      * @dev Decrease the amount of tokens that an owner allowed to a spender.
368      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
369      * allowed value is better to use this function to avoid 2 calls (and wait until
370      * the first transaction is mined)
371      * From MonolithDAO Token.sol
372      * Emits an Approval event.
373      * @param spender The address which will spend the funds.
374      * @param subtractedValue The amount of tokens to decrease the allowance by.
375      */
376     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
377         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
378         return true;
379     }
380 
381     /**
382      * @dev Transfer token for a specified addresses
383      * @param from The address to transfer from.
384      * @param to The address to transfer to.
385      * @param value The amount to be transferred.
386      */
387     function _transfer(address from, address to, uint256 value) internal {
388         require(to != address(0));
389 
390         _balances[from] = _balances[from].sub(value);
391         _balances[to] = _balances[to].add(value);
392         emit Transfer(from, to, value);
393     }
394 
395     /**
396      * @dev Internal function that mints an amount of the token and assigns it to
397      * an account. This encapsulates the modification of balances such that the
398      * proper events are emitted.
399      * @param account The account that will receive the created tokens.
400      * @param value The amount that will be created.
401      */
402     function _mint(address account, uint256 value) internal {
403         require(account != address(0));
404 
405         _totalSupply = _totalSupply.add(value);
406         _balances[account] = _balances[account].add(value);
407         emit Transfer(address(0), account, value);
408     }
409 
410     /**
411      * @dev Internal function that burns an amount of the token of a given
412      * account.
413      * @param account The account whose tokens will be burnt.
414      * @param value The amount that will be burnt.
415      */
416     function _burn(address account, uint256 value) internal {
417         require(account != address(0));
418 
419         _totalSupply = _totalSupply.sub(value);
420         _balances[account] = _balances[account].sub(value);
421         emit Transfer(account, address(0), value);
422     }
423 
424     /**
425      * @dev Approve an address to spend another addresses' tokens.
426      * @param owner The address that owns the tokens.
427      * @param spender The address that will spend the tokens.
428      * @param value The number of tokens that can be spent.
429      */
430     function _approve(address owner, address spender, uint256 value) internal {
431         require(spender != address(0));
432         require(owner != address(0));
433 
434         _allowed[owner][spender] = value;
435         emit Approval(owner, spender, value);
436     }
437 
438     /**
439      * @dev Internal function that burns an amount of the token of a given
440      * account, deducting from the sender's allowance for said account. Uses the
441      * internal burn function.
442      * Emits an Approval event (reflecting the reduced allowance).
443      * @param account The account whose tokens will be burnt.
444      * @param value The amount that will be burnt.
445      */
446     function _burnFrom(address account, uint256 value) internal {
447         _burn(account, value);
448         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
449     }
450 }
451 
452 contract ERC20Detailed is IERC20 {
453     string private _name;
454     string private _symbol;
455     uint8 private _decimals;
456 
457     constructor (string memory name, string memory symbol, uint8 decimals) public {
458         _name = name;
459         _symbol = symbol;
460         _decimals = decimals;
461     }
462 
463     /**
464      * @return the name of the token.
465      */
466     function name() public view returns (string memory) {
467         return _name;
468     }
469 
470     /**
471      * @return the symbol of the token.
472      */
473     function symbol() public view returns (string memory) {
474         return _symbol;
475     }
476 
477     /**
478      * @return the number of decimals of the token.
479      */
480     function decimals() public view returns (uint8) {
481         return _decimals;
482     }
483 }
484 
485 library SafeERC20 {
486     using SafeMath for uint256;
487     using Address for address;
488 
489     function safeTransfer(IERC20 token, address to, uint256 value) internal {
490         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
491     }
492 
493     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
494         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
495     }
496 
497     function safeApprove(IERC20 token, address spender, uint256 value) internal {
498         // safeApprove should only be called when setting an initial allowance,
499         // or when resetting it to zero. To increase and decrease it, use
500         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
501         require((value == 0) || (token.allowance(address(this), spender) == 0));
502         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
503     }
504 
505     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
506         uint256 newAllowance = token.allowance(address(this), spender).add(value);
507         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
508     }
509 
510     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
511         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
512         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
513     }
514 
515     /**
516      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
517      * on the return value: the return value is optional (but if data is returned, it must equal true).
518      * @param token The token targeted by the call.
519      * @param data The call data (encoded using abi.encode or one of its variants).
520      */
521     function callOptionalReturn(IERC20 token, bytes memory data) private {
522         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
523         // we're implementing it ourselves.
524 
525         // A Solidity high level call has three parts:
526         //  1. The target address is checked to verify it contains contract code
527         //  2. The call itself is made, and success asserted
528         //  3. The return value is decoded, which in turn checks the size of the returned data.
529 
530         require(address(token).isContract());
531 
532         // solhint-disable-next-line avoid-low-level-calls
533         (bool success, bytes memory returndata) = address(token).call(data);
534         require(success);
535 
536         if (returndata.length > 0) { // Return data is optional
537             require(abi.decode(returndata, (bool)));
538         }
539     }
540 }
541 
542 library Address {
543     /**
544      * Returns whether the target address is a contract
545      * @dev This function will return false if invoked during the constructor of a contract,
546      * as the code is not actually created until after the constructor finishes.
547      * @param account address of the account to check
548      * @return whether the target address is a contract
549      */
550     function isContract(address account) internal view returns (bool) {
551         uint256 size;
552         // XXX Currently there is no better way to check if there is a contract in an address
553         // than to check the size of the code at that address.
554         // See https://ethereum.stackexchange.com/a/14016/36603
555         // for more details about how this works.
556         // TODO Check this again before the Serenity release, because all addresses will be
557         // contracts then.
558         // solhint-disable-next-line no-inline-assembly
559         assembly { size := extcodesize(account) }
560         return size > 0;
561     }
562 }
563 
564 contract MoneyMarketInterface {
565   function getSupplyBalance(address account, address asset) public view returns (uint);
566   function supply(address asset, uint amount) public returns (uint);
567   function withdraw(address asset, uint requestedAmount) public returns (uint);
568 }
569 
570 contract LoanEscrow is Pausable {
571   using SafeERC20 for IERC20;
572   using SafeMath for uint256;
573 
574   // configurable to any ERC20 (i.e. xCHF)
575   IERC20 public dai = IERC20(0xB4272071eCAdd69d933AdcD19cA99fe80664fc08);  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5  // 0xB4272071eCAdd69d933AdcD19cA99fe80664fc08
576   MoneyMarketInterface public moneyMarket = MoneyMarketInterface(0x3FDA67f7583380E67ef93072294a7fAc882FD7E7);  // 0x6732c278C58FC90542cce498981844A073D693d7
577 
578   event Deposited(address indexed from, uint256 daiAmount);
579   event InterestWithdrawn(address indexed to, uint256 daiAmount);
580   event Pulled(address indexed to, uint256 daiAmount);
581 
582   mapping(address => uint256) public deposits;
583   mapping(address => uint256) public pulls;
584   uint256 public deposited;
585   uint256 public pulled;
586 
587   modifier onlyBlockimmo() {
588     require(msg.sender == blockimmo(), "onlyBlockimmo");
589     _;
590   }
591 
592   function blockimmo() public view returns (address);
593 
594   function withdrawInterest() public onlyBlockimmo {
595     uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), address(dai)).add(dai.balanceOf(address(this))).add(pulled).sub(deposited);
596     require(amountInterest > 0, "no interest");
597 
598     uint256 errorCode = (amountInterest > dai.balanceOf(address(this))) ? moneyMarket.withdraw(address(dai), amountInterest.sub(dai.balanceOf(address(this)))) : 0;
599     require(errorCode == 0, "withdraw failed");
600 
601     dai.safeTransfer(msg.sender, amountInterest);
602     emit InterestWithdrawn(msg.sender, amountInterest);
603   }
604 
605   function withdrawMoneyMarket(uint256 _amountDai) public onlyBlockimmo {
606     uint256 errorCode = moneyMarket.withdraw(address(dai), _amountDai);
607     require(errorCode == 0, "withdraw failed");
608   }
609 
610   function deposit(address _from, uint256 _amountDai) internal {
611     require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");
612 
613     dai.safeTransferFrom(msg.sender, address(this), _amountDai);
614 
615     if (!paused()) {
616       dai.safeApprove(address(moneyMarket), _amountDai);
617 
618       uint256 errorCode = moneyMarket.supply(address(dai), _amountDai);
619       require(errorCode == 0, "supply failed");
620       require(dai.allowance(address(this), address(moneyMarket)) == 0, "allowance not fully consumed by moneyMarket");
621     }
622 
623     deposits[_from] = deposits[_from].add(_amountDai);
624     deposited = deposited.add(_amountDai);
625     emit Deposited(_from, _amountDai);
626   }
627 
628   function pull(address _to, uint256 _amountDai, bool _refund) internal {
629     require(_to != address(0) && _amountDai > 0, "invalid parameter(s)");
630 
631     uint256 errorCode = (_amountDai > dai.balanceOf(address(this))) ? moneyMarket.withdraw(address(dai), _amountDai.sub(dai.balanceOf(address(this)))) : 0;
632     require(errorCode == 0, "withdraw failed");
633 
634     if (_refund) {
635       deposits[_to] = deposits[_to].sub(_amountDai);
636       deposited = deposited.sub(_amountDai);
637     } else {
638       pulls[_to] = pulls[_to].add(_amountDai);
639       pulled = pulled.add(_amountDai);
640     }
641 
642     dai.safeTransfer(_to, _amountDai);
643     emit Pulled(_to, _amountDai);
644   }
645 }
646 
647 contract DividendDistributingToken is ERC20, LoanEscrow {
648   using SafeMath for uint256;
649 
650   uint256 public constant POINTS_PER_DAI = uint256(10) ** 32;
651 
652   uint256 public pointsPerToken = 0;
653   mapping(address => uint256) public credits;
654   mapping(address => uint256) public lastPointsPerToken;
655 
656   event DividendsCollected(address indexed collector, uint256 amount);
657   event DividendsDeposited(address indexed depositor, uint256 amount);
658 
659   function collectOwedDividends(address _account) public {
660     creditAccount(_account);
661 
662     uint256 _dai = credits[_account].div(POINTS_PER_DAI);
663     credits[_account] = 0;
664 
665     pull(_account, _dai, false);
666     emit DividendsCollected(_account, _dai);
667   }
668 
669   function depositDividends() public {  // dividends
670     uint256 amount = dai.allowance(msg.sender, address(this));
671 
672     uint256 fee = amount.div(100);
673     dai.safeTransferFrom(msg.sender, blockimmo(), fee);
674 
675     deposit(msg.sender, amount.sub(fee));
676 
677     // partially tokenized properties store the "non-tokenized" part in `this` contract, dividends not disrupted
678     uint256 issued = totalSupply().sub(unissued());
679     pointsPerToken = pointsPerToken.add(amount.sub(fee).mul(POINTS_PER_DAI).div(issued));
680 
681     emit DividendsDeposited(msg.sender, amount);
682   }
683 
684   function unissued() public view returns (uint256) {
685     return balanceOf(address(this));
686   }
687 
688   function creditAccount(address _account) internal {
689     uint256 amount = balanceOf(_account).mul(pointsPerToken.sub(lastPointsPerToken[_account]));
690 
691     uint256 _credits = credits[_account].add(amount);
692     if (credits[_account] != _credits)
693       credits[_account] = _credits;
694 
695     if (lastPointsPerToken[_account] != pointsPerToken)
696       lastPointsPerToken[_account] = pointsPerToken;
697   }
698 }
699 
700 contract LandRegistryInterface {
701   function getProperty(string memory _eGrid) public view returns (address property);
702 }
703 
704 contract LandRegistryProxyInterface {
705   function owner() public view returns (address);
706   function landRegistry() public view returns (LandRegistryInterface);
707 }
708 
709 contract WhitelistInterface {
710   function checkRole(address _operator, string memory _permission) public view;
711 }
712 
713 contract WhitelistProxyInterface {
714   function whitelist() public view returns (WhitelistInterface);
715 }
716 
717 contract TokenizedProperty is DividendDistributingToken, ERC20Detailed, Ownable {
718   LandRegistryProxyInterface public registryProxy = LandRegistryProxyInterface(0xe72AD2A335AE18e6C7cdb6dAEB64b0330883CD56);  // 0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B;
719   WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(0x7223b032180CDb06Be7a3D634B1E10032111F367);  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
720 
721   uint256 public constant NUM_TOKENS = 1000000;
722 
723   modifier isValid() {
724     LandRegistryInterface registry = LandRegistryInterface(registryProxy.landRegistry());
725     require(registry.getProperty(name()) == address(this), "invalid TokenizedProperty");
726     _;
727   }
728 
729   modifier onlyBlockimmo() {
730     require(msg.sender == blockimmo(), "onlyBlockimmo");
731     _;
732   }
733 
734   constructor(string memory _eGrid, string memory _grundstuck) public ERC20Detailed(_eGrid, _grundstuck, 18) {
735     uint256 totalSupply = NUM_TOKENS.mul(uint256(10) ** decimals());
736     _mint(msg.sender, totalSupply);
737 
738     _approve(address(this), blockimmo(), ~uint256(0));  // enable blockimmo to issue `unissued` tokens in the future
739   }
740 
741   function blockimmo() public view returns (address) {
742     return registryProxy.owner();
743   }
744 
745   function burn(uint256 _value) public isValid {  // buyback
746     creditAccount(msg.sender);
747     _burn(msg.sender, _value);
748   }
749 
750   function mint(address _to, uint256 _value) public isValid onlyBlockimmo returns (bool) {  // equity dilution
751     creditAccount(_to);
752     _mint(_to, _value);
753     return true;
754   }
755 
756   function _transfer(address _from, address _to, uint256 _value) internal isValid {
757     whitelistProxy.whitelist().checkRole(_to, "authorized");
758 
759     creditAccount(_from);  // required for dividends...
760     creditAccount(_to);
761 
762     super._transfer(_from, _to, _value);
763   }
764 }