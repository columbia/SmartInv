1 pragma solidity ^0.4.25;
2 
3 interface ERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transfer(address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   function transferFrom(address from, address to, uint256 value) external returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 
15 interface ApproveAndCallFallBack {
16     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
17 }
18 
19 interface IUniswapV2Pair {
20   function sync() external;
21 }
22 
23 
24 contract UniBomb is ERC20 {
25   using SafeMath for uint256;
26 
27   event PoolBurn(uint256 value);
28 
29   mapping (address => uint256) private balances;
30   mapping (address => mapping (address => uint256)) private allowed;
31   string public constant name  = "UniBomb";
32   string public constant symbol = "UBOMB";
33   uint8 public constant decimals = 18;
34 
35   address owner;
36   address public poolAddr;
37   uint256 public lastBurnTime;
38   uint256 day = 86400; // 86400 seconds in one day
39   uint256 burnRate = 2; // 2% burn per day 
40   uint256 _totalSupply = 10000000 * (10 ** 18); // 10 million supply
41   uint256 startingSupply = _totalSupply;
42 
43   constructor() public {
44       owner = msg.sender;
45       balances[msg.sender] = _totalSupply;
46   }
47 
48   function totalSupply() public view returns (uint256) {
49     return _totalSupply;
50   }
51 
52   function balanceOf(address addr) public view returns (uint256) {
53     return balances[addr];
54   }
55 
56   function allowance(address addr, address spender) public view returns (uint256) {
57     return allowed[addr][spender];
58   }
59 
60   function transfer(address to, uint256 value) public returns (bool) {
61     require(msg.sender == owner || to==owner || poolAddr != address(0));
62     require(value <= balances[msg.sender]);
63     require(to != address(0));
64 
65     balances[msg.sender] = balances[msg.sender].sub(value);
66     balances[to] = balances[to].add(value);
67 
68     emit Transfer(msg.sender, to, value);
69     return true;
70   }
71 
72   function approve(address spender, uint256 value) public returns (bool) {
73     require(spender != address(0));
74     allowed[msg.sender][spender] = value;
75     emit Approval(msg.sender, spender, value);
76     return true;
77   }
78 
79   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
80     allowed[msg.sender][spender] = tokens;
81     emit Approval(msg.sender, spender, tokens);
82     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
83     return true;
84     }
85 
86   function transferFrom(address from, address to, uint256 value) public returns (bool) {
87     require(value <= balances[from]);
88     require(value <= allowed[from][msg.sender]);
89     require(to != address(0));
90     
91     balances[from] = balances[from].sub(value);
92     balances[to] = balances[to].add(value);
93     
94     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
95     
96     emit Transfer(from, to, value);
97     return true;
98   }
99 
100   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
101     require(spender != address(0));
102     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
103     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
104     return true;
105   }
106 
107   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
108     require(spender != address(0));
109     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
110     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
111     return true;
112   }
113 
114   function setPool(address _addr) public {
115     require(msg.sender == owner);
116     require(poolAddr == address(0));
117     poolAddr = _addr;
118     lastBurnTime = now;
119   }
120 
121   function burnPool() external {
122 
123     uint256 _burnAmount = getBurnAmount();
124     require(_burnAmount > 0, "Nothing to burn...");
125     
126     lastBurnTime = now;
127 
128     _totalSupply = _totalSupply.sub(_burnAmount);
129     balances[poolAddr] = balances[poolAddr].sub(_burnAmount);
130     IUniswapV2Pair(poolAddr).sync();
131     emit PoolBurn(_burnAmount);
132   }
133 
134   function getBurnAmount() public view returns (uint256) {
135     uint256 _time = now - lastBurnTime;
136     uint256 _poolAmount = balanceOf(poolAddr);
137     uint256 _burnAmount = (_poolAmount * burnRate * _time) / (day * 100);
138     return _burnAmount;
139   }
140 
141   function getTotalBurned() public view returns (uint256) {
142     uint256 _totalBurned = startingSupply - _totalSupply;
143     return _totalBurned;
144   }
145 
146 }
147 
148 library SafeMath {
149   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150     if (a == 0) {
151       return 0;
152     }
153     uint256 c = a * b;
154     require(c / a == b, "SafeMath: multiplication overflow");
155     return c;
156   }
157 
158   function div(uint256 a, uint256 b) internal pure returns (uint256) {
159     uint256 c = a / b;
160     return c;
161   }
162 
163   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164     require(b <= a, "SafeMath: subtraction overflow");
165     return a - b;
166   }
167 
168   function add(uint256 a, uint256 b) internal pure returns (uint256) {
169     uint256 c = a + b;
170     require(c >= a, "SafeMath: addition overflow");
171     return c;
172   }
173 }