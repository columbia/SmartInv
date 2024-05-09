1 /*
2 Woolongcrypto.io
3 woolongstaking.com
4 Twitter/X = @Woolong_Crypto
5 TG = https://t.me/WoolongOfficial
6 */
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity ^0.8.0;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 pragma solidity ^0.8.0;
22 
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(
27         address indexed previousOwner,
28         address indexed newOwner
29     );
30 
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     modifier onlyOwner() {
36         _checkOwner();
37         _;
38     }
39 
40     function owner() public view virtual returns (address) {
41         return _owner;
42     }
43 
44     function _checkOwner() internal view virtual {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46     }
47 
48     function renounceOwnership() public virtual onlyOwner {
49         _transferOwnership(address(0));
50     }
51 
52     function transferOwnership(address newOwner) public virtual onlyOwner {
53         require(
54             newOwner != address(0),
55             "Ownable: new owner is the zero address"
56         );
57         _transferOwnership(newOwner);
58     }
59 
60     function _transferOwnership(address newOwner) internal virtual {
61         address oldOwner = _owner;
62         _owner = newOwner;
63         emit OwnershipTransferred(oldOwner, newOwner);
64     }
65 }
66 
67 pragma solidity ^0.8.0;
68 
69 interface IERC20 {
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     event Approval(
73         address indexed owner,
74         address indexed spender,
75         uint256 value
76     );
77 
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address account) external view returns (uint256);
81 
82     function transfer(address to, uint256 amount) external returns (bool);
83 
84     function allowance(
85         address owner,
86         address spender
87     ) external view returns (uint256);
88 
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     function transferFrom(
92         address from,
93         address to,
94         uint256 amount
95     ) external returns (bool);
96 }
97 
98 pragma solidity ^0.8.0;
99 
100 interface IERC20Metadata is IERC20 {
101     function name() external view returns (string memory);
102 
103     function symbol() external view returns (string memory);
104 
105     function decimals() external view returns (uint8);
106 }
107 
108 pragma solidity ^0.8.0;
109 
110 contract ERC20 is Context, IERC20, IERC20Metadata {
111     mapping(address => uint256) private _balances;
112 
113     mapping(address => mapping(address => uint256)) private _allowances;
114 
115     uint256 private _totalSupply;
116 
117     string private _name;
118     string private _symbol;
119 
120     constructor(string memory name_, string memory symbol_) {
121         _name = name_;
122         _symbol = symbol_;
123     }
124 
125     function name() public view virtual override returns (string memory) {
126         return _name;
127     }
128 
129     function symbol() public view virtual override returns (string memory) {
130         return _symbol;
131     }
132 
133     function decimals() public view virtual override returns (uint8) {
134         return 18;
135     }
136 
137     function totalSupply() public view virtual override returns (uint256) {
138         return _totalSupply;
139     }
140 
141     function balanceOf(
142         address account
143     ) public view virtual override returns (uint256) {
144         return _balances[account];
145     }
146 
147     function transfer(
148         address to,
149         uint256 amount
150     ) public virtual override returns (bool) {
151         address owner = _msgSender();
152         _transfer(owner, to, amount);
153         return true;
154     }
155 
156     function allowance(
157         address owner,
158         address spender
159     ) public view virtual override returns (uint256) {
160         return _allowances[owner][spender];
161     }
162 
163     function approve(
164         address spender,
165         uint256 amount
166     ) public virtual override returns (bool) {
167         address owner = _msgSender();
168         _approve(owner, spender, amount);
169         return true;
170     }
171 
172     function transferFrom(
173         address from,
174         address to,
175         uint256 amount
176     ) public virtual override returns (bool) {
177         address spender = _msgSender();
178         _spendAllowance(from, spender, amount);
179         _transfer(from, to, amount);
180         return true;
181     }
182 
183     function increaseAllowance(
184         address spender,
185         uint256 addedValue
186     ) public virtual returns (bool) {
187         address owner = _msgSender();
188         _approve(owner, spender, allowance(owner, spender) + addedValue);
189         return true;
190     }
191 
192     function decreaseAllowance(
193         address spender,
194         uint256 subtractedValue
195     ) public virtual returns (bool) {
196         address owner = _msgSender();
197         uint256 currentAllowance = allowance(owner, spender);
198         require(
199             currentAllowance >= subtractedValue,
200             "ERC20: decreased allowance below zero"
201         );
202         unchecked {
203             _approve(owner, spender, currentAllowance - subtractedValue);
204         }
205 
206         return true;
207     }
208 
209     function _transfer(
210         address from,
211         address to,
212         uint256 amount
213     ) internal virtual {
214         require(from != address(0), "ERC20: transfer from the zero address");
215         require(to != address(0), "ERC20: transfer to the zero address");
216 
217         _beforeTokenTransfer(from, to, amount);
218 
219         uint256 fromBalance = _balances[from];
220         require(
221             fromBalance >= amount,
222             "ERC20: transfer amount exceeds balance"
223         );
224         unchecked {
225             _balances[from] = fromBalance - amount;
226 
227             _balances[to] += amount;
228         }
229 
230         emit Transfer(from, to, amount);
231 
232         _afterTokenTransfer(from, to, amount);
233     }
234 
235     function _mint(address account, uint256 amount) internal virtual {
236         require(account != address(0), "ERC20: mint to the zero address");
237 
238         _beforeTokenTransfer(address(0), account, amount);
239 
240         _totalSupply += amount;
241         unchecked {
242             _balances[account] += amount;
243         }
244         emit Transfer(address(0), account, amount);
245 
246         _afterTokenTransfer(address(0), account, amount);
247     }
248 
249     function _burn(address account, uint256 amount) internal virtual {
250         require(account != address(0), "ERC20: burn from the zero address");
251 
252         _beforeTokenTransfer(account, address(0), amount);
253 
254         uint256 accountBalance = _balances[account];
255         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
256         unchecked {
257             _balances[account] = accountBalance - amount;
258             // Overflow not possible: amount <= accountBalance <= totalSupply.
259             _totalSupply -= amount;
260         }
261 
262         emit Transfer(account, address(0), amount);
263 
264         _afterTokenTransfer(account, address(0), amount);
265     }
266 
267     function _approve(
268         address owner,
269         address spender,
270         uint256 amount
271     ) internal virtual {
272         require(owner != address(0), "ERC20: approve from the zero address");
273         require(spender != address(0), "ERC20: approve to the zero address");
274 
275         _allowances[owner][spender] = amount;
276         emit Approval(owner, spender, amount);
277     }
278 
279     function _spendAllowance(
280         address owner,
281         address spender,
282         uint256 amount
283     ) internal virtual {
284         uint256 currentAllowance = allowance(owner, spender);
285         if (currentAllowance != type(uint256).max) {
286             require(
287                 currentAllowance >= amount,
288                 "ERC20: insufficient allowance"
289             );
290             unchecked {
291                 _approve(owner, spender, currentAllowance - amount);
292             }
293         }
294     }
295 
296     function _beforeTokenTransfer(
297         address from,
298         address to,
299         uint256 amount
300     ) internal virtual {}
301 
302     function _afterTokenTransfer(
303         address from,
304         address to,
305         uint256 amount
306     ) internal virtual {}
307 }
308 
309 pragma solidity ^0.8.9;
310 
311 contract Woolong is ERC20, Ownable {
312     constructor() ERC20("Woolong", "WNG") {
313         _mint(msg.sender, 1000000000 * 10 ** decimals());
314     }
315 }