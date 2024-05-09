1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b);
29 
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b > 0);
35         uint256 c = a / b;
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b <= a);
41         uint256 c = a - b;
42 
43         return c;
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
54         require(b != 0);
55         return a % b;
56     }
57 }
58 
59 
60 contract ERC20 is IERC20 {
61     using SafeMath for uint256;
62 
63     mapping(address => uint256) private _balances;
64 
65     mapping(address => mapping(address => uint256)) private _allowed;
66 
67     uint256 private _totalSupply;
68 
69     function totalSupply() public view returns (uint256) {
70         return _totalSupply;
71     }
72 
73     function balanceOf(address owner) public view returns (uint256) {
74         return _balances[owner];
75     }
76 
77     function allowance(address owner, address spender) public view returns (uint256) {
78         return _allowed[owner][spender];
79     }
80 
81     function transfer(address to, uint256 value) public returns (bool) {
82         _transfer(msg.sender, to, value);
83         return true;
84     }
85 
86     function approve(address spender, uint256 value) public returns (bool) {
87         _approve(msg.sender, spender, value);
88         return true;
89     }
90 
91     function transferFrom(address from, address to, uint256 value) public returns (bool) {
92         _transfer(from, to, value);
93         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
94         return true;
95     }
96 
97 
98     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
99         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
100         return true;
101     }
102 
103     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
104         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
105         return true;
106     }
107 
108     function _transfer(address from, address to, uint256 value) internal {
109         require(to != address(0));
110 
111         _balances[from] = _balances[from].sub(value);
112         _balances[to] = _balances[to].add(value);
113         emit Transfer(from, to, value);
114     }
115 
116     function _mint(address account, uint256 value) internal {
117         require(account != address(0));
118 
119         _totalSupply = _totalSupply.add(value);
120         _balances[account] = _balances[account].add(value);
121         emit Transfer(address(0), account, value);
122     }
123 
124     function _burn(address account, uint256 value) internal {
125         require(account != address(0));
126 
127         _totalSupply = _totalSupply.sub(value);
128         _balances[account] = _balances[account].sub(value);
129         emit Transfer(account, address(0), value);
130     }
131 
132     function _approve(address owner, address spender, uint256 value) internal {
133         require(spender != address(0));
134         require(owner != address(0));
135 
136         _allowed[owner][spender] = value;
137         emit Approval(owner, spender, value);
138     }
139 
140     function _burnFrom(address account, uint256 value) internal {
141         _burn(account, value);
142         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
143     }
144 }
145 
146 library Roles {
147     struct Role {
148         mapping(address => bool) bearer;
149     }
150 
151     function add(Role storage role, address account) internal {
152         require(account != address(0));
153         require(!has(role, account));
154 
155         role.bearer[account] = true;
156     }
157 
158     function remove(Role storage role, address account) internal {
159         require(account != address(0));
160         require(has(role, account));
161 
162         role.bearer[account] = false;
163     }
164 
165     function has(Role storage role, address account) internal view returns (bool) {
166         require(account != address(0));
167         return role.bearer[account];
168     }
169 }
170 
171 contract PauserRole {
172     using Roles for Roles.Role;
173 
174     event PauserAdded(address indexed account);
175     event PauserRemoved(address indexed account);
176 
177     Roles.Role private _pausers;
178 
179     constructor () internal {
180         _addPauser(msg.sender);
181     }
182 
183     modifier onlyPauser() {
184         require(isPauser(msg.sender));
185         _;
186     }
187 
188     function isPauser(address account) public view returns (bool) {
189         return _pausers.has(account);
190     }
191 
192     function addPauser(address account) public onlyPauser {
193         _addPauser(account);
194     }
195 
196     function renouncePauser() public {
197         _removePauser(msg.sender);
198     }
199 
200     function _addPauser(address account) internal {
201         _pausers.add(account);
202         emit PauserAdded(account);
203     }
204 
205     function _removePauser(address account) internal {
206         _pausers.remove(account);
207         emit PauserRemoved(account);
208     }
209 }
210 
211 contract Pausable is PauserRole {
212     event Paused(address account);
213     event Unpaused(address account);
214 
215     bool private _paused;
216 
217     constructor () internal {
218         _paused = false;
219     }
220 
221     function paused() public view returns (bool) {
222         return _paused;
223     }
224     modifier whenNotPaused() {
225         require(!_paused);
226         _;
227     }
228 
229     modifier whenPaused() {
230         require(_paused);
231         _;
232     }
233 
234     function pause() public onlyPauser whenNotPaused {
235         _paused = true;
236         emit Paused(msg.sender);
237     }
238 
239     function unpause() public onlyPauser whenPaused {
240         _paused = false;
241         emit Unpaused(msg.sender);
242     }
243 }
244 
245 contract PauseableToken is ERC20, Pausable {
246     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
247         return super.transfer(to, value);
248     }
249 
250     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
251         return super.transferFrom(from, to, value);
252     }
253 
254     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
255         return super.approve(spender, value);
256     }
257 
258     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
259         return super.increaseAllowance(spender, addedValue);
260     }
261 
262     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
263         return super.decreaseAllowance(spender, subtractedValue);
264     }
265 }
266 
267 contract Ownable {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271     constructor () internal {
272         _owner = msg.sender;
273         emit OwnershipTransferred(address(0), _owner);
274     }
275     function owner() public view returns (address) {
276         return _owner;
277     }
278     modifier onlyOwner() {
279         require(isOwner());
280         _;
281     }
282     function isOwner() public view returns (bool) {
283         return msg.sender == _owner;
284     }
285 
286     function transferOwnership(address newOwner) public onlyOwner {
287         _transferOwnership(newOwner);
288     }
289 
290     function _transferOwnership(address newOwner) internal {
291         require(newOwner != address(0));
292         emit OwnershipTransferred(_owner, newOwner);
293         _owner = newOwner;
294     }
295 }
296 
297 // "USDE Token" , "USDE",18
298 contract USDEToken is PauseableToken, Ownable {
299     string private _name;
300     string private _symbol;
301     uint8 private _decimals;
302 
303     constructor (string memory name, string memory symbol, uint8 decimals) public {
304         _name = name;
305         _symbol = symbol;
306         _decimals = decimals;
307     }
308 
309     function name() public view returns (string memory) {
310         return _name;
311     }
312 
313     function symbol() public view returns (string memory) {
314         return _symbol;
315     }
316 
317     function decimals() public view returns (uint8) {
318         return _decimals;
319     }
320 
321     function mint(address account, uint256 value) public onlyOwner {
322         _mint(account, value);
323     }
324 
325     function burnFrom(address account, uint256 value) public onlyOwner {
326         _burnFrom(account, value);
327     }
328 
329     function burn(address account, uint256 value) public onlyOwner {
330         _burn(account, value);
331     }
332 }