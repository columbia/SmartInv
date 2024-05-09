1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev give an account access to this role
14      */
15     function add(Role storage role, address account) internal {
16         require(account != address(0));
17         require(!has(role, account));
18 
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev remove an account's access to this role
24      */
25     function remove(Role storage role, address account) internal {
26         require(account != address(0));
27         require(has(role, account));
28 
29         role.bearer[account] = false;
30     }
31 
32     /**
33      * @dev check if an account has this role
34      * @return bool
35      */
36     function has(Role storage role, address account) internal view returns (bool) {
37         require(account != address(0));
38         return role.bearer[account];
39     }
40 }
41 
42 
43 
44 
45 contract MinterRole {
46     using Roles for Roles.Role;
47 
48     event MinterAdded(address indexed account);
49     event MinterRemoved(address indexed account);
50 
51     Roles.Role private _minters;
52 
53     constructor () internal {
54         _addMinter(msg.sender);
55     }
56 
57     modifier onlyMinter() {
58         require(isMinter(msg.sender));
59         _;
60     }
61 
62     function isMinter(address account) public view returns (bool) {
63         return _minters.has(account);
64     }
65 
66     function addMinter(address account) public onlyMinter {
67         _addMinter(account);
68     }
69 
70     function renounceMinter() public {
71         _removeMinter(msg.sender);
72     }
73 
74     function _addMinter(address account) internal {
75         _minters.add(account);
76         emit MinterAdded(account);
77     }
78 
79     function _removeMinter(address account) internal {
80         _minters.remove(account);
81         emit MinterRemoved(account);
82     }
83 }
84 
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 interface IERC20 {
91     function transfer(address to, uint256 value) external returns (bool);
92 
93     function approve(address spender, uint256 value) external returns (bool);
94 
95     function transferFrom(address from, address to, uint256 value) external returns (bool);
96 
97     function totalSupply() external view returns (uint256);
98 
99     function balanceOf(address who) external view returns (uint256);
100 
101     function allowance(address owner, address spender) external view returns (uint256);
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 
110 
111 
112 
113 /**
114  * @title SafeMath
115  * @dev Unsigned math operations with safety checks that revert on error
116  */
117 library SafeMath {
118     /**
119     * @dev Multiplies two unsigned integers, reverts on overflow.
120     */
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
123         // benefit is lost if 'b' is also tested.
124         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
125         if (a == 0) {
126             return 0;
127         }
128 
129         uint256 c = a * b;
130         require(c / a == b);
131 
132         return c;
133     }
134 
135     /**
136     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
137     */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         // Solidity only automatically asserts when dividing by 0
140         require(b > 0);
141         uint256 c = a / b;
142         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143 
144         return c;
145     }
146 
147     /**
148     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
149     */
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         require(b <= a);
152         uint256 c = a - b;
153 
154         return c;
155     }
156 
157     /**
158     * @dev Adds two unsigned integers, reverts on overflow.
159     */
160     function add(uint256 a, uint256 b) internal pure returns (uint256) {
161         uint256 c = a + b;
162         require(c >= a);
163 
164         return c;
165     }
166 
167     /**
168     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
169     * reverts when dividing by zero.
170     */
171     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
172         require(b != 0);
173         return a % b;
174     }
175 }
176 
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
183  * Originally based on code by FirstBlood:
184  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
185  *
186  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
187  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
188  * compliant implementations may not do it.
189  */
190 contract ERC20 is IERC20 {
191     using SafeMath for uint256;
192 
193     mapping (address => uint256) private _balances;
194 
195     mapping (address => mapping (address => uint256)) private _allowed;
196 
197     uint256 private _totalSupply;
198 
199     /**
200     * @dev Total number of tokens in existence
201     */
202     function totalSupply() public view returns (uint256) {
203         return _totalSupply;
204     }
205 
206     /**
207     * @dev Gets the balance of the specified address.
208     * @param owner The address to query the balance of.
209     * @return An uint256 representing the amount owned by the passed address.
210     */
211     function balanceOf(address owner) public view returns (uint256) {
212         return _balances[owner];
213     }
214 
215     /**
216      * @dev Function to check the amount of tokens that an owner allowed to a spender.
217      * @param owner address The address which owns the funds.
218      * @param spender address The address which will spend the funds.
219      * @return A uint256 specifying the amount of tokens still available for the spender.
220      */
221     function allowance(address owner, address spender) public view returns (uint256) {
222         return _allowed[owner][spender];
223     }
224 
225     /**
226     * @dev Transfer token for a specified address
227     * @param to The address to transfer to.
228     * @param value The amount to be transferred.
229     */
230     function transfer(address to, uint256 value) public returns (bool) {
231         _transfer(msg.sender, to, value);
232         return true;
233     }
234 
235     /**
236      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237      * Beware that changing an allowance with this method brings the risk that someone may use both the old
238      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      * @param spender The address which will spend the funds.
242      * @param value The amount of tokens to be spent.
243      */
244     function approve(address spender, uint256 value) public returns (bool) {
245         require(spender != address(0));
246 
247         _allowed[msg.sender][spender] = value;
248         emit Approval(msg.sender, spender, value);
249         return true;
250     }
251 
252     /**
253      * @dev Transfer tokens from one address to another.
254      * Note that while this function emits an Approval event, this is not required as per the specification,
255      * and other compliant implementations may not emit the event.
256      * @param from address The address which you want to send tokens from
257      * @param to address The address which you want to transfer to
258      * @param value uint256 the amount of tokens to be transferred
259      */
260     function transferFrom(address from, address to, uint256 value) public returns (bool) {
261         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
262         _transfer(from, to, value);
263         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
264         return true;
265     }
266 
267     /**
268      * @dev Increase the amount of tokens that an owner allowed to a spender.
269      * approve should be called when allowed_[_spender] == 0. To increment
270      * allowed value is better to use this function to avoid 2 calls (and wait until
271      * the first transaction is mined)
272      * From MonolithDAO Token.sol
273      * Emits an Approval event.
274      * @param spender The address which will spend the funds.
275      * @param addedValue The amount of tokens to increase the allowance by.
276      */
277     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
278         require(spender != address(0));
279 
280         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
281         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
282         return true;
283     }
284 
285     /**
286      * @dev Decrease the amount of tokens that an owner allowed to a spender.
287      * approve should be called when allowed_[_spender] == 0. To decrement
288      * allowed value is better to use this function to avoid 2 calls (and wait until
289      * the first transaction is mined)
290      * From MonolithDAO Token.sol
291      * Emits an Approval event.
292      * @param spender The address which will spend the funds.
293      * @param subtractedValue The amount of tokens to decrease the allowance by.
294      */
295     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
296         require(spender != address(0));
297 
298         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
299         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
300         return true;
301     }
302 
303     /**
304     * @dev Transfer token for a specified addresses
305     * @param from The address to transfer from.
306     * @param to The address to transfer to.
307     * @param value The amount to be transferred.
308     */
309     function _transfer(address from, address to, uint256 value) internal {
310         require(to != address(0));
311 
312         _balances[from] = _balances[from].sub(value);
313         _balances[to] = _balances[to].add(value);
314         emit Transfer(from, to, value);
315     }
316 
317     /**
318      * @dev Internal function that mints an amount of the token and assigns it to
319      * an account. This encapsulates the modification of balances such that the
320      * proper events are emitted.
321      * @param account The account that will receive the created tokens.
322      * @param value The amount that will be created.
323      */
324     function _mint(address account, uint256 value) internal {
325         require(account != address(0));
326 
327         _totalSupply = _totalSupply.add(value);
328         _balances[account] = _balances[account].add(value);
329         emit Transfer(address(0), account, value);
330     }
331 
332     /**
333      * @dev Internal function that burns an amount of the token of a given
334      * account.
335      * @param account The account whose tokens will be burnt.
336      * @param value The amount that will be burnt.
337      */
338     function _burn(address account, uint256 value) internal {
339         require(account != address(0));
340 
341         _totalSupply = _totalSupply.sub(value);
342         _balances[account] = _balances[account].sub(value);
343         emit Transfer(account, address(0), value);
344     }
345 
346     /**
347      * @dev Internal function that burns an amount of the token of a given
348      * account, deducting from the sender's allowance for said account. Uses the
349      * internal burn function.
350      * Emits an Approval event (reflecting the reduced allowance).
351      * @param account The account whose tokens will be burnt.
352      * @param value The amount that will be burnt.
353      */
354     function _burnFrom(address account, uint256 value) internal {
355         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
356         _burn(account, value);
357         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
358     }
359 }
360 
361 
362 
363 
364 
365 /**
366  * @title ERC20Detailed token
367  * @dev The decimals are only for visualization purposes.
368  * All the operations are done using the smallest and indivisible token unit,
369  * just as on Ethereum all the operations are done in wei.
370  */
371 contract ERC20Detailed is IERC20 {
372     string private _name;
373     string private _symbol;
374     uint8 private _decimals;
375 
376     constructor (string memory name, string memory symbol, uint8 decimals) public {
377         _name = name;
378         _symbol = symbol;
379         _decimals = decimals;
380     }
381 
382     /**
383      * @return the name of the token.
384      */
385     function name() public view returns (string memory) {
386         return _name;
387     }
388 
389     /**
390      * @return the symbol of the token.
391      */
392     function symbol() public view returns (string memory) {
393         return _symbol;
394     }
395 
396     /**
397      * @return the number of decimals of the token.
398      */
399     function decimals() public view returns (uint8) {
400         return _decimals;
401     }
402 }
403 
404 
405 
406 
407 
408 
409 /**
410  * @title ERC20Mintable
411  * @dev ERC20 minting logic
412  */
413 contract ERC20Mintable is ERC20, MinterRole {
414     /**
415      * @dev Function to mint tokens
416      * @param to The address that will receive the minted tokens.
417      * @param value The amount of tokens to mint.
418      * @return A boolean that indicates if the operation was successful.
419      */
420     function mint(address to, uint256 value) public onlyMinter returns (bool) {
421         _mint(to, value);
422         return true;
423     }
424 }
425 
426 
427 
428 
429 
430 /**
431  * @title Burnable Token
432  * @dev Token that can be irreversibly burned (destroyed).
433  */
434 contract ERC20Burnable is ERC20 {
435     /**
436      * @dev Burns a specific amount of tokens.
437      * @param value The amount of token to be burned.
438      */
439     function burn(uint256 value) public {
440         _burn(msg.sender, value);
441     }
442 
443     /**
444      * @dev Burns a specific amount of tokens from the target address and decrements allowance
445      * @param from address The address which you want to send tokens from
446      * @param value uint256 The amount of token to be burned
447      */
448     function burnFrom(address from, uint256 value) public {
449         _burnFrom(from, value);
450     }
451 }
452 
453 
454 
455 /**
456 * @title New LGO contract
457 * @dev ERC20 with bulk minting function restricted to minter role, bulk transferring and burn function
458 */
459 contract NewLGO is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
460 
461   /**
462   * [LGO Token CONSTRUCTOR]
463   * @dev Deploy contract with name, symbol and decimal
464   */
465   constructor()
466   ERC20Detailed("LGO Token", "LGO", 8)
467   public { }
468 
469   /**
470   * @dev Public function that mints amounts of token and assigns it to
471   * respective accounts
472   * @param accounts The accounts that will receive the created tokens.
473   * @param values The amounts that will be created (in the same order).
474   */
475   function bulkMint(address[] memory accounts, uint256[] memory values)
476     public
477   {
478     require(accounts.length == values.length, "Accounts array and values array don't have the same length");
479 
480     for (uint i = 0; i<accounts.length; i++) {
481       mint(accounts[i], values[i]);
482     }
483 
484   }
485 
486   /**
487   * @dev Public function that transfers amounts of token to
488   * respective accounts
489   * @param accounts The accounts that will receive the tokens.
490   * @param values The amounts that will be sent (in the same order).
491   */
492   function bulkTransfer(address[] memory accounts, uint256[] memory values)
493     public
494   {
495     require(accounts.length == values.length, "Accounts array and values array don't have the same length");
496 
497     for (uint i = 0; i<accounts.length; i++) {
498       transfer(accounts[i], values[i]);
499     }
500 
501   }
502 
503 }