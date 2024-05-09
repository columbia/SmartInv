1 /**
2  * @title ERC20 interface
3  * @dev see https://github.com/ethereum/EIPs/issues/20
4  */
5 interface IERC20 {
6     function transfer(address to, uint256 value) external returns (bool);
7 
8     function approve(address spender, uint256 value) external returns (bool);
9 
10     function transferFrom(address from, address to, uint256 value) external returns (bool);
11 
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address who) external view returns (uint256);
15 
16     function allowance(address owner, address spender) external view returns (uint256);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 
24 /**
25  * @title ERC20Detailed token
26  * @dev The decimals are only for visualization purposes.
27  * All the operations are done using the smallest and indivisible token unit,
28  * just as on Ethereum all the operations are done in wei.
29  */
30 contract ERC20Detailed is IERC20 {
31     string private _name;
32     string private _symbol;
33     uint8 private _decimals;
34 
35     constructor (string memory name, string memory symbol, uint8 decimals) public {
36         _name = name;
37         _symbol = symbol;
38         _decimals = decimals;
39     }
40 
41     /**
42      * @return the name of the token.
43      */
44     function name() public view returns (string memory) {
45         return _name;
46     }
47 
48     /**
49      * @return the symbol of the token.
50      */
51     function symbol() public view returns (string memory) {
52         return _symbol;
53     }
54 
55     /**
56      * @return the number of decimals of the token.
57      */
58     function decimals() public view returns (uint8) {
59         return _decimals;
60     }
61 }
62 
63 
64 
65 
66 
67 
68 /**
69  * @title SafeMath
70  * @dev Unsigned math operations with safety checks that revert on error
71  */
72 library SafeMath {
73     /**
74     * @dev Multiplies two unsigned integers, reverts on overflow.
75     */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b);
86 
87         return c;
88     }
89 
90     /**
91     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
92     */
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         // Solidity only automatically asserts when dividing by 0
95         require(b > 0);
96         uint256 c = a / b;
97         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98 
99         return c;
100     }
101 
102     /**
103     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
104     */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b <= a);
107         uint256 c = a - b;
108 
109         return c;
110     }
111 
112     /**
113     * @dev Adds two unsigned integers, reverts on overflow.
114     */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a);
118 
119         return c;
120     }
121 
122     /**
123     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
124     * reverts when dividing by zero.
125     */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         require(b != 0);
128         return a % b;
129     }
130 }
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
138  * Originally based on code by FirstBlood:
139  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  *
141  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
142  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
143  * compliant implementations may not do it.
144  */
145 contract ERC20 is IERC20 {
146     using SafeMath for uint256;
147 
148     mapping (address => uint256) private _balances;
149 
150     mapping (address => mapping (address => uint256)) private _allowed;
151 
152     uint256 private _totalSupply;
153 
154     /**
155     * @dev Total number of tokens in existence
156     */
157     function totalSupply() public view returns (uint256) {
158         return _totalSupply;
159     }
160 
161     /**
162     * @dev Gets the balance of the specified address.
163     * @param owner The address to query the balance of.
164     * @return An uint256 representing the amount owned by the passed address.
165     */
166     function balanceOf(address owner) public view returns (uint256) {
167         return _balances[owner];
168     }
169 
170     /**
171      * @dev Function to check the amount of tokens that an owner allowed to a spender.
172      * @param owner address The address which owns the funds.
173      * @param spender address The address which will spend the funds.
174      * @return A uint256 specifying the amount of tokens still available for the spender.
175      */
176     function allowance(address owner, address spender) public view returns (uint256) {
177         return _allowed[owner][spender];
178     }
179 
180     /**
181     * @dev Transfer token for a specified address
182     * @param to The address to transfer to.
183     * @param value The amount to be transferred.
184     */
185     function transfer(address to, uint256 value) public returns (bool) {
186         _transfer(msg.sender, to, value);
187         return true;
188     }
189 
190     /**
191      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192      * Beware that changing an allowance with this method brings the risk that someone may use both the old
193      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196      * @param spender The address which will spend the funds.
197      * @param value The amount of tokens to be spent.
198      */
199     function approve(address spender, uint256 value) public returns (bool) {
200         require(spender != address(0));
201 
202         _allowed[msg.sender][spender] = value;
203         emit Approval(msg.sender, spender, value);
204         return true;
205     }
206 
207     /**
208      * @dev Transfer tokens from one address to another.
209      * Note that while this function emits an Approval event, this is not required as per the specification,
210      * and other compliant implementations may not emit the event.
211      * @param from address The address which you want to send tokens from
212      * @param to address The address which you want to transfer to
213      * @param value uint256 the amount of tokens to be transferred
214      */
215     function transferFrom(address from, address to, uint256 value) public returns (bool) {
216         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
217         _transfer(from, to, value);
218         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
219         return true;
220     }
221 
222     /**
223      * @dev Increase the amount of tokens that an owner allowed to a spender.
224      * approve should be called when allowed_[_spender] == 0. To increment
225      * allowed value is better to use this function to avoid 2 calls (and wait until
226      * the first transaction is mined)
227      * From MonolithDAO Token.sol
228      * Emits an Approval event.
229      * @param spender The address which will spend the funds.
230      * @param addedValue The amount of tokens to increase the allowance by.
231      */
232     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
233         require(spender != address(0));
234 
235         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
236         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
237         return true;
238     }
239 
240     /**
241      * @dev Decrease the amount of tokens that an owner allowed to a spender.
242      * approve should be called when allowed_[_spender] == 0. To decrement
243      * allowed value is better to use this function to avoid 2 calls (and wait until
244      * the first transaction is mined)
245      * From MonolithDAO Token.sol
246      * Emits an Approval event.
247      * @param spender The address which will spend the funds.
248      * @param subtractedValue The amount of tokens to decrease the allowance by.
249      */
250     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
251         require(spender != address(0));
252 
253         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
254         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
255         return true;
256     }
257 
258     /**
259     * @dev Transfer token for a specified addresses
260     * @param from The address to transfer from.
261     * @param to The address to transfer to.
262     * @param value The amount to be transferred.
263     */
264     function _transfer(address from, address to, uint256 value) internal {
265         require(to != address(0));
266 
267         _balances[from] = _balances[from].sub(value);
268         _balances[to] = _balances[to].add(value);
269         emit Transfer(from, to, value);
270     }
271 
272     /**
273      * @dev Internal function that mints an amount of the token and assigns it to
274      * an account. This encapsulates the modification of balances such that the
275      * proper events are emitted.
276      * @param account The account that will receive the created tokens.
277      * @param value The amount that will be created.
278      */
279     function _mint(address account, uint256 value) internal {
280         require(account != address(0));
281 
282         _totalSupply = _totalSupply.add(value);
283         _balances[account] = _balances[account].add(value);
284         emit Transfer(address(0), account, value);
285     }
286 
287     /**
288      * @dev Internal function that burns an amount of the token of a given
289      * account.
290      * @param account The account whose tokens will be burnt.
291      * @param value The amount that will be burnt.
292      */
293     function _burn(address account, uint256 value) internal {
294         require(account != address(0));
295 
296         _totalSupply = _totalSupply.sub(value);
297         _balances[account] = _balances[account].sub(value);
298         emit Transfer(account, address(0), value);
299     }
300 
301     /**
302      * @dev Internal function that burns an amount of the token of a given
303      * account, deducting from the sender's allowance for said account. Uses the
304      * internal burn function.
305      * Emits an Approval event (reflecting the reduced allowance).
306      * @param account The account whose tokens will be burnt.
307      * @param value The amount that will be burnt.
308      */
309     function _burnFrom(address account, uint256 value) internal {
310         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
311         _burn(account, value);
312         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
313     }
314 }
315 
316 
317 contract TCB is ERC20, ERC20Detailed {
318     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals()));
319     
320     constructor () public ERC20Detailed("tengchatoken", "TCB", 18){
321         _mint(msg.sender, INITIAL_SUPPLY);
322     }
323 }