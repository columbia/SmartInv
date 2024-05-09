1 pragma solidity 0.5.9;
2 
3 
4 /**
5  * @title Claimable
6  * @dev Claimable contract, where the ownership needs to be claimed.
7  * This allows the new owner to accept the transfer.
8  */
9 contract Claimable {
10     address public owner;
11     address public pendingOwner;
12 
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18     /**
19     * @dev The Claimable constructor sets the original `owner` of the contract to the sender
20     * account.
21     */
22     constructor() public {
23         owner = msg.sender;
24     }
25 
26     /**
27     * @dev Throws if called by any account other than the owner.
28     */
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     /**
35     * @dev Modifier throws if called by any account other than the pendingOwner.
36     */
37     modifier onlyPendingOwner() {
38         require(msg.sender == pendingOwner);
39         _;
40     }
41 
42     /**
43     * @dev Allows the current owner to set the pendingOwner address.
44     * @param newOwner The address to transfer ownership to.
45     */
46     function transferOwnership(address newOwner) public onlyOwner {
47         pendingOwner = newOwner;
48     }
49 
50     /**
51     * @dev Allows the pendingOwner address to finalize the transfer.
52     */
53     function claimOwnership() public onlyPendingOwner {
54         emit OwnershipTransferred(owner, pendingOwner);
55         owner = pendingOwner;
56         pendingOwner = address(0);
57     }
58 }
59 
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://eips.ethereum.org/EIPS/eip-20
64  */
65 interface IERC20 {
66     function transfer(address to, uint256 value) external returns (bool);
67 
68     function approve(address spender, uint256 value) external returns (bool);
69 
70     function transferFrom(address from, address to, uint256 value) external returns (bool);
71 
72     function totalSupply() external view returns (uint256);
73 
74     function balanceOf(address who) external view returns (uint256);
75 
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 /**
84  * @title SafeMath
85  * @dev Unsigned math operations with safety checks that revert on error
86  */
87 library SafeMath {
88     /**
89      * @dev Multiplies two unsigned integers, reverts on overflow.
90      */
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b);
101 
102         return c;
103     }
104 
105     /**
106      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Solidity only automatically asserts when dividing by 0
110         require(b > 0);
111         uint256 c = a / b;
112         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113 
114         return c;
115     }
116 
117     /**
118      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b <= a);
122         uint256 c = a - b;
123 
124         return c;
125     }
126 
127     /**
128      * @dev Adds two unsigned integers, reverts on overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a);
133 
134         return c;
135     }
136 
137     /**
138      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
139      * reverts when dividing by zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b != 0);
143         return a % b;
144     }
145 }
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * https://eips.ethereum.org/EIPS/eip-20
152  * Originally based on code by FirstBlood:
153  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  *
155  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
156  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
157  * compliant implementations may not do it.
158  */
159 contract ERC20 is IERC20 {
160     using SafeMath for uint256;
161 
162     mapping (address => uint256) private _balances;
163 
164     mapping (address => mapping (address => uint256)) private _allowed;
165 
166     uint256 private _totalSupply;
167 
168     /**
169      * @dev Total number of tokens in existence
170      */
171     function totalSupply() public view returns (uint256) {
172         return _totalSupply;
173     }
174 
175     /**
176      * @dev Gets the balance of the specified address.
177      * @param owner The address to query the balance of.
178      * @return A uint256 representing the amount owned by the passed address.
179      */
180     function balanceOf(address owner) public view returns (uint256) {
181         return _balances[owner];
182     }
183 
184     /**
185      * @dev Function to check the amount of tokens that an owner allowed to a spender.
186      * @param owner address The address which owns the funds.
187      * @param spender address The address which will spend the funds.
188      * @return A uint256 specifying the amount of tokens still available for the spender.
189      */
190     function allowance(address owner, address spender) public view returns (uint256) {
191         return _allowed[owner][spender];
192     }
193 
194     /**
195      * @dev Transfer token to a specified address
196      * @param to The address to transfer to.
197      * @param value The amount to be transferred.
198      */
199     function transfer(address to, uint256 value) public returns (bool) {
200         _transfer(msg.sender, to, value);
201         return true;
202     }
203 
204     /**
205      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206      * Beware that changing an allowance with this method brings the risk that someone may use both the old
207      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      * @param spender The address which will spend the funds.
211      * @param value The amount of tokens to be spent.
212      */
213     function approve(address spender, uint256 value) public returns (bool) {
214         _approve(msg.sender, spender, value);
215         return true;
216     }
217 
218     /**
219      * @dev Transfer tokens from one address to another.
220      * Note that while this function emits an Approval event, this is not required as per the specification,
221      * and other compliant implementations may not emit the event.
222      * @param from address The address which you want to send tokens from
223      * @param to address The address which you want to transfer to
224      * @param value uint256 the amount of tokens to be transferred
225      */
226     function transferFrom(address from, address to, uint256 value) public returns (bool) {
227         _transfer(from, to, value);
228         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
229         return true;
230     }
231 
232     /**
233      * @dev Increase the amount of tokens that an owner allowed to a spender.
234      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * From MonolithDAO Token.sol
238      * Emits an Approval event.
239      * @param spender The address which will spend the funds.
240      * @param addedValue The amount of tokens to increase the allowance by.
241      */
242     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
243         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
244         return true;
245     }
246 
247     /**
248      * @dev Decrease the amount of tokens that an owner allowed to a spender.
249      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
250      * allowed value is better to use this function to avoid 2 calls (and wait until
251      * the first transaction is mined)
252      * From MonolithDAO Token.sol
253      * Emits an Approval event.
254      * @param spender The address which will spend the funds.
255      * @param subtractedValue The amount of tokens to decrease the allowance by.
256      */
257     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
258         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
259         return true;
260     }
261 
262     /**
263      * @dev Transfer token for a specified addresses
264      * @param from The address to transfer from.
265      * @param to The address to transfer to.
266      * @param value The amount to be transferred.
267      */
268     function _transfer(address from, address to, uint256 value) internal {
269         require(to != address(0));
270 
271         _balances[from] = _balances[from].sub(value);
272         _balances[to] = _balances[to].add(value);
273         emit Transfer(from, to, value);
274     }
275 
276     /**
277      * @dev Internal function that mints an amount of the token and assigns it to
278      * an account. This encapsulates the modification of balances such that the
279      * proper events are emitted.
280      * @param account The account that will receive the created tokens.
281      * @param value The amount that will be created.
282      */
283     function _mint(address account, uint256 value) internal {
284         require(account != address(0));
285 
286         _totalSupply = _totalSupply.add(value);
287         _balances[account] = _balances[account].add(value);
288         emit Transfer(address(0), account, value);
289     }
290 
291     /**
292      * @dev Internal function that burns an amount of the token of a given
293      * account.
294      * @param account The account whose tokens will be burnt.
295      * @param value The amount that will be burnt.
296      */
297     function _burn(address account, uint256 value) internal {
298         require(account != address(0));
299 
300         _totalSupply = _totalSupply.sub(value);
301         _balances[account] = _balances[account].sub(value);
302         emit Transfer(account, address(0), value);
303     }
304 
305     /**
306      * @dev Approve an address to spend another addresses' tokens.
307      * @param owner The address that owns the tokens.
308      * @param spender The address that will spend the tokens.
309      * @param value The number of tokens that can be spent.
310      */
311     function _approve(address owner, address spender, uint256 value) internal {
312         require(spender != address(0));
313         require(owner != address(0));
314 
315         _allowed[owner][spender] = value;
316         emit Approval(owner, spender, value);
317     }
318 
319     /**
320      * @dev Internal function that burns an amount of the token of a given
321      * account, deducting from the sender's allowance for said account. Uses the
322      * internal burn function.
323      * Emits an Approval event (reflecting the reduced allowance).
324      * @param account The account whose tokens will be burnt.
325      * @param value The amount that will be burnt.
326      */
327     function _burnFrom(address account, uint256 value) internal {
328         _burn(account, value);
329         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
330     }
331 }
332 
333 
334 /**
335  * @title Burnable Token
336  * @dev Token that can be irreversibly burned (destroyed).
337  */
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
349      * @param from address The account whose tokens will be burned.
350      * @param value uint256 The amount of token to be burned.
351      */
352     function burnFrom(address from, uint256 value) public {
353         _burnFrom(from, value);
354     }
355 }
356 
357 
358 contract SwgToken is ERC20, ERC20Burnable, Claimable {
359     string public name = "SkyWay Global Token";
360     string public symbol = "TESTWG";
361     uint8 public decimals = 8;
362 
363     /**
364      * @dev Function to mint tokens
365      * @param to The address that will receive the minted tokens.
366      * @param value The amount of tokens to mint.
367      * @return A boolean that indicates if the operation was successful.
368      */
369     function mint(address to, uint256 value) public onlyOwner returns (bool) {
370         require(value > 0);
371         _mint(to, value);
372         return true;
373     }
374 }