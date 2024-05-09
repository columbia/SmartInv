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
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a);
50 
51         return c;
52     }
53 
54     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b != 0);
56         return a % b;
57     }
58 }
59 
60 contract ERC20 is IERC20 {
61     using SafeMath for uint256;
62 
63     mapping (address => uint256) private _balances;
64 
65     mapping (address => mapping (address => uint256)) private _allowed;
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
87         require(spender != address(0));
88 
89         _allowed[msg.sender][spender] = value;
90         emit Approval(msg.sender, spender, value);
91         return true;
92     }
93 
94     function transferFrom(address from, address to, uint256 value) public returns (bool) {
95         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
96         _transfer(from, to, value);
97         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
98         return true;
99     }
100 
101     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
102         require(spender != address(0));
103 
104         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
105         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
106         return true;
107     }
108 
109     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
110         require(spender != address(0));
111 
112         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
113         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
114         return true;
115     }
116 
117     function _transfer(address from, address to, uint256 value) internal {
118         require(to != address(0));
119 
120         _balances[from] = _balances[from].sub(value);
121         _balances[to] = _balances[to].add(value);
122         emit Transfer(from, to, value);
123     }
124 
125     function _mint(address account, uint256 value) internal {
126         require(account != address(0));
127 
128         _totalSupply = _totalSupply.add(value);
129         _balances[account] = _balances[account].add(value);
130         emit Transfer(address(0), account, value);
131     }
132 
133     function _burn(address account, uint256 value) internal {
134         require(account != address(0));
135 
136         _totalSupply = _totalSupply.sub(value);
137         _balances[account] = _balances[account].sub(value);
138         emit Transfer(account, address(0), value);
139     }
140 
141     function _burnFrom(address account, uint256 value) internal {
142         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
143         _burn(account, value);
144         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
145     }
146 }
147 
148 contract ERC20Detailed is IERC20 {
149     string private _name;
150     string private _symbol;
151     uint8 private _decimals;
152 
153     constructor (string memory name, string memory symbol, uint8 decimals) public {
154         _name = name;
155         _symbol = symbol;
156         _decimals = decimals;
157     }
158 
159     function name() public view returns (string memory) {
160         return _name;
161     }
162 
163     function symbol() public view returns (string memory) {
164         return _symbol;
165     }
166 
167     function decimals() public view returns (uint8) {
168         return _decimals;
169     }
170 }
171 
172 library Roles {
173     struct Role {
174         mapping (address => bool) bearer;
175     }
176 
177     function add(Role storage role, address account) internal {
178         require(account != address(0));
179         require(!has(role, account));
180 
181         role.bearer[account] = true;
182     }
183 
184     function remove(Role storage role, address account) internal {
185         require(account != address(0));
186         require(has(role, account));
187 
188         role.bearer[account] = false;
189     }
190 
191     function has(Role storage role, address account) internal view returns (bool) {
192         require(account != address(0));
193         return role.bearer[account];
194     }
195 }
196 
197 contract PauserRole {
198     using Roles for Roles.Role;
199 
200     event PauserAdded(address indexed account);
201     event PauserRemoved(address indexed account);
202 
203     Roles.Role private _pausers;
204 
205     constructor () internal {
206         _addPauser(msg.sender);
207     }
208 
209     modifier onlyPauser() {
210         require(isPauser(msg.sender));
211         _;
212     }
213 
214     function isPauser(address account) public view returns (bool) {
215         return _pausers.has(account);
216     }
217 
218     function addPauser(address account) public onlyPauser {
219         _addPauser(account);
220     }
221 
222     function renouncePauser() public {
223         _removePauser(msg.sender);
224     }
225 
226     function _addPauser(address account) internal {
227         _pausers.add(account);
228         emit PauserAdded(account);
229     }
230 
231     function _removePauser(address account) internal {
232         _pausers.remove(account);
233         emit PauserRemoved(account);
234     }
235 }
236 
237 contract Pausable is PauserRole {
238     event Paused(address account);
239     event Unpaused(address account);
240 
241     bool private _paused;
242 
243     constructor () internal {
244         _paused = false;
245     }
246 
247     function paused() public view returns (bool) {
248         return _paused;
249     }
250 
251     modifier whenNotPaused() {
252         require(!_paused);
253         _;
254     }
255 
256     modifier whenPaused() {
257         require(_paused);
258         _;
259     }
260 
261     function pause() public onlyPauser whenNotPaused {
262         _paused = true;
263         emit Paused(msg.sender);
264     }
265 
266     function unpause() public onlyPauser whenPaused {
267         _paused = false;
268         emit Unpaused(msg.sender);
269     }
270 }
271 
272 contract ERC20Pausable is ERC20, Pausable {
273     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
274         return super.transfer(to, value);
275     }
276 
277     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
278         return super.transferFrom(from, to, value);
279     }
280 
281     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
282         return super.approve(spender, value);
283     }
284 
285     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
286         return super.increaseAllowance(spender, addedValue);
287     }
288 
289     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
290         return super.decreaseAllowance(spender, subtractedValue);
291     }
292 }
293 
294 contract SilverCJTToken is ERC20Detailed, ERC20Pausable {
295 	using SafeMath for uint256;
296     uint8 public constant DECIMALS = 18;
297 	uint256 public constant INITIAL_SUPPLY = 153 * 10000 * 10000 * (10 ** uint256(DECIMALS));
298 
299     constructor()
300 	    ERC20Detailed("Silver CJT", "CJT", DECIMALS)
301 		ERC20Pausable()
302 		public
303 	{
304         _mint(msg.sender, INITIAL_SUPPLY);
305     }
306 }