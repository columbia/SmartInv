1 pragma solidity ^0.5.0;
2 
3 contract Context {
4 
5     constructor () internal { }
6 
7     function _msgSender() internal view returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 
18 interface IERC20 {
19 
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     function allowance(address owner, address spender) external view returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42 
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59         // benefit is lost if 'b' is also tested.
60         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
61         if (a == 0) {
62             return 0;
63         }
64 
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67 
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74 
75     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         // Solidity only automatically asserts when dividing by 0
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80 
81         return c;
82     }
83 
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         return mod(a, b, "SafeMath: modulo by zero");
86     }
87 
88     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b != 0, errorMessage);
90         return a % b;
91     }
92 }
93 
94 contract ERC20 is Context, IERC20 {
95     using SafeMath for uint256;
96 
97     mapping (address => uint256) private _balances;
98 
99     mapping (address => mapping (address => uint256)) private _allowances;
100 
101     uint256 private _totalSupply;
102 
103     function totalSupply() public view returns (uint256) {
104         return _totalSupply;
105     }
106 
107     function balanceOf(address account) public view returns (uint256) {
108         return _balances[account];
109     }
110 
111     function transfer(address recipient, uint256 amount) public returns (bool) {
112         _transfer(_msgSender(), recipient, amount);
113         return true;
114     }
115 
116     function allowance(address owner, address spender) public view returns (uint256) {
117         return _allowances[owner][spender];
118     }
119 
120     function approve(address spender, uint256 amount) public returns (bool) {
121         _approve(_msgSender(), spender, amount);
122         return true;
123     }
124 
125     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
126         _transfer(sender, recipient, amount);
127         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
128         return true;
129     }
130 
131     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
132         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
133         return true;
134     }
135 
136     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
137         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
138         return true;
139     }
140 
141     function _transfer(address sender, address recipient, uint256 amount) internal {
142         require(sender != address(0), "ERC20: transfer from the zero address");
143         require(recipient != address(0), "ERC20: transfer to the zero address");
144 
145         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
146         _balances[recipient] = _balances[recipient].add(amount);
147         emit Transfer(sender, recipient, amount);
148     }
149 
150     function _mint(address account, uint256 amount) internal {
151         require(account != address(0), "ERC20: mint to the zero address");
152 
153         _totalSupply = _totalSupply.add(amount);
154         _balances[account] = _balances[account].add(amount);
155         emit Transfer(address(0), account, amount);
156     }
157 
158     function _burn(address account, uint256 amount) internal {
159         require(account != address(0), "ERC20: burn from the zero address");
160 
161         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
162         _totalSupply = _totalSupply.sub(amount);
163         emit Transfer(account, address(0), amount);
164     }
165 
166     function _approve(address owner, address spender, uint256 amount) internal {
167         require(owner != address(0), "ERC20: approve from the zero address");
168         require(spender != address(0), "ERC20: approve to the zero address");
169 
170         _allowances[owner][spender] = amount;
171         emit Approval(owner, spender, amount);
172     }
173 
174     function _burnFrom(address account, uint256 amount) internal {
175         _burn(account, amount);
176         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
177     }
178 }
179 
180 contract ERC20Burnable is Context, ERC20 {
181 
182     function burn(uint256 amount) public {
183         _burn(_msgSender(), amount);
184     }
185 
186     function burnFrom(address account, uint256 amount) public {
187         _burnFrom(account, amount);
188     }
189 }
190 
191 library Roles {
192     struct Role {
193         mapping (address => bool) bearer;
194     }
195 
196     function add(Role storage role, address account) internal {
197         require(!has(role, account), "Roles: account already has role");
198         role.bearer[account] = true;
199     }
200 
201     function remove(Role storage role, address account) internal {
202         require(has(role, account), "Roles: account does not have role");
203         role.bearer[account] = false;
204     }
205 
206     function has(Role storage role, address account) internal view returns (bool) {
207         require(account != address(0), "Roles: account is the zero address");
208         return role.bearer[account];
209     }
210 }
211 
212 
213 contract MinterRole is Context {
214     using Roles for Roles.Role;
215 
216     event MinterAdded(address indexed account);
217     event MinterRemoved(address indexed account);
218 
219     Roles.Role private _minters;
220 
221     constructor () internal {
222         _addMinter(_msgSender());
223     }
224 
225     modifier onlyMinter() {
226         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
227         _;
228     }
229 
230     function isMinter(address account) public view returns (bool) {
231         return _minters.has(account);
232     }
233 
234     function addMinter(address account) public onlyMinter {
235         _addMinter(account);
236     }
237 
238     function renounceMinter() public {
239         _removeMinter(_msgSender());
240     }
241 
242     function _addMinter(address account) internal {
243         _minters.add(account);
244         emit MinterAdded(account);
245     }
246 
247     function _removeMinter(address account) internal {
248         _minters.remove(account);
249         emit MinterRemoved(account);
250     }
251 }
252 
253 contract ERC20Mintable is ERC20, MinterRole {
254 
255     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
256         _mint(account, amount);
257         return true;
258     }
259 }
260 
261 contract ERC20Detailed is IERC20 {
262     string private _name;
263     string private _symbol;
264     uint8 private _decimals;
265 
266     constructor (string memory name, string memory symbol, uint8 decimals) public {
267         _name = name;
268         _symbol = symbol;
269         _decimals = decimals;
270     }
271 
272     function name() public view returns (string memory) {
273         return _name;
274     }
275 
276     function symbol() public view returns (string memory) {
277         return _symbol;
278     }
279 
280     function decimals() public view returns (uint8) {
281         return _decimals;
282     }
283 }
284 
285 contract Ownable is Context {
286     address private _owner;
287 
288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290     constructor () internal {
291         _owner = _msgSender();
292         emit OwnershipTransferred(address(0), _owner);
293     }
294 
295     function owner() public view returns (address) {
296         return _owner;
297     }
298 
299     modifier onlyOwner() {
300         require(isOwner(), "Ownable: caller is not the owner");
301         _;
302     }
303 
304     function isOwner() public view returns (bool) {
305         return _msgSender() == _owner;
306     }
307 
308     function renounceOwnership() public onlyOwner {
309         emit OwnershipTransferred(_owner, address(0));
310         _owner = address(0);
311     }
312 
313     function transferOwnership(address newOwner) public onlyOwner {
314         _transferOwnership(newOwner);
315     }
316 
317     function _transferOwnership(address newOwner) internal {
318         require(newOwner != address(0), "Ownable: new owner is the zero address");
319         emit OwnershipTransferred(_owner, newOwner);
320         _owner = newOwner;
321     }
322 }
323 
324 contract DHFToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable, Ownable {
325     constructor() ERC20Detailed("DHFToken", "DHF", 18) public {
326         
327     }
328 }