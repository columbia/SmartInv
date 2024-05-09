1 pragma solidity 0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
28 
29 /**
30  * @title ERC20Detailed token
31  * @dev The decimals are only for visualization purposes.
32  * All the operations are done using the smallest and indivisible token unit,
33  * just as on Ethereum all the operations are done in wei.
34  */
35 contract ERC20Detailed is IERC20 {
36     string private _name;
37     string private _symbol;
38     uint8 private _decimals;
39 
40     constructor (string memory name, string memory symbol, uint8 decimals) public {
41         _name = name;
42         _symbol = symbol;
43         _decimals = decimals;
44     }
45 
46     /**
47      * @return the name of the token.
48      */
49     function name() public view returns (string memory) {
50         return _name;
51     }
52 
53     /**
54      * @return the symbol of the token.
55      */
56     function symbol() public view returns (string memory) {
57         return _symbol;
58     }
59 
60     /**
61      * @return the number of decimals of the token.
62      */
63     function decimals() public view returns (uint8) {
64         return _decimals;
65     }
66 }
67 
68 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
69 
70 /**
71  * @title SafeMath
72  * @dev Unsigned math operations with safety checks that revert on error
73  */
74 library SafeMath {
75     /**
76     * @dev Multiplies two unsigned integers, reverts on overflow.
77     */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b);
88 
89         return c;
90     }
91 
92     /**
93     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
94     */
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Solidity only automatically asserts when dividing by 0
97         require(b > 0);
98         uint256 c = a / b;
99         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101         return c;
102     }
103 
104     /**
105     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
106     */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b <= a);
109         uint256 c = a - b;
110 
111         return c;
112     }
113 
114     /**
115     * @dev Adds two unsigned integers, reverts on overflow.
116     */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a);
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
134 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
141  * Originally based on code by FirstBlood:
142  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  *
144  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
145  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
146  * compliant implementations may not do it.
147  */
148 contract ERC20 is IERC20 {
149     using SafeMath for uint256;
150 
151     mapping (address => uint256) private _balances;
152 
153     mapping (address => mapping (address => uint256)) private _allowed;
154 
155     uint256 private _totalSupply;
156 
157     /**
158     * @dev Total number of tokens in existence
159     */
160     function totalSupply() public view returns (uint256) {
161         return _totalSupply;
162     }
163 
164     /**
165     * @dev Gets the balance of the specified address.
166     * @param owner The address to query the balance of.
167     * @return An uint256 representing the amount owned by the passed address.
168     */
169     function balanceOf(address owner) public view returns (uint256) {
170         return _balances[owner];
171     }
172 
173     /**
174      * @dev Function to check the amount of tokens that an owner allowed to a spender.
175      * @param owner address The address which owns the funds.
176      * @param spender address The address which will spend the funds.
177      * @return A uint256 specifying the amount of tokens still available for the spender.
178      */
179     function allowance(address owner, address spender) public view returns (uint256) {
180         return _allowed[owner][spender];
181     }
182 
183     /**
184     * @dev Transfer token for a specified address
185     * @param to The address to transfer to.
186     * @param value The amount to be transferred.
187     */
188     function transfer(address to, uint256 value) public returns (bool) {
189         _transfer(msg.sender, to, value);
190         return true;
191     }
192 
193     /**
194      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195      * Beware that changing an allowance with this method brings the risk that someone may use both the old
196      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      * @param spender The address which will spend the funds.
200      * @param value The amount of tokens to be spent.
201      */
202     function approve(address spender, uint256 value) public returns (bool) {
203         require(spender != address(0));
204 
205         _allowed[msg.sender][spender] = value;
206         emit Approval(msg.sender, spender, value);
207         return true;
208     }
209 
210     /**
211      * @dev Transfer tokens from one address to another.
212      * Note that while this function emits an Approval event, this is not required as per the specification,
213      * and other compliant implementations may not emit the event.
214      * @param from address The address which you want to send tokens from
215      * @param to address The address which you want to transfer to
216      * @param value uint256 the amount of tokens to be transferred
217      */
218     function transferFrom(address from, address to, uint256 value) public returns (bool) {
219         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
220         _transfer(from, to, value);
221         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
222         return true;
223     }
224 
225     /**
226      * @dev Increase the amount of tokens that an owner allowed to a spender.
227      * approve should be called when allowed_[_spender] == 0. To increment
228      * allowed value is better to use this function to avoid 2 calls (and wait until
229      * the first transaction is mined)
230      * From MonolithDAO Token.sol
231      * Emits an Approval event.
232      * @param spender The address which will spend the funds.
233      * @param addedValue The amount of tokens to increase the allowance by.
234      */
235     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
236         require(spender != address(0));
237 
238         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
239         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
240         return true;
241     }
242 
243     /**
244      * @dev Decrease the amount of tokens that an owner allowed to a spender.
245      * approve should be called when allowed_[_spender] == 0. To decrement
246      * allowed value is better to use this function to avoid 2 calls (and wait until
247      * the first transaction is mined)
248      * From MonolithDAO Token.sol
249      * Emits an Approval event.
250      * @param spender The address which will spend the funds.
251      * @param subtractedValue The amount of tokens to decrease the allowance by.
252      */
253     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
254         require(spender != address(0));
255 
256         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
257         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
258         return true;
259     }
260 
261     /**
262     * @dev Transfer token for a specified addresses
263     * @param from The address to transfer from.
264     * @param to The address to transfer to.
265     * @param value The amount to be transferred.
266     */
267     function _transfer(address from, address to, uint256 value) internal {
268         require(to != address(0));
269 
270         _balances[from] = _balances[from].sub(value);
271         _balances[to] = _balances[to].add(value);
272         emit Transfer(from, to, value);
273     }
274 
275     /**
276      * @dev Internal function that mints an amount of the token and assigns it to
277      * an account. This encapsulates the modification of balances such that the
278      * proper events are emitted.
279      * @param account The account that will receive the created tokens.
280      * @param value The amount that will be created.
281      */
282     function _mint(address account, uint256 value) internal {
283         require(account != address(0));
284 
285         _totalSupply = _totalSupply.add(value);
286         _balances[account] = _balances[account].add(value);
287         emit Transfer(address(0), account, value);
288     }
289 
290     /**
291      * @dev Internal function that burns an amount of the token of a given
292      * account.
293      * @param account The account whose tokens will be burnt.
294      * @param value The amount that will be burnt.
295      */
296     function _burn(address account, uint256 value) internal {
297         require(account != address(0));
298 
299         _totalSupply = _totalSupply.sub(value);
300         _balances[account] = _balances[account].sub(value);
301         emit Transfer(account, address(0), value);
302     }
303 
304     /**
305      * @dev Internal function that burns an amount of the token of a given
306      * account, deducting from the sender's allowance for said account. Uses the
307      * internal burn function.
308      * Emits an Approval event (reflecting the reduced allowance).
309      * @param account The account whose tokens will be burnt.
310      * @param value The amount that will be burnt.
311      */
312     function _burnFrom(address account, uint256 value) internal {
313         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
314         _burn(account, value);
315         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
316     }
317 }
318 
319 // File: openzeppelin-solidity/contracts/access/Roles.sol
320 
321 /**
322  * @title Roles
323  * @dev Library for managing addresses assigned to a Role.
324  */
325 library Roles {
326     struct Role {
327         mapping (address => bool) bearer;
328     }
329 
330     /**
331      * @dev give an account access to this role
332      */
333     function add(Role storage role, address account) internal {
334         require(account != address(0));
335         require(!has(role, account));
336 
337         role.bearer[account] = true;
338     }
339 
340     /**
341      * @dev remove an account's access to this role
342      */
343     function remove(Role storage role, address account) internal {
344         require(account != address(0));
345         require(has(role, account));
346 
347         role.bearer[account] = false;
348     }
349 
350     /**
351      * @dev check if an account has this role
352      * @return bool
353      */
354     function has(Role storage role, address account) internal view returns (bool) {
355         require(account != address(0));
356         return role.bearer[account];
357     }
358 }
359 
360 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
361 
362 contract MinterRole {
363     using Roles for Roles.Role;
364 
365     event MinterAdded(address indexed account);
366     event MinterRemoved(address indexed account);
367 
368     Roles.Role private _minters;
369 
370     constructor () internal {
371         _addMinter(msg.sender);
372     }
373 
374     modifier onlyMinter() {
375         require(isMinter(msg.sender));
376         _;
377     }
378 
379     function isMinter(address account) public view returns (bool) {
380         return _minters.has(account);
381     }
382 
383     function addMinter(address account) public onlyMinter {
384         _addMinter(account);
385     }
386 
387     function renounceMinter() public {
388         _removeMinter(msg.sender);
389     }
390 
391     function _addMinter(address account) internal {
392         _minters.add(account);
393         emit MinterAdded(account);
394     }
395 
396     function _removeMinter(address account) internal {
397         _minters.remove(account);
398         emit MinterRemoved(account);
399     }
400 }
401 
402 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
403 
404 /**
405  * @title ERC20Mintable
406  * @dev ERC20 minting logic
407  */
408 contract ERC20Mintable is ERC20, MinterRole {
409     /**
410      * @dev Function to mint tokens
411      * @param to The address that will receive the minted tokens.
412      * @param value The amount of tokens to mint.
413      * @return A boolean that indicates if the operation was successful.
414      */
415     function mint(address to, uint256 value) public onlyMinter returns (bool) {
416         _mint(to, value);
417         return true;
418     }
419 }
420 
421 // File: contracts/Token.sol
422 
423 contract Token is ERC20Detailed, ERC20Mintable {
424 
425   constructor() ERC20Detailed("LondonCoin", "LNC", 18) public {
426   }
427 
428 }