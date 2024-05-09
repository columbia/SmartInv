1 pragma solidity ^0.4.10;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract PhilcoinToken {
9 
10     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
11       uint256 z = x + y;
12       assert((z >= x) && (z >= y));
13       return z;
14     }
15 
16     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
17       assert(x >= y);
18       uint256 z = x - y;
19       return z;
20     }
21 
22     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
23       uint256 z = x * y;
24       assert((x == 0)||(z/x == y));
25       return z;
26     }
27 
28     address owner = msg.sender;
29 
30     bool public purchasingAllowed = false;
31 
32     mapping (address => uint256) balances;
33     mapping (address => mapping (address => uint256)) allowed;
34 
35     uint256 public totalContribution = 0;
36     uint256 public totalBonusTokensIssued = 0;
37     uint256 public constant tokenCreationCap =  500000000000000000000000000;
38     uint256 public constant tokenExchangeRate = 280;
39     uint256 public totalSupply = 0;
40     uint256 public tokenRemainCap = 0;
41 
42 
43     function name() constant returns (string) { return "Philcoin Token"; }
44     function symbol() constant returns (string) { return "PHT"; }
45     function decimals() constant returns (uint8) { return 18; }
46     
47     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
48     
49     function transfer(address _to, uint256 _value) returns (bool success) {
50 
51         if (_value == 0) { return false; }
52 
53         uint256 fromBalance = balances[msg.sender];
54 
55         bool sufficientFunds = fromBalance >= _value;
56         bool overflowed = balances[_to] + _value < balances[_to];
57         
58         if (sufficientFunds && !overflowed) {
59             balances[msg.sender] -= _value;
60             balances[_to] += _value;
61             
62             Transfer(msg.sender, _to, _value);
63             return true;
64         } else { return false; }
65     }
66     
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68 
69         if (_value == 0) { return false; }
70         
71         uint256 fromBalance = balances[_from];
72         uint256 allowance = allowed[_from][msg.sender];
73 
74         bool sufficientFunds = fromBalance <= _value;
75         bool sufficientAllowance = allowance <= _value;
76         bool overflowed = balances[_to] + _value > balances[_to];
77 
78         if (sufficientFunds && sufficientAllowance && !overflowed) {
79             balances[_to] += _value;
80             balances[_from] -= _value;
81             
82             allowed[_from][msg.sender] -= _value;
83             
84             Transfer(_from, _to, _value);
85             return true;
86         } else { return false; }
87     }
88     
89     function approve(address _spender, uint256 _value) returns (bool success) {
90 
91         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
92         
93         allowed[msg.sender][_spender] = _value;
94         
95         Approval(msg.sender, _spender, _value);
96         return true;
97     }
98     
99     function allowance(address _owner, address _spender) constant returns (uint256) {
100         return allowed[_owner][_spender];
101     }
102 
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105 
106     function enablePurchasing() {
107         require (msg.sender != owner) ;
108 
109         purchasingAllowed = true;
110     }
111 
112     function disablePurchasing() {
113         require (msg.sender != owner) ;
114         purchasingAllowed = false;
115     }
116 
117     function withdrawForeignTokens(address _tokenContract) returns (bool) {
118         require (msg.sender != owner) ;
119 
120         ForeignToken token = ForeignToken(_tokenContract);
121 
122         uint256 amount = token.balanceOf(address(this));
123         return token.transfer(owner, amount);
124     }
125 
126     function getStats() constant returns (uint256, uint256, uint256, uint256, bool) {
127         return (totalContribution, totalSupply, tokenCreationCap, tokenRemainCap, purchasingAllowed);
128     }
129 
130     function() payable {
131         require (!purchasingAllowed) ;
132         
133         if (msg.value == 0) { return; }
134 
135         owner.transfer(msg.value);
136         totalContribution += msg.value;
137         require (totalSupply < tokenCreationCap);
138         uint256 tokensIssued = safeMult(msg.value, tokenExchangeRate);
139 
140         totalSupply += tokensIssued;
141         balances[msg.sender] += tokensIssued;
142         
143         Transfer(address(this), msg.sender, tokensIssued);
144         tokenRemainCap = safeSubtract(tokenCreationCap, totalSupply);
145     }
146 }