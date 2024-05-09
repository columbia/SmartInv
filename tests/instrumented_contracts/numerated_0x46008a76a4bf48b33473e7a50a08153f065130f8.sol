1 /**
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣤⣤⣤⣤⣤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠾⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠳⢶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡏⠀⠀⠀⠀⢀⣠⣤⣤⡶⠶⠟⠛⢻⠛⠛⠛⠛⣿⠻⢶⣦⣤⡀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡟⠀⣀⣠⣴⣾⠟⠋⠁⣿⠆⠀⠀⠀⢸⠀⠀⠀⠀⣿⠀⠀⠀⢹⡿⢿⣄⠀⢿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣷⣾⠛⠉⠀⡟⠀⠀⠀⣿⠀⢀⣠⣤⣿⣤⣤⣤⣤⣿⣀⡀⠀⢸⡇⠀⢹⣷⣼⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⡞⠀⠀⠀⡇⢀⣠⣴⣿⢿⣿⣯⣉⡉⠉⠉⠉⠉⠙⠛⠿⣷⣿⣀⠀⣼⠛⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⠀⢰⡇⠀⣀⣤⣿⠟⠋⠁⠀⠀⠀⠙⠛⠻⢦⡀⠀⠀⠀⠀⠀⠀⠉⠻⣿⡇⠀⢹⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⢸⣷⣾⠟⠋⠀⠀⠀⢰⣶⡶⣦⣤⡀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣶⣶⣾⣿⣤⢿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣤⣾⣿⠻⣿⠀⠀⠀⠀⠀⠀⠹⣟⣛⣒⣻⠗⠀⠀⠀⣠⣞⣫⣤⣄⡀⠀⠀⣽⡏⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⡅⠳⠀⠿⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⢰⠎⢡⠈⠛⡺⠿⠿⡷⠀⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⢀⣴⡶⠟⠛⢻⣛⠋⠉⠛⠷⠾⣿⣄⣀⣴⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⢸⠀⠀⠈⠉⠉⠀⢠⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⢀⣾⠯⠀⠀⠀⠀⠘⢦⠀⠀⠀⠀⣸⡟⢿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠾⠿⠀⢸⡇⠀⠀⠀⠀⠀⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⣠⡶⠋⠁⠀⠀⠀⠀⢦⡀⠀⢧⠀⠀⣠⣿⠁⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⠾⢤⡤⠤⣼⡷⠀⠀⠀⠀⣼⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⣿⡇⠀⠀⠀⠀⠤⣄⣀⢻⣦⠸⣦⠾⣿⠁⠀⢸⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡄⠛⠉⠁⠀⠀⠀⣼⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⣿⡇⠀⠀⠀⠀⠀⠀⠉⠓⢿⣷⡏⣼⡇⠀⠀⠀⢻⣧⡀⠀⠀⠀⠀⠀⢠⡴⠒⠒⠚⠧⢤⡄⠀⠀⠀⠀⣼⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣟⠀⠀⠀⠀⠀⠹⣿⣆⡀⠀⠀⠀⠀⠲⣄⣀⣀⡈⠉⢻⢦⠀⢠⡾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⣿⢷⣦⣄⠀⠚⠛⠛⠛⠛⠛⠲⢦⣟⢷⡄⠀⠀⠀⠀⠈⠻⣷⣄⠀⠀⠀⠀⠈⠉⠉⠉⠛⠁⠀⣰⣟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⣿⡆⠀⠙⠿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣆⠀⠀⠀⠀⠀⠈⠻⣷⣄⡀⠀⠀⣠⠀⠀⠀⣠⣾⠋⠙⢿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⣿⡇⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⢹⣆⠀⠀⠀⠀⠀⠀⠈⠙⠛⠿⠿⢶⣶⠶⠾⠋⢻⣧⠀⠀⠈⠛⠛⠲⠦⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⣿⣇⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀⠀⢹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⠁⠀⠀⠀⠀⠙⣷⠀⠀⠀⠀⠀⠀⠸⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⣿⠻⣧⠀⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀⢿⢦⣀⠀⠀⠀⣀⣤⠴⢾⣿⡶⣤⣀⠀⠀⠀⠀⠙⣇⠀⠀⠀⠀⠀⠀⢿⡌⠙⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 ⣿⠀⠹⣇⠀⠀⠀⠀⠀⠀⠀⠈⠛⢶⣤⡀⠀⠀⠈⣇⠙⠲⢾⣭⣁⣀⣤⣤⣬⣉⡓⢭⡳⣶⢦⡀⠀⢻⡆⠀⠀⠀⠀⠀⠘⣧⠀⠘⢿⣄⠀⠀⠀⠀⠀⠀⠀⠀
27 
28 */
29 
30 /**
31 TELEGRAM: https://t.me/eminemportal
32 WEBSITE: https://eminemeth.pro/
33 
34 
35 */
36 
37 // SPDX-License-Identifier: MIT
38 pragma solidity ^0.8.21;
39  
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address) {
42         return msg.sender;
43     }
44  
45     function _msgData() internal view virtual returns (bytes calldata) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50  
51 interface IUniswapV2Pair {
52     event Approval(address indexed owner, address indexed spender, uint value);
53     event Transfer(address indexed from, address indexed to, uint value);
54  
55     function name() external pure returns (string memory);
56     function symbol() external pure returns (string memory);
57     function decimals() external pure returns (uint8);
58     function totalSupply() external view returns (uint);
59     function balanceOf(address owner) external view returns (uint);
60     function allowance(address owner, address spender) external view returns (uint);
61  
62     function approve(address spender, uint value) external returns (bool);
63     function transfer(address to, uint value) external returns (bool);
64     function transferFrom(address from, address to, uint value) external returns (bool);
65  
66     function DOMAIN_SEPARATOR() external view returns (bytes32);
67     function PERMIT_TYPEHASH() external pure returns (bytes32);
68     function nonces(address owner) external view returns (uint);
69  
70     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
71  
72     event Mint(address indexed sender, uint amount0, uint amount1);
73     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
74     event Swap(
75         address indexed sender,
76         uint amount0In,
77         uint amount1In,
78         uint amount0Out,
79         uint amount1Out,
80         address indexed to
81     );
82     event Sync(uint112 reserve0, uint112 reserve1);
83  
84     function MINIMUM_LIQUIDITY() external pure returns (uint);
85     function factory() external view returns (address);
86     function token0() external view returns (address);
87     function token1() external view returns (address);
88     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
89     function price0CumulativeLast() external view returns (uint);
90     function price1CumulativeLast() external view returns (uint);
91     function kLast() external view returns (uint);
92  
93     function mint(address to) external returns (uint liquidity);
94     function burn(address to) external returns (uint amount0, uint amount1);
95     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
96     function skim(address to) external;
97     function sync() external;
98  
99     function initialize(address, address) external;
100 }
101  
102 interface IUniswapV2Factory {
103     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
104  
105     function feeTo() external view returns (address);
106     function feeToSetter() external view returns (address);
107  
108     function getPair(address tokenA, address tokenB) external view returns (address pair);
109     function allPairs(uint) external view returns (address pair);
110     function allPairsLength() external view returns (uint);
111  
112     function createPair(address tokenA, address tokenB) external returns (address pair);
113  
114     function setFeeTo(address) external;
115     function setFeeToSetter(address) external;
116 }
117  
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123  
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128  
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137  
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146  
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162  
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) external returns (bool);
177  
178     /**
179      * @dev Emitted when `value` tokens are moved from one account (`from`) to
180      * another (`to`).
181      *
182      * Note that `value` may be zero.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 value);
185  
186     /**
187      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
188      * a call to {approve}. `value` is the new allowance.
189      */
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192  
193 interface IERC20Metadata is IERC20 {
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() external view returns (string memory);
198  
199     /**
200      * @dev Returns the symbol of the token.
201      */
202     function symbol() external view returns (string memory);
203  
204     /**
205      * @dev Returns the decimals places of the token.
206      */
207     function decimals() external view returns (uint8);
208 }
209  
210  
211 contract ERC20 is Context, IERC20, IERC20Metadata {
212     using SafeMath for uint256;
213  
214     mapping(address => uint256) private _balances;
215  
216     mapping(address => mapping(address => uint256)) private _allowances;
217  
218     uint256 private _totalSupply;
219  
220     string private _name;
221     string private _symbol;
222  
223     /**
224      * @dev Sets the values for {name} and {symbol}.
225      *
226      * The default value of {decimals} is 18. To select a different value for
227      * {decimals} you should overload it.
228      *
229      * All two of these values are immutable: they can only be set once during
230      * construction.
231      */
232     constructor(string memory name_, string memory symbol_) {
233         _name = name_;
234         _symbol = symbol_;
235     }
236  
237     /**
238      * @dev Returns the name of the token.
239      */
240     function name() public view virtual override returns (string memory) {
241         return _name;
242     }
243  
244     /**
245      * @dev Returns the symbol of the token, usually a shorter version of the
246      * name.
247      */
248     function symbol() public view virtual override returns (string memory) {
249         return _symbol;
250     }
251  
252     /**
253      * @dev Returns the number of decimals used to get its user representation.
254      * For example, if `decimals` equals `2`, a balance of `505` tokens should
255      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
256      *
257      * Tokens usually opt for a value of 18, imitating the relationship between
258      * Ether and Wei. This is the value {ERC20} uses, unless this function is
259      * overridden;
260      *
261      * NOTE: This information is only used for _display_ purposes: it in
262      * no way affects any of the arithmetic of the contract, including
263      * {IERC20-balanceOf} and {IERC20-transfer}.
264      */
265     function decimals() public view virtual override returns (uint8) {
266         return 18;
267     }
268  
269     /**
270      * @dev See {IERC20-totalSupply}.
271      */
272     function totalSupply() public view virtual override returns (uint256) {
273         return _totalSupply;
274     }
275  
276     /**
277      * @dev See {IERC20-balanceOf}.
278      */
279     function balanceOf(address account) public view virtual override returns (uint256) {
280         return _balances[account];
281     }
282  
283     /**
284      * @dev See {IERC20-transfer}.
285      *
286      * Requirements:
287      *
288      * - `recipient` cannot be the zero address.
289      * - the caller must have a balance of at least `amount`.
290      */
291     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
292         _transfer(_msgSender(), recipient, amount);
293         return true;
294     }
295  
296     /**
297      * @dev See {IERC20-allowance}.
298      */
299     function allowance(address owner, address spender) public view virtual override returns (uint256) {
300         return _allowances[owner][spender];
301     }
302  
303     /**
304      * @dev See {IERC20-approve}.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function approve(address spender, uint256 amount) public virtual override returns (bool) {
311         _approve(_msgSender(), spender, amount);
312         return true;
313     }
314  
315     /**
316      * @dev See {IERC20-transferFrom}.
317      *
318      * Emits an {Approval} event indicating the updated allowance. This is not
319      * required by the EIP. See the note at the beginning of {ERC20}.
320      *
321      * Requirements:
322      *
323      * - `sender` and `recipient` cannot be the zero address.
324      * - `sender` must have a balance of at least `amount`.
325      * - the caller must have allowance for ``sender``'s tokens of at least
326      * `amount`.
327      */
328     function transferFrom(
329         address sender,
330         address recipient,
331         uint256 amount
332     ) public virtual override returns (bool) {
333         _transfer(sender, recipient, amount);
334         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
335         return true;
336     }
337  
338     /**
339      * @dev Atomically increases the allowance granted to `spender` by the caller.
340      *
341      * This is an alternative to {approve} that can be used as a mitigation for
342      * problems described in {IERC20-approve}.
343      *
344      * Emits an {Approval} event indicating the updated allowance.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
351         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
352         return true;
353     }
354  
355     /**
356      * @dev Atomically decreases the allowance granted to `spender` by the caller.
357      *
358      * This is an alternative to {approve} that can be used as a mitigation for
359      * problems described in {IERC20-approve}.
360      *
361      * Emits an {Approval} event indicating the updated allowance.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      * - `spender` must have allowance for the caller of at least
367      * `subtractedValue`.
368      */
369     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
370         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
371         return true;
372     }
373  
374     /**
375      * @dev Moves tokens `amount` from `sender` to `recipient`.
376      *
377      * This is internal function is equivalent to {transfer}, and can be used to
378      * e.g. implement automatic token fees, slashing mechanisms, etc.
379      *
380      * Emits a {Transfer} event.
381      *
382      * Requirements:
383      *
384      * - `sender` cannot be the zero address.
385      * - `recipient` cannot be the zero address.
386      * - `sender` must have a balance of at least `amount`.
387      */
388     function _transfer(
389         address sender,
390         address recipient,
391         uint256 amount
392     ) internal virtual {
393         require(sender != address(0), "ERC20: transfer from the zero address");
394         require(recipient != address(0), "ERC20: transfer to the zero address");
395  
396         _beforeTokenTransfer(sender, recipient, amount);
397  
398         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
399         _balances[recipient] = _balances[recipient].add(amount);
400         emit Transfer(sender, recipient, amount);
401     }
402  
403     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
404      * the total supply.
405      *
406      * Emits a {Transfer} event with `from` set to the zero address.
407      *
408      * Requirements:
409      *
410      * - `account` cannot be the zero address.
411      */
412     function _mint(address account, uint256 amount) internal virtual {
413         require(account != address(0), "ERC20: mint to the zero address");
414  
415         _beforeTokenTransfer(address(0), account, amount);
416  
417         _totalSupply = _totalSupply.add(amount);
418         _balances[account] = _balances[account].add(amount);
419         emit Transfer(address(0), account, amount);
420     }
421  
422     /**
423      * @dev Destroys `amount` tokens from `account`, reducing the
424      * total supply.
425      *
426      * Emits a {Transfer} event with `to` set to the zero address.
427      *
428      * Requirements:
429      *
430      * - `account` cannot be the zero address.
431      * - `account` must have at least `amount` tokens.
432      */
433     function _burn(address account, uint256 amount) internal virtual {
434         require(account != address(0), "ERC20: burn from the zero address");
435  
436         _beforeTokenTransfer(account, address(0), amount);
437  
438         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
439         _totalSupply = _totalSupply.sub(amount);
440         emit Transfer(account, address(0), amount);
441     }
442  
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
445      *
446      * This internal function is equivalent to `approve`, and can be used to
447      * e.g. set automatic allowances for certain subsystems, etc.
448      *
449      * Emits an {Approval} event.
450      *
451      * Requirements:
452      *
453      * - `owner` cannot be the zero address.
454      * - `spender` cannot be the zero address.
455      */
456     function _approve(
457         address owner,
458         address spender,
459         uint256 amount
460     ) internal virtual {
461         require(owner != address(0), "ERC20: approve from the zero address");
462         require(spender != address(0), "ERC20: approve to the zero address");
463  
464         _allowances[owner][spender] = amount;
465         emit Approval(owner, spender, amount);
466     }
467  
468     /**
469      * @dev Hook that is called before any transfer of tokens. This includes
470      * minting and burning.
471      *
472      * Calling conditions:
473      *
474      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
475      * will be to transferred to `to`.
476      * - when `from` is zero, `amount` tokens will be minted for `to`.
477      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
478      * - `from` and `to` are never both zero.
479      *
480      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
481      */
482     function _beforeTokenTransfer(
483         address from,
484         address to,
485         uint256 amount
486     ) internal virtual {}
487 }
488  
489 library SafeMath {
490     function add(uint256 a, uint256 b) internal pure returns (uint256) {
491         uint256 c = a + b;
492         require(c >= a, "SafeMath: addition overflow");
493  
494         return c;
495     }
496 
497     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
498         return sub(a, b, "SafeMath: subtraction overflow");
499     }
500 
501     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
502         require(b <= a, errorMessage);
503         uint256 c = a - b;
504  
505         return c;
506     }
507 
508     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
509         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
510         // benefit is lost if 'b' is also tested.
511         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
512         if (a == 0) {
513             return 0;
514         }
515  
516         uint256 c = a * b;
517         require(c / a == b, "SafeMath: multiplication overflow");
518  
519         return c;
520     }
521 
522     function div(uint256 a, uint256 b) internal pure returns (uint256) {
523         return div(a, b, "SafeMath: division by zero");
524     }
525 
526     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
527         require(b > 0, errorMessage);
528         uint256 c = a / b;
529 
530         return c;
531     }
532 
533     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
534         return mod(a, b, "SafeMath: modulo by zero");
535     }
536 
537     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
538         require(b != 0, errorMessage);
539         return a % b;
540     }
541 }
542  
543 contract Ownable is Context {
544     address private _owner;
545  
546     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
547  
548     constructor () {
549         address msgSender = _msgSender();
550         _owner = msgSender;
551         emit OwnershipTransferred(address(0), msgSender);
552     }
553 
554     function owner() public view returns (address) {
555         return _owner;
556     }
557  
558     modifier onlyOwner() {
559         require(_owner == _msgSender(), "Ownable: caller is not the owner");
560         _;
561     }
562  
563     function renounceOwnership() public virtual onlyOwner {
564         emit OwnershipTransferred(_owner, address(0));
565         _owner = address(0);
566     }
567 
568     function transferOwnership(address newOwner) public virtual onlyOwner {
569         require(newOwner != address(0), "Ownable: new owner is the zero address");
570         emit OwnershipTransferred(_owner, newOwner);
571         _owner = newOwner;
572     }
573 }
574  
575  
576 
577 library SafeMathInt {
578     int256 private constant MIN_INT256 = int256(1) << 255;
579     int256 private constant MAX_INT256 = ~(int256(1) << 255);
580  
581     function mul(int256 a, int256 b) internal pure returns (int256) {
582         int256 c = a * b;
583  
584         // Detect overflow when multiplying MIN_INT256 with -1
585         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
586         require((b == 0) || (c / b == a));
587         return c;
588     }
589  
590     function div(int256 a, int256 b) internal pure returns (int256) {
591         // Prevent overflow when dividing MIN_INT256 by -1
592         require(b != -1 || a != MIN_INT256);
593  
594         // Solidity already throws when dividing by 0.
595         return a / b;
596     }
597  
598     function sub(int256 a, int256 b) internal pure returns (int256) {
599         int256 c = a - b;
600         require((b >= 0 && c <= a) || (b < 0 && c > a));
601         return c;
602     }
603  
604     function add(int256 a, int256 b) internal pure returns (int256) {
605         int256 c = a + b;
606         require((b >= 0 && c >= a) || (b < 0 && c < a));
607         return c;
608     }
609  
610     function abs(int256 a) internal pure returns (int256) {
611         require(a != MIN_INT256);
612         return a < 0 ? -a : a;
613     }
614  
615  
616     function toUint256Safe(int256 a) internal pure returns (uint256) {
617         require(a >= 0);
618         return uint256(a);
619     }
620 }
621  
622 library SafeMathUint {
623   function toInt256Safe(uint256 a) internal pure returns (int256) {
624     int256 b = int256(a);
625     require(b >= 0);
626     return b;
627   }
628 }
629  
630  
631 interface IUniswapV2Router01 {
632     function factory() external pure returns (address);
633     function WETH() external pure returns (address);
634  
635     function addLiquidity(
636         address tokenA,
637         address tokenB,
638         uint amountADesired,
639         uint amountBDesired,
640         uint amountAMin,
641         uint amountBMin,
642         address to,
643         uint deadline
644     ) external returns (uint amountA, uint amountB, uint liquidity);
645     function addLiquidityETH(
646         address token,
647         uint amountTokenDesired,
648         uint amountTokenMin,
649         uint amountETHMin,
650         address to,
651         uint deadline
652     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
653     function removeLiquidity(
654         address tokenA,
655         address tokenB,
656         uint liquidity,
657         uint amountAMin,
658         uint amountBMin,
659         address to,
660         uint deadline
661     ) external returns (uint amountA, uint amountB);
662     function removeLiquidityETH(
663         address token,
664         uint liquidity,
665         uint amountTokenMin,
666         uint amountETHMin,
667         address to,
668         uint deadline
669     ) external returns (uint amountToken, uint amountETH);
670     function removeLiquidityWithPermit(
671         address tokenA,
672         address tokenB,
673         uint liquidity,
674         uint amountAMin,
675         uint amountBMin,
676         address to,
677         uint deadline,
678         bool approveMax, uint8 v, bytes32 r, bytes32 s
679     ) external returns (uint amountA, uint amountB);
680     function removeLiquidityETHWithPermit(
681         address token,
682         uint liquidity,
683         uint amountTokenMin,
684         uint amountETHMin,
685         address to,
686         uint deadline,
687         bool approveMax, uint8 v, bytes32 r, bytes32 s
688     ) external returns (uint amountToken, uint amountETH);
689     function swapExactTokensForTokens(
690         uint amountIn,
691         uint amountOutMin,
692         address[] calldata path,
693         address to,
694         uint deadline
695     ) external returns (uint[] memory amounts);
696     function swapTokensForExactTokens(
697         uint amountOut,
698         uint amountInMax,
699         address[] calldata path,
700         address to,
701         uint deadline
702     ) external returns (uint[] memory amounts);
703     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
704         external
705         payable
706         returns (uint[] memory amounts);
707     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
708         external
709         returns (uint[] memory amounts);
710     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
711         external
712         returns (uint[] memory amounts);
713     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
714         external
715         payable
716         returns (uint[] memory amounts);
717  
718     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
719     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
720     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
721     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
722     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
723 }
724  
725 interface IUniswapV2Router02 is IUniswapV2Router01 {
726     function removeLiquidityETHSupportingFeeOnTransferTokens(
727         address token,
728         uint liquidity,
729         uint amountTokenMin,
730         uint amountETHMin,
731         address to,
732         uint deadline
733     ) external returns (uint amountETH);
734     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
735         address token,
736         uint liquidity,
737         uint amountTokenMin,
738         uint amountETHMin,
739         address to,
740         uint deadline,
741         bool approveMax, uint8 v, bytes32 r, bytes32 s
742     ) external returns (uint amountETH);
743  
744     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
745         uint amountIn,
746         uint amountOutMin,
747         address[] calldata path,
748         address to,
749         uint deadline
750     ) external;
751     function swapExactETHForTokensSupportingFeeOnTransferTokens(
752         uint amountOutMin,
753         address[] calldata path,
754         address to,
755         uint deadline
756     ) external payable;
757     function swapExactTokensForETHSupportingFeeOnTransferTokens(
758         uint amountIn,
759         uint amountOutMin,
760         address[] calldata path,
761         address to,
762         uint deadline
763     ) external;
764 }
765  
766 contract Eminem is ERC20, Ownable {
767     using SafeMath for uint256;
768  
769     IUniswapV2Router02 public immutable uniswapV2Router;
770     address public immutable uniswapV2Pair;
771     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
772  
773     bool private swapping;
774  
775     address public marketingWallet;
776     address public devWallet;
777  
778     uint256 public maxTransactionAmount;
779     uint256 public swapTokensAtAmount;
780     uint256 public maxWallet;
781  
782     bool public limitsInEffect = true;
783     bool public tradingActive = true;
784     bool public swapEnabled = false;
785  
786      // Anti-bot and anti-whale mappings and variables
787     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
788  
789     // Seller Map
790     mapping (address => uint256) private _holderFirstBuyTimestamp;
791  
792     bool public transferDelayEnabled = true;
793  
794     uint256 public buyTotalFees;
795     uint256 public buyMarketingFee;
796     uint256 public buyLiquidityFee;
797     uint256 public buyDevFee;
798  
799     uint256 public sellTotalFees;
800     uint256 public sellMarketingFee;
801     uint256 public sellLiquidityFee;
802     uint256 public sellDevFee;
803 
804     uint256 public feeDenominator;
805  
806     uint256 public tokensForMarketing;
807     uint256 public tokensForLiquidity;
808     uint256 public tokensForDev;
809  
810     // block number of opened trading
811     uint256 launchedAt;
812  
813     /******************/
814  
815     // exclude from fees and max transaction amount
816     mapping (address => bool) private _isExcludedFromFees;
817     mapping (address => bool) public _isExcludedMaxTransactionAmount;
818  
819     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
820     // could be subject to a maximum transfer amount
821     mapping (address => bool) public automatedMarketMakerPairs;
822  
823     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
824  
825     event ExcludeFromFees(address indexed account, bool isExcluded);
826  
827     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
828  
829     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
830  
831     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
832  
833     event SwapAndLiquify(
834         uint256 tokensSwapped,
835         uint256 ethReceived,
836         uint256 tokensIntoLiquidity
837     );
838  
839     constructor() ERC20("Every Meme Is Never Ever Meaningful", "EMINEM") {
840  
841         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
842  
843         excludeFromMaxTransaction(address(_uniswapV2Router), true);
844         uniswapV2Router = _uniswapV2Router;
845  
846         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
847         excludeFromMaxTransaction(address(uniswapV2Pair), true);
848         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
849  
850         uint256 _buyMarketingFee = 25;
851         uint256 _buyLiquidityFee = 0;
852         uint256 _buyDevFee = 5;
853         
854         uint256 _sellMarketingFee = 10;
855         uint256 _sellLiquidityFee = 0;
856         uint256 _sellDevFee = 20;
857 
858         uint256 _feeDenominator = 100;
859  
860         uint256 totalSupply = 1_000_000 * 1e18;
861  
862         maxTransactionAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
863         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
864         swapTokensAtAmount = totalSupply * 3 / 10000; // 0.03% swap wallet
865 
866         feeDenominator = _feeDenominator;
867  
868         buyMarketingFee = _buyMarketingFee;
869         buyLiquidityFee = _buyLiquidityFee;
870         buyDevFee = _buyDevFee;
871         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
872  
873         sellMarketingFee = _sellMarketingFee;
874         sellLiquidityFee = _sellLiquidityFee;
875         sellDevFee = _sellDevFee;
876         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
877  
878         marketingWallet = address(0x0B52968b57b87bf350A3770D7713c24B51D07E02); // set as marketing wallet
879         devWallet = address(0x0B52968b57b87bf350A3770D7713c24B51D07E02); // set as dev wallet
880  
881         // exclude from paying fees or having max transaction amount
882         excludeFromFees(owner(), true);
883         excludeFromFees(devWallet, true);
884         excludeFromFees(address(this), true);
885         excludeFromFees(address(0xdead), true);
886  
887         excludeFromMaxTransaction(owner(), true);
888         excludeFromMaxTransaction(devWallet, true);
889         excludeFromMaxTransaction(address(this), true);
890         excludeFromMaxTransaction(address(0xdead), true);
891  
892         /*
893             _mint is an internal function in ERC20.sol that is only called here,
894             and CANNOT be called ever again
895         */
896         _mint(msg.sender, totalSupply);
897     }
898  
899     receive() external payable {
900  
901   	}
902  
903     // once enabled, can never be turned off
904     function enableTrading() external onlyOwner {
905         tradingActive = true;
906         swapEnabled = true;
907         launchedAt = block.number;
908     }
909  
910     // remove limits after token is stable
911     function removeLimits() external onlyOwner returns (bool){
912         limitsInEffect = false;
913         return true;
914     }
915  
916     // disable Transfer delay - cannot be reenabled
917     function disableTransferDelay() external onlyOwner returns (bool){
918         transferDelayEnabled = false;
919         return true;
920     }
921  
922      // change the minimum amount of tokens to sell from fees
923     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
924   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
925   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
926   	    swapTokensAtAmount = newAmount;
927   	    return true;
928   	}
929  
930     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
931         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
932         maxTransactionAmount = newNum * (10**18);
933     }
934  
935     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
936         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
937         maxWallet = newNum * (10**18);
938     }
939  
940     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
941         _isExcludedMaxTransactionAmount[updAds] = isEx;
942     }
943  
944     // only use to disable contract sales if absolutely necessary (emergency use only)
945     function updateSwapEnabled(bool enabled) external onlyOwner(){
946         swapEnabled = enabled;
947     }
948  
949     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
950         buyMarketingFee = _marketingFee;
951         buyLiquidityFee = _liquidityFee;
952         buyDevFee = _devFee;
953         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
954         require(buyTotalFees.div(feeDenominator) <= 10, "Must keep fees at 10% or less");
955     }
956  
957     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
958         sellMarketingFee = _marketingFee;
959         sellLiquidityFee = _liquidityFee;
960         sellDevFee = _devFee;
961         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
962         require(sellTotalFees.div(feeDenominator) <= 10, "Must keep fees at 10% or less");
963     }
964  
965     function excludeFromFees(address account, bool excluded) public onlyOwner {
966         _isExcludedFromFees[account] = excluded;
967         emit ExcludeFromFees(account, excluded);
968     }
969  
970     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
971         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
972  
973         _setAutomatedMarketMakerPair(pair, value);
974     }
975  
976     function _setAutomatedMarketMakerPair(address pair, bool value) private {
977         automatedMarketMakerPairs[pair] = value;
978  
979         emit SetAutomatedMarketMakerPair(pair, value);
980     }
981  
982     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
983         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
984         marketingWallet = newMarketingWallet;
985     }
986  
987     function updateDevWallet(address newWallet) external onlyOwner {
988         emit devWalletUpdated(newWallet, devWallet);
989         devWallet = newWallet;
990     }
991 
992     function isExcludedFromFees(address account) public view returns(bool) {
993         return _isExcludedFromFees[account];
994     }
995  
996     function _transfer(
997         address from,
998         address to,
999         uint256 amount
1000     ) internal override {
1001         require(from != address(0), "ERC20: transfer from the zero address");
1002         require(to != address(0), "ERC20: transfer to the zero address");
1003         if(amount == 0) {
1004             super._transfer(from, to, 0);
1005             return;
1006         }
1007  
1008         if(limitsInEffect){
1009             if (
1010                 from != owner() &&
1011                 to != owner() &&
1012                 to != address(0) &&
1013                 to != address(0xdead) &&
1014                 !swapping
1015             ){
1016                 if(!tradingActive){
1017                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1018                 }
1019  
1020                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1021                 if (transferDelayEnabled) {
1022                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1023                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled. Only one purchase per block allowed.");
1024                         _holderLastTransferTimestamp[tx.origin] = block.number;
1025                     }
1026                 }
1027  
1028                 //when buy
1029                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1030                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1031                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1032                 }
1033  
1034                 //when sell
1035                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1036                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1037                 }
1038                 else if(!_isExcludedMaxTransactionAmount[to]){
1039                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1040                 }
1041             }
1042         }
1043  
1044 		uint256 contractTokenBalance = balanceOf(address(this));
1045  
1046         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1047  
1048         if( 
1049             canSwap &&
1050             swapEnabled &&
1051             !swapping &&
1052             !automatedMarketMakerPairs[from] &&
1053             !_isExcludedFromFees[from] &&
1054             !_isExcludedFromFees[to]
1055         ) {
1056             swapping = true;
1057  
1058             swapBack();
1059  
1060             swapping = false;
1061         }
1062  
1063         bool takeFee = !swapping;
1064  
1065         // if any account belongs to _isExcludedFromFee account then remove the fee
1066         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1067             takeFee = false;
1068         }
1069  
1070         uint256 fees = 0;
1071         // only take fees on buys/sells, do not take on wallet transfers
1072         if(takeFee){
1073             // on sell
1074             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1075                 fees = amount.mul(sellTotalFees).div(feeDenominator);
1076                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1077                 tokensForDev += fees * sellDevFee / sellTotalFees;
1078                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1079             }
1080             // on buy
1081             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1082         	    fees = amount.mul(buyTotalFees).div(feeDenominator);
1083         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1084                 tokensForDev += fees * buyDevFee / buyTotalFees;
1085                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1086             }
1087  
1088             if(fees > 0){    
1089                 super._transfer(from, address(this), fees);
1090             }
1091  
1092         	amount -= fees;
1093         }
1094  
1095         super._transfer(from, to, amount);
1096     }
1097  
1098     function swapTokensForEth(uint256 tokenAmount) private {
1099         // generate the uniswap pair path of token -> weth
1100         address[] memory path = new address[](2);
1101         path[0] = address(this);
1102         path[1] = uniswapV2Router.WETH();
1103  
1104         _approve(address(this), address(uniswapV2Router), tokenAmount);
1105  
1106         // make the swap
1107         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1108             tokenAmount,
1109             0, // accept any amount of ETH
1110             path,
1111             address(this),
1112             block.timestamp
1113         );
1114     }
1115  
1116     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1117         // approve token transfer to cover all possible scenarios
1118         _approve(address(this), address(uniswapV2Router), tokenAmount);
1119  
1120         // add the liquidity
1121         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1122             address(this),
1123             tokenAmount,
1124             0, // slippage is unavoidable
1125             0, // slippage is unavoidable
1126             deadAddress,
1127             block.timestamp
1128         );
1129     }
1130  
1131     function swapBack() private {
1132         uint256 contractBalance = balanceOf(address(this));
1133         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1134         bool success;
1135  
1136         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1137  
1138         if(contractBalance > swapTokensAtAmount * 20){
1139           contractBalance = swapTokensAtAmount * 20;
1140         }
1141  
1142         // Halve the amount of liquidity tokens
1143         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1144         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1145  
1146         uint256 initialETHBalance = address(this).balance;
1147  
1148         swapTokensForEth(amountToSwapForETH); 
1149  
1150         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1151  
1152         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1153         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1154  
1155         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1156  
1157         tokensForLiquidity = 0;
1158         tokensForMarketing = 0;
1159         tokensForDev = 0;
1160  
1161         (success,) = address(devWallet).call{value: ethForDev}("");
1162  
1163         if(liquidityTokens > 0 && ethForLiquidity > 0){
1164             addLiquidity(liquidityTokens, ethForLiquidity);
1165             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1166         }
1167  
1168         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1169     }
1170 }