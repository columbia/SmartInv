1 pragma solidity ^0.4.10;
2 
3 // Inspiration from other ICO's are used in this contract!
4 // Please contact me when there are critical errors, thanks!
5 
6 contract ForeignToken {
7     function balanceOf(address _owner) constant returns (uint256);
8     function transfer(address _to, uint256 _value) returns (bool);
9 }
10 
11 contract CosmosToken {
12     address owner = msg.sender;
13     bool public purchasingAllowed = false;
14 
15     mapping (address => uint256) balances;
16     mapping (address => mapping (address => uint256)) allowed;
17 
18     uint256 public totalContribution = 0;
19     uint256 public totalSupply = 0;
20 
21     function name() constant returns (string) { return "CosmosToken"; }
22     function symbol() constant returns (string) { return "CST"; }
23     function decimals() constant returns (uint8) { return 18; }
24 
25     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
26 
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         if(msg.data.length < (2 * 32) + 4) { throw; }
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
46         if(msg.data.length < (3 * 32) + 4) { throw; }
47         if (_value == 0) { return false; }
48 
49         uint256 fromBalance = balances[_from];
50         uint256 allowance = allowed[_from][msg.sender];
51 
52         bool sufficientFunds = fromBalance <= _value;
53         bool sufficientAllowance = allowance <= _value;
54         bool overflowed = balances[_to] + _value > balances[_to];
55 
56         if (sufficientFunds && sufficientAllowance && !overflowed) {
57             balances[_to] += _value;
58             balances[_from] -= _value;
59 
60             allowed[_from][msg.sender] -= _value;
61 
62             Transfer(_from, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function approve(address _spender, uint256 _value) returns (bool success) {
68         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
69 
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72 
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) constant returns (uint256) {
77         return allowed[_owner][_spender];
78     }
79 
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82 
83     function enablePurchasing() {
84         if (msg.sender != owner) { throw; }
85         purchasingAllowed = true;
86     }
87 
88     function disablePurchasing() {
89         if (msg.sender != owner) { throw; }
90         purchasingAllowed = false;
91     }
92 
93     function withdrawForeignTokens(address _tokenContract) returns (bool) {
94         if (msg.sender != owner) { throw; }
95 
96         ForeignToken token = ForeignToken(_tokenContract);
97 
98         uint256 amount = token.balanceOf(address(this));
99         return token.transfer(owner, amount);
100     }
101 
102     function getStats() constant returns (uint256, uint256, bool) {
103         return (totalContribution, totalSupply, purchasingAllowed);
104     }
105 
106     function() payable {
107         if (!purchasingAllowed) { throw; }
108 
109         if (msg.value == 0) { return; }
110 
111         owner.transfer(msg.value);
112         totalContribution += msg.value;
113 
114         uint256 tokensIssued = (msg.value * 1000);
115 
116         totalSupply += tokensIssued;
117         balances[msg.sender] += tokensIssued;
118 
119         Transfer(address(this), msg.sender, tokensIssued);
120     }
121 }