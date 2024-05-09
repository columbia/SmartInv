1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
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
26     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27     */
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
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 pragma solidity ^0.4.24;
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75     address private _owner;
76 
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     /**
80      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81      * account.
82      */
83     constructor () internal {
84         _owner = msg.sender;
85         emit OwnershipTransferred(address(0), _owner);
86     }
87 
88     /**
89      * @return the address of the owner.
90      */
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     /**
96      * @dev Throws if called by any account other than the owner.
97      */
98     modifier onlyOwner() {
99         require(isOwner());
100         _;
101     }
102 
103     /**
104      * @return true if `msg.sender` is the owner of the contract.
105      */
106     function isOwner() public view returns (bool) {
107         return msg.sender == _owner;
108     }
109 
110     /**
111      * @dev Allows the current owner to relinquish control of the contract.
112      * @notice Renouncing to ownership will leave the contract without an owner.
113      * It will not be possible to call the functions with the `onlyOwner`
114      * modifier anymore.
115      */
116     function renounceOwnership() public onlyOwner {
117         emit OwnershipTransferred(_owner, address(0));
118         _owner = address(0);
119     }
120 
121     /**
122      * @dev Allows the current owner to transfer control of the contract to a newOwner.
123      * @param newOwner The address to transfer ownership to.
124      */
125     function transferOwnership(address newOwner) public onlyOwner {
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers control of the contract to a newOwner.
131      * @param newOwner The address to transfer ownership to.
132      */
133     function _transferOwnership(address newOwner) internal {
134         require(newOwner != address(0));
135         emit OwnershipTransferred(_owner, newOwner);
136         _owner = newOwner;
137     }
138 }
139 
140 pragma solidity ^0.4.24;
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 interface IERC20 {
147     function totalSupply() external view returns (uint256);
148 
149     function balanceOf(address who) external view returns (uint256);
150 
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     function transfer(address to, uint256 value) external returns (bool);
154 
155     function approve(address spender, uint256 value) external returns (bool);
156 
157     function transferFrom(address from, address to, uint256 value) external returns (bool);
158 
159     event Transfer(address indexed from, address indexed to, uint256 value);
160 
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 pragma solidity ^0.4.24;
165 
166 /**
167  * @title ERC20Detailed token
168  * @dev The decimals are only for visualization purposes.
169  * All the operations are done using the smallest and indivisible token unit,
170  * just as on Ethereum all the operations are done in wei.
171  */
172 contract ERC20Detailed is IERC20 {
173     string private _name;
174     string private _symbol;
175     uint8 private _decimals;
176 
177     constructor (string name, string symbol, uint8 decimals) public {
178         _name = name;
179         _symbol = symbol;
180         _decimals = decimals;
181     }
182 
183     /**
184      * @return the name of the token.
185      */
186     function name() public view returns (string) {
187         return _name;
188     }
189 
190     /**
191      * @return the symbol of the token.
192      */
193     function symbol() public view returns (string) {
194         return _symbol;
195     }
196 
197     /**
198      * @return the number of decimals of the token.
199      */
200     function decimals() public view returns (uint8) {
201         return _decimals;
202     }
203 }
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
210  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  *
212  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
213  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
214  * compliant implementations may not do it.
215  */
216 contract ERC20 is IERC20 {
217     using SafeMath for uint256;
218 
219     mapping (address => uint256) private _balances;
220     mapping (address => mapping (address => uint256)) private _allowed;
221     uint256 private _totalSupply;
222 
223     /**
224     * @dev Total number of tokens in existence
225     */
226     function totalSupply() public view returns (uint256) {
227         return _totalSupply;
228     }
229 
230     /**
231     * @dev Gets the balance of the specified address.
232     * @param owner The address to query the balance of.
233     * @return An uint256 representing the amount owned by the passed address.
234     */
235     function balanceOf(address owner) public view returns (uint256) {
236         return _balances[owner];
237     }
238 
239     /**
240      * @dev Function to check the amount of tokens that an owner allowed to a spender.
241      * @param owner address The address which owns the funds.
242      * @param spender address The address which will spend the funds.
243      * @return A uint256 specifying the amount of tokens still available for the spender.
244      */
245     function allowance(address owner, address spender) public view returns (uint256) {
246         return _allowed[owner][spender];
247     }
248 
249     /**
250     * @dev Transfer token for a specified address
251     * @param to The address to transfer to.
252     * @param value The amount to be transferred.
253     */
254     function transfer(address to, uint256 value) public returns (bool) {
255         _transfer(msg.sender, to, value);
256         return true;
257     }
258 
259     /**
260      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
261      * Beware that changing an allowance with this method brings the risk that someone may use both the old
262      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
263      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
264      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265      * @param spender The address which will spend the funds.
266      * @param value The amount of tokens to be spent.
267      */
268     function approve(address spender, uint256 value) public returns (bool) {
269         require(spender != address(0));
270 
271         _allowed[msg.sender][spender] = value;
272         emit Approval(msg.sender, spender, value);
273         return true;
274     }
275 
276     /**
277      * @dev Transfer tokens from one address to another.
278      * Note that while this function emits an Approval event, this is not required as per the specification,
279      * and other compliant implementations may not emit the event.
280      * @param from address The address which you want to send tokens from
281      * @param to address The address which you want to transfer to
282      * @param value uint256 the amount of tokens to be transferred
283      */
284     function transferFrom(address from, address to, uint256 value) public returns (bool) {
285         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
286         _transfer(from, to, value);
287         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
288         return true;
289     }
290 
291     /**
292      * @dev Increase the amount of tokens that an owner allowed to a spender.
293      * approve should be called when allowed_[_spender] == 0. To increment
294      * allowed value is better to use this function to avoid 2 calls (and wait until
295      * the first transaction is mined)
296      * From MonolithDAO Token.sol
297      * Emits an Approval event.
298      * @param spender The address which will spend the funds.
299      * @param addedValue The amount of tokens to increase the allowance by.
300      */
301     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
302         require(spender != address(0));
303 
304         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
305         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
306         return true;
307     }
308 
309     /**
310      * @dev Decrease the amount of tokens that an owner allowed to a spender.
311      * approve should be called when allowed_[_spender] == 0. To decrement
312      * allowed value is better to use this function to avoid 2 calls (and wait until
313      * the first transaction is mined)
314      * From MonolithDAO Token.sol
315      * Emits an Approval event.
316      * @param spender The address which will spend the funds.
317      * @param subtractedValue The amount of tokens to decrease the allowance by.
318      */
319     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
320         require(spender != address(0));
321 
322         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
323         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
324         return true;
325     }
326 
327     /**
328     * @dev Transfer token for a specified addresses
329     * @param from The address to transfer from.
330     * @param to The address to transfer to.
331     * @param value The amount to be transferred.
332     */
333     function _transfer(address from, address to, uint256 value) internal {
334         require(to != address(0));
335 
336         _balances[from] = _balances[from].sub(value);
337         _balances[to] = _balances[to].add(value);
338         emit Transfer(from, to, value);
339     }
340 
341     /**
342      * @dev Internal function that mints an amount of the token and assigns it to
343      * an account. This encapsulates the modification of balances such that the
344      * proper events are emitted.
345      * @param account The account that will receive the created tokens.
346      * @param value The amount that will be created.
347      */
348     function _mint(address account, uint256 value) internal {
349         require(account != address(0));
350 
351         _totalSupply = _totalSupply.add(value);
352         _balances[account] = _balances[account].add(value);
353         emit Transfer(address(0), account, value);
354     }
355 
356     /**
357      * @dev Internal function that burns an amount of the token of a given
358      * account.
359      * @param account The account whose tokens will be burnt.
360      * @param value The amount that will be burnt.
361      */
362     function _burn(address account, uint256 value) internal {
363         require(account != address(0));
364 
365         _totalSupply = _totalSupply.sub(value);
366         _balances[account] = _balances[account].sub(value);
367         emit Transfer(account, address(0), value);
368     }
369 }
370 
371 contract BonusToken is ERC20, ERC20Detailed, Ownable {
372 
373     address public gameAddress;
374     address public investTokenAddress;
375     uint public maxLotteryParticipants;
376 
377     mapping (address => uint256) public ethLotteryBalances;
378     address[] public ethLotteryParticipants;
379     uint256 public ethLotteryBank;
380     bool public isEthLottery;
381 
382     mapping (address => uint256) public tokensLotteryBalances;
383     address[] public tokensLotteryParticipants;
384     uint256 public tokensLotteryBank;
385     bool public isTokensLottery;
386 
387     modifier onlyGame() {
388         require(msg.sender == gameAddress);
389         _;
390     }
391 
392     modifier tokenIsAvailable {
393         require(investTokenAddress != address(0));
394         _;
395     }
396 
397     constructor (address startGameAddress) public ERC20Detailed("Bet Token", "BET", 18) {
398         setGameAddress(startGameAddress);
399     }
400 
401     function setGameAddress(address newGameAddress) public onlyOwner {
402         require(newGameAddress != address(0));
403         gameAddress = newGameAddress;
404     }
405 
406     function buyTokens(address buyer, uint256 tokensAmount) public onlyGame {
407         _mint(buyer, tokensAmount * 10**18);
408     }
409 
410     function startEthLottery() public onlyGame {
411         isEthLottery = true;
412     }
413 
414     function startTokensLottery() public onlyGame tokenIsAvailable {
415         isTokensLottery = true;
416     }
417 
418     function restartEthLottery() public onlyGame {
419         for (uint i = 0; i < ethLotteryParticipants.length; i++) {
420             ethLotteryBalances[ethLotteryParticipants[i]] = 0;
421         }
422         ethLotteryParticipants = new address[](0);
423         ethLotteryBank = 0;
424         isEthLottery = false;
425     }
426 
427     function restartTokensLottery() public onlyGame tokenIsAvailable {
428         for (uint i = 0; i < tokensLotteryParticipants.length; i++) {
429             tokensLotteryBalances[tokensLotteryParticipants[i]] = 0;
430         }
431         tokensLotteryParticipants = new address[](0);
432         tokensLotteryBank = 0;
433         isTokensLottery = false;
434     }
435 
436     function updateEthLotteryBank(uint256 value) public onlyGame {
437         ethLotteryBank = ethLotteryBank.sub(value);
438     }
439 
440     function updateTokensLotteryBank(uint256 value) public onlyGame {
441         tokensLotteryBank = tokensLotteryBank.sub(value);
442     }
443 
444     function swapTokens(address account, uint256 tokensToBurnAmount) public {
445         require(msg.sender == investTokenAddress);
446         _burn(account, tokensToBurnAmount);
447     }
448 
449     function sendToEthLottery(uint256 value) public {
450         require(!isEthLottery);
451         require(ethLotteryParticipants.length < maxLotteryParticipants);
452         address account = msg.sender;
453         _burn(account, value);
454         if (ethLotteryBalances[account] == 0) {
455             ethLotteryParticipants.push(account);
456         }
457         ethLotteryBalances[account] = ethLotteryBalances[account].add(value);
458         ethLotteryBank = ethLotteryBank.add(value);
459     }
460 
461     function sendToTokensLottery(uint256 value) public tokenIsAvailable {
462         require(!isTokensLottery);
463         require(tokensLotteryParticipants.length < maxLotteryParticipants);
464         address account = msg.sender;
465         _burn(account, value);
466         if (tokensLotteryBalances[account] == 0) {
467             tokensLotteryParticipants.push(account);
468         }
469         tokensLotteryBalances[account] = tokensLotteryBalances[account].add(value);
470         tokensLotteryBank = tokensLotteryBank.add(value);
471     }
472 
473     function ethLotteryParticipants() public view returns(address[]) {
474         return ethLotteryParticipants;
475     }
476 
477     function tokensLotteryParticipants() public view returns(address[]) {
478         return tokensLotteryParticipants;
479     }
480 
481     function setInvestTokenAddress(address newInvestTokenAddress) external onlyOwner {
482         require(newInvestTokenAddress != address(0));
483         investTokenAddress = newInvestTokenAddress;
484     }
485 
486     function setMaxLotteryParticipants(uint256 participants) external onlyOwner {
487         maxLotteryParticipants = participants;
488     }
489 }
490 
491 /**
492  * @title ERC20 interface
493  * @dev see https://github.com/ethereum/EIPs/issues/20
494  */
495 interface modIERC20 {
496     function totalSupply() external view returns (uint256);
497 
498     function balanceOf(address who) external view returns (uint256);
499 
500     function transfer(address to, uint256 value, uint256 index) external returns (bool);
501 
502     event Transfer(address indexed from, address indexed to, uint256 value);
503 }
504 
505 /**
506  * @title ERC20Detailed token
507  * @dev The decimals are only for visualization purposes.
508  * All the operations are done using the smallest and indivisible token unit,
509  * just as on Ethereum all the operations are done in wei.
510  */
511 contract modERC20Detailed is modIERC20 {
512     string private _name;
513     string private _symbol;
514     uint8 private _decimals;
515 
516     constructor (string name, string symbol, uint8 decimals) public {
517         _name = name;
518         _symbol = symbol;
519         _decimals = decimals;
520     }
521 
522     /**
523      * @return the name of the token.
524      */
525     function name() public view returns (string) {
526         return _name;
527     }
528 
529     /**
530      * @return the symbol of the token.
531      */
532     function symbol() public view returns (string) {
533         return _symbol;
534     }
535 
536     /**
537      * @return the number of decimals of the token.
538      */
539     function decimals() public view returns (uint8) {
540         return _decimals;
541     }
542 }
543 
544 contract modERC20 is modIERC20 {
545     using SafeMath for uint256;
546 
547     uint256 constant public MIN_HOLDERS_BALANCE = 20 ether;
548 
549     address public gameAddress;
550 
551     mapping (address => uint256) private _balances;
552     uint256 private _totalSupply;
553 
554     address[] internal holders;
555     mapping(address => bool) internal isUser;
556 
557     function getHolders() public view returns (address[]) {
558         return holders;
559     }
560 
561     /**
562     * @dev Total number of tokens in existence
563     */
564     function totalSupply() public view returns (uint256) {
565         return _totalSupply;
566     }
567 
568     /**
569     * @dev Gets the balance of the specified address.
570     * @param owner The address to query the balance of.
571     * @return An uint256 representing the amount owned by the passed address.
572     */
573     function balanceOf(address owner) public view returns (uint256) {
574         return _balances[owner];
575     }
576 
577     /**
578     * @dev Transfer token for a specified addresses
579     * @param from The address to transfer from.
580     * @param to The address to transfer to.
581     * @param value The amount to be transferred.
582     */
583     function _transfer(address from, address to, uint256 value) internal {
584         require(to != address(0));
585 
586         if (to != gameAddress && from != gameAddress) {
587             uint256 transferFee = value.div(100);
588             _burn(from, transferFee);
589             value = value.sub(transferFee);
590         }
591         _balances[from] = _balances[from].sub(value);
592         if (to != gameAddress && _balances[to] < MIN_HOLDERS_BALANCE && _balances[to].add(value) >= MIN_HOLDERS_BALANCE) {
593             holders.push(to);
594         }
595         _balances[to] = _balances[to].add(value);
596         emit Transfer(from, to, value);
597     }
598 
599     /**
600      * @dev Internal function that mints an amount of the token and assigns it to
601      * an account. This encapsulates the modification of balances such that the
602      * proper events are emitted.
603      * @param account The account that will receive the created tokens.
604      * @param value The amount that will be created.
605      */
606     function _mint(address account, uint256 value) internal {
607         require(account != address(0));
608 
609         _totalSupply = _totalSupply.add(value);
610         _balances[account] = _balances[account].add(value);
611         emit Transfer(address(0), account, value);
612     }
613 
614     /**
615      * @dev Internal function that burns an amount of the token of a given
616      * account.
617      * @param account The account whose tokens will be burnt.
618      * @param value The amount that will be burnt.
619      */
620     function _burn(address account, uint256 value) internal {
621         require(account != address(0));
622 
623         _totalSupply = _totalSupply.sub(value);
624         _balances[account] = _balances[account].sub(value);
625         emit Transfer(account, address(0), value);
626     }
627 }
628 
629 contract InvestToken is modERC20, modERC20Detailed, Ownable {
630 
631     uint8 constant public REFERRER_PERCENT = 3;
632     uint8 constant public CASHBACK_PERCENT = 2;
633     uint8 constant public HOLDERS_BUY_PERCENT_WITH_REFERRER = 7;
634     uint8 constant public HOLDERS_BUY_PERCENT_WITH_REFERRER_AND_CASHBACK = 5;
635     uint8 constant public HOLDERS_BUY_PERCENT = 10;
636     uint8 constant public HOLDERS_SELL_PERCENT = 5;
637     uint8 constant public TOKENS_DIVIDER = 10;
638     uint256 constant public PRICE_INTERVAL = 10000000000;
639 
640     uint256 public swapTokensLimit;
641     uint256 public investDividends;
642     uint256 public casinoDividends;
643     mapping(address => uint256) public ethStorage;
644     mapping(address => address) public referrers;
645     mapping(address => uint256) public investSize24h;
646     mapping(address => uint256) public lastInvestTime;
647     BonusToken public bonusToken;
648 
649     uint256 private holdersIndex;
650     uint256 private totalInvestDividends;
651     uint256 private totalCasinoDividends;
652     uint256 private priceCoeff = 105e9;
653     uint256 private constant a = 5e9;
654 
655     event Buy(address indexed buyer, uint256 weiAmount, uint256 tokensAmount, uint256 timestamp);
656     event Sell(address indexed seller, uint256 weiAmount, uint256 tokensAmount, uint256 timestamp);
657     event Reinvest(address indexed investor, uint256 weiAmount, uint256 tokensAmount, uint256 timestamp);
658     event Withdraw(address indexed investor, uint256 weiAmount, uint256 timestamp);
659     event ReferalsIncome(address indexed recipient, uint256 amount, uint256 timestamp);
660     event InvestIncome(address indexed recipient, uint256 amount, uint256 timestamp);
661     event CasinoIncome(address indexed recipient, uint256 amount, uint256 timestamp);
662 
663     constructor (address _bonusToken) public modERC20Detailed("Get Token", "GET", 18) {
664         require(_bonusToken != address (0));
665         bonusToken = BonusToken(_bonusToken);
666         swapTokensLimit = 10000;
667         swapTokensLimit = swapTokensLimit.mul(10 ** uint256(decimals()));
668     }
669 
670     modifier onlyGame() {
671         require(msg.sender == gameAddress, 'The sender must be a game contract.');
672         _;
673     }
674 
675     function () public payable {
676         if (msg.sender != gameAddress) {
677             address referrer;
678             if (msg.data.length == 20) {
679                 referrer = bytesToAddress(bytes(msg.data));
680             }
681             buyTokens(referrer);
682         }
683     }
684 
685     function buyTokens(address referrer) public payable {
686         uint256 weiAmount = msg.value;
687         address buyer = msg.sender;
688         uint256 tokensAmount;
689         (weiAmount, tokensAmount) = mint(buyer, weiAmount);
690         uint256 correctWeiAmount = msg.value.sub(weiAmount);
691         checkInvestTimeAndSize(buyer, correctWeiAmount);
692         if (!isUser[buyer]) {
693             if (referrer != address(0) && referrer != buyer) {
694                 referrers[buyer] = referrer;
695             }
696             buyFee(buyer, correctWeiAmount, true);
697             isUser[buyer] = true;
698         } else {
699             buyFee(buyer, correctWeiAmount, false);
700         }
701         if (weiAmount > 0) {
702             buyer.transfer(weiAmount);
703         }
704         emit Buy(buyer, correctWeiAmount, tokensAmount, now);
705     }
706 
707     function sellTokens(uint256 tokensAmount, uint index) public {
708         address seller = msg.sender;
709         tokensAmount = tokensAmount.div(decimals()).mul(decimals());
710         burn(seller, tokensAmount, index);
711         uint256 weiAmount = tokensToEthereum(tokensAmount.div(uint256(10) ** decimals()));
712         weiAmount = sellFee(weiAmount);
713         seller.transfer(weiAmount);
714         emit Sell(seller, weiAmount, tokensAmount, now);
715     }
716 
717     function swapTokens(uint256 tokensAmountToBurn) public {
718         uint256 tokensAmountToMint = tokensAmountToBurn.div(TOKENS_DIVIDER);
719         require(tokensAmountToMint <= swapTokensLimit.sub(tokensAmountToMint));
720         require(bonusToken.balanceOf(msg.sender) >= tokensAmountToBurn, 'Not enough bonus tokens.');
721         bonusToken.swapTokens(msg.sender, tokensAmountToBurn);
722         swapTokensLimit = swapTokensLimit.sub(tokensAmountToMint);
723         priceCoeff = priceCoeff.add(tokensAmountToMint.mul(1e10));
724         correctBalanceByMint(msg.sender, tokensAmountToMint);
725         _mint(msg.sender, tokensAmountToMint);
726     }
727 
728     function reinvest(uint256 weiAmount) public {
729         ethStorage[msg.sender] = ethStorage[msg.sender].sub(weiAmount);
730         uint256 tokensAmount;
731         (weiAmount, tokensAmount) = mint(msg.sender, weiAmount);
732         if (weiAmount > 0) {
733             ethStorage[msg.sender] = ethStorage[msg.sender].add(weiAmount);
734         }
735         emit Reinvest(msg.sender, weiAmount, tokensAmount, now);
736     }
737 
738     function withdraw(uint256 weiAmount) public {
739         require(weiAmount > 0);
740         ethStorage[msg.sender] = ethStorage[msg.sender].sub(weiAmount);
741         msg.sender.transfer(weiAmount);
742         emit Withdraw(msg.sender, weiAmount, now);
743     }
744 
745     function transfer(address to, uint256 value, uint256 index) public returns (bool) {
746         if (msg.sender != gameAddress) {
747             correctBalanceByBurn(msg.sender, value, index);
748         }
749         _transfer(msg.sender, to, value);
750         return true;
751     }
752 
753     function sendDividendsToHolders(uint holdersIterations) public onlyOwner {
754         if (holdersIndex == 0) {
755             totalInvestDividends = investDividends;
756             totalCasinoDividends = casinoDividends;
757         }
758         uint holdersIterationsNumber;
759         if (holders.length.sub(holdersIndex) < holdersIterations) {
760             holdersIterationsNumber = holders.length.sub(holdersIndex);
761         } else {
762             holdersIterationsNumber = holdersIterations;
763         }
764         uint256 holdersBalance = 0;
765         uint256 weiAmount = 0;
766         for (uint256 i = 0; i < holdersIterationsNumber; i++) {
767             holdersBalance = balanceOf(holders[holdersIndex]);
768             if (holdersBalance >= MIN_HOLDERS_BALANCE) {
769                 if (totalInvestDividends > 0) {
770                     weiAmount = holdersBalance.mul(totalInvestDividends).div(totalSupply());
771                     investDividends = investDividends.sub(weiAmount);
772                     emit InvestIncome(holders[holdersIndex], weiAmount, now);
773                     ethStorage[holders[holdersIndex]] = ethStorage[holders[holdersIndex]].add(weiAmount);
774                 }
775                 if (totalCasinoDividends > 0) {
776                     weiAmount = holdersBalance.mul(totalCasinoDividends).div(totalSupply());
777                     casinoDividends = casinoDividends.sub(weiAmount);
778                     emit CasinoIncome(holders[holdersIndex], weiAmount, now);
779                     ethStorage[holders[holdersIndex]] = ethStorage[holders[holdersIndex]].add(weiAmount);
780                 }
781             }
782             holdersIndex++;
783         }
784         if (holdersIndex == holders.length) {
785             holdersIndex = 0;
786         }
787     }
788 
789     function setGameAddress(address newGameAddress) public onlyOwner {
790         gameAddress = newGameAddress;
791     }
792 
793     function sendToGame(address player, uint256 tokensAmount, uint256 index) public onlyGame returns(bool) {
794         correctBalanceByBurn(player, tokensAmount, index);
795         _transfer(player, gameAddress, tokensAmount);
796         return true;
797     }
798 
799     function gameDividends(uint256 weiAmount) public onlyGame {
800         casinoDividends = casinoDividends.add(weiAmount);
801     }
802 
803     function price() public view returns(uint256) {
804         return priceCoeff.add(a);
805     }
806 
807     function mint(address account, uint256 weiAmount) private returns(uint256, uint256) {
808         (uint256 tokensToMint, uint256 backPayWeiAmount) = ethereumToTokens(weiAmount);
809         correctBalanceByMint(account, tokensToMint);
810         _mint(account, tokensToMint);
811         return (backPayWeiAmount, tokensToMint);
812     }
813 
814     function burn(address account, uint256 tokensAmount, uint256 index) private returns(uint256, uint256) {
815         correctBalanceByBurn(account, tokensAmount, index);
816         _burn(account, tokensAmount);
817     }
818 
819     function checkInvestTimeAndSize(address account, uint256 weiAmount) private {
820         if (now - lastInvestTime[account] > 24 hours) {
821             investSize24h[account] = 0;
822         }
823         require(investSize24h[account].add(weiAmount) <= 5 ether, 'Investment limit exceeded for 24 hours.');
824         investSize24h[account] = investSize24h[account].add(weiAmount);
825         lastInvestTime[account] = now;
826     }
827 
828     function buyFee(address sender, uint256 weiAmount, bool isFirstInvest) private {
829         address referrer = referrers[sender];
830         uint256 holdersWeiAmount;
831         if (referrer != address(0)) {
832             uint256 referrerWeiAmount = weiAmount.mul(REFERRER_PERCENT).div(100);
833             emit ReferalsIncome(referrer, referrerWeiAmount, now);
834             ethStorage[referrer] = ethStorage[referrer].add(referrerWeiAmount);
835             if (isFirstInvest) {
836                 uint256 cashbackWeiAmount = weiAmount.mul(CASHBACK_PERCENT).div(100);
837                 emit ReferalsIncome(sender, cashbackWeiAmount, now);
838                 ethStorage[sender] = ethStorage[sender].add(cashbackWeiAmount);
839                 holdersWeiAmount = weiAmount.mul(HOLDERS_BUY_PERCENT_WITH_REFERRER_AND_CASHBACK).div(100);
840             } else {
841                 holdersWeiAmount = weiAmount.mul(HOLDERS_BUY_PERCENT_WITH_REFERRER).div(100);
842             }
843         } else {
844             holdersWeiAmount = weiAmount.mul(HOLDERS_BUY_PERCENT).div(100);
845         }
846         addDividends(holdersWeiAmount);
847     }
848 
849     function sellFee(uint256 weiAmount) private returns(uint256) {
850         uint256 holdersWeiAmount = weiAmount.mul(HOLDERS_SELL_PERCENT).div(100);
851         addDividends(holdersWeiAmount);
852         weiAmount = weiAmount.sub(holdersWeiAmount);
853         return weiAmount;
854     }
855 
856     function addDividends(uint256 weiAmount) private {
857         investDividends = investDividends.add(weiAmount);
858     }
859 
860     function correctBalanceByMint(address account, uint256 value) private {
861         if (balanceOf(account) < MIN_HOLDERS_BALANCE && balanceOf(account).add(value) >= MIN_HOLDERS_BALANCE) {
862             holders.push(msg.sender);
863         }
864     }
865 
866     function correctBalanceByBurn(address account, uint256 value, uint256 index) private {
867         if (balanceOf(account) >= MIN_HOLDERS_BALANCE && balanceOf(account).sub(value) < MIN_HOLDERS_BALANCE) {
868             require(holders[index] == account);
869             deleteTokensHolder(index);
870         }
871     }
872 
873     function ethereumToTokens(uint256 weiAmount) private returns(uint256, uint256) {
874         uint256 b = priceCoeff;
875         uint256 c = weiAmount;
876         uint256 D = (b ** 2).add(a.mul(4).mul(c));
877         uint256 tokensAmount = (sqrt(D).sub(b)).div((a).mul(2));
878         require(tokensAmount > 0);
879         uint256 backPayWeiAmount = weiAmount.sub(a.mul(tokensAmount ** 2).add(priceCoeff.mul(tokensAmount)));
880         priceCoeff = priceCoeff.add(tokensAmount.mul(1e10));
881         tokensAmount = tokensAmount.mul(10 ** uint256(decimals()));
882         return (tokensAmount, backPayWeiAmount);
883     }
884 
885     function tokensToEthereum(uint256 tokensAmount) private returns(uint256) {
886         require(tokensAmount > 0);
887         uint256 weiAmount = priceCoeff.mul(tokensAmount).sub((tokensAmount ** 2).mul(5).mul(1e9));
888         priceCoeff = priceCoeff.sub(tokensAmount.mul(1e10));
889         return weiAmount;
890     }
891 
892     function bytesToAddress(bytes source) private pure returns(address parsedAddress)
893     {
894         assembly {
895             parsedAddress := mload(add(source,0x14))
896         }
897         return parsedAddress;
898     }
899 
900     function sqrt(uint256 x) private pure returns (uint256 y) {
901         uint256 z = (x + 1) / 2;
902         y = x;
903         while (z < y) {
904             y = z;
905             z = (x / z + z) / 2;
906         }
907     }
908 
909     function deleteTokensHolder(uint index) private {
910         holders[index] = holders[holders.length - 1];
911         delete holders[holders.length - 1];
912         holders.length--;
913     }
914 }