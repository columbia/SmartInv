1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4   
5     function totalSupply() external view returns (uint256);
6    
7     function balanceOf(address account) external view returns (uint256);
8    
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     
11     function allowance(address owner, address spender) external view returns (uint256);
12     
13     function approve(address spender, uint256 amount) external returns (bool);
14    
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16    
17     event Transfer(address indexed from, address indexed to, uint256 value);
18    
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 contract ERC20Detailed is IERC20 {
24     string private _name;
25     string private _symbol;
26     uint8 private _decimals;
27   
28     constructor (string memory name, string memory symbol, uint8 decimals) public {
29         _name = name;
30         _symbol = symbol;
31         _decimals = decimals;
32     }
33    
34     function name() public view returns (string memory) {
35         return _name;
36     }
37    
38     function symbol() public view returns (string memory) {
39         return _symbol;
40     }
41    
42     function decimals() public view returns (uint8) {
43         return _decimals;
44     }
45 }
46 
47 contract Context {
48   
49     constructor () internal { }
50     
51 
52     function _msgSender() internal view returns (address payable) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view returns (bytes memory) {
57         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
58         return msg.data;
59     }
60 }
61 
62 library SafeMath {
63     /**
64      * @dev Returns the addition of two unsigned integers, reverting on
65      * overflow.
66      *
67      * Counterpart to Solidity's `+` operator.
68      *
69      * Requirements:
70      * - Addition cannot overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75         return c;
76     }
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89     /**
90      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
91      * overflow (when the result is negative).
92      *
93      * Counterpart to Solidity's `-` operator.
94      *
95      * Requirements:
96      * - Subtraction cannot overflow.
97      *
98      * _Available since v2.4.0._
99      */
100     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103         return c;
104     }
105     /**
106      * @dev Returns the multiplication of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `*` operator.
110      *
111      * Requirements:
112      * - Multiplication cannot overflow.
113      */
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
118         if (a == 0) {
119             return 0;
120         }
121         uint256 c = a * b;
122         require(c / a == b, "SafeMath: multiplication overflow");
123         return c;
124     }
125     /**
126      * @dev Returns the integer division of two unsigned integers. Reverts on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return div(a, b, "SafeMath: division by zero");
138     }
139     /**
140      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator. Note: this function uses a
144      * `revert` opcode (which leaves remaining gas untouched) while Solidity
145      * uses an invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         // Solidity only automatically asserts when dividing by 0
154         require(b > 0, errorMessage);
155         uint256 c = a / b;
156         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157         return c;
158     }
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
161      * Reverts when dividing by zero.
162      *
163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
164      * opcode (which leaves remaining gas untouched) while Solidity uses an
165      * invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return mod(a, b, "SafeMath: modulo by zero");
172     }
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      *
184      * _Available since v2.4.0._
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 /**
192  * @dev Implementation of the {IERC20} interface.
193  *
194  * This implementation is agnostic to the way tokens are created. This means
195  * that a supply mechanism has to be added in a derived contract using {_mint}.
196  * For a generic mechanism see {ERC20Mintable}.
197  *
198  * TIP: For a detailed writeup see our guide
199  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
200  * to implement supply mechanisms].
201  *
202  * We have followed general OpenZeppelin guidelines: functions revert instead
203  * of returning `false` on failure. This behavior is nonetheless conventional
204  * and does not conflict with the expectations of ERC20 applications.
205  *
206  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
207  * This allows applications to reconstruct the allowance for all accounts just
208  * by listening to said events. Other implementations of the EIP may not emit
209  * these events, as it isn't required by the specification.
210  *
211  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
212  * functions have been added to mitigate the well-known issues around setting
213  * allowances. See {IERC20-approve}.
214  */
215 contract ERC20 is Context, IERC20 {
216     using SafeMath for uint256;
217     mapping (address => uint256) private _balances;
218     mapping (address => mapping (address => uint256)) private _allowances;
219     uint256 private _totalSupply;
220     /**
221      * @dev See {IERC20-totalSupply}.
222      */
223     function totalSupply() public view returns (uint256) {
224         return _totalSupply;
225     }
226     /**
227      * @dev See {IERC20-balanceOf}.
228      */
229     function balanceOf(address account) public view returns (uint256) {
230         return _balances[account];
231     }
232     /**
233      * @dev See {IERC20-transfer}.
234      *
235      * Requirements:
236      *
237      * - `recipient` cannot be the zero address.
238      * - the caller must have a balance of at least `amount`.
239      */
240     function transfer(address recipient, uint256 amount) public returns (bool) {
241         _transfer(_msgSender(), recipient, amount);
242         return true;
243     }
244     /**
245      * @dev See {IERC20-allowance}.
246      */
247     function allowance(address owner, address spender) public view returns (uint256) {
248         return _allowances[owner][spender];
249     }
250     /**
251      * @dev See {IERC20-approve}.
252      *
253      * Requirements:
254      *
255      * - `spender` cannot be the zero address.
256      */
257     function approve(address spender, uint256 amount) public returns (bool) {
258         _approve(_msgSender(), spender, amount);
259         return true;
260     }
261     /**
262      * @dev See {IERC20-transferFrom}.
263      *
264      * Emits an {Approval} event indicating the updated allowance. This is not
265      * required by the EIP. See the note at the beginning of {ERC20};
266      *
267      * Requirements:
268      * - `sender` and `recipient` cannot be the zero address.
269      * - `sender` must have a balance of at least `amount`.
270      * - the caller must have allowance for `sender`'s tokens of at least
271      * `amount`.
272      */
273     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
274         _transfer(sender, recipient, amount);
275         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
276         return true;
277     }
278     /**
279      * @dev Atomically increases the allowance granted to `spender` by the caller.
280      *
281      * This is an alternative to {approve} that can be used as a mitigation for
282      * problems described in {IERC20-approve}.
283      *
284      * Emits an {Approval} event indicating the updated allowance.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
291         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
292         return true;
293     }
294     /**
295      * @dev Atomically decreases the allowance granted to `spender` by the caller.
296      *
297      * This is an alternative to {approve} that can be used as a mitigation for
298      * problems described in {IERC20-approve}.
299      *
300      * Emits an {Approval} event indicating the updated allowance.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      * - `spender` must have allowance for the caller of at least
306      * `subtractedValue`.
307      */
308     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
309         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
310         return true;
311     }
312     /**
313      * @dev Moves tokens `amount` from `sender` to `recipient`.
314      *
315      * This is internal function is equivalent to {transfer}, and can be used to
316      * e.g. implement automatic token fees, slashing mechanisms, etc.
317      *
318      * Emits a {Transfer} event.
319      *
320      * Requirements:
321      *
322      * - `sender` cannot be the zero address.
323      * - `recipient` cannot be the zero address.
324      * - `sender` must have a balance of at least `amount`.
325      */
326     function _transfer(address sender, address recipient, uint256 amount) internal {
327         require(sender != address(0), "ERC20: transfer from the zero address");
328         require(recipient != address(0), "ERC20: transfer to the zero address");
329 
330         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
331         _balances[recipient] = _balances[recipient].add(amount);
332         emit Transfer(sender, recipient, amount);
333     }
334     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
335      * the total supply.
336      *
337      * Emits a {Transfer} event with `from` set to the zero address.
338      *
339      * Requirements
340      *
341      * - `to` cannot be the zero address.
342      */
343     function _mint(address account, uint256 amount) internal {
344         require(account != address(0), "ERC20: mint to the zero address");
345 
346         _totalSupply = _totalSupply.add(amount);
347         _balances[account] = _balances[account].add(amount);
348         emit Transfer(address(0), account, amount);
349     }
350     /**
351      * @dev Destroys `amount` tokens from `account`, reducing the
352      * total supply.
353      *
354      * Emits a {Transfer} event with `to` set to the zero address.
355      *
356      * Requirements
357      *
358      * - `account` cannot be the zero address.
359      * - `account` must have at least `amount` tokens.
360      */
361     function _burn(address account, uint256 amount) internal {
362         require(account != address(0), "ERC20: burn from the zero address");
363 
364         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
365         _totalSupply = _totalSupply.sub(amount);
366         emit Transfer(account, address(0), amount);
367     }
368     /**
369      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
370      *
371      * This is internal function is equivalent to `approve`, and can be used to
372      * e.g. set automatic allowances for certain subsystems, etc.
373      *
374      * Emits an {Approval} event.
375      *
376      * Requirements:
377      *
378      * - `owner` cannot be the zero address.
379      * - `spender` cannot be the zero address.
380      */
381     function _approve(address owner, address spender, uint256 amount) internal {
382         require(owner != address(0), "ERC20: approve from the zero address");
383         require(spender != address(0), "ERC20: approve to the zero address");
384 
385         _allowances[owner][spender] = amount;
386         emit Approval(owner, spender, amount);
387     }
388     /**
389      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
390      * from the caller's allowance.
391      *
392      * See {_burn} and {_approve}.
393      */
394     function _burnFrom(address account, uint256 amount) internal {
395         _burn(account, amount);
396         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
397     }
398 }
399 /**
400  * @dev Extension of {ERC20} that allows token holders to destroy both their own
401  * tokens and those that they have an allowance for, in a way that can be
402  * recognized off-chain (via event analysis).
403  */
404 contract ERC20Burnable is Context, ERC20 {
405     /**
406      * @dev Destroys `amount` tokens from the caller.
407      *
408      * See {ERC20-_burn}.
409      */
410     function burn(uint256 amount) public {
411         _burn(_msgSender(), amount);
412     }
413 
414     /**
415      * @dev See {ERC20-_burnFrom}.
416      */
417     function burnFrom(address account, uint256 amount) public {
418         _burnFrom(account, amount);
419     }
420 }
421 /**
422  * @title SimpleToken
423  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
424  * Note they can later distribute these tokens as they wish using `transfer` and other
425  * `ERC20` functions.
426  */
427 contract SimpleToken is ERC20, ERC20Detailed,ERC20Burnable {
428     /**
429      * @dev Constructor that gives _msgSender() all of existing tokens.
430      */
431     constructor () public ERC20Detailed("Ulgen Hash Power", "UHP", 18) {
432         _mint(_msgSender(), 2100000000 * (10 ** uint256(decimals())));
433     }
434 }