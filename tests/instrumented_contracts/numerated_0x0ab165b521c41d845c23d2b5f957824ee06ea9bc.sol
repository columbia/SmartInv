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
492  * @title Standard ERC20 token
493  *
494  * @dev Implementation of the basic standard token.
495  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
496  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
497  *
498  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
499  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
500  * compliant implementations may not do it.
501  */
502 contract modERC20 is IERC20 {
503     using SafeMath for uint256;
504 
505     uint256 constant public MIN_HOLDERS_BALANCE = 20 ether;
506 
507     mapping (address => uint256) private _balances;
508     mapping (address => mapping (address => uint256)) private _allowed;
509     uint256 private _totalSupply;
510 
511     address public gameAddress;
512 
513     address[] internal holders;
514     mapping(address => bool) internal isUser;
515 
516     function getHolders() public view returns (address[]) {
517         return holders;
518     }
519 
520     /**
521     * @dev Total number of tokens in existence
522     */
523     function totalSupply() public view returns (uint256) {
524         return _totalSupply;
525     }
526 
527     /**
528     * @dev Gets the balance of the specified address.
529     * @param owner The address to query the balance of.
530     * @return An uint256 representing the amount owned by the passed address.
531     */
532     function balanceOf(address owner) public view returns (uint256) {
533         return _balances[owner];
534     }
535 
536     /**
537      * @dev Function to check the amount of tokens that an owner allowed to a spender.
538      * @param owner address The address which owns the funds.
539      * @param spender address The address which will spend the funds.
540      * @return A uint256 specifying the amount of tokens still available for the spender.
541      */
542     function allowance(address owner, address spender) public view returns (uint256) {
543         return _allowed[owner][spender];
544     }
545 
546     /**
547     * @dev Transfer token for a specified address
548     * @param to The address to transfer to.
549     * @param value The amount to be transferred.
550     */
551     function transfer(address to, uint256 value) public returns (bool) {
552         _transfer(msg.sender, to, value);
553         return true;
554     }
555 
556     /**
557      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
558      * Beware that changing an allowance with this method brings the risk that someone may use both the old
559      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
560      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
561      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
562      * @param spender The address which will spend the funds.
563      * @param value The amount of tokens to be spent.
564      */
565     function approve(address spender, uint256 value) public returns (bool) {
566         require(spender != address(0));
567 
568         _allowed[msg.sender][spender] = value;
569         emit Approval(msg.sender, spender, value);
570         return true;
571     }
572 
573     /**
574      * @dev Transfer tokens from one address to another.
575      * Note that while this function emits an Approval event, this is not required as per the specification,
576      * and other compliant implementations may not emit the event.
577      * @param from address The address which you want to send tokens from
578      * @param to address The address which you want to transfer to
579      * @param value uint256 the amount of tokens to be transferred
580      */
581     function transferFrom(address from, address to, uint256 value) public returns (bool) {
582         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
583         _transfer(from, to, value);
584         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
585         return true;
586     }
587 
588     /**
589      * @dev Increase the amount of tokens that an owner allowed to a spender.
590      * approve should be called when allowed_[_spender] == 0. To increment
591      * allowed value is better to use this function to avoid 2 calls (and wait until
592      * the first transaction is mined)
593      * From MonolithDAO Token.sol
594      * Emits an Approval event.
595      * @param spender The address which will spend the funds.
596      * @param addedValue The amount of tokens to increase the allowance by.
597      */
598     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
599         require(spender != address(0));
600 
601         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
602         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
603         return true;
604     }
605 
606     /**
607      * @dev Decrease the amount of tokens that an owner allowed to a spender.
608      * approve should be called when allowed_[_spender] == 0. To decrement
609      * allowed value is better to use this function to avoid 2 calls (and wait until
610      * the first transaction is mined)
611      * From MonolithDAO Token.sol
612      * Emits an Approval event.
613      * @param spender The address which will spend the funds.
614      * @param subtractedValue The amount of tokens to decrease the allowance by.
615      */
616     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
617         require(spender != address(0));
618 
619         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
620         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
621         return true;
622     }
623 
624     /**
625     * @dev Transfer token for a specified addresses
626     * @param from The address to transfer from.
627     * @param to The address to transfer to.
628     * @param value The amount to be transferred.
629     */
630     function _transfer(address from, address to, uint256 value) internal {
631         require(to != address(0));
632 
633         if (to != gameAddress && from != gameAddress) {
634             uint256 transferFee = value.div(100);
635             _burn(from, transferFee);
636             value = value.sub(transferFee);
637         }
638         if (to != gameAddress && _balances[to] == 0 && value >= MIN_HOLDERS_BALANCE) {
639             holders.push(to);
640         }
641         _balances[from] = _balances[from].sub(value);
642         _balances[to] = _balances[to].add(value);
643         emit Transfer(from, to, value);
644     }
645 
646     /**
647      * @dev Internal function that mints an amount of the token and assigns it to
648      * an account. This encapsulates the modification of balances such that the
649      * proper events are emitted.
650      * @param account The account that will receive the created tokens.
651      * @param value The amount that will be created.
652      */
653     function _mint(address account, uint256 value) internal {
654         require(account != address(0));
655 
656         _totalSupply = _totalSupply.add(value);
657         _balances[account] = _balances[account].add(value);
658         emit Transfer(address(0), account, value);
659     }
660 
661     /**
662      * @dev Internal function that burns an amount of the token of a given
663      * account.
664      * @param account The account whose tokens will be burnt.
665      * @param value The amount that will be burnt.
666      */
667     function _burn(address account, uint256 value) internal {
668         require(account != address(0));
669 
670         _totalSupply = _totalSupply.sub(value);
671         _balances[account] = _balances[account].sub(value);
672         emit Transfer(account, address(0), value);
673     }
674 }
675 
676 contract InvestToken is modERC20, ERC20Detailed, Ownable {
677 
678     uint8 constant public REFERRER_PERCENT = 3;
679     uint8 constant public CASHBACK_PERCENT = 2;
680     uint8 constant public HOLDERS_BUY_PERCENT_WITH_REFERRER = 7;
681     uint8 constant public HOLDERS_BUY_PERCENT_WITH_REFERRER_AND_CASHBACK = 5;
682     uint8 constant public HOLDERS_BUY_PERCENT = 10;
683     uint8 constant public HOLDERS_SELL_PERCENT = 5;
684     uint8 constant public TOKENS_DIVIDER = 10;
685     uint256 constant public PRICE_INTERVAL = 10000000000;
686 
687     uint256 public swapTokensLimit;
688     uint256 public investDividends;
689     uint256 public casinoDividends;
690     mapping(address => uint256) public ethStorage;
691     mapping(address => address) public referrers;
692     mapping(address => uint256) public investSize24h;
693     mapping(address => uint256) public lastInvestTime;
694     BonusToken public bonusToken;
695 
696     uint256 private holdersIndex;
697     uint256 private totalInvestDividends;
698     uint256 private totalCasinoDividends;
699     uint256 private priceCoeff = 105e9;
700     uint256 private constant a = 5e9;
701 
702     event Buy(address indexed buyer, uint256 weiAmount, uint256 tokensAmount, uint256 timestamp);
703     event Sell(address indexed seller, uint256 weiAmount, uint256 tokensAmount, uint256 timestamp);
704     event Reinvest(address indexed investor, uint256 weiAmount, uint256 tokensAmount, uint256 timestamp);
705     event Withdraw(address indexed investor, uint256 weiAmount, uint256 timestamp);
706     event ReferalsIncome(address indexed recipient, uint256 amount, uint256 timestamp);
707     event InvestIncome(address indexed recipient, uint256 amount, uint256 timestamp);
708     event CasinoIncome(address indexed recipient, uint256 amount, uint256 timestamp);
709 
710     constructor (address _bonusToken) public ERC20Detailed("Get Token", "GET", 18) {
711         require(_bonusToken != address (0));
712         bonusToken = BonusToken(_bonusToken);
713         swapTokensLimit = 10000;
714         swapTokensLimit = swapTokensLimit.mul(10 ** uint256(decimals()));
715     }
716 
717     modifier onlyGame() {
718         require(msg.sender == gameAddress, 'The sender must be a game contract.');
719         _;
720     }
721 
722     function () public payable {
723         if (msg.sender != gameAddress) {
724             address referrer;
725             if (msg.data.length == 20) {
726                 referrer = bytesToAddress(bytes(msg.data));
727             }
728             buyTokens(referrer);
729         }
730     }
731 
732     function buyTokens(address referrer) public payable {
733         uint256 weiAmount = msg.value;
734         address buyer = msg.sender;
735         uint256 tokensAmount;
736         (weiAmount, tokensAmount) = mint(buyer, weiAmount);
737         uint256 correctWeiAmount = msg.value.sub(weiAmount);
738         checkInvestTimeAndSize(buyer, correctWeiAmount);
739         if (!isUser[buyer]) {
740             if (referrer != address(0) && referrer != buyer) {
741                 referrers[buyer] = referrer;
742             }
743             buyFee(buyer, correctWeiAmount, true);
744             isUser[buyer] = true;
745         } else {
746             buyFee(buyer, correctWeiAmount, false);
747         }
748         if (weiAmount > 0) {
749             buyer.transfer(weiAmount);
750         }
751         if (balanceOf(buyer) >= MIN_HOLDERS_BALANCE) {
752             holders.push(buyer);
753         }
754         emit Buy(buyer, correctWeiAmount, tokensAmount, now);
755     }
756 
757     function sellTokens(uint256 tokensAmount) public {
758         address seller = msg.sender;
759         _burn(seller, tokensAmount.mul(10 ** uint256(decimals())));
760         uint256 weiAmount = tokensToEthereum(tokensAmount);
761         weiAmount = sellFee(weiAmount);
762         seller.transfer(weiAmount);
763         emit Sell(seller, weiAmount, tokensAmount, now);
764     }
765 
766     function swapTokens(uint256 tokensAmountToBurn) public {
767         uint256 tokensAmountToMint = tokensAmountToBurn.div(TOKENS_DIVIDER);
768         require(tokensAmountToMint <= swapTokensLimit.sub(tokensAmountToMint));
769         require(bonusToken.balanceOf(msg.sender) >= tokensAmountToBurn, 'Not enough bonus tokens.');
770         bonusToken.swapTokens(msg.sender, tokensAmountToBurn);
771         swapTokensLimit = swapTokensLimit.sub(tokensAmountToMint);
772         priceCoeff = priceCoeff.add(tokensAmountToMint.mul(1e10));
773         _mint(msg.sender, tokensAmountToMint);
774     }
775 
776     function reinvest(uint256 weiAmount) public {
777         ethStorage[msg.sender] = ethStorage[msg.sender].sub(weiAmount);
778         uint256 tokensAmount;
779         (weiAmount, tokensAmount) = mint(msg.sender, weiAmount);
780         if (weiAmount > 0) {
781             ethStorage[msg.sender] = ethStorage[msg.sender].add(weiAmount);
782         }
783         emit Reinvest(msg.sender, weiAmount, tokensAmount, now);
784     }
785 
786     function withdraw(uint256 weiAmount) public {
787         require(weiAmount > 0);
788         ethStorage[msg.sender] = ethStorage[msg.sender].sub(weiAmount);
789         msg.sender.transfer(weiAmount);
790         emit Withdraw(msg.sender, weiAmount, now);
791     }
792 
793     function sendDividendsToHolders(uint holdersIterations) public onlyOwner {
794         if (holdersIndex == 0) {
795             totalInvestDividends = investDividends;
796             totalCasinoDividends = casinoDividends;
797         }
798         uint holdersIterationsNumber;
799         if (holders.length.sub(holdersIndex) < holdersIterations) {
800             holdersIterationsNumber = holders.length.sub(holdersIndex);
801         } else {
802             holdersIterationsNumber = holdersIterations;
803         }
804         uint256 holdersBalance = 0;
805         uint256 weiAmount = 0;
806         for (uint256 i = 0; i < holdersIterationsNumber; i++) {
807             holdersBalance = balanceOf(holders[holdersIndex]);
808             if (holdersBalance >= MIN_HOLDERS_BALANCE) {
809                 if (totalInvestDividends > 0) {
810                     weiAmount = holdersBalance.mul(totalInvestDividends).div(totalSupply());
811                     investDividends = investDividends.sub(weiAmount);
812                     emit InvestIncome(holders[holdersIndex], weiAmount, now);
813                     ethStorage[holders[holdersIndex]] = ethStorage[holders[holdersIndex]].add(weiAmount);
814                 }
815                 if (totalCasinoDividends > 0) {
816                     weiAmount = holdersBalance.mul(totalCasinoDividends).div(totalSupply());
817                     casinoDividends = casinoDividends.sub(weiAmount);
818                     emit CasinoIncome(holders[holdersIndex], weiAmount, now);
819                     ethStorage[holders[holdersIndex]] = ethStorage[holders[holdersIndex]].add(weiAmount);
820                 }
821             } else {
822                 deleteTokensHolder(holdersIndex);
823             }
824             holdersIndex++;
825         }
826         if (holdersIndex == holders.length) {
827             holdersIndex = 0;
828         }
829     }
830 
831     function setGameAddress(address newGameAddress) public onlyOwner {
832         gameAddress = newGameAddress;
833     }
834 
835     function sendToGame(address player, uint256 tokensAmount) public onlyGame returns(bool) {
836         _transfer(player, gameAddress, tokensAmount);
837         return true;
838     }
839 
840     function gameDividends(uint256 weiAmount) public onlyGame {
841         casinoDividends = casinoDividends.add(weiAmount);
842     }
843 
844     function price() public view returns(uint256) {
845         return priceCoeff.add(a);
846     }
847 
848     function mint(address account, uint256 weiAmount) private returns(uint256, uint256) {
849         (uint256 tokensToMint, uint256 backPayWeiAmount) = ethereumToTokens(weiAmount);
850         _mint(account, tokensToMint);
851         return (backPayWeiAmount, tokensToMint);
852     }
853 
854     function checkInvestTimeAndSize(address account, uint256 weiAmount) private {
855         if (now - lastInvestTime[account] > 24 hours) {
856             investSize24h[account] = 0;
857         }
858         require(investSize24h[account].add(weiAmount) <= 5 ether, 'Investment limit exceeded for 24 hours.');
859         investSize24h[account] = investSize24h[account].add(weiAmount);
860         lastInvestTime[account] = now;
861     }
862 
863     function buyFee(address sender, uint256 weiAmount, bool isFirstInvest) private {
864         address referrer = referrers[sender];
865         uint256 holdersWeiAmount;
866         if (referrer != address(0)) {
867             uint256 referrerWeiAmount = weiAmount.mul(REFERRER_PERCENT).div(100);
868             emit ReferalsIncome(referrer, referrerWeiAmount, now);
869             ethStorage[referrer] = ethStorage[referrer].add(referrerWeiAmount);
870             if (isFirstInvest) {
871                 uint256 cashbackWeiAmount = weiAmount.mul(CASHBACK_PERCENT).div(100);
872                 emit ReferalsIncome(sender, cashbackWeiAmount, now);
873                 ethStorage[sender] = ethStorage[sender].add(cashbackWeiAmount);
874                 holdersWeiAmount = weiAmount.mul(HOLDERS_BUY_PERCENT_WITH_REFERRER_AND_CASHBACK).div(100);
875             } else {
876                 holdersWeiAmount = weiAmount.mul(HOLDERS_BUY_PERCENT_WITH_REFERRER).div(100);
877             }
878         } else {
879             holdersWeiAmount = weiAmount.mul(HOLDERS_BUY_PERCENT).div(100);
880         }
881         addDividends(holdersWeiAmount);
882     }
883 
884     function sellFee(uint256 weiAmount) private returns(uint256) {
885         uint256 holdersWeiAmount = weiAmount.mul(HOLDERS_SELL_PERCENT).div(100);
886         addDividends(holdersWeiAmount);
887         weiAmount = weiAmount.sub(holdersWeiAmount);
888         return weiAmount;
889     }
890 
891     function addDividends(uint256 weiAmount) private {
892         investDividends = investDividends.add(weiAmount);
893     }
894 
895     function ethereumToTokens(uint256 weiAmount) private returns(uint256, uint256) {
896         uint256 b = priceCoeff;
897         uint256 c = weiAmount;
898         uint256 D = (b ** 2).add(a.mul(4).mul(c));
899         uint256 tokensAmount = (sqrt(D).sub(b)).div((a).mul(2));
900         require(tokensAmount > 0);
901         uint256 backPayWeiAmount = weiAmount.sub(a.mul(tokensAmount ** 2).add(priceCoeff.mul(tokensAmount)));
902         priceCoeff = priceCoeff.add(tokensAmount.mul(1e10));
903         tokensAmount = tokensAmount.mul(10 ** uint256(decimals()));
904         return (tokensAmount, backPayWeiAmount);
905     }
906 
907     function tokensToEthereum(uint256 tokensAmount) private returns(uint256) {
908         require(tokensAmount > 0);
909         uint256 weiAmount = priceCoeff.mul(tokensAmount).sub((tokensAmount ** 2).mul(5).mul(1e9));
910         priceCoeff = priceCoeff.sub(tokensAmount.mul(1e10));
911         return weiAmount;
912     }
913 
914     function bytesToAddress(bytes source) private pure returns(address parsedAddress)
915     {
916         assembly {
917             parsedAddress := mload(add(source,0x14))
918         }
919         return parsedAddress;
920     }
921 
922     function sqrt(uint256 x) private pure returns (uint256 y) {
923         uint256 z = (x + 1) / 2;
924         y = x;
925         while (z < y) {
926             y = z;
927             z = (x / z + z) / 2;
928         }
929     }
930 
931     function deleteTokensHolder(uint index) private {
932         holders[index] = holders[holders.length - 1];
933         delete holders[holders.length - 1];
934         holders.length--;
935     }
936 }