1 pragma solidity ^0.4.13;
2 
3 contract PRSToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract PRSTokenICO {
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
20     function name() constant returns (string) { return "PRS Token"; }
21     function symbol() constant returns (string) { return "PRST"; }
22     function decimals() constant returns (uint8) { return 18; }
23     
24     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
25     
26     function transfer(address _to, uint256 _value) returns (bool success) {
27         // mitigates the ERC20 short address attack
28         if(msg.data.length < (2 * 32) + 4) { revert(); }
29 
30         if (_value == 0) { return false; }
31 
32         uint256 fromBalance = balances[msg.sender];
33 
34         bool sufficientFunds = fromBalance >= _value;
35         bool overflowed = balances[_to] + _value < balances[_to];
36         
37         if (sufficientFunds && !overflowed) {
38             balances[msg.sender] -= _value;
39             balances[_to] += _value;
40             
41             Transfer(msg.sender, _to, _value);
42             return true;
43         } else { return false; }
44     }
45     
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
47         // mitigates the ERC20 short address attack
48         if(msg.data.length < (3 * 32) + 4) { revert(); }
49 
50         if (_value == 0) { return false; }
51         
52         uint256 fromBalance = balances[_from];
53         uint256 allowance = allowed[_from][msg.sender];
54 
55         bool sufficientFunds = fromBalance <= _value;
56         bool sufficientAllowance = allowance <= _value;
57         bool overflowed = balances[_to] + _value > balances[_to];
58 
59         if (sufficientFunds && sufficientAllowance && !overflowed) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             
63             allowed[_from][msg.sender] -= _value;
64             
65             Transfer(_from, _to, _value);
66             return true;
67         } else { return false; }
68     }
69     
70     function approve(address _spender, uint256 _value) returns (bool success) {
71         // mitigates the ERC20 spend/approval race condition
72         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
73         
74         allowed[msg.sender][_spender] = _value;
75         
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79     
80     function allowance(address _owner, address _spender) constant returns (uint256) {
81         return allowed[_owner][_spender];
82     }
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 
87     function enablePurchasing() {
88         if (msg.sender != owner) { revert(); }
89 
90         purchasingAllowed = true;
91     }
92 
93     function disablePurchasing() {
94         if (msg.sender != owner) { revert(); }
95 
96         purchasingAllowed = false;
97     }
98 
99     function withdrawForeignTokens(address _tokenContract) returns (bool) {
100         if (msg.sender != owner) { revert(); }
101 
102         PRSToken token = PRSToken(_tokenContract);
103 
104         uint256 amount = token.balanceOf(address(this));
105         return token.transfer(owner, amount);
106     }
107 
108     function getStats() constant returns (uint256, uint256, bool) {
109         return (totalContribution, totalSupply, purchasingAllowed);
110     }
111 
112     function() payable {
113         if (!purchasingAllowed) { revert(); }
114         
115         if (msg.value == 0) { return; }
116 
117         owner.transfer(msg.value);
118         totalContribution += msg.value;
119 
120         uint256 tokensIssued = (msg.value * 100);
121 
122         if (msg.value >= 10 finney) {
123             tokensIssued += totalContribution;
124 
125         }
126 
127         totalSupply += tokensIssued;
128         balances[msg.sender] += tokensIssued;
129         
130         Transfer(address(this), msg.sender, tokensIssued);
131     }
132 }