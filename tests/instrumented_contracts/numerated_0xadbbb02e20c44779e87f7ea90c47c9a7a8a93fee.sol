1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9  
10     function balanceOf(address account) external view returns (uint256);
11 
12     function transfer(address recipient, uint256 amount) external returns (bool);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     function approve(address spender, uint256 amount) external returns (bool);
17 
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     /**
27      * @dev Returns the addition of two unsigned integers, reverting on
28      * overflow.
29      *
30      * Counterpart to Solidity's `+` operator.
31      *
32      * Requirements:
33      * - Addition cannot overflow.
34      */
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38 
39         return c;
40     }
41 
42     /**
43      * @dev Returns the subtraction of two unsigned integers, reverting on
44      * overflow (when the result is negative).
45      *
46      * Counterpart to Solidity's `-` operator.
47      *
48      * Requirements:
49      * - Subtraction cannot overflow.
50      */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         require(b <= a, "SafeMath: subtraction overflow");
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
65      * - Multiplication cannot overflow.
66      */
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69         // benefit is lost if 'b' is also tested.
70         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
71         if (a == 0) {
72             return 0;
73         }
74 
75         uint256 c = a * b;
76         require(c / a == b, "SafeMath: multiplication overflow");
77 
78         return c;
79     }
80 
81     /**
82      * @dev Returns the integer division of two unsigned integers. Reverts on
83      * division by zero. The result is rounded towards zero.
84      *
85      * Counterpart to Solidity's `/` operator. Note: this function uses a
86      * `revert` opcode (which leaves remaining gas untouched) while Solidity
87      * uses an invalid opcode to revert (consuming all remaining gas).
88      *
89      * Requirements:
90      * - The divisor cannot be zero.
91      */
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         // Solidity only automatically asserts when dividing by 0
94         require(b > 0, "SafeMath: division by zero");
95         uint256 c = a / b;
96         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
103      * Reverts when dividing by zero.
104      *
105      * Counterpart to Solidity's `%` operator. This function uses a `revert`
106      * opcode (which leaves remaining gas untouched) while Solidity uses an
107      * invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      * - The divisor cannot be zero.
111      */
112     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b != 0, "SafeMath: modulo by zero");
114         return a % b;
115     }
116 }
117 
118 /**
119  * @dev Implementation of the `IERC20` interface.
120  *
121  * This implementation is agnostic to the way tokens are created. This means
122  * that a supply mechanism has to be added in a derived contract using `_mint`.
123  * For a generic mechanism see `ERC20Mintable`.
124  *
125  * *For a detailed writeup see our guide [How to implement supply
126  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
127  *
128  * We have followed general OpenZeppelin guidelines: functions revert instead
129  * of returning `false` on failure. This behavior is nonetheless conventional
130  * and does not conflict with the expectations of ERC20 applications.
131  *
132  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
133  * This allows applications to reconstruct the allowance for all accounts just
134  * by listening to said events. Other implementations of the EIP may not emit
135  * these events, as it isn't required by the specification.
136  *
137  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
138  * functions have been added to mitigate the well-known issues around setting
139  * allowances. See `IERC20.approve`.
140  */
141 contract BitCrystals is IERC20 {
142     using SafeMath for uint256;
143 
144     mapping (address => uint256) private _balances;
145 
146     mapping (address => mapping (address => uint256)) private _allowances;
147 
148     // NOTE Start of https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v2.3.0/contracts/token/ERC20/ERC20Detailed.sol
149     string private _name;
150     string private _symbol;
151     uint8 private _decimals;
152 
153     constructor (string memory name, string memory symbol, uint8 decimals) public {
154         _name = name;
155         _symbol = symbol;
156         _decimals = decimals;
157 
158         _mint(msg.sender, 18000000 * 10 ** uint256(decimals)); // CAUTION!
159     }
160 
161     /**
162      * @dev Returns the name of the token.
163      */
164     function name() public view returns (string memory) {
165         return _name;
166     }
167 
168     /**
169      * @dev Returns the symbol of the token, usually a shorter version of the
170      * name.
171      */
172     function symbol() public view returns (string memory) {
173         return _symbol;
174     }
175 
176     /**
177      * @dev Returns the number of decimals used to get its user representation.
178      * For example, if `decimals` equals `2`, a balance of `505` tokens should
179      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
180      *
181      * Tokens usually opt for a value of 18, imitating the relationship between
182      * Ether and Wei.
183      *
184      * > Note that this information is only used for _display_ purposes: it in
185      * no way affects any of the arithmetic of the contract, including
186      * `IERC20.balanceOf` and `IERC20.transfer`.
187      */
188     function decimals() public view returns (uint8) {
189         return _decimals;
190     }
191     // NOTE End of https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v2.3.0/contracts/token/ERC20/ERC20Detailed.sol
192 
193     uint256 private _totalSupply;
194 
195     /**
196      * @dev See `IERC20.totalSupply`.
197      */
198     function totalSupply() public view returns (uint256) {
199         return _totalSupply;
200     }
201 
202     /**
203      * @dev See `IERC20.balanceOf`.
204      */
205     function balanceOf(address account) public view returns (uint256) {
206         return _balances[account];
207     }
208 
209     /**
210      * @dev See `IERC20.transfer`.
211      *
212      * Requirements:
213      *
214      * - `recipient` cannot be the zero address.
215      * - the caller must have a balance of at least `amount`.
216      */
217     function transfer(address recipient, uint256 amount) public returns (bool) {
218         _transfer(msg.sender, recipient, amount);
219         return true;
220     }
221 
222     /**
223      * @dev See `IERC20.allowance`.
224      */
225     function allowance(address owner, address spender) public view returns (uint256) {
226         return _allowances[owner][spender];
227     }
228 
229     /**
230      * @dev See `IERC20.approve`.
231      *
232      * Requirements:
233      *
234      * - `spender` cannot be the zero address.
235      */
236     function approve(address spender, uint256 value) public returns (bool) {
237         _approve(msg.sender, spender, value);
238         return true;
239     }
240 
241     /**
242      * @dev See `IERC20.transferFrom`.
243      *
244      * Emits an `Approval` event indicating the updated allowance. This is not
245      * required by the EIP. See the note at the beginning of `ERC20`;
246      *
247      * Requirements:
248      * - `sender` and `recipient` cannot be the zero address.
249      * - `sender` must have a balance of at least `value`.
250      * - the caller must have allowance for `sender`'s tokens of at least
251      * `amount`.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
254         _transfer(sender, recipient, amount);
255         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
256         return true;
257     }
258 
259     /**
260      * @dev Atomically increases the allowance granted to `spender` by the caller.
261      *
262      * This is an alternative to `approve` that can be used as a mitigation for
263      * problems described in `IERC20.approve`.
264      *
265      * Emits an `Approval` event indicating the updated allowance.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      */
271     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
272         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
273         return true;
274     }
275 
276     /**
277      * @dev Atomically decreases the allowance granted to `spender` by the caller.
278      *
279      * This is an alternative to `approve` that can be used as a mitigation for
280      * problems described in `IERC20.approve`.
281      *
282      * Emits an `Approval` event indicating the updated allowance.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      * - `spender` must have allowance for the caller of at least
288      * `subtractedValue`.
289      */
290     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
291         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
292         return true;
293     }
294 
295     /**
296      * @dev Moves tokens `amount` from `sender` to `recipient`.
297      *
298      * This is internal function is equivalent to `transfer`, and can be used to
299      * e.g. implement automatic token fees, slashing mechanisms, etc.
300      *
301      * Emits a `Transfer` event.
302      *
303      * Requirements:
304      *
305      * - `sender` cannot be the zero address.
306      * - `recipient` cannot be the zero address.
307      * - `sender` must have a balance of at least `amount`.
308      */
309     function _transfer(address sender, address recipient, uint256 amount) internal {
310         require(sender != address(0), "ERC20: transfer from the zero address");
311         require(recipient != address(0), "ERC20: transfer to the zero address");
312 
313         _balances[sender] = _balances[sender].sub(amount);
314         _balances[recipient] = _balances[recipient].add(amount);
315         emit Transfer(sender, recipient, amount);
316     }
317 
318     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
319      * the total supply.
320      *
321      * Emits a `Transfer` event with `from` set to the zero address.
322      *
323      * Requirements
324      *
325      * - `to` cannot be the zero address.
326      */
327     function _mint(address account, uint256 amount) internal {
328         require(account != address(0), "ERC20: mint to the zero address");
329 
330         _totalSupply = _totalSupply.add(amount);
331         _balances[account] = _balances[account].add(amount);
332         emit Transfer(address(0), account, amount);
333     }
334 
335      /**
336      * @dev Destroys `amount` tokens from `account`, reducing the
337      * total supply.
338      *
339      * Emits a `Transfer` event with `to` set to the zero address.
340      *
341      * Requirements
342      *
343      * - `account` cannot be the zero address.
344      * - `account` must have at least `amount` tokens.
345      */
346     function _burn(address account, uint256 value) internal {
347         require(account != address(0), "ERC20: burn from the zero address");
348 
349     _balances[account] = _balances[account].sub(value);
350         _totalSupply = _totalSupply.sub(value);
351         emit Transfer(account, address(0), value);
352     }
353 
354     /**
355      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
356      *
357      * This is internal function is equivalent to `approve`, and can be used to
358      * e.g. set automatic allowances for certain subsystems, etc.
359      *
360      * Emits an `Approval` event.
361      *
362      * Requirements:
363      *
364      * - `owner` cannot be the zero address.
365      * - `spender` cannot be the zero address.
366      */
367     function _approve(address owner, address spender, uint256 value) internal {
368         require(owner != address(0), "ERC20: approve from the zero address");
369         require(spender != address(0), "ERC20: approve to the zero address");
370 
371         _allowances[owner][spender] = value;
372         emit Approval(owner, spender, value);
373     }
374 
375     /**
376      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
377      * from the caller's allowance.
378      *
379      * See `_burn` and `_approve`.
380      */
381     function _burnFrom(address account, uint256 amount) internal {
382         _burn(account, amount);
383         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
384     }
385 }