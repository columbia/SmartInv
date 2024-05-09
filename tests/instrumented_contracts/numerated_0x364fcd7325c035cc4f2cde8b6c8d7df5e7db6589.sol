1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.11;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, 'SafeMath: addition overflow');
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, 'SafeMath: subtraction overflow');
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(
48         uint256 a,
49         uint256 b,
50         string memory errorMessage
51     ) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the multiplication of two unsigned integers, reverting on
60      * overflow.
61      *
62      * Counterpart to Solidity's `*` operator.
63      *
64      * Requirements:
65      *
66      * - Multiplication cannot overflow.
67      */
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
70         // benefit is lost if 'b' is also tested.
71         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
72         if (a == 0) {
73             return 0;
74         }
75 
76         uint256 c = a * b;
77         require(c / a == b, 'SafeMath: multiplication overflow');
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the integer division of two unsigned integers. Reverts on
84      * division by zero. The result is rounded towards zero.
85      *
86      * Counterpart to Solidity's `/` operator. Note: this function uses a
87      * `revert` opcode (which leaves remaining gas untouched) while Solidity
88      * uses an invalid opcode to revert (consuming all remaining gas).
89      *
90      * Requirements:
91      *
92      * - The divisor cannot be zero.
93      */
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, 'SafeMath: division by zero');
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      *
108      * - The divisor cannot be zero.
109      */
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135         return mod(a, b, 'SafeMath: modulo by zero');
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts with custom message when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 
159     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
160         z = x < y ? x : y;
161     }
162 
163     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
164     function sqrt(uint256 y) internal pure returns (uint256 z) {
165         if (y > 3) {
166             z = y;
167             uint256 x = y / 2 + 1;
168             while (x < z) {
169                 z = x;
170                 x = (y / x + x) / 2;
171             }
172         } else if (y != 0) {
173             z = 1;
174         }
175     }
176 }
177 
178 interface IERC20 {
179     /**
180      * @dev Returns the amount of tokens in existence.
181      */
182     function totalSupply() external view returns (uint256);
183 
184     /**
185      * @dev Returns the token decimals.
186      */
187     function decimals() external view returns (uint8);
188 
189     /**
190      * @dev Returns the token symbol.
191      */
192     function symbol() external view returns (string memory);
193 
194     /**
195      * @dev Returns the token name.
196      */
197     function name() external view returns (string memory);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `recipient`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transfer(address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Returns the remaining number of tokens that `spender` will be
215      * allowed to spend on behalf of `owner` through {transferFrom}. This is
216      * zero by default.
217      *
218      * This value changes when {approve} or {transferFrom} are called.
219      */
220     function allowance(address _owner, address spender) external view returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * IMPORTANT: Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transferFrom(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) external returns (bool);
252 
253     /**
254      * @dev Emitted when `value` tokens are moved from one account (`from`) to
255      * another (`to`).
256      *
257      * Note that `value` may be zero.
258      */
259     event Transfer(address indexed from, address indexed to, uint256 value);
260 
261     /**
262      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
263      * a call to {approve}. `value` is the new allowance.
264      */
265     event Approval(address indexed owner, address indexed spender, uint256 value);
266 }
267 abstract contract Context {
268     function _msgSender() internal view returns (address) {
269         return msg.sender;
270     }
271 
272     function _msgData() internal view returns (bytes memory) {
273         this;
274         return msg.data;
275     }
276 }
277 
278 contract MetalkToken is Context, IERC20{
279     using SafeMath for uint256;
280 
281     mapping(address => uint256) private _balances;
282     mapping(address => mapping(address => uint256)) private _allowances;
283     uint256 private _totalSupply;
284 
285     string private _name;
286     string private _symbol;
287     uint8 private _decimals;
288 
289     /**
290      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
291      * a default value of 18.
292      *
293      * To select a different value for {decimals}, use {_setupDecimals}.
294      *
295      * All three of these values are immutable: they can only be set once during
296      * construction.
297      */
298     constructor(){
299         _name = 'Metalk Token';
300         _symbol = 'Meta';
301         _decimals = 18;
302         _totalSupply = 1000000000*1e18;
303         _balances[msg.sender] = _totalSupply;
304 
305         emit Transfer(address(0), msg.sender, _totalSupply);
306     }
307 
308     /**
309      * @dev Returns the token name.
310      */
311     function name() public override view returns (string memory) {
312         return _name;
313     }
314 
315     /**
316      * @dev Returns the token decimals.
317      */
318     function decimals() public override view returns (uint8) {
319         return _decimals;
320     }
321 
322     /**
323      * @dev Returns the token symbol.
324      */
325     function symbol() public override view returns (string memory) {
326         return _symbol;
327     }
328 
329     /**
330      * @dev See {ERC20-totalSupply}.
331      */
332     function totalSupply() public override view returns (uint256) {
333         return _totalSupply;
334     }
335 
336     /**
337      * @dev See {ERC20-balanceOf}.
338      */
339     function balanceOf(address account) public override view returns (uint256) {
340         return _balances[account];
341     }
342     /**
343      * @dev See {ERC20-transfer}.
344      *
345      * Requirements:
346      *
347      * - `recipient` cannot be the zero address.
348      * - the caller must have a balance of at least `amount`.
349      */
350     function transfer(address recipient, uint256 amount) public override returns (bool) {
351         _transfer(_msgSender(), recipient, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {ERC20-allowance}.
357      */
358     function allowance(address owner, address spender) public override view returns (uint256) {
359         return _allowances[owner][spender];
360     }
361 
362     /**
363      * @dev See {ERC20-approve}.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function approve(address spender, uint256 amount) public override returns (bool) {
370         _approve(_msgSender(), spender, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {ERC20-transferFrom}.
376      *
377      * Emits an {Approval} event indicating the updated allowance. This is not
378      * required by the EIP. See the note at the beginning of {ERC20};
379      *
380      * Requirements:
381      * - `sender` and `recipient` cannot be the zero address.
382      * - `sender` must have a balance of at least `amount`.
383      * - the caller must have allowance for `sender`'s tokens of at least
384      * `amount`.
385      */
386     function transferFrom(
387         address sender,
388         address recipient,
389         uint256 amount
390     ) public override returns (bool) {
391         _transfer(sender, recipient, amount);
392         _approve(
393             sender,
394             _msgSender(),
395             _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
396         );
397         return true;
398     }
399 
400     /**
401      * @dev Atomically increases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {ERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      */
412     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
413         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
414         return true;
415     }
416 
417     /**
418      * @dev Atomically decreases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {ERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      * - `spender` must have allowance for the caller of at least
429      * `subtractedValue`.
430      */
431     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
432         _approve(
433             _msgSender(),
434             spender,
435             _allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero')
436         );
437         return true;
438     }
439 
440     /**
441      * @dev Moves tokens `amount` from `sender` to `recipient`.
442      *
443      * This is internal function is equivalent to {transfer}, and can be used to
444      * e.g. implement automatic token fees, slashing mechanisms, etc.
445      *
446      * Emits a {Transfer} event.
447      *
448      * Requirements:
449      *
450      * - `sender` cannot be the zero address.
451      * - `recipient` cannot be the zero address.
452      * - `sender` must have a balance of at least `amount`.
453      */
454     function _transfer(
455         address sender,
456         address recipient,
457         uint256 amount
458     ) internal {
459         require(sender != address(0), 'ERC20: transfer from the zero address');
460         _balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');
461         _balances[recipient] = _balances[recipient].add(amount);
462         emit Transfer(sender, recipient, amount);
463     }
464 
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
468      *
469      * This is internal function is equivalent to `approve`, and can be used to
470      * e.g. set automatic allowances for certain subsystems, etc.
471      *
472      * Emits an {Approval} event.
473      *
474      * Requirements:
475      *
476      * - `owner` cannot be the zero address.
477      * - `spender` cannot be the zero address.
478      */
479     function _approve(
480         address owner,
481         address spender,
482         uint256 amount
483     ) internal {
484         require(owner != address(0), 'ERC20: approve from the zero address');
485         require(spender != address(0), 'ERC20: approve to the zero address');
486         _allowances[owner][spender] = amount;
487         emit Approval(owner, spender, amount);
488     }
489 }