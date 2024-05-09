1 pragma solidity ^0.5.0;
2 
3 contract Context {
4     constructor () internal { }
5 
6     function _msgSender() internal view returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view returns (bytes memory) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30 
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32 
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36 
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 
41 
42 library SafeMath {
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47 
48         return c;
49     }
50 
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63 
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83 
84     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         // Solidity only automatically asserts when dividing by 0
86         require(b > 0, errorMessage);
87         uint256 c = a / b;
88         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89 
90         return c;
91     }
92 
93 
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         return mod(a, b, "SafeMath: modulo by zero");
96     }
97 
98 
99     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b != 0, errorMessage);
101         return a % b;
102     }
103 }
104 
105 
106 
107 
108 
109 contract ERC20 is Context, IERC20 {
110     using SafeMath for uint256;
111 
112     mapping (address => uint256) private _balances;
113 
114     mapping (address => mapping (address => uint256)) private _allowances;
115 
116     uint256 private _totalSupply;
117 
118 
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     function balanceOf(address account) public view returns (uint256) {
124         return _balances[account];
125     }
126 
127 
128     function transfer(address recipient, uint256 amount) public returns (bool) {
129         _transfer(_msgSender(), recipient, amount);
130         return true;
131     }
132 
133 
134     function allowance(address owner, address spender) public view returns (uint256) {
135         return _allowances[owner][spender];
136     }
137 
138 
139     function approve(address spender, uint256 amount) public returns (bool) {
140         _approve(_msgSender(), spender, amount);
141         return true;
142     }
143 
144 
145     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
146         _transfer(sender, recipient, amount);
147         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
148         return true;
149     }
150 
151 
152     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
153         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
154         return true;
155     }
156 
157 
158     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
159         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
160         return true;
161     }
162 
163 
164     function _transfer(address sender, address recipient, uint256 amount) internal {
165         require(sender != address(0), "ERC20: transfer from the zero address");
166         require(recipient != address(0), "ERC20: transfer to the zero address");
167 
168         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
169         _balances[recipient] = _balances[recipient].add(amount);
170         emit Transfer(sender, recipient, amount);
171     }
172 
173 
174     function _mint(address account, uint256 amount) internal {
175         require(account != address(0), "ERC20: mint to the zero address");
176 
177         _totalSupply = _totalSupply.add(amount);
178         _balances[account] = _balances[account].add(amount);
179         emit Transfer(address(0), account, amount);
180     }
181 
182 
183     function _burn(address account, uint256 amount) internal {
184         require(account != address(0), "ERC20: burn from the zero address");
185 
186         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
187         _totalSupply = _totalSupply.sub(amount);
188         emit Transfer(account, address(0), amount);
189     }
190 
191 
192     function _approve(address owner, address spender, uint256 amount) internal {
193         require(owner != address(0), "ERC20: approve from the zero address");
194         require(spender != address(0), "ERC20: approve to the zero address");
195 
196         _allowances[owner][spender] = amount;
197         emit Approval(owner, spender, amount);
198     }
199 
200 
201     function _burnFrom(address account, uint256 amount) internal {
202         _burn(account, amount);
203         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
204     }
205 }
206 
207 
208 
209 
210 
211 
212 contract ERC20Burnable is Context, ERC20 {
213 
214     function burn(uint256 amount) public {
215         _burn(_msgSender(), amount);
216     }
217 
218 
219     function burnFrom(address account, uint256 amount) public {
220         _burnFrom(account, amount);
221     }
222 }
223 
224 
225 
226 
227 library Roles {
228     struct Role {
229         mapping (address => bool) bearer;
230     }
231 
232 
233     function add(Role storage role, address account) internal {
234         require(!has(role, account), "Roles: account already has role");
235         role.bearer[account] = true;
236     }
237 
238 
239     function remove(Role storage role, address account) internal {
240         require(has(role, account), "Roles: account does not have role");
241         role.bearer[account] = false;
242     }
243 
244 
245     function has(Role storage role, address account) internal view returns (bool) {
246         require(account != address(0), "Roles: account is the zero address");
247         return role.bearer[account];
248     }
249 }
250 
251 
252 
253 
254 contract MinterRole is Context {
255     using Roles for Roles.Role;
256 
257     event MinterAdded(address indexed account);
258     event MinterRemoved(address indexed account);
259 
260     Roles.Role private _minters;
261 
262     constructor () internal {
263         _addMinter(_msgSender());
264     }
265 
266     modifier onlyMinter() {
267         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
268         _;
269     }
270 
271     function isMinter(address account) public view returns (bool) {
272         return _minters.has(account);
273     }
274 
275     function addMinter(address account) public onlyMinter {
276         _addMinter(account);
277     }
278 
279     function renounceMinter() public {
280         _removeMinter(_msgSender());
281     }
282 
283     function _addMinter(address account) internal {
284         _minters.add(account);
285         emit MinterAdded(account);
286     }
287 
288     function _removeMinter(address account) internal {
289         _minters.remove(account);
290         emit MinterRemoved(account);
291     }
292 }
293 
294 
295 
296 
297 
298 
299 contract ERC20Mintable is ERC20, MinterRole {
300 
301     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
302         _mint(account, amount);
303         return true;
304     }
305 }
306 
307 
308 
309 
310 contract ERC20Detailed is IERC20 {
311     string private _name;
312     string private _symbol;
313     uint8 private _decimals;
314 
315 
316     constructor (string memory name, string memory symbol, uint8 decimals) public {
317         _name = name;
318         _symbol = symbol;
319         _decimals = decimals;
320     }
321 
322 
323     function name() public view returns (string memory) {
324         return _name;
325     }
326 
327 
328     function symbol() public view returns (string memory) {
329         return _symbol;
330     }
331 
332 
333     function decimals() public view returns (uint8) {
334         return _decimals;
335     }
336 }
337 
338 
339 
340 
341 contract NzinCoin is ERC20Mintable, ERC20Burnable, ERC20Detailed {
342 
343     constructor (address owner) public ERC20Detailed("Nzin Coin", "NZC", 18) {
344 
345         _mint(owner, 1000000000 * (10 ** uint256(decimals())));
346 
347         _addMinter(owner);
348         
349         
350     }
351 
352 }