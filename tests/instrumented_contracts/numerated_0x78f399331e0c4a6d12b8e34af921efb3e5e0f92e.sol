1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-05-08
7 */
8 
9 pragma solidity ^0.5.2;
10 
11 /**
12  * @title SafeMath(Connor)
13  * @dev Unsigned math operations with safety checks that revert on error
14  */
15 library SafeMath_Connor {
16     /**
17      * @dev Multiplies two unsigned integers, reverts on overflow.
18      */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21         // benefit is lost if 'b' is also tested.
22         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b);
29 
30         return c;
31     }
32 
33     /**
34      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
35      */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Solidity only automatically asserts when dividing by 0
38         require(b > 0);
39         uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 
42         return c;
43     }
44 
45     /**
46      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         require(b <= a);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     /**
56      * @dev Adds two unsigned integers, reverts on overflow.
57      */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a);
61 
62         return c;
63     }
64 
65     /**
66      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
67      * reverts when dividing by zero.
68      */
69     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b != 0);
71         return a % b;
72     }
73 }
74 
75 /**
76  * @title IERC20(Connor) interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 interface IERC20_Connor {
80     function transfer(address to, uint256 value) external returns (bool);
81 
82     function approve(address spender, uint256 value) external returns (bool);
83 
84     function transferFrom(address from, address to, uint256 value) external returns (bool);
85 
86     function totalSupply() external view returns (uint256);
87 
88     function balanceOf(address who) external view returns (uint256);
89 
90     function allowance(address owner, address spender) external view returns (uint256);
91 
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 /**
98  * @title Standard ERC20(Connor) token
99  * @dev Implementation of the basic standard token.
100 */
101 contract ERC20_Connor is IERC20_Connor {
102     using SafeMath_Connor for uint256;
103 
104     mapping (address => uint256) private _balances;
105 
106     mapping (address => mapping (address => uint256)) private _allowed;
107 
108     uint256 private _totalSupply;
109 
110     /**
111      * @dev Total number of tokens in existence
112      */
113     function totalSupply() public view returns (uint256) {
114         return _totalSupply;
115     }
116 
117     /**
118      * @dev Gets the balance of the specified address.
119      * @param owner The address to query the balance of.
120      * @return An uint256 representing the amount owned by the passed address.
121      */
122     function balanceOf(address owner) public view returns (uint256) {
123         return _balances[owner];
124     }
125 
126     /**
127      * @dev Function to check the amount of tokens that an owner allowed to a spender.
128      * @param owner address The address which owns the funds.
129      * @param spender address The address which will spend the funds.
130      * @return A uint256 specifying the amount of tokens still available for the spender.
131      */
132     function allowance(address owner, address spender) public view returns (uint256) {
133         return _allowed[owner][spender];
134     }
135 
136     /**
137      * @dev Transfer token for a specified address
138      * @param to The address to transfer to.
139      * @param value The amount to be transferred.
140      */
141     function transfer(address to, uint256 value) public returns (bool) {
142         _transfer(msg.sender, to, value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * @param spender The address which will spend the funds.
152      * @param value The amount of tokens to be spent.
153      */
154     function approve(address spender, uint256 value) public returns (bool) {
155         _approve(msg.sender, spender, value);
156         return true;
157     }
158 
159     /**
160      * @dev Transfer tokens from one address to another.
161      * Note that while this function emits an Approval event, this is not required as per the specification,
162      * and other compliant implementations may not emit the event.
163      * @param from address The address which you want to send tokens from
164      * @param to address The address which you want to transfer to
165      * @param value uint256 the amount of tokens to be transferred
166      */
167     function transferFrom(address from, address to, uint256 value) public returns (bool) {
168         _transfer(from, to, value);
169         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
170         return true;
171     }
172 
173     /**
174      * @dev Increase the amount of tokens that an owner allowed to a spender.
175      * approve should be called when allowed_[_spender] == 0. To increment
176      * allowed value is better to use this function to avoid 2 calls (and wait until
177      * the first transaction is mined)
178      * From MonolithDAO Token.sol
179      * Emits an Approval event.
180      * @param spender The address which will spend the funds.
181      * @param addedValue The amount of tokens to increase the allowance by.
182      */
183     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
184         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
185         return true;
186     }
187 
188     /**
189      * @dev Decrease the amount of tokens that an owner allowed to a spender.
190      * approve should be called when allowed_[_spender] == 0. To decrement
191      * allowed value is better to use this function to avoid 2 calls (and wait until
192      * the first transaction is mined)
193      * From MonolithDAO Token.sol
194      * Emits an Approval event.
195      * @param spender The address which will spend the funds.
196      * @param subtractedValue The amount of tokens to decrease the allowance by.
197      */
198     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
199         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
200         return true;
201     }
202 
203     /**
204      * @dev Transfer token for a specified addresses
205      * @param from The address to transfer from.
206      * @param to The address to transfer to.
207      * @param value The amount to be transferred.
208      */
209     function _transfer(address from, address to, uint256 value) internal {
210         require(to != address(0));
211 
212         _balances[from] = _balances[from].sub(value);
213         _balances[to] = _balances[to].add(value);
214         emit Transfer(from, to, value);
215     }
216 
217     /**
218      * @dev Internal function that mints an amount of the token and assigns it to
219      * an account. This encapsulates the modification of balances such that the
220      * proper events are emitted.
221      * @param account The account that will receive the created tokens.
222      * @param value The amount that will be created.
223      */
224     function _mint(address account, uint256 value) internal {
225         require(account != address(0));
226 
227         _totalSupply = _totalSupply.add(value);
228         _balances[account] = _balances[account].add(value);
229         emit Transfer(address(0), account, value);
230     }
231 
232     /**
233      * @dev Internal function that burns an amount of the token of a given
234      * account.
235      * @param account The account whose tokens will be burnt.
236      * @param value The amount that will be burnt.
237      */
238     function _burn(address account, uint256 value) internal {
239         require(account != address(0));
240 
241         _totalSupply = _totalSupply.sub(value);
242         _balances[account] = _balances[account].sub(value);
243         emit Transfer(account, address(0), value);
244     }
245 
246     /**
247      * @dev Approve an address to spend another addresses' tokens.
248      * @param owner The address that owns the tokens.
249      * @param spender The address that will spend the tokens.
250      * @param value The number of tokens that can be spent.
251      */
252     function _approve(address owner, address spender, uint256 value) internal {
253         require(spender != address(0));
254         require(owner != address(0));
255 
256         _allowed[owner][spender] = value;
257         emit Approval(owner, spender, value);
258     }
259 
260     /**
261      * @dev Internal function that burns an amount of the token of a given
262      * account, deducting from the sender's allowance for said account. Uses the
263      * internal burn function.
264      * Emits an Approval event (reflecting the reduced allowance).
265      * @param account The account whose tokens will be burnt.
266      * @param value The amount that will be burnt.
267      */
268     function _burnFrom(address account, uint256 value) internal {
269         _burn(account, value);
270         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
271     }
272 }
273 
274 /**
275  * @title ERC20Detailed(Connor) token
276  * @dev The decimals are only for visualization purposes.
277  * All the operations are done using the smallest and indivisible token unit,
278  * just as on Ethereum all the operations are done in wei.
279  */
280 contract ERC20Detailed_Connor is IERC20_Connor {
281     string private _name;
282     string private _symbol;
283     uint8 private _decimals;
284 
285     constructor (string memory name, string memory symbol, uint8 decimals) public {
286         _name = name;
287         _symbol = symbol;
288         _decimals = decimals;
289     }
290 
291     /**
292      * @return the name of the token.
293      */
294     function name() public view returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @return the symbol of the token.
300      */
301     function symbol() public view returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @return the number of decimals of the token.
307      */
308     function decimals() public view returns (uint8) {
309         return _decimals;
310     }
311 }
312 /**
313  * @title ERC20Burnable(Connor) Token
314  * @dev Token that can be irreversibly burned (destroyed).
315  */
316 contract ERC20Burnable_Connor is ERC20_Connor {
317     /**
318      * @dev Burns a specific amount of tokens.
319      * @param value The amount of token to be burned.
320      */
321     function burn(uint256 value) public {
322         _burn(msg.sender, value);
323     }
324 
325     /**
326      * @dev Burns a specific amount of tokens from the target address and decrements allowance
327      * @param from address The account whose tokens will be burned.
328      * @param value uint256 The amount of token to be burned.
329      */
330     function burnFrom(address from, uint256 value) public {
331         _burnFrom(from, value);
332     }
333 }
334 /**
335  * @title SimpleToken
336  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
337  * Note they can later distribute these tokens as they wish using `transfer` and other
338  * `ERC20` functions.
339  */
340 contract ConnorToken is ERC20_Connor, ERC20Detailed_Connor, ERC20Burnable_Connor {
341     uint8 public constant DECIMALS = 2;
342     uint256 public constant INITIAL_SUPPLY = 19990000 * (10 ** uint256(DECIMALS));
343 
344     /**
345      * @dev Constructor that gives msg.sender all of existing tokens.
346      */
347     constructor () public ERC20Detailed_Connor("TraceToken", "TRE", DECIMALS) {
348         _mint(msg.sender, INITIAL_SUPPLY);
349     }
350 }