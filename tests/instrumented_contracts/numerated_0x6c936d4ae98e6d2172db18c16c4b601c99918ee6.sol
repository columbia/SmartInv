1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8 
9     function balanceOf(address account) external view returns (uint256);
10 
11     function transfer(address recipient, uint256 amount) external returns (bool);
12 
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function approve(address spender, uint256 amount) external returns (bool);
16 
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, reverting on
27      * overflow.
28      *
29      * Counterpart to Solidity's `+` operator.
30      *
31      * Requirements:
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b <= a, "SafeMath: subtraction overflow");
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the multiplication of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `*` operator.
62      *
63      * Requirements:
64      * - Multiplication cannot overflow.
65      */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68         // benefit is lost if 'b' is also tested.
69         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the integer division of two unsigned integers. Reverts on
82      * division by zero. The result is rounded towards zero.
83      *
84      * Counterpart to Solidity's `/` operator. Note: this function uses a
85      * `revert` opcode (which leaves remaining gas untouched) while Solidity
86      * uses an invalid opcode to revert (consuming all remaining gas).
87      *
88      * Requirements:
89      * - The divisor cannot be zero.
90      */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Solidity only automatically asserts when dividing by 0
93         require(b > 0, "SafeMath: division by zero");
94         uint256 c = a / b;
95         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
102      * Reverts when dividing by zero.
103      *
104      * Counterpart to Solidity's `%` operator. This function uses a `revert`
105      * opcode (which leaves remaining gas untouched) while Solidity uses an
106      * invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
112         require(b != 0, "SafeMath: modulo by zero");
113         return a % b;
114     }
115 }
116 
117 /**
118  * @dev Implementation of the `IERC20` interface.
119  *
120  * This implementation is agnostic to the way tokens are created. This means
121  * that a supply mechanism has to be added in a derived contract using `_mint`.
122  * For a generic mechanism see `ERC20Mintable`.
123  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
124  * This allows applications to reconstruct the allowance for all accounts just
125  * by listening to said events. Other implementations of the EIP may not emit
126  * these events, as it isn't required by the specification.
127  *
128  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
129  * functions have been added to mitigate the well-known issues around setting
130  * allowances. See `IERC20.approve`.
131  */
132  
133  
134 contract LifeToken is IERC20 {
135     using SafeMath for uint256;
136     
137     // OWNER DATA
138     address public tokenBurner;
139 
140     mapping (address => uint256) private _balances;
141 
142     mapping (address => mapping (address => uint256)) private _allowances;
143 
144     string private _name;
145     string private _symbol;
146     uint8 private _decimals;
147 
148     constructor ()  {
149         _name = "Life Crypto";
150         _symbol = "LIFE";
151         _decimals = 18;
152         
153         _mint(msg.sender, 10000000000 * 10 ** uint256(18)); 
154         tokenBurner = msg.sender;
155     }
156     
157     
158     /**
159      * @dev Throws if called by any account other than the owner.
160      */
161     modifier onlyOwner() {
162         require(msg.sender == tokenBurner, "supplyController");
163         _;
164     }
165 
166 
167     /**
168      * @dev Returns the name of the token.
169      */
170     function name() public view returns (string memory) {
171         return _name;
172     }
173 
174     /**
175      * @dev Returns the symbol of the token, usually a shorter version of the
176      * name.
177      */
178     function symbol() public view returns (string memory) {
179         return _symbol;
180     }
181 
182     /**
183      * @dev Returns the number of decimals used to get its user representation.
184      * For example, if `decimals` equals `2`, a balance of `505` tokens should
185      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
186      *
187      * Tokens usually opt for a value of 18, imitating the relationship between
188      * Ether and Wei.
189      * Here in Life crypto token, we have initialised constructor with 18 decimals.  
190      */
191     function decimals() public view returns (uint8) {
192         return _decimals;
193     }
194 
195     uint256 private _totalSupply;
196 
197     /**
198      * @dev See `IERC20.totalSupply`.
199      */
200     function totalSupply() public override view returns (uint256) {
201         return _totalSupply;
202     }
203 
204     /**
205      * @dev See `IERC20.balanceOf`.
206      */
207     function balanceOf(address account) public override view returns (uint256) {
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
219     function transfer(address recipient, uint256 amount) public override returns (bool) {
220         _transfer(msg.sender, recipient, amount);
221         return true;
222     }
223     
224     /**
225     * Function to bur tokens to 0 address
226     * Can be done by owner only
227     */
228     function destroyTokens(address account, uint256 value) public onlyOwner returns (bool) {
229         
230         require(value <= _balances[account], "not enough supply");
231         require(account == tokenBurner, "onlyOwner");
232 
233         _balances[account] = _balances[account].sub(value);
234         _totalSupply = _totalSupply.sub(value);
235         emit Transfer(account, address(0), value);
236         return true;
237         }
238     /**
239      * @dev See `IERC20.allowance`.
240      */
241     function allowance(address owner, address spender) public override view returns (uint256) {
242         return _allowances[owner][spender];
243     }
244 
245     /**
246      * @dev See `IERC20.approve`.
247      *
248      * Requirements:
249      *
250      * - `spender` cannot be the zero address.
251      */
252     function approve(address spender, uint256 value) public override returns (bool) {
253         _approve(msg.sender, spender, value);
254         return true;
255     }
256 
257     /**
258      * @dev See `IERC20.transferFrom`.
259      *
260      * Requirements:
261      * - `sender` and `recipient` cannot be the zero address.
262      * - `sender` must have a balance of at least `value`.
263      * - the caller must have allowance for `sender`'s tokens of at least
264      * `amount`.
265      */
266     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
267         _transfer(sender, recipient, amount);
268         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
269         return true;
270     }
271 
272     /**
273      * @dev Atomically increases the allowance granted to `spender` by the caller.
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
279         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
280         return true;
281     }
282 
283     /**
284      * @dev Atomically decreases the allowance granted to `spender` by the caller.
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      * - `spender` must have allowance for the caller of at least
289      * `subtractedValue`.
290      */
291     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
292         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
293         return true;
294     }
295 
296     /**
297      * @dev Moves tokens `amount` from `sender` to `recipient`.
298      *
299      * This is internal function is equivalent to `transfer`, and can be used to
300      * e.g. implement automatic token fees, slashing mechanisms, etc.
301      *
302      * Emits a `Transfer` event.
303      *
304      * Requirements:
305      *
306      * - `sender` cannot be the zero address.
307      * - `recipient` cannot be the zero address.
308      * - `sender` must have a balance of at least `amount`.
309      */
310     function _transfer(address sender, address recipient, uint256 amount) internal {
311         require(sender != address(0), "ERC20: transfer from the zero address");
312         require(recipient != address(0), "ERC20: transfer to the zero address");
313 
314         _balances[sender] = _balances[sender].sub(amount);
315         _balances[recipient] = _balances[recipient].add(amount);
316         emit Transfer(sender, recipient, amount);
317     }
318 
319     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
320      * the total supply.
321      *
322      * Emits a `Transfer` event with `from` set to the zero address.
323      *
324      * Requirements
325      *
326      * - `to` cannot be the zero address.
327      */
328     function _mint(address account, uint256 amount) internal {
329         require(account != address(0), "ERC20: mint to the zero address");
330 
331         _totalSupply = _totalSupply.add(amount);
332         _balances[account] = _balances[account].add(amount);
333         emit Transfer(address(0), account, amount);
334     }
335 
336      /**
337      * @dev Destroys `amount` tokens from `account`, reducing the
338      * total supply.
339      *
340      * Emits a `Transfer` event with `to` set to the zero address.
341      *
342      * Requirements
343      *
344      * - `account` cannot be the zero address.
345      * - `account` must have at least `amount` tokens.
346      */
347     function _burn(address account, uint256 value) internal {
348         require(account != address(0), "ERC20: burn from the zero address");
349 
350     _balances[account] = _balances[account].sub(value);
351         _totalSupply = _totalSupply.sub(value);
352         emit Transfer(account, address(0), value);
353     }
354 
355     /**
356      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
357      *
358      * This is internal function is equivalent to `approve`, and can be used to
359      * e.g. set automatic allowances for certain subsystems, etc.
360      *
361      * Emits an `Approval` event.
362      *
363      * Requirements:
364      *
365      * - `owner` cannot be the zero address.
366      * - `spender` cannot be the zero address.
367      */
368     function _approve(address owner, address spender, uint256 value) internal {
369         require(owner != address(0), "ERC20: approve from the zero address");
370         require(spender != address(0), "ERC20: approve to the zero address");
371 
372         _allowances[owner][spender] = value;
373         emit Approval(owner, spender, value);
374     }
375 
376     /**
377      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
378      * from the caller's allowance.
379      *
380      * See `_burn` and `_approve`.
381      */
382     function _burnFrom(address account, uint256 amount) internal {
383         _burn(account, amount);
384         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
385     }
386 }