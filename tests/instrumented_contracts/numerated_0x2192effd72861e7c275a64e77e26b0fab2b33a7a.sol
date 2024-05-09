1 /**
2  *  Interdax Token - 2019
3  *  Based on OpenZeppelin's secure ERC20 libs
4  */
5 
6 
7 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
8 
9 pragma solidity ^0.5.2;
10 
11 /**
12  * @title ERC20 interface
13  * @dev see https://eips.ethereum.org/EIPS/eip-20
14  */
15 interface IERC20 {
16     function transfer(address to, uint256 value) external returns (bool);
17 
18     function approve(address spender, uint256 value) external returns (bool);
19 
20     function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address who) external view returns (uint256);
25 
26     function allowance(address owner, address spender) external view returns (uint256);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
34 
35 pragma solidity ^0.5.2;
36 
37 /**
38  * @title SafeMath
39  * @dev Unsigned math operations with safety checks that revert on error
40  */
41 library SafeMath {
42     /**
43      * @dev Multiplies two unsigned integers, reverts on overflow.
44      */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
61      */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Solidity only automatically asserts when dividing by 0
64         require(b > 0);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     /**
72      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73      */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82      * @dev Adds two unsigned integers, reverts on overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a);
87 
88         return c;
89     }
90 
91     /**
92      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
93      * reverts when dividing by zero.
94      */
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b != 0);
97         return a % b;
98     }
99 }
100 
101 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
102 
103 pragma solidity ^0.5.2;
104 
105 
106 
107 /**
108  * @title Standard ERC20 token
109  *
110  * @dev Implementation of the basic standard token.
111  * https://eips.ethereum.org/EIPS/eip-20
112  * Originally based on code by FirstBlood:
113  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114  *
115  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
116  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
117  * compliant implementations may not do it.
118  */
119 contract ERC20 is IERC20 {
120     using SafeMath for uint256;
121 
122     mapping (address => uint256) private _balances;
123 
124     mapping (address => mapping (address => uint256)) private _allowed;
125 
126     uint256 private _totalSupply;
127 
128     /**
129      * @dev Total number of tokens in existence
130      */
131     function totalSupply() public view returns (uint256) {
132         return _totalSupply;
133     }
134 
135     /**
136      * @dev Gets the balance of the specified address.
137      * @param owner The address to query the balance of.
138      * @return A uint256 representing the amount owned by the passed address.
139      */
140     function balanceOf(address owner) public view returns (uint256) {
141         return _balances[owner];
142     }
143 
144     /**
145      * @dev Function to check the amount of tokens that an owner allowed to a spender.
146      * @param owner address The address which owns the funds.
147      * @param spender address The address which will spend the funds.
148      * @return A uint256 specifying the amount of tokens still available for the spender.
149      */
150     function allowance(address owner, address spender) public view returns (uint256) {
151         return _allowed[owner][spender];
152     }
153 
154     /**
155      * @dev Transfer token to a specified address
156      * @param to The address to transfer to.
157      * @param value The amount to be transferred.
158      */
159     function transfer(address to, uint256 value) public returns (bool) {
160         _transfer(msg.sender, to, value);
161         return true;
162     }
163 
164     /**
165      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166      * Beware that changing an allowance with this method brings the risk that someone may use both the old
167      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      * @param spender The address which will spend the funds.
171      * @param value The amount of tokens to be spent.
172      */
173     function approve(address spender, uint256 value) public returns (bool) {
174         _approve(msg.sender, spender, value);
175         return true;
176     }
177 
178     /**
179      * @dev Transfer tokens from one address to another.
180      * Note that while this function emits an Approval event, this is not required as per the specification,
181      * and other compliant implementations may not emit the event.
182      * @param from address The address which you want to send tokens from
183      * @param to address The address which you want to transfer to
184      * @param value uint256 the amount of tokens to be transferred
185      */
186     function transferFrom(address from, address to, uint256 value) public returns (bool) {
187         _transfer(from, to, value);
188         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
189         return true;
190     }
191 
192     /**
193      * @dev Increase the amount of tokens that an owner allowed to a spender.
194      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      * Emits an Approval event.
199      * @param spender The address which will spend the funds.
200      * @param addedValue The amount of tokens to increase the allowance by.
201      */
202     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
203         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
204         return true;
205     }
206 
207     /**
208      * @dev Decrease the amount of tokens that an owner allowed to a spender.
209      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
210      * allowed value is better to use this function to avoid 2 calls (and wait until
211      * the first transaction is mined)
212      * From MonolithDAO Token.sol
213      * Emits an Approval event.
214      * @param spender The address which will spend the funds.
215      * @param subtractedValue The amount of tokens to decrease the allowance by.
216      */
217     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
218         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
219         return true;
220     }
221 
222     /**
223      * @dev Transfer token for a specified addresses
224      * @param from The address to transfer from.
225      * @param to The address to transfer to.
226      * @param value The amount to be transferred.
227      */
228     function _transfer(address from, address to, uint256 value) internal {
229         require(to != address(0));
230 
231         _balances[from] = _balances[from].sub(value);
232         _balances[to] = _balances[to].add(value);
233         emit Transfer(from, to, value);
234     }
235 
236     /**
237      * @dev Internal function that mints an amount of the token and assigns it to
238      * an account. This encapsulates the modification of balances such that the
239      * proper events are emitted.
240      * @param account The account that will receive the created tokens.
241      * @param value The amount that will be created.
242      */
243     function _mint(address account, uint256 value) internal {
244         require(account != address(0));
245 
246         _totalSupply = _totalSupply.add(value);
247         _balances[account] = _balances[account].add(value);
248         emit Transfer(address(0), account, value);
249     }
250 
251     /**
252      * @dev Internal function that burns an amount of the token of a given
253      * account.
254      * @param account The account whose tokens will be burnt.
255      * @param value The amount that will be burnt.
256      */
257     function _burn(address account, uint256 value) internal {
258         require(account != address(0));
259 
260         _totalSupply = _totalSupply.sub(value);
261         _balances[account] = _balances[account].sub(value);
262         emit Transfer(account, address(0), value);
263     }
264 
265     /**
266      * @dev Approve an address to spend another addresses' tokens.
267      * @param owner The address that owns the tokens.
268      * @param spender The address that will spend the tokens.
269      * @param value The number of tokens that can be spent.
270      */
271     function _approve(address owner, address spender, uint256 value) internal {
272         require(spender != address(0));
273         require(owner != address(0));
274 
275         _allowed[owner][spender] = value;
276         emit Approval(owner, spender, value);
277     }
278 
279     /**
280      * @dev Internal function that burns an amount of the token of a given
281      * account, deducting from the sender's allowance for said account. Uses the
282      * internal burn function.
283      * Emits an Approval event (reflecting the reduced allowance).
284      * @param account The account whose tokens will be burnt.
285      * @param value The amount that will be burnt.
286      */
287     function _burnFrom(address account, uint256 value) internal {
288         _burn(account, value);
289         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
290     }
291 }
292 
293 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
294 
295 pragma solidity ^0.5.2;
296 
297 
298 /**
299  * @title ERC20Detailed token
300  * @dev The decimals are only for visualization purposes.
301  * All the operations are done using the smallest and indivisible token unit,
302  * just as on Ethereum all the operations are done in wei.
303  */
304 contract ERC20Detailed is IERC20 {
305     string private _name;
306     string private _symbol;
307     uint8 private _decimals;
308 
309     constructor (string memory name, string memory symbol, uint8 decimals) public {
310         _name = name;
311         _symbol = symbol;
312         _decimals = decimals;
313     }
314 
315     /**
316      * @return the name of the token.
317      */
318     function name() public view returns (string memory) {
319         return _name;
320     }
321 
322     /**
323      * @return the symbol of the token.
324      */
325     function symbol() public view returns (string memory) {
326         return _symbol;
327     }
328 
329     /**
330      * @return the number of decimals of the token.
331      */
332     function decimals() public view returns (uint8) {
333         return _decimals;
334     }
335 }
336 
337 // File: contracts/InterdaxToken.sol
338 
339 pragma solidity ^0.5.0;
340 
341 
342 
343 /**
344  * @title Interdax Token
345  * @dev Standard ERC20 Token where all tokens are allocated to the issuer.
346  */
347 contract InterdaxToken is ERC20, ERC20Detailed {
348     // Token name
349     string public constant NAME = "Interdax Token";
350     // Token symbol
351     string public constant SYMBOL = "ITDX";
352     // Token decimals
353     uint8 public constant DECIMALS = 18;
354     // Initial token supply
355     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(DECIMALS)); // 10 Billion tokens
356 
357     /**
358      * @dev Constructor assigning the sender all the token supply.
359      */
360     constructor () public ERC20Detailed(NAME, SYMBOL, DECIMALS) {
361         _mint(msg.sender, INITIAL_SUPPLY);
362     }
363 }