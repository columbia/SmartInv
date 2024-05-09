1 /**
2 
3 TheLastMemeBender
4 
5 Telegram: https://t.me/PepeTheLastMemeBender
6 
7 Website:  https://TheLastMemeBender.com/
8 
9 Twitter:  https://twitter.com/AppaCoinEth
10 
11 LinkTree: https://linktr.ee/AppaCoinEth
12 
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 pragma solidity ^0.8.0;
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
29 
30 abstract contract Ownable is Context {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36     constructor() {
37         _transferOwnership(_msgSender());
38     }
39 
40 
41     function owner() public view virtual returns (address) {
42         return _owner;
43     }
44 
45 
46     modifier onlyOwner() {
47         require(owner() == _msgSender(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51 
52     function renounceOwnership() public virtual onlyOwner {
53         _transferOwnership(address(0));
54     }
55 
56 
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _transferOwnership(newOwner);
60     }
61 
62 
63     function _transferOwnership(address newOwner) internal virtual {
64         address oldOwner = _owner;
65         _owner = newOwner;
66         emit OwnershipTransferred(oldOwner, newOwner);
67     }
68 }
69 
70 
71 interface IERC20 {
72 
73     function totalSupply() external view returns (uint256);
74 
75 
76     function balanceOf(address account) external view returns (uint256);
77 
78 
79     function transfer(address recipient, uint256 amount) external returns (bool);
80 
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84 
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87 
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) external returns (bool);
93 
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97 
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 interface IERC20Metadata is IERC20 {
103 
104     function name() external view returns (string memory);
105 
106 
107     function symbol() external view returns (string memory);
108 
109 
110     function decimals() external view returns (uint8);
111 }
112 
113 
114 contract ERC20 is Context, IERC20, IERC20Metadata {
115     mapping(address => uint256) private _balances;
116 
117     mapping(address => mapping(address => uint256)) private _allowances;
118 
119     uint256 private _totalSupply;
120 
121     string private _name;
122     string private _symbol;
123 
124 
125     constructor(string memory name_, string memory symbol_) {
126         _name = name_;
127         _symbol = symbol_;
128     }
129 
130 
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135 
136     function symbol() public view virtual override returns (string memory) {
137         return _symbol;
138     }
139 
140     function decimals() public view virtual override returns (uint8) {
141         return 18;
142     }
143 
144 
145     function totalSupply() public view virtual override returns (uint256) {
146         return _totalSupply;
147     }
148 
149     function balanceOf(address account) public view virtual override returns (uint256) {
150         return _balances[account];
151     }
152 
153 
154     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
155         _transfer(_msgSender(), recipient, amount);
156         return true;
157     }
158 
159 
160     function allowance(address owner, address spender) public view virtual override returns (uint256) {
161         return _allowances[owner][spender];
162     }
163 
164 
165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
166         _approve(_msgSender(), spender, amount);
167         return true;
168     }
169 
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) public virtual override returns (bool) {
175         _transfer(sender, recipient, amount);
176 
177         uint256 currentAllowance = _allowances[sender][_msgSender()];
178         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
179         unchecked {
180             _approve(sender, _msgSender(), currentAllowance - amount);
181         }
182 
183         return true;
184     }
185 
186 
187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
189         return true;
190     }
191 
192 
193     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
194         uint256 currentAllowance = _allowances[_msgSender()][spender];
195         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
196         unchecked {
197             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
198         }
199 
200         return true;
201     }
202 
203 
204     function _transfer(
205         address sender,
206         address recipient,
207         uint256 amount
208     ) internal virtual {
209         require(sender != address(0), "ERC20: transfer from the zero address");
210         require(recipient != address(0), "ERC20: transfer to the zero address");
211 
212         _beforeTokenTransfer(sender, recipient, amount);
213 
214         uint256 senderBalance = _balances[sender];
215         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
216         unchecked {
217             _balances[sender] = senderBalance - amount;
218         }
219         _balances[recipient] += amount;
220 
221         emit Transfer(sender, recipient, amount);
222 
223         _afterTokenTransfer(sender, recipient, amount);
224     }
225 
226 
227     function _mint(address account, uint256 amount) internal virtual {
228         require(account != address(0), "ERC20: mint to the zero address");
229 
230         _beforeTokenTransfer(address(0), account, amount);
231 
232         _totalSupply += amount;
233         _balances[account] += amount;
234         emit Transfer(address(0), account, amount);
235 
236         _afterTokenTransfer(address(0), account, amount);
237     }
238 
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
257 
258     function _approve(
259         address owner,
260         address spender,
261         uint256 amount
262     ) internal virtual {
263         require(owner != address(0), "ERC20: approve from the zero address");
264         require(spender != address(0), "ERC20: approve to the zero address");
265 
266         _allowances[owner][spender] = amount;
267         emit Approval(owner, spender, amount);
268     }
269 
270 
271     function _beforeTokenTransfer(
272         address from,
273         address to,
274         uint256 amount
275     ) internal virtual {}
276 
277 
278     function _afterTokenTransfer(
279         address from,
280         address to,
281         uint256 amount
282     ) internal virtual {}
283 }
284 
285 contract TheLastMemeBender is Ownable, ERC20 {
286     bool public limited;
287     uint256 public maxWallet;
288     address public uniswapV2Pair;
289 
290     mapping(address => bool) public blackList;
291 
292     constructor() ERC20("TheLastMemeBender", "Appa") {
293         _mint(msg.sender, 100000000000 ether);
294         maxWallet = 5000000000 ether;
295         blackList[0x6b75d8AF000000e20B7a7DDf000Ba900b4009A80] = true;
296         blackList[0xae2Fc483527B8EF99EB5D9B44875F005ba1FaE13] = true;
297         uniswapV2Pair = 0x7885e359a085372EbCF1ed6829402f149D02c600;
298         limited = true;
299     }
300 
301     function setWalletRule(address _uniswapV2Pair, uint256 _maxWallet) external onlyOwner {
302         require(_maxWallet > 0, "maxWallet must be greater than zero");
303         uniswapV2Pair = _uniswapV2Pair;
304         maxWallet = _maxWallet;
305     }
306 
307     function _beforeTokenTransfer(
308         address from,
309         address to,
310         uint256 amount
311     ) override internal virtual {
312 
313         if (uniswapV2Pair == address(0)) {
314             require(from == owner() || to == owner(), "trading not open yet");
315             return;
316         }
317 
318         if (blackList[from] || blackList[to]) {
319             revert("Not This time Azula");
320         }
321 
322         if (limited && from == uniswapV2Pair) {
323             require(balanceOf(to) + amount <= maxWallet, "max wallet breached");
324         }
325     }
326 }