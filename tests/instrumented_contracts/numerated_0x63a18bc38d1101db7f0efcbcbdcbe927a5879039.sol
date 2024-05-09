1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-18
3 */
4 
5 
6 /**
7  *  TICKER       : EARN
8  *  TOKEN NAME   : Yearn Classic Token
9  *  TOTAL SUPPLY : 21000
10  *  (c) yearnclassic.finance
11 */
12 
13 pragma solidity ^0.5.2;
14 
15 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://eips.ethereum.org/EIPS/eip-20
20  */
21 interface IERC20 {
22     function transfer(address to, uint256 value) external returns (bool);
23 
24     function approve(address spender, uint256 value) external returns (bool);
25 
26     function transferFrom(address from, address to, uint256 value) external returns (bool);
27 
28     function totalSupply() external view returns (uint256);
29 
30     function balanceOf(address who) external view returns (uint256);
31 
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
40 
41 pragma solidity ^0.5.2;
42 
43 /**
44  * @title SafeMath
45  * @dev Unsigned math operations with safety checks that revert on error
46  */
47 library SafeMath {
48     /**
49      * @dev Multiplies two unsigned integers, reverts on overflow.
50      */
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53         // benefit is lost if 'b' is also tested.
54         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55         if (a == 0) {
56             return 0;
57         }
58 
59         uint256 c = a * b;
60         require(c / a == b);
61 
62         return c;
63     }
64 
65     /**
66      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
67      */
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         // Solidity only automatically asserts when dividing by 0
70         require(b > 0);
71         uint256 c = a / b;
72         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73 
74         return c;
75     }
76 
77     /**
78      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
79      */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b <= a);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     /**
88      * @dev Adds two unsigned integers, reverts on overflow.
89      */
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a);
93 
94         return c;
95     }
96 
97     /**
98      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
99      * reverts when dividing by zero.
100      */
101     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b != 0);
103         return a % b;
104     }
105 }
106 
107 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
108 
109 pragma solidity ^0.5.2;
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * https://eips.ethereum.org/EIPS/eip-20
116  *
117  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
118  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
119  * compliant implementations may not do it.
120  */
121 contract ERC20 is IERC20 {
122     using SafeMath for uint256;
123 
124     mapping (address => uint256) private _balances;
125 
126     mapping (address => mapping (address => uint256)) private _allowed;
127 
128     uint256 private _totalSupply;
129 
130     /**
131      * @dev Total number of tokens in existence
132      */
133     function totalSupply() public view returns (uint256) {
134         return _totalSupply;
135     }
136 
137     /**
138      * @dev Gets the balance of the specified address.
139      * @param owner The address to query the balance of.
140      * @return A uint256 representing the amount owned by the passed address.
141      */
142     function balanceOf(address owner) public view returns (uint256) {
143         return _balances[owner];
144     }
145 
146     /**
147      * @dev Function to check the amount of tokens that an owner allowed to a spender.
148      * @param owner address The address which owns the funds.
149      * @param spender address The address which will spend the funds.
150      * @return A uint256 specifying the amount of tokens still available for the spender.
151      */
152     function allowance(address owner, address spender) public view returns (uint256) {
153         return _allowed[owner][spender];
154     }
155 
156     /**
157      * @dev Transfer token to a specified address
158      * @param to The address to transfer to.
159      * @param value The amount to be transferred.
160      */
161     function transfer(address to, uint256 value) public returns (bool) {
162         _transfer(msg.sender, to, value);
163         return true;
164     }
165 
166     /**
167      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168      * Beware that changing an allowance with this method brings the risk that someone may use both the old
169      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172      * @param spender The address which will spend the funds.
173      * @param value The amount of tokens to be spent.
174      */
175     function approve(address spender, uint256 value) public returns (bool) {
176         _approve(msg.sender, spender, value);
177         return true;
178     }
179 
180     /**
181      * @dev Transfer tokens from one address to another.
182      * Note that while this function emits an Approval event, this is not required as per the specification,
183      * and other compliant implementations may not emit the event.
184      * @param from address The address which you want to send tokens from
185      * @param to address The address which you want to transfer to
186      * @param value uint256 the amount of tokens to be transferred
187      */
188     function transferFrom(address from, address to, uint256 value) public returns (bool) {
189         _transfer(from, to, value);
190         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
191         return true;
192     }
193 
194     /**
195      * @dev Increase the amount of tokens that an owner allowed to a spender.
196      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * Emits an Approval event.
201      * @param spender The address which will spend the funds.
202      * @param addedValue The amount of tokens to increase the allowance by.
203      */
204     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
205         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
206         return true;
207     }
208 
209     /**
210      * @dev Decrease the amount of tokens that an owner allowed to a spender.
211      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
212      * allowed value is better to use this function to avoid 2 calls (and wait until
213      * the first transaction is mined)
214      * From MonolithDAO Token.sol
215      * Emits an Approval event.
216      * @param spender The address which will spend the funds.
217      * @param subtractedValue The amount of tokens to decrease the allowance by.
218      */
219     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
220         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
221         return true;
222     }
223 
224     /**
225      * @dev Transfer token for a specified addresses
226      * @param from The address to transfer from.
227      * @param to The address to transfer to.
228      * @param value The amount to be transferred.
229      */
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
268      * @dev Approve an address to spend another addresses' tokens.
269      * @param owner The address that owns the tokens.
270      * @param spender The address that will spend the tokens.
271      * @param value The number of tokens that can be spent.
272      */
273     function _approve(address owner, address spender, uint256 value) internal {
274         require(spender != address(0));
275         require(owner != address(0));
276 
277         _allowed[owner][spender] = value;
278         emit Approval(owner, spender, value);
279     }
280 
281     /**
282      * @dev Internal function that burns an amount of the token of a given
283      * account, deducting from the sender's allowance for said account. Uses the
284      * internal burn function.
285      * Emits an Approval event (reflecting the reduced allowance).
286      * @param account The account whose tokens will be burnt.
287      * @param value The amount that will be burnt.
288      */
289     function _burnFrom(address account, uint256 value) internal {
290         _burn(account, value);
291         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
292     }
293 }
294 
295 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
296 
297 pragma solidity ^0.5.2;
298 
299 
300 /**
301  * @title ERC20Detailed token
302  * @dev The decimals are only for visualization purposes.
303  * All the operations are done using the smallest and indivisible token unit,
304  * just as on Ethereum all the operations are done in wei.
305  */
306 contract ERC20Detailed is IERC20 {
307     string private _name;
308     string private _symbol;
309     uint8 private _decimals;
310 
311     constructor (string memory name, string memory symbol, uint8 decimals) public {
312         _name = name;
313         _symbol = symbol;
314         _decimals = decimals;
315     }
316 
317     /**
318      * @return the name of the token.
319      */
320     function name() public view returns (string memory) {
321         return _name;
322     }
323 
324     /**
325      * @return the symbol of the token.
326      */
327     function symbol() public view returns (string memory) {
328         return _symbol;
329     }
330 
331     /**
332      * @return the number of decimals of the token.
333      */
334     function decimals() public view returns (uint8) {
335         return _decimals;
336     }
337 }
338 
339 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
340 
341 pragma solidity ^0.5.2;
342 
343 
344 /**
345  * @title Burnable Token
346  * @dev Token that can be irreversibly burned (destroyed).
347  */
348 contract ERC20Burnable is ERC20 {
349     /**
350      * @dev Burns a specific amount of tokens.
351      * @param value The amount of token to be burned.
352      */
353     function burn(uint256 value) public {
354         _burn(msg.sender, value);
355     }
356 
357     /**
358      * @dev Burns a specific amount of tokens from the target address and decrements allowance
359      * @param from address The account whose tokens will be burned.
360      * @param value uint256 The amount of token to be burned.
361      */
362     function burnFrom(address from, uint256 value) public {
363         _burnFrom(from, value);
364     }
365 }
366 
367 // File: EARN.sol
368 
369 pragma solidity ^0.5.0;
370 
371 contract EARN is ERC20, ERC20Detailed, ERC20Burnable {
372     constructor() ERC20Detailed('Yearn Classic', 'EARN', 18) public {
373         _mint(msg.sender, 21000 * 10 ** 18);
374     }
375 }