1 /**
2 
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⣤⣤⣴⣦⣤⣤⣤⣤⣤⣄⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⣤⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⢀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠉⠉⠁⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⢸⣿⣿⣿⣿⡿⠛⠛⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠘⢻⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⣿⡟⠀⠀⠀⣀⠀⠀⠀⡐⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⣿⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⣿⡇⢀⠄⠉⣀⡀⢉⠁⣠⣶⣶⣶⣶⣤⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⡿⢁⠔⠀⠀⠪⢂⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠹⡇⢀⣴⣿⡿⢀⠀⠀⠉⠛⠛⠛⠿⣿⣿⣿⣿⣿⣿⣦⠀⡀⠀⠀⠀⠀⠀⢹⣿⣿⣿⡿⠋⠀⠁⠀⠀⠀⠀⢻⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⢀⣼⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⢉⠡⢀⡀⠀⠀⠀⠀⠀⠸⣿⣿⡟⠀⠀⠀⠐⠂⠀⠀⡠⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⣾⣿⡿⠛⠐⠂⠤⡐⠄⠀⢠⠀⠀⠊⠶⠛⠛⠛⠊⠥⠄⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠇⢸⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⢹⡏⠀⣀⣴⠶⠶⢾⠰⠀⠀⠀⠀⠀⠠⠤⠄⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠘⠊⢸⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠣⡞⢟⠁⢀⠠⢘⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠁⠀⠀⢀⠆⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⡹⠂⠀⠀⡐⠁⠆⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⠃⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⢠⠁⠀⠀⡌⠀⡘⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠈⠀⠀⢰⠀⢈⢃⡀⠀⢠⠐⠀⠀⠀⠁⠀⠀⠀⠀⠑⠄⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⣼⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠘⡀⠀⠀⠄⠀⠉⠁⠀⠀⠀⠀⣀⠠⠄⢀⣀⣤⣀⠀⠈⡄⡄⠀⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠐⡄⠀⡀⠀⢀⠤⠒⣈⣩⡤⢶⠞⠟⢙⠉⡋⣛⣿⡆⠀⡇⠀⡈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠈⢄⠐⢄⠠⣿⣿⡋⡁⢁⣀⣤⣷⣾⣿⣿⣿⢿⠃⠀⡇⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠈⠢⡀⠑⡜⢜⠻⣿⣿⡿⢻⣻⠹⠕⠋⢁⠊⠀⠀⠇⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⠈⢄⠢⢀⣉⡁⠁⠀⠤⠐⠊⠀⠀⠀⠠⠰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠂⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
27 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⡈⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠔⢁⠁⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠀⠀⠀⠠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
28 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⠀⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀
29 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⢀⠀⠀⠀⠀⠀⠀⠀
30 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢄⠀⠀⠀⠀⠀⢀⠠⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡄⠱⡀⠀⠀⠀⠀⠀
31 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠫⡁⠒⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡄⠈⠐⠠⡀⠀⠀
32 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠀⠀⢡⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡅⠀⠀⠀⠈⠰⡀
33 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠀⠀⠀⠀⠡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀
35                        no yin , no yang , we yao 
36     Join Us !!
37 -- https://www.yaoming.io/
38 -- https://t.me/yaomingportal
39 */
40 
41 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
42 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
43 // SPDX-License-Identifier: MIT
44 /**
45  * @dev Provides information about the current execution context, including the
46  * sender of the transaction and its data. While these are generally available
47  * via msg.sender and msg.data, they should not be accessed in such a direct
48  * manner, since when dealing with meta-transactions the account sending and
49  * paying for execution may not be the actual sender (as far as an application
50  * is concerned).
51  *
52  * This contract is only required for intermediate, library-like contracts.
53  */
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes calldata) {
60         return msg.data;
61     }
62 }
63 
64 /**
65  * @dev Contract module which provides a basic access control mechanism, where
66  * there is an account (an owner) that can be granted exclusive access to
67  * specific functions.
68  *
69  * By default, the owner account will be the one that deploys the contract. This
70  * can later be changed with {transferOwnership}.
71  *
72  * This module is used through inheritance. It will make available the modifier
73  * `onlyOwner`, which can be applied to your functions to restrict their use to
74  * the owner.
75  */
76 abstract contract Ownable is Context {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     /**
82      * @dev Initializes the contract setting the deployer as the initial owner.
83      */
84     constructor() {
85         _transferOwnership(_msgSender());
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         _checkOwner();
93         _;
94     }
95 
96     /**
97      * @dev Returns the address of the current owner.
98      */
99     function owner() public view virtual returns (address) {
100         return _owner;
101     }
102 
103     /**
104      * @dev Throws if the sender is not the owner.
105      */
106     function _checkOwner() internal view virtual {
107         require(owner() == _msgSender(), "Ownable: caller is not the owner");
108     }
109 
110     /**
111      * @dev Leaves the contract without owner. It will not be possible to call
112      * `onlyOwner` functions anymore. Can only be called by the current owner.
113      *
114      * NOTE: Renouncing ownership will leave the contract without an owner,
115      * thereby removing any functionality that is only available to the owner.
116      */
117     function renounceOwnership() public virtual onlyOwner {
118         _transferOwnership(address(0));
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Can only be called by the current owner.
124      */
125     function transferOwnership(address newOwner) public virtual onlyOwner {
126         require(newOwner != address(0), "Ownable: new owner is the zero address");
127         _transferOwnership(newOwner);
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Internal function without access restriction.
133      */
134     function _transferOwnership(address newOwner) internal virtual {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 
141 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
142 
143 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
144 
145 /**
146  * @dev Interface of the ERC20 standard as defined in the EIP.
147  */
148 interface IERC20 {
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 
163     /**
164      * @dev Returns the amount of tokens in existence.
165      */
166     function totalSupply() external view returns (uint256);
167 
168     /**
169      * @dev Returns the amount of tokens owned by `account`.
170      */
171     function balanceOf(address account) external view returns (uint256);
172 
173     /**
174      * @dev Moves `amount` tokens from the caller's account to `to`.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transfer(address to, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Returns the remaining number of tokens that `spender` will be
184      * allowed to spend on behalf of `owner` through {transferFrom}. This is
185      * zero by default.
186      *
187      * This value changes when {approve} or {transferFrom} are called.
188      */
189     function allowance(address owner, address spender) external view returns (uint256);
190 
191     /**
192      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * IMPORTANT: Beware that changing an allowance with this method brings the risk
197      * that someone may use both the old and the new allowance by unfortunate
198      * transaction ordering. One possible solution to mitigate this race
199      * condition is to first reduce the spender's allowance to 0 and set the
200      * desired value afterwards:
201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address spender, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Moves `amount` tokens from `from` to `to` using the
209      * allowance mechanism. `amount` is then deducted from the caller's
210      * allowance.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(
217         address from,
218         address to,
219         uint256 amount
220     ) external returns (bool);
221 }
222 
223 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
224 
225 /**
226  * @dev Interface for the optional metadata functions from the ERC20 standard.
227  *
228  * _Available since v4.1._
229  */
230 interface IERC20Metadata is IERC20 {
231     /**
232      * @dev Returns the name of the token.
233      */
234     function name() external view returns (string memory);
235 
236     /**
237      * @dev Returns the symbol of the token.
238      */
239     function symbol() external view returns (string memory);
240 
241     /**
242      * @dev Returns the decimals places of the token.
243      */
244     function decimals() external view returns (uint8);
245 }
246 
247 /**
248  * @dev Implementation of the {IERC20} interface.
249  *
250  * This implementation is agnostic to the way tokens are created. This means
251  * that a supply mechanism has to be added in a derived contract using {_mint}.
252  * For a generic mechanism see {ERC20PresetMinterPauser}.
253  *
254  * TIP: For a detailed writeup see our guide
255  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
256  * to implement supply mechanisms].
257  *
258  * We have followed general OpenZeppelin Contracts guidelines: functions revert
259  * instead returning `false` on failure. This behavior is nonetheless
260  * conventional and does not conflict with the expectations of ERC20
261  * applications.
262  *
263  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
264  * This allows applications to reconstruct the allowance for all accounts just
265  * by listening to said events. Other implementations of the EIP may not emit
266  * these events, as it isn't required by the specification.
267  *
268  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
269  * functions have been added to mitigate the well-known issues around setting
270  * allowances. See {IERC20-approve}.
271  */
272 contract ERC20 is Context, IERC20, IERC20Metadata {
273     mapping(address => uint256) private _balances;
274 
275     mapping(address => mapping(address => uint256)) private _allowances;
276 
277     uint256 private _totalSupply;
278 
279     string private _name;
280     string private _symbol;
281 
282     /**
283      * @dev Sets the values for {name} and {symbol}.
284      *
285      * The default value of {decimals} is 18. To select a different value for
286      * {decimals} you should overload it.
287      *
288      * All two of these values are immutable: they can only be set once during
289      * construction.
290      */
291     constructor(string memory name_, string memory symbol_) {
292         _name = name_;
293         _symbol = symbol_;
294     }
295 
296     /**
297      * @dev Returns the name of the token.
298      */
299     function name() public view virtual override returns (string memory) {
300         return _name;
301     }
302 
303     /**
304      * @dev Returns the symbol of the token, usually a shorter version of the
305      * name.
306      */
307     function symbol() public view virtual override returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @dev Returns the number of decimals used to get its user representation.
313      * For example, if `decimals` equals `2`, a balance of `505` tokens should
314      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
315      *
316      * Tokens usually opt for a value of 18, imitating the relationship between
317      * Ether and Wei. This is the value {ERC20} uses, unless this function is
318      * overridden;
319      *
320      * NOTE: This information is only used for _display_ purposes: it in
321      * no way affects any of the arithmetic of the contract, including
322      * {IERC20-balanceOf} and {IERC20-transfer}.
323      */
324     function decimals() public view virtual override returns (uint8) {
325         return 18;
326     }
327 
328     /**
329      * @dev See {IERC20-totalSupply}.
330      */
331     function totalSupply() public view virtual override returns (uint256) {
332         return _totalSupply;
333     }
334 
335     /**
336      * @dev See {IERC20-balanceOf}.
337      */
338     function balanceOf(address account) public view virtual override returns (uint256) {
339         return _balances[account];
340     }
341 
342     /**
343      * @dev See {IERC20-transfer}.
344      *
345      * Requirements:
346      *
347      * - `to` cannot be the zero address.
348      * - the caller must have a balance of at least `amount`.
349      */
350     function transfer(address to, uint256 amount) public virtual override returns (bool) {
351         address owner = _msgSender();
352         _transfer(owner, to, amount);
353         return true;
354     }
355 
356     /**
357      * @dev See {IERC20-allowance}.
358      */
359     function allowance(address owner, address spender) public view virtual override returns (uint256) {
360         return _allowances[owner][spender];
361     }
362 
363     /**
364      * @dev See {IERC20-approve}.
365      *
366      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
367      * `transferFrom`. This is semantically equivalent to an infinite approval.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function approve(address spender, uint256 amount) public virtual override returns (bool) {
374         address owner = _msgSender();
375         _approve(owner, spender, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-transferFrom}.
381      *
382      * Emits an {Approval} event indicating the updated allowance. This is not
383      * required by the EIP. See the note at the beginning of {ERC20}.
384      *
385      * NOTE: Does not update the allowance if the current allowance
386      * is the maximum `uint256`.
387      *
388      * Requirements:
389      *
390      * - `from` and `to` cannot be the zero address.
391      * - `from` must have a balance of at least `amount`.
392      * - the caller must have allowance for ``from``'s tokens of at least
393      * `amount`.
394      */
395     function transferFrom(
396         address from,
397         address to,
398         uint256 amount
399     ) public virtual override returns (bool) {
400         address spender = _msgSender();
401         _spendAllowance(from, spender, amount);
402         _transfer(from, to, amount);
403         return true;
404     }
405 
406     /**
407      * @dev Atomically increases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      */
418     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
419         address owner = _msgSender();
420         _approve(owner, spender, allowance(owner, spender) + addedValue);
421         return true;
422     }
423 
424     /**
425      * @dev Atomically decreases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      * - `spender` must have allowance for the caller of at least
436      * `subtractedValue`.
437      */
438     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
439         address owner = _msgSender();
440         uint256 currentAllowance = allowance(owner, spender);
441         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
442         unchecked {
443             _approve(owner, spender, currentAllowance - subtractedValue);
444         }
445 
446         return true;
447     }
448 
449     /**
450      * @dev Moves `amount` of tokens from `from` to `to`.
451      *
452      * This internal function is equivalent to {transfer}, and can be used to
453      * e.g. implement automatic token fees, slashing mechanisms, etc.
454      *
455      * Emits a {Transfer} event.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `from` must have a balance of at least `amount`.
462      */
463     function _transfer(
464         address from,
465         address to,
466         uint256 amount
467     ) internal virtual {
468         require(from != address(0), "ERC20: transfer from the zero address");
469         require(to != address(0), "ERC20: transfer to the zero address");
470 
471         _beforeTokenTransfer(from, to, amount);
472 
473         uint256 fromBalance = _balances[from];
474         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
475         unchecked {
476             _balances[from] = fromBalance - amount;
477             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
478             // decrementing then incrementing.
479             _balances[to] += amount;
480         }
481 
482         emit Transfer(from, to, amount);
483 
484         _afterTokenTransfer(from, to, amount);
485     }
486 
487     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
488      * the total supply.
489      *
490      * Emits a {Transfer} event with `from` set to the zero address.
491      *
492      * Requirements:
493      *
494      * - `account` cannot be the zero address.
495      */
496     function _mint(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: mint to the zero address");
498 
499         _beforeTokenTransfer(address(0), account, amount);
500 
501         _totalSupply += amount;
502         unchecked {
503             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
504             _balances[account] += amount;
505         }
506         emit Transfer(address(0), account, amount);
507 
508         _afterTokenTransfer(address(0), account, amount);
509     }
510 
511     /**
512      * @dev Destroys `amount` tokens from `account`, reducing the
513      * total supply.
514      *
515      * Emits a {Transfer} event with `to` set to the zero address.
516      *
517      * Requirements:
518      *
519      * - `account` cannot be the zero address.
520      * - `account` must have at least `amount` tokens.
521      */
522     function _burn(address account, uint256 amount) internal virtual {
523         require(account != address(0), "ERC20: burn from the zero address");
524 
525         _beforeTokenTransfer(account, address(0), amount);
526 
527         uint256 accountBalance = _balances[account];
528         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
529         unchecked {
530             _balances[account] = accountBalance - amount;
531             // Overflow not possible: amount <= accountBalance <= totalSupply.
532             _totalSupply -= amount;
533         }
534 
535         emit Transfer(account, address(0), amount);
536 
537         _afterTokenTransfer(account, address(0), amount);
538     }
539 
540     /**
541      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
542      *
543      * This internal function is equivalent to `approve`, and can be used to
544      * e.g. set automatic allowances for certain subsystems, etc.
545      *
546      * Emits an {Approval} event.
547      *
548      * Requirements:
549      *
550      * - `owner` cannot be the zero address.
551      * - `spender` cannot be the zero address.
552      */
553     function _approve(
554         address owner,
555         address spender,
556         uint256 amount
557     ) internal virtual {
558         require(owner != address(0), "ERC20: approve from the zero address");
559         require(spender != address(0), "ERC20: approve to the zero address");
560 
561         _allowances[owner][spender] = amount;
562         emit Approval(owner, spender, amount);
563     }
564 
565     /**
566      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
567      *
568      * Does not update the allowance amount in case of infinite allowance.
569      * Revert if not enough allowance is available.
570      *
571      * Might emit an {Approval} event.
572      */
573     function _spendAllowance(
574         address owner,
575         address spender,
576         uint256 amount
577     ) internal virtual {
578         uint256 currentAllowance = allowance(owner, spender);
579         if (currentAllowance != type(uint256).max) {
580             require(currentAllowance >= amount, "ERC20: insufficient allowance");
581             unchecked {
582                 _approve(owner, spender, currentAllowance - amount);
583             }
584         }
585     }
586 
587     /**
588      * @dev Hook that is called before any transfer of tokens. This includes
589      * minting and burning.
590      *
591      * Calling conditions:
592      *
593      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
594      * will be transferred to `to`.
595      * - when `from` is zero, `amount` tokens will be minted for `to`.
596      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
597      * - `from` and `to` are never both zero.
598      *
599      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
600      */
601     function _beforeTokenTransfer(
602         address from,
603         address to,
604         uint256 amount
605     ) internal virtual {}
606 
607     /**
608      * @dev Hook that is called after any transfer of tokens. This includes
609      * minting and burning.
610      *
611      * Calling conditions:
612      *
613      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
614      * has been transferred to `to`.
615      * - when `from` is zero, `amount` tokens have been minted for `to`.
616      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
617      * - `from` and `to` are never both zero.
618      *
619      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
620      */
621     function _afterTokenTransfer(
622         address from,
623         address to,
624         uint256 amount
625     ) internal virtual {}
626 }
627 
628 pragma solidity ^0.8.0;
629 
630 contract YaoMing is Ownable, ERC20 {
631     constructor(uint256 _totalSupply) ERC20("YaoMing", "YAO") {
632         _mint(msg.sender, _totalSupply);
633     }
634 
635     function burn(uint256 value) external {
636         _burn(msg.sender, value);
637     }
638 
639     receive() external payable {
640         revert();
641     }
642 
643     fallback() external {
644         revert();
645     }
646 }