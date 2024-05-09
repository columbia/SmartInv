1 pragma solidity ^0.4.16;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) returns (bool success);
5 }
6  
7 /* 灵感来自于NAS  coin*/
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
46         require (_to != 0x0);
47         require (balances[msg.sender] >= _value && _value > 0);
48         require (balances[_to] + _value >= balances[_to]);
49         
50         uint256 previousBalances = balances[msg.sender] + balances[_to];
51 
52         balances[msg.sender] -= _value;
53         balances[_to] += _value;
54         
55         assert(balances[msg.sender] + balances[_to] == previousBalances);
56 
57         Transfer(msg.sender, _to, _value);
58         return true;
59     }
60  
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62         require (_to != 0x0);
63         require (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
64 
65         balances[_to] += _value;
66         balances[_from] -= _value;
67         allowed[_from][msg.sender] -= _value;
68         Transfer(_from, _to, _value);
69         return true;
70     }
71  
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75  
76     function approve(address _spender, uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81  
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83         return allowed[_owner][_spender];
84     }
85  
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88 }
89  
90 contract BTJToken is StandardToken, SafeMath {
91  
92     // metadata
93     string  public constant name = "Bit Jade";
94     string  public constant symbol = "BTJ";
95     uint256 public constant decimals = 18;
96     string  public version = "1.0";
97  
98     // contracts
99     address public ethFundDeposit;          // ETH存放地址
100     address public newContractAddr;         // token更新地址
101  
102     // crowdsale parameters
103     bool    public isFunding;                // 状态切换到true
104     uint256 public fundingStartBlock;
105     uint256 public fundingStopBlock;
106  
107     uint256 public currentSupply;           // 正在售卖中的tokens数量
108     uint256 public tokenRaised = 0;         // 总的售卖数量token
109     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
110     uint256 public tokenExchangeRate = 100;             // 100 BTJ 兑换 1 ETH
111  
112     // events
113     event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;
114     event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;
115     event IncreaseSupply(uint256 _value);
116     event DecreaseSupply(uint256 _value);
117     event Migrate(address indexed _to, uint256 _value);
118  
119     // 转换
120     function formatDecimals(uint256 _value) internal returns (uint256 ) {
121         return _value * 10 ** decimals;
122     }
123  
124     // constructor
125     function BTJToken(
126         address _ethFundDeposit,
127         uint256 _currentSupply)
128     {
129         ethFundDeposit = _ethFundDeposit;
130  
131         isFunding = false;                           //通过控制预CrowdSale状态
132         fundingStartBlock = 0;
133         fundingStopBlock = 0;
134  
135         currentSupply = formatDecimals(_currentSupply);
136         totalSupply = formatDecimals(3000000000);
137         balances[msg.sender] = totalSupply;
138 
139         assert(currentSupply < totalSupply);
140     }
141  
142     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
143  
144     ///  设置token汇率
145     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
146         require(_tokenExchangeRate != 0 && _tokenExchangeRate != tokenExchangeRate);
147     
148         tokenExchangeRate = _tokenExchangeRate;
149     }
150  
151     /// 超发token处理
152     function increaseSupply (uint256 _value) isOwner external {
153         uint256 value = formatDecimals(_value);
154         assert(value + currentSupply <= totalSupply);
155 
156         currentSupply = safeAdd(currentSupply, value);
157         IncreaseSupply(value);
158     }
159  
160     /// @dev 被盗token处理
161     function decreaseSupply (uint256 _value) isOwner external {
162         uint256 value = formatDecimals(_value);
163         require(value + tokenRaised <= currentSupply);
164  
165         currentSupply = safeSubtract(currentSupply, value);
166         DecreaseSupply(value);
167     }
168  
169     ///  启动区块检测 异常的处理
170     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
171         require(!isFunding);
172         require(_fundingStartBlock < _fundingStopBlock);
173         require(block.number < _fundingStartBlock);
174  
175         fundingStartBlock = _fundingStartBlock;
176         fundingStopBlock = _fundingStopBlock;
177         isFunding = true;
178     }
179  
180     ///  关闭区块异常处理
181     function stopFunding() isOwner external {
182         require(isFunding);
183         isFunding = false;
184     }
185  
186     /// 开发了一个新的合同来接收token（或者更新token）
187     function setMigrateContract(address _newContractAddr) isOwner external {
188         require(_newContractAddr != newContractAddr);
189         newContractAddr = _newContractAddr;
190     }
191  
192     /// 设置新的所有者地址
193     function changeOwner(address _newFundDeposit) isOwner() external {
194         require (_newFundDeposit != address(0x0));
195         ethFundDeposit = _newFundDeposit;
196     }
197  
198     ///转移token到新的合约
199     function migrate() external {
200         require(!isFunding);
201         require(newContractAddr != address(0x0));
202         uint256 tokens = balances[msg.sender];
203         require (tokens != 0);
204  
205         balances[msg.sender] = 0;
206         tokenMigrated = safeAdd(tokenMigrated, tokens);
207  
208         IMigrationContract newContract = IMigrationContract(newContractAddr);
209         
210         assert (newContract.migrate(msg.sender, tokens));
211  
212         Migrate(msg.sender, tokens);               // log it
213     }
214  
215     /// 转账ETH 到BTJ团队
216     function transferETH() isOwner external {
217         require (this.balance != 0);
218         assert (ethFundDeposit.send(this.balance));
219     }
220  
221     ///  将BTJ token分配到预处理地址。
222     function allocateToken (address _addr, uint256 _eth) isOwner external {
223         require (_eth != 0);
224         require (_addr != address(0x0));
225  
226         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
227         require (tokens + tokenRaised <= currentSupply);
228  
229         tokenRaised = safeAdd(tokenRaised, tokens);
230         balances[_addr] += tokens;
231  
232         AllocateToken(_addr, tokens);
233     }
234  
235     /// 购买token
236     function () payable {
237         require (isFunding);
238         require (msg.value != 0);
239  
240         require (block.number >= fundingStartBlock);
241         require (block.number <= fundingStopBlock);
242  
243         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
244         require (tokens + tokenRaised <= currentSupply);
245  
246         tokenRaised = safeAdd(tokenRaised, tokens);
247         balances[msg.sender] += tokens;
248  
249         IssueToken(msg.sender, tokens);  //记录日志
250     }
251 }