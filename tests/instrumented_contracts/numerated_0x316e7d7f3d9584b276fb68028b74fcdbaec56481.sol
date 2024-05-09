1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
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
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
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
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 /**
59  * @title ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 interface IERC20 {
63     function totalSupply() external view returns (uint256);
64 
65     function balanceOf(address who) external view returns (uint256);
66 
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     function transfer(address to, uint256 value) external returns (bool);
70 
71     function approve(address spender, uint256 value) external returns (bool);
72 
73     function transferFrom(address from, address to, uint256 value) external returns (bool);
74 
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * @title Standard ERC20 token
82  *
83  * @dev Implementation of the basic standard token.
84  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
85  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
86  *
87  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
88  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
89  * compliant implementations may not do it.
90  */
91 contract ERC20 is IERC20 {
92     using SafeMath for uint256;
93 
94     mapping(address => uint256) private _balances;
95 
96     mapping(address => mapping(address => uint256)) private _allowed;
97 
98     uint256 private _totalSupply;
99 
100     /**
101     * @dev Total number of tokens in existence
102     */
103     function totalSupply() public view returns (uint256) {
104         return _totalSupply;
105     }
106 
107     /**
108     * @dev Gets the balance of the specified address.
109     * @param owner The address to query the balance of.
110     * @return An uint256 representing the amount owned by the passed address.
111     */
112     function balanceOf(address owner) public view returns (uint256) {
113         return _balances[owner];
114     }
115 
116     /**
117      * @dev Function to check the amount of tokens that an owner allowed to a spender.
118      * @param owner address The address which owns the funds.
119      * @param spender address The address which will spend the funds.
120      * @return A uint256 specifying the amount of tokens still available for the spender.
121      */
122     function allowance(address owner, address spender) public view returns (uint256) {
123         return _allowed[owner][spender];
124     }
125 
126     /**
127      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128      * Beware that changing an allowance with this method brings the risk that someone may use both the old
129      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      * @param spender The address which will spend the funds.
133      * @param value The amount of tokens to be spent.
134      */
135     function approve(address spender, uint256 value) public returns (bool) {
136         require(spender != address(0));
137         require((value == 0) || (_allowed[msg.sender][spender] == 0));
138 
139         _allowed[msg.sender][spender] = value;
140         emit Approval(msg.sender, spender, value);
141         return true;
142     }
143 
144     /**
145      * @dev Transfer tokens from one address to another.
146      * Note that while this function emits an Approval event, this is not required as per the specification,
147      * and other compliant implementations may not emit the event.
148      * @param from address The address which you want to send tokens from
149      * @param to address The address which you want to transfer to
150      * @param value uint256 the amount of tokens to be transferred
151      */
152     function transferFrom(address from, address to, uint256 value) public returns (bool) {
153         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
154         _transfer(from, to, value);
155         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
156         return true;
157     }
158 
159     /**
160      * @dev Increase the amount of tokens that an owner allowed to a spender.
161      * approve should be called when allowed_[_spender] == 0. To increment
162      * allowed value is better to use this function to avoid 2 calls (and wait until
163      * the first transaction is mined)
164      * From MonolithDAO Token.sol
165      * Emits an Approval event.
166      * @param spender The address which will spend the funds.
167      * @param addedValue The amount of tokens to increase the allowance by.
168      */
169     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
170         require(spender != address(0));
171 
172         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
173         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
174         return true;
175     }
176 
177     /**
178      * @dev Decrease the amount of tokens that an owner allowed to a spender.
179      * approve should be called when allowed_[_spender] == 0. To decrement
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      * Emits an Approval event.
184      * @param spender The address which will spend the funds.
185      * @param subtractedValue The amount of tokens to decrease the allowance by.
186      */
187     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
188         require(spender != address(0));
189 
190         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
191         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
192         return true;
193     }
194 
195     /**
196     * @dev Transfer token for a specified addresses
197     * @param from The address to transfer from.
198     * @param to The address to transfer to.
199     * @param value The amount to be transferred.
200     */
201     function _transfer(address from, address to, uint256 value) internal {
202         require(to != address(0));
203 
204         _balances[from] = _balances[from].sub(value);
205         _balances[to] = _balances[to].add(value);
206         emit Transfer(from, to, value);
207     }
208 
209     /**
210      * @dev Internal function that mints an amount of the token and assigns it to
211      * an account. This encapsulates the modification of balances such that the
212      * proper events are emitted.
213      * @param account The account that will receive the created tokens.
214      * @param value The amount that will be created.
215      */
216     function _mint(address account, uint256 value) internal {
217         require(account != address(0));
218 
219         _totalSupply = _totalSupply.add(value);
220         _balances[account] = _balances[account].add(value);
221         emit Transfer(address(0), account, value);
222     }
223 
224     /**
225      * @dev Internal function that burns an amount of the token of a given
226      * account.
227      * @param account The account whose tokens will be burnt.
228      * @param value The amount that will be burnt.
229      */
230     function _burn(address account, uint256 value) internal {
231         require(account != address(0));
232 
233         _totalSupply = _totalSupply.sub(value);
234         _balances[account] = _balances[account].sub(value);
235         emit Transfer(account, address(0), value);
236     }
237 
238     /**
239      * @dev Internal function that burns an amount of the token of a given
240      * account, deducting from the sender's allowance for said account. Uses the
241      * internal burn function.
242      * Emits an Approval event (reflecting the reduced allowance).
243      * @param account The account whose tokens will be burnt.
244      * @param value The amount that will be burnt.
245      */
246     function _burnFrom(address account, uint256 value) internal {
247         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
248         _burn(account, value);
249         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
250     }
251 }
252 
253 /**
254  * @title Ownable
255  * @dev The Ownable contract has an owner address, and provides basic authorization control
256  * functions, this simplifies the implementation of "user permissions".
257  */
258 contract Ownable {
259     address private _owner;
260 
261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
262 
263     /**
264      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265      * account.
266      */
267     constructor () internal {
268         _owner = msg.sender;
269         emit OwnershipTransferred(address(0), _owner);
270     }
271 
272     /**
273      * @return the address of the owner.
274      */
275     function owner() public view returns (address) {
276         return _owner;
277     }
278 
279     /**
280      * @dev Throws if called by any account other than the owner.
281      */
282     modifier onlyOwner() {
283         require(isOwner());
284         _;
285     }
286 
287     /**
288      * @return true if `msg.sender` is the owner of the contract.
289      */
290     function isOwner() public view returns (bool) {
291         return msg.sender == _owner;
292     }
293 
294     /**
295      * @dev Allows the current owner to transfer control of the contract to a newOwner.
296      * @param newOwner The address to transfer ownership to.
297      */
298     function transferOwnership(address newOwner) public onlyOwner {
299         _transferOwnership(newOwner);
300     }
301 
302     /**
303      * @dev Transfers control of the contract to a newOwner.
304      * @param newOwner The address to transfer ownership to.
305      */
306     function _transferOwnership(address newOwner) internal {
307         require(newOwner != address(0));
308         emit OwnershipTransferred(_owner, newOwner);
309         _owner = newOwner;
310     }
311 }
312 
313 /**
314  * @title ERC20Detailed token
315  * @dev The decimals are only for visualization purposes.
316  * All the operations are done using the smallest and indivisible token unit,
317  * just as on Ethereum all the operations are done in wei.
318  */
319 contract ERC20Detailed is ERC20, Ownable {
320     string private _name = 'Bitcoin Short';
321     string private _symbol = 'BSHORT';
322     uint8 private _decimals = 18;
323 
324     /**
325      * @return the name of the token.
326      */
327     function name() public view returns (string) {
328         return _name;
329     }
330 
331     /**
332      * @return the symbol of the token.
333      */
334     function symbol() public view returns (string) {
335         return _symbol;
336     }
337 
338     /**
339      * @return the number of decimals of the token.
340      */
341     function decimals() public view returns (uint8) {
342         return _decimals;
343     }
344 
345     /**
346      * @dev Burns a specific amount of tokens.
347      * @param value The amount of token to be burned.
348      */
349     function burn(uint256 value) public {
350         _burn(msg.sender, value);
351     }
352 
353     /**
354      * @dev Burns a specific amount of tokens from the target address and decrements allowance
355      * @param from address The address which you want to send tokens from
356      * @param value uint256 The amount of token to be burned
357      */
358     function burnFrom(address from, uint256 value) public {
359         _burnFrom(from, value);
360     }
361 }
362 
363 interface ITrade {
364     function contractBuyTokensFrom(address from, uint amount) external;
365 
366     function isOwner(address user) external view returns (bool);
367 }
368 
369 contract BSHORT is ERC20Detailed {
370     using SafeMath for uint256;
371 
372     bool public isPaused = false;
373     uint256 private DEC = 1000000000000000000;
374     address public tradeAddress;
375     // how many ETH cost 1000 BSHORT. rate = 1000 BSHORT/ETH. It's always an integer!
376     // formula for rate: rate = 1000 * (BSHORT in USD) / (ETH in USD)
377     uint256 public rate = 10;
378     uint public minimumSupply = 1;
379     uint public hardCap = 9000000000 * DEC;
380 
381     event TokenPurchase(address purchaser, uint256 value, uint256 amount, uint integer_amount, uint256 tokensMinted);
382     event TokenIssue(address purchaser, uint256 amount, uint integer_amount, uint256 tokensMinted);
383 
384     modifier onlyTrade() {
385         require(msg.sender == tradeAddress);
386         _;
387     }
388 
389     function pauseCrowdSale() public onlyOwner {
390         require(isPaused == false);
391         isPaused = true;
392     }
393 
394     function startCrowdSale() public onlyOwner {
395         require(isPaused == true);
396         isPaused = false;
397     }
398 
399     function setRate(uint _rate) public onlyOwner {
400         require(_rate > 0);
401         require(_rate <= 1000);
402         rate = _rate;
403     }
404 
405     function buyTokens() public payable {
406         require(!isPaused);
407 
408         uint256 weiAmount = msg.value;
409         uint256 tokens = weiAmount.mul(1000).div(rate);
410 
411         require(tokens >= minimumSupply * DEC);
412         require(totalSupply().add(tokens) <= hardCap);
413 
414         _mint(msg.sender, tokens);
415         owner().transfer(msg.value);
416 
417         emit TokenPurchase(msg.sender, weiAmount, tokens, tokens.div(DEC), totalSupply().div(DEC));
418     }
419 
420     function IssueTokens(address account, uint256 value) public onlyOwner {
421         uint tokens = value * DEC;
422 
423         require(totalSupply().add(tokens) <= hardCap);
424 
425         _mint(account, tokens);
426 
427         emit TokenIssue(account, tokens, value, totalSupply().div(DEC));
428     }
429 
430     function() external payable {
431         buyTokens();
432     }
433 
434     function setTradeAddress(address _tradeAddress) public onlyOwner {
435         require(_tradeAddress != address(0));
436         tradeAddress = _tradeAddress;
437     }
438 
439     function transferTrade(address _from, address _to, uint256 _value) onlyTrade public returns (bool) {
440         _transfer(_from, _to, _value);
441         return true;
442     }
443 
444     function transfer(address _to, uint256 _value) public returns (bool) {
445         if (_to == tradeAddress) {
446             ITrade(tradeAddress).contractBuyTokensFrom(msg.sender, _value);
447         } else {
448             _transfer(msg.sender, _to, _value);
449         }
450         return true;
451     }
452 }