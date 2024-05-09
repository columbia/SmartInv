1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two unsigned integers, reverts on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two unsigned integers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 interface IERC20 {
64     function transfer(address to, uint256 value) external returns (bool);
65 
66     function approve(address spender, uint256 value) external returns (bool);
67 
68     function transferFrom(address from, address to, uint256 value) external returns (bool);
69 
70     function totalSupply() external view returns (uint256);
71 
72     function balanceOf(address who) external view returns (uint256);
73 
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 contract ERC20 is IERC20 {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) private _balances;
85 
86     mapping (address => mapping (address => uint256)) private _allowed;
87 
88     uint256 private _totalSupply;
89 
90     /**
91     * @dev Total number of tokens in existence
92     */
93     function totalSupply() public view returns (uint256) {
94         return _totalSupply;
95     }
96 
97     /**
98     * @dev Gets the balance of the specified address.
99     * @param owner The address to query the balance of.
100     * @return An uint256 representing the amount owned by the passed address.
101     */
102     function balanceOf(address owner) public view returns (uint256) {
103         return _balances[owner];
104     }
105 
106     /**
107      * @dev Function to check the amount of tokens that an owner allowed to a spender.
108      * @param owner address The address which owns the funds.
109      * @param spender address The address which will spend the funds.
110      * @return A uint256 specifying the amount of tokens still available for the spender.
111      */
112     function allowance(address owner, address spender) public view returns (uint256) {
113         return _allowed[owner][spender];
114     }
115 
116     /**
117     * @dev Transfer token for a specified address
118     * @param to The address to transfer to.
119     * @param value The amount to be transferred.
120     */
121     function transfer(address to, uint256 value) public returns (bool) {
122         _transfer(msg.sender, to, value);
123         return true;
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
137 
138         _allowed[msg.sender][spender] = value;
139         emit Approval(msg.sender, spender, value);
140         return true;
141     }
142 
143     /**
144      * @dev Transfer tokens from one address to another.
145      * Note that while this function emits an Approval event, this is not required as per the specification,
146      * and other compliant implementations may not emit the event.
147      * @param from address The address which you want to send tokens from
148      * @param to address The address which you want to transfer to
149      * @param value uint256 the amount of tokens to be transferred
150      */
151     function transferFrom(address from, address to, uint256 value) public returns (bool) {
152         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
153         _transfer(from, to, value);
154         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
155         return true;
156     }
157 
158     /**
159      * @dev Increase the amount of tokens that an owner allowed to a spender.
160      * approve should be called when allowed_[_spender] == 0. To increment
161      * allowed value is better to use this function to avoid 2 calls (and wait until
162      * the first transaction is mined)
163      * From MonolithDAO Token.sol
164      * Emits an Approval event.
165      * @param spender The address which will spend the funds.
166      * @param addedValue The amount of tokens to increase the allowance by.
167      */
168     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
169         require(spender != address(0));
170 
171         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
172         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
173         return true;
174     }
175 
176     /**
177      * @dev Decrease the amount of tokens that an owner allowed to a spender.
178      * approve should be called when allowed_[_spender] == 0. To decrement
179      * allowed value is better to use this function to avoid 2 calls (and wait until
180      * the first transaction is mined)
181      * From MonolithDAO Token.sol
182      * Emits an Approval event.
183      * @param spender The address which will spend the funds.
184      * @param subtractedValue The amount of tokens to decrease the allowance by.
185      */
186     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
187         require(spender != address(0));
188 
189         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
190         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
191         return true;
192     }
193 
194     /**
195     * @dev Transfer token for a specified addresses
196     * @param from The address to transfer from.
197     * @param to The address to transfer to.
198     * @param value The amount to be transferred.
199     */
200     function _transfer(address from, address to, uint256 value) internal {
201         require(to != address(0));
202 
203         _balances[from] = _balances[from].sub(value);
204         _balances[to] = _balances[to].add(value);
205         emit Transfer(from, to, value);
206     }
207 
208     /**
209      * @dev Internal function that mints an amount of the token and assigns it to
210      * an account. This encapsulates the modification of balances such that the
211      * proper events are emitted.
212      * @param account The account that will receive the created tokens.
213      * @param value The amount that will be created.
214      */
215     function _mint(address account, uint256 value) internal {
216         require(account != address(0));
217 
218         _totalSupply = _totalSupply.add(value);
219         _balances[account] = _balances[account].add(value);
220         emit Transfer(address(0), account, value);
221     }
222 
223     /**
224      * @dev Internal function that burns an amount of the token of a given
225      * account.
226      * @param account The account whose tokens will be burnt.
227      * @param value The amount that will be burnt.
228      */
229     function _burn(address account, uint256 value) internal {
230         require(account != address(0));
231 
232         _totalSupply = _totalSupply.sub(value);
233         _balances[account] = _balances[account].sub(value);
234         emit Transfer(account, address(0), value);
235     }
236 
237     /**
238      * @dev Internal function that burns an amount of the token of a given
239      * account, deducting from the sender's allowance for said account. Uses the
240      * internal burn function.
241      * Emits an Approval event (reflecting the reduced allowance).
242      * @param account The account whose tokens will be burnt.
243      * @param value The amount that will be burnt.
244      */
245     function _burnFrom(address account, uint256 value) internal {
246         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
247         _burn(account, value);
248         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
249     }
250 }
251 
252 contract ERC20Detailed is IERC20 {
253     string private _name;
254     string private _symbol;
255     uint8 private _decimals;
256 
257     constructor (string memory name, string memory symbol, uint8 decimals) public {
258         _name = name;
259         _symbol = symbol;
260         _decimals = decimals;
261     }
262 
263     /**
264      * @return the name of the token.
265      */
266     function name() public view returns (string memory) {
267         return _name;
268     }
269 
270     /**
271      * @return the symbol of the token.
272      */
273     function symbol() public view returns (string memory) {
274         return _symbol;
275     }
276 
277     /**
278      * @return the number of decimals of the token.
279      */
280     function decimals() public view returns (uint8) {
281         return _decimals;
282     }
283 }
284 
285 contract TestToken is ERC20, ERC20Detailed {
286     uint256 public burned; // Burned TST.
287 
288     string private constant NAME = "Test";
289     string private constant SYMBOL = "TST";
290     uint8 private constant DECIMALS = 18;
291     uint256 private constant INITIAL_SUPPLY = 2 * 10**28; // 20 billion
292 
293     constructor () public ERC20Detailed(NAME, SYMBOL, DECIMALS) {
294         _mint(msg.sender, INITIAL_SUPPLY);
295     }
296 
297     function burn(uint256 value) public returns(bool) {
298         burned = burned.add(value);
299         
300 
301 
302 
303 
304 
305 _burn(msg.sender, value);
306         return true;
307     }
308 
309     function burnFrom(address from, uint256 value) public returns(bool) {
310         burned = burned.add(value);
311         _burnFrom(from, value);
312         return true;
313     }
314 }