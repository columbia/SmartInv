1 pragma solidity ^0.4.12;
2 
3 
4 /* JetQe  */
5 
6 
7 
8 contract IMigrationContract {
9     function migrate(address addr, uint256 nas) returns (bool success);
10 }
11  
12 /* safe computing */
13 contract SafeMath {
14  
15  
16     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
17         uint256 z = x + y;
18         assert((z >= x) && (z >= y));
19         return z;
20     }
21  
22     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
23         assert(x >= y);
24         uint256 z = x - y;
25         return z;
26     }
27  
28     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
29         uint256 z = x * y;
30         assert((x == 0)||(z/x == y));
31         return z;
32     }
33  
34 }
35  
36 contract Token {
37     uint256 public totalSupply;
38     function balanceOf(address _owner) constant returns (uint256 balance);
39     function transfer(address _to, uint256 _value) returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41     function approve(address _spender, uint256 _value) returns (bool success);
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46  
47  
48 /*  ERC 20 token */
49 contract StandardToken is Token {
50  
51     function transfer(address _to, uint256 _value) returns (bool success) {
52         if (balances[msg.sender] >= _value && _value > 0) {
53             balances[msg.sender] -= _value;
54             balances[_to] += _value;
55             Transfer(msg.sender, _to, _value);
56             return true;
57         } else {
58             return false;
59         }
60     }
61  
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
64             balances[_to] += _value;
65             balances[_from] -= _value;
66             allowed[_from][msg.sender] -= _value;
67             Transfer(_from, _to, _value);
68             return true;
69         } else {
70             return false;
71         }
72     }
73  
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77  
78     function approve(address _spender, uint256 _value) returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83  
84     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
85         return allowed[_owner][_spender];
86     }
87  
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90 }
91  
92 contract DEJToken is StandardToken, SafeMath {
93  
94     // metadata
95     string  public constant name = "De Home";
96     string  public constant symbol = "DEJ";
97     uint256 public constant decimals = 18;
98     string  public version = "1.0";
99  
100     // contracts
101     address public ethFundDeposit;          // ETH存放地址
102     address public newContractAddr;         // token更新地址
103  
104     // crowdsale parameters
105     bool    public isFunding;                // 状态切换到true
106     uint256 public fundingStartBlock;
107     uint256 public fundingStopBlock;
108  
109     uint256 public currentSupply;           // 正在售卖中的tokens数量
110     uint256 public tokenRaised = 0;         // 总的售卖数量token
111     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
112  
113     // events
114 
115     event IncreaseSupply(uint256 _value);
116     event DecreaseSupply(uint256 _value);
117  
118     // transfer
119     function formatDecimals(uint256 _value) internal returns (uint256 ) {
120         return _value * 10 ** decimals;
121     }
122  
123     // constructor
124     function DEJToken()
125     {
126         ethFundDeposit  = 0x697e6C6845212AE294E55E0adB13977de0F0BD37;
127  
128         isFunding = false;                           //通过控制预CrowdS ale状态
129         fundingStartBlock = 0;
130         fundingStopBlock = 0;
131  
132         currentSupply = formatDecimals(1000000000);
133         totalSupply = formatDecimals(1000000000);
134         balances[msg.sender] = totalSupply;
135         if(currentSupply > totalSupply) throw;
136     }
137  
138     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
139     
140 
141  
142     /// @dev 超发token处理
143     function increaseSupply (uint256 _value) isOwner external {
144         uint256 value = formatDecimals(_value);
145         if (value + currentSupply > totalSupply) throw;
146         currentSupply = safeAdd(currentSupply, value);
147         IncreaseSupply(value);
148     }
149  
150     /// @dev 被盗token处理
151     function decreaseSupply (uint256 _value) isOwner external {
152         uint256 value = formatDecimals(_value);
153         if (value + tokenRaised > currentSupply) throw;
154  
155         currentSupply = safeSubtract(currentSupply, value);
156         DecreaseSupply(value);
157     }
158  
159     ///  启动区块检测 异常的处理
160     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
161         if (isFunding) throw;
162         if (_fundingStartBlock >= _fundingStopBlock) throw;
163         if (block.number >= _fundingStartBlock) throw;
164  
165         fundingStartBlock = _fundingStartBlock;
166         fundingStopBlock = _fundingStopBlock;
167         isFunding = true;
168     }
169  
170     ///  关闭区块异常处理
171     function stopFunding() isOwner external {
172         if (!isFunding) throw;
173         isFunding = false;
174     }
175  
176 
177  
178     /// 转账ETH 到Exin
179     function transferETH() isOwner external {
180         if (this.balance == 0) throw;
181         if (!ethFundDeposit.send(this.balance)) throw;
182     }
183 }