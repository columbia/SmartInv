1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // 'World Bank' token contract
5 //
6 // Symbol                        : WBT
7 // Name                          : World Bank token
8 // Total supply                  : 16*10^6
9 // Decimals                      : 18
10 //
11 // Enjoy.
12 //
13 //
14 // ----------------------------------------------------------------------------
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, reverting on
18      * overflow.
19      *
20      * Counterpart to Solidity's `+` operator.
21      *
22      * Requirements:
23      * - Addition cannot overflow.
24      */
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28 
29         return c;
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, reverting on
34      * overflow (when the result is negative).
35      *
36      * Counterpart to Solidity's `-` operator.
37      *
38      * Requirements:
39      * - Subtraction cannot overflow.
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a, "SafeMath: subtraction overflow");
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Returns the multiplication of two unsigned integers, reverting on
50      * overflow.
51      *
52      * Counterpart to Solidity's `*` operator.
53      *
54      * Requirements:
55      * - Multiplication cannot overflow.
56      */
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59         // benefit is lost if 'b' is also tested.
60         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61         if (a == 0) {
62             return 0;
63         }
64 
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the integer division of two unsigned integers. Reverts on
73      * division by zero. The result is rounded towards zero.
74      *
75      * Counterpart to Solidity's `/` operator. Note: this function uses a
76      * `revert` opcode (which leaves remaining gas untouched) while Solidity
77      * uses an invalid opcode to revert (consuming all remaining gas).
78      *
79      * Requirements:
80      * - The divisor cannot be zero.
81      */
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Solidity only automatically asserts when dividing by 0
84         require(b > 0, "SafeMath: division by zero");
85         uint256 c = a / b;
86         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
93      * Reverts when dividing by zero.
94      *
95      * Counterpart to Solidity's `%` operator. This function uses a `revert`
96      * opcode (which leaves remaining gas untouched) while Solidity uses an
97      * invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      * - The divisor cannot be zero.
101      */
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b != 0, "SafeMath: modulo by zero");
104         return a % b;
105     }
106 }
107 interface IERC20 {
108     /**
109      * @dev Returns the amount of tokens in existence.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     /**
114      * @dev Returns the amount of tokens owned by `account`.
115      */
116     function balanceOf(address account) external view returns (uint256);
117 
118     /**
119      * @dev Moves `amount` tokens from the caller's account to `recipient`.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a `Transfer` event.
124      */
125     function transfer(address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Returns the remaining number of tokens that `spender` will be
129      * allowed to spend on behalf of `owner` through `transferFrom`. This is
130      * zero by default.
131      *
132      * This value changes when `approve` or `transferFrom` are called.
133      */
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * > Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an `Approval` event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a `Transfer` event.
160      */
161     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to `approve`. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 contract WbankToken is IERC20 {
178     using SafeMath for uint256;
179 
180     mapping (address => uint256) private _balances;
181 
182     mapping (address => mapping (address => uint256)) private _allowances;
183 
184     uint256 private _totalSupply;
185     string private _name;
186     string private _symbol;
187     uint8 private _decimals;
188     uint256 private _releaseTime = 1704085200;
189     uint256 private amount_wbAddress = 11*10**24;
190     uint256 private amount_Locked = 5*10**24;
191 
192     address private address_wb;
193 
194     function _issueTokens(address _to, uint256 _amount) internal {
195         require(_balances[_to] == 0);
196         _balances[_to] = _balances[_to].add(_amount);
197         emit Transfer(address(0), _to, _amount);
198     }
199     constructor (
200       address _wbAddress
201     ) public {
202         _name = "World Bank token";
203         _symbol = "WBT";
204         _decimals = 18;
205         _totalSupply = 16*10**24;
206         address_wb = _wbAddress;
207 
208         _issueTokens(address_wb, amount_wbAddress);
209     }
210 
211     function release() public {
212       require(block.timestamp >= _releaseTime, "TokenTimelock: current time is before release time");
213       require(amount_Locked > 0);
214       _issueTokens(address_wb, amount_Locked);
215       amount_Locked = amount_Locked.sub(amount_Locked);
216     }
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() public view returns (string memory) {
221         return _name;
222     }
223 
224     /**
225      * @dev Returns the symbol of the token, usually a shorter version of the
226      * name.
227      */
228     function symbol() public view returns (string memory) {
229         return _symbol;
230     }
231 
232     /**
233      * @dev Returns the number of decimals used to get its user representation.
234      * For example, if `decimals` equals `2`, a balance of `505` tokens should
235      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
236      *
237      * Tokens usually opt for a value of 18, imitating the relationship between
238      * Ether and Wei.
239      *
240      * > Note that this information is only used for _display_ purposes: it in
241      * no way affects any of the arithmetic of the contract, including
242      * `IERC20.balanceOf` and `IERC20.transfer`.
243      */
244     function decimals() public view returns (uint8) {
245         return _decimals;
246     }
247     /**
248      * @dev See `IERC20.totalSupply`.
249      */
250     function totalSupply() public view returns (uint256) {
251         return _totalSupply;
252     }
253 
254     /**
255      * @dev See `IERC20.balanceOf`.
256      */
257     function balanceOf(address account) public view returns (uint256) {
258         return _balances[account];
259     }
260 
261     /**
262      * @dev See `IERC20.transfer`.
263      *
264      * Requirements:
265      *
266      * - `recipient` cannot be the zero address.
267      * - the caller must have a balance of at least `amount`.
268      */
269     function transfer(address recipient, uint256 amount) public returns (bool) {
270         _transfer(msg.sender, recipient, amount);
271         return true;
272     }
273 
274     /**
275      * @dev See `IERC20.allowance`.
276      */
277     function allowance(address owner, address spender) public view returns (uint256) {
278         return _allowances[owner][spender];
279     }
280 
281     /**
282      * @dev See `IERC20.approve`.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      */
288     function approve(address spender, uint256 value) public returns (bool) {
289         _approve(msg.sender, spender, value);
290         return true;
291     }
292 
293     /**
294      * @dev See `IERC20.transferFrom`.
295      *
296      * Emits an `Approval` event indicating the updated allowance. This is not
297      * required by the EIP. See the note at the beginning of `ERC20`;
298      *
299      * Requirements:
300      * - `sender` and `recipient` cannot be the zero address.
301      * - `sender` must have a balance of at least `value`.
302      * - the caller must have allowance for `sender`'s tokens of at least
303      * `amount`.
304      */
305     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
306         _transfer(sender, recipient, amount);
307         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
308         return true;
309     }
310 
311     /**
312      * @dev Atomically increases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to `approve` that can be used as a mitigation for
315      * problems described in `IERC20.approve`.
316      *
317      * Emits an `Approval` event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
324         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to `approve` that can be used as a mitigation for
332      * problems described in `IERC20.approve`.
333      *
334      * Emits an `Approval` event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
343         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
344         return true;
345     }
346 
347     /**
348      * @dev Moves tokens `amount` from `sender` to `recipient`.
349      *
350      * This is internal function is equivalent to `transfer`, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a `Transfer` event.
354      *
355      * Requirements:
356      *
357      * - `sender` cannot be the zero address.
358      * - `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `amount`.
360      */
361     function _transfer(address sender, address recipient, uint256 amount) internal {
362         require(sender != address(0), "ERC20: transfer from the zero address");
363         require(recipient != address(0), "ERC20: transfer to the zero address");
364 
365         _balances[sender] = _balances[sender].sub(amount);
366         _balances[recipient] = _balances[recipient].add(amount);
367         emit Transfer(sender, recipient, amount);
368     }
369     /**
370      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
371      *
372      * This is internal function is equivalent to `approve`, and can be used to
373      * e.g. set automatic allowances for certain subsystems, etc.
374      *
375      * Emits an `Approval` event.
376      *
377      * Requirements:
378      *
379      * - `owner` cannot be the zero address.
380      * - `spender` cannot be the zero address.
381      */
382     function _approve(address owner, address spender, uint256 value) internal {
383         require(owner != address(0), "ERC20: approve from the zero address");
384         require(spender != address(0), "ERC20: approve to the zero address");
385 
386         _allowances[owner][spender] = value;
387         emit Approval(owner, spender, value);
388     }
389 }
