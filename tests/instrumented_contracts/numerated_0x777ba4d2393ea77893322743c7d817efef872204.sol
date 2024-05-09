1 // SPDX-License-Identifier: UNLICENSED
2 
3 //............................................................................................
4 //.....................................................................SSSSSS.................
5 //.WWWW..WWWWW..WWWW..333333...BBBBBBBBBB...PPPPPPPPPP..UUUU...UUUU...SSSSSSSS...HHHH...HHHH..
6 //.WWWW..WWWWW..WWWW.33333333..BBBBBBBBBBB..PPPPPPPPPP..UUUU...UUUU..SSSSSSSSSS..HHHH...HHHH..
7 //.WWWW..WWWWW..WWWW333333333..BBBBBBBBBBB..PPPPPPPPPPP.UUUU...UUUU..SSSSSSSSSS..HHHH...HHHH..
8 //..WWWW.WWWWW.WWWW.3333.3333..BBBB...BBBB..PPPP...PPPP.UUUU...UUUU.USSS...SSSSS.HHHH...HHHH..
9 //..WWWWWWWWWWWWWWW.3333.3333..BBBB..BBBBB..PPPP...PPPP.UUUU...UUUU.USSSSS.......HHHHHHHHHHH..
10 //..WWWWWWWWWWWWWWW....333333..BBBBBBBBBBB..PPPPPPPPPPP.UUUU...UUUU..SSSSSSSSS...HHHHHHHHHHH..
11 //..WWWWWWWWWWWWWWW....333333..BBBBBBBBBBB..PPPPPPPPPPP.UUUU...UUUU..SSSSSSSSSS..HHHHHHHHHHH..
12 //...WWWWWW.WWWWWW.....3333333.BBBBBBBBBBB..PPPPPPPPPP..UUUU...UUUU....SSSSSSSSS.HHHHHHHHHHH..
13 //...WWWWWW.WWWWWW..3333..3333.BBBB....BBBB.PPPPPPPPP...UUUU...UUUU.USSS..SSSSSS.HHHH...HHHH..
14 //...WWWWWW.WWWWWW..3333..3333.BBBB...BBBBB.PPPP........UUUU...UUUU.USSS....SSSS.HHHH...HHHH..
15 //....WWWWW.WWWWW...3333333333.BBBBBBBBBBB..PPPP........UUUUUUUUUUU.USSSSSSSSSSS.HHHH...HHHH..
16 //....WWWW...WWWW...333333333..BBBBBBBBBBB..PPPP........UUUUUUUUUUU..SSSSSSSSSS..HHHH...HHHH..
17 //....WWWW...WWWW....33333333..BBBBBBBBBB...PPPP.........UUUUUUUUU....SSSSSSSSS..HHHH...HHHH..
18 //.....................3333................................UUUUU.......SSSSSS.................
19 //............................................................................................
20 
21 pragma solidity ^0.7.0;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this;
30         return msg.data;
31     }
32 }
33 
34 interface IERC20 {
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address account) external view returns (uint256);
38 
39     function transfer(address recipient, uint256 amount)
40         external
41         returns (bool);
42 
43     function allowance(address owner, address spender)
44         external
45         view
46         returns (uint256);
47 
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     function transferFrom(
51         address sender,
52         address recipient,
53         uint256 amount
54     ) external returns (bool);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58     event Approval(
59         address indexed owner,
60         address indexed spender,
61         uint256 value
62     );
63 }
64 
65 library SafeMath {
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a, "SafeMath: addition overflow");
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     function sub(
77         uint256 a,
78         uint256 b,
79         string memory errorMessage
80     ) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83         return c;
84     }
85 
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         if (a == 0) {
88             return 0;
89         }
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92         return c;
93     }
94 
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return div(a, b, "SafeMath: division by zero");
97     }
98 
99     function div(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         return c;
107     }
108 
109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
110         return mod(a, b, "SafeMath: modulo by zero");
111     }
112 
113     function mod(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b != 0, errorMessage);
119         return a % b;
120     }
121 }
122 
123 contract ERC20 is Context, IERC20 {
124     using SafeMath for uint256;
125 
126     mapping(address => uint256) private _balances;
127 
128     mapping(address => mapping(address => uint256)) private _allowances;
129 
130     uint256 private _totalSupply;
131     string private _name;
132     string private _symbol;
133     uint8 private _decimals;
134 
135     constructor(
136         string memory name_,
137         string memory symbol_,
138         uint8 decimals_
139     ) {
140         _name = name_;
141         _symbol = symbol_;
142         _decimals = decimals_;
143     }
144 
145     function name() public view returns (string memory) {
146         return _name;
147     }
148 
149     function symbol() public view returns (string memory) {
150         return _symbol;
151     }
152 
153     function decimals() public view returns (uint8) {
154         return _decimals;
155     }
156 
157     function totalSupply() public view override returns (uint256) {
158         return _totalSupply;
159     }
160 
161     function balanceOf(address account) public view override returns (uint256) {
162         return _balances[account];
163     }
164 
165     function transfer(address recipient, uint256 amount)
166         public
167         virtual
168         override
169         returns (bool)
170     {
171         _transfer(_msgSender(), recipient, amount);
172         return true;
173     }
174 
175     function allowance(address owner, address spender)
176         public
177         view
178         virtual
179         override
180         returns (uint256)
181     {
182         return _allowances[owner][spender];
183     }
184 
185     function approve(address spender, uint256 amount)
186         public
187         virtual
188         override
189         returns (bool)
190     {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     function transferFrom(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) public virtual override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(
202             sender,
203             _msgSender(),
204             _allowances[sender][_msgSender()].sub(
205                 amount,
206                 "ERC20: transfer amount exceeds allowance"
207             )
208         );
209         return true;
210     }
211 
212     function increaseAllowance(address spender, uint256 addedValue)
213         public
214         virtual
215         returns (bool)
216     {
217         _approve(
218             _msgSender(),
219             spender,
220             _allowances[_msgSender()][spender].add(addedValue)
221         );
222         return true;
223     }
224 
225     function decreaseAllowance(address spender, uint256 subtractedValue)
226         public
227         virtual
228         returns (bool)
229     {
230         _approve(
231             _msgSender(),
232             spender,
233             _allowances[_msgSender()][spender].sub(
234                 subtractedValue,
235                 "ERC20: decreased allowance below zero"
236             )
237         );
238         return true;
239     }
240 
241     function _transfer(
242         address sender,
243         address recipient,
244         uint256 amount
245     ) internal virtual {
246         require(sender != address(0), "ERC20: transfer from the zero address");
247         require(recipient != address(0), "ERC20: transfer to the zero address");
248 
249         _beforeTokenTransfer(sender, recipient, amount);
250 
251         _balances[sender] = _balances[sender].sub(
252             amount,
253             "ERC20: transfer amount exceeds balance"
254         );
255         _balances[recipient] = _balances[recipient].add(amount);
256         emit Transfer(sender, recipient, amount);
257     }
258 
259     function _mint(address account, uint256 amount) internal virtual {
260         require(account != address(0), "ERC20: mint to the zero address");
261 
262         _beforeTokenTransfer(address(0), account, amount);
263 
264         _totalSupply = _totalSupply.add(amount);
265         _balances[account] = _balances[account].add(amount);
266         emit Transfer(address(0), account, amount);
267     }
268 
269     function _burn(address account, uint256 amount) internal virtual {
270         require(account != address(0), "ERC20: burn from the zero address");
271 
272         _beforeTokenTransfer(account, address(0), amount);
273 
274         _balances[account] = _balances[account].sub(
275             amount,
276             "ERC20: burn amount exceeds balance"
277         );
278         _totalSupply = _totalSupply.sub(amount);
279         emit Transfer(account, address(0), amount);
280     }
281 
282     function _approve(
283         address owner,
284         address spender,
285         uint256 amount
286     ) internal virtual {
287         require(owner != address(0), "ERC20: approve from the zero address");
288         require(spender != address(0), "ERC20: approve to the zero address");
289 
290         _allowances[owner][spender] = amount;
291         emit Approval(owner, spender, amount);
292     }
293 
294     function _setupDecimals(uint8 decimals_) internal virtual {
295         _decimals = decimals_;
296     }
297 
298     function _beforeTokenTransfer(
299         address from,
300         address to,
301         uint256 amount
302     ) internal virtual {}
303 }
304 
305 /*
306     W3bPush is notification ecosystem for DApps and CApps.
307 */
308 contract W3bPush is ERC20 {
309     using SafeMath for uint256;
310 
311     uint8 public constant _DECIMALS = 18;
312     uint256 private _totalSupply = 1000000 * (10**uint256(_DECIMALS));
313     address private _contractDeployer;
314 
315     constructor() ERC20("W3bPush", "W3B", _DECIMALS) {
316         _contractDeployer = msg.sender;
317         _mint(_contractDeployer, _totalSupply);
318     }
319 
320     function burn(uint256 amount) public {
321         _burn(msg.sender, amount);
322     }
323 }