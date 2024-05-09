1 pragma solidity ^0.5.0;
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
25 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
26 
27 pragma solidity ^0.5.0;
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35     * @dev Multiplies two unsigned integers, reverts on overflow.
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53     */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Adds two unsigned integers, reverts on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85     * reverts when dividing by zero.
86     */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
94 
95 pragma solidity ^0.5.0;
96 
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
104  * Originally based on code by FirstBlood:
105  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  *
107  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
108  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
109  * compliant implementations may not do it.
110  */
111 contract ERC20 is IERC20 {
112     using SafeMath for uint256;
113 
114     mapping (address => uint256) private _balances;
115 
116     mapping (address => mapping (address => uint256)) private _allowed;
117 
118     uint256 private _totalSupply;
119 
120     /**
121     * @dev Total number of tokens in existence
122     */
123     function totalSupply() public view returns (uint256) {
124         return _totalSupply;
125     }
126 
127     /**
128     * @dev Gets the balance of the specified address.
129     * @param owner The address to query the balance of.
130     * @return An uint256 representing the amount owned by the passed address.
131     */
132     function balanceOf(address owner) public view returns (uint256) {
133         return _balances[owner];
134     }
135 
136     /**
137      * @dev Function to check the amount of tokens that an owner allowed to a spender.
138      * @param owner address The address which owns the funds.
139      * @param spender address The address which will spend the funds.
140      * @return A uint256 specifying the amount of tokens still available for the spender.
141      */
142     function allowance(address owner, address spender) public view returns (uint256) {
143         return _allowed[owner][spender];
144     }
145 
146     /**
147     * @dev Transfer token for a specified address
148     * @param to The address to transfer to.
149     * @param value The amount to be transferred.
150     */
151     function transfer(address to, uint256 value) public returns (bool) {
152         _transfer(msg.sender, to, value);
153         return true;
154     }
155 
156     /**
157      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158      * Beware that changing an allowance with this method brings the risk that someone may use both the old
159      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      * @param spender The address which will spend the funds.
163      * @param value The amount of tokens to be spent.
164      */
165     function approve(address spender, uint256 value) public returns (bool) {
166         require(spender != address(0));
167 
168         _allowed[msg.sender][spender] = value;
169         emit Approval(msg.sender, spender, value);
170         return true;
171     }
172 
173     /**
174      * @dev Transfer tokens from one address to another.
175      * Note that while this function emits an Approval event, this is not required as per the specification,
176      * and other compliant implementations may not emit the event.
177      * @param from address The address which you want to send tokens from
178      * @param to address The address which you want to transfer to
179      * @param value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(address from, address to, uint256 value) public returns (bool) {
182         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
183         _transfer(from, to, value);
184         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
185         return true;
186     }
187 
188     /**
189      * @dev Increase the amount of tokens that an owner allowed to a spender.
190      * approve should be called when allowed_[_spender] == 0. To increment
191      * allowed value is better to use this function to avoid 2 calls (and wait until
192      * the first transaction is mined)
193      * From MonolithDAO Token.sol
194      * Emits an Approval event.
195      * @param spender The address which will spend the funds.
196      * @param addedValue The amount of tokens to increase the allowance by.
197      */
198     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
199         require(spender != address(0));
200 
201         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
202         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
203         return true;
204     }
205 
206     /**
207      * @dev Decrease the amount of tokens that an owner allowed to a spender.
208      * approve should be called when allowed_[_spender] == 0. To decrement
209      * allowed value is better to use this function to avoid 2 calls (and wait until
210      * the first transaction is mined)
211      * From MonolithDAO Token.sol
212      * Emits an Approval event.
213      * @param spender The address which will spend the funds.
214      * @param subtractedValue The amount of tokens to decrease the allowance by.
215      */
216     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
217         require(spender != address(0));
218 
219         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
220         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
221         return true;
222     }
223 
224     /**
225     * @dev Transfer token for a specified addresses
226     * @param from The address to transfer from.
227     * @param to The address to transfer to.
228     * @param value The amount to be transferred.
229     */
230     function _transfer(address from, address to, uint256 value) internal {
231         require(to != address(0));
232 
233         _balances[from] = _balances[from].sub(value);
234         _balances[to] = _balances[to].add(value);
235         emit Transfer(from, to, value);
236     }
237 
238     /**
239      * @dev Internal function that mints an amount of the token and assigns it to
240      * an account. This encapsulates the modification of balances such that the
241      * proper events are emitted.
242      * @param account The account that will receive the created tokens.
243      * @param value The amount that will be created.
244      */
245     function _mint(address account, uint256 value) internal {
246         require(account != address(0));
247 
248         _totalSupply = _totalSupply.add(value);
249         _balances[account] = _balances[account].add(value);
250         emit Transfer(address(0), account, value);
251     }
252 
253     /**
254      * @dev Internal function that burns an amount of the token of a given
255      * account.
256      * @param account The account whose tokens will be burnt.
257      * @param value The amount that will be burnt.
258      */
259     function _burn(address account, uint256 value) internal {
260         require(account != address(0));
261 
262         _totalSupply = _totalSupply.sub(value);
263         _balances[account] = _balances[account].sub(value);
264         emit Transfer(account, address(0), value);
265     }
266 
267     /**
268      * @dev Internal function that burns an amount of the token of a given
269      * account, deducting from the sender's allowance for said account. Uses the
270      * internal burn function.
271      * Emits an Approval event (reflecting the reduced allowance).
272      * @param account The account whose tokens will be burnt.
273      * @param value The amount that will be burnt.
274      */
275     function _burnFrom(address account, uint256 value) internal {
276         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
277         _burn(account, value);
278         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
279     }
280 }
281 
282 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
283 
284 pragma solidity ^0.5.0;
285 
286 
287 /**
288  * @title ERC20Detailed token
289  * @dev The decimals are only for visualization purposes.
290  * All the operations are done using the smallest and indivisible token unit,
291  * just as on Ethereum all the operations are done in wei.
292  */
293 contract ERC20Detailed is IERC20 {
294     string private _name;
295     string private _symbol;
296     uint8 private _decimals;
297 
298     constructor (string memory name, string memory symbol, uint8 decimals) public {
299         _name = name;
300         _symbol = symbol;
301         _decimals = decimals;
302     }
303 
304     /**
305      * @return the name of the token.
306      */
307     function name() public view returns (string memory) {
308         return _name;
309     }
310 
311     /**
312      * @return the symbol of the token.
313      */
314     function symbol() public view returns (string memory) {
315         return _symbol;
316     }
317 
318     /**
319      * @return the number of decimals of the token.
320      */
321     function decimals() public view returns (uint8) {
322         return _decimals;
323     }
324 }
325 
326 // File: contracts/SMC.sol
327 
328 pragma solidity >=0.4.21 <0.6.0;
329 
330 
331 
332 contract SMC is ERC20, ERC20Detailed {
333     uint8 public constant DECIMALS = 18;
334     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(DECIMALS));
335 
336     /**
337      * @dev Constructor that gives msg.sender all of existing tokens.
338      */
339     constructor () public ERC20Detailed("SMC", "SMC", DECIMALS) {
340         _mint(msg.sender, INITIAL_SUPPLY);
341     }
342 }