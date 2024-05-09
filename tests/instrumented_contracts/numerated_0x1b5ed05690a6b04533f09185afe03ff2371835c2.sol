1 pragma solidity ^0.4.19;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract RainbowUnicoin {
9     address owner = msg.sender;
10 
11     bool public purchasingAllowed = true;
12 
13     mapping (address => uint256) balances;
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     uint256 public totalContribution = 0;
17     uint256 public totalBonusTokensIssued = 0;
18     uint256 public nextBonusPayout = 0;
19 
20     uint256 public totalSupply = 0;
21 
22     function name() constant returns (string) { return "Rainbow Unicoin"; }
23     function symbol() constant returns (string) { return "RUC"; }
24     function decimals() constant returns (uint8) { return 18; }
25     
26     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
27     
28     function transfer(address _to, uint256 _value) returns (bool success) {
29         // mitigates the ERC20 short address attack
30         if(msg.data.length < (2 * 32) + 4) { throw; }
31 
32         if (_value == 0) { return false; }
33 
34         uint256 fromBalance = balances[msg.sender];
35 
36         bool sufficientFunds = fromBalance >= _value;
37         bool overflowed = balances[_to] + _value < balances[_to];
38         
39         if (sufficientFunds && !overflowed) {
40             balances[msg.sender] -= _value;
41             balances[_to] += _value;
42             
43             Transfer(msg.sender, _to, _value);
44             return true;
45         } else { return false; }
46     }
47     
48     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
49         // mitigates the ERC20 short address attack
50         if(msg.data.length < (3 * 32) + 4) { throw; }
51 
52         if (_value == 0) { return false; }
53         
54         uint256 fromBalance = balances[_from];
55         uint256 allowance = allowed[_from][msg.sender];
56 
57         bool sufficientFunds = fromBalance <= _value;
58         bool sufficientAllowance = allowance <= _value;
59         bool overflowed = balances[_to] + _value > balances[_to];
60 
61         if (sufficientFunds && sufficientAllowance && !overflowed) {
62             balances[_to] += _value;
63             balances[_from] -= _value;
64             
65             allowed[_from][msg.sender] -= _value;
66             
67             Transfer(_from, _to, _value);
68             return true;
69         } else { return false; }
70     }
71     
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         // mitigates the ERC20 spend/approval race condition
74         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
75         
76         allowed[msg.sender][_spender] = _value;
77         
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81     
82     function allowance(address _owner, address _spender) constant returns (uint256) {
83         return allowed[_owner][_spender];
84     }
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88 
89     function enablePurchasing() {
90         if (msg.sender != owner) { throw; }
91 
92         purchasingAllowed = true;
93     }
94 
95     function disablePurchasing() {
96         if (msg.sender != owner) { throw; }
97 
98         purchasingAllowed = false;
99     }
100 
101     function withdrawForeignTokens(address _tokenContract) returns (bool) {
102         if (msg.sender != owner) { throw; }
103 
104         ForeignToken token = ForeignToken(_tokenContract);
105 
106         uint256 amount = token.balanceOf(address(this));
107         return token.transfer(owner, amount);
108     }
109 
110     function getStats() constant returns (uint256, uint256, uint256, bool) {
111         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
112     }
113 
114     function() payable {
115         if (!purchasingAllowed) { throw; }
116         
117         if (msg.value == 0) { return; }
118 
119         owner.transfer(msg.value);
120         totalContribution += msg.value;
121 
122         uint256 tokensIssued = (msg.value * 1000) + nextBonusPayout;
123         totalBonusTokensIssued += nextBonusPayout;
124         nextBonusPayout = tokensIssued / 2;
125 
126         totalSupply += tokensIssued;
127         balances[msg.sender] += tokensIssued;
128         
129         Transfer(address(this), msg.sender, tokensIssued);
130     }
131 }