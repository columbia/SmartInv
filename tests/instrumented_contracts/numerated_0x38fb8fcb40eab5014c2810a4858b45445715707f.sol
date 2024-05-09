1 pragma solidity ^0.4.12;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) returns (bool success);
5 }
6  
7 contract SafeMath {
8     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
9         uint256 z = x + y;
10         assert((z >= x) && (z >= y));
11         return z;
12     }
13     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
14         assert(x >= y);
15         uint256 z = x - y;
16         return z;
17     }
18     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
19         uint256 z = x * y;
20         assert((x == 0)||(z/x == y));
21         return z;
22     }
23 }
24  
25 contract Token {
26     uint256 public totalSupply;
27     function balanceOf(address _owner) constant returns (uint256 balance);
28     function transfer(address _to, uint256 _value) returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30     function approve(address _spender, uint256 _value) returns (bool success);
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35  
36  
37 /*  ERC 20 token */
38 contract StandardToken is Token {
39     function transfer(address _to, uint256 _value) returns (bool success) {
40         if (balances[msg.sender] >= _value && _value > 0) {
41             balances[msg.sender] -= _value;
42             balances[_to] += _value;
43             Transfer(msg.sender, _to, _value);
44             return true;
45         } else {
46             return false;
47         }
48     }
49  
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
51         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52             balances[_to] += _value;
53             balances[_from] -= _value;
54             allowed[_from][msg.sender] -= _value;
55             Transfer(_from, _to, _value);
56             return true;
57         } else {
58             return false;
59         }
60     }
61  
62     function balanceOf(address _owner) constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65  
66     function approve(address _spender, uint256 _value) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71  
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
73         return allowed[_owner][_spender];
74     }
75  
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78 }
79  
80 contract IPPToken is StandardToken, SafeMath {
81     // metadata
82     string  public constant name = "International Partner Platform";
83     string  public constant symbol = "IPP";
84     uint256 public constant decimals = 18;
85     string  public version = "1.0";
86  
87     // contracts
88     address public ethFundDeposit;          // ETH存放地址
89     address public newContractAddr;         // token更新地址
90  
91     // crowdsale parameters
92     bool    public isFunding;                // 状态切换到true
93     uint256 public fundingStartBlock;
94     uint256 public fundingStopBlock;
95  
96     uint256 public currentSupply;           // 正在售卖中的tokens数量
97     uint256 public tokenRaised = 0;         // 总的售卖数量token
98     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
99     uint256 public tokenExchangeRate = 625;             // 625  兑换 1 ETH
100  
101     // events
102     event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;
103     event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;
104     event IncreaseSupply(uint256 _value);
105     event DecreaseSupply(uint256 _value);
106     event Migrate(address indexed _to, uint256 _value);
107  
108     // 转换
109     function formatDecimals(uint256 _value) internal returns (uint256 ) {
110         return _value * 10 ** decimals;
111     }
112  
113     // constructor
114     function IPPToken(
115         address _ethFundDeposit,
116         uint256 _currentSupply)
117     {
118         ethFundDeposit = _ethFundDeposit;
119  
120         isFunding = false;                           //通过控制预CrowdS ale状态
121         fundingStartBlock = 0;
122         fundingStopBlock = 0;
123  
124         currentSupply = formatDecimals(_currentSupply);
125         totalSupply = formatDecimals(1000000000);
126         balances[msg.sender] = totalSupply;
127         if(currentSupply > totalSupply) throw;
128     }
129  
130     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
131  
132     ///  设置token汇率
133     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
134         if (_tokenExchangeRate == 0) throw;
135         if (_tokenExchangeRate == tokenExchangeRate) throw;
136  
137         tokenExchangeRate = _tokenExchangeRate;
138     }
139  
140     /// @dev 超发token处理
141     function increaseSupply (uint256 _value) isOwner external {
142         uint256 value = formatDecimals(_value);
143         if (value + currentSupply > totalSupply) throw;
144         currentSupply = safeAdd(currentSupply, value);
145         IncreaseSupply(value);
146     }
147  
148     /// @dev 被盗token处理
149     function decreaseSupply (uint256 _value) isOwner external {
150         uint256 value = formatDecimals(_value);
151         if (value + tokenRaised > currentSupply) throw;
152  
153         currentSupply = safeSubtract(currentSupply, value);
154         DecreaseSupply(value);
155     }
156  
157     ///  启动区块检测 异常的处理
158     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
159         if (isFunding) throw;
160         if (_fundingStartBlock >= _fundingStopBlock) throw;
161         if (block.number >= _fundingStartBlock) throw;
162  
163         fundingStartBlock = _fundingStartBlock;
164         fundingStopBlock = _fundingStopBlock;
165         isFunding = true;
166     }
167  
168     ///  关闭区块异常处理
169     function stopFunding() isOwner external {
170         if (!isFunding) throw;
171         isFunding = false;
172     }
173  
174     /// 开发了一个新的合同来接收token（或者更新token）
175     function setMigrateContract(address _newContractAddr) isOwner external {
176         if (_newContractAddr == newContractAddr) throw;
177         newContractAddr = _newContractAddr;
178     }
179  
180     /// 设置新的所有者地址
181     function changeOwner(address _newFundDeposit) isOwner() external {
182         if (_newFundDeposit == address(0x0)) throw;
183         ethFundDeposit = _newFundDeposit;
184     }
185  
186     ///转移token到新的合约
187     function migrate() external {
188         if(isFunding) throw;
189         if(newContractAddr == address(0x0)) throw;
190  
191         uint256 tokens = balances[msg.sender];
192         if (tokens == 0) throw;
193  
194         balances[msg.sender] = 0;
195         tokenMigrated = safeAdd(tokenMigrated, tokens);
196  
197         IMigrationContract newContract = IMigrationContract(newContractAddr);
198         if (!newContract.migrate(msg.sender, tokens)) throw;
199  
200         Migrate(msg.sender, tokens);               // log it
201     }
202  
203     /// 转账ETH
204     function transferETH() isOwner external {
205         if (this.balance == 0) throw;
206         if (!ethFundDeposit.send(this.balance)) throw;
207     }
208  
209     ///token分配到预处理地址。
210     function allocateToken (address _addr, uint256 _eth) isOwner external {
211         if (_eth == 0) throw;
212         if (_addr == address(0x0)) throw;
213  
214         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
215         if (tokens + tokenRaised > currentSupply) throw;
216  
217         tokenRaised = safeAdd(tokenRaised, tokens);
218         balances[_addr] += tokens;
219  
220         AllocateToken(_addr, tokens);  // 记录token日志
221     }
222  
223     /// 购买token
224     function () payable {
225         if (!isFunding) throw;
226         if (msg.value == 0) throw;
227  
228         if (block.number < fundingStartBlock) throw;
229         if (block.number > fundingStopBlock) throw;
230  
231         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
232         if (tokens + tokenRaised > currentSupply) throw;
233  
234         tokenRaised = safeAdd(tokenRaised, tokens);
235         balances[msg.sender] += tokens;
236  
237         IssueToken(msg.sender, tokens);  //记录日志
238     }
239 }