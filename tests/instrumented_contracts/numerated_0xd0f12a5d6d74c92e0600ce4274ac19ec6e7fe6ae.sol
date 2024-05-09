1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      * - Subtraction cannot overflow.
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b <= a, "SafeMath: subtraction overflow");
32         uint256 c = a - b;
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the multiplication of two unsigned integers, reverting on
39      * overflow.
40      *
41      * Counterpart to Solidity's `*` operator.
42      *
43      * Requirements:
44      * - Multiplication cannot overflow.
45      */
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50         if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56 
57         return c;
58     }
59 
60     /**
61      * @dev Returns the integer division of two unsigned integers. Reverts on
62      * division by zero. The result is rounded towards zero.
63      *
64      * Counterpart to Solidity's `/` operator. Note: this function uses a
65      * `revert` opcode (which leaves remaining gas untouched) while Solidity
66      * uses an invalid opcode to revert (consuming all remaining gas).
67      *
68      * Requirements:
69      * - The divisor cannot be zero.
70      */
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Solidity only automatically asserts when dividing by 0
73         require(b > 0, "SafeMath: division by zero");
74         uint256 c = a / b;
75         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
82      * Reverts when dividing by zero.
83      *
84      * Counterpart to Solidity's `%` operator. This function uses a `revert`
85      * opcode (which leaves remaining gas untouched) while Solidity uses an
86      * invalid opcode to revert (consuming all remaining gas).
87      *
88      * Requirements:
89      * - The divisor cannot be zero.
90      */
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b != 0, "SafeMath: modulo by zero");
93         return a % b;
94     }
95 }
96 
97 
98 interface IERC20 {
99     /**
100      * @dev Returns the amount of tokens in existence.
101      */
102     function totalSupply() external view returns (uint256);
103 
104     /**
105      * @dev Returns the amount of tokens owned by `account`.
106      */
107     function balanceOf(address account) external view returns (uint256);
108 
109     /**
110      * @dev Moves `amount` tokens from the caller's account to `recipient`.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a `Transfer` event.
115      */
116     function transfer(address recipient, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Returns the remaining number of tokens that `spender` will be
120      * allowed to spend on behalf of `owner` through `transferFrom`. This is
121      * zero by default.
122      *
123      * This value changes when `approve` or `transferFrom` are called.
124      */
125     function allowance(address owner, address spender) external view returns (uint256);
126 
127     /**
128      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * > Beware that changing an allowance with this method brings the risk
133      * that someone may use both the old and the new allowance by unfortunate
134      * transaction ordering. One possible solution to mitigate this race
135      * condition is to first reduce the spender's allowance to 0 and set the
136      * desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      *
139      * Emits an `Approval` event.
140      */
141     function approve(address spender, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Moves `amount` tokens from `sender` to `recipient` using the
145      * allowance mechanism. `amount` is then deducted from the caller's
146      * allowance.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a `Transfer` event.
151      */
152     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Emitted when `value` tokens are moved from one account (`from`) to
156      * another (`to`).
157      *
158      * Note that `value` may be zero.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 value);
161 
162     /**
163      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
164      * a call to `approve`. `value` is the new allowance.
165      */
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 
170 /**
171  * @dev Optional functions from the ERC20 standard.
172  */
173 contract ERC20Detailed is IERC20 {
174     string private _name;
175     string private _symbol;
176     uint8 private _decimals;
177 
178     /**
179      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
180      * these values are immutable: they can only be set once during
181      * construction.
182      */
183     constructor (string memory name, string memory symbol, uint8 decimals) public {
184         _name = name;
185         _symbol = symbol;
186         _decimals = decimals;
187     }
188 
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() public view returns (string memory) {
193         return _name;
194     }
195 
196     /**
197      * @dev Returns the symbol of the token, usually a shorter version of the
198      * name.
199      */
200     function symbol() public view returns (string memory) {
201         return _symbol;
202     }
203 
204     /**
205      * @dev Returns the number of decimals used to get its user representation.
206      * For example, if `decimals` equals `2`, a balance of `505` tokens should
207      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
208      *
209      * Tokens usually opt for a value of 18, imitating the relationship between
210      * Ether and Wei.
211      *
212      * > Note that this information is only used for _display_ purposes: it in
213      * no way affects any of the arithmetic of the contract, including
214      * `IERC20.balanceOf` and `IERC20.transfer`.
215      */
216     function decimals() public view returns (uint8) {
217         return _decimals;
218     }
219 }
220 
221 
222 
223 contract ERC20 is IERC20 {
224     using SafeMath for uint256;
225 
226     mapping (address => uint256) private _balances;
227 
228     mapping (address => mapping (address => uint256)) private _allowances;
229 
230     uint256 private _totalSupply;
231 
232     /**
233      * @dev See `IERC20.totalSupply`.
234      */
235     function totalSupply() public view returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See `IERC20.balanceOf`.
241      */
242     function balanceOf(address account) public view returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See `IERC20.transfer`.
248      *
249      * Requirements:
250      *
251      * - `recipient` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address recipient, uint256 amount) public returns (bool) {
255         _transfer(msg.sender, recipient, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See `IERC20.allowance`.
261      */
262     function allowance(address owner, address spender) public view returns (uint256) {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See `IERC20.approve`.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 value) public returns (bool) {
274         _approve(msg.sender, spender, value);
275         return true;
276     }
277 
278     /**
279      * @dev See `IERC20.transferFrom`.
280      *
281      * Emits an `Approval` event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of `ERC20`;
283      *
284      * Requirements:
285      * - `sender` and `recipient` cannot be the zero address.
286      * - `sender` must have a balance of at least `value`.
287      * - the caller must have allowance for `sender`'s tokens of at least
288      * `amount`.
289      */
290     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
293         return true;
294     }
295 
296     /**
297      * @dev Atomically increases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to `approve` that can be used as a mitigation for
300      * problems described in `IERC20.approve`.
301      *
302      * Emits an `Approval` event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
309         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
310         return true;
311     }
312 
313     /**
314      * @dev Atomically decreases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to `approve` that can be used as a mitigation for
317      * problems described in `IERC20.approve`.
318      *
319      * Emits an `Approval` event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      * - `spender` must have allowance for the caller of at least
325      * `subtractedValue`.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
328         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
329         return true;
330     }
331 
332     /**
333      * @dev Moves tokens `amount` from `sender` to `recipient`.
334      *
335      * This is internal function is equivalent to `transfer`, and can be used to
336      * e.g. implement automatic token fees, slashing mechanisms, etc.
337      *
338      * Emits a `Transfer` event.
339      *
340      * Requirements:
341      *
342      * - `sender` cannot be the zero address.
343      * - `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      */
346     function _transfer(address sender, address recipient, uint256 amount) internal {
347         require(sender != address(0), "ERC20: transfer from the zero address");
348         require(recipient != address(0), "ERC20: transfer to the zero address");
349 
350         _balances[sender] = _balances[sender].sub(amount);
351         _balances[recipient] = _balances[recipient].add(amount);
352         emit Transfer(sender, recipient, amount);
353     }
354 
355     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
356      * the total supply.
357      *
358      * Emits a `Transfer` event with `from` set to the zero address.
359      *
360      * Requirements
361      *
362      * - `to` cannot be the zero address.
363      */
364     function _mint(address account, uint256 amount) internal {
365         require(account != address(0), "ERC20: mint to the zero address");
366 
367         _totalSupply = _totalSupply.add(amount);
368         _balances[account] = _balances[account].add(amount);
369         emit Transfer(address(0), account, amount);
370     }
371 
372      /**
373      * @dev Destoys `amount` tokens from `account`, reducing the
374      * total supply.
375      *
376      * Emits a `Transfer` event with `to` set to the zero address.
377      *
378      * Requirements
379      *
380      * - `account` cannot be the zero address.
381      * - `account` must have at least `amount` tokens.
382      */
383     function _burn(address account, uint256 value) internal {
384         require(account != address(0), "ERC20: burn from the zero address");
385 
386         _totalSupply = _totalSupply.sub(value);
387         _balances[account] = _balances[account].sub(value);
388         emit Transfer(account, address(0), value);
389     }
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
393      *
394      * This is internal function is equivalent to `approve`, and can be used to
395      * e.g. set automatic allowances for certain subsystems, etc.
396      *
397      * Emits an `Approval` event.
398      *
399      * Requirements:
400      *
401      * - `owner` cannot be the zero address.
402      * - `spender` cannot be the zero address.
403      */
404     function _approve(address owner, address spender, uint256 value) internal {
405         require(owner != address(0), "ERC20: approve from the zero address");
406         require(spender != address(0), "ERC20: approve to the zero address");
407 
408         _allowances[owner][spender] = value;
409         emit Approval(owner, spender, value);
410     }
411 
412     /**
413      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
414      * from the caller's allowance.
415      *
416      * See `_burn` and `_approve`.
417      */
418     function _burnFrom(address account, uint256 amount) internal {
419         _burn(account, amount);
420         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
421     }
422 }
423 
424 
425 
426 
427 contract Taurus is ERC20, ERC20Detailed {
428 
429     /**
430      * @dev Constructor that gives msg.sender all of existing tokens.
431      */
432     constructor () public ERC20Detailed("Taurus", "TAUC", 4) {
433         _mint(msg.sender, 12990000 * (10 ** uint256(decimals())));
434     }
435 }