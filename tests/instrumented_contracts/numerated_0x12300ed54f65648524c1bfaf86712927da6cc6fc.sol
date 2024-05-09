1 // File: contracts/utils/SafeMath.sol
2 
3 
4 pragma solidity >=0.4.22 <0.9.0;
5 
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b <= a, "SafeMath: subtraction overflow");
15         return a - b;
16     }
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) return 0;
20         uint256 c = a * b;
21         require(c / a == b, "SafeMath: multiplication overflow");
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b > 0, "SafeMath: division by zero");
27         return a / b;
28     }
29 
30     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0, "SafeMath: modulo by zero");
32         return a % b;
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         return a - b;
38     }
39 
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b > 0, errorMessage);
42         return a / b;
43     }
44 
45     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b > 0, errorMessage);
47         return a % b;
48     }
49 
50 }
51 
52 // File: contracts/token/IERC20.sol
53 
54 
55 pragma solidity >=0.4.22 <0.9.0;
56 
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59 
60     function balanceOf(address account) external view returns (uint256);
61 
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 
74 }
75 
76 // File: contracts/utils/Context.sol
77 
78 
79 pragma solidity >=0.4.22 <0.9.0;
80 
81 abstract contract Context {
82     function _msgSender() internal view virtual returns (address) {
83         return msg.sender;
84     }
85 
86     function _msgData() internal view virtual returns (bytes memory) {
87         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
88         return msg.data;
89     }
90 }
91 
92 // File: contracts/MOVD.sol
93 
94 
95 pragma solidity >=0.4.22 <0.9.0;
96 
97 
98 
99 
100 
101 contract ERC20 is Context, IERC20 {
102     using SafeMath for uint256;
103 
104     mapping (address => uint256) private _balances;
105 
106     mapping (address => mapping (address => uint256)) private _allowances;
107 
108     uint256 private _totalSupply;
109 
110     string private _name;
111     string private _symbol;
112     uint8 private _decimals;
113 
114     constructor (string memory name_, string memory symbol_ ) {
115         _decimals = 18;
116         _symbol = symbol_;
117         _name = name_;
118         _totalSupply = 10 ** 9 * 1e18;
119 
120         // MOVE-TEAM
121         _balances[address(0xdd20a5D3c5EE23F94Fd573ca5837B562a2D3C32D)] = 15 * 10 ** 7 * 1e18;
122         emit Transfer(address(0), address(0xdd20a5D3c5EE23F94Fd573ca5837B562a2D3C32D), 15 * 10 ** 7 * 1e18 );
123 
124         // MOVE-TOKENSALES
125         _balances[address(0x4aBB983dddFA282F97bF8289a978B3d658E5D5F8)] = 13 * 10 ** 7 * 1e18;
126         emit Transfer(address(0), address(0x4aBB983dddFA282F97bF8289a978B3d658E5D5F8), 13 * 10 ** 7 * 1e18);
127 
128         // MOVE-PARTNERSHIPS
129         _balances[address(0x9e70eD075A46e418E7963335Cf9Fde5Fc5C8eA58)] = 10 ** 8 * 1e18;
130         emit Transfer(address(0), address(0x9e70eD075A46e418E7963335Cf9Fde5Fc5C8eA58), 10 ** 8 * 1e18);
131 
132         // MOVE-ECOSYSTEM
133         _balances[address(0xF6C423BB72632f82027DB34615eC9c21de21b1C3)] = 12 * 10 ** 7 * 1e18;
134         emit Transfer(address(0), address(0xF6C423BB72632f82027DB34615eC9c21de21b1C3), 12 * 10 ** 7 * 1e18);
135 
136         // MOVE-MINING
137         _balances[address(0xa3F060Bc75881324F7f2919558797F61ea94AEDc)] = 5 * 10 ** 8 * 1e18;
138         emit Transfer(address(0), address(0xa3F060Bc75881324F7f2919558797F61ea94AEDc), 5 * 10 ** 8 * 1e18);
139     }
140 
141     function name() public view virtual returns (string memory) {
142         return _name;
143     }
144 
145     function symbol() public view virtual returns (string memory) {
146         return _symbol;
147     }
148 
149     function decimals() public view virtual returns (uint8) {
150         return _decimals;
151     }
152 
153     function totalSupply() public view virtual override returns (uint256) {
154         return _totalSupply;
155     }
156 
157     function balanceOf(address account) public view virtual override returns (uint256) {
158         return _balances[account];
159     }
160 
161     modifier onlyPayloadSize(uint size) {
162       require(!(_msgData().length < size + 4));
163       _;
164     }
165 
166     function transfer(address recipient, uint256 amount) public virtual override onlyPayloadSize(2 * 32) returns (bool) {
167         _transfer(_msgSender(), recipient, amount);
168         return true;
169     }
170 
171     function allowance(address owner, address spender) public view virtual override returns (uint256) {
172         return _allowances[owner][spender];
173     }
174 
175     function approve(address spender, uint256 amount) public virtual override onlyPayloadSize(2 * 32) returns (bool) {
176         _approve(_msgSender(), spender, amount);
177         return true;
178     }
179 
180     function transferFrom(address sender, address recipient, uint256 amount) public virtual override onlyPayloadSize(3 * 32) returns (bool) {
181         _transfer(sender, recipient, amount);
182         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
183         return true;
184     }
185 
186     function increaseAllowance(address spender, uint256 addedValue) public virtual onlyPayloadSize(2 * 32) returns (bool) {
187         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
188         return true;
189     }
190 
191     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual onlyPayloadSize(2 * 32) returns (bool) {
192         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
193         return true;
194     }
195 
196     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
197         require(sender != address(0), "ERC20: transfer from the zero address");
198         require(recipient != address(0), "ERC20: transfer to the zero address");
199 
200         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
201         _balances[recipient] = _balances[recipient].add(amount);
202         emit Transfer(sender, recipient, amount);
203     }
204 
205     function _approve(address owner, address spender, uint256 amount) internal virtual {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208 
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213 }
214 
215 contract Ownable is Context {
216 
217   address public owner;
218   event OwnershipTransferred(
219     address indexed previousOwner,
220     address indexed newOwner
221   );
222 
223   constructor() {
224     owner = _msgSender();
225   }
226 
227   modifier onlyOwner() {
228     require(_msgSender() == owner);
229     _;
230   }
231 
232   function transferOwnership(address _newOwner) public onlyOwner {
233     _transferOwnership(_newOwner);
234   }
235 
236   function _transferOwnership(address _newOwner) internal {
237     require(_newOwner != address(0));
238     emit OwnershipTransferred(owner, _newOwner);
239     owner = _newOwner;
240   }
241 
242 }
243 
244 
245 contract Pausable is Context, Ownable {
246     event Paused(address account);
247     event Unpaused(address account);
248     bool private _paused = false;
249 
250     function paused() public view virtual returns (bool) {
251       return _paused;
252     }
253 
254     modifier whenNotPaused() {
255         require(!paused(), "Pausable: paused");
256         _;
257     }
258 
259     modifier whenPaused() {
260         require(paused(), "Pausable: not paused");
261         _;
262     }
263 
264     function _pause() internal virtual onlyOwner whenNotPaused {
265         _paused = true;
266         emit Paused(_msgSender());
267     }
268 
269     function _unpause() internal virtual onlyOwner whenPaused {
270         _paused = false;
271         emit Unpaused(_msgSender());
272     }
273 }
274 
275 
276 contract MOVD is Pausable, ERC20 {
277   using SafeMath for uint256;
278 
279   constructor() 
280   ERC20("MOVD Token", "MOVD"){}
281 
282   function transfer(address recipient, uint256 amount) public virtual override whenNotPaused onlyPayloadSize(2 * 32) returns (bool) {
283     _transfer(_msgSender(), recipient, amount);
284     return true;
285   }
286 
287   function transferFrom(address sender, address recipient, uint256 amount) public virtual override whenNotPaused onlyPayloadSize(3 * 32) returns (bool) {
288     super.transferFrom(sender, recipient, amount);
289     return true;
290   }
291 
292 
293   function pause() public {
294     _pause();
295   }
296 
297   function unpause() public {
298     _unpause();
299   }
300 }