1 /**
2  * Source Code first verified at https://etherscan.io on Friday, March 8, 2019
3  (UTC) */
4 
5 /**                                                                         
6 * ________                                                ____                                                           
7 * `MMMMMMMb.                                             6MMMMb\                                                         
8 *  MM    `Mb                                            6M'    `                                                         
9 *  MM     MM   ____  __ ____  __ ____     ____  ___  __ MM         ____     ____         ____     _____  ___  __    __   
10 *  MM     MM  6MMMMb `M6MMMMb `M6MMMMb   6MMMMb `MM 6MM YM.       6MMMMb   6MMMMb.      6MMMMb.  6MMMMMb `MM 6MMb  6MMb  
11 *  MM    .M9 6M'  `Mb MM'  `Mb MM'  `Mb 6M'  `Mb MM69 "  YMMMMb  6M'  `Mb 6M'   Mb     6M'   Mb 6M'   `Mb MM69 `MM69 `Mb 
12 *  MMMMMMM9' MM    MM MM    MM MM    MM MM    MM MM'         `Mb MM    MM MM    `'     MM    `' MM     MM MM'   MM'   MM 
13 *  MM        MMMMMMMM MM    MM MM    MM MMMMMMMM MM           MM MMMMMMMM MM           MM       MM     MM MM    MM    MM 
14 *  MM        MM       MM    MM MM    MM MM       MM           MM MM       MM           MM       MM     MM MM    MM    MM 
15 *  MM        YM    d9 MM.  ,M9 MM.  ,M9 YM    d9 MM     L    ,M9 YM    d9 YM.   d9 68b YM.   d9 YM.   ,M9 MM    MM    MM 
16 * _MM_        YMMMM9  MMYMMM9  MMYMMM9   YMMMM9 _MM_    MYMMMM9   YMMMM9   YMMMM9  Y89  YMMMM9   YMMMMM9 _MM_  _MM_  _MM_
17 *                     MM       MM                                                                                        
18 *                     MM       MM                                                                                        
19 *                    _MM_     _MM_                                                                                       
20 */
21 
22 
23 // Get a free estimate for your Solidity audit @ hello@peppersec.com 
24 // https://peppersec.com
25 
26 /**
27 *   _______    _                ______                   _   
28 *  |__   __|  | |              |  ____|                 | |  
29 *     | | ___ | | _____ _ __   | |__ __ _ _   _  ___ ___| |_ 
30 *     | |/ _ \| |/ / _ \ '_ \  |  __/ _` | | | |/ __/ _ \ __|
31 *     | | (_) |   <  __/ | | | | | | (_| | |_| | (_|  __/ |_ 
32 *     |_|\___/|_|\_\___|_| |_| |_|  \__,_|\__,_|\___\___|\__|
33 */
34 pragma solidity ^0.5.5;
35 
36 /**
37  * @title ERC20 interface
38  * @dev see https://eips.ethereum.org/EIPS/eip-20
39  */
40 interface IERC20 {
41     function transfer(address to, uint256 value) external returns (bool);
42 
43     function approve(address spender, uint256 value) external returns (bool);
44 
45     function transferFrom(address from, address to, uint256 value) external returns (bool);
46 
47     function totalSupply() external view returns (uint256);
48 
49     function balanceOf(address who) external view returns (uint256);
50 
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
59 
60 pragma solidity ^0.5.2;
61 
62 /**
63  * @title SafeMath
64  * @dev Unsigned math operations with safety checks that revert on error
65  */
66 library SafeMath {
67     /**
68      * @dev Multiplies two unsigned integers, reverts on overflow.
69      */
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
72         // benefit is lost if 'b' is also tested.
73         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b);
80 
81         return c;
82     }
83 
84     /**
85      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0);
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     /**
97      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
98      */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b <= a);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Adds two unsigned integers, reverts on overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a);
112 
113         return c;
114     }
115 
116     /**
117      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
118      * reverts when dividing by zero.
119      */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b != 0);
122         return a % b;
123     }
124 }
125 
126 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
127 
128 pragma solidity ^0.5.2;
129 
130 
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * https://eips.ethereum.org/EIPS/eip-20
137  * Originally based on code by FirstBlood:
138  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  *
140  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
141  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
142  * compliant implementations may not do it.
143  */
144 contract ERC20 is IERC20 {
145     using SafeMath for uint256;
146 
147     mapping (address => uint256) private _balances;
148 
149     mapping (address => mapping (address => uint256)) private _allowed;
150 
151     uint256 private _totalSupply;
152 
153     /**
154      * @dev Total number of tokens in existence
155      */
156     function totalSupply() public view returns (uint256) {
157         return _totalSupply;
158     }
159 
160     /**
161      * @dev Gets the balance of the specified address.
162      * @param owner The address to query the balance of.
163      * @return A uint256 representing the amount owned by the passed address.
164      */
165     function balanceOf(address owner) public view returns (uint256) {
166         return _balances[owner];
167     }
168 
169     /**
170      * @dev Function to check the amount of tokens that an owner allowed to a spender.
171      * @param owner address The address which owns the funds.
172      * @param spender address The address which will spend the funds.
173      * @return A uint256 specifying the amount of tokens still available for the spender.
174      */
175     function allowance(address owner, address spender) public view returns (uint256) {
176         return _allowed[owner][spender];
177     }
178 
179     /**
180      * @dev Transfer token to a specified address
181      * @param to The address to transfer to.
182      * @param value The amount to be transferred.
183      */
184     function transfer(address to, uint256 value) public returns (bool) {
185         _transfer(msg.sender, to, value);
186         return true;
187     }
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param spender The address which will spend the funds.
196      * @param value The amount of tokens to be spent.
197      */
198     function approve(address spender, uint256 value) public returns (bool) {
199         _approve(msg.sender, spender, value);
200         return true;
201     }
202 
203     /**
204      * @dev Transfer tokens from one address to another.
205      * Note that while this function emits an Approval event, this is not required as per the specification,
206      * and other compliant implementations may not emit the event.
207      * @param from address The address which you want to send tokens from
208      * @param to address The address which you want to transfer to
209      * @param value uint256 the amount of tokens to be transferred
210      */
211     function transferFrom(address from, address to, uint256 value) public returns (bool) {
212         _transfer(from, to, value);
213         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
214         return true;
215     }
216 
217     /**
218      * @dev Increase the amount of tokens that an owner allowed to a spender.
219      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
220      * allowed value is better to use this function to avoid 2 calls (and wait until
221      * the first transaction is mined)
222      * From MonolithDAO Token.sol
223      * Emits an Approval event.
224      * @param spender The address which will spend the funds.
225      * @param addedValue The amount of tokens to increase the allowance by.
226      */
227     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
228         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
229         return true;
230     }
231 
232     /**
233      * @dev Decrease the amount of tokens that an owner allowed to a spender.
234      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * From MonolithDAO Token.sol
238      * Emits an Approval event.
239      * @param spender The address which will spend the funds.
240      * @param subtractedValue The amount of tokens to decrease the allowance by.
241      */
242     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
243         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
244         return true;
245     }
246 
247     /**
248      * @dev Transfer token for a specified addresses
249      * @param from The address to transfer from.
250      * @param to The address to transfer to.
251      * @param value The amount to be transferred.
252      */
253     function _transfer(address from, address to, uint256 value) internal {
254         require(to != address(0));
255 
256         _balances[from] = _balances[from].sub(value);
257         _balances[to] = _balances[to].add(value);
258         emit Transfer(from, to, value);
259     }
260 
261     /**
262      * @dev Internal function that mints an amount of the token and assigns it to
263      * an account. This encapsulates the modification of balances such that the
264      * proper events are emitted.
265      * @param account The account that will receive the created tokens.
266      * @param value The amount that will be created.
267      */
268     function _mint(address account, uint256 value) internal {
269         require(account != address(0));
270 
271         _totalSupply = _totalSupply.add(value);
272         _balances[account] = _balances[account].add(value);
273         emit Transfer(address(0), account, value);
274     }
275 
276     /**
277      * @dev Internal function that burns an amount of the token of a given
278      * account.
279      * @param account The account whose tokens will be burnt.
280      * @param value The amount that will be burnt.
281      */
282     function _burn(address account, uint256 value) internal {
283         require(account != address(0));
284 
285         _totalSupply = _totalSupply.sub(value);
286         _balances[account] = _balances[account].sub(value);
287         emit Transfer(account, address(0), value);
288     }
289 
290     /**
291      * @dev Approve an address to spend another addresses' tokens.
292      * @param owner The address that owns the tokens.
293      * @param spender The address that will spend the tokens.
294      * @param value The number of tokens that can be spent.
295      */
296     function _approve(address owner, address spender, uint256 value) internal {
297         require(spender != address(0));
298         require(owner != address(0));
299 
300         _allowed[owner][spender] = value;
301         emit Approval(owner, spender, value);
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
313         _burn(account, value);
314         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
315     }
316 }
317 
318 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
319 
320 pragma solidity ^0.5.2;
321 
322 
323 /**
324  * @title ERC20Detailed token
325  * @dev The decimals are only for visualization purposes.
326  * All the operations are done using the smallest and indivisible token unit,
327  * just as on Ethereum all the operations are done in wei.
328  */
329 contract ERC20Detailed is IERC20 {
330     string private _name;
331     string private _symbol;
332     uint8 private _decimals;
333 
334     constructor (string memory name, string memory symbol, uint8 decimals) public {
335         _name = name;
336         _symbol = symbol;
337         _decimals = decimals;
338     }
339 
340     /**
341      * @return the name of the token.
342      */
343     function name() public view returns (string memory) {
344         return _name;
345     }
346 
347     /**
348      * @return the symbol of the token.
349      */
350     function symbol() public view returns (string memory) {
351         return _symbol;
352     }
353 
354     /**
355      * @return the number of decimals of the token.
356      */
357     function decimals() public view returns (uint8) {
358         return _decimals;
359     }
360 }
361 
362 // File: openzeppelin-solidity/contracts/access/Roles.sol
363 
364 pragma solidity ^0.5.2;
365 
366 /**
367  * @title Roles
368  * @dev Library for managing addresses assigned to a Role.
369  */
370 library Roles {
371     struct Role {
372         mapping (address => bool) bearer;
373     }
374 
375     /**
376      * @dev give an account access to this role
377      */
378     function add(Role storage role, address account) internal {
379         require(account != address(0));
380         require(!has(role, account));
381 
382         role.bearer[account] = true;
383     }
384 
385     /**
386      * @dev remove an account's access to this role
387      */
388     function remove(Role storage role, address account) internal {
389         require(account != address(0));
390         require(has(role, account));
391 
392         role.bearer[account] = false;
393     }
394 
395     /**
396      * @dev check if an account has this role
397      * @return bool
398      */
399     function has(Role storage role, address account) internal view returns (bool) {
400         require(account != address(0));
401         return role.bearer[account];
402     }
403 }
404 
405 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
406 
407 pragma solidity ^0.5.2;
408 
409 
410 contract MinterRole {
411     using Roles for Roles.Role;
412 
413     event MinterAdded(address indexed account);
414     event MinterRemoved(address indexed account);
415 
416     Roles.Role private _minters;
417 
418     constructor () internal {
419         _addMinter(msg.sender);
420     }
421 
422     modifier onlyMinter() {
423         require(isMinter(msg.sender));
424         _;
425     }
426 
427     function isMinter(address account) public view returns (bool) {
428         return _minters.has(account);
429     }
430 
431     function addMinter(address account) public onlyMinter {
432         _addMinter(account);
433     }
434 
435     function renounceMinter() public {
436         _removeMinter(msg.sender);
437     }
438 
439     function _addMinter(address account) internal {
440         _minters.add(account);
441         emit MinterAdded(account);
442     }
443 
444     function _removeMinter(address account) internal {
445         _minters.remove(account);
446         emit MinterRemoved(account);
447     }
448 }
449 
450 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
451 
452 pragma solidity ^0.5.2;
453 
454 
455 
456 /**
457  * @title ERC20Mintable
458  * @dev ERC20 minting logic
459  */
460 contract ERC20Mintable is ERC20, MinterRole {
461     /**
462      * @dev Function to mint tokens
463      * @param to The address that will receive the minted tokens.
464      * @param value The amount of tokens to mint.
465      * @return A boolean that indicates if the operation was successful.
466      */
467     function mint(address to, uint256 value) public onlyMinter returns (bool) {
468         _mint(to, value);
469         return true;
470     }
471 }
472 
473 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
474 
475 pragma solidity ^0.5.2;
476 
477 
478 /**
479  * @title Burnable Token
480  * @dev Token that can be irreversibly burned (destroyed).
481  */
482 contract ERC20Burnable is ERC20 {
483     /**
484      * @dev Burns a specific amount of tokens.
485      * @param value The amount of token to be burned.
486      */
487     function burn(uint256 value) public {
488         _burn(msg.sender, value);
489     }
490 
491     /**
492      * @dev Burns a specific amount of tokens from the target address and decrements allowance
493      * @param from address The account whose tokens will be burned.
494      * @param value uint256 The amount of token to be burned.
495      */
496     function burnFrom(address from, uint256 value) public {
497         _burnFrom(from, value);
498     }
499 }
500 
501 // File: contracts/FaucetToken.sol
502 
503 pragma solidity 0.5.5;
504 
505 
506 
507 
508 
509 contract FaucetToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
510     uint8 public constant DECIMALS = 18;
511     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(DECIMALS));
512 
513     /**
514      * @dev Constructor that gives msg.sender all of existing tokens.
515      */
516     constructor () public ERC20Detailed("FaucetToken", "FAU", DECIMALS) {
517     }
518 
519     function() external {
520         mint(msg.sender, 1 ether);
521     }
522 
523     function mint(address to, uint256 value) public returns (bool) {
524         require(value <= 10000000 ether, "dont be greedy");
525         _mint(to, value);
526         return true;
527     }
528 
529 }