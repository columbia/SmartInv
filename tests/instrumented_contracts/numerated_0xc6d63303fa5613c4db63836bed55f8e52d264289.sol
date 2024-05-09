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
204 contract ERC20 is IERC20 {
205     using SafeMath for uint256;
206 
207     mapping (address => uint256) private _balances;
208     mapping (address => mapping (address => uint256)) private _allowed;
209     uint256 private _totalSupply;
210 
211     /**
212     * @dev Total number of tokens in existence
213     */
214     function totalSupply() public view returns (uint256) {
215         return _totalSupply;
216     }
217 
218     /**
219     * @dev Gets the balance of the specified address.
220     * @param owner The address to query the balance of.
221     * @return An uint256 representing the amount owned by the passed address.
222     */
223     function balanceOf(address owner) public view returns (uint256) {
224         return _balances[owner];
225     }
226 
227     /**
228      * @dev Function to check the amount of tokens that an owner allowed to a spender.
229      * @param owner address The address which owns the funds.
230      * @param spender address The address which will spend the funds.
231      * @return A uint256 specifying the amount of tokens still available for the spender.
232      */
233     function allowance(address owner, address spender) public view returns (uint256) {
234         return _allowed[owner][spender];
235     }
236 
237     /**
238     * @dev Transfer token for a specified address
239     * @param to The address to transfer to.
240     * @param value The amount to be transferred.
241     */
242     function transfer(address to, uint256 value) public returns (bool) {
243         _transfer(msg.sender, to, value);
244         return true;
245     }
246 
247     /**
248      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249      * Beware that changing an allowance with this method brings the risk that someone may use both the old
250      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253      * @param spender The address which will spend the funds.
254      * @param value The amount of tokens to be spent.
255      */
256     function approve(address spender, uint256 value) public returns (bool) {
257         require(spender != address(0));
258 
259         _allowed[msg.sender][spender] = value;
260         emit Approval(msg.sender, spender, value);
261         return true;
262     }
263 
264     /**
265      * @dev Transfer tokens from one address to another.
266      * Note that while this function emits an Approval event, this is not required as per the specification,
267      * and other compliant implementations may not emit the event.
268      * @param from address The address which you want to send tokens from
269      * @param to address The address which you want to transfer to
270      * @param value uint256 the amount of tokens to be transferred
271      */
272     function transferFrom(address from, address to, uint256 value) public returns (bool) {
273         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
274         _transfer(from, to, value);
275         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
276         return true;
277     }
278 
279     /**
280      * @dev Increase the amount of tokens that an owner allowed to a spender.
281      * approve should be called when allowed_[_spender] == 0. To increment
282      * allowed value is better to use this function to avoid 2 calls (and wait until
283      * the first transaction is mined)
284      * From MonolithDAO Token.sol
285      * Emits an Approval event.
286      * @param spender The address which will spend the funds.
287      * @param addedValue The amount of tokens to increase the allowance by.
288      */
289     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
290         require(spender != address(0));
291 
292         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
293         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
294         return true;
295     }
296 
297     /**
298      * @dev Decrease the amount of tokens that an owner allowed to a spender.
299      * approve should be called when allowed_[_spender] == 0. To decrement
300      * allowed value is better to use this function to avoid 2 calls (and wait until
301      * the first transaction is mined)
302      * From MonolithDAO Token.sol
303      * Emits an Approval event.
304      * @param spender The address which will spend the funds.
305      * @param subtractedValue The amount of tokens to decrease the allowance by.
306      */
307     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
308         require(spender != address(0));
309 
310         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
311         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
312         return true;
313     }
314 
315     /**
316     * @dev Transfer token for a specified addresses
317     * @param from The address to transfer from.
318     * @param to The address to transfer to.
319     * @param value The amount to be transferred.
320     */
321     function _transfer(address from, address to, uint256 value) internal {
322         require(to != address(0));
323 
324         _balances[from] = _balances[from].sub(value);
325         _balances[to] = _balances[to].add(value);
326         emit Transfer(from, to, value);
327     }
328 
329     /**
330      * @dev Internal function that mints an amount of the token and assigns it to
331      * an account. This encapsulates the modification of balances such that the
332      * proper events are emitted.
333      * @param account The account that will receive the created tokens.
334      * @param value The amount that will be created.
335      */
336     function _mint(address account, uint256 value) internal {
337         require(account != address(0));
338 
339         _totalSupply = _totalSupply.add(value);
340         _balances[account] = _balances[account].add(value);
341         emit Transfer(address(0), account, value);
342     }
343 
344     /**
345      * @dev Internal function that burns an amount of the token of a given
346      * account.
347      * @param account The account whose tokens will be burnt.
348      * @param value The amount that will be burnt.
349      */
350     function _burn(address account, uint256 value) internal {
351         require(account != address(0));
352 
353         _totalSupply = _totalSupply.sub(value);
354         _balances[account] = _balances[account].sub(value);
355         emit Transfer(account, address(0), value);
356     }
357 }
358 
359 contract BonusToken is ERC20, ERC20Detailed, Ownable {
360 
361     address public gameAddress;
362     address public investTokenAddress;
363     uint public maxLotteryParticipants;
364 
365     mapping (address => uint256) public ethLotteryBalances;
366     address[] public ethLotteryParticipants;
367     uint256 public ethLotteryBank;
368     bool public isEthLottery;
369 
370     mapping (address => uint256) public tokensLotteryBalances;
371     address[] public tokensLotteryParticipants;
372     uint256 public tokensLotteryBank;
373     bool public isTokensLottery;
374 
375     modifier onlyGame() {
376         require(msg.sender == gameAddress);
377         _;
378     }
379 
380     modifier tokenIsAvailable {
381         require(investTokenAddress != address(0));
382         _;
383     }
384 
385     constructor (address startGameAddress) public ERC20Detailed("Bet Token", "BET", 18) {
386         setGameAddress(startGameAddress);
387     }
388 
389     function setGameAddress(address newGameAddress) public onlyOwner {
390         require(newGameAddress != address(0));
391         gameAddress = newGameAddress;
392     }
393 
394     function buyTokens(address buyer, uint256 tokensAmount) public onlyGame {
395         _mint(buyer, tokensAmount * 10**18);
396     }
397 
398     function startEthLottery() public onlyGame {
399         isEthLottery = true;
400     }
401 
402     function startTokensLottery() public onlyGame tokenIsAvailable {
403         isTokensLottery = true;
404     }
405 
406     function restartEthLottery() public onlyGame {
407         for (uint i = 0; i < ethLotteryParticipants.length; i++) {
408             ethLotteryBalances[ethLotteryParticipants[i]] = 0;
409         }
410         ethLotteryParticipants = new address[](0);
411         ethLotteryBank = 0;
412         isEthLottery = false;
413     }
414 
415     function restartTokensLottery() public onlyGame tokenIsAvailable {
416         for (uint i = 0; i < tokensLotteryParticipants.length; i++) {
417             tokensLotteryBalances[tokensLotteryParticipants[i]] = 0;
418         }
419         tokensLotteryParticipants = new address[](0);
420         tokensLotteryBank = 0;
421         isTokensLottery = false;
422     }
423 
424     function updateEthLotteryBank(uint256 value) public onlyGame {
425         ethLotteryBank = ethLotteryBank.sub(value);
426     }
427 
428     function updateTokensLotteryBank(uint256 value) public onlyGame {
429         tokensLotteryBank = tokensLotteryBank.sub(value);
430     }
431 
432     function swapTokens(address account, uint256 tokensToBurnAmount) public {
433         require(msg.sender == investTokenAddress);
434         _burn(account, tokensToBurnAmount);
435     }
436 
437     function sendToEthLottery(uint256 value) public {
438         require(!isEthLottery);
439         require(ethLotteryParticipants.length < maxLotteryParticipants);
440         address account = msg.sender;
441         _burn(account, value);
442         if (ethLotteryBalances[account] == 0) {
443             ethLotteryParticipants.push(account);
444         }
445         ethLotteryBalances[account] = ethLotteryBalances[account].add(value);
446         ethLotteryBank = ethLotteryBank.add(value);
447     }
448 
449     function sendToTokensLottery(uint256 value) public tokenIsAvailable {
450         require(!isTokensLottery);
451         require(tokensLotteryParticipants.length < maxLotteryParticipants);
452         address account = msg.sender;
453         _burn(account, value);
454         if (tokensLotteryBalances[account] == 0) {
455             tokensLotteryParticipants.push(account);
456         }
457         tokensLotteryBalances[account] = tokensLotteryBalances[account].add(value);
458         tokensLotteryBank = tokensLotteryBank.add(value);
459     }
460 
461     function ethLotteryParticipants() public view returns(address[]) {
462         return ethLotteryParticipants;
463     }
464 
465     function tokensLotteryParticipants() public view returns(address[]) {
466         return tokensLotteryParticipants;
467     }
468 
469     function setInvestTokenAddress(address newInvestTokenAddress) external onlyOwner {
470         require(newInvestTokenAddress != address(0));
471         investTokenAddress = newInvestTokenAddress;
472     }
473 
474     function setMaxLotteryParticipants(uint256 participants) external onlyOwner {
475         maxLotteryParticipants = participants;
476     }
477 }