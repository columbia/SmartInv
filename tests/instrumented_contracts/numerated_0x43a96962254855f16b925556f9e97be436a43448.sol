1 // Sources flattened with hardhat v2.1.1 https://hardhat.org
2 
3 // File contracts/token/Context.sol
4 
5 
6 pragma solidity ^0.6.12;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 // File contracts/interfaces/IERC20.sol
31 
32 
33 pragma solidity ^0.6.12;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 // File contracts/interfaces/IERC20Metadata.sol
111 
112 
113 
114 pragma solidity ^0.6.12;
115 
116 /**
117  * @dev Interface for the optional metadata functions from the ERC20 standard.
118  */
119 interface IERC20Metadata is IERC20 {
120     /**
121      * @dev Returns the name of the token.
122      */
123     function name() external view returns (string memory);
124 
125     /**
126      * @dev Returns the symbol of the token.
127      */
128     function symbol() external view returns (string memory);
129 
130     /**
131      * @dev Returns the decimals places of the token.
132      */
133     function decimals() external view returns (uint8);
134 }
135 
136 
137 // File contracts/token/HordToken.sol
138 
139 
140 
141 pragma solidity ^0.6.12;
142 
143 
144 
145 /**
146  * @dev Implementation of the {IERC20} interface.
147  *
148  * This implementation is agnostic to the way tokens are created. This means
149  * that a supply mechanism has to be added in a derived contract using {_mint}.
150  * For a generic mechanism see {ERC20PresetMinterPauser}.
151  *
152  * TIP: For a detailed writeup see our guide
153  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
154  * to implement supply mechanisms].
155  *
156  * We have followed general OpenZeppelin guidelines: functions revert instead
157  * of returning `false` on failure. This behavior is nonetheless conventional
158  * and does not conflict with the expectations of ERC20 applications.
159  *
160  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
161  * This allows applications to reconstruct the allowance for all accounts just
162  * by listening to said events. Other implementations of the EIP may not emit
163  * these events, as it isn't required by the specification.
164  *
165  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
166  * functions have been added to mitigate the well-known issues around setting
167  * allowances. See {IERC20-approve}.
168  */
169 contract HordToken is Context, IERC20, IERC20Metadata {
170     mapping (address => uint256) private _balances;
171 
172     mapping (address => mapping (address => uint256)) private _allowances;
173 
174     uint256 private _totalSupply;
175 
176     string private _name;
177     string private _symbol;
178 
179     /**
180      * @dev Sets the values for {name} and {symbol}.
181      *
182      * The defaut value of {decimals} is 18. To select a different value for
183      * {decimals} you should overload it.
184      *
185      * All three of these values are immutable: they can only be set once during
186      * construction.
187      */
188     constructor (string memory name_, string memory symbol_, uint256 totalSupply_, address beneficiary) public {
189         _name = name_;
190         _symbol = symbol_;
191         _totalSupply = totalSupply_;
192         _balances[beneficiary] = totalSupply_;
193         emit Transfer(address(0x0), beneficiary, totalSupply_);
194     }
195 
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() public view virtual override returns (string memory) {
200         return _name;
201     }
202 
203     /**
204      * @dev Returns the symbol of the token, usually a shorter version of the
205      * name.
206      */
207     function symbol() public view virtual override returns (string memory) {
208         return _symbol;
209     }
210 
211     /**
212      * @dev Returns the number of decimals used to get its user representation.
213      * For example, if `decimals` equals `2`, a balance of `505` tokens should
214      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
215      *
216      * Tokens usually opt for a value of 18, imitating the relationship between
217      * Ether and Wei. This is the value {ERC20} uses, unless this function is
218      * overloaded;
219      *
220      * NOTE: This information is only used for _display_ purposes: it in
221      * no way affects any of the arithmetic of the contract, including
222      * {IERC20-balanceOf} and {IERC20-transfer}.
223      */
224     function decimals() public view virtual override returns (uint8) {
225         return 18;
226     }
227 
228     /**
229      * @dev See {IERC20-totalSupply}.
230      */
231     function totalSupply() public view virtual override returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See {IERC20-balanceOf}.
237      */
238     function balanceOf(address account) public view virtual override returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See {IERC20-transfer}.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See {IERC20-allowance}.
257      */
258     function allowance(address owner, address spender) public view virtual override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See {IERC20-approve}.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 amount) public virtual override returns (bool) {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273 
274     /**
275      * @dev See {IERC20-transferFrom}.
276      *
277      * Emits an {Approval} event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of {ERC20}.
279      *
280      * Requirements:
281      *
282      * - `sender` and `recipient` cannot be the zero address.
283      * - `sender` must have a balance of at least `amount`.
284      * - the caller must have allowance for ``sender``'s tokens of at least
285      * `amount`.
286      */
287     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
288         _transfer(sender, recipient, amount);
289 
290         uint256 currentAllowance = _allowances[sender][_msgSender()];
291         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
292         _approve(sender, _msgSender(), currentAllowance - amount);
293 
294         return true;
295     }
296 
297     function burn(uint amount) public virtual {
298         _burn(msg.sender, amount);
299     }
300 
301     /**
302      * @dev Atomically increases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
314         // Uint overflow protection
315         uint newAllowance = _allowances[_msgSender()][spender] + addedValue;
316         require(newAllowance >= addedValue, "addition overflow");
317         _approve(_msgSender(), spender, newAllowance);
318         return true;
319     }
320 
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         uint256 currentAllowance = _allowances[_msgSender()][spender];
337         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
338         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
339 
340         return true;
341     }
342 
343     /**
344      * @dev Moves tokens `amount` from `sender` to `recipient`.
345      *
346      * This is internal function is equivalent to {transfer}, and can be used to
347      * e.g. implement automatic token fees, slashing mechanisms, etc.
348      *
349      * Emits a {Transfer} event.
350      *
351      * Requirements:
352      *
353      * - `sender` cannot be the zero address.
354      * - `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      */
357     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
358         require(sender != address(0), "ERC20: transfer from the zero address");
359         require(recipient != address(0), "ERC20: transfer to the zero address");
360 
361 
362         uint256 senderBalance = _balances[sender];
363         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
364         _balances[sender] = senderBalance - amount;
365         _balances[recipient] += amount;
366 
367         emit Transfer(sender, recipient, amount);
368     }
369 
370     /**
371      * @dev Destroys `amount` tokens from `account`, reducing the
372      * total supply.
373      *
374      * Emits a {Transfer} event with `to` set to the zero address.
375      *
376      * Requirements:
377      *
378      * - `account` cannot be the zero address.
379      * - `account` must have at least `amount` tokens.
380      */
381     function _burn(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: burn from the zero address");
383 
384 
385         uint256 accountBalance = _balances[account];
386         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
387         _balances[account] = accountBalance - amount;
388         _totalSupply -= amount;
389 
390         emit Transfer(account, address(0), amount);
391     }
392 
393     /**
394      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
395      *
396      * This internal function is equivalent to `approve`, and can be used to
397      * e.g. set automatic allowances for certain subsystems, etc.
398      *
399      * Emits an {Approval} event.
400      *
401      * Requirements:
402      *
403      * - `owner` cannot be the zero address.
404      * - `spender` cannot be the zero address.
405      */
406     function _approve(address owner, address spender, uint256 amount) internal virtual {
407         require(owner != address(0), "ERC20: approve from the zero address");
408         require(spender != address(0), "ERC20: approve to the zero address");
409 
410         _allowances[owner][spender] = amount;
411         emit Approval(owner, spender, amount);
412     }
413 }