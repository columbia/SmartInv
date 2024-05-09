1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
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
36     constructor (string name, string symbol, uint8 decimals) public {
37         _name = name;
38         _symbol = symbol;
39         _decimals = decimals;
40     }
41 
42     /**
43      * @return the name of the token.
44      */
45     function name() public view returns (string) {
46         return _name;
47     }
48 
49     /**
50      * @return the symbol of the token.
51      */
52     function symbol() public view returns (string) {
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
66  * @dev Math operations with safety checks that revert on error
67  */
68 library SafeMath {
69     int256 constant private INT256_MIN = -2**255;
70 
71     /**
72     * @dev Multiplies two unsigned integers, reverts on overflow.
73     */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b);
84 
85         return c;
86     }
87 
88     /**
89     * @dev Multiplies two signed integers, reverts on overflow.
90     */
91     function mul(int256 a, int256 b) internal pure returns (int256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
95         if (a == 0) {
96             return 0;
97         }
98 
99         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
100 
101         int256 c = a * b;
102         require(c / a == b);
103 
104         return c;
105     }
106 
107     /**
108     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
109     */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         // Solidity only automatically asserts when dividing by 0
112         require(b > 0);
113         uint256 c = a / b;
114         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115 
116         return c;
117     }
118 
119     /**
120     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
121     */
122     function div(int256 a, int256 b) internal pure returns (int256) {
123         require(b != 0); // Solidity only automatically asserts when dividing by 0
124         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
125 
126         int256 c = a / b;
127 
128         return c;
129     }
130 
131     /**
132     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
133     */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         require(b <= a);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142     * @dev Subtracts two signed integers, reverts on overflow.
143     */
144     function sub(int256 a, int256 b) internal pure returns (int256) {
145         int256 c = a - b;
146         require((b >= 0 && c <= a) || (b < 0 && c > a));
147 
148         return c;
149     }
150 
151     /**
152     * @dev Adds two unsigned integers, reverts on overflow.
153     */
154     function add(uint256 a, uint256 b) internal pure returns (uint256) {
155         uint256 c = a + b;
156         require(c >= a);
157 
158         return c;
159     }
160 
161     /**
162     * @dev Adds two signed integers, reverts on overflow.
163     */
164     function add(int256 a, int256 b) internal pure returns (int256) {
165         int256 c = a + b;
166         require((b >= 0 && c >= a) || (b < 0 && c < a));
167 
168         return c;
169     }
170 
171     /**
172     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
173     * reverts when dividing by zero.
174     */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         require(b != 0);
177         return a % b;
178     }
179 }
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
186  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
187  *
188  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
189  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
190  * compliant implementations may not do it.
191  */
192 contract ERC20 is IERC20 {
193     using SafeMath for uint256;
194 
195     mapping (address => uint256) private _balances;
196 
197     mapping (address => mapping (address => uint256)) private _allowed;
198 
199     uint256 private _totalSupply;
200 
201     /**
202     * @dev Total number of tokens in existence
203     */
204     function totalSupply() public view returns (uint256) {
205         return _totalSupply;
206     }
207 
208     /**
209     * @dev Gets the balance of the specified address.
210     * @param owner The address to query the balance of.
211     * @return An uint256 representing the amount owned by the passed address.
212     */
213     function balanceOf(address owner) public view returns (uint256) {
214         return _balances[owner];
215     }
216 
217     /**
218      * @dev Function to check the amount of tokens that an owner allowed to a spender.
219      * @param owner address The address which owns the funds.
220      * @param spender address The address which will spend the funds.
221      * @return A uint256 specifying the amount of tokens still available for the spender.
222      */
223     function allowance(address owner, address spender) public view returns (uint256) {
224         return _allowed[owner][spender];
225     }
226 
227     /**
228     * @dev Transfer token for a specified address
229     * @param to The address to transfer to.
230     * @param value The amount to be transferred.
231     */
232     function transfer(address to, uint256 value) public returns (bool) {
233         _transfer(msg.sender, to, value);
234         return true;
235     }
236 
237     /**
238      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
239      * Beware that changing an allowance with this method brings the risk that someone may use both the old
240      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243      * @param spender The address which will spend the funds.
244      * @param value The amount of tokens to be spent.
245      */
246     function approve(address spender, uint256 value) public returns (bool) {
247         require(spender != address(0));
248 
249         _allowed[msg.sender][spender] = value;
250         emit Approval(msg.sender, spender, value);
251         return true;
252     }
253 
254     /**
255      * @dev Transfer tokens from one address to another.
256      * Note that while this function emits an Approval event, this is not required as per the specification,
257      * and other compliant implementations may not emit the event.
258      * @param from address The address which you want to send tokens from
259      * @param to address The address which you want to transfer to
260      * @param value uint256 the amount of tokens to be transferred
261      */
262     function transferFrom(address from, address to, uint256 value) public returns (bool) {
263         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
264         _transfer(from, to, value);
265         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
266         return true;
267     }
268 
269     /**
270      * @dev Increase the amount of tokens that an owner allowed to a spender.
271      * approve should be called when allowed_[_spender] == 0. To increment
272      * allowed value is better to use this function to avoid 2 calls (and wait until
273      * the first transaction is mined)
274      * From MonolithDAO Token.sol
275      * Emits an Approval event.
276      * @param spender The address which will spend the funds.
277      * @param addedValue The amount of tokens to increase the allowance by.
278      */
279     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
280         require(spender != address(0));
281 
282         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
283         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
284         return true;
285     }
286 
287     /**
288      * @dev Decrease the amount of tokens that an owner allowed to a spender.
289      * approve should be called when allowed_[_spender] == 0. To decrement
290      * allowed value is better to use this function to avoid 2 calls (and wait until
291      * the first transaction is mined)
292      * From MonolithDAO Token.sol
293      * Emits an Approval event.
294      * @param spender The address which will spend the funds.
295      * @param subtractedValue The amount of tokens to decrease the allowance by.
296      */
297     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
298         require(spender != address(0));
299 
300         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
301         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
302         return true;
303     }
304 
305     /**
306     * @dev Transfer token for a specified addresses
307     * @param from The address to transfer from.
308     * @param to The address to transfer to.
309     * @param value The amount to be transferred.
310     */
311     function _transfer(address from, address to, uint256 value) internal {
312         require(to != address(0));
313 
314         _balances[from] = _balances[from].sub(value);
315         _balances[to] = _balances[to].add(value);
316         emit Transfer(from, to, value);
317     }
318 
319     /**
320      * @dev Internal function that mints an amount of the token and assigns it to
321      * an account. This encapsulates the modification of balances such that the
322      * proper events are emitted.
323      * @param account The account that will receive the created tokens.
324      * @param value The amount that will be created.
325      */
326     function _mint(address account, uint256 value) internal {
327         require(account != address(0));
328 
329         _totalSupply = _totalSupply.add(value);
330         _balances[account] = _balances[account].add(value);
331         emit Transfer(address(0), account, value);
332     }
333 
334     /**
335      * @dev Internal function that burns an amount of the token of a given
336      * account.
337      * @param account The account whose tokens will be burnt.
338      * @param value The amount that will be burnt.
339      */
340     function _burn(address account, uint256 value) internal {
341         require(account != address(0));
342 
343         _totalSupply = _totalSupply.sub(value);
344         _balances[account] = _balances[account].sub(value);
345         emit Transfer(account, address(0), value);
346     }
347 
348     /**
349      * @dev Internal function that burns an amount of the token of a given
350      * account, deducting from the sender's allowance for said account. Uses the
351      * internal burn function.
352      * Emits an Approval event (reflecting the reduced allowance).
353      * @param account The account whose tokens will be burnt.
354      * @param value The amount that will be burnt.
355      */
356     function _burnFrom(address account, uint256 value) internal {
357         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
358         _burn(account, value);
359         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
360     }
361 }
362 
363 /**
364  * @title Roles
365  * @dev Library for managing addresses assigned to a Role.
366  */
367 library Roles {
368     struct Role {
369         mapping (address => bool) bearer;
370     }
371 
372     /**
373      * @dev give an account access to this role
374      */
375     function add(Role storage role, address account) internal {
376         require(account != address(0));
377         require(!has(role, account));
378 
379         role.bearer[account] = true;
380     }
381 
382     /**
383      * @dev remove an account's access to this role
384      */
385     function remove(Role storage role, address account) internal {
386         require(account != address(0));
387         require(has(role, account));
388 
389         role.bearer[account] = false;
390     }
391 
392     /**
393      * @dev check if an account has this role
394      * @return bool
395      */
396     function has(Role storage role, address account) internal view returns (bool) {
397         require(account != address(0));
398         return role.bearer[account];
399     }
400 }
401 
402 contract MinterRole {
403     using Roles for Roles.Role;
404 
405     event MinterAdded(address indexed account);
406     event MinterRemoved(address indexed account);
407 
408     Roles.Role private _minters;
409 
410     constructor () internal {
411         _addMinter(msg.sender);
412     }
413 
414     modifier onlyMinter() {
415         require(isMinter(msg.sender));
416         _;
417     }
418 
419     function isMinter(address account) public view returns (bool) {
420         return _minters.has(account);
421     }
422 
423     function addMinter(address account) public onlyMinter {
424         _addMinter(account);
425     }
426 
427     function renounceMinter() public {
428         _removeMinter(msg.sender);
429     }
430 
431     function _addMinter(address account) internal {
432         _minters.add(account);
433         emit MinterAdded(account);
434     }
435 
436     function _removeMinter(address account) internal {
437         _minters.remove(account);
438         emit MinterRemoved(account);
439     }
440 }
441 
442 /**
443  * @title ERC20Mintable
444  * @dev ERC20 minting logic
445  */
446 contract ERC20Mintable is ERC20, MinterRole {
447     /**
448      * @dev Function to mint tokens
449      * @param to The address that will receive the minted tokens.
450      * @param value The amount of tokens to mint.
451      * @return A boolean that indicates if the operation was successful.
452      */
453     function mint(address to, uint256 value) public onlyMinter returns (bool) {
454         _mint(to, value);
455         return true;
456     }
457 }
458 
459 /**
460  * @title Burnable Token
461  * @dev Token that can be irreversibly burned (destroyed).
462  */
463 contract ERC20Burnable is ERC20 {
464     /**
465      * @dev Burns a specific amount of tokens.
466      * @param value The amount of token to be burned.
467      */
468     function burn(uint256 value) public {
469         _burn(msg.sender, value);
470     }
471 
472     /**
473      * @dev Burns a specific amount of tokens from the target address and decrements allowance
474      * @param from address The address which you want to send tokens from
475      * @param value uint256 The amount of token to be burned
476      */
477     function burnFrom(address from, uint256 value) public {
478         _burnFrom(from, value);
479     }
480 }
481 
482 contract WTX2019Token is ERC20Detailed, ERC20Mintable, ERC20Burnable  {
483     constructor() ERC20Detailed("Wintex 2019 Token", "WTX2019", 4) public {}
484 }