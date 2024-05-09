1 pragma solidity 0.4.25;
2 
3 
4 library SafeMath {
5 
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17 
18 
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25 
26 
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41 
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45 
46         return c;
47     }
48 
49     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
50         return mod(a, b, "SafeMath: modulo by zero");
51     }
52 
53     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b != 0, errorMessage);
55         return a % b;
56     }
57 }
58 
59 pragma solidity 0.4.25;
60 
61 
62     contract AWToken {
63 
64         string public name;
65 
66         string public symbol;
67 
68         uint8 public decimals;
69 
70         uint public totalSupply;
71 
72         uint public supplied;
73 
74         uint public surplusSupply;
75 
76 
77         uint beforeFrequency = 0;
78 
79         uint centerFrequency = 300;
80 
81         uint afterFrequency = 400;
82 
83         address owner;
84 
85         uint public usdtPrice = 10000;
86 
87         address gameAddr;
88 
89 
90         mapping(address => uint) public balanceOf;
91 
92 
93         mapping(address => mapping(address => uint)) public allowance;
94 
95         constructor(
96             string _name,
97             string _symbol,
98             uint8 _decimals,
99             uint _totalSupply,
100             address _owner
101         )  public {
102             name = _name;
103             symbol = _symbol;
104             decimals = _decimals;
105             totalSupply = _totalSupply * (10 ** uint256(decimals));
106             owner = _owner;
107             surplusSupply = totalSupply;
108         }
109 
110         event Transfer(address indexed from, address indexed to,uint value);
111 
112         event Approval(address indexed owner, address indexed spender, uint256 value);
113 
114         modifier validDestination(address _to) {
115 
116             require(_to != address(0x0), "address cannot be 0x0");
117             require(_to != address(this), "address cannot be contract address");
118             _;
119         }
120 
121 
122         function setGameAddr(address addr) external {
123             require(owner == msg.sender, "Insufficient permissions");
124             gameAddr = addr;
125         }
126 
127         function calculationNeedAW(uint usdtVal) external view returns(uint) {
128             uint awCount = SafeMath.div(SafeMath.div(SafeMath.mul(usdtVal, 10 ** 8), 10), usdtPrice);
129             return awCount;
130         }
131 
132         function riseUsdt(uint index, uint count) internal returns(uint) {
133             if(count > index) {
134                 for(uint i = index; i < count; i++) {
135                     usdtPrice = SafeMath.add(usdtPrice, SafeMath.div(usdtPrice, 100));
136                 }
137             }
138             return count;
139         }
140 
141 
142         function gainAWToken(uint value, bool isCovert) external {
143             require(msg.sender == gameAddr, "Insufficient permissions");
144             require(value <= surplusSupply, "AW tokens are larger than the remaining supply");
145             surplusSupply = SafeMath.sub(surplusSupply, value);
146             supplied = SafeMath.add(supplied, value);
147             if(isCovert) {
148 
149                 uint number = SafeMath.div(supplied, 10 ** 12);
150                 if(number <= 18900) {
151                     uint count = 0;
152                     if(number <= 6000) {
153                         count = SafeMath.div(number, 10);
154                         beforeFrequency = riseUsdt(beforeFrequency, count);
155                     }else if(number <= 12000) {
156                         if(beforeFrequency < 600) {
157                             beforeFrequency = riseUsdt(beforeFrequency, 600);
158                         }
159                         count = SafeMath.div(number, 20);
160                         centerFrequency = riseUsdt(centerFrequency, count);
161                     }else {
162                         if(centerFrequency < 600) {
163                             centerFrequency = riseUsdt(centerFrequency, 600);
164                         }
165                         count = SafeMath.div(number, 30);
166                         afterFrequency = riseUsdt(afterFrequency, count);
167                     }
168                 }
169             }
170             balanceOf[msg.sender] = SafeMath.add(balanceOf[msg.sender], value);
171         }
172 
173 
174         function transfer(address to, uint value) public validDestination(to) {
175             require(value >= 0, "Incorrect transfer amount");
176             require(balanceOf[msg.sender] >= value, "Insufficient balance");
177             require(balanceOf[to] + value >= balanceOf[to], "Transfer failed");
178 
179             balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], value);
180             balanceOf[to] = SafeMath.add(balanceOf[to], value);
181 
182             emit Transfer(msg.sender, to, value);
183         }
184 
185 
186         function approve(address spender, uint value) public {
187               require((value == 0) || (allowance[msg.sender][spender] == 0), "Authorized tokens are not used up");
188               allowance[msg.sender][spender] = value;
189               emit Approval(msg.sender, spender, value);
190         }
191 
192 
193         function transferFrom(address from, address to, uint value) public validDestination(to) {
194             require(value >= 0, "Incorrect transfer amount");
195             require(balanceOf[from] >= value, "Insufficient balance");
196             require(balanceOf[to] + value >= balanceOf[to], "Transfer failed");
197             require(value <= allowance[from][msg.sender], "The transfer amount is higher than the available amount");
198 
199             balanceOf[from] = SafeMath.sub(balanceOf[from], value);
200             balanceOf[to] = SafeMath.add(balanceOf[to], value);
201             allowance[from][msg.sender] = SafeMath.sub(allowance[from][msg.sender], value);
202 
203             emit Transfer(from, to, value);
204         }
205 
206 
207         function burn(address addr, uint value) public {
208             require(msg.sender == gameAddr, "Insufficient permissions");
209             require(balanceOf[addr] >= value, "Insufficient balance");
210 
211             balanceOf[addr] = SafeMath.sub(balanceOf[addr], value);
212             balanceOf[address(0x0)] = SafeMath.add(balanceOf[address(0x0)], value);
213 
214             emit Transfer(addr, address(0x0), value);
215         }
216     }