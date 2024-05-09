1 pragma solidity ^0.5.1;
2 /**
3 * this is the official contract deployed for XLG token 
4 * all code is pulled from the open-zeplin github and then flattened into one file. 
5 */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that revert on error
10  */
11 library SafeMath {
12     /**
13     * @dev Multiplies two numbers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52     * @dev Adds two numbers, reverts on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
63     * reverts when dividing by zero.
64     */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 interface IERC20 {
76     function totalSupply() external view returns (uint256);
77 
78     function balanceOf(address who) external view returns (uint256);
79 
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     function transfer(address to, uint256 value) external returns (bool);
83 
84     function approve(address spender, uint256 value) external returns (bool);
85 
86     function transferFrom(address from, address to, uint256 value) external returns (bool);
87 
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  * @dev Implementation of the basic standard token.
96  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
97  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  *
99  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
100  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
101  * compliant implementations may not do it.
102  */
103 contract ERC20 is IERC20 {
104     using SafeMath for uint256;
105     mapping (address => uint256) private _balances;
106 
107     mapping (address => mapping (address => uint256)) private _allowed;
108 
109     uint256 private _totalSupply;
110     string private _name;
111     string private _symbol;
112     uint8 private _decimals;
113 
114     constructor (string memory name, string memory symbol, uint8 decimals) public {
115         _name = name;
116         _symbol = symbol;
117         _decimals = decimals;
118     }
119 
120     /**
121      * @return the name of the token.
122      */
123     function name() public view returns (string memory) {
124         return _name;
125     }
126 
127     /**
128      * @return the symbol of the token.
129      */
130     function symbol() public view returns (string memory) {
131         return _symbol;
132     }
133 
134     /**
135      * @return the number of decimals of the token.
136      */
137     function decimals() public view returns (uint8) {
138         return _decimals;
139     }
140 
141     /**
142     * @dev Total number of tokens in existence
143     */
144     function totalSupply() public view returns (uint256) {
145         return _totalSupply;
146     }
147 
148     /**
149     * @dev Gets the balance of the specified address.
150     * @param owner The address to query the balance of.
151     * @return An uint256 representing the amount owned by the passed address.
152     */
153     function balanceOf(address owner) public view returns (uint256) {
154         return _balances[owner];
155     }
156 
157     /**
158      * @dev Function to check the amount of tokens that an owner allowed to a spender.
159      * @param owner address The address which owns the funds.
160      * @param spender address The address which will spend the funds.
161      * @return A uint256 specifying the amount of tokens still available for the spender.
162      */
163     function allowance(address owner, address spender) public view returns (uint256) {
164         return _allowed[owner][spender];
165     }
166 
167     /**
168     * @dev Transfer token for a specified address
169     * @param to The address to transfer to.
170     * @param value The amount to be transferred.
171     */
172     function transfer(address to, uint256 value) public returns (bool) {
173         _transfer(msg.sender, to, value);
174         return true;
175     }
176 
177     /**
178     * @dev Token that can be irreversibly burned (destroyed).
179     */
180     function burn(uint256 value) public {
181         _burn(msg.sender, value);
182     }
183 
184     /**
185      * @dev Burns a specific amount of tokens from the target address and decrements allowance
186      * @param from address The address which you want to send tokens from
187      * @param value uint256 The amount of token to be burned
188      */
189     function burnFrom(address from, uint256 value) public {
190         _burnFrom(from, value);
191     }
192 
193     /**
194      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195      * Beware that changing an allowance with this method brings the risk that someone may use both the old
196      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      * @param spender The address which will spend the funds.
200      * @param value The amount of tokens to be spent.
201      */
202     function approve(address spender, uint256 value) public returns (bool) {
203         require(spender != address(0));
204 
205         _allowed[msg.sender][spender] = value;
206         emit Approval(msg.sender, spender, value);
207         return true;
208     }
209 
210     /**
211      * @dev Transfer tokens from one address to another.
212      * Note that while this function emits an Approval event, this is not required as per the specification,
213      * and other compliant implementations may not emit the event.
214      * @param from address The address which you want to send tokens from
215      * @param to address The address which you want to transfer to
216      * @param value uint256 the amount of tokens to be transferred
217      */
218     function transferFrom(address from, address to, uint256 value) public returns (bool) {
219         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
220         _transfer(from, to, value);
221         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
222         return true;
223     }
224 
225     /**
226      * @dev Increase the amount of tokens that an owner allowed to a spender.
227      * approve should be called when allowed_[_spender] == 0. To increment
228      * allowed value is better to use this function to avoid 2 calls (and wait until
229      * the first transaction is mined)
230      * From MonolithDAO Token.sol
231      * Emits an Approval event.
232      * @param spender The address which will spend the funds.
233      * @param addedValue The amount of tokens to increase the allowance by.
234      */
235     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
236         require(spender != address(0));
237 
238         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
239         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
240         return true;
241     }
242 
243     /**
244      * @dev Decrease the amount of tokens that an owner allowed to a spender.
245      * approve should be called when allowed_[_spender] == 0. To decrement
246      * allowed value is better to use this function to avoid 2 calls (and wait until
247      * the first transaction is mined)
248      * From MonolithDAO Token.sol
249      * Emits an Approval event.
250      * @param spender The address which will spend the funds.
251      * @param subtractedValue The amount of tokens to decrease the allowance by.
252      */
253     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
254         require(spender != address(0));
255 
256         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
257         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
258         return true;
259     }
260 
261     /**
262     * @dev Transfer token for a specified addresses
263     * @param from The address to transfer from.
264     * @param to The address to transfer to.
265     * @param value The amount to be transferred.
266     */
267     function _transfer(address from, address to, uint256 value) internal {
268         require(to != address(0));
269 
270         _balances[from] = _balances[from].sub(value);
271         _balances[to] = _balances[to].add(value);
272         emit Transfer(from, to, value);
273     }
274 
275     /**
276      * @dev Internal function that mints an amount of the token and assigns it to
277      * an account. This encapsulates the modification of balances such that the
278      * proper events are emitted.
279      * @param account The account that will receive the created tokens.
280      * @param value The amount that will be created.
281      */
282     function _mint(address account, uint256 value) internal {
283         require(account != address(0));
284 
285         _totalSupply = _totalSupply.add(value);
286         _balances[account] = _balances[account].add(value);
287         emit Transfer(address(0), account, value);
288     }
289 
290     /**
291      * @dev Internal function that burns an amount of the token of a given
292      * account.
293      * @param account The account whose tokens will be burnt.
294      * @param value The amount that will be burnt.
295      */
296     function _burn(address account, uint256 value) internal {
297         require(account != address(0));
298 
299         _totalSupply = _totalSupply.sub(value);
300         _balances[account] = _balances[account].sub(value);
301         emit Transfer(account, address(0), value);
302     }
303 
304     /**
305      * @dev Internal function that burns an amount of the token of a given
306      * account, deducting from the sender's allowance for said account. Uses the
307      * internal burn function.
308      * Emits an Approval event (reflecting the reduced allowance).
309      * @param account The account whose tokens will be burnt.
310      * @param value The amount that will be burnt.
311      */
312     function _burnFrom(address account, uint256 value) internal {
313         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
314         _burn(account, value);
315         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
316     }
317 
318 
319 }
320 
321 /** Below this is the actual token deploymet code **/
322 /**
323  * @title LedgeriumToken
324  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
325  * taken directly from open-zepplin examples.
326  * Note they can later distribute these tokens as they wish using `transfer` and other
327  * `ERC20` functions.
328  */
329 contract LedgeriumToken is ERC20 {
330     uint256 public constant INITIAL_SUPPLY = 20000000000000000;
331     /**
332     * Total during ERC-20 stage is 200 million. 
333     */
334 
335     /**
336      * @dev Constructor that gives msg.sender all of existing tokens.
337      */
338     constructor () public ERC20("Ledgerium", "XLG", 8) {
339         _mint(msg.sender, INITIAL_SUPPLY);
340     }
341 }