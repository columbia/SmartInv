1 library SafeMath {
2     /**
3      * @dev Returns the addition of two unsigned integers, reverting on
4      * overflow.
5      *
6      * Counterpart to Solidity's `+` operator.
7      *
8      * Requirements:
9      * - Addition cannot overflow.
10      */
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14 
15         return c;
16     }
17 
18     /**
19      * @dev Returns the subtraction of two unsigned integers, reverting on
20      * overflow (when the result is negative).
21      *
22      * Counterpart to Solidity's `-` operator.
23      *
24      * Requirements:
25      * - Subtraction cannot overflow.
26      */
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30 
31     /**
32      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
33      * overflow (when the result is negative).
34      *
35      * Counterpart to Solidity's `-` operator.
36      *
37      * Requirements:
38      * - Subtraction cannot overflow.
39      *
40      * _Available since v2.4.0._
41      */
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
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
61         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
84         return div(a, b, "SafeMath: division by zero");
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      *
98      * _Available since v2.4.0._
99      */
100     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b > 0, errorMessage);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
111      * Reverts when dividing by zero.
112      *
113      * Counterpart to Solidity's `%` operator. This function uses a `revert`
114      * opcode (which leaves remaining gas untouched) while Solidity uses an
115      * invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      * - The divisor cannot be zero.
119      */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         return mod(a, b, "SafeMath: modulo by zero");
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts with custom message when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      *
135      * _Available since v2.4.0._
136      */
137     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b != 0, errorMessage);
139         return a % b;
140     }
141 }
142 
143 contract Context {
144     // Empty internal constructor, to prevent people from mistakenly deploying
145     // an instance of this contract, which should be used via inheritance.
146     constructor () internal { }
147     // solhint-disable-previous-line no-empty-blocks
148 
149     function _msgSender() internal view returns (address payable) {
150         return msg.sender;
151     }
152 
153     function _msgData() internal view returns (bytes memory) {
154         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
155         return msg.data;
156     }
157 }
158 
159 
160 
161 interface IERC20 {
162     /**
163      * @dev Returns the amount of tokens in existence.
164      */
165     function totalSupply() external view returns (uint256);
166 
167     /**
168      * @dev Returns the amount of tokens owned by `account`.
169      */
170     function balanceOf(address account) external view returns (uint256);
171 
172     /**
173      * @dev Moves `amount` tokens from the caller's account to `recipient`.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transfer(address recipient, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Returns the remaining number of tokens that `spender` will be
183      * allowed to spend on behalf of `owner` through {transferFrom}. This is
184      * zero by default.
185      *
186      * This value changes when {approve} or {transferFrom} are called.
187      */
188     function allowance(address owner, address spender) external view returns (uint256);
189 
190     /**
191      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * IMPORTANT: Beware that changing an allowance with this method brings the risk
196      * that someone may use both the old and the new allowance by unfortunate
197      * transaction ordering. One possible solution to mitigate this race
198      * condition is to first reduce the spender's allowance to 0 and set the
199      * desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address spender, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Moves `amount` tokens from `sender` to `recipient` using the
208      * allowance mechanism. `amount` is then deducted from the caller's
209      * allowance.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Emitted when `value` tokens are moved from one account (`from`) to
219      * another (`to`).
220      *
221      * Note that `value` may be zero.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 value);
224 
225     /**
226      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
227      * a call to {approve}. `value` is the new allowance.
228      */
229     event Approval(address indexed owner, address indexed spender, uint256 value);
230 }
231 
232 contract ERC20 is Context, IERC20 {
233     using SafeMath for uint256;
234 
235     mapping (address => uint256) private _balances;
236 
237     mapping (address => mapping (address => uint256)) private _allowances;
238 
239     uint256 private _totalSupply;
240 
241     /**
242      * @dev See {IERC20-totalSupply}.
243      */
244     function totalSupply() public view returns (uint256) {
245         return _totalSupply;
246     }
247 
248     /**
249      * @dev See {IERC20-balanceOf}.
250      */
251     function balanceOf(address account) public view returns (uint256) {
252         return _balances[account];
253     }
254 
255     /**
256      * @dev See {IERC20-transfer}.
257      *
258      * Requirements:
259      *
260      * - `recipient` cannot be the zero address.
261      * - the caller must have a balance of at least `amount`.
262      */
263     function transfer(address recipient, uint256 amount) public returns (bool) {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267 
268     /**
269      * @dev See {IERC20-allowance}.
270      */
271     function allowance(address owner, address spender) public view returns (uint256) {
272         return _allowances[owner][spender];
273     }
274 
275     /**
276      * @dev See {IERC20-approve}.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address spender, uint256 amount) public returns (bool) {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286 
287     /**
288      * @dev See {IERC20-transferFrom}.
289      *
290      * Emits an {Approval} event indicating the updated allowance. This is not
291      * required by the EIP. See the note at the beginning of {ERC20};
292      *
293      * Requirements:
294      * - `sender` and `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      * - the caller must have allowance for `sender`'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
300         _transfer(sender, recipient, amount);
301         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
302         return true;
303     }
304 
305     /**
306      * @dev Atomically increases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
318         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
319         return true;
320     }
321 
322     /**
323      * @dev Atomically decreases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      * - `spender` must have allowance for the caller of at least
334      * `subtractedValue`.
335      */
336     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
337         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
338         return true;
339     }
340 
341     /**
342      * @dev Moves tokens `amount` from `sender` to `recipient`.
343      *
344      * This is internal function is equivalent to {transfer}, and can be used to
345      * e.g. implement automatic token fees, slashing mechanisms, etc.
346      *
347      * Emits a {Transfer} event.
348      *
349      * Requirements:
350      *
351      * - `sender` cannot be the zero address.
352      * - `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      */
355     function _transfer(address sender, address recipient, uint256 amount) internal {
356         require(sender != address(0), "ERC20: transfer from the zero address");
357         require(recipient != address(0), "ERC20: transfer to the zero address");
358 
359         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
360         _balances[recipient] = _balances[recipient].add(amount);
361         emit Transfer(sender, recipient, amount);
362     }
363 
364     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
365      * the total supply.
366      *
367      * Emits a {Transfer} event with `from` set to the zero address.
368      *
369      * Requirements
370      *
371      * - `to` cannot be the zero address.
372      */
373     function _mint(address account, uint256 amount) internal {
374         require(account != address(0), "ERC20: mint to the zero address");
375 
376         _totalSupply = _totalSupply.add(amount);
377         _balances[account] = _balances[account].add(amount);
378         emit Transfer(address(0), account, amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
396         _totalSupply = _totalSupply.sub(amount);
397         emit Transfer(account, address(0), amount);
398     }
399 
400     /**
401      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
402      *
403      * This is internal function is equivalent to `approve`, and can be used to
404      * e.g. set automatic allowances for certain subsystems, etc.
405      *
406      * Emits an {Approval} event.
407      *
408      * Requirements:
409      *
410      * - `owner` cannot be the zero address.
411      * - `spender` cannot be the zero address.
412      */
413     function _approve(address owner, address spender, uint256 amount) internal {
414         require(owner != address(0), "ERC20: approve from the zero address");
415         require(spender != address(0), "ERC20: approve to the zero address");
416 
417         _allowances[owner][spender] = amount;
418         emit Approval(owner, spender, amount);
419     }
420 
421     /**
422      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
423      * from the caller's allowance.
424      *
425      * See {_burn} and {_approve}.
426      */
427     function _burnFrom(address account, uint256 amount) internal {
428         _burn(account, amount);
429         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
430     }
431 }
432 
433 contract ERC20Token is ERC20 {
434 	string public constant name = "Crypto puzzles";
435 	string public constant symbol = "CPTE";
436 	uint8 public constant decimals = 18;
437 
438 	/**
439 	* @dev Constructor that gives _initialBeneficiar all of existing tokens.
440 	*/
441 	constructor(address _initialBeneficiar) public {
442 			uint256 INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
443 			_mint(_initialBeneficiar, INITIAL_SUPPLY);
444 	}
445 }