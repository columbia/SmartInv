1 // SPDX-License-Identifier: MIT
2 
3 /*
4 The meek shall inherit the earth.
5 https://twitter.com/FinanceVendetta
6 */
7 
8 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 // File: @openzeppelin/contracts@4.6.0/token/ERC20/IERC20.sol
26 
27 
28 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     /**
40      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
41      * a call to {approve}. `value` is the new allowance.
42      */
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     function transfer(address to, uint256 amount) external returns (bool);
56 
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     function transferFrom(
62         address from,
63         address to,
64         uint256 amount
65     ) external returns (bool);
66 }
67 
68 // File: @openzeppelin/contracts@4.6.0/token/ERC20/extensions/IERC20Metadata.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 
76 /**
77  * @dev Interface for the optional metadata functions from the ERC20 standard.
78  *
79  * _Available since v4.1._
80  */
81 interface IERC20Metadata is IERC20 {
82     /**
83      * @dev Returns the name of the token.
84      */
85     function name() external view returns (string memory);
86 
87     /**
88      * @dev Returns the symbol of the token.
89      */
90     function symbol() external view returns (string memory);
91 
92     /**
93      * @dev Returns the decimals places of the token.
94      */
95     function decimals() external view returns (uint8);
96 }
97 
98 // File: @openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol
99 
100 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 
105 contract ERC20 is Context, IERC20, IERC20Metadata {
106     mapping(address => uint256) private _balances;
107 
108     mapping(address => mapping(address => uint256)) private _allowances;
109 
110     uint256 private _totalSupply;
111 
112     string private _name;
113     string private _symbol;
114 
115     constructor(string memory name_, string memory symbol_) {
116         _name = name_;
117         _symbol = symbol_;
118     }
119 
120     /**
121      * @dev Returns the name of the token.
122      */
123     function name() public view virtual override returns (string memory) {
124         return _name;
125     }
126 
127     /**
128      * @dev Returns the symbol of the token, usually a shorter version of the
129      * name.
130      */
131     function symbol() public view virtual override returns (string memory) {
132         return _symbol;
133     }
134 
135     function decimals() public view virtual override returns (uint8) {
136         return 18;
137     }
138 
139     /**
140      * @dev See {IERC20-totalSupply}.
141      */
142     function totalSupply() public view virtual override returns (uint256) {
143         return _totalSupply;
144     }
145 
146     /**
147      * @dev See {IERC20-balanceOf}.
148      */
149     function balanceOf(address account) public view virtual override returns (uint256) {
150         return _balances[account];
151     }
152 
153     function transfer(address to, uint256 amount) public virtual override returns (bool) {
154         address owner = _msgSender();
155         _transfer(owner, to, amount);
156         return true;
157     }
158 
159     /**
160      * @dev See {IERC20-allowance}.
161      */
162     function allowance(address owner, address spender) public view virtual override returns (uint256) {
163         return _allowances[owner][spender];
164     }
165 
166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
167         address owner = _msgSender();
168         _approve(owner, spender, amount);
169         return true;
170     }
171 
172     function transferFrom(
173         address from,
174         address to,
175         uint256 amount
176     ) public virtual override returns (bool) {
177         address spender = _msgSender();
178         _spendAllowance(from, spender, amount);
179         _transfer(from, to, amount);
180         return true;
181     }
182 
183     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
184         address owner = _msgSender();
185         _approve(owner, spender, allowance(owner, spender) + addedValue);
186         return true;
187     }
188 
189     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
190         address owner = _msgSender();
191         uint256 currentAllowance = allowance(owner, spender);
192         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
193         unchecked {
194             _approve(owner, spender, currentAllowance - subtractedValue);
195         }
196 
197         return true;
198     }
199 
200     function _transfer(
201         address from,
202         address to,
203         uint256 amount
204     ) internal virtual {
205         require(from != address(0), "ERC20: transfer from the zero address");
206         require(to != address(0), "ERC20: transfer to the zero address");
207 
208         _beforeTokenTransfer(from, to, amount);
209 
210         uint256 fromBalance = _balances[from];
211         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
212         unchecked {
213             _balances[from] = fromBalance - amount;
214         }
215         _balances[to] += amount;
216 
217         emit Transfer(from, to, amount);
218 
219         _afterTokenTransfer(from, to, amount);
220     }
221 
222     function _mint(address account, uint256 amount) internal virtual {
223         require(account != address(0), "ERC20: mint to the zero address");
224 
225         _beforeTokenTransfer(address(0), account, amount);
226 
227         _totalSupply += amount;
228         _balances[account] += amount;
229         emit Transfer(address(0), account, amount);
230 
231         _afterTokenTransfer(address(0), account, amount);
232     }
233 
234     function _burn(address account, uint256 amount) internal virtual {
235         require(account != address(0), "ERC20: burn from the zero address");
236 
237         _beforeTokenTransfer(account, address(0), amount);
238 
239         uint256 accountBalance = _balances[account];
240         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
241         unchecked {
242             _balances[account] = accountBalance - amount;
243         }
244         _totalSupply -= amount;
245 
246         emit Transfer(account, address(0), amount);
247 
248         _afterTokenTransfer(account, address(0), amount);
249     }
250 
251     function _approve(
252         address owner,
253         address spender,
254         uint256 amount
255     ) internal virtual {
256         require(owner != address(0), "ERC20: approve from the zero address");
257         require(spender != address(0), "ERC20: approve to the zero address");
258 
259         _allowances[owner][spender] = amount;
260         emit Approval(owner, spender, amount);
261     }
262 
263     function _spendAllowance(
264         address owner,
265         address spender,
266         uint256 amount
267     ) internal virtual {
268         uint256 currentAllowance = allowance(owner, spender);
269         if (currentAllowance != type(uint256).max) {
270             require(currentAllowance >= amount, "ERC20: insufficient allowance");
271             unchecked {
272                 _approve(owner, spender, currentAllowance - amount);
273             }
274         }
275     }
276 
277     function _beforeTokenTransfer(
278         address from,
279         address to,
280         uint256 amount
281     ) internal virtual {}
282 
283     function _afterTokenTransfer(
284         address from,
285         address to,
286         uint256 amount
287     ) internal virtual {}
288 }
289 
290 // File: Vendetta.sol
291 
292 
293 pragma solidity ^0.8.4;
294 
295 
296 contract VENDETTA is ERC20 {
297     constructor() ERC20("VEN", "VENDETTA") {
298         _mint(msg.sender, 111222333 * 10 ** decimals());
299     }
300 }