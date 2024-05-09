1 pragma solidity ^0.5.11;
2 
3 // ----------------------------------------------------------------------------
4 // 'Astra Network Token' contract
5 //
6 // Symbol                        : ANX
7 // Name                          : Astra Network Token
8 // Total supply                  : 17*10^9
9 // Decimals                      : 8
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
177 contract AstraNetwork is IERC20 {
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
188     uint256 private amount_release = 10**27;
189 
190     address private anx_address;
191 
192     function _issueTokens(address _to, uint256 _amount) internal {
193         require(_balances[_to] == 0);
194         _balances[_to] = _balances[_to].add(_amount);
195         emit Transfer(address(0), _to, _amount);
196     }
197     constructor (
198       address _ANXAddress
199     ) public {
200         _name = "Astra Network Token";
201         _symbol = "ANX";
202         _decimals = 18;
203         _totalSupply = 10**27;
204         anx_address = _ANXAddress;
205 
206         _issueTokens(anx_address, amount_release);
207     }
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view returns (string memory) {
212         return _name;
213     }
214 
215     /**
216      * @dev Returns the symbol of the token, usually a shorter version of the
217      * name.
218      */
219     function symbol() public view returns (string memory) {
220         return _symbol;
221     }
222 
223     /**
224      * @dev Returns the number of decimals used to get its user representation.
225      * For example, if `decimals` equals `2`, a balance of `505` tokens should
226      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
227      *
228      * Tokens usually opt for a value of 18, imitating the relationship between
229      * Ether and Wei.
230      *
231      * > Note that this information is only used for _display_ purposes: it in
232      * no way affects any of the arithmetic of the contract, including
233      * `IERC20.balanceOf` and `IERC20.transfer`.
234      */
235     function decimals() public view returns (uint8) {
236         return _decimals;
237     }
238     /**
239      * @dev See `IERC20.totalSupply`.
240      */
241     function totalSupply() public view returns (uint256) {
242         return _totalSupply;
243     }
244 
245     /**
246      * @dev See `IERC20.balanceOf`.
247      */
248     function balanceOf(address account) public view returns (uint256) {
249         return _balances[account];
250     }
251 
252     /**
253      * @dev See `IERC20.transfer`.
254      *
255      * Requirements:
256      *
257      * - `recipient` cannot be the zero address.
258      * - the caller must have a balance of at least `amount`.
259      */
260     function transfer(address recipient, uint256 amount) public returns (bool) {
261         _transfer(msg.sender, recipient, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See `IERC20.allowance`.
267      */
268     function allowance(address owner, address spender) public view returns (uint256) {
269         return _allowances[owner][spender];
270     }
271 
272     /**
273      * @dev See `IERC20.approve`.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 value) public returns (bool) {
280         _approve(msg.sender, spender, value);
281         return true;
282     }
283 
284     /**
285      * @dev See `IERC20.transferFrom`.
286      *
287      * Emits an `Approval` event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of `ERC20`;
289      *
290      * Requirements:
291      * - `sender` and `recipient` cannot be the zero address.
292      * - `sender` must have a balance of at least `value`.
293      * - the caller must have allowance for `sender`'s tokens of at least
294      * `amount`.
295      */
296     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
299         return true;
300     }
301 
302     /**
303      * @dev Atomically increases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to `approve` that can be used as a mitigation for
306      * problems described in `IERC20.approve`.
307      *
308      * Emits an `Approval` event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      */
314     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
315         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
316         return true;
317     }
318 
319     /**
320      * @dev Atomically decreases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to `approve` that can be used as a mitigation for
323      * problems described in `IERC20.approve`.
324      *
325      * Emits an `Approval` event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      * - `spender` must have allowance for the caller of at least
331      * `subtractedValue`.
332      */
333     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
334         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
335         return true;
336     }
337 
338     /**
339      * @dev Moves tokens `amount` from `sender` to `recipient`.
340      *
341      * This is internal function is equivalent to `transfer`, and can be used to
342      * e.g. implement automatic token fees, slashing mechanisms, etc.
343      *
344      * Emits a `Transfer` event.
345      *
346      * Requirements:
347      *
348      * - `sender` cannot be the zero address.
349      * - `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      */
352     function _transfer(address sender, address recipient, uint256 amount) internal {
353         require(sender != address(0), "ERC20: transfer from the zero address");
354         require(recipient != address(0), "ERC20: transfer to the zero address");
355 
356         _balances[sender] = _balances[sender].sub(amount);
357         _balances[recipient] = _balances[recipient].add(amount);
358         emit Transfer(sender, recipient, amount);
359     }
360     /**
361      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
362      *
363      * This is internal function is equivalent to `approve`, and can be used to
364      * e.g. set automatic allowances for certain subsystems, etc.
365      *
366      * Emits an `Approval` event.
367      *
368      * Requirements:
369      *
370      * - `owner` cannot be the zero address.
371      * - `spender` cannot be the zero address.
372      */
373     function _approve(address owner, address spender, uint256 value) internal {
374         require(owner != address(0), "ERC20: approve from the zero address");
375         require(spender != address(0), "ERC20: approve to the zero address");
376 
377         _allowances[owner][spender] = value;
378         emit Approval(owner, spender, value);
379     }
380 }