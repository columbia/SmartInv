1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address who) external view returns (uint256);
7 
8     function allowance(address owner, address spender) external view returns (uint256);
9 
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     int256 constant private INT256_MIN = -2**255;
23 
24     /**
25     * @dev Multiplies two unsigned integers, reverts on overflow.
26     */
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
29         // benefit is lost if 'b' is also tested.
30         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b);
37 
38         return c;
39     }
40 
41     /**
42     * @dev Multiplies two signed integers, reverts on overflow.
43     */
44     function mul(int256 a, int256 b) internal pure returns (int256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48         if (a == 0) {
49             return 0;
50         }
51 
52         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
53 
54         int256 c = a * b;
55         require(c / a == b);
56 
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
62     */
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Solidity only automatically asserts when dividing by 0
65         require(b > 0);
66         uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     /**
73     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
74     */
75     function div(int256 a, int256 b) internal pure returns (int256) {
76         require(b != 0); // Solidity only automatically asserts when dividing by 0
77         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
78 
79         int256 c = a / b;
80 
81         return c;
82     }
83 
84     /**
85     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
86     */
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b <= a);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     /**
95     * @dev Subtracts two signed integers, reverts on overflow.
96     */
97     function sub(int256 a, int256 b) internal pure returns (int256) {
98         int256 c = a - b;
99         require((b >= 0 && c <= a) || (b < 0 && c > a));
100 
101         return c;
102     }
103 
104     /**
105     * @dev Adds two unsigned integers, reverts on overflow.
106     */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a);
110 
111         return c;
112     }
113 
114     /**
115     * @dev Adds two signed integers, reverts on overflow.
116     */
117     function add(int256 a, int256 b) internal pure returns (int256) {
118         int256 c = a + b;
119         require((b >= 0 && c >= a) || (b < 0 && c < a));
120 
121         return c;
122     }
123 
124     /**
125     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
126     * reverts when dividing by zero.
127     */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b != 0);
130         return a % b;
131     }
132 }
133 
134 contract ERC20 is IERC20 {
135     using SafeMath for uint256;
136 
137     mapping (address => uint256) private _balances;
138 
139     mapping (address => mapping (address => uint256)) private _allowed;
140 
141     uint256 private _totalSupply;
142 
143     /**
144     * @dev Total number of tokens in existence
145     */
146     function totalSupply() public view returns (uint256) {
147         return _totalSupply;
148     }
149 
150     /**
151     * @dev Gets the balance of the specified address.
152     * @param owner The address to query the balance of.
153     * @return An uint256 representing the amount owned by the passed address.
154     */
155     function balanceOf(address owner) public view returns (uint256) {
156         return _balances[owner];
157     }
158 
159     /**
160      * @dev Function to check the amount of tokens that an owner allowed to a spender.
161      * @param owner address The address which owns the funds.
162      * @param spender address The address which will spend the funds.
163      * @return A uint256 specifying the amount of tokens still available for the spender.
164      */
165     function allowance(address owner, address spender) public view returns (uint256) {
166         return _allowed[owner][spender];
167     }
168 
169     /**
170     * @dev Transfer token for a specified address
171     * @param to The address to transfer to.
172     * @param value The amount to be transferred.
173     */
174     function transfer(address to, uint256 value) public returns (bool) {
175         _transfer(msg.sender, to, value);
176         return true;
177     }
178 
179     /**
180      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181      * Beware that changing an allowance with this method brings the risk that someone may use both the old
182      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      * @param spender The address which will spend the funds.
186      * @param value The amount of tokens to be spent.
187      */
188     function approve(address spender, uint256 value) public returns (bool) {
189         require(spender != address(0));
190 
191         _allowed[msg.sender][spender] = value;
192         emit Approval(msg.sender, spender, value);
193         return true;
194     }
195 
196     /**
197      * @dev Transfer tokens from one address to another.
198      * Note that while this function emits an Approval event, this is not required as per the specification,
199      * and other compliant implementations may not emit the event.
200      * @param from address The address which you want to send tokens from
201      * @param to address The address which you want to transfer to
202      * @param value uint256 the amount of tokens to be transferred
203      */
204     function transferFrom(address from, address to, uint256 value) public returns (bool) {
205         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
206         _transfer(from, to, value);
207         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
208         return true;
209     }
210 
211     /**
212      * @dev Increase the amount of tokens that an owner allowed to a spender.
213      * approve should be called when allowed_[_spender] == 0. To increment
214      * allowed value is better to use this function to avoid 2 calls (and wait until
215      * the first transaction is mined)
216      * From MonolithDAO Token.sol
217      * Emits an Approval event.
218      * @param spender The address which will spend the funds.
219      * @param addedValue The amount of tokens to increase the allowance by.
220      */
221     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
222         require(spender != address(0));
223 
224         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
225         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
226         return true;
227     }
228 
229     /**
230      * @dev Decrease the amount of tokens that an owner allowed to a spender.
231      * approve should be called when allowed_[_spender] == 0. To decrement
232      * allowed value is better to use this function to avoid 2 calls (and wait until
233      * the first transaction is mined)
234      * From MonolithDAO Token.sol
235      * Emits an Approval event.
236      * @param spender The address which will spend the funds.
237      * @param subtractedValue The amount of tokens to decrease the allowance by.
238      */
239     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
240         require(spender != address(0));
241 
242         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
243         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
244         return true;
245     }
246 
247     /**
248     * @dev Transfer token for a specified addresses
249     * @param from The address to transfer from.
250     * @param to The address to transfer to.
251     * @param value The amount to be transferred.
252     */
253     function _transfer(address from, address to, uint256 value) internal {
254         require(to != address(0));
255 
256         _balances[from] = _balances[from].sub(value);
257         _balances[to] = _balances[to].add(value);
258         emit Transfer(from, to, value);
259     }
260 
261     /**
262      * @dev Internal function that mints an amount of the token and assigns it to
263      * an account. This encapsulates the modification of balances such that the
264      * proper events are emitted.
265      * @param account The account that will receive the created tokens.
266      * @param value The amount that will be created.
267      */
268     function _mint(address account, uint256 value) internal {
269         require(account != address(0));
270 
271         _totalSupply = _totalSupply.add(value);
272         _balances[account] = _balances[account].add(value);
273         emit Transfer(address(0), account, value);
274     }
275 
276     /**
277      * @dev Internal function that burns an amount of the token of a given
278      * account.
279      * @param account The account whose tokens will be burnt.
280      * @param value The amount that will be burnt.
281      */
282     function _burn(address account, uint256 value) internal {
283         require(account != address(0));
284 
285         _totalSupply = _totalSupply.sub(value);
286         _balances[account] = _balances[account].sub(value);
287         emit Transfer(account, address(0), value);
288     }
289 
290     /**
291      * @dev Internal function that burns an amount of the token of a given
292      * account, deducting from the sender's allowance for said account. Uses the
293      * internal burn function.
294      * Emits an Approval event (reflecting the reduced allowance).
295      * @param account The account whose tokens will be burnt.
296      * @param value The amount that will be burnt.
297      */
298     function _burnFrom(address account, uint256 value) internal {
299         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
300         _burn(account, value);
301         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
302     }
303 }
304 
305 contract ERC20Detailed is IERC20 {
306     string private _name;
307     string private _symbol;
308     uint8 private _decimals;
309 
310     constructor (string name, string symbol, uint8 decimals) public {
311         _name = name;
312         _symbol = symbol;
313         _decimals = decimals;
314     }
315 
316     /**
317      * @return the name of the token.
318      */
319     function name() public view returns (string) {
320         return _name;
321     }
322 
323     /**
324      * @return the symbol of the token.
325      */
326     function symbol() public view returns (string) {
327         return _symbol;
328     }
329 
330     /**
331      * @return the number of decimals of the token.
332      */
333     function decimals() public view returns (uint8) {
334         return _decimals;
335     }
336 }
337 
338 contract ERC20Burnable is ERC20 {
339     /**
340      * @dev Burns a specific amount of tokens.
341      * @param value The amount of token to be burned.
342      */
343     function burn(uint256 value) public {
344         _burn(msg.sender, value);
345     }
346 
347     /**
348      * @dev Burns a specific amount of tokens from the target address and decrements allowance
349      * @param from address The address which you want to send tokens from
350      * @param value uint256 The amount of token to be burned
351      */
352     function burnFrom(address from, uint256 value) public {
353         _burnFrom(from, value);
354     }
355 }
356 
357 contract Stasia is ERC20, ERC20Detailed, ERC20Burnable {
358     uint256 public constant INITIAL_SUPPLY = 10000000000 * 10**18;
359 
360     /**
361      * @dev Constructor that gives msg.sender all of existing tokens.
362      */
363     constructor () public ERC20Detailed("STASIA", "STASIA", 18) {
364         _mint(msg.sender, INITIAL_SUPPLY);
365     }
366 }