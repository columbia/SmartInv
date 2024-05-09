1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     function transfer(address to, uint256 value) external returns (bool);
17 
18     function approve(address spender, uint256 value) external returns (bool);
19 
20     function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     int256 constant private INT256_MIN = -2**255;
37 
38     /**
39     * @dev Multiplies two unsigned integers, reverts on overflow.
40     */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     /**
56     * @dev Multiplies two signed integers, reverts on overflow.
57     */
58     function mul(int256 a, int256 b) internal pure returns (int256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
67 
68         int256 c = a * b;
69         require(c / a == b);
70 
71         return c;
72     }
73 
74     /**
75     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
76     */
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Solidity only automatically asserts when dividing by 0
79         require(b > 0);
80         uint256 c = a / b;
81         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82 
83         return c;
84     }
85 
86     /**
87     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
88     */
89     function div(int256 a, int256 b) internal pure returns (int256) {
90         require(b != 0); // Solidity only automatically asserts when dividing by 0
91         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
92 
93         int256 c = a / b;
94 
95         return c;
96     }
97 
98     /**
99     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
100     */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b <= a);
103         uint256 c = a - b;
104 
105         return c;
106     }
107 
108     /**
109     * @dev Subtracts two signed integers, reverts on overflow.
110     */
111     function sub(int256 a, int256 b) internal pure returns (int256) {
112         int256 c = a - b;
113         require((b >= 0 && c <= a) || (b < 0 && c > a));
114 
115         return c;
116     }
117 
118     /**
119     * @dev Adds two unsigned integers, reverts on overflow.
120     */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a);
124 
125         return c;
126     }
127 
128     /**
129     * @dev Adds two signed integers, reverts on overflow.
130     */
131     function add(int256 a, int256 b) internal pure returns (int256) {
132         int256 c = a + b;
133         require((b >= 0 && c >= a) || (b < 0 && c < a));
134 
135         return c;
136     }
137 
138     /**
139     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
140     * reverts when dividing by zero.
141     */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         require(b != 0);
144         return a % b;
145     }
146 }
147 
148 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
149 
150 pragma solidity ^0.5.0;
151 
152 
153 
154 /**
155  * @title Standard ERC20 token
156  *
157  * @dev Implementation of the basic standard token.
158  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
159  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  *
161  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
162  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
163  * compliant implementations may not do it.
164  */
165 contract ERC20 is IERC20 {
166     using SafeMath for uint256;
167 
168     mapping (address => uint256) private _balances;
169 
170     mapping (address => mapping (address => uint256)) private _allowed;
171 
172     uint256 private _totalSupply;
173 
174     /**
175     * @dev Total number of tokens in existence
176     */
177     function totalSupply() public view returns (uint256) {
178         return _totalSupply;
179     }
180 
181     /**
182     * @dev Gets the balance of the specified address.
183     * @param owner The address to query the balance of.
184     * @return An uint256 representing the amount owned by the passed address.
185     */
186     function balanceOf(address owner) public view returns (uint256) {
187         return _balances[owner];
188     }
189 
190     /**
191      * @dev Function to check the amount of tokens that an owner allowed to a spender.
192      * @param owner address The address which owns the funds.
193      * @param spender address The address which will spend the funds.
194      * @return A uint256 specifying the amount of tokens still available for the spender.
195      */
196     function allowance(address owner, address spender) public view returns (uint256) {
197         return _allowed[owner][spender];
198     }
199 
200     /**
201     * @dev Transfer token for a specified address
202     * @param to The address to transfer to.
203     * @param value The amount to be transferred.
204     */
205     function transfer(address to, uint256 value) public returns (bool) {
206         _transfer(msg.sender, to, value);
207         return true;
208     }
209 
210     /**
211      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212      * Beware that changing an allowance with this method brings the risk that someone may use both the old
213      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216      * @param spender The address which will spend the funds.
217      * @param value The amount of tokens to be spent.
218      */
219     function approve(address spender, uint256 value) public returns (bool) {
220         require(spender != address(0));
221 
222         _allowed[msg.sender][spender] = value;
223         emit Approval(msg.sender, spender, value);
224         return true;
225     }
226 
227     /**
228      * @dev Transfer tokens from one address to another.
229      * Note that while this function emits an Approval event, this is not required as per the specification,
230      * and other compliant implementations may not emit the event.
231      * @param from address The address which you want to send tokens from
232      * @param to address The address which you want to transfer to
233      * @param value uint256 the amount of tokens to be transferred
234      */
235     function transferFrom(address from, address to, uint256 value) public returns (bool) {
236         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
237         _transfer(from, to, value);
238         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
239         return true;
240     }
241 
242     /**
243      * @dev Increase the amount of tokens that an owner allowed to a spender.
244      * approve should be called when allowed_[_spender] == 0. To increment
245      * allowed value is better to use this function to avoid 2 calls (and wait until
246      * the first transaction is mined)
247      * From MonolithDAO Token.sol
248      * Emits an Approval event.
249      * @param spender The address which will spend the funds.
250      * @param addedValue The amount of tokens to increase the allowance by.
251      */
252     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
253         require(spender != address(0));
254 
255         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
256         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
257         return true;
258     }
259 
260     /**
261      * @dev Decrease the amount of tokens that an owner allowed to a spender.
262      * approve should be called when allowed_[_spender] == 0. To decrement
263      * allowed value is better to use this function to avoid 2 calls (and wait until
264      * the first transaction is mined)
265      * From MonolithDAO Token.sol
266      * Emits an Approval event.
267      * @param spender The address which will spend the funds.
268      * @param subtractedValue The amount of tokens to decrease the allowance by.
269      */
270     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
271         require(spender != address(0));
272 
273         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
274         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
275         return true;
276     }
277 
278     /**
279     * @dev Transfer token for a specified addresses
280     * @param from The address to transfer from.
281     * @param to The address to transfer to.
282     * @param value The amount to be transferred.
283     */
284     function _transfer(address from, address to, uint256 value) internal {
285         require(to != address(0));
286 
287         _balances[from] = _balances[from].sub(value);
288         _balances[to] = _balances[to].add(value);
289         emit Transfer(from, to, value);
290     }
291 
292     /**
293      * @dev Internal function that mints an amount of the token and assigns it to
294      * an account. This encapsulates the modification of balances such that the
295      * proper events are emitted.
296      * @param account The account that will receive the created tokens.
297      * @param value The amount that will be created.
298      */
299     function _mint(address account, uint256 value) internal {
300         require(account != address(0));
301 
302         _totalSupply = _totalSupply.add(value);
303         _balances[account] = _balances[account].add(value);
304         emit Transfer(address(0), account, value);
305     }
306 
307     /**
308      * @dev Internal function that burns an amount of the token of a given
309      * account.
310      * @param account The account whose tokens will be burnt.
311      * @param value The amount that will be burnt.
312      */
313     function _burn(address account, uint256 value) internal {
314         require(account != address(0));
315 
316         _totalSupply = _totalSupply.sub(value);
317         _balances[account] = _balances[account].sub(value);
318         emit Transfer(account, address(0), value);
319     }
320 
321     /**
322      * @dev Internal function that burns an amount of the token of a given
323      * account, deducting from the sender's allowance for said account. Uses the
324      * internal burn function.
325      * Emits an Approval event (reflecting the reduced allowance).
326      * @param account The account whose tokens will be burnt.
327      * @param value The amount that will be burnt.
328      */
329     function _burnFrom(address account, uint256 value) internal {
330         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
331         _burn(account, value);
332         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
333     }
334 }
335 
336 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
337 
338 pragma solidity ^0.5.0;
339 
340 
341 /**
342  * @title ERC20Detailed token
343  * @dev The decimals are only for visualization purposes.
344  * All the operations are done using the smallest and indivisible token unit,
345  * just as on Ethereum all the operations are done in wei.
346  */
347 contract ERC20Detailed is IERC20 {
348     string private _name;
349     string private _symbol;
350     uint8 private _decimals;
351 
352     constructor (string memory name, string memory symbol, uint8 decimals) public {
353         _name = name;
354         _symbol = symbol;
355         _decimals = decimals;
356     }
357 
358     /**
359      * @return the name of the token.
360      */
361     function name() public view returns (string memory) {
362         return _name;
363     }
364 
365     /**
366      * @return the symbol of the token.
367      */
368     function symbol() public view returns (string memory) {
369         return _symbol;
370     }
371 
372     /**
373      * @return the number of decimals of the token.
374      */
375     function decimals() public view returns (uint8) {
376         return _decimals;
377     }
378 }
379 
380 // File: contracts/KoolToken.sol
381 
382 pragma solidity ^0.5.0;
383 
384 
385 
386 contract KoolToken is ERC20, ERC20Detailed {
387   constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _supply) 
388   ERC20Detailed(_name, _symbol, _decimals)
389   ERC20()
390   public {
391     require(_supply > 0, "amount has to be greater than 0");
392     uint256 total = _supply.mul(10 ** uint256(_decimals));
393     _mint(msg.sender, total);
394   }
395 }