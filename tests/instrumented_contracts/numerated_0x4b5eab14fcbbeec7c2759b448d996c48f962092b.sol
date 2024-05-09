1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Teh frens will find me on twitter and create truly decentralized community TG
5 https://medium.com/@iroh.kyoshi/mizu-ga-nagareru-b3bf86b0e7b1
6 https://www.mizuiroh.online/
7 */
8 
9 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
10 
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts@4.6.0/token/ERC20/IERC20.sol
27 
28 
29 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     /**
41      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
42      * a call to {approve}. `value` is the new allowance.
43      */
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     function transfer(address to, uint256 amount) external returns (bool);
57 
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     function transferFrom(
63         address from,
64         address to,
65         uint256 amount
66     ) external returns (bool);
67 }
68 
69 // File: @openzeppelin/contracts@4.6.0/token/ERC20/extensions/IERC20Metadata.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 
77 /**
78  * @dev Interface for the optional metadata functions from the ERC20 standard.
79  *
80  * _Available since v4.1._
81  */
82 interface IERC20Metadata is IERC20 {
83     /**
84      * @dev Returns the name of the token.
85      */
86     function name() external view returns (string memory);
87 
88     /**
89      * @dev Returns the symbol of the token.
90      */
91     function symbol() external view returns (string memory);
92 
93     /**
94      * @dev Returns the decimals places of the token.
95      */
96     function decimals() external view returns (uint8);
97 }
98 
99 // File: @openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol
100 
101 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 contract ERC20 is Context, IERC20, IERC20Metadata {
107     mapping(address => uint256) private _balances;
108 
109     mapping(address => mapping(address => uint256)) private _allowances;
110 
111     uint256 private _totalSupply;
112 
113     string private _name;
114     string private _symbol;
115 
116     constructor(string memory name_, string memory symbol_) {
117         _name = name_;
118         _symbol = symbol_;
119     }
120 
121     /**
122      * @dev Returns the name of the token.
123      */
124     function name() public view virtual override returns (string memory) {
125         return _name;
126     }
127 
128     /**
129      * @dev Returns the symbol of the token, usually a shorter version of the
130      * name.
131      */
132     function symbol() public view virtual override returns (string memory) {
133         return _symbol;
134     }
135 
136     function decimals() public view virtual override returns (uint8) {
137         return 18;
138     }
139 
140     /**
141      * @dev See {IERC20-totalSupply}.
142      */
143     function totalSupply() public view virtual override returns (uint256) {
144         return _totalSupply;
145     }
146 
147     /**
148      * @dev See {IERC20-balanceOf}.
149      */
150     function balanceOf(address account) public view virtual override returns (uint256) {
151         return _balances[account];
152     }
153 
154     function transfer(address to, uint256 amount) public virtual override returns (bool) {
155         address owner = _msgSender();
156         _transfer(owner, to, amount);
157         return true;
158     }
159 
160     /**
161      * @dev See {IERC20-allowance}.
162      */
163     function allowance(address owner, address spender) public view virtual override returns (uint256) {
164         return _allowances[owner][spender];
165     }
166 
167     function approve(address spender, uint256 amount) public virtual override returns (bool) {
168         address owner = _msgSender();
169         _approve(owner, spender, amount);
170         return true;
171     }
172 
173     function transferFrom(
174         address from,
175         address to,
176         uint256 amount
177     ) public virtual override returns (bool) {
178         address spender = _msgSender();
179         _spendAllowance(from, spender, amount);
180         _transfer(from, to, amount);
181         return true;
182     }
183 
184     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
185         address owner = _msgSender();
186         _approve(owner, spender, allowance(owner, spender) + addedValue);
187         return true;
188     }
189 
190     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
191         address owner = _msgSender();
192         uint256 currentAllowance = allowance(owner, spender);
193         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
194         unchecked {
195             _approve(owner, spender, currentAllowance - subtractedValue);
196         }
197 
198         return true;
199     }
200 
201     function _transfer(
202         address from,
203         address to,
204         uint256 amount
205     ) internal virtual {
206         require(from != address(0), "ERC20: transfer from the zero address");
207         require(to != address(0), "ERC20: transfer to the zero address");
208 
209         _beforeTokenTransfer(from, to, amount);
210 
211         uint256 fromBalance = _balances[from];
212         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
213         unchecked {
214             _balances[from] = fromBalance - amount;
215         }
216         _balances[to] += amount;
217 
218         emit Transfer(from, to, amount);
219 
220         _afterTokenTransfer(from, to, amount);
221     }
222 
223     function _mint(address account, uint256 amount) internal virtual {
224         require(account != address(0), "ERC20: mint to the zero address");
225 
226         _beforeTokenTransfer(address(0), account, amount);
227 
228         _totalSupply += amount;
229         _balances[account] += amount;
230         emit Transfer(address(0), account, amount);
231 
232         _afterTokenTransfer(address(0), account, amount);
233     }
234 
235     function _burn(address account, uint256 amount) internal virtual {
236         require(account != address(0), "ERC20: burn from the zero address");
237 
238         _beforeTokenTransfer(account, address(0), amount);
239 
240         uint256 accountBalance = _balances[account];
241         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
242         unchecked {
243             _balances[account] = accountBalance - amount;
244         }
245         _totalSupply -= amount;
246 
247         emit Transfer(account, address(0), amount);
248 
249         _afterTokenTransfer(account, address(0), amount);
250     }
251 
252     function _approve(
253         address owner,
254         address spender,
255         uint256 amount
256     ) internal virtual {
257         require(owner != address(0), "ERC20: approve from the zero address");
258         require(spender != address(0), "ERC20: approve to the zero address");
259 
260         _allowances[owner][spender] = amount;
261         emit Approval(owner, spender, amount);
262     }
263 
264     function _spendAllowance(
265         address owner,
266         address spender,
267         uint256 amount
268     ) internal virtual {
269         uint256 currentAllowance = allowance(owner, spender);
270         if (currentAllowance != type(uint256).max) {
271             require(currentAllowance >= amount, "ERC20: insufficient allowance");
272             unchecked {
273                 _approve(owner, spender, currentAllowance - amount);
274             }
275         }
276     }
277 
278     function _beforeTokenTransfer(
279         address from,
280         address to,
281         uint256 amount
282     ) internal virtual {}
283 
284     function _afterTokenTransfer(
285         address from,
286         address to,
287         uint256 amount
288     ) internal virtual {}
289 }
290 
291 // File: MIZU.sol
292 
293 
294 pragma solidity ^0.8.4;
295 
296 
297 contract MIZU is ERC20 {
298     constructor() ERC20("MIZUIROH KYOSHI", "MIZU") {
299         _mint(msg.sender, 4920221330 * 10 ** decimals());
300     }
301 }