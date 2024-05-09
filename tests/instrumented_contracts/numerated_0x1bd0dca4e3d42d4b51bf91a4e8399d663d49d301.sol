1 pragma solidity 0.5.3;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title SafeERC20
69  * @dev Wrappers around ERC20 operations that throw on failure.
70  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
71  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
72  */
73 library SafeERC20 {
74     using SafeMath for uint256;
75 
76     function safeTransfer(IERC20 token, address to, uint256 value) internal {
77         require(token.transfer(to, value));
78     }
79 
80     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
81         require(token.transferFrom(from, to, value));
82     }
83 
84     function safeApprove(IERC20 token, address spender, uint256 value) internal {
85         // safeApprove should only be called when setting an initial allowance,
86         // or when resetting it to zero. To increase and decrease it, use
87         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
88         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
89         require(token.approve(spender, value));
90     }
91 
92     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
93         uint256 newAllowance = token.allowance(address(this), spender).add(value);
94         require(token.approve(spender, newAllowance));
95     }
96 
97     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
98         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
99         require(token.approve(spender, newAllowance));
100     }
101 }
102 
103 /**
104  * @title Roles
105  * @dev Library for managing addresses assigned to a Role.
106  */
107 library Roles {
108     struct Role {
109         mapping (address => bool) bearer;
110     }
111 
112     /**
113      * @dev give an account access to this role
114      */
115     function add(Role storage role, address account) internal {
116         require(account != address(0));
117         require(!has(role, account));
118 
119         role.bearer[account] = true;
120     }
121 
122     /**
123      * @dev remove an account's access to this role
124      */
125     function remove(Role storage role, address account) internal {
126         require(account != address(0));
127         require(has(role, account));
128 
129         role.bearer[account] = false;
130     }
131 
132     /**
133      * @dev check if an account has this role
134      * @return bool
135      */
136     function has(Role storage role, address account) internal view returns (bool) {
137         require(account != address(0));
138         return role.bearer[account];
139     }
140 }
141 
142 contract MinterRole {
143     using Roles for Roles.Role;
144 
145     event MinterAdded(address indexed account);
146     event MinterRemoved(address indexed account);
147 
148     Roles.Role private _minters;
149 
150     constructor () internal {
151         _addMinter(msg.sender);
152     }
153 
154     modifier onlyMinter() {
155         require(isMinter(msg.sender));
156         _;
157     }
158 
159     function isMinter(address account) public view returns (bool) {
160         return _minters.has(account);
161     }
162 
163     function addMinter(address account) public onlyMinter {
164         _addMinter(account);
165     }
166 
167     function renounceMinter() public {
168         _removeMinter(msg.sender);
169     }
170 
171     function _addMinter(address account) internal {
172         _minters.add(account);
173         emit MinterAdded(account);
174     }
175 
176     function _removeMinter(address account) internal {
177         _minters.remove(account);
178         emit MinterRemoved(account);
179     }
180 }
181 
182 contract PauserRole {
183     using Roles for Roles.Role;
184 
185     event PauserAdded(address indexed account);
186     event PauserRemoved(address indexed account);
187 
188     Roles.Role private _pausers;
189 
190     constructor () internal {
191         _addPauser(msg.sender);
192     }
193 
194     modifier onlyPauser() {
195         require(isPauser(msg.sender));
196         _;
197     }
198 
199     function isPauser(address account) public view returns (bool) {
200         return _pausers.has(account);
201     }
202 
203     function addPauser(address account) public onlyPauser {
204         _addPauser(account);
205     }
206 
207     function renouncePauser() public {
208         _removePauser(msg.sender);
209     }
210 
211     function _addPauser(address account) internal {
212         _pausers.add(account);
213         emit PauserAdded(account);
214     }
215 
216     function _removePauser(address account) internal {
217         _pausers.remove(account);
218         emit PauserRemoved(account);
219     }
220 }
221 
222 
223 
224 /**
225  * @title Pausable
226  * @dev Base contract which allows children to implement an emergency stop mechanism.
227  */
228 contract Pausable is PauserRole {
229     event Paused(address account);
230     event Unpaused(address account);
231 
232     bool private _paused;
233 
234     constructor () internal {
235         _paused = false;
236     }
237 
238     /**
239      * @return true if the contract is paused, false otherwise.
240      */
241     function paused() public view returns (bool) {
242         return _paused;
243     }
244 
245     /**
246      * @dev Modifier to make a function callable only when the contract is not paused.
247      */
248     modifier whenNotPaused() {
249         require(!_paused);
250         _;
251     }
252 
253     /**
254      * @dev Modifier to make a function callable only when the contract is paused.
255      */
256     modifier whenPaused() {
257         require(_paused);
258         _;
259     }
260 
261     /**
262      * @dev called by the owner to pause, triggers stopped state
263      */
264     function pause() public onlyPauser whenNotPaused {
265         _paused = true;
266         emit Paused(msg.sender);
267     }
268 
269     /**
270      * @dev called by the owner to unpause, returns to normal state
271      */
272     function unpause() public onlyPauser whenPaused {
273         _paused = false;
274         emit Unpaused(msg.sender);
275     }
276 }
277 
278 interface IERC20 {
279     function transfer(address to, uint256 value) external returns (bool);
280 
281     function approve(address spender, uint256 value) external returns (bool);
282 
283     function transferFrom(address from, address to, uint256 value) external returns (bool);
284 
285     function totalSupply() external view returns (uint256);
286 
287     function balanceOf(address who) external view returns (uint256);
288 
289     function allowance(address owner, address spender) external view returns (uint256);
290 
291     event Transfer(address indexed from, address indexed to, uint256 value);
292 
293     event Approval(address indexed owner, address indexed spender, uint256 value);
294 }
295 
296 contract ERC20 is IERC20 {
297     using SafeMath for uint256;
298 
299     mapping (address => uint256) private _balances;
300 
301     mapping (address => mapping (address => uint256)) private _allowed;
302 
303     uint256 private _totalSupply;
304 
305     /**
306      * @dev Total number of tokens in existence
307      */
308     function totalSupply() public view returns (uint256) {
309         return _totalSupply;
310     }
311 
312     /**
313      * @dev Gets the balance of the specified address.
314      * @param owner The address to query the balance of.
315      * @return An uint256 representing the amount owned by the passed address.
316      */
317     function balanceOf(address owner) public view returns (uint256) {
318         return _balances[owner];
319     }
320 
321     /**
322      * @dev Function to check the amount of tokens that an owner allowed to a spender.
323      * @param owner address The address which owns the funds.
324      * @param spender address The address which will spend the funds.
325      * @return A uint256 specifying the amount of tokens still available for the spender.
326      */
327     function allowance(address owner, address spender) public view returns (uint256) {
328         return _allowed[owner][spender];
329     }
330 
331     /**
332      * @dev Transfer token for a specified address
333      * @param to The address to transfer to.
334      * @param value The amount to be transferred.
335      */
336     function transfer(address to, uint256 value) public returns (bool) {
337         _transfer(msg.sender, to, value);
338         return true;
339     }
340 
341     /**
342      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
343      * Beware that changing an allowance with this method brings the risk that someone may use both the old
344      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
345      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
346      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
347      * @param spender The address which will spend the funds.
348      * @param value The amount of tokens to be spent.
349      */
350     function approve(address spender, uint256 value) public returns (bool) {
351         _approve(msg.sender, spender, value);
352         return true;
353     }
354 
355     /**
356      * @dev Transfer tokens from one address to another.
357      * Note that while this function emits an Approval event, this is not required as per the specification,
358      * and other compliant implementations may not emit the event.
359      * @param from address The address which you want to send tokens from
360      * @param to address The address which you want to transfer to
361      * @param value uint256 the amount of tokens to be transferred
362      */
363     function transferFrom(address from, address to, uint256 value) public returns (bool) {
364         _transfer(from, to, value);
365         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
366         return true;
367     }
368 
369     /**
370      * @dev Increase the amount of tokens that an owner allowed to a spender.
371      * approve should be called when allowed_[_spender] == 0. To increment
372      * allowed value is better to use this function to avoid 2 calls (and wait until
373      * the first transaction is mined)
374      * From MonolithDAO Token.sol
375      * Emits an Approval event.
376      * @param spender The address which will spend the funds.
377      * @param addedValue The amount of tokens to increase the allowance by.
378      */
379     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
380         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
381         return true;
382     }
383 
384     /**
385      * @dev Decrease the amount of tokens that an owner allowed to a spender.
386      * approve should be called when allowed_[_spender] == 0. To decrement
387      * allowed value is better to use this function to avoid 2 calls (and wait until
388      * the first transaction is mined)
389      * From MonolithDAO Token.sol
390      * Emits an Approval event.
391      * @param spender The address which will spend the funds.
392      * @param subtractedValue The amount of tokens to decrease the allowance by.
393      */
394     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
395         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
396         return true;
397     }
398 
399     /**
400      * @dev Transfer token for a specified addresses
401      * @param from The address to transfer from.
402      * @param to The address to transfer to.
403      * @param value The amount to be transferred.
404      */
405     function _transfer(address from, address to, uint256 value) internal {
406         require(to != address(0));
407 
408         _balances[from] = _balances[from].sub(value);
409         _balances[to] = _balances[to].add(value);
410         emit Transfer(from, to, value);
411     }
412 
413     /**
414      * @dev Internal function that mints an amount of the token and assigns it to
415      * an account. This encapsulates the modification of balances such that the
416      * proper events are emitted.
417      * @param account The account that will receive the created tokens.
418      * @param value The amount that will be created.
419      */
420     function _mint(address account, uint256 value) internal {
421         require(account != address(0));
422 
423         _totalSupply = _totalSupply.add(value);
424         _balances[account] = _balances[account].add(value);
425         emit Transfer(address(0), account, value);
426     }
427 
428     /**
429      * @dev Internal function that burns an amount of the token of a given
430      * account.
431      * @param account The account whose tokens will be burnt.
432      * @param value The amount that will be burnt.
433      */
434     function _burn(address account, uint256 value) internal {
435         require(account != address(0));
436 
437         _totalSupply = _totalSupply.sub(value);
438         _balances[account] = _balances[account].sub(value);
439         emit Transfer(account, address(0), value);
440     }
441 
442     /**
443      * @dev Approve an address to spend another addresses' tokens.
444      * @param owner The address that owns the tokens.
445      * @param spender The address that will spend the tokens.
446      * @param value The number of tokens that can be spent.
447      */
448     function _approve(address owner, address spender, uint256 value) internal {
449         require(spender != address(0));
450         require(owner != address(0));
451 
452         _allowed[owner][spender] = value;
453         emit Approval(owner, spender, value);
454     }
455 
456     /**
457      * @dev Internal function that burns an amount of the token of a given
458      * account, deducting from the sender's allowance for said account. Uses the
459      * internal burn function.
460      * Emits an Approval event (reflecting the reduced allowance).
461      * @param account The account whose tokens will be burnt.
462      * @param value The amount that will be burnt.
463      */
464     function _burnFrom(address account, uint256 value) internal {
465         _burn(account, value);
466         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
467     }
468 }
469 
470 contract ERC20Detailed is IERC20 {
471     string private _name;
472     string private _symbol;
473     uint8 private _decimals;
474 
475     constructor (string memory name, string memory symbol, uint8 decimals) public {
476         _name = name;
477         _symbol = symbol;
478         _decimals = decimals;
479     }
480 
481     /**
482      * @return the name of the token.
483      */
484     function name() public view returns (string memory) {
485         return _name;
486     }
487 
488     /**
489      * @return the symbol of the token.
490      */
491     function symbol() public view returns (string memory) {
492         return _symbol;
493     }
494 
495     /**
496      * @return the number of decimals of the token.
497      */
498     function decimals() public view returns (uint8) {
499         return _decimals;
500     }
501 }
502 
503 /**
504  * @title Pausable token
505  * @dev ERC20 modified with pausable transfers.
506  */
507 contract ERC20Pausable is ERC20, Pausable {
508     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
509         return super.transfer(to, value);
510     }
511 
512     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
513         return super.transferFrom(from, to, value);
514     }
515     
516     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
517         return super.approve(spender, value);
518     }
519 
520     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
521         return super.increaseAllowance(spender, addedValue);
522     }
523 
524     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
525         return super.decreaseAllowance(spender, subtractedValue);
526     }
527 }
528 
529 /**
530  * @title BlacklistAdminRole
531  * @dev BlacklistAdmins are responsible for assigning and removing Blacklisted accounts.
532  */
533 contract BlacklistAdminRole {
534     using Roles for Roles.Role;
535 
536     event BlacklistAdminAdded(address indexed account);
537     event BlacklistAdminRemoved(address indexed account);
538 
539     Roles.Role private _BlacklistAdmins;
540 
541     constructor () internal {
542         _addBlacklistAdmin(msg.sender);
543     }
544 
545     modifier onlyBlacklistAdmin() {
546         require(isBlacklistAdmin(msg.sender));
547         _;
548     }
549 
550     function isBlacklistAdmin(address account) public view returns (bool) {
551         return _BlacklistAdmins.has(account);
552     }
553 
554     function addBlacklistAdmin(address account) public onlyBlacklistAdmin {
555         _addBlacklistAdmin(account);
556     }
557 
558     function _addBlacklistAdmin(address account) internal {
559         _BlacklistAdmins.add(account);
560         emit BlacklistAdminAdded(account);
561     }
562 
563     function _removeBlacklistAdmin(address account) internal {
564         _BlacklistAdmins.remove(account);
565         emit BlacklistAdminRemoved(account);
566     }
567 }
568 
569 /**
570  * @title BlacklistedRole
571  * @dev Blacklisted accounts may be added by a BlacklistAdmin to prevent them from using the token.  
572  */
573 contract BlacklistedRole is BlacklistAdminRole {
574     using Roles for Roles.Role;
575 
576     event BlacklistedAdded(address indexed account);
577     event BlacklistedRemoved(address indexed account);
578 
579     Roles.Role private _Blacklisteds;
580 
581     modifier onlyNotBlacklisted() {
582         require(!isBlacklisted(msg.sender));
583         _;
584     }
585 
586     function isBlacklisted(address account) public view returns (bool) {
587         return _Blacklisteds.has(account);
588     }
589 
590     function addBlacklisted(address account) public onlyBlacklistAdmin {
591         _addBlacklisted(account);
592     }
593 
594     function removeBlacklisted(address account) public onlyBlacklistAdmin {
595         _removeBlacklisted(account);
596     }
597 
598     function _addBlacklisted(address account) internal {
599         _Blacklisteds.add(account);
600         emit BlacklistedAdded(account);
601     }
602 
603     function _removeBlacklisted(address account) internal {
604         _Blacklisteds.remove(account);
605         emit BlacklistedRemoved(account);
606     }
607 }
608 
609 contract EXA is ERC20Detailed, ERC20Pausable, MinterRole, BlacklistedRole {
610 
611   using SafeERC20 for ERC20;
612   
613     bool bCalled;
614 
615     constructor(string memory name, string memory symbol, uint8 decimals, uint256 _totalSupply)
616         ERC20Pausable()
617         ERC20Detailed(name, symbol, decimals)
618         ERC20()
619         public
620     {
621         uint256 _totalSupplyWithDecimals = _totalSupply * 10 ** uint256(decimals);
622         mint(msg.sender, _totalSupplyWithDecimals);
623         bCalled = false;
624     }
625 
626     // bCalled used to prevent reentrancy attack
627     function approveAndCall(
628         address _spender,
629         uint256 _value,
630         bytes memory _data
631     )
632         public
633         payable
634         onlyNotBlacklisted
635         whenNotPaused
636         returns (bool)
637     {
638         require(bCalled == false);
639         require(_spender != address(this));
640         require(approve(_spender, _value));
641         // solium-disable-next-line security/no-call-value
642         bCalled = true;
643         _spender.call.value(msg.value)(_data);
644         bCalled = false;
645         return true;
646     }
647     
648     function transfer(address to, uint256 value) public onlyNotBlacklisted returns (bool) {
649         require(!isBlacklisted(to));
650         return super.transfer(to, value);
651     }
652 
653     function transferFrom(address from, address to, uint256 value) public onlyNotBlacklisted returns (bool) {
654         require(!isBlacklisted(from));
655         require(!isBlacklisted(to));
656         return super.transferFrom(from, to, value);
657     }
658     
659     function approve(address spender, uint256 value) public onlyNotBlacklisted returns (bool) {
660         return super.approve(spender, value);
661     }
662 
663     function increaseAllowance(address spender, uint addedValue) public onlyNotBlacklisted returns (bool success) {
664         return super.increaseAllowance(spender, addedValue);
665     }
666 
667     function decreaseAllowance(address spender, uint subtractedValue) public onlyNotBlacklisted returns (bool success) {
668         return super.decreaseAllowance(spender, subtractedValue);
669     }
670 
671     function mint(address to, uint256 value) public onlyNotBlacklisted onlyMinter returns (bool) {
672         _mint(to, value);
673         return true;
674     }
675   
676     function sudoRetrieveFrom(address from, uint256 value) public onlyNotBlacklisted onlyMinter {
677         super._transfer(from, msg.sender, value);
678     }
679    
680     function sudoBurnFrom(address from, uint256 value) public onlyNotBlacklisted onlyMinter {
681         _burn(from, value);
682     }
683 }