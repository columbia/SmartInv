1 pragma solidity >=0.5.0;
2 
3 
4 interface IERC20 {
5     function transfer(address to, uint256 value) external returns (bool);
6 
7     function approve(address spender, uint256 value) external returns (bool);
8 
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     /**
24      * @dev Multiplies two unsigned integers, reverts on overflow.
25      */
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b);
36 
37         return c;
38     }
39 
40     /**
41      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
42      */
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         // Solidity only automatically asserts when dividing by 0
45         require(b > 0);
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48 
49         return c;
50     }
51 
52     /**
53      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
54      */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b <= a);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63      * @dev Adds two unsigned integers, reverts on overflow.
64      */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a);
68 
69         return c;
70     }
71 
72     /**
73      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
74      * reverts when dividing by zero.
75      */
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b != 0);
78         return a % b;
79     }
80 }
81 
82 contract ERC20 is IERC20 {
83     using SafeMath for uint256;
84 
85     mapping (address => uint256) private _balances;
86 
87     mapping (address => mapping (address => uint256)) private _allowed;
88 
89     uint256 private _totalSupply;
90 
91     /**
92      * @dev Total number of tokens in existence
93      */
94     function totalSupply() public view returns (uint256) {
95         return _totalSupply;
96     }
97 
98     /**
99      * @dev Gets the balance of the specified address.
100      * @param owner The address to query the balance of.
101      * @return A uint256 representing the amount owned by the passed address.
102      */
103     function balanceOf(address owner) public view returns (uint256) {
104         return _balances[owner];
105     }
106 
107     /**
108      * @dev Function to check the amount of tokens that an owner allowed to a spender.
109      * @param owner address The address which owns the funds.
110      * @param spender address The address which will spend the funds.
111      * @return A uint256 specifying the amount of tokens still available for the spender.
112      */
113     function allowance(address owner, address spender) public view returns (uint256) {
114         return _allowed[owner][spender];
115     }
116 
117     /**
118      * @dev Transfer token to a specified address
119      * @param to The address to transfer to.
120      * @param value The amount to be transferred.
121      */
122     function transfer(address to, uint256 value) public returns (bool) {
123         _transfer(msg.sender, to, value);
124         return true;
125     }
126 
127     /**
128      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129      * Beware that changing an allowance with this method brings the risk that someone may use both the old
130      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      * @param spender The address which will spend the funds.
134      * @param value The amount of tokens to be spent.
135      */
136     function approve(address spender, uint256 value) public returns (bool) {
137         _approve(msg.sender, spender, value);
138         return true;
139     }
140 
141     /**
142      * @dev Transfer tokens from one address to another.
143      * Note that while this function emits an Approval event, this is not required as per the specification,
144      * and other compliant implementations may not emit the event.
145      * @param from address The address which you want to send tokens from
146      * @param to address The address which you want to transfer to
147      * @param value uint256 the amount of tokens to be transferred
148      */
149     function transferFrom(address from, address to, uint256 value) public returns (bool) {
150         _transfer(from, to, value);
151         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
152         return true;
153     }
154 
155     /**
156      * @dev Increase the amount of tokens that an owner allowed to a spender.
157      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
158      * allowed value is better to use this function to avoid 2 calls (and wait until
159      * the first transaction is mined)
160      * From MonolithDAO Token.sol
161      * Emits an Approval event.
162      * @param spender The address which will spend the funds.
163      * @param addedValue The amount of tokens to increase the allowance by.
164      */
165     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
166         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
167         return true;
168     }
169 
170     /**
171      * @dev Decrease the amount of tokens that an owner allowed to a spender.
172      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
173      * allowed value is better to use this function to avoid 2 calls (and wait until
174      * the first transaction is mined)
175      * From MonolithDAO Token.sol
176      * Emits an Approval event.
177      * @param spender The address which will spend the funds.
178      * @param subtractedValue The amount of tokens to decrease the allowance by.
179      */
180     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
181         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
182         return true;
183     }
184 
185     /**
186      * @dev Transfer token for a specified addresses
187      * @param from The address to transfer from.
188      * @param to The address to transfer to.
189      * @param value The amount to be transferred.
190      */
191     function _transfer(address from, address to, uint256 value) internal {
192         require(to != address(0));
193 
194         _balances[from] = _balances[from].sub(value);
195         _balances[to] = _balances[to].add(value);
196         emit Transfer(from, to, value);
197     }
198 
199     /**
200      * @dev Internal function that mints an amount of the token and assigns it to
201      * an account. This encapsulates the modification of balances such that the
202      * proper events are emitted.
203      * @param account The account that will receive the created tokens.
204      * @param value The amount that will be created.
205      */
206     function _mint(address account, uint256 value) internal {
207         require(account != address(0));
208 
209         _totalSupply = _totalSupply.add(value);
210         _balances[account] = _balances[account].add(value);
211         emit Transfer(address(0), account, value);
212     }
213 
214     /**
215      * @dev Internal function that burns an amount of the token of a given
216      * account.
217      * @param account The account whose tokens will be burnt.
218      * @param value The amount that will be burnt.
219      */
220     function _burn(address account, uint256 value) internal {
221         require(account != address(0));
222 
223         _totalSupply = _totalSupply.sub(value);
224         _balances[account] = _balances[account].sub(value);
225         emit Transfer(account, address(0), value);
226     }
227 
228     /**
229      * @dev Approve an address to spend another addresses' tokens.
230      * @param owner The address that owns the tokens.
231      * @param spender The address that will spend the tokens.
232      * @param value The number of tokens that can be spent.
233      */
234     function _approve(address owner, address spender, uint256 value) internal {
235         require(spender != address(0));
236         require(owner != address(0));
237 
238         _allowed[owner][spender] = value;
239         emit Approval(owner, spender, value);
240     }
241 
242     /**
243      * @dev Internal function that burns an amount of the token of a given
244      * account, deducting from the sender's allowance for said account. Uses the
245      * internal burn function.
246      * Emits an Approval event (reflecting the reduced allowance).
247      * @param account The account whose tokens will be burnt.
248      * @param value The amount that will be burnt.
249      */
250     function _burnFrom(address account, uint256 value) internal {
251         _burn(account, value);
252         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
253     }
254 }
255 
256 contract ERC20Burnable is ERC20 {
257     /**
258      * @dev Burns a specific amount of tokens.
259      * @param value The amount of token to be burned.
260      */
261     function burn(uint256 value) public {
262         _burn(msg.sender, value);
263     }
264 
265     /**
266      * @dev Burns a specific amount of tokens from the target address and decrements allowance
267      * @param from address The account whose tokens will be burned.
268      * @param value uint256 The amount of token to be burned.
269      */
270     function burnFrom(address from, uint256 value) public {
271         _burnFrom(from, value);
272     }
273 }
274 
275 contract ERC20Detailed is IERC20 {
276     string private _name;
277     string private _symbol;
278     uint8 private _decimals;
279 
280     constructor (string memory name, string memory symbol, uint8 decimals) public {
281         _name = name;
282         _symbol = symbol;
283         _decimals = decimals;
284     }
285 
286     /**
287      * @return the name of the token.
288      */
289     function name() public view returns (string memory) {
290         return _name;
291     }
292 
293     /**
294      * @return the symbol of the token.
295      */
296     function symbol() public view returns (string memory) {
297         return _symbol;
298     }
299 
300     /**
301      * @return the number of decimals of the token.
302      */
303     function decimals() public view returns (uint8) {
304         return _decimals;
305     }
306 }
307 
308 library Roles {
309     struct Role {
310         mapping (address => bool) bearer;
311     }
312 
313     /**
314      * @dev give an account access to this role
315      */
316     function add(Role storage role, address account) internal {
317         require(account != address(0));
318         require(!has(role, account));
319 
320         role.bearer[account] = true;
321     }
322 
323     /**
324      * @dev remove an account's access to this role
325      */
326     function remove(Role storage role, address account) internal {
327         require(account != address(0));
328         require(has(role, account));
329 
330         role.bearer[account] = false;
331     }
332 
333     /**
334      * @dev check if an account has this role
335      * @return bool
336      */
337     function has(Role storage role, address account) internal view returns (bool) {
338         require(account != address(0));
339         return role.bearer[account];
340     }
341 }
342 
343 contract MinterRole {
344     using Roles for Roles.Role;
345 
346     event MinterAdded(address indexed account);
347     event MinterRemoved(address indexed account);
348 
349     Roles.Role private _minters;
350 
351     constructor () internal {
352         _addMinter(msg.sender);
353     }
354 
355     modifier onlyMinter() {
356         require(isMinter(msg.sender));
357         _;
358     }
359 
360     function isMinter(address account) public view returns (bool) {
361         return _minters.has(account);
362     }
363 
364     function addMinter(address account) public onlyMinter {
365         _addMinter(account);
366     }
367 
368     function renounceMinter() public {
369         _removeMinter(msg.sender);
370     }
371 
372     function _addMinter(address account) internal {
373         _minters.add(account);
374         emit MinterAdded(account);
375     }
376 
377     function _removeMinter(address account) internal {
378         _minters.remove(account);
379         emit MinterRemoved(account);
380     }
381 }
382 
383 contract ERC20Mintable is ERC20, MinterRole {
384     /**
385      * @dev Function to mint tokens
386      * @param to The address that will receive the minted tokens.
387      * @param value The amount of tokens to mint.
388      * @return A boolean that indicates if the operation was successful.
389      */
390     function mint(address to, uint256 value) public onlyMinter returns (bool) {
391         _mint(to, value);
392         return true;
393     }
394 }
395 
396 contract Ownable {
397     address private _owner;
398 
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
403      * account.
404      */
405     constructor () internal {
406         _owner = msg.sender;
407         emit OwnershipTransferred(address(0), _owner);
408     }
409 
410     /**
411      * @return the address of the owner.
412      */
413     function owner() public view returns (address) {
414         return _owner;
415     }
416 
417     /**
418      * @dev Throws if called by any account other than the owner.
419      */
420     modifier onlyOwner() {
421         require(isOwner());
422         _;
423     }
424 
425     /**
426      * @return true if `msg.sender` is the owner of the contract.
427      */
428     function isOwner() public view returns (bool) {
429         return msg.sender == _owner;
430     }
431 
432     /**
433      * @dev Allows the current owner to relinquish control of the contract.
434      * It will not be possible to call the functions with the `onlyOwner`
435      * modifier anymore.
436      * @notice Renouncing ownership will leave the contract without an owner,
437      * thereby removing any functionality that is only available to the owner.
438      */
439     function renounceOwnership() public onlyOwner {
440         emit OwnershipTransferred(_owner, address(0));
441         _owner = address(0);
442     }
443 
444     /**
445      * @dev Allows the current owner to transfer control of the contract to a newOwner.
446      * @param newOwner The address to transfer ownership to.
447      */
448     function transferOwnership(address newOwner) public onlyOwner {
449         _transferOwnership(newOwner);
450     }
451 
452     /**
453      * @dev Transfers control of the contract to a newOwner.
454      * @param newOwner The address to transfer ownership to.
455      */
456     function _transferOwnership(address newOwner) internal {
457         require(newOwner != address(0));
458         emit OwnershipTransferred(_owner, newOwner);
459         _owner = newOwner;
460     }
461 }
462 
463 interface Compliance {
464     /**
465      *  @dev Checks if a transfer can occur between the from/to addresses.
466      *
467      *  Both addresses must be whitelisted, unfrozen, and pass all compliance rule checks.
468      *  THROWS when the transfer should fail.
469      *  @param initiator The address initiating the transfer.
470      *  @param from The address of the sender.
471      *  @param to The address of the receiver.
472      *  @param tokens The number of tokens being transferred.
473      *  @return If a transfer can occur between the from/to addresses.
474      */
475     function canTransfer(address initiator, address from, address to, uint256 tokens) external returns (bool);
476 }
477 
478 contract QAS is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable, Ownable {
479     uint constant private INITIAL_SUPPLY = 10500000000e18; // 10.5 Billion
480     string constant public NAME = "QAS";
481     string constant public SYMBOL = "QAS";
482     uint8 constant public DECIMALS = 18;
483 
484     address constant internal ZERO_ADDRESS = address(0);
485     Compliance public compliance;
486 
487     constructor()
488         ERC20()
489         ERC20Detailed(NAME, SYMBOL, DECIMALS)
490         ERC20Mintable()
491         ERC20Burnable()
492         Ownable()
493         public
494     {
495         _mint(msg.sender, INITIAL_SUPPLY);
496     }
497 
498     /**
499      *  @dev Sets the compliance contract address to use during transfers.
500      *  @param newComplianceAddress The address of the compliance contract.
501      */
502     function setCompliance(address newComplianceAddress) external onlyOwner {
503         compliance = Compliance(newComplianceAddress);
504     }
505 
506     /**
507      * @dev Transfer token to a specified address
508      * @param to The address to transfer to.
509      * @param value The amount to be transferred.
510      */
511     function transfer(address to, uint256 value) public returns (bool) {
512         bool transferAllowed;
513         transferAllowed = canTransfer(msg.sender, to, value);
514         if (transferAllowed) {
515             _transfer(msg.sender, to, value);
516         }
517         return transferAllowed;
518     }
519 
520     /**
521      *  @dev Checks if a transfer may take place between the two accounts.
522      *
523      *   Validates that the transfer can take place.
524      *     - Ensure the transfer is compliant
525      *  @param from The sender address.
526      *  @param to The recipient address.
527      *  @param tokens The number of tokens being transferred.
528      *  @return If the transfer can take place.
529      */
530     function canTransfer(address from, address to, uint256 tokens) private returns (bool) {
531         // ignore compliance rules when compliance not set.
532         if (address(compliance) == ZERO_ADDRESS) {
533             return true;
534         }
535         return compliance.canTransfer(msg.sender, from, to, tokens);
536     }
537 }