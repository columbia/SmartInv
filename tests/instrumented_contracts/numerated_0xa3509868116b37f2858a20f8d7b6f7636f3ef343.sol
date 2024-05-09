1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.20;
4 
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         _transferOwnership(address(0));
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         _transferOwnership(newOwner);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Internal function without access restriction.
91      */
92     function _transferOwnership(address newOwner) internal virtual {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, with an overflow flag.
103      *
104      * _Available since v3.4._
105      */
106     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         unchecked {
108             uint256 c = a + b;
109             if (c < a) return (false, 0);
110             return (true, c);
111         }
112     }
113 
114     /**
115      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
116      *
117      * _Available since v3.4._
118      */
119     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         unchecked {
121             if (b > a) return (false, 0);
122             return (true, a - b);
123         }
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
128      *
129      * _Available since v3.4._
130      */
131     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
132         unchecked {
133             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
134             // benefit is lost if 'b' is also tested.
135             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
136             if (a == 0) return (true, 0);
137             uint256 c = a * b;
138             if (c / a != b) return (false, 0);
139             return (true, c);
140         }
141     }
142 
143     /**
144      * @dev Returns the division of two unsigned integers, with a division by zero flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         unchecked {
150             if (b == 0) return (false, 0);
151             return (true, a / b);
152         }
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
157      *
158      * _Available since v3.4._
159      */
160     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         unchecked {
162             if (b == 0) return (false, 0);
163             return (true, a % b);
164         }
165     }
166 
167     /**
168      * @dev Returns the addition of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `+` operator.
172      *
173      * Requirements:
174      *
175      * - Addition cannot overflow.
176      */
177     function add(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a + b;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting on
183      * overflow (when the result is negative).
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a - b;
193     }
194 
195     /**
196      * @dev Returns the multiplication of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `*` operator.
200      *
201      * Requirements:
202      *
203      * - Multiplication cannot overflow.
204      */
205     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a * b;
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers, reverting on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator.
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a / b;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * reverting when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a % b;
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
241      * overflow (when the result is negative).
242      *
243      * CAUTION: This function is deprecated because it requires allocating memory for the error
244      * message unnecessarily. For custom revert reasons use {trySub}.
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      *
250      * - Subtraction cannot overflow.
251      */
252     function sub(
253         uint256 a,
254         uint256 b,
255         string memory errorMessage
256     ) internal pure returns (uint256) {
257         unchecked {
258             require(b <= a, errorMessage);
259             return a - b;
260         }
261     }
262     function div(
263         uint256 a,
264         uint256 b,
265         string memory errorMessage
266     ) internal pure returns (uint256) {
267         unchecked {
268             require(b > 0, errorMessage);
269             return a / b;
270         }
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * reverting with custom message when dividing by zero.
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {tryMod}.
279      *
280      * Counterpart to Solidity's `%` operator. This function uses a `revert`
281      * opcode (which leaves remaining gas untouched) while Solidity uses an
282      * invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function mod(
289         uint256 a,
290         uint256 b,
291         string memory errorMessage
292     ) internal pure returns (uint256) {
293         unchecked {
294             require(b > 0, errorMessage);
295             return a % b;
296         }
297     }
298 }
299 
300 
301 interface IERC20 {
302     /**
303      * @dev Returns the amount of tokens in existence.
304      */
305     function totalSupply() external view returns (uint256);
306 
307     /**
308      * @dev Returns the amount of tokens owned by `account`.
309      */
310     function balanceOf(address account) external view returns (uint256);
311 
312     /**
313      * @dev Moves `amount` tokens from the caller's account to `recipient`.
314      *
315      * Returns a boolean value indicating whether the operation succeeded.
316      *
317      * Emits a {Transfer} event.
318      */
319     function transfer(address recipient, uint256 amount) external returns (bool);
320 
321     /**
322      * @dev Returns the remaining number of tokens that `spender` will be
323      * allowed to spend on behalf of `owner` through {transferFrom}. This is
324      * zero by default.
325      *
326      * This value changes when {approve} or {transferFrom} are called.
327      */
328     function allowance(address owner, address spender) external view returns (uint256);
329 
330     /**
331      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
332      *
333      * Returns a boolean value indicating whether the operation succeeded.
334      *
335      * IMPORTANT: Beware that changing an allowance with this method brings the risk
336      * that someone may use both the old and the new allowance by unfortunate
337      * transaction ordering. One possible solution to mitigate this race
338      * condition is to first reduce the spender's allowance to 0 and set the
339      * desired value afterwards:
340      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
341      *
342      * Emits an {Approval} event.
343      */
344     function approve(address spender, uint256 amount) external returns (bool);
345 
346     /**
347      * @dev Moves `amount` tokens from `sender` to `recipient` using the
348      * allowance mechanism. `amount` is then deducted from the caller's
349      * allowance.
350      *
351      * Returns a boolean value indicating whether the operation succeeded.
352      *
353      * Emits a {Transfer} event.
354      */
355     function transferFrom(
356         address sender,
357         address recipient,
358         uint256 amount
359     ) external returns (bool);
360 
361     /**
362      * @dev Emitted when `value` tokens are moved from one account (`from`) to
363      * another (`to`).
364      *
365      * Note that `value` may be zero.
366      */
367     event Transfer(address indexed from, address indexed to, uint256 value);
368 
369     /**
370      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
371      * a call to {approve}. `value` is the new allowance.
372      */
373     event Approval(address indexed owner, address indexed spender, uint256 value);
374 }
375 
376 interface IERC20Metadata is IERC20 {
377     /**
378      * @dev Returns the name of the token.
379      */
380     function name() external view returns (string memory);
381 
382     /**
383      * @dev Returns the symbol of the token.
384      */
385     function symbol() external view returns (string memory);
386 
387     /**
388      * @dev Returns the decimals places of the token.
389      */
390     function decimals() external view returns (uint8);
391 }
392 
393 contract GENSO is Context, Ownable, IERC20, IERC20Metadata{
394     using SafeMath for uint256;
395 
396 
397     mapping (address => uint256) private _balances;
398 
399     mapping (address => mapping (address => uint256)) private _allowances;
400 
401     uint256 private _totalSupply;
402     string private _name;
403     string private _symbol;
404     uint8 private _decimals;
405 
406 
407     constructor() {
408         _name = 'Genso';
409         _symbol = 'GENSO';
410         _decimals = 18;
411         _totalSupply = 1_600_000_000 * 1e18;
412 
413         
414         _balances[msg.sender] = _totalSupply;
415 
416         emit Transfer(address(0), msg.sender, _totalSupply);
417     }
418 
419     function name() public view returns (string memory) {
420         return _name;
421     }
422 
423     function symbol() public view returns (string memory) {
424         return _symbol;
425     }
426 
427     function decimals() public view returns (uint8) {
428         return _decimals;
429     }
430 
431     function totalSupply() public view override returns (uint256) {
432         return _totalSupply;
433     }
434 
435     function balanceOf(address account) public view override returns (uint256) {
436         return _balances[account];
437     }
438 
439     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
440         _transfer(_msgSender(), recipient, amount);
441         return true;
442     }
443 
444     function allowance(address owner, address spender) public view virtual override returns (uint256) {
445         return _allowances[owner][spender];
446     }
447 
448     function approve(address spender, uint256 amount) public virtual override returns (bool) {
449         _approve(_msgSender(), spender, amount);
450         return true;
451     }
452 
453     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
454         _transfer(sender, recipient, amount);
455         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
456         return true;
457     }
458 
459     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
461         return true;
462     }
463 
464     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
465         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
466         return true;
467     }
468 
469     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
470         require(sender != address(0), "ERCToken: transfer from the zero address");
471         require(recipient != address(0), "ERCToken: transfer to the zero address");
472 
473         _balances[sender] = _balances[sender].sub(amount, "ERCToken: transfer amount exceeds balance");
474         _balances[recipient] = _balances[recipient].add(amount);
475         emit Transfer(sender, recipient, amount);
476     }
477 
478     function _approve(address owner, address spender, uint256 amount) internal virtual {
479         require(owner != address(0), "ERC20: approve from the dead address");
480         require(spender != address(0), "ERC20: approve to the dead address");
481 
482         _allowances[owner][spender] = amount;
483         emit Approval(owner, spender, amount);
484     }
485 
486 }