1 // SPDX-License-Identifier: MIT
2 //https://twitter.com/Pugnator69
3 pragma solidity >0.4.0 <0.9.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21     constructor() {
22         _transferOwnership(_msgSender());
23     }
24 
25     function owner() public view virtual returns (address) {
26         return _owner;
27     }
28 
29     modifier onlyOwner() {
30         require(owner() == _msgSender(), "Ownable: caller is not the owner");
31         _;
32     }
33 
34     function renounceOwnership() public virtual onlyOwner {
35         _transferOwnership(address(0));
36     }
37 
38     function transferOwnership(address newOwner) public virtual onlyOwner {
39         require(newOwner != address(0), "Ownable: new owner is the zero address");
40         _transferOwnership(newOwner);
41     }
42 
43     function _transferOwnership(address newOwner) internal virtual {
44         address oldOwner = _owner;
45         _owner = newOwner;
46         emit OwnershipTransferred(oldOwner, newOwner);
47     }
48 }
49 
50 library SafeMath {
51 
52     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             uint256 c = a + b;
55             if (c < a) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         unchecked {
62             if (b > a) return (false, 0);
63             return (true, a - b);
64         }
65     }
66 
67     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
70             // benefit is lost if 'b' is also tested.
71             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
72             if (a == 0) return (true, 0);
73             uint256 c = a * b;
74             if (c / a != b) return (false, 0);
75             return (true, c);
76         }
77     }
78 
79     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a / b);
83         }
84     }
85 
86     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
87         unchecked {
88             if (b == 0) return (false, 0);
89             return (true, a % b);
90         }
91     }
92 
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a + b;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a - b;
99     }
100 
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a * b;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a / b;
107     }
108 
109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a % b;
111     }
112 
113     function sub(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         unchecked {
119             require(b <= a, errorMessage);
120             return a - b;
121         }
122     }
123 
124     function div(
125         uint256 a,
126         uint256 b,
127         string memory errorMessage
128     ) internal pure returns (uint256) {
129         unchecked {
130             require(b > 0, errorMessage);
131             return a / b;
132         }
133     }
134 
135     function mod(
136         uint256 a,
137         uint256 b,
138         string memory errorMessage
139     ) internal pure returns (uint256) {
140         unchecked {
141             require(b > 0, errorMessage);
142             return a % b;
143         }
144     }
145 }
146 
147 interface IERC20 {
148 
149     function totalSupply() external view returns (uint256);
150     function balanceOf(address account) external view returns (uint256);
151     function transfer(address recipient, uint256 amount) external returns (bool);
152     function allowance(address owner, address spender) external view returns (uint256);
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) external returns (bool);
160 
161     event Transfer(address indexed from, address indexed to, uint256 value);
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 interface IERC20Metadata is IERC20 {
166 
167     function name() external view returns (string memory);
168     function symbol() external view returns (string memory);
169     function decimals() external view returns (uint8);
170 }
171 
172 contract ERC20 is Context, IERC20, IERC20Metadata {
173     mapping(address => uint256) private _balances;
174 
175     mapping(address => mapping(address => uint256)) private _allowances;
176 
177     uint256 private _totalSupply;
178 
179     string private _name;
180     string private _symbol;
181 
182     constructor(string memory name_, string memory symbol_) {
183         _name = name_;
184         _symbol = symbol_;
185     }
186 
187     function name() public view virtual override returns (string memory) {
188         return _name;
189     }
190 
191     function symbol() public view virtual override returns (string memory) {
192         return _symbol;
193     }
194 
195     function decimals() public view virtual override returns (uint8) {
196         return 18;
197     }
198 
199     function totalSupply() public view virtual override returns (uint256) {
200         return _totalSupply;
201     }
202 
203     function balanceOf(address account) public view virtual override returns (uint256) {
204         return _balances[account];
205     }
206 
207     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
208         _transfer(_msgSender(), recipient, amount);
209         return true;
210     }
211 
212     function allowance(address owner, address spender) public view virtual override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     function approve(address spender, uint256 amount) public virtual override returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     function transferFrom(
222         address sender,
223         address recipient,
224         uint256 amount
225     ) public virtual override returns (bool) {
226         _transfer(sender, recipient, amount);
227 
228         uint256 currentAllowance = _allowances[sender][_msgSender()];
229         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
230         unchecked {
231             _approve(sender, _msgSender(), currentAllowance - amount);
232         }
233 
234         return true;
235     }
236 
237     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
238         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
239         return true;
240     }
241 
242     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
243         uint256 currentAllowance = _allowances[_msgSender()][spender];
244         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
245         unchecked {
246             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
247         }
248 
249         return true;
250     }
251 
252     function _transfer(
253         address sender,
254         address recipient,
255         uint256 amount
256     ) internal virtual {
257         require(sender != address(0), "ERC20: transfer from the zero address");
258         require(recipient != address(0), "ERC20: transfer to the zero address");
259 
260         _beforeTokenTransfer(sender, recipient, amount);
261 
262         uint256 senderBalance = _balances[sender];
263         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
264         unchecked {
265             _balances[sender] = senderBalance - amount;
266         }
267         _balances[recipient] += amount;
268 
269         emit Transfer(sender, recipient, amount);
270 
271         _afterTokenTransfer(sender, recipient, amount);
272     }
273 
274     function _mint(address account, uint256 amount) internal virtual {
275         require(account != address(0), "ERC20: mint to the zero address");
276 
277         _beforeTokenTransfer(address(0), account, amount);
278 
279         _totalSupply += amount;
280         _balances[account] += amount;
281         emit Transfer(address(0), account, amount);
282 
283         _afterTokenTransfer(address(0), account, amount);
284     }
285 
286     function _burn(address account, uint256 amount) internal virtual {
287         require(account != address(0), "ERC20: burn from the zero address");
288 
289         _beforeTokenTransfer(account, address(0), amount);
290 
291         uint256 accountBalance = _balances[account];
292         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
293         unchecked {
294             _balances[account] = accountBalance - amount;
295         }
296         _totalSupply -= amount;
297 
298         emit Transfer(account, address(0), amount);
299 
300         _afterTokenTransfer(account, address(0), amount);
301     }
302 
303     function _approve(
304         address owner,
305         address spender,
306         uint256 amount
307     ) internal virtual {
308         require(owner != address(0), "ERC20: approve from the zero address");
309         require(spender != address(0), "ERC20: approve to the zero address");
310 
311         _allowances[owner][spender] = amount;
312         emit Approval(owner, spender, amount);
313     }
314 
315     function _beforeTokenTransfer(
316         address from,
317         address to,
318         uint256 amount
319     ) internal virtual {}
320 
321     function _afterTokenTransfer(
322         address from,
323         address to,
324         uint256 amount
325     ) internal virtual {}
326 }
327 
328 contract PUG is Ownable, ERC20 {
329     using SafeMath for uint256;
330 
331     constructor(uint256 _tokensCount) ERC20("PUG", "PUG") {
332         _mint(owner(), _tokensCount);
333     }
334 }