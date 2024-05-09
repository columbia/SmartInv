1 // Sources flattened with hardhat v2.3.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.1.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 // solhint-disable-next-line compiler-version
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
12  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
13  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
14  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
15  *
16  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
17  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
18  *
19  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
20  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
21  */
22 abstract contract Initializable {
23 
24     /**
25      * @dev Indicates that the contract has been initialized.
26      */
27     bool private _initialized;
28 
29     /**
30      * @dev Indicates that the contract is in the process of being initialized.
31      */
32     bool private _initializing;
33 
34     /**
35      * @dev Modifier to protect an initializer function from being invoked twice.
36      */
37     modifier initializer() {
38         require(_initializing || !_initialized, "Initializable: contract is already initialized");
39 
40         bool isTopLevelCall = !_initializing;
41         if (isTopLevelCall) {
42             _initializing = true;
43             _initialized = true;
44         }
45 
46         _;
47 
48         if (isTopLevelCall) {
49             _initializing = false;
50         }
51     }
52 }
53 
54 
55 // File @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol@v4.1.0
56 
57 pragma solidity ^0.8.0;
58 
59 /*
60  * @dev Provides information about the current execution context, including the
61  * sender of the transaction and its data. While these are generally available
62  * via msg.sender and msg.data, they should not be accessed in such a direct
63  * manner, since when dealing with meta-transactions the account sending and
64  * paying for execution may not be the actual sender (as far as an application
65  * is concerned).
66  *
67  * This contract is only required for intermediate, library-like contracts.
68  */
69 abstract contract ContextUpgradeable is Initializable {
70     function __Context_init() internal initializer {
71         __Context_init_unchained();
72     }
73 
74     function __Context_init_unchained() internal initializer {
75     }
76     function _msgSender() internal view virtual returns (address) {
77         return msg.sender;
78     }
79 
80     function _msgData() internal view virtual returns (bytes calldata) {
81         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
82         return msg.data;
83     }
84     uint256[50] private __gap;
85 }
86 
87 
88 // File @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol@v4.1.0
89 
90 pragma solidity ^0.8.0;
91 
92 
93 /**
94  * @dev Contract module which provides a basic access control mechanism, where
95  * there is an account (an owner) that can be granted exclusive access to
96  * specific functions.
97  *
98  * By default, the owner account will be the one that deploys the contract. This
99  * can later be changed with {transferOwnership}.
100  *
101  * This module is used through inheritance. It will make available the modifier
102  * `onlyOwner`, which can be applied to your functions to restrict their use to
103  * the owner.
104  */
105 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
106     address private _owner;
107 
108     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109 
110     /**
111      * @dev Initializes the contract setting the deployer as the initial owner.
112      */
113     function __Ownable_init() internal initializer {
114         __Context_init_unchained();
115         __Ownable_init_unchained();
116     }
117 
118     function __Ownable_init_unchained() internal initializer {
119         address msgSender = _msgSender();
120         _owner = msgSender;
121         emit OwnershipTransferred(address(0), msgSender);
122     }
123 
124     /**
125      * @dev Returns the address of the current owner.
126      */
127     function owner() public view virtual returns (address) {
128         return _owner;
129     }
130 
131     /**
132      * @dev Throws if called by any account other than the owner.
133      */
134     modifier onlyOwner() {
135         require(owner() == _msgSender(), "Ownable: caller is not the owner");
136         _;
137     }
138 
139     /**
140      * @dev Leaves the contract without owner. It will not be possible to call
141      * `onlyOwner` functions anymore. Can only be called by the current owner.
142      *
143      * NOTE: Renouncing ownership will leave the contract without an owner,
144      * thereby removing any functionality that is only available to the owner.
145      */
146     function renounceOwnership() public virtual onlyOwner {
147         emit OwnershipTransferred(_owner, address(0));
148         _owner = address(0);
149     }
150 
151     /**
152      * @dev Transfers ownership of the contract to a new account (`newOwner`).
153      * Can only be called by the current owner.
154      */
155     function transferOwnership(address newOwner) public virtual onlyOwner {
156         require(newOwner != address(0), "Ownable: new owner is the zero address");
157         emit OwnershipTransferred(_owner, newOwner);
158         _owner = newOwner;
159     }
160     uint256[49] private __gap;
161 }
162 
163 
164 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.1.0
165 
166 pragma solidity ^0.8.0;
167 
168 // CAUTION
169 // This version of SafeMath should only be used with Solidity 0.8 or later,
170 // because it relies on the compiler's built in overflow checks.
171 
172 /**
173  * @dev Wrappers over Solidity's arithmetic operations.
174  *
175  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
176  * now has built in overflow checking.
177  */
178 library SafeMath {
179     /**
180      * @dev Returns the addition of two unsigned integers, with an overflow flag.
181      *
182      * _Available since v3.4._
183      */
184     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
185         unchecked {
186             uint256 c = a + b;
187             if (c < a) return (false, 0);
188             return (true, c);
189         }
190     }
191 
192     /**
193      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
194      *
195      * _Available since v3.4._
196      */
197     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         unchecked {
199             if (b > a) return (false, 0);
200             return (true, a - b);
201         }
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
206      *
207      * _Available since v3.4._
208      */
209     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         unchecked {
211             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
212             // benefit is lost if 'b' is also tested.
213             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
214             if (a == 0) return (true, 0);
215             uint256 c = a * b;
216             if (c / a != b) return (false, 0);
217             return (true, c);
218         }
219     }
220 
221     /**
222      * @dev Returns the division of two unsigned integers, with a division by zero flag.
223      *
224      * _Available since v3.4._
225      */
226     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             if (b == 0) return (false, 0);
229             return (true, a / b);
230         }
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
235      *
236      * _Available since v3.4._
237      */
238     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
239         unchecked {
240             if (b == 0) return (false, 0);
241             return (true, a % b);
242         }
243     }
244 
245     /**
246      * @dev Returns the addition of two unsigned integers, reverting on
247      * overflow.
248      *
249      * Counterpart to Solidity's `+` operator.
250      *
251      * Requirements:
252      *
253      * - Addition cannot overflow.
254      */
255     function add(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a + b;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting on
261      * overflow (when the result is negative).
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      *
267      * - Subtraction cannot overflow.
268      */
269     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a - b;
271     }
272 
273     /**
274      * @dev Returns the multiplication of two unsigned integers, reverting on
275      * overflow.
276      *
277      * Counterpart to Solidity's `*` operator.
278      *
279      * Requirements:
280      *
281      * - Multiplication cannot overflow.
282      */
283     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a * b;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers, reverting on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator.
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a / b;
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * reverting when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a % b;
315     }
316 
317     /**
318      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
319      * overflow (when the result is negative).
320      *
321      * CAUTION: This function is deprecated because it requires allocating memory for the error
322      * message unnecessarily. For custom revert reasons use {trySub}.
323      *
324      * Counterpart to Solidity's `-` operator.
325      *
326      * Requirements:
327      *
328      * - Subtraction cannot overflow.
329      */
330     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
331         unchecked {
332             require(b <= a, errorMessage);
333             return a - b;
334         }
335     }
336 
337     /**
338      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
339      * division by zero. The result is rounded towards zero.
340      *
341      * Counterpart to Solidity's `%` operator. This function uses a `revert`
342      * opcode (which leaves remaining gas untouched) while Solidity uses an
343      * invalid opcode to revert (consuming all remaining gas).
344      *
345      * Counterpart to Solidity's `/` operator. Note: this function uses a
346      * `revert` opcode (which leaves remaining gas untouched) while Solidity
347      * uses an invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
354         unchecked {
355             require(b > 0, errorMessage);
356             return a / b;
357         }
358     }
359 
360     /**
361      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
362      * reverting with custom message when dividing by zero.
363      *
364      * CAUTION: This function is deprecated because it requires allocating memory for the error
365      * message unnecessarily. For custom revert reasons use {tryMod}.
366      *
367      * Counterpart to Solidity's `%` operator. This function uses a `revert`
368      * opcode (which leaves remaining gas untouched) while Solidity uses an
369      * invalid opcode to revert (consuming all remaining gas).
370      *
371      * Requirements:
372      *
373      * - The divisor cannot be zero.
374      */
375     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
376         unchecked {
377             require(b > 0, errorMessage);
378             return a % b;
379         }
380     }
381 }
382 
383 
384 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.1.0
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @dev Interface of the ERC20 standard as defined in the EIP.
390  */
391 interface IERC20 {
392     /**
393      * @dev Returns the amount of tokens in existence.
394      */
395     function totalSupply() external view returns (uint256);
396 
397     /**
398      * @dev Returns the amount of tokens owned by `account`.
399      */
400     function balanceOf(address account) external view returns (uint256);
401 
402     /**
403      * @dev Moves `amount` tokens from the caller's account to `recipient`.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transfer(address recipient, uint256 amount) external returns (bool);
410 
411     /**
412      * @dev Returns the remaining number of tokens that `spender` will be
413      * allowed to spend on behalf of `owner` through {transferFrom}. This is
414      * zero by default.
415      *
416      * This value changes when {approve} or {transferFrom} are called.
417      */
418     function allowance(address owner, address spender) external view returns (uint256);
419 
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * IMPORTANT: Beware that changing an allowance with this method brings the risk
426      * that someone may use both the old and the new allowance by unfortunate
427      * transaction ordering. One possible solution to mitigate this race
428      * condition is to first reduce the spender's allowance to 0 and set the
429      * desired value afterwards:
430      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
431      *
432      * Emits an {Approval} event.
433      */
434     function approve(address spender, uint256 amount) external returns (bool);
435 
436     /**
437      * @dev Moves `amount` tokens from `sender` to `recipient` using the
438      * allowance mechanism. `amount` is then deducted from the caller's
439      * allowance.
440      *
441      * Returns a boolean value indicating whether the operation succeeded.
442      *
443      * Emits a {Transfer} event.
444      */
445     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
446 
447     /**
448      * @dev Emitted when `value` tokens are moved from one account (`from`) to
449      * another (`to`).
450      *
451      * Note that `value` may be zero.
452      */
453     event Transfer(address indexed from, address indexed to, uint256 value);
454 
455     /**
456      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
457      * a call to {approve}. `value` is the new allowance.
458      */
459     event Approval(address indexed owner, address indexed spender, uint256 value);
460 }
461 
462 
463 // File contracts/GluwaAirdrop.sol
464 
465 pragma solidity >=0.8.5;
466 
467 
468 
469 contract GluwaAirdrop is OwnableUpgradeable {
470     using SafeMath for uint256;
471 
472     uint256 private _fee;
473 
474     event EthTransfer(
475         address indexed _from,
476         uint256 _senderVal,
477         address _to,
478         uint256 _amount
479     );
480 
481     function GluwaAirdrop_init() external initializer {
482         __Ownable_init();
483     }
484 
485     receive() external payable {
486         emit EthTransfer(msg.sender, msg.value, address(this), msg.value);
487     }
488 
489     function fee() external view returns (uint256) {
490         return _fee;
491     }
492 
493     function setFee(uint256 __fee) external onlyOwner {
494         _fee = __fee;
495     }
496 
497     function withdrawFund() external onlyOwner {
498         uint256 totalBalance = payable(address(this)).balance;
499         _safeTransfer(payable(msg.sender), totalBalance);
500         emit EthTransfer(msg.sender, totalBalance, msg.sender, totalBalance);
501     }
502 
503     function withdrawToken(IERC20 token) external onlyOwner() {
504         uint256 totalTokenBalance = token.balanceOf(address(this));
505         token.transfer(msg.sender, totalTokenBalance);
506     }
507 
508     function multiTransfer(address[] memory addresses, uint256[] memory amounts)
509         public
510         payable
511         onlyOwner
512         returns (bool)
513     {
514         uint256 toReturn = msg.value;
515         for (uint256 i = 0; i < addresses.length; i++) {
516             toReturn = SafeMath.sub(toReturn, amounts[i]);
517             _safeCall(addresses[i], amounts[i]);
518             emit EthTransfer(msg.sender, msg.value, addresses[i], amounts[i]);
519         }
520         _safeTransfer(payable(msg.sender), toReturn);
521         emit EthTransfer(msg.sender, msg.value, msg.sender, toReturn);
522         return true;
523     }
524 
525     function multiTransferTightlyPacked(bytes32[] memory addressesAndAmounts)
526         public
527         payable
528         onlyOwner
529         returns (bool)
530     {
531         uint256 toReturn = msg.value;
532         for (uint256 i = 0; i < addressesAndAmounts.length; i++) {
533             address to = address(bytes20(addressesAndAmounts[i] >> 96));
534             uint256 amount = uint256(uint96(bytes12(addressesAndAmounts[i])));
535             _safeCall(to, amount);
536             toReturn = SafeMath.sub(
537                 toReturn,
538                 uint256(uint96(bytes12(addressesAndAmounts[i])))
539             );
540             emit EthTransfer(msg.sender, msg.value, to, amount);
541         }
542         _safeTransfer(payable(msg.sender), toReturn);
543         emit EthTransfer(msg.sender, msg.value, msg.sender, toReturn);
544         return true;
545     }
546 
547     function multiTransferERC20(
548         IERC20 token,
549         address[] memory addresses,
550         uint256[] memory amounts
551     ) public {
552         for (uint256 i = 0; i < addresses.length; i++) {
553             token.transferFrom(msg.sender, addresses[i], amounts[i]);
554         }
555         token.transferFrom(msg.sender, owner(), _fee);
556     }
557 
558     function multiTransferERC20TightlyPacked(
559         IERC20 token,
560         bytes32[] memory addressesAndAmounts
561     ) public {
562         for (uint256 i = 0; i < addressesAndAmounts.length; i++) {
563             address to =
564                 address(uint160(uint256(addressesAndAmounts[i] >> 96)));
565             uint256 amount = uint256(uint96(uint256(addressesAndAmounts[i])));
566             token.transferFrom(msg.sender, to, amount);
567         }
568         token.transferFrom(msg.sender, owner(), _fee);
569     }
570 
571     function _safeCall(address to, uint256 amount) private {
572         require(to != address(0));
573         (bool success, ) = to.call{value: amount}("");
574         require(success);
575     }
576 
577     function _safeTransfer(address payable to, uint256 amount) private {
578         require(to != address(0));
579         to.transfer(amount);
580     }
581 }