1 // SPDX-License-Identifier: MIT
2 
3 /*
4 I come from simpler times. When frens would buy tokens and send them to frens. 
5 Because that's what we do. It didnt matter win or lose, moon or rug, pump or dump, we won and lost together.
6 I can save you the time hunting for medium articles and tell you that there is nothing there. 
7 Save the effort of searching on twitter because there is no official account or Dev
8 Do not waste effort looking for etherscan hops because all you will find is for years I have been an ordinary trader.
9 Just as you.
10 I have traded the same tokens you have, been part of many big wins with you, endured many losses with you and still do.
11 As time wore on I found many sources of delight and despair, many exalted peaks climbed and troughs endured. 
12 I come from simpler times. When frens would buy tokens and send them to frens. 
13 The calculation is pi, the feature set is Densetsu, the OG, is you. 
14 */
15 
16 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
17 
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 // File: @openzeppelin/contracts@4.6.0/token/ERC20/IERC20.sol
34 
35 
36 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44 
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
63     function transfer(address to, uint256 amount) external returns (bool);
64 
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     function transferFrom(
70         address from,
71         address to,
72         uint256 amount
73     ) external returns (bool);
74 }
75 
76 // File: @openzeppelin/contracts@4.6.0/token/ERC20/extensions/IERC20Metadata.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 
84 /**
85  * @dev Interface for the optional metadata functions from the ERC20 standard.
86  *
87  * _Available since v4.1._
88  */
89 interface IERC20Metadata is IERC20 {
90     /**
91      * @dev Returns the name of the token.
92      */
93     function name() external view returns (string memory);
94 
95     /**
96      * @dev Returns the symbol of the token.
97      */
98     function symbol() external view returns (string memory);
99 
100     /**
101      * @dev Returns the decimals places of the token.
102      */
103     function decimals() external view returns (uint8);
104 }
105 
106 // File: @openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol
107 
108 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 
113 contract ERC20 is Context, IERC20, IERC20Metadata {
114     mapping(address => uint256) private _balances;
115 
116     mapping(address => mapping(address => uint256)) private _allowances;
117 
118     uint256 private _totalSupply;
119 
120     string private _name;
121     string private _symbol;
122 
123     constructor(string memory name_, string memory symbol_) {
124         _name = name_;
125         _symbol = symbol_;
126     }
127 
128     /**
129      * @dev Returns the name of the token.
130      */
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     /**
136      * @dev Returns the symbol of the token, usually a shorter version of the
137      * name.
138      */
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142 
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146 
147     /**
148      * @dev See {IERC20-totalSupply}.
149      */
150     function totalSupply() public view virtual override returns (uint256) {
151         return _totalSupply;
152     }
153 
154     /**
155      * @dev See {IERC20-balanceOf}.
156      */
157     function balanceOf(address account) public view virtual override returns (uint256) {
158         return _balances[account];
159     }
160 
161     function transfer(address to, uint256 amount) public virtual override returns (bool) {
162         address owner = _msgSender();
163         _transfer(owner, to, amount);
164         return true;
165     }
166 
167     /**
168      * @dev See {IERC20-allowance}.
169      */
170     function allowance(address owner, address spender) public view virtual override returns (uint256) {
171         return _allowances[owner][spender];
172     }
173 
174     function approve(address spender, uint256 amount) public virtual override returns (bool) {
175         address owner = _msgSender();
176         _approve(owner, spender, amount);
177         return true;
178     }
179 
180     function transferFrom(
181         address from,
182         address to,
183         uint256 amount
184     ) public virtual override returns (bool) {
185         address spender = _msgSender();
186         _spendAllowance(from, spender, amount);
187         _transfer(from, to, amount);
188         return true;
189     }
190 
191     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
192         address owner = _msgSender();
193         _approve(owner, spender, allowance(owner, spender) + addedValue);
194         return true;
195     }
196 
197     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
198         address owner = _msgSender();
199         uint256 currentAllowance = allowance(owner, spender);
200         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
201         unchecked {
202             _approve(owner, spender, currentAllowance - subtractedValue);
203         }
204 
205         return true;
206     }
207 
208     function _transfer(
209         address from,
210         address to,
211         uint256 amount
212     ) internal virtual {
213         require(from != address(0), "ERC20: transfer from the zero address");
214         require(to != address(0), "ERC20: transfer to the zero address");
215 
216         _beforeTokenTransfer(from, to, amount);
217 
218         uint256 fromBalance = _balances[from];
219         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
220         unchecked {
221             _balances[from] = fromBalance - amount;
222         }
223         _balances[to] += amount;
224 
225         emit Transfer(from, to, amount);
226 
227         _afterTokenTransfer(from, to, amount);
228     }
229 
230     function _mint(address account, uint256 amount) internal virtual {
231         require(account != address(0), "ERC20: mint to the zero address");
232 
233         _beforeTokenTransfer(address(0), account, amount);
234 
235         _totalSupply += amount;
236         _balances[account] += amount;
237         emit Transfer(address(0), account, amount);
238 
239         _afterTokenTransfer(address(0), account, amount);
240     }
241 
242     function _burn(address account, uint256 amount) internal virtual {
243         require(account != address(0), "ERC20: burn from the zero address");
244 
245         _beforeTokenTransfer(account, address(0), amount);
246 
247         uint256 accountBalance = _balances[account];
248         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
249         unchecked {
250             _balances[account] = accountBalance - amount;
251         }
252         _totalSupply -= amount;
253 
254         emit Transfer(account, address(0), amount);
255 
256         _afterTokenTransfer(account, address(0), amount);
257     }
258 
259     function _approve(
260         address owner,
261         address spender,
262         uint256 amount
263     ) internal virtual {
264         require(owner != address(0), "ERC20: approve from the zero address");
265         require(spender != address(0), "ERC20: approve to the zero address");
266 
267         _allowances[owner][spender] = amount;
268         emit Approval(owner, spender, amount);
269     }
270 
271     function _spendAllowance(
272         address owner,
273         address spender,
274         uint256 amount
275     ) internal virtual {
276         uint256 currentAllowance = allowance(owner, spender);
277         if (currentAllowance != type(uint256).max) {
278             require(currentAllowance >= amount, "ERC20: insufficient allowance");
279             unchecked {
280                 _approve(owner, spender, currentAllowance - amount);
281             }
282         }
283     }
284 
285     function _beforeTokenTransfer(
286         address from,
287         address to,
288         uint256 amount
289     ) internal virtual {}
290 
291     function _afterTokenTransfer(
292         address from,
293         address to,
294         uint256 amount
295     ) internal virtual {}
296 }
297 
298 // File: OG.sol
299 
300 
301 pragma solidity ^0.8.4;
302 
303 
304 contract OG is ERC20 {
305     constructor() ERC20("Densetsu", "OG") {
306         _mint(msg.sender, 3141592635 * 10 ** decimals());
307     }
308 }