1 pragma solidity ^0.5.10;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
115  * the optional functions; to access them see `ERC20Detailed`.
116  */
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127 
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a `Transfer` event.
134      */
135     function transfer(address recipient, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Returns the remaining number of tokens that `spender` will be
139      * allowed to spend on behalf of `owner` through `transferFrom`. This is
140      * zero by default.
141      *
142      * This value changes when `approve` or `transferFrom` are called.
143      */
144     function allowance(address owner, address spender) external view returns (uint256);
145 
146     /**
147      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * > Beware that changing an allowance with this method brings the risk
152      * that someone may use both the old and the new allowance by unfortunate
153      * transaction ordering. One possible solution to mitigate this race
154      * condition is to first reduce the spender's allowance to 0 and set the
155      * desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      *
158      * Emits an `Approval` event.
159      */
160     function approve(address spender, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Moves `amount` tokens from `sender` to `recipient` using the
164      * allowance mechanism. `amount` is then deducted from the caller's
165      * allowance.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a `Transfer` event.
170      */
171     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to `approve`. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
189 
190 /**
191  * @dev Contract module which provides a basic access control mechanism, where
192  * there is an account (an owner) that can be granted exclusive access to
193  * specific functions.
194  *
195  * This module is used through inheritance. It will make available the modifier
196  * `onlyOwner`, which can be aplied to your functions to restrict their use to
197  * the owner.
198  */
199 contract Ownable {
200     address private _owner;
201 
202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204     /**
205      * @dev Initializes the contract setting the deployer as the initial owner.
206      */
207     constructor () internal {
208         _owner = msg.sender;
209         emit OwnershipTransferred(address(0), _owner);
210     }
211 
212     /**
213      * @dev Returns the address of the current owner.
214      */
215     function owner() public view returns (address) {
216         return _owner;
217     }
218 
219     /**
220      * @dev Throws if called by any account other than the owner.
221      */
222     modifier onlyOwner() {
223         require(isOwner(), "Ownable: caller is not the owner");
224         _;
225     }
226 
227     /**
228      * @dev Returns true if the caller is the current owner.
229      */
230     function isOwner() public view returns (bool) {
231         return msg.sender == _owner;
232     }
233 
234     /**
235      * @dev Leaves the contract without owner. It will not be possible to call
236      * `onlyOwner` functions anymore. Can only be called by the current owner.
237      *
238      * > Note: Renouncing ownership will leave the contract without an owner,
239      * thereby removing any functionality that is only available to the owner.
240      */
241     function renounceOwnership() public onlyOwner {
242         emit OwnershipTransferred(_owner, address(0));
243         _owner = address(0);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Can only be called by the current owner.
249      */
250     function transferOwnership(address newOwner) public onlyOwner {
251         _transferOwnership(newOwner);
252     }
253 
254     /**
255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
256      */
257     function _transferOwnership(address newOwner) internal {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         emit OwnershipTransferred(_owner, newOwner);
260         _owner = newOwner;
261     }
262 }
263 
264 // File: eth-token-recover/contracts/TokenRecover.sol
265 
266 /**
267  * @title TokenRecover
268  * @author Vittorio Minacori (https://github.com/vittominacori)
269  * @dev Allow to recover any ERC20 sent into the contract for error
270  */
271 contract TokenRecover is Ownable {
272 
273     /**
274      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
275      * @param tokenAddress The token contract address
276      * @param tokenAmount Number of tokens to be sent
277      */
278     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
279         IERC20(tokenAddress).transfer(owner(), tokenAmount);
280     }
281 }
282 
283 // File: openzeppelin-solidity/contracts/access/Roles.sol
284 
285 /**
286  * @title Roles
287  * @dev Library for managing addresses assigned to a Role.
288  */
289 library Roles {
290     struct Role {
291         mapping (address => bool) bearer;
292     }
293 
294     /**
295      * @dev Give an account access to this role.
296      */
297     function add(Role storage role, address account) internal {
298         require(!has(role, account), "Roles: account already has role");
299         role.bearer[account] = true;
300     }
301 
302     /**
303      * @dev Remove an account's access to this role.
304      */
305     function remove(Role storage role, address account) internal {
306         require(has(role, account), "Roles: account does not have role");
307         role.bearer[account] = false;
308     }
309 
310     /**
311      * @dev Check if an account has this role.
312      * @return bool
313      */
314     function has(Role storage role, address account) internal view returns (bool) {
315         require(account != address(0), "Roles: account is the zero address");
316         return role.bearer[account];
317     }
318 }
319 
320 // File: contracts/access/roles/OperatorRole.sol
321 
322 contract OperatorRole {
323     using Roles for Roles.Role;
324 
325     event OperatorAdded(address indexed account);
326     event OperatorRemoved(address indexed account);
327 
328     Roles.Role private _operators;
329 
330     constructor() internal {
331         _addOperator(msg.sender);
332     }
333 
334     modifier onlyOperator() {
335         require(isOperator(msg.sender));
336         _;
337     }
338 
339     function isOperator(address account) public view returns (bool) {
340         return _operators.has(account);
341     }
342 
343     function addOperator(address account) public onlyOperator {
344         _addOperator(account);
345     }
346 
347     function renounceOperator() public {
348         _removeOperator(msg.sender);
349     }
350 
351     function _addOperator(address account) internal {
352         _operators.add(account);
353         emit OperatorAdded(account);
354     }
355 
356     function _removeOperator(address account) internal {
357         _operators.remove(account);
358         emit OperatorRemoved(account);
359     }
360 }
361 
362 // File: contracts/utils/Contributions.sol
363 
364 /**
365  * @title Contributions
366  * @author Vittorio Minacori (https://github.com/vittominacori)
367  * @dev Utility contract where to save any information about Crowdsale contributions
368  */
369 contract Contributions is OperatorRole, TokenRecover {
370     using SafeMath for uint256;
371 
372     struct Contributor {
373         uint256 weiAmount;
374         uint256 tokenAmount;
375         bool exists;
376     }
377 
378     // the number of sold tokens
379     uint256 private _totalSoldTokens;
380 
381     // the number of wei raised
382     uint256 private _totalWeiRaised;
383 
384     // list of addresses who contributed in crowdsales
385     address[] private _addresses;
386 
387     // map of contributors
388     mapping(address => Contributor) private _contributors;
389 
390     constructor() public {} // solhint-disable-line no-empty-blocks
391 
392     /**
393      * @return the number of sold tokens
394      */
395     function totalSoldTokens() public view returns (uint256) {
396         return _totalSoldTokens;
397     }
398 
399     /**
400      * @return the number of wei raised
401      */
402     function totalWeiRaised() public view returns (uint256) {
403         return _totalWeiRaised;
404     }
405 
406     /**
407      * @return address of a contributor by list index
408      */
409     function getContributorAddress(uint256 index) public view returns (address) {
410         return _addresses[index];
411     }
412 
413     /**
414      * @dev return the contributions length
415      * @return uint representing contributors number
416      */
417     function getContributorsLength() public view returns (uint) {
418         return _addresses.length;
419     }
420 
421     /**
422      * @dev get wei contribution for the given address
423      * @param account Address has contributed
424      * @return uint256
425      */
426     function weiContribution(address account) public view returns (uint256) {
427         return _contributors[account].weiAmount;
428     }
429 
430     /**
431      * @dev get token balance for the given address
432      * @param account Address has contributed
433      * @return uint256
434      */
435     function tokenBalance(address account) public view returns (uint256) {
436         return _contributors[account].tokenAmount;
437     }
438 
439     /**
440      * @dev check if a contributor exists
441      * @param account The address to check
442      * @return bool
443      */
444     function contributorExists(address account) public view returns (bool) {
445         return _contributors[account].exists;
446     }
447 
448     /**
449      * @dev add contribution into the contributions array
450      * @param account Address being contributing
451      * @param weiAmount Amount of wei contributed
452      * @param tokenAmount Amount of token received
453      */
454     function addBalance(address account, uint256 weiAmount, uint256 tokenAmount) public onlyOperator {
455         if (!_contributors[account].exists) {
456             _addresses.push(account);
457             _contributors[account].exists = true;
458         }
459 
460         _contributors[account].weiAmount = _contributors[account].weiAmount.add(weiAmount);
461         _contributors[account].tokenAmount = _contributors[account].tokenAmount.add(tokenAmount);
462 
463         _totalWeiRaised = _totalWeiRaised.add(weiAmount);
464         _totalSoldTokens = _totalSoldTokens.add(tokenAmount);
465     }
466 
467     /**
468      * @dev remove the `operator` role from address
469      * @param account Address you want to remove role
470      */
471     function removeOperator(address account) public onlyOwner {
472         _removeOperator(account);
473     }
474 }