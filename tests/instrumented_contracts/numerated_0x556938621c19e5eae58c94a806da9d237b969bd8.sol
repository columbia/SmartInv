1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.0;
4 
5 
6 // 
7 interface ILowOrbitPropulsor {
8     function deposit(uint256 amount) external returns (bool);
9     function withdraw(uint256 amount) external returns (bool);
10     function pulse(uint256 fees) external returns (bool);
11 }
12 
13 // 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 // 
89 /*
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
106         return msg.data;
107     }
108 }
109 
110 // 
111 // CAUTION
112 // This version of SafeMath should only be used with Solidity 0.8 or later,
113 // because it relies on the compiler's built in overflow checks.
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations.
116  *
117  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
118  * now has built in overflow checking.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, with an overflow flag.
123      *
124      * _Available since v3.4._
125      */
126     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         unchecked {
128             uint256 c = a + b;
129             if (c < a) return (false, 0);
130             return (true, c);
131         }
132     }
133 
134     /**
135      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
136      *
137      * _Available since v3.4._
138      */
139     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         unchecked {
141             if (b > a) return (false, 0);
142             return (true, a - b);
143         }
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154             // benefit is lost if 'b' is also tested.
155             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156             if (a == 0) return (true, 0);
157             uint256 c = a * b;
158             if (c / a != b) return (false, 0);
159             return (true, c);
160         }
161     }
162 
163     /**
164      * @dev Returns the division of two unsigned integers, with a division by zero flag.
165      *
166      * _Available since v3.4._
167      */
168     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
169         unchecked {
170             if (b == 0) return (false, 0);
171             return (true, a / b);
172         }
173     }
174 
175     /**
176      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
177      *
178      * _Available since v3.4._
179      */
180     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
181         unchecked {
182             if (b == 0) return (false, 0);
183             return (true, a % b);
184         }
185     }
186 
187     /**
188      * @dev Returns the addition of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `+` operator.
192      *
193      * Requirements:
194      *
195      * - Addition cannot overflow.
196      */
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         return a + b;
199     }
200 
201     /**
202      * @dev Returns the subtraction of two unsigned integers, reverting on
203      * overflow (when the result is negative).
204      *
205      * Counterpart to Solidity's `-` operator.
206      *
207      * Requirements:
208      *
209      * - Subtraction cannot overflow.
210      */
211     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a * b;
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers, reverting on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator.
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function div(uint256 a, uint256 b) internal pure returns (uint256) {
240         return a / b;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * reverting when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a % b;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
261      * overflow (when the result is negative).
262      *
263      * CAUTION: This function is deprecated because it requires allocating memory for the error
264      * message unnecessarily. For custom revert reasons use {trySub}.
265      *
266      * Counterpart to Solidity's `-` operator.
267      *
268      * Requirements:
269      *
270      * - Subtraction cannot overflow.
271      */
272     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         unchecked {
274             require(b <= a, errorMessage);
275             return a - b;
276         }
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
281      * division by zero. The result is rounded towards zero.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Counterpart to Solidity's `/` operator. Note: this function uses a
288      * `revert` opcode (which leaves remaining gas untouched) while Solidity
289      * uses an invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         unchecked {
297             require(b > 0, errorMessage);
298             return a / b;
299         }
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * reverting with custom message when dividing by zero.
305      *
306      * CAUTION: This function is deprecated because it requires allocating memory for the error
307      * message unnecessarily. For custom revert reasons use {tryMod}.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         unchecked {
319             require(b > 0, errorMessage);
320             return a % b;
321         }
322     }
323 }
324 
325 // 
326 contract LowOrbitERC20 is Context, IERC20 {
327     using SafeMath for uint256;
328     mapping (address => uint256) private _balances;
329 
330     mapping (address => mapping (address => uint256)) private _allowances;
331 
332     uint256 private _totalSupply;
333 
334     string private _name;
335     string private _symbol;
336     address private _owner;
337     address private _stakingContract;
338     bool _feesActivated = false;
339     bool _burnPaused = false;
340 
341     mapping(address => bool) _excludedFeesAddress;
342 
343     constructor () {
344         _owner = msg.sender;
345         _name = "Low Orbit Crypto Cannon";
346         _symbol = "LOCC";
347 
348         // Give all tokens to the owner
349         _totalSupply = 1000 * (10 ** 18);
350         _balances[msg.sender] += _totalSupply;
351         emit Transfer(address(0), msg.sender, _totalSupply);
352     }
353 
354     modifier onlyOwner() {
355         require(msg.sender == _owner, "LOCC: RESTRICTED_OWNER");
356         _;
357     }
358 
359     function setStakingContract(address newAddr) public onlyOwner returns (bool) {
360         _stakingContract = newAddr;
361         return true;
362     }
363 
364     function setFeesActivated(bool value) public onlyOwner returns (bool) {
365         _feesActivated = value;
366         return true;
367     }
368 
369     function setBurnPaused(bool value) public onlyOwner returns (bool) {
370         _burnPaused = value;
371         return true;
372     }
373 
374     function setExcludedFeesAddr(address addr, bool value) public onlyOwner returns (bool) {
375         _excludedFeesAddress[addr] = value;
376         return true;
377     }
378 
379     function name() public view returns (string memory) {
380         return _name;
381     }
382 
383     function symbol() public view returns (string memory) {
384         return _symbol;
385     }
386 
387     function decimals() public pure returns (uint8) {
388         return 18;
389     }
390 
391     function totalSupply() public view override returns (uint256) {
392         return _totalSupply;
393     }
394 
395     function balanceOf(address account) public view override returns (uint256) {
396         return _balances[account];
397     }
398 
399     function transfer(address recipient, uint256 amount) public override returns (bool) {
400         _transfer(_msgSender(), recipient, amount);
401         return true;
402     }
403 
404     function allowance(address owner, address spender) public view override returns (uint256) {
405         return _allowances[owner][spender];
406     }
407 
408     function approve(address spender, uint256 amount) public override returns (bool) {
409         _approve(_msgSender(), spender, amount);
410         return true;
411     }
412 
413     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
414         _transfer(sender, recipient, amount);
415 
416         uint256 currentAllowance = _allowances[sender][_msgSender()];
417         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
418         _approve(sender, _msgSender(), currentAllowance - amount);
419 
420         return true;
421     }
422 
423     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
424         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
425         return true;
426     }
427 
428     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
429         uint256 currentAllowance = _allowances[_msgSender()][spender];
430         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
431         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
432 
433         return true;
434     }
435 
436     function _transfer(address sender, address recipient, uint256 amount) internal {
437         require(sender != address(0), "ERC20: transfer from the zero address");
438         require(recipient != address(0), "ERC20: transfer to the zero address");
439         require(amount > 0, "ERC20: amount 0 not allowed");
440         require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
441 
442         if(_feesActivated && !_excludedFeesAddress[sender]) {
443             uint256 burnAmount = amount.div(100).mul(5);
444             uint256 stakingAmount = amount.div(100).mul(5);
445             uint256 amountSubFees = amount.sub(burnAmount).sub(stakingAmount);
446 
447             // Transfert to the recipient
448             _balances[sender] = _balances[sender] - amount;
449             _balances[recipient] += amountSubFees;
450             emit Transfer(sender, recipient, amountSubFees);
451 
452             // Burn fees
453             if(!_burnPaused) {
454                 _burn(sender, burnAmount);
455             }
456             else {
457                 if(_stakingContract != address(0)) {
458                     _balances[_stakingContract] += burnAmount;
459                 }
460             }
461 
462             // Transfert to the staking contract and call the pulsator
463             _balances[_stakingContract] += stakingAmount;
464             if(_stakingContract != address(0)) {
465                 if(_burnPaused) {
466                     ILowOrbitPropulsor(_stakingContract).pulse(stakingAmount.add(burnAmount));
467                     emit Transfer(sender, _stakingContract, stakingAmount.add(burnAmount));
468                 }
469                 else {
470                     ILowOrbitPropulsor(_stakingContract).pulse(stakingAmount);
471                     emit Transfer(sender, _stakingContract, stakingAmount);
472                 }
473             }
474             else {
475                 _burn(sender, burnAmount);
476             }
477         }
478         else {
479             // Transfert to the recipient
480             _balances[sender] = _balances[sender] - amount;
481             _balances[recipient] += amount;
482             emit Transfer(sender, recipient, amount);
483         }
484     }
485 
486     function _burn(address account, uint256 amount) internal {
487         require(account != address(0), "ERC20: burn from the zero address");
488 
489         uint256 accountBalance = _balances[account];
490         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
491         _balances[account] = accountBalance - amount;
492         _totalSupply -= amount;
493 
494         emit Transfer(account, address(0), amount);
495     }
496 
497     function _approve(address owner, address spender, uint256 amount) internal {
498         require(owner != address(0), "ERC20: approve from the zero address");
499         require(spender != address(0), "ERC20: approve to the zero address");
500 
501         _allowances[owner][spender] = amount;
502         emit Approval(owner, spender, amount);
503     }
504 
505     function burn(uint256 amount) public {
506         _burn(_msgSender(), amount);
507     }
508 
509     function burnFrom(address account, uint256 amount) public {
510         uint256 currentAllowance = allowance(account, _msgSender());
511         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
512         _approve(account, _msgSender(), currentAllowance - amount);
513         _burn(account, amount);
514     }
515 }