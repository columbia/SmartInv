1 // File: openzeppelin-solidity/contracts/access/Roles.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: contracts/ProxyToken/ProxyTokenBurnerRole.sol
45 
46 pragma solidity ^0.5.0;
47 
48 
49 contract ProxyTokenBurnerRole {
50   using Roles for Roles.Role;
51 
52   event BurnerAdded(address indexed account);
53   event BurnerRemoved(address indexed account);
54 
55   Roles.Role private burners;
56 
57   constructor() internal {
58     _addBurner(msg.sender);
59   }
60 
61   modifier onlyBurner() {
62     require(isBurner(msg.sender), "Sender does not have a burner role");
63 
64     _;
65   }
66 
67   function isBurner(address account) public view returns (bool) {
68     return burners.has(account);
69   }
70 
71   function addBurner(address account) public onlyBurner {
72     _addBurner(account);
73   }
74 
75   function renounceBurner() public {
76     _removeBurner(msg.sender);
77   }
78 
79   function _addBurner(address account) internal {
80     burners.add(account);
81     emit BurnerAdded(account);
82   }
83 
84   function _removeBurner(address account) internal {
85     burners.remove(account);
86     emit BurnerRemoved(account);
87   }
88 }
89 
90 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
91 
92 pragma solidity ^0.5.0;
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 interface IERC20 {
99     function transfer(address to, uint256 value) external returns (bool);
100 
101     function approve(address spender, uint256 value) external returns (bool);
102 
103     function transferFrom(address from, address to, uint256 value) external returns (bool);
104 
105     function totalSupply() external view returns (uint256);
106 
107     function balanceOf(address who) external view returns (uint256);
108 
109     function allowance(address owner, address spender) external view returns (uint256);
110 
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
117 
118 pragma solidity ^0.5.0;
119 
120 /**
121  * @title SafeMath
122  * @dev Unsigned math operations with safety checks that revert on error
123  */
124 library SafeMath {
125     /**
126     * @dev Multiplies two unsigned integers, reverts on overflow.
127     */
128     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130         // benefit is lost if 'b' is also tested.
131         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
132         if (a == 0) {
133             return 0;
134         }
135 
136         uint256 c = a * b;
137         require(c / a == b);
138 
139         return c;
140     }
141 
142     /**
143     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
144     */
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         // Solidity only automatically asserts when dividing by 0
147         require(b > 0);
148         uint256 c = a / b;
149         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150 
151         return c;
152     }
153 
154     /**
155     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
156     */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         require(b <= a);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165     * @dev Adds two unsigned integers, reverts on overflow.
166     */
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         uint256 c = a + b;
169         require(c >= a);
170 
171         return c;
172     }
173 
174     /**
175     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
176     * reverts when dividing by zero.
177     */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b != 0);
180         return a % b;
181     }
182 }
183 
184 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
185 
186 pragma solidity ^0.5.0;
187 
188 
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
195  * Originally based on code by FirstBlood:
196  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  *
198  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
199  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
200  * compliant implementations may not do it.
201  */
202 contract ERC20 is IERC20 {
203     using SafeMath for uint256;
204 
205     mapping (address => uint256) private _balances;
206 
207     mapping (address => mapping (address => uint256)) private _allowed;
208 
209     uint256 private _totalSupply;
210 
211     /**
212     * @dev Total number of tokens in existence
213     */
214     function totalSupply() public view returns (uint256) {
215         return _totalSupply;
216     }
217 
218     /**
219     * @dev Gets the balance of the specified address.
220     * @param owner The address to query the balance of.
221     * @return An uint256 representing the amount owned by the passed address.
222     */
223     function balanceOf(address owner) public view returns (uint256) {
224         return _balances[owner];
225     }
226 
227     /**
228      * @dev Function to check the amount of tokens that an owner allowed to a spender.
229      * @param owner address The address which owns the funds.
230      * @param spender address The address which will spend the funds.
231      * @return A uint256 specifying the amount of tokens still available for the spender.
232      */
233     function allowance(address owner, address spender) public view returns (uint256) {
234         return _allowed[owner][spender];
235     }
236 
237     /**
238     * @dev Transfer token for a specified address
239     * @param to The address to transfer to.
240     * @param value The amount to be transferred.
241     */
242     function transfer(address to, uint256 value) public returns (bool) {
243         _transfer(msg.sender, to, value);
244         return true;
245     }
246 
247     /**
248      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249      * Beware that changing an allowance with this method brings the risk that someone may use both the old
250      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253      * @param spender The address which will spend the funds.
254      * @param value The amount of tokens to be spent.
255      */
256     function approve(address spender, uint256 value) public returns (bool) {
257         require(spender != address(0));
258 
259         _allowed[msg.sender][spender] = value;
260         emit Approval(msg.sender, spender, value);
261         return true;
262     }
263 
264     /**
265      * @dev Transfer tokens from one address to another.
266      * Note that while this function emits an Approval event, this is not required as per the specification,
267      * and other compliant implementations may not emit the event.
268      * @param from address The address which you want to send tokens from
269      * @param to address The address which you want to transfer to
270      * @param value uint256 the amount of tokens to be transferred
271      */
272     function transferFrom(address from, address to, uint256 value) public returns (bool) {
273         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
274         _transfer(from, to, value);
275         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
276         return true;
277     }
278 
279     /**
280      * @dev Increase the amount of tokens that an owner allowed to a spender.
281      * approve should be called when allowed_[_spender] == 0. To increment
282      * allowed value is better to use this function to avoid 2 calls (and wait until
283      * the first transaction is mined)
284      * From MonolithDAO Token.sol
285      * Emits an Approval event.
286      * @param spender The address which will spend the funds.
287      * @param addedValue The amount of tokens to increase the allowance by.
288      */
289     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
290         require(spender != address(0));
291 
292         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
293         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
294         return true;
295     }
296 
297     /**
298      * @dev Decrease the amount of tokens that an owner allowed to a spender.
299      * approve should be called when allowed_[_spender] == 0. To decrement
300      * allowed value is better to use this function to avoid 2 calls (and wait until
301      * the first transaction is mined)
302      * From MonolithDAO Token.sol
303      * Emits an Approval event.
304      * @param spender The address which will spend the funds.
305      * @param subtractedValue The amount of tokens to decrease the allowance by.
306      */
307     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
308         require(spender != address(0));
309 
310         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
311         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
312         return true;
313     }
314 
315     /**
316     * @dev Transfer token for a specified addresses
317     * @param from The address to transfer from.
318     * @param to The address to transfer to.
319     * @param value The amount to be transferred.
320     */
321     function _transfer(address from, address to, uint256 value) internal {
322         require(to != address(0));
323 
324         _balances[from] = _balances[from].sub(value);
325         _balances[to] = _balances[to].add(value);
326         emit Transfer(from, to, value);
327     }
328 
329     /**
330      * @dev Internal function that mints an amount of the token and assigns it to
331      * an account. This encapsulates the modification of balances such that the
332      * proper events are emitted.
333      * @param account The account that will receive the created tokens.
334      * @param value The amount that will be created.
335      */
336     function _mint(address account, uint256 value) internal {
337         require(account != address(0));
338 
339         _totalSupply = _totalSupply.add(value);
340         _balances[account] = _balances[account].add(value);
341         emit Transfer(address(0), account, value);
342     }
343 
344     /**
345      * @dev Internal function that burns an amount of the token of a given
346      * account.
347      * @param account The account whose tokens will be burnt.
348      * @param value The amount that will be burnt.
349      */
350     function _burn(address account, uint256 value) internal {
351         require(account != address(0));
352 
353         _totalSupply = _totalSupply.sub(value);
354         _balances[account] = _balances[account].sub(value);
355         emit Transfer(account, address(0), value);
356     }
357 
358     /**
359      * @dev Internal function that burns an amount of the token of a given
360      * account, deducting from the sender's allowance for said account. Uses the
361      * internal burn function.
362      * Emits an Approval event (reflecting the reduced allowance).
363      * @param account The account whose tokens will be burnt.
364      * @param value The amount that will be burnt.
365      */
366     function _burnFrom(address account, uint256 value) internal {
367         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
368         _burn(account, value);
369         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
370     }
371 }
372 
373 // File: contracts/ProxyToken/ProxyTokenBurnable.sol
374 
375 pragma solidity ^0.5.0;
376 
377 
378 
379 /**
380  * @title Burnable Token
381  * @dev Token that can be irreversibly burned (destroyed).
382  */
383 contract ProxyTokenBurnable is ERC20, ProxyTokenBurnerRole {
384   mapping (address => mapping (address => uint256)) private _burnAllowed;
385 
386   event BurnApproval(address indexed owner, address indexed spender, uint256 value);
387 
388   /**
389    * @dev Modifier to check if a burner can burn a specific amount of owner's tokens.
390    * @param burner address The address which will burn the funds.
391    * @param owner address The address which owns the funds.
392    * @param amount uint256 The amount of tokens to burn.
393    */
394 
395   modifier onlyWithBurnAllowance(address burner, address owner, uint256 amount) {
396     if (burner != owner) {
397       require(burnAllowance(owner, burner) >= amount, "Not enough burn allowance");
398     }
399     _;
400   }
401 
402   /**
403    * @dev Function to check the amount of tokens that an owner allowed to burn.
404    * @param owner address The address which owns the funds.
405    * @param burner address The address which will burn the funds.
406    * @return A uint256 specifying the amount of tokens still available to burn.
407    */
408   function burnAllowance(address owner, address burner) public view returns (uint256) {
409     return _burnAllowed[owner][burner];
410   }
411 
412   /**
413    * @dev Increase the amount of tokens that an owner allowed to a burner to burn.
414    * @param burner The address which will burn the funds.
415    * @param addedValue The increased amount of tokens to be burnt.
416    */
417   function increaseBurnAllowance(address burner, uint256 addedValue) public returns (bool) {
418     require(burner != address(0), "Invalid burner address");
419 
420     _burnAllowed[msg.sender][burner] = _burnAllowed[msg.sender][burner].add(addedValue);
421 
422     emit BurnApproval(msg.sender, burner, _burnAllowed[msg.sender][burner]);
423 
424     return true;
425   }
426 
427   /**
428    * @dev Decrease the amount of tokens that an owner allowed to a burner to burn.
429    * @param burner The address which will burn the funds.
430    * @param subtractedValue The subtractedValue amount of tokens to be burnt.
431    */
432   function decreaseBurnAllowance(address burner, uint256 subtractedValue) public returns (bool) {
433     require(burner != address(0), "Invalid burner address");
434 
435     _burnAllowed[msg.sender][burner] = _burnAllowed[msg.sender][burner].sub(subtractedValue);
436 
437     emit BurnApproval(msg.sender, burner, _burnAllowed[msg.sender][burner]);
438 
439     return true;
440   }
441 
442   /**
443    * @dev Function to burn tokens
444    * @param amount The amount of tokens to burn.
445    * @return A boolean that indicates if the operation was successful.
446    */
447   function burn(uint256 amount)
448     public
449     onlyBurner
450   returns (bool) {
451     _burn(msg.sender, amount);
452 
453     return true;
454   }
455 
456   /**
457    * @dev Burns a specific amount of tokens from the target address and decrements allowance
458    * @param account address The address which you want to send tokens from
459    * @param amount uint256 The amount of token to be burned
460    */
461   function burnFrom(address account, uint256 amount)
462     public
463     onlyBurner
464     onlyWithBurnAllowance(msg.sender, account, amount)
465   returns (bool) {
466     _burnAllowed[account][msg.sender] = _burnAllowed[account][msg.sender].sub(amount);
467 
468     _burn(account, amount);
469 
470     emit BurnApproval(account, msg.sender, _burnAllowed[account][msg.sender]);
471 
472     return true;
473   }
474 }
475 
476 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
477 
478 pragma solidity ^0.5.0;
479 
480 
481 /**
482  * @title ERC20Detailed token
483  * @dev The decimals are only for visualization purposes.
484  * All the operations are done using the smallest and indivisible token unit,
485  * just as on Ethereum all the operations are done in wei.
486  */
487 contract ERC20Detailed is IERC20 {
488     string private _name;
489     string private _symbol;
490     uint8 private _decimals;
491 
492     constructor (string memory name, string memory symbol, uint8 decimals) public {
493         _name = name;
494         _symbol = symbol;
495         _decimals = decimals;
496     }
497 
498     /**
499      * @return the name of the token.
500      */
501     function name() public view returns (string memory) {
502         return _name;
503     }
504 
505     /**
506      * @return the symbol of the token.
507      */
508     function symbol() public view returns (string memory) {
509         return _symbol;
510     }
511 
512     /**
513      * @return the number of decimals of the token.
514      */
515     function decimals() public view returns (uint8) {
516         return _decimals;
517     }
518 }
519 
520 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
521 
522 pragma solidity ^0.5.0;
523 
524 
525 contract MinterRole {
526     using Roles for Roles.Role;
527 
528     event MinterAdded(address indexed account);
529     event MinterRemoved(address indexed account);
530 
531     Roles.Role private _minters;
532 
533     constructor () internal {
534         _addMinter(msg.sender);
535     }
536 
537     modifier onlyMinter() {
538         require(isMinter(msg.sender));
539         _;
540     }
541 
542     function isMinter(address account) public view returns (bool) {
543         return _minters.has(account);
544     }
545 
546     function addMinter(address account) public onlyMinter {
547         _addMinter(account);
548     }
549 
550     function renounceMinter() public {
551         _removeMinter(msg.sender);
552     }
553 
554     function _addMinter(address account) internal {
555         _minters.add(account);
556         emit MinterAdded(account);
557     }
558 
559     function _removeMinter(address account) internal {
560         _minters.remove(account);
561         emit MinterRemoved(account);
562     }
563 }
564 
565 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
566 
567 pragma solidity ^0.5.0;
568 
569 
570 
571 /**
572  * @title ERC20Mintable
573  * @dev ERC20 minting logic
574  */
575 contract ERC20Mintable is ERC20, MinterRole {
576     /**
577      * @dev Function to mint tokens
578      * @param to The address that will receive the minted tokens.
579      * @param value The amount of tokens to mint.
580      * @return A boolean that indicates if the operation was successful.
581      */
582     function mint(address to, uint256 value) public onlyMinter returns (bool) {
583         _mint(to, value);
584         return true;
585     }
586 }
587 
588 // File: contracts/ProxyToken/ProxyToken.sol
589 
590 pragma solidity ^0.5.0;
591 
592 
593 
594 
595 
596 /**
597  * @title ProxyToken
598  */
599 contract ProxyToken is ERC20, ERC20Detailed, ERC20Mintable, ProxyTokenBurnable {
600   /**
601   * @notice Constructor for the ProxyToken
602   * @param owner owner of the initial proxy tokens
603   * @param name name of the proxy token
604   * @param symbol symbol of the proxy token
605   * @param decimals divisibility of proxy token
606   * @param initialProxySupply initial amount of proxy tokens
607   */
608   constructor(
609     address owner,
610     string memory name,
611     string memory symbol,
612     uint8 decimals,
613     uint256 initialProxySupply)
614   public ERC20Detailed(name, symbol, decimals) {
615     mint(owner, initialProxySupply * (10 ** uint256(decimals)));
616 
617     if (owner == msg.sender) {
618       return;
619     }
620 
621     addBurner(owner);
622     addMinter(owner);
623     renounceBurner();
624     renounceMinter();
625   }
626 }
627 
628 // File: contracts/ProxyToken/instances/UniversalGold.sol
629 
630 pragma solidity ^0.5.0;
631 
632 
633 /**
634  * @title UniversalGold
635  */
636 contract UniversalGold is ProxyToken {
637   /**
638   * @notice Constructor for the UniversalGold
639   * @param owner owner of the initial proxy tokens
640   */
641   constructor(address owner) public ProxyToken(owner, "Universal Gold", "UPXAU", 5, 0) {} // solium-disable-line no-empty-blocks
642 }