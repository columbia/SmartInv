1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.6.6;
4 
5 library SafeMath {
6 
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10 
11         return c;
12     }
13 
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         return sub(a, b, "SafeMath: subtraction overflow");
17     }
18 
19 
20     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23 
24         return c;
25     }
26 
27 
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38 
39 
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43 
44 
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         return c;
49     }
50 
51 
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         return mod(a, b, "SafeMath: modulo by zero");
54     }
55 
56 
57     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b != 0, errorMessage);
59         return a % b;
60     }
61 }
62 
63 
64 interface IERC20 {
65 
66     function totalSupply() external view returns (uint256);
67 
68     function balanceOf(address account) external view returns (uint256);
69 
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 abstract contract Context {
84     function _msgSender() internal view virtual returns (address payable) {
85         return msg.sender;
86     }
87 
88     function _msgData() internal view virtual returns (bytes memory) {
89         this;
90         return msg.data;
91     }
92 }
93 
94 abstract contract Pausable is Context {
95 
96     event Paused(address account);
97 
98 
99     event Unpaused(address account);
100 
101     bool private _paused;
102 
103     constructor () internal {
104         _paused = false;
105     }
106 
107 
108     function paused() public view returns (bool) {
109         return _paused;
110     }
111 
112 
113     modifier whenNotPaused() {
114         require(!_paused, "Pausable: paused");
115         _;
116     }
117 
118 
119     modifier whenPaused() {
120         require(_paused, "Pausable: not paused");
121         _;
122     }
123 
124 
125     function _pause() internal virtual whenNotPaused {
126         _paused = true;
127         emit Paused(_msgSender());
128     }
129 
130 
131     function _unpause() internal virtual whenPaused {
132         _paused = false;
133         emit Unpaused(_msgSender());
134     }
135 }
136 
137 contract ERC20 is Context, IERC20 {
138     using SafeMath for uint256;
139 
140     mapping (address => uint256) private _balances;
141 
142     mapping (address => mapping (address => uint256)) private _allowances;
143 
144     uint256 private _totalSupply;
145 	
146     string private _name;
147     string private _symbol;
148     uint8 private _decimals;
149 
150     constructor (string memory name_, string memory symbol_, uint8 decimals_) public {
151         _name = name_;
152         _symbol = symbol_;
153         _decimals = decimals_;
154     }
155 
156     function name() public view returns (string memory) {
157         return _name;
158     }
159 
160 
161     function symbol() public view returns (string memory) {
162         return _symbol;
163     }
164 
165 
166     function decimals() public view returns (uint8) {
167         return _decimals;
168     }
169 
170 
171     function totalSupply() public view override returns (uint256) {
172         return _totalSupply;
173     }
174 
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return _balances[account];
178     }
179 
180 
181     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186 
187     function allowance(address owner, address spender) public view virtual override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191 
192     function approve(address spender, uint256 amount) public virtual override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204 
205     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
206         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
207         return true;
208     }
209 
210     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
211         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
212         return true;
213     }
214 
215     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
216         require(sender != address(0), "ERC20: transfer from the zero address");
217         require(recipient != address(0), "ERC20: transfer to the zero address");
218 
219         _beforeTokenTransfer(sender, recipient, amount);
220 
221         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
222         _balances[recipient] = _balances[recipient].add(amount);
223         emit Transfer(sender, recipient, amount);
224     }
225 
226 
227     function _mint(address account, uint256 amount) internal virtual {
228         require(account != address(0), "ERC20: mint to the zero address");
229 
230         _beforeTokenTransfer(address(0), account, amount);
231 
232         _totalSupply = _totalSupply.add(amount);
233         _balances[account] = _balances[account].add(amount);
234         emit Transfer(address(0), account, amount);
235     }
236 
237 
238     function _burn(address account, uint256 amount) internal virtual {
239         require(account != address(0), "ERC20: burn from the zero address");
240 
241         _beforeTokenTransfer(account, address(0), amount);
242 
243         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
244         _totalSupply = _totalSupply.sub(amount);
245         emit Transfer(account, address(0), amount);
246     }
247 
248     function _approve(address owner, address spender, uint256 amount) internal virtual {
249         require(owner != address(0), "ERC20: approve from the zero address");
250         require(spender != address(0), "ERC20: approve to the zero address");
251 
252         _allowances[owner][spender] = amount;
253         emit Approval(owner, spender, amount);
254     }
255 
256     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
257 }
258 
259 abstract contract ERC20Pausable is ERC20, Pausable {
260     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
261         super._beforeTokenTransfer(from, to, amount);
262 
263         require(!paused(), "ERC20Pausable: token transfer while paused");
264     }
265 }
266 
267 contract ChaingeWrappedToken is ERC20Pausable {
268     address public owner;
269     address public controller;
270     constructor(string memory name, string memory symbol,uint8 decimal) public ERC20(name,symbol, decimal) {
271         owner = msg.sender;
272 		controller = msg.sender;
273     }
274 
275     modifier onlyOwner() {
276         require(msg.sender == owner,"only owner");
277         _;
278     }
279 
280     modifier onlyController() {
281         require(msg.sender == controller || msg.sender == owner ,"only controller");
282         _;
283     }
284 
285     function pause() public  onlyController {
286         _pause();
287     }
288 
289     function unpause() public  onlyController {
290         _unpause();
291     }
292 
293     function setOwner(address newOwner) public onlyOwner {
294 		owner = newOwner;
295     }
296 
297     function setController(address newController) public onlyOwner {
298 		controller = newController;
299     }
300 
301     function mint(address account, uint256 amount) public whenNotPaused onlyController {
302         _mint(account, amount);
303     }
304 	
305     function burn(address account , uint256 amount) public whenNotPaused onlyController {
306         _burn(account,amount);
307     }
308 }