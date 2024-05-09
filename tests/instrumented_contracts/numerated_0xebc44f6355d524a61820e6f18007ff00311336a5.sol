1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that revert on error
4  */
5 library SafeMath {
6     int256 constant private INT256_MIN = -2**255;
7 
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
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
26     * @dev Multiplies two signed integers, reverts on overflow.
27     */
28     function mul(int256 a, int256 b) internal pure returns (int256) {
29         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
30         // benefit is lost if 'b' is also tested.
31         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32         if (a == 0) {
33             return 0;
34         }
35 
36         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
37 
38         int256 c = a * b;
39         require(c / a == b);
40 
41         return c;
42     }
43 
44     /**
45     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
46     */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Solidity only automatically asserts when dividing by 0
49         require(b > 0);
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53         return c;
54     }
55 
56     /**
57     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
58     */
59     function div(int256 a, int256 b) internal pure returns (int256) {
60         require(b != 0); // Solidity only automatically asserts when dividing by 0
61         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
62 
63         int256 c = a / b;
64 
65         return c;
66     }
67 
68     /**
69     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
70     */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79     * @dev Subtracts two signed integers, reverts on overflow.
80     */
81     function sub(int256 a, int256 b) internal pure returns (int256) {
82         int256 c = a - b;
83         require((b >= 0 && c <= a) || (b < 0 && c > a));
84 
85         return c;
86     }
87 
88     /**
89     * @dev Adds two unsigned integers, reverts on overflow.
90     */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a);
94 
95         return c;
96     }
97 
98     /**
99     * @dev Adds two signed integers, reverts on overflow.
100     */
101     function add(int256 a, int256 b) internal pure returns (int256) {
102         int256 c = a + b;
103         require((b >= 0 && c >= a) || (b < 0 && c < a));
104 
105         return c;
106     }
107 
108     /**
109     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
110     * reverts when dividing by zero.
111     */
112     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b != 0);
114         return a % b;
115     }
116 }
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122  interface IERC20 {
123     function totalSupply() external view returns (uint256);
124 
125     function balanceOf(address who) external view returns (uint256);
126 
127     function allowance(address owner, address spender) external view returns (uint256);
128 
129     function transfer(address to, uint256 value) external returns (bool);
130 
131     function approve(address spender, uint256 value) external returns (bool);
132 
133     function transferFrom(address from, address to, uint256 value) external returns (bool);
134 
135     event Transfer(address indexed from, address indexed to, uint256 value);
136 
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 /**
141  * @title ERC20Detailed token
142  * @dev The decimals are only for visualization purposes.
143  * All the operations are done using the smallest and indivisible token unit,
144  * just as on Ethereum all the operations are done in wei.
145  */
146 contract ERC20Detailed is IERC20 {
147     string private _name;
148     string private _symbol;
149     uint8 private _decimals;
150 
151     constructor (string name, string symbol, uint8 decimals) public {
152         _name = name;
153         _symbol = symbol;
154         _decimals = decimals;
155     }
156 
157     /**
158      * @return the name of the token.
159      */
160     function name() public view returns (string) {
161         return _name;
162     }
163 
164     /**
165      * @return the symbol of the token.
166      */
167     function symbol() public view returns (string) {
168         return _symbol;
169     }
170 
171     /**
172      * @return the number of decimals of the token.
173      */
174     function decimals() public view returns (uint8) {
175         return _decimals;
176     }
177 }
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
183  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  *
185  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
186  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
187  * compliant implementations may not do it.
188  */
189 contract ERC20 is IERC20 {
190     using SafeMath for uint256;
191 
192     mapping (address => uint256) private _balances;
193 
194     mapping (address => mapping (address => uint256)) private _allowed;
195 
196     uint256 private _totalSupply;
197 
198     /**
199     * @dev Total number of tokens in existence
200     */
201     function totalSupply() public view returns (uint256) {
202         return _totalSupply;
203     }
204 
205     /**
206     * @dev Gets the balance of the specified address.
207     * @param owner The address to query the balance of.
208     * @return An uint256 representing the amount owned by the passed address.
209     */
210     function balanceOf(address owner) public view returns (uint256) {
211         return _balances[owner];
212     }
213 
214     /**
215      * @dev Function to check the amount of tokens that an owner allowed to a spender.
216      * @param owner address The address which owns the funds.
217      * @param spender address The address which will spend the funds.
218      * @return A uint256 specifying the amount of tokens still available for the spender.
219      */
220     function allowance(address owner, address spender) public view returns (uint256) {
221         return _allowed[owner][spender];
222     }
223 
224     /**
225     * @dev Transfer token for a specified address
226     * @param to The address to transfer to.
227     * @param value The amount to be transferred.
228     */
229     function transfer(address to, uint256 value) public returns (bool) {
230         _transfer(msg.sender, to, value);
231         return true;
232     }
233 
234     /**
235      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236      * Beware that changing an allowance with this method brings the risk that someone may use both the old
237      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240      * @param spender The address which will spend the funds.
241      * @param value The amount of tokens to be spent.
242      */
243     function approve(address spender, uint256 value) public returns (bool) {
244         require(spender != address(0));
245 
246         _allowed[msg.sender][spender] = value;
247         emit Approval(msg.sender, spender, value);
248         return true;
249     }
250 
251     /**
252      * @dev Transfer tokens from one address to another.
253      * Note that while this function emits an Approval event, this is not required as per the specification,
254      * and other compliant implementations may not emit the event.
255      * @param from address The address which you want to send tokens from
256      * @param to address The address which you want to transfer to
257      * @param value uint256 the amount of tokens to be transferred
258      */
259     function transferFrom(address from, address to, uint256 value) public returns (bool) {
260         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
261         _transfer(from, to, value);
262         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
263         return true;
264     }
265 
266     /**
267      * @dev Increase the amount of tokens that an owner allowed to a spender.
268      * approve should be called when allowed_[_spender] == 0. To increment
269      * allowed value is better to use this function to avoid 2 calls (and wait until
270      * the first transaction is mined)
271      * From MonolithDAO Token.sol
272      * Emits an Approval event.
273      * @param spender The address which will spend the funds.
274      * @param addedValue The amount of tokens to increase the allowance by.
275      */
276     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
277         require(spender != address(0));
278 
279         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
280         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
281         return true;
282     }
283 
284     /**
285      * @dev Decrease the amount of tokens that an owner allowed to a spender.
286      * approve should be called when allowed_[_spender] == 0. To decrement
287      * allowed value is better to use this function to avoid 2 calls (and wait until
288      * the first transaction is mined)
289      * From MonolithDAO Token.sol
290      * Emits an Approval event.
291      * @param spender The address which will spend the funds.
292      * @param subtractedValue The amount of tokens to decrease the allowance by.
293      */
294     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
295         require(spender != address(0));
296 
297         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
298         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
299         return true;
300     }
301 
302     /**
303     * @dev Transfer token for a specified addresses
304     * @param from The address to transfer from.
305     * @param to The address to transfer to.
306     * @param value The amount to be transferred.
307     */
308     function _transfer(address from, address to, uint256 value) internal {
309         require(to != address(0));
310 
311         _balances[from] = _balances[from].sub(value);
312         _balances[to] = _balances[to].add(value);
313         emit Transfer(from, to, value);
314     }
315 
316     /**
317      * @dev Internal function that mints an amount of the token and assigns it to
318      * an account. This encapsulates the modification of balances such that the
319      * proper events are emitted.
320      * @param account The account that will receive the created tokens.
321      * @param value The amount that will be created.
322      */
323     function _mint(address account, uint256 value) internal {
324         require(account != address(0));
325 
326         _totalSupply = _totalSupply.add(value);
327         _balances[account] = _balances[account].add(value);
328         emit Transfer(address(0), account, value);
329     }
330 
331     /**
332      * @dev Internal function that burns an amount of the token of a given
333      * account.
334      * @param account The account whose tokens will be burnt.
335      * @param value The amount that will be burnt.
336      */
337     function _burn(address account, uint256 value) internal {
338         require(account != address(0));
339 
340         _totalSupply = _totalSupply.sub(value);
341         _balances[account] = _balances[account].sub(value);
342         emit Transfer(account, address(0), value);
343     }
344 
345     /**
346      * @dev Internal function that burns an amount of the token of a given
347      * account, deducting from the sender's allowance for said account. Uses the
348      * internal burn function.
349      * Emits an Approval event (reflecting the reduced allowance).
350      * @param account The account whose tokens will be burnt.
351      * @param value The amount that will be burnt.
352      */
353     function _burnFrom(address account, uint256 value) internal {
354         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
355         _burn(account, value);
356         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
357     }
358 }
359 
360 /**
361  * @title Burnable Token
362  * @dev Token that can be irreversibly burned (destroyed).
363  */
364 contract ERC20Burnable is ERC20 {
365     /**
366      * @dev Burns a specific amount of tokens.
367      * @param value The amount of token to be burned.
368      */
369     function burn(uint256 value) public {
370         _burn(msg.sender, value);
371     }
372 
373     /**
374      * @dev Burns a specific amount of tokens from the target address and decrements allowance
375      * @param from address The address which you want to send tokens from
376      * @param value uint256 The amount of token to be burned
377      */
378     function burnFrom(address from, uint256 value) public {
379         _burnFrom(from, value);
380     }
381 }
382 
383 /**
384  * @title SimpleToken
385  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
386  * Note they can later distribute these tokens as they wish using `transfer` and other
387  * `ERC20` functions.
388  */
389 contract HscToken is ERC20, ERC20Detailed, ERC20Burnable {
390     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals()));
391 
392     /**
393      * @dev Constructor that gives msg.sender all of existing tokens.
394      */
395     constructor () public ERC20Detailed("HSC Token", "HSC", 8) {
396         _mint(msg.sender, INITIAL_SUPPLY);
397     }
398 }