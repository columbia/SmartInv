1 pragma solidity 0.5.3;
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
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31     * @dev Multiplies two unsigned integers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70     * @dev Adds two unsigned integers, reverts on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81     * reverts when dividing by zero.
82     */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
94  * Originally based on code by FirstBlood:
95  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  *
97  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
98  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
99  * compliant implementations may not do it.
100  */
101 contract ERC20 is IERC20 {
102     using SafeMath for uint256;
103 
104     mapping(address => uint256) internal _balances;
105 
106     mapping(address => mapping(address => uint256)) internal _allowed;
107 
108     uint256 internal _totalSupply;
109 
110     /**
111     * @dev Total number of tokens in existence
112     */
113     function totalSupply() public view returns (uint256) {
114         return _totalSupply;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param owner The address to query the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address owner) public view returns (uint256) {
123         return _balances[owner];
124     }
125 
126     /**
127      * @dev Function to check the amount of tokens that an owner allowed to a spender.
128      * @param owner address The address which owns the funds.
129      * @param spender address The address which will spend the funds.
130      * @return A uint256 specifying the amount of tokens still available for the spender.
131      */
132     function allowance(address owner, address spender) public view returns (uint256) {
133         return _allowed[owner][spender];
134     }
135 
136     /**
137     * @dev Transfer token for a specified address
138     * @param to The address to transfer to.
139     * @param value The amount to be transferred.
140     */
141     function transfer(address to, uint256 value) public returns (bool) {
142         _transfer(msg.sender, to, value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      * @param spender The address which will spend the funds.
153      * @param value The amount of tokens to be spent.
154      */
155     function approve(address spender, uint256 value) public returns (bool) {
156         require(spender != address(0));
157 
158         _allowed[msg.sender][spender] = value;
159         emit Approval(msg.sender, spender, value);
160         return true;
161     }
162 
163     /**
164      * @dev Transfer tokens from one address to another.
165      * Note that while this function emits an Approval event, this is not required as per the specification,
166      * and other compliant implementations may not emit the event.
167      * @param from address The address which you want to send tokens from
168      * @param to address The address which you want to transfer to
169      * @param value uint256 the amount of tokens to be transferred
170      */
171     function transferFrom(address from, address to, uint256 value) public returns (bool) {
172         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
173         _transfer(from, to, value);
174         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
175         return true;
176     }
177 
178     /**
179      * @dev Increase the amount of tokens that an owner allowed to a spender.
180      * approve should be called when allowed_[_spender] == 0. To increment
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * Emits an Approval event.
185      * @param spender The address which will spend the funds.
186      * @param addedValue The amount of tokens to increase the allowance by.
187      */
188     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
189         require(spender != address(0));
190 
191         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
192         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
193         return true;
194     }
195 
196     /**
197      * @dev Decrease the amount of tokens that an owner allowed to a spender.
198      * approve should be called when allowed_[_spender] == 0. To decrement
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * Emits an Approval event.
203      * @param spender The address which will spend the funds.
204      * @param subtractedValue The amount of tokens to decrease the allowance by.
205      */
206     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
207         require(spender != address(0));
208 
209         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
210         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
211         return true;
212     }
213 
214     /**
215     * @dev Transfer token for a specified addresses
216     * @param from The address to transfer from.
217     * @param to The address to transfer to.
218     * @param value The amount to be transferred.
219     */
220     function _transfer(address from, address to, uint256 value) internal {
221         require(to != address(0));
222 
223         _balances[from] = _balances[from].sub(value);
224         _balances[to] = _balances[to].add(value);
225         emit Transfer(from, to, value);
226     }
227 
228     /**
229      * @dev Internal function that mints an amount of the token and assigns it to
230      * an account. This encapsulates the modification of balances such that the
231      * proper events are emitted.
232      * @param account The account that will receive the created tokens.
233      * @param value The amount that will be created.
234      */
235     function _mint(address account, uint256 value) internal {
236         require(account != address(0));
237 
238         _totalSupply = _totalSupply.add(value);
239         _balances[account] = _balances[account].add(value);
240         emit Transfer(address(0), account, value);
241     }
242 
243     /**
244      * @dev Internal function that burns an amount of the token of a given
245      * account.
246      * @param account The account whose tokens will be burnt.
247      * @param value The amount that will be burnt.
248      */
249     function _burn(address account, uint256 value) internal {
250         require(account != address(0));
251 
252         _totalSupply = _totalSupply.sub(value);
253         _balances[account] = _balances[account].sub(value);
254         emit Transfer(account, address(0), value);
255     }
256 
257     /**
258      * @dev Internal function that burns an amount of the token of a given
259      * account, deducting from the sender's allowance for said account. Uses the
260      * internal burn function.
261      * Emits an Approval event (reflecting the reduced allowance).
262      * @param account The account whose tokens will be burnt.
263      * @param value The amount that will be burnt.
264      */
265     function _burnFrom(address account, uint256 value) internal {
266         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
267         _burn(account, value);
268         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
269     }
270 }
271 
272 /**
273  * @title Roles
274  * @dev Library for managing addresses assigned to a Role.
275  */
276 library Roles {
277     struct Role {
278         mapping (address => bool) bearer;
279     }
280 
281     /**
282      * @dev give an account access to this role
283      */
284     function add(Role storage role, address account) internal {
285         require(account != address(0));
286         require(!has(role, account));
287 
288         role.bearer[account] = true;
289     }
290 
291     /**
292      * @dev remove an account's access to this role
293      */
294     function remove(Role storage role, address account) internal {
295         require(account != address(0));
296         require(has(role, account));
297 
298         role.bearer[account] = false;
299     }
300 
301     /**
302      * @dev check if an account has this role
303      * @return bool
304      */
305     function has(Role storage role, address account) internal view returns (bool) {
306         require(account != address(0));
307         return role.bearer[account];
308     }
309 }
310 
311 contract MinterRole {
312     using Roles for Roles.Role;
313 
314     event MinterAdded(address indexed account);
315     event MinterRemoved(address indexed account);
316 
317     Roles.Role private _minters;
318 
319     constructor () internal {
320         _addMinter(msg.sender);
321     }
322 
323     modifier onlyMinter() {
324         require(isMinter(msg.sender));
325         _;
326     }
327 
328     function isMinter(address account) public view returns (bool) {
329         return _minters.has(account);
330     }
331 
332     function addMinter(address account) public onlyMinter {
333         _addMinter(account);
334     }
335 
336     function renounceMinter() public {
337         _removeMinter(msg.sender);
338     }
339 
340     function _addMinter(address account) internal {
341         _minters.add(account);
342         emit MinterAdded(account);
343     }
344 
345     function _removeMinter(address account) internal {
346         _minters.remove(account);
347         emit MinterRemoved(account);
348     }
349 }
350 
351 /**
352  * @title ERC20Mintable
353  * @dev ERC20 minting logic
354  */
355 contract ERC20Mintable is ERC20, MinterRole {
356     /**
357      * @dev Function to mint tokens
358      * @param to The address that will receive the minted tokens.
359      * @param value The amount of tokens to mint.
360      * @return A boolean that indicates if the operation was successful.
361      */
362     function mint(address to, uint256 value) public onlyMinter returns (bool) {
363         _mint(to, value);
364         return true;
365     }
366 }
367 
368 contract FreezableToken is ERC20 {
369     // freezing chains
370     mapping(bytes32 => uint64) internal _chains;
371     // freezing amounts for each chain
372     mapping(bytes32 => uint) internal _freezings;
373     // total freezing balance per address
374     mapping(address => uint) internal _freezingBalance;
375 
376     event Freezed(address indexed to, uint64 release, uint amount);
377     event Released(address indexed owner, uint amount);
378 
379     /**
380      * @dev Gets the balance of the specified address include freezing tokens.
381      * @param _owner The address to query the the balance of.
382      * @return An uint256 representing the amount owned by the passed address.
383      */
384     function balanceOf(address _owner) public view returns (uint256 balance) {
385         return super.balanceOf(_owner) + _freezingBalance[_owner];
386     }
387 
388     /**
389      * @dev Gets the balance of the specified address without freezing tokens.
390      * @param _owner The address to query the the balance of.
391      * @return An uint256 representing the amount owned by the passed address.
392      */
393     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
394         return super.balanceOf(_owner);
395     }
396 
397     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
398         return _freezingBalance[_owner];
399     }
400 
401     /**
402      * @dev gets freezing count
403      * @param _addr Address of freeze tokens owner.
404      */
405     function freezingCount(address _addr) public view returns (uint count) {
406         uint64 release = _chains[toKey(_addr, 0)];
407         while (release != 0) {
408             count++;
409             release = _chains[toKey(_addr, release)];
410         }
411     }
412 
413     /**
414      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
415      * @param _addr Address of freeze tokens owner.
416      * @param _index Freezing portion index. It ordered by release date descending.
417      */
418     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
419         for (uint i = 0; i < _index + 1; i++) {
420             _release = _chains[toKey(_addr, _release)];
421             if (_release == 0) {
422                 return (_release, _balance);
423             }
424         }
425         _balance = _freezings[toKey(_addr, _release)];
426     }
427 
428     /**
429      * @dev freeze your tokens to the specified address.
430      *      Be careful, gas usage is not deterministic,
431      *      and depends on how many freezes _to address already has.
432      * @param _to Address to which token will be freeze.
433      * @param _amount Amount of token to freeze.
434      * @param _until Release date, must be in future.
435      */
436     function freezeTo(address _to, uint _amount, uint64 _until) public {
437         require(_to != address(0));
438         require(_amount <= _balances[msg.sender], "amount should not be more than balance");
439 
440         _balances[msg.sender] = _balances[msg.sender].sub(_amount);
441 
442         bytes32 currentKey = toKey(_to, _until);
443         _freezings[currentKey] = _freezings[currentKey].add(_amount);
444         _freezingBalance[_to] = _freezingBalance[_to].add(_amount);
445 
446         freeze(_to, _until);
447         emit Transfer(msg.sender, _to, _amount);
448         emit Freezed(_to, _until, _amount);
449     }
450 
451     /**
452      * @dev release first available freezing tokens.
453      */
454     function releaseOnce() public {
455         bytes32 headKey = toKey(msg.sender, 0);
456         uint64 head = _chains[headKey];
457         require(head != 0, "head should not be 0");
458         require(uint64(block.timestamp) > head, "current block time should be more than head time");
459         bytes32 currentKey = toKey(msg.sender, head);
460 
461         uint64 next = _chains[currentKey];
462 
463         uint amount = _freezings[currentKey];
464         delete _freezings[currentKey];
465 
466         _balances[msg.sender] = _balances[msg.sender].add(amount);
467         _freezingBalance[msg.sender] = _freezingBalance[msg.sender].sub(amount);
468 
469         if (next == 0) {
470             delete _chains[headKey];
471         } else {
472             _chains[headKey] = next;
473             delete _chains[currentKey];
474         }
475         emit Released(msg.sender, amount);
476     }
477 
478     /**
479      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
480      * @return how many tokens was released
481      */
482     function releaseAll() public returns (uint tokens) {
483         uint release;
484         uint balance;
485         (release, balance) = getFreezing(msg.sender, 0);
486         while (release != 0 && block.timestamp > release) {
487             releaseOnce();
488             tokens += balance;
489             (release, balance) = getFreezing(msg.sender, 0);
490         }
491     }
492 
493     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
494         // WISH masc to increase entropy
495         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
496         assembly {
497             result := or(result, mul(_addr, 0x10000000000000000))
498             result := or(result, and(_release, 0xffffffffffffffff))
499         }
500     }
501 
502     function freeze(address _to, uint64 _until) internal {
503         require(_until > block.timestamp, "release time should be more than current block time");
504         bytes32 key = toKey(_to, _until);
505         bytes32 parentKey = toKey(_to, uint64(0));
506         uint64 next = _chains[parentKey];
507 
508         if (next == 0) {
509             _chains[parentKey] = _until;
510             return;
511         }
512 
513         bytes32 nextKey = toKey(_to, next);
514         uint parent;
515 
516         while (next != 0 && _until > next) {
517             parent = next;
518             parentKey = nextKey;
519 
520             next = _chains[nextKey];
521             nextKey = toKey(_to, next);
522         }
523 
524         if (_until == next) {
525             return;
526         }
527 
528         if (next != 0) {
529             _chains[key] = next;
530         }
531 
532         _chains[parentKey] = _until;
533     }
534 }
535 
536 contract FreezableMintableToken is FreezableToken, ERC20Mintable {
537     /**
538      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
539      *      Be careful, gas usage is not deterministic,
540      *      and depends on how many freezes _to address already has.
541      * @param _to Address to which token will be freeze.
542      * @param _amount Amount of token to mint and freeze.
543      * @param _until Release date, must be in future.
544      * @return A boolean that indicates if the operation was successful.
545      */
546     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyMinter returns (bool) {
547         _totalSupply = _totalSupply.add(_amount);
548 
549         bytes32 currentKey = toKey(_to, _until);
550         _freezings[currentKey] = _freezings[currentKey].add(_amount);
551         _freezingBalance[_to] = _freezingBalance[_to].add(_amount);
552 
553         freeze(_to, _until);
554         emit Freezed(_to, _until, _amount);
555         emit Transfer(msg.sender, _to, _amount);
556         return true;
557     }
558 }
559 
560 /**
561  * @title Burnable Token
562  * @dev Token that can be irreversibly burned (destroyed).
563  */
564 contract ERC20Burnable is ERC20 {
565     /**
566      * @dev Burns a specific amount of tokens.
567      * @param value The amount of token to be burned.
568      */
569     function burn(uint256 value) public {
570         _burn(msg.sender, value);
571     }
572 
573     /**
574      * @dev Burns a specific amount of tokens from the target address and decrements allowance
575      * @param from address The address which you want to send tokens from
576      * @param value uint256 The amount of token to be burned
577      */
578     function burnFrom(address from, uint256 value) public {
579         _burnFrom(from, value);
580     }
581 }
582 
583 /**
584  * @title ERC20Detailed token
585  * @dev The decimals are only for visualization purposes.
586  * All the operations are done using the smallest and indivisible token unit,
587  * just as on Ethereum all the operations are done in wei.
588  */
589 contract ERC20Detailed is IERC20 {
590     string private _name;
591     string private _symbol;
592     uint8 private _decimals;
593 
594     constructor (string memory name, string memory symbol, uint8 decimals) public {
595         _name = name;
596         _symbol = symbol;
597         _decimals = decimals;
598     }
599 
600     /**
601      * @return the name of the token.
602      */
603     function name() public view returns (string memory) {
604         return _name;
605     }
606 
607     /**
608      * @return the symbol of the token.
609      */
610     function symbol() public view returns (string memory) {
611         return _symbol;
612     }
613 
614     /**
615      * @return the number of decimals of the token.
616      */
617     function decimals() public view returns (uint8) {
618         return _decimals;
619     }
620 }
621 
622 contract MediciToken is ERC20Detailed, FreezableMintableToken, ERC20Burnable {
623     constructor() public ERC20Detailed("Medici Token", "MDI", 18) {}
624 }