1 pragma solidity ^0.5.16;
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
63         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      *
100      * _Available since v2.4.0._
101      */
102     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         // Solidity only automatically asserts when dividing by 0
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
113      * Reverts when dividing by zero.
114      *
115      * Counterpart to Solidity's `%` operator. This function uses a `revert`
116      * opcode (which leaves remaining gas untouched) while Solidity uses an
117      * invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      * - The divisor cannot be zero.
121      */
122     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
123         return mod(a, b, "SafeMath: modulo by zero");
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts with custom message when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      *
137      * _Available since v2.4.0._
138      */
139     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b != 0, errorMessage);
141         return a % b;
142     }
143 }
144 
145 interface IERC20 {
146     /**
147      * @dev Returns the amount of tokens in existence.
148      */
149     function totalSupply() external view returns (uint256);
150 
151     /**
152      * @dev Returns the amount of tokens owned by `account`.
153      */
154     function balanceOf(address account) external view returns (uint256);
155 
156     /**
157      * @dev Moves `amount` tokens from the caller's account to `recipient`.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transfer(address recipient, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Returns the remaining number of tokens that `spender` will be
167      * allowed to spend on behalf of `owner` through {transferFrom}. This is
168      * zero by default.
169      *
170      * This value changes when {approve} or {transferFrom} are called.
171      */
172     function allowance(address owner, address spender) external view returns (uint256);
173 
174     /**
175      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * IMPORTANT: Beware that changing an allowance with this method brings the risk
180      * that someone may use both the old and the new allowance by unfortunate
181      * transaction ordering. One possible solution to mitigate this race
182      * condition is to first reduce the spender's allowance to 0 and set the
183      * desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      *
186      * Emits an {Approval} event.
187      */
188     function approve(address spender, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Moves `amount` tokens from `sender` to `recipient` using the
192      * allowance mechanism. `amount` is then deducted from the caller's
193      * allowance.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
200 
201     /**
202      * @dev Emitted when `value` tokens are moved from one account (`from`) to
203      * another (`to`).
204      *
205      * Note that `value` may be zero.
206      */
207     event Transfer(address indexed from, address indexed to, uint256 value);
208 
209     /**
210      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
211      * a call to {approve}. `value` is the new allowance.
212      */
213     event Approval(address indexed owner, address indexed spender, uint256 value);
214 }
215 
216 contract Context {
217     // Empty internal constructor, to prevent people from mistakenly deploying
218     // an instance of this contract, which should be used via inheritance.
219     constructor () internal { }
220     // solhint-disable-previous-line no-empty-blocks
221 
222     function _msgSender() internal view returns (address payable) {
223         return msg.sender;
224     }
225 
226     function _msgData() internal view returns (bytes memory) {
227         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
228         return msg.data;
229     }
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
433 contract WBCBToken is ERC20 {
434     string public name = "World Block Club Token";
435     string public symbol = "WBCB";
436     uint8 public decimals = 18;
437     uint256 public INITIAL_SUPPLY = 50000 * 10**uint256(decimals);
438 
439     constructor() public {
440         _mint(msg.sender, INITIAL_SUPPLY);
441     }
442 }