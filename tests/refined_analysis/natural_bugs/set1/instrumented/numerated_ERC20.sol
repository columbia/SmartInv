1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 import "../../utils/Context.sol";
6 import "./IERC20.sol";
7 import "../../math/SafeMath.sol";
8 
9 /**
10  * @dev Implementation of the {IERC20} interface.
11  *
12  * This implementation is agnostic to the way tokens are created. This means
13  * that a supply mechanism has to be added in a derived contract using {_mint}.
14  * For a generic mechanism see {ERC20PresetMinterPauser}.
15  *
16  * TIP: For a detailed writeup see our guide
17  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
18  * to implement supply mechanisms].
19  *
20  * We have followed general OpenZeppelin guidelines: functions revert instead
21  * of returning `false` on failure. This behavior is nonetheless conventional
22  * and does not conflict with the expectations of ERC20 applications.
23  *
24  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
25  * This allows applications to reconstruct the allowance for all accounts just
26  * by listening to said events. Other implementations of the EIP may not emit
27  * these events, as it isn't required by the specification.
28  *
29  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
30  * functions have been added to mitigate the well-known issues around setting
31  * allowances. See {IERC20-approve}.
32  */
33 contract ERC20 is Context, IERC20 {
34     using SafeMath for uint256;
35 
36     mapping (address => uint256) private _balances;
37 
38     mapping (address => mapping (address => uint256)) private _allowances;
39 
40     uint256 private _totalSupply;
41 
42     string private _name;
43     string private _symbol;
44     uint8 private _decimals;
45 
46     /**
47      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
48      * a default value of 18.
49      *
50      * To select a different value for {decimals}, use {_setupDecimals}.
51      *
52      * All three of these values are immutable: they can only be set once during
53      * construction.
54      */
55     constructor (string memory name_, string memory symbol_) public {
56         _name = name_;
57         _symbol = symbol_;
58         _decimals = 18;
59     }
60 
61     /**
62      * @dev Returns the name of the token.
63      */
64     function name() public view virtual returns (string memory) {
65         return _name;
66     }
67 
68     /**
69      * @dev Returns the symbol of the token, usually a shorter version of the
70      * name.
71      */
72     function symbol() public view virtual returns (string memory) {
73         return _symbol;
74     }
75 
76     /**
77      * @dev Returns the number of decimals used to get its user representation.
78      * For example, if `decimals` equals `2`, a balance of `505` tokens should
79      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
80      *
81      * Tokens usually opt for a value of 18, imitating the relationship between
82      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
83      * called.
84      *
85      * NOTE: This information is only used for _display_ purposes: it in
86      * no way affects any of the arithmetic of the contract, including
87      * {IERC20-balanceOf} and {IERC20-transfer}.
88      */
89     function decimals() public view virtual returns (uint8) {
90         return _decimals;
91     }
92 
93     /**
94      * @dev See {IERC20-totalSupply}.
95      */
96     function totalSupply() public view virtual override returns (uint256) {
97         return _totalSupply;
98     }
99 
100     /**
101      * @dev See {IERC20-balanceOf}.
102      */
103     function balanceOf(address account) public view virtual override returns (uint256) {
104         return _balances[account];
105     }
106 
107     /**
108      * @dev See {IERC20-transfer}.
109      *
110      * Requirements:
111      *
112      * - `recipient` cannot be the zero address.
113      * - the caller must have a balance of at least `amount`.
114      */
115     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
116         _transfer(_msgSender(), recipient, amount);
117         return true;
118     }
119 
120     /**
121      * @dev See {IERC20-allowance}.
122      */
123     function allowance(address owner, address spender) public view virtual override returns (uint256) {
124         return _allowances[owner][spender];
125     }
126 
127     /**
128      * @dev See {IERC20-approve}.
129      *
130      * Requirements:
131      *
132      * - `spender` cannot be the zero address.
133      */
134     function approve(address spender, uint256 amount) public virtual override returns (bool) {
135         _approve(_msgSender(), spender, amount);
136         return true;
137     }
138 
139     /**
140      * @dev See {IERC20-transferFrom}.
141      *
142      * Emits an {Approval} event indicating the updated allowance. This is not
143      * required by the EIP. See the note at the beginning of {ERC20}.
144      *
145      * Requirements:
146      *
147      * - `sender` and `recipient` cannot be the zero address.
148      * - `sender` must have a balance of at least `amount`.
149      * - the caller must have allowance for ``sender``'s tokens of at least
150      * `amount`.
151      */
152     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
153         _transfer(sender, recipient, amount);
154         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
155         return true;
156     }
157 
158     /**
159      * @dev Atomically increases the allowance granted to `spender` by the caller.
160      *
161      * This is an alternative to {approve} that can be used as a mitigation for
162      * problems described in {IERC20-approve}.
163      *
164      * Emits an {Approval} event indicating the updated allowance.
165      *
166      * Requirements:
167      *
168      * - `spender` cannot be the zero address.
169      */
170     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
171         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
172         return true;
173     }
174 
175     /**
176      * @dev Atomically decreases the allowance granted to `spender` by the caller.
177      *
178      * This is an alternative to {approve} that can be used as a mitigation for
179      * problems described in {IERC20-approve}.
180      *
181      * Emits an {Approval} event indicating the updated allowance.
182      *
183      * Requirements:
184      *
185      * - `spender` cannot be the zero address.
186      * - `spender` must have allowance for the caller of at least
187      * `subtractedValue`.
188      */
189     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
190         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
191         return true;
192     }
193 
194     /**
195      * @dev Moves tokens `amount` from `sender` to `recipient`.
196      *
197      * This is internal function is equivalent to {transfer}, and can be used to
198      * e.g. implement automatic token fees, slashing mechanisms, etc.
199      *
200      * Emits a {Transfer} event.
201      *
202      * Requirements:
203      *
204      * - `sender` cannot be the zero address.
205      * - `recipient` cannot be the zero address.
206      * - `sender` must have a balance of at least `amount`.
207      */
208     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
209         require(sender != address(0), "ERC20: transfer from the zero address");
210         require(recipient != address(0), "ERC20: transfer to the zero address");
211 
212         _beforeTokenTransfer(sender, recipient, amount);
213 
214         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
215         _balances[recipient] = _balances[recipient].add(amount);
216         emit Transfer(sender, recipient, amount);
217     }
218 
219     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
220      * the total supply.
221      *
222      * Emits a {Transfer} event with `from` set to the zero address.
223      *
224      * Requirements:
225      *
226      * - `to` cannot be the zero address.
227      */
228     function _mint(address account, uint256 amount) internal virtual {
229         require(account != address(0), "ERC20: mint to the zero address");
230 
231         _beforeTokenTransfer(address(0), account, amount);
232 
233         _totalSupply = _totalSupply.add(amount);
234         _balances[account] = _balances[account].add(amount);
235         emit Transfer(address(0), account, amount);
236     }
237 
238     /**
239      * @dev Destroys `amount` tokens from `account`, reducing the
240      * total supply.
241      *
242      * Emits a {Transfer} event with `to` set to the zero address.
243      *
244      * Requirements:
245      *
246      * - `account` cannot be the zero address.
247      * - `account` must have at least `amount` tokens.
248      */
249     function _burn(address account, uint256 amount) internal virtual {
250         require(account != address(0), "ERC20: burn from the zero address");
251 
252         _beforeTokenTransfer(account, address(0), amount);
253 
254         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
255         _totalSupply = _totalSupply.sub(amount);
256         emit Transfer(account, address(0), amount);
257     }
258 
259     /**
260      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
261      *
262      * This internal function is equivalent to `approve`, and can be used to
263      * e.g. set automatic allowances for certain subsystems, etc.
264      *
265      * Emits an {Approval} event.
266      *
267      * Requirements:
268      *
269      * - `owner` cannot be the zero address.
270      * - `spender` cannot be the zero address.
271      */
272     function _approve(address owner, address spender, uint256 amount) internal virtual {
273         require(owner != address(0), "ERC20: approve from the zero address");
274         require(spender != address(0), "ERC20: approve to the zero address");
275 
276         _allowances[owner][spender] = amount;
277         emit Approval(owner, spender, amount);
278     }
279 
280     /**
281      * @dev Sets {decimals} to a value other than the default one of 18.
282      *
283      * WARNING: This function should only be called from the constructor. Most
284      * applications that interact with token contracts will not expect
285      * {decimals} to ever change, and may work incorrectly if it does.
286      */
287     function _setupDecimals(uint8 decimals_) internal virtual {
288         _decimals = decimals_;
289     }
290 
291     /**
292      * @dev Hook that is called before any transfer of tokens. This includes
293      * minting and burning.
294      *
295      * Calling conditions:
296      *
297      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
298      * will be to transferred to `to`.
299      * - when `from` is zero, `amount` tokens will be minted for `to`.
300      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
301      * - `from` and `to` are never both zero.
302      *
303      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
304      */
305     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
306 }