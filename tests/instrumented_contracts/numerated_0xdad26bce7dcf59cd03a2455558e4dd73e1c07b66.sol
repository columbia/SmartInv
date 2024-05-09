1 /**
2  * Website: https://trade.win 
3  * Telegram: https://t.me/tradewin_chat
4  * Twitter: https://twitter.com/tradewin_twi
5 */
6 pragma solidity ^0.5.2;
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://eips.ethereum.org/EIPS/eip-20
11  */
12 interface IERC20 {
13     function transfer(address to, uint256 value) external returns (bool);
14 
15     function approve(address spender, uint256 value) external returns (bool);
16 
17     function transferFrom(address from, address to, uint256 value) external returns (bool);
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address who) external view returns (uint256);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
31 
32 pragma solidity ^0.5.2;
33 
34 /**
35  * @title SafeMath
36  * @dev Unsigned math operations with safety checks that revert on error
37  */
38 library SafeMath {
39     /**
40      * @dev Multiplies two unsigned integers, reverts on overflow.
41      */
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44         // benefit is lost if 'b' is also tested.
45         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
46         if (a == 0) {
47             return 0;
48         }
49 
50         uint256 c = a * b;
51         require(c / a == b);
52 
53         return c;
54     }
55 
56     /**
57      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
58      */
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Solidity only automatically asserts when dividing by 0
61         require(b > 0);
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64 
65         return c;
66     }
67 
68     /**
69      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Adds two unsigned integers, reverts on overflow.
80      */
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a);
84 
85         return c;
86     }
87 
88     /**
89      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
90      * reverts when dividing by zero.
91      */
92     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
93         require(b != 0);
94         return a % b;
95     }
96 }
97 
98 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
99 
100 pragma solidity ^0.5.2;
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://eips.ethereum.org/EIPS/eip-20
107  *
108  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
109  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
110  * compliant implementations may not do it.
111  */
112 contract ERC20 is IERC20 {
113     using SafeMath for uint256;
114 
115     mapping (address => uint256) private _balances;
116 
117     mapping (address => mapping (address => uint256)) private _allowed;
118 
119     uint256 private _totalSupply;
120 
121     /**
122      * @dev Total number of tokens in existence
123      */
124     function totalSupply() public view returns (uint256) {
125         return _totalSupply;
126     }
127 
128     /**
129      * @dev Gets the balance of the specified address.
130      * @param owner The address to query the balance of.
131      * @return A uint256 representing the amount owned by the passed address.
132      */
133     function balanceOf(address owner) public view returns (uint256) {
134         return _balances[owner];
135     }
136 
137     /**
138      * @dev Function to check the amount of tokens that an owner allowed to a spender.
139      * @param owner address The address which owns the funds.
140      * @param spender address The address which will spend the funds.
141      * @return A uint256 specifying the amount of tokens still available for the spender.
142      */
143     function allowance(address owner, address spender) public view returns (uint256) {
144         return _allowed[owner][spender];
145     }
146 
147     /**
148      * @dev Transfer token to a specified address
149      * @param to The address to transfer to.
150      * @param value The amount to be transferred.
151      */
152     function transfer(address to, uint256 value) public returns (bool) {
153         _transfer(msg.sender, to, value);
154         return true;
155     }
156 
157     /**
158      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159      * Beware that changing an allowance with this method brings the risk that someone may use both the old
160      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      * @param spender The address which will spend the funds.
164      * @param value The amount of tokens to be spent.
165      */
166     function approve(address spender, uint256 value) public returns (bool) {
167         _approve(msg.sender, spender, value);
168         return true;
169     }
170 
171     /**
172      * @dev Transfer tokens from one address to another.
173      * Note that while this function emits an Approval event, this is not required as per the specification,
174      * and other compliant implementations may not emit the event.
175      * @param from address The address which you want to send tokens from
176      * @param to address The address which you want to transfer to
177      * @param value uint256 the amount of tokens to be transferred
178      */
179     function transferFrom(address from, address to, uint256 value) public returns (bool) {
180         _transfer(from, to, value);
181         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
182         return true;
183     }
184 
185     /**
186      * @dev Increase the amount of tokens that an owner allowed to a spender.
187      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      * Emits an Approval event.
192      * @param spender The address which will spend the funds.
193      * @param addedValue The amount of tokens to increase the allowance by.
194      */
195     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
196         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
197         return true;
198     }
199 
200     /**
201      * @dev Decrease the amount of tokens that an owner allowed to a spender.
202      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * Emits an Approval event.
207      * @param spender The address which will spend the funds.
208      * @param subtractedValue The amount of tokens to decrease the allowance by.
209      */
210     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
211         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
212         return true;
213     }
214 
215     /**
216      * @dev Transfer token for a specified addresses
217      * @param from The address to transfer from.
218      * @param to The address to transfer to.
219      * @param value The amount to be transferred.
220      */
221     function _transfer(address from, address to, uint256 value) internal {
222         require(to != address(0));
223 
224         _balances[from] = _balances[from].sub(value);
225         _balances[to] = _balances[to].add(value);
226         emit Transfer(from, to, value);
227     }
228 
229     /**
230      * @dev Internal function that mints an amount of the token and assigns it to
231      * an account. This encapsulates the modification of balances such that the
232      * proper events are emitted.
233      * @param account The account that will receive the created tokens.
234      * @param value The amount that will be created.
235      */
236     function _mint(address account, uint256 value) internal {
237         require(account != address(0));
238 
239         _totalSupply = _totalSupply.add(value);
240         _balances[account] = _balances[account].add(value);
241         emit Transfer(address(0), account, value);
242     }
243 
244     /**
245      * @dev Internal function that burns an amount of the token of a given
246      * account.
247      * @param account The account whose tokens will be burnt.
248      * @param value The amount that will be burnt.
249      */
250     function _burn(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.sub(value);
254         _balances[account] = _balances[account].sub(value);
255         emit Transfer(account, address(0), value);
256     }
257 
258     /**
259      * @dev Approve an address to spend another addresses' tokens.
260      * @param owner The address that owns the tokens.
261      * @param spender The address that will spend the tokens.
262      * @param value The number of tokens that can be spent.
263      */
264     function _approve(address owner, address spender, uint256 value) internal {
265         require(spender != address(0));
266         require(owner != address(0));
267 
268         _allowed[owner][spender] = value;
269         emit Approval(owner, spender, value);
270     }
271 
272     /**
273      * @dev Internal function that burns an amount of the token of a given
274      * account, deducting from the sender's allowance for said account. Uses the
275      * internal burn function.
276      * Emits an Approval event (reflecting the reduced allowance).
277      * @param account The account whose tokens will be burnt.
278      * @param value The amount that will be burnt.
279      */
280     function _burnFrom(address account, uint256 value) internal {
281         _burn(account, value);
282         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
283     }
284 }
285 
286 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
287 
288 pragma solidity ^0.5.2;
289 
290 
291 /**
292  * @title ERC20Detailed token
293  * @dev The decimals are only for visualization purposes.
294  * All the operations are done using the smallest and indivisible token unit,
295  * just as on Ethereum all the operations are done in wei.
296  */
297 contract ERC20Detailed is IERC20 {
298     string private _name;
299     string private _symbol;
300     uint8 private _decimals;
301 
302     constructor (string memory name, string memory symbol, uint8 decimals) public {
303         _name = name;
304         _symbol = symbol;
305         _decimals = decimals;
306     }
307 
308     /**
309      * @return the name of the token.
310      */
311     function name() public view returns (string memory) {
312         return _name;
313     }
314 
315     /**
316      * @return the symbol of the token.
317      */
318     function symbol() public view returns (string memory) {
319         return _symbol;
320     }
321 
322     /**
323      * @return the number of decimals of the token.
324      */
325     function decimals() public view returns (uint8) {
326         return _decimals;
327     }
328 }
329 
330 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
331 
332 pragma solidity ^0.5.2;
333 
334 
335 /**
336  * @title Burnable Token
337  * @dev Token that can be irreversibly burned (destroyed).
338  */
339 contract ERC20Burnable is ERC20 {
340     /**
341      * @dev Burns a specific amount of tokens.
342      * @param value The amount of token to be burned.
343      */
344     function burn(uint256 value) public {
345         _burn(msg.sender, value);
346     }
347 
348     /**
349      * @dev Burns a specific amount of tokens from the target address and decrements allowance
350      * @param from address The account whose tokens will be burned.
351      * @param value uint256 The amount of token to be burned.
352      */
353     function burnFrom(address from, uint256 value) public {
354         _burnFrom(from, value);
355     }
356 }
357 
358 // File: contracts/TWI.sol
359 
360 pragma solidity ^0.5.0;
361 
362 contract Tradewin is ERC20, ERC20Detailed, ERC20Burnable {
363     constructor() ERC20Detailed('Trade.win', 'TWI', 18) public {
364         _mint(msg.sender, 200_000 * 10 ** 18);
365     }
366 }