1 // ____   ____  _____   ______    ____  _________________      ______        _____                    _____          ____           _____    
2 //|    | |    ||\    \ |\     \  |    |/                 \ ___|\     \   ___|\    \               ___|\    \    ____|\   \     ____|\    \   
3 //|    | |    | \\    \| \     \ |    |\______     ______/|     \     \ |    |\    \             |    |\    \  /    /\    \   /     /\    \  
4 //|    | |    |  \|    \  \     ||    |   \( /    /  )/   |     ,_____/||    | |    |            |    | |    ||    |  |    | /     /  \    \ 
5 //|    | |    |   |     \  |    ||    |    ' |   |   '    |     \--'\_|/|    | |    |            |    | |    ||    |__|    ||     |    |    |
6 //|    | |    |   |      \ |    ||    |      |   |        |     /___/|  |    | |    |            |    | |    ||    .--.    ||     |    |    |
7 //|    | |    |   |    |\ \|    ||    |     /   //        |     \____|\ |    | |    |            |    | |    ||    |  |    ||\     \  /    /|
8 //|\___\_|____|   |____||\_____/||____|    /___//         |____ '     /||____|/____/|            |____|/____/||____|  |____|| \_____\/____/ |
9 //| |    |    |   |    |/ \|   |||    |   |`   |          |    /_____/ ||    /    | |            |    /    | ||    |  |    | \ |    ||    | /
10 // \|____|____|   |____|   |___|/|____|   |____|          |____|     | /|____|____|/             |____|____|/ |____|  |____|  \|____||____|/ 
11 //    \(   )/       \(       )/    \(       \(              \( |_____|/   \(    )/                 \(    )/     \(      )/       \(    )/    
12 //     '   '         '       '      '        '               '    )/       '    '                   '    '       '      '         '    '    
13 
14 
15 // TG - https://t.me/unitedDaoforever
16 
17 //Disclaimer: The inherent value of UD is 0 and if it seems to be trading on the open market for more, be very aware that the value can return again to zero very quickly. 
18 //Don't invest what you can't afford to lose.
19 
20 
21 pragma solidity ^0.4.25;
22 
23 interface ERC20 {
24   function totalSupply() external view returns (uint256);
25   function balanceOf(address who) external view returns (uint256);
26   function allowance(address owner, address spender) external view returns (uint256);
27   function transfer(address to, uint256 value) external returns (bool);
28   function approve(address spender, uint256 value) external returns (bool);
29   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
30   function transferFrom(address from, address to, uint256 value) external returns (bool);
31 
32   event Transfer(address indexed from, address indexed to, uint256 value);
33   event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 interface ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
38 }
39 
40 
41 contract UD is ERC20 {
42   using SafeMath for uint256;
43 
44   mapping (address => uint256) private balances;
45   mapping (address => mapping (address => uint256)) private allowed;
46   string public constant name  = "United Dao";
47   string public constant symbol = "UD";
48   uint8 public constant decimals = 18;
49   
50   address owner = msg.sender;
51 
52   uint256 _totalSupply = 1800 * (10 ** 18); 
53 
54   constructor() public {
55     balances[msg.sender] = _totalSupply;
56     emit Transfer(address(0), msg.sender, _totalSupply);
57   }
58 
59   function totalSupply() public view returns (uint256) {
60     return _totalSupply;
61   }
62 
63   function balanceOf(address player) public view returns (uint256) {
64     return balances[player];
65   }
66 
67   function allowance(address player, address spender) public view returns (uint256) {
68     return allowed[player][spender];
69   }
70 
71 
72   function transfer(address to, uint256 value) public returns (bool) {
73     require(value <= balances[msg.sender]);
74     require(to != address(0));
75 
76     balances[msg.sender] = balances[msg.sender].sub(value);
77     balances[to] = balances[to].add(value);
78 
79     emit Transfer(msg.sender, to, value);
80     return true;
81   }
82 
83   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
84     for (uint256 i = 0; i < receivers.length; i++) {
85       transfer(receivers[i], amounts[i]);
86     }
87   }
88 
89   function approve(address spender, uint256 value) public returns (bool) {
90     require(spender != address(0));
91     allowed[msg.sender][spender] = value;
92     emit Approval(msg.sender, spender, value);
93     return true;
94   }
95 
96   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
97         allowed[msg.sender][spender] = tokens;
98         emit Approval(msg.sender, spender, tokens);
99         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
100         return true;
101     }
102 
103   function transferFrom(address from, address to, uint256 value) public returns (bool) {
104     require(value <= balances[from]);
105     require(value <= allowed[from][msg.sender]);
106     require(to != address(0));
107     
108     balances[from] = balances[from].sub(value);
109     balances[to] = balances[to].add(value);
110     
111     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
112     
113     emit Transfer(from, to, value);
114     return true;
115   }
116 
117   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
118     require(spender != address(0));
119     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
120     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
121     return true;
122   }
123 
124   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
125     require(spender != address(0));
126     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
127     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
128     return true;
129   }
130 
131   function burn(uint256 amount) external {
132     require(amount != 0);
133     require(amount <= balances[msg.sender]);
134     _totalSupply = _totalSupply.sub(amount);
135     balances[msg.sender] = balances[msg.sender].sub(amount);
136     emit Transfer(msg.sender, address(0), amount);
137   }
138 }
139 
140 
141 
142 
143 library SafeMath {
144   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145     if (a == 0) {
146       return 0;
147     }
148     uint256 c = a * b;
149     require(c / a == b);
150     return c;
151   }
152 
153   function div(uint256 a, uint256 b) internal pure returns (uint256) {
154     uint256 c = a / b;
155     return c;
156   }
157 
158   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159     require(b <= a);
160     return a - b;
161   }
162 
163   function add(uint256 a, uint256 b) internal pure returns (uint256) {
164     uint256 c = a + b;
165     require(c >= a);
166     return c;
167   }
168 
169   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
170     uint256 c = add(a,m);
171     uint256 d = sub(c,1);
172     return mul(div(d,m),m);
173   }
174 }