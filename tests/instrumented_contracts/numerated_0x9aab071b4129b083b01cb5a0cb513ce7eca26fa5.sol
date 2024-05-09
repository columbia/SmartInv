1 pragma solidity ^0.5.0;
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
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Unsigned math operations with safety checks that revert on error
30  */
31 library SafeMath {
32     /**
33     * @dev Multiplies two unsigned integers, reverts on overflow.
34     */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b);
45 
46         return c;
47     }
48 
49     /**
50     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
51     */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Solidity only automatically asserts when dividing by 0
54         require(b > 0);
55         uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58         return c;
59     }
60 
61     /**
62     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
63     */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b <= a);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72     * @dev Adds two unsigned integers, reverts on overflow.
73     */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a);
77 
78         return c;
79     }
80 
81     /**
82     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
83     * reverts when dividing by zero.
84     */
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b != 0);
87         return a % b;
88     }
89 }
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
97  * Originally based on code by FirstBlood:
98  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  *
100  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
101  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
102  * compliant implementations may not do it.
103  */
104 contract ERC20 is IERC20 {
105     using SafeMath for uint256;
106 
107     mapping (address => uint256) private _balances;
108 
109     mapping (address => mapping (address => uint256)) private _allowed;
110 
111     uint256 private _totalSupply;
112 
113     /**
114     * @dev Total number of tokens in existence
115     */
116     function totalSupply() public view returns (uint256) {
117         return _totalSupply;
118     }
119 
120     /**
121     * @dev Gets the balance of the specified address.
122     * @param owner The address to query the balance of.
123     * @return An uint256 representing the amount owned by the passed address.
124     */
125     function balanceOf(address owner) public view returns (uint256) {
126         return _balances[owner];
127     }
128 
129     /**
130      * @dev Function to check the amount of tokens that an owner allowed to a spender.
131      * @param owner address The address which owns the funds.
132      * @param spender address The address which will spend the funds.
133      * @return A uint256 specifying the amount of tokens still available for the spender.
134      */
135     function allowance(address owner, address spender) public view returns (uint256) {
136         return _allowed[owner][spender];
137     }
138 
139     /**
140     * @dev Transfer token for a specified address
141     * @param to The address to transfer to.
142     * @param value The amount to be transferred.
143     */
144     function transfer(address to, uint256 value) public returns (bool) {
145         _transfer(msg.sender, to, value);
146         return true;
147     }
148 
149     /**
150      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151      * Beware that changing an allowance with this method brings the risk that someone may use both the old
152      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      * @param spender The address which will spend the funds.
156      * @param value The amount of tokens to be spent.
157      */
158     function approve(address spender, uint256 value) public returns (bool) {
159         require(spender != address(0));
160 
161         _allowed[msg.sender][spender] = value;
162         emit Approval(msg.sender, spender, value);
163         return true;
164     }
165 
166     /**
167      * @dev Transfer tokens from one address to another.
168      * Note that while this function emits an Approval event, this is not required as per the specification,
169      * and other compliant implementations may not emit the event.
170      * @param from address The address which you want to send tokens from
171      * @param to address The address which you want to transfer to
172      * @param value uint256 the amount of tokens to be transferred
173      */
174     function transferFrom(address from, address to, uint256 value) public returns (bool) {
175         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
176         _transfer(from, to, value);
177         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
178         return true;
179     }
180 
181     /**
182      * @dev Increase the amount of tokens that an owner allowed to a spender.
183      * approve should be called when allowed_[_spender] == 0. To increment
184      * allowed value is better to use this function to avoid 2 calls (and wait until
185      * the first transaction is mined)
186      * From MonolithDAO Token.sol
187      * Emits an Approval event.
188      * @param spender The address which will spend the funds.
189      * @param addedValue The amount of tokens to increase the allowance by.
190      */
191     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
192         require(spender != address(0));
193 
194         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
195         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
196         return true;
197     }
198 
199     /**
200      * @dev Decrease the amount of tokens that an owner allowed to a spender.
201      * approve should be called when allowed_[_spender] == 0. To decrement
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * Emits an Approval event.
206      * @param spender The address which will spend the funds.
207      * @param subtractedValue The amount of tokens to decrease the allowance by.
208      */
209     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
210         require(spender != address(0));
211 
212         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
213         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
214         return true;
215     }
216 
217     /**
218     * @dev Transfer token for a specified addresses
219     * @param from The address to transfer from.
220     * @param to The address to transfer to.
221     * @param value The amount to be transferred.
222     */
223     function _transfer(address from, address to, uint256 value) internal {
224         require(to != address(0));
225 
226         _balances[from] = _balances[from].sub(value);
227         _balances[to] = _balances[to].add(value);
228         emit Transfer(from, to, value);
229     }
230 
231     /**
232      * @dev Internal function that mints an amount of the token and assigns it to
233      * an account. This encapsulates the modification of balances such that the
234      * proper events are emitted.
235      * @param account The account that will receive the created tokens.
236      * @param value The amount that will be created.
237      */
238     function _mint(address account, uint256 value) internal {
239         require(account != address(0));
240 
241         _totalSupply = _totalSupply.add(value);
242         _balances[account] = _balances[account].add(value);
243         emit Transfer(address(0), account, value);
244     }
245 
246     /**
247      * @dev Internal function that burns an amount of the token of a given
248      * account.
249      * @param account The account whose tokens will be burnt.
250      * @param value The amount that will be burnt.
251      */
252     function _burn(address account, uint256 value) internal {
253         require(account != address(0));
254 
255         _totalSupply = _totalSupply.sub(value);
256         _balances[account] = _balances[account].sub(value);
257         emit Transfer(account, address(0), value);
258     }
259 
260     /**
261      * @dev Internal function that burns an amount of the token of a given
262      * account, deducting from the sender's allowance for said account. Uses the
263      * internal burn function.
264      * Emits an Approval event (reflecting the reduced allowance).
265      * @param account The account whose tokens will be burnt.
266      * @param value The amount that will be burnt.
267      */
268     function _burnFrom(address account, uint256 value) internal {
269         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
270         _burn(account, value);
271         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
272     }
273 }
274 
275 
276 /**
277  * @title ERC20Detailed token
278  * @dev The decimals are only for visualization purposes.
279  * All the operations are done using the smallest and indivisible token unit,
280  * just as on Ethereum all the operations are done in wei.
281  */
282 contract ERC20Detailed is IERC20 {
283     string private _name;
284     string private _symbol;
285     uint8 private _decimals;
286 
287     constructor (string memory name, string memory symbol, uint8 decimals) public {
288         _name = name;
289         _symbol = symbol;
290         _decimals = decimals;
291     }
292 
293     /**
294      * @return the name of the token.
295      */
296     function name() public view returns (string memory) {
297         return _name;
298     }
299 
300     /**
301      * @return the symbol of the token.
302      */
303     function symbol() public view returns (string memory) {
304         return _symbol;
305     }
306 
307     /**
308      * @return the number of decimals of the token.
309      */
310     function decimals() public view returns (uint8) {
311         return _decimals;
312     }
313 }
314 
315 
316 
317 /**
318  * @title Roles
319  * @dev Library for managing addresses assigned to a Role.
320  */
321 library Roles {
322     struct Role {
323         mapping (address => bool) bearer;
324     }
325 
326     /**
327      * @dev give an account access to this role
328      */
329     function add(Role storage role, address account) internal {
330         require(account != address(0));
331         require(!has(role, account));
332 
333         role.bearer[account] = true;
334     }
335 
336     /**
337      * @dev remove an account's access to this role
338      */
339     function remove(Role storage role, address account) internal {
340         require(account != address(0));
341         require(has(role, account));
342 
343         role.bearer[account] = false;
344     }
345 
346     /**
347      * @dev check if an account has this role
348      * @return bool
349      */
350     function has(Role storage role, address account) internal view returns (bool) {
351         require(account != address(0));
352         return role.bearer[account];
353     }
354 }
355 
356 
357 contract MinterRole {
358     using Roles for Roles.Role;
359 
360     event MinterAdded(address indexed account);
361     event MinterRemoved(address indexed account);
362 
363     Roles.Role private _minters;
364 
365     constructor () internal {
366         _addMinter(msg.sender);
367     }
368 
369     modifier onlyMinter() {
370         require(isMinter(msg.sender));
371         _;
372     }
373 
374     function isMinter(address account) public view returns (bool) {
375         return _minters.has(account);
376     }
377 
378     function addMinter(address account) public onlyMinter {
379         _addMinter(account);
380     }
381 
382     function renounceMinter() public {
383         _removeMinter(msg.sender);
384     }
385 
386     function _addMinter(address account) internal {
387         _minters.add(account);
388         emit MinterAdded(account);
389     }
390 
391     function _removeMinter(address account) internal {
392         _minters.remove(account);
393         emit MinterRemoved(account);
394     }
395 }
396 
397 
398 /**
399  * @title ERC20Mintable
400  * @dev ERC20 minting logic
401  */
402 contract ERC20Mintable is ERC20, MinterRole {
403     /**
404      * @dev Function to mint tokens
405      * @param to The address that will receive the minted tokens.
406      * @param value The amount of tokens to mint.
407      * @return A boolean that indicates if the operation was successful.
408      */
409     function mint(address to, uint256 value) public onlyMinter returns (bool) {
410         _mint(to, value);
411         return true;
412     }
413 }
414 
415 
416 /**
417  * @title Burnable Token
418  * @dev Token that can be irreversibly burned (destroyed).
419  */
420 contract ERC20Burnable is ERC20 {
421     /**
422      * @dev Burns a specific amount of tokens.
423      * @param value The amount of token to be burned.
424      */
425     function burn(uint256 value) public {
426         _burn(msg.sender, value);
427     }
428 
429     /**
430      * @dev Burns a specific amount of tokens from the target address and decrements allowance
431      * @param from address The address which you want to send tokens from
432      * @param value uint256 The amount of token to be burned
433      */
434     function burnFrom(address from, uint256 value) public {
435         _burnFrom(from, value);
436     }
437 }
438 
439 
440 contract HuntToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
441   uint private INITIAL_SUPPLY = 500000000e18;
442 
443   constructor () public
444     ERC20Burnable()
445     ERC20Mintable()
446     ERC20Detailed("HuntToken", "HUNT", 18)
447   {
448     _mint(msg.sender, INITIAL_SUPPLY);
449   }
450 }