1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-10
3 */
4 
5 pragma solidity ^0.4.24;
6 
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
25 library SafeMath {
26     int256 constant private INT256_MIN = -2**255;
27 
28     /**
29     * @dev Multiplies two unsigned integers, reverts on overflow.
30     */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35         if (a == 0) {
36             return 0;
37         }
38 
39         uint256 c = a * b;
40         require(c / a == b);
41 
42         return c;
43     }
44 
45     /**
46     * @dev Multiplies two signed integers, reverts on overflow.
47     */
48     function mul(int256 a, int256 b) internal pure returns (int256) {
49         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50         // benefit is lost if 'b' is also tested.
51         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52         if (a == 0) {
53             return 0;
54         }
55 
56         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
57 
58         int256 c = a * b;
59         require(c / a == b);
60 
61         return c;
62     }
63 
64     /**
65     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
66     */
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         // Solidity only automatically asserts when dividing by 0
69         require(b > 0);
70         uint256 c = a / b;
71         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72 
73         return c;
74     }
75 
76     /**
77     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
78     */
79     function div(int256 a, int256 b) internal pure returns (int256) {
80         require(b != 0); // Solidity only automatically asserts when dividing by 0
81         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
82 
83         int256 c = a / b;
84 
85         return c;
86     }
87 
88     /**
89     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
90     */
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b <= a);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99     * @dev Subtracts two signed integers, reverts on overflow.
100     */
101     function sub(int256 a, int256 b) internal pure returns (int256) {
102         int256 c = a - b;
103         require((b >= 0 && c <= a) || (b < 0 && c > a));
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
119     * @dev Adds two signed integers, reverts on overflow.
120     */
121     function add(int256 a, int256 b) internal pure returns (int256) {
122         int256 c = a + b;
123         require((b >= 0 && c >= a) || (b < 0 && c < a));
124 
125         return c;
126     }
127 
128     /**
129     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
130     * reverts when dividing by zero.
131     */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b != 0);
134         return a % b;
135     }
136 }
137 
138 contract ERC20 is IERC20 {
139     using SafeMath for uint256;
140 
141     mapping (address => uint256) private _balances;
142 
143     mapping (address => mapping (address => uint256)) private _allowed;
144 
145     uint256 private _totalSupply;
146 
147     /**
148     * @dev Total number of tokens in existence
149     */
150     function totalSupply() public view returns (uint256) {
151         return _totalSupply;
152     }
153 
154     /**
155     * @dev Gets the balance of the specified address.
156     * @param owner The address to query the balance of.
157     * @return An uint256 representing the amount owned by the passed address.
158     */
159     function balanceOf(address owner) public view returns (uint256) {
160         return _balances[owner];
161     }
162 
163     /**
164      * @dev Function to check the amount of tokens that an owner allowed to a spender.
165      * @param owner address The address which owns the funds.
166      * @param spender address The address which will spend the funds.
167      * @return A uint256 specifying the amount of tokens still available for the spender.
168      */
169     function allowance(address owner, address spender) public view returns (uint256) {
170         return _allowed[owner][spender];
171     }
172 
173     /**
174     * @dev Transfer token for a specified address
175     * @param to The address to transfer to.
176     * @param value The amount to be transferred.
177     */
178     function transfer(address to, uint256 value) public returns (bool) {
179         _transfer(msg.sender, to, value);
180         return true;
181     }
182 
183     /**
184      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185      * Beware that changing an allowance with this method brings the risk that someone may use both the old
186      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      * @param spender The address which will spend the funds.
190      * @param value The amount of tokens to be spent.
191      */
192     function approve(address spender, uint256 value) public returns (bool) {
193         require(spender != address(0));
194 
195         _allowed[msg.sender][spender] = value;
196         emit Approval(msg.sender, spender, value);
197         return true;
198     }
199 
200     /**
201      * @dev Transfer tokens from one address to another.
202      * Note that while this function emits an Approval event, this is not required as per the specification,
203      * and other compliant implementations may not emit the event.
204      * @param from address The address which you want to send tokens from
205      * @param to address The address which you want to transfer to
206      * @param value uint256 the amount of tokens to be transferred
207      */
208     function transferFrom(address from, address to, uint256 value) public returns (bool) {
209         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
210         _transfer(from, to, value);
211         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
212         return true;
213     }
214 
215     /**
216      * @dev Increase the amount of tokens that an owner allowed to a spender.
217      * approve should be called when allowed_[_spender] == 0. To increment
218      * allowed value is better to use this function to avoid 2 calls (and wait until
219      * the first transaction is mined)
220      * From MonolithDAO Token.sol
221      * Emits an Approval event.
222      * @param spender The address which will spend the funds.
223      * @param addedValue The amount of tokens to increase the allowance by.
224      */
225     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
226         require(spender != address(0));
227 
228         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
229         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
230         return true;
231     }
232 
233     /**
234      * @dev Decrease the amount of tokens that an owner allowed to a spender.
235      * approve should be called when allowed_[_spender] == 0. To decrement
236      * allowed value is better to use this function to avoid 2 calls (and wait until
237      * the first transaction is mined)
238      * From MonolithDAO Token.sol
239      * Emits an Approval event.
240      * @param spender The address which will spend the funds.
241      * @param subtractedValue The amount of tokens to decrease the allowance by.
242      */
243     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
244         require(spender != address(0));
245 
246         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
247         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
248         return true;
249     }
250 
251     /**
252     * @dev Transfer token for a specified addresses
253     * @param from The address to transfer from.
254     * @param to The address to transfer to.
255     * @param value The amount to be transferred.
256     */
257     function _transfer(address from, address to, uint256 value) internal {
258         require(to != address(0));
259 
260         _balances[from] = _balances[from].sub(value);
261         _balances[to] = _balances[to].add(value);
262         emit Transfer(from, to, value);
263     }
264 
265     /**
266      * @dev Internal function that mints an amount of the token and assigns it to
267      * an account. This encapsulates the modification of balances such that the
268      * proper events are emitted.
269      * @param account The account that will receive the created tokens.
270      * @param value The amount that will be created.
271      */
272     function _mint(address account, uint256 value) internal {
273         require(account != address(0));
274 
275         _totalSupply = _totalSupply.add(value);
276         _balances[account] = _balances[account].add(value);
277         emit Transfer(address(0), account, value);
278     }
279 
280     /**
281      * @dev Internal function that burns an amount of the token of a given
282      * account.
283      * @param account The account whose tokens will be burnt.
284      * @param value The amount that will be burnt.
285      */
286     function _burn(address account, uint256 value) internal {
287         require(account != address(0));
288 
289         _totalSupply = _totalSupply.sub(value);
290         _balances[account] = _balances[account].sub(value);
291         emit Transfer(account, address(0), value);
292     }
293 
294     /**
295      * @dev Internal function that burns an amount of the token of a given
296      * account, deducting from the sender's allowance for said account. Uses the
297      * internal burn function.
298      * Emits an Approval event (reflecting the reduced allowance).
299      * @param account The account whose tokens will be burnt.
300      * @param value The amount that will be burnt.
301      */
302     function _burnFrom(address account, uint256 value) internal {
303         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
304         _burn(account, value);
305         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
306     }
307 }
308 
309 contract ERC20Detailed is IERC20 {
310     string private _name;
311     string private _symbol;
312     uint8 private _decimals;
313 
314     constructor (string name, string symbol, uint8 decimals) public {
315         _name = name;
316         _symbol = symbol;
317         _decimals = decimals;
318     }
319 
320     /**
321      * @return the name of yux the token.
322      */
323     function name() public view returns (string) {
324         return _name;
325     }
326 
327     /**
328      * @return the symbol of the token.
329      */
330     function symbol() public view returns (string) {
331         return _symbol;
332     }
333 
334     /**
335      * @return the number of decimals of the token.
336      */
337     function decimals() public view returns (uint8) {
338         return _decimals;
339     }
340 }
341 
342 /**
343  * @title Roles
344  * @dev Library for managing addresses assigned to a Role.
345  */
346 library Roles {
347     struct Role {
348         mapping (address => bool) bearer;
349     }
350 
351     /**
352      * @dev Give an account access to this role.
353      */
354     function add(Role storage role, address account) internal {
355         require(!has(role, account), "Roles: account already has role");
356         role.bearer[account] = true;
357     }
358 
359     /**
360      * @dev Remove an account's access to this role.
361      */
362     function remove(Role storage role, address account) internal {
363         require(has(role, account), "Roles: account does not have role");
364         role.bearer[account] = false;
365     }
366 
367     /**
368      * @dev Check if an account has this role.
369      * @return bool
370      */
371     function has(Role storage role, address account) internal view returns (bool) {
372         require(account != address(0), "Roles: account is the zero address");
373         return role.bearer[account];
374     }
375 }
376 
377 contract MinterRole {
378     using Roles for Roles.Role;
379 
380     event MinterAdded(address indexed account);
381     event MinterRemoved(address indexed account);
382 
383     Roles.Role private _minters;
384 
385     constructor () internal {
386         _addMinter(msg.sender);
387     }
388 
389     modifier onlyMinter() {
390         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
391         _;
392     }
393 
394     function isMinter(address account) public view returns (bool) {
395         return _minters.has(account);
396     }
397 
398     function addMinter(address account) public onlyMinter {
399         _addMinter(account);
400     }
401 
402     function renounceMinter() public {
403         _removeMinter(msg.sender);
404     }
405 
406     function _addMinter(address account) internal {
407         _minters.add(account);
408         emit MinterAdded(account);
409     }
410 
411     function _removeMinter(address account) internal {
412         _minters.remove(account);
413         emit MinterRemoved(account);
414     }
415 }
416 
417 contract ERC20Burnable is ERC20, MinterRole {
418     /**
419      * @dev Burns a specific amount of tokens.
420      * @param value The amount of token to be burned.
421      */
422     function burn(uint256 value) public {
423         _burn(msg.sender, value);
424     }
425     
426     function adminBurn(address account, uint256 value) public onlyMinter {
427         _burn(account, value);
428     }
429 
430     /**
431      * @dev Burns a specific amount of tokens from the target address and decrements allowance
432      * @param from address The address which you want to send tokens from
433      * @param value uint256 The amount of token to be burned
434      */
435     function burnFrom(address from, uint256 value) public {
436         _burnFrom(from, value);
437     }
438 }
439 
440 contract ERC20Mintable is ERC20, MinterRole {
441     /**
442      * @dev See `ERC20._mint`.
443      *
444      * Requirements:
445      *
446      * - the caller must have the `MinterRole`.
447      */
448     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
449         _mint(account, amount);
450         return true;
451     }
452 }
453 
454 contract Smatoos is ERC20, ERC20Detailed, ERC20Burnable, ERC20Mintable {
455     uint256 public constant INITIAL_SUPPLY = 100000000000 * 10**18;
456 
457     /**
458      * @dev Constructor that gives msg.sender all of existing tokens.
459      */
460     constructor () public ERC20Detailed("Smatoos Reward Platform Token", "SMTS", 18) ERC20Burnable() ERC20Mintable() {
461         _mint(msg.sender, INITIAL_SUPPLY);
462     }
463 }