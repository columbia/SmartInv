1 pragma solidity ^0.4.12;
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
86 contract DaRuiToken is StandardToken, SafeMath {
87 
88     // metadata
89     string  public constant name = "DaRuiCoin";
90     string  public constant symbol = "DRC";
91     uint256 public constant decimals = 18;
92     string  public version = "1.0";
93 
94     // contracts
95     address public ethFundDeposit;          // ETH存放地址
96     address public newContractAddr;         // token更新地址
97 
98     // crowdsale parameters
99     bool    public isFunding;                // 状态切换到true
100     uint256 public fundingStartBlock;
101     uint256 public fundingStopBlock;
102 
103     uint256 public currentSupply;           // 正在售卖中的tokens数量
104     uint256 public tokenRaised = 0;         // 总的售卖数量token
105     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
106     uint256 public tokenExchangeRate = 1000;             // 1000 DRC 兑换 1 ETH
107 
108     // events
109     event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;
110     event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;
111     event IncreaseSupply(uint256 _value);
112     event DecreaseSupply(uint256 _value);
113     event Migrate(address indexed _to, uint256 _value);
114 
115     // 转换
116     function formatDecimals(uint256 _value) internal returns (uint256 ) {
117         return _value * 10 ** decimals;
118     }
119 
120     // constructor
121     function DaRuiToken(
122         address _ethFundDeposit,
123         uint256 _currentSupply)
124     {
125         ethFundDeposit = _ethFundDeposit;
126 
127         isFunding = false;                           //通过控制预CrowdS ale状态
128         fundingStartBlock = 0;
129         fundingStopBlock = 0;
130 
131         currentSupply = formatDecimals(_currentSupply);
132         totalSupply = formatDecimals(10000000);
133         balances[msg.sender] = totalSupply;
134         if(currentSupply > totalSupply) throw;
135     }
136 
137     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
138 
139     ///  设置token汇率
140     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
141         if (_tokenExchangeRate == 0) throw;
142         if (_tokenExchangeRate == tokenExchangeRate) throw;
143 
144         tokenExchangeRate = _tokenExchangeRate;
145     }
146 
147     /// @dev 超发token处理
148     function increaseSupply (uint256 _value) isOwner external {
149         uint256 value = formatDecimals(_value);
150         if (value + currentSupply > totalSupply) throw;
151         currentSupply = safeAdd(currentSupply, value);
152         IncreaseSupply(value);
153     }
154 
155     /// @dev 被盗token处理
156     function decreaseSupply (uint256 _value) isOwner external {
157         uint256 value = formatDecimals(_value);
158         if (value + tokenRaised > currentSupply) throw;
159 
160         currentSupply = safeSubtract(currentSupply, value);
161         DecreaseSupply(value);
162     }
163 
164     ///  启动区块检测 异常的处理
165     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
166         if (isFunding) throw;
167         if (_fundingStartBlock >= _fundingStopBlock) throw;
168         if (block.number >= _fundingStartBlock) throw;
169 
170         fundingStartBlock = _fundingStartBlock;
171         fundingStopBlock = _fundingStopBlock;
172         isFunding = true;
173     }
174 
175     ///  关闭区块异常处理
176     function stopFunding() isOwner external {
177         if (!isFunding) throw;
178         isFunding = false;
179     }
180 
181     /// 开发了一个新的合同来接收token（或者更新token）
182     function setMigrateContract(address _newContractAddr) isOwner external {
183         if (_newContractAddr == newContractAddr) throw;
184         newContractAddr = _newContractAddr;
185     }
186 
187     /// 设置新的所有者地址
188     function changeOwner(address _newFundDeposit) isOwner() external {
189         if (_newFundDeposit == address(0x0)) throw;
190         ethFundDeposit = _newFundDeposit;
191     }
192 
193     ///转移token到新的合约
194     function migrate() external {
195         if(isFunding) throw;
196         if(newContractAddr == address(0x0)) throw;
197 
198         uint256 tokens = balances[msg.sender];
199         if (tokens == 0) throw;
200 
201         balances[msg.sender] = 0;
202         tokenMigrated = safeAdd(tokenMigrated, tokens);
203 
204         IMigrationContract newContract = IMigrationContract(newContractAddr);
205         if (!newContract.migrate(msg.sender, tokens)) throw;
206 
207         Migrate(msg.sender, tokens);               // log it
208     }
209 
210     /// 转账ETH 到darui团队
211     function transferETH() isOwner external {
212         if (this.balance == 0) throw;
213         if (!ethFundDeposit.send(this.balance)) throw;
214     }
215 
216     ///  将darui token分配到预处理地址。
217     function allocateToken (address _addr, uint256 _eth) isOwner external {
218         if (_eth == 0) throw;
219         if (_addr == address(0x0)) throw;
220 
221         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
222         if (tokens + tokenRaised > currentSupply) throw;
223 
224         tokenRaised = safeAdd(tokenRaised, tokens);
225         balances[_addr] += tokens;
226 
227         AllocateToken(_addr, tokens);  // 记录token日志
228     }
229 
230     /// 购买token
231     function () payable {
232         if (!isFunding) throw;
233         if (msg.value == 0) throw;
234 
235         if (block.number < fundingStartBlock) throw;
236         if (block.number > fundingStopBlock) throw;
237 
238         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
239         if (tokens + tokenRaised > currentSupply) throw;
240 
241         tokenRaised = safeAdd(tokenRaised, tokens);
242         balances[msg.sender] += tokens;
243 
244         IssueToken(msg.sender, tokens);  //记录日志
245     }
246 }