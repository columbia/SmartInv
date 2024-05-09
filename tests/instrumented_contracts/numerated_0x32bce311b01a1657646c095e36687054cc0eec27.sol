1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations.
7  *
8  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
9  * now has built in overflow checking.
10  */
11 library SafeMath {
12     /**
13      * @dev Returns the addition of two unsigned integers, with an overflow flag.
14      *
15      * _Available since v3.4._
16      */
17     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {
19             uint256 c = a + b;
20             if (c < a) return (false, 0);
21             return (true, c);
22         }
23     }
24 
25     /**
26      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
27      *
28      * _Available since v3.4._
29      */
30     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {
32             if (b > a) return (false, 0);
33             return (true, a - b);
34         }
35     }
36 
37     /**
38      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
39      *
40      * _Available since v3.4._
41      */
42     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43         unchecked {
44             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
45             // benefit is lost if 'b' is also tested.
46             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
47             if (a == 0) return (true, 0);
48             uint256 c = a * b;
49             if (c / a != b) return (false, 0);
50             return (true, c);
51         }
52     }
53 
54     /**
55      * @dev Returns the division of two unsigned integers, with a division by zero flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         unchecked {
61             if (b == 0) return (false, 0);
62             return (true, a / b);
63         }
64     }
65 
66     /**
67      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         unchecked {
73             if (b == 0) return (false, 0);
74             return (true, a % b);
75         }
76     }
77 
78     /**
79      * @dev Returns the addition of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `+` operator.
83      *
84      * Requirements:
85      *
86      * - Addition cannot overflow.
87      */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         return a + b;
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      *
100      * - Subtraction cannot overflow.
101      */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         return a - b;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      *
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         return a * b;
118     }
119 
120     /**
121      * @dev Returns the integer division of two unsigned integers, reverting on
122      * division by zero. The result is rounded towards zero.
123      *
124      * Counterpart to Solidity's `/` operator.
125      *
126      * Requirements:
127      *
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a / b;
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * reverting when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         return a % b;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * CAUTION: This function is deprecated because it requires allocating memory for the error
155      * message unnecessarily. For custom revert reasons use {trySub}.
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(
164         uint256 a,
165         uint256 b,
166         string memory errorMessage
167     ) internal pure returns (uint256) {
168         unchecked {
169             require(b <= a, errorMessage);
170             return a - b;
171         }
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(
187         uint256 a,
188         uint256 b,
189         string memory errorMessage
190     ) internal pure returns (uint256) {
191         unchecked {
192             require(b > 0, errorMessage);
193             return a / b;
194         }
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(
213         uint256 a,
214         uint256 b,
215         string memory errorMessage
216     ) internal pure returns (uint256) {
217         unchecked {
218             require(b > 0, errorMessage);
219             return a % b;
220         }
221     }
222 }
223 
224 /**
225  * @dev Provides information about the current execution context, including the
226  * sender of the transaction and its data. While these are generally available
227  * via msg.sender and msg.data, they should not be accessed in such a direct
228  * manner, since when dealing with meta-transactions the account sending and
229  * paying for execution may not be the actual sender (as far as an application
230  * is concerned).
231  *
232  * This contract is only required for intermediate, library-like contracts.
233  */
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address) {
236         return msg.sender;
237     }
238 
239     function _msgData() internal view virtual returns (bytes calldata) {
240         return msg.data;
241     }
242 }
243 
244 /**
245  * @dev Interface of the ERC20 standard as defined in the EIP.
246  */
247 interface IERC20 {
248     /**
249      * @dev Returns the amount of tokens in existence.
250      */
251     function totalSupply() external view returns (uint256);
252 
253     /**
254      * @dev Returns the amount of tokens owned by `account`.
255      */
256     function balanceOf(address account) external view returns (uint256);
257 
258     /**
259      * @dev Moves `amount` tokens from the caller's account to `recipient`.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transfer(address recipient, uint256 amount) external returns (bool);
266 
267     /**
268      * @dev Returns the remaining number of tokens that `spender` will be
269      * allowed to spend on behalf of `owner` through {transferFrom}. This is
270      * zero by default.
271      *
272      * This value changes when {approve} or {transferFrom} are called.
273      */
274     function allowance(address owner, address spender) external view returns (uint256);
275 
276     /**
277      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * IMPORTANT: Beware that changing an allowance with this method brings the risk
282      * that someone may use both the old and the new allowance by unfortunate
283      * transaction ordering. One possible solution to mitigate this race
284      * condition is to first reduce the spender's allowance to 0 and set the
285      * desired value afterwards:
286      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287      *
288      * Emits an {Approval} event.
289      */
290     function approve(address spender, uint256 amount) external returns (bool);
291 
292     /**
293      * @dev Moves `amount` tokens from `sender` to `recipient` using the
294      * allowance mechanism. `amount` is then deducted from the caller's
295      * allowance.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transferFrom(
302         address sender,
303         address recipient,
304         uint256 amount
305     ) external returns (bool);
306 
307     /**
308      * @dev Emitted when `value` tokens are moved from one account (`from`) to
309      * another (`to`).
310      *
311      * Note that `value` may be zero.
312      */
313     event Transfer(address indexed from, address indexed to, uint256 value);
314 
315     /**
316      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
317      * a call to {approve}. `value` is the new allowance.
318      */
319     event Approval(address indexed owner, address indexed spender, uint256 value);
320 }
321 
322 /**
323  * @dev Contract module that helps prevent reentrant calls to a function.
324  *
325  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
326  * available, which can be applied to functions to make sure there are no nested
327  * (reentrant) calls to them.
328  *
329  * Note that because there is a single `nonReentrant` guard, functions marked as
330  * `nonReentrant` may not call one another. This can be worked around by making
331  * those functions `private`, and then adding `external` `nonReentrant` entry
332  * points to them.
333  *
334  * TIP: If you would like to learn more about reentrancy and alternative ways
335  * to protect against it, check out our blog post
336  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
337  */
338 abstract contract ReentrancyGuard {
339     // Booleans are more expensive than uint256 or any type that takes up a full
340     // word because each write operation emits an extra SLOAD to first read the
341     // slot's contents, replace the bits taken up by the boolean, and then write
342     // back. This is the compiler's defense against contract upgrades and
343     // pointer aliasing, and it cannot be disabled.
344 
345     // The values being non-zero value makes deployment a bit more expensive,
346     // but in exchange the refund on every call to nonReentrant will be lower in
347     // amount. Since refunds are capped to a percentage of the total
348     // transaction's gas, it is best to keep them low in cases like this one, to
349     // increase the likelihood of the full refund coming into effect.
350     uint256 private constant _NOT_ENTERED = 1;
351     uint256 private constant _ENTERED = 2;
352 
353     uint256 private _status;
354 
355     constructor() {
356         _status = _NOT_ENTERED;
357     }
358 
359     /**
360      * @dev Prevents a contract from calling itself, directly or indirectly.
361      * Calling a `nonReentrant` function from another `nonReentrant`
362      * function is not supported. It is possible to prevent this from happening
363      * by making the `nonReentrant` function external, and making it call a
364      * `private` function that does the actual work.
365      */
366     modifier nonReentrant() {
367         // On the first call to nonReentrant, _notEntered will be true
368         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
369 
370         // Any calls to nonReentrant after this point will fail
371         _status = _ENTERED;
372 
373         _;
374 
375         // By storing the original value once again, a refund is triggered (see
376         // https://eips.ethereum.org/EIPS/eip-2200)
377         _status = _NOT_ENTERED;
378     }
379 }
380 
381 /**
382  * @dev Contract module which provides a basic access control mechanism, where
383  * there is an account (an owner) that can be granted exclusive access to
384  * specific functions.
385  *
386  * By default, the owner account will be the one that deploys the contract. This
387  * can later be changed with {transferOwnership}.
388  *
389  * This module is used through inheritance. It will make available the modifier
390  * `onlyOwner`, which can be applied to your functions to restrict their use to
391  * the owner.
392  */
393 abstract contract Ownable is Context {
394     address private _owner;
395 
396     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
397 
398     /**
399      * @dev Initializes the contract setting the deployer as the initial owner.
400      */
401     constructor() {
402         _transferOwnership(_msgSender());
403     }
404 
405     /**
406      * @dev Returns the address of the current owner.
407      */
408     function owner() public view virtual returns (address) {
409         return _owner;
410     }
411 
412     /**
413      * @dev Throws if called by any account other than the owner.
414      */
415     modifier onlyOwner() {
416         require(owner() == _msgSender(), "Ownable: caller is not the owner");
417         _;
418     }
419 
420     /**
421      * @dev Transfers ownership of the contract to a new account (`newOwner`).
422      * Can only be called by the current owner.
423      */
424     function transferOwnership(address newOwner) public virtual onlyOwner {
425         require(newOwner != address(0), "Ownable: new owner is the zero address");
426         _transferOwnership(newOwner);
427     }
428 
429     /**
430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
431      * Internal function without access restriction.
432      */
433     function _transferOwnership(address newOwner) internal virtual {
434         address oldOwner = _owner;
435         _owner = newOwner;
436         emit OwnershipTransferred(oldOwner, newOwner);
437     }
438 }
439 
440 contract Token is Context, IERC20, Ownable {
441     using SafeMath for uint256;
442 
443     string private _name;
444     string private _symbol;
445     uint8 private _decimals;
446     uint256 private _totalSupply;
447     
448     mapping (address => uint256) private balances;
449     mapping (address => mapping (address => uint256)) private allowances;
450 
451     constructor (string memory __name, string memory __symbol,  uint8 __decimals, uint256 __amount) {
452         _name = __name;
453         _symbol = __symbol;
454         _decimals = __decimals;
455         _totalSupply = __amount * 10**_decimals;
456 
457         balances[_msgSender()] = _totalSupply;
458         emit Transfer(address(0), _msgSender(), _totalSupply);
459     }
460 
461     function name() public view returns (string memory) {
462         return _name;
463     }
464 
465     function symbol() public view returns (string memory) {
466         return _symbol;
467     }
468 
469     function decimals() public view returns (uint8) {
470         return _decimals;
471     }
472 
473     function totalSupply() public view override returns (uint256) {
474         return _totalSupply;
475     }
476 
477     function balanceOf(address account) public view override returns (uint256) {
478         return balances[account];
479     }
480 
481     function allowance(address owner_, address spender) public view override returns (uint256) {
482         return allowances[owner_][spender];
483     }
484 
485     function approve(address delegate, uint numTokens) public override returns (bool) {
486         require(numTokens <= balances[msg.sender]);
487     
488         allowances[msg.sender][delegate] = numTokens;
489         
490         emit Approval(msg.sender, delegate, numTokens);
491         
492         return true;
493     }
494 
495     function transfer(address receiver, uint numTokens) public override returns (bool) {
496         require(numTokens <= balances[msg.sender]);
497         
498         balances[msg.sender] = balances[msg.sender].sub(numTokens);
499         balances[receiver] = balances[receiver].add(numTokens);
500         
501         emit Transfer(msg.sender, receiver, numTokens);
502         
503         return true;
504     }
505 
506     function transferFrom(address owner, address buyer, uint numTokens) public override returns (bool) {
507         require(numTokens <= balances[owner]);    
508         require(numTokens <= allowances[owner][msg.sender]);
509     
510         balances[owner] = balances[owner].sub(numTokens);
511         allowances[owner][msg.sender] = allowances[owner][msg.sender].sub(numTokens);
512         balances[buyer] = balances[buyer].add(numTokens);
513         
514         emit Transfer(owner, buyer, numTokens);
515         
516         return true;
517     }
518 }