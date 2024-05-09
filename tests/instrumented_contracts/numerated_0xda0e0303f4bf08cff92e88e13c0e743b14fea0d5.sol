1 pragma solidity ^0.4.17;
2 
3 /* taking ideas from FirstBlood token */
4 contract SafeMath {
5 
6     /* function assert(bool assertion) internal { */
7     /*   if (!assertion) { */
8     /*     throw; */
9     /*   } */
10     /* }      // assert no longer needed once solidity is on 0.4.10 */
11 
12     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
13       uint256 z = x + y;
14       assert((z >= x) && (z >= y));
15       return z;
16     }
17 
18     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
19       assert(x >= y);
20       uint256 z = x - y;
21       return z;
22     }
23 
24     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
25       uint256 z = x * y;
26       assert((x == 0)||(z/x == y));
27       return z;
28     }
29 
30 }
31 
32 contract Token {
33     uint256 public totalSupply;
34     function balanceOf(address _owner) constant returns (uint256 balance);
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
46 
47     function transfer(address _to, uint256 _value) returns (bool success) {
48       if (balances[msg.sender] >= _value && _value > 0) {
49         balances[msg.sender] -= _value;
50         balances[_to] += _value;
51         Transfer(msg.sender, _to, _value);
52         return true;
53       } else {
54         return false;
55       }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60         balances[_to] += _value;
61         balances[_from] -= _value;
62         allowed[_from][msg.sender] -= _value;
63         Transfer(_from, _to, _value);
64         return true;
65       } else {
66         return false;
67       }
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
81       return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86 }
87 
88 contract MOERToken is StandardToken, SafeMath {
89 
90     // metadata
91     string public constant name = "Moer Digital Assets Platform";
92     string public constant symbol = "MOER";
93     uint256 public constant decimals = 18;
94     string public version = "1.0";
95 
96     // contracts
97     address public owner;                                             // owner's address for MOER Team.
98 
99     // MOER parameters
100     uint256 public currentSupply = 0;                                 // current supply tokens for sell
101     uint256 public constant totalFund = 2 * (10**9) * 10**decimals;   // 2 billion MOER totally issued.
102     
103     // crowdsale parameters
104     bool    public isFunding;                // switched to true in operational state
105     uint256 public fundingStartBlock;
106     uint256 public fundingStopBlock;
107     uint256 public tokenExchangeRate = 12000;             // 12000 MOER tokens per 1 ETH
108     uint256 public totalFundingAmount = (10**8) * 10**decimals; // 100 million for crowdsale
109     uint256 public currentFundingAmount = 0;
110 
111     // constructor
112     function MOERToken(
113         address _owner)
114     {
115         owner = _owner;
116         
117         isFunding = false;
118         fundingStartBlock = 0;
119         fundingStopBlock = 0;
120         
121         totalSupply = totalFund;
122     }
123 
124     /// @dev Throws if called by any account other than the owner.
125     modifier onlyOwner() {
126       require(msg.sender == owner);
127       _;
128     }
129 
130     /// @dev increase MOER's current supply
131     function increaseSupply (uint256 _value, address _to) onlyOwner external {
132         if (_value + currentSupply > totalSupply) throw;
133         currentSupply = safeAdd(currentSupply, _value);
134         balances[_to] = safeAdd(balances[_to], _value);
135         Transfer(address(0x0), _to, _value);
136     }
137 
138     /// @dev change owner
139     function changeOwner(address _newOwner) onlyOwner external {
140         if (_newOwner == address(0x0)) throw;
141         owner = _newOwner;
142     }
143     
144     /// @dev set the token's tokenExchangeRate,
145     function setTokenExchangeRate(uint256 _tokenExchangeRate) onlyOwner external {
146         if (_tokenExchangeRate == 0) throw;
147         if (_tokenExchangeRate == tokenExchangeRate) throw;
148 
149         tokenExchangeRate = _tokenExchangeRate;
150     }    
151     
152     /// @dev set the token's totalFundingAmount,
153     function setFundingAmount(uint256 _totalFundingAmount) onlyOwner external {
154         if (_totalFundingAmount == 0) throw;
155         if (_totalFundingAmount == totalFundingAmount) throw;
156         if (_totalFundingAmount - currentFundingAmount + currentSupply > totalSupply) throw;
157 
158         totalFundingAmount = _totalFundingAmount;
159     }    
160     
161     /// @dev sends ETH to MOER team
162     function transferETH() onlyOwner external {
163         if (this.balance == 0) throw;
164         if (!owner.send(this.balance)) throw;
165     }    
166     
167     /// @dev turn on the funding state
168     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) onlyOwner external {
169         if (isFunding) throw;
170         if (_fundingStartBlock >= _fundingStopBlock) throw;
171         if (block.number >= _fundingStartBlock) throw;
172 
173         fundingStartBlock = _fundingStartBlock;
174         fundingStopBlock = _fundingStopBlock;
175         isFunding = true;
176     }
177 
178     /// @dev turn off the funding state
179     function stopFunding() onlyOwner external {
180         if (!isFunding) throw;
181         isFunding = false;
182     }    
183     
184     /// buys the tokens
185     function () payable {
186         if (!isFunding) throw;
187         if (msg.value == 0) throw;
188 
189         if (block.number < fundingStartBlock) throw;
190         if (block.number > fundingStopBlock) throw;
191 
192         uint256 tokens = safeMult(msg.value, tokenExchangeRate);
193         if (tokens + currentFundingAmount > totalFundingAmount) throw;
194 
195         currentFundingAmount = safeAdd(currentFundingAmount, tokens);
196         currentSupply = safeAdd(currentSupply, tokens);
197         balances[msg.sender] += tokens;
198 
199         Transfer(address(0x0), msg.sender, tokens);
200     }    
201 }