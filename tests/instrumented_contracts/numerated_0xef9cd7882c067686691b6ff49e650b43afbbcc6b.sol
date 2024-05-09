1 pragma solidity 0.4.24;
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
26  * @dev Wrappers over Solidity's arithmetic operations with added overflow
27  * checks.
28  *
29  * Arithmetic operations in Solidity wrap on overflow. This can easily result
30  * in bugs, because programmers usually assume that an overflow raises an
31  * error, which is the standard behavior in high level programming languages.
32  * `SafeMath` restores this intuition by reverting the transaction when an
33  * operation overflows.
34  *
35  * Using this library instead of the unchecked operations eliminates an entire
36  * class of bugs, so it's recommended to use it always.
37  */
38 library SafeMath {
39     /**
40      * @dev Returns the addition of two unsigned integers, reverting on
41      * overflow.
42      *
43      * Counterpart to Solidity's `+` operator.
44      *
45      * Requirements:
46      *
47      * - Addition cannot overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, reverting on
58      * overflow (when the result is negative).
59      *
60      * Counterpart to Solidity's `-` operator.
61      *
62      * Requirements:
63      *
64      * - Subtraction cannot overflow.
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      *
78      * - Subtraction cannot overflow.
79      */
80     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the multiplication of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `*` operator.
92      *
93      * Requirements:
94      *
95      * - Multiplication cannot overflow.
96      */
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
99         // benefit is lost if 'b' is also tested.
100         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
101         if (a == 0) {
102             return 0;
103         }
104 
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         return div(a, b, "SafeMath: division by zero");
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b > 0, errorMessage);
141         uint256 c = a / b;
142         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return mod(a, b, "SafeMath: modulo by zero");
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts with custom message when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176         require(b != 0, errorMessage);
177         return a % b;
178     }
179 }
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
186  * Originally based on code by FirstBlood:
187  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  *
189  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
190  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
191  * compliant implementations may not do it.
192  */
193 contract ERC20 is IERC20 {
194 
195     using SafeMath for uint256;
196 
197     mapping (address => uint256) private _balances;
198 
199     mapping (address => mapping (address => uint256)) private _allowed;
200 
201     uint256 private _totalSupply;
202 
203     /**
204     * @dev Total number of tokens in existence
205     */
206     function totalSupply() public view returns (uint256) {
207         return _totalSupply;
208     }
209 
210     /**
211     * @dev Gets the balance of the specified address.
212     * @param owner The address to query the balance of.
213     * @return An uint256 representing the amount owned by the passed address.
214     */
215     function balanceOf(address owner) public view returns (uint256) {
216         return _balances[owner];
217     }
218 
219     /**
220      * @dev Function to check the amount of tokens that an owner allowed to a spender.
221      * @param owner address The address which owns the funds.
222      * @param spender address The address which will spend the funds.
223      * @return A uint256 specifying the amount of tokens still available for the spender.
224      */
225     function allowance(address owner, address spender) public view returns (uint256) {
226         return _allowed[owner][spender];
227     }
228 
229     /**
230     * @dev Transfer token for a specified address
231     * @param to The address to transfer to.
232     * @param value The amount to be transferred.
233     */
234     function transfer(address to, uint256 value) public returns (bool) {
235         _transfer(msg.sender, to, value);
236         return true;
237     }
238 
239     /**
240      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241      * Beware that changing an allowance with this method brings the risk that someone may use both the old
242      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245      * @param spender The address which will spend the funds.
246      * @param value The amount of tokens to be spent.
247      */
248     function approve(address spender, uint256 value) public returns (bool) {
249         require(spender != address(0));
250 
251         _allowed[msg.sender][spender] = value;
252         emit Approval(msg.sender, spender, value);
253         return true;
254     }
255 
256     /**
257      * @dev Transfer tokens from one address to another.
258      * Note that while this function emits an Approval event, this is not required as per the specification,
259      * and other compliant implementations may not emit the event.
260      * @param from address The address which you want to send tokens from
261      * @param to address The address which you want to transfer to
262      * @param value uint256 the amount of tokens to be transferred
263      */
264     function transferFrom(address from, address to, uint256 value) public returns (bool) {
265         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
266         _transfer(from, to, value);
267         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
268         return true;
269     }
270 
271     /**
272      * @dev Increase the amount of tokens that an owner allowed to a spender.
273      * approve should be called when allowed_[_spender] == 0. To increment
274      * allowed value is better to use this function to avoid 2 calls (and wait until
275      * the first transaction is mined)
276      * From MonolithDAO Token.sol
277      * Emits an Approval event.
278      * @param spender The address which will spend the funds.
279      * @param addedValue The amount of tokens to increase the allowance by.
280      */
281     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
282         require(spender != address(0));
283 
284         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
285         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
286         return true;
287     }
288 
289     /**
290      * @dev Decrease the amount of tokens that an owner allowed to a spender.
291      * approve should be called when allowed_[_spender] == 0. To decrement
292      * allowed value is better to use this function to avoid 2 calls (and wait until
293      * the first transaction is mined)
294      * From MonolithDAO Token.sol
295      * Emits an Approval event.
296      * @param spender The address which will spend the funds.
297      * @param subtractedValue The amount of tokens to decrease the allowance by.
298      */
299     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
300         require(spender != address(0));
301 
302         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
303         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
304         return true;
305     }
306 
307     /**
308     * @dev Transfer token for a specified addresses
309     * @param from The address to transfer from.
310     * @param to The address to transfer to.
311     * @param value The amount to be transferred.
312     */
313     function _transfer(address from, address to, uint256 value) internal {
314         require(to != address(0));
315 
316         _balances[from] = _balances[from].sub(value);
317         _balances[to] = _balances[to].add(value);
318         emit Transfer(from, to, value);
319     }
320 
321     /**
322      * @dev Internal function that mints an amount of the token and assigns it to
323      * an account. This encapsulates the modification of balances such that the
324      * proper events are emitted.
325      * @param account The account that will receive the created tokens.
326      * @param value The amount that will be created.
327      */
328     function _mint(address account, uint256 value) internal {
329         require(account != address(0));
330 
331         _totalSupply = _totalSupply.add(value);
332         _balances[account] = _balances[account].add(value);
333         emit Transfer(address(0), account, value);
334     }
335 
336     /**
337      * @dev Internal function that burns an amount of the token of a given
338      * account.
339      * @param account The account whose tokens will be burnt.
340      * @param value The amount that will be burnt.
341      */
342     function _burn(address account, uint256 value) internal {
343         require(account != address(0));
344 
345         _totalSupply = _totalSupply.sub(value);
346         _balances[account] = _balances[account].sub(value);
347         emit Transfer(account, address(0), value);
348     }
349 
350     /**
351      * @dev Internal function that burns an amount of the token of a given
352      * account, deducting from the sender's allowance for said account. Uses the
353      * internal burn function.
354      * Emits an Approval event (reflecting the reduced allowance).
355      * @param account The account whose tokens will be burnt.
356      * @param value The amount that will be burnt.
357      */
358     function _burnFrom(address account, uint256 value) internal {
359         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
360         _burn(account, value);
361         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
362     }
363 }
364 
365 
366 
367 
368 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
369 ///  later changed
370 contract Owned {
371 
372     /// @dev `owner` is the only address that can call a function with this
373     /// modifier
374     modifier onlyOwner() {
375         require(msg.sender == owner);
376         _;
377     }
378 
379     address public owner;
380 
381     /// @notice The Constructor assigns the message sender to be `owner`
382     constructor () public {
383         owner = msg.sender;
384     }
385 
386     address public newOwner;
387 
388     /// @notice `owner` can step down and assign some other address to this role
389     /// @param _newOwner The address of the new owner. 0x0 can be used to create
390     ///  an unowned neutral vault, however that cannot be undone
391     function changeOwner(address _newOwner) public onlyOwner {
392         newOwner = _newOwner;
393     }
394 
395 
396     function acceptOwnership() public {
397         if (msg.sender == newOwner) {
398             owner = newOwner;
399         }
400     }
401 }
402 
403 /**
404  * @dev Example of the ERC20 Token.
405  */
406 contract FnxToken is Owned, ERC20{
407     using SafeMath for uint;
408 
409     string private _name = "FinNexus";
410     string private _symbol = "FNX";
411 
412     uint8 private _decimals = 18;
413 
414     /// FinNexus total tokens supply
415     uint public MAX_TOTAL_TOKEN_AMOUNT = 500000000 ether;
416 
417     modifier maxWanTokenAmountNotReached (uint amount){
418     	  assert(totalSupply().add(amount) <= MAX_TOTAL_TOKEN_AMOUNT);
419     	  _;
420     }
421 
422     /**
423      * @return the name of the token.
424      */
425     function name() public view returns (string memory) {
426         return _name;
427     }
428 
429     /**
430      * @return the symbol of the token.
431      */
432     function symbol() public view returns (string memory) {
433         return _symbol;
434     }
435 
436     /**
437      * @return the number of decimals of the token.
438      */
439     function decimals() public view returns (uint8) {
440         return _decimals;
441     }
442 
443   /**
444      * EXTERNAL FUNCTION
445      *
446      * @dev change token name
447      * @param name token name
448      * @param symbol token symbol
449      *
450      */
451     function changeTokenName(string memory name, string memory symbol)
452         public
453         onlyOwner
454     {
455         //check parameter in ico minter contract
456         _name = name;
457         _symbol = symbol;
458     }
459 
460     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
461      * the total supply.
462      *
463      * Emits a {Transfer} event with `from` set to the zero address.
464      *
465      * Requirements
466      *
467      * - `to` cannot be the zero address.
468      */
469     function mint(address account, uint256 amount)
470         public
471         onlyOwner
472         maxWanTokenAmountNotReached(amount)
473     {
474         _mint(account,amount);
475     }
476 
477 
478 }