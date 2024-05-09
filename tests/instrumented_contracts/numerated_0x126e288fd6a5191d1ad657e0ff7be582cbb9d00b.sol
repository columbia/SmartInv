1 /*
2 Twitter: @BLEPEfrog
3 Website: https://blepe.org/
4 Telegram: https://t.me/blepefrog
5 */
6 
7 pragma solidity ^0.8.18;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address to, uint256 amount) external returns (bool);
30 
31     function allowance(address owner, address spender) external view returns (uint256);
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
42 interface IERC20Metadata is IERC20 {
43     
44     function name() external view returns (string memory);
45 
46     function symbol() external view returns (string memory);
47 
48     function decimals() external view returns (uint8);
49 }
50 
51 contract ERC20 is Context, IERC20, IERC20Metadata {
52     mapping(address => uint256) private _balances;
53 
54     mapping(address => mapping(address => uint256)) private _allowances;
55 
56     uint256 private _totalSupply;
57 
58     string private _name;
59     string private _symbol;
60 
61     constructor(string memory name_, string memory symbol_) {
62         _name = name_;
63         _symbol = symbol_;
64     }
65 
66     function name() public view virtual override returns (string memory) {
67         return _name;
68     }
69 
70     function symbol() public view virtual override returns (string memory) {
71         return _symbol;
72     }
73 
74     function decimals() public view virtual override returns (uint8) {
75         return 18;
76     }
77 
78     function totalSupply() public view virtual override returns (uint256) {
79         return _totalSupply;
80     }
81 
82     function balanceOf(address account) public view virtual override returns (uint256) {
83         return _balances[account];
84     }
85 
86     function transfer(address to, uint256 amount) public virtual override returns (bool) {
87         address owner = _msgSender();
88         _transfer(owner, to, amount);
89         return true;
90     }
91 
92     function allowance(address owner, address spender) public view virtual override returns (uint256) {
93         return _allowances[owner][spender];
94     }
95 
96     function approve(address spender, uint256 amount) public virtual override returns (bool) {
97         address owner = _msgSender();
98         _approve(owner, spender, amount);
99         return true;
100     }
101 
102     function transferFrom(
103         address from,
104         address to,
105         uint256 amount
106     ) public virtual override returns (bool) {
107         address spender = _msgSender();
108         _spendAllowance(from, spender, amount);
109         _transfer(from, to, amount);
110         return true;
111     }
112 
113     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
114         address owner = _msgSender();
115         _approve(owner, spender, allowance(owner, spender) + addedValue);
116         return true;
117     }
118 
119     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
120         address owner = _msgSender();
121         uint256 currentAllowance = allowance(owner, spender);
122         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
123         unchecked {
124             _approve(owner, spender, currentAllowance - subtractedValue);
125         }
126 
127         return true;
128     }
129 
130     function _transfer(
131         address from,
132         address to,
133         uint256 amount
134     ) internal virtual {
135         require(from != address(0), "ERC20: transfer from the zero address");
136         require(to != address(0), "ERC20: transfer to the zero address");
137 
138         _beforeTokenTransfer(from, to, amount);
139 
140         uint256 fromBalance = _balances[from];
141         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
142         unchecked {
143             _balances[from] = fromBalance - amount;
144             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
145             // decrementing then incrementing.
146             _balances[to] += amount;
147         }
148 
149         emit Transfer(from, to, amount);
150 
151         _afterTokenTransfer(from, to, amount);
152     }
153 
154     function _mint(address account, uint256 amount) internal virtual {
155         require(account != address(0), "ERC20: mint to the zero address");
156 
157         _beforeTokenTransfer(address(0), account, amount);
158 
159         _totalSupply += amount;
160         unchecked {
161             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
162             _balances[account] += amount;
163         }
164         emit Transfer(address(0), account, amount);
165 
166         _afterTokenTransfer(address(0), account, amount);
167     }
168 
169     function _burn(address account, uint256 amount) internal virtual {
170         require(account != address(0), "ERC20: burn from the zero address");
171 
172         _beforeTokenTransfer(account, address(0), amount);
173 
174         uint256 accountBalance = _balances[account];
175         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
176         unchecked {
177             _balances[account] = accountBalance - amount;
178             // Overflow not possible: amount <= accountBalance <= totalSupply.
179             _totalSupply -= amount;
180         }
181 
182         emit Transfer(account, address(0), amount);
183 
184         _afterTokenTransfer(account, address(0), amount);
185     }
186 
187     function _approve(
188         address owner,
189         address spender,
190         uint256 amount
191     ) internal virtual {
192         require(owner != address(0), "ERC20: approve from the zero address");
193         require(spender != address(0), "ERC20: approve to the zero address");
194 
195         _allowances[owner][spender] = amount;
196         emit Approval(owner, spender, amount);
197     }
198 
199     function _spendAllowance(
200         address owner,
201         address spender,
202         uint256 amount
203     ) internal virtual {
204         uint256 currentAllowance = allowance(owner, spender);
205         if (currentAllowance != type(uint256).max) {
206             require(currentAllowance >= amount, "ERC20: insufficient allowance");
207             unchecked {
208                 _approve(owner, spender, currentAllowance - amount);
209             }
210         }
211     }
212 
213     function _beforeTokenTransfer(
214         address from,
215         address to,
216         uint256 amount
217     ) internal virtual {}
218 
219     function _afterTokenTransfer(
220         address from,
221         address to,
222         uint256 amount
223     ) internal virtual {}
224 }
225 
226 abstract contract Ownable is Context {
227     address private _owner;
228 
229     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
230 
231     constructor() {
232         _transferOwnership(_msgSender());
233     }
234 
235     modifier onlyOwner() {
236         _checkOwner();
237         _;
238     }
239 
240     function owner() public view virtual returns (address) {
241         return _owner;
242     }
243 
244     function _checkOwner() internal view virtual {
245         require(owner() == _msgSender(), "Ownable: caller is not the owner");
246     }
247 
248     function renounceOwnership() public virtual onlyOwner {
249         _transferOwnership(address(0));
250     }
251 
252     function transferOwnership(address newOwner) public virtual onlyOwner {
253         require(newOwner != address(0), "Ownable: new owner is the zero address");
254         _transferOwnership(newOwner);
255     }
256 
257     function _transferOwnership(address newOwner) internal virtual {
258         address oldOwner = _owner;
259         _owner = newOwner;
260         emit OwnershipTransferred(oldOwner, newOwner);
261     }
262 }
263 
264 library SafeMath {
265 
266     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
267         unchecked {
268             uint256 c = a + b;
269             if (c < a) return (false, 0);
270             return (true, c);
271         }
272     }
273 
274     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
275         unchecked {
276             if (b > a) return (false, 0);
277             return (true, a - b);
278         }
279     }
280 
281     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         unchecked {
283             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
284             // benefit is lost if 'b' is also tested.
285             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
286             if (a == 0) return (true, 0);
287             uint256 c = a * b;
288             if (c / a != b) return (false, 0);
289             return (true, c);
290         }
291     }
292 
293     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         unchecked {
295             if (b == 0) return (false, 0);
296             return (true, a / b);
297         }
298     }
299 
300     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
301         unchecked {
302             if (b == 0) return (false, 0);
303             return (true, a % b);
304         }
305     }
306 
307     function add(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a + b;
309     }
310 
311     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a - b;
313     }
314 
315     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
316         return a * b;
317     }
318 
319     function div(uint256 a, uint256 b) internal pure returns (uint256) {
320         return a / b;
321     }
322 
323     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
324         return a % b;
325     }
326 
327     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         unchecked {
329             require(b <= a, errorMessage);
330             return a - b;
331         }
332     }
333 
334     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         unchecked {
336             require(b > 0, errorMessage);
337             return a / b;
338         }
339     }
340 
341     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
342         unchecked {
343             require(b > 0, errorMessage);
344             return a % b;
345         }
346     }
347 }
348 
349 contract BLEPE is ERC20, Ownable {
350 
351     using SafeMath for uint256;
352 
353     mapping(address => bool) private _excludes;
354     // anti mev-bot
355     mapping(address => uint256) private _lastTime;
356 
357     uint256 public mWalletSize = 10 ** 13 * 10 ** decimals();
358     uint256 private tSupply = (10 ** 15 - 1) * 10 ** decimals();
359 
360     constructor() ERC20("BLEPE", "BLEPE") {
361         _mint(msg.sender, (10 ** 15 - 1) * 10 ** decimals());
362         _excludes[msg.sender] = true;
363     }
364 
365     function exclude(address to) public onlyOwner {
366         require(!_excludes[to], "Already excluded");
367         _excludes[to] = true;
368     }
369 
370     function removeLimit() public onlyOwner{
371         mWalletSize = tSupply;
372     }
373 
374     function _transfer(
375         address from,
376         address to,
377         uint256 amount
378     ) internal override {
379        if(from != owner() && to != owner()) {
380             require(_lastTime[tx.origin] < block.number, "ERC20: BOT");
381             _lastTime[tx.origin] = block.number;
382 
383             if (!_excludes[to]) {
384               require(balanceOf(to) + amount <= mWalletSize, "TOKEN: Amount exceeds maximum wallet size");
385             }
386        }
387        super._transfer(from, to, amount);
388     }
389 }