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
42 contract ProxyTokenBurnerRole {
43   using Roles for Roles.Role;
44 
45   event BurnerAdded(address indexed account);
46   event BurnerRemoved(address indexed account);
47 
48   Roles.Role private burners;
49 
50   constructor() internal {
51     _addBurner(msg.sender);
52   }
53 
54   modifier onlyBurner() {
55     require(isBurner(msg.sender), "Sender does not have a burner role");
56 
57     _;
58   }
59 
60   function isBurner(address account) public view returns (bool) {
61     return burners.has(account);
62   }
63 
64   function addBurner(address account) public onlyBurner {
65     _addBurner(account);
66   }
67 
68   function renounceBurner() public {
69     _removeBurner(msg.sender);
70   }
71 
72   function _addBurner(address account) internal {
73     burners.add(account);
74     emit BurnerAdded(account);
75   }
76 
77   function _removeBurner(address account) internal {
78     burners.remove(account);
79     emit BurnerRemoved(account);
80   }
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 interface IERC20 {
88     function transfer(address to, uint256 value) external returns (bool);
89 
90     function approve(address spender, uint256 value) external returns (bool);
91 
92     function transferFrom(address from, address to, uint256 value) external returns (bool);
93 
94     function totalSupply() external view returns (uint256);
95 
96     function balanceOf(address who) external view returns (uint256);
97 
98     function allowance(address owner, address spender) external view returns (uint256);
99 
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @title SafeMath
107  * @dev Unsigned math operations with safety checks that revert on error
108  */
109 library SafeMath {
110     /**
111     * @dev Multiplies two unsigned integers, reverts on overflow.
112     */
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b);
123 
124         return c;
125     }
126 
127     /**
128     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
129     */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         // Solidity only automatically asserts when dividing by 0
132         require(b > 0);
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136         return c;
137     }
138 
139     /**
140     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
141     */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         require(b <= a);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150     * @dev Adds two unsigned integers, reverts on overflow.
151     */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a);
155 
156         return c;
157     }
158 
159     /**
160     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
161     * reverts when dividing by zero.
162     */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b != 0);
165         return a % b;
166     }
167 }
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
174  * Originally based on code by FirstBlood:
175  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  *
177  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
178  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
179  * compliant implementations may not do it.
180  */
181 contract ERC20 is IERC20 {
182     using SafeMath for uint256;
183 
184     mapping (address => uint256) private _balances;
185 
186     mapping (address => mapping (address => uint256)) private _allowed;
187 
188     uint256 private _totalSupply;
189 
190     /**
191     * @dev Total number of tokens in existence
192     */
193     function totalSupply() public view returns (uint256) {
194         return _totalSupply;
195     }
196 
197     /**
198     * @dev Gets the balance of the specified address.
199     * @param owner The address to query the balance of.
200     * @return An uint256 representing the amount owned by the passed address.
201     */
202     function balanceOf(address owner) public view returns (uint256) {
203         return _balances[owner];
204     }
205 
206     /**
207      * @dev Function to check the amount of tokens that an owner allowed to a spender.
208      * @param owner address The address which owns the funds.
209      * @param spender address The address which will spend the funds.
210      * @return A uint256 specifying the amount of tokens still available for the spender.
211      */
212     function allowance(address owner, address spender) public view returns (uint256) {
213         return _allowed[owner][spender];
214     }
215 
216     /**
217     * @dev Transfer token for a specified address
218     * @param to The address to transfer to.
219     * @param value The amount to be transferred.
220     */
221     function transfer(address to, uint256 value) public returns (bool) {
222         _transfer(msg.sender, to, value);
223         return true;
224     }
225 
226     /**
227      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228      * Beware that changing an allowance with this method brings the risk that someone may use both the old
229      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232      * @param spender The address which will spend the funds.
233      * @param value The amount of tokens to be spent.
234      */
235     function approve(address spender, uint256 value) public returns (bool) {
236         require(spender != address(0));
237 
238         _allowed[msg.sender][spender] = value;
239         emit Approval(msg.sender, spender, value);
240         return true;
241     }
242 
243     /**
244      * @dev Transfer tokens from one address to another.
245      * Note that while this function emits an Approval event, this is not required as per the specification,
246      * and other compliant implementations may not emit the event.
247      * @param from address The address which you want to send tokens from
248      * @param to address The address which you want to transfer to
249      * @param value uint256 the amount of tokens to be transferred
250      */
251     function transferFrom(address from, address to, uint256 value) public returns (bool) {
252         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
253         _transfer(from, to, value);
254         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
255         return true;
256     }
257 
258     /**
259      * @dev Increase the amount of tokens that an owner allowed to a spender.
260      * approve should be called when allowed_[_spender] == 0. To increment
261      * allowed value is better to use this function to avoid 2 calls (and wait until
262      * the first transaction is mined)
263      * From MonolithDAO Token.sol
264      * Emits an Approval event.
265      * @param spender The address which will spend the funds.
266      * @param addedValue The amount of tokens to increase the allowance by.
267      */
268     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
269         require(spender != address(0));
270 
271         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
272         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
273         return true;
274     }
275 
276     /**
277      * @dev Decrease the amount of tokens that an owner allowed to a spender.
278      * approve should be called when allowed_[_spender] == 0. To decrement
279      * allowed value is better to use this function to avoid 2 calls (and wait until
280      * the first transaction is mined)
281      * From MonolithDAO Token.sol
282      * Emits an Approval event.
283      * @param spender The address which will spend the funds.
284      * @param subtractedValue The amount of tokens to decrease the allowance by.
285      */
286     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
287         require(spender != address(0));
288 
289         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
290         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
291         return true;
292     }
293 
294     /**
295     * @dev Transfer token for a specified addresses
296     * @param from The address to transfer from.
297     * @param to The address to transfer to.
298     * @param value The amount to be transferred.
299     */
300     function _transfer(address from, address to, uint256 value) internal {
301         require(to != address(0));
302 
303         _balances[from] = _balances[from].sub(value);
304         _balances[to] = _balances[to].add(value);
305         emit Transfer(from, to, value);
306     }
307 
308     /**
309      * @dev Internal function that mints an amount of the token and assigns it to
310      * an account. This encapsulates the modification of balances such that the
311      * proper events are emitted.
312      * @param account The account that will receive the created tokens.
313      * @param value The amount that will be created.
314      */
315     function _mint(address account, uint256 value) internal {
316         require(account != address(0));
317 
318         _totalSupply = _totalSupply.add(value);
319         _balances[account] = _balances[account].add(value);
320         emit Transfer(address(0), account, value);
321     }
322 
323     /**
324      * @dev Internal function that burns an amount of the token of a given
325      * account.
326      * @param account The account whose tokens will be burnt.
327      * @param value The amount that will be burnt.
328      */
329     function _burn(address account, uint256 value) internal {
330         require(account != address(0));
331 
332         _totalSupply = _totalSupply.sub(value);
333         _balances[account] = _balances[account].sub(value);
334         emit Transfer(account, address(0), value);
335     }
336 
337     /**
338      * @dev Internal function that burns an amount of the token of a given
339      * account, deducting from the sender's allowance for said account. Uses the
340      * internal burn function.
341      * Emits an Approval event (reflecting the reduced allowance).
342      * @param account The account whose tokens will be burnt.
343      * @param value The amount that will be burnt.
344      */
345     function _burnFrom(address account, uint256 value) internal {
346         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
347         _burn(account, value);
348         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
349     }
350 }
351 
352 /**
353  * @title Burnable Token
354  * @dev Token that can be irreversibly burned (destroyed).
355  */
356 contract ProxyTokenBurnable is ERC20, ProxyTokenBurnerRole {
357   mapping (address => mapping (address => uint256)) private _burnAllowed;
358 
359   event BurnApproval(address indexed owner, address indexed spender, uint256 value);
360 
361   /**
362    * @dev Modifier to check if a burner can burn a specific amount of owner's tokens.
363    * @param burner address The address which will burn the funds.
364    * @param owner address The address which owns the funds.
365    * @param amount uint256 The amount of tokens to burn.
366    */
367 
368   modifier onlyWithBurnAllowance(address burner, address owner, uint256 amount) {
369     if (burner != owner) {
370       require(burnAllowance(owner, burner) >= amount, "Not enough burn allowance");
371     }
372     _;
373   }
374 
375   /**
376    * @dev Function to check the amount of tokens that an owner allowed to burn.
377    * @param owner address The address which owns the funds.
378    * @param burner address The address which will burn the funds.
379    * @return A uint256 specifying the amount of tokens still available to burn.
380    */
381   function burnAllowance(address owner, address burner) public view returns (uint256) {
382     return _burnAllowed[owner][burner];
383   }
384 
385   /**
386    * @dev Increase the amount of tokens that an owner allowed to a burner to burn.
387    * @param burner The address which will burn the funds.
388    * @param addedValue The increased amount of tokens to be burnt.
389    */
390   function increaseBurnAllowance(address burner, uint256 addedValue) public returns (bool) {
391     require(burner != address(0), "Invalid burner address");
392 
393     _burnAllowed[msg.sender][burner] = _burnAllowed[msg.sender][burner].add(addedValue);
394 
395     emit BurnApproval(msg.sender, burner, _burnAllowed[msg.sender][burner]);
396 
397     return true;
398   }
399 
400   /**
401    * @dev Decrease the amount of tokens that an owner allowed to a burner to burn.
402    * @param burner The address which will burn the funds.
403    * @param subtractedValue The subtractedValue amount of tokens to be burnt.
404    */
405   function decreaseBurnAllowance(address burner, uint256 subtractedValue) public returns (bool) {
406     require(burner != address(0), "Invalid burner address");
407 
408     _burnAllowed[msg.sender][burner] = _burnAllowed[msg.sender][burner].sub(subtractedValue);
409 
410     emit BurnApproval(msg.sender, burner, _burnAllowed[msg.sender][burner]);
411 
412     return true;
413   }
414 
415   /**
416    * @dev Function to burn tokens
417    * @param amount The amount of tokens to burn.
418    * @return A boolean that indicates if the operation was successful.
419    */
420   function burn(uint256 amount)
421     public
422     onlyBurner
423   returns (bool) {
424     _burn(msg.sender, amount);
425 
426     return true;
427   }
428 
429   /**
430    * @dev Burns a specific amount of tokens from the target address and decrements allowance
431    * @param account address The address which you want to send tokens from
432    * @param amount uint256 The amount of token to be burned
433    */
434   function burnFrom(address account, uint256 amount)
435     public
436     onlyBurner
437     onlyWithBurnAllowance(msg.sender, account, amount)
438   returns (bool) {
439     _burnAllowed[account][msg.sender] = _burnAllowed[account][msg.sender].sub(amount);
440 
441     _burn(account, amount);
442 
443     emit BurnApproval(account, msg.sender, _burnAllowed[account][msg.sender]);
444 
445     return true;
446   }
447 }
448 
449 /**
450  * @title ERC20Detailed token
451  * @dev The decimals are only for visualization purposes.
452  * All the operations are done using the smallest and indivisible token unit,
453  * just as on Ethereum all the operations are done in wei.
454  */
455 contract ERC20Detailed is IERC20 {
456     string private _name;
457     string private _symbol;
458     uint8 private _decimals;
459 
460     constructor (string memory name, string memory symbol, uint8 decimals) public {
461         _name = name;
462         _symbol = symbol;
463         _decimals = decimals;
464     }
465 
466     /**
467      * @return the name of the token.
468      */
469     function name() public view returns (string memory) {
470         return _name;
471     }
472 
473     /**
474      * @return the symbol of the token.
475      */
476     function symbol() public view returns (string memory) {
477         return _symbol;
478     }
479 
480     /**
481      * @return the number of decimals of the token.
482      */
483     function decimals() public view returns (uint8) {
484         return _decimals;
485     }
486 }
487 
488 contract MinterRole {
489     using Roles for Roles.Role;
490 
491     event MinterAdded(address indexed account);
492     event MinterRemoved(address indexed account);
493 
494     Roles.Role private _minters;
495 
496     constructor () internal {
497         _addMinter(msg.sender);
498     }
499 
500     modifier onlyMinter() {
501         require(isMinter(msg.sender));
502         _;
503     }
504 
505     function isMinter(address account) public view returns (bool) {
506         return _minters.has(account);
507     }
508 
509     function addMinter(address account) public onlyMinter {
510         _addMinter(account);
511     }
512 
513     function renounceMinter() public {
514         _removeMinter(msg.sender);
515     }
516 
517     function _addMinter(address account) internal {
518         _minters.add(account);
519         emit MinterAdded(account);
520     }
521 
522     function _removeMinter(address account) internal {
523         _minters.remove(account);
524         emit MinterRemoved(account);
525     }
526 }
527 
528 /**
529  * @title ERC20Mintable
530  * @dev ERC20 minting logic
531  */
532 contract ERC20Mintable is ERC20, MinterRole {
533     /**
534      * @dev Function to mint tokens
535      * @param to The address that will receive the minted tokens.
536      * @param value The amount of tokens to mint.
537      * @return A boolean that indicates if the operation was successful.
538      */
539     function mint(address to, uint256 value) public onlyMinter returns (bool) {
540         _mint(to, value);
541         return true;
542     }
543 }
544 
545 /**
546  * @title ProxyToken
547  */
548 contract ProxyToken is ERC20, ERC20Detailed, ERC20Mintable, ProxyTokenBurnable {
549   /**
550   * @notice Constructor for the ProxyToken
551   * @param owner owner of the initial proxy tokens
552   * @param name name of the proxy token
553   * @param symbol symbol of the proxy token
554   * @param decimals divisibility of proxy token
555   * @param initialProxySupply initial amount of proxy tokens
556   */
557   constructor(
558     address owner,
559     string memory name,
560     string memory symbol,
561     uint8 decimals,
562     uint256 initialProxySupply)
563   public ERC20Detailed(name, symbol, decimals) {
564     mint(owner, initialProxySupply * (10 ** uint256(decimals)));
565 
566     if (owner == msg.sender) {
567       return;
568     }
569 
570     addBurner(owner);
571     addMinter(owner);
572     renounceBurner();
573     renounceMinter();
574   }
575 }
576 
577 /**
578  * @title UniversalUSDollar
579  */
580 contract UniversalUSDollar is ProxyToken {
581   /**
582   * @notice Constructor for the UniversalUSDollar
583   * @param owner owner of the initial proxy tokens
584   */
585   constructor(address owner) public ProxyToken(owner, "Universal US Dollar", "UPUSD", 2, 0) {} // solium-disable-line no-empty-blocks
586 }