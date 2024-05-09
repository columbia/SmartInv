1 //SPDX-License-Identifier: ChaingeFinance
2 
3 /*
4 Contract name: ChaingeToken
5 Compiler version: v0.6.6+commit.6c089d20
6 Optimization enabled: true
7 Optimization runs: 200
8 */
9 
10 pragma solidity =0.6.6;
11 
12 library SafeMath {
13 
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         return sub(a, b, "SafeMath: subtraction overflow");
24     }
25 
26 
27     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require(b <= a, errorMessage);
29         uint256 c = a - b;
30 
31         return c;
32     }
33 
34 
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45 
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50 
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         return mod(a, b, "SafeMath: modulo by zero");
61     }
62 
63 
64     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b != 0, errorMessage);
66         return a % b;
67     }
68 }
69 
70 
71 interface IERC20 {
72 
73     function totalSupply() external view returns (uint256);
74 
75     function balanceOf(address account) external view returns (uint256);
76 
77     function transfer(address recipient, uint256 amount) external returns (bool);
78 
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address payable) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes memory) {
95         this;
96         return msg.data;
97     }
98 }
99 
100 
101 abstract contract Pausable is Context {
102 
103     event Paused(address account);
104 
105 
106     event Unpaused(address account);
107 
108     bool private _paused;
109 
110     constructor () internal {
111         _paused = false;
112     }
113 
114 
115     function paused() public view returns (bool) {
116         return _paused;
117     }
118 
119 
120     modifier whenNotPaused() {
121         require(!_paused, "Pausable: paused");
122         _;
123     }
124 
125 
126     modifier whenPaused() {
127         require(_paused, "Pausable: not paused");
128         _;
129     }
130 
131 
132     function _pause() internal virtual whenNotPaused {
133         _paused = true;
134         emit Paused(_msgSender());
135     }
136 
137 
138     function _unpause() internal virtual whenPaused {
139         _paused = false;
140         emit Unpaused(_msgSender());
141     }
142 }
143 contract ERC20 is Context, IERC20 {
144     using SafeMath for uint256;
145 
146     mapping (address => uint256) private _balances;
147 
148     mapping (address => mapping (address => uint256)) private _allowances;
149 
150     uint256 private _totalSupply;
151 	
152     string private _name;
153     string private _symbol;
154     uint8 private _decimals;
155 
156     constructor (string memory name_, string memory symbol_, uint8 decimals_) public {
157         _name = name_;
158         _symbol = symbol_;
159         _decimals = decimals_;
160     }
161 
162     function name() public view returns (string memory) {
163         return _name;
164     }
165 
166 
167     function symbol() public view returns (string memory) {
168         return _symbol;
169     }
170 
171 
172     function decimals() public view returns (uint8) {
173         return _decimals;
174     }
175 
176 
177     function totalSupply() public view override returns (uint256) {
178         return _totalSupply;
179     }
180 
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return _balances[account];
184     }
185 
186 
187     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
188         _transfer(_msgSender(), recipient, amount);
189         return true;
190     }
191 
192 
193     function allowance(address owner, address spender) public view virtual override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197 
198     function approve(address spender, uint256 amount) public virtual override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203 
204     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209 
210 
211     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
212         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
213         return true;
214     }
215 
216     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
217         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
218         return true;
219     }
220 
221     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
222         require(sender != address(0), "ERC20: transfer from the zero address");
223         require(recipient != address(0), "ERC20: transfer to the zero address");
224 
225         _beforeTokenTransfer(sender, recipient, amount);
226 
227         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
228         _balances[recipient] = _balances[recipient].add(amount);
229         emit Transfer(sender, recipient, amount);
230     }
231 
232 
233     function _mint(address account, uint256 amount) internal virtual {
234         require(account != address(0), "ERC20: mint to the zero address");
235 
236         _beforeTokenTransfer(address(0), account, amount);
237 
238         _totalSupply = _totalSupply.add(amount);
239         _balances[account] = _balances[account].add(amount);
240         emit Transfer(address(0), account, amount);
241     }
242 
243 
244     function _burn(address account, uint256 amount) internal virtual {
245         require(account != address(0), "ERC20: burn from the zero address");
246 
247         _beforeTokenTransfer(account, address(0), amount);
248 
249         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
250         _totalSupply = _totalSupply.sub(amount);
251         emit Transfer(account, address(0), amount);
252     }
253 
254     function _approve(address owner, address spender, uint256 amount) internal virtual {
255         require(owner != address(0), "ERC20: approve from the zero address");
256         require(spender != address(0), "ERC20: approve to the zero address");
257 
258         _allowances[owner][spender] = amount;
259         emit Approval(owner, spender, amount);
260     }
261 
262     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
263 }
264 abstract contract ERC20Pausable is ERC20, Pausable {
265     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
266         super._beforeTokenTransfer(from, to, amount);
267 
268         require(!paused(), "ERC20Pausable: token transfer while paused");
269     }
270 }
271 contract ERC20Template is ERC20Pausable {
272     address owner;
273     address controller;
274     address pauser;
275     constructor(string memory name, string memory symbol,uint8 decimal) public ERC20(name,symbol, decimal) {
276         owner = msg.sender;
277 		controller = msg.sender;
278 		pauser = msg.sender;
279     }
280 
281     modifier onlyOwner(){
282         require(msg.sender == owner,"only owner");
283         _;
284     }
285     modifier onlyController(){
286         require(msg.sender == controller,"not allowed");
287         _;
288     }
289     modifier onlyPauser(){
290         require(msg.sender == pauser,"not allowed");
291         _;
292     }
293 
294     function pause() public  onlyPauser{
295         _pause();
296     }
297 
298     function unpause() public  onlyPauser{
299         _unpause();
300     }
301 
302     function setAdmin(address new_controller, address new_pauser) public onlyOwner{
303         controller = new_controller;
304 		pauser = new_pauser;
305     }
306 
307     function mint(address account, uint256 amount) public whenNotPaused onlyController {
308         _mint(account, amount);
309     }
310 	
311     function burn(address account , uint256 amount) public whenNotPaused onlyController {
312         _burn(account,amount);
313     }
314 }