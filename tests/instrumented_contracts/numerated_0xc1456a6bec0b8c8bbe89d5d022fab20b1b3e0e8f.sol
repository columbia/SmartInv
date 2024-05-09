1 pragma solidity ^0.4.12;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) returns (bool success);
5 }
6  
7 /* 灵感来自于NAS  coin*/
8 contract SafeMath {
9  
10  
11     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
12         uint256 z = x + y;
13         assert((z >= x) && (z >= y));
14         return z;
15     }
16  
17     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
18         assert(x >= y);
19         uint256 z = x - y;
20         return z;
21     }
22  
23     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
24         uint256 z = x * y;
25         assert((x == 0)||(z/x == y));
26         return z;
27     }
28  
29 }
30  
31 contract Token {
32     uint256 public totalSupply;
33     function balanceOf(address _owner) constant returns (uint256 balance);
34     function transfer(address _to, uint256 _value) returns (bool success);
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
36     function approve(address _spender, uint256 _value) returns (bool success);
37     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41  
42  
43 /*  ERC 20 token */
44 contract StandardToken is Token {
45  
46     function transfer(address _to, uint256 _value) returns (bool success) {
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else {
53             return false;
54         }
55     }
56  
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59             balances[_to] += _value;
60             balances[_from] -= _value;
61             allowed[_from][msg.sender] -= _value;
62             Transfer(_from, _to, _value);
63             return true;
64         } else {
65             return false;
66         }
67     }
68  
69     function balanceOf(address _owner) constant returns (uint256 balance) {
70         return balances[_owner];
71     }
72  
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78  
79     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
80         return allowed[_owner][_spender];
81     }
82  
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85 }
86  
87 contract GWCToken is StandardToken, SafeMath {
88  
89     // metadata
90     string  public constant name = "GWC";
91     string  public constant symbol = "GWC";
92     uint256 public constant decimals = 18;
93     string  public version = "1.0";
94  
95     // contracts
96     address public ethFundDeposit;          // ETH存放地址
97     address public newContractAddr;         // token更新地址
98  
99     uint256 public currentSupply;           // 正在售卖中的tokens数量
100     uint256 public tokenRaised = 0;         // 总的售卖数量token
101     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
102     uint256 public tokenExchangeRate = 900;             // 625 BILIBILI 兑换 1 ETH
103  
104     // events
105     event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;
106     event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;
107     event IncreaseSupply(uint256 _value);
108     event DecreaseSupply(uint256 _value);
109     event Migrate(address indexed _to, uint256 _value);
110  
111     // 转换
112     function formatDecimals(uint256 _value) internal returns (uint256 ) {
113         return _value * 10 ** decimals;
114     }
115  
116     // constructor
117     function GWCToken(
118         address _ethFundDeposit,
119         uint256 _currentSupply)
120     {
121         ethFundDeposit = _ethFundDeposit;
122         currentSupply = formatDecimals(_currentSupply);
123         totalSupply = formatDecimals(50000000);
124         balances[ethFundDeposit] = totalSupply;
125         if(currentSupply > totalSupply) throw;
126     }
127  
128     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
129  
130     ///  设置token汇率
131     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
132         if (_tokenExchangeRate == 0) throw;
133         if (_tokenExchangeRate == tokenExchangeRate) throw;
134  
135         tokenExchangeRate = _tokenExchangeRate;
136     }
137  
138     /// @dev 超发token处理
139     function increaseSupply (uint256 _value) isOwner external {
140         uint256 value = formatDecimals(_value);
141         if (value + currentSupply > totalSupply) throw;
142         currentSupply = safeAdd(currentSupply, value);
143         IncreaseSupply(value);
144     }
145  
146     /// @dev 被盗token处理
147     function decreaseSupply (uint256 _value) isOwner external {
148         uint256 value = formatDecimals(_value);
149         if (value + tokenRaised > currentSupply) throw;
150  
151         currentSupply = safeSubtract(currentSupply, value);
152         DecreaseSupply(value);
153     }
154  
155   
156     /// 开发了一个新的合同来接收token（或者更新token）
157     function setMigrateContract(address _newContractAddr) isOwner external {
158         if (_newContractAddr == newContractAddr) throw;
159         newContractAddr = _newContractAddr;
160     }
161  
162     /// 设置新的所有者地址
163     function changeOwner(address _newFundDeposit) isOwner() external {
164         if (_newFundDeposit == address(0x0)) throw;
165         ethFundDeposit = _newFundDeposit;
166     }
167  
168     ///转移token到新的合约
169     function migrate() external {
170         if(newContractAddr == address(0x0)) throw;
171  
172         uint256 tokens = balances[msg.sender];
173         if (tokens == 0) throw;
174  
175         balances[msg.sender] = 0;
176         tokenMigrated = safeAdd(tokenMigrated, tokens);
177  
178         IMigrationContract newContract = IMigrationContract(newContractAddr);
179         if (!newContract.migrate(msg.sender, tokens)) throw;
180  
181         Migrate(msg.sender, tokens);               // log it
182     }
183  
184     /// 转账ETH 到BILIBILI团队
185     function transferETH() isOwner external {
186         if (this.balance == 0) throw;
187         if (!ethFundDeposit.send(this.balance)) throw;
188     }
189  
190     ///  将BILIBILI token分配到预处理地址。
191     function allocateToken (address _addr, uint256 _eth) isOwner external {
192         if (_eth == 0) throw;
193         if (_addr == address(0x0)) throw;
194  
195         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
196         if (tokens + tokenRaised > currentSupply) throw;
197  
198         tokenRaised = safeAdd(tokenRaised, tokens);
199         balances[_addr] += tokens;
200  
201         AllocateToken(_addr, tokens);  // 记录token日志
202     }
203  
204     /// 购买token
205     function () payable {
206 
207         if (msg.value == 0) throw;
208 
209         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
210         if (tokens + tokenRaised > currentSupply) throw;
211 
212         tokenRaised = safeAdd(tokenRaised, tokens);
213         balances[msg.sender] += tokens;
214         balances[ethFundDeposit] -= tokens;
215 
216         IssueToken(msg.sender, tokens);  //记录日志
217     }
218 }