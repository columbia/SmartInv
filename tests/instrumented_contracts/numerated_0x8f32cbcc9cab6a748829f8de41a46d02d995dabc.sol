1 pragma solidity ^0.4.24;
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     int256 constant private INT256_MIN = -2**255;
11 
12     /**
13     * @dev Multiplies two unsigned integers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Multiplies two signed integers, reverts on overflow.
31     */
32     function mul(int256 a, int256 b) internal pure returns (int256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (a == 0) {
37             return 0;
38         }
39 
40         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
41 
42         int256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
62     */
63     function div(int256 a, int256 b) internal pure returns (int256) {
64         require(b != 0); // Solidity only automatically asserts when dividing by 0
65         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
66 
67         int256 c = a / b;
68 
69         return c;
70     }
71 
72     /**
73     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74     */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b <= a);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83     * @dev Subtracts two signed integers, reverts on overflow.
84     */
85     function sub(int256 a, int256 b) internal pure returns (int256) {
86         int256 c = a - b;
87         require((b >= 0 && c <= a) || (b < 0 && c > a));
88 
89         return c;
90     }
91 
92     /**
93     * @dev Adds two unsigned integers, reverts on overflow.
94     */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Adds two signed integers, reverts on overflow.
104     */
105     function add(int256 a, int256 b) internal pure returns (int256) {
106         int256 c = a + b;
107         require((b >= 0 && c >= a) || (b < 0 && c < a));
108 
109         return c;
110     }
111 
112     /**
113     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
114     * reverts when dividing by zero.
115     */
116     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b != 0);
118         return a % b;
119     }
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126  interface IERC20 {
127     function totalSupply() external view returns (uint256);
128 
129     function balanceOf(address who) external view returns (uint256);
130 
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     function transfer(address to, uint256 value) external returns (bool);
134 
135     function approve(address spender, uint256 value) external returns (bool);
136 
137     function transferFrom(address from, address to, uint256 value) external returns (bool);
138 
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
149  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  *
151  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
152  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
153  * compliant implementations may not do it.
154  */
155 contract ERC20 is IERC20 {
156     using SafeMath for uint256;
157 
158     mapping (address => uint256) private _balances;
159 
160     mapping (address => mapping (address => uint256)) private _allowed;
161 
162     uint256 private _totalSupply;
163 
164     /**
165     * @dev Total number of tokens in existence
166     */
167     function totalSupply() public view returns (uint256) {
168         return _totalSupply;
169     }
170 
171     /**
172     * @dev Gets the balance of the specified address.
173     * @param owner The address to query the balance of.
174     * @return An uint256 representing the amount owned by the passed address.
175     */
176     function balanceOf(address owner) public view returns (uint256) {
177         return _balances[owner];
178     }
179 
180     /**
181      * @dev Function to check the amount of tokens that an owner allowed to a spender.
182      * @param owner address The address which owns the funds.
183      * @param spender address The address which will spend the funds.
184      * @return A uint256 specifying the amount of tokens still available for the spender.
185      */
186     function allowance(address owner, address spender) public view returns (uint256) {
187         return _allowed[owner][spender];
188     }
189 
190     /**
191     * @dev Transfer token for a specified address
192     * @param to The address to transfer to.
193     * @param value The amount to be transferred.
194     */
195     function transfer(address to, uint256 value) public returns (bool) {
196         _transfer(msg.sender, to, value);
197         return true;
198     }
199 
200     /**
201      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202      * Beware that changing an allowance with this method brings the risk that someone may use both the old
203      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206      * @param spender The address which will spend the funds.
207      * @param value The amount of tokens to be spent.
208      */
209     function approve(address spender, uint256 value) public returns (bool) {
210         require(spender != address(0));
211 
212         _allowed[msg.sender][spender] = value;
213         emit Approval(msg.sender, spender, value);
214         return true;
215     }
216 
217     /**
218      * @dev Transfer tokens from one address to another.
219      * Note that while this function emits an Approval event, this is not required as per the specification,
220      * and other compliant implementations may not emit the event.
221      * @param from address The address which you want to send tokens from
222      * @param to address The address which you want to transfer to
223      * @param value uint256 the amount of tokens to be transferred
224      */
225     function transferFrom(address from, address to, uint256 value) public returns (bool) {
226         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
227         _transfer(from, to, value);
228         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
229         return true;
230     }
231 
232     /**
233      * @dev Increase the amount of tokens that an owner allowed to a spender.
234      * approve should be called when allowed_[_spender] == 0. To increment
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * From MonolithDAO Token.sol
238      * Emits an Approval event.
239      * @param spender The address which will spend the funds.
240      * @param addedValue The amount of tokens to increase the allowance by.
241      */
242     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
243         require(spender != address(0));
244 
245         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
246         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
247         return true;
248     }
249 
250     /**
251      * @dev Decrease the amount of tokens that an owner allowed to a spender.
252      * approve should be called when allowed_[_spender] == 0. To decrement
253      * allowed value is better to use this function to avoid 2 calls (and wait until
254      * the first transaction is mined)
255      * From MonolithDAO Token.sol
256      * Emits an Approval event.
257      * @param spender The address which will spend the funds.
258      * @param subtractedValue The amount of tokens to decrease the allowance by.
259      */
260     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
261         require(spender != address(0));
262 
263         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
264         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
265         return true;
266     }
267 
268     /**
269     * @dev Transfer token for a specified addresses
270     * @param from The address to transfer from.
271     * @param to The address to transfer to.
272     * @param value The amount to be transferred.
273     */
274     function _transfer(address from, address to, uint256 value) internal {
275         require(to != address(0));
276 
277         _balances[from] = _balances[from].sub(value);
278         _balances[to] = _balances[to].add(value);
279         emit Transfer(from, to, value);
280     }
281 
282     /**
283      * @dev Internal function that mints an amount of the token and assigns it to
284      * an account. This encapsulates the modification of balances such that the
285      * proper events are emitted.
286      * @param account The account that will receive the created tokens.
287      * @param value The amount that will be created.
288      */
289     function _mint(address account, uint256 value) internal {
290         require(account != address(0));
291 
292         _totalSupply = _totalSupply.add(value);
293         _balances[account] = _balances[account].add(value);
294         emit Transfer(address(0), account, value);
295     }
296 
297     /**
298      * @dev Internal function that burns an amount of the token of a given
299      * account.
300      * @param account The account whose tokens will be burnt.
301      * @param value The amount that will be burnt.
302      */
303     function _burn(address account, uint256 value) internal {
304         require(account != address(0));
305 
306         _totalSupply = _totalSupply.sub(value);
307         _balances[account] = _balances[account].sub(value);
308         emit Transfer(account, address(0), value);
309     }
310 
311     /**
312      * @dev Internal function that burns an amount of the token of a given
313      * account, deducting from the sender's allowance for said account. Uses the
314      * internal burn function.
315      * Emits an Approval event (reflecting the reduced allowance).
316      * @param account The account whose tokens will be burnt.
317      * @param value The amount that will be burnt.
318      */
319     function _burnFrom(address account, uint256 value) internal {
320         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
321         _burn(account, value);
322         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
323     }
324 }
325 
326 contract ERC20Burnable is ERC20 {
327     /**
328      * @dev Burns a specific amount of tokens.
329      * @param value The amount of token to be burned.
330      */
331     function burn(uint256 value) public {
332         _burn(msg.sender, value);
333     }
334 
335     /**
336      * @dev Burns a specific amount of tokens from the target address and decrements allowance
337      * @param from address The address which you want to send tokens from
338      * @param value uint256 The amount of token to be burned
339      */
340     function burnFrom(address from, uint256 value) public {
341         _burnFrom(from, value);
342     }
343 }
344 
345 /**
346  * @title ERC20Detailed token
347  * @dev The decimals are only for visualization purposes.
348  * All the operations are done using the smallest and indivisible token unit,
349  * just as on Ethereum all the operations are done in wei.
350  */
351 contract ERC20Detailed is IERC20 {
352     string private _name;
353     string private _symbol;
354     uint8 private _decimals;
355 
356     constructor (string name, string symbol, uint8 decimals) public {
357         _name = name;
358         _symbol = symbol;
359         _decimals = decimals;
360     }
361 
362     /**
363      * @return the name of the token.
364      */
365     function name() public view returns (string) {
366         return _name;
367     }
368 
369     /**
370      * @return the symbol of the token.
371      */
372     function symbol() public view returns (string) {
373         return _symbol;
374     }
375 
376     /**
377      * @return the number of decimals of the token.
378      */
379     function decimals() public view returns (uint8) {
380         return _decimals;
381     }
382 }
383 
384 /**
385  * @title SimpleToken
386  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
387  * Note they can later distribute these tokens as they wish using `transfer` and other
388  * `ERC20` functions.
389  */
390 contract DflowToken is ERC20, ERC20Detailed, ERC20Burnable {
391     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals()));
392 
393     /**
394      * @dev Constructor that gives msg.sender all of existing tokens.
395      */
396     constructor () public ERC20Detailed("Dflow", "DFL", 8) {
397         _mint(msg.sender, INITIAL_SUPPLY);
398     }
399 }