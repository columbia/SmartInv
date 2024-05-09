1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  * 
7  */
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address who) external view returns (uint256);
12 
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function transfer(address to, uint256 value) external returns (bool);
16 
17     function approve(address spender, uint256 value) external returns (bool);
18 
19     function transferFrom(address from, address to, uint256 value) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     int256 constant private INT256_MIN = -2**255;
32 
33     /**
34     * @dev Multiplies two unsigned integers, reverts on overflow.
35     */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b);
46 
47         return c;
48     }
49 
50     /**
51     * @dev Multiplies two signed integers, reverts on overflow.
52     */
53     function mul(int256 a, int256 b) internal pure returns (int256) {
54         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55         // benefit is lost if 'b' is also tested.
56         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
57         if (a == 0) {
58             return 0;
59         }
60 
61         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
62 
63         int256 c = a * b;
64         require(c / a == b);
65 
66         return c;
67     }
68 
69     /**
70     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
71     */
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         // Solidity only automatically asserts when dividing by 0
74         require(b > 0);
75         uint256 c = a / b;
76         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77 
78         return c;
79     }
80 
81     /**
82     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
83     */
84     function div(int256 a, int256 b) internal pure returns (int256) {
85         require(b != 0); // Solidity only automatically asserts when dividing by 0
86         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
87 
88         int256 c = a / b;
89 
90         return c;
91     }
92 
93     /**
94     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
95     */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b <= a);
98         uint256 c = a - b;
99 
100         return c;
101     }
102 
103     /**
104     * @dev Subtracts two signed integers, reverts on overflow.
105     */
106     function sub(int256 a, int256 b) internal pure returns (int256) {
107         int256 c = a - b;
108         require((b >= 0 && c <= a) || (b < 0 && c > a));
109 
110         return c;
111     }
112 
113     /**
114     * @dev Adds two unsigned integers, reverts on overflow.
115     */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a);
119 
120         return c;
121     }
122 
123     /**
124     * @dev Adds two signed integers, reverts on overflow.
125     */
126     function add(int256 a, int256 b) internal pure returns (int256) {
127         int256 c = a + b;
128         require((b >= 0 && c >= a) || (b < 0 && c < a));
129 
130         return c;
131     }
132 
133     /**
134     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
135     * reverts when dividing by zero.
136     */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b != 0);
139         return a % b;
140     }
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
148  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  *
150  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
151  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
152  * compliant implementations may not do it.
153  */
154 contract ERC20 is IERC20 {
155     using SafeMath for uint256;
156 
157     mapping (address => uint256) private _balances;
158 
159     mapping (address => mapping (address => uint256)) private _allowed;
160 
161     uint256 private _totalSupply;
162 
163     /**
164     * @dev Total number of tokens in existence
165     */
166     function totalSupply() public view returns (uint256) {
167         return _totalSupply;
168     }
169 
170     /**
171     * @dev Gets the balance of the specified address.
172     * @param owner The address to query the balance of.
173     * @return An uint256 representing the amount owned by the passed address.
174     */
175     function balanceOf(address owner) public view returns (uint256) {
176         return _balances[owner];
177     }
178 
179     /**
180      * @dev Function to check the amount of tokens that an owner allowed to a spender.
181      * @param owner address The address which owns the funds.
182      * @param spender address The address which will spend the funds.
183      * @return A uint256 specifying the amount of tokens still available for the spender.
184      */
185     function allowance(address owner, address spender) public view returns (uint256) {
186         return _allowed[owner][spender];
187     }
188 
189     /**
190     * @dev Transfer token for a specified address
191     * @param to The address to transfer to.
192     * @param value The amount to be transferred.
193     */
194     function transfer(address to, uint256 value) public returns (bool) {
195         _transfer(msg.sender, to, value);
196         return true;
197     }
198 
199     /**
200      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201      * Beware that changing an allowance with this method brings the risk that someone may use both the old
202      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205      * @param spender The address which will spend the funds.
206      * @param value The amount of tokens to be spent.
207      */
208     function approve(address spender, uint256 value) public returns (bool) {
209         require(spender != address(0));
210 
211         _allowed[msg.sender][spender] = value;
212         emit Approval(msg.sender, spender, value);
213         return true;
214     }
215 
216     /**
217      * @dev Transfer tokens from one address to another.
218      * Note that while this function emits an Approval event, this is not required as per the specification,
219      * and other compliant implementations may not emit the event.
220      * @param from address The address which you want to send tokens from
221      * @param to address The address which you want to transfer to
222      * @param value uint256 the amount of tokens to be transferred
223      */
224     function transferFrom(address from, address to, uint256 value) public returns (bool) {
225         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
226         _transfer(from, to, value);
227         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
228         return true;
229     }
230 
231     /**
232      * @dev Increase the amount of tokens that an owner allowed to a spender.
233      * approve should be called when allowed_[_spender] == 0. To increment
234      * allowed value is better to use this function to avoid 2 calls (and wait until
235      * the first transaction is mined)
236      * From MonolithDAO Token.sol
237      * Emits an Approval event.
238      * @param spender The address which will spend the funds.
239      * @param addedValue The amount of tokens to increase the allowance by.
240      */
241     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
242         require(spender != address(0));
243 
244         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
245         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
246         return true;
247     }
248 
249     /**
250      * @dev Decrease the amount of tokens that an owner allowed to a spender.
251      * approve should be called when allowed_[_spender] == 0. To decrement
252      * allowed value is better to use this function to avoid 2 calls (and wait until
253      * the first transaction is mined)
254      * From MonolithDAO Token.sol
255      * Emits an Approval event.
256      * @param spender The address which will spend the funds.
257      * @param subtractedValue The amount of tokens to decrease the allowance by.
258      */
259     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
260         require(spender != address(0));
261 
262         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
263         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
264         return true;
265     }
266 
267     /**
268     * @dev Transfer token for a specified addresses
269     * @param from The address to transfer from.
270     * @param to The address to transfer to.
271     * @param value The amount to be transferred.
272     */
273     function _transfer(address from, address to, uint256 value) internal {
274         require(to != address(0));
275 
276         _balances[from] = _balances[from].sub(value);
277         _balances[to] = _balances[to].add(value);
278         emit Transfer(from, to, value);
279     }
280 
281     /**
282      * @dev Internal function that mints an amount of the token and assigns it to
283      * an account. This encapsulates the modification of balances such that the
284      * proper events are emitted.
285      * @param account The account that will receive the created tokens.
286      * @param value The amount that will be created.
287      */
288     function _mint(address account, uint256 value) internal {
289         require(account != address(0));
290 
291         _totalSupply = _totalSupply.add(value);
292         _balances[account] = _balances[account].add(value);
293         emit Transfer(address(0), account, value);
294     }
295 
296     /**
297      * @dev Internal function that burns an amount of the token of a given
298      * account.
299      * @param account The account whose tokens will be burnt.
300      * @param value The amount that will be burnt.
301      */
302     function _burn(address account, uint256 value) internal {
303         require(account != address(0));
304 
305         _totalSupply = _totalSupply.sub(value);
306         _balances[account] = _balances[account].sub(value);
307         emit Transfer(account, address(0), value);
308     }
309 
310     /**
311      * @dev Internal function that burns an amount of the token of a given
312      * account, deducting from the sender's allowance for said account. Uses the
313      * internal burn function.
314      * Emits an Approval event (reflecting the reduced allowance).
315      * @param account The account whose tokens will be burnt.
316      * @param value The amount that will be burnt.
317      */
318     function _burnFrom(address account, uint256 value) internal {
319         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
320         _burn(account, value);
321         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
322     }
323 }
324 
325 /**
326  * @title Roles
327  * @dev Library for managing addresses assigned to a Role.
328  */
329 library Roles {
330     struct Role {
331         mapping (address => bool) bearer;
332     }
333 
334     /**
335      * @dev give an account access to this role
336      */
337     function add(Role storage role, address account) internal {
338         require(account != address(0));
339         require(!has(role, account));
340 
341         role.bearer[account] = true;
342     }
343 
344     /**
345      * @dev remove an account's access to this role
346      */
347     function remove(Role storage role, address account) internal {
348         require(account != address(0));
349         require(has(role, account));
350 
351         role.bearer[account] = false;
352     }
353 
354     /**
355      * @dev check if an account has this role
356      * @return bool
357      */
358     function has(Role storage role, address account) internal view returns (bool) {
359         require(account != address(0));
360         return role.bearer[account];
361     }
362 }
363 
364 contract MinterRole {
365     using Roles for Roles.Role;
366 
367     event MinterAdded(address indexed account);
368     event MinterRemoved(address indexed account);
369 
370     Roles.Role private _minters;
371 
372     constructor () internal {
373         _addMinter(msg.sender);
374     }
375 
376     modifier onlyMinter() {
377         require(isMinter(msg.sender));
378         _;
379     }
380 
381     function isMinter(address account) public view returns (bool) {
382         return _minters.has(account);
383     }
384 
385     function addMinter(address account) public onlyMinter {
386         _addMinter(account);
387     }
388 
389     function renounceMinter() public {
390         _removeMinter(msg.sender);
391     }
392 
393     function _addMinter(address account) internal {
394         _minters.add(account);
395         emit MinterAdded(account);
396     }
397 
398     function _removeMinter(address account) internal {
399         _minters.remove(account);
400         emit MinterRemoved(account);
401     }
402 }
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
421 /**
422  * @title Capped token
423  * @dev Mintable token with a token cap.
424  */
425 contract ERC20Capped is ERC20Mintable {
426     uint256 private _cap;
427 
428     constructor (uint256 cap) public {
429         require(cap > 0);
430         _cap = cap;
431     }
432 
433     /**
434      * @return the cap for the token minting.
435      */
436     function cap() public view returns (uint256) {
437         return _cap;
438     }
439 
440     function _mint(address account, uint256 value) internal {
441         require(totalSupply().add(value) <= _cap);
442         super._mint(account, value);
443     }
444 }
445 
446 /**
447  * @title Burnable Token
448  * @dev Token that can be irreversibly burned (destroyed).
449  */
450 contract ERC20Burnable is ERC20 {
451     /**
452      * @dev Burns a specific amount of tokens.
453      * @param value The amount of token to be burned.
454      */
455     function burn(uint256 value) public {
456         _burn(msg.sender, value);
457     }
458 
459     /**
460      * @dev Burns a specific amount of tokens from the target address and decrements allowance
461      * @param from address The account whose tokens will be burned.
462      * @param value uint256 The amount of token to be burned.
463      */
464     function burnFrom(address from, uint256 value) public {
465         _burnFrom(from, value);
466     }
467 }
468 
469 /**
470  * @title ERC20Detailed token
471  * @dev The decimals are only for visualization purposes.
472  * All the operations are done using the smallest and indivisible token unit,
473  * just as on Ethereum all the operations are done in wei.
474  */
475 contract ERC20Detailed is IERC20 {
476     string private _name;
477     string private _symbol;
478     uint8 private _decimals;
479 
480     constructor (string name, string symbol, uint8 decimals) public {
481         _name = name;
482         _symbol = symbol;
483         _decimals = decimals;
484     }
485 
486     /**
487      * @return the name of the token.
488      */
489     function name() public view returns (string) {
490         return _name;
491     }
492 
493     /**
494      * @return the symbol of the token.
495      */
496     function symbol() public view returns (string) {
497         return _symbol;
498     }
499 
500     /**
501      * @return the number of decimals of the token.
502      */
503     function decimals() public view returns (uint8) {
504         return _decimals;
505     }
506 }
507 
508 /**
509  * @title Indigen XT - IDGX
510  * @dev Indigen XT ERC20 Token by Larrimar Tia. https://indigen.foundation
511  * Created on 1/27/2019.
512  * Maximum Supply Mintable: 100,000,000 IDGX
513  */
514 contract IndigenXT is ERC20, ERC20Detailed, ERC20Capped, ERC20Burnable { 
515     /**
516      * @dev Constructor that gives msg.sender all of existing tokens.
517      */
518     constructor (string name, string symbol, uint8 decimals, uint256 cap, uint256 initialBalance)
519         ERC20Detailed(name, symbol, decimals)
520         ERC20Capped(cap)
521         public
522         {
523             if (initialBalance > 0) {
524                 _mint(msg.sender, initialBalance);
525         }
526     }
527 }