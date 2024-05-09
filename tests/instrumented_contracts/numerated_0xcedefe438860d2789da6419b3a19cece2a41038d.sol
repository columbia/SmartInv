1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 // File: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 // File: Token.sol
144 
145 
146 
147 pragma solidity 0.8.9;
148 
149 
150 
151 contract Token is Context, IERC20Metadata {
152     mapping(address => uint256) private _balances;
153 
154     mapping(address => mapping(address => uint256)) private _allowances;
155 
156     uint256 private _totalSupply;
157 
158     string private _name;
159     string private _symbol;
160     uint8 private constant _decimals = 18;
161     uint256 public constant hardCap = 100_000_000_000 * (10**_decimals); //100 billion
162 
163     constructor(
164         string memory name_,
165         string memory symbol_,
166         address _to
167     ) {
168         require(_to != address(0), "Zero to address");
169         _name = name_;
170         _symbol = symbol_;
171         _mint(_to, hardCap);
172     }
173 
174     function name() public view virtual override returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public view virtual override returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public view virtual override returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public view virtual override returns (uint256) {
187         return _totalSupply;
188     }
189 
190     function balanceOf(address account)
191         public
192         view
193         virtual
194         override
195         returns (uint256)
196     {
197         return _balances[account];
198     }
199 
200     function transfer(address recipient, uint256 amount)
201         public
202         virtual
203         override
204         returns (bool)
205     {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     function allowance(address from, address to)
211         public
212         view
213         virtual
214         override
215         returns (uint256)
216     {
217         return _allowances[from][to];
218     }
219 
220     function approve(address to, uint256 amount)
221         public
222         virtual
223         override
224         returns (bool)
225     {
226         _approve(_msgSender(), to, amount);
227         return true;
228     }
229 
230     function transferFrom(
231         address sender,
232         address recipient,
233         uint256 amount
234     ) public virtual override returns (bool) {
235         _transfer(sender, recipient, amount);
236 
237         uint256 currentAllowance = _allowances[sender][_msgSender()];
238         require(
239             currentAllowance >= amount,
240             "ERC20: transfer amount exceeds allowance"
241         );
242         unchecked {
243             _approve(sender, _msgSender(), currentAllowance - amount);
244         }
245 
246         return true;
247     }
248 
249     function increaseAllowance(address to, uint256 addedValue)
250         public
251         virtual
252         returns (bool)
253     {
254         _approve(_msgSender(), to, _allowances[_msgSender()][to] + addedValue);
255         return true;
256     }
257 
258     function decreaseAllowance(address to, uint256 subtractedValue)
259         public
260         virtual
261         returns (bool)
262     {
263         uint256 currentAllowance = _allowances[_msgSender()][to];
264         require(
265             currentAllowance >= subtractedValue,
266             "ERC20: decreased allowance below zero"
267         );
268         unchecked {
269             _approve(_msgSender(), to, currentAllowance - subtractedValue);
270         }
271 
272         return true;
273     }
274 
275     function _transfer(
276         address sender,
277         address recipient,
278         uint256 amount
279     ) internal virtual {
280         require(sender != address(0), "ERC20: transfer from the zero address");
281         require(recipient != address(0), "ERC20: transfer to the zero address");
282 
283         uint256 senderBalance = _balances[sender];
284         require(
285             senderBalance >= amount,
286             "ERC20: transfer amount exceeds balance"
287         );
288         unchecked {
289             _balances[sender] = senderBalance - amount;
290         }
291         _balances[recipient] += amount;
292 
293         emit Transfer(sender, recipient, amount);
294     }
295 
296     function _mint(address account, uint256 amount) internal virtual {
297         require(account != address(0), "ERC20: mint to the zero address");
298 
299         _totalSupply += amount;
300         _balances[account] += amount;
301         emit Transfer(address(0), account, amount);
302     }
303 
304     function _burn(address account, uint256 amount) internal virtual {
305         require(account != address(0), "ERC20: burn from the zero address");
306 
307         uint256 accountBalance = _balances[account];
308         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
309         unchecked {
310             _balances[account] = accountBalance - amount;
311         }
312         _totalSupply -= amount;
313 
314         emit Transfer(account, address(0), amount);
315     }
316 
317     function burn(uint256 amount) external {
318         _burn(_msgSender(), amount);
319     }
320 
321     function _approve(
322         address from,
323         address to,
324         uint256 amount
325     ) internal virtual {
326         require(from != address(0), "ERC20: approve from the zero address");
327         require(to != address(0), "ERC20: approve to the zero address");
328 
329         _allowances[from][to] = amount;
330         emit Approval(from, to, amount);
331     }
332 }