1 // SPDX-License-Identifier: MIT
2 
3 //For more information on KATSUBET read here: https://linktr.ee/katsubet
4 
5 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 // File: @openzeppelin/contracts@4.6.0/token/ERC20/IERC20.sol
22 
23 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     /**
35      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
36      * a call to {approve}. `value` is the new allowance.
37      */
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     function transfer(address to, uint256 amount) external returns (bool);
51 
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     function transferFrom(
57         address from,
58         address to,
59         uint256 amount
60     ) external returns (bool);
61 }
62 
63 // File: @openzeppelin/contracts@4.6.0/token/ERC20/extensions/IERC20Metadata.sol
64 
65 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
66 
67 pragma solidity ^0.8.0;
68 
69 /**
70  * @dev Interface for the optional metadata functions from the ERC20 standard.
71  *
72  * _Available since v4.1._
73  */
74 interface IERC20Metadata is IERC20 {
75     /**
76      * @dev Returns the name of the token.
77      */
78     function name() external view returns (string memory);
79 
80     /**
81      * @dev Returns the symbol of the token.
82      */
83     function symbol() external view returns (string memory);
84 
85     /**
86      * @dev Returns the decimals places of the token.
87      */
88     function decimals() external view returns (uint8);
89 }
90 
91 // File: @openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol
92 
93 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 contract ERC20 is Context, IERC20, IERC20Metadata {
98     mapping(address => uint256) private _balances;
99 
100     mapping(address => mapping(address => uint256)) private _allowances;
101 
102     uint256 private _totalSupply;
103 
104     string private _name;
105     string private _symbol;
106 
107     constructor(string memory name_, string memory symbol_) {
108         _name = name_;
109         _symbol = symbol_;
110     }
111 
112     /**
113      * @dev Returns the name of the token.
114      */
115     function name() public view virtual override returns (string memory) {
116         return _name;
117     }
118 
119     /**
120      * @dev Returns the symbol of the token, usually a shorter version of the
121      * name.
122      */
123     function symbol() public view virtual override returns (string memory) {
124         return _symbol;
125     }
126 
127     function decimals() public view virtual override returns (uint8) {
128         return 18;
129     }
130 
131     /**
132      * @dev See {IERC20-totalSupply}.
133      */
134     function totalSupply() public view virtual override returns (uint256) {
135         return _totalSupply;
136     }
137 
138     /**
139      * @dev See {IERC20-balanceOf}.
140      */
141     function balanceOf(address account) public view virtual override returns (uint256) {
142         return _balances[account];
143     }
144 
145     function transfer(address to, uint256 amount) public virtual override returns (bool) {
146         address owner = _msgSender();
147         _transfer(owner, to, amount);
148         return true;
149     }
150 
151     /**
152      * @dev See {IERC20-allowance}.
153      */
154     function allowance(address owner, address spender) public view virtual override returns (uint256) {
155         return _allowances[owner][spender];
156     }
157 
158     function approve(address spender, uint256 amount) public virtual override returns (bool) {
159         address owner = _msgSender();
160         _approve(owner, spender, amount);
161         return true;
162     }
163 
164     function transferFrom(
165         address from,
166         address to,
167         uint256 amount
168     ) public virtual override returns (bool) {
169         address spender = _msgSender();
170         _spendAllowance(from, spender, amount);
171         _transfer(from, to, amount);
172         return true;
173     }
174 
175     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
176         address owner = _msgSender();
177         _approve(owner, spender, allowance(owner, spender) + addedValue);
178         return true;
179     }
180 
181     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
182         address owner = _msgSender();
183         uint256 currentAllowance = allowance(owner, spender);
184         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
185         unchecked {
186             _approve(owner, spender, currentAllowance - subtractedValue);
187         }
188 
189         return true;
190     }
191 
192     function _transfer(
193         address from,
194         address to,
195         uint256 amount
196     ) internal virtual {
197         require(from != address(0), "ERC20: transfer from the zero address");
198         require(to != address(0), "ERC20: transfer to the zero address");
199 
200         _beforeTokenTransfer(from, to, amount);
201 
202         uint256 fromBalance = _balances[from];
203         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
204         unchecked {
205             _balances[from] = fromBalance - amount;
206         }
207         _balances[to] += amount;
208 
209         emit Transfer(from, to, amount);
210 
211         _afterTokenTransfer(from, to, amount);
212     }
213 
214     function _mint(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: mint to the zero address");
216 
217         _beforeTokenTransfer(address(0), account, amount);
218 
219         _totalSupply += amount;
220         _balances[account] += amount;
221         emit Transfer(address(0), account, amount);
222 
223         _afterTokenTransfer(address(0), account, amount);
224     }
225 
226     function _burn(address account, uint256 amount) internal virtual {
227         require(account != address(0), "ERC20: burn from the zero address");
228 
229         _beforeTokenTransfer(account, address(0), amount);
230 
231         uint256 accountBalance = _balances[account];
232         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
233         unchecked {
234             _balances[account] = accountBalance - amount;
235         }
236         _totalSupply -= amount;
237 
238         emit Transfer(account, address(0), amount);
239 
240         _afterTokenTransfer(account, address(0), amount);
241     }
242 
243     function _approve(
244         address owner,
245         address spender,
246         uint256 amount
247     ) internal virtual {
248         require(owner != address(0), "ERC20: approve from the zero address");
249         require(spender != address(0), "ERC20: approve to the zero address");
250 
251         _allowances[owner][spender] = amount;
252         emit Approval(owner, spender, amount);
253     }
254 
255     function _spendAllowance(
256         address owner,
257         address spender,
258         uint256 amount
259     ) internal virtual {
260         uint256 currentAllowance = allowance(owner, spender);
261         if (currentAllowance != type(uint256).max) {
262             require(currentAllowance >= amount, "ERC20: insufficient allowance");
263             unchecked {
264                 _approve(owner, spender, currentAllowance - amount);
265             }
266         }
267     }
268 
269     function _beforeTokenTransfer(
270         address from,
271         address to,
272         uint256 amount
273     ) internal virtual {}
274 
275     function _afterTokenTransfer(
276         address from,
277         address to,
278         uint256 amount
279     ) internal virtual {}
280 }
281 
282 // File: KATSU.sol
283 
284 pragma solidity ^0.8.4;
285 
286 contract KATSU is ERC20 {
287     constructor() ERC20("KATSU", "KATSU") {
288         _mint(msg.sender, 1000000000 * 10 ** decimals());
289     }
290 }