1 pragma solidity ^0.4.24;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) returns (bool success);
5 }
6  
7 
8 contract SafeMath {
9 
10     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
11         uint256 z = x + y;
12         assert((z >= x) && (z >= y));
13         return z;
14     }
15  
16     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
17         assert(x >= y);
18         uint256 z = x - y;
19         return z;
20     }
21  
22     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
23         uint256 z = x * y;
24         assert((x == 0)||(z/x == y));
25         return z;
26     }
27  
28 }
29  
30 contract Token {
31     uint256 public totalSupply;
32     function balanceOf(address _owner) constant returns (uint256 balance);
33     function transfer(address _to, uint256 _value) returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35     function approve(address _spender, uint256 _value) returns (bool success);
36     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40  
41  
42 /*  ERC 20 token */
43 contract StandardToken is Token {
44  
45     function transfer(address _to, uint256 _value) returns (bool success) {
46         if (balances[msg.sender] >= _value && _value > 0) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             Transfer(msg.sender, _to, _value);
50             return true;
51         } else {
52             return false;
53         }
54     }
55  
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             allowed[_from][msg.sender] -= _value;
61             Transfer(_from, _to, _value);
62             return true;
63         } else {
64             return false;
65         }
66     }
67  
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71  
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77  
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79         return allowed[_owner][_spender];
80     }
81  
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85  
86 contract ACCTToken is StandardToken, SafeMath {
87  
88     // metadata
89     string  public constant name = "ACCTToken";
90     string  public constant symbol = "ACCT";
91     uint256 public constant decimals = 21;
92     string  public version = "1.0";
93  
94     // contracts
95     // ETH Deposit Address
96     address public ethFundDeposit;   
97     //Token update address
98     address public newContractAddr;      
99  
100     // crowdsale parameters
101     //Switch state to true
102     bool    public isFunding;               
103     uint256 public fundingStartBlock;
104     uint256 public fundingStopBlock;
105     
106     
107     //Number of tokens on sale
108     uint256 public currentSupply;   
109     //Total sales volume token
110     uint256 public tokenRaised = 0;  
111     //Total traded token
112     uint256 public tokenMigrated = 0;  
113    
114  
115     // events
116     event IncreaseSupply(uint256 _value);
117     event DecreaseSupply(uint256 _value);
118     event Migrate(address indexed _to, uint256 _value);
119  
120     // 转换
121     function formatDecimals(uint256 _value) internal returns (uint256 ) {
122         return _value * 10 ** decimals;
123     }
124  
125     // constructor
126     function ACCTToken(
127         address _ethFundDeposit,
128         uint256 _currentSupply)
129     {
130         ethFundDeposit = _ethFundDeposit;
131  
132         isFunding = false;                           //通过控制预CrowdS ale状态
133         fundingStartBlock = 0;
134         fundingStopBlock = 0;
135  
136         currentSupply = formatDecimals(_currentSupply);
137         totalSupply = formatDecimals(10000000000);
138         balances[msg.sender] = totalSupply;
139         if(currentSupply > totalSupply) throw;
140     }
141  
142     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
143 
144  
145     /// @dev 被盗token处理
146     function decreaseSupply (uint256 _value) isOwner external {
147         uint256 value = formatDecimals(_value);
148         if (value + tokenRaised > currentSupply) throw;
149  
150         currentSupply = safeSubtract(currentSupply, value);
151         DecreaseSupply(value);
152     }
153  
154    
155     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
156         if (isFunding) throw;
157         if (_fundingStartBlock >= _fundingStopBlock) throw;
158         if (block.number >= _fundingStartBlock) throw;
159  
160         fundingStartBlock = _fundingStartBlock;
161         fundingStopBlock = _fundingStopBlock;
162         isFunding = true;
163     }
164  
165    
166     function stopFunding() isOwner external {
167         if (!isFunding) throw;
168         isFunding = false;
169     }
170 
171    
172     function changeOwner(address _newFundDeposit) isOwner() external {
173         if (_newFundDeposit == address(0x0)) throw;
174         ethFundDeposit = _newFundDeposit;
175     }
176  
177  
178     function migrate() external {
179         if(isFunding) throw;
180         if(newContractAddr == address(0x0)) throw;
181  
182         uint256 tokens = balances[msg.sender];
183         if (tokens == 0) throw;
184  
185         balances[msg.sender] = 0;
186         tokenMigrated = safeAdd(tokenMigrated, tokens);
187  
188         IMigrationContract newContract = IMigrationContract(newContractAddr);
189         if (!newContract.migrate(msg.sender, tokens)) throw;
190  
191         Migrate(msg.sender, tokens);               // log it
192     }
193  
194 }