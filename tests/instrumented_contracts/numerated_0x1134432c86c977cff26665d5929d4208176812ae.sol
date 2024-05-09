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
34 
35     function transfer(address _to, uint256 _value) returns (bool success);
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37     function approve(address _spender, uint256 _value) returns (bool success);
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 
44 /*  ERC 20 token */
45 contract StandardToken is Token {
46   //默认token发行量不能超过(2^256 - 1)
47     function transfer(address _to, uint256 _value) returns (bool success) {
48         if (balances[msg.sender] >= _value && _value > 0) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else {
54             return false;
55         }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else {
66             return false;
67         }
68     }
69 
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81         return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86 }
87 
88 contract UnityToken is StandardToken, SafeMath {
89 
90     // metadata
91     string  public constant name = "Ping";
92     string  public constant symbol = "PIN";
93     uint256 public constant decimals = 3;
94     string  public version = "1.0";
95 
96     // contracts
97     address public ethFundDeposit;          // ETH存放地址
98     address public newContractAddr;         // token更新地址
99 
100     // crowdsale parameters
101     bool    public isFunding;                // 状态切换到true
102     uint256 public fundingStartBlock;
103     uint256 public fundingStopBlock;
104 
105     uint256 public currentSupply;           // 正在售卖中的tokens数量
106     uint256 public tokenRaised = 0;         // 总的售卖数量token
107     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
108     uint256 public tokenExchangeRate = 3;             // 3 Unity 兑换 1 finney
109 
110     // events
111     event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;
112     event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;
113     event IncreaseSupply(uint256 _value);
114     event DecreaseSupply(uint256 _value);
115     event Migrate(address indexed _to, uint256 _value);
116 
117     // 转换
118     function formatDecimals(uint256 _value) internal returns (uint256 ) {
119         return _value * 10 ** decimals;
120     }
121 
122     // constructor
123     function UnityToken(
124         address _ethFundDeposit,
125         uint256 _currentSupply)
126     {
127         ethFundDeposit = _ethFundDeposit;
128 
129         isFunding = false;                           //通过控制预CrowdS ale状态
130         fundingStartBlock = 0;
131         fundingStopBlock = 0;
132 
133         currentSupply = formatDecimals(_currentSupply);
134         totalSupply = formatDecimals(10000000);
135         balances[msg.sender] = totalSupply;
136         if(currentSupply > totalSupply) throw;
137     }
138 
139     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
140 
141     ///  设置token汇率
142     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
143         if (_tokenExchangeRate == 0) throw;
144         if (_tokenExchangeRate == tokenExchangeRate) throw;
145 
146         tokenExchangeRate = _tokenExchangeRate;
147     }
148 
149     /// @dev 超发token处理
150     function increaseSupply (uint256 _value) isOwner external {
151         uint256 value = formatDecimals(_value);
152         if (value + currentSupply > totalSupply) throw;
153         currentSupply = safeAdd(currentSupply, value);
154         IncreaseSupply(value);
155     }
156 
157     /// @dev 被盗token处理
158     function decreaseSupply (uint256 _value) isOwner external {
159         uint256 value = formatDecimals(_value);
160         if (value + tokenRaised > currentSupply) throw;
161 
162         currentSupply = safeSubtract(currentSupply, value);
163         DecreaseSupply(value);
164     }
165 
166     ///  启动区块检测 异常的处理
167     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
168         if (isFunding) throw;
169         if (_fundingStartBlock >= _fundingStopBlock) throw;
170         if (block.number >= _fundingStartBlock) throw;
171 
172         fundingStartBlock = _fundingStartBlock;
173         fundingStopBlock = _fundingStopBlock;
174         isFunding = true;
175     }
176 
177     ///  关闭区块异常处理
178     function stopFunding() isOwner external {
179         if (!isFunding) throw;
180         isFunding = false;
181     }
182 
183     /// 开发了一个新的合同来接收token（或者更新token）
184     function setMigrateContract(address _newContractAddr) isOwner external {
185         if (_newContractAddr == newContractAddr) throw;
186         newContractAddr = _newContractAddr;
187     }
188 
189     /// 设置新的所有者地址
190     function changeOwner(address _newFundDeposit) isOwner() external {
191         if (_newFundDeposit == address(0x0)) throw;
192         ethFundDeposit = _newFundDeposit;
193     }
194 
195     ///转移token到新的合约
196     function migrate() external {
197         if(isFunding) throw;
198         if(newContractAddr == address(0x0)) throw;
199 
200         uint256 tokens = balances[msg.sender];
201         if (tokens == 0) throw;
202 
203         balances[msg.sender] = 0;
204         tokenMigrated = safeAdd(tokenMigrated, tokens);
205 
206         IMigrationContract newContract = IMigrationContract(newContractAddr);
207         if (!newContract.migrate(msg.sender, tokens)) throw;
208 
209         Migrate(msg.sender, tokens);               // log it
210     }
211 
212     /// 转账ETH 到Unity团队
213     function transferETH() isOwner external {
214         if (this.balance == 0) throw;
215         if (!ethFundDeposit.send(this.balance)) throw;
216     }
217 
218     ///  将Unity token分配到预处理地址。
219     function allocateToken (address _addr, uint256 _fin) isOwner public {
220         if (_fin == 0) throw;
221         if (_addr == address(0x0)) throw;
222 
223         uint256 tokens = safeMult(formatDecimals(_fin), tokenExchangeRate);
224 
225         if (tokens + tokenRaised > currentSupply) throw;
226 
227         tokenRaised = safeAdd(tokenRaised, tokens);
228 
229         balances[_addr] += tokens;
230         //balances[ethFundDeposit] -= tokens;
231         AllocateToken(_addr, tokens);  // 记录token日志
232     }
233 
234     /// 购买token
235     function () payable {
236         if (!isFunding) throw;
237         if (msg.value == 0) throw;
238 
239         if (block.number < fundingStartBlock) throw;
240         if (block.number > fundingStopBlock) throw;
241 
242         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
243         if (tokens + tokenRaised > currentSupply) throw;
244 
245         tokenRaised = safeAdd(tokenRaised, tokens);
246         balances[msg.sender] += tokens;
247 
248         IssueToken(msg.sender, tokens);  //记录日志
249     }
250 }