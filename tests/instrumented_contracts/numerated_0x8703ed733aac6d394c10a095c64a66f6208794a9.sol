1 pragma solidity ^0.4.12;
2  
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) returns (bool success);
5 }
6  
7 contract SafeMath {
8  
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
40 /*  ERC 20 token */
41 contract StandardToken is Token {
42  
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         if (balances[msg.sender] >= _value && _value > 0) {
45             balances[msg.sender] -= _value;
46             balances[_to] += _value;
47             Transfer(msg.sender, _to, _value);
48             return true;
49         } else {
50             return false;
51         }
52     }
53  
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
55         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
56             balances[_to] += _value;
57             balances[_from] -= _value;
58             allowed[_from][msg.sender] -= _value;
59             Transfer(_from, _to, _value);
60             return true;
61         } else {
62             return false;
63         }
64     }
65  
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69  
70     function approve(address _spender, uint256 _value) returns (bool success) {
71         allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75  
76     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77         return allowed[_owner][_spender];
78     }
79  
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82 }
83  
84 contract KWHToken is StandardToken, SafeMath {
85  
86     // metadata
87     string  public constant name = "German New Energy Development Ecological Pass";
88     string  public constant symbol = "KWH";
89     uint256 public constant decimals = 18;
90     string  public version = "1.0";
91  
92     // contracts
93     address public ethFundDeposit;
94     address public newContractAddr;
95  
96     // crowdsale parameters
97     bool    public isFunding;
98     uint256 public fundingStartBlock;
99     uint256 public fundingStopBlock;
100  
101     uint256 public currentSupply;
102     uint256 public tokenRaised = 0;
103     uint256 public tokenMigrated = 0;
104     uint256 public tokenExchangeRate = 3000; // 3000 KWH 兑换 1 ETH
105  
106     // events
107     event AllocateToken(address indexed _to, uint256 _value);
108     event IssueToken(address indexed _to, uint256 _value);
109     event IncreaseSupply(uint256 _value);
110     event DecreaseSupply(uint256 _value);
111     event Migrate(address indexed _to, uint256 _value);
112  
113     // 转换
114     function formatDecimals(uint256 _value) internal returns (uint256 ) {
115         return _value * 10 ** decimals;
116     }
117  
118     // constructor
119     function KWHToken(
120         address _ethFundDeposit,
121         uint256 _currentSupply)
122     {
123         ethFundDeposit = _ethFundDeposit;
124  
125         isFunding = false;
126         fundingStartBlock = 0;
127         fundingStopBlock = 0;
128  
129         currentSupply = formatDecimals(_currentSupply);
130         totalSupply = formatDecimals(200000000);
131         balances[msg.sender] = totalSupply;
132         if(currentSupply > totalSupply) throw;
133     }
134  
135     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
136  
137     ///  设置token汇率
138     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
139         if (_tokenExchangeRate == 0) throw;
140         if (_tokenExchangeRate == tokenExchangeRate) throw;
141  
142         tokenExchangeRate = _tokenExchangeRate;
143     }
144  
145     ///  超发token处理
146     function increaseSupply (uint256 _value) isOwner external {
147         uint256 value = formatDecimals(_value);
148         if (value + currentSupply > totalSupply) throw;
149         currentSupply = safeAdd(currentSupply, value);
150         IncreaseSupply(value);
151     }
152  
153     ///  被盗token处理
154     function decreaseSupply (uint256 _value) isOwner external {
155         uint256 value = formatDecimals(_value);
156         if (value + tokenRaised > currentSupply) throw;
157  
158         currentSupply = safeSubtract(currentSupply, value);
159         DecreaseSupply(value);
160     }
161  
162     ///  启动区块检测 异常的处理
163     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
164         if (isFunding) throw;
165         if (_fundingStartBlock >= _fundingStopBlock) throw;
166         if (block.number >= _fundingStartBlock) throw;
167  
168         fundingStartBlock = _fundingStartBlock;
169         fundingStopBlock = _fundingStopBlock;
170         isFunding = true;
171     }
172  
173     ///  关闭区块异常处理
174     function stopFunding() isOwner external {
175         if (!isFunding) throw;
176         isFunding = false;
177     }
178  
179     /// 开发了一个新的合同来接收token（或者更新token）
180     function setMigrateContract(address _newContractAddr) isOwner external {
181         if (_newContractAddr == newContractAddr) throw;
182         newContractAddr = _newContractAddr;
183     }
184  
185     /// 设置新的所有者地址
186     function changeOwner(address _newFundDeposit) isOwner() external {
187         if (_newFundDeposit == address(0x0)) throw;
188         ethFundDeposit = _newFundDeposit;
189     }
190  
191     ///转移token到新的合约
192     function migrate() external {
193         if(isFunding) throw;
194         if(newContractAddr == address(0x0)) throw;
195  
196         uint256 tokens = balances[msg.sender];
197         if (tokens == 0) throw;
198  
199         balances[msg.sender] = 0;
200         tokenMigrated = safeAdd(tokenMigrated, tokens);
201  
202         IMigrationContract newContract = IMigrationContract(newContractAddr);
203         if (!newContract.migrate(msg.sender, tokens)) throw;
204  
205         Migrate(msg.sender, tokens);               // log it
206     }
207  
208     /// 转账ETH 到KWH团队
209     function transferETH() isOwner external {
210         if (this.balance == 0) throw;
211         if (!ethFundDeposit.send(this.balance)) throw;
212     }
213  
214     ///  将KWH分配到预处理地址。
215     function allocateToken (address _addr, uint256 _eth) isOwner external {
216         if (_eth == 0) throw;
217         if (_addr == address(0x0)) throw;
218  
219         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
220         if (tokens + tokenRaised > currentSupply) throw;
221  
222         tokenRaised = safeAdd(tokenRaised, tokens);
223         balances[_addr] += tokens;
224  
225         AllocateToken(_addr, tokens);  // 记录token日志
226     }
227  
228     /// 购买token
229     function () payable {
230         if (!isFunding) throw;
231         if (msg.value == 0) throw;
232  
233         if (block.number < fundingStartBlock) throw;
234         if (block.number > fundingStopBlock) throw;
235  
236         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
237         if (tokens + tokenRaised > currentSupply) throw;
238  
239         tokenRaised = safeAdd(tokenRaised, tokens);
240         balances[msg.sender] += tokens;
241  
242         IssueToken(msg.sender, tokens);  //记录日志
243     }
244 }