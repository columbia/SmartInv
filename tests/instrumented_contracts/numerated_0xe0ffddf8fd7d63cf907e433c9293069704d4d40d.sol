1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
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
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30  
31 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Emitted when `value` tokens are moved from one account (`from`) to
41      * another (`to`).
42      *
43      * Note that `value` may be zero.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     /**
48      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
49      * a call to {approve}. `value` is the new allowance.
50      */
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 
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
64      * @dev Moves `amount` tokens from the caller's account to `to`.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transfer(address to, uint256 amount) external returns (bool);
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
98      * @dev Moves `amount` tokens from `from` to `to` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 amount
110     ) external returns (bool);
111 }
112 
113 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
114 
115  
116 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface for the optional metadata functions from the ERC20 standard.
122  *
123  * _Available since v4.1._
124  */
125 interface IERC20Metadata is IERC20 {
126     /**
127      * @dev Returns the name of the token.
128      */
129     function name() external view returns (string memory);
130 
131     /**
132      * @dev Returns the symbol of the token.
133      */
134     function symbol() external view returns (string memory);
135 
136     /**
137      * @dev Returns the decimals places of the token.
138      */
139     function decimals() external view returns (uint8);
140 }
141 
142 // File: contracts/Token.sol
143 
144  
145 
146 pragma solidity 0.8.9;
147 
148 
149 contract Token is Context, IERC20Metadata {
150     mapping(address => uint256) private _balances;
151 
152     mapping(address => mapping(address => uint256)) private _allowances;
153 
154     uint256 private _totalSupply;
155 
156     string private _name;
157     string private _symbol;
158     uint8 private constant _decimals = 18;
159     uint256 public constant hardCap = 10_000_000_000 * (10**_decimals); //10 billion
160 
161     constructor(
162         string memory name_,
163         string memory symbol_,
164         address _to
165     ) {
166         require(_to != address(0), "Zero to address");
167         _name = name_;
168         _symbol = symbol_;
169         _mint(_to, hardCap);
170     }
171 
172     function name() public view virtual override returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public view virtual override returns (string memory) {
177         return _symbol;
178     }
179 
180     function decimals() public view virtual override returns (uint8) {
181         return _decimals;
182     }
183 
184     function totalSupply() public view virtual override returns (uint256) {
185         return _totalSupply;
186     }
187 
188     function balanceOf(address account)
189         public
190         view
191         virtual
192         override
193         returns (uint256)
194     {
195         return _balances[account];
196     }
197 
198     function transfer(address recipient, uint256 amount)
199         public
200         virtual
201         override
202         returns (bool)
203     {
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     function allowance(address from, address to)
209         public
210         view
211         virtual
212         override
213         returns (uint256)
214     {
215         return _allowances[from][to];
216     }
217 
218     function approve(address to, uint256 amount)
219         public
220         virtual
221         override
222         returns (bool)
223     {
224         _approve(_msgSender(), to, amount);
225         return true;
226     }
227 
228     function transferFrom(
229         address sender,
230         address recipient,
231         uint256 amount
232     ) public virtual override returns (bool) {
233         _transfer(sender, recipient, amount);
234 
235         uint256 currentAllowance = _allowances[sender][_msgSender()];
236         require(
237             currentAllowance >= amount,
238             "ERC20: transfer amount exceeds allowance"
239         );
240         unchecked {
241             _approve(sender, _msgSender(), currentAllowance - amount);
242         }
243 
244         return true;
245     }
246 
247     function increaseAllowance(address to, uint256 addedValue)
248         public
249         virtual
250         returns (bool)
251     {
252         _approve(_msgSender(), to, _allowances[_msgSender()][to] + addedValue);
253         return true;
254     }
255 
256     function decreaseAllowance(address to, uint256 subtractedValue)
257         public
258         virtual
259         returns (bool)
260     {
261         uint256 currentAllowance = _allowances[_msgSender()][to];
262         require(
263             currentAllowance >= subtractedValue,
264             "ERC20: decreased allowance below zero"
265         );
266         unchecked {
267             _approve(_msgSender(), to, currentAllowance - subtractedValue);
268         }
269 
270         return true;
271     }
272 
273     function _transfer(
274         address sender,
275         address recipient,
276         uint256 amount
277     ) internal virtual {
278         require(sender != address(0), "ERC20: transfer from the zero address");
279         require(recipient != address(0), "ERC20: transfer to the zero address");
280         require(amount > 0, "ERC20: zero transfer amount");
281 
282         uint256 senderBalance = _balances[sender];
283         require(
284             senderBalance >= amount,
285             "ERC20: transfer amount exceeds balance"
286         );
287         unchecked {
288             _balances[sender] = senderBalance - amount;
289         }
290         _balances[recipient] += amount;
291 
292         emit Transfer(sender, recipient, amount);
293     }
294 
295     function _mint(address account, uint256 amount) internal virtual {
296         require(account != address(0), "ERC20: mint to the zero address");
297 
298         _totalSupply += amount;
299         _balances[account] += amount;
300         emit Transfer(address(0), account, amount);
301     }
302 
303     function _burn(address account, uint256 amount) internal virtual {
304         require(account != address(0), "ERC20: burn from the zero address");
305 
306         uint256 accountBalance = _balances[account];
307         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
308         unchecked {
309             _balances[account] = accountBalance - amount;
310         }
311         _totalSupply -= amount;
312 
313         emit Transfer(account, address(0), amount);
314     }
315 
316     function burn(uint256 amount) external {
317         _burn(_msgSender(), amount);
318     }
319 
320     function _approve(
321         address from,
322         address to,
323         uint256 amount
324     ) internal virtual {
325         require(from != address(0), "ERC20: approve from the zero address");
326         require(to != address(0), "ERC20: approve to the zero address");
327 
328         _allowances[from][to] = amount;
329         emit Approval(from, to, amount);
330     }
331 }