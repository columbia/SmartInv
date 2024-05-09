1 pragma solidity 0.4.24;
2 
3 // File: contracts/commons/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/flavours/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions". It has two-stage ownership transfer.
75  */
76 contract Ownable {
77 
78     address public owner;
79     address public pendingOwner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91     /**
92      * @dev Throws if called by any account other than the owner.
93      */
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyPendingOwner() {
103         require(msg.sender == pendingOwner);
104         _;
105     }
106 
107     /**
108      * @dev Allows the current owner to prepare transfer control of the contract to a newOwner.
109      * @param newOwner The address to transfer ownership to.
110      */
111     function transferOwnership(address newOwner) public onlyOwner {
112         require(newOwner != address(0));
113         pendingOwner = newOwner;
114     }
115 
116     /**
117      * @dev Allows the pendingOwner address to finalize the transfer.
118      */
119     function claimOwnership() public onlyPendingOwner {
120         emit OwnershipTransferred(owner, pendingOwner);
121         owner = pendingOwner;
122         pendingOwner = address(0);
123     }
124 }
125 
126 // File: contracts/flavours/Lockable.sol
127 
128 /**
129  * @title Lockable
130  * @dev Base contract which allows children to
131  *      implement main operations locking mechanism.
132  */
133 contract Lockable is Ownable {
134     event Lock();
135     event Unlock();
136 
137     bool public locked = false;
138 
139     /**
140      * @dev Modifier to make a function callable
141     *       only when the contract is not locked.
142      */
143     modifier whenNotLocked() {
144         require(!locked);
145         _;
146     }
147 
148     /**
149      * @dev Modifier to make a function callable
150      *      only when the contract is locked.
151      */
152     modifier whenLocked() {
153         require(locked);
154         _;
155     }
156 
157     /**
158      * @dev called by the owner to locke, triggers locked state
159      */
160     function lock() public onlyOwner whenNotLocked {
161         locked = true;
162         emit Lock();
163     }
164 
165     /**
166      * @dev called by the owner
167      *      to unlock, returns to unlocked state
168      */
169     function unlock() public onlyOwner whenLocked {
170         locked = false;
171         emit Unlock();
172     }
173 }
174 
175 // File: contracts/base/BaseFixedERC20Token.sol
176 
177 contract BaseFixedERC20Token is Lockable {
178     using SafeMath for uint;
179 
180     /// @dev ERC20 Total supply
181     uint public totalSupply;
182 
183     mapping(address => uint) public balances;
184 
185     mapping(address => mapping(address => uint)) private allowed;
186 
187     /// @dev Fired if token is transferred according to ERC20 spec
188     event Transfer(address indexed from, address indexed to, uint value);
189 
190     /// @dev Fired if token withdrawal is approved according to ERC20 spec
191     event Approval(address indexed owner, address indexed spender, uint value);
192 
193     /**
194      * @dev Gets the balance of the specified address
195      * @param owner_ The address to query the the balance of
196      * @return An uint representing the amount owned by the passed address
197      */
198     function balanceOf(address owner_) public view returns (uint balance) {
199         return balances[owner_];
200     }
201 
202     /**
203      * @dev Transfer token for a specified address
204      * @param to_ The address to transfer to.
205      * @param value_ The amount to be transferred.
206      */
207     function transfer(address to_, uint value_) public whenNotLocked returns (bool) {
208         require(to_ != address(0) && value_ <= balances[msg.sender]);
209         // SafeMath.sub will throw an exception if there is not enough balance
210         balances[msg.sender] = balances[msg.sender].sub(value_);
211         balances[to_] = balances[to_].add(value_);
212         emit Transfer(msg.sender, to_, value_);
213         return true;
214     }
215 
216     /**
217      * @dev Transfer tokens from one address to another
218      * @param from_ address The address which you want to send tokens from
219      * @param to_ address The address which you want to transfer to
220      * @param value_ uint the amount of tokens to be transferred
221      */
222     function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {
223         require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);
224         balances[from_] = balances[from_].sub(value_);
225         balances[to_] = balances[to_].add(value_);
226         allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);
227         emit Transfer(from_, to_, value_);
228         return true;
229     }
230 
231     /**
232      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
233      *
234      * Beware that changing an allowance with this method brings the risk that someone may use both the old
235      * and the new allowance by unfortunate transaction ordering
236      *
237      * To change the approve amount you first have to reduce the addresses
238      * allowance to zero by calling `approve(spender_, 0)` if it is not
239      * already 0 to mitigate the race condition described in:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      *
242      * @param spender_ The address which will spend the funds.
243      * @param value_ The amount of tokens to be spent.
244      */
245     function approve(address spender_, uint value_) public whenNotLocked returns (bool) {
246         if (value_ != 0 && allowed[msg.sender][spender_] != 0) {
247             revert();
248         }
249         allowed[msg.sender][spender_] = value_;
250         emit Approval(msg.sender, spender_, value_);
251         return true;
252     }
253 
254     /**
255      * @dev Function to check the amount of tokens that an owner allowed to a spender
256      * @param owner_ address The address which owns the funds
257      * @param spender_ address The address which will spend the funds
258      * @return A uint specifying the amount of tokens still available for the spender
259      */
260     function allowance(address owner_, address spender_) public view returns (uint) {
261         return allowed[owner_][spender_];
262     }
263 }
264 
265 // File: contracts/flavours/SelfDestructible.sol
266 
267 /**
268  * @title SelfDestructible
269  * @dev The SelfDestructible contract has an owner address, and provides selfDestruct method
270  * in case of deployment error.
271  */
272 contract SelfDestructible is Ownable {
273 
274     function selfDestruct(uint8 v, bytes32 r, bytes32 s) public onlyOwner {
275         if (ecrecover(prefixedHash(), v, r, s) != owner) {
276             revert();
277         }
278         selfdestruct(owner);
279     }
280 
281     function originalHash() internal view returns (bytes32) {
282         return keccak256(abi.encodePacked(
283                 "Signed for Selfdestruct",
284                 address(this),
285                 msg.sender
286             ));
287     }
288 
289     function prefixedHash() internal view returns (bytes32) {
290         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
291         return keccak256(abi.encodePacked(prefix, originalHash()));
292     }
293 }
294 
295 // File: contracts/interface/ERC20Token.sol
296 
297 interface ERC20Token {
298     function transferFrom(address from_, address to_, uint value_) external returns (bool);
299     function transfer(address to_, uint value_) external returns (bool);
300     function balanceOf(address owner_) external returns (uint);
301 }
302 
303 // File: contracts/flavours/Withdrawal.sol
304 
305 /**
306  * @title Withdrawal
307  * @dev The Withdrawal contract has an owner address, and provides method for withdraw funds and tokens, if any
308  */
309 contract Withdrawal is Ownable {
310 
311     // withdraw funds, if any, only for owner
312     function withdraw() public onlyOwner {
313         owner.transfer(address(this).balance);
314     }
315 
316     // withdraw stuck tokens, if any, only for owner
317     function withdrawTokens(address _someToken) public onlyOwner {
318         ERC20Token someToken = ERC20Token(_someToken);
319         uint balance = someToken.balanceOf(address(this));
320         someToken.transfer(owner, balance);
321     }
322 }
323 
324 // File: contracts/SNPCToken.sol
325 
326 /**
327  * @title SNPC token contract.
328  */
329 contract SNPCToken is BaseFixedERC20Token, SelfDestructible, Withdrawal {
330     using SafeMath for uint;
331 
332     string public constant name = "SnapCoin";
333 
334     string public constant symbol = "SNPC";
335 
336     uint8 public constant decimals = 18;
337 
338     uint internal constant ONE_TOKEN = 1e18;
339 
340     /// @dev team reserved balances
341     mapping(address => uint) public teamReservedBalances;
342 
343     uint public teamReservedUnlockAt;
344 
345     /// @dev bounty reserved balances
346     mapping(address => uint) public bountyReservedBalances;
347 
348     uint public bountyReservedUnlockAt;
349 
350     /// @dev Fired some tokens distributed to someone from staff,business
351     event ReservedTokensDistributed(address indexed to, uint8 group, uint amount);
352 
353     event TokensBurned(uint amount);
354 
355     constructor(uint totalSupplyTokens_,
356             uint teamTokens_,
357             uint bountyTokens_,
358             uint advisorsTokens_,
359             uint reserveTokens_,
360             uint stackingBonusTokens_) public {
361         locked = true;
362         totalSupply = totalSupplyTokens_.mul(ONE_TOKEN);
363         uint availableSupply = totalSupply;
364 
365         reserved[RESERVED_TEAM_GROUP] = teamTokens_.mul(ONE_TOKEN);
366         reserved[RESERVED_BOUNTY_GROUP] = bountyTokens_.mul(ONE_TOKEN);
367         reserved[RESERVED_ADVISORS_GROUP] = advisorsTokens_.mul(ONE_TOKEN);
368         reserved[RESERVED_RESERVE_GROUP] = reserveTokens_.mul(ONE_TOKEN);
369         reserved[RESERVED_STACKING_BONUS_GROUP] = stackingBonusTokens_.mul(ONE_TOKEN);
370         availableSupply = availableSupply
371             .sub(reserved[RESERVED_TEAM_GROUP])
372             .sub(reserved[RESERVED_BOUNTY_GROUP])
373             .sub(reserved[RESERVED_ADVISORS_GROUP])
374             .sub(reserved[RESERVED_RESERVE_GROUP])
375             .sub(reserved[RESERVED_STACKING_BONUS_GROUP]);
376         teamReservedUnlockAt = block.timestamp + 365 days; // 1 year
377         bountyReservedUnlockAt = block.timestamp + 91 days; // 3 month
378 
379         balances[owner] = availableSupply;
380         emit Transfer(0, address(this), availableSupply);
381         emit Transfer(address(this), owner, balances[owner]);
382     }
383 
384     // Disable direct payments
385     function() external payable {
386         revert();
387     }
388 
389     function burnTokens(uint amount) public {
390         require(balances[msg.sender] >= amount);
391         totalSupply = totalSupply.sub(amount);
392         balances[msg.sender] = balances[msg.sender].sub(amount);
393 
394         emit TokensBurned(amount);
395     }
396 
397     // --------------- Reserve specific
398     uint8 public constant RESERVED_TEAM_GROUP = 0x1;
399 
400     uint8 public constant RESERVED_BOUNTY_GROUP = 0x2;
401 
402     uint8 public constant RESERVED_ADVISORS_GROUP = 0x4;
403 
404     uint8 public constant RESERVED_RESERVE_GROUP = 0x8;
405 
406     uint8 public constant RESERVED_STACKING_BONUS_GROUP = 0x10;
407 
408     /// @dev Token reservation mapping: key(RESERVED_X) => value(number of tokens)
409     mapping(uint8 => uint) public reserved;
410 
411     /**
412      * @dev Get reserved tokens for specific group
413      */
414     function getReservedTokens(uint8 group_) public view returns (uint) {
415         return reserved[group_];
416     }
417 
418     /**
419      * @dev Assign `amount_` of privately distributed tokens
420      *      to someone identified with `to_` address.
421      * @param to_   Tokens owner
422      * @param group_ Group identifier of privately distributed tokens
423      * @param amount_ Number of tokens distributed with decimals part
424      */
425     function assignReserved(address to_, uint8 group_, uint amount_) public onlyOwner {
426         require(to_ != address(0) && (group_ & 0x1F) != 0);
427 
428         // SafeMath will check reserved[group_] >= amount
429         reserved[group_] = reserved[group_].sub(amount_);
430         balances[to_] = balances[to_].add(amount_);
431         if (group_ == RESERVED_TEAM_GROUP) {
432             teamReservedBalances[to_] = teamReservedBalances[to_].add(amount_);
433         } else if (group_ == RESERVED_BOUNTY_GROUP) {
434             bountyReservedBalances[to_] = bountyReservedBalances[to_].add(amount_);
435         }
436         emit ReservedTokensDistributed(to_, group_, amount_);
437     }
438 
439     /**
440      * @dev Gets the balance of team reserved tokens the specified address.
441      * @param owner_ The address to query the the balance of.
442      * @return An uint representing the amount owned by the passed address.
443      */
444     function teamReservedBalanceOf(address owner_) public view returns (uint) {
445         return teamReservedBalances[owner_];
446     }
447 
448     /**
449      * @dev Gets the balance of bounty reserved tokens the specified address.
450      * @param owner_ The address to query the the balance of.
451      * @return An uint representing the amount owned by the passed address.
452      */
453     function bountyReservedBalanceOf(address owner_) public view returns (uint) {
454         return bountyReservedBalances[owner_];
455     }
456 
457     function getAllowedForTransferTokens(address from_) public view returns (uint) {
458         uint allowed = balances[from_];
459 
460         if (teamReservedBalances[from_] > 0) {
461             if (block.timestamp < teamReservedUnlockAt) {
462                 allowed = allowed.sub(teamReservedBalances[from_]);
463             }
464         }
465 
466         if (bountyReservedBalances[from_] > 0) {
467             if (block.timestamp < bountyReservedUnlockAt) {
468                 allowed = allowed.sub(bountyReservedBalances[from_]);
469             }
470         }
471 
472         return allowed;
473     }
474 
475     function transfer(address to_, uint value_) public whenNotLocked returns (bool) {
476         require(value_ <= getAllowedForTransferTokens(msg.sender));
477         return super.transfer(to_, value_);
478     }
479 
480     function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {
481         require(value_ <= getAllowedForTransferTokens(from_));
482         return super.transferFrom(from_, to_, value_);
483     }
484 
485 }