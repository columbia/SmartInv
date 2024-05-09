1 pragma solidity ^0.5.6;
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
42 
43 
44 
45 contract MinterRole {
46     using Roles for Roles.Role;
47 
48     event MinterAdded(address indexed account);
49     event MinterRemoved(address indexed account);
50 
51     Roles.Role private _minters;
52 
53     constructor () internal {
54         _addMinter(msg.sender);
55     }
56 
57     modifier onlyMinter() {
58         require(isMinter(msg.sender));
59         _;
60     }
61 
62     function isMinter(address account) public view returns (bool) {
63         return _minters.has(account);
64     }
65 
66     function addMinter(address account) public onlyMinter {
67         _addMinter(account);
68     }
69 
70     function renounceMinter() public {
71         _removeMinter(msg.sender);
72     }
73 
74     function _addMinter(address account) internal {
75         _minters.add(account);
76         emit MinterAdded(account);
77     }
78 
79     function _removeMinter(address account) internal {
80         _minters.remove(account);
81         emit MinterRemoved(account);
82     }
83 }
84 
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 interface IERC20 {
91     function transfer(address to, uint256 value) external returns (bool);
92 
93     function approve(address spender, uint256 value) external returns (bool);
94 
95     function transferFrom(address from, address to, uint256 value) external returns (bool);
96 
97     function totalSupply() external view returns (uint256);
98 
99     function balanceOf(address who) external view returns (uint256);
100 
101     function allowance(address owner, address spender) external view returns (uint256);
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 /**
110  * @title SafeMath
111  * @dev Unsigned math operations with safety checks that revert on error
112  */
113 library SafeMath {
114     /**
115     * @dev Multiplies two unsigned integers, reverts on overflow.
116     */
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
119         // benefit is lost if 'b' is also tested.
120         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
121         if (a == 0) {
122             return 0;
123         }
124 
125         uint256 c = a * b;
126         require(c / a == b);
127 
128         return c;
129     }
130 
131     /**
132     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
133     */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Solidity only automatically asserts when dividing by 0
136         require(b > 0);
137         uint256 c = a / b;
138         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139 
140         return c;
141     }
142 
143     /**
144     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
145     */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         require(b <= a);
148         uint256 c = a - b;
149 
150         return c;
151     }
152 
153     /**
154     * @dev Adds two unsigned integers, reverts on overflow.
155     */
156     function add(uint256 a, uint256 b) internal pure returns (uint256) {
157         uint256 c = a + b;
158         require(c >= a);
159 
160         return c;
161     }
162 
163     /**
164     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
165     * reverts when dividing by zero.
166     */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         require(b != 0);
169         return a % b;
170     }
171 }
172 
173 
174  
175 
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     /**
188      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189      * account.
190      */
191     constructor () internal {
192         _owner = msg.sender;
193         emit OwnershipTransferred(address(0), _owner);
194     }
195 
196     /**
197      * @return the address of the owner.
198      */
199     function owner() public view returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(isOwner());
208         _;
209     }
210 
211     /**
212      * @return true if `msg.sender` is the owner of the contract.
213      */
214     function isOwner() public view returns (bool) {
215         return msg.sender == _owner;
216     }
217 
218     /**
219      * @dev Allows the current owner to relinquish control of the contract.
220      * @notice Renouncing to ownership will leave the contract without an owner.
221      * It will not be possible to call the functions with the `onlyOwner`
222      * modifier anymore.
223      */
224     function renounceOwnership() public onlyOwner {
225         emit OwnershipTransferred(_owner, address(0));
226         _owner = address(0);
227     }
228 
229     /**
230      * @dev Allows the current owner to transfer control of the contract to a newOwner.
231      * @param newOwner The address to transfer ownership to.
232      */
233     function transferOwnership(address newOwner) public onlyOwner {
234         _transferOwnership(newOwner);
235     }
236 
237     /**
238      * @dev Transfers control of the contract to a newOwner.
239      * @param newOwner The address to transfer ownership to.
240      */
241     function _transferOwnership(address newOwner) internal {
242         require(newOwner != address(0));
243         emit OwnershipTransferred(_owner, newOwner);
244         _owner = newOwner;
245     }
246 }
247  
248  
249 
250 
251 
252 
253 
254 
255 
256 
257 /**
258  * @title Standard ERC20 token
259  *
260  * @dev Implementation of the basic standard token.
261  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
262  * Originally based on code by FirstBlood:
263  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
264  *
265  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
266  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
267  * compliant implementations may not do it.
268  */
269 contract ERC20 is IERC20 {
270     using SafeMath for uint256;
271 
272     mapping (address => uint256) private _balances;
273 
274     mapping (address => mapping (address => uint256)) private _allowed;
275 
276     uint256 private _totalSupply;
277 
278     /**
279     * @dev Total number of tokens in existence
280     */
281     function totalSupply() public view returns (uint256) {
282         return _totalSupply;
283     }
284 
285     /**
286     * @dev Gets the balance of the specified address.
287     * @param owner The address to query the balance of.
288     * @return An uint256 representing the amount owned by the passed address.
289     */
290     function balanceOf(address owner) public view returns (uint256) {
291         return _balances[owner];
292     }
293 
294     /**
295      * @dev Function to check the amount of tokens that an owner allowed to a spender.
296      * @param owner address The address which owns the funds.
297      * @param spender address The address which will spend the funds.
298      * @return A uint256 specifying the amount of tokens still available for the spender.
299      */
300     function allowance(address owner, address spender) public view returns (uint256) {
301         return _allowed[owner][spender];
302     }
303 
304     /**
305     * @dev Transfer token for a specified address
306     * @param to The address to transfer to.
307     * @param value The amount to be transferred.
308     */
309     function transfer(address to, uint256 value) public returns (bool) {
310         _transfer(msg.sender, to, value);
311         return true;
312     }
313 
314     /**
315      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
316      * Beware that changing an allowance with this method brings the risk that someone may use both the old
317      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
318      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
319      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
320      * @param spender The address which will spend the funds.
321      * @param value The amount of tokens to be spent.
322      */
323     function approve(address spender, uint256 value) public returns (bool) {
324         require(spender != address(0));
325 
326         _allowed[msg.sender][spender] = value;
327         emit Approval(msg.sender, spender, value);
328         return true;
329     }
330 
331     /**
332      * @dev Transfer tokens from one address to another.
333      * Note that while this function emits an Approval event, this is not required as per the specification,
334      * and other compliant implementations may not emit the event.
335      * @param from address The address which you want to send tokens from
336      * @param to address The address which you want to transfer to
337      * @param value uint256 the amount of tokens to be transferred
338      */
339     function transferFrom(address from, address to, uint256 value) public returns (bool) {
340         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
341         _transfer(from, to, value);
342         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
343         return true;
344     }
345 
346     /**
347      * @dev Increase the amount of tokens that an owner allowed to a spender.
348      * approve should be called when allowed_[_spender] == 0. To increment
349      * allowed value is better to use this function to avoid 2 calls (and wait until
350      * the first transaction is mined)
351      * From MonolithDAO Token.sol
352      * Emits an Approval event.
353      * @param spender The address which will spend the funds.
354      * @param addedValue The amount of tokens to increase the allowance by.
355      */
356     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
357         require(spender != address(0));
358 
359         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
360         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
361         return true;
362     }
363 
364     /**
365      * @dev Decrease the amount of tokens that an owner allowed to a spender.
366      * approve should be called when allowed_[_spender] == 0. To decrement
367      * allowed value is better to use this function to avoid 2 calls (and wait until
368      * the first transaction is mined)
369      * From MonolithDAO Token.sol
370      * Emits an Approval event.
371      * @param spender The address which will spend the funds.
372      * @param subtractedValue The amount of tokens to decrease the allowance by.
373      */
374     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
375         require(spender != address(0));
376 
377         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
378         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
379         return true;
380     }
381 
382     /**
383     * @dev Transfer token for a specified addresses
384     * @param from The address to transfer from.
385     * @param to The address to transfer to.
386     * @param value The amount to be transferred.
387     */
388     function _transfer(address from, address to, uint256 value) internal {
389         require(to != address(0));
390 
391         _balances[from] = _balances[from].sub(value);
392         _balances[to] = _balances[to].add(value);
393         emit Transfer(from, to, value);
394     }
395 
396     /**
397      * @dev Internal function that mints an amount of the token and assigns it to
398      * an account. This encapsulates the modification of balances such that the
399      * proper events are emitted.
400      * @param account The account that will receive the created tokens.
401      * @param value The amount that will be created.
402      */
403     function _mint(address account, uint256 value) internal {
404         require(account != address(0));
405 
406         _totalSupply = _totalSupply.add(value);
407         _balances[account] = _balances[account].add(value);
408         emit Transfer(address(0), account, value);
409     }
410 
411     /**
412      * @dev Internal function that burns an amount of the token of a given
413      * account.
414      * @param account The account whose tokens will be burnt.
415      * @param value The amount that will be burnt.
416      */
417     function _burn(address account, uint256 value) internal {
418         require(account != address(0));
419 
420         _totalSupply = _totalSupply.sub(value);
421         _balances[account] = _balances[account].sub(value);
422         emit Transfer(account, address(0), value);
423     }
424 
425     /**
426      * @dev Internal function that burns an amount of the token of a given
427      * account, deducting from the sender's allowance for said account. Uses the
428      * internal burn function.
429      * Emits an Approval event (reflecting the reduced allowance).
430      * @param account The account whose tokens will be burnt.
431      * @param value The amount that will be burnt.
432      */
433     function _burnFrom(address account, uint256 value) internal {
434         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
435         _burn(account, value);
436         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
437     }
438 }
439  
440 
441 
442 
443 
444 /**
445  * @title ERC20Detailed token
446  * @dev The decimals are only for visualization purposes.
447  * All the operations are done using the smallest and indivisible token unit,
448  * just as on Ethereum all the operations are done in wei.
449  */
450 contract ERC20Detailed is IERC20 {
451     string private _name;
452     string private _symbol;
453     uint8 private _decimals;
454 
455     constructor (string memory name, string memory symbol, uint8 decimals) public {
456         _name = name;
457         _symbol = symbol;
458         _decimals = decimals;
459     }
460 
461     /**
462      * @return the name of the token.
463      */
464     function name() public view returns (string memory) {
465         return _name;
466     }
467 
468     /**
469      * @return the symbol of the token.
470      */
471     function symbol() public view returns (string memory) {
472         return _symbol;
473     }
474 
475     /**
476      * @return the number of decimals of the token.
477      */
478     function decimals() public view returns (uint8) {
479         return _decimals;
480     }
481 }
482  
483 
484 
485 
486 
487 
488 /**
489  * @title ERC20Mintable
490  * @dev ERC20 minting logic
491  */
492 contract ERC20Mintable is ERC20, MinterRole {
493     /**
494      * @dev Function to mint tokens
495      * @param to The address that will receive the minted tokens.
496      * @param value The amount of tokens to mint.
497      * @return A boolean that indicates if the operation was successful.
498      */
499     function mint(address to, uint256 value) public onlyMinter returns (bool) {
500         _mint(to, value);
501         return true;
502     }
503 }
504  
505 
506 
507 
508 
509 /**
510  * @title Capped token
511  * @dev Mintable token with a token cap.
512  */
513 contract ERC20Capped is ERC20Mintable {
514     uint256 private _cap;
515 
516     constructor (uint256 cap) public {
517         require(cap > 0);
518         _cap = cap;
519     }
520 
521     /**
522      * @return the cap for the token minting.
523      */
524     function cap() public view returns (uint256) {
525         return _cap;
526     }
527 
528     function _mint(address account, uint256 value) internal {
529         require(totalSupply().add(value) <= _cap);
530         super._mint(account, value);
531     }
532 }
533  
534 
535 contract PictosisGenesisToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Capped {
536     address public exchangeContract;
537 
538     constructor()
539         ERC20Capped(125000000000000000000000000)
540         ERC20Mintable()
541         ERC20Detailed("Pictosis Genesis Token", "PICTO-G", 18)
542         ERC20()
543         public
544     {
545     }
546 
547     function burnFrom(address from, uint256 value) public onlyMinter {
548         _burnFrom(from, value);
549     }
550 
551     function setExchangeContract(address _exchangeContract) public onlyMinter {
552         exchangeContract = _exchangeContract;
553     }
554 
555     function completeExchange(address from) public {
556         require(msg.sender == exchangeContract && exchangeContract != address(0), "Only the exchange contract can invoke this function");
557         _burnFrom(from, balanceOf(from));
558     }
559 
560     function transfer(address to, uint256 value) public returns (bool) {
561         revert("Token can only be exchanged for PICTO tokens in the exchange contract");
562     }
563 
564     uint256 constant D160 = 0x0010000000000000000000000000000000000000000;
565 
566     // data is an array of uint256s. Each uint256 represents a transfer.
567     // The 160 LSB is the destination of the address that wants to be sent
568     // The 96 MSB is the amount of tokens that wants to be sent.
569     // i.e. assume we want to mint 1200 tokens for address 0xABCDEFAABBCCDDEEFF1122334455667788990011
570     // 1200 in hex: 0x0000410d586a20a4c00000. Concatenate this value and the address
571     // ["0x0000410d586a20a4c00000ABCDEFAABBCCDDEEFF1122334455667788990011"]
572     function multiMint(uint256[] memory data) public onlyMinter {
573         for (uint256 i = 0; i < data.length; i++) {
574             address addr = address(data[i] & (D160 - 1));
575             uint256 amount = data[i] / D160;
576             _mint(addr, amount);
577         }
578     }
579 
580     /// @notice This method can be used by the minter to extract mistakenly
581     ///  sent tokens to this contract.
582     /// @param _token The address of the token contract that you want to recover
583     ///  set to 0x0000...0000 in case you want to extract ether.
584     function claimTokens(address _token) public onlyMinter {
585         if (_token == address(0)) {
586             msg.sender.transfer(address(this).balance);
587             return;
588         }
589 
590         ERC20 token = ERC20(_token);
591         uint256 balance = token.balanceOf(address(this));
592         token.transfer(msg.sender, balance);
593         emit ClaimedTokens(_token, msg.sender, balance);
594     }
595 
596     event ClaimedTokens(address indexed _token, address indexed _sender, uint256 _amount);
597 
598 }