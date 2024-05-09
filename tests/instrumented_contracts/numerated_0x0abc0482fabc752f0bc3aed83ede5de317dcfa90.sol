1 // SPDX-License-Identifier: MIT
2 
3 /*
4 The age of gods, is about to transition to the age of man. 
5 Yes we have a world class website.
6 Yes we have a twitter account.
7 Yes we have a succinct medium.
8 But all you will get at launch is this: https://t.me/kojikitenno
9 We will first chat for a bit, understand whether you are ready, whether you are a weak spirited deserter.
10 Or, if you are of blue blood willing to weather the storms it takes to get a seat in Jimmus court.
11 Once the men are separated from the boys, we unleash the full suite. 
12 */
13 
14 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts@4.6.0/token/ERC20/IERC20.sol
32 
33 
34 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     /**
46      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
47      * a call to {approve}. `value` is the new allowance.
48      */
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 
51     /**
52      * @dev Returns the amount of tokens in existence.
53      */
54     function totalSupply() external view returns (uint256);
55 
56     /**
57      * @dev Returns the amount of tokens owned by `account`.
58      */
59     function balanceOf(address account) external view returns (uint256);
60 
61     function transfer(address to, uint256 amount) external returns (bool);
62 
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     function transferFrom(
68         address from,
69         address to,
70         uint256 amount
71     ) external returns (bool);
72 }
73 
74 // File: @openzeppelin/contracts@4.6.0/token/ERC20/extensions/IERC20Metadata.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 
82 /**
83  * @dev Interface for the optional metadata functions from the ERC20 standard.
84  *
85  * _Available since v4.1._
86  */
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns (string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns (string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns (uint8);
102 }
103 
104 // File: @openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol
105 
106 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 
111 contract ERC20 is Context, IERC20, IERC20Metadata {
112     mapping(address => uint256) private _balances;
113 
114     mapping(address => mapping(address => uint256)) private _allowances;
115 
116     uint256 private _totalSupply;
117 
118     string private _name;
119     string private _symbol;
120 
121     constructor(string memory name_, string memory symbol_) {
122         _name = name_;
123         _symbol = symbol_;
124     }
125 
126     /**
127      * @dev Returns the name of the token.
128      */
129     function name() public view virtual override returns (string memory) {
130         return _name;
131     }
132 
133     /**
134      * @dev Returns the symbol of the token, usually a shorter version of the
135      * name.
136      */
137     function symbol() public view virtual override returns (string memory) {
138         return _symbol;
139     }
140 
141     function decimals() public view virtual override returns (uint8) {
142         return 18;
143     }
144 
145     /**
146      * @dev See {IERC20-totalSupply}.
147      */
148     function totalSupply() public view virtual override returns (uint256) {
149         return _totalSupply;
150     }
151 
152     /**
153      * @dev See {IERC20-balanceOf}.
154      */
155     function balanceOf(address account) public view virtual override returns (uint256) {
156         return _balances[account];
157     }
158 
159     function transfer(address to, uint256 amount) public virtual override returns (bool) {
160         address owner = _msgSender();
161         _transfer(owner, to, amount);
162         return true;
163     }
164 
165     /**
166      * @dev See {IERC20-allowance}.
167      */
168     function allowance(address owner, address spender) public view virtual override returns (uint256) {
169         return _allowances[owner][spender];
170     }
171 
172     function approve(address spender, uint256 amount) public virtual override returns (bool) {
173         address owner = _msgSender();
174         _approve(owner, spender, amount);
175         return true;
176     }
177 
178     function transferFrom(
179         address from,
180         address to,
181         uint256 amount
182     ) public virtual override returns (bool) {
183         address spender = _msgSender();
184         _spendAllowance(from, spender, amount);
185         _transfer(from, to, amount);
186         return true;
187     }
188 
189     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
190         address owner = _msgSender();
191         _approve(owner, spender, allowance(owner, spender) + addedValue);
192         return true;
193     }
194 
195     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
196         address owner = _msgSender();
197         uint256 currentAllowance = allowance(owner, spender);
198         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
199         unchecked {
200             _approve(owner, spender, currentAllowance - subtractedValue);
201         }
202 
203         return true;
204     }
205 
206     function _transfer(
207         address from,
208         address to,
209         uint256 amount
210     ) internal virtual {
211         require(from != address(0), "ERC20: transfer from the zero address");
212         require(to != address(0), "ERC20: transfer to the zero address");
213 
214         _beforeTokenTransfer(from, to, amount);
215 
216         uint256 fromBalance = _balances[from];
217         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
218         unchecked {
219             _balances[from] = fromBalance - amount;
220         }
221         _balances[to] += amount;
222 
223         emit Transfer(from, to, amount);
224 
225         _afterTokenTransfer(from, to, amount);
226     }
227 
228     function _mint(address account, uint256 amount) internal virtual {
229         require(account != address(0), "ERC20: mint to the zero address");
230 
231         _beforeTokenTransfer(address(0), account, amount);
232 
233         _totalSupply += amount;
234         _balances[account] += amount;
235         emit Transfer(address(0), account, amount);
236 
237         _afterTokenTransfer(address(0), account, amount);
238     }
239 
240     function _burn(address account, uint256 amount) internal virtual {
241         require(account != address(0), "ERC20: burn from the zero address");
242 
243         _beforeTokenTransfer(account, address(0), amount);
244 
245         uint256 accountBalance = _balances[account];
246         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
247         unchecked {
248             _balances[account] = accountBalance - amount;
249         }
250         _totalSupply -= amount;
251 
252         emit Transfer(account, address(0), amount);
253 
254         _afterTokenTransfer(account, address(0), amount);
255     }
256 
257     function _approve(
258         address owner,
259         address spender,
260         uint256 amount
261     ) internal virtual {
262         require(owner != address(0), "ERC20: approve from the zero address");
263         require(spender != address(0), "ERC20: approve to the zero address");
264 
265         _allowances[owner][spender] = amount;
266         emit Approval(owner, spender, amount);
267     }
268 
269     function _spendAllowance(
270         address owner,
271         address spender,
272         uint256 amount
273     ) internal virtual {
274         uint256 currentAllowance = allowance(owner, spender);
275         if (currentAllowance != type(uint256).max) {
276             require(currentAllowance >= amount, "ERC20: insufficient allowance");
277             unchecked {
278                 _approve(owner, spender, currentAllowance - amount);
279             }
280         }
281     }
282 
283     function _beforeTokenTransfer(
284         address from,
285         address to,
286         uint256 amount
287     ) internal virtual {}
288 
289     function _afterTokenTransfer(
290         address from,
291         address to,
292         uint256 amount
293     ) internal virtual {}
294 }
295 
296 // File: Kojiki.sol
297 
298 
299 pragma solidity ^0.8.4;
300 
301 
302 contract Kojiki is ERC20 {
303     constructor() ERC20("Jimmu Tenno", "Kojiki") {
304         _mint(msg.sender, 66600000000 * 10 ** decimals());
305     }
306 }