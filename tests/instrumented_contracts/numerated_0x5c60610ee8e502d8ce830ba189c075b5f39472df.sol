1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
82 
83 pragma solidity >=0.6.0 <0.8.0;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 // File: openzeppelin-solidity/contracts/GSN/Context.sol
242 
243 pragma solidity >=0.6.0 <0.8.0;
244 
245 /*
246  * @dev Provides information about the current execution context, including the
247  * sender of the transaction and its data. While these are generally available
248  * via msg.sender and msg.data, they should not be accessed in such a direct
249  * manner, since when dealing with GSN meta-transactions the account sending and
250  * paying for execution may not be the actual sender (as far as an application
251  * is concerned).
252  *
253  * This contract is only required for intermediate, library-like contracts.
254  */
255 abstract contract Context {
256     function _msgSender() internal view virtual returns (address payable) {
257         return msg.sender;
258     }
259 
260     function _msgData() internal view virtual returns (bytes memory) {
261         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
262         return msg.data;
263     }
264 }
265 
266 // File: openzeppelin-solidity/contracts/access/Ownable.sol
267 
268 pragma solidity >=0.6.0 <0.8.0;
269 
270 /**
271  * @dev Contract module which provides a basic access control mechanism, where
272  * there is an account (an owner) that can be granted exclusive access to
273  * specific functions.
274  *
275  * By default, the owner account will be the one that deploys the contract. This
276  * can later be changed with {transferOwnership}.
277  *
278  * This module is used through inheritance. It will make available the modifier
279  * `onlyOwner`, which can be applied to your functions to restrict their use to
280  * the owner.
281  */
282 abstract contract Ownable is Context {
283     address private _owner;
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287     /**
288      * @dev Initializes the contract setting the deployer as the initial owner.
289      */
290     constructor () internal {
291         address msgSender = _msgSender();
292         _owner = msgSender;
293         emit OwnershipTransferred(address(0), msgSender);
294     }
295 
296     /**
297      * @dev Returns the address of the current owner.
298      */
299     function owner() public view returns (address) {
300         return _owner;
301     }
302 
303     /**
304      * @dev Throws if called by any account other than the owner.
305      */
306     modifier onlyOwner() {
307         require(_owner == _msgSender(), "Ownable: caller is not the owner");
308         _;
309     }
310 
311     /**
312      * @dev Leaves the contract without owner. It will not be possible to call
313      * `onlyOwner` functions anymore. Can only be called by the current owner.
314      *
315      * NOTE: Renouncing ownership will leave the contract without an owner,
316      * thereby removing any functionality that is only available to the owner.
317      */
318     function renounceOwnership() public virtual onlyOwner {
319         emit OwnershipTransferred(_owner, address(0));
320         _owner = address(0);
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Can only be called by the current owner.
326      */
327     function transferOwnership(address newOwner) public virtual onlyOwner {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331     }
332 }
333 
334 // File: contracts/PolyLocker.sol
335 
336 pragma solidity 0.7.6;
337 
338 // Requirements
339 
340 // Any POLY holder can lock POLY (Issuers, Investors, WL, Polymath Founders, etc.)
341 // The amount of POLY to be locked must be >=1, otherwise, fail with insufficient funds
342 // There is no max limit on how much POLY can be locked
343 // POLY will be locked forever, no one can unlock it (ignore the upgradable contract bit)
344 // Granularity for locked POLY should be restricted to Polymesh granularity (10^6)
345 // User must provide their Mesh address when locking POLY
346 // Emit an event for locked POLY including Mesh address & timestamp
347 // Mesh address must be of valid length
348 
349 
350 
351 
352 /**
353  * @title Contract used to lock POLY corresponds to locked amount user can claim same
354  * amount of POLY on Polymesh blockchain
355  */
356 contract PolyLocker is Ownable {
357     using SafeMath for uint256;
358 
359     // Tracks the total no. of events emitted by the contract.
360     uint256 public noOfeventsEmitted;
361 
362     // Address of the token that is locked by the contract. i.e. PolyToken contract address.
363     IERC20 public immutable polyToken;
364 
365     // Controls if locking Poly is frozen.
366     bool public frozen;
367 
368     // Granularity Polymesh blockchain in 10^6 but it's 10^18 on Ethereum.
369     // This is used to truncate 18 decimal places to 6.
370     uint256 constant public TRUNCATE_SCALE = 10 ** 12;
371 
372     // Valid address length of Polymesh blockchain.
373     uint256 constant public VALID_ADDRESS_LENGTH = 48;
374 
375     uint256 constant internal E18 = uint256(10) ** 18;
376 
377     // Emit an event when the poly gets lock
378     event PolyLocked(uint256 indexed _id, address indexed _holder, string _meshAddress, uint256 _polymeshBalance, uint256 _polyTokenBalance);
379     // Emitted when locking is frozen
380     event Frozen();
381     // Emitted when locking is unfrozen
382     event Unfrozen();
383 
384 
385     constructor(address _polyToken) public {
386         require(_polyToken != address(0), "Invalid address");
387         polyToken = IERC20(_polyToken);
388     }
389 
390     /**
391      * @notice Used for freezing locking of POLY token
392      */
393     function freezeLocking() external onlyOwner {
394         require(!frozen, "Already frozen");
395         frozen = true;
396         emit Frozen();
397     }
398 
399     /**
400      * @notice Used for unfreezing locking of POLY token
401      */
402     function unfreezeLocking() external onlyOwner {
403         require(frozen, "Already unfrozen");
404         frozen = false;
405         emit Unfrozen();
406     }
407 
408     /**
409      * @notice used to set the nonce
410      * @param _newNonce New nonce to set with the contract
411      */
412     function setEventsNonce(uint256 _newNonce) external onlyOwner {
413         noOfeventsEmitted = _newNonce;
414     }
415 
416     /**
417      * @notice Used for locking the POLY token
418      * @param _meshAddress Address that compatible the Polymesh blockchain
419      */
420     function lock(string calldata _meshAddress) external {
421         _lock(_meshAddress, msg.sender, polyToken.balanceOf(msg.sender));
422     }
423 
424     /**
425      * @notice Used for locking the POLY token
426      * @param _meshAddress Address that compatible the Polymesh blockchain
427      * @param _lockedValue Amount of tokens need to locked
428      */
429     function limitLock(string calldata _meshAddress, uint256 _lockedValue) external {
430         _lock(_meshAddress, msg.sender, _lockedValue);
431     }
432 
433     function _lock(string memory _meshAddress, address _holder, uint256 _polyAmount) internal {
434         // Make sure locking is not frozen
435         require(!frozen, "Locking frozen");
436         // Validate the MESH address
437         require(bytes(_meshAddress).length == VALID_ADDRESS_LENGTH, "Invalid length of mesh address");
438 
439         // Make sure the minimum `_polyAmount` is 1.
440         require(_polyAmount >= E18, "Insufficient amount");
441 
442         // Polymesh balances have 6 decimal places.
443         // 1 POLY on Ethereum has 18 decimal places. 1 POLYX on Polymesh has 6 decimal places.
444         // i.e. 10^18 POLY = 10^6 POLYX.
445         uint256 polymeshBalance = _polyAmount / TRUNCATE_SCALE;
446         _polyAmount = polymeshBalance * TRUNCATE_SCALE;
447 
448         // Transfer funds to this contract.
449         require(polyToken.transferFrom(_holder, address(this), _polyAmount), "Insufficient allowance");
450         uint256 cachedNoOfeventsEmitted = noOfeventsEmitted + 1;  // Caching number of events in memory, saves 1 SLOAD.
451         noOfeventsEmitted = cachedNoOfeventsEmitted;              // Increment the event counter in storage.
452 
453         // The event does not need to contain both `polymeshBalance` and `_polyAmount` as one can be derived from other.
454         // However, we are still keeping them for easier integrations.
455         emit PolyLocked(cachedNoOfeventsEmitted, _holder, _meshAddress, polymeshBalance, _polyAmount);
456     }
457 }