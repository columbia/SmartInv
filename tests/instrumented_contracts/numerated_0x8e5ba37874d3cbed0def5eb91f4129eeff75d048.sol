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
87 contract HKHCToken is StandardToken, SafeMath {
88  
89     // metadata
90     string  public constant name = "Happily keep health";
91     string  public constant symbol = "HKHC";
92     uint256 public constant decimals = 18;
93     string  public version = "1.0";
94  
95     // contracts
96     address public ethFundDeposit;          // ETH存放地址
97     address public newContractAddr;         // token更新地址
98  
99     // crowdsale parameters
100     bool    public isFunding;                // 状态切换到true
101     uint256 public fundingStartBlock;
102     uint256 public fundingStopBlock;
103  
104     uint256 public currentSupply;           // 正在售卖中的tokens数量
105     uint256 public tokenRaised = 0;         // 总的售卖数量token
106     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
107     uint256 public tokenExchangeRate = 625;             // 625 BILIBILI 兑换 1 ETH
108  
109     // events
110     event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;
111     event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;
112     event IncreaseSupply(uint256 _value);
113     event DecreaseSupply(uint256 _value);
114     event Migrate(address indexed _to, uint256 _value);
115  
116     // 转换
117     function formatDecimals(uint256 _value) internal returns (uint256 ) {
118         return _value * 10 ** decimals;
119     }
120  
121     // constructor
122     function HKHCToken(
123         address _ethFundDeposit,
124         uint256 _currentSupply)
125     {
126         ethFundDeposit = _ethFundDeposit;
127  
128         isFunding = false;                           //通过控制预CrowdS ale状态
129         fundingStartBlock = 0;
130         fundingStopBlock = 0;
131  
132         currentSupply = formatDecimals(_currentSupply);
133         totalSupply = formatDecimals(1000000000);
134         balances[msg.sender] = totalSupply;
135         if(currentSupply > totalSupply) throw;
136     }
137  
138     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
139  
140     ///  设置token汇率
141     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
142         if (_tokenExchangeRate == 0) throw;
143         if (_tokenExchangeRate == tokenExchangeRate) throw;
144  
145         tokenExchangeRate = _tokenExchangeRate;
146     }
147  
148     /// @dev 超发token处理
149     function increaseSupply (uint256 _value) isOwner external {
150         uint256 value = formatDecimals(_value);
151         if (value + currentSupply > totalSupply) throw;
152         currentSupply = safeAdd(currentSupply, value);
153         IncreaseSupply(value);
154     }
155  
156     /// @dev 被盗token处理
157     function decreaseSupply (uint256 _value) isOwner external {
158         uint256 value = formatDecimals(_value);
159         if (value + tokenRaised > currentSupply) throw;
160  
161         currentSupply = safeSubtract(currentSupply, value);
162         DecreaseSupply(value);
163     }
164  
165     ///  启动区块检测 异常的处理
166     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
167         if (isFunding) throw;
168         if (_fundingStartBlock >= _fundingStopBlock) throw;
169         if (block.number >= _fundingStartBlock) throw;
170  
171         fundingStartBlock = _fundingStartBlock;
172         fundingStopBlock = _fundingStopBlock;
173         isFunding = true;
174     }
175  
176     ///  关闭区块异常处理
177     function stopFunding() isOwner external {
178         if (!isFunding) throw;
179         isFunding = false;
180     }
181  
182     /// 开发了一个新的合同来接收token（或者更新token）
183     function setMigrateContract(address _newContractAddr) isOwner external {
184         if (_newContractAddr == newContractAddr) throw;
185         newContractAddr = _newContractAddr;
186     }
187  
188     /// 设置新的所有者地址
189     function changeOwner(address _newFundDeposit) isOwner() external {
190         if (_newFundDeposit == address(0x0)) throw;
191         ethFundDeposit = _newFundDeposit;
192     }
193  
194     ///转移token到新的合约
195     function migrate() external {
196         if(isFunding) throw;
197         if(newContractAddr == address(0x0)) throw;
198  
199         uint256 tokens = balances[msg.sender];
200         if (tokens == 0) throw;
201  
202         balances[msg.sender] = 0;
203         tokenMigrated = safeAdd(tokenMigrated, tokens);
204  
205         IMigrationContract newContract = IMigrationContract(newContractAddr);
206         if (!newContract.migrate(msg.sender, tokens)) throw;
207  
208         Migrate(msg.sender, tokens);               // log it
209     }
210  
211     /// 转账ETH 到  HKHCToken 团队
212     function transferETH() isOwner external {
213         if (this.balance == 0) throw;
214         if (!ethFundDeposit.send(this.balance)) throw;
215     }
216  
217     ///  将BILIBILI token分配到预处理地址。
218     function allocateToken (address _addr, uint256 _eth) isOwner external {
219         if (_eth == 0) throw;
220         if (_addr == address(0x0)) throw;
221  
222         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
223         if (tokens + tokenRaised > currentSupply) throw;
224  
225         tokenRaised = safeAdd(tokenRaised, tokens);
226         balances[_addr] += tokens;
227  
228         AllocateToken(_addr, tokens);  // 记录token日志
229     }
230  
231     /// 购买token
232     function () payable {
233         if (!isFunding) throw;
234         if (msg.value == 0) throw;
235  
236         if (block.number < fundingStartBlock) throw;
237         if (block.number > fundingStopBlock) throw;
238  
239         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
240         if (tokens + tokenRaised > currentSupply) throw;
241  
242         tokenRaised = safeAdd(tokenRaised, tokens);
243         balances[msg.sender] += tokens;
244  
245         IssueToken(msg.sender, tokens);  //记录日志
246     }
247 }