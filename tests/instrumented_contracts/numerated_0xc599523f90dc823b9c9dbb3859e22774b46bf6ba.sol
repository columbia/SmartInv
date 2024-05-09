1 //DumbCoin
2 
3 pragma solidity ^0.4.18;
4 
5 contract ForeignToken {
6     function balanceOf(address _owner) constant returns (uint256);
7     function transfer(address _to, uint256 _value) returns (bool);
8 }
9 
10 contract DumbCoin {
11     address public owner;
12 
13     bool public purchasingAllowed = true;
14 
15     mapping (address => uint256) balances;
16     mapping (address => mapping (address => uint256)) allowed;
17 
18     uint256 public totalContribution = 0;
19     uint256 public totalTokensIssued = 0;
20     uint256 public totalBonusTokensIssued = 0;
21 
22     function name() public constant returns (string) { return "DumbCoin"; }
23     function symbol() public constant returns (string) { return "DUM"; }
24     function decimals() public constant returns (uint8) { return 18; }
25 
26     uint256 public totalSupply = 1000000 * (10 ** 18);
27     
28     function DumbCoin() {
29         owner = msg.sender;
30 
31         balances[owner] = totalSupply;
32         Transfer(0x0, owner, totalSupply);
33     }
34     
35     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
36     
37     function transfer(address _to, uint256 _value) returns (bool success) {
38         // mitigates the ERC20 short address attack
39         if(msg.data.length < (2 * 32) + 4) { throw; }
40 
41         if (_value == 0) { return false; }
42 
43         uint256 fromBalance = balances[msg.sender];
44 
45         bool sufficientFunds = fromBalance >= _value;
46         bool overflowed = balances[_to] + _value < balances[_to];
47         
48         if (sufficientFunds && !overflowed) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else { return false; }
55     }
56     
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         // mitigates the ERC20 short address attack
59         if(msg.data.length < (3 * 32) + 4) { throw; }
60 
61         if (_value == 0) { return false; }
62         
63         uint256 fromBalance = balances[_from];
64         uint256 allowance = allowed[_from][msg.sender];
65 
66         bool sufficientFunds = fromBalance <= _value;
67         bool sufficientAllowance = allowance <= _value;
68         bool overflowed = balances[_to] + _value > balances[_to];
69 
70         if (sufficientFunds && sufficientAllowance && !overflowed) {
71             balances[_to] += _value;
72             balances[_from] -= _value;
73             
74             allowed[_from][msg.sender] -= _value;
75             
76             Transfer(_from, _to, _value);
77             return true;
78         } else { return false; }
79     }
80     
81     function approve(address _spender, uint256 _value) returns (bool success) {
82         // mitigates the ERC20 spend/approval race condition
83         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
84         
85         allowed[msg.sender][_spender] = _value;
86         
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90     
91     function allowance(address _owner, address _spender) constant returns (uint256) {
92         return allowed[_owner][_spender];
93     }
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 
98     function enablePurchasing() {
99         if (msg.sender != owner) { throw; }
100 
101         purchasingAllowed = true;
102     }
103 
104     function disablePurchasing() {
105         if (msg.sender != owner) { throw; }
106 
107         purchasingAllowed = false;
108     }
109 
110     function withdrawForeignTokens(address _tokenContract) returns (bool) {
111         if (msg.sender != owner) { throw; }
112 
113         ForeignToken token = ForeignToken(_tokenContract);
114 
115         uint256 amount = token.balanceOf(address(this));
116         return token.transfer(owner, amount);
117     }
118 
119     function getStats() constant returns (uint256, uint256, uint256, uint256, bool) {
120         return (totalContribution, totalSupply, totalTokensIssued, totalBonusTokensIssued, purchasingAllowed);
121     }
122 
123     function() payable {
124         if (!purchasingAllowed) { throw; }
125         
126         if (msg.value == 0) { return; }
127 
128         owner.transfer(msg.value);
129         totalContribution += msg.value;
130 
131         uint256 tokensIssued = (msg.value * 100);
132 
133         if (msg.value >= 10 finney) {
134             tokensIssued += totalContribution;
135 
136             uint256 bonusTokensIssued = 0;
137             
138             uint256 random_block = uint(block.blockhash(block.number-1))%100 + 1;
139             uint256 random_number = uint(block.blockhash(block.number-random_block))%100 + 1;
140 
141             // 70% Chance of a bonus
142             if (random_number <= 70) {
143                 uint256 random_block2 = uint(block.blockhash(block.number-5))%100 + 1;
144                 uint256 random_number2 = uint(block.blockhash(block.number-random_block2))%100 + 1;
145                 if (random_number2 <= 60) {
146                     // 10% BONUS
147                     bonusTokensIssued = tokensIssued / 10;
148                 } else if (random_number2 <= 80) {
149                     // 20% BONUS
150                     bonusTokensIssued = tokensIssued / 5;
151                 } else if (random_number2 <= 90) {
152                     // 50% BONUS
153                     bonusTokensIssued = tokensIssued / 2;
154                 } else if (random_number2 <= 96) {
155                     // 100% BONUS
156                     bonusTokensIssued = tokensIssued;
157                 } else if (random_number2 <= 99) {
158                     // 300% BONUS
159                     bonusTokensIssued = tokensIssued * 3;
160                 } else if (random_number2 == 100) {
161                     // 1000% BONUS
162                     bonusTokensIssued = tokensIssued * 10;
163                 }
164             }
165             tokensIssued += bonusTokensIssued;
166 
167             totalBonusTokensIssued += bonusTokensIssued;
168         }
169 
170         totalSupply += tokensIssued;
171         totalTokensIssued += tokensIssued;
172         balances[msg.sender] += tokensIssued;
173         
174         Transfer(address(this), msg.sender, tokensIssued);
175     }
176 }