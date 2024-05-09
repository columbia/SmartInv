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
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72     function totalSupply() external view returns (uint256);
73 
74     function balanceOf(address who) external view returns (uint256);
75 
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
94  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 
97 contract ERC20 is IERC20 {
98     using SafeMath for uint256;
99 
100     mapping (address => uint256) private _balances;
101 
102     mapping (address => mapping (address => uint256)) private _allowed;
103 
104     uint256 private _totalSupply;
105 
106     /**
107     * @dev Total number of tokens in existence
108     */
109     function totalSupply() public view returns (uint256) {
110         return _totalSupply;
111     }
112 
113     /**
114     * @dev Gets the balance of the specified address.
115     * @param owner The address to query the balance of.
116     * @return An uint256 representing the amount owned by the passed address.
117     */
118     function balanceOf(address owner) public view returns (uint256) {
119         return _balances[owner];
120     }
121 
122     /**
123      * @dev Function to check the amount of tokens that an owner allowed to a spender.
124      * @param owner address The address which owns the funds.
125      * @param spender address The address which will spend the funds.
126      * @return A uint256 specifying the amount of tokens still available for the spender.
127      */
128     function allowance(address owner, address spender) public view returns (uint256) {
129         return _allowed[owner][spender];
130     }
131 
132     /**
133     * @dev Transfer token for a specified address
134     * @param to The address to transfer to.
135     * @param value The amount to be transferred.
136     */
137     function transfer(address to, uint256 value) public returns (bool) {
138         _transfer(msg.sender, to, value);
139         return true;
140     }
141 
142     /**
143      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144      * Beware that changing an allowance with this method brings the risk that someone may use both the old
145      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      * @param spender The address which will spend the funds.
149      * @param value The amount of tokens to be spent.
150      */
151     function approve(address spender, uint256 value) public returns (bool) {
152         require(spender != address(0));
153 
154         _allowed[msg.sender][spender] = value;
155         emit Approval(msg.sender, spender, value);
156         return true;
157     }
158 
159     /**
160      * @dev Transfer tokens from one address to another
161      * @param from address The address which you want to send tokens from
162      * @param to address The address which you want to transfer to
163      * @param value uint256 the amount of tokens to be transferred
164      */
165     function transferFrom(address from, address to, uint256 value) public returns (bool) {
166         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
167         _transfer(from, to, value);
168         return true;
169     }
170 
171     /**
172      * @dev Increase the amount of tokens that an owner allowed to a spender.
173      * approve should be called when allowed_[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      * @param spender The address which will spend the funds.
178      * @param addedValue The amount of tokens to increase the allowance by.
179      */
180     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
181         require(spender != address(0));
182 
183         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
184         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
185         return true;
186     }
187 
188     /**
189      * @dev Decrease the amount of tokens that an owner allowed to a spender.
190      * approve should be called when allowed_[_spender] == 0. To decrement
191      * allowed value is better to use this function to avoid 2 calls (and wait until
192      * the first transaction is mined)
193      * From MonolithDAO Token.sol
194      * @param spender The address which will spend the funds.
195      * @param subtractedValue The amount of tokens to decrease the allowance by.
196      */
197     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
198         require(spender != address(0));
199 
200         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
201         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
202         return true;
203     }
204 
205     /**
206     * @dev Transfer token for a specified addresses
207     * @param from The address to transfer from.
208     * @param to The address to transfer to.
209     * @param value The amount to be transferred.
210     */
211     function _transfer(address from, address to, uint256 value) internal {
212         require(to != address(0));
213 
214         _balances[from] = _balances[from].sub(value);
215         _balances[to] = _balances[to].add(value);
216         emit Transfer(from, to, value);
217     }
218 
219     /**
220      * @dev Internal function that mints an amount of the token and assigns it to
221      * an account. This encapsulates the modification of balances such that the
222      * proper events are emitted.
223      * @param account The account that will receive the created tokens.
224      * @param value The amount that will be created.
225      */
226     function _mint(address account, uint256 value) internal {
227         require(account != address(0));
228 
229         _totalSupply = _totalSupply.add(value);
230         _balances[account] = _balances[account].add(value);
231         emit Transfer(address(0), account, value);
232     }
233 
234     /**
235      * @dev Internal function that burns an amount of the token of a given
236      * account.
237      * @param account The account whose tokens will be burnt.
238      * @param value The amount that will be burnt.
239      */
240     function _burn(address account, uint256 value) internal {
241         require(account != address(0));
242 
243         _totalSupply = _totalSupply.sub(value);
244         _balances[account] = _balances[account].sub(value);
245         emit Transfer(account, address(0), value);
246     }
247 
248     /**
249      * @dev Internal function that burns an amount of the token of a given
250      * account, deducting from the sender's allowance for said account. Uses the
251      * internal burn function.
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burnFrom(address account, uint256 value) internal {
256         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
257         // this function needs to emit an event with the updated approval.
258         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
259         _burn(account, value);
260     }
261 }
262 
263 /**
264  * @title ERC20Detailed token
265  * @dev The decimals are only for visualization purposes.
266  * All the operations are done using the smallest and indivisible token unit,
267  * just as on Ethereum all the operations are done in wei.
268  */
269 contract ERC20Detailed is IERC20 {
270     string private _name;
271     string private _symbol;
272     uint8 private _decimals;
273 
274     constructor (string name, string symbol, uint8 decimals) public {
275         _name = name;
276         _symbol = symbol;
277         _decimals = decimals;
278     }
279 
280     /**
281      * @return the name of the token.
282      */
283     function name() public view returns (string) {
284         return _name;
285     }
286 
287     /**
288      * @return the symbol of the token.
289      */
290     function symbol() public view returns (string) {
291         return _symbol;
292     }
293 
294     /**
295      * @return the number of decimals of the token.
296      */
297     function decimals() public view returns (uint8) {
298         return _decimals;
299     }
300 }
301 
302 /**
303  * @title AI42TOKEN
304  * @dev A ERC20 Token which maps the AI42 ETI, where all tokens are pre-assigned to the creator.
305  * Note they can later distribute these tokens as they wish using `transfer` and other
306  * `ERC20` functions.
307  */
308 contract AI42TOKEN is ERC20, ERC20Detailed {
309     uint256 public constant INITIAL_SUPPLY = 65000000 * (10 ** uint256(decimals()));
310     uint256 AI42IndexValue;
311     address Issuer;
312     /**
313      * @dev Constructor that gives msg.sender all of existing tokens.
314      */
315     constructor () public ERC20Detailed("AI42 INDEX Token", "AI42", 0) {
316         _mint(msg.sender, INITIAL_SUPPLY);
317         Issuer = msg.sender;
318     }
319     /**
320      * @return the AI42 INDEX value
321      */
322     function setAI42IndexValue(uint256 x) public returns (bool) {
323         require(msg.sender == Issuer);
324         AI42IndexValue = x;
325         return true;
326     }
327     /**
328      * @return the AI42 INDEX value
329      */
330     function getAI42IndexValue() public view returns (uint256) {
331         return AI42IndexValue;
332     }
333 }