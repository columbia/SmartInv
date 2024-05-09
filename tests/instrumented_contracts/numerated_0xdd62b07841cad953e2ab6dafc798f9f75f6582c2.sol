1 pragma solidity ^0.4.12;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) returns (bool success);
5 }
6  
7 
8 contract SafeMath {
9     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
10         uint256 z = x + y;
11         assert((z >= x) && (z >= y));
12         return z;
13     }
14  
15     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
16         assert(x >= y);
17         uint256 z = x - y;
18         return z;
19     }
20  
21     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
22         uint256 z = x * y;
23         assert((x == 0)||(z/x == y));
24         return z;
25     }
26  
27 }
28  
29 contract Token {
30     uint256 public totalSupply;
31     function balanceOf(address _owner) constant returns (uint256 balance);
32     function transfer(address _to, uint256 _value) returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34     function approve(address _spender, uint256 _value) returns (bool success);
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39  
40  
41 /*  ERC 20 token */
42 contract StandardToken is Token {
43  
44     function transfer(address _to, uint256 _value) returns (bool success) {
45         if (balances[msg.sender] >= _value && _value > 0) {
46             balances[msg.sender] -= _value;
47             balances[_to] += _value;
48             Transfer(msg.sender, _to, _value);
49             return true;
50         } else {
51             return false;
52         }
53     }
54  
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57             balances[_to] += _value;
58             balances[_from] -= _value;
59             allowed[_from][msg.sender] -= _value;
60             Transfer(_from, _to, _value);
61             return true;
62         } else {
63             return false;
64         }
65     }
66  
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70  
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76  
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
78         return allowed[_owner][_spender];
79     }
80  
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83 }
84  
85 contract QECToken is StandardToken, SafeMath {
86  
87     // metadata
88     string  public constant name = "QEC";
89     string  public constant symbol = "QEC";
90     uint256 public constant decimals = 18;
91     string  public version = "1.0";
92  
93     // contracts
94     address public ethFundDeposit;          // ETH存放地址
95     address public newContractAddr;         // token更新地址
96  
97     // crowdsale parameters
98     bool    public isFunding;                // 状态切换到true
99     uint256 public fundingStartBlock;
100     uint256 public fundingStopBlock;
101  
102     uint256 public currentSupply;            // 正在售卖中的tokens数量
103     uint256 public tokenRaised = 0;          // 总的售卖数量token
104     uint256 public tokenMigrated = 0;        // 总的已经交易的 token
105     uint256 public tokenExchangeRate = 1000; // 1ETH = 1000QEC
106  
107     // events
108     event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;
109     event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;
110     event IncreaseSupply(uint256 _value);
111     event DecreaseSupply(uint256 _value);
112     event Migrate(address indexed _to, uint256 _value);
113  
114     // 转换
115     function formatDecimals(uint256 _value) internal returns (uint256 ) {
116         return _value * 10 ** decimals;
117     }
118  
119     // 构造函数
120     function QECToken(address _ethFundDeposit, uint256 _currentSupply) {
121         ethFundDeposit = _ethFundDeposit;
122  
123         isFunding = false;                           //通过控制预CrowdS ale状态
124         fundingStartBlock = 0;
125         fundingStopBlock = 0;
126  
127         currentSupply = formatDecimals(_currentSupply);
128         totalSupply = formatDecimals(200000000);    //代币总量
129         balances[msg.sender] = totalSupply;
130         if(currentSupply > totalSupply) throw;
131     }
132  
133     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
134  
135     ///  设置token汇率
136     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
137         if (_tokenExchangeRate == 0) throw;
138         if (_tokenExchangeRate == tokenExchangeRate) throw;
139  
140         tokenExchangeRate = _tokenExchangeRate;
141     }
142  
143     /// @dev 超发token处理
144     function increaseSupply (uint256 _value) isOwner external {
145         uint256 value = formatDecimals(_value);
146         if (value + currentSupply > totalSupply) throw;
147         currentSupply = safeAdd(currentSupply, value);
148         IncreaseSupply(value);
149     }
150  
151     /// @dev 被盗token处理
152     function decreaseSupply (uint256 _value) isOwner external {
153         uint256 value = formatDecimals(_value);
154         if (value + tokenRaised > currentSupply) throw;
155  
156         currentSupply = safeSubtract(currentSupply, value);
157         DecreaseSupply(value);
158     }
159  
160     ///  启动区块检测 异常的处理
161     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
162         if (isFunding) throw;
163         if (_fundingStartBlock >= _fundingStopBlock) throw;
164         if (block.number >= _fundingStartBlock) throw;
165  
166         fundingStartBlock = _fundingStartBlock;
167         fundingStopBlock = _fundingStopBlock;
168         isFunding = true;
169     }
170  
171     ///  关闭区块异常处理
172     function stopFunding() isOwner external {
173         if (!isFunding) throw;
174         isFunding = false;
175     }
176  
177     /// 开发了一个新的合同来接收token（或者更新token）
178     function setMigrateContract(address _newContractAddr) isOwner external {
179         if (_newContractAddr == newContractAddr) throw;
180         newContractAddr = _newContractAddr;
181     }
182  
183     /// 设置新的所有者地址
184     function changeOwner(address _newFundDeposit) isOwner() external {
185         if (_newFundDeposit == address(0x0)) throw;
186         ethFundDeposit = _newFundDeposit;
187     }
188  
189     ///转移token到新的合约
190     function migrate() external {
191         if(isFunding) throw;
192         if(newContractAddr == address(0x0)) throw;
193  
194         uint256 tokens = balances[msg.sender];
195         if (tokens == 0) throw;
196  
197         balances[msg.sender] = 0;
198         tokenMigrated = safeAdd(tokenMigrated, tokens);
199  
200         IMigrationContract newContract = IMigrationContract(newContractAddr);
201         if (!newContract.migrate(msg.sender, tokens)) throw;
202  
203         Migrate(msg.sender, tokens);               // log it
204     }
205  
206     /// 转账ETH 到QEC团队
207     function transferETH() isOwner external {
208         if (this.balance == 0) throw;
209         if (!ethFundDeposit.send(this.balance)) throw;
210     }
211  
212     ///  将QECToken分配到预处理地址。
213     function allocateToken (address _addr, uint256 _eth) isOwner external {
214         if (_eth == 0) throw;
215         if (_addr == address(0x0)) throw;
216  
217         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
218         if (tokens + tokenRaised > currentSupply) throw;
219  
220         tokenRaised = safeAdd(tokenRaised, tokens);
221         balances[_addr] += tokens;
222  
223         AllocateToken(_addr, tokens);  // 记录token日志
224     }
225  
226     /// 购买token
227     function () payable {
228         if (!isFunding) throw;
229         if (msg.value == 0) throw;
230  
231         if (block.number < fundingStartBlock) throw;
232         if (block.number > fundingStopBlock) throw;
233  
234         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
235         if (tokens + tokenRaised > currentSupply) throw;
236  
237         tokenRaised = safeAdd(tokenRaised, tokens);
238         balances[msg.sender] += tokens;
239  
240         IssueToken(msg.sender, tokens);  //记录日志
241     }
242 }