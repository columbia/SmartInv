1 pragma solidity ^0.5.16;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     constructor () internal {
9         _owner = msg.sender;
10         emit OwnershipTransferred(address(0), _owner);
11     }
12 
13     function owner() public view returns (address) {
14         return _owner;
15     }
16 
17     modifier onlyOwner() {
18         require(isOwner());
19         _;
20     }
21 
22     function isOwner() public view returns (bool) {
23         return msg.sender == _owner;
24     }
25 
26     function renounceOwnership() public onlyOwner {
27         emit OwnershipTransferred(_owner, address(0));
28         _owner = address(0);
29     }
30 
31     function transferOwnership(address newOwner) public onlyOwner {
32         _transferOwnership(newOwner);
33     }
34 
35     function _transferOwnership(address newOwner) internal {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(_owner, newOwner);
38         _owner = newOwner;
39     }
40 
41 }
42 
43 library Roles {
44     struct Role {
45         mapping (address => bool) bearer;
46     }
47 
48     function add(Role storage role, address account) internal {
49         require(account != address(0));
50         require(!has(role, account));
51 
52         role.bearer[account] = true;
53     }
54 
55     function remove(Role storage role, address account) internal {
56         require(account != address(0));
57         require(has(role, account));
58 
59         role.bearer[account] = false;
60     }
61 
62     function has(Role storage role, address account) internal view returns (bool) {
63         require(account != address(0));
64         return role.bearer[account];
65     }
66 }
67 
68 contract MinterRole {
69     using Roles for Roles.Role;
70 
71     event MinterAdded(address indexed account);
72     event MinterRemoved(address indexed account);
73 
74     Roles.Role private _minters;
75 
76     constructor () internal {
77         _addMinter(msg.sender);
78     }
79 
80     modifier onlyMinter() {
81         require(isMinter(msg.sender));
82         _;
83     }
84 
85     function isMinter(address account) public view returns (bool) {
86         return _minters.has(account);
87     }
88 
89     function addMinter(address account) public onlyMinter {
90         _addMinter(account);
91     }
92 
93     function renounceMinter() public {
94         _removeMinter(msg.sender);
95     }
96 
97     function _addMinter(address account) internal {
98         _minters.add(account);
99         emit MinterAdded(account);
100     }
101 
102     function _removeMinter(address account) internal {
103         _minters.remove(account);
104         emit MinterRemoved(account);
105     }
106 }
107 
108 library SafeMath {
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b);
116 
117         return c;
118     }
119 
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b > 0);
122         uint256 c = a / b;
123 
124         return c;
125     }
126 
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b <= a);
129         uint256 c = a - b;
130 
131         return c;
132     }
133 
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a);
137 
138         return c;
139     }
140 
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b != 0);
143         return a % b;
144     }
145 }
146 
147 interface IERC20 {
148     function transfer(address to, uint256 value) external returns (bool);
149 
150     function approve(address spender, uint256 value) external returns (bool);
151 
152     function transferFrom(address from, address to, uint256 value) external returns (bool);
153 
154     function totalSupply() external view returns (uint256);
155 
156     function balanceOf(address who) external view returns (uint256);
157 
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     event Transfer(address indexed from, address indexed to, uint256 value);
161 
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 contract ERC20 is IERC20 {
166     using SafeMath for uint256;
167 
168     mapping (address => uint256) private _balances;
169 
170     mapping (address => mapping (address => uint256)) private _allowed;
171 
172     uint256 private _totalSupply;
173 
174     mapping (address => uint) public lockedAccount;
175     
176     event Lock(address target, uint amount);
177     event UnLock(address target, uint amount);
178 
179     function totalSupply() public view returns (uint256) {
180         return _totalSupply;
181     }
182 
183     function balanceOf(address owner) public view returns (uint256) {
184         return _balances[owner];
185     }
186 
187     function allowance(address owner, address spender) public view returns (uint256) {
188         return _allowed[owner][spender];
189     }
190 
191     function transfer(address to, uint256 value) public returns (bool) {
192         _transfer(msg.sender, to, value);
193         return true;
194     }
195 
196     function approve(address spender, uint256 value) public returns (bool) {
197         _approve(msg.sender, spender, value);
198         return true;
199     }
200 
201     function transferFrom(address from, address to, uint256 value) public returns (bool) {
202         _transfer(from, to, value);
203         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
204         return true;
205     }
206 
207     function lockAccount(uint amount) internal returns (bool) {
208         lockAccount(msg.sender, amount);
209         return true;
210     }
211 
212     function unLockAccount(uint amount) internal returns (bool) {
213         unLockAccount(msg.sender, amount);
214         return true;
215     }
216 
217     function _transfer(address from, address to, uint256 amount) internal {
218         require(from != address(0), "ERC20: transfer from the zero address");
219         require(to != address(0), "ERC20: transfer to the zero address");
220 
221         _balances[from] = _balances[from].sub(amount);
222         _balances[to] = _balances[to].add(amount);
223         emit Transfer(from, to, amount);
224     }
225 
226     function _mint(address account, uint256 value) internal {
227         require(account != address(0));
228 
229         _totalSupply = _totalSupply.add(value);
230         _balances[account] = _balances[account].add(value);
231         emit Transfer(address(0), account, value);
232     }
233 
234     function _approve(address owner, address spender, uint256 value) internal {
235         require(spender != address(0));
236         require(owner != address(0));
237 
238         _allowed[owner][spender] = value;
239         emit Approval(owner, spender, value);
240     }
241 
242     function lockAccount(address account, uint amount) internal returns (bool) {
243         require(account != address(0));
244         require(_balances[account] >= amount);
245         _balances[account] = _balances[account].sub(amount);
246         lockedAccount[account] = lockedAccount[account].add(amount);
247         emit Lock(account, lockedAccount[account]);
248 
249         return true;
250     }
251 
252     function unLockAccount(address account, uint amount) internal returns (bool) {
253         require(account != address(0));
254         require(lockedAccount[account] >= amount);
255         lockedAccount[account] = lockedAccount[account].sub(amount);
256         _balances[account] = _balances[account].add(amount);
257         emit UnLock(account, lockedAccount[account]);
258         
259         return true;
260     }
261 }
262 
263 contract ERC20Mintable is ERC20, MinterRole {
264     function mint(address to, uint256 value) public onlyMinter returns (bool) {
265         _mint(to, value);
266         return true;
267     }
268 }
269 
270 contract PMWToken is ERC20Mintable, Ownable {
271     string public constant name = "Photon Milky Way";
272     string public constant symbol = "PMW";
273     uint8 public constant decimals = 18;
274     uint public constant initialSupply = 1000000000000000000000000000;
275 
276     mapping (address => bool) public frozenAccount;
277 
278     event Freeze(address target);
279     event UnFreeze(address target);
280 
281     constructor() public {
282         _mint(msg.sender, initialSupply);
283     }
284 
285     function () external payable {
286         revert();
287     }
288 
289     function freezeAccount(address target) onlyOwner public {
290         require(target != address(0));
291         require(!frozenAccount[target]);
292         frozenAccount[target] = true;
293         emit Freeze(target);
294     }
295 
296     function unFreezeAccount(address target) onlyOwner public {
297         require(target != address(0));
298         require(frozenAccount[target]);
299         frozenAccount[target] = false;
300         emit UnFreeze(target);
301     }
302 
303     function transfer(address recipient, uint256 amount) public returns (bool) {
304         require(!frozenAccount[msg.sender]);        // Check if sender is frozen
305         require(!frozenAccount[recipient]);               // Check if recipient is frozen
306         return super.transfer(recipient, amount);
307     }
308 
309     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
310         require(!frozenAccount[msg.sender]);        // Check if approved is frozen
311         require(!frozenAccount[sender]);             // Check if sender is frozen
312         require(!frozenAccount[recipient]);               // Check if recipient is frozen
313         return super.transferFrom(sender, recipient, amount);
314     }
315 }