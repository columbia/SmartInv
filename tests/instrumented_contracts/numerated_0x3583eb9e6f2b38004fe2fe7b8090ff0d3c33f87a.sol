1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-16
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 contract IMigrationContract {
8     function migrate(address addr, uint256 nas) public returns (bool success);
9 }
10 
11 /* 灵感来自于NAS  coin*/
12 contract SafeMath {
13     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
14         uint256 z = x + y;
15         assert((z >= x) && (z >= y));
16         return z;
17     }
18 
19     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
20         assert(x >= y);
21         uint256 z = x - y;
22         return z;
23     }
24 
25     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
26         uint256 z = x * y;
27         assert((x == 0)||(z/x == y));
28         return z;
29     }
30 
31 }
32 
33 contract Token {
34     uint256 public totalSupply;
35     function balanceOf(address _owner) public constant returns (uint256 balance);
36     function transfer(address _to, uint256 _value) public returns (bool success);
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
38     function approve(address _spender, uint256 _value) public returns (bool success);
39     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 
45 /*  ERC 20 token */
46 contract StandardToken is Token {
47 
48     function transfer(address _to, uint256 _value) public returns (bool success) {
49         if (balances[msg.sender] >= _value && _value > 0) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             emit Transfer(msg.sender, _to, _value);
53             return true;
54         } else {
55             return false;
56         }
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
60         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
61             balances[_to] += _value;
62             balances[_from] -= _value;
63             allowed[_from][msg.sender] -= _value;
64             emit Transfer(_from, _to, _value);
65             return true;
66         } else {
67             return false;
68         }
69     }
70 
71     function balanceOf(address _owner) public constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender, uint256 _value) public returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
82         return allowed[_owner][_spender];
83     }
84 
85     mapping (address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87 }
88 
89 contract YCOToken is StandardToken, SafeMath {
90     
91     // metadata
92     string  public constant name = "Yi cloud";
93     string  public constant symbol = "YCO";
94     uint256 public constant decimals = 8;
95     string  public version = "1.0";
96 
97     // contracts
98     address public ethFundDeposit;          // ETH存放地址
99     address public newContractAddr;         // token更新地址
100 
101     // crowdsale parameters
102     bool    public isFunding;                // 状态切换到true
103     uint256 public fundingStartBlock;
104     uint256 public fundingStopBlock;
105 
106     uint256 public currentSupply;           // 正在售卖中的tokens数量
107     uint256 public tokenRaised = 0;         // 总的售卖数量token
108     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
109     uint256 public tokenExchangeRate = 300;             // 代币兑换比例 N代币 兑换 1 ETH
110 
111     // events
112     event AllocateToken(address indexed _to, uint256 _value);   // allocate token for private sale;
113     event IssueToken(address indexed _to, uint256 _value);      // issue token for public sale;
114     event IncreaseSupply(uint256 _value);
115     event DecreaseSupply(uint256 _value);
116     event Migrate(address indexed _to, uint256 _value);
117 
118     // 转换
119     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
120         return _value * 10 ** decimals;
121     }
122 
123     // constructor
124     constructor(
125         address _ethFundDeposit,
126         uint256 _currentSupply) public
127     {
128         ethFundDeposit = _ethFundDeposit;
129 
130         isFunding = false;                           //通过控制预CrowdS ale状态
131         fundingStartBlock = 0;
132         fundingStopBlock = 0;
133 
134         currentSupply = formatDecimals(_currentSupply);
135         totalSupply = formatDecimals(2000000000);
136         balances[msg.sender] = totalSupply;
137         require(currentSupply <= totalSupply);
138     }
139 
140     modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }
141 
142     ///  设置token汇率
143     function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
144         require(_tokenExchangeRate != 0);
145         require(_tokenExchangeRate != tokenExchangeRate);
146 
147         tokenExchangeRate = _tokenExchangeRate;
148     }
149 
150 
151     ///开启
152     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
153         require(!isFunding);
154         require(_fundingStartBlock < _fundingStopBlock);
155         require(block.number < _fundingStartBlock);
156 
157         fundingStartBlock = _fundingStartBlock;
158         fundingStopBlock = _fundingStopBlock;
159         isFunding = true;
160     }
161 
162     ///关闭
163     function stopFunding() isOwner external {
164         require(isFunding);
165         isFunding = false;
166     }
167 
168     /// 转账ETH 到团队
169     function transferETH() isOwner external {
170         require(address(this).balance != 0);
171         require(ethFundDeposit.send(address(this).balance));
172     }
173 
174     ///  将token分配到预处理地址。
175     function allocateToken (address _addr, uint256 _eth) isOwner external {
176         require(_eth != 0);
177         require(_addr != address(0x0));
178 
179         uint256 tokens = safeMult(formatDecimals(_eth), tokenExchangeRate);
180         require(tokens + tokenRaised <= currentSupply);
181 
182         tokenRaised = safeAdd(tokenRaised, tokens);
183         balances[_addr] += tokens;
184 
185         emit AllocateToken(_addr, tokens);  // 记录token日志
186     }
187 
188     /// 购买token 
189     function () public payable {
190         require(isFunding);
191         require(msg.value != 0);
192 
193         require(block.number >= fundingStartBlock);
194         require(block.number <= fundingStopBlock);
195 
196         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
197         require(tokens + tokenRaised <= currentSupply);
198 
199         tokenRaised = safeAdd(tokenRaised, tokens);
200         balances[msg.sender] += tokens;
201 
202         emit IssueToken(msg.sender, tokens);  //记录日志
203     }
204 }