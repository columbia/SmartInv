1 pragma solidity ^0.5.10;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      * - Addition cannot overflow.
12      */
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19 
20     /**
21      * @dev Returns the subtraction of two unsigned integers, reverting on
22      * overflow (when the result is negative).
23      *
24      * Counterpart to Solidity's `-` operator.
25      *
26      * Requirements:
27      * - Subtraction cannot overflow.
28      */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      *
42      * _Available since v2.4.0._
43      */
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
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
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      *
99      * _Available since v2.4.0._
100      */
101     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         // Solidity only automatically asserts when dividing by 0
103         require(b > 0, errorMessage);
104         uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
112      * Reverts when dividing by zero.
113      *
114      * Counterpart to Solidity's `%` operator. This function uses a `revert`
115      * opcode (which leaves remaining gas untouched) while Solidity uses an
116      * invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      * - The divisor cannot be zero.
120      */
121     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
122         return mod(a, b, "SafeMath: modulo by zero");
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts with custom message when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      *
136      * _Available since v2.4.0._
137      */
138     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b != 0, errorMessage);
140         return a % b;
141     }
142 }
143 
144 /**
145  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
146  * the optional functions; to access them see {ERC20Detailed}
147  */
148 interface IERC20 {
149     /**
150      * @dev Returns the amount of tokens in existence.
151      */
152     function totalSupply() external view returns (uint256);
153 
154     /**
155      * @dev Returns the amount of tokens owned by `account`.
156      */
157     function balanceOf(address account) external view returns (uint256);
158 
159     /**
160      * @dev Moves `amount` tokens from the caller's account to `recipient`.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transfer(address recipient, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Returns the remaining number of tokens that `spender` will be
170      * allowed to spend on behalf of `owner` through {transferFrom}. This is
171      * zero by default.
172      *
173      * This value changes when {approve} or {transferFrom} are called.
174      */
175     function allowance(address owner, address spender) external view returns (uint256);
176 
177     /**
178      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * IMPORTANT: Beware that changing an allowance with this method brings the risk
183      * that someone may use both the old and the new allowance by unfortunate
184      * transaction ordering. One possible solution to mitigate this race
185      * condition is to first reduce the spender's allowance to 0 and set the
186      * desired value afterwards:
187      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      *
189      * Emits an {Approval} event.
190      */
191     function approve(address spender, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Moves `amount` tokens from `sender` to `recipient` using the
195      * allowance mechanism. `amount` is then deducted from the caller's
196      * allowance.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
203 
204     /**
205      * @dev Emitted when `value` tokens are moved from one account (`from`) to
206      * another (`to`).
207      *
208      * Note that `value` may be zero.
209      */
210     event Transfer(address indexed from, address indexed to, uint256 value);
211 
212     /**
213      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
214      * a call to {approve}. `value` is the new allowance.
215      */
216     event Approval(address indexed owner, address indexed spender, uint256 value);
217 }
218 
219 contract Context {
220     // Empty internal constructor, to prevent people from mistakenly deploying
221     // an instance of this contract, which should be used via inheritance.
222     constructor () internal { }
223     // solhint-disable-previous-line no-empty-blocks
224 
225     function _msgSender() internal view returns (address payable) {
226         return msg.sender;
227     }
228 
229     function _msgData() internal view returns (bytes memory) {
230         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
231         return msg.data;
232     }
233 }
234 
235 contract ERC20 is Context, IERC20 {
236     using SafeMath for uint256;
237 
238     mapping (address => uint256) private _balances;
239 
240     mapping (address => mapping (address => uint256)) private _allowances;
241 
242     uint256 private _totalSupply;
243 
244     /**
245      * @dev See {IERC20-totalSupply}.
246      */
247     function totalSupply() public view returns (uint256) {
248         return _totalSupply;
249     }
250 
251     /**
252      * @dev See {IERC20-balanceOf}.
253      */
254     function balanceOf(address account) public view returns (uint256) {
255         return _balances[account];
256     }
257 
258     /**
259      * @dev See {IERC20-transfer}.
260      *
261      * Requirements:
262      *
263      * - `recipient` cannot be the zero address.
264      * - the caller must have a balance of at least `amount`.
265      */
266     function transfer(address recipient, uint256 amount) public returns (bool) {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270 
271     /**
272      * @dev See {IERC20-allowance}.
273      */
274     function allowance(address owner, address spender) public view returns (uint256) {
275         return _allowances[owner][spender];
276     }
277 
278     /**
279      * @dev See {IERC20-approve}.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      */
285     function approve(address spender, uint256 amount) public returns (bool) {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289 
290     /**
291      * @dev See {IERC20-transferFrom}.
292      *
293      * Emits an {Approval} event indicating the updated allowance. This is not
294      * required by the EIP. See the note at the beginning of {ERC20};
295      *
296      * Requirements:
297      * - `sender` and `recipient` cannot be the zero address.
298      * - `sender` must have a balance of at least `amount`.
299      * - the caller must have allowance for `sender`'s tokens of at least
300      * `amount`.
301      */
302     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
303         _transfer(sender, recipient, amount);
304         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
305         return true;
306     }
307 
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
340         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
341         return true;
342     }
343 
344     function burn(uint256 amount) public returns (bool) {
345         _burn(_msgSender(), amount);
346         return true;
347     }
348 
349     function burnFrom(address account, uint256 amount) public returns (bool) {
350         _burnFrom(account, amount);
351         return true;
352     }
353 
354     /**
355      * @dev Moves tokens `amount` from `sender` to `recipient`.
356      *
357      * This is internal function is equivalent to {transfer}, and can be used to
358      * e.g. implement automatic token fees, slashing mechanisms, etc.
359      *
360      * Emits a {Transfer} event.
361      *
362      * Requirements:
363      *
364      * - `sender` cannot be the zero address.
365      * - `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      */
368     function _transfer(address sender, address recipient, uint256 amount) internal {
369         require(sender != address(0), "ERC20: transfer from the zero address");
370         require(recipient != address(0), "ERC20: transfer to the zero address");
371 
372         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
373         _balances[recipient] = _balances[recipient].add(amount);
374         emit Transfer(sender, recipient, amount);
375     }
376 
377     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
378      * the total supply.
379      *
380      * Emits a {Transfer} event with `from` set to the zero address.
381      *
382      * Requirements
383      *
384      * - `to` cannot be the zero address.
385      */
386     function _mint(address account, uint256 amount) internal {
387         require(account != address(0), "ERC20: mint to the zero address");
388 
389         _totalSupply = _totalSupply.add(amount);
390         _balances[account] = _balances[account].add(amount);
391         emit Transfer(address(0), account, amount);
392     }
393 
394     /**
395     * @dev Destroys `amount` tokens from `account`, reducing the
396     * total supply.
397     *
398     * Emits a {Transfer} event with `to` set to the zero address.
399     *
400     * Requirements
401     *
402     * - `account` cannot be the zero address.
403     * - `account` must have at least `amount` tokens.
404     */
405     function _burn(address account, uint256 amount) internal {
406         require(account != address(0), "ERC20: burn from the zero address");
407 
408         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
409         _totalSupply = _totalSupply.sub(amount);
410         emit Transfer(account, address(0), amount);
411     }
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
415      *
416      * This is internal function is equivalent to `approve`, and can be used to
417      * e.g. set automatic allowances for certain subsystems, etc.
418      *
419      * Emits an {Approval} event.
420      *
421      * Requirements:
422      *
423      * - `owner` cannot be the zero address.
424      * - `spender` cannot be the zero address.
425      */
426     function _approve(address owner, address spender, uint256 amount) internal {
427         require(owner != address(0), "ERC20: approve from the zero address");
428         require(spender != address(0), "ERC20: approve to the zero address");
429 
430         _allowances[owner][spender] = amount;
431         emit Approval(owner, spender, amount);
432     }
433 
434     /**
435      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
436      * from the caller's allowance.
437      *
438      * See {_burn} and {_approve}.
439      */
440     function _burnFrom(address account, uint256 amount) internal {
441         _burn(account, amount);
442         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
443     }
444 }
445 
446 contract TeachingTrainingTutoringContract is ERC20 {
447 
448     string public name = "Teaching Training Tutoring";
449     string public symbol = "TTT";
450     uint public decimals = 18;
451     uint public INITIAL_SUPPLY = 1000000000 * (10 **decimals);
452 
453     constructor() public {
454         _mint(msg.sender, INITIAL_SUPPLY);
455     }
456 }