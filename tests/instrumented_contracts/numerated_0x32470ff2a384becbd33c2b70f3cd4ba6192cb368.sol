1 /**
2  * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
3  * No license
4  */
5 
6 pragma solidity ^0.5.3;
7 
8 /**
9  * @title SafeMath
10  * @dev Unsigned math operations with safety checks that revert on error
11  */
12 library SafeMath {
13     /**
14     * @dev Multiplies two unsigned integers, reverts on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b);
26 
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Solidity only automatically asserts when dividing by 0
35         require(b > 0);
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38 
39         return c;
40     }
41 
42     /**
43     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44     */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b <= a);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53     * @dev Adds two unsigned integers, reverts on overflow.
54     */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a);
58 
59         return c;
60     }
61 
62     /**
63     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
64     * reverts when dividing by zero.
65     */
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b != 0);
68         return a % b;
69     }
70 }
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78     address private _owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     /**
83      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84      * account.
85      */
86     constructor () internal {
87         _owner = msg.sender;
88         emit OwnershipTransferred(address(0), _owner);
89     }
90 
91     /**
92      * @return the address of the owner.
93      */
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     /**
99      * @dev Throws if called by any account other than the owner.
100      */
101     modifier onlyOwner() {
102         require(isOwner());
103         _;
104     }
105 
106     /**
107      * @return true if `msg.sender` is the owner of the contract.
108      */
109     function isOwner() public view returns (bool) {
110         return msg.sender == _owner;
111     }
112 
113     /**
114      * @dev Allows the current owner to relinquish control of the contract.
115      * @notice Renouncing to ownership will leave the contract without an owner.
116      * It will not be possible to call the functions with the `onlyOwner`
117      * modifier anymore.
118      */
119     function renounceOwnership() public onlyOwner {
120         emit OwnershipTransferred(_owner, address(0));
121         _owner = address(0);
122     }
123 
124     /**
125      * @dev Allows the current owner to transfer control of the contract to a newOwner.
126      * @param newOwner The address to transfer ownership to.
127      */
128     function transferOwnership(address newOwner) public onlyOwner {
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers control of the contract to a newOwner.
134      * @param newOwner The address to transfer ownership to.
135      */
136     function _transferOwnership(address newOwner) internal {
137         require(newOwner != address(0));
138         emit OwnershipTransferred(_owner, newOwner);
139         _owner = newOwner;
140     }
141 }
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 interface IERC20 {
148     function transfer(address to, uint256 value) external returns (bool);
149 
150     function approve(address spender, uint256 value) external returns (bool);
151 
152     function transferFrom(address from, address to, uint256 value) external returns (bool);
153 
154     function totalSupply() external view returns (uint256);
155 
156     function balanceOf(address who) external view returns (uint256);
157 
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     event Transfer(address indexed from, address indexed to, uint256 value);
161 
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
170  * Originally based on code by FirstBlood:
171  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  *
173  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
174  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
175  * compliant implementations may not do it.
176  */
177 contract ERC20 is IERC20 {
178     using SafeMath for uint256;
179 
180     mapping (address => uint256) private _balances;
181 
182     mapping (address => mapping (address => uint256)) private _allowed;
183 
184     uint256 private _totalSupply;
185 
186     /**
187     * @dev Total number of tokens in existence
188     */
189     function totalSupply() public view returns (uint256) {
190         return _totalSupply;
191     }
192 
193     /**
194     * @dev Gets the balance of the specified address.
195     * @param owner The address to query the balance of.
196     * @return An uint256 representing the amount owned by the passed address.
197     */
198     function balanceOf(address owner) public view returns (uint256) {
199         return _balances[owner];
200     }
201 
202     /**
203      * @dev Function to check the amount of tokens that an owner allowed to a spender.
204      * @param owner address The address which owns the funds.
205      * @param spender address The address which will spend the funds.
206      * @return A uint256 specifying the amount of tokens still available for the spender.
207      */
208     function allowance(address owner, address spender) public view returns (uint256) {
209         return _allowed[owner][spender];
210     }
211 
212     /**
213     * @dev Transfer token for a specified address
214     * @param to The address to transfer to.
215     * @param value The amount to be transferred.
216     */
217     function transfer(address to, uint256 value) public returns (bool) {
218         _transfer(msg.sender, to, value);
219         return true;
220     }
221 
222     /**
223      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224      * Beware that changing an allowance with this method brings the risk that someone may use both the old
225      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      * @param spender The address which will spend the funds.
229      * @param value The amount of tokens to be spent.
230      */
231     function approve(address spender, uint256 value) public returns (bool) {
232         _approve(msg.sender, spender, value);
233         return true;
234     }
235 
236     /**
237      * @dev Transfer tokens from one address to another.
238      * Note that while this function emits an Approval event, this is not required as per the specification,
239      * and other compliant implementations may not emit the event.
240      * @param from address The address which you want to send tokens from
241      * @param to address The address which you want to transfer to
242      * @param value uint256 the amount of tokens to be transferred
243      */
244     function transferFrom(address from, address to, uint256 value) public returns (bool) {
245         _transfer(from, to, value);
246         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
247         return true;
248     }
249 
250     /**
251      * @dev Increase the amount of tokens that an owner allowed to a spender.
252      * approve should be called when allowed_[_spender] == 0. To increment
253      * allowed value is better to use this function to avoid 2 calls (and wait until
254      * the first transaction is mined)
255      * From MonolithDAO Token.sol
256      * Emits an Approval event.
257      * @param spender The address which will spend the funds.
258      * @param addedValue The amount of tokens to increase the allowance by.
259      */
260     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
261         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
262         return true;
263     }
264 
265     /**
266      * @dev Decrease the amount of tokens that an owner allowed to a spender.
267      * approve should be called when allowed_[_spender] == 0. To decrement
268      * allowed value is better to use this function to avoid 2 calls (and wait until
269      * the first transaction is mined)
270      * From MonolithDAO Token.sol
271      * Emits an Approval event.
272      * @param spender The address which will spend the funds.
273      * @param subtractedValue The amount of tokens to decrease the allowance by.
274      */
275     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
276         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
277         return true;
278     }
279 
280     /**
281     * @dev Transfer token for a specified addresses
282     * @param from The address to transfer from.
283     * @param to The address to transfer to.
284     * @param value The amount to be transferred.
285     */
286     function _transfer(address from, address to, uint256 value) internal {
287         require(to != address(0));
288 
289         _balances[from] = _balances[from].sub(value);
290         _balances[to] = _balances[to].add(value);
291         emit Transfer(from, to, value);
292     }
293 
294     /**
295      * @dev Internal function that mints an amount of the token and assigns it to
296      * an account. This encapsulates the modification of balances such that the
297      * proper events are emitted.
298      * @param account The account that will receive the created tokens.
299      * @param value The amount that will be created.
300      */
301     function _mint(address account, uint256 value) internal {
302         require(account != address(0));
303 
304         _totalSupply = _totalSupply.add(value);
305         _balances[account] = _balances[account].add(value);
306         emit Transfer(address(0), account, value);
307     }
308 
309     /**
310      * @dev Internal function that burns an amount of the token of a given
311      * account.
312      * @param account The account whose tokens will be burnt.
313      * @param value The amount that will be burnt.
314      */
315     function _burn(address account, uint256 value) internal {
316         require(account != address(0));
317 
318         _totalSupply = _totalSupply.sub(value);
319         _balances[account] = _balances[account].sub(value);
320         emit Transfer(account, address(0), value);
321     }
322 
323     /**
324      * @dev Approve an address to spend another addresses' tokens.
325      * @param owner The address that owns the tokens.
326      * @param spender The address that will spend the tokens.
327      * @param value The number of tokens that can be spent.
328      */
329     function _approve(address owner, address spender, uint256 value) internal {
330         require(spender != address(0));
331         require(owner != address(0));
332 
333         _allowed[owner][spender] = value;
334         emit Approval(owner, spender, value);
335     }
336 
337     /**
338      * @dev Internal function that burns an amount of the token of a given
339      * account, deducting from the sender's allowance for said account. Uses the
340      * internal burn function.
341      * Emits an Approval event (reflecting the reduced allowance).
342      * @param account The account whose tokens will be burnt.
343      * @param value The amount that will be burnt.
344      */
345     function _burnFrom(address account, uint256 value) internal {
346         _burn(account, value);
347         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
348     }
349 }
350 
351 /**
352  * @title ERC20Detailed token
353  * @dev The decimals are only for visualization purposes.
354  * All the operations are done using the smallest and indivisible token unit,
355  * just as on Ethereum all the operations are done in wei.
356  */
357 contract ERC20Detailed is IERC20 {
358     string private _name;
359     string private _symbol;
360     uint8 private _decimals;
361 
362     constructor (string memory name, string memory symbol, uint8 decimals) public {
363         _name = name;
364         _symbol = symbol;
365         _decimals = decimals;
366     }
367 
368     /**
369      * @return the name of the token.
370      */
371     function name() public view returns (string memory) {
372         return _name;
373     }
374 
375     /**
376      * @return the symbol of the token.
377      */
378     function symbol() public view returns (string memory) {
379         return _symbol;
380     }
381 
382     /**
383      * @return the number of decimals of the token.
384      */
385     function decimals() public view returns (uint8) {
386         return _decimals;
387     }
388 }
389 
390 /**
391  * @title SafeERC20
392  * @dev Wrappers around ERC20 operations that throw on failure.
393  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
394  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
395  */
396 library SafeERC20 {
397     using SafeMath for uint256;
398 
399     function safeTransfer(IERC20 token, address to, uint256 value) internal {
400         require(token.transfer(to, value));
401     }
402 
403     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
404         require(token.transferFrom(from, to, value));
405     }
406 
407     function safeApprove(IERC20 token, address spender, uint256 value) internal {
408         // safeApprove should only be called when setting an initial allowance,
409         // or when resetting it to zero. To increase and decrease it, use
410         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
411         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
412         require(token.approve(spender, value));
413     }
414 
415     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         uint256 newAllowance = token.allowance(address(this), spender).add(value);
417         require(token.approve(spender, newAllowance));
418     }
419 
420     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
422         require(token.approve(spender, newAllowance));
423     }
424 }
425 
426 contract MoneyMarketInterface {
427   function getSupplyBalance(address account, address asset) public view returns (uint);
428   function supply(address asset, uint amount) public returns (uint);
429   function withdraw(address asset, uint requestedAmount) public returns (uint);
430 }
431 
432 contract LoanEscrow {
433   using SafeERC20 for IERC20;
434   using SafeMath for uint256;
435 
436   address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
437   IERC20 public dai = IERC20(DAI_ADDRESS);
438 
439   address public constant MONEY_MARKET_ADDRESS = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;  // 0x6732c278C58FC90542cce498981844A073D693d7;
440   MoneyMarketInterface public moneyMarket = MoneyMarketInterface(MONEY_MARKET_ADDRESS);
441 
442   event Deposited(address indexed from, uint256 daiAmount);
443   event Pulled(address indexed to, uint256 daiAmount);
444   event InterestWithdrawn(address indexed to, uint256 daiAmount);
445 
446   mapping(address => uint256) public deposits;
447   mapping(address => uint256) public pulls;
448   uint256 public deposited;
449   uint256 public pulled;
450 
451   modifier onlyBlockimmo() {
452     require(msg.sender == blockimmo());
453     _;
454   }
455 
456   function blockimmo() public returns (address);
457 
458   function withdrawInterest() public onlyBlockimmo {
459     uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), DAI_ADDRESS).add(pulled).sub(deposited);
460     require(amountInterest > 0, "no interest");
461 
462     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, amountInterest);
463     require(errorCode == 0, "withdraw failed");
464 
465     dai.safeTransfer(msg.sender, amountInterest);
466     emit InterestWithdrawn(msg.sender, amountInterest);
467   }
468 
469   function deposit(address _from, uint256 _amountDai) internal {
470     require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");
471     dai.safeTransferFrom(msg.sender, address(this), _amountDai);
472 
473     require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "non-zero initial moneyMarket allowance");
474     require(dai.approve(MONEY_MARKET_ADDRESS, _amountDai), "approving moneyMarket failed");
475 
476     uint256 errorCode = moneyMarket.supply(DAI_ADDRESS, _amountDai);
477     require(errorCode == 0, "supply failed");
478     require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "allowance not fully consumed by moneyMarket");
479 
480     deposits[_from] = deposits[_from].add(_amountDai);
481     deposited = deposited.add(_amountDai);
482     emit Deposited(_from, _amountDai);
483   }
484 
485   function pull(address _to, uint256 _amountDai, bool refund) internal {
486     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, _amountDai);
487     require(errorCode == 0, "withdraw failed");
488 
489     if (refund) {
490       deposits[_to] = deposits[_to].sub(_amountDai);
491       deposited = deposited.sub(_amountDai);
492     } else {
493       pulls[_to] = pulls[_to].add(_amountDai);
494       pulled = pulled.add(_amountDai);
495     }
496 
497     dai.safeTransfer(_to, _amountDai);
498     emit Pulled(_to, _amountDai);
499   }
500 }
501 
502 /**
503  * @title DividendDistributingToken
504  * @dev An ERC20-compliant token that distributes any Dai it receives to its token holders proportionate to their share.
505  *
506  * Implementation based on: https://blog.pennyether.com/posts/realtime-dividend-token.html#the-token
507  *
508  * The user is responsible for when they transact tokens (transacting before a dividend payout is probably not ideal).
509  *
510  * `TokenizedProperty` inherits from `this` and is the front-facing contract representing the rights / ownership to a property.
511  */
512 contract DividendDistributingToken is ERC20, LoanEscrow {
513   using SafeMath for uint256;
514 
515   uint256 public constant POINTS_PER_DAI = uint256(10) ** 32;
516 
517   uint256 public pointsPerToken = 0;
518   mapping(address => uint256) public credits;
519   mapping(address => uint256) public lastPointsPerToken;
520 
521   event DividendsDeposited(address indexed depositor, uint256 amount);
522   event DividendsCollected(address indexed collector, uint256 amount);
523 
524   function collectOwedDividends() public {
525     creditAccount(msg.sender);
526 
527     uint256 _dai = credits[msg.sender].div(POINTS_PER_DAI);
528     credits[msg.sender] = 0;
529 
530     pull(msg.sender, _dai, false);
531     emit DividendsCollected(msg.sender, _dai);
532   }
533 
534   function depositDividends() public {  // dividends
535     uint256 amount = dai.allowance(msg.sender, address(this));
536 
537     uint256 fee = amount.div(100);
538     dai.safeTransferFrom(msg.sender, blockimmo(), fee);
539 
540     deposit(msg.sender, amount.sub(fee));
541 
542     pointsPerToken = pointsPerToken.add(amount.sub(fee).mul(POINTS_PER_DAI).div(totalSupply()));
543     emit DividendsDeposited(msg.sender, amount);
544   }
545 
546   function creditAccount(address _account) internal {
547     uint256 amount = balanceOf(_account).mul(pointsPerToken.sub(lastPointsPerToken[_account]));
548     credits[_account] = credits[_account].add(amount);
549     lastPointsPerToken[_account] = pointsPerToken;
550   }
551 }
552 
553 contract LandRegistryInterface {
554   function getProperty(string memory _eGrid) public view returns (address property);
555 }
556 
557 contract LandRegistryProxyInterface {
558   function owner() public view returns (address);
559   function landRegistry() public view returns (LandRegistryInterface);
560 }
561 
562 contract WhitelistInterface {
563   function checkRole(address _operator, string memory _permission) public view;
564 }
565 
566 contract WhitelistProxyInterface {
567   function whitelist() public view returns (WhitelistInterface);
568 }
569 
570 /**
571  * @title TokenizedProperty
572  * @dev An asset-backed security token (a property as identified by its E-GRID (a UUID) in the (Swiss) land registry).
573  *
574  * Ownership of `this` must be transferred to `ShareholderDAO` before blockimmo will verify `this` as legitimate in `LandRegistry`.
575  * Until verified legitimate, transferring tokens is not possible (locked).
576  *
577  * Tokens can be freely listed on exchanges (especially decentralized / 0x).
578  *
579  * `this.owner` can make two suggestions that blockimmo will always (try) to take: `setManagementCompany` and `untokenize`.
580  * `this.owner` can also transfer or rescind ownership.
581  * See `ShareholderDAO` documentation for more information...
582  *
583  * Our legal framework requires a `TokenizedProperty` must be possible to `untokenize`.
584  * Un-tokenizing is also the first step to upgrading or an outright sale of `this`.
585  *
586  * For both:
587  *   1. `owner` emits an `UntokenizeRequest`
588  *   2. blockimmo removes `this` from the `LandRegistry`
589  *
590  * Upgrading:
591  *   3. blockimmo migrates `this` to the new `TokenizedProperty` (ie perfectly preserving `this.balances`)
592  *   4. blockimmo attaches `owner` to the property (1)
593  *   5. blockimmo adds the property to `LandRegistry`
594  *
595  * Outright sale:
596  *   3. blockimmo deploys a new `TokenizedProperty` and adds it to the `LandRegistry`
597  *   4. blockimmo configures and deploys a `TokenSale` for the property with `TokenSale.wallet == address(this)`
598  *      (raised Ether distributed to current token holders as a dividend payout)
599  *        - if the sale is unsuccessful, the new property is removed from the `LandRegistry`, and `this` is added back
600  */
601 contract TokenizedProperty is DividendDistributingToken, ERC20Detailed, Ownable {
602   address public constant LAND_REGISTRY_PROXY_ADDRESS = 0xe72AD2A335AE18e6C7cdb6dAEB64b0330883CD56;  // 0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B;
603   address public constant WHITELIST_PROXY_ADDRESS = 0x7223b032180CDb06Be7a3D634B1E10032111F367;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
604 
605   LandRegistryProxyInterface public registryProxy = LandRegistryProxyInterface(LAND_REGISTRY_PROXY_ADDRESS);
606   WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);
607 
608   uint256 public constant NUM_TOKENS = 1000000;
609 
610   string public managementCompany;
611   mapping(address => uint256) public lastTransferBlock;
612   mapping(address => uint256) public minTransferAccepted;
613 
614   event MinTransferSet(address indexed account, uint256 minTransfer);
615   event ManagementCompanySet(string managementCompany);
616   event UntokenizeRequest();
617   event Generic(string generic);
618 
619   modifier isValid() {
620     LandRegistryInterface registry = LandRegistryInterface(registryProxy.landRegistry());
621     require(registry.getProperty(name()) == address(this), "invalid TokenizedProperty");
622     _;
623   }
624 
625   constructor(string memory _eGrid, string memory _grundstuck) public ERC20Detailed(_eGrid, _grundstuck, 18) {
626     uint256 totalSupply = NUM_TOKENS * (uint256(10) ** decimals());
627     _mint(msg.sender, totalSupply);
628   }
629 
630   function blockimmo() public returns (address) {
631     return registryProxy.owner();
632   }
633 
634   function emitGenericProposal(string memory _generic) public isValid onlyOwner {
635     emit Generic(_generic);
636   }
637 
638   function setManagementCompany(string memory _managementCompany) public isValid onlyOwner {
639     managementCompany = _managementCompany;
640     emit ManagementCompanySet(managementCompany);
641   }
642 
643   function setMinTransfer(uint256 _amount) public {
644     minTransferAccepted[msg.sender] = _amount;
645     emit MinTransferSet(msg.sender, _amount);
646   }
647 
648   function transfer(address _to, uint256 _value) public isValid returns (bool) {
649     require(_value >= minTransferAccepted[_to], "_value must exceed _to's minTransferAccepted");
650     transferBookKeeping(msg.sender, _to);
651     return super.transfer(_to, _value);
652   }
653 
654   function transferFrom(address _from, address _to, uint256 _value) public isValid returns (bool) {
655     transferBookKeeping(_from, _to);
656     return super.transferFrom(_from, _to, _value);
657   }
658 
659   function untokenize() public isValid onlyOwner {
660     emit UntokenizeRequest();
661   }
662 
663   function transferBookKeeping(address _from, address _to) internal {
664     whitelistProxy.whitelist().checkRole(_to, "authorized");
665 
666     creditAccount(_from);  // required for dividends...
667     creditAccount(_to);
668 
669     lastTransferBlock[_from] = block.number;  // required for voting...
670     lastTransferBlock[_to] = block.number;
671   }
672 }