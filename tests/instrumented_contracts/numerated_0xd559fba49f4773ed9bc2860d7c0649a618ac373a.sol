1 pragma solidity 0.6.12;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36 
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40 
41         return c;
42     }
43 
44     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45         return mod(a, b, "SafeMath: modulo by zero");
46     }
47 
48     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b != 0, errorMessage);
50         return a % b;
51     }
52 }
53 
54 contract Ownable {
55     address public _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     constructor () public {
60         _owner = msg.sender;
61         emit OwnershipTransferred(address(0), msg.sender);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(_owner == msg.sender, "Ownable: caller is not the owner");
70         _;
71     }
72 
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 }
84 
85 interface IERC20 {
86     function totalSupply() external view returns (uint);
87     function balanceOf(address tokenOwner) external view returns (uint balance);
88     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
89     function transfer(address to, uint tokens) external returns (bool success);
90     function approve(address spender, uint tokens) external returns (bool success);
91     function transferFrom(address from, address to, uint tokens) external returns (bool success);
92 
93     function increaseAllowance(address spender, uint addedValue) external returns (bool success);
94     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool success);
95 
96     event Transfer(address indexed from, address indexed to, uint tokens);
97     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
98 }
99 
100 contract ERC20 {
101     using SafeMath for uint256;
102     
103     // ERC20 Token variables
104     string public symbol = "YFKA";
105     string public name = "Yield Farming Known as Ash";
106     uint8 public decimals = 18;
107     uint public _totalSupply = 0;
108     
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowances;
111     
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113     event Transfer(address indexed from, address indexed to, uint256 value);
114     
115     function totalSupply() public view returns (uint256) {
116         return _totalSupply;
117     }
118     
119     function balanceOf(address account) public view returns (uint256) {
120         return balances[account];
121     }
122     
123     function transfer(address recipient, uint256 amount) public returns (bool) {
124         balances[msg.sender] = balances[msg.sender].sub(amount, "ERC20: transfer amount exceeds balance");
125         balances[recipient] = balances[recipient].add(amount);
126         emit Transfer(msg.sender, recipient, amount);
127     }
128     
129     function transferFrom(address from, address to, uint256 value) public returns (bool success)
130     {
131         require(value <= balances[from]);
132         require(value <= allowances[from][msg.sender]);
133 
134         balances[from] = balances[from].sub(value);
135         balances[to] = balances[to].add(value);
136         
137         allowances[from][msg.sender] = allowances[from][msg.sender].sub(value);
138         emit Transfer(from, to, value);
139         return true;
140     }
141     
142     function approve(address owner, address spender, uint256 amount) internal virtual {
143         allowances[owner][spender] = amount;
144         emit Approval(owner, spender, amount);
145     }
146 }
147 
148 contract YFKA is ERC20, Ownable {
149     using SafeMath for uint256;
150 
151     IERC20 public boaContract;
152     uint256 public boaRate;
153 
154     IERC20 public xampContract;
155     uint256 public xampRate;
156 
157     IERC20 public tobContract;
158     uint256 public tobRate;
159 
160     bool public presaleRunning = true;
161     bool public tuning = true;
162     
163     // OPERATIONAL FUNCTIONS FOR TESTING
164     function turnOffTuning() public onlyOwner {
165         tuning = false;
166     }
167     
168     function setUp(address _boaContract, uint256 _boaRate, address _xampContract, uint256 _xampRate, address _tobContract, uint256 _tobRate) public onlyOwner {
169         require(tuning == true);
170         
171         boaContract = IERC20(_boaContract);
172         boaRate = _boaRate;
173 
174         xampContract = IERC20(_xampContract);
175         xampRate = _xampRate;
176 
177         tobContract = IERC20(_tobContract);
178         tobRate = _tobRate;
179     }
180     
181     function changeRate(address _addr, uint256 newRate) public onlyOwner {
182         require(tuning == true);
183         
184         if (_addr == address(boaContract)) boaRate = newRate;
185         else if (_addr == address(xampContract)) xampRate = newRate;
186         else if (_addr == address(tobContract)) tobRate = newRate;
187     }
188     
189     function changeContract(address _addr, address newAddress) public onlyOwner {
190         require(tuning == true);
191         
192         if (_addr == address(boaContract)) boaContract = IERC20(newAddress);
193         else if (_addr == address(xampContract)) xampContract = IERC20(newAddress);
194         else if (_addr == address(tobContract)) tobContract = IERC20(newAddress);
195     }
196 
197     // MINTING FUNCTIONS
198     // INTERNAL FOR PRESALE
199     function _mint(address to, uint amount) internal {
200         require(presaleRunning == true || tuning == true);
201 
202         balances[to] = balances[to].add(amount);
203         _totalSupply = _totalSupply.add(amount);
204 
205         emit Transfer(address(this), msg.sender, amount);
206     }
207 
208     // POST PRESALE. OWNERSHIP TRANSFERRED TO SMART CONTRACT
209     function mint(address to, uint256 amount) onlyOwner public {
210         require(presaleRunning == false);
211         
212         balances[to] = balances[to].add(amount);
213         _totalSupply = _totalSupply.add(amount);
214 
215         emit Transfer(address(this), msg.sender, amount);
216     }
217 
218     
219     function endPresale() onlyOwner public {
220         presaleRunning = false;
221     }
222     
223     function calculateRate(address token, uint256 amount) public view returns (uint256) {
224         uint256 rate;
225         
226         if (token == address(boaContract)) {
227             rate = boaRate;
228         }
229         else if (token == address(xampContract)) {
230             rate = xampRate;
231         }
232         else if (token == address(tobContract)) {
233             rate = tobRate;
234         }
235         
236         require(rate > 0);
237         
238         return amount.mul(rate).div(10 ** 18);
239     }
240 
241     function _purchaseWithToken(IERC20 token, uint256 amount) internal {
242         token.transferFrom(msg.sender, _owner, amount);
243         
244         uint256 _rate = calculateRate(address(token), amount);
245         
246         _mint(msg.sender, _rate);
247     }
248 
249     function purchaseWithBOA(uint256 amount) public returns (bool success) {
250         _purchaseWithToken(boaContract, amount);
251         return true;
252     }
253 
254     function purchaseWithXAMP (uint256 amount) public returns (bool success) {
255         _purchaseWithToken(xampContract, amount);
256         return true;
257     }
258 
259     function purchaseWithTOB (uint256 amount) public returns (bool success) {
260         _purchaseWithToken(tobContract, amount);
261         return true;
262     }
263 }