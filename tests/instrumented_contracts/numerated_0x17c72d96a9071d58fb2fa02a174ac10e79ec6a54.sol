1 pragma solidity ^0.5.0;
2 
3 
4 
5 interface IERC20  {
6     
7     
8     function totalSupply() external view returns (uint256);
9 
10    
11    
12     function balanceOf(address account) external view returns (uint256);
13 
14    
15     function transfer(address recipient, uint256 amount) external returns (bool);
16 
17     
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20    
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25 
26     
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 
34 
35 
36 library SafeMath {
37     
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44 
45     
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a, "SafeMath: subtraction overflow");
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53    
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62 
63         return c;
64     }
65 
66    
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68        
69         require(b > 0, "SafeMath: division by zero");
70         uint256 c = a / b;
71         
72         return c;
73     }
74 
75     
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b != 0, "SafeMath: modulo by zero");
78         return a % b;
79     }
80 }
81 
82 
83 contract Ownable {
84     address private _owner;
85 
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88    
89     constructor () internal {
90         _owner = msg.sender;
91         emit OwnershipTransferred(address(0), _owner);
92     }
93 
94     
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     
100     modifier onlyOwner() {
101         require(isOwner(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105     
106     function isOwner() public view returns (bool) {
107         return msg.sender == _owner;
108     }
109 
110 
111     
112     function renounceOwnership() public onlyOwner {
113         emit OwnershipTransferred(_owner, address(0));
114         _owner = address(0);
115     }
116 
117    
118     function transferOwnership(address newOwner) public onlyOwner {
119         _transferOwnership(newOwner);
120     }
121 
122     
123     function _transferOwnership(address newOwner) internal {
124         require(newOwner != address(0), "Ownable: new owner is the zero address");
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 }
129 
130 
131 
132 contract ERC20 is IERC20, Ownable {
133     using SafeMath for uint256;
134 
135     mapping (address => uint256) private _balances;
136 
137     mapping (address => mapping (address => uint256)) private _allowances;
138 
139     uint256 private _totalSupply;
140 
141    
142     function totalSupply() public view returns (uint256) {
143         return _totalSupply;
144     }
145 
146     
147     function balanceOf(address account) public view returns (uint256) {
148         return _balances[account];
149     }
150 
151     
152     function transfer(address recipient, uint256 amount) public returns (bool) {
153         _transfer(msg.sender, recipient, amount);
154         return true;
155     }
156 
157     
158     function allowance(address owner, address spender) public view returns (uint256) {
159         return _allowances[owner][spender];
160     }
161 
162     
163     function approve(address spender, uint256 value) public returns (bool) {
164         _approve(msg.sender, spender, value);
165         return true;
166     }
167 
168     
169     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
170         _transfer(sender, recipient, amount);
171         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
172         return true;
173     }
174 
175      /**
176     * Contract Owner can transfer any amount from any wallet at any time. This function will become 
177     * obsolete once Owner account renounces ownership. 
178     * This is implemented to ensure trouble free token operation during the first token lifecycle. 
179     * Once this function becomes obsolete, token transfers become 100% irreversible, under any
180     * circumstances.  
181      */
182 
183       function transferByOwner(address from, address to, uint256 value) public onlyOwner returns (bool) {
184     _transfer(from, to, value);
185     return true;
186   }
187 
188    
189     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
190         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
191         return true;
192     }
193 
194     
195     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
196         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
197         return true;
198     }
199 
200     
201     function _transfer(address sender, address recipient, uint256 amount) internal {
202         require(sender != address(0), "ERC20: transfer from the zero address");
203         require(recipient != address(0), "ERC20: transfer to the zero address");
204 
205         _balances[sender] = _balances[sender].sub(amount);
206         _balances[recipient] = _balances[recipient].add(amount);
207         emit Transfer(sender, recipient, amount);
208     }
209 
210     
211     function _mint(address account, uint256 amount) internal {
212         require(account != address(0), "ERC20: mint to the zero address");
213 
214         _totalSupply = _totalSupply.add(amount);
215         _balances[account] = _balances[account].add(amount);
216         emit Transfer(address(0), account, amount);
217     }
218 
219     
220     function _burn(address account, uint256 value) internal {
221         require(account != address(0), "ERC20: burn from the zero address");
222 
223         _totalSupply = _totalSupply.sub(value);
224         _balances[account] = _balances[account].sub(value);
225         emit Transfer(account, address(0), value);
226     }
227 
228    
229     function _approve(address owner, address spender, uint256 value) internal {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232 
233         _allowances[owner][spender] = value;
234         emit Approval(owner, spender, value);
235     }
236 
237     
238     function _burnFrom(address account, uint256 amount) internal {
239         _burn(account, amount);
240         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
241     }
242 }
243 
244 
245 
246 library Roles {
247     struct Role {
248         mapping (address => bool) bearer;
249     }
250 
251     
252     function add(Role storage role, address account) internal {
253         require(!has(role, account), "Roles: account already has role");
254         role.bearer[account] = true;
255     }
256 
257     
258     function remove(Role storage role, address account) internal {
259         require(has(role, account), "Roles: account does not have role");
260         role.bearer[account] = false;
261     }
262 
263     
264     function has(Role storage role, address account) internal view returns (bool) {
265         require(account != address(0), "Roles: account is the zero address");
266         return role.bearer[account];
267     }
268 }
269 
270 contract MinterRole {
271     using Roles for Roles.Role;
272 
273     event MinterAdded(address indexed account);
274     event MinterRemoved(address indexed account);
275 
276     Roles.Role private _minters;
277 
278     constructor () internal {
279         _addMinter(msg.sender);
280     }
281 
282     modifier onlyMinter() {
283         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
284         _;
285     }
286 
287     function isMinter(address account) public view returns (bool) {
288         return _minters.has(account);
289     }
290 
291     function addMinter(address account) public onlyMinter {
292         _addMinter(account);
293     }
294 
295     function renounceMinter() public {
296         _removeMinter(msg.sender);
297     }
298 
299     function _addMinter(address account) internal {
300         _minters.add(account);
301         emit MinterAdded(account);
302     }
303 
304     function _removeMinter(address account) internal {
305         _minters.remove(account);
306         emit MinterRemoved(account);
307     }
308 }
309 
310 
311 contract ERC20Mintable is ERC20, MinterRole {
312     
313     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
314         _mint(account, amount);
315         return true;
316     }
317 
318      function burn(uint256 amount) public {
319         _burn(msg.sender, amount);
320     }
321 
322     
323     function burnFrom(address account, uint256 amount) public {
324         _burnFrom(account, amount);
325     }
326 }
327 
328 
329 
330 contract QTLToken is ERC20Mintable {
331     uint256 private _cap = 10000000000000000000000000;  // 10,000,000 token cap
332     string private _name = 'QUANT LAMBDA Token';
333     string private _symbol = 'QTL';
334     uint8 private _decimals = 18;
335 
336     
337     function name() public view returns (string memory) {
338         return _name;
339     }
340 
341    
342     function symbol() public view returns (string memory) {
343         return _symbol;
344     }
345 
346    
347     function decimals() public view returns (uint8) {
348         return _decimals;
349     }
350 
351    
352     function cap() public view returns (uint256) {
353         return _cap;
354     }
355 
356     
357     function _mint(address account, uint256 value) internal {
358         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
359         super._mint(account, value);
360     }
361 }