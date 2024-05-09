1 /*
2 ----------------------------------------------------------------------------
3  Scoobi-Doge Token Contract
4 
5  A real decentralized community token with 100% tokens in starting Uniswap supply and locked away for 10 years, no minting functions.
6  Further information on https://github.com/Scoobi-doge/Scoobi-doge.github.io
7  BTW Scoobi-Doge really is a cool dog breed, and arguably the strongest.
8 
9  Symbol        : SCooBi
10  Name          : Scoobi-Doge
11  Total supply  : 100000000000
12  Decimals      : 18
13  Deployer Account : 0xA1c71DD36b10009012B01b9e82f9b749286F12c6
14 
15 ----------------------------------------------------------------------------
16 */
17 
18 // SPDX-License-Identifier: UNLICENSED
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * This project does not require SafeMath library because Solidity version used is 0.8.0
24  * and it has safe implementations of arithmetic operators used in this contract.
25  * Further info: https://ethereum.stackexchange.com/questions/91367/is-the-safemath-library-obsolete-in-solidity-0-8-0
26  */
27 
28 /**
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with GSN meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes calldata) {
44         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
45         return msg.data;
46     }
47 }
48 
49 /**
50  * @dev Interface of the ERC20 standard as defined in the EIP.
51  */
52 interface IERC20 {
53     /**
54      * @dev Returns the amount of tokens in existence.
55      */
56     function totalSupply() external view returns (uint256);
57 
58     /**
59      * @dev Returns the amount of tokens owned by `account`.
60      */
61     function balanceOf(address account) external view returns (uint256);
62 
63     /**
64      * @dev Moves `amount` tokens from the caller's account to `recipient`.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Returns the remaining number of tokens that `spender` will be
74      * allowed to spend on behalf of `owner` through {transferFrom}. This is
75      * zero by default.
76      *
77      * This value changes when {approve} or {transferFrom} are called.
78      */
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `sender` to `recipient` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Emitted when `value` tokens are moved from one account (`from`) to
110      * another (`to`).
111      *
112      * Note that `value` may be zero.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 value);
115 
116     /**
117      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
118      * a call to {approve}. `value` is the new allowance.
119      */
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 /**
124  * @dev Implementation of the {IERC20} interface.
125  *
126  * TIP: For a detailed writeup see our guide
127  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
128  * to implement supply mechanisms].
129  *
130  * We have followed general OpenZeppelin guidelines: functions revert instead
131  * of returning `false` on failure. This behavior is nonetheless conventional
132  * and does not conflict with the expectations of ERC20 applications.
133  *
134  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
135  * This allows applications to reconstruct the allowance for all accounts just
136  * by listening to said events. Other implementations of the EIP may not emit
137  * these events, as it isn't required by the specification.
138  *
139  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
140  * functions have been added to mitigate the well-known issues around setting
141  * allowances. See {IERC20-approve}.
142  */
143 contract ERC20 is Context, IERC20 {
144     mapping (address => uint256) private _balances;
145     mapping (address => mapping (address => uint256)) private _allowances;
146 
147     string private _name;
148     string private _symbol;
149     uint256 private _totalSupply;
150 
151     /**
152      * @dev Sets the values for {name} and {symbol}.
153      *
154      * The defaut value of {decimals} is 18. To select a different value for
155      * {decimals} you should overload it.
156      *
157      * All three of these values are immutable: they can only be set once during
158      * construction.
159      */
160     constructor () {
161         _name = "Scoobi-Doge";
162         _symbol = "SCooBi";
163         _totalSupply = 100000000000000000000000000000;
164         
165         _balances[_msgSender()] = _totalSupply;
166         emit Transfer(address(0), _msgSender(), _totalSupply);
167     }
168 
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() public view virtual returns (string memory) {
173         return _name;
174     }
175 
176     /**
177      * @dev Returns the symbol of the token, usually a shorter version of the
178      * name.
179      */
180     function symbol() public view virtual returns (string memory) {
181         return _symbol;
182     }
183 
184     /**
185      * @dev Returns the number of decimals used to get its user representation.
186      * For example, if `decimals` equals `2`, a balance of `505` tokens should
187      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
188      *
189      * Tokens usually opt for a value of 18, imitating the relationship between
190      * Ether and Wei. This is the value {ERC20} uses, unless this function is
191      * overloaded;
192      *
193      * NOTE: This information is only used for _display_ purposes: it in
194      * no way affects any of the arithmetic of the contract, including
195      * {IERC20-balanceOf} and {IERC20-transfer}.
196      */
197     function decimals() public view virtual returns (uint8) {
198         return 18;
199     }
200 
201     /**
202      * @dev See {IERC20-totalSupply}.
203      */
204     function totalSupply() public view virtual override returns (uint256) {
205         return _totalSupply;
206     }
207 
208     /**
209      * @dev See {IERC20-balanceOf}.
210      */
211     function balanceOf(address account) public view virtual override returns (uint256) {
212         return _balances[account];
213     }
214 
215     /**
216      * @dev See {IERC20-transfer}.
217      *
218      * Requirements:
219      *
220      * - `recipient` cannot be the zero address.
221      * - the caller must have a balance of at least `amount`.
222      */
223     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
224         _transfer(_msgSender(), recipient, amount);
225         return true;
226     }
227 
228     /**
229      * @dev See {IERC20-allowance}.
230      */
231     function allowance(address owner, address spender) public view virtual override returns (uint256) {
232         return _allowances[owner][spender];
233     }
234 
235     /**
236      * @dev See {IERC20-approve}.
237      *
238      * Requirements:
239      *
240      * - `spender` cannot be the zero address.
241      */
242     function approve(address spender, uint256 amount) public virtual override returns (bool) {
243         _approve(_msgSender(), spender, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See {IERC20-transferFrom}.
249      *
250      * Emits an {Approval} event indicating the updated allowance. This is not
251      * required by the EIP. See the note at the beginning of {ERC20}.
252      *
253      * Requirements:
254      *
255      * - `sender` and `recipient` cannot be the zero address.
256      * - `sender` must have a balance of at least `amount`.
257      * - the caller must have allowance for ``sender``'s tokens of at least
258      * `amount`.
259      */
260     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
261         _transfer(sender, recipient, amount);
262 
263         uint256 currentAllowance = _allowances[sender][_msgSender()];
264         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
265         _approve(sender, _msgSender(), currentAllowance - amount);
266 
267         return true;
268     }
269 
270     /**
271      * @dev Moves tokens `amount` from `sender` to `recipient`.
272      *
273      * This is internal function is equivalent to {transfer}, and can be used to
274      * e.g. implement automatic token fees, slashing mechanisms, etc.
275      *
276      * Emits a {Transfer} event.
277      *
278      * Requirements:
279      *
280      * - `sender` cannot be the zero address.
281      * - `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `amount`.
283      */
284     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
285         require(sender != address(0), "ERC20: transfer from the zero address");
286         require(recipient != address(0), "ERC20: transfer to the zero address");
287 
288         _beforeTokenTransfer(sender, recipient, amount);
289 
290         uint256 senderBalance = _balances[sender];
291         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
292         _balances[sender] = senderBalance - amount;
293         _balances[recipient] += amount;
294 
295         emit Transfer(sender, recipient, amount);
296     }
297 
298     /**
299      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
300      *
301      * This internal function is equivalent to `approve`, and can be used to
302      * e.g. set automatic allowances for certain subsystems, etc.
303      *
304      * Emits an {Approval} event.
305      *
306      * Requirements:
307      *
308      * - `owner` cannot be the zero address.
309      * - `spender` cannot be the zero address.
310      */
311     function _approve(address owner, address spender, uint256 amount) internal virtual {
312         require(owner != address(0), "ERC20: approve from the zero address");
313         require(spender != address(0), "ERC20: approve to the zero address");
314 
315         _allowances[owner][spender] = amount;
316         emit Approval(owner, spender, amount);
317     }
318 
319     /**
320      * @dev Hook that is called before any transfer of tokens.
321      */
322     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
323 }