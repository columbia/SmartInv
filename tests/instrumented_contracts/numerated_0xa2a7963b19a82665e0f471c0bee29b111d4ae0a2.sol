1 pragma solidity ^0.5.0;
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
30         require(b <= a, "SafeMath: subtraction overflow");
31         uint256 c = a - b;
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the multiplication of two unsigned integers, reverting on
38      * overflow.
39      *
40      * Counterpart to Solidity's `*` operator.
41      *
42      * Requirements:
43      * - Multiplication cannot overflow.
44      */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the integer division of two unsigned integers. Reverts on
61      * division by zero. The result is rounded towards zero.
62      *
63      * Counterpart to Solidity's `/` operator. Note: this function uses a
64      * `revert` opcode (which leaves remaining gas untouched) while Solidity
65      * uses an invalid opcode to revert (consuming all remaining gas).
66      *
67      * Requirements:
68      * - The divisor cannot be zero.
69      */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Solidity only automatically asserts when dividing by 0
72         require(b > 0, "SafeMath: division by zero");
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
81      * Reverts when dividing by zero.
82      *
83      * Counterpart to Solidity's `%` operator. This function uses a `revert`
84      * opcode (which leaves remaining gas untouched) while Solidity uses an
85      * invalid opcode to revert (consuming all remaining gas).
86      *
87      * Requirements:
88      * - The divisor cannot be zero.
89      */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0, "SafeMath: modulo by zero");
92         return a % b;
93     }
94 }
95 
96 interface IERC20 {
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     /**
103      * @dev Returns the amount of tokens owned by `account`.
104      */
105     function balanceOf(address account) external view returns (uint256);
106 
107     /**
108      * @dev Moves `amount` tokens from the caller's account to `recipient`.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a `Transfer` event.
113      */
114     function transfer(address recipient, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Returns the remaining number of tokens that `spender` will be
118      * allowed to spend on behalf of `owner` through `transferFrom`. This is
119      * zero by default.
120      *
121      * This value changes when `approve` or `transferFrom` are called.
122      */
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     /**
126      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * > Beware that changing an allowance with this method brings the risk
131      * that someone may use both the old and the new allowance by unfortunate
132      * transaction ordering. One possible solution to mitigate this race
133      * condition is to first reduce the spender's allowance to 0 and set the
134      * desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      *
137      * Emits an `Approval` event.
138      */
139     function approve(address spender, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Moves `amount` tokens from `sender` to `recipient` using the
143      * allowance mechanism. `amount` is then deducted from the caller's
144      * allowance.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a `Transfer` event.
149      */
150     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Emitted when `value` tokens are moved from one account (`from`) to
154      * another (`to`).
155      *
156      * Note that `value` may be zero.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 value);
159 
160     /**
161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
162      * a call to `approve`. `value` is the new allowance.
163      */
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 contract ERC20 is IERC20 {
168     using SafeMath for uint256;
169 
170     mapping (address => uint256) private _balances;
171 
172     mapping (address => mapping (address => uint256)) private _allowances;
173 
174     uint256 private _totalSupply;
175 
176     /**
177      * @dev See `IERC20.totalSupply`.
178      */
179     function totalSupply() public view returns (uint256) {
180         return _totalSupply;
181     }
182 
183     /**
184      * @dev See `IERC20.balanceOf`.
185      */
186     function balanceOf(address account) public view returns (uint256) {
187         return _balances[account];
188     }
189 
190     /**
191      * @dev See `IERC20.transfer`.
192      *
193      * Requirements:
194      *
195      * - `recipient` cannot be the zero address.
196      * - the caller must have a balance of at least `amount`.
197      */
198     function transfer(address recipient, uint256 amount) public returns (bool) {
199         _transfer(msg.sender, recipient, amount);
200         return true;
201     }
202 
203     /**
204      * @dev See `IERC20.allowance`.
205      */
206     function allowance(address owner, address spender) public view returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     /**
211      * @dev See `IERC20.approve`.
212      *
213      * Requirements:
214      *
215      * - `spender` cannot be the zero address.
216      */
217     function approve(address spender, uint256 value) public returns (bool) {
218         _approve(msg.sender, spender, value);
219         return true;
220     }
221 
222     /**
223      * @dev See `IERC20.transferFrom`.
224      *
225      * Emits an `Approval` event indicating the updated allowance. This is not
226      * required by the EIP. See the note at the beginning of `ERC20`;
227      *
228      * Requirements:
229      * - `sender` and `recipient` cannot be the zero address.
230      * - `sender` must have a balance of at least `value`.
231      * - the caller must have allowance for `sender`'s tokens of at least
232      * `amount`.
233      */
234     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
235         _transfer(sender, recipient, amount);
236         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
237         return true;
238     }
239 
240     /**
241      * @dev Atomically increases the allowance granted to `spender` by the caller.
242      *
243      * This is an alternative to `approve` that can be used as a mitigation for
244      * problems described in `IERC20.approve`.
245      *
246      * Emits an `Approval` event indicating the updated allowance.
247      *
248      * Requirements:
249      *
250      * - `spender` cannot be the zero address.
251      */
252     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
253         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
254         return true;
255     }
256 
257     /**
258      * @dev Atomically decreases the allowance granted to `spender` by the caller.
259      *
260      * This is an alternative to `approve` that can be used as a mitigation for
261      * problems described in `IERC20.approve`.
262      *
263      * Emits an `Approval` event indicating the updated allowance.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      * - `spender` must have allowance for the caller of at least
269      * `subtractedValue`.
270      */
271     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
272         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
273         return true;
274     }
275 
276     /**
277      * @dev Moves tokens `amount` from `sender` to `recipient`.
278      *
279      * This is internal function is equivalent to `transfer`, and can be used to
280      * e.g. implement automatic token fees, slashing mechanisms, etc.
281      *
282      * Emits a `Transfer` event.
283      *
284      * Requirements:
285      *
286      * - `sender` cannot be the zero address.
287      * - `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      */
290     function _transfer(address sender, address recipient, uint256 amount) internal {
291         require(sender != address(0), "ERC20: transfer from the zero address");
292         require(recipient != address(0), "ERC20: transfer to the zero address");
293 
294         _balances[sender] = _balances[sender].sub(amount);
295         _balances[recipient] = _balances[recipient].add(amount);
296         emit Transfer(sender, recipient, amount);
297     }
298 
299     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
300      * the total supply.
301      *
302      * Emits a `Transfer` event with `from` set to the zero address.
303      *
304      * Requirements
305      *
306      * - `to` cannot be the zero address.
307      */
308     function _mint(address account, uint256 amount) internal {
309         require(account != address(0), "ERC20: mint to the zero address");
310 
311         _totalSupply = _totalSupply.add(amount);
312         _balances[account] = _balances[account].add(amount);
313         emit Transfer(address(0), account, amount);
314     }
315 
316      /**
317      * @dev Destoys `amount` tokens from `account`, reducing the
318      * total supply.
319      *
320      * Emits a `Transfer` event with `to` set to the zero address.
321      *
322      * Requirements
323      *
324      * - `account` cannot be the zero address.
325      * - `account` must have at least `amount` tokens.
326      */
327     function _burn(address account, uint256 value) internal {
328         require(account != address(0), "ERC20: burn from the zero address");
329 
330         _totalSupply = _totalSupply.sub(value);
331         _balances[account] = _balances[account].sub(value);
332         emit Transfer(account, address(0), value);
333     }
334 
335     /**
336      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
337      *
338      * This is internal function is equivalent to `approve`, and can be used to
339      * e.g. set automatic allowances for certain subsystems, etc.
340      *
341      * Emits an `Approval` event.
342      *
343      * Requirements:
344      *
345      * - `owner` cannot be the zero address.
346      * - `spender` cannot be the zero address.
347      */
348     function _approve(address owner, address spender, uint256 value) internal {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351 
352         _allowances[owner][spender] = value;
353         emit Approval(owner, spender, value);
354     }
355 
356     /**
357      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
358      * from the caller's allowance.
359      *
360      * See `_burn` and `_approve`.
361      */
362     function _burnFrom(address account, uint256 amount) internal {
363         _burn(account, amount);
364         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
365     }
366 }
367 
368 contract ERC20Detailed is IERC20 {
369     string private _name;
370     string private _symbol;
371     uint8 private _decimals;
372 
373     /**
374      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
375      * these values are immutable: they can only be set once during
376      * construction.
377      */
378     constructor (string memory name, string memory symbol, uint8 decimals) public {
379         _name = name;
380         _symbol = symbol;
381         _decimals = decimals;
382     }
383 
384     /**
385      * @dev Returns the name of the token.
386      */
387     function name() public view returns (string memory) {
388         return _name;
389     }
390 
391     /**
392      * @dev Returns the symbol of the token, usually a shorter version of the
393      * name.
394      */
395     function symbol() public view returns (string memory) {
396         return _symbol;
397     }
398 
399     /**
400      * @dev Returns the number of decimals used to get its user representation.
401      * For example, if `decimals` equals `2`, a balance of `505` tokens should
402      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
403      *
404      * Tokens usually opt for a value of 18, imitating the relationship between
405      * Ether and Wei.
406      *
407      * > Note that this information is only used for _display_ purposes: it in
408      * no way affects any of the arithmetic of the contract, including
409      * `IERC20.balanceOf` and `IERC20.transfer`.
410      */
411     function decimals() public view returns (uint8) {
412         return _decimals;
413     }
414 }
415 
416 contract TEDToken is ERC20, ERC20Detailed {
417     uint256 public burned;
418 
419     string private constant NAME = "Token Economy Doin";
420     string private constant SYMBOL = "TED";
421     uint8 private constant DECIMALS = 18;
422     uint256 private constant INITIAL_SUPPLY = 45 * 10**26;
423 
424     constructor () public ERC20Detailed(NAME, SYMBOL, DECIMALS) {
425         _mint(msg.sender, INITIAL_SUPPLY);
426     }
427 
428     function burn(uint256 value) public returns(bool) {
429         burned = burned.add(value);
430         _burn(msg.sender, value);
431         return true;
432     }
433 
434     function burnFrom(address from, uint256 value) public returns(bool) {
435         burned = burned.add(value);
436         _burnFrom(from, value);
437         return true;
438     }
439 }