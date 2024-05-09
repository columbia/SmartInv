1 pragma solidity ^0.4.14;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 
9 
10 
11 
12 contract DoneToken {
13     
14     address owner = msg.sender;
15  
16  
17     bool public purchasingAllowed = false;
18 
19     mapping (address => uint256) balances;
20     mapping (address => mapping (address => uint256)) allowed;
21 
22     uint256 public totalContribution = 0;
23 
24     uint256 public totalSupply = 0;
25 
26     uint256 constant September1 = 1504274400; //2 PM GMT 9/1/2017
27     uint256 constant August25 = 1503669600; //2 PM GMT 8/25/2017
28     uint256 constant testtime = 1502003216; //20 minutes
29 
30     function name() constant returns (string) { return "Donation Efficiency Token"; }
31     function symbol() constant returns (string) { return "DONE"; }
32     function decimals() constant returns (uint8) { return 16; }
33     
34     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
35     
36     function transfer(address _to, uint256 _value) returns (bool success) {
37         if(msg.data.length < (2 * 32) + 4) { throw; }
38 
39         if (_value == 0) { return false; }
40 
41         uint256 fromBalance = balances[msg.sender];
42 
43         bool sufficientFunds = fromBalance >= _value;
44         bool overflowed = balances[_to] + _value < balances[_to];
45         
46         if (sufficientFunds && !overflowed) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else { return false; }
53     }
54     
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         if(msg.data.length < (3 * 32) + 4) { throw; }
57 
58         if (_value == 0) { return false; }
59         
60         uint256 fromBalance = balances[_from];
61         uint256 allowance = allowed[_from][msg.sender];
62 
63         bool sufficientFunds = fromBalance <= _value;
64         bool sufficientAllowance = allowance <= _value;
65         bool overflowed = balances[_to] + _value > balances[_to];
66 
67         if (sufficientFunds && sufficientAllowance && !overflowed) {
68             balances[_to] += _value;
69             balances[_from] -= _value;
70             
71             allowed[_from][msg.sender] -= _value;
72             
73             Transfer(_from, _to, _value);
74             return true;
75         } else { return false; }
76     }
77     
78     function approve(address _spender, uint256 _value) returns (bool success) {
79         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
80         
81         allowed[msg.sender][_spender] = _value;
82         
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86     
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
97         if (totalContribution > 1000000000000000000000) {throw;} //purchasing cannot be re-enabled
98                                   
99         purchasingAllowed = true;
100     }
101 
102     function disablePurchasing() {
103         if (msg.sender != owner) { throw; }
104 
105         purchasingAllowed = false;
106     }
107 
108    
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
119     function getStats() constant returns (uint256, uint256, bool) {
120         return (totalContribution, totalSupply, purchasingAllowed);
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
131         if (block.timestamp > August25){
132         
133         uint256 tokensIssued = (msg.value * 5);
134         }
135         else tokensIssued = (msg.value * 10);
136         
137         totalSupply += tokensIssued;
138         balances[msg.sender] += tokensIssued;
139         
140         Transfer(address(this), msg.sender, tokensIssued);
141     }
142 }