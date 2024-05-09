1 pragma solidity 0.5.8;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
111  * the optional functions; to access them see `ERC20Detailed`.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a `Transfer` event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through `transferFrom`. This is
136      * zero by default.
137      *
138      * This value changes when `approve` or `transferFrom` are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * > Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an `Approval` event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a `Transfer` event.
166      */
167     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to `approve`. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 /**
185  * @dev Implementation of the `IERC20` interface.
186  */
187 
188 contract ERC20 is IERC20 {
189     using SafeMath for uint256;
190 
191     mapping (address => uint256) internal _balances;
192 
193     mapping (address => mapping (address => uint256)) internal _allowances;
194 
195     uint256 internal _totalSupply;
196 
197     /**
198      * @dev See `IERC20.totalSupply`.
199      */
200     function totalSupply() public view returns (uint256) {
201         return _totalSupply;
202     }
203 
204     /**
205      * @dev See `IERC20.balanceOf`.
206      */
207     function balanceOf(address account) public view returns (uint256) {
208         return _balances[account];
209     }
210 
211     /**
212      * @dev See `IERC20.transfer`.
213      *
214      * Requirements:
215      *
216      * - `recipient` cannot be the zero address.
217      * - the caller must have a balance of at least `amount`.
218      */
219     function transfer(address recipient, uint256 amount) public returns (bool) {
220         _transfer(msg.sender, recipient, amount);
221         return true;
222     }
223 
224     /**
225      * @dev See `IERC20.allowance`.
226      */
227     function allowance(address owner, address spender) public view returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231     function burn(uint256 amount) public {
232         _burn(msg.sender, amount);
233     }
234 
235     /**
236      * @dev See `ERC20._burnFrom`.
237      */
238     function burnFrom(address account, uint256 amount) public {
239         _burnFrom(account, amount);
240     }
241 
242     /**
243      * @dev See `IERC20.approve`.
244      *
245      * Requirements:
246      *
247      * - `spender` cannot be the zero address.
248      */
249     function approve(address spender, uint256 value) public returns (bool) {
250         _approve(msg.sender, spender, value);
251         return true;
252     }
253 
254     /**
255      * @dev See `IERC20.transferFrom`.
256      *
257      * Emits an `Approval` event indicating the updated allowance. This is not
258      * required by the EIP. See the note at the beginning of `ERC20`;
259      *
260      * Requirements:
261      * - `sender` and `recipient` cannot be the zero address.
262      * - `sender` must have a balance of at least `value`.
263      * - the caller must have allowance for `sender`'s tokens of at least
264      * `amount`.
265      */
266     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
267         _transfer(sender, recipient, amount);
268         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
269         return true;
270     }
271 
272     /**
273      * @dev Atomically increases the allowance granted to `spender` by the caller.
274      *
275      * This is an alternative to `approve` that can be used as a mitigation for
276      * problems described in `IERC20.approve`.
277      *
278      * Emits an `Approval` event indicating the updated allowance.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      */
284     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
285         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
286         return true;
287     }
288 
289     /**
290      * @dev Atomically decreases the allowance granted to `spender` by the caller.
291      *
292      * This is an alternative to `approve` that can be used as a mitigation for
293      * problems described in `IERC20.approve`.
294      *
295      * Emits an `Approval` event indicating the updated allowance.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      * - `spender` must have allowance for the caller of at least
301      * `subtractedValue`.
302      */
303     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
304         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
305         return true;
306     }
307 
308     /**
309      * @dev Moves tokens `amount` from `sender` to `recipient`.
310      *
311      * This is internal function is equivalent to `transfer`, and can be used to
312      * e.g. implement automatic token fees, slashing mechanisms, etc.
313      *
314      * Emits a `Transfer` event.
315      *
316      * Requirements:
317      *
318      * - `sender` cannot be the zero address.
319      * - `recipient` cannot be the zero address.
320      * - `sender` must have a balance of at least `amount`.
321      */
322     function _transfer(address sender, address recipient, uint256 amount) internal {
323         require(sender != address(0), "ERC20: transfer from the zero address");
324         require(recipient != address(0), "ERC20: transfer to the zero address");
325 
326         _balances[sender] = _balances[sender].sub(amount);
327         _balances[recipient] = _balances[recipient].add(amount);
328         emit Transfer(sender, recipient, amount);
329     }
330 
331      /**
332      * @dev Destoys `amount` tokens from `account`, reducing the
333      * total supply.
334      *
335      * Emits a `Transfer` event with `to` set to the zero address.
336      *
337      * Requirements
338      *
339      * - `account` cannot be the zero address.
340      * - `account` must have at least `amount` tokens.
341      */
342     function _burn(address account, uint256 value) internal {
343         require(account != address(0), "ERC20: burn from the zero address");
344 
345         _totalSupply = _totalSupply.sub(value);
346         _balances[account] = _balances[account].sub(value);
347         emit Transfer(account, address(0), value);
348     }
349 
350     /**
351      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
352      *
353      * This is internal function is equivalent to `approve`, and can be used to
354      * e.g. set automatic allowances for certain subsystems, etc.
355      *
356      * Emits an `Approval` event.
357      *
358      * Requirements:
359      *
360      * - `owner` cannot be the zero address.
361      * - `spender` cannot be the zero address.
362      */
363     function _approve(address owner, address spender, uint256 value) internal {
364         require(owner != address(0), "ERC20: approve from the zero address");
365         require(spender != address(0), "ERC20: approve to the zero address");
366 
367         _allowances[owner][spender] = value;
368         emit Approval(owner, spender, value);
369     }
370 
371     /**
372      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
373      * from the caller's allowance.
374      *
375      * See `_burn` and `_approve`.
376      */
377     function _burnFrom(address account, uint256 amount) internal {
378         _burn(account, amount);
379         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
380     }
381 }
382 
383 /**
384  * @dev COS token
385  */
386 contract COS is ERC20 {
387     string private _name;
388     string private _symbol;
389     uint8 private _decimals;
390 
391     /**
392      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
393      * these values are immutable: they can only be set once during
394      * construction.
395      */
396     constructor () public {
397         _name = "COS";
398         _symbol = "COS";
399         _decimals = 18;
400         _totalSupply = 200e6 * 10**18; //200 millions
401         // transfer(msg.sender, _totalSupply);
402         _balances[msg.sender] = _totalSupply;
403         emit Transfer(address(this), msg.sender, _totalSupply);
404     }
405 
406     /**
407      * @dev ardrop tokens to multiple addresses
408      */
409     function airdrop(address[] calldata _recipients, uint256[] calldata _values) external returns (bool) {
410         require(_recipients.length == _values.length, "Inconsistent data lengths");
411         uint256 senderBalance = _balances[msg.sender];
412         uint256 length = _values.length;
413         for (uint256 i = 0; i < length; i++) {
414             uint256 value = _values[i];
415             address to = _recipients[i];
416             require(senderBalance >= value, "Insufficient Balance");
417             require(to != address(0), "Address is Null");
418             if (msg.sender != _recipients[i])  {      
419                 transfer(to, value);
420             }
421         }
422         return true;            
423     }
424 
425     /**
426      * Getter Functions
427      */
428 
429     /**
430      * @dev Returns the name of the token.
431      */
432     function name() public view returns (string memory) {
433         return _name;
434     }
435 
436     /**
437      * @dev Returns the symbol of the token, usually a shorter version of the
438      * name.
439      */
440     function symbol() public view returns (string memory) {
441         return _symbol;
442     }
443 
444     /**
445      * @dev Returns the number of decimals used to get its user representation
446      */
447     function decimals() public view returns (uint8) {
448         return _decimals;
449     }
450 }