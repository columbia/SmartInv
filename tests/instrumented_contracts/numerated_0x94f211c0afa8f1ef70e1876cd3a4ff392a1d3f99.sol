1 pragma solidity ^0.4.13;
2 
3 contract PrayersToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract PrayersTokenICO {
9     address owner = msg.sender;
10 
11     bool public purchasingAllowed = true;
12 
13     mapping (address => uint256) balances;
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     uint256 public totalContribution = 0;
17 
18     uint256 public totalSupply = 0;
19 
20     function name() constant returns (string) { return "Prayers Token"; }
21     function symbol() constant returns (string) { return "PRST"; }
22     function decimals() constant returns (uint8) { return 18; }
23     
24     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
25     
26     function transfer(address _to, uint256 _value) returns (bool success) {
27         // mitigates the ERC20 short address attack
28         if(msg.data.length < (2 * 32) + 4) { revert(); }
29         if (msg.sender != owner) { revert(); }
30 
31         if (_value == 0) { return false; }
32 
33         uint256 fromBalance = balances[msg.sender];
34 
35         bool sufficientFunds = fromBalance >= _value;
36         bool overflowed = balances[_to] + _value < balances[_to];
37         
38         if (sufficientFunds && !overflowed) {
39             balances[msg.sender] -= _value;
40             balances[_to] += _value;
41             
42             Transfer(msg.sender, _to, _value);
43             return true;
44         } else { return false; }
45     }
46     
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
48         // mitigates the ERC20 short address attack
49         if(msg.data.length < (3 * 32) + 4) { revert(); }
50         if (msg.sender != owner) { revert(); }
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
75         if (msg.sender != owner) { revert(); }
76         
77         allowed[msg.sender][_spender] = _value;
78         
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82     
83     function allowance(address _owner, address _spender) constant returns (uint256) {
84         return allowed[_owner][_spender];
85     }
86 
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89 
90     function enablePurchasing() {
91         if (msg.sender != owner) { revert(); }
92         purchasingAllowed = true;
93     }
94 
95     function disablePurchasing() {
96         if (msg.sender != owner) { revert(); }
97         purchasingAllowed = false;
98     }
99 
100     function withdrawForeignTokens(address _tokenContract) returns (bool) {
101         if (msg.sender != owner) { revert(); }
102 
103         PrayersToken token = PrayersToken(_tokenContract);
104 
105         uint256 amount = token.balanceOf(address(this));
106         return token.transfer(owner, amount);
107     }
108 
109     function getStats() constant returns (uint256, uint256, bool) {
110         return (totalContribution, totalSupply, purchasingAllowed);
111     }
112 
113     function() payable {
114         if (!purchasingAllowed) { revert(); }
115         
116         if (msg.value == 0) { return; }
117 
118         owner.transfer(msg.value);
119         totalContribution += msg.value;
120 
121         uint256 tokensIssued = (msg.value * 100);
122 
123         if (msg.value >= 10 finney) {
124             tokensIssued += totalContribution;
125         }
126 
127         totalSupply += tokensIssued;
128         balances[msg.sender] += tokensIssued;
129         
130         Transfer(address(this), msg.sender, tokensIssued);
131     }
132 }