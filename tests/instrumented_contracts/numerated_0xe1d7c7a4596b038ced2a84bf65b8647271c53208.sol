1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.0;
4 
5 //
6 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
7 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
8 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▓▒░░░░░░▒▓▓▓▓▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
9 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▒░░░░░░▓▓▓▓▓▓▓▓▓▓▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
10 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░
11 //░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▒░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░
12 //░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▒░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░
13 //░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░
14 //░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░
15 //░░░░░░░░░░░░░░░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▒░░░░░░▒▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░░
16 //░░░░░░░░░░░░░▒▓▒░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓░░░░░░░▒▓▒░░░░░░░░░░░░
17 //░░░░░░░░░░░░▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▒░░░░░░▒▓▓▓▓▒░░░░░░░▓▓▓▓▒░░░░░░░░░░░
18 //░░░░░░░░░░░▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▒░░░░░░░▒▓▓▓▓▓▓▓░░░░░░░░░░
19 //░░░░░░░░░░▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░▓▓▓▓▓▓▓▓▓▓░░░░░░░░░
20 //░░░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░
21 //░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▒▓▓▓▓▓▓▓▓▓░░░░░░░░░░▓▓▓▓▓▓▓▓▓░░░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░
22 //░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░▓▓▓▓▓▓▓▒░░░░░░░░░░░▒▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░
23 //░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░▒▒▒░░░░░░░░░░░░░░░░▒▒▒▒░░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░
24 //░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░▓▓▒░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░▒░░░
25 //░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░▒▓▓▓▓▓▒░░░░░░░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░
26 //░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░▓▓▓▓▓▓▓▓▓░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░
27 //░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░▒▓▓▓▓▓▓▓▓▓▒░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░
28 //░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░▓▓▓▓▓▓▓▓▒░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░
29 //░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░▒▓▓▓▓▓░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░
30 //░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░▒▒▒░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░▒░░░
31 //░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▒▓▓▓▒░░░░░░░░░░░░░░░▒▒▒▒▒░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░▒░░░
32 //░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░▓▓▓▓▓▓▓▒░░░░░░░░░░░▓▓▓▓▓▓▓▓░░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░
33 //░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░▒▓▓▓▓▓▓▓▓▓░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▒░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░
34 //░░░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▒░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░
35 //░░░░░░░░░░▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓░░░░░░░░░
36 //░░░░░░░░░░░▓▓▓▓▓▓▓░░░░░░░▒▓▓▒░░░░░░▒▓▓▓▓▓▓▓▓▓▒░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓░░░░░░░░░░
37 //░░░░░░░░░░░░▓▓▓▓▒░░░░░░░▓▓▓▓▓▓░░░░░░░▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▒░░░░░░░░░░░
38 //░░░░░░░░░░░░░▒▓░░░░░░░▒▓▓▓▓▓▓▓▓▒░░░░░░▒▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░▒▓▒░░░░░░░░░░░░
39 //░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░
40 //░░░░░░░░░░░░░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░▒▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░
41 //░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▓▓▓▓▓▓▓▓▓▓▒░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░
42 //░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░▒▓▓▓▓▓▓▓▓▓▓░░░░░░░▒▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░
43 //░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░▓▓▓▓▓▓▓▓▓▓▒░░░░░░▒▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░
44 //░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░▒▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
45 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓▓▓▓▓▓▓▓▓▓▒░░░░░░▓▓▓▓▓▓▓▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
46 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▓▓▓▓▓▒░░░░░░▒▓▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
47 //░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
48 //         __ _         _       _
49 //  _ __  / _| |_ _   _| | __ _| |__  ___
50 // | '_ \| |_| __| | | | |/ _` | '_ \/ __|
51 // | | | |  _| |_| |_| | | (_| | |_) \__ \
52 // |_| |_|_|  \__|\__, |_|\__,_|_.__/|___/
53 //                |___/
54 //
55 // Name: NFTY Token
56 // Symbol: NFTY
57 // Decimals: 18
58 // Initial Supply: 509684123 NFTY
59 // Supply Limit:  1456240353 NFTY
60 // Emissions Limit: 88 NFTY per block
61 
62 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.1
63 
64 /**
65  * @dev Interface of the ERC20 standard as defined in the EIP.
66  */
67 interface IERC20 {
68     /**
69      * @dev Returns the amount of tokens in existence.
70      */
71     function totalSupply() external view returns (uint256);
72 
73     /**
74      * @dev Returns the amount of tokens owned by `account`.
75      */
76     function balanceOf(address account) external view returns (uint256);
77 
78     /**
79      * @dev Moves `amount` tokens from the caller's account to `recipient`.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transfer(address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Returns the remaining number of tokens that `spender` will be
89      * allowed to spend on behalf of `owner` through {transferFrom}. This is
90      * zero by default.
91      *
92      * This value changes when {approve} or {transferFrom} are called.
93      */
94     function allowance(address owner, address spender) external view returns (uint256);
95 
96     /**
97      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * IMPORTANT: Beware that changing an allowance with this method brings the risk
102      * that someone may use both the old and the new allowance by unfortunate
103      * transaction ordering. One possible solution to mitigate this race
104      * condition is to first reduce the spender's allowance to 0 and set the
105      * desired value afterwards:
106      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107      *
108      * Emits an {Approval} event.
109      */
110     function approve(address spender, uint256 amount) external returns (bool);
111 
112     /**
113      * @dev Moves `amount` tokens from `sender` to `recipient` using the
114      * allowance mechanism. `amount` is then deducted from the caller's
115      * allowance.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(
122         address sender,
123         address recipient,
124         uint256 amount
125     ) external returns (bool);
126 
127     /**
128      * @dev Emitted when `value` tokens are moved from one account (`from`) to
129      * another (`to`).
130      *
131      * Note that `value` may be zero.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     /**
136      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
137      * a call to {approve}. `value` is the new allowance.
138      */
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 
143 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.1
144 
145 /**
146  * @dev Interface for the optional metadata functions from the ERC20 standard.
147  *
148  * _Available since v4.1._
149  */
150 interface IERC20Metadata is IERC20 {
151     /**
152      * @dev Returns the name of the token.
153      */
154     function name() external view returns (string memory);
155 
156     /**
157      * @dev Returns the symbol of the token.
158      */
159     function symbol() external view returns (string memory);
160 
161     /**
162      * @dev Returns the decimals places of the token.
163      */
164     function decimals() external view returns (uint8);
165 }
166 
167 
168 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
169 
170 /**
171  * @dev Provides information about the current execution context, including the
172  * sender of the transaction and its data. While these are generally available
173  * via msg.sender and msg.data, they should not be accessed in such a direct
174  * manner, since when dealing with meta-transactions the account sending and
175  * paying for execution may not be the actual sender (as far as an application
176  * is concerned).
177  *
178  * This contract is only required for intermediate, library-like contracts.
179  */
180 abstract contract Context {
181     function _msgSender() internal view virtual returns (address) {
182         return msg.sender;
183     }
184 
185     function _msgData() internal view virtual returns (bytes calldata) {
186         return msg.data;
187     }
188 }
189 
190 
191 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.1
192 
193 /**
194  * @dev Implementation of the {IERC20} interface.
195  *
196  * This implementation is agnostic to the way tokens are created. This means
197  * that a supply mechanism has to be added in a derived contract using {_mint}.
198  * For a generic mechanism see {ERC20PresetMinterPauser}.
199  *
200  * TIP: For a detailed writeup see our guide
201  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
202  * to implement supply mechanisms].
203  *
204  * We have followed general OpenZeppelin Contracts guidelines: functions revert
205  * instead returning `false` on failure. This behavior is nonetheless
206  * conventional and does not conflict with the expectations of ERC20
207  * applications.
208  *
209  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
210  * This allows applications to reconstruct the allowance for all accounts just
211  * by listening to said events. Other implementations of the EIP may not emit
212  * these events, as it isn't required by the specification.
213  *
214  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
215  * functions have been added to mitigate the well-known issues around setting
216  * allowances. See {IERC20-approve}.
217  */
218 contract ERC20 is Context, IERC20, IERC20Metadata {
219     mapping(address => uint256) private _balances;
220 
221     mapping(address => mapping(address => uint256)) private _allowances;
222 
223     uint256 private _totalSupply;
224 
225     string private _name;
226     string private _symbol;
227 
228     /**
229      * @dev Sets the values for {name} and {symbol}.
230      *
231      * The default value of {decimals} is 18. To select a different value for
232      * {decimals} you should overload it.
233      *
234      * All two of these values are immutable: they can only be set once during
235      * construction.
236      */
237     constructor(string memory name_, string memory symbol_) {
238         _name = name_;
239         _symbol = symbol_;
240     }
241 
242     /**
243      * @dev Returns the name of the token.
244      */
245     function name() public view virtual override returns (string memory) {
246         return _name;
247     }
248 
249     /**
250      * @dev Returns the symbol of the token, usually a shorter version of the
251      * name.
252      */
253     function symbol() public view virtual override returns (string memory) {
254         return _symbol;
255     }
256 
257     /**
258      * @dev Returns the number of decimals used to get its user representation.
259      * For example, if `decimals` equals `2`, a balance of `505` tokens should
260      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
261      *
262      * Tokens usually opt for a value of 18, imitating the relationship between
263      * Ether and Wei. This is the value {ERC20} uses, unless this function is
264      * overridden;
265      *
266      * NOTE: This information is only used for _display_ purposes: it in
267      * no way affects any of the arithmetic of the contract, including
268      * {IERC20-balanceOf} and {IERC20-transfer}.
269      */
270     function decimals() public view virtual override returns (uint8) {
271         return 18;
272     }
273 
274     /**
275      * @dev See {IERC20-totalSupply}.
276      */
277     function totalSupply() public view virtual override returns (uint256) {
278         return _totalSupply;
279     }
280 
281     /**
282      * @dev See {IERC20-balanceOf}.
283      */
284     function balanceOf(address account) public view virtual override returns (uint256) {
285         return _balances[account];
286     }
287 
288     /**
289      * @dev See {IERC20-transfer}.
290      *
291      * Requirements:
292      *
293      * - `recipient` cannot be the zero address.
294      * - the caller must have a balance of at least `amount`.
295      */
296     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
297         _transfer(_msgSender(), recipient, amount);
298         return true;
299     }
300 
301     /**
302      * @dev See {IERC20-allowance}.
303      */
304     function allowance(address owner, address spender) public view virtual override returns (uint256) {
305         return _allowances[owner][spender];
306     }
307 
308     /**
309      * @dev See {IERC20-approve}.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function approve(address spender, uint256 amount) public virtual override returns (bool) {
316         _approve(_msgSender(), spender, amount);
317         return true;
318     }
319 
320     /**
321      * @dev See {IERC20-transferFrom}.
322      *
323      * Emits an {Approval} event indicating the updated allowance. This is not
324      * required by the EIP. See the note at the beginning of {ERC20}.
325      *
326      * Requirements:
327      *
328      * - `sender` and `recipient` cannot be the zero address.
329      * - `sender` must have a balance of at least `amount`.
330      * - the caller must have allowance for ``sender``'s tokens of at least
331      * `amount`.
332      */
333     function transferFrom(
334         address sender,
335         address recipient,
336         uint256 amount
337     ) public virtual override returns (bool) {
338         _transfer(sender, recipient, amount);
339 
340         uint256 currentAllowance = _allowances[sender][_msgSender()];
341         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
342         unchecked {
343             _approve(sender, _msgSender(), currentAllowance - amount);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Atomically increases the allowance granted to `spender` by the caller.
351      *
352      * This is an alternative to {approve} that can be used as a mitigation for
353      * problems described in {IERC20-approve}.
354      *
355      * Emits an {Approval} event indicating the updated allowance.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      */
361     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
362         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
363         return true;
364     }
365 
366     /**
367      * @dev Atomically decreases the allowance granted to `spender` by the caller.
368      *
369      * This is an alternative to {approve} that can be used as a mitigation for
370      * problems described in {IERC20-approve}.
371      *
372      * Emits an {Approval} event indicating the updated allowance.
373      *
374      * Requirements:
375      *
376      * - `spender` cannot be the zero address.
377      * - `spender` must have allowance for the caller of at least
378      * `subtractedValue`.
379      */
380     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
381         uint256 currentAllowance = _allowances[_msgSender()][spender];
382         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
383         unchecked {
384             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
385         }
386 
387         return true;
388     }
389 
390     /**
391      * @dev Moves `amount` of tokens from `sender` to `recipient`.
392      *
393      * This internal function is equivalent to {transfer}, and can be used to
394      * e.g. implement automatic token fees, slashing mechanisms, etc.
395      *
396      * Emits a {Transfer} event.
397      *
398      * Requirements:
399      *
400      * - `sender` cannot be the zero address.
401      * - `recipient` cannot be the zero address.
402      * - `sender` must have a balance of at least `amount`.
403      */
404     function _transfer(
405         address sender,
406         address recipient,
407         uint256 amount
408     ) internal virtual {
409         require(sender != address(0), "ERC20: transfer from the zero address");
410         require(recipient != address(0), "ERC20: transfer to the zero address");
411 
412         _beforeTokenTransfer(sender, recipient, amount);
413 
414         uint256 senderBalance = _balances[sender];
415         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
416         unchecked {
417             _balances[sender] = senderBalance - amount;
418         }
419         _balances[recipient] += amount;
420 
421         emit Transfer(sender, recipient, amount);
422 
423         _afterTokenTransfer(sender, recipient, amount);
424     }
425 
426     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
427      * the total supply.
428      *
429      * Emits a {Transfer} event with `from` set to the zero address.
430      *
431      * Requirements:
432      *
433      * - `account` cannot be the zero address.
434      */
435     function _mint(address account, uint256 amount) internal virtual {
436         require(account != address(0), "ERC20: mint to the zero address");
437 
438         _beforeTokenTransfer(address(0), account, amount);
439 
440         _totalSupply += amount;
441         _balances[account] += amount;
442         emit Transfer(address(0), account, amount);
443 
444         _afterTokenTransfer(address(0), account, amount);
445     }
446 
447     /**
448      * @dev Destroys `amount` tokens from `account`, reducing the
449      * total supply.
450      *
451      * Emits a {Transfer} event with `to` set to the zero address.
452      *
453      * Requirements:
454      *
455      * - `account` cannot be the zero address.
456      * - `account` must have at least `amount` tokens.
457      */
458     function _burn(address account, uint256 amount) internal virtual {
459         require(account != address(0), "ERC20: burn from the zero address");
460 
461         _beforeTokenTransfer(account, address(0), amount);
462 
463         uint256 accountBalance = _balances[account];
464         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
465         unchecked {
466             _balances[account] = accountBalance - amount;
467         }
468         _totalSupply -= amount;
469 
470         emit Transfer(account, address(0), amount);
471 
472         _afterTokenTransfer(account, address(0), amount);
473     }
474 
475     /**
476      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
477      *
478      * This internal function is equivalent to `approve`, and can be used to
479      * e.g. set automatic allowances for certain subsystems, etc.
480      *
481      * Emits an {Approval} event.
482      *
483      * Requirements:
484      *
485      * - `owner` cannot be the zero address.
486      * - `spender` cannot be the zero address.
487      */
488     function _approve(
489         address owner,
490         address spender,
491         uint256 amount
492     ) internal virtual {
493         require(owner != address(0), "ERC20: approve from the zero address");
494         require(spender != address(0), "ERC20: approve to the zero address");
495 
496         _allowances[owner][spender] = amount;
497         emit Approval(owner, spender, amount);
498     }
499 
500     /**
501      * @dev Hook that is called before any transfer of tokens. This includes
502      * minting and burning.
503      *
504      * Calling conditions:
505      *
506      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
507      * will be transferred to `to`.
508      * - when `from` is zero, `amount` tokens will be minted for `to`.
509      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
510      * - `from` and `to` are never both zero.
511      *
512      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
513      */
514     function _beforeTokenTransfer(
515         address from,
516         address to,
517         uint256 amount
518     ) internal virtual {}
519 
520     /**
521      * @dev Hook that is called after any transfer of tokens. This includes
522      * minting and burning.
523      *
524      * Calling conditions:
525      *
526      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
527      * has been transferred to `to`.
528      * - when `from` is zero, `amount` tokens have been minted for `to`.
529      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
530      * - `from` and `to` are never both zero.
531      *
532      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
533      */
534     function _afterTokenTransfer(
535         address from,
536         address to,
537         uint256 amount
538     ) internal virtual {}
539 }
540 
541 
542 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
543 
544 /**
545  * @dev Contract module which provides a basic access control mechanism, where
546  * there is an account (an owner) that can be granted exclusive access to
547  * specific functions.
548  *
549  * By default, the owner account will be the one that deploys the contract. This
550  * can later be changed with {transferOwnership}.
551  *
552  * This module is used through inheritance. It will make available the modifier
553  * `onlyOwner`, which can be applied to your functions to restrict their use to
554  * the owner.
555  */
556 abstract contract Ownable is Context {
557     address private _owner;
558 
559     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
560 
561     /**
562      * @dev Initializes the contract setting the deployer as the initial owner.
563      */
564     constructor() {
565         _setOwner(_msgSender());
566     }
567 
568     /**
569      * @dev Returns the address of the current owner.
570      */
571     function owner() public view virtual returns (address) {
572         return _owner;
573     }
574 
575     /**
576      * @dev Throws if called by any account other than the owner.
577      */
578     modifier onlyOwner() {
579         require(owner() == _msgSender(), "Ownable: caller is not the owner");
580         _;
581     }
582 
583     /**
584      * @dev Leaves the contract without owner. It will not be possible to call
585      * `onlyOwner` functions anymore. Can only be called by the current owner.
586      *
587      * NOTE: Renouncing ownership will leave the contract without an owner,
588      * thereby removing any functionality that is only available to the owner.
589      */
590     function renounceOwnership() public virtual onlyOwner {
591         _setOwner(address(0));
592     }
593 
594     /**
595      * @dev Transfers ownership of the contract to a new account (`newOwner`).
596      * Can only be called by the current owner.
597      */
598     function transferOwnership(address newOwner) public virtual onlyOwner {
599         require(newOwner != address(0), "Ownable: new owner is the zero address");
600         _setOwner(newOwner);
601     }
602 
603     function _setOwner(address newOwner) private {
604         address oldOwner = _owner;
605         _owner = newOwner;
606         emit OwnershipTransferred(oldOwner, newOwner);
607     }
608 }
609 
610 
611 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.1
612 
613 // CAUTION
614 // This version of SafeMath should only be used with Solidity 0.8 or later,
615 // because it relies on the compiler's built in overflow checks.
616 
617 /**
618  * @dev Wrappers over Solidity's arithmetic operations.
619  *
620  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
621  * now has built in overflow checking.
622  */
623 library SafeMath {
624     /**
625      * @dev Returns the addition of two unsigned integers, with an overflow flag.
626      *
627      * _Available since v3.4._
628      */
629     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
630         unchecked {
631             uint256 c = a + b;
632             if (c < a) return (false, 0);
633             return (true, c);
634         }
635     }
636 
637     /**
638      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
639      *
640      * _Available since v3.4._
641      */
642     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
643         unchecked {
644             if (b > a) return (false, 0);
645             return (true, a - b);
646         }
647     }
648 
649     /**
650      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
651      *
652      * _Available since v3.4._
653      */
654     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
655         unchecked {
656             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
657             // benefit is lost if 'b' is also tested.
658             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
659             if (a == 0) return (true, 0);
660             uint256 c = a * b;
661             if (c / a != b) return (false, 0);
662             return (true, c);
663         }
664     }
665 
666     /**
667      * @dev Returns the division of two unsigned integers, with a division by zero flag.
668      *
669      * _Available since v3.4._
670      */
671     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
672         unchecked {
673             if (b == 0) return (false, 0);
674             return (true, a / b);
675         }
676     }
677 
678     /**
679      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
680      *
681      * _Available since v3.4._
682      */
683     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
684         unchecked {
685             if (b == 0) return (false, 0);
686             return (true, a % b);
687         }
688     }
689 
690     /**
691      * @dev Returns the addition of two unsigned integers, reverting on
692      * overflow.
693      *
694      * Counterpart to Solidity's `+` operator.
695      *
696      * Requirements:
697      *
698      * - Addition cannot overflow.
699      */
700     function add(uint256 a, uint256 b) internal pure returns (uint256) {
701         return a + b;
702     }
703 
704     /**
705      * @dev Returns the subtraction of two unsigned integers, reverting on
706      * overflow (when the result is negative).
707      *
708      * Counterpart to Solidity's `-` operator.
709      *
710      * Requirements:
711      *
712      * - Subtraction cannot overflow.
713      */
714     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
715         return a - b;
716     }
717 
718     /**
719      * @dev Returns the multiplication of two unsigned integers, reverting on
720      * overflow.
721      *
722      * Counterpart to Solidity's `*` operator.
723      *
724      * Requirements:
725      *
726      * - Multiplication cannot overflow.
727      */
728     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
729         return a * b;
730     }
731 
732     /**
733      * @dev Returns the integer division of two unsigned integers, reverting on
734      * division by zero. The result is rounded towards zero.
735      *
736      * Counterpart to Solidity's `/` operator.
737      *
738      * Requirements:
739      *
740      * - The divisor cannot be zero.
741      */
742     function div(uint256 a, uint256 b) internal pure returns (uint256) {
743         return a / b;
744     }
745 
746     /**
747      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
748      * reverting when dividing by zero.
749      *
750      * Counterpart to Solidity's `%` operator. This function uses a `revert`
751      * opcode (which leaves remaining gas untouched) while Solidity uses an
752      * invalid opcode to revert (consuming all remaining gas).
753      *
754      * Requirements:
755      *
756      * - The divisor cannot be zero.
757      */
758     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
759         return a % b;
760     }
761 
762     /**
763      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
764      * overflow (when the result is negative).
765      *
766      * CAUTION: This function is deprecated because it requires allocating memory for the error
767      * message unnecessarily. For custom revert reasons use {trySub}.
768      *
769      * Counterpart to Solidity's `-` operator.
770      *
771      * Requirements:
772      *
773      * - Subtraction cannot overflow.
774      */
775     function sub(
776         uint256 a,
777         uint256 b,
778         string memory errorMessage
779     ) internal pure returns (uint256) {
780         unchecked {
781             require(b <= a, errorMessage);
782             return a - b;
783         }
784     }
785 
786     /**
787      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
788      * division by zero. The result is rounded towards zero.
789      *
790      * Counterpart to Solidity's `/` operator. Note: this function uses a
791      * `revert` opcode (which leaves remaining gas untouched) while Solidity
792      * uses an invalid opcode to revert (consuming all remaining gas).
793      *
794      * Requirements:
795      *
796      * - The divisor cannot be zero.
797      */
798     function div(
799         uint256 a,
800         uint256 b,
801         string memory errorMessage
802     ) internal pure returns (uint256) {
803         unchecked {
804             require(b > 0, errorMessage);
805             return a / b;
806         }
807     }
808 
809     /**
810      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
811      * reverting with custom message when dividing by zero.
812      *
813      * CAUTION: This function is deprecated because it requires allocating memory for the error
814      * message unnecessarily. For custom revert reasons use {tryMod}.
815      *
816      * Counterpart to Solidity's `%` operator. This function uses a `revert`
817      * opcode (which leaves remaining gas untouched) while Solidity uses an
818      * invalid opcode to revert (consuming all remaining gas).
819      *
820      * Requirements:
821      *
822      * - The divisor cannot be zero.
823      */
824     function mod(
825         uint256 a,
826         uint256 b,
827         string memory errorMessage
828     ) internal pure returns (uint256) {
829         unchecked {
830             require(b > 0, errorMessage);
831             return a % b;
832         }
833     }
834 }
835 
836 abstract contract AuxContract is Ownable {
837   function cron(address rewardTo) external virtual;
838 }
839 
840 contract NFTY is ERC20, Ownable {
841   using SafeMath for *;
842 
843   // constants
844   uint8 constant private DECIMALS = 18;
845   uint256 constant public SUPPLY_LIMIT   =       1456240353 * 10 ** DECIMALS;
846   uint256 constant public INITIAL_SUPPLY =        509684123 * 10 ** DECIMALS;
847 
848   // amount of token per block (88 token max)
849   uint256 constant public MAX_AMOUNT_PER_BLOCK =         88 * 10 ** DECIMALS;
850   uint256 public amountMinedPerBlock =                  MAX_AMOUNT_PER_BLOCK;
851 
852   AuxContract auxContract;
853 
854   // wallets
855   address public w1; address public w2; address public w3; address public w4;
856   // ratios
857   uint256 public r1; uint256 public r2; uint256 public r3; uint256 public r4;
858 
859   // state variables
860   uint256 public lastBlockMined;
861   bool public miningPaused;
862   uint256 public amountBurned;
863 
864   event AlreadyMined(uint256 block);
865   event Mined(uint256 block, uint256 amountMined, uint256 amountBurned, uint256 totalSupply, uint256 totalBurned);
866   event EmissionsLowered(uint256 block, uint256 newAmountPerBlock);
867   event Paused(uint256 block);
868   event Unpaused(uint256 block);
869   event AuthDelegated(address from, address to);
870   event VoteDelegated(address from, address to);
871 
872   /// @dev Decimals override
873   function decimals() public pure override returns (uint8){
874     return DECIMALS;
875   }
876 
877   /// @notice Burn an amount of tokens, and increment the global amountBurned variable
878   function burn(uint256 amount) public {
879       _burn(_msgSender(), amount);
880       amountBurned += amount; // add this burnAmount to amountBurned total
881   }
882 
883   /**
884    * @notice
885    * Constructor called on contract deployment
886    * This function mints the initial supploy to the contract deployer.
887    * This function also initializes miningPaused to True, and lastBlockMined to the current block
888    */
889   constructor() ERC20("NFTY Token", "NFTY") {
890     _mint(msg.sender, INITIAL_SUPPLY); // initial supply
891     lastBlockMined = block.number; // init block number
892     miningPaused = true;
893   }
894   
895   mapping (address=>address) public delegatedAuth;
896 
897   /// @notice Delegate wallet authentication to another address
898   /// @param to The address to delegate authentication to
899   function delegateAuth(address to) public {
900     delegatedAuth[msg.sender] = to;
901     emit AuthDelegated(msg.sender, to);
902   }
903 
904   mapping (address=>address) public delegatedVote;
905 
906   /// @notice Delegate wallet voting to another address
907   /// @param to The address to delegate authentication to
908   function delegateVote(address to) public {
909     delegatedVote[msg.sender] = to;
910     emit VoteDelegated(msg.sender, to);
911   }
912 
913   /**
914    * @dev calculates & returns the TOTAL pending emission and its subsequent split,
915    * based on the current stream ratios (r1,r2,r3,r4). 
916    * These values are stored & returned as amt2mine,amt1,amt2,amt3,amt4,amt2burn
917    * If any checks fail, returns all values as 0 - `(0,0,0,0,0,0)`
918    */
919   /**
920    * @return six-element tuple of uint256's, which represent
921    * 1. TOTAL amount to mine 
922    * 2. amount for stream wallet 1
923    * 3. amount for stream wallet 2
924    * 4. amount for stream wallet 3
925    * 5. amount for stream wallet 4
926    * 6. amount to burn
927    */
928   function getAmounts() public view returns 
929   (uint256, uint256, uint256, uint256, uint256, uint256) {
930     // Check if miningPaused OR no difference between now and lastBlockMined 
931     int256 since = int256(block.number) - int256(lastBlockMined);
932     if (since <= 0 || miningPaused) {
933       return (0,0,0,0,0,0);
934     }
935     // Determine current reward
936     uint256 tReward = amountMinedPerBlock.mul(uint256(since));
937 
938     // Check if supply limit has been reached
939     uint256 supply = totalSupply().add(amountBurned);
940     if (SUPPLY_LIMIT <= supply) {
941       return (0,0,0,0,0,0);
942     }
943 
944     // Ensure correct amount should be mined
945     // If full amount is over limit, only mine the spare change
946     if (tReward.add(supply) > SUPPLY_LIMIT) {
947       tReward = SUPPLY_LIMIT.sub(supply);
948     }
949 
950     // Check if tReward is 0 at this point
951     if (tReward == 0) {
952       return (0,0,0,0,0,0);
953     }
954 
955     // split the stream amounts
956     uint256 amt1 = tReward.mul(r1).div(100);
957     uint256 amt2 = tReward.mul(r2).div(100);
958     uint256 amt3 = tReward.mul(r3).div(100);
959     uint256 amt4 = tReward.mul(r4).div(100);
960     uint256 summed = amt1.add(amt2).add(amt3).add(amt4);
961 
962     // Burn remainder
963     uint256 burnAmount;
964     if (summed != tReward) { 
965       burnAmount = tReward.sub(summed);
966     }
967 
968     // Verify splits add up
969     require(tReward == burnAmount.add(amt1).add(amt2).add(amt3).add(amt4), "mismatch");
970     return (tReward, amt1, amt2, amt3, amt4, burnAmount);
971   }
972 
973   /// @dev This function calls mineTo, but with rewardTo set as zero-address 
974   function mine() public {
975     mineTo(address(0));
976   }
977 
978   /**
979    * @dev If miningPaused, this function does nothing
980    * If tokens were already mined this block, this function does nothing
981    * If amountBurned + totalSupply >= SUPPLY_LIMIT, this function does nothing.
982    */
983   /// @notice Create tokens and send down the pre-defined streams. 
984   /// @param rewardTo Which address to send reward to for mining tokens
985   function mineTo(address rewardTo) public {
986     if (miningPaused) {
987       return;
988     }
989     // only mine once per block, maximum.
990     // don't revert, in case called via some downstream contract
991     if (lastBlockMined >= block.number) {
992       emit AlreadyMined(block.number);
993       return;
994     }
995 
996     // use getAmounts() to calculate splits
997     (uint256 amt2mine, uint256 amount1, uint256 amount2, uint256 amount3, uint256 amount4, uint256 amt2burn) = getAmounts();
998     if (amt2mine == 0) {
999       return;
1000     }
1001     lastBlockMined = block.number;
1002 
1003     // transfer downstream if amount is not zero
1004     if (amount1 != 0) { _mint(w1, amount1); }
1005     if (amount2 != 0) { _mint(w2, amount2); }
1006     if (amount3 != 0) { _mint(w3, amount3); }
1007     if (amount4 != 0) { _mint(w4, amount4); }
1008 
1009     // There are tokens to burn, so add them to amt2burn
1010     // No point in burning then minting, so simply track these in global amountBurned variable
1011     if (amt2burn != 0) {
1012       amountBurned += amt2burn; 
1013     }
1014     emit Mined(block.number, amt2mine, amt2burn, totalSupply(), amountBurned);
1015 
1016     // Call auxiliary contract for reward, passing rewardTo address
1017     AuxContract aux = auxContract;
1018     if (address(aux) != address(0)) {
1019         try aux.cron(rewardTo) {} catch {}
1020     }
1021   }
1022 
1023   /// @notice Assign stream wallets for token emissions (available to contract owner only)
1024   /// @notice Order matters for these addresses, as they correspond to the matching numbered ratio
1025   /// @param a1 First stream address 
1026   /// @param a2 Second stream address
1027   /// @param a3 Third stream address
1028   /// @param a4 Fourth stream address
1029   function updateStreams(address a1, address a2, address a3, address a4) public onlyOwner {
1030     require(a1 != address(0), "address 1 cannot be zero address");
1031     w1 = a1; w2 = a2; w3 = a3; w4 = a4;
1032     // disable slot if zero address (will burn in 'mine' step)
1033     if (w2 == address(0)) { r2 = 0; }
1034     if (w3 == address(0)) { r3 = 0; }
1035     if (w4 == address(0)) { r4 = 0; }
1036   }
1037 
1038 
1039   /// @notice Assign stream ratios for token emissions (available to contract owner only)
1040   /// @notice Order matters for these ratios, as they correspond to the matching numbered wallet
1041   /// @param a1 First stream ratio
1042   /// @param a2 Second stream ratio
1043   /// @param a3 Third stream ratio
1044   /// @param a4 Fourth stream ratio
1045   function updateStreamRatios(uint256 a1, uint256  a2, uint256 a3, uint256 a4) public onlyOwner {
1046     require(a1.add(a2).add(a3).add(a4) <= 100, "parts exceed 100");
1047     if (w2 == address(0)){ require(a2 == 0, "cannot mint to zero address 2"); }
1048     if (w3 == address(0)){ require(a3 == 0, "cannot mint to zero address 3"); }
1049     if (w4 == address(0)){ require(a4 == 0, "cannot mint to zero address 4"); }
1050     r1 = a1; r2 = a2; r3 = a3; r4 = a4;
1051   }
1052 
1053   /// @notice Pause token emissions.
1054   /// @notice Mining pause does not gather reserves or burn, as lastBlockMined is reset on unpause
1055   function pauseEmissions() public onlyOwner {
1056     require(!miningPaused, "mining already paused");
1057     miningPaused = true;
1058     emit Paused(block.number);
1059   }
1060 
1061   /// @notice Unpause token emissions, 10 blocks after function call
1062   function unpauseEmissions() public onlyOwner {
1063     require(miningPaused, "mining not paused");
1064     lastBlockMined = block.number + 10; // re-enable after 10 blocks
1065     miningPaused = false;
1066     emit Unpaused(block.number + 10);
1067   }
1068 
1069   /// @notice Decrease token per block emissions
1070   /// @notice This function can only decrease emissions, not increase
1071   function decreaseEmissions(uint256 amount) public onlyOwner {
1072     require(amount >= 1 * 10**DECIMALS, "amount < one token");
1073     require(amount < amountMinedPerBlock, "amount >= current emission rate");
1074     amountMinedPerBlock = amount;
1075     emit EmissionsLowered(block.number, amount);
1076   }
1077   
1078   /// @notice Set a new AuxContract to be used for the reward mechanism in mineTo
1079   /// @param aux Contract address for new auxiliary contract
1080   function setContract(address aux) public onlyOwner {
1081     auxContract = AuxContract(aux);
1082   }
1083 }