1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
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
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123     * @dev Total number of tokens in existence
124     */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param owner The address to query the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149     * @dev Transfer token for a specified address
150     * @param to The address to transfer to.
151     * @param value The amount to be transferred.
152     */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         require(spender != address(0));
169 
170         _allowed[msg.sender][spender] = value;
171         emit Approval(msg.sender, spender, value);
172         return true;
173     }
174 
175     /**
176      * @dev Transfer tokens from one address to another.
177      * Note that while this function emits an Approval event, this is not required as per the specification,
178      * and other compliant implementations may not emit the event.
179      * @param from address The address which you want to send tokens from
180      * @param to address The address which you want to transfer to
181      * @param value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address from, address to, uint256 value) public returns (bool) {
184         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
185         _transfer(from, to, value);
186         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed_[_spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         require(spender != address(0));
202 
203         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
204         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when allowed_[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         require(spender != address(0));
220 
221         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
222         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Transfer token for a specified addresses
228     * @param from The address to transfer from.
229     * @param to The address to transfer to.
230     * @param value The amount to be transferred.
231     */
232     function _transfer(address from, address to, uint256 value) internal {
233         require(to != address(0));
234 
235         _balances[from] = _balances[from].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(from, to, value);
238     }
239 
240     /**
241      * @dev Internal function that mints an amount of the token and assigns it to
242      * an account. This encapsulates the modification of balances such that the
243      * proper events are emitted.
244      * @param account The account that will receive the created tokens.
245      * @param value The amount that will be created.
246      */
247     function _mint(address account, uint256 value) internal {
248         require(account != address(0));
249 
250         _totalSupply = _totalSupply.add(value);
251         _balances[account] = _balances[account].add(value);
252         emit Transfer(address(0), account, value);
253     }
254 
255     /**
256      * @dev Internal function that burns an amount of the token of a given
257      * account.
258      * @param account The account whose tokens will be burnt.
259      * @param value The amount that will be burnt.
260      */
261     function _burn(address account, uint256 value) internal {
262         require(account != address(0));
263 
264         _totalSupply = _totalSupply.sub(value);
265         _balances[account] = _balances[account].sub(value);
266         emit Transfer(account, address(0), value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account, deducting from the sender's allowance for said account. Uses the
272      * internal burn function.
273      * Emits an Approval event (reflecting the reduced allowance).
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burnFrom(address account, uint256 value) internal {
278         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
279         _burn(account, value);
280         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
281     }
282 }
283 
284 // File: openzeppelin-solidity/contracts/access/Roles.sol
285 
286 pragma solidity ^0.5.0;
287 
288 /**
289  * @title Roles
290  * @dev Library for managing addresses assigned to a Role.
291  */
292 library Roles {
293     struct Role {
294         mapping (address => bool) bearer;
295     }
296 
297     /**
298      * @dev give an account access to this role
299      */
300     function add(Role storage role, address account) internal {
301         require(account != address(0));
302         require(!has(role, account));
303 
304         role.bearer[account] = true;
305     }
306 
307     /**
308      * @dev remove an account's access to this role
309      */
310     function remove(Role storage role, address account) internal {
311         require(account != address(0));
312         require(has(role, account));
313 
314         role.bearer[account] = false;
315     }
316 
317     /**
318      * @dev check if an account has this role
319      * @return bool
320      */
321     function has(Role storage role, address account) internal view returns (bool) {
322         require(account != address(0));
323         return role.bearer[account];
324     }
325 }
326 
327 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
328 
329 pragma solidity ^0.5.0;
330 
331 
332 contract MinterRole {
333     using Roles for Roles.Role;
334 
335     event MinterAdded(address indexed account);
336     event MinterRemoved(address indexed account);
337 
338     Roles.Role private _minters;
339 
340     constructor () internal {
341         _addMinter(msg.sender);
342     }
343 
344     modifier onlyMinter() {
345         require(isMinter(msg.sender));
346         _;
347     }
348 
349     function isMinter(address account) public view returns (bool) {
350         return _minters.has(account);
351     }
352 
353     function addMinter(address account) public onlyMinter {
354         _addMinter(account);
355     }
356 
357     function renounceMinter() public {
358         _removeMinter(msg.sender);
359     }
360 
361     function _addMinter(address account) internal {
362         _minters.add(account);
363         emit MinterAdded(account);
364     }
365 
366     function _removeMinter(address account) internal {
367         _minters.remove(account);
368         emit MinterRemoved(account);
369     }
370 }
371 
372 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
373 
374 pragma solidity ^0.5.0;
375 
376 
377 
378 /**
379  * @title ERC20Mintable
380  * @dev ERC20 minting logic
381  */
382 contract ERC20Mintable is ERC20, MinterRole {
383     /**
384      * @dev Function to mint tokens
385      * @param to The address that will receive the minted tokens.
386      * @param value The amount of tokens to mint.
387      * @return A boolean that indicates if the operation was successful.
388      */
389     function mint(address to, uint256 value) public onlyMinter returns (bool) {
390         _mint(to, value);
391         return true;
392     }
393 }
394 
395 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
396 
397 pragma solidity ^0.5.0;
398 
399 
400 /**
401  * @title Capped token
402  * @dev Mintable token with a token cap.
403  */
404 contract ERC20Capped is ERC20Mintable {
405     uint256 private _cap;
406 
407     constructor (uint256 cap) public {
408         require(cap > 0);
409         _cap = cap;
410     }
411 
412     /**
413      * @return the cap for the token minting.
414      */
415     function cap() public view returns (uint256) {
416         return _cap;
417     }
418 
419     function _mint(address account, uint256 value) internal {
420         require(totalSupply().add(value) <= _cap);
421         super._mint(account, value);
422     }
423 }
424 
425 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
426 
427 pragma solidity ^0.5.0;
428 
429 
430 /**
431  * @title ERC20Detailed token
432  * @dev The decimals are only for visualization purposes.
433  * All the operations are done using the smallest and indivisible token unit,
434  * just as on Ethereum all the operations are done in wei.
435  */
436 contract ERC20Detailed is IERC20 {
437     string private _name;
438     string private _symbol;
439     uint8 private _decimals;
440 
441     constructor (string memory name, string memory symbol, uint8 decimals) public {
442         _name = name;
443         _symbol = symbol;
444         _decimals = decimals;
445     }
446 
447     /**
448      * @return the name of the token.
449      */
450     function name() public view returns (string memory) {
451         return _name;
452     }
453 
454     /**
455      * @return the symbol of the token.
456      */
457     function symbol() public view returns (string memory) {
458         return _symbol;
459     }
460 
461     /**
462      * @return the number of decimals of the token.
463      */
464     function decimals() public view returns (uint8) {
465         return _decimals;
466     }
467 }
468 
469 // File: contracts/Aavio.sol
470 
471 pragma solidity >=0.5.0;
472 
473 
474 
475 
476 
477 
478 
479 contract Aavio is IERC20, ERC20, ERC20Detailed, ERC20Capped {
480     using SafeMath for uint256;
481 
482     constructor()
483     ERC20Detailed("Aavio", "AAV", 18)
484     ERC20Capped(500000000000000000000000000)
485     public  {
486         uint256 initialSupply = 300000000000000000000000000;  // 300 million tokens + 18 decimals
487         _mint(msg.sender, initialSupply);
488     }
489     
490     /**
491     * @dev Transfer token for a specified address
492     * @param to The address to transfer to.
493     * @param value The amount to be transferred.
494     */
495     function transfer(address to, uint256 value) public returns (bool) {
496         require(to != address(this), "CANT SEND TO TOKEN CONTRACT");
497         _transfer(msg.sender, to, value);
498         return true;
499     }
500 
501     /**
502      * @dev Transfer tokens from one address to another.
503      * Note that while this function emits an Approval event, this is not required as per the specification,
504      * and other compliant implementations may not emit the event.
505      * @param from address The address which you want to send tokens from
506      * @param to address The address which you want to transfer to
507      * @param value uint256 the amount of tokens to be transferred
508      */
509     function transferFrom(address from, address to, uint256 value) public returns (bool) {
510         require(to != address(this), "CANT SEND TO TOKEN CONTRACT");
511         super.transferFrom(from, to, value);
512         return true;
513     }
514 
515 }