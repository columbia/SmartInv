1 pragma solidity ^0.4.2;
2 
3 //  import "./IERC20.sol"; 
4 //  import "./SafeMath.sol";
5 
6 pragma solidity ^0.4.2;
7 
8 /**
9 * @title SafeMath
10 * @dev Unsigned math operations with safety checks that revert on error
11 */
12 
13 library SafeMath {
14    /**
15    * @dev Multiplies two unsigned integers, reverts on overflow.
16    */
17    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19        // benefit is lost if 'b' is also tested.
20        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21        if (a == 0) {
22            return 0;
23        }
24 
25        uint256 c = a * b;
26        require(c / a == b);
27 
28        return c;
29    }
30 
31    /**
32    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
33    */
34    function div(uint256 a, uint256 b) internal pure returns (uint256) {
35        // Solidity only automatically asserts when dividing by 0
36        require(b > 0);
37        uint256 c = a / b;
38        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 
40        return c;
41    }
42 
43    /**
44    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
45    */
46    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47        require(b <= a);
48        uint256 c = a - b;
49 
50        return c;
51    }
52 
53    /**
54    * @dev Adds two unsigned integers, reverts on overflow.
55    */
56    function add(uint256 a, uint256 b) internal pure returns (uint256) {
57        uint256 c = a + b;
58        require(c >= a);
59 
60        return c;
61    }
62 
63    /**
64    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
65    * reverts when dividing by zero.
66    */
67    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68        require(b != 0);
69        return a % b;
70    }
71 }
72 interface IERC20 {
73    function transfer(address to, uint256 value) external returns (bool);
74 
75    function approve(address spender, uint256 value) external returns (bool);
76 
77    function transferFrom(address from, address to, uint256 value) external returns (bool);
78 
79    function totalSupply() external view returns (uint256);
80 
81    function balanceOf(address who) external view returns (uint256);
82 
83    function allowance(address owner, address spender) external view returns (uint256);
84 
85    event Transfer(address indexed from, address indexed to, uint256 value);
86 
87    event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 contract ERC20 is IERC20 {
90    using SafeMath for uint256;
91 
92    mapping (address => uint256) private _balances;
93 
94    mapping (address => mapping (address => uint256)) private _allowed;
95 
96    uint256 private _totalSupply;
97 
98    /**
99    * @dev Total number of tokens in existence
100    */
101    function totalSupply() public view returns (uint256) {
102        return _totalSupply;
103    }
104 
105    /**
106    * @dev Gets the balance of the specified address.
107    * @param owner The address to query the balance of.
108    * @return An uint256 representing the amount owned by the passed address.
109    */
110    function balanceOf(address owner) public view returns (uint256) {
111        return _balances[owner];
112    }
113 
114    /**
115     * @dev Function to check the amount of tokens that an owner allowed to a spender.
116     * @param owner address The address which owns the funds.
117     * @param spender address The address which will spend the funds.
118     * @return A uint256 specifying the amount of tokens still available for the spender.
119     */
120    function allowance(address owner, address spender) public view returns (uint256) {
121        return _allowed[owner][spender];
122    }
123 
124    /**
125    * @dev Transfer token for a specified address
126    * @param to The address to transfer to.
127    * @param value The amount to be transferred.
128    */
129    function transfer(address to, uint256 value) public returns (bool) {
130        _transfer(msg.sender, to, value);
131        return true;
132    }
133 
134    /**
135     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136     * Beware that changing an allowance with this method brings the risk that someone may use both the old
137     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140     * @param spender The address which will spend the funds.
141     * @param value The amount of tokens to be spent.
142     */
143    function approve(address spender, uint256 value) public returns (bool) {
144        require(spender != address(0));
145 
146        _allowed[msg.sender][spender] = value;
147        emit Approval(msg.sender, spender, value);
148        return true;
149    }
150 
151    /**
152     * @dev Transfer tokens from one address to another.
153     * Note that while this function emits an Approval event, this is not required as per the specification,
154     * and other compliant implementations may not emit the event.
155     * @param from address The address which you want to send tokens from
156     * @param to address The address which you want to transfer to
157     * @param value uint256 the amount of tokens to be transferred
158     */
159    function transferFrom(address from, address to, uint256 value) public returns (bool) {
160        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
161        _transfer(from, to, value);
162        emit Approval(from, msg.sender, _allowed[from][msg.sender]);
163        return true;
164    }
165 
166    /**
167     * @dev Increase the amount of tokens that an owner allowed to a spender.
168     * approve should be called when allowed_[_spender] == 0. To increment
169     * allowed value is better to use this function to avoid 2 calls (and wait until
170     * the first transaction is mined)
171     * From MonolithDAO Token.sol
172     * Emits an Approval event.
173     * @param spender The address which will spend the funds.
174     * @param addedValue The amount of tokens to increase the allowance by.
175     */
176    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
177        require(spender != address(0));
178 
179        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
180        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
181        return true;
182    }
183 
184    /**
185     * @dev Decrease the amount of tokens that an owner allowed to a spender.
186     * approve should be called when allowed_[_spender] == 0. To decrement
187     * allowed value is better to use this function to avoid 2 calls (and wait until
188     * the first transaction is mined)
189     * From MonolithDAO Token.sol
190     * Emits an Approval event.
191     * @param spender The address which will spend the funds.
192     * @param subtractedValue The amount of tokens to decrease the allowance by.
193     */
194    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
195        require(spender != address(0));
196 
197        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
198        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199        return true;
200    }
201 
202    /**
203    * @dev Transfer token for a specified addresses
204    * @param from The address to transfer from.
205    * @param to The address to transfer to.
206    * @param value The amount to be transferred.
207    */
208    function _transfer(address from, address to, uint256 value) internal {
209        require(to != address(0));
210 
211        _balances[from] = _balances[from].sub(value);
212        _balances[to] = _balances[to].add(value);
213        emit Transfer(from, to, value);
214    }
215 
216    /**
217     * @dev Internal function that mints an amount of the token and assigns it to
218     * an account. This encapsulates the modification of balances such that the
219     * proper events are emitted.
220     * @param account The account that will receive the created tokens.
221     * @param value The amount that will be created.
222     */
223    function _mint(address account, uint256 value) internal {
224        require(account != address(0));
225 
226        _totalSupply = _totalSupply.add(value);
227        _balances[account] = _balances[account].add(value);
228        emit Transfer(address(0), account, value);
229    }
230 
231    /**
232     * @dev Internal function that burns an amount of the token of a given
233     * account.
234     * @param account The account whose tokens will be burnt.
235     * @param value The amount that will be burnt.
236     */
237    function _burn(address account, uint256 value) internal {
238        require(account != address(0));
239 
240        _totalSupply = _totalSupply.sub(value);
241        _balances[account] = _balances[account].sub(value);
242        emit Transfer(account, address(0), value);
243    }
244 
245    /**
246     * @dev Internal function that burns an amount of the token of a given
247     * account, deducting from the sender's allowance for said account. Uses the
248     * internal burn function.
249     * Emits an Approval event (reflecting the reduced allowance).
250     * @param account The account whose tokens will be burnt.
251     * @param value The amount that will be burnt.
252     */
253    function _burnFrom(address account, uint256 value) internal {
254        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
255        _burn(account, value);
256        emit Approval(account, msg.sender, _allowed[account][msg.sender]);
257    }
258 }
259 
260 pragma solidity ^0.4.2;
261 
262 // import "./IERC20.sol";
263 
264 
265 
266 /**
267 * @title ERC20Detailed token
268 * @dev The decimals are only for visualization purposes.
269 * All the operations are done using the smallest and indivisible token unit,
270 * just as on Ethereum all the operations are done in wei.
271 */
272 contract ERC20Detailed is IERC20 {
273    string private _name;
274    string private _symbol;
275    uint8 private _decimals;
276 
277    constructor (string memory name, string memory symbol, uint8 decimals) public {
278        _name = name;
279        _symbol = symbol;
280        _decimals = decimals;
281    }
282 
283    /**
284     * @return the name of the token.
285     */
286    function name() public view returns (string memory) {
287        return _name;
288    }
289 
290    /**
291     * @return the symbol of the token.
292     */
293    function symbol() public view returns (string memory) {
294        return _symbol;
295    }
296 
297    /**
298     * @return the number of decimals of the token.
299     */
300    function decimals() public view returns (uint8) {
301        return _decimals;
302    }
303 }
304 pragma solidity ^0.4.2;
305 
306 // import "./ERC20.sol";
307 
308 /**
309 * @title Burnable Token
310 * @dev Token that can be irreversibly burned (destroyed).
311 */
312 contract ERC20Burnable is ERC20 {
313    /**
314     * @dev Burns a specific amount of tokens.
315     * @param value The amount of token to be burned.
316     */
317    function burn(uint256 value) public {
318        _burn(msg.sender, value);
319    }
320 
321    /**
322     * @dev Burns a specific amount of tokens from the target address and decrements allowance
323     * @param from address The address which you want to send tokens from
324     * @param value uint256 The amount of token to be burned
325     */
326    function burnFrom(address from, uint256 value) public {
327        _burnFrom(from, value);
328    }
329 }
330 pragma solidity ^0.4.2;
331 
332 /**
333 * @title ERC20 interface
334 * @dev see https://github.com/ethereum/EIPs/issues/20
335 */
336 pragma solidity ^0.4.2;
337 
338 // import "./ERC20.sol";
339 // import "./ERC20Detailed.sol";
340 // import "./ERC20Burnable.sol";
341 
342 
343 contract BettingGameZone is ERC20, ERC20Detailed, ERC20Burnable {
344    uint8 public constant DECIMALS = 18;
345    uint256 public constant INITIAL_SUPPLY = 150000000 * (10 ** uint256(DECIMALS));
346 
347    /**
348     * @dev Constructor that gives msg.sender all of existing tokens.
349     */
350    constructor () public ERC20Detailed("BettingGameZone", "BGZ", 18) {
351        _mint(msg.sender, INITIAL_SUPPLY);
352    }
353 }