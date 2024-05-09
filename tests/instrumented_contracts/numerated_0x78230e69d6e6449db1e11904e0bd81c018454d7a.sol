1 pragma solidity 0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title ERC20Detailed token
27  * @dev The decimals are only for visualization purposes.
28  * All the operations are done using the smallest and indivisible token unit,
29  * just as on Ethereum all the operations are done in wei.
30  */
31 contract ERC20Detailed is IERC20 {
32     string private _name;
33     string private _symbol;
34     uint8 private _decimals;
35 
36     constructor (string memory name, string memory symbol, uint8 decimals) public {
37         _name = name;
38         _symbol = symbol;
39         _decimals = decimals;
40     }
41 
42     /**
43      * @return the name of the token.
44      */
45     function name() public view returns (string memory) {
46         return _name;
47     }
48 
49     /**
50      * @return the symbol of the token.
51      */
52     function symbol() public view returns (string memory) {
53         return _symbol;
54     }
55 
56     /**
57      * @return the number of decimals of the token.
58      */
59     function decimals() public view returns (uint8) {
60         return _decimals;
61     }
62 }
63 
64 /**
65  * @title SafeMath
66  * @dev Unsigned math operations with safety checks that revert on error
67  */
68 library SafeMath {
69     /**
70     * @dev Multiplies two unsigned integers, reverts on overflow.
71     */
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
74         // benefit is lost if 'b' is also tested.
75         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
76         if (a == 0) {
77             return 0;
78         }
79 
80         uint256 c = a * b;
81         require(c / a == b);
82 
83         return c;
84     }
85 
86     /**
87     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
88     */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Solidity only automatically asserts when dividing by 0
91         require(b > 0);
92         uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
109     * @dev Adds two unsigned integers, reverts on overflow.
110     */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a);
114 
115         return c;
116     }
117 
118     /**
119     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
120     * reverts when dividing by zero.
121     */
122     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
123         require(b != 0);
124         return a % b;
125     }
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
133  * Originally based on code by FirstBlood:
134  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  *
136  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
137  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
138  * compliant implementations may not do it.
139  */
140 contract ERC20 is IERC20 {
141     using SafeMath for uint256;
142 
143     mapping (address => uint256) private _balances;
144 
145     mapping (address => mapping (address => uint256)) private _allowed;
146 
147     uint256 private _totalSupply;
148 
149     /**
150     * @dev Total number of tokens in existence
151     */
152     function totalSupply() public view returns (uint256) {
153         return _totalSupply;
154     }
155 
156     /**
157     * @dev Gets the balance of the specified address.
158     * @param owner The address to query the balance of.
159     * @return An uint256 representing the amount owned by the passed address.
160     */
161     function balanceOf(address owner) public view returns (uint256) {
162         return _balances[owner];
163     }
164 
165     /**
166      * @dev Function to check the amount of tokens that an owner allowed to a spender.
167      * @param owner address The address which owns the funds.
168      * @param spender address The address which will spend the funds.
169      * @return A uint256 specifying the amount of tokens still available for the spender.
170      */
171     function allowance(address owner, address spender) public view returns (uint256) {
172         return _allowed[owner][spender];
173     }
174 
175     /**
176     * @dev Transfer token for a specified address
177     * @param to The address to transfer to.
178     * @param value The amount to be transferred.
179     */
180     function transfer(address to, uint256 value) public returns (bool) {
181         _transfer(msg.sender, to, value);
182         return true;
183     }
184 
185     /**
186      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187      * Beware that changing an allowance with this method brings the risk that someone may use both the old
188      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      * @param spender The address which will spend the funds.
192      * @param value The amount of tokens to be spent.
193      */
194     function approve(address spender, uint256 value) public returns (bool) {
195         require(spender != address(0));
196 
197         _allowed[msg.sender][spender] = value;
198         emit Approval(msg.sender, spender, value);
199         return true;
200     }
201 
202     /**
203      * @dev Transfer tokens from one address to another.
204      * Note that while this function emits an Approval event, this is not required as per the specification,
205      * and other compliant implementations may not emit the event.
206      * @param from address The address which you want to send tokens from
207      * @param to address The address which you want to transfer to
208      * @param value uint256 the amount of tokens to be transferred
209      */
210     function transferFrom(address from, address to, uint256 value) public returns (bool) {
211         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
212         _transfer(from, to, value);
213         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
214         return true;
215     }
216 
217     /**
218      * @dev Increase the amount of tokens that an owner allowed to a spender.
219      * approve should be called when allowed_[_spender] == 0. To increment
220      * allowed value is better to use this function to avoid 2 calls (and wait until
221      * the first transaction is mined)
222      * From MonolithDAO Token.sol
223      * Emits an Approval event.
224      * @param spender The address which will spend the funds.
225      * @param addedValue The amount of tokens to increase the allowance by.
226      */
227     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
228         require(spender != address(0));
229 
230         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
231         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
232         return true;
233     }
234 
235     /**
236      * @dev Decrease the amount of tokens that an owner allowed to a spender.
237      * approve should be called when allowed_[_spender] == 0. To decrement
238      * allowed value is better to use this function to avoid 2 calls (and wait until
239      * the first transaction is mined)
240      * From MonolithDAO Token.sol
241      * Emits an Approval event.
242      * @param spender The address which will spend the funds.
243      * @param subtractedValue The amount of tokens to decrease the allowance by.
244      */
245     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
246         require(spender != address(0));
247 
248         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
249         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
250         return true;
251     }
252 
253     /**
254     * @dev Transfer token for a specified addresses
255     * @param from The address to transfer from.
256     * @param to The address to transfer to.
257     * @param value The amount to be transferred.
258     */
259     function _transfer(address from, address to, uint256 value) internal {
260         require(to != address(0));
261 
262         _balances[from] = _balances[from].sub(value);
263         _balances[to] = _balances[to].add(value);
264         emit Transfer(from, to, value);
265     }
266 
267     /**
268      * @dev Internal function that mints an amount of the token and assigns it to
269      * an account. This encapsulates the modification of balances such that the
270      * proper events are emitted.
271      * @param account The account that will receive the created tokens.
272      * @param value The amount that will be created.
273      */
274     function _mint(address account, uint256 value) internal {
275         require(account != address(0));
276 
277         _totalSupply = _totalSupply.add(value);
278         _balances[account] = _balances[account].add(value);
279         emit Transfer(address(0), account, value);
280     }
281 
282     /**
283      * @dev Internal function that burns an amount of the token of a given
284      * account.
285      * @param account The account whose tokens will be burnt.
286      * @param value The amount that will be burnt.
287      */
288     function _burn(address account, uint256 value) internal {
289         require(account != address(0));
290 
291         _totalSupply = _totalSupply.sub(value);
292         _balances[account] = _balances[account].sub(value);
293         emit Transfer(account, address(0), value);
294     }
295 
296     /**
297      * @dev Internal function that burns an amount of the token of a given
298      * account, deducting from the sender's allowance for said account. Uses the
299      * internal burn function.
300      * Emits an Approval event (reflecting the reduced allowance).
301      * @param account The account whose tokens will be burnt.
302      * @param value The amount that will be burnt.
303      */
304     function _burnFrom(address account, uint256 value) internal {
305         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
306         _burn(account, value);
307         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
308     }
309 }
310 
311 /**
312  * @title Roles
313  * @dev Library for managing addresses assigned to a Role.
314  */
315 library Roles {
316     struct Role {
317         mapping (address => bool) bearer;
318     }
319 
320     /**
321      * @dev give an account access to this role
322      */
323     function add(Role storage role, address account) internal {
324         require(account != address(0));
325         require(!has(role, account));
326 
327         role.bearer[account] = true;
328     }
329 
330     /**
331      * @dev remove an account's access to this role
332      */
333     function remove(Role storage role, address account) internal {
334         require(account != address(0));
335         require(has(role, account));
336 
337         role.bearer[account] = false;
338     }
339 
340     /**
341      * @dev check if an account has this role
342      * @return bool
343      */
344     function has(Role storage role, address account) internal view returns (bool) {
345         require(account != address(0));
346         return role.bearer[account];
347     }
348 }
349 
350 contract MinterRole {
351     using Roles for Roles.Role;
352 
353     event MinterAdded(address indexed account);
354     event MinterRemoved(address indexed account);
355 
356     Roles.Role private _minters;
357 
358     constructor () internal {
359         _addMinter(msg.sender);
360     }
361 
362     modifier onlyMinter() {
363         require(isMinter(msg.sender));
364         _;
365     }
366 
367     function isMinter(address account) public view returns (bool) {
368         return _minters.has(account);
369     }
370 
371     function addMinter(address account) public onlyMinter {
372         _addMinter(account);
373     }
374 
375     function renounceMinter() public {
376         _removeMinter(msg.sender);
377     }
378 
379     function _addMinter(address account) internal {
380         _minters.add(account);
381         emit MinterAdded(account);
382     }
383 
384     function _removeMinter(address account) internal {
385         _minters.remove(account);
386         emit MinterRemoved(account);
387     }
388 }
389 
390 /**
391  * @title ERC20Mintable
392  * @dev ERC20 minting logic
393  */
394 contract ERC20Mintable is ERC20, MinterRole {
395     /**
396      * @dev Function to mint tokens
397      * @param to The address that will receive the minted tokens.
398      * @param value The amount of tokens to mint.
399      * @return A boolean that indicates if the operation was successful.
400      */
401     function mint(address to, uint256 value) public onlyMinter returns (bool) {
402         _mint(to, value);
403         return true;
404     }
405 }
406 
407 /**
408  * @title Burnable Token
409  * @dev Token that can be irreversibly burned (destroyed).
410  */
411 contract ERC20Burnable is ERC20 {
412     /**
413      * @dev Burns a specific amount of tokens.
414      * @param value The amount of token to be burned.
415      */
416     function burn(uint256 value) public {
417         _burn(msg.sender, value);
418     }
419 
420     /**
421      * @dev Burns a specific amount of tokens from the target address and decrements allowance
422      * @param from address The address which you want to send tokens from
423      * @param value uint256 The amount of token to be burned
424      */
425     function burnFrom(address from, uint256 value) public {
426         _burnFrom(from, value);
427     }
428 }
429 
430 /**
431  * @title NativeToken
432  * @dev Simple mintable ERC20 Token, where all tokens are pre-assigned to the creator.
433  * Note they can later distribute these tokens as they wish using `transfer` and other
434  * `StandardToken` functions.
435  */
436 
437 contract NativeToken is ERC20Detailed, ERC20Mintable, ERC20Burnable {
438 
439   constructor(string memory _name, string memory _symbol, uint8 _decimals) 
440     public ERC20Detailed(_name, _symbol, _decimals) {
441   }
442 
443 }