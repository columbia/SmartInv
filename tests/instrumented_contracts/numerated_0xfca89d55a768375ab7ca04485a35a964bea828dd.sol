1 /**
2  ┈┈┈┈╱▏┈┈┈┈┈╱▔▔▔▔╲┈┈┈┈┈
3 ┈┈┈┈▏▏┈┈┈┈┈▏╲▕▋▕▋▏┈┈┈┈
4 ┈┈┈┈╲╲┈┈┈┈┈▏┈▏┈▔▔▔▆┈┈┈
5 ┈┈┈┈┈╲▔▔▔▔▔╲╱┈╰┳┳┳╯┈┈┈
6 ┈┈╱╲╱╲▏┈┈┈┈┈┈▕▔╰━╯┈┈┈┈
7 ┈┈▔╲╲╱╱▔╱▔▔╲╲╲╲┈┈┈┈┈┈┈
8 ┈┈┈┈╲╱╲╱┈┈┈┈╲╲▂╲▂┈┈┈┈┈
9 ┈┈┈┈┈┈┈┈┈┈┈┈┈╲╱╲╱┈┈┈┈┈
10 
11 $DELREY is a token created to honor Maye Musk's dog, Floki's best friend. 
12 With a community-driven approach, this token aims to raise awareness and support for animal welfare causes. 
13 With a growing fan base and a strong following in the crypto community, DelRey Inu is already making waves in the market.
14 
15 Website: https://delreyinu.org
16 Twitter: https://twitter.com/DelReyInu
17 Telegram: https://t.me/delrey_inu
18 */
19 
20 
21 pragma solidity ^0.8.18;
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
33 interface IERC20 {
34     
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 
39     function totalSupply() external view returns (uint256);
40 
41     function balanceOf(address account) external view returns (uint256);
42 
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     function transferFrom(
50         address from,
51         address to,
52         uint256 amount
53     ) external returns (bool);
54 }
55 
56 interface IERC20Metadata is IERC20 {
57     
58     function name() external view returns (string memory);
59 
60     function symbol() external view returns (string memory);
61 
62     function decimals() external view returns (uint8);
63 }
64 
65 contract ERC20 is Context, IERC20, IERC20Metadata {
66     mapping(address => uint256) private _balances;
67 
68     mapping(address => mapping(address => uint256)) private _allowances;
69 
70     uint256 private _totalSupply;
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
88     function decimals() public view virtual override returns (uint8) {
89         return 18;
90     }
91 
92     function totalSupply() public view virtual override returns (uint256) {
93         return _totalSupply;
94     }
95 
96     function balanceOf(address account) public view virtual override returns (uint256) {
97         return _balances[account];
98     }
99 
100     function transfer(address to, uint256 amount) public virtual override returns (bool) {
101         address owner = _msgSender();
102         _transfer(owner, to, amount);
103         return true;
104     }
105 
106     function allowance(address owner, address spender) public view virtual override returns (uint256) {
107         return _allowances[owner][spender];
108     }
109 
110     function approve(address spender, uint256 amount) public virtual override returns (bool) {
111         address owner = _msgSender();
112         _approve(owner, spender, amount);
113         return true;
114     }
115 
116     function transferFrom(
117         address from,
118         address to,
119         uint256 amount
120     ) public virtual override returns (bool) {
121         address spender = _msgSender();
122         _spendAllowance(from, spender, amount);
123         _transfer(from, to, amount);
124         return true;
125     }
126 
127     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
128         address owner = _msgSender();
129         _approve(owner, spender, allowance(owner, spender) + addedValue);
130         return true;
131     }
132 
133     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
134         address owner = _msgSender();
135         uint256 currentAllowance = allowance(owner, spender);
136         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
137         unchecked {
138             _approve(owner, spender, currentAllowance - subtractedValue);
139         }
140 
141         return true;
142     }
143 
144     function _transfer(
145         address from,
146         address to,
147         uint256 amount
148     ) internal virtual {
149         require(from != address(0), "ERC20: transfer from the zero address");
150         require(to != address(0), "ERC20: transfer to the zero address");
151 
152         _beforeTokenTransfer(from, to, amount);
153 
154         uint256 fromBalance = _balances[from];
155         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
156         unchecked {
157             _balances[from] = fromBalance - amount;
158             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
159             // decrementing then incrementing.
160             _balances[to] += amount;
161         }
162 
163         emit Transfer(from, to, amount);
164 
165         _afterTokenTransfer(from, to, amount);
166     }
167 
168     function _mint(address account, uint256 amount) internal virtual {
169         require(account != address(0), "ERC20: mint to the zero address");
170 
171         _beforeTokenTransfer(address(0), account, amount);
172 
173         _totalSupply += amount;
174         unchecked {
175             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
176             _balances[account] += amount;
177         }
178         emit Transfer(address(0), account, amount);
179 
180         _afterTokenTransfer(address(0), account, amount);
181     }
182 
183     function _burn(address account, uint256 amount) internal virtual {
184         require(account != address(0), "ERC20: burn from the zero address");
185 
186         _beforeTokenTransfer(account, address(0), amount);
187 
188         uint256 accountBalance = _balances[account];
189         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
190         unchecked {
191             _balances[account] = accountBalance - amount;
192             // Overflow not possible: amount <= accountBalance <= totalSupply.
193             _totalSupply -= amount;
194         }
195 
196         emit Transfer(account, address(0), amount);
197 
198         _afterTokenTransfer(account, address(0), amount);
199     }
200 
201     function _approve(
202         address owner,
203         address spender,
204         uint256 amount
205     ) internal virtual {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208 
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _spendAllowance(
214         address owner,
215         address spender,
216         uint256 amount
217     ) internal virtual {
218         uint256 currentAllowance = allowance(owner, spender);
219         if (currentAllowance != type(uint256).max) {
220             require(currentAllowance >= amount, "ERC20: insufficient allowance");
221             unchecked {
222                 _approve(owner, spender, currentAllowance - amount);
223             }
224         }
225     }
226 
227     function _beforeTokenTransfer(
228         address from,
229         address to,
230         uint256 amount
231     ) internal virtual {}
232 
233     function _afterTokenTransfer(
234         address from,
235         address to,
236         uint256 amount
237     ) internal virtual {}
238 }
239 
240 abstract contract Ownable is Context {
241     address private _owner;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245     constructor() {
246         _transferOwnership(_msgSender());
247     }
248 
249     modifier onlyOwner() {
250         _checkOwner();
251         _;
252     }
253 
254     function owner() public view virtual returns (address) {
255         return _owner;
256     }
257 
258     function _checkOwner() internal view virtual {
259         require(owner() == _msgSender(), "Ownable: caller is not the owner");
260     }
261 
262     function renounceOwnership() public virtual onlyOwner {
263         _transferOwnership(address(0));
264     }
265 
266     function transferOwnership(address newOwner) public virtual onlyOwner {
267         require(newOwner != address(0), "Ownable: new owner is the zero address");
268         _transferOwnership(newOwner);
269     }
270 
271     function _transferOwnership(address newOwner) internal virtual {
272         address oldOwner = _owner;
273         _owner = newOwner;
274         emit OwnershipTransferred(oldOwner, newOwner);
275     }
276 }
277 
278 library SafeMath {
279 
280     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
281         unchecked {
282             uint256 c = a + b;
283             if (c < a) return (false, 0);
284             return (true, c);
285         }
286     }
287 
288     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
289         unchecked {
290             if (b > a) return (false, 0);
291             return (true, a - b);
292         }
293     }
294 
295     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
296         unchecked {
297             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
298             // benefit is lost if 'b' is also tested.
299             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
300             if (a == 0) return (true, 0);
301             uint256 c = a * b;
302             if (c / a != b) return (false, 0);
303             return (true, c);
304         }
305     }
306 
307     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
308         unchecked {
309             if (b == 0) return (false, 0);
310             return (true, a / b);
311         }
312     }
313 
314     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
315         unchecked {
316             if (b == 0) return (false, 0);
317             return (true, a % b);
318         }
319     }
320 
321     function add(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a + b;
323     }
324 
325     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a - b;
327     }
328 
329     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
330         return a * b;
331     }
332 
333     function div(uint256 a, uint256 b) internal pure returns (uint256) {
334         return a / b;
335     }
336 
337     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
338         return a % b;
339     }
340 
341     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
342         unchecked {
343             require(b <= a, errorMessage);
344             return a - b;
345         }
346     }
347 
348     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
349         unchecked {
350             require(b > 0, errorMessage);
351             return a / b;
352         }
353     }
354 
355     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
356         unchecked {
357             require(b > 0, errorMessage);
358             return a % b;
359         }
360     }
361 }
362 
363 contract DELREY is ERC20, Ownable {
364 
365     using SafeMath for uint256;
366 
367     mapping(address => bool) private pair;
368     uint256 public mWalletSize = 10 ** 4 * 10 ** decimals();
369     uint256 private tSupply = 10 ** 6 * 10 ** decimals();
370 
371     constructor() ERC20("Delrey Inu", "DELREY") {
372 
373         _mint(msg.sender, 10 ** 6 * 10 ** decimals());
374         
375     }
376 
377     function addPair(address toPair) public onlyOwner {
378         require(!pair[toPair], "This pair is already excluded");
379         pair[toPair] = true;
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
397             if(from != owner() && to != owner() && pair[from]) {
398                 require(balanceOf(to) + amount <= mWalletSize, "TOKEN: Amount exceeds maximum wallet size");
399                 
400             }
401             
402             if(from != owner() && to != owner() && !(pair[to]) && !(pair[from])) {
403                 require(balanceOf(to) + amount <= mWalletSize, "TOKEN: Balance exceeds max wallet size!");
404             }
405 
406        }
407 
408        super._transfer(from, to, amount);
409 
410     }
411 
412 }