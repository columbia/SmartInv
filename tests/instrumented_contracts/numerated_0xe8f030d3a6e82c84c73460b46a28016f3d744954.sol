1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) public returns (bool success);
5 }
6 
7 contract SafeMath {
8 
9 
10     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
11         uint256 z = x + y;
12         assert((z >= x) && (z >= y));
13         return z;
14     }
15 
16     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
17         assert(x >= y);
18         uint256 z = x - y;
19         return z;
20     }
21 
22     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
23         uint256 z = x * y;
24         assert((x == 0)||(z/x == y));
25         return z;
26     }
27 
28     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
29         assert(y > 0);
30         uint256 z = x / y;
31         assert(x == y * z + x % y);
32         return z;
33     }
34 
35 }
36 
37 contract Token {
38     uint256 public totalSupply;
39     function balanceOf(address _owner) public view returns (uint256 balance);
40     function transfer(address _to, uint256 _value) public returns (bool success);
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42     function approve(address _spender, uint256 _value) public returns (bool success);
43     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 
49 /*  ERC 20 token */
50 contract StandardToken is SafeMath, Token {
51 
52     function transfer(address _to, uint256 _value) public returns (bool success) {
53         require(_to != address(0));
54         require(_value <= balances[msg.sender]);
55 
56         balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
57         balances[_to] = safeAdd(balances[_to], _value);
58         emit Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         require(_from != address(0));
64         require(_to != address(0));
65         require(_value <= balances[_from]);
66         require(_value > 0);
67         require(allowed[_from][msg.sender] >= _value);
68 
69         balances[_from] = safeSubtract(balances[_from], _value);
70         allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
71         balances[_to] = safeAdd(balances[_to], _value);
72         emit Transfer(_from, _to, _value);
73         return true;
74     }
75 
76     function balanceOf(address _owner) public view returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint256 _value) public returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         emit Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
87         return allowed[_owner][_spender];
88     }
89 
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92 }
93 
94 contract GENEToken is StandardToken {
95     // metadata
96     string  public constant name = "GENE";
97     string  public constant symbol = "GE";
98     uint8   public constant decimals = 18;
99     string  public version = "1.0";
100 
101     // contracts
102     address payable public ethFundDeposit;  // ETH存放地址
103     address public newContractAddr;         // token更新地址
104 
105     // crowdsale parameters
106     bool    public isFunding;                // 状态切换到true
107     uint256 public fundingStartBlock;
108     uint256 public fundingStopBlock;
109 
110     uint256 public currentSupply;           // 正在售卖中的tokens数量
111     uint256 public tokenRaised = 0;         // 总的售卖数量token
112     uint256 public tokenMigrated = 0;       // 总的已经交易的 token
113     uint256 public tokenExchangeRate = 1;             // 1 GE 兑换 1 ETH
114 
115     // events
116     event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;
117     event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;
118     event IncreaseSupply(uint256 _value);
119     event DecreaseSupply(uint256 _value);
120     event Migrate(address indexed _to, uint256 _value);
121 
122     // 转换
123     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
124         return _value * 10 ** uint256(decimals);
125     }
126 
127     // constructor
128     constructor(address payable _ethFundDeposit, uint256 _currentSupply) public{
129         ethFundDeposit = _ethFundDeposit;
130 
131         isFunding = false;                           // 通过控制预CrowdS ale状态
132         fundingStartBlock = 0;
133         fundingStopBlock = 0;
134 
135         currentSupply = formatDecimals(_currentSupply);
136         totalSupply = formatDecimals(1000000000);
137         balances[msg.sender] = totalSupply;
138         require(currentSupply <= totalSupply);
139     }
140 
141     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
142 
143     /// 设置token汇率
144     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
145         require(_tokenExchangeRate != 0);
146         require(_tokenExchangeRate != tokenExchangeRate);
147 
148         tokenExchangeRate = _tokenExchangeRate;
149     }
150 
151     /// @dev 超发token处理
152     function increaseSupply (uint256 _value) isOwner external {
153         uint256 value = formatDecimals(_value);
154         require(value + currentSupply <= totalSupply);
155         currentSupply = safeAdd(currentSupply, value);
156         emit IncreaseSupply(value);
157     }
158 
159     /// @dev 被盗token处理
160     function decreaseSupply (uint256 _value) isOwner external {
161         uint256 value = formatDecimals(_value);
162         require(value + tokenRaised <= currentSupply);
163 
164         currentSupply = safeSubtract(currentSupply, value);
165         emit DecreaseSupply(value);
166     }
167 
168     /// 启动区块检测 异常的处理
169     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
170         require(!isFunding);
171         require(_fundingStartBlock < _fundingStopBlock);
172         require(block.number < _fundingStartBlock);
173 
174         fundingStartBlock = _fundingStartBlock;
175         fundingStopBlock = _fundingStopBlock;
176         isFunding = true;
177     }
178 
179     /// 关闭区块异常处理
180     function stopFunding() isOwner external {
181         require(isFunding);
182         isFunding = false;
183     }
184 
185     /// 开发了一个新的合同来接收token（或者更新token）
186     function setMigrateContract(address _newContractAddr) isOwner external {
187         require(_newContractAddr != newContractAddr);
188         newContractAddr = _newContractAddr;
189     }
190 
191     /// 设置新的所有者地址
192     function changeOwner(address payable _newFundDeposit) isOwner external {
193         require(_newFundDeposit != address(0x0));
194         ethFundDeposit = _newFundDeposit;
195     }
196 
197     /// 转移token到新的合约
198     function migrate() external {
199         require(!isFunding);
200         require(newContractAddr != address(0x0));
201 
202         uint256 tokens = balances[msg.sender];
203         require(tokens != 0);
204 
205         balances[msg.sender] = 0;
206         tokenMigrated = safeAdd(tokenMigrated, tokens);
207 
208         IMigrationContract newContract = IMigrationContract(newContractAddr);
209         require(newContract.migrate(msg.sender, tokens));
210 
211         emit Migrate(msg.sender, tokens);               // log it
212     }
213 
214     /// 转账ETH 到 GE 团队
215     function transferETH() isOwner external {
216         require(address(this).balance != 0);
217         require(ethFundDeposit.send(address(this).balance));
218     }
219 
220     /// 将GE token分配到预处理地址。
221     function allocateToken (address _addr, uint256 _eth) isOwner external {
222         require(_eth != 0);
223         require(_addr != address(0x0));
224         require(isFunding);
225 
226         uint256 tokens = safeDiv(formatDecimals(_eth), tokenExchangeRate);
227         require(tokens + tokenRaised <= currentSupply);
228 
229         tokenRaised = safeAdd(tokenRaised, tokens);
230         balances[_addr] = safeAdd(balances[_addr], tokens);
231         balances[msg.sender] = safeSubtract(balances[msg.sender], tokens);
232 
233         emit AllocateToken(_addr, tokens); // 记录token日志
234     }
235 
236     /// 购买token
237     function () external payable {
238         require(isFunding);
239         require(msg.value != 0);
240 
241         require(block.number >= fundingStartBlock);
242         require(block.number <= fundingStopBlock);
243 
244         uint256 tokens = safeDiv(msg.value, tokenExchangeRate);
245         require(tokens + tokenRaised <= currentSupply);
246 
247         tokenRaised = safeAdd(tokenRaised, tokens);
248         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
249         balances[ethFundDeposit] = safeSubtract(balances[ethFundDeposit], tokens);
250 
251         emit IssueToken(msg.sender, tokens); //记录日志
252     }
253 }