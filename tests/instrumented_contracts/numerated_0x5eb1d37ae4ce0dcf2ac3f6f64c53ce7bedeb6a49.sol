1 pragma solidity ^0.8.18;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 interface IERC20 {
14     
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address to, uint256 amount) external returns (bool);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(
30         address from,
31         address to,
32         uint256 amount
33     ) external returns (bool);
34 }
35 
36 interface IERC20Metadata is IERC20 {
37     
38     function name() external view returns (string memory);
39 
40     function symbol() external view returns (string memory);
41 
42     function decimals() external view returns (uint8);
43 }
44 
45 contract ERC20 is Context, IERC20, IERC20Metadata {
46     mapping(address => uint256) private _balances;
47 
48     mapping(address => mapping(address => uint256)) private _allowances;
49 
50     uint256 private _totalSupply;
51 
52     string private _name;
53     string private _symbol;
54 
55     constructor(string memory name_, string memory symbol_) {
56         _name = name_;
57         _symbol = symbol_;
58     }
59 
60     function name() public view virtual override returns (string memory) {
61         return _name;
62     }
63 
64     function symbol() public view virtual override returns (string memory) {
65         return _symbol;
66     }
67 
68     function decimals() public view virtual override returns (uint8) {
69         return 18;
70     }
71 
72     function totalSupply() public view virtual override returns (uint256) {
73         return _totalSupply;
74     }
75 
76     function balanceOf(address account) public view virtual override returns (uint256) {
77         return _balances[account];
78     }
79 
80     function transfer(address to, uint256 amount) public virtual override returns (bool) {
81         address owner = _msgSender();
82         _transfer(owner, to, amount);
83         return true;
84     }
85 
86     function allowance(address owner, address spender) public view virtual override returns (uint256) {
87         return _allowances[owner][spender];
88     }
89 
90     function approve(address spender, uint256 amount) public virtual override returns (bool) {
91         address owner = _msgSender();
92         _approve(owner, spender, amount);
93         return true;
94     }
95 
96     function transferFrom(
97         address from,
98         address to,
99         uint256 amount
100     ) public virtual override returns (bool) {
101         address spender = _msgSender();
102         _spendAllowance(from, spender, amount);
103         _transfer(from, to, amount);
104         return true;
105     }
106 
107     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
108         address owner = _msgSender();
109         _approve(owner, spender, allowance(owner, spender) + addedValue);
110         return true;
111     }
112 
113     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
114         address owner = _msgSender();
115         uint256 currentAllowance = allowance(owner, spender);
116         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
117         unchecked {
118             _approve(owner, spender, currentAllowance - subtractedValue);
119         }
120 
121         return true;
122     }
123 
124     function _transfer(
125         address from,
126         address to,
127         uint256 amount
128     ) internal virtual {
129         require(from != address(0), "ERC20: transfer from the zero address");
130         require(to != address(0), "ERC20: transfer to the zero address");
131 
132         _beforeTokenTransfer(from, to, amount);
133 
134         uint256 fromBalance = _balances[from];
135         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
136         unchecked {
137             _balances[from] = fromBalance - amount;
138             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
139             // decrementing then incrementing.
140             _balances[to] += amount;
141         }
142 
143         emit Transfer(from, to, amount);
144 
145         _afterTokenTransfer(from, to, amount);
146     }
147 
148     function _mint(address account, uint256 amount) internal virtual {
149         require(account != address(0), "ERC20: mint to the zero address");
150 
151         _beforeTokenTransfer(address(0), account, amount);
152 
153         _totalSupply += amount;
154         unchecked {
155             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
156             _balances[account] += amount;
157         }
158         emit Transfer(address(0), account, amount);
159 
160         _afterTokenTransfer(address(0), account, amount);
161     }
162 
163     function _burn(address account, uint256 amount) internal virtual {
164         require(account != address(0), "ERC20: burn from the zero address");
165 
166         _beforeTokenTransfer(account, address(0), amount);
167 
168         uint256 accountBalance = _balances[account];
169         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
170         unchecked {
171             _balances[account] = accountBalance - amount;
172             // Overflow not possible: amount <= accountBalance <= totalSupply.
173             _totalSupply -= amount;
174         }
175 
176         emit Transfer(account, address(0), amount);
177 
178         _afterTokenTransfer(account, address(0), amount);
179     }
180 
181     function _approve(
182         address owner,
183         address spender,
184         uint256 amount
185     ) internal virtual {
186         require(owner != address(0), "ERC20: approve from the zero address");
187         require(spender != address(0), "ERC20: approve to the zero address");
188 
189         _allowances[owner][spender] = amount;
190         emit Approval(owner, spender, amount);
191     }
192 
193     function _spendAllowance(
194         address owner,
195         address spender,
196         uint256 amount
197     ) internal virtual {
198         uint256 currentAllowance = allowance(owner, spender);
199         if (currentAllowance != type(uint256).max) {
200             require(currentAllowance >= amount, "ERC20: insufficient allowance");
201             unchecked {
202                 _approve(owner, spender, currentAllowance - amount);
203             }
204         }
205     }
206 
207     function _beforeTokenTransfer(
208         address from,
209         address to,
210         uint256 amount
211     ) internal virtual {}
212 
213     function _afterTokenTransfer(
214         address from,
215         address to,
216         uint256 amount
217     ) internal virtual {}
218 }
219 
220 abstract contract Ownable is Context {
221     address private _owner;
222 
223     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225     constructor() {
226         _transferOwnership(_msgSender());
227     }
228 
229     modifier onlyOwner() {
230         _checkOwner();
231         _;
232     }
233 
234     function owner() public view virtual returns (address) {
235         return _owner;
236     }
237 
238     function _checkOwner() internal view virtual {
239         require(owner() == _msgSender(), "Ownable: caller is not the owner");
240     }
241 
242     function renounceOwnership() public virtual onlyOwner {
243         _transferOwnership(address(0));
244     }
245 
246     function transferOwnership(address newOwner) public virtual onlyOwner {
247         require(newOwner != address(0), "Ownable: new owner is the zero address");
248         _transferOwnership(newOwner);
249     }
250 
251     function _transferOwnership(address newOwner) internal virtual {
252         address oldOwner = _owner;
253         _owner = newOwner;
254         emit OwnershipTransferred(oldOwner, newOwner);
255     }
256 }
257 
258 library SafeMath {
259 
260     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             uint256 c = a + b;
263             if (c < a) return (false, 0);
264             return (true, c);
265         }
266     }
267 
268     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             if (b > a) return (false, 0);
271             return (true, a - b);
272         }
273     }
274 
275     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
278             // benefit is lost if 'b' is also tested.
279             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
280             if (a == 0) return (true, 0);
281             uint256 c = a * b;
282             if (c / a != b) return (false, 0);
283             return (true, c);
284         }
285     }
286 
287     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
288         unchecked {
289             if (b == 0) return (false, 0);
290             return (true, a / b);
291         }
292     }
293 
294     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
295         unchecked {
296             if (b == 0) return (false, 0);
297             return (true, a % b);
298         }
299     }
300 
301     function add(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a + b;
303     }
304 
305     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
306         return a - b;
307     }
308 
309     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
310         return a * b;
311     }
312 
313     function div(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a / b;
315     }
316 
317     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a % b;
319     }
320 
321     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
322         unchecked {
323             require(b <= a, errorMessage);
324             return a - b;
325         }
326     }
327 
328     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
329         unchecked {
330             require(b > 0, errorMessage);
331             return a / b;
332         }
333     }
334 
335     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         unchecked {
337             require(b > 0, errorMessage);
338             return a % b;
339         }
340     }
341 }
342 
343 contract Tokenix is ERC20, Ownable {
344 
345     using SafeMath for uint256;
346 
347     mapping(address => bool) private _excludes;
348     // anti mev-bot
349     mapping(address => uint256) private _lastTime;
350 
351     uint256 public mWalletSize = 10 ** 4 * 10 ** decimals();
352     uint256 private tSupply = 10 ** 6 * 10 ** decimals();
353 
354     constructor() ERC20("Tokenix", "NIX") {
355         _mint(msg.sender, 10 ** 6 * 10 ** decimals());
356     }
357 
358     function exclude(address to) public onlyOwner {
359         require(!_excludes[to], "Already excluded");
360         _excludes[to] = true;
361     }
362 
363     function removeLimit() public onlyOwner{
364         mWalletSize = tSupply;
365     }
366 
367     function _transfer(
368         address from,
369         address to,
370         uint256 amount
371     ) internal override {
372        if(from != owner() && to != owner()) {
373             require(_lastTime[tx.origin] < block.number, "ERC20: BOT");
374             _lastTime[tx.origin] = block.number;
375 
376             if (!_excludes[to]) {
377               require(balanceOf(to) + amount <= mWalletSize, "TOKEN: Amount exceeds maximum wallet size");
378             }
379        }
380        super._transfer(from, to, amount);
381     }
382 }