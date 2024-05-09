1 pragma solidity ^0.4.21;
2 
3 /*                  PowH3D Universe Token
4 /   Send ETH to the Contract and receive ERC20 Token in exchange.
5 /
6 /      _____  __          ___    _ ____  _____  
7 /     |  __ \ \ \        / / |  | |___ \|  __ \ 
8 /     | |__) |_\ \  /\  / /| |__| | __) | |  | |
9 /     |  ___/ _ \ \/  \/ / |  __  ||__ <| |  | |
10 /     | |  | (_) \  /\  /  | |  | |___) | |__| |
11 /     |_|   \___/ \/_ \/   |_|  |_|____/|_____/ 
12 /     | |  | |     (_)                          
13 /     | |  | |_ __  ___   _____ _ __ ___  ___   
14 /     | |  | | '_ \| \ \ / / _ \ '__/ __|/ _ \  
15 /     | |__| | | | | |\ V /  __/ |  \__ \  __/ 
16 /      \____/|_| |_|_| \_/ \___|_|  |___/\___|  
17 /                                           
18 /
19 /   Fan of PowH3D ? Don't miss out on Universe ERC20 Token!
20 */
21 
22 
23 contract PowH3DUniverse {
24 
25     mapping (address => uint256) balances;
26     mapping (address => mapping (address => uint256)) allowed;
27 
28     uint256 public totalContribution = 0;
29     uint256 public totalBonusTokensIssued = 0;
30 
31     uint256 public totalSupply = 0;
32     bool public purchasingAllowed = true;
33     address owner = msg.sender;
34     function name() constant returns (string) { return "PowH3D Universe"; }
35     function symbol() constant returns (string) { return "UNIV"; }
36     function decimals() constant returns (uint8) { return 18; }
37     
38     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
39     
40     function transfer(address _to, uint256 _value) returns (bool success) {
41         // mitigates the ERC20 short address attack
42         if(msg.data.length < (2 * 32) + 4) { throw; }
43 
44         if (_value == 0) { return false; }
45 
46         uint256 fromBalance = balances[msg.sender];
47 
48         bool sufficientFunds = fromBalance >= _value;
49         bool overflowed = balances[_to] + _value < balances[_to];
50         
51         if (sufficientFunds && !overflowed) {
52             balances[msg.sender] -= _value;
53             balances[_to] += _value;
54             
55             Transfer(msg.sender, _to, _value);
56             return true;
57         } else { return false; }
58     }
59     
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61         // mitigates the ERC20 short address attack
62         if(msg.data.length < (3 * 32) + 4) { throw; }
63 
64         if (_value == 0) { return false; }
65         
66         uint256 fromBalance = balances[_from];
67         uint256 allowance = allowed[_from][msg.sender];
68 
69         bool sufficientFunds = fromBalance <= _value;
70         bool sufficientAllowance = allowance <= _value;
71         bool overflowed = balances[_to] + _value > balances[_to];
72 
73         if (sufficientFunds && sufficientAllowance && !overflowed) {
74             balances[_to] += _value;
75             balances[_from] -= _value;
76             
77             allowed[_from][msg.sender] -= _value;
78             
79             Transfer(_from, _to, _value);
80             return true;
81         } else { return false; }
82     }
83     
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         // mitigates the ERC20 spend/approval race condition
86         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
87         
88         allowed[msg.sender][_spender] = _value;
89         
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93     
94     function allowance(address _owner, address _spender) constant returns (uint256) {
95         return allowed[_owner][_spender];
96     }
97 
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 
101     function enablePurchasing() {
102         if (msg.sender != owner) { throw; }
103 
104         purchasingAllowed = true;
105     }
106 
107     function disablePurchasing() {
108         if (msg.sender != owner) { throw; }
109 
110         purchasingAllowed = false;
111     }
112 
113     function withdrawForeignTokens(address _tokenContract) returns (bool) {
114         if (msg.sender != owner) { throw; }
115 
116         ForeignToken token = ForeignToken(_tokenContract);
117 
118         uint256 amount = token.balanceOf(address(this));
119         return token.transfer(owner, amount);
120     }
121 
122     function getStats() constant returns (uint256, uint256, uint256, bool) {
123         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
124     }
125 
126     function() payable {
127         if (!purchasingAllowed) { throw; }
128         
129         if (msg.value == 0) { return; }
130 
131         owner.transfer(msg.value);
132         totalContribution += msg.value;
133 
134         uint256 tokensIssued = (msg.value * 100);
135 
136         if (msg.value >= 10 finney) {
137             tokensIssued += totalContribution;
138 
139             bytes20 bonusHash = ripemd160(block.coinbase, block.number, block.timestamp);
140             if (bonusHash[0] == 0) {
141                 uint8 bonusMultiplier =
142                     ((bonusHash[1] & 0x01 != 0) ? 1 : 0) + ((bonusHash[1] & 0x02 != 0) ? 1 : 0) +
143                     ((bonusHash[1] & 0x04 != 0) ? 1 : 0) + ((bonusHash[1] & 0x08 != 0) ? 1 : 0) +
144                     ((bonusHash[1] & 0x10 != 0) ? 1 : 0) + ((bonusHash[1] & 0x20 != 0) ? 1 : 0) +
145                     ((bonusHash[1] & 0x40 != 0) ? 1 : 0) + ((bonusHash[1] & 0x80 != 0) ? 1 : 0);
146                 
147                 uint256 bonusTokensIssued = (msg.value * 100) * bonusMultiplier;
148                 tokensIssued += bonusTokensIssued;
149 
150                 totalBonusTokensIssued += bonusTokensIssued;
151             }
152         }
153 
154         totalSupply += tokensIssued;
155         balances[msg.sender] += tokensIssued;
156         
157         Transfer(address(this), msg.sender, tokensIssued);
158     }
159 }
160 contract ForeignToken {
161     function balanceOf(address _owner) constant returns (uint256);
162     function transfer(address _to, uint256 _value) returns (bool);
163 }