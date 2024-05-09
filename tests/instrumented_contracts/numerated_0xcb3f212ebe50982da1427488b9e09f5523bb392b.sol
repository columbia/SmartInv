1 pragma solidity ^0.4.24;
2 
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) public returns (bool success);
5 }
6 
7 contract SafeMath {
8     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
9         uint256 z = x + y;
10         assert((z >= x) && (z >= y));
11         return z;
12     }
13 
14     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
15         assert(x >= y);
16         uint256 z = x - y;
17         return z;
18     }
19 
20     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
21         uint256 z = x * y;
22         assert((x == 0)||(z/x == y));
23         return z;
24     }
25 
26 }
27 
28 contract Token {
29     uint256 public totalSupply;
30     function balanceOf(address _owner) public constant returns (uint256 balance);
31     function transfer(address _to, uint256 _value) public returns (bool success);
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33     function approve(address _spender, uint256 _value) public returns (bool success);
34     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 
40 /*  ERC 20 token */
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) public returns (bool success) {
44         if (balances[msg.sender] >= _value && _value > 0) {
45             balances[msg.sender] -= _value;
46             balances[_to] += _value;
47             emit Transfer(msg.sender, _to, _value);
48             return true;
49         } else {
50             return false;
51         }
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
56             balances[_to] += _value;
57             balances[_from] -= _value;
58             allowed[_from][msg.sender] -= _value;
59             emit Transfer(_from, _to, _value);
60             return true;
61         } else {
62             return false;
63         }
64     }
65 
66     function balanceOf(address _owner) public constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     function approve(address _spender, uint256 _value) public returns (bool success) {
71         allowed[msg.sender][_spender] = _value;
72         emit Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
77         return allowed[_owner][_spender];
78     }
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82 }
83 
84 contract LBXToken is StandardToken, SafeMath {
85 
86     // metadata
87     string  public constant name = "链博星";
88     string  public constant symbol = "LBX";
89     uint256 public constant decimals = 18;
90     string  public version = "1.0";
91 
92     // contracts
93     address public ethFundDeposit;          // ETH存放地址
94     address public newContractAddr;         // token更新地址
95 
96     // crowdsale parameters
97     bool    public isFunding;                // 状态切换到true
98     uint256 public fundingStartBlock;
99     uint256 public fundingStopBlock;
100 
101     uint256 public currentSupply;           // 正在售卖中的tokens数量
102     uint256 public tokenRaised = 0;         // 总的售卖数量token
103     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
104     uint256 public tokenExchangeRate = 300;             // 代币兑换比例 N代币 兑换 1 ETH
105 
106     // events
107     event AllocateToken(address indexed _to, uint256 _value);   // allocate token for private sale;
108     event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;
109     event IncreaseSupply(uint256 _value);
110     event DecreaseSupply(uint256 _value);
111     event Migrate(address indexed _to, uint256 _value);
112 
113     // 转换
114     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
115         return _value * 10 ** decimals;
116     }
117 
118     // constructor
119     constructor(
120         address _ethFundDeposit,
121         uint256 _currentSupply) public
122     {
123         ethFundDeposit = _ethFundDeposit;
124 
125         isFunding = false;                           //通过控制预CrowdS ale状态
126         fundingStartBlock = 0;
127         fundingStopBlock = 0;
128 
129         currentSupply = formatDecimals(_currentSupply);
130         totalSupply = formatDecimals(1000000000);
131         balances[msg.sender] = totalSupply;
132         require(currentSupply <= totalSupply);
133     }
134 
135     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
136 
137     ///  设置token汇率
138     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
139         require(_tokenExchangeRate != 0);
140         require(_tokenExchangeRate != tokenExchangeRate);
141 
142         tokenExchangeRate = _tokenExchangeRate;
143     }
144 
145     ///增发代币
146     function increaseSupply (uint256 _value) isOwner external {
147         uint256 value = formatDecimals(_value);
148         require(value + currentSupply <= totalSupply);
149         currentSupply = safeAdd(currentSupply, value);
150         emit IncreaseSupply(value);
151     }
152 
153     ///减少代币
154     function decreaseSupply (uint256 _value) isOwner external {
155         uint256 value = formatDecimals(_value);
156         require(value + tokenRaised <= currentSupply);
157 
158         currentSupply = safeSubtract(currentSupply, value);
159         emit DecreaseSupply(value);
160     }
161 
162     ///开启
163     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
164         require(!isFunding);
165         require(_fundingStartBlock < _fundingStopBlock);
166         require(block.number < _fundingStartBlock);
167 
168         fundingStartBlock = _fundingStartBlock;
169         fundingStopBlock = _fundingStopBlock;
170         isFunding = true;
171     }
172 
173     ///关闭
174     function stopFunding() isOwner external {
175         require(isFunding);
176         isFunding = false;
177     }
178 
179     ///set a new contract for recieve the tokens (for update contract)
180     function setMigrateContract(address _newContractAddr) isOwner external {
181         require(_newContractAddr != newContractAddr);
182         newContractAddr = _newContractAddr;
183     }
184 
185     ///set a new owner.
186     function changeOwner(address _newFundDeposit) isOwner() external {
187         require(_newFundDeposit != address(0x0));
188         ethFundDeposit = _newFundDeposit;
189     }
190 
191     ///sends the tokens to new contract
192     function migrate() external {
193         require(!isFunding);
194         require(newContractAddr != address(0x0));
195 
196         uint256 tokens = balances[msg.sender];
197         require(tokens != 0);
198 
199         balances[msg.sender] = 0;
200         tokenMigrated = safeAdd(tokenMigrated, tokens);
201 
202         IMigrationContract newContract = IMigrationContract(newContractAddr);
203         require(newContract.migrate(msg.sender, tokens));
204 
205         emit Migrate(msg.sender, tokens);               // log it
206     }
207 
208     /// 转账ETH 到团队
209     function transferETH() isOwner external {
210         require(address(this).balance != 0);
211         require(ethFundDeposit.send(address(this).balance));
212     }
213 
214     ///  将token分配到预处理地址。
215     function allocateToken (address _addr, uint256 _eth) isOwner external {
216         require(_eth != 0);
217         require(_addr != address(0x0));
218 
219         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
220         require(tokens + tokenRaised <= currentSupply);
221 
222         tokenRaised = safeAdd(tokenRaised, tokens);
223         balances[_addr] += tokens;
224 
225         emit AllocateToken(_addr, tokens);  // 记录token日志
226     }
227 
228     /// 购买token
229     function () public payable {
230         require(isFunding);
231         require(msg.value != 0);
232 
233         require(block.number >= fundingStartBlock);
234         require(block.number <= fundingStopBlock);
235 
236         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
237         require(tokens + tokenRaised <= currentSupply);
238 
239         tokenRaised = safeAdd(tokenRaised, tokens);
240         balances[msg.sender] += tokens;
241 
242         emit IssueToken(msg.sender, tokens);  //记录日志
243     }
244 }