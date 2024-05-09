1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8 
9         uint256 c = a * b;
10         require(c / a == b);
11 
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Solidity only automatically asserts when dividing by 0
17         require(b > 0);
18         uint256 c = a / b;
19 
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a);
33 
34         return c;
35     }
36 
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b != 0);
39         return a % b;
40     }
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
76     constructor() internal {
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
108 
109 contract Ownable {
110     address private _owner;
111 
112     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114     constructor() internal {
115         _owner = msg.sender;
116         emit OwnershipTransferred(address(0), _owner);
117     }
118 
119     function owner() public view returns (address) {
120         return _owner;
121     }
122 
123     modifier onlyOwner() {
124         require(isOwner());
125         _;
126     }
127 
128     function isOwner() public view returns (bool) {
129         return msg.sender == _owner;
130     }
131 
132     function renounceOwnership() public onlyOwner {
133         emit OwnershipTransferred(_owner, address(0));
134         _owner = address(0);
135     }
136 
137     function transferOwnership(address newOwner) public onlyOwner {
138         _transferOwnership(newOwner);
139     }
140 
141     function _transferOwnership(address newOwner) internal {
142         require(newOwner != address(0));
143         emit OwnershipTransferred(_owner, newOwner);
144         _owner = newOwner;
145     }
146 }
147 
148 interface IERC20 {
149     function transfer(address to, uint256 value) external returns (bool);
150 
151     function approve(address spender, uint256 value) external returns (bool);
152 
153     function transferFrom(address from, address to, uint256 value) external returns (bool);
154 
155     function totalSupply() external view returns (uint256);
156 
157     function balanceOf(address who) external view returns (uint256);
158 
159     function allowance(address owner, address spender) external view returns (uint256);
160 
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 contract ERC20 is IERC20, Ownable {
167     using SafeMath for uint256;
168 
169     mapping (address => uint256) private _balances;
170 
171     mapping (address => mapping (address => uint256)) private _allowed;
172 
173     uint256 private _totalSupply;
174 
175     function totalSupply() public view returns (uint256) {
176         return _totalSupply;
177     }
178 
179     function balanceOf(address owner) public view returns (uint256) {
180         return _balances[owner];
181     }
182 
183     function allowance(address owner, address spender) public view returns (uint256) {
184         return _allowed[owner][spender];
185     }
186 
187     function transfer(address to, uint256 value) public onlyOwner returns (bool) {
188         _transfer(msg.sender, to, value);
189         return true;
190     }
191 
192     function approve(address spender, uint256 value) public returns (bool) {
193         require(spender != address(0));
194 
195         _allowed[msg.sender][spender] = value;
196         emit Approval(msg.sender, spender, value);
197         return true;
198     }
199 
200     function transferFrom(address from, address to, uint256 value) public onlyOwner returns (bool) {
201         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
202         _transfer(from, to, value);
203         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
204         return true;
205     }
206 
207     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
208         require(spender != address(0));
209         require(false, "unsupported");
210 
211         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
212         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
213         return true;
214     }
215 
216     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
217         require(spender != address(0));
218         require(false, "unsupported");
219 
220         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
221         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
222         return true;
223     }
224 
225     function _transfer(address from, address to, uint256 value) internal {
226         require(to != address(0));
227 
228         _balances[from] = _balances[from].sub(value);
229         _balances[to] = _balances[to].add(value);
230         emit Transfer(from, to, value);
231     }
232 
233     function _mint(address account, uint256 value) internal {
234         require(account != address(0));
235 
236         _totalSupply = _totalSupply.add(value);
237         _balances[account] = _balances[account].add(value);
238         emit Transfer(address(0), account, value);
239     }
240     /*
241     function _burn(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.sub(value);
245         _balances[account] = _balances[account].sub(value);
246         emit Transfer(account, address(0), value);
247     }
248 
249     function _burnFrom(address account, uint256 value) internal {
250         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
251         _burn(account, value);
252         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
253     }
254     */
255 }
256 
257 contract ERC20Detailed is IERC20 {
258     string private _name;
259     string private _symbol;
260     uint8 private _decimals;
261 
262     constructor(string memory name, string memory symbol, uint8 decimals) public {
263         _name = name;
264         _symbol = symbol;
265         _decimals = decimals;
266     }
267 
268     function name() public view returns (string memory) {
269         return _name;
270     }
271 
272     function symbol() public view returns (string memory) {
273         return _symbol;
274     }
275 
276     function decimals() public view returns (uint8) {
277         return _decimals;
278     }
279 }
280 
281 contract ERC20Mintable is ERC20, MinterRole {
282     function mint(address to, uint256 value) public onlyMinter returns (bool) {
283         _mint(to, value);
284         return true;
285     }
286 }
287 
288 contract ETMToken is ERC20, ERC20Detailed, ERC20Mintable {
289     uint8 public constant DECIMALS = 18;
290     uint256 public constant INITIAL_SUPPLY = 30000000 * (10 ** uint256(DECIMALS));
291     bool private _destoried = false;
292 
293     constructor() public ERC20Detailed("EnTanMo", "ETM", DECIMALS) {
294         _mint(msg.sender, INITIAL_SUPPLY);
295     }
296 
297     function destory() public onlyOwner returns (bool) {
298         if (!_destoried) {
299             _destoried = true;
300             selfdestruct(address(0));
301             return true;
302         }
303         return false;
304     }
305 }