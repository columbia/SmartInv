1 pragma solidity ^0.4.2;
2 
3 //  import "./IERC20.sol"; 
4 //  import "./SafeMath.sol";
5 
6 /**
7  * @title SafeMath
8  * @dev Unsigned math operations with safety checks that revert on error
9  */
10  
11 library SafeMath {
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
30     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52     * @dev Adds two unsigned integers, reverts on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
63     * reverts when dividing by zero.
64     */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
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
87 contract ERC20 is IERC20 {
88     using SafeMath for uint256;
89 
90     mapping (address => uint256) private _balances;
91 
92     mapping (address => mapping (address => uint256)) private _allowed;
93 
94     uint256 private _totalSupply;
95 
96     /**
97     * @dev Total number of tokens in existence
98     */
99     function totalSupply() public view returns (uint256) {
100         return _totalSupply;
101     }
102 
103     /**
104     * @dev Gets the balance of the specified address.
105     * @param owner The address to query the balance of.
106     * @return An uint256 representing the amount owned by the passed address.
107     */
108     function balanceOf(address owner) public view returns (uint256) {
109         return _balances[owner];
110     }
111 
112     /**
113      * @dev Function to check the amount of tokens that an owner allowed to a spender.
114      * @param owner address The address which owns the funds.
115      * @param spender address The address which will spend the funds.
116      * @return A uint256 specifying the amount of tokens still available for the spender.
117      */
118     function allowance(address owner, address spender) public view returns (uint256) {
119         return _allowed[owner][spender];
120     }
121 
122     /**
123     * @dev Transfer token for a specified address
124     * @param to The address to transfer to.
125     * @param value The amount to be transferred.
126     */
127     function transfer(address to, uint256 value) public returns (bool) {
128         _transfer(msg.sender, to, value);
129         return true;
130     }
131 
132     /**
133      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134      * Beware that changing an allowance with this method brings the risk that someone may use both the old
135      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      * @param spender The address which will spend the funds.
139      * @param value The amount of tokens to be spent.
140      */
141     function approve(address spender, uint256 value) public returns (bool) {
142         require(spender != address(0));
143 
144         _allowed[msg.sender][spender] = value;
145         emit Approval(msg.sender, spender, value);
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
158         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
159         _transfer(from, to, value);
160         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
161         return true;
162     }
163 
164     /**
165      * @dev Increase the amount of tokens that an owner allowed to a spender.
166      * approve should be called when allowed_[_spender] == 0. To increment
167      * allowed value is better to use this function to avoid 2 calls (and wait until
168      * the first transaction is mined)
169      * From MonolithDAO Token.sol
170      * Emits an Approval event.
171      * @param spender The address which will spend the funds.
172      * @param addedValue The amount of tokens to increase the allowance by.
173      */
174     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
175         require(spender != address(0));
176 
177         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
178         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
179         return true;
180     }
181 
182     /**
183      * @dev Decrease the amount of tokens that an owner allowed to a spender.
184      * approve should be called when allowed_[_spender] == 0. To decrement
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * Emits an Approval event.
189      * @param spender The address which will spend the funds.
190      * @param subtractedValue The amount of tokens to decrease the allowance by.
191      */
192     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
193         require(spender != address(0));
194 
195         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
196         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
197         return true;
198     }
199 
200     /**
201     * @dev Transfer token for a specified addresses
202     * @param from The address to transfer from.
203     * @param to The address to transfer to.
204     * @param value The amount to be transferred.
205     */
206     function _transfer(address from, address to, uint256 value) internal {
207         require(to != address(0));
208 
209         _balances[from] = _balances[from].sub(value);
210         _balances[to] = _balances[to].add(value);
211         emit Transfer(from, to, value);
212     }
213 
214     /**
215      * @dev Internal function that mints an amount of the token and assigns it to
216      * an account. This encapsulates the modification of balances such that the
217      * proper events are emitted.
218      * @param account The account that will receive the created tokens.
219      * @param value The amount that will be created.
220      */
221     function _mint(address account, uint256 value) internal {
222         require(account != address(0));
223 
224         _totalSupply = _totalSupply.add(value);
225         _balances[account] = _balances[account].add(value);
226         emit Transfer(address(0), account, value);
227     }
228 
229     /**
230      * @dev Internal function that burns an amount of the token of a given
231      * account.
232      * @param account The account whose tokens will be burnt.
233      * @param value The amount that will be burnt.
234      */
235     function _burn(address account, uint256 value) internal {
236         require(account != address(0));
237 
238         _totalSupply = _totalSupply.sub(value);
239         _balances[account] = _balances[account].sub(value);
240         emit Transfer(account, address(0), value);
241     }
242 
243     /**
244      * @dev Internal function that burns an amount of the token of a given
245      * account, deducting from the sender's allowance for said account. Uses the
246      * internal burn function.
247      * Emits an Approval event (reflecting the reduced allowance).
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burnFrom(address account, uint256 value) internal {
252         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
253         _burn(account, value);
254         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
255     }
256 }
257 
258 pragma solidity ^0.4.2;
259 
260 // import "./IERC20.sol";
261 
262 
263 
264 /**
265  * @title ERC20Detailed token
266  * @dev The decimals are only for visualization purposes.
267  * All the operations are done using the smallest and indivisible token unit,
268  * just as on Ethereum all the operations are done in wei.
269  */
270 contract ERC20Detailed is IERC20 {
271     string private _name;
272     string private _symbol;
273     uint8 private _decimals;
274 
275     constructor (string memory name, string memory symbol, uint8 decimals) public {
276         _name = name;
277         _symbol = symbol;
278         _decimals = decimals;
279     }
280 
281     /**
282      * @return the name of the token.
283      */
284     function name() public view returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @return the symbol of the token.
290      */
291     function symbol() public view returns (string memory) {
292         return _symbol;
293     }
294 
295     /**
296      * @return the number of decimals of the token.
297      */
298     function decimals() public view returns (uint8) {
299         return _decimals;
300     }
301 }
302 pragma solidity ^0.4.2;
303 
304 // import "./ERC20.sol";
305 
306 /**
307  * @title Burnable Token
308  * @dev Token that can be irreversibly burned (destroyed).
309  */
310 contract ERC20Burnable is ERC20 {
311     /**
312      * @dev Burns a specific amount of tokens.
313      * @param value The amount of token to be burned.
314      */
315     function burn(uint256 value) public {
316         _burn(msg.sender, value);
317     }
318 
319     /**
320      * @dev Burns a specific amount of tokens from the target address and decrements allowance
321      * @param from address The address which you want to send tokens from
322      * @param value uint256 The amount of token to be burned
323      */
324     function burnFrom(address from, uint256 value) public {
325         _burnFrom(from, value);
326     }
327 }
328 
329 /**
330  * @title ERC20 interface
331  * @dev see https://github.com/ethereum/EIPs/issues/20
332  */
333 
334 // import "./ERC20.sol";
335 // import "./ERC20Detailed.sol";
336 // import "./ERC20Burnable.sol";
337 
338 
339 contract CopyLock is ERC20, ERC20Detailed, ERC20Burnable {
340     uint8 public constant DECIMALS = 18;
341     uint256 public constant INITIAL_SUPPLY = 150000000 * (10 ** uint256(DECIMALS));
342 
343     /**
344      * @dev Constructor that gives msg.sender all of existing tokens.
345      */
346     constructor () public ERC20Detailed("CopyLock", "COL", 18) {
347         _mint(msg.sender, INITIAL_SUPPLY);
348     }
349 }