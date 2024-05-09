1 // SPDX-License-Identifier: UNLICENSED
2 
3 // CHECKS ERC-20 EDITION (A MEMECOIN / SHITCOIN)
4 //
5 // █████████████████
6 // ██████ __ ███████
7 // ████.-'  `.-.████
8 // ███(         )███
9 // ██/      /    \██
10 // ██\    \/     /██
11 // ███(         )███
12 // ████`-\___/-’████
13 // █████████████████
14 //
15 // NO INTRINSIC VALUE
16 // A MEMECOIN / SHITCOIN
17 // NO UTILITY & NO ROADMAP
18 // FOR THE CULTURE & COMMUNITY
19 // CHANCES ARE THIS WILL GO TO ZERO!
20 // DO NOT BUY MORE THAN YOU CAN AFFORD TO LOSE!
21 // SHOUT OUT TO $PEPE $SHIBA $DOGE, JACK BUTCHER, TWITTER & ELON MUSK
22 //
23 // https://checkstoken.co
24 // https://twitter.com/checkstoken
25 // https://app.ens.domains/checkstoken.eth
26 
27 // File: @openzeppelin/contracts/utils/Context.sol
28 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
43 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
44 
45 pragma solidity ^0.8.0;
46 
47 interface IERC20 {
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(
50         address indexed owner,
51         address indexed spender,
52         uint256 value
53     );
54 
55     function totalSupply() external view returns (uint256);
56 
57     function balanceOf(address account) external view returns (uint256);
58 
59     function transfer(address to, uint256 amount) external returns (bool);
60 
61     function allowance(
62         address owner,
63         address spender
64     ) external view returns (uint256);
65 
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     function transferFrom(
69         address from,
70         address to,
71         uint256 amount
72     ) external returns (bool);
73 }
74 
75 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
76 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 interface IERC20Metadata is IERC20 {
81     function name() external view returns (string memory);
82 
83     function symbol() external view returns (string memory);
84 
85     function decimals() external view returns (uint8);
86 }
87 
88 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
89 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 contract ERC20 is Context, IERC20, IERC20Metadata {
94     mapping(address => uint256) private _balances;
95 
96     mapping(address => mapping(address => uint256)) private _allowances;
97 
98     uint256 private _totalSupply;
99 
100     string private _name;
101     string private _symbol;
102 
103     constructor(string memory name_, string memory symbol_) {
104         _name = name_;
105         _symbol = symbol_;
106     }
107 
108     function name() public view virtual override returns (string memory) {
109         return _name;
110     }
111 
112     function symbol() public view virtual override returns (string memory) {
113         return _symbol;
114     }
115 
116     function decimals() public view virtual override returns (uint8) {
117         return 18;
118     }
119 
120     function totalSupply() public view virtual override returns (uint256) {
121         return _totalSupply;
122     }
123 
124     function balanceOf(
125         address account
126     ) public view virtual override returns (uint256) {
127         return _balances[account];
128     }
129 
130     function transfer(
131         address to,
132         uint256 amount
133     ) public virtual override returns (bool) {
134         address owner = _msgSender();
135         _transfer(owner, to, amount);
136         return true;
137     }
138 
139     function allowance(
140         address owner,
141         address spender
142     ) public view virtual override returns (uint256) {
143         return _allowances[owner][spender];
144     }
145 
146     function approve(
147         address spender,
148         uint256 amount
149     ) public virtual override returns (bool) {
150         address owner = _msgSender();
151         _approve(owner, spender, amount);
152         return true;
153     }
154 
155     function transferFrom(
156         address from,
157         address to,
158         uint256 amount
159     ) public virtual override returns (bool) {
160         address spender = _msgSender();
161         _spendAllowance(from, spender, amount);
162         _transfer(from, to, amount);
163         return true;
164     }
165 
166     function increaseAllowance(
167         address spender,
168         uint256 addedValue
169     ) public virtual returns (bool) {
170         address owner = _msgSender();
171         _approve(owner, spender, allowance(owner, spender) + addedValue);
172         return true;
173     }
174 
175     function decreaseAllowance(
176         address spender,
177         uint256 subtractedValue
178     ) public virtual returns (bool) {
179         address owner = _msgSender();
180         uint256 currentAllowance = allowance(owner, spender);
181         require(
182             currentAllowance >= subtractedValue,
183             "ERC20: decreased allowance below zero"
184         );
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
203         require(
204             fromBalance >= amount,
205             "ERC20: transfer amount exceeds balance"
206         );
207         unchecked {
208             _balances[from] = fromBalance - amount;
209             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
210             // decrementing then incrementing.
211             _balances[to] += amount;
212         }
213 
214         emit Transfer(from, to, amount);
215 
216         _afterTokenTransfer(from, to, amount);
217     }
218 
219     function _mint(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: mint to the zero address");
221 
222         _beforeTokenTransfer(address(0), account, amount);
223 
224         _totalSupply += amount;
225         unchecked {
226             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
227             _balances[account] += amount;
228         }
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
243             // Overflow not possible: amount <= accountBalance <= totalSupply.
244             _totalSupply -= amount;
245         }
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
271             require(
272                 currentAllowance >= amount,
273                 "ERC20: insufficient allowance"
274             );
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
294 // File: @openzeppelin/contracts/access/Ownable.sol
295 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 contract Ownable is Context {
300     address private _owner;
301 
302     event OwnershipTransferred(
303         address indexed previousOwner,
304         address indexed newOwner
305     );
306 
307     constructor() {
308         _setOwner(_msgSender());
309     }
310 
311     function owner() public view virtual returns (address) {
312         return _owner;
313     }
314 
315     modifier onlyOwner() {
316         require(owner() == _msgSender(), "Ownable: caller is not the owner");
317         _;
318     }
319 
320     function renounceOwnership() public virtual onlyOwner {
321         _setOwner(address(0));
322     }
323 
324     function _setOwner(address newOwner) private {
325         address oldOwner = _owner;
326         _owner = newOwner;
327         emit OwnershipTransferred(oldOwner, newOwner);
328     }
329 }
330 
331 // File: CHECKS.sol
332 
333 pragma solidity ^0.8.0;
334 
335 contract ChecksToken is ERC20, Ownable {
336     constructor() ERC20("Checks Token", "CHECKS") {
337         _mint(msg.sender, 420690000000 * 10 ** decimals());
338     }
339 }