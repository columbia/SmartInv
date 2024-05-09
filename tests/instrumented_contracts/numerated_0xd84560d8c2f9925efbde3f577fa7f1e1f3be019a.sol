1 pragma solidity ^0.4.24;
2 
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) public returns (bool success);
5 }
6 
7 /* 灵感来自于NAS  coin*/
8 contract SafeMath {
9     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
10         uint256 z = x + y;
11         assert((z >= x) && (z >= y));
12         return z;
13     }
14 
15     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
16         assert(x >= y);
17         uint256 z = x - y;
18         return z;
19     }
20 
21     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
22         uint256 z = x * y;
23         assert((x == 0)||(z/x == y));
24         return z;
25     }
26 
27 }
28 
29 contract Token {
30     uint256 public totalSupply;
31     function balanceOf(address _owner) public constant returns (uint256 balance);
32     function transfer(address _to, uint256 _value) public returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34     function approve(address _spender, uint256 _value) public returns (bool success);
35     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 
41 /*  ERC 20 token */
42 contract StandardToken is Token {
43 
44     function transfer(address _to, uint256 _value) public returns (bool success) {
45         if (balances[msg.sender] >= _value && _value > 0) {
46             balances[msg.sender] -= _value;
47             balances[_to] += _value;
48             emit Transfer(msg.sender, _to, _value);
49             return true;
50         } else {
51             return false;
52         }
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
56         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57             balances[_to] += _value;
58             balances[_from] -= _value;
59             allowed[_from][msg.sender] -= _value;
60             emit Transfer(_from, _to, _value);
61             return true;
62         } else {
63             return false;
64         }
65     }
66 
67     function balanceOf(address _owner) public constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     function approve(address _spender, uint256 _value) public returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         emit Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
78         return allowed[_owner][_spender];
79     }
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83 }
84 
85 contract YCOToken is StandardToken, SafeMath {
86     
87     // metadata
88     string  public constant name = "Yi Cloud";
89     string  public constant symbol = "YCO";
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
102     uint256 public currentSupply;           // 正在售卖中的tokens数量
103     uint256 public tokenRaised = 0;         // 总的售卖数量token
104     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
105     uint256 public tokenExchangeRate = 300;             // 代币兑换比例 N代币 兑换 1 ETH
106 
107     // events
108     event AllocateToken(address indexed _to, uint256 _value);   // allocate token for private sale;
109     event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;
110     event IncreaseSupply(uint256 _value);
111     event DecreaseSupply(uint256 _value);
112     event Migrate(address indexed _to, uint256 _value);
113 
114     // 转换
115     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
116         return _value * 10 ** decimals;
117     }
118 
119     // constructor
120     constructor(
121         address _ethFundDeposit,
122         uint256 _currentSupply) public
123     {
124         ethFundDeposit = _ethFundDeposit;
125 
126         isFunding = false;                           //通过控制预CrowdS ale状态
127         fundingStartBlock = 0;
128         fundingStopBlock = 0;
129 
130         currentSupply = formatDecimals(_currentSupply);
131         totalSupply = formatDecimals(2000000000);
132         balances[msg.sender] = totalSupply;
133         require(currentSupply <= totalSupply);
134     }
135 
136     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
137 
138     ///  设置token汇率
139     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
140         require(_tokenExchangeRate != 0);
141         require(_tokenExchangeRate != tokenExchangeRate);
142 
143         tokenExchangeRate = _tokenExchangeRate;
144     }
145 
146     ///增发代币
147     function increaseSupply (uint256 _value) isOwner external {
148         uint256 value = formatDecimals(_value);
149         require(value + currentSupply <= totalSupply);
150         currentSupply = safeAdd(currentSupply, value);
151         emit IncreaseSupply(value);
152     }
153 
154     ///减少代币
155     function decreaseSupply (uint256 _value) isOwner external {
156         uint256 value = formatDecimals(_value);
157         require(value + tokenRaised <= currentSupply);
158 
159         currentSupply = safeSubtract(currentSupply, value);
160         emit DecreaseSupply(value);
161     }
162 
163     ///开启
164     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
165         require(!isFunding);
166         require(_fundingStartBlock < _fundingStopBlock);
167         require(block.number < _fundingStartBlock);
168 
169         fundingStartBlock = _fundingStartBlock;
170         fundingStopBlock = _fundingStopBlock;
171         isFunding = true;
172     }
173 
174     ///关闭
175     function stopFunding() isOwner external {
176         require(isFunding);
177         isFunding = false;
178     }
179 
180     ///set a new contract for recieve the tokens (for update contract)
181     function setMigrateContract(address _newContractAddr) isOwner external {
182         require(_newContractAddr != newContractAddr);
183         newContractAddr = _newContractAddr;
184     }
185 
186     ///set a new owner.
187     function changeOwner(address _newFundDeposit) isOwner() external {
188         require(_newFundDeposit != address(0x0));
189         ethFundDeposit = _newFundDeposit;
190     }
191 
192     ///sends the tokens to new contract
193     function migrate() external {
194         require(!isFunding);
195         require(newContractAddr != address(0x0));
196 
197         uint256 tokens = balances[msg.sender];
198         require(tokens != 0);
199 
200         balances[msg.sender] = 0;
201         tokenMigrated = safeAdd(tokenMigrated, tokens);
202 
203         IMigrationContract newContract = IMigrationContract(newContractAddr);
204         require(newContract.migrate(msg.sender, tokens));
205 
206         emit Migrate(msg.sender, tokens);               // log it
207     }
208 
209     /// 转账ETH 到团队
210     function transferETH() isOwner external {
211         require(address(this).balance != 0);
212         require(ethFundDeposit.send(address(this).balance));
213     }
214 
215     ///  将token分配到预处理地址。
216     function allocateToken (address _addr, uint256 _eth) isOwner external {
217         require(_eth != 0);
218         require(_addr != address(0x0));
219 
220         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
221         require(tokens + tokenRaised <= currentSupply);
222 
223         tokenRaised = safeAdd(tokenRaised, tokens);
224         balances[_addr] += tokens;
225 
226         emit AllocateToken(_addr, tokens);  // 记录token日志
227     }
228 
229     /// 购买token 
230     function () public payable {
231         require(isFunding);
232         require(msg.value != 0);
233 
234         require(block.number >= fundingStartBlock);
235         require(block.number <= fundingStopBlock);
236 
237         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
238         require(tokens + tokenRaised <= currentSupply);
239 
240         tokenRaised = safeAdd(tokenRaised, tokens);
241         balances[msg.sender] += tokens;
242 
243         emit IssueToken(msg.sender, tokens);  //记录日志
244     }
245 }