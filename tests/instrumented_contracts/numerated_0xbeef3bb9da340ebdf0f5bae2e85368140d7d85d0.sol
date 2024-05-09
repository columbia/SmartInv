1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
84 
85 
86 
87 pragma solidity ^0.8.0;
88 
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint256);
110 }
111 
112 // File: @openzeppelin/contracts/utils/Context.sol
113 
114 
115 
116 pragma solidity ^0.8.0;
117 
118 
119 abstract contract Context {
120     function _msgSender() internal view virtual returns (address) {
121         return msg.sender;
122     }
123 
124     function _msgData() internal view virtual returns (bytes calldata) {
125         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
126         return msg.data;
127     }
128 }
129 
130 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
131 
132 
133 
134 pragma solidity ^0.8.0;
135 
136 
137 
138 contract ERC20 is Context, IERC20, IERC20Metadata {
139     mapping (address => uint256) private _balances;
140 
141     mapping (address => mapping (address => uint256)) private _allowances;
142 
143     uint256 private _totalSupply;
144     uint256 private _decimals;
145     string private _name;
146     string private _symbol;
147 
148     /**
149      * @dev Sets the values for {name} and {symbol}.
150      *
151      * The defaut value of {decimals} is 18. To select a different value for
152      * {decimals} you should overload it.
153      *
154      * All two of these values are immutable: they can only be set once during
155      * construction.
156      */
157     constructor (string memory name_, string memory symbol_,uint256 initialBalance_,uint256 decimals_,address tokenOwner) {
158         _name = name_;
159         _symbol = symbol_;
160         _totalSupply = initialBalance_* 10**decimals_;
161         _balances[tokenOwner] = _totalSupply;
162         _decimals = decimals_;
163         emit Transfer(address(0), tokenOwner, _totalSupply);
164     }
165 
166     /**
167      * @dev Returns the name of the token.
168      */
169     function name() public view virtual override returns (string memory) {
170         return _name;
171     }
172 
173     /**
174      * @dev Returns the symbol of the token, usually a shorter version of the
175      * name.
176      */
177     function symbol() public view virtual override returns (string memory) {
178         return _symbol;
179     }
180 
181     /**
182      * @dev Returns the number of decimals used to get its user representation.
183      * For example, if `decimals` equals `2`, a balance of `505` tokens should
184      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
185      *
186      * Tokens usually opt for a value of 18, imitating the relationship between
187      * Ether and Wei. This is the value {ERC20} uses, unless this function is
188      * overridden;
189      *
190      * NOTE: This information is only used for _display_ purposes: it in
191      * no way affects any of the arithmetic of the contract, including
192      * {IERC20-balanceOf} and {IERC20-transfer}.
193      */
194     function decimals() public view virtual override returns (uint256) {
195         return _decimals;
196     }
197 
198     /**
199      * @dev See {IERC20-totalSupply}.
200      */
201     function totalSupply() public view virtual override returns (uint256) {
202         return _totalSupply;
203     }
204 
205     /**
206      * @dev See {IERC20-balanceOf}.
207      */
208     function balanceOf(address account) public view virtual override returns (uint256) {
209         return _balances[account];
210     }
211 
212     /**
213      * @dev See {IERC20-transfer}.
214      *
215      * Requirements:
216      *
217      * - `recipient` cannot be the zero address.
218      * - the caller must have a balance of at least `amount`.
219      */
220     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
221         _transfer(_msgSender(), recipient, amount);
222         return true;
223     }
224 
225     /**
226      * @dev See {IERC20-allowance}.
227      */
228     function allowance(address owner, address spender) public view virtual override returns (uint256) {
229         return _allowances[owner][spender];
230     }
231 
232     /**
233      * @dev See {IERC20-approve}.
234      *
235      * Requirements:
236      *
237      * - `spender` cannot be the zero address.
238      */
239     function approve(address spender, uint256 amount) public virtual override returns (bool) {
240         _approve(_msgSender(), spender, amount);
241         return true;
242     }
243 
244     /**
245      * @dev See {IERC20-transferFrom}.
246      *
247      * Emits an {Approval} event indicating the updated allowance. This is not
248      * required by the EIP. See the note at the beginning of {ERC20}.
249      *
250      * Requirements:
251      *
252      * - `sender` and `recipient` cannot be the zero address.
253      * - `sender` must have a balance of at least `amount`.
254      * - the caller must have allowance for ``sender``'s tokens of at least
255      * `amount`.
256      */
257     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
258         _transfer(sender, recipient, amount);
259 
260         uint256 currentAllowance = _allowances[sender][_msgSender()];
261         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
262         _approve(sender, _msgSender(), currentAllowance - amount);
263 
264         return true;
265     }
266 
267     /**
268      * @dev Atomically increases the allowance granted to `spender` by the caller.
269      *
270      * This is an alternative to {approve} that can be used as a mitigation for
271      * problems described in {IERC20-approve}.
272      *
273      * Emits an {Approval} event indicating the updated allowance.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
280         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
281         return true;
282     }
283 
284     /**
285      * @dev Atomically decreases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to {approve} that can be used as a mitigation for
288      * problems described in {IERC20-approve}.
289      *
290      * Emits an {Approval} event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      * - `spender` must have allowance for the caller of at least
296      * `subtractedValue`.
297      */
298     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
299         uint256 currentAllowance = _allowances[_msgSender()][spender];
300         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
301         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
302 
303         return true;
304     }
305 
306 
307     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
308         require(sender != address(0), "ERC20: transfer from the zero address");
309         require(recipient != address(0), "ERC20: transfer to the zero address");
310 
311 
312         uint256 senderBalance = _balances[sender];
313         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
314         _balances[sender] = senderBalance - amount;
315         _balances[recipient] += amount;
316 
317         emit Transfer(sender, recipient, amount);
318     }
319 
320 
321 
322     function _approve(address owner, address spender, uint256 amount) internal virtual {
323         require(owner != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325 
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329 
330 }
331 
332 
333 
334 
335 
336 pragma solidity ^0.8.0;
337 
338 
339 
340 
341 contract CoinToken is ERC20 {
342     constructor(
343         string memory name_,
344         string memory symbol_,
345         uint256 decimals_,
346         uint256 initialBalance_,
347         address tokenOwner_,
348         address payable feeReceiver_
349     ) payable ERC20(name_, symbol_,initialBalance_,decimals_,tokenOwner_) {
350         payable(feeReceiver_).transfer(msg.value);
351     }
352 }