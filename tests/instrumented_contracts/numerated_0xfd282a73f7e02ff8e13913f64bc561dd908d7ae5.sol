1 pragma solidity ^0.4.24;
2 
3 // File: contracts/token/ERC20/IERC20.sol
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
27 // File: contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35     * @dev Multiplies two numbers, reverts on overflow.
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
53     */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Adds two numbers, reverts on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
85     * reverts when dividing by zero.
86     */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: contracts/token/ERC20/ERC20.sol
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
100  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  *
102  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
103  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
104  * compliant implementations may not do it.
105  */
106 contract ERC20 is IERC20 {
107     using SafeMath for uint256;
108 
109     mapping (address => uint256) private _balances;
110 
111     mapping (address => mapping (address => uint256)) private _allowed;
112 
113     uint256 private _totalSupply;
114 
115     /**
116     * @dev Total number of tokens in existence
117     */
118     function totalSupply() public view returns (uint256) {
119         return _totalSupply;
120     }
121 
122     /**
123     * @dev Gets the balance of the specified address.
124     * @param owner The address to query the balance of.
125     * @return An uint256 representing the amount owned by the passed address.
126     */
127     function balanceOf(address owner) public view returns (uint256) {
128         return _balances[owner];
129     }
130 
131     /**
132      * @dev Function to check the amount of tokens that an owner allowed to a spender.
133      * @param owner address The address which owns the funds.
134      * @param spender address The address which will spend the funds.
135      * @return A uint256 specifying the amount of tokens still available for the spender.
136      */
137     function allowance(address owner, address spender) public view returns (uint256) {
138         return _allowed[owner][spender];
139     }
140 
141     /**
142     * @dev Transfer token for a specified address
143     * @param to The address to transfer to.
144     * @param value The amount to be transferred.
145     */
146     function transfer(address to, uint256 value) public returns (bool) {
147         _transfer(msg.sender, to, value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      * Beware that changing an allowance with this method brings the risk that someone may use both the old
154      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      * @param spender The address which will spend the funds.
158      * @param value The amount of tokens to be spent.
159      */
160     function approve(address spender, uint256 value) public returns (bool) {
161         require(spender != address(0));
162 
163         _allowed[msg.sender][spender] = value;
164         emit Approval(msg.sender, spender, value);
165         return true;
166     }
167 
168     /**
169      * @dev Transfer tokens from one address to another.
170      * Note that while this function emits an Approval event, this is not required as per the specification,
171      * and other compliant implementations may not emit the event.
172      * @param from address The address which you want to send tokens from
173      * @param to address The address which you want to transfer to
174      * @param value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(address from, address to, uint256 value) public returns (bool) {
177         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
178         _transfer(from, to, value);
179         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
180         return true;
181     }
182 
183     /**
184      * @dev Increase the amount of tokens that an owner allowed to a spender.
185      * approve should be called when allowed_[_spender] == 0. To increment
186      * allowed value is better to use this function to avoid 2 calls (and wait until
187      * the first transaction is mined)
188      * From MonolithDAO Token.sol
189      * Emits an Approval event.
190      * @param spender The address which will spend the funds.
191      * @param addedValue The amount of tokens to increase the allowance by.
192      */
193     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
194         require(spender != address(0));
195 
196         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
197         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when allowed_[_spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         require(spender != address(0));
213 
214         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
215         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
216         return true;
217     }
218 
219     /**
220     * @dev Transfer token for a specified addresses
221     * @param from The address to transfer from.
222     * @param to The address to transfer to.
223     * @param value The amount to be transferred.
224     */
225     function _transfer(address from, address to, uint256 value) internal {
226         require(to != address(0));
227 
228         _balances[from] = _balances[from].sub(value);
229         _balances[to] = _balances[to].add(value);
230         emit Transfer(from, to, value);
231     }
232 
233     /**
234      * @dev Internal function that mints an amount of the token and assigns it to
235      * an account. This encapsulates the modification of balances such that the
236      * proper events are emitted.
237      * @param account The account that will receive the created tokens.
238      * @param value The amount that will be created.
239      */
240     function _mint(address account, uint256 value) internal {
241         require(account != address(0));
242 
243         _totalSupply = _totalSupply.add(value);
244         _balances[account] = _balances[account].add(value);
245         emit Transfer(address(0), account, value);
246     }
247 
248     /**
249      * @dev Internal function that burns an amount of the token of a given
250      * account.
251      * @param account The account whose tokens will be burnt.
252      * @param value The amount that will be burnt.
253      */
254     function _burn(address account, uint256 value) internal {
255         require(account != address(0));
256 
257         _totalSupply = _totalSupply.sub(value);
258         _balances[account] = _balances[account].sub(value);
259         emit Transfer(account, address(0), value);
260     }
261 
262     /**
263      * @dev Internal function that burns an amount of the token of a given
264      * account, deducting from the sender's allowance for said account. Uses the
265      * internal burn function.
266      * Emits an Approval event (reflecting the reduced allowance).
267      * @param account The account whose tokens will be burnt.
268      * @param value The amount that will be burnt.
269      */
270     function _burnFrom(address account, uint256 value) internal {
271         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
272         _burn(account, value);
273         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
274     }
275 }
276 
277 // File: contracts/token/ERC20/ERC20Burnable.sol
278 
279 /**
280  * @title Burnable Token
281  * @dev Token that can be irreversibly burned (destroyed).
282  */
283 contract ERC20Burnable is ERC20 {
284     /**
285      * @dev Burns a specific amount of tokens.
286      * @param value The amount of token to be burned.
287      */
288     function burn(uint256 value) public {
289         _burn(msg.sender, value);
290     }
291 
292     /**
293      * @dev Burns a specific amount of tokens from the target address and decrements allowance
294      * @param from address The address which you want to send tokens from
295      * @param value uint256 The amount of token to be burned
296      */
297     function burnFrom(address from, uint256 value) public {
298         _burnFrom(from, value);
299     }
300 }
301 
302 // File: contracts/token/ERC20/ERC20Detailed.sol
303 
304 /**
305  * @title ERC20Detailed token
306  * @dev The decimals are only for visualization purposes.
307  * All the operations are done using the smallest and indivisible token unit,
308  * just as on Ethereum all the operations are done in wei.
309  */
310 contract ERC20Detailed is IERC20 {
311     string private _name;
312     string private _symbol;
313     uint8 private _decimals;
314 
315     constructor (string name, string symbol, uint8 decimals) public {
316         _name = name;
317         _symbol = symbol;
318         _decimals = decimals;
319     }
320 
321     /**
322      * @return the name of the token.
323      */
324     function name() public view returns (string) {
325         return _name;
326     }
327 
328     /**
329      * @return the symbol of the token.
330      */
331     function symbol() public view returns (string) {
332         return _symbol;
333     }
334 
335     /**
336      * @return the number of decimals of the token.
337      */
338     function decimals() public view returns (uint8) {
339         return _decimals;
340     }
341 }
342 
343 // File: contracts/examples/DexNetworks.sol
344 
345 contract DexNetworks is ERC20Burnable, ERC20Detailed {
346     uint256 public constant INITIAL_SUPPLY = 2643826675 * (10 **18);
347 
348     /**
349      * @dev Constructor that gives msg.sender all of existing tokens.
350      */
351     constructor () public ERC20Detailed("DexNetworks", "DNW", 18) {
352         _mint(msg.sender, INITIAL_SUPPLY);
353     }
354 }