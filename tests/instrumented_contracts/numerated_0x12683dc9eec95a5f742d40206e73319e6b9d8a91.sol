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
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 /**
181  * @dev Optional functions from the ERC20 standard.
182  */
183 contract ERC20Detailed is IERC20 {
184     string private _name;
185     string private _symbol;
186     uint8 private _decimals;
187 
188     /**
189      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
190      * these values are immutable: they can only be set once during
191      * construction.
192      */
193     constructor (string memory name, string memory symbol, uint8 decimals) public {
194         _name = name;
195         _symbol = symbol;
196         _decimals = decimals;
197     }
198 
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() public view returns (string memory) {
203         return _name;
204     }
205 
206     /**
207      * @dev Returns the symbol of the token, usually a shorter version of the
208      * name.
209      */
210     function symbol() public view returns (string memory) {
211         return _symbol;
212     }
213 
214     /**
215      * @dev Returns the number of decimals used to get its user representation.
216      * For example, if `decimals` equals `2`, a balance of `505` tokens should
217      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
218      *
219      * Tokens usually opt for a value of 18, imitating the relationship between
220      * Ether and Wei.
221      *
222      * NOTE: This information is only used for _display_ purposes: it in
223      * no way affects any of the arithmetic of the contract, including
224      * {IERC20-balanceOf} and {IERC20-transfer}.
225      */
226     function decimals() public view returns (uint8) {
227         return _decimals;
228     }
229 }
230 
231 /**
232  * @dev Implementation of the {IERC20} interface.
233  *
234  * This implementation is agnostic to the way tokens are created. This means
235  * that a supply mechanism has to be added in a derived contract using {_mint}.
236  * For a generic mechanism see {ERC20Mintable}.
237  *
238  * TIP: For a detailed writeup see our guide
239  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
240  * to implement supply mechanisms].
241  *
242  * We have followed general OpenZeppelin guidelines: functions revert instead
243  * of returning `false` on failure. This behavior is nonetheless conventional
244  * and does not conflict with the expectations of ERC20 applications.
245  *
246  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
247  * This allows applications to reconstruct the allowance for all accounts just
248  * by listening to said events. Other implementations of the EIP may not emit
249  * these events, as it isn't required by the specification.
250  *
251  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
252  * functions have been added to mitigate the well-known issues around setting
253  * allowances. See {IERC20-approve}.
254  */
255 contract ERC20 is IERC20 {
256     using SafeMath for uint256;
257 
258     mapping (address => uint256) private _balances;
259 
260     mapping (address => mapping (address => uint256)) private _allowances;
261 
262     uint256 private _totalSupply;
263 
264     /**
265      * @dev See {IERC20-totalSupply}.
266      */
267     function totalSupply() public view returns (uint256) {
268         return _totalSupply;
269     }
270 
271     /**
272      * @dev See {IERC20-balanceOf}.
273      */
274     function balanceOf(address account) public view returns (uint256) {
275         return _balances[account];
276     }
277 
278     /**
279      * @dev See {IERC20-transfer}.
280      *
281      * Requirements:
282      *
283      * - `recipient` cannot be the zero address.
284      * - the caller must have a balance of at least `amount`.
285      */
286     function transfer(address recipient, uint256 amount) public returns (bool) {
287         _transfer(msg.sender, recipient, amount);
288         return true;
289     }
290 
291     /**
292      * @dev See {IERC20-allowance}.
293      */
294     function allowance(address owner, address spender) public view returns (uint256) {
295         return _allowances[owner][spender];
296     }
297 
298     /**
299      * @dev See {IERC20-approve}.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      */
305     function approve(address spender, uint256 value) public returns (bool) {
306         _approve(msg.sender, spender, value);
307         return true;
308     }
309 
310     /**
311      * @dev See {IERC20-transferFrom}.
312      *
313      * Emits an {Approval} event indicating the updated allowance. This is not
314      * required by the EIP. See the note at the beginning of {ERC20};
315      *
316      * Requirements:
317      * - `sender` and `recipient` cannot be the zero address.
318      * - `sender` must have a balance of at least `value`.
319      * - the caller must have allowance for `sender`'s tokens of at least
320      * `amount`.
321      */
322     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
323         _transfer(sender, recipient, amount);
324         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
325         return true;
326     }
327 
328     /**
329      * @dev Atomically increases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
341         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
342         return true;
343     }
344 
345     /**
346      * @dev Atomically decreases the allowance granted to `spender` by the caller.
347      *
348      * This is an alternative to {approve} that can be used as a mitigation for
349      * problems described in {IERC20-approve}.
350      *
351      * Emits an {Approval} event indicating the updated allowance.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      * - `spender` must have allowance for the caller of at least
357      * `subtractedValue`.
358      */
359     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
360         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
361         return true;
362     }
363 
364     /**
365      * @dev Moves tokens `amount` from `sender` to `recipient`.
366      *
367      * This is internal function is equivalent to {transfer}, and can be used to
368      * e.g. implement automatic token fees, slashing mechanisms, etc.
369      *
370      * Emits a {Transfer} event.
371      *
372      * Requirements:
373      *
374      * - `sender` cannot be the zero address.
375      * - `recipient` cannot be the zero address.
376      * - `sender` must have a balance of at least `amount`.
377      */
378     function _transfer(address sender, address recipient, uint256 amount) internal {
379         require(sender != address(0), "ERC20: transfer from the zero address");
380         require(recipient != address(0), "ERC20: transfer to the zero address");
381 
382         _balances[sender] = _balances[sender].sub(amount);
383         _balances[recipient] = _balances[recipient].add(amount);
384         emit Transfer(sender, recipient, amount);
385     }
386 
387     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      *
390      * Emits a {Transfer} event with `from` set to the zero address.
391      *
392      * Requirements
393      *
394      * - `to` cannot be the zero address.
395      */
396     function _mint(address account, uint256 amount) internal {
397         require(account != address(0), "ERC20: mint to the zero address");
398 
399         _totalSupply = _totalSupply.add(amount);
400         _balances[account] = _balances[account].add(amount);
401         emit Transfer(address(0), account, amount);
402     }
403 
404      /**
405      * @dev Destroys `amount` tokens from `account`, reducing the
406      * total supply.
407      *
408      * Emits a {Transfer} event with `to` set to the zero address.
409      *
410      * Requirements
411      *
412      * - `account` cannot be the zero address.
413      * - `account` must have at least `amount` tokens.
414      */
415     function _burn(address account, uint256 value) internal {
416         require(account != address(0), "ERC20: burn from the zero address");
417 
418         _totalSupply = _totalSupply.sub(value);
419         _balances[account] = _balances[account].sub(value);
420         emit Transfer(account, address(0), value);
421     }
422 
423     /**
424      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
425      *
426      * This is internal function is equivalent to `approve`, and can be used to
427      * e.g. set automatic allowances for certain subsystems, etc.
428      *
429      * Emits an {Approval} event.
430      *
431      * Requirements:
432      *
433      * - `owner` cannot be the zero address.
434      * - `spender` cannot be the zero address.
435      */
436     function _approve(address owner, address spender, uint256 value) internal {
437         require(owner != address(0), "ERC20: approve from the zero address");
438         require(spender != address(0), "ERC20: approve to the zero address");
439 
440         _allowances[owner][spender] = value;
441         emit Approval(owner, spender, value);
442     }
443 
444     /**
445      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
446      * from the caller's allowance.
447      *
448      * See {_burn} and {_approve}.
449      */
450     function _burnFrom(address account, uint256 amount) internal {
451         _burn(account, amount);
452         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
453     }
454 }
455 
456 /**
457  * @title ERC20 Token for the FAB Tokensale.
458  * Is a Standard ERC20 token
459  */
460 contract FABToken is ERC20, ERC20Detailed{
461   constructor(string memory _name, string memory _symbol, uint8 _decimals)
462     ERC20Detailed(_name, _symbol, _decimals)
463     public
464   {
465     _mint(msg.sender, 55000000000000000000000000000);
466   }
467 }