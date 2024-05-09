1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-08
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 contract Context {
8     constructor () internal { }
9 
10     function _msgSender() internal view returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this;
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57 
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68 
69         return c;
70     }
71 
72     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
73         return mod(a, b, "SafeMath: modulo by zero");
74     }
75 
76     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b != 0, errorMessage);
78         return a % b;
79     }
80 }
81 
82 contract Governance is Context{
83     address internal _governance;
84     mapping (address => bool) private _isMinter;
85     mapping (address => uint256) internal _supplyByMinter;
86     mapping (address => uint256) internal _burnByAddress;
87     
88     event GovernanceChanged(address oldGovernance, address newGovernance);
89     event MinterAdmitted(address target);
90     event MinterExpelled(address target);
91     
92     modifier GovernanceOnly () {
93         require (_msgSender() == _governance, "Only Governance can do");
94         _;
95     }
96     
97     modifier MinterOnly () {
98         require (_isMinter[_msgSender()], "Only Minter can do");
99         _;
100     }
101     
102     function governance () external view returns (address) {
103         return _governance;
104     }
105     
106     function isMinter (address target) external view returns (bool) {
107         return _isMinter[target];
108     }
109     
110     function supplyByMinter (address minter) external view returns (uint256) {
111         return _supplyByMinter[minter];
112     }
113     
114     function burnByAddress (address by) external view returns (uint256) {
115         return _burnByAddress[by];
116     }
117     
118     function admitMinter (address target) external GovernanceOnly {
119         require (!_isMinter[target], "Target is minter already");
120         _isMinter[target] = true;
121         emit MinterAdmitted(target);
122     }
123     
124     function expelMinter (address target) external GovernanceOnly {
125         require (_isMinter[target], "Target is not minter");
126         _isMinter[target] = false;
127         emit MinterExpelled(target);
128     }
129     
130     function succeedGovernance (address newGovernance) external GovernanceOnly {
131         _governance = newGovernance;
132         emit GovernanceChanged(msg.sender, newGovernance);
133     }
134 }
135 
136 contract ERC20 is Governance, IERC20 {
137     using SafeMath for uint256;
138 
139     mapping (address => uint256) private _balances;
140 
141     mapping (address => mapping (address => uint256)) private _allowances;
142 
143     string private _name;
144     string private _symbol;
145     uint8 private _decimals;
146 
147     uint256 private _totalSupply;
148     uint256 private _initialSupply;
149 
150     constructor (
151         string memory name,
152         string memory symbol,
153         uint8 decimals,
154         uint256 initialSupply
155     ) public {
156         _name = name;
157         _symbol = symbol;
158         _decimals = decimals;
159         _governance = msg.sender;
160         
161         _mint(msg.sender, initialSupply);
162         _initialSupply = initialSupply;
163     }
164 
165     function name() external view returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() external view returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() external view returns (uint8) {
174         return _decimals;
175     }
176 
177     function totalSupply() external view returns (uint256) {
178         return _totalSupply;
179     }
180 
181     function balanceOf(address account) external view returns (uint256) {
182         return _balances[account];
183     }
184 
185     function transfer(address recipient, uint256 amount) external returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) external view returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) external returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
202         return true;
203     }
204 
205     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
206         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
207         return true;
208     }
209 
210     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
211         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
212         return true;
213     }
214     
215     function mint (address to, uint256 quantity) external MinterOnly {
216         _mint(to, quantity);
217         _supplyByMinter[msg.sender] = _supplyByMinter[msg.sender].add(quantity);
218     }
219     
220     function burn (uint256 quantity) external {
221         _burn(msg.sender, quantity);
222         _burnByAddress[msg.sender] = _burnByAddress[msg.sender].add(quantity);
223     }
224 
225     function _transfer(address sender, address recipient, uint256 amount) internal {
226         require(sender != address(0), "ERC20: transfer from the zero address");
227         require(recipient != address(0), "ERC20: transfer to the zero address");
228 
229         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
230         _balances[recipient] = _balances[recipient].add(amount);
231         emit Transfer(sender, recipient, amount);
232     }
233 
234     function _mint(address account, uint256 amount) internal {
235         require(account != address(0), "ERC20: mint to the zero address");
236 
237         _totalSupply = _totalSupply.add(amount);
238         _balances[account] = _balances[account].add(amount);
239         emit Transfer(address(0), account, amount);
240     }
241 
242     function _burn(address account, uint256 amount) internal {
243         require(account != address(0), "ERC20: burn from the zero address");
244 
245         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
246         _totalSupply = _totalSupply.sub(amount);
247         emit Transfer(account, address(0), amount);
248     }
249 
250     function _approve(address owner, address spender, uint256 amount) internal {
251         require(owner != address(0), "ERC20: approve from the zero address");
252         require(spender != address(0), "ERC20: approve to the zero address");
253 
254         _allowances[owner][spender] = amount;
255         emit Approval(owner, spender, amount);
256     }
257 
258     function _burnFrom(address account, uint256 amount) internal {
259         _burn(account, amount);
260         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
261     }
262 }
263 
264 contract MCS is ERC20 ("MCS", "MCS", 18, 13000000000000000000000000000) {
265 
266 }