1 // Verified using https://dapp.tools
2 // hevm: flattened sources of contracts/Melon.sol
3 pragma solidity ^0.4.24;
4 
5 ////// contracts/openzeppelin/IERC20.sol
6 /* pragma solidity ^0.4.24; */
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/20
11  */
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     function transfer(address to, uint256 value) external returns (bool);
20 
21     function approve(address spender, uint256 value) external returns (bool);
22 
23     function transferFrom(address from, address to, uint256 value) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 ////// contracts/openzeppelin/SafeMath.sol
31 /* pragma solidity ^0.4.24; */
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that revert on error
36  */
37 library SafeMath {
38     int256 constant private INT256_MIN = -2**255;
39 
40     /**
41     * @dev Multiplies two unsigned integers, reverts on overflow.
42     */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
45         // benefit is lost if 'b' is also tested.
46         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47         if (a == 0) {
48             return 0;
49         }
50 
51         uint256 c = a * b;
52         require(c / a == b);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Multiplies two signed integers, reverts on overflow.
59     */
60     function mul(int256 a, int256 b) internal pure returns (int256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
69 
70         int256 c = a * b;
71         require(c / a == b);
72 
73         return c;
74     }
75 
76     /**
77     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
78     */
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Solidity only automatically asserts when dividing by 0
81         require(b > 0);
82         uint256 c = a / b;
83         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84 
85         return c;
86     }
87 
88     /**
89     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
90     */
91     function div(int256 a, int256 b) internal pure returns (int256) {
92         require(b != 0); // Solidity only automatically asserts when dividing by 0
93         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
94 
95         int256 c = a / b;
96 
97         return c;
98     }
99 
100     /**
101     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
102     */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a);
105         uint256 c = a - b;
106 
107         return c;
108     }
109 
110     /**
111     * @dev Subtracts two signed integers, reverts on overflow.
112     */
113     function sub(int256 a, int256 b) internal pure returns (int256) {
114         int256 c = a - b;
115         require((b >= 0 && c <= a) || (b < 0 && c > a));
116 
117         return c;
118     }
119 
120     /**
121     * @dev Adds two unsigned integers, reverts on overflow.
122     */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a);
126 
127         return c;
128     }
129 
130     /**
131     * @dev Adds two signed integers, reverts on overflow.
132     */
133     function add(int256 a, int256 b) internal pure returns (int256) {
134         int256 c = a + b;
135         require((b >= 0 && c >= a) || (b < 0 && c < a));
136 
137         return c;
138     }
139 
140     /**
141     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
142     * reverts when dividing by zero.
143     */
144     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145         require(b != 0);
146         return a % b;
147     }
148 }
149 
150 ////// contracts/openzeppelin/ERC20.sol
151 /* pragma solidity ^0.4.24; */
152 
153 /* import "./IERC20.sol"; */
154 /* import "./SafeMath.sol"; */
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
161  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  *
163  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
164  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
165  * compliant implementations may not do it.
166  */
167 contract ERC20 is IERC20 {
168     using SafeMath for uint256;
169 
170     mapping (address => uint256) private _balances;
171 
172     mapping (address => mapping (address => uint256)) private _allowed;
173 
174     uint256 private _totalSupply;
175 
176     /**
177     * @dev Total number of tokens in existence
178     */
179     function totalSupply() public view returns (uint256) {
180         return _totalSupply;
181     }
182 
183     /**
184     * @dev Gets the balance of the specified address.
185     * @param owner The address to query the balance of.
186     * @return An uint256 representing the amount owned by the passed address.
187     */
188     function balanceOf(address owner) public view returns (uint256) {
189         return _balances[owner];
190     }
191 
192     /**
193      * @dev Function to check the amount of tokens that an owner allowed to a spender.
194      * @param owner address The address which owns the funds.
195      * @param spender address The address which will spend the funds.
196      * @return A uint256 specifying the amount of tokens still available for the spender.
197      */
198     function allowance(address owner, address spender) public view returns (uint256) {
199         return _allowed[owner][spender];
200     }
201 
202     /**
203     * @dev Transfer token for a specified address
204     * @param to The address to transfer to.
205     * @param value The amount to be transferred.
206     */
207     function transfer(address to, uint256 value) public returns (bool) {
208         _transfer(msg.sender, to, value);
209         return true;
210     }
211 
212     /**
213      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214      * Beware that changing an allowance with this method brings the risk that someone may use both the old
215      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      * @param spender The address which will spend the funds.
219      * @param value The amount of tokens to be spent.
220      */
221     function approve(address spender, uint256 value) public returns (bool) {
222         require(spender != address(0));
223 
224         _allowed[msg.sender][spender] = value;
225         emit Approval(msg.sender, spender, value);
226         return true;
227     }
228 
229     /**
230      * @dev Transfer tokens from one address to another.
231      * Note that while this function emits an Approval event, this is not required as per the specification,
232      * and other compliant implementations may not emit the event.
233      * @param from address The address which you want to send tokens from
234      * @param to address The address which you want to transfer to
235      * @param value uint256 the amount of tokens to be transferred
236      */
237     function transferFrom(address from, address to, uint256 value) public returns (bool) {
238         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
239         _transfer(from, to, value);
240         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
241         return true;
242     }
243 
244     /**
245      * @dev Increase the amount of tokens that an owner allowed to a spender.
246      * approve should be called when allowed_[_spender] == 0. To increment
247      * allowed value is better to use this function to avoid 2 calls (and wait until
248      * the first transaction is mined)
249      * From MonolithDAO Token.sol
250      * Emits an Approval event.
251      * @param spender The address which will spend the funds.
252      * @param addedValue The amount of tokens to increase the allowance by.
253      */
254     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
255         require(spender != address(0));
256 
257         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
258         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
259         return true;
260     }
261 
262     /**
263      * @dev Decrease the amount of tokens that an owner allowed to a spender.
264      * approve should be called when allowed_[_spender] == 0. To decrement
265      * allowed value is better to use this function to avoid 2 calls (and wait until
266      * the first transaction is mined)
267      * From MonolithDAO Token.sol
268      * Emits an Approval event.
269      * @param spender The address which will spend the funds.
270      * @param subtractedValue The amount of tokens to decrease the allowance by.
271      */
272     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
273         require(spender != address(0));
274 
275         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
276         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
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
324      * @dev Internal function that burns an amount of the token of a given
325      * account, deducting from the sender's allowance for said account. Uses the
326      * internal burn function.
327      * Emits an Approval event (reflecting the reduced allowance).
328      * @param account The account whose tokens will be burnt.
329      * @param value The amount that will be burnt.
330      */
331     function _burnFrom(address account, uint256 value) internal {
332         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
333         _burn(account, value);
334         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
335     }
336 }
337 
338 ////// contracts/openzeppelin/ERC20Burnable.sol
339 /* pragma solidity ^0.4.24; */
340 
341 /* import "./ERC20.sol"; */
342 
343 /**
344  * @title Burnable Token
345  * @dev Token that can be irreversibly burned (destroyed).
346  */
347 contract ERC20Burnable is ERC20 {
348     /**
349      * @dev Burns a specific amount of tokens.
350      * @param value The amount of token to be burned.
351      */
352     function burn(uint256 value) public {
353         _burn(msg.sender, value);
354     }
355 
356     /**
357      * @dev Burns a specific amount of tokens from the target address and decrements allowance
358      * @param from address The address which you want to send tokens from
359      * @param value uint256 The amount of token to be burned
360      */
361     function burnFrom(address from, uint256 value) public {
362         _burnFrom(from, value);
363     }
364 }
365 
366 ////// contracts/openzeppelin/ERC20Detailed.sol
367 /* pragma solidity ^0.4.24; */
368 
369 /* import "./IERC20.sol"; */
370 
371 /**
372  * @title ERC20Detailed token
373  * @dev The decimals are only for visualization purposes.
374  * All the operations are done using the smallest and indivisible token unit,
375  * just as on Ethereum all the operations are done in wei.
376  */
377 contract ERC20Detailed is IERC20 {
378     string private _name;
379     string private _symbol;
380     uint8 private _decimals;
381 
382     constructor (string name, string symbol, uint8 decimals) public {
383         _name = name;
384         _symbol = symbol;
385         _decimals = decimals;
386     }
387 
388     /**
389      * @return the name of the token.
390      */
391     function name() public view returns (string) {
392         return _name;
393     }
394 
395     /**
396      * @return the symbol of the token.
397      */
398     function symbol() public view returns (string) {
399         return _symbol;
400     }
401 
402     /**
403      * @return the number of decimals of the token.
404      */
405     function decimals() public view returns (uint8) {
406         return _decimals;
407     }
408 }
409 
410 ////// contracts/Melon.sol
411 /* pragma solidity ^0.4.24; */
412 
413 /* import "./openzeppelin/ERC20Burnable.sol"; */
414 /* import "./openzeppelin/ERC20Detailed.sol"; */
415 /* import "./openzeppelin/SafeMath.sol"; */
416 
417 contract Melon is ERC20Burnable, ERC20Detailed {
418     using SafeMath for uint;
419 
420     uint public constant BASE_UNITS = 10 ** 18;
421     uint public constant INFLATION_ENABLE_DATE = 1551398400;
422     uint public constant INITIAL_TOTAL_SUPPLY = uint(932613).mul(BASE_UNITS);
423     uint public constant YEARLY_MINTABLE_AMOUNT = uint(300600).mul(BASE_UNITS);
424     uint public constant MINTING_INTERVAL = 365 days;
425 
426     address public council;
427     address public deployer;
428     bool public initialSupplyMinted;
429     uint public nextMinting = INFLATION_ENABLE_DATE;
430 
431     modifier onlyDeployer {
432         require(msg.sender == deployer, "Only deployer can call this");
433         _;
434     }
435 
436     modifier onlyCouncil {
437         require(msg.sender == council, "Only council can call this");
438         _;
439     }
440 
441     modifier anIntervalHasPassed {
442         require(
443             block.timestamp >= uint(nextMinting),
444             "Please wait until an interval has passed"
445         );
446         _;
447     }
448 
449     modifier inflationEnabled {
450         require(
451             block.timestamp >= INFLATION_ENABLE_DATE,
452             "Inflation is not enabled yet"
453         );
454         _;
455     }
456 
457     constructor(
458         string _name,
459         string _symbol,
460         uint8 _decimals,
461         address _council
462     ) public ERC20Detailed(_name, _symbol, _decimals) {
463         deployer = msg.sender;
464         council = _council;
465     }
466 
467     function changeCouncil(address _newCouncil) public onlyCouncil {
468         council = _newCouncil;
469     }
470 
471     function mintInitialSupply(address _initialReceiver) public onlyDeployer {
472         require(!initialSupplyMinted, "Initial minting already complete");
473         initialSupplyMinted = true;
474         _mint(_initialReceiver, INITIAL_TOTAL_SUPPLY);
475     }
476 
477     function mintInflation() public anIntervalHasPassed inflationEnabled {
478         require(initialSupplyMinted, "Initial minting not complete");
479         nextMinting = uint(nextMinting).add(MINTING_INTERVAL);
480         _mint(council, YEARLY_MINTABLE_AMOUNT);
481     }
482 }
