1 pragma solidity ^0.5.2;
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two unsigned integers, reverts on overflow.
6      */
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
22      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23      */
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
34      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44      * @dev Adds two unsigned integers, reverts on overflow.
45      */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55      * reverts when dividing by zero.
56      */
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
81 /**
82  * @title Standard ERC20 token
83  *
84  * @dev Implementation of the basic standard token.
85  * https://eips.ethereum.org/EIPS/eip-20
86  * Originally based on code by FirstBlood:
87  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
88  *
89  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
90  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
91  * compliant implementations may not do it.
92  */
93 contract ERC20 is IERC20 {
94     using SafeMath for uint256;
95 
96     mapping (address => uint256) private _balances;
97 
98     mapping (address => mapping (address => uint256)) private _allowed;
99 
100     uint256 private _totalSupply;
101 
102     function totalSupply() public view returns (uint256) {
103         return _totalSupply;
104     }
105 
106     
107     function balanceOf(address owner) public view returns (uint256) {
108         return _balances[owner];
109     }
110 
111     /**
112      * @dev Function to check the amount of tokens that an owner allowed to a spender.
113      * @param owner address The address which owns the funds.
114      * @param spender address The address which will spend the funds.
115      * @return A uint256 specifying the amount of tokens still available for the spender.
116      */
117     function allowance(address owner, address spender) public view returns (uint256) {
118         return _allowed[owner][spender];
119     }
120 
121     /**
122      * @dev Transfer token to a specified address.
123      * @param to The address to transfer to.
124      * @param value The amount to be transferred.
125      */
126     function transfer(address to, uint256 value) public returns (bool) {
127         _transfer(msg.sender, to, value);
128         return true;
129     }
130 
131     /**
132      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133      * Beware that changing an allowance with this method brings the risk that someone may use both the old
134      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      * @param spender The address which will spend the funds.
138      * @param value The amount of tokens to be spent.
139      */
140     function approve(address spender, uint256 value) public returns (bool) {
141         _approve(msg.sender, spender, value);
142         return true;
143     }
144 
145     /**
146      * @dev Transfer tokens from one address to another.
147      * Note that while this function emits an Approval event, this is not required as per the specification,
148      * and other compliant implementations may not emit the event.
149      * @param from address The address which you want to send tokens from
150      * @param to address The address which you want to transfer to
151      * @param value uint256 the amount of tokens to be transferred
152      */
153     function transferFrom(address from, address to, uint256 value) public returns (bool) {
154         _transfer(from, to, value);
155         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
156         return true;
157     }
158 
159     /**
160      * @dev Increase the amount of tokens that an owner allowed to a spender.
161      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
162      * allowed value is better to use this function to avoid 2 calls (and wait until
163      * the first transaction is mined)
164      * From MonolithDAO Token.sol
165      * Emits an Approval event.
166      * @param spender The address which will spend the funds.
167      * @param addedValue The amount of tokens to increase the allowance by.
168      */
169     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
170         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
171         return true;
172     }
173 
174     /**
175      * @dev Decrease the amount of tokens that an owner allowed to a spender.
176      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * Emits an Approval event.
181      * @param spender The address which will spend the funds.
182      * @param subtractedValue The amount of tokens to decrease the allowance by.
183      */
184     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
185         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
186         return true;
187     }
188 
189     /**
190      * @dev Transfer token for a specified addresses.
191      * @param from The address to transfer from.
192      * @param to The address to transfer to.
193      * @param value The amount to be transferred.
194      */
195     function _transfer(address from, address to, uint256 value) internal {
196         require(to != address(0));
197 
198         _balances[from] = _balances[from].sub(value);
199         _balances[to] = _balances[to].add(value);
200         emit Transfer(from, to, value);
201     }
202 
203     /**
204      * @dev Internal function that mints an amount of the token and assigns it to
205      * an account. This encapsulates the modification of balances such that the
206      * proper events are emitted.
207      * @param account The account that will receive the created tokens.
208      * @param value The amount that will be created.
209      */
210     function _mint(address account, uint256 value) internal {
211         require(account != address(0));
212 
213         _totalSupply = _totalSupply.add(value);
214         _balances[account] = _balances[account].add(value);
215         emit Transfer(address(0), account, value);
216     }
217 
218     /**
219      * @dev Internal function that burns an amount of the token of a given
220      * account.
221      * @param account The account whose tokens will be burnt.
222      * @param value The amount that will be burnt.
223      */
224     function _burn(address account, uint256 value) internal {
225         require(account != address(0));
226 
227         _totalSupply = _totalSupply.sub(value);
228         _balances[account] = _balances[account].sub(value);
229         emit Transfer(account, address(0), value);
230     }
231 
232     /**
233      * @dev Approve an address to spend another addresses' tokens.
234      * @param owner The address that owns the tokens.
235      * @param spender The address that will spend the tokens.
236      * @param value The number of tokens that can be spent.
237      */
238     function _approve(address owner, address spender, uint256 value) internal {
239         require(spender != address(0));
240         require(owner != address(0));
241 
242         _allowed[owner][spender] = value;
243         emit Approval(owner, spender, value);
244     }
245 
246     /**
247      * @dev Internal function that burns an amount of the token of a given
248      * account, deducting from the sender's allowance for said account. Uses the
249      * internal burn function.
250      * Emits an Approval event (reflecting the reduced allowance).
251      * @param account The account whose tokens will be burnt.
252      * @param value The amount that will be burnt.
253      */
254     function _burnFrom(address account, uint256 value) internal {
255         _burn(account, value);
256         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
257     }
258 }
259 
260 
261 
262 /**
263  * @title Burnable Token
264  * @dev Token that can be irreversibly burned (destroyed).
265  */
266 contract ERC20Burnable is ERC20 {
267     /**
268      * @dev Burns a specific amount of tokens.
269      * @param value The amount of token to be burned.
270      */
271     function burn(uint256 value) public {
272         _burn(msg.sender, value);
273     }
274 
275     /**
276      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
277      * @param from address The account whose tokens will be burned.
278      * @param value uint256 The amount of token to be burned.
279      */
280     function burnFrom(address from, uint256 value) public {
281         _burnFrom(from, value);
282     }
283 }
284 
285 /**
286  * @title ERC20Detailed token
287  * @dev The decimals are only for visualization purposes.
288  * All the operations are done using the smallest and indivisible token unit,
289  * just as on Ethereum all the operations are done in wei.
290  */
291 contract ERC20Detailed is IERC20 {
292     string private _name;
293     string private _symbol;
294     uint8 private _decimals;
295 
296     constructor (string memory name, string memory symbol, uint8 decimals) public {
297         _name = name;
298         _symbol = symbol;
299         _decimals = decimals;
300     }
301 
302     /**
303      * @return the name of the token.
304      */
305     function name() public view returns (string memory) {
306         return _name;
307     }
308 
309     /**
310      * @return the symbol of the token.
311      */
312     function symbol() public view returns (string memory) {
313         return _symbol;
314     }
315 
316     /**
317      * @return the number of decimals of the token.
318      */
319     function decimals() public view returns (uint8) {
320         return _decimals;
321     }
322 }
323 
324 /**
325  * @title tranToken
326  * Note they can later distribute these tokens as they wish using `transfer` and other
327  * `ERC20` functions.
328  */
329 contract GEToken is ERC20, ERC20Burnable, ERC20Detailed {
330     uint8 public constant DECIMALS = 18;
331     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(DECIMALS)); 
332 
333     /**
334      * @dev Constructor that gives msg.sender all of existing tokens.
335      */
336     constructor () public ERC20Detailed("GEToken", "GET", 18) {
337         _mint(msg.sender, INITIAL_SUPPLY); 
338     }
339 }