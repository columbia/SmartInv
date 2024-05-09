1 /**                                                                         
2 * ________                                                ____                                                           
3 * `MMMMMMMb.                                             6MMMMb\                                                         
4 *  MM    `Mb                                            6M'    `                                                         
5 *  MM     MM   ____  __ ____  __ ____     ____  ___  __ MM         ____     ____         ____     _____  ___  __    __   
6 *  MM     MM  6MMMMb `M6MMMMb `M6MMMMb   6MMMMb `MM 6MM YM.       6MMMMb   6MMMMb.      6MMMMb.  6MMMMMb `MM 6MMb  6MMb  
7 *  MM    .M9 6M'  `Mb MM'  `Mb MM'  `Mb 6M'  `Mb MM69 "  YMMMMb  6M'  `Mb 6M'   Mb     6M'   Mb 6M'   `Mb MM69 `MM69 `Mb 
8 *  MMMMMMM9' MM    MM MM    MM MM    MM MM    MM MM'         `Mb MM    MM MM    `'     MM    `' MM     MM MM'   MM'   MM 
9 *  MM        MMMMMMMM MM    MM MM    MM MMMMMMMM MM           MM MMMMMMMM MM           MM       MM     MM MM    MM    MM 
10 *  MM        MM       MM    MM MM    MM MM       MM           MM MM       MM           MM       MM     MM MM    MM    MM 
11 *  MM        YM    d9 MM.  ,M9 MM.  ,M9 YM    d9 MM     L    ,M9 YM    d9 YM.   d9 68b YM.   d9 YM.   ,M9 MM    MM    MM 
12 * _MM_        YMMMM9  MMYMMM9  MMYMMM9   YMMMM9 _MM_    MYMMMM9   YMMMM9   YMMMM9  Y89  YMMMM9   YMMMMM9 _MM_  _MM_  _MM_
13 *                     MM       MM                                                                                        
14 *                     MM       MM                                                                                        
15 *                    _MM_     _MM_                                                                                       
16 */
17 
18 
19 // Get a free estimate for your Solidity audit @ hello@peppersec.com 
20 // https://peppersec.com
21 
22 /**
23 *   _______    _                ______                   _   
24 *  |__   __|  | |              |  ____|                 | |  
25 *     | | ___ | | _____ _ __   | |__ __ _ _   _  ___ ___| |_ 
26 *     | |/ _ \| |/ / _ \ '_ \  |  __/ _` | | | |/ __/ _ \ __|
27 *     | | (_) |   <  __/ | | | | | | (_| | |_| | (_|  __/ |_ 
28 *     |_|\___/|_|\_\___|_| |_| |_|  \__,_|\__,_|\___\___|\__|
29 */
30 pragma solidity ^0.5.5;
31 
32 /**
33  * @title ERC20 interface
34  * @dev see https://eips.ethereum.org/EIPS/eip-20
35  */
36 interface IERC20 {
37     function transfer(address to, uint256 value) external returns (bool);
38 
39     function approve(address spender, uint256 value) external returns (bool);
40 
41     function transferFrom(address from, address to, uint256 value) external returns (bool);
42 
43     function totalSupply() external view returns (uint256);
44 
45     function balanceOf(address who) external view returns (uint256);
46 
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
55 
56 pragma solidity ^0.5.2;
57 
58 /**
59  * @title SafeMath
60  * @dev Unsigned math operations with safety checks that revert on error
61  */
62 library SafeMath {
63     /**
64      * @dev Multiplies two unsigned integers, reverts on overflow.
65      */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68         // benefit is lost if 'b' is also tested.
69         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b);
76 
77         return c;
78     }
79 
80     /**
81      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0);
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
94      */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b <= a);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103      * @dev Adds two unsigned integers, reverts on overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a);
108 
109         return c;
110     }
111 
112     /**
113      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
114      * reverts when dividing by zero.
115      */
116     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b != 0);
118         return a % b;
119     }
120 }
121 
122 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
123 
124 pragma solidity ^0.5.2;
125 
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://eips.ethereum.org/EIPS/eip-20
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
150      * @dev Total number of tokens in existence
151      */
152     function totalSupply() public view returns (uint256) {
153         return _totalSupply;
154     }
155 
156     /**
157      * @dev Gets the balance of the specified address.
158      * @param owner The address to query the balance of.
159      * @return A uint256 representing the amount owned by the passed address.
160      */
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
176      * @dev Transfer token to a specified address
177      * @param to The address to transfer to.
178      * @param value The amount to be transferred.
179      */
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
195         _approve(msg.sender, spender, value);
196         return true;
197     }
198 
199     /**
200      * @dev Transfer tokens from one address to another.
201      * Note that while this function emits an Approval event, this is not required as per the specification,
202      * and other compliant implementations may not emit the event.
203      * @param from address The address which you want to send tokens from
204      * @param to address The address which you want to transfer to
205      * @param value uint256 the amount of tokens to be transferred
206      */
207     function transferFrom(address from, address to, uint256 value) public returns (bool) {
208         _transfer(from, to, value);
209         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
210         return true;
211     }
212 
213     /**
214      * @dev Increase the amount of tokens that an owner allowed to a spender.
215      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      * Emits an Approval event.
220      * @param spender The address which will spend the funds.
221      * @param addedValue The amount of tokens to increase the allowance by.
222      */
223     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
224         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
225         return true;
226     }
227 
228     /**
229      * @dev Decrease the amount of tokens that an owner allowed to a spender.
230      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
231      * allowed value is better to use this function to avoid 2 calls (and wait until
232      * the first transaction is mined)
233      * From MonolithDAO Token.sol
234      * Emits an Approval event.
235      * @param spender The address which will spend the funds.
236      * @param subtractedValue The amount of tokens to decrease the allowance by.
237      */
238     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
239         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
240         return true;
241     }
242 
243     /**
244      * @dev Transfer token for a specified addresses
245      * @param from The address to transfer from.
246      * @param to The address to transfer to.
247      * @param value The amount to be transferred.
248      */
249     function _transfer(address from, address to, uint256 value) internal {
250         require(to != address(0));
251 
252         _balances[from] = _balances[from].sub(value);
253         _balances[to] = _balances[to].add(value);
254         emit Transfer(from, to, value);
255     }
256 
257     /**
258      * @dev Internal function that mints an amount of the token and assigns it to
259      * an account. This encapsulates the modification of balances such that the
260      * proper events are emitted.
261      * @param account The account that will receive the created tokens.
262      * @param value The amount that will be created.
263      */
264     function _mint(address account, uint256 value) internal {
265         require(account != address(0));
266 
267         _totalSupply = _totalSupply.add(value);
268         _balances[account] = _balances[account].add(value);
269         emit Transfer(address(0), account, value);
270     }
271 
272     /**
273      * @dev Internal function that burns an amount of the token of a given
274      * account.
275      * @param account The account whose tokens will be burnt.
276      * @param value The amount that will be burnt.
277      */
278     function _burn(address account, uint256 value) internal {
279         require(account != address(0));
280 
281         _totalSupply = _totalSupply.sub(value);
282         _balances[account] = _balances[account].sub(value);
283         emit Transfer(account, address(0), value);
284     }
285 
286     /**
287      * @dev Approve an address to spend another addresses' tokens.
288      * @param owner The address that owns the tokens.
289      * @param spender The address that will spend the tokens.
290      * @param value The number of tokens that can be spent.
291      */
292     function _approve(address owner, address spender, uint256 value) internal {
293         require(spender != address(0));
294         require(owner != address(0));
295 
296         _allowed[owner][spender] = value;
297         emit Approval(owner, spender, value);
298     }
299 
300     /**
301      * @dev Internal function that burns an amount of the token of a given
302      * account, deducting from the sender's allowance for said account. Uses the
303      * internal burn function.
304      * Emits an Approval event (reflecting the reduced allowance).
305      * @param account The account whose tokens will be burnt.
306      * @param value The amount that will be burnt.
307      */
308     function _burnFrom(address account, uint256 value) internal {
309         _burn(account, value);
310         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
311     }
312 }
313 
314 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
315 
316 pragma solidity ^0.5.2;
317 
318 
319 /**
320  * @title ERC20Detailed token
321  * @dev The decimals are only for visualization purposes.
322  * All the operations are done using the smallest and indivisible token unit,
323  * just as on Ethereum all the operations are done in wei.
324  */
325 contract ERC20Detailed is IERC20 {
326     string private _name;
327     string private _symbol;
328     uint8 private _decimals;
329 
330     constructor (string memory name, string memory symbol, uint8 decimals) public {
331         _name = name;
332         _symbol = symbol;
333         _decimals = decimals;
334     }
335 
336     /**
337      * @return the name of the token.
338      */
339     function name() public view returns (string memory) {
340         return _name;
341     }
342 
343     /**
344      * @return the symbol of the token.
345      */
346     function symbol() public view returns (string memory) {
347         return _symbol;
348     }
349 
350     /**
351      * @return the number of decimals of the token.
352      */
353     function decimals() public view returns (uint8) {
354         return _decimals;
355     }
356 }
357 
358 // File: openzeppelin-solidity/contracts/access/Roles.sol
359 
360 pragma solidity ^0.5.2;
361 
362 /**
363  * @title Roles
364  * @dev Library for managing addresses assigned to a Role.
365  */
366 library Roles {
367     struct Role {
368         mapping (address => bool) bearer;
369     }
370 
371     /**
372      * @dev give an account access to this role
373      */
374     function add(Role storage role, address account) internal {
375         require(account != address(0));
376         require(!has(role, account));
377 
378         role.bearer[account] = true;
379     }
380 
381     /**
382      * @dev remove an account's access to this role
383      */
384     function remove(Role storage role, address account) internal {
385         require(account != address(0));
386         require(has(role, account));
387 
388         role.bearer[account] = false;
389     }
390 
391     /**
392      * @dev check if an account has this role
393      * @return bool
394      */
395     function has(Role storage role, address account) internal view returns (bool) {
396         require(account != address(0));
397         return role.bearer[account];
398     }
399 }
400 
401 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
402 
403 pragma solidity ^0.5.2;
404 
405 
406 contract MinterRole {
407     using Roles for Roles.Role;
408 
409     event MinterAdded(address indexed account);
410     event MinterRemoved(address indexed account);
411 
412     Roles.Role private _minters;
413 
414     constructor () internal {
415         _addMinter(msg.sender);
416     }
417 
418     modifier onlyMinter() {
419         require(isMinter(msg.sender));
420         _;
421     }
422 
423     function isMinter(address account) public view returns (bool) {
424         return _minters.has(account);
425     }
426 
427     function addMinter(address account) public onlyMinter {
428         _addMinter(account);
429     }
430 
431     function renounceMinter() public {
432         _removeMinter(msg.sender);
433     }
434 
435     function _addMinter(address account) internal {
436         _minters.add(account);
437         emit MinterAdded(account);
438     }
439 
440     function _removeMinter(address account) internal {
441         _minters.remove(account);
442         emit MinterRemoved(account);
443     }
444 }
445 
446 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
447 
448 pragma solidity ^0.5.2;
449 
450 
451 
452 /**
453  * @title ERC20Mintable
454  * @dev ERC20 minting logic
455  */
456 contract ERC20Mintable is ERC20, MinterRole {
457     /**
458      * @dev Function to mint tokens
459      * @param to The address that will receive the minted tokens.
460      * @param value The amount of tokens to mint.
461      * @return A boolean that indicates if the operation was successful.
462      */
463     function mint(address to, uint256 value) public onlyMinter returns (bool) {
464         _mint(to, value);
465         return true;
466     }
467 }
468 
469 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
470 
471 pragma solidity ^0.5.2;
472 
473 
474 /**
475  * @title Burnable Token
476  * @dev Token that can be irreversibly burned (destroyed).
477  */
478 contract ERC20Burnable is ERC20 {
479     /**
480      * @dev Burns a specific amount of tokens.
481      * @param value The amount of token to be burned.
482      */
483     function burn(uint256 value) public {
484         _burn(msg.sender, value);
485     }
486 
487     /**
488      * @dev Burns a specific amount of tokens from the target address and decrements allowance
489      * @param from address The account whose tokens will be burned.
490      * @param value uint256 The amount of token to be burned.
491      */
492     function burnFrom(address from, uint256 value) public {
493         _burnFrom(from, value);
494     }
495 }
496 
497 // File: contracts/FaucetToken.sol
498 
499 pragma solidity 0.5.5;
500 
501 
502 
503 
504 
505 contract FaucetToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
506     uint8 public constant DECIMALS = 18;
507     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(DECIMALS));
508 
509     /**
510      * @dev Constructor that gives msg.sender all of existing tokens.
511      */
512     constructor () public ERC20Detailed("FaucetToken", "FAU", DECIMALS) {
513     }
514 
515     function() external {
516         mint(msg.sender, 1 ether);
517     }
518 
519     function mint(address to, uint256 value) public returns (bool) {
520         require(value <= 10000000 ether, "dont be greedy");
521         _mint(to, value);
522         return true;
523     }
524 
525 }