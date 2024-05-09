1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     int256 constant private INT256_MIN = - 2 ** 255;
9 
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Multiplies two signed integers, reverts on overflow.
29     */
30     function mul(int256 a, int256 b) internal pure returns (int256) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34         if (a == 0) {
35             return 0;
36         }
37 
38         require(!(a == - 1 && b == INT256_MIN));
39         // This is the only case of overflow not detected by the check below
40 
41         int256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
61     */
62     function div(int256 a, int256 b) internal pure returns (int256) {
63         require(b != 0);
64         // Solidity only automatically asserts when dividing by 0
65         require(!(b == - 1 && a == INT256_MIN));
66         // This is the only case of overflow
67 
68         int256 c = a / b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
75     */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b <= a);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84     * @dev Subtracts two signed integers, reverts on overflow.
85     */
86     function sub(int256 a, int256 b) internal pure returns (int256) {
87         int256 c = a - b;
88         require((b >= 0 && c <= a) || (b < 0 && c > a));
89 
90         return c;
91     }
92 
93     /**
94     * @dev Adds two unsigned integers, reverts on overflow.
95     */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a);
99 
100         return c;
101     }
102 
103     /**
104     * @dev Adds two signed integers, reverts on overflow.
105     */
106     function add(int256 a, int256 b) internal pure returns (int256) {
107         int256 c = a + b;
108         require((b >= 0 && c >= a) || (b < 0 && c < a));
109 
110         return c;
111     }
112 
113     /**
114     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
115     * reverts when dividing by zero.
116     */
117     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b != 0);
119         return a % b;
120     }
121 }
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 interface IERC20 {
128     function totalSupply() external view returns (uint256);
129 
130     function balanceOf(address who) external view returns (uint256);
131 
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     function transfer(address to, uint256 value) external returns (bool);
135 
136     function approve(address spender, uint256 value) external returns (bool);
137 
138     function transferFrom(address from, address to, uint256 value) external returns (bool);
139 
140     event Transfer(address indexed from, address indexed to, uint256 value);
141 
142     event Approval(address indexed owner, address indexed spender, uint256 value);
143 }
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
150  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  *
152  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
153  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
154  * compliant implementations may not do it.
155  */
156 contract ERC20 is IERC20 {
157     using SafeMath for uint256;
158 
159     mapping(address => uint256) private _balances;
160 
161     mapping(address => mapping(address => uint256)) private _allowed;
162 
163     uint256 private _totalSupply;
164 
165     /**
166     * @dev Total number of tokens in existence
167     */
168     function totalSupply() public view returns (uint256) {
169         return _totalSupply;
170     }
171 
172     /**
173     * @dev Gets the balance of the specified address.
174     * @param owner The address to query the balance of.
175     * @return An uint256 representing the amount owned by the passed address.
176     */
177     function balanceOf(address owner) public view returns (uint256) {
178         return _balances[owner];
179     }
180 
181     /**
182      * @dev Function to check the amount of tokens that an owner allowed to a spender.
183      * @param owner address The address which owns the funds.
184      * @param spender address The address which will spend the funds.
185      * @return A uint256 specifying the amount of tokens still available for the spender.
186      */
187     function allowance(address owner, address spender) public view returns (uint256) {
188         return _allowed[owner][spender];
189     }
190 
191     /**
192      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193      * Beware that changing an allowance with this method brings the risk that someone may use both the old
194      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      * @param spender The address which will spend the funds.
198      * @param value The amount of tokens to be spent.
199      */
200     function approve(address spender, uint256 value) public returns (bool) {
201         require(spender != address(0));
202         require((value == 0) || (_allowed[msg.sender][spender] == 0));
203 
204         _allowed[msg.sender][spender] = value;
205         emit Approval(msg.sender, spender, value);
206         return true;
207     }
208 
209     /**
210      * @dev Transfer tokens from one address to another.
211      * Note that while this function emits an Approval event, this is not required as per the specification,
212      * and other compliant implementations may not emit the event.
213      * @param from address The address which you want to send tokens from
214      * @param to address The address which you want to transfer to
215      * @param value uint256 the amount of tokens to be transferred
216      */
217     function transferFrom(address from, address to, uint256 value) public returns (bool) {
218         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
219         _transfer(from, to, value);
220         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
221         return true;
222     }
223 
224     /**
225      * @dev Increase the amount of tokens that an owner allowed to a spender.
226      * approve should be called when allowed_[_spender] == 0. To increment
227      * allowed value is better to use this function to avoid 2 calls (and wait until
228      * the first transaction is mined)
229      * From MonolithDAO Token.sol
230      * Emits an Approval event.
231      * @param spender The address which will spend the funds.
232      * @param addedValue The amount of tokens to increase the allowance by.
233      */
234     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
235         require(spender != address(0));
236 
237         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
238         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
239         return true;
240     }
241 
242     /**
243      * @dev Decrease the amount of tokens that an owner allowed to a spender.
244      * approve should be called when allowed_[_spender] == 0. To decrement
245      * allowed value is better to use this function to avoid 2 calls (and wait until
246      * the first transaction is mined)
247      * From MonolithDAO Token.sol
248      * Emits an Approval event.
249      * @param spender The address which will spend the funds.
250      * @param subtractedValue The amount of tokens to decrease the allowance by.
251      */
252     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
253         require(spender != address(0));
254 
255         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
256         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
257         return true;
258     }
259 
260     /**
261     * @dev Transfer token for a specified addresses
262     * @param from The address to transfer from.
263     * @param to The address to transfer to.
264     * @param value The amount to be transferred.
265     */
266     function _transfer(address from, address to, uint256 value) internal {
267         require(to != address(0));
268 
269         _balances[from] = _balances[from].sub(value);
270         _balances[to] = _balances[to].add(value);
271         emit Transfer(from, to, value);
272     }
273 
274     /**
275      * @dev Internal function that mints an amount of the token and assigns it to
276      * an account. This encapsulates the modification of balances such that the
277      * proper events are emitted.
278      * @param account The account that will receive the created tokens.
279      * @param value The amount that will be created.
280      */
281     function _mint(address account, uint256 value) internal {
282         require(account != address(0));
283 
284         _totalSupply = _totalSupply.add(value);
285         _balances[account] = _balances[account].add(value);
286         emit Transfer(address(0), account, value);
287     }
288 
289     /**
290      * @dev Internal function that burns an amount of the token of a given
291      * account.
292      * @param account The account whose tokens will be burnt.
293      * @param value The amount that will be burnt.
294      */
295     function _burn(address account, uint256 value) internal {
296         require(account != address(0));
297 
298         _totalSupply = _totalSupply.sub(value);
299         _balances[account] = _balances[account].sub(value);
300         emit Transfer(account, address(0), value);
301     }
302 
303     /**
304      * @dev Internal function that burns an amount of the token of a given
305      * account, deducting from the sender's allowance for said account. Uses the
306      * internal burn function.
307      * Emits an Approval event (reflecting the reduced allowance).
308      * @param account The account whose tokens will be burnt.
309      * @param value The amount that will be burnt.
310      */
311     function _burnFrom(address account, uint256 value) internal {
312         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
313         _burn(account, value);
314         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
315     }
316 }
317 
318 /**
319  * @title Ownable
320  * @dev The Ownable contract has an owner address, and provides basic authorization control
321  * functions, this simplifies the implementation of "user permissions".
322  */
323 contract Ownable {
324     address private _owner;
325 
326     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
327 
328     /**
329      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
330      * account.
331      */
332     constructor () internal {
333         _owner = msg.sender;
334         emit OwnershipTransferred(address(0), _owner);
335     }
336 
337     /**
338      * @return the address of the owner.
339      */
340     function owner() public view returns (address) {
341         return _owner;
342     }
343 
344     /**
345      * @dev Throws if called by any account other than the owner.
346      */
347     modifier onlyOwner() {
348         require(isOwner());
349         _;
350     }
351 
352     /**
353      * @return true if `msg.sender` is the owner of the contract.
354      */
355     function isOwner() public view returns (bool) {
356         return msg.sender == _owner;
357     }
358 
359     /**
360      * @dev Allows the current owner to transfer control of the contract to a newOwner.
361      * @param newOwner The address to transfer ownership to.
362      */
363     function transferOwnership(address newOwner) public onlyOwner {
364         _transferOwnership(newOwner);
365     }
366 
367     /**
368      * @dev Transfers control of the contract to a newOwner.
369      * @param newOwner The address to transfer ownership to.
370      */
371     function _transferOwnership(address newOwner) internal {
372         require(newOwner != address(0));
373         emit OwnershipTransferred(_owner, newOwner);
374         _owner = newOwner;
375     }
376 }
377 
378 /**
379  * @title ERC20Detailed token
380  * @dev The decimals are only for visualization purposes.
381  * All the operations are done using the smallest and indivisible token unit,
382  * just as on Ethereum all the operations are done in wei.
383  */
384 contract ERC20Detailed is ERC20, Ownable {
385     string private _name = 'BitcoinShort';
386     string private _symbol = 'BSHORT';
387     uint8 private _decimals = 18;
388 
389     /**
390      * @return the name of the token.
391      */
392     function name() public view returns (string) {
393         return _name;
394     }
395 
396     /**
397      * @return the symbol of the token.
398      */
399     function symbol() public view returns (string) {
400         return _symbol;
401     }
402 
403     /**
404      * @return the number of decimals of the token.
405      */
406     function decimals() public view returns (uint8) {
407         return _decimals;
408     }
409 
410     /**
411      * @dev Burns a specific amount of tokens.
412      * @param value The amount of token to be burned.
413      */
414     function burn(uint256 value) public {
415         _burn(msg.sender, value);
416     }
417 
418     /**
419      * @dev Burns a specific amount of tokens from the target address and decrements allowance
420      * @param from address The address which you want to send tokens from
421      * @param value uint256 The amount of token to be burned
422      */
423     function burnFrom(address from, uint256 value) public {
424         _burnFrom(from, value);
425     }
426 }
427 
428 interface ITrade {
429     function sellTokensFrom(address from, uint amount) external;
430 
431     function isOwner(address user) external view returns (bool);
432 }
433 
434 contract BSHORT is ERC20Detailed {
435     using SafeMath for uint256;
436 
437     bool public isPaused = false;
438     uint256 private DEC = 1000000000000000000;
439     address public tradeAddress;
440     // how many ETH cost 1000 BSHORT. rate = 1000 BSHORT/ETH. It's always an integer!
441     // formula for rate: rate = 1000 * (BSHORT in USD) / (ETH in USD)
442     uint256 public rate = 10;
443     uint public minimumSupply = 1;
444     uint public hardCap = 9000000000 * DEC;
445 
446     event TokenPurchase(address purchaser, uint256 value, uint256 amount, uint integer_amount, uint256 tokensMinted);
447     event TokenIssue(address purchaser, uint256 amount, uint integer_amount, uint256 tokensMinted);
448 
449     modifier onlyTrade() {
450         require(msg.sender == tradeAddress);
451         _;
452     }
453 
454     function pauseCrowdSale() public onlyOwner {
455         require(isPaused == false);
456         isPaused = true;
457     }
458 
459     function startCrowdSale() public onlyOwner {
460         require(isPaused == true);
461         isPaused = false;
462     }
463 
464     function setRate(uint _rate) public onlyOwner {
465         require(_rate > 0);
466         require(_rate <= 1000);
467         rate = _rate;
468     }
469 
470     function buyTokens() public payable {
471         require(!isPaused);
472 
473         uint256 weiAmount = msg.value;
474         uint256 tokens = weiAmount.mul(1000).div(rate);
475 
476         require(tokens >= minimumSupply * DEC);
477         require(totalSupply().add(tokens) <= hardCap);
478 
479         _mint(msg.sender, tokens);
480         owner().transfer(msg.value);
481 
482         emit TokenPurchase(msg.sender, weiAmount, tokens, tokens.div(DEC), totalSupply().div(DEC));
483     }
484 
485     function IssueTokens(address account, uint256 value) public onlyOwner {
486         uint tokens = value * DEC;
487 
488         require(totalSupply().add(tokens) <= hardCap);
489 
490         _mint(account, tokens);
491 
492         emit TokenIssue(account, tokens, value, totalSupply().div(DEC));
493     }
494 
495     function() external payable {
496         buyTokens();
497     }
498 
499     function setTradeAddress(address _tradeAddress) public onlyOwner {
500         require(_tradeAddress != address(0));
501         tradeAddress = _tradeAddress;
502     }
503 
504     function transferTrade(address _from, address _to, uint256 _value) onlyTrade public returns (bool) {
505         _transfer(_from, _to, _value);
506         return true;
507     }
508 
509     function transfer(address _to, uint256 _value) public returns (bool) {
510         if (_to == tradeAddress) {
511             ITrade(tradeAddress).sellTokensFrom(msg.sender, _value);
512         } else {
513             _transfer(msg.sender, _to, _value);
514         }
515         return true;
516     }
517 }