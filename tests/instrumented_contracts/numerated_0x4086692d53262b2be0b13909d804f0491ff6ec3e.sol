1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-08
3 */
4 
5 pragma solidity 0.6.12;
6 
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a, "SafeMath: addition overflow");
11 
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         return sub(a, b, "SafeMath: subtraction overflow");
17     }
18 
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25 
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30 
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33 
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40 
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44 
45         return c;
46     }
47 
48     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
49         return mod(a, b, "SafeMath: modulo by zero");
50     }
51 
52     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b != 0, errorMessage);
54         return a % b;
55     }
56 }
57 
58 contract Ownable {
59     address public _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor () public {
64         _owner = msg.sender;
65         emit OwnershipTransferred(address(0), msg.sender);
66     }
67 
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     modifier onlyOwner() {
73         require(_owner == msg.sender, "Ownable: caller is not the owner");
74         _;
75     }
76 
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 interface IERC20 {
90     function totalSupply() external view returns (uint256);
91     function balanceOf(address tokenOwner) external view returns (uint256 balance);
92     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
93     function transfer(address to, uint tokens) external returns (bool success);
94     function approve(address spender, uint tokens) external returns (bool success);
95     function transferFrom(address from, address to, uint tokens) external returns (bool success);
96 
97     function increaseAllowance(address spender, uint addedValue) external returns (bool success);
98     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool success);
99 
100     event Transfer(address indexed from, address indexed to, uint tokens);
101     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
102 }
103 
104 contract ERC20 {
105     using SafeMath for uint256;
106     
107     // ERC20 Token variables
108     string public symbol = "YFKA";
109     string public name = "Yield Farming Known as Ash";
110     uint8 public decimals = 18;
111     uint256 public _totalSupply = 0;
112     
113     mapping(address => uint256) public balances;
114     mapping(address => mapping(address => uint256)) public allowance;
115     
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117     event Transfer(address indexed from, address indexed to, uint256 value);
118     
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122     
123     function balanceOf(address account) public view returns (uint256 balance) {
124         return balances[account];
125     }
126     
127     function transfer(address recipient, uint256 amount) public returns (bool success) {
128         balances[msg.sender] = balances[msg.sender].sub(amount, "ERC20: transfer amount exceeds balance");
129         balances[recipient] = balances[recipient].add(amount);
130         emit Transfer(msg.sender, recipient, amount);
131         return true;
132     }
133     
134     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
135         balances[from] = balances[from].sub(tokens);
136         allowance[from][msg.sender] = allowance[from][msg.sender].sub(tokens);
137         balances[to] = balances[to].add(tokens);
138         Transfer(from, to, tokens);
139         return true;
140     }
141     
142     
143     function approve(address spender, uint tokens) public returns (bool success) {
144         allowance[msg.sender][spender] = tokens;
145         Approval(msg.sender, spender, tokens);
146         return true;
147     }
148 }
149 
150 contract YFKA is ERC20, Ownable {
151     using SafeMath for uint256;
152 
153     IERC20 public boaContract;
154     uint256 public boaRate;
155 
156     IERC20 public xampContract;
157     uint256 public xampRate;
158 
159     IERC20 public tobContract;
160     uint256 public tobRate;
161 
162     bool public presaleRunning = true;
163     bool public tuning = true;
164     
165     // OPERATIONAL FUNCTIONS FOR TESTING
166     function turnOffTuning() public onlyOwner {
167         tuning = false;
168     }
169     
170     function setUp(address _boaContract, uint256 _boaRate, address _xampContract, uint256 _xampRate, address _tobContract, uint256 _tobRate) public onlyOwner {
171         require(tuning == true);
172         
173         boaContract = IERC20(_boaContract);
174         boaRate = _boaRate;
175 
176         xampContract = IERC20(_xampContract);
177         xampRate = _xampRate;
178 
179         tobContract = IERC20(_tobContract);
180         tobRate = _tobRate;
181     }
182     
183     function changeRate(address _addr, uint256 newRate) public onlyOwner {
184         require(tuning == true);
185         
186         if (_addr == address(boaContract)) boaRate = newRate;
187         else if (_addr == address(xampContract)) xampRate = newRate;
188         else if (_addr == address(tobContract)) tobRate = newRate;
189     }
190     
191     function changeContract(address _addr, address newAddress) public onlyOwner {
192         require(tuning == true);
193         
194         if (_addr == address(boaContract)) boaContract = IERC20(newAddress);
195         else if (_addr == address(xampContract)) xampContract = IERC20(newAddress);
196         else if (_addr == address(tobContract)) tobContract = IERC20(newAddress);
197     }
198 
199     // MINTING FUNCTIONS
200     // INTERNAL FOR PRESALE
201     function _mint(address to, uint amount) internal {
202         require(presaleRunning == true || tuning == true);
203 
204         balances[to] = balances[to].add(amount);
205         _totalSupply = _totalSupply.add(amount);
206 
207         emit Transfer(address(this), msg.sender, amount);
208     }
209 
210     // POST PRESALE. OWNERSHIP TRANSFERRED TO SMART CONTRACT
211     function mint(address to, uint256 amount) onlyOwner public {
212         require(presaleRunning == false || tuning == true);
213         
214         balances[to] = balances[to].add(amount);
215         _totalSupply = _totalSupply.add(amount);
216 
217         emit Transfer(address(this), msg.sender, amount);
218     }
219 
220     
221     function endPresale() onlyOwner public {
222         presaleRunning = false;
223     }
224     
225     function calculateRate(address token, uint256 amount) public view returns (uint256) {
226         uint256 rate;
227         
228         if (token == address(boaContract)) {
229             rate = boaRate;
230         }
231         else if (token == address(xampContract)) {
232             rate = xampRate;
233         }
234         else if (token == address(tobContract)) {
235             rate = tobRate;
236         }
237         
238         require(rate > 0);
239         
240         return amount.mul(rate).div(10 ** 18);
241     }
242 
243     function _purchaseWithToken(IERC20 token, uint256 amount) internal {
244         token.transferFrom(msg.sender, _owner, amount);
245         
246         uint256 _rate = calculateRate(address(token), amount);
247         
248         _mint(msg.sender, _rate);
249     }
250 
251     function purchaseWithBOA(uint256 amount) public returns (bool success) {
252         _purchaseWithToken(boaContract, amount);
253         return true;
254     }
255 
256     function purchaseWithXAMP (uint256 amount) public returns (bool success) {
257         _purchaseWithToken(xampContract, amount);
258         return true;
259     }
260 
261     function purchaseWithTOB (uint256 amount) public returns (bool success) {
262         _purchaseWithToken(tobContract, amount);
263         return true;
264     }
265 }