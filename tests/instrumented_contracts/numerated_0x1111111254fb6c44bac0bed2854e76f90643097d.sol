1 /*
2                                                            ,▄▓▓██▌   ,╓▄▄▓▓▓▓▓▓▓▓▄▄▄,,
3                                                         ,▓██▓███▓▄▓███▓╬╬╬╬╬╬╬╬╬╬╬╬╬▓███▓▄,
4                                                   ▄█   ▓██╬╣███████╬▓▀╬╬▓▓▓████████████▓█████▄,
5                                                  ▓██▌ ▓██╬╣██████╬▓▌  ██████████████████████▌╙╙▀ⁿ
6                                                 ▐████████╬▓████▓▓█╨ ▄ ╟█████████▓▓╬╬╬╬╬▓▓█████▓▄
7                                   └▀▓▓▄╓        ╟█▓╣█████▓██████▀ ╓█▌ ███████▓▓▓▓▓╬╬╬╬╬╬╬╬╬╬╬╬▓██▓▄
8                                      └▀████▓▄╥  ▐██╬╬██████████╙ Æ▀─ ▓███▀╚╠╬╩▀▀███████▓▓╬╬╬╬╬╬╬╬╬██▄
9                                         └▀██▓▀▀█████▓╬▓██████▀     ▄█████▒╠"      └╙▓██████▓╬╬╬╬╬╬╬╬██▄
10                                            └▀██▄,└╙▀▀████▌└╙    ^"▀╙╙╙"╙██      @▄    ╙▀███████╬╬╬╬╬╬╬██µ
11                                               └▀██▓▄, ██▌       ╒       ╙█▓     ]▓█▓╔    ▀███████▓╬╬╬╬╬▓█▌
12                                                   ▀█████       ▓         ╟█▌    ]╠██▓░▒╓   ▀████████╬╬╬╬╣█▌
13                                                   ▐████      ╓█▀█▌      ,██▌    ╚Å███▓▒▒╠╓  ╙█████████╬╬╬╣█▌
14                                                   └████     ▓█░░▓█      ▀▀▀    φ▒╫████▒▒▒▒╠╓  █████████▓╬╬▓█µ
15                                                    ╘███µ ▌▄█▓▄▓▀`     ,▀    ,╔╠░▓██████▌╠▒▒▒φ  ██████████╬╬██
16                                                    ▐████µ╙▓▀`     ,▀╙,╔╔φφφ╠░▄▓███████▌░▓╙▒▒▒╠ └██╬███████╬▓█⌐
17                                                    ╫██ ▓▌         ▌φ▒▒░▓██████████████▌▒░▓╚▒▒▒╠ ▓██╬▓██████╣█▌
18                                                    ██▌           ▌╔▒▒▄████████████████▒▒▒░▌╠▒▒▒≥▐██▓╬╬███████▌
19                                                    ██▌      ,╓φ╠▓«▒▒▓████▀  ▀█████████▌▒▒▒╟░▒▒▒▒▐███╬╬╣████▓█▌
20                                                   ▐██      ╠▒▄▓▓███▓████└     ▀████████▌▒▒░▌╚▒▒▒▐███▓╬╬████ ╙▌
21                                                   ███  )  ╠▒░░░▒░╬████▀        └████████░▒▒░╬∩▒▒▓████╬╬╣███
22                                                  ▓██    ╠╠▒▒▐█▀▀▌`░╫██           ███████▒▒▒▒░▒▒½█████╬╬╣███
23                                                 ███ ,█▄ ╠▒▒▒╫▌,▄▀,▒╫██           ╟██████▒▒▒░╣⌠▒▓█████╬╬╣██▌
24                                                ╘██µ ██` ╠▒▒░██╬φ╠▄▓██`            ██████░░▌φ╠░▓█████▓╬╬▓██
25                                                 ╟██  .φ╠▒░▄█▀░░▄██▀└              █████▌▒╣φ▒░▓██████╬╬╣██
26                                                  ▀██▄▄▄╓▄███████▀                ▐█████░▓φ▒▄███████▓╬╣██
27                                                    ╙▀▀▀██▀└                      ████▓▄▀φ▄▓████████╬▓█▀
28                                                                                 ▓███╬╩╔╣██████████▓██└
29                                                                               ╓████▀▄▓████████▀████▀
30                                                                             ,▓███████████████─]██╙
31                                                                          ,▄▓██████████████▀└  ╙
32                                                                     ,╓▄▓███████████████▀╙
33                                                              `"▀▀▀████████▀▀▀▀`▄███▀▀└
34                                                                               └└
35 
36 
37 
38                     11\   11\                     11\             11\   11\            11\                                       11\
39                   1111 |  \__|                    11 |            111\  11 |           11 |                                      11 |
40                   \_11 |  11\ 1111111\   1111111\ 1111111\        1111\ 11 | 111111\ 111111\   11\  11\  11\  111111\   111111\  11 |  11\
41                     11 |  11 |11  __11\ 11  _____|11  __11\       11 11\11 |11  __11\\_11  _|  11 | 11 | 11 |11  __11\ 11  __11\ 11 | 11  |
42                     11 |  11 |11 |  11 |11 /      11 |  11 |      11 \1111 |11111111 | 11 |    11 | 11 | 11 |11 /  11 |11 |  \__|111111  /
43                     11 |  11 |11 |  11 |11 |      11 |  11 |      11 |\111 |11   ____| 11 |11\ 11 | 11 | 11 |11 |  11 |11 |      11  _11<
44                   111111\ 11 |11 |  11 |\1111111\ 11 |  11 |      11 | \11 |\1111111\  \1111  |\11111\1111  |\111111  |11 |      11 | \11\
45                   \______|\__|\__|  \__| \_______|\__|  \__|      \__|  \__| \_______|  \____/  \_____\____/  \______/ \__|      \__|  \__|
46 
47 
48 
49                                111111\                                                               11\     11\
50                               11  __11\                                                              11 |    \__|
51                               11 /  11 | 111111\   111111\   111111\   111111\   111111\   111111\ 111111\   11\  111111\  1111111\
52                               11111111 |11  __11\ 11  __11\ 11  __11\ 11  __11\ 11  __11\  \____11\\_11  _|  11 |11  __11\ 11  __11\
53                               11  __11 |11 /  11 |11 /  11 |11 |  \__|11111111 |11 /  11 | 1111111 | 11 |    11 |11 /  11 |11 |  11 |
54                               11 |  11 |11 |  11 |11 |  11 |11 |      11   ____|11 |  11 |11  __11 | 11 |11\ 11 |11 |  11 |11 |  11 |
55                               11 |  11 |\1111111 |\1111111 |11 |      \1111111\ \1111111 |\1111111 | \1111  |11 |\111111  |11 |  11 |
56                               \__|  \__| \____11 | \____11 |\__|       \_______| \____11 | \_______|  \____/ \__| \______/ \__|  \__|
57                                         11\   11 |11\   11 |                    11\   11 |
58                                         \111111  |\111111  |                    \111111  |
59                                          \______/  \______/                      \______/
60                                                 1111111\                        11\
61                                                 11  __11\                       11 |
62                                                 11 |  11 | 111111\  11\   11\ 111111\    111111\   111111\
63                                                 1111111  |11  __11\ 11 |  11 |\_11  _|  11  __11\ 11  __11\
64                                                 11  __11< 11 /  11 |11 |  11 |  11 |    11111111 |11 |  \__|
65                                                 11 |  11 |11 |  11 |11 |  11 |  11 |11\ 11   ____|11 |
66                                                 11 |  11 |\111111  |\111111  |  \1111  |\1111111\ 11 |
67                                                 \__|  \__| \______/  \______/    \____/  \_______|\__|
68 */
69 
70 // File @openzeppelin/contracts/utils/Context.sol@v3.4.2-solc-0.7
71 
72 // SPDX-License-Identifier: MIT
73 
74 pragma solidity >=0.6.0 <0.8.0;
75 
76 /*
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with GSN meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address payable) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes memory) {
92         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
93         return msg.data;
94     }
95 }
96 
97 
98 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.2-solc-0.7
99 
100 
101 pragma solidity ^0.7.0;
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor () {
124         address msgSender = _msgSender();
125         _owner = msgSender;
126         emit OwnershipTransferred(address(0), msgSender);
127     }
128 
129     /**
130      * @dev Returns the address of the current owner.
131      */
132     function owner() public view virtual returns (address) {
133         return _owner;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * NOTE: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public virtual onlyOwner {
152         emit OwnershipTransferred(_owner, address(0));
153         _owner = address(0);
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         emit OwnershipTransferred(_owner, newOwner);
163         _owner = newOwner;
164     }
165 }
166 
167 
168 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2-solc-0.7
169 
170 
171 pragma solidity ^0.7.0;
172 
173 /**
174  * @dev Interface of the ERC20 standard as defined in the EIP.
175  */
176 interface IERC20 {
177     /**
178      * @dev Returns the amount of tokens in existence.
179      */
180     function totalSupply() external view returns (uint256);
181 
182     /**
183      * @dev Returns the amount of tokens owned by `account`.
184      */
185     function balanceOf(address account) external view returns (uint256);
186 
187     /**
188      * @dev Moves `amount` tokens from the caller's account to `recipient`.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transfer(address recipient, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Returns the remaining number of tokens that `spender` will be
198      * allowed to spend on behalf of `owner` through {transferFrom}. This is
199      * zero by default.
200      *
201      * This value changes when {approve} or {transferFrom} are called.
202      */
203     function allowance(address owner, address spender) external view returns (uint256);
204 
205     /**
206      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
207      *
208      * Returns a boolean value indicating whether the operation succeeded.
209      *
210      * IMPORTANT: Beware that changing an allowance with this method brings the risk
211      * that someone may use both the old and the new allowance by unfortunate
212      * transaction ordering. One possible solution to mitigate this race
213      * condition is to first reduce the spender's allowance to 0 and set the
214      * desired value afterwards:
215      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216      *
217      * Emits an {Approval} event.
218      */
219     function approve(address spender, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Moves `amount` tokens from `sender` to `recipient` using the
223      * allowance mechanism. `amount` is then deducted from the caller's
224      * allowance.
225      *
226      * Returns a boolean value indicating whether the operation succeeded.
227      *
228      * Emits a {Transfer} event.
229      */
230     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Emitted when `value` tokens are moved from one account (`from`) to
234      * another (`to`).
235      *
236      * Note that `value` may be zero.
237      */
238     event Transfer(address indexed from, address indexed to, uint256 value);
239 
240     /**
241      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
242      * a call to {approve}. `value` is the new allowance.
243      */
244     event Approval(address indexed owner, address indexed spender, uint256 value);
245 }
246 
247 
248 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2-solc-0.7
249 
250 
251 pragma solidity ^0.7.0;
252 
253 /**
254  * @dev Wrappers over Solidity's arithmetic operations with added overflow
255  * checks.
256  *
257  * Arithmetic operations in Solidity wrap on overflow. This can easily result
258  * in bugs, because programmers usually assume that an overflow raises an
259  * error, which is the standard behavior in high level programming languages.
260  * `SafeMath` restores this intuition by reverting the transaction when an
261  * operation overflows.
262  *
263  * Using this library instead of the unchecked operations eliminates an entire
264  * class of bugs, so it's recommended to use it always.
265  */
266 library SafeMath {
267     /**
268      * @dev Returns the addition of two unsigned integers, with an overflow flag.
269      *
270      * _Available since v3.4._
271      */
272     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         uint256 c = a + b;
274         if (c < a) return (false, 0);
275         return (true, c);
276     }
277 
278     /**
279      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
280      *
281      * _Available since v3.4._
282      */
283     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
284         if (b > a) return (false, 0);
285         return (true, a - b);
286     }
287 
288     /**
289      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
290      *
291      * _Available since v3.4._
292      */
293     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
295         // benefit is lost if 'b' is also tested.
296         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
297         if (a == 0) return (true, 0);
298         uint256 c = a * b;
299         if (c / a != b) return (false, 0);
300         return (true, c);
301     }
302 
303     /**
304      * @dev Returns the division of two unsigned integers, with a division by zero flag.
305      *
306      * _Available since v3.4._
307      */
308     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
309         if (b == 0) return (false, 0);
310         return (true, a / b);
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
315      *
316      * _Available since v3.4._
317      */
318     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
319         if (b == 0) return (false, 0);
320         return (true, a % b);
321     }
322 
323     /**
324      * @dev Returns the addition of two unsigned integers, reverting on
325      * overflow.
326      *
327      * Counterpart to Solidity's `+` operator.
328      *
329      * Requirements:
330      *
331      * - Addition cannot overflow.
332      */
333     function add(uint256 a, uint256 b) internal pure returns (uint256) {
334         uint256 c = a + b;
335         require(c >= a, "SafeMath: addition overflow");
336         return c;
337     }
338 
339     /**
340      * @dev Returns the subtraction of two unsigned integers, reverting on
341      * overflow (when the result is negative).
342      *
343      * Counterpart to Solidity's `-` operator.
344      *
345      * Requirements:
346      *
347      * - Subtraction cannot overflow.
348      */
349     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
350         require(b <= a, "SafeMath: subtraction overflow");
351         return a - b;
352     }
353 
354     /**
355      * @dev Returns the multiplication of two unsigned integers, reverting on
356      * overflow.
357      *
358      * Counterpart to Solidity's `*` operator.
359      *
360      * Requirements:
361      *
362      * - Multiplication cannot overflow.
363      */
364     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
365         if (a == 0) return 0;
366         uint256 c = a * b;
367         require(c / a == b, "SafeMath: multiplication overflow");
368         return c;
369     }
370 
371     /**
372      * @dev Returns the integer division of two unsigned integers, reverting on
373      * division by zero. The result is rounded towards zero.
374      *
375      * Counterpart to Solidity's `/` operator. Note: this function uses a
376      * `revert` opcode (which leaves remaining gas untouched) while Solidity
377      * uses an invalid opcode to revert (consuming all remaining gas).
378      *
379      * Requirements:
380      *
381      * - The divisor cannot be zero.
382      */
383     function div(uint256 a, uint256 b) internal pure returns (uint256) {
384         require(b > 0, "SafeMath: division by zero");
385         return a / b;
386     }
387 
388     /**
389      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
390      * reverting when dividing by zero.
391      *
392      * Counterpart to Solidity's `%` operator. This function uses a `revert`
393      * opcode (which leaves remaining gas untouched) while Solidity uses an
394      * invalid opcode to revert (consuming all remaining gas).
395      *
396      * Requirements:
397      *
398      * - The divisor cannot be zero.
399      */
400     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
401         require(b > 0, "SafeMath: modulo by zero");
402         return a % b;
403     }
404 
405     /**
406      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
407      * overflow (when the result is negative).
408      *
409      * CAUTION: This function is deprecated because it requires allocating memory for the error
410      * message unnecessarily. For custom revert reasons use {trySub}.
411      *
412      * Counterpart to Solidity's `-` operator.
413      *
414      * Requirements:
415      *
416      * - Subtraction cannot overflow.
417      */
418     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
419         require(b <= a, errorMessage);
420         return a - b;
421     }
422 
423     /**
424      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
425      * division by zero. The result is rounded towards zero.
426      *
427      * CAUTION: This function is deprecated because it requires allocating memory for the error
428      * message unnecessarily. For custom revert reasons use {tryDiv}.
429      *
430      * Counterpart to Solidity's `/` operator. Note: this function uses a
431      * `revert` opcode (which leaves remaining gas untouched) while Solidity
432      * uses an invalid opcode to revert (consuming all remaining gas).
433      *
434      * Requirements:
435      *
436      * - The divisor cannot be zero.
437      */
438     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
439         require(b > 0, errorMessage);
440         return a / b;
441     }
442 
443     /**
444      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
445      * reverting with custom message when dividing by zero.
446      *
447      * CAUTION: This function is deprecated because it requires allocating memory for the error
448      * message unnecessarily. For custom revert reasons use {tryMod}.
449      *
450      * Counterpart to Solidity's `%` operator. This function uses a `revert`
451      * opcode (which leaves remaining gas untouched) while Solidity uses an
452      * invalid opcode to revert (consuming all remaining gas).
453      *
454      * Requirements:
455      *
456      * - The divisor cannot be zero.
457      */
458     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
459         require(b > 0, errorMessage);
460         return a % b;
461     }
462 }
463 
464 
465 // File @openzeppelin/contracts/utils/Address.sol@v3.4.2-solc-0.7
466 
467 
468 pragma solidity ^0.7.0;
469 
470 /**
471  * @dev Collection of functions related to the address type
472  */
473 library Address {
474     /**
475      * @dev Returns true if `account` is a contract.
476      *
477      * [IMPORTANT]
478      * ====
479      * It is unsafe to assume that an address for which this function returns
480      * false is an externally-owned account (EOA) and not a contract.
481      *
482      * Among others, `isContract` will return false for the following
483      * types of addresses:
484      *
485      *  - an externally-owned account
486      *  - a contract in construction
487      *  - an address where a contract will be created
488      *  - an address where a contract lived, but was destroyed
489      * ====
490      */
491     function isContract(address account) internal view returns (bool) {
492         // This method relies on extcodesize, which returns 0 for contracts in
493         // construction, since the code is only stored at the end of the
494         // constructor execution.
495 
496         uint256 size;
497         // solhint-disable-next-line no-inline-assembly
498         assembly { size := extcodesize(account) }
499         return size > 0;
500     }
501 
502     /**
503      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
504      * `recipient`, forwarding all available gas and reverting on errors.
505      *
506      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
507      * of certain opcodes, possibly making contracts go over the 2300 gas limit
508      * imposed by `transfer`, making them unable to receive funds via
509      * `transfer`. {sendValue} removes this limitation.
510      *
511      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
512      *
513      * IMPORTANT: because control is transferred to `recipient`, care must be
514      * taken to not create reentrancy vulnerabilities. Consider using
515      * {ReentrancyGuard} or the
516      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
517      */
518     function sendValue(address payable recipient, uint256 amount) internal {
519         require(address(this).balance >= amount, "Address: insufficient balance");
520 
521         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
522         (bool success, ) = recipient.call{ value: amount }("");
523         require(success, "Address: unable to send value, recipient may have reverted");
524     }
525 
526     /**
527      * @dev Performs a Solidity function call using a low level `call`. A
528      * plain`call` is an unsafe replacement for a function call: use this
529      * function instead.
530      *
531      * If `target` reverts with a revert reason, it is bubbled up by this
532      * function (like regular Solidity function calls).
533      *
534      * Returns the raw returned data. To convert to the expected return value,
535      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
536      *
537      * Requirements:
538      *
539      * - `target` must be a contract.
540      * - calling `target` with `data` must not revert.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
545       return functionCall(target, data, "Address: low-level call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
550      * `errorMessage` as a fallback revert reason when `target` reverts.
551      *
552      * _Available since v3.1._
553      */
554     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
555         return functionCallWithValue(target, data, 0, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but also transferring `value` wei to `target`.
561      *
562      * Requirements:
563      *
564      * - the calling contract must have an ETH balance of at least `value`.
565      * - the called Solidity function must be `payable`.
566      *
567      * _Available since v3.1._
568      */
569     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
575      * with `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
580         require(address(this).balance >= value, "Address: insufficient balance for call");
581         require(isContract(target), "Address: call to non-contract");
582 
583         // solhint-disable-next-line avoid-low-level-calls
584         (bool success, bytes memory returndata) = target.call{ value: value }(data);
585         return _verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
590      * but performing a static call.
591      *
592      * _Available since v3.3._
593      */
594     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
595         return functionStaticCall(target, data, "Address: low-level static call failed");
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
600      * but performing a static call.
601      *
602      * _Available since v3.3._
603      */
604     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
605         require(isContract(target), "Address: static call to non-contract");
606 
607         // solhint-disable-next-line avoid-low-level-calls
608         (bool success, bytes memory returndata) = target.staticcall(data);
609         return _verifyCallResult(success, returndata, errorMessage);
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
614      * but performing a delegate call.
615      *
616      * _Available since v3.4._
617      */
618     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
619         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
624      * but performing a delegate call.
625      *
626      * _Available since v3.4._
627      */
628     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
629         require(isContract(target), "Address: delegate call to non-contract");
630 
631         // solhint-disable-next-line avoid-low-level-calls
632         (bool success, bytes memory returndata) = target.delegatecall(data);
633         return _verifyCallResult(success, returndata, errorMessage);
634     }
635 
636     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
637         if (success) {
638             return returndata;
639         } else {
640             // Look for revert reason and bubble it up if present
641             if (returndata.length > 0) {
642                 // The easiest way to bubble the revert reason is using memory via assembly
643 
644                 // solhint-disable-next-line no-inline-assembly
645                 assembly {
646                     let returndata_size := mload(returndata)
647                     revert(add(32, returndata), returndata_size)
648                 }
649             } else {
650                 revert(errorMessage);
651             }
652         }
653     }
654 }
655 
656 
657 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.2-solc-0.7
658 
659 
660 pragma solidity ^0.7.0;
661 
662 
663 
664 /**
665  * @title SafeERC20
666  * @dev Wrappers around ERC20 operations that throw on failure (when the token
667  * contract returns false). Tokens that return no value (and instead revert or
668  * throw on failure) are also supported, non-reverting calls are assumed to be
669  * successful.
670  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
671  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
672  */
673 library SafeERC20 {
674     using SafeMath for uint256;
675     using Address for address;
676 
677     function safeTransfer(IERC20 token, address to, uint256 value) internal {
678         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
679     }
680 
681     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
682         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
683     }
684 
685     /**
686      * @dev Deprecated. This function has issues similar to the ones found in
687      * {IERC20-approve}, and its usage is discouraged.
688      *
689      * Whenever possible, use {safeIncreaseAllowance} and
690      * {safeDecreaseAllowance} instead.
691      */
692     function safeApprove(IERC20 token, address spender, uint256 value) internal {
693         // safeApprove should only be called when setting an initial allowance,
694         // or when resetting it to zero. To increase and decrease it, use
695         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
696         // solhint-disable-next-line max-line-length
697         require((value == 0) || (token.allowance(address(this), spender) == 0),
698             "SafeERC20: approve from non-zero to non-zero allowance"
699         );
700         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
701     }
702 
703     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
704         uint256 newAllowance = token.allowance(address(this), spender).add(value);
705         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
706     }
707 
708     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
709         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
710         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
711     }
712 
713     /**
714      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
715      * on the return value: the return value is optional (but if data is returned, it must not be false).
716      * @param token The token targeted by the call.
717      * @param data The call data (encoded using abi.encode or one of its variants).
718      */
719     function _callOptionalReturn(IERC20 token, bytes memory data) private {
720         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
721         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
722         // the target address contains contract code and also asserts for success in the low-level call.
723 
724         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
725         if (returndata.length > 0) { // Return data is optional
726             // solhint-disable-next-line max-line-length
727             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
728         }
729     }
730 }
731 
732 
733 // File contracts/helpers/EthReceiver.sol
734 
735 
736 pragma solidity ^0.7.6;
737 
738 /// @title Base contract with common payable logics
739 abstract contract EthReceiver {
740     receive() external payable {
741         // solhint-disable-next-line avoid-tx-origin
742         require(msg.sender != tx.origin, "ETH deposit rejected");
743     }
744 }
745 
746 
747 // File @openzeppelin/contracts/drafts/IERC20Permit.sol@v3.4.2-solc-0.7
748 
749 
750 pragma solidity >=0.6.0 <0.8.0;
751 
752 /**
753  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
754  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
755  *
756  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
757  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
758  * need to send a transaction, and thus is not required to hold Ether at all.
759  */
760 interface IERC20Permit {
761     /**
762      * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
763      * given `owner`'s signed approval.
764      *
765      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
766      * ordering also apply here.
767      *
768      * Emits an {Approval} event.
769      *
770      * Requirements:
771      *
772      * - `spender` cannot be the zero address.
773      * - `deadline` must be a timestamp in the future.
774      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
775      * over the EIP712-formatted function arguments.
776      * - the signature must use ``owner``'s current nonce (see {nonces}).
777      *
778      * For more information on the signature format, see the
779      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
780      * section].
781      */
782     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
783 
784     /**
785      * @dev Returns the current nonce for `owner`. This value must be
786      * included whenever a signature is generated for {permit}.
787      *
788      * Every successful call to {permit} increases ``owner``'s nonce by one. This
789      * prevents a signature from being used multiple times.
790      */
791     function nonces(address owner) external view returns (uint256);
792 
793     /**
794      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
795      */
796     // solhint-disable-next-line func-name-mixedcase
797     function DOMAIN_SEPARATOR() external view returns (bytes32);
798 }
799 
800 
801 // File contracts/helpers/RevertReasonParser.sol
802 
803 
804 pragma solidity ^0.7.6;
805 
806 /// @title Library that allows to parse unsuccessful arbitrary calls revert reasons.
807 /// See https://solidity.readthedocs.io/en/latest/control-structures.html#revert for details.
808 /// Note that we assume revert reason being abi-encoded as Error(string) so it may fail to parse reason
809 /// if structured reverts appear in the future.
810 ///
811 /// All unsuccessful parsings get encoded as Unknown(data) string
812 library RevertReasonParser {
813     bytes4 constant private _PANIC_SELECTOR = bytes4(keccak256("Panic(uint256)"));
814     bytes4 constant private _ERROR_SELECTOR = bytes4(keccak256("Error(string)"));
815 
816     function parse(bytes memory data, string memory prefix) internal pure returns (string memory) {
817         if (data.length >= 4) {
818             bytes4 selector;
819             assembly {  // solhint-disable-line no-inline-assembly
820                 selector := mload(add(data, 0x20))
821             }
822 
823             // 68 = 4-byte selector + 32 bytes offset + 32 bytes length
824             if (selector == _ERROR_SELECTOR && data.length >= 68) {
825                 uint256 offset;
826                 bytes memory reason;
827                 // solhint-disable no-inline-assembly
828                 assembly {
829                     // 36 = 32 bytes data length + 4-byte selector
830                     offset := mload(add(data, 36))
831                     reason := add(data, add(36, offset))
832                 }
833                 /*
834                     revert reason is padded up to 32 bytes with ABI encoder: Error(string)
835                     also sometimes there is extra 32 bytes of zeros padded in the end:
836                     https://github.com/ethereum/solidity/issues/10170
837                     because of that we can't check for equality and instead check
838                     that offset + string length + extra 36 bytes is less than overall data length
839                 */
840                 require(data.length >= 36 + offset + reason.length, "Invalid revert reason");
841                 return string(abi.encodePacked(prefix, "Error(", reason, ")"));
842             }
843             // 36 = 4-byte selector + 32 bytes integer
844             else if (selector == _PANIC_SELECTOR && data.length == 36) {
845                 uint256 code;
846                 // solhint-disable no-inline-assembly
847                 assembly {
848                     // 36 = 32 bytes data length + 4-byte selector
849                     code := mload(add(data, 36))
850                 }
851                 return string(abi.encodePacked(prefix, "Panic(", _toHex(code), ")"));
852             }
853         }
854 
855         return string(abi.encodePacked(prefix, "Unknown(", _toHex(data), ")"));
856     }
857 
858     function _toHex(uint256 value) private pure returns(string memory) {
859         return _toHex(abi.encodePacked(value));
860     }
861 
862     function _toHex(bytes memory data) private pure returns(string memory) {
863         bytes16 alphabet = 0x30313233343536373839616263646566;
864         bytes memory str = new bytes(2 + data.length * 2);
865         str[0] = "0";
866         str[1] = "x";
867         for (uint256 i = 0; i < data.length; i++) {
868             str[2 * i + 2] = alphabet[uint8(data[i] >> 4)];
869             str[2 * i + 3] = alphabet[uint8(data[i] & 0x0f)];
870         }
871         return string(str);
872     }
873 }
874 
875 
876 // File contracts/interfaces/IDaiLikePermit.sol
877 
878 
879 pragma solidity ^0.7.6;
880 
881 /// @title Interface for DAI-style permits
882 interface IDaiLikePermit {
883     function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;
884 }
885 
886 
887 // File contracts/helpers/Permitable.sol
888 
889 
890 pragma solidity ^0.7.6;
891 
892 
893 
894 /// @title Base contract with common permit handling logics
895 contract Permitable {
896     function _permit(address token, bytes calldata permit) internal {
897         if (permit.length > 0) {
898             bool success;
899             bytes memory result;
900             if (permit.length == 32 * 7) {
901                 // solhint-disable-next-line avoid-low-level-calls
902                 (success, result) = token.call(abi.encodePacked(IERC20Permit.permit.selector, permit));
903             } else if (permit.length == 32 * 8) {
904                 // solhint-disable-next-line avoid-low-level-calls
905                 (success, result) = token.call(abi.encodePacked(IDaiLikePermit.permit.selector, permit));
906             } else {
907                 revert("Wrong permit length");
908             }
909             if (!success) {
910                 revert(RevertReasonParser.parse(result, "Permit failed: "));
911             }
912         }
913     }
914 }
915 
916 
917 // File contracts/helpers/UniERC20.sol
918 
919 
920 pragma solidity ^0.7.6;
921 
922 
923 
924 
925 library UniERC20 {
926     using SafeMath for uint256;
927     using SafeERC20 for IERC20;
928 
929     IERC20 private constant _ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
930     IERC20 private constant _ZERO_ADDRESS = IERC20(0);
931 
932     function isETH(IERC20 token) internal pure returns (bool) {
933         return (token == _ZERO_ADDRESS || token == _ETH_ADDRESS);
934     }
935 
936     function uniBalanceOf(IERC20 token, address account) internal view returns (uint256) {
937         if (isETH(token)) {
938             return account.balance;
939         } else {
940             return token.balanceOf(account);
941         }
942     }
943 
944     function uniTransfer(IERC20 token, address payable to, uint256 amount) internal {
945         if (amount > 0) {
946             if (isETH(token)) {
947                 to.transfer(amount);
948             } else {
949                 token.safeTransfer(to, amount);
950             }
951         }
952     }
953 
954     function uniApprove(IERC20 token, address to, uint256 amount) internal {
955         require(!isETH(token), "Approve called on ETH");
956 
957         // solhint-disable-next-line avoid-low-level-calls
958         (bool success, bytes memory returndata) = address(token).call(abi.encodeWithSelector(token.approve.selector, to, amount));
959 
960         if (!success || (returndata.length > 0 && !abi.decode(returndata, (bool)))) {
961             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, to, 0));
962             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, to, amount));
963         }
964     }
965 
966     function _callOptionalReturn(IERC20 token, bytes memory data) private {
967         // solhint-disable-next-line avoid-low-level-calls
968         (bool success, bytes memory result) = address(token).call(data);
969         if (!success) {
970             revert(RevertReasonParser.parse(result, "Low-level call failed: "));
971         }
972 
973         if (result.length > 0) { // Return data is optional
974             require(abi.decode(result, (bool)), "ERC20 operation did not succeed");
975         }
976     }
977 }
978 
979 
980 // File contracts/interfaces/IAggregationExecutor.sol
981 
982 
983 pragma solidity ^0.7.6;
984 
985 /// @title Interface for making arbitrary calls during swap
986 interface IAggregationExecutor {
987     /// @notice Make calls on `msgSender` with specified data
988     function callBytes(address msgSender, bytes calldata data) external payable;  // 0x2636f7f8
989 }
990 
991 
992 // File @openzeppelin/contracts/drafts/EIP712.sol@v3.4.2-solc-0.7
993 
994 
995 pragma solidity >=0.6.0 <0.8.0;
996 
997 /**
998  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
999  *
1000  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1001  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1002  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1003  *
1004  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1005  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1006  * ({_hashTypedDataV4}).
1007  *
1008  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1009  * the chain id to protect against replay attacks on an eventual fork of the chain.
1010  *
1011  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1012  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1013  *
1014  * _Available since v3.4._
1015  */
1016 abstract contract EIP712 {
1017     /* solhint-disable var-name-mixedcase */
1018     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1019     // invalidate the cached domain separator if the chain id changes.
1020     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1021     uint256 private immutable _CACHED_CHAIN_ID;
1022 
1023     bytes32 private immutable _HASHED_NAME;
1024     bytes32 private immutable _HASHED_VERSION;
1025     bytes32 private immutable _TYPE_HASH;
1026     /* solhint-enable var-name-mixedcase */
1027 
1028     /**
1029      * @dev Initializes the domain separator and parameter caches.
1030      *
1031      * The meaning of `name` and `version` is specified in
1032      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1033      *
1034      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1035      * - `version`: the current major version of the signing domain.
1036      *
1037      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1038      * contract upgrade].
1039      */
1040     constructor(string memory name, string memory version) {
1041         bytes32 hashedName = keccak256(bytes(name));
1042         bytes32 hashedVersion = keccak256(bytes(version));
1043         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1044         _HASHED_NAME = hashedName;
1045         _HASHED_VERSION = hashedVersion;
1046         _CACHED_CHAIN_ID = _getChainId();
1047         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1048         _TYPE_HASH = typeHash;
1049     }
1050 
1051     /**
1052      * @dev Returns the domain separator for the current chain.
1053      */
1054     function _domainSeparatorV4() internal view virtual returns (bytes32) {
1055         if (_getChainId() == _CACHED_CHAIN_ID) {
1056             return _CACHED_DOMAIN_SEPARATOR;
1057         } else {
1058             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1059         }
1060     }
1061 
1062     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
1063         return keccak256(
1064             abi.encode(
1065                 typeHash,
1066                 name,
1067                 version,
1068                 _getChainId(),
1069                 address(this)
1070             )
1071         );
1072     }
1073 
1074     /**
1075      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1076      * function returns the hash of the fully encoded EIP712 message for this domain.
1077      *
1078      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1079      *
1080      * ```solidity
1081      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1082      *     keccak256("Mail(address to,string contents)"),
1083      *     mailTo,
1084      *     keccak256(bytes(mailContents))
1085      * )));
1086      * address signer = ECDSA.recover(digest, signature);
1087      * ```
1088      */
1089     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1090         return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
1091     }
1092 
1093     function _getChainId() private view returns (uint256 chainId) {
1094         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1095         // solhint-disable-next-line no-inline-assembly
1096         assembly {
1097             chainId := chainid()
1098         }
1099     }
1100 }
1101 
1102 
1103 // File contracts/helpers/ECDSA.sol
1104 
1105 
1106 pragma solidity ^0.7.6;
1107 
1108 /**
1109  * @dev Simplified copy of OpenZeppelin ECDSA library downgraded to 0.7.6
1110  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/541e82144f691aa171c53ba8c3b32ef7f05b99a5/contracts/utils/cryptography/ECDSA.sol
1111  *
1112  * Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1113  *
1114  * These functions can be used to verify that a message was signed by the holder
1115  * of the private keys of a given address.
1116  */
1117 library ECDSA {
1118     /**
1119      * @dev Returns the address that signed a hashed message (`hash`) with
1120      * `signature` or error string. This address can then be used for verification purposes.
1121      *
1122      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1123      * this function rejects them by requiring the `s` value to be in the lower
1124      * half order, and the `v` value to be either 27 or 28.
1125      *
1126      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1127      * verification to be secure: it is possible to craft signatures that
1128      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1129      * this is by receiving a hash of the original message (which may otherwise
1130      * be too long), and then calling {toEthSignedMessageHash} on it.
1131      *
1132      * Documentation for signature generation:
1133      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1134      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1135      *
1136      * _Available since v4.3._
1137      */
1138     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1139         // Check the signature length
1140         // - case 65: r,s,v signature (standard)
1141         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1142         if (signature.length == 65) {
1143             bytes32 r;
1144             bytes32 s;
1145             uint8 v;
1146             // ecrecover takes the signature parameters, and the only way to get them
1147             // currently is to use assembly.
1148             assembly {  // solhint-disable-line no-inline-assembly
1149                 r := mload(add(signature, 0x20))
1150                 s := mload(add(signature, 0x40))
1151                 v := byte(0, mload(add(signature, 0x60)))
1152             }
1153             return tryRecover(hash, v, r, s);
1154         } else if (signature.length == 64) {
1155             bytes32 r;
1156             bytes32 vs;
1157             // ecrecover takes the signature parameters, and the only way to get them
1158             // currently is to use assembly.
1159             assembly {  // solhint-disable-line no-inline-assembly
1160                 r := mload(add(signature, 0x20))
1161                 vs := mload(add(signature, 0x40))
1162             }
1163             return tryRecover(hash, r, vs);
1164         } else {
1165             return address(0);
1166         }
1167     }
1168 
1169     /**
1170      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1171      *
1172      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1173      *
1174      * _Available since v4.3._
1175      */
1176     function tryRecover(
1177         bytes32 hash,
1178         bytes32 r,
1179         bytes32 vs
1180     ) internal pure returns (address) {
1181         bytes32 s;
1182         uint8 v;
1183         assembly {  // solhint-disable-line no-inline-assembly
1184             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1185             v := add(shr(255, vs), 27)
1186         }
1187         return tryRecover(hash, v, r, s);
1188     }
1189 
1190     /**
1191      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1192      * `r` and `s` signature fields separately.
1193      *
1194      * _Available since v4.3._
1195      */
1196     function tryRecover(
1197         bytes32 hash,
1198         uint8 v,
1199         bytes32 r,
1200         bytes32 s
1201     ) internal pure returns (address) {
1202         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1203         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1204         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1205         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1206         //
1207         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1208         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1209         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1210         // these malleable signatures as well.
1211         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1212             return address(0);
1213         }
1214         if (v != 27 && v != 28) {
1215             return address(0);
1216         }
1217 
1218         // If the signature is valid (and not malleable), return the signer address
1219         address signer = ecrecover(hash, v, r, s);
1220         if (signer == address(0)) {
1221             return address(0);
1222         }
1223 
1224         return signer;
1225     }
1226 }
1227 
1228 
1229 // File contracts/interfaces/IERC1271.sol
1230 
1231 
1232 pragma solidity ^0.7.6;
1233 
1234 /**
1235  * @dev Interface of the ERC1271 standard signature validation method for
1236  * contracts as defined in https://eips.ethereum.org/EIPS/eip-1271[ERC-1271].
1237  */
1238 interface IERC1271 {
1239     /**
1240      * @dev Should return whether the signature provided is valid for the provided data
1241      * @param hash      Hash of the data to be signed
1242      * @param signature Signature byte array associated with _data
1243      */
1244     function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
1245 }
1246 
1247 
1248 // File contracts/interfaces/IWETH.sol
1249 
1250 
1251 pragma solidity ^0.7.6;
1252 
1253 /// @title Interface for WETH tokens
1254 interface IWETH is IERC20 {
1255     function deposit() external payable;
1256     function withdraw(uint256 amount) external;
1257 }
1258 
1259 
1260 // File contracts/LimitOrderProtocolRFQ.sol
1261 
1262 
1263 pragma solidity ^0.7.6;
1264 pragma abicoder v2;
1265 
1266 
1267 
1268 
1269 
1270 
1271 
1272 contract LimitOrderProtocolRFQ is EthReceiver, EIP712("1inch RFQ", "2"), Permitable {
1273     using SafeMath for uint256;
1274     using SafeERC20 for IERC20;
1275 
1276     event OrderFilledRFQ(
1277         bytes32 orderHash,
1278         uint256 makingAmount
1279     );
1280 
1281     struct OrderRFQ {
1282         // lowest 64 bits is the order id, next 64 bits is the expiration timestamp
1283         // highest bit is unwrap WETH flag which is set on taker's side
1284         // [unwrap eth(1 bit) | unused (127 bits) | expiration timestamp(64 bits) | orderId (64 bits)]
1285         uint256 info;
1286         IERC20 makerAsset;
1287         IERC20 takerAsset;
1288         address maker;
1289         address allowedSender;  // equals to Zero address on public orders
1290         uint256 makingAmount;
1291         uint256 takingAmount;
1292     }
1293 
1294     bytes32 constant public LIMIT_ORDER_RFQ_TYPEHASH = keccak256(
1295         "OrderRFQ(uint256 info,address makerAsset,address takerAsset,address maker,address allowedSender,uint256 makingAmount,uint256 takingAmount)"
1296     );
1297     uint256 private constant _UNWRAP_WETH_MASK = 1 << 255;
1298 
1299     IWETH private immutable _WETH;  // solhint-disable-line var-name-mixedcase
1300     mapping(address => mapping(uint256 => uint256)) private _invalidator;
1301 
1302     constructor(address weth) {
1303         _WETH = IWETH(weth);
1304     }
1305 
1306     // solhint-disable-next-line func-name-mixedcase
1307     function DOMAIN_SEPARATOR() external view returns(bytes32) {
1308         return _domainSeparatorV4();
1309     }
1310 
1311     /// @notice Returns bitmask for double-spend invalidators based on lowest byte of order.info and filled quotes
1312     /// @return Result Each bit represents whenever corresponding quote was filled
1313     function invalidatorForOrderRFQ(address maker, uint256 slot) external view returns(uint256) {
1314         return _invalidator[maker][slot];
1315     }
1316 
1317     /// @notice Cancels order's quote
1318     function cancelOrderRFQ(uint256 orderInfo) external {
1319         _invalidateOrder(msg.sender, orderInfo);
1320     }
1321 
1322     /// @notice Fills order's quote, fully or partially (whichever is possible)
1323     /// @param order Order quote to fill
1324     /// @param signature Signature to confirm quote ownership
1325     /// @param makingAmount Making amount
1326     /// @param takingAmount Taking amount
1327     function fillOrderRFQ(
1328         OrderRFQ memory order,
1329         bytes calldata signature,
1330         uint256 makingAmount,
1331         uint256 takingAmount
1332     ) external payable returns(uint256 /* actualMakingAmount */, uint256 /* actualTakingAmount */) {
1333         return fillOrderRFQTo(order, signature, makingAmount, takingAmount, payable(msg.sender));
1334     }
1335 
1336     /// @notice Fills Same as `fillOrderRFQ` but calls permit first,
1337     /// allowing to approve token spending and make a swap in one transaction.
1338     /// Also allows to specify funds destination instead of `msg.sender`
1339     /// @param order Order quote to fill
1340     /// @param signature Signature to confirm quote ownership
1341     /// @param makingAmount Making amount
1342     /// @param takingAmount Taking amount
1343     /// @param target Address that will receive swap funds
1344     /// @param permit Should consist of abiencoded token address and encoded `IERC20Permit.permit` call.
1345     /// See tests for examples
1346     function fillOrderRFQToWithPermit(
1347         OrderRFQ memory order,
1348         bytes calldata signature,
1349         uint256 makingAmount,
1350         uint256 takingAmount,
1351         address payable target,
1352         bytes calldata permit
1353     ) external returns(uint256 /* actualMakingAmount */, uint256 /* actualTakingAmount */) {
1354         _permit(address(order.takerAsset), permit);
1355         return fillOrderRFQTo(order, signature, makingAmount, takingAmount, target);
1356     }
1357 
1358     /// @notice Same as `fillOrderRFQ` but allows to specify funds destination instead of `msg.sender`
1359     /// @param order Order quote to fill
1360     /// @param signature Signature to confirm quote ownership
1361     /// @param makingAmount Making amount
1362     /// @param takingAmount Taking amount
1363     /// @param target Address that will receive swap funds
1364     function fillOrderRFQTo(
1365         OrderRFQ memory order,
1366         bytes calldata signature,
1367         uint256 makingAmount,
1368         uint256 takingAmount,
1369         address payable target
1370     ) public payable returns(uint256 /* actualMakingAmount */, uint256 /* actualTakingAmount */) {
1371         address maker = order.maker;
1372         bool unwrapWETH = (order.info & _UNWRAP_WETH_MASK) > 0;
1373         order.info = order.info & (_UNWRAP_WETH_MASK - 1);  // zero-out unwrap weth flag as it is taker-only
1374         {  // Stack too deep
1375             uint256 info = order.info;
1376             // Check time expiration
1377             uint256 expiration = uint128(info) >> 64;
1378             require(expiration == 0 || block.timestamp <= expiration, "LOP: order expired");  // solhint-disable-line not-rely-on-time
1379             _invalidateOrder(maker, info);
1380         }
1381 
1382         {  // stack too deep
1383             uint256 orderMakingAmount = order.makingAmount;
1384             uint256 orderTakingAmount = order.takingAmount;
1385             // Compute partial fill if needed
1386             if (takingAmount == 0 && makingAmount == 0) {
1387                 // Two zeros means whole order
1388                 makingAmount = orderMakingAmount;
1389                 takingAmount = orderTakingAmount;
1390             }
1391             else if (takingAmount == 0) {
1392                 require(makingAmount <= orderMakingAmount, "LOP: making amount exceeded");
1393                 takingAmount = orderTakingAmount.mul(makingAmount).add(orderMakingAmount - 1).div(orderMakingAmount);
1394             }
1395             else if (makingAmount == 0) {
1396                 require(takingAmount <= orderTakingAmount, "LOP: taking amount exceeded");
1397                 makingAmount = orderMakingAmount.mul(takingAmount).div(orderTakingAmount);
1398             }
1399             else {
1400                 revert("LOP: one of amounts should be 0");
1401             }
1402         }
1403 
1404         require(makingAmount > 0 && takingAmount > 0, "LOP: can't swap 0 amount");
1405 
1406         // Validate order
1407         require(order.allowedSender == address(0) || order.allowedSender == msg.sender, "LOP: private order");
1408         bytes32 orderHash = _hashTypedDataV4(keccak256(abi.encode(LIMIT_ORDER_RFQ_TYPEHASH, order)));
1409         _validate(maker, orderHash, signature);
1410 
1411         // Maker => Taker
1412         if (order.makerAsset == _WETH && unwrapWETH) {
1413             order.makerAsset.safeTransferFrom(maker, address(this), makingAmount);
1414             _WETH.withdraw(makingAmount);
1415             target.transfer(makingAmount);
1416         } else {
1417             order.makerAsset.safeTransferFrom(maker, target, makingAmount);
1418         }
1419         // Taker => Maker
1420         if (order.takerAsset == _WETH && msg.value > 0) {
1421             require(msg.value == takingAmount, "LOP: wrong msg.value");
1422             _WETH.deposit{ value: takingAmount }();
1423             _WETH.transfer(maker, takingAmount);
1424         } else {
1425             require(msg.value == 0, "LOP: wrong msg.value");
1426             order.takerAsset.safeTransferFrom(msg.sender, maker, takingAmount);
1427         }
1428 
1429         emit OrderFilledRFQ(orderHash, makingAmount);
1430         return (makingAmount, takingAmount);
1431     }
1432 
1433     function _validate(address signer, bytes32 orderHash, bytes calldata signature) private view {
1434         if (ECDSA.tryRecover(orderHash, signature) != signer) {
1435             (bool success, bytes memory result) = signer.staticcall(
1436                 abi.encodeWithSelector(IERC1271.isValidSignature.selector, orderHash, signature)
1437             );
1438             require(success && result.length == 32 && abi.decode(result, (bytes4)) == IERC1271.isValidSignature.selector, "LOP: bad signature");
1439         }
1440     }
1441 
1442     function _invalidateOrder(address maker, uint256 orderInfo) private {
1443         uint256 invalidatorSlot = uint64(orderInfo) >> 8;
1444         uint256 invalidatorBit = 1 << uint8(orderInfo);
1445         mapping(uint256 => uint256) storage invalidatorStorage = _invalidator[maker];
1446         uint256 invalidator = invalidatorStorage[invalidatorSlot];
1447         require(invalidator & invalidatorBit == 0, "LOP: invalidated order");
1448         invalidatorStorage[invalidatorSlot] = invalidator | invalidatorBit;
1449     }
1450 }
1451 
1452 
1453 // File contracts/UnoswapRouter.sol
1454 
1455 
1456 pragma solidity ^0.7.6;
1457 
1458 
1459 
1460 contract UnoswapRouter is EthReceiver, Permitable {
1461     uint256 private constant _TRANSFER_FROM_CALL_SELECTOR_32 = 0x23b872dd00000000000000000000000000000000000000000000000000000000;
1462     uint256 private constant _WETH_DEPOSIT_CALL_SELECTOR_32 = 0xd0e30db000000000000000000000000000000000000000000000000000000000;
1463     uint256 private constant _WETH_WITHDRAW_CALL_SELECTOR_32 = 0x2e1a7d4d00000000000000000000000000000000000000000000000000000000;
1464     uint256 private constant _ERC20_TRANSFER_CALL_SELECTOR_32 = 0xa9059cbb00000000000000000000000000000000000000000000000000000000;
1465     uint256 private constant _ADDRESS_MASK =   0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff;
1466     uint256 private constant _REVERSE_MASK =   0x8000000000000000000000000000000000000000000000000000000000000000;
1467     uint256 private constant _WETH_MASK =      0x4000000000000000000000000000000000000000000000000000000000000000;
1468     uint256 private constant _NUMERATOR_MASK = 0x0000000000000000ffffffff0000000000000000000000000000000000000000;
1469     /// @dev WETH address is network-specific and needs to be changed before deployment.
1470     /// It can not be moved to immutable as immutables are not supported in assembly
1471     uint256 private constant _WETH = 0x000000000000000000000000C02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1472     uint256 private constant _UNISWAP_PAIR_RESERVES_CALL_SELECTOR_32 = 0x0902f1ac00000000000000000000000000000000000000000000000000000000;
1473     uint256 private constant _UNISWAP_PAIR_SWAP_CALL_SELECTOR_32 = 0x022c0d9f00000000000000000000000000000000000000000000000000000000;
1474     uint256 private constant _DENOMINATOR = 1000000000;
1475     uint256 private constant _NUMERATOR_OFFSET = 160;
1476 
1477     /// @notice Same as `unoswap` but calls permit first,
1478     /// allowing to approve token spending and make a swap in one transaction.
1479     /// @param srcToken Source token
1480     /// @param amount Amount of source tokens to swap
1481     /// @param minReturn Minimal allowed returnAmount to make transaction commit
1482     /// @param pools Pools chain used for swaps. Pools src and dst tokens should match to make swap happen
1483     /// @param permit Should contain valid permit that can be used in `IERC20Permit.permit` calls.
1484     /// See tests for examples
1485     function unoswapWithPermit(
1486         IERC20 srcToken,
1487         uint256 amount,
1488         uint256 minReturn,
1489         bytes32[] calldata pools,
1490         bytes calldata permit
1491     ) external returns(uint256 returnAmount) {
1492         _permit(address(srcToken), permit);
1493         return unoswap(srcToken, amount, minReturn, pools);
1494     }
1495 
1496     /// @notice Performs swap using Uniswap exchange. Wraps and unwraps ETH if required.
1497     /// Sending non-zero `msg.value` for anything but ETH swaps is prohibited
1498     /// @param srcToken Source token
1499     /// @param amount Amount of source tokens to swap
1500     /// @param minReturn Minimal allowed returnAmount to make transaction commit
1501     /// @param pools Pools chain used for swaps. Pools src and dst tokens should match to make swap happen
1502     function unoswap(
1503         IERC20 srcToken,
1504         uint256 amount,
1505         uint256 minReturn,
1506         // solhint-disable-next-line no-unused-vars
1507         bytes32[] calldata pools
1508     ) public payable returns(uint256 returnAmount) {
1509         assembly {  // solhint-disable-line no-inline-assembly
1510             function reRevert() {
1511                 returndatacopy(0, 0, returndatasize())
1512                 revert(0, returndatasize())
1513             }
1514 
1515             function revertWithReason(m, len) {
1516                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
1517                 mstore(0x20, 0x0000002000000000000000000000000000000000000000000000000000000000)
1518                 mstore(0x40, m)
1519                 revert(0, len)
1520             }
1521 
1522             function swap(emptyPtr, swapAmount, pair, reversed, numerator, dst) -> ret {
1523                 mstore(emptyPtr, _UNISWAP_PAIR_RESERVES_CALL_SELECTOR_32)
1524                 if iszero(staticcall(gas(), pair, emptyPtr, 0x4, emptyPtr, 0x40)) {
1525                     reRevert()
1526                 }
1527                 if iszero(eq(returndatasize(), 0x60)) {
1528                     revertWithReason(0x0000001472657365727665732063616c6c206661696c65640000000000000000, 0x59)  // "reserves call failed"
1529                 }
1530 
1531                 let reserve0 := mload(emptyPtr)
1532                 let reserve1 := mload(add(emptyPtr, 0x20))
1533                 if reversed {
1534                     let tmp := reserve0
1535                     reserve0 := reserve1
1536                     reserve1 := tmp
1537                 }
1538                 ret := mul(swapAmount, numerator)
1539                 ret := div(mul(ret, reserve1), add(ret, mul(reserve0, _DENOMINATOR)))
1540 
1541                 mstore(emptyPtr, _UNISWAP_PAIR_SWAP_CALL_SELECTOR_32)
1542                 switch reversed
1543                 case 0 {
1544                     mstore(add(emptyPtr, 0x04), 0)
1545                     mstore(add(emptyPtr, 0x24), ret)
1546                 }
1547                 default {
1548                     mstore(add(emptyPtr, 0x04), ret)
1549                     mstore(add(emptyPtr, 0x24), 0)
1550                 }
1551                 mstore(add(emptyPtr, 0x44), dst)
1552                 mstore(add(emptyPtr, 0x64), 0x80)
1553                 mstore(add(emptyPtr, 0x84), 0)
1554                 if iszero(call(gas(), pair, 0, emptyPtr, 0xa4, 0, 0)) {
1555                     reRevert()
1556                 }
1557             }
1558 
1559             let emptyPtr := mload(0x40)
1560             mstore(0x40, add(emptyPtr, 0xc0))
1561 
1562             let poolsOffset := add(calldataload(0x64), 0x4)
1563             let poolsEndOffset := calldataload(poolsOffset)
1564             poolsOffset := add(poolsOffset, 0x20)
1565             poolsEndOffset := add(poolsOffset, mul(0x20, poolsEndOffset))
1566             let rawPair := calldataload(poolsOffset)
1567             switch srcToken
1568             case 0 {
1569                 if iszero(eq(amount, callvalue())) {
1570                     revertWithReason(0x00000011696e76616c6964206d73672e76616c75650000000000000000000000, 0x55)  // "invalid msg.value"
1571                 }
1572 
1573                 mstore(emptyPtr, _WETH_DEPOSIT_CALL_SELECTOR_32)
1574                 if iszero(call(gas(), _WETH, amount, emptyPtr, 0x4, 0, 0)) {
1575                     reRevert()
1576                 }
1577 
1578                 mstore(emptyPtr, _ERC20_TRANSFER_CALL_SELECTOR_32)
1579                 mstore(add(emptyPtr, 0x4), and(rawPair, _ADDRESS_MASK))
1580                 mstore(add(emptyPtr, 0x24), amount)
1581                 if iszero(call(gas(), _WETH, 0, emptyPtr, 0x44, 0, 0)) {
1582                     reRevert()
1583                 }
1584             }
1585             default {
1586                 if callvalue() {
1587                     revertWithReason(0x00000011696e76616c6964206d73672e76616c75650000000000000000000000, 0x55)  // "invalid msg.value"
1588                 }
1589 
1590                 mstore(emptyPtr, _TRANSFER_FROM_CALL_SELECTOR_32)
1591                 mstore(add(emptyPtr, 0x4), caller())
1592                 mstore(add(emptyPtr, 0x24), and(rawPair, _ADDRESS_MASK))
1593                 mstore(add(emptyPtr, 0x44), amount)
1594                 if iszero(call(gas(), srcToken, 0, emptyPtr, 0x64, 0, 0)) {
1595                     reRevert()
1596                 }
1597             }
1598 
1599             returnAmount := amount
1600 
1601             for {let i := add(poolsOffset, 0x20)} lt(i, poolsEndOffset) {i := add(i, 0x20)} {
1602                 let nextRawPair := calldataload(i)
1603 
1604                 returnAmount := swap(
1605                     emptyPtr,
1606                     returnAmount,
1607                     and(rawPair, _ADDRESS_MASK),
1608                     and(rawPair, _REVERSE_MASK),
1609                     shr(_NUMERATOR_OFFSET, and(rawPair, _NUMERATOR_MASK)),
1610                     and(nextRawPair, _ADDRESS_MASK)
1611                 )
1612 
1613                 rawPair := nextRawPair
1614             }
1615 
1616             switch and(rawPair, _WETH_MASK)
1617             case 0 {
1618                 returnAmount := swap(
1619                     emptyPtr,
1620                     returnAmount,
1621                     and(rawPair, _ADDRESS_MASK),
1622                     and(rawPair, _REVERSE_MASK),
1623                     shr(_NUMERATOR_OFFSET, and(rawPair, _NUMERATOR_MASK)),
1624                     caller()
1625                 )
1626             }
1627             default {
1628                 returnAmount := swap(
1629                     emptyPtr,
1630                     returnAmount,
1631                     and(rawPair, _ADDRESS_MASK),
1632                     and(rawPair, _REVERSE_MASK),
1633                     shr(_NUMERATOR_OFFSET, and(rawPair, _NUMERATOR_MASK)),
1634                     address()
1635                 )
1636 
1637                 mstore(emptyPtr, _WETH_WITHDRAW_CALL_SELECTOR_32)
1638                 mstore(add(emptyPtr, 0x04), returnAmount)
1639                 if iszero(call(gas(), _WETH, 0, emptyPtr, 0x24, 0, 0)) {
1640                     reRevert()
1641                 }
1642 
1643                 if iszero(call(gas(), caller(), returnAmount, 0, 0, 0, 0)) {
1644                     reRevert()
1645                 }
1646             }
1647 
1648             if lt(returnAmount, minReturn) {
1649                 revertWithReason(0x000000164d696e2072657475726e206e6f742072656163686564000000000000, 0x5a)  // "Min return not reached"
1650             }
1651         }
1652     }
1653 }
1654 
1655 
1656 // File @openzeppelin/contracts/utils/SafeCast.sol@v3.4.2-solc-0.7
1657 
1658 
1659 pragma solidity ^0.7.0;
1660 
1661 
1662 /**
1663  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1664  * checks.
1665  *
1666  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1667  * easily result in undesired exploitation or bugs, since developers usually
1668  * assume that overflows raise errors. `SafeCast` restores this intuition by
1669  * reverting the transaction when such an operation overflows.
1670  *
1671  * Using this library instead of the unchecked operations eliminates an entire
1672  * class of bugs, so it's recommended to use it always.
1673  *
1674  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1675  * all math on `uint256` and `int256` and then downcasting.
1676  */
1677 library SafeCast {
1678 
1679     /**
1680      * @dev Returns the downcasted uint128 from uint256, reverting on
1681      * overflow (when the input is greater than largest uint128).
1682      *
1683      * Counterpart to Solidity's `uint128` operator.
1684      *
1685      * Requirements:
1686      *
1687      * - input must fit into 128 bits
1688      */
1689     function toUint128(uint256 value) internal pure returns (uint128) {
1690         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
1691         return uint128(value);
1692     }
1693 
1694     /**
1695      * @dev Returns the downcasted uint64 from uint256, reverting on
1696      * overflow (when the input is greater than largest uint64).
1697      *
1698      * Counterpart to Solidity's `uint64` operator.
1699      *
1700      * Requirements:
1701      *
1702      * - input must fit into 64 bits
1703      */
1704     function toUint64(uint256 value) internal pure returns (uint64) {
1705         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
1706         return uint64(value);
1707     }
1708 
1709     /**
1710      * @dev Returns the downcasted uint32 from uint256, reverting on
1711      * overflow (when the input is greater than largest uint32).
1712      *
1713      * Counterpart to Solidity's `uint32` operator.
1714      *
1715      * Requirements:
1716      *
1717      * - input must fit into 32 bits
1718      */
1719     function toUint32(uint256 value) internal pure returns (uint32) {
1720         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
1721         return uint32(value);
1722     }
1723 
1724     /**
1725      * @dev Returns the downcasted uint16 from uint256, reverting on
1726      * overflow (when the input is greater than largest uint16).
1727      *
1728      * Counterpart to Solidity's `uint16` operator.
1729      *
1730      * Requirements:
1731      *
1732      * - input must fit into 16 bits
1733      */
1734     function toUint16(uint256 value) internal pure returns (uint16) {
1735         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
1736         return uint16(value);
1737     }
1738 
1739     /**
1740      * @dev Returns the downcasted uint8 from uint256, reverting on
1741      * overflow (when the input is greater than largest uint8).
1742      *
1743      * Counterpart to Solidity's `uint8` operator.
1744      *
1745      * Requirements:
1746      *
1747      * - input must fit into 8 bits.
1748      */
1749     function toUint8(uint256 value) internal pure returns (uint8) {
1750         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
1751         return uint8(value);
1752     }
1753 
1754     /**
1755      * @dev Converts a signed int256 into an unsigned uint256.
1756      *
1757      * Requirements:
1758      *
1759      * - input must be greater than or equal to 0.
1760      */
1761     function toUint256(int256 value) internal pure returns (uint256) {
1762         require(value >= 0, "SafeCast: value must be positive");
1763         return uint256(value);
1764     }
1765 
1766     /**
1767      * @dev Returns the downcasted int128 from int256, reverting on
1768      * overflow (when the input is less than smallest int128 or
1769      * greater than largest int128).
1770      *
1771      * Counterpart to Solidity's `int128` operator.
1772      *
1773      * Requirements:
1774      *
1775      * - input must fit into 128 bits
1776      *
1777      * _Available since v3.1._
1778      */
1779     function toInt128(int256 value) internal pure returns (int128) {
1780         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
1781         return int128(value);
1782     }
1783 
1784     /**
1785      * @dev Returns the downcasted int64 from int256, reverting on
1786      * overflow (when the input is less than smallest int64 or
1787      * greater than largest int64).
1788      *
1789      * Counterpart to Solidity's `int64` operator.
1790      *
1791      * Requirements:
1792      *
1793      * - input must fit into 64 bits
1794      *
1795      * _Available since v3.1._
1796      */
1797     function toInt64(int256 value) internal pure returns (int64) {
1798         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
1799         return int64(value);
1800     }
1801 
1802     /**
1803      * @dev Returns the downcasted int32 from int256, reverting on
1804      * overflow (when the input is less than smallest int32 or
1805      * greater than largest int32).
1806      *
1807      * Counterpart to Solidity's `int32` operator.
1808      *
1809      * Requirements:
1810      *
1811      * - input must fit into 32 bits
1812      *
1813      * _Available since v3.1._
1814      */
1815     function toInt32(int256 value) internal pure returns (int32) {
1816         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
1817         return int32(value);
1818     }
1819 
1820     /**
1821      * @dev Returns the downcasted int16 from int256, reverting on
1822      * overflow (when the input is less than smallest int16 or
1823      * greater than largest int16).
1824      *
1825      * Counterpart to Solidity's `int16` operator.
1826      *
1827      * Requirements:
1828      *
1829      * - input must fit into 16 bits
1830      *
1831      * _Available since v3.1._
1832      */
1833     function toInt16(int256 value) internal pure returns (int16) {
1834         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
1835         return int16(value);
1836     }
1837 
1838     /**
1839      * @dev Returns the downcasted int8 from int256, reverting on
1840      * overflow (when the input is less than smallest int8 or
1841      * greater than largest int8).
1842      *
1843      * Counterpart to Solidity's `int8` operator.
1844      *
1845      * Requirements:
1846      *
1847      * - input must fit into 8 bits.
1848      *
1849      * _Available since v3.1._
1850      */
1851     function toInt8(int256 value) internal pure returns (int8) {
1852         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
1853         return int8(value);
1854     }
1855 
1856     /**
1857      * @dev Converts an unsigned uint256 into a signed int256.
1858      *
1859      * Requirements:
1860      *
1861      * - input must be less than or equal to maxInt256.
1862      */
1863     function toInt256(uint256 value) internal pure returns (int256) {
1864         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
1865         return int256(value);
1866     }
1867 }
1868 
1869 
1870 // File contracts/interfaces/IUniswapV3Pool.sol
1871 
1872 pragma solidity ^0.7.6;
1873 
1874 interface IUniswapV3Pool {
1875     /// @notice Swap token0 for token1, or token1 for token0
1876     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
1877     /// @param recipient The address to receive the output of the swap
1878     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
1879     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
1880     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
1881     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
1882     /// @param data Any data to be passed through to the callback
1883     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
1884     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
1885     function swap(
1886         address recipient,
1887         bool zeroForOne,
1888         int256 amountSpecified,
1889         uint160 sqrtPriceLimitX96,
1890         bytes calldata data
1891     ) external returns (int256 amount0, int256 amount1);
1892 
1893     /// @notice The first of the two tokens of the pool, sorted by address
1894     /// @return The token contract address
1895     function token0() external view returns (address);
1896 
1897     /// @notice The second of the two tokens of the pool, sorted by address
1898     /// @return The token contract address
1899     function token1() external view returns (address);
1900 
1901     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
1902     /// @return The fee
1903     function fee() external view returns (uint24);
1904 }
1905 
1906 
1907 // File contracts/interfaces/IUniswapV3SwapCallback.sol
1908 
1909 pragma solidity ^0.7.6;
1910 
1911 /// @title Callback for IUniswapV3PoolActions#swap
1912 /// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
1913 interface IUniswapV3SwapCallback {
1914     /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
1915     /// @dev In the implementation you must pay the pool tokens owed for the swap.
1916     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
1917     /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
1918     /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
1919     /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
1920     /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
1921     /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
1922     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
1923     function uniswapV3SwapCallback(
1924         int256 amount0Delta,
1925         int256 amount1Delta,
1926         bytes calldata data
1927     ) external;
1928 }
1929 
1930 
1931 // File contracts/UnoswapV3Router.sol
1932 
1933 
1934 pragma solidity ^0.7.6;
1935 
1936 
1937 
1938 
1939 
1940 
1941 
1942 
1943 
1944 contract UnoswapV3Router is EthReceiver, Permitable, IUniswapV3SwapCallback {
1945     using Address for address payable;
1946     using SafeERC20 for IERC20;
1947     using SafeMath for uint256;
1948 
1949     uint256 private constant _ONE_FOR_ZERO_MASK = 1 << 255;
1950     uint256 private constant _WETH_WRAP_MASK = 1 << 254;
1951     uint256 private constant _WETH_UNWRAP_MASK = 1 << 253;
1952     bytes32 private constant _POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
1953     bytes32 private constant _FF_FACTORY = 0xff1F98431c8aD98523631AE4a59f267346ea31F9840000000000000000000000;
1954     bytes32 private constant _SELECTORS = 0x0dfe1681d21220a7ddca3f430000000000000000000000000000000000000000;
1955     uint256 private constant _ADDRESS_MASK =   0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff;
1956     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
1957     uint160 private constant _MIN_SQRT_RATIO = 4295128739 + 1;
1958     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
1959     uint160 private constant _MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342 - 1;
1960     IWETH private immutable _WETH;  // solhint-disable-line var-name-mixedcase
1961 
1962     constructor(address weth) {
1963         _WETH = IWETH(weth);
1964     }
1965 
1966     /// @notice Same as `uniswapV3SwapTo` but calls permit first,
1967     /// allowing to approve token spending and make a swap in one transaction.
1968     /// @param recipient Address that will receive swap funds
1969     /// @param srcToken Source token
1970     /// @param amount Amount of source tokens to swap
1971     /// @param minReturn Minimal allowed returnAmount to make transaction commit
1972     /// @param pools Pools chain used for swaps. Pools src and dst tokens should match to make swap happen
1973     /// @param permit Should contain valid permit that can be used in `IERC20Permit.permit` calls.
1974     /// See tests for examples
1975     function uniswapV3SwapToWithPermit(
1976         address payable recipient,
1977         IERC20 srcToken,
1978         uint256 amount,
1979         uint256 minReturn,
1980         uint256[] calldata pools,
1981         bytes calldata permit
1982     ) external returns(uint256 returnAmount) {
1983         _permit(address(srcToken), permit);
1984         return uniswapV3SwapTo(recipient, amount, minReturn, pools);
1985     }
1986 
1987     /// @notice Same as `uniswapV3SwapTo` but uses `msg.sender` as recipient
1988     /// @param amount Amount of source tokens to swap
1989     /// @param minReturn Minimal allowed returnAmount to make transaction commit
1990     /// @param pools Pools chain used for swaps. Pools src and dst tokens should match to make swap happen
1991     function uniswapV3Swap(
1992         uint256 amount,
1993         uint256 minReturn,
1994         uint256[] calldata pools
1995     ) external payable returns(uint256 returnAmount) {
1996         return uniswapV3SwapTo(msg.sender, amount, minReturn, pools);
1997     }
1998 
1999     /// @notice Performs swap using Uniswap V3 exchange. Wraps and unwraps ETH if required.
2000     /// Sending non-zero `msg.value` for anything but ETH swaps is prohibited
2001     /// @param recipient Address that will receive swap funds
2002     /// @param amount Amount of source tokens to swap
2003     /// @param minReturn Minimal allowed returnAmount to make transaction commit
2004     /// @param pools Pools chain used for swaps. Pools src and dst tokens should match to make swap happen
2005     function uniswapV3SwapTo(
2006         address payable recipient,
2007         uint256 amount,
2008         uint256 minReturn,
2009         uint256[] calldata pools
2010     ) public payable returns(uint256 returnAmount) {
2011         uint256 len = pools.length;
2012         require(len > 0, "UNIV3R: empty pools");
2013         uint256 lastIndex = len - 1;
2014         returnAmount = amount;
2015         bool wrapWeth = pools[0] & _WETH_WRAP_MASK > 0;
2016         bool unwrapWeth = pools[lastIndex] & _WETH_UNWRAP_MASK > 0;
2017         if (wrapWeth) {
2018             require(msg.value == amount, "UNIV3R: wrong msg.value");
2019             _WETH.deposit{value: amount}();
2020         } else {
2021             require(msg.value == 0, "UNIV3R: msg.value should be 0");
2022         }
2023         if (len > 1) {
2024             returnAmount = _makeSwap(address(this), wrapWeth ? address(this) : msg.sender, pools[0], returnAmount);
2025 
2026             for (uint256 i = 1; i < lastIndex; i++) {
2027                 returnAmount = _makeSwap(address(this), address(this), pools[i], returnAmount);
2028             }
2029             returnAmount = _makeSwap(unwrapWeth ? address(this) : recipient, address(this), pools[lastIndex], returnAmount);
2030         } else {
2031             returnAmount = _makeSwap(unwrapWeth ? address(this) : recipient, wrapWeth ? address(this) : msg.sender, pools[0], returnAmount);
2032         }
2033 
2034         require(returnAmount >= minReturn, "UNIV3R: min return");
2035 
2036         if (unwrapWeth) {
2037             _WETH.withdraw(returnAmount);
2038             recipient.sendValue(returnAmount);
2039         }
2040     }
2041 
2042     /// @inheritdoc IUniswapV3SwapCallback
2043     function uniswapV3SwapCallback(
2044         int256 amount0Delta,
2045         int256 amount1Delta,
2046         bytes calldata /* data */
2047     ) external override {
2048         IERC20 token0;
2049         IERC20 token1;
2050         bytes32 ffFactoryAddress = _FF_FACTORY;
2051         bytes32 poolInitCodeHash = _POOL_INIT_CODE_HASH;
2052         address payer;
2053 
2054         assembly {  // solhint-disable-line no-inline-assembly
2055             function reRevert() {
2056                 returndatacopy(0, 0, returndatasize())
2057                 revert(0, returndatasize())
2058             }
2059 
2060             function revertWithReason(m, len) {
2061                 mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
2062                 mstore(0x20, 0x0000002000000000000000000000000000000000000000000000000000000000)
2063                 mstore(0x40, m)
2064                 revert(0, len)
2065             }
2066 
2067             let emptyPtr := mload(0x40)
2068             let resultPtr := add(emptyPtr, 0x20)
2069             mstore(emptyPtr, _SELECTORS)
2070 
2071             if iszero(staticcall(gas(), caller(), emptyPtr, 0x4, resultPtr, 0x20)) {
2072                 reRevert()
2073             }
2074             token0 := mload(resultPtr)
2075             if iszero(staticcall(gas(), caller(), add(emptyPtr, 0x4), 0x4, resultPtr, 0x20)) {
2076                 reRevert()
2077             }
2078             token1 := mload(resultPtr)
2079             if iszero(staticcall(gas(), caller(), add(emptyPtr, 0x8), 0x4, resultPtr, 0x20)) {
2080                 reRevert()
2081             }
2082             let fee := mload(resultPtr)
2083 
2084             let p := emptyPtr
2085             mstore(p, ffFactoryAddress)
2086             p := add(p, 21)
2087             // Compute the inner hash in-place
2088             mstore(p, token0)
2089             mstore(add(p, 32), token1)
2090             mstore(add(p, 64), fee)
2091             mstore(p, keccak256(p, 96))
2092             p := add(p, 32)
2093             mstore(p, poolInitCodeHash)
2094             let pool := and(keccak256(emptyPtr, 85), _ADDRESS_MASK)
2095 
2096             if iszero(eq(pool, caller())) {
2097                 revertWithReason(0x00000010554e495633523a2062616420706f6f6c000000000000000000000000, 0x54)  // UNIV3R: bad pool
2098             }
2099 
2100             calldatacopy(emptyPtr, 0x84, 0x20)
2101             payer := mload(emptyPtr)
2102         }
2103 
2104         if (amount0Delta > 0) {
2105             if (payer == address(this)) {
2106                 token0.safeTransfer(msg.sender, uint256(amount0Delta));
2107             } else {
2108                 token0.safeTransferFrom(payer, msg.sender, uint256(amount0Delta));
2109             }
2110         }
2111         if (amount1Delta > 0) {
2112             if (payer == address(this)) {
2113                 token1.safeTransfer(msg.sender, uint256(amount1Delta));
2114             } else {
2115                 token1.safeTransferFrom(payer, msg.sender, uint256(amount1Delta));
2116             }
2117         }
2118     }
2119 
2120     function _makeSwap(address recipient, address payer, uint256 pool, uint256 amount) private returns (uint256) {
2121         bool zeroForOne = pool & _ONE_FOR_ZERO_MASK == 0;
2122         if (zeroForOne) {
2123             (, int256 amount1) = IUniswapV3Pool(pool).swap(
2124                 recipient,
2125                 zeroForOne,
2126                 SafeCast.toInt256(amount),
2127                 _MIN_SQRT_RATIO,
2128                 abi.encode(payer)
2129             );
2130             return SafeCast.toUint256(-amount1);
2131         } else {
2132             (int256 amount0,) = IUniswapV3Pool(pool).swap(
2133                 recipient,
2134                 zeroForOne,
2135                 SafeCast.toInt256(amount),
2136                 _MAX_SQRT_RATIO,
2137                 abi.encode(payer)
2138             );
2139             return SafeCast.toUint256(-amount0);
2140         }
2141     }
2142 }
2143 
2144 
2145 // File contracts/interfaces/IClipperExchangeInterface.sol
2146 
2147 
2148 pragma solidity ^0.7.6;
2149 
2150 /// @title Clipper interface subset used in swaps
2151 interface IClipperExchangeInterface {
2152     function sellTokenForToken(IERC20 inputToken, IERC20 outputToken, address recipient, uint256 minBuyAmount, bytes calldata auxiliaryData) external returns (uint256 boughtAmount);
2153     function sellEthForToken(IERC20 outputToken, address recipient, uint256 minBuyAmount, bytes calldata auxiliaryData) external payable returns (uint256 boughtAmount);
2154     function sellTokenForEth(IERC20 inputToken, address payable recipient, uint256 minBuyAmount, bytes calldata auxiliaryData) external returns (uint256 boughtAmount);
2155     function theExchange() external returns (address payable);
2156 }
2157 
2158 
2159 // File contracts/ClipperRouter.sol
2160 
2161 
2162 pragma solidity ^0.7.6;
2163 
2164 
2165 
2166 
2167 
2168 
2169 /// @title Clipper router that allows to use `ClipperExchangeInterface` for swaps
2170 contract ClipperRouter is EthReceiver, Permitable {
2171     using SafeERC20 for IERC20;
2172 
2173     IWETH private immutable _WETH;  // solhint-disable-line var-name-mixedcase
2174     IERC20 private constant _ETH = IERC20(address(0));
2175     bytes private constant _INCH_TAG = "1INCH";
2176     IClipperExchangeInterface private immutable _clipperExchange;
2177     address payable private immutable _clipperPool;
2178 
2179     constructor(
2180         address weth,
2181         IClipperExchangeInterface clipperExchange
2182     ) {
2183         _clipperExchange = clipperExchange;
2184         _clipperPool = clipperExchange.theExchange();
2185         _WETH = IWETH(weth);
2186     }
2187 
2188     /// @notice Same as `clipperSwapTo` but calls permit first,
2189     /// allowing to approve token spending and make a swap in one transaction.
2190     /// @param recipient Address that will receive swap funds
2191     /// @param srcToken Source token
2192     /// @param dstToken Destination token
2193     /// @param amount Amount of source tokens to swap
2194     /// @param minReturn Minimal allowed returnAmount to make transaction commit
2195     /// @param permit Should contain valid permit that can be used in `IERC20Permit.permit` calls.
2196     /// See tests for examples
2197     function clipperSwapToWithPermit(
2198         address payable recipient,
2199         IERC20 srcToken,
2200         IERC20 dstToken,
2201         uint256 amount,
2202         uint256 minReturn,
2203         bytes calldata permit
2204     ) external returns(uint256 returnAmount) {
2205         _permit(address(srcToken), permit);
2206         return clipperSwapTo(recipient, srcToken, dstToken, amount, minReturn);
2207     }
2208 
2209     /// @notice Same as `clipperSwapTo` but uses `msg.sender` as recipient
2210     /// @param srcToken Source token
2211     /// @param dstToken Destination token
2212     /// @param amount Amount of source tokens to swap
2213     /// @param minReturn Minimal allowed returnAmount to make transaction commit
2214     function clipperSwap(
2215         IERC20 srcToken,
2216         IERC20 dstToken,
2217         uint256 amount,
2218         uint256 minReturn
2219     ) external payable returns(uint256 returnAmount) {
2220         return clipperSwapTo(msg.sender, srcToken, dstToken, amount, minReturn);
2221     }
2222 
2223     /// @notice Performs swap using Clipper exchange. Wraps and unwraps ETH if required.
2224     /// Sending non-zero `msg.value` for anything but ETH swaps is prohibited
2225     /// @param recipient Address that will receive swap funds
2226     /// @param srcToken Source token
2227     /// @param dstToken Destination token
2228     /// @param amount Amount of source tokens to swap
2229     /// @param minReturn Minimal allowed returnAmount to make transaction commit
2230     function clipperSwapTo(
2231         address payable recipient,
2232         IERC20 srcToken,
2233         IERC20 dstToken,
2234         uint256 amount,
2235         uint256 minReturn
2236     ) public payable returns(uint256 returnAmount) {
2237         bool srcETH;
2238         if (srcToken == _WETH) {
2239             require(msg.value == 0, "CL1IN: msg.value should be 0");
2240             _WETH.transferFrom(msg.sender, address(this), amount);
2241             _WETH.withdraw(amount);
2242             srcETH = true;
2243         }
2244         else if (srcToken == _ETH) {
2245             require(msg.value == amount, "CL1IN: wrong msg.value");
2246             srcETH = true;
2247         }
2248         else {
2249             require(msg.value == 0, "CL1IN: msg.value should be 0");
2250             srcToken.safeTransferFrom(msg.sender, _clipperPool, amount);
2251         }
2252 
2253         if (srcETH) {
2254             _clipperPool.transfer(amount);
2255             returnAmount = _clipperExchange.sellEthForToken(dstToken, recipient, minReturn, _INCH_TAG);
2256         } else if (dstToken == _WETH) {
2257             returnAmount = _clipperExchange.sellTokenForEth(srcToken, address(this), minReturn, _INCH_TAG);
2258             _WETH.deposit{ value: returnAmount }();
2259             _WETH.transfer(recipient, returnAmount);
2260         } else if (dstToken == _ETH) {
2261             returnAmount = _clipperExchange.sellTokenForEth(srcToken, recipient, minReturn, _INCH_TAG);
2262         } else {
2263             returnAmount = _clipperExchange.sellTokenForToken(srcToken, dstToken, recipient, minReturn, _INCH_TAG);
2264         }
2265     }
2266 }
2267 
2268 
2269 // File contracts/AggregationRouterV4.sol
2270 
2271 
2272 pragma solidity ^0.7.6;
2273 
2274 
2275 
2276 contract AggregationRouterV4 is Ownable, EthReceiver, Permitable, UnoswapRouter, UnoswapV3Router, LimitOrderProtocolRFQ, ClipperRouter {
2277     using SafeMath for uint256;
2278     using UniERC20 for IERC20;
2279     using SafeERC20 for IERC20;
2280 
2281     uint256 private constant _PARTIAL_FILL = 1 << 0;
2282     uint256 private constant _REQUIRES_EXTRA_ETH = 1 << 1;
2283 
2284     struct SwapDescription {
2285         IERC20 srcToken;
2286         IERC20 dstToken;
2287         address payable srcReceiver;
2288         address payable dstReceiver;
2289         uint256 amount;
2290         uint256 minReturnAmount;
2291         uint256 flags;
2292         bytes permit;
2293     }
2294 
2295     constructor(address weth, IClipperExchangeInterface _clipperExchange)
2296         UnoswapV3Router(weth)
2297         LimitOrderProtocolRFQ(weth)
2298         ClipperRouter(weth, _clipperExchange)
2299     {}  // solhint-disable-line no-empty-blocks
2300 
2301     /// @notice Performs a swap, delegating all calls encoded in `data` to `caller`. See tests for usage examples
2302     /// @param caller Aggregation executor that executes calls described in `data`
2303     /// @param desc Swap description
2304     /// @param data Encoded calls that `caller` should execute in between of swaps
2305     /// @return returnAmount Resulting token amount
2306     /// @return spentAmount Source token amount
2307     /// @return gasLeft Gas left
2308     function swap(
2309         IAggregationExecutor caller,
2310         SwapDescription calldata desc,
2311         bytes calldata data
2312     )
2313         external
2314         payable
2315         returns (
2316             uint256 returnAmount,
2317             uint256 spentAmount,
2318             uint256 gasLeft
2319         )
2320     {
2321         require(desc.minReturnAmount > 0, "Min return should not be 0");
2322         require(data.length > 0, "data should not be empty");
2323 
2324         uint256 flags = desc.flags;
2325         IERC20 srcToken = desc.srcToken;
2326         IERC20 dstToken = desc.dstToken;
2327 
2328         bool srcETH = srcToken.isETH();
2329         if (flags & _REQUIRES_EXTRA_ETH != 0) {
2330             require(msg.value > (srcETH ? desc.amount : 0), "Invalid msg.value");
2331         } else {
2332             require(msg.value == (srcETH ? desc.amount : 0), "Invalid msg.value");
2333         }
2334 
2335         if (!srcETH) {
2336             _permit(address(srcToken), desc.permit);
2337             srcToken.safeTransferFrom(msg.sender, desc.srcReceiver, desc.amount);
2338         }
2339 
2340         {
2341             bytes memory callData = abi.encodePacked(caller.callBytes.selector, bytes12(0), msg.sender, data);
2342             // solhint-disable-next-line avoid-low-level-calls
2343             (bool success, bytes memory result) = address(caller).call{value: msg.value}(callData);
2344             if (!success) {
2345                 revert(RevertReasonParser.parse(result, "callBytes failed: "));
2346             }
2347         }
2348 
2349         spentAmount = desc.amount;
2350         returnAmount = dstToken.uniBalanceOf(address(this));
2351 
2352         if (flags & _PARTIAL_FILL != 0) {
2353             uint256 unspentAmount = srcToken.uniBalanceOf(address(this));
2354             if (unspentAmount > 0) {
2355                 spentAmount = spentAmount.sub(unspentAmount);
2356                 srcToken.uniTransfer(msg.sender, unspentAmount);
2357             }
2358             require(returnAmount.mul(desc.amount) >= desc.minReturnAmount.mul(spentAmount), "Return amount is not enough");
2359         } else {
2360             require(returnAmount >= desc.minReturnAmount, "Return amount is not enough");
2361         }
2362 
2363         address payable dstReceiver = (desc.dstReceiver == address(0)) ? msg.sender : desc.dstReceiver;
2364         dstToken.uniTransfer(dstReceiver, returnAmount);
2365 
2366         gasLeft = gasleft();
2367     }
2368 
2369     function rescueFunds(IERC20 token, uint256 amount) external onlyOwner {
2370         token.uniTransfer(msg.sender, amount);
2371     }
2372 
2373     function destroy() external onlyOwner {
2374         selfdestruct(msg.sender);
2375     }
2376 }