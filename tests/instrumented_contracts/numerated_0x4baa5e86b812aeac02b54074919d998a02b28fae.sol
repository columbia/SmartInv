1 // https://www.party-hat.com/
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 pragma solidity ^0.8.0;
18 
19 interface IERC20 {
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address account) external view returns (uint256);
27 
28     function transfer(address to, uint256 amount) external returns (bool);
29 
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32  
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(
36         address from,
37         address to,
38         uint256 amount
39     ) external returns (bool);
40 }
41 
42 pragma solidity ^0.8.0;
43 
44 interface IERC20Metadata is IERC20 {
45     /**
46      * @dev Returns the name of the token.
47      */
48     function name() external view returns (string memory);
49 
50     /**
51      * @dev Returns the symbol of the token.
52      */
53     function symbol() external view returns (string memory);
54 
55     /**
56      * @dev Returns the decimals places of the token.
57      */
58     function decimals() external view returns (uint8);
59 }
60 
61 pragma solidity ^0.8.0;
62 
63 
64 contract ERC20 is Context, IERC20, IERC20Metadata {
65     mapping(address => uint256) private _balances;
66 
67     mapping(address => mapping(address => uint256)) private _allowances;
68 
69     uint256 private _totalSupply;
70 
71 
72     string private _name;
73     string private _symbol;
74 
75     constructor(string memory name_, string memory symbol_) {
76         _name = name_;
77         _symbol = symbol_;
78     }
79 
80     function name() public view virtual override returns (string memory) {
81         return _name;
82     }
83 
84     function symbol() public view virtual override returns (string memory) {
85         return _symbol;
86     }
87 
88   
89     function decimals() public view virtual override returns (uint8) {
90         return 18;
91     }
92 
93     /**
94      * @dev See {IERC20-totalSupply}.
95      */
96     function totalSupply() public view virtual override returns (uint256) {
97         return _totalSupply;
98     }
99 
100     /**
101      * @dev See {IERC20-balanceOf}.
102      */
103     function balanceOf(address account) public view virtual override returns (uint256) {
104         return _balances[account];
105     }
106 
107     /**
108      * @dev See {IERC20-transfer}.
109      *
110      * Requirements:
111      *
112      * - `to` cannot be the zero address.
113      * - the caller must have a balance of at least `amount`.
114      */
115     function transfer(address to, uint256 amount) public virtual override returns (bool) {
116         address owner = _msgSender();
117         _transfer(owner, to, amount);
118         
119         return true;
120     }
121 
122     /**
123      * @dev See {IERC20-allowance}.
124      */
125     function allowance(address owner, address spender) public view virtual override returns (uint256) {
126         return _allowances[owner][spender];
127     }
128 
129     /**
130      * @dev See {IERC20-approve}.
131      *
132      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
133      * `transferFrom`. This is semantically equivalent to an infinite approval.
134      *
135      * Requirements:
136      *
137      * - `spender` cannot be the zero address.
138      */
139     function approve(address spender, uint256 amount) public virtual override returns (bool) {
140         address owner = _msgSender();
141         _approve(owner, spender, amount);
142         return true;
143     }
144 
145     function transferFrom(
146         address from,
147         address to,
148         uint256 amount
149         
150     ) public virtual override returns (bool) {
151         
152         address spender = _msgSender();
153         _spendAllowance(from, spender, amount);
154         _transfer(from, to, amount);
155         return true;
156     }
157 
158     
159     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
160         address owner = _msgSender();
161         _approve(owner, spender, allowance(owner, spender) + addedValue);
162         return true;
163     }
164 
165     
166     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
167         address owner = _msgSender();
168         uint256 currentAllowance = allowance(owner, spender);
169         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
170         unchecked {
171             _approve(owner, spender, currentAllowance - subtractedValue);
172         }
173 
174         return true;
175     }
176 
177     /**
178      * @dev Moves `amount` of tokens from `from` to `to`.
179      *
180      * This internal function is equivalent to {transfer}, and can be used to
181      * e.g. implement automatic token fees, slashing mechanisms, etc.
182      *
183      * Emits a {Transfer} event.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `from` must have a balance of at least `amount`.
190      */
191     function _transfer(
192         address from,
193         address to,
194         uint256 amount
195     ) internal virtual {
196         require(from != address(0), "ERC20: transfer from the zero address");
197         require(to != address(0), "ERC20: transfer to the zero address");
198         
199         _beforeTokenTransfer(from, to, amount);
200 
201         uint256 fromBalance = _balances[from];
202         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
203         unchecked {
204             _balances[from] = fromBalance - amount;
205             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
206             // decrementing then incrementing.
207             _balances[to] += amount;
208         }
209 
210         emit Transfer(from, to, amount);
211 
212         _afterTokenTransfer(from, to, amount);
213     }
214 
215     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
216      * the total supply.
217      *
218      * Emits a {Transfer} event with `from` set to the zero address.
219      *
220      * Requirements:
221      *
222      * - `account` cannot be the zero address.
223      */
224     function _mint(address account, uint256 amount) internal virtual {
225         require(account != address(0), "ERC20: mint to the zero address");
226 
227         _beforeTokenTransfer(address(0), account, amount);
228 
229         _totalSupply += amount;
230         unchecked {
231             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
232             _balances[account] += amount;
233         }
234         emit Transfer(address(0), account, amount);
235 
236         _afterTokenTransfer(address(0), account, amount);
237     }
238 
239     function _burn(address account, uint256 amount) internal virtual {
240         require(account != address(0), "ERC20: burn from the zero address");
241 
242         _beforeTokenTransfer(account, address(0), amount);
243 
244         uint256 accountBalance = _balances[account];
245         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
246         unchecked {
247             _balances[account] = accountBalance - amount;
248             // Overflow not possible: amount <= accountBalance <= totalSupply.
249             _totalSupply -= amount;
250         }
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
289    
290     function _afterTokenTransfer(
291         address from,
292         address to,
293         uint256 amount
294     ) internal virtual {}
295 }
296 
297 pragma solidity ^0.8.9;
298 
299 
300 contract PHAT is ERC20 {
301     constructor() ERC20("Party Hat", "PHAT") {
302 
303         _mint(msg.sender, 2147000000 * 10 ** decimals());
304     }
305 }