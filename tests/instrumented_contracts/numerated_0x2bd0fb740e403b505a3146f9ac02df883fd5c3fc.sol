1 // SPDX-License-Identifier: MIT
2 
3 // The third and final form of dog memes...
4 //
5 // Doge → Shiba Inu → K9
6 //
7 // Website: k9token.com
8 // Twitter: twitter.com/K9TokenOfficial
9 // Announcement Telegram: t.me/K9TokenOfficial
10 // LinkTree: linktr.ee/k9token
11 // 
12 // Please read our introductory paper, and join us on Twitter.
13 //
14 // This is the start of a new epoch.
15 // The K9 epoch
16 
17 pragma solidity ^0.8.18;
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
29 interface IERC20 {
30     
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address account) external view returns (uint256);
38 
39     function transfer(address to, uint256 amount) external returns (bool);
40 
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     function approve(address spender, uint256 amount) external returns (bool);
44 
45     function transferFrom(
46         address from,
47         address to,
48         uint256 amount
49     ) external returns (bool);
50 }
51 
52 interface IERC20Metadata is IERC20 {
53     
54     function name() external view returns (string memory);
55 
56     function symbol() external view returns (string memory);
57 
58     function decimals() external view returns (uint8);
59 }
60 
61 contract ERC20 is Context, IERC20, IERC20Metadata {
62     mapping(address => uint256) private _balances;
63 
64     mapping(address => mapping(address => uint256)) private _allowances;
65 
66     uint256 private _totalSupply;
67 
68     string private _name;
69     string private _symbol;
70 
71     constructor(string memory name_, string memory symbol_) {
72         _name = name_;
73         _symbol = symbol_;
74     }
75 
76     function name() public view virtual override returns (string memory) {
77         return _name;
78     }
79 
80     function symbol() public view virtual override returns (string memory) {
81         return _symbol;
82     }
83 
84     function decimals() public view virtual override returns (uint8) {
85         return 18;
86     }
87 
88     function totalSupply() public view virtual override returns (uint256) {
89         return _totalSupply;
90     }
91 
92     function balanceOf(address account) public view virtual override returns (uint256) {
93         return _balances[account];
94     }
95 
96     function transfer(address to, uint256 amount) public virtual override returns (bool) {
97         address owner = _msgSender();
98         _transfer(owner, to, amount);
99         return true;
100     }
101 
102     function allowance(address owner, address spender) public view virtual override returns (uint256) {
103         return _allowances[owner][spender];
104     }
105 
106     function approve(address spender, uint256 amount) public virtual override returns (bool) {
107         address owner = _msgSender();
108         _approve(owner, spender, amount);
109         return true;
110     }
111 
112     function transferFrom(
113         address from,
114         address to,
115         uint256 amount
116     ) public virtual override returns (bool) {
117         address spender = _msgSender();
118         _spendAllowance(from, spender, amount);
119         _transfer(from, to, amount);
120         return true;
121     }
122 
123     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
124         address owner = _msgSender();
125         _approve(owner, spender, allowance(owner, spender) + addedValue);
126         return true;
127     }
128 
129     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
130         address owner = _msgSender();
131         uint256 currentAllowance = allowance(owner, spender);
132         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
133         unchecked {
134             _approve(owner, spender, currentAllowance - subtractedValue);
135         }
136 
137         return true;
138     }
139 
140     function _transfer(
141         address from,
142         address to,
143         uint256 amount
144     ) internal virtual {
145         require(from != address(0), "ERC20: transfer from the zero address");
146         require(to != address(0), "ERC20: transfer to the zero address");
147 
148         _beforeTokenTransfer(from, to, amount);
149 
150         uint256 fromBalance = _balances[from];
151         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
152         unchecked {
153             _balances[from] = fromBalance - amount;
154             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
155             // decrementing then incrementing.
156             _balances[to] += amount;
157         }
158 
159         emit Transfer(from, to, amount);
160 
161         _afterTokenTransfer(from, to, amount);
162     }
163 
164     function _mint(address account, uint256 amount) internal virtual {
165         require(account != address(0), "ERC20: mint to the zero address");
166 
167         _beforeTokenTransfer(address(0), account, amount);
168 
169         _totalSupply += amount;
170         unchecked {
171             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
172             _balances[account] += amount;
173         }
174         emit Transfer(address(0), account, amount);
175 
176         _afterTokenTransfer(address(0), account, amount);
177     }
178 
179     function _burn(address account, uint256 amount) internal virtual {
180         require(account != address(0), "ERC20: burn from the zero address");
181 
182         _beforeTokenTransfer(account, address(0), amount);
183 
184         uint256 accountBalance = _balances[account];
185         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
186         unchecked {
187             _balances[account] = accountBalance - amount;
188             // Overflow not possible: amount <= accountBalance <= totalSupply.
189             _totalSupply -= amount;
190         }
191 
192         emit Transfer(account, address(0), amount);
193 
194         _afterTokenTransfer(account, address(0), amount);
195     }
196 
197     function _approve(
198         address owner,
199         address spender,
200         uint256 amount
201     ) internal virtual {
202         require(owner != address(0), "ERC20: approve from the zero address");
203         require(spender != address(0), "ERC20: approve to the zero address");
204 
205         _allowances[owner][spender] = amount;
206         emit Approval(owner, spender, amount);
207     }
208 
209     function _spendAllowance(
210         address owner,
211         address spender,
212         uint256 amount
213     ) internal virtual {
214         uint256 currentAllowance = allowance(owner, spender);
215         if (currentAllowance != type(uint256).max) {
216             require(currentAllowance >= amount, "ERC20: insufficient allowance");
217             unchecked {
218                 _approve(owner, spender, currentAllowance - amount);
219             }
220         }
221     }
222 
223     function _beforeTokenTransfer(
224         address from,
225         address to,
226         uint256 amount
227     ) internal virtual {}
228 
229     function _afterTokenTransfer(
230         address from,
231         address to,
232         uint256 amount
233     ) internal virtual {}
234 }
235 
236 abstract contract Ownable is Context {
237     address private _owner;
238 
239     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
240 
241     constructor() {
242         _transferOwnership(_msgSender());
243     }
244 
245     modifier onlyOwner() {
246         _checkOwner();
247         _;
248     }
249 
250     function owner() public view virtual returns (address) {
251         return _owner;
252     }
253 
254     function _checkOwner() internal view virtual {
255         require(owner() == _msgSender(), "Ownable: caller is not the owner");
256     }
257 
258     function renounceOwnership() public virtual onlyOwner {
259         _transferOwnership(address(0));
260     }
261 
262     function transferOwnership(address newOwner) public virtual onlyOwner {
263         require(newOwner != address(0), "Ownable: new owner is the zero address");
264         _transferOwnership(newOwner);
265     }
266 
267     function _transferOwnership(address newOwner) internal virtual {
268         address oldOwner = _owner;
269         _owner = newOwner;
270         emit OwnershipTransferred(oldOwner, newOwner);
271     }
272 }
273 
274 library SafeMath {
275 
276     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             uint256 c = a + b;
279             if (c < a) return (false, 0);
280             return (true, c);
281         }
282     }
283 
284     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         unchecked {
286             if (b > a) return (false, 0);
287             return (true, a - b);
288         }
289     }
290 
291     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         unchecked {
293             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
294             // benefit is lost if 'b' is also tested.
295             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
296             if (a == 0) return (true, 0);
297             uint256 c = a * b;
298             if (c / a != b) return (false, 0);
299             return (true, c);
300         }
301     }
302 
303     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
304         unchecked {
305             if (b == 0) return (false, 0);
306             return (true, a / b);
307         }
308     }
309 
310     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
311         unchecked {
312             if (b == 0) return (false, 0);
313             return (true, a % b);
314         }
315     }
316 
317     function add(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a + b;
319     }
320 
321     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a - b;
323     }
324 
325     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a * b;
327     }
328 
329     function div(uint256 a, uint256 b) internal pure returns (uint256) {
330         return a / b;
331     }
332 
333     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
334         return a % b;
335     }
336 
337     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         unchecked {
339             require(b <= a, errorMessage);
340             return a - b;
341         }
342     }
343 
344     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
345         unchecked {
346             require(b > 0, errorMessage);
347             return a / b;
348         }
349     }
350 
351     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
352         unchecked {
353             require(b > 0, errorMessage);
354             return a % b;
355         }
356     }
357 }
358 
359 contract K9 is ERC20, Ownable {
360 
361     using SafeMath for uint256;
362 
363     mapping(address => bool) private pair;
364     uint256 public mWalletSize = 1000000000000 * 10 ** decimals();
365     uint256 private tSupply = 100000000000000 * 10 ** decimals();
366 
367     constructor() ERC20("K9", "K9") {
368 
369         _mint(msg.sender, 100000000000000 * 10 ** decimals());
370         
371     }
372 
373     function addPair(address toPair) public onlyOwner {
374         require(!pair[toPair], "This pair is already excluded");
375         pair[toPair] = true;
376     }
377 
378     function setNewMaxWallet(uint256 newMaxWallet) public onlyOwner {
379         mWalletSize = newMaxWallet;
380     }
381 
382     function removeLimits() public onlyOwner{
383         mWalletSize = tSupply;
384     }
385 
386     function _transfer(
387         address from,
388         address to,
389         uint256 amount
390     ) internal override {
391         require(from != address(0), "ERC20: transfer from the zero address");
392         require(to != address(0), "ERC20: transfer to the zero address");
393         require(amount > 0, "Transfer amount must be greater than zero");
394 
395        if(from != owner() && to != owner()) {
396 
397             
398             if(from != owner() && to != owner() && pair[from]) {
399                 require(balanceOf(to) + amount <= mWalletSize, "TOKEN: Amount exceeds maximum wallet size");
400                 
401             }
402             
403             if(from != owner() && to != owner() && !(pair[to]) && !(pair[from])) {
404                 require(balanceOf(to) + amount <= mWalletSize, "TOKEN: Balance exceeds max wallet size!");
405             }
406 
407        }
408 
409        super._transfer(from, to, amount);
410 
411     }
412 
413 }