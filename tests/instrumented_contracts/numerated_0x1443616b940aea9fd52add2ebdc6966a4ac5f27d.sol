1 contract ForeignToken {
2     function balanceOf(address _owner) constant returns (uint256);
3     function transfer(address _to, uint256 _value) returns (bool);
4 }
5 
6 contract UselessEthereumToken2 {
7     address owner = msg.sender;
8 
9     bool public purchasingAllowed = false;
10 
11     mapping (address => uint256) balances;
12     mapping (address => mapping (address => uint256)) allowed;
13 
14     uint256 public totalContribution = 0;
15     uint256 public totalBonusTokensIssued = 0;
16 
17     uint256 public totalSupply = 0;
18 
19     function name() constant returns (string) { return "Useless Ethereum Token 2"; }
20     function symbol() constant returns (string) { return "UET2"; }
21     function decimals() constant returns (uint8) { return 18; }
22     
23     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
24     
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         // mitigates the ERC20 short address attack
27         if(msg.data.length < (2 * 32) + 4) { throw; }
28 
29         if (_value == 0) { return false; }
30 
31         uint256 fromBalance = balances[msg.sender];
32 
33         bool sufficientFunds = fromBalance >= _value;
34         bool overflowed = balances[_to] + _value < balances[_to];
35         
36         if (sufficientFunds && !overflowed) {
37             balances[msg.sender] -= _value;
38             balances[_to] += _value;
39             
40             Transfer(msg.sender, _to, _value);
41             return true;
42         } else { return false; }
43     }
44     
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
46         // mitigates the ERC20 short address attack
47         if(msg.data.length < (3 * 32) + 4) { throw; }
48 
49         if (_value == 0) { return false; }
50         
51         uint256 fromBalance = balances[_from];
52         uint256 allowance = allowed[_from][msg.sender];
53 
54         bool sufficientFunds = fromBalance <= _value;
55         bool sufficientAllowance = allowance <= _value;
56         bool overflowed = balances[_to] + _value > balances[_to];
57 
58         if (sufficientFunds && sufficientAllowance && !overflowed) {
59             balances[_to] += _value;
60             balances[_from] -= _value;
61             
62             allowed[_from][msg.sender] -= _value;
63             
64             Transfer(_from, _to, _value);
65             return true;
66         } else { return false; }
67     }
68     
69     function approve(address _spender, uint256 _value) returns (bool success) {
70         // mitigates the ERC20 spend/approval race condition
71         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
72         
73         allowed[msg.sender][_spender] = _value;
74         
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78     
79     function allowance(address _owner, address _spender) constant returns (uint256) {
80         return allowed[_owner][_spender];
81     }
82 
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 
86     function enablePurchasing() {
87         if (msg.sender != owner) { throw; }
88 
89         purchasingAllowed = true;
90     }
91 
92     function disablePurchasing() {
93         if (msg.sender != owner) { throw; }
94 
95         purchasingAllowed = false;
96     }
97 
98     function withdrawForeignTokens(address _tokenContract) returns (bool) {
99         if (msg.sender != owner) { throw; }
100 
101         ForeignToken token = ForeignToken(_tokenContract);
102 
103         uint256 amount = token.balanceOf(address(this));
104         return token.transfer(owner, amount);
105     }
106 
107     function getStats() constant returns (uint256, uint256, uint256, bool) {
108         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
109     }
110 
111     function() payable {
112         if (!purchasingAllowed) { throw; }
113         
114         if (msg.value == 0) { return; }
115 
116         owner.transfer(msg.value);
117         totalContribution += msg.value;
118 
119         uint256 tokensIssued = (msg.value * 100);
120 
121         if (msg.value >= 10 finney) {
122             tokensIssued += totalContribution;
123 
124             bytes20 bonusHash = ripemd160(block.coinbase, block.number, block.timestamp);
125             if (bonusHash[1] == 0) {
126                 uint8 bonusMultiplier =
127                     ((bonusHash[2] & 0x01 != 0) ? 1 : 0) + ((bonusHash[2] & 0x02 != 0) ? 1 : 0) +
128                     ((bonusHash[2] & 0x04 != 0) ? 1 : 0) + ((bonusHash[2] & 0x08 != 0) ? 1 : 0) +
129                     ((bonusHash[2] & 0x10 != 0) ? 1 : 0) + ((bonusHash[2] & 0x20 != 0) ? 1 : 0) +
130                     ((bonusHash[2] & 0x40 != 0) ? 1 : 0) + ((bonusHash[2] & 0x80 != 0) ? 1 : 0);
131                 
132                 uint256 bonusTokensIssued = (msg.value * 100) * bonusMultiplier;
133                 tokensIssued += bonusTokensIssued;
134 
135                 totalBonusTokensIssued += bonusTokensIssued;
136             }
137         }
138 
139         totalSupply += tokensIssued;
140         balances[msg.sender] += tokensIssued;
141         
142         Transfer(address(this), msg.sender, tokensIssued);
143     }
144 }