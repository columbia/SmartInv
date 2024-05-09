1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Enter the Dragon Slayer
5 This is a story of the supreme sacrifice of Tokoyo,
6 and the slaying of the Dragon that has cast a curse over all of Cryptocurrency.
7 tokoyo.org
8 twitter.com/yofune_nushi
9 medium.com/@yofunenushi
10 */
11 
12 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
13 
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts@4.6.0/token/ERC20/IERC20.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     /**
44      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
45      * a call to {approve}. `value` is the new allowance.
46      */
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 
49     /**
50      * @dev Returns the amount of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the amount of tokens owned by `account`.
56      */
57     function balanceOf(address account) external view returns (uint256);
58 
59     function transfer(address to, uint256 amount) external returns (bool);
60 
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     function transferFrom(
66         address from,
67         address to,
68         uint256 amount
69     ) external returns (bool);
70 }
71 
72 // File: @openzeppelin/contracts@4.6.0/token/ERC20/extensions/IERC20Metadata.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 
80 /**
81  * @dev Interface for the optional metadata functions from the ERC20 standard.
82  *
83  * _Available since v4.1._
84  */
85 interface IERC20Metadata is IERC20 {
86     /**
87      * @dev Returns the name of the token.
88      */
89     function name() external view returns (string memory);
90 
91     /**
92      * @dev Returns the symbol of the token.
93      */
94     function symbol() external view returns (string memory);
95 
96     /**
97      * @dev Returns the decimals places of the token.
98      */
99     function decimals() external view returns (uint8);
100 }
101 
102 // File: @openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol
103 
104 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 
109 contract ERC20 is Context, IERC20, IERC20Metadata {
110     mapping(address => uint256) private _balances;
111 
112     mapping(address => mapping(address => uint256)) private _allowances;
113 
114     uint256 private _totalSupply;
115 
116     string private _name;
117     string private _symbol;
118 
119     constructor(string memory name_, string memory symbol_) {
120         _name = name_;
121         _symbol = symbol_;
122     }
123 
124     /**
125      * @dev Returns the name of the token.
126      */
127     function name() public view virtual override returns (string memory) {
128         return _name;
129     }
130 
131     /**
132      * @dev Returns the symbol of the token, usually a shorter version of the
133      * name.
134      */
135     function symbol() public view virtual override returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public view virtual override returns (uint8) {
140         return 18;
141     }
142 
143     /**
144      * @dev See {IERC20-totalSupply}.
145      */
146     function totalSupply() public view virtual override returns (uint256) {
147         return _totalSupply;
148     }
149 
150     /**
151      * @dev See {IERC20-balanceOf}.
152      */
153     function balanceOf(address account) public view virtual override returns (uint256) {
154         return _balances[account];
155     }
156 
157     function transfer(address to, uint256 amount) public virtual override returns (bool) {
158         address owner = _msgSender();
159         _transfer(owner, to, amount);
160         return true;
161     }
162 
163     /**
164      * @dev See {IERC20-allowance}.
165      */
166     function allowance(address owner, address spender) public view virtual override returns (uint256) {
167         return _allowances[owner][spender];
168     }
169 
170     function approve(address spender, uint256 amount) public virtual override returns (bool) {
171         address owner = _msgSender();
172         _approve(owner, spender, amount);
173         return true;
174     }
175 
176     function transferFrom(
177         address from,
178         address to,
179         uint256 amount
180     ) public virtual override returns (bool) {
181         address spender = _msgSender();
182         _spendAllowance(from, spender, amount);
183         _transfer(from, to, amount);
184         return true;
185     }
186 
187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
188         address owner = _msgSender();
189         _approve(owner, spender, allowance(owner, spender) + addedValue);
190         return true;
191     }
192 
193     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
194         address owner = _msgSender();
195         uint256 currentAllowance = allowance(owner, spender);
196         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
197         unchecked {
198             _approve(owner, spender, currentAllowance - subtractedValue);
199         }
200 
201         return true;
202     }
203 
204     function _transfer(
205         address from,
206         address to,
207         uint256 amount
208     ) internal virtual {
209         require(from != address(0), "ERC20: transfer from the zero address");
210         require(to != address(0), "ERC20: transfer to the zero address");
211 
212         _beforeTokenTransfer(from, to, amount);
213 
214         uint256 fromBalance = _balances[from];
215         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
216         unchecked {
217             _balances[from] = fromBalance - amount;
218         }
219         _balances[to] += amount;
220 
221         emit Transfer(from, to, amount);
222 
223         _afterTokenTransfer(from, to, amount);
224     }
225 
226     function _mint(address account, uint256 amount) internal virtual {
227         require(account != address(0), "ERC20: mint to the zero address");
228 
229         _beforeTokenTransfer(address(0), account, amount);
230 
231         _totalSupply += amount;
232         _balances[account] += amount;
233         emit Transfer(address(0), account, amount);
234 
235         _afterTokenTransfer(address(0), account, amount);
236     }
237 
238     function _burn(address account, uint256 amount) internal virtual {
239         require(account != address(0), "ERC20: burn from the zero address");
240 
241         _beforeTokenTransfer(account, address(0), amount);
242 
243         uint256 accountBalance = _balances[account];
244         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
245         unchecked {
246             _balances[account] = accountBalance - amount;
247         }
248         _totalSupply -= amount;
249 
250         emit Transfer(account, address(0), amount);
251 
252         _afterTokenTransfer(account, address(0), amount);
253     }
254 
255     function _approve(
256         address owner,
257         address spender,
258         uint256 amount
259     ) internal virtual {
260         require(owner != address(0), "ERC20: approve from the zero address");
261         require(spender != address(0), "ERC20: approve to the zero address");
262 
263         _allowances[owner][spender] = amount;
264         emit Approval(owner, spender, amount);
265     }
266 
267     function _spendAllowance(
268         address owner,
269         address spender,
270         uint256 amount
271     ) internal virtual {
272         uint256 currentAllowance = allowance(owner, spender);
273         if (currentAllowance != type(uint256).max) {
274             require(currentAllowance >= amount, "ERC20: insufficient allowance");
275             unchecked {
276                 _approve(owner, spender, currentAllowance - amount);
277             }
278         }
279     }
280 
281     function _beforeTokenTransfer(
282         address from,
283         address to,
284         uint256 amount
285     ) internal virtual {}
286 
287     function _afterTokenTransfer(
288         address from,
289         address to,
290         uint256 amount
291     ) internal virtual {}
292 }
293 
294 // File: TOKOYO.sol
295 
296 
297 pragma solidity ^0.8.4;
298 
299 
300 contract TOKOYO is ERC20 {
301     constructor() ERC20("Yofune Nushi", "KOYO") {
302         _mint(msg.sender, 30072015000 * 10 ** decimals());
303     }
304 }