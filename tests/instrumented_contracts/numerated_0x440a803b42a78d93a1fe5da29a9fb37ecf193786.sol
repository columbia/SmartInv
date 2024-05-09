1 pragma solidity 0.5.2;
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
56  * @title SafeMath
57  * @dev Unsigned math operations with safety checks that revert on error
58  */
59 library SafeMath {
60     /**
61     * @dev Multiplies two unsigned integers, reverts on overflow.
62     */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath#mul: Integer overflow");
73 
74         return c;
75     }
76 
77     /**
78     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
79     */
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Solidity only automatically asserts when dividing by 0
82         require(b > 0, "SafeMath#div: Invalid divisor zero");
83         uint256 c = a / b;
84         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85 
86         return c;
87     }
88 
89     /**
90     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
91     */
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         require(b <= a, "SafeMath#sub: Integer underflow");
94         uint256 c = a - b;
95 
96         return c;
97     }
98 
99     /**
100     * @dev Adds two unsigned integers, reverts on overflow.
101     */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath#add: Integer overflow");
105 
106         return c;
107     }
108 
109     /**
110     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
111     * reverts when dividing by zero.
112     */
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         require(b != 0, "SafeMath#mod: Invalid divisor zero");
115         return a % b;
116     }
117 }
118 
119 contract IUniswapExchange {
120     // Address of ERC20 token sold on this exchange
121     function tokenAddress() external view returns (address token);
122     // Address of Uniswap Factory
123     function factoryAddress() external view returns (address factory);
124     // Provide Liquidity
125     function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
126     function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
127     // Get Prices
128     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
129     function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
130     function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
131     function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
132     // Trade ETH to ERC20
133     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
134     function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
135     function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
136     function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
137     // Trade ERC20 to ETH
138     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
139     function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_tokens, uint256 deadline, address recipient) external returns (uint256  eth_bought);
140     function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
141     function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
142     // Trade ERC20 to ERC20
143     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
144     function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
145     function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
146     function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
147     // Trade ERC20 to Custom Pool
148     function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
149     function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
150     function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
151     function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
152     // ERC20 comaptibility for liquidity tokens
153     bytes32 public name;
154     bytes32 public symbol;
155     uint256 public decimals;
156     function transfer(address _to, uint256 _value) external returns (bool);
157     function transferFrom(address _from, address _to, uint256 value) external returns (bool);
158     function approve(address _spender, uint256 _value) external returns (bool);
159     function allowance(address _owner, address _spender) external view returns (uint256);
160     function balanceOf(address _owner) external view returns (uint256);
161     // Never use
162     function setup(address token_addr) external;
163 }
164 
165 contract IUniswapFactory {
166     // Public Variables
167     address public exchangeTemplate;
168     uint256 public tokenCount;
169     // Create Exchange
170     function createExchange(address token) external returns (address payable exchange);
171     // Get Exchange and Token Info
172     function getExchange(address token) external view returns (address payable exchange);
173     function getToken(address exchange) external view returns (address token);
174     function getTokenWithId(uint256 tokenId) external view returns (address token);
175 }
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
182  * Originally based on code by FirstBlood:
183  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  *
185  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
186  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
187  * compliant implementations may not do it.
188  */
189 contract ERC20 is IERC20 {
190     using SafeMath for uint256;
191 
192     mapping (address => uint256) private _balances;
193 
194     mapping (address => mapping (address => uint256)) private _allowed;
195 
196     uint256 private _totalSupply;
197 
198     /**
199     * @dev Total number of tokens in existence
200     */
201     function totalSupply() public view returns (uint256) {
202         return _totalSupply;
203     }
204 
205     /**
206     * @dev Gets the balance of the specified address.
207     * @param owner The address to query the balance of.
208     * @return An uint256 representing the amount owned by the passed address.
209     */
210     function balanceOf(address owner) public view returns (uint256) {
211         return _balances[owner];
212     }
213 
214     /**
215      * @dev Function to check the amount of tokens that an owner allowed to a spender.
216      * @param owner address The address which owns the funds.
217      * @param spender address The address which will spend the funds.
218      * @return A uint256 specifying the amount of tokens still available for the spender.
219      */
220     function allowance(address owner, address spender) public view returns (uint256) {
221         return _allowed[owner][spender];
222     }
223 
224     /**
225     * @dev Transfer token for a specified address
226     * @param to The address to transfer to.
227     * @param value The amount to be transferred.
228     */
229     function transfer(address to, uint256 value) public returns (bool) {
230         _transfer(msg.sender, to, value);
231         return true;
232     }
233 
234     /**
235      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236      * Beware that changing an allowance with this method brings the risk that someone may use both the old
237      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240      * @param spender The address which will spend the funds.
241      * @param value The amount of tokens to be spent.
242      */
243     function approve(address spender, uint256 value) public returns (bool) {
244         require(spender != address(0), "ERC20#approve: Cannot approve address zero");
245 
246         _allowed[msg.sender][spender] = value;
247         emit Approval(msg.sender, spender, value);
248         return true;
249     }
250 
251     /**
252      * @dev Transfer tokens from one address to another.
253      * Note that while this function emits an Approval event, this is not required as per the specification,
254      * and other compliant implementations may not emit the event.
255      * @param from address The address which you want to send tokens from
256      * @param to address The address which you want to transfer to
257      * @param value uint256 the amount of tokens to be transferred
258      */
259     function transferFrom(address from, address to, uint256 value) public returns (bool) {
260         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
261         _transfer(from, to, value);
262         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
263         return true;
264     }
265 
266     /**
267      * @dev Increase the amount of tokens that an owner allowed to a spender.
268      * approve should be called when allowed_[_spender] == 0. To increment
269      * allowed value is better to use this function to avoid 2 calls (and wait until
270      * the first transaction is mined)
271      * From MonolithDAO Token.sol
272      * Emits an Approval event.
273      * @param spender The address which will spend the funds.
274      * @param addedValue The amount of tokens to increase the allowance by.
275      */
276     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
277         require(spender != address(0), "ERC20#increaseAllowance: Cannot increase allowance for address zero");
278 
279         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
280         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
281         return true;
282     }
283 
284     /**
285      * @dev Decrease the amount of tokens that an owner allowed to a spender.
286      * approve should be called when allowed_[_spender] == 0. To decrement
287      * allowed value is better to use this function to avoid 2 calls (and wait until
288      * the first transaction is mined)
289      * From MonolithDAO Token.sol
290      * Emits an Approval event.
291      * @param spender The address which will spend the funds.
292      * @param subtractedValue The amount of tokens to decrease the allowance by.
293      */
294     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
295         require(spender != address(0), "ERC20#decreaseAllowance: Cannot decrease allowance for address zero");
296 
297         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
298         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
299         return true;
300     }
301 
302     /**
303     * @dev Transfer token for a specified addresses
304     * @param from The address to transfer from.
305     * @param to The address to transfer to.
306     * @param value The amount to be transferred.
307     */
308     function _transfer(address from, address to, uint256 value) internal {
309         require(to != address(0), "ERC20#_transfer: Cannot transfer to address zero");
310 
311         _balances[from] = _balances[from].sub(value);
312         _balances[to] = _balances[to].add(value);
313         emit Transfer(from, to, value);
314     }
315 
316     /**
317      * @dev Internal function that mints an amount of the token and assigns it to
318      * an account. This encapsulates the modification of balances such that the
319      * proper events are emitted.
320      * @param account The account that will receive the created tokens.
321      * @param value The amount that will be created.
322      */
323     function _mint(address account, uint256 value) internal {
324         require(account != address(0), "ERC20#_mint: Cannot mint to address zero");
325 
326         _totalSupply = _totalSupply.add(value);
327         _balances[account] = _balances[account].add(value);
328         emit Transfer(address(0), account, value);
329     }
330 
331     /**
332      * @dev Internal function that burns an amount of the token of a given
333      * account.
334      * @param account The account whose tokens will be burnt.
335      * @param value The amount that will be burnt.
336      */
337     function _burn(address account, uint256 value) internal {
338         require(account != address(0), "ERC20#_burn: Cannot burn from address zero");
339 
340         _totalSupply = _totalSupply.sub(value);
341         _balances[account] = _balances[account].sub(value);
342         emit Transfer(account, address(0), value);
343     }
344 
345     /**
346      * @dev Internal function that burns an amount of the token of a given
347      * account, deducting from the sender's allowance for said account. Uses the
348      * internal burn function.
349      * Emits an Approval event (reflecting the reduced allowance).
350      * @param account The account whose tokens will be burnt.
351      * @param value The amount that will be burnt.
352      */
353     function _burnFrom(address account, uint256 value) internal {
354         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
355         _burn(account, value);
356         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
357     }
358 }
359 
360 contract OracleToken is ERC20 {
361     string public name = "Polaris Token";
362     string public symbol = "PLRS";
363     uint8 public decimals = 18;
364     address public oracle;
365     address public token;
366 
367     constructor(address _token) public payable {
368         oracle = msg.sender;
369         token = _token;
370     }
371 
372     function () external payable {}
373 
374     function mint(address to, uint amount) public returns (bool) {
375         require(msg.sender == oracle, "OracleToken::mint: Only Oracle can call mint");
376         _mint(to, amount);
377         return true;
378     }
379 
380     function redeem(uint amount) public {
381         uint ethAmount = address(this).balance.mul(amount).div(totalSupply());
382         _burn(msg.sender, amount);
383         msg.sender.transfer(ethAmount);
384     }
385 }
386 
387 pragma experimental ABIEncoderV2;
388 
389 
390 contract Polaris {
391     using Math for uint;
392     using SafeMath for uint;
393 
394     event NewMedian(address indexed token, uint ethReserve, uint tokenReserve);
395     event Subscribe(address indexed token, address indexed subscriber, uint amount);
396     event Unsubscribe(address indexed token, address indexed subscriber, uint amount);
397 
398     uint8 public constant MAX_CHECKPOINTS = 15;
399 
400     // Reward for a successful poke, in oracle tokens
401     uint public constant CHECKPOINT_REWARD = 1e18;
402 
403     // Conditions for checkpoint reward
404     uint public constant MIN_PRICE_CHANGE = .01e18; // 1%
405     uint public constant MAX_TIME_SINCE_LAST_CHECKPOINT = 3 hours;
406 
407     uint public constant PENDING_PERIOD = 3.5 minutes;
408 
409     address public constant ETHER = address(0);
410 
411     // Monthly subscription fee to subscribe to a single oracle
412     uint public constant MONTHLY_SUBSCRIPTION_FEE = 5 ether;
413     uint public constant ONE_MONTH_IN_SECONDS = 30 days;
414 
415     IUniswapFactory public uniswap;
416 
417     struct Account {
418         uint balance;
419         uint collectionTimestamp;
420     }
421 
422     struct Checkpoint {
423         uint ethReserve;
424         uint tokenReserve;
425     }
426 
427     struct Medianizer {
428         uint8 tail;
429         uint pendingStartTimestamp;
430         uint latestTimestamp;
431         Checkpoint[] prices;
432         Checkpoint[] pending;
433         Checkpoint median;
434     }
435 
436     // Token => Subscriber => Account
437     mapping (address => mapping (address => Account)) public accounts;
438 
439     // Token => Oracle Token (reward for poking)
440     mapping (address => OracleToken) public oracleTokens;
441 
442     // Token => Medianizer
443     mapping (address => Medianizer) private medianizers;
444 
445     constructor(IUniswapFactory _uniswap) public {
446         uniswap = _uniswap;
447     }
448 
449     /**
450      * @dev Subscribe to read the price of a given token (e.g, DAI).
451      * @param token The address of the token to subscribe to.
452      */
453     function subscribe(address token) public payable {
454         Account storage account = accounts[token][msg.sender];
455         _collect(token, account);
456         account.balance = account.balance.add(msg.value);
457         require(account.balance >= MONTHLY_SUBSCRIPTION_FEE, "Polaris::subscribe: Account balance is below the minimum");
458         emit Subscribe(token, msg.sender, msg.value);
459     }
460 
461     /**
462      * @dev Unsubscribe to a given token (e.g, DAI).
463      * @param token The address of the token to unsubscribe from.
464      * @param amount The requested amount to withdraw, in wei.
465      * @return The actual amount withdrawn, in wei.
466      */
467     function unsubscribe(address token, uint amount) public returns (uint) {
468         Account storage account = accounts[token][msg.sender];
469         _collect(token, account);
470         uint maxWithdrawAmount = account.balance.sub(MONTHLY_SUBSCRIPTION_FEE);
471         uint actualWithdrawAmount = amount.min(maxWithdrawAmount);
472         account.balance = account.balance.sub(actualWithdrawAmount);
473         msg.sender.transfer(actualWithdrawAmount);
474         emit Unsubscribe(token, msg.sender, actualWithdrawAmount);
475     }
476 
477     /**
478      * @dev Collect subscription fees from a subscriber.
479      * @param token The address of the subscribed token to collect fees from.
480      * @param who The address of the subscriber.
481      */
482     function collect(address token, address who) public {
483         Account storage account = accounts[token][who];
484         _collect(token, account);
485     }
486 
487     /**
488      * @dev Add a new price checkpoint.
489      * @param token The address of the token to checkpoint.
490      */
491     function poke(address token) public {
492         require(_isHuman(), "Polaris::poke: Poke must be called by an externally owned account");
493         OracleToken oracleToken = oracleTokens[token];
494 
495         // Get the current reserves from Uniswap
496         Checkpoint memory checkpoint = _newCheckpoint(token);
497 
498         if (address(oracleToken) == address(0)) {
499             _initializeMedianizer(token, checkpoint);
500         } else {
501             Medianizer storage medianizer = medianizers[token];
502 
503             require(medianizer.latestTimestamp != block.timestamp, "Polaris::poke: Cannot poke more than once per block");
504 
505             // See if checkpoint should be rewarded
506             if (_willRewardCheckpoint(token, checkpoint)) {
507                 oracleToken.mint(msg.sender, CHECKPOINT_REWARD);
508             }
509 
510             // If pending checkpoints are old, reset pending checkpoints
511             if (block.timestamp.sub(medianizer.pendingStartTimestamp) > PENDING_PERIOD || medianizer.pending.length == MAX_CHECKPOINTS) {
512                 medianizer.pending.length = 0;
513                 medianizer.tail = (medianizer.tail + 1) % MAX_CHECKPOINTS;
514                 medianizer.pendingStartTimestamp = block.timestamp;
515             }
516 
517             medianizer.latestTimestamp = block.timestamp;
518 
519             // Add the checkpoint to the pending array
520             medianizer.pending.push(checkpoint);
521             
522             // Add the pending median to the prices array
523             medianizer.prices[medianizer.tail] = _medianize(medianizer.pending);
524             
525             // Find and store the prices median
526             medianizer.median = _medianize(medianizer.prices);
527 
528             emit NewMedian(token, medianizer.median.ethReserve, medianizer.median.tokenReserve);
529         }
530     }
531 
532     /**
533      * @dev Get price data for a given token.
534      * @param token The address of the token to query.
535      * @return The price data struct.
536      */
537     function getMedianizer(address token) public view returns (Medianizer memory) {
538         require(_isSubscriber(accounts[token][msg.sender]) || _isHuman(), "Polaris::getMedianizer: Not subscribed");
539         return medianizers[token];
540     }
541 
542     /**
543      * @notice This uses the x * y = k bonding curve to determine the destination amount based on the medianized price.
544      *              𝝙x = (𝝙y * x) / (y + 𝝙y)
545      * @dev Get the amount of destination token, based on a given amount of source token.
546      * @param src The address of the source token.
547      * @param dest The address of the destination token.
548      * @param srcAmount The amount of the source token.
549      * @return The amount of destination token.
550      */
551     function getDestAmount(address src, address dest, uint srcAmount) public view returns (uint) {
552         if (!_isHuman()) {
553             require(src == ETHER || _isSubscriber(accounts[src][msg.sender]), "Polaris::getDestAmount: Not subscribed");
554             require(dest == ETHER || _isSubscriber(accounts[dest][msg.sender]), "Polaris::getDestAmount: Not subscribed");    
555         }
556 
557         if (src == dest) {
558             return srcAmount;
559         } else if (src == ETHER) {
560             Checkpoint memory median = medianizers[dest].median;
561             return srcAmount.mul(median.tokenReserve).div(median.ethReserve.add(srcAmount));
562         } else if (dest == ETHER) {
563             Checkpoint memory median = medianizers[src].median;
564             return srcAmount.mul(median.ethReserve).div(median.tokenReserve.add(srcAmount));
565         } else {
566             Checkpoint memory srcMedian = medianizers[src].median;
567             Checkpoint memory destMedian = medianizers[dest].median;
568             
569             uint ethAmount = srcAmount.mul(srcMedian.ethReserve).div(srcMedian.tokenReserve.add(srcAmount));
570             return ethAmount.mul(destMedian.ethReserve).div(destMedian.tokenReserve.add(ethAmount));
571         }
572     }
573 
574     /**
575      * @dev Determine whether a given checkpoint would be rewarded with newly minted oracle tokens.
576      * @param token The address of the token to query checkpoint for.
577      * @return True if given checkpoint satisfies any of the following:
578      *              Less than required checkpoints exist to calculate a valid median
579      *              Exceeds max time since last checkpoint
580      *              Exceeds minimum price change from median AND no pending checkpoints
581      *              Exceeds minimum percent change from pending checkpoints median
582      *              Exceeds minimum percent change from last checkpoint
583      */
584     function willRewardCheckpoint(address token) public view returns (bool) {
585         Checkpoint memory checkpoint = _newCheckpoint(token);
586         return _willRewardCheckpoint(token, checkpoint);
587     }
588 
589     /**
590      * @dev Get the account for a given subscriber of a token feed.
591      * @param token The token to query the account of the given subscriber.
592      * @param who The subscriber to query the account of the given token feed.
593      * @return The account of the subscriber of the given token feed.
594      */
595     function getAccount(address token, address who) public view returns (Account memory) {
596         return accounts[token][who];
597     }
598 
599     /**
600      * @dev Get the owed amount for a given subscriber of a token feed.
601      * @param token The token to query the owed amount of the given subscriber.
602      * @param who The subscriber to query the owed amount for the given token feed.
603      * @return The owed amount of the subscriber of the given token feed.
604      */
605     function getOwedAmount(address token, address who) public view returns (uint) {
606         Account storage account = accounts[token][who];
607         return _getOwedAmount(account);
608     }
609 
610     /**
611      * @dev Update the subscriber balance of a given token feed.
612      * @param token The token to collect subscription revenues for.
613      * @param account The subscriber account to collect subscription revenues from.
614      */
615     function _collect(address token, Account storage account) internal {
616         if (account.balance == 0) {
617             account.collectionTimestamp = block.timestamp;
618             return;
619         }
620 
621         uint owedAmount = _getOwedAmount(account);
622         OracleToken oracleToken = oracleTokens[token];
623 
624         // If the subscriber does not have enough, collect the remaining balance
625         if (owedAmount >= account.balance) {
626             address(oracleToken).transfer(account.balance);
627             account.balance = 0;
628         } else {
629             address(oracleToken).transfer(owedAmount);
630             account.balance = account.balance.sub(owedAmount);
631         }
632 
633         account.collectionTimestamp = block.timestamp;
634     }
635 
636     /**
637      * @dev Initialize the medianizer
638      * @param token The token to initialize the medianizer for.
639      * @param checkpoint The new checkpoint to initialize the medianizer with.
640      */
641     function _initializeMedianizer(address token, Checkpoint memory checkpoint) internal {
642         address payable exchange = uniswap.getExchange(token);
643         require(exchange != address(0), "Polaris::_initializeMedianizer: Token must exist on Uniswap");
644 
645         OracleToken oracleToken = new OracleToken(token);
646         oracleTokens[token] = oracleToken;
647         // Reward additional oracle tokens for the first poke to compensate for extra gas costs
648         oracleToken.mint(msg.sender, CHECKPOINT_REWARD.mul(10));
649 
650         Medianizer storage medianizer = medianizers[token];
651         medianizer.pending.push(checkpoint);
652         medianizer.median = checkpoint;
653         medianizer.latestTimestamp = block.timestamp;
654         medianizer.pendingStartTimestamp = block.timestamp;
655 
656         // Hydrate prices queue
657         for (uint i = 0; i < MAX_CHECKPOINTS; i++) {
658             medianizer.prices.push(checkpoint);
659         }
660     }
661 
662     /**
663      * @dev Find the median given an array of checkpoints.
664      * @param checkpoints The array of checkpoints to find the median.
665      * @return The median checkpoint within the given array.
666      */
667     function _medianize(Checkpoint[] memory checkpoints) internal pure returns (Checkpoint memory) {
668         // To minimize complexity, return the higher of the two middle checkpoints in even-sized arrays instead of the average.
669         uint k = checkpoints.length.div(2); 
670         uint left = 0;
671         uint right = checkpoints.length.sub(1);
672 
673         while (left < right) {
674             uint pivotIndex = left.add(right).div(2);
675             Checkpoint memory pivotCheckpoint = checkpoints[pivotIndex];
676 
677             (checkpoints[pivotIndex], checkpoints[right]) = (checkpoints[right], checkpoints[pivotIndex]);
678             uint storeIndex = left;
679             for (uint i = left; i < right; i++) {
680                 if (_isLessThan(checkpoints[i], pivotCheckpoint)) {
681                     (checkpoints[storeIndex], checkpoints[i]) = (checkpoints[i], checkpoints[storeIndex]);
682                     storeIndex++;
683                 }
684             }
685 
686             (checkpoints[storeIndex], checkpoints[right]) = (checkpoints[right], checkpoints[storeIndex]);
687             if (storeIndex < k) {
688                 left = storeIndex.add(1);
689             } else {
690                 right = storeIndex;
691             }
692         }
693 
694         return checkpoints[k];
695     }
696 
697     /**
698      * @dev Determine if checkpoint x is less than checkpoint y.
699      * @param x The first checkpoint for comparison.
700      * @param y The second checkpoint for comparison.
701      * @return True if x is less than y.
702      */
703     function _isLessThan(Checkpoint memory x, Checkpoint memory y) internal pure returns (bool) {
704         return x.ethReserve.mul(y.tokenReserve) < y.ethReserve.mul(x.tokenReserve);
705     }
706 
707     /**
708      * @dev Check if msg.sender is an externally owned account.
709      * @return True if msg.sender is an externally owned account, false if smart contract.
710      */
711     function _isHuman() internal view returns (bool) {
712         return msg.sender == tx.origin;
713     }
714 
715     /**
716      * @dev Get the reserve values of a Uniswap exchange for a given token.
717      * @param token The token to query the reserve values for.
718      * @return A checkpoint holding the appropriate reserve values.
719      */
720     function _newCheckpoint(address token) internal view returns (Checkpoint memory) {
721         address payable exchange = uniswap.getExchange(token);
722         return Checkpoint({
723             ethReserve: exchange.balance,
724             tokenReserve: IERC20(token).balanceOf(exchange)
725         });
726     }
727 
728     /**
729      * @dev Get subscriber status of a given account for a given token.
730      * @param account The account to query.
731      * @return True if subscribed.
732      */
733     function _isSubscriber(Account storage account) internal view returns (bool) {
734         // Strict inequality to return false for users who never subscribed and owe zero.      
735         return account.balance > _getOwedAmount(account);
736     }
737 
738     /**
739      * @dev Get amount owed by an account. Accrued amount minus collections.
740      * @param account The account to query.
741      * @return Amount owed.
742      */
743     function _getOwedAmount(Account storage account) internal view returns (uint) {
744         if (account.collectionTimestamp == 0) return 0;
745 
746         uint timeElapsed = block.timestamp.sub(account.collectionTimestamp);
747         return MONTHLY_SUBSCRIPTION_FEE.mul(timeElapsed).div(ONE_MONTH_IN_SECONDS);
748     }
749 
750     /**
751      * @dev Determine whether a given checkpoint would be rewarded with newly minted oracle tokens.
752      * @param token The address of the token to query checkpoint for.
753      * @param checkpoint The checkpoint to test for reward of oracle tokens.
754      * @return True if given checkpoint satisfies any of the following:
755      *              Less than required checkpoints exist to calculate a valid median
756      *              Exceeds max time since last checkpoint
757      *              Exceeds minimum price change from median AND no pending checkpoints
758      *              Exceeds minimum percent change from pending checkpoints median
759      *              Exceeds minimum percent change from last checkpoint
760      */
761     function _willRewardCheckpoint(address token, Checkpoint memory checkpoint) internal view returns (bool) {
762         Medianizer memory medianizer = medianizers[token];
763 
764         return (
765             medianizer.prices.length < MAX_CHECKPOINTS ||
766             block.timestamp.sub(medianizer.latestTimestamp) >= MAX_TIME_SINCE_LAST_CHECKPOINT ||
767             (block.timestamp.sub(medianizer.pendingStartTimestamp) >= PENDING_PERIOD && _percentChange(medianizer.median, checkpoint) >= MIN_PRICE_CHANGE) ||
768             _percentChange(medianizer.prices[medianizer.tail], checkpoint) >= MIN_PRICE_CHANGE ||
769             _percentChange(medianizer.pending[medianizer.pending.length.sub(1)], checkpoint) >= MIN_PRICE_CHANGE
770         );
771     }
772 
773     /**
774      * @dev Get the percent change between two checkpoints.
775      * @param x The first checkpoint.
776      * @param y The second checkpoint.
777      * @return The absolute value of the percent change, with 18 decimals of precision (e.g., .01e18 = 1%).
778      */
779     function _percentChange(Checkpoint memory x, Checkpoint memory y) internal pure returns (uint) {
780         uint a = x.ethReserve.mul(y.tokenReserve);
781         uint b = y.ethReserve.mul(x.tokenReserve);
782         uint diff = a > b ? a.sub(b) : b.sub(a);
783         return diff.mul(10 ** 18).div(a);
784     }
785 
786 }