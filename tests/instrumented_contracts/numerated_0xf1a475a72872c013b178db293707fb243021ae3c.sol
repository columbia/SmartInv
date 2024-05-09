1 pragma solidity ^0.5.2;
2 
3 
4 
5 library SafeMath {
6     /**
7      * @dev Multiplies two unsigned integers, reverts on overflow.
8      */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (a == 0) {
14             return 0;
15         }
16 
17         uint256 c = a * b;
18         require(c / a == b);
19 
20         return c;
21     }
22 
23     /**
24      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
25      */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Solidity only automatically asserts when dividing by 0
28         require(b > 0);
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31 
32         return c;
33     }
34 
35     /**
36      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37      */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     /**
46      * @dev Adds two unsigned integers, reverts on overflow.
47      */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a);
51 
52         return c;
53     }
54 
55     /**
56      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
57      * reverts when dividing by zero.
58      */
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b != 0);
61         return a % b;
62     }
63 }
64 
65 
66 
67 /**
68  * @title ERC20 interface
69  */
70 interface IERC20 {
71     function transfer(address to, uint256 value) external returns (bool);
72 
73     function approve(address spender, uint256 value) external returns (bool);
74 
75     function transferFrom(address from, address to, uint256 value) external returns (bool);
76 
77     function totalSupply() external view returns (uint256);
78 
79     function balanceOf(address who) external view returns (uint256);
80 
81     function allowance(address owner, address spender) external view returns (uint256);
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 
90 contract ERC20 is IERC20 {
91     using SafeMath for uint256;
92 
93     mapping (address => uint256) private _balances;
94 
95     mapping (address => mapping (address => uint256)) private _allowed;
96 
97     uint256 private _totalSupply;
98 
99     /**
100      * @dev Total number of tokens in existence
101      */
102     function totalSupply() public view returns (uint256) {
103         return _totalSupply;
104     }
105 
106     /**
107      * @dev Gets the balance of the specified address.
108      * @param owner The address to query the balance of.
109      * @return An uint256 representing the amount owned by the passed address.
110      */
111     function balanceOf(address owner) public view returns (uint256) {
112         return _balances[owner];
113     }
114 
115     /**
116      * @dev Function to check the amount of tokens that an owner allowed to a spender.
117      * @param owner address The address which owns the funds.
118      * @param spender address The address which will spend the funds.
119      * @return A uint256 specifying the amount of tokens still available for the spender.
120      */
121     function allowance(address owner, address spender) public view returns (uint256) {
122         return _allowed[owner][spender];
123     }
124 
125     /**
126      * @dev Transfer token for a specified address
127      * @param to The address to transfer to.
128      * @param value The amount to be transferred.
129      */
130     function transfer(address to, uint256 value) public returns (bool) {
131         _transfer(msg.sender, to, value);
132         return true;
133     }
134 
135     /**
136      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137      * Beware that changing an allowance with this method brings the risk that someone may use both the old
138      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      * @param spender The address which will spend the funds.
142      * @param value The amount of tokens to be spent.
143      */
144     function approve(address spender, uint256 value) public returns (bool) {
145         _approve(msg.sender, spender, value);
146         return true;
147     }
148 
149     /**
150      * @dev Transfer tokens from one address to another.
151      * Note that while this function emits an Approval event, this is not required as per the specification,
152      * and other compliant implementations may not emit the event.
153      * @param from address The address which you want to send tokens from
154      * @param to address The address which you want to transfer to
155      * @param value uint256 the amount of tokens to be transferred
156      */
157     function transferFrom(address from, address to, uint256 value) public returns (bool) {
158         _transfer(from, to, value);
159         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
160         return true;
161     }
162 
163     /**
164      * @dev Increase the amount of tokens that an owner allowed to a spender.
165      * approve should be called when allowed_[_spender] == 0. To increment
166      * allowed value is better to use this function to avoid 2 calls (and wait until
167      * the first transaction is mined)
168      * From MonolithDAO Token.sol
169      * Emits an Approval event.
170      * @param spender The address which will spend the funds.
171      * @param addedValue The amount of tokens to increase the allowance by.
172      */
173     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
174         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
175         return true;
176     }
177 
178     /**
179      * @dev Decrease the amount of tokens that an owner allowed to a spender.
180      * approve should be called when allowed_[_spender] == 0. To decrement
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * Emits an Approval event.
185      * @param spender The address which will spend the funds.
186      * @param subtractedValue The amount of tokens to decrease the allowance by.
187      */
188     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
189         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
190         return true;
191     }
192 
193     /**
194      * @dev Transfer token for a specified addresses
195      * @param from The address to transfer from.
196      * @param to The address to transfer to.
197      * @param value The amount to be transferred.
198      */
199     function _transfer(address from, address to, uint256 value) internal {
200         require(to != address(0));
201 
202         _balances[from] = _balances[from].sub(value);
203         _balances[to] = _balances[to].add(value);
204         emit Transfer(from, to, value);
205     }
206 
207     /**
208      * @dev Internal function that mints an amount of the token and assigns it to
209      * an account. This encapsulates the modification of balances such that the
210      * proper events are emitted.
211      * @param account The account that will receive the created tokens.
212      * @param value The amount that will be created.
213      */
214     function _mint(address account, uint256 value) internal {
215         require(account != address(0));
216 
217         _totalSupply = _totalSupply.add(value);
218         _balances[account] = _balances[account].add(value);
219         emit Transfer(address(0), account, value);
220     }
221 
222     /**
223      * @dev Internal function that burns an amount of the token of a given
224      * account.
225      * @param account The account whose tokens will be burnt.
226      * @param value The amount that will be burnt.
227      */
228     function _burn(address account, uint256 value) internal {
229         require(account != address(0));
230 
231         _totalSupply = _totalSupply.sub(value);
232         _balances[account] = _balances[account].sub(value);
233         emit Transfer(account, address(0), value);
234     }
235 
236     /**
237      * @dev Approve an address to spend another addresses' tokens.
238      * @param owner The address that owns the tokens.
239      * @param spender The address that will spend the tokens.
240      * @param value The number of tokens that can be spent.
241      */
242     function _approve(address owner, address spender, uint256 value) internal {
243         require(spender != address(0));
244         require(owner != address(0));
245 
246         _allowed[owner][spender] = value;
247         emit Approval(owner, spender, value);
248     }
249 
250     /**
251      * @dev Internal function that burns an amount of the token of a given
252      * account, deducting from the sender's allowance for said account. Uses the
253      * internal burn function.
254      * Emits an Approval event (reflecting the reduced allowance).
255      * @param account The account whose tokens will be burnt.
256      * @param value The amount that will be burnt.
257      */
258     function _burnFrom(address account, uint256 value) internal {
259         _burn(account, value);
260         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
261     }
262 }
263 
264 
265 
266 /**
267  * @title ERC20Detailed token
268  */
269 contract ERC20Detailed is IERC20 {
270     string private _name;
271     string private _symbol;
272     uint8 private _decimals;
273 
274     constructor (string memory name, string memory symbol, uint8 decimals) public {
275         _name = name;
276         _symbol = symbol;
277         _decimals = decimals;
278     }
279 
280     /**
281      * @return the name of the token.
282      */
283     function name() public view returns (string memory) {
284         return _name;
285     }
286 
287     /**
288      * @return the symbol of the token.
289      */
290     function symbol() public view returns (string memory) {
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
302 
303 
304 /**
305  * @title Burnable Token
306  */
307 contract ERC20Burnable is ERC20 {
308     /**
309      * @dev Burns a specific amount of tokens.
310      * @param value The amount of token to be burned.
311      */
312     function burn(uint256 value) public {
313         _burn(msg.sender, value);
314     }
315 
316     /**
317      * @dev Burns a specific amount of tokens from the target address and decrements allowance
318      * @param from address The account whose tokens will be burned.
319      * @param value uint256 The amount of token to be burned.
320      */
321     function burnFrom(address from, uint256 value) public {
322         _burnFrom(from, value);
323     }
324 }
325 
326 
327 
328 /**
329  * @title SponbToken
330  * `ERC20` functions.
331  */
332 contract SponbToken is ERC20, ERC20Detailed, ERC20Burnable {
333     uint8 public constant DECIMALS = 18;
334     uint256 public constant INITIAL_UINT = 3500000000;
335     uint256 public constant INITIAL_SUPPLY = INITIAL_UINT * (10 ** uint256(DECIMALS));
336 
337     /**
338      * @dev Constructor that gives msg.sender all of existing tokens.
339      */
340     constructor () public ERC20Detailed("SponbToken", "SPO", DECIMALS) {
341         _mint(msg.sender, INITIAL_SUPPLY);
342     }
343 }