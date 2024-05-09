1 /**
2  *YFRocket.finance
3 */
4 
5 pragma solidity ^0.5.9;
6 
7 
8 library SafeMath {
9     /**
10      * @dev Returns the addition of two unsigned integers, reverting on
11      * overflow.
12      *
13      * Counterpart to Solidity's `+` operator.
14      *
15      * Requirements:
16      * - Addition cannot overflow.
17      */
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Returns the subtraction of two unsigned integers, reverting on
27      * overflow (when the result is negative).
28      *
29      * Counterpart to Solidity's `-` operator.
30      *
31      * Requirements:
32      * - Subtraction cannot overflow.
33      */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b <= a, "SafeMath: subtraction overflow");
36         uint256 c = a - b;
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, reverting on
43      * overflow.
44      *
45      * Counterpart to Solidity's `*` operator.
46      *
47      * Requirements:
48      * - Multiplication cannot overflow.
49      */
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52         // benefit is lost if 'b' is also tested.
53         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54         if (a == 0) {
55             return 0;
56         }
57 
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the integer division of two unsigned integers. Reverts on
66      * division by zero. The result is rounded towards zero.
67      *
68      * Counterpart to Solidity's `/` operator. Note: this function uses a
69      * `revert` opcode (which leaves remaining gas untouched) while Solidity
70      * uses an invalid opcode to revert (consuming all remaining gas).
71      *
72      * Requirements:
73      * - The divisor cannot be zero.
74      */
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Solidity only automatically asserts when dividing by 0
77         require(b > 0, "SafeMath: division by zero");
78         uint256 c = a / b;
79         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80 
81         return c;
82     }
83 
84     /**
85      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
86      * Reverts when dividing by zero.
87      *
88      * Counterpart to Solidity's `%` operator. This function uses a `revert`
89      * opcode (which leaves remaining gas untouched) while Solidity uses an
90      * invalid opcode to revert (consuming all remaining gas).
91      *
92      * Requirements:
93      * - The divisor cannot be zero.
94      */
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b != 0, "SafeMath: modulo by zero");
97         return a % b;
98     }
99 }
100 interface IERC20 {
101     /**
102      * @dev Returns the amount of tokens in existence.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     /**
107      * @dev Returns the amount of tokens owned by `account`.
108      */
109     function balanceOf(address account) external view returns (uint256);
110 
111     /**
112      * @dev Moves `amount` tokens from the caller's account to `recipient`.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a `Transfer` event.
117      */
118     function transfer(address recipient, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Returns the remaining number of tokens that `spender` will be
122      * allowed to spend on behalf of `owner` through `transferFrom`. This is
123      * zero by default.
124      *
125      * This value changes when `approve` or `transferFrom` are called.
126      */
127     function allowance(address owner, address spender) external view returns (uint256);
128 
129     /**
130      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * > Beware that changing an allowance with this method brings the risk
135      * that someone may use both the old and the new allowance by unfortunate
136      * transaction ordering. One possible solution to mitigate this race
137      * condition is to first reduce the spender's allowance to 0 and set the
138      * desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      *
141      * Emits an `Approval` event.
142      */
143     function approve(address spender, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Moves `amount` tokens from `sender` to `recipient` using the
147      * allowance mechanism. `amount` is then deducted from the caller's
148      * allowance.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a `Transfer` event.
153      */
154     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Emitted when `value` tokens are moved from one account (`from`) to
158      * another (`to`).
159      *
160      * Note that `value` may be zero.
161      */
162     event Transfer(address indexed from, address indexed to, uint256 value);
163 
164     /**
165      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
166      * a call to `approve`. `value` is the new allowance.
167      */
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169     
170     event AddPreSaleList(address indexed from, address indexed to, uint256 value);
171 }
172 contract YFRocket is IERC20 {
173     using SafeMath for uint256;
174 
175     mapping (address => uint256) private _pre_sale_list;
176     mapping (address => uint256) private _balances;
177     mapping (address => mapping (address => uint256)) private _allowances;
178 
179     uint256 private _totalSupply;
180     string private _name;
181     string private _symbol;
182     uint8 private _decimals;
183     uint256 private amount_release;
184     address payable private _owner;
185 
186     function _issueTokens(address _to, uint256 _amount) internal {
187         require(_balances[_to] == 0);
188         _balances[_to] = _balances[_to].add(_amount);
189         emit Transfer(address(0), _to, _amount);
190     }
191     constructor () public {
192         _name = "YFRocket";
193         _symbol = "YFR";
194         _decimals = 18;
195         _totalSupply = 666666000000000000000000 ;
196         amount_release = 666666000000000000000000 ;
197         _owner = msg.sender;
198         _issueTokens(_owner, amount_release);
199     }
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view returns (string memory) {
204         return _name;
205     }
206 
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view returns (string memory) {
212         return _symbol;
213     }
214 
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei.
222      *
223      * > Note that this information is only used for _display_ purposes: it in
224      * no way affects any of the arithmetic of the contract, including
225      * `IERC20.balanceOf` and `IERC20.transfer`.
226      */
227     function decimals() public view returns (uint8) {
228         return _decimals;
229     }
230     /**
231      * @dev See `IERC20.totalSupply`.
232      */
233     function totalSupply() public view returns (uint256) {
234         return _totalSupply;
235     }
236 
237     /**
238      * @dev See `IERC20.balanceOf`.
239      */
240     function balanceOf(address account) public view returns (uint256) {
241         return _balances[account];
242     }
243 
244     /**
245      * @dev See `IERC20.transfer`.
246      *
247      * Requirements:
248      *
249      * - `recipient` cannot be the zero address.
250      * - the caller must have a balance of at least `amount`.
251      */
252     function transfer(address recipient, uint256 amount) public returns (bool) {
253         _transfer(msg.sender, recipient, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See `IERC20.allowance`.
259      */
260     function allowance(address owner, address spender) public view returns (uint256) {
261         return _allowances[owner][spender];
262     }
263 
264     /**
265      * @dev See `IERC20.approve`.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      */
271     function approve(address spender, uint256 value) public returns (bool) {
272         _approve(msg.sender, spender, value);
273         return true;
274     }
275 
276     /**
277      * @dev See `IERC20.transferFrom`.
278      *
279      * Emits an `Approval` event indicating the updated allowance. This is not
280      * required by the EIP. See the note at the beginning of `ERC20`;
281      *
282      * Requirements:
283      * - `sender` and `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `value`.
285      * - the caller must have allowance for `sender`'s tokens of at least
286      * `amount`.
287      */
288     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
289         _transfer(sender, recipient, amount);
290         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
291         return true;
292     }
293 
294     /**
295      * @dev Atomically increases the allowance granted to `spender` by the caller.
296      *
297      * This is an alternative to `approve` that can be used as a mitigation for
298      * problems described in `IERC20.approve`.
299      *
300      * Emits an `Approval` event indicating the updated allowance.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      */
306     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
307         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
308         return true;
309     }
310 
311     /**
312      * @dev Atomically decreases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to `approve` that can be used as a mitigation for
315      * problems described in `IERC20.approve`.
316      *
317      * Emits an `Approval` event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      * - `spender` must have allowance for the caller of at least
323      * `subtractedValue`.
324      */
325     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
326         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
327         return true;
328     }
329 
330     /**
331      * @dev Moves tokens `amount` from `sender` to `recipient`.
332      *
333      * This is internal function is equivalent to `transfer`, and can be used to
334      * e.g. implement automatic token fees, slashing mechanisms, etc.
335      *
336      * Emits a `Transfer` event.
337      *
338      * Requirements:
339      *
340      * - `sender` cannot be the zero address.
341      * - `recipient` cannot be the zero address.
342      * - `sender` must have a balance of at least `amount`.
343      */
344      function () external payable {
345         require(msg.value > 0);
346         _pre_sale_list[msg.sender] = _pre_sale_list[msg.sender].add(msg.value);
347         _owner.transfer(msg.value);
348         emit AddPreSaleList( msg.sender, address(this), msg.value);
349     }
350     /**
351     * Transfer token
352     **/
353     function _transfer(address sender, address recipient, uint256 amount) internal {
354         require(sender != address(0), "ERC20: transfer from the zero address");
355         require(recipient != address(0), "ERC20: transfer to the zero address");
356 
357         _balances[sender] = _balances[sender].sub(amount);
358         _balances[recipient] = _balances[recipient].add(amount);
359         emit Transfer(sender, recipient, amount);
360     }
361     /**
362      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
363      *
364      * This is internal function is equivalent to `approve`, and can be used to
365      * e.g. set automatic allowances for certain subsystems, etc.
366      *
367      * Emits an `Approval` event.
368      *
369      * Requirements:
370      *
371      * - `owner` cannot be the zero address.
372      * - `spender` cannot be the zero address.
373      */
374     function _approve(address owner, address spender, uint256 value) internal {
375         require(owner != address(0), "ERC20: approve from the zero address");
376         require(spender != address(0), "ERC20: approve to the zero address");
377 
378         _allowances[owner][spender] = value;
379         emit Approval(owner, spender, value);
380     }
381 }