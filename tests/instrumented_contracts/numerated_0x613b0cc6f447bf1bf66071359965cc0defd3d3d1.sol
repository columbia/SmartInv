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
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32     * @dev Multiplies two unsigned integers, reverts on overflow.
33     */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Adds two unsigned integers, reverts on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82     * reverts when dividing by zero.
83     */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
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
276 
277 /**
278  * @title ERC20Detailed token
279  * @dev The decimals are only for visualization purposes.
280  * All the operations are done using the smallest and indivisible token unit,
281  * just as on Ethereum all the operations are done in wei.
282  */
283 contract ERC20Detailed is IERC20 {
284     string private _name;
285     string private _symbol;
286     uint8 private _decimals;
287 
288     constructor (string memory name, string memory symbol, uint8 decimals) public {
289         _name = name;
290         _symbol = symbol;
291         _decimals = decimals;
292     }
293 
294     /**
295      * @return the name of the token.
296      */
297     function name() public view returns (string memory) {
298         return _name;
299     }
300 
301     /**
302      * @return the symbol of the token.
303      */
304     function symbol() public view returns (string memory) {
305         return _symbol;
306     }
307 
308     /**
309      * @return the number of decimals of the token.
310      */
311     function decimals() public view returns (uint8) {
312         return _decimals;
313     }
314 }
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
357 
358 contract MinterRole {
359     using Roles for Roles.Role;
360 
361     event MinterAdded(address indexed account);
362     event MinterRemoved(address indexed account);
363 
364     Roles.Role private _minters;
365 
366     constructor () internal {
367         _addMinter(msg.sender);
368     }
369 
370     modifier onlyMinter() {
371         require(isMinter(msg.sender));
372         _;
373     }
374 
375     function isMinter(address account) public view returns (bool) {
376         return _minters.has(account);
377     }
378 
379     function addMinter(address account) public onlyMinter {
380         _addMinter(account);
381     }
382 
383     function renounceMinter() public {
384         _removeMinter(msg.sender);
385     }
386 
387     function _addMinter(address account) internal {
388         _minters.add(account);
389         emit MinterAdded(account);
390     }
391 
392     function _removeMinter(address account) internal {
393         _minters.remove(account);
394         emit MinterRemoved(account);
395     }
396 }
397 
398 
399 
400 /**
401  * @title ERC20Mintable
402  * @dev ERC20 minting logic
403  */
404 contract ERC20Mintable is ERC20, MinterRole {
405     /**
406      * @dev Function to mint tokens
407      * @param to The address that will receive the minted tokens.
408      * @param value The amount of tokens to mint.
409      * @return A boolean that indicates if the operation was successful.
410      */
411     function mint(address to, uint256 value) public onlyMinter returns (bool) {
412         _mint(to, value);
413         return true;
414     }
415 }
416 
417 
418 
419 /**
420  * @title Burnable Token
421  * @dev Token that can be irreversibly burned (destroyed).
422  */
423 contract ERC20Burnable is ERC20 {
424     /**
425      * @dev Burns a specific amount of tokens.
426      * @param value The amount of token to be burned.
427      */
428     function burn(uint256 value) public {
429         _burn(msg.sender, value);
430     }
431 
432     /**
433      * @dev Burns a specific amount of tokens from the target address and decrements allowance
434      * @param from address The address which you want to send tokens from
435      * @param value uint256 The amount of token to be burned
436      */
437     function burnFrom(address from, uint256 value) public {
438         _burnFrom(from, value);
439     }
440 }
441 
442 
443 
444 contract Token is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
445     string private _creator_name = 'SIMEX Inc.';
446 	string private _creator_website = 'simex.global';
447 
448     constructor (string memory token_name, string memory token_symbol, uint8 token_decimals, uint mint_size, address mint_address) public
449         ERC20Detailed(token_name, token_symbol, token_decimals) {
450         if (mint_size > 0) {
451             _mint(mint_address, mint_size * (10 ** uint256(token_decimals)));
452         }
453     }
454 
455     /**
456      * @return the creator's name.
457      */
458 	function creatorName() public view returns(string memory) {
459 		return _creator_name;
460 	}
461 
462 	/**
463      * @return the creator's website.
464      */
465 	function creatorWebsite() public view returns(string memory) {
466 		return _creator_website;
467 	}
468 }
