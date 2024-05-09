1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21 
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 // SPDX-License-Identifier: MIT
35 
36 pragma solidity ^0.6.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor () internal {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         emit OwnershipTransferred(_owner, newOwner);
98         _owner = newOwner;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/math/SafeMath.sol
103 
104 // SPDX-License-Identifier: MIT
105 
106 pragma solidity ^0.6.0;
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         // Solidity only automatically asserts when dividing by 0
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
258 
259 // SPDX-License-Identifier: MIT
260 
261 pragma solidity ^0.6.0;
262 
263 /**
264  * @dev Interface of the ERC20 standard as defined in the EIP.
265  */
266 interface IERC20 {
267     /**
268      * @dev Returns the amount of tokens in existence.
269      */
270     function totalSupply() external view returns (uint256);
271 
272     /**
273      * @dev Returns the amount of tokens owned by `account`.
274      */
275     function balanceOf(address account) external view returns (uint256);
276 
277     /**
278      * @dev Moves `amount` tokens from the caller's account to `recipient`.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transfer(address recipient, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Returns the remaining number of tokens that `spender` will be
288      * allowed to spend on behalf of `owner` through {transferFrom}. This is
289      * zero by default.
290      *
291      * This value changes when {approve} or {transferFrom} are called.
292      */
293     function allowance(address owner, address spender) external view returns (uint256);
294 
295     /**
296      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
297      *
298      * Returns a boolean value indicating whether the operation succeeded.
299      *
300      * IMPORTANT: Beware that changing an allowance with this method brings the risk
301      * that someone may use both the old and the new allowance by unfortunate
302      * transaction ordering. One possible solution to mitigate this race
303      * condition is to first reduce the spender's allowance to 0 and set the
304      * desired value afterwards:
305      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
306      *
307      * Emits an {Approval} event.
308      */
309     function approve(address spender, uint256 amount) external returns (bool);
310 
311     /**
312      * @dev Moves `amount` tokens from `sender` to `recipient` using the
313      * allowance mechanism. `amount` is then deducted from the caller's
314      * allowance.
315      *
316      * Returns a boolean value indicating whether the operation succeeded.
317      *
318      * Emits a {Transfer} event.
319      */
320     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
321 
322     /**
323      * @dev Emitted when `value` tokens are moved from one account (`from`) to
324      * another (`to`).
325      *
326      * Note that `value` may be zero.
327      */
328     event Transfer(address indexed from, address indexed to, uint256 value);
329 
330     /**
331      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
332      * a call to {approve}. `value` is the new allowance.
333      */
334     event Approval(address indexed owner, address indexed spender, uint256 value);
335 }
336 
337 // File: contracts/Base.sol
338 
339 // SPDX-License-Identifier: MIT
340 pragma solidity 0.6.0;
341 
342 
343 
344 
345 contract Base is IERC20, Ownable {
346     
347     using SafeMath for uint;
348 
349     uint256 private _totalSupply;
350     uint256 private _stockCount;
351     mapping (address => uint256) private _balances;
352     mapping (address => mapping (address => uint256)) private _allowed;
353 
354     mapping (bytes32 => uint256) public stock;
355     address public minter;
356     address public burner;
357 
358     function burn(bytes32 serial) external onlyBurner() {
359         require(serial != 0x00, "Invalid location or serial");
360         uint256 value = stock[serial];
361 
362         require(value > 0, "Invalid stock");
363         require(_balances[owner()] >= value, "Cannot burn more than you own");
364 
365         stock[serial] = 0;
366         _balances[owner()] = _balances[owner()].sub(value);
367 
368         _stockCount = _stockCount.sub(1);
369         _totalSupply = _totalSupply.sub(value);
370 
371         emit Transfer(owner(), address(0), value);
372         emit Burned(serial, value);
373     }
374 
375     function mint(address to, bytes32 serial, uint256 value) external onlyMinter() returns(bool) {
376         require(serial != 0x00, "Invalid location or serial");
377         require(to != address(0), "Invalid to address");
378         require(value > 0, "Amount must be greater than zero");
379 
380         stock[serial] = value;
381         _stockCount = _stockCount.add(1);
382 
383         _totalSupply = _totalSupply.add(value);
384         _balances[to] = _balances[to].add(value);
385 
386         emit Transfer(owner(), to, value);
387         emit Minted(serial, value);
388 
389         return true;
390     }
391 
392     function updateBurner(address who) external onlyOwner() returns (bool) {
393         require(who != address(0), "Invalid address");
394         burner = who;
395         return true;
396     }
397 
398     function updateMinter(address who) external onlyOwner() returns (bool) {
399         require(who != address(0), "Invalid address");
400         minter = who;
401         return true;
402     }
403 
404     function stockCount() public view returns (uint256) {
405         return _stockCount;
406     }
407 
408     //erc20 props
409     function decimals() public pure returns (uint8) {
410         return 4;
411     }
412 
413     function totalSupply() public view override returns (uint256) {
414         return _totalSupply;
415     }
416 
417     function balanceOf(address who) public override view returns (uint256 balance) {
418         balance = _balances[who];
419     }
420 
421     function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {
422         return _allowed[tokenOwner][spender];
423     }
424 
425     function approve(address spender, uint256 value) public override returns (bool) {
426         require(spender != address(0), "Invalid address");
427 
428         _allowed[msg.sender][spender] = value;
429         emit Approval(msg.sender, spender, value);
430         return true;
431     }
432 
433     function transfer(address to, uint256 value) public override returns (bool) {
434         _transfer(msg.sender, to, value);
435         return true;
436     }
437 
438     function transferFrom(address from, address to, uint256 value) public override returns (bool success) {
439         require(to != address(0), "Invalid address");
440 
441         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
442         _transfer(from, to, value);
443 
444         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
445         return true;
446     }
447 
448     function _transfer(address from, address to, uint256 value) internal {
449         require(to != address(0), "Invalid to address");
450         require(from != address(0), "Invalid from address");
451 
452         _balances[from] = _balances[from].sub(value);
453         _balances[to] = _balances[to].add(value);
454 
455         emit Transfer(from, to, value);
456     }
457 
458     event FeeUpdated(uint256 value);
459     event Burned(bytes32 indexed serial, uint value);
460     event Minted(bytes32 indexed serial, uint value);
461 
462     modifier onlyBurner() {
463         require(burner == msg.sender, "Sender is not a burner");
464         _;
465     }
466 
467     modifier onlyMinter() {
468         require(minter == msg.sender, "Sender is not a minter");
469         _;
470     }
471 }
472 
473 // File: contracts/Gold.sol
474 
475 // SPDX-License-Identifier: MIT
476 pragma solidity 0.6.0;
477 
478 
479 contract Gold is Base {
480 
481     function symbol() public pure returns (string memory) {
482         return "AUS";
483     }
484 
485     function name() public pure returns (string memory) {
486         return "Gold Standard";
487     }
488 
489     constructor() public {
490         burner = msg.sender;
491         minter = msg.sender;
492     }
493 }