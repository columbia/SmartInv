1 pragma solidity ^0.4.10;
2 
3 // scamtoken
4 // completely original and not copy pasted contract
5 // prince of nigeria and major tunde send their regards
6 
7 contract CloneToken {
8     function balanceOf(address _owner) constant returns (uint256);
9     function transfer(address _to, uint256 _value) returns (bool);
10 }
11 
12 contract ScamToken {
13     address owner = msg.sender;
14 
15     bool public purchasingAllowed = false;
16 
17     mapping (address => uint256) balances;
18     mapping (address => mapping (address => uint256)) allowed;
19    // such code
20     uint256 public totalContribution = 0;
21     uint256 public totalBonusTokensIssued = 0;
22 
23     uint256 public totalSupply = 0;
24 
25     function name() constant returns (string) { return "ScamToken"; }
26     function symbol() constant returns (string) { return "SCAM"; }
27     function decimals() constant returns (uint8) { return 18; }
28     // much wow
29     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
30     
31     function transfer(address _to, uint256 _value) returns (bool success) {
32         // mitigates the ERC20 short address attack
33         if(msg.data.length < (2 * 32) + 4) { throw; }
34 
35         if (_value == 0) { return false; }
36 
37         uint256 fromBalance = balances[msg.sender];
38 
39         bool sufficientFunds = fromBalance >= _value;
40         bool overflowed = balances[_to] + _value < balances[_to];
41         
42         if (sufficientFunds && !overflowed) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45           
46           // so scam  
47             Transfer(msg.sender, _to, _value);
48             return true;
49         } else { return false; }
50     }
51     
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         // mitigates the ERC20 short address attack
54         if(msg.data.length < (3 * 32) + 4) { throw; }
55 
56         if (_value == 0) { return false; }
57         
58         uint256 fromBalance = balances[_from];
59         uint256 allowance = allowed[_from][msg.sender];
60         // my squanch is squanched
61         bool sufficientFunds = fromBalance <= _value;
62         bool sufficientAllowance = allowance <= _value;
63         bool overflowed = balances[_to] + _value > balances[_to];
64 
65         if (sufficientFunds && sufficientAllowance && !overflowed) {
66             balances[_to] += _value;
67             balances[_from] -= _value;
68             
69             allowed[_from][msg.sender] -= _value;
70             
71             Transfer(_from, _to, _value);
72             return true;
73         } else { return false; }
74     }
75     
76     function approve(address _spender, uint256 _value) returns (bool success) {
77         // mitigates the ERC20 spend/approval race condition
78         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
79         
80         allowed[msg.sender][_spender] = _value;
81         
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85     
86     // wut
87     function allowance(address _owner, address _spender) constant returns (uint256) {
88         return allowed[_owner][_spender];
89     }
90 
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 
94     function enablePurchasing() {
95         if (msg.sender != owner) { throw; }
96 
97         purchasingAllowed = true;
98     }
99 
100     function disablePurchasing() {
101         if (msg.sender != owner) { throw; }
102 
103         purchasingAllowed = false;
104     }
105 
106     function withdrawCloneTokens(address _tokenContract) returns (bool) {
107         if (msg.sender != owner) { throw; }
108 
109         CloneToken token = CloneToken(_tokenContract);
110 
111         uint256 amount = token.balanceOf(address(this));
112         return token.transfer(owner, amount);
113     }
114 
115     function getStats() constant returns (uint256, uint256, uint256, bool) {
116         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
117     }
118 
119     function() payable {
120         if (!purchasingAllowed) { throw; }
121         
122         if (msg.value == 0) { return; }
123 
124         owner.transfer(msg.value);
125         totalContribution += msg.value;
126 
127         uint256 tokensIssued = (msg.value * 100);
128 
129         if (msg.value >= 10 finney) {
130             tokensIssued += totalContribution;
131 
132             bytes20 bonusHash = ripemd160(block.coinbase, block.number, block.timestamp);
133             if (bonusHash[0] == 0) {
134 				// just deleted a bunch of shit lol hope it still works
135                 uint8 bonusMultiplier = 100;
136                 
137                 uint256 bonusTokensIssued = (msg.value * 100) * bonusMultiplier;
138                 tokensIssued += bonusTokensIssued;
139 
140                 totalBonusTokensIssued += bonusTokensIssued;
141             }
142         }
143 
144         totalSupply += tokensIssued;
145         balances[msg.sender] += tokensIssued;
146         
147         Transfer(address(this), msg.sender, tokensIssued);
148     }
149 }