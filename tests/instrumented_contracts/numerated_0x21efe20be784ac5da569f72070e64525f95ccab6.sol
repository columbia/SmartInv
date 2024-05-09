1 pragma solidity >=0.4.22 <0.6.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         require(c / a == b, "SafeMath: multiplication overflow");
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0, "SafeMath: division by zero");
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a, "SafeMath: subtraction overflow");
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30 }
31 
32 contract ERC20 {
33     function totalSupply() public view returns (uint supply);
34     function balanceOf(address who) public view returns (uint value);
35     function allowance(address owner, address spender) public view returns (uint remaining);
36 
37     function transfer(address to, uint value) public returns (bool ok);
38     function transferFrom(address from, address to, uint value) public returns (bool ok);
39     function approve(address spender, uint value) public returns (bool ok);
40 
41     event Burned(uint value, uint when);
42     event Stacked(address indexed from, uint value, uint when);
43     event Transfer(address indexed from, address indexed to, uint value);
44     event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 contract AZBIcore is ERC20{
48 
49     modifier onlyTeam{
50         require(msg.sender == teamAddress, "This function is for team only!");
51         _;
52     }
53 
54     using SafeMath for uint256;
55     uint8 public constant decimals = 18;
56     uint256 initialSupply;
57     uint256 public soldTokens = 0;
58     uint256 public currentPrice;
59     uint256 public currentInterest;
60     string public constant name = "AZBI core";
61     string public constant symbol = "AZBI";
62 
63     //add valid address!!!
64     address payable teamAddress;
65     address stakingRewardAddress = address(this);
66 
67     mapping (address => uint256) balances;
68     mapping (address => uint256) stacked;
69     mapping (address => uint256) timeOfStacking;
70 
71     mapping (address => mapping (address => uint256)) allowed;
72 
73     function stake() public returns (bool success) {
74         if (balances[msg.sender] >= 0) {
75             uint256 value = balances[msg.sender];
76             stacked[msg.sender] = stacked[msg.sender].add(value);
77             balances[msg.sender] = 0;
78             timeOfStacking[msg.sender] = now;
79             emit Stacked(msg.sender, value, now);
80             return true;
81         } else {
82             return false;
83         }
84     }
85 
86     function currentReward(address owner) public view returns (uint256 value) {
87         if (stacked[owner] > 0) {
88             uint256 reward = stacked[owner].mul(currentInterest).div(100).mul(now.sub(timeOfStacking[owner])).div(365 days);  // 20% per year
89             if (reward<=balances[stakingRewardAddress]) {
90                 return reward;
91             } else {
92                 return balances[stakingRewardAddress];
93             }
94         }
95         else return 0;
96     }
97 
98     function getStacked(address owner) public view returns (uint256 value) {
99         return stacked[owner];
100     }
101 
102     function claimReward() public returns (bool success) {
103         require(stacked[msg.sender]>0, "You need to have something staked first"); // none stacked
104         uint256 reward = currentReward(msg.sender);
105         balances[stakingRewardAddress] = balances[stakingRewardAddress].sub(reward);
106         balances[msg.sender] = balances[msg.sender].add(reward);
107         balances[msg.sender] = balances[msg.sender].add(stacked[msg.sender]);
108         stacked[msg.sender] = 0;
109         return true;
110     }
111 
112     function totalSupply() public view returns (uint256) {
113         return initialSupply;
114     }
115 
116     function balanceOf(address owner) public view returns (uint256 balance) {
117         return balances[owner];
118     }
119 
120     function allowance(address owner, address spender) public view returns (uint remaining) {
121         return allowed[owner][spender];
122     }
123 
124     function transfer(address to, uint256 value) public returns (bool success) {
125         if (balances[msg.sender] >= value) {
126             require (value>=10**2, "too small amount of AZBI"); // too small amount of AZBI
127             balances[msg.sender] = balances[msg.sender].sub(value);
128             uint256 toBurn = value.div(100);
129             uint256 forReward = value.mul(3).div(100);
130             uint256 toTransfer = value.mul(96).div(100);
131             balances[to] = balances[to].add(toTransfer);
132             balances[stakingRewardAddress] = balances[stakingRewardAddress].add(forReward);
133             emit Burned(toBurn, now);
134             initialSupply = initialSupply.sub(toBurn);
135             emit Transfer(msg.sender, to, toTransfer);
136             emit Transfer(msg.sender, stakingRewardAddress, forReward);
137             return true;
138         } else {
139             return false;
140         }
141     }
142 
143     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
144         if (balances[from] >= value && allowed[from][msg.sender] >= value) {
145             require (value>=10**2, "too small amount of AZBI"); // too small amount of AZBI
146             uint256 toBurn = value.div(100);
147             uint256 forReward = value.mul(3).div(100);
148             uint256 toTransfer = value.mul(96).div(100);
149             balances[from] = balances[from].sub(value);
150             allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
151             balances[to] = balances[to].add(toTransfer);
152             balances[stakingRewardAddress] = balances[stakingRewardAddress].add(forReward);
153             emit Burned(toBurn, now);
154             initialSupply = initialSupply.sub(toBurn);
155             emit Transfer(from, to, toTransfer);
156             emit Transfer(from, stakingRewardAddress, forReward);
157             return true;
158         } else {
159             return false;
160         }
161     }
162 
163     function approve(address spender, uint256 value) public returns (bool success) {
164         allowed[msg.sender][spender] = value;
165         emit Approval(msg.sender, spender, value);
166         return true;
167     }
168 
169     function changeInterest(uint256 value) public onlyTeam {
170         currentInterest = value;
171     }
172 
173     function changePrice(uint256 value) public onlyTeam {
174         currentPrice = value;
175     }
176 
177     constructor() public payable {
178         teamAddress = address(0x8EcA013b8eca5a8643914798AdBdf313BF91AC8a);
179         initialSupply = 20000000000*10**uint256(decimals);
180         currentPrice = 5 * 10**12;
181         currentInterest = 20;
182         balances[teamAddress] = initialSupply.mul(6).div(10);
183         balances[stakingRewardAddress] = initialSupply.mul(4).div(10);
184     }
185 
186     function () external payable {
187         require (msg.value>=10**15, "Send 0.001 ETH minimum"); // 0.001 ETH min
188         uint256 valueToPass =  msg.value.div(currentPrice).mul(10**uint256(decimals));
189         if (balances[address(this)] <= valueToPass)
190             valueToPass = balances[address(this)];
191 
192         soldTokens = soldTokens.add(valueToPass);
193 
194         if (balances[address(this)] >= valueToPass && valueToPass > 0) {
195             balances[msg.sender] = balances[msg.sender].add(valueToPass);
196             balances[address(this)] = balances[address(this)].sub(valueToPass);
197             emit Transfer(address(this), msg.sender, valueToPass);
198         }
199         teamAddress.transfer(msg.value);
200     }
201 }